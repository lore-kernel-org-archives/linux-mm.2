Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DDFEE20A6
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 13:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4916B0096; Fri,  6 Feb 2026 08:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386386B0098; Fri,  6 Feb 2026 08:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2922D6B0099; Fri,  6 Feb 2026 08:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2496B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:57:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B35EC5634D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:57:01 +0000 (UTC)
X-FDA: 84414183042.23.B8B3F07
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id CD739180007
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:56:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770386220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=5Zs+DR2LmyOtpGzEiKrxzZCtBbHCAI3j2ET7S259SQU=;
	b=wtggwpRSu8ld79E4/aTeYHckHbGrkiMRMcU7UCOgpUZ26ENyoa0v8BwXWAvdx/mjVVf+36
	apLCGewNfOyLGfRupxSDpgKTTgTDc45VFHHF5ze1VmLGfgOx8dUnTmb466tFDjF3TAU2Sw
	BFYue6XqayVfolWRTqNeiVo1PJ0whWk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770386220; a=rsa-sha256;
	cv=none;
	b=IM9TSJgQLJDL+zGI053ynkhGcTGsPYy+KEhCPpRhuTbVH4WhiDQphsp8D6vzs6KPFwGXZi
	0tNDfAJEHoHoxQYOlRkqi/PzyHErdpzXMwPpzXJGWBwWEy/VMxjr6VFvjMQnznyA3KISt3
	sLij4iCKJcmnDRDYYfFEWpxyKOrm5P8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4E7B6339;
	Fri,  6 Feb 2026 05:56:52 -0800 (PST)
Received: from localhost.localdomain (unknown [10.163.132.30])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1E36F3F632;
	Fri,  6 Feb 2026 05:56:53 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	kirill@shutemov.name,
	willy@infradead.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH] mm: map maximum pages possible in finish_fault
Date: Fri,  6 Feb 2026 19:26:48 +0530
Message-Id: <20260206135648.38164-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD739180007
X-Stat-Signature: ojnj3y1p1obnzfxc3953jmx78g9d5x4s
X-Rspam-User: 
X-HE-Tag: 1770386219-600528
X-HE-Meta: U2FsdGVkX1/3t5uQgwTVBLyJ0IC3lZgSkJo7QkRjdH+OnyFYCHypLt92IgaUDs1md7Q8F+nLWzkXhnDhmM1jTnHHCmP/hmICSlYFtxmT7PRToBxmyITQY2KV56XkgV9n9LptEFOrrEOHYztormMA9Qn8POsqCStmx2KqBDM1RQ1kl7OO5rqx0KJvV1aWvps19g2DJnniv4AzN8/lLakoGLaC77nfu4ifmKvEWyVSORKzl4erx2ysT4+8zXLfULQoNAyM8X5s3lcRZ5GBiUAWqq4DOoozTQig/avsl6wdvAa+nkujtf4Le1I4Kb4U55LELoUggRs4o1OtqgNYTJHSdXhBq2g2tZuk3NeqeICYNrDbVtkjly8vbgH/vKi3JgIQx45PXc7G1TzpXAdtz0w3d6UQFQFD6vKUfCkJWFGzzCzMsLkbRXTPRG/q3xyNil37+9cfFRqwtwo8Q77NBPTsalT2vAxtjnqa8E7Pjl7l2QIWKdbBIh2XvDwYdE4Iw1BqvJk0ew0IJ5cS5A12tW/8cBSWON6ZGCYo5ryWpg/w7vcKoRvBiLTyHCjxwO6Y2AfMGe3XZ8v3bKKN3pJk6m7D+Aag+QwLL7fqhNLyhu/DZttjngTKPyjUGQ5/5iunMo5xg0nTuo9SsnrD01zUkbjpGseCLA1Y8akA5CNUwmMocucP0BH6TUIWTEpxCJWtd1IZ0Bk2c1GVlLB01oe7P1Yx5/e7USjXyW2h2Hy3Qfrg6tWyh2WFOwhBE5sz8kvPIVwAMfsmi3k/OKKRfLwPzOqLixUNX8CALqU7qcQwpw2jRIPiGFsz5pGqHVkdInl+UKpKb5fypRQS5vO3kf9QtKvEMLKJe4ZnwgigMeyEKC780EMdiUWTf16hW9swqJe/FLYmDMKPP56W4sMsIy9EglaKS9dIobDKdUjxhbvhkY+l2lVxtaVU6NyuJRW+xEJzzZ1gcHcmAZsa972WSZH+cq3
 ChXZHeXT
 Z5K/Lps4Y7dDG5FIgkDhg64hXiC2Mmzcm5BAQNUyOt0YNECmv0+Zeed8cx8OIbPi2g/4WDSQSlgnDphdHINgOlvA1NKFuyCdhwYDpc3LjHEuNduIBNppEhsTo7eysw86orS30iRLRiNhtPveoNcS/hJc5URSLXw+CvF7XVQ9gSCUjzD33AiEMgiG5/OlWXIFnhm6GjVKYcYKpVgw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suppose a VMA of size 64K, maps a file/shmem-file at index 0, and that the
