<script lang="ts">
	let { children, name, value, submitOnChange = false } = $props();
	let key = $derived(`${name}_${value}`);

	let input = $state<HTMLInputElement>();

	const onchange = () => {
		if (submitOnChange) {
			input?.form?.requestSubmit();
		}
	};
</script>

<div class="relative flex cursor-pointer items-center gap-2">
	<input
		type="checkbox"
		id={key}
		{value}
		{name}
		class="border-accent peer size-6 cursor-pointer appearance-none rounded-md border-1 bg-white"
		{onchange}
		bind:this={input}
	/>
	<svg
		xmlns="http://www.w3.org/2000/svg"
		fill="none"
		viewBox="0 0 24 24"
		stroke-width="1.5"
		stroke="currentColor"
		class="text-accent pointer-events-none absolute hidden size-6 peer-checked:block"
	>
		<path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
	</svg>

	<label for={key} class="cursor-pointer">{@render children()}</label>
</div>
