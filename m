Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B4CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C386B00A2; Mon, 29 Jun 2026 21:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC4F6B00A3; Mon, 29 Jun 2026 21:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812DB6B00A6; Mon, 29 Jun 2026 21:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9396B00A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:53:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A761B1402D8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:47 +0000 (UTC)
X-FDA: 84934907694.04.FFADC19
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0B70F40002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:53:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tAUc0BtY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784426;
	b=JEc9zw1S1UInnvac6JOgW+fOe80K341/bcoV2IfSlaQxeEBgMg0jxV8GRiSKU/OzB4e/Ow
	w/xuD/0tah7SsNfJxnneaGsyw2HK4Gnny16VF0G/fFFVP1pKM8d4MkkVL9wGxLYFHFElVY
	XdDV5T2lMxaNIV6gmhhcEwg++gJaHqU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=wWczCs4FqgxrZGq4ls2dMJ5FUIVTntIaSigez1rEnkFdxIdVWvdaGqvN2TGeQQKwU0X0wp
	3kCxORLgGYolrPc5DcEXuN0fSHWmn7i017bbaVfTjEJUcUv9meA5yeVJmWAY5GSxI7/IA8
	unIDMIj0lfsIrm4XADd3BVeJN8SZKog=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tAUc0BtY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=tAUc0BtYl9zRdOXdzXksmTk6bQUKvnNLgL+CPb0QqzgH9c1fZDG6gSwSWZPsUzH5uP1/+E
	thP9KHUGeLkOeub1MH0+loDf9630Bwm0YmTMEIeTxqbeqSYxyI882xQ5cZGz/2qCRBScIu
	gj6l0TRfYoJ2m+KioE7DWSHrWsWLO8Y=
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
Subject: [PATCH v3 1/7] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Tue, 30 Jun 2026 09:53:18 +0800
Message-ID: <20260630015331.147174-2-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B70F40002
X-Rspam-User: 
X-Stat-Signature: uso4yundk8pw3fb4yx6ud3oc4f7u8fby
X-HE-Tag: 1782784425-928434
X-HE-Meta: U2FsdGVkX192dR3iVBK4rLgGakBCAWvAgu6/zJrkrN6GhXGACQelCpzL11ryzJ9C7w1lPU5ouRX8aK8BORvsh/1Wz4GJJCtdBbBNXo3GW0Jsg/SbpnFIpc6+jXdBgs4sdwTnPTqA8cFtp/IQl2suWmgJ/e6o9RGN6R6bTMRyxqVrzK1KCZlXcSQ1hurGC4uMgqAjQEM7GHo+cL4zzed1pPB2CjyOJQTjGBsu7vhUhRj4gt1sa7umL/JVYa9/riBDqJJigBOnKZeV4VrQiycryJ56gFhuwjukvc16US4DEaM0z50wXMOV4gCMO7SDKdJ/vWcIaeZJkVEXpsD5ZfmkrzKr+OaEy6v2K8MI82c2y5V3WUGWEwh2lw9zheH4LfS3Lx7muRWfXaO9FQ/I20orPfTx9zETg07WXgNdVXvTNuK2sZC20QARRWo/O0W0pb58sV9AaxGXoz7hqCIqtASQD6sXiSJXH29Sp22FGnEWe6NPK0CyxFFpS/+dN+uVdcLr1Lmx7a4G0Vpd1HBKMsnuLGpMWujvvYljsP6QzkOY76QUHx9f4WhgTYFh/driA/y0YmDltouvGzJpuNurQ/mp47GkhFjx7etb1mu4KC21+Idv6AuQxkdgfxxFGccX+06Nff+bliIH66YEWKv1m+uV66xNZunMEO8R9UJV7oGSpXnu9jQeJKZeyZqM1L/iacFJkVMyTe+J3+ey1PsZ5oPpNmeEYDX2Qit9/2Ymezn2FkAeZzOZCN/IHvfRXByrZz8JTI0uR5oQwTjzgRIFDjIeaDOCsawmROL4HE5PqtQC10dEy3W3g93VyY22aQ01G0IOgtAycybkM7K+8hOFI19IHttQeUmW1bP/waK2I1exIncYGN+A+6anKY5nIzJdEBOLwNrBzMgzCeo49SrJerZiSCSRVzBkcb1mSH49AB2t8RZC8+fBgvumNogH44OX/1tlxPgLtxGvfut+YK0g7Um
 ia35z930
 NfIeUSiU1X/X81YjHVtQfUTZWImPmoFFjjg6uVuXUDAOwTByBOUxHT7F2J1cq3fu/Zoo9HUgTnmxU3SGHR9lBUxq47leyQH683yg0tkAU5TAzOaRkiu35TuS89c+Y9xyEVUxtZOazUwRfSkYc7yDgFapSK3K3CsGtxxqyaQUFmKNyyEUZDhwGPEqTVIIbVkDxdFZSgLFYZGyxXIEdi4J6CJ9PgiiBsfhgalBR+FUAA2ZrUsPRaUUY3cKuty4hql+oj7BU70Jfl66axFqtY96TRjCS7Fgz8ll8YWjzrrtaVPhsWII=
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


