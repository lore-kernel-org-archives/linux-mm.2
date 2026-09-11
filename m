Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E953FC88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3E3D6B0096; Thu, 10 Sep 2026 20:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16056B0098; Thu, 10 Sep 2026 20:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD656B0099; Thu, 10 Sep 2026 20:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3246B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:18:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE0361A06AE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:42 +0000 (UTC)
X-FDA: 85199570484.24.1BD6782
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F4181A0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=utRR8lJQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sdb+na/h6ecDzLaWx78ptxSH3vM79ZXkyzQFAMwq7RI=;
	b=xMLLyF6tZ3fTTHsqsefHYI4nI0nPqe3j41xv4eJGD57+PZAgshpbLyt7PABDu1p2rs2DP7
	0xVQwZA8X25Zx5bS83ap7rwEm1gPhozmCPd6V/JUyYAlCp+3R9jO1iqk/Gg3s7WdIE16hM
	+msvsM6oZb60sJMLOx7kQ9AKUSQbIww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085921;
	b=kEJJvaisIkWxRKF/OdNgcbcOqzvwvKedXTcbiYa7ve/5wkGqBfxn4S3obhg+q6TXzVx8Jx
	04J3++a4vBlfSoFD8m9i9CIZnQmHaamat3E+CTYXOBsw3zxWYkKa+8LHCPMZYXNKqNGoXB
	7S9avF8VhhWkhZ3KDUqgLccy2pHVFVk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=utRR8lJQ;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-939c8c6b114so26357385a.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789085920; x=1789690720; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sdb+na/h6ecDzLaWx78ptxSH3vM79ZXkyzQFAMwq7RI=;
        b=utRR8lJQXQF5P3hpW2Ab6ZA74PbNOVubWXwEfQBEFUZS3blpFF8C7Q06x5nTCX+scH
         kL2sKGw/ujfNNyFJvW0yfnA50BTSospf295LU45c+2WFVeis1vfVA+s3G3MfvdkmUmvU
         cetpJ21mUWbeWMgpE8LA0Gadjp7zlmpsisrLL1Lg1sBU6uTVi51PRgPv7N78nntcIqL9
         7Tc/fD+6qm+VcJq5Po5jo6vi0OaHinxXB9+OBOOkFCS81bjpEA7ux4QNAXIQ6IpBam7X
         ADMtCwNIKbbmfMxJs/mH43MqegwiKr2ME0vvmdufUixgngI/I7/3E2kYxIODSO7FY3OV
         WvwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085920; x=1789690720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sdb+na/h6ecDzLaWx78ptxSH3vM79ZXkyzQFAMwq7RI=;
        b=IFaXHd+Lt6qVuxq/1tmQr4z6YdPtkc1kHF8ji0pbyd5/+Ya8BrEv+00Ma4IbDUG/O4
         wWYxsxeIUVRWSswaZ27CSFuw6EFU4IEFFuGZLsvBpyJpVOmIsjvzRNdmzVFH/DRbPDS6
         MzgpREYbyrGw+AhGXqn0vxgFDsMq9YotUUKnmgBt4NtTvb6afEwk9qPMRIPe5IiUd3Yr
         ebBD9vT3CGPaRE5g0uFZ7koUly5dxQxSPLqidpcB3EpycKLr0khdoiY8oMb4v0dpGlzT
         YXn8OldzYuAxPjfFgXKNG8roOaqOJ0LqlOQvxnm8tmFr9HNvhCUOL/fSbgO9F062ytTd
         vs1w==
X-Gm-Message-State: AFuF++kArgowpYSf3T0vKkDqgUhhqtmnWf3mxMC7eTHQ3LAcyLgr5AqM
	Gm7GmhGjPWPlgUwxGfuCTvq36G3nRO0zmPshsneSqpeYQPojnd22SsAojSUOh/IxRO5zV2KWk6z
	Pyp9H
X-Gm-Gg: AYBFou0eGcKwqQSwLZ+Lnt6bPoxwufPtnEe7QNKkAY4BPE5r8V9nhmbedz7fwAF7BhH
	kEEO7ykOjyvZIhZtUuUM1iwEKqEuSn9uCgxqkSf8+WYdlyAaDORfMxpeOpAykHHk8vuARKry3oS
	tMgyknSASdgNolDByjYKuOpAJBTXrwZZNv6kXVo3Y4Z5KHv5dx5HDrXw/8VDF8M3UF/gcxP2zd1
	M68aMbK7wSLHFrysaia5FKkXaEq3RYmPBxZGGiknQYxePubyAsSw9APqKdkCDx2REzr5m7e1pX+
	UvUAJuVA9FmqXHuGZLLjfO9e/HbsVS7OhX7r5S99sNmo0fDRxXUU+zkCtwPbReSLaiVuTp61SAy
	/K9vrwHzmR4Xq+8cA76LuGx71nBP2mIc1rr47i7V2IrYNkbZDjnzs9ywA309VQTbIIomEbcrn/W
	Q1npJu0nq5q0dgkj00Ac16oUvQ9VheAagduLeAoOAUDBEPXQJJoI8JFAAsmo2auN/ivVGSvo4qN
	gt9v5j+Skldev/a3pr8tYvmoKBzuP75OXLo67LNNoBOLWq23hkBxGG17Fec
