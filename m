Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C43D606A33F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FP6qFnXO
Received: by kanga.kvack.org (Postfix)
	id 11B476B05C2; Thu,  5 Nov 2026 16:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2AE6B05C4; Thu,  5 Nov 2026 16:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28AB6B05C2; Thu,  5 Nov 2026 16:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CED166B05C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:34:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3805DC0BE3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:03 +0000 (UTC)
X-FDA: 85402368366.27.47E79A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5F9D0140007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FP6qFnXO;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914441;
	b=ygZlr5ISRfyxARTwGSgPlD8Njvb1e8s+iIOH1RDi0oCsY5X1ya4t3UhPilm9tShGW7vwkS
	Ro18slHOHM+0ePvp4nwz35L92zB48Xax8JPHHUP5koFM1O1Wm4Bm+0/MForOPxwHbsWCQk
	ShWjrDVQmwtVu/pYnBL67qLf3qbUIkc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FP6qFnXO;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1O6PsPSrFnt9BTLaaISkTdkv8+AsEerts7T47IxUwQ=;
	b=wnrS7bAbld6/8UszYvNfdr68GkaTQPEXMOfoSiC7fdsMk8cQypXn8B/Qk7aooy4cYeAda8
	SsnK24oObckyFe3sDI5EOoV8r4vx4+Q1JES8VdMUkR1WPLiqHNWAzltBaSAFi5CO8LMzjs
	Px73F6bibvWQAnsEYQjUAj7q4AGo4WY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A045F4150F;
	Thu,  5 Nov 2026 21:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265CA1F0089F;
	Thu,  5 Nov 2026 21:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914440;
	bh=Q1O6PsPSrFnt9BTLaaISkTdkv8+AsEerts7T47IxUwQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FP6qFnXOsA4KQpngsPCZd5lXBRNPCMj99mGbaOnvk5VdxhrZD9E2YiEbUspll/M98
	 k46DOiZz/G4kPuu8uUVt4XNGYcEkntyJBALH3XTT3CahGiUpY2cDDeocvjUuhR/9p0
	 wJGvlS5BjR/voyFaU125NCiqWpfEoToetp0cUf9HT58FmMhUV9ZuaxarhpeLKXuy9W
	 qlKv7KwkPEzfONlC3AHLNnNMXXon1I/FJSztkelxU5z1gphUucDgmgGsBNnuZsWVqz
	 Ho3I6eXllot+zXbOF7NC4ZDW5Vek8hlvaZQeijm2vj/9vbhhr6pkv8eyISBtYZOGxb
	 9183O3UZctltw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:59 +0000
Subject: [PATCH 08/13] mm: convert miscellaneous VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7804; i=ljs@kernel.org;
 h=from:subject:message-id; bh=qpbuJVrxyY/7AAHSEFGEKenLjEhgiUuNHBU8QsxXe74=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0+1f0Tq5WqHxOL/8ZuOem6JVHm36fmN294GXLt9
 Oy1G9aWdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiM58wMnw+cf5EVN3exN9H
 REo0wg+meG1S8M+ISRBNuON3NNyf24OR4aTj3j3KcWEz8vZrMrSkLHpV0no97fyM/DRD6bnMDyf
 HcwMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F9D0140007
