Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE78CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C04F8E0050; Mon, 18 Aug 2025 13:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2719D8E0013; Mon, 18 Aug 2025 13:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F348E0050; Mon, 18 Aug 2025 13:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2B558E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:02:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF86EBBAF3
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:05 +0000 (UTC)
X-FDA: 83790495810.12.1D58F88
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0B5EDC000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:02:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmVndicI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536524; a=rsa-sha256;
	cv=none;
	b=GgtH7tE/zYzcZugTmR+16AO9L/76vh5GeD+PRwo38/aWy3rxclFUUKPfEq/RcCRP3R3dCe
	U9aHVMDABhMz1BSe/ieWN9UldWUOFVIs8axFs1nGV4ZlwHHKhOYJUGLLxlyrqTSnaxs7h2
	iHt26kZJwJ5G8/onwWPEqE4JrWUcprg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HmVndicI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbLFrydxxFltKx71yS/4EU7bCQFvXwfOv838sVEINzk=;
	b=4B27nmFiGvRvTX0BxKBktl/mSCgPle+HPnCTtoxJ9/ED23a2C25kIDHIbTnrpm3vzLxS/p
	ia0FPgGB5BksJQ44zjH3ESll32/VwSmmVY+rZUsHtYJ7ZbX5qU07+mieCithX4evOnIPi0
	m46GF3ucEUAgNeiF8OlOlCFsbRZ0+Bk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536522;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pbLFrydxxFltKx71yS/4EU7bCQFvXwfOv838sVEINzk=;
	b=HmVndicIgd1MOovjGT3tuk+Clf7w9gQt/J5iV244rD8BMDMagEbXceif4wnMg6wqi0thEx
	x0uvly97MaJ68GXg7+UWvj8c2K0A8gkSJwQyXDQ+uu87+gxH8naiO3OA/PGJl5XwAEq2uz
	tHBa73obbnXn3rKHcxgCrsAdsE6xpQ8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 04/14] mm: introduce bpf kfuncs to deal with memcg pointers
Date: Mon, 18 Aug 2025 10:01:26 -0700
Message-ID: <20250818170136.209169-5-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-1-roman.gushchin@linux.dev>
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0B5EDC000F
X-Stat-Signature: emzwrstjzrx3qxcsgua4zjg81b7qgazt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755536523-133985
X-HE-Meta: U2FsdGVkX18oWKmJcNdNhme+iA4QL0wyYN4rjvRbJYwS/QF0gy2D4b7rMLweMmgpXtIUfoZ3dmEhZtojChIHQ7VN/te/qiAT1HWI8PR8lt6run4/+WK7asHKiW9Q7ke66Xtn+dZHAouaQ5IAWe1DisYNoBl7WGLlXWcXirDhpE7a8RtqPl/OsTnbRmnwtQzLYfNIS4k8chC7dY7IDb8xivvhKOX6X00xRF0KLLMqOCOSFYe4OoKVfJzh7i+4I5KqO6pzThykFLB3s1hPuiA2+nH9EpTz7KBGrNOvpF/LZUW0hLDPAs8/hup5qIKzmAWTbY4+G2vn/Cs8ZiDY54mS+Liw7Ttg05Ywg5703obduFVgxVGdg07bCi9dLzpZt2hDuAn7WPAMDcClyeaORnk/ZYezfpCLr3v9zxcxePzAaUvEYmdqhJMI6G9GkUfAWXYScDBb+XNNH3AEl6Gkd/roY3TyOke9g8HyBZwy8wNgGNEk9Xun2TMxExyh8TGidEqHfxIVmn+L1EwelkCyZHPIXtKd3GD4rAjOl/YnlgA4R0kkTSjBZsGuYB1EUYAMCPS46rLDi5PKoZZP2zz4dZjnE1x6OLSHvmD4xCDkONFKLLsYIXcVuMOyK4RCD6iOSCy8n/O4oVQJ8Dr5CxMk6elJVEqPHmFNMrkgolSY9yjjAUdK1s/b2QCAelkdf82R66PQVPebwqzCdgfo0OeJhIfhIeR0cIvB97D/t3R2879fMzgJtfgO3io1eLKohc6AFBS8jAsMGl//EhxFr/Kolv0khc9bdPhHKkG3ItrPdwwZUP2DyeRwmdAzFnZv0UVYEispooJgeKuUPsZj1nCm3GBF6wUs0XwhjAXaFROzP8rzvOJAqyfcl/8MokI7tCdqhkERUFeGW6kbheM+OCCQAfrHDxUm2I5ZYhh/z6j6MKqkUBr86HmCQkMHYCt/j0EqirTeHmCHWRmrfeHKY4gi2Di
 v0oZ8Xkx
 T4eTWVC0INJ6vj3i7kBMUL3R2a8JXY1RIz1UQhEFnQ/r1GadHL408Lu0bNArZayAzqkaCBOFfo/eyYFDGbP75HGeMfb4NLH60lEC0byOR88d7ncFO1V8tpLXGljqpzu3NmBuQ2eZq6JHkyBYXuglTjDNtAA1UqVA5NPSe9K2db4BkEAaQJJexrAUu1yTKCCgpLmE8sbP52ZuM7+QGooh1YQHJIIoVDHkHDCn69H7y0ptbpLk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To effectively operate with memory cgroups in bpf there is a need
