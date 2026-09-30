Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52001CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B5B6B0096; Wed, 30 Sep 2026 07:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D231B6B0098; Wed, 30 Sep 2026 07:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11F06B0099; Wed, 30 Sep 2026 07:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92D466B0096
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FA5A80774
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:22 +0000 (UTC)
X-FDA: 85270190124.09.E654074
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf29.hostedemail.com (Postfix) with ESMTP id BFFEB120009
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JozeI63F;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5sOdqBpRiTst4ZBC1jadPK4tdAEyGxAhe4Ruk8ZbG8=;
	b=3f+8PWIHE2dOZRNtFvwV99lY2EId8jgn0xkEq9GUXAG2ADKpEgpGkIpq2LlTLY39IFnfo+
	ZA2cK3NcXVzrbzModv48YORPkHRe9Q420CoWnCW1HDbsQrKt25Er/3NHNY3gZZR1LEvep3
	jyiqeo0mhaCfR0lQQhqAH2yBU5p7GMs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JozeI63F;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767340;
	b=n2vGbtNPb+qOWEwWjRDvAs9mc3IZzRTCiOC8oEDg+Yd34UmNYhnW5VkNFW+5D2oPUhlwT5
	3XrenEX8dmEILuX00TcwY1lgrsGle/GBABy1jEfhpv28zMBpuNCbaCuUGLgHy1pywhSDQD
	jr7XvVfa/HQG5rDG0Nn1rGDxpn045BY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso48637435e9.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767339; x=1791372139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M5sOdqBpRiTst4ZBC1jadPK4tdAEyGxAhe4Ruk8ZbG8=;
        b=JozeI63FKhvg9mfnLsn/SK9sTgVTCm/8Q/5fdHpCjS2gHxJNJErQOxcmelwOF5r1AN
         F+KPTfVn4J4BrvdMOhL5rObiR973bTVx4dYkz54GFcSeYP4Je7kNDFW2QGXtUEihXKJM
         ovR9PFdSKSBEhRG4h66Yhye+iXk4o74OgWPckcl/orRwrsrO/4gIVOmTv8LYmGG8ySHW
         BaPxc6a5+qfh1HvN4qvnOh09WWlXS6azrANjOFSLRtAePDubmj91agLXhj3dRbb8yKml
         hMD+KLgY7JFm3iclI0mNUYKSKeTeYxC/EfyRP1acCAPz/kGjpx9cvbPXBGZi3dwpCvux
         iQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767339; x=1791372139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=M5sOdqBpRiTst4ZBC1jadPK4tdAEyGxAhe4Ruk8ZbG8=;
        b=VRsWXHtPZsPXX6/xZISzpXyXDlomLyjROTwmjO6wfzv3h0ZFPNhqBcMBRw2PnHOHU/
         BmzW7fvNm/i+iIIWSlxz+oAxL1sMIpPvy2fcGv9Ce6NPB91B9XZQE62Tpbh9vw5m8asd
         A64AYG9Fd4C7f2ulKUvxIgY09tOx/SxWWoXPmQfrlDoBYXVuSg/6pz+tFjN4sF3g0WtT
         XCEorRZdlatlxfHcE9G7UDh9OEfxIyp5N2Qr4Z9AF3ErzDlrvEsTwyN+h8u+8FhSjFZw
         RXoudN7cX+18gDb1aQ26aluiUtivPioSWLSgGkc9PsMqXNQRdg6gINq+zVQnQBLs0dyO
         ikKg==
X-Gm-Message-State: AFuF++mPVuI+GuxO+27e604qyHvzYFjYYM0dVSk5G93tN8plrlr7c5zy
	KMSFznl6TPrf4le2108GhVAYCmHh5d3J5aqRDqske1a8CjDQGa7pVDZJYDCmPBdejK4jLoILEU7
	NMCaO2NDuCA==
