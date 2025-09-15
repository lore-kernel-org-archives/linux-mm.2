Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF986CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 458868E001A; Mon, 15 Sep 2025 12:47:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4091B8E0008; Mon, 15 Sep 2025 12:47:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3464C8E001A; Mon, 15 Sep 2025 12:47:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 237A88E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:47:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC2A9BA94C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:47:12 +0000 (UTC)
X-FDA: 83892064704.04.AC93158
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1217980009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:47:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3E8/zr/+";
	spf=pass (imf02.hostedemail.com: domain of 3DUPIaAsKCAImcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3DUPIaAsKCAImcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKwpABqpohuFqzMZ59NYGHVdaV3v0Z5awKHv0UgL8Ps=;
	b=bCzuibaOa66MZTXDlB0czqXDmzKwW1IhsVhBrHAWCPvj5eThQAT1odpG9Es+v1mAG/nffN
	DnWvhgr6KosPdVxovRDOspdoKulx+6o6d2kdhdy/OXUqE3ggReAV7uIDmXe5ah7dFMboo1
	txUBp1KeW0a9wDJlrC9oyoiRnsHeEq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954831; a=rsa-sha256;
	cv=none;
	b=WTb7x06upQCTptaek8+BYEtUsM3QkrNFSnWJ0k3gk3TSoL4z6zzN9yIFVfbN4YzPBAXkDg
	YmpWM7qV+cffqJ86yG7k9xo4yqRkrXM57WXyoSHc4VSEpHGBM9Ompy5WvpupDkH9cI8hTC
	/CpIMbo2J2LcmtJPaAFbN3bi2GWCU8U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3E8/zr/+";
	spf=pass (imf02.hostedemail.com: domain of 3DUPIaAsKCAImcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3DUPIaAsKCAImcngujukpijiqqing.eqonkpwz-oomxcem.qti@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2675d9ad876so12330135ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954830; x=1758559630; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hKwpABqpohuFqzMZ59NYGHVdaV3v0Z5awKHv0UgL8Ps=;
        b=3E8/zr/+jERv4LS0r3NWNv9Wt5t9g2AN34KrnQNngbkGmOoZ5tZBtheNXmn/yty9b2
         gnldH++D/e0p7i7pMZQ4jZqv/P72I9onzeinVGpgLuKZyLZ1+R0UuW1rsdPvROWypJRn
         DPFf6sgStJPpFEoU9Aqs7pja+YLkFg/9D0R/aHA6DxYCAeaFKv9jgs3s0j8YALUPk3RX
         LgLnDTqyrh7Uh6TcpT2DH1Y/aPPwdOvSOqw7wXrYnjEIDRN7l89YRT+zfdOwrB2i4v68
         w9GU562stZIMCnM4F4RuvXL1c/s97RVNhotI5dykmZT6wEtyB77K7M95XcbshtwREGd3
         +J+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954830; x=1758559630;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hKwpABqpohuFqzMZ59NYGHVdaV3v0Z5awKHv0UgL8Ps=;
        b=LO8dNZzEuF9YG6lj++/k9ysb0n3RStGuWyR6zAFA/sE7TOq/LvFxkEyzH/Lqu3VHTE
         EVw2HMN0hnQ4ax8o+DIPzGNueoK4W+xR44BjrP2+TPq4HU1STASPf6L12mcvnZYSU8jS
         oXrOL0wZpUYVS+UeYQ9PLtauTSCSi5LywxARab8Eeqh4p83uUJlfSufn2m9UGYCts5H+
         5T/hvrmYvr3X8ZNHXX3KjJOqma0D/6OEz5g4XVp1sj5bOQd1wljwVMFhkcrKlDl5lwxF
         WPkX9Z6jZ4r06MDe/oTTtO18yBhvQDInb0W4rz+lqUw6CnGRpS4lkvzu1MqExvnJtq+G
         9e/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoIsg7X8eimA+RmDP8JkBnYKMKQq8wKXif0IJ00l67fERaF/GGX+V1eC42mOkFrhuTeagwK5HNuw==@kvack.org
X-Gm-Message-State: AOJu0YzDE0mGCK10HnUoKBa/JssQ9rgGxsJ+LN/ganIdLPEi68gOoGZF
	GO7EjUVfnOS8xighyq5z3ie6r2A8DNcNhwiJeW7ffTsCiiTQxZt5w1CvHFOTdDeanDSOCy5ImG4
	XkVxJuCV60XiB0HHCIjOLkoYPVw==
X-Google-Smtp-Source: AGHT+IHxs26EIdlIXz631Uz365/CGN6f9O6Xm7lLrsiaFhIbp7CDzVSSsE3TgFf9kclQMXvcquwmL00++yYPRtwtYA==
X-Received: from plbnb15.prod.google.com ([2002:a17:903:15cf:b0:24c:af07:f077])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2448:b0:267:a55a:8684 with SMTP id d9443c01a7336-267a55a8724mr34282065ad.2.1757954829980;
 Mon, 15 Sep 2025 09:47:09 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:37 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-7-kaleshsingh@google.com>
Subject: [PATCH v2 6/7] mm: add assertion for VMA count limit
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1217980009
X-Stat-Signature: dy94q7q1f3nssxwaiysqzx6c5ejo8pnu
X-Rspam-User: 
X-HE-Tag: 1757954830-477849
X-HE-Meta: U2FsdGVkX1+CsUehJkOylQuUN+Zxb/VqP29oNA+K08ZBv7PpwTyc+oW4gdIa5RzcUysFaX/sa9uoFzrcvH4tom6ECiiF86iQ0evgMULpLESbOkzCIZn2WKXXrfZ53FSUCGcc1O3ttABMurja3nUMGBiW3XrkMeCapvJ7ZalyLtD3LLssO1LwlBCtBX0W3cc68Haii84kjD9P09noFKjJsAIPjcTkfVtd0T+a8lN898S9luqjTl0WtIXeWHmQFPIi9T+EN1VAfYK+Ufu9H/cbkafDlX7hTeoPEEtSH0vAZEdHE4MVMGgp8haOqBZrdP4Ra5kxskcENxOohYoSsechOejSnsSINpad3o/J90JIKFnkOUH4I0AiEKTv6Yw/VCeI1HuZmtMUsRnKKPUV9ULR6hE6w63RRtNKsNLTfzU86pudVzcypTvjk98KcwTxNzN528qtxGEPNKmw2biVL6CsXf6cPlSEz6U+l+Z5g2pTnsv3G6achzZUBbD13WdGBg/sRJYIAUtNGkFSMkWUZKkKeRPU8NaeHhqMlhd2NNohFzQZvuF9iP94eFMppGQiM39JvhXRaaaKsq86F10BhLDXv7SFD4uP+HrKVFJv8N7x6wUjYevoH/O++6Na5O721RaIUI1xvkgjgkfljSICo1Fo6HLxYUgnAUf/Pao4piLJ1mJEjJRdkix0ohxdGVlNAh6nl9Sk90hUmB01ruuzCdtmDspdJQkVcIqIL3RB+vO3MuxHxfXKwAahO+roHCeQLoJs42HJICtE6/86ktJlVjSpMybBdmDbSJZoNGd4BRqbZhHygOPAfbmEoEOUWkmly4OiajHKGPELI1MDW1/Q0YPhymDuyrdT2/x0ICaE8Ed2tVJ839QC1LJaTrif2vk/9OLHb4N7WrDRkzFxqG1mKoAo21X5QPPsgEkijWvvs4PQutG2bAZrv2xDb9KcZpZek8bOXLM1qF+lCFTA3MLNGL0
 LyjJSqmr
 wBZxMEoTRSNpaTsnN3F/HJ+aqkK5R804YFAmr6enROy2yyQ0MHEHnvcOf2n18YRGaAg/DY/L+8IXM4xs7C6mzXCB3Lzm1l4bMunGw5+OcWJj4U9VhK5f3ksRcUqI59TqEx6GPcVwh9r0ALTp3bf7Id/WNMW+6+qsEo1B6ldCY8P8tWFR/e4iilwu4Ja3NEKo14SlvyGVQfFZIE4U9VnbE83EuQhlNAbGSAD3VlBqdJrpApXGaS18EUU1VQbJYeFn53lvKsD/MqwWRwMMSxRflr/eNG9bs+9uYZPTmWh9q3k1t1E2uuQiBGGno2ovgb9PiuQD7r3tbApojJtlqGYgrxWDwI5Lh5pFx5agL3bq2fjzs6SsKr8KTVIotjFP64gXcWrpbHEdaeOOU8EyBkMtuJzp+73D+qjcfwhSY3Dyp7axLPAO63IHAUUFQ6ot1D3Eudrz1PivsE/Ntx1Ew6gG9xF2qD6lWt76ILQB8CwZMlxKT+ZiKPWB69BqBrYMAHqIhFtX/HtN2F8ExL/5vGXRR7vK9aAYAHU7W5++5csvH2vr2aSdepivsMclYFZkVeWwjIAW8GLudst6smXvOk3k3B5tBJOmxI15TYN6a7vKRV3dYOvl/ygHuUr0MeW75QmIFI+h5RLPKpRrL5A3WmRQNNAU5G7KYP7hR+zxVyWGrFkDDMWFos4fgdYZJoyvpbwSb0EZMfYRLjb5TAzrH2U/skcbFi2p88F75TfhUL8uhG9EuN6SjjMCYCh6Z4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Building on the vma_count helpers, add a VM_WARN_ON_ONCE() to detect
cases where the VMA count exceeds the sysctl_max_map_count limit.

This check will help catch future bugs or regressions where
the VMAs are allocated exceeding the limit.

The warning is placed in the main vma_count_*() helpers, while the
internal *_nocheck variants bypass it. _nocheck helpers are used to
ensure that the assertion does not trigger a false positive in
the legitimate case of a temporary VMA increase past the limit
by a VMA split in munmap().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
  - Add assertions if exceeding max_vma_count limit, per Pedro

 include/linux/mm.h               | 12 ++++++--
 mm/internal.h                    |  1 -
 mm/vma.c                         | 49 +++++++++++++++++++++++++-------
 tools/testing/vma/vma_internal.h |  7 ++++-
 4 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8bad1454984c..3a3749d7015c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4219,19 +4219,27 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)
 
 void snapshot_page(struct page_snapshot *ps, const struct page *page);
 
+int vma_count_remaining(const struct mm_struct *mm);
+
 static inline void vma_count_init(struct mm_struct *mm)
 {
 	ACCESS_PRIVATE(mm, __vma_count) = 0;
 }
 
-static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+static inline void __vma_count_add_nocheck(struct mm_struct *mm, int nr_vmas)
 {
 	ACCESS_PRIVATE(mm, __vma_count) += nr_vmas;
 }
 
+static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+{
+	VM_WARN_ON_ONCE(!vma_count_remaining(mm));
+	__vma_count_add_nocheck(mm, nr_vmas);
+}
+
 static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
 {
-	vma_count_add(mm, -nr_vmas);
+	__vma_count_add_nocheck(mm, -nr_vmas);
 }
 
 static inline void vma_count_inc(struct mm_struct *mm)
diff --git a/mm/internal.h b/mm/internal.h
index 39f1c9535ae5..e0567a3b64fa 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1661,6 +1661,5 @@ static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
-int vma_count_remaining(const struct mm_struct *mm);
 
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/vma.c b/mm/vma.c
index 0cd3cb472220..0e4fcaebe209 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -323,15 +323,17 @@ static void vma_prepare(struct vma_prepare *vp)
 }
 
 /*
- * vma_complete- Helper function for handling the unlocking after altering VMAs,
- * or for inserting a VMA.
+ * This is the internal, unsafe version of vma_complete(). Unlike its
+ * wrapper, this function bypasses runtime checks for VMA count limits by
+ * using the _nocheck vma_count* helpers.
  *
- * @vp: The vma_prepare struct
- * @vmi: The vma iterator
- * @mm: The mm_struct
+ * Its use is restricted to __split_vma() where the VMA count can be
+ * temporarily higher than the sysctl_max_map_count limit.
+ *
+ * All other callers must use vma_complete().
  */
