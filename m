Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C17CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 14:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A75C6B0095; Tue, 13 Oct 2026 10:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FB46B0096; Tue, 13 Oct 2026 10:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED82D6B0098; Tue, 13 Oct 2026 10:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1F9A6B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 10:29:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6F9A1C443E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:29:52 +0000 (UTC)
X-FDA: 85317837024.11.138A5C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 203D71C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:29:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTGTGta3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791901791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSi3PANfY4MjoDSvofvJf61AjnfTTXNg976PsOkYsso=;
	b=kLbQltqwBb9oGM35JKenGSRNvdOMXHlftziM6KUe0eOsQ19TZnQuTjACQVNFNJRTsRG9Z2
	M2RUFYS/ynCP8Fu2XVizZlQ7UKqUBLlA4cZr4l792zC9hOFaFbx07fwwAP13Iqj3pFwgdf
	wnuxaZg0kG0kXz3ssdErUgJihN3bcE0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WTGTGta3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791901791;
	b=R+TTLVIbdLN+6JORmfmqrSA3LyrfbgMIMrA9M1YPWqyTcxmlkx+xPc4mTaAGiI3sRIIsMA
	cZymvh2IktbxcTzuvxSIQHB9CYYyiRyRgxSJafLNXGNMcK/tsEjWTBAYL/4tJqupqycD8d
	7vhCAY371TfAi34obXBms4v5UkKn5i4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6650743795;
	Tue, 13 Oct 2026 14:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E121B1F000FF;
	Tue, 13 Oct 2026 14:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901790;
	bh=MSi3PANfY4MjoDSvofvJf61AjnfTTXNg976PsOkYsso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WTGTGta3BaGB0P5FZtBi8DBd/bdJ0/0OvzJgJhTIcEoTdneroJIuBFUEE2Vmpzre5
	 FJWH0TdGlGepmeWzARjpUcjDnfOTp6NZQ4YG+ariJ6pQ0HTL43BsozIhF44XOxLr3h
	 T049eRNF3g48x6Kww3M6v6owS/9za3X96XfcWnZ1ES1EO1tHzITfCGaiEEm22y8Fq9
	 LNm+/6ragNInKh6AK8AY1P9hYJIrweDdGR9ikKPnV3VjNRjXM5SNFmkzCmOJOWIEHp
	 8BevgnbGVefcYMLyB5XK2V7xMhsVhmkp51syk15Ph0nBwaEbd/kbngaPZltNdtBFJE
	 gS9/KL3jEkSiQ==
Date: Tue, 13 Oct 2026 15:29:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Kyle Zeng <kylebot@openai.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: don't discard lazyfree THPs at PMD level
Message-ID: <as49h2Zgs2wtkfmJ@gremlin>
References: <20261009-lazyfree-stable-fix-v1-1-70997958ef8d@nvidia.com>
 <asy445BYRhcsGDE9@gremlin>
 <8B17F897-40BE-4834-8078-949DA951B46F@nvidia.com>
 <asz2domYFnTe2owf@gremlin>
 <9CC1C4F0-1C73-4AA4-8D1C-28DB024E2221@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9CC1C4F0-1C73-4AA4-8D1C-28DB024E2221@nvidia.com>
X-Stat-Signature: mxdz4pchjdfunzeyn7trmg5sihpf53si
X-Rspam-User: 
X-Rspamd-Queue-Id: 203D71C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1791901790-904917
X-HE-Meta: U2FsdGVkX186wWeNtjzXsySIAuBn+bBYOO1u4ESyHtCqH8WUHero6n+RXueXaibBR6n8/sDYCskZuBLlcQBZIMWpMlHWQ6EGT9bWWbQ9cKA5Eq3m6DNExKtP+WFc0yBUDnxvbLP3CHbo+72jGKUCbToOxa86nagsiIVGC/Zv9HZp0Wlstdr4mXviH0RO7mXItYqDRJeuNAoTShCtpJVl7ciAdEWnUy9vs6c3WuOgT2TRKW6TJi2LH3bsAWW9BQjicqd2EounSO7wR32xHdOI0mx09XL8raW18kdkSxRIhcuYq8+99zjYmsM+OMGCbmj4lpKWBvv2bBABCTPJzstf8ZWoxjqNfcRbfYy9uA9I/pJDd8/JAWe2vPLaYOpCJrlaPxQ1KRQUkFbg0hbHN2F2OJjOuHfSL7nGVswcOIKFpQfVTaUV/PGuZnVKO+JDg+pb4BpUpkCgEdz+jfk6OAfY1Yv73MJr6FTcOoYmTjahxIFY8tywUIREcfD6Xh+yim2cro9YKxF2dqxaQPgQ/fkRf5DxFbqvHksFwTg/7qcjIEtfPNaBxDRHXIAPniIAhd2f1hMtR/XPogv33x1zl39t8DKJymknjA3NOMIf72Nj93ZAD4tzeHjuufGjvEWowEPCEFjnOgnkAVzZQlvfyunhV7mPm6QPfLpbLebWzuoQxyGqNqUi1eadccjcqAPTatXgNKZmkOPTbueqXMn7Pf1tzN4cte5qKTbi4nK1sqIPrwOXDB0ye34sbM8Q0Kx0YH7KrmWUaNnOkblrT9RLRzzllZoNLI7WylA95mA9k+aRicmaUEVCbZiMS5ovfs7RHugv8WrcN+lWAtlwIfGaisyjZVk6TML12wwPjPwNlwy4uyzifjGq/3SQJmeVBcXvQbaf0zOhDA8zSNMVPP6xf7Auu+xbxVZNt6ErljOlO3TnhM5HvgGqFOQ3z5Fma2PzC6QyKYb9V0+QGtiMzebC0j3
 XfYKdLhk
 rLx7B/vGEArJ520bhDWJC2W7kqj78IQUFW9v0TYWtdBJ5Lk34xZH9b/C/+ShFow5bC8nmGrKsGGZeQpYtmcJVeqpStNupY++ArZ/iPL5+sVy3+fGiviAUvrfbzaAmXn93wUSJCYBPAO+QVOs94gknAWobQG4NXNspVsaEnUSIQPvBnsx0qxcq7ZOxtLF5pqn1JD/wh0/Zu5yklspfV2Shtc/oI7SOTOHWZPfz5vVGrpgZaVsNxiqd01Wo4IzW8wd9bG4eWqx1We4k60PHTTrnOA+9AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 04:37:34PM -0400, Zi Yan wrote:
