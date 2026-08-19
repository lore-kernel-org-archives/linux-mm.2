Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C8DC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F4E6B0093; Wed, 19 Aug 2026 02:36:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D07FA6B0095; Wed, 19 Aug 2026 02:36:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA90C6B0098; Wed, 19 Aug 2026 02:36:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82BF16B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:36:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04CE21C15D6
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:36:03 +0000 (UTC)
X-FDA: 85117059048.01.7390850
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2759980002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:36:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UTEpmTvb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787121362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROiHaasuLqL5zMneidEMusmfHb0ZX+HTaMtf62jDwZw=;
	b=VZPrLRIYdqCPZQ+PiI06JhP42YZr+V9WHOh1KmNElZjzB7Il+Z/rWVdzlisBXzXNXoxVe2
	HjyprMCjCzNxAPMsYsXfBAVtwKtmzOeoWYL4GemczGU7R2q8v7vtos7FqIyztdxUhtFhn6
	MV1oBUCjLQve6f7m3XHwwoNXrUsD+MI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UTEpmTvb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787121362;
	b=0puKNhgv2hTHuyGaWxuOrsjOhmNYEWP6W09v95q/lY0nw9TS3oAtJA+gjLqvpgCp3o2rDm
	rbQ0TYz0uELeVNxuSlnJTjH20Veb56nZE5I28CaMQ0UIKFUdP31xqlQjI6nJWqvoaSA45K
	dtenatOSsHnhVuGd5JzNM9TzT7c/SXU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OCyFphCtNGo59EIP+zqGbTU7uKKjAFjnRoVLUS82u0k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787121360; v=1; x=1787726160;
 b=UTEpmTvbQGZsqLK7z96qIls76dcbHZO+9yzzvr1NAKbqrrBylTQfKXOq7HTOglyWxGPZgISd
 jOrf1C0IMoC6IB4uSqJ5ppVG+No4vrfO6RZC2UqDgP2xjyRn0ttt0OyxrCl4Ci0bzNJJymHIR6f
 8rIe+kZYVVQYVicvQb8SW2Hk=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 231faae9ec5b32d1;
	Wed, 19 Aug 2026 06:36:00 +0000
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
Subject: [PATCH bpf-next v3 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
Date: Wed, 19 Aug 2026 14:35:43 +0800
Message-ID: <0a2355a169c0900427b6e3c0d73ca6ae1be56f13.1787120833.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787120833.git.zhuhui@kylinos.cn>
References: <cover.1787120833.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2759980002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4d6jjgk38yao81cpugdmrmff6gdhk5cw
X-HE-Tag: 1787121361-812517
X-HE-Meta: U2FsdGVkX1+PcleMG0sw+JQCwQr9nOjP7p05dAW4FGJZDuSV0SL2IPR94XVy4GuXheNBVjx/4B10ATF/nCfj9D4X2z3cYymtJDhajkLNfFzqxPXOXTzVWnVxLA4xsrD9d0W96mXf9HnyZ2L5e3Squ7G+RpDZuv7l188bJsB2mp17fQo/XD0F8sv+l/jRtaQr0hrs3PZP1a2I4EQlVGAW7qJIREBC8IFp8sjIqZZ2H7jFmQqxW4IJVtbt8sumHfiMcJlnPU9A7Zs2//PSXZei024DzywYppaOHG+a3gF2DanlRfMPjMExiwYdwZqnjhNYHc4+pna7vHWHQTyTvbHnygFQxEuGUIftxzIRuFJ2viGuCrwqJJYh2F7DrA7aaCKCNMC0LeWlDtPDuo53F1xzssYFVvmnpmaoVmZ3zSuRbJUj31/T1Yn7UzdB901DEKlRrKsRIlzl9SXiNNRJz+Ui/Is3Yup+wKcMDfNNrWw8hL4cP2udDSJrrgMMEI369QqgaP3MeMRJ+UK+yVQsLAVOTN3jUeo6OLXu1dBWaJQMxEHffQLg+bBWfv22b+kp2oEtYWKY83HL+cN486M52ZsitlXReycu/6o2bqfSEEbGEB5Ls9B5XRuyOBA8zEloiL3+VqDZi+3fYfWVyZZ4fLSR1OLw5/NuETB9I8VYYuc+iVQAHl1qgXFag9USx5r3GD86MaIkKZIaNax64cLMC6WIJJJeRkrHTrZUwYgmNXaDJv9odH9DunePx8MQzUxDm23Xo9TnmA9CfqTTEtHIe5q1yE502/38sFbvMcb7WYjCe432KxQbSEKlcdUjrho7Galc2FS2v3X7Z0Os6OcrOw7SXqYf0G/en1e3qr8UHtDP0zJ16X8Rz5Z0TipSQfcYm2bEEwypNpLFoSY/ksL29Tq/xKGGbYSOh5ptXhE7oLwmXaH2Ri/u8Q25SKKRmrNvgnxG9m1eDQ2BiRSsBe20nNv
 sRua9XWU
 Zq8j7i4TkufpxjECA0nQLxQRiyK32xgj6vqncznrWM/x+1w5v1nuznt+xpx7yx63UOD3krsjcmhOnFiaiMT089drHczDlIwo+bVB0lvTbFCVWRUjNgBRmEEIz4KKVv73MY44WxAtPrpNrUtgZlQVv5FtS1koh4gG44AYntS+sax1kh3MaO0naMIxtKa7u53yfyS1dlXWXSoG1YsBIWjh8P91dukyKyHR7+w5ajSJlbnFpaS+J2Ms23gcISQ==
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
plus SWAPPINESS_ANON_ONLY. Both go through a shared helper,
bpf_proactive_reclaim_pages(), which guards against reclaim recursion
and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
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
 mm/bpf_memcontrol.c | 101 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..b0a0d4c55dc4 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,103 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
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
+/*
+ * Shared implementation of the proactive reclaim kfuncs: performs one
+ * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
+ * @swappiness as the anon/file balance override (NULL to follow the
+ * cgroup's own swappiness setting).
+ */
+static unsigned long
+bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_pages,
+			    int *swappiness)
+{
+	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+					    MEMCG_RECLAIM_MAY_SWAP |
+					    MEMCG_RECLAIM_PROACTIVE,
+					    swappiness);
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
+	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL);
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
+	if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_ONLY)
+		return 0;
+
+	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
+					   &swappiness);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -172,6 +270,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


