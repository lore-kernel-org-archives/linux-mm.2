Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC7661099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C866B00F8; Fri, 20 Mar 2026 18:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5537E6B00FA; Fri, 20 Mar 2026 18:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 469C66B00FB; Fri, 20 Mar 2026 18:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 317856B00F8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEFBE1B7AFE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:49 +0000 (UTC)
X-FDA: 84567847098.07.6D74295
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C3E0FC000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fOZqms56;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qKfxo/S/neakHF4Pe8K6B5u7yRY/XP7jLE8cxMrrp4=;
	b=V/9gy50rWjyJ8tq0LMctEWacwSsyps4lqj54tsO0VeECUMzt63tLeOcF5R93r5efLiHAMB
	xdpvkduX3kqZD7z90NRPsgAt2kG7EAHi7rSSw0m3QkvrRuzGHh+ktddBqHmfz5QH/ZPLxZ
	U9NSsrp4Tb/5ewxAlJYlsBxM2UKvjlc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fOZqms56;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044887; a=rsa-sha256;
	cv=none;
	b=5WcKbK5jGVkFhX2MFBsVG+iaO2rmYCHCXivY0ICC5ttL+JyMPHcZVksKjvWvHNJ2to/7Ad
	CldsYGUwAWKKNVNMRILkYLhe5H8NZ50iEQ0fyLkpUZsRyEHCIt6p1/QC4H4yjXRv31KLQv
	lanQjSLuK4zcfC3KUKfooIMlvXsEPCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE42043503;
	Fri, 20 Mar 2026 22:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0415BC2BC9E;
	Fri, 20 Mar 2026 22:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044886;
	bh=eJ5LJmBygj38sotSWrTqqnRQBxx9S09xuHHuoQllTf4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fOZqms56Detoy7Ovql6hpqyFtIeGu2lGm8UYHQTWjXWW07wX+NrF400TJE7KR77iF
	 9iCuUdABYnU76QMfikTfpFzS/Hvt6CBqZniMNHd19YOw1xDd5XMqF14wdMiaekrhhz
	 qhnwaetcd3jJkelgH1rnPvfWuZFFqGIbxeENC9nn/Kr3ltIHWKUzBzTZ+CaB2kf7lZ
	 1xKdVDw2rqCl0Pjlqj0t4KrOwpm43JEyKX/DBfvImIOe2FHRCwwvZG0Ldi6xHpAoUN
	 Mnl5e4sno4aqrQ87l6rQMAXZF4brrhoHmbWYxQ5CAjXrgaVbepoHy29TJZ3Es+E1n9
	 Sh9ug6YAQ3Iog==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:47 +0100
Subject: [PATCH v2 15/15] mm/sparse: move memory hotplug bits to
 sparse-vmemmap.c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-15-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: C3E0FC000B
X-Rspamd-Server: rspam08
X-Stat-Signature: 5ej8n1nfm37s1xpsm8ffdtra81dz7ci5
X-HE-Tag: 1774044887-530149
X-HE-Meta: U2FsdGVkX1+UBTutt8MH4LA2RYT4IfboKkzDLAyaLOXfZ5Gb8ESDSROsqIOwG+XcSOGk+RPMD7N4tb4qdjUZ34qOtFuKnWoOM6scQ5HvNSkTgwjQ8Cstp2dqIggkXTUV0rH14R9O4cB9M1VBHVcbs3VJ/zZg4eK/LuTmA+Pk0I5qjJCbfgrbf0J0Ve5mJXZJlSUwh2Kku5vTfXIFC71vhrw1fllIXwyJBev3IBo80NdQ6vM16UoZNOsW4pRR+8bQlO2GRBspMxHpa/a4PWemCyQtR0/rnNkF2g61bJ2xl+E3plKft0I8c2cvt0JakWMPe587opv7guniG2aJlY9Q9JJK07chI9GtyZdpk75yLvhAseDuBa1rzHFeTj8tMssUF9rNriCaXUzYinSNu2j7r4PrH/p5qntdmh2BDDHR4nCtH3F+wgN8xU2+FpG1pawT2Iu30vaB5PVGtPgn/S5UdaHC9IVeL8uj5Dfhb4TM2EdZqTf0PNdmW1JSCoxiKBbzzOCNUE3ISesjVtGE/ogBMFFJ7SJGMR3giiIUMMp7WDzOy9OKVgbfBc4EXgiUF4046Q3duamWW4LupB5zEs8ANic9VxYGNCTkm7Qbnh7rkSZu4InLeuRWZ4gfjvUgl7fTaGzNEwxhwJqOFtgqEjOUr9f7Bw0saBysTP149V5GCDdy8FNoOtPMYWo8b1YnCya1vPbqblqXuYqT2NOZKyvV2FQBkA8zzlHvyT1VE4BLPTRSL3ebXDtDQ1eS7mTpznKiDQxJ0XRrQ9DmFsDub5hhf/abE/wCfES65OkQmxpeN5B1T9n4ZQIfl7t9YYhCwSYOzg7dCnd0QAO835OhItaAcRD7i0ajFQGPxUASNWrfYCMGgu6883/I182UYd3veJdkz2uMDLDWnKfjbbOEGgocEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move all memory hoptplug related code to sparse-vmemmap.c.

