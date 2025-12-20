Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 938B1E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E99A96B008A; Fri, 19 Dec 2025 23:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60A26B008C; Fri, 19 Dec 2025 23:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D918E6B0092; Fri, 19 Dec 2025 23:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7B376B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AE1313A7B5
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:19 +0000 (UTC)
X-FDA: 84238529718.14.B683A43
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27713160006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWqi11Yi;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QSJTSDVQWiKe8Yn9P+ThjPphZH9zD1eW5Vd3nR6fOA=;
	b=pVIQcUixC+PnfAsPHpi/bbXwGcH/yZQjhd9c81ijbVXXMWKLaRsGB6FD5kPPMRor/y8k8T
	GDT9Kg2uC1Tlylcs4i1Tyi4Rfw89Y8bEP3TKPOmfDtiNmlNNRnZchf7hklKrbsF5DNEdGM
	EYbeDMYeO286dzrveINc3vGpw0rwhKE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sWqi11Yi;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203996; a=rsa-sha256;
	cv=none;
	b=knDPnRBgsb40JgIdwnS8Wkui3O6+Ar4jcJDDLHBp0cGM8fffHeJ8cad15xr653sGMehOWY
	Fazc74rAJYm0wwMfCR7bFkWWMS/xehDiI6XdZka4w7C7VV+m2SLzf9j1aj6Kxhuue4rKGA
	uNKvs5ZSeruUhIr2pFc4Od4TdJwZDrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766203994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QSJTSDVQWiKe8Yn9P+ThjPphZH9zD1eW5Vd3nR6fOA=;
	b=sWqi11YiqXfaC4q538Oi6YnjR2MSP8tTLim8jXiIFt4IKJJyXeziCX3dWTTdJK7u6wRacv
	DWZJ6jebb21kHCjYJ+tj+ageCL0XhRlOYpZhjjcBn9IdYm/zbE1cLIJOMjPomVt+PMw0Rh
	vpkVuj89b6hPDNdWFXf3NlxouB83tes=
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
Subject: [PATCH bpf-next v2 2/7] mm: introduce BPF kfuncs to deal with memcg pointers
Date: Fri, 19 Dec 2025 20:12:45 -0800
Message-ID: <20251220041250.372179-3-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: boo8qbbztj6taynqga9o1yigdu66jxdz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 27713160006
X-HE-Tag: 1766203995-760466
X-HE-Meta: U2FsdGVkX19dQGLJ713GkhUQ5mcDCUrsOhJ4MR4pOWFmIor8+12MZSr+d8PW14v8f0xGV3WMetq1F2vKrNoTXLZ4k/mPHq0CXyYmgQSTkBn7eenUjem2xendQL5pNMxCNTCV9NqBa2TvK2x1RIHWPoYl6ZGQ9LgcCT8P68Y7CdsPCy4n15+Pug+8LV+sQ9FUn7l/GnAKwq75bKyoday/eJTbL0hTmMii5yuvz64rvfFLgDRM27ccSYvBkrAMuGM0EC/xTh8OSkWNEOlwv6jWNbh3Oii7FOjM3SiZbMOxObT+r7pnk0SAMca3MUAN331IBYerlXOLtakTlBaG6INNxOa615oDPWNwl3eA5+rO1VDV0wDceL60OrD8gwUT1EkQxUsqiK45rAgaEiRAdnbMGtb6C8ChxAM2mb9i9dlNdc/7rvcmteQujrmoVMN/RbvoGuIOmnhf3qKEU/++DeGCavf9lqyT9KSC4tEqyVl2C4xz5AR8NPkYqvkxKXRnwaD5jb4dKCr9Cmr9LNGejkYdY8J7VCZmYu877AOhac5n+bPp80LEof5UX7cp+XQbUowAGeXr5qvMb9kViznznHrbXlC3+PQmWoK5aaOvb6fPrvBp5SUTkKig7eDxSrAw3Q+kMTUxDuVxRG0ibHXTSqZNYbHm5eoKTMe18fy0CgZKlvhvstWLGcdaYFHIW9WXhUdlqnVKeVop+tgnGwgjc1Jxkb+VkdQJcyw388mX8azYvVQ3at+PFobpvn2g1X1R4EjrgG6rthyfD8FTq9MnS0/U03+1lOSgsW1cxL4xVZQx9OMe/Akyx+c8jFqARxVycbtE1lb9oKWmZJQ96M9Gk8c6qEDRrC/+yULhInh8/99rE5RGo/Bz40WT0UIt+zE3qCC42xYpy75uelw/5D+s7Onm4PD4DfWqkGMDMDyewye5VwxcpYZT1QZTnrcFSrLs7i9B0jNbFJTcJLO46jTooIM
 q9CtfXeR
 evS6a6VnTQ9hN2OCxwZ2tovY+aaN0iN9O+SqMggf29+bA17XNAOS5MUV0929890KUPUPl9dieuWXIxqkdwbHPg+3KPfsKA3Y0p26iaPBIq5gCPty4oaR9rus4Pc3lZQiXlUH92A90dBKG114O6TRAsnAIpVjfASQlcZD1S2beF3m8AbnKd81jGTkWWKj61c+eI5Zi
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
index 9175f8cc6565..79c39a98ff83 100644
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
index 000000000000..03d435fc4f10
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
+BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
+BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
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


