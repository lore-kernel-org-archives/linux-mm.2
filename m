Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8075BC98307
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482A86B00A0; Tue, 22 Sep 2026 14:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4331C6B00A2; Tue, 22 Sep 2026 14:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F98E6B00A4; Tue, 22 Sep 2026 14:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 091106B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95CF21C290C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:43 +0000 (UTC)
X-FDA: 85242236646.16.DC4872A
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA8DA40008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hZEkQfve;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=axWZscC+v0nVIusaiMTv07a6IEIvhtM/ylITkcHKQpY=;
	b=KB43gkxfM+D9wBfxuvi5ns8knroW/7zEMY/unnPBKHBsB/NrRcPoJPvj4cJaPbezZ0iMyb
	r7MKrlMzs6Z/+4ce6myBczzZuInPz6U5uEdChAhDTJ3aM+Z+dzx+/9BmJ62vJtpBkKX4xd
	yWsILrcQ8LmFFotGxRdQ9kukJrcQF7Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hZEkQfve;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101781;
	b=oa4ifTGy3rmclPpUQdsnw46LH7FRpqdlM7YUJhLcxgVax3VYGbwCABFXC41RQyG8fyNVpl
	df4TVB0ywalq7hX8TLa8AYs3AmIF0Gtz32H45r/H7GcqGBhFAZuzVesBt8WgQf71NorFIu
	ZoK45AHpRpY1aJFLDQVZiDkyzmhdYMw=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c9ff1cso16717085a.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101781; x=1790706581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=axWZscC+v0nVIusaiMTv07a6IEIvhtM/ylITkcHKQpY=;
        b=hZEkQfvehmtbQe6vs1BHv9AnmUNUMjh7eUhbCnd72+XGvQMb8RZZyv5GLX4E7HWlAJ
         wcCJPyUS9lGmX/Opee4cvOzyIph3p5ZWGZhRqKqR7Z022/JPAIhNtbDDdmfw8OncnbLE
         dI8kn/TbPqLhXJHD9UFmSGHEnhLrTMIbVA540/zt43WANJNg49E9TEYz3ntjV2d6tiZ3
         P6xlqmL2J8X+R4FfKIQs6UUUL7iaUx0GW/ZXupSSP38a1caZNHL/gAdGimqFVH88vpyF
         lESYMItZutUSTO3ijRfM5rMOK+iVhNS3xirig7BpbOGGW1QOW5vVeNcs8fql25iZZK+M
         E7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101781; x=1790706581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=axWZscC+v0nVIusaiMTv07a6IEIvhtM/ylITkcHKQpY=;
        b=BYXgQsK+I75HlJzEGl4CuKrZGFTmvgqBA4drRl0AvYJmifu1I9T7NYI6JDDvCqj5cT
         QOXXl4QpNjiEytrjxezh/sEtclT1Y2YXYiizRMQpaTFzhPd9Tk4ukKkf5PpX2I2IJyNv
         F1t3fpmFF/roA3lB2AzfiUmzGBbovZExzjq/UIPSZShtuYu4s3kUSaFqSyN3Zv8lgm0V
         FI3RJrLPsUV4YPC0hIzgWXCEYcMJIvKv5tj4sQaX2SamaWWu0EG1MmNCResZy47OhTZB
         XieO/FIvqq3LvbIyISTwM3opzRCYQnvmVJhQolDLEmJybgU78T1wXnvCR8QYLRmKLM1M
         rkHQ==
X-Gm-Message-State: AFuF++nREP7OMd0xCv+MPe/fys7Rs2yOsq1SL6uFQFN4JaVw9jjfzne7
	zkiRxFOlnZP3ZYJ3XA6DAZHTTe6ZSxcvnxJj8Gc/V2XLEVcvL5eMCxj2Pm6Yi/O32LqJ5NuV4nO
	+Mjf4
X-Gm-Gg: AYBFou22e0m1T5L/7Py2iRafH80jlRAR9vOGP5Rnx5c3SXIYuBRy1VfjPs5xvS59YyQ
	FpsSifmj97Tan8qEGN0wI3wOqjEUYyIs/JjsnepXBWVNZ3/+euEzVjtiRJ5Ab1m/qOJFPvQ4+k7
	sfEXyinQ6JrzH33N4SdUzxJ0Fr6+jh7wyAcmTBTAWC2yv1s0rY5ht61Q8S3c6aH5GYJNPqjnn9m
	U+qVpuUQQE4DzM6qLpAomtn5cwBb4xEhN19mk0ayYcvZa5lMSOOUR11S9T5gWL8gKE10J9ikXEK
	Ea6tTzDwG9iGTzjz/hpwUHEZoP5cYwW3lD8/ZDge0rcd6yINQl7KYrQKVxmJYckCVnVYOy11HOQ
	yY88XPF2tkucHRCsNIklaZzBDAAxJKj+BIBbOvJ0KDfhqFCTQelmTHyIu0ocf1MTFT0xZhq/bRe
	QNG3JevEFzRkzsD6vZkvqOf5xNXgHNhPLd9gfJW9DgC69Pgrzc6cAruRait+T0MJ08WA1WfiIbZ
	7zCM7RkAFUOrgC/HgzCS5xbaS+DDkZhL4XL8dgRwIMRe8UTz68q6VuT6XvaJ0i6cKaaqmU=
