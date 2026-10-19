Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AA8CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3721D6B00CA; Sun, 18 Oct 2026 21:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5706B00CC; Sun, 18 Oct 2026 21:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2F66B00CD; Sun, 18 Oct 2026 21:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2EB26B00CA
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 641731204FA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:08 +0000 (UTC)
X-FDA: 85337607096.07.00A75E0
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC2DE1C0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FXVgoqso;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7TMpawWNRts1XohqXN2q0I/cO8xOP35tsLvrs3bwC0=;
	b=ONjVyG2+q07bhsrdoA+Wo2m3X5gZrba/qiWF6iDE+z9TkZvEOvoZCTUMyJVQUA/XQvidhC
	7YYIBew+1YW5wsiF/Z1JSNXhZDaRO3sRJCCtQqYByfc3u8CkJifBXy6/Im5+L96jIUDul/
	hMp3RPLgVPtis5zt9cM4oKJCeOSV2Ik=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=FXVgoqso;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372506;
	b=j6/9NIm+uwL7J7sBsjfsnAJEKA1JAE0voQns/ObqlOp4C+YBrIrOWhdjpWK7OyYbaTx+kH
	HES+Q8qEWWVDX4cFL0lexgq2bt3feC1+UEGcCHH161foK1CJ8PWh5qmOM7iyAjz7heAgqv
	D6JrYMmsM+9w7eOo172W8Q5g5YJNVIU=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eaa1b5b84aso2118785e0c.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372506; x=1792977306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=j7TMpawWNRts1XohqXN2q0I/cO8xOP35tsLvrs3bwC0=;
        b=FXVgoqsoGdrcA9bf9h0WJYGhWO9gU/TR2AI2K9dOqmz4M9cpVTmXIO6cV+mUs6DVVS
         QuBWtnIkiWgrIt+QA7jc6N6O4v2OIECLwwpjuaFGOwZlocysCls7NFK/eWoQMxKyaE4b
         xS9ZjiyVn1bKzoJJJqg8UQ4A9re+PP3tTZF2csimnVkhPdrEola5cEntuVx63sKTzzqf
         ccSQAD48vpLWm3uB3pg/AAnwDtRAjCxGD/xm/uUDq9mnigLkAYTI6yb9FzwkzUgyfFEH
         0Ns6bu8txPhWZ0ci0gg5QDIcxAblBvt2loOIf307NGSAd0Ai0tA4j58m5z1hVMYm3GpZ
         xQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372506; x=1792977306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=j7TMpawWNRts1XohqXN2q0I/cO8xOP35tsLvrs3bwC0=;
        b=LWAZJeMYXxFZdRdZbYawLTEprlPsCgd/pT5jcp12YFgWg0gp4JXnc8ObOLG/CCw4+a
         FyD/utYUSyqHOM8kJav/JI1GuLAHQdcbo1Yn2m4p7FTJAI9dg02FzfnMC1uBnCpG2Bgj
         AyBOfTXGgzI/cxSGwCmGgUYK2IQc2//O3vVSANkAbgLP2T2Rg6/iPQ/w3UW1sTsxutyD
         i3HjDww/NPF320P+43ehehMsuIbPWSvftioipXNpojP4VhjsXyw5INsTOiBjAK9Z4YT3
         tZMJPS4tURxNHpXFF6QDRmzTWhcUdjl7wzmWuiS0Wiel3oo6ZYYirpxLMBGY/UzydU8x
         SfGg==
X-Forwarded-Encrypted: i=1; AKwUvByqA7aHaIit3kn1VBZZehzJBFWKftb61yO0uCp28s/+SJm8rnYvhPEP3KIWKJSUaM3WJAyvQ+vKQQ==@kvack.org
X-Gm-Message-State: AFq9FYJgdztC2VUJBoYqwJmovCVEeD9RIs9XGEPZsTAGwGcmpcN2Ox4F
	NihLdv+fmu4Kz4hdczFZtKqqv/Hp+isENcbIId0Re+4TbXQVsl1qq/SwOtWRY77/+pU=
