Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63512CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 22:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70F5E8E0005; Thu,  2 Oct 2025 18:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E7598E0002; Thu,  2 Oct 2025 18:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCBB8E0005; Thu,  2 Oct 2025 18:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 503E78E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:27:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 061631DFFF4
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:27:58 +0000 (UTC)
X-FDA: 83954613036.25.953697E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 16E9B8000B
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:27:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JJCpfBAo;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759444076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1b3dxs7sgJZh4+KCWUcvCpGnwHfwLmvzZBIJgjOLPU=;
	b=OUc4u9xTW3+gaLE+s9T3BXvIa0yzv3nZXjueOPRRE0wVQZ37jDl4tGhkItQTES2LoTD4FG
	9C80LZ+5/oe2mvfmW81BLEJQoSPKB2/ph68SEmIDQ0x2LdjuYkGLm4v1h4UkANj2urLzsM
	CgL8dWU8RKBvMcgKQ8TNWIkbRwkfiYs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759444076; a=rsa-sha256;
	cv=none;
	b=mUV2rhshQ79CgKa3wMilY8AIGNGoDnCAymarLC1jXRib+9joO8/aeD9nhBXKs120jRGfUU
	xeEzqTXpb5K1jrk0EehQAYZ8G7OG7pEnzcnbiedQba5wRxUGJAeg0kTWm5uM3ty9NePoV4
	vYUeYPh8UuZlz8fC+7rn4iYzmGz8iBU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JJCpfBAo;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77EDA491FD;
	Thu,  2 Oct 2025 22:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23C9C4CEF4;
	Thu,  2 Oct 2025 22:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759444074;
	bh=FAQx29UJAqdlcYne9qiTsc80FK6EHP3tnr0RF1bSC2c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JJCpfBAoihBUJ9RPqt+9zxTJPXbYrb/r8zj8A/F2DkAJ9NpG2w7ROqjVPDbZxabzG
	 uCM3fkpFeVhmNra06S7KH4Y4Jr9XFdIjos6NAHGJHrP4jBx5ZQGmMyzxP+4onV1sJ+
	 BhpIKf382kot/jenn0jumv5/okezR09L8daGIUmA=
Date: Thu, 2 Oct 2025 15:27:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
Message-Id: <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
In-Reply-To: <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
References: <202510030449.VfSaAjvd-lkp@intel.com>
	<20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
	<CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ydbc71mnta6ihtgmq89k17kee3n7qedy
