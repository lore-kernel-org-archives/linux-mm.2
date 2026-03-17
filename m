Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D864EFEDA1A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDAD6B0088; Tue, 17 Mar 2026 16:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E875A6B008A; Tue, 17 Mar 2026 16:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D766A6B008C; Tue, 17 Mar 2026 16:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BEECC6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:09:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1234C1603A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:09:09 +0000 (UTC)
X-FDA: 84556644018.13.52829B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D3102000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:09:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfRe+mjD;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773778147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TkukskCJ/Pz4m9xWNfzjgsORJyN1cMMSsuE0kdmlWug=;
	b=6LQjqeo24AKeAtP0zq5tnsDqJk+zIZFJcYCjVL+fwdrTgVQJjrjlYWE4+qH9jDx+zKNXMk
	dv2c5ziMZbRbzOkWlU70lIXY82Uiia+egPu8CrYzIWE+TP9NS8SOn7gNxDP3KX7X5GxKaV
	ZCoGdwcrhLtHNcuUKc8hFlXMEwycqCs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YfRe+mjD;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773778147; a=rsa-sha256;
	cv=none;
	b=sB9O0OwtwiHyep7vZ+cBxPhN6WyRPxvzMcnLWfw/Oq+IFhvJuBJlyURcAjMAcs5NmRRPAD
	oaPmh0NTNVmzR3mwppEReUJXx8lwjJxt0LnOF2bFQuLnXUQXqZvNkX4Z4gS+l0Ec8m6A/v
	HmIScRyOHEJ7BBvJNPj7bs80aRN7chw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81FAE60018;
	Tue, 17 Mar 2026 20:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39585C4CEF7;
	Tue, 17 Mar 2026 20:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773778146;
	bh=GXmKngRGvWAuIH9ekA+sVq7FF03kIC0fozu+H57QGgI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YfRe+mjDJx/MA9kia17cAbF1Y7Yr3BzWq1O4SnKPaRs4VEFn54MlkKqZ+gPFw95Z4
	 PyvPYySV7HCh9woLFXqkMkLRsD9/O+vU+eeH4z6SzxkglhqtLacu8eHdjax2ZilOAT
	 mn29ERxlSE9paospmlBqqzJ/Kq4qBmRh7HuZRUA4X8D2kmf1I3Mm8W168T++/Y49Rs
	 Hm2OlJsQW8mWjlRUt378hJq6i59R6hRNGHLPor5Oc6eja3l1yeIYTuZ1lFVgZgbnI2
	 36BgxACQNl1bhw5xOYCGw+avgQZ2aEUOckW7EdRO5Fzrsnnk7m8rHr2EmSC0hkQl+d
	 3ZLkavQCEblCg==
Date: Tue, 17 Mar 2026 20:09:03 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 14/14] mm/sparse: move memory hotplug bits to
 sparse-vmemmap.c
