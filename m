Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070FBD25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0D96B0098; Mon, 26 Jan 2026 21:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AF1A6B0099; Mon, 26 Jan 2026 21:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7D96B009B; Mon, 26 Jan 2026 21:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AE8C6B0098
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA3F7BC178
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:55 +0000 (UTC)
X-FDA: 84376201350.03.4AD2834
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0E6D5A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2nK62HA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PHaA2+5weS8eMVRt0w0C41HRb3xuqgYUHYcE0aRYLk=;
	b=P15Sh3ipUNl5dVNVtoYo0BkIoFDcQrkZIwkTSh0cqlRLDIo7RR7KOJhf4qIYvLJ6AYELTh
	sH0pAeTwW0woKXokGrxueWBb3VyCK+dYswmnO2pvyeqxGJm//OGyBDy1SHcq3zrifVWqp5
	MKGV4XES2Sib/jnn73vKM6ZH9fVc+cw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481894; a=rsa-sha256;
	cv=none;
	b=w6qZZmErquDoOLn0chL0FbkvBrfypb47cWvI5nRK1lEs0GbBYTWpGSPei1J6MeJD83lp/Y
	H3JB97HhLpY7XonwBfq3baG0LQ4oHG7dieCyWV8Ht6kKox7GErBoN0KGQk/uC7JOUjNXoS
	bcq2p3h5lHOcGDZWmC5R9gEy9gs7ATY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r2nK62HA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/PHaA2+5weS8eMVRt0w0C41HRb3xuqgYUHYcE0aRYLk=;
	b=r2nK62HAUpJgtaVgR9wcxmPF5WBN7yrbWIiPNAeIkNI/RPqTsKGe6ktWP9lW5F867uVOe+
	bXuqAwfECgywick13UfqRJNlK0fAjpTe4vLxsSt8eBnxKA5oxNo0Z7qcYBm9b3MEYh48g7
	A3utZOabrRMvrYAesNh4JONgVmbMKCc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 07/17] mm: introduce BPF OOM struct ops
Date: Mon, 26 Jan 2026 18:44:10 -0800
Message-ID: <20260127024421.494929-8-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0E6D5A0003
X-Stat-Signature: 3azaoa74j916ps47ch87kitk3w4dxrdg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769481893-418045
X-HE-Meta: U2FsdGVkX1+mVFwLq/LLImelhWUqg3i9RuwYeMTrMqZZw0th73tghsLDkmIfcUSHmqurYQRCgTYlUS9gwwSlo0X/gTD+ntGq32aEnCp92H0mZnU0OOLKHVrZ2V+eeD8xp+4aJJNdz7KTZlYM7/co8UTUPDnkzjBxsqJfb6qewAzSop4SX0pAwwn9dCw447k9r1GXGPEuOjfkJQ54cNR5skp1UlRIRmsn1Ns+z8+AaNjTQ6mE6Nb/+w8CJXDdB4ckay78J8sYQPWiVI8vCCigadb5+a9mRpNauGM8FX0PDp0scLKw05VUHX5N4ZqM5ZIsXT8FlORtUZxfX1v4WU6vJJ6rHd+lSBzUXAKgShTGLqwCaI9RVRMi5AaobPeP1BnaHEDZOQK/5+A2qzqlU0zbxJc39aVoAyB+rHxUS3mlZnKKkv2dbUXeM80IX17qtK/NX5YKlZoJtckqbKV9mIWxq03hu9uw97mZf/RJJH4XV9UeVTelhRWZsULYJFn+IM2YXLMEDlf4Sh76sbfN1//LjfY7BKBkZ8Ps4bh76YwGa0GAfk0SHrm/XNk0RVDb6J6Z2fwTHqfg8qp9X2Cuva3As7pd37bkTq00uW14Na4nhA6xATNXVJWY2gfe4QY/+PaaKOlABDGWDJU7APVG09/PW3X9m2K+qffEFOXRzzpo3ezdz3nWdSiejK9N8Pn45fhIr2cUGQKtfLEUlFbO51XVOdmlCR9e8wlJPia4pI2SznYTXZCO4xhxXWcxGh5m/bGVDmJpAvzj1uSFozl6Us/13moYi2nL/KOoHVTVeiN6sls7RhVikbYQuWJlst2xbA3r2Hs9dsmgbA3RS7UErCOsvKqaixDJarx+4z6u3oNUyBUhF40LPlVVqOwa2egqe7wfz0yxmNnSLMbhaZao7UZNxwO6D1/T1XK6JYMTntGzoPUgO/BE/q7mEoPPSe4i6DLdOX0SV5L2xZg0jja44PS
 v7amZU4I
 pn6BLW6IFNxYdpnjUYKplfs9upomnSicNXslHFJvbhBCwLgyxGS6Um4riGvvgZROWY0fUObYPoZTI6Rk5EysQPeWDVpX7qRIQ3Bm5v5MCbld1oTHFPtbh5y9VOzj4PR2F4S487SNzpo2N9GoWVPgMfG68dmFMtGoBaofMvkd3wFTAlfthssEJjsXZofiBFZa8mndvYUlXDEV0ZGjHm822OLODczJjfqsycnQD25s8uANVLBpe8nSvWTBsNewSMr7nkL2mEVbkg28/wntFaQa77Qx1e4c6xvi8BRyY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a bpf struct ops for implementing custom OOM handling
