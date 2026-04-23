Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BB2F589CD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 930276B0005; Thu, 23 Apr 2026 09:11:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0A16B008A; Thu, 23 Apr 2026 09:11:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F65A6B008C; Thu, 23 Apr 2026 09:11:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD3D6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:11:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11A4C16016C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:11:29 +0000 (UTC)
X-FDA: 84689857098.03.E280680
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8985E40010
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:11:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zr9ltmpH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776949886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvk5sEdE+5BObQhhoSJTJjFRv2F0CGcQSoBemVZ/uK8=;
	b=DQiWfriwI0/WpiBVOiAB23KeE9t6hIfBa4C3F5WBSU4SV0tgrOPD0NhNzqahWHwebe1m3l
	5DnduBsY5k4FyrJhPWQx639MvNal+kDhU2kk1W85B/G58HiqP6mGLS12yFzH8vxSyBxbuX
	uF/e3z8rjhXpu4t4dSWrtdDb3XGAbOU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=zr9ltmpH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776949886; a=rsa-sha256;
	cv=none;
	b=v2PVdRio3qEXuYcV8yz8uWGiTZwVsherAl9EaSYqN4WW+/FiTBaOs055JJL+NeG1/h3Lht
	XZI+zyehP0KQUWYwkdZC0MIXJXHI5cjKAkARJqfayWfj1GiPsd0rB1fFNt2d0PoGRzk0U3
	vBN2jSzo5pUpBvpP1Ihuhymw75MkH4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66B5840864;
	Thu, 23 Apr 2026 13:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFDDC2BCAF;
	Thu, 23 Apr 2026 13:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776949885;
	bh=NgNx5Wx9WFx543DniRV0daakH/1Qxo617y5uaLhM+y8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zr9ltmpHiAFJSCjm6cVQGCv0pX9x8gQffjtVQwifkogwK5JxYx3eNqkRPpxbQEs8P
	 6R9NJSkoG9+IG3I38q0VHX1936NLu37nkbwumAltDTIWATIRcEVutZOlkXIVYPswH1
	 xC6rVI06nA11QuCwzYng7C/BhoxhszjB5LxyHeUI=
Date: Thu, 23 Apr 2026 15:11:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026042357-elderly-mute-6cae@gregkh>
References: <2026042334-acutely-unadorned-e05c@gregkh>
 <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
 <2026042314-traffic-riverbank-d9a1@gregkh>
 <b4e0877c-230b-463f-99b6-c363595e7ac0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4e0877c-230b-463f-99b6-c363595e7ac0@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8985E40010
X-Stat-Signature: jat374isubw54wrpqo91zjynrx3dbgzn
X-Rspam-User: 
X-HE-Tag: 1776949886-82950
X-HE-Meta: U2FsdGVkX19O4ykDsqd3wBUauKts0gbH+ozMkjroJpH8wIp95Krj9DLSY4m5Hzlwq660bl1Z3OOarSSIQNEmgGFGwB2I/JCorItovyDv4hO/LOhzZrwLDnHiKKSMhEuh+vaUgoUerfB9k9MdGe3fIUiPQ6WR8WZxLnOlkaPHknHY2oJGMHzODfdcMqV70UcSnfD45iTRbi7YjjYFcjRpv91i9Hq72XSbYnmbZmLCwEZdEzZAAGD2Eyk+/gxYNkUFEXqyqE77ivaaoc16qsrkdyuMm8GzlypT15UDkj/72mylMF0v5uLx5VxPINZ/96gTulu0q3c344ywX8DFaQ5PiQcsWYg+Krz9Bovs8PjjTwAnYshsgKGzGxqk3TOmsmpTENqglSiUVs/v8ewSbohx4BFdfo12+JBoFwIwvRbEbpMBlTKsc00BZ7nwDEk+vUvduRWmovgv85/nCxM3xnMU/SQGA19yeOW+Tgquu7YjZJW/LFCON9t9rrALh4UNTaPG6nT9tFJota5LSqYS5JLj5Ryqa3gjF8HBBDsJ7fFztQXbkOR9RsOXfpvPxeT+i8uJTVIYOBi7p58IgUOsvVWSdKjToPg15RoNk+mVU+/TQz0IO+jGC6F4baRKL3CAzAKbWNFxnwjUnIFaDIHwpfkS7T2vs6054G1iHq1UmweQe6OHBfP72sUJqO5UTEYtsO+4XsKG4QmmeaWVPlD5mOQyjwBXnr/325ZsUV39dJ82Q5Od6incrtjBdNM6gRFeqOo4YOdGkEPu8Og/JnHywbl1jt4SvW16XQeWqMaYaqQeQY7EoNqYN4F8g41jPZLik0hv5IYUgPKU/kUdog6jiwQvISFmv1M0ns5ZQDw8mXonJeUfMvxG7y8xQ99zNtsjfMZutyIJR5+fLG+FIFk4jZzxfuYntchd9OQKhnOctovnW6/nCmxX0eAfDRYdmJGfVluIm0mB/XFAg383kSTsAbP
 M3cLo7dg
 gI42gYXzGh5jYhRmkdAbWX1Yy9Z1xs9i+5ll/Ae5akiDGucH2ay/oA36+67VcvgNIoBexkdmqT/jiVLUWwwO2ijsrxQRBr6zFQVrR4LIYZJH1CZAcFfNLQtyrlMMfmNOfpeW4xeqbrZZn72HcdziTGo2vGGwB1idUn2GDsuKF2ZkRlSiIP3MCutc83Mv/g4oRusf2PlWHqUpZq4D2xg4j1+Uwfk4ZaVDhrgeHT1URkmEf+T/lECnPHPOuW0/tkGkpwb6GizOBURQF+AV89csMpTTqbSSRzmIkPLA509cO9rgxuow+QIHX9+1DiuQibomNhATpzchEtRbJR93pQVkI1peyuzZQBvEPw7pLWiipTq6CPzs2jmRyxo0TgRAUH8k//4hhW0LO0M0UIon7xy1QxO5Zdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 03:04:56PM +0200, David Hildenbrand (Arm) wrote:
