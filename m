Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5C48CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1F06B0088; Fri, 19 Jun 2026 08:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52626B008A; Fri, 19 Jun 2026 08:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A6F6B008C; Fri, 19 Jun 2026 08:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7690B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:20:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB93CC1DAF
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:20:25 +0000 (UTC)
X-FDA: 84896570010.01.43C73E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1394F14000F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:20:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs5J494y;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781871624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dsf7zQ2rniKbmb14SUZKUUHsmi2Ftb0lXqoOWzVTT2o=;
	b=hN60B6MhUVcqrfxAGVEIQ+xz7I2kTiew7DSwfLKdekGW6PGq0ajlmF56cqfqLsbS4l8qWB
	Ev63Zao3QPRZ1L6Jxd00YQtV62MGDpq7t7JDvkwr1XTtRciFT/DNTqQNANGy88d7bs270b
	cqVqeUhO+XJnIZSootCVhRU2nxqrZpE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781871624;
	b=w2mXADCFwZFoh+5PZ1bKu3NL0pnsSH7hi2F5ZvpwHC6LC1V7SIosque6tm7IJK9f1UR55b
	Cd8m1DgOh3oKPQxWpamCN4IefF8AOIzECV7ifURbAFM67CpRkGkBYn7IPfk3ea94eXL/jG
	NvXTjBHSTovueeMWc5FS06DyY8WHnac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs5J494y;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F17943618;
	Fri, 19 Jun 2026 12:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085AC1F000E9;
	Fri, 19 Jun 2026 12:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781871623;
	bh=dsf7zQ2rniKbmb14SUZKUUHsmi2Ftb0lXqoOWzVTT2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Gs5J494yuNOjSJLbLl7+/OO24jmnyeJWgNDRNCw3coWm+OclWeVzjjvNc0W0y1Y90
	 mMHPFWACoxI82HoMQfQ/zR3RBE3dlx1Nt/9ef4P1+6+rz3BImkpu7rS/T6vP4jB8lL
	 SG78iToX54XWE8t04tfVNOxyY1porp54yRFCjtKHWHSes8Toj7jt0ewNsd+/ghZ440
	 kIPhBMVYKaTf4JOOjT+uqt3b774UUGSmnUNjpenQKhS0yo+zl8RuxoXRo7ufgHh5My
	 76VjEL59ScrijkixFkkWUAFF0NQlQ8jNVVuRS4CFCdLWY6JzJy0qeAfKaQ4nGsdSaQ
	 A1z1u2jMbcQ9g==
Date: Fri, 19 Jun 2026 13:20:16 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin <d@ilvokhin.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 3/3] mm: read remote memory without the mmap lock where
 possible
Message-ID: <ajUpv7RBMc1jigW9@lucifer>
References: <20260616190300.1509639-1-riel@surriel.com>
 <20260616190300.1509639-4-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616190300.1509639-4-riel@surriel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1394F14000F
X-Stat-Signature: excy9gdw353w5zpog769ewt5teskpnwt
X-HE-Tag: 1781871623-21977
X-HE-Meta: U2FsdGVkX1/0hTZdpVazOD2oud4/3+DF4aNRL0lsrFo5eUR24kxnLsOWlSrPT7yLAT72LWj8bn4LwdpEpN4QZzCGgBt/1MkRAShqEghyW0A4cfwHw9z8O+WhDSDbkLWtK7S1DT45TdM+sYfpWKkz9gfTAmYO+Z7wlNFV3dJxRfCKDkoGSeYcxWgrwh41M1IcI0+FcL30Oz+RDxl1XqpvfMUnSHhqcNj7CBUU/eKRE9orQ5H5mC/97NDpxLcZOE4h9IulXf8CnDJNfqc+MgDDRAw2Nz84xdH9BbWVnUZlCrTRHEkD7PKUWu0bdpBaZtKx+R2uEEHsXmeBrAWTnOUoN1UcJS2S3OE5HHs1u0QrgZzysr0LDJ6RYvZEX3Pmw9UO2eQwgs1B7HQPokfHfJeGihfa9fG+3cUDLsUkFWwqaIiwbhqzJoYsiAzO9fAD4SThxQ+95fztPSsvyDuElblbqpi+dqYGf9+8QQEpefzjXt3VGY/aTH8Rt3MemeUki+SnWZznktywb/63z7gaqDMuo1v9o/XdmfnRQmpU7LcTAmApSQDGMRPE/t6bWiqLQIwZJP7RjLELBQapQsGpISsa+0nPqwXZ97k351lMIqBoxQpFF6JHSVk3FYX9uu/kwXeHwpery/LoJ5jbzTCeutJoouLREDxJieLk7ep71e2/iwjhcCro+DwTCsdCppPfgK7hJ+xSIesz/XmiUoSmXJqBBJy7n+caxTP9DoK+9KZwQv8noV+3dW3m5EWx1tAcxQcC3vxKiizrhZobh9RifbhonGSZQcsKni2EVeL3MZ7EZb9wJfSnVOtveh5X0q01gALuXladUBAJKlO7zJcTdQUWou4a7bn45Y9ibsqoR262UixKwzpMoz7wLXf0Q0d24r5JY05CTT4exTIY2HMFLvd4Q1yMDx21ZVyNgprPcYWxzQ3TKXdjU2BRmH/0Exi5ggzvcgyoogV9mzPmxdCjVno
 1hyZI438
 o0AcS62A5a4RFlGNoBI01F4RNZ7XVUd4hhkvxAlxXObTd8y/MrHLVECZTsimZnPwym1xzfEM64PwjbYksl/oSuK4z7Jk+Kj5f8YnVYEamVnf/VHwnXbfEFiEPP9K9ba8JM9ZMRGWKlFsSB2Iun89s9RAyu+9oMQ1L13Bd54utnJAobAOTbu8KPIfV/K2QpxeQha4L97WcSwKAmjl/XH/rrhgtGeWyoDqPXpnvmQZ4Vk5p9PMI/AOa462i6AL20eoPnXJFu1NBYaQntDv1X3/4zfP8mEPr8QMtFB37gkDRlV4fPsyP8KeYm6M8cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 03:03:00PM -0400, Rik van Riel wrote:
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

