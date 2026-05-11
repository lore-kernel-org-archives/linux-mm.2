Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24978CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7AC6B008A; Mon, 11 May 2026 17:04:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068BA6B008C; Mon, 11 May 2026 17:04:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98F66B0092; Mon, 11 May 2026 17:04:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D62336B008A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:04:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29613C0C17
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:04:45 +0000 (UTC)
X-FDA: 84756368130.10.D98CDD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 789714000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:04:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hZ7iGlg9;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778533483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pG3yoZf+TLyrfVD6e7EJeV+jwU3u8DaAMf8KEm/ea6M=;
	b=HthlWwvK98zLTSkal4Xs8Ut95dGnV+m2SEM5iT4em3glsmDUp7YxcYwYQFZrhy7++L+NVw
	JEGXyTOQsgvpd0ZXvvzJAjUxaMFBGOhJSnLbkg3+cvw1hojGQs0JNq74BEcWvVlAXyKt0M
	hF+lUaIFhIUhMQ0GP632FUQTLQUAq2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778533483; a=rsa-sha256;
	cv=none;
	b=4AzDVJqXw54hpz/GBk2Qyml+gfd18t243Z5LqINL/EFuLp64WageY1EjPo0oaszRjd01pK
	mVp2S1I+L880gCa+n7aWeH0vQuYYPAbqRMt1LZq6FPFHjXH7zAM+ef5sMADGvjFxWURAW1
	47x+JSkCjTc8H0UeVCtn5e7I/qRY/cY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hZ7iGlg9;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E3A46001A;
	Mon, 11 May 2026 21:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99007C2BCB0;
	Mon, 11 May 2026 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778533482;
	bh=Vz8sfjIZyexmCXOFva8KkOYGJXssUjTt9qoZfn0Kr0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hZ7iGlg9nP7t3RQWbYXON9En367yGxeWtYIvKjI3igZRzzkkrdgLmxURdi8Fx1J8y
	 kxoJZ/15N+fSX20WF0oQEQptFHbAlAM/dCw2PTHivO85cyvItzGX2divIz6DBu+SKx
	 hW9lTcvHs3gI2qtVudDFm1PZsQNEGHqLF5WYyS9E=
Date: Mon, 11 May 2026 14:04:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
 jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 00/14] khugepaged: mTHP support
Message-Id: <20260511140440.d8a71b4774d13537b3977d19@linux-foundation.org>
In-Reply-To: <20260511185817.686831-1-npache@redhat.com>
References: <20260511185817.686831-1-npache@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 789714000A
X-Stat-Signature: k6i9z1fd1usbn9mojo39ungtwm9sxqsa
X-Rspam-User: 
X-HE-Tag: 1778533483-205920
X-HE-Meta: U2FsdGVkX1+LuCmYnHW2EEeC+LUeylAAtfsdWJmMUo3j+bFs3/iIYc0tt7RU/+kMCIab0pldotposK/g/jipjwlpnyv8tEnyyRUHeC9IoIZ7jnxx8djqdZGX0+p1MHPq68bREnkStDBvqTr/XAYNQUuDyHgzfjG/mDtolAkwbgllWMk/L6Kd2t/5YoRzU8Aa4nv0FhypWNxuxFZU8IDbc6PHTdhQFG4rDX45BgzU+ykr4lISaEWlilijZz1UzW14Vz/3G8MyRRak/M9aMtWwMDMVKmwgG+xhf6m+zUSTVia2slnkae+h4jbM8++rVGM3RJOL1pZM1a/MntpEdKvp4JSjaN3E6G/w7ErhWlDXAdIzrYKZXe1viYt7vfRVQjrm60uVVBHlI66i99B9U5omfs0Il/yKrwD4jRA3EbsYgH6aUo4MTyu8l275HwuX36VMxJZICElbS377y/UHU7dY90644jt1HaJlY9v+O1MKY/BUlEj8Rul16D5b2f+n/YOnzhBnI19QfD/rWNu32AUzEJoIgAgfIzAdjOTpkIaj8ku9iLVAtDAHSdpg5zDMEjQ1ayp/z28LWattXFvuspt+oRl02qdgFknj5NtZhVZ7qKSh5jYqwww7aho8c2CFHV1HhGxbvKt66d7sFaom5zID7+duXAtQuPnaLWd4/cm5Wf1W63XnKEhyZBEKv/tEJd6n4P4V2x4fODffJ985+iFqyAilhVdZS+M9pB2I2XrbBQT5zsT2KisgBlHQIbikWVY0/NgPLxV/Nlub1vZoi2Y1hJjb7msk+dxiWjE0yB766Zu0JWf0IcmOfBEketGTfDR1tYloMS2kECl54jYktuB1urvUDCOM6m+BONRZGClAB0cSDvrEjOfk6Ce7KDBeUEdRZDmefSbURCoNIWBmriAGEDG8VwPuO9p/cMQcKp5T+uFOf4fxtLaTV+XziDtL6kB0u5wR55TQETJ+FCAkAKH
 fAHnf+bV
 jejx5D5RZc5fTbGhk4BeLa66rHcjlJRBFtrVydnLhJ3z6YcRGUkFIe9p+hr37jYeGQSiD5N8nyfvp8BynQLJ4Cx/c1yzpEcJTYEIviGGqL4I6P0sGfCHg08Miu850S47JpkArnSoobSLEFyJlBj1MWSRVAOl4NNt2g2lBsdRMy0V977cfXaZSbat6g7chpqaNx+uTHjMerYifyWs/UxWOtdnpaRDN587+7VFer0ejUkG5RAavGr2F3DsGdqEM8PC+pOM5XCquM/JB8JhWwTt930ROBqhY6GElVBVR1PsKAYaCA7VvDfbgmoXwIRsiWC/DEDuu5wEc8BsXxs5j3b6R+5KaU7BYW9z9p+hU5iyqm/Jyx/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 12:58:00 -0600 Nico Pache <npache@redhat.com> wrote:

