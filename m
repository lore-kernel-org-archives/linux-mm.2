Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2074C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85EC46B0088; Mon,  3 Aug 2026 10:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FB06B008A; Mon,  3 Aug 2026 10:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FF116B0092; Mon,  3 Aug 2026 10:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 43AFB6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:30:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C394FC071F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:30:25 +0000 (UTC)
X-FDA: 85060193610.20.E2A1562
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09D9D140007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:30:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KunjWBf2;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785767424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBUO0sI60vSvUUULyUBjZ5PO/NpGB9Aqguv7Qzws6Zw=;
	b=JAGhAXisHFXpkjcBMYsnSwDtiGcJ/2NADjG5PUp1pApMe/p+wMqxLE+8K1fRJJ9Z3A3urd
	35RhSFv5H7efk5vhE/OyjT9cYnk2L4zzQMhXu+rhX5JPOU/Q3F+FWM1E6H1DF9uphyW2RX
	0nzgUTIw31NxyBfSCDCoqcPfrKeld4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785767424;
	b=qJrFXzkOxhgzmYtrQGsZYiYgcouTrECUI+iQYMuK0v/rVLQF5zyw8zLI3dmM0nXQkmlcmi
	hX8XKtHpuNUX7EcAtpl+izbYgHST2By6+1dRuWXILc1roYbYr1Dcva8NrbDzSrYqfUGTFW
	EsE59XQv+JtTVqVH+vfIgKaZPAY1KsM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KunjWBf2;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E330641A8B;
	Mon,  3 Aug 2026 14:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D91F00A3D;
	Mon,  3 Aug 2026 14:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785767422;
	bh=tBUO0sI60vSvUUULyUBjZ5PO/NpGB9Aqguv7Qzws6Zw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KunjWBf2HfEayrRWcgqlNF4dW8kZwEqvN9UMQVHbeVCf0bXTvc+9at69v/s86hVAy
	 koxpSd5erKYHoQX6nU7pnxFVeAtOusP96Z+voCXciMEyecY4S+LM9crnVyh2EyWsJs
	 ZGRosrBTJnaKMq/d21m372wXHZWkB7RqQOG8oYWhA5vCaKtJoEHCZZ8ByMRdEjQlkN
	 pqiWrjr6BscxP4XUIMy8ofhjFcI8Ie4RbM+d8A5AO4eUk3TihD5OvMlO5qzUrV/nnQ
	 yvjunAW8aAvCp/IczAYDcLvAXMtPV+pZelWzN4EzWjCR1M8tEGuY0Hyp0KY2Z9+Trw
	 OoTsIb5WR/IgA==
Date: Mon, 3 Aug 2026 15:30:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 08/15] mm: introduce and use linear_folio_page_index()
Message-ID: <anCdkHNmG5K43E6l@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-8-e8ecfefea812@kernel.org>
 <0d9f3040-825d-49af-9d07-1e7945dd3e9d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d9f3040-825d-49af-9d07-1e7945dd3e9d@kernel.org>
