Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A678606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LpE6INQ2
Received: by kanga.kvack.org (Postfix)
	id 907056B05B7; Thu,  5 Nov 2026 16:32:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE746B05B8; Thu,  5 Nov 2026 16:32:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F47C6B05B9; Thu,  5 Nov 2026 16:32:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B0A6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:32:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E39A5C0C1C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:32:16 +0000 (UTC)
X-FDA: 85402363872.11.7DB2E67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 09AD440012
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:32:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpE6INQ2;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzAJuWtp08ycZNcRlNLNBepst97TvXc/S7lvgMY4+qc=;
	b=EABwAOPO8dXrd8qy0CniOD7z+UjlEfWzaKzt1H531OeWmn1V1FjQPdTEzDx/FRuHKCNDIQ
	7QiJ0OEomsknTeQTnpvLaOp40XroZHFwxNPBVpkPfJrI9vng8vy3TUXq8wWoNb0XkvrVWF
	LDML7hVJQ2wEshURhC3Tj7o+je4h+pk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914335;
	b=z0El323WfN492NpBxeyLdN1OpJ97GeE9eEghG37i7qlPS65XVM0PQy0M2e3N/ufWADyeaY
	MCKGfdFRd+F/H/Ap1rvMJfxejf2Y5R32AsiW6l+G1E6o5ZR8Cg4yKfnDebpRDnCg5Qjk4D
	vUMFuphNunABq7SpawpD+tAytEQ8yLU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LpE6INQ2;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAB2E42B6D;
	Thu,  5 Nov 2026 21:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8271F0089F;
	Thu,  5 Nov 2026 21:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914333;
	bh=hzAJuWtp08ycZNcRlNLNBepst97TvXc/S7lvgMY4+qc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LpE6INQ28oxaDGfOupj/I9YluB+UQugAH5I3JpI7rSwRCO/BF35M2Rzi99vFcu3Ah
	 0hnbTK820Cci+SGakQ0570h3z6e0/kCnG5Z9Nhq5+h6rqRyo106yH9wHsEX4NVonfJ
	 Bo6kbNppZcbxkEWd8JEvkOxr2G6shRFwjJC4lLD3VyW0JtzfIYcauU+CpQyqmV4yxW
	 GVr6unqhSotyQVysxVk24xubu4MZXHasxZt+oN/hbh7xAhZtui42NoVy2NS3dEVCFD
	 b63NM0Tyzuz0UMXjElTukk9vUIpeYfX9JNAtuyqjWwezfYTudwqI8c2ErvWfPjpTYX
	 0BJMIYbdKpRPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:53 +0000
