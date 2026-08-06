Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB24C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4AB6B009F; Thu,  6 Aug 2026 06:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2657D6B00A1; Thu,  6 Aug 2026 06:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3256B00A3; Thu,  6 Aug 2026 06:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E853D6B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:30:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CC73A0755
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:39 +0000 (UTC)
X-FDA: 85070475798.18.08BD7BB
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3CC1C0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:30:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rWRV7ivX;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786012237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pvvgpw5CGDbpUKH+B75dcJEqDhAR0/u/1a7RYtxk/M=;
	b=wdZe4eZMVFHYEudCzqMQnj95hHbiHmHXsYq8iTSekRlX8feHjpxOoCtUuwDQ91qIqAGIXR
	LK7DaWB2q7Y4V6wUSJIrgcPPSsgDYWRUXJ1ltPD7bktc4IMUF67AiX7f+NHQLxZ0OXsUBq
	6sIVHMkn6Fbpd3sZTLDwsJS30ZA62mI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786012237;
	b=2khGIyJY2Cc4Q7sQDv9E0mmLI1jM9e/Pv6WMTlS7T3E6RSlZ6JyObVxUhatKSSlmh3/I4h
	Yc5tTkqoWxIOlNUqG7BwWTSO1AwY5u9koL+NJK6i857J82zAfdSDSalFoDk3QQXWyr0Alx
	s6jqJ0clWKhpILZmso+7o+6EhFhIaJw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rWRV7ivX;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786012236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1pvvgpw5CGDbpUKH+B75dcJEqDhAR0/u/1a7RYtxk/M=;
	b=rWRV7ivXsUmzccs1EV67ur50u1+bB7KZrHUgsMKDob1dmIH0dpOIipTHdiLaWRvqC7sKKx
	VUIBRsKxTifAIcIIs8ve1QpEFaiVO9riUzMBkfGLzh0shhT3r7oJ8eovo1uMxmkI6fDfbt
	A8NDmisatt85NenCe+8u+UEqFhPLfTU=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 2/6] mm/mglru: refactor Bloom filter helpers for two filter levels
Date: Thu,  6 Aug 2026 18:29:56 +0800
Message-ID: <20260806103003.3924438-3-baoquan.he@linux.dev>
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3CC1C0013
X-Stat-Signature: ti7yoj7rfdg7iywixc9jhc71gmzrj18r
X-Rspam-User: 
X-HE-Tag: 1786012237-416812
X-HE-Meta: U2FsdGVkX1+oHitKY8ZDppIdhqrdTdXO1AjCVqVB6o2PEZMwyFNcpbbQn6v21W6W4yahijy7MhKKIXlY+ugv1zc5q+ESL90YwqYTHC17AM6F7Lj92r40NRRbBdlG3lmvkLtsZF4EX84NI0mQYa4JbEa47e16ppJqsfoWmUkYQAPwoH8AuBhQ9eHNPCSB57m7qkcjimnHKpVoYo0LYpLoGTy2JYjwsHFSzShyP9ihy66KNlqFROh9bjYNFdRQx+utvAph7U+A3bCrL4vGrwkDL7BM0oO6pf6QfzVQtLRLP4Ti9XhfIY1l2YD70hHWQv4kSDWZUx6vUlsc59+LpsykT6V+1j2EZYtlqmF6AyYEwIfMviiotB93ZYSAKM2q/gJUZvAlLxJimhshLLYw1VlLoYl+3liSgiN95cFVZceEVtEPefJ6j/qmWfRGkYB/Rq3Ybyyn06Bcg0kvVousXpjuIYcgm3NGbPAtW0QrEj7Xq7aq0XBsBXfKc4zuWEOVW2OpCuFm0/GyNZddltkXtGHtdLJABJdvxEY8gj1I+xUUvYKHSwBIS4pifT6JnW966aVnEY8pnke0aLxzwGDb0HZgc+k2KnnxXVfxgMPqjfxIyy2phEHJmYfcjNLHMF+/1oyezvbQozhXb9C1CnExRWp6rWTMoVaD2W1T1it1wx6D2T6xD8ZJ2HPx+hz80vYIRRapW6q0PxWLCnFRmSU/zd7axAyE0kLHCNWixDTbFfHr2CA9tzq2xLgv6wk3doRns8Ruosm36DSOp1z9Bvop1lKcJcUB1Q1CLLKxwQ9D6RfE9EyzizDbuLZKVAGOKzWZh3NvDLC6gVWFIV5rHG1ULkNqloDd/4xH4IQjn0qc1awhHt9vZh03NzAmbfiSQyCCtJ4numQ5iIkqZ4J6D0FJh7j0XMpQWQyifEHicnZg7vRMMeJqZZY6hN0AT9BA1DJlyX94KjQTYe8ZnNC0IKaq5Ks
 BFvKLWjB
 /VN8nCS9iKDITOK5OyBufE5xq/6CJnOLvtwwQ4tEey/ZkORhW/OKkrxHOwXcHuSl3uWDKQ8W+QiCqQdQHcRVMFVvOqR6ozISYjM0dBqRCx+TAwxEziil3G8RURtFvIxUWzWpDg3tAHv/TXJHg+/DhDWL0oO2tEbjyNH08BCqnxqwz6rClKOygfx6UZZxFtscE5nEKD1oQginoFl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split test/update/reset_bloom_filter() into __ prefixed helpers that
operate on a generic filters array, and thin wrappers that pass the
PMD-level mm_state->filters. This lets a second, coarser (PUD-level)
filter pair reuse the exact same hash, double-buffering and reset
machinery without duplicating code. Purely mechanical; no behavior
change.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/vmscan.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 17d2b793cbfc..a397c62b2e5d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2841,14 +2841,13 @@ static void get_item_key(void *item, int *key)
 	key[1] = hash >> BLOOM_FILTER_SHIFT;
 }
 
-static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-			      void *item)
+static bool __test_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return true;
 
@@ -2857,14 +2856,13 @@ static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long s
 	return test_bit(key[0], filter) && test_bit(key[1], filter);
 }
 
-static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
-				void *item)
+static void __update_bloom_filter(unsigned long **filters, unsigned long seq, void *item)
 {
 	int key[2];
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = READ_ONCE(mm_state->filters[gen]);
+	filter = READ_ONCE(filters[gen]);
 	if (!filter)
 		return;
 
@@ -2876,12 +2874,12 @@ static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 		set_bit(key[1], filter);
 }
 
-static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+static void __reset_bloom_filter(unsigned long **filters, unsigned long seq)
 {
 	unsigned long *filter;
 	int gen = filter_gen_from_seq(seq);
 
-	filter = mm_state->filters[gen];
+	filter = filters[gen];
 	if (filter) {
 		bitmap_clear(filter, 0, BIT(BLOOM_FILTER_SHIFT));
 		return;
@@ -2889,7 +2887,24 @@ static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long
 
 	filter = bitmap_zalloc(BIT(BLOOM_FILTER_SHIFT),
 			       __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	WRITE_ONCE(mm_state->filters[gen], filter);
+	WRITE_ONCE(filters[gen], filter);
+}
+
+static bool test_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+			      void *item)
+{
+	return __test_bloom_filter(mm_state->filters, seq, item);
+}
+
+static void update_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq,
+				void *item)
+{
+	__update_bloom_filter(mm_state->filters, seq, item);
+}
+
+static void reset_bloom_filter(struct lru_gen_mm_state *mm_state, unsigned long seq)
+{
+	__reset_bloom_filter(mm_state->filters, seq);
 }
 
 /******************************************************************************
-- 
2.54.0


