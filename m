Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9307EFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE0EE6B0088; Tue, 28 Apr 2026 07:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91306B008A; Tue, 28 Apr 2026 07:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80046B008C; Tue, 28 Apr 2026 07:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A8FCA6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:20:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 56A911C063A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:20:39 +0000 (UTC)
X-FDA: 84707721798.15.57D3FED
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F1B8180008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:20:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777375236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wVlN3F/adnpU3EbVMRovr5PQ7UzNKrgvugpJLXSzjvA=;
	b=Ld3qeMKcEoN64lZfKbtnNNOAIHvESJHu4Owxltevcz0z3PPwS+u7B3LBeyZ1Ly5uVC1YrR
	y8ip4LW15Vi937am7opBCbNe7Y50q1U0MBKYZQJBiDR7K2H4HTyI/0wvv+bJZ3383yPiXO
	9vqb40vH+ZO/Nc1iZoGD0fJ4OUFPZC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777375236; a=rsa-sha256;
	cv=none;
	b=HH3RpoDSpWQA2k4HMJke6MW2sN5pfIBMsKdIDmuU0iLnqLXt+yrmwZ4xSuny4xCyn2CjsP
	rD9qWboTx+PYelY23aEFtLFJ9/4syICjvja3MA5Q+IOadCRxnRuU62AnWXo6q/gAd1Br51
	vZ2tx5izrxUATej+rqhReSvNirnm/m4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of segher@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=segher@kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 63SBKIxF1057213;
	Tue, 28 Apr 2026 06:20:18 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 63SBKHXo1057211;
	Tue, 28 Apr 2026 06:20:17 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Tue, 28 Apr 2026 06:20:17 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Laight <david.laight.linux@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org,
        Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
        dmaengine@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org,
        ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org,
        linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org,
        linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
        loongarch@lists.linux.dev, linux-m68k@vger.kernel.org,
        linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC PATCH v1 7/9] x86: Add unsafe_copy_from_user()
Message-ID: <afCX8WlnEFUei1y6@gate>
References: <cover.1777306795.git.chleroy@kernel.org>
 <0ee46bb228d97163fbdc14f2a7c52b93d8bc34ce.1777306795.git.chleroy@kernel.org>
 <ae-j2_QirCySZD02@yury>
 <63a4d0f6-0eb3-48cd-9f98-bf7b223b2606@kernel.org>
 <ae-2yLWSGnfeTvh1@yury>
 <CAHk-=wgPrLy0FR3sEWBYQuNAac1axDASYMnTuPuxEU0WytzL7w@mail.gmail.com>
 <ae_jeJLlVWjJ4sOY@yury>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae_jeJLlVWjJ4sOY@yury>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F1B8180008
X-Stat-Signature: b143eodtd1iqh4u3ubk9hiy11okiiq3p
X-Rspam-User: 
X-HE-Tag: 1777375235-710086
X-HE-Meta: U2FsdGVkX19t5tDvbAjlxQLycs7LZuJW+atE4SQqmpatzdDYO/j+FnxGE8rDuip7V3EdPQcS0YX5i338fLmGtUQIIP4AC5hcrasTqMPHlmArQaYbuX8sCjDmXVs3PLHpuVlXF67DRc+T311EwR7dg7xxGL9gkxX8+rTHv0dBOw08DBW2BLtgBWPoh+vwCyi7MmIC0eTv0DfwYA8/ZF2oIdBuFHSO8uwS65yxh5nwtq+7MvUZxo1NA7jWRdVU3SJP2XL0fh0826dEs3A7Xy3bdk6SVm/Di9i7BXEllEFSJy1BK/gMs+V17tkC/7SVGx7hDWGsJnx4MaHXZysj92GTFfueEDVLRnGo/L0SSHju20eaa5yKBsT0FRuH6XzVWCdWJ9Ln7k1IwiHfBq5TNrxZxl840iP9byYSEXAfxoLlKMXeQTch352ztezGX5QQJ7VeXYP2rrBElNqWAdmkAx2PXMPBL5kDJy6t++s91BZVVFhU+StPW1A0J8j207U9f71lGe/nO2UWFXyPfDnlNHM8o+b+55diolOmPh+cWLxTbSMO+9FSV0tkc86lpwnYSoLEp/DNgRCSSXiXzLt8FTgRX4aMShWmCAnqRqCWurPD5kNhSqXOJGFxO9dCn62s/qMHi2fsGHZAQMNQ/HzOsSghAL0k7Oc7qH2nVZX3z3XGVr37kSWP+0rxEMYL3jcXRex110loaNlNYF/nAZ8anesazIavo1BmLJiVFxG53kCYvoX78F5v+faTdaCXhQd4SnG2d64u8XjCWgKtRZE4x3+ykDHSCa6Cpb0XSSnlj2cAY+xYLh1YeGwb1hsNw1dTPWlhKzdFJ/71+7MOC5fhN9VzVAGM3jmZqxEc0zqOd5JXUXEeYfXbFJeu53NeP2ROkwwyahenf5S3GhwmxwCAJzVI3Yjkqx5GfyFNRlYhsMWG7fR823t0J+ajb583fXQ+xLm97IRV4UpWU22N1nHjXz7
 ACqosjKN
 OuGoocEr2R65NMJA0Np328FUjQb5iRUrmASSAeC6evZSsP9VdZlGQwMNUUXX62sGjFwsYpASTtOpxH1kK7MXvDQaeikoSJ3jNtVN0ilELLEF45l6w1hZeDpYzFVq9GIJBnP6tQ1c24zA6v95DezLaDl/xoq1b4roQGYl3S4Xdy01Gywtb0dk+FPxV4pnA0Bl1Z5xc3kx5Wc8P/UnTtoo8jx7w1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On Mon, Apr 27, 2026 at 06:30:16PM -0400, Yury Norov wrote:
> On Mon, Apr 27, 2026 at 02:52:05PM -0700, Linus Torvalds wrote:
> > On Mon, 27 Apr 2026 at 12:19, Yury Norov <ynorov@nvidia.com> wrote:
> > >
> > > This is what Linus said when added x86 implementation for copy_from_user()
> > > in c512c69187197:
> > 
> > Note that some things have happily changed in the six+ years since...
> > 
> > >   That's partly because we have no current users of it, but also partly
> > >   because the copy_from_user() case is slightly different and cannot
> > >   efficiently be implemented in terms of a unsafe_get_user() loop (because
> > >   gcc can't do asm goto with outputs).
> > 
> > now everybody can do asm goto with outputs.
> > 
> > Yes, it's disabled on older versions, so it's not *always* available,
> > but all modern versions do it. And if you care about performance, you
> > won't be using an old compiler.
> 
> The minimal GCC version is 8.1, and asm goto with outputs is supported
> since GCC-11. That would brake the build, if we just switch to using it
> without "CC_IS_GCC && (GCC_VERSION >= 110100)" guard.
> 
> Is it worth to maintain 2 version of the function? I don't know...

GCC 11 was released five years and a day ago.  The last GCC 11 release
(that of 11.5) is not even two years ago though (but there will be no
more!)

So it would be not conservative at all to require GCC 11 as minimum now,
some people might even call it a bit aggressive.  But in a year (or
maybe two) the lay of the land will be rather different.


Segher

