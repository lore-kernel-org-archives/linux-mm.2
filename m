Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76A28CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 02:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D526B0096; Mon, 25 May 2026 22:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E566B0098; Mon, 25 May 2026 22:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C5D6B0099; Mon, 25 May 2026 22:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B03A36B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:25:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C2F340225
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:25:32 +0000 (UTC)
X-FDA: 84807979704.15.8D3DC72
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 506E1140003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:25:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YfiAh1tC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779762330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBXofLS2/VUxF2UYjXjqK/PbDOUsVx2R7QdYyie6cEM=;
	b=Ad/RhLF9n/WKRnZ7CJam+rv3aG4tguaMq1Lea6wGWMN1XQlFNiiOkjOrV78T2dWyq1tFRd
	vunERkCUFlbK8A8G4Q0pbQPpK2s5+rZCgQphle8CD/kBL64Gjx1p6iVNi2dST1WSLLvFim
	W/7bm2MdPyRwucxv7dLcXtoETq5aKYI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YfiAh1tC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779762330; a=rsa-sha256;
	cv=none;
	b=Uf9fWQo/44TKEjN53F2a9piMowBNG/2xih41Daw/bYQevhDYX7twqmlLXftX11YiMc9xXV
	clzIbjhQnI50d8FRr+XXUSkqBtj5JhwLU4b/6S5bvpwQd9ezB7iypJgGLEDki1mO14mO16
	iT6dH/grGu57a0N/MPoXWulkSfWa01s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779762328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WBXofLS2/VUxF2UYjXjqK/PbDOUsVx2R7QdYyie6cEM=;
	b=YfiAh1tCl+MvkWkflELb5JhfMqa4GlkKZiB7v/dGb6ZkFPUhd3JnWnzAMAC9u/xxKuP3fH
	cDqhUBNAnjE25f2K+KrZG85Cf6B2fBNww+eKqzhx3kmH1S5aglrFr+XNJDg4XA/bEp3oB9
	68w3TY7e4GWPu+TQBzpK8Z8r+l1p9xA=
From: Hui Zhu <hui.zhu@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	davem@davemloft.net,
	Jakub Kicinski <kuba@kernel.org>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	KP Singh <kpsingh@kernel.org>,
	Tao Chen <chen.dylane@linux.dev>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tobias Klauser <tklauser@distanz.ch>,
	Eyal Birger <eyal.birger@gmail.com>,
	Rong Tao <rongtao@cestc.cn>,
	Hao Luo <haoluo@google.com>,
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
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Lance Yang <lance.yang@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: geliang@kernel.org,
	baohua@kernel.org,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: [RFC PATCH bpf-next v7 06/11] mm: memcontrol: Add BPF struct_ops for memory controller
