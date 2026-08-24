Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C4BC5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 02:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E237B6B0095; Sun, 23 Aug 2026 22:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFACF6B009B; Sun, 23 Aug 2026 22:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA156B009D; Sun, 23 Aug 2026 22:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2F6B6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 22:41:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 057BD80423
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:41:24 +0000 (UTC)
X-FDA: 85134611688.06.745392B
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4144C20003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 02:41:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LPCrfO2j;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787539282;
	b=v8L/25JwoPpUitSUTKvTWlNwphxSDKmLONkPWOq0s305iAJhbEsdT7j5bIep8wBBYBdpNE
	s+ifHVaRaJQ6muiNI3xsgxhzV4sX8LYJywUtS26oJ2ryllRz+iYq2DAhwxO2ErvGMa3QU1
	UmH2ejZDZKPh6/NwewpUcKWdbdMt/r8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LPCrfO2j;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787539282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMgUDKT62DeKeqlqvHdFsR2bI0aE5RkYkhomGJfRr0k=;
	b=KRsxyQRl0BwR3dbEL1tr92OiKY07V/5qyUiBXjr9CTQKNVEENyFs/5zz25glMDsuQCr7Vz
	rb1C9oojdNe4eU1ez0TroalcMSJxM2xg34iiALONclQXCNKUv0jO2NPwSSwZZUb4/mmg3h
	hdoSKJ+vivoNYWsu3qQqn2XWvn8s6Ds=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c16ac21acso19546671cf.0
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 19:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787539281; x=1788144081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zMgUDKT62DeKeqlqvHdFsR2bI0aE5RkYkhomGJfRr0k=;
        b=LPCrfO2jV7r1kEBj3DQ1Uqz1ivglVkL3Z5IMwE38FwPtTYKCp3/06Ne52FCWyIGwBV
         Gf2L8jvL5zRDMQXqgBfn8EIdElFZ73brjAHI6uYNnHkWsXWQEa095If4GAU85empfPnq
         ixif6RoKBoCJ6I+dgBjB9MQUHwpR3vcFtn04eYbfcCFyhvVv+BzH8dopsS8v3vM9Ht3i
         FeVZGvMyQ6P+aJDTW3v41iNnEc+nTsJqmLPPIuGbfq0RgK5IMIwONYIlYVXxH36RG2cV
         hYHZi13Obnc8xz56BpMnIOrnZZoj5S8HSungPCVNXYoC9acv7K9Z1Fzma/Im0AmlTd41
         xzPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787539281; x=1788144081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zMgUDKT62DeKeqlqvHdFsR2bI0aE5RkYkhomGJfRr0k=;
        b=ZtLUY/S1yab1MeBv7VJoXj+YRe9X2JxAG+kiHJqEr2bDs8vYmS9x581kf/N7/YydOR
         vjYY8N2L4fniRJ8e0OJbf9tIjNN+spYQnLc9nq7XhzP1m/kDdY4+QpWOHa4v/txtRA8n
         ZxZlvA0J0KHZFPKpzCAxuwduKFtfhkmPH8LDFe8dAQ23+2Jvcqp1GdObxjlm3TwcL8Yi
         5ZiIB8xhNWcXQ5qcIsiXsaej9BrfZfw4sIEc0HjcBveBQk3Y3pLbeyP+Yz68VYr03418
         hMP/sWrCxBVsL4P/qzLAVNYCV95Z6f3AvC+YYzOVbqilKUl8SwHlZ7Y4rLh00AlrqUk5
         h/kA==
X-Gm-Message-State: AFuF++l78+296Uy/LrcW7dnVrt3iafOQac16xFhGsHEdLxj+cKDDV64z
	gAb4HMPXr5T4cCz0KvzjK2X4MqRnfm4q2014144bn3ZvN39LjUfo3YnGZj9SV5U055e720YOGlT
	j+tKlAsM=
X-Gm-Gg: AR+sD11KYLHv5WuzmYNnqdyNGksbNtiZBEc+aWuKdH4MjgR2Ht9YmvUUfkZqv/YadMG
	4XxmMaUU2pJhAokVuaujL9gHyGeul0e042GxBVJthzpwt0wOeKX5Kz8/d8QZdTvsz+5otRniDty
	bVt0RIKxdf81bhgYDkKAfSUCauzDu8uQe5pjbIeGtsdWR2lACcnKtKWDAM4f4ULFtdzOPYQvACt
	xXaD6Cr8r/7zIIeppU3kvHETdeNHJwRqC+kEzn2p403pL13CcTW7XPFHous28ciR1pVdMBxbpPL
	lLrlZxya2KaCa2TEE6jg23iwyvXhcLAX44UNxZxvsAefBgPTrRce7tLLd5YeLiou67vmCBJnvTo
	1i7azvzyhHyr28QxNQlBOZtPjvFkRtzmcQZ/ZlpuIkBMYcvwiSk42T8myKx5FppgAhDNRHwafoZ
	6eJxNUSDJ3O+5hHvRnxCrr1UrkInfKr3gfKSeQUFa/45jBC8yI0fW7ZFuqYAvyi2w5+Tv8nBHWe
	IfGmyM0VrTzB6tfwHBZIv6Hs4b7vUXCpS9WMX0XkHnIeKznbA==
