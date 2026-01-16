Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2CEFC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2446B0095; Fri, 16 Jan 2026 11:19:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39FE66B0096; Fri, 16 Jan 2026 11:19:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 256E36B009B; Fri, 16 Jan 2026 11:19:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 11C106B0095
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:19:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7600556AE0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:19:03 +0000 (UTC)
X-FDA: 84338336166.21.8E7A2C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E0C81C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:19:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSWU+QUd;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trbxxJj7IpT6f8ezUn4wgkV/6irZfek+bO70Yjr55Xo=;
	b=6yYgO0lbkaVSZMf1Nf4TnOJew7LJ/jgkDT7yIrU6EkMsMI5Qsg8E7L8MBWrXWJ81xsFSy8
	3J1Ibqxih4MaLW6JR9RNGvBjH2lKACniYsgnupU0G8tuJgzSRWfaPBb5ZI7u29kShmKuv5
	yE4BitNJcJjHAIfgZtUUf262p400jZg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pSWU+QUd;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768580341; a=rsa-sha256;
	cv=none;
	b=xvTZZDs2uWi/td9uqQvH8JG57mWr4GhG9BOnGNa8d4qiGqoGbpyIML9Qcgf+RrSaE6Up3n
	uYxBKCiamPFWJD8IHLiXm3EGbQJsd9ZzB4dZTWyb++eikfD/j4AEcS/SNDaf89BIERv6PK
	/RvDTDHE69vGE3OIDJNxDdpURw2iwfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F1E8443F2;
	Fri, 16 Jan 2026 16:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F9AC19425;
	Fri, 16 Jan 2026 16:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768580339;
	bh=/Mp8bdLF/AfKTaNOMoq3MpNYakYvz35npSkmqiiDFVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSWU+QUdLEZVWfxZEr6S6sckSDMzAQP4ynowWsBJff95lj5PdNvb4u/5S7l0Di5Ms
	 o/vXoM6oqhKqeRhET2Vqd9LXEt07dCShAeFJPIbHfmyslXTXDkA5umftGDHUSnXLSh
	 xR7eWOjVqm5gU9RfWmAmZk7M8TQIHaLq5xc6bOAInPY6zU/FeosdWhAJoAOj7wLymY
	 NkTjIBSNWO5ljcggQA/ztCDP7qRqubZDcrioQG06NOuPhKBBO7IzeL7DXDOeWM09C9
	 UCe5PKJFjPVCBR0Kxh8kgNyZq62rgFNmGmwvCm/s21SE+6fj3VJd9l4efFv0HAfn3W
	 uNUtXpw1C/SAQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 547B4F40087;
	Fri, 16 Jan 2026 11:18:58 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 16 Jan 2026 11:18:58 -0500
X-ME-Sender: <xms:8mRqabv8Ft1x0lbuCbWr7rE0AwXZeP0w0g5rpaYEIGRB0ENrItdVlw>
    <xme:8mRqabvV8xRNxCiqNg_zfGQj9MBvYu35XjHW0c-WQ61oU658LgJKn7uw85il6k6VE
    vhT2I_o3XTcjpwk4laAtDDPCWvGp_BrG2PzxyD9O7xg55igoN4DaDcL>
X-ME-Received: <xmr:8mRqaRn3mkqm_kYMglTEhVZQZWByrhgc0vU5Kp9GGFVomV-bJ8abh4JAd_HqOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduvdelgedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoteeftdduqddtudculdduhedmnecujfgurhephffvve
    fufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhhuhhtshgv
    mhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdufe
    ejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvg
    hsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeeg
    jedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnh
    gspghrtghpthhtohepvddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehkrghs
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnug
    grthhiohhnrdhorhhgpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtghp
    thhtoheptghorhgsvghtsehlfihnrdhnvghtpdhrtghpthhtohepuggrvhhiugeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepfhhvughlsehgohhoghhlvgdrtghomhdprhgtphht
    thhopehhrghnnhgvshestghmphigtghhghdrohhrghdprhgtphhtthhopehkvghrnhgvlh
    dqthgvrghmsehmvghtrgdrtghomhdprhgtphhtthhopehlihhnuhigqdguohgtsehvghgv
    rhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:8mRqaRuD2fOUfJyL-ilunjIbkDM11U5BCD7G3JNoHJy_NW6x3N6bAQ>
    <xmx:8mRqaQNdl7mMH-A_cjvKJD4-n89JA2T3c2YZCtvTjFjYQ86sKEES0Q>
    <xmx:8mRqaS2byjdCEjpcq77vkESiVp2MfPwJubd9yLzg5A6E0g0vZZRzNA>
    <xmx:8mRqaSxnPuWtQWUehjJJ7jGoGBaOcKR3VaijEKbaWf-3kTNRyYnCcw>
    <xmx:8mRqacpfRkQGky2EDJ3ZdEq9M2tG_rSswLMxcoIcR0e-S_CnyXjLwNWw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 11:18:56 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	bhe@redhat.com,
	corbet@lwn.net,
	david@kernel.org,
	fvdl@google.com,
	hannes@cmpxchg.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	rppt@kernel.org,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	willy@infradead.org,
	ziy@nvidia.com
