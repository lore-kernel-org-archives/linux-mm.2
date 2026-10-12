Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160DDCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 15:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292DB6B008C; Mon, 12 Oct 2026 11:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2433D6B0092; Mon, 12 Oct 2026 11:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CA86B0098; Mon, 12 Oct 2026 11:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCEAE6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:22:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0B681C49DC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:22:28 +0000 (UTC)
X-FDA: 85314340776.01.1AE629E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 418C3160006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:22:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhvFY7Na;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791818547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Hl7JhwHL6QZRyn/5JpMAadGxR10kpDMUmsBVHSxWuc=;
	b=8fSlM9cMNjFiaOYTlDH3GvFK9WpK787kgMAZY2RRVPPK9hoM++QLCg4+rc4zIIwbJfMlqR
	diuE9IP5J+eWNvC/qo7/tVogeLLIAcumUOKuS0cqFm0Gy/F398ggyso1LWPqkKGxtKi4im
	Alfe1uvZz/pdIbuB8OdWMrQ3PqKbK8M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhvFY7Na;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791818547;
	b=iwmFYvTkUak0FjR+cRQvyiX6HSCtcEFzcWX27MfR8JQRDhzoRZVKDpvzq2zIcFiYr+RlTX
	N2JQ/zVRhVc5V55HvsgXQ1+192BhdxERFAgKlyK6te5oJAFjhIkNVFwDs9u4zi7dOM9KvX
	4Z8AAD8Ib7ljttECkZqUrPWCI+AQLIQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8A496021E;
	Mon, 12 Oct 2026 15:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FF01F0089C;
	Mon, 12 Oct 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818546;
	bh=+Hl7JhwHL6QZRyn/5JpMAadGxR10kpDMUmsBVHSxWuc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IhvFY7NaCyskeu05X+aLMX9HkouW/N/AnO9Zs8otqIRZixbmqRO2BuBo8w05ZD6nr
	 WJRZ3iCk1bveU2hU3ZlJSq/af1nWy9ksW0euhl3liA26QdJzXslkxBYBeC040mAmOM
	 9Fp0vXCAitJLJLPD87orxoZIupHoZkBND7GKoztd14FOTtahelazj+wWjMSJQBQQh7
	 u9JNGgmTIG7F8qfvMIRII8zXi/i7h/ICdnQNgCIwZwmV+hNSeLZcN13t3Mbs90A1nr
	 Z+9pxp3UMPQab0fcnR7DgsY7WMHO27D2oaCIICZvUF/yGrGA2Ig8w4Q/Ibwe/5bGVc
	 w+9slFmOe3iEg==
Date: Mon, 12 Oct 2026 16:22:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <asz2domYFnTe2owf@gremlin>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
 <asy445BYRhcsGDE9@gremlin>
 <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 418C3160006
