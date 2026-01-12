Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9847FC9EC7C
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A886B0088; Mon, 12 Jan 2026 07:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7D66B0089; Mon, 12 Jan 2026 07:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA00C6B008A; Mon, 12 Jan 2026 07:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8AED6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:16:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 609A68CC2E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:16:38 +0000 (UTC)
X-FDA: 84323210076.27.7DD1E21
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E4BC100006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:16:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imbyE6ku;
	spf=pass (imf05.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768220197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OVWY/dnICKjphyKsb50bvyo0Pt8KlZMZFnV041JZSGk=;
	b=qM0PBALWxOcfEVxXDLieuVlfLcz3Wth9vOY+zu4qvO9BlUykTq32MjcO6Aq+X3+5WGvRbO
	9tc0PLwLzZO5c8uewotlUjtBzUM+yjonPwj3VuLodf9tR8WSl1RNY8ep8PFp5MkqhHFQ3d
	dmQn4w2lhM8GZyVggHeWjfa24s9HRY8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imbyE6ku;
	spf=pass (imf05.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768220197; a=rsa-sha256;
	cv=none;
	b=HzFybkwtb9tXs/1JJ1ayIIQrkDgIgv8V4OwpTcl25j9RTcXm9RstwAtj8to5DtvkMu7FMp
	IAxs2F/zAkbPh9E7FIbc+bYFvwTDzaSqWh/yVlW3N2f4cd5ydjqh67HorA9m8zjJsNVzyV
	QvJTsrTBT/A5osRLvr1ertoqFfER0ek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768220194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OVWY/dnICKjphyKsb50bvyo0Pt8KlZMZFnV041JZSGk=;
	b=imbyE6ku6JxtT9B0A+vaToGO5vlqkt7Ohwuao9YbvaEPl/EPO9MnlXX/RjHp3KvezjLKO5
	+s28Gix19dhPj49Vq35vDTkuERrNZpUSgn606YK5ppAMVqjPqqjAF2LZEzLuuqjtAfVPj2
	kmM4kArMsouyjodp7X0v2YVxSDCOUUE=
From: Yajun Deng <yajun.deng@linux.dev>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yajun Deng <yajun.deng@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates in move_to_free_list()
Date: Mon, 12 Jan 2026 20:16:14 +0800
Message-Id: <20260112121614.1840607-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c5yi9zwn5jspxtdisbx8wdz6ah9k9zpz
X-Rspamd-Queue-Id: 8E4BC100006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768220196-945410
X-HE-Meta: U2FsdGVkX1/Q6/0qT0suiDgouWDJIpKEV3yBUr13l7SNRiZhcANU7/oEMZ5vnwGj0lLq31BLprhDmcLXMDKBrHb9iW5xBr8NArrLK06ssTEkdzBzC+9Z/T5HtpQrLjD40Bu8/b5v0hkmPrd6oQ+I4GsEv6FCYyN3ARd3y8lmpyOcPQAeGaqVCcLajEfexY7AmA6HOPXRDvloNVNzYyegSrBxworS7KRsC3OHIgV7P6SVNPTx1wIR351D42tJNio9Htc5DBHyZbZTi/mJW3SkoM2VE343BOQQfwzvcONhxNBoi4EBhcPP0wLxHLQVCb66wRRa2IbEPnkqrSOImEheA4rMNhULJcQXmeREg/gxPY0RAPGdwr5/+nD/dXCPifhdQi2/FnkKpaq3FJ/C/7LAAE3hwnpy3yz5UKXOwTXtx2LN3XVBMAXABkiA0rOWKNInCKsvsASEKUEglmvHRFYTsjwJRKslt75fd1uIMtc9rGMHlUgvdBXnv8xakmdXhsjODiTbbxjBOGx/1EBQabrwa/6FNpBsCnrHZ5+xu2xOLrvlM/MaQ/hQ/rsIcyBBknJgt5G99vat8aZyP18E4gf8C/hyr1el6I4DrisMYhVBw2yWAQQDvP7Zzn4OI12tk/RHd7mJ+/R1hvj7PdH0DviJpzOkoo+9N+1caWCmS4dDcz9MhwB7JHhCg5nmoOi7CP7g64JLPUAJag+LNlf26R642fvhHMrZ8CUXGxI3KvaERnXtjsKwrssMungmTo5iWq+aVMMMMF/AGJvNRE6ll9qwCcA5gzoDfcpPE4zKRcQ7wHGTI8H1c6is4NRk/S0FxnVUZHqAxdsGCznCTKMmCrxrS+I6rvL8uPzWU4uhoMky+Ups9zW55kggg6cgPNUP05qOTOgh079O5VF0C9RY8eqKV45lt9En7N36yAXwhEse+XvgY1XIGey2uQBpRCMLM32rxVLhzweApNVP2fLFJNA
 OVJB0K6c
 U5tKr2sAml24AY4cYhwdHwURderLyXQjuQYZRoe0UW/H4xCeuqH6dupvNIaEqUAiIu2ahN+visyDJgpriPeQpNK0jIm8vgCxkCq0Pa3rvttjHI850EqUvpCWuIlqZvB5FF17MypPZmV2G1UD8Q170UsWgXECA8jI476lVS2k+aFoY+JP/9ivQz4tGMk+9YsbhuJ65kckl7vTPYnffNrI6Ortin7/xYGikgp5GbtRJEZKSR89gD7SY0MInpQ2oPB+JBpDuFsFHp3ct2indQFXIH2U8WnbOSBfxJ6HQeWG788Li2O0yGd+DsoqCBR1vFlzGsrqAnJ+gThQJHOEUO3wCTZyjscLnuY9eHlZ3FSgAhHIYG0o2LuLZgsMMR5IoHbqtSwxp3Tfzwj+94qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In move_to_free_list(), when a page block changes its migration type,
we need to update free page counts for both the old and new types.
Originally, this was done by two calls to account_freepages(), which
updates NR_FREE_PAGES and also type-specific counters. However, this
causes NR_FREE_PAGES to be updated twice, while the net change is zero
in most cases.

This patch adds a condition that updates the NR_FREE_PAGES only if one of
the two types is the isolate type. This avoids NR_FREE_PAGES being
updates twice.

The optimization avoid duplicate NR_FREE_PAGES updates in
move_to_free_list().

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
  v2: remove account_freepages_both().
  v1: https://lore.kernel.org/all/20260109105121.328780-1-yajun.deng@linux.dev/
---
 mm/page_alloc.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ebfa07632995..d56e94eb4914 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -812,6 +812,16 @@ compaction_capture(struct capture_control *capc, struct page *page,
 }
 #endif /* CONFIG_COMPACTION */
 
+static inline void account_specific_freepages(struct zone *zone, int nr_pages,
+					      int migratetype)
+{
+	if (is_migrate_cma(migratetype))
+		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
+	else if (migratetype == MIGRATE_HIGHATOMIC)
+		WRITE_ONCE(zone->nr_free_highatomic,
+			   zone->nr_free_highatomic + nr_pages);
+}
+
 static inline void account_freepages(struct zone *zone, int nr_pages,
 				     int migratetype)
 {
@@ -822,11 +832,7 @@ static inline void account_freepages(struct zone *zone, int nr_pages,
 
 	__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
 
-	if (is_migrate_cma(migratetype))
-		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, nr_pages);
-	else if (migratetype == MIGRATE_HIGHATOMIC)
-		WRITE_ONCE(zone->nr_free_highatomic,
-			   zone->nr_free_highatomic + nr_pages);
+	account_specific_freepages(zone, nr_pages, migratetype);
 }
 
 /* Used for pages not on another list */
@@ -861,6 +867,8 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 {
 	struct free_area *area = &zone->free_area[order];
 	int nr_pages = 1 << order;
+	bool old_isolated = is_migrate_isolate(old_mt);
+	bool new_isolated = is_migrate_isolate(new_mt);
 
 	/* Free page moving can fail, so it happens before the type update */
 	VM_WARN_ONCE(get_pageblock_migratetype(page) != old_mt,
@@ -869,14 +877,18 @@ static inline void move_to_free_list(struct page *page, struct zone *zone,
 
 	list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
 
-	account_freepages(zone, -nr_pages, old_mt);
-	account_freepages(zone, nr_pages, new_mt);
-
-	if (order >= pageblock_order &&
-	    is_migrate_isolate(old_mt) != is_migrate_isolate(new_mt)) {
-		if (!is_migrate_isolate(old_mt))
-			nr_pages = -nr_pages;
-		__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_pages);
+	if (!old_isolated)
+		account_specific_freepages(zone, -nr_pages, old_mt);
+	if (!new_isolated)
+		account_specific_freepages(zone, nr_pages, new_mt);
+
+	/* Only update NR_FREE_PAGES if one of them is isolate type */
+	if (old_isolated != new_isolated) {
+		nr_pages = old_isolated ? nr_pages : -nr_pages;
+		__mod_zone_page_state(zone, NR_FREE_PAGES, nr_pages);
+		if (order >= pageblock_order)
+			__mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS,
+					      nr_pages);
 	}
 }
 
-- 
2.34.1


