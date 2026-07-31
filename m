Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56592C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 12:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0716B0088; Fri, 31 Jul 2026 08:16:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0BC6B008A; Fri, 31 Jul 2026 08:16:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290F16B008C; Fri, 31 Jul 2026 08:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADBF46B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 08:16:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4732CA1666
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:16:26 +0000 (UTC)
X-FDA: 85048969572.22.1A66237
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id E78E3180007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 12:16:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bv10xC7U;
	spf=pass (imf06.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785500184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjaQBjIOi/mGsF8R2DednvLl/tyj05TlJUvS8Gm7aK0=;
	b=2h+CYDHnZV8mhkDhgD2pCgiA/dyjAnbqdXiJkm2RKOW2DUntAiCXHeO4MQEM5QuM0iT2O6
	RYwp2N+NXocAVGgMhkeXRDaanBA3vbcb9qQswzmSfpZRS8pwvCQq0tAvIr90lOjkMVEfI9
	cUQ6pTa85bsasRLfI8OwYe4UvLw46wY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785500184;
	b=CRfQcJAaz3jwW7Wdw5Xjz2iXI74GZriv9Amd8R1k1rj2Bt+b6WYCSbWk9KD/HyBuFLapuF
	oJOJHmYEm/V25uPQ5SspWrnSYvHtYEijdHMIPfpqv1NUOoS8rDXuPTh9X1MhpBHRbeZ0Ft
	O99sNOFxqWLCFHRVonMdaAGxzewCAC4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bv10xC7U;
	spf=pass (imf06.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785500177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FjaQBjIOi/mGsF8R2DednvLl/tyj05TlJUvS8Gm7aK0=;
	b=Bv10xC7URkuETp9aAWu5jihNIcQ7T/d9IbtsoMCi+ObFLEZmP4N4bejTP4gPY5OG7MwG4y
	m2yIFfiZZ4XsxwA0Cgbs8mPZ2FtoAePEdymQG4Rj9iKNBH4d6X58UmfUYJEDThJhRlj/oS
	mdaCd76CzQV+PGaIdVcKtijEyfWZtXQ=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jul 2026 12:15:50 +0000
Message-Id: <DKCQZ9JTKRIO.1K61106YF38GW@linux.dev>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>, "Nikita Kalyazin"
 <nikita.kalyazin@linux.dev>
Subject: Re: [PATCH v3 03/26] mm: introduce AS_NO_DIRECT_MAP
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-3-6f5729aa9832@google.com>
 <amu5v-e39GKpgFG4@google.com>
In-Reply-To: <amu5v-e39GKpgFG4@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E78E3180007
X-Stat-Signature: w6tue8hfcwnpxk59ehg4ractj4ynhhdi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785500182-185997
X-HE-Meta: U2FsdGVkX1/22M1fCEc2hmGMrDGTSTZSqea098vBXRyq9hxSP8J6auw2PCTQ2JEmLCk6f2zdhG26vYMoZUw2MWsiLQmW5PAIZo7DafLZgNh9BWEt3pKUq9sB3AH45QWb/vuoo+AlricK03Ia/qREE2jaPID6/JuL+yIHDYzW+ffTzk0XwS82MtWx9ggvVTjz/BH2Ktt/PpIPpjdrZOIwGrKCgIpkPAqNbEBIo8OZ+AymyglIVXanHPt4RMeaAE2KN6x+3OZitfh3KXpcDLekanq14ZJSYSwQPkD+afyeA8x0JinvnmN9YuMuIO94WHjgKBWc1bN/OiXYN5e5bxmJfnc2p7RiZ7dSfwdH32R9lu4xNU0wX4OuGwwfI03vTCiTCKGj7YknttLAOnqxPJFnrkNi2jLkFnTuN46lg/4arEm3q9xDZ8Q63fNIxaj78/6chkxQHgezllieTaA7C2E9+/DDlDuI+P/UJh0ibQOtze15pmZnji4YqKnju+HQkt8u8cF+6ioWfTbBhva8cthz4IGBd7bGaTC9LWqEa54lEhUOPACGMt4284eOCqZbvuWS5S+67fbUB3eQZ5UmaGHD8kI2BbfP4rNFgh22QLN+NAGdM0+P47Yy6MA1TxtqyMWMt6oSebPlAc9w5AIF8IjlhlZsDMKMcL96oPJrfQFP56M+AbDQ5Vf4yUNJlDFIXvXym3vkyeVGa4X2+Puwkv+Tn8sEktc9XGhcyBaqRhkiPcAsY/vHzjulBAHEywef+3lrbApl7V1ainxCYrJh6IsUZOTFcDKdJjAAMTPphKDSfksWfPaxehWhZ09ipqwbBjxjp2kLENHzrDpEsRq8tRkCEQQe5dsrdOor02k/rj6KMjXzmrapburnwk7HUGSDn8d3VYe1gq9BFqhgUKgduS1pMHmAAB2Q8YrenmPfH5oWkcw/wDZU59EV3mtPJUqbJMMDQP/w80m9pBXI6O5Q+cJ
 49waogCH
 FrcSmO8OFafTFlIIm6dFQAMXyEr3MhgZDmHbJ95QgsZcIPQv8oPjO4cRJLw1jROdmMM1AH3SVLkFgK+TrHyRQzvW+PA0FfY+9Q5zSGLmwNKPlOpYLYpNgjtGBBYNYf0khHjI5dWvM4qAN8ACAw+eZ5Bp3Z3+wO0tUs1Z0Af62Ak4mYiu4SmsHYcAklWWFzTIps1p1n+4YPCgr3d5LnjLYKHY5N2DXZ+0rtWnJVp6cj4/xmd942kKjxZJ0ozTOKbSm+uZ+lm1cUVTtqFGTjM/mTmC1HF1vN6x52mmAhAGSsxU+H/gVLHT9ahfqA1y7lbUzCzcKRUwJ67iIvwWS9GJETKhJdDMDJrl08isa/FePD66wFZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 30, 2026 at 9:06 PM UTC, Yosry Ahmed wrote:
> On Sun, Jul 26, 2026 at 10:22:36PM +0000, Brendan Jackman wrote:
>> From: Patrick Roy <patrick.roy@linux.dev>
>>=20
>> Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are
>> set to not present. Currently, mappings that match this description are
>> secretmem mappings (memfd_secret()). Later, some guest_memfd
>> configurations will also fall into this category.
>>=20
>> Reject this new type of mappings in all locations that currently reject
>> secretmem mappings, on the assumption that if secretmem mappings are
>> rejected somewhere, it is precisely because of an inability to deal with
>> folios without direct map entries, and then make memfd_secret() use
>> AS_NO_DIRECT_MAP on its address_space to drop its special
>> vma_is_secretmem()/secretmem_mapping() checks.
>
> I don't think this is necessarily true. See below.
>
>> Use a new flag instead of overloading AS_INACCESSIBLE (which is already
>> set by guest_memfd) because not all guest_memfd mappings will end up
>> being direct map removed (e.g. in pKVM setups, parts of guest_memfd that
>> can be mapped to userspace should also be GUP-able, and generally not
>> have restrictions on who can access it).
>>=20
>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>> Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>
>> [Moved zapping to page cache; removed review tags]
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> [..]
>> diff --git a/lib/buildid.c b/lib/buildid.c
>> index c4b7376406215..ba79bf28f7e69 100644
>> --- a/lib/buildid.c
>> +++ b/lib/buildid.c
>> @@ -47,6 +47,10 @@ static int freader_get_folio(struct freader *r, loff_=
t file_off)
>> =20
>>  	freader_put_folio(r);
>> =20
>> +	/* reject folios without direct map entries (e.g. from memfd_secret() =
or guest_memfd()) */
>> +	if (mapping_no_direct_map(r->file->f_mapping))
>> +		return -EFAULT;
>> +
>
> The plan is to eventually have ~all user have no direct map in ASI page
> tables, right? I assume this would then be problematic as paths like
> this one will want to create an ephemeral mapping to access memory
> rather than just fail.
>
> Is the plan to have a separate check for ASI mappings that are present
> in the unrestricted/non-sensitive address space?

Yeah ASI-protected mappings would not have AS_NO_DIRECT_MAP set. That
means "no direct map at all, you crash if you touch it". There might be
a separate flag like AS_SENSITIVE to reflect that, or more likely it's
more like my previous postings where it was just implicit that the page
cache was protected by ASI.

But we shouldn't need many such carveouts for ASI. I expect all
ASI-specific code that's related to the page cache will be purely
for optimisation, while this -EFAULT is a functional requirement.

>>  	/* only use page cache lookup - fail if not already cached */
>>  	r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SH=
IFT);
>> =20
>> @@ -87,8 +91,8 @@ const void *freader_fetch(struct freader *r, loff_t fi=
le_off, size_t sz)
>>  		return r->data + file_off;
>>  	}
>> =20
>> -	/* reject secretmem folios created with memfd_secret() */
>> -	if (secretmem_mapping(r->file->f_mapping)) {
>> +	/* reject folios without direct map entries (e.g. from memfd_secret() =
or guest_memfd()) */
>> +	if (mapping_no_direct_map(r->file->f_mapping)) {
>>  		r->err =3D -EFAULT;
>>  		return NULL;
>>  	}
> [..]
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -11,7 +11,6 @@
>>  #include <linux/rmap.h>
>>  #include <linux/swap.h>
>>  #include <linux/swapops.h>
>> -#include <linux/secretmem.h>
>> =20
>>  #include <linux/sched/signal.h>
>>  #include <linux/rwsem.h>
>> @@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *=
vma, unsigned long gup_flags)
>>  	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))
>>  		return -EOPNOTSUPP;
>> =20
>> -	if (vma_is_secretmem(vma))
>> +	if (vma_has_no_direct_map(vma))
>
> Same here, and for GUP in general. For example, KVM uses kvm_vcpu_map()
> to map guest memory and access it (e.g. when running nested
> virtualization), which uses GUP under the hood AFAICT. So KVM will want
> GUP to succeed, and probably create an ephemeral mapping as well.
>
> Maybe eventually we will want a GUP flag to handle creating an ephemeral
> mapping, as I imagine multiple GUP users will run into the same issue?
>
> Not sure if this is an ASI-specific issue, or if we also have use cases
> where we need GUP to work guest_memfd pages (with ephemeral mappings).