X-Gm-Gg: AYBFou0GJWTomKs/T3/r9XH+WWBeZESFksim9H5GRioNLF4gTmo2ZR7Prb9XmzN7qc8
	+6kjFfg0pYxCnS/J6gV99oHtAPZ8SkhCUPg4fmr7UEaIc9x92LcOpU3ApYQbiY/KhNHfU+sea9D
	iIkua5WfRh9EucciqaHUdbfWuPblwc2Ly+YxYBF6mV3hwNe3Kd2hlqnLJF8sR1MzrPRn7ADYHDy
	6Z6J+eK0hxHu+Uqu8gzObGWqWjH8w1HNdSTfBa/SzBKabY2j8O8ceeKwbJm7gZhGtWvG2pgNm8+
	J/Ilku+1I0IjAEhveXRYk55kl822BjkLdgJnGlNBA4fXZ259TLdztsMUb7+W08W3MCpFvHInYP8
	9UDeC4mJ7aPclh0CSrNihBtZHYoAq/eNDPdLM5FAGYxUfiRk7jwYaKlig1b/6IKhuGHSVcEZZO5
	Vi8BblqVhLEpgOLsOVzInRW07mtoMUwoLr/j6zUOo9qKV/jXYOhtlr33ys3sYME7nzf7qH14SWH
	0QYuizxQsiiXE2dL8dx8eiLYVc=
X-Received: by 2002:a05:600c:6206:b0:49f:eddb:bcb1 with SMTP id 5b1f17b1804b1-4a01b11cb33mr18611185e9.25.1790767339469;
        Wed, 30 Sep 2026 04:22:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:19 -0700 (PDT)
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
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v4 5/7] sched/numa: scan PID-inactive VMAs for promotion
Date: Wed, 30 Sep 2026 07:22:04 -0400
Message-ID: <20260930112206.205083-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6qif4nc8hy6ejy95odqewybfwk7pf6zb
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFFEB120009
X-HE-Tag: 1790767340-344870
X-HE-Meta: U2FsdGVkX1/AsE7Z5GmeFhKvRsDmvb+HwHnTN8OgX70RxI9IkULg/NxCt5BBnRFLZ+PRftH9xQzSPii/dsSF+y5ktT1+fgYsPH0ssjMTCRKkvBgjgHP5nzuujbUGoGDB0OY3K9oL+vFLMsAJiiM5A84RYvBZp44My0XO/kgBMoWP9aF+uRQ/0EEgQdIRgd3c9e89SqrUP6C6m3A2O0nYpqqvaWb/L9mW8EQWaRj+rlcU6J1I422xA4z1v+Dn0sbto+lICWKVh8U7BaS5+4KgE6ksLm+YRrbguj4Is3fQ1Z34HXwsDRy8Syctc/tFz8TTv5D05UZtYlmP4H1XqcQ8JlQt5PskZ5KrPx2dEWKr9Z+jYxnKUWzIzk/+08GwbWRPoydqml1G8VDL+L3SkC/4Uuw7p/OViF93iU2hvyMiA4sX6hEf/FndslGvkQinpIiDuR1DbuL2Pq60pfVKoYJa4Elq2YdROIQ+dobxTuiJ9O8z2fW1IQJi6iTcci0nlMyYL+EesWlCSAmJFG/1Sx5vPfc4WSlU/yIYEnzpbFuZL2hi8G/WjoJ/NE6tLNs8Gm4eRwv71TWmuQeOhJQpOc5KiHwNOGyb+n1/FskkV7wQBAqHOsNoIlXe02Th+uRKzFTRUmD6rPQKjDkdkM45mNGK26qSEw8w9+ccPEuZ7jdEmb9JtfUXA5aVGQLAtxoyIOw5ZVmvY1VADvn3rs0j13nsq5c3ivb3xXrlfT2+2pkTDzag70c+cKztZsrurQ9Doukx2YD/9v3IAOdBZf8vs6vA7AoPckF2Dk6gkCscgzWbjs9d5OhwaRr4oe+BrWjnqPfrUlnDyylf0wJBNokk9BwhnvUZVzsI/P0F4r8191kH4fpsgPWs3Lv+Iif99t8Gr97mq1EdPYSYMmpLLQyTs5V2y/chGmO3XZWR1ktthOxYVsfGskk5zsIAOG08+646mpx6fv43lC93qQ8Blj9Aom5
 3sVnVsvB
 3iwpleVkvCIVm1ckW4ul05FcOhkebpwuxod3UBTAxns/tlPN5J43taOuFPmXLcKxtLqIDAWhJHieP/u7+2KvL/8R5UOjZ0YWgkSWKTGSFPXKvp8yKWVfUuYzL91cgDoyqOYoEHQfbq1uYvEk2UnbXoM8wL4ff/eEvWTauChNEGRvWGT3ySXP0jJ2edq9sYildF/kQUcNKnttEZX5hotPpIdsmMEl3ijyMrfuS8Yp2Oz3axvTj8kAhde4t5FF/mRa+BQQaXirAay8s0mLQMH/v1ZCkM+TnCp3RH/c2Li1kGJ11SC0iJJvYuGWEheh7+KeNtjxofXF4nxC/q5+Dzgpz+1GQaudHzPNB4BjhlCat7aKi8Mu+r6Q0tpkgkMoiHsNKFoK/EuQmmz6HpXpjSgc+32JYaw==
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

