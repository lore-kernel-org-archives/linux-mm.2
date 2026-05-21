Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2122ECD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 824036B00AC; Thu, 21 May 2026 00:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4636B00AE; Thu, 21 May 2026 00:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3616B00AF; Thu, 21 May 2026 00:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 571DE6B00AC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:03:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 028B51606EE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:08 +0000 (UTC)
X-FDA: 84790081698.22.0B45765
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf30.hostedemail.com (Postfix) with ESMTP id 180FF8000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:03:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nN5kh5pf;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8qhTx7yx3vMMJAHefyPo3ETAaMxzAsg7BKGCu+RwJg=;
	b=ROhgxnzsXaUl0R4x32I0tUiZlwniHYrmVmD9e+fcf3KEXOrOpHz1z0kHRfLt7l646c3rLh
	LBi401nVRGH7D+tqujvWJbW4nFV5Q818bmNwwJwBpN4T6yScQ+OrfI1cQLomcSOewSjFiq
	np06N18g0YjtQ448q3LneJ+oH7I52ZE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=nN5kh5pf;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336187; a=rsa-sha256;
	cv=none;
	b=Ow9iWJO4Ehjqk3oRJ1pBh4xUTvbj6DHD6+e7biOoLvZYZZEhoHGlW46xcqu24hIdR1ncNo
	htP3uIk8Xcm9OH7heoCtMX8/6wGAtia4dmoc8NkZT8Xf4UOzYUtftbvwcZjDB78dtr0mM9
	9Vq75zL26NWnj7rk79xmZpeqPO66eew=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336182; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=r8qhTx7yx3vMMJAHefyPo3ETAaMxzAsg7BKGCu+RwJg=;
 b=nN5kh5pfL9Zv5Rs68RqL8v/tzSR9cbPc9Ahep90oEPq2WAuLw3HRCUIOczDU7zuo2HXn4Q
 gW5eEyG+XzrZ+S/AwwjMzJayY4LHpZ9ueORqRbF94qX6jtKsOjTF9YUSOFtKzMGkk9Ikvh
 KCLrJ9h6nXSV60UxS90tqJmH6ARyqmniszXZe8fm9vsV5hu6004uy1jrj49i4BGs5GQsbp
 fpjvPTKEzYVeoNDeQtDxDBfLQhEkhHKdXZNd+hVOrqC9E+fmt9coGOOBWHpoC3cPbxxKTj
 frlC7hknG0Yrxy8HxyfKl4cKCfHKTu3q8ZVzSojPLIO5Km3KSHBM7BYvXHtr5w==
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Date: Thu, 21 May 2026 12:01:18 +0800
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
Subject: [PATCH v2 1/7] mm: factor zone-device page init helpers out of __init_zone_device_page
Content-Type: text/plain; charset=UTF-8
Message-Id: <20260521040124.10608-2-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a0e83f4+0f9157+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 180FF8000D
X-Stat-Signature: nedgcsfpuym5deo4rsfjdjh764qjsp1e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779336186-75471
X-HE-Meta: U2FsdGVkX1+3MjkJkVunvUs7bZB90k9H8UOAz0/YRXn7MhILygyvwpfrPaQOBtnjk8rBlnZpak6yt766TP5tREujZsbljoH6NI+3mq7VyCzNvpOb0jsqSLdoZvbeH8H4ThFN8rnXkiq1+fJ63fiG4xpMmmxGlRbmINL8OopGP2/VN3F7U0h8DzHz6EJe7fSCsDGnAuo0d6WjRpkFqHDzHmuw5wHqLgeI17Rq86IqOtJO66k3qi7QBmBPRJ9ygbwIk/xFu4N1B6XJgPepRXF4AWJkKUXYVXb4rQvWpTmhvKmqZdV0TYWbHiGbEzp2CE82bANdAIeolkKMP/SUsdZQJjc6aYOmkQbqmTMCpTfKu0BjsLzh1hBLvYe8ivggH3QbIkd7NEJsPq4e95kOnoWN8o2ftkbLKZsU9dcG4trvabQPwsGL+Fokz5VeoKbyN/s6PbEwezhXUOui2q29yTjalpE7FCsh+oqk1hfVbd+u9MKi7Qxkf2KIZl8sWYyCruQIP/LH4Y3hNA7kw95nZ1IzET7+h2+GpcHilvng6Z/NFfg4tWcMk4II9+AHvWXJxXjvp1Lww8q9Pa+JFl0tzzNjKetaEhC1mb7GNTV+OR0SlayBOm1Nl4yRRUuByfAncHVfPWK9wMVMKsQun/nV1rw5w6lEugYeCmN7ZfVEgQcPsnhr/8ACVtokDMAuyGo4xWZWnOwtZ9wwEr4W+mW+uaOlUnsLs2/LX5J6uX5GK4lg0J5fItcs2ND90PhzCeA0Tkbx24Vd3Wf7P7n5eejLu8gTsUb9uITtOGTwkQuZz7ETJ52Qmv3E2lSCTgM77S+L8u2UQM3gDbzm5NRItuGr0X3wjmnTsC9gttu+bj5OBfFH/b8i77A4buiVQHUEgm5IWozwwUZWOCd93cNurnRlZH8AoVAIyaKgjUxaIIQRbLohG3x6h6z/Pt0oWXRFFh3hxyL5hd102S1yOJ+BbqiURbX
 xz15abVE
 f2JYjp8KLD5eNZiF9i0YNHOyFtaOoJra9WOMAOv/fQJBxZzHmUOicG+f7y72jH4qHpTRj7lOHHYGcTq/82bCrOH5M5tIaM9URqKPfxxdS2aG4QrAh791uOzohamxnQCRpXTIxsSjMAsQ28ISeB7H+ILYJpkGVaTAfgXNDOJGIe6J5qo41vtR1gJhlHMInIFEV1QhW12josDn1klyyLAb4i0y3x5jpqs/Ow5ZFUSZIztQBqPjHyGOYjmXY6e4aXp3CNOaqk2zxNtWNR/hgGOSzKQVM9nL8AmN1MSHb/VLHwlXmKSkGjwBuKDKDLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() currently mixes refcount policy, core
