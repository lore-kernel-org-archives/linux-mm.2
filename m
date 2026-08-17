Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 140DDC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 23:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF436B011E; Mon, 17 Aug 2026 19:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987366B011F; Mon, 17 Aug 2026 19:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D2E6B0120; Mon, 17 Aug 2026 19:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9B86B011E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:47:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC1BC40960
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:47:13 +0000 (UTC)
X-FDA: 85112399946.17.FA8A87A
Received: from mta1.migadu.com (out-65.mta1.migadu.com [95.215.58.65])
	by imf24.hostedemail.com (Postfix) with ESMTP id A71D118000C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:47:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uN6EGKx8;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787010432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bDE+WNOURqVHT8JCAZx9gvMFrr5EwBebHiPffzrjPKM=;
	b=lMd613bMJ5rmIOqVYd9c659BG/XCgP/XI8mnziLW7MdqFUhgY+UI+nrmBMZuLApANHAX9x
	n4RvORKgDIDlG1GBpylLFsWXJZyN+ECRdDtTKAGrzntVl9oIAbIeLbMvPuw6qnBYGAPgaR
	Tmo5cGU5q4eNKTJPr0CstbI6eVZxH6g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787010432;
	b=sluHW5s3icahjWpI2UzdNAXRct5SEHULukFdAfQXxmetnsiXzZRAFIpHUoBNUK5hAeMEWe
	fVo5W48ARJ3PmcF4YfHtFY/H4oxpwRl3c8FnuxIhdTt+dt3nqIPCZCCPoUjz8g4aWJwQpi
	5AgEo2wrxXNJVlVL1VRV7JsbAYzRicw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uN6EGKx8;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.65 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q/qbPRDk98eO9e8BArq/GawFd8W6hSVeAMeh/+FA22E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787010428; v=1; x=1787615228;
 b=uN6EGKx8cbQQQwWuRR6MK2wx3Iw28itStxodHfgm5cjv4qZBEAqge0epF/0OAnyX6Hkp0U8m
 E4KjH1vLJtyY7Bk1+Ak+iatB83pDNPt3oC0yvrsNIHBVKEr77pYSHDbnn/svIWbJP/G401IWuM7
 4CKD3kS8ifI0/jrTYQtXDO9I=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:6::)
	by smtp.migadu.com with ESMTPS id b0ce8be08b6723bf;
	Mon, 17 Aug 2026 23:47:08 +0000
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joy Chaoyue Xiong <joyxiong@yahoo.com>
Subject: [PATCH] memcg: trim the per-cpu charge stock instead of draining it
Date: Mon, 17 Aug 2026 16:46:51 -0700
Message-ID: <20260817234651.666540-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 55cew7ay53rsz349gsrmmx83ediqfcrk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A71D118000C
X-HE-Tag: 1787010431-504404
X-HE-Meta: U2FsdGVkX19AQ00euGXnEwguB1PrMWlffo9YpSZbmhX9zS2Ujmvlg7FO+sonnVVYVmapEmt86q3qDNVjnmCdaGJJ4KrGJUMz+0jbQmeHq9n2dEFpc8THJ9WsvT0McpeQRAbMDTBqya1KPGZhVCrrMCn7Fbn2q0SLXOTrU00KEROZ3kBQS/ERNw14UVqZr+MWTqpf3TNh6A2rPEwGyIJ/xpQKd8oY2wHhR5q6No4susdL34rGT2BNfIp9P6eXSDwKZZHtDXD6FHj7TDSY0iM7BH/Lf2GlaQIWNgcse9mdj5zME1mdnutkMnfu2nADTpJPVvemO+aLzvb98nZ5TvPd2+QpmW+ELnrEWtM96naHSjN9BeJ8Tv60euleut1zTUm2vy2flkrnlKi7OXLIQxZ1IUxPGhSjcQmh2XIcS4ulHT49qzkLus5tsQcsGAtQAbahbOjSHjKapg7lTNhhc3sxnF+JysmyLiSN9TUvjJEYYQ7v5Hi5QJ3hnuFmvkOU0MeBNLgjR90akf1G/WsyJVV7x8JD6pxw/NDJeHtg9WxCuKnubxzKdSv5tNCgdFkJZ5c28AjzXUr4IE35C87G2jOzHoi/3fDU6MJlansICzYO0NRLM52IwxELSxVwkXG4sSNEQ9VBoPP98jiocImpSwfUlK+hZmy9P9qvDdZiGFdfRQJRCJ+/CZK/4avnusT3eWtFJ1ShzxXo0kwNTb6PZZHzvkyZgDNQrmxKUEtRyoBQdeR03URNo/B8yXgyd8VqTzQQ5MTO+XTwTFL2N03klbh+lLbKMjsTxQ6f0j+YXRLNdPeoT0rZAZnTFZWqBQ0J7L+qQw2aAqmP9edq2T4Tl6Sa+tpkYEqY5JS19SJoWIz1aCNO3EPiVaxod+Im0mdE7/6wZTACfUuGfi4Y2MoKZoUIxKDTc5HZQOaP58l0672lOUSCxUG23dw6Mx+oYABg7p2P5pi4OKXmOqlFeVDOl1C
 3cxCF0Wj
 rJi20trLOGzd8Eu47TL1ANp3OMREpfYW0e3yki7v6a9VLIhOo3HH9a9mhYtktMEPEmDdNYZO30A5yMg0csEFm85ky5EHCRzouYBEEn1hpr+TGVyANlPVy/2n3hu3QD63G3EXOh8COAIp6xGZtVV83Cyudvs/TGKEfPaH/ZO0R/ioFsoCjqbzJ/ddXkC8ZCxP+h88+TCWiVZxI1d8hyFXEwlqW6bHNoOhtHTNpOWN79HN1ph/jC0RGBMSszjZj18eWmi0f01bx2j35Jj/GuqzDs5cmd3yHCqOTD98P6U0vjkl5SIaT06ZCEBMAuR+cI5D9J0s+nLFETw/yG+v91l5xm+HxLxMUIDIZrRf5MhjDibQkHl69KR2FIAcz7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joy reported that an application generating a request/response traffic