Date: Tue, 26 May 2026 10:24:54 +0800
Message-ID: <9e081d01a0708dcdd101af7f7bede07cf43ca21d.1779760876.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1779760876.git.zhuhui@kylinos.cn>
References: <cover.1779760876.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 506E1140003
X-Stat-Signature: q5u6u9uhhtyti37s1zrs98mzebd19w7s
X-Rspam-User: 
X-HE-Tag: 1779762330-734848
X-HE-Meta: U2FsdGVkX19s+kVazRYsrNaVtLblCwjFC2IbqB9Sf24sMw2g0KUHcb88w0lFSOKY7lwsBAG7HCqoXSFxcxLbPRdb71oAkJyZt5sQZuNze7ndoIvhaO4/4GljBeLN4gbNM0BkFigCSUgV1hDZ7qtIlWImuWtmkJ4iS4ljTCuHXUpDp112+qKYsiR89H0PaR79oDepcGYFngo4L8C+L7JcsOUOtywj7IA+EdaiI5pPbTfEIdZ5OsliOypzz2GLiEsfqXHwGqMnENKLT7fdBPOFdgKZgHuBEQSaybPbQ3JZnzBTjdkPcP8K3KpEs1XPiKbQwcC3ap27TKoJOAgONfFFcFyIVjeKH71b/pNZwBEjCbBXSP155/DXrqzOU7BsbZEeRzjzm+rCgvtvdvkisbiPqB2OCw6hS0L5bFqSaEdyBpCle8ZzYuepLwXsfVaVgc507k37J+/gPKcVOB+t3BDfb+Kd8FBiBujsbN4K9blEY6unjzaHZOpk2GG13VQancsGAHmkksLo3cJjVbon5jIvk9zUUCnk1JgeesH6tPosi19NBwpV/T+M/PWsc9qk97qB99KA+g92svoKEKGD1aLz53tUroP+INyRTPm2FXv1e+XmLZIOhG+fLANXYc+TNbhRmRV2TyKXQp660aEMVtwQjm6p5mIMjNCUw/0Y3KMDRxWpGG/X6pcMgyyvj8pa427wexFbvTRgL7eGPfcqKezSWCdQzu2BPJmvk0hXIKVzS5OXs3YPVjMzJtnTPegY+/puITG6U99IyNPZeVHoXjMW0GdpMx97tWtjbW63WWtEPuVlbr7p6vYTKQh9cxLWlZxvmvc2dJNROGaYKXM1boMSsMk2YEJHLyWW27zgQHoubLF/r+ZDf6X57852ZaQ3xqu6daJQian9YZGFH3j1JjZyYuMDCRN+CQJ8ZejHk5flo6lwjcadD3hTro+gnpNMmETuuCIORHvqrbNL8+WVw5y
 O8N2ih3f
 amEvcTSQCRUssnTHsc3H2PB31ObKcWjFlxp2xMofXbSCh4tYitQXzeHem1sj5gch4zf22pIbyRcgmfz7dseF7smsyPysgenq5ylKx4dH00Qo1xOJY+fO3V0BrubC0apUJgnVJsBKUdvs9l3/S1Z4WQexJv2b047ec1qe+0RbpaRl4kRkZPvwjeE4hGmULmsNk884ciglQSLHVrMMcRhGys/iCriWHu32PglRRVQ8D2zZeooRvZzCSIIkKV5wTqJGwPpP9nDIS8X1hf5ecRl/8QX4q2cQsBz51L+a2si31Wo1PhwjwDaKWvg/ZBM1slZIdoq+1PwD70Gs4fqUBd4CFEAhNVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Introduce BPF struct_ops support to the memory controller, enabling
custom and dynamic control over memory pressure via a new struct_ops
type, `memcg_bpf_ops`.

The `memcg_bpf_ops` interface exposes the following hooks:

- `memcg_charged`: Called on the synchronous blocking charge path after
  pages have been charged to the cgroup. Returns a custom throttling
  delay in milliseconds. This value is used as a lower bound for the
  penalty passed to `__mem_cgroup_handle_over_high()` and applies even
  when `memory.high` is not breached, allowing BPF programs to impose
  proactive back-pressure on any charge event. Return 0 for no delay.

- `memcg_uncharged`: Called when pages are uncharged from a cgroup,
  allowing BPF programs to track or react to memory releases.

- `below_low`: Overrides the `memory.low` protection check. Receives
  the effective low threshold (elow) and current usage as arguments.
  If it returns true, the cgroup is treated as protected regardless of
  the standard elow >= usage comparison. Returning false continues
  to the normal kernel check.

- `below_min`: Same as `below_low`, but for `memory.min` protection.
  Receives emin and usage as arguments.

- `handle_cgroup_online`/`offline`: Callbacks invoked when a cgroup
  with an attached program comes online or goes offline, allowing BPF
  programs to manage per-cgroup state.

These hooks are integrated into core memory control logic.

`memcg_charged` is consulted in `try_charge_memcg` on the synchronous
blocking path. To avoid losing the originally charged cgroup pointer as
the charge loop walks up the ancestor chain, `orig_memcg` is saved
before the loop begins. After the loop, the BPF hook is called with
`orig_memcg` and the actual batch size, and its result (converted from
milliseconds to jiffies) is stored as `bpf_high_delay`.

