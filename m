Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C145EE6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 04:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BAB6B0092; Mon, 22 Dec 2025 23:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CA56B0093; Mon, 22 Dec 2025 23:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9706B0095; Mon, 22 Dec 2025 23:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 374896B0092
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:42:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE53A137983
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:18 +0000 (UTC)
X-FDA: 84249489156.10.29F5CED
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D034120011
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:42:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cmunOv0/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766464937; a=rsa-sha256;
	cv=none;
	b=MokNVd+6EPtFZIEtkvf6rygkO3QzoW68RN68p1S5A//PoU2mvmGm00uHwh+8XAd6e7HHhB
	mWoRUkTrWVfPWlYLAmXzJnyrJ4QVqQ8LdKbcZC3fcg49OdHHTErU9qgEH0a0pqSi9K1i/R
	DHDNGMVUIEwc/4HqjmHDZUj95Q19sQY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cmunOv0/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766464937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+k9Y16RYCKDsPX3GLsUDS+uvfky7DUhx3FePXUCIjEw=;
	b=a3/okNLX0/XvpQArC2WzmMV4yj8MMX60egmjIg2UB5SpyadRSlN7UeZDyqQFJBWcPOzf2v
	fqITemPn/N+JST7OIo79FJh32+kRJNxHyor6hfmaHXq2Dx3nlJkr2EteNY1LeKZvvnG5a1
	8TNZpR6283cpeYNGaTgSvyhR+ah0+UY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766464935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+k9Y16RYCKDsPX3GLsUDS+uvfky7DUhx3FePXUCIjEw=;
	b=cmunOv0/EJEY36u/ZhHKa+jnLhnbpz1jqRS25Z/VWfGFLZYYCQ+s41LnHmgQRRc4EWri8b
	rWvsufqpLc8t9ALdbvSyjisRJ1bpCOKg7CbVN4vWN4GoEjSgZcyjerNVdo++1LCkEz4jQq
	LiQQEX5XgATZcTJZxR5ZQR/SAJla4tA=
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
Subject: [PATCH bpf-next v4 4/6] mm: introduce BPF kfuncs to access memcg statistics and events
Date: Mon, 22 Dec 2025 20:41:54 -0800
Message-ID: <20251223044156.208250-5-roman.gushchin@linux.dev>
In-Reply-To: <20251223044156.208250-1-roman.gushchin@linux.dev>
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3D034120011
X-Stat-Signature: 7b1odza7n1mr4x6esi9nz6ptmbagf87g
X-Rspam-User: 
X-HE-Tag: 1766464936-927179
X-HE-Meta: U2FsdGVkX1/B3tfnlFNl0G5EJNM45iJwzHUO2gLwIOyQW3uKkYPNUyQcXKY/baCfbZbwsRy+vHS4Vq41vzuDZK9aOjalGttNcdv0Y6E+wPihOc000cKb/G5mTeGMeP3RDGz474Kg4GRT8wqKG0QPr7c3lQ7iKUNBnDT5Zhbr+qHc2pEoqXNxuhwTOQGefOlr6um3tMUgOp+p31zZa5sl5byEzhNxxeMCExpPJW00Fg9vDBTxR54xkIXgNKevZNgXteXuD+RPcuAzl0LkeX94r9ucxeVnj7W5WP04gtQtaJsKqUc8GMAKvubdS54kSZb4AokAJN33KHSsH1tENar4529H7yVvX3xEVx0Y3WV3o/RMUgHFArzzZJkwFPgwYJMUkYJHWq8c5NEgaoRthOwf2qaKSU51xDqO330xPLiYQ+urz1GgQtozqyn7VDlDrERB3vpPEQCv8jAMzZiqJK4hT++GZd2Gh8OIwEa47wt5We5k7y1aOspAoeHX5GNLtaKdG0BlqT34bEQxWKiRO1TzrQF0tCsMT4FRBph0cCVdShWn3/nlK2Tnyu8chkuWh1YUW7KB/tRsIzjdnEFa5GsUFap7+bybU2iCGr88AiiDKp2kfU8IT2Z7X7XyzXq0TO2s8tKWfWRJYYOCLiV8M548uMSdtUpPPSELfUpH28ph+iQrBQVQVCZL3XFAcBvGDP1pxHL8IIKbtXxW3lIZ8ldcNKpev+rcqDvHO4yPcOOFZ3NWALbYA/GTrRI52ML/LX3nlwsZf54yRYx2ESIoSWdSb+JwZcKOPKH0QXQFox6hFm7/tmd+95508NslzzOs3I+1q+nH5xHRrQaXL3cRBr26nzj/DjEAajEoFmbb5f8k40eMOOv8TIkg80IU3ObqEcFowF/XGrcdrCaDNBXuFF44v7GFSgKjWHef+1s5LVdu119LXOpHfYn12fezD7ueNKY0vLj16gN31PXNwcUd4L6
 uVRZL71w
 snnjVDFw6x/Lig5PDnPnKKy03iiVSdvxNzF98NSMe5ZOwumfHlEf5A/KHb/Aepjgd54Vfy6jJ6msmjsyShDw4U5EO00aYv7hOFFFJGDyHJOi3EKmr4FcTpk96Vd+jgf9bw7kINLVwhXKf7f0oAXQAzxWw+QxpK3yzelT77Isq8yMFA5+X5sV+CYg5jT7KkuATwhW+MHENrn9zP3uRXjL9NJUWcLvfMSLhVkiC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce BPF kfuncs to conveniently access memcg data:
  - bpf_mem_cgroup_vm_events(),
  - bpf_mem_cgroup_memory_events(),
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
---
 include/linux/memcontrol.h | 14 +++++++
 mm/bpf_memcontrol.c        | 85 ++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c            | 16 +++++++
 3 files changed, 115 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7bef427d5a82..6a5d65487b70 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -949,8 +949,12 @@ static inline void mod_memcg_page_state(struct page *page,
 	rcu_read_unlock();
 }
 
