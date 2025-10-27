Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6779CCCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 23:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7ABC800B2; Mon, 27 Oct 2025 19:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AAB8009B; Mon, 27 Oct 2025 19:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67BF800B2; Mon, 27 Oct 2025 19:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30748009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:18:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 704671402A6
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:24 +0000 (UTC)
X-FDA: 84045460128.29.D655B7F
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id BD4F8100003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:18:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqupITNo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761607102; a=rsa-sha256;
	cv=none;
	b=eich0Zirkz5986VSNFxyjEBn0hHODZqBP8U5Gul8XmjgqChWlmZT0o/6gnTmxGpwiVq7Du
	v0EAcqLY52mI83eFe3cKqid0BOjiuwosSQD9m+UCzCRo7Kwenhn41ltZoy6t6CFs2ZruOr
	NsR2lkfaBJLmNWxxXld/KX4BNQmGyJ0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqupITNo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761607102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGNhnHhDztEBZDrNzEjV2cb6TNW+GcgGJqFKk02+7Oc=;
	b=qG3v165eiwpt9FQRwQGLFdxCZ9sBUHQoX+0do5LYSKffM3DZqbdmRIxKtJJXZl+gJVF1jr
	wxFn0zMxXmD1D8gBsvEY7YbSp1pcKkiZI9YDtNQ/cvGFGUDxFjjT6dgRagsTHEePlygo9G
	SqdecXMUC2LdIPLhZkCYZK4zNqfN3uE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761607101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RGNhnHhDztEBZDrNzEjV2cb6TNW+GcgGJqFKk02+7Oc=;
	b=tqupITNoxhfGoV/jU5uxGa72WRtEc2MA2UUuBBuLyiYcN9KJcfKECP8OssfhuVWBK4P+Gg
	Gzo6bxS3AXK3JdfZpr2vpG4kLq6jv3fvy0VV3a/aLxB10cHsxyDp32h/lgkpsh2zQUY+q2
	/jigg7DGq1xMN2v9D4FMpi3kfCIlBDw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2 10/23] mm: introduce BPF kfuncs to access memcg statistics and events
Date: Mon, 27 Oct 2025 16:17:13 -0700
Message-ID: <20251027231727.472628-11-roman.gushchin@linux.dev>
In-Reply-To: <20251027231727.472628-1-roman.gushchin@linux.dev>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD4F8100003
X-Stat-Signature: u5rre5e938btx6ce8hrdftn9xkgexgcs
X-HE-Tag: 1761607102-120234
X-HE-Meta: U2FsdGVkX1+lxia0Xp8r/z6G4q4SGcfxEw+UGdFxStFkfkzMep6EMGaPGpdfndbN4RueHigeVbHQ+4ES7/tG5Ul+SO8Fx8Sd1SwkLR79n3uo+62AWbA5HB2hIUgbzd8rSQk7yKG1XDn+Yh92iXjAvT6kVvuMQBvgwTSrhQVs1gVDXKecF/X3clZcBW1Tb/zgwbVA5OCMAq9VFofX1185OT05zgTDi703m9Wv6CNTbes+C09I66Oc7h5Jd+yZlXYz8KgC33BVn/m5L0ecA+0ht9S2L9BZcALQxFIpMwxI/NNlbZ7DsltaoTfIczKrNp1UyjuccX27TLPsntPv1jDfbwy143sHPY49xMtOk4MR2aVCS43NGujiIGDD24AEsxxvqs91PLI62YNULyS6CkXr7DZDW5W++qudkpbywoqglBwn/0oEuaMj4d4IQQdRS/3I9Gkwo/eqv47ZJbh/P2zT3P11ndPcKtltv1v0/ycBGM9XIbbeKoTARcxVrLUNi18hhEeXjMFMAkOggCtpRhrwMEs/5l76OXCQeYw+RRf03LYnjfuo8O5LChq++69/2TYrNyHNKVvHXCqDhEboQ6S7pEMk7/nHaLhY9hAHTpA14pgnozruFDFTNXSse/DYmkhDJq7uC3ZWZ+MijgrO7QcdWLLxl0ldYT7UVoMiiYvZu4EiUx7s0wwBr9/nqhHofZ7iV3+lXOtRFbYR+qnOidjCRcZojX79MiWK+ku4QaaBhshAsc8ARHv5WiQPJMo+lK7CFA6LSk+WdVWEtuA7PRmelgSiMfBP1NHdv2RXLbCf1KSwHx0pGiuittk0QyWKvTeGjIcq2Ik/ssf5KyF/PaFyJrgc+42LZkgRflZo3H487vAo9CnI705d2cy3FxAHRrdki4gZYHJbgYq7aJsorqLNeDdupPvKXceOLaDCmHriRuFcUiEYtfeeGY8ykyEGIS8zXUpFJaKIIzSsO2A++Fj
 4So6+fp5
 cnv+Ld3mCGYYylzuHynV2Gfy40llh1817LQRKpM4TDew4hK8dFu8mU4egHMg7ou/BXHl6p16aebS//iFYUGCnIYQ5pWT/EuK9I+LcfCeo2pzDR76qfixl+hGnzvwEAVE5qShDrvtz+90u2Mu/yoCzCl4lSQflUemHVYy1/7Z97nZJ/tSkQ7S8bPPInNF0IgiV5OCUsoLBe6wzTz1uqx+isSssM9c9sA299fWYdYEFYmuhpc//675iCzeM6xow+hUU+jxq
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
---
 include/linux/memcontrol.h |  2 ++
 mm/bpf_memcontrol.c        | 57 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 39a6c7c8735b..b9e08dddd7ad 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -953,6 +953,8 @@ static inline void mod_memcg_page_state(struct page *page,
 	rcu_read_unlock();
 }
 
+unsigned long memcg_events(struct mem_cgroup *memcg, int event);
+unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
 unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
 unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
 unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index 76c342318256..387255b8ab88 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -75,6 +75,56 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
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
+ */
+__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
+{
+	return page_counter_read(&memcg->memory);
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
@@ -82,6 +132,11 @@ BTF_ID_FLAGS(func, bpf_get_root_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL | KF_RCU)
 BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
 
+BTF_ID_FLAGS(func, bpf_mem_cgroup_vm_events, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
+BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS | KF_SLEEPABLE)
+
 BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
 
 static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
@@ -93,7 +148,7 @@ static int __init bpf_memcontrol_init(void)
 {
 	int err;
 
-	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
 					&bpf_memcontrol_kfunc_set);
 	if (err)
 		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
-- 
2.51.0