policies.

It's possible to load one bpf_oom_ops for the system and one
bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
cgroup tree is traversed from the OOM'ing memcg up to the root and
corresponding BPF OOM handlers are executed until some memory is
freed. If no memory is freed, the kernel OOM killer is invoked.

The struct ops provides the bpf_handle_out_of_memory() callback,
which expected to return 1 if it was able to free some memory and 0
otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
field of the oom_control structure, which is expected to be set by
kfuncs suitable for releasing memory (which will be introduced later
in the patch series). If both are set, OOM is considered handled,
otherwise the next OOM handler in the chain is executed: e.g. BPF OOM
attached to the parent cgroup or the kernel OOM killer.

The bpf_handle_out_of_memory() callback program is sleepable to allow
using iterators, e.g. cgroup iterators. The callback receives struct
oom_control as an argument, so it can determine the scope of the OOM
event: if this is a memcg-wide or system-wide OOM. It also receives
bpf_struct_ops_link as the second argument, so it can detect the
cgroup level at which this specific instance is attached.

The bpf_handle_out_of_memory() callback is executed just before the
kernel victim task selection algorithm, so all heuristics and sysctls
like panic on oom, sysctl_oom_kill_allocating_task and
sysctl_oom_kill_allocating_task are respected.

The struct ops has the name field, which allows to define a custom
name for the implemented policy. It's printed in the OOM report
in the oom_handler=<name> format only if a bpf handler is invoked.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 MAINTAINERS                     |   2 +
 include/linux/bpf-cgroup-defs.h |   3 +
 include/linux/bpf.h             |   1 +
 include/linux/bpf_oom.h         |  46 ++++++++
 include/linux/oom.h             |   8 ++
 kernel/bpf/bpf_struct_ops.c     |  12 +-
 mm/Makefile                     |   2 +-
 mm/bpf_oom.c                    | 192 ++++++++++++++++++++++++++++++++
 mm/oom_kill.c                   |  19 ++++
 9 files changed, 282 insertions(+), 3 deletions(-)
 create mode 100644 include/linux/bpf_oom.h
 create mode 100644 mm/bpf_oom.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 491d567f7dc8..53465570c1e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4807,7 +4807,9 @@ M:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	bpf@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	include/linux/bpf_oom.h
 F:	mm/bpf_memcontrol.c
+F:	mm/bpf_oom.c
 
 BPF [MISC]
 L:	bpf@vger.kernel.org
diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
index 6c5e37190dad..52395834ce13 100644
--- a/include/linux/bpf-cgroup-defs.h
+++ b/include/linux/bpf-cgroup-defs.h
@@ -74,6 +74,9 @@ struct cgroup_bpf {
 	/* list of bpf struct ops links */
 	struct list_head struct_ops_links;
 
+	/* BPF OOM struct ops link */
+	struct bpf_struct_ops_link __rcu *bpf_oom_link;
+
 	/* reference counter used to detach bpf programs after cgroup removal */
 	struct percpu_ref refcnt;
 
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 391888eb257c..a5cee5a657b0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -3944,6 +3944,7 @@ static inline bool bpf_is_subprog(const struct bpf_prog *prog)
 int bpf_prog_get_file_line(struct bpf_prog *prog, unsigned long ip, const char **filep,
 			   const char **linep, int *nump);
 struct bpf_prog *bpf_prog_find_from_stack(void);
+void *bpf_struct_ops_data(struct bpf_map *map);
 
 int bpf_insn_array_init(struct bpf_map *map, const struct bpf_prog *prog);
 int bpf_insn_array_ready(struct bpf_map *map);
diff --git a/include/linux/bpf_oom.h b/include/linux/bpf_oom.h
new file mode 100644
index 000000000000..c81133145c50
--- /dev/null
+++ b/include/linux/bpf_oom.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+
+#ifndef __BPF_OOM_H
+#define __BPF_OOM_H
+
+struct oom_control;
+
+#define BPF_OOM_NAME_MAX_LEN 64
+
+struct bpf_oom_ops {
+	/**
+	 * @handle_out_of_memory: Out of memory bpf handler, called before
+	 * the in-kernel OOM killer.
+	 * @oc: OOM control structure
+	 * @st_link: struct ops link
+	 *
+	 * Should return 1 if some memory was freed up, otherwise
+	 * the in-kernel OOM killer is invoked.
+	 */
+	int (*handle_out_of_memory)(struct oom_control *oc,
+				    struct bpf_struct_ops_link *st_link);
+
+	/**
+	 * @name: BPF OOM policy name
+	 */
+	char name[BPF_OOM_NAME_MAX_LEN];
+};
+
+#ifdef CONFIG_BPF_SYSCALL
+/**
+ * @bpf_handle_oom: handle out of memory condition using bpf
+ * @oc: OOM control structure
+ *
+ * Returns true if some memory was freed.
+ */
+bool bpf_handle_oom(struct oom_control *oc);
+
+#else /* CONFIG_BPF_SYSCALL */
+static inline bool bpf_handle_oom(struct oom_control *oc)
+{
+	return false;
+}
+
+#endif /* CONFIG_BPF_SYSCALL */
+
+#endif /* __BPF_OOM_H */
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 7b02bc1d0a7e..c2dce336bcb4 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -51,6 +51,14 @@ struct oom_control {
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
+
+#ifdef CONFIG_BPF_SYSCALL
+	/* Used by the bpf oom implementation to mark the forward progress */
+	bool bpf_memory_freed;
+
+	/* Handler name */
+	const char *bpf_handler_name;
+#endif
 };
 
 extern struct mutex oom_lock;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 2e361e22cfa0..6285a6d56b98 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -1009,7 +1009,7 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 	 * in the tramopline image to finish before releasing
 	 * the trampoline image.
 	 */
-	synchronize_rcu_mult(call_rcu, call_rcu_tasks);
+	synchronize_rcu_mult(call_rcu, call_rcu_tasks, call_rcu_tasks_trace);
 
 	__bpf_struct_ops_map_free(map);
 }
@@ -1226,7 +1226,8 @@ static void bpf_struct_ops_map_link_dealloc(struct bpf_link *link)
 	if (st_link->cgroup)
 		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
 
-	kfree(st_link);
+	synchronize_rcu_tasks_trace();
+	kfree_rcu(st_link, link.rcu);
 }
 
 static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
