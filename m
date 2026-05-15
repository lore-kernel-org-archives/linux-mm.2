Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7DACD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78CF6B00C5; Fri, 15 May 2026 04:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4FF26B00C6; Fri, 15 May 2026 04:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 966396B00C7; Fri, 15 May 2026 04:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8548D6B00C5
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:21:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1AEC3C2A08
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:30 +0000 (UTC)
X-FDA: 84768959940.22.10AC319
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id 312E54000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:21:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Znklo0rk;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pn4tF8TLTowTahB1RqTQqb2NJ664ubG6BvZ5yr4OYEU=;
	b=4V689XcAxHXLq6Av04kzvbnjUaIV/BrnTdfbzarJv3anQ7v0d9rg3iZgNR2OV1Y0iUxUyr
	7dmrFJJ2iWp/lawFPcEGZx4O28bwILJZHF4SxGXDzP8fnoWEGaXeGIOrQzc5dGnncvxk88
	pt7xUZKhJgBudWFCB19BQf3mKuu21JE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Znklo0rk;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778833288; a=rsa-sha256;
	cv=none;
	b=UaZyQTelTTdTOooZ7+Nd8uXoeWhoDwWv1aVGCKsI4A7zr7lgt37ha9zHIIyGTOdeECj2RL
	QwqGqw+eCW0YyhVd1gEgHcxNYVwHqf6PaZQQss+cygQ5T47MZ/LXXDdVwQ0fm6UNQ5XJ95
	0YZT4FnSfBetNpC/ED77k1mq9vwR8FM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1778833281; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Pn4tF8TLTowTahB1RqTQqb2NJ664ubG6BvZ5yr4OYEU=;
 b=Znklo0rkP4IKckRsKDfhmMAydgK9R8Oap6EsM4b3azWMVFOejBmK0WwjMqBb4OsVV3N/DY
 pmzSLsqXATJkuXgQUJ5Yrb2HeRbfCYVL82Hp64zuP0eOe4DMXiSCAgeAd5Eo0VijZ9yqzV
 ckstGZj56zrU/zn4VilF+VwJs0exs44IlKtG1XydK7NzqXg05scReIcGA+dCJ+JjW7vWPA
 DOYXWYqf7iRB+/r8zxGI0QWa4qExNGQ9h9lM1HRUzaZJG2XqqSDAH1MckCMhaTytabuFfL
 +NIRg5NdJ84cf5c48eZGvEzjau4TIFLW449OBLYYX61iae4ZokdWAin3F7R95A==
Message-Id: <20260515082045.63029-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a06d77f+cb4b8a+kvack.org+lizhe.67@bytedance.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <arnd@arndb.de>, <rppt@kernel.org>, 
	<akpm@linux-foundation.org>, <david@kernel.org>
