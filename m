Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A27D7235E
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 09:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518E76B0476; Fri, 23 Jan 2026 04:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174CE6B0478; Fri, 23 Jan 2026 04:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7B76B0479; Fri, 23 Jan 2026 04:00:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDE16B0476
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:00:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3C688B93E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:00:41 +0000 (UTC)
X-FDA: 84362633082.07.68E6C77
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id D649FA0007
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:00:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oH9p83jf;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmdpaV9B6tw25LP5uotyZ1lCEdDuASwhRWt8MPVMavA=;
	b=r8BgNQNoWLFxrwWlzF4vMozOdZpYNkFueVzqPm3NJAkg2CvVLsTBrnp41ctiBisDM6Poh1
	i58OJEVRTyaarSW/wKF7umBYqYzZTaHGXfPXhfksP0jUFV6Ufye9NrRfBavXZ+rqrQ3Kfy
	lM9SRyfmnGtF41hAseUidE1A2hU34mQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oH9p83jf;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158840; a=rsa-sha256;
	cv=none;
	b=XRX4/NVqTD7cX31695y3Kgl08fpOEXP6eaui7yMM6yeEUhz7enHqDeXseND9j7aqdEiMGU
	GxMXeIFmVgQNjDSJiwLzgQg9ACKwDRgt2CGSgjT9uqLe25HfMiHvHQYrqICu7lLNX/8JOT
	uCrRh9KiHX2jGa7TojU/6ymnTaskLaw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769158837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YmdpaV9B6tw25LP5uotyZ1lCEdDuASwhRWt8MPVMavA=;
	b=oH9p83jfG7qjP1gOLGi1H99wE8zFGPkm6ZDTBXb0xT5J94HC68j/e5uBeNFGsMFrcbGNfP
	E4/DvnXs75aP4rJeLvmGofelgf57Cq+HUL0vJHWwHyXbzAofrHRUeErHUYjbS6BEPiEZ/+
	gVKTBwRZwnXgyPXcyMShc7eatNqV1Gk=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Jeff Xu <jeffxu@chromium.org>,
	mkoutny@suse.com,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Christian Brauner <brauner@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brian Gerst <brgerst@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH bpf-next v3 08/12] mm: memcontrol: Add BPF struct_ops for memory controller
Date: Fri, 23 Jan 2026 17:00:13 +0800
Message-ID: <863b91cb85097f137bc741e7cb686ff78d9bb95e.1769157382.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1769157382.git.zhuhui@kylinos.cn>
References: <cover.1769157382.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D649FA0007
X-Stat-Signature: m1jbumsg7jpbsdjyr1k7gi4coxg8sxbg
X-Rspam-User: 
X-HE-Tag: 1769158839-292765
X-HE-Meta: U2FsdGVkX194+m3MzxQOYY37lw1qyM1dE2D0xQG8mwPDNr0YtQBPYRtZBq4ZStkMpaWW4w4gPmhP+N6O4dBGo8fSIKivydoDnF6aUHnOQtw237IP1ecgh4pHqb0/uJOdDdi9TcObo5rz+v4vQwMT/e2mxKWUTIpDB94dj7aOI06vfUI61LrcodcIF1bWvipJrLEtOArP/KUh9tAmEL7fz5mgtJJISlH+uS76EjOByXeyNuAqpYJXNTm4FQso5uodPG70PWPO90YC0ZQiyQsnjqAxKjWzGDFoLqvcujXjUXmHlQ/KsUDb6kLbdgF71LEaozV76ASQuY3j0qF2s5xw6yJUQ6XB6EOVC/FAHPFXwf1qC4ohObKo72T6AkgD0m/PENF8u+J8cODIAel3gSS8xun19Tg0Td3znMYheucE99f6Iee5xMQe86zETLDIpWXACmew+w39aARK0cSvev1h6k8hj2g7OqBXG+uV6FNIJnrhQK0jJnvT7BrdMNcFM0Vjdlmu832HueYzWFds15M1YO3C5hwSkyKw2S/5FFAa62vvQrt67TWxyCDKyqOasKPluEH2dajT7gvZSSNbgj7F9b/McQ/L4hydvQzJtCBcO3FSNQCOvQvaKN9EDTlHA54SiFEEm7LGsKlj4e+HZOixJmep3lnDRkhxaSLMkDWeeFWJRkuNlzcwM/wZhvx1DRSdh9ChN6UG6qmWTF4r20qiJXjMzf+fXMN/euCPFOQPswvEsZ8T6vlwtiT+GCBfO/J6bDNOCSXy6fuCnNyPhWbgDwOjq59aiv68yH7NAcF21ErCZOIK56pWrt4nM3ODKjTQ4bkPUbDlYYfBzwDtRTVKRf4NxJLGMKWYZmZSEc5u3fyqqmCZ2eQ3eIxJIqmKJhuMeX4Ys/mWKO9liWHqkqp5gRCYK8+ym4xvr9+26h7DHgEpG+JZyG1GxVEsKYxUdOn+oW2NVvWw3tg1nz5N1xi
 M+1AgN8Z
 dbNkTy+bdz4ZNeCh9WPkZCM0c0fwUkurkj3d+irmRPOD0WgX3h9//zRKyLtBiZU73P1SlXYrxmRrqGRqeieNESvEEt0UD42UhB1PcojxBKyM9i0WiBNL0PIv6FDfaNW2g0KJ5wdWMg7a7uEBvar3OMu6IzvxugTwhUqdzaTzJdUnPyv+oGyX6WopSPoQEtk6166q74Rt9lt1j0r71MnFGfbSNH9tfBu/RvHJa4fh766a5fnyFGEDz8aeBHPyCyQCzXGxgbk9CoUE3Vc2OnMGzSaWMlDNJcyGSEKN0wVcHE8gtlxk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Introduce BPF struct_ops support to the memory controller, enabling
