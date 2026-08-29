Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94866C61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908E56B0092; Fri, 28 Aug 2026 21:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B536B0095; Fri, 28 Aug 2026 21:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782206B0096; Fri, 28 Aug 2026 21:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 580D86B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:59:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 49D5D1C216B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:52 +0000 (UTC)
X-FDA: 85152651024.24.BD26D19
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82D6EC0006
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:59:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iTAFNOmG;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787968790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jC5RZ0/W3U26Ng+tF+NWajMfbOb15T9nPbwMwMEpGWM=;
	b=B62xJkeiVNQ5DroMLAegu/Gl7C9R19JC3UYOaAMSINGezSvtEfZibtF5L7mK4hOn7qqEej
	zRsap7GUhKxr0TLz1g5RWlRCOeI8EWhzKIP0NIAX+zf/kOvbCXZVci+NlhNthB4O3t0FHD
	/RYLlkfJcO2uBpo24ikoBAOGo5kqe/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787968790;
	b=8iIVGzKRNSAMhyRRRyYydbb8lWo4B6jve4T3Q7MutgbHaFUkZWVz/zIgttvYMfRbFuaB8h
	GSlXrvNsCe8uC2pULeZzlODq3EcjZ8B89F7lr/vHx2dtHyhpj6f6kejwtY4wIzrgdJ0tDm
	zod8xjnTCyrJxTEUSRfrPnE4WcyIv3o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=iTAFNOmG;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e55b62640so70651385a.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787968790; x=1788573590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jC5RZ0/W3U26Ng+tF+NWajMfbOb15T9nPbwMwMEpGWM=;
        b=iTAFNOmG8VQCCj8qaP6fxpmqRLk8Yi9gNMVCRYtV69OheiFZ3ak8W4EdLll5gmZPSS
         uQtdyiMuI0Jr+q3EIKCHMHM0c3ZVVxe4nrsDld2B+be0NKP2X/ZK9xeULu/YFq4v1SBg
         hikwYne2273E++SK/jpRtwzXUTiWxw2xfoWlCDJGIVo9QCiS3ZzCsZi93N4ixMy1GhST
         Q3BnfRuoGn/2SyWTp8s1tO9IOnpmdFrXXVHQHQ9C1VcTQd7e7eYfAHxiFcHh6+TDVZ9W
         iUmFNZfko1Oq87ct8gVavE8Du+vAo1IW4SHdP6RpfnVtLpfCGBKm4QjFUJJA/mL7Z1+5
         Mkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787968790; x=1788573590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jC5RZ0/W3U26Ng+tF+NWajMfbOb15T9nPbwMwMEpGWM=;
        b=Psm4prvyYSITmEmBQcI43E7lPslVcmIFNFjY/zczFdPAXeSlgBI3ahqob0zRjACJSK
         ok5CvKr1VAPAsl/gddK4pswDXjHBfCgHUKKQMmOYM+Igm9EIAgBE4TXBg5qMWEIj8qNA
         aSsFMzI7lTec4PZvgEG83dKzb4Fvb8WlLJXbGHdGJmiZqD6073gQnpVxujmjcR0Xzkg2
         lKX3u2Vu8R/UYLAZv3S1/vIPtYP6U/0FJxaj4JhjZ5ao7rHgdXWIkLo60yg0ztOE3T4c
         WcECPEfWVKcgw0KvRgLgTT7ueN6ibRCflyUuqug/0OhhlyqRkx//wlqSj1TJVnDN/pC3
         6mNg==
X-Gm-Message-State: AFuF++mGSsyz3r6OKw1h17n7CnX+8cP2Ynsb4ZLjlcDJnF06MK6Tm2Py
	c1ucWzdKcI47ucIVmXFlaDGaEh+7jrBtAQp1k5RkhHGrs6biP88b+XHMj57gmxVlEybh9mMlyv5
	V9bRpk5k=
X-Gm-Gg: AR+sD12jsmHRn5EKfTo+H5MC8Kjtfn/xGvsf+ZObx7XgNHOgvcU85xBIJOCk9Rv5lUM
	3+0YxLsRYdAjThqEDGorQUZkNwIV0QIGWTcm6OkYL4kyiGQKC3l6wUMbB4oR8/8KZ5FpVK662SJ
	JAgCzli3yhLEtMH+zQJlaBrsiIzJchbf2U1lv/+MRQAfne5Nazzp2X9etrAQ6u4ZJG+LTzhAHEG
	00IKYihIUO1xBWIc26/AnR6Z+yF0G/qnxXG+sIb3iFu8ycKa81OxDGf3gvWxYZmQbE4+lKTFQrE
	MNVaMIvtHHwxa6PUdfCpkiVKdR+STn77G/rzNPF/wIxd/NZlfJzEsBTYMONLjSsXSklc5pIJ/jw
	n4hBLTJqfR3oSj5l5AfJ8GBiZAQQexV7nR0oZsEiIPaV9y3fbQYQwH3ByGmpiEE6tuOhHLBj6CH
	RB8ToRkcwdiw6gIU1tp6xzze0RTeQ6rBZ4kw+8/mJNh9l+tTc6WxN2pzazD9SaFaq/MCCLrvIUz
	Yw46Nd7+JgcinFSyrThY30KrKohd0kgFmrJgmiEn/lRnZSJEw==
