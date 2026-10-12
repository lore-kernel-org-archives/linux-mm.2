Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD33ACA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CFC6B008A; Mon, 12 Oct 2026 06:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DF76B008C; Mon, 12 Oct 2026 06:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4447D6B0092; Mon, 12 Oct 2026 06:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22E4A6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:33:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9553160B3B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:33:57 +0000 (UTC)
X-FDA: 85313613714.05.D2D595D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 10481C0009
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:33:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fEKg6uip;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791801236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNnBEk1ZblEqrRrnuFXhKbUtj1Kjb67w+8SQlGULyHY=;
	b=HGqCQfV+eGtfJbANyBR+/crvA4MmA/ZlDg8ltMwvNAKf8tagUVp5l6xNNO8WL8wFXVY+Dc
	We/GTmeCz5ugVNSruEYi+KtC8dRrbOoY1FAGjOxQFWSSsgSPHdxRzl2FRzk4Qp0c5PSnKg
	w4U8x4ncGPUp/pU2G5/nRiwWEP/GVIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791801236;
	b=OA4Whqxr9xpc5ihzamvOIj+CF+YQjWa8HPON4737HIQHveFBcZOH/XCBVtlFpz9aAeweVC
	EevqPjGP43YBYByivbPIh264UFLKHn88O2HcAF+QX6U4a1JbANKpqWwHE+9aAi//EYJKKX
	qtrtsQtNBYOfQNWaJ/50+WEgZovQK3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fEKg6uip;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63C1642DA3;
	Mon, 12 Oct 2026 10:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6801F0089B;
	Mon, 12 Oct 2026 10:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801234;
	bh=YNnBEk1ZblEqrRrnuFXhKbUtj1Kjb67w+8SQlGULyHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fEKg6uipIJDU9BC6xLEMgoLYR9QG7W0hFPrT8AQqy8X2IQaQv99e7Fq09HEvCH/7m
	 QeS0JYlgUSTRWU+B3s/P7udKfTuMZUdJC/3eZku2DYciVmbv5wXEzhgn1KnMpklBTJ
	 vn2c9N0de6SuluS/nhj/Q4f+YIWeQ06tzo6l90oRfJf72m4iWPmr+sVAy89lUnVgm3
	 kw3XKwdEGazJRTIyqblyFf3KzxNPxoYXt1dD+qWn5pClS0PO7kTIzPqLOg2Kbh0ZAg
	 aqW0ULSvcobAVRgeguqucH/6oNpiq6OgjyZdiV0qYhlDj4J9xTfN+KgA8HZ8IFXmPB
	 5DgvOhzM1Irmg==
Date: Mon, 12 Oct 2026 11:33:48 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: keep the hardware dirty bit in MADV_COLD's
 THP path
Message-ID: <asyy7Nwik5yMTNbo@gremlin>
References: <20261011132227.413217-1-samarth.colleges@gmail.com>
 <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42087cd7-473e-40a7-ae63-3c841c615c8f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10481C0009