custom and dynamic control over memory pressure. This is achieved
through a new struct_ops type, `memcg_bpf_ops`.

This new interface allows a BPF program to implement hooks that
influence a memory cgroup's behavior. The `memcg_bpf_ops` struct
provides the following hooks:

- `get_high_delay_ms`: Returns a custom throttling delay in
  milliseconds for a cgroup that has breached its `memory.high`
  limit. This is the primary mechanism for BPF-driven throttling.

- `below_low`: Overrides the `memory.low` protection check. If this
  hook returns true, the cgroup is considered to be protected by its
  `memory.low` setting, regardless of its actual usage.

- `below_min`: Similar to `below_low`, this overrides the `memory.min`
  protection check.

- `handle_cgroup_online`/`offline`: Callbacks invoked when a cgroup
  with an attached program comes online or goes offline, allowing for
  state management.

This patch integrates these hooks into the core memory control logic.
The `get_high_delay_ms` value is incorporated into charge paths like
`try_charge_memcg` and the high-limit handler
`__mem_cgroup_handle_over_high`. The `below_low` and `below_min`
hooks are checked within their respective protection functions.

Lifecycle management is handled to ensure BPF programs are correctly
inherited by child cgroups and cleaned up on detachment. SRCU is used
to protect concurrent access to the `memcg->bpf_ops` pointer.

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/memcontrol.h | 106 ++++++++++++++-
 mm/bpf_memcontrol.c        | 255 ++++++++++++++++++++++++++++++++++++-
 mm/memcontrol.c            |  32 +++--
 3 files changed, 380 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f3b8c71870d8..d71e86b85ba7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -181,6 +181,37 @@ struct obj_cgroup {
 	};
 };
 
