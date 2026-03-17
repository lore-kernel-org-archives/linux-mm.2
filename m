Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B425EFD8746
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274406B0005; Tue, 17 Mar 2026 07:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2251C6B0088; Tue, 17 Mar 2026 07:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 114466B0089; Tue, 17 Mar 2026 07:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE91E6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:47:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6920140120
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:47:45 +0000 (UTC)
X-FDA: 84555380490.19.7B52503
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A1EE9120010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:47:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LMgFvu9F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773748063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldjr9jl3+0UuxjdlN/jzybK7A57q6oxnK6lplC/nwX4=;
	b=diEP6nbD5tlWCYBjGZJJehYKXDAaVrBJq03Sf0IV/Pkn7suYRiDg3PJPnphOrLRgJFRVnA
	ga3HLoQgvWchi1/KOcQ1ww3ytL+Lg87kEdbyYoWEE4ydxbMR6rEEkVZiA0fi4jiMIL1grp
	jLUEntZgVsxVh0YTNbKJ4CdfwQ5ly/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773748063; a=rsa-sha256;
	cv=none;
	b=L25dQWqlMHj8btA/9fwh356Bpz25NKDF9tWuWC+wtScl5EvKGrBP3S9IKVOIwHpepmBicZ
	pHCPpJfuH00mSmYPS6byfEONLlxGqUdRsdYwxoxfukhjCNUoJjgZib+BHmRaOeWgnLHl+j
	9PWDppKLDU/4mL+o668anzEWkM1LCeM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LMgFvu9F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6D964378E;
	Tue, 17 Mar 2026 11:47:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E2AC4CEF7;
	Tue, 17 Mar 2026 11:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773748062;
	bh=7uI3sZsbI/asoDP3ipVmP/m6CZdFxisukQ5cHQaHucM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LMgFvu9FU9askm1BvrDjNAEUL04XuJ31QM6qV13iSW214ZQbnJVyMLrhfI5NXKIGu
	 BPvaKj6/iPHOmmtIpuubVwXikwy4TCFDhbPFPYJY3t4/iaDZXVjAm2Fw8/Tkzhe0+I
	 1R1aRH/6DAwFHGeXXzkG+WYRicztHA4JY4TwsUlgFyiA4MTGgYBF75/eXzt+f6RsIC
	 hmZwl1HPk16ug/vqZ2JFaI6LJ1qVxDAeAT5USnlG6lkxq00+UCQsqrj831MniqsdEH
	 AhIRVUYDyPvRUpRelfcyq3ZajvDK7IN+CI8kWi13uPOctYbyoAaW8fl/y2jgdyYifQ
	 hAIxUmM6LCccg==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 18A95F4008E;
	Tue, 17 Mar 2026 07:47:41 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 17 Mar 2026 07:47:41 -0400
X-ME-Sender: <xms:XT-5aU0Mm6LGtgR9kv86-Mtk6XyaBZHfx5XZMtqUilaTdDFLU_oepw>
    <xme:XT-5afNKFRTeuTbq-k1Odd2m-qSj7Vo5O15kwWhA4BLeVACC_T8U-sH2iJlBEc1eM
    kUyJDbtirqGmm6gMz9x5KmCb2PeorT3wRqUGKJ9EzGizB7_vS8xyg>
