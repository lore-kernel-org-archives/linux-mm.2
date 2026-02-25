Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFCBF5545B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 05:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E576B0005; Wed, 25 Feb 2026 00:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656B16B0088; Wed, 25 Feb 2026 00:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558D66B008A; Wed, 25 Feb 2026 00:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4E56B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:11:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EAC1C1D97
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:11:14 +0000 (UTC)
X-FDA: 84481805268.25.78E708E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6384C40006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 05:11:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771996272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YNAer0kvb9uUECwgAxzUJDnQWLrx13vZqO/mpArMO6Q=;
	b=kVSKFzbbHgJsbjMei7e+BvBcMl0yg8tFypBOmyvh7dkyLEdAYgNs6lcmZ17dKR9fnOt2lk
	zYavZczl3N+UlWHuD1lXkj/jl/qW7xV+LEfaDANWUP4gwsIvO86OhnS1JqvQAeQXbDIk8S
	2aDXlxvbkaBZg5hfTrWh4yyNkA6Z/WU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771996272; a=rsa-sha256;
	cv=none;
	b=hNgPf6F4JXPFiqXRdWZXKnspVgJnw592G68X0IBDkKieC0GKVdzGX7JghAleZcbzczwLZY
	3ZBAIWMfwMN7z03u1NZqJFwsS/9U38HeMM7R1ysNV//Lv/F67BDjQz2po1k8y70KOr2Srm
	LTk9iPscAVkXRwMbmPIuJuLxn7LN9O0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEDA4165C;
	Tue, 24 Feb 2026 21:11:04 -0800 (PST)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B18643F7BD;
	Tue, 24 Feb 2026 21:11:07 -0800 (PST)
Message-ID: <40c4917a-cf50-43f6-8ef0-de5a2c7a638f@arm.com>
Date: Wed, 25 Feb 2026 10:41:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@kernel.org, harry.yoo@oracle.com, jannh@google.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable <stable@kernel.org>
References: <20260224110934.881360-1-dev.jain@arm.com>
 <763ffcc5-8640-4b48-8ace-051ff0ccbdaf@lucifer.local>
 <61161337-0d0b-4597-aad6-b5a1aa1ad41f@lucifer.local>
 <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: t81rm75eistzuaja1u6yntqhdsn4qecq
X-Rspam-User: 
X-Rspamd-Queue-Id: 6384C40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1771996272-810598
X-HE-Meta: U2FsdGVkX1+SJEpDF2GS0kpNHsCNrF/SE30oKmwr3F28t5zYxYkcoh1rVAZD1phsXoD/fLlZeV3nrdol9aSGsU6W9vDPh0Q0LIfE2F/G8DXI3fR/38Jv+rqtNTCObU7yEhCJSbJ8d1SlIvKLz1FcsSeLBOZII4LUHnX+Z/jAKsrkyuF2/rozXKdP2mgFEOw+35WvmgeWxbmMk4rgnUlcoLYvgu+hXqpti1nJu4uE98QJusM0UBQbPaLa/6rv+CdUF7IhjFbokSfxJ0llY5CAYaZ4+UQott/I0Yx3ZzyLqsX86A6N+MW95wi/rqZXCy8V+fm0KkUpaJ+Z8dYvXUowryIFyHLspWsbzfbxi32JJYOyHUQavNqryfm5f8GIvQH6O2GZoshnzU4YY10yvG/E4zfdP9n1q3UzcuM+vIy5+/Gjs4/0JN718sq6po6qn8MjhpxRh/dn44u4gdVa2X6ZibeparMH9ckVkyxWLJZfkeFGexKjsvAAvHdflGy/pmTuu/LZcGaMEvJPly9YJjxu437xMd7LdnhZ7gl4CgX0E9INB0GvI7W9dh4181DNNpZHzmR5UcL/nahRly32I9Pv3PLj2s7e5PcCQrQJReX1xYqz+Y6x9WLapeFCGL1ozkqEhbRt0vf8jIsn3kEepMzcF4fT4GVgPLJDoRWfH69X86z68qBpnRQ5cxOCl43tkyGgdHgg1bg0/weR3NEy4SHh3ZNFIGatQB4i4VBvzHS/TYKFx/UL+2U6JePk8EHh4et7SiWXjxGmirazSQqIr4QLO2HDzUluU/nhWPzJtNvp8Xp0VF2sc6aO93JWNQWsXdIc/7DVBAna9w/1KWt+ED+i/tHdBM56laXZqVfrJR0lw++2Mgn+NHbbHW50L+rpE/vSKy62y7LWaqGVhKQZiHmOk5vrJcyiTCD4ASxe8TnHbjQsQ27hCq28CnhmZ13Hp/GWJmz1UxwyphsXD/Tv1Om
 /BMPPRwx
 Sm3MU++mryWaF8C8cyfYUdquVAu1NLC0fR50kYeyYCFoiFoc8AQjKrbJ0kfZbMFpTQ4JoDXAN0FTbu+1D+HZoa11SA3JS0WjPr96HKh4jb3+iDsmz6fGQk/8LIQ5LYhBXodfRm2h7GflIGpkVM9/qZJNHaxyWuWmrq+h3GkfmEPIzBZlRAxrS4DvjEJckEBr/dWOD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/02/26 9:31 pm, David Hildenbrand (Arm) wrote:
> On 2/24/26 12:43, Lorenzo Stoakes wrote:
>> On Tue, Feb 24, 2026 at 11:31:24AM +0000, Lorenzo Stoakes wrote:
>>> Thanks Dev.
>>>
>>> Andrew - why was commit 354dffd29575 ("mm: support batched unmap for lazyfree
>>> large folios during reclamation") merged?
>>>
>>> It had enormous amounts of review commentary at
>>> https://lore.kernel.org/all/146b4cb1-aa1e-4519-9e03-f98cfb1135d2@redhat.com/ and
>>> no tags, this should be a signal to wait for a respin _at least_, and really if
>>> late in cycle suggests it should wait a cycle.
>>>
>>> I've said going forward I'm going to check THP series for tags and if not
>>> present NAK if they hit mm-stable, I guess I'll extend that to rmap also.
>>
>> Sorry I misread the original mail rushing through this is old... so this is less
>> pressing than I thought (for some reason I thought it was merged last cycle...!)
>> but it's a good example of how stuff can go unnoticed for a while.
>>
>> In that case maybe a revert is a bit much and we just want the simplest possible
>> fix for backporting.
> 
> Dev volunteered to un-messify some of the stuff here. In particular, to
> extend batching to all cases, not just some hand-selected ones.
> 
> Support for file folios is on the way.

Typo - anonymous non-lazyfree folios : )

> 
>>
>> But is the proposed 'just assume wrprotect' sensible? David?
> 
> In general, I think so. If PTEs were writable, they certainly have
> PAE set. The write-fault handler can fully recover from that (as PAE is
> set). If it's ever a performance problem (doubt), we can revisit.
> 
> I'm wondering whether we should just perform the wrprotect earlier:
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 0f00570d1b9e..19b875ee3fad 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  
>                         /* Nuke the page table entry. */
>                         pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
> +
> +                       /*
> +                        * Our batch might include writable and read-only
> +                        * PTEs. When we have to restore the mapping, just
> +                        * assume read-only to not accidentally upgrade
> +                        * write permissions for PTEs that must not be
> +                        * writable.
> +                        */
> +                       pteval = pte_wrprotect(pteval);
> +
>                         /*
>                          * We clear the PTE but do not flush so potentially
>                          * a remote CPU could still be writing to the folio
> 
> 
> Given that nobody asks for writability (pte_write()) later.
> 
> Or does someone care?
> 
> Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
> not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
> architecture (write-only)? I don't think so.
> 
> 
> We have the following options:
> 
> 1) pte_wrprotect(): fake that all was read-only.
> 
> Either we do it like Dev suggests, or we do it as above early.
> 
> The downside is that any code that might later want to know "was
> this possibly writable" would get that information. Well, it wouldn't
> get that information reliably *today* already (and that sounds a bit shaky).

I would vote for this, since if we were to follow the current patch,
the extension to anon folios will make it worse (pte_wrprotect at 5 places
- the 3 additional places being in the if conditions consisting of
folio_dup_swap, arch_unmap_one, folio_try_share_anon_rmap_pte)
The downside being that if we fail in this rmap path, the ptes are all
write-protected. But then the page is already there - the fault is going
to be processed fast.

> 
> 2) Tell batching logic to honor pte_write()
> 
> Sounds suboptimal for some cases that really don't care in the future.
> 
> 3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
> 
> ... then we know for sure whether any PTE was writable and we could

Well, we don't need this? The problem here is that we are making a decision
on the basis of the writability of the *first* pte of the batch - so if
the first pte is writable, only then we have the problem we have been
talking about.

We could have had a FPB_MERGE_WRPROTECT (which I know, is totally
incompatible with FPB_MERGE_WRITE) - that would tell whether at least one
pte in the patch was non-writable, in which case we will be able to avoid
the restoration of the entire batch to writeprotected if all the ptes
were writable (which I am assuming is the common case). But of course this
is not possible to do with the current shape of folio_pte_batch_flags. We
will have to revert the FPB_MERGE_* stuff to just collect the "at least one
is writable, at least one is dirty, at least one is young, at least one is
non-writable" etc information from the function and let the caller handle
it. That will kill all the work you did in simplifying that function :)


> 
> (a) Pass it as we did before around to all checks, like pte_accessible().
> 
> (b) Have an explicit restore PTE where we play save.
> 
> 
> I raised to Dev in private that softdirty handling is also shaky, as we
> batch over that. Meaning that we could lose or gain softdirty PTE bits in
> a batch.
> 
> For lazyfree and file folios it doesn't really matter I guess. But it will
> matter once we unlock it for all anon folios.
> 
> 
> 1) sounds simplest, 3) sounds cleanest long-term.
> 


