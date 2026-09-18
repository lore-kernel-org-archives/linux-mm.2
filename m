Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914DFC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9A76B0093; Thu, 17 Sep 2026 20:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1016B0095; Thu, 17 Sep 2026 20:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFF36B0096; Thu, 17 Sep 2026 20:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 074A76B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:12:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3F6AF12052C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:17 +0000 (UTC)
X-FDA: 85224955914.19.B606197
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6539F100004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:12:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jJPEXLjo;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789690335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ReC5OTam6MTJ6u4FECt/nJW9XaNR1Mg3esV3ZyKWZpE=;
	b=PibqfPwa+PO7HHI8kQ3nuDhypiPf4OKNKGXJGzoGVN2YFwHk6VWNFrNYeiRSFLxfsZnShW
	+VsX5jcewuaQleQVryoqw38aAAcrif9ouylBKgQIyj3NLpEScWuj70TiQ97TX4DjkZXtZD
	7cPLAPVqUMfWgfCzHErllYJwGr2XKVo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jJPEXLjo;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789690335;
	b=TCECoAI2RZGSA8jSYew4hqNg8EYVAXBl89e8M+LorFVsVfn9F2Lip0NztPTCmWVnpI69sc
	9njZGCxXuhwGIQdf7G2O7BrFtK/NlMaBpM0fd7Ia1+EqU6Be1lMpMeUedXfoYyW9O+CocT
	ddMfJCaJ1y5QdL3R5hEGTtDj3QdmWFY=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cc46c7so15011985a.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789690334; x=1790295134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ReC5OTam6MTJ6u4FECt/nJW9XaNR1Mg3esV3ZyKWZpE=;
        b=jJPEXLjogBfJFhWENCSj8/SjX2FML0Pxm/ti9SeX6zIlwd7O2bzpgGLd+i3LdEmDYb
         W+5SmHrv0F7/lq9pCX5DOFZgtxQQWcS+7qCo94K8yh7Aubjg6ItRVLtaTXmB3JgzWESH
         A7dfoahKBRsoN5AWFW8/IKXIcpp37MbIbdK9UEnsXuCe6sY7zuLr/OQaFQCA60h0DfRf
         WF8sQDNddb12RFi3gOt7TKYfDYhI4XRIlBNn7rBQip1c0y1Q3LQ+Ny1usiHeZ/ZiCeCs
         TZFrCBSOZjUSAz355yuNFqJoDdEXcXM7+7qX15Lv4sc5Q8VUWRn9g7JQgeg36mEDUoar
         xlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789690334; x=1790295134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ReC5OTam6MTJ6u4FECt/nJW9XaNR1Mg3esV3ZyKWZpE=;
        b=WEz+laNaUHZExh2bMUNCSPKuUdZkcpYtixDAkCIJYICaL36SouiCYZ2bC+HQ7tsVE0
         Whgim8tOHX+UiTDbXaG8/vkg+r63uRA2FJEE+5JwQdiXQ9LIUaJOHw+qs1o7oO0+OSGm
         aY39ts7DVRDpH+ns/O0szr/clH9YmkvHswF6IKsbY2TmKWiq/c0L2oHo7vHNOYkNuED2
         zmfngTEzO6qrwW4hLiwS5i1uQoQgM7GhVnAtzMzJV738oaWtmlzHkHp8bue3ZzMTkWEc
         MPiW3N1NREfqS7izo3IeMLsZo09sOF2YgcWnDs+sxrD2Hd+Jd6wy7d7CW6gAV7RP5g8Y
         +pqg==
X-Gm-Message-State: AFuF++lRT98KYq7P7gta4ztT63gzAiQWwjhIn9w4H4rSPvFLeIglmfSm
	g0FeEvuqlNjXiQlePHPofOcwTHyrJ5Qct+Y7Vg09B+1gml2vuOTzjuhk8lClrShTDo0U1YbOszr
	Zmf7p
X-Gm-Gg: AYBFou37hz5bHJ65f7GENTlKxXhXPU9BZ8AmtgzI0+J3IsTFh4Qhk7P7eWdOCpPQd/z
	lCaAYjjYe+s36tQppvkPYy4KrBb0/spo3Ts0JdhaN/Xiau8OZXtsaiY55B9ufZFEQO2AYwuN5lU
	cWwRaTewLZl6X/wzbXWC5lAS+b/wtsKjsl71dkrjcNKslQ0OBUDc4u5gGEbqDkRvKFHgglQKpQA
	2JEpD5oq/STF3k6kadYFqVLgtUlU3AM/piVrDZrNfC8GLrsLZDP3ULSZQvRVmhGCnD2NvI10EEY
	q/xSoM4shUSlnxFv0rMH1rZ9/QmdMWVzlknV6VO9ofOw7GT7jma+ncCRvAkk0j9FvTsjqMoMTdI
	nqiBOsEnM+Om7GwwMiDJPkaIctp/157VT6uXlENLfClk6Zwt0AgaxhNYp4EH10gwQY2VZGrvUQg
	qOqLCpA6fnALnKwW4M4RVVgIy/k5qh8dZ9nrxAcES6mkKWMokah9g/7u12QuiQMCN91k4+MbmU6
	paaypnkWECYSI9sTYnCpLwc1bheZ5GuUzuLNDbom7vUH2WOWKAzai6YCesT
