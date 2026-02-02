Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D655E7DEFA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B926B0107; Mon,  2 Feb 2026 10:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CB26B0109; Mon,  2 Feb 2026 10:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB126B010A; Mon,  2 Feb 2026 10:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3BB6B0107
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E9B389656
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:18 +0000 (UTC)
X-FDA: 84399973476.30.C126299
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00F26120006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pCTVTrn2;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thzRNh9rAZK8qHDFwycDHVrMaoNZgzgZsSom1OMIaIs=;
	b=y9+NwkmccSdUfdQQiHR/r+UWjoHTeUyK74FM2EXHDoCCGybO3AkiHJeEHJc3gCwT91zMkY
	X1f0kC9VTfaiAoh97pz0qhgIlxyzjisX+NjMbvbfDtN9K1vJGBwz3DxwD+kXGHKt1jvu7l
	hMYyhrn/hVwTXQ/O1qflLo8A8rG2g/Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pCTVTrn2;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047896; a=rsa-sha256;
	cv=none;
	b=1WNwGv4HFNfMBfd1VY60++U335vyf5qSznJR5vlvS16GKpJubvFF3c0XanNAq5tOwAJ8Ef
	/a/8d5J+5u7UaNLLg4y5qIFBdAjX1qEqQD6ZDI1WoRGtaxrIel5sdTRJ2hXMZGSYXmBMFw
	23gBNF9EyrAOjUu1O33YnFwaJlTMzZg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F374441DB;
	Mon,  2 Feb 2026 15:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9D9C4AF0B;
	Mon,  2 Feb 2026 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047894;
	bh=8150cyoGX9SS1fXE9plqym887h813uJpRn/Ewh7r9v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCTVTrn2xIfXEgDFZxJ7MNSokBBZtXjXd8VlKnhKCBCzTx8fZnHY4HyrN17XCH5F2
	 /kTY/xFUOm+7GUvGwvpA+ZLlPJ0UuNQctj+cZUYNbxl9LQ+wNhL8L7Pm64Y3ZRiWIw
	 zClXFNqdvSrARA5RBgAc6nkgwiREJUW/5Ep2NvO2y7FKBGqMpum0Tk8qsFmtE3A9LE
	 9ES7+2doVIX89ZSYIVNNTuBkgACnEEeGmeghL3cTJzksK4tpzxJZW6JzuhaFjpBCbm
	 CT2b1KrxAn/OVgL2YguYC081eZTzFh57KgVGWA9z0UmzyfiUvPw1WLw16LgFLvNOA4
	 dyANFCuX2yexg==
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4456BF40069;
	Mon,  2 Feb 2026 10:58:13 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Mon, 02 Feb 2026 10:58:13 -0500
X-ME-Sender: <xms:lcmAafOVIemRBNGdCdti12wXzkwyX_kATknMUCjBqBfQeVwRQFc9ew>
    <xme:lcmAaTI0urXb1bMKI7WqSKVH3oq2iw5tNyl7EV5hVpLwrlY2RxRZhU8gp9xQe5Fea
    -_539_JaMSIYQg0jaidwdVdklBsE_BemPOZ9PiZN4jUtpOCUhkZ0A>
