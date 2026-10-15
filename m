Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D552CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3DF6B009B; Thu, 15 Oct 2026 11:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5AE6B009D; Thu, 15 Oct 2026 11:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C946B009E; Thu, 15 Oct 2026 11:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45B686B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C588214019F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:48 +0000 (UTC)
X-FDA: 85325255736.23.D20881C
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0989380007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQSAS1hL;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cy8uFrZ7NgoiMHkU62i+b+5hnlENX1fPhNJngUB5VQ4=;
	b=C2TbqZHpMKOIIqzdVhHJHn9M9Kva/Hk1luNEahtCvRuUzsV4O/sUsWjA/yVVzQtj5XcxdQ
	EwvnpjT7298x7Uj0Jq5XljDX4+qEIz/TK0f+gbbdjW4juHA76hnJdkV7YyrgZ3AIL6f4Sh
	YxJXftsxIDdvAbdtVivjFqNPBsGjLS4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WQSAS1hL;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078427;
	b=FH/joVGPh+D/37eoKilrhvVMLV/BPeu/mTlmSVHKAhanOEIa77G4OaG6FDqwmvtCITsJt5
	0ir0XXHV/rQoFpppJr9e602LiNGWN2ZKykUspWX1OkyS84uT2aC2i5hEkWx/1H0/N7EilT
	Ekuj3piaqxMCltISY2knFCfYB/o1xRk=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7a6e560f580so1072729137.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078426; x=1792683226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Cy8uFrZ7NgoiMHkU62i+b+5hnlENX1fPhNJngUB5VQ4=;
        b=WQSAS1hLrPNpzPM0K6uvTMc2uiwKFF1jXFcTBc9qGs/M08Xs8crntyrp94FzffnMe2
         WENLK1HHFBtJJVhoXyvEOZbP/ipgdVNuePDYdZno33moAb2a6kL6l5SaRD9AlYksQC0Z
         IGsmQyqeqwk+ctfUl/GmrmWu7oZgH0ss3hfUczPhPRIUjOaCu3aPt86lClA79R7LUl0U
         xzUDLjmpObe6B+grDDrj6itJMq/CwfmCzOmMPNxC8f40wz3SvRT/9Un0IxKJtFmJre2/
         F8+x4EN6JGYJazL21+nK6HDzys2BuhrgQIvuBycQB73FasA7pgBAUiY4RR4VLi96Lsaq
         ft3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078426; x=1792683226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Cy8uFrZ7NgoiMHkU62i+b+5hnlENX1fPhNJngUB5VQ4=;
        b=Ao9l7XK0Y1SpKM6tQx+G+/CN2qS9qbz6AuB4va/sTOxUszCUuDjITDhtVXUnk6ntsD
         n/7GwIWPrKfaFRvyP3HjVMt/ec+BmD4Ccrc0DAwez2Ga9aM+BO7QNdCUVfUGfRPZUarX
         1LqUupYalpKTEz3jZXwnpp23OC/prX04gHCVIUcpO2BWMrBg3O6H09zhQKKMPRe1gnJ7
         Dkw1AJwf2UXGjM/m7EFDtqoeSJvit+lnjCXpc63od7ir/tRvBONbjuCxQRqaQ9s2rhmb
         Asn8Hqh1jjzHB3SdcO/0CMvxNytACoNZGmER1RANQDXfwr6IweBrFjQjN6X9SxZw5JQX
         h6Kw==
X-Forwarded-Encrypted: i=1; AKwUvBzaQWcjkYGiArwQalHSN69M/pCkpcdK/H+HHWMT6go7bbICa7XxscYtj+VgM8yLCaaBeR2twMz58w==@kvack.org
X-Gm-Message-State: AFq9FYLlrWrNpr5oto2+PtXkW5Ybb8WZb9miIfA4yoQ7cCE1P3weZDVL
	JoZ6N4zzWateBeTist0qAqS0+k2Kq1bZPeVkJ2x9EtFNrY+CPGVmXCU1GTOpAWd/Fvs=
X-Gm-Gg: AYBFou1eyqvXSjsRTJ/S+1FqeeZDl9orFbfaoZMrGvUe34yuWunwsy6epPS8Kd8ENY5
	gCutAy3grIzEuu7MHDW4Ov2a7AZKlai0M6+UyuFjfKykk07qbvwC6Rs5ixibZ61qKpBdJ5ZkpoJ
	1RkXWJ17Yf4QAWW4yGHwFwW+6hxevy8DXCSM+SSGiBsMbiIccLvr+YcBvAJfxz1REjr8wa5J+nX
	NR5dKg4h85TinFpkUOx7eEuX7kYYpMqB3RBOd30q3IAk3RLPG+P7Q1S44JKIT9cBg+Q32Bt9WKv
	6x1WvZIEbfHrt6HujA90kLWpHqrM9ffS0bqbAr+AWALpcoh7Tzn67H+nBFUv4SgfPfrPOiSDVSf
	OA2+BhZO02diT2qT6QKUQqJpN9Vn6VXbgVuq4LCZKMqM0z4Pb8wOgYp61gzHXEHVndOU/HyWDu+
	dVzeF6Q8KQ7B+sFtEauk2e/z4o6DDgeJXZ5230ZwzeuoYEJSEj/Hm9ESsW1GyrOUZaoxx4nV4W6
	7MFEQxOx5Q9kPZYEcH0jnWqnPUAwgHbn5BSrfjKT6r1mrdZ1j8N0SpDGuwJ7VnwWoA0bspzFKte
	jx/dnBGMZZ5e3rR91jo=
