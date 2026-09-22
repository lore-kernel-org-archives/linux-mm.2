Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17746C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6A36B008C; Tue, 22 Sep 2026 14:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7806B009E; Tue, 22 Sep 2026 14:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDCC6B009F; Tue, 22 Sep 2026 14:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE9D6B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8BA4120483
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:39 +0000 (UTC)
X-FDA: 85242236478.02.BD7E420
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3A70620008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ERpKZ+7q;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HZmb4EJkk3UUTgAceH+rUT2N1g6qzeO8Xgy2w+ERPg=;
	b=Pnl8SYJyR1HEbi00fMcKLFlEngCpBtPY7CZIwvh7P6Lcx5OrKgtmqUx/bnq2nqQSAeg0rL
	XjdlyBRPznPl4Dc+esC2mOZAPCF1D4S6OvHZtThjQQYbjvlrNzeNqNcE6SnDWExFS2VrQJ
	aoAZ4J25feIeNA1KT/gWKadLaNxEgMk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ERpKZ+7q;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101778;
	b=GMyf5PZoWgjNcteBfC3pqkrr4cZT6ju5V0GmJFmF5KpEehjHYYpxwDSbAMP3RcWaOtj/DO
	IO3sHDsiDNIRRIl80tDfYqMN3geC4XWZqYWHEGNk1YAhI6FAk36bnONroD0saT4ikkd9LB
	n9fg59Q5zC4RvcelWYte2hAzIFQq8oQ=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-93c1c71fc6dso10370485a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101777; x=1790706577; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1HZmb4EJkk3UUTgAceH+rUT2N1g6qzeO8Xgy2w+ERPg=;
        b=ERpKZ+7q669KYS+NRuj3KcgMIMuSrCk/hCQu9XaLkAUwRsLP00+HWApwsCq09MrrcX
         msaiZuKC+jjky2CrJQLxu/Kr1FxtulaFeuRvXeWWkWSE5mqdBleFKxDPR21buUU1qGPB
         uUKcD6DdQYxnSyITvjHVeAIFxeqiNv8dBw7CN80Zqq2bVJIXTCTJahB7NoDQ3AXJUER3
         ux+i5Pj/wnkuxAsE0uP2cLGo4DGl+92wQuaAsjk4AtaES/W2Z4DSYD+byRU9PaAzjECJ
         dKRvii7nSf7b0mYm854L4Z2wwjT5uLLRNktP7rVjhuPdomp6BrCF6Gk7eip1+6ley1mL
         3FOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101777; x=1790706577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1HZmb4EJkk3UUTgAceH+rUT2N1g6qzeO8Xgy2w+ERPg=;
        b=aXfrC8Llc7PhKnJ9De0puwxHR0VgMGBhzKr0CnGvfvL3AoeBiurii2hDjM81Ufb2G4
         pKr7mAFcCw+OUDUK/pdv3vfc3CKV/GtKDa7uElYOIrPJLtiGErcBngavQfAP01BI+j4g
         Fb4KxhUPLORNAU0JqYLkYCkTih9zi4rZGkNQvJWuomfEjBJWc/Sp6oKCY41Lo4RML/8o
         wGdwe2Ns1M8Yz6Is5IenFyB/w9cijIJF0TQYb0aa1KasvgKt1wFgWi14FfebC5qwsNKz
         dCNFW2NijHgTrGaoF4lwxIMPJb95ayGgvGEEH/NqQ7OLOXQMxMoFEF7o8+S6LtxM+Bke
         VNoA==
X-Gm-Message-State: AFuF++mOy+EJYXb7qs5h+kjUlnNfp48vqUwfpQxXJmyGoLqOtgJpvJpg
	9NxbxJXB8+JcfnwYaR2tXXbJazK7+NpUbTXnBALj1Ke2aSBxy/YTPH9yaRyvC2Gw8A/VQlt0MOR
	ieiA7i/4=
