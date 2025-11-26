Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E76D10F22
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 11:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B586B0026; Wed, 26 Nov 2025 06:09:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573326B0028; Wed, 26 Nov 2025 06:09:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0FC6B0031; Wed, 26 Nov 2025 06:09:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 394556B0026
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 06:09:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CECB2C0512
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:09:55 +0000 (UTC)
X-FDA: 84152488350.08.63AA078
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED854A0003
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 11:09:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764155394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2S0/KoRc0+IlyzkUvL3LSwVwT8JWqU7+8Xc5uRQZ0wE=;
	b=1ZO4KEG2uplcD/O9X4peuXBNS4+qiDpOt/l8LCYWlzKgVHr9PmSXxpzGzzWN3KD7reevZf
	t4abCBjC4vXHTVYjtIC5UAu2Ju40ms8d453bWqDz3D3GT9jdMcfzDdMyajbbhDKfXfYf4/
	nxST5MF4mLrUG9/4b/Muu1P7bUYKl3E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764155394; a=rsa-sha256;
	cv=none;
	b=yhoPBj1OD4CwNkDgPuR0wTE6XBgODf2VeIB8VzCC5Fwn7Hk0DGIam6T80QbPYVx9+rjtIa
	+f2ozLoQIevF6WxMN52/14+GUF+C02LTAzii94PahxR8hvQYQ/j9bKHdJkpvmoUGloMXbh
	mlN/L0Pz0C3otZ4gywke7340dgbl7io=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47C0D168F;
	Wed, 26 Nov 2025 03:09:45 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1DF653F66E;
	Wed, 26 Nov 2025 03:09:50 -0800 (PST)
Message-ID: <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
Date: Wed, 26 Nov 2025 11:09:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Content-Language: en-GB
To: Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: devicetree@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Conor Dooley <conor@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
 Emil Renner Berthing <kernel@esmil.dk>, Rob Herring <robh+dt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Julia Lawall <Julia.Lawall@inria.fr>,
 Nicolas Palix <nicolas.palix@imag.fr>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251113014656.2605447-7-samuel.holland@sifive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED854A0003
X-Stat-Signature: gfeaep3j9mtopgfq9a78kfttwok7hhcb
X-Rspam-User: 
X-HE-Tag: 1764155393-28239
X-HE-Meta: U2FsdGVkX1+RrD/z1hg/V4jdnJDzSu+jvFplFUkvqrp3vq0pZM24c5oZDYfKtAH5KNqwevvkZXbZ5mWLc+Z0ScvbYLfGsgveEnrij9KN5dkOrJ7Q4SF56loG5usQAz6T0EBSq8Ue0WsGGdiKE7+WKm55c12sxlIeOpzA0GnrPjPE28amr8vI8tj71zViyTxIU0WEaSdCxmwPshnP9WfKaIrGHroYmrxFfMTUVH1qbNcm4EpoVyH5YeqxLOFxnEVVwcquGlIB0b4kR9+HFRO7cMP7KIK6CCmnjcBk/o++2KZW5/kT4rOUSeoeLRV45QK6w3pKBk6z3gapkBu0bRy/mrDlkjq1oIuCPZ1rVzbAYY2cqX0Ft6AQP76ncQWp/Z5HaS/hcFGqLenCuZHNAeqJOsyHoggZ44gt6gUmczJNsMpoIZXwdl1zv9ycr/aiZtnPtDNa6sdkAYPBSxJmZsk4h6n0Hip6Re2dSuVU/6JF3dxzTLKyau+3dxk/zZ0ShMeMzH8jfeg8leYm3NW4V6bhtPdsH+QSCetaRveotyhRriRcHUJoLLo3CKDENVoUB5HNXL8CaBR251XaoeuoCTdOEHY/0xc3BEI9ojfoh1tGtJlRxBjOcQ5a20JPKgGfXis4TbqmiX34rbJZ0ScE6yURneG8kG0OwPJZC0FfJdim9oBoR+tsRntnh21oOs0MIVHHchwPtNLCixZnQtCgOU3qUcK90Rie7YfPtLe9bX7sO2ijDVbav/X26+csKDGqmY1fCuM5xqY6CiBUoO7GxvDxhxO7VtDyeVOOHZQ0Wsp/b13cp34U9K6CzhWKBq7jZd2Hq8VULBsEyqjilP0qT6Te3LZK5J01YDMC7mgdgMhY4DepGSH2ep8JmtgLUkJo8XbEHRJ8d/QiaxK7CuuzKKC/ddwog914lVkfdI5yeLuSneQPfg0alUJXBFm+sKFTHqGgjbzHQtMWKDXx2EcDnMC
 DFnOH++f
 joSv1ZHTulp0SkC3eEX6mGJhusb5M0YTXWWvC98Hh0JZHs4qJOF8VwDJLiuBDnNeKy1W0AUKijA23hJ5PiNqfbjXQqUKqJBU6tuLqJL4nLaQ0sK4NHezufZuf8dlGR2/QVDA4yFLMMQhN4gR71LyeOYdNj3D43xqcD9OIaPFhmmbR9hebiGwoHvE18PEklRu4l1kRh4tFw+k60pqDXOvsZnGBxtkZ2yOZsFIsSLi1JM6RmsXNigC5A9txxqcrROJAIvsl7kGjd79E8+WoWIYTLkw3TAJ6M7xBoPmuy2FfD4NE8MzitwcixbSna5eiCfMa3Rfx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/11/2025 01:45, Samuel Holland wrote:
> Some platforms need to fix up the values when reading or writing page
> tables. Because of this, the accessors must always be used; it is not
> valid to simply dereference a pXX_t pointer.
> 
> Fix all of the instances of this pattern in generic code, mostly by
> applying the below coccinelle semantic patch, repeated for each page
> table level. Some additional fixes were applied manually, mostly to
> macros where type information is unavailable.
> 
> In a few places, a `pte_t *` or `pmd_t *` is actually a pointer to a PTE
> or PMDE value stored on the stack, not a pointer to a page table. In
> those cases, it is not appropriate to use the accessors, because the
> value is not globally visible, and any transformation from pXXp_get()
> has already been applied. Those places are marked by naming the pointer
> `ptentp` or `pmdvalp`, as opposed to `ptep` or `pmdp`.
> 
> @@
> pte_t *P;
> expression E;
> expression I;
> @@
> - P[I] = E
> + set_pte(P + I, E)
> 
> @@
> pte_t *P;
> expression E;
> @@
> (
> - WRITE_ONCE(*P, E)
> + set_pte(P, E)
> |
> - *P = E
> + set_pte(P, E)
> )

There should absolutely never be any instances of core code directly setting an
entry at any level. This *must* always go via the arch code helpers. Did you
find any instances of this? If so, I would consider these bugs and suggest
sending as a separate bugfix patch. Bad things could happen on arm64 because we
may need to break a contiguous mapping, which would not happen if the value is
set directly.

> 
> @@
> pte_t *P;
> expression I;
> @@
> (
>   &P[I]
> |
> - READ_ONCE(P[I])
> + ptep_get(P + I)
> |
> - P[I]
> + ptep_get(P + I)
> )
> 
> @@
> pte_t *P;
> @@
> (
> - READ_ONCE(*P)
> + ptep_get(P)
> |
> - *P
> + ptep_get(P)
> )

For reading the *PTE*, conversion over to ptep_get() should have already been
done (I did this a few years back when implementing support for arm64 contiguous
mappings). If you find any cases where direct dereference or READ_ONCE() is
being done in generic code for PTE, then that's a bug and should also be sent as
a separate patch.

FYI, my experience was that Coccinelle didn't find everything when I was
converting to ptep_get() - although it could have been that my Cochinelle skills
were not up to scratch! I ended up using an additional method where I did a
find/replace to convert "pte_t *" to "ptep_handle_t" and declared pte_handle_t
as a void* which causes a compiler error on dereference. Then in a few key
places I did a manual case from pte_handle_t to (pte_t *) and compiled allyesconfig.

I'm assuming the above Cocchinelle template was also used for pmd_t, pud_t,
p4d_t and pgd_t?

> 
> Additionally, the following semantic patch was used to convert PMD and
> PUD references inside struct vm_fault:
> 
> @@
> struct vm_fault vmf;
> @@
> (
> - *vmf.pmd
> + pmdp_get(vmf.pmd)
> |
> - *vmf.pud
> + pudp_get(vmf.pud)
> )
> 
> @@
> struct vm_fault *vmf;
> @@
> (
> - *vmf->pmd
> + pmdp_get(vmf->pmd)
> |
> - *vmf->pud
> + pudp_get(vmf->pud)
> )
> 
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
> This commit covers some of the same changes as an existing series from
> Anshuman Khandual[1]. Unlike that series, this commit is a purely
> mechanical conversion to demonstrate the RISC-V changes, so it does not
> insert local variables to avoid redundant calls to the accessors. A
> manual conversion like in that series could improve performance.
> 
> [1]: https://lore.kernel.org/linux-mm/20240917073117.1531207-1-anshuman.khandual@arm.com/

Hi,

I've just come across this patch and wanted to mention that we could also
benefit from this improved absraction for some features we are looking at for
arm64. As you mention, Anshuman had a go but hit some roadblocks.

