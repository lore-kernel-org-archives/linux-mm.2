Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF4DCF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394756B0027; Tue, 18 Nov 2025 20:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345A66B0028; Tue, 18 Nov 2025 20:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E6F26B009D; Tue, 18 Nov 2025 20:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0817D6B0027
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:35:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96FCA13A3EA
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:35:00 +0000 (UTC)
X-FDA: 84125637960.11.3661586
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FAC110000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:34:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kbmG10x1;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763516099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HJ3VjAT/1JRhW/gpt3j3I9moH9fANhCnAIifgJP2C6Y=;
	b=ZlggTZhC5HDs1GR2FPGR1CFYQw3TRFBq3G6NjH97V1XDf+iEqRPJxuGfgD83fYFRseGZpc
	7ivx3nZnDTuTaocW42Py1wYeuR/L+/UNdgaTN8JPBwCnWfEUrZ0kbNkDS+7Lg+Em+jP1Qt
	jpudHVtlzQ/hg2Oun/RFlR6SNiHhdKs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763516099; a=rsa-sha256;
	cv=none;
	b=TII7HHuPVK41IUo4wkQmS8uNRt1e0LhCi96N/drNCqpPChZHq5znx6J09A4pUuLoYtgST3
	vmOj7JiuzDdQKaydUdCxQvztXknmfFF3yIraE+mhCSeI3JunXW2XnCuM9eFfYJjgmIr/QK
	ENyS/xQqVlrL2AdXKVB76UFoiY46V/U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kbmG10x1;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763516096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HJ3VjAT/1JRhW/gpt3j3I9moH9fANhCnAIifgJP2C6Y=;
	b=kbmG10x1v1sq/VQ6AHV5R4kB5PubC/+/l3ZrfRLP/wFy1xZP8/qy4GdE9UW5kdM4uPXtZ8
	SmH/mg6LECTzFB7rnBzHBAZNPuPrqaFcxzYhl5B/QfKaY6y0LBjGnE4cg6Nm0/XOWcZJIY
	2oaObruik/d/Rt3Js9WWffWkGYu0J+s=
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	Geliang Tang <geliang@kernel.org>
Subject: [RFC PATCH 1/3] memcg: add eBPF struct ops support for memory charging
Date: Wed, 19 Nov 2025 09:34:06 +0800
Message-ID: <15f95166c6c516f303f3092e74c88ace5164bdf0.1763457705.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1763457705.git.zhuhui@kylinos.cn>
References: <cover.1763457705.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FAC110000B
X-Stat-Signature: 7ddceg8jftbi5d84q6s1yt1bnj6jpjpj
X-HE-Tag: 1763516098-794953
X-HE-Meta: U2FsdGVkX1+Xf1TZWoxiqWo06IborroARjFqPgGW+qGpQPHiCWeCcyNK+kEBHXQYuzZ9NO164UNmwFAfXNwyEPcdTJ8P/qvtPbtxZP0BupH2LHNToVBLk/+VyqIt1I+GJSK+OLk81kIQZNU0vtjfsf0x2hTLqJ7/cf+uW/vMnt86mgeYAXW1qCTlADgO7L06dNLU624duanuwFBfgYaWQ0+wWGRP9v8R7XWLDeZiaIEhBbjZjCQ4CP0HqzSijrzP3YTs2oaaVmWQL3RDt/xIH7B7SqIWsZR0k8FQljs2EJMq5nBxHi9nVQUEZ1K1JfcRpEvDoC8QD6ixyQNoIXgxG1/+ecpAmIg8VOaT1+/lnm5K+6TkdKLB1Hz+mmgPpRLhNOmWrAcur+pJq51/vwULEQfU5CaDDTz6yOAM0dt8+yzzEgVhNlYLeFmEQ132CE8fyK/M29mSJeUQsPuU5BKN14X5AoDewq8ujD9Id1WYRfNIkqZ2yZ2UUXblHxgrUEPOTGmt4sscMYhdml1AlS5BpBRjZjuKUa2abBX57ytgApv4HiAfT++9dFNJgqXr9YPSfXktEuJW6ifAFPRBeleMHZijbLE0CNphePosYbW4irMeqK3OnkzxF3auW4jfsBUlbhUP/842I3oVLzBe0nlMAeioi3AugAXI/zGT6tV8G5jxnOzjkG2ywX6iqxghpVmvH4ya6mxuNVeV5LNTfnTYH/jVNniorTTqJqE80NBzzkDwKNAEj+9/kA8j8Wlg8IL/R5++Vl8LIsXpoXiwtpra9MFCz5+lkrw5+cemvp7MKRbAglZ2hNhE50XbMs/mNs/aW8l7moQbudXX0tr1BJmj90xswuJ12FQnpOv+jwqfcgWH9BagwMAVrYMB95Lex46hinddxoEziGoSsXv1nFvthPQtRbm+TcdFTG/2+vo/CCtrQvXKtwjFCWl8CMH8VKXVkUNXSeL+tAx5x+fMtn/
 by0gfywQ
 og2AjNbms/mOt5abLCiTebX250ebbeYvn/49BAbZxU+fNOTwEA474Fb/CxxjdHBJDxVKFRMDpIwpFFrr6KqgKEoaaTIMewLlKJzjQDYCXhEzYv4MGaHqoproobmGmuFfMBMpCxAsBqAcCRx0pY56uPGp1xnbCecYehFAA5R2EMBcWHmnuouquOx3RKw1IBfr40YCCPCREVNDdcyFYwGQocrWVG5Vdvu3wAQZ76nXOWQUluf0dyRZhKo7QmdtQN+rLhvwP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add eBPF struct ops support to the memory controller, enabling
