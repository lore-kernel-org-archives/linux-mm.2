Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE82CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:04:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239E16B0098; Wed,  3 Jun 2026 04:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2121B6B0099; Wed,  3 Jun 2026 04:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F716B009B; Wed,  3 Jun 2026 04:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07E366B0098
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:04:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF67C120228
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:04:27 +0000 (UTC)
X-FDA: 84837864174.23.645CD7F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf17.hostedemail.com (Postfix) with ESMTP id D114A40007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:04:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nXc4Z1Jj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAoGwOogI0538Jjz3Jr5mPaMM02ePyByPYJiX1kFuRI=;
	b=RvrjcD4gkI04JDqoHiCQBKdVWdLW59Q4s0kqdclADZjO+fW0EEdFZqMkgzVvq2F3TfVRBU
	p914uq6iEJLnaEZxfpEQAsN/PX8X1bA4RG5qyI7YPsVxlCvpMBT4nHd0/GKBLr4FG12ItH
	a0JE31IRDt8Q5FwgsU1ceUe6819QX9o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nXc4Z1Jj;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473864;
	b=a0UIiLgSWn6PI3V/uywat6k2+FF09dVZu3KnFD0hCToGs43trpEBdRskGliT3XbfFBmHX/
	LUu0AFBkQMjD8AvYO2fHmbG88wMOWc9mQBrrR52e97PvAEWD8pz7wlFFIUOcR91Zcs1mf2
	YYxK+EB3Rci75Q2Dx0CCFYdsIBiQed8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473860; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=PAoGwOogI0538Jjz3Jr5mPaMM02ePyByPYJiX1kFuRI=;
 b=nXc4Z1Jju0zHBJOvEeYJbZHEg9IWLUkiIUT9Y5bIJxEQsqz/L2DmvHPWjZckPV8v+RMxKa
 OgET/x03w4pmPnmfN8PEr4I6+BDxFDg1o4b1j/WnvD1K8gtEMM5snPrJHDP/5Z8fx9/iyo
 7Yp0fMCsBr9c9Zb7ftKJ/sJ+cIB5f/dUHLpmO/F1lIpwXL0rC9UvcU/vqdupPDFbJ+gZa1
 svfmi2VZZdjyoM+OzAjHWHjMgNkjq1gpl9/vIaQ9bGCHyye2h3vUh4UBalVqJLAikEIfs7
 nXlzMu+uxtMELsyyP/8iAMJ/gI9TGdtQJJzXFI+nEmYs9qjsSykorhFplaSpwA==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v4 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Date: Wed,  3 Jun 2026 16:01:46 +0800
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a1fe002+d1e010+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260603080152.64728-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ubrnfpj9re7rkith88gbbj7yasi7fgzs
X-Rspamd-Queue-Id: D114A40007
X-HE-Tag: 1780473864-358748
X-HE-Meta: U2FsdGVkX1+BgVT8Wg74QAJnr6qCOhAV8l5O9WlChjdF//9IC17gMuaDR4oFJxjTrbpQqdaytpv/5yhK1tqvK1CD0bmt63EYXBSAoF0p67hqYim75zsU5K66IHXwoQah1DdGXX3wXE5JEH8dQkXm9BiON+rsY22fvHOqTnC/NHAHqAKDBvVF7Vp3Q7R9O+2XtFfXLUnzGjiLgeMaSE+oLJpwx1uFtIMWVApMERBwUQk7fROPobbtBu03yOlZ66J9wcjnGwnhtkWLmMOawJQNTjeKpucmrb9I9qk0MH6kJZ/QtwYJ9aXzixXWPGvbOax02Cus4CSTKRi3knwhYkEC5D0isXW9lEpek6llSrbJMNmry7y1gtDW2QCWOZG47ftpkit6i6vB08YoN/gjP3aXUYLspAKKBxsFSQ5hiIX2HieNCE0bQn/5mzEzOHdaVqFw3/CR1eBJqb7UoCZO00uiBwhHjnbiRnysGitOBv7zp7T0AipJIkxXGYeTb5YPvaddNk04SU4DCsQIvRrN43E/MZD0Ec8jfbteu6zVuLbUebqtyND0PNML/IRWzXFtF/L1WQpNODo2B9KtZPSBOirkO0jdh6Jm/8aZfIS/eWRNFJNdRZqUf4hp/ApoX3P1ezZ5OZR8pHC7OhXMDp50II3w5EdR4EnzNQYPBVHJPv/DbUtzdd1VRfvlWsNe9y+ZRw73P2+hVUuvBaDGqae3nqLXfjXPgNMr4lIBJoE0rKfiuMD5xoWie2TjTjJhLs4gI9tPw9smKm1UPo1ncY9AwJ1GGQOIlm6K+6KrexD28gbb0YfLLxj4mLRhVe2Y7LqkqLkyaI52Mv1uA/3pT3uHBZfxSG1QQr0aNehDT9irM1y/LNQ7BH0DlxJAlmECBC7pLa4lavXlskp3SiWankOEpVLSMhvkWskle1C16ib+jKfoaAa+Q/z+sIXvDK8edMHdcy0vDjbcBr2E3JmvjWAHs1V
 Asit48s+
 FrgMjmpLrNLr/30K2jgvEJTDG358n7xQn+QAPdTFijL7ns3WTzdUlYuOSucPiZ5icAm19NWzZQkDIFI1Y5eyx211pYzb5sChvYxqRaRKR3zPTYiOO/kWREWyHt7973RKH5+BkGuImdRUOfsNy1EsxPN5ZuQqcYK7iSB6ri/t6F49qxGBJ6RcBLFOE+VOB/gOs9X68dRSSBIO0g8D7uMx2wNIosednFDPyDHMLibA7nHz7B8CiXR+ICxNrEz91H2INltTzYHhogegvs0UsYfys2g61zTY5GkR80K/O/yZcEo+tKlys0pmjFPnqhXLfqr+WgS+iO+sfV9rD75c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy, core
ZONE_DEVICE page setup, and pageblock metadata handling in a single
helper.

Factor the refcount-reset predicate into pagemap_resets_refcount(), move
the common page initialization into __zone_device_page_init(), split
pageblock handling into zone_device_page_init_pageblock(), and wrap the
existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 62 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 35de3b6a186d..2e5899c5cf35 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -987,11 +987,38 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when the free path for this pagemap type restores the page
+ * refcount to 1, so memmap_init_zone_device() can keep the count set by
+ * __init_single_page(). Otherwise initialize the refcount to 0 and leave
+ * it to the allocator or pgmap callbacks to raise it when the page is
+ * handed out again.
+ */
+static inline bool pagemap_resets_refcount(const struct dev_pagemap *pgmap)
+{
+	/*
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return false;
+	case MEMORY_DEVICE_GENERIC:
+		return true;
+	default:
+		WARN_ONCE(1, "Unknown memory type!");
+		return true;
+	}
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1010,7 +1037,11 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
+}
 
+static void __ref zone_device_page_init_pageblock(struct page *page,
+						  unsigned long pfn)
+{
 	/*
 	 * Mark the block movable so that blocks are reserved for
 	 * movable at startup. This will force kernel allocations
@@ -1025,23 +1056,16 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
 		cond_resched();
 	}
+}
 
-	/*
-	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
-	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
-	 * the count again when the allocator or driver hands the page out.
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (!pagemap_resets_refcount(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
+	zone_device_page_init_pageblock(page, pfn);
 }
 
 /*
@@ -1080,7 +1104,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1116,7 +1140,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (pfns_per_compound == 1)
 			continue;
-- 
2.20.1

