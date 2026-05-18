Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518F5CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 22:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B0756B0005; Mon, 18 May 2026 18:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861196B0088; Mon, 18 May 2026 18:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776776B008C; Mon, 18 May 2026 18:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60CA16B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:28:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB17540AF4
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:28:57 +0000 (UTC)
X-FDA: 84781981914.18.5A34816
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id E73914000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 22:28:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfDbF6Ay;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779143336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eNkqK2A55he/AkNTcmEivfEujicKPHNpUvazuTitr7U=;
	b=gwqCA3TO/N9ZQpdG8fDYGYnBEX69Tl9OdNq+ta9VNIppCl2h/P4AisIxBlumwy++HS6x+U
	6LvrKuhC/PF3+eu0niUwLeSjguYGjxrkN3xj9I5XN25Sfwow212cHJFbSk1FNtkFtEkUzJ
	wvkx5GE5OjY7o+CRf/kZVyJRu7piqA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779143336; a=rsa-sha256;
	cv=none;
	b=IjKrN/M7aITY7XWV+TYryr6yznv0OmusF7FhHyn5vse4Nv6bAEXh2FXJXJUrbfGkL7FVWY
	UOF3C5ZJpcwG8fUzk4BU5lkKdR/MPazY+a30RRGgJ1MFgAxhZLdN+fMgjTtjyHHBEyInGQ
	SaRpH9Ug9RDXLRmjo2MaawbGmxqbwe8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MfDbF6Ay;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779143333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eNkqK2A55he/AkNTcmEivfEujicKPHNpUvazuTitr7U=;
	b=MfDbF6AyWkNiedUaGRpVlVBH78K8WfmWXypNTh15kLqzTYdIwlwYP58CInVnc9uPKO+56C
	nQdhXnWAwVry7m6A1aKupi+6zoMg0mIk9UF0vVnWlvlz7UCJBHPhYJEp5Q0cFxG6krnLjb
	0z9m95s//rNavmPx3tyEWbJdtnlOq9c=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
Date: Mon, 18 May 2026 15:28:27 -0700
Message-ID: <20260518222827.110696-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E73914000A
X-Stat-Signature: 6nqbff44wipuo6puco3txcd5an8u4oxz
X-Rspam-User: 
X-HE-Tag: 1779143335-403125
X-HE-Meta: U2FsdGVkX1+BnwfOctxYwPHvOeIYNnSFGJ7fNuhKPqTgsQH4F1bqw0AGdgeRWcolAyLP0sM3jnoopHwPVI+OfxARlvGX8SGNhVa9RwoSlOyyrB3G+Z4PgVmoiwvrZszLQ3bwxSwU0Ak8sXHhKGnFrCDgTWHezmnB2WpclNL4c5BgH81qtsCYqDdy5ig8wFqwY0TFrEWxBvN3Ulno8Aubpm+3sMfHgQa/7S8a1KcSmc7rV7iJycyuNUF9gtOdTI24UFnoL0mxEsqzz4iSmKSapIotv9yandJ66XD0mO9MwgJLDok5VXRW+rHNleFV0UPBUKT1eYoi+QxVXw0vfu23orbBVbLLfqBPreHkh0uz+xIp6aSkGqknFipkn4GJpak9GD6wIkVYUqy2lLfrmicxCbo+PWGuufh1FllhlK6Vuh6Qv3nWkfJ+ZBFcLmhY2jPS/c4B3Ku8W0+gg8KK4xz19KAczwlPb1yY/qswo3WTgdPE8xfVZIkcN7IsvD0oU3TN6m7C/6ArRRZBcu8Xk6jr8vTJf4ZCx4hkqiYOzmkbLAuxIKAwQKPklpk3d+G+69C9bp2M84TBgu7ViOyQZkRAW2CHvzt4QjQBIErcklU1PmmNtuSorG/g/SawxdFmV3GezAjGslhmESOxXmo3GMlxdashygS6OFqPnBaQciUW8cEAcE1zujfNuc/8PIXvUMp2UCCZzfVLdCgTs76zZU5alBNudhHEMFvA7VFs1naK9tlk+PL6/wEkNlh6/+ETHrSwJWwspcWIJnqk++x6vHy1vJ9MWOpdvtH/X5Ux0aKC0+Wv3V4WjKcsxyOLgKFiLdPO/fI8YJl/dpFldWvZNcijtZjmAklsTK6koPR4yd80F3pjFCwmiEjFx4eKPZxXKf4WmbCiYKQoDkMPs5Z6erU/sjmwJp0Q4oeaPPMMs8CEDuLCOxBjkUDxpaxu7/Tx0HaWw4nhrMotXtexoa1zXNJ
 q+0n585z
 6ki7lA4mr4mgrnZvtQVTtVIEqezZ4YqIJhqqtnC+3iRO5Rd38EhxHMhCptCfcHYpwYJd1BvWgvUrh3iyz28XOfQ7j/iMiQ+CCa9r2UetjdEVhW/d1ZqLR39K9qErCp/fchz3XbqTDMT5JlHHRcQ/HPMDBQYsFqDKf4iGBYMHtHJWSEotfzN3rhmE/WIptwHd09QBaQUGCcAct6MndSABfznHoyEk4EQcGdnro7wymrz725JQ3Cqnd8XjtbuC+nszAkE7FCUFkfs4TIqwDNywYDsJIcfz4nUiT+MZUm80W5qdplix3BIUptKceZ6IgNTOlC4jsCjhd5pvF0O21V+YzHkYji+EBInED/njtNBUoz2AXwzA=
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