-static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
-			 struct mm_struct *mm)
+static void __vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
+			   struct mm_struct *mm)
 {
 	if (vp->file) {
 		if (vp->adj_next)
@@ -352,7 +354,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		 * (it may either follow vma or precede it).
 		 */
 		vma_iter_store_new(vmi, vp->insert);
-		vma_count_inc(mm);
+		/*
+		 * Explicitly allow vma_count to exceed the threshold to prevent,
+		 * blocking munmap() freeing resources.
+		 */
+		__vma_count_add_nocheck(mm, 1);
 	}
 
 	if (vp->anon_vma) {
@@ -403,6 +409,26 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		uprobe_mmap(vp->insert);
 }
 
+/*
+ * vma_complete- Helper function for handling the unlocking after altering VMAs,
+ * or for inserting a VMA.
+ *
+ * @vp: The vma_prepare struct
+ * @vmi: The vma iterator
+ * @mm: The mm_struct
+ */
+static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
+			 struct mm_struct *mm)
+{
+	/*
+	 * __vma_complete() explicitly foregoes checking the new
+	 * vma_count against the sysctl_max_map_count limit, so
+	 * do it here.
+	 */
+	VM_WARN_ON_ONCE(!vma_count_remaining(mm));
+	__vma_complete(vp, vmi, mm);
+}
+
 /*
  * init_vma_prep() - Initializer wrapper for vma_prepare struct
  * @vp: The vma_prepare struct
@@ -564,8 +590,11 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		vma->vm_end = addr;
 	}
 
-	/* vma_complete stores the new vma */
-	vma_complete(&vp, vmi, vma->vm_mm);
+	/*
+	 * __vma_complete stores the new vma without checking against the
+	 * sysctl_max_map_count (vma_count) limit.
+	 */
+	__vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);

 	/* Success. */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 6e724ba1adf4..d084b1eb2a5c 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1534,11 +1534,16 @@ static inline void vma_count_init(struct mm_struct *mm)
 	mm->__vma_count = 0;
 }

-static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+static inline void __vma_count_add_nocheck(struct mm_struct *mm, int nr_vmas)
 {
 	mm->__vma_count += nr_vmas;
 }

+static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+{
+	__vma_count_add_nocheck(mm, nr_vmas);
+}
+
 static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
 {
 	vma_count_add(mm, -nr_vmas);
-- 
2.51.0.384.g4c02a37b29-goog


