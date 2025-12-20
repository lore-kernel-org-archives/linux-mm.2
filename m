Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1F8E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751256B0092; Fri, 19 Dec 2025 23:13:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730F46B0093; Fri, 19 Dec 2025 23:13:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C4D6B0095; Fri, 19 Dec 2025 23:13:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 553EB6B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:13:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05F7160252
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:29 +0000 (UTC)
X-FDA: 84238530138.01.33D9132
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3FBC1C0012
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:13:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RruRHd+a;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAmHdQut5bmy5tCpMldk44XLF0pjcC9APBv9xG6KR/c=;
	b=njFq2gL4p0hC9p61b5D0ZzTrC8I9WcoFX5KeR+IeCIi9N3hueRsmMFgS5x7ji+qDDcofBJ
	d+B7Ba4SeV+B8SWF62noONnalhQ4vSnGDBNNLsYFdf3j3WilO0wQm28Pdr+ranhA6gGE1g
	bPiRn9rzTSsTzozKiPapBozbfTAnHzE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RruRHd+a;
	spf=pass (imf10.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204007; a=rsa-sha256;
	cv=none;
	b=mwGtW0ufHRxSrsgdeE5Vf8zzRGxi+39jJDSdr1WlxgffpKW2+Qq+OYVvvxBSr9tAZnuldS
	WKoxxx/IkDcT7xcL4sYs+zcrwid1OhlvrkwkbWY8zLqrK8fkbhJEWu/1Cgrn6eE4dKAKfH
	CNgD1ADqfCMwSO/IS5Co8PuSMcB6m50=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766204000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAmHdQut5bmy5tCpMldk44XLF0pjcC9APBv9xG6KR/c=;
	b=RruRHd+atc2p1QdNvLwrdQEUiCQWNyfHbiNelmPzEz8nMp6fUAaBQpvS3zIZszSKHVOW0d
	Yu/IFGRE1UBKVg6Du3HbI42yWC17q4jiGw+H0T29019J7a0jbbH0kX5g5E0TSJageutwA5
	PDMmgH5XsQPpOF623z/H+ShPfVeWEgE=
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
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH bpf-next v2 4/7] mm: introduce BPF kfuncs to access memcg statistics and events
Date: Fri, 19 Dec 2025 20:12:47 -0800
Message-ID: <20251220041250.372179-5-roman.gushchin@linux.dev>
In-Reply-To: <20251220041250.372179-1-roman.gushchin@linux.dev>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: f7hzq9nsuo4tixnin191qxzhcg8uic8w
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FBC1C0012
X-HE-Tag: 1766204007-581167
X-HE-Meta: U2FsdGVkX1+DIXtFDdkZMvzoCtpinZ/m63hBgoLQAyJxl0uckFxrCaMqXl6FXXVeWsLavRVTXu94aqZo1I2D5rNXRm2I4XKeL9HhNybPAgOA5T5xI/IGO3fqvB6BYVwctQ6FY4n5n8Tq7OE+F5VaDOncu22Th/fbaIh9+Ziw7tnkKz4Ys5o9an6ZAQk9TCoym0gj/t+7pcjd0evgolmaihOES2rE/KxI97+zjrEoKURa/FPPglErDbkS1eTX0SZURQhMVW1POqRPk20ZcQvmUsaB4HK0ThX/+rDN4o+gd13ykx/xBS1dEFydfOjzo9NS7UkEEEBG67+SCz3ACgaBcf5/lbBder/5Lf5U+sfim2H4ob0eNdLewYf13W4NnSXO3ymkdued6VJVG8554cqsRJGV8SXEjJmFhGyRpl2CZsrk1VwHjquS+suOEjc2xKuTJY2zxLcBfMkCVOUZBUcNtkG0+ldFf3qqti19TrLYlv+nKmEmHoPMwBupvRF+YiGPgZd+ut0gS2Q8s5q3kAp+74/CGi5BVa1ZoEZWhJ6fmTo11fIdyPKftEyyJD84C4yhFCyAPkPLxgRF9aV29T1XsDjX5ubxjdNINPKOUfOEpWphei8hvlvy4hfAzcscMcv5gd1JWrSiGeYUaCgZMmKgfrR6Y+KdyijGH4VT4h8ZNoDo3/Nc4TyFXbE4Pfj0mjZ3IC1nu8d118OEXZ4uVEBtbUKUTelJGZdvzRVYpAwsoFIl8VueifCOW1JXd0TSz9euIcnaIwx7YLEZR+Xo4VJ0QlyuwHqeJ+4FOjZbK1NrV2HKx6+k/xXTtHtZasDR4gbmP9kveh9kBCCMs9QzRnVIpLNfdceikE6fgSoYnVBTErSsTr4LsV+VAukYrQ0UjCfW3gJD6Pr0A40bffls3ml4opG+gGzxYvBIza5GeB5V9QUavZOCDD/x8foM3dvbBzM0zaWR1MYNLLaTaG5nWQ5
 If+Ki793
 j/tfaJOf0BWc6BRxgvmc/4zFsP6Sj0SggfGrUK/oCXLGiMc49V62/1BG8ZXM84ZbGPhsOaligUPD9hSycU8s90eFry2ha0mqb4Fg50CovxFwIzn3OeV8XA65XoyQpQz9gkOqs8qGqEm0U2tiWQDsIyB1bUuC9If2WU9zS1FmxCWMJxOce4342d0r3cNiie3ves95zXu9CQjmOo+09iRlW+MUxPP8TKGof3OmoUG93B52ieNjPNJEFjk9TdiUT/NV+3M8Ybpc8Ua9YaQASbzbPfJldxWIddflqt9WN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce BPF kfuncs to conveniently access memcg data:
  - bpf_mem_cgroup_vm_events(),
  - bpf_mem_cgroup_usage(),
  - bpf_mem_cgroup_page_state(),
  - bpf_mem_cgroup_flush_stats().