Subject: [PATCH 1/4] mm: factor zone-device page init helpers out of __init_zone_device_page
References: <20260515082045.63029-1-lizhe.67@bytedance.com>
Cc: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>
In-Reply-To: <20260515082045.63029-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Fri, 15 May 2026 16:20:42 +0800
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 312E54000C
X-Stat-Signature: f68uz8akdb9zn7tajuew3u95k359bxzw
X-HE-Tag: 1778833288-361005
X-HE-Meta: U2FsdGVkX1/TwyLSgEpa0HWX+wAD4JGJK63KvaVa/P9vzNejo7oVBlj8ChSJJwI6Yo6bwrTdMJ/IUKQhfw4XJTuVs3VfDU873IgY7IAL9w7CIbccSOWNqxWLpvwFDeuaXTuBmqFErHpmdj/RERdNExFgK9kSA2DXtzRGKT1+UhRn1hoY13DW8RxzjmMl6m+ujHSng4I5WLIf+DHkit9vnSzNAGg57wd+SNtCnQOP0772YZ6bVlC/fzx66748js/m7jd6ivEy7Glh4OEmjFnNE2WaF6nEkKIkz1nQ77MuJwn45BC6FJ+gYkL4krwYumQ7AWSq61mh7V1bfa1hL1hA8FmfkfGE3BwzwzMPmlQypJg/EU19Gi4PcjnxGsENWVSu7xBTj8B8odXdGMJqJz7XWN8MvM+I9S/4quegaZwyXwQbERgnrS/ZOGNQ0RidakdCQoB7p6/tQiCVl6A9SToaJVEUASVTyaPER9Zvu1WLSviUTuDaWQpgyZAW4Mi8etwHf98H9XPZSLFS5X/y3LR86FcwF8ixVZgAYUgv27u4TewfNS9CbP6aX3ecbGK1hPYJzwwsry6ErpUbMbL9fsWNGBvruJNxYHFKdN3xUEnCUXmFXQDDKIv1zjmDXtiYs9hhEFoPPrS530czmBNMr6iGNQBWBwhpxIdehKNcwMLr3RYiZXTekbcacZ2tbRFGtRzF3ai8l0SpihB+KLAKwnbAo6kAPJBXz6ZVV2F/KLv5YwCafMkbWzx+7UnBkPod4qFjNiB2CiFT0MDpgO51igig+j8pfM46NjP10hN2zHmrRaxFgpOWGHPP04hqwe//nyEJJ6LUGo6PyeYcRZ8S0xFMnCKgNclrOR8/ArZaO9FtE7LiORGzS56YXjMnSPpMv2VwosLmu5NWmPVH3lUAVI0DVZVyc7Hij922omECgAQDDi3gZi6bQwqFq3sDxyw6btEAUT/RP+jM3gIJT1i+UhL
 J3Sj6mfe
 puUfM1pH/M1eiz+vhWBdopGJJTtv0RYHaOZH2A29C5rPZqKmgX4gA8xxRxXNMsqvahkMfbxSLfgGXP6J7h1V4qgKXwofj2BAmPmi4Ecy+GXc08gl8qqRBMaTTnPAbjPdvI/t4gFNMlYIHOmJh6gc+nYiKUPKMh8NVraWb02mtUM6rfnqFQi2O7tE8OoRdq2XvWYbqgtfB1+aSMY7N66aQKNTZhhIjJHpoReWIEZJorI7Rkq4oRlgU1PkfuC86lWJkmRcoikB3kKfE4f8tiMVtoKxxC7nWsMztl23nGaQ9Uee3eF4M1sZv9w1Hgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__init_zone_device_page() currently mixes three different jobs: deciding
the initial page refcount, initializing the generic ZONE_DEVICE state, and
setting up pageblock metadata.

Split the refcount policy into zone_device_page_init_refcount() and move
the generic page initialization into generic_init_zone_device_page(). This
keeps the slow path behavior unchanged, but makes the individual pieces
reusable by later fast-path patches.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 62 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..5244acb96dbb 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -987,11 +987,36 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
-					  unsigned long zone_idx, int nid,
-					  struct dev_pagemap *pgmap)
+static inline int zone_device_page_init_refcount(
+		const struct dev_pagemap *pgmap)
 {
+	/*
+	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
+	 * directly to the driver page allocator which will set the page count
+	 * to 1 when allocating the page.
+	 *
+	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
+	 * their refcount reset to one whenever they are freed (ie. after
+	 * their refcount drops to 0).
+	 */
+	switch (pgmap->type) {
+	case MEMORY_DEVICE_FS_DAX:
+	case MEMORY_DEVICE_PRIVATE:
+	case MEMORY_DEVICE_COHERENT:
+	case MEMORY_DEVICE_PCI_P2PDMA:
+		return 0;
+	case MEMORY_DEVICE_GENERIC:
+		return 1;
+	default:
+		WARN_ONCE(1, "Unknown memory type!");
+		return 1;
+	}
+}
 
+static void __ref generic_init_zone_device_page(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1011,6 +1036,16 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
 
+	if (!zone_device_page_init_refcount(pgmap))
+		set_page_count(page, 0);
+}
+
+static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+					  unsigned long zone_idx, int nid,
+					  struct dev_pagemap *pgmap)
+{
+	generic_init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+
 	/*
 	 * Mark the block movable so that blocks are reserved for
 	 * movable at startup. This will force kernel allocations
@@ -1025,27 +1060,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
 		cond_resched();
 	}
-
-	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
-	 */
-	switch (pgmap->type) {
-	case MEMORY_DEVICE_FS_DAX:
-	case MEMORY_DEVICE_PRIVATE:
-	case MEMORY_DEVICE_COHERENT:
-	case MEMORY_DEVICE_PCI_P2PDMA:
-		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
 }
 
 /*
-- 
2.20.1

