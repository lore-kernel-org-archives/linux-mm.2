Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64165606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=AIzGQocF
Received: by kanga.kvack.org (Postfix)
	id 9057A6B05BA; Tue,  3 Nov 2026 07:29:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DC0C6B05BB; Tue,  3 Nov 2026 07:29:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818B86B05BC; Tue,  3 Nov 2026 07:29:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC966B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:29:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0BAC803BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:28 +0000 (UTC)
X-FDA: 85393738416.20.F274370
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id D14C340008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:29:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AIzGQocF;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793708967;
	b=DZcHDiuzWOYnUimJjej/9cBqWrMNc0nPc/3bKdZkGELimci2YJrejlnrsJJubQjJPvIfk4
	1DrCZ+ZChw6FOubdJb9cyvFSltTxAflD2FO5KznvHTZ3aalENJOkQGBaPwAt8YY9TKmt5P
	kGGW2LKMKh2+t2zBolGaNrr9nvgKxkY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=AIzGQocF;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793708967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FP7kG4/RawLD0z06EWd0ekkozMQmyFz/TouOQGf11tc=;
	b=DnbbrXrOgt9ggyNvVmOj8P4eHxCOXOHr9YZi6MTmXv4Lf5iCluCieMfQLbFKRqOfUPdmZ2
	xyZNn5Wli0RsACPH8iVD+uCZhOVHiDEJBUcl9o3hZow+FYfwiu2DYOGrDdRtnX53ERyyX5
	ad9x/pIxLet+aKqHVxFpShPyflZOJ3w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793708961; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=FP7kG4/RawLD0z06EWd0ekkozMQmyFz/TouOQGf11tc=;
 b=AIzGQocFfgWdNoTakhQX2iAHKob9UPvw3QMcbq68VyAdWi6E25Tmf6ynmTo3xB6pAmH/25
 rtNA71csOKYn3tQRJ7uAolU5wnZ3/U1LlUyFZt24qucmB0OvVG+MPYdOKnHUTE2xGmpmnt
 5ZcMbwudaRME8thCbSHFkx5XiihwWDK5YUQokCGyGyzFE8kdGJrH+T99OpPk6lhXYGAqUX
 Dj+jd/Ki7nUasP9ODN5pODRvZmlA1jxm3kwVaQ7uvE/6BcVZaw8GxGJtCZO8zk/YBYyURx
 NQ1zsONrrDFO0wbP5aXQP9tFAgI5g2jtCpXGI+ErBsCOo5sCSZt1KroD6xRrpw==
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
X-Lms-Return-Path: <lba+26ae9d39e+f9da6e+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Tue,  3 Nov 2026 20:28:14 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Message-Id: <20261103122816.48037-2-lizhe.67@bytedance.com>
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 1/3] mm/mempolicy: factor weighted interleave state helpers
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: pui6jpupucimw6n3fpeee75scgjnacg3
X-Rspamd-Queue-Id: D14C340008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793708966-656833
X-HE-Meta: U2FsdGVkX190fkIotvd4Xwvk/IwK/WNjTjixP8F47Rp6dkgQMU6tpPzFjIHYJLaxF3I+MURaodM2Bn7JINFHRJmOFEzQzq7iNDaK3pa+8q0INUnuMQ1wORxZMoWbDiB6caMwWZ01sh/UfkniYw9094jjRfPCGCG0Xw9A6aeieJNRSXZkPapD0/RUFFivelgmgTCrJFHE6S75fhHbZwz6Di3YOjqMdr0/P/rqQj9j7aDrIQctrLu8UJnS3BSGzGEb3FlR8a4WzmITcZt5J3RxsL2f7/q0Op0dc9aJ8C3KWOBYIqAQpgi9oBHELOI3dS7W3a8CQRT8b+wmkpA5W/JeXstPH+Ko6pC7JqFoybWnx/bJjsPZdYxlQGoJ3R3ctxvtAPr7m9p8Nl1OIe5fmaIdoBYvfvpBHUblFNQq8NblpoUwMBaTrcKqpxGhaw/igsURX91gtofEeDVlf3YueBHGEcpfxwYaC6sm0TFgopA17sDUVe2X37BcqPDq8b9/YNTP+j4Kz5NKhwbwr8liH+4w+ytzJMbYHzotOm1LYDWJfmqdAFJ4wjPssNa6fH2splaku6HtWVBI3JQp+sIkJFcyUutyzV4uHkn4Fn8+8UpEvggfvLd4JoyeOHswXmMhHIbla8PxPm7sCDJrhrHmQvqwcHSbJzXgaaGw4OmmI8fb+1vPZeIi78Vm/TKPXqgXc8VgOe/NzEqAwzOFzJMSt4a5T+UdBVyH75uy2ZaX8j8/bbU2lqxdBEdvPy5jStj6CWCMTaS8S/wNsLMlTmp9Bxcid+DKesA2FLVDTkdr1MwbDQTC3nU+7X6/w7AXYTNeYysk7n+Q9cJ2RP2+S2PXYRN1PF7hG29uCfoJsTZxAZikq7+ywneRi05gvio2FLVH/pFhy5UWTmhfOnHGiIaPWzU9WjIjEqL40HsxnaFKS8bioj2r7RWbouYMjoPxGxj+Mw+aBpKHLSat60ep+Z4WT6O
 Lh7vo+gJ
 4d31LFtO2MTooNB4ts9wx/59LnQxKiz5glNMcsau4bR4Sn+cuJBWgnuTdEm0KIz9CfDqw5dk5+BHqSB9X4S9C4NiXOjcQQqivfkMWsFbaJXOGlHqyIrRLnSHtv7cMj8tTMDWlzUj77EXq4uuvScDA6Ww7l5pqFge+jhXfHoDQy6bFZNLEpkxhF/tkje7eClwHWeVr2DUO7X4MYdxoeStz7sHP+JdGuhtbMdjGd/uXSJkz9MucMCqgHDR5IN1uDAb9Y2wfk1nGZmaDlUziPaHXj450VBAUYRcWIszz3+EkM0wNvw+MLAQ+XyP8szNiua4mToAnH/lzhHYwKrTMGn4ywO9trY/hy6uBkBQUt2xcIiPogLNdta0Tf4qKNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Weighted interleave updates repeat the same allocation, default table
