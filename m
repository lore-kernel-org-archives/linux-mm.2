Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945C7CCFA05
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA21C8E0008; Wed,  5 Nov 2025 06:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D799E8E0003; Wed,  5 Nov 2025 06:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6CD8E0008; Wed,  5 Nov 2025 06:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9CC08E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:48:05 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45E7CB61E6
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:48:05 +0000 (UTC)
X-FDA: 84076379730.29.4F6EA6D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9577110000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:48:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MwGXM1sZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762343283; a=rsa-sha256;
	cv=none;
	b=JU9k5Yehhj3wys4gCQ+SriRifyhSfOS98j7NMo2WmJ2Xgrn8oIsznHmfO5XyMT4D3Urk25
	/Tsqx6mYLjBHOMvMn//WpCVXTnN4bIA4Ottzvm8l4Q0Nk9xG2IxKkZh3lnl/aOizNBjBha
	ehFxX59QjaVTZwSHRLa5A/u2GIaZCEY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MwGXM1sZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762343283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxXbCLQxvn/59KzuFtW+MHCdYVZK1kOCrBQCFEwNh3o=;
	b=pH+rLnilvqdIxoW/8Y+aMh9lV/yrITolEDjtIsX0AQUD559WMveRaSizmmExy2ZqeK6ame
	Xl/3CqtbqXMSE5T/SZfQznhC3iicmvUvi2B8Np4K4ud778MAR5Ay0u+B6KbJaaNZIObBAI
	YfqUamYEr3MJ9K7ed3Q8sz25VFrpDQQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 750A544447;
	Wed,  5 Nov 2025 11:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CAEAC4CEFB;
	Wed,  5 Nov 2025 11:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762343282;
	bh=btxGnn6CCgFSpgKGiKlUN2Uoo0h0EbsAS5PsaSiCdPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwGXM1sZVPMMIEL85QYLjQ0vHOh8EXKaoJGqdkAadD4KEXSGC6jdo1AVO1v9Uko01
	 21aNnVjOVpauDxe0V1jUzhdmsI84/uGaC9tOddXiwkDzkDb6bNSYMptOr49arE3NTT
	 G6SAw8F8neQfpDJOmI7IdebRpD5zMOfpYvn5QfSpEZiD+QrufvkQ768kFjqD0bnA87
	 Pj+2TJSGXXZ+icT6U5pql6MqJ5IYwyi6170a7s7OSjLvjWWG/oucjF/Hk5DG2LMU9G
	 TmcbT+xMixtAp/AeDdsLQfShwXpZRbwgAaHKWSnA07a8ZNc+Q5o0/P69dP6yifcQVn
	 +jDFRzhxlPQsA==
Date: Wed, 5 Nov 2025 12:47:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, neil@brown.name, 
	a.hindborg@kernel.org, linux-mm@kvack.org, linux-efi@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251105-aufheben-ausmusterung-4588dab8c585@brauner>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk>
 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
 <20251029193755.GU2441659@ZenIV>
 <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