X-Rspam-User: 
X-Stat-Signature: 6bcczqtpuizttzqo7h3ayb8jzc74j6i4
X-HE-Tag: 1791818547-743763
X-HE-Meta: U2FsdGVkX1+CkSwaTWqXW9ulRN2jUOEzxGez51L9DCM+h71NhMRmFXZtYKDVb3MNnv8058LM5YWYY8cyzUadAU5AfKmUaS7Gf9yq4+Ns6dIInBI0CtYpheWFAIIe40T5VAdGOvvyeVnVfJhN7K9zFrtk+vhF/Cdo8Q2/2UIGfvFC7dsvQiMLI3xtX51UWdX8RbIC2kBKyxTdGpD1haH6mu0K/QWEd8LxUMfHTh17Dd87dz2+NYp1vsiE1av8az50wNgl3p/jKCoKMNZR2IWt3XoSj2NyhF9c3TyQzeCOFsmS5eM8vMd7wtxT5zIIJI2cps6XMgpbWQ4fWxDRjRXJA2318Sqy9jdz4/LdD2xjobenPIq+PCe72Vj1KqXNP58u0+mC8t1q40l6xPibf/6038Dwy5sX3HerfZpXTd47H1UEQydZ+rkRhGXA7ap6uNkkun0DlmIZOfUi5xpwzLki4srbw8y6WGRmxTnVn7N517sPe5P1g2aLqmTunG7vvKzlRQn71lniq1W/Me82dsiGm1hhIEsmlaBo1fCa86iSNdZK/kePuDb09ZdFxu/46w11BZNrc7MwDRic0JU54gTWAKyV+1EURdmVSAxPNbkJIsAP4A5v6d4nc4A4HrBAkUDkzgKnKiSqEClFQVULONpdgEmMkCJQAiiAtL+YJkbw1Tq7Dpc72bcAfXWpoWuRbOih5xwAMjClgIgiefibrJ/npv3I0BbQ3sKToe4pASuzDFIvtaDzTlTMiL314BzLSKGoL3hD0kmuaZ7baCbFBDxA26OGIjiPki+twEhmgQV44y3pWEQvbzGKkSnjuHVNf7SrEAYlwzOkl3Kh8y6+BJIip2IRKBtptBtu6cAhF54UMMRK/FKtdTpKvO7mWfUtKznS91R0ebd7bsu8wMh5hWkbyqVk7p+oS79WlsvXX0JPx0zA4IW0NgziofIUkiUdy9gpaoD+D82lOJmR97nmELj
 Kt2Hiyni
 7lWiLnpBpcFN6NTm/p5zozjNKLlX/GBOrIzSNy+lvFDiW7TLrzIRYoj46T5pys+rl1IR3uzQYIGUc68xsbgf0FgNoGBoXBHOkzmBDtUJNtdMyYVErNEE9jxAoqSk/s3vgAD/7RSfk6UnbtnKTTsWR47CGZ687N+2m6GKMDaE/fepEf2r5gz78AN8mb9KKgbY00SoRwwE8yDAOEh2ca2ETlSVmDnMmSKv4J/OYh9PYnolsmYqOeezq+6PTYSZIsgNTJgSABeCimJ9RjRefOkU7tkkxJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 10:33:34AM -0400, Zi Yan wrote:
> > Looking at the code:
> >
> > <anon_vma lock>
> > [reclaim]
> > < PMD lock >
> > -> try_to_unmap_one()
> >     -> unmap_huge_pmd_locked()
> >       -> __discard_anon_folio_pmd_locked()
> >         [ clears PMD entry ]
>
> The PMD becomes pmd_none().

Yup.

>
> > 	...
>
> There are two readers making decisions based on “pmd_none()” locklessly:
>
> 1. munmap case is via zap_pmd_range() in mm/memory.c: it skips pmd_none(),
> so the above folio is not zapped;

Yup I get at that below.

It also doesn't serialise on the PMD lock as a result.

That's really key isn't it?

		if (pmd_is_huge(*pmd)) { 				<- returns false
			if (next - addr != HPAGE_PMD_SIZE)
				__split_huge_pmd(vma, pmd, addr, false);
			else if (zap_huge_pmd(tlb, vma, pmd, addr)) {	<- doesn't lock the PMD
				addr = next;
				continue;
			}

So it skips it and nothing happens to the PMD nor is there any serialisation
between unmap_huge_pmd_locked() and this code.

try_to_unmap_one() will be called under the PMD lock because of this In
page_vma_mapped_walk(), I believe:

bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
{
	...
		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
		    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
		    pmd_is_device_private_entry(pmde))) {
			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
			...
			if (likely(pmd_trans_huge(pmde))) {
				...
				return true;
			}
			...
		}
	...
}

>
> 2. MREMAP_DONTUNMAP case is via move_page_tables() in mm/mremap.c calls
> get_old_pmd(): get_old_pmd() returns NULL for pmd_none(),
> so move_page_tables() skips the above folio.

move_page_tables() is called for _all_ mremap() operations. So the same issue
would occur across mremap().

That bit isn't special to MREMAP_DONTUNMAP.

>
> > 	[ reinstates PMD entry later ]
>
>
> 1. for munmap, unmap_region() calls free_pgtables(). In free_pmd_range(),
> the restored PMD is treated as pmd_bad() and cleared. And the folio’s
> rmap is not removed.

