Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 136F0CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 17:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9365E6B0088; Tue, 23 Jun 2026 13:12:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8916B008A; Tue, 23 Jun 2026 13:12:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D6436B008C; Tue, 23 Jun 2026 13:12:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 574616B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:12:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D6376167231
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:12:02 +0000 (UTC)
X-FDA: 84911820084.04.7801F6C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7410316001E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 17:11:53 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782234714;
	b=LjN5JyQ6A3C6Ik+lWOVWZMzRiXS3kKokDNGdkZtuEUAT5girqKIbJjTOSxFVBayGtzXN4u
	mOMMR0p8zCQ/fj5MTksPLR0yh5K7RP1hzRYqCFCtibOj/ViqQLqathwIBHfyOu21DY91ii
	9hIWBQOl47pwJ9y65Ehx54+iZGejUEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782234714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZVkYOevjL7FlXWA0dHOu3mnPA7zEZjKOe2JRitWsqY=;
	b=gx4+FP68X9l9lnA6y99AQ5oD44YozDOtlPcdStKy3RIhiIiZJl0eb9vM5kBnBiBCLrlmKH
	0F49Z8PjnM1q09Lc5SaVaiVjP2WfVjxw+qSDX8c9j6sgV9/xkmVxaa9FpgSzugZetULt/r
	iUeHtukNoM+dDNV8hzMGZ8AtRv/Wdpw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GqGg8pmM;
	spf=pass (imf08.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A5C0514BF;
	Tue, 23 Jun 2026 10:11:47 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 290E03F62B;
	Tue, 23 Jun 2026 10:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782234712; bh=Dxe3mvHcxdglVG7y4dd4JmaJkVwRDW0juOrCiKYqNmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqGg8pmM+4me4s427XLrPiVTIz4+Bk5hJxoH7b02XrTCiKzTMeZEr81wh5odqYxCq
	 Uvscfxy4Ql2su1sbLaQdBANm5mQCX+XE4vv/H7J5V0E+6hfqZv7oXxs9L287NH/Sgp
	 RNdKP8gA1DrJD2dJ+px4es/a9yQ+tJYHSGjgwQ4Y=
Date: Tue, 23 Jun 2026 18:11:46 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: Harry Yoo <harry@kernel.org>, ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
	andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, kaleshsingh@google.com,
	21cnbao@gmail.com, david@kernel.org, will@kernel.org
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
Message-ID: <ajq-Ukmd9NBruhr5@arm.com>
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
 <ajVByfkLbetzA8bB@arm.com>
 <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org>
 <ajltLd6FQg1aMge_@arm.com>
 <78d97371-b477-4230-8690-ac870a7bab3b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78d97371-b477-4230-8690-ac870a7bab3b@arm.com>
X-HE-Tag: 1782234713-270157
X-HE-Meta: U2FsdGVkX19VgdFtFwu+8N/tbuewU1BXfZnbgy7lK9ZLO7xI3M61u0NpEmOKGzg8oes1TMFPysmqccwOrfjvTJCTjOZP46zkvi4st95wgITYYZJqYKsE2hHJ4n6YCQ65AojTndZrB9LffbvUAOzdT+4En1ALDOgBqZeK9WDHbzLSQab6wP1VHdzKDWcEudghQtigEPOdBSpEUuMGs6kmzlKdkC5oqFQRkqveNmuFQfXQffWEK/PlIbqGJgttQ7TpWAkjqKsGLEZaj9cR7IX+gTqYvXmCsTW5jEjmmtD8Ej58r3x1rIFaNhjiagLUg0lCC1mauVm2ULWdTl0pubnj0M9hMBpAf5KYOO4TTcbY1YTI85eY9kLJPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 10:32:16AM +0530, Dev Jain wrote:
> On 22/06/26 10:43 pm, Catalin Marinas wrote:
> > On Mon, Jun 22, 2026 at 09:42:10PM +0900, Harry Yoo wrote:
> >> On 6/19/26 10:19 PM, Catalin Marinas wrote:
> >>> On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
> >>>> On 6/12/26 1:44 PM, Dev Jain wrote:
> >>>>> Now, when a memory object will be freed, it will retain the random tag it
> >>>>> had at allocation time. This compromises on catching UAF bugs, till the
> >>>>> time the object is not reallocated, at which point it will have a new
> >>>>> random tag.
> >>>>>
> >>>>> Hence, not catching "use-after-free-before-reallocation" and not catching
> >>>>> "double-free" will be the compromise for reduced KASAN overhead.
> >>>>
> >>>> I doubt users who care about security enough to enable HW_TAGS KASAN
> >>>> are willing to compromise on security just to save a few instructions
> >>>> to store tags in the free path.
> >>>>
> >>>> To me, it looks like too much of a compromise on security for little
> >>>> performance gain.
> >>>
> >>> I don't think there's much compromise on security for use-after-free.
> >>
> >> I think it depends... OH, WAIT! I see what you mean.
> >>
> >> You mean use-after-free before reallocation does not lead to much
> >> compromise on security because objects are initialized after allocation?
> >>
> >> You're probably right.
> >>
> >> Hmm, but stores to e.g.) free pointer, fields initialized by
> >> constructor or accessed by SLAB_TYPESAFE_BY_RCU semantics after free
> >> will be undiscovered if they happen before reallocation.
> > 
> > Even with SLAB_TYPESAFE_BY_RCU, the object isn't tagged on free either
> > (or realloc, only if the actual slab page ends up freed). But we don't
> > get type confusion for such slab.
> > 
> > However, without tagging on free, one could argue that it reduces
> > security for cases where the page is re-allocated as untagged - e.g. all
> > user pages mapped without PROT_MTE. Currently we have a deterministic
> > tag check fault if the page is coloured as KASAN_TAG_INVALID. I think
> 
> So you are saying that a stale kernel pointer can continue to use the
> reallocated page, because for non-PROT_MTE case the page does not get
> a new tag. Makes sense.

Yes.

> > for this patch, it might be better to only do such skip on free in
> > kasan_poison_slab() rather than kasan_poison(). Freed pages would then
> > be tagged.
> 
> I think you mean to say, "skip tag on free when freeing pages into buddy"?

No, I meant always poison via kasan_poison_pages(), as we currently do
with KASAN_PAGE_FREE being set.

> So that would mean, kasan_poison() will do the poisoning also in the
> case of value == KASAN_PAGE_FREE.
> 
> > An alternative would be tagging on free only with a new tag and skipping
> > it on re-alloc. But we'd need to track when it's a completely new
> > allocation or a reused object (I haven't looked I'm pretty sure it's
> > doable).
> 
> That was our original approach, and IIRC we had concluded there was no
> security compromise. However it is difficult to implement - it has cases
> like, what happens when two differently tagged pages are coalesced by
> buddy and someone gets that large page as an allocation.

Yeah, it's fairly complex.

I think the more problematic case is when we can't detect
use-after-reallocation and this happens when a page is reused untagged
(probabilistically, also when the page is reused with the old tag). As
an optimisation, it might be sufficient to skip poisoning when freeing
an object into the slab but keep the poisoning when freeing a slab page
into the buddy allocator. That's where the page may end up in a place
untagged.

Also for your optimisation to only tag on reallocation, do you have any
code to read the current tag and avoid reusing it? That's useful for
kmalloc caches or other merged kmem caches where we can have type
confusion.

-- 
Catalin

