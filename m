Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0779D109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A91D6B042C; Thu, 19 Mar 2026 22:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A586B042D; Thu, 19 Mar 2026 22:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5976F6B042E; Thu, 19 Mar 2026 22:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49A5F6B042C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:08:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D93E81E06C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:08:04 +0000 (UTC)
X-FDA: 84564806088.22.B053750
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2CAC5C0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:08:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7gazw7S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773972483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uqC2n4jtYgB5WUI932AbJPwrEp5yFTXjiuWiQl2OLvg=;
	b=XpQaKF7nAxynndblaHQWf2XVhSTC9eVXUq3LSK/Y0qBQ6fGkdQpvx1qoKIB8hJT5YMqG+2
	waKQrFF5vn41UkOmAT96z0Pbz74vl7ECa1mi3UUrk0HYN80rcPDFwcQI3vtEoFEQTc6WEf
	7dCZal6lueJS5BIE0FOuNWLqGWHCiLQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p7gazw7S;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773972483; a=rsa-sha256;
	cv=none;
	b=zYKDjqFeIXFhRPzVqhOfD9V+/qI8mymJseKVqCWlF25PllgBHm5dehNtlyHT77IDNx1slG
	SG2sg5RQjbW/OaXIpWbhcbtqoe/DNPLtedaRWqmiC7KbqlgyAIx4uinaf+lkCUuziMtGD7
	q4RwId4gKbVj+yrr+6Qpafwf0JAFFSg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773972480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uqC2n4jtYgB5WUI932AbJPwrEp5yFTXjiuWiQl2OLvg=;
	b=p7gazw7Sd5DvqjmrmCeeYyG+kF0rT7XzsytLSmfQ6QmPI4oYDSPX/cFGW6gajPcCqYxtRP
	7XHxOgkJiDZ5VmnVo5/Z0UZyEer5xbjbWuBuCFzdbE1MpHJ4oRzWsySeEAA7ebVgbb/rw+
	MEBapoa2/iU3PuPeI4RewH3Bgmdx8Hw=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook
Date: Fri, 20 Mar 2026 10:07:45 +0800
Message-ID: <20260320020745.833792-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CAC5C0002
X-Stat-Signature: afop75f7st7tff9uytuqawrmpbfbiaos
X-Rspam-User: 
X-HE-Tag: 1773972482-43146
X-HE-Meta: U2FsdGVkX19s1CyB4Fo+cKp3T84jHe79oHpUZcDO+HRVkLj3hM1c3vsxUW3sUS+jN9tS0tSHErdLSiEHLS6ft5wM9GRhR4tlgyZfAy9/z/5Y0eJrkmui3hAWMZE/4nbf7i16YxNeQ/1YTBcTDbFdUB3Mqh0zCjjJ/zRWzccVCh6KTnTOuDKrpD9wTqsf+VgQl/zZsV+4FMDQ8QNuWFP62azwTcaBQzJgV8lk1wLwwL64bkXzu1Uo9moIwLKlqnBOlBDi7HAz6KEHu85y/8ZWwB7zLO/saGNhs2y/lbhMEb974bFCSNmQituJtyeej8CtcXhZOo/811wbFan1YsqOpRB6lnsvRaEl3Zy5rvNsNtBpfGGrVmppe3+qtehv+Dlqy5M/x0NDblv0urGAj/WiL2Gz5zhJ3mIBbzIBDuAN01Xnrqhy9vlHbg67bWhMdWYCoi0IDtDZNm7A6aLIsgsXe1bH4r7tUCr0kLBJuREt/XXGrqo7FJdySwZFUttTlhm33nsUmLSC+8jMc+6J/eQ2/17kybqAUFRxqUBo85Kccjib0Y5EOa9Pnmq4me0Yr/yBXxjAODDV+f0rOxuAI6Q9Vt5NOh4QhTFIkSuqyaQ7Ea5GY7yzjlb4xn/IZXVZUD0DP2o+/mOeoJaR0gPnSgCO1xXRS1pI+AelxcLKnexlL7zeYtLaZkmu2KD6FX8prB0/Ae7EePpuRDVBSeedLLTBjw4c3UCLo13Jg80/3agvOoMudndaTAdh5bfHEqeCsKzBR2AGyoHf3JG9HIsiWyasMCzDd5VbsdtIBOsdp1vX+y7xpA1u69418xGfQXgD3fglnCTztjDojddAsQLrjyIgkPwu6Yqd9Cu+PU3zwJaxFuO2WKnv4g6lPR9lhT/TszhGAj+k2CE5jyzL7AFMDazlx/5BPmElVLi2DNICWq8hEBsURfe17oQLekHJjy81StR0kJDa81mI9kK6L6LpTGK
 sjeJw75t
 oPFmPKKHnbcxSiOlh3z1kv6/ysc4wC4mpmhKLOuvH04hRtV/t3GDCdld/2kHcFQ21JR+0sfWsn7ZTnzbH7w4C911PMfzUdE4VQzqAntBp/swReSYmvosUEhDiuPS95rzixvsof8zpTPxBPjUePlz9v75ADoVCuVle5sKvXXhOrrfGobeiyFq2lhwbB2OhFFg638YHVyiLeWZNni/2a0MiqRsFZeAjEnx6fu3vf6u5UGc8Ej8wUNApIVp42EliP+DkyynryaQlo1cZdC3QVg+kCYl9N4iX8edWWMWsqnnVu3PKGf8A7UnA8rCXfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: teawater <zhuhui@kylinos.cn>