> 
> >> It just follows what we do everywhere else (e.g., follow_page_pte()).
> >>
> >>
> >>> +				if (try_grab_folio(page_folio(pages[i]), 1,
> >>> +						   foll_flags)) {
> >>> +					pages[i] = NULL;
> >>> +					break;
> >>> +				}
> >>> +			}
> >>
> >> If it fails on the first iteration, we return -EFAULT instead of -ENOMEM.
> >>
> >> I know, I know, nobody cares. But if we touch it, we might just want to return
> >> the error we get from try_grab_folio().
> > 
> > So just abort here and return it?  No, that will not work, there's a
> > lock we would jump around.  How about something like this horrid thing,
> > adding back in the relevant unlikely() to match the other calls like
> > this:
> > 
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index ad9ded39609c..8fa5b37be8b7 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
> >  	struct vm_area_struct *vma;
> >  	bool must_unlock = false;
> >  	vm_flags_t vm_flags;
> > +	int ret;
> >  	long i;
> >  
> >  	if (!nr_pages)
> > @@ -2019,8 +2020,15 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
> >  
> >  		if (pages) {
> >  			pages[i] = virt_to_page((void *)start);
> > -			if (pages[i])
> > -				get_page(pages[i]);
> > +			if (pages[i]) {
> > +				ret = try_grab_folio(page_folio(pages[i]), 1,
> > +						     foll_flags);
> > +				if (unlikely(ret)) {
> > +					pages[i] = NULL;
> > +					i = ret;
> > +					break;
> 
> So, we have to report the old i in case of an error.
> 
> Assuming we want to also return -EFAULT on !pages[i] -- which i think we want,
> maybe the following (uncompiled and untested)?
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index ad9ded39609c..d00ff8d988fa 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1983,6 +1983,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>         struct vm_area_struct *vma;
>         bool must_unlock = false;
>         vm_flags_t vm_flags;
> +       int ret, err = -EFAULT;
>         long i;
>  
>         if (!nr_pages)
> @@ -2019,8 +2020,14 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>  
>                 if (pages) {
>                         pages[i] = virt_to_page((void *)start);
> -                       if (pages[i])
> -                               get_page(pages[i]);
> +                       if (!pages[i])
> +                               break;
> +                       ret = try_grab_folio(page_folio(pages[i]), 1, foll_flags);
> +                       if (ret) {
> +                               pages[i] = NULL;
> +                               err = ret;
> +                               break
> +                       }
>                 }
>  
>                 start = (start + PAGE_SIZE) & PAGE_MASK;
> @@ -2031,7 +2038,7 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
>                 *locked = 0;
>         }
>  
> -       return i ? : -EFAULT;
> +       return i ? : err;
>  }
>  #endif /* !CONFIG_MMU */

Cool, let me through this at my reproducer and see how it goes!

Ugh, nommu...

