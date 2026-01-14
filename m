Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90EAD31A15
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9466B0089; Wed, 14 Jan 2026 02:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A07C6B008C; Wed, 14 Jan 2026 02:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD496B0092; Wed, 14 Jan 2026 02:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8DB6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:41:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB2E98B834
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:22 +0000 (UTC)
X-FDA: 84329774004.30.AFFC764
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC39580007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:41:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdN96whk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768376481; a=rsa-sha256;
	cv=none;
	b=UrbIBXBmdeUiSzxvF/ana7ptjd5Lq3+WJtP6YKlCJgxGamPSUE98zJ3XYUMboESDRdMNvb
	j8194LBXRRKkCvkIISbfxrQBPeImr+eKEcu49ugTlP446zlnh2H1+7ak7GYxGsmJVdgVsw
	qOrxLZKqcv6Ym1LNinsYyGZF44T5nvQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HdN96whk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768376481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m29ZRcbPtm9JpokMLGdHmu+Zzbc/y/DtDAKnbut40qw=;
	b=MJ6s1ZXBSXA3fpiEITe1viOlInrMiiUYovvQzEas+f1mbZRlGb4gqk7ZsiCMVeRkxRgPae
	KKU6gXPlnAlD+FctEl966Oah70fNbH6LYecgU8g4HgdZ7DD+CZJERqGGac/MobCHF1lRFC
	M9X47D5D2GKAtzxI7TlbcgZRMsYBwH0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768376477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m29ZRcbPtm9JpokMLGdHmu+Zzbc/y/DtDAKnbut40qw=;
	b=HdN96whkUmsgrx9dCvaK4FKjnr4b/YWZi+Fh8vqu/jrQVehdy5bbEPBksLoG5nWYZae1nR
	beLx7ZZTiyR/S7lgwaSgA4WQEEZ3Sb7TDvcBGH3jcq9M09gHEXmlApjzWAPXsqXksufhQq
	OOrdludBb226tISEMzE2u8UrtZjufKQ=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org,
	shakeel.butt@linux.dev
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] mm/vmscan: mitigate spurious kswapd_failures reset from direct reclaim
Date: Wed, 14 Jan 2026 15:40:35 +0800
Message-ID: <20260114074049.229935-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260114074049.229935-1-jiayuan.chen@linux.dev>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: jrtp63fsotju34zuumrt6fbyfqozjrmf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC39580007
X-HE-Tag: 1768376480-362239
X-HE-Meta: U2FsdGVkX1/JtK13CZXMG3z7ckDH/vB+RKt47uCI/tYS4Xg2R/CoPPmeF4D3uWhh2WO/mlqYlPkBZ3ewhHXlGyRz+2hzR3boMBzyD7fIVv18ELaHz7taKQRzeQgTD9cQP3hSnjgL+q88/Td6EQuB1T6s0E4PNqPruq30P8s4tVd77qOfD7VyJmFp6alIj2yieX6TVqPIpBp1GmIlJXavrBhOxDGtZNrlcQ4nKOl1GLOY+wmwh46XcrRtTCUyTVfjB5UHncN3vk/zDGr+BUF7ahegevm2wOKdyB4GyRUCS507rdLBR3Z+woi7EFArZzRPle2zJKf3+xRdatcT+9kaazFymjd4OqIxx7+Iifc1cv5JNS1HhqX2bUKavDL4RkQclUWbd9uIWjfbXfki6wtnDYjyVlsTCrx8yigIAmsni9uXl6+Dq6ZAZesaEc60+hOrHmZildkNslh5wjA8wT0i/RxxYnVLKkbP2Esv/s7/3lhgfdfSeLe/33XdHIWLPzhUh4H87kXCyBocaTvBXGPO93z4wpGPOEiOj5oBGMKCKk7v+e/LYyEsybNUR6YjP4isLLIt5ro1lq/99dlFyP6vZJAyiQOh0KfkqrPhxCIGSQiakwTQLrVG8uTumRT5T8VIQNYq5ow6XigfVgF6mHGo2MFPjX0xd2VWb9vrgBchLXniaWhW8acgF+M2dvh6bRu+oUvztsdn1RMIb26WZKlUotHBDZhbROTOXCq4eJmK+Nc+2IDStXLkZwDHX/n0MfC6nrV9vsXqGESOJZc9vZccZktut77mx5Aa7RljgB1NOa6TtByiEwDAyhFGTM+ruOiQG7QFoSeOYo38uT5l6qa9mZJGCX93Jsq5T1bb6X3GfX9BICcYuph0WTveDtroX7mx9xM8NIqUei2D3b7MMwXM7Q6Fhv9HBs06M3W0hvQzfno11Xy7q40t30x7bWzDUz/Ex29bEXpzBAd963TXv2J
 9o2rX2b4
 rt4qUkSf3/i7ZhzW5f2vZvOzPH/Jk3i17yjupAoTy0hl2IWnfp9fpR4LyrLls2P+rwj0wQg9n4OecpyvFt19C9Sz+711FsUVnJfvPJH7fGPZKxprvDSRFOBjUQz43LQyu1OP3LK7jgoRf/eMI7JMIN/XMWIvbPVe3O0/cGsnGNaTY4g7NTsgCdWl+UuscDZrHvX+o/YwdriaRVrOEgnFIf5aSyoKikXFw4ScO8NffQrYSJ/+xikuMaAtSq1k/nH+UDjrohoJFBIyAgy7Wd2dKaJ96deBlPb5Zs8tTP9Ah9GHdkFvIn4xnxVmP5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

