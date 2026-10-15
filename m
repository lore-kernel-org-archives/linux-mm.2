Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28221CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 215EC6B0098; Thu, 15 Oct 2026 11:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE0D6B0099; Thu, 15 Oct 2026 11:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B51F6B009D; Thu, 15 Oct 2026 11:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D68CA6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 524EF1207BB
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:46 +0000 (UTC)
X-FDA: 85325255652.21.7C0BD6F
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4692618000E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OkO2knL5;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRVjYPIptXeZue/0tQ2bv1jjJkRW9EshCpZbkUsbSi8=;
	b=SC17oo8Qa9h2h0FStSPQXL0ccrn7eqAJKiIfRnWWuVg9886z+/o2TP3+aU8Ap8Usm68WOy
	s8gtiVxifVdUD+fTEDSWKFiJvdEf49OH7EDwaorfg2/y4F0g69GTSuONxfmWyza5Sny4l+
	ycfZ1HaV2HimsFUi/1kUcNzYeiWsKF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078424;
	b=QNirZed/m1ep2p+QAuBQKNlMHZW1rJ6F78R2pLuhwLLvW/mPvFXtTOPEbLcgzHlORqgwE1
	v25e+6+/l3z8e2e/PpPUXAor+ze6ydHcKt8ziT4zGGSH/vvSbeVxt38k6A8dI/PbPAE+DG
	MsJetx00gOCbcqbNC9KCNH2QzyqVMbk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OkO2knL5;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7c03a445cb8so1133955137.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078423; x=1792683223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=VRVjYPIptXeZue/0tQ2bv1jjJkRW9EshCpZbkUsbSi8=;
        b=OkO2knL5ozqBYSPDS2+7vb2f0qN4GaVVLDToIJJjhg9ZHCJYK8SO1JgGfpnbbGm1kS
         RojEjOg3fbZwK9/J55PAX736aAVimGMxUgQ2YCwLzLJxB9RgmK5IUJh9lqDzBCrP71Kz
         mqtLE6QJhhg5aJHAns9BWPPGPi5K7LSU5s+2750WRoXGMymo/2qL15HALbwI13iU6NOu
         sP1B7xbAOdc7GD84HWsnqepgwKy7WrByexntEVYBIdGXA2ToKe2jwGxmzyRdffP8SDgP
         CNnvEF9Bn3l/0lZsSoYpQVoBAZ5ga2lEHKVg37+deQFf+LF9BUrziaxYiPkrd6VIy+8E
         h9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078423; x=1792683223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=VRVjYPIptXeZue/0tQ2bv1jjJkRW9EshCpZbkUsbSi8=;
        b=Ee2tWuNGEVmqFceZsER0+L2vJ8Viky59rPUiGAbAyIV/HwyRBbgxM1GE3vyy6N5Fio
         /vNykAwI9OiPhmUKdVg6JsAh9TCJT6ULf09vQAYiA1HowOvW7jd2tFLY6+zav3xPpKIv
         /C0oVympd2tyP0q0K2pyGZyavW4b+MJw/EhbPZ67Qg2gyjY43YuZXWzHMDGAkS9XEFdk
         +RyGLjUpddsVAJNGrzf2tSrWnOdoFeOxxgHFpgYJSzfuzPGsiKLcLLoOMwjATWcPZ1R3
         vcEKCQGn8UJoG9bAbJFGdV8d1BnbutruCfxjZXsCkfsIk0Gdj/76LBsblvblsh6XJuxj
         Opfg==
X-Forwarded-Encrypted: i=1; AKwUvBy9X1Cf+Az1ntopyhfg+iYnn3inxQ//9pqBUsdf4RisVkflgdWQvd6Jlk/dNHVJYJnCv1sge0p8uA==@kvack.org
X-Gm-Message-State: AFq9FYL5dG50G8x8iCEWt0N4Zo79BjwvgjOYw9imVupOJC5bJCw6wKXc
	Ye+ql8UwL/lHJqWZ1hJvWQtCxsjDfSv+Iwai/Gt1nwsV1otPuvKopwz66CRFi2xXZyA=
X-Gm-Gg: AYBFou1EbMW+D06H8U0XMn/NpI8ZhhnIbR36JNPTYWus/xwfoKOtjBFR/7TT0Y6Z+Jb
	hRnfMqMDSdVHmmPI4CJbE/ay1Twzg2/Gmi6BMqw6tEkYvezPEKpXFtGEphBtPIW6DcylSKEeS9l
	k83TQNHWgy9UNW1c9HOwktclytVAF2EO/x5hXujbpkzN5QnODFUdL1wCuB8kxpuHVy4yJHzUP8j
	QxXMD/cRfTDnUFYKch4OGX4+TpFlGpBHIs2QleShOC4h42EaQ8QbzzCYJlj2ipqcvgDtReL+sxo
	zGrPnLNRKKI6XmVOdl3Sufsor4KsCWV4FqBehSH9+7ksbAxU0+Q7gGwG/MTXzbk/9I+VBa5yFWj
	LzLxpt66bdKhYJAdgDWnCMSeibnQGMb1i4viWObf71YlzZ0h0ZI7LWQYq8qYtfXwzSHxIcsCzd8
	5eQBkUsQSrbVy38uDPEg8QUgCN51RD24jjhaMilCEDW1K8hesQYwIk9G7/P4bwb7TE3XH96A9pN
	z3U0TXnQdNhFo/PIoiihAit5bubgddmPPNz8GLDlK/wouyicCXpvUjxL89rQbC0KTX9GHJQEyxJ
	gOa3mBPj9fL3ZxbdRBs=
