Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FACECCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76706B00C6; Sun, 18 Oct 2026 21:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53986B00C8; Sun, 18 Oct 2026 21:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D116B00C9; Sun, 18 Oct 2026 21:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 699CC6B00C6
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D1F60805CD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:04 +0000 (UTC)
X-FDA: 85337606928.01.6694CAA
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03B8C180008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GiOBrcmT;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372503;
	b=cntYbUs6q076XpU8NUPl++fTkVSKX5mjqcocuhvXaNtn60k1VTODzrR/Rqt7AJ6P+32snX
	KJqDkeKZs9/hqg/vs6D0xR4bT+yTr4fEAd++AS5piCON+2kd+/LSZEVEpYQbzVP3FajTqz
	Pav8RvOulxhshYMP9ES3aVMEBwcU5TM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GiOBrcmT;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOMQVB/jXsWsIeoiodYZ/B+RDWxFCBllXDVeS82fgVc=;
	b=Zx1RJnP25BNaAlwL0SD0np6H7nAkv/SHGMi468+J+rhOyr9SE5tiGaHgcD4KZI+U0TGEBq
	Prfoh1LfQfrufMzcVee9BGCHifHxs5ETIEaO3XO70tRUKJffuqlfiVZlLPssmK5lfkaJrm
	FcM4PFgLpTiL0Cek/TN++RyicSpf1CY=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5eabf7d5bbeso1054355e0c.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372502; x=1792977302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oOMQVB/jXsWsIeoiodYZ/B+RDWxFCBllXDVeS82fgVc=;
        b=GiOBrcmTTgae+RHPyjV5T/QWCaXFW8oMapJtyY62Gm2UcXebhy4ekfVQ6Lagealw9x
         +49YcrqDRszrlB648uwwS9dMLg0Y0zgAB4qM26+eRPron9gYPXBbEIZkr/V3iLNMUPYB
         GY0E4CraJqrdwH0Gad24ke5EZ5XDyfb1SgTv5A3ZrSNlitdzXRRzFGJnpNRc49mbjBVo
         TwK4cSH8gQKmvYHvpno4+pcevd4eg+JWKot/M8ZwBh9jFY0s2cB45wHV4OzgWvME+tiY
         UurAlhNTFyfqNIuV7KTimKpLlZxZsCegFN/PlxEGWA4QJJPUE6mcrxHGFHGhJkI/UPsO
         ZRaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372502; x=1792977302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oOMQVB/jXsWsIeoiodYZ/B+RDWxFCBllXDVeS82fgVc=;
        b=bfOfCpQDgVYQC3Tu7u3ENkb8/5y+Rf0HkyBwT+usSPWWvWzB25Eq0nB1RDnbxSFYn5
         jcn+AO3nUB75aWPUIXDnz/Otvz1oo7qLrFt03DUMpjoULlLloguMMlBkoCYPB0FFvj7H
         jx1hkPw89YQOL9cUAlEgQe6xZEl5+iLyulXiDOQZGh3kDh4EEAq0eaLSrrBP1Br0mw0o
         1xP5SD5FkoA+tHbOW6VyAAj/TfkLVe9VisNlcOKLNVOJvKBBrP3zccc3ONy3v74nwv0N
         DW60cmDzwZk2tFo0kwfNBqnjWg/YV8EHVtEiYDz71rdjlnjh0yC+/axuyhMqHjNq7Vv9
         aTKw==
X-Forwarded-Encrypted: i=1; AKwUvBwHBinJ3He1HIc4jBi5Z+r4RGcNU7yCfQ4XkCPO1poUMbUM/HxKKkvCZsJkeEWcwakvT52upqoXhA==@kvack.org
X-Gm-Message-State: AFq9FYK8+gGy3fuIJGxdlgPjq6fJCRzWubWZcrHYz3zNAHt2tfyf9dxb
	Ec+hPD3REE/i2fZAcO/wiWMDdEjM2EbzXJzm6mIyVzxMP7JubIEMEUtp45BRRgw1Yfs=