Sharing the reserve without re-caching means bytes funded by one
per-node objcg's slow path can be consumed/freed under a different
sibling, leaving sub-page residue on whichever sibling was cached at
drain time. The pre-existing obj_cgroup_release() path would WARN and
silently drop that residue, leaking up to nr_node_ids * (PAGE_SIZE - 1)
bytes per memcg lifecycle from the page_counter. Forward the residue
into a per-node objcg of the same (post-reparent) memcg at release time
instead, so it can be reconciled later via a refill atomic_xchg or
another release; the chain terminates at root_mem_cgroup, whose
page_counter has no enforced limit.

Please note that this is temporary fix and will be reverted when
per-node kmem accounting is introduced.

Update the stale invariant comment on __account_obj_stock().

Qi Zheng built a specialized reproducer [1] for the corner case and
confirmed the fix.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
---

Changes since v2:
https://lore.kernel.org/20260517194308.952655-1-shakeel.butt@linux.dev/
- Instead of handling sub-page charged residue at refill time, let's handle it
  at the obj_cgroup_release time.

Changes since v1:
https://lore.kernel.org/20260515171953.2224503-1-shakeel.butt@linux.dev/
- Fix the rcu warning (Sashiko).
- Fix the page counter possible underflow warning (Sashiko).

 mm/memcontrol.c | 69 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 18 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..a547ec7c42d1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -142,14 +142,24 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
+	unsigned int sub_bytes;
 	unsigned long flags;
 
 	/*
-	 * At this point all allocated objects are freed, and
-	 * objcg->nr_charged_bytes can't have an arbitrary byte value.
-	 * However, it can be PAGE_SIZE or (x * PAGE_SIZE).
+	 * At this point all allocated objects are freed, but
+	 * objcg->nr_charged_bytes can still hold either
+	 *   - (x * PAGE_SIZE)  if a small-alloc/drain race left whole pages
+	 *     stranded (see the historical sequence below), or
+	 *   - any sub-page residue, now that the stock is keyed by memcg and
+	 *     sibling per-node objcgs share its reserve: bytes consumed by
+	 *     one sibling can spill into another sibling's nr_charged_bytes
+	 *     when the stock is drained.
 	 *
-	 * The following sequence can lead to it:
+	 * Uncharge the page-aligned portion from this objcg's (post-reparent)
+	 * memcg, and forward any sub-page residue into a per-node objcg of
+	 * the same memcg so it can be reconciled later instead of being lost.
+	 *
+	 * Historical race producing the (x * PAGE_SIZE) case:
 	 * 1) CPU0: objcg == stock->cached_objcg
 	 * 2) CPU1: we do a small allocation (e.g. 92 bytes),
 	 *          PAGE_SIZE bytes are charged
@@ -160,23 +170,33 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	 *          92 bytes are added to stock->nr_bytes
 	 * 6) CPU0: stock is flushed,
 	 *          92 bytes are added to objcg->nr_charged_bytes
-	 *
-	 * In the result, nr_charged_bytes == PAGE_SIZE.
-	 * This page will be uncharged in obj_cgroup_release().
 	 */
 	nr_bytes = atomic_read(&objcg->nr_charged_bytes);
-	WARN_ON_ONCE(nr_bytes & (PAGE_SIZE - 1));
 	nr_pages = nr_bytes >> PAGE_SHIFT;
+	sub_bytes = nr_bytes & (PAGE_SIZE - 1);
 
-	if (nr_pages) {
+	if (nr_pages || sub_bytes) {
 		struct mem_cgroup *memcg;
 
-		memcg = get_mem_cgroup_from_objcg(objcg);
-		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
-		memcg1_account_kmem(memcg, -nr_pages);
-		if (!mem_cgroup_is_root(memcg))
-			memcg_uncharge(memcg, nr_pages);
-		mem_cgroup_put(memcg);
+		rcu_read_lock();
+		memcg = obj_cgroup_memcg(objcg);
+
+		if (nr_pages) {
+			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
+			memcg1_account_kmem(memcg, -nr_pages);
+			if (!mem_cgroup_is_root(memcg))
+				memcg_uncharge(memcg, nr_pages);
+		}
+
+		if (sub_bytes && !mem_cgroup_is_root(memcg)) {
+			struct obj_cgroup *fwd;
+
+			fwd = rcu_dereference(
+				memcg->nodeinfo[numa_node_id()]->objcg);
+			if (fwd)
+				atomic_add(sub_bytes, &fwd->nr_charged_bytes);
+		}
+		rcu_read_unlock();
 	}
 
 	spin_lock_irqsave(&objcg_lock, flags);
@@ -3152,7 +3172,12 @@ static void unlock_stock(struct obj_stock_pcp *stock)
 		local_unlock(&obj_stock.lock);
 }
 
-/* Call after __refill_obj_stock() to ensure stock->cached_objg == objcg */
+/*
+ * Call after __consume_obj_stock() / __refill_obj_stock(). The stock may be
+ * cached for a sibling per-node objcg of the same memcg; in that case the
+ * vmstat batching slot does not match objcg and we fallthrough to the
+ * direct path.
+ */
 static void __account_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock, int nr,
 				struct pglist_data *pgdat, enum node_stat_item idx)
@@ -3210,7 +3235,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
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
@@ -3318,6 +3347,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3357,10 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	/* Direct READ_ONCE due to just pointer comparison. */
+	if (cached != objcg &&
+	    (!cached || READ_ONCE(cached->memcg) != READ_ONCE(objcg->memcg))) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-- 
2.53.0-Meta


