Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8199BCDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D9D6B0088; Tue, 23 Jun 2026 02:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544E16B008A; Tue, 23 Jun 2026 02:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4845D6B008C; Tue, 23 Jun 2026 02:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBE26B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:52:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5603A03A1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:51 +0000 (UTC)
X-FDA: 84910259742.11.380AA71
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf02.hostedemail.com (Postfix) with ESMTP id E493180008
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eek4DDfg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197570;
	b=DucutELJGjdGUK1xPR9mt0Nj0RHDDf1m/F0FglCz0zM1oCD5nfJ2eIFe0FST/p7H56eIdd
	/RtgXSJ7pL2Fb3fsnLnvI/ZEEx7oqY/TI+ef/fNZcNh47TwVJVQ2mkgC9bxCaTAk61EE0t
	quU1gahp2VhxNQAPIgLdFiIdse7WsXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvIJsA3YqPuqH4YFKYfsJHGBnY+wCnYdbztz69l5314=;
	b=DX7oWb+1wp/YnTSTpooKHPji1eNv8lSzMbiQy0NTFdVxW7xkTUmV+QFUy+KbdHRf8c+clx
	eBMX2ueLnoZU7DAgk090/XfSeP/g2nueZxUAOjWOeJXN0eSgU256hNf7obPKX2zvffW6WT
	a/R3XaSCwnLQLuNQ8NvhZaTlss9ozZo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Eek4DDfg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvIJsA3YqPuqH4YFKYfsJHGBnY+wCnYdbztz69l5314=;
	b=Eek4DDfgEZSCdU9HKwxGDYhui2nzE/cv3JiXat1CNGLY2dRdLYYhUNyW5uTJ2Sy3qQ2kSH
	WezQAHINUaEa48AdA2V0u6Zt5VgVBxyoN5nMs05fZNSFE4tM2Z6ueR7MlV0jVqtWn3v3c3
	1fmhRdzeYn4Hbmrg93Dg0i10MmyllKQ=
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
Subject: [PATCH 1/6] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Tue, 23 Jun 2026 14:52:26 +0800
Message-ID: <20260623065234.31866-2-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E493180008
X-Stat-Signature: cq6j8at5i147ys8xqieicumkuyiwbd1p
X-HE-Tag: 1782197569-731283
X-HE-Meta: U2FsdGVkX1/8L+2+uBK+Co3gzxX98ET9LEKbB06K1Qt0LZXBS7Ac9z7Okvk2zN3e9fQj213gUguAvoBc/upIgcAo0yIDCVhi/RnWU0pZJIeFb0iZv/wRmjtiJw4S383AixgOSiHCyhgr/BU1qk0iBrA3yA6MdeJ0WFjRZCN3aWH1DaIo28BSg9+r5WqIqbTT79n37J/WIlz1jS903RdaBT0EgJVTuTAPG4GpKcLiBNjwgC2Oc3PX3xoVglD2igHXftZHCbjiCIr3dGPmBDbh/nJ1SC2Zia8uTQNbtgETg1VFLOnGOyoQm2P6ngZm54XdffYXFIpS5nBE5LZDU0KaaXKQuHWSThZ65gSJ8O7Q7XTmVKbbHgnFKor2hh2nQ1CATlpnZ0Y7dd9QaaxeDKxuTdPa679TnGMTClQYnJhT8McKKIhvOLlYPjcu80Y14zj+VYgMiLZp1fMoY3SmC/+C20wL9PrAij+8yDz19rYJIUq4cDltuoifd/e5HKrBO7uX+XbSp6aETGP6a8HGYiwVyX+CKaMhEb/w+S8piwbtijTez/lR7d0y94SatQ/PkVv18XsdETaoSlIBhwg6eorD6eAAjHWLIARQBB5swPMaOPEe/BSitILeK0u6aUaa+goCMjFLFpOT8p0wyu8Y8qmOGfWXimfVHgEpwgS1H7apUEpRMMqp943u2RZQN++dG0vK8WIAsslvPN3LenGnq8KfFUxNqr4gJtw6LzsBtSqfIa2INWEB/SGJcSt6rGZdUEAPmCW2e+aLAPwKObpnlY/KNcs6T+1tZZV3sx5M8gSx/ey4/gvf6olyj+ewU/jAO1/DIY/UnO9VoWsgzAixjRtIS34UrlGOyQ4gwmO0Iiv8xUy62oVgv0k+08WSXHnu7peGl5+pYGlQokGb5+KaWrX+/2JjnU/SZU1SMtwhnbsk/4CEEfotU/TlT4g5+ZlIn9uZEhOmnjVC1C38BhtCaxa
 e31kGHZP
 kgXLhLBdqcZkmm1TAFF8T3qmn0ZmMuEAZmCbNp7zipeeQin/Aske/Qsuc8d4NF8DVjqN+6aqY2gV0fk/QiIw8uAHtiALDbd43VRyi/DTKHDQqWEEaiWh4WYlZdyuBmzjIlcHfDdOYaxDTRJdcIs0PalqYwraKJQy7cb+G9f00MZN0X86AGTJlPT5RbWkBjOJ3gcE5O4FLRYWIUl1+cX8tkLHuL92ovFcVQ41Ar79HoTFM42YfkZVstefg1A==
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