These functions are useful for implementing BPF OOM policies, but
also can be used to accelerate access to the memcg data. Reading
it through cgroupfs is much more expensive, roughly 5x, mostly
because of the need to convert the data into the text and back.

JP Kobryn:
An experiment was setup to compare the performance of a program that
uses the traditional method of reading memory.stat vs a program using
the new kfuncs. The control program opens up the root memory.stat file
and for 1M iterations reads, converts the string values to numeric data,
then seeks back to the beginning. The experimental program sets up the
requisite libbpf objects and for 1M iterations invokes a bpf program
which uses the kfuncs to fetch all available stats for node_stat_item,
memcg_stat_item, and vm_event_item types.

The results showed a significant perf benefit on the experimental side,
outperforming the control side by a margin of 93%. In kernel mode,
elapsed time was reduced by 80%, while in user mode, over 99% of time
was saved.

control: elapsed time
real    0m38.318s
user    0m25.131s
sys     0m13.070s

experiment: elapsed time
real    0m2.789s
user    0m0.187s
sys     0m2.512s

control: perf data
33.43% a.out libc.so.6         [.] __vfscanf_internal
 6.88% a.out [kernel.kallsyms] [k] vsnprintf
 6.33% a.out libc.so.6         [.] _IO_fgets
 5.51% a.out [kernel.kallsyms] [k] format_decode
 4.31% a.out libc.so.6         [.] __GI_____strtoull_l_internal
 3.78% a.out [kernel.kallsyms] [k] string
 3.53% a.out [kernel.kallsyms] [k] number
 2.71% a.out libc.so.6         [.] _IO_sputbackc
 2.41% a.out [kernel.kallsyms] [k] strlen
 1.98% a.out a.out             [.] main
 1.70% a.out libc.so.6         [.] _IO_getline_info
 1.51% a.out libc.so.6         [.] __isoc99_sscanf
 1.47% a.out [kernel.kallsyms] [k] memory_stat_format
 1.47% a.out [kernel.kallsyms] [k] memcpy_orig
 1.41% a.out [kernel.kallsyms] [k] seq_buf_printf

experiment: perf data
10.55% memcgstat bpf_prog_..._query [k] bpf_prog_16aab2f19fa982a7_query
 6.90% memcgstat [kernel.kallsyms]  [k] memcg_page_state_output
 3.55% memcgstat [kernel.kallsyms]  [k] _raw_spin_lock
 3.12% memcgstat [kernel.kallsyms]  [k] memcg_events
 2.87% memcgstat [kernel.kallsyms]  [k] __memcg_slab_post_alloc_hook
 2.73% memcgstat [kernel.kallsyms]  [k] kmem_cache_free
 2.70% memcgstat [kernel.kallsyms]  [k] entry_SYSRETQ_unsafe_stack
 2.25% memcgstat [kernel.kallsyms]  [k] __memcg_slab_free_hook
 2.06% memcgstat [kernel.kallsyms]  [k] get_page_from_freelist

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Co-developed-by: JP Kobryn <inwardvessel@gmail.com>
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/memcontrol.h |  2 ++
 mm/bpf_memcontrol.c        | 56 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index b309d13110af..8c1ba4477d36 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -949,6 +949,8 @@ static inline void mod_memcg_page_state(struct page *page,
 	rcu_read_unlock();
 }
 
+unsigned long memcg_events(struct mem_cgroup *memcg, int event);
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 2d518ad2ad3f..d84fe6f3ed43 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -78,6 +78,57 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 	css_put(&memcg->css);
 }
 
+/**
+ * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
+ * @memcg: memory cgroup
+ * @event: event id
+ *
+ * Allows to read memory cgroup event counters.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
+						enum vm_event_item event)
+{
+	return memcg_events(memcg, event);
+}
+
+/**
+ * bpf_mem_cgroup_usage - Read memory cgroup's usage
+ * @memcg: memory cgroup
+ *
+ * Returns current memory cgroup size in bytes.
+ * For the root memory cgroup it returns an approximate value.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
+{
+	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
+}
+
+/**
+ * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
+ * @memcg: memory cgroup
+ * @idx: counter idx
+ *
+ * Allows to read memory cgroup statistics. The output is in bytes.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
+{
+	if (idx < 0 || idx >= MEMCG_NR_STAT)
+		return (unsigned long)-1;
+
+	return memcg_page_state_output(memcg, idx);
+}
+
+/**
+ * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
+ * @memcg: memory cgroup
+ *
+ * Propagate memory cgroup's statistics up the cgroup tree.
+ */
+__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
+{
+	mem_cgroup_flush_stats(memcg);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
@@ -85,6 +136,11 @@ BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
 
+BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
-- 
2.52.0


