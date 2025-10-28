Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CBBCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F958E0195; Tue, 28 Oct 2025 17:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846B68E0005; Tue, 28 Oct 2025 17:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D5A8E0195; Tue, 28 Oct 2025 17:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6388E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:26:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EEA81605CF
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:26:20 +0000 (UTC)
X-FDA: 84048806520.26.1B75631
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf18.hostedemail.com (Postfix) with ESMTP id 20A661C000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:26:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b0/E49yk";
	spf=pass (imf18.hostedemail.com: domain of 3-DQBaQsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-DQBaQsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+j8zhoyklgSghm0fkzA4ZWTIhpnJZIgaxeAaI4yI5tk=;
	b=68zSl/C3IWhOpvztjAPu62aRnh9jdE6N4v762SO0DF4xupKK/KJKIUk+Tq5CzTrJsU1Wd0
	eyB1O791WcawSwhuT1EPXH+BKvh1XhMxZkoCbmw+w94t4VbaKAbqXEs1InaMRAVCmFPcn/
	ab7GCY6P1Kay2IsIOcz4+/aqhN/lMTg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="b0/E49yk";
	spf=pass (imf18.hostedemail.com: domain of 3-DQBaQsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3-DQBaQsKCLUfVgZncndibcbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686778; a=rsa-sha256;
	cv=none;
	b=eKkHHztZzsFz2zjlAwLvjOXzixnt+JUmRQcB+0cGO0zLmQ/oXFIDQXbECsHkc1xYBjQlg5
	/Mz6dJB48Es6URO7tui4sUsrBc7eN9kBxY6n+0denjoDtF+Iep04lUSN1dsxWBX+j5W5XH
	e/4w/jkuP6teheKpnACeN7FOq0JBrG4=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2924b3b9d47so57580675ad.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686777; x=1762291577; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+j8zhoyklgSghm0fkzA4ZWTIhpnJZIgaxeAaI4yI5tk=;
        b=b0/E49ykFT7spwhsoS4iFtwX5i6kPqi/MGXrg7DdB6Th9SXR0gqxoWbFHKlHQeCicL
         Y3sZaXTPLI5TIhVCwYQTni2fK39WlvHV1Rrg2QDHqQbCOWzy4ieqm9yFwixmLo5cM3++
         gb/FLUyK9rvT5Vl/IlEtl7LyqtRhGDwSC8a24m2hlSGqLSZXB/Y3kQJcdCR95TDJyS/N
         veAts7mt9d5Z2QjyZWS/U7DRTQuo+G4NpVaSPVmOcPZl5VoRnGisbcXLpJXM5IyQsrhJ
         /BQ7LHWpJ2RdGf9ZFK0oKjPW8vHQIWACDCaRH/MzlCPEDVIf+4Nvo/WxuK/3O4EPYGPY
         dqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686777; x=1762291577;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+j8zhoyklgSghm0fkzA4ZWTIhpnJZIgaxeAaI4yI5tk=;
        b=kmAM9e2Gp5/wN7r34lgkPFsrSd5idmmr9JO/HxTZ2i/UvJYz2wekck5sw9WJF+FUdb
         Ay4pzNQ9IJwXd7jnFNsY0d/LF+tnhprSOafflhwRmmCDJATG90r9Z9YZIEkAzWyR5+is
         dWnhezs9VUcdl02u4Mi8pggHQmlEsD5qCIFq52QWzbu5VcN/mk20Hyhzt/etJo3bPDR8
         WBqKhzoUMvOt9ADXkvfOIH3jkQgDErMWFV57EFy/5VpSVZYroIjae5+pX255xdQOY1f+
         MsyjGgPe9NeahvjBwNKdsxujmH5RWB1mkBuNjfYBhchjlPUp4IKR4QmjRzIKx2YImxLt
         jA5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWNN8xbIbqP0Luq78K5WgZNoZPS+C34fSAOnd4pjVRC1+JH2PE1Zk04DSXTKV03/6fUttnOAmltng==@kvack.org
X-Gm-Message-State: AOJu0YzFBbf962UH/sYygmhhISYy+hLlawYvJLBnBGWB0s/ZakJucui4
	yTVuKc6DwcqhMApaBKesuw+180tes7ssRHFBU89Ywab+3Bm/pFjpaK2cfTjwH+RfeXdmJhT3bBG
	Ro08hchsyE0StlTbWmIElDeAK9g==
X-Google-Smtp-Source: AGHT+IGvJTcAodqjN68/cwhmvyNqJA89FwIXn0dFOb/T2m6hISvMSs8SoSnw6SBju5uM62L8KYA8GGXsErxvKEdp5A==
X-Received: from plow16.prod.google.com ([2002:a17:903:1b10:b0:290:9a4e:6b11])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f542:b0:267:9931:dbfb with SMTP id d9443c01a7336-294deedb108mr6935075ad.54.1761686776729;
 Tue, 28 Oct 2025 14:26:16 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:24:35 -0700
In-Reply-To: <20251028212528.681081-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251028212528.681081-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212528.681081-5-kaleshsingh@google.com>
Subject: [PATCH v4 4/5] mm: rename mm_struct::map_count to vma_count
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com, 
	android-mm@google.com, Kalesh Singh <kaleshsingh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: je3cqgancac4a6ig4m9iaw3huhc8ymsu
X-Rspamd-Queue-Id: 20A661C000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761686777-521134
X-HE-Meta: U2FsdGVkX185+nxn4nIX1WXzODcL9XlnxbI3S411cr74Qdi3H++Pnsm9gHg5SqoKpXcO1+uNvsrR0g5ZfUgMbDggPprYiowQIgm6fmHiOWvKI2+x5BPODKiz8vBOGssr/9Cu0L96klyBMwTL4jSij3zoE6V63Gl3QO9XJCc7CtK/MWpBLy5gAnl1yqcXHaJhmWfzfzMGSWEH++TDr9JPU1UgSEMS04kLXVeg6cg4u2MZ0l+349bmmNB78SyrvkuVqot8jtkZiN5QyMzoo+ot+Pl3znIRUpXo4aD3y4qiKRDaC2tVry4iHAQpLiYM0uf9b2t5VGDqM4UTjLzil5ra52T5taZBzDkw+RZBtbZh1UVxdatkivlYIlpnH1baIvYXmwlXQc/qhudGRBKlGz2nrgUEzOhXyj6THzoNMurYmtWFL67VR5MVtqN/14VwD5iJHMyY27v22oCf8goNOOUms4XXydLU/rx94D1ZqjVpS3N9akNdJ6zzXWscjpecH0Qo0H2higw3wHHlCe+7bobaeFGnbbO/pSWZOXqwI2SwU6dg+X5bVvSOGmNGuYGaQEBT8GStv7Ti9qBH0caKWx0sLogAIZXQrEfamD0CW/c12Ak+bn9kHoBkwR1S7nNDGeuqWIAWIJRSs1qw5AqkUHZE9Xo1jnYWE7/X7Oab/3FhvreFlAZYqpasUzaE8/Jgx4qV1ejNtRZwQwR7NuPCrfxkdsNfaXax/MSXpssHpxOf6OjtY7b9F27+0NFxuWoM2H6Sxj1SnU4FnBwrSgXMl0NbwksZveZC6hS9IjnLJhEYrqeVlKsylwvB51BqmnC3jwUlEn/UzdAIm1VDxzmnRDJZ77kPNJYZiW5kzf+WNjGc20xz1nw+k9ZL5QHRG/bdomCE4SP62siCEjU+kTTbyZg1OQaJGCSFIqzrzftCho6DY1zAY7L79QKM2pqWhrC6JDVrMM+GlnLJIsRRCWiQK+q
 iMbWy+cj
 4G07i48DonrvrnVuiO1uU+wVG5T0EPIS9wZZz6vY39mdU0RselQxuovZa934Vj2Rbbv+NaWAVYLyLhXSb7TFJetbrQ8q20Eg05ZHu/u6/iHCZoTThP5UDri7LThgojqjBxp637mmj56PXpEQ+iJ8YJ+onJuN09WHOYVd8otpNM43kCyjsJ4NBtvAEFHtZVnXr6CXmJua1CtFiHWN8O6vzYSnjzpOnbtlTA122W5FOF/yqty2liVkVT9NlE3EcnXuuz01s+BiF++aDAkrmx6B/oecN7YZYAEtG/TFVhhKRSkBFYIM7Bu7LB2c2lfiWnYKpvtstU6/Yo1+VGJ6zp1KB3TLOTxJygzF71fZgxABTZyGdc4693YUAoRIdmK/MpXIRVTKHLPnU19/SSWCEZmcfM5PwW8qTjcsNMEA3JLs4zthf3m3q4m5i5CNI4/sYuCwtBXnQlqjqYTUx4++QPMzssEflLlPa3JclrfEIc+gK4eUwaSQ9QrOy3TgLN2xMPbV8+Y//LIBAN4FFRbB6qx+rbntW76OrNrONS4qIU+/J1+U2aIy4rwokJnEq19Si4DCJevUPPrpGuhzgDmDFKza5Sfx7GrKoBcfxkRlNzimWMFzFoJx7D6jU1ROFy6s8uFsbNhcXenbNIP9GzhnwnRHUw0CKno6cpCOXdMdy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Perform a mechanical rename of mm_struct->map_count to vma_count.

The name "map_count" is ambiguous. It can be confused with other counters
like the page mapcount (page->_mapcount), which tracks PTE references.

The new name, vma_count, is more precise and self-documenting, as this
field has always counted the number of vm_area_structs associated with
an mm_struct. This change improves code clarity and readability.

While at it, update the BUG_ON() in exit_mmap() to a WARN_ON_ONCE() to
avoid crashing the kernel on a simple accounting mismatch. No other
functional change is intended.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
 - Update the new max_vma_count_tests.c to use the vma_count name.

Changes in v3:
  - Change vma_count BUG_ON() in exit_mmap() to WARN_ON_ONCE,
    per David and Lorenzo
  - Collect Reviewed-by tags

 fs/binfmt_elf.c                               |  2 +-
 fs/coredump.c                                 |  2 +-
 include/linux/mm_types.h                      |  2 +-
 kernel/fork.c                                 |  2 +-
 mm/debug.c                                    |  2 +-
 mm/mmap.c                                     |  6 ++--
 mm/mremap.c                                   |  4 +--
 mm/nommu.c                                    |  8 ++---
 mm/vma.c                                      | 30 ++++++++---------
 .../selftests/mm/max_vma_count_tests.c        | 28 ++++++++--------
 tools/testing/vma/vma.c                       | 32 +++++++++----------
 tools/testing/vma/vma_internal.h              |  2 +-
 12 files changed, 60 insertions(+), 60 deletions(-)

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
index 5021047485a9..2a102f4899ed 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1085,7 +1085,7 @@ struct mm_struct {
 #ifdef CONFIG_MMU
 		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
-		int map_count;			/* number of VMAs */
+		int vma_count;			/* number of VMAs */
 
 		spinlock_t page_table_lock; /* Protects page tables and some
 					     * counters
diff --git a/kernel/fork.c b/kernel/fork.c
index dd0bb5fe4305..b2c2ca8a0a9d 100644
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
index 5a967a307099..647a676c0ab4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -383,7 +383,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	 * sysctl_max_map_count limit by one. This behavior is preserved to
 	 * avoid breaking existing applications.
 	 */
-	if (max_vma_count() - mm->map_count < 0)
+	if (max_vma_count() - mm->vma_count < 0)
 		return -ENOMEM;
 
 	/*
@@ -1314,7 +1314,7 @@ void exit_mmap(struct mm_struct *mm)
 		vma = vma_next(&vmi);
 	} while (vma && likely(!xa_is_zero(vma)));
 
-	BUG_ON(count != mm->map_count);
+	WARN_ON_ONCE(count != mm->vma_count);
 
 	trace_exit_mmap(mm);
 destroy:
@@ -1822,7 +1822,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		 */
 		vma_iter_bulk_store(&vmi, tmp);
 
-		mm->map_count++;
+		mm->vma_count++;
 
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
diff --git a/mm/mremap.c b/mm/mremap.c
index 02c38fd957e4..4874729cd65c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (max_vma_count() - current->mm->map_count < 4)
+	if (max_vma_count() - current->mm->vma_count < 4)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1814,7 +1814,7 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * the threshold. In other words, is the current map count + 6 at or
 	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if (max_vma_count() - current->mm->map_count < 6)
+	if (max_vma_count() - current->mm->vma_count < 6)
 		return -ENOMEM;
 
 	return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index ae2b20cc324a..ef05d5abbe9f 100644
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
 
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (max_vma_count() - mm->map_count < 1)
+	if (max_vma_count() - mm->vma_count < 1)
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
@@ -1367,7 +1367,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	setup_vma_to_mm(vma, mm);
 	setup_vma_to_mm(new, mm);
 	vma_iter_store_new(vmi, new);
-	mm->map_count++;
+	mm->vma_count++;
 	return 0;
 
 err_vmi_preallocate:
diff --git a/mm/vma.c b/mm/vma.c
index 768d216beed3..fbb8d1a0449d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -354,7 +354,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		 * (it may either follow vma or precede it).
 		 */
 		vma_iter_store_new(vmi, vp->insert);
-		mm->map_count++;
+		mm->vma_count++;
 	}
 
 	if (vp->anon_vma) {
@@ -385,7 +385,7 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 		}
 		if (vp->remove->anon_vma)
 			anon_vma_merge(vp->vma, vp->remove);
-		mm->map_count--;
+		mm->vma_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
 			WARN_ON_ONCE(vp->vma->vm_end < vp->remove->vm_end);
@@ -594,7 +594,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (max_vma_count() - vma->vm_mm->map_count < 1)
+	if (max_vma_count() - vma->vm_mm->vma_count < 1)
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -685,13 +685,13 @@ void validate_mm(struct mm_struct *mm)
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
@@ -1268,7 +1268,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 	struct mm_struct *mm;
 
 	mm = current->mm;
-	mm->map_count -= vms->vma_count;
+	mm->vma_count -= vms->vma_count;
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
 		mmap_write_downgrade(mm);
@@ -1342,14 +1342,14 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 	if (vms->start > vms->vma->vm_start) {
 
 		/*
-		 * Make sure that map_count on return from munmap() will
+		 * Make sure that vma_count on return from munmap() will
 		 * not exceed its limit; but let map_count go just above
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    max_vma_count() - vms->vma->vm_mm->map_count < 1) {
+		    max_vma_count() - vms->vma->vm_mm->vma_count < 1) {
 			error = -ENOMEM;
-			goto map_count_exceeded;
+			goto vma_count_exceeded;
 		}
 
 		/* Don't bother splitting the VMA if we can't unmap it anyway */
@@ -1463,7 +1463,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 modify_vma_failed:
 	reattach_vmas(mas_detach);
 start_split_failed:
-map_count_exceeded:
+vma_count_exceeded:
 	return error;
 }
 
@@ -1781,7 +1781,7 @@ static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 	vma_start_write(vma);
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
-	mm->map_count++;
+	mm->vma_count++;
 	validate_mm(mm);
 	return 0;
 }
@@ -2498,7 +2498,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap)
 	/* Lock the VMA since it is modified after insertion into VMA tree */
 	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