We only have to expose sparse_index_init(). While at it, drop the
definition of sparse_index_init() for !CONFIG_SPARSEMEM, which is unused,
and place the declaration in internal.h.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h |   1 -
 mm/internal.h          |   4 +
 mm/sparse-vmemmap.c    | 304 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/sparse.c            | 310 +------------------------------------------------
 4 files changed, 310 insertions(+), 309 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index dcbbf36ed88c..e11513f581eb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2390,7 +2390,6 @@ static inline unsigned long next_present_section_nr(unsigned long section_nr)
 #endif
 
 #else
-#define sparse_index_init(_sec, _nid)  do {} while (0)
 #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
 #define sparse_vmemmap_init_nid_late(_nid) do {} while (0)
 #define pfn_in_present_section pfn_valid
diff --git a/mm/internal.h b/mm/internal.h
index b002c91e40a5..83e781147a28 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -965,6 +965,7 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
 		unsigned long pnum, struct page *mem_map,
@@ -1000,6 +1001,9 @@ static inline void __section_mark_present(struct mem_section *ms,
 static inline void sparse_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
+/*
+ * mm/sparse-vmemmap.c
+ */
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 void sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages);
 #else
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index f0690797667f..08fef7b5c8b0 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -591,3 +591,307 @@ void __init sparse_vmemmap_init_nid_late(int nid)
 	hugetlb_vmemmap_init_late(nid);
 }
 #endif
