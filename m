Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E594ACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594716B010D; Wed, 13 May 2026 09:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544D06B010F; Wed, 13 May 2026 09:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B056B0110; Wed, 13 May 2026 09:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32AFD6B010D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:22:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA6D54005F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:29 +0000 (UTC)
X-FDA: 84762460818.21.2777691
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE21E2000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:22:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HZfcnsUB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778678547; a=rsa-sha256;
	cv=none;
	b=KuyTleKXQEqe73wOvonSNU9AOvAXdF9hBsUvYtUhcxWP+c9rq0Q7Yv1cTWXwZunucCMebx
	bpNEd29tBLxkly3aZgd4z90iNAp134EBaSr7LtFH8PjYPMeif1BHu+RpjG+WZQ1PREGcRJ
	en8HuITqF1i16BDFWqxZrjQT8QsGpgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HZfcnsUB;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778678547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5LFbqiG/RD0CCzo7+/AP1zWQqzbysWKSZNji4RwzSyY=;
	b=R5Sa2b85pWG2iwj5A324TD/IpU0MaRwPtPqVKZoioBB0C/ERWW3OSGoxpN2edEOkNjC7Tb
	d+uPn2T9G5oYh0pwJ3zLsoGdsGeRNU9uLSLi4kTpLMPVCs0U8nJvZwjkkj2xbJlB21J87d
	DMiRA1N6cNmh9LdajEe0sGqSmDWxYiQ=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3680540a6efso2535698a91.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778678547; x=1779283347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5LFbqiG/RD0CCzo7+/AP1zWQqzbysWKSZNji4RwzSyY=;
        b=HZfcnsUBeseMe9M+K+mFZok9cjr3ANGzovgCNYmQTaFAo93sAzMzmKh8rxTzWKldQE
         hYiN/jtGu9kEJhyxYQ3KB+d6UGrfsy7Ggx++SnRoVpeVrgwFM6MOndPGpMr7T3WD+iHM
         PtEsSzNUSxoRsnhG/THWHZzyRNx9jPO9+86+yK8HtED3JQD4+wdjNSuvm410PixKV4JF
         3bD+WGf1pDosYybFXDbr/Fmkg6qvzcWrw5e1zgqlGaJRRDeKMf8f8j0whxy+RcrqUZov
         C3LyTKntmjONO+TejGeaLi6WNMre7o0wKliH+GOlOdJCFG+zRo6O4Ule5YupJcCh2UFH
         XMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778678547; x=1779283347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5LFbqiG/RD0CCzo7+/AP1zWQqzbysWKSZNji4RwzSyY=;
        b=ISFds8YOoRqKikKlViNdWlorG2vgRJkrKzzeNqULPZ+pIy1HkiH2LRKy6qK+5Lsl08
         0AtT8YLORmVz4GWk080k08HRHyQdLEjOE3bUMtnEhIFu+qxLYGSpqzf+PbCppz94FoNf
         rDEba2jyypEiSoI72bgq1WRxYS9RQ24gC7H8LIa5i8LxaiiBFk72kbLWCRQDVEwDhzza
         ZR089amR4h08qBl0dCTtYYjtUoAmDpevQhUjguTbFf0ig4XwLrG1nwPnaorbhw6wMkYS
         qJLBouRoSv5SWqE+gtxV7esnJNJqqZz9kUnvjUKFTKoZGNQIqKugy5px5eRjo68unZnV
         hrtg==
X-Forwarded-Encrypted: i=1; AFNElJ+pRQkiscrSOZSyh5yxGsymWxarcKMK0FywPIidwh5HkaNjIMQjQIqPxNDzxSvDpkRV9hCLR5hjJg==@kvack.org
X-Gm-Message-State: AOJu0YwrvnyuBvczZbyhdzMUnwetVrHKxYnaGFA8fU5iKOowONajj+y8
	gkVWobDAZ16e9Fgv6/B0JXM/Ucu8qU5JO0LUbUdsACczq9Dt+vsjVK/TQHqd03+446o=
