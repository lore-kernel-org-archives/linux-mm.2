Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EA89CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699F98E0012; Tue, 28 Oct 2025 17:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B1C8E0005; Tue, 28 Oct 2025 17:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512AF8E0012; Tue, 28 Oct 2025 17:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D83A8E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:26:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFE98C05BA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:26:09 +0000 (UTC)
X-FDA: 84048806058.16.85C41B9
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A6AB140007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:26:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt59JfuR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 37zQBaQsKCKwWMXQeTeUZSTSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kaleshsingh.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=37zQBaQsKCKwWMXQeTeUZSTSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTt8bEnNQStSUEFXw6O1ENJZuyS/zqyLXHsHqP8M9Hk=;
	b=G1i7rmhAwSg+qVEf8PzScI8I69gweVqqr2NXfZDh0A4CdS3YEjXKI+2TRY9RZ7rZEemHuB
	932dI+sodfAXFiZY5Jdvk2MUh8Q+fAkywmVSsD/GHuy3tqsOiPcNugOxuEoJalwPn0WfIx
	UJT3HMQI/mkjEGmZDC6TxLYMfs0frOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686768; a=rsa-sha256;
	cv=none;
	b=GVVwr72aN0LQBZ9gzWw7TwhE+H16fyJwS4ruO1Uq+EpUXdTo44WdqH2wNHB4haFBYgjt/g
	+zW5vakfMi4Uuaix5dIGBOKkziOpVxq0OsP23n+1fYg6PQMLc8J2Gt8IvGjE8CP/bLQDY/
	Xu66qNjIU5svxAszQ21p63rHpmbz0OA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dt59JfuR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 37zQBaQsKCKwWMXQeTeUZSTSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kaleshsingh.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=37zQBaQsKCKwWMXQeTeUZSTSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--kaleshsingh.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-780e1e71180so90252507b3.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686767; x=1762291567; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NTt8bEnNQStSUEFXw6O1ENJZuyS/zqyLXHsHqP8M9Hk=;
        b=dt59JfuRP99McK52Usy/DM+2HkM1y/WODXhKHdzuTDBJkiooQmSrymOFDujuyUEM7i
         IXusEfcOOJA/dajXcAwQph8rMSpfks23v36AEVZazgh0Ua7F9quUI/ee5pZNJfwNVomE
         IsVyyRynKo5CX6AaPcgDH6W+Y879n1sO3pXjaidap955JgA2cUV0suUhgYsB+zzxH1hd
         ue+okPAWbln8FkRc2CHHZJUhI5nDMG8zcuKbSVvhmbgMG3D3ZxFgRDOviGC85qjVnv8J
         VeLA9piTbQQhYjyx5rAM68+0ZBjLO/w5wkQZZ5yRAgsT5z+m+F6IN5aXsPRMe20bIggi
         Enlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686767; x=1762291567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NTt8bEnNQStSUEFXw6O1ENJZuyS/zqyLXHsHqP8M9Hk=;
        b=aup4og3fFWje1YRZd165v6ihVYqbpN8KDVurjeieJmnEFobWLCj2H+1AU6yapdTprK
         BLqbF6+mpdFf19pz+D5r24xPvddXT2rpXp5grXZLuuYNaTdYEWy1jJ3ZC/FDaMgedyaq
         u1ieHHvWOiJqfPBRr0VWJ8LsSlj4UKi0b6lVcWJkaSKl7p+TG9q71I5XRkFiDAUNpluM
         LxD+OVPON955BO9XifBJimA/Yldgg+BKWHajKYlD4srGEFN6gML9WGCdmCXzwsL5EyNf
         FWIII80zb37zch9/JbHvc/WfjAJ7QKuEMxHabTggqpWXz1qVieGrzfPqMN6DS8fZ5nBI
         0MgA==
X-Forwarded-Encrypted: i=1; AJvYcCVe89h4vXsEjZwz9AbW14cFCrfNJrrq8SHKDxIs6AiI3YTmIFlh+tkoT6YcaJTeiSNFSDa4MkE4Kg==@kvack.org
X-Gm-Message-State: AOJu0YzjnHmXRSDV5jxU9pfKCaBXyvUo7zyZ+P5AIehkecbUNbfOOkwj
	Wi8ScZgk5alsapT1MuQU3oJCnWFAoweRXqvFFqxWcyfnT1ZyCNLsSEbMHAVvbAFXuW+ZpG71Qxw
	cW92q5Gm27J6x74hDFFUl9BukoA==