X-Rspamd-Queue-Id: 9577110000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 4kip361jqjrz44cybkw5pca4dkqep3eo
X-Rspam-User: 
X-HE-Tag: 1762343283-455745
X-HE-Meta: U2FsdGVkX19wtKx9wt7OKk5csD0d7j0318secgTvAL/muW9sTJfH1ZOcb02OE9DXl1+sl3Nf6EbTWvtmMk7vbeWO2/9BsYh0pdMvBjmwofeCSAIuQN9a9pWWLYKQ2yVg+GbD/HboZi9vHFuWuYQO+iNaBHOgYw/0Mf2Q/vIHD4kJpBaQBaGe3/5xoCoy1QuRf9dSNOwySX8BCaZClMH8L6iN3/KBqFiZDX7u86lEJM3gHKYD9c1gP819AkuKoa55FWGooUkvTIOmAfbdfoTZGaSnrMkU19LdvKmto+b+ueSz0Kuah1rIvfVmT66Sj2MwBo16q4STyfNWIzSGgv4Rn9eelizg3VuCk/6B06HQqBq5dwtlxrbcoGYq5JHajQjFwn6fIEukk5KBleq21Gs9BiD58Tn9BrNBws3M8d7iIJFVyA4TlRh0xzHo9Qk5+XzGra9iI4mTYotFrkmdH0qHq7oOiHZRAqoNOHWJS7M0EAlXWmT+uEUKAimCZnZb7hCsLQVjelmVzhJ8EFa0X+pin92z5Mgfl9eF/i8zfLns/haG+Do8uPqPTrWCS/9uWY+VEkexrOBBq6ZmTYlJT/stpcxY/0gZsjM8Si0c+snjWGsn8oBRk4LT3N2idvY6wVwz2muZ+CDe/YNvgwLIrUiX8VWcf8ara1AG31gsawEwTIfMH/bitS/fDPOVO3SOL9sQwfoJfjdre7LoYuA1KUT/D/sIVnEkV/c9fUrKrXdq1RjF1d5OP08/etMMb36iUjOtdX41nYd7m2pmAzrvT3qHnE7UuU+R4d761jKfF04zJROhx7SOfuC36yOLeen/DpVXbL7OJ1lSyb/GjxBuYAo+LDeyiLpqPh8jKeBP/telMEqqwgLJfuIGjTl2+fT9q4ylzN1nPag7LZ24UbDEANaIARZka5LcNY/b5HZEZYI8NaHm6Goo8kj/UvtPC50BJ6nE4Wwa2sNFik3gVZj/Ko2
 rnKQPBNj
 qc00V87vt+jd0bI31qSqRE35NYdxwVwU0bWHnp1je8Zl801Bjzk7AOkbkEIKkUzHVKTAv/8x5cP/8k6LKSKU3z9neqXFJ6dMe3CHk4obh/zH0nTuRxzDTag4ACtwveJfYcmQlZqR3bi/9WIRM7pp+0lnjTUqmCtUSH2GYxpnYhL+o8q9s6cPpwSTpvBUiUUaFXBBM33wuV2XgsDKhDhEbhs2Iu5b/Rze5iyoyKgyDWBcodbPAold37lak0i+o3WNxGEtF+KQvur1xFPKHpx9pEoy7UjPlJSRVQpMm/PxugGAWLed/y5BwO8yF0pPOE1lk1GQbfpPg6c6tHLpMvmunU6z7E+L6kv81jzZHNMH3TjYfqmg4mkIZNGq61UaKE1uiLF9v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 02:35:51PM +0100, Ard Biesheuvel wrote:
> On Wed, 29 Oct 2025 at 20:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > On Wed, Oct 29, 2025 at 02:57:51PM -0400, James Bottomley wrote:
> >
> > > I think this all looks OK.  The reason for the convolution is that
> > > simple_start/done_creating() didn't exist when I did the conversion ...
> > > although if they had, I'm not sure I'd have thought of reworking
> > > efivarfs_create_dentry to use them.  I tried to update some redundant
> > > bits, but it wasn't the focus of what I was trying to fix.
> > >
> > > So I think the cleanup works and looks nice.
> > >
> > > >
> > > > Relying on the -EEXIST return value to detect duplicates, and
> > > > combining the two callbacks seem like neat optimizations to me, so
> > > >
> > > > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > > >
> > > > but I have to confess I am slightly out of my depth when it comes to
> > > > VFS stuff.
> > >
> > > Yes, ack too.
> >
> >         Umm...  FWIW, I've got a few more followups on top of that (see
> > #untested.efivarfs, current head at 36051c773015).  Not sure what would
> > be the best way to deal with that stuff - I hope to get the main series
> > stabilized and merged in the coming window.  Right now I'm collecting
> > feedback (acked-by, etc.), and there's a couple of outright bugfixes
> > in front of the series, so I'd expect at least a rebase to -rc4...
> >
> 
> I pulled your code and tried to test it. It works fine for the
> ordinary case, but only now I realized that commit
> 
> commit 0e4f9483959b785f65a36120bb0e4cf1407e492c
> Author: Christian Brauner <brauner@kernel.org>
> Date:   Mon Mar 31 14:42:12 2025 +0200
> 
>     efivarfs: support freeze/thaw
> 
> actually broke James's implementation of the post-resume sync with the
> underlying variable store.
> 
> So I wonder what the point is of all this complexity if it does not
> work for the use case where it is the most important, i.e., resume
> from hibernation, where the system goes through an ordinary cold boot
> and so the EFI variable store may have gotten out of sync with the
> hibernated kernel's view of it.
> 
> If no freeze/thaw support in the suspend/resume path is forthcoming,
> would it be better to just revert that change? That would badly
> conflict with your changes, though, so I'd like to resolve this before
> going further down this path.

So first of all, this works. I've tested it extensively. If it doesn't
work there's a regression.

And suspend/resume works just fine with freeze/thaw. See commit
eacfbf74196f ("power: freeze filesystems during suspend/resume") which
implements exactly that.

The reason this didn't work for you is very likely:

cat /sys/power/freeze_filesystems
0

which you must set to 1.

Second, that "complexity" replaces your way more complex blocking
notifier implementation for this thing which simply deadlocked the
system as I reported and showed earlier this year.

That blocking notifier thing had to use vfs_kern_mount() which had to
come up with it's own internal private vfs mount to pin efivarfs because
it's called out-of-band and then walk the list of variables and resync.
Problem is that leads to completely untenable locking problems. So if
you want to go back to that be my guest.

