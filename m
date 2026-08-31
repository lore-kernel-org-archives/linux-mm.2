Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FBE8C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADCC6B0098; Mon, 31 Aug 2026 03:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684EA6B0099; Mon, 31 Aug 2026 03:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526906B009B; Mon, 31 Aug 2026 03:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA856B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D2DCC01E0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:54 +0000 (UTC)
X-FDA: 85160803308.29.757E297
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95A46120004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fa9loWrv;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162892;
	b=gMKGFYEPHRraBQrDHiKurpOP+E4un9urcJ+oU7S5/YcdiI1t0tH833CDDtAZreBw+1L3Qr
	FSwSJ5qFqlrPYAu9THco7tftRPMnLYmR6fpi0xOI6mDCKttYhJUccBEWimvVIBoxXVkGMy
	MNzWpSTALUBFf/x0USIVmNDecxDnSTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d85H49jI1quBgxYs+PQ2R3ebCcg9h4JyI/UtxSGskms=;
	b=iJ30XldEcN1iCfeYUmnUSVC+VBNPlPJQJaJVCF9N0PlWsbES9pFes3RfFhhl0V7o3Ozurv
	zbljYPc2v7EfJPkOgzU3/A6+3kGSGniAx+dz/kqMAGuQnnGvmS9kuo4uZsEI1E6u3BBzcN
	vwQDjw10/bfyxz7gnPMknUNut1lK3xQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fa9loWrv;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cbe827e3cb4so3354699a12.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162891; x=1788767691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d85H49jI1quBgxYs+PQ2R3ebCcg9h4JyI/UtxSGskms=;
        b=Fa9loWrvXqSTnLx7CeZPklNft8FwAe/e/lxzCJPGZCYMenbIsqavnlJ6YfqQKbZsVC
         jBiEXpt20nViBXGe8LU5PnZlykVyyrVLi2xhIlvlKxdHHNKBPyJN9ViKiSzbSyYd+OTH
         9HFP75TJAmjcmLaqpDU32gOgyyaXbpRuf7Rt6STOUrjk609NfNMQKhAHZUzy78z+4fnI
         w/08+SDl8GG4isuwekQxY37oFb7cnbCAqYEYU7C8avwvstmwdqjmSudvT1YbMtsnrfuR
         TkhI/1SUHx3Ed0E+5BxNSJFbF4jxDEYqGEBKcrSD1pAmmE6WKuE+wWFqec32SutdIulp
         OQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162891; x=1788767691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=d85H49jI1quBgxYs+PQ2R3ebCcg9h4JyI/UtxSGskms=;
        b=Rx4PAfcQLEavShwwExpvFWxWtruJyzM/i15IUb1yQKIJUkeX7f91nDmo6rAW7iP1ya
         8sZIxliLB7fzl4IQfu1TNc0fGMa+P0/ubIXp+KqiqL8PAApWfy+hliWftLTCGU9maFUh
         YnMkLxzIlqLpMPdeDKPWLhElHMT0LCgpHiFVm5Upuf0XabRwX7qUwiAtwYha0SU6RGji
         Ylb4o6yRwGzDMekispb0Vnl7Z9h3vtEoM3hQ6xgMO/3DNwHRcAM8QSTp7EpNWhgfL4S0
         2FET7f1UgpFDMdVAIpv3ZrnjZ9Y+7oAC4YLTEn5ditFQUzx1t7D8bhqiQ2GydaGVAx7M
         Na0A==
X-Gm-Message-State: AFuF++mrwrlL8RANUXVKtxCdAELi5aE97K2THMG0exE3iGv4D6JhAEfA
	jGxilsp2B6otu+O/jB/V80yuibQXeLr5fpxsKfj1xbmyCWqIzp1rB54Z+KFw7ZbTbKA=