> The following series provides khugepaged with the capability to collapse
> anonymous memory regions to mTHPs.

Thanks, I've updated mm.git's mm-new branch to this version.

> V17 Changes:
> - Added Acks/RB
> - New patch(5): split the mmap_read_unlock() locking contract change out of
>   "generalize collapse_huge_page" into its own patch; add a comment
>   documenting the enter/exit-with-lock-dropped contract (Usama, David)
> - [patch 03] Add const to max_ptes_none/shared/swap variables; improve the
>   three helper docstrings; replace the paragraphs with inline comments;
>   note that sysctl values are now snapshotted once per scan (Usama, David)
> - [patch 04] Add SCAN_INVALID_PTES_NONE result code and return it instead
>   of SCAN_FAIL when collapse_max_ptes_none() returns -EINVAL (Usama);
>   snapshot khugepaged_max_ptes_none into a local variable to fix race on
>   the two comparisons (Usama); clean up mTHP docstring paragraphs into
>   inline comments; fix commit message wording (David)
> - [patch 06] Remove /* PMD collapse */ and /* mTHP collapse */ comments
>   (David); move const declarations to top of variable list (David); add
>   comment explaining that map_anon_folio_pte_nopf() calls set_ptes under
>   pmd_ptl and is safe because PMD is expected to be none (Usama)
> - [patch 08] Shorten sysfs counter documentation for
>   collapse_exceed_swap/shared_pte to concise one-liners; trim
>   collapse_exceed_none_pte description; fix "dont" → "do not" (David)
> - [patch 10] Keep vm_flags parameter in khugepaged_enter_vma() and
>   collapse_allowable_orders() rather than dropping it and reading
>   vma->vm_flags internally; pass vm_flags explicitly at all three
>   collapse_allowable_orders() call sites (David, sashskio)
> - [patch 11] Fix MTHP_STACK_SIZE: was exponential (~128); correct formula
>   is (height + 1) for a DFS on a binary tree rewrite comment to explain
>   the DFS sizing (sashskio)
> - [patch 12] Replace SCAN_PAGE_LRU with SCAN_PAGE_LAZYFREE in the
>   "goto next_order" early-bail cases; non-LRU page failures cannot be
>   recovered at any order and belong in the default (return) path
> - [patch 13] Use tva_flags == TVA_KHUGEPAGED (strict equality) instead of
>   tva_flags & TVA_KHUGEPAGED; flatten nested if into single condition;
>   retain vm_flags parameter; pass vm_flags to collapse_allowable_orders()