X-Received: by 2002:a05:620a:40cb:b0:936:cda7:554d with SMTP id af79cd13be357-93913798773mr1261501085a.14.1787968789658;
        Fri, 28 Aug 2026 18:59:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9391701305dsm272582285a.4.2026.08.28.18.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 18:59:49 -0700 (PDT)
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
	urezki@gmail.com,
	chenwandun@huawei.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 1/2] mm/mempolicy: use SRCU for the weighted interleave state
Date: Fri, 28 Aug 2026 21:59:42 -0400
Message-ID: <20260829015943.1258774-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829015943.1258774-1-gourry@gourry.net>
References: <20260829015943.1258774-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 82D6EC0006
X-Stat-Signature: hkfg17f7g3bg6efhfakkp1ctk1uouiw9
X-HE-Tag: 1787968790-687010
X-HE-Meta: U2FsdGVkX19w2bj0s8UA2DoxvEFcZSHJjdhpoG+TmhVWducra7fcAtzM6byb1aXffDB+VmXEXDjHVN8z7oq8O+1UddbGwidNKwVOhZn0ldqGx4WpBWyE1WyAwMGP8oamTr57o8BUVS2N4yKiJntFLxDfubU5KVcjhh4OxhhwPCvNl1r724vGS8FFZPvf7YUFWgtddfNZ7Gc5IHQ8Ast915qiVLXbgR5ZYflANtmcpZWwuPbMD0bVssWYMNEjsAB4OjyURtTEseZRjKlzxuClMSyRkXGnPrdpJ6Bo89N+oM4tuKpq/+OLsGmTE0xwLK5wT1DlpAPUt7h/8GlT9qfYGyWCmQoaeFoJojahooBAtvqfX5AlnpTS2jBBUK/qcohWaPBYwmLqBE9w7ws1kTjvpVKsR/9lNzoPb7gpyh/Vpg8QQfW3VOvDYzWpulePf7qCCGatbkpkF0WTQ54X1b9qX77h2VlZyLK9aWx3nOutETmQimpQ9C1Np4RQVfUwzS3ccB9r/GTKK7NqPCYcHLMteun5Gicxd3Rc5ilChxvwPWdt2pz3d38DOSWUkuYjrnGfcLY9y7OQwl6uMfFAGwtwjICaqnoe/7r++wiKompqCL6iud5t/VIeyOsxogshXDkKrFwjGKHkz5/yBZ73SbxqyqwqtCYc4O4h0V1s4Rc8jHuAf20rkNncw2afq3HptGAaiApI641+EVrxrK0+ADHMSVVn9TrURHQ0PARxTX99yD/6TCTQP8K4SwzAE89TTbqF1qOHrScAeqXoH6nTSKAheqYTA5GV7g5OQTzylzf5GwXTwfKr/Gai9nSHFzkNDahZvt5J+kqTOafLG5nmJkScBcNEsQ90Xg7cHU7TrMb4P1fuu9arL7OJh4z7SOaufGJBu9q9/FjfHX73vCquUYtZ+eQnMQGV8JeQdYw5m3rul7Lgu3OEKQxiDShFukwVg8vw1YLvlNairB0rjtWklYv
 js5YMmw6
 GzGu6u60+wg2FAc37SRyHPn9weK5On0lRbGJBZutXkzFzqOYVQzKwRTsl25xCiJsKZ+ZyM7GLWuM37wIgmmj/cCuK8NEs+WyeIO+BiNe2bMk2Yoy/NlkO7EWlYM0M1oakQebudvu8EGV4iEPI89sL6SsVlEX9liHOwiqkHJCZtHB9sbmQXQzTnr9d6koeJfC0hKscKdJO04LZpjzhDTDae0B7zSSljxZOHHWGEUJdea1MGrnXWZtnI/O32sG+rjWcudQ6/umlf4JrPPqZNHpPHEV80RNr/IFxkpN5DCmbVhKobwljy6dz/9n48aVdBzRtgiG/D2ofEYrCTto8rk48X1YpwhbEN+mpy3Z2xOQsmln9GeC6W4ujlAe60V2MQP6aIO0xqa7UI4wSOoP948n6PbdhritXyzK3gQAn5REYXKdJGi1bDnW6hrA8vVYFCTd/0vawYmlYFJkC9EHQ+Rmpvc0eEsCfrZ99OsU9kBiXzbRoLjrR0ATGHsvgXA==
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
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
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


