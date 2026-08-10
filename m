Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF00C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A256B0095; Mon, 10 Aug 2026 08:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9115F6B0096; Mon, 10 Aug 2026 08:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F706B0098; Mon, 10 Aug 2026 08:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8AB6B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:22:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA7381C012A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:22:37 +0000 (UTC)
X-FDA: 85085273154.17.FDCC21A
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf13.hostedemail.com (Postfix) with ESMTP id 40B282000D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:22:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EQNj1wu1;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
	b=DJdyalKkMW051mM5jKsU/CtCQQIDIs3jhp/NZI+Af0Vrif8q61+WOSZHW84V8IgmEjvzab
	arzAhGFzluJbJhuGtdBA71dIPHFWUPl2MjunnsZZN4Wk+bLMzCs+M541ggMswEldojUnX8
	scq1ppRp3KeioTINvQZK0GbcNrGnx2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364556;
	b=ezA2ZaORf8nv6d1qzUUVeB4GMamTlbnvqg/PRGflcmRigz4jUDDOb+pmIqZpw76C4kD2eg
	deu5qnGOXOC7j/tQcupGZAcdXHCd7ThBP/e8EUSgBI46tVD1IvASxwTd2rzHR5oOs1xnjk
	CdrhTqukKuJarBK8Om1mkFx1xMxDm0c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EQNj1wu1;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364550; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=z2FZl2/YzaMjC0aIAZHsTKk9OBnNm9ulSHwBzV0fwO8=;
 b=EQNj1wu1MdksK5Xx+IUlx3uiyjJAVBhE30PDdio3MhJrGmHu6UgPca+v3miVaK/IqngmAC
 bugRdNGiyUfFHAjjzTjGh5Qg4pyssRBSKfi/74WxMpgU5uiKUHk9f0NJP1jjOG7ukBC/nk
 WR1dSiddlc94zmyBUI5hXLs3EHFyetz93baO2iIB4PeZKtjKV1dDxE45ZrXMw8y+LqNsyK
 v3gMXjCcYKMPpZiswGnzDoMIBz3rmIKudxZfiQaAY0V+oKK6f0gUdBfk44Udg3+MrO7m7X
 RsqFUgKSP7KFUNCER2fATeeBWWnEwin5VAE+u3vDm8eIE4xR2EhBDm33paHb5A==
Message-Id: <20260810122057.30447-3-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2026 20:20:51 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c284+0bfd05+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v10 2/8] mm: factor zone-device page init helpers out of __init_zone_device_page
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 40B282000D
X-Stat-Signature: ic9fz3qun3wkdtdad78uein9kbqbh3mi
X-HE-Tag: 1786364555-326507
X-HE-Meta: U2FsdGVkX1/EDvw1px2gLyv8Y7x9E0uAsWgUL87Coo8qa+R1AGwItLP3W8cQ4+CFNmcL8xH7Dd5I/7H6v1r5CPWzPT2Iwlejrz6qAJLH6DwMoYSRLQWxCjS8qVEzUqCDU5uu/mN3zXjwifNQg42o+vKOT3srRHKVnQLxEwwWzqLRaqdBbJVixygAEoxUIHjkgF6aCo0J5wbgIcaudXnRwi6WCQ+ZbPuUnUCZyu3E6ufQwb7w3H0RdjFUHRvo64Y6X5wHwP0tecL1PaPgUrT3t8ItSLk8o5SMlhxHRKcKGxod+Rs68AYiHTOpIU4mISMK/Bw5b7II3sSPlVGQwM3xYKIDDPX6ZgMpGKabkqOIty1mw+c7t/wCZq3Pu0ywZqrSde0VDkbkwCRkrKF6UTdl3VisRikYfi7a4vM51uRAgA0UTIi+HqwiCqKJd2087abEjS0r5tQFEDXYtWJLyAvirn5xZNOGAkwLj9cceQiz+SO9l5YsoCOyECxPVVCiW92F4vGUM4FMKO1eMVqZFIdeTieJ4YndyDCQYFH/71ayk95/sgnWJABnhdjgwq2Uq7eqZWkFjlZ2M+vEK6uj+0Rw7iysPn2wL5cv+bPWjKB+G6NZBv+xfEqqnTyj8Kdja9m6swmmOjIAfbG+HBk4y07fpg2BLMPT2liTz9wJK6CB5BTsUqOYf5dSBLXQJq2J2DykiekDB+ywWiHk2P01hMNnXwrn1b0ESrJMUnJCeH8opnp251gE70aLEuPPWNASDAwpOsK0+zY7juV6m2P8KqvVmTW3ZL7K7dgLMo5R1Z0+12cvtSDnh2rWZY4fj2vswn0QcmDF2YoCeUGR+cbcUh35cLBrNA7NoaWaNRqqe+OfV/EgdrhUJBhwbf/7vxOhG1SJ0frg5KGkxVikPAGtWAVOrj50XoiSzk1dbfZZqb2q7+PupnV8bTpCXH5H5pMEWR8k6G1o+AfsnthtMxFJQy2
 oF8G01Ip
 JDEsbZY9NQsxxkZyIYmmQNbrVVsSFmhDS0YeCmusBfveed2nj/pl1gESDtz8UV1BM5PUUx50FA5MVP70w1AhVCtU2FeHdv8pd8u9u3oMyDMFMIOba2lqwxJkw0JpoorWJGc7nRu9GECzDhfc9/6/tPKBDpgU/pyHXgAsHVuMBHeZxILrxMkoYOYJqGHXXIIkE3dS0gw8gTx1TdWt0eOOG+QtXGVzM6EMcI+ojRgMJS/1alo8FF/hdbLu7AjQCjiqaExIkbR9gZWBv+WlUoSUAANujqxddIm7OSb5ouGUUImK50USlgq66fjA0OnlLuN1hYrnusaruPhjFm8DciKFRJ0tczCxGWEQyT9X9tj2GfciSsMl5dGnFm4LqhMUqjcQ5sOVQnWSrZ4+xALLFPdCclcrPmfy1iqJvKZ8NtHb7qhVDcHlZvACgI8TOYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy and core
ZONE_DEVICE page setup in a single helper.

Factor the refcount-reset predicate into pagemap_requires_refcount_reset(),
move the common page initialization into __zone_device_page_init(), and
wrap the existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 56 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 19 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 95808ab5cfdb..a70acb7431a6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1005,11 +1005,37 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+/*
+ * Return true when memmap_init_zone_device() must initialize the page
+ * refcount to 0. MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in
+ * the free path, while the remaining ZONE_DEVICE types start from 0 here
+ * and raise the count again when the allocator or driver hands the page
+ * out.
+ */
+static inline bool pagemap_requires_refcount_reset(const struct dev_pagemap *pgmap)
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
+		return true;
+	case MEMORY_DEVICE_GENERIC:
+		return false;
+	}
+
+	return false;
+}
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1028,23 +1054,15 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
+	if (pagemap_requires_refcount_reset(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
@@ -1090,7 +1108,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1126,7 +1144,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
-- 
2.20.1

