Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7C0CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A5D6B0093; Thu, 18 Jun 2026 13:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 322426B0095; Thu, 18 Jun 2026 13:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BC56B0096; Thu, 18 Jun 2026 13:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E13916B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:03:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4216CC0A90
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:03:00 +0000 (UTC)
X-FDA: 84893653320.07.22399CA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id A305840014
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:02:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vzz+zfi8;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781802178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmuIcSpZ72Q2dFdWE8ZIFcNBmjQBX3Sgf0SwuEfsfUw=;
	b=axXeerbGYOPvzsoMXJy1T8UfRussmrTJDG4aN5H3nYz7cAzmIQfXzQZTBiXpYi1ozxKyH9
	79RxoCA+GBJHLuoWIrb8ZBQ4xQC/hL8n65odRpxfUSlok750OQOwK6jFd3CLKG9khAQpIA
	Wi0DIlk84bzhmpFQQIJJwXsu2X4jyX4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781802178;
	b=c5DgPaRhYiAdXhk4wsuvFEpMHEfozTyp2kQJYIV6oe3PCTFx2fAcQpF6zqnNsnPTwQ5vha
	ReFLwYepU9DlaE9FGt72BUV7p9saULtF3spR4XfDjJaLS01ThLdh0PruKliMBC5dCvVTaM
	DfBMT2w44CAFOLq8SBOvuDpLsdzdGQ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Vzz+zfi8;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781802175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UmuIcSpZ72Q2dFdWE8ZIFcNBmjQBX3Sgf0SwuEfsfUw=;
	b=Vzz+zfi8tAIbw7fqohxlBjGj+G7vR0Xkrbpbhn554lIsTC87zYgvNxJfWzSdpVzo4xnW6H
	pcRW6gJPMAKd5XG0DA22SZrRYVF7p7Hkj4EDcTY7Yw9Z49+0FGQFlxBw992xHv8HJVivG6
	XGVVGrgmn72EXf2B7CXIrtenxclE598=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where possible
Date: Thu, 18 Jun 2026 10:01:56 -0700
Message-ID: <20260618170157.1375279-1-usama.arif@linux.dev>
In-Reply-To: <20260616190300.1509639-4-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A305840014
X-Rspam-User: 
X-Stat-Signature: giad1gt8kzs1m961oqnk6cj7xix4eygm
X-HE-Tag: 1781802177-772139
X-HE-Meta: U2FsdGVkX19kujRk/3s1bp5043JE4qtulZ7Ynn3VBmqpOJ/wdNMHnYAI3zGn12ezWKILBRQLLq8+pT+dlT8AsziZu3q2UgCM8t0Vd65e0Z/Mww9X3l/pBEWg9EQkjYz1XgqC6L7jKm3TbJdK6wa2IbeneimwGPCOJSDjyTVMK7hDbqGBJoTuVgL7WMs1vQGfhcgF9SS+lfTCFX3RU/2LW9ZwBRHnh/OzLRPSDcGf04N8ijYgCDthTvzi2X+xK2P0U9JeOwLIH3wBLPA1YyEks5JhMPg4f8cz5c8IMadjoQacRgtc3WLB0JBdTZruhPi/VogC/Ed7vreSGPp1f4ZmYGYUZCvW2OyM7k8KNMJrVmImD5G5w2YE7Na1UyaLkACXNZpGBWy4zpni/pvHZV/ONiEPr5H+vXqAXGUA2Sxm1XxULK73e5Jt8MrwchTjPTi7HUr4LPuS6qA9jW55r8CphVxuhy9H52kGuuc9S1zCAHtauAhx5Dun25vGbXUgw99vpOgJdxkSyCEGGd4BIsYWrHjJPq880CPKX2y6CGRAUM7cE/qChwnRmv2kiQdg85H617qgWcFEdub0q6X5ikHIhSfJ5EHN+Qlku77dhPmLR9EL5Fq74Yj05wZjErmvkSA2bTjpWoytbiKceJGpUTCOWw5LUKd6iSLGNSi80mQNeVdE6Ztz7mruKlxLzIqq49mTEVmoQMgZSp0dz2SZpOgQ9gP009pJ8FuEUkIZALQtAo4W66lmGrY3SICIXiBuAZyg6x6iK/eWXGgtc+NUcGrHd1wdnrOXBE63SEceX+tAzFevkVYnQtxmKvVN3OXMXnNBIMndHapbwgX6bgiRZVb96CY/tjP4cL5E8btVxx/pkLbFi1rN+Kx/g7pSxvYiLo5k3aPilisuBmiZlCxjDn7OJSWM+BDTGP42rw4TAwBJBdQB/+higMjqSiooOnbiEUw1vKMP0NIWNlqkgTjg4Q7
 yyfARHNh
 YcEDouBV1PnaS/prUF6nT2K07PR3bgMtw0L3Y04rOv702UDUV3Byek1vH+BvIS/26CyDGywtAOlFluHiJeVyt06rJGjnkwR7PNFBc8+VAOY7I+lYImKjNHOYe056+e13gfSPkWW47/3DC4oo/Fk6mn10y3latLXRdenULEtM0RoGzvW5EbZxM9vvbPfxd93qYkV4sr8GOkK7GprBF8pnjyKCGJDPpXk4b5rfrCKGQNxDAv1q1vzWWo19JtH0BCY4B1FEj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:03:00 -0400 Rik van Riel <riel@surriel.com> wrote:

