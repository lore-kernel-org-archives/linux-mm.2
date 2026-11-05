Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2C8606D818
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FB44KVZY
Received: by kanga.kvack.org (Postfix)
	id 820826B05C4; Thu,  5 Nov 2026 16:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7736B05C5; Thu,  5 Nov 2026 16:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E0D6B05C6; Thu,  5 Nov 2026 16:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4B56E6B05C4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:34:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3019DA0A6B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:23 +0000 (UTC)
X-FDA: 85402369206.18.6E6AB4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 59A384000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:34:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FB44KVZY;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yugPCJWELV1xpKfK4O7FyYZfkGoZI5YKsROj+R4zujY=;
	b=UJEaNCIMHSYeqz2gfZGIL1F060ix6Fenj3KwxI48bthjNdCdBZ4z5ATYy0eZb+RdKSXUPR
	y6jL5A4gtHlFPEtlBiYFSFqcL31eou6PD4kr6B4DyzywfSkdnu//sb03TlbPMzk/Bm8WfL
	2KI4pvJx/jg/0WgxQp4s97PtkKmuBDY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914461;
	b=r3H+hYJI9Y0xrdBYmFFOMmZRIcb7Uzc7+2ukP/csE0eytP/KRb4CEutTIkJXgiLnW+BnID
	Qc3AGdA5q1hu6nunt1PLFGRsaA8RWl50O2NFKpsO2wGCDn0Soo56TW79rSG8H8iZa/OXkI
	3UVIXkv0Ky4Mp5m47FROyJ+YBjbZn1Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FB44KVZY;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 867214392B;
	Thu,  5 Nov 2026 21:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0210E1F008A1;
	Thu,  5 Nov 2026 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914460;
	bh=yugPCJWELV1xpKfK4O7FyYZfkGoZI5YKsROj+R4zujY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FB44KVZYOhJT1YlS6i0LyQDM/pa7pB+3TCYgAO+hofV0IlW6TnQvGUQSfSiuPZqrE
	 EJtaBhoyIR6GcgaxYIK/kCqjpb22jYqP49GznKx8e3tvIOudb8xMlePEiW3wRWX3Ah
	 I9l3VYR6aPG8Jn61Cr3cct75FaSdaBoYtRTEjXL7YQhjxsH5UEb3aPzKxbub50CvvN
	 4SxfLf85UGAZ/ServkXlWuZQvXu2fK1/cMbbUKSOO8iyPghvMFyZso9HYleZV2qnv3
	 DaKdGCchqc6cHurc24RCJNc7lXJv0A10DB+7MedX92odZfrtEMDNonlWuXNfQtkCBT
	 LZ074p1E43cIw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:31:00 +0000
Subject: [PATCH 09/13] fs/proc/task_mmu: convert VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-9-0d3cd15ab75f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5492; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ulPrq/NTHlGJ37qdVO5tRAZqEZAYcflQE7jG4GXbH0A=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0uLVlyimvWeaGrUx/zn2HJkjuz4UHUiW3u65fJM
 z24X1pt0VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJeEkxMtxUW6bavNnbOteQ
 u3F2/KTPJ14+yNjx4NqFvjUzje2jD51lZHg5vTDNzqaCL2RxJ0O60EFuFt7+U1ss9s9u6aljniu
 awQ0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dc5gu633fod4f6h9qp3nt1kpgxbefzhg
X-Rspamd-Queue-Id: 59A384000B
X-Rspam-User: 
X-HE-Tag: 1793914461-892615
X-HE-Meta: U2FsdGVkX1/c3E3VKjiq+3J1bn0oA7Sd8HvNyFpPjVD37YW8JY5jJy4X+tEz5bFAT2fck+gZ4VaIftMQ2PRRv1jhoqDhPaGtTAX7hMq/sz3mGGUZnmJYvQ0qC4iNpx6xN0XJjstYNjDhSPmN0Y4vQjcYYzcvPtVgpN9zukRxFZmuJiywVQIbkBbCoeyhrnF2QblYI85KhPQTCepUvY+bH2YK2Kbnww8ehf97pxxDTwAONK5x7vVnRma4sc5IjKQwR181wEEyuMmVMxkuKb66VrPozbCY82LABBXCHdfJsGZsLyTOfueYeywqnzKNv9aMm06QS4LnvNk7J5aIe6WKxVgAIMnzYZXfdxJFwL1ha2OKfJr3opKLXwrLlpjV3+0jVvXfF8Hm4lraWe5tyfuJJpwxs3vhDlsZP9HrqwF18LGBWMx7bShRn70eTo52tNDhkzY/7+SbiGyTjO8aCKZPSKZN/ywTi53DeW616aOaur33ukF7DEKWvVuoy8xHYP2DEcShuNQB/5XO7RIdlJ9tYe++8dUCSvigDAIGlmy3ayvs8IoxWVB22tsgapOqQmw5sValAEFKh9zYBcRlp5XH8XziqV0gp0DU5PI7OyAkk5h/gCUzIgWdj8n3z/6BtXnJs0xyx70XwmyD3yHBmx9T0dq9Iin47y5LbuP74iWc6sDPgi0QnQHdEFSCcfd69WhZiuKQF3YBQNVZoWaDReNffuzM9bWJSwayt97Cq8t10HdGbiIJCbGE7z0/Ralpt/czR+tXPFUxKsKUWzEWYzwC3AmQV53VGNbxYgNEOg184v7CTXX7PFdnnkEl7wNNSD8SMEL+xkhLvdp/m/UHUefTfj6iy4cfGWTfxEu4JaK/iTAQSCTCt+DDFmAAphFXd4Rz1EzeRvpLRXFjTk2xqLiBb+rOxWPaoyJJ8uFYHhMll1MnzjIwYkRM6MQoRVrXmSnsdiv1Am5arbYtdp7YQ+Z
 hmkNm+Zh
 PgwXLTGoySvq99ooJUIjj+9o54HS/gs2qwjhygsN4npJa908sfSCqLz+cLyLlMeYw4h2rOX7Klkme6lyXkptruZVTr1nmX6VccH95L8YwQW5f2AvLFgmndmKbwSsIiMCvtxlT/Ou2b4HSqVatS9k3RpZM2EKT2blOxLexN6Vuc1slpEFQKCzkhwZEpTzHeTMlZsRe1YvkgQe0HsYVr1TGQCf+z8Z72Po0rr4EQHtEBc5NXOVr9GJvCxbVvBRArVf2p2e6xXmPXFeSjKhEXVrL3gev64JpvnSakPnFfN6cZBjDja4mTS5o7/Nquz28+O+DXxeHpNLUx2CPV3x0avu2l5Fq1K0lpnj0WV80uZJteo/lcMfaCd0ctFZFCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