X-Received: by 2002:a05:620a:1d02:b0:93b:d7a3:45de with SMTP id af79cd13be357-93c252538f6mr36699785a.71.1790101780908;
        Tue, 22 Sep 2026 11:29:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:40 -0700 (PDT)
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
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v3 5/7] sched/numa: scan PID-inactive VMAs for promotion
Date: Tue, 22 Sep 2026 14:29:26 -0400
Message-ID: <20260922182928.2199090-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BA8DA40008
X-Stat-Signature: 1xk16xszdpweikdksrap7m4gwsscshci
X-Rspam-User: 
X-HE-Tag: 1790101781-772202
X-HE-Meta: U2FsdGVkX1+cb/C8LET5DLzs49o3DpflW2V4UMw9uIdvadZf6dC/gEhRSFTvbd0+tthXQeUn5AN7uU7NAt/bgDqOAjDs7f5QWffQ3+Mp9bfMTTrlhCI7pI1Y3HQVySuMDlQIajoX2Oq6w3eUtI/tVhFHHUDkEhg6PPhuavrHPeztVG2FbMD+yMXlvASclY+i+trgGPRW2FzIFn21Vw+xuJssXopl0qUN8lxja7cX87PwMRTy6mBm1XLPPtp55gNIxBTGUHK1PJ6kdgKOZOq1tWBVplZbrwEPRdZCYnphzHSrVwzMFY57IoSDHLfxixM8QFkOO7XXWuYDbVwJ1v+U5ii5uZ11y2KrRl4erKNw/XssGJtZTTyXjriNpADaGInXFjnAOFsXIH2uypxcOjyYR3zsB8RLoiRVauaiDSv+XF6VvdzSjYjeU+rPOQsRsX5HQ7QNOGVVh06WwGWZj8xgQ5W7dRVnVladaZCY93FmY0xk3scd+XPIq1n2gWnYehmLKkJGIYI7/3NnrRb8uf7YaU7LN1rrMLU5fbAxjhh8O7GDwJwN+4ax89ycL1GqY2Pr4bfr3YtIrXfJFcFP+HM9uQzFJibbDti2GGa48p+8Qiz4o5vsAnkPRgJdTYJTM5zzeJ8o3ej+/wX48VmJWd8DnLwpCOirQnILS9JsGTQX1HPEUrMI4rir0v9CmL2xHPQs38GcwJVd6nqdaWTqjJRcXrmZCLlgIkK5IVFYHe9t8znBYwTg8xpgQMSRQizgsj1noq8LN4lRSU0jBeye3a22ktE83+n5YAyRh2OeJpbbf6lUuikX1zaiIuDVXENwWIcNs8lVMtsfJBe2OWqza5p8pf/drXmfJD2YURO0AX3a/4hAdlMvPrfye4Qmdzl65188rJDEtgN/yjOFSRVgq+BeYe9Kt9rYZlSFfQcIrYaL1WdWI9RowyXS+Z8zCRBSMKH5LyZ+++VsVaYCxre5T0G
 PfL4Q1+y
 PI8bgUOOQasLujumOfjwU/+MQ+/V11QODLC0vBkW8C7zX/oHVQPlDciwXx/XU68MURfm/j/zBoAWgK5ulDhnTW/jsxxvNDTy5auqabCDyAEM3UZ6DABCo1h+VRAYYR0AdeOcCynJCVj16EfbbVlJ5NGZndy+HDjsSBAayT88XpLS8bwSjwMbruISAs1FhsvdYUVyXgSd/l1t4hWlUVCayt4PpoWhAusink7i8Utw5vxiXLYKLwgCYdrmY+H5dIfGPItR56ecMLrv0oo0r0k8fdrpJbLUuecpsxn6yZVl0QLBon+RCd2kOlKvTpzo2Kp6QYku84VJxvvZZ74dbkJNPONrm6t4XKCcxKYn5qnlFkGJTYMD+qdSqpYQxS72OJUS+sDo+9hHmltReFdzNfLlA8nXr3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Commit fc137c0ddab2 ("sched/numa: enhance vma scanning logic") skips
