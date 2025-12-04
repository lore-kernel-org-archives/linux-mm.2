Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB334D206A8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C886B0092; Thu,  4 Dec 2025 09:12:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FCEB6B0093; Thu,  4 Dec 2025 09:12:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33A006B0095; Thu,  4 Dec 2025 09:12:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 229386B0092
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:12:47 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BD47131600
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:12:44 +0000 (UTC)
X-FDA: 84181979448.26.65E9399
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf17.hostedemail.com (Postfix) with ESMTP id 12A4140016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:12:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c3eRuugH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857562; a=rsa-sha256;
	cv=none;
	b=LChF9gu4aZa52p7Jw28R0zrMJ74+46Eucob4CmklfDHwiKWfvzVVRHdx60upe7cZfSpTz7
	sQJnIPeE+Kps3GseHW+BuA3nJJJG9Ux4N0JIHx62R9o2G0F2XcaQ3QeswxaqQcCC7szM3m
	8wLi2dYzd0Lc5DGGAfqmaYPTHXRE/vU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c3eRuugH;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dkYSy/gbe5jT4GPBC3gX5tdFW8sy5n6ioyBwECgSNdo=;
	b=Nt+X4lGJr5bx1xKrViUdSjcMxsfvppJq+AGoDEhz0vWoDN/h166Fz6B/OTXHLz5j1peAkG
	GvIB0i47V7GkVM4IJB4H9ypdPsmpyZaIwp8c0ER15L1/R3w8NycwPUi0Xw1scpYZUtGNmf
	4E7rdFgQ7QPkBq1Cm3UzT9nBs/fG4YQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764857556; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=dkYSy/gbe5jT4GPBC3gX5tdFW8sy5n6ioyBwECgSNdo=;
	b=c3eRuugHgBxaK8JmyAk36M6Y4GPQ3D+2QCA2SzUG7h/xt+YNCrHZE8ECTIaT7p3NEGN/QjYfXtX6LxWzgCD13U98ea7V1ZSZ54jS7EejzBpVncp1jWG9OIxY8e5ZvBTmByIaI/L6ZgMdlhOpT2a2p+m87n2S934mLzLSLdt0FFo=
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0Wu4cLfq_1764857555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Dec 2025 22:12:35 +0800
Date: Thu, 4 Dec 2025 22:12:32 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [linux-next:master 9966/13055] kernel/watchdog.c:74:22: warning:
 unused variable 'hardlockup_si_mask'
Message-ID: <aTGW0AQJfQPKe0ao@U-2FWC9VHC-2323.local>
References: <202512030920.NFKtekA7-lkp@intel.com>
 <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
 <aTGO4iLrQnd4l6fO@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aTGO4iLrQnd4l6fO@pathway.suse.cz>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12A4140016
X-Stat-Signature: jcduownir3pbxks646jopmay9cj3m9ab
X-Rspam-User: 
X-HE-Tag: 1764857560-590871
X-HE-Meta: U2FsdGVkX18WjMXE+V9xDfm9nkcIWOYf2T97iXfmwWeBPKgOAiSQrBDj1c0b9EMCSjL7PjRIhoD2aeJFPmgt9xTDYrEjX15Kffhv6hVVtZyMEq64CuY3iIw+DLDt/eu19yb1C81xC+iWUH9ggW/Q+3AxWhiYfiuLxGdgxBCCl1/P+YifnAFC1zI5ZLFjM1nokIN9Lcfh+9cCjw1RBdIf1AaK5oh5zNbz7B5NyWCpsDNgmdu5Ev9gMbn4uS0v6zXGtbFtsC/a4QD1ao9+9ICnj1fcCN/IscNCI5re1GARZJxmAUgX5lDMuEYCSbZFTvFu5HhwsBrnS5ZmFcMQI/L3f4hfmuBFzE9zPwFzNI4Imq71EFkfpRdIEKv02saZhZ99b0X0cppiFBO6BIzgPkaLKWQV/RJ2dUQESwWteNXmZAbmwwItP+bKACxb2g/wJ15qmbETZq26azMa1jZ6mtX2aAyDXQUR7IIYIS6UsOq30sDAg87mQOBECvGO+fSW1CTUBlYkmvEFI8cTocUd7kAH57RtU0IWbPYApsNQ/tA0fhTp4eCM1dlP89pEgwUDoR1alvjaL6kzG+i2l4gwSOI8VXKavs0gYTNgfDDYhJBai/YUJP4/GMdVE20sU/IGs6hVKiHKrdJ6CESn+fHs/5jKYI5kzSZFB2eNINH61Dt3aePhSOcTwtSXHuyymEkT7tOlnbKS3w9fo+YuHN9rzDX2JIvphasFMNyMjj2b0JqMJdzNFEJaO8SwLiJ+iWOA52n0+FgksTtmSPcE+WEEV0p5UUepfv4FofWLMwgtvWJxsFjYFdGD4rjNjL3YhNQmmyYM8cDvWIWMs4NEeRM7OeoRd+QlkKX2SbEtxwugxDXryzBWLByld4taLvYhPS7KRZVdKXqBvZTFmei3YkImkrpV1qhayv3UPf05lHO2P2kRgZ/BgkGSYo1CL/RyFw6bEu0xmJ50cpNHnnV/TiFPQgB
 9eY/FuU2
 o9/ouECnyDIGCD2WeSbQwrfiAsyAHAKMDHoGvqMWax6beDIK1phneRfMVlb/ug4XEcpoRjhSDacaDp38LTHavHZHCPXCaubztoiNbrvB6spO5i3k9nSvEQ6v8ZBY3MWbLx4BSXK4yF6lIo+36bBwj2q8s2KbwwqYYPtGMD+3KTOT3YTehP4DeTKyJl+HQvLmUiB612vfHx1rZWtTCChKh6lTm3Ob/9gtN65tF5eYXtbgldTLJh0xYv1e0oPhZJEqlDjW6xyeaBFY07x7+HK5sylCa3XrRxR4PnnAu2pH6dzG78qSv5gN8rI7HAtRJ8sMkKpwZ1+LO6jMSE0yVWQyWtOpVG7TuClrsOQoQYJNQJ4Wt/+Y+khO1i0PhM0JbzfrmOKu8urz89WOEp5oDs2ucEt31BybaFvjzHmwxuB8C0sYTvgCUHMONP6Jq+5PGCMX5PUKE9tuPJufNlaiX9Tali+6/hrUfOtCkwX5Y59zwICJvRaw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 02:38:42PM +0100, Petr Mladek wrote:
> On Wed 2025-12-03 14:44:53, Andrew Morton wrote:
> > On Wed, 3 Dec 2025 09:05:30 +0800 kernel test robot <lkp@intel.com> wrote:
> > 
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > > head:   47b7b5e32bb7264b51b89186043e1ada4090b558
> > > commit: a9af76a78760717361cccc884dc649e30db61c8b [9966/13055] watchdog: add sys_info sysctls to dump sys info on system lockup
> > > config: powerpc64-randconfig-002-20251203 (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config)
> > > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 734a912d0f025559fcf76bde9aaaeb0383c1625a)
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/reproduce)
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
> > > 
> > > All warnings (new ones prefixed by >>):
> > > 
> > > >> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
> > >       74 | static unsigned long hardlockup_si_mask;
> > >          |                      ^~~~~~~~~~~~~~~~~~
> > >    1 warning generated.
> > 
> > I'm testing the appended patch but it needs checking please.
> > 
> > The comment for hardlockup_si_mask says
> > 
> >  * bitmask to control what kinds of system info to be printed when
> >  * hard lockup is detected, it could be task, memory, lock etc.
> >  * Refer include/linux/sys_info.h for detailed bit definition.
> > 
> > but the variable depends on "COUNTS_HRTIMER".  The comment doesn't
> > mention hrtimers and I don't see why it should.  Not sure what's going
> > on here.
> 
> Good point! It took me some time to understand it.
> 
> So, powerpc implements its own watchog, see arch/powerpc/kernel/watchdog.c.
> The watchdog is supported only by some powerpc platforms, see the
>    following line in arch/powerpc/Kconfig:
> 
> 	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if PPC_BOOK3S_64 && SMP
> 
> As a result, the test system could have the following in the config,
> see https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config
> 
> 	CONFIG_HARDLOCKUP_DETECTOR=y
> 	# CONFIG_HARDLOCKUP_DETECTOR_PERF is not set
> 	# CONFIG_HARDLOCKUP_DETECTOR_BUDDY is not set
> 	CONFIG_HARDLOCKUP_DETECTOR_ARCH=y
> 
> And "COUNTS_HRTIMER" is not defined.

Thanks for the check!

Was working on a reply at the same time :)

> > @@ -1250,6 +1250,7 @@ static const struct ctl_table watchdog_s
> >  		.extra1		= SYSCTL_ZERO,
> >  		.extra2		= SYSCTL_ONE,
> >  	},
> > +#if defined(CONFIG_HARDLOCKUP_DETECTOR_COUNTS_HRTIMER)
> >  	{
> >  		.procname	= "hardlockup_sys_info",
> >  		.data		= &hardlockup_si_mask,
> > @@ -1257,6 +1258,7 @@ static const struct ctl_table watchdog_s
> >  		.mode		= 0644,
> >  		.proc_handler	= sysctl_sys_info_handler,
> >  	},
> > +#endif
> >  #ifdef CONFIG_SMP
> >  	{
> >  		.procname	= "hardlockup_all_cpu_backtrace",
> > _
> 
> This patch makes some sense because the arch-specific watchdog does
> not support the sys_info interface. And it is better than nothing.
> definitely.
> 
> A better solution would be export the variable and handle it
> in arch/powerpc/kernel/watchdog.c.

Yep!

> It seems that powerpc is the only architecture which could define
> HAVE_HARDLOCKUP_DETECTOR_ARCH.
> 
> Feng, would you have time to look at it?

Sure.

Thanks,
Feng

