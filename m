Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C73B2C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885D06B00A8; Tue, 30 Jun 2026 21:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DDA6B00A9; Tue, 30 Jun 2026 21:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D196B00AB; Tue, 30 Jun 2026 21:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4695B6B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:22:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C3DD401A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:22:56 +0000 (UTC)
X-FDA: 84938458752.22.77C8EA1
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E0A940008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:22:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SyYEUTYW;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782868975;
	b=pqPOvw5PsiyeM/tRpf9WmXEQs5cOfn+nIZcT5aImYy+dlcUm7QflszxHO5IEUEADm/1wyF
	OlWEfnxY1K5NwSeAdV7zmwwGPLVGMST18jVSR3TOa7jPv8Rg0NPyBA/84WkWJ5+Z/uf0+k
	Jdfu4iKFKEfbzWdCIOHK9vsLt1BB4xc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782868975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=1N2i2QB8P3UGYbbr01vXoDRr6nPzlhepSD0WCLv5Oe63ifU8SCarahxSUdOCMiT7xFLAtu
	5Haw4N3xUUC68jDCQRN1ymiH5ZJ4SHH1r22IX09Lwb1JtzdPRAR060A9DdXfcX5EWjFkzX
	yfLB0xvQ1kAU0F/yn+oxkn8hy1sw6NU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SyYEUTYW;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782868973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=SyYEUTYWxEfXkpe6axwG2eg4sc2sFHN9VJs/m2VpqmEWmnnUhsv2kg9xuNZQME1zhILi5s
	1CLpml0Qek4So6jIAJjtLTh7GpXpzW7+9eypDyYYABkmB3D0TWWO7IDBQn1pzDy9OJd+lB
	baGnRGtdpeum6k3IRxUxCbOkOVeb13U=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/7] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Wed,  1 Jul 2026 09:22:27 +0800
Message-ID: <20260701012239.315262-2-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E0A940008
X-Stat-Signature: z9i5rxtmhpi7jysshqt6w396iphfd5ct
X-HE-Tag: 1782868974-100511
X-HE-Meta: U2FsdGVkX1+0t524ZJV6BOVo6DA3o0RqAavgtbs1IXCaI7oirzw+Z1lbyix7NRQ7Vp3KyvFDbBTFZW/rVwypGHLQOTiK48rP4qelqhFHaJtuwuriSNB1M5vziJ7j/xeHgdwS60NyjQ9Pb27a6fWqma6f2F2yzFTDcmw5nig+vBK2O3UE0DO/RuoNCG+opUDvA72G9l02vhvHW45HYnCp1ldCl3AI+BgmxkLRl8cJ44XV5Uu7JR8tsPBTcmDIEy+QjnPk7oCNjP2+nVJsiSZpGtVa1d7IO0t6q29XReeQj/EpvYZL/lSIbgZmpRJs3EzY9w6eQ3bAC3R30ls9v25WIQw7x/g8V9Xc6ZuPBpRPXDS3jfX1r8XyTsN6qFRgOtVPl2tw45dsOaJdrXwX6eKHaEhC2gDneB3tA7bVxdRdxGUePOuzgaaRv36SjaRMxJpvW65ZOiBjWUOe/6sYNP1GyuVIrs8+wSSzpV7WDXbh+LsKwE6jFGOLU5EuRPpMLyPa2u99SMGdlK5qp2e+RH527hvBiebfUN6XHjDHQmaVDlXjryu/FN3ceNJYvoDsCTOR7EKbCVA/rkzcZhyH3ccpreMYkMjN2ZDQppzMg7cXOEkmLqkv2aiBqrNSiSKlt+sFXlcv1B6WyR253QGxslr1MdZiTaZZ0FUO/zfotxhJpOnarSwBR64/lUDInf19NIsBBguvJPfV0HWseVk2Efa/bL1MVAzGK3zW8n36WwCdaOhhGOxYTSuDhJWE9RnyIY2nzXweg5XPqIJyO8FwLWPAKGRbZNetnRgjNICJ7rJ9ozlPRDvkrsIHEJbT4X8XupfS/EuDogCKqBwYbiEi/kupH47JmKpca/pSqhb+f3Wiknt7T0we17nmfwFblyPTPxKL4Z5yWyyC9smWXl2chvbSsyjUF7/OgGG+dZhDWTDw5L47ncHzxCqR12KzgDgZ8NX2vXEinevGelyHmgfdoHo
 BaR3b2Jk
 qc+wvOPQDPGDHipjPXaXnk0+fkI3AXZ6RPBiqWyvdZ/sc/+lYovkRX/iJ8FbDP/hbxjryptCuRoAPl7z17WPFwQYe9UvrAQAd8JMKIu0QHLQ/A5Jlfitl/dnRZDk0NX2JqpzinHvi2A+H+e+vcHxaSbPcemIi7KxWab8gnFqmd9XElObBp643NLtSBqiMH8DAS4UABgAKpmHsZLJWqJOXPg4yFWWalNA9A80GG/ekJbUGULbHBheAPr9B5bPlczhLzKBfN54Nfmo2Ro+sYhG2awrBGhGWfuwcW3TAEFz4KjEgccg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three places in page_owner.c duplicate the same pattern: check if a