X-Gm-Gg: AYBFou20Xs2F5U+4EUK/vtc1wGMM4/8ditTjv0niDuGgJBaEM8RUOD8bium7dv33puM
	L+iPBwUhtMzJpq60C3wz6RpB04SrdKiHiItBfaFPjjgirMo2Bz17zzxth16eI8EZmN1G46tgEF/
	FXWkr4zX8KnB3pN+5oN9PQYwVyt4f6Vw/rM4QR99vWnOoP8vg9zovMe2H5Crt7qA/ZUv0dcfRbq
	/FHQtM+K/bmxcjcacnSZ9Wan0Zn69v8fnnPINVuvH/z4H0VwdL+j7N47G1KyG3ftOaGUcxoHwql
	t6DFzZluihK/gxyEp9UcdbLxpwQ+9YQbCLsQkiXggFbZNylaxVVW/zOjQdM0iBjHTbPXXX8eenD
	8sVDmVrhVmiAwnrIgeO4byIOHei+GSTJ8Ios8aGiLA2XgPkEQASbUbMi3gZHAkbf6Sr/ynMKbgs
	es9dOsrJ0hCHb6iMbJ2EjGaB6lgU+VVKJgbdPjXDwbQ7M73KLHDqJ0DXGzxYMug73z5nkiddrYD
	fYQ5pEYmr7nT/X11dyvB96N9iBJgdYF7NwcINTdfYf6/x+MfvLZTItWC3ElkNy6FSQ/ReFFzq24
	Ng7IULwhzi1znN2FdvM=
X-Received: by 2002:a05:6122:4f9a:b0:5ea:c984:5ad4 with SMTP id 71dfb90a1353d-5eac9845f53mr360485e0c.2.1792372505877;
        Sun, 18 Oct 2026 18:15:05 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 7/8] sched/topology: Avoid redundant percpu allocations and bitmap walks in build_sched_domains()
Date: Sun, 18 Oct 2026 21:14:45 -0400
Message-ID: <20261019011446.834487-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 58orprqxe35i56s5e4tocguimq3yjks9
X-Rspamd-Queue-Id: AC2DE1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792372506-935766
X-HE-Meta: U2FsdGVkX1/OpwKT45ffP7CAZoioPMCaub/yYIkriUEdM/aI1T//iYrwZx/Ra99bGzuoDqnmCsKVt2FBghyOQ6qHOs1vgFY020he7OCEi4h/q6XfKPausPDPgILpfKFE4AnnmVzkW1274d0PgeElu8jZ9LE5mG48uiomV6dCkIyC8DgqyLePJcFHdh1QXL3c3ncdaPK9siRlHgTipEZc9Mcgb64BRabXxC1ZtXGCYxN/V7ApRy22NkM2Z6Qphou4qC9HQo2oJLPTR7FxBggAaxaGqy6XHE75GTHJUxix11xDAlXv7u5PxjMOjn1iDXLpWK9a33TNYjzdvg2FtCM1RnVnT99A+7bWrZXzrkNPloPk/uc2aJgpNY+aLcpC2hrsghw6RLbQhw4xED1M9v7j9oCWolAUlYbdeMpHOojFRUDfHxRK7Ijt6gyx9TSFFHku/Co4XnMVpZtNqBKphsjcyyFdL45pcKt8Mdbxpy+25/7I/LHMhilbNet6t0jqP+oq3TxDR1yldAlBm46/sxXZ7yjkR78bgM2gyQLCpmk5w52JIESV3ywhttzPl7PSvNJBYuw4oi6udbMBagI6urh4Qw2EdXcPJoBxQprk/8c6mKbpZhhVqy24K51KDqAfYR5rglAGtzDP6rsmooNmUTCcmaDaY6vXEvCp454XIaRKVpvmMY9AipB/fxzVuvon0fUNq5Ixj1AUmpDpLt2JhRaLOxsdzqC7VQK7hP5hSroKnx6QbZ54L2aIoKCpY8R0ERqT7zHWs58LZUylM75PnVz8vqw4O3aCjnRNIJtSlLbhIFUg1zgo8XYQj4ZWtGN2teraVbaxLUfXt6GXXilUBkberQqWU4b2IgFEEYp01COhBPTWoXzVoBdG4rCEzzWrpSs3CkYiInv8d9oPmb47tN9d7J0Fc7lv0phcPBJHCCdlLi75GgMuWC1cp2c7OJ1We1ISVx2u6LsVy9Lkfr59JnS
 5UpuNBMy
 OYkzk1aS/yMygRLDEI6vijHpsFDXBCPcREnZNDufx+N1Ke0WeiEAxm+792L3TVCve9QTh8oKK2fasuTZbjvTQzgJS/xUoIwbr2cOuqp0qzGJ1wrthWYktsdSLE4jwZHVlS18yO2J19bMVaahxJR6Q1I3D5UJ7MMbnvmPGAiicldj+0B3mIkyUdNPCnxauJng+n57NevzzjYoqDRPR7ClMfZ4kg+3N1TC7bf6CkvVhP47OssCP29c2Ep1EbLBTUcI8CpiFJNQjcjmTZYNxNBHZwFFgV+JYQ+94szmUXJOFuztGIMhIPnGaW5rm5htmwktFBPvJ6cjv5xE+ThN0mZDviFkyaQo/hoSKVrpxoOb9gezhTnLy/00/3YNIBDRN2ZtGGATV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During CPU hotplug, build_sched_domains() is invoked on every CPU
