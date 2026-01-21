Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50B65D4694F
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65966B009B; Wed, 21 Jan 2026 11:23:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B456B6B009D; Wed, 21 Jan 2026 11:23:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BE626B009E; Wed, 21 Jan 2026 11:23:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 85D8D6B009B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D2678C481
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:19 +0000 (UTC)
X-FDA: 84356490918.20.2B44A53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F9A440008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sEMFbroh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012597; a=rsa-sha256;
	cv=none;
	b=GgMtZeEiuqrSz609kHjDE0aG/vMzX+pYh6IZe85J0vweE9cI22B6t/lUXv2Gs3JOEtKaF2
	e5n8bYtRuxlb8poELrnoS3qk6ODufZevcR/uebIGcf0Q4ypwBQRQr+Jp4uzs8cn8U6QPdn
	ZEhAuM+LWeDz91423J3vYAshMgo9MRw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sEMFbroh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEAn9lAZKD7qz5esIzLLn95/lP5VlsbKvVVv12/AFsU=;
	b=XYUPZRY3mKatLLGqPY6O4UXu4nVEd1yjrHm1KVDjhEsOnHtqAa1Cl/ZnB5SNa7K/WZbD00
	jYdZYKN8B9SgAKAVyiwF6T1xIh7dTem/ZHsboQQKEGHCRdf75ZYkL80OfIuBulBe/CyI+c
	aoiIFgwj8savO2aVHwUdVfTOohDqGRs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7263541978;
	Wed, 21 Jan 2026 16:23:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3A9C19424;
	Wed, 21 Jan 2026 16:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012596;
	bh=DsOOnID5BsY5gweo7veZo7bh9WLbOqa0BuVHiVgozn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEMFbrohHxxkkpM/bu6I6h1gLZdULc3zhpxY6M280Uyg/ZlAQHL1I2P71TtPgHlMb
	 B4ipV7eHV8rYGlcMekIlJNUhLmkKCZcK82VUu6XmQGst7oC1iq7h0bp5Tii9aIgRqD
	 RzkfDa5YSxavS928Nkk1btw8fZWt68tYz7rpWT5u9NDH77YCRimI6gVFd3vRyhK0j5
	 Owv4b8zwGtZ2bgq3Lz5cTC0O6kx6eKDzIPaQuYKq3dyajzwTVHUVDE3b6bcso6rYQE
	 yNM+Pfvfa17Sz9XdWvSSygPQqHfhYbbI7CnN6iv27m2clU4RiwidQb0pLh/S6Vf67J
	 kJffNcI7SeMnw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2F581F4006B;
	Wed, 21 Jan 2026 11:23:15 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 21 Jan 2026 11:23:15 -0500
X-ME-Sender: <xms:c_1wabOU-xu2RdKWzDK_7jJiD7vYXsofCjMLbZOfnYgP2Y-Ne5dumA>
    <xme:c_1waVNacWXHWeSm2kbgY4Iodb7gmm8W3gBUD02aUG6vMk8XCGhh6g_02gJB5XS2U
    07lG88XfH1KfvD1zOf6T5e1KuOKFARSGI3Gw7qj5TTdPZOLxANJQkA>
X-ME-Received: <xmr:c_1wadH7TGFHMFjTS90m8URUEADiiXxgvjJFveDMGTA39VI6qDwhcvNhsail0g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:c_1waXPVgncYhV_HonqRBpHb7gP7pPZ-haFSNh-nrifL4dNjziojqw>
    <xmx:c_1waXt8yiFpunqlzmANKSYQdStPZwOdAJiYxghFhtwkAErA1phr6w>
    <xmx:c_1waUXRdJbtcA4CwbSY-7EX2Tee4gnkPFJOheIEErvqnvyGOuBKSQ>
    <xmx:c_1waWT_cM64Rg_0vI9Lr8pyN6tjdBDkXcxdDPlQKcpefyWS4DN1ew>
    <xmx:c_1waaJ_M-eGOVTp2F6NOpWemgCwlXC2eHg0hvkbTSOasrDNX0axfvfr>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:14 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
