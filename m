Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4D4CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C356B0093; Fri, 22 May 2026 05:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6226B0095; Fri, 22 May 2026 05:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F116B0096; Fri, 22 May 2026 05:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF7AE6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:59:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 717C29152D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:59:40 +0000 (UTC)
X-FDA: 84794608920.16.ECF8BBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B7FCF40002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:59:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqGHgDrZ;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779443978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8p0T4HNyPt2rtXXItCwHLCB30PYbM6+SRmeDyHpW9cw=;
	b=ipCf3Ahy8ESWDYXA6bzsCYLa4ZU/Vw/ZHFJFfsqwdMGmNWZRdukMJXtrjGcBqc3f9CIQ+l
	PxSnqKRPylV7UQ6RNgmtVbBp+M7ox9WwKYGgQVNaoFzS9g/whFrvDXZWZEzFKijonvCvqR
	I0vxtYHo24YCLkina4gdik/Kg6H6b6M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqGHgDrZ;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779443978; a=rsa-sha256;
	cv=none;
	b=hyhM2r1YjL646xpOqnfSXcQiwqhprvVggRs1NGb3C3+Z1x7ov1sToQDugfx5cS/Zic3Vxo
	wfsHQDOjwP0mcGIeQmLs6hXpbFFQIZSwdqafUcJyk5vPIi9ssQr+zWSGjUkOJBCTFfWxGQ
	bCiArRCTRXBNj4RuXVvgUnSf4erxbXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D240B60136;
	Fri, 22 May 2026 09:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3190A1F000E9;
	Fri, 22 May 2026 09:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779443977;
	bh=8p0T4HNyPt2rtXXItCwHLCB30PYbM6+SRmeDyHpW9cw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=KqGHgDrZsdOsieHVKysVXhcHgaodUEd3YW69EUjImDXu74JlBtzE+02Vun3dI1EPC
	 9AdaM39GaGHFsm4W9fje1kSJnTeI+Bgsu4DfNFhXFRRQswSpxfNVxRjlw+HPqz8sa/
	 1HeGG9B0JdvT705Ndutn8tb1FsaJdTsnGAPsQEzuEIr4WQk2TZmKtWrniq+cHcTEx8
	 +h0XvbKl5qLScCnPomNuOS4jDsAhdrG9mZFrMkOd0T7N9F6zInDzfA3I4No0vUpmID
	 Z9fCZ9Pgd1wPc4NJyYicruwHkBPpuI6VQbfbdi5lE4IS4inSNUq/8Kh3FFnJ45Y8K5
	 S8PGC+EW4gutg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
From: Christian Brauner <brauner@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@infradead.org>, 
 Matthew Wilcox <willy@infradead.org>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 Akilesh Kailash <akailash@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-api@vger.kernel.org, 
 Christian Brauner <christian@brauner.io>
In-Reply-To: <20260521155748.GA79343@macsyma-wired.lan>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com> <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com> <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
Date: Fri, 22 May 2026 11:59:32 +0200
Message-Id: <20260522-stollen-fabuliert-helium-82376a109c5e@brauner>
X-Mailer: b4 0.16-dev-05c9c
X-Developer-Signature: v=1; a=openpgp-sha256; l=1846; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YuVuEhwaHMb0Ugfecndd7/67rNAO5cvP1w5w6tDsGuw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQJaLJ9nsafzv/su3jKF497K1aGzw071/TmS38665l8H
 7/wtEWfOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbyq5Hhf5qa1v/j2cyaK90u
 /pascZaX+2H0V3tm+4TPG0169h/25mJkeHl/+epvi1jLAjit1KbOXmerZxfQYFh8/urqWXN0vb/
 w8gMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B7FCF40002