Message-ID: <c880bda9-486c-41ab-b8f2-f0329392bbf6@lucifer.local>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-15-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-15-david@kernel.org>
X-Rspamd-Queue-Id: 7D3102000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 95ystb4mkfxtqrxkqgtopug4j6an68wf
X-Rspam-User: 
X-HE-Tag: 1773778147-806825
X-HE-Meta: U2FsdGVkX1/U7JaZo/pTrXs6gjgx3FHm7lEWJb8L5D64HjizFzE/6xFoW9ZU2EgtTPaLa/0oX/j6N1T2gOPTAfayVy+bduXC9hcL0jx6QJ71TAhqH5Gci7RFmj/qFfT+S+UL9sxeu1pH3MkiEtx30x+nend/UnpkLcg9JMfkSTaGhU8n+JlkJ8TB3nHnFP9PkgjTzIj0HuEQdNQHQI37elHDdRdMgoNNf7iHMyCO7I6LxTzk0Id0ZQup+CF6bw5I1cLO/gO5FmQwyDwCN2scUJ5O9ItN0A7n/N9ZkPyURQjSrbDfLgZ26z1o49E7RNRlvOfBoQKhCWhOGnYqKtlLjOw8vVdnJcGtkC77zvhXsnoawP7V3j4axgS6Hu9gWFUb6bKT35hAZdNJSqsOi/faicKlP6EnIZH21BMhhFm8NvvhF9fjF3c/Hl2CEOixr5H7oig1vfE33cW/IsnmvJTM3IQYeq+RgLVaRiMI2p/anVPjy3wV+Um7Ym8R8v6+WA4HLoR17uxRp9jxHWGLiMd/6YpOzUImPUcxho/E2oaBHF3mNVAIU+NCeQ+2tDKSpDIDA3GPYkJVTT1edEGbETRX3CleKltLKY+2q5ilPL08EkT4NUXIBbIcOYJqCReaVuwfqC4y0iiKwh4bWlMzWSw5vA9BnFzVEXXBadKtqI7NQx0gXSznPvoYC22wz4ow40CrBEtYpjTOz38k9AJGUrpRQnWVyz6JBWYzeqSAZ9zoXfDZmTxhtgD/XPdncbXC1pTCcLvBQXy5Kzb2n4jJrd99t8EKI1GMjukLeyolx0bbRBHYcYc6TuIMqpDsO077BzfghX9SuFdBf8oAzDY147YnWxzZwiB7mAPqZlKDwDhG8gCqRGA1Uv8o1UDx7RgaE2ACvzLuJbrRFDCOH//BeYj/E4vgxzmqwKyxeXDSPCJrMRG0zVXDW3E0jCEMNIt6WMT206BO/Rn0ayTT/HAG8Vh
 ZfJo+Ebv
 LwbZjqzJgOpZUDVAt7rKc4yxutcjnenzRdBi2cWC51l3htY7gvNyKMibWpbv1c5FU5pxgUvVe0GB/Ef0r8eS1sN3Of6cxa+syqGeLDhhVRuhmvGGlheUuWpnYBTfJgOWP6G8ST0yiHIZKP2PapAuGISLSyOI78O1pvNczwVlpJYTOl6gVzZJbO2ZcoGc0xByB+gngCNRuuR3citVY7nZCIkZIga0LqhN1h2MdS9In/0Bt4N4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:52PM +0100, David Hildenbrand (Arm) wrote:
> Let's move all memory hoptplug related code to sparse-vmemmap.c.
>
> We only have to expose sparse_index_init(). While at it, drop the
> definition of sparse_index_init() for !CONFIG_SPARSEMEM, which is unused,
> and place the declaration in internal.h.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Looking through this it looks like it is just a code move modulo the other bits
you metion, overall very nice cleanup, so let me hotplug my:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Into this review!

OK I've actually cringed terribly at the puns here and maybe I'm cured for life
from doing that again ;)

Cheers, Lorenzo

