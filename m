Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 997A5CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 16:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE81F6B0008; Mon, 17 Nov 2025 11:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E98706B000C; Mon, 17 Nov 2025 11:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D877F6B000D; Mon, 17 Nov 2025 11:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C45DB6B0008
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:41:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CB278726D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:41:59 +0000 (UTC)
X-FDA: 84120665958.05.B43E5F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B815E100002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 16:41:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BruVpwO/";
	spf=pass (imf05.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763397717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6j7NromG03GxCB910sPIHN5CFeKS4e2hh8QlioN0jn0=;
	b=R3RbMKP8/kYl7KlFNgT3xeEsYa3+wbMIZBvvKrW8BcDbtxHHMNcUvih6R7ScyF7kM+6Hn6
	QmOXxnIIfmw5BQad7qvlj9OUQFKlJ4I1A1N3Y2wXLWn3VhOEHP9IVh87Nm3YMUgwStRK+i
	dg+fXidsi7KRTVB2kWQXBdZqwhFwhjk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763397717; a=rsa-sha256;
	cv=none;
	b=8kcycpQE9mTCq4zSX2xkMxOpDI1UyP9MxI6zhO+URbFDwyQ2HndivBpvXqwVzkKtGcpNAN
	ynPYeSQ54qd/RBdwu9pQCKfROT9uUGfDL1TqWgXqImb3fiWgE+4If6V5+bxq8hRjPy7moe
	d7bMNZCAXbzV3I4rxYpbQ2om6ZWjx/k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BruVpwO/";
	spf=pass (imf05.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73CD0443E2;
	Mon, 17 Nov 2025 16:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44E29C4CEF1;
	Mon, 17 Nov 2025 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763397716;
	bh=dZ251Jd6bLrB7WwBSwgnKezSZ9PfbBw2z/HUXlRFHck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BruVpwO/difzdwaljwe0afX7jV92ylBmozwdxiXCjvaF6TEIEG5ryBKnybz3fiGT5
	 I1OH4hkoVayKGLETjl491dwOdYOavboux+e7EUqEou8Jg8sYUgmfKJ/FmilBlMrS3D
	 gFGjNykzMWImAvhr3OGZ6uXUaGAEN8F4yY+UfU3uS4JHUF2fO8+rcCnLycChGRwdei
	 u/Ms5MCTO7G36cjNebz8mxWh23JNDqdeNVcacbdpJ26dofOzKHwtIT8k2JzXtdXWco
	 REQtZBARylVp5ozlrK1R6uXUWIptSeqXw7L682LwSLz46BP9qPHYv4P9l68nYe0baS
	 4ri6o4cLaXURg==
Date: Mon, 17 Nov 2025 08:41:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <20251117164155.GB196362@frogsfrogsfrogs>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
X-Stat-Signature: eb7x8wgrsc5wjnrrbipyq98kycc3agr1
X-Rspam-User: 
X-Rspamd-Queue-Id: B815E100002
X-Rspamd-Server: rspam01
X-HE-Tag: 1763397717-914204
X-HE-Meta: U2FsdGVkX1/oWmg1jmUFbyZFkf9rKy3D0hpfHLlHUjQNRgr7yoHxVzBc3WLPwTeyXRNxZPEyBTSrxlaPxilz/mS92UoD/2Y91KXEWnvnO6IBlEcra9yNGXfTjQgb/mDUmR70KTjGYWkIcYbRYttLkwtA7thlZD7pE8mli57ddiExW65CF6AUi+Zu400xgzg5TwGrtpu5EBR2F+xzDvb0AXudRxiqAvsrLHcRrJgoIkiCW0LYb/zj5/DYpj2WMKoU0fcGvJLgyo0M+yY4NPIFXueb8oRDDCobQ77/7IbGn+eADvY2irviNfOOo1ti6ELZYbpbe+RclR6Z5CkRtENIAJ7u7rclDNFvY5RjptPlFFLo/ZIgYbxDfAMEOGZyMtHJ4GOiev39bl3XsPIhOWJRzKRO7t47lFTlIGudD1Q3VfaKI3Ft+Rx/MzaRJ71F4ubu9x2mbUJBv8Cn1b94Nl51enZKPJl/1FRyWXx8KoavHeDQrY6B+fMaF/j2zTmLibmYriNWb8+yQFs6UOKff9rB/YUI+YTIV2TgYZhkftVENz0uoZYSR9CPJhSUknTa5MF7pdY8Kv1GH9Ur/dQtpeSLe9Y8FM51gy0hQERGSib7Kner6hbpeD4YrO7Y+CHVRHqFZ0OCKx0iGNnLICY7p6Sn9apif/o/bl3FLPgW4S7BrCj+sBYsM2bVvqBp3lB1+RclbILz8gZ3CSIofHU+8H+6Y8qvIPRD4dh2FZk/TvBxossNZd5gdAuPKLAyidtbzBPxBn7jTCLZkJi+Gp5bTnVH7ownQFL8/OKlprBwDwhl7Bzq0bpw55Jgm3f2iGr/Q8kL5C0RsP5Q3tZTc8GHw/slhh8uUe29r+VKF7XPiHBAhsnxOyiHQlqJeV30BgK2rpfEPrjLpi/RLZhuWl+WhY3QaN8Xps+/33H2JQr87J2JzTClT/LwPHcB3glxZ+qM1qD330xeUWC4fUrzjhqhGzT
 AQTPk/jb
 6RYDNvQb/H16+06M4OCr+H2bAK0k7ChxRCos4lg9kiD6PpU9atsMrzpkGc/byPliRtAoeEj9Rla0e4lxTaqPieKqDPbiBCjmenE7GI5YjQqsEJccvAMMlhKlshmg6H17lo80f1pkVAMqxoCke1Nu3n1Y9kRunzYA4woc7p11vbZ/HU2Pzi3uvLfxxwxlLHZCCZdbH7kmgv0EzrhoIOF6UvoSyLc6g+nVpHMS/4tuwpJysqM0mDYBKs6AJ/a1PlH5BOrilgnY/g7N6Dn3GmmJafh8pN6RVL1pw13QYhCBGBG18fpiccWcrJ9hUGAnhXPcftHgJQVGlqFn44HGUMMEhwOxqIk2K7bDqw22YIr77enSNVqXgLWef9h9/Geiao5s8OYdVTxcpHKd8ecO+WU0wdXy+7BtJCMCpZepTzhjO+bpPKx5rB2yiHSKVySPHoUPGsq1GTWxVNIX1imTchuY97qb2cALbOnL8miMW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 10:32:12PM +0000, Matthew Wilcox wrote:
> First, some process things ;-)
> 
> 1. Thank you for working on this.  Andrii has been ignoring it since
> August, which is bad.  So thank you for picking it up.
> 
> 2. Sending a v2 while we're having a discussion is generally a bad idea.
> It's fine to send a patch as a reply, but going as far as a v2 isn't
> necessary.  If conversation has died down, then a v2 is definitely
> warranted, but you and I are still having a discussion ;-)
> 
> 3. When you do send a v2 (or, now that you've sent a v2, send a v3),
> do it as a new thread rather then in reply to the v1 thread.  That plays
> better with the tooling we have like b4 which will pull in all patches
> in a thread.
> 
> With that over with, on to the fun technical stuff.
> 
> On Sun, Nov 16, 2025 at 11:13:42AM +0530, SHAURYA RANE wrote:
> > On Sat, Nov 15, 2025 at 2:14 AM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in wrote:
> > > > When read_cache_folio() is called with a NULL filler function on a
> > > > mapping that does not implement read_folio, a NULL pointer
> > > > dereference occurs in filemap_read_folio().
> > > >
> > > > The crash occurs when:
> > > >
> > > > build_id_parse() is called on a VMA backed by a file from a
> > > > filesystem that does not implement ->read_folio() (e.g. procfs,
> > > > sysfs, or other virtual filesystems).
> > >
> > > Not a fan of this approach, to be honest.  This should be caught at
> > > a higher level.  In __build_id_parse(), there's already a check:
> > >
> > >         /* only works for page backed storage  */
> > >         if (!vma->vm_file)
> > >                 return -EINVAL;
> > >
> > > which is funny because the comment is correct, but the code is not.
> > > I suspect the right answer is to add right after it:
> > >
> > > +       if (vma->vm_file->f_mapping->a_ops == &empty_aops)
> > > +               return -EINVAL;
> > >
> > > Want to test that out?
> > Thanks for the suggestion.
> > Checking for
> >     a_ops == &empty_aops
> > is not enough. Certain filesystems for example XFS with DAX use
> > their own a_ops table (not empty_aops) but still do not implement
> > ->read_folio(). In those cases read_cache_folio() still ends up with
> > filler = NULL and filemap_read_folio(NULL) crashes.
> 
> Ah, right.  I had assumed that the only problem was synthetic
> filesystems like sysfs and procfs which can't have buildids because
> buildids only exist in executables.  And neither procfs nor sysfs
> contain executables.
> 
> But DAX is different.  You can absolutely put executables on a DAX
> filesystem.  So we shouldn't filter out DAX here.  And we definitely
> shouldn't *silently* fail for DAX.  Otherwise nobody will ever realise
> that the buildid people just couldn't be bothered to make DAX work.
> 
> I don't think it's necessarily all that hard to make buildid work
> for DAX.  It's probably something like:
> 
> 	if (IS_DAX(file_inode(file)))
> 		kernel_read(file, buf, count, &pos);
> 
> but that's just off the top of my head.

I wondered why this whole thing opencodes kernel_read, but then I
noticed zero fstests for it and decid*******************************
*****.

--D

> 
> I really don't want the check for filler being NULL in read_cache_folio().
> I want it to crash noisily if callers are doing something stupid.
> 