> On 12 Oct 2026, at 11:22, Lorenzo Stoakes (ARM) wrote:
>
> > On Mon, Oct 12, 2026 at 10:33:34AM -0400, Zi Yan wrote:

> > }
>
> Yes.
>
> My wording was not precise.
>
> zap_pmd_range() doesn’t take the PTL since it sees pmd_none(), while
> try_to_unmap_one() takes the PTL.

Yeah, this is nasty.

No wonder it took some AI analysis to find this :)

> > That bit isn't special to MREMAP_DONTUNMAP.
>
> Right.

But it is a 'very special' flag for mremap... :)

The # of bugs that thing has produced...

> > That set pmd could also UAF on the PMD page table in theory couldn't it?
>
> No, in __discard_anon_folio_pmd_locked(), the caller holds anon_vma read lock;
> when mremap() or munmap() calls free_pgtables() to get rid of page tables,
> they first call unlink_anon_vmas() and get blocked by the aforementioned read
> lock. set_pmd_at() is called while free_pgtables() is blocked, so no UAF here.

Ah ok thanks. Yeah the rmap lock is held throughout that.

Hey - when I eliminate the rmap lock things are going to be even more fun ;)

>
> >
> > It's all really horrible.
>
> And kills my brain.

Yeah this hurt my head too.

I actually (rare in 2026) only got AI to chime in late in my analysis, and while
it helped confirm/deny some stuff it wasn't even that helpful in avoiding the
head... f..un.

> >>> So unmap_vmas() doesn't correctly populate the mmu_gather struct for the
> >>> range, meaning that the underlying page isn't freed and the refcount,
> >>> mapcount etc. are all left as they were?
> >>
> >> Yes to the underlying page isn’t freed.
> >
> > The refcount and mapcount etc. would be correct? I think the refcount would be
> > such that it permanently leaks and the mapcount would be incorrect or only
> > accidentally correct?
>
> refcount and mapcount would be wrong in the munmap case. Both are correct
> in MREMAP_DONTUNMAP case, since the folio is still mapped in the source VMA
> but its anon_vma says it belongs to dst VMA. When dst VMA is unmapped,
> the anon_vma is freed, but the folio is still mapped and its ->mapping
> points to a freed anon_vma. A rmap code checking folio->mapping is a UAF.

OK I _think_ you can only have a destination that either has the same anon_vma
or is unfaulted (so gets given the source anon_vma) so yeah, the anon_vma is
still right but is pointing at the destination VMA, while still being mapped in
the source one :)))

MREMAP_DONTUNMAP really is the gift that keeps on giving.

> > They seem like they are existing bugs effectively in pmdp_invalidate()? Or stuff
> > that we would want to fix anyway I guess?
>
> SPARC’s thp_pte_count might cause other issues, since its code only considers
> huge pmd splitting. powerpc’s page table check might have an issue.

Such fun... lord.

> >> I can remove the dead code if you think that is better.
> >
> > No, if you plan to reinstate it (soon!) then that's fine, but please
> > explain that you're intentionally doing that in the commit message please!
>
> Sure. I will try to come up with a concise but comprehensive message to cover
> both the issue and why pmdp_invalidate() does not work itself.

Great thanks, I saw the v2 and it all LGTM!

--
Cheers, Lorenzo