-	map->mm->map_count++;
+	map->mm->vma_count++;
 	vma_link_file(vma, map->hold_file_rmap_lock);
 
 	/*
@@ -2819,7 +2819,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * typically extends the existing brk VMA rather than creating a new one.
 	 * See also the comment in do_mmap().
 	 */
-	if (max_vma_count() - mm->map_count < 0)
+	if (max_vma_count() - mm->vma_count < 0)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
@@ -2857,7 +2857,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
 		goto mas_store_fail;
 
-	mm->map_count++;
+	mm->vma_count++;
 	validate_mm(mm);
 out:
 	perf_event_mmap(vma);
diff --git a/tools/testing/selftests/mm/max_vma_count_tests.c b/tools/testing/selftests/mm/max_vma_count_tests.c
index e20cafaefc82..79404cb22df2 100644
--- a/tools/testing/selftests/mm/max_vma_count_tests.c
+++ b/tools/testing/selftests/mm/max_vma_count_tests.c
@@ -18,7 +18,7 @@
 #include "../kselftest_harness.h"
 #include "vm_util.h"
 
-#define DEFAULT_MAX_MAP_COUNT		65530
+#define DEFAULT_MAX_VMA_COUNT		65530
 #define TEST_AREA_NR_PAGES		3
 #define TEST_AREA_PROT			(PROT_NONE)
 #define EXTRA_MAP_PROT			(PROT_NONE)