X-Stat-Signature: 3uji1z3cpzoo6fxqtqbmobxdg93hidzb
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09D9D140007
X-HE-Tag: 1785767423-417067
X-HE-Meta: U2FsdGVkX1/M+Ew0YCUGKODRIrg2Kr+inSxrrvSE1IRD8GGUyP8OvohA7VTkMBJUi7bqWIL/nk9puhvccU//umLYdktl93W9ZVxpbQ71jt6ecKePhgiacY/bqsBMV2feuOHqOVHqyJU1JicVYcOcEAojNlvOKNJx5KQAgX/Oy+WumkmjJ+udxJp4PFNTpA+T6jB4uLxE5YxcqpenSoeUGPZ9rxPBHwbYMWa9Diyr7YrnV+uInDVGPDLFllaVKuPjL7103DFc5XbtphFDRfx8QY2+VSreeFtiXrMQiKGhsLFUCQtv23NRweMDxDgwanjpshgfFbhaixT9+3BcifFYhOED+nQnvklQkn6uq7PoPdyli7DqVznLTgl3ECiWbWbRSDJM5PEDFfWU/hqDIZluKjTPXp7UUWyomuSa3SBewT0mA2+9oV9PM7WJmjGSDggIraabJ+SKShX5Xr34JLlSKdEBkxIqv8R7LbhNmMn8E23A0pXyCTNqPNBxeiJy6moV9e3r4J4S15laAWN+TxzEcQ08gRUA9cU27n6UWl/UlYNzWLuwJZeiGa4wH8K+QNA0iX7FLIbDN9WigyQOOn7CkWSTwg54j2pumXSVMYrabwNzFSb3LXJildKYfVcMO5hY4UyCcCJ8cage66gDQRNFqR+HKLJlCoM5RkpE6+1/XKcPf9r9S+LQUYbn9tSFv103Xl4XGNso4hMXobxoUsPiyexLcw0feVfCeZn71Z62nhO1Lro6SQxm3YWX+ji2NKX7Kwu8vYqlUg97KQihosv1dqHZJk7GpuF+cnuEsTP5/M3BtIQ8MB/YYePWwUGBpyBuTW2MfA6ubBSHIS7NLdN9YpYB8Gf+AUxtAKzcgRliIZPBde8HtbcjZ+VP0UWyVMfojBA5i3+IrhBFHLN81eLM+M9Ewq1BgM3jqQfEEmyGIjDYGjlLP4CTaz2R82bRHEj952VQ73cE1XnkuMuFqCQ
 EN7sjTez
 ZXTkH2f1EcYV9QG3g/h5EwyMqLtRdOa7bcRQsSSmKUHTpIclq1CEgouucXWeRJFzVgo+6b86U0CRVX7SufhM2/16gAlwL3uUW4sC9gaJGxJN23TDvKDAGM3KtiMIq4hAT75Rz10aYVJ0hTGD6T7lG5LXFIvI3ID8bKvX4f+tYlFNjGTb1ZDMbzbuc72he20JDCQEOoDNER504Zl95y3YMf2shyGAhhgbzBprz3IPUhQAKYVJebUIXNy3TL4mC/YEUgEn3mxvUcCrwh+F2SZdj49imi7lgGZsguCZkTjjq/hnQ6nzYhizLKF7jOzcsXxlsIF1Gbrrzflv4oggFhOLQGs7aUjMLZy2miD5ZPDS6MedOHrWdCljT1bmwF9dblOOwOwxMEzGmYk1bevEZ3Q9SE9TDlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 01:27:09PM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > This function is, for now, a placeholder; it will be used in future to
> > determine whether to use the anonymous page index or not, based on whether
> > the folio is anonymous or not.
> >
> > Currently it simply wraps linear_page_index(), so this does not change
> > behaviour.
> >
> > We update callers that will, once the change is introduced to track
> > anonymous folios by anonymous page offset if MAP_PRIVATE file-backed, need
> > to determine which index to use based on folio type.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/pagemap.h | 18 ++++++++++++++++++
> >  mm/huge_memory.c        |  3 ++-
> >  mm/migrate.c            |  6 ++++--
> >  mm/userfaultfd.c        |  6 ++++--
> >  4 files changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 259177544b03..6eb8d811ba4c 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -1143,6 +1143,24 @@ static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
> >  	return pgoff;
> >  }
> >
> > +/**
> > + * linear_folio_page_index() - Determine the absolute page offset of
> > + * @address within @vma from @folio.
> > + * @folio: The folio whose linear page index is sought.
> > + * @vma: The VMA in which @address resides.
> > + * @address: The address whose absolute page offset is required.
> > + *
> > + * For compatibility, currently identical to linear_page_index().
> > + *
> > + * Returns: The absolute page offset of @address within @vma.
> > + */
> > +static inline pgoff_t linear_folio_page_index(const struct folio *folio,
> > +					      const struct vm_area_struct *vma,
> > +					      const unsigned long address)
> > +{
> > +	return linear_page_index(vma, address);
> > +}
>
>
> I found this to be rather confusing, given that we now have a "folio" helper that
> receives a folio and a "page" helper that doesn't receive a page ...