X-Received: by 2002:ac8:584f:0:b0:52d:92c1:b7c2 with SMTP id d75a77b69052e-52df56eff97mr219376221cf.1.1787539281264;
        Sun, 23 Aug 2026 19:41:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c936183d0sm50926846d6.22.2026.08.23.19.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 19:41:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	edumazet@google.com
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	stable@vger.kernel.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH] mm/mempolicy: refcount the weighted interleave state instead of copying it
Date: Sun, 23 Aug 2026 22:41:17 -0400
Message-ID: <20260824024117.1755899-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
References: <20260821104043.f692421fec915c0c5bc1fbe6@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4144C20003
X-Stat-Signature: wpce4jcnk38s3meusuhgb91mok6feqhq
X-HE-Tag: 1787539282-988088
X-HE-Meta: U2FsdGVkX1/XKTWYElK1xTas/hA+TKGA7KlmhDkG4GfwLTidpeBIKeEL4unbMJl4ug3PKR/KmZLUiU0gXzoLC7uCNqzHqdGayRmWwB9QhQoOx8i4AG/rJTt7G5w059IT6xXhfpDRsPY0NvgjmPJgljLWP6JgvBXLP6jsjDVz2TGgaz70QKQKPZ10Dy7GN1py+yUmYc2C13ezGAw64/mCPFBf/1uTvj/1Lf8GvX2xs8MHR2gUv3DgYbU81FXHyqR1vdg8YapqgvIgeumJNslCJjK0W32SEjO835H2OfbjcNHFz9WqUHgI27eMPRbbInVMzA2GQHQIROFffvnNNBzB9PwFfSe21SFQrkLaeMF4H3nBD+niF7onPv/yd5Y6hD1TTZna6zekk+MolOPZmfAAUVT9RZs+eYCDcUkE3VqgxkJGDzcg8lUh2ozngVyKOtEoA1cBcq6LhGHqW5fLBRESFcW/mVODYGxRbg6Z8i52PFf+pd7420P0bQDn4YZ87dNzQCklcwMZJUqTPYDCYc7P/JrnKtFvlzGsfA6jd7pTFP9ZbF8uNUtuAvgPxJJLoYUZc/WVSq+kL2pq5OPXInXYOKaUCais6LtRdJpvLbsXBi0IKB8OzZ1VUqY2mLPIhL7SZ/DveD/tFm2RsRNNseiYLpbOKBv03r5jJEqvmT4Ifk8LOa16lW10mmYm59uxtPpE8uvjaOjft2UfRRJDaDG+UbLxWAowpDMql8aIptvjZR678qCj8iJ/s9g62tKiVw8Rw706e57G8+8kaN4IoQYlKDDaMbzra5SgMa/9yp5hGB8zpRgWHHhZ3E/ktw+BOQVkZSZQudOpj5JEyhEF7f0g5KhiYnJ3U1+q3aoJzvi+4daoLxNkAmODjvyDICeBFBjavG3rh77PaWPkUuiHy1AuJgsZRlfCjIk1LBv2JP8dlPcwEdD1YBw9u823/N4Or+N0qfHs3/3NMTeKoMkGiaL
 MzR5lkiH
 xlBbWLDZHrams7YwHq2tDMLKQS/3VQCHnb0ddehrXApzzlWk/U3RMwvZm5lK3LNbcqZ9+sPWEmEXm3z8dPBkyWlC7rVI+9uvsedu+W4ZybgeetFgRwfyH+n4CPlzPHUf28YzxsjpFK6KyXFR5zGWzrOvHJcyzoxTZ8sPWLRHFXWozHT4+jxeKqEDZcGqV3FS51+TzJ7V55HAgCE12Cf39A/mqVrxDrGAgbbLB7mJInTmVwnFY/Y5a+8JD8ZhC/V4HFG4Ok76Eve6zBdhq5fkjMu7+VF84yWvgiqERE9p5JNjd7nUm0PoYgg6/dyBZ/i7+qjAXVWEnTZVG6reo9SinIYu4FMZgD/Ro8rghvxDe+nDnwWfuvIsOV/lbum14+vtx+cigSjdfvsvydkf1EXH9zD+DQrQB0LIsDGt4RG175q/sUD/hZQEtWXpqjkZlHW4mbzgxZ4x7Z/K+tMcUFuq+IEgV7QGTJmoODE6LOFCOJC9+yt+P7kKRX1RTXkLEfKvfs0QnlqXhE+4GtoZWTKQOsc1QnGTUnM6UhPlO3ARZ+1MptfeQh/rWoU6W4XQxzSr+JDOz27DFFHD6uc6zl6/2/9T05qjxqZn0Ct9o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_weighted_interleave() copies iw_table into a scratch
array on every call to get the table outside of RCU.

Refcount the weighted interleave state and cleanup with kfree_rcu().
Refcount and iw_table get their own cachelines to prevent false sharing.