X-Gm-Gg: AYBFou3G5lHN1uoQszcVMI0KgvDrAgGTQB5lW3LaGH28VtdayXeBAHEBUNuzHSUfe4N
	ZJGyWcJ+3/I3YMfpaSVX3kMFmbdRljQU4EDnjWmau/+Kg2xBo5a69u3VYhJIGMgZ+qzxMMrcgII
	Eor7VK8s0cnP/O2RMgA+3hXRSeYQhL8ITt0nrxI1ojgCehpnkm8zNqn1x4alN2JGgvZfywsRJdk
	zxFXTyYJDExE6igIr71SDqnV5Rx7qnHpXVEhAw8XMT4AbKuNuNC0TgdKE8AGkH4yRaQmeCL9UFl
	rfooLH8FbcZOccwDLQtdfnH01MzHrqU9qtwxDc1nvWs3F1XwVxKIrcVXwVv+BBWax0LVu411YmG
	fCjIOOfhFaUsCupurEnJIIYMEy28nYkv5tGtj1Z9e8BawcAggf2reCJE08UlEu0zTanpLRh77Ps
	WYC/CWzRbtiVqFdlEAvJ1oKcDpMXqut7FrhVMRijZ/EBHXSBPiTXx6SkbXp9EJpSs1CYtLw43bn
	8F4LgNKJRW81tgu/rRIozlEG+d4CPf9Yyj1CxQCBaGW8e1kDvCRuMhwUrUGF25j71SDYUD8PL26
	cGRFhvA/qgYwBd3uRfw=
X-Received: by 2002:a05:6122:78e:b0:5ea:389c:51e4 with SMTP id 71dfb90a1353d-5eaaa0c78fcmr2260825e0c.2.1792372502039;
        Sun, 18 Oct 2026 18:15:02 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:01 -0700 (PDT)
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
Subject: [PATCH v2 5/8] sched/topology: Avoid redundant O(N^3) group capacity walks and unused allocations in build_sched_domains()
Date: Sun, 18 Oct 2026 21:14:43 -0400
Message-ID: <20261019011446.834487-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03B8C180008
X-Stat-Signature: bepfnj1x814tf4nb9n3jg75x8dfbe7hu
X-Rspam-User: 
X-HE-Tag: 1792372502-992494
X-HE-Meta: U2FsdGVkX18Qf0SnvZQEFHtLIkjiHNN1s2ylTJrYtBGwd3OM+abpO/sUj6nDrPs+ZwzcqDpvPp9aUEn6H/Ovv/xuaSfEaMoyrpE4Yb2DPwQ7F8s4q4f4IFsaYE2wvvUpnlB4gWt7S9aZ2kAl9Cm7SAOyxcdNeJsYu5HmUemsKvVa0tZ87830zBW7+s5PqZ6aENtS3URaYTMKEbDthjL8kbk5+to762bqU/npdAxEbGk0LuQ2cqJNR3c6pZ+xLKXYpkp8FhFtz0NNGRp4bXbmFTI0o+zdsfihkWfX5vAxPnR8XVOEYa6MHaydAC6Jl5ryk43Bvvun2ZhYnLJ99tAbxq/cnnDUClmTB8l6OVtcU/EW+Y+5payM7QvxXIOyyAi8R/UpL/VfPOlYpPaNpjx2drfRe66i8BqcMRZRXtDyPOWbrBm8F1cyxtsW5rBHKrynDxCF2sDaxbN4K/Di1y0u0JpHN7t+MPHD1569YnQE+JjRKQzHExaM5EI7cOSdxO3MfvnVdgczHBrPv8Sv4syCXupfGbc8isIoeBP56WNGOFZPemI1pFWgi0f4fPPHnWSoAFVLbZUG9pLRLceu4Gl5kEv1tJfeUzo2akt49rvyrgHBropO5/Oz0ujBNHphfC5YB6Ef+lc8jp1hPEq1CeiCrQqa+cLQ9+EKTTATu2xVlMIKlePDSWEy9tRNp3gw8TLvnNvxD+2Mxgcu1PrbEWG+HaKBsQw8dupndSgnQicrHqJVv+OISWFBOd7PoyK3d57QfXUq+OleJQYmvDuix13fn+SrDRgwOQt8K6N/9EyL5806peiJRVPz4YrX24d2652qeYYAoBGmctSPp4smt+RkDOvdCBkU3AR3sQ0Sy1PvRmsH6GtoB2Vy4pP6F09MRRTw187usJ18afgcCdjmlv5a0r8+6/1PLQ7vnZldkiViq/VcLmFHuljMQBhYGQyNSTYezjnR5UASt690tdBo0Wx
 9qGafhob
 sGISv3fmeTgaHhFFW+QbgDtO59a6lCSDWK3VQOK83cg00+EmLV7g/jfVFJfbaD/EiNiDglp3X1rW8d3ewgufNBnBWv4cL1MrZ29F6xzpKmGHWpk6ykY/pdcsnKDliOIyeWsEZgVliQRGLZOI7Z8laRR6zabyzFxxO245UMF8oX7kUoniX1E9shfgvYu79r80diEdDLT+lStHApVJPN7qbe/BvBE5tXoMobKDDAEO96n5EjHiSNOF9Xk5hsA2nl06wc023N6pH3d+pYcQM7mEtiwaeOSKJCEmFbQFz5OiTs6V99YQxqjjiGhRuaFQ973nckl946BqLaWgHgB2jGT2ZXD3pl1Ks/x8bL+rEoC1s5W+dONZLPDKEVxXrIPs3I+Wx9+2L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During sequential CPU hotplug on large systems, build_sched_domains() is
