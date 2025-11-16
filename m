Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13FACEBF61
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 22:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156738E0025; Sun, 16 Nov 2025 17:32:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12E2C8E0002; Sun, 16 Nov 2025 17:32:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06A868E0025; Sun, 16 Nov 2025 17:32:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E743C8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 17:32:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7B23F140B4D
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:32:20 +0000 (UTC)
X-FDA: 84117920040.30.69A567F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9EBAB14000E
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 22:32:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=O1D5YNTP;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763332339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dFifphuT1Ey8DYPYtkHFgtfxrd367msl8AST4REB3E=;
	b=NpPX5lVI7PgSIM4FX7C9TuX7x0dwwlHcjJiXXT79wEhvAdsydXk4ahZ17cjPxR/Lp1qiVO
	4Hoshe8VGE897a4wlR0Xfqr0yVXr/B8QW3PvLmdP9xAj9M17HR4POw65S+zNvjy5NGFGfW
	yhbf+bx0iPYd5+JeznBbfE/TT8Szi1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763332339; a=rsa-sha256;
	cv=none;
	b=Ivt+llp3qKliSY6SgMowDkpg12Ccgcck9LApw3KGRYoPu3/clm5XPYRYRUFQFA+UZzFaQd
	EzNCmTMqGm2+ptMWFaDJfNkaVc6VCWT/djh6/y/D7UKtnLrboBlvaRiWUByswkDIyBOA/5
	VW69cbRPXyFMacYN+OtwF29D9S1+8PU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=O1D5YNTP;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=4dFifphuT1Ey8DYPYtkHFgtfxrd367msl8AST4REB3E=; b=O1D5YNTPQJgIXJcZJEoln+5CeZ
	NNw8VuzPnK/fgPV/GdaodwrE7QkwJKzgVuTUVpOSZ5Hcze3ioQvn8Eap/jh5fuMkv6Z21FeI8+98w
	sq+LWdbYNvrpCuahvExYdYajTIqIGUxykHaClnbq9kgIHRZk6JigPgj67ELtfC8UdhLf1LxsoZdx6
	nDEhXmafcbvPTwxID3dqzHg1+5/Z4We4t3omUTrTL4FaEBkQMPe39A/VuQ5HXxzOiYOGap0cWWTUO
	PaoyOzwp+lcDrfuQjhY1Gu1dsHBAnipYtRoTvFW/yVE2OLZF8xtlJ2PUkRN04t7jCMlRPoc2Jhjmo
	awWIt6hg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vKlI4-0000000CqfL-3Rel;
	Sun, 16 Nov 2025 22:32:12 +0000
Date: Sun, 16 Nov 2025 22:32:12 +0000
From: Matthew Wilcox <willy@infradead.org>
To: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, eddyz87@gmail.com,
	andrii@kernel.org, ast@kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com, khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EBAB14000E
