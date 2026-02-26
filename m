Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD02AFC5904
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A3F6B0089; Thu, 26 Feb 2026 02:10:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462A56B008A; Thu, 26 Feb 2026 02:10:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398D56B0093; Thu, 26 Feb 2026 02:10:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 248376B0089
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:10:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7F291CCD9
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:10:10 +0000 (UTC)
X-FDA: 84485733780.06.42247E0
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id D2817100009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:10:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5RbrvYi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089809; a=rsa-sha256;
	cv=none;
	b=0b1TlOTbjELdAijVn92L5NdhsqfZ/+yXE2WYuZzYs+ll6Pnep6XFu/dp49JABF/ksoJbrq
	uAOUwEHAVayu73UlzaWUz5clONG/y49wgXPvWkVdOalt1gwmnILHDtuKwrs8PVKZJUtLOo
	yCyyMjRrughnicoUSs1mGBQG/tp2viQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T5RbrvYi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blph2lJMOWUKWT5xAcasjhPc5lsVgPYBkYe9OiBnrFo=;
	b=6oZcQJCNBxJCiBPKcB5LbaoCbO+vHGXUXmZKprEaCWzzcdzSZUrQ9UZKp5xdzm+pJhSqkO
	An2yOIvGXMsjquezdYJ2vhoObxQaIvrqTP8eDJUgzi7ThmBf5vcdIqQB1rW/8H6ozei614
	ztGcnBi2OhO1MVB5pRraskjtg/Z5mgI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772089806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=blph2lJMOWUKWT5xAcasjhPc5lsVgPYBkYe9OiBnrFo=;
	b=T5RbrvYiPNIdRhfvw5JAikOpxhVjBz1xrmoTd92fOVEGmDQ2xWgabqHv755kCfxYLwuix/
	WCR/+EXQ1md0c18KGEyzr/nZ40BHt9egIeTftkrFB8u0OPfAugKD67i84YwbQH3rOQ0kZT
	G+E9PoYBAV8U3l3PoT11fjOSTDxsIIg=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	stable@kernel.org,
	vbabka@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/rmap: fix incorrect pte restoration for lazyfree folios