`__mem_cgroup_handle_over_high()` is then invoked when either
`bpf_high_delay` is non-zero or `memcg_nr_pages_over_high` exceeds
MEMCG_CHARGE_BATCH. Inside the function, the current task's memcg is
obtained independently via `get_mem_cgroup_from_mm()`. Reclaim is
attempted first; if reclaim makes forward progress or retries remain,
the function loops back to reclaim again rather than throttling
immediately. `bpf_high_delay` serves as a lower bound for the final
penalty via `max(penalty_jiffies, bpf_high_delay)`: when
`memcg_nr_pages_over_high` is zero (memory.high not breached),
the kernel overage calculation is skipped and `bpf_high_delay` alone
sets the penalty. In all cases, throttling only occurs if the resulting
penalty exceeds HZ/100; a BPF-requested delay below this threshold
causes no sleep. The deferred user-return path (via
`mem_cgroup_handle_over_high()`) always passes bpf_high_delay=0 since
BPF delay is evaluated exactly once, on the synchronous charge path.

`below_low` and `below_min` are inserted in their respective inline
functions after the unprotected check. The pre-read elow/emin and usage
values are forwarded to the BPF hook; on false return the standard
kernel comparison (elow >= usage) proceeds as normal.

Support for `BPF_F_ALLOW_OVERRIDE` is included. When a program is
registered with this flag, a descendant cgroup may later attach its own
`memcg_bpf_ops` to override the inherited program. Without this flag,
attaching to a cgroup that already has a program (whether attached
directly or inherited from an ancestor) will fail with -EBUSY.

On registration, ops are propagated to the cgroup itself and all its
descendants via `mem_cgroup_iter`. A `bpf_ops_flags` field is added to
`struct mem_cgroup` to persist the attachment flags, which are inherited
during `css_online` and restored to the parent's flags on
unregistration. On unregistration, rather than unconditionally clearing
`bpf_ops` to NULL throughout the subtree, each descendant that still
holds the unregistered ops pointer has its `bpf_ops` and
`bpf_ops_flags` restored to the values the registering cgroup's parent
held at that time. This correctly handles the override case where a
descendant had re-attached over an inherited program.

Lifecycle management ensures programs are inherited by child cgroups
on `css_online` and cleaned up on `css_offline`. SRCU (`memcg_bpf_srcu`)
protects concurrent read access to the `memcg->bpf_ops` pointer; all
writes are serialized under `cgroup_mutex`.

Signed-off-by: Barry Song <baohua@kernel.org>
Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 include/linux/memcontrol.h | 250 ++++++++++++++++++++++++++++++-
 mm/bpf_memcontrol.c        | 298 ++++++++++++++++++++++++++++++++++++-
 mm/memcontrol.c            |  43 ++++--
 3 files changed, 574 insertions(+), 17 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dc3fa687759b..30b7b8558ccb 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -23,6 +23,7 @@
 #include <linux/writeback.h>
 #include <linux/page-flags.h>
 #include <linux/shrinker.h>
+#include <linux/srcu.h>
 
 struct mem_cgroup;
 struct obj_cgroup;
@@ -192,6 +193,59 @@ struct obj_cgroup {
 	bool is_root;
 };
 
