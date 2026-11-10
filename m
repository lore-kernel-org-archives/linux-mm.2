Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8A6D60A5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=a0+tFL4F
Received: by kanga.kvack.org (Postfix)
	id 8C5D76B05C2; Tue, 10 Nov 2026 10:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E446B05C4; Tue, 10 Nov 2026 10:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766DE6B05C5; Tue, 10 Nov 2026 10:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B51E6B05C2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFC1880910
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:05 +0000 (UTC)
X-FDA: 85419532170.29.C5F3ECD
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14A65140016
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a0+tFL4F;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFWhcWmrWDGG0gIid6Q78OLBS0KZGvC/qqEABqibX+0=;
	b=HMtYNAgAp3Bzf/50IwUPkIgdrZ3u84zG6w+C6uudP6mJ4qyE0li3hP0Qi0QzHYmRKYTEbt
	SWpJFHH11zJv2Ii5FbwkIb9yKbo3gUZ9JqYO0XbwkCujCTPqTaopiR3dK44SexhGaBwR3A
	OHdv3JO3cvgYtocB2B7dmjouk1iMuRs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=a0+tFL4F;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323104;
	b=Z2oNMLm7jbwbPHdcadwl85+GkGABzhEhckG6ngc9cKRi6vcRHIuDF6hBk1pxF+yIpqVTpK
	WzXVEstyhJym05uKT5Lxgsxc9B21aYWVWLO2TGnRl4DW0A+J0j7W0qCGzQDJjAG0cowVLV
	EjgykwtPYXI5Z23xXoWsODeGXijeE0s=
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5ecd9a400cbso1170042e0c.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323103; x=1794927903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cFWhcWmrWDGG0gIid6Q78OLBS0KZGvC/qqEABqibX+0=;
        b=a0+tFL4FW2IN0bRV5Nc61K0UNJ9bN8PcnJZd1RK5s9NZBkPplGCdr/2skdQz1axu6h
         JrzqQm8kdsvJE0TEAsODQ599lN4tB70djGin0vfXDxuIkMwBk3I4gpvzHo0Q7Z92q+29
         soscRQmtKkT+FtOT5PdnfURJKb8K6Mpi08VR4Shi4/iTBKc12nGdulpKindJupbv3/W/
         kpXvvQ5Z1nhlV5wsxsYFCQ9upo9WCpz+k8ObAeb3hE9W9wVfBQIMbSricf11I+L+CLYS
         EdKmRhLwzgPg7s00VxbIPtQJ7FrKTWCMlM918aM9chWkK5NDSEiAFMI7XeCVLYpp0CTU
         QgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323103; x=1794927903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cFWhcWmrWDGG0gIid6Q78OLBS0KZGvC/qqEABqibX+0=;
        b=Zi7JUWAS62Qt2Iir14/4CT++ZzGjoR8cttYf1lhqGwK/uQOKLjrW8oooM3Gmh7BgqN
         CccwSMfLOf4sgUo4U4XB4B5GsLrXZW97ClciF1EuIjHl3QspuVdFwjsZPnyNHTCiohyW
         ICE5c47uQHejhIabA41tXbtLts7Ms/R9r+4yvOXGTa1CSpqRROusrg/rpVQEduajZxSI
         O50MJdP24d1RfTO9A441IzpxLUcgHX6UOJatF2vunnVVizlp8qAfOQH8JN2imBcsQScN
         XWXl9pCjC54v4mXJM+pj7GuMG/ngg+R5VkHk4KfuV96/Z3Vs192yzMf+nOgn9NJHTHXf
         n/pw==
X-Gm-Message-State: APuU4Z8br9xjB3Ptk5CW5aZR2M5Z9qlHBDCz0ABmfMsuK7eOYf7FRTmy
	X1x6eoUiDezGtD5nI33e08DzkwUdzUxGkJ3UF2bhzRJiy6tTiE/mqiJTtPBENP1AvPe4ytz6Jlj
	WOQKh