invoked for every CPU offline and online step. Two bottlenecks in the
domain construction path scale poorly with CPU count:

1. On non-overlapping topology levels, all CPUs sharing a domain span
   share the same circular ring of sched_group instances, and on
   overlapping NUMA levels, groups with identical spans share
   sched_group_capacity (sgc). However, init_sched_groups_capacity()
   walks the entire group ring for every CPU in the domain and repeatedly
   recomputes group_weight, cores (walking the group cpumask and clearing
   cpu_smt_mask), and asym_prefer_cpu (O(N^3) bitmap operations per
   hotplug step). Similarly, init_overlap_sched_group() recomputes
   build_balance_mask() and cpumask_weight(sg_span) even when the shared
   sgc was already initialized.

2. __sdt_alloc() and __sds_alloc() upfront-allocate a sched_group,
   sched_group_capacity, and sched_domain_shared for every CPU in cpu_map
   at every topology level, even though get_group() only uses the entry
   for the first CPU of each child domain and d.sds is only used once per
   LLC (plus at most once per SD_ASYM_CPUCAPACITY_FULL domain). All other
   per-CPU allocations are immediately freed unused by
   __free_domain_allocs().

Cache group_weight, cores, and asym_prefer_cpu on struct
sched_group_capacity so init_sched_groups_capacity() computes them once
per shared group capacity, reuse already-initialized sgc instances in
init_overlap_sched_group(), and allocate sdd->sg, sdd->sgc, and d->sds
lazily on demand.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   9.85 s ->  5.15 s (-47.7%)
  Online:    8.69 s ->  4.05 s (-53.4%)
  Total:    18.54 s ->  9.20 s (-50.4%)
  build_sched_domains() (cpu479 offline / online):
    35.65 ms -> 10.39 ms (-70.9%) / 35.68 ms -> 9.58 ms (-73.2%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   4.51 s ->  3.26 s (-27.7%)
  Online:    3.15 s ->  2.03 s (-35.6%)
  Total:     7.66 s ->  5.29 s (-30.9%)
  build_sched_domains() (cpu511 offline / online):
    11.69 ms -> 5.61 ms (-52.0%) / 12.24 ms -> 5.84 ms (-52.3%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/sched/sched.h    |   9 ++
 kernel/sched/topology.c | 218 ++++++++++++++++++++++++++--------------
 2 files changed, 150 insertions(+), 77 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 499a5649582e..314fcad94668 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2262,6 +2262,15 @@ struct sched_group_capacity {
 
 	int			id;
 
+	/*
+	 * Build-time cache shared by all groups using this sgc while
+	 * build_sched_domains() runs; not maintained afterwards (e.g. by
+	 * sched_update_asym_prefer_cpu()). Use the sched_group copies.
+	 */
+	unsigned int		group_weight;
+	unsigned int		cores;
+	int			asym_prefer_cpu;
+
 	unsigned long		cpumask[];		/* Balance mask */
 };
 
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 919d0fb00bd9..a5a5d1378ce2 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1207,6 +1207,33 @@ int group_balance_cpu(struct sched_group *sg)
  */
 
 
+/* Find the group_balance_cpu() */
+static int find_group_balance_cpu(struct sched_domain *sd, struct sched_group *sg)
+{
+	const struct cpumask *sg_span = sched_group_span(sg);
+	struct sd_data *sdd = sd->private;
+	struct sched_domain *sibling;
+	int i;
+
+	for_each_cpu(i, sg_span) {
+		sibling = *per_cpu_ptr(sdd->sd, i);
+
+		/*
+		 * Can happen in the asymmetric case, where these siblings are
+		 * unused. The mask will not be empty because those CPUs that
+		 * do have the top domain _should_ span the domain.
+		 */
+		if (!sibling->child)
+			continue;
+
+		/* If we would not end up here, we can't continue from here */
+		if (cpumask_equal(sg_span, sched_domain_span(sibling->child)))
+			return i;
+	}
+
+	return nr_cpu_ids;
+}
+
 /*
  * Build the balance mask; it contains only those CPUs that can arrive at this
  * group and should be considered to continue balancing.
@@ -1216,17 +1243,19 @@ int group_balance_cpu(struct sched_group *sg)
  * can fully construct this using the sched_domain bits (which are already
  * complete).
  */
-static void
-build_balance_mask(struct sched_domain *sd, struct sched_group *sg, struct cpumask *mask)
+static void build_balance_mask(int group_balance_cpu,
+			       struct sched_domain *sd,
+			       struct sched_group *sg,
+			       struct cpumask *mask)
 {
 	const struct cpumask *sg_span = sched_group_span(sg);
 	struct sd_data *sdd = sd->private;
 	struct sched_domain *sibling;
-	int i;
+	int i = group_balance_cpu;
 
 	cpumask_clear(mask);
 
-	for_each_cpu(i, sg_span) {
+	for_each_cpu_from(i, sg_span) {
 		sibling = *per_cpu_ptr(sdd->sd, i);
 
 		/*
@@ -1277,32 +1306,51 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
 	return sg;
 }
 
-static void init_overlap_sched_group(struct sched_domain *sd,
-				     struct sched_group *sg)
+static int init_overlap_sched_group(struct sched_domain *sd,
+				    struct sched_group *sg)
 {
 	struct cpumask *mask = sched_domains_tmpmask2;
 	struct sd_data *sdd = sd->private;
-	struct cpumask *sg_span;
+	struct cpumask *sg_span = sched_group_span(sg);
+	struct sched_group_capacity *sgc;
 	int cpu;
 
-	build_balance_mask(sd, sg, mask);
-	cpu = cpumask_first(mask);
+	cpu = find_group_balance_cpu(sd, sg);
+	if (WARN_ON_ONCE(cpu >= nr_cpu_ids))
+		return -ENOENT;
 
-	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
-	if (atomic_inc_return(&sg->sgc->ref) == 1)
-		cpumask_copy(group_balance_mask(sg), mask);
-	else
-		WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));
+	sgc = *per_cpu_ptr(sdd->sgc, cpu);
+	if (sgc && atomic_read(&sgc->ref)) {
+		atomic_inc(&sgc->ref);
+		sg->sgc = sgc;
+		return 0;
+	}
+
+	if (!sgc) {
+		sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
+				   GFP_KERNEL, cpu_to_node(cpu));
+		if (!sgc)
+			return -ENOMEM;
+		sgc->id = cpu;
+		*per_cpu_ptr(sdd->sgc, cpu) = sgc;
+	}
+
+	build_balance_mask(cpu, sd, sg, mask);
+
+	sg->sgc = sgc;
+	atomic_set(&sgc->ref, 1);
+	cpumask_copy(group_balance_mask(sg), mask);
 
 	/*
 	 * Initialize sgc->capacity such that even if we mess up the
 	 * domains and no possible iteration will get us here, we won't
 	 * die on a /0 trap.
 	 */
-	sg_span = sched_group_span(sg);
-	sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
-	sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
-	sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
+	sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
+	sgc->min_capacity = SCHED_CAPACITY_SCALE;
+	sgc->max_capacity = SCHED_CAPACITY_SCALE;
+
+	return 0;
 }
 
 static struct sched_domain *
@@ -1405,7 +1453,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		sg_span = sched_group_span(sg);
 		cpumask_or(covered, covered, sg_span);
 
-		init_overlap_sched_group(sibling, sg);
+		if (init_overlap_sched_group(sibling, sg)) {
+			kfree(sg);
+			goto fail;
+		}
 
 		if (!first)
 			first = sg;
@@ -1507,6 +1558,25 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
 		cpu = cpumask_first(sched_domain_span(child));
 
 	sg = *per_cpu_ptr(sdd->sg, cpu);
+	if (!sg) {
+		sg = kzalloc_node(sizeof(*sg) + cpumask_size(),
+				  GFP_KERNEL, cpu_to_node(cpu));
+		if (!sg)
+			return NULL;
+		sg->next = sg;
+		*per_cpu_ptr(sdd->sg, cpu) = sg;
+	}
+
+	if (!*per_cpu_ptr(sdd->sgc, cpu)) {
+		struct sched_group_capacity *sgc;
+
+		sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
+				   GFP_KERNEL, cpu_to_node(cpu));
+		if (!sgc)
+			return NULL;
+		sgc->id = cpu;
+		*per_cpu_ptr(sdd->sgc, cpu) = sgc;
+	}
 	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
 
 	/* Increase refcounts for claim_allocations: */
@@ -1562,6 +1632,8 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = get_group(i, sdd);
+		if (!sg)
+			return -ENOMEM;
 
 		cpumask_or(covered, covered, sched_group_span(sg));
 
@@ -1595,27 +1667,40 @@ static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
 	WARN_ON(!sg);
 
 	do {
-		int cpu, cores = 0, max_cpu = -1;
+		int i, cores = 0, max_cpu = -1;
+
+		if (sg->group_weight)
+			goto next;
+
+		if (sg->sgc->group_weight) {
+			sg->group_weight = sg->sgc->group_weight;
+			sg->cores = sg->sgc->cores;
+			sg->asym_prefer_cpu = sg->sgc->asym_prefer_cpu;
+			goto next;
+		}
 
 		sg->group_weight = cpumask_weight(sched_group_span(sg));
 
 		cpumask_copy(mask, sched_group_span(sg));
-		for_each_cpu(cpu, mask) {
+		for_each_cpu(i, mask) {
 			cores++;
-			cpumask_andnot(mask, mask, cpu_smt_mask(cpu));
+			cpumask_andnot(mask, mask, cpu_smt_mask(i));
 		}
 		sg->cores = cores;
 
-		if (!(sd->flags & SD_ASYM_PACKING))
-			goto next;
-
-		for_each_cpu(cpu, sched_group_span(sg)) {
-			if (max_cpu < 0)
-				max_cpu = cpu;
-			else if (sched_asym_prefer(cpu, max_cpu))
-				max_cpu = cpu;
+		if (sd->flags & SD_ASYM_PACKING) {
+			for_each_cpu(i, sched_group_span(sg)) {
+				if (max_cpu < 0)
+					max_cpu = i;
+				else if (sched_asym_prefer(i, max_cpu))
+					max_cpu = i;
+			}
+			sg->asym_prefer_cpu = max_cpu;
 		}
-		sg->asym_prefer_cpu = max_cpu;
+
+		sg->sgc->group_weight = sg->group_weight;
+		sg->sgc->cores = sg->cores;
+		sg->sgc->asym_prefer_cpu = sg->asym_prefer_cpu;
 
 next:
 		sg = sg->next;
@@ -1889,7 +1974,8 @@ static void claim_allocations(int cpu, struct s_data *d)
 {
 	struct sched_domain *sd;
 
-	if (atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
+	if (*per_cpu_ptr(d->sds, cpu) &&
+	    atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
 		*per_cpu_ptr(d->sds, cpu) = NULL;
 
 	for (sd = *per_cpu_ptr(d->sd, cpu); sd; sd = sd->parent) {
@@ -1898,10 +1984,12 @@ static void claim_allocations(int cpu, struct s_data *d)
 		WARN_ON_ONCE(*per_cpu_ptr(sdd->sd, cpu) != sd);
 		*per_cpu_ptr(sdd->sd, cpu) = NULL;
 
-		if (atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
+		if (*per_cpu_ptr(sdd->sg, cpu) &&
+		    atomic_read(&(*per_cpu_ptr(sdd->sg, cpu))->ref))
 			*per_cpu_ptr(sdd->sg, cpu) = NULL;
 
-		if (atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
+		if (*per_cpu_ptr(sdd->sgc, cpu) &&
+		    atomic_read(&(*per_cpu_ptr(sdd->sgc, cpu))->ref))
 			*per_cpu_ptr(sdd->sgc, cpu) = NULL;
 	}
 }
@@ -2700,8 +2788,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
-			struct sched_group *sg;
-			struct sched_group_capacity *sgc;
 
 			sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -2709,24 +2795,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 				return -ENOMEM;
 
 			*per_cpu_ptr(sdd->sd, j) = sd;
-
-			sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sg)
-				return -ENOMEM;
-
-			sg->next = sg;
-
-			*per_cpu_ptr(sdd->sg, j) = sg;
-
-			sgc = kzalloc_node(sizeof(struct sched_group_capacity) + cpumask_size(),
-					GFP_KERNEL, cpu_to_node(j));
-			if (!sgc)
-				return -ENOMEM;
-
-			sgc->id = j;
-
-			*per_cpu_ptr(sdd->sgc, j) = sgc;
 		}
 	}
 
@@ -2767,23 +2835,10 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
 static int __sds_alloc(struct s_data *d, const struct cpumask *cpu_map)
 {
-	int j;
-
 	d->sds = alloc_percpu(struct sched_domain_shared *);
 	if (!d->sds)
 		return -ENOMEM;
 
-	for_each_cpu(j, cpu_map) {
-		struct sched_domain_shared *sds;
-
-		sds = kzalloc_node(sizeof(struct sched_domain_shared),
-				GFP_KERNEL, cpu_to_node(j));
-		if (!sds)
-			return -ENOMEM;
-
-		*per_cpu_ptr(d->sds, j) = sds;
-	}
-
 	return 0;
 }
 
@@ -2954,7 +3009,7 @@ static void adjust_numa_imbalance(struct sched_domain *sd_llc)
 	}
 }
 
-static void
+static int
 init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -2976,6 +3031,13 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 	 */
 	for_each_cpu(cpu, sched_domain_span(sd)) {
 		sds = *per_cpu_ptr(d->sds, cpu);
+		if (!sds) {
+			sds = kzalloc_node(sizeof(*sds),
+					   GFP_KERNEL, cpu_to_node(cpu));
+			if (!sds)
+				return -ENOMEM;
+			*per_cpu_ptr(d->sds, cpu) = sds;
+		}
 
 		if (!sds->alloc_flags ||
 		    sd->span_weight == 1 ||
@@ -3000,6 +3062,8 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 	 */
 	atomic_set(&sd->shared->nr_busy_cpus, sd->span_weight);
 	atomic_inc(&sd->shared->ref);
+
+	return 0;
 }
 
 /*
@@ -3015,25 +3079,24 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
  * degenerate into a single-capacity group. The relevant edge cases are instead
  * covered by the caveats above.
  *
- * Return true if this CPU's asym path claimed sd->shared, false otherwise.
+ * Return 0 on success or if not claimed, -ENOMEM on allocation failure.
  */
-static bool claim_asym_sched_domain_shared(struct s_data *d, int cpu)
+static int claim_asym_sched_domain_shared(struct s_data *d, int cpu)
 {
 	struct sched_domain *sd = *per_cpu_ptr(d->sd, cpu);
 	struct sched_domain *sd_asym;
 
 	if (!sd)
-		return false;
+		return 0;
 
 	sd_asym = sd;
 	while (sd_asym && !(sd_asym->flags & SD_ASYM_CPUCAPACITY_FULL))
 		sd_asym = sd_asym->parent;
 
 	if (!sd_asym || (sd_asym->flags & SD_NUMA))
-		return false;
+		return 0;
 
-	init_sched_domain_shared(d, sd_asym, SD_ASYM_CPUCAPACITY);
-	return true;
+	return init_sched_domain_shared(d, sd_asym, SD_ASYM_CPUCAPACITY);
 }
 
 static int __sched_domains_alloc_llc_id(void)
@@ -3179,15 +3242,16 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 		if (!sd)
 			continue;
 
-		if (has_asym)
-			claim_asym_sched_domain_shared(&d, i);
+		if (has_asym && claim_asym_sched_domain_shared(&d, i))
+			goto error;
 
 		/* First, find the topmost SD_SHARE_LLC domain */
 		while (sd->parent && (sd->parent->flags & SD_SHARE_LLC))
 			sd = sd->parent;
 
 		if (sd->flags & SD_SHARE_LLC) {
-			init_sched_domain_shared(&d, sd, SD_SHARE_LLC);
+			if (init_sched_domain_shared(&d, sd, SD_SHARE_LLC))
+				goto error;
 
 			/*
 			 * In presence of higher domains, adjust the
-- 
2.56.0.176.g3575e65682-goog