pagecache at index 0 contains an order-9 folio. If do_fault_around is able
to find this folio, filemap_map_pages ultimately maps the first 64K half of
the folio into the pagetable, thus reducing the number of future page
faults. If fault-around fails to satisfy the fault, or if it is a write
fault, then we use vma->vm_ops->fault to find/create the folio, followed by
finish_fault to map the folio into the pagetable. On encountering a similar
large folio crossing the VMA boundary, finish_fault currently falls back
to mapping only a single page.

Align finish_fault with filemap_map_pages, and map as many pages as
possible, without crossing VMA/PMD/file boundaries.

Commit 19773df031bc ("mm/fault: try to map the entire file folio in
finish_fault()") argues that doing a per-page fault only prevents RSS
accounting, and not RSS inflation. Combining with the improvements below,
it makes sense to map as maximum pages as possible.

We test the patch with the following userspace program. A shmem VMA of
2M is created, and faulted in, with sysfs setting
hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
in the next iteration. We measure the accumulated time taken during
faulting the VMA.

On arm64,

without patch:
Total time taken by inner loop: 4701721766 ns

with patch:
Total time taken by inner loop: 516043507 ns

giving a 9x improvement.

To remove arm64 contpte interference (although contpte will worsen the
execution time due to not accessing mapped memory, but incurring the
overhead of painting the ptes with cont bit), we can change the program to
map a 32K VMA, and do the fault 8 times. For this case:

without patch:
Total time taken by inner loop: 2081356415 ns

with patch:
Total time taken by inner loop: 408755218 ns

leading to an improvement as well.

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <assert.h>
#include <time.h>
#include <errno.h>
#include <string.h>
#include <sys/syscall.h>
#include <linux/memfd.h>
#include <fcntl.h>

#define PMDSIZE     (1UL << 21)
#define PAGESIZE    (1UL << 12)
#define MTHPSIZE    (1UL << 16)

#define ITERATIONS  1000000

static int xmemfd_create(const char *name, unsigned int flags)
{
#ifdef SYS_memfd_create
    return syscall(SYS_memfd_create, name, flags);
#else
    (void)name; (void)flags;
    errno = ENOSYS;
    return -1;
#endif
}

static void die(const char *msg)
{
    fprintf(stderr, "%s: %s (errno=%d)\n", msg, strerror(errno), errno);
    exit(1);
}

int main(void)
{
    /* Create a shmem-backed "file" (anonymous, RAM/swap-backed) */
    int fd = xmemfd_create("willitscale-shmem", MFD_CLOEXEC);
    if (fd < 0)
        die("memfd_create");

    if (ftruncate(fd, PMDSIZE) != 0)
        die("ftruncate");

    char *c = mmap(NULL, PMDSIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (c == MAP_FAILED)
        die("mmap PMDSIZE");

    assert(!((unsigned long)c & (PMDSIZE - 1)));

    /* allocate PMD shmem folio */
    c[0] = 0;

    char *ptr = mmap(NULL, MTHPSIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (ptr == MAP_FAILED)
        die("mmap MTHPSIZE");

    assert(!((unsigned long)ptr & (MTHPSIZE - 1)));

    long total_time_ns = 0;

    for (int i = 0; i < ITERATIONS; ++i) {
        struct timespec start, end;
        if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
            die("clock_gettime start");

        for (int j = 0; j < 8; ++j) {
            ptr[j * PAGESIZE] = 3;
        }

        if (clock_gettime(CLOCK_MONOTONIC, &end) != 0)
            die("clock_gettime end");

        long elapsed_ns =
            (end.tv_sec - start.tv_sec) * 1000000000L +
            (end.tv_nsec - start.tv_nsec);

        total_time_ns += elapsed_ns;

        assert(madvise(ptr, MTHPSIZE, MADV_DONTNEED) == 0);
    }

    printf("Total time taken by inner loop: %ld ns\n", total_time_ns);

    munmap(ptr, MTHPSIZE);
    munmap(c, PMDSIZE);
    close(fd);
    return 0;
}

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Based on mm-unstable (6873c4e2723d). mm-selftests pass.

 mm/memory.c | 72 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 34 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 79ba525671c7..b3d951573076 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5563,11 +5563,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
 		      !(vma->vm_flags & VM_SHARED);
 	int type, nr_pages;
-	unsigned long addr;
-	bool needs_fallback = false;
+	unsigned long start_addr;
+	bool single_page_fallback = false;
+	bool try_pmd_mapping = true;
+	pgoff_t file_end;
+	struct address_space *mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
 
 fallback:
-	addr = vmf->address;
+	start_addr = vmf->address;
 
 	/* Did we COW the page? */
 	if (is_cow)
@@ -5586,25 +5589,22 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
-	if (!needs_fallback && vma->vm_file) {
-		struct address_space *mapping = vma->vm_file->f_mapping;
-		pgoff_t file_end;
-
+	if (!single_page_fallback && mapping) {
 		file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
 
 		/*
-		 * Do not allow to map with PTEs beyond i_size and with PMD
-		 * across i_size to preserve SIGBUS semantics.
+		 * Do not allow to map with PMD across i_size to preserve
+		 * SIGBUS semantics.
 		 *
 		 * Make an exception for shmem/tmpfs that for long time
 		 * intentionally mapped with PMDs across i_size.
 		 */
-		needs_fallback = !shmem_mapping(mapping) &&
-			file_end < folio_next_index(folio);
+		try_pmd_mapping = shmem_mapping(mapping) ||
+			file_end >= folio_next_index(folio);
 	}
 
 	if (pmd_none(*vmf->pmd)) {
-		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
+		if (try_pmd_mapping && folio_test_pmd_mappable(folio)) {
 			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
@@ -5619,49 +5619,53 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	nr_pages = folio_nr_pages(folio);
 
 	/* Using per-page fault to maintain the uffd semantics */
-	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
+	if (unlikely(userfaultfd_armed(vma)) || unlikely(single_page_fallback)) {
 		nr_pages = 1;
 	} else if (nr_pages > 1) {
-		pgoff_t idx = folio_page_idx(folio, page);
-		/* The page offset of vmf->address within the VMA. */
-		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
-		/* The index of the entry in the pagetable for fault page. */
-		pgoff_t pte_off = pte_index(vmf->address);
+
+		/* Ensure mapping stays within VMA and PMD boundaries */
+		unsigned long pmd_boundary_start = ALIGN_DOWN(vmf->address, PMD_SIZE);
+		unsigned long pmd_boundary_end = pmd_boundary_start + PMD_SIZE;
+		unsigned long va_of_folio_start = vmf->address - ((vmf->pgoff - folio->index) * PAGE_SIZE);
+		unsigned long va_of_folio_end = va_of_folio_start + nr_pages * PAGE_SIZE;
+		unsigned long end_addr;
+
+		start_addr = max3(vma->vm_start, pmd_boundary_start, va_of_folio_start);
+		end_addr = min3(vma->vm_end, pmd_boundary_end, va_of_folio_end);
 
 		/*
-		 * Fallback to per-page fault in case the folio size in page
-		 * cache beyond the VMA limits and PMD pagetable limits.
+		 * Do not allow to map with PTEs across i_size to preserve
+		 * SIGBUS semantics.
+		 *
+		 * Make an exception for shmem/tmpfs that for long time
+		 * intentionally mapped with PMDs across i_size.
 		 */
-		if (unlikely(vma_off < idx ||
-			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
-			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
-			nr_pages = 1;
-		} else {
-			/* Now we can set mappings for the whole large folio. */
-			addr = vmf->address - idx * PAGE_SIZE;
-			page = &folio->page;
-		}
+		if (mapping && !shmem_mapping(mapping))
+			end_addr = min(end_addr, va_of_folio_start + (file_end - folio->index) * PAGE_SIZE);
+
+		nr_pages = (end_addr - start_addr) >> PAGE_SHIFT;
+		page = folio_page(folio, (start_addr - va_of_folio_start) >> PAGE_SHIFT);
 	}
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
-				       addr, &vmf->ptl);
+				       start_addr, &vmf->ptl);
 	if (!vmf->pte)
 		return VM_FAULT_NOPAGE;
 
 	/* Re-check under ptl */
 	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
-		update_mmu_tlb(vma, addr, vmf->pte);
+		update_mmu_tlb(vma, start_addr, vmf->pte);
 		ret = VM_FAULT_NOPAGE;
 		goto unlock;
 	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
-		needs_fallback = true;
+		single_page_fallback = true;
+		try_pmd_mapping = false;
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		goto fallback;
 	}
 
 	folio_ref_add(folio, nr_pages - 1);
-	set_pte_range(vmf, folio, page, nr_pages, addr);
+	set_pte_range(vmf, folio, page, nr_pages, start_addr);
 	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
 	add_mm_counter(vma->vm_mm, type, nr_pages);
 	ret = 0;
-- 
2.34.1


