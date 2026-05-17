Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127C1CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 19:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA046B0005; Sun, 17 May 2026 15:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16AE46B0088; Sun, 17 May 2026 15:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080E36B008C; Sun, 17 May 2026 15:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA8906B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:43:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ACB7C22D8
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:43:26 +0000 (UTC)
X-FDA: 84777936012.08.823213E
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf19.hostedemail.com (Postfix) with ESMTP id CB8EF1A0002
	for <linux-mm@kvack.org>; Sun, 17 May 2026 19:43:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5XDDwmK;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779047005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dVdq1jCkPqSPhxPa9j3o3rCe8JoThsgPaLrsDuG7ZL0=;
	b=yHLgnv1Kdb5RWkGvrqlpwNT/n6PcVc+tpNNSUdTxtaiWxEa/ZrRJH1yZe9J+NaphgdEkH4
	9LxEp/4ArNPf3z5+KfHENGRS1q4zY94qcrBs+vNyyZcXh5wczZaL4fS0r3Gkw2mERHcPxs
	jyIV1mnxsZ3fbu7bZjbyQQPu7BLNCV8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G5XDDwmK;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779047005; a=rsa-sha256;
	cv=none;
	b=mBqhik0asoSIH51V1iPCKVtTQxbl9QVnvZ27CN2de0kbaLLYcmvlXwJ/MKcrGvhwTAeWXC
	aVCABPws5hmUwFfSexhI6b0eEYAAUn0Nf73JVDhiq+kaY7/JcT3hCdaw+NiVn6O0IOKG19
	wpCGjjRV4bxzD3rJLFrq1aF29L4s4wg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779047001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dVdq1jCkPqSPhxPa9j3o3rCe8JoThsgPaLrsDuG7ZL0=;
	b=G5XDDwmKqGDrgio9xNyEW3gXjYRXJRVye2jJNq1tfICzAcvzmveTcRuNA7j0+dNrmQXq1N
	TL9CJp5z/XU/AB1YAilct63QAnncN4XLaNBg8B9pUvG4NH39l7F74XhUjJJKagXU8sBvXV
	WobS8+JwZE5bH1VoMrALbkYsolkNe6s=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v2] memcg: cache obj_stock by memcg, not by objcg pointer
Date: Sun, 17 May 2026 12:43:08 -0700
Message-ID: <20260517194308.952655-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hspsmetin8uazhcwsk7quky5czucohxt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB8EF1A0002
X-Rspam-User: 
X-HE-Tag: 1779047004-21285
X-HE-Meta: U2FsdGVkX1/AZmmBU+p9S76i4kZHtlOWOo6lV7J8miEgGyY0zcWlAu3Qyz6rAcKipj/ZoGGmTonFO//09V1kUu9zaeaA7oE/LpeIa8vwefSvBGy5pqlXkROJGPpS6ta2RuXCIEHtDVfZB5sCgtm/qZuXqAZ/11Btt+OnsSjXGDnI+3CBHqypbbBgRcLNCzRVsH6U0d2/dxR/eLM8nL1aohA8lCfAwDNZc2ER+0i9k14pz2wQqsBVrV00VuSKp1OeMdZmMojDzA71ZT3jhTWzu83xt5osCp7NKoAWNsW9tksbN7Cy76HgM99t4DTjRqION2QC3PbP+qdyDdjEdnNZVlUtdb67lPTOPCi9LFhRIGlrAoNvqBRWoIXJAwf/uraP1DKeDo7AaXw0XASBrA/8EkrQJFWdVaic6kwKEkbXrhD+caScN2UwuGPA6QynqHiixTKBoqTbOUCq3RhCyRudM2G9uzqPw/bA17pTnn/vcO+0VpvVaO7M5xNGKbQIgcNqLupR07JxbqxMU7rK5L/oOLyJ1gwAAQ8HkMkD3Fe3JOnk2MOkAoPt6jW3pUnIJJkgRXW2EyQjZK9ufLh6Wam1+tv/GEOm0ZqsBtwj79PzCxyG5Laq+OtGaEK0Cw126rTGTZ0kJ641tEgJhjg7sfw6q2jQoN4gisaEulMnXGcNJOwQDHy3YLm6GzJyHR8ORzWRKHP/hztgHfqrAZqTzzI2RvUHF9bAFJ2H4SCQDBM53J/RIiBCITBvbojyO7ZPJOeHLWF0zLTNOjzgQjhH2np8w4TwR0XQis9ioemqWvI65mlDWicwd1m1g96Io9J1+ebsooqsmgWnd1KPjCMpGJyU8LST5AQ9Ov4EgEwOXo0O8H9NEYwwaCIfAWMrTAI5F3iDgVgDgqR2gcJjELd+P/9fUpaOSUY3bEN8FToOzG8SnK7p7BE4AfRM+cYPBaNdETXm5DaSUBx+PAD5x023t1G
 lMXL9UYY
 pnZoH1pRBCj0TDcItXUHT6mz5IIlfozBscP4cO6QrTZTx27IvrV0Emvqat+VI9T+gWsLqijZwVTKho4LL126zh6nXZ9RoQB77OTE7tZI7aNh3BSkHIJD77TMmv0Cc6kgzrYbH1E9vW+EBoIEvd7nWZf0AtBTXuT4IGhhc3uTzQPcq62osHYbunAXhGnA06hL2yE1c/G8LZkAWfhIh8giTRdFRX7Ht6VT5cfmO+SIBNRHQ5/yNd1ZhGZd0zn53fDq4ydSdr/A/eOyPzBCkAglO9ZvTMcNxxQl0bj1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node, but the per-CPU obj_stock_pcp still keys cached_objcg by
