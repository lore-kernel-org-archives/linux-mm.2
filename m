Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B42CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2188E0051; Mon, 18 Aug 2025 13:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1D48E0013; Mon, 18 Aug 2025 13:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642AF8E0051; Mon, 18 Aug 2025 13:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43A7A8E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 179871608E6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:36 +0000 (UTC)
X-FDA: 83790497112.15.8BD6CB5
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B998100007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJ0SHZLm;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/YrYUzXccRuZ9yFhf36EzBvX3yiPzvgrHin8+im7U8c=;
	b=Ab7MmiFxc9EwfmQeej2Tlobc1MIL3YMHhZ+0IEdlNgRU7acSs950UagyrG4LzjtDgmhAlH
	4JecGhRxMiIfn0gsn9NdQrM5+H68u8yTI5tMhmWP5w9CL+s9A3ydC37Z6UmhCbe7dJttTs
	BmCGqlRsLpzJ6Mvg3UylqQ2/8EUBA28=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZJ0SHZLm;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536554; a=rsa-sha256;
	cv=none;
	b=zQ/fUK1l2m18dggafRVy+6WQZDpJD9RiUBRT763VtbcWzrbl+nXe7hd0Q91w6+npruGdtE
	wTTCfbOA6bsayL7P2Qgu6dxTN/zwJ49er1U/KW98vqzJkwqzFRv6RK63h7JvRedOWomX6F
	o0f4CJIf0DhYqsG1eRNjHg332gtG4Bg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/YrYUzXccRuZ9yFhf36EzBvX3yiPzvgrHin8+im7U8c=;
	b=ZJ0SHZLmHc8edLK5ZYYB4wbYZfDWJcfd2/Tf3z0l1o5HxRXQSbxTpe09chOrUd8ci7phP+
	ieVgN4zISNFQN8Jh/sSklBbnBlw8SL9MLoPvSYkPnbGeNrLInaafU8anGtjdp58uCaIjxx
	xCRExOHuT7oMdQG9t4IXTVWnQQul9mE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 12/14] sched: psi: implement psi trigger handling using bpf
Date: Mon, 18 Aug 2025 10:01:34 -0700
Message-ID: <20250818170136.209169-13-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: b7rrdk9r6brt64o7phf5156fse9fcp1y
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B998100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755536553-660787
X-HE-Meta: U2FsdGVkX18satpAhoLJ2OJR4ug6G9Lu+tabyPSUYWEoUhMfg5hxVamqillnc3QxDHCKnrs6drRG1ofLcQDuvTktulQdqvTKU2hHc+D56+QcTy5s8CWxtJ2btKbEtgaq8xKzshUr9GUYpsI5Hsp4wyfgH7EuXRw7LtxbImuFaJwU2DEQ7fuURXL6jxTYnvRz7DLYuZdGqLQ/kTSugLJTm5XWE5bO4Hg5MNyLZAn1vJ6hzgAsnN0PmauDOCuCMq3ICCIUg2TnP1vCvgpD1e9XiQ3TWce/HDL6e+uhoWmmBc+SsBpAVeLLmogewbm/PFaQmHtxSZbt5fe6+w3dQgiyvTujeFiGlbViEgZDrX+k6WawbJj06XJzbmYcEOKAAbkz20WiqjbadFSn9i0eg/35wJhbGuyAdw5EXGT5LJZIqWEiMF0zWOtDEVkskzc57LN/wz+AM5zlEXHjTrEdGj/TE7yRfvQZOV3bNxgepbyCX8eIiLcE2HGbaNv5A18W5L3b7zHoWjEwVAHa/tnoanB064Tl25JaLTvZgusRwM3a8opo+tMsSCj7vmPbEkKG4SKbF0z383RysRBpxVW5lHtbDbfx+My+G7tAqJtfDBFsubUR+WLeyMGeKtBOjX23OaoH6rFnwFRBdUHjehLsXIF0EL6Vj/2KAN54VhF7nhigosxuwD7Zzg3T53+TWMmSMUwlyC8kdeYTplsuzTsHWu5Fwx6lzWRRoF3jaUtzLdVFilohe5wOxobYETUX8M7aiw3Kj9qr19LCZ6s4YJuu3YZTg9Ya8Y52BD+nstIO2lV8mjBVwdwcq+JYeI93WCavDQ0kd+Mi1fW+pu63AKaw7bkTIzvg+zvuqG9SStxPhTgTVN1qn6iI+ro15Sig6O1/zvRPdRcyug+AL9xvqWxKmIKYDgPcmheEG3ajmUOHmGLc/EhI81OlHz+pRTRtO/yiA5qdKes99MZ2utO8GXXYH/U
 cnHVK2KG
 UDfS+DSEmLtShoT5cGxWdZwb+8oJVyaEJEHRYrcxDECutxVsurVvS1gNEqj1v2U4YJCL/1j4JGEz/OQxQQHOSK4xEwu7c/RdYd+VeiRB0rL1UMLlyL4za4cL25G9DSpgLxTGImx9KyXqYr0K7AGB2o3Booyv9S/zzW69IHrlT4qp2SDI+QVM1z8v1EsmWW/BuMuLJJWnxeMrpXyxtif6jP4V+gaT45I+T/qXnQI8cdnj6qOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch implements a bpf struct ops-based mechanism to create