Here's how v17 altered mm.git:


 Documentation/admin-guide/mm/transhuge.rst |   24 ---
 include/linux/khugepaged.h                 |    6 
 include/trace/events/huge_memory.h         |    3 
 mm/huge_memory.c                           |    2 
 mm/khugepaged.c                            |  152 ++++++++++---------
 mm/vma.c                                   |    6 
 tools/testing/vma/include/stubs.h          |    3 
 7 files changed, 99 insertions(+), 97 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~b
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -725,27 +725,17 @@ nr_anon_partially_mapped
 
 collapse_exceed_none_pte
        The number of collapse attempts that failed due to exceeding the
-       max_ptes_none threshold. For mTHP collapse, Currently only max_ptes_none
-       values of 0 and (HPAGE_PMD_NR - 1) are supported. Any other value will
-       emit a warning and no mTHP collapse will be attempted. khugepaged will
-       try to collapse to the largest enabled (m)THP size; if it fails, it will
-       try the next lower enabled mTHP size. This counter records the number of
-       times a collapse attempt was skipped for exceeding the max_ptes_none
-       threshold, and khugepaged will move on to the next available mTHP size.
+       max_ptes_none threshold.
 
 collapse_exceed_swap_pte
-       The number of anonymous mTHP PTE ranges which were unable to collapse due
-       to containing at least one swap PTE. Currently khugepaged does not
-       support collapsing mTHP regions that contain a swap PTE. This counter can
-       be used to monitor the number of khugepaged mTHP collapses that failed
-       due to the presence of a swap PTE.
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_swap threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one swap PTE.
 
 collapse_exceed_shared_pte
-       The number of anonymous mTHP PTE ranges which were unable to collapse due
-       to containing at least one shared PTE. Currently khugepaged does not
-       support collapsing mTHP PTE ranges that contain a shared PTE. This
-       counter can be used to monitor the number of khugepaged mTHP collapses
-       that failed due to the presence of a shared PTE.
+       The number of collapse attempts that failed due to exceeding the
+       max_ptes_shared threshold. For non-PMD orders this occurs if a mTHP range
+       contains at least one shared PTE.
 
 As the system ages, allocating huge pages may be expensive as the
 system uses memory compaction to copy data around memory to free a
--- a/include/linux/khugepaged.h~b
+++ a/include/linux/khugepaged.h
@@ -13,7 +13,8 @@ extern void khugepaged_destroy(void);
 extern int start_stop_khugepaged(void);
 extern void __khugepaged_enter(struct mm_struct *mm);
 extern void __khugepaged_exit(struct mm_struct *mm);
-extern void khugepaged_enter_vma(struct vm_area_struct *vma);
+extern void khugepaged_enter_vma(struct vm_area_struct *vma,
+				 vm_flags_t vm_flags);
 extern void khugepaged_min_free_kbytes_update(void);
 extern bool current_is_khugepaged(void);
 void collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
