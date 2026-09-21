Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0FDC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EBFE6B00C3; Mon, 21 Sep 2026 15:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C48B6B00C5; Mon, 21 Sep 2026 15:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D87A6B00C7; Mon, 21 Sep 2026 15:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 220BE6B00C3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:26:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB05D1602B5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:25 +0000 (UTC)
X-FDA: 85238750730.16.BAEDB7F
Received: from mta1.migadu.com (out-100.mta1.migadu.com [95.215.58.100])
	by imf18.hostedemail.com (Postfix) with ESMTP id 773631C0009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wFx/yzM/";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790018783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2m4oRpUkR2vVSm9z+KqoO2GjdHKb41OEmUJERsqeVQ=;
	b=m1AXiA5s8OkXzwjBCwe43ncvqUOeR9P78z1m6twAq9IxUw1OQo5uskgKqj82Y4Pyx8eovz
	e/CVAIR1dtYoCx4NrQB25gi7uQU8oR6/Kftqa4iGfgfHKheYyZeWqVBgTOb8id4rw78nD7
	LXyMT0D4rV5bUZh0sCHaV5CPKDHgX1Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wFx/yzM/";
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.100 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790018783;
	b=aDERnmEqa4Xmz6cFEBD4vjxqaKEOFFwA5Yy6DSArGFK8SJpcyAQTZpsvl7st7+QRY6HpWq
	FLakwdd5/RhDRFExvP88e++WGcG6VXzqmUnZqOundpJmUzSzsn82S0US/o9qe08ByR4Vfy
	YXlY6sz/du3caFLSu8Uz6II4YuJG32g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rk6vSHsZulU3ylU3QojCy3TlgitfGn9MgxeNvIoe+1s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018782; v=1; x=1790623582;
 b=wFx/yzM/t0ddWiHKQ4sYhMKhbWztXPPDtYNJSk9Ge2JyyQsROoisSAFq8JqScjtDlQ/yFrRn
 46Zevvsy0S9rPQl8Xtb7RMP1pXdMCTGlxuxvR7QoL2e+m3WY4dtE8k4MdewwkgYgmZK4dNprhZv
 vlMLv7xnHzWqyPRliFtx8/r8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9b07036d47c80b85;
	Mon, 21 Sep 2026 19:26:21 +0000
X-Mizu-Trace-ID: 9b07036d47c80b85
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/4] memcg_ext: add cgroup-attached bpf_memcg_ops
Date: Mon, 21 Sep 2026 12:25:57 -0700
Message-ID: <20260921192559.2619635-3-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 773631C0009
X-Stat-Signature: gzxaj94hone5jxd4qqe3tfjmpmsrzhkf
X-Rspam-User: 
X-HE-Tag: 1790018783-973844
X-HE-Meta: U2FsdGVkX18Mgpp+0InAt/KaeCb8nr9mZD3B8gWcMA+WqcAVWZiOGI4ZpTDVLPQbRjXyT8dmUcegXyChlBs2Rmo+nOi53m2udoTE5V81UjCw7LkJNGcT65mHnLNrVpKPjdV/rHccZx785JQzr5VwJSTUW2rC0YXRam6k7xP43qXA3fqZItXGd1Ny+fWFrYcxCPtjDZoH3fSnedgnf22AV7IFtdXL0ZTz3HZjnVRNnL1YsQ7U6MDtNBmmzs57XEm91Zrp0Zlpnp+9waJj+ypVo5RXCV1pS/ba+ScT1x9XK9Z264ENM16JYxAdXv3JKLCrSUbRaXjN6QDhq5rhH2iojEKRGYNIn6/9w3GQAyAKF/NPukWcLX0BD51wjJhHBYXAcmCZG2gDrYWSE+FX9Bgm81xEQcq2XF+8Qi8pZR+N+BORKF/lRrD/njseonldRSYR/Cp5SCx6lqwZpCgkUwl2TMxFJjcpVZcTNSR8d1KjzPrNu0ScR0D7ShoVYwrm+tGtnlpQmqcS7oDHZuoxuqyg+JE7VoJu/O9eeTdzUqtmDD/dqBbKBAEW7TKaDyDMZqsMd/OwHFRCbxkuGd8RlSSbWCfve9DSDefCSwRHppN8eYvbHY4hc39nbVSFQBRJEjekPzEzNpfoQxZ631FlA8Vf1mNJR9EhXx+5QynRUl2e6Ch1+whRziR7qN4t9rRkHPA0qcr/veVHeYctqqFvLMqT8X86Y7Pm0A11TYzPKYgbakYQlPy5YtYWkhFcReebIJu2Wi40gUEUS6B706rCgVJAGMKEMxD0YQDMY9bGrc9BrLkqKzmC2NwiMvKBO/41VRWPkbbPqgqMZyZLsRFPb5s3GomHT6A65du+tUXT7bhezvVdI6wbEMoLcl48xTyYvGFvmBlK68+psKh/znoo3nVTzye4RwHSL21GBb1oz6seTGaS9FQXKMWyVKU+xmcrPu97/AawAIMOZ0t/P5zE2WB
 pjv4KwQK
 0+oEcM+RoTeM0/GNVDNTkKGEjPeG3xwtUv/ZdpQuOYJ6ueJS+oR9iIyWULtn5ZWZL8zSxCLHeYzvzrE0XlGe3Ri/b6HiWFDA7W6mq/quTn5fFG/r+OKsRfiDkL4kfDLU3G/A7suSUVNUnVzm7TqTwQ/uiYA8xQ/RF7lBF6Xc+C02G4vwnAHbap5mMEZFKlFMut97rsFJXG5Zm8Dhi3vI6LvEwMwXS3kMEBSDtVqT57ppIocxwGc97tf5AQdjWUiUqmJ4G//2p+YDdwsyqR8Z4uiRq73JTi6jmBIb2pLmzGDDzmEg4ExheMKpegP5GyZgNv+QA8oV4KZuVs2JYkDFq+8TLlisKpmFgrLn2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an empty bpf_memcg_ops type for attaching memory policies to
