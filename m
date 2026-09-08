Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00017C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C436B00A2; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD016B00A3; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD1706B00A4; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0446B00A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:11:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FF3C160470
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:55 +0000 (UTC)
X-FDA: 85190027790.23.51D936B
Received: from mta0.migadu.com (out-31.mta0.migadu.com [91.218.175.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C9B0C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:11:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wD93d/jD";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.31 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5rL7nt0vYx1tBK19++uw+3dR4ZZzg6Cf5DDlpGW3nQ=;
	b=4S8tqnz34HYmGvj+xo+A1fs76FPhxXXxAOLOZjmEdyBCE4E2CsO+53iWEPQYn3OZnobZwH
	p8BwGQy3ps3ntcYt1tiHsYWJh1+ItjbT+0/I1Wb+r8yvnnwvJlSa/1LZX/79kZkbQV69ou
	zKahsYFRtSMMC7VvkXmXV/7ACEJ+/+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858713;
	b=69I0YdFdZdp+QSGtxZSnyKn8GOQjLNS/F2kfYw1++LeVA05poOwwqafhh/E+Zl6w5BX8mx
	7TtsGV1WqDi3+iAatKRGlVY8dd9oTxZkHxwdjIwAXfN4CraHlQ+AQBsQM0X7liok/lGJKt
	u8vo20P+9Oxte/UKzJL2/hoNZ9UY6u4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wD93d/jD";
	spf=pass (imf28.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.31 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fhWEdSTjs9B2MAlTgThpgs2j4iGNoPGiSJakWwaXUGY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788858712; v=1; x=1789463512;
 b=wD93d/jDxGKweuS6SP0neFuPg8CIxfSQ4YsaJ0VkX3FvKgoyIlKDceE0oUVl9KBTQ0fFRMyh
 yPDJwQ8r4r2QiiobXPsvnOTdmyOALJ1zs4Gx33b2f/Y1sPOrUjIqcaP3xqpcPrwpnofATJ8M04i
 ilkM5LvQ8yvm40BeJBGjZPtM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 616980083be58a88;
	Tue, 08 Sep 2026 09:11:51 +0000
X-Mizu-Trace-ID: 616980083be58a88
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
Subject: [PATCH bpf-next v9 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Date: Tue,  8 Sep 2026 17:11:27 +0800
Message-ID: <06452a0d7722c92a38fdfd117954d244c3e52d0e.1788857915.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788857915.git.zhuhui@kylinos.cn>
References: <cover.1788857915.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: srxsi715iusz6wbn3apxmgzn1n5c47ea
X-Rspamd-Queue-Id: 8C9B0C0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788858713-511796
X-HE-Meta: U2FsdGVkX1/8d+hz8eSVPLqVg1RPARZOBffFDJ7wOFjtWSeJeN+7BuDN1Q1COnmatW4kvu7X0gGqQNJlsJ2/OdAX2cK4vtv+TrnOcDRnh9QSR93VL3t/Ul+kMNbn+d47XWRyij8SCVKFa56WivWLO3ezshPONdz7gFnTjN1jYP6yrgPGbRZ80dzEmNMa5wqr0ZLAkD4zhWgNQi3NqISZDmPTzfT7KPNsJriTCfq/w1saKlmkSYlokoUS1O6OXcmFZQvEJZXnidNM/C9ExlWdW2dWw+LNg/DdAvzI+9V0JVJqcnxhBWgcd23XIpEQdRohm8VaarG3hsRusdDcanISSijxHwB+ooEsQQD8XJyQfW5zkbLUrRS/W7oP1Z53NqZxH4TIMzatQj7Kq25iWwtUqV66LYwJO4o7R8NEU9KxaQfZtcqEkHs6igRgZrB2XXXMp1pzT7PdQv/QT6iJew/EOdQUBUgw19b/NXSuwcND5uh4f1Zfg9Nou0EDSxQ11c1CR5mHYAoeMEBKpBScvIOpgLU+i00zpTpARNPlomZEUBDiBq6iSoGLRsWOwbO3WV5xcd9sTAeR/Ej8e4kkKRuGSSXKxtg7+R5RstFYSecHowaP9Pa0N90a3M5Doltryup2FbCpF/xI1sZkR8jXhi2TDLZAigx+TZ9QQSguUKlpkETCpiULtZr9AUrd/c6zCkzaFrVOrjGQ1ug+OrMqLbvYTW7cieS2HJu1THEz6s/ArCmwzgT2liQ6Wf7WIYxM0Lmh8c+h+8BweoiscAbtwFAtqbpxdrvlz/od3UUwA8hZrvvs+LgoVSFuB2k5bwEDBcCmlCkLNVxxzuNRp1jCpp2480YBZt+8XvqXyn10VUpPWRv9IlAPlkTAXRvAM+gdSR0skW561DTn1Xsxo0GvbkNIqS0ptGmIndvf4sxwRlzR2K21xVvwpvx7yDml8QsZ/3RHYKCyxwNuN3ts5zn8Jms
 nmOJxXiQ
 ZLklNBxAvxzWNZkPX6JH39EFtYtKUS6TWdFqzUunRJzw6IkhvXY8ffTGO1YpQMimoLpe+oGWd9rYuBUnk8XAWxiLqFrW5Nl2yidJPqh7UQK81WeYAlIU4LIKS4jocNIHCWdCaK7U0P5nGt8BcBqTsOXBUSKdRVYXvgy2UY0lsOvvCnQOHdZ6pEQnYEOloEcxMPoduMXqFCZ80GF2Piyqj/yUkWRcg9oCYpte9/oTftjRMvuc=
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
workqueue fallback, which bounds each reclaim request the same way
and uses one work item per memcg. Note that only the reclaim target
is capped: the actual scanning work and its duration are not
bounded. Reclaiming more than one batch is left to the BPF program
rather than enforced by the kfunc: with one call per bpf_wq callback
and the same work item requeued for the next batch, the program can
also stop submitting batches in between, e.g. once the target cgroup
is dying.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 88 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 87 insertions(+), 1 deletion(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..2817c6db9a5d 100644
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
@@ -159,6 +162,73 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
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
+						    swappiness < 0 ? NULL :
+								     &swappiness);
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
-- 
2.43.0