psi triggers, attach them to cgroups or system wide and handle
psi events in bpf.

The struct ops provides 3 callbacks:
  - init() called once at load, handy for creating psi triggers
  - handle_psi_event() called every time a psi trigger fires
  - handle_cgroup_free() called if a cgroup with an attached
    trigger is being freed

A single struct ops can create a number of psi triggers, both
cgroup-scoped and system-wide.

All 3 struct ops callbacks can be sleepable. handle_psi_event()
handlers are executed using a separate workqueue, so it won't
affect the latency of other psi triggers.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf_psi.h      |  71 ++++++++++
 include/linux/psi_types.h    |  43 +++++-
 kernel/sched/bpf_psi.c       | 253 +++++++++++++++++++++++++++++++++++
 kernel/sched/build_utility.c |   4 +
 kernel/sched/psi.c           |  49 +++++--
 5 files changed, 408 insertions(+), 12 deletions(-)
 create mode 100644 include/linux/bpf_psi.h
 create mode 100644 kernel/sched/bpf_psi.c

diff --git a/include/linux/bpf_psi.h b/include/linux/bpf_psi.h
new file mode 100644
index 000000000000..826ab89ac11c
--- /dev/null
+++ b/include/linux/bpf_psi.h
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __BPF_PSI_H
+#define __BPF_PSI_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/srcu.h>
+#include <linux/psi_types.h>
+
+struct cgroup;
+struct bpf_psi;
+struct psi_trigger;
+struct psi_trigger_params;
+
+#define BPF_PSI_FULL 0x80000000
+
+struct bpf_psi_ops {
+	/**
+	 * @init: Initialization callback, suited for creating psi triggers.
+	 * @bpf_psi: bpf_psi pointer, can be passed to bpf_psi_create_trigger().
+	 *
+	 * A non-0 return value means the initialization has been failed.
+	 */
+	int (*init)(struct bpf_psi *bpf_psi);
+
+	/**
+	 * @handle_psi_event: PSI event callback
+	 * @t: psi_trigger pointer
+	 */
+	void (*handle_psi_event)(struct psi_trigger *t);
+
+	/**
+	 * @handle_cgroup_free: Cgroup free callback
+	 * @cgroup_id: Id of freed cgroup
+	 *
+	 * Called every time a cgroup with an attached bpf psi trigger is freed.
+	 * No psi events can be raised after handle_cgroup_free().
+	 */
+	void (*handle_cgroup_free)(u64 cgroup_id);
+
+	/* private */
+	struct bpf_psi *bpf_psi;
+};
+
+struct bpf_psi {
+	spinlock_t lock;
+	struct list_head triggers;
+	struct bpf_psi_ops *ops;
+	struct srcu_struct srcu;
+};
+
+#ifdef CONFIG_BPF_SYSCALL
+void bpf_psi_add_trigger(struct psi_trigger *t,
+			 const struct psi_trigger_params *params);
+void bpf_psi_remove_trigger(struct psi_trigger *t);
+void bpf_psi_handle_event(struct psi_trigger *t);
+#ifdef CONFIG_CGROUPS
+void bpf_psi_cgroup_free(struct cgroup *cgroup);
+#endif
+
+#else /* CONFIG_BPF_SYSCALL */
+static inline void bpf_psi_add_trigger(struct psi_trigger *t,
+			const struct psi_trigger_params *params) {}
+static inline void bpf_psi_remove_trigger(struct psi_trigger *t) {}
+static inline void bpf_psi_handle_event(struct psi_trigger *t) {}
+static inline void bpf_psi_cgroup_free(struct cgroup *cgroup) {}
+
+#endif /* CONFIG_BPF_SYSCALL */
+
+#endif /* __BPF_PSI_H */
diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index cea54121d9b9..f695cc34cfd4 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -124,6 +124,7 @@ struct psi_window {
 enum psi_trigger_type {
 	PSI_SYSTEM,
 	PSI_CGROUP,
+	PSI_BPF,
 };
 
 struct psi_trigger_params {
@@ -145,8 +146,15 @@ struct psi_trigger_params {
 	/* Privileged triggers are treated differently */
 	bool privileged;
 
-	/* Link to kernfs open file, only for PSI_CGROUP */
-	struct kernfs_open_file *of;
+	union {
+		/* Link to kernfs open file, only for PSI_CGROUP */
+		struct kernfs_open_file *of;
+
+#ifdef CONFIG_BPF_SYSCALL
+		/* Link to bpf_psi structure, only for BPF_PSI */
+		struct bpf_psi *bpf_psi;
+#endif
+	};
 };
 
 struct psi_trigger {
@@ -188,6 +196,31 @@ struct psi_trigger {
 
 	/* Trigger type - PSI_AVGS for unprivileged, PSI_POLL for RT */
 	enum psi_aggregators aggregator;
+
+#ifdef CONFIG_BPF_SYSCALL
+	/* Fields specific to PSI_BPF triggers */
+
+	/* Bpf psi structure for events handling */
+	struct bpf_psi *bpf_psi;
+
+	/* List node inside bpf_psi->triggers list */
+	struct list_head bpf_psi_node;
+
+	/* List node inside group->bpf_triggers list */
+	struct list_head bpf_group_node;
+
+	/* Work structure, used to execute event handlers */
+	struct work_struct bpf_work;
+
+	/*
+	 * Whether the trigger is being pinned in memory.
+	 * Protected by group->bpf_triggers_lock.
+	 */
+	bool pinned;
+
+	/* Cgroup Id */
+	u64 cgroup_id;
+#endif
 };
 
 struct psi_group {
@@ -236,6 +269,12 @@ struct psi_group {
 	u64 rtpoll_total[NR_PSI_STATES - 1];
 	u64 rtpoll_next_update;
 	u64 rtpoll_until;
+
+#ifdef CONFIG_BPF_SYSCALL
+	/* List of triggers owned by bpf and corresponding lock */
+	spinlock_t bpf_triggers_lock;
+	struct list_head bpf_triggers;
+#endif
 };
 
 #else /* CONFIG_PSI */
diff --git a/kernel/sched/bpf_psi.c b/kernel/sched/bpf_psi.c
new file mode 100644
index 000000000000..2ea9d7276b21
--- /dev/null
+++ b/kernel/sched/bpf_psi.c
@@ -0,0 +1,253 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * BPF PSI event handlers
+ *
+ * Author: Roman Gushchin <roman.gushchin@linux.dev>
+ */
+
+#include <linux/bpf_psi.h>
+#include <linux/cgroup-defs.h>
+
+static struct workqueue_struct *bpf_psi_wq;
+
+static struct bpf_psi *bpf_psi_create(struct bpf_psi_ops *ops)
+{
+	struct bpf_psi *bpf_psi;
+
+	bpf_psi = kzalloc(sizeof(*bpf_psi), GFP_KERNEL);
+	if (!bpf_psi)
+		return NULL;
+
+	if (init_srcu_struct(&bpf_psi->srcu)) {
+		kfree(bpf_psi);
+		return NULL;
+	}
+
+	spin_lock_init(&bpf_psi->lock);
+	bpf_psi->ops = ops;
+	INIT_LIST_HEAD(&bpf_psi->triggers);
+	ops->bpf_psi = bpf_psi;
+
+	return bpf_psi;
+}
+
+static void bpf_psi_free(struct bpf_psi *bpf_psi)
+{
+	cleanup_srcu_struct(&bpf_psi->srcu);
+	kfree(bpf_psi);
+}
+
+static void bpf_psi_handle_event_fn(struct work_struct *work)
+{
+	struct psi_trigger *t;
+	struct bpf_psi *bpf_psi;
+	int idx;
+
+	t = container_of(work, struct psi_trigger, bpf_work);
+	bpf_psi = READ_ONCE(t->bpf_psi);
+
+	if (likely(bpf_psi)) {
+		idx = srcu_read_lock(&bpf_psi->srcu);
+		if (bpf_psi->ops->handle_psi_event)
+			bpf_psi->ops->handle_psi_event(t);
+		srcu_read_unlock(&bpf_psi->srcu, idx);
+	}
+}
+
+void bpf_psi_add_trigger(struct psi_trigger *t,
+			 const struct psi_trigger_params *params)
+{
+	t->bpf_psi = params->bpf_psi;
+	t->pinned = false;
+	INIT_WORK(&t->bpf_work, bpf_psi_handle_event_fn);
+
+	spin_lock(&t->bpf_psi->lock);
+	list_add(&t->bpf_psi_node, &t->bpf_psi->triggers);
+	spin_unlock(&t->bpf_psi->lock);
+
+	spin_lock(&t->group->bpf_triggers_lock);
+	list_add(&t->bpf_group_node, &t->group->bpf_triggers);
+	spin_unlock(&t->group->bpf_triggers_lock);
+}
+
+void bpf_psi_remove_trigger(struct psi_trigger *t)
+{
+	spin_lock(&t->group->bpf_triggers_lock);
+	list_del(&t->bpf_group_node);
+	spin_unlock(&t->group->bpf_triggers_lock);
+
+	spin_lock(&t->bpf_psi->lock);
+	list_del(&t->bpf_psi_node);
+	spin_unlock(&t->bpf_psi->lock);
+}
+
+#ifdef CONFIG_CGROUPS
+void bpf_psi_cgroup_free(struct cgroup *cgroup)
+{
+	struct psi_group *group = cgroup->psi;
+	u64 cgrp_id = cgroup_id(cgroup);
+	struct psi_trigger *t, *p;
+	struct bpf_psi *bpf_psi;
+	LIST_HEAD(to_destroy);
+	int idx;
+
+	spin_lock(&group->bpf_triggers_lock);
+	list_for_each_entry_safe(t, p, &group->bpf_triggers, bpf_group_node) {
+		if (!t->pinned) {
+			t->pinned = true;
+			list_move(&t->bpf_group_node, &to_destroy);
+		}
+	}
+	spin_unlock(&group->bpf_triggers_lock);
+
+	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node) {
+		bpf_psi = READ_ONCE(t->bpf_psi);
+
+		idx = srcu_read_lock(&bpf_psi->srcu);
+		if (bpf_psi->ops->handle_cgroup_free)
+			bpf_psi->ops->handle_cgroup_free(cgrp_id);
+		srcu_read_unlock(&bpf_psi->srcu, idx);
+
+		spin_lock(&bpf_psi->lock);
+		list_del(&t->bpf_psi_node);
+		spin_unlock(&bpf_psi->lock);
+
+		WRITE_ONCE(t->bpf_psi, NULL);
+		flush_workqueue(bpf_psi_wq);
+		synchronize_srcu(&bpf_psi->srcu);
+		psi_trigger_destroy(t);
+	}
+}
+#endif
+
+void bpf_psi_handle_event(struct psi_trigger *t)
+{
+	queue_work(bpf_psi_wq, &t->bpf_work);
+}
+
+// bpf struct ops
+
+static int __bpf_psi_init(struct bpf_psi *bpf_psi) { return 0; }
+static void __bpf_psi_handle_psi_event(struct psi_trigger *t) {}
+static void __bpf_psi_handle_cgroup_free(u64 cgroup_id) {}
+
+static struct bpf_psi_ops __bpf_psi_ops = {
+	.init = __bpf_psi_init,
+	.handle_psi_event = __bpf_psi_handle_psi_event,
+	.handle_cgroup_free = __bpf_psi_handle_cgroup_free,
+};
+
+static const struct bpf_func_proto *
+bpf_psi_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return tracing_prog_func_proto(func_id, prog);
+}
+
+static bool bpf_psi_ops_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_verifier_ops bpf_psi_verifier_ops = {
+	.get_func_proto = bpf_psi_func_proto,
+	.is_valid_access = bpf_psi_ops_is_valid_access,
+};
+
+static int bpf_psi_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_psi_ops *ops = kdata;
+	struct bpf_psi *bpf_psi;
+
+	bpf_psi = bpf_psi_create(ops);
+	if (!bpf_psi)
+		return -ENOMEM;
+
+	return ops->init(bpf_psi);
+}
+
+static void bpf_psi_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_psi_ops *ops = kdata;
+	struct bpf_psi *bpf_psi = ops->bpf_psi;
+	struct psi_trigger *t, *p;
+	LIST_HEAD(to_destroy);
+
+	spin_lock(&bpf_psi->lock);
+	list_for_each_entry_safe(t, p, &bpf_psi->triggers, bpf_psi_node) {
+		spin_lock(&t->group->bpf_triggers_lock);
+		if (!t->pinned) {
+			t->pinned = true;
+			list_move(&t->bpf_group_node, &to_destroy);
+			list_del(&t->bpf_psi_node);
+
+			WRITE_ONCE(t->bpf_psi, NULL);
+		}
+		spin_unlock(&t->group->bpf_triggers_lock);
+	}
+	spin_unlock(&bpf_psi->lock);
+
+	flush_workqueue(bpf_psi_wq);
+	synchronize_srcu(&bpf_psi->srcu);
+
+	list_for_each_entry_safe(t, p, &to_destroy, bpf_group_node)
+		psi_trigger_destroy(t);
+
+	bpf_psi_free(bpf_psi);
+}
+
+static int bpf_psi_ops_check_member(const struct btf_type *t,
+				    const struct btf_member *member,
+				    const struct bpf_prog *prog)
+{
+	return 0;
+}
+
+static int bpf_psi_ops_init_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_psi_ops_init(struct btf *btf)
+{
+	return 0;
+}
+
+static struct bpf_struct_ops bpf_psi_bpf_ops = {
+	.verifier_ops = &bpf_psi_verifier_ops,
+	.reg = bpf_psi_ops_reg,
+	.unreg = bpf_psi_ops_unreg,
+	.check_member = bpf_psi_ops_check_member,
+	.init_member = bpf_psi_ops_init_member,
+	.init = bpf_psi_ops_init,
+	.name = "bpf_psi_ops",
+	.owner = THIS_MODULE,
+	.cfi_stubs = &__bpf_psi_ops
+};
+
+static int __init bpf_psi_struct_ops_init(void)
+{
+	int wq_flags = WQ_MEM_RECLAIM | WQ_UNBOUND | WQ_HIGHPRI;
+	int err;
+
+	bpf_psi_wq = alloc_workqueue("bpf_psi_wq", wq_flags, 0);
+	if (!bpf_psi_wq)
+		return -ENOMEM;
+
+	err = register_bpf_struct_ops(&bpf_psi_bpf_ops, bpf_psi_ops);
+	if (err) {
+		pr_warn("error while registering bpf psi struct ops: %d", err);
+		goto err;
+	}
+
+	return 0;
+
+err:
+	destroy_workqueue(bpf_psi_wq);
+	return err;
+}
+late_initcall(bpf_psi_struct_ops_init);
diff --git a/kernel/sched/build_utility.c b/kernel/sched/build_utility.c
index bf9d8db94b70..80f3799a2fa6 100644
--- a/kernel/sched/build_utility.c
+++ b/kernel/sched/build_utility.c
@@ -19,6 +19,7 @@
 #include <linux/sched/rseq_api.h>
 #include <linux/sched/task_stack.h>
 
