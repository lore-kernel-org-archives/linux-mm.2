Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A81CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD708E00B3; Mon, 13 Oct 2025 19:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E008E0024; Mon, 13 Oct 2025 19:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D35BB8E00B3; Mon, 13 Oct 2025 19:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B96A08E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:56:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8071B1DFFCD
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:23 +0000 (UTC)
X-FDA: 83994752646.01.3622B68
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD58640004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyfBBqsJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3pJHtaAsKCMs1r2v9y9z4xyx55x2v.t532z4BE-331Crt1.58x@flex--kaleshsingh.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3pJHtaAsKCMs1r2v9y9z4xyx55x2v.t532z4BE-331Crt1.58x@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399781; a=rsa-sha256;
	cv=none;
	b=gFfFHB7m32lHOyviZ2gZnQlOZ4+3FlWq7JyWqTOi5NBAXkDWdOgD72z9Bizqma711vgfsB
	bxMQubtV9JvVFhIdRExQSDMf8sY0D1MWtW3QYEM/E3704NAVQqsYE8htcUvolegYIOH5K7
	elXQmO3UX2sIAmNq2wEsHvyY5oHDNI8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LyfBBqsJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3pJHtaAsKCMs1r2v9y9z4xyx55x2v.t532z4BE-331Crt1.58x@flex--kaleshsingh.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3pJHtaAsKCMs1r2v9y9z4xyx55x2v.t532z4BE-331Crt1.58x@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfyNCZtwA/KBestiCQmuIFg3B48jf9OXth0tohHfRYY=;
	b=McaSX6UNYYyQ/S3rSKtLgrZSTVebn2zDv8QK/62gox9f23OF/R5QN0eN2U5mnuyQOuRsKO
	tSrGQBRS4zSNn6Gl5bKQof2srDzR2tYB1Ry0WEBV15HXf/bB5PadKXHGFcroxwvEALtICN
	5p6Rgooo9PCRBjcO3DdwihId3vTzTa8=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2698b5fbe5bso111584095ad.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399780; x=1761004580; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DfyNCZtwA/KBestiCQmuIFg3B48jf9OXth0tohHfRYY=;
        b=LyfBBqsJe2ZbrqXt30Yyxu8KE2KeQOiYStvDh/YRSa72wI6g3yyoEhSgJ8MkaRDmi1
         8IxzxrWMNeLbN75Lmk6d4tOtPUvAGggOxwiPQk1gFx33dMtAFoj6WjjG3feFKp55TMKw
         Y3EdBm7WlK0+9QW9e2MzOqsN+EFp0jmSbNuW/6iQk8QxDeSaAE9w6EbDDr2OtSHM1zgo
         7TB0DlKx/g/reG3pBh50U5eLLq0uoWKxYuHVF7PMT5O3l+0ZuG0lv/so5h+4GDqSj/6S
         qaZiYqgcP5RzHHnChNCYuYk2fwyxpIA6ceHB434aKm19iOXCj9TXY6ep/G4Kdtxex/lc
         PZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399780; x=1761004580;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DfyNCZtwA/KBestiCQmuIFg3B48jf9OXth0tohHfRYY=;
        b=Ow1YlrPjjxzH3tVnu9SR5gexygEXuPnteZWLb7levGxckoZcaj9Yx0/ezpNnl7T5/S
         RmDrHtO/jnjTah7C3Ssr9HyBe9mUa1VULU+b9SXQdUnTnSw0SZsxoq+ByritUYiVTO8N
         UqcJmCBzTtEGfIKKmVYmXPRrpVbp8DJGtFSfgGF38EZy4FXHwmx1YetKUFvZOSFen44Y
         y1itwyK2VltKKqFXQSlgY4otT2ab/P5eyZYEJ9q19D9BjirwvTJeR8dkrrYgUAJfhVvw
         qb85g0EtcfFWplRdzadCsIqzJ6Ui1GKmsnCISVkZ2yKtLr2wzAaI2smXf+kJz6TQDYk4
         YJKg==
X-Forwarded-Encrypted: i=1; AJvYcCUTn1tPRR+1/Atp+L1iYccwno8TFlTtdCklRO+vuv8RvFtvsJohfjaCXFIZV2+smn0E7ebtvC8FsQ==@kvack.org
X-Gm-Message-State: AOJu0Yy41p8/FHJUE6krPr1uWC36SYhnawVZMXMXvu/1H+3BCWS3BIHP
	LiVKXJvYpXa7fi2L257yZaOCm6PyJUgAQg5IR05/6eTQ6FDnLxpV7jQOW02G5FAas5loMxmPsqM
	e37ugH/G1L1vpS9+jnVif9/ztqQ==