Subject: [PATCH 02/13] mm/filemap: convert fault and readahead logic to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4267; i=ljs@kernel.org;
 h=from:subject:message-id; bh=aLGopd4z1uVC7ZtIXGCKSy3SWCLXYQcORFJokfXjLww=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF027WG8Q/mUYLZ3WUvN+2OzliZmCgpVxT1m7yw71
 7PA96BcRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACay+Dcjw73gpzevbdoWvnJr
 pq7BTsOz+hvdDld/td+l2hRiMf9i9BlGhnNdMQbP2N5LeJz5ofS7mq9b41O+1aUTXi1HQ5r0N2l
 N4QUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 09AD440012
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gppwg1ykyzpp6jx7b86f9edrwyozrsq4
X-Rspam-User: 
X-HE-Tag: 1793914334-966254
X-HE-Meta: U2FsdGVkX190tp1eVd3/LfoAUs1P62igKxASA5neIq8GK32ldVoDMuY6hi2Sk/2gceBdzNWEaEJxz7xjOBXLYslxYbv5eUQ5drpzGtzdsZHVTq1S7SNGTNRK6pnXaScN/2Ih68QsN1c8/As4s9ANVyEhH5bLLy9/dJXl7Rz0GdZgM9Fxm70gVDKJft3vvZvaGuZJNHeHQ1tn/D415z+JIYy282uIbYmINxtPC65XyfDJqZ5fUysrKok2dQp+DyxXxwSucLlaSaPaXIi+8CyBZBsdoVNo+5MphqJN1Ie++1mFN40WlvbJx8nXeiA8u0n61LLUh7djSLOcJRljAFsDnBWZKvo+24xAG3JY50Ug752yQaZwWdTu904Ctx9mJNjSWnvNsb3EeRfXrEw5GUhBtIMjcMtqhwTjU5v+zUkLtuNucAm/GIXJcPMCDSFiq26GaMDoDu1vemo9Qd2xjbCYrrulQEUBl3wHKkE7AV+KHHNSrd7AlAPfA4AACfA5gTZBF/i6Q6iPzXTcB6g68PulhCy0aDpTid2f07KiaA0Hr+gie/++K9BgnFCZC+zdFow66wQhm4UdHKDJTzZtHHEjWeGpQoD2Y12TJIuEAAeG9VwxVew5P7a+3mumXvVFfRhiSOvsLrs2UtKA7Kj5ZyAeQ/7dLbkAJ1osX3NpesERdRiWHkHcN/sBeUgrLTCpDQQVdLIHKJ26wSTg0e6PDIZkgGsKe6h+9tNYUBmqROGpIJpmfYbmukeHygabLb0SHqQ+2TVN9AxYIlb366uYw2T4AbwZ7HAlBFvJA8ISJM6XoH+4Xv86ckAMBAXYFNk6Sl5rkuO6UVrqeP+WJC8wMA4z5vIR023/jSaVlqAGNfD8BsiDxKr9HHrbIWl0KE+W/fQmGFkMZnPUmNQ4mkPOYl5Nv+bHKiyb4gpdUDWe0JBFpyKuiYv2FJVsyN4vcjuy6gWtP+TQOxOmr3btE6T/Qbp
 WfVnc/4l
 SZqYYPqodNdphOB7P/xQfmzzZsFckF359VY4twArdr+mWK6bG6ZRR7hdfLT4SZGz2Wq0t0Sbk7HIkEUMY660Csl4hKFg00enPnP59KqFslakZwucnkx0gKmJwnHd2qtnnvlb3iMOKnZWEUdAEy3MeXoA+fXftsUc0VFGGNc4xS7hXdabkYIfAIaWYgyJyhvL/M7M0gPGen7eCvZ2piLBTNgf0K1AeSKmfszFT+6kpN3qAy/E/M0Tov6Qm1jB8AvxIWNOpBWs2vCAMDjI6qaDWH0t7hK49zX7nukZADisZUN44MrfpT5RPvP49h3hh5jNnqCvrfOLtsyGhuQ8v04X+J3iJpK0IJc/UBcsW9s62Q5/fWlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
file fault and mmap readahead logic.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/filemap.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..d8b538bd1404 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3351,13 +3351,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	struct vm_area_struct *vma = vmf->vma;
 	bool force_thp_readahead = false;
 	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    vma_test(vma, VMA_HUGEPAGE_BIT)) {
 		/*
 		 * Cap max THP order at 2MB: this is the common PMD-sized
 		 * hugepage size, and it avoids memory pressure from very
@@ -3377,20 +3378,21 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * If we don't want any read-ahead, don't bother.
 		 * VM_EXEC case below is already intended for random access.
 		 */
-		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
+		if (vma_test(vma, VMA_RAND_READ_BIT) &&
+		    !vma_test(vma, VMA_EXEC_BIT))
 			return fpin;
 
 		if (!ra->ra_pages)
 			return fpin;
 
-		if (vm_flags & VM_SEQ_READ) {
+		if (vma_test(vma, VMA_SEQ_READ_BIT)) {
 			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 			page_cache_sync_ra(&ractl, ra->ra_pages);
 			return fpin;
 		}
 	}
 
-	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	if (!vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3414,7 +3416,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
-		if (!(vm_flags & VM_RAND_READ))
+		if (!vma_test(vma, VMA_RAND_READ_BIT))
 			ra->size *= 2;
 		ra->async_size = folio_nr_pages;
 		ra->order = thp_order;
@@ -3422,7 +3424,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		return fpin;
 	}
 
-	if (vm_flags & VM_EXEC) {
+	if (vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
 		 * executable memory. This can often be beneficial to
@@ -3477,7 +3479,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	unsigned short mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
+	if (vma_test(vmf->vma, VMA_RAND_READ_BIT) || !ra->ra_pages)
 		return fpin;
 
 	/*
@@ -3491,7 +3493,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	    !vma_test_any(vmf->vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3524,7 +3526,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 	 * scenarios. Recheck the PTE without PT lock firstly, thereby reducing
 	 * the number of times we hold PT lock.
 	 */
-	if (!(vma->vm_flags & VM_LOCKED))
+	if (!vma_test(vma, VMA_LOCKED_BIT))
 		return 0;
 
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
@@ -4000,7 +4002,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+		    !vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);

-- 
2.56.0