X-Gm-Gg: AYBFou3o4vAn10/m3ekFl6fH9vwALLjpNk5lO/8QJnI7+TrccPhJTafFdlkiLDbz1iF
	EWqaRVo8O7VYJlh3SSYJoZHuKMQfqjztFMPdZKuyOHDefUyylFD1QLZAUpn2+I5eVTmvIwzKd2C
	YhaobQa/kbl/qK536RBg6RKd+VVg15CiALZLuWcFpOG0HXYAPlK5IGRP+hMafhiGWA4TPN73yFl
	uJ8wFDPk6Jdy3ZaOtk6NkJm9if9oPMsAnzmQgf0mKbJHjrv2LxneYEJGhMxb/U81iZBUSLKQfBi
	88p4aquiCgGNL62W9w3qw1XHhbe2RPJmQ/jdAv6ZqK6w9TTZ5lYyqGvTBZELtiENF0D+qcl6woT
	XajLavVC6Crnse0Wdg9B1mFIIc5GG+0fKGK/FLXac/1y4hBIrqgpMIQieX3qeOyLPiui4j9ezO7
	xG7Ok01aL8LcUXb8XQoCVPZqjfoFuKagvAAbIuymjkyzk53lAAqLKgc+2P4WK3yeighOjng75Rb
	d4mmLHxkpAjFdDE8b6ojM25nsaQQ4DoSCzRSKik+SvTed1D9M/iE1VuXtngGZwtcn0CyrsTCN/M
	SyaxNVHsxsRzv/7Y3zw57y2bNvqbENPvk0XdRMpyORQeWjbyEu29mnkNMJ0WrXeoc40FaUwMr9O
	zG7QpWpDbbQGgQjQ=
X-Received: by 2002:a05:6122:32ce:b0:5ea:b972:1403 with SMTP id 71dfb90a1353d-5ee0cf152b1mr999596e0c.3.1794323102986;
        Tue, 10 Nov 2026 07:05:02 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:05:02 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
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
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
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
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v5 4/7] sched/numa: separate VMA placement from scan continuation
Date: Tue, 10 Nov 2026 10:04:43 -0500
Message-ID: <20261110150446.2452975-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bwnrgxmjf6n5uewwbcj7nqacyqo3gb71
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 14A65140016
X-HE-Tag: 1794323103-68909
X-HE-Meta: U2FsdGVkX19CNrDW1hZ5RRUZfnHoTPwjIRmO0AWYAql+O6kIJn6Ib+enLz7Mlpti+WVPvEub3SnSQL3A7m/lM5dov0kIVBkhVyyVaW436voTB4aaZha9rADcmAXffZcmQM+luE+4dSVC6nkHYKu5Gzf13XaTtjyX+Us5u+FceJXzx+EAYZ+vpQ0LIXdR8Npu9BkonjBekNSNrDNeCBUyZhhAzRlru86IVLAnFp2FiHaTj5kWix5Kbv51FXQopuwJ2ca86SO6qnSgTjyaQotjhH4Xm7/fX6Ql+oMz8wi8j5l8u8XJzIx8OMb73cffhVKSo0VbO0ggRwuetc9Wuwd4FtmPiDR0jCI2Y6ZTqPrepP0TnSn7Mk27V7twdw/97sIpEalNrnkgndz+JjSfV3ULLn6m0FrzFB9K0EDUTa5vxy+p+A06d/SqPOeaL/EI6swqcttbOatbBkk7Rrs2sq+b7RwLSVVZ67Zz9ZyAuvFGBL1upp+KRugwmL7se/EsuKQY9r8zFLHDk0SF1IK53XycMFxK/zIc8Ro7yrmezVL70x0CZ1S5D7vunxXCZFEj5Rx2+qEMXSrL1MGr9VezSHGjfgdNbu61mLqRJD5cEE1wvVQpt2LEPchd8V7x1QzU57tO4qA2kKG13wn+Kq8XpZAuNH2SdzT4bAp/pGuHKO9TeMkmDmcGlRAwvsRMUhGwV2WV4Ckqmqm5Xou0wtsfaA8J7TXYgPd0/3hhFwPnw2DnOwtWDOqFGnGLoXD1CIDAVqDipzVW1n2IFdgLqmcRHM28qFzHVTniFEdHpcKx8wtDLQdr+UMIbYxNFb2tjQGDcPLF9nnsWf7N19qZXLST0eeFC35dL1gcN7By4ZgT8bFS0MjkqHuhoFSp8u87P6sKr/mE+1IH+FUepHoQRHBsCD0Q89EBjOTbDjYfzBzT7eNoNwtdkGHWbNMzMqFXq15EsxgtPstN/3Dm9XVfcQ3exos
 7N1C0C4r
 mlL8ko2zdR3VW4xgPvbZSbE2rljgokOAAb58s0fsIxwoZNyhbBmjm5M0t296+t0RU25VBgKw06/dGfhVLwfBrji5eAkraOzsYWOGKP9jNBzfr8Iv8hHT2QvW538M/c9OZSq79clyltNun6L/GtM9+uzNw2696wAETtRGByRZNhoOaV5lVL+osvjJwoEySJmzv2YQZ30sg52jvJ/ElBsWDFV4Cw7nBPnM8VoZ9pFXiUjumyfoLPN4bni/JMJZ8Wa6nuVHYJgR/IpQLKJTdMC7SWzZuuAOzp4cJkvLmz7rSQIyaDxgF2lAlW8E5wVsDNjPNiWeja1PrCMAGnYGyZy1wcoWZkfnVNqM/8Y8DxPJ9EzqCwDGtQZhMSpQlUHWkE0Cp1U6E9dPyyujXWlYf5bFWdQ6JHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vma_is_accessed() returns true both when a VMA needs placement
