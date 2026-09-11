Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC57EC88E40
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 02:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEAD96B0092; Thu, 10 Sep 2026 22:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E746B6B0093; Thu, 10 Sep 2026 22:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A946B0095; Thu, 10 Sep 2026 22:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD5A56B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:21:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACF72120699
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:21:17 +0000 (UTC)
X-FDA: 85199879394.13.735A6D8
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	by imf09.hostedemail.com (Postfix) with ESMTP id 94743140009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:21:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jKKyByK2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jKKyByK2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789093275;
	b=zhksGAFvNsOaovUAERMU7Mu7QolPsD0b83TbCN5Izzu//Z7qKZzn/+klfW6FZmTZVWRqfi
	dvx6Xez4eQne6fVzOgv1oTXQ1kAO2Sasbumj6ZNT9LLOug4NJVzlTZBL8X0C3muGxAH4aO
	2cccXUaDEh6h4Y7U8ejxVPt9yods3KM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789093275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=od3W+xitX6MeObwjJgdPJ0rydXWzJ2pjx3tFbtjfnIY=;
	b=2KUtriMwKSvxLeHu5OSPLWkHmICLHqV2ReONi1W+/z1v0rD6DBtq3HtNBTi6wBJQVpT1Nq
	dcKjTduU87C4Ro1f0kJXpv/ZYLhYMyVKsmDoxG7vEnZpIxbgslu9GJMf8iubLjx1W29DWG
	NZc+mz/AQtXcfirjV/bzncGb/xEAJLU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7U0NZ07kxt7oMI8+IdEEFk22QN5PFNHO3HrbUzPvBh8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789093272; v=1; x=1789698072;
 b=jKKyByK24A7mfi5+BWi1/nPhkn8WIaFf8j9jXiflMaCc0BHzfN4lMZnyTQCnCCsE9YYj4M5E
 hhBNY+9bBs9cj38P8cjvDnMSVKoMHngqQUenmTVH6KgSYAAku9jYnoEEHuW5R+alNz9xlPQr7r/
 /0co1aKklNg5ziH36x2iHK70=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3789ec0d9053d367;
	Fri, 11 Sep 2026 02:21:11 +0000