Date: Wed, 21 Jan 2026 16:22:46 +0000
Message-ID: <20260121162253.2216580-10-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F9A440008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: r6aa8ymnt7ghyz6eogiu3jd71qiua6n4
X-HE-Tag: 1769012597-743501
X-HE-Meta: U2FsdGVkX19MVSaBNgxKEQuyWrdnycHN3ouextwr4OcmmEd0NZAZc9dtMny/e8nsZLnleGyLfUg2CfX9TjD+oHSXcTA1SgoXJZroW6dQqqSuAbss+/dk8AeoRFVNNoMuaZ5F9gpWfS5pF1EnAycDdZ4k0WM894hqroj9YRWktOfdocGBunsXq2RJt4DhAdd0lRCDQuXfPYvTci6Vi0Rkpzv24qaU9cZpTPMO1oQlSfVRdIMmhckYhidsVMDJS4Ga+A/h8Iv8hDNHcSbxEK8tWPibBZCAW5iHW5+D6EjEMQBqZWc5Dgdq9Xm7pVxL2yDCBmNKIbT2JShG3K4z/4te6mzNvGH1LFMIu1HwRkLmKS1FqYN98neqlm7zaP1ALqu6FkTNZMnlR/OvjhhN+jvr/py0VSqZGNZubYubsalHFq30eddDaf5knU8eWbKJSHIFVMn3WXYP3j8hsF7MC4tP0sbkAt+oi3uvz5FTgAMGYmTMQiX0f0o1pK3Ko5mFxSGWk9d3iFzcgl5nl9L3ZYgtEqDyAJTbHhDudgIXmJRjBiYArZ/c9eIxF1hi/OHjQ7mavwfEoPwd37Tu9qipR219p98hxAgRLDVliXB9X02gQ/Y8wrqMqgEojUekml+Xa71g6O0orG9CaanBctBWs5ZKk/S+3n9h/42FY6Ye3Gk2i4bR2MpdocG5cYHbsfdCUS2xfWSBSu4uXIibSLh2bgj7AYnsh6wVkcfU6jDpldQbqiK0PFWO21aDA09Q57ZD41D+YmnPVLCyHn+lgWuZukKKChcxaMS5LwK62ui07OYY1BIiB6T+rNR2ywPELvmQMFjyi3napgLXlbOkZdHTx6m1RQM0UhzPKgsn7+xBV1LlUZJ8yE4hu8rkWp08kvfoWupHOHt4TJJQHCYtMKYLzvUtrSuZkzfAq40l6tH6t1xjUcQc6CVSjGPtM6DImnvKs5M5NYQz62yqb+/94P2xOzM
 TeBHui7e
 DJ2znFlwc2MZry66twgZMcUgkDtBsDKpuzUP/6S1IRzvKf8rHNKgIRJ2yVCiTLdkZgtaXgk3gJ6CPmKtpeGhbXFeGLxfdmv3f6w3scv+h96txW6yH9Kw08f7+IAMR1NKHuRUQ8vVw/G84/mtdCY7GTHTO/v3j08MpNx8zWFXkXaOodoDcZGJLhM7BctsYDZxoSRls1+rohuSGDTLE4Q7Cb5Ajoxr6FxlHMKvtOvDcRv08H0wvoMPclEXdYHt9my61Iq1S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
vmemmap pages for huge pages and remapping the freed range to a single
page containing the struct page metadata.

With the new mask-based compound_info encoding (for power-of-2 struct
page sizes), all tail pages of the same order are now identical
regardless of which compound page they belong to. This means the tail
pages can be truly shared without fake heads.

Allocate a single page of initialized tail struct pages per NUMA node
per order in the vmemmap_tails[] array in pglist_data. All huge pages of
that order on the node share this tail page, mapped read-only into their
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
 include/linux/mmzone.h | 18 ++++++++--
 mm/hugetlb_vmemmap.c   | 80 ++++++++++++++++++++++++++++--------------
 mm/sparse-vmemmap.c    | 44 ++++++++++++++++++-----
 3 files changed, 106 insertions(+), 36 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7e4f69b9d760..7e6beeca4d40 100644
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
@@ -1407,6 +1411,13 @@ struct memory_failure_stats {
 };
 #endif
 
+/*
+ * vmemmap optimization (like HVO) is only possible for page orders that fill
+ * two or more pages with struct pages.
+ */
+#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
+#define NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1555,6 +1566,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a51c0e293175..51bb6c73db92 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -231,36 +232,25 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 	set_pte_at(&init_mm, addr, pte, entry);
 }
 