+#ifdef CONFIG_BPF_SYSCALL
+/*
+ * struct memcg_bpf_ops - BPF callbacks for memory cgroup operations
+ *
+ * @handle_cgroup_online:  Called when a cgroup comes online. May be used
+ *                         by a BPF program to initialize per-cgroup state.
+ * @handle_cgroup_offline: Called when a cgroup goes offline. May be used
+ *                         to release per-cgroup state allocated in the
+ *                         online callback.
+ * @below_low:  Override the memory.low protection check.
+ *              Receives the effective low threshold @elow and the current
+ *              memory usage @usage (both in pages). If the callback returns
+ *              true, mem_cgroup_below_low() returns true immediately,
+ *              treating the cgroup as protected regardless of the standard
+ *              elow >= usage comparison. Returning false continues to
+ *              the normal kernel check.
+ * @below_min:  Same as @below_low, but for the memory.min protection check.
+ *              Receives @emin and @usage. Returning true short-circuits the
+ *              standard emin >= usage comparison.
+ * @memcg_charged:   Called on the synchronous blocking charge path after
+ *                   pages have been charged to the cgroup. Returns a custom
+ *                   throttle delay in milliseconds. This delay is taken as
+ *                   a lower bound for the penalty in
+ *                   __mem_cgroup_handle_over_high() and applies even when
+ *                   memory.high is not breached. Return 0 for no extra delay.
+ * @memcg_uncharged: Called when pages are uncharged from the cgroup.
+ *                   Allows BPF programs to track memory releases or update
+ *                   accounting state. No return value.
+ *
+ * This structure defines the interface for BPF programs to customize
+ * memory cgroup behavior through struct_ops programs. All callbacks are
+ * non-sleepable. Concurrent readers are protected by SRCU
+ * (memcg_bpf_srcu); writers hold cgroup_mutex.
+ */
+struct memcg_bpf_ops {
+	void (*handle_cgroup_online)(struct mem_cgroup *memcg);
+
+	void (*handle_cgroup_offline)(struct mem_cgroup *memcg);
+
+	bool (*below_low)(struct mem_cgroup *memcg, unsigned long elow,
+			  unsigned long usage);
+
+	bool (*below_min)(struct mem_cgroup *memcg, unsigned long emin,
+			  unsigned long usage);
+
+	unsigned int (*memcg_charged)(struct mem_cgroup *memcg,
+				      unsigned int nr_pages);
+
+	void (*memcg_uncharged)(struct mem_cgroup *memcg,
+				unsigned int nr_pages);
+};
+#endif /* CONFIG_BPF_SYSCALL */
+
 /*
  * The memory controller data structure. The memory controller controls both
  * page cache and RSS per cgroup. We would eventually like to provide
@@ -323,6 +377,11 @@ struct mem_cgroup {
 	spinlock_t event_list_lock;
 #endif /* CONFIG_MEMCG_V1 */
 
+#ifdef CONFIG_BPF_SYSCALL
+	struct memcg_bpf_ops *bpf_ops;
+	u32 bpf_ops_flags;
+#endif
+
 	struct mem_cgroup_per_node *nodeinfo[];
 };
 