X-ME-Received: <xmr:XT-5aauZQXsEu7dSi42lJZFfvjN8wBxId5c0Gqc0O63kXd2kQXUXl8SAPQeZJg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdduudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegote
    eftdduqddtudculdduhedmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokh
    grsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekffef
    vdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghu
    thhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhkrg
    hspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphht
    thhopedvledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgrsheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdr
    ohhrghdprhgtphhtthhopegrlhgvgiesghhhihhtihdrfhhrpdhrtghpthhtoheprghouh
    esvggvtghsrdgsvghrkhgvlhgvhidrvgguuhdprhgtphhtthhopegshhgvsehrvgguhhgr
    thdrtghomhdprhgtphhtthhopegthhgvnhhhuhgrtggriheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheptghorhgsvghtsehlfihnrdhnvghtpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfhhvughlsehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:XT-5aSFPl_Kenod8IgaXD0xcOHWy_GmUczp69xeZekceBnBWNvDv5A>
    <xmx:XT-5aVQFCiZ7kkiq6kMMgzn9xuPrYvfqYLK8Y_Gw0V1O_ZHxyiG-7g>
    <xmx:XT-5aWiwA6TUb7QFBP77q1nrbCZduMPbThS1TgwuGux7Q9OKiRxDbQ>
    <xmx:XT-5aZayYdlnuMtvet7YeOqrxEaeMydvnVSjiKn1uQkunaUo5OM86w>
    <xmx:XT-5aXXP5gQ8GLy2Xjxf0O7VlI1E4j-TUlMlYI_j4tBcK0O2KDhruQaL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Mar 2026 07:47:38 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	alex@ghiti.fr,
	aou@eecs.berkeley.edu,
	bhe@redhat.com,
	chenhuacai@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	kernel-team@meta.com,
	kernel@xen0n.name,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	rppt@kernel.org,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	willy@infradead.org,
	ziy@nvidia.com,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCHv7.1 12/18] mm/hugetlb: Remove fake head pages
Date: Tue, 17 Mar 2026 11:47:29 +0000
Message-ID: <20260317114729.138321-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227194302.274384-13-kas@kernel.org>
References: <20260227194302.274384-13-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1EE9120010
X-Stat-Signature: 3dkyhz4t77hx96gjhnxh5wi6ep7cjxyc
X-Rspam-User: 
X-HE-Tag: 1773748063-493747
X-HE-Meta: U2FsdGVkX1+rt7JpcF0+fFICgD5OcdJY0oJAoR1XBNcWjfyt1ezdQtK49KdCO7WDpn7PlXhtzapNTmhh3yoN+lUratLos1Fr+5sDC8u42H4MbwVZ9dGWgR9Cb3xVUeQpdDl/yxDjA2+N6i3oleUgniG1fncDLltwaDLC8O4oR3RdzXGBlViBtnZyYznjOiUziPOMlwpSQdZeb+F2t47OxrO/tgsScyTDLsykZl25mFyvZEOWuonwXo/iN6HG0va+F001aXQ2uYuBiDPnfrkE7ewmZN/GQTFgUtIUfOQOtuDL/XmcBYcmcPXbKlabFxbCmjDOoUjcjkyqKJAtsofwehJ0Li9LQnj/0tE/2E23pT96rElRWdfMHllGYUf+sI1mCNNF11OfhlzUSws2+Fblfpyg4r4PMiQkHQmhNXchrlvlu+wmbw1yoM15fwCUKjoxu3caaS5UBnFWtTm5RwF/nnXj5wBQB8hoYUEhG97OdJzHofaeYThFPoRCm76sJr6wZIcrb0D1k28OeNH1vYVBahTiN/1RkkYS5qVnmEui7nabCKXRqJVDXwuGYICZN8vR0eo7kL7MZOgUAMKu5L8uz35k3YtOrFmaOptxb4bo/SNRZoogl3aI8JAFR2xNuopiYzL70fuSc7DrehvGV76+MvNPFNfTE6Dqy5jz7lz3FSoC6Oh7G0Qjb8mpWq7jF6n0OUdTQ6tN0+e1lMsxAOo1RlaK4ARlFZGFytFm5z9bZLqpFpVM5O6Z6DpyUK9587yegKtmyJS8PDrhGkqMWEsgSRjMk1qyLzYoznhpkjiwHuAEXlqp96rIatvgHOd2i/lJOsD5gD5iumM92fHAVgzfKQ9+g2EMhps4CzriI6GOe5HjOnER632wkiyFGBnRHDaLuBzpzmsYfAAVs03DatxVlo1sLzyNU/PccpJ3tgAaV4jq8j9usugD4zPn78Nvc+3NNAWwtZuc19pSnAAs5VR
 aTB6V/NQ
 eULLoug5CgHPoL0zMGHSnyYbNQwaeE2iyzhTSiw9L4kTwWXUTnoZ3jNcDXO/kP7v2pi30c5fvdaOy2wSTpwO6J9WP2vJ80V75v1UqB+Mf6g2D+Lda6zCibrlpDbYwc3K1D/eD/8vh/ld6KKElMNTkqIKRhgdXvXgHngHI9HYkDz8rtvZ1Y0rlAhyasWedZii/oVOq8XvjGJ9E8PszcvoAnSEKzWnhRlqcPenObA0HzP7ggkyTJnu2lP7R012TM7T4gs9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