X-Received: by 2002:a05:6102:4186:b0:7c3:c0b9:9028 with SMTP id ada2fe7eead31-7cb373134dcmr6256034137.24.1792078425962;
        Thu, 15 Oct 2026 08:33:45 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:45 -0700 (PDT)
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
Subject: [PATCH v1 7/8] sched/topology: Avoid redundant percpu allocations and bitmap walks in build_sched_domains()
Date: Thu, 15 Oct 2026 11:33:30 -0400
Message-ID: <20261015153331.1872641-8-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0989380007
X-Rspam-User: 
X-Stat-Signature: qtznhnj9atctbghxoxmjsfr3q3s5wprc
X-HE-Tag: 1792078426-831092
X-HE-Meta: U2FsdGVkX1+j00prnp6O6iuTmqjgdOl8VRfuzQKP7qOCwY4/SpHZLuwUkuEP+g6f7jYRFn/KQlDAaVf1xLIbz3tAIjS2usiyyyydyvDjt66Lruscg9IclaQYqgHLVxW0kgWrx0nXS30Fpk5wR7isENwK+J8SAymaYCb618A5OMfn2vBWHutxReOoRrswye1+XHZ4LOlQcO6ngOy9ILQzzDYXg1Mqsx1zspBTQ/rm/KrU46ckwwxjAtv4nQYIRRq1s3FBGj8od9FgexpvJWn7f/Mqw/0qT73+qi7JGkIE5bvcfFD1gSK8MCvFf5PGtVZePyT8OiGCQn4aaPxNPT8NG4Tc5SaXtCchWgQt83y8QpPTsteCnKrTxSltFCmAlB4FDqPQrZV/ZZ3leHVi5ObwR/mmzcoT04YtYZAL1A2w0NORAdafCmECMMUeRiwcljWvFUDkr9uvc8hJ633bjTEIRONdYBdAnmlBQoqaDXLckT1TYoacWnmsSLVAeXevi9oOJMYuwaUOeFcdELu76qqxXj40yCPFplsOBvt3+/UMG4nYtK0OA01OhdJy817ZmenFYH3RnJxN91nes2Bd27K46qBjpLuiFSEgmewxhQeNyBp9Hz69jSJOEi+mFj1utP3iQaJVTVTQCAVI3JJ3qFY6AW3HRg5j1LGXXHgGNFIV6gnAg6JHErw4QDLruPL7nV9B2EwcDHDXOgq0BUBi+uHQtwEdDW/QCo2SmOsuh4fXvzdkNmDDPpSBSF8w5lZbxE5FpCRIiH3Y67ote/njPB9UgpcRU6UgP/ZVRiVd59TsahUj7gSDWDLUAZI0rWamAp/HFUNH9mAOtNcZBYkIxGvVEi5XR6ctn+2tOV24uHuL9QWkIkcxvv/TbDYK0b0UDWZajDc1/HKN3ohahZUFXF/h2uQWHmeOoTnK52D7XdXCURYTn5BlU5LaVKSkYUnAgJiWk22BhdS7Uo3aY+BHOeT
 qrEsJYbz
 5Fz/ONLGo/jm3CBMjtGFUJhJqbgZhDXAvvJ5GX3JXEeTMMyHjZijYiR012ToAzT++1F2AGq5DxHCCQvK9IJkf8eeJAqtcsXIJOpFgICdwttGvYgnV1jEa8XgrxDo/YcigozohjHYSXBgDKMvahCUeumCenKuYCg+Nogiq5D9cox4WjEqDtJ5mB+jrQHRZ+2PJnm/RyoGXa/xMxwlVEMsV5INTaIVEGzpzcM2Urwyw2FCxUG2YCwGvBX4/5TYPr0EANuLd4qoltqRbBaqnJX16Odn+pfLrvVMNnFDFvCm7lhr5ULGSVUqFcXVOKtoGJv/qjtEIlaU+MFDz8SJck3Wq7OIMNk5nry74xsBt64zpsirs6/fGLJdNr4Ob4xxL5OQC8ndF
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
   per-CPU pointer arrays across domain rebuilds under
   sched_domains_mutex, clearing entries in __free_domain_allocs() and
   only freeing the topology-level arrays when sched_domain_topology is
   replaced in sched_init_numa() / sched_reset_numa().

3. sd_init() already computes sd_weight = cpumask_weight(sd_span), so
   initialize sd->span_weight directly in sd_init() and reuse
   child->span_weight in get_group() instead of recomputing
   cpumask_weight() across all domains and groups.