dynamic memory management policies via eBPF programs. This
allows users to implement custom memory charging and
reclamation strategies without kernel recompilation.

The implementation introduces:

- A new BPF struct ops type `memcg_ops` with a `try_charge_memcg`
  hook for intercepting memory charge operations
- Integration into the `try_charge_memcg()` function to call
  registered eBPF handlers
- Safe registration/unregistration via BPF struct ops
  infrastructure
- Reference counting using percpu_ref to track handler lifecycle
- Static branch keys to minimize overhead when disabled
- New Kconfig option CONFIG_MEMCG_BPF to control the feature

The eBPF handler receives a `try_charge_memcg` struct containing:
- Memory cgroup and affected memory cgroup
- GFP flags and page count
- Reclamation options
- Current charge status

Handlers can inspect this context and modify certain fields
(e.g., nr_pages) to adjust reclamation behavior. The design
enforces single active handler to avoid conflicts.

Use cases include:
- Custom memory policies for specialized workloads
- Memory pressure telemetry and monitoring
- Integration with container management systems
- Runtime memory management experimentation

Design decisions:
- Uses RCU synchronization for safe handler replacement
- Zero overhead when feature is disabled (via static keys)
- Single handler model prevents complexity and race conditions
- eBPF verifier restrictions ensure memory safety
- Minimal context exposure to reduce attack surface

Signed-off-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 MAINTAINERS         |   2 +
 init/Kconfig        |  38 +++++++++
 mm/Makefile         |   1 +
 mm/memcontrol.c     |  26 ++++--
 mm/memcontrol_bpf.c | 200 ++++++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol_bpf.h | 103 +++++++++++++++++++++++
 6 files changed, 363 insertions(+), 7 deletions(-)
 create mode 100644 mm/memcontrol_bpf.c
 create mode 100644 mm/memcontrol_bpf.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e64b94e6b5a9..498d01c9a48e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6351,6 +6351,8 @@ F:	include/linux/page_counter.h
 F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
+F:	mm/memcontrol_bpf.c
+F:	mm/memcontrol_bpf.h
 F:	mm/page_counter.c
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49..cde8f5cb5ffa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1063,6 +1063,44 @@ config MEMCG_V1
 
 	  Say N if unsure.
 