X-Mizu-Trace-ID: 3789ec0d9053d367
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
Subject: [PATCH bpf-next v10 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Fri, 11 Sep 2026 10:20:44 +0800
Message-ID: <e00910f328c129fea716e9fd031dada328e60313.1789091855.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789091855.git.zhuhui@kylinos.cn>
References: <cover.1789091855.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 94743140009
X-Stat-Signature: zpqxz7dbywf6io4t3z6uftb1a65869pd
X-Rspamd-Server: rspam01
X-HE-Tag: 1789093273-827944
X-HE-Meta: U2FsdGVkX1+35D+1f5lPaQFnBgbSTP83Xw4cEgy4jG/zLeH26makAgJMl3wwkzOrsklgiIe9mJnwX/hks//O57X3A+20kpEOBBqxZFHSuBM6THWIrbsv4q2TNwquXcLml1vAo3Qyn6g0z82nEP/m8za++kWPaeoNBF+aXQh4RKOBraqRr3FaHHeRv7xAybQfq7u3/tgkTlBGnjvwICAs1xt/OL4H6FDbsgstClgd3RLpoSoT0qcpIxCPtHIQqnFDZd6an2merFF4UAJe5aZuCmpHcvUGz+uxbKM2fm2eojBz/cAzRJUDYxlQXCnQCzG/HL4CfZsJPSy5TrAe7YiSgbB16UHIFk0SCpvN4RyKl51V36M83SdaNrsssCNNGzbg36POcBCMd//uAX1wdTeKYfnZ7I/T62AvxY37GHT7C5P344yT69AczeRoLJEBo0SOYL91h/j7Z43ZcWhdQ65BYsug7tr4nxZQSDYQnwWs8p6a/AnOq+77/rCORxST5j7YcskqOPQln77pmaBApyjxtyX/CtDEFPBDZpKrwbsbhdpWEkkF5TUHPBjRyMzVAnFOajyTvQYRE/ESFD0wbHwBdPeTZNReebVc9zco802xRzTHSSXj5/rjlZ65aaceIhLq+tTC3ibfT9/RKMCu24uT1JyxU55jXkVAR1GXzCfVDcayzDTpkBtlH/UJfGcVCmVcLjOPK2f8UNmeIDjOQiDYhiPJK35gE1BUOHdrbv+lkYnfr0aVjYccmOC5cKYKv3La8avfYgs4HMTH8TJKM9My8itm5uwUYYTLlDNHtj4QTWReiPxA9tIO42VWAkTj/4HpRs8iDXBP4ubOkkW9N/ePxHaIevZw/GMenRTzwylQufCMVWAYG+5gj8SXBVM8YTl4wNJHRib6YWSasYKySSZbEdgMmc7GruVhv3hR/aIvGZS+aZQBWRwNPHTFWkVSID2KS35coKx98nWPS5QmJh+
 29FmHHBR
 NmclLhyiT3WWjjklsAqKLjk/Kw8X3BC2Ca9GgMI8xSdLp/TT5HJ+Va+mPpSxZFmM5s6z+jPsonYvg8n9x1qz+3uTsAorADje8ZwuvmBd6a1M6b7uUmvfFBZfieNqfNcSFbWmHcRnGqVG9jjt+nKcEx7E8gOTld1ou9Z+fFUSYSPXbgjdsNmjwss9/de7DzaPL9QOSEyo2VRMabqxalwWF9A0+NWbX99IP0vsW9mLb/TbDEMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

BPF programs can observe memory pressure on a cgroup (e.g. refault
stats via bpf_mem_cgroup_page_state()), but cannot act on it:
triggering reclaim on a chosen cgroup requires writing to
memory.reclaim, which BPF cannot do. Add bpf_proactive_reclaim(),
a sleepable kfunc which performs one proactive reclaim pass on a
given memory cgroup, similar to a write to memory.reclaim but
without retrying until the target is reached, so that when and how
hard to reclaim is BPF policy rather than hard-coded thresholds.

Since some bpf program types may be invoked while holding fs locks,
limit the kfunc to BPF_PROG_TYPE_SYSCALL only, to avoid deadlocking
in filesystem shrinkers on the reclaim path. A SYSCALL program can
invoke the kfunc directly, or asynchronously from its bpf_wq or
task_work callbacks, which run in process context and keep the
SYSCALL program type.

The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
following the precedent of high_work_func(), the memory.high
workqueue fallback. Note that only the reclaim target is capped: the
actual scanning work and its duration are not bounded. Reclaiming more
than one batch is left to the BPF program rather than enforced by the
kfunc: with one call per bpf_wq callback and the same work item
requeued for the next batch, the program can also stop submitting
batches in between, e.g. once the target cgroup is dying.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 88 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/internal.h       | 10 +++---
 2 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..d8827bc388ef 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -8,6 +8,8 @@
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
 
+#include "internal.h"
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -159,6 +161,74 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory
+ *                         cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size:  the amount of memory to reclaim, in bytes, clamped to
+ *         MEMCG_CHARGE_BATCH (64 pages)
+ * @swappiness: the reclaim swappiness, in the range
+ *         [MIN_SWAPPINESS, SWAPPINESS_ANON_ONLY], where
+ *         SWAPPINESS_ANON_ONLY means anon-only reclaim, or -1 to use
+ *         the memcg's own swappiness
+ *
+ * Trigger one proactive reclaim pass on @memcg, similar to a write to
+ * memory.reclaim, but without retrying until @size is reached.
+ *
+ * Only the reclaim target is capped: @size is clamped to
+ * MEMCG_CHARGE_BATCH, following the precedent of high_work_func(),
+ * the memory.high workqueue fallback, which bounds each reclaim
+ * request the same way. The actual scanning work and its duration
+ * are not bounded. To reclaim more, call this kfunc repeatedly
+ * instead of passing a larger @size.
+ *
+ * The kfunc can be called directly from a BPF_PROG_TYPE_SYSCALL
+ * program, synchronously in the context of the thread running the
+ * program, or from the bpf_wq and task_work callbacks of a SYSCALL
+ * program, which run in process context and keep the SYSCALL program
+ * type. It is registered for BPF_PROG_TYPE_SYSCALL only, because
+ * generic sleepable programs may run with filesystem locks held or
+ * in NOFS/NOIO contexts, where the reclaim path could deadlock on
+ * those locks via filesystem shrinkers.
+ *
+ * For asynchronous reclaim of more than one batch, driving the
+ * reclaim from a bpf_wq callback is recommended: call this kfunc
+ * once per callback and requeue the same work item for the next
+ * batch, instead of looping inside the callback and monopolizing a
+ * workqueue worker, and give each target memcg its own work item,
+ * as high_work_func() does with one work item per memcg. Whether
+ * to submit the next batch is up to the BPF program, which can stop
+ * at any point, e.g. once the target cgroup is dying.
+ *
+ * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
+ * smaller than a page, or (unsigned long)-1 if @swappiness is out of
+ * range.
+ */
+__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+						unsigned long size,
+						int swappiness)
+{
+	unsigned long nr_reclaimed;
+	unsigned long nr_pages;
+
+	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
+		return (unsigned long)-1;
+
+	if (size < PAGE_SIZE)
+		return 0;
+
+	nr_pages = min(size / PAGE_SIZE, (unsigned long)MEMCG_CHARGE_BATCH);
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages,
+						    GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    swappiness == -1 ? NULL :
+								       &swappiness);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -174,19 +244,35 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
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
+		pr_warn("error registering bpf reclaim kfuncs: %d", err);
 
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