X-Received: by 2002:a05:620a:31a0:b0:93b:d7a0:d9e4 with SMTP id af79cd13be357-93bdca1640cmr106094985a.62.1789690334389;
        Thu, 17 Sep 2026 17:12:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b81cff7cbsm583762585a.41.2026.09.17.17.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 17:12:14 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 1/2] mm/mempolicy: use SRCU for the weighted interleave state
Date: Thu, 17 Sep 2026 20:12:02 -0400
Message-ID: <20260918001203.3389165-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918001203.3389165-1-gourry@gourry.net>
References: <20260918001203.3389165-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6539F100004
X-Stat-Signature: o88f94gm1tz4btrk9wqggfjjjym9jmss
X-Rspam-User: 
X-HE-Tag: 1789690335-715748
X-HE-Meta: U2FsdGVkX1/y/YTOSYFjhGiDmz0XD2DNcfBtpNGoKXiO0zSVEmWTlkcZe3mBuAgFFGIpXTHoxh+Uyn9WAQQfH/5qey9uCk8+E8Gc5eVt83TCNiopfy7tIbQ+NDdsuhNQMW0Q76R0KHLjGEWn6JMFNzas1i5I7A/VK86M5BYeeUBMyLSvHnw7+ac/5Ue8CoUl9MVriANE3K0PPokTR4Y28jt4RxENicPI2N1tlWRk8qBXfbIdGFbzSnJyKfSBaH9PueIPt4B7/Xp2gOa74OjxmlPNIvk9EqcSWonDNoiEIqDOqL4HGJnxLw3hCFRaZOuC+S1W1osyPe0SfXSCMD1iRzmiUUKyubgqJSWP3ScMSY223ERQmKRbl084MvA8VNk7iiMDJLoZXA22LJugfACfZaY6pmKHg1zOXtWY7bwZnnOLe6D2IBtVO0oynUomc52sXZ1/QiaKqAH/k2lq7UnEibwR17CiDK+mZY7KNlLU+8Og//97bbpyvVs+dYfZi47wOF9qulY7/5vfMO4jYesIs7VL6blq/cMTJ/m2mEL82nP7VUoNyVigWaOhaHGewrIDgvJhvEp4PFRxQx4z4qz11Y0eViqatb+7ISXVRRuArJUZQmKtvyhNdHYNBqU7JfZCBeZKFfDv4LP5DaW4E10qDRAi/v0+dGY6lV0TCspQb3PDSWLma8UMkPLERRO+oqBW5YEjyoGbyUoJvofx2zeH/Dteq5X1vwOti32150A00I9vrtaZyoOVOTWNGL64JaCvRQ5VYRn0pfWUr7ebgezo/YViFJac09bMr/zLPLAxNI+doAwxf0ajYaegfsRjgN1PvKJD1RJmtCyiGhUBKbTibtdU8pdIZXwNYErLCyPETzMNLUnfzZtKIy1xHgVPqZTleBwfgvMclOO7wqwDKocXPOujWlq8E2n9Z2FOHEA+OtQ1cdc/e3DqqkMh/lRsu/YUl3MKOiyLey4/uPKrBe3
 7R06Mz0n
 EtWJ2V8UIUAbOfvoayyZR1131w2Vkb8M7dLdS9G1AJWJzo+wcfj/CIeeTMjgE30sJ6df4y9j12Az6lPr6xFrTkOjfaA3XoLyJv5/KF84xWxHTaV1wuysuJnpq59O9wTnkr1IEDwUsp8QEGkyGe//lTeW+tyB04tE+4bJ/qg7xM85j9REkqbbvZiaGnEX2huo5y0CvYv+mEaQaIBYEMxArVWmMAE4iC+MzKXbdPnYoecrQn21v0ZFpHNBwN0d0XT4/PG+K0RB1hg/toyfYFQ7qDwtMA2HKp8mUGQVtIz3W8bAwx7T3dqtAWpHY375gypYbDA0EHgByZdVmkoJKNWLjCzoJhK24udeDjAmDWNMLpoK7u1a9CRrZynm6MmxWOrEDRL/8FG+wdZ8X7jNNlaRnHcLWujYNPbeOMeOu/fR9TbboLRmq50sXI+ILuR6DlFanmB73hT/RA27ThEJYOd7r99IRAfNcY6Md6ysqfCIrt06Mkajpwz9P38tDO9vmdgQoLy5CPMPF2IUcr98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_weighted_interleave() copies iw_table into a scratch