+config MEMCG_BPF
+	bool "Memory controller eBPF support"
+	depends on MEMCG
+	depends on BPF_SYSCALL
+	default n
+	help
+	  This option enables eBPF support for the memory controller,
+	  allowing eBPF programs to hook into memory charging
+	  operations and implement custom memory management policies
+	  at runtime.
+
+	  With this feature enabled, administrators can load eBPF
+	  programs to monitor and adjust memory charging behavior
+	  without recompiling the kernel. This enables:
+
+	  - Custom memory reclamation strategies for specialized
+	    workloads
+	  - Dynamic memory pressure telemetry and monitoring
+	  - Memory accounting adjustments based on runtime conditions
+	  - Integration with container orchestration systems
+	  - Experimentation with novel memory management algorithms
+
+	  The eBPF handler is invoked during memory charge attempts
+	  and can inspect memory cgroup context and optionally modify
+	  parameters like reclamation size.
+
+	  When this feature is disabled or no eBPF program is loaded,
+	  there is zero performance overhead. When enabled with an
+	  active program, overhead is minimal (one indirect function
+	  call per charge attempt). The eBPF verifier ensures memory
+	  safety of loaded programs.
+
+	  Only one eBPF program can be active at a time. Loading a
+	  new program requires appropriate BPF permissions
+	  (CAP_PERFMON or CAP_SYS_ADMIN).
+
+	  Say N if unsure.
+
 config BLK_CGROUP
 	bool "IO controller"
 	depends on BLOCK
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..5ac2fa7a8a74 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
+obj-$(CONFIG_MEMCG_BPF) += memcontrol_bpf.o
 ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4deda33625f4..104c9e9309f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -68,6 +68,7 @@
 #include <net/ip.h>
 #include "slab.h"
 #include "memcontrol-v1.h"
+#include "memcontrol_bpf.h"
 
 #include <linux/uaccess.h>
 
@@ -2301,13 +2302,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
-	unsigned long nr_reclaimed;
+	unsigned long nr_reclaime, nr_reclaimed;
 	bool passed_oom = false;
 	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool charge_done = false;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
@@ -2320,20 +2322,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
-			goto done_restock;
-		if (do_memsw_account())
-			page_counter_uncharge(&memcg->memsw, batch);
-		mem_over_limit = mem_cgroup_from_counter(counter, memory);
+			charge_done = true;
+		else {
+			if (do_memsw_account())
+				page_counter_uncharge(&memcg->memsw, batch);
+			mem_over_limit = mem_cgroup_from_counter(counter, memory);
+		}
 	} else {
 		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
 		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
 	}
 
-	if (batch > nr_pages) {
+	if (!charge_done && batch > nr_pages) {
 		batch = nr_pages;
 		goto retry;
 	}
 
+	nr_reclaime = bpf_try_charge_memcg(memcg, gfp_mask, nr_pages,
+					   mem_over_limit,
+					   reclaim_options,
+					   charge_done);
+
+	if (charge_done)
+		goto done_restock;
+
 	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
@@ -2353,7 +2365,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
-	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
+	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_reclaime,
 						    gfp_mask, reclaim_options, NULL);
 	psi_memstall_leave(&pflags);
 
