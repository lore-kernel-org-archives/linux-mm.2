Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EA9CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBAB6B00B6; Thu, 25 Jun 2026 22:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2A86B00B7; Thu, 25 Jun 2026 22:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592036B00B8; Thu, 25 Jun 2026 22:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 310296B00B6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAAC116714F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:07 +0000 (UTC)
X-FDA: 84920524374.24.346B43F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B3D320003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGoT6wNJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441966;
	b=DtPqHHlCyap3ZTp5zd8fqdVIGrSrw7gra2WxiNWEs8J7BqNvM3YufA4ZOthSdydUKt01pW
	FImRZJscSXh+nfkxqMbV1GWZPSwPx+1SIdWFYdXYtH8fuoaStqFgEDDVkwZez3F1w98YYs
	IUYOOQq2FC8VQA03DkOFg2c+TiC9lu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvIJsA3YqPuqH4YFKYfsJHGBnY+wCnYdbztz69l5314=;
	b=GwgvKg0uVpZDI4s6fTOwJEJKYwI1GUzA0czuC7/jOHve9uOqPOOnBn1TEUURRc4Vo3QJxC
	mWY+NJXaAyg4FLxE+E4acfFOVK6s1wfT+IUU2xcduZhlNh0laLRD92BkvWwIConVk81fyk
	yL6/AFn2wUO8o6PpRhCVkgAqAlVDO20=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gGoT6wNJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvIJsA3YqPuqH4YFKYfsJHGBnY+wCnYdbztz69l5314=;
	b=gGoT6wNJnWEEuS0KISWu6vpmFckqv8DVGTIepePx/OSA9YQav0Y7gHwOp5YMxrsJ9aJywa
	hlaZNPMdBNGC8Y9bOyx2YMseA3Ffk95gmnP/tCDZdzXktnGRGWFyyQW0Fd1J22gQzXOe+5
	RsxpH2Z4luSnWc73dc8F4sTXNJIArIg=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/6] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Fri, 26 Jun 2026 10:45:40 +0800
Message-ID: <20260626024550.25677-2-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B3D320003
X-Rspam-User: 
X-Stat-Signature: bsjujeaeygxp13kqhp4ocgm4ipmjuxun
X-HE-Tag: 1782441965-196048
X-HE-Meta: U2FsdGVkX19+FJTYaxikveqPYvwrjWspeXvK9qNb1JequPYu7WO6nOnjst26mf9Oe1HwdYYPR/8EnNoiD2zEmwjiSqKj/Dvh2abE5mf3x/i17KkF8JmAObNVDvEOCGta/UY6vK6GiiaOkbvNeP8n2w5yJ5WPnGq+dvYU9omMkg636nj/h+eOd5xHgdUVwVg6xLru28SPlvKFA7P889lvEm9EZ4Z21RQeETvRovtvYXjJz9uRraH3LyRnfUg8BVcAe35QLrB6PotiH5oeE7Otab5h6IkOooBCsC8YBcLY+kKML2VHoFxifJHzfKg1+84cx7CKOmFsVJs++bFNcyiy+PPtNBuev24iD71nY+rQYaz1TuTEC/o1OR9Jh95aGkHFpqRfVV5Jpqr5mKfmE4pjSjVgOSvWUxMsg/xkO3C70O4n9CJnnuP7geRQDJsyMyeNPLaybhLan8ih1sAk4ur2xzB2var1tK7+6dJqBhZhfxjB7qU3h1J+ObHoAyNbp6E3U2oHWgnQyPJch/lYf93iAq04+714h8tz95xTpWqhsXnhy/UcekJxR/Y5Ls02pwwnrWbh5hMCOQUQed8LemDHgmQ0vPP5MrHsuEQiyQ6XoML9VRwE9xYkmH9LUOvpbDasLm9T0WVw2nNfqd7aV572BOMXqZrmJu0MwskDnsYQZJ9Fwkko8JOoinnccfS24AqckcyPJD57OPYSD7Ls9+GnnS3ljRpqv5vT0LP9fw7Wbw8wkLJMa+9gYKRS22y+yqRNOQNR3f9RJJZera+RI0/yuKDaDi2mfb7q4CVt52rmmQMDRJKreuOQlBE30yl8N/IolhEsGmjFgWqotPlUSnxxyJSD0We42xLNT4kC7iruqqZxsJO31ol5NVFzvSjckYKyYbDyb8ytYwH68vwJQb+TtGs+X/k/pdkILIvTF/112rH/nUbq6mMIu8TFXzltohMIKZgR0wobr9SrCEz1Mr5
 MLind4+y
 YV5Y0JdhEkohtH+L7UoZ/ZW8ETueaqQAWRv1DQTYWSOGr/wZxD+tJq54UwSXPYjOtStW8SWONjgtOmeLfH5/3XfcTPykD3mxF2gz6LQuVJk0vZTecPhpMVk9DgicvFSGCTXWkTQN95lIAiOtZiVL8rqZWBQ96AyFswCeVVprlZgsTjdjnTB3Ol6OaFnOHUD9pLzFW+lt12Gv5UIj9lJmRyVEjJ+q8M6GDkf909U9XVi2D2s04B6ZEd/s9QA==
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