@@ -42,9 +42,9 @@ static int get_max_vma_count(void);
 static bool set_max_vma_count(int val);
 static int get_current_vma_count(void);
 static bool is_test_area_mapped(char *test_area, int test_area_size);
-static bool lower_max_map_count_if_needed(max_vma_count_data_t *self,
+static bool lower_max_vma_count_if_needed(max_vma_count_data_t *self,
 					  struct __test_metadata *_metadata);
-static void restore_max_map_count_if_needed(max_vma_count_data_t *self,
+static void restore_max_vma_count_if_needed(max_vma_count_data_t *self,
 					    struct __test_metadata *_metadata);
 static bool free_vma_slots(max_vma_count_data_t *self, int slots_to_free);
 static void create_reservation(max_vma_count_data_t *self,
@@ -98,9 +98,9 @@ FIXTURE_SETUP(max_vma_count)
 
 	self->test_area_size = TEST_AREA_NR_PAGES * psize();
 
-	if (!lower_max_map_count_if_needed(self, _metadata)) {
+	if (!lower_max_vma_count_if_needed(self, _metadata)) {
 		SKIP(return,
-		     "max_map_count too high and cannot be lowered. Please rerun as root.");
+		     "max_vma_count too high and cannot be lowered. Please rerun as root.");
 	}
 
 	initial_vma_count = get_current_vma_count();
@@ -127,7 +127,7 @@ FIXTURE_TEARDOWN(max_vma_count)
 	 * mapping cleanup to process teardown for simplicity.
 	 */
 
-	restore_max_map_count_if_needed(self, _metadata);
+	restore_max_vma_count_if_needed(self, _metadata);
 }
 
 static bool mmap_anon(max_vma_count_data_t *self)
@@ -542,7 +542,7 @@ TEST_HARNESS_MAIN
 
 /* --- Utilities --- */
 
-static bool lower_max_map_count_if_needed(max_vma_count_data_t *self,
+static bool lower_max_vma_count_if_needed(max_vma_count_data_t *self,
 			      struct __test_metadata *_metadata)
 {
 	self->max_vma_count = get_max_vma_count();
@@ -550,19 +550,19 @@ static bool lower_max_map_count_if_needed(max_vma_count_data_t *self,
 	ASSERT_GT(self->max_vma_count, 0);
 
 	self->original_max_vma_count = 0;
-	if (self->max_vma_count > DEFAULT_MAX_MAP_COUNT) {
+	if (self->max_vma_count > DEFAULT_MAX_VMA_COUNT) {
 		self->original_max_vma_count = self->max_vma_count;
 		TH_LOG("Max VMA count: %d; lowering to default %d for test...",
-		       self->max_vma_count, DEFAULT_MAX_MAP_COUNT);
+		       self->max_vma_count, DEFAULT_MAX_VMA_COUNT);
 
-		if (!set_max_vma_count(DEFAULT_MAX_MAP_COUNT))
+		if (!set_max_vma_count(DEFAULT_MAX_VMA_COUNT))
 			return false;
-		self->max_vma_count = DEFAULT_MAX_MAP_COUNT;
+		self->max_vma_count = DEFAULT_MAX_VMA_COUNT;
 	}
 	return true;
 }
 
-static void restore_max_map_count_if_needed(max_vma_count_data_t *self,
+static void restore_max_vma_count_if_needed(max_vma_count_data_t *self,
 					    struct __test_metadata *_metadata)
 {
 	if (!self->original_max_vma_count)
@@ -572,7 +572,7 @@ static void restore_max_map_count_if_needed(max_vma_count_data_t *self,
 		return;
 
 	if (!set_max_vma_count(self->original_max_vma_count))
-		TH_LOG("Failed to restore max_map_count to %d",
+		TH_LOG("Failed to restore max_vma_count to %d",
 			self->original_max_vma_count);
 }
 
@@ -617,7 +617,7 @@ static int get_current_vma_count(void)
 
 		/*
 		 * The [vsyscall] mapping is a special mapping that
-		 * doesn't count against the max_map_count limit.
+		 * doesn't count against the max_vma_count limit.
 		 * Ignore it here to match the kernel's accounting.
 		 */
 		if (strcmp(vma_name, "[vsyscall]") != 0)
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
index 41d354a699c5..d89b26e81679 100644
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
-- 
2.51.1.851.g4ebd6896fd-goog


