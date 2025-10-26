Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B73CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 04:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BCE8E015D; Sun, 26 Oct 2025 00:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C998E0150; Sun, 26 Oct 2025 00:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132AF8E015D; Sun, 26 Oct 2025 00:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F34ED8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:51:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 86FE4C025E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:51:39 +0000 (UTC)
X-FDA: 84039042318.28.1F5020C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id F404D40005
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:51:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jISZLSQS;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761454298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3n+pNbQ3ZBkgKWwhcjEgBnjkuULYV9gEIE5B8VZdZf4=;
	b=btjBElm/KWSntKa6NSB2vBAXhexz5BJjwN61jd6fk22oVeMmCaPn46tcDYFFjjwGHX3Xos
	22Sdd5jkdz1A9vxYpSjBoeBnoxciS4rk1oxaly0UVt0PWc6E2MUH6spG4MPYMunq3jQ72Y
	umwR90VUVpOmVWPq6IHPQJiXDBCF3xM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761454298; a=rsa-sha256;
	cv=none;
	b=n090vzoMXQtQ9X+FleXzl7ai6jCAKcHqlUb0SDmFlaG2bBAeRJyQeoQxwOMUBlvkWjcPsW
	Lbej9ZO/h5c+wKA4IiUDodNPRvqucZWj2kPWSQAODDzli05PBawtkOJ3eQAa4iaGxlR+HB
	rJj0ciuyahquHMr1vy3kGQsTrcnxx5o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jISZLSQS;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22C6260194;
	Sun, 26 Oct 2025 04:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A5BC4CEE7;
	Sun, 26 Oct 2025 04:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761454296;
	bh=jPmY9EuaikqLfsyh48vPZOJpqI2dti5YZlMz2+bkIUI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jISZLSQSCwqRaR+wnHgDJfumz4BjQrB1NVVE9UVd662AW6j84/NyVOSq/QzRUQ7if
	 MIzUZIOcoTBOFJ3B4XmuRDhok10sFz4JALbtCNiDwXB6Z03ERRA3+AArGfKfaz9+i7
	 7K7fGGVYo/chdbr/Q9nk8lQvmIRhenVha5M6vmew=
Date: Sat, 25 Oct 2025 21:51:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Douglas Anderson <dianders@chromium.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 40/49] ld.lld: error: undefined
 symbol: hw_nmi_get_sample_period
Message-Id: <20251025215135.d947785ef3edcb7b725cfcf2@linux-foundation.org>
In-Reply-To: <202510240701.eB6r97V3-lkp@intel.com>
References: <202510240701.eB6r97V3-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F404D40005
X-Rspamd-Server: rspam02
X-Stat-Signature: 3ntyyrdz5a4hmsnww548psq6z8bqhwa8
X-HE-Tag: 1761454297-443766
X-HE-Meta: U2FsdGVkX196vgBolfZif271chlgmDAZnBix9BsjTfBHjC5yx6hjfctP2M9MEZUAgvSTD8nOWBhUD1YJ6heyBuB9Heb0ehEP2d2lJKkEuq2lzXBHSWgJwcwkWtIuyGatiZ4aXqNbcBA8WMQmlGxHLoRmFqn052cJQKIVj8bpV+T5NqOImi3zMJjzZquFM5K7M/U/lEpDjPJeJYanEV58id6+w3QXooAj0LV+cH4pIGiV3XTDHH2X66ti6IGmByl83aizmj/0l/iu8V+kXXIFj3ejNHNgoj/OjmdydNO+qxegHSXsmO/7V6ntVAZ5nvYCmZadb4C6m5H7PqAQx8Ew28geMvewmBmYNIO5UMgIv/oskYsAnAO/a75+FL/fMFd4WXTTEWjtZ4YivHKIIIQJirUuhwiKvgIlkcM7vro7PFGWoAoAI72zwSvOfyoEzNO7PxzeI2UZ8tAc5oBSgSGvi6QiA/HZdmmwFmxRyfKDSiPfQ6Ewza/UaoLct9OD69R+V2IkMhqUN5SpAyTZ35Dd8w2NMhlZo7X1JPr1ZLzVdTLus8O9sYYjdRH0OzQwrk0F8mGc7uDwArpgApdZyVRSUsu4TThp/M0vOKipAVAE7rxHz33OhOpFAv2pTbrfjhvpom23/ldAWDTwpBFnEuqSJ+IrKIiMl5loIJ05a+M/9D4O6YubqZoz3q8o8sm+Q1XmaMP/lrC6eq4AJYjCYYd1WSGWWHIlo/9Tu9kXiTbaRhvf1XD24ON94VuzxIPCtqMka/Owo43/VJ/fILsiDF5SD9aJRNFD8hVnnhbeLpBRLeTyDZfwfnD8RCIdU1MT4a1vTBReUX8KG4hGorwUJpZx6E+kx6ET6V0eIYJAzj3baN6AT7FgoOuChmGnQ9uV15Nj6rlDtYtZ7PAcZs8jTYWrfILWVFeynqqPgfDqJDx/wd/uBHHFsrV0gIJhWCSNmycLEr97YbMbg55YKpfuGfU
 sdC2PtyO
 ZhXnypBOU46rZwPRBF5KMTI+aDTk7t9EGjsMrGwzfe4Fj5NtGjQHimoLDD0NrGSh+ZXzhrl9MrcgjnxC7OZSRYzs6fmigw1mA3AZpapLSutAsZxrqbWuFCirc1e6kH6DInYqFdROEFXyvZiVJeAqmrZqJPoZctOKPry+ervROBg3mHsdo/oIh4NHKvORJlQNq9eHEK8o13gOwyHW7c19CPnl+rhyT/ngQApxhVYFXuKivi7gEHPAnhUaSKu1dGt/LvvUHHGuOrLoctdoxV9lw4kLYICYcVz+LsXAK8P+4Pm3s5vFqxHRn71UrYB2Jgsms3fHA0TwG1PgLM8d/gKpcAUMDXiAnnpwkYFPWkN1z4j5eJE5xWXB5Gxufx5K81UaUir+0fHykNBr3cT6qQfvx/9YX81HWPtuXvVGDs4N2++Fmw7Ni+g7O6hKYPnAwK65p7wdFZyj6WFIF8+k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 07:44:47 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> head:   b0165d26ed76a1d8825e54ddc5c0b62db5113f13
> commit: 5ec1304ad3434337b407db8e6e3bf6e2964c045f [40/49] watchdog: move arm64 watchdog_hld into common code
> config: arm64-randconfig-002-20251024 (https://download.01.org/0day-ci/archive/20251024/202510240701.eB6r97V3-lkp@intel.com/config)

CONFIG_WATCHDOG_PERF_ADJUST_PERIOD isn't set.

> compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251024/202510240701.eB6r97V3-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510240701.eB6r97V3-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> ld.lld: error: undefined symbol: hw_nmi_get_sample_period
>    >>> referenced by watchdog_perf.c
>    >>>               kernel/watchdog_perf.o:(hardlockup_detector_event_create) in archive vmlinux.a
>    >>> referenced by watchdog_perf.c
>    >>>               kernel/watchdog_perf.o:(hardlockup_detector_event_create) in archive vmlinux.a

Thanks, I'll remove this version of the series from mm.git.

