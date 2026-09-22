Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69427C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8086B009F; Tue, 22 Sep 2026 14:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FD96B00A0; Tue, 22 Sep 2026 14:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E346B00A1; Tue, 22 Sep 2026 14:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E60E6B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:29:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 814ED16060A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:41 +0000 (UTC)
X-FDA: 85242236562.13.D4AC1B2
Received: from mail-qk2-f42.google.com (mail-qk2-f42.google.com [74.125.230.234])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4FD02000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:29:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d0TI5v+D;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790101779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfgiKa+YRyMtK2RiU6jcCWMC566+XGPfa3bnqM4rs00=;
	b=4Ve5UE+6CW4qDBs+cKE2gSe+UMhBc6MMFzAY/gLeAXq0YeMdP6xXEKWTlrYEMoAvLnOAa1
	heYimacl8M/HA30jzIND6IXKwXe+SixOhvmRlCNE6/TtOePbrGtXVqulm8E3/S7cnSr8VR
	MYqeX3KQIC+uBqx+mGLK+Vy56PZb6Mo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d0TI5v+D;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.234 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790101779;
	b=0PuhJzxbkxTSotFqjcleUNQAUGwt3dUARLfZnoeCkSW3gADvTcZdGxbeP2WXMdU+cPKwnX
	33WSD8p2pOSznUbiMNgGko+Gw5tKaxUYk9kCKzajVgyuKH6N0QmcIbfZzeZeAqWMbAvSNQ
	4/wBbjh7ZApqJEng0vV8Rhlykbj5dEA=
Received: by mail-qk2-f42.google.com with SMTP id af79cd13be357-93bd580489dso20489085a.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790101779; x=1790706579; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nfgiKa+YRyMtK2RiU6jcCWMC566+XGPfa3bnqM4rs00=;
        b=d0TI5v+DkBV+T9JsEVx7RR8uakzcbgQfGTairTMYAv8YrSMI9mWZQadMDPZSYTSDkG
         5YQJIoDLLJ6qReEfuzoXnGtLeLMA3GxPdtaXz+yncbgYWpp/CjY7P3KXh5NQeq5AKo90
         5YbSjgohMBqAo1b2NfoMJYp+q3hafnktmKscZobkrRc8PTAaS3s4OcDRsN4948VTf5fD
         RIfWRCu7mOeJ9RhL5AyLUU7Qme1DtQ7G+h7EBRLDh4uXVZ2IJdOi2ESRV+HXx1Yu2pge
         WuLjvzrOEieIMWGjMC5OZofFIFiQzxdzb1FIkUIZt3Al1GPzFFELqatB8koCbKdUCwK1
         7JsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790101779; x=1790706579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nfgiKa+YRyMtK2RiU6jcCWMC566+XGPfa3bnqM4rs00=;
        b=KeGaq11/AGV+yqBAX0lfbTIXs+ckJhxdJ/MMPsm43CmoL6Q4n/6B7h3V+nJy/TXkvM
         gN79lSLwT5sWbNsXzGwEcF1YIdRDrJUzJJ5MPPs6IHcpvAZjFGCamLkbpQluXk3TdEfM
         lb2s7ou5RaodZJGuwo1W+egLqADMF2+0EXjxdgRc8atjxyKWBndv+uQNmnutV4i79GZe
         kvhjzYakJjMqFALMFQeKcv3gZ79UVBcNpbgL+kBMCCt7df6bkAjip8PNXi1PaGSgFFzM
         EYUpWJfQgUxsZ84z8cLRspcLrZAxCzPY7v9cNu/+neRcWdyQT6C13wFcHxeeEQq+aZyc
         pPdQ==
X-Gm-Message-State: AFuF++mMF42A0N7eijEnpGflsTkqeLY4HFfMTeYZ7xMmq4fsleAqcHhf
	rt8OjWkwIFvcd4IbgVkmsQtf0729RG+nhpzp+D4xHnI/JcWNJVoN+d4uGGpguVGBzOkJqU8Nula
	SWQvJa5g=