> ---
>  include/linux/mmzone.h |   1 -
>  mm/internal.h          |   4 +
>  mm/sparse-vmemmap.c    | 308 ++++++++++++++++++++++++++++++++++++++++
>  mm/sparse.c            | 314 +----------------------------------------
>  4 files changed, 314 insertions(+), 313 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index dcbbf36ed88c..e11513f581eb 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2390,7 +2390,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
>  #endif
>
>  #else
> -#define sparse_index_init(_sec, _nid)  do {} while (0)
>  #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
>  #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
>  #define pfn_in_present_section pfn_valid
> diff --git a/mm/internal.h b/mm/internal.h
> index 835a6f00134e..b1a9e9312ffe 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -965,6 +965,7 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
>   */
>  #ifdef CONFIG_SPARSEMEM
>  void sparse_init(void);
> +int sparse_index_init(unsigned long section_nr, int nid);
>
>  static inline void sparse_init_one_section(struct mem_section *ms,
>  		unsigned long pnum, struct page *mem_map,
> @@ -1000,6 +1001,9 @@ static inline void __section_mark_present(struct mem_section *ms,
>  static inline void sparse_init(void) {}
>  #endif /* CONFIG_SPARSEMEM */
>
> +/*
> + * mm/sparse-vmemmap.c
> + */
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
>  void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
>  #else
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index f0690797667f..330579365a0f 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -591,3 +591,311 @@ void __init sparse_vmemmap_init_nid_late(int nid)
>  	hugetlb_vmemmap_init_late(nid);
>  }
>  #endif
> +
> +static void subsection_mask_set(unsigned long *map, unsigned long pfn,
> +		unsigned long nr_pages)
> +{
> +	int idx = subsection_map_index(pfn);
> +	int end = subsection_map_index(pfn + nr_pages - 1);
> +
> +	bitmap_set(map, idx, end - idx + 1);
> +}
> +
> +void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
> +{
> +	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
> +	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
> +
> +	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
> +		struct mem_section *ms;
> +		unsigned long pfns;
> +
> +		pfns = min(nr_pages, PAGES_PER_SECTION
> +				- (pfn & ~PAGE_SECTION_MASK));
> +		ms = __nr_to_section(nr);
> +		subsection_mask_set(ms->usage->subsection_map, pfn, pfns);
> +
> +		pr_debug("%s: sec: %lu pfns: %lu set(%d, %d)\n", __func__, nr,
> +				pfns, subsection_map_index(pfn),
> +				subsection_map_index(pfn + pfns - 1));
> +
> +		pfn += pfns;
> +		nr_pages -= pfns;
> +	}
> +}
> +
> +#ifdef CONFIG_MEMORY_HOTPLUG
> +
> +/* Mark all memory sections within the pfn range as online */
> +void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	unsigned long pfn;
> +
> +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		unsigned long section_nr = pfn_to_section_nr(pfn);
> +		struct mem_section *ms = __nr_to_section(section_nr);
> +
> +		ms->section_mem_map |= SECTION_IS_ONLINE;
> +	}
> +}
> +
> +/* Mark all memory sections within the pfn range as offline */
> +void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
> +{
> +	unsigned long pfn;
> +
> +	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +		unsigned long section_nr = pfn_to_section_nr(pfn);
> +		struct mem_section *ms = __nr_to_section(section_nr);
> +
> +		ms->section_mem_map &= ~SECTION_IS_ONLINE;
> +	}
> +}
> +
> +static struct page * __meminit populate_section_memmap(unsigned long pfn,
> +		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> +		struct dev_pagemap *pgmap)
> +{
> +	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> +}
> +
> +static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap)
> +{
> +	unsigned long start = (unsigned long) pfn_to_page(pfn);
> +	unsigned long end = start + nr_pages * sizeof(struct page);
> +
> +	vmemmap_free(start, end, altmap);
> +}
> +static void free_map_bootmem(struct page *memmap)
> +{
> +	unsigned long start = (unsigned long)memmap;
> +	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
> +
> +	vmemmap_free(start, end, NULL);
> +}
> +
> +static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
> +{
> +	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
> +	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
> +	struct mem_section *ms = __pfn_to_section(pfn);
> +	unsigned long *subsection_map = ms->usage
> +		? &ms->usage->subsection_map[0] : NULL;
> +
> +	subsection_mask_set(map, pfn, nr_pages);
> +	if (subsection_map)
> +		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
> +
> +	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
> +				"section already deactivated (%#lx + %ld)\n",
> +				pfn, nr_pages))
> +		return -EINVAL;
> +
> +	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
> +	return 0;
> +}
> +
> +static bool is_subsection_map_empty(struct mem_section *ms)
> +{
> +	return bitmap_empty(&ms->usage->subsection_map[0],
> +			    SUBSECTIONS_PER_SECTION);
> +}
> +
> +static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct mem_section *ms = __pfn_to_section(pfn);
> +	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
> +	unsigned long *subsection_map;
> +	int rc = 0;
> +
> +	subsection_mask_set(map, pfn, nr_pages);
> +
> +	subsection_map = &ms->usage->subsection_map[0];
> +
> +	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
> +		rc = -EINVAL;
> +	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
> +		rc = -EEXIST;
> +	else
> +		bitmap_or(subsection_map, map, subsection_map,
> +				SUBSECTIONS_PER_SECTION);
> +
> +	return rc;
> +}
> +
> +/*
> + * To deactivate a memory region, there are 3 cases to handle across
> + * two configurations (SPARSEMEM_VMEMMAP={y,n}):
> + *
> + * 1. deactivation of a partial hot-added section (only possible in
> + *    the SPARSEMEM_VMEMMAP=y case).
> + *      a) section was present at memory init.
> + *      b) section was hot-added post memory init.
> + * 2. deactivation of a complete hot-added section.
> + * 3. deactivation of a complete section from memory init.
> + *
> + * For 1, when subsection_map does not empty we will not be freeing the
> + * usage map, but still need to free the vmemmap range.
> + *
> + * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
> + */
> +static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap)
> +{
> +	struct mem_section *ms = __pfn_to_section(pfn);
> +	bool section_is_early = early_section(ms);
> +	struct page *memmap = NULL;
> +	bool empty;
> +
> +	if (clear_subsection_map(pfn, nr_pages))
> +		return;
> +
> +	empty = is_subsection_map_empty(ms);
> +	if (empty) {
> +		/*
> +		 * Mark the section invalid so that valid_section()
> +		 * return false. This prevents code from dereferencing
> +		 * ms->usage array.
> +		 */
> +		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
> +
> +		/*
> +		 * When removing an early section, the usage map is kept (as the
> +		 * usage maps of other sections fall into the same page). It
> +		 * will be re-used when re-adding the section - which is then no
> +		 * longer an early section. If the usage map is PageReserved, it
> +		 * was allocated during boot.
> +		 */
> +		if (!PageReserved(virt_to_page(ms->usage))) {
> +			kfree_rcu(ms->usage, rcu);
> +			WRITE_ONCE(ms->usage, NULL);
> +		}
> +		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
> +	}
> +
> +	/*
> +	 * The memmap of early sections is always fully populated. See
> +	 * section_activate() and pfn_valid() .
> +	 */
> +	if (!section_is_early) {
> +		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
> +		depopulate_section_memmap(pfn, nr_pages, altmap);
> +	} else if (memmap) {
> +		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
> +							  PAGE_SIZE)));
> +		free_map_bootmem(memmap);
> +	}
> +
> +	if (empty)
> +		ms->section_mem_map = (unsigned long)NULL;
> +}
> +
> +static struct page * __meminit section_activate(int nid, unsigned long pfn,
> +		unsigned long nr_pages, struct vmem_altmap *altmap,
> +		struct dev_pagemap *pgmap)
> +{
> +	struct mem_section *ms = __pfn_to_section(pfn);
> +	struct mem_section_usage *usage = NULL;
> +	struct page *memmap;
> +	int rc;
> +
> +	if (!ms->usage) {
> +		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
> +		if (!usage)
> +			return ERR_PTR(-ENOMEM);
> +		ms->usage = usage;
> +	}
> +
> +	rc = fill_subsection_map(pfn, nr_pages);
> +	if (rc) {
> +		if (usage)
> +			ms->usage = NULL;
> +		kfree(usage);
> +		return ERR_PTR(rc);
> +	}
> +
> +	/*
> +	 * The early init code does not consider partially populated
> +	 * initial sections, it simply assumes that memory will never be
> +	 * referenced.  If we hot-add memory into such a section then we
> +	 * do not need to populate the memmap and can simply reuse what
> +	 * is already there.
> +	 */
> +	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
> +		return pfn_to_page(pfn);
> +
> +	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> +	if (!memmap) {
> +		section_deactivate(pfn, nr_pages, altmap);
> +		return ERR_PTR(-ENOMEM);
> +	}
> +	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> +
> +	return memmap;
> +}
> +
> +/**
> + * sparse_add_section - add a memory section, or populate an existing one
> + * @nid: The node to add section on
> + * @start_pfn: start pfn of the memory range
> + * @nr_pages: number of pfns to add in the section
> + * @altmap: alternate pfns to allocate the memmap backing store
> + * @pgmap: alternate compound page geometry for devmap mappings
> + *
> + * This is only intended for hotplug.
> + *
> + * Note that only VMEMMAP supports sub-section aligned hotplug,
> + * the proper alignment and size are gated by check_pfn_span().
> + *
> + *
> + * Return:
> + * * 0		- On success.
> + * * -EEXIST	- Section has been present.
> + * * -ENOMEM	- Out of memory.
> + */
> +int __meminit sparse_add_section(int nid, unsigned long start_pfn,
> +		unsigned long nr_pages, struct vmem_altmap *altmap,
> +		struct dev_pagemap *pgmap)
> +{
> +	unsigned long section_nr = pfn_to_section_nr(start_pfn);
> +	struct mem_section *ms;
> +	struct page *memmap;
> +	int ret;
> +
> +	ret = sparse_index_init(section_nr, nid);
> +	if (ret < 0)
> +		return ret;
> +
> +	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
> +	if (IS_ERR(memmap))
> +		return PTR_ERR(memmap);
> +
> +	/*
> +	 * Poison uninitialized struct pages in order to catch invalid flags
> +	 * combinations.
> +	 */
> +	page_init_poison(memmap, sizeof(struct page) * nr_pages);
> +
> +	ms = __nr_to_section(section_nr);
> +	__section_mark_present(ms, section_nr);
> +
> +	/* Align memmap to section boundary in the subsection case */
> +	if (section_nr_to_pfn(section_nr) != start_pfn)
> +		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
> +	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
> +
> +	return 0;
> +}
> +
> +void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
> +			   struct vmem_altmap *altmap)
> +{
> +	struct mem_section *ms = __pfn_to_section(pfn);
> +
> +	if (WARN_ON_ONCE(!valid_section(ms)))
> +		return;
> +
> +	section_deactivate(pfn, nr_pages, altmap);
> +}
> +#endif /* CONFIG_MEMORY_HOTPLUG */
> diff --git a/mm/sparse.c b/mm/sparse.c
> index bf620f3fe05d..007fd52c621e 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -79,7 +79,7 @@ static noinline struct mem_section __ref *sparse_index_alloc(int nid)
>  	return section;
>  }
>
> -static int __meminit sparse_index_init(unsigned long section_nr, int nid)
> +int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  {
>  	unsigned long root = SECTION_NR_TO_ROOT(section_nr);
>  	struct mem_section *section;
> @@ -103,7 +103,7 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  	return 0;
>  }
>  #else /* !SPARSEMEM_EXTREME */
> -static inline int sparse_index_init(unsigned long section_nr, int nid)
> +int sparse_index_init(unsigned long section_nr, int nid)
>  {
>  	return 0;
>  }
> @@ -167,40 +167,6 @@ static inline unsigned long first_present_section_nr(void)
>  	return next_present_section_nr(-1);
>  }
>
> -#ifdef CONFIG_SPARSEMEM_VMEMMAP
> -static void subsection_mask_set(unsigned long *map, unsigned long pfn,
> -		unsigned long nr_pages)
> -{
> -	int idx = subsection_map_index(pfn);
> -	int end = subsection_map_index(pfn + nr_pages - 1);
> -
> -	bitmap_set(map, idx, end - idx + 1);
> -}
> -
> -void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
> -{
> -	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
> -	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
> -
> -	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
> -		struct mem_section *ms;
> -		unsigned long pfns;
> -
> -		pfns = min(nr_pages, PAGES_PER_SECTION
> -				- (pfn & ~PAGE_SECTION_MASK));
> -		ms = __nr_to_section(nr);
> -		subsection_mask_set(ms->usage->subsection_map, pfn, pfns);
> -
> -		pr_debug("%s: sec: %lu pfns: %lu set(%d, %d)\n", __func__, nr,
> -				pfns, subsection_map_index(pfn),
> -				subsection_map_index(pfn + pfns - 1));
> -
> -		pfn += pfns;
> -		nr_pages -= pfns;
> -	}
> -}
> -#endif
> -
>  /* Record a memory area against a node. */
>  static void __init memory_present(int nid, unsigned long start, unsigned long end)
>  {
> @@ -482,279 +448,3 @@ void __init sparse_init(void)
>  	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
>  	vmemmap_populate_print_last();
>  }
> -
> -#ifdef CONFIG_MEMORY_HOTPLUG
> -
> -/* Mark all memory sections within the pfn range as online */
> -void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
> -{
> -	unsigned long pfn;
> -
> -	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms = __nr_to_section(section_nr);
> -
> -		ms->section_mem_map |= SECTION_IS_ONLINE;
> -	}
> -}
> -
> -/* Mark all memory sections within the pfn range as offline */
> -void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
> -{
> -	unsigned long pfn;
> -
> -	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms = __nr_to_section(section_nr);
> -
> -		ms->section_mem_map &= ~SECTION_IS_ONLINE;
> -	}
> -}
> -
> -static struct page * __meminit populate_section_memmap(unsigned long pfn,
> -		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
> -		struct dev_pagemap *pgmap)
> -{
> -	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> -}
> -
> -static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
> -		struct vmem_altmap *altmap)
> -{
> -	unsigned long start = (unsigned long) pfn_to_page(pfn);
> -	unsigned long end = start + nr_pages * sizeof(struct page);
> -
> -	vmemmap_free(start, end, altmap);
> -}
> -static void free_map_bootmem(struct page *memmap)
> -{
> -	unsigned long start = (unsigned long)memmap;
> -	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
> -
> -	vmemmap_free(start, end, NULL);
> -}
> -
> -static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
> -{
> -	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
> -	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
> -	struct mem_section *ms = __pfn_to_section(pfn);
> -	unsigned long *subsection_map = ms->usage
> -		? &ms->usage->subsection_map[0] : NULL;
> -
> -	subsection_mask_set(map, pfn, nr_pages);
> -	if (subsection_map)
> -		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
> -
> -	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
> -				"section already deactivated (%#lx + %ld)\n",
> -				pfn, nr_pages))
> -		return -EINVAL;
> -
> -	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
> -	return 0;
> -}
> -
> -static bool is_subsection_map_empty(struct mem_section *ms)
> -{
> -	return bitmap_empty(&ms->usage->subsection_map[0],
> -			    SUBSECTIONS_PER_SECTION);
> -}
> -
> -static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
> -{
> -	struct mem_section *ms = __pfn_to_section(pfn);
> -	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
> -	unsigned long *subsection_map;
> -	int rc = 0;
> -
> -	subsection_mask_set(map, pfn, nr_pages);
> -
> -	subsection_map = &ms->usage->subsection_map[0];
> -
> -	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
> -		rc = -EINVAL;
> -	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
> -		rc = -EEXIST;
> -	else
> -		bitmap_or(subsection_map, map, subsection_map,
> -				SUBSECTIONS_PER_SECTION);
> -
> -	return rc;
> -}
> -
> -/*
> - * To deactivate a memory region, there are 3 cases to handle across
> - * two configurations (SPARSEMEM_VMEMMAP={y,n}):
> - *
> - * 1. deactivation of a partial hot-added section (only possible in
> - *    the SPARSEMEM_VMEMMAP=y case).
> - *      a) section was present at memory init.
> - *      b) section was hot-added post memory init.
> - * 2. deactivation of a complete hot-added section.
> - * 3. deactivation of a complete section from memory init.
> - *
> - * For 1, when subsection_map does not empty we will not be freeing the
> - * usage map, but still need to free the vmemmap range.
> - *
> - * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
> - */
> -static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
> -		struct vmem_altmap *altmap)
> -{
> -	struct mem_section *ms = __pfn_to_section(pfn);
> -	bool section_is_early = early_section(ms);
> -	struct page *memmap = NULL;
> -	bool empty;
> -
> -	if (clear_subsection_map(pfn, nr_pages))
> -		return;
> -
> -	empty = is_subsection_map_empty(ms);
> -	if (empty) {
> -		/*
> -		 * Mark the section invalid so that valid_section()
> -		 * return false. This prevents code from dereferencing
> -		 * ms->usage array.
> -		 */
> -		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
> -
> -		/*
> -		 * When removing an early section, the usage map is kept (as the
> -		 * usage maps of other sections fall into the same page). It
> -		 * will be re-used when re-adding the section - which is then no
> -		 * longer an early section. If the usage map is PageReserved, it
> -		 * was allocated during boot.
> -		 */
> -		if (!PageReserved(virt_to_page(ms->usage))) {
> -			kfree_rcu(ms->usage, rcu);
> -			WRITE_ONCE(ms->usage, NULL);
> -		}
> -		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
> -	}
> -
> -	/*
> -	 * The memmap of early sections is always fully populated. See
> -	 * section_activate() and pfn_valid() .
> -	 */
> -	if (!section_is_early) {
> -		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
> -		depopulate_section_memmap(pfn, nr_pages, altmap);
> -	} else if (memmap) {
> -		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
> -							  PAGE_SIZE)));
> -		free_map_bootmem(memmap);
> -	}
> -
> -	if (empty)
> -		ms->section_mem_map = (unsigned long)NULL;
> -}
> -
> -static struct page * __meminit section_activate(int nid, unsigned long pfn,
> -		unsigned long nr_pages, struct vmem_altmap *altmap,
> -		struct dev_pagemap *pgmap)
> -{
> -	struct mem_section *ms = __pfn_to_section(pfn);
> -	struct mem_section_usage *usage = NULL;
> -	struct page *memmap;
> -	int rc;
> -
> -	if (!ms->usage) {
> -		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
> -		if (!usage)
> -			return ERR_PTR(-ENOMEM);
> -		ms->usage = usage;
> -	}
> -
> -	rc = fill_subsection_map(pfn, nr_pages);
> -	if (rc) {
> -		if (usage)
> -			ms->usage = NULL;
> -		kfree(usage);
> -		return ERR_PTR(rc);
> -	}
> -
> -	/*
> -	 * The early init code does not consider partially populated
> -	 * initial sections, it simply assumes that memory will never be
> -	 * referenced.  If we hot-add memory into such a section then we
> -	 * do not need to populate the memmap and can simply reuse what
> -	 * is already there.
> -	 */
> -	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
> -		return pfn_to_page(pfn);
> -
> -	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
> -	if (!memmap) {
> -		section_deactivate(pfn, nr_pages, altmap);
> -		return ERR_PTR(-ENOMEM);
> -	}
> -	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
> -
> -	return memmap;
> -}
> -
> -/**
> - * sparse_add_section - add a memory section, or populate an existing one
> - * @nid: The node to add section on
> - * @start_pfn: start pfn of the memory range
> - * @nr_pages: number of pfns to add in the section
> - * @altmap: alternate pfns to allocate the memmap backing store
> - * @pgmap: alternate compound page geometry for devmap mappings
> - *
> - * This is only intended for hotplug.
> - *
> - * Note that only VMEMMAP supports sub-section aligned hotplug,
> - * the proper alignment and size are gated by check_pfn_span().
> - *
> - *
> - * Return:
> - * * 0		- On success.
> - * * -EEXIST	- Section has been present.
> - * * -ENOMEM	- Out of memory.
> - */
> -int __meminit sparse_add_section(int nid, unsigned long start_pfn,
> -		unsigned long nr_pages, struct vmem_altmap *altmap,
> -		struct dev_pagemap *pgmap)
> -{
> -	unsigned long section_nr = pfn_to_section_nr(start_pfn);
> -	struct mem_section *ms;
> -	struct page *memmap;
> -	int ret;
> -
> -	ret = sparse_index_init(section_nr, nid);
> -	if (ret < 0)
> -		return ret;
> -
> -	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
> -	if (IS_ERR(memmap))
> -		return PTR_ERR(memmap);
> -
> -	/*
> -	 * Poison uninitialized struct pages in order to catch invalid flags
> -	 * combinations.
> -	 */
> -	page_init_poison(memmap, sizeof(struct page) * nr_pages);
> -
> -	ms = __nr_to_section(section_nr);
> -	__section_mark_present(ms, section_nr);
> -
> -	/* Align memmap to section boundary in the subsection case */
> -	if (section_nr_to_pfn(section_nr) != start_pfn)
> -		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
> -	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
> -
> -	return 0;
> -}
> -
> -void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
> -			   struct vmem_altmap *altmap)
> -{
> -	struct mem_section *ms = __pfn_to_section(pfn);
> -
> -	if (WARN_ON_ONCE(!valid_section(ms)))
> -		return;
> -
> -	section_deactivate(pfn, nr_pages, altmap);
> -}
> -#endif /* CONFIG_MEMORY_HOTPLUG */
> --
> 2.43.0
>

