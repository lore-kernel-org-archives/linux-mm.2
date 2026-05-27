Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 626A3CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8EE46B0005; Tue, 26 May 2026 23:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F406B008A; Tue, 26 May 2026 23:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54AC6B008C; Tue, 26 May 2026 23:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A58666B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:38:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C1EFA047D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:49 +0000 (UTC)
X-FDA: 84811793178.09.BDE462B
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id 560AC4000B
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:38:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="neZhJ7m/";
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAoGwOogI0538Jjz3Jr5mPaMM02ePyByPYJiX1kFuRI=;
	b=vicTA7VISqcbglehSN8m/OfZbe4CLh+tkn8v7D6mVPilJxAsRdI56CzzEWSMQNKTQLUNxD
	fYdylqsgQna91n7TqF/hp+fzekUAqIeYldeKd3VThqEe1fEB4AYhrS9um/N3ODgAWSt7WS
	OBs727w5LEu0KnrOJd/su7XhB+KcVM8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="neZhJ7m/";
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853127; a=rsa-sha256;
	cv=none;
	b=JN2bOcbXWB5qQLW2POm18ysjUpGi8khX60kg//04aKuZn4dgJ3wtNSKaa1uF1ZrkhCV2FL
	XcF0sC0Z1f3YqZANur7K/yveAlZSVd7jq4fW3aUBAu01mvGjs5s3xOT7iWDxuHLkKazU9L
	i6zHilTX5DdxTFV/xlyG6CufljdclbE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853122; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=PAoGwOogI0538Jjz3Jr5mPaMM02ePyByPYJiX1kFuRI=;
 b=neZhJ7m/rmzXpsdK/7NyQsm0Tyqm8pOxRJ21fCT9oMOcS4L7iqlXO0Nxhrc0V7VavhVyAe
 GwUkBQA5f66OnY0/zBq86VK6Qnwn/DYWUrh4lIryFRsEVRqLVHyTKx1VEDM3TJmdomuIKQ
 nB0c5FbiXbpal+2WX7Rq1AloKVMByqVMLVMw+42dZFa9Y1SmbEhBYktLgkbJRNYBtmlG0v
 BRsd1UirrTmEUwpxGDOimZZvjOOfm3G3+jR6COoa3LE1hbABUVSgD8chus7VccHzOuu2ZW
 xnSEjwyxcIMBMl47qzyu2T14Wv3X6AMlN+Avo/UGRT5GuqlR7C+calqK056fDA==
Date: Wed, 27 May 2026 11:36:30 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a166740+981a74+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260527033636.28231-3-lizhe.67@bytedance.com>
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v3 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 560AC4000B
X-Stat-Signature: 983e7eh91wqzajtwg5nb5b3nmmd5aae8
X-HE-Tag: 1779853127-102605
X-HE-Meta: U2FsdGVkX1+CtaxukL7yiSXUrQ9M5AsFjcm04ljaeKkoL/1PaNmosqYL6WS9CY0LNlkCqDhNPKgqYRSPyOcJB3N376PfH/BppE/BA3rHnJ5lRqBLjRUYW0jSEp7eyAyGCb8lWki4iyz7ECD29JHebOEWrFu8/FBko9fKDfWoNY1GDmEK8WkIeV7x1F9wtTkbFCesH3nME0DpSrKfrPmPYcSEYgq14xY0moh8768Kn5Nh2EPSE2WsM888g0yWi3sK01YJ5bxQmPJM+yrZzAS6SU3ru4EAuMGdx12IZlIuCOg71/Rl+EaylxLBKfU+Di9KANiMWjaSZ8mtHeh8UabxzkdTPK0e3E9ipxfEnnNzCdkThGY5KL3EMIHP3ZKjXychs372CJxggt9LFBVLWsVyE/dO3E5c/JpdtDIpuMSV6Z7geCPyqSAIOTWSRS+EjrJzvplZR0UgY4Gb9R+GcPt+0BJoA93AqY1oenZLuFJtgBZgmNIo6BbfTaIJzO3MQGcRHholMfd7pGasZwwNMs67qy+wMnrtdentrq93hsirXpFNFIz9meAYxvkCT+mX+rA4W/UBpqNZmL9PdNokCU/ZBrC08sSf/D+4qlh9gJRQjpGHh1oTir0km2LIMq9zLS5sU2TYjD80eJXbA0w3pLLlxzSZxwxW57FJ4kVTld69zs1VvqRbNC5ozjHOOgCUauHh3DJM9yv+z0r6rWhzXcX4+1dOQ8TuPPkdMJ92dMrqQApx1ADtclZYP+O+ed2AVlJ7CrbZIussfoIU1EiJAQHtjhkmU/kuRXvcChjuvPRNrB9StcYSlTq9r6/BJA5v3nNLEBmKme4f2lA03jQbrctXD13hwEQf4VykA58kRgf3JG8vdEe5TLHqHJOAdzQG7zZxrHXDkngNs/6rN/YBGyfVtoa2v7mL9aAuD1+fuFUN7u1Igm/XEGpnjPIPl0PMQIadJ5VmGifR3Dsh63cgZIs
 zA3oD6jm
 v5A8TE9+ZrmTq6nY6BzvTU8tCgl6wAf/tJaJxuTbFC4bSrh4QVZYfZESLs6QzbQIZiHqpXnekpvuA6oO2ULnFcTsf68Adw25SzS9npH/Wg7onJJI9wOGsPZ2M4Rs6PMtzw338feKaFWUM3O1lQIALdGCBuf6DSCPT6FXp7FDf3HSQixpWMoMv/aNVV5/IUc1+JWtX6W985E7bMNoveZYqv+l63yHG4zVzBkswYBk0iB4ip4EMm6ZAWJMvvbbgIsh21yu7hPFlFjCrk4wdk6Su2+lF8p+xw485A7saU0RVGkLEfmw5/5cDZec1S2m8mIz94b9naYz5HUGnwbw=
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