X-Google-Smtp-Source: AGHT+IFrlEdqDQbSkrVhtqgCvEVtlsqYzUqdtjztFgSuD/p7jE/0v1060C3RmU11+7JIA5Kg3L/dQa4wsNzkHR6+tw==
X-Received: from yxfj13.prod.google.com ([2002:a05:690e:4cd:b0:63f:2d9a:654e])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a53:6912:0:b0:63c:f349:cb97 with SMTP id 956f58d0204a3-63f76db2d1bmr604043d50.41.1761686767005;
 Tue, 28 Oct 2025 14:26:07 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:24:34 -0700
In-Reply-To: <20251028212528.681081-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251028212528.681081-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212528.681081-4-kaleshsingh@google.com>
Subject: [PATCH v4 3/5] mm: Introduce max_vma_count() to abstract the max map
 count sysctl
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A6AB140007
X-Rspamd-Server: rspam02
X-Stat-Signature: cobkpxmom7ofogtfidoicuxcf14qhep3
X-HE-Tag: 1761686767-836533
X-HE-Meta: U2FsdGVkX1/HXWedIRSeRrw7bFrqEo7FcSzl3K8tslooBSYU7SOf/4XrHvtMx3QnP6/u4VqhFUtqFWJpeWUHBnDy0Ag7UCikdTi7/2S3jvDGQb/DJsowjjLVfZZtMRgfv4NwlSKz2JORSgbh15vwAsKwpXEzjxHu90lByX3XDHdFQOaBfCpOhdFrVZOBILpmLXzPqR2oPYr++7SCAMU4rvswnM1yxssj3xAQyJeaZGTfijfRvnLwjoedkHf0TDySV/G1Ho5iMzeiYqfmcqg7WGe4WPdJx+8JyWG+7pdW4qgY4ksr/Zj71Bd3OyrZcjpBNqC8ziRkB4R7wA85gW58LNKzNfm/8N43XOh1r0DbQUrSlNOgy/D22eiE2vroWeOomjI3bwOhsO66JZnhegnmi0vzL4nKyecQceFJW8EFsebb5UVWCzaPAaoMAtdQv8pCi/tpr6aMOpEEZNw1VaQ0i0T7IC0pBbJJg2Nu3lYKdFdaZRAzpER9fK6dP47B0uXzT3keEV6FtkdLncHwuclnkSdw+j5Mgq3z1BIauJB5oN5pZrjY8YdPfCRAITo/FjNj8u1bnNvkHenCGLPY9So8CNoqV/trk27Ei0rSPTrR462c1BoLUO1HnokuXSTm9EeQFcUhTF3NqDkV3d2nvfTpgjsU8VwGb2Q7ekC24fJRITRfWd8FXudipDvsj5CqvKfeG80B0Ob5UGNDVkDzAHaVXA2kYGMz3BuzZTcKlGvzRedZwT7ORXcRPdI+3wpHB6QEOpjoMrOl0u5kwSq1JyF/RRpG2hApM39DBIQitnVdzkdzfv2IODzjQfZMbrh7w9xN5UvEVPM0wx016epxC5uxJvb2JmDzpmGIJwDWNnNp2AOLYmgH/x8qMr7PMcun6cuyPCUQAa4ssQTEjleGkvV3+5ni2twPdJuK9Mp462IBGzKkobVEBlYRr4Sb+QVmTfhxEvkzx/rPeGfz2h3IxR3
 e1iUFw+l
 7L/RNi1Yv+E5tBcSSDc6A3EE6lw1dlY5rd761TUYzx8IPHN/vHkmkP0tWnh08ceOQFtaIn9qSYRDZCP9wEM5ElcdsEitE/b1ilN3PSxkX/pCZmW13vmropGp7HAmwYVkN4VWmkMp2aQ98z/zQv0pdWFdVIcAy/Nys3edhWwJTSHCh0QW5j0gsUII2D09of22jZ0Suu3079wPH3HVcY0UslGK2Ugs+q+fhIhVoa+O7oGG44m2hkvggsVDr8Xin5Lw0iXPyKxV2EYrlBQhnV38kQNFzr6ysdodfCLqymdA+Z7YTxuPSWXvEUG1bP27IPaVoPg3ckhgPVfKCrBi1SEuThx//vqwpXPTkEHZMcFnuSbnXr6UMm50N00HssHDSdgYdoNFBTFdV1HbIPIvqho2slEcGGg6N07KmK5cIsPh25888ksY6JRO79uNdYH507dtkQY6b3Bt6KiuzzCaqDf+CJ0G+dGy1W7LuGHwLlHq0VeQL3ignkkGUvyxfJRrCbPwYK6XqsTbnEGXkvjrSpoPUsIYghqM3U8yYhX9c/4WTDSPWibR6sGNrV4PHDGWUrfSTo+ehRDhEmiZsqXScT4aLbM65NfwFT2TvgN2LYgsgi7vmpfdwhrzP6XucXoWvc+qPorFxcnq+5CdIcM/2ssKCNN98LYkZR9wHcjmZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper function, max_vma_count(), to act as the