vmemmap pages for huge pages and remapping the freed range to a single
page containing the struct page metadata.

With the new mask-based compound_info encoding (for power-of-2 struct
page sizes), all tail pages of the same order are now identical
regardless of which compound page they belong to. This means the tail
pages can be truly shared without fake heads.

Allocate a single page of initialized tail struct pages per zone
per order in the vmemmap_tails[] array in struct zone. All huge pages of
that order in the zone share this tail page, mapped read-only into their
vmemmap. The head page remains unique per huge page.

Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
compile-constant as it is used to specify vmemmap_tail array size.
For some reason, compiler is not able to solve get_order() at
compile-time, but ilog2() works.

Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
<linux/pgtable.h> which generates hard-to-break include loop.

This eliminates fake heads while maintaining the same memory savings,
and simplifies compound_head() by removing fake head detection.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h     |  3 +-
 include/linux/mmzone.h | 19 +++++++++--
 mm/hugetlb_vmemmap.c   | 73 ++++++++++++++++++++++++++++++++++++++++--
 mm/internal.h          | 10 ++++++
 mm/sparse-vmemmap.c    | 57 +++++++++++++++++++++++++++------
 5 files changed, 147 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0e2d45008ff4..883af2cb4e3c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4482,7 +4482,8 @@ int vmemmap_populate_hugepages(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap);
 int vmemmap_populate(unsigned long start, unsigned long end, int node,
 		struct vmem_altmap *altmap);
-int vmemmap_populate_hvo(unsigned long start, unsigned long end, int node,
+int vmemmap_populate_hvo(unsigned long start, unsigned long end,
+			 unsigned int order, struct zone *zone,
 			 unsigned long headsize);
 void vmemmap_wrprotect_hvo(unsigned long start, unsigned long end, int node,
 			  unsigned long headsize);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 492a5be1090f..610c9691fb47 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -81,13 +81,17 @@
  * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
  * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
  */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#ifdef CONFIG_64BIT
+#define MAX_FOLIO_ORDER		(ilog2(SZ_16G) - PAGE_SHIFT)
+#else
+#define MAX_FOLIO_ORDER		(ilog2(SZ_1G) - PAGE_SHIFT)
+#endif
 #else
 /*
  * Without hugetlb, gigantic folios that are bigger than a single PUD are
  * currently impossible.
  */
-#define MAX_FOLIO_ORDER		PUD_ORDER
+#define MAX_FOLIO_ORDER		(PUD_SHIFT - PAGE_SHIFT)
 #endif
 
 #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
@@ -103,6 +107,14 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
+/*
+ * vmemmap optimization (like HVO) is only possible for page orders that fill
+ * two or more pages with struct pages.
+ */
+#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
+#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
+#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -1099,6 +1111,9 @@ struct zone {
 	/* Zone statistics */
 	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
 	atomic_long_t		vm_numa_event[NR_VM_NUMA_EVENT_ITEMS];
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } ____cacheline_internodealigned_in_smp;
 
 enum pgdat_flags {
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 3628fb5b2a28..a2664e230333 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -505,6 +506,32 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
+static struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	const unsigned int idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	struct page *tail, *p;
+	int node = zone_to_nid(zone);
+
+	tail = READ_ONCE(zone->vmemmap_tails[idx]);
+	if (likely(tail))
+		return tail;
+
+	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!tail)
+		return NULL;
+
+	p = page_to_virt(tail);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		init_compound_tail(p + i, NULL, order, zone);
+
+	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, tail)) {
+		__free_page(tail);
+		tail = READ_ONCE(zone->vmemmap_tails[idx]);
+	}
+
+	return tail;
+}
+
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -520,6 +547,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
+	nid = folio_nid(folio);
+	vmemmap_tail = vmemmap_get_tail(h->order, folio_zone(folio));
+	if (!vmemmap_tail)
+		return -ENOMEM;
+
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
@@ -537,7 +569,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	nid = folio_nid(folio);
 	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
 	if (!vmemmap_head) {
 		ret = -ENOMEM;
@@ -548,7 +579,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
@@ -776,11 +806,26 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	}
 }
 