+#ifdef CONFIG_BPF_SYSCALL
+/**
+ * struct memcg_bpf_ops - BPF callbacks for memory cgroup operations
+ * @handle_cgroup_online: Called when a cgroup comes online
+ * @handle_cgroup_offline: Called when a cgroup goes offline
+ * @below_low: Override memory.low protection check. If this callback returns
+ *             true, mem_cgroup_below_low() will return true immediately without
+ *             performing the standard comparison. If it returns false, the
+ *             original memory.low threshold comparison will proceed normally.
+ * @below_min: Override memory.min protection check. If this callback returns
+ *             true, mem_cgroup_below_min() will return true immediately without
+ *             performing the standard comparison. If it returns false, the
+ *             original memory.min threshold comparison will proceed normally.
+ * @get_high_delay_ms: Return custom throttle delay in milliseconds
+ *
+ * This structure defines the interface for BPF programs to customize
+ * memory cgroup behavior through struct_ops programs.
+ */
+struct memcg_bpf_ops {
+	void (*handle_cgroup_online)(struct mem_cgroup *memcg);
+
+	void (*handle_cgroup_offline)(struct mem_cgroup *memcg);
+
+	bool (*below_low)(struct mem_cgroup *memcg);
+
+	bool (*below_min)(struct mem_cgroup *memcg);
+
+	unsigned int (*get_high_delay_ms)(struct mem_cgroup *memcg);
+};
+#endif /* CONFIG_BPF_SYSCALL */
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -321,6 +352,10 @@ struct mem_cgroup {
 	spinlock_t event_list_lock;
 #endif /* CONFIG_MEMCG_V1 */
 
+#ifdef CONFIG_BPF_SYSCALL
+	struct memcg_bpf_ops *bpf_ops;
+#endif
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
@@ -554,6 +589,66 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+#ifdef CONFIG_BPF_SYSCALL
+
+/* SRCU for protecting concurrent access to memcg->bpf_ops */
+extern struct srcu_struct memcg_bpf_srcu;
+
+/**
+ * BPF_MEMCG_CALL - Safely invoke a BPF memcg callback
+ * @memcg: The memory cgroup
+ * @op: The operation name (struct member)
+ * @default_val: Default return value if no BPF program attached
+ *
+ * This macro safely calls a BPF callback under SRCU protection.
+ */
+#define BPF_MEMCG_CALL(memcg, op, default_val) ({		\
+	typeof(default_val) __ret = (default_val);		\
+	struct memcg_bpf_ops *__ops;				\
+	int __idx;						\
+								\
+	__idx = srcu_read_lock(&memcg_bpf_srcu);		\
+	__ops = READ_ONCE((memcg)->bpf_ops);			\
+	if (__ops && __ops->op)					\
+		__ret = __ops->op(memcg);			\
+	srcu_read_unlock(&memcg_bpf_srcu, __idx);		\
+	__ret;							\
+})
+
+static inline bool bpf_memcg_below_low(struct mem_cgroup *memcg)
+{
+	return BPF_MEMCG_CALL(memcg, below_low, false);
+}
+
+static inline bool bpf_memcg_below_min(struct mem_cgroup *memcg)
+{
+	return BPF_MEMCG_CALL(memcg, below_min, false);
+}
+
+static inline unsigned long bpf_memcg_get_high_delay(struct mem_cgroup *memcg)
+{
+	unsigned int ret;
+
+	ret = BPF_MEMCG_CALL(memcg, get_high_delay_ms, 0U);
+	return msecs_to_jiffies(ret);
+}
+
+#undef BPF_MEMCG_CALL
+
+extern void memcontrol_bpf_online(struct mem_cgroup *memcg);
+extern void memcontrol_bpf_offline(struct mem_cgroup *memcg);
+
+#else /* CONFIG_BPF_SYSCALL */
+
+static inline unsigned long
+bpf_memcg_get_high_delay(struct mem_cgroup *memcg) { return 0 }
+static inline bpf_memcg_below_low(struct mem_cgroup *memcg) { return false }
+static inline bpf_memcg_below_min(struct mem_cgroup *memcg) { return false }
+static inline void memcontrol_bpf_online(struct mem_cgroup *memcg) { }
+static inline void memcontrol_bpf_offline(struct mem_cgroup *memcg) { }
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -625,6 +720,9 @@ static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (bpf_memcg_below_low(memcg))
+		return true;
+
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
@@ -635,6 +733,9 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (bpf_memcg_below_min(memcg))
+		return true;
+
 	return READ_ONCE(memcg->memory.emin) >=
 		page_counter_read(&memcg->memory);
 }
@@ -909,12 +1010,13 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
-void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask,
+				   unsigned long bpf_high_delay);
 
 static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 	if (unlikely(current->memcg_nr_pages_over_high))
-		__mem_cgroup_handle_over_high(gfp_mask);
+		__mem_cgroup_handle_over_high(gfp_mask, 0);
 }
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index f95cd5d16f4c..3eae1af49519 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -8,6 +8,9 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
 
+/* Protects memcg->bpf_ops pointer for read and write. */
+DEFINE_SRCU(memcg_bpf_srcu);
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -179,15 +182,263 @@ static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
 	.set            = &bpf_memcontrol_kfuncs,
 };
 
