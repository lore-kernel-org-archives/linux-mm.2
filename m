Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86487D3748A
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 19:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9004B6B02C8; Fri,  5 Dec 2025 14:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9496B02CA; Fri,  5 Dec 2025 14:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 778D26B02CB; Fri,  5 Dec 2025 14:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6106B02C8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 14:44:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 276C013A7B4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:07 +0000 (UTC)
X-FDA: 84186443334.18.FD0D0B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1422040004
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:44:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLRAkAaN;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764963845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=apQtfbwPC1xbMIq6yRvXdjLrKVLGQGd3fLzkPHjvupI=;
	b=yRTfztSJ5p0hO54pVIe7vCb8ZJQ1U045XXHBiNUaKB5ZsBc7g8rGNHXakbKUVPj4eshNZU
	4I23tcuf4PIOSRLphZ7C91vM97k6NBJBRwMSWng/Piv+6fDxxGRp1pk9Pb7fr7Cj0JYRev
	4vSMofMYTiC6zWgZB14ZgTn4BQcW/HI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLRAkAaN;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764963845; a=rsa-sha256;
	cv=none;
	b=GydpcjfDbiUBpEJ+Rhd8w8SMFfFUFD6Q2rSLimYIpY0ZG16m+E146GsZMgv9oT3mVAuELD
	aHGN5r/WlBtFMXiPni6WVtMQZXI37sns2brZRSXbHdne5XvBcuBiUS6sg5ObbGjoECsk2Y
	zavbYRMr41gfG8Vt4RegMZM4rC5t7Kk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0EAC4352C;
	Fri,  5 Dec 2025 19:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4280FC19421;
	Fri,  5 Dec 2025 19:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764963843;
	bh=oMYy6glwIW5pXD0zPIrvTMQhQQvrPM7gnzZZsvkFTM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLRAkAaNAeqUmCE7ZfWJfkGF2yhvsrstkT+8jFX9GctkmfcAYklZGF1SnkcudStrm
	 ru8aTvxZcBj7tKbu6gjH156+qiDO0qgpOihmoQDwcGfQ0WPge3EE7mQbizT96VVy5y
	 b+Q2CeksMHH4nIByKGb6tNrb5TJrhGdvnlHByIyQg32Cl7KI+GBa4X/Y9s5f123F4y
	 D1Ouh2k4/isKnReUNfQ3vbWnQBbDorTSwpC8Qt3K7zoyXJggtCkPnrOBE1Jk/yyrP6
	 atVJQI2X3bdl38um/6ueHY0xJNS9IYLjWCruit/h2aMGiPST5i8sNPc4zfAu5gDffu
	 zyGZbZ3FNhecg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 87006F40072;
	Fri,  5 Dec 2025 14:44:02 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 05 Dec 2025 14:44:02 -0500
X-ME-Sender: <xms:AjYzafHc158lBU91byUTogAf19nQ8Ab3xU2wccYt-nl0jP0n5mhx8Q>
    <xme:AjYzadsvsA1SKt9hVMPQ7d64uXiJZRZdQfrKJ6vmXC1JaG0BxIPxEyNWJzpgTurMq
    gVLLnRSNdHoz5SryS9zK5vn0oW-63P_552gTyxG0afbU1vDWaoAdjU>
X-ME-Received: <xmr:AjYzaabhncL4OsVmJUO8DXwRjNxGgfLOaWEAYjxnaaiLmFqb4yU8HJt43GTZWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdelvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    ephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnh
    ephfdufeejhefhkedtuedvfeevjeffvdfhvedtudfgudffjeefieekleehvdetvdevnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilh
    hlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddv
    keeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrg
    hmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepmh
    hutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegurghvihgusehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdruggvpd
    hrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorh
    grtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:AjYzaVXu8rKWZZHi2X59K_indMmtMICUPUiaaP06QiLWmoDwZ6lEHg>
    <xmx:AjYzacLhkfXJLvXjVN3vxUDzw_4aCZocy8PdmwrqLkvZuwKI-gUdUQ>
    <xmx:AjYzaTHJrA-d3CQ7c9XDmzj6GfNcaoo5wKNQ58OD8A9Do0SF9RpM9Q>
    <xmx:AjYzaRwCb5IDQLMRuDP8Vnz0k8yeKooRUhWchPAOkQQa1awkytnQDA>
    <xmx:AjYzaQhGr3M57JXHBx1MbdBMK-OvZ_fAJXwAH4urAWZOmWASe36T7pKS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 Dec 2025 14:44:01 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Usama Arif <usamaarif642@gmail.com>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH 05/11] mm/hugetlb: Refactor code around vmemmap_walk
