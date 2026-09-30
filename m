Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006D9CA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B3166B0095; Wed, 30 Sep 2026 07:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B5E6B0096; Wed, 30 Sep 2026 07:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079506B0098; Wed, 30 Sep 2026 07:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2ADA6B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D11FA70F2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:21 +0000 (UTC)
X-FDA: 85270190082.29.8C07AE9
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0DF08140002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mrO8UPjh;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fT8gMBRoh6f83banrddk6Bl4fUsBazwJRJAVzyteTg=;
	b=XW+of8fMk6OL+tITO/I2gsB6boB85WGLgsaTLRFznNYtKBmVYE0aKoffq6M5H6l72bLM1O
	cy2LnVx5lzKx/QfkCvsBdmw2Mm79j8nTcpv4q0/CQvQCg2B99Lf/QxfVLmzsSDhopqI1hE
	Fekhxto19vOEi7JTKEHiAkdyY5IbLNw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767339;
	b=AFi81UveLNqsVLXMKQVMvOCkevv1lAsw6ejx3hAMX+n9//WiLajHkWYPQM/OfcGa4HQGRH
	NJqD7ZqOfFbYRaCphvQt9U+7giZk3BmWdogv0iKjeLbcWz6n3J0LJJYB/Cu9QUAHoAMi8x
	7feia2JVZEPw4UQUFLPRimNrZFknj7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mrO8UPjh;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a006bb267eso16792775e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767338; x=1791372138; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7fT8gMBRoh6f83banrddk6Bl4fUsBazwJRJAVzyteTg=;
        b=mrO8UPjhvjjt6ZycmD5N0xD6fbqt1GH2wP+u36BboJsDVt6ggXX+yRMukHRzEbNKGF
         ECw4kvOKWK6KHGRtJYrrure7bYac13ixkFlTEOGNSFA7Afi3+EAhveame5tiGPv86uXR
         pMSUL/6sMfiKS1tEnskP1jZjKddXDvXXYeGNOyonFhKeFVHgHyIqUcgALihRE9uHuw1t
         u3JimN4CVpF6ihSVkyQFKsL2RlQ7qs7jX4BEjWl1yT8sEEGPEXHp1/9mke1BrbFjcLME
         LtR1VgSdkSozWZgfTXqDo/6gUXok997zSAjHtS0UgFJYSlR2NM8YDUv3NOZKcvhZ8FZE
         zBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767338; x=1791372138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7fT8gMBRoh6f83banrddk6Bl4fUsBazwJRJAVzyteTg=;
        b=qiOP0Mp6y0VURE3WWBoDuvFVpEH8/9px5gkAWK1f2L4tWegZ8ENlkiIAh7Ahk+KbOZ
         /F+WD65vjgdqImjk6wyP2+jqQdNHmkR53u/3wajZLcdDKMOOFMqx3or0dgjefsdvwmry
         W01jadQ7huuwVbNKRHi7AbceF5a5npsM9b2gSGEPCHGRnh+vZMlsl7Y5szefTubLbfDN
         OPlEms3qPUzcaHSGXaAqNeRxm1klSMQUEPFN8dlxwdX6IoSk4piZZcBaEwrwlbBANO2I
         x0dzMbOYivvZuV979f0rV2nB03h25joBizpooEOdJu3cFJ4oGFb+ifhgue7mb1NpaOFC
         Htqw==
X-Gm-Message-State: AFuF++nn58Xyd4XQ18lGQz3XI6/xRboGnC+0ZbiNj9NpeBPfIU8JWYdi
	xJPkmwNxlF0gcA1+k6QSUSkc+Ki9B7b5RFxX3Zubs9Jfwuk50KAVSzDqoNJtAHbtLLmftPS/s4/
	nypBwkK/6Yw==
X-Gm-Gg: AYBFou0QhGRbex4puQMI61/AJS8Mv2y0njv3G4ELUpItm+c7/Nrql9/KTwht+Ym7QFZ
	U+lthIDVE8RaCfhtl2PLiTh53BtjsxxwT9LOenA7srP2Xi5/QKfRtap0FohqJk3ZVAlPCWfEfRw
	9Swlo9gl/anLv9yQjxHXfP+mb1kWyauq+oLAapKjRlVmYp4MYi6ko+FkQwrTJES/fx/sI+K/Gzg
	jzUsNMM1huaR/gICZkRCfhv8oEH5f1DxbgUbkzVPuJodaoULzjdRo1olfr1wdywheoOcunPugfc
	JfB1TxNO+HdKgVW0wJthH3D0A8aJ4HHNwwqv9dFu7nX0yk1rn/E1PXvEDrc2akJA5bRkyojYH8B
	R6vdq6NkYjaPmpvsgruRVXZWYvxfmj/Gir3R3Iw38qQIabk5uG2r73yGofB7kj6K5AiKJAvUiTr
	xyruU2xlQ2D106QLfKRu6W9s10x/DqUpWUKGy0dJ5SCRn0wdTaX1jsO5v635P17AmZWk+jRZNWV
	bP4W5jt7W/Lx5R6