@@ -1535,3 +1536,10 @@ void bpf_map_struct_ops_info_fill(struct bpf_map_info *info, struct bpf_map *map
 
 	info->btf_vmlinux_id = btf_obj_id(st_map->btf);
 }
+
+void *bpf_struct_ops_data(struct bpf_map *map)
+{
+	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
+
+	return &st_map->kvalue.data;
+}
diff --git a/mm/Makefile b/mm/Makefile
index bf46fe31dc14..e939525ba01b 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -107,7 +107,7 @@ ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
 ifdef CONFIG_BPF_SYSCALL
-obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
+obj-$(CONFIG_MEMCG) += bpf_memcontrol.o bpf_oom.o
 endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
diff --git a/mm/bpf_oom.c b/mm/bpf_oom.c
new file mode 100644
index 000000000000..ea70be6e2c26
--- /dev/null
+++ b/mm/bpf_oom.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * BPF-driven OOM killer customization
+ *
+ * Author: Roman Gushchin <roman.gushchin@linux.dev>
+ */
+
+#include <linux/bpf.h>
+#include <linux/oom.h>
+#include <linux/bpf_oom.h>
+#include <linux/bpf-cgroup.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/uaccess.h>
+
+static int bpf_ops_handle_oom(struct bpf_oom_ops *bpf_oom_ops,
+			      struct bpf_struct_ops_link *st_link,
+			      struct oom_control *oc)
+{
+	int ret;
+
+	oc->bpf_handler_name = &bpf_oom_ops->name[0];
+	oc->bpf_memory_freed = false;
+	pagefault_disable();
+	ret = bpf_oom_ops->handle_out_of_memory(oc, st_link);
+	pagefault_enable();
+	oc->bpf_handler_name = NULL;
+
+	return ret;
+}
+
+bool bpf_handle_oom(struct oom_control *oc)
+{
+	struct bpf_struct_ops_link *st_link;
+	struct bpf_oom_ops *bpf_oom_ops;
+	struct mem_cgroup *memcg;
+	struct bpf_map *map;
+	int ret = 0;
+
+	/*
+	 * System-wide OOMs are handled by the struct ops attached
+	 * to the root memory cgroup
+	 */
+	memcg = oc->memcg ? oc->memcg : root_mem_cgroup;
+
+	rcu_read_lock_trace();
+
+	/* Find the nearest bpf_oom_ops traversing the cgroup tree upwards */
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		st_link = rcu_dereference_check(memcg->css.cgroup->bpf.bpf_oom_link,
+						rcu_read_lock_trace_held());
+		if (!st_link)
+			continue;
+
+		map = rcu_dereference_check((st_link->map),
+					    rcu_read_lock_trace_held());
+		if (!map)
+			continue;
+
+		/* Call BPF OOM handler */
+		bpf_oom_ops = bpf_struct_ops_data(map);
+		ret = bpf_ops_handle_oom(bpf_oom_ops, st_link, oc);
+		if (ret && oc->bpf_memory_freed)
+			break;
+		ret = 0;
+	}
+
+	rcu_read_unlock_trace();
+
+	return ret && oc->bpf_memory_freed;
+}
+
+static int __handle_out_of_memory(struct oom_control *oc,
+				  struct bpf_struct_ops_link *st_link)
+{
+	return 0;
+}
+
+static struct bpf_oom_ops __bpf_oom_ops = {
+	.handle_out_of_memory = __handle_out_of_memory,
+};
+
+static const struct bpf_func_proto *
+bpf_oom_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return tracing_prog_func_proto(func_id, prog);
+}
+
+static bool bpf_oom_ops_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_verifier_ops bpf_oom_verifier_ops = {
+	.get_func_proto = bpf_oom_func_proto,
+	.is_valid_access = bpf_oom_ops_is_valid_access,
+};
+
+static int bpf_oom_ops_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
+	struct cgroup *cgrp;
+
+	/* The link is not yet fully initialized, but cgroup should be set */
+	if (!link)
+		return -EOPNOTSUPP;
+
+	cgrp = st_link->cgroup;
+	if (!cgrp)
+		return -EINVAL;
+
+	if (cmpxchg(&cgrp->bpf.bpf_oom_link, NULL, st_link))
+		return -EEXIST;
+
+	return 0;
+}
+
+static void bpf_oom_ops_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_struct_ops_link *st_link = (struct bpf_struct_ops_link *)link;
+	struct cgroup *cgrp;
+
+	if (!link)
+		return;
+
+	cgrp = st_link->cgroup;
+	if (!cgrp)
+		return;
+
+	WARN_ON(cmpxchg(&cgrp->bpf.bpf_oom_link, st_link, NULL) != st_link);
+}
+
+static int bpf_oom_ops_check_member(const struct btf_type *t,
+				    const struct btf_member *member,
+				    const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct bpf_oom_ops, handle_out_of_memory):
+		if (!prog)
+			return -EINVAL;
+		break;
+	}
+
+	return 0;
+}
+
+static int bpf_oom_ops_init_member(const struct btf_type *t,
+				   const struct btf_member *member,
+				   void *kdata, const void *udata)
+{
+	const struct bpf_oom_ops *uops = udata;
+	struct bpf_oom_ops *ops = kdata;
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct bpf_oom_ops, name):
+		if (uops->name[0])
+			strscpy_pad(ops->name, uops->name, sizeof(ops->name));
+		else
+			strscpy_pad(ops->name, "bpf_defined_policy");
+		return 1;
+	}
+	return 0;
+}
+
+static int bpf_oom_ops_init(struct btf *btf)
+{
+	return 0;
+}
+
+static struct bpf_struct_ops bpf_oom_bpf_ops = {
+	.verifier_ops = &bpf_oom_verifier_ops,
+	.reg = bpf_oom_ops_reg,
+	.unreg = bpf_oom_ops_unreg,
+	.check_member = bpf_oom_ops_check_member,
+	.init_member = bpf_oom_ops_init_member,
+	.init = bpf_oom_ops_init,
+	.name = "bpf_oom_ops",
+	.owner = THIS_MODULE,
+	.cfi_stubs = &__bpf_oom_ops
+};
+
+static int __init bpf_oom_struct_ops_init(void)
+{
+	return register_bpf_struct_ops(&bpf_oom_bpf_ops, bpf_oom_ops);
+}
+late_initcall(bpf_oom_struct_ops_init);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..44bbcf033804 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -45,6 +45,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/cred.h>
 #include <linux/nmi.h>