This drops a kzalloc/memcpy/kfree per call and deals with a bug induced
by the scratch array's hardcoded GFP_KERNEL and the partial allocation it
returned when that failed.

Tested in VM (KASAN, PROVE_LOCKING and DEBUG_OBJECTS_RCU_HEAD) with a
udelay() injected between the rcu_dereference() and the refcount_inc
to stress the race. Six concurrent bulk allocators racing four threads
writing the sysfs weights took the retry path 2536 times with no splat,
and the published state was back to a count of one at rest.

Replacing the kfree_rcu() with a bare kfree() in that same test reports
a use-after-free immediately, so the test does exercise what the deferred
free protects.

Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
Cc: stable@vger.kernel.org
Reported-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/all/20260821170407.3721004-1-edumazet@google.com/
Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---

Hi Andrew - please consider this instead.

 mm/mempolicy.c | 76 ++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..4a3722c63b31 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -112,6 +112,7 @@
 #include <linux/printk.h>
 #include <linux/leafops.h>
 #include <linux/gcd.h>
+#include <linux/refcount.h>
 
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
@@ -156,7 +157,9 @@ static const int weightiness = 32;
  */
 struct weighted_interleave_state {
 	bool mode_auto;
-	u8 iw_table[];
+	refcount_t refcnt;
+	struct rcu_head rcu;
+	u8 iw_table[] ____cacheline_aligned_in_smp;
 };
 static struct weighted_interleave_state __rcu *wi_state;
 static unsigned int *node_bw_table;
@@ -167,6 +170,27 @@ static unsigned int *node_bw_table;
  */
 static DEFINE_MUTEX(wi_state_lock);
 
+/* Allow sleeping readers to pin the state to avoid taking copies */
+static struct weighted_interleave_state *wi_state_get(void)
+{
+	struct weighted_interleave_state *state;
+
+	rcu_read_lock();
+	while ((state = rcu_dereference(wi_state))) {
+		if (refcount_inc_not_zero(&state->refcnt))
+			break;
+	}
+	rcu_read_unlock();
+
+	return state;
+}
+
+static void wi_state_put(struct weighted_interleave_state *state)
+{
+	if (state && refcount_dec_and_test(&state->refcnt))
+		kfree_rcu(state, rcu);
+}
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -235,6 +259,7 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 		return -ENOMEM;
 	}
 	new_wi_state->mode_auto = true;
+	refcount_set(&new_wi_state->refcnt, 1);
 	for (i = 0; i < nr_node_ids; i++)
 		new_wi_state->iw_table[i] = 1;
 
@@ -265,10 +290,7 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	rcu_assign_pointer(wi_state, new_wi_state);
 
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_put(old_wi_state);
 out:
 	kfree(old_bw);
 	return 0;
@@ -2632,7 +2654,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	unsigned long nr_allocated = 0;
 	unsigned long rounds;
 	unsigned long node_pages, delta;
-	u8 *weights, weight;
+	u8 *table, weight;
 	unsigned int weight_total = 0;
 	unsigned long rem_pages = nr_pages;
 	nodemask_t nodes;
@@ -2676,25 +2698,12 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	me->il_weight = 0;
 	prev_node = node;
 
-	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
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
+	state = wi_state_get();
+	table = state ? state->iw_table : NULL;
 
 	/* calculate total, detect system default usage */
 	for_each_node_mask(node, nodes)
-		weight_total += weights[node];
+		weight_total += table ? table[node] : 1;
 
 	/*
 	 * Calculate rounds/partial rounds to minimize __alloc_pages_bulk calls.
@@ -2706,10 +2715,10 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
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
@@ -2735,7 +2744,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	}
 	me->il_prev = resume_node;
 	me->il_weight = resume_weight;
-	kfree(weights);
+	wi_state_put(state);
 	return total_allocated;
 }
 
@@ -3644,6 +3653,7 @@ static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
 	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
 	if (!new_wi_state)
 		return -ENOMEM;
+	refcount_set(&new_wi_state->refcnt, 1);
 
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
@@ -3660,10 +3670,7 @@ static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
 
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_put(old_wi_state);
 	return count;
 }
 
@@ -3696,6 +3703,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
 	if (!new_wi_state)
 		return -ENOMEM;
+	refcount_set(&new_wi_state->refcnt, 1);
 	for (i = 0; i < nr_node_ids; i++)
 		new_wi_state->iw_table[i] = 1;
 
@@ -3728,10 +3736,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 update_wi_state:
 	rcu_assign_pointer(wi_state, new_wi_state);
 	mutex_unlock(&wi_state_lock);
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_put(old_wi_state);
 	return count;
 }
 
@@ -3775,10 +3780,7 @@ static void wi_state_free(void)
 	rcu_assign_pointer(wi_state, NULL);
 	mutex_unlock(&wi_state_lock);
 
-	if (old_wi_state) {
-		synchronize_rcu();
-		kfree(old_wi_state);
-	}
+	wi_state_put(old_wi_state);
 }
 
 static struct kobj_attribute wi_auto_attr =
-- 
2.55.0