@@ -533,6 +592,165 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+#ifdef CONFIG_BPF_SYSCALL
+
+/* SRCU for protecting concurrent access to memcg->bpf_ops */
+extern struct srcu_struct memcg_bpf_srcu;
+
+/*
+ * BPF_MEMCG_CALL - Safely invoke a BPF memcg callback with return value
+ * @memcg:       The memory cgroup whose bpf_ops to invoke
+ * @op:          The callback name (struct member of memcg_bpf_ops)
+ * @default_val: Value to return if no BPF program is attached or the
+ *               specific callback is not implemented
+ * @...:         Additional arguments forwarded to the callback
+ *
+ * Uses a two-phase READ_ONCE() pattern:
+ *   1. An initial lockless READ_ONCE() provides a fast-path check.
+ *      If bpf_ops is NULL the SRCU lock is never taken, keeping the
+ *      common no-BPF path free of synchronization overhead.
+ *   2. A second READ_ONCE() after srcu_read_lock() ensures a consistent
+ *      view of the pointer under the SRCU read section, guarding against
+ *      a concurrent bpf_memcg_ops_unreg() that may be in progress.
+ */
+#define BPF_MEMCG_CALL(memcg, op, default_val, ...) ({		\
+	typeof(default_val) __ret = (default_val);		\
+	struct memcg_bpf_ops *__ops;				\
+	int __idx;						\
+								\
+	if (unlikely(READ_ONCE((memcg)->bpf_ops))) {		\
+		__idx = srcu_read_lock(&memcg_bpf_srcu);	\
+		__ops = READ_ONCE((memcg)->bpf_ops);		\
+		if (__ops && __ops->op)				\
+			__ret = __ops->op(memcg, ##__VA_ARGS__);\
+		srcu_read_unlock(&memcg_bpf_srcu, __idx);	\
+	}							\
+	__ret;							\
+})
+
+/*
+ * BPF_MEMCG_CALL_VOID - Safely invoke a void BPF memcg callback
+ * @memcg: The memory cgroup whose bpf_ops to invoke
+ * @op:    The callback name (struct member of memcg_bpf_ops)
+ * @...:   Additional arguments forwarded to the callback
+ *
+ * Same SRCU fast-path pattern as BPF_MEMCG_CALL but for callbacks
+ * that have no return value.
+ */
+#define BPF_MEMCG_CALL_VOID(memcg, op, ...) do {		\
+	struct memcg_bpf_ops *__ops;				\
+	int __idx;						\
+								\
+	if (unlikely(READ_ONCE((memcg)->bpf_ops))) {		\
+		__idx = srcu_read_lock(&memcg_bpf_srcu);	\
+		__ops = READ_ONCE((memcg)->bpf_ops);		\
+		if (__ops && __ops->op)				\
+			__ops->op(memcg, ##__VA_ARGS__);	\
+		srcu_read_unlock(&memcg_bpf_srcu, __idx);	\
+	}							\
+} while (0)
+
+static inline bool
+bpf_memcg_below_low(struct mem_cgroup *memcg, unsigned long elow,
+		    unsigned long usage)
+{
+	return BPF_MEMCG_CALL(memcg, below_low, false, elow, usage);
+}
+
+static inline bool
+bpf_memcg_below_min(struct mem_cgroup *memcg, unsigned long emin,
+		    unsigned long usage)
+{
+	return BPF_MEMCG_CALL(memcg, below_min, false, emin, usage);
+}
+
+static inline unsigned long
+bpf_memcg_charged(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	unsigned int ret;
+
+	/*
+	 * Retrieve the BPF-specified throttle delay in milliseconds and
+	 * convert to jiffies for use in __mem_cgroup_handle_over_high().
+	 */
+	ret = BPF_MEMCG_CALL(memcg, memcg_charged, 0U, nr_pages);
+	return msecs_to_jiffies(ret);
+}
+
+static inline void
+bpf_memcg_uncharged(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	BPF_MEMCG_CALL_VOID(memcg, memcg_uncharged, nr_pages);
+}
+
+#undef BPF_MEMCG_CALL
+#undef BPF_MEMCG_CALL_VOID
+
+/*
+ * memcontrol_bpf_online - Inherit BPF ops for a newly online cgroup.
+ * @memcg: The memory cgroup coming online.
+ *
+ * Called under cgroup_mutex from mem_cgroup_css_online(). Inherits the
+ * parent's bpf_ops pointer and bpf_ops_flags into @memcg so that
+ * BPF-based memory control policies propagate down the hierarchy
+ * automatically.
+ *
+ * If the parent has no bpf_ops, this is a no-op. If it does, the ops
+ * pointer is copied and, if an online handler is implemented, it is
+ * invoked to allow the BPF program to initialize per-cgroup state for
+ * the new child.
+ *
+ * Locking: cgroup_mutex is held by the caller. Because bpf_memcg_ops_reg()
+ * and bpf_memcg_ops_unreg() also hold cgroup_mutex when writing
+ * memcg->bpf_ops, no additional lock on memcg_bpf_srcu is required here.
+ */
+extern void memcontrol_bpf_online(struct mem_cgroup *memcg);
+
+/*
+ * memcontrol_bpf_offline - Run BPF cleanup for a cgroup going offline.
+ * @memcg: The memory cgroup going offline.
+ *
+ * Called under cgroup_mutex from mem_cgroup_css_offline(). If a BPF
+ * program is attached and implements a handle_cgroup_offline callback,
+ * it is invoked so the program can release any per-cgroup state before
+ * the memcg is freed.
+ *
+ * Locking: same as memcontrol_bpf_online() — cgroup_mutex is held.
+ */
+extern void memcontrol_bpf_offline(struct mem_cgroup *memcg);
+
+#else /* CONFIG_BPF_SYSCALL */
+
+static inline unsigned long
+bpf_memcg_charged(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+	return 0;
+}
+
+static inline void
+bpf_memcg_uncharged(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+}
+
+static inline bool
+bpf_memcg_below_low(struct mem_cgroup *memcg, unsigned long elow,
+		    unsigned long usage)
+{
+	return false;
+}
+
+static inline bool
+bpf_memcg_below_min(struct mem_cgroup *memcg, unsigned long emin,
+		    unsigned long usage)
+{
+	return false;
+}
+
+static inline void memcontrol_bpf_online(struct mem_cgroup *memcg) { }
+static inline void memcontrol_bpf_offline(struct mem_cgroup *memcg) { }
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 static inline void mem_cgroup_protection(struct mem_cgroup *root,
 					 struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -603,21 +821,35 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long elow, usage;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.elow) >=