Subject: [PATCHv3.1 10/15] mm/hugetlb: Remove fake head pages
Date: Fri, 16 Jan 2026 16:18:46 +0000
Message-ID: <20260116161846.1799643-1-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260115144604.822702-11-kas@kernel.org>
References: <20260115144604.822702-11-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E0C81C0005
X-Stat-Signature: 64h5f9pwz9dcg1es5117bzdk65mx68fm
X-HE-Tag: 1768580341-726970
X-HE-Meta: U2FsdGVkX19cHTBT6fX4Q8K8/QLswuKazBjdl88KpBxrfosOnYBRHJyxXGMK+DsPi95KUfeVOfgWxuX7oQwY2Qn0/fbT72XS8jUDoUoOL/IPGNgP6FiLN8lLZYJe5MtEZ53vR0KhKNqHLVeIeuaPs5TiVyBfsGV/ojH/Jz3O6UmiSPsFTXe1Ikn4ZOFc/7VSn0CXfyso4Mw4RAsqR0XlI8gn8hVsROQ2goZx3u2WGdiUXOQFomvFiirvkbS5yiu+/9cAWvO2MKAo/4wKYZJDi0EZMCiLW/L6COB5+iW4eal0oxWyLkpbypGVaeX+cxgH1V0ym4LC2ApK2HXIUL+ZqkROhyOaZQo2BmGMkDZrqWTEv+4QLM4HnQhltbNiI8jlidYCQAJ53+w5O5N0Q523HS4IA9PJ/p+p69J7WqeAPu4D2MCHw0hu+IDkbZkC/gLEhpHqLeOfvP+gzhJ02MK+qWNQps6cPTFbkXyiJHSfeqXJg1JUd78m+s9rLTlvFmO/znfKMGFAfdm/VdLR4wiXwr5K9UBSODT54DukmG+itUDS4dH5zKTUpflPG2qoCexqXxmE6Vn/dNoW5wwsOzQjkKlwrNqLchylzlhTAtGig6S04t8NtrhH06K1PCM8vKXZIy11p22KZipeHc3S5qGMmtBjyap6OCxXxFavZrJE23b66FHGTMvlCIHSO8eTMeBGJ415TlaN+EHIxJvRLCq46wTubgx54pXHKJGS5hswBx3M/6AcVMjDJ8Kzr5NXjBTRMN+XMmijxTNOrq1bFNLU06RBaVM/F1IuwRM365nrSdpg8FdWxOc/W39LneFy11zRsvEpExIOPAcg+CxHFiQVFeiUXS3iSTQ/J0kiVi2roWu2xbObFxWUCOz8dMBUaU7jZ6NS21Pj0JjnM0lv15DHaiVJK7cn1sfloCbHRbLY9NlOCYTZuMnIbjKz5MuYcT0v4W6dtKqBbQ7CA0uqLzm
 T1ujfUvD
 ovaHj5HlYj4Ij8yaqCwqlku68ctWdCGFmflH9vmaE+QERnBvnbbNB34CClvl5eMopLPIcAYdWOuKN/YEpVxRNQXDTEpkup4RVQheJ6UfwRvxdeuwtNq+I3AOg4deUJ7Ny4ain0D4AKF57LNV1d5OM1wX98WmCbUW45x9Xxuo/n/sItZ9rhPM90KZaHAGfDkO6QPF/o1X2aY0sX8K8BFG2teYPCVB+XY9aEOgSE9kOlewNAMgN+/owM2x5NQ5GJJ1tqxTC
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

This eliminates fake heads while maintaining the same memory savings,
and simplifies compound_head() by removing fake head detection.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---

v3.1:
 - Define MAX_FOLIO_ORDER using ilog2();
 - Update commit message;

---
 include/linux/mmzone.h | 16 ++++++++++++++-
 mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
 mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
 3 files changed, 93 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 322ed4c42cfc..bc333546c2d3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -82,7 +82,11 @@
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
@@ -1408,6 +1412,13 @@ struct memory_failure_stats {
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
@@ -1556,6 +1567,9 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+	unsigned long vmemmap_tails[NR_VMEMMAP_TAILS];
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 2b19c2205091..cbdca4684db1 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -18,6 +18,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -517,6 +518,41 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
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
+	tail = alloc_pages_node(node, GFP_KERNEL, 0);
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
@@ -532,6 +568,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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
@@ -549,7 +591,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	nid = folio_nid(folio);
 	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
 
 	if (!vmemmap_head) {
@@ -561,7 +602,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	list_add(&vmemmap_head->lru, vmemmap_pages);
 	memmap_pages_add(1);
 
-	vmemmap_tail	= vmemmap_head;
 	vmemmap_start	= (unsigned long)folio;
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


