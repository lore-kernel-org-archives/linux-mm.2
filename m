Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC1CCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268AF800B0; Mon, 27 Oct 2025 19:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218468009B; Mon, 27 Oct 2025 19:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E02A800B0; Mon, 27 Oct 2025 19:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB7208009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:18:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B663113A259
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:14 +0000 (UTC)
X-FDA: 84045459708.17.CD3A583
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0C097A0008
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5UMrwUa;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pBvFLnmQUGhHDldbyfAqGwleevT81Px3hvXcQya18A=;
	b=3/3Y38CTdQnKKq4K4xa0koEOGHkLJmnN7WPnAgmnLDYLgvHgQOQVk6jiA/hBlNPbQei5z5
	XbtoD412x9ty+du1Y0vX73GZHz9HlUoiirfgBJfpjiDT4Q74hjGEzc2EzDMgQuXD+SrsJq
	VVLgWr4wW6YIObJ2cs+0TTlL1d+Afjw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607093; a=rsa-sha256;
	cv=none;
	b=tUD42dbA7qBSTcJw+GFmPRwd/duufEhIVsHFye7R29IL/hBvLp7cOkYXxQM7YAEsfCED05
	6xaEERlRR4j+XbiXm628FciOwDIS+tHIruJ5FN3qfVnN8uO5NnNn7L2u7SCald68FBGHTR
	EUeKpAGK2ZBofWET+5SrBJQaBIaN3yw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w5UMrwUa;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1pBvFLnmQUGhHDldbyfAqGwleevT81Px3hvXcQya18A=;
	b=w5UMrwUaoMs+GXh5EBhwvblLHe56g5Uq//mZp5YrlIP4NiHqkzroAOo1KdY9GZFzBBdZBH
	tdNPolJqq+i4qqTGuetYltCar6ZHnLfsICgRE7BoeH/soUxhA0t7GyTI/CnWvYY8sjfHvL
	ewVRkWVHPz9s4vIAASuiU7JSKnftYcI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 08/23] mm: introduce BPF kfuncs to deal with memcg pointers
Date: Mon, 27 Oct 2025 16:17:11 -0700
Message-ID: <20251027231727.472628-9-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: mq4frgikg7qdjutpdsi71hf6uhjmzaq5
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C097A0008
X-HE-Tag: 1761607092-390900
X-HE-Meta: U2FsdGVkX1/ZGs0eE5+XjStrfWTAZbnt1yvgKSU5iGpyK3UiGg/DeTtQDrfE17VjGSzGek+fgk4yx2H58zuUhNWb4xyHFui6iPyYl9D9CzN+XbG1aTjuoQsm/0m9XS4Ei35GXJmVYIYQClelv6U63HKjVtBjKwDxRkldJK9vGBbqmpQGr7bDDizkdJP3aIXcAkZUvxCyQOIKdU9qxcMqpFm+5PhWExsbEpgjPConEwUSwztcOx3/b219GJHXM3kRbwT0f7bZhTts9kEudb6LCt0GmsIODC+cDjOuA0wziMADnK5OUKwkjLwGalb/2A8oMvgVvMTfDFaskFBOk9A8xjHdUBNK4usyrDSHtlrXAfO4ljzcWpgBGkNm3mVjd0TcglPQeKd+XJrD964RMGUezWB5OAUx6cHqsBkp7W7U9JZtBSty7Dh2kJ3kpH5H+uXjYyorvYoNVv2QPpS83jMEH2ug/1UbMe36/TGcnUc2M6pqmu04CrGoznzeF2e5OxkurDJiGRc4BVBAkrvh7U8KQVJ8tn9BiHFkoQtx7UweP7OCVOLIeH8IR5s5lARXPweYV7dzFDo+UL6umwvfoFW+wHV/41aUnCpRYlINRvjYM2Nvv49oyZzFOgFIFNdDcOxPVFVa6Cr1u7D7AaqzAtScFbfu4xghr4xYeYAQ3q8/BJNWURe3lfZpb0RIdHl+7LB2U4l+gyIrHvelYr01pFJNMebGeBcaspM3pZ2PoZ2KDVs6ppZkJGb7HTHDi3aL9p5EprsyGxL3djvBGoRKCg9Mpvier9ZyJKCJBjbNWvIUQDcRiaLyQYpJE6dTJpa90NQQMG9m0Zyj9Ua2bLeyNJc0CNLaS6swLhPoZrOV7WD0/I5NMn/CRy/hs/v+3dzXWw8VofzVqwiU/vf2GaOuazBp5io1gUsoxdCNqjVmBTdoYUrBTqPBkOq5zAMoa5Gp4Mhozm8KUjXl9IpYpTGuNG1
 z08WcxER
 SfIaskJrXjwZjdg/do2Tti2NkT2FDYzoMkdF02rNsp2mLd8+VXeg9vOwSEhm5pPxM8b/csiMbncj3x4qagJp5c/qgfMP+ytYg21xBV+dNW2dxAQsqSNxppyR95ZcABqQrJ2fra+hqSfN51GcDaAcmNvmgNeuDiR/HKWe7poAoiHlx1nFBCdiEaI/0KUDKiSanteeuUnh31Ep0gycQB1cgAAFPgzawZQLCtCucB8vzEBBLNDU=
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
 mm/Makefile         |  1 +
 mm/bpf_memcontrol.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 mm/bpf_memcontrol.c

diff --git a/mm/Makefile b/mm/Makefile
index 051e88c699af..2d8f9beb3c71 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
 endif
 ifdef CONFIG_BPF_SYSCALL
 obj-y += bpf_oom.o
+obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
 endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
new file mode 100644
index 000000000000..1e46097745cf
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
+ * Returns a pointer to a mem_cgroup structure after bumping
+ * the corresponding css's reference counter.
+ *
+ * It's fine to pass a css which belongs to any cgroup controller,
+ * e.g. unified hierarchy's main css.
+ *
+ * Implements KF_ACQUIRE semantics.
+ */
+__bpf_kfunc struct mem_cgroup *
+bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
+{
+	struct mem_cgroup *memcg = NULL;
+	bool rcu_unlock = false;
+
+	if (!root_mem_cgroup)
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
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_memcontrol_kfunc_set);
+	if (err)
+		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+
+	return err;
+}
+late_initcall(bpf_memcontrol_init);
-- 
2.51.0


