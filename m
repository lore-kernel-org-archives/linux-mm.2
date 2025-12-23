Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07097E6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60716B008A; Mon, 22 Dec 2025 23:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2CF6B008C; Mon, 22 Dec 2025 23:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90ECC6B0092; Mon, 22 Dec 2025 23:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 797AD6B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B0F21404AF
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:13 +0000 (UTC)
X-FDA: 84249488946.12.6CC6D80
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 719E8100002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZRbLbHA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464931; a=rsa-sha256;
	cv=none;
	b=VfoMQh44tEVXyiFOJtfmdDJAiqm+rLdTF+8dnCQomrvGgVyj+1fbOardSKKwE2a/L7qqro
	vw12hznqHmdwkswhov/YkVQydqH57MH/8m6ryFXo/a/oyRGw8/nLEaua+HhCN7ydM2FQyI
	dUVGB9XdTV2PnAedqKxvvP6szCbYtjM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZRbLbHA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sgm34XnAtjYqHmQ8m4pVVZ/fcJUWGruYJivSnP1OS4=;
	b=0xhzRnTeMMmH+hk1IV7AUJFRE2Q0TDEU468z7okD1UyHOdt7t35++BUhoCazseeNSV1HgY
	+I9iIA+W7QNn6J4Jp0eHIxbCZ43FJzStsklXQ5+BfqfZiVmBJJzj6wKP7MsUkapQKHEOzW
	ewsDzmB/FjHL3MEJAt7wXe6pljq2oVA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sgm34XnAtjYqHmQ8m4pVVZ/fcJUWGruYJivSnP1OS4=;
	b=sZRbLbHAZYcVTrs1pZoM2rBFY8qzVAPKt8ffAlhBWRNomC+dxxlV9k7FfS7iik4lbVfYDH
	+dw5JRNuY2XOJPhrA2DEsyR039yQPD960Gd1cimG2vGSSt/RJQFmCKXOfZVp5q8fW4VJVO
	N3aLsOwhJ2m5xXkWuSR9DtfsvIR97V0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v4 2/6] mm: introduce BPF kfuncs to deal with memcg pointers
Date: Mon, 22 Dec 2025 20:41:52 -0800
Message-ID: <20251223044156.208250-3-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 719E8100002
X-Rspamd-Server: rspam10
X-Stat-Signature: zzh4aitgtaczaq69qfoeb6skjaas6cxq
X-HE-Tag: 1766464931-477122
X-HE-Meta: U2FsdGVkX1+6FPmFIMxhlBvCfRXikns9PtGWv7qgu5fZh9SOr3A01r7IgEk6r+Oqg5kjdO1AoRrja9yU+U4SJpYT7afuVt55nfYEH/Q0ZjratwadrfDMcfyLSCTNL4Rk0R+djphDvISPR9In0+Pz38iBQh+ZMJRdWm9nz5HkIrkNJeXG4V0vOh3hG7OTek93J7vx5XXA96nWksdeo8X0Rffwvg5rXlfNFv/4Nh02ZdYSkryXuXOwXJL1ebkGHywj9YUqIHG8VLYtdqpxWIeLKZBlFPqzTqCPgDjJPL4uJ57FXyFkUqB0eNCjYOiY1uZt/6Aot1d0KNrE23U7vkZGRV3RXil9gKJ6qLktwtnWrB6lu9DIDbsw/fL9fKIfvR/Vi+D7OkZBsWNoWdMTYzJY5bzhi7shW8e4rWcLVxcOspY9NPeGT80coFhIn/wAvhrAJQSnul++cPt6VVHTCObA9gbfbrMOqrHFHujRiUtxMKOu9MC2IFoAxUPR93vCsnSTFUjOfx5aJSpeVBCbDyLOl7yQkx8TkVMg4XINKFYgbUTGVmIu1qhpafKeBoVqNwE/gWCF8m17rXhCSz1uK3ibEBHAO/yE9oeDuzTNChWVRl0ie2t/loYscbGLimDoxsdEF8opTpFE/N52lajTrb2BlSwDMSSFTCZM8nGFkhgE6s9K5q04eYvM8FvQYcoLNmU59+/hOCYP61gGi/t6L7RC1XlNpmMlO3P1MUF89u7sxhHDSrFBjJSOhiZjR+HqiLNFu9FuKUfTv8rjTaEmS5xuryJ2BRwpu9096ulaxwJ3i35riygr8gLLrbnIUgxq3kFvRBiPpougZhVBtU8mRlmu6ooC+pDnxebnXAZs77c9V+kRTUkwhzYvDB2/bA6paMI5T/Lx17FL0cbRFhYetnHG7fV42xdHH4xtarSVhL/zCVr4ujPYNM6lgAjlispXRUy1UeaeLLwtH+38OmL106i
 phmtUvZb
 VVqXgmPd2zTFgTmtJ4GaCpEfPcX4hlrTMr6wpmQj234wg9FzHgt7ZTvXVi6Yyxp2rdu8Ehi8/AqZcX4mxhQnJoiU17uFaMY7BhYKvQnAUUYDNTKX25Llq5Dq+BnSTRjNANxNSgt6bclULPfHbGtmMusvMCha0k8IlIeDbb6lHDjN/7H3u+WqD17kdGSOqWVubBns4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To effectively operate with memory cgroups in BPF there is a need