+/**
+ * memcontrol_bpf_online - Inherit BPF programs for a new online cgroup.
+ * @memcg: The memory cgroup that is coming online.
+ *
+ * When a new memcg is brought online, it inherits the BPF programs
+ * attached to its parent. This ensures consistent BPF-based memory
+ * control policies throughout the cgroup hierarchy.
+ *
+ * After inheriting, if the BPF program has an online handler, it is
+ * invoked for the new memcg.
+ */
+void memcontrol_bpf_online(struct mem_cgroup *memcg)
+{
+	int idx;
+	struct memcg_bpf_ops *ops;
+	struct mem_cgroup *parent_memcg;
+
+	/* The root cgroup does not inherit from a parent. */
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	parent_memcg = parent_mem_cgroup(memcg);
+
+	idx = srcu_read_lock(&memcg_bpf_srcu);
+
+	/* Inherit the BPF program from the parent cgroup. */
+	ops = READ_ONCE(parent_memcg->bpf_ops);
+	if (!ops)
+		goto out;
+
+	WRITE_ONCE(memcg->bpf_ops, ops);
+
+	/*
+	 * If the BPF program implements it, call the online handler to
+	 * allow the program to perform setup tasks for the new cgroup.
+	 */
+	if (!ops->handle_cgroup_online)
+		goto out;
+
+	ops->handle_cgroup_online(memcg);
+
+out:
+	srcu_read_unlock(&memcg_bpf_srcu, idx);
+}
+
+/**
+ * memcontrol_bpf_offline - Run BPF cleanup for an offline cgroup.
+ * @memcg: The memory cgroup that is going offline.
+ *
+ * If a BPF program is attached and implements an offline handler,
+ * it is invoked to perform cleanup tasks before the memcg goes
+ * completely offline.
+ */
+void memcontrol_bpf_offline(struct mem_cgroup *memcg)
+{
+	int idx;
+	struct memcg_bpf_ops *ops;
+
+	idx = srcu_read_lock(&memcg_bpf_srcu);
+
+	ops = READ_ONCE(memcg->bpf_ops);
+	if (!ops || !ops->handle_cgroup_offline)
+		goto out;
+
+	ops->handle_cgroup_offline(memcg);
+
+out:
+	srcu_read_unlock(&memcg_bpf_srcu, idx);
+}
+
+static int memcg_ops_btf_struct_access(struct bpf_verifier_log *log,
+					const struct bpf_reg_state *reg,
+					int off, int size)
+{
+	return -EACCES;
+}
+
+static bool memcg_ops_is_valid_access(int off, int size, enum bpf_access_type type,
+	const struct bpf_prog *prog,
+	struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+const struct bpf_verifier_ops bpf_memcg_verifier_ops = {
+	.get_func_proto = bpf_base_func_proto,
+	.btf_struct_access = memcg_ops_btf_struct_access,
+	.is_valid_access = memcg_ops_is_valid_access,
+};
+
+static void cfi_handle_cgroup_online(struct mem_cgroup *memcg)
+{
+}
+
+static void cfi_handle_cgroup_offline(struct mem_cgroup *memcg)
+{
+}
+
+static bool cfi_below_low(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static bool cfi_below_min(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static unsigned int cfi_get_high_delay_ms(struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
+static struct memcg_bpf_ops cfi_bpf_memcg_ops = {
+	.handle_cgroup_online = cfi_handle_cgroup_online,
+	.handle_cgroup_offline = cfi_handle_cgroup_offline,
+	.below_low = cfi_below_low,
+	.below_min = cfi_below_min,
+	.get_high_delay_ms = cfi_get_high_delay_ms,
+};
+
+static int bpf_memcg_ops_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_memcg_ops_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct memcg_bpf_ops, handle_cgroup_online):
+		break;
+	case offsetof(struct memcg_bpf_ops, handle_cgroup_offline):
+		break;
+	case offsetof(struct memcg_bpf_ops, below_low):
+		break;
+	case offsetof(struct memcg_bpf_ops, below_min):
+		break;
+	case offsetof(struct memcg_bpf_ops, get_high_delay_ms):
+		break;
+	default:
+		if (prog->sleepable)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int bpf_memcg_ops_init_member(const struct btf_type *t,
+				const struct btf_member *member,
+				void *kdata, const void *udata)
+{
+	return 0;
+}
+
+/**
+ * clean_memcg_bpf_ops - Detach BPF programs from a cgroup hierarchy.
+ * @memcg: The root of the cgroup hierarchy to clean.
+ * @ops:   The specific ops struct to detach. If NULL, detach any ops.
+ *
+ * Iterates through all descendant cgroups of @memcg (including itself)
+ * and clears their bpf_ops pointer. This is used when a BPF program
+ * is detached or if attachment fails midway.
+ */
+static void clean_memcg_bpf_ops(struct mem_cgroup *memcg,
+				struct memcg_bpf_ops *ops)
+{
+	struct mem_cgroup *iter = NULL;
+
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		if (ops) {
+			if (!WARN_ON(READ_ONCE(memcg->bpf_ops) != ops))
+				WRITE_ONCE(memcg->bpf_ops, NULL);
+		} else
+			WRITE_ONCE(iter->bpf_ops, NULL);
+	}
+}
+
+static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *ops_link
+		= container_of(link, struct bpf_struct_ops_link, link);
+	struct memcg_bpf_ops *ops = kdata;
+	struct mem_cgroup *memcg, *iter = NULL;
+	int err = 0;
+
+	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
+	if (IS_ERR_OR_NULL(memcg))
+		return PTR_ERR(memcg);
+
+	cgroup_lock();
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		if (READ_ONCE(iter->bpf_ops)) {
+			mem_cgroup_iter_break(memcg, iter);
+			err = -EBUSY;
+			break;
+		}
+		WRITE_ONCE(iter->bpf_ops, ops);
+	}
+	if (err)
+		clean_memcg_bpf_ops(memcg, NULL);
+	cgroup_unlock();
+
+	mem_cgroup_put(memcg);
+	return err;
+}
+
+/* Unregister the struct ops instance */
+static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *ops_link
+		= container_of(link, struct bpf_struct_ops_link, link);
+	struct memcg_bpf_ops *ops = kdata;
+	struct mem_cgroup *memcg;
+
+	memcg = mem_cgroup_get_from_ino(ops_link->cgroup_id);
+	if (IS_ERR_OR_NULL(memcg))
+		goto out;
+
+	cgroup_lock();
+	clean_memcg_bpf_ops(memcg, ops);
+	cgroup_unlock();
+
+	mem_cgroup_put(memcg);
+
+out:
+	synchronize_srcu(&memcg_bpf_srcu);
+}
+
+static struct bpf_struct_ops bpf_memcg_bpf_ops = {
+	.verifier_ops = &bpf_memcg_verifier_ops,
+	.init = bpf_memcg_ops_init,
+	.check_member = bpf_memcg_ops_check_member,
+	.init_member = bpf_memcg_ops_init_member,
+	.reg = bpf_memcg_ops_reg,
+	.unreg = bpf_memcg_ops_unreg,
+	.name = "memcg_bpf_ops",
+	.owner = THIS_MODULE,
+	.cfi_stubs = &cfi_bpf_memcg_ops,
+};
+
 static int __init bpf_memcontrol_init(void)
 {
-	int err;
+	int err, err2;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
 	if (err)
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
 
-	return err;
+	err2 = register_bpf_struct_ops(&bpf_memcg_bpf_ops, memcg_bpf_ops);
+	if (err)
+		pr_warn("error while registering memcontrol bpf ops: %d", err2);
+
+	return err ? err : err2;
 }
 late_initcall(bpf_memcontrol_init);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1f74fce27677..8d90575aa77d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2252,7 +2252,8 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
  * try_charge() (context permitting), as well as from the userland
  * return path where reclaim is always able to block.
  */