X-Rspam-User: 
X-Rspamd-Queue-Id: 16E9B8000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1759444075-650424
X-HE-Meta: U2FsdGVkX19vX0lCOwCBX5x7oM4GYe2VTgWVS5fpHGtriwHwLyzji+ZCcMrNtLKGjP5zL2A/fPZnEykP1hK/MQ7Oslmc9zOk+WVYhYR5+RrcUEQ3vh7+b0Qbuk7TU2w2LmK7XIqK4u1EsHlP4F016We1e1Wow3efHi1kFYhqCXGWHVNhe7E/9Y3jTRscOWms+KoWFKdkjs0CBtD+9MExtplbpkqMZFNzyFwvLDkocuxm0KltfRhyscfNOMiQpiSJ6w1jAYx2FSoDVAunYe1ZbHuKjj5pvZv/F4/zkRiIgTMhvXr8tIMs6fBI9qrmECeOsBA8CvKnd8hrASOdpnagThDq5R/AsCV64BKw30uW+o915zH81Tw3PNBNglHjQAR+Wll8phetxkh/XYMnMQ5NCHHR6srM5Kd9Jc5rxiSCPCzep3RSUqAV9TKDjrzd8PB86sVYYQoDdMBIXr1fCs8ChftqQjFI2mCerr82CDLiiCTRzZ0Shzh6L07P2VoetwAs8Y1B7RJybPbC/NUCvikpjoXsCJEx77B2LD6Sfy1ZZwMFxn6MfarRCZXd8Rx03/CqlozBy1CSBmgxP19tDLwHZoXVB1jHFGmqJ+yRA75LVkrMQ2LHOK+f/fOBI5my/IZ2I+zvSRfBq5DiYMfLWW13uUlpgO1iUlaQM3gwh0NehgC/U34Rk/itED3YAl7ITmodOKF9Nh5jAPsDr5p8PysFcuWkZagxzJe04J0cu+LODMT4heMizq//SxvqvXa9AEN3HytRJAgWuRpLUr88pIVQ255j8Ho8zYQN0OFQzYCTyvo4I1UnUrsxYPG2DLKgqda/A4B/F7G4X8ng9FUZPiPK/I33EndU2ORvfFwYfcLRZTuupNnUx8m2jK0WT2VIDoqj9KzXG+kEzvqpc5lz+hb260YIXB9sDhObzpokS97AuPW7Heai88q3vedaJWNf+R7JPdpO622HftVF2bIx1F4
 WVB8dBc5
 xCJzuFgXm1Ro6n1WoAsK5nUgMFiyfwpuwctx1mk3I2uOAZLWAwCo3a1PbUjhYiI1sJLxMSon+nZdLMXsNs4f10toQNdMvaXgDR6w5N2zSqhFspnND/cO0IGDQDVipDdrERcFfPtzElv4grfwEReswGg+e/AZyzhv3nlEW2izdVYjMTjF333gMFejeg2orJmffJ0/c1yU0+USfl4ZiFhGwIiI7tpuFu8Odwnty/bkbgkBrGdh9CE1eL/cRVNkZVeklhnw+hdXmijaunxFstajPSG5GochdsZ+Vf9OcJ1QB5FPzbuepEAZyuFAqTc43UhVITWmNWC028G5R8tusL2rYCEmG7TL0PauqVz2uo1D7llDAGHJ90s+Gp/GVxu7AC7Bcrn3XvCDAwVe1b6ue4sNym4EJs+SPbtLWQObhYdx4crdhtSPJssAAvbXUGNAGv7fPsJX8p4pDxHDJ6Io7ELGCGCMmp1Ctl3wSRRSz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Oct 2025 23:42:59 +0200 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:

> On Thu, Oct 2, 2025 at 11:19 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > No idea.  Let me cc rust-for-linux.
> >
> > It's a one-line patch:
> >
> > --- a/include/linux/mm.h~mm-ksm-fix-flag-dropping-behavior-in-ksm_madvise
> > +++ a/include/linux/mm.h
> > @@ -296,7 +296,7 @@ extern unsigned int kobjsize(const void
> >  #define VM_MIXEDMAP    0x10000000      /* Can contain "struct page" and pure PFN pages */
> >  #define VM_HUGEPAGE    0x20000000      /* MADV_HUGEPAGE marked this vma */
> >  #define VM_NOHUGEPAGE  0x40000000      /* MADV_NOHUGEPAGE marked this vma */
> > -#define VM_MERGEABLE   0x80000000      /* KSM may merge identical pages */
> > +#define VM_MERGEABLE   BIT(31)         /* KSM may merge identical pages */
> >
> >  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
> >  #define VM_HIGH_ARCH_BIT_0     32      /* bit only usable on 64-bit architectures */
> 
> Yeah, non-trivial macros confuse `bindgen`.
> 
> For the moment, you can do e.g. [1].
> 
> Other times, we have changed `#define`s into `enum`s -- that also works.
> 
> ...
>
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -106,3 +106,5 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT = XA_PRESENT;
> 
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC = XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 = XA_FLAGS_ALLOC1;
> +
> +const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE = VM_MERGEABLE;

Sorry, this is rather annoying.  Rust is breaking the build for a very
simple patch.  Many developers aren't rust-enabled and probably aren't
even able to test a fix - my attempt to get a rust build setup working
didn't end happily.

Jakub's patch fixes a kernel crash and needs to be merged into mainline
and -stable reasonably soon.  But that is now blocked until someone who
knows how to fix this error and how to test it gets down and does those
things.

Jakub's patch is present in current linux-next.  Can someone please
send us a fix?

