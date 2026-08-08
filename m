Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD75DC5AC67
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 13:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721E06B00BE; Sat,  8 Aug 2026 09:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3A96B00BF; Sat,  8 Aug 2026 09:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1C06B00C0; Sat,  8 Aug 2026 09:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27A596B00BE
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:57:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E0A8140374
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:57:13 +0000 (UTC)
X-FDA: 85078253946.05.3ABD29B
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id A94A2180008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:57:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWwoHKX1;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786197431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=inITKJNEIJ/fzZw/B+Onv6wqJgdODvMx75Qp9KdBULg=;
	b=M7VMjeHQIZBJ/HGgkFJH15KqVDtZ2XuAIQt8/yFPgKFUUmGK23EJbLQl3UUcp925XSKaH5
	ve0udDmWPniuBspTSKE5ARIhvnECZKCY58z3mCbFH1ZpEPiQb6WQrlNnXLUQEMX4hXp70u
	6Zr4xH7E5u6Qdtwbv05NCbvputWFCnk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EWwoHKX1;
	spf=pass (imf16.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786197431;
	b=3aPp+54sOwVqyLxdleueQOG5DKf+8usuJ/Taqp7/gD0SJxiFHrgiy6sHnO00PPAhTo5QiT
	SiWQdWmJqDDlIBm+jAOur0RBPATiIyBdTSBGQ6QjR9L71ftinMdEmnuw/Xe2eE3sIHoEjK
	rRb7MQpMtV65QcjOcyYh5QogdmccICU=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786197428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=inITKJNEIJ/fzZw/B+Onv6wqJgdODvMx75Qp9KdBULg=;
	b=EWwoHKX1zDlwfhm4jgH6Ts0j/pbZ55U/YQmKJrF2mBZjUbAlSstgMQ7gjSW/Fss4//up6A
	a/OnO1UD4ZbzIbPtWELlcziqvgM3luphoOtQ3BTRCsamxzrE1XQmQmyjAjGS+sWf2y0c4t
	7xBzW5OSYLIc5r6b8L0yAUCAcHtCYwQ=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 15:56:49 +0200
Message-Id: <DKJM4XXSPQLA.13XE36MX0650H@linux.dev>
Cc: "Brendan Jackman" <jackmanb@google.com>, "Borislav Petkov"
 <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>,
 "Wei Xu" <weixugc@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi
 Yan" <ziy@nvidia.com>, "Lorenzo Stoakes" <ljs@kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Patrick Bellasi" <derkling@google.com>, "Reiji
 Watanabe" <reijiw@google.com>, "Sean Christopherson" <seanjc@google.com>,
 "Nikita Kalyazin" <nikita.kalyazin@linux.dev>, "Ackerley Tng"
 <ackerleytng@google.com>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com>
In-Reply-To: <amz0jzVPZo_eBeRV@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A94A2180008
X-Stat-Signature: 75wxqq7tgsncxpjxm9zpetd7bidij514
X-HE-Tag: 1786197430-547429
X-HE-Meta: U2FsdGVkX1+b480XvAdFMGRMwjb2+nAh0vUF0teY/62MfQRXadBiFVRzw9wsee9bM0Gmh2Ldkls3OrP0Hk0QMCPHUn026JwtmYtvYTuMFwnfwqAAHvValnFNMfC5OeWcqF6FPvGzdXy/RFWIHTj5dqDhv/BNc9aCwxHKY7Fw/9T2GmBU+F63VYm/AW+45CadiYnI+InxCvK2ead237K6mr0Gqj3HmptqSJht7214VuJGd9Nem0DMNYWnwmEKAprRyxPgJ/e9UToyxQ3irW6K0XrkvPTtEm88V8hk6WjkDh+Lf2usErjPO59fqql2lJU6zsr8HtQfz/UbfQyEdZjJcAD/v/vWTY1vp8jqo0lGwateASUr9PEp5xOrOhCrvIwrKNlqx8bSa9oJ8IOToZVPhnH2vp0ohmPJamYUoxu8M+kShXH5j4VI9GjxKLcPCEg+0bB8o3bGe35PwMNJs4/CodDVjmcNWW0i1iYyW8loM6dNzbVd9Qsf5dTQbRK57Ve8JXFAN+ixvOf/qZlhmiiCkz2jmdch8HPsIB74Y78+zFO3/ficUAjRJhfTYZyETLOf59A+HD1rGWnWeZgx44C/bY6GuMoHG+2YvqxnPQJ+n9XTvJ/jGrp8LlaLwMtWUqnByj8snoOWtoXfyaLo7OUYfYF8wdfQcuWfJJKbwAq+rknz5TCtHGHq13ES/vuqA5dZTbBo8In27lXIWPUUwKBzjxcAKAHdEIxWoCBE4bTxxH26Wf4J//oGa03+JIho2fOFX1JGySoQsKeqJBpWT9a6QQOC/U+rEzatXXYzMfXnysKOqxwacbbF75q1sWnOtERYcjgRBgiH8bLmhTnUuH47SVDBQgmy+h0xjugdU/ePgQnrpBPsBiD43t53olme4e3bu8vmtjqwH+Ac0N+nUEv5wcCdcc+gcyQXGYzZxcV8EsxockZUwv2eBZ1+O/lVHTtn9ki19L0tkxsrT0dTQHf
 u+Yezfw+
 CzSbcurc/YhFpHdwNVZyo9DN5jv41nDMDUCXqIXhsB/Q/ifgWfMSDr6wogYyaty5Az124uRKkBp4bIYEYM+ZYVq9uyozMpV7x+nxQyf8O51FwEMo+8iZDOXr65ZCFkwbTRpTeAbn83owO2YGv+XIW/dmY4P2A0tqKvPjg+YFNJk1M96Kf01qDNKvcb3JQG4WqVZfoSFnPgryAAQ993oRfuEWJIfskx9Ew0kumjGLK5upktDvkneudTkh3CU3AMthKGBgxtb6L/r/Xbt5cnZxAq9ID2Zn708BG/cnNxe4fJMophXvy5p0KgsfBfFtSmxxggb6/jIN5K1DJvp0F6Hu5AdtefJmlb7qFbV8huXza+1mT7CQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 9:28 PM CEST, Yosry Ahmed wrote:
>> > [..]
>> >> --- a/mm/gup.c
>> >> +++ b/mm/gup.c
>> >> @@ -11,7 +11,6 @@
>> >>  #include <linux/rmap.h>
>> >>  #include <linux/swap.h>
>> >>  #include <linux/swapops.h>
>> >> -#include <linux/secretmem.h>
>> >> =20
>> >>  #include <linux/sched/signal.h>
>> >>  #include <linux/rwsem.h>
>> >> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struc=
t *vma, unsigned long gup_flags)
>> >>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>> >>  		return -EOPNOTSUPP;
>> >> =20
>> >> -	if (vma_is_secretmem(vma))
>> >> +	if (vma_has_no_direct_map(vma))
>> >
>> > Same here, and for GUP in general. For example, KVM uses kvm_vcpu_map(=
)
>> > to map guest memory and access it (e.g. when running nested
>> > virtualization), which uses GUP under the hood AFAICT. So KVM will wan=
t
>> > GUP to succeed, and probably create an ephemeral mapping as well.
>> >
>> > Maybe eventually we will want a GUP flag to handle creating an ephemer=
al
>> > mapping, as I imagine multiple GUP users will run into the same issue?
>> >
>> > Not sure if this is an ASI-specific issue, or if we also have use case=
s
>> > where we need GUP to work guest_memfd pages (with ephemeral mappings).
>>=20
>> Similar to above, this shouldn't affect ASI at all.
>
> But outside of ASI, aren't there any cases where the kernel (e.g. KVM)
> needs to access guest_memfd memory?
>
> Maybe Sean or David can help us out here.
>
>> >>  		return -EFAULT;
>> >> =20
>> >>  	if (write) {
>> >> @@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>> >>   * This call assumes the caller has pinned the folio, that the lowes=
t page table
>> >>   * level still points to this folio, and that interrupts have been d=
isabled.
>> >>   *
>> >> - * GUP-fast must reject all secretmem folios.
>> >> + * GUP-fast must reject all folios without direct map entries (such =
as secretmem).
>> >>   *
>> >>   * Writing to pinned file-backed dirty tracked folios is inherently =
problematic
>> >>   * (see comment describing the writable_file_mapping_allowed() funct=
ion). We
>> >> @@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio=
 *folio, unsigned int flags)