X-ME-Received: <xmr:lcmAaYYG8yLyeFo0k3Uh_CYcY2Q20jTWLmz4_TJZp3ksabQFu49PSSHSv1k4kA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdev
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
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
X-ME-Proxy: <xmx:lcmAaUl-Aa4Kzw0sS2vgd3ctdQTy5_9iDokv_jZTJwukuViAnWcP9A>
    <xmx:lcmAaTZFHwywKfk4s5MGgOKXW33pimaZO9oM4D1FIEyAAYG2StdBuw>
    <xmx:lcmAacB_kl_ciLy9Jni0bJUUy5XsxOASyGTTjeRWZP3D7LqdkL6iWQ>
    <xmx:lcmAaZZMjMEEhAM_-pLqSX1LHcEt7g2MREOZ1Ajyo41AK_kNyXL1Hg>
    <xmx:lcmAaQhA25FmibUi8mD8euDg09oA87stZrUWKdIWcY1yYclw29vI_O66>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:11 -0500 (EST)
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
Subject: [PATCHv6 11/17] mm/hugetlb: Remove fake head pages
Date: Mon,  2 Feb 2026 15:56:27 +0000
Message-ID: <20260202155634.650837-12-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: fo8pyrpwa31qry4xnw88mhcg6fxf6dbg
X-Rspam-User: 
X-Rspamd-Queue-Id: 00F26120006
X-HE-Tag: 1770047895-243924
X-HE-Meta: U2FsdGVkX1+lsMxku3TC94OF+qh4Ojh8GAvpnBpERvO5mRiZYDMEZRgDT2s7CgzxL1Cc2dNYBh2rDM1WEwMNq1x6J7pu7PHFn7V3BdeXkik7ThuIgMjYsFKQoC901nEXNW+VaMoy1PsTJ7R5udYqp3t8lYP7n5dCvm/x8X5mZlNqWudRL51XyLU9iZOI0fYXCSHjIG/S3/RLo1UIjjFD9GVNkVgIGc70/kL7mdPYnxxS5G/kkBWzqdGOc4uuytnDUuPRW7yNV88VtiB9ThdRLa/Q3ZzgxKgIXe4vnoJ30yhfz+4+fIH4J/7NDkmy3VG8pU6eby8RkaWbA/HATlO7zetpAF5demLEEv7zVYYIP42JlgLpgDY8fWlsnM26Fl4WZY++W07fkI54r/JNlfRz8hC32gRBda6Hrb3y8r6QZogA9iwLxki/IgYKSy1mv7muUwjNljJIbvf1Y7IDBQkssl/2FP6g8MEwl5PUFtTSC+8K+hGDArC4i5GDQMwuEh2EOssHn1U88N+lno6mLWjjtSwMhOEaZ6cQ3lcr5VWWmIxeOBhV+1U2xQb7wpwa/d3nRjian83IMfa3uMlBHRkH1kUWn57EDIJ9e6o7fxVAVdhCUiSk9dsjPoUAghfTvAGq60VvYFyGAH621eshcq/QcDQTrJfm95kQf3hAOmftVrCbkNroHrdGvQOvXtIm9w5xQiiZGXyjerafcBcN9EixFm9E7XZcuMPeSeCw/ovjsgIszdSaA2rYRsjB7W/h5oLbJr60mMYuXOP4mSyi7e+W9URWwsWcp7MweJOWsTEywr+i27J4+dJyeSDe7S/13it4rKmJHAXqpUMzDplGbMYjBpadk0sfX/2vCLQVVODe62Gqfmlj9LxfSplgZZWc79NUbV94JSW1NtRJ1cJfquf5pVErGA9AKLZYUV00idNuGh2kPjX7cyIbskKC7/Be9qYwxVYw/9rrBhWzhXLeOpz
 JlJ+y1jT
 LXI1gXryUAHaZmW8bgPU2VPZ4qx/n1g8kKokG5/f9MU/cO0HiRdSlvE86n7ZeuaR+DpVekhix3GvnLYKYeoMDFtVNseiwf9vOwIJNPtjWJpKjYPlWmooJYrKT9mmzMpjcX77pJu90b157qmp7XF3wCVQdvyxdhKCx8Vu4DuToIwW21k9yRJMomfkma78HEfR/Eb351IXOeKELr+UO5RLx6YLLDpb5ZhEvyuUb5Z9egyy/30ljx+UuedY2PlpDFyQZXcCT
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
 include/linux/mmzone.h | 19 +++++++++++++++++--
 mm/hugetlb_vmemmap.c   | 34 +++++++++++++++++++++++++++++++--
 mm/sparse-vmemmap.c    | 43 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 84 insertions(+), 12 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 192143b5cdc0..c01f8235743b 100644
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
@@ -1402,6 +1406,14 @@ struct memory_failure_stats {
 };
 #endif
 
+/*
+ * vmemmap optimization (like HVO) is only possible for page orders that fill
+ * two or more pages with struct pages.
+ */
+#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
+#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
+#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1550,6 +1562,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	struct page *vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a39a301e08b9..688764c52c72 100644
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
 
+static struct page *vmemmap_get_tail(unsigned int order, int node)
+{
+	struct page *tail, *p;
+	unsigned int idx;
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	tail = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
+	if (tail)
+		return tail;
+
+	tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!tail)
+		return NULL;
+
+	p = page_to_virt(tail);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], NULL, tail)) {
+		__free_page(tail);
+		tail = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
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
+	vmemmap_tail = vmemmap_get_tail(h->order, nid);
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
 
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 37522d6cb398..13bcf5562f1b 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -378,16 +378,44 @@ void vmemmap_wrprotect_hvo(unsigned long addr, unsigned long end,
 	}
 }
 
-/*
- * Populate vmemmap pages HVO-style. The first page contains the head
- * page and needed tail pages, the other ones are mirrors of the first
- * page.
- */
+static __meminit unsigned long vmemmap_get_tail(unsigned int order, int node)
+{
+	struct page *p, *tail;
+	unsigned int idx;
+
+	BUG_ON(order < VMEMMAP_TAIL_MIN_ORDER);
+	BUG_ON(order > MAX_FOLIO_ORDER);
+
+	idx = order - VMEMMAP_TAIL_MIN_ORDER;
+	tail = NODE_DATA(node)->vmemmap_tails[idx];
+	if (tail)
+		return page_to_pfn(tail);
+
+	p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
+	if (!p)
+		return 0;
+
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
+		prep_compound_tail(p + i, NULL, order);
+
+	tail = virt_to_page(p);
+	NODE_DATA(node)->vmemmap_tails[idx] = tail;
+
+	return page_to_pfn(tail);
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
@@ -398,8 +426,7 @@ int __meminit vmemmap_populate_hvo(unsigned long addr, unsigned long end,
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