-void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
+void
+__mem_cgroup_handle_over_high(gfp_t gfp_mask, unsigned long bpf_high_delay)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
@@ -2294,11 +2295,15 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
-					       mem_find_max_overage(memcg));
+	if (nr_pages) {
+		penalty_jiffies = calculate_high_delay(
+			memcg, nr_pages, mem_find_max_overage(memcg));
 
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
-						swap_find_max_overage(memcg));
+		penalty_jiffies += calculate_high_delay(
+			memcg, nr_pages, swap_find_max_overage(memcg));
+	} else
+		penalty_jiffies = 0;
+	penalty_jiffies = max(penalty_jiffies, bpf_high_delay);
 
 	/*
 	 * Clamp the max delay per usermode return so as to still keep the
@@ -2356,6 +2361,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	struct mem_cgroup *orig_memcg;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
@@ -2481,6 +2487,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	orig_memcg = memcg;
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2530,10 +2537,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * kernel. If this is successful, the return path will see it
 	 * when it rechecks the overage and simply bail out.
 	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	if (gfpflags_allow_blocking(gfp_mask)) {
+		unsigned long bpf_high_delay;
+
+		bpf_high_delay = bpf_memcg_get_high_delay(orig_memcg);
+		if (bpf_high_delay ||
+		    current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH)
+			__mem_cgroup_handle_over_high(gfp_mask, bpf_high_delay);
+	}
 	return 0;
 }
 
@@ -3906,6 +3917,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_ids, memcg->id.id, memcg, GFP_KERNEL);
 
+	memcontrol_bpf_online(memcg);
+
 	return 0;
 offline_kmem:
 	memcg_offline_kmem(memcg);
@@ -3925,6 +3938,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	zswap_memcg_offline_cleanup(memcg);
 
+	memcontrol_bpf_offline(memcg);
 	memcg_offline_kmem(memcg);
 	reparent_deferred_split_queue(memcg);
 	reparent_shrinker_deferred(memcg);
-- 
2.43.0