to convert css pointers to memcg pointers. A simple container_of
cast which is used in the kernel code can't be used in BPF because
from the verifier's point of view that's a out-of-bounds memory access.

Introduce helper get/put kfuncs which can be used to get
a refcounted memcg pointer from the css pointer:
  - bpf_get_mem_cgroup,
  - bpf_put_mem_cgroup.

bpf_get_mem_cgroup() can take both memcg's css and the corresponding
cgroup's "self" css. It allows it to be used with the existing cgroup
iterator which iterates over cgroup tree, not memcg tree.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 mm/Makefile         |  3 ++
 mm/bpf_memcontrol.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)
 create mode 100644 mm/bpf_memcontrol.c

diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..bf46fe31dc14 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -106,6 +106,9 @@ obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
 obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
+ifdef CONFIG_BPF_SYSCALL
+obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
+endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
new file mode 100644
index 000000000000..82eb95de77b7
--- /dev/null
+++ b/mm/bpf_memcontrol.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Memory Controller-related BPF kfuncs and auxiliary code
+ *
+ * Author: Roman Gushchin <roman.gushchin@linux.dev>
+ */
+
+#include <linux/memcontrol.h>
+#include <linux/bpf.h>
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_get_mem_cgroup - Get a reference to a memory cgroup
+ * @css: pointer to the css structure
+ *
+ * It's fine to pass a css which belongs to any cgroup controller,
+ * e.g. unified hierarchy's main css.
+ *
+ * Implements KF_ACQUIRE semantics.
+ *
+ * Return: A pointer to a mem_cgroup structure after bumping
+ * the corresponding css's reference counter.
+ */
+__bpf_kfunc struct mem_cgroup *
+bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
+{
+	struct mem_cgroup *memcg = NULL;
+	bool rcu_unlock = false;
+
+	if (mem_cgroup_disabled() || !root_mem_cgroup)
+		return NULL;
+
+	if (root_mem_cgroup->css.ss != css->ss) {
+		struct cgroup *cgroup = css->cgroup;
+		int ssid = root_mem_cgroup->css.ss->id;
+
+		rcu_read_lock();
+		rcu_unlock = true;
+		css = rcu_dereference_raw(cgroup->subsys[ssid]);
+	}
+
+	if (css && css_tryget(css))
+		memcg = container_of(css, struct mem_cgroup, css);
+
+	if (rcu_unlock)
+		rcu_read_unlock();
+
+	return memcg;
+}
+
+/**
+ * bpf_put_mem_cgroup - Put a reference to a memory cgroup
+ * @memcg: memory cgroup to release
+ *
+ * Releases a previously acquired memcg reference.
+ * Implements KF_RELEASE semantics.
+ */
+__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
+{
+	css_put(&memcg->css);
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
+BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+
+BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
+
+static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_kfuncs,
+};
+
+static int __init bpf_memcontrol_init(void)
+{
+	int err;
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
+					&bpf_memcontrol_kfunc_set);
+	if (err)
+		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+
+	return err;
+}
+late_initcall(bpf_memcontrol_init);
-- 
2.52.0


