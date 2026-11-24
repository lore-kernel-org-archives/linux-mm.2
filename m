Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9755E60A380A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fh5NqFKV
Received: by kanga.kvack.org (Postfix)
	id 963D36B07D9; Tue, 24 Nov 2026 12:09:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B106B07DB; Tue, 24 Nov 2026 12:09:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851BA6B07DC; Tue, 24 Nov 2026 12:09:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB316B07D9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:09:27 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A2E280B94
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:09:26 +0000 (UTC)
X-FDA: 85470648732.01.6215475
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6AE8C000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:09:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fh5NqFKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540165;
	b=H6EVyj5xFDcYy8KYFGuMdDzL7O4UlzGiRY/r5tWroBlXqhSLx7Udnv1TJE7msH11HIYVwz
	rNUNH+5TL/9e1RlautSkHfb/TG1pUC3nU+1oKCeh5pDmU28EBTlDExE8l7G3ga9H0NfK8B
	9Q/xH0VoAc0rH7RhF8lIKZ5iAbZ1YNk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AaIrFlkXdeWf9hXAsBJcUrPwWw8lPr576kDFCtinrC4=;
	b=dHrbG6L7rgxLG95Q/yXbnlvGEaJf2m0acbDIKkNM7j9b/24g/2+AYo93xonQSWyklhog3z
	Nzrwh4OWzx/J3zs/PyWILFdzDxGhUEAuh6/wR0s5zI4TEMrPg4NHu3XvdnZWCsf4ulR2pa
	Y0xLz6wnnCz8AuYrtwuKwQf+QC4wuMg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fh5NqFKV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 450E16279F;
	Tue, 24 Nov 2026 17:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6CF1F000D0;
	Tue, 24 Nov 2026 17:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540163;
	bh=AaIrFlkXdeWf9hXAsBJcUrPwWw8lPr576kDFCtinrC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fh5NqFKVY7dmEHOZo+WfBqkbmDoW4EzOBurfc1eW7z5egP5jZ69di12rtO+fJDhlG
	 +asNZ8e7evQ6DQ9TAwz5qnSWe61KBzp37w3IUz1sZ197hsmM3XfKfW8sKh0dT8l1yO
	 pjn7SavwfbD02HUUU9lkEnRgD64gQJSlhK+LUWGcgrIRrFZ2RY8328T8DDhD7zJy/v
	 4JhIgZ02UnJ3QrbkIgU/rPWi64UpgCJu/lgGYsaS0LC9AJBTd2BfRevIb0LTRnc3ij
	 g0WVhVCUqF4knuF0OXQ/isOcX7Z44fhhey0B6KvDsIWeOjm/BfaAZM7K3WH1yH7ff/
	 pOLG1BJlyy5wg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:55 +0000
Subject: [PATCH v2 03/11] mm: convert miscellaneous VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-3-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8060; i=ljs@kernel.org;
 h=from:subject:message-id; bh=HbJWR73e5rJe6zVww3bXvTrm1rI3bP2M41UnWwSLhf4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+TWfD2t2uLo3b8la07U3I9LGBgeeLsfuOG4c3Ln9
 Y9hV+5s7ihlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEGlIZGX4Ux1T7qNoHnf57
 Y1lO7e0pLp1TVc6//3mrdJpllqt1VAPDf/e4Qw6aG880HNl9ebfT+71TPAOm74v80bjSxr+ni+8
 gMzsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: D6AE8C000B