> __access_remote_vm() takes mmap_read_lock() for the entire transfer and
> uses get_user_pages_remote(), which faults pages in.  For the common
> case of reading memory that is already resident -- /proc/PID/cmdline,
> /proc/PID/environ, ptrace PEEK of resident pages -- the mmap lock is
> unnecessary and is badly contended on large machines.
> 
> Add an opportunistic, read-only fast path that transfers what it can
> without the mmap lock.  For each address it takes the per-VMA lock with
> lock_vma_under_rcu(), re-checks the read-side VMA permissions, and uses
> folio_walk_start(..., FW_VMA_LOCKED) to grab a short-lived reference to
> a present page before copying it out.  Anything non-trivial -- a not-
> present page (needs faulting), a hugetlb or VM_IO/VM_PFNMAP mapping, or
> a race with a VMA writer -- falls back to the existing mmap_lock path
> for the remainder.
> 
> untagged_addr_remote() asserts the mmap lock, so add an unlocked variant
> for the fast path; the untag mask is a stable per-mm value.
> 
> Only reads are handled here; writes keep using the slow path.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  arch/x86/include/asm/uaccess_64.h |  12 +++
>  include/linux/uaccess.h           |  11 ++
>  mm/memory.c                       | 166 +++++++++++++++++++++++++++++-
>  3 files changed, 188 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
> index 4a52497ba6a1..c6fac900a747 100644
> --- a/arch/x86/include/asm/uaccess_64.h
> +++ b/arch/x86/include/asm/uaccess_64.h
> @@ -51,6 +51,18 @@ static inline unsigned long __untagged_addr_remote(struct mm_struct *mm,
>  	(__force __typeof__(addr))__untagged_addr_remote(mm, __addr);	\
>  })
>  
> +/* Same as __untagged_addr_remote(), but usable without the mmap lock held. */
> +static inline unsigned long __untagged_addr_remote_unlocked(struct mm_struct *mm,
> +							    unsigned long addr)
> +{
> +	return addr & READ_ONCE((mm)->context.untag_mask);
> +}
> +
> +#define untagged_addr_remote_unlocked(mm, addr)	({			\
> +	unsigned long __addr = (__force unsigned long)(addr);		\
> +	(__force __typeof__(addr))__untagged_addr_remote_unlocked(mm, __addr); \
> +})
> +
>  #endif
>  
>  #define valid_user_address(x) \
> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index 8a264662b242..c8c83372c9d8 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -34,6 +34,17 @@
>  })
>  #endif
>  
> +/*
> + * Like untagged_addr_remote(), but for callers that stabilize @mm by other
> + * means (e.g. a per-VMA lock) and must not assert the mmap lock.
> + */
> +#ifndef untagged_addr_remote_unlocked
> +#define untagged_addr_remote_unlocked(mm, addr)	({	\
> +	(void)(mm);					\
> +	untagged_addr(addr);				\
> +})
> +#endif
> +
>  #ifdef masked_user_access_begin
>   #define can_do_masked_user_access() 1
>  # ifndef masked_user_write_access_begin
> diff --git a/mm/memory.c b/mm/memory.c
> index 86a973119bd4..0b23b82eaa18 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -42,6 +42,8 @@
>  #include <linux/kernel_stat.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/secretmem.h>
> +#include <linux/pagewalk.h>
>  #include <linux/sched/mm.h>
>  #include <linux/sched/numa_balancing.h>
>  #include <linux/sched/task.h>
> @@ -7062,6 +7064,153 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
>  EXPORT_SYMBOL_GPL(generic_access_phys);
>  #endif
>  
> +/*
> + * The fast path uses folio_walk_start(FW_VMA_LOCKED), which needs the per-VMA
> + * lock and RCU-freed page tables to walk page tables without the mmap lock.
> + */
> +#if defined(CONFIG_PER_VMA_LOCK) && defined(CONFIG_MMU_GATHER_RCU_TABLE_FREE)
> +/*
> + * Opportunistic lockless fast path for __access_remote_vm() reads.
> + *
> + * Memory already resident in @mm can be read without taking the heavily
> + * contended mmap_lock: a per-VMA lock stabilizes the VMA, and folio_walk_start()
> + * with FW_VMA_LOCKED grabs a short-lived reference to a present page via an
> + * RCU/PTL protected page table walk (relying on MMU_GATHER_RCU_TABLE_FREE).
> + *
> + * Anything that would require faulting a page in, touching a hugetlb or
> + * VM_IO/VM_PFNMAP mapping, or that races a VMA writer is left to the mmap_lock
> + * path in __access_remote_vm().  Only reads are handled here.
> + *
> + * Returns the number of bytes transferred via the fast path.
> + */
> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
> +				 void *buf, int len, unsigned int gup_flags)
> +{
> +	void *old_buf = buf;
> +
> +	addr = untagged_addr_remote_unlocked(mm, addr);
> +
> +	while (len) {
> +		struct vm_area_struct *vma;
> +		vm_flags_t vm_flags;
> +
> +		vma = lock_vma_under_rcu(mm, addr);
> +		if (!vma)
> +			break;
> +
> +		/*
> +		 * Mirror the read-side permission checks of check_vma_flags(),
> +		 * and exclude what FW_VMA_LOCKED cannot handle (hugetlb) or what
> +		 * needs the ->access() handler (VM_IO/VM_PFNMAP).  Checked once
> +		 * per VMA; anything not positively allowed falls back to the
> +		 * slow path, which re-validates everything.
> +		 */
> +		vm_flags = vma->vm_flags;
> +		if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
> +		    is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
> +		    (!(vm_flags & VM_READ) &&
> +		     (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREAD)))) {
> +			vma_end_read(vma);
> +			break;
> +		}