-/*
- * How many struct page structs need to be reset. When we reuse the head
- * struct page, the special metadata (e.g. page->flags or page->mapping)
- * cannot copy to the tail struct page structs. The invalid value will be
- * checked in the free_tail_page_prepare(). In order to avoid the message
- * of "corrupted mapping in tail page". We need to reset at least 4 (one
- * head struct page struct and three tail struct page structs) struct page
- * structs.
- */
-#define NR_RESET_STRUCT_PAGE		4
-
-static inline void reset_struct_pages(struct page *start)
-{
-	struct page *from = start + NR_RESET_STRUCT_PAGE;
-
-	BUILD_BUG_ON(NR_RESET_STRUCT_PAGE * 2 > PAGE_SIZE / sizeof(struct page));
-	memcpy(start, from, sizeof(*from) * NR_RESET_STRUCT_PAGE);
-}
-
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
 	struct page *page;
-	void *to;
+	struct page *from, *to;
 
 	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
 	list_del(&page->lru);
+
+	/*
+	 * Initialize all tail pages with the value of the first non-special
+	 * tail pages. The first 4 tail pages of the hugetlb folio contain
+	 * special metadata.
+	 */
+	from = compound_head((struct page *)addr) + 4;
 	to = page_to_virt(page);
-	copy_page(to, (void *)walk->vmemmap_start);
-	reset_struct_pages(to);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++, to++) {
+		*to = *from;
+	}
 
 	/*
 	 * Makes sure that preceding stores to the page contents become visible
@@ -425,8 +415,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start += HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -517,6 +506,41 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
+static struct page *vmemmap_get_tail(unsigned int order, int node)
+{
+	unsigned long pfn;
+	unsigned int idx;
+	struct page *tail, *p;
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
+	if (pfn)
+		return pfn_to_page(pfn);
+
+	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!tail)
+		return NULL;
+
+	p = page_to_virt(tail);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	spin_lock(&hugetlb_lock);
+	if (!NODE_DATA(node)->vmemmap_tails[idx]) {
+		pfn = PHYS_PFN(virt_to_phys(p));
+		NODE_DATA(node)->vmemmap_tails[idx] = pfn;
+		tail = NULL;
+	} else {
+		pfn = NODE_DATA(node)->vmemmap_tails[idx];
+	}
+	spin_unlock(&hugetlb_lock);
+
+	if (tail)
+		__free_page(tail);
+
+	return pfn_to_page(pfn);
+}
+
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -532,6 +556,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
+	nid = folio_nid(folio);
+
+	vmemmap_tail = vmemmap_get_tail(h->order, nid);
+	if (!vmemmap_tail)
+		return -ENOMEM;
+
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
@@ -549,7 +579,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	nid = folio_nid(folio);
 	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
 
 	if (!vmemmap_head) {
@@ -561,7 +590,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index dbd8daccade2..94b4e90fa00f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -378,16 +378,45 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-/*
- * Populate vmemmap pages HVO-style. The first page contains the head
- * page and needed tail pages, the other ones are mirrors of the first
- * page.
- */
+static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
+{
+	unsigned long pfn;
+	unsigned int idx;
+	struct page *p;
+
+	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
+	BUG_ON(order > MAX_FOLIO_ORDER);
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	pfn =  NODE_DATA(node)->vmemmap_tails[idx];
+	if (pfn)
+		return pfn;
+
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return 0;
+
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	pfn = PHYS_PFN(virt_to_phys(p));
+	NODE_DATA(node)->vmemmap_tails[idx] = pfn;
+
+	return pfn;
+}
+
 int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 				       int node, unsigned long headsize)
 {
+	unsigned long maddr, len, tail_pfn;
+	unsigned int order;
 	pte_t *pte;
-	unsigned long maddr;
+
+	len = end - addr;
+	order = ilog2(len * sizeof(struct page) / PAGE_SIZE);
+	tail_pfn = vmemmap_get_tail(order, node);
+	if (!tail_pfn)
+		return -ENOMEM;
 
 	for (maddr = addr; maddr < addr + headsize; maddr += PAGE_SIZE) {
 		pte = vmemmap_populate_address(maddr, node, NULL, -1, 0);
@@ -398,8 +427,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
 	/*
 	 * Reuse the last page struct page mapped above for the rest.
 	 */
-	return vmemmap_populate_range(maddr, end, node, NULL,
-					pte_pfn(ptep_get(pte)), 0);
+	return vmemmap_populate_range(maddr, end, node, NULL, tail_pfn, 0);
 }
 
 void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
-- 
2.51.2


