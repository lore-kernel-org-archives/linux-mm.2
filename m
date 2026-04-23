Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40204F589D8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 13:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 825876B008C; Thu, 23 Apr 2026 09:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCC76B0092; Thu, 23 Apr 2026 09:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739DE6B0093; Thu, 23 Apr 2026 09:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 670476B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 09:42:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0FF2C120188
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:42:05 +0000 (UTC)
X-FDA: 84689934210.30.07A0976
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6E46B40011
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:42:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PsfsVAy8;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776951723; a=rsa-sha256;
	cv=none;
	b=lRS1ppbsilV8DgPAgNUC7uG5KTgv5gafp4u6zg+RuxDMLpib+G1MxyOcyaO2QpB81IxV0A
	7ipvYPjMV0+hgW6eIlWtu9n+XAUF8RfIJcZ/CSnUWtiBg7fjcBfnzgt+z3Mvk5uKTdidzF
	ckQyG0Zzdq2LssuogdIVgYvHeS96mqU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=PsfsVAy8;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf07.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776951723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGKlwQiZakubnAISaYpyLURAxTYG84eBWIwmavCZso8=;
	b=1fEXaOF/4bOvo9pgFHs8F5cscI8jZE0f7ZoJkK/P/au7G9AqESUqChIxMgRYB5al6cyTrn
	kIq2kxsoyA9DKdjkrs8KvnULLdpy/VWpjY3KIjpIfnpd6PTC3TSYVpynKlN1lYHGyQdRHb
	OZ8Qc3p0WA7egZePiVwfRKEFHmXTj1o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C324F6015B;
	Thu, 23 Apr 2026 13:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5C6C2BCAF;
	Thu, 23 Apr 2026 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776951722;
	bh=qOaA7NIPr2tw79ziq7W+A48uOM2/yb3Pe/Bnkwop12Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsfsVAy8uQgOpI3Y4M5eaBM3Sft+GDNd+f16EfK60t9R55sNhFrzmy53+Ltz38S3L
	 L8JzHVNDr1UrdeJ3HgbUIioD0UZnjTk0UOTbupzHzmm2SAKYkvlG3aFqsOOHErFN9N
	 B8mgTPo81ti72GOKRH7bDgMvTmKvGxI3/mRfrAOM=
Date: Thu, 23 Apr 2026 15:42:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026042336-hermit-stout-a63f@gregkh>
References: <2026042334-acutely-unadorned-e05c@gregkh>
 <dee5b7e8-864d-48b5-99cf-282eedaba927@kernel.org>
 <2026042314-traffic-riverbank-d9a1@gregkh>
 <b4e0877c-230b-463f-99b6-c363595e7ac0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4e0877c-230b-463f-99b6-c363595e7ac0@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: eq9pxftuu6eb4eyzsifnbmdnu4d9xooc
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E46B40011
X-HE-Tag: 1776951723-216890
X-HE-Meta: U2FsdGVkX1/nsA94BL5aj0agUGzO17N4hxtNZtbeG5jzsMv6Ek2e4so8JIOLCzjT4leepD7ENnJG+g8dhUvlUmU58wJAXNHi3IskFvz1ADEFY8Wjr6RFIaZkDgUnrAwdciFgTin1bZsvU1VRM8HJRgiZNsHp4t5s14cRx43nJfShoZTh+U5WqLyaWTHC+RrXEB7dhrJIvShDP7T7zbNBw4nhpVqZFHODGljUzhep3tVXuyQxmKjpn/9/ETE/2PdRISCJV0NOSV82aQCg1EZYaKi3loAZBv/sQjJlHWYbNCcV40H5Fp8RD0TknqFETaNptGgeq+We+Gma2aIrvvzR/LUbCOQq7qmOt1ovkDX0nvDXXaQMAMovDxUEp/u0bRc6JTOlPDs5Rqs1LpLdaSSQ8Nt05Vlkvsn1qElO80YYSHJH2vIDk1qvcJD46/CSqKMuvWKBkhYhYqUmykgOLcnj+hZfH4mjzAgZX6OhLAumou9kBTkiXYFF/HiftWoJDfLzikJj50ZPckbliA8TTbE/OhFn0CKAt4AI9JdIqxWiNMraXRfS/v9y1qMZ1gv29fsvajqMhAcgUHGivTUzyUMrqa8i2afzgAJP/bLfCxNz+M6185iYAaH3MMNf7v4dn8sS28WiJSvUNo3VOeCvULegia3xF/p4lmJylF78scSIbn7yT9dWzqlseCZvOElzrqN9QnqrcKZFTJMLSkTYn75+r6QWBIZSGH9aMvTG9F5vXe62tf1ydNJRw/MdX3pCmkKY+7cgZwav+kAkeJzpUGxVxxKC+YcZK4yTpuO6O5agh4abbNrENxyFuNhz5zEqmwFGlrr+MvW7APFwxjGDwmJFQWqy048sFX/zsZkm2COf/xeeVgDhhldcy0xly3AB2K0pHrPy3d5y9lin+lfVP2TkoptluJV18sXRkA4k2JywONN2n7ZCAwCrQ4NL33AC2kks57u4Sf7MVWRmzAho1Qw
 dmOj5XzC
 2ozxBoxlSvFdAJIE/Lu7Fv0UUwa1QWQ+mYhzQ9Znxd6ejzWUdO2cv8So4ARJipbDzy3niPv2HxjonxcogY2t2kdVdDrd0cHVO+JBpl0x35Mgj+2oYoWuBY/F746Z/fTrmU+kgt8j202RAL/k0SjDMl3yXA0Cy4VDhBs9hgPjfgV2rWrWScoaU0Uh6G4e0SeFOvMrATuGHabSLjv3mauznRnZvakV9SXLQDDCVYO4tII0yWPnHSSheG5W60QMBtB5uM0hT9n2tkdGpZCad00EW1VUbOnSIUs25FHMZ6o6W0DQQ8vfA51HbtYzK3YHcLk++4NutTMo/AW4qZ9g3jfLwX2RMk3pYzXGWJx2YprP7tupKr/hLOKUqCxKSsC7iGc7ZUddQKuwn/4qln0fm6KeLWsXtWA==
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

Yup, this passes my tests, let me go send a v2 with this version,
thanks!

greg k-h