X-Gm-Gg: AYBFou0lpEDouIxcuCNx8L59OwBH9n/xANIgb9EykDPrID1ea6umm0nI49L/2cpS3s6
	PPHZphEqm2J/b1oWLS8RbS7jH8Aar+gmqexQrp1yXLtEwYlG7ailtGVAGZXOxigib4G1qv1Sy0j
	vsedN5asf079fBnyx2OdVyuoKsyhZPYxQCPZpCuBCdPwMkBEtMltiCIoYRv0W+EBbQBuPfS0/F2
	p97blNag50BSWzf41dqcIdelErvn1yuuOD1VcuUCAB/IkPocnj28IM4l1WmFw4JTRxrB6SjcoNf
	Sv+lJWbhhtvJ/gy2uZ/zuhd0o//9HULL8pCBpgLAtDPTg5lA9eZfsDLryS4yclJ30xEN1X9hPPx
	6UmWRprAjkZqe2uUj+NMVjOhm+ixDeig1QhpVRGX3AEelKGnarPQXmvKfTq+v+S3JUOm4aLieYZ
	EAL0E460Z6PUm76gPSecFDB7S0YwvLOpUeKQpFOWHC2hdbIHBMsw95QsaLgTYlSGH13srAIA9Zo
	jOhMpgJVrcELB3GHeLidvjpRX2FugWQ0Wc2PqIBitq1ATvzfG/PIfDRPi6+
X-Received: by 2002:a05:620a:370f:b0:939:a9d4:7023 with SMTP id af79cd13be357-93c17e32171mr566886685a.10.1790101777045;
        Tue, 22 Sep 2026 11:29:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:36 -0700 (PDT)
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
Subject: [PATCH v3 3/7] sched/numa: scan read-only file mappings in tiering mode
Date: Tue, 22 Sep 2026 14:29:24 -0400
Message-ID: <20260922182928.2199090-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A70620008
X-Rspam-User: 
X-Stat-Signature: bozz4uxy7m4owq6kuxooggrqkd5i95yb
X-HE-Tag: 1790101778-314439
X-HE-Meta: U2FsdGVkX1+8EsDNZ4KFtFbnTvX84SC5pqANFBB8uVKQTwrOwRmg+EDJzrexjWEZJ63167x47UcNrvITtztNyzPpFf42aMJdvswz43e03sWGSLve9KdmOzitTHvJokqqFvyeklZokjMQDn0iqAYcNGr9ocLlSutuRoNP2w00G71AP2fd33sb6aJlLjvai7crQiotaZcQacON9v9d4d69Sq12nWqv6AOjH6JsD4HbAj6KE8JBFPay1u0nu7iF9XIM4QTVXkxmL3nF1MG0WzanQejoV+SDoA/3EcheXrdbA22zdhI7Wy8MLYWxUA6WJU7tRlTQMTM4aCzuPFZ+UYlBw6oyPKSTkL7M+kUvuj9AwbYnhVCVCtMNYkLw2BVtiPqOmIsXosfzXZ9J6xKGhzCHZBhja5OFcbV7O+VTAnjyMdoEFS9FE2tjpc9d7Yf+BJty2WXh6+zQjwcvrzhHUwKbCofJaxkiaEOGP/D6oTB/6/TOT2yIIxQmyVpfOWu/dXCeQifBzPpfxhEhF+qTpCYKbEAjHHwrFGJ6asjM+htxl1VKyq4a7LNcahl0868drnditNXjaIaUMEIeXMAoaETMkA6mXhDx2aG3La1LvZBzGcMI7E8/GozSWqLNsz2aDA903pG8MWre9EZ5h8mI1LsPBAmxpMr1wqIsU7zm8fFIJHVw4vSdkcUpA2C46d4QHZUXzZi4ffGUCsPUEBpAJFRmjghsSby0R76RVHFaq/a6P7TAbeE+HFLW0oZDx1bjInBztP9HyMgExUa+N8KGL6y5FC7T3AKnoB2rN70Q8didmaR+9qaE5OoC0xPODynJRwFi8ArQqnvwCB6TBfzZ6riqL4VyW/1cVh7Q7fm9R9A5r5zC4Pl96EMd0xTkTbxq6WJ3tZFercbVAMD7A2BiTOKoVHC9Nu6o6M5d1/msvmboiLjPpFScEoOs18mW5+Q1cu7SAH6huT/3/ZHRCua5GKl
 Hz0mxde0
 /IxuJxI2krWu+N0bEM7PiENvlZTPJQnu+ELLm3jDm44CATKJ9U+K7XDvekHqWcao2ByeQQcuJG1yVQreJ2vZDQpD643uY1DKio/0SHtmUeJ79ejvhXlHBi0gO0RN1zkHyK6/x43r63b5MxwkqmOoqFU1Zz33fFJKmikffnOpLhnoceGd6kal9e6rfd39BPlZMolnPsHjf/wEBPWQkI7SL2q46CEeBVnZnQC1CiLQo/fnfWHQAYeT/ZpPHlmEBe3W+m7SFv6eAJuGoRkRZ78NBwKijUZ3EkLEpTZfrZlcrwbpSB9sXDyJzvm+WJTlyDABC1SdM59ZcvOJWvdXUswGywTE8VOeRuPET24WFx2lcBH/0Vu8lN44DycTDdQYKM7dviODKTdtsUPHdoRSS/sAOFPLaGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