>> >>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>> >>  		return false;
>> >> =20
>> >> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
>> >> +	/* hugetlb neither requires dirty-tracking nor can be without direc=
t map. */
>
> Is this necessarily true? I know there were discussions/proposals about
> using some of the hugetlb infrastructure for guest_memfd. I am not sure
> if those folios would remain hugetlb folios though.
>
> Adding Ackerley here.
>
>> >>  	if (folio_test_hugetlb(folio))
>> >>  		return true;
>> >> =20
>> >> @@ -2812,7 +2811,7 @@ static bool gup_fast_folio_allowed(struct folio=
 *folio, unsigned int flags)
>> >>  	 * At this point, we know the mapping is non-null and points to an
>> >>  	 * address_space object.
>> >>  	 */
>> >> -	if (check_secretmem && secretmem_mapping(mapping))
>> >> +	if (mapping_no_direct_map(mapping))
>> >>  		return false;
>> >>  	/* The only remaining allowed file system is shmem. */
>> >>  	return !reject_file_backed || shmem_mapping(mapping);
>> >> diff --git a/mm/mlock.c b/mm/mlock.c
>> >> index efa6716e4dfbd..045b6779440b1 100644
>> >> --- a/mm/mlock.c
>> >> +++ b/mm/mlock.c
>> >> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, =
struct vm_area_struct *vma,
>> >>  	int ret =3D 0;
>> >> =20
>> >>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
>> >> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
>> >> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
>> >
>> > I don't think this one is correct. From commit 1507f51255c9 ("mm:
>> > introduce memfd_secret system call to create "secret" memory areas"):
>> >
>> >   Since the secretmem mappings are locked in memory they cannot exceed
>> >   RLIMIT_MEMLOCK.  Since these mappings are already locked independent=
ly
>> >   from mlock(), an attempt to mlock()/munlock() secretmem range would
>> >   fail and mlockall()/munlockall() will ignore secretmem mappings.
>> >
>> > Seems like secretmem pages are just mlock()'d by default, hence the
>> > check here. Maybe this also works for guest_memfd, but I don't think
>> > it's a generalization that any pages without a direct mapping should
>> > receive the same treatment here.
>>=20
>> Ack, yeah this sounds correct to me.
>>=20
>> I guess you could argue something like "the reason secretmem is
>> implicitly mlocked is that it can't be reclaimed, because there's no
>> direct map". But that doesn't generalise IMO, you could imagine letting
>> the user say "remove this memory from the direct map, but I trust my
>> swap system, you can swap it" and then use the mermap to implement
>> reclaim.
>
> Exactly, I don't think no direct mapping implicitly means unreclaimable.
> I don't think you actually need a direct mapping to read/write from
> disk to memory?
>
>>=20
>> > I am aware that perhaps the answer for most these cases is that it wor=
ks
>> > for guest_memfd as well as secretmem, but since the main goal of the
>> > series is setting up ASI,=20
>>=20
>> [Aside]
>> 	Well, the main reason for Google to pay me for it is as a
>> 	stepping stone for ASI, but I do actually think
>> 	GUEST_MEMFD_FLAG_NO_DIRECT_MAP[0] is valuable and prefer to
>> 	think of that as the "main goal" of this patchset. (I didn't
>> 	include it here since Sean asked[1] for the KVM bits to be
>> 	separate, but it's basically just a repeat of the secretmem.c
>> 	changes).
>
> Right, I understand this is the goal of the series and it is valuable
> without ASI. Perhaps "motivation" was the correct word :)
>
>>=20
>> 	[0] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.=
com/
>> 	[1] https://lore.kernel.org/all/akw1lZDEv8_Ub1zQ@google.com/
>>=20
>> > ideally we don't want checks that we know
>> > will become wrong when ASI is introduced. If the idea is that
>> > mapping_no_direct_map() and vma_has_no_direct_map() will not be used f=
or
>> > ASI sensitive mappings,=20
>>=20
>> (I said this above but just to be clear: that is not the idea).
>>=20
>> > we should document this somewhere, or have
>> > better localized checks (if at all possible) so that we can side-step
>> > the whole mixup when ASI mappings come along.
>>=20
>> BUT yes I still totally agree that we should not unnecessarily overload
>> vma_has_no_direct_map() here.
>
> Right, that was essentially what I meant. We shouldn't just current
> secretmem checks with no direct map checks without thinking them
> through.
>
>>=20
>> >>  		/*
>> >>  		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
>> >>  		 * count.  For secretmem, don't allow the memory to be unlocked.
>> >> diff --git a/mm/secretmem.c b/mm/secretmem.c
>> >> index 4a4934769f8ba..c043c53687d95 100644
>> >> --- a/mm/secretmem.c
>> >> +++ b/mm/secretmem.c
>> >> @@ -52,49 +52,20 @@ static vm_fault_t secretmem_fault(struct vm_fault=
 *vmf)
>> >>  	struct address_space *mapping =3D vmf->vma->vm_file->f_mapping;
>> >>  	struct inode *inode =3D file_inode(vmf->vma->vm_file);
>> >>  	pgoff_t offset =3D vmf->pgoff;
>> >> -	gfp_t gfp =3D vmf->gfp_mask;
>> >>  	struct folio *folio;
>> >>  	vm_fault_t ret;
>> >> -	int err;
>> >> =20
>> >>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))
>> >>  		return vmf_error(-EINVAL);
>> >> =20
>> >>  	filemap_invalidate_lock_shared(mapping);
>> >> =20
>> >> -retry:
>> >> -	folio =3D filemap_lock_folio(mapping, offset);
>> >> +	folio =3D filemap_grab_folio(mapping, offset);
>> >>  	if (IS_ERR(folio)) {
>> >> -		folio =3D folio_alloc(gfp | __GFP_ZERO, 0);
>> >> -		if (!folio) {
>> >> -			ret =3D VM_FAULT_OOM;
>> >> -			goto out;
>> >> -		}
>> >> -
>> >> -		err =3D folio_zap_direct_map(folio);
>> >> -		if (err) {
>> >> -			folio_put(folio);
>> >> -			ret =3D vmf_error(err);
>> >> -			goto out;
>> >> -		}
>> >> -
>> >> -		__folio_mark_uptodate(folio);
>> >> -		err =3D filemap_add_folio(mapping, folio, offset, gfp);
>> >> -		if (unlikely(err)) {
>> >> -			/*
>> >> -			 * If a split of large page was required, it
>> >> -			 * already happened when we marked the page invalid
>> >> -			 * which guarantees that this call won't fail
>> >> -			 */
>> >> -			folio_restore_direct_map(folio);
>> >> -			folio_put(folio);
>> >> -			if (err =3D=3D -EEXIST)
>> >> -				goto retry;
>> >> -
>> >> -			ret =3D vmf_error(err);
>> >> -			goto out;
>> >> -		}
>> >> +		ret =3D vmf_error(PTR_ERR(folio));
>> >> +		goto out;
>> >>  	}
>> >> +	folio_mark_uptodate(folio);
>> >
>> > This chunk seems like pure refactoring that should be done separately?
>>=20
>> This is the adoption of AS_NO_DIRECT_MAP, i.e. the removal of the
>> explicit folio_zap_direct_map() call. We could certainly separate out
>> "create AS_NO_DIRECT_MAP" from "adopt it in secretmem" but the previous
>> version of this patchset was on v12 and it hadn't split them so I assume
>> nobody was calling for this split.
>
> Oh sorry I wasn't clear. I meant switching from folio_lock_folio() and
> the rest of the logic to folio_grab_folio(). There are some subtle
> differences AFAICT so this conversion shouldn't really be part of this
> patch.
>
> I think maybe just drop the
> folio_zap_direct_map()/folio_restore_direct_map() calls for this patch?