4. Reuse the first LLC sibling's computed llc_bytes in alloc_sd_llc()
   and hoist get_effective_llc_bytes() out of the sibling loop in
   sched_update_llc_bytes().

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
 kernel/sched/topology.c | 147 ++++++++++++++++++++++++++--------------
 1 file changed, 98 insertions(+), 49 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index fe7ecee041f5b..a9122dbff379d 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -903,9 +903,15 @@ static bool alloc_sd_llc(const struct cpumask *cpu_map,
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
@@ -986,6 +992,7 @@ void sched_cache_active_set(void)
 void sched_update_llc_bytes(unsigned int cpu)
 {
 	struct sched_domain *sd, *sdp;
+	unsigned long llc_bytes;
 	unsigned int i;
 
 	sched_domains_mutex_lock();
@@ -1002,10 +1009,11 @@ void sched_update_llc_bytes(unsigned int cpu)
 	 * sibling on each online event corrects this once the full
 	 * shared_cpu_map is known.
 	 */
+	llc_bytes = get_effective_llc_bytes(cpu, sdp);
 	for_each_cpu(i, sched_domain_span(sdp)) {
 		sd = rcu_dereference_sched_domain(cpu_rq(i)->sd);
 		if (sd)
-			sd->llc_bytes = get_effective_llc_bytes(i, sdp);
+			sd->llc_bytes = llc_bytes;
 	}
 
 unlock:
@@ -1321,19 +1329,18 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
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
@@ -1346,8 +1353,10 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
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
@@ -1389,7 +1398,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			goto fail;
 
 		sg_span = sched_group_span(sg);
-		cpumask_or(covered, covered, sg_span);
+		cpumask_andnot(uncovered, uncovered, sg_span);
 
 		if (init_overlap_sched_group(sibling, sg)) {
 			kfree(sg);
@@ -1530,12 +1539,13 @@ static struct sched_group *get_group(int cpu, struct sd_data *sdd)
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
 
@@ -1555,25 +1565,24 @@ build_sched_groups(struct sched_domain *sd, int cpu)
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
@@ -1862,16 +1871,21 @@ static int __sdt_alloc(const struct cpumask *cpu_map);
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
@@ -1893,9 +1907,12 @@ __visit_domain_allocation_hell(struct s_data *d, const struct cpumask *cpu_map)
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
@@ -2019,6 +2036,7 @@ sd_init(struct sched_domain_topology_level *tl,
 
 		.last_balance		= jiffies,
 		.balance_interval	= sd_weight,
+		.span_weight		= sd_weight,
 
 		/* 50% success rate */
 		.newidle_call		= 512,
@@ -2159,6 +2177,22 @@ void __init set_sched_topology(struct sched_domain_topology_level *tl)
 }
 
 #ifdef CONFIG_NUMA
+static void __sdt_free_percpu(void)
+{
+	struct sched_domain_topology_level *tl;
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
@@ -2449,6 +2483,7 @@ void sched_init_numa(int offline_node)
 	/*
 	 * Copy the default topology bits..
 	 */
+	__sdt_free_percpu();
 	for (i = 0; sched_domain_topology[i].mask; i++)
 		tl[i] = sched_domain_topology[i];
 
@@ -2507,6 +2542,7 @@ static void sched_reset_numa(void)
 		kfree(masks);
 	}
 	if (sched_domain_topology_saved) {
+		__sdt_free_percpu();
 		kfree(sched_domain_topology);
 		sched_domain_topology = sched_domain_topology_saved;
 		sched_domain_topology_saved = NULL;
@@ -2708,17 +2744,23 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
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
 
 		for_each_cpu(j, cpu_map) {
 			struct sched_domain *sd;
@@ -2748,30 +2790,36 @@ static void __sdt_free(const struct cpumask *cpu_map)
 
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
+	if (!sched_domains_sds) {
+		sched_domains_sds = alloc_percpu(struct sched_domain_shared *);
+		if (!sched_domains_sds)
+			return -ENOMEM;
+	}
+	d->sds = sched_domains_sds;
 
 	return 0;
 }
@@ -2783,10 +2831,11 @@ static void __sds_free(struct s_data *d, const struct cpumask *cpu_map)
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
 
@@ -2810,6 +2859,7 @@ static struct sched_domain *build_sched_domain(struct sched_domain_topology_leve
 			cpumask_or(sched_domain_span(sd),
 				   sched_domain_span(sd),
 				   sched_domain_span(child));
+			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 		}
 
 	}
@@ -3160,7 +3210,6 @@ build_sched_domains(const struct cpumask *cpu_map, struct sched_domain_attr *att
 	/* Build the groups for the domains */
 	for_each_cpu(i, cpu_map) {
 		for (sd = *per_cpu_ptr(d.sd, i); sd; sd = sd->parent) {
-			sd->span_weight = cpumask_weight(sched_domain_span(sd));
 			if (sd->flags & SD_NUMA) {
 				if (build_overlap_sched_groups(sd, i))
 					goto error;
-- 
2.56.0.385.gd3acb90ef8-goog


