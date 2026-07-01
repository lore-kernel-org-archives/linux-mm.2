Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB6DC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D31A6B00AB; Wed,  1 Jul 2026 05:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AA4E6B00AC; Wed,  1 Jul 2026 05:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7DB6B00AD; Wed,  1 Jul 2026 05:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB6E6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:07:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0EBD1202C2
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:07:42 +0000 (UTC)
X-FDA: 84939629964.30.B8592BF
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB2811C0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:07:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KF6lDpW+;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896861;
	b=mWKo6N3YTNOBHqd0H4xloK51CQ+bLiAlaeMvO35ijakTrLf/CCaK2INFwGEiLLQRsAmX3j
	+ooG9MLkcSLRos3o70+h1puZh6XnUcJt3EnTSmviajb2vHSRPZF/b/8lfuuRMBbCwHbtlq
	mgAB2pj8xtdNUbQxGTiCC9RRr8/Jeeg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sen/XJQ1mPaPSt/blhLYv62ie6B/okRloNouG8j+xt4=;
	b=Gf/5RAz54bxmiGaaH8TTwY6P4pxiUR1m4XkH+2xPkXZLvjDQxwfHkRJXVDbeWEWxyUiTrP
	cfzPwNnbfISK8lydUrBB4Pl9NM37IVC1iZ9v94uBW5ny48SE/DS/3Pa1L2gxBXegpLYd73
	seHFfry317ACVyMGd+tNSMxmYKHpPmg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KF6lDpW+;
	spf=pass (imf20.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896856; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Sen/XJQ1mPaPSt/blhLYv62ie6B/okRloNouG8j+xt4=;
 b=KF6lDpW+Sg8BdS4PEQTEraQEmDUy5Bh5V6qjE4DxPtev9kowk3bjujG+MFBJLEYtKGmAq9
 M+yj9EGBYmk7m+K/0W2eerhaOWdZSM6+LFLLoZwfPe6ZemaoxMZIwzvLWnKJiW9cku3dhr
 i4taifsmiGMgjKn7oyIPts+DkFxovVuZuceTO9vqMfEo5nByQSbxkgdyti4Eohe0MoNHi6
 VLx2aCAfyILWKePjzIl819HoIFB7dcHtu23bC1rIsBtFz5XqhZJKDQtkv4fWXyNINgQbZA
 mFlet4iRHhqQKsx2hP3k0C3LNo9RhUwAdW79Q4Y7PF6vTdkqQnSz03BLrU6j2w==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v5 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <20260701090553.62691-3-lizhe.67@bytedance.com>
Mime-Version: 1.0
Date: Wed,  1 Jul 2026 17:05:47 +0800
X-Lms-Return-Path: <lba+26a44d8d6+d8898d+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
X-Stat-Signature: i76c9xpmx6gp4sgzdtgfxm9idup6kygi
X-Rspam-User: 
X-Rspamd-Queue-Id: CB2811C0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782896860-809387
X-HE-Meta: U2FsdGVkX1/OBJ0X79zbfv7IDqy98/4146onGAZHgMi+UOSCqETsa6LxVKKk47++4lHB0w7fH4Kdph5Qb46UTlpks7/s3fGRHBHt8QekCAs8gSxk/c5sDA9ac9BwFL0P9rVQb4Oq8zMkymalDvsE10qcaPfLd6eiOVrNhnTJzJAtMQlW8fULrOFcAI+zjzIiohU7FTFo3NNX0rqv4WtGVljcy6XT6n+wiXvB8WI5JVZ+/ztDcGYF9B5Fdkzc7QG/xLUHdzn92yjiaajJBofhz9BL1jPwJMQyRRcS3WiKNMH6gtzjiFwYkcjyKv0O8GcCs1jKRTHMN/oKePTTdnoj4GPxH0zr3PGlcaGG3yifFAxCHCLPe3HnySSxgISdd+OntAKdcaup6XaU0eMNQaszOYQ51Jl6ghdpTXSJiLuVnrSk9R9uOXFge6PZ3KCUklV9H5Sv25m5AP4p8IZMMFxTO/JvkjaLbHrsniGStV1QkCTeQdgRkSPxdfz4IElauSjufRzU+G2kwPyPinqrb/cvftENculxzPR/bm954Q/xPvdM6xEsCXeFu3i/zCEbVBCeYSVuTRNm8UZJj+4zy+F3mRAwEkmzHeqYsRCvsqEl4YRh8VWwmNUr3cSz9z+lREtsZEJMS+nrDZw8h+bVyHW/gKD24grEB1T6S+XLEWt7690Dh7z+Cvl06nZqocT8kwtW0PkxDOgRV7R7ddjHs/k7gTBUda0ftI41U2xdVoDS7iYSxiWu0P/SnTwGmglBw3b3C8zLWi4vc2tU4Ear/O8stZXd9bidHLC+EJqsr4u4+yKVsMZOSpQWI8Dm0f619njafMO76Qa7XZym8X/oARCrKK0TRiLRIPgSHIVNMuOVCg26/Ij1EnfjvKYYPB5I8LtyAs5X+iZbnuTH8n4XzML0hQWu6o8A+2EYP05rIx8Ttmm0RiQdubloRDTNGShO/S+hIlpOIulmYBIbcl08sQe
 yd2UWMS8
 PtUXKltG0C1a6pKG6Sk0pKCrxOhzRCL9nieHDD1Yd82WHw/mFBIucwdKE4cl9smJSQOlvJZfRNuTuyS0kTo8Ekl5qoKRP3Qn3bVidsYnGP3c6tKrpBnamFShPSFR7ROGttAFNC3eKK0Wnmn2e+BsgUIrhDgBVM3iXMBUut/VmWyEytozVwVRTROq5tS0dTRBFSlMXWESTnhd2B5cpSupLqi0la55Ttg1giAqqueOOTUv0ESm6OleLuWgPQalEha+GB/EG++QwzWD3rRsFLCYxK7LtUSnuj/kWlW5AxnH2998JR8YaB+GkwCO5MZxQ17avmOtmFrzN0tlcRtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_resets_refcount(), move
the common page initialization into __zone_device_page_init(), and wrap
the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 57 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..4c7fad440c2a 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,38 @@ static void __init memmap_init(void)
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
@@ -1028,23 +1055,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	 */
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
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
 }
 
 /*
@@ -1090,7 +1109,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1126,7 +1145,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

