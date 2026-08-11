Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDD6C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 10:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1426B007B; Tue, 11 Aug 2026 06:58:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B3E6B008A; Tue, 11 Aug 2026 06:58:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5226D6B008C; Tue, 11 Aug 2026 06:58:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2194C6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:58:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9652B1A03D4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:58:15 +0000 (UTC)
X-FDA: 85088689350.05.79AECC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8330340002
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:58:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKGjJivw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786445894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMPfsClutHKF0jEs4FSR4QcGXWVBEFIj5vjA+eQoUl8=;
	b=GuvXa2D5nsdc4WrEIUHT5K3lpv/0Eg5lB9Dc6qL9yYPOs7AZO3sajV9NEfi5Tr+A4NgKaD
	WIKz/WMV4HwJmt5YlKx5LS5lTZSnv0A9Ucale4ALX98CbT4jkWtsPomAGZDaaUzXhhc3Hx
	11a988hZkOLh9koI7xEkfnIwnQM8DVI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tKGjJivw;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786445894;
	b=KMl3MVj6OLIkkXs8UwxjtKcTGA+CY5DeZlU8wG9aQfI5vwsCF07f7E+Dt/Kje/Pd8AfO2Y
	pVW7FXzJcWKqg2WXQQP7RuzQXd9zuVqPXR6Xk1xK62hey/CFVHIsvOMYKrSGCa02st6GXT
	HvUEhME7iZZzVU9it7MTmpYJEeQBcto=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44D0C1682;
	Tue, 11 Aug 2026 03:58:08 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 820043F86F;
	Tue, 11 Aug 2026 03:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786445892; bh=E2Q5I65meboDct+4hfaKsQDzSd1S1/tsAKEVH3DzJwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tKGjJivwGyrqmHqJQhgHkKc1NYH5dpUS0DWnYV/mVHQACS1frf2TRd2UhTyMG8JvA
	 Bw0BndUTcgOm1QZBl4JI/V5svJA1QNwOZVE/G2oL5rd2q44W5xc5apxl/s1/v2NISQ
	 JQrQY7r9UAbIHixEwxX6nTsx2ykLpYcEoEZ681SE=
Date: Tue, 11 Aug 2026 16:28:09 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, ziy@nvidia.com, 
	pfalcato@suse.de, agordeev@linux.ibm.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev
Subject: Re: [PATCH 3/9] mm: name pointers to copied PTE values ptentp
Message-ID: <e7osakog3yvdewhdlrk3bsp27pwt2nnhroeb7zihlfxyjotarb@rwxkcb25crh3>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-4-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806083926.1807279-4-usama.anjum@arm.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8330340002
X-Stat-Signature: a3er1r5z9xzfn1jyu31suxjfhbs98ggk
X-Rspam-User: 
X-HE-Tag: 1786445893-274179
X-HE-Meta: U2FsdGVkX18h6d8V8ZUB3CZho/j93NNrKUwm9GMovQOkUdBVQEnrMDWzE/xDvxybWUXmzKeEkpGO93RCngDbob1vW16X1cCZofBQl3JzOzWNt1D3GAPUIDyOdSxd2MWkNnwQ9pPD7g41VM6Oc+T8xqzhPA0PXD7rV9QsH+Aujp3xdzzzlzS03CWeXrPs827gdMY5Lx7lkgS773rOiNbsoH5ZjZcSP6XQ3ORYdxO9/slVdYth3TV6PcYdZfWqJfVroTaG1H3fvK/wIR0Zs7MznAl00rKugQlZyZLVe1m/+ud5sUYj5pnwFoZsXhlGj0rIKSqxgNexD/lSlkq7+fuVwadQ6HtU4UqUpvK8vaYKwkgEbG57X/FA5LQPRB+q3RKg/5d+ZcZBBi2bd2JEicyS26eD5jcwWQx4OpSBxaMvyWTocj35NeOATsL7n9mt/uicyMZnvrznV0yHhErJYmczz3aJyTtDANL5HN1NQwAEjKka+4Ro6AZ58rQ52hM8H2xSgcKjOJyQHXe6qQRy/hl7DvC9mj2YIuVyLSmdLsM7HeH9hRYrCmDEnF4QC175Ltci4Wy+HmkyiVgxfqHXiuILqrddWw3Lz5O7XTptS8rxDGx6sXLVKG2uUtxWIawNuhz0pgI7AAa/nVf7RQLXB+pP/YL2oawwSlvXnrCNmxzEVgcUiECo0MrvdNQTi1iHGQRfPwpfIQFcNCq9rAPP2QrEs3DSs7vleKEueWhf2OEdI2sReRKAb+diiNZHIDCKAGUMCzZy3laH9K8DByYxJjbho/uN0e6uM+M9ODVz62koKd6IC2g21prhQKndoXGBJeOsEzXG7l9+b6FwYA4ibwBLECbGC1v2r3op0V5QYvpStSdFGje0sCKXdjFYR2qoNDdz41BM+Bisd6qynCvT36gwIP9fVSbnfugzWC6k48QE25RkdBUU/Poi/QnWu+sH7HjWaSaFAPS/QEo2C5qN517
 g6W00SFa
 NAaAPmLGhSsyXbNSEV1ZBeCq1X4DUEJO85XgqKPXeNNzyeMnev+i9jUl/UvTSF+573CQyPwrDBx10sR2fVcnBtfM7EaN+oq9YMt29YnBtmFBo3duKHESTYV4ma3joR3mT9MRMNdnMfXju9mRt5xYPcOl2v6uz+dYAfiYb9JGAvkVk8/ic5360+4mOxuIKfosH5HxUNwX+KkQNNnomctev49x2h9ZJ2kaOS7jZwFw1UHtBP6G54i4yiafHX9FfQZ1y/QEZbsajaYLmJD6ckVXZXNA1+ReU1R6bAOdZNlFMVLG2YdBHfonUOAkDCZtDXTdz0Npq8VFSeeI3rt1CsSnF6J+wWn0KmoLjLOaXh1WeesCYhev7NFd5FGG4ldnGiy8u/HeKwx4NYDSPuenA5b0OIDFiAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject line is very confusing. Perhaps something like the following.