This is just to avoid having to duplicate the if (folio_test_anon()) { ... }
else { ... } stuff.

Agreed it's a bit confusing!

Really you are figuring things out from (vma, address) - 'what is the correct
page offset based on the VMA'.

And yeah it seems migrate can do it via PFN as you suggest, it really is
just trying to find the page offset in the folio.

But...

>
> I guess the problem is the "page" in "linear_page_index", as it
> reminds of legacy page->index.
>
>
> I wonder if it would be better to have a linear_folio_index() and
> force that address points at the start of the folio.
>
> Looking below, this is exactly what we want for all except one case:

...I don't think this is true.

The uffd code uses this too in move_present_ptes():

		src_folio->index = linear_folio_page_index(src_folio, dst_vma,
							   dst_addr);

And it's now _updating_ the source folio index to the offset in the destination
VMA, so it doesn't even relate to the source folio's offset at all?

(move_swap_pte() calls linear_folio_page_index() but obviously has to be
anon, so that can just use linear_anon_page_index() there instead, will
update.)

With your change we can just eliminate the linear_folio_page_index()
function and open-code the uffd case.

It's a bit of a special case anyway and is neatly the one place where you
actually don't know if it's anon or file-backed (well anon or shmem
specifically I think).

>
>
> >  		/* pgoff is invalid for ksm pages, but they are never large */
> > -		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> > -			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
> > +		if (folio_test_large(folio) && !folio_test_hugetlb(folio)) {
> > +			idx += linear_folio_page_index(folio, vma, pvmw.address);
> > +			idx -= pvmw.pgoff;
> > +		}
> >  		new = folio_page(folio, idx);
>
> I think we could avoid this index work entirely by using the pfn, which is much
> clearer to me, and similar to how we handle it during other rmap operations.
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 222c8c15f782f..686351d353203 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -362,17 +362,12 @@ static bool remove_migration_pte(struct folio *folio,
>                 struct page *new;
>                 unsigned long idx = 0;
>
> -               /* pgoff is invalid for ksm pages, but they are never large */
> -               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> -                       idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
> -               new = folio_page(folio, idx);
> -
>  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>                 /* PMD-mapped THP migration entry */
>                 if (!pvmw.pte) {
>                         VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
>                                         !folio_test_pmd_mappable(folio), folio);
> -                       remove_migration_pmd(&pvmw, new);
> +                       remove_migration_pmd(&pvmw, folio_page(folio, idx));

I think we'd need the idx code below to go above where the idx code is now
as otherwise this will be incorrect right?

But then again, if it's a PMD softleaf it'd have to be aligned right, so
couldn't we just update that function to be passed a folio instead and
avoid the idx here at all?

>                         continue;
>                 }
>  #endif
> @@ -385,10 +380,14 @@ static bool remove_migration_pte(struct folio *folio,
>                     try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
>                         continue;
>
> +               entry = softleaf_from_pte(old_pte);
> +               if (folio_test_large(folio) && !folio_test_hugetlb(folio))
> +                       idx = softleaf_to_pfn(entry) - folio_pfn(rmap_walk_arg->folio);

Could actually be softleaf_to_pfn(entry) - pvmw.pfn even?

> +               new = folio_page(folio, idx);
> +
>                 folio_get(folio);
>                 pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
>
> -               entry = softleaf_from_pte(old_pte);
>                 if (!softleaf_is_migration_young(entry))
>                         pte = pte_mkold(pte);
>                 if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entr
>
>
> remove_migration_pmd() will work for now. Later it should just receive the folio
> and do the same thing through softleaf_from_pmd() -> softleaf_to_pfn().

Ah you already addressed it. But since this would move the idx code above,
I think I should just change it to accept a folio instead?

Or for less churn &folio->page...

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