X-Gm-Gg: AR+sD11JFOUaa35BW71aiVEALVcdxyR4A1ALqGFZAt8yGKBqK8nXSnuadfbRXT3OWOP
	3vqXVO630OZfwkWpTZdRoNJj0VcPivd5jUvteBi0JJ65k+8VaFkfYqTEmBWoakQP6DrR81NgaPS
	FhDDea8gAB+E2QNf3TKZy8Fat/QFSuPoY3QhJJbRIM2KIc7zE6uqyZSbILLFpLGmXRKFquVVt/V
	0CdjxJzoui0SXSaBKzc8Z8kPcaC0ZcK2ifnPxb9YTpU5Ptd5dLHAHXFQHM9qPBGPr8RvF0cnCVn
	PqHIlBTOt59fPYPzhhnat0ztRZbVuczEQF1POHvJfBIOfdwRkJ2/TGG+MFypXBOcEummTFMsvg8
	MD5obIQaJN4e5AIazy+Ofb5SE9Eq4IQrJO1KIUJnjBXCIx2HfY8wd65tv2+ykUWVH+yxnIL0Khg
	3cMSrfbEh2swr4SJyDtoBUdAppcHOFmI5FbcC0vW3QWDOWwv/k1D7ZdUJA9wOOuJavYK8JslYxu
	iE60w2qloQIFN52mlRolD7i
X-Received: by 2002:a05:6300:220d:b0:3cc:faf3:331a with SMTP id adf61e73a8af0-3d2686aa479mr43643171637.10.1788162891372;
        Mon, 31 Aug 2026 00:54:51 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 05/11] mm/sparse-vmemmap: set section order for device DAX
Date: Mon, 31 Aug 2026 15:53:36 +0800
Message-ID: <20260831075342.57563-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95A46120004
X-Stat-Signature: ma3yjtrf6gendd4sk8ru3zmf1351znsj
X-HE-Tag: 1788162892-145668
X-HE-Meta: U2FsdGVkX185EOuXEd+7Gyit346uCnjXFpQQWNZLbRjn/Ckk10+Z5fmhbeE6wMwlyhlMH0v26CAMT1Ocv5SJdGnr2PqtehYuI5IJeGkHMStM9/HneZsauYAuEQcpsYvqrN5A7EqOep/7eaHSQ5JkbRR+newZKs0FbssE2d2QB/rWUwpPiiq+V8n+hTjuCH4T0NsMjECWKgC47WFE7iMrwyEEJWa2Hzhkf9oGlSdQPXBi03W5aBSv37M3CWFzjKP+wo4j+mu+bsLPg4QRpgYMnyhGc8VoqwQDjhExHhTppZXGpNMwQ08zYFROq5lxSGL8N75NKK4x/JBBi/7JbyP7YUIk4EmkAm205buuSJ/1UftwOLsyXpgNS6uPHq0238dkqR6qx9nSzhteF9pTQYDxr4B5yNOrBGBG0c6oZFYPsykhNsDDN56JW0wtMj7DpfKKznEwhmcw0YCefiqYhbbn0ceXCLOOfA8qMNcxz17nhV59ljv3r+Ia5IHRUOP1MgWwcvcCvCmDqJp7Vdy7blg2FONzuLiApwIbzkyh5fn3NycyqSTM5gM+WP2pdjWIOhC+gG35tuZw4QkE4oC6haEQl6bCBdsb7NZ05Tl5blBNLwFw/qbU8BB45yP8hTmFU83ZO3McIoKZCrzZih1m2cgc2ng1iggZxjP+rXazZ3es3Mv3ZjFk8aezAgs9BEx/UgdHFIj/qOFqIydIXsDet2X3TH+DfhUtv3+vje+lSX3yvFvMaXn4bOznw7OxcPVvKpz6bTBERMDRK7m9ntAVNRS6DOKo9phfk+NYgBrHifZzz4kg0tnbNidO86pZt9H86iTNUEZtanC44zDZ4x0Pz43kTmAQLL9zrazf1+PlheKoc5oy69aGjkwDc0o7/qeS+yxh9nbzS3cKgGGyiS/cs+8eeVp4kEPu7nGIH/uE8Fd621bDco1JnB0/zQzXGAvw1mjtwqrtw9wV7ULP8A1xS/y
 KrP+z8vM
 hkX/zdx8a8X7w0BYcVFLOHLOQSIixtcDZUmZ+2yVJgrubUW0zaYNt4bTagf144QI8OJz2NU3wIAt8s0Zvrv24fSt987xZ4nNXKi6PQNZl9WF2Ha+44Nzq/H3uUnTvFz8l/ue5Ifb9yLzBmHBuFbPbQcH10RL0DWtntiaesF34L+SKe+3quGt5jqAAMVH4JSfHVH4OF2WBLt5WF3DCf2PSc9g0zN33avJn+VGE5b/BfIo6uMFPh6x4daRsxK3wyF5sRG1uI1ayocdzYi84BR7ScU/EfyykAXvg5j9btkKtO6UiomJafDkyx1cNbQPgeSorFHU7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device DAX can use vmemmap optimization only when a full section is