When kmem_cache_alloc_bulk() allocates multiple objects, the post-alloc
hook __memcg_slab_post_alloc_hook() previously charged memcg one object
at a time, even though consecutive objects may reside on slabs backed by
the same pgdat node.

Batch the memcg charging by scanning ahead from the current position to
find a contiguous run of objects whose slabs share the same pgdat, then
issue a single __obj_cgroup_charge() / __consume_obj_stock() call for
the entire run. The per-object obj_ext assignment loop is preserved as-is
since it cannot be further collapsed.

This implements the TODO comment left in commit bc730030f956 ("memcg:
combine slab obj stock charging and accounting").

The existing error-recovery contract is unchanged: if size == 1 then
memcg_alloc_abort_single() will free the sole object, and for larger
bulk allocations kmem_cache_free_bulk() will uncharge any objects that
were already charged before the failure.

Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
(iters=100000):

  bulk=32  before: 215 ns/object   after: 174 ns/object  (-19%)
  bulk=1   before: 344 ns/object   after: 335 ns/object  (  ~)

No measurable regression for bulk=1, as expected.

Signed-off-by: teawater <zhuhui@kylinos.cn>
---
Changelog:
v2:
According to the comments in [1], add code to handle the integer
overflow issue.

[1] https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu%40linux.dev

 mm/memcontrol.c | 77 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a47fb68dd65f..e65130d521d7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3448,51 +3448,90 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 			return false;
 	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; ) {
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		struct pglist_data *pgdat;
+		int batch_bytes;
+		size_t run_len = 0;
+		size_t j;
+		size_t max_size;
+		bool skip_next = false;
 
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, false)) {
+			i++;
 			continue;
 		}
 
+		pgdat = slab_pgdat(slab);
+		run_len = 1;
+
+		/*
+		 * The value of batch_bytes must not exceed
+		 * (INT_MAX - PAGE_SIZE) to prevent integer overflow in
+		 * the final accumulation performed by __account_obj_stock().
+		 */
+		max_size = min((size_t)((INT_MAX - PAGE_SIZE) / obj_size),
+			       size);
+
+		for (j = i + 1; j < max_size; j++) {
+			struct slab *slab_j = virt_to_slab(p[j]);
+
+			if (slab_pgdat(slab_j) != pgdat)
+				break;
+
+			if (!slab_obj_exts(slab_j) &&
+			    alloc_slab_obj_exts(slab_j, s, flags, false)) {
+				skip_next = true;
+				break;
+			}
+
+			run_len++;
+		}
+
 		/*
-		 * if we fail and size is 1, memcg_alloc_abort_single() will
+		 * If we fail and size is 1, memcg_alloc_abort_single() will
 		 * just free the object, which is ok as we have not assigned
-		 * objcg to its obj_ext yet
-		 *
-		 * for larger sizes, kmem_cache_free_bulk() will uncharge
-		 * any objects that were already charged and obj_ext assigned
+		 * objcg to its obj_ext yet.
 		 *
-		 * TODO: we could batch this until slab_pgdat(slab) changes
-		 * between iterations, with a more complicated undo
+		 * For larger sizes, kmem_cache_free_bulk() will uncharge
+		 * any objects that were already charged and obj_ext assigned.
 		 */
+		batch_bytes = obj_size * run_len;
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (!stock || !__consume_obj_stock(objcg, stock, batch_bytes)) {
 			size_t remainder;
 
 			unlock_stock(stock);
-			if (__obj_cgroup_charge(objcg, flags, obj_size, &remainder))
+			if (__obj_cgroup_charge(objcg, flags, batch_bytes, &remainder))
 				return false;
 			stock = trylock_stock();
 			if (remainder)
 				__refill_obj_stock(objcg, stock, remainder, false);
 		}
-		__account_obj_stock(objcg, stock, obj_size,
-				    slab_pgdat(slab), cache_vmstat_idx(s));
+		__account_obj_stock(objcg, stock, batch_bytes,
+				    pgdat, cache_vmstat_idx(s));
 		unlock_stock(stock);
 
-		obj_exts = slab_obj_exts(slab);
-		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
-		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
-		put_slab_obj_exts(obj_exts);
+		for (j = 0; j < run_len; j++) {
+			slab = virt_to_slab(p[i + j]);
+			obj_exts = slab_obj_exts(slab);
+			get_slab_obj_exts(obj_exts);
+			off = obj_to_index(s, slab, p[i + j]);
+			obj_ext = slab_obj_ext(slab, obj_exts, off);
+			obj_cgroup_get(objcg);
+			obj_ext->objcg = objcg;
+			put_slab_obj_exts(obj_exts);
+		}
+
+		if (skip_next)
+			i = i + run_len + 1;
+		else
+			i += run_len;
 	}
 
 	return true;
-- 
2.43.0