@@ -37,7 +38,8 @@ static inline void khugepaged_fork(struc
 static inline void khugepaged_exit(struct mm_struct *mm)
 {
 }
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
+					vm_flags_t vm_flags)
 {
 }
 static inline void collapse_pte_mapped_thp(struct mm_struct *mm,
--- a/include/trace/events/huge_memory.h~b
+++ a/include/trace/events/huge_memory.h
@@ -39,7 +39,8 @@
 	EM( SCAN_STORE_FAILED,		"store_failed")			\
 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
 	EM( SCAN_PAGE_FILLED,		"page_filled")			\
-	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
+	EM(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")	\
+	EMe(SCAN_INVALID_PTES_NONE,	"invalid_ptes_none")
 
 #undef EM
 #undef EMe
--- a/mm/huge_memory.c~b
+++ a/mm/huge_memory.c
@@ -1571,7 +1571,7 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	ret = vmf_anon_prepare(vmf);
 	if (ret)
 		return ret;
-	khugepaged_enter_vma(vma);
+	khugepaged_enter_vma(vma, vma->vm_flags);
 
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
--- a/mm/khugepaged.c~b
+++ a/mm/khugepaged.c
@@ -61,6 +61,7 @@ enum scan_result {
 	SCAN_COPY_MC,
 	SCAN_PAGE_FILLED,
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
+	SCAN_INVALID_PTES_NONE,
 };
 
 #define CREATE_TRACE_POINTS
@@ -101,16 +102,15 @@ static struct kmem_cache *mm_slot_cache
 
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
 /*
- * The maximum number of mTHP ranges that can be stored on the stack.
- * This is calculated based on the number of PTE entries in a PTE page table
- * and the minimum mTHP order.
+ * mthp_collapse() does an iterative DFS over a binary tree, from
+ * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
+ * size needed for a DFS on a binary tree is height + 1, where
+ * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
  *
- * ilog2 is needed in place of HPAGE_PMD_ORDER due to some architectures
- * (ie ppc64le) not defining HPAGE_PMD_ORDER until after build time.
- *
- * At most there will be 1 << (PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER) mTHP ranges
+ * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
+ * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
  */
-#define MTHP_STACK_SIZE	(1UL << (ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER))
+#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
 
 /*
  * Defines a range of PTE entries in a PTE page table which are being
@@ -380,89 +380,87 @@ static bool pte_none_or_zero(pte_t pte)
 }
 
 /**
- * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
+ * collapse_max_ptes_none - Calculate maximum allowed none-page or zero-page
+ * PTEs for the given collapse operation.
  * @cc: The collapse control struct
  * @vma: The vma to check for userfaultfd
  * @order: The folio order being collapsed to
  *
- * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
- * empty page. For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the
- * configured khugepaged_max_ptes_none value.
- *
- * For mTHP collapses, we currently only support khugepaged_max_pte_none values
- * of 0 or (KHUGEPAGED_MAX_PTES_LIMIT). Any other value will emit a warning and
- * no mTHP collapse will be attempted
- *
- * Return: Maximum number of empty PTEs allowed for the collapse operation
+ * Return: Maximum number of none-page or zero-page PTEs allowed for the
+ * collapse operation.
  */
 static int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
+	unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.
 	if (vma && userfaultfd_armed(vma))
 		return 0;
+	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	// for PMD collapse, respect the user defined maximum.
 	if (is_pmd_order(order))
-		return khugepaged_max_ptes_none;
+		return max_ptes_none;
 	/* Zero/non-present collapse disabled. */
-	if (!khugepaged_max_ptes_none)
+	if (!max_ptes_none)
 		return 0;
-	if (khugepaged_max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
+	// for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
+	// scale the maximum number of PTEs to the order of the collapse.
+	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
 
+	// We currently only support max_ptes_none values of 0 or KHUGEPAGED_MAX_PTES_LIMIT.
+	// Emit a warning and return -EINVAL.
 	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
 		      KHUGEPAGED_MAX_PTES_LIMIT);
 	return -EINVAL;
 }
 
 /**
- * collapse_max_ptes_shared - Calculate maximum allowed shared PTEs for collapse
+ * collapse_max_ptes_shared - Calculate maximum allowed PTEs that map shared
+ * anonymous pages for the given collapse operation.
  * @cc: The collapse control struct
  * @order: The folio order being collapsed to
  *
- * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
- * shared page.
- *
- * For mTHP collapses, we currently dont support collapsing memory with
- * shared memory.
- *
- * Return: Maximum number of shared PTEs allowed for the collapse operation
+ * Return: Maximum number of PTEs that map shared anonymous pages for the
+ * collapse operation
  */
 static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
+	// for MADV_COLLAPSE, do not restrict the number of PTEs that map shared
+	// anonymous pages.
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	// for mTHP collapse do not allow collapsing anonymous memory pages that
+	// are shared between processes.
 	if (!is_pmd_order(order))
 		return 0;
-
+	// for PMD collapse, respect the user defined maximum.
 	return khugepaged_max_ptes_shared;
 }
 
 /**
- * collapse_max_ptes_swap - Calculate maximum allowed swap PTEs for collapse
+ * collapse_max_ptes_swap - Calculate the maximum allowed non-present PTEs or the
+ * maximum allowed non-present pagecache entries for the given collapse operation.
  * @cc: The collapse control struct
  * @order: The folio order being collapsed to
  *
- * If we are not in khugepaged mode use HPAGE_PMD_NR to allow any
- * swap page.
- *
- * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
- * khugepaged_max_ptes_swap value.
- *
- * For mTHP collapses, we currently dont support collapsing memory with
- * swapped out memory.
- *
- * Return: Maximum number of swap PTEs allowed for the collapse operation
+ * Return: Maximum number of non-present PTEs or the maximum allowed non-present
+ * pagecache entries for the collapse operation.
  */
 static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