diff --git a/mm/memcontrol_bpf.c b/mm/memcontrol_bpf.c
new file mode 100644
index 000000000000..0bdb2a147a50
--- /dev/null
+++ b/mm/memcontrol_bpf.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Memory Controller eBPF support
+ *
+ * Author: Hui Zhu <zhuhui@kylinos.cn>
+ * Copyright (C) 2025 KylinSoft Corporation.
+ */
+
+#include <linux/cgroup-defs.h>
+#include <linux/page_counter.h>
+#include <linux/memcontrol.h>
+#include <linux/cgroup.h>
+#include <linux/rcupdate.h>
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/module.h>
+#include "memcontrol_bpf.h"
+
+struct memcg_ops __rcu *memcg_ops;
+DEFINE_STATIC_KEY_FALSE(memcg_bpf_enable);
+
+static void memcg_ops_release(struct percpu_ref *ref)
+{
+	struct memcg_ops *ops = container_of(ref,
+		struct memcg_ops, refcount);
+
+	/* Signal destruction completion */
+	complete(&ops->destroy_done);
+}
+
+static int memcg_ops_btf_struct_access(struct bpf_verifier_log *log,
+					const struct bpf_reg_state *reg,
+					int off, int size)
+{
+	size_t end;
+
+	switch (off) {
+	case offsetof(struct try_charge_memcg, nr_pages):
+		end = offsetofend(struct try_charge_memcg, nr_pages);
+		break;
+	default:
+		return -EACCES;
+	}
+
+	if (off + size > end)
+		return -EACCES;
+
+	return 0;
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
+static int cfi_try_charge_memcg(struct try_charge_memcg *tcm)
+{
+	return -EINVAL;
+}
+
+static struct memcg_ops cfi_bpf_memcg_ops = {
+	.try_charge_memcg = cfi_try_charge_memcg,
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
+	case offsetof(struct memcg_ops, try_charge_memcg):
+	case offsetof(struct memcg_ops, refcount):
+	case offsetof(struct memcg_ops, destroy_done):
+		break;
+	default:
+		if (prog->sleepable)
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int default_try_charge_memcg(struct try_charge_memcg *tcm)
+{
+	return 0;
+}
+
+static int bpf_memcg_ops_init_member(const struct btf_type *t,
+				const struct btf_member *member,
+				void *kdata, const void *udata)
+{
+	struct memcg_ops *ops = (struct memcg_ops *)kdata;
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+	int ret;
+
+	if (moff == offsetof(struct memcg_ops, refcount)) {
+		ret = percpu_ref_init(&ops->refcount, memcg_ops_release, 0, GFP_KERNEL);
+		if (ret) {
+			pr_err("Failed to percpu_ref_init: %d\n", ret);
+			return ret;
+		}
+
+		init_completion(&ops->destroy_done);
+
+		if (!ops->try_charge_memcg)
+			ops->try_charge_memcg = default_try_charge_memcg;
+	}
+
+	return 0;
+}
+
+static int bpf_memcg_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct memcg_ops *new_ops, *old_ops;
+
+	/*
+	 * Check if ops already exists.
+	 * just get old_ops but not keep lock because
+	 * caller has locked st_map->lock.
+	 */
+	rcu_read_lock();
+	old_ops = rcu_dereference(memcg_ops);
+	rcu_read_unlock();
+	if (old_ops)
+		return -EEXIST;
+
+	new_ops = kdata;
+
+	/* Atomically set ops pointer (should be NULL at this point) */
+	old_ops = rcu_replace_pointer(memcg_ops, new_ops, true);
+	WARN_ON(old_ops);
+
+	static_branch_enable(&memcg_bpf_enable);
+
+	return 0;
+}
+
+/* Unregister the struct ops instance */
+static void bpf_memcg_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct memcg_ops *ops;
+
+	static_branch_disable(&memcg_bpf_enable);
+
+	/* Not lock same with bpf_memcg_ops_reg. */
+	ops = rcu_replace_pointer(memcg_ops, NULL, true);
+	if (ops) {
+		synchronize_rcu();
+
+		percpu_ref_kill(&ops->refcount);
+		wait_for_completion(&ops->destroy_done);
+
+		percpu_ref_exit(&ops->refcount);
+	}
+}
+
+static struct bpf_struct_ops bpf_memcg_ops = {
+	.verifier_ops = &bpf_memcg_verifier_ops,
+	.init = bpf_memcg_ops_init,
+	.check_member = bpf_memcg_ops_check_member,
+	.init_member = bpf_memcg_ops_init_member,
+	.reg = bpf_memcg_ops_reg,
+	.unreg = bpf_memcg_ops_unreg,
+	.name = "memcg_ops",
+	.owner = THIS_MODULE,
+	.cfi_stubs = &cfi_bpf_memcg_ops,
+};
+
+static int __init memcontrol_bpf_init(void)
+{
+	int err;
+
+	RCU_INIT_POINTER(memcg_ops, NULL);
+
+	err = register_bpf_struct_ops(&bpf_memcg_ops, memcg_ops);
+	if (err) {
+		pr_warn("error while registering bpf memcg_ops: %d\n", err);
+		return err;
+	}
+
+	pr_info("bpf memcg_ops registered successfully\n");
+	return 0;
+}
+late_initcall(memcontrol_bpf_init);
diff --git a/mm/memcontrol_bpf.h b/mm/memcontrol_bpf.h
new file mode 100644
index 000000000000..ee2815fc3d05
--- /dev/null
+++ b/mm/memcontrol_bpf.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/* memcontrol_bpf.h - Memory Controller eBPF support
+ *
+ * Author: Hui Zhu <zhuhui@kylinos.cn>
+ * Copyright (C) 2025 KylinSoft Corporation.
+ */
+
+#ifndef _LINUX_MEMCONTROL_BPF_H
+#define _LINUX_MEMCONTROL_BPF_H
+
+#ifdef CONFIG_MEMCG_BPF
+
+struct try_charge_memcg {
+	struct mem_cgroup *memcg;
+	gfp_t gfp_mask;
+	unsigned long nr_pages;
+	struct mem_cgroup *mem_over_limit;
+	unsigned int reclaim_options;
+	bool charge_done;
+};
+
+struct memcg_ops {
+	int (*try_charge_memcg)(struct try_charge_memcg *tcm);
+	struct percpu_ref refcount;
+	struct completion destroy_done;
+};
+
+extern struct memcg_ops __rcu *memcg_ops;
+DECLARE_STATIC_KEY_FALSE(memcg_bpf_enable);
+
+static inline struct memcg_ops *memcg_ops_get(void)
+{
+	struct memcg_ops *ops;
+
+	rcu_read_lock();
+	ops = rcu_dereference(memcg_ops);
+	if (likely(ops)) {
+		if (unlikely(!percpu_ref_tryget_live(&ops->refcount)))
+			ops = NULL;
+	}
+	rcu_read_unlock();
+
+	return ops;
+}
+
+static inline void memcg_ops_put(struct memcg_ops *ops)
+{
+	percpu_ref_put(&ops->refcount);
+}
+
+static inline unsigned long
+bpf_try_charge_memcg(struct mem_cgroup *memcg,
+		     gfp_t gfp_mask,
+		     unsigned int nr_pages,
+		     struct mem_cgroup *mem_over_limit,
+		     unsigned int reclaim_options,
+		     bool charge_done)
+{
+	struct memcg_ops *ops;
+	struct try_charge_memcg tcm;
+	int update_nr_pages;
+
+	if (likely(!static_branch_unlikely(&memcg_bpf_enable)))
+		goto out;
+
+	ops = memcg_ops_get();
+	if (unlikely(!ops))
+		goto out;
+
+	tcm.memcg = memcg;
+	tcm.gfp_mask = gfp_mask;
+	tcm.nr_pages = nr_pages;
+	tcm.mem_over_limit = mem_over_limit;
+	tcm.reclaim_options = reclaim_options;
+	tcm.charge_done = charge_done;
+
+	update_nr_pages = ops->try_charge_memcg(&tcm);
+
+	memcg_ops_put(ops);
+
+	if (update_nr_pages && !charge_done && tcm.nr_pages &&
+	    tcm.nr_pages <= HPAGE_PMD_NR)
+		nr_pages = tcm.nr_pages;
+
+out:
+	return nr_pages;
+}
+
+#else
+
+#define bpf_try_charge_memcg(memcg, gfp_mask, nr_pages, \
+			     mem_over_limit, reclaim_options, \
+			     charge_done) \
+			     ((void)memcg, \
+			      (void)gfp_mask, \
+			      nr_pages, \
+			      (void)mem_over_limit, \
+			      (void)reclaim_options, \
+			      (void)charge_done)
+
+#endif
+
+#endif
-- 
2.43.0


