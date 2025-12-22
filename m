Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57162E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5E66B008A; Mon, 22 Dec 2025 17:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53686B008C; Mon, 22 Dec 2025 17:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80086B0092; Mon, 22 Dec 2025 17:18:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95B766B008A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:18:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C5A514039D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:12 +0000 (UTC)
X-FDA: 84248521224.02.BEA6003
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 63F17C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FFYtVRDh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441890; a=rsa-sha256;
	cv=none;
	b=GbfyifBVoUDEU+bXW84fEkBvcb0C4CycymIxr1SiHXAOfqQGLk+l64HK15t0zzLD+dIEK3
	zCGenDYNXicSjIXEwHwr+1TPoPG3X61/oX+bhf0/thUzmBUuT8tSgjSin9U9iuGxdUCPzG
	230R8cwWQOCG6RsaqGB1vZJs9H7Z4TQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FFYtVRDh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sgm34XnAtjYqHmQ8m4pVVZ/fcJUWGruYJivSnP1OS4=;
	b=CZKnQm2hASUFgdWL5MOuXt4mMGYrRPVbDOaifG+V5Lj5rokuRaH4x3cM0OaNfM2skVto09
	SV6FE9cKUhRD2sGxjcHhEZ+CaVgjb3E7NTiH2a8anWBMZ8lBXR6FflWumoNUz+JWBLGOVr
	22RizB1nIKHhXaaxR5aUst/vHPikRE4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766441889;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sgm34XnAtjYqHmQ8m4pVVZ/fcJUWGruYJivSnP1OS4=;
	b=FFYtVRDh+n7hWp0hPxsNtn4mecu9eMF77W2V4b/Dd5xENJzwa/GAXemSK2rf6Z+ZxaJl1L
	zM7iAo6FtVGy8AyDoTQB+oCPtHDnBKgm7cgbKL5iMEeOp1cwKQ/R82dcPMgc3baiXin/8C
	BZPntX+LTS0mrEdFSj44actVVDASEUI=
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
Subject: [PATCH bpf-next v3 2/6] mm: introduce BPF kfuncs to deal with memcg pointers
Date: Mon, 22 Dec 2025 14:17:50 -0800
Message-ID: <20251222221754.186191-3-roman.gushchin@linux.dev>
In-Reply-To: <20251222221754.186191-1-roman.gushchin@linux.dev>
References: <20251222221754.186191-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 63F17C000A
X-Stat-Signature: bzm3hmpiqweay5by9gjmrkj74wifh4bj
X-Rspam-User: 
X-HE-Tag: 1766441890-313994
X-HE-Meta: U2FsdGVkX1+eLMlOSj01Q+lsQZXsHmt2scHpkM+OPDdsIrhKX4p1U87nA/fXv6HS/b3MhpgyGEcHP0bHZOr0GjcGTZTLiFnEjiOtWXzrPlP23pNoNKLzJMogD9bdok6Kr8HSMZzzqgg4gqXeMbyiHqt9yxPiLA9EXp0EhoQnYdnb/CbDYo12EWp1oJdC0w2xCDfOtTZJGlfe8kndaIia+94fftLqhEYA0xJY9oVkyec0eiKlX6QigaH8W7yp1STmpAO16d6y1qbX/fa27JITSFPxXR4R/tbN3AosLkj3WD+H+WQ+u93NU2p7CEzqs1j9WKvVyaumFiy0oHXZCo4Uzrkaq80elDrLvGNrXH11AsZKoMC3JZd6gtRA7MhR1P1mFNMjoAWYBteCgjHBdX77TNDVQNJYM3GtEEQWgajy2ip+2mr8fG5ec0xoSc3uToixlxoXYaad51RmGfRTHJ3LrbfP+esFia1Czh+bGg69Wxlv0dq830/bhXCpiueVmhHqUM6/nrJKPAzcqv3LvmBmKM4L0uF6NJ6NSv6aqtCXZGvqhRBc1D9mZS/QO534i2T9eP86yi6Jzbt0j080z3GWjkzwDiz03Rqnl7LCN+bWZiqX6RViFCSzO775s6HLpnR0MNj9RSuMjVOhnnjcxRscuBguq1pkIJRhJOpKhPjJ7rg0T6DgAMfN5CVdW0poeIFGfI5HOU0wIvQGXlRPtBliC72OgQxYwU1NujBKyVvxzFvtZ6ZBsea7ShsEv9Nu4A70cMVlWO4qwA+wCaqAC9TboXRp9NCF6T9cPahJiF7Vf0JfXfQfTVrEnQ+LldRWQSuPJdNw+UQnTC3M3FkXkATnuf00BuXUusZ/WP6cQ42/QCzZSIer0wL9uk3j/cxucZeGbS796PbBrWGa7CHXLIf5//4KjZOCz//JbgyXUi7DjCGv+XeCqZlrIK11alUvAjaEFrGnxTDKBbm94P19I4O
 3mhr7Pc7
 SOQf+L/v1oDLG6N67IdH6LJfQfJSkrKW5q5pPvNBpqmpxD3227iL9htsCYGU8qkXKme5AOXfegbCducsUnO1/d5qWlFZfRobW6tOzrONP80AKcA64NaTVLOjBz7Bj2AThArL0XmwDDhwHCdv5ayvsOuROH/AqL0nYiOB08DYz69A4H6RGx5d2RDsNyuL0qPSqX2M7
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


