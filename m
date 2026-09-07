Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EBD6C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B8D06B009D; Mon,  7 Sep 2026 03:09:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390376B009E; Mon,  7 Sep 2026 03:09:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CD666B009F; Mon,  7 Sep 2026 03:09:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E77A66B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:09:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CEBD4065D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:09:23 +0000 (UTC)
X-FDA: 85186090206.13.909265F
Received: from mta1.migadu.com (out-5.mta1.migadu.com [95.215.58.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id B858740004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:09:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fmHdHfaR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788764961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9T2w8V1PMq6BjY6clDbak2lAhBNZRnye+1nDhPdaZDY=;
	b=eFF9pGJub4bCxo6Z4opEdznXLEdvPgCfkrSglk8HEGhNvfD8VsDAEJcF2+ry+MI4eGEvMk
	kj9AlL/pauTgs24f8fN1hOlJrG6ACpKWR2hVyJUgupccCl1l+541y3bZgjJ8txWUwmzmz/
	pxQ7D2IpjVhd8CEJm5fPIgaY9Pxzm44=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fmHdHfaR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.5 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788764961;
	b=216X230wt2mCJSp3XyHp2gtfsx1/J8W6c0cVEWbKFWsoYpBFrtZNZZY2TsYA2DAhkvTo7s
	NJa1cVbb0QlOiuNzv8vhmFCHOCvqH23WxZulmM5fCgFq5IwW+9tjJrxf1q8zktes9XVI11
	6Xz7rut/EfeSY12zcMGu9UFQVUg8tS4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kaUSBsmbXUIhnagLpCb0TJMLdmRDradcNb5ZURBLdfs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788764958; v=1; x=1789369758;
 b=fmHdHfaREV4K/q5Oq/qDUCDKxhNUwzspDGddGFbCMCFhDatOH/ksCyIMxneIm2nv4IptwxqL
 qIiK1YwPYT0nQGCQWWL9Soof3QqUtQjESxTgrhS9NtAARVUM+kVeECmEgC4yTl2Vvl7x0J/mzJX
 mRgSwEap7y0Il5LGhARiEtS0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ceef0c02fe0baa6a;
	Mon, 07 Sep 2026 07:09:18 +0000
X-Mizu-Trace-ID: ceef0c02fe0baa6a
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
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
Subject: [PATCH bpf-next v8 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Mon,  7 Sep 2026 15:08:52 +0800
Message-ID: <0f1e2b5408aef7baaacf7306dff5f6d4fb91e441.1788764121.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788764121.git.zhuhui@kylinos.cn>
References: <cover.1788764121.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B858740004
X-Stat-Signature: 8ghu14g6f6wkxrg1tbhayopiscrdqpn5
X-Rspam-User: 
X-HE-Tag: 1788764959-168117
X-HE-Meta: U2FsdGVkX19RU2RjNRpU8GHYFc7S7EyeHaRd1Knfk47pIHTrAcztVQf1BckHtXbo5cdd5b6eaHxidb0FM3UYxmDdgnz3lzovL1MBVLqH5nyU4iREnHRBhkB7+sraEPtAtDZJPFw6UXgSkX0KUQ9z+2YGQhfgsHawUt5LnTtpkerlw1h8Sz4YBAxEPF6Rrwm7t/eY1/cnUz520lfOPZ9JY3nPVi25zpaNydR5CP0nb+6b5C7LiLrfJDEy4ldGJZf9Rjm0s+FfMwFZ+ERLrmOSbVFxR+VYIbtMETQlVELBMZshlEBcPId9N5pxBcSmhfG9wOR1e0Q4LoG9ywa9nnE3wkP2Dv1+4hPYkNMvOSGERvF0+6UGL8L6lRMhz4ODhn8X7SbRt6A5EO+GxgyXgW8DpI8o01IF013CX8adUgmliSR+ToQgONIy/bLccbgiivroBgwiAygLlG0N9xADEyw84Qq5rxQK7LKKEMGXXTzFfuHTJuTdr2/nof81/5O/HhazjZFGVMUKvuUyTNHI0GVOETIhnSaDlRwq4X/dsLyzrQLOu1JiVPduraYQyuSJJAwKJWUIp+wlERbf89yUsDQsvKABdO/Xw9OuqYpkV7mvWt/WiBBp+p2xdBnhf4T8fjWyBVeUOAWEFhfQt8rkQQXH8clg399z26uO+rI2hZTBTNox6OCCugcIa9GxZ8mRjJ6U8OJHH8ljrwwPtyxpKsW8lo0r0UVVJ1P4eXhv/SsH+qebtM5n7OmI8cUDS7NU9yMOaeBlkUur+XyV7Xyp0og1d5APfQjBlYCDBKQMxtz3guKPT8jFBtHbmqKeEd/hjpxexmWQdos7bb4bdd8C2GJAZEOXTop/GHNUpfBknqHGvL0qCL5a9m3YQsLPy7PZkqEvgBqjH5a+XbDSNOGzO/uEV+j00jIgaV80/dVXD4ui3SZ4vi7D6o1f5EsvkHyZRfHQpvtpp5YUxh6hKjnNkLH
 ubaB9iQw
 aiZkUWypJYEjTgAYjpxgQ2yTolHZUe6yQa6oFHoRAt5o9Sg2eO/AROmblw5GZRngBWxkCUE/owm43NgS3HjX1SRb7PlxomgevoNvUMET8YlCenOZ5FQDYK1X3kUXj1uZO/ifGnMDln/7SCG0V0+HzTE6sCb27BntqLQfLg7eQScRickYKM5LGMb/A26WcWYHwqYmNBcGFr9u7TYa4pTHJ1th/co6g2S+QmX5zhs/vADl+y6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
proactive reclaim pass on a given memory cgroup, similar to a write
to memory.reclaim but without retrying until the target is reached.

The kfunc is restricted to BPF_PROG_TYPE_SYSCALL so that reclaim
always runs in a clean process context. Generic sleepable programs
may execute with filesystem locks held or in NOFS/NOIO contexts,
where the reclaim path could deadlock in filesystem shrinkers. A
SYSCALL program can still drive reclaim asynchronously through
bpf_wq or task_work callbacks, which run in process context and
keep the SYSCALL program type, so they can call the kfunc too.

The reclaim target of a single call is clamped to MEMCG_CHARGE_BATCH.
try_to_free_mem_cgroup_pages() takes nr_to_reclaim as a lower bound,
so nothing else limits how long one call scans. An unbounded call
stalls other work on a shared workqueue, and since lru_lock is held
with interrupts disabled the contention delays IPI handling and can
cause CSD lock stalls. MEMCG_CHARGE_BATCH is the bound already used
by high_work_func(), so each call becomes a bounded unit of work.

Reclaiming more than one batch is left to the BPF program. This is
documented in the kfunc rather than enforced: call the kfunc once
per bpf_wq callback and requeue the same work item for the next
batch instead of looping inside a callback, and give each target
memcg its own bpf_wq item. Keeping the policy in BPF lets a program
decide when to reclaim and when to stop, e.g. once the target cgroup
is dying.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 94 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..74ccac30c011 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,8 +6,11 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
+#include "internal.h"
+
 __bpf_kfunc_start_defs();
 
 /**
@@ -159,6 +162,71 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory
+ *                         cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size:  the amount of memory to reclaim, in bytes, clamped to
+ *         MEMCG_CHARGE_BATCH (64 pages)
+ * @swappiness: the reclaim swappiness, in the range [0, 201] where 201
+ *         means anon-only reclaim; a negative value means the memcg's
+ *         own swappiness is used
+ *
+ * Trigger one proactive reclaim pass on @memcg, similar to a write to
+ * memory.reclaim, but without retrying until @size is reached.
+ *
+ * @size is clamped so that one call is a bounded unit of work, matching
+ * the memory.high workqueue fallback in high_work_func(). To reclaim
+ * more, call this kfunc repeatedly instead of passing a larger @size.
+ *
+ * This kfunc is restricted to BPF_PROG_TYPE_SYSCALL to ensure it runs
+ * in a clean process context. The SYSCALL program can schedule the
+ * actual reclaim work via bpf_wq or timers, which also execute in
+ * safe process context (workqueue, task_work).
+ *
+ * When reclaim is driven from a bpf_wq, call this kfunc once per
+ * callback and requeue the same work item for the next batch rather
+ * than looping inside the callback: a long-running callback stalls
+ * other work on the shared workqueue, and because lru_lock is held with
+ * interrupts disabled the resulting contention also delays IPI
+ * handling. Give each target memcg its own bpf_wq item, so that
+ * reclaiming one memcg neither serializes behind nor piles up on top of
+ * another. Deciding whether to submit the next batch is up to the BPF
+ * program, which can stop at any point, e.g. once the target cgroup is
+ * dying.
+ *
+ * Must not be called with a filesystem lock held: the reclaim path
+ * may deadlock on it via filesystem shrinkers.
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
+						    swappiness < 0 ? NULL :
+								     &swappiness);
+
+	return nr_reclaimed * PAGE_SIZE;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -171,22 +239,44 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
-
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
+/*
+ * Proactive reclaim needs a clean process context, so it is restricted
+ * to BPF_PROG_TYPE_SYSCALL. The bpf_wq and task_work callbacks that a
+ * SYSCALL program schedules run as the same program type, so they can
+ * still invoke it; generic sleepable programs (e.g. fentry on reclaim
+ * paths, inode_rmdir) cannot.
+ */
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
-- 
2.53.0