X-Received: by 2002:a05:6102:4427:b0:7a7:19aa:8a88 with SMTP id ada2fe7eead31-7cb3750190amr5949566137.35.1792078423308;
        Thu, 15 Oct 2026 08:33:43 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:42 -0700 (PDT)
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
	thorsten.blum@linux.dev,
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
	tj@kernel.org,
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
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 5/8] sched/topology: Avoid redundant O(N^3) group capacity walks and unused allocations in build_sched_domains()
Date: Thu, 15 Oct 2026 11:33:28 -0400
Message-ID: <20261015153331.1872641-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4692618000E
X-Stat-Signature: z5c3kc7yp5daho76itoh8subugfzozyt
X-HE-Tag: 1792078424-345208
X-HE-Meta: U2FsdGVkX1/IsEaG+mY++0JqNzsoXoQ65qaNqKLknxHefW61ZlhszuzPtE0NsLOav4hv1aIIH51X8Iwr0hXRkE8yV66hs1Nwl4LlHNTG+3zAyyk9uNeZTRX/JFt3q0aPtskJvRqDzSaL3n5CtLA6YYfQCWn4d252noIg/VGPFYQDWXkXCnqvuzRNHN9y7/45GVMDXDULNFrnut6y2Pl6EMvxsICnhpTLaK3eoX4ItJlFsfu2gO0UhNFK1bGsR+RLpyViL0ATp4hY2TkQ7UWvNTrDzsDP2gmpHRRJ6fseXbAjMN0mSU/szdffQ68z/o+vM6EtXbtkdJUoTEowRrMuySct2Gn63NzbZNrBtLt7rPjUGbwcG4FGXcLz8/DeW85lO7pOkcQlOY82kPJCdBpfczu1rp7883YuhMJYYdu+nOAwKb//hJ+2Tnny7/Hn8P4jGq7AFf1UkyRCo3FlqGNowOl8GNVJdnDHHUYA9QG0ZAHJxWIxTqDhDsyffLRDvZuD4tz6yo5DdBQtYB5X5Ramm4XF5y+xGUuOYSmsEq04eRxtow1yQKlS8bVTCSNJZYsNOBaYas8s39Ymj2/dwr2psbW+ot9WQLdaLipGrkoJDhztm8152aIEb2ouf+bnkPblOAQuwoMcXhS6gWLXDF0p68naipZtxEHDGnm9Sk+TF768ztip1Rema2JFiY52pY5bGbOsVpoxW43DXvmQ5qw4JU3ljf7yMiJkSWSBAaTh73Mi1Jh6wTcCyBmOg8cWr8tp9mHek8Z4kSTIvUjjgi+OYhc+JajoxRVhWfIzNkIAsl0v45CkaE3D1wEsRGXz7qkCfk11cheApO5ry6C51Au9binI88N6vbL/ZSdmV2tRLs+MP/XRUmFEZsMrHw9AjXIf0T8hnfUmIe6d4yxZfQDwFFPQ1ELht72B0JtYU+2SDX9aAmvuK63GMvi3fJc7oNiQh9eEQxa6jCf/gvNcj4D
 5+2fzmc2
 fKdt5khOdmgsgmWggOADqvZxV2SlHabhXuEcu/UNOZmoo6TgMwz3uDudSWXV2qzQcG9YVfyK0tny+FtLkxbVgSANxKEGZc263ws7o8ZMssppElZwq4zVCM/0MOvPeApPMtUUV94PAGiE3LUttJucxLZybIePihAJnMDbAkH4HoKCFWluOrzAaX0KJ2d8H26gw75xFtxKbwW8vLd+O4frxK0qEFtBHaQ5NG7bERo3k63jT6Zd0qLM4WRBQOXq5VkN4To8FGmHVvoIZ6qKBHdk833S4XBsEo5PdIfJ8gxwrGznI0WMYHgpUI4Kt++wqtWCqoSFlj+o0wOIeks2A2J5qYtOsTzyLxccfqUgIiW3d6f66wMzPhzS+7xnL3pFlDAMXvs6w
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
 kernel/sched/topology.c | 183 ++++++++++++++++++++++++----------------
 2 files changed, 117 insertions(+), 75 deletions(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e656c7059bf86..b76e2cd695025 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2261,6 +2261,15 @@ struct sched_group_capacity {
 
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
index 0248227d983a7..02c38089a80c9 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1259,32 +1259,49 @@ build_group_from_child_sched_domain(struct sched_domain *sd, int cpu)
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
-	int cpu;
+	struct cpumask *sg_span = sched_group_span(sg);
+	struct sched_group_capacity *sgc;
+	int cpu = cpumask_first(sg_span);
+	struct sched_domain *first_sd = *per_cpu_ptr(sdd->sd, cpu);
+
+	sgc = *per_cpu_ptr(sdd->sgc, cpu);
+	if (sgc && atomic_read(&sgc->ref) > 0 &&
+	    first_sd && first_sd->child &&
+	    cpumask_equal(sg_span, sched_domain_span(first_sd->child))) {
+		atomic_inc(&sgc->ref);
+		sg->sgc = sgc;
+		return 0;
+	}
 
 	build_balance_mask(sd, sg, mask);
 	cpu = cpumask_first(mask);
 
-	sg->sgc = *per_cpu_ptr(sdd->sgc, cpu);
-	if (atomic_inc_return(&sg->sgc->ref) == 1)
+	sgc = *per_cpu_ptr(sdd->sgc, cpu);
+	if (!sgc) {
+		sgc = kzalloc_node(sizeof(*sgc) + cpumask_size(),
+				   GFP_KERNEL, cpu_to_node(cpu));
+		if (!sgc)
+			return -ENOMEM;
+		sgc->id = cpu;
+		*per_cpu_ptr(sdd->sgc, cpu) = sgc;
+	}
+
+	sg->sgc = sgc;
+	if (atomic_inc_return(&sg->sgc->ref) == 1) {
 		cpumask_copy(group_balance_mask(sg), mask);
-	else
+		sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
+		sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
+		sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
+	} else {
 		WARN_ON_ONCE(!cpumask_equal(group_balance_mask(sg), mask));
+	}
 
-	/*
-	 * Initialize sgc->capacity such that even if we mess up the
-	 * domains and no possible iteration will get us here, we won't
-	 * die on a /0 trap.
-	 */
-	sg_span = sched_group_span(sg);
-	sg->sgc->capacity = SCHED_CAPACITY_SCALE * cpumask_weight(sg_span);
-	sg->sgc->min_capacity = SCHED_CAPACITY_SCALE;
-	sg->sgc->max_capacity = SCHED_CAPACITY_SCALE;
+	return 0;
 }
 
 static struct sched_domain *
@@ -1387,7 +1404,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 		sg_span = sched_group_span(sg);
 		cpumask_or(covered, covered, sg_span);
 
-		init_overlap_sched_group(sibling, sg);
+		if (init_overlap_sched_group(sibling, sg)) {
+			kfree(sg);
+			goto fail;
+		}
 
 		if (!first)
 			first = sg;
@@ -1489,6 +1509,25 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
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
@@ -1544,6 +1583,8 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = get_group(i, sdd);
+		if (!sg)
+			return -ENOMEM;
 
 		cpumask_or(covered, covered, sched_group_span(sg));
 
@@ -1577,27 +1618,40 @@ static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
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
@@ -1871,7 +1925,8 @@ static void claim_allocations(int cpu, struct s_data *d)
 {
 	struct sched_domain *sd;
 
-	if (atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
+	if (*per_cpu_ptr(d->sds, cpu) &&
+	    atomic_read(&(*per_cpu_ptr(d->sds, cpu))->ref))
 		*per_cpu_ptr(d->sds, cpu) = NULL;
 
 	for (sd = *per_cpu_ptr(d->sd, cpu); sd; sd = sd->parent) {
@@ -1880,10 +1935,12 @@ static void claim_allocations(int cpu, struct s_data *d)
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
@@ -2678,8 +2735,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
-			struct sched_group *sg;
-			struct sched_group_capacity *sgc;
 
 			sd = kzalloc_node(sizeof(struct sched_domain) + cpumask_size(),
 					GFP_KERNEL, cpu_to_node(j));
@@ -2687,24 +2742,6 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
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
 
@@ -2745,23 +2782,10 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
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
 
@@ -2932,7 +2956,7 @@ static void adjust_numa_imbalance(struct sched_domain *sd_llc)
 	}
 }
 
-static void
+static int
 init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 {
 	struct sched_domain_shared *sds = NULL;
@@ -2954,6 +2978,13 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
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
@@ -2978,6 +3009,8 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
 	 */
 	atomic_set(&sd->shared->nr_busy_cpus, sd->span_weight);
 	atomic_inc(&sd->shared->ref);
+
+	return 0;
 }
 
 /*
@@ -2993,25 +3026,24 @@ init_sched_domain_shared(struct s_data *d, struct sched_domain *sd, int flags)
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
@@ -3157,15 +3189,16 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
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
2.56.0.385.gd3acb90ef8-goog