pattern spends 44.6% to 57.0% of CPU in the memcg charge/uncharge path
for a range of message sizes, against 0.27% to 0.71% outside that range.
Running from the root memcg, where socket memory accounting is skipped,
recovers the performance.

Tracing the charge path showed that the application generates a pattern
where the write syscall charges one page and the read syscall uncharges
two pages on the same CPU. This hits a corner case in the memcg percpu
stock code that thrashes the stock continuously.

In the memcg percpu stock code, MEMCG_CHARGE_BATCH (64) is both the high
watermark and the emptying target, i.e. on a request to charge one page
the kernel charges MEMCG_CHARGE_BATCH pages and caches
(MEMCG_CHARGE_BATCH - 1) of them in the percpu stock. The following
uncharge of 2 pages takes the cached count to (MEMCG_CHARGE_BATCH + 1),
and refill_stock() then empties the cache completely. With such a
pattern the percpu stock becomes completely ineffective.

Instead of a single boundary point for charges, use the technique the
page allocator uses for its own percpu caches, which keeps the watermark
and the emptying target apart: nr_pcp_free() frees between batch and
high - batch pages, leaving at least pcp->batch on the list. Add a high
watermark MEMCG_STOCK_HIGH and, once the cached count goes over it,
return only the pages above MEMCG_STOCK_LOW. The watermarks are
MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a full
batch. Peak cached pages per memcg grows from 64 to 96, the same
high-versus-batch tradeoff the page allocator makes.

Reported-by: Joy Chaoyue Xiong <joyxiong@yahoo.com>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17da1f43b7d3..ff7fbcd27422 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2048,6 +2048,21 @@ void mem_cgroup_print_oom_group(struct mem_cgroup *memcg)
  * nr_pages in a single cacheline. This may change in future.
  */
 #define NR_MEMCG_STOCK 7
+
+/*
+ * Watermarks for a charge stock slot, in the spirit of pcp->high and
+ * pcp->batch: MEMCG_STOCK_HIGH is the high watermark at which a slot is
+ * trimmed, and it is trimmed down to MEMCG_STOCK_LOW rather than emptied.
+ *
+ * Using MEMCG_CHARGE_BATCH as both high watermark and emptying target
+ * thrashes: charging one page stocks 63, an uncharge of 2 takes the count
+ * to 65 and empties the slot, and the next charge misses. The watermarks
+ * are MEMCG_CHARGE_BATCH apart, so a page_counter update still covers a
+ * full batch.
+ */
+#define MEMCG_STOCK_LOW		(MEMCG_CHARGE_BATCH / 2)
+#define MEMCG_STOCK_HIGH	(MEMCG_STOCK_LOW + MEMCG_CHARGE_BATCH)
+
 #define FLUSHING_CACHED_CHARGE	0
 struct memcg_stock_pcp {
 	local_trylock_t lock;
@@ -2223,17 +2238,18 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	struct memcg_stock_pcp *stock;
 	struct mem_cgroup *cached;
-	uint8_t stock_pages;
+	unsigned int stock_pages;
 	bool success = false;
 	int empty_slot = -1;
 	int i;
 
 	/*
-	 * For now limit MEMCG_CHARGE_BATCH to 127 and less. In future if we
-	 * decide to increase it more than 127 then we will need more careful
-	 * handling of nr_pages[] in struct memcg_stock_pcp.
+	 * nr_pages[] is a uint8_t and a slot's count is capped at
+	 * MEMCG_STOCK_HIGH. Raising MEMCG_CHARGE_BATCH beyond 127 would need
+	 * more careful handling of nr_pages[] in struct memcg_stock_pcp.
 	 */
 	BUILD_BUG_ON(MEMCG_CHARGE_BATCH > S8_MAX);
+	BUILD_BUG_ON(MEMCG_STOCK_HIGH > U8_MAX);
 
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
@@ -2254,9 +2270,12 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 			empty_slot = i;
 		if (memcg == READ_ONCE(stock->cached[i])) {
 			stock_pages = READ_ONCE(stock->nr_pages[i]) + nr_pages;
+			if (stock_pages > MEMCG_STOCK_HIGH) {
+				memcg_uncharge(memcg,
+					       stock_pages - MEMCG_STOCK_LOW);
+				stock_pages = MEMCG_STOCK_LOW;
+			}
 			WRITE_ONCE(stock->nr_pages[i], stock_pages);
-			if (stock_pages > MEMCG_CHARGE_BATCH)
-				drain_stock(stock, i);
 			success = true;
 			break;
 		}
-- 
2.53.0-Meta