X-Received: by 2002:a05:620a:270c:b0:939:a3a0:9a70 with SMTP id af79cd13be357-939ea0a39e2mr191963485a.18.1789085920053;
        Thu, 10 Sep 2026 17:18:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80e4c36sm108896485a.40.2026.09.10.17.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:18:39 -0700 (PDT)
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
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	osalvador@suse.de,
	hannes@cmpxchg.org,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] sched/numa: do not let VMA PID activity gate promotion
Date: Thu, 10 Sep 2026 20:18:26 -0400
Message-ID: <20260911001826.2109390-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F4181A0006
X-Stat-Signature: mby3fqjyr9t5y1nqfhyqnxbhr99g99y3
X-HE-Tag: 1789085920-165601
X-HE-Meta: U2FsdGVkX1/bYH08aZHMshbT50FgIewDvsnEPeB7xL70N/db4XJE4ZVzynq38RfChydm6JhsEL0uXdtOroqxHj1gpgEPMhs31FgEgklYdSuLDSc8OPOrlXNbsOugjjb77vwlM8r1FdNhQu2oBPQbZrqAFOCtlF1r5nkDljnA/cOJ6cg6YSwbkXDAdXsEtEQR1XuHdga3ksRZ64DVxqb1u4Gjj+7uXlK0UGLZSKRHFmp0lHVyvxWNUsKLcF+0+kOIfx1wTcrB59jcPMxF8baFqVc/3/qaD3HCz8Vh4qy1934bjkdbkuBWBjsQutpxzVAvIpOb/p0VJ3ZdPkcNUGrVGq/xRGbplDjxrd3/K5ayMBEK32mmvBaU2A05+uCo46yKhZGAQJm7VYDf5voTA+IkJP/0mJvR7l8YLCuPud7XfgSiD6KbeBGg655YF4A6cfHIojkOQ29JDmYzBI95hFpQDzCelzMHvXdCh0EqDkNwurrEk4IPLmQwU7OTrsPGEi2CRxqJyVTNUr5fpJqmFz6C2iYY0tOWtS4OmDVatGtzcoB594iBOS01eoxAlGyIdbARNgw3nk66BQsS26f183NYXyLmsePr+d5/DSJcmwYjfJgYpqIMO7oVxYZNVpCU0m8UptUceO4QMU8k/l8mwsdKGWg36o0ivPL25k8nOwdDYq5lcEPapI5pZidA18w4H9PWKB1FIODEkAwfJ/jcnpG6dDYzrvnr7aJ2HPb0SCUh4wc6G2LZ0fKytDs9HHs/zeJOLPWCugNSQMbUBaDrP2F9HxEWtXLbWHDhFlKy8keiJSpGTzIiuPcZVwCfoXlOeBw4q8NSHV0Pyt862aETmBp85t1cUE0LVCmBvw/Omx9rnGDjQDB0D+FpzmIOYddiGBlsZoeD7XgzuTe2E30QM9y7Kl2phLHULbye3DPTG1OC9bJKND30ycBkMvhyvgMnUBv8pmsgclF4h/DAhClH5lf
 T6x1G5dJ
 uJplkLNg+IxysTXXmF1wQXowlQFjYV1XPJzSUk46NEGiEoY0XAZjnUVjN43VWC4GUZq6kzZ7s1XDOw6pqmFOO165q89wUmti/omzX2F5bkVQcXq+Fz29/1ENmyJo8diO78iGh5DfBk2a7P+rCDkq6HnE93ZjSlwKOxHUxT27h7QhtVKmtGmba96fEoiTeuHbnFBYkIYaRJ/gN7Cw2uAc3lXuYpD+Af6KrNrubLwbQHDPVjfhECIeeZ99rWnqgyOZm+YuQ4jY7pvztZWkT5k9Am55Uf2Ti/XUeF4Bc4jnWreAfzT3zRNJo6r/ANBu5R/waLcjwafiX3iaJ2akZXnU4+6d1aD6M0rcbHSHnegEm6vWSYEH7Na/Dv4chAyUmvQd8eAPaaT7eO7BzFy/ZLfx8WjQnSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
