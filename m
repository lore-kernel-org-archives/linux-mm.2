Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFACC88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24A96B0092; Tue, 15 Sep 2026 08:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38D36B0093; Tue, 15 Sep 2026 08:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB17B6B0095; Tue, 15 Sep 2026 08:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA3D6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:30:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CA0FC021A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:12 +0000 (UTC)
X-FDA: 85215929064.28.318B312
Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE3E2C0003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:30:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1iq0bE6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789475410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFySKlIySaaWIeScK8OkeSBVJiRjLmwju89eAUyEAic=;
	b=GGgZDTp7VdZDH/tQFki9R7wTBJ7d4lbas55L8AykZjit12za6A6VMXUs+Y3E6viv4GTn4Z
	IAYIzkY2emH8nFUK8x7oDVYIekxs0BfVC42qF6WNxyxvXgKcksvCkkS8Rs/8v1pvGzwhP8
	nGHJMVQ14Q6v6vJmH5eKR/AXoNJ2RLM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789475410;
	b=SO2U4T3vtA2L/NgzUE4thFMAzKkZNDQLcs3VkMgte4ywZsqC6n/pH+dTJxq6OyxLLvpmU0
	6ciDGZmH0RmKYhg0pZfNMbHA3M7AJF9+rClmX6evrjvmpp8E0ndScptUI7v/wltMBIREZs
	VyHLr2RQcRtfZrU3ZaaRXPzu/IXwg/s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m1iq0bE6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.241 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TcY2wxf5+iePUwSde/atrLl8tfnWU0M7vr2yTNPUWv0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789475407; v=1; x=1790080207;
 b=m1iq0bE6EI1OQpSG+bG1D6g7smnMjWbjXFBjVnAylHtNqW8p8FjKqrOXNzpflkqhr9HFX/V1
 QIc6qA3QAWdDdj0r49Dp8lNwEwBCWHcX37nJcAqHH+AJj2QK7m8eeyZeflT0Iyi7KQEOyBPyR2X
 +dBrxi4bjVYQtIzyvR27j/Hw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 93ffe1fc753e266b;
	Tue, 15 Sep 2026 12:30:04 +0000
X-Mizu-Trace-ID: 93ffe1fc753e266b
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Shuah Khan <shuah@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH bpf-next v11 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Tue, 15 Sep 2026 20:29:35 +0800
Message-ID: <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789475073.git.zhuhui@kylinos.cn>
References: <cover.1789475073.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AE3E2C0003
X-Stat-Signature: gyeg5uikog9mtqx3cpyxgdq1c995r5eb
X-HE-Tag: 1789475408-470525
X-HE-Meta: U2FsdGVkX1+XJige6aRwa02aHIRN55Q2p/EShHeHnkGrw5F0ggjst/lx28Zt7YZiQ8tiEQYHkho/wOK6VBoGVDOlJI9nmSz1IBEvjuRiNwcLZgCI7rFUVrdPiLycx7BEU5cbz9Iq9zX6MfHB+ZwBdI6ZldrNcQ+Bdt2Tzv2fnhlKgIHD7FezWFQkiRihmFKuGK7K4w4eQwXxNh1e6dNIQAJeFCLYAkBMipfi/vQTGo61xBKJwZr6Fdw5eSgDVNYWObvMo8p6L7RPro65VccDTo4NqVH+qp3fZBzSvLit+D64qJSY9Yz8KGRFT9c2cKtUpcOm//dKdtTbSlYd4fHZt4lWIf8yuvpJYn729QsHYr82jaQ5MmvmZfVji3HJzogaV582cLSf7lvQPQ+qEAchUFEgPhe5boUmM8vXNfi266mcOBTjPd4JHa2iWKF+GEXUD3/HIZCIAwe2/g2Y0qk7lLOkNsVdsUwWqsGJSfuk/uIDit2kyeS0GR6HdwD3h2/ElJP/P9cG8GhnSJWmnOn7wq+iVCGFYtbTvjl8pmEO/fTpkhe+nUxyXi3UMCqHDrWMMLECo6mdkyKkB7Ywogs/UgTi0RoIT3tgv1/+jrJ76ajLODVqq9EcEkiEE8X/Pj9QOQzAa00lvvFoA3aJfkS/DOZrZaxiSa34GfyAF6qCMQKUGoQPTWfbMYaxvGbDE+sos7mP0HHIJW2tqsRBkrUnpyiQuJLki5Ix9fqshZeCGAXMXO+2Yr5qUszbaaA55OL6L9qe58uxi4CChnMx3Wd0x9VJDWT55TGj5A4p6ouV5pa0Fe/4KYLcLme++KbKV0T7Zczacbs62jN3fNM/H0RnV0ngoNe9K5k3PDKBkHYUVV25H5fKa9uJirkOSqUYY8tYiKQAqVMu+fSJFPq4zKF58u2d9CIlO17dwOV6uH9hxHfRSNS/CXRCTkjoTcZff9KnUyHi4OV3sOWswU8Ki5F
 UVTTu0/1
 h7Y87B/zh7hoBU5Ss3JiyLMK2hhORQJwyFuuaa+GX7i0rhemgwzw2f7oahgbJe0rf06gVm0nx0x6GzVIuGzQk+3iM4RSPxvaiGka3a/IyckjnE0VlV69IrdK7Zsb6ut5LcmtsAjravevvXg27+mkntWnHyJndm+6yPk6qKBBOr98Xf8p6PGNoYA3zzTveS0Ws6mYeRdw3+oyGrFUnMa9c91xiF6Vjlo75ra9A/3l34XhsFQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup, e.g. refault