Similar to above, this shouldn't affect ASI at all.

>>  		return -EFAULT;
>> =20
>>  	if (write) {
>> @@ -2731,7 +2730,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>   * This call assumes the caller has pinned the folio, that the lowest p=
age table
>>   * level still points to this folio, and that interrupts have been disa=
bled.
>>   *
>> - * GUP-fast must reject all secretmem folios.
>> + * GUP-fast must reject all folios without direct map entries (such as =
secretmem).
>>   *
>>   * Writing to pinned file-backed dirty tracked folios is inherently pro=
blematic
>>   * (see comment describing the writable_file_mapping_allowed() function=
). We
>> @@ -2769,7 +2768,7 @@ static bool gup_fast_folio_allowed(struct folio *f=
olio, unsigned int flags)
>>  	if (WARN_ON_ONCE(folio_test_slab(folio)))
>>  		return false;
>> =20
>> -	/* hugetlb neither requires dirty-tracking nor can be secretmem. */
>> +	/* hugetlb neither requires dirty-tracking nor can be without direct m=
ap. */
>>  	if (folio_test_hugetlb(folio))
>>  		return true;
>> =20
>> @@ -2812,7 +2811,7 @@ static bool gup_fast_folio_allowed(struct folio *f=
olio, unsigned int flags)
>>  	 * At this point, we know the mapping is non-null and points to an
>>  	 * address_space object.
>>  	 */
>> -	if (check_secretmem && secretmem_mapping(mapping))
>> +	if (mapping_no_direct_map(mapping))
>>  		return false;
>>  	/* The only remaining allowed file system is shmem. */
>>  	return !reject_file_backed || shmem_mapping(mapping);
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index efa6716e4dfbd..045b6779440b1 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, str=
uct vm_area_struct *vma,
>>  	int ret =3D 0;
>> =20
>>  	if (vma_flags_same_pair(&old_vma_flags, new_vma_flags) ||
>> -	    vma_is_secretmem(vma) || !vma_supports_mlock(vma)) {
>> +	    vma_has_no_direct_map(vma) || !vma_supports_mlock(vma)) {
>
> I don't think this one is correct. From commit 1507f51255c9 ("mm:
> introduce memfd_secret system call to create "secret" memory areas"):
>
>   Since the secretmem mappings are locked in memory they cannot exceed
>   RLIMIT_MEMLOCK.  Since these mappings are already locked independently
>   from mlock(), an attempt to mlock()/munlock() secretmem range would
>   fail and mlockall()/munlockall() will ignore secretmem mappings.
>
> Seems like secretmem pages are just mlock()'d by default, hence the
> check here. Maybe this also works for guest_memfd, but I don't think
> it's a generalization that any pages without a direct mapping should
> receive the same treatment here.

Ack, yeah this sounds correct to me.

I guess you could argue something like "the reason secretmem is
implicitly mlocked is that it can't be reclaimed, because there's no
direct map". But that doesn't generalise IMO, you could imagine letting
the user say "remove this memory from the direct map, but I trust my
swap system, you can swap it" and then use the mermap to implement
reclaim.

> I am aware that perhaps the answer for most these cases is that it works
> for guest_memfd as well as secretmem, but since the main goal of the
> series is setting up ASI,=20

[Aside]
	Well, the main reason for Google to pay me for it is as a
	stepping stone for ASI, but I do actually think
	GUEST_MEMFD_FLAG_NO_DIRECT_MAP[0] is valuable and prefer to
	think of that as the "main goal" of this patchset. (I didn't
	include it here since Sean asked[1] for the KVM bits to be
	separate, but it's basically just a repeat of the secretmem.c
	changes).

	[0] https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com=
/
	[1] https://lore.kernel.org/all/akw1lZDEv8_Ub1zQ@google.com/

> ideally we don't want checks that we know
> will become wrong when ASI is introduced. If the idea is that
> mapping_no_direct_map() and vma_has_no_direct_map() will not be used for
> ASI sensitive mappings,=20

(I said this above but just to be clear: that is not the idea).

> we should document this somewhere, or have
> better localized checks (if at all possible) so that we can side-step
> the whole mixup when ASI mappings come along.

BUT yes I still totally agree that we should not unnecessarily overload
vma_has_no_direct_map() here.

>>  		/*
>>  		 * Don't set VMA_LOCKED_BIT or VMA_LOCKONFAULT_BIT and don't
>>  		 * count.  For secretmem, don't allow the memory to be unlocked.
>> diff --git a/mm/secretmem.c b/mm/secretmem.c
>> index 4a4934769f8ba..c043c53687d95 100644
>> --- a/mm/secretmem.c
>> +++ b/mm/secretmem.c
>> @@ -52,49 +52,20 @@ static vm_fault_t secretmem_fault(struct vm_fault *v=
mf)
>>  	struct address_space *mapping =3D vmf->vma->vm_file->f_mapping;
>>  	struct inode *inode =3D file_inode(vmf->vma->vm_file);
>>  	pgoff_t offset =3D vmf->pgoff;
>> -	gfp_t gfp =3D vmf->gfp_mask;
>>  	struct folio *folio;
>>  	vm_fault_t ret;
>> -	int err;
>> =20
>>  	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))
>>  		return vmf_error(-EINVAL);
>> =20
>>  	filemap_invalidate_lock_shared(mapping);
>> =20
>> -retry:
>> -	folio =3D filemap_lock_folio(mapping, offset);
>> +	folio =3D filemap_grab_folio(mapping, offset);
>>  	if (IS_ERR(folio)) {
>> -		folio =3D folio_alloc(gfp | __GFP_ZERO, 0);
>> -		if (!folio) {
>> -			ret =3D VM_FAULT_OOM;
>> -			goto out;
>> -		}
>> -
>> -		err =3D folio_zap_direct_map(folio);
>> -		if (err) {
>> -			folio_put(folio);
>> -			ret =3D vmf_error(err);
>> -			goto out;
>> -		}
>> -
>> -		__folio_mark_uptodate(folio);
>> -		err =3D filemap_add_folio(mapping, folio, offset, gfp);
>> -		if (unlikely(err)) {
>> -			/*
>> -			 * If a split of large page was required, it
>> -			 * already happened when we marked the page invalid
>> -			 * which guarantees that this call won't fail
>> -			 */
>> -			folio_restore_direct_map(folio);
>> -			folio_put(folio);
>> -			if (err =3D=3D -EEXIST)
>> -				goto retry;
>> -
>> -			ret =3D vmf_error(err);
>> -			goto out;
>> -		}
>> +		ret =3D vmf_error(PTR_ERR(folio));
>> +		goto out;
>>  	}
>> +	folio_mark_uptodate(folio);
>
> This chunk seems like pure refactoring that should be done separately?

This is the adoption of AS_NO_DIRECT_MAP, i.e. the removal of the
explicit folio_zap_direct_map() call. We could certainly separate out
"create AS_NO_DIRECT_MAP" from "adopt it in secretmem" but the previous
version of this patchset was on v12 and it hadn't split them so I assume
nobody was calling for this split.

