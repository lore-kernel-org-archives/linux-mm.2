Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC24606D81F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=Y7UZCyZj
Received: by kanga.kvack.org (Postfix)
	id 6BFAD6B05B1; Tue,  3 Nov 2026 07:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FA06B05B2; Tue,  3 Nov 2026 07:32:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586E26B05B3; Tue,  3 Nov 2026 07:32:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4256B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:32:35 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC314A7D7B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:32:34 +0000 (UTC)
X-FDA: 85393746228.17.FD0A3A9
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf18.hostedemail.com (Postfix) with ESMTP id CDA2D1C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:32:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y7UZCyZj;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793709153;
	b=7dS4ZZJSpYVDYbAc3FpAY+3aSSwT39kmj1+YMNO5OtWF4DTusEPPTauN2bV9p9oyezkYY4
	QeDFcRe3kVXsLWm9eea5srsh8xaXkDUUjRe2shJiS2uaTTzpRSiFYz2U3b3+1PpJkDhsSg
	dbvjz+fUMeRjiQ0f8to49OGDaoCSoBA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Y7UZCyZj;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793709153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x2ncG86rAs9pOnWEtcTfjniv2/ccRbZe8/nBUY3DZLo=;
	b=5hqZPex2+vXCEa0pYRAcq+w5Raa4mnSG+7fu0v2F7A8X8EnwLSU/4PLuqHAWmAMl6DBVkO
	Khg52p3iDHkwjm3L0o3MZkGbzk1PCrIWQF3WYtaeSSghkU8IYcel6e0Nahirouo5v3Cfdi
	PNxdofidVIgOB4NK0rCT1P9PfFfFncQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1793709147; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=x2ncG86rAs9pOnWEtcTfjniv2/ccRbZe8/nBUY3DZLo=;
 b=Y7UZCyZjRyqCvZIhBQOZ+OaQT+8AW2wR11H/WdPbRmW7HHKYsQKuUtiRktBQkBR7cBEUAy
 fs5zO5r1Wf0Hp775TZH17f0cyHfXe1K/v4EHX3uxW/unTk/4EShVzzVs2IT37THbAp1C/n
 QmGAHm4CuOw0LZN25pTooVaNibUcEF2YwRJ+S9ZEPXFDBzK0QtzN2PjLhiok2ANnlYQtYt
 eGmRZ94XZVkgh4wBM3fbYDWkD2ofNQr92wYX4OWgqEE2rUcxqvyrta/mWQSbGLbdYD3kOO
 ubG5ongpAav/ElFiE1oQX0D3A5UO9db2HcH88t76hTFju7IHpzUwjr5gPGFjeg==
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261103122816.48037-4-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20261103122816.48037-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <bpf@vger.kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH 3/3] mm/mempolicy: add BPF kfuncs for cgroup interleave weights
Date: Tue,  3 Nov 2026 20:28:16 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ae9d459+a7e146+kvack.org+lizhe.67@bytedance.com>
To: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <gourry@gourry.net>, 
	<ziy@nvidia.com>, <joshua.hahnjy@gmail.com>, 
	<ying.huang@linux.alibaba.com>, <ljs@kernel.org>, <liam@infradead.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20261103122816.48037-1-lizhe.67@bytedance.com>