X-Gm-Gg: Acq92OGxx2WlhrgsVxIV5s9rnWnwEmbKD3Qe+v4N8kGMCedxQU6pln2evBLo//6DWMr
	Q55Sdg6XKIOeLKb/AYI5aagLCU5To6oW6AD3Tisp74uYSFMY86FuPZoeRHv4ZfdIHf3kkhi67hr
	6sP+Y4n2ni5AGH9hUV0zh9TGmSl7Qdd7bVaofu/wMxu4hF5CtfjyGYzAfXHOdvQs56vwb2BAhUL
	MZeJsyKe6ieoS0RuyPe2p1lRcRAZ3zgyi204lYuokLAubwGYQMOO4AgVagqToCQEKGz1ZflE/Cp
	HPV2AFnlaNMJqw4IpdQZdg8EsObWB1CrGge/ceXqMrXE97E9OSoXqJ2I8EtY3JkyUXlEiLDvo1d
	WZwygiLTuEyAMsfgAkK3VEocUbHepmk3y5jWpexrqxyL3xJ4AF4RQmpV+S2E9DVRdmLbxrkCtXH
	BSfygzY6emLvPrq9bsapfTRDPYcYloMthP8Fe4jtZoIoWjfC0Z8/JRnGI3V5+3ivJqumzUH/w=
X-Received: by 2002:a17:90a:da8b:b0:368:ddd7:abca with SMTP id 98e67ed59e1d1-368f79e8cfbmr3065574a91.26.1778678546422;
        Wed, 13 May 2026 06:22:26 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368edf7cbc2sm3098406a91.14.2026.05.13.06.22.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:22:25 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 61/69] mm/hugetlb: Drop boot-time HVO handling for gigantic folios
Date: Wed, 13 May 2026 21:20:26 +0800
Message-ID: <20260513132044.41690-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513132044.41690-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513132044.41690-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3oiqmbe96uwqiion95ku8gppqdsfgep5
X-Rspam-User: 
X-Rspamd-Queue-Id: DE21E2000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1778678547-955124
X-HE-Meta: U2FsdGVkX1/JY9mSb3TNomPEniI9lIKnlZu7e0n0QYJ0e1gJFdf0kSzZg5b5qnbNuyS06Dd3DUpX55xxp4ZJcjXhkBzerqBB6igSMr5KY6XH/qP/vDNYyJU87NA0MLbNp7BZCpITs8PU+SJWaR/TdEZI3zn7l6KO6I6JgUqgZCHsVSdiZvDtvC67lstfp+EMdifRdoUgZWw0/tnXANefqv9EtegDECKY65GsHPuaQrka/AifKqmnQlXj3ndRj/yuBSqwNVlKOOUW7RuiqzTg1uOCC8N94gRslM1gmzHFCTS7j1J/8rgvbO4L6iTqAY6TGQtiuuurRxDglVU8XtSJ+uOTq//O64/SUi8TvG2VqpHsSwbuE/lde+FzZHiluAfbEDoXXS4rjRJbf27vo2+Sw98yZRStlsixYWP1Vmel98qhHLP7hqPR8wxRRolTBphnC9Eyg8cHuBN9zrFg/Ah+oSaEacw6wWkKF9I1ZRuobCCq7G2Mr6R+Mrg/k3/8ho3E2Q9vdRjcmn2qM/6B9zIPpMYDlyomNtAJOPmqR/KQ4IEmur5PnMwpBsTSXGmWysHt0Vpc8nv8xoHZn/i8KogEHzhi3DWz3dXvM4Sla/GLG8flJUB6RqrQb33/q+hGd3FuK87QHoWF41k4HBTMSU2rNXvwcNMEEvkrBkAxx8YEzszKPtC2LXlm84lA8VXNfejZp0SO+t+dsnTKgnve9jSy7o+FdFEqIMi0gL8gs8v9jihMFBlnr+Vfkn7R2ijNKibXdWnlOFo/vMbI6AVr/aj717syYk6Dfs1lcO3PTohBVugXBqean37zYYX66cByQQyknaTznaARihx32evv/4DCEL1rqjdDBZQl99HGCzEGNX/VSu+eWENJpncjlinUZtcBIaTw8GWY4aJTnOS/G+zCUAp9bAG/uPMvlqKwP2CEbwxqj7+uPYFIdgMS1aQiBp75opk8rNb0V56l1HT8vkL
 hVlNu4IY
 cpQowQn8bFB2t0V4I8ncq26S+AGQrREisL1u14rS+L81NXyixlK8tQiA1fQjJxiXcrRXrZlEbjjIVWy4jsPm4U3sHsE6wjoHimCm5ocjvZhM8Oqyr+Bl5Dz2PgrRnw421sAPE/UB+eOuumoOtbUd1dyrlhyvyiJM2lb//+cJz6KuQ2rkpRX1Zo6rNHz907n5pHVx8pilNaaKSFL7nykuDi58MfYgOuyUTCVlFyeMoMoR2y0S5kzAfWXPVYKDwqlHvwZlXOQSwGhbbkKMQi4PFC9+rfUyl8VJrYxdVi9hFWjv0GKU45QS6FAVRKrnQN5WKVSjPH6atczaYmktAh2+GBXzH7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB HVO is currently supported on x86-64, riscv64, and LoongArch.
