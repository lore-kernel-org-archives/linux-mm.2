Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09710FF60EE
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718B96B008C; Tue, 31 Mar 2026 05:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C96E6B0098; Tue, 31 Mar 2026 05:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B79F6B0099; Tue, 31 Mar 2026 05:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 464546B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:17:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE680140C6A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:17:29 +0000 (UTC)
X-FDA: 84605805018.26.2D938D2
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id E92BF1C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:17:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urNiOCnm;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774948648; a=rsa-sha256;
	cv=none;
	b=ZyOtjgriJ/o2pgsEEn8TTmzV/E1X1I2TXN+zZFCN6iAjjKZCGjKEeKo+Ie01w5VLVyMJ35
	1IU2H2XOmVIaOYcFw+CIBV3nvCogEG6gsNF9Azj2RMXQsosg2M8ejS5qGwg3m2wDAWOMDq
	fNyBn3+8mKjXBudbXpzdR0b6UekdCRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774948648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lp3DpxTMCR7y+PPNSc4ZSesA8X8RvD0NTh7t+I9q0Pk=;
	b=fN2CbesIIQtO/b6OxF9T9AEIStMpCNyC88IegLYJl44DlWaGh5HA+fMTgDRzeppjov46jG
	CgD3+l9YYKiP/FQvfrcSnKTWz8u9oXc0BenFHaqrZpvTuGYBC3CyL02xidOzS9UQ0yNgyD
	oegkmRxQ0z9foe43K2+ivgo4vcmVOjk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=urNiOCnm;
	spf=pass (imf20.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774948645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lp3DpxTMCR7y+PPNSc4ZSesA8X8RvD0NTh7t+I9q0Pk=;
	b=urNiOCnm2nA1ap8689/tDYlQ/VXYIFTKHVvXNCZnKlJYDDK/+GzCJ/wgrIIst/j+7thz4v
	qZwF/jJt/Ts7FFBGcQ0D/E1PcXRVpSvE2u+CjhCkZry2q8S5Gw+6ZD/8OqJ/ZG5Ho4g8v2
	GeyAxmhOMUkGUUtMZoRK47cgFHzOXRs=
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
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-stable v3] mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook
Date: Tue, 31 Mar 2026 17:17:07 +0800
Message-ID: <20260331091707.226786-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E92BF1C0002
X-Stat-Signature: 796zj1kqgmdnpo6tpxm3qf7tdbj9on65
X-HE-Tag: 1774948647-374992
X-HE-Meta: U2FsdGVkX1+7ON+ZhFBvvGL09p6EBuWrilSyeACkmnisBDeUz8sXo3srh2n79/PtqaoCb0/YXwRTm5ls3zbwK3AaoBoHIAA62sr71eNmdOPwEU/OHwXZxwDzT/fptHGu9ovi8aUiFOHSFpcEGR1tPqpoNEqNfafAJSI0zsPtGwu3nlalnph//Ze3A8Mev1chjzs0xyaPR6StZ8qQB8IkiOJmSv8C5kHwWOIQUqRGUywDX4leuOhaCM94Z7c0qiO3uiUV0p6NVEKCLS7VX6UnXQZwyab6yG0p9IhOMFKjWaBFPVMNfBZKgvatTmcxbK2wtaYy5J2fhJfCe27xu+OVRdYMuKv2bqGNZS9joZ7Suv/CER3ryS76UcSR5K9V453y+prg2rmJfrC/SQuZ5zghAPfueYk/0Eyo6z9g9u5QYiuE9SgNcyOulWPOkCywb7/iRp+sM3vZt8i1tlucTTVRde+MhfJnJsFiHUgWGmJBgqK9u8cO9JykcUW75Ia8AUbeQs8bLzP5DhNNLUf0+FmXrSi8mwMFSxO5z7YDdlCJyA+zXGfpgy0dLQDhN2wpgLvqAMJ+OJGL6Ggd8Ff8cnDLBSTXGrPqZTczzHiv//fv3IDko9YnRS1Tf6dlttjR/jPN5xND9Fe3LizPV+fq9z9E5NyElwxrqTCBYTdlC3jFne9MsAFgCS2jUUIQIOlntxJVGZy4SSZdWitInGKM4bzVY9AN836efmPsgiHgSPWzCzEJuroz49WUMj/iG/vYl9d2mhNOfNGbLjtoJ22dRRdllEmrf33R8/zhW/qAkC9DjPD4YvZWtSLxmie27tCbMeRzxITtrUVJshKxpc3LcliWlEDQBF1LGeOOtY7v05gfXY6X74KC1a9CtL0oww/8o3qepiN0gf1ht3EwyF2B2C+WcimgVNLGMBWIU03puaDyrczigsVTYx0VUtXKywT+2JTxKJ2l5JL10uMCuQ+eLqs
 hCpBcdS4
 2qXUI4cWYkFbBT2O+/yHYEzU3dnC8iClxHncxBHm65whYqKou79haxEiOPqiH/N/NsU8HSD2UIFtXys38jDpYKjW+rXZPKHxWQcn6COqPyeUJg1OJnL1DAhpxEzi6ahjZgqSHbCVCTXm4xHwJPCMetP43Xc/+xfoWYc/I4pjrjItRfsuVqqsY5+eylJ63jaiRCSYJlODQ7oDjQpdEphCh5BstIOHho84A7GN8waFCcsfSkVZEq8QbTI0zOvU0zCzISvwHsaaEm/0TkKurdkKkk8Y5kJYQsESxxGVwEyGJLiEO44E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

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

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---

Changelog:
v3:
Update base from "mm-unstable" to "mm-stable".
v2:
According to the comments in [1], add code to handle the integer
overflow issue.

[1] https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu%40linux.dev

 mm/memcontrol.c | 77 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 58 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 051b82ebf371..3159bf39e060 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3277,51 +3277,90 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
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


