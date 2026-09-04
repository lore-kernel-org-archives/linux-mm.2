Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4792AC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C6F6B008A; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BCFA6B008C; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D2066B0092; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16A256B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26E291A0194
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:21 +0000 (UTC)
X-FDA: 85176894642.30.17CBF6B
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 448F940007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jwjioHs/";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788546019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p8Z4JBi3sjE2KlaCLrWKRkykHYLdYdycFQqiI4ckxMI=;
	b=C+xXsiP/E9v8d/GChucFI74xRFcbLU0tXCpEbnJXMkpFJmMn+IJr2W0Df1OubZmhZnCPtE
	2YcObEQ0lDNhG68HDL9uheraHFTG818fYZyRjRkcA+DLcXq1Iyr2tGkdhc9Qm1FDa19VCG
	Clzz3CFH5vomG1hFpq8Mc9MWWCcEY7M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788546019;
	b=xpI0qGRsesuLVBiKvAtDKvfb4VsfU4BiNDzkDEn3JAF9VsnpbrSCl93uy2531Uea34t/oi
	gP5luOziVkGXh+gszd3MSeZLCDPBGMdAHPpODw9AZq3mfgOypWm4BY+Ui5Kp2caicSFk0F
	e4QlXzTVYFOOc+W7MriOuZIeO5psGjI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="jwjioHs/";
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-9382fbb1208so120601985a.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 11:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788546018; x=1789150818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p8Z4JBi3sjE2KlaCLrWKRkykHYLdYdycFQqiI4ckxMI=;
        b=jwjioHs/B6z5TV6D+NCmYQZ9tHWoj2jzfLfz1cpeXEm9JJAevNY6W6TnWSYYcSDumr
         cVUUd1CgfPBFu5063ljazPNCfA5QbC2r0P0laOH3yfYIGrS0U7NFIYpcAZTL3YzOvCGa
         QWyrX894QpLT6EYwT27cw3YyzD0Tx6br4cYQpHZR2uNUknytv5/FX1VrIzgUoC730Gle
         w5/d7uPm4gPDozygea1aQRWusTQwQjQefeZ9zFFM+J7unS62EZoSva4mYdrLYfYBdpJC
         QjrPxVFUo5OZdi1GCKeqGnHvCa+Eh3TSTtyhIcJDqLIWN9BFAp9j0+gLrkq5dBAMKRsV
         fijQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546018; x=1789150818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p8Z4JBi3sjE2KlaCLrWKRkykHYLdYdycFQqiI4ckxMI=;
        b=G8CgsuLcBRFVeqh1RTIpdmbSi7kkvk9qIibv0Z+1BNwydvHCFSzaGsyt44kJScalgQ
         SKFE6l486XBT3Jp2SKyLKsgM4GUtDQlnkv9n1ohQRy6ASrybKcit6rEZgAIs4Uhcp69I
         vLSnphpo3wawHu6Wzmvk317lp9r0qonTv9ZcsHkBAWr9X6iW9ESa9GtPGD46ocNNAAlx
         v6W4I2YOLcYcAGL4EzpT/W5zzP2wcRRMKMltSfNGBKN7/toIuIpo5rcOkB+Otwk0R27m
         JVuHcDQH3t3o/wUvEZ8rUMMCKFSQVPG56Z4YeOXfiQTEA2ty75WTuKqu0zhsevdDiLwA
         RyXQ==
X-Gm-Message-State: AFuF++nbjQbybAcrzDJBiiImjHCgwcMVmVm8MM4O4fi67iysyjMU1X1M
	ntt34t73ZaxfBwuLlShQYjR7bFT+LalQSX/WrniFujXzR5byLBjZAgGTstdm4Wl5kMX/x9vDOfr
	Jyeur
X-Gm-Gg: AYBFou1kA5pPxw8IXMfrfQp1gGWjgA2vqa/1wpL6RzVqvkXqMjcgRmJ1EVWk/Wg6dRB
	uKgf5d9wvA2wzcCtVsxItqmj9iVF635v/1wHlYbEMZA2U1sDGeN6gj9HmPknijXm32t839TGMFh
	g6hQ8naDuF1Ch45yw2IhQF6OncIoxFqkqCcNiOmghOTrO1m7+0c9OL5EZcLiCp6bxrfXOtsM6La
	REQVtKq+kmC++fIhbgrcfxig+726rqBE7aAJwy6pDLhJ6rbd+8GQ77Ml7oeARWXmUXPXyguYvZr
	r7xmZICZsBmjLV79oMIoIXTKMHaq3B++8kQHU7U8EWk7gCLbyrvE9SkpKl5i3SerU4KP+o6j6VM
	yHm2SFfxsZNAuu/9+JaudJ96vG6h2ccaCm0BOSVqIEaCeNYWOodhKVqk1wj2f4j8Ssy3E4p4HKd
	W3POfr9rm0Fl7PlE5cMZuSZ4sroJIhJOagYbuitcTZORwCqIpUQu00YcYJ2PAij2pVjdmaHWp+v
	vENRyljNscA4twi5veIh/aSA47bYx2Cfrx3i/p9AaVYrgjA3Q==