mm: Rename pointers to copied PTE values as ptentp

But even 'copied PTE values' is not very clear as well.

On Thu, Aug 06, 2026 at 09:38:41AM +0100, Muhammad Usama Anjum wrote:
> The hw_pte_t conversion must retain pte_t * for pointers to standalone PTE

We need to explain what is `standalone PTE values` first.

> values. Name the value parameters ptentp in the install_pte callback,
> write_protect_page(), and guard_install_set_pte() so the later mechanical
> conversion can distinguish them from pointers to PTE table storage.
> 
> Some functions already use the ptentp name, including:
> - madvise_folio_pte_batch()
> - folio_pte_batch_flags()
> No need to convert them.
> 
> This is a naming-only change.

Small nit - s/naming-only/rename

The commit message needs rewrite clearly explaining the following details

- What are standalone PTE values
- How these are different from HW pgtable pointers
- Change is just a rename for pointers into such 'standalone PTE'
- These renamed 'ptentp' here would be used for skip or replaced during
  upcoming mechanical change via a script
- No functional changes intended

> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since RFC v1:
> - Update the description for the architecture opt-in conversion.
> ---
>  include/linux/pagewalk.h | 2 +-
>  mm/ksm.c                 | 4 ++--
>  mm/madvise.c             | 4 ++--
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index b41d7265c01bc..c34d826c5e4a2 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -89,7 +89,7 @@ struct mm_walk_ops {
>  		       struct mm_walk *walk);
>  	void (*post_vma)(struct mm_walk *walk);
>  	int (*install_pte)(unsigned long addr, unsigned long next,
> -			   pte_t *ptep, struct mm_walk *walk);
> +			   pte_t *ptentp, struct mm_walk *walk);
>  	enum page_walk_lock walk_lock;
>  };
>  
> diff --git a/mm/ksm.c b/mm/ksm.c
> index ad05d7791307e..11d50518d02e9 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -1292,7 +1292,7 @@ static u32 calc_checksum(struct page *page)
>  }
>  
>  static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
> -			      pte_t *orig_pte)
> +			      pte_t *ptentp)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, 0, 0);
> @@ -1371,7 +1371,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
>  
>  		set_pte_at(mm, pvmw.address, pvmw.pte, entry);
>  	}
> -	*orig_pte = entry;
> +	*ptentp = entry;
>  	err = 0;
>  
>  out_unlock:
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad4..c324cc991f841 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1101,12 +1101,12 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>  }
>  
>  static int guard_install_set_pte(unsigned long addr, unsigned long next,
> -				 pte_t *ptep, struct mm_walk *walk)
> +				 pte_t *ptentp, struct mm_walk *walk)
>  {
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>  
>  	/* Simply install a PTE marker, this causes segfault on access. */
> -	*ptep = make_pte_marker(PTE_MARKER_GUARD);
> +	*ptentp = make_pte_marker(PTE_MARKER_GUARD);
>  	(*nr_pages)++;
>  
>  	return 0;
> -- 
> 2.47.3
>

How did we ensure that the above changes are comprehensive and nothing
else got left in here ?