+#include <linux/bpf_psi.h>
 #include <linux/cpufreq.h>
 #include <linux/cpumask_api.h>
 #include <linux/cpuset.h>
@@ -92,6 +93,9 @@
 
 #ifdef CONFIG_PSI
 # include "psi.c"
+# ifdef CONFIG_BPF_SYSCALL
+#  include "bpf_psi.c"
+# endif
 #endif
 
 #ifdef CONFIG_MEMBARRIER
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index e1d8eaeeff17..e10fbbc34099 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -201,6 +201,10 @@ static void group_init(struct psi_group *group)
 	init_waitqueue_head(&group->rtpoll_wait);
 	timer_setup(&group->rtpoll_timer, poll_timer_fn, 0);
 	rcu_assign_pointer(group->rtpoll_task, NULL);
+#ifdef CONFIG_BPF_SYSCALL
+	spin_lock_init(&group->bpf_triggers_lock);
+	INIT_LIST_HEAD(&group->bpf_triggers);
+#endif
 }
 
 void __init psi_init(void)
@@ -489,10 +493,17 @@ static void update_triggers(struct psi_group *group, u64 now,
 
 		/* Generate an event */
 		if (cmpxchg(&t->event, 0, 1) == 0) {
-			if (t->type == PSI_CGROUP)
-				kernfs_notify(t->of->kn);
-			else
+			switch (t->type) {
+			case PSI_SYSTEM:
 				wake_up_interruptible(&t->event_wait);
+				break;
+			case PSI_CGROUP:
+				kernfs_notify(t->of->kn);
+				break;
+			case PSI_BPF:
+				bpf_psi_handle_event(t);
+				break;
+			}
 		}
 		t->last_event_time = now;
 		/* Reset threshold breach flag once event got generated */
@@ -1125,6 +1136,7 @@ void psi_cgroup_free(struct cgroup *cgroup)
 		return;
 
 	cancel_delayed_work_sync(&cgroup->psi->avgs_work);
+	bpf_psi_cgroup_free(cgroup);
 	free_percpu(cgroup->psi->pcpu);
 	/* All triggers must be removed by now */
 	WARN_ONCE(cgroup->psi->rtpoll_states, "psi: trigger leak\n");
@@ -1356,6 +1368,9 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 	case PSI_CGROUP:
 		t->of = params->of;
 		break;
+	case PSI_BPF:
+		bpf_psi_add_trigger(t, params);
+		break;
 	}
 
 	t->pending_event = false;