stats via bpf_mem_cgroup_page_state(), but cannot act on it:
triggering reclaim requires writing to memory.reclaim, which BPF
cannot do.

Add bpf_proactive_reclaim(), a sleepable kfunc performing one
proactive reclaim pass on a memcg, like a write to memory.reclaim
but without retrying until the target is reached, so that when and
how hard to reclaim is BPF policy rather than hard-coded thresholds.
The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
as high_work_func() does for memory.high; reclaiming more is left to
the program, which can call the kfunc once per bpf_wq callback and
stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
other sleepable programs may run with filesystem locks held, on
which the reclaim path could deadlock via filesystem shrinkers.

Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
macros to an enum so that they are emitted into BTF and usable from
BPF programs via vmlinux.h.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 61 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/internal.h       | 10 +++++---
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..d6b6f4f8359a 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -8,6 +8,8 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
 
+#include "internal.h"
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -159,6 +161,47 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size: the amount of memory to reclaim, in bytes, clamped to
+ *        MEMCG_CHARGE_BATCH
+ * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS,
+ *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own
+ *
+ * Performs one proactive reclaim pass on @memcg, like a write to
+ * memory.reclaim but without retrying until @size is reached. Call it
+ * repeatedly to reclaim more than one batch.
+ *
+ * Only available to BPF_PROG_TYPE_SYSCALL, because other sleepable programs
+ * may run with filesystem locks held, which the reclaim path can deadlock
+ * on via filesystem shrinkers.
+ *
+ * Return: The amount of memory reclaimed, in bytes, or a negative error.
+ */
+__bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+				       unsigned long size,
+				       int swappiness)
+{
+	unsigned long nr_reclaimed;
+	unsigned long nr_pages;
+
+	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
+		return -EINVAL;
+
+	if (size < PAGE_SIZE)
+		return -EINVAL;
+
+	nr_pages = min(size / PAGE_SIZE, (unsigned long)MEMCG_CHARGE_BATCH);
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    swappiness == -1 ? NULL : &swappiness);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -174,19 +217,35 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
+BTF_KFUNCS_START(bpf_memcontrol_reclaim_kfuncs)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_KFUNCS_END(bpf_memcontrol_reclaim_kfuncs)
+
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
 	.owner          = THIS_MODULE,
 	.set            = &bpf_memcontrol_kfuncs,
 };
 
+static const struct btf_kfunc_id_set bpf_memcontrol_reclaim_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_reclaim_kfuncs,
+};
+
 static int __init bpf_memcontrol_init(void)
 {
 	int err;
 
 	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
-	if (err)
+	if (err) {
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
+		return err;
+	}
+
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					&bpf_memcontrol_reclaim_kfunc_set);
+	if (err)
+		pr_warn("error registering bpf reclaim kfuncs: %d\n", err);
 
 	return err;
 }
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..44e95e87e3cd 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -74,11 +74,13 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru,
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
-#define MIN_SWAPPINESS 0
-#define MAX_SWAPPINESS 200
+enum {
+	MIN_SWAPPINESS = 0,
+	MAX_SWAPPINESS = 200,
 
-/* Just reclaim from anon folios in proactive memory reclaim */
-#define SWAPPINESS_ANON_ONLY (MAX_SWAPPINESS + 1)
+	/* Just reclaim from anon folios in proactive memory reclaim */
+	SWAPPINESS_ANON_ONLY = MAX_SWAPPINESS + 1,
+};
 
 unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
-- 
2.43.0