VMA flags are tested directly in /proc/$pid/[s]maps, pagemap, clear_refs
and PROCMAP_QUERY.

In replacing vm_flags_clear() (which takes the VMA write lock) with
vma_clear_flags() (which does not) in clear_refs_write(), we explicitly
write lock the VMA. The mmap write lock is already held at this point.

The show_vma_header_prefix() and show_smap_vma_flags() output functions and
the thp_vma_allowable_orders() call continue to use legacy flags for the
time being.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/proc/task_mmu.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..b6e8ef15e40e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -569,18 +569,18 @@ static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *l
 
 	/* VMA permissions should satisfy query flags */
 	if (flags & PROCMAP_QUERY_VMA_FLAGS) {
-		u32 perm = 0;
+		vma_flags_t perm = EMPTY_VMA_FLAGS;
 
 		if (flags & PROCMAP_QUERY_VMA_READABLE)
-			perm |= VM_READ;
+			vma_flags_set(&perm, VMA_READ_BIT);
 		if (flags & PROCMAP_QUERY_VMA_WRITABLE)
-			perm |= VM_WRITE;
+			vma_flags_set(&perm, VMA_WRITE_BIT);
 		if (flags & PROCMAP_QUERY_VMA_EXECUTABLE)
-			perm |= VM_EXEC;
+			vma_flags_set(&perm, VMA_EXEC_BIT);
 		if (flags & PROCMAP_QUERY_VMA_SHARED)
-			perm |= VM_MAYSHARE;
+			vma_flags_set(&perm, VMA_MAYSHARE_BIT);
 
-		if ((vma->vm_flags & perm) != perm)
+		if (!vma_test_all_mask(vma, perm))
 			goto skip_vma;
 	}
 
@@ -647,13 +647,13 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	karg.vma_end = vma->vm_end;
 
 	karg.vma_flags = 0;
-	if (vma->vm_flags & VM_READ)
+	if (vma_test(vma, VMA_READ_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_READABLE;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_WRITABLE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_EXECUTABLE;
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma_test(vma, VMA_MAYSHARE_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_SHARED;
 
 	karg.vma_page_size = vma_kernel_pagesize(vma);
@@ -970,7 +970,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false, young = false, dirty = false;
 	pte_t ptent = ptep_get(pte);
@@ -1017,7 +1017,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false;
 	struct folio *folio;
@@ -1728,7 +1728,7 @@ static int clear_refs_test_walk(unsigned long start, unsigned long end,
 	struct clear_refs_private *cp = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return 1;
 
 	/*
@@ -1798,9 +1798,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for_each_vma(vmi, vma) {
-				if (!(vma->vm_flags & VM_SOFTDIRTY))
+				if (!vma_test(vma, VMA_SOFTDIRTY_BIT))
 					continue;
-				vm_flags_clear(vma, VM_SOFTDIRTY);
+				vma_start_write(vma);
+				vma_clear_flags(vma, VMA_SOFTDIRTY_BIT);
 				vma_set_page_prot(vma);
 			}
 
@@ -1904,7 +1905,7 @@ static int pagemap_pte_hole(unsigned long start, unsigned long end,
 			break;
 
 		/* Addresses in the VMA. */
-		if (vma->vm_flags & VM_SOFTDIRTY)
+		if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			err = add_to_pagemap(&pme, pm);
@@ -1976,7 +1977,7 @@ static pagemap_entry_t pte_to_pagemap_entry(struct pagemapread *pm,
 	}
 
 out:
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	return make_pme(frame, flags);
@@ -1994,7 +1995,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 	struct folio *folio = NULL;
 	int err = 0;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	if (pmd_none(pmd))
@@ -2116,7 +2117,7 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 	int err = 0;
 	pte_t pte;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
@@ -2625,13 +2626,13 @@ static int pagemap_scan_test_walk(unsigned long start, unsigned long end,
 		 */
 	}
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return 1;
 
 	if (wp_allowed)
 		vma_category |= PAGE_IS_WPALLOWED;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		vma_category |= PAGE_IS_SOFT_DIRTY;
 
 	if (!pagemap_scan_is_interesting_vma(vma_category, p))

-- 
2.56.0