to convert css pointers to memcg pointers. A simple container_of
cast which is used in the kernel code can't be used in bpf because
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
 include/linux/memcontrol.h |   2 +
 mm/Makefile                |   1 +
 mm/bpf_memcontrol.c        | 151 +++++++++++++++++++++++++++++++++++++
 3 files changed, 154 insertions(+)
 create mode 100644 mm/bpf_memcontrol.c

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 87b6688f124a..785a064000cd 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -932,6 +932,8 @@ static inline void mod_memcg_page_state(struct page *page,
 	rcu_read_unlock();
 }
 
+unsigned long memcg_events(struct mem_cgroup *memcg, int event);
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
diff --git a/mm/Makefile b/mm/Makefile
index a714aba03759..c397af904a87 100644
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
index 000000000000..66f2a359af7e
--- /dev/null
+++ b/mm/bpf_memcontrol.c
@@ -0,0 +1,151 @@
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
+/**
+ * bpf_mem_cgroup_events - Read memory cgroup's event counter
+ * @memcg: memory cgroup
+ * @event: event idx
+ *
+ * Allows to read memory cgroup event counters.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_events(struct mem_cgroup *memcg, int event)
+{
+
+	if (event < 0 || event >= NR_VM_EVENT_ITEMS)
+		return (unsigned long)-1;
+
+	return memcg_events(memcg, event);
+}
+
+/**
+ * bpf_mem_cgroup_usage - Read memory cgroup's usage
+ * @memcg: memory cgroup
+ *
+ * Returns current memory cgroup size in bytes.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
+{
+	return page_counter_read(&memcg->memory);
+}
+
+/**
+ * bpf_mem_cgroup_events - Read memory cgroup's page state counter
+ * @memcg: memory cgroup
+ * @event: event idx
+ *
+ * Allows to read memory cgroup statistics.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
+{
+	if (idx < 0 || idx >= MEMCG_NR_STAT)
+		return (unsigned long)-1;
+
+	return memcg_page_state(memcg, idx);
+}
+
+/**
+ * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
+ * @memcg: memory cgroup
+ *
+ * Propagate memory cgroup's statistics up the cgroup tree.
+ *
+ * Note, that this function uses the rate-limited version of
+ * mem_cgroup_flush_stats() to avoid hurting the system-wide
+ * performance. So bpf_mem_cgroup_flush_stats() guarantees only
+ * that statistics is not stale beyond 2*FLUSH_TIME.
+ */
+__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
+{
+	mem_cgroup_flush_stats_ratelimited(memcg);
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
+BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
+
+BTF_ID_FLAGS(func, bpf_mem_cgroup_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS)
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
2.50.1