This feels as if there was a little too much left to AI :)

> Signed-off-by: Rik van Riel <riel@surriel.com>

This needs to be separated into more patches, functions, and thoroughly reworked
to be upstreamable, unfortunately.

It's additionally quite hard to review in this form.

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

How? This is pretty vague.

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

I'm confused why you're implementing this and not just calling untagged_addr()
from untagged_addr_remote_unlocked()?

You don't comment or explain this in the commit msg afaict.

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

It's odd you'll comment this like this but not explain the confusing bit as to
why you can't just call untagged_addr()

> +#ifndef untagged_addr_remote_unlocked
> +#define untagged_addr_remote_unlocked(mm, addr)	({	\
> +	(void)(mm);					\

I'm not sure this is required?

> +	untagged_addr(addr);				\

Weird again that x86 needs special treatment but not other arches?

> +})
> +#endif
> +

You should really make untagged_addr_remote() call
untagged_addr_remote_unlocked() after its assert, otherwise it's a really odd
inconsistency.

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

Shall we wait for, or rely on Dave's series to remove CONFIG_PER_VMA_LOCK + make
it permanently on here?

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

I think referencing the confusing mess that is the special VMA flags is best
avoided (and anyway I think and you should just say

I think we could be clearer here like:

This is the read fast patch, writes are handled by the slow path in
__access_remote_vm() - faulting in, touching hugetlb or a remap.


> + *
> + * Returns the number of bytes transferred via the fast path.
> + */
> +static int access_remote_vm_fast(struct mm_struct *mm, unsigned long addr,
> +				 void *buf, int len, unsigned int gup_flags)

In general this function is... ugly. Very ugly :)

You nest while -> while -> for and it's all open-coded.

It needs major refactoring - separate out smaller functions, improve the
comments, separate out logic that can be shared with gup etc.

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

This feels very overwrought. You're compressing far to omuch into one lump of
text.

> +		vm_flags = vma->vm_flags;

Please don't use the old VMA flags API for new code. And definitely don't do
some weird vm_flags we keep separate from vma->vm_flags thing here.

	vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT)

> +		if ((vm_flags & (VM_IO | VM_PFNMAP)) ||
> +		    is_vm_hugetlb_page(vma) || vma_is_secretmem(vma) ||
> +		    (!(vm_flags & VM_READ) &&

But what does !VM_READ mean exactly? Are you really checking for PROT_NONE?

So vma_is_accessible() is right here no?

> +		     (!(gup_flags & FOLL_FORCE) || !(vm_flags & VM_MAYREAD)))) {

This conditional is abhorrent...

I think a good rule of thumb for this kind of thing is to read it out loud in
English - 'if IO or PFN map or hugetlb or secret mem or either not VM_READ etc.'
- if you're confused by it in English then don't put it in code.

Anyway it should clearly be a separate function like:

	static bool vma_can_use_fast_path(const struct vm_area_struct *vma)
	{
		/* We cannot GUP PFN maps or I/O memory. */
		if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
			return false;
		/* Hugetlb is a special snowflake. */
		if (is_vm_hugetlb_page(vma))
			return false;
		... etc. etc. ...
		return true;
	}

Which is vastly clearer.


> +			vma_end_read(vma);
> +			break;
> +		}
> +
> +		/*
> +		 * Copy as much of this VMA as we can without re-acquiring the
> +		 * per-VMA lock; re-lock only when @addr leaves the VMA.
> +		 */

