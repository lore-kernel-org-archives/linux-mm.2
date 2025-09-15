Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89382CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D58368E0019; Mon, 15 Sep 2025 12:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08F08E0008; Mon, 15 Sep 2025 12:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7EE8E0019; Mon, 15 Sep 2025 12:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB0E38E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:46:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79CCA16067F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:57 +0000 (UTC)
X-FDA: 83892064074.05.BFDF7C9
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id B601E1C0006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Exdjp4HH;
	spf=pass (imf20.hostedemail.com: domain of 3_kLIaAsKCPEdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3_kLIaAsKCPEdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SbJK8pWy0CZE0crqWikRoe+l2baB0Rx7jlgQSj60pLY=;
	b=flC6hQYhN5p8p6Hdmreb6zfs+OlSYV2x8N6nMtZynXQqMi/Q+QqhmdvxWAG0bhiDjZac/o
	dJ0vdEKzxakSPpB3T3lPrlSahR6wSuKaMkGBZhFYrgAbkKekNuJXd+kM+rWf2DKEG6y8yy
	i0NSZO9ZZVy9USqziJiqeITLiLDOkWQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Exdjp4HH;
	spf=pass (imf20.hostedemail.com: domain of 3_kLIaAsKCPEdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3_kLIaAsKCPEdTeXlalbgZaZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954815; a=rsa-sha256;
	cv=none;
	b=4lTgDqrbmhJvOVL+g0tXBFraLQVk9ZPh60sQPLT9M/MHrPtzOP177IgNoAThU/KFL2MWGu
	VCpeB7bpcJ4qa7pgejHN8MOEkBblPrWnnbnApzHV8Zo/YHxjFEG9b48AIhiPxo4gQFt+Qh
	2PbRZpfDmgDKjHQWbQSan6Tv6F9KZic=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-267ac96f558so6421585ad.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954814; x=1758559614; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SbJK8pWy0CZE0crqWikRoe+l2baB0Rx7jlgQSj60pLY=;
        b=Exdjp4HH+gwwNZUWfKmxIpYVerd5RMZviDOMYmoYrkd9K6IYh4atgztSiJOj5/UEJ4
         Vig0rjc9WCuhqt8mwMpp9U9A4zsgYENna/6VVyqAYjR+FeJcdBFfAT7pxSDrl7an6ffO
         3KYoJtA9UicDFVe7jcV4d/6ktzXX+IZF7fC8nDXDLysjWOGD7wHAlEAHVlMTf0Boyam+
         mWsEqsrCOguTrFTBdzmGhG1EVT1MqUBGWOYO7cCur1NApL9jWPSwHRtJqeN4/cNa17fi
         96e3BxSDFC55OkPFzFr8VcoHjFWH8meHaCnHdlpsnjgyeTy9EeYlOwTcWE0fkUXDFc3/
         dAtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954814; x=1758559614;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SbJK8pWy0CZE0crqWikRoe+l2baB0Rx7jlgQSj60pLY=;
        b=jhqrOBjA54UYybf3O9jtunBmS9HutiD9nmIko3M/JKHnk5bOzL3lPpK2EoTvlOCBBR
         HlNiAfLBDkFjiICr+eSQrGOJC5uW1Vi8vGMmQiRBVctmwn19gQlHiABDdVjoTQLOmfpj
         p3boXfsHYvHS7aT46ar99qYU3GeIHc7Ky7jFCUH96AqGKVfMeGNlUHQt1HN3EQaaiZrC
         2E2vEfH9aBQIYC8tCV/hdNyjT+M40VDpAGvV+m9mezEQwLWMczIzDWUD5d2QC0FwTSFs
         qMn6c7Mz90+6SsFaU2is/1bOfPC1KQtTY/6KNLTaFDVWXwVWg5rX2lVxRpKTeJpQeYf7
         azBA==
X-Forwarded-Encrypted: i=1; AJvYcCXp59pPwlxivljwSsLn8DLiLcUUGcEAhbaLZTfkMZPIionwZ9cyvF0DzP6LirhfCqT/2Cq7UD7mGw==@kvack.org
X-Gm-Message-State: AOJu0Yy2KabmN7n38l0ZwiBLr4jEjUcDdHuZaHk/GnTw5aCwUorzasHQ
	syIrVzLhf75dZf8aBrBV6YBV+fEX6feBa4oY0AmMmI+co968yvvJw+PTN1vt54JjUuK1hUg0env
	0f6c4o1u/+YVCPOPNAM1Z4Wb7fw==
X-Google-Smtp-Source: AGHT+IFj2fssKhkti4Yi38ezbH/JI+2/57SQchOc8iv6dsxeJ23DL0meIXHXVVhUOdfHhPdiopD3vNalm3MQQmXFcA==
X-Received: from pleg2.prod.google.com ([2002:a17:902:e382:b0:25d:f53e:e5a4])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b4c:b0:24c:b2a4:7089 with SMTP id d9443c01a7336-25d26077175mr169658175ad.31.1757954814330;
 Mon, 15 Sep 2025 09:46:54 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:36 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-6-kaleshsingh@google.com>
Subject: [PATCH v2 5/7] mm: harden vma_count against direct modification
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
X-Rspamd-Queue-Id: B601E1C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: zdr5jwmgotr9h8pqxsu9pqemmsgfujd4
X-Rspam-User: 
X-HE-Tag: 1757954815-467455
X-HE-Meta: U2FsdGVkX193OTB2UC4UGsbOaoMDSlq7b4O70RBL61YlPhiWe4WR58wc1LjbsK30BbSkDeGkrVFkplzZKUH8YDDCrrqF9gJsJUyW6doLbcLQJuUOM7V4/PKbXGoHvT9/0WgAlBXG4m5+XKmsfkrFbMkhKetrw6VgS4ZcjQHkqewajzZkqixqmPsgWxxlKSlul6QCTBO4ke7ToqW/6ce/e63jFvXdmRYLz2GJ2CZKP9Cwi7ezSpz+7Yuv6CtdtYXq/G6+x2Dz5RY528qltqVqtDHyV+FiOWzz60lhrZghznzqMkFbKWVRrgLClDFxWm/ERYCmbw3L6Z4zi650GkHJ5rDz04b9TUA0faYhajYRAcCZ4kFCvDR/JmNKNJ0JzXev0bCwYz9X1aPgyMcjf56tDkz9zgHo8aVvvgeTTL/96chB/EsfsyfFqBPX7ZeecxoEzz7Xn2DftnOvroovduMVDZf7q9hU+Jgz4bRJHKAxrLLlz72krOUDBf5W7U9BXrl1JgZfoUodwReKdyHqT00VlbUYgW+ZqinQp4OPMFAdPJH2uiRtkDW76dLSGRUTO4/pPJDrnhzlTLRmMPyggl7XM+b/WF2O9n6Hr7wnUVWvL2R2MMFK3c0ccvuyzbB2H7aVj66FVDLojl/ZIqXuM7zUB02jAlFqYSFftvbl5uYZ5b+D+Eg4Q0XAtadKhePWcIeG8o9ysUNugYckoo8btWc02xxCzvAjx/BDbFnsxPGGAEW83WMQttQhb8cF8Rql6F/IUoM5X4b4oXeAiq79/CNj0r434sFSmWlosBp8YQbKkSzA0KFxD9izxv3IzfGMSvPtrCFUq3fxwjy0sfmt5O8j+oe0rpMWRMil6beY1vozIKP5uYgsFgphbw+lp5TrDfO9IN/g2y4rtwUoN+OsaMekC+LD5D6/ZX9hLzUQPHKoDYMMWmy8HJmdacejZznAb497emiPYVNX9HvcY9yIgj1
 3ci19Z+N
 Zcsa+Q8M63fMETyqsQI36XM5u24wNNpBQYH6rHir0piQlP5MiwO2/pz0qeKDvjOYtysytFQ9nOywF+vxdMoBfOm+TLL+9NzdWIxNdDYPpkbycqtBdYaFmvhlPLjfpX2nIxLfGgoeKyeUpQVWFFVSP0fumoh79lyB7IrAVDpM2yIrj5pe+k4hlselYmyaEtde2v8Hq4AUFFmpuRTfybtLnbLn+ywzNlI1hNQyIeYYxtparnXUs/mgLNYLaHn/oQB6+rc6d84qywzQOXiDINfluJ1meJtCBMMNgRhHs8H37+xq4nTmPw4KkpXwnmq/cobUXXoFAZtp+DEyWHx2iDzmYCPIevykko++02jcpcfAPKgOZ8SruuHbjDAdXYq1PCbnB6e7J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To make VMA counting more robust, prevent direct modification of the
mm->vma_count field. This is achieved by making the public-facing
member const via a union and requiring all modifications to go
through a new set of helper functions the operate on a private
__vma_count.

While there are no other invariants tied to vma_count currently, this
structural change improves maintainability; as it creates a single,
centralized point for any future logic, such as adding debug checks
or updating related statistics (in subsequent patches).

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 include/linux/mm.h               | 25 +++++++++++++++++++++++++
 include/linux/mm_types.h         |  5 ++++-
 kernel/fork.c                    |  2 +-
 mm/mmap.c                        |  2 +-
 mm/vma.c                         | 12 ++++++------
 tools/testing/vma/vma.c          |  2 +-
 tools/testing/vma/vma_internal.h | 30 +++++++++++++++++++++++++++++-
 7 files changed, 67 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 138bab2988f8..8bad1454984c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4219,4 +4219,29 @@ static inline bool snapshot_page_is_faithful(const struct page_snapshot *ps)

 void snapshot_page(struct page_snapshot *ps, const struct page *page);

+static inline void vma_count_init(struct mm_struct *mm)
+{
+	ACCESS_PRIVATE(mm, __vma_count) = 0;
+}
+
+static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+{
+	ACCESS_PRIVATE(mm, __vma_count) += nr_vmas;
+}
+
+static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
+{
+	vma_count_add(mm, -nr_vmas);
+}
+
+static inline void vma_count_inc(struct mm_struct *mm)
+{
+	vma_count_add(mm, 1);
+}
+
+static inline void vma_count_dec(struct mm_struct *mm)
+{
+	vma_count_sub(mm, 1);
+}
+
 #endif /* _LINUX_MM_H */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4343be2f9e85..2ea8fc722aa2 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1020,7 +1020,10 @@ struct mm_struct {
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
-		int vma_count;			/* number of VMAs */
+		union {
+			const int vma_count;		/* number of VMAs */
+			int __private __vma_count;
+		};

 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
diff --git a/kernel/fork.c b/kernel/fork.c
index 8fcbbf947579..ea9eff416e51 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1037,7 +1037,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm_pgtables_bytes_init(mm);
-	mm->vma_count = 0;
+	vma_count_init(mm);
 	mm->locked_vm = 0;
 	atomic64_set(&mm->pinned_vm, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
diff --git a/mm/mmap.c b/mm/mmap.c
index c6769394a174..30ddd550197e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1828,7 +1828,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		 */
 		vma_iter_bulk_store(&vmi, tmp);
 
-		mm->vma_count++;
+		vma_count_inc(mm);
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff --git a/mm/vma.c b/mm/vma.c
index 64f4e7c867c3..0cd3cb472220 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -352,7 +352,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		 * (it may either follow vma or precede it).
 		 */
 		vma_iter_store_new(vmi, vp->insert);
-		mm->vma_count++;
+		vma_count_inc(mm);
 	}
 
 	if (vp->anon_vma) {
@@ -383,7 +383,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		}
 		if (vp->remove->anon_vma)
 			anon_vma_merge(vp->vma, vp->remove);
-		mm->vma_count--;
+		vma_count_dec(mm);
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
 			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
@@ -1266,7 +1266,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 	struct mm_struct *mm;
 
 	mm = current->mm;
-	mm->vma_count -= vms->vma_count;
+	vma_count_sub(mm, vms->vma_count);
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
 		mmap_write_downgrade(mm);
@@ -1795,7 +1795,7 @@ int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 	vma_start_write(vma);
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma);
-	mm->vma_count++;
+	vma_count_inc(mm);
 	validate_mm(mm);
 	return 0;
 }
