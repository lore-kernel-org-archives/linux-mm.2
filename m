Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E3DFD530A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 19:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C072B6B00AF; Fri, 27 Feb 2026 14:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9EAF6B00B0; Fri, 27 Feb 2026 14:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D62D6B00B1; Fri, 27 Feb 2026 14:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 868246B00AF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:30:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F23BBBCF9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:56 +0000 (UTC)
X-FDA: 84491229312.09.A3C2A70
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1D9AA180005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:30:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIFFbamP;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772220654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+21rtgP9mqU6HBO/IylhHqs3PnzOyqvgX3AvZWox4RQ=;
	b=kK48536maMwHSTQDnKrv+7PnFtbJP0wyJGo2vQaeIHS5QIKPm5duXAoPey0mfRk9iQ9lwm
	Dj6A4VAxynPjx3F49nfqnuuM3W4jSfHNzcPZbaGL/+lZ1qtBK3dePZ4OmJqOVCBl6YKKDt
	vhmQIaB5JgjkQ+WJEwH7naO9SHIRA5w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIFFbamP;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772220654; a=rsa-sha256;
	cv=none;
	b=aaodImY8meTzjMqJ24vkglI0I8wVY9Kq3SEkM5Gcbuu3VJYATJV96ZcC9stKsnyOH4PLT5
	wZzuIfIhWNoHQTgtNwRIYzsOC9t9Txx+zqD++y58nBLGfHlH4aywCMe8I9Ze+VqKMOf+hU
	OvmfFpnqZT0Eph/UpQaqiwu3VOASOqo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92E4B60133;
	Fri, 27 Feb 2026 19:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4518CC2BC86;
	Fri, 27 Feb 2026 19:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772220653;
	bh=sftyYYIl4LYwBedYNGdqMNaop3rVqC0b5hlGvUe0QrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIFFbamPzZHt7vs/Qms4n13/Zwx3WMyKXHuawPAfx0chOpCIEPhTCRYriJy7/IOy0
	 ubX8ygwpN5AbjhCjU3zIOTNwzCwYmhZdnofdKfZwN9oVUNwCM7SKsRsf5BrfMheh3h
	 7RTj4knqcA6WJTpvPaqw15AxgJ3BT3JGuVkuxL4ilr4k9+q/5X4DSOXDWisstGVf79
	 zeaD3Sw0r+xG5KXcZPLjbPpa7S8If0aOoLc3sLFLegpC5u6NgtOanG3pJA1/Y3Yb5P
	 eRmtxTtNukx4q0CjqkbZ5BkrulLhlXNLuar2lmDj3veRwz0yA3rW6SHtQ1BZUXXDAh
	 V75iw31XXaj6Q==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 70193F40069;
	Fri, 27 Feb 2026 14:30:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 27 Feb 2026 14:30:51 -0500
X-ME-Sender: <xms:6_Chae0zgCStXMfK74cKvszCgyKspRUqVf8P5-kLc4tUOMs4puYK6w>
    <xme:6_ChaaQTam1cbXgegcNOZbv_KLrDqVjWLToAQNTImojHZmm4qnh8rhs37EsEKt3a9
    n3arWRxntwAzibUvNcKxC0aFkXvwZGBF78P7L9-Nm71GxbD6U5y8e4>
X-ME-Received: <xmr:6_ChaRCWrTQl23ntZy_O1s_fvKS3GTTXxc8ZIAhD7vDrnjVifMCyahLp8LuAgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvgeelkeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhudejfedvgeekffefvdekheekkeeuveeftdelheegteel
    gfefveevueekhfdtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghp
    thhtohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesih
    hnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhm
    rghilhdrtghomhdprhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpth
    htohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:6_ChaQuYntYeSeb_mafJJt7RZOsnx4HHCcPj1-xQ2_faVJa8vbgLhw>
    <xmx:6_ChadCI_3Y0pYkzcjPhsynnw_IZv9CzkvK9IGfOsjHpqR3v_R5ZGw>
    <xmx:6_ChaVKkwzu4Q0geebwVxUXH8eMB60-bvdPpsjVuTRgXTRp8XAxEAg>
    <xmx:6_ChacAK7PvHFnztJ8SkKZxx1zgttL-gbp6U5xmwAoWZnYLYqoQDuQ>
    <xmx:6_ChaerzMCyr8s5ZrGL8fFOo-_ZRVuCMPT5V-Zf3PqRcU216o-WeSwYi>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Feb 2026 14:30:50 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv7 12/18] mm/hugetlb: Remove fake head pages