Strange phrasing. I'm not even sure it's a useful comment?

> +		while (len && addr < vma->vm_end) {
> +			struct folio_walk fw;

Be good to avoid mystery meat varible names. 'walk'?

> +			struct folio *folio;
> +			struct page *page;
> +			unsigned long entry_size, entry_left, folio_left, span;
> +			unsigned long copied, idx0;

idx0 is a terrible name :)

All these variables tells you the function is too long.

> +			int offset;
> +
> +			folio = folio_walk_start(&fw, vma, addr, FW_VMA_LOCKED);
> +			if (!folio) {
> +				vma_end_read(vma);
> +				goto out;
> +			}
> +			page = fw.page;
> +			if (!page) {

under what circumstances would !fw.page when folio is non-NULL?

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

Surely we have a better way of doing this? At least needs abstracting, a random
switch in the middle of this code is horrid.

> +			idx0 = folio_page_idx(folio, page);
> +			folio_left = ((folio_nr_pages(folio) - idx0) << PAGE_SHIFT) -
> +				     offset;

Couldn't we just keep track of this without this horrid expression?

> +			span = min3((unsigned long)len, entry_left, folio_left);
> +			span = min(span, vma->vm_end - addr);

You add massive comments for some bits, then do extremely confusing open coded
stuff here?

This needs a lot of breaking up.

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

This is a really confusing mass of text that is really dense and hard to
parse. Clarity is king.

In any case this should be separted out.

> +			for (copied = 0; copied < span; ) {

Very odd for loop.

	copied = 0;
	while (copied < span) {
		...
	}

Would be better. But I think reworking it so a normal for (init; cond; incr)
loop would work would be better?

> +				unsigned long foff = offset + copied;

foff :)) now I won't be childish :P

I really dislike overly compressed variable names. It's vague. File offset? I
guess you mean folio offset right?

and why did you call it plain 'offset' before but now specify folio but as 'f'?

> +				unsigned long pidx = idx0 + (foff >> PAGE_SHIFT);

'pidx'?

Equally unnecessarily and confusingly compressed variable name. We can live with
page_index if that's what you mean?

Also it's unceratin what the units are. It's ok to say 'bytes' and 'nr_pages' or
'page_nr' or something, and far clearer.

This should obviously be in another function anyway given indentation levels here.

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
> +
> +			folio_put(folio);
> +			len -= span;
> +			buf += span;
> +			addr += span;
> +		}
> +		vma_end_read(vma);

Really hard to keep track of what's what here.

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

This is a weird comment, you should describe what access_remote_vm_fast() does
in access_remote_vm_fast(). You also don't mention the !write here which is the
thing people might wonder about.

I think the code is self-documenting anyway - try fast path - pretty clear.


> +	if (!write) {
> +		int done = access_remote_vm_fast(mm, addr, buf, len, gup_flags);

Can be const.

Can't errors arise in access_remote_vm_fast()? And in general seems it'd make
more sense to return an error/bool rather and have done as output param rather
than infer stuff from done.

> +
> +		addr += done;
> +		buf += done;
> +		len -= done;
> +		if (!len)
> +			return buf - old_buf;

So usual case will be it does everything right? So you do some useless
arithmetic and then return buf - old_buf.

Should probably instead have a return value.

But in general __access_remote_vm() is horrible. I think if you add new features
it's only right you spend some commits cleaning up first.

Otherwise we heap more stuff on top of broken stuff on and on and things get
messier + messier.


> +	}
> +
>  	if (mmap_read_lock_killable(mm))
> -		return 0;
> +		return buf - old_buf;

Err there's other cases where you return 0 here, e.g.:

	/* Avoid triggering the temporary warning in __get_user_pages */
	if (!vma_lookup(mm, addr) && !expand_stack(mm, addr))
		return 0;

So you probably need to fix those up to?

Probably better to just have a return value declared in the function.

>
>  	/* Untag the address before looking up the VMA */
>  	addr = untagged_addr_remote(mm, addr);
> --
> 2.53.0-Meta
>

Thanks, Lorenzo