X-Stat-Signature: qjk7fd7bui9ic6up57egdy969f3ds1j3
X-Rspam-User: 
X-HE-Tag: 1793914441-588128
X-HE-Meta: U2FsdGVkX19YRu93MyjI1nbDQrb5UPzZrndhIlVBgnGtrQsJKKAwgqlY3LKyk8T7ss/6A6OLjpEwej4qjLzIDZmAA9ETH+VYti1EyvS6Zrz2V30G855lEgMyFMtOC3lGbonSqJtnpI5P6jIpvPCuQJbdQFknD1Q1T2AGJ1JeW6SH4DIOEHgnEuTN6tEPPwoi4S2NCsmCfUej+YGB+n5T9B0m7iMmVS3oIphamLKsCipFFZeW6m5wqCRMFEAZM7TLciovfIFa/scb/YeNRRZs0CGoohgk8nHAq5VSyYC+6hswJl7vxRqbR7S5tJcwfz0zyhpITgTrsGn519JUXKn0fSz6DpnZ5X9BXxOoJoMaHdYy1Oi/4Ys9QZJYbHutTesOjtTOeV3en4+FsRi/9bMUzx1sMgzb2XiYjMpNrny5u9KAbZjG/+U0FVL2pYWh6xgV7GXTn07CR5ogQMNiYogUXVbGUrEMi2j27APibUTidA32vt4RLa01/zdfHIGsGw08ow3cprauBFuwp5hfp/Lccw4+WSKmzHHWSMLzXotaz0HOoQMDygiFo6eZ6whZQsmUO+79ntppNCY0n0H1psY5lpFeONvTnxiTM3yVhUaM5zealB29ojQtfuXCRLK1gkd4kmFtmu9lLvAVTS5kh4uwfgqSr3iyxDoQNpHsLL94N3K4XxS87PLhBkWMT+eOkn7Gp0Oxk2MxGZIpKhS5F4tlrVItwWb67PFWcduY1B7SKbWcnRsmnRe+X/BA7+sHOfus0wzQWXyU3LmMVhDC9A96AG0qQwNP7YaS5SRdMmXH4wrYaqyT7vmdTKyOf7TrvHe9RDO1kpULe9uwWkObgMO1K/yEn1ES+RWgHVMsgihw2NzjqCJVGJGZBtbapZ+ClR1DhPIuFZF6PCK3z4bLaiy4ApIxzdgg5Bo9+Wqv5ha3IN3FfMKd3jdrLfdhsTq97ugyuP8huSECEZpYRz5aKgb
 /W55Q6E+
 d2bioLxIyfFEv/P3OeCW/f+WkceiysdHjgCLYq0XfM+wkpkPYfHYmVthU8ubMvwyAUU+0MYq/VGFlvORwR7lpD3ggkIxI+9o5ihszODIPa9fZlhNC88/wPclqtRXjU+YtsWFsWw5tUw5mG0CosFaATjoayEsqPCWzaoTfHmHpDOOi/e41t1Tto+zMELBOhwBcDxtavJw4X3oPGw9krprLdY+AsrBOi4KomFAAXKgJAgbHuayFljr9ay3UY3OlXAq09gSiGfNfjs6h2Q5MJunKfvEXuhJu4qrRy/rguY0N+ggn/Vra4pgYNs8erHmesCiNtUk5utK2gx37PhaiEpGeRh78320v+pjzOj+Ic4R01qDEVfxmHKot+hxhHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
remaining straightforward VMA flag tests scattered throughout core mm, HMM
(and its test module), DAMON and the OOM reaper.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm_inline.h | 2 +-
 lib/test_hmm.c            | 4 ++--
 mm/damon/vaddr.c          | 2 +-
 mm/hmm.c                  | 6 +++---
 mm/internal.h             | 2 +-
 mm/mempolicy.c            | 4 ++--
 mm/mmap_lock.c            | 4 ++--
 mm/msync.c                | 4 ++--
 mm/oom_kill.c             | 4 ++--
 mm/pagewalk.c             | 2 +-
 mm/vma.h                  | 4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index ab69b9930893..da04d81a819c 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -657,7 +657,7 @@ static inline pte_marker copy_pte_marker(
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
+	if (vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_RAND_READ_BIT))
 		return false;
 
 	if (vma->vm_file && (vma->vm_file->f_mode & FMODE_NOREUSE))
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index b409c42bfe6f..d7702d99ac9b 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1248,7 +1248,7 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1320,7 +1320,7 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2..9a43f7428142 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -240,7 +240,7 @@ static void damon_va_walk_page_range(struct mm_struct *mm, unsigned long start,
 		goto lock_mmap;
 	}
 
