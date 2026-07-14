Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F58C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1D86B0088; Mon, 13 Jul 2026 21:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72D76B0096; Mon, 13 Jul 2026 21:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89426B0098; Mon, 13 Jul 2026 21:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 963546B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:51:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 131F5A0270
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:40 +0000 (UTC)
X-FDA: 84985705560.02.E6EFBDE
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2654440003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q9MMIWnr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=10CA+VWQ/tmnnnISu28kRakrc4Sv2sfE4e3lV24CL257Zt2A655Y344s5inIRw9WmrqcEw
	6V4rH2arb8c/JkplzQCZPt86j8+0JGKU7DDOi30CEznw6oC0/8cp8eimy7gZzCwWj5OV40
	Ck6m51kUO3Bl1/EbMC/Yiv9TsfYUCrk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q9MMIWnr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993898;
	b=tXFU5kMZgj2HEPeuR3qsXCmIO8F7zio4C4kAXJhV1AGBn3kwPvh9OH9pBlVLvwwnFll7g2
	latDpNZBX952nnRuN39X/qau4KY4VXcHVk1Q89gvvkudcOOXX+RTQ/pPkotPuz8utjnopK
	sYiKQ+/A4eC8gp8SnqgkD9abZ7UIRwA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=q9MMIWnrG6MMXSjSwOz6WBgZTgDuv8pCguuTBtgut4YzhTSYjwchyKhMO5rI55P04ujT7t
	cnTinz3UAN7NBNIz8Hbo79jT+K5J6wOXNNHj4gFV/FO/aCezggwftfpIJV4QI+MrmGcU2B
	myHIU6NqkpZAl2gj8TZx5KCYkxWyUAM=
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
Subject: [PATCH v6 1/9] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Tue, 14 Jul 2026 09:51:00 +0800
Message-ID: <20260714015117.78351-2-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2654440003
X-Stat-Signature: 6rh7mw1cipux5xzfdizwt3bb695xyt8f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783993898-6263
X-HE-Meta: U2FsdGVkX180L7Ns/CB0Hwcfzs+61yLw21BmCR1yt1HaDQRfR+DqhA/ecufQ1BuFLuiDipAJgOJNGezlKvIGCRv4K5GFkIuwfv0dsWJCmA6Ro+qPOgnUna7ej5e2QYX6DcOtzvjBIravQcloeuhqgGmyWMpoKwOphBHdjAHndu1pszZNGurZbaGhJSVHdTpQ76jIsD96UdUDjZQQ1UCbortl6uMWNxDl/v0rd36rhawRVzWg/lXtsQsoTIETQHuuSf5UHzVebtU1balDUWoQyrVhiUUh+G30fMkcXEicP/WNEtjEF7sMOUJEwURv9OYg8bcVrFGBeoo0P3PxbVdID6yb6Ykm+OV7gJqnWxkYcnNSe48OELUxkrhQSdRGhXf4bL4ymjALCuf5SRMUCwBtyeS7lQYFGrgCdS4Y4ZlGoB9U8U7mc9PdhsVKe4FgSUwIw9996ZI5v41TuIUB0RPDcP3TzSX05rObOaFgoPfM2ZGEPt3dS/+zUMcx/e+ChrD7jvT0EEGfjMHYfWEjD7E+G5wElusfgJZZ4kApqyWX9kqnI/UtSsxgxnfS9vhg1BGbfzwznwYG6A0heN+FEP871mzFsyDIsFysQCNWlVd7FzScMJ7PY0PQXU0Ygd4gUZBJUHC5K2KvB03SoSZQXuxAayuQIlx+FoyzM/1FLQdeG0tEmo5q1PVqYYOmuW8i7Md3zw9c1Ra6l6ENlUVrMsFEp74am22h74MKxaUwP5StKpwojGWh6JyH3IeXuciVCPkfPCqj5r5KSg2tCvxEmkkdRtQxkN3QcHH2WeeijU/0GtRyowEZYQVGIYVmc+4RptesnVTVviGkzE8ExmTY14EJLPpovhKOYfTo/1khOm/z0HGQ7oS4kYXZ2PXu1W8095NsMZQPwN/J07/1U4X0Tf75ytg/DbqrL/zlMScBYVLGMA7fVY9TEwkSIyJmW8Q6MPBoelbyooQznnU82aq5mBT
 uxBSqizZ
 2K97w6Z4SbLKcxqj5lcD3Jr0TZnfCOeURdsrCc6x6jcducEjgls8OZX/rAYxtENHO5Fg47cmC4+u8dLyrq6FxFY4kqDhPKtE0ofjLbtvnU98sFsNmzAY2wFUB3EGCIOqhKfDA098GY3nXi+GECfHDaDGzAf6VftXupWcaC6gbKR4dvc+tciFHWkI+SMvf28qEhnQkatlBSQUVOaANtkIR0vIPuy88DWRc2zO8jaLoWy+RffKD6pb2waD+atxtTIG1ydtJqKTBOigVOigFR8zqP8TNFnNu96TwerwaHEFxvGnffpE=
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