Yup I got to that point below :)

>
> 2. for meremap, dontunmap_complete() unlinks anon_vma but the source VMA
> still maps the folio.

Well, only if the set_pmd_at() managed to reinstall it AND the PUD page table
that mapped it still exists.

That set pmd could also UAF on the PMD page table in theory couldn't it?

It's all really horrible.

>
> >
> > Concurrent munmap():
> >
> > <mmap write lock, downgraded to mmap read lock later>
> > do_vmi_align_munmap()
> >   -> vms_complete_munmap_vmas()
> >     -> vms_clear_ptes()
> >       -> unmap_region()
> >         -> unmap_vmas() < zaps > <----- EDIT: the real issue, see below
> > 	-> free_pgtables()
> > 	   -> unlink_anon_vmas()
> > 	     -> < anon_vma lock taken! >
> > 	   ... clears down page tables (no rmap lock) ...
> >
> > Is the issue actually the zapping in unmap_vmas(), which doesn't seem to be
> > protected by rmap lock at all, meaning that _that_ can happen with
> > concurrent munmap()?
>
> No. zap and rmap walkers are serialized by PTL. The reason is described above.
>

Well, no, that's not quite right AFAICT - as above the PMD PTL _is not taken_
because the PMD entry is cleared.

So the serialisation that would otherwise exist between the try_to_unmap_one()
and zap_pmd_range() doesn't happen.

> >
> > So unmap_vmas() doesn't correctly populate the mmu_gather struct for the
> > range, meaning that the underlying page isn't freed and the refcount,
> > mapcount etc. are all left as they were?
>
> Yes to the underlying page isn’t freed.

The refcount and mapcount etc. would be correct? I think the refcount would be
such that it permanently leaks and the mapcount would be incorrect or only
accidentally correct?

>
> >
> > MREMAP_DONTUNMAP seems a bit of a bizarre callout, but I suppose it is the
> > other case in which (under certain, likely, circumstances
> > e.g. non-partial/self-merging remap) an unlink_anon_vmas()'s call is done.
> >
> > With normal mremap() that'd happen via an unmap of the original VMA.
> >
> >> rmap walk uses the freed anon_vma.
> >>
> >> Using an invalidated PMD instead of a cleared one requires additional arch
> >> code fixes. Instead, disable the PMD level discard of lazyfree THPs, as
> >> before commit 735ecdfaf4e8 ("mm/vmscan: avoid split lazyfree THP during
> >> shrink_folio_list()").
> >
> > Again it feels like this commit message assumes a bunch of information that
> > isn't presented here.
>
> 1. SPARC has thp_pte_count-- in its pmdp_invalidate(), but set_pmd_at()
> does not add it back, since the code assumes pmdp_invalidate() is only
> used in THP splitting code.
>
> 2. GUP-fast accepts an invalidate PMD on s390, risk, loongarch. They
> need to fix it to prevent GUP-fast from succeeding for this new
> pmdp_invalidate().

Thanks that's useful to know! And ugh.

They seem like they are existing bugs effectively in pmdp_invalidate()? Or stuff
that we would want to fix anyway I guess?

In general the point of all the above discussion is to encourage a commit
message that conveys this information clearly.

When I read the patch first there was a lot of 'huh' and that's a sign that the
commit msg doesn't say enough.

> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index 805db93fe0428..1131b76bbbc28 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -2275,17 +2275,6 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> >>  		}
> >>
> >>  		if (!pvmw.pte) {
> >> -			if (folio_test_lazyfree(folio)) {
> >> -				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
> >
> > This is the only caller of unmap_huge_pmd_locked(), making that and
> > __discard_anon_folio_pmd_locked() dead code, shouldn't we remove all of it?
> >
> > Otherwise we're leaving dead code around.
>
> 1) it keeps the backport small, 2) I am going to restore the function and
> this reduce the code churn.
>
> I can remove the dead code if you think that is better.

No, if you plan to reinstate it (soon!) then that's fine, but please
explain that you're intentionally doing that in the commit message please!

--
Cheers, Lorenzo

