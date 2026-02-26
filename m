Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B7DFC591F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:21:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0B56B0088; Thu, 26 Feb 2026 05:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B2E6B0089; Thu, 26 Feb 2026 05:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E706B008A; Thu, 26 Feb 2026 05:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7433B6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:21:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B4EDBB945
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:21:52 +0000 (UTC)
X-FDA: 84486216864.19.519D8CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 647C51C0010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:21:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM7Lgr3+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuCerTyWryQm3CAau67ZoP6XzLHwS6G9LXqFxBsISVI=;
	b=c51DzzVETjs2qNaUY40jL6xNrO/SD1whWZPwfPnVquY/RCHO0QU0aAqzLlPHtgK+xSAT+v
	dpGQ7aKTfuM+Jsqka6JQMy7AtFw0GDX8AH+UkbyQpBqPaGuxfgu16GbrEfJdGSnbSp0UwS
	BEIK6Hd28UQl3qF1pl27e8cVmeNtSGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772101310; a=rsa-sha256;
	cv=none;
	b=Ozb1WluWpDOLftrLs+2sm4NOVw7GTWQ4YGAaOCQeoDemkWMcrDToZtNpxe734SAuGOL65P
	lGbLdxwgbbPqpYHYzSyCvg0ugNPqaB2qwblCJv2SEC2jO0Lwenr76Q2AlfYWb8L0WnMor6
	d2MN4zDd+oJyLuMFGZjEGNTJKJcvqpo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MM7Lgr3+;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B821B60054;
	Thu, 26 Feb 2026 10:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFEDC19422;
	Thu, 26 Feb 2026 10:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772101309;
	bh=ZGC9AzVF3KF23hoV1pwiHOcbwP0cmN0R05n3IYisA28=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MM7Lgr3+Rwv9YP+1L2h5YCPAA2k5LEFtfXhogSxmKny+/XtAgTicPqC4GcVjfRmSh
	 R2iauQxDOqlWgu7PpPQerciQ3T5ToEUNe227E0JoJhBvHGJy/LsgFG18l0QTrCrOf0
	 jVStZmjO3qZUjhQkrM05n2n/rFqVY+UVCJFZk0FdGkx7iSYE4RYTNHcYLOt3PzVY+n
	 GwmVbAot6QyX44txQgVkAMEZj7+aQJ3WlWh/qcvmcVjCVn3ujfkTc++De+FvH/X3Ib
	 KybxS0wW/gUoVQbBzr+W+S5JKThYUGiyF7takzeRQh0GUIOIOizP3em0ZprRsiF3s8
	 GY8idn4OKqWtg==
Message-ID: <bc4ad689-6dd5-4637-92dd-d16ac8ddd460@kernel.org>
Date: Thu, 26 Feb 2026 11:21:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Dev Jain <dev.jain@arm.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable <stable@kernel.org>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
 <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
 <40c4917a-cf50-43f6-8ef0-de5a2c7a638f@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <40c4917a-cf50-43f6-8ef0-de5a2c7a638f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 647C51C0010
X-Stat-Signature: 8y9mbbzyzrcmgu839yxtg1z5ie763ude
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772101310-875893
X-HE-Meta: U2FsdGVkX1/sXF21dj/MGoVUp++XQqNS/0j4gaCSk0kPePM8rqJD2kITgFaVrsQFo/94jV661hfPnomwc5w3QxavAje9gQEaR1wHxhZRQJADL/b3dg/LTbCPii8mE02bMv/wpToDnOQfK+l40seXD8YqjrCDJbzX3PpUXl+0lpFDudwnCxzq4EezFIcaIY3wBraYZOKevmFkP5cOViwBX7shaBn7Ju5NJYOmBM4jHsXCCuoYSCdlKdCir/AoFoy/IyAdLDD397GguFrMxTqPPwvKZQ02MvEBZ/bxMxsT38M+hB0lBVWeUE6itKnXVyulzOkkTHiFqgiAnnXORkKTY9qwOSmLWO9rSLlxDBL8ccT5sp7Nt36+kpO/24xvDmOqyn83F3cqVkB2IFMJPyNFgu7ionXWRNJCpTOJNy2/hXM6/v9jYrJXM2ffFBlnadIIms4Y/L02hw5BceamnHMTM9GHTTPeNi4s33IYfPde5mxPydG8rr45OxCeUnKBV3kNCld+luy3+GHZkSGA/9MfxW2i1LhFga9qVKJjsoC+RZPCJQRxSLVNGnjJYulaV+Jk3pZc4elhXuQnaR3qsKT5Wmy20MW0rvqId4Pfv/7vJ5JGfr3nDj26/JGmkkVCMApW3Pj2tqNz/38sVrmSE/bdWug4+8qMzkd29yrnQNWXwDM5ZmcyTsiXaf+cMsEh7lTq+WjS4sgVMy2bugjAjrAxvyU6ZasjTuguBOkeoMPQ/05UgcH14aNhTWOUka1TyaIf5QqixN3GX3UeGovNntPBFMOnVM9dCuCjWtSw88un29+CCe1UIJ8H3qCQehlZIJ7IA9zCNn5Et3/T6KjEYF59oAfuHEI05bmfkrhe3KTOPe0JzkGiQFZUl/J2ybHuaUqNf4RSgLARoUWFfMeDwuF8sn+YZEY7bMwLO5POaIJpHyDTYyodcL83Smf9JN9Asu6RkPVTu8SUwDQsGU5Hhts
 aPr4Q9+x
 IH7JqBHcgGXtbMr6HnvMT5dq7BVZK8nyCXnWjH9JaVl8/wa4gMi8OmDjsIGYpgXc3qwtyMG+cWsrp3MIwmbyMH67pRDzCdWE/HSuHSvX5dCT2NCBH2Q3A0qo6/WLZdl9gx+lVFswASP4Ix6baxJT/KYzcrTIE41jCe2bC6q1UeiZYZdfP3ERYURKaFSYnycVbRUePO+1DGf00RittSbTM+p3MbVHaJTZYTajtlMk08hcs/RxOBlblHc7oEHKPXE5Rj376
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 06:11, Dev Jain wrote:
> 
> 
> On 24/02/26 9:31 pm, David Hildenbrand (Arm) wrote:
>> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>>>
>>> Sorry I misread the original mail rushing through this is old... so this is less
>>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>>> but it's a good example of how stuff can go unnoticed for a while.
>>>
>>> In that case maybe a revert is a bit much and we just want the simplest possible
>>> fix for backporting.
>>
>> Dev volunteered to un-messify some of the stuff here. In particular, to
>> extend batching to all cases, not just some hand-selected ones.
>>
>> Support for file folios is on the way.
> 
> Typo - anonymous non-lazyfree folios : )

