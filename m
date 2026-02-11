Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D3E1E9E2E7
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 11:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81D66B0089; Wed, 11 Feb 2026 06:33:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F3C6B008A; Wed, 11 Feb 2026 06:33:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6C26B008C; Wed, 11 Feb 2026 06:33:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD7766B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 06:33:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 727181A02CC
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:33:57 +0000 (UTC)
X-FDA: 84431966514.30.746BF0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 90848160010
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 11:33:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxoxQqUX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770809635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BjBUuHS3cWRFPWNcvMjBdWtBf6RvZ3nK8CHC4OK3RN0=;
	b=TKWVJbmmNxCFEuO86OJq/cBagd0Nn9Zl+VsKBl8Yutliz/O0kZtgtNnCrcw/Sop/gX2/ps
	Lj4GnRYO9hlI5R7K8X0A+0ZOQpLZemyMQ5zy7ytOIGy48NLG7dFFDC0T6V+Kmx+sqZup8h
	78NFZcpsPaTPXWuMo0+bGOmELO0J08Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770809635; a=rsa-sha256;
	cv=none;
	b=MAaIDfcb021yWJ6FW70R4ut9uStA1pSnlXcCdBI1VatuDNA18t5fXV3I3pWGzBuAntcty0
	MNKqq7XJPIhMNLhbtSQiAajfID7S8bWOa+8NA8Wm8jq6HNQaZCrxd95Q7Zd7rKA21hCbma
	HwjG5fx9E1YJ3yDHzIVsjWiVVqTAuX4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nxoxQqUX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BEEC460053;
	Wed, 11 Feb 2026 11:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F4EC4CEF7;
	Wed, 11 Feb 2026 11:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770809634;
	bh=3QW93jMAvUWPDGSeAtG4hJyUOPCA/qFepn9XLXy/HJY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nxoxQqUXENoCszCOouqOHY/Vu2wyr8k8XFjvkfsmsmYEqVGlkHg8uRPfd29gcpVb5
	 Nmfdq7qJ7tzvan1077LHpTkaCp/rfKircS/TY6/QzF7MW3Zx7qMx/e5IYVkcUNcG+X
	 vmtXUKorPSnb2fsDInHvz3hSueu4agqCHgmzvt2usGys5to1VBJ9qu33QtxUYQUzfM
	 PgEmhmgaio8fXNB83Eo6hKnX5Vzha+rvwT1r7ao86CLPCvQUtl8tiy56N+IqPgb7Aj
	 K2W5df8i+F6jrSvWw9wRhk+Ns/shVr5v0cWPx3MNpUuZjU95inF4nfmzA6K2vwqGnz
	 VzTBc47gmCtYg==
