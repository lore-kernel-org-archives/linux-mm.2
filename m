Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AECC5D2069A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05D116B0030; Thu,  4 Dec 2025 08:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035586B0031; Thu,  4 Dec 2025 08:57:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3836B0062; Thu,  4 Dec 2025 08:57:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCCB16B0030
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:57:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DE4B91401B6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:57:26 +0000 (UTC)
X-FDA: 84181940892.18.55FD875
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB8BC140014
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:57:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BZ/slsWW";
	spf=pass (imf23.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764856645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60z/geyFr3iyPIcOdTYFrnP2HLi0uj0xFDSeRjMgiwU=;
	b=MyI/Ozy9eI+wVICH7xcOe8TwrZOgKEjISup9Z0WZ4BZ5GIhjglIetmA83dwRCclqKMYpXA
	j1z5RwvYCLZhmKydSIx3qW4IJTVedbrsBBsBldit9kvWhIB54cNmoZbTZc2OWqIc59rizU
	tMxohz2Zok91eAw+VyDEmdxe5D1LXgE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="BZ/slsWW";
	spf=pass (imf23.hostedemail.com: domain of feng.tang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=feng.tang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764856645; a=rsa-sha256;
	cv=none;
	b=2knW8MZI/jVn7eRCdz3mv9bHcS9KR+hwzWOuTx08vE5jATVkeeaRIv5uLZd1ExyGy4pqwZ
	L6SYhL1s/h+AMAEr/s1S/2o+1ywUQz2F5jFIH0dPYGn0BVWT1s5F8olHzmMZ4VAmWGFom1
	KcqefFvO8PFcZ9S48V+VdajEWIo09q0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764856638; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=60z/geyFr3iyPIcOdTYFrnP2HLi0uj0xFDSeRjMgiwU=;
	b=BZ/slsWWVOvmY4j9p0FKKmQETRFFUKFxfuoiayoWPTrvNe5wNWKkVqh7PpLXyIvn/+INjeegXDTqxREIfRHR+sjwsFBrpkxgVokaKcNasRfXO3BI9rj8EoJ8mcWerZU+8s6DKqb0pGf/BrXYtJI3mFTwkVUL5vbV5d8YidmBUQw=
Received: from localhost(mailfrom:feng.tang@linux.alibaba.com fp:SMTPD_---0Wu4Zmgb_1764856636 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Dec 2025 21:57:17 +0800
Date: Thu, 4 Dec 2025 21:57:14 +0800
From: Feng Tang <feng.tang@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [linux-next:master 9966/13055] kernel/watchdog.c:74:22: warning:
 unused variable 'hardlockup_si_mask'
Message-ID: <aTGTOi5creA4v3AK@U-2FWC9VHC-2323.local>
References: <202512030920.NFKtekA7-lkp@intel.com>
 <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251203144453.be34d189c5e6668ce2da06b3@linux-foundation.org>
X-Rspamd-Queue-Id: DB8BC140014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gxwyiqrk9c6seg63ms3wozjygkemmkhy
X-HE-Tag: 1764856643-756845
X-HE-Meta: U2FsdGVkX19JUgeymnDziGnHmheWF4MXNQfUoCly9YU/SvwxnaCphW7Z4mkxstdtnuAo2/SWvvwCrobXogNN4poVwJKCaoPkq4I2DH1BY7F3h1KAS6R7ix6GYfCT0+13TgWQjgzPAAFD8HgCEClysVnkwBbZkWwjM9SGEqjdunJKYtCZeKBfFWR+uWN4MB07yY6xlvRzek3mfLfsfwuD6mgUIr401YG9o5UQspxm1ZhS8sJqmjpaWlOJbcXQIncGQnwR0mFd3LI6sWfTEC18xc7vuKVnzWuN0styGUhal9T+GIv9t1lYA4qdv8pWWTuHy7W+J+CuUwgsFZlZmof2AFNrzcSb0V1s8kUJ3JsDRE8uz5Bqk32Er/WJKt+04tr9s1t/9WFTfKvlChsgrmxgtHiiBSIoXh4c6lDDz7H7oJeS5WAX41wpnY356U7dxSDjr3CP94thcinsWXNQo/WPqJpvGU7LfeQ2wy4WXkDmdM3Ut/ndTF4WVNoje6BELthpve1EI1AcpMfJdfUJJbPQsSza7qIa+LLpA+X63OMASj1iELRbSM8X49ykktMT4p20Hpwna96aH7lQqSQjhYpj52bVyXmvZ4NQjp4sG+KzTjZvpYTZ+1Vy3GpwXRFQPksOS/WNJ4wqhiietOjneYFEh6SqGpIJn1NVlJDzXksQTu+3tUyatqVj2pB3MdfJ3CC7jOUqWcdWLS3L5CgNzN0ni7FVwCYMBCSFkd5NCWAoHM0tnhkn5GTdYBRz0UJoDzjluXfxeuQwAdl7zrVR/Hx63zxypXFa0/hroAMo/kRNDIVyUyS/BJMELsNjWA1EwcnCvh+Laij8kTLFslsHzEy9Ys7kDJgTjsRLVk9RZLbxYYjVFv3EZUYnkapI/EfEYnslgSHv2WOPtlMWYoAvOurvt98RDkTtqiEZa0Y/GfWb+QLyXwgQIj/9pKyh7ZAeaZ53P8GdK3L7hAoUE0YkB5N
 ARK2yvNG
 dGnFF7B9wmzqJ+Gh2pcXJljwKgUKMAkk7duO/vYLbsM/kvYmF4H4opa8yULTrzDqXdeDjmQt8LTyWn09sgpiMbwfIlOCz9BeZU3qF9fMBcG+60FRFZHfiIC6cAHl0q1BYboVs3APfA/9G2qGvKSYekgzl9pB8/j1GW/9K8LORmsS8uYJIkCa3a+vJWokaKCVSvrTu8AcBfvCtNhpTmdUmxg/b7ETWFPqbmiJYSj9dQFV+FbJyQLDCTXVUZ7hK3CsV+A0NUxoFmJAys5E2FcimLu5fBjXLPodogTvWJXX+VYzR/Oumklol5BPoq0bXq9TZvrh0HlnkjOB0WU/8GMelMFmroyQIfMAfxC35Fx88R23QZzDwMF+8PrlVZilg53WLooXGspWmOQepRJZfv8kl4W8eoaxlitzMYrziKLpf95cTqCg3DSLo9eeM5uHv4FWzqdB2R2rTEH3enSrSx15YegGT/5dkDmtrVi1jjOmhX3/sPpo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 02:44:53PM -0800, Andrew Morton wrote:
> On Wed, 3 Dec 2025 09:05:30 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > head:   47b7b5e32bb7264b51b89186043e1ada4090b558
> > commit: a9af76a78760717361cccc884dc649e30db61c8b [9966/13055] watchdog: add sys_info sysctls to dump sys info on system lockup
> > config: powerpc64-randconfig-002-20251203 (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/config)
> > compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 734a912d0f025559fcf76bde9aaaeb0383c1625a)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512030920.NFKtekA7-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202512030920.NFKtekA7-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> > >> kernel/watchdog.c:74:22: warning: unused variable 'hardlockup_si_mask' [-Wunused-variable]
> >       74 | static unsigned long hardlockup_si_mask;
> >          |                      ^~~~~~~~~~~~~~~~~~
> >    1 warning generated.
> 
> I'm testing the appended patch but it needs checking please.
> 
> The comment for hardlockup_si_mask says
> 
>  * bitmask to control what kinds of system info to be printed when
>  * hard lockup is detected, it could be task, memory, lock etc.
>  * Refer include/linux/sys_info.h for detailed bit definition.
> 
> but the variable depends on "COUNTS_HRTIMER".  The comment doesn't
> mention hrtimers and I don't see why it should.  Not sure what's going
> on here.

Yes, it is a little weird. Logically the 'hardlockup_si_mask' should be
under the CONFIG_HARDLOCKUP_DETECTOR, which is what my original patch did.

I did a quick check, and there are 3 types of hardlockup detector:

	 HARDLOCKUP_DETECTOR_PERF
	 HARDLOCKUP_DETECTOR_BUDDY
	 HARDLOCKUP_DETECTOR_ARCH

IIUC, most archs will use the first 2 types, which will both select
HARDLOCKUP_DETECTOR_COUNTS_HRTIMER (lib/Kconfig.debug), which is kind of
a _proxy_ to select SOFTLOCKUP_DETECTOR which needs hrtimer for its
implementations.

And only very few arch may chose the 3rd architecture specific implementation,
which was in 0day bot's kernel config.

In arch/powerpc/Kconfig
	select HAVE_HARDLOCKUP_DETECTOR_ARCH	if PPC_BOOK3S_64 && SMP
	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI

In short, for most cases the hrtimer is used for soft/hard lockup detector.

Thanks,
Feng