-		page_counter_read(&memcg->memory);
+	elow = READ_ONCE(memcg->memory.elow);
+	usage = page_counter_read(&memcg->memory);
+
+	if (bpf_memcg_below_low(memcg, elow, usage))
+		return true;
+
+	return elow >= usage;
 }
 
 static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 					struct mem_cgroup *memcg)
 {
+	unsigned long emin, usage;
+
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
-	return READ_ONCE(memcg->memory.emin) >=
-		page_counter_read(&memcg->memory);
+	emin = READ_ONCE(memcg->memory.emin);
+	usage = page_counter_read(&memcg->memory);
+
+	if (bpf_memcg_below_min(memcg, emin, usage))
+		return true;
+
+	return emin >= usage;
 }
 
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
@@ -890,12 +1122,18 @@ unsigned long mem_cgroup_get_zone_lru_size(struct lruvec *lruvec,
 	return READ_ONCE(mz->lru_zone_size[zone_idx][lru]);
 }
 
-void __mem_cgroup_handle_over_high(gfp_t gfp_mask);
+void __mem_cgroup_handle_over_high(gfp_t gfp_mask,
+				   unsigned long bpf_high_delay);
 
 static inline void mem_cgroup_handle_over_high(gfp_t gfp_mask)
 {
 	if (unlikely(current->memcg_nr_pages_over_high))
-		__mem_cgroup_handle_over_high(gfp_mask);
+		/*
+		 * Deferred user-return path: no BPF delay lookup here.
+		 * BPF-provided delay is injected from try_charge_memcg()
+		 * on the synchronous blocking charge path.
+		 */
+		__mem_cgroup_handle_over_high(gfp_mask, 0);
 }
 
 unsigned long mem_cgroup_get_max(struct mem_cgroup *memcg);
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..1f726a7b22e3 100644
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
@@ -179,15 +182,306 @@ static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
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
+	struct memcg_bpf_ops *ops;
+	struct mem_cgroup *parent_memcg;
+
+	/* The root cgroup does not inherit from a parent. */
+	if (mem_cgroup_is_root(memcg))
+		return;
+
+	/*
+	 * Because only functions bpf_memcg_ops_reg and bpf_memcg_ops_unreg
+	 * write to memcg->bpf_ops and memcg->bpf_ops_flags under the
+	 * protection of cgroup_mutex, ensuring that cgroup_mutex is already
+	 * locked here allows safe reading and writing of memcg->bpf_ops and
+	 * memcg->bpf_ops_flags without needing to acquire a lock on
+	 * memcg_bpf_srcu.
+	 */
+	lockdep_assert_held(&cgroup_mutex);
+
+	parent_memcg = parent_mem_cgroup(memcg);
+
+	/* Inherit the BPF program from the parent cgroup. */
+	ops = READ_ONCE(parent_memcg->bpf_ops);
+	if (!ops)
+		return;
+	WRITE_ONCE(memcg->bpf_ops, ops);
+	memcg->bpf_ops_flags = parent_memcg->bpf_ops_flags;
+
+	/*
+	 * If the BPF program implements it, call the online handler to
+	 * allow the program to perform setup tasks for the new cgroup.
+	 */
+	if (ops->handle_cgroup_online)
+		ops->handle_cgroup_online(memcg);
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
+	struct memcg_bpf_ops *ops;
+
+	/* Same locking rules as memcontrol_bpf_online(). */
+	lockdep_assert_held(&cgroup_mutex);
+
+	ops = READ_ONCE(memcg->bpf_ops);
+	if (!ops || !ops->handle_cgroup_offline)
+		return;
+
+	ops->handle_cgroup_offline(memcg);
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
+static bool
+cfi_below_low(struct mem_cgroup *memcg, unsigned long elow,
+	      unsigned long usage)
+{
+	return false;
+}
+
+static bool
+cfi_below_min(struct mem_cgroup *memcg, unsigned long emin,
+	      unsigned long usage)
+{
+	return false;
+}
+
+static unsigned int cfi_memcg_charged(struct mem_cgroup *memcg,
+				      unsigned int nr_pages)
+{
+	return 0;
+}
+
+static void cfi_memcg_uncharged(struct mem_cgroup *memcg, unsigned int nr_pages)
+{
+}
+
+static struct memcg_bpf_ops cfi_bpf_memcg_ops = {
+	.handle_cgroup_online = cfi_handle_cgroup_online,
+	.handle_cgroup_offline = cfi_handle_cgroup_offline,
+	.below_low = cfi_below_low,
+	.below_min = cfi_below_min,
+	.memcg_charged = cfi_memcg_charged,
+	.memcg_uncharged = cfi_memcg_uncharged,
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
+	case offsetof(struct memcg_bpf_ops, handle_cgroup_offline):
+	case offsetof(struct memcg_bpf_ops, below_low):
+	case offsetof(struct memcg_bpf_ops, below_min):
+	case offsetof(struct memcg_bpf_ops, memcg_charged):
+	case offsetof(struct memcg_bpf_ops, memcg_uncharged):
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (prog->sleepable)
+		return -EINVAL;
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
+static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *ops_link;
+	struct memcg_bpf_ops *ops = kdata, *old_ops;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg, *iter;
+	int err = 0;
+
+	if (!link)
+		return -EOPNOTSUPP;
+	ops_link = container_of(link, struct bpf_struct_ops_link, link);
+	if (!ops_link->cgroup)
+		return -EINVAL;
+
+	cgroup_lock();
+
+	css = cgroup_e_css(ops_link->cgroup, &memory_cgrp_subsys);
+	if (!css) {
+		err = -EINVAL;
+		goto unlock_out;
+	}
+	memcg = mem_cgroup_from_css(css);
+
+	/*
+	 * Check if memcg has bpf_ops and whether it is inherited from
+	 * parent.
+	 * If inherited and BPF_F_ALLOW_OVERRIDE is set, allow override.
+	 */
+	old_ops = READ_ONCE(memcg->bpf_ops);
+	if (old_ops) {
+		struct mem_cgroup *parent_memcg = parent_mem_cgroup(memcg);
+
+		if (!parent_memcg ||
+		    !(memcg->bpf_ops_flags & BPF_F_ALLOW_OVERRIDE) ||
+		    READ_ONCE(parent_memcg->bpf_ops) != old_ops) {
+			err = -EBUSY;
+			goto unlock_out;
+		}
+	}
+
+	/* Check for incompatible bpf_ops in descendants. */
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		struct memcg_bpf_ops *iter_ops = READ_ONCE(iter->bpf_ops);
+
+		if (iter_ops && iter_ops != old_ops) {
+			/* cannot override existing bpf_ops of sub-cgroup. */
+			mem_cgroup_iter_break(memcg, iter);
+			err = -EBUSY;
+			goto unlock_out;
+		}
+	}
+
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		WRITE_ONCE(iter->bpf_ops, ops);
+		iter->bpf_ops_flags = ops_link->flags;
+	}
+
+unlock_out:
+	cgroup_unlock();
+	return err;
+}
+
+/* Unregister the struct ops instance */
+static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *ops_link;
+	struct memcg_bpf_ops *ops = kdata;
+	struct cgroup_subsys_state *css;
+	struct mem_cgroup *memcg;
+	struct mem_cgroup *iter;
+	struct memcg_bpf_ops *parent_bpf_ops = NULL;
+	u32 parent_bpf_ops_flags = 0;
+
+	if (!link)
+		return;
+	ops_link = container_of(link, struct bpf_struct_ops_link, link);
+	if (!ops_link->cgroup)
+		return;
+
+	cgroup_lock();
+
+	css = cgroup_e_css(ops_link->cgroup, &memory_cgrp_subsys);
+	if (!css)
+		goto unlock_out;
+	memcg = mem_cgroup_from_css(css);
+
+	/* Get the parent bpf_ops and bpf_ops_flags */
+	iter = parent_mem_cgroup(memcg);
+	if (iter) {
+		parent_bpf_ops = READ_ONCE(iter->bpf_ops);
+		parent_bpf_ops_flags = iter->bpf_ops_flags;
+	}
+
+	iter = NULL;
+	while ((iter = mem_cgroup_iter(memcg, iter, NULL))) {
+		if (READ_ONCE(iter->bpf_ops) == ops) {
+			WRITE_ONCE(iter->bpf_ops, parent_bpf_ops);
+			iter->bpf_ops_flags = parent_bpf_ops_flags;
+		}
+	}
+
+unlock_out:
+	cgroup_unlock();
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
+	if (err2)
+		pr_warn("error while registering memcontrol bpf ops: %d\n",
+			err2);
+
+	return err ? err : err2;
 }
 late_initcall(bpf_memcontrol_init);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..ec912d19ef87 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2085,6 +2085,8 @@ static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
 	page_counter_uncharge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