This should also do the FOLL_ANON check from check_vma_flags().

check_vma_flags() rejects non-anonymous VMAs when FOLL_ANON is set:

	if ((gup_flags & FOLL_ANON) && !vma_anon)
		return -EFAULT;

That flag is used by fs/proc/base.c for /proc/PID/cmdline and
/proc/PID/environ.  It was added by commit 7f7ccc2ccc2e ("proc: do not
access cmdline nor environ from file-backed areas"), which fixed
CVE-2018-1120 by making those proc files refuse file-backed argv/env
areas.

> +
> +		/*
> +		 * Copy as much of this VMA as we can without re-acquiring the
> +		 * per-VMA lock; re-lock only when @addr leaves the VMA.
> +		 */
> +		while (len && addr < vma->vm_end) {
> +			struct folio_walk fw;
> +			struct folio *folio;
> +			struct page *page;
> +			unsigned long entry_size, entry_left, folio_left, span;
> +			unsigned long copied, idx0;
> +			int offset;
> +
> +			folio = folio_walk_start(&fw, vma, addr, FW_VMA_LOCKED);
> +			if (!folio) {
> +				vma_end_read(vma);
> +				goto out;
> +			}
> +			page = fw.page;
> +			if (!page) {
> +				folio_walk_end(&fw, vma);
> +				vma_end_read(vma);
> +				goto out;
> +			}
> +			/* Pin the folio so it stays valid after the PTL is dropped. */
> +			folio_get(folio);
> +			folio_walk_end(&fw, vma);
> +
> +			/*
> +			 * folio_walk_start() validated exactly one mapping entry,
> +			 * which covers a contiguous, present run of this folio:
> +			 * PAGE_SIZE for a pte, PMD_SIZE for a pmd leaf, PUD_SIZE
> +			 * for a pud leaf.  Copy up to the end of that entry,
> +			 * bounded by the folio, the VMA and len, so a huge mapping
> +			 * is handled in one walk instead of per page.
> +			 */
> +			offset = offset_in_page(addr);
> +			switch (fw.level) {
> +			case FW_LEVEL_PUD:
> +				entry_size = PUD_SIZE;
> +				break;
> +			case FW_LEVEL_PMD:
> +				entry_size = PMD_SIZE;
> +				break;
> +			default:
> +				entry_size = PAGE_SIZE;
> +				break;
> +			}
> +			entry_left = entry_size - (addr & (entry_size - 1));
> +			idx0 = folio_page_idx(folio, page);
> +			folio_left = ((folio_nr_pages(folio) - idx0) << PAGE_SHIFT) -
> +				     offset;
> +			span = min3((unsigned long)len, entry_left, folio_left);
> +			span = min(span, vma->vm_end - addr);
> +
> +			/*
> +			 * Copy the span page-by-page: kmap_local_folio() maps one
> +			 * page on HIGHMEM and copy_from_user_page() flushes per
> +			 * page on aliasing caches, but the page tables are not
> +			 * re-walked.  The span borrows the single folio reference
> +			 * taken above, so each mapping is dropped with
> +			 * kunmap_local() (not folio_release_kmap(), which would
> +			 * also drop a folio reference per page).
> +			 */
> +			for (copied = 0; copied < span; ) {
> +				unsigned long foff = offset + copied;
> +				unsigned long pidx = idx0 + (foff >> PAGE_SHIFT);
> +				int poff = foff & ~PAGE_MASK;
> +				int chunk = min_t(unsigned long, span - copied,
> +						  PAGE_SIZE - poff);
> +				void *maddr = kmap_local_folio(folio,
> +						pidx << PAGE_SHIFT);
> +
> +				copy_from_user_page(vma, folio_page(folio, pidx),
> +						    addr + copied, buf + copied,
> +						    maddr + poff, chunk);
> +				kunmap_local(maddr);
> +				copied += chunk;
> +			}

__access_remote_vm() slow path calls get_user_page_vma_remote() which calls
get_user_pages_remote(). get_user_pages_remote() adds FOLL_TOUCH and then the
page-table walk eventually reaches follow_page_pte().

The new resident-page fast path copies the same data without doing an
equivalent folio_mark_accessed().

That changes reclaim behaviour for pages repeatedly read through
access_remote_vm(), such as /proc/PID/cmdline polling. I think you
should mark the folio as accessed.


> +
> +			folio_put(folio);
> +			len -= span;
> +			buf += span;
> +			addr += span;
> +		}
> +		vma_end_read(vma);
> +	}
> +out:
> +	return buf - old_buf;
> +}
> +#else
> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
> +				 void *buf, int len, unsigned int gup_flags)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_PER_VMA_LOCK && CONFIG_MMU_GATHER_RCU_TABLE_FREE */
> +
>  /*
>   * Access another process' address space as given in mm.
>   */
> @@ -7071,8 +7220,23 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  	void *old_buf = buf;
>  	int write = gup_flags & FOLL_WRITE;
>  
> +	/*
> +	 * Try the lockless fast path for reads first; it transfers what it can
> +	 * from resident memory without taking mmap_lock, and leaves the
> +	 * remainder (if any) to the slow path below.
> +	 */
> +	if (!write) {
> +		int done = access_remote_vm_fast(mm, addr, buf, len, gup_flags);
> +
> +		addr += done;
> +		buf += done;
> +		len -= done;
> +		if (!len)
> +			return buf - old_buf;
> +	}
> +
>  	if (mmap_read_lock_killable(mm))
> -		return 0;
> +		return buf - old_buf;
>  
>  	/* Untag the address before looking up the VMA */
>  	addr = untagged_addr_remote(mm, addr);
> -- 
> 2.53.0-Meta
> 
> 