X-Received: by 2002:a05:600c:3ba6:b0:4a0:1a7f:2abb with SMTP id 5b1f17b1804b1-4a01addde33mr21170285e9.11.1790767337531;
        Wed, 30 Sep 2026 04:22:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:17 -0700 (PDT)
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
Subject: [PATCH v4 4/7] sched/numa: separate VMA placement from scan continuation
Date: Wed, 30 Sep 2026 07:22:03 -0400
Message-ID: <20260930112206.205083-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yk4pwruqxei8rs1cygjiqx1mx3joyxeg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0DF08140002
X-HE-Tag: 1790767338-645581
X-HE-Meta: U2FsdGVkX1/NL278g09H1QbnmTlRFAun/sfb7JVt5HYCW1ylJCzmWW55MAzlqzhDbHlVGsytXj8ZX71pqD3MXNdkEXknbZ04B7d7xzKXkNeuKnQu6YTM3TCauwNf/2hy5h/FW99XkjsPKXoeDE/30enqqCfsE23Z+LtYiS5660MZLsZNYaYHvVe5J4T6mk81DQiyuAmIrcBS6Xoye3ukMWrWoYkb0HO2CZIQO5v+u5PopqYVWd5/hSoaz2FHvMSfTk0oJJpghiSYp4Eag/CqybmsrdYPx45IEyBtrz8wbkovQ07IthsY/iXKu3TmMQQOMl0vXOjkyHgqGI2SyR2abnJDbORseF8mGvsL9tqDY87VD9Wvkr6wWCcBjb9QpZlRm5yN+jWgShxTiaM+pcwp1qODwBaNinAw5+K5r1FDGIEF5eFDPkixOw1vnjsCu0k5yW9LNzyqsLbLjafx41f/rlbC0LydLlkbuxGu/JyKtS1cxa2Nyw9Fh9TXbQs9wXvAOGaGTmY9O3e1voyzEJqmpAOxNsf3iOYCIgVVX9Dg/8poQariLxUPHFCAE6T40PeFDCtw+GeKDNhxXmSOYW/TsSb33mOAwMzZxj3QtJNAalTea3QhgvOg04Jnc02nG2zsX59RZpKcj0aKJpZcLdkL6CvJNgd+U3a9wM+BEywf8uQZ/kfO5PHTdIOcdTYF4aveDXEiL4L9U7Ea7YowzGNTwQyCEsaO2fwd2UnfLniKsNFU7w0Imwu7ZXfM3ocQSaG7pVXrC2Kqak4QNNg9BGwyFLcHxDJ0AEXSFKuNl33gsNZdfR/wcjGJJkt1rOfLJ/TbNU6UjB8WZZRuMZ+swjlQTajabg1/Hf55Xc+8tYePjMF0n/ZQAeU873U4B1LK8o+w3GVHkaW1BpVd04FiDKTBvfi4R9jo5tDWFQHoXKp48wpujhxJDOvGoq+Ks3H//5S+iQsG2CCnGAhHHcte6CR
 do+/B0SH
 pDL/+Fi+Q6QsT6p+mMkJ2xzGWwK7e35LklWzSIqKGzLr6fgzBz0Mh6EW93g6TPano+Ozlrewnlvoc7uu+014Pt+h8eac00CuetpOOjrLsBWbEYAqFBtPqr68aJYst12facQyq5ITAkc+4dplGauz9Xu/X7g0uJTh4zSMx4NwNl1ezpNUBJloKlfQsknDr3d83c6xX4b6SuKRQGif/5G4RJUgxLx6JB+Ojgs2j/2W5z09Ky2UVqL+b52RyOBM7JI94yTfc9hkxaqRo9M19Cf1iQgpB1QxoEHwMl83LPsh7q/AGEd19++y+OeEEOHIAn4IbvSXAm3Gf66iddlTzxpD1phgJoNnm00EZcqjM1LcbPvFNrfkceQiPOS7sPVzN8dAFlyobyKTLI5v6hz6ULuwUrfvmmQ==
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
state in task_numa_work(). Record whether an in-progress VMA scan is
promotion-only so a scan resumed in a later scan window finishes with
the policy it started with. The zeroed initial state places no
restriction, so a resumed scan that finds freshly allocated NUMAB state
falls back to the default policy.

This separation allows PID-inactive VMAs to be scanned for promotion
without treating scan continuation as evidence of placement eligibility.
It is a prerequisite for the following fix and must accompany it when
backported.

Fixes: fc137c0ddab2 ("sched/numa: enhance vma scanning logic")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mm_types.h |  6 ++++++
 kernel/sched/fair.c      | 40 ++++++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1bd3ca7bfff2..d0ac21d02c47 100644
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
index ab9afd3ad49b..3b30786ded3b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4082,7 +4082,8 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
-static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
+static bool vma_needs_placement_scan(struct mm_struct *mm,
+		struct vm_area_struct *vma)
 {
 	unsigned long pids;
 	/*
@@ -4098,15 +4099,6 @@ static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
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
@@ -4130,6 +4122,7 @@ static void task_numa_work(struct callback_head *work)
 	const unsigned int numab_mode = READ_ONCE(sysctl_numa_balancing_mode);
 	const bool tiering = numab_mode & NUMA_BALANCING_MEMORY_TIERING;
 	const bool balancing = numab_mode & NUMA_BALANCING_NORMAL;
+	bool pid_scan_allowed, placement_due, scan_started;
 	unsigned long migrate, next_scan, now = jiffies;
 	struct task_struct *p = current;
 	struct mm_struct *mm = p->mm;
@@ -4316,15 +4309,29 @@ static void task_numa_work(struct callback_head *work)
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
 
+		/* Keep scan policy stable while processing a VMA in chunks. */
+		if (scan_started && vma->numab_state->promo_only)
+			placement_scan = false;
+
+		vma->numab_state->promo_only = !placement_scan;
 		cp_flags = MM_CP_PROT_NUMA;
 		if (!placement_scan)
 			cp_flags |= MM_CP_PROT_NUMA_PROMO_ONLY;
@@ -4357,6 +4364,7 @@ static void task_numa_work(struct callback_head *work)
 
 		/* VMA scan is complete, do not scan until next sequence. */
 		vma->numab_state->prev_scan_seq = mm->numa_scan_seq;
+		vma->numab_state->promo_only = false;
 
 		/*
 		 * Only force scan within one VMA at a time, to limit the
-- 
2.55.0