initialization, table copy and default table setup patterns in the sysfs
and auto-weighting paths.

Factor those pieces into small helpers so later changes can reuse one
state lifecycle for both the global table and cgroup-local override
tables. Keep the existing upstream wi_srcu retirement path unchanged.

No functional change is intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mempolicy.c | 54 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 22 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..fb9962302664 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -188,6 +188,30 @@ static void wi_state_retire(struct weighted_interleave_state *state)
 		call_srcu(&wi_srcu, &state->rcu, wi_state_free_rcu);
 }
 
+static struct weighted_interleave_state *wi_state_alloc(void)
+{
+	struct weighted_interleave_state *state;
+
+	return kzalloc_flex(*state, iw_table, nr_node_ids, GFP_KERNEL);
+}
+
+static void wi_state_init(struct weighted_interleave_state *state)
+{
+	for (int i = 0; i < nr_node_ids; i++)
+		state->iw_table[i] = 1;
+}
+
+#if defined(CONFIG_SYSFS) || defined(CONFIG_BPF_WEIGHTED_INTERLEAVE)
+static void wi_state_init_from(struct weighted_interleave_state *dst,
+			       struct weighted_interleave_state *src)
+{
+	if (src)
+		memcpy(dst->iw_table, src->iw_table, nr_node_ids * sizeof(u8));
+	else
+		wi_state_init(dst);
+}
+#endif
+
 static u8 get_il_weight(int node)
 {
 	struct weighted_interleave_state *state;
@@ -243,22 +267,17 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *old_bw, *new_bw;
 	unsigned int bw_val;
-	int i;
 
 	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
 	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
 	if (!new_bw)
 		return -ENOMEM;
 
-	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state) {
 		kfree(new_bw);
 		return -ENOMEM;
 	}
-	new_wi_state->mode_auto = true;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
-
 	/*
 	 * Update bandwidth info, even in manual mode. That way, when switching
 	 * to auto mode in the future, iw_table can be overwritten using
@@ -282,6 +301,8 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 	}
 
 	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
+	wi_state_init(new_wi_state);
+	new_wi_state->mode_auto = true;
 	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
 	rcu_assign_pointer(wi_state, new_wi_state);
 
@@ -3672,27 +3693,20 @@ static ssize_t node_store(struct kobject *kobj, struct kobj_attribute *attr,
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	struct iw_node_attr *node_attr;
 	u8 weight = 0;
-	int i;
 
 	node_attr = container_of(attr, struct iw_node_attr, kobj_attr);
 	if (count == 0 || sysfs_streq(buf, "") ||
 	    kstrtou8(buf, 0, &weight) || weight == 0)
 		return -EINVAL;
 
-	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state)
 		return -ENOMEM;
 
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
 					lockdep_is_held(&wi_state_lock));
-	if (old_wi_state) {
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					nr_node_ids * sizeof(u8));
-	} else {
-		for (i = 0; i < nr_node_ids; i++)
-			new_wi_state->iw_table[i] = 1;
-	}
+	wi_state_init_from(new_wi_state, old_wi_state);
 	new_wi_state->iw_table[node_attr->nid] = weight;
 	new_wi_state->mode_auto = false;
 
@@ -3723,16 +3737,13 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
 	unsigned int *bw;
 	bool input;
-	int i;
 
 	if (kstrtobool(buf, &input))
 		return -EINVAL;
 
-	new_wi_state = kzalloc_flex(*new_wi_state, iw_table, nr_node_ids);
+	new_wi_state = wi_state_alloc();
 	if (!new_wi_state)
 		return -ENOMEM;
-	for (i = 0; i < nr_node_ids; i++)
-		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
 	old_wi_state = rcu_dereference_protected(wi_state,
@@ -3745,9 +3756,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 	}
 
 	if (!input) {
-		if (old_wi_state)
-			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-						       nr_node_ids * sizeof(u8));
+		wi_state_init_from(new_wi_state, old_wi_state);
 		goto update_wi_state;
 	}
 
@@ -3758,6 +3767,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 		return -ENODEV;
 	}
 
+	wi_state_init(new_wi_state);
 	new_wi_state->mode_auto = true;
 	reduce_interleave_weights(bw, new_wi_state->iw_table);
 
-- 
2.20.1