On x86-64 and riscv64, gigantic HugeTLB pages are larger than the
section size, so the existing section-based vmemmap optimization
infrastructure is already sufficient to cover the whole folio.  On
LoongArch, HugeTLB HVO is supported without gigantic HugeTLB pages.

Therefore, boot-time HugeTLB HVO folios can rely on the section-based
vmemmap optimization infrastructure directly, without the extra bulk
optimization and fallback handling.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         | 25 ++++++-------------------
 mm/hugetlb_vmemmap.c | 21 ++++++---------------
 mm/internal.h        | 25 +++++++++++++++++++++++--
 mm/sparse.c          | 23 -----------------------
 4 files changed, 35 insertions(+), 59 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bd136fc6aec0..3cb8fffb9e3e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3201,21 +3201,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	unsigned long flags;
 	struct folio *folio, *tmp_f;
 
-	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_folios(h, folio_list);
-
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
-		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
-			/*
-			 * If HVO fails, initialize all tail struct pages
-			 * We do not worry about potential long lock hold
-			 * time as this is early in boot and there should
-			 * be no contention.
-			 */
-			hugetlb_folio_init_tail_vmemmap(folio, h,
-					OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES,
-					pages_per_huge_page(h));
-		}
 		hugetlb_bootmem_init_migratetype(folio, h);
 		/* Subdivide locks to achieve better parallel performance */
 		spin_lock_irqsave(&hugetlb_lock, flags);
@@ -3238,6 +3224,8 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
 		struct page *page = virt_to_page(m);
 		struct folio *folio = (void *)page;
+		unsigned long pfn = PHYS_PFN(__pa(m));
+		unsigned long nr_pages = pages_per_huge_page(m->hstate);
 
 		h = m->hstate;
 		/*
@@ -3251,13 +3239,12 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		VM_BUG_ON(!hstate_is_gigantic(h));
 		WARN_ON(folio_ref_count(folio) != 1);
 
-		hugetlb_folio_init_vmemmap(folio, h,
-					   OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
+		hugetlb_folio_init_vmemmap(folio, h, vmemmap_nr_struct_pages(pfn, nr_pages));
 		init_new_hugetlb_folio(folio);
 
-		if (order_vmemmap_optimizable(pfn_to_section_order(folio_pfn(folio)))) {
+		if (order_vmemmap_optimizable(pfn_to_section_order(pfn))) {
 			folio_set_hugetlb_vmemmap_optimized(folio);
-			section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
+			section_set_order_range(pfn, nr_pages, 0);
 		}
 
 		if (hugetlb_early_cma(h))
@@ -3274,7 +3261,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		 * (via hugetlb_bootmem_init_migratetype), so skip it here.
 		 */
 		if (!folio_test_hugetlb_cma(folio))