+	// for MADV_COLLAPSE, do not restrict the number PTEs entries or
+	// pagecache entries that are non-present.
 	if (!cc->is_khugepaged)
 		return HPAGE_PMD_NR;
+	// for mTHP collapse do not allow any non-present PTEs or pagecache entries.
 	if (!is_pmd_order(order))
 		return 0;
-
+	// for PMD collapse, respect the user defined maximum.
 	return khugepaged_max_ptes_swap;
 }
 
@@ -478,7 +476,7 @@ int hugepage_madvise(struct vm_area_stru
 		 * register it here without waiting a page fault that
 		 * may not happen any time soon.
 		 */
-		khugepaged_enter_vma(vma);
+		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
@@ -579,26 +577,26 @@ void __khugepaged_enter(struct mm_struct
 
 /* Check what orders are allowed based on the vma and collapse type */
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
-		enum tva_type tva_flags)
+		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
 
 	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
-	if ((tva_flags & TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+	if ((tva_flags == TVA_KHUGEPAGED) && vma_is_anonymous(vma))
 		orders = THP_ORDERS_ALL_ANON;
 	else
 		orders = BIT(HPAGE_PMD_ORDER);
 
-	return thp_vma_allowable_orders(vma, vma->vm_flags, tva_flags, orders);
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
-void khugepaged_enter_vma(struct vm_area_struct *vma)
+void khugepaged_enter_vma(struct vm_area_struct *vma,
+			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_enabled()) {
-		if (collapse_allowable_orders(vma, TVA_KHUGEPAGED))
-			__khugepaged_enter(vma->vm_mm);
-	}
+	    collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED) &&
+	    hugepage_enabled())
+		__khugepaged_enter(vma->vm_mm);
 }
 
 void __khugepaged_exit(struct mm_struct *mm)
@@ -683,7 +681,7 @@ static enum scan_result __collapse_huge_
 	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
 
 	if (max_ptes_none < 0)