+#include <linux/bpf_oom.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -246,6 +247,15 @@ static const char * const oom_constraint_text[] = {
 	[CONSTRAINT_MEMCG] = "CONSTRAINT_MEMCG",
 };
 
+static const char *oom_handler_name(struct oom_control *oc)
+{
+#ifdef CONFIG_BPF_SYSCALL
+	if (oc->bpf_handler_name)
+		return oc->bpf_handler_name;
+#endif
+	return NULL;
+}
+
 /*
  * Determine the type of allocation constraint.
  */
@@ -461,6 +471,8 @@ static void dump_header(struct oom_control *oc)
 	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
+	if (oom_handler_name(oc))
+		pr_warn("oom bpf handler: %s\n", oom_handler_name(oc));
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
 		pr_warn("COMPACTION is disabled!!!\n");
 
@@ -1168,6 +1180,13 @@ bool out_of_memory(struct oom_control *oc)
 		return true;
 	}
 
+	/*
+	 * Let bpf handle the OOM first. If it was able to free up some memory,
+	 * bail out. Otherwise fall back to the kernel OOM killer.
+	 */
+	if (bpf_handle_oom(oc))
+		return true;
+
 	select_bad_process(oc);
 	/* Found nothing?!?! */
 	if (!oc->chosen) {
-- 
2.52.0