X-Received: by 2002:a05:620a:2715:b0:939:8a03:f7e3 with SMTP id af79cd13be357-9398a03ff25mr362976385a.6.1788546018205;
        Fri, 04 Sep 2026 11:20:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93982db6a95sm207374585a.9.2026.09.04.11.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:20:17 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	raghavendra.kt@amd.com,
	shy828301@gmail.com,
	baolin.wang@linux.alibaba.com,
	osalvador@suse.de
Subject: [PATCH 1/2] sched/numa: do not let the per-VMA PID filter gate promotion
Date: Fri,  4 Sep 2026 14:20:05 -0400
Message-ID: <20260904182006.1562449-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904182006.1562449-1-gourry@gourry.net>
References: <20260904182006.1562449-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 448F940007
X-Stat-Signature: p16pjbnae5w9wiuzz4ih161gwifs7zyr
X-Rspam-User: 
X-HE-Tag: 1788546019-445215
X-HE-Meta: U2FsdGVkX19Z+HaiQBNA4Q3c/8C5r3j09Tu0PORkC6pWkfJQ3E9Zknc02zChoLMa3gfiLStZNKd5n4DZQALdSCMVLuoqsVHXB8ZAnb88fCW6IK5tVLfpNCKFqHsobtLu6trBXcxSz1Kioapu+Uvx0UMH+m2oxxwRCoxBZo740jDMLNdC5ZWOEVGMHHQ7W5wkj7wriU2uPtn2hnRuoeyhnZpcELRoHEK0AhrBe5EDVniyL6uCLn5yEljbczyoze0c431D3C0E50FEF81yyHOsd29KGPs7CceJp0Nq5B/VRBjCwziRmb/QGzC5LuJvisXQWCiNiCnj3id2dsuVodYpcK+9WHqr8vPbMpSq6eAgQ57+j/85mKVJ2e6crhBF5V3TmGTfJFpe9R+BvnO6L7yMUV0u/YCYSIkDjwkuM9Fk6WYFynS7aNBus6q7ZdV/2r9FZv52sbRWLQ46nHlIczfMKDMuxMMxxDEw/LyxDRauk+/L5JNAGqny0EnC7qX1T1jBo4kG32X/H/AgKjijJ+pjzv2TEmtFtF0IvLo6ayPxMccMpBORRqhE+FcAo+cww5agIbph6X5a4beHatddGfRIoFxfzeHuuPZgWU4bmqfhW/axLivaJLpUfV/dzGzSSUFDEXqxW06SePU9Ex6AoGJLx1t9myRuetGZaZ9/K1X0buwmPP9a0tbF+87Kg78O0wHYBbvtgzPS7hdp/fgUtdcGkKG2EeyPKX9dt5OlZAnojni5ncFE3QafE/C1nsGappobLFFt7InHg6HBX9sz5ybIlzFVbG4ZTTv2kQwE9bOVYqTGwxqRm078dXeYFo7/YYDi8ESyOkrWI8R6GX69dVuXcSDjCxjxvI5wGFWSOUqZ+oKzfSJUB6yXAahl5a4/3PHdDJiXbaXhBkHiWVzDc+5H2iRgf6eT6FimAmH4RLcSD8jKthgGHT97/fQDNrGbDi/y19IWJtN9j3CZWjFV7ye
 JLPVg0I5
 p2TZT8kgKZDG1Jz1S2esBgQv2t2P2fIFznOjr5S6S6lijIURaqa1vQa3V0UGbbc2yJAFYM7GE4BcNQw8Lm7OxjzM/WPMNPqnnklPOVUPXq52Lf/bJDWKhcx0ihn1ja5bpLgMocZ/m+Qqfe+GI9RGgNNRo3ra2iEgxhof/U/UM/4nH2KkZT8ks+cOnz66OIgnKdeGJ0HyjlSQ1dtFXh7+4Znyd/77g6kH7Mg1Su6JVephEfiqLX/HSX8vGI+0z7dlDjbbUTkaoF7Ge97sECxJIstgBCb+X40yqgmWRCCCmtMUs7C3Czikq066ieFY5/IATj6RZrG37CVY8CzLKSngXi3NPCqqkdXwsEhrrJugyfFULXPx2tCb56uwEwWFrMdpd3+/9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_numa_work() will not scan a VMA that vma_is_accessed() rejects:

  if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
      vma_pids_skipped = true;
      trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
      continue;
  }

vma_is_accessed() wants the scanning thread's hash bit in
vma->numab_state->pids_active[].  Those bits have one setter,
vma_set_access_pid_bit(), called on a NUMA hint fault.