X-Stat-Signature: et3hkbyrzo4inn5tnqarkybq19wobua4
X-Rspamd-Queue-Id: CDA2D1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793709151-765958
X-HE-Meta: U2FsdGVkX18HCcoBxE5ejsVHLT4aMHPDeqBUEuPervczFRjBnYVzEDx0buOOs+E8sladmhvC9MzDvliir8mRYWYpmA1KsLNCaGlzhPBJl/WVJ51dmJkckoMSpq9ROfgLfxTUakpD1Wd6sO75R7PnlhufPc2rbImnUhQsVz1ioOgeXn6XOGlE42EC4M2umsHwruK1VLNVqUl1CzelLakK0BpuTl5QRRi6SowAAGQ9FjhwOhtOok4a4bIxvoGMduqXvzLRQM4FgbTrSbLtIrYzX68GPmNmkyeyEYcMyf2yjG1OZs1lWiBLoenIuER72Wpf429njVh/EgbzcazgIMC5s4O+C8sSkPhr+vlxE0273vc4uxrQjIPTiPhhpufWwt+8C4G2vZhVAysIPrROD+0Tau2ncviLkftPMZWeCy6udkqF9nMML0l24sstia1ZTA2Jao8Sa9w+j1VFIuMijvx7ZKOvDJ70BeKgLFLmQOv306WVeEL997awRRAj7hdUOXcdVz25uh4Gcg1rmvoMVPJaDrJ6Pv80mvPU7MUH6BUu4UbTAUTaFWpa1gUVrYw1S+h7O34leh4Tc2TPTjw2oAcXEiFip1t+QaD3mtXNmy8HUzhUDDk7iV4leQmExzw6CQk+O7CdkFXVZuGqYq1TGlFsVIhM2XM8d1UY+KHzi0Co7BanAgOmWQi/GHwmqb/DxwiQvn/JrbcQn6VC2MVBpQfRQUqDv+Oi6sv/9fJLl7FMKw2ZfahE8e2VQLcAasJGoo73aFxWSz2R8CZWOTmNyLebV1CHMtTxzhTGfkcejy3i+/OloPdivdwT+N9V5Io8AWbvAvwLl/DXRi6fRxOhQ5KCegTvy13l4/9pTttYxrC6PL/n6nxNdHHxRYi5bDWuaxU8uwJwmldTHtbaBK8Ty0MsEUuyV4iLM1PlQn9yu+GXeZCSFX/tZdbZKJrJhCFTZ2E7syq0LB/2mFx5+OivCXt
 xn9N3vgA
 BNI89xLoOM1ZgfKY54DqONY6BLyGuZ40VZ7BGegjdOqfJGVih2PQkGTfCr3VOe2XJQGkENZf4F0FUIS6Ph9i/G6Jd2ZxdDivkERadFEOZgTlClMswt6ymxvNSVrgnoj9N7T5OCjtC2qi/CrLxFYBMsVNJAxAEsWPlrNmG81sN8BGrUiBvAwWeuWKhFu6ZGPiNgju5s+lcbsGr58lT7J6OCWA/Ne3GTrfSjhiB1eIIHaQq8uUAS9fum9h5FH2Ug7azIR6TMFyM9K0U2yK1VITJfzcutARtyPAKlKxoB6PQ3lW2JDQ0zw7Y+aUcs417FY9xK7cPBVou9MlY+Ok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Expose bpf_wi_set_weight(), bpf_wi_clear_weights(), and
bpf_wi_get_weight() as a BPF syscall control plane for cgroup
weighted-interleave overrides. The kfuncs let a privileged program
update one node weight, remove an override, or read the effective
weight.

All three kfuncs are sleepable, require CAP_SYS_ADMIN in the initial
user namespace, and accept only cgroup ids from the default cgroup-v2
hierarchy. Updates materialize a complete weight table and publish it
with RCU.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mempolicy.c | 201 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 200 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 751a5e90a4e1..7521542712cb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -78,6 +78,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/mempolicy.h>
+#include <linux/capability.h>
+#include <linux/bpf.h>
 #include <linux/pagewalk.h>
 #include <linux/highmem.h>
 #include <linux/hugetlb.h>
@@ -103,6 +105,7 @@
 #include <linux/proc_fs.h>
 #include <linux/memory-tiers.h>
 #include <linux/migrate.h>
+#include <linux/module.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/security.h>
@@ -245,7 +248,7 @@ static struct weighted_interleave_state *wi_task_state_rcu(void)
 	return NULL;
 }
 
-void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+static void wi_cgroup_clear_weights(struct cgroup *cgrp)
 {
 	struct weighted_interleave_state *old_wi_state;
 
@@ -260,6 +263,202 @@ void weighted_interleave_cgroup_free(struct cgroup *cgrp)
 
 	wi_state_retire(old_wi_state);
 }
