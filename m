Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5DFCCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 15:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4656B0088; Fri, 16 Oct 2026 11:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7565A6B008A; Fri, 16 Oct 2026 11:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66B706B008C; Fri, 16 Oct 2026 11:54:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B6B16B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:54:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA596A04C7
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:54:00 +0000 (UTC)
X-FDA: 85328935440.28.417D0E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32048A0008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:53:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxjrIKjs;
	spf=pass (imf25.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792166039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kJXPyKDReNETsbabdJcxoJ4iyMjVrBk5Ibj9K3xRl/k=;
	b=wb5Sw591+va6TlrHMIf2NsY3+6TunracfsPTfHGCcWKjW5QnZjIvAwzIMNiwiXNKFLzukG
	qKUYlWi43EYkMsh1kK07qUZJ5SyjqAR3+6vtb150Bhi9J0tAHLwjHc/JTFFggssAlzhYfR
	VGuXWvbE6x5p3kJTPj6x1G48wqY4Luk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792166039;
	b=gKb4PXZPUr9miS+xTwKE0G5dgAwUpfObI+CkbM8hirPy1opN2zTD4XgOVohZYboL8jWzwR
	nNjvEuxIeWNnWs3ak2yWun3WGdf0p64e4onFo9dkUvSZa3UEHAaa7iC2SUk8xJg103G7Yb
	vbN+Z0yvO/p8v1NW+ZJNk/RNVo+Omq0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxjrIKjs;
	spf=pass (imf25.hostedemail.com: domain of puranjay@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=puranjay@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61D024244F;
	Fri, 16 Oct 2026 15:53:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BD21F000C4;
	Fri, 16 Oct 2026 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792166038;
	bh=kJXPyKDReNETsbabdJcxoJ4iyMjVrBk5Ibj9K3xRl/k=;
	h=From:To:Cc:Subject:Date;
	b=lxjrIKjsJ+kdH/k7DpC3BJIRMLlojm/2LyIpb6pevJkK6OilqDXz6wYnqr9eda3BB
	 iymATJMNo10wC9Kjs3whvAeKSHZW4f7IZ9WzLmRCS9pTInCuTWpJnyHH20B/dSzR75
	 yfpuVIQGjWxJf04kwBUyhAsqXRpQDDYWn/nodrgsHKeJ9BFy/3Wo4k/zj/6OiZTXH3
	 wXlalzvEVMi5Fu0YpgUoT2dODrN4z/jydYnI3BobXqolw3KCQOO6NXQDSPXvoAxv3s
	 XWDQnNqgm/Js5Tke8lniHveVye5LA157s7PIridsUuL9wAqw4xtnlhZOUTg0dWA/n2
	 rP1wSH9ZsM3Cw==
From: Puranjay Mohan <puranjay@kernel.org>
To: linux-mm@kvack.org
Cc: Puranjay Mohan <puranjay@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/slab: Call call_rcu() directly from __kfree_rcu_sheaf() in any context
Date: Fri, 16 Oct 2026 08:53:39 -0700
Message-ID: <20261016155340.3304319-1-puranjay@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32048A0008
X-Stat-Signature: ahg7rdcec3wdibjdjmyjfbmuxqijrbos
X-HE-Tag: 1792166039-292354
X-HE-Meta: U2FsdGVkX18vk7LQSnR3NbgMZrgZPgi+WBDTsAyikSjDIJb4Dsip/u2u1FoSHxcAgnKb+TsCjsrDq2+MPXMQQz7pqgyrE3J8O0UEh1E4q2Q4DBUyax1Wl9Y21m8wqVdzcjQ85M1+3519n+9VauBlvsb4jKF5MVbnrLjhy54aHuxYN2rk5RaeQH0CHVjBdWqmcNmvIo9tz6//RsrxzmJ+Vs6eArKEfTTK8PEm3hy9EnWFFNg/ACPEEyH2174aO/Bv+gZM0sq9MECPjIBTmeKK7esuR1dCN014SWRcjyEOzfSFUJDYzIg14LoTvSznu0j4LsUFAtWTofsbgEjddtPK23LhrkMVm/3DkRghx5wDxfnG+BuU/pQGkQEg5yFIp5dfrl51RCpUTYu4x0/Wane4pmMzcO375ncUJEapSuYihzmKKsGDqM06qVuiNFT/aN+T1T2sClaZNPPJg/PMDe/ETsQb329Z33ilaatYogZEcPReK01e9Jpddeyi/sxB5g13nysf63/NDRGgQSBOicTB9BEjIJzPgoI3AtExCb92GgNCodT1T4uf890ssY5j8tXNqJbtRSOlfkTSOjNiSvSNiNbg9krJYz5vtrznY8Gq5FyqhomcR+vzHAh4WpGnGjVFZRehbc12zkiYUpDCA5kaA+gSkeCl0BdrX0Gzla183GEncgeFyFetvubQ+1iCygdbWWHwZ69SKMKysI8GD00jrgp3IyXJwJulzy0i97XYjDMn+QZJEJAR5BMqhFpYnJcSnjA3m6s1O6tBW6Ch7GLLTp4qr7j97nNuj0FifFCgk6uvw8JSkkE2L9xWMR85tcWJgD7o+OR3UsAGWiKqRYhnx8mla++nD9N1QM/evd30EjsrSfDa6EKColky0v1qsOTpyZVvzZBmnjaetEL/pYdgdyCP89Y1YDtQTb57hnDzVzlZKixyEhKESmVcdzzzOJxbDWHGXGKQKtJS4AAbcmH
 4j7obMKh
 Wp0Ig+MTQJ+6Wp8rubNha9Z+en1x7+LFI69QTG36JG+V20h0bWjZvY5bCNBVwjRVf7Fd+lg0hO/eeNHHtk593q7pRagGvnA7C8bFExGKeWdW/rP6T7kESb1Ue6IcOsiV5VA2/9WS38Q5pS0vIxe28LUlUD+C4i5YZIhEyqzSKW1nCre92aMEV4MKgsOQOd04XATk3n+8T0ZHBr8VkiPdmkQdIJPi7rmt/gN8ednpB3snMy0auBiLdaC8vjtpay7GbzXAfw/LlWZlWp6VeGv3DVEaqbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__kfree_rcu_sheaf() can run with allow_spin == false, e.g. from
kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the same
CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
extend deferred free mechanism to handle rcu sheaves") added a fallback:
when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
per-CPU llist and submitted to call_rcu() later from irq_work.

call_rcu() now handles this itself. When it is called with IRQs disabled
(from NMI, or re-entered from instrumentation), it stages the callback on
a per-CPU list and re-issues it from irq_work. Callers no longer need to
guard against that, so always call call_rcu() directly and remove the
rcu_sheaves llist and its irq_work handling.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
---
 mm/slub.c | 28 +++-------------------------
 1 file changed, 3 insertions(+), 25 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8fbc6bf8ebc51..6c44f4495db5a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4145,7 +4145,6 @@ static void flush_all(struct kmem_cache *s)
 struct deferred_percpu_work {
 	struct llist_head objects;
 	struct llist_head objects_by_rcu;
-	struct llist_head rcu_sheaves;
 	struct irq_work work;
 };
 
@@ -4154,7 +4153,6 @@ static void deferred_percpu_work_fn(struct irq_work *work);
 static DEFINE_PER_CPU(struct deferred_percpu_work, deferred_percpu_work) = {
 	.objects = LLIST_HEAD_INIT(objects),
 	.objects_by_rcu = LLIST_HEAD_INIT(objects_by_rcu),
-	.rcu_sheaves = LLIST_HEAD_INIT(rcu_sheaves),
 	.work = IRQ_WORK_INIT(deferred_percpu_work_fn),
 };
 
@@ -6308,22 +6306,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	 * we flush before local_unlock to make sure a racing
 	 * flush_all_rcu_sheaves() doesn't miss this sheaf
 	 */
-	if (rcu_sheaf) {
-		/*
-		 * With !allow_spin, we might have interrupted call_rcu()'s
-		 * IRQ-disabled critical section. If IRQs are not disabled,
-		 * we know that's not the case.
-		 */
-		if (unlikely(!allow_spin && irqs_disabled())) {
-			struct deferred_percpu_work *dpw;
-
-			dpw = this_cpu_ptr(&deferred_percpu_work);
-			if (llist_add(&rcu_sheaf->llnode, &dpw->rcu_sheaves))
-				irq_work_queue(&dpw->work);
-		} else {
-			call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
-		}
-	}
+	if (rcu_sheaf)
+		call_rcu(&rcu_sheaf->rcu_head, rcu_free_sheaf);
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -6532,12 +6516,10 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 static void deferred_percpu_work_fn(struct irq_work *work)
 {
 	struct deferred_percpu_work *dpw;
-	struct llist_head *objs, *objs_by_rcu, *rcu_sheaves;
+	struct llist_head *objs, *objs_by_rcu;
 	struct llist_node *llnode, *pos, *t;
-	struct slab_sheaf *sheaf, *next;
 
 	dpw = container_of(work, struct deferred_percpu_work, work);
-	rcu_sheaves = &dpw->rcu_sheaves;
 	objs = &dpw->objects;
 	objs_by_rcu = &dpw->objects_by_rcu;
 
@@ -6571,10 +6553,6 @@ static void deferred_percpu_work_fn(struct irq_work *work)
 
 		kvfree_call_rcu(head, objp);
 	}
-
-	llnode = llist_del_all(rcu_sheaves);
-	llist_for_each_entry_safe(sheaf, next, llnode, llnode)
-		call_rcu(&sheaf->rcu_head, rcu_free_sheaf);
 }
 
 static void defer_free(struct kmem_cache *s, void *head)

base-commit: e52c7c28dbece00f54dff26e1554df2fe59b02f3
-- 
2.53.0-Meta