(east-west) sampling and when a VMA is already mid-scan across
multiple scan windows.

Callers cannot distinguish placement eligibility from scan progress.

Rename the helper to vma_needs_placement_scan() and handle continuation
state in task_numa_work(). Record whether an in-progress VMA scan is
promotion-only so a scan resumed in a later scan window finishes with
the policy it started with. The zeroed initial state places no
restriction, so a resumed scan that finds freshly allocated NUMAB state
falls back to the default policy.

This separation allows PID-inactive VMAs to be scanned for promotion
without treating scan continuation as evidence of placement eligibility.
It is a prerequisite for the following fix and must accompany it when
backported.

NUMA hint faults always target the faulting CPU's node, which is
top-tier by definition (any node with a CPU is top-tier), so a low-tier
folio can only be promoted, never migrated between slow tiers.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  6 ++++++
 kernel/sched/fair.c      | 40 ++++++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e3..045b47f4b0463 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -803,6 +803,12 @@ struct vma_numab_state {
 	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
 	 */
 	int prev_scan_seq;
+
+	/*
+	 * The in-progress scan of this VMA is promotion-only.
+	 * Resumed scans finish with the policy they started with.
+	 */
+	bool promo_only;
 };
 
 #ifdef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c0b7271f1bce8..778ba0ed34fe8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4226,8 +4226,9 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
-static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
+static bool vma_needs_placement_scan(struct vm_area_struct *vma)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	unsigned long pids;
 	/*
 	 * Allow unconditional access first two times, so that all the (pages)
@@ -4242,15 +4243,6 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
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
@@ -4274,6 +4266,7 @@ static void task_numa_work(struct callback_head *work)
 	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
 	const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
 	const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
+	bool pid_scan_allowed, placement_due, scan_started;
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
@@ -4460,15 +4453,29 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/*
-		 * Do not scan the VMA if task has not accessed it, unless no other
-		 * VMA candidate exists.
+		 * Do not scan the VMA if a task has not accessed it, unless no other
+		 * VMA candidate exists. If a scan is already in-progress, finish it,
+		 * but track continuation separately from starting a new one.
 		 */
-		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
-			vma_pids_skipped = true;
-			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
-			continue;
+		placement_due = vma_needs_placement_scan(vma);
+		scan_started = mm->numa_scan_offset > vma->vm_start;
+		pid_scan_allowed = vma_pids_forced || placement_due;
+
+		if (!pid_scan_allowed) {
+			if (scan_started) {
+				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_IGNORE_PID);
+			} else {
+				vma_pids_skipped = true;
+				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
+				continue;
+			}
 		}
 
+		/* Keep scan policy stable while processing a VMA in chunks. */
+		if (scan_started && vma->numab_state->promo_only)
+			placement_scan = false;
+
+		vma->numab_state->promo_only = !placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
 		if (!placement_scan)
 			cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
@@ -4501,6 +4508,7 @@ static void task_numa_work(struct callback_head *work)
 
 		/* VMA scan is complete, do not scan until next sequence. */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		vma->numab_state->promo_only = false;
 
 		/*
 		 * Only force scan within one VMA at a time, to limit the
-- 
2.53.0-Meta


