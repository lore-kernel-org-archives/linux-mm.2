Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5355D2F006
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DFB6B00A7; Wed, 28 Jan 2026 08:56:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C676B00A9; Wed, 28 Jan 2026 08:56:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0376F6B00AA; Wed, 28 Jan 2026 08:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5F436B00A7
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:56:43 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC80A1B0FB9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:43 +0000 (UTC)
X-FDA: 84381523086.02.9BB41D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F146A000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:56:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lk2v3jW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769608601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0MEXP/It8vw7ovmJxqjR369tgVo7rf5IJQ+buml6HQ=;
	b=HrGsVnsQmk5g0D6VFuko/r2SaKrtxQJpVYSt61XoK9iHRAMP18SI9+kaxwY71Nrv1/tZL9
	85nrHfPk2+jK1+9xxNPrvxrKpB/2eONv3s7pAWBHKEzrgeAZ3cNHZvyOue3emRn9n8lJ8c
	wRQCfclCuxUXVULj7FZVVACH9I6IrYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769608601; a=rsa-sha256;
	cv=none;
	b=XF55ktu1dhgIAc801s2oktq5XTzzR6kt411BDIMrGjGp979VwaApItH8r0lgNDJA4oB58W
	62wpOzfEF+mhhHE2NwVHkraJSLlmYAatBRvQE19Y1hmJqHSTVgq4z1Uz7X3UJeIYNZuGCP
	4tJXFSsidN2jsg5Sjqdns5ldbcssh3c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lk2v3jW5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A96E240398;
	Wed, 28 Jan 2026 13:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A436BC4CEF1;
	Wed, 28 Jan 2026 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769608600;
	bh=fFTi7KqVHkyzr/PBaMlC7COar//pupZ4efF1BKAMSd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lk2v3jW51BQX0bHMHMocn8xHUJUaqSrGMtQJsEKZTAllkq9A1Ie419HiLwTpjpT7c
	 ASsFepRjT98/qHQyM+ctFYlYows84iLjA/YYBXHbb5RiL0BxyVIs4EVAXextzQfMqz
	 /IPL6A4srRg9wxjTFGwe70od2Ol9/T/8ybaaum8aS75bMRsXaLnSn4kkVvXTr0dJvL
	 0dDK1tNJrz02HBKd7B/cPfcX8mZMklUEfLiI0But8y/2iv6iQuJh5+D5x6PaZNjZBL
	 +hykQIkRjWNkSx+QJTs2HbLUDG2QEQYMHv0PmFuhE0ihLNpa0WeckjhGL83V+IQ6V4
	 bEJWp8UE8dHKA==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.phl.internal (Postfix) with ESMTP id CD825F40069;
	Wed, 28 Jan 2026 08:56:38 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Wed, 28 Jan 2026 08:56:38 -0500
X-ME-Sender: <xms:lhV6aRW4A-oyYv2uobQR6-7ykMxoBiJKcRWTtzOj_uumKAmO17inzw>
    <xme:lhV6aaxIBTRENn8wqscR6YUGztPIHeoB1KkFSIoVmNAtnl9U2kmtoyas8RGJ2zsKx
    B49Am4NvAE9gbjnu1b26-ONRl8mlhusKL8DDgSA0nouaE0H1kLAzBBy>
X-ME-Received: <xmr:lhV6aXhayAmSFV9uXDKaNCZ0VIk4_Uy_cVyWR2hSHkoqR4POQ7QHflNpDpI8HQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefheegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdekpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoh
    epmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgu
    sehrvgguhhgrthdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurd
    horhhgpdhrtghpthhtohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhr
    tghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehoshgrlhhvrg
    guohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehvsggrsghkrgesshhushgvrdgtii