cgroups.  This is the first patch of memcg_ext, which makes memcg
enforcement programmable one hook at a time.  Policy hooks will be added
later.

Move the cgroup BPF attach types outside CONFIG_CGROUP_BPF and fix the
struct_ops registration stub so all supported configurations build.

This does not change behavior yet.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/bpf-cgroup-defs.h |  22 ++++---
 include/linux/bpf-cgroup.h      |   2 +-
 include/linux/bpf.h             |   2 +-
 include/linux/bpf_memcontrol.h  |  17 +++++
 mm/bpf_memcontrol.c             | 108 +++++++++++++++++++++++++++++++-
 5 files changed, 140 insertions(+), 11 deletions(-)
 create mode 100644 include/linux/bpf_memcontrol.h

diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 0147b8bec973..53d2853535c6 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -2,14 +2,6 @@
 #ifndef _BPF_CGROUP_DEFS_H
 #define _BPF_CGROUP_DEFS_H
 
-#ifdef CONFIG_CGROUP_BPF
-
-#include <linux/list.h>
-#include <linux/percpu-refcount.h>
-#include <linux/workqueue.h>
-
-struct bpf_prog_array;
-
 #ifdef CONFIG_BPF_LSM
 /* Maximum number of concurrently attachable per-cgroup LSM hooks. */
 #define CGROUP_LSM_NUM 10
@@ -17,6 +9,10 @@ struct bpf_prog_array;
 #define CGROUP_LSM_NUM 0
 #endif
 