ZONE_DEVICE page setup, and pageblock metadata handling in a single
helper.

Factor the refcount policy into zone_device_page_init_refcount(), move
the common page initialization into __zone_device_page_init(), split
pageblock handling into zone_device_page_init_pageblock(), and wrap the
existing slow path in zone_device_page_init_slow().

This keeps the slow-path behaviour unchanged and gives later patches
reusable helper boundaries.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 64 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..4ba506df93bc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -987,11 +987,36 @@ static void __init memmap_init(void)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
+static inline int zone_device_page_init_refcount(
+		const struct dev_pagemap *pgmap)
+{
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
+
+static void __ref __zone_device_page_init(struct page *page, unsigned long pfn,
 					  unsigned long zone_idx, int nid,
 					  struct dev_pagemap *pgmap)
 {
-
 	__init_single_page(page, pfn, zone_idx, nid);
 
 	/*
@@ -1010,7 +1035,11 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
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
@@ -1025,27 +1054,16 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
 		cond_resched();
 	}
+}
 
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
+static void __ref zone_device_page_init_slow(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap)
+{
+	__zone_device_page_init(page, pfn, zone_idx, nid, pgmap);
+	if (!zone_device_page_init_refcount(pgmap))
 		set_page_count(page, 0);
-		break;
-
-	case MEMORY_DEVICE_GENERIC:
-		break;
-	}
+	zone_device_page_init_pageblock(page, pfn);
 }
 
 /*
@@ -1084,7 +1102,7 @@ static void __ref memmap_init_compound(struct page *head,
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
 	}
@@ -1120,7 +1138,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (pfn = start_pfn; pfn < end_pfn; pfn += pfns_per_compound) {
 		struct page *page = pfn_to_page(pfn);
 
-		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
+		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
 
 		if (pfns_per_compound == 1)
 			continue;
-- 
2.20.1