X-Stat-Signature: cyj3ewofz6oty3afsfkmr9ijy7iuunzu
X-HE-Tag: 1779443978-522064
X-HE-Meta: U2FsdGVkX1/SLF8aXMo9pqVfCmFvBtmzjGrIY1dvIDeeuJOOM6I+O8MY1gp4TT+6ePFMwMTJURs3K4BSxa4+MwInJnuhVqKVevfslZYXD4wmg42uGjI9FNzdd7IfFmmu+97NVFTg0l7QFgfyS2QxyxVMFQOX/SHUKgmVklNgI9ClqKoGCR+c5BPOUXFF3YmqJYzeM6gu66eLTkv405D71VK9A8MIXEaVvktU8h/bfr5UQiu2cdT+Dnrtxg2YNbgweQ2cNWbjwMrB7lk+gr1w19Ij/SSphyh8kSh4WV4NPWsvP4Lp5ef0beYw1stgr8HgtAUoS1UgXD8w54Yt1MuNwT7+qtPziLI1kjTZKsJsknZZGo7NQVD9+aW2UAe/4ewy/JzCG/5qQNhDMyrk4PAXq3UKzEJL9g43ZXEzBris59T+GpbwDZYcAIvrYGT97aTge6eNk5dpEhVXLMQlDPl5cFNwzdjqkwxuRZTTEAPQ4M/DBOwZi3nj0TNwx9VyqbTvK1fUtKo0153udFh4uo6F826e0hCMm8Tz4dgGmCJuQoVWZqCgj39NYcoQBM4PyBftY+FVXqTwqnGwTHtqqdrM8yB2DFLP9PEPXUB6yxLXbDMZmGcQyVCjPYhrXAPAjvfFHrZnwiEOzv6R3vfqR9tN4UExmiH6gnjiCYjQVPm4lz88vxts9SQrFVM1BUMT0wQH13Gh86p8V6y5nB+ODRyDw+JV2N7XASR6ii3Yq6vmoBUY9Eaq56+fO83UrA8eRzsT/OomgFuzmgcIPja6YMZlyzHc5gpEYE2/pt0abWkn9sB+oodQyjQPa9qUVwf+lVMgC0Y/iHMtCX158rxjvbSlMvLO1cDXznMkWPcmWKIS+OCmyjz9K/BKzc04njg022Z/kRFM0FQ2EAPBx4TKJRU4faCWHcqx49xtUsQqcESLGj9kstPApNTUs08oSnH/fxNQDKBcOYsT4KiZGP3W82Q
 1rVw/uQC
 QwZSBfqy0y+dkqaVjNtEGwBebfB6MPtB6fv10+weBRzVU4uaCYUU+gGOEqPtKohwHVitEMZap7HDZaPjF9EvyT7kvnMxuMGfZgsswc8D+7QBNB4+EcgSjq8T1ygRkQ3XQeDbjl68KmQR0V54FmIuzZBYdX0oCDAx252LjWTFABjpP55geCvzwZT+J74tswcJaaTjp3NvXe303qJoUfbNogBE7SbEzs6Qb1ciFOsp9NTAIECO+pxiEe9SzxWcmE97lbqKDLB/p83MBmJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-21 11:57 -0400, Theodore Tso wrote:
> On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > patch.  There's no justification for why f2fs is so special that it
> > > needs this.  What the hell is going on?  You know this is not the way to
> > > get code merged into Linux.
> > 
> > None of this got properly answers, and this broken interface now landed
> > in linux-next. IT is offloading a user.* xattr which is free-form
> > user data with semantics that are weird to say it very nicely.
> > 
> > All this was done against the advice in the mailing list discussion.
> 
> So let me get this straight.  This is a magic xattr interface which is
> not even persisted in the file system, but instead sets a 32-bit
> bitmask in the struct inode which disappears once the inode gets
> flushed from the inode stack.  And it uses a generic xattr name,
> "user.fadvise".
> 
> There's no way in *hell* any other file system is likely to adopt such
> a broken interface, so why didn't you just use an ioctl to set this
> magic f2fs-specific flag?
> 
> > I think at some point we just need to stop taking f2fs updates likes
> > this.
> 
> Well, that's ultiamtely up to Linus.  I'll say that if I were Linus
> (and I'm glad I'm not :-), and I saw this in a pull request, I'd
> reject it out of hand.  But whether it's worth making a huge fuss and
> asking escalating this mess to Linus, we probably should get a bit
> more community consensus before taking such a drastic step.
> 
> Christian, since you're one of the VFS maintaienrs, what's your
> opinion about escalating this to Linus?

I think we don't need to involve Linus.
The interface as is is broken. Using xattrs for this makes no sense
whatsoever.