canonical accessor for the maximum VMA count limit.

The global variable sysctl_max_map_count is used in multiple files to
check the VMA limit. This direct usage exposes an implementation detail
and makes the code harder to read and maintain.

This patch abstracts the global variable behind the more aptly named
max_vma_count() function. As a result, the sysctl_max_map_count
variable can now be made static to mm/mmap.c, improving encapsulation.

All call sites are converted to use the new helper, making the limit
checks more readable.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
 - Introduce max_vma_count() to abstract the max map count sysctl,
   replacing the previously proposed vma_count_remaining() helper
    -- since this remaining count can now be negative as some cases
    are allowed to exceed the limit.
 - Convert all callers to use the new helper.

Changes in v3:
 - Move vma_count_remaining() out of #if CONFIG_SYSCTL to fix build 
   failure
 - Use READ_ONCE() for sysclt_max_map_count, per David, Lorenzo
 - Remove use of ternary op in vma_count_remaining, per Lorenzo
 - Rebase on mm-new to fix conflicts in vma_internal.h and
   mm/internal.h

 include/linux/mm.h               |  2 --
 mm/internal.h                    |  3 +++
 mm/mmap.c                        |  9 ++++++++-
 mm/mremap.c                      |  7 ++++---
 mm/nommu.c                       |  2 +-
 mm/util.c                        |  1 -
 mm/vma.c                         | 10 +++++-----
 tools/testing/vma/vma_internal.h |  6 ++++++
 8 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index aada935c4950..5db9d95043f6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -205,8 +205,6 @@ static inline void __mm_zero_struct_page(struct page *page)
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff --git a/mm/internal.h b/mm/internal.h
index 116a1ba85e66..eba30ff7c8dc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1702,4 +1702,7 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+/* mmap.c */
+int max_vma_count(void);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index 78843a2fae42..5a967a307099 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -383,7 +383,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	 * sysctl_max_map_count limit by one. This behavior is preserved to
 	 * avoid breaking existing applications.
 	 */
-	if (mm->map_count > sysctl_max_map_count)
+	if (max_vma_count() - mm->map_count < 0)
 		return -ENOMEM;
 
 	/*
@@ -1504,6 +1504,13 @@ struct vm_area_struct *_install_special_mapping(
 					&special_mapping_vmops);
 }
 
+static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
+int max_vma_count(void)
+{
+	return READ_ONCE(sysctl_max_map_count);
+}
+
 #ifdef CONFIG_SYSCTL
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
 		defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
diff --git a/mm/mremap.c b/mm/mremap.c
index a7f531c17b79..02c38fd957e4 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (max_vma_count() - current->mm->map_count < 4)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1811,9 +1811,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * split in 3 before unmapping it.
 	 * That means 2 more maps (1 for each) to the ones we already hold.
 	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * the threshold. In other words, is the current map count + 6 at or
+	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (max_vma_count() - current->mm->map_count < 6)
 		return -ENOMEM;
 
 	return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index c3a23b082adb..ae2b20cc324a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (max_vma_count() - mm->map_count < 1)
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
diff --git a/mm/util.c b/mm/util.c
index 97cae40c0209..eb1bcfc1d48d 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -752,7 +752,6 @@ EXPORT_SYMBOL(folio_mc_copy);
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 
diff --git a/mm/vma.c b/mm/vma.c
index d0bb3127280e..768d216beed3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -493,8 +493,8 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 }
 
 /*
- * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
- * has already been checked or doesn't make sense to fail.
+ * __split_vma() bypasses max_vma_count() checks. We use this where
+ * it has already been checked or doesn't make sense to fail.
  * VMA Iterator will point to the original VMA.
  */
 static __must_check int
@@ -594,7 +594,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (max_vma_count() - vma->vm_mm->map_count < 1)
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1347,7 +1347,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    max_vma_count() - vms->vma->vm_mm->map_count < 1) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2819,7 +2819,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 * typically extends the existing brk VMA rather than creating a new one.
 	 * See also the comment in do_mmap().
 	 */
-	if (mm->map_count > sysctl_max_map_count)
+	if (max_vma_count() - mm->map_count < 0)
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index d873667704e8..41d354a699c5 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1491,4 +1491,10 @@ static inline int do_munmap(struct mm_struct *, unsigned long, size_t,
 	return 0;
 }
 
+/* Helper to get max vma count */
+static int max_vma_count(void)
+{
+	return sysctl_max_map_count;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
-- 
2.51.1.851.g4ebd6896fd-goog


