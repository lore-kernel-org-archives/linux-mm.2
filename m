Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB64CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0E36B00A8; Wed,  1 Jul 2026 02:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7720D6B00A9; Wed,  1 Jul 2026 02:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688586B00AB; Wed,  1 Jul 2026 02:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2A96B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D9D01A0248
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:20 +0000 (UTC)
X-FDA: 84939185520.14.DC958A9
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7B3CF180002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bkjg0hSE;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886279;
	b=pT851OIXkTRGTbywaoqlHx6s23UvMVL6rEwwDPuwcccMRVZ7ktSwWURXXTUbu6bQdptGP/
	3nWSBgCeCqe6qbxLOgAvlAWh22wxO7JVZPzicGCAZ/TZQ8q4ytNKkMbAom8GX8BsbGLHFJ
	CZiARPxkeFhDPQaeyDdwI6mEMtF7Un4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=aSZgRRU6NDyVvcS7hpU825AGWAMXaXTnVScuH2BIeuFLt3FfZ9MMdxLgwtV1lTwrxW5esl
	waiOqWXnJkoVhtf+MxKtwDozlGdLdwdePlPCsZj1lGkxCDJhiU6WQJKA30kquUmXv20HEQ
	bLgnie00oC7R8d4VwQkpGlrIYl7gnqs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bkjg0hSE;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JMExFnjyQtVXN7x+iPdJHV2C/UohwacNGTdpQ/luPkA=;
	b=bkjg0hSEnefr0xknPnvIvmFhT4Naamc6EL9eaEQkfQ9ep6vorBu7I12mkJ2rqzZA8em9rO
	D9AP612nucjzD8A32qdJMSVsCqqou+p7M2w4aMYrpuHS0VP9xUotWqx94z0L50QQARRtTP
	FNM09wdxp2NGTOtZvewELxz4HZy1dS8=
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
Subject: [PATCH v5 1/9] mm/page_owner: extract skip_buddy_pages() helper to unify buddy page skipping
Date: Wed,  1 Jul 2026 14:10:44 +0800
Message-ID: <20260701061101.344679-2-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B3CF180002
X-Stat-Signature: 3j5phrofugp149u9k1skeyywm3hxqp9b
X-HE-Tag: 1782886278-345447
X-HE-Meta: U2FsdGVkX18wMz90wTlH3cpowHv8uMyci1Vt0tIsz6iWJuIiMpcoFuZDXVAlGvE+eL9VE/+tdBOTNzU1iYE/hpwhIZyofFJod+00i6t/F3mAMOGjkr4AV9OEUjr2za+q0/TkptZKylrqAOASu4VBz2Nnu3GIrS2dvT95Q/SzqYDdVU1qUKJmdZSTU2B42JF6hj2BZFuf/quKjxcIs2T7XS4XflVv9EYcifnkvOAYtkNoXTaTykbRIpSsU9dLfhmxu4eoQYiI3Rq3zCPtbTXlURyVcMvyKOTloCMLb5UsP378smAUfyjYZbEVEK3B0/U3gbyVAb+7KdModVb4fPDvq3glgv9Rg4Z7/9W8h0cvfqk65ROcSw+ZccUg/UhniXXcVedXAy5mVJluFMJlILDkrXrwDZzyO9rqsM5IZkbv46d6UEBiwVOHix0r5XPpgBDZ2u+NchXpWmQyCK4AJJnQ3i/Ei1+nMJLU94z+CHViTHheyYXNxA/jjE0DenMeyfBUday3/jz5j+UMP/9XefhtobqPlmRL2jSiDrpxlyZRkeNVKHhnCYkeRH2G9C5O9E+yI1AnQ/5qhbdBJewYmjCyP6UaSPl5OjBuC0svejzYpdm8YohE1RBeKuJOIoTri35WaYzZcTFvyAh8dmnpEZfckiP9a0urlNdYvhCNm1DX/dokCalD4qwyDvC8rUqsFVY6M/wkLEpl081+XqtIJAYFPRLW+YyVgsFV6H0TsxQ+hJOmql+cDpucWt5XBrmhUpq8ty/gZwAoMRlBbVRylw7d4eG5hXDbXaPSbOmV8ERyP7Cn5SJ+z8NrJ4K4AqkNDn9lF2w5XvS6hN7fSoEJB2YySIsW7Y1ygNah2Ulr9MTDOsKB9Vu2hKC9Y/10zL4XHA9Kh8g4Vmn5Rp3od9so95XPCPyTriK/1UtrElf9X7W/kiCg6sw+qYx2lSjiv4m9MPjugj3FAeUeAR8bbokPsk3
 Qrzb0jWg
 hk8ebAvgJCIAgubE27n+TFGi54MXBaSY0SM2Ja5dt2kZnzlmW8y9g9m79JQh0wp2GhXgX5TvUjJacGmI8hK03AqsiHoSLJfo5q4eRDkG67SBunQSGopdPa9356DuPEnQdV5opNACLguXiWq6osUmNq1dlGHp36UAhStFohE22iB16O+/ItGov0zZ9KZjqEakTzkf6zCI3NJgxZAV6+3C0QmIhNnjkrSgqMAW/GiVn02OxXUvA6rbG6rNOEdh1jrvhpR7UTTtQj1uFg2sf0zV+2SDHV8zWDZmCMhq8B4GxOBM15O8=
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