activation and deactivation. Profiling build_sched_domains() on a
480-CPU Intel Xeon 6985P-C and a 512-CPU AMD EPYC 9B45 shows several
sources of avoidable O(N^2) and O(N) work per step:

1. build_sched_groups() and build_overlap_sched_groups() iterate over
   every bit of sched_domain_span(sd) via for_each_cpu_wrap(i, span, cpu)
   and check cpumask_test_cpu(i, covered) one CPU at a time, even after
   entire child groups (e.g., 120-CPU NUMA nodes) have been added to
   covered. Instead, track the remaining uncovered CPUs
   (cpumask_copy(uncovered, span)), clear each built group's span with
   cpumask_andnot(), and advance directly to the next uncovered CPU.

2. __visit_domain_allocation_hell() and __free_domain_allocs() allocate
   and free 3 * nr_levels + 2 temporary per-CPU pointer arrays via
   alloc_percpu() / free_percpu() on every domain rebuild. Reuse the
   per-CPU pointer arrays across domain rebuilds (serialized by
   sched_domains_mutex), clearing entries in __free_domain_allocs() and
   only freeing the topology-level arrays when sched_domain_topology is
   replaced in sched_init_numa() / sched_reset_numa() (serialized
   against domain rebuilds by the CPU hotplug lock).

3. sd_init() already computes sd_weight = cpumask_weight(sd_span), so
   initialize sd->span_weight directly in sd_init() and reuse
   child->span_weight in get_group() instead of recomputing
   cpumask_weight() across all domains and groups.