+unsigned long memcg_events(struct mem_cgroup *memcg, int event);
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
+bool memcg_stat_item_valid(int idx);
+bool memcg_vm_event_item_valid(enum vm_event_item idx);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
 unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 				      enum node_stat_item idx);
@@ -1379,6 +1383,16 @@ static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg, in
 	return 0;
 }
 
+static inline bool memcg_stat_item_valid(int idx)
+{
+	return false;
+}
+
+static inline bool memcg_vm_event_item_valid(enum vm_event_item idx)
+{
+	return false;
+}
+
 static inline unsigned long lruvec_page_state(struct lruvec *lruvec,
 					      enum node_stat_item idx)
 {
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 187919eb2fe2..e8fa7f5855f9 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -80,6 +80,85 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
 	css_put(&memcg->css);
 }
 
+/**
+ * bpf_mem_cgroup_vm_events - Read memory cgroup's vm event counter
+ * @memcg: memory cgroup
+ * @event: event id
+ *
+ * Allows to read memory cgroup event counters.
+ *
+ * Return: The current value of the corresponding events counter.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_vm_events(struct mem_cgroup *memcg,
+						   enum vm_event_item event)
+{
+	if (unlikely(!memcg_vm_event_item_valid(event)))
+		return (unsigned long)-1;
+
+	return memcg_events(memcg, event);
+}
+
+/**
+ * bpf_mem_cgroup_usage - Read memory cgroup's usage
+ * @memcg: memory cgroup
+ *
+ * Please, note that the root memory cgroup it special and is exempt
+ * from the memory accounting. The returned value is a sum of sub-cgroup's
+ * usages and it not reflecting the size of the root memory cgroup itself.
+ * If you need to get an approximation, you can use root level statistics:
+ * e.g. NR_FILE_PAGES + NR_ANON_MAPPED.
+ *
+ * Return: The current memory cgroup size in bytes.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
+{
+	return page_counter_read(&memcg->memory) * PAGE_SIZE;
+}
+
+/**
+ * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
+ * @memcg: memory cgroup
+ * @event: memory event id
+ *
+ * Return: The current value of the memory event counter.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
+						       enum memcg_memory_event event)
+{
+	if (unlikely(event >= MEMCG_NR_MEMORY_EVENTS))
+		return (unsigned long)-1;
+
+	return atomic_long_read(&memcg->memory_events[event]);
+}
+
+/**
+ * bpf_mem_cgroup_page_state - Read memory cgroup's page state counter
+ * @memcg: memory cgroup
+ * @idx: counter idx
+ *
+ * Allows to read memory cgroup statistics. The output is in bytes.
+ *
+ * Return: The value of the page state counter in bytes.
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
+{
+	if (unlikely(!memcg_stat_item_valid(idx)))
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
@@ -87,6 +166,12 @@ BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
+BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_memory_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..bae4eb72da61 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -663,6 +663,14 @@ unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx)
 	return x;
 }
 
+bool memcg_stat_item_valid(int idx)
+{
+	if ((u32)idx >= MEMCG_NR_STAT)
+		return false;
+
+	return !BAD_STAT_IDX(memcg_stats_index(idx));
+}
+
 static int memcg_page_state_unit(int item);
 
 /*
@@ -860,6 +868,14 @@ unsigned long memcg_events(struct mem_cgroup *memcg, int event)
 	return READ_ONCE(memcg->vmstats->events[i]);
 }
 
+bool memcg_vm_event_item_valid(enum vm_event_item idx)
+{
+	if (idx >= NR_VM_EVENT_ITEMS)
+		return false;
+
+	return !BAD_STAT_IDX(memcg_events_index(idx));
+}
+
 #ifdef CONFIG_MEMCG_V1
 unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 {
-- 
2.52.0