+
+static void subsection_mask_set(unsigned long *map, unsigned long pfn,
+		unsigned long nr_pages)
+{
+	int idx = subsection_map_index(pfn);
+	int end = subsection_map_index(pfn + nr_pages - 1);
+
+	bitmap_set(map, idx, end - idx + 1);
+}
+
+void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
+	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
+
+	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
+		struct mem_section *ms;
+		unsigned long pfns;
+
+		pfns = min(nr_pages, PAGES_PER_SECTION
+				- (pfn & ~PAGE_SECTION_MASK));
+		ms = __nr_to_section(nr);
+		subsection_mask_set(ms->usage->subsection_map, pfn, pfns);
+
+		pr_debug("%s: sec: %lu pfns: %lu set(%d, %d)\n", __func__, nr,
+				pfns, subsection_map_index(pfn),
+				subsection_map_index(pfn + pfns - 1));
+
+		pfn += pfns;
+		nr_pages -= pfns;
+	}
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+
+/* Mark all memory sections within the pfn range as online */
+void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+		struct mem_section *ms = __nr_to_section(section_nr);
+
+		ms->section_mem_map |= SECTION_IS_ONLINE;
+	}
+}
+
+/* Mark all memory sections within the pfn range as offline */
+void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long pfn;
+
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		unsigned long section_nr = pfn_to_section_nr(pfn);
+		struct mem_section *ms = __nr_to_section(section_nr);
+
+		ms->section_mem_map &= ~SECTION_IS_ONLINE;
+	}
+}
+
+static struct page * __meminit populate_section_memmap(unsigned long pfn,
+		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
+{
+	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+}
+
+static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap)
+{
+	unsigned long start = (unsigned long) pfn_to_page(pfn);
+	unsigned long end = start + nr_pages * sizeof(struct page);
+
+	vmemmap_free(start, end, altmap);
+}
+static void free_map_bootmem(struct page *memmap)
+{
+	unsigned long start = (unsigned long)memmap;
+	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
+
+	vmemmap_free(start, end, NULL);
+}
+
+static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
+	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
+	struct mem_section *ms = __pfn_to_section(pfn);
+	unsigned long *subsection_map = ms->usage
+		? &ms->usage->subsection_map[0] : NULL;
+
+	subsection_mask_set(map, pfn, nr_pages);
+	if (subsection_map)
+		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
+
+	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
+				"section already deactivated (%#lx + %ld)\n",
+				pfn, nr_pages))
+		return -EINVAL;
+
+	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
+	return 0;
+}
+
+static bool is_subsection_map_empty(struct mem_section *ms)
+{
+	return bitmap_empty(&ms->usage->subsection_map[0],
+			    SUBSECTIONS_PER_SECTION);
+}
+
+static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
+	unsigned long *subsection_map;
+	int rc = 0;
+
+	subsection_mask_set(map, pfn, nr_pages);
+
+	subsection_map = &ms->usage->subsection_map[0];
+
+	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
+		rc = -EINVAL;
+	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
+		rc = -EEXIST;
+	else
+		bitmap_or(subsection_map, map, subsection_map,
+				SUBSECTIONS_PER_SECTION);
+
+	return rc;
+}
+
+/*
+ * To deactivate a memory region, there are 3 cases to handle:
+ *
+ * 1. deactivation of a partial hot-added section:
+ *      a) section was present at memory init.
+ *      b) section was hot-added post memory init.
+ * 2. deactivation of a complete hot-added section.
+ * 3. deactivation of a complete section from memory init.
+ *
+ * For 1, when subsection_map does not empty we will not be freeing the
+ * usage map, but still need to free the vmemmap range.
+ */
+static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
+		struct vmem_altmap *altmap)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	bool section_is_early = early_section(ms);
+	struct page *memmap = NULL;
+	bool empty;
+
+	if (clear_subsection_map(pfn, nr_pages))
+		return;
+
+	empty = is_subsection_map_empty(ms);
+	if (empty) {
+		/*
+		 * Mark the section invalid so that valid_section()
+		 * return false. This prevents code from dereferencing
+		 * ms->usage array.
+		 */
+		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
+
+		/*
+		 * When removing an early section, the usage map is kept (as the
+		 * usage maps of other sections fall into the same page). It
+		 * will be re-used when re-adding the section - which is then no
+		 * longer an early section. If the usage map is PageReserved, it
+		 * was allocated during boot.
+		 */
+		if (!PageReserved(virt_to_page(ms->usage))) {
+			kfree_rcu(ms->usage, rcu);
+			WRITE_ONCE(ms->usage, NULL);
+		}
+		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
+	}
+
+	/*
+	 * The memmap of early sections is always fully populated. See
+	 * section_activate() and pfn_valid() .
+	 */
+	if (!section_is_early) {
+		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+		depopulate_section_memmap(pfn, nr_pages, altmap);
+	} else if (memmap) {
+		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
+							  PAGE_SIZE)));
+		free_map_bootmem(memmap);
+	}
+
+	if (empty)
+		ms->section_mem_map = (unsigned long)NULL;
+}
+
+static struct page * __meminit section_activate(int nid, unsigned long pfn,
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+	struct mem_section_usage *usage = NULL;
+	struct page *memmap;
+	int rc;
+
+	if (!ms->usage) {
+		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
+		if (!usage)
+			return ERR_PTR(-ENOMEM);
+		ms->usage = usage;
+	}
+
+	rc = fill_subsection_map(pfn, nr_pages);
+	if (rc) {
+		if (usage)
+			ms->usage = NULL;
+		kfree(usage);
+		return ERR_PTR(rc);
+	}
+
+	/*
+	 * The early init code does not consider partially populated
+	 * initial sections, it simply assumes that memory will never be
+	 * referenced.  If we hot-add memory into such a section then we
+	 * do not need to populate the memmap and can simply reuse what
+	 * is already there.
+	 */
+	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
+		return pfn_to_page(pfn);
+
+	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	if (!memmap) {
+		section_deactivate(pfn, nr_pages, altmap);
+		return ERR_PTR(-ENOMEM);
+	}
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return memmap;
+}
+
+/**
+ * sparse_add_section - add a memory section, or populate an existing one
+ * @nid: The node to add section on
+ * @start_pfn: start pfn of the memory range
+ * @nr_pages: number of pfns to add in the section
+ * @altmap: alternate pfns to allocate the memmap backing store
+ * @pgmap: alternate compound page geometry for devmap mappings
+ *
+ * This is only intended for hotplug.
+ *
+ * Note that only VMEMMAP supports sub-section aligned hotplug,
+ * the proper alignment and size are gated by check_pfn_span().
+ *
+ *
+ * Return:
+ * * 0		- On success.
+ * * -EEXIST	- Section has been present.
+ * * -ENOMEM	- Out of memory.
+ */
+int __meminit sparse_add_section(int nid, unsigned long start_pfn,
+		unsigned long nr_pages, struct vmem_altmap *altmap,
+		struct dev_pagemap *pgmap)
+{
+	unsigned long section_nr = pfn_to_section_nr(start_pfn);
+	struct mem_section *ms;
+	struct page *memmap;
+	int ret;
+
+	ret = sparse_index_init(section_nr, nid);
+	if (ret < 0)
+		return ret;
+
+	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
+	if (IS_ERR(memmap))
+		return PTR_ERR(memmap);
+
+	/*
+	 * Poison uninitialized struct pages in order to catch invalid flags
+	 * combinations.
+	 */
+	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+
+	ms = __nr_to_section(section_nr);
+	__section_mark_present(ms, section_nr);
+
+	/* Align memmap to section boundary in the subsection case */
+	if (section_nr_to_pfn(section_nr) != start_pfn)
+		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
+	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
+
+	return 0;
+}
+
+void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
+			   struct vmem_altmap *altmap)
+{
+	struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (WARN_ON_ONCE(!valid_section(ms)))
+		return;
+
+	section_deactivate(pfn, nr_pages, altmap);
+}
+#endif /* CONFIG_MEMORY_HOTPLUG */
diff --git a/mm/sparse.c b/mm/sparse.c
index ecd4c41c0ff0..007fd52c621e 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -79,7 +79,7 @@ static noinline struct mem_section __ref *sparse_index_alloc(int nid)
 	return section;
 }
 