pointer. Cross-NUMA workloads now see a drain on every refill and a
miss on every consume that targets a sibling per-node objcg of the
same memcg, producing the 67.7% stress-ng switch-mq regression
reported by LKP.

stock->nr_bytes are fungible across per-node objcgs of one memcg.
Treat the cache as keyed by memcg in __consume_obj_stock() and
__refill_obj_stock() so siblings share the reserve. Compare via
READ_ONCE(objcg->memcg) directly: pointer-compare only, no deref, so
the rcu_read_lock contract on obj_cgroup_memcg() does not apply.

In the same-memcg refill path also fold the incoming objcg's
nr_charged_bytes into the stock; otherwise sub-page residue
accumulates on whichever sibling was cached at drain time and
obj_cgroup_release() silently drops it, leaking up to nr_node_ids *
(PAGE_SIZE - 1) bytes per memcg lifecycle from the page_counter.
This issue was reported by Sashiko.

Update the now-stale invariant comment on __account_obj_stock().

Qi Zheng built a specialized reproducer [1] for the corner case and
confirmed the fix.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Qi Zheng <qi.zheng@linux.dev>
---

Changes since v1:
- Fix the rcu warning (Sashiko).
- Fix the page counter possible underflow warning (Sashiko).

 mm/memcontrol.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..e22ffa3b3319 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3152,7 +3152,12 @@ static void unlock_stock(struct obj_stock_pcp *stock)
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/*
+ * Call after __consume_obj_stock() / __refill_obj_stock(). The stock may be
+ * cached for a sibling per-node objcg of the same memcg; in that case the
+ * vmstat batching slot does not match objcg and we fall through to the
+ * direct path.
+ */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3210,7 +3215,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
+
+	/* Sibling per-node objcgs share the reserve. */
+	if ((cached == objcg ||
+	     (cached && READ_ONCE(cached->memcg) == READ_ONCE(objcg->memcg))) &&
 	    stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		return true;
@@ -3318,6 +3327,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3337,11 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	if (cached == objcg)
+		goto add_bytes;
+	/* Direct READ_ONCE due to just pointer comparison. */
+	if (!cached || READ_ONCE(cached->memcg) != READ_ONCE(objcg->memcg)) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
@@ -3335,7 +3349,12 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		WRITE_ONCE(stock->cached_objcg, objcg);
 
 		allow_uncharge = true;	/* Allow uncharge when objcg changes */
+	} else if (atomic_read(&objcg->nr_charged_bytes)) {
+		/* Fold sibling's stranded ncb into stock; else release leaks it. */
+		stock->nr_bytes += atomic_xchg(&objcg->nr_charged_bytes, 0);
+		allow_uncharge = true;
 	}
+add_bytes:
 	stock->nr_bytes += nr_bytes;
 
 	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
-- 
2.53.0-Meta