page is PageBuddy, read its order via buddy_order_unsafe(), advance
the pfn past the buddy block if the order is valid, and continue.

Consolidate them into a single inline helper skip_buddy_pages().
The function returns true (skip) for any buddy page and advances
@pfn past the block when the order is valid; returns false if the
page is not a buddy page and should be processed normally.

The old init_pages_in_zone() variant used "order > 0" as an extra
guard before advancing pfn, but the continue was unconditional and
(1UL << 0) - 1 == 0, so the behaviour is identical.  The comment
about zone->lock is preserved in the helper's kernel-doc.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 52 ++++++++++++++++++++++++-------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 2dddcb6510aa..342549891a8d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -422,6 +422,29 @@ void __folio_copy_owner(struct folio *newfolio, struct folio *old)
 	rcu_read_unlock();
 }
 
+/*
+ * Check if a page is a buddy page and advance @pfn past the entire buddy block.
+ * This safely reads the buddy order without the zone lock, which may cause us
+ * to skip less than the full buddy block, but that is acceptable for page owner
+ * iteration purposes.
+ *
+ * Return: true if the page was skipped (caller should continue its loop),
+ *         false if the page is not a buddy page and should be processed normally.
+ */
+static inline bool skip_buddy_pages(unsigned long *pfn, struct page *page)
+{
+	unsigned long order;
+
+	if (!PageBuddy(page))
+		return false;
+
+	order = buddy_order_unsafe(page);
+	if (order <= MAX_PAGE_ORDER)
+		*pfn += (1UL << order) - 1;
+
+	return true;
+}
+
 void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 				       pg_data_t *pgdat, struct zone *zone)
 {
@@ -461,14 +484,8 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 			if (page_zone(page) != zone)
 				continue;
 
-			if (PageBuddy(page)) {
-				unsigned long freepage_order;
-
-				freepage_order = buddy_order_unsafe(page);
-				if (freepage_order <= MAX_PAGE_ORDER)
-					pfn += (1UL << freepage_order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
@@ -697,13 +714,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		}
 
 		page = pfn_to_page(pfn);
-		if (PageBuddy(page)) {
-			unsigned long freepage_order = buddy_order_unsafe(page);
-
-			if (freepage_order <= MAX_PAGE_ORDER)
-				pfn += (1UL << freepage_order) - 1;
+		if (skip_buddy_pages(&pfn, page))
 			continue;
-		}
 
 		page_ext = page_ext_get(page);
 		if (unlikely(!page_ext))
@@ -798,20 +810,8 @@ static void init_pages_in_zone(struct zone *zone)
 			if (page_zone(page) != zone)
 				continue;
 
-			/*
-			 * To avoid having to grab zone->lock, be a little
-			 * careful when reading buddy page order. The only
-			 * danger is that we skip too much and potentially miss
-			 * some early allocated pages, which is better than
-			 * heavy lock contention.
-			 */
-			if (PageBuddy(page)) {
-				unsigned long order = buddy_order_unsafe(page);
-
-				if (order > 0 && order <= MAX_PAGE_ORDER)
-					pfn += (1UL << order) - 1;
+			if (skip_buddy_pages(&pfn, page))
 				continue;
-			}
 
 			if (PageReserved(page))
 				continue;
-- 
2.43.0