X-Gm-Gg: AYBFou0LtAKXhD9eaqJplSWcM17nHtF7P2mk0RdajstSnXLHmCr89RMooDRZQYOfMjI
	57HBJoHf5KdKxN6OoHYJoMBJ3Y7zuW8445ELzW6rvNAJ4KPl22pP5LBQC3lBbndjJ0X63LoMAND
	8bqEYagudy0jd1C8FVrUmkhpHKTHbm8yAW0Q77toObxr5NxYUR2w2z42sH1kctpwLskoRDLolhR
	qCF8mtPHhhtHTiIhqfYXTj94/MWSvSvm+elQ2n28YywB2EOXvQFmSCHWpgxpgbIW4jPW0MnZ+EO
	N0Vur3lc4jFjpJba17Bj4H3lajUkCDeNfwKptahoHwHNrEujlWTik0IdabPSUd6Efi7teTvQLMa
	aWlMQFsNoqb6oq7ABL8bMs/ujYA5glXkCpD42VyhlAoWjVLW+kVDeuXOV+t6MICuP4mdRn1Jltt
	ZEpwuyYFtbK0I1HjtgguPVNpQaxUlT5HysYd9AOLzpnuQsBOQSuDyLW5rPU3me54oQfzN/OBhuX
	gQpbU7E6PDXiMEAGTS3DxElNuoppxOdDOW/1WozoxmS3Vw/6ZnkfNHKx0/y
X-Received: by 2002:a05:620a:27d5:b0:93b:d7a2:83d5 with SMTP id af79cd13be357-93c252aabb2mr34297885a.68.1790101778939;
        Tue, 22 Sep 2026 11:29:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c24889ac9sm37130085a.27.2026.09.22.11.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 11:29:38 -0700 (PDT)
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
Subject: [PATCH v3 4/7] sched/numa: separate VMA placement from scan continuation
Date: Tue, 22 Sep 2026 14:29:25 -0400
Message-ID: <20260922182928.2199090-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922182928.2199090-1-gourry@gourry.net>
References: <20260922182928.2199090-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4FD02000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rnw8bo1gozxgxdhxyh5yqqp9f6gj8epg
X-HE-Tag: 1790101779-535341
X-HE-Meta: U2FsdGVkX1/cSh66PGsAzjMps/kn9NiRj5YNi9Wp2XMSxqQ7xMxsSaYKqxtEHBPy+ti6tzjQY84p4lqvtRoLkR9xb8xNSQyev0hGfFHrL2O/G3n41AaOVCsCwBFURJiWUR4F1a5rMEus1P5RYqzX5sfNkWWkMMmLgPQW30m1rAF6/GfArmwuzR4YOs5+t9/gy9qY0ARcYsP3XGNuoHFHGQwzyAtgW/8TP0i/Vt5oHaAhJMk09jPw5dwgVAAvZACqoBA1URTxWXveUMj+hs8Dl3kYGPmzVU/W89wJiioHT4VZRkqptrLLcmZdcNLFow52TdH+L+XEHGB7gosGoiVwWdsryGciPG98EXep56h53nCYwpiVh7migktoouhFAYcjvW9oAqi1ybIowAaW2v4rV1GZud2tNsJNH8GIyt0bzS9FOm7day/SjViv4TTCExMr1RS4TrPtKNAwuZn9f7gEBWiQjN5wJZIMCVJIhDmB/QO3rKmCEGMxb/ogwaVzWjqBnGKeOb/OEGuYcSs8dHbhcRRmI2GQ7ZW6mXis8vPoSpnGgHghrNHArMC2gDN0Y0We+LNhFLxU/8E/kkiKo0A9hnbNnazB1N0gbDUdnREqV7bzw9iG4Qq2UF9e8m/3CUUGpFaqaxN26IuBzDfOzt2Dk7WVJEhg4qgmTd0JlBHDJk7CdISXm1LI7akKxq8yfYFSoft/HNguWPoTFWC/SLDIMK1oMZMjQJDLfnuwVhcsrtOEgSnnIxKKsPvCJ2Fiar0yZCWkJSGCfi7p4eD6TaNxV3gmNQreCqtiX47tuvrmdVl6cubMxI8B4OQBwtJpSdMHIJkG4EXo8WGIGe72PKGtlvU0tuAF/Zl0ZICwLg6H8XUePdLEwg3gQ2QQcHgYgIWYlmcme/Rdl0mPxIXKzFCnePBww8hiNltMqh0tIrSAaaG14j6KiO/Zf62x3PAs+JxP6lsK6N/baGp2atYnTrs
 7CMTGoRn
 +Yca3wBlxAcMg3JFik1Goq30xZnwwlAq9esK3pD5tCuGWv5kIJdBdaf3WRwHSfYiCWJvhZrVmH16PdYTdJi9b9QK08UfArkzZyFfGSk/LCDVqepnswvnev+EkfIZaClIJd9db4w2VlyzryKZMx+AQsG19SB1uZjCGfjTHorWLQ5bopt7b3p3LGutdbRA61NDrBomDGA+LQbJ342XxnvhRbeJnttMxbmwCm9Xr4u/yH95RpulsJCs5DP74HJ7FZ1Zu6mDtwam2A6tEX1is6s/ofxkIy0AwtvrXkFOm12PMRmkFHCQOSMjd0+FfdPMwNjcTNahBGowJvPgHVsLvpnAoIePKVF5Wy2olcxcvULZ+GQqfrk+EnDvciNWzQHKOQo/05moSGB2uFHQPEqrOXgk4hzYLJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

