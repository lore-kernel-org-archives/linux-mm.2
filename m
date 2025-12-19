Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3301BD711D3
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE906B008C; Thu, 18 Dec 2025 20:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9308A6B0092; Thu, 18 Dec 2025 20:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697E76B0093; Thu, 18 Dec 2025 20:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 510E76B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:58:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F30F6C04C8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:18 +0000 (UTC)
X-FDA: 84234560676.12.7176261
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B4E08000B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:58:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DFfbZWiC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766109497; a=rsa-sha256;
	cv=none;
	b=X8picsOCsXStcOOr95aGe2FQ9pd4bVqKHb85VdhF3AwqLLSgWGPfvgCYs8HM1ypH5s7+9M
	e6UnqdBIN54sIw1NvGm4l4f5GxbVsMnUBEGar3vW3pLJ2Ua2XhwpVLNnFO5ZJxcEcPqyeq
	V84YvA6KnjyTW3EtAVXxQnUJlH1O10o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DFfbZWiC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766109497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTktsG7ST0CgeUUMGlE5kKsDclUE4lDCG2tInOPeljI=;
	b=6kQswx4mPIkTWXkOxe620245ra1sd5CruND4dXOIQLkX7MU+ivrSqdhogDZhSlTi29pS/K
	KlGlPutQ4lmrmMmzymLllE3Oi6AFdJ0doOjRNGJFhumPbc4FCNaLFVTn7f27vl7XRnOaM9
	5jT/EPFl9bphU4LFoZZqkg9Twpw5lhM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766109495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bTktsG7ST0CgeUUMGlE5kKsDclUE4lDCG2tInOPeljI=;
	b=DFfbZWiCA55KAw8LDUto63tYUC/7C46Wrgqkf7IkJsWlewiLqPtgh8oEIBwP6b4dV3EnMR
	nCFsu7r+TmfSu3YCi/VQYo0DMUKk6dRck+8Lrd2d014ZYfTKhMB6dyNq0b7vso3kFciW9U
	BNA6Ha17E7WuPhvvkK9sx80Y0m+uZpc=
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
Subject: [PATCH bpf-next v1 4/6] mm: introduce BPF kfuncs to access memcg statistics and events
Date: Thu, 18 Dec 2025 17:57:48 -0800
Message-ID: <20251219015750.23732-5-roman.gushchin@linux.dev>
In-Reply-To: <20251219015750.23732-1-roman.gushchin@linux.dev>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4B4E08000B
X-Rspamd-Server: rspam03
X-Stat-Signature: q67wfxws3oggxihxsrcpytbrcrpb7ujk
X-Rspam-User: 
X-HE-Tag: 1766109497-867847
X-HE-Meta: U2FsdGVkX19NsknPOJ7OLgTZBSxicFJ0jlPK3e4W9TTIn6pxJCQirWXhzF010mlvId00gfbqHAETzxtjgGpahkPaESncZvVVwmSWk1VdkISkVYbjrB+eqTjKbkTr+1UK7s5b7DsR4/+bLU8GW7jgKGK2SNI2qKujqzPifEBiRaiSUIkwf4Eg9ttelDbqgmIob/2QxDgFPxtFAYv9Yf+tHBnp/Q1avYN9lif1Rbo9444Wfl4bQsJbwT4p2mQJSY0qR8e5pXD0m0K+J5SzqHEiWCO333w7Lkcu17rks1wpvWHGbJr7MOYvgthmKk7yP24vhA1T1SzcTEipH99ipg297pMddg6uP4yj3HhK9sqr+eSdsCVNFO7ZNeGbVa6F4qb0ojPQZWmasoKD7xW+vDY8htWHTzP7KjxAAx1kdhasH2aDOieHy8S2OMV5Tt+eGBoIad55i1/SV2WNOgal6nFOAJ0Plpe8R3gO5V4yS9mo4FpKmjWm48Mlzu4qcarnmmD4w9mHzjSKBHm14bwHnBvX5lIBvdg/RuEtdkipCyL7r3rrK4ii9QKsHNOPb6jcSX6mHVHT9PtymnK/r6en5/3tlgF487BrpUwwLhPFv0uB3YqRS/mp0WsYU6+gS8ZDbdmMJ003+3rQsZThyFK8jJg5KFC8gjiBuCsjp5iEInSJ1BRIsDWrUh1RbBpfASCOfEJ+VNBoIW4w1y7ATg6WhQ1foocR7UTEVWvVOy7CTOZAC97CZPTxWodOFV7sTi9L+dcSWV8cC4KaB36jEuZCAz0jZV12WVLbsVBlMpNiAkCX+zq7rz63xSSIQJPItwaVb7F4usQBUNYwH7ZwBOORTrYg03XkvKVyes+Oap1sEOqRdiffubL7evyc4Ts6Vn7mJ/btcbkhTlQQo8zI+LuJBR8ODgVyxjHeA9aRFWQkKJG286M+r5G/9aBMbk3sviVimKf2/DT4QjhB4ay5qF57+fP
 9EZaAGx5
 98+qImRlhaketm4L4PuIj6kpVgkNFPRjdFQVZ3jlVmbJwr07Zji9AGsp4saJCKrA3lvwmBgFtXZceVIfVceP7wsE8UWuI18KdPR9vS9RaV5z/ypcbhXq8Jrka4O6OUg2V7Dap3ZMEftzCIEtgcm5GqHihZLtU4PNs/IG8DgO+MB8zjUgCTRXORXpCjg9kPZdiuHIZsyMLdZGZISNmlXLNZFqOoYUfvtGGYSOlX7nZgdf2aBRXMKgsUSaGq20Yhfh52u+tzvx71iDvY5tmLEKOOV6jDg==
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
 mm/bpf_memcontrol.c        | 55 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

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
index 6d0d73bf0dd1..4d9d7d909f6c 100644
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
+	return page_counter_read(&memcg->memory) * PAGE_SIZE;
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