-			adjust_managed_page_count(page, pages_per_huge_page(h));
+			adjust_managed_page_count(page, nr_pages);
 		cond_resched();
 	}
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1305bee1195a..d20d2ce13906 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -599,23 +599,17 @@ static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *fol
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
-	list_for_each_entry(folio, folio_list, lru) {
-		int ret;
-
-		/*
-		 * Bootmem gigantic folios may already be marked optimized when
-		 * their vmemmap layout was prepared earlier, so skip them here.
-		 */
-		if (folio_test_hugetlb_vmemmap_optimized(folio))
-			continue;
+	if (!vmemmap_should_optimize(h))
+		return;
 
-		nr_to_optimize++;
+	if (list_empty(folio_list))
+		return;
 
-		ret = hugetlb_vmemmap_split_folio(h, folio);
+	list_for_each_entry(folio, folio_list, lru) {
+		int ret = hugetlb_vmemmap_split_folio(h, folio);
 
 		/*
 		 * Splitting the PMD requires allocating a page, thus let's fail
@@ -627,9 +621,6 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 			break;
 	}
 
-	if (!nr_to_optimize)
-		return;
-
 	flush_tlb_all();
 
 	list_for_each_entry(folio, folio_list, lru) {
diff --git a/mm/internal.h b/mm/internal.h
index aff7cebb1da4..416afdf7b2ec 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -949,6 +949,29 @@ void memmap_init_range(unsigned long, int, unsigned long, unsigned long,
 		unsigned long, enum meminit_context, struct vmem_altmap *, int,
 		bool);
 
+static inline int vmemmap_nr_struct_pages(unsigned long pfn, unsigned long nr_pages)
+{
+	const unsigned int order = pfn_to_section_order(pfn);
+	const unsigned long pages_per_compound = 1UL << order;
+
+	if (!order_vmemmap_optimizable(order))
+		return nr_pages;
+
+	if (order < PFN_SECTION_SHIFT) {
+		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
+		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES * nr_pages / pages_per_compound;
+	}
+
+	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
+	/* Ensure the requested range does not cross a compound page boundary. */
+	VM_WARN_ON_ONCE((pfn % pages_per_compound) + nr_pages > pages_per_compound);
+
+	if (IS_ALIGNED(pfn, pages_per_compound))
+		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
+
+	return 0;
+}
+
 /*
  * mm/sparse.c
  */
@@ -988,8 +1011,6 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-int vmemmap_nr_struct_pages(unsigned long pfn, unsigned long nr_pages);
-
 static inline int section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
diff --git a/mm/sparse.c b/mm/sparse.c
index 598da1651e49..21a0eb636fea 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -236,29 +236,6 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-int __meminit vmemmap_nr_struct_pages(unsigned long pfn, unsigned long nr_pages)
-{
-	const unsigned int order = pfn_to_section_order(pfn);
-	const unsigned long pages_per_compound = 1UL << order;
-
-	if (!order_vmemmap_optimizable(order))
-		return nr_pages;
-
-	if (order < PFN_SECTION_SHIFT) {
-		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES * nr_pages / pages_per_compound;
-	}
-
-	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
-	/* Ensure the requested range does not cross a compound page boundary. */
-	VM_WARN_ON_ONCE((pfn % pages_per_compound) + nr_pages > pages_per_compound);
-
-	if (IS_ALIGNED(pfn, pages_per_compound))
-		return OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES;
-
-	return 0;
-}
-
 /*
  * Initialize sparse on a specific node. The node spans [pnum_begin, pnum_end)
  * And number of present sections in this node is map_count.
-- 
2.54.0