X-Stat-Signature: bfk6oumahk1bk69rtqdwdcepxjotix3j
X-HE-Tag: 1763332337-770115
X-HE-Meta: U2FsdGVkX1/XRGQ9ACNV5lhLjy8ja4pfhgC8Oz7F7MZhPl5lKOixcOzgKNu1NbfbDGyPcKrNCP+TbTT2yGPouoeA4G01VEIhGhk4PWcCnNJfjErFo3/ZlCIcN+w+MQB9XL70LVuEJXfn3d/H3zrCAtJqwze2QSvRAXVd9BFtWZ0PZpTIrr8Q773MPPXAaEaTE9/S32uCXbqtSsl6lf6p6BD3QlSFRceGmIURyZEESJFIc7OibUwX5a7zJaoGHJuGlfrIE8mlHY1H57Rcul7NtZSctdt1sfPvn4z0aPX8tjStAnMhyG7iAKGVzHX8sT2Z0oGSMFWYMVRBFJalgcvQlEO8n1YV1XRyVbiUzuVTx0tjO6YONWRXZCP1Qo+dub7dVsk01ZmmlWQvy0wSxXb7iAzrFHuq7efeWae5EkrC5wJIj6caDSsMX+aTNVF5kONCR4njijgq8toF/CuPn3ij64OD5E0jPxHNSxzH4+xFERCv8DOivO9eYHz2dQxma/OuRbWEzBSPz4GO2QiHpe1gTbi/KP68eEwHV0lzXAQ/Jb/LV9u8zaSDsTi2kX0f7xnLJAjU3FRQ+MQ9qfPXWnuBO7pwr1PA3+R4euW7vXP0biX/MHbdcGVOZYZhOAmN7D8qxetudsub54SZo1xR84XszwtzRBfnZN1rUPMf9PToD/uiVF+Z5AyeM773N3yft6+VTnPP1xAlQkY/ipLvVuvNwTE+pKMDAHEHg2fFda/e7OW2C9N7wT4uVWEPG8XPc/UL8a8yGwcjDVmFNPzB2zscLjWdNCI5zAOWcjycYdGIHU8Ly47DH8vtq6DkidQ5iDrZera4+1vTmnjtFh+HvD+xprL+tElHyI/vLsCNdTDcgNC5O0toHFXkccOQtXZW8MZln41ACWLkYVefDCsUH+1hN5MEMSRHiVRtW/ct09JqUn8EV7IAzjLs98QNzHkjWRjeZQJp4A/t09rjc1ce9yD
 9qrUrQmv
 kU+FLMq4BKuV9SHv7wv0mci9XU3ejxjXlkHAQoMfe9j6x1NrzbV+W7pnnqTM0v5NHKpdiqh8nwGVdmfKH/byNcjQrFz2cQcyXsg7H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, some process things ;-)

1. Thank you for working on this.  Andrii has been ignoring it since
August, which is bad.  So thank you for picking it up.

2. Sending a v2 while we're having a discussion is generally a bad idea.
It's fine to send a patch as a reply, but going as far as a v2 isn't
necessary.  If conversation has died down, then a v2 is definitely
warranted, but you and I are still having a discussion ;-)

3. When you do send a v2 (or, now that you've sent a v2, send a v3),
do it as a new thread rather then in reply to the v1 thread.  That plays
better with the tooling we have like b4 which will pull in all patches
in a thread.

With that over with, on to the fun technical stuff.

On Sun, Nov 16, 2025 at 11:13:42AM +0530, SHAURYA RANE wrote:
> On Sat, Nov 15, 2025 at 2:14 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in wrote:
> > > When read_cache_folio() is called with a NULL filler function on a
> > > mapping that does not implement read_folio, a NULL pointer
> > > dereference occurs in filemap_read_folio().
> > >
> > > The crash occurs when:
> > >
> > > build_id_parse() is called on a VMA backed by a file from a
> > > filesystem that does not implement ->read_folio() (e.g. procfs,
> > > sysfs, or other virtual filesystems).
> >
> > Not a fan of this approach, to be honest.  This should be caught at
> > a higher level.  In __build_id_parse(), there's already a check:
> >
> >         /* only works for page backed storage  */
> >         if (!vma->vm_file)
> >                 return -EINVAL;
> >
> > which is funny because the comment is correct, but the code is not.
> > I suspect the right answer is to add right after it:
> >
> > +       if (vma->vm_file->f_mapping->a_ops == &empty_aops)
> > +               return -EINVAL;
> >
> > Want to test that out?
> Thanks for the suggestion.
> Checking for
>     a_ops == &empty_aops
> is not enough. Certain filesystems for example XFS with DAX use
> their own a_ops table (not empty_aops) but still do not implement
> ->read_folio(). In those cases read_cache_folio() still ends up with
> filler = NULL and filemap_read_folio(NULL) crashes.

Ah, right.  I had assumed that the only problem was synthetic
filesystems like sysfs and procfs which can't have buildids because
buildids only exist in executables.  And neither procfs nor sysfs
contain executables.

But DAX is different.  You can absolutely put executables on a DAX
filesystem.  So we shouldn't filter out DAX here.  And we definitely
shouldn't *silently* fail for DAX.  Otherwise nobody will ever realise
that the buildid people just couldn't be bothered to make DAX work.

I don't think it's necessarily all that hard to make buildid work
for DAX.  It's probably something like:

	if (IS_DAX(file_inode(file)))
		kernel_read(file, buf, count, &pos);

but that's just off the top of my head.


I really don't want the check for filler being NULL in read_cache_folio().
I want it to crash noisily if callers are doing something stupid.