Date: Thu, 26 Feb 2026 15:09:40 +0800
Message-ID: <20260226070940.96226-1-lance.yang@linux.dev>
In-Reply-To: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
References: <36e676b4-dc6f-45f7-b885-8685227ac6a8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cht1bremdkdp7az5wg6xf5qxnjesnihq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D2817100009
X-HE-Tag: 1772089808-49892
X-HE-Meta: U2FsdGVkX18VNxZwbRyDF4YSOuvrLsCwwa4yYRGh8yt5hvDSxSrfIPT+8YMCwN3cb8ser4wsT4qaP9nVcmQW/kvd6cbUtycC4MPyMwq23Utc271dVAYMIusMCo1KXJFEgRgZ45aW11NXGfzzxnWewXlr0Xo741cMP59N6Y7iFhkHP6iW360OSiRvlm07IXuV67U2COyTSBz8+JcAvjVaa0bxHWGLFa8v7q8b4Gvmw5PhGr75MrVozVczOYpuShDO9nHgwjwooeFecgMd9yJcQ9gGgh9w4tVwmGefu3pgjXTnBmndqWr+EUV7cUpM1u1nISGZKkS1Nw/NTFPxalMwxBISMdiag4SymSctkBBiew8z9y1PY5M+mfsEA5zvPvOV0+RRZ+BelmuomiAFFfS4nDniJBArjMiw8ajcN/yicLPkQruJJxsAJuMuNkUAD6qi4GyKTOCUhpQ30EKAQg7jtN4jVKfOAw9qkfRz6EPD/+IBAGqObNV0K7ocr3Kvt/8vXOSiwKekHciMOwjhxeFBBENBlQOSnchAkAvyEUAZShSH84cNowKTNoCoBJVYg3CBoGHxI2z6xVsTpnNmZ6tkfZHImPdzMoY81i/8x27h2chAnpudW9V78MVcbmvhNwqljpkjZAPrtx3FmMGeR6SVh6O2/23G5uJyBCp7Og02MN2cgwEjQuCSufp+epzRZaJozJES8GPJq8M6C7CmnC8YQ/H8Ag2Ebr17d/ZQvkBbNmIkK1r+F0K0P1Srf0EJSaWZ1Z/eII72mv9mosjknd+e0/ikuDqPLZx1zD/bG10fknbpHI3n76ybPDtqLSPCL8r4ju6dZ17UpvkZBKRjWyl9ZOPjzEV8tExxywdO29fmtBLdfdxRR214PsoxTq5bfQXJpuHNXsRtQrM1MAmmOG7arDcqtDxSTwTlCiVzQcn9jUy25vSdG0pI0B7WPUcnMwJ83t/JAUfbAprvfafchas
 b+lBpsfB
 g20vjswOVCjRULYVFLGVExul8TvDLroqIdRIkgODdk8EernzIGfj1BJ9L25a4UlR4XEhh0QnFmNmTnzlCS+dLFekxxzjzIqkNHj/RG6Zj7ePmBUq6d8zMl9/U5Q8GHqQmVkxuKsIZscZt3XZwqZAYcOI+Edp0IW3IebqKY3YKSeju9fJ3QZdviGpad4NBDb9UJroHwDldHve28DkiiaigGErPX4Xw8C8U9F4ny95gqm+9VpRkrKOmvhgYjQO3PQvg/m84
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Feb 24, 2026 at 05:01:50PM +0100, David Hildenbrand (Arm) wrote:
>On 2/24/26 12:43, Lorenzo Stoakes wrote:
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
>Dev volunteered to un-messify some of the stuff here. In particular, to
>extend batching to all cases, not just some hand-selected ones.
>
>Support for file folios is on the way.
>
>> 
>> But is the proposed 'just assume wrprotect' sensible? David?
>
>In general, I think so. If PTEs were writable, they certainly have
>PAE set. The write-fault handler can fully recover from that (as PAE is
>set). If it's ever a performance problem (doubt), we can revisit.
>
>I'm wondering whether we should just perform the wrprotect earlier:
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index 0f00570d1b9e..19b875ee3fad 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -2150,6 +2150,16 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> 
>                        /* Nuke the page table entry. */
>                        pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
>+
>+                       /*
>+                        * Our batch might include writable and read-only
>+                        * PTEs. When we have to restore the mapping, just
>+                        * assume read-only to not accidentally upgrade
>+                        * write permissions for PTEs that must not be
>+                        * writable.
>+                        */
>+                       pteval = pte_wrprotect(pteval);
>+
>                        /*
>                         * We clear the PTE but do not flush so potentially
>                         * a remote CPU could still be writing to the folio
>
>
>Given that nobody asks for writability (pte_write()) later.
>
>Or does someone care?
>
>Staring at set_tlb_ubc_flush_pending()->pte_accessible() I am
>not 100% sure. Could pte_wrprotect() turn a PTE inaccessible on some
>architecture (write-only)? I don't think so.
>
>
>We have the following options:
>
>1) pte_wrprotect(): fake that all was read-only.
>
>Either we do it like Dev suggests, or we do it as above early.
>
>The downside is that any code that might later want to know "was
>this possibly writable" would get that information. Well, it wouldn't
>get that information reliably *today* already (and that sounds a bit shaky).

Makes sense to me :)

>2) Tell batching logic to honor pte_write()
>
>Sounds suboptimal for some cases that really don't care in the future.
>
>3) Tell batching logic to tell us if any pte was writable: FPB_MERGE_WRITE
>
>... then we know for sure whether any PTE was writable and we could
>
>(a) Pass it as we did before around to all checks, like pte_accessible().
>
>(b) Have an explicit restore PTE where we play save.
>
>
>I raised to Dev in private that softdirty handling is also shaky, as we
>batch over that. Meaning that we could lose or gain softdirty PTE bits in
>a batch.

I guess we won't lose soft_dirty bits - only gain them (false positive):

1) get_and_clear_ptes() merges dirty bits from all PTEs via pte_mkdirty()
2) pte_mkdirty() atomically sets both _PAGE_DIRTY and _PAGE_SOFT_DIRTY on
all architectures that support soft_dirty (x86, s390, powerpc, riscv)
3) set_ptes() uses pte_advance_pfn() which keeps all flags intact

So if any PTE in the batch was dirty, all PTEs become soft_dirty after
restore.

>For lazyfree and file folios it doesn't really matter I guess. But it will
>matter once we unlock it for all anon folios.
>
>
>1) sounds simplest, 3) sounds cleanest long-term.
>