+
+	bpf_memcg_uncharged(memcg, nr_pages);
 }
 
 /*
@@ -2473,8 +2475,12 @@ static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
  * Reclaims memory over the high limit. Called directly from
  * try_charge() (context permitting), as well as from the userland
  * return path where reclaim is always able to block.
+ *
+ * @bpf_high_delay is caller-provided extra delay. Callers that do
+ * not evaluate BPF delay (e.g. deferred return-path handling) pass 0.
  */
-void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
+void
+__mem_cgroup_handle_over_high(gfp_t gfp_mask, unsigned long bpf_high_delay)
 {
 	unsigned long penalty_jiffies;
 	unsigned long pflags;
@@ -2516,11 +2522,15 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
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
@@ -2578,6 +2588,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	struct mem_cgroup *orig_memcg;
+	unsigned long bpf_high_delay;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
@@ -2704,6 +2716,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (batch > nr_pages)
 		refill_stock(memcg, batch - nr_pages);
 
+	orig_memcg = memcg;
 	/*
 	 * If the hierarchy is above the normal consumption range, schedule
 	 * reclaim on returning to userland.  We can perform reclaim here
@@ -2746,6 +2759,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	bpf_high_delay = bpf_memcg_charged(orig_memcg, batch);
+
 	/*
 	 * Reclaim is set up above to be called from the userland
 	 * return path. But also attempt synchronous reclaim to avoid
@@ -2753,10 +2768,17 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * kernel. If this is successful, the return path will see it
 	 * when it rechecks the overage and simply bail out.
 	 */
-	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
-	    !(current->flags & PF_MEMALLOC) &&
-	    gfpflags_allow_blocking(gfp_mask))
-		__mem_cgroup_handle_over_high(gfp_mask);
+	if (!(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask)) {
+		/*
+		 * BPF high-delay is evaluated only on the synchronous
+		 * blocking path. The deferred user-return path calls
+		 * __mem_cgroup_handle_over_high() with bpf_high_delay == 0.
+		 */
+		if (bpf_high_delay ||
+		    current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH)
+			__mem_cgroup_handle_over_high(gfp_mask, bpf_high_delay);
+	}
 	return 0;
 }
 
@@ -4151,6 +4173,8 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	 */
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
+	memcontrol_bpf_online(memcg);
+
 	return 0;
 free_objcg:
 	for_each_node(nid) {
@@ -4188,6 +4212,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	zswap_memcg_offline_cleanup(memcg);
 
+	memcontrol_bpf_offline(memcg);
 	memcg_offline_kmem(memcg);
 	reparent_deferred_split_queue(memcg);
 	/*
-- 
2.43.0