The main issue is that the compiler was unable to optimize away the READ_ONCE()s
for the case where certain levels of the pgtable are folded. But it can optimize
the plain C dereferences. There were complaints the the generated code for arm
(32) and powerpc was significantly impacted due to having many more (redundant)
loads.

Were you able to solve this problem?

I think it stems from there really being 2 types of access; READ_ONCE() and
plain C dereference. The existing READ_ONCE() accesses require the
single-copy-atomic guarantees but the plain c dereferences don't actually need
that; they are usually just checking "is the value the same as a value I
previously read?", "is the pXd none?", etc. so it doesn't matter if they get torn.

It would be nice to have only a single flavour of accessor, but in that case it
obviously needs to be the strongest (READ_ONCE()). Perhaps we should settle for
2 flavours, and the compiler should then be able to continue to optimize out the
c dereferences. There are already 2 flavours for pte (which never gets folded);
ptep_get() and ptep_get_lockless(), but the semantics don't quite match.

Perhaps:

pXdp_get() -> READ_ONCE()
pXdp_get_weak() -> c dereference?

or pXdp_deref()? I'm not great with names...


The other problem is that there is nothing preventing new code from introducing
new direct dereferences or READ_ONCE()s. One possible solution to this is to use
an opaque handle type (similar to what I described above with pte_handle_t). But
that introduces a lot more code churn. I think that's a nice-to-have/incremental
improvement that could be done later.

> 
> Changes in v3:
>  - Rebased on top of torvalds/master (v6.18-rc5+)
> 
> Changes in v2:
>  - New patch for v2
> 
>  fs/dax.c                |  4 +-
>  fs/proc/task_mmu.c      | 27 +++++++------
>  fs/userfaultfd.c        |  6 +--
>  include/linux/huge_mm.h |  8 ++--
>  include/linux/mm.h      | 14 +++----
>  include/linux/pgtable.h | 42 +++++++++----------
>  mm/damon/vaddr.c        |  2 +-
>  mm/debug_vm_pgtable.c   |  4 +-
>  mm/filemap.c            |  6 +--
>  mm/gup.c                | 24 +++++------
>  mm/huge_memory.c        | 90 ++++++++++++++++++++---------------------
>  mm/hugetlb.c            | 10 ++---
>  mm/hugetlb_vmemmap.c    |  4 +-
>  mm/kasan/init.c         | 39 +++++++++---------
>  mm/kasan/shadow.c       | 12 +++---
>  mm/khugepaged.c         |  4 +-
>  mm/ksm.c                |  2 +-
>  mm/madvise.c            |  8 ++--
>  mm/memory-failure.c     | 14 +++----
>  mm/memory.c             | 76 +++++++++++++++++-----------------
>  mm/mempolicy.c          |  4 +-
>  mm/migrate.c            |  4 +-
>  mm/migrate_device.c     | 10 ++---
>  mm/mlock.c              |  6 +--
>  mm/mprotect.c           |  2 +-
>  mm/mremap.c             | 30 +++++++-------
>  mm/page_table_check.c   |  4 +-
>  mm/page_vma_mapped.c    |  6 +--
>  mm/pagewalk.c           | 14 +++----
>  mm/percpu.c             |  8 ++--
>  mm/pgalloc-track.h      |  8 ++--
>  mm/pgtable-generic.c    | 23 ++++++-----
>  mm/rmap.c               |  8 ++--
>  mm/sparse-vmemmap.c     |  8 ++--
>  mm/userfaultfd.c        | 10 ++---
>  mm/vmalloc.c            | 49 +++++++++++-----------
>  mm/vmscan.c             | 14 +++----
>  37 files changed, 304 insertions(+), 300 deletions(-)
> 

[...]

> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1322,7 +1322,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>  
>  		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
>  	}
> -	*orig_pte = entry;
> +	set_pte(orig_pte, entry);

This is incorrect. orig_pte points to a location on stack. Please revert.

>  	err = 0;
>  
>  out_unlock:

[...]

> @@ -1116,7 +1116,7 @@ static int guard_install_set_pte(unsigned long addr, unsigned long next,
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>  
>  	/* Simply install a PTE marker, this causes segfault on access. */
> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> +	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));

I tried "fixing" this before. But it's correct as is. ptep is pointing to a
value on the stack. See [2].

https://lore.kernel.org/linux-mm/2308a4d0-273e-4cf8-9c9f-3008c42b6d18@arm.com/

>  	(*nr_pages)++;

[...]

It's all very difficult to review at the moment since it is so big. Any chance
of at least splitting by level in future versions?

Thanks,
Ryan