-	if (!(vma->vm_flags & VM_PFNMAP)) {
+	if (!vma_test(vma, VMA_PFNMAP_BIT)) {
 		ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
 		walk_page_range_vma(vma, start, end, ops, private);
 	}
diff --git a/mm/hmm.c b/mm/hmm.c
index 2f1e98c6b644..058d0b48399a 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -595,8 +595,8 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (!vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT) &&
+	    vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
@@ -659,7 +659,7 @@ static int hmm_do_fault(struct mm_struct *mm,
 		return -EFAULT;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
+		if (!vma_test(vma, VMA_WRITE_BIT))
 			return -EPERM;
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
diff --git a/mm/internal.h b/mm/internal.h
index 8b1263e81054..cbb205f06097 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1249,7 +1249,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 80c693c6d693..31d42bcad529 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2015,7 +2015,7 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
 		return false;
 
 	/*
@@ -2565,7 +2565,7 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 	pgoff_t ilx;
 	struct folio *folio;
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 834bbf86e004..1b0560a4dfcd 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -636,7 +636,7 @@ struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
 	 * Well, dang. We might still be successful, but only
 	 * if we can extend a vma to do so.
 	 */
-	if (!vma || !(vma->vm_flags & VM_GROWSDOWN)) {
+	if (!vma || !vma_test(vma, VMA_GROWSDOWN_BIT)) {
 		mmap_read_unlock(mm);
 		return NULL;
 	}
@@ -659,7 +659,7 @@ struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
 			goto fail;
 		if (vma->vm_start <= addr)
 			goto success;
-		if (!(vma->vm_flags & VM_GROWSDOWN))
+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 			goto fail;
 	}
 
diff --git a/mm/msync.c b/mm/msync.c
index 90b491a27a14..953efa1738c5 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -81,7 +81,7 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 		}
 		/* Here vma->vm_start <= start < vma->vm_end. */
 		if ((flags & MS_INVALIDATE) &&
-				(vma->vm_flags & VM_LOCKED)) {
+				vma_test(vma, VMA_LOCKED_BIT)) {
 			error = -EBUSY;
 			goto out_unlock;
 		}
@@ -90,7 +90,7 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 		fend = fstart + (min(end, vma->vm_end) - start) - 1;
 		start = vma->vm_end;
 		if ((flags & MS_SYNC) && file &&
-				(vma->vm_flags & VM_SHARED)) {
+				vma_test(vma, VMA_SHARED_BIT)) {
 			get_file(file);
 			mmap_read_unlock(mm);
 			error = vfs_fsync_range(file, fstart, fend, 1);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27..91b11299cb5d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -524,7 +524,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	 * of the address space.
 	 */
 	mas_for_each_rev(&mas, vma, 0) {
-		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
+		if (vma_test_any(vma, VMA_HUGETLB_BIT, VMA_PFNMAP_BIT))
 			continue;
 
 		/*
@@ -537,7 +537,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 		 * we do not want to block exit_mmap by keeping mm ref
 		 * count elevated without a good reason.
 		 */
-		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
+		if (vma_is_anonymous(vma) || !vma_test(vma, VMA_SHARED_BIT)) {
 			if (zap_vma_for_reaping(vma))
 				ret = false;
 		}
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index e6493bbe6919..41e19f544493 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -393,7 +393,7 @@ static int walk_page_test(unsigned long start, unsigned long end,
 	 * define their ->pte_hole() callbacks, so let's delegate them to handle
 	 * vma(VM_PFNMAP).
 	 */
-	if (vma->vm_flags & VM_PFNMAP) {
+	if (vma_test(vma, VMA_PFNMAP_BIT)) {
 		int err = 1;
 		if (ops->pte_hole)
 			err = ops->pte_hole(start, end, -1, walk);
diff --git a/mm/vma.h b/mm/vma.h
index 3fc3b47a954b..201dbfe3d7f8 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -597,9 +597,9 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
 	 * private mappings, that's always the case when we have write
 	 * permissions as we properly have to handle COW.
 	 */
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return vma_wants_writenotify(vma, vma->vm_page_prot);
-	return !!(vma->vm_flags & VM_WRITE);
+	return vma_test(vma, VMA_WRITE_BIT);
 }
 
 #ifdef CONFIG_MMU

-- 
2.56.0