array on every call so it can walk the weights outside of RCU.  The copy
exists only because the loop may sleep in the page allocator and so cannot
hold rcu_read_lock().

Use SRCU to pin the global iw_table object and use it in-place instead.

Retire through both flavors - call_srcu() for the sleeping readers, then
kfree_rcu() for the reference-less ones - so writers no longer block on
synchronize_rcu() either.

Tested in a VM with KASAN, PROVE_LOCKING and DEBUG_OBJECTS_RCU_HEAD,
with a udelay() injected into the read section to widen the race against
concurrent sysfs weight writers, and placement checked against the
configured weights.

Every retired state reached its callback. Swapping the deferred free for
a bare kfree() in the same test reports a use-after-free immediately.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 70 ++++++++++++++++++++++++--------------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 060a0eb26917..2643915dc966 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -112,6 +112,7 @@
 #include <linux/printk.h>
 #include <linux/leafops.h>
 #include <linux/gcd.h>
+#include <linux/srcu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -157,6 +158,7 @@ static const int weightiness = 32;
  */
 struct weighted_interleave_state {
 	bool mode_auto;
+	struct rcu_head rcu;
 	u8 iw_table[];
 };
 static struct weighted_interleave_state __rcu *wi_state;
@@ -168,6 +170,24 @@ static unsigned int *node_bw_table;
  */
 static DEFINE_MUTEX(wi_state_lock);
 
+/* Readers that sleep while walking iw_table hold this instead */
+DEFINE_STATIC_SRCU_FAST(wi_srcu);
+
+static void wi_state_free_rcu(struct rcu_head *head)
+{
+	struct weighted_interleave_state *state =
+		container_of(head, struct weighted_interleave_state, rcu);
+
+	kfree_rcu(state, rcu);
+}
+
+/* Retire through both flavors: sleeping readers use SRCU, the rest RCU */
+static void wi_state_retire(struct weighted_interleave_state *state)
+{
+	if (state)
+		call_srcu(&wi_srcu, &state->rcu, wi_state_free_rcu);
+}
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -266,10 +286,7 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	rcu_assign_pointer(wi_state, new_wi_state);
 
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 out:
 	kfree(old_bw);
 	return 0;
@@ -2644,7 +2661,8 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	unsigned long nr_allocated = 0;
 	unsigned long rounds;
 	unsigned long node_pages, delta;
-	u8 *weights, weight;
+	struct srcu_ctr __percpu *scp;
+	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
 	nodemask_t nodes;
@@ -2688,25 +2706,14 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	me->il_weight = 0;
 	prev_node = node;
 
-	/* create a local copy of node weights to operate on outside rcu */
-	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
-	if (!weights)
-		return total_allocated;
-
-	rcu_read_lock();
-	state = rcu_dereference(wi_state);
-	if (state) {
-		memcpy(weights, state->iw_table, nr_node_ids * sizeof(u8));
-		rcu_read_unlock();
-	} else {
-		rcu_read_unlock();
-		for (i = 0; i < nr_node_ids; i++)
-			weights[i] = 1;
-	}
+	/* The page allocator may sleep, pin the weight table with SRCU */
+	scp = srcu_read_lock_fast(&wi_srcu);
+	state = srcu_dereference(wi_state, &wi_srcu);
+	table = state ? state->iw_table : NULL;
 
 	/* calculate total, detect system default usage */
 	for_each_node_mask(node, nodes)
-		weight_total += weights[node];
+		weight_total += table ? table[node] : 1;
 
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
@@ -2718,10 +2725,10 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	rounds = rem_pages / weight_total;
 	delta = rem_pages % weight_total;
 	resume_node = next_node_in(prev_node, nodes);
-	resume_weight = weights[resume_node];
+	resume_weight = table ? table[resume_node] : 1;
 	for (i = 0; i < nnodes; i++) {
 		node = next_node_in(prev_node, nodes);
-		weight = weights[node];
+		weight = table ? table[node] : 1;
 		node_pages = weight * rounds;
 		/* If a delta exists, add this node's portion of the delta */
 		if (delta > weight) {
@@ -2747,7 +2754,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
-	kfree(weights);
+	srcu_read_unlock_fast(&wi_srcu, scp);
 	return total_allocated;
 }
 
@@ -3673,10 +3680,7 @@ static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 	return count;
 }
 
@@ -3742,10 +3746,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 update_wi_state:
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 	return count;
 }
 
@@ -3789,10 +3790,7 @@ static void wi_state_free(void)
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
 
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_retire(old_wi_state);
 }
 
 static struct kobj_attribute wi_auto_attr = {
-- 
2.55.0