X-Google-Smtp-Source: AGHT+IG1eNGVa95/QxhVANFx3qZmjnkLDPa9MUnbtzy/TBkioj/4LaNLCxwSAjNYNO/fURaI2PCcXgwYg4e6udk1Bw==
X-Received: from plrr19.prod.google.com ([2002:a17:902:c613:b0:269:8006:8526])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2350:b0:274:aab9:4ed4 with SMTP id d9443c01a7336-29027312ffamr275585885ad.57.1760399780569;
 Mon, 13 Oct 2025 16:56:20 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:55 -0700
In-Reply-To: <20251013235259.589015-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-5-kaleshsingh@google.com>
Subject: [PATCH v3 4/5] mm: rename mm_struct::map_count to vma_count
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD58640004
X-Stat-Signature: oho3o5szmycah47maeoumfphed9i3mmo
X-HE-Tag: 1760399781-171306
X-HE-Meta: U2FsdGVkX18kjB95SS6BHXYHPd8LB3Sl57b3Ax95Uu9RcJnqI1S0wSYTKJ2O0j2V8oboGKt8SDXbsw8vs8iBrwNCnLZEAg8IFvq5pOYXGFrSSXV4dpwu0xqdhrpMbojUy9WwcRSa+jOKAD0zcSbesI0anmStB/CJDtVLPRcu3/7xrPxy8QyckKnL7b4n2Ld8tKfxOwYD1ZxS2bA2hqqfGlLdCsw1ixipxm3CXo9I4oxEs6t9/Q857mIzx25c8dRIPtP+cQZGVBEt5ygF8qc2nNTPQJJaJiVxeQGOGlAxOWMEVokoYkpO0XCDQgLv4hZnpnAdsoI5CmtAL+QQsri322oPtpgeqNl52xvL0qByv+ZfHil8pvjqI/CLszClpBNWNSeR4p5fyoFGJZYdQ/TUWLN0Snn/5Fy9PuIuNOHg4v7+4YZqJp/UKQewE8RJSp8unJXFwJImmfIX9d0klTHCyPMCgmn0wlz61tyarlCYuxniqEdoweMDciqSGnRq+Lqv0huvC+MhwBUYy9v+nKdpAQ5Ls1LeicKRNX8yMrTZ/0dVjyPd66jgXRJGBbwEOveTWvl0lVSC6lyUqrvcrIuK4S7u8YueSdGKWpUvxqg8KS31QYJhriUB9bUhrfls4NesUn/9jmeyU9PDTx+vTnQovXYJgufNDxNg3Pwe0AEjfiPLmh4diAC4/Wa7omjheEnTBg0X82qBgLsnDdiCg4qNdmnHtEF2D3NKbSGt/psLvTDFxzpo1Lut8kC/YQ1D3b1aIXq/ldM9PBCDwTwv0xibhkpMajcxcXkHw9qXuYmjDIv5E9p6st6qPaHm1WoPxuudZmI8UatdUsH8vuVz1Wxfn6GRDkIMDWLe42KINRrZ6hrEihEz/RQyqjgozO3UjHSfD5/dQWH8MM+Jnzwb1Hv8qZxDbGBv7Tdi/EsoDntzjdz6kbdGISsET/OwlRPyH+OdkZjLVcfLSLWv40hgTHH
 gtwLU17V
 XShsKX7hZGHakKhKD5we5ERekKb/IF0nQVakE0Qtc6qGnSj9GCuLnOv/6KCGtIwXMutA+ygNA+fm8Lb7d7SzPT1gFaC5XezPZ8dgsx9c7j5bydPdGzCEejLecT5UmUtWWoO8OXURLU9NXZvUNS3mhuANQdSftVEy8YUomLVMscDDSTMEbi0bPcw61wU8BRv8jWbp/tw4XB0Cw2/TuDM9yRTtSKwx9d3JPyIm1CwOqdl8+MMGZt8gia0oPePv29i1d4l+JLmXA2rEr/ulH0Qu8hkcYzDNixUvORTknuD0i96r3qSXI4FnQJymXDuCOnSQ34r6Nsi8LADo2pd82UsgXUQc5iN8nUycN8gNRIH/rm//dOvcHDHMZft1bw7CLgRva9ISaDVgo9QGbyU/pC75QOggClCivsi4BrJjVwfviTHWQqyfQEJQiTrA7F2SOi1v6jeUwveyZDIpdlpEdGDl625LOAtLkfN9cuqDlXs3d843CCmk571O0o5uKG7xj9l++v4JRkaVGllpS3H9r05QR+oB/EpMs/JkeDEcMWWF+lDUsUv77zRd5VsYzTjSsFNPHKwhMZolTpeYYgCA4/pmXDjet0pnw8xrFP8cWterm9SiRU1wWn4rBRg6fDFbPbrWmf/hHDKQk75mFXLqp5Rhu9dsWH089BoUZfEYRmQbCdBxc44mPWdlcD841pbfU2rLe2em8g7kRXhhkXEryUabWz6YromJ6QXQrK6zEifROMZLM4FA4Cq/em/DnV5/MAe4g3XPlLCbFlOUUKaTeVJ6bnGctfA+HbG6O48zk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A mechanical rename of the mm_struct->map_count.