VMAs without recent PID activity. Since only NUMA hint faults record
that activity, the filter can suppress the fault needed to promote hot
slow-tier memory.

Let memory tiering bypass the PID scan filter. In combined mode, use the
placement decision to restrict top-tier sampling to VMAs that need it,
while inactive VMAs still receive promotion-only scans.

Track the last completed placement scan separately from scans of any
kind. Promotion-only scans still update prev_scan_seq, but do not
advance the placement-starvation horizon.

On a host with 768 GB of DRAM and 256 GB of CXL memory, one large shmem
VMA consumed most scanning activity, while 2,537 other VMAs covering
84 GB were skipped as inactive. One stand-out result: a hot 20 GB hash
table ended up trapped entirely on CXL and drove CXL bandwidth
utilization beyond sustainable levels - resulting in a large regression.

With this series, the hot hash table ends up split evenly between DRAM
and CXL, tier residency tracked runtime load, and CXL bandwidth
utilization drops from 45GB/s (maxed) to 5-10GB/s, while DRAM bandwidth
utilization increases from ~200GB/s to 250GB/s+, resulting in major
throughput improvements for the database workload.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI:gpt-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  7 +++++++
 kernel/sched/fair.c      | 26 +++++++++++++++++++++-----
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index fd35db969bc94..dcca3ead9db59 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -804,6 +804,13 @@ struct vma_numab_state {
 	 */
 	int prev_scan_seq;
 
+	/*
+	 * MM scan sequence ID when the VMA was last scanned for placement.
+	 * The starvation horizon in vma_needs_placement_scan() counts against
+	 * this, so promotion-only scans cannot postpone placement indefinitely.
+	 */
+	int prev_placement_scan_seq;
+
 	/* Preserve placement-scan eligibility during an in-progress scan. */
 	bool placement_scan;
 };
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a2849e72c4e26..412c72084a63d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4097,7 +4097,7 @@ static bool vma_needs_placement_scan(struct mm_struct *mm,
 	 * threads can help scan this vma, force a vma scan.
 	 */
 	if (READ_ONCE(mm->numa_scan_seq) >
-	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
 		return true;
 
 	return false;
@@ -4267,7 +4267,8 @@ static void task_numa_work(struct callback_head *work)
 			 * to prevent VMAs being skipped prematurely on the
 			 * first scan:
 			 */
-			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
 		}
 
 		/*
@@ -4300,10 +4301,13 @@ static void task_numa_work(struct callback_head *work)
 		 * Do not scan the VMA if a task has not accessed it, unless no other
 		 * VMA candidate exists. If a scan is already in-progress, finish it,
 		 * but track continuation separately from starting a new one.
+		 *
+		 * The PID filter must not gate promotion. Allow PID-inactive VMAs
+		 * to proceed when memory tiering is enabled.
 		 */
 		placement_due = vma_needs_placement_scan(mm, vma);
 		scan_started = mm->numa_scan_offset > vma->vm_start;
-		pid_scan_allowed = vma_pids_forced || placement_due;
+		pid_scan_allowed = tiering || vma_pids_forced || placement_due;
 
 		if (!pid_scan_allowed) {
 			if (scan_started) {
@@ -4315,10 +4319,16 @@ static void task_numa_work(struct callback_head *work)
 			}
 		}
 
-		/* Keep scan policy stable while processing a VMA in chunks.*/
+		/*
+		 * Keep scan policy stable while processing a VMA in chunks.
+		 * A fault in one chunk can make a VMA placement-eligible. Keep a
+		 * promotion-only decision sticky for the rest of a partial scan.
+		 */
 		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
 		if (scan_started)
 			placement_scan &= vma->numab_state->placement_scan;
+		else if (tiering)
+			placement_scan &= placement_due;
 
 		vma->numab_state->placement_scan = placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
@@ -4351,8 +4361,14 @@ static void task_numa_work(struct callback_head *work)
 			cond_resched();
 		} while (end != vma->vm_end);
 
-		/* VMA scan is complete, do not scan until next sequence. */
+		/*
+		 * VMA scan is complete, do not scan until next sequence.
+		 * A promotion-only scan did not cover top-tier folios, so it
+		 * does not count towards the placement-scan starvation check.
+		 */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		if (placement_scan)
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq;
 		vma->numab_state->placement_scan = false;
 
 		/*
-- 
2.53.0-Meta