Heh, no, not what I meant. We do have file folio support on the way (see
the other patch set).

> 
>>
>>>
>>> But is the proposed 'just assume wrprotect' sensible? David?
>>
>> In general, I think so. If PTEs were writable, they certainly have
>> PAE set. The write-fault handler can fully recover from that (as PAE is
>> set). If it's ever a performance problem (doubt), we can revisit.
>>
>> I'm wondering whether we should just perform the wrprotect earlier:
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 0f00570d1b9e..19b875ee3fad 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  
>>                         /* Nuke the page table entry. */
>>                         pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>> +
>> +                       /*
>> +                        * Our batch might include writable and read-only
>> +                        * PTEs. When we have to restore the mapping, just
>> +                        * assume read-only to not accidentally upgrade
>> +                        * write permissions for PTEs that must not be
>> +                        * writable.
>> +                        */
>> +                       pteval = pte_wrprotect(pteval);
>> +
>>                         /*
>>                          * We clear the PTE but do not flush so potentially
>>                          * a remote CPU could still be writing to the folio
>>
>>
>> Given that nobody asks for writability (pte_write()) later.
>>
>> Or does someone care?
>>
>> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>> architecture (write-only)? I don't think so.
>>
>>
>> We have the following options:
>>
>> 1) pte_wrprotect(): fake that all was read-only.
>>
>> Either we do it like Dev suggests, or we do it as above early.
>>
>> The downside is that any code that might later want to know "was
>> this possibly writable" would get that information. Well, it wouldn't
>> get that information reliably *today* already (and that sounds a bit shaky).
> 
> I would vote for this, since if we were to follow the current patch,
> the extension to anon folios will make it worse (pte_wrprotect at 5 places
> - the 3 additional places being in the if conditions consisting of
> folio_dup_swap, arch_unmap_one, folio_try_share_anon_rmap_pte)
> The downside being that if we fail in this rmap path, the ptes are all
> write-protected. But then the page is already there - the fault is going
> to be processed fast.

Right, we should only have a single "revert pte", and not have to redo
that from multiple locations.

> 
>>
>> 2) Tell batching logic to honor pte_write()
>>
>> Sounds suboptimal for some cases that really don't care in the future.

As per discussion with Barry, we might just want to do that now as an
easy and obviously correct fix.

It's a shame we stop being able to use folio_pte_batch() and have to
create an inlined version.

>>
>> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
>>
>> ... then we know for sure whether any PTE was writable and we could
> 
> Well, we don't need this? The problem here is that we are making a decision
> on the basis of the writability of the *first* pte of the batch - so if
> the first pte is writable, only then we have the problem we have been
> talking about.

That's what I was referring above as "being shaky".

Some code has to be taught that "there is something writable here, so
assume it was accessible in a certain way", other code has to be taught
that "there is something read-only here, so make sure you don't
accidentally make something writable".

One way to handle it is to say that "the resulting pte is writable, so
assume it was accessible", to then say "but just assume it is read-only
as we are not sure whether everything is writable".

> 
> We could have had a FPB_MERGE_WRPROTECT (which I know, is totally
> incompatible with FPB_MERGE_WRITE) - that would tell whether at least one
> pte in the patch was non-writable, in which case we will be able to avoid
> the restoration of the entire batch to writeprotected if all the ptes
> were writable (which I am assuming is the common case). But of course this
> is not possible to do with the current shape of folio_pte_batch_flags. We
> will have to revert the FPB_MERGE_* stuff to just collect the "at least one
> is writable, at least one is dirty, at least one is young, at least one is
> non-writable" etc information from the function and let the caller handle
> it. That will kill all the work you did in simplifying that function :)
Yeah, let's not go down that path. :)

To fix what we currently have in the tree, probably we should really
just set FPB_RESPECT_WRITE|FPB_RESPECT_SOFT_DIRTY, saying that this is
"obviously correct", and revisit it once we expect more cases where
batching over these PTEs would provide more value.

For lazyfree, likely it doesn't make a difference.

-- 
Cheers,

David