While at it update the vma_count BUG_ON() in exit_mmap() to a
WARN_ON_ONCE; no other functional change is intended.

The name "map_count" is ambiguous within the memory management subsystem,
as it can be confused with the folio/page->_mapcount field, which tracks
PTE references.

The new name, vma_count, is more precise as this field has always
counted the number of vm_area_structs associated with an mm_struct.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

---

Changes in v3:
  - Change vma_count BUG_ON() in exit_mmap() to WARN_ON_ONCE,
    per David and Lorenzo
  - Collect Reviewed-by tags

 fs/binfmt_elf.c                  |  2 +-
 fs/coredump.c                    |  2 +-
 include/linux/mm_types.h         |  2 +-
 kernel/fork.c                    |  2 +-
 mm/debug.c                       |  2 +-
 mm/mmap.c                        | 10 +++++-----
 mm/nommu.c                       |  6 +++---
 mm/vma.c                         | 24 ++++++++++++------------
 tools/testing/vma/vma.c          | 32 ++++++++++++++++----------------
 tools/testing/vma/vma_internal.h |  6 +++---
 10 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index e4653bb99946..a5acfe97612d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1660,7 +1660,7 @@ static int fill_files_note(struct memelfnote *note, struct coredump_params *cprm
 	data[0] = count;
 	data[1] = PAGE_SIZE;
 	/*
-	 * Count usually is less than mm->map_count,
+	 * Count usually is less than mm->vma_count,
 	 * we need to move filenames down.
 	 */
 	n = cprm->vma_count - count;
diff --git a/fs/coredump.c b/fs/coredump.c
index b5fc06a092a4..5e0859813141 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -1733,7 +1733,7 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
 
 	cprm->vma_data_size = 0;
 	gate_vma = get_gate_vma(mm);
-	cprm->vma_count = mm->map_count + (gate_vma ? 1 : 0);
+	cprm->vma_count = mm->vma_count + (gate_vma ? 1 : 0);
 
 	cprm->vma_meta = kvmalloc_array(cprm->vma_count, sizeof(*cprm->vma_meta), GFP_KERNEL);
 	if (!cprm->vma_meta) {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 4e5d59997e4a..97e0541cd415 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1078,7 +1078,7 @@ struct mm_struct {
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
-		int map_count;			/* number of VMAs */
+		int vma_count;			/* number of VMAs */
 
 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..c8d59042b34f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1038,7 +1038,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mmap_init_lock(mm);
 	INIT_LIST_HEAD(&mm->mmlist);
 	mm_pgtables_bytes_init(mm);
-	mm->map_count = 0;
+	mm->vma_count = 0;
 	mm->locked_vm = 0;
 	atomic64_set(&mm->pinned_vm, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
diff --git a/mm/debug.c b/mm/debug.c
index 64ddb0c4b4be..a35e2912ae53 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -204,7 +204,7 @@ void dump_mm(const struct mm_struct *mm)
 		mm->pgd, atomic_read(&mm->mm_users),
 		atomic_read(&mm->mm_count),
 		mm_pgtables_bytes(mm),
-		mm->map_count,
+		mm->vma_count,
 		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
 		(u64)atomic64_read(&mm->pinned_vm),
 		mm->data_vm, mm->exec_vm, mm->stack_vm,
diff --git a/mm/mmap.c b/mm/mmap.c
index d9ea029cd018..b4eda47b88d8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1305,7 +1305,7 @@ void exit_mmap(struct mm_struct *mm)
 		vma = vma_next(&vmi);
 	} while (vma && likely(!xa_is_zero(vma)));
 
-	BUG_ON(count != mm->map_count);
+	WARN_ON_ONCE(count != mm->vma_count);
 
 	trace_exit_mmap(mm);
 destroy:
@@ -1508,13 +1508,13 @@ static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
  */
 int vma_count_remaining(const struct mm_struct *mm)
 {
-	const int map_count = mm->map_count;
+	const int vma_count = mm->vma_count;
 	const int max_count = READ_ONCE(sysctl_max_map_count);
 
-	if (map_count >= max_count)
+	if (vma_count >= max_count)
 		return 0;
 
-	return max_count - map_count;
+	return max_count - vma_count;
 }
 
 #ifdef CONFIG_SYSCTL
@@ -1828,7 +1828,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		 */
 		vma_iter_bulk_store(&vmi, tmp);
 
-		mm->map_count++;
+		mm->vma_count++;
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff --git a/mm/nommu.c b/mm/nommu.c
index 22e55e7c69c4..b375d3e00d0c 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -577,7 +577,7 @@ static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
 
 static void cleanup_vma_from_mm(struct vm_area_struct *vma)
 {
-	vma->vm_mm->map_count--;
+	vma->vm_mm->vma_count--;
 	/* remove the VMA from the mapping */
 	if (vma->vm_file) {
 		struct address_space *mapping;
@@ -1199,7 +1199,7 @@ unsigned long do_mmap(struct file *file,
 		goto error_just_free;
 
 	setup_vma_to_mm(vma, current->mm);
-	current->mm->map_count++;
+	current->mm->vma_count++;
 	/* add the VMA to the tree */
 	vma_iter_store_new(&vmi, vma);
 
@@ -1367,7 +1367,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
 	vma_iter_store_new(vmi, new);
-	mm->map_count++;
+	mm->vma_count++;
 	return 0;
 
 err_vmi_preallocate:
diff --git a/mm/vma.c b/mm/vma.c
index 96ba37721002..b35a4607cde4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -352,7 +352,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		 * (it may either follow vma or precede it).
 		 */
 		vma_iter_store_new(vmi, vp->insert);
-		mm->map_count++;
+		mm->vma_count++;
 	}
 
 	if (vp->anon_vma) {
@@ -383,7 +383,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		}
 		if (vp->remove->anon_vma)
 			anon_vma_merge(vp->vma, vp->remove);
-		mm->map_count--;
+		mm->vma_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
 			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
@@ -683,13 +683,13 @@ void validate_mm(struct mm_struct *mm)
 		}
 #endif
 		/* Check for a infinite loop */
-		if (++i > mm->map_count + 10) {
+		if (++i > mm->vma_count + 10) {
 			i = -1;
 			break;
 		}
 	}
-	if (i != mm->map_count) {
-		pr_emerg("map_count %d vma iterator %d\n", mm->map_count, i);
+	if (i != mm->vma_count) {
+		pr_emerg("vma_count %d vma iterator %d\n", mm->vma_count, i);
 		bug = 1;
 	}
 	VM_BUG_ON_MM(bug, mm);
@@ -1266,7 +1266,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 	struct mm_struct *mm;
 
 	mm = current->mm;
-	mm->map_count -= vms->vma_count;
+	mm->vma_count -= vms->vma_count;
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
 		mmap_write_downgrade(mm);
@@ -1340,14 +1340,14 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 	if (vms->start > vms->vma->vm_start) {
 
 		/*
-		 * Make sure that map_count on return from munmap() will
+		 * Make sure that vma_count on return from munmap() will
 		 * not exceed its limit; but let map_count go just above
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
 		    !vma_count_remaining(vms->vma->vm_mm)) {
 			error = -ENOMEM;
-			goto map_count_exceeded;
+			goto vma_count_exceeded;
 		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
@@ -1461,7 +1461,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 modify_vma_failed:
 	reattach_vmas(mas_detach);
 start_split_failed:
-map_count_exceeded:
+vma_count_exceeded:
 	return error;
 }
 
@@ -1795,7 +1795,7 @@ int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 	vma_start_write(vma);
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma);
-	mm->map_count++;
+	mm->vma_count++;
 	validate_mm(mm);
 	return 0;
 }
@@ -2512,7 +2512,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
-	map->mm->map_count++;
+	map->mm->vma_count++;
 	vma_link_file(vma);
 
 	/*
@@ -2835,7 +2835,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
-	mm->map_count++;
+	mm->vma_count++;
 	validate_mm(mm);
 out:
 	perf_event_mmap(vma);
diff --git a/tools/testing/vma/vma.c b/tools/testing/vma/vma.c
index 656e1c75b711..69fa7d14a6c2 100644
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -261,7 +261,7 @@ static int cleanup_mm(struct mm_struct *mm, struct vma_iterator *vmi)
 	}
 
 	mtree_destroy(&mm->mm_mt);
-	mm->map_count = 0;
+	mm->vma_count = 0;
 	return count;
 }
 
@@ -500,7 +500,7 @@ static bool test_merge_new(void)
 	INIT_LIST_HEAD(&vma_d->anon_vma_chain);
 	list_add(&dummy_anon_vma_chain_d.same_vma, &vma_d->anon_vma_chain);
 	ASSERT_FALSE(merged);
-	ASSERT_EQ(mm.map_count, 4);
+	ASSERT_EQ(mm.vma_count, 4);
 
 	/*
 	 * Merge BOTH sides.
@@ -519,7 +519,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 3);
+	ASSERT_EQ(mm.vma_count, 3);
 
 	/*
 	 * Merge to PREVIOUS VMA.
@@ -536,7 +536,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 3);
+	ASSERT_EQ(mm.vma_count, 3);
 
 	/*
 	 * Merge to NEXT VMA.
@@ -555,7 +555,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 3);
+	ASSERT_EQ(mm.vma_count, 3);
 
 	/*
 	 * Merge BOTH sides.
@@ -573,7 +573,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	/*
 	 * Merge to NEXT VMA.
@@ -591,7 +591,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	/*
 	 * Merge BOTH sides.
@@ -608,7 +608,7 @@ static bool test_merge_new(void)
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 1);
+	ASSERT_EQ(mm.vma_count, 1);
 
 	/*
 	 * Final state.
@@ -967,7 +967,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	cleanup_mm(&mm, &vmi);
 	return true;
@@ -1017,7 +1017,7 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma->vm_pgoff, 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1045,7 +1045,7 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_next->vm_pgoff, 2);
 	ASSERT_EQ(vma_next->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_next));
-	ASSERT_EQ(mm.map_count, 1);
+	ASSERT_EQ(mm.vma_count, 1);
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1079,7 +1079,7 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma->vm_pgoff, 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	/* Clear down and reset. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 2);
@@ -1108,7 +1108,7 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->vm_pgoff, 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
-	ASSERT_EQ(mm.map_count, 1);
+	ASSERT_EQ(mm.vma_count, 1);
 
 	/* Clear down and reset. We should have deleted vma. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1138,7 +1138,7 @@ static bool test_merge_existing(void)
 	ASSERT_EQ(vma_prev->vm_pgoff, 0);
 	ASSERT_EQ(vma_prev->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma_prev));
-	ASSERT_EQ(mm.map_count, 1);
+	ASSERT_EQ(mm.vma_count, 1);
 
 	/* Clear down and reset. We should have deleted prev and next. */
 	ASSERT_EQ(cleanup_mm(&mm, &vmi), 1);
@@ -1540,7 +1540,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma->vm_pgoff, 0);
 	ASSERT_TRUE(vma_write_started(vma));
-	ASSERT_EQ(mm.map_count, 1);
+	ASSERT_EQ(mm.vma_count, 1);
 
 	cleanup_mm(&mm, &vmi);
 	return true;
@@ -1652,7 +1652,7 @@ static bool test_mmap_region_basic(void)
 			     0x24d, NULL);
 	ASSERT_EQ(addr, 0x24d000);
 
-	ASSERT_EQ(mm.map_count, 2);
+	ASSERT_EQ(mm.vma_count, 2);
 
 	for_each_vma(vmi, vma) {
 		if (vma->vm_start == 0x300000) {
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 70f11163ab72..84760d901656 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -261,7 +261,7 @@ typedef struct {
 
 struct mm_struct {
 	struct maple_tree mm_mt;
-	int map_count;			/* number of VMAs */
+	int vma_count;			/* number of VMAs */
 	unsigned long total_vm;	   /* Total pages mapped */
 	unsigned long locked_vm;   /* Pages that have PG_mlocked set */
 	unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
@@ -1487,10 +1487,10 @@ static inline int do_munmap(struct mm_struct *, unsigned long, size_t,
 /* Helper to get VMA count capacity */
 static int vma_count_remaining(const struct mm_struct *mm)
 {
-	const int map_count = mm->map_count;
+	const int vma_count = mm->vma_count;
 	const int max_count = sysctl_max_map_count;
 
-	return (max_count > map_count) ? (max_count - map_count) : 0;
+	return (max_count > vma_count) ? (max_count - vma_count) : 0;
 }
 
 #endif	/* __MM_VMA_INTERNAL_H */
-- 
2.51.0.760.g7b8bcc2412-goog