shared libraries") excludes file-backed read-only VMAs from NUMA
hint faulting to prevent east-west placement bouncing.

This filter hides hot file folios on slow memory from promotion.

Scan those VMAs when tiering is enabled, but make their scans promotion
only to retains the existing restriction. Keep the historical VMA
predicate unchanged for backport-ability.

Read the balancing mode once per task_numa_work() invocation and build
the protection flags for each VMA from that snapshot. This keeps the PTE
and PMD paths on the same policy for an entire protection walk (which
may be split across multiple scanning periods).

On a host with 768 GB of DRAM and 256 GB of CXL memory running two
database services using ~430GB each, 169 MB of their shared 185 MB
main binary accumulated on CXL before permanently stuck there.

With the change, the binary tier residency tracks its runtime hotness.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dc78d24ed8bc0..8a4687f67d82f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4119,21 +4119,21 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
  */
 static void task_numa_work(struct callback_head *work)
 {
+	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
+	const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
 	u64 runtime = p->se.sum_exec_runtime;
 	struct vm_area_struct *vma;
-	unsigned long cp_flags = MM_CP_PROT_NUMA;
+	unsigned long cp_flags;
 	unsigned long start, end;
 	unsigned long nr_pte_updates = 0;
 	long pages, virtpages;
 	struct vma_iterator vmi;
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
-
-	if (!(READ_ONCE(sysctl_numa_balancing_mode) & NUMA_BALANCING_NORMAL))
-		cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+	bool placement_scan;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -4221,13 +4221,19 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/*
-		 * Shared library pages mapped by multiple processes are not
-		 * migrated as it is expected they are cache replicated. Avoid
-		 * hinting faults in read-only file-backed mappings or the vDSO
-		 * as migrating the pages will be of marginal benefit.
+		 * Shared library pages mapped by multiple processes are limited
+		 * to south->north migrations as it is expected they are cache
+		 * replicated. The benefit of east-west migration in this case
+		 * is at best marginal and may be harmful due to TLB/cache
+		 * invalidation.
+		 *
+		 * Allow promotion as a cold page incurring many cache-misses
+		 * under cache pressure can drive considerable bandwidth.
 		 */
-		if (!vma->vm_mm ||
-		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
+		placement_scan = !(vma->vm_file &&
+			(vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ);
+
+		if (!vma->vm_mm || (!placement_scan && !tiering)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
 			continue;
 		}
@@ -4307,6 +4313,11 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
+		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
+		cp_flags = MM_CP_PROT_NUMA;
+		if (!placement_scan)
+			cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
+
 		do {
 			start = max(start, vma->vm_start);
 			end = ALIGN(start + (pages << PAGE_SHIFT), HPAGE_SIZE);
-- 
2.53.0-Meta


