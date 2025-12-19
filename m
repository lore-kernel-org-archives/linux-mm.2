Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CDBDD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63136B008A; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9F86B008C; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D866B008C; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B30E56B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE0761403AA
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:15 +0000 (UTC)
X-FDA: 84234560550.09.AC68E55
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 37AAA4000F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RupqOEDW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109494; a=rsa-sha256;
	cv=none;
	b=nPHOT8gbXvQDO41Zg9EZmHBXhTuMaxkAkNBXZbEcCyAXdYf8rD6kJXzyvvWPNQQPTclrUN
	ehosWxPUPHpFcdY8i7J39eKoCap4y9LGz87PQdc2CMBB4W8hsc0EJdnTTrtQBqJpGoCvVS
	zk/qkwKBd/m9B4pPOyfHRWgS60+u2J4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RupqOEDW;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLd5oWmWCYkR7ReeLcpFlkM0ux992FEQziG8j7xdk78=;
	b=jRDzkKNBIeV64O007wIVVr9KfZApUPlDOtp7VqmGEt0mzeF56UoqJb3Xa9qEa3FKOksVgz
	RwICEhwmnTqNYUbUiBJ5px3ZBXDdI71VB0bgemuK4JHizjKtq39Nc8VZt6y46u0o9O9qS6
	1OTIQQmzbuUJmnJo39ql4nuu+kbciu8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xLd5oWmWCYkR7ReeLcpFlkM0ux992FEQziG8j7xdk78=;
	b=RupqOEDW58QMOUb7+ZU3sn2bwRWblk0DBU7hce9GN0cdW8FUoK58/1t6cLpsQSy+DwlMp2
	U7jw3kyDH3Ct3U53rYB6sgUuExD2rG58QAT/nfmeIEUr8eiZcUj4atvLS43LM9VkNvCxDE
	AOCX3Pelas4tA0z0WzutyiL9//JUydo=
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
Subject: [PATCH bpf-next v1 2/6] mm: introduce BPF kfuncs to deal with memcg pointers
Date: Thu, 18 Dec 2025 17:57:46 -0800
Message-ID: <20251219015750.23732-3-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37AAA4000F
X-Stat-Signature: nbkmkcj9ci1hkbmtd8c35a1pbtjapw96
X-Rspam-User: 
X-HE-Tag: 1766109494-888343
X-HE-Meta: U2FsdGVkX1/xDydZkz7FBLptMuRX2pPkzLBNZUdqZQY5Gk3L6wSihyLS7YR9taZqLS5SLoohiHdxupjpJ7B1M58axWwZqybuBRYmXM/f+D7JLGJ+r2IrkD+o7kc9YR5cT64zaJ7LWQdgUcnit2nUco+RdjN+bvwL+2TupmZjHgAdvPcuKZ3noOrr3rOmAKrFPx+UUtdEd8VybXnwLmy2/+QltlDC+UXwIvFOALwvPgpWBf2OXPD6WASSf/OCjZtG/MsOICFnkF4WYgFN88CE1BxIr38K69nB39vUsA8n8NcWAp37VYPlEvS96NKWjwog/FGJMpCCL96plu9M748E+DA6HQRTk1mrNCSv6fDf8bHr29sCq9Zq/zf6o1yXY9bpXNYzUZ5TCEm8KYgxOkvQt0hfyyega6twmZwhpDNKHiMjdWmTvi2Urx+nQewYSOHSK6tumXTlykyO/XgPhNdeq0kFnWAdFuIRsn19ly7kljnfes1+h17re+mNmgQ1nqw8w0Ety+T86WdIHp+ULrh0uJ1bh09BfOkDFypAok78sJZBU8mbGD/5BZvzXTKFD7wl+iPoKIFLYjUnrHOFZQFUKteW10V9i7hNNULNQGYzNyYvIclcQX+WQ/zNUz3TJMqOrzbXiEcLXxGZy2dPHp8VEXZkn7ODkv5290euxfMdKvwtw7+Ek+g92Slj5CAv3jsjvqBiWyvab6omLZwYxNO25QIuqAykGBWhIpjB+04hIXeB66W0uqugpeh+elWtGSQwO/GIoKy/MezmIkSoHPsQ4G6cFNYbTYK0FMrazkmQJ6GW55niFpzs8C/Eo92g8HyveJUBA+QNubyNNgPztdqwMs2ehvBhw4cdVzyhTloz6keBqQiLxVNOdRy5NW1R8Miu6sZF9tdTQLhLscSWwYJk84vcyM0Jb9zYzDNlDViLYT+TKnXnOK0p4WunsB+rmiQKVyyJuBX+d9O7JF+2l+/
 ghsFU1Fr
 B0GHTv3y00+7WrQz1P47kn5J84whOTSZ/SpG/8HjmcljA+WCH2A2a/wL9ZkuCx2pZx6HNYTc62GtMTR33aDOrWJ8x/tz+C3a+P0sL0RukkS3zhU51JOYIBDcP188ngJKG4u2f9LCa7FXLWb13rqkipvZgP6vJnvDFl2C8+wBictvGw5gcKVg6B3AcZrEzIf2q69Bc
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
index 000000000000..8aa842b56817
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