X-ME-Proxy: <xmx:lhV6aVOoWd_2hGBeC46klZJfm7p5gYCpOkW9gSKVZQUQBT6MZBe3eQ>
    <xmx:lhV6aXgnprHDbrLiDADJJg2qGhlEgupPOkHh2l6gRpNXCtA-qeNFBQ>
    <xmx:lhV6adohINp5uggQdxMgiCzGlkFU6zMmx0sC3FI55c-i8S9ZtLKj1Q>
    <xmx:lhV6aaitdSvFe1SJE3dCb8OhpiemLeNkPx7wFd7ZQGL9hkK6fi9FSA>
    <xmx:lhV6abLAB3DHyekDtKEHvgSTuaPtRPCvz3Gk8_WjPJLy1L02qefgt2RW>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 08:56:37 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
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
Subject: [PATCHv5 11/17] mm/hugetlb: Remove fake head pages
Date: Wed, 28 Jan 2026 13:54:52 +0000
Message-ID: <20260128135500.22121-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260128135500.22121-1-kas@kernel.org>
References: <20260128135500.22121-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9F146A000B
X-Stat-Signature: zn1fnhdcsr4sziyr4sfqt8z1tkbiu3g5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769608601-220285
X-HE-Meta: U2FsdGVkX1/SSxM4BSJqkGKG6GFlg3cnW5+dNU7Es9SDfhISxHMD6l1MR7QbqXJmlBgAT4F4PsZN3HxQKh9qzpysg3lVc34jjig7DJVvgeUj19RabCwRusrKvtsH0V/WWOlGgK9n/NQr2ohnrSe/wdY9RAID+G1JCysj7eQK79ld9lyp0RTNrtk26CaoSI5duZcI484VriFctci0fnPysraPMMVS+0ASwrePoucyduSkRmakPMlGbckX/J2Y7kXhuHzgRfleK2PE3iBwle93T/kYVHEmPmoY+kw6F5X0u5+29nSawRLbzQU36mo4ggDYauoTibTbN+locyl0MfFvj12wYQgcC7Oo4c/ZmmE27bEaJjXdU3ijk8phRcqBqHR2x3yiiJH0EoF6psM7N4AwGXyAydz8GR9i0XF0D/eqsvtXleNz0ssBcXrCqK4Gd1mjOXsnYMoLYJWnTNchGjyyHqrQrJ509IjYBPF9k8ndse7Bonzk071UDdCNnJYT57OxTKsfcSkicVxWwE4HwY3euUH4E2I32AzcNWjU8Xb4a7ttthpD9VmlbpoKXPBW7Kqfyi/OzJ/VH61mVqhKrM+2fcUPzs8RMwdrTHhSydqo7Gb9GS+fge14CwgZBU8Zr1Oo4e9HYyH5Nfn661QSG3ssTi2C4/lQr1q+6u4cp0JGpQbBeXvurdQQ/9sYltwVv570KspTU7ke5qI4dpcLciBveOEI6xpm80S4wWSmWkyBjPwQr3xUFP2QHP3xfKIZzj0/nwzBB+ZJgcOEkkIzOd3uzIY99aHGBfZ+kN7MervqrwbBMjuBgubHUX6rbFfstGDDe1oBHD8d7uQycmWpmbwouwVUGcFr1KXVJAJYL4TfAZJ08Het5TvAaY+C6CQBW6xoTIXSAUiqB96EV9iUm7CJWcKRRQDOkMBwXai5eIrX4FSWFy7XDOCI1IrhX2LCSNCKa6p0FClTPrnPsjYx3s0
 T+Zq1PYy
 AeV2XsmCChS/ol5Nc1kzv327Ij2tcoSI3uTJKaNo3XcSBuV21k2qWO06zP7mtUsb2pOSFbz5VZqUsEhBilB/o291vtHA09Y4qvYTbcgiEP37uaqVctnamwpx59ptcLrUp0lI09LeqoLs55YBPWcl9za2H6nm2O0n7WzBx1+NU+4KBdIIhgWCorNinvF9/qllsXaFqRG1bZg0FmWDos2Dt3TWU0ZHMamuAHaZG6SeOpuCOJCGhyCgFIytkLviPY9qPK9Pe
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
 include/linux/mmzone.h | 18 +++++++++++++++--
 mm/hugetlb_vmemmap.c   | 36 ++++++++++++++++++++++++++++++++--
 mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 192143b5cdc0..698091c74dbb 100644
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
@@ -1402,6 +1406,13 @@ struct memory_failure_stats {
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
@@ -1550,6 +1561,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a39a301e08b9..f5f42b92dd7d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -505,6 +506,34 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
 	return true;
 }
 
+static struct page *vmemmap_get_tail(unsigned int order, int node)
+{
+	unsigned long pfn;
+	unsigned int idx;
+	struct page *tail, *p;
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	pfn = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
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
+	pfn = PHYS_PFN(virt_to_phys(p));
+	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], 0, pfn)) {
+		__free_page(tail);
+		pfn = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
+	}
+
+	return pfn_to_page(pfn);
+}
+
 static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct folio *folio,
 					    struct list_head *vmemmap_pages,
@@ -520,6 +549,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return ret;
 
+	nid = folio_nid(folio);
+	vmemmap_tail = vmemmap_get_tail(h->order, nid);
+	if (!vmemmap_tail)
+		return -ENOMEM;
+
 	static_branch_inc(&hugetlb_optimize_vmemmap_key);
 
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
@@ -537,7 +571,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	nid = folio_nid(folio);
 	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
 	if (!vmemmap_head) {
 		ret = -ENOMEM;
@@ -548,7 +581,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..23abd06f1a4e 100644
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


