Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CB6BC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 15:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CD56B052C; Thu, 13 Aug 2026 11:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E016B052D; Thu, 13 Aug 2026 11:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B676B052E; Thu, 13 Aug 2026 11:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD6B86B052C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:32:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73B4B1C0A21
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:32:14 +0000 (UTC)
X-FDA: 85096637388.27.F8FF4B2
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	by imf25.hostedemail.com (Postfix) with ESMTP id 815F7A000C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:32:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3wRhpkU;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786635132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10gMp1YaRW9PuC9piHPqFMk2DiRElJ4cgwclKG+ptB4=;
	b=Ip3LxOlsuWMsWFAWXCMU74sOpxcDJ3k+Ddv22amur7oK1rVWFoNZCsGng+rMBb6tnLOg4x
	PcmUMgKIVFzuC3T0M5zCHLThe52bPxDYDt0/f62mhKpk6wp+x5mJRSmcQCSHSfPEU9WSt+
	2gBs4XYkK37D/rfg9Pp0XcOvOLXUqVo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I3wRhpkU;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786635132;
	b=TDgUR7W8x5T5IOIJHH47oINS9d7pd0EFVfzO74kGNUbL50laQopx7LV4o9CvZ81v7fP38M
	Q0QE/sTjkjfy9bLpHmroXYKp8iYU3KZAMp5pJM+nP29j3orSrildSILf3FHamI/k3BediY
	nh5rQPvb2KERynnqAPFL7LDjKkExLlg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=21CxL64E5wvwVmKuUEtjeFpitv04JpKOndGL+tFRCGk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786635126; v=1; x=1787239926;
 b=I3wRhpkUPfBjO+pyhU2vatPE1Rr6QhTmjnk//ALSs1mDLEGUP1VH8MpC2+XRFFbLVOuY4db4
 GvMhPcoFbJUpewvl1+7JXJG0O62lQWcoplb8Iz59qrLJJWqNNhlNa/m8ppeQ0xJVA0v/wmcHqEd
 N7ipwOCQ7hs+4MNkAIfq8/3U=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 9cd5fe5c07c2ba09;
	Thu, 13 Aug 2026 15:32:06 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 13 Aug 2026 16:32:04 +0100
Message-Id: <DKNXALH7DITL.349JD9B5RM4EH@linux.dev>
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
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com> <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
 <amz0jzVPZo_eBeRV@google.com>
In-Reply-To: <amz0jzVPZo_eBeRV@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815F7A000C
X-Stat-Signature: dzphtz6n8stuf93je8kag9guxuwmnz9g
X-Rspam-User: 
X-HE-Tag: 1786635130-648445
X-HE-Meta: U2FsdGVkX1+EWiZCXMJ+KwqshVsVGvmKR6y50VAPwFljZm88XpRNEOyS+ar1LtfVeunDKpa6wjRR9Hl3BPIRGwlUkhjzMZw8G6gcmW0WRYVyN0LNqTms72/xhtTzOon1pem/xqXxbDXAXV2alEWUEOTfm1N3XMjpQ+2l4EiBlOOGkZxeDxPHxcILN1hdBzik2jM1InwsO6d2eElLYGQ74WkTCkCHGDxCyEWywrZibnKxyge5a7yRnQtQ2ddjL8yHbZceaVD51vUt9DS5O2jQgciqBuC2RrMueetZXXiDglqY9hM+pSF6b1Sw8Q8iPJu1HPB4MkFTkv5cYe9uA0dU19sMul5DAJ/gv1Yyf/keGLFCd8dDy3m70EoCtyOIgQh4HyL34dngNoJiCqxCz63k4BsJC0XSGK2oxBYSI8tZL5egxlAAOoInWI07F/wqKi7ihjxez6LD5hOndZIaLpBH4HP6sVIUXjG15BvgQqhf/goiO2gCJzvQcoeqGNkdJKGYaF29wwwMoPF9pp/sIvUiBHcpxpS5C2N4ObBdkxX03Yg/kZzC0dmKSYqMGz77lZbLoD5X1QZ4u7E7l2gu6bcqYYNw76BgHOI/2XWSxrhhPwFeHYbXSKSDCzoP3T5yyD8pSnx9FYQ+DFGkfXpazP+3NoHqYth3X7kVfxeioB/ts1yMhs5lLnuf0jNLSYfm6vHBO1j/AgQa7iU+pfcn4D1grRojw12zqxH0fpw5+3YrNntrDQ3YOcCPkz8gUaQkZjw5meaZlTdYXMJZRRas26IBgRQ1ybkfa87fejFPmGDlnWNRy1u8maIf4ZpzxEOMTUXP7I4mGGHhQFjuyGdTjgNhUE2vwuvc+9/+6KNTtjsyzm2Bzume7Wf8yu06kPcoWC5TQemkmtBMNYnXFbWMtP0RpklUx4aw1JV8N+p4JsKUu7Tm9EU/dw7TKYQvQ6H4Z2bvwz75YOIqs7E6idRHfRg
 4ch8gYRi
 M1KYua65JEPnjbCweZjMTrIWXrrWI2oKgsYtejWbGa1VdE1h32rQZ1Uo8+2ieT+XlzwQ6FqYereSzKgQntJkITWsUiwjNxkAHNChSNgB/uTXawDYaSZzl3IaHesyj1SInrbbHsFvWGHJwPbh7qNHtX//2UDAdFCGAP7+OPEKDwb6kd7MnmQAV2/Pxh6E3WtXlSQ0TAdZxeEwSUJb1VklFf8YAgV4CA3FGZo8w+GcpIQP5Q+bFhgD+YFKPT0uC6CKyphJTD/BEXq5fPlctWfjK4nIkhZLxUgXUjkgifXkPfC6EdMlHbp/PPLEQNY9Mc3PU8pd5oyemuZIXXN4Ae2WwOzq6WNdb9nlQIeKM86TwF7fAxHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right, attempting this again now I've fixed my mail setup.

I've no idea how that other "butt-dial" mail got sent, I was not able to
sent mail _deliberately_ during that period but I guess somewhere in my
setup I still had a copy of the password somewhere!

On Fri Jul 31, 2026 at 8:28 PM BST, Yosry Ahmed wrote:
>> > [..]

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

I think Google might have a bunch of patches for this, afraid I know
very little about it though.

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

Oh. I never thought about that! I suppose the DMA is gonna happen via
some other address space, either it's via an IOMMU or it works directly
on physical RAM.  So the kernel's direct map is irrelevant... Is that
universal though? There must be cases where the CPU's mappings still
matter...  Umm... needs more research!

(Don't think this blocks anything in this series though, let me know if
you disagree...)

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

Oh I see what you mean, yeah just dropping the zap/restore makes sense,
then switch APIs as a followup.