@@ -1369,8 +1384,10 @@ struct psi_trigger *psi_trigger_create(struct psi_group *group,
 
 			task = kthread_create(psi_rtpoll_worker, group, "psimon");
 			if (IS_ERR(task)) {
-				kfree(t);
 				mutex_unlock(&group->rtpoll_trigger_lock);
+				if (t->type == PSI_BPF)
+					bpf_psi_remove_trigger(t);
+				kfree(t);
 				return ERR_CAST(task);
 			}
 			atomic_set(&group->rtpoll_wakeup, 0);
@@ -1414,10 +1431,16 @@ void psi_trigger_destroy(struct psi_trigger *t)
 	 * being accessed later. Can happen if cgroup is deleted from under a
 	 * polling process.
 	 */
-	if (t->type == PSI_CGROUP)
-		kernfs_notify(t->of->kn);
-	else
+	switch (t->type) {
+	case PSI_SYSTEM:
 		wake_up_interruptible(&t->event_wait);
+		break;
+	case PSI_CGROUP:
+		kernfs_notify(t->of->kn);
+		break;
+	case PSI_BPF:
+		break;
+	}
 
 	if (t->aggregator == PSI_AVGS) {
 		mutex_lock(&group->avgs_lock);
@@ -1494,10 +1517,16 @@ __poll_t psi_trigger_poll(void **trigger_ptr,
 	if (!t)
 		return DEFAULT_POLLMASK | EPOLLERR | EPOLLPRI;
 
-	if (t->type == PSI_CGROUP)
-		kernfs_generic_poll(t->of, wait);
-	else
+	switch (t->type) {
+	case PSI_SYSTEM:
 		poll_wait(file, &t->event_wait, wait);
+		break;
+	case PSI_CGROUP:
+		kernfs_generic_poll(t->of, wait);
+		break;
+	case PSI_BPF:
+		break;
+	}
 
 	if (cmpxchg(&t->event, 1, 0) == 1)
 		ret |= EPOLLPRI;
-- 
2.50.1