Date: Fri,  5 Dec 2025 19:43:41 +0000
Message-ID: <20251205194351.1646318-6-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251205194351.1646318-1-kas@kernel.org>
References: <20251205194351.1646318-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h3j5pkts9rbzwe8471adqyxizh3yh78u
X-Rspamd-Queue-Id: 1422040004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764963844-795499
X-HE-Meta: U2FsdGVkX19c+HK905i81Mhq+hIgibYxZzhIFeZr14yBbUkmmSmqI36Iq34B/5QmyxoegK/rBwMwDIB29tKLQ6dU+L3IrNAHdNPS1496PpY6Pqt0XDHVwwADVl+sEuNdUBFZhSisHHSh/8/FY1S1lnSqix+hOvrOuaRxgJnme/Zo2cBlOYgb4k3+BvshBo2+OrNy9zXZuimvf0GQGX65d++VTI22PdJJJmn6Dsd0x/EItW1Bq9XgsedHqAgQoT29ey1dcx+IwPyyQ2nkM/+wBFpdrwDMv03NyFPwtzPqgmg6iYVlS5e8vt31eQ8+ddjJ4raSgm7D5Ml1Hm+h21pnKrR+ja6a5xpu52f79GZnkd8lWppfu/Wwc4U9+SjF9Q27XomXekh9hiFEzNK6RYSbe5bpt0Umo1mEMxhUA+3LsRMfvH04xG8eBpOc9Qp0oQWYpGVyMKYp2nEn8R2DZRf0VWqXy0OmLpRa3AjuZqrjkwd/APGtbic6zyuJTCYq1f2WjBDQwFvgKqQS5essHsv2+xMPVndOYSAjSxsryevJ8XMycojvBAULQ1Ydfrsg9uh58bsCeHADuue0cdNRhnT/9Kvhx0wuiWJ3FV0Acph3Gqbo9Un1dWryj8bweuAZ1BPwHuJiG/ThRohksu7xM/j1bAKCF6Ef0Gwyaz+zg3CmTJyN+8KC3x3gUdCP7TN2fa8o8qMMFvmd3/8m+EU2092XX5HC4X7xIoh3OA44FQu0iCfubAWd8X6gQNPa5cttfnlC972OEIDMF7jAQZ1ckUaSnAF6/UaissCeb8HEJmhEQK6zswRHZATdj18HgK+3AsE1tdLC06eEU35+wcSniDh2IpDzLA9FHmtVot6Sf9OyQUDaXSp7YT4uLbm5DhgvUbRZsELtt2It0/mg4K4sRGzi4WJ5BMiRsQ6rM/jkNLk4NHoTL9elVkSxxXvwiIlu4yZSXK+6uH4FdPEkmCR+6MS
 vMufqIur
 IhOeHKyhcWF9Vbi0lLn9Kap/TYwL2qy3MFgmORYfbOxzqzzCJhMBdSilTGOMcslkNRJpGAijW//fyjh+ENLCGw2YqRnnXV/LsLB9U4UC1d0mB7th8Q/uqVsKlVnOf61eCElLF954rdtzYTdGMSYUOQU/SCStknHhi72+KyiJoRt4ukOsI22PZuIcPiuegT3amGtdLJ9v/IVH/N5EyJGAJkdnJlWRWv4K+aZ2KW3DVYMMqrsppVSt57WKCyTCjCpWKKX49OTFeb9+CCyPZjUKh83f2METC7Uu/SJoGxRw5K51eLAyFJUSpV03L6Wp+U8X8dnn09bKIpp603t6VfGB7LdONiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To prepare for removing fake head pages, the vmemmap_walk code is being reworked.

The reuse_page and reuse_addr variables are being eliminated. There will
no longer be an expectation regarding the reuse address in relation to
the operated range. Instead, the caller will provide head and tail
vmemmap pages, along with the vmemmap_start address where the head page
is located.

Currently, vmemmap_head and vmemmap_tail are set to the same page, but
this will change in the future.

The only functional change is that __hugetlb_vmemmap_optimize_folio()
will abandon optimization if memory allocation fails.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 mm/hugetlb_vmemmap.c | 184 ++++++++++++++++++-------------------------
 1 file changed, 77 insertions(+), 107 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ba0fb1b6a5a8..f5ee499b8563 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -24,8 +24,9 @@
  *
  * @remap_pte:		called for each lowest-level entry (PTE).
  * @nr_walked:		the number of walked pte.
- * @reuse_page:		the page which is reused for the tail vmemmap pages.
- * @reuse_addr:		the virtual address of the @reuse_page page.
+ * @vmemmap_start:	the start of vmemmap range, where head page is located
+ * @vmemmap_head:	the page to be installed as first in the vmemmap range
+ * @vmemmap_tail:	the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages:	the list head of the vmemmap pages that can be freed
  *			or is mapped from.
  * @flags:		used to modify behavior in vmemmap page table walking