skips VMAs without recent PID activity. Since only NUMA hint faults record
that activity, the filter can suppress the fault needed to promote hot
slow-tier memory.

In tiering mode, scan PID-inactive VMAs using promotion-only scans.
Reevaluate this choice whenever the scanner visits a VMA and pass it with
each protection walk.

Record socket-placement scans in prev_placement_scan_seq. Promotion-only
scans still update prev_scan_seq, but no longer postpone the starvation
fallback for placement scans.

On a host with 768 GB of DRAM and 256 GB of CXL memory running two roughly
430 GB database workloads, a large shmem VMA occupied each scan while 2,537
other VMAs covering 84 GB were skipped as inactive. A hot 20 GB hash table
remained entirely on CXL before this change and was split evenly between
DRAM and CXL afterwards.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  7 ++++++
 kernel/sched/fair.c      | 48 ++++++++++++++++++++++++++--------------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5413bd10fff2..9f042d6ad465 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -803,6 +803,13 @@ struct vma_numab_state {
 	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
 	 */
 	int prev_scan_seq;
+
+	/*
+	 * MM scan sequence ID when the VMA was last scanned for placement.
+	 * The starvation horizon in vma_is_accessed() counts against this, so
+	 * promotion-only scans cannot postpone placement indefinitely.
+	 */
+	int prev_placement_scan_seq;
 };
 
 #ifdef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e636e8de53f1..6d1da13a2ef5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4085,6 +4085,10 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
+/*
+ * Decide whether this VMA should be sampled for NUMA placement.  In addition
+ * to recent accesses, periodically allow a scan to avoid starvation.
+ */
 static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long pids;
@@ -4101,22 +4105,13 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 	if (test_bit(hash_32(current->pid, ilog2(BITS_PER_LONG)), &pids))
 		return true;
 
-	/*
-	 * Complete a scan that has already started regardless of PID access, or
-	 * some VMAs may never be scanned in multi-threaded applications:
-	 */
-	if (mm->numa_scan_offset > vma->vm_start) {
-		trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
-		return true;
-	}
-
 	/*
 	 * This vma has not been accessed for a while, and if the number
 	 * the threads in the same process is low, which means no other
 	 * threads can help scan this vma, force a vma scan.
 	 */
 	if (READ_ONCE(mm->numa_scan_seq) >
-	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
 		return true;
 
 	return false;
@@ -4142,7 +4137,7 @@ static void task_numa_work(struct callback_head *work)
 	unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
-	bool promo_only;
+	bool accessed, scan_started, promo_only;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -4278,6 +4273,7 @@ static void task_numa_work(struct callback_head *work)
 			 * first scan:
 			 */
 			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			 vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
 		}
 
 		/*
@@ -4307,17 +4303,30 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/*
-		 * Do not scan the VMA if task has not accessed it, unless no other
-		 * VMA candidate exists.
+		 * The PID filter must not gate promotion.  Scan PID-inactive
+		 * VMAs in tiering mode using promotion-only scans.
 		 */
-		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
+		accessed = vma_is_accessed(mm, vma);
+		scan_started = mm->numa_scan_offset > vma->vm_start;
+
+		if (!vma_pids_forced && !accessed && !scan_started &&
+		    !(numab_mode & NUMA_BALANCING_MEMORY_TIERING)) {
 			vma_pids_skipped = true;
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
 			continue;
 		}
+		if (!vma_pids_forced && !accessed &&
+		    !(numab_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+		    scan_started)
+			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
 
+		/*
+		 * In combined mode, only VMAs the task uses need placement
+		 * samples. Without tiering, every VMA reaching here does.
+		 */
 		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL) ||
-			     vma_is_ro_file(vma);
+			     ((numab_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+			      !accessed) || vma_is_ro_file(vma);
 
 		do {
 			start = max(start, vma->vm_start);
@@ -4345,8 +4354,15 @@ static void task_numa_work(struct callback_head *work)
 			cond_resched();
 		} while (end != vma->vm_end);
 
-		/* VMA scan is complete, do not scan until next sequence. */
+		/*
+		 * VMA scan is complete, do not scan until next sequence.  A
+		 * promotion-only scan reached the end of the VMA but did not
+		 * sample placement, so it does not count towards the starvation
+		 * horizon in vma_is_accessed().
+		 */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		if (!promo_only)
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
 
 		/*
 		 * Only force scan within one VMA at a time, to limit the
-- 
2.55.0