When kswapd fails to reclaim memory, kswapd_failures is incremented.
Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
futile reclaim attempts. However, any successful direct reclaim
unconditionally resets kswapd_failures to 0, which can cause problems.

We observed an issue in production on a multi-NUMA system where a
process allocated large amounts of anonymous pages on a single NUMA
node, causing its watermark to drop below high and evicting most file
pages:

$ numastat -m
Per-node system memory usage (in MBs):
                          Node 0          Node 1           Total
                 --------------- --------------- ---------------
MemTotal               128222.19       127983.91       256206.11
MemFree                  1414.48         1432.80         2847.29
MemUsed                126807.71       126551.11       252358.82
SwapCached                  0.00            0.00            0.00
Active                  29017.91        25554.57        54572.48
Inactive                92749.06        95377.00       188126.06
Active(anon)            28998.96        23356.47        52355.43
Inactive(anon)          92685.27        87466.11       180151.39
Active(file)               18.95         2198.10         2217.05
Inactive(file)             63.79         7910.89         7974.68

With swap disabled, only file pages can be reclaimed. When kswapd is
woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
raise free memory above the high watermark since reclaimable file pages
are insufficient. Normally, kswapd would eventually stop after
kswapd_failures reaches MAX_RECLAIM_RETRIES.

However, containers on this machine have memory.high set in their
cgroup. Business processes continuously trigger the high limit, causing
frequent direct reclaim that keeps resetting kswapd_failures to 0. This
prevents kswapd from ever stopping.

The key insight is that direct reclaim triggered by cgroup memory.high
performs aggressive scanning to throttle the allocating process. With
sufficiently aggressive scanning, even hot pages will eventually be
reclaimed, making direct reclaim "successful" at freeing some memory.
However, this success does not mean the node has reached a balanced
state - the freed memory may still be insufficient to bring free pages
above the high watermark. Unconditionally resetting kswapd_failures in
this case keeps kswapd alive indefinitely.

The result is that kswapd runs endlessly. Unlike direct reclaim which
only reclaims from the allocating cgroup, kswapd scans the entire node's
memory. This causes hot file pages from all workloads on the node to be
evicted, not just those from the cgroup triggering memory.high. These
pages constantly refault, generating sustained heavy IO READ pressure
across the entire system.

Fix this by only resetting kswapd_failures when the node is actually
balanced. This allows both kswapd and direct reclaim to clear
kswapd_failures upon successful reclaim, but only when the reclaim
actually resolves the memory pressure (i.e., the node becomes balanced).

Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 mm/vmscan.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 670fe9fae5ba..6fd100130987 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2650,6 +2650,25 @@ static bool can_age_anon_pages(struct lruvec *lruvec,
 			  lruvec_memcg(lruvec));
 }
 
+static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
+{
+	atomic_set(&pgdat->kswapd_failures, 0);
+}
+
+/*
+ * Reset kswapd_failures only when the node is balanced. Without this
+ * check, successful direct reclaim (e.g., from cgroup memory.high
+ * throttling) can keep resetting kswapd_failures even when the node
+ * cannot be balanced, causing kswapd to run endlessly.
+ */
+static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx);
+static inline void pgdat_try_reset_kswapd_failures(struct pglist_data *pgdat,
+						   struct scan_control *sc)
+{
+	if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
+		pgdat_reset_kswapd_failures(pgdat);
+}
+
 #ifdef CONFIG_LRU_GEN
 
 #ifdef CONFIG_LRU_GEN_ENABLED
@@ -5067,7 +5086,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		pgdat_try_reset_kswapd_failures(pgdat, sc);
 }
 
 /******************************************************************************
@@ -6141,7 +6160,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		atomic_set(&pgdat->kswapd_failures, 0);
+		pgdat_try_reset_kswapd_failures(pgdat, sc);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
-- 
2.43.0