@@ -34,11 +35,14 @@
 struct vmemmap_remap_walk {
 	void			(*remap_pte)(pte_t *pte, unsigned long addr,
 					     struct vmemmap_remap_walk *walk);
+
 	unsigned long		nr_walked;
-	struct page		*reuse_page;
-	unsigned long		reuse_addr;
+	unsigned long		vmemmap_start;
+	struct page		*vmemmap_head;
+	struct page		*vmemmap_tail;
 	struct list_head	*vmemmap_pages;
 
+
 /* Skip the TLB flush when we split the PMD */
 #define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
 /* Skip the TLB flush when we remap the PTE */
@@ -140,14 +144,7 @@ static int vmemmap_pte_entry(pte_t *pte, unsigned long addr,
 {
 	struct vmemmap_remap_walk *vmemmap_walk = walk->private;
 
-	/*
-	 * The reuse_page is found 'first' in page table walking before
-	 * starting remapping.
-	 */
-	if (!vmemmap_walk->reuse_page)
-		vmemmap_walk->reuse_page = pte_page(ptep_get(pte));
-	else
-		vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
+	vmemmap_walk->remap_pte(pte, addr, vmemmap_walk);
 	vmemmap_walk->nr_walked++;
 
 	return 0;
@@ -207,18 +204,12 @@ static void free_vmemmap_page_list(struct list_head *list)
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
-	/*
-	 * Remap the tail pages as read-only to catch illegal write operation
-	 * to the tail pages.
-	 */
-	pgprot_t pgprot = PAGE_KERNEL_RO;
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
 
 	/* Remapping the head page requires r/w */
-	if (unlikely(addr == walk->reuse_addr)) {
-		pgprot = PAGE_KERNEL;
-		list_del(&walk->reuse_page->lru);
+	if (unlikely(addr == walk->vmemmap_start)) {
+		list_del(&walk->vmemmap_head->lru);
 
 		/*
 		 * Makes sure that preceding stores to the page contents from
@@ -226,9 +217,16 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 		 * write.
 		 */
 		smp_wmb();
+
+		entry = mk_pte(walk->vmemmap_head, PAGE_KERNEL);
+	} else {
+		/*
+		 * Remap the tail pages as read-only to catch illegal write
+		 * operation to the tail pages.
+		 */
+		entry = mk_pte(walk->vmemmap_tail, PAGE_KERNEL_RO);
 	}
 
-	entry = mk_pte(walk->reuse_page, pgprot);
 	list_add(&page->lru, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, entry);
 }
@@ -255,16 +253,13 @@ static inline void reset_struct_pages(struct page *start)
 static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 				struct vmemmap_remap_walk *walk)
 {
-	pgprot_t pgprot = PAGE_KERNEL;
 	struct page *page;
 	void *to;
 
-	BUG_ON(pte_page(ptep_get(pte)) != walk->reuse_page);
-
 	page = list_first_entry(walk->vmemmap_pages, struct page, lru);
 	list_del(&page->lru);
 	to = page_to_virt(page);
-	copy_page(to, (void *)walk->reuse_addr);
+	copy_page(to, (void *)walk->vmemmap_start);
 	reset_struct_pages(to);
 
 	/*
@@ -272,7 +267,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	 * before the set_pte_at() write.
 	 */
 	smp_wmb();
-	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
+	set_pte_at(&init_mm, addr, pte, mk_pte(page, PAGE_KERNEL));
 }
 
 /**
@@ -282,22 +277,17 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
  *             to remap.
  * @end:       end address of the vmemmap virtual address range that we want to
  *             remap.
- * @reuse:     reuse address.
- *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_split(unsigned long start, unsigned long end,
-			       unsigned long reuse)
+static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
+		.vmemmap_start	= start,
 		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 /**
@@ -308,7 +298,8 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
+ * @vmemmap_head: the page to be installed as first in the vmemmap range
+ * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
  *		responsibility to free pages.
  * @flags:	modifications to vmemmap_remap_walk flags
@@ -316,69 +307,40 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end,
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_free(unsigned long start, unsigned long end,
-			      unsigned long reuse,
+			      struct page *vmemmap_head,
+			      struct page *vmemmap_tail,
 			      struct list_head *vmemmap_pages,
 			      unsigned long flags)
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_remap_pte,
-		.reuse_addr	= reuse,
+		.vmemmap_start	= start,
+		.vmemmap_head	= vmemmap_head,
+		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
-	int nid = page_to_nid((struct page *)reuse);
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+
+	ret = vmemmap_remap_range(start, end, &walk);
+	if (!ret || !walk.nr_walked)
+		return ret;
+
+	end = start + walk.nr_walked * PAGE_SIZE;
 
 	/*
-	 * Allocate a new head vmemmap page to avoid breaking a contiguous
-	 * block of struct page memory when freeing it back to page allocator
-	 * in free_vmemmap_page_list(). This will allow the likely contiguous
-	 * struct page backing memory to be kept contiguous and allowing for
-	 * more allocations of hugepages. Fallback to the currently
-	 * mapped head page in case should it fail to allocate.
+	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
+	 * call which failed.  These are pages which were removed from
+	 * the vmemmap. They will be restored in the following call.
 	 */
-	walk.reuse_page = alloc_pages_node(nid, gfp_mask, 0);
-	if (walk.reuse_page) {
-		copy_page(page_to_virt(walk.reuse_page),
-			  (void *)walk.reuse_addr);
-		list_add(&walk.reuse_page->lru, vmemmap_pages);
-		memmap_pages_add(1);
-	}
+	walk = (struct vmemmap_remap_walk) {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_start	= start,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= 0,
+	};
 
-	/*
-	 * In order to make remapping routine most efficient for the huge pages,
-	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
-	 *
-	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
-	 *   should be continuous.
-	 * - The @reuse address is part of the range [@reuse, @end) that we are
-	 *   walking which is passed to vmemmap_remap_range().
-	 * - The @reuse address is the first in the complete range.
-	 *
-	 * So we need to make sure that @start and @reuse meet the above rules.
-	 */
-	BUG_ON(start - reuse != PAGE_SIZE);
-
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	if (ret && walk.nr_walked) {
-		end = reuse + walk.nr_walked * PAGE_SIZE;
-		/*
-		 * vmemmap_pages contains pages from the previous
-		 * vmemmap_remap_range call which failed.  These
-		 * are pages which were removed from the vmemmap.
-		 * They will be restored in the following call.
-		 */
-		walk = (struct vmemmap_remap_walk) {
-			.remap_pte	= vmemmap_restore_pte,
-			.reuse_addr	= reuse,
-			.vmemmap_pages	= vmemmap_pages,
-			.flags		= 0,
-		};
-
-		vmemmap_remap_range(reuse, end, &walk);
-	}
+	vmemmap_remap_range(start + PAGE_SIZE, end, &walk);
 
 	return ret;
 }
@@ -415,29 +377,27 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
  *		to remap.
  * @end:	end address of the vmemmap virtual address range that we want to
  *		remap.
- * @reuse:	reuse address.
  * @flags:	modifications to vmemmap_remap_walk flags
  *
  * Return: %0 on success, negative error code otherwise.
  */
 static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long reuse, unsigned long flags)
