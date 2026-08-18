Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B3FC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F866B015D; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFC96B015F; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905636B0160; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67FBB6B015D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:36:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F07BC1C2009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:36:50 +0000 (UTC)
X-FDA: 85113734580.29.88D3B89
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9A0E140003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:36:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxS2nSI5;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787042209;
	b=PawTipEMkyEUOwcBq6qizrlK6TMcR28y8zuADQpkl3ozadG9PzXtoYqfDgIfgSw9pE9BWq
	Gbv6f6XOLn7cq6af0iifSoG5xLYlp23Uc4+LPnawYU5mt8cTYwLRoDZa5yDx6xA7zMC75w
	8ltgzdcCtTn05HgnIkhZQIwplh7Li+s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxS2nSI5;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787042209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2f4g9sLOPXPl9cXx0mKItMPGzrEKL5DqJ2Qxzn1cvE=;
	b=1mzsNesqwg26qmTm9nrU1bqc7auxVnX3R/J258qnmSIfVfSb7qgrUa08LYotzjSTzEvLsb
	STMju2qK/BePdZ2bG5SgKh7ArkfLX/rFE3R6KK7wyHG6EEL4UidHllP2GchY0PndScFc9A
	zoN6cQXhp5Xk9yjOFUIGXxPieyKWk3w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GReinsz2jYAS8LuTZNxhDAjdV+gzaBJE35QjgXUsYGo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787042207; v=1; x=1787647007;
 b=AxS2nSI5T8MCMdlY4J0xF1udO87vv2cvYoZxK572h8blAIFgw+OVEhqQaZdFZNuL8pmbXHHq
 GlGxa9gerpVRAkodzse4ToWFbEsFfxN5sqT7IVVzWAcYa8oL0JQKOTYjmqtkk2XRlYpwVVgvCoQ
 I/7cOIyFN7v/h94oNiLdPA2M=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id f63cb70c360e837f;
	Tue, 18 Aug 2026 08:36:47 +0000
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
Subject: [PATCH bpf-next v2 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
Date: Tue, 18 Aug 2026 16:36:09 +0800
Message-ID: <ea02caf3118cfc34cb9845f75ac655abf04b7b9f.1787040082.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787040082.git.zhuhui@kylinos.cn>
References: <cover.1787040082.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9A0E140003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: fgztx3wjpiq93iuieshq4jcm8tt6js67
X-HE-Tag: 1787042208-64574
X-HE-Meta: U2FsdGVkX1/N3nrP0JzahaExMsPq2eUfwwQuJvrK5oMT+TrpDWX/6PMYbLNDs4g/Po2JotvvuMAuS4qQpQA+WLgijGQt2QnF3GWItdPArp4hbIY4/XzEPOt+sD2BbCReeVTznYx2AIz3ohxPN6avY4dDTiidXQab5HEWbiSkRXEbIos2gZPGers5W5AeSBnnauFJilg07GDPgUhC8VoaIRg3JKnRpBD9xo4TDmrCKEMChUTR0GlujwCUEfWceTMreung2e28nYcKOjo5oUdePL4YHm79XLXW4G7ylAckMUuWZkY5M37ZbsYLEV49wRujUy3mI3zUFOQ8LzN6VogKdZQK+jEl2tqOhlbQ8/fDi7+wk0gqiCNtpY1mtLcZtWJFLfTibX6o8Ws8AJcS8rw/D9/jvg9CbwqFkPCffrIDLtnVIsnI+U6+E1kh4WXt7QFfDH69CjqLRuCj3dBhcPil3FeGNQI7dI9Zkx7VyaGV/tN45THJV8g7oGW3AtBwo828gO/ivu+8yfYxk5/l9Jr2SA2Nx616hTVVLsmQmykuJMyHkOzJ9zKa4EHwOuBnceiRjlXDYhaTwNDSBE/e/nilUFMwEZu50hL+I1YCmd/BONXEPN1XHYhFIMiuJHaqqCwRpjFvH+s+yNGzo08+D31g7Wvw8AlY+K8aaSVy7gmtFtMt+VChbtFgLoLMn10kBux5RB1A0wee5RxMLEpqjQbqVN+l6rd6Gq3kWH/BrCuKeQVQHW3aE0s/5nM0O/c/anb0GmeQLPxaKmzpvRhwX1Vs4TtaZH/FdILxpZ8HkeUA5+8FaZLdF+cQ6+hBjH69Y5t0xuHeTBYciec+LE5HDPt662bi6yYB007sOIEv0+73lSldDIDXyuXnA+tjxxOo9KmAy/3CqeKNVf1gZAS9TqQueaotWzscMTe5JiZlSgPpqil+svApsPVhpn7xKKFOwJDQq1Mmgqi4rPkIfzdhH5+
 02uc3AeI
 yrD6loASHxD0ZktZa/LZpa83ipab77ik8CckU/3ilF+bonE36JcKX3N+UUHqpfICJLVp03Vkke49ehKM+oykZV9KnGQxD1XJuZcuMgcfn+z+9BwtrW6F9GvM6hVrkyqClPW5vDdTzXRFWlvY6u39wMX28+RlgcSHlQsLU/obIWB93ThZ4iD1ORCId2AXm9+po8iocPzzPkkCTxbMWeb0o4838+sem9wZLtU20FrP4QxOAxP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Expose memcg proactive reclaim to sleepable BPF programs:
unsigned long bpf_proactive_reclaim(memcg, size);
unsigned long bpf_proactive_reclaim_swappiness(memcg, size, swappiness);

They perform one reclaim pass on @memcg, like a write to memory.reclaim:
swap is allowed, and the anon/file balance follows the cgroup's
swappiness or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS]
plus SWAPPINESS_ANON_ONLY. Both delegate to
try_to_free_mem_cgroup_pages() with GFP_KERNEL and
MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
user_proactive_reclaim() uses, and unlike memory.reclaim they do not
retry until @size is reached.

Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
current->reclaim_state on entry and NULLs it on exit, so a nested call
from an in-flight reclaim would corrupt the outer reclaim state (e.g.
MGLRU dereferences current->reclaim_state->mm_walk). Both kfuncs
therefore refuse to reclaim when PF_MEMALLOC is set, mirroring the
guards in the memcg charging path and node_reclaim().

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 95 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..92272f9a5825 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,97 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/*
+ * Reclaim must not recurse. try_to_free_mem_cgroup_pages() unconditionally
+ * overwrites current->reclaim_state on entry and resets it to NULL on exit.
+ * So invoking it from an in-flight reclaim would clobber the outer reclaim
+ * state and corrupt its accounting.
+ *
+ * The guard is PF_MEMALLOC. Every reclaim entry point marks the current
+ * task with it for the whole reclaim window: try_to_free_mem_cgroup_pages()
+ * and __perform_reclaim() do so via memalloc_noreclaim_save(), and kswapd
+ * keeps it set for its entire lifetime. A hook inside the reclaim path
+ * (shrink_node, shrink_slab, ...) executes in the context of the
+ * reclaiming task, where current->flags already carries the flag. The page
+ * allocator, the memcg charging path and node_reclaim() rely on the same
+ * flag to avoid reclaim recursion.
+ *
+ * In try_to_free_mem_cgroup_pages(), reclaim_state is set slightly before
+ * PF_MEMALLOC, with only a tracepoint in between, which a sleepable BPF
+ * program cannot attach to.
+ * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct compaction
+ * and vmalloc), where the kfunc conservatively refuses to reclaim as well.
+ */
+static bool bpf_in_reclaim_context(void)
+{
+	return current->flags & PF_MEMALLOC;
+}
+
+/**
+ * bpf_proactive_reclaim - proactively reclaim memory from a memory
+ *                         cgroup
+ * @memcg: the target memory cgroup to reclaim from
+ * @size:  the amount of memory to reclaim, in bytes
+ *
+ * Trigger one proactive reclaim pass on @memcg, similar to a write to
+ * the memory.reclaim cgroup file: pages are reclaimed according to the
+ * cgroup's own swappiness setting and swap is allowed. Note that,
+ * unlike memory.reclaim, this does not retry until @size is reached;
+ * callers can invoke it again if needed.
+ *
+ * Return:
+ *   The number of pages actually reclaimed, or 0 if @size is smaller
+ *   than a page or the calling task is already in a reclaim/freeing
+ *   context (PF_MEMALLOC).
+ */
+__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
+						unsigned long size)
+{
+	unsigned long nr_pages = size / PAGE_SIZE;
+
+	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+					    MEMCG_RECLAIM_MAY_SWAP |
+					    MEMCG_RECLAIM_PROACTIVE, NULL);
+}
+
+/**
+ * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
+ *                                    memory cgroup with an explicit
+ *                                    swappiness
+ * @memcg:      the target memory cgroup to reclaim from
+ * @size:       the amount of memory to reclaim, in bytes
+ * @swappiness: swappiness override for this reclaim pass
+ *
+ * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
+ * balance is controlled by @swappiness instead of the cgroup's
+ * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS]
+ * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
+ *
+ * Return:
+ *   The number of pages actually reclaimed, or 0 if @size is smaller
+ *   than a page, @swappiness is out of range, or the calling task is
+ *   already in a reclaim/freeing context (PF_MEMALLOC).
+ */
+__bpf_kfunc unsigned long
+bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
+				 int swappiness)
+{
+	unsigned long nr_pages = size / PAGE_SIZE;
+
+	if (!nr_pages || swappiness < MIN_SWAPPINESS ||
+	    swappiness > SWAPPINESS_ANON_ONLY ||
+	    unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+					    MEMCG_RECLAIM_MAY_SWAP |
+					    MEMCG_RECLAIM_PROACTIVE,
+					    &swappiness);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -172,6 +264,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