@@ -2495,7 +2495,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
-	map->mm->vma_count++;
+	vma_count_inc(map->mm);
 	vma_link_file(vma);
 
 	/*
@@ -2810,7 +2810,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
-	mm->vma_count++;
+	vma_count_inc(mm);
 	validate_mm(mm);
 out:
 	perf_event_mmap(vma);
diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index 69fa7d14a6c2..ee5a1e2365e0 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -261,7 +261,7 @@ static int cleanup_mm(struct mm_struct *mm, struct vma_iterator *vmi)
 	}
 
 	mtree_destroy(&mm->mm_mt);
-	mm->vma_count = 0;
+	vma_count_init(mm);
 	return count;
 }
 
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 15525b86145d..6e724ba1adf4 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -251,7 +251,10 @@ struct mutex {};
 
 struct mm_struct {
 	struct maple_tree mm_mt;
-	int vma_count;			/* number of VMAs */
+	union {
+		const int vma_count;		/* number of VMAs */
+		int __vma_count;
+	};
 	unsigned long total_vm;	   /* Total pages mapped */
 	unsigned long locked_vm;   /* Pages that have PG_mlocked set */
 	unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
@@ -1526,4 +1529,29 @@ static int vma_count_remaining(const struct mm_struct *mm)
 	return (max_count > vma_count) ? (max_count - vma_count) : 0;
 }
 
+static inline void vma_count_init(struct mm_struct *mm)
+{
+	mm->__vma_count = 0;
+}
+
+static inline void vma_count_add(struct mm_struct *mm, int nr_vmas)
+{
+	mm->__vma_count += nr_vmas;
+}
+
+static inline void vma_count_sub(struct mm_struct *mm, int nr_vmas)
+{
+	vma_count_add(mm, -nr_vmas);
+}
+
+static inline void vma_count_inc(struct mm_struct *mm)
+{
+	vma_count_add(mm, 1);
+}
+
+static inline void vma_count_dec(struct mm_struct *mm)
+{
+	vma_count_sub(mm, 1);
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
-- 
2.51.0.384.g4c02a37b29-goog