-		return result;
+		return SCAN_INVALID_PTES_NONE;
 
 	for (_pte = pte; _pte < pte + nr_pages;
 	     _pte++, addr += PAGE_SIZE) {
@@ -905,6 +903,7 @@ static void __collapse_huge_page_copy_fa
 {
 	const unsigned long nr_pages = 1UL << order;
 	spinlock_t *pmd_ptl;
+
 	/*
 	 * Re-establish the PMD to point to the original page table
 	 * entry. Restoring PMD needs to be done prior to releasing
@@ -944,6 +943,7 @@ static enum scan_result __collapse_huge_
 	const unsigned long nr_pages = 1UL << order;
 	unsigned int i;
 	enum scan_result result = SCAN_SUCCEED;
+
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
@@ -1263,10 +1263,20 @@ static enum scan_result alloc_charge_fol
 	return SCAN_SUCCEED;
 }
 
+/*
+ * collapse_huge_page expects the mmap_read_lock to be dropped before
+ * entering this function. The function will also always return with the lock
+ * dropped. The function starts by allocation a folio, which can potentially
+ * take a long time if it involves sync compaction, and we do not need to hold
+ * the mmap_lock during that. We must recheck the vma after taking it again in
+ * write mode.
+ */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
 		int referenced, int unmapped, struct collapse_control *cc,
 		unsigned int order)
 {
+	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
+	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
 	LIST_HEAD(compound_pagelist);
 	pmd_t *pmd, _pmd;
 	pte_t *pte = NULL;
@@ -1277,8 +1287,6 @@ static enum scan_result collapse_huge_pa
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	bool anon_vma_locked = false;
-	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
-	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
 
 	result = alloc_charge_folio(&folio, mm, cc, order);
 	if (result != SCAN_SUCCEED)
@@ -1399,11 +1407,16 @@ static enum scan_result collapse_huge_pa
 	__folio_mark_uptodate(folio);
 	spin_lock(pmd_ptl);
 	WARN_ON_ONCE(!pmd_none(*pmd));
-	if (is_pmd_order(order)) { /* PMD collapse */
+	if (is_pmd_order(order)) {
 		pgtable = pmd_pgtable(_pmd);
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
-	} else { /* mTHP collapse */
+	} else {
+		/*
+		 * set_ptes is called in map_anon_folio_pte_nopf with the
+		 * pmd_ptl lock still held; this is safe as the PMD is expected
+		 * to be none. The pmd entry is then repopulated below.
+		 */
 		map_anon_folio_pte_nopf(folio, pte, vma, start_addr, /*uffd_wp=*/ false);
 		smp_wmb(); /* make PTEs visible before PMD. See pmd_install() */
 		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
@@ -1538,12 +1551,12 @@ static int mthp_collapse(struct mm_struc
 			case SCAN_EXCEED_SHARED_PTE:
 			case SCAN_PAGE_LOCK:
 			case SCAN_PAGE_COUNT:
-			case SCAN_PAGE_LRU:
 			case SCAN_PAGE_NULL:
 			case SCAN_DEL_PAGE_LRU:
 			case SCAN_PTE_NON_PRESENT:
 			case SCAN_PTE_UFFD_WP:
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
+			case SCAN_PAGE_LAZYFREE:
 				goto next_order;
 			/* Cases where no further collapse is possible */
 			default:
@@ -1569,6 +1582,10 @@ static enum scan_result collapse_scan_pm
 		struct vm_area_struct *vma, unsigned long start_addr,
 		bool *lock_dropped, struct collapse_control *cc)
 {
+	int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
+	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1580,10 +1597,6 @@ static enum scan_result collapse_scan_pm
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE, unmapped = 0;
-	int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
 
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
@@ -1597,7 +1610,7 @@ static enum scan_result collapse_scan_pm
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 
-	enabled_orders = collapse_allowable_orders(vma, tva_flags);
+	enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
 
 	/*
 	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
@@ -1757,12 +1770,7 @@ static enum scan_result collapse_scan_pm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
-		/*
-		 * Before allocating the hugepage, release the mmap_lock read lock.
-		 * The allocation can take potentially a long time if it involves
-		 * sync compaction, and we do not need to hold the mmap_lock during
-		 * that. We will recheck the vma after taking it again in write mode.
-		 */
+		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
 		nr_collapsed = mthp_collapse(mm, start_addr, referenced, unmapped,
 					      cc, enabled_orders);
@@ -2657,14 +2665,14 @@ static enum scan_result collapse_scan_fi
 		unsigned long addr, struct file *file, pgoff_t start,
 		struct collapse_control *cc)
 {
+	const int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
+	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	enum scan_result result = SCAN_SUCCEED;
-	int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 
 	present = 0;
 	swap = 0;
@@ -2867,7 +2875,7 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!collapse_allowable_orders(vma, TVA_KHUGEPAGED)) {
+		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3177,7 +3185,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!collapse_allowable_orders(vma, TVA_FORCED_COLLAPSE))
+	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -989,7 +989,7 @@ static __must_check struct vm_area_struc
 		goto abort;
 
 	vma_set_flags_mask(vmg->target, sticky_flags);
-	khugepaged_enter_vma(vmg->target);
+	khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 	vmg->state = VMA_MERGE_SUCCESS;
 	return vmg->target;
 
@@ -1110,7 +1110,7 @@ struct vm_area_struct *vma_merge_new_ran
 	 * following VMA if we have VMAs on both sides.
 	 */
 	if (vmg->target && !vma_expand(vmg)) {
-		khugepaged_enter_vma(vmg->target);
+		khugepaged_enter_vma(vmg->target, vmg->vm_flags);
 		vmg->state = VMA_MERGE_SUCCESS;
 		return vmg->target;
 	}
@@ -2589,7 +2589,7 @@ static int __mmap_new_vma(struct mmap_st
 	 * call covers the non-merge case.
 	 */
 	if (!vma_is_anonymous(vma))
-		khugepaged_enter_vma(vma);
+		khugepaged_enter_vma(vma, map->vm_flags);
 	*vmap = vma;
 	return 0;
 
--- a/tools/testing/vma/include/stubs.h~b
+++ a/tools/testing/vma/include/stubs.h
@@ -183,7 +183,8 @@ static inline bool mpol_equal(struct mem
 	return true;
 }
 
-static inline void khugepaged_enter_vma(struct vm_area_struct *vma)
+static inline void khugepaged_enter_vma(struct vm_area_struct *vma,
+			  vm_flags_t vm_flags)
 {
 }
 
_