Make this decision only when a VMA scan starts. placement_due is
evaluated for the current task, and a partially scanned VMA is usually
resumed by a different thread, so re-evaluating it for each chunk would
demote in-progress placement scans and starve large VMAs of placement
sampling in multi-threaded processes.

Track the last completed placement scan separately from scans of any
kind. Promotion-only scans still update prev_scan_seq, but do not
advance the placement-starvation horizon.

On a host with 768 GB of DRAM and 256 GB of CXL memory, one large shmem
VMA consumed most scanning activity, while 2,537 other VMAs covering
84 GB were skipped as inactive. One stand-out result: a hot 20 GB hash
table ended up trapped entirely on CXL and drove CXL bandwidth
utilization beyond sustainable levels - resulting in a large regression.

With this series, the hot hash table ends up split evenly between DRAM
and CXL, tier residency tracks runtime load, and CXL bandwidth
utilization drops from 45GB/s (maxed) to 5-10GB/s, while DRAM bandwidth
utilization increases from ~200GB/s to 250GB/s+, resulting in major
throughput improvements for the database workload.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  7 +++++++
 kernel/sched/fair.c      | 31 +++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d0ac21d02c47..86cd12a61755 100644
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
 	/*
 	 * The in-progress scan of this VMA is promotion-only.
 	 * Resumed scans finish with the policy they started with.
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 3b30786ded3b..6002882b9d30 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4105,7 +4105,7 @@ static bool vma_needs_placement_scan(struct mm_struct *mm,
 	 * threads can help scan this vma, force a vma scan.
 	 */
 	if (READ_ONCE(mm->numa_scan_seq) >
-	   (vma->numab_state->prev_scan_seq + get_nr_threads(current)))
+	   (vma->numab_state->prev_placement_scan_seq + get_nr_threads(current)))
 		return true;
 
 	return false;
@@ -4279,7 +4279,8 @@ static void task_numa_work(struct callback_head *work)
 			 * to prevent VMAs being skipped prematurely on the
 			 * first scan:
 			 */
-			 vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_scan_seq = mm->numa_scan_seq - 1;
+			vma->numab_state->prev_placement_scan_seq = mm->numa_scan_seq - 1;
 		}
 
 		/*
@@ -4312,10 +4313,13 @@ static void task_numa_work(struct callback_head *work)
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
@@ -4327,9 +4331,18 @@ static void task_numa_work(struct callback_head *work)
 			}
 		}
 
-		/* Keep scan policy stable while processing a VMA in chunks. */
-		if (scan_started && vma->numab_state->promo_only)
+		/*
+		 * Keep scan policy stable while processing a VMA in chunks.
+		 * placement_due is evaluated for the current task, and a
+		 * different thread will usually resume the scan. Finish an
+		 * in-progress scan with the policy it started with.
+		 */
+		if (scan_started) {
+			if (vma->numab_state->promo_only)
+				placement_scan = false;
+		} else if (tiering && !placement_due) {
 			placement_scan = false;
+		}
 
 		vma->numab_state->promo_only = !placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
@@ -4362,8 +4375,14 @@ static void task_numa_work(struct callback_head *work)
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
 		vma->numab_state->promo_only = false;
 
 		/*
-- 
2.55.0