Date: Fri, 27 Feb 2026 19:30:13 +0000
Message-ID: <20260227193030.272078-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D9AA180005
X-Stat-Signature: qnbpioyc3qmk6jx3t59awms53rg7b9za
X-Rspam-User: 
X-HE-Tag: 1772220653-884720
X-HE-Meta: U2FsdGVkX19Keu0zk56KUcOLhCWQ7UKkXDj4duW8lFxlYCVOcsixlxype2yC1cgamIGbYOgC4h9g+9H3C2+7IUmfbC9V8KXot9TOvGj2kuBTpFPrPL2ZdG2mOO6/WWAZmk7eVNGRtBlX4byvICytk8mzPPgRgN32ewTcWYKv01CSpIKMoSrHqYudVXmL3dmwt1nIRTSm5MndrmMxDyCPSYuCdadKxqZlVnPh2D5zwMsCEoTMai2UnCIG/z0Drdd48Hzy+pe4Kg91SEx/iA9O/cPpCjZ4PALyVGXh8g9qhsJcKWcudEh+ti85+FKPrUMmHaX/YkLwiL5jDuDRlyqu2w+PUrGB6/BoYGCUjE6+SqyuOFxgI+ZkfdNpa0NBok7a7V+vfBEC2YhwRyd3qgQJw30b+brfWwK9DYNSngtD7fS7mCcuPcMoy5o8iP4JBv/ORGKOCYx94FkV+uItQ2NZML53WqFwAGyEFcMJ9QqUutPTQIPw61Qur4LoAAPyWiRRAgnjOnckUOyL0wUlA7f4UQM/V98wjcFRuJJX60XXsddcBqWwl/50cF2KFwoaz39aekrniCMTidykYQ+WRYLd3MGyexjzoFA9oUnJu2EWqvEwJy7kmlnz3Oy4fuDzPXdC+Fa6W5metRAD/8474JKe7rvOHarAsHDvrVwZjq+XUBFzX0geg5ffLpn/RAFC3kPSo021dYGCyuTd5xeiF/iYiCdohqLd0Ou1uaNKHu/BmM0l+YOo4H4Ru5nII3YwjfrpmjiHJXdIl7WC7t0Z0TEDG8TsbnYXOSJpTeEEib+lPMCnLF1DPHoFUL/aiACG5QTf/rXoLDoEQTohvIjE826C7IeJor3M+FgNQqFz3ge9L20UcLkHmnB6DDhILNWvLPl9h0jYrz2sbfUONwmMYzdxkk4OTT7K4nauHAiRMKacN+u7/5DpFvd3AXuZjlraaJgoN3q3WR/u6+3uGiwKmq2
 U1znTzOO
 0kQdlI6Q2XA0fDfpnunZowi9LD/lpvuIS1PJXCy66iLMNWxK9MEQg1ARJ6tSE3jO+N7z5vEa0Wwj//3JkHgY27zj40ADZ4C6UDPX0SX2r27M3mgIO31a5R5UhrVZ5393YbAkGdkWEPVJHG89LDUgskjL3wZ6lQMsTMmUiladaxkxMjDPBffiyoVt5PToPcIdckYyOG5XvgLWIqE4CwrCM9YMMauD3Dr6OgOiiMo0x9OVnVlfdpZY10yZKfRK51LaTKTC2
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
---
 include/linux/mm.h     |  3 +-
 include/linux/mmzone.h | 19 +++++++++--
 mm/hugetlb_vmemmap.c   | 73 ++++++++++++++++++++++++++++++++++++++++--
 mm/internal.h          |  9 ++++++
 mm/sparse-vmemmap.c    | 57 +++++++++++++++++++++++++++------
 5 files changed, 146 insertions(+), 15 deletions(-)

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
index 3628fb5b2a28..92330f172eb7 100644
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
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
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
+			zone = pfn_to_zone(nid, pfn);
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
index c76122f22294..928e79c7549c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -886,6 +886,15 @@ static inline void prep_compound_tail(struct page *tail,
 	set_page_private(tail, 0);
 }
 
+static inline void init_compound_tail(struct page *tail,
+		const struct page *head, unsigned int order, struct zone *zone)
+{
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


