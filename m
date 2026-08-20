Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5955EC5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 06:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1546B0092; Thu, 20 Aug 2026 02:12:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8524B6B0095; Thu, 20 Aug 2026 02:12:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F2B6B0098; Thu, 20 Aug 2026 02:12:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACD16B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:12:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAE25160586
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:12:57 +0000 (UTC)
X-FDA: 85120629594.10.800FA6F
Received: from mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98AF0140004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:12:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jx3PaCXk;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787206376;
	b=trWxO3WTmNuZnIFgeBhPHpsc2AjQ+QFk23DE202MQXARmNtRaReSliNdRNCVV0fllfBMPK
	yit7gtP4ZntEIok43iVR5EKiMOI6p3woFlll74a7aOqF2X9FuHcM2ZG5JcBXlc3gtld+bL
	Q1xmHU0WEelByUOK23k+WZG715mJcBU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jx3PaCXk;
	spf=pass (imf26.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.224 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787206376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dc5G5OJQPHQHrq4L1yURoRNIMHKipHlie2uBrMTh/3A=;
	b=pUkgR8YH+8Y/sT3Jdlc9r2QH0/PhxlF8CCUjpKedT5s/vSpMnyRLU0DTDksFRjBYALyWYC
	obrckk0hFK6jASmhoItHR+TIlgEpf2qfKDekM0033UfuN7e5Btxbbtph+qfdBOMDyqPoLj
	vLeQxhI6Ue2RvZ4JXNrCDe+GTSl55DY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UALJxsMlMAeybiusza3SeD1HcmlhyFIbWbg9jJQtxXE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787206374; v=1; x=1787811174;
 b=Jx3PaCXk1G8SVkFfiUsgcn1swb3r5R33rmt81QEKZXrNEgSnaCEPK6XftizbL1PQPxADtUFn
 Vz5najfizlXbopXMpz8GVmRDdEXK74FhNOSWxGnuvo/ha+7DDzJ1kFMA0DGSaydTjJt4MSVTg7G
 vi55Bm1YuTsnPxdG3ikKUk5E=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id 6eca4aa22dcb26ae;
	Thu, 20 Aug 2026 06:12:53 +0000
X-Mizu-Trace-ID: 6eca4aa22dcb26ae
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
Subject: [PATCH bpf-next v4 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
Date: Thu, 20 Aug 2026 14:12:26 +0800
Message-ID: <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787205002.git.zhuhui@kylinos.cn>
References: <cover.1787205002.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98AF0140004
X-Stat-Signature: obdw9h4bns73ufhoshyznp4w4basrq46
X-HE-Tag: 1787206375-934534
X-HE-Meta: U2FsdGVkX1/9ZFdT+2TeFJKclwaYuVQE2XibIvr+DjQ7J5oKdtGQcFuyg/uEfONww2WPCiNvV3/j+kCiyFdqfckHv6cb6pPu/G3nCrBZp4RuqvVfKV7xlzbJC4lbDuIpuPUMTsrcGB0V2+fQCYzuhMG3mxLm00EFim4JwCYHVAWNYJEY4i6ZOodKHnD1VSedmX+pyq3Y9NTkWfb5uNMG7wgU7Eu+LoGd2/PlLRF8GWFntOovo5IqJFYVsNepajEU3BQmiXxboCdQ/4vwELXytJ0gHn82QmElwwfLSuLRc5Gi0e/esJWlRs6S60BGtNQ9xUL6a8KDCERtrh5+oYMvZPkGMKUDQQkA74IwtBBTmqekxOHn7zlx2IluBlt7dNC7BCW8HTWEB+5q3SSVbomu8S+S40ylKcX8dA0ifQgrM7rppf8ZP3xOHYspZ1Jbz8zzbwVLdy4EaOKWLiCP7l/tis/TfjNiZ6tou7GglBqdx9mg7uFikzcLnU+BgLq1M1LWySb2LaW9aQcuLeM09VbYaArMSJkBkQ7RfPnKZ/e9EISTIKvflal4EYzQMPMukcyMnY6+B2jIlm843jZMaujwEedYFL3jnqibeet6n5iYpDzMg3Mbli5WGCBbj8UWy1WRD9Py7zVhxqdTkQOHx5TpY1UDezzgnos57toSKZKlLnS7XwdwiJksgC09KvEMJh1IDHWPNO6jh+CSYrQ27ijmHp2bC2qmZkJ3tkd122rZXaBs29vT21dVYeG6w8AocpodJ1KEOkSzsgHPghtbyEMW3RCJzQVlZaEPbLsyOSH7R0W0hI1Ukggk4cNf13aya7HXxEy5weF36CgtkBpNgX7xq1Fq4o9j8ntUfkrYAdxAt39TaiX2SAsQ7bhdtts2CMADh4eQL8m3MmtgqYFw0VNo/lS5/7+9Zx/Q+lAtgPiStYSSdUUOnF+1UhWaawG1Racl76J9BOl8CY4IQfLBUHn
 xcUB/hI6
 KYNO5ctqrWjN8eTkEOufxszGQyTjBr08GpXuby9Psrd81W8Z2hht7+NYQku/vXfUfSKXrTVG+deZ4Q68eUYDKd2bjLdjqxN1bAaH2vVgcpSPtL+mSAneXH48HIZprG3RrdaX5OaRKpIr6XtO5fhN353wcWUzjXrYVdSHT15ky25+425A6h13dlLyQkgm4DYPD04ukKRmWj4bfaU/v8aqJrPH8wUrmjf8D5mWRr/Uegd9I52WzZ5KAZFXF0UXiQAlDnqLvTTLi5An3I1o=
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
therefore refuse to reclaim when PF_MEMALLOC is set or
current->reclaim_state is non-NULL. The latter check also closes the
window in try_to_free_mem_cgroup_pages() where reclaim_state is already
installed but PF_MEMALLOC is not: only a tracepoint call sits in
between, and while a sleepable BPF program cannot attach to the
tracepoint itself, it can attach to the generated trace iterator
function (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry.

The kfuncs take @size in bytes; the return value is normalized to bytes
as well, matching the byte-based unit of bpf_mem_cgroup_usage() and
bpf_mem_cgroup_page_state(), so callers can mix them without manual
page/byte conversions.

An out-of-range @swappiness is reported with (unsigned long)-1 instead
of 0, following the convention of bpf_mem_cgroup_vm_events() and
bpf_mem_cgroup_page_state(), as 0 cannot be told apart from a
successful pass that reclaimed nothing.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/bpf_memcontrol.c | 118 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 716df49d7647..dc51868b3acf 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/memcontrol.h>
+#include <linux/swap.h>
 #include <linux/bpf.h>
 
 __bpf_kfunc_start_defs();
@@ -159,6 +160,120 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 	mem_cgroup_flush_stats(memcg);
 }
 
+/*
+ * Reclaim must not recurse. try_to_free_mem_cgroup_pages() unconditionally
+ * overwrites current->reclaim_state on entry and resets it to NULL on exit.
+ * So invoking it from an in-flight reclaim would clobber the outer reclaim
+ * state and corrupt its accounting.
+ *
+ * The guards are PF_MEMALLOC and current->reclaim_state. Every reclaim
+ * entry point marks the current task with PF_MEMALLOC for the whole
+ * reclaim window: try_to_free_mem_cgroup_pages() and __perform_reclaim()
+ * do so via memalloc_noreclaim_save(), and kswapd keeps it set for its
+ * entire lifetime. A hook inside the reclaim path (shrink_node,
+ * shrink_slab, ...) executes in the context of the reclaiming task, where
+ * current->flags already carries the flag. The page allocator, the memcg
+ * charging path and node_reclaim() rely on the same flag to avoid reclaim
+ * recursion.
+ *
+ * reclaim_state is checked in addition because it is set slightly before
+ * PF_MEMALLOC in try_to_free_mem_cgroup_pages(), with only a tracepoint
+ * call in between. A sleepable BPF program cannot attach to the tracepoint
+ * itself, but it can attach to the generated trace iterator function
+ * (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry, so PF_MEMALLOC
+ * alone would leave that window open.
+ *
+ * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct compaction
+ * and vmalloc), where the kfunc conservatively refuses to reclaim as well.
+ */
+static bool bpf_in_reclaim_context(void)
+{
+	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
+}
+
+/*
+ * Shared implementation of the proactive reclaim kfuncs: performs one
+ * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
+ * @swappiness as the anon/file balance override (NULL to follow the
+ * cgroup's own swappiness setting). Returns the reclaimed amount in
+ * bytes, keeping the byte-based unit of the kfuncs' @size argument.
+ */
+static unsigned long
+bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_pages,
+			    int *swappiness)
+{
+	unsigned long nr_reclaimed;
+
+	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
+		return 0;
+
+	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
+						    MEMCG_RECLAIM_MAY_SWAP |
+						    MEMCG_RECLAIM_PROACTIVE,
+						    swappiness);
+
+	return nr_reclaimed * PAGE_SIZE;
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
+ * The reclaim runs with GFP_KERNEL, so this function must not be called
+ * from a context that holds a filesystem lock (e.g. an LSM hook invoked
+ * with inode_lock held): the reclaim path may enter filesystem shrinkers
+ * and deadlock trying to reacquire the lock. Contexts that set
+ * PF_MEMALLOC_NOFS/NOIO are handled by the gfp context inheritance.
+ *
+ * Return:
+ *   The amount of memory actually reclaimed, in bytes (rounded to full
+ *   pages), or 0 if @size is smaller than a page or the calling task is
+ *   already in a reclaim/freeing context (PF_MEMALLOC).
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
+ *   The amount of memory actually reclaimed, in bytes (rounded to full
+ *   pages), (unsigned long)-1 if @swappiness is out of range, or 0 if
+ *   @size is smaller than a page or the calling task is already in a
+ *   reclaim/freeing context (PF_MEMALLOC).
+ */
+__bpf_kfunc unsigned long
+bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
+				 int swappiness)
+{
+	if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_ONLY)
+		return (unsigned long)-1;
+
+	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
+					   &swappiness);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -172,6 +287,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
 BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
 
+BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.53.0