Message-ID: <3684c55a-6581-4731-b94a-19526f455a1e@kernel.org>
Date: Wed, 11 Feb 2026 12:33:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kirill@shutemov.name, willy@infradead.org
References: <20260206135648.38164-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260206135648.38164-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90848160010
X-Stat-Signature: qpyrtquxm6h169f7amm5o3jmojx4395e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770809635-38965
X-HE-Meta: U2FsdGVkX1+aSt8a61jJT22n2z/DD9QYggG/WIm/vrpDPUEDn8StK7rm1e9uB4cs7CgZAHJLjDLNP65UzVJ3FFA4lf1aBsAdD/iFjzWQj91io5CXidgKs7ve8CAl8wWwvA7g0l+lx2JFTp/OlAUxDJmrpDNYD8Zct68JPElg4IqfUnnFwm6CMJV7zosHkAlUz3cn5Aj5knNvJ4PGdS8val3KYzgeLvRQKifG02dHWEVBMxPk/NHag+T9+QKUlm7t5b2bKlDEL8ALDZJm58TGSwQJFts9fT1YZbNx49/oh94cwpPRqgJU9rYZTGdlVgoN8YUVayWw7mdad2Wuy2b3iPYWMD0aIJdOmADQcIpuF64DkIf6LoEHF80TQu57ebZrOGVxYEuDpCc89/AGlo91BAvAiCF3LEUWN2kC/PZNbL8XhiEPpwfpQe0XxSz8tVb1fZ3TWA5Cq6/12K81eX6/hS/EnGa+tHP+tFqoooELU3HuzzyES+tXlvkqxrHmNpY6uZRzZs5X2/cp1+y2yEu6MudmIKD5JHNtVU/zXzE2x2HM7pZbC9uai9RF2b7RGMMrpzwRR39alvL23oD7td20F8BhDTg0CmBN1MVt3FfrMMLjJEb4r/VoM1WSS3DlJi8drYGidC0pcKtY8alIbLE3A3VBArzaUn6ezQ/XhDWiS7eVW2JZ6Ra4KrYtVu2YM6aCdGGI9gTckT9gVIrkhd/N9rEGnKw7wCwFokPODIFnY7CdFbleDFIEWTxAlRbMyGoMTpti/i39qriw+k3LZH2dwysgv7Zm28oJiY0ETGn/FcsrX4DOYCr+zA35g19C6dWrmknb9gcT4SjkNRKF8c5KckGzuHGqWZh9ioT8jCdaOatBaWoS0Nd9PShi+camvFoUMjQWVA2glJco4OPI8/INH19ioMQv/JnbMwOWWvZPAO1p7C9QKnfrT578EK4c49yDmomqZE480Uhf8+0u0vj
 POI4W/44
 n0CE2RLhpHbPq6gdWy7Oi2S/Ft52fsHYY2LS7Afr6FgsOGgZh/gS/j9pqq+n+fWrJpphETHwztcaH/VdG+OYZ2H0dv/R6OdqU5JtCrg6AyyEReCQdgfQGQzmUbDa9PkE4dvoCmozq1yw/k2LsqnY7VMao+Mn5vTfYKcSzXNbmf3GWVOWJyJovp44IpfXnYMjlOvhrmL6TwNew6njZ2bMHhBwKDl3kKCaa9Nb3nu7dzO9AMh1/6XYH/ncTWOE8rzt4/LN/rLS5Xpnkcz+rgT7zS52uc/xDqGCnwOhgrg7hXp5YwK72XGaQE7/ocQqMhZswV1zl8h7R0XCFxnGi75w380Kg19KiJlG1SMlbTFAIYhTvX/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/6/26 14:56, Dev Jain wrote:
> Suppose a VMA of size 64K, maps a file/shmem-file at index 0, and that the
> pagecache at index 0 contains an order-9 folio. If do_fault_around is able
> to find this folio, filemap_map_pages ultimately maps the first 64K half of
> the folio into the pagetable, thus reducing the number of future page
> faults. If fault-around fails to satisfy the fault, or if it is a write
> fault, then we use vma->vm_ops->fault to find/create the folio, followed by
> finish_fault to map the folio into the pagetable. On encountering a similar
> large folio crossing the VMA boundary, finish_fault currently falls back
> to mapping only a single page.
> 
> Align finish_fault with filemap_map_pages, and map as many pages as
> possible, without crossing VMA/PMD/file boundaries.
> 
> Commit 19773df031bc ("mm/fault: try to map the entire file folio in
> finish_fault()") argues that doing a per-page fault only prevents RSS
> accounting, and not RSS inflation. Combining with the improvements below,
> it makes sense to map as maximum pages as possible.
> 
> We test the patch with the following userspace program. A shmem VMA of
> 2M is created, and faulted in, with sysfs setting
> hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
> with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
> Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
> in the next iteration. We measure the accumulated time taken during
> faulting the VMA.
> 
> On arm64,
> 
> without patch:
> Total time taken by inner loop: 4701721766 ns
> 
> with patch:
> Total time taken by inner loop: 516043507 ns
> 
> giving a 9x improvement.
> 
> To remove arm64 contpte interference (although contpte will worsen the
> execution time due to not accessing mapped memory, but incurring the
> overhead of painting the ptes with cont bit), we can change the program to
> map a 32K VMA, and do the fault 8 times. For this case:
> 
> without patch:
> Total time taken by inner loop: 2081356415 ns
> 
> with patch:
> Total time taken by inner loop: 408755218 ns
> 
> leading to an improvement as well.
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <assert.h>
> #include <time.h>
> #include <errno.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <linux/memfd.h>
> #include <fcntl.h>
> 
> #define PMDSIZE     (1UL << 21)
> #define PAGESIZE    (1UL << 12)
> #define MTHPSIZE    (1UL << 16)
> 
> #define ITERATIONS  1000000
> 
> static int xmemfd_create(const char *name, unsigned int flags)
> {
> #ifdef SYS_memfd_create
>      return syscall(SYS_memfd_create, name, flags);
> #else
>      (void)name; (void)flags;
>      errno = ENOSYS;
>      return -1;
> #endif
> }
> 
> static void die(const char *msg)
> {
>      fprintf(stderr, "%s: %s (errno=%d)\n", msg, strerror(errno), errno);
>      exit(1);
> }
> 
> int main(void)
> {
>      /* Create a shmem-backed "file" (anonymous, RAM/swap-backed) */
>      int fd = xmemfd_create("willitscale-shmem", MFD_CLOEXEC);
>      if (fd < 0)
>          die("memfd_create");
> 
>      if (ftruncate(fd, PMDSIZE) != 0)
>          die("ftruncate");
> 
>      char *c = mmap(NULL, PMDSIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>      if (c == MAP_FAILED)
>          die("mmap PMDSIZE");
> 
>      assert(!((unsigned long)c & (PMDSIZE - 1)));
> 
>      /* allocate PMD shmem folio */
>      c[0] = 0;
> 
>      char *ptr = mmap(NULL, MTHPSIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>      if (ptr == MAP_FAILED)
>          die("mmap MTHPSIZE");
> 
>      assert(!((unsigned long)ptr & (MTHPSIZE - 1)));
> 
>      long total_time_ns = 0;
> 
>      for (int i = 0; i < ITERATIONS; ++i) {
>          struct timespec start, end;
>          if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
>              die("clock_gettime start");
> 
>          for (int j = 0; j < 8; ++j) {
>              ptr[j * PAGESIZE] = 3;
>          }
> 
>          if (clock_gettime(CLOCK_MONOTONIC, &end) != 0)
>              die("clock_gettime end");
> 
>          long elapsed_ns =
>              (end.tv_sec - start.tv_sec) * 1000000000L +
>              (end.tv_nsec - start.tv_nsec);
> 
>          total_time_ns += elapsed_ns;
> 
>          assert(madvise(ptr, MTHPSIZE, MADV_DONTNEED) == 0);
>      }
> 
>      printf("Total time taken by inner loop: %ld ns\n", total_time_ns);
> 
>      munmap(ptr, MTHPSIZE);
>      munmap(c, PMDSIZE);
>      close(fd);
>      return 0;
> }
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Based on mm-unstable (6873c4e2723d). mm-selftests pass.
> 
>   mm/memory.c | 72 ++++++++++++++++++++++++++++-------------------------
>   1 file changed, 38 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 79ba525671c7..b3d951573076 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5563,11 +5563,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   	bool is_cow = (vmf->flags & FAULT_FLAG_WRITE) &&
>   		      !(vma->vm_flags & VM_SHARED);
>   	int type, nr_pages;
> -	unsigned long addr;
> -	bool needs_fallback = false;
> +	unsigned long start_addr;
> +	bool single_page_fallback = false;
> +	bool try_pmd_mapping = true;
> +	pgoff_t file_end;
> +	struct address_space *mapping = vma->vm_file ? vma->vm_file->f_mapping : NULL;
>   
>   fallback:
> -	addr = vmf->address;
> +	start_addr = vmf->address;
>   
>   	/* Did we COW the page? */
>   	if (is_cow)
> @@ -5586,25 +5589,22 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   			return ret;
>   	}
>   
> -	if (!needs_fallback && vma->vm_file) {
> -		struct address_space *mapping = vma->vm_file->f_mapping;
> -		pgoff_t file_end;
> -
> +	if (!single_page_fallback && mapping) {
>   		file_end = DIV_ROUND_UP(i_size_read(mapping->host), PAGE_SIZE);
>   
>   		/*
> -		 * Do not allow to map with PTEs beyond i_size and with PMD
> -		 * across i_size to preserve SIGBUS semantics.
> +		 * Do not allow to map with PMD across i_size to preserve
> +		 * SIGBUS semantics.
>   		 *
>   		 * Make an exception for shmem/tmpfs that for long time
>   		 * intentionally mapped with PMDs across i_size.
>   		 */
> -		needs_fallback = !shmem_mapping(mapping) &&
> -			file_end < folio_next_index(folio);
> +		try_pmd_mapping = shmem_mapping(mapping) ||
> +			file_end >= folio_next_index(folio);
>   	}
>   
>   	if (pmd_none(*vmf->pmd)) {
> -		if (!needs_fallback && folio_test_pmd_mappable(folio)) {
> +		if (try_pmd_mapping && folio_test_pmd_mappable(folio)) {
>   			ret = do_set_pmd(vmf, folio, page);
>   			if (ret != VM_FAULT_FALLBACK)
>   				return ret;
> @@ -5619,49 +5619,53 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   	nr_pages = folio_nr_pages(folio);
>   
>   	/* Using per-page fault to maintain the uffd semantics */
> -	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(single_page_fallback)) {
>   		nr_pages = 1;
>   	} else if (nr_pages > 1) {
> -		pgoff_t idx = folio_page_idx(folio, page);
> -		/* The page offset of vmf->address within the VMA. */
> -		pgoff_t vma_off = vmf->pgoff - vmf->vma->vm_pgoff;
> -		/* The index of the entry in the pagetable for fault page. */
> -		pgoff_t pte_off = pte_index(vmf->address);
> +
> +		/* Ensure mapping stays within VMA and PMD boundaries */
> +		unsigned long pmd_boundary_start = ALIGN_DOWN(vmf->address, PMD_SIZE);
> +		unsigned long pmd_boundary_end = pmd_boundary_start + PMD_SIZE;
> +		unsigned long va_of_folio_start = vmf->address - ((vmf->pgoff - folio->index) * PAGE_SIZE);
> +		unsigned long va_of_folio_end = va_of_folio_start + nr_pages * PAGE_SIZE;
> +		unsigned long end_addr;
> +
> +		start_addr = max3(vma->vm_start, pmd_boundary_start, va_of_folio_start);
> +		end_addr = min3(vma->vm_end, pmd_boundary_end, va_of_folio_end);
>   
>   		/*
> -		 * Fallback to per-page fault in case the folio size in page
> -		 * cache beyond the VMA limits and PMD pagetable limits.
> +		 * Do not allow to map with PTEs across i_size to preserve
> +		 * SIGBUS semantics.
> +		 *
> +		 * Make an exception for shmem/tmpfs that for long time
> +		 * intentionally mapped with PMDs across i_size.
>   		 */
> -		if (unlikely(vma_off < idx ||
> -			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
> -			    pte_off < idx ||
> -			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
> -			nr_pages = 1;
> -		} else {
> -			/* Now we can set mappings for the whole large folio. */
> -			addr = vmf->address - idx * PAGE_SIZE;
> -			page = &folio->page;
> -		}
> +		if (mapping && !shmem_mapping(mapping))
> +			end_addr = min(end_addr, va_of_folio_start + (file_end - folio->index) * PAGE_SIZE);
> +
> +		nr_pages = (end_addr - start_addr) >> PAGE_SHIFT;
> +		page = folio_page(folio, (start_addr - va_of_folio_start) >> PAGE_SHIFT);
>   	}
>   
>   	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> -				       addr, &vmf->ptl);
> +				       start_addr, &vmf->ptl);
>   	if (!vmf->pte)
>   		return VM_FAULT_NOPAGE;
>   
>   	/* Re-check under ptl */
>   	if (nr_pages == 1 && unlikely(vmf_pte_changed(vmf))) {
> -		update_mmu_tlb(vma, addr, vmf->pte);
> +		update_mmu_tlb(vma, start_addr, vmf->pte);
>   		ret = VM_FAULT_NOPAGE;
>   		goto unlock;
>   	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
> -		needs_fallback = true;
> +		single_page_fallback = true;
> +		try_pmd_mapping = false;
>   		pte_unmap_unlock(vmf->pte, vmf->ptl);
>   		goto fallback;
>   	}
>   
>   	folio_ref_add(folio, nr_pages - 1);
> -	set_pte_range(vmf, folio, page, nr_pages, addr);
> +	set_pte_range(vmf, folio, page, nr_pages, start_addr);
>   	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
>   	add_mm_counter(vma->vm_mm, type, nr_pages);
>   	ret = 0;


I can see something like that to be reasonable, but I think we really 
have to cleanup this function first before we perform further 
complicated changes.

I wonder if the "goto fallback" thing could be avoided by reworking 
things. A bit nasty.

The whole "does the whole folio fit into this page table+vma" check 
should probably get factored out into a helper that could later tell us
which page+nr_pages range could get mapped into the page table instead 
of just telling us "1 page vs. the full thing".

There, I would also expect a lockless check for a suiteable 
pte_none-range, similar to how we have it in other code.


So I would expect the function flow to be something like:

1) Try mapping with PMD if possible.

2) If not, detect biggest folio range that can be mapped (taking VMA,
    PMD-range and actual page table (pte_none) into account) and try to
    map that. If there is already something at the faulting pte,
    VM_FAULT_NOPAGE.

3) We could retry 2) or just give up and let the caller retry 
(VM_FAULT_NOPAGE).

-- 
Cheers,

David