+			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
-		.reuse_addr	= reuse,
+		.vmemmap_start	= start,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	/* See the comment in the vmemmap_remap_free(). */
-	BUG_ON(start - reuse != PAGE_SIZE);
+	start += HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(reuse, end, &walk);
+	return vmemmap_remap_range(start, end, &walk);
 }
 
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
@@ -454,8 +414,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -466,9 +425,8 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
 		synchronize_rcu();
 
+	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -477,7 +435,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	 * When a HugeTLB page is freed to the buddy allocator, previously
 	 * discarded vmemmap pages must be allocated and remapping.
 	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, vmemmap_reuse, flags);
+	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
 	if (!ret) {
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
@@ -565,9 +523,9 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	int ret = 0;
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
+	struct page *vmemmap_head, *vmemmap_tail;
+	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -592,9 +550,21 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
+	nid = folio_nid(folio);
+	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
+
+	if (!vmemmap_head) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	copy_page(page_to_virt(vmemmap_head), folio);
+	list_add(&vmemmap_head->lru, vmemmap_pages);
+	memmap_pages_add(1);
+
+	vmemmap_tail	= vmemmap_head;
+	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end)
@@ -602,8 +572,10 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * mapping the range to vmemmap_pages list so that they can be freed by
 	 * the caller.
 	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end, vmemmap_reuse,
+	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
+				 vmemmap_head, vmemmap_tail,
 				 vmemmap_pages, flags);
+out:
 	if (ret) {
 		static_branch_dec(&hugetlb_optimize_vmemmap_key);
 		folio_clear_hugetlb_vmemmap_optimized(folio);
@@ -632,21 +604,19 @@ void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
 
 static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *folio)
 {
-	unsigned long vmemmap_start = (unsigned long)&folio->page, vmemmap_end;
-	unsigned long vmemmap_reuse;
+	unsigned long vmemmap_start, vmemmap_end;
 
 	if (!vmemmap_should_optimize_folio(h, folio))
 		return 0;
 
+	vmemmap_start	= (unsigned long)folio;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-	vmemmap_reuse	= vmemmap_start;
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
 
 	/*
 	 * Split PMDs on the vmemmap virtual address range [@vmemmap_start,
 	 * @vmemmap_end]
 	 */
-	return vmemmap_remap_split(vmemmap_start, vmemmap_end, vmemmap_reuse);
+	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
 static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
-- 
2.51.2