-static int __meminit sparse_index_init(unsigned long section_nr, int nid)
+int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	unsigned long root = SECTION_NR_TO_ROOT(section_nr);
 	struct mem_section *section;
@@ -103,7 +103,7 @@ static int __meminit sparse_index_init(unsigned long section_nr, int nid)
 	return 0;
 }
 #else /* !SPARSEMEM_EXTREME */
-static inline int sparse_index_init(unsigned long section_nr, int nid)
+int sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
@@ -167,40 +167,6 @@ static inline unsigned long first_present_section_nr(void)
 	return next_present_section_nr(-1);
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-static void subsection_mask_set(unsigned long *map, unsigned long pfn,
-		unsigned long nr_pages)
-{
-	int idx = subsection_map_index(pfn);
-	int end = subsection_map_index(pfn + nr_pages - 1);
-
-	bitmap_set(map, idx, end - idx + 1);
-}
-
-void __init sparse_init_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	int end_sec_nr = pfn_to_section_nr(pfn + nr_pages - 1);
-	unsigned long nr, start_sec_nr = pfn_to_section_nr(pfn);
-
-	for (nr = start_sec_nr; nr <= end_sec_nr; nr++) {
-		struct mem_section *ms;
-		unsigned long pfns;
-
-		pfns = min(nr_pages, PAGES_PER_SECTION
-				- (pfn & ~PAGE_SECTION_MASK));
-		ms = __nr_to_section(nr);
-		subsection_mask_set(ms->usage->subsection_map, pfn, pfns);
-
-		pr_debug("%s: sec: %lu pfns: %lu set(%d, %d)\n", __func__, nr,
-				pfns, subsection_map_index(pfn),
-				subsection_map_index(pfn + pfns - 1));
-
-		pfn += pfns;
-		nr_pages -= pfns;
-	}
-}
-#endif
-
 /* Record a memory area against a node. */
 static void __init memory_present(int nid, unsigned long start, unsigned long end)
 {
@@ -482,275 +448,3 @@ void __init sparse_init(void)
 	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
 	vmemmap_populate_print_last();
 }
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-
-/* Mark all memory sections within the pfn range as online */
-void online_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms = __nr_to_section(section_nr);
-
-		ms->section_mem_map |= SECTION_IS_ONLINE;
-	}
-}
-
-/* Mark all memory sections within the pfn range as offline */
-void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long pfn;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-		unsigned long section_nr = pfn_to_section_nr(pfn);
-		struct mem_section *ms = __nr_to_section(section_nr);
-
-		ms->section_mem_map &= ~SECTION_IS_ONLINE;
-	}
-}
-
-static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
-}
-
-static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
-{
-	unsigned long start = (unsigned long) pfn_to_page(pfn);
-	unsigned long end = start + nr_pages * sizeof(struct page);
-
-	vmemmap_free(start, end, altmap);
-}
-static void free_map_bootmem(struct page *memmap)
-{
-	unsigned long start = (unsigned long)memmap;
-	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
-
-	vmemmap_free(start, end, NULL);
-}
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
-	DECLARE_BITMAP(tmp, SUBSECTIONS_PER_SECTION) = { 0 };
-	struct mem_section *ms = __pfn_to_section(pfn);
-	unsigned long *subsection_map = ms->usage
-		? &ms->usage->subsection_map[0] : NULL;
-
-	subsection_mask_set(map, pfn, nr_pages);
-	if (subsection_map)
-		bitmap_and(tmp, map, subsection_map, SUBSECTIONS_PER_SECTION);
-
-	if (WARN(!subsection_map || !bitmap_equal(tmp, map, SUBSECTIONS_PER_SECTION),
-				"section already deactivated (%#lx + %ld)\n",
-				pfn, nr_pages))
-		return -EINVAL;
-
-	bitmap_xor(subsection_map, map, subsection_map, SUBSECTIONS_PER_SECTION);
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return bitmap_empty(&ms->usage->subsection_map[0],
-			    SUBSECTIONS_PER_SECTION);
-}
-
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-	DECLARE_BITMAP(map, SUBSECTIONS_PER_SECTION) = { 0 };
-	unsigned long *subsection_map;
-	int rc = 0;
-
-	subsection_mask_set(map, pfn, nr_pages);
-
-	subsection_map = &ms->usage->subsection_map[0];
-
-	if (bitmap_empty(map, SUBSECTIONS_PER_SECTION))
-		rc = -EINVAL;
-	else if (bitmap_intersects(map, subsection_map, SUBSECTIONS_PER_SECTION))
-		rc = -EEXIST;
-	else
-		bitmap_or(subsection_map, map, subsection_map,
-				SUBSECTIONS_PER_SECTION);
-
-	return rc;
-}
-
-/*
- * To deactivate a memory region, there are 3 cases to handle:
- *
- * 1. deactivation of a partial hot-added section:
- *      a) section was present at memory init.
- *      b) section was hot-added post memory init.
- * 2. deactivation of a complete hot-added section.
- * 3. deactivation of a complete section from memory init.
- *
- * For 1, when subsection_map does not empty we will not be freeing the
- * usage map, but still need to free the vmemmap range.
- */
-static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-	bool section_is_early = early_section(ms);
-	struct page *memmap = NULL;
-	bool empty;
-
-	if (clear_subsection_map(pfn, nr_pages))
-		return;
-
-	empty = is_subsection_map_empty(ms);
-	if (empty) {
-		/*
-		 * Mark the section invalid so that valid_section()
-		 * return false. This prevents code from dereferencing
-		 * ms->usage array.
-		 */
-		ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
-
-		/*
-		 * When removing an early section, the usage map is kept (as the
-		 * usage maps of other sections fall into the same page). It
-		 * will be re-used when re-adding the section - which is then no
-		 * longer an early section. If the usage map is PageReserved, it
-		 * was allocated during boot.
-		 */
-		if (!PageReserved(virt_to_page(ms->usage))) {
-			kfree_rcu(ms->usage, rcu);
-			WRITE_ONCE(ms->usage, NULL);
-		}
-		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
-	}
-
-	/*
-	 * The memmap of early sections is always fully populated. See
-	 * section_activate() and pfn_valid() .
-	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
-		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
-		free_map_bootmem(memmap);
-	}
-
-	if (empty)
-		ms->section_mem_map = (unsigned long)NULL;
-}
-
-static struct page * __meminit section_activate(int nid, unsigned long pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-	struct mem_section_usage *usage = NULL;
-	struct page *memmap;
-	int rc;
-
-	if (!ms->usage) {
-		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
-		if (!usage)
-			return ERR_PTR(-ENOMEM);
-		ms->usage = usage;
-	}
-
-	rc = fill_subsection_map(pfn, nr_pages);
-	if (rc) {
-		if (usage)
-			ms->usage = NULL;
-		kfree(usage);
-		return ERR_PTR(rc);
-	}
-
-	/*
-	 * The early init code does not consider partially populated
-	 * initial sections, it simply assumes that memory will never be
-	 * referenced.  If we hot-add memory into such a section then we
-	 * do not need to populate the memmap and can simply reuse what
-	 * is already there.
-	 */
-	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
-		return pfn_to_page(pfn);
-
-	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
-	if (!memmap) {
-		section_deactivate(pfn, nr_pages, altmap);
-		return ERR_PTR(-ENOMEM);
-	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
-
-	return memmap;
-}
-
-/**
- * sparse_add_section - add a memory section, or populate an existing one
- * @nid: The node to add section on
- * @start_pfn: start pfn of the memory range
- * @nr_pages: number of pfns to add in the section
- * @altmap: alternate pfns to allocate the memmap backing store
- * @pgmap: alternate compound page geometry for devmap mappings
- *
- * This is only intended for hotplug.
- *
- * Note that only VMEMMAP supports sub-section aligned hotplug,
- * the proper alignment and size are gated by check_pfn_span().
- *
- *
- * Return:
- * * 0		- On success.
- * * -EEXIST	- Section has been present.
- * * -ENOMEM	- Out of memory.
- */
-int __meminit sparse_add_section(int nid, unsigned long start_pfn,
-		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	unsigned long section_nr = pfn_to_section_nr(start_pfn);
-	struct mem_section *ms;
-	struct page *memmap;
-	int ret;
-
-	ret = sparse_index_init(section_nr, nid);
-	if (ret < 0)
-		return ret;
-
-	memmap = section_activate(nid, start_pfn, nr_pages, altmap, pgmap);
-	if (IS_ERR(memmap))
-		return PTR_ERR(memmap);
-
-	/*
-	 * Poison uninitialized struct pages in order to catch invalid flags
-	 * combinations.
-	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
-
-	ms = __nr_to_section(section_nr);
-	__section_mark_present(ms, section_nr);
-
-	/* Align memmap to section boundary in the subsection case */
-	if (section_nr_to_pfn(section_nr) != start_pfn)
-		memmap = pfn_to_page(section_nr_to_pfn(section_nr));
-	sparse_init_one_section(ms, section_nr, memmap, ms->usage, 0);
-
-	return 0;
-}
-
-void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
-			   struct vmem_altmap *altmap)
-{
-	struct mem_section *ms = __pfn_to_section(pfn);
-
-	if (WARN_ON_ONCE(!valid_section(ms)))
-		return;
-
-	section_deactivate(pfn, nr_pages, altmap);
-}
-#endif /* CONFIG_MEMORY_HOTPLUG */

-- 
2.43.0