vma_is_accessed() returns true both when a VMA needs placement
(east-west) sampling and when a VMA is already mid-scan across
multiple scan windows.

Callers cannot distinguish placement eligibility from scan progress.

Rename the helper to vma_needs_placement_scan() and handle continuation
state in task_numa_work(). Cache the scan eligibility decision while a
VMA is scanned in chunks so a resumed scan retains the existing policy.

This separation allows PID-inactive VMAs to be scanned for promotion
without treating scan continuation as evidence of placement eligibility.
It is a prerequisite for the following fix and must accompany it when
backported.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  3 +++
 kernel/sched/fair.c      | 42 ++++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 77c90b1994131..fd35db969bc94 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -803,6 +803,9 @@ struct vma_numab_state {
 	 * A VMA is not eligible for scanning if prev_scan_seq == numa_scan_seq
 	 */
 	int prev_scan_seq;
+
+	/* Preserve placement-scan eligibility during an in-progress scan. */
+	bool placement_scan;
 };
 
 #ifdef __HAVE_PFNMAP_TRACKING
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8a4687f67d82f..a2849e72c4e26 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4074,7 +4074,8 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
-static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
+static bool vma_needs_placement_scan(struct mm_struct *mm,
+		struct vm_area_struct *vma)
 {
 	unsigned long pids;
 	/*
@@ -4090,15 +4091,6 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
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
@@ -4133,7 +4125,8 @@ static void task_numa_work(struct callback_head *work)
 	struct vma_iterator vmi;
 	bool vma_pids_skipped;
 	bool vma_pids_forced = false;
-	bool placement_scan;
+	bool pid_scan_allowed, placement_due;
+	bool placement_scan, scan_started;
 
 	WARN_ON_ONCE(p != container_of(work, struct task_struct, numa_work));
 
@@ -4304,16 +4297,30 @@ static void task_numa_work(struct callback_head *work)
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
+		placement_due = vma_needs_placement_scan(mm, vma);
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
 
+		/* Keep scan policy stable while processing a VMA in chunks.*/
 		placement_scan &= numab_mode & NUMA_BALANCING_NORMAL;
+		if (scan_started)
+			placement_scan &= vma->numab_state->placement_scan;
+
+		vma->numab_state->placement_scan = placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
 		if (!placement_scan)
 			cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
@@ -4346,6 +4353,7 @@ static void task_numa_work(struct callback_head *work)
 
 		/* VMA scan is complete, do not scan until next sequence. */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		vma->numab_state->placement_scan = false;
 
 		/*
 		 * Only force scan within one VMA at a time, to limit the
-- 
2.53.0-Meta