The PROT_NONE scan is the only source of hint faults, so a VMA the
task has not hint-faulted looks untouched - preventing new scans
from causing faults for potentially hours or days.

The existing escape mechanisms do not solve this problem:

  numa_scan_offset      - rescues only the VMA holding the scan cursor

  get_nr_threads()      - the horizon from commit f22cde4371f3
                          ("sched/numa: Fix the vma scan starving issue")
                          costs nr_threads scan sequences, which
                          can be incredibly large.

  vma_pids_forced retry - fires only at the end of the VMA list, and then
                          scans exactly one VMA

Observed effect in the following environment:

  - 768G DRAM + 256G CXL Host
  - two ~430GB highly-threaded database workload
  - a single large (300GB+) shmem/tmpfs VMA in each workload
  - numa_balancing = 2   (default tuning)

In this environment, the large shmem VMAs held the cursor for 100% of a
scan, while 84G across 2537 other VMAs were skipped due to "inactivity".

Among them, a 20G hash table ended up 100% on CXL.  After this patch it
was consistently split 50:50 between DRAM and CXL.

Scan the rejected VMAs, looking only at folios on non-toptier nodes.
Promotion candidates then come from the whole address space, while toptier
folios are only marked where vma_is_accessed() already allowed it, so
top-tier marking is unchanged in every mode.

A restricted scan reaches the end of the VMA but may not completely scan
it, so it leaves prev_scan_seq alone.  Setting it there would permanently
disarm the get_nr_threads() horizon above.

Before this change:

  DRAM Bandwidth utilization dropped from 200GB/s to 150GB/s
  CXL Bandwidth utilization increased from 5GB/s to 45GB/s (capped)
  Request Latency increases from 800us to 5ms tracked with CXL bandwidth

After this change:

  DRAM Bandwidth maintains between 200GB/s and 250GB/s
  CXL Bandwidth maintains at ~7-10GB/s
  Request Latency hovers between 800us-2ms tracked with request load.

commit d230991493b5 ("mm: mempolicy: fix automatic numa balancing for shmem")
surfaced this issue when it fixed shmem numa balance scanning.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Assisted-by: Claude:claude-opus-5
---
 include/linux/mm_types.h |  7 +++++++
 kernel/sched/fair.c      | 25 ++++++++++++++++++++-----
 mm/mempolicy.c           |  9 +++++----
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..d986fcab9c8f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -803,6 +803,13 @@ struct vma_numab_state {
 	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
 	 */
 	int prev_scan_seq;
+
+	/*
+	 * Set by the scanner for the duration of a scan of this VMA when only
+	 * folios on non-toptier nodes should be made NUMA hintable, because
+	 * the scanning task has not accessed the VMA recently.
+	 */
+	bool slow_only;
 };
 
 #ifdef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6d881e530f89..990af0e45d69 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4297,11 +4297,20 @@ static void task_numa_work(struct callback_head *work)
 		/*
 		 * Do not scan the VMA if task has not accessed it, unless no other
 		 * VMA candidate exists.
+		 *
+		 * Force-scan only slow-tier folios when in tiering mode, as a large
+		 * VMA can cause others to become "permanently unaccessed" if a scan
+		 * cycle is consumed entirely by the large VMA.
 		 */
+		vma->numab_state->slow_only = false;
 		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
-			vma_pids_skipped = true;
-			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
-			continue;
+			if (!(sysctl_numa_balancing_mode &
+			      NUMA_BALANCING_MEMORY_TIERING)) {
+				vma_pids_skipped = true;
+				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
+				continue;
+			}
+			vma->numab_state->slow_only = true;
 		}
 
 		do {
@@ -4329,8 +4338,14 @@ static void task_numa_work(struct callback_head *work)
 			cond_resched();
 		} while (end != vma->vm_end);
 
-		/* VMA scan is complete, do not scan until next sequence. */
-		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		/*
+		 * VMA scan is complete, do not scan until next sequence.
+		 * A restricted scan reached the end of the VMA but may not
+		 * have completely scanned it - it must not disarm the sequence
+		 * counting horizon in vma_is_accessed() for this VMA.
+		 */
+		if (!vma->numab_state->slow_only)
+			vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
 
 		/*
 		 * Only force scan within one VMA at a time, to limit the
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ce10ce437464..e3fe08c4f109 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -887,11 +887,12 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 		return false;
 
 	/*
-	 * Skip scanning top tier node if normal numa
-	 * balancing is disabled
+	 * Skip scanning top tier node if normal numa balancing is disabled,
+	 * or if the scanner only wants promotion candidates out of this VMA.
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (node_is_toptier(nid) &&
+	    (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) ||
+	     (vma->numab_state && vma->numab_state->slow_only)))
 		return false;
 
 	if (folio_use_access_time(folio))
-- 
2.55.0