+static struct zone *hugetlb_early_pfn_to_zone(unsigned nid, unsigned long pfn)
+{
+	struct zone *zone;
+	enum zone_type zone_type;
+
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		zone = &NODE_DATA(nid)->node_zones[zone_type];
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 void __init hugetlb_vmemmap_init_late(int nid)
 {
 	struct huge_bootmem_page *m, *tm;
 	unsigned long phys, nr_pages, start, end;
 	unsigned long pfn, nr_mmap;
+	struct zone *zone = NULL;
 	struct hstate *h;
 	void *map;
 
@@ -814,7 +859,12 @@ void __init hugetlb_vmemmap_init_late(int nid)
 			continue;
 		}
 
-		if (vmemmap_populate_hvo(start, end, nid,
+		if (!zone || !zone_spans_pfn(zone, pfn))
+			zone = hugetlb_early_pfn_to_zone(nid, pfn);
+		if (WARN_ON_ONCE(!zone))
+			continue;
+
+		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
 					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
 			/* Fallback if HVO population fails */
 			vmemmap_populate(start, end, nid, NULL);
@@ -842,10 +892,27 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
+	struct zone *zone;
 
 	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
 	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
 
+	for_each_zone(zone) {
+		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
+			struct page *tail, *p;
+			unsigned int order;
+
+			tail = zone->vmemmap_tails[i];
+			if (!tail)
+				continue;
+
+			order = i + VMEMMAP_TAIL_MIN_ORDER;
+			p = page_to_virt(tail);
+			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
+				init_compound_tail(p + j, NULL, order, zone);
+		}
+	}
+
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
 			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
diff --git a/mm/internal.h b/mm/internal.h
index c76122f22294..8c2ce3e16fd7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -886,6 +886,16 @@ static inline void prep_compound_tail(struct page *tail,
 	set_page_private(tail, 0);
 }
 
+static inline void init_compound_tail(struct page *tail,
+		const struct page *head, unsigned int order, struct zone *zone)
+{
+	set_page_count(tail, 0);
+	atomic_set(&tail->_mapcount, -1);
+	set_page_node(tail, zone_to_nid(zone));
+	set_page_zone(tail, zone_idx(zone));
+	prep_compound_tail(tail, head, order);
+}
+
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 032a81450838..842ed2f0bce6 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -325,16 +325,54 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-/*
- * Populate vmemmap pages HVO-style. The first page contains the head
- * page and needed tail pages, the other ones are mirrors of the first
- * page.
- */
-int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
-				       int node, unsigned long headsize)
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+	int node = zone_to_nid(zone);
+
+	if (WARN_ON_ONCE(order < VMEMMAP_TAIL_MIN_ORDER))
+		return NULL;
+	if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER))
+		return NULL;
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	tail = zone->vmemmap_tails[idx];
+	if (tail)
+		return tail;
+
+	/*
+	 * Only allocate the page, but do not initialize it.
+	 *
+	 * Any initialization done here will be overwritten by memmap_init().
+	 *
+	 * hugetlb_vmemmap_init() will take care of initialization after
+	 * memmap_init().
+	 */
+
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return NULL;
+
+	tail = virt_to_page(p);
+	zone->vmemmap_tails[idx] = tail;
+
+	return tail;
+}
+
+int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
+				       unsigned int order, struct zone *zone,
+				       unsigned long headsize)
 {
-	pte_t *pte;
 	unsigned long maddr;
+	struct page *tail;
+	pte_t *pte;
+	int node = zone_to_nid(zone);
+
+	tail = vmemmap_get_tail(order, zone);
+	if (!tail)
+		return -ENOMEM;
 
 	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
@@ -346,8 +384,9 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 	 * Reuse the last page struct page mapped above for the rest.
 	 */
 	return vmemmap_populate_range(maddr, end, node, NULL,
-					pte_pfn(ptep_get(pte)), 0);
+				      page_to_pfn(tail), 0);
 }
+#endif
 
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 				      unsigned long addr, unsigned long next)
-- 
2.51.2


