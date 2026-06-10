Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EAFCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64AD96B0005; Wed, 10 Jun 2026 03:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6225B6B0088; Wed, 10 Jun 2026 03:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F166B008A; Wed, 10 Jun 2026 03:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44F016B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:28:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09B2F1650E1
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:28:44 +0000 (UTC)
X-FDA: 84863175768.12.8FD8E68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64295A0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:28:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fgvSiRD0;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781076522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujw8//AhBz2ofNEZXVOO0whE9ziRkQU7WuP9Q2n1nw4=;
	b=DWAL6sbKm6aG4mGuxR1ll2rsNmf36vq3PcSitD0wmQDDXT1rqWl3G+gotN48Uq0xBaFd3C
	gzZ6dPEphIq6IsclDcMZtFwwMkK2b2rELrBuS2iByi5NRUKFW+AxOEpQx+ZcTHm1dm4qBy
	h3JuAANb4Jsf8Gfzmau803n4/a2m3xw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fgvSiRD0;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781076522;
	b=3FSm4ah2JklnNlAKCeL+YXrvbWCqNFZp7JFT/Jcd6ze0Y3tSAkje41wd4K7kMvHzSvC6co
	q4Gz8pJg12QrTDk2iA67HGRWsBgKER3213w6aVvvWr3w+dpBSLipxctKfHQytq4v+4nZBV
	kPjOeLUpyEtf1ft1ECOWYXWnpUtOHhs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A615542A44;
	Wed, 10 Jun 2026 07:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D40D1F00893;
	Wed, 10 Jun 2026 07:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781076521;
	bh=Ujw8//AhBz2ofNEZXVOO0whE9ziRkQU7WuP9Q2n1nw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fgvSiRD0nlrWeKZ00ARxxj8+SIeSOssxKo/IteKl5SNNXShxIV9RzZYZjW2fJDF4Y
	 BRLJiLnad8I+/cgypVTOTIn/c5oxyEme4EK0poeNVEmG9QKE7i/U92Q7yjVt2JPZoo
	 KKab8o9SdIM2XvpGoVICIQ4XwdgAVtaPGhU54ayQfCnfLlEaW3lPQVBllb9BkmzECO
	 nE7j1CjEqBtnt3cNbOS7Erz0xZkaANJGk+ly24VtiJa0PCDT3qoW/N+IRr4nTvwqZd
	 Z5PKSNrIQl7+mm2qzkxCg4AIGhgZkp5e7n9mKFUe2JXKDXK2WgGk0nXZXZ5u3/BshM
	 PjG2C1OvGIzpg==
Date: Wed, 10 Jun 2026 09:28:32 +0200
From: Christian Brauner <brauner@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Li Chen <me@linux.beauty>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-arch@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <20260610-saufen-zerfallen-uncool-5608105e0d8e@brauner>
References: <20260528095235.2491226-1-me@linux.beauty>
 <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
 <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
X-Rspamd-Queue-Id: 64295A0005
X-Stat-Signature: 8xe43q3ckbdqbsh4uxf1189a86iremoj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781076522-7239
X-HE-Meta: U2FsdGVkX19aNaqPyI0YPi32MAh80dBVd4L6uliQ/GLJMj9zUHVYuWkuc6Iap0p2LcXj45QQaiAaW/ifZ9+KDI3dEVfw9D/xa5X9kZPAhTwpmRRBMfW88I5W82+MY/Gn59EN8HglupjhHKw7Ovc8a6AFIh8xxP7vFjXKnXUeYhSpFRE2ymNCKJx9YlfIjBWzkQLNRTWCPGb/jZbQTk3cHS+mabC1DA9l0FGU3v5Yt1175OdM36HNEGUcSBWHdTjH41LhcCgAECAg6JJlCs5qEPPa3+gSTT/ARqGXw2Wk/ctRPoxnuQlWHNJnPkIMt9qb0XmRZYrC3RRLCGMzRiAbY4uGPcQxlZ6P70StVl3Za/2pQwLrP8Hd1F28+Iqqj8p5xWeVIKMKeZTIo2OnYrO/Uzxjc0oLy9nxNfS40aK1JjCHJTvigu7OsiMqXxi5p0Zpqw6JlsTJ+1YEi/cdg9/1rOJnyb86R9S6LQNUYYPDx8URYUQorHBwH2G9ymFoPO0LNVFEDFlUNYHHpLW7wwh+NFv2/xDGvyqjKAQ7wMAQrcF5xOh2/07MGpmCDd7R7Zh15/NkiBphK21NriR9OgCplr1PI1qAVnQoDerI0+PiZTByYhSrmaJBH+VEkZUvth0KMMXyPry1MzfOb9F2JLUUhO67VfhrDmxXvjGCd/DLVvHBRbYQKWzCigBb51jn+BDP9NAW8y5n9q+V4V3NKQcqyCNy9isvqZdlCkjHTRlZf7YW0AZmkHxumoJ0+yR+Nv//2AXJ5gBMIbhm0mebgT/8OpWWtP9nQtcL4pMU+yySg0bcht9SsJOqvAnn/UbUBpX1omVttsE/m/1F48dJJwBitJ2t4vXlDXOq0vrW9QRV69V4hk6LSZseGSy80h6q97M2deEsw0HMdqnunWDo28v6yeFehmb6eJDs0ZnRUWFpRKCq1ewUazMAZxtFz4XN1gFxKcq9QEoRAJqdh/oounp
 01ejkUPJ
 H0kl14hiNdYKuLpVWJxH8pql1LrJuBuSu8SBMugUfSawHjg176iuPPhsDdV5TgW3kYmfdS92Qh4yMha5TcZ2J/VsUGS28Fu4ddDJuUNTXqJgykPMDkD8KwoqzKu1vAmXtMCBofDamOY8vLMdMppnlxrKjmnnjIv23cNNEQykuwVnVW3lr2avPjiRXkMEKPgMSaYhQnENVoSkZP+DGswC9PFKPFLFGDCLwMReyxSY3rXHR4NH5Mo16BjqFxv1dRjf0w/VKa2l4eUUz/fRkeY1sWWlrt5Bkpb46FK/jHFPBTAgy212tKx6qm1RI+OcyCpKXQksVFXuB5T8C73WnorIVEwVlxDVh2o4Ki3pi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 05:01:57PM -0700, Andy Lutomirski wrote:
> On Thu, May 28, 2026 at 4:05 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> > > Hi,
> > >
> > > This is an early RFC for an idea that is probably still rough in both the
> > > UAPI and implementation details. Sorry for the rough edges; I am sending
> > > it now to check whether this direction is worth pursuing and to get
> > > feedback on the kernel/userspace boundary.
> >
> > The idea of having a builder api for exec isn't all that crazy. But it
> > should simply be built on top of pidfds and thus pidfs itself instead.
> > It has all the basic infrastructure in place already. Any implementation
> > should also allow userspace to implement posix_spawn() on top of it.
> >
> > fd = pidfd_open(0, PIDFD_EMPTY /* or better name */)
> >
> > pidfd_config(fd, ...) // modeled similar to fsconfig()
> >
> 
> After contemplating this for a bit... why pidfd?  Doesn't a pidfd
> refer to an actual process that is, or at least was, running?  This
> new thing is a process that we are contemplating spawning.  I can
> imagine that basically all pidfd APIs would be a bit confused by the
> nonexistence of the process in question.

I don't think that would be a problem because every api just needs to
handle ESRCH. Ignoring that for a second: the mount api has a builder fd
that is later transformed into a pidfd. Which is easily doable here as
well. My point is that all the infrastructure building blocks already
exist in pidfs.