X-Stat-Signature: by6gtek86w861ahyqiex8wcgtt3gqiig
X-HE-Tag: 1791801235-901168
X-HE-Meta: U2FsdGVkX1+8A7nS4deEyrNlhYTKc2w0oZAYVy8P22NAe3X+4m4P8ZgNAmxwNkeajPY2tlVfVET908FSSqJpQdp9tzMEoT2m+XqdQMHbjqlq1TxBu9tKiWCpzxxQUitBupIlN0s90tKtIEl+6DwwO2nwgpUiy/RHgtHU7aRqXtxhti9++f1MX338wrFL2GtmC/8uVEMmggWBPczAVJqm0oM4sDo3IQTzHFOPHyaQF/tU8yPWssJKqHwaT1O9sHiBc3DruyjYYK6Jr1ENJGI4kimkUr4gnuaGp5TCCGiywUm7LV/bTlrWIDiTeY7WEmfB7kmjgOe5mbblQqO5XQUxzxtyIoxM5kpyYcrYRB1X2+QlojEhY4T3yxrGoc4WodPu7uMQnfHFS46PN3HVUXekkY6xGrhPYoMq1yw9HvDbEVRfQU29mMqH0iad9E9bi19DGu61qYxn0xEKlv5uiFb7STXbaUgK+RN7idvnImFQZPklR650jTZyHSjPMJLEHEdW3negh2XaYQlHNETDkSXzmObHhE+vf9S8Z2iHr5PfnYSmiu/3yafZrCaF5yi+QNic/yuJBZk12Cr/fJksOwJunuWc+ZXPg8vXYhcuWu5nHKXNXXHtXRgYpgQ2QFpag38+PC6ysDfOcZemt6bhbPwaVtWQzxSNWwx+oqxgJoiMraoaMVJkTsJNhAjThTICm+Vofjj3movVEtRph3og8XEmtjJ8REG1GxCmYkX7sPPVZGvFD+LS7Q0oXAKpSfmtDxrZYxopuzv0OIoD9MGYyCCI7Vb35ywIywFGNVSOiBsNF1zX04j595yvhaQbi0TmFdaNSMEzeN21zFWqTiUlqBcU6V4WUr66WEIapctpuS1YiOwT04AlG1J+CBCk1h96ImI6cC1TR3dKES6/BQA4aCSJSxwiQDFGhSWoaC9EbFqy8GgSgnAySaJeligULOwpF57RBxsEAhXeICr6R7tnwkl
 TJGQ87Ao
 g9AoI3J5wTEbWlMEzNUxlZUR5YbdgJeqxz3qGrVFBlvwDrNIJ1j0K3SGdMp4kCluiJxHSiArQWinouQWf+2VMEvzgGjC0hbpgGH31YOem46MrFdW7AYfUsviRfxJcTvFb/RHjzJ7u5ojFY++V2Y6nfjkisn4FJFGcNoLbezUt6IiNPYg2/BExjU9hEtBA4ywGjFda8JieDKsn5ck8eKWGWOm/tH5ZirrPngqL6PGDoOXxvoIHkffuvRQqOI6Ibuj24DNKtmgMVgtW1hLCNEhVbGvFN2iDnxKZZwKIWggxKSWtLzwKAHG/NvhPp7KUkk3UZbxb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc slopper.

On Mon, Oct 12, 2026 at 12:09:07PM +0200, David Hildenbrand (Arm) wrote:
> On 10/11/26 15:22, samarth.colleges@gmail.com wrote:

> > diff --git a/mm/madvise.c b/mm/madvise.c
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -426,8 +426,14 @@
> >  		}
> >
> >  		if (!pageout && pmd_young(orig_pmd)) {
> > -			pmdp_invalidate(vma, addr, pmd);
> > -			orig_pmd = pmd_mkold(orig_pmd);
> > +			/*
> > +			 * Rebuild from the entry pmdp_invalidate() exchanged
> > +			 * out, not from orig_pmd: hardware may have set the
> > +			 * dirty bit since orig_pmd was read, and a MADV_FREE'd
> > +			 * (lazyfree) THP whose dirty bit is lost is discarded
> > +			 * by reclaim, silently dropping the store.
> > +			 */
> > +			orig_pmd = pmd_mkold(pmdp_invalidate(vma, addr, pmd));
>
> Okay, you are saying we can lose the dirty bit that could get set concurrently.
> And if we did an MADV_FREE before, we might not detect that the content was changed.

Yeah, lazyfree -> write means you don't actually free it.

As per the manpage:

	For each of the pages that has been marked to be freed but has not yet
	been freed, the free operation will be canceled if the caller writes
	into the page.

This is anon memory only:

	The MADV_FREE operation can be applied only to private anonymous
	pages (see mmap(2)).

>
>
> I suspect this found through the help of an LLM and not an actual use case in
> practice?

Seems very likely.

>
> Using MADV_COLD following MADV_FREE sounds odd at thirst. In particular, when
> having MADV_COLD race with actual access.

It's odd to MADV_FREE (lazyfree) then MADV_COLD (deactivate) yes,
especially with racing accesses.

I wonder if there are other cases where you could get weird races like
this...

In any case it seems a really hard thing to hit in reality. But I think we
probably need to fix this because of the stated contract of MADV_FREE.

I think probably we shouldn't have added that contract...

>
> On the PTE path we use clear_young_dirty_ptes(CYDP_CLEAR_YOUNG) which achieves
> the same through ptep_test_and_clear_young().
>
>
> ... where we also just do a
>
> pte = ptep_get(ptep);
> set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
>
> in the generic variant and rely on the per-arch variant to do the right thing.
>
> Which makes me wonder whether we should actually have per-architecture PMD
> helpers for that purpose?

Is it achieving the same thing? There's an invalidation here also.

pmdp_establish() is used to install a pmd_mkinvalid() entry and there's a
flush_pmd_tlb_range().

--
Cheers, Lorenzo