X-Stat-Signature: 6s71akp5ffdesqmbz9une46oj4nrhot1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795540164-902714
X-HE-Meta: U2FsdGVkX1+H1CAkfEloewTbNq/VxA4vrdF3ErIUL3+E0RGKOD6empFPGaBwTTqk87Dfoco3nf2n7Gl5znTMZGKAq8Bu+mY49xwyrkxtsAqaeWP27HjU9uLnzpmw8/O0AYk3ehItxbAksb2HjQxLXsN1YdM55/tVrIuI0sMZurZYjHjSQRV3A2T+dSYH6qpFDwLnFy52h0y0WYF/55crNuU0h2D0rozp/+Ofx/Sv5qK4vyX1+/dMYZafRRA71+jpxM53BoNK1eioxL5ieLbcqZ8yFlkCTW/RPcMvyH9qUG4v6f8+SozForIhmkvzkROZqSmubiqUmDpMwerNTQib4HnaBPFRtg0Cbfk6qc7AzMT4zbnzixeoaPhN2BP4Hp85Bj8gdxaDehQp5UCTNl039kfaFVdQEDEt2Xx4NVv0YR1eGcvd4htJIW010lFVa6PqSTR1K7ceXACr/bXgEaP/Caoy8AcND/wTdl/cFJQGLikjmB3SRcf7wxA/N9p8V55Dm6WT3JbszDlXj2YrygpjujEACnMBh6DWZkBOSS90TPrKN8TzH2ddeclkYBa3venknq2YZh3d9mAdS0ske2TUV/aaX6cse7K/cWe8ph9IThne041HgMze+8UlA/omXappwsgPizIxjxhfoJ8s5/EHi8AlX9W37GqHgVhAV7ZeBvYZvE9OXJES3XwWKUa3O/wLJe4JMO+pBsrzLNDtvz7hdMZm1jk/Cv8UnD2vigiTyqFTG9cTq96XnFMIw+LZEOCoakLZ12bWsRbG1eHXBZagQ/EUV323EkQgXWa9ZJiDiLtcMMGX07/krxs2nlV9BJpk0MGQkQmDe1RYArzMqqloFLgYETCBPspT0Z5j7clNz5mIplf5/UU7NHTpWY07YM3iM0Zho+gl2ip03f/XzQeEntg2Tbf6q4Zo2dO4UL6L8H4fxAGKLVSoU6ZbEp/d1pgOho5KpSZVySpcCP/48YJ
 bq3QPJZF
 odCM3NbaZI65ilV1kEL0MO0cKSLC5A5WaeMKqWmsr2vd4OvkeygxH+ccnynXKGPPVQFbW9YnlAdie4WC+TncpZctlzAe7paeekM9/FOcPDn+z7EBIUq/BjJle5zZJAnTqmbveJPgLDJXELxtZlbQGugvOxfxx3isK/uLkXVQLEsc+abkYLxTXqnahNumYT9Ob2wSQ7SJQuq3YidEfma3ToDuRL4AUZ4mWO9TI8VN+p6xDZ8sZitlStkrXl4FUzU+2W2nUftIobnGKRJZcTJ6bn+Re9PrpxQh0Ck+A9bjKUMEuWWx0klSffv0/h1jj6IS+e6+e5KX3FKRrh5CkPhTuh1C3fBfr5PaRYoz/yx9sK2tcq2uvaWVWXN1599pnk8QufpV7pe4es237ccwRXLybS0gKENGFiZMWBtDmhWZ0pFlgB94I56B9nbOn3ZHYhjbq0AOnpjJNVFFDCFtL7VPRnnO3DTefTJGtmuZRF4WErxoSWi45R51sx9CSjSxM2CB0xqpgq0V76AhQQf4mwYzn+pIWoYewRZwq7z2POdaMdow8sYfWaI2heH808O+fXTwSQnQCSv3PriRHPtirPreIqOuPJaOG/bahOCobuGT3v9CIW+swYNJePzWKeZ9oMiBUWBQXpM++YgjWFCnA/bMSDxOdPw==
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
Acked-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org> # DAMON
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
index 36b80a2a0e74..573b68ffbc63 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -813,7 +813,7 @@ static inline pte_marker copy_pte_marker(
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
+	if (vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_RAND_READ_BIT))
 		return false;
 
 	if (vma->vm_file && (vma->vm_file->f_mode & FMODE_NOREUSE))
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index b803c53201cc..e08993b10a7a 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1251,7 +1251,7 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1323,7 +1323,7 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1e65e7651cd9..750e643e020f 100644
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
index ad7d6013922d..6b9def3c0687 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -596,9 +596,9 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
+	if (!vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT) &&
 	    !vma_test_single_mask(vma, VMA_SHADOW_STACK) &&
-	    vma->vm_flags & VM_READ)
+	    vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
@@ -663,7 +663,7 @@ static int hmm_do_fault(struct mm_struct *mm,
 		return -EFAULT;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
+		if (!vma_test(vma, VMA_WRITE_BIT))
 			return -EPERM;
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
diff --git a/mm/internal.h b/mm/internal.h
index de4593b3e3b6..cc5e43e7bc49 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1259,7 +1259,7 @@ ssize_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f800fb961ae..6528c86042bb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2015,7 +2015,7 @@ SYSCALL_DEFINE5(get_mempolicy, int __user *, policy,
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
 		return false;
 
 	/*
@@ -2567,7 +2567,7 @@ struct folio *vma_alloc_folio_noprof(gfp_t gfp, int order, struct vm_area_struct
 	pgoff_t ilx;
 	struct folio *folio;
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 073c5125b424..36dc9c0b5dfa 100644
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
index ced41d3c2903..06c62cdb337d 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -79,7 +79,7 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
 		}
 		/* Here vma->vm_start <= start < vma->vm_end. */
 		if ((flags & MS_INVALIDATE) &&
-				(vma->vm_flags & VM_LOCKED)) {
+				vma_test(vma, VMA_LOCKED_BIT)) {
 			error = -EBUSY;
 			goto out_unlock;
 		}
@@ -88,7 +88,7 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
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
index 05300badd70b..a74143bd2274 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -596,9 +596,9 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
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
2.56.1