+/*
+ * Plain constants, so a subsystem can name its attach type without
+ * depending on CONFIG_CGROUP_BPF.
+ */
 enum cgroup_bpf_attach_type {
 	CGROUP_BPF_ATTACH_TYPE_INVALID = -1,
 	CGROUP_INET_INGRESS = 0,
@@ -48,11 +44,21 @@ enum cgroup_bpf_attach_type {
 	CGROUP_UNIX_GETSOCKNAME,
 	CGROUP_INET_SOCK_RELEASE,
 	CGROUP_TCP_SOCK_OPS,
+	CGROUP_MEMCG_OPS,
 	CGROUP_LSM_START,
 	CGROUP_LSM_END = CGROUP_LSM_START + CGROUP_LSM_NUM - 1,
 	MAX_CGROUP_BPF_ATTACH_TYPE
 };
 
+#ifdef CONFIG_CGROUP_BPF
+
+#include <linux/list.h>
+#include <linux/percpu-refcount.h>
+#include <linux/workqueue.h>
+
+struct bpf_prog_array;
+
+
 struct cgroup_bpf {
 	/* array of effective progs in this cgroup */
 	struct bpf_prog_array __rcu *effective[MAX_CGROUP_BPF_ATTACH_TYPE];
diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 3b2c127d401d..4e8150848bd2 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -127,7 +127,7 @@ struct bpf_prog_list {
 
 static inline bool cgroup_bpf_is_struct_ops_atype(enum cgroup_bpf_attach_type atype)
 {
-	return atype == CGROUP_TCP_SOCK_OPS;
+	return atype == CGROUP_TCP_SOCK_OPS || atype == CGROUP_MEMCG_OPS;
 }
 void cgroup_bpf_struct_ops_register(int atype, u32 type_id, void *cfi_stubs, bool mult_trace);
 int cgroup_bpf_struct_ops_attach(struct bpf_map *map, const union bpf_attr *attr);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5033b934ffd9..f8eb102e7fc4 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2331,7 +2331,7 @@ int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
 void bpf_map_struct_ops_info_fill(struct bpf_map_info *info, struct bpf_map *map);
 void bpf_struct_ops_desc_release(struct bpf_struct_ops_desc *st_ops_desc);
 #else
-#define register_bpf_struct_ops(st_ops, type) ({ (void *)(st_ops); 0; })
+#define register_bpf_struct_ops(st_ops, type) ({ (void)(st_ops); 0; })
 static inline bool bpf_try_module_get(const void *data, struct module *owner)
 {
 	return try_module_get(owner);
diff --git a/include/linux/bpf_memcontrol.h b/include/linux/bpf_memcontrol.h
new file mode 100644
index 000000000000..8204d894761e
--- /dev/null
+++ b/include/linux/bpf_memcontrol.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF policy hooks for the memory controller.
+ *
+ * A bpf_memcg_ops is attached to a cgroup.  A charge runs the policies of
+ * that cgroup and of every ancestor, and the kernel combines what they
+ * return.  BPF only picks between things the kernel already does.
+ *
+ * The type has no members yet; they come with the policies that use them.
+ */
+#ifndef _LINUX_BPF_MEMCONTROL_H
+#define _LINUX_BPF_MEMCONTROL_H
+
+struct bpf_memcg_ops {
+};
+
+#endif /* _LINUX_BPF_MEMCONTROL_H */
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..fd6dff150f01 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -7,6 +7,12 @@
 
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
+#include <linux/bpf-cgroup.h>
+#include <linux/bpf_memcontrol.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf_ids.h>
+#include <linux/cgroup.h>
+#include <linux/sched.h>
 
 #include "internal.h"
 
@@ -235,6 +241,100 @@ static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
 	.set            = &bpf_memcontrol_reclaim_kfuncs,
 };
 
+/*
+ * bpf_memcg_ops: memcg policy attached to a cgroup.  A program returns a
+ * request and the kernel acts on it.  Nothing here reclaims or sleeps.
+ */
+
+/* CFI stubs.  A slot points at these while its policy is being detached. */
+static struct bpf_memcg_ops __bpf_memcg_ops = {
+};
+
+static const struct bpf_func_proto *
+bpf_memcg_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	/*
+	 * The base set is all a policy needs today, and none of it sleeps.
+	 * Anything added here must be safe from the charge path.
+	 */
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static bool bpf_memcg_is_valid_access(int off, int size,
+				      enum bpf_access_type type,
+				      const struct bpf_prog *prog,
+				      struct bpf_insn_access_aux *info)
+{
+	/* The context is read-only. */
+	if (type != BPF_READ)
+		return false;
+
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static int bpf_memcg_init_member(const struct btf_type *t,
+				 const struct btf_member *member,
+				 void *kdata, const void *udata)
+{
+	/* Mandatory: the core calls it without a NULL check. */
+	return 0;
+}
+
+static int bpf_memcg_check_member(const struct btf_type *t,
+				  const struct btf_member *member,
+				  const struct bpf_prog *prog)
+{
+	/* Members run from the charge path, which cannot sleep. */
+	if (prog->sleepable)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int bpf_memcg_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_memcg_validate(void *kdata)
+{
+	return 0;
+}
+
+static const struct bpf_verifier_ops bpf_memcg_verifier_ops = {
+	.get_func_proto		= bpf_memcg_get_func_proto,
+	.is_valid_access	= bpf_memcg_is_valid_access,
+};
+
+static struct bpf_struct_ops bpf_memcg_ops_desc = {
+	.verifier_ops	= &bpf_memcg_verifier_ops,
+	.init		= bpf_memcg_init,
+	.init_member	= bpf_memcg_init_member,
+	.check_member	= bpf_memcg_check_member,
+	.validate	= bpf_memcg_validate,
+	.name		= "bpf_memcg_ops",
+	.cgroup_atype	= CGROUP_MEMCG_OPS,
+	.cfi_stubs	= &__bpf_memcg_ops,
+	.owner		= THIS_MODULE,
+	/*
+	 * .reg/.unreg stay NULL: the cgroup layer does attach and detach, and
+	 * registration fails if a cgroup_atype comes with either.
+	 *
+	 * .free_after_mult_rcu_gp stays false while no member sleeps.  A
+	 * sleepable one would also need a tasks-trace RCU version of
+	 * bpf_cgroup_struct_ops_foreach().
+	 */
+};
+
+static int __init bpf_memcg_ops_register(void)
+{
+	/*
+	 * register_bpf_struct_ops() is a no-op without struct_ops support, so
+	 * this needs no guard of its own.
+	 */
+	return register_bpf_struct_ops(&bpf_memcg_ops_desc, bpf_memcg_ops);
+}
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
@@ -248,8 +348,14 @@ static int __init bpf_memcontrol_init(void)
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
 					&bpf_memcontrol_reclaim_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error registering bpf reclaim kfuncs: %d\n", err);
+		return err;
+	}
+
+	err = bpf_memcg_ops_register();
+	if (err)
+		pr_warn("error while registering bpf_memcg_ops: %d", err);
 
 	return err;
 }
-- 
2.53.0-Meta