populated with a compound-page geometry. Record that geometry in the
section order before populating the section, so later vmemmap accounting
and population decisions can use the section state directly.

Clear the section order when the section becomes empty again. Also reject
partial additions to a section that already has optimized vmemmap mappings,
because a section cannot safely mix optimized and ordinary vmemmap layouts.

Partial additions continue to use ordinary vmemmap population, so they do
not save vmemmap memory. Such additions are uncommon, and the lost saving
is negligible.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c        | 13 ++++---------
 mm/sparse-vmemmap.c | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 33ff95141adb..c4cd61978ce8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1042,16 +1042,11 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
  * of an altmap. See vmemmap_populate_compound_pages().
  */
 static inline unsigned long compound_nr_pages(unsigned long pfn,
-					      struct vmem_altmap *altmap,
 					      struct dev_pagemap *pgmap)
 {
-	/*
-	 * If DAX memory is hot-plugged into an unoccupied subsection
-	 * of an early section, the unoptimized boot memmap is reused.
-	 * See section_activate().
-	 */
-	if (early_section(__pfn_to_section(pfn)) ||
-	    !vmemmap_can_optimize(altmap, pgmap))
+	const struct mem_section *ms = __pfn_to_section(pfn);
+
+	if (!section_vmemmap_optimizable(ms))
 		return pgmap_vmemmap_nr(pgmap);
 
 	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
@@ -1121,7 +1116,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 			continue;
 
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
-				     compound_nr_pages(pfn, altmap, pgmap));
+				     compound_nr_pages(pfn, pgmap));
 	}
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 54ae8c284324..aed1e7429daa 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -135,14 +135,14 @@ int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int order = section_order(ms);
 	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
@@ -573,7 +573,7 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
-	if (vmemmap_can_optimize(altmap, pgmap))
+	if (pgmap && section_vmemmap_optimizable(__pfn_to_section(pfn)))
 		r = vmemmap_populate_compound_pages(pfn, start, end, nid, pgmap);
 	else
 		r = vmemmap_populate(start, end, nid, altmap);
@@ -792,8 +792,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	else if (memmap)
 		free_map_bootmem(memmap);
 
-	if (empty)
+	if (empty) {
 		ms->section_mem_map = (unsigned long)NULL;
+		section_set_order(ms, 0);
+	}
 }
 
 static struct page * __meminit section_activate(int nid, unsigned long pfn,
@@ -803,8 +805,13 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
+	unsigned int order;
 	int rc;
 
+	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
+	if (nr_pages < PAGES_PER_SECTION && section_order(ms))
+		return ERR_PTR(-ENOTSUPP);
+
 	if (!ms->usage) {
 		usage = kzalloc(mem_section_usage_size(), GFP_KERNEL);
 		if (!usage)
@@ -830,6 +837,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
 		return pfn_to_page(pfn);
 
+	section_set_order_range(pfn, nr_pages, order);
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
-- 
2.54.0