+
+void weighted_interleave_cgroup_free(struct cgroup *cgrp)
+{
+	wi_cgroup_clear_weights(cgrp);
+}
+
+static struct weighted_interleave_state *
+wi_effective_state_cgroup_rcu(struct cgroup *cgrp)
+{
+	struct weighted_interleave_state *state;
+
+	state = wi_cgroup_state_rcu(cgrp);
+	if (state)
+		return state;
+	return rcu_dereference(wi_state);
+}
+
+static void wi_cgroup_set_state(struct cgroup *cgrp,
+				struct weighted_interleave_state *new_wi_state,
+				u32 nid, u8 weight)
+{
+	struct weighted_interleave_state *old_wi_state;
+
+	mutex_lock(&wi_cgroup_lock);
+	old_wi_state = rcu_dereference_protected(cgrp->wi_state,
+						 lockdep_is_held(&wi_cgroup_lock));
+	rcu_read_lock();
+	wi_state_init_from(new_wi_state, wi_effective_state_cgroup_rcu(cgrp));
+	rcu_read_unlock();
+
+	new_wi_state->mode_auto = false;
+	new_wi_state->iw_table[nid] = weight;
+	rcu_assign_pointer(cgrp->wi_state, new_wi_state);
+	if (!old_wi_state)
+		static_branch_inc(&wi_cgroup_weights_set);
+	mutex_unlock(&wi_cgroup_lock);
+
+	wi_state_retire(old_wi_state);
+}
+
+static bool wi_valid_nid(u32 nid)
+{
+	return nid < nr_node_ids && node_state(nid, N_MEMORY);
+}
+
+static int wi_cgroup_get(u64 cgid, struct cgroup **cgrpp)
+{
+	struct cgroup *cgrp;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	if (!cgroup_on_dfl(cgrp)) {
+		cgroup_put(cgrp);
+		return -ENOENT;
+	}
+
+	*cgrpp = cgrp;
+	return 0;
+}
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_wi_set_weight - Set one weighted-interleave node weight for a cgroup.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ * @nid: memory NUMA node id to update
+ * @weight: new weight in range [1, 255]
+ *
+ * The first update creates an explicit override for @cgid by copying the
+ * nearest ancestor override, or the system-wide weighted-interleave weights
+ * if no ancestor has one. Nodes not named by the first update become local
+ * values in that table and do not keep tracking ancestor changes. Later
+ * updates modify the cgroup-local table. The override affects new
+ * MPOL_WEIGHTED_INTERLEAVE allocations made by tasks in the cgroup and
+ * descendants that do not have a nearer override.
+ *
+ * Return: 0 on success, -EINVAL for an invalid node or weight, -ENOENT
+ * when @cgid does not name a cgroup in the default cgroup-v2 hierarchy,
+ * -EPERM for insufficient privilege, or -ENOMEM when the override table
+ * cannot be allocated.
+ */
+__bpf_kfunc int bpf_wi_set_weight(u64 cgid, u32 nid, u32 weight)
+{
+	struct weighted_interleave_state *new_wi_state;
+	struct cgroup *cgrp;
+	int ret;
+
+	if (!wi_valid_nid(nid) || weight == 0 || weight > U8_MAX)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	new_wi_state = wi_state_alloc();
+	if (!new_wi_state)
+		return -ENOMEM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret) {
+		kfree(new_wi_state);
+		return ret;
+	}
+
+	wi_cgroup_set_state(cgrp, new_wi_state, nid, weight);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_wi_clear_weights - Remove a cgroup weighted-interleave override.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ *
+ * After clearing, the cgroup inherits the nearest ancestor override, or the
+ * system-wide weighted-interleave weights if no ancestor has an override.
+ *
+ * Return: 0 on success, -ENOENT when @cgid does not name a cgroup in
+ * the default cgroup-v2 hierarchy, or -EPERM for insufficient
+ * privilege.
+ */
+__bpf_kfunc int bpf_wi_clear_weights(u64 cgid)
+{
+	struct cgroup *cgrp;
+	int ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret)
+		return ret;
+
+	wi_cgroup_clear_weights(cgrp);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_wi_get_weight - Read the effective weighted-interleave node weight.
+ * @cgid: cgroup id that must name a cgroup in default cgroup-v2 hierarchy
+ * @nid: memory NUMA node id to query
+ *
+ * Return: the effective weight, -EINVAL for an invalid node, -ENOENT when
+ * @cgid does not name a cgroup in the default cgroup-v2 hierarchy, or
+ * -EPERM for insufficient privilege.
+ */
+__bpf_kfunc s64 bpf_wi_get_weight(u64 cgid, u32 nid)
+{
+	struct weighted_interleave_state *state;
+	struct cgroup *cgrp;
+	s64 weight;
+	int ret;
+
+	if (!wi_valid_nid(nid))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = wi_cgroup_get(cgid, &cgrp);
+	if (ret)
+		return ret;
+
+	rcu_read_lock();
+	state = wi_effective_state_cgroup_rcu(cgrp);
+	weight = wi_state_weight(state, nid);
+	rcu_read_unlock();
+
+	cgroup_put(cgrp);
+	return weight;
+}
+
+__bpf_kfunc_end_defs();
+
+__ADDRESSABLE(bpf_wi_set_weight)
+__ADDRESSABLE(bpf_wi_clear_weights)
+__ADDRESSABLE(bpf_wi_get_weight)
+
+BTF_KFUNCS_START(wi_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_wi_set_weight, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_wi_clear_weights, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_wi_get_weight, KF_SLEEPABLE)
+BTF_KFUNCS_END(wi_kfunc_ids)
+
+static const struct btf_kfunc_id_set wi_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &wi_kfunc_ids,
+};
+
+static int __init wi_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					 &wi_kfunc_set);
+}
+late_initcall(wi_kfunc_init);
 #else
 static struct weighted_interleave_state *wi_task_state_rcu(void)
 {
-- 
2.20.1