4. Reuse the first LLC sibling's computed llc_bytes in alloc_sd_llc()
   and sched_update_llc_bytes().

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   3.88 s ->  3.37 s (-13.1%)
  Online:    2.51 s ->  2.06 s (-17.9%)
  Total:     6.39 s ->  5.43 s (-15.0%)
  build_sched_domains() (cpu479 offline / online):
    7.91 ms -> 3.96 ms (-50.0%) / 7.51 ms -> 4.26 ms (-43.3%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   2.77 s ->  2.34 s (-15.5%)
  Online:    1.53 s ->  1.12 s (-26.8%)
  Total:     4.30 s ->  3.46 s (-19.5%)
  build_sched_domains() (cpu511 offline / online):
    6.55 ms -> 3.04 ms (-53.7%) / 5.28 ms -> 3.20 ms (-39.4%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/sched/topology.c | 171 ++++++++++++++++++++++++++++------------
 1 file changed, 122 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index b5dec7f486b5..33210fd9dc2c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -917,9 +917,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
 			top_llc = parent;
 
 		if (top_llc->flags & SD_SHARE_LLC) {
+			int first = cpumask_first(sched_domain_span(top_llc));
+
 			sd->llc_max = max_lid + 1;
 			sd->llc_counts = p;
-			sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
+			/* All CPUs in top_llc share the same LLC size and weight. */
+			if (first < i)
+				sd->llc_bytes = (*per_cpu_ptr(d->sd, first))->llc_bytes;
+			else
+				sd->llc_bytes = get_effective_llc_bytes(i, top_llc);
 		} else {
 			/* avoid memory leak */
 			kfree(p);
@@ -1018,12 +1024,20 @@ void sched_update_llc_bytes(const struct cpumask *cpus)
 	 * own LLC domain to scale its share of the physical cache.
 	 */
 	for_each_cpu(i, cpus) {
+		int first;
+
 		sdp = rcu_dereference_sched_domain(per_cpu(sd_llc, i));
 		if (!sdp)
 			continue;
 
 		sd = rcu_dereference_sched_domain(cpu_rq(i)->sd);
-		if (sd)
+		if (!sd)
+			continue;
+
+		first = cpumask_first(sched_domain_span(sdp));
+		if (first < i)
+			sd->llc_bytes = rcu_dereference_sched_domain(cpu_rq(first)->sd)->llc_bytes;
+		else
 			sd->llc_bytes = get_effective_llc_bytes(i, sdp);
 	}
 
@@ -1370,19 +1384,18 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 {
 	struct sched_group *first = NULL, *last = NULL, *sg;
 	const struct cpumask *span = sched_domain_span(sd);
-	struct cpumask *covered = sched_domains_tmpmask;
+	struct cpumask *uncovered = sched_domains_tmpmask;
 	struct sd_data *sdd = sd->private;
 	struct sched_domain *sibling;
 	int i;
 
-	cpumask_clear(covered);
+	cpumask_copy(uncovered, span);
 
-	for_each_cpu_wrap(i, span, cpu) {
+	for (i = cpu; i < nr_cpu_ids;
+	     i = cpumask_next(i, uncovered),
+	     i = i < nr_cpu_ids ? i : cpumask_first(uncovered)) {
 		struct cpumask *sg_span;
 
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
 		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/*
@@ -1395,8 +1408,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		 * Domains should always include the CPU they're built on, so
 		 * check that.
 		 */
-		if (!cpumask_test_cpu(i, sched_domain_span(sibling)))
+		if (!cpumask_test_cpu(i, sched_domain_span(sibling))) {
+			__cpumask_clear_cpu(i, uncovered);
 			continue;
+		}
 
 		/*
 		 * Usually we build sched_group by sibling's child sched_domain
@@ -1438,7 +1453,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_span(sg);
-		cpumask_or(covered, covered, sg_span);
+		cpumask_andnot(uncovered, uncovered, sg_span);
 
 		if (init_overlap_sched_group(sibling, sg)) {
 			kfree(sg);
@@ -1579,12 +1594,13 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
 		cpumask_copy(sched_group_span(sg), sched_domain_span(child));
 		cpumask_copy(group_balance_mask(sg), sched_group_span(sg));
 		sg->flags = child->flags;
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE * child->span_weight;
 	} else {
 		cpumask_set_cpu(cpu, sched_group_span(sg));
 		cpumask_set_cpu(cpu, group_balance_mask(sg));
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE;
 	}
 
-	sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sched_group_span(sg));
 	sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
 	sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
 
@@ -1604,25 +1620,24 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
 	const struct cpumask *span = sched_domain_span(sd);
-	struct cpumask *covered;
+	struct cpumask *uncovered;
 	int i;
 
 	lockdep_assert_held(&sched_domains_mutex);
-	covered = sched_domains_tmpmask;
+	uncovered = sched_domains_tmpmask;
 
-	cpumask_clear(covered);
+	cpumask_copy(uncovered, span);
 
-	for_each_cpu_wrap(i, span, cpu) {
+	for (i = cpu; i < nr_cpu_ids;
+	     i = cpumask_next(i, uncovered),
+	     i = i < nr_cpu_ids ? i : cpumask_first(uncovered)) {
 		struct sched_group *sg;
 
-		if (cpumask_test_cpu(i, covered))
-			continue;
-
 		sg = get_group(i, sdd);
 		if (!sg)
 			return -ENOMEM;
 
-		cpumask_or(covered, covered, sched_group_span(sg));
+		cpumask_andnot(uncovered, uncovered, sched_group_span(sg));
 
 		if (!first)
 			first = sg;
@@ -1911,16 +1926,21 @@ static int __sdt_alloc(const struct cpumask *cpu_map);
 static void __sds_free(struct s_data *d, const struct cpumask *cpu_map);
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map);
 
+static struct sched_domain * __percpu *sched_domains_sd;
+
 static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 				 const struct cpumask *cpu_map)
 {
+	int j;
+
 	switch (what) {
 	case sa_rootdomain:
 		if (!atomic_read(&d->rd->refcount))
 			free_rootdomain(&d->rd->rcu);
 		fallthrough;
 	case sa_sd:
-		free_percpu(d->sd);
+		for_each_cpu(j, cpu_map)
+			*per_cpu_ptr(d->sd, j) = NULL;
 		fallthrough;
 	case sa_sd_shared:
 		__sds_free(d, cpu_map);
@@ -1942,9 +1962,12 @@ __visit_domain_allocation_hell(struct s_data *d, const struct cpumask *cpu_map)
 		return sa_sd_storage;
 	if (__sds_alloc(d, cpu_map))
 		return sa_sd_shared;
-	d->sd = alloc_percpu(struct sched_domain *);
-	if (!d->sd)
-		return sa_sd_shared;
+	if (!sched_domains_sd) {
+		sched_domains_sd = alloc_percpu(struct sched_domain *);
+		if (!sched_domains_sd)
+			return sa_sd_shared;
+	}
+	d->sd = sched_domains_sd;
 	d->rd = alloc_rootdomain();
 	if (!d->rd)
 		return sa_sd;
@@ -2072,6 +2095,7 @@ sd_init(struct sched_domain_topology_level *tl,
 
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.span_weight		= sd_weight,
 
 		/* 50% success rate */
 		.newidle_call		= 512,
@@ -2212,6 +2236,24 @@ void __init set_sched_topology(struct sched_domain_topology_level *tl)
 }
 
 #ifdef CONFIG_NUMA
+static void __sdt_free_percpu(void)
+{
+	struct sched_domain_topology_level *tl;
+
+	lockdep_assert_cpus_held();
+
+	for_each_sd_topology(tl) {
+		struct sd_data *sdd = &tl->data;
+
+		free_percpu(sdd->sd);
+		sdd->sd = NULL;
+		free_percpu(sdd->sg);
+		sdd->sg = NULL;
+		free_percpu(sdd->sgc);
+		sdd->sgc = NULL;
+	}
+}
+
 static int cpu_numa_flags(void)
 {
 	return SD_NUMA;
@@ -2502,6 +2544,7 @@ void sched_init_numa(int offline_node)
 	/*
 	 * Copy the default topology bits..
 	 */
+	__sdt_free_percpu();
 	for (i = 0; sched_domain_topology[i].mask; i++)
 		tl[i] = sched_domain_topology[i];
 
@@ -2560,6 +2603,7 @@ static void sched_reset_numa(void)
 		kfree(masks);
 	}
 	if (sched_domain_topology_saved) {
+		__sdt_free_percpu();
 		kfree(sched_domain_topology);
 		sched_domain_topology = sched_domain_topology_saved;
 		sched_domain_topology_saved = NULL;
@@ -2761,21 +2805,38 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 	for_each_sd_topology(tl) {
 		struct sd_data *sdd = &tl->data;
 
-		sdd->sd = alloc_percpu(struct sched_domain *);
-		if (!sdd->sd)
-			return -ENOMEM;
+		if (!sdd->sd) {
+			sdd->sd = alloc_percpu(struct sched_domain *);
+			if (!sdd->sd)
+				return -ENOMEM;
+		}
 
-		sdd->sg = alloc_percpu(struct sched_group *);
-		if (!sdd->sg)
-			return -ENOMEM;
+		if (!sdd->sg) {
+			sdd->sg = alloc_percpu(struct sched_group *);
+			if (!sdd->sg)
+				return -ENOMEM;
+		}
 
-		sdd->sgc = alloc_percpu(struct sched_group_capacity *);
-		if (!sdd->sgc)
-			return -ENOMEM;
+		if (!sdd->sgc) {
+			sdd->sgc = alloc_percpu(struct sched_group_capacity *);
+			if (!sdd->sgc)
+				return -ENOMEM;
+		}
 
+		/*
+		 * The slot arrays are kept between builds. Every slot for a CPU
+		 * in cpu_map must be NULL here; lazy allocation treats NULL as
+		 * "not allocated in this build". claim_allocations() and
+		 * __sdt_free()/__sds_free() clear the slots, but only for
+		 * cpu_map, so a build must not fill slots outside cpu_map.
+		 */
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
 
+			WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, j) ||
+				     *per_cpu_ptr(sdd->sg, j) ||
+				     *per_cpu_ptr(sdd->sgc, j));
+
 			sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
 			if (!sd)
@@ -2801,30 +2862,41 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
 			if (sdd->sd) {
 				sd = *per_cpu_ptr(sdd->sd, j);
-				if (sd && (sd->flags & SD_NUMA))
-					free_sched_groups(sd->groups, 0);
-				kfree(*per_cpu_ptr(sdd->sd, j));
+				if (sd) {
+					if (sd->flags & SD_NUMA)
+						free_sched_groups(sd->groups, 0);
+					kfree(sd);
+					*per_cpu_ptr(sdd->sd, j) = NULL;
+				}
 			}
 
-			if (sdd->sg)
+			if (sdd->sg) {
 				kfree(*per_cpu_ptr(sdd->sg, j));
-			if (sdd->sgc)
+				*per_cpu_ptr(sdd->sg, j) = NULL;
+			}
+			if (sdd->sgc) {
 				kfree(*per_cpu_ptr(sdd->sgc, j));
+				*per_cpu_ptr(sdd->sgc, j) = NULL;
+			}
 		}
-		free_percpu(sdd->sd);
-		sdd->sd = NULL;
-		free_percpu(sdd->sg);
-		sdd->sg = NULL;
-		free_percpu(sdd->sgc);
-		sdd->sgc = NULL;
 	}
 }
 
+static struct sched_domain_shared * __percpu *sched_domains_sds;
+
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
 {
-	d->sds = alloc_percpu(struct sched_domain_shared *);
-	if (!d->sds)
-		return -ENOMEM;
+	int j;
+
+	if (!sched_domains_sds) {
+		sched_domains_sds = alloc_percpu(struct sched_domain_shared *);
+		if (!sched_domains_sds)
+			return -ENOMEM;
+	}
+	d->sds = sched_domains_sds;
+
+	for_each_cpu(j, cpu_map)
+		WARN_ON_ONCE(*per_cpu_ptr(d->sds, j));
 
 	return 0;
 }
@@ -2836,10 +2908,11 @@ static void __sds_free(struct s_data *d, const struct cpumask *cpu_map)
 	if (!d->sds)
 		return;
 
-	for_each_cpu(j, cpu_map)
+	for_each_cpu(j, cpu_map) {
 		kfree(*per_cpu_ptr(d->sds, j));
+		*per_cpu_ptr(d->sds, j) = NULL;
+	}
 
-	free_percpu(d->sds);
 	d->sds = NULL;
 }
 
@@ -2863,6 +2936,7 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
 			cpumask_or(sched_domain_span(sd),
 				   sched_domain_span(sd),
 				   sched_domain_span(child));
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 		}
 
 	}
@@ -3213,7 +3287,6 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	/* Build the groups for the domains */
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
-			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 			if (sd->flags & SD_NUMA) {
 				if (build_overlap_sched_groups(sd, i))
 					goto error;
-- 
2.56.0.176.g3575e65682-goog


