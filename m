Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C08D3E783
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 23:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C1D6B0006; Wed, 10 Dec 2025 18:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DE26B0007; Wed, 10 Dec 2025 18:39:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E653E6B0008; Wed, 10 Dec 2025 18:39:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D22DB6B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 18:39:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B9EC1A0541
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:39:10 +0000 (UTC)
X-FDA: 84205179660.17.A185685
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7AB9140007
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:39:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fDJ+qI+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765409948; a=rsa-sha256;
	cv=none;
	b=M5C+cMEOvud1ARoZ2F2FehXWDtbTRnHPZC7YPJqikyNmr6iB5A/CRn0vfTXxWdOSO0fAhM
	KpTbWNqpTcfOJXuZDrTah6VFFO6mo1hUkMRwKS7m6SsVl5jUUaF40bsGVjha3ZmwkuKFCU
	+wIhNvvkAvkV7qv9XK41BfZlIexlARQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fDJ+qI+H;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765409948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=E7Xv5HcglnCTC1Tr1nd33fSvSACmcKuFz1SrniB+dBs=;
	b=gM/x0/OA4bXdSKsIsZl7Hputor17d42/wSKC2bKitqoMk4oprg0DOPYvy669SBL5JD0Rxc
	3zyNl8boEe2M1ZeobZs94nig0t+BN0G2XLHkF5rYXgeLwI85ccFS2vbCKp9+lWTO6reF9u
	60alMbGxaouIbuDf08RB7DNl1EDOG5s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765409947; x=1796945947;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=zkO0pZKAlhPJJKawaGoprcHejdVZs09dRM1SrVJ/MP0=;
  b=fDJ+qI+HHAKgmRs4wHoldW9Am8a1GN5oDGFAXVJFydKk/EVXFVD/GaMV
   yQO71m/1R+kyCDoZFjtpOfjI8sA5sXhT685hKyeKG/tx/vCbLkTbOOObl
   5esPUWjIeB1fLxKpT+TE6rF2293sKLKkFL+1dialxqIjNBFMOFG5cizLu
   vcjEITVzeSJ0LKmy1UhG6Y9mLFvznFlBn28asAOJp9O8GZf/j3mfHv3ZG
   o5R3kwcZuDgsHPStIORNBwaT3rORktjb07zuEyzrl0snZmqHvFn9ruVjG
   oTtv+UaVMiYQ2F3EJPjlyoKcLcqJmVySZ8SP2DFrBOsZVUt9sB+cTeRSO
   w==;
X-CSE-ConnectionGUID: cd+EBDe/QliRcTPwGWHwWg==
X-CSE-MsgGUID: /zMiyNQ7SeKHf5+nT2gfpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="69975595"
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="69975595"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 15:39:06 -0800
X-CSE-ConnectionGUID: bfsQFZOhQJuod1OeOhJLxg==
X-CSE-MsgGUID: KzEwnuQdTiqXD7Mj5FbZ7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,265,1758610800"; 
   d="scan'208";a="196930357"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 10 Dec 2025 15:39:04 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTTlu-000000003sL-0yTk;
	Wed, 10 Dec 2025 23:39:02 +0000
Date: Thu, 11 Dec 2025 07:38:14 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: net/ipv6/seg6.c:430:24: sparse: sparse: incorrect type in assignment
 (different address spaces)
Message-ID: <202512110721.RFqufwXf-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7AB9140007
X-Stat-Signature: n17oyejmchrjrng3981qx7y9p9y6rrw8
X-Rspam-User: 
X-HE-Tag: 1765409947-68190
X-HE-Meta: U2FsdGVkX18hZoLH8PosOvxAQwin6gvSWiwwgaSw0qEuKvvezKy4suOh06obtLiFx/WZNZVzqpsFF2siFDtNEN7AjV2jc5mjMneGZ6dJKt0w1tlnaEBsVuaoAaK9DvVPM7GzMpmJkhz37WUi3Zdh2nA/lrrHOyqRQWcZxiKHYjunGXiD6JXefPyxBroVEMPdd3mwL3YvBL0HxUCbM9ed07vx3vpmEfqJeFMeFvmRlggwM//hB5XSBE3kF7NShM/Tc9EUZAKAnANTU17Tq0N+87xICl+80UFtTmpyh1FMQaCPqe0QqzHSrY2bVyhcJxsHlJmx9mKQh01OkcQfHhgQ5pUHfn1ql33Zcdb4c2cV6UWzkMMkqaT/2kGGoRsJGMz7DKzZ++78LzwsjJbb/ChOoo/9qAs0WccjtnaRofzYPB6eoEKuxy1zpsJcG3HBItvYG5RDLOd6qDkHD1MiOzbMBXcNlDWmhzBfHavYUokQJNW5m2cNkug213fW09lRSMe771YckOHXRW/aczlqj3xOKyBrmREBOLSH80uV2cGbCmQ6ob8KqGsALP5TMSih5JGpeYEXjkMhnf8aiXnD/TSQmla23y55aiGicti4cFG5LMeeunfVSvncW10fKVU3cNOs6pJVsPLWfJw0Yk8yRmgWBfyHz9ujomNKPICL6WGQ6FyfIxbXPlB7i0qkxwj8fPcoGSWrRPYXf1FDNjSKJfk7KCJqeFPaijbNkunmHOO6B31cFZTT9ggQDHr6MGXpJTtSHFuuC/VFKTDZ0ccuHHK39Xp8quKmbKsSjCxBlSn+Ly9WhqG8IRSBa5gnQ/g0UryiKkVR82XlcGIIr5cNlKCjM1dgRluLE2F5zoGSpYRGbfyTnCPFOUzHMR3EK/Hn3TCKU11CHk6SVx4bKzoeW6RcmL0xaZuMr3F6k0R0o6/rzH+1FQnqdG6PxE53Vr51A1eVPbluUKSE0PDYd4REovV
 kG0kXYoB
 9A8r2I064n0EkGgaioJpkILs4NtW2vWOtjasyuEdMl40Po7cFcSRQSTBPo0AdRC6ozgk0UzKa0YlG1dPzIEU6/cKyEcUuvYsQ7j/c2Ol1QldNvs2DcwedN09giZlgsDENDrwaEykvDYOnAS0thSukMwkQ3Y4201EQ7xUSSRlz9LQMxzdCoo15wtGIyUf5Y6kUwi3deSKbRqeoKg7NkW6BdQjEzwJYizI1IvlfST6Uuvw5pGVsS5mGrCUAOTjMZ5zQtUekp5NRv/VHap+oUhlYdZqFBlwojeQvhnkT92JS41N1PQdcCZ8ZnLc40Z0lUiiAdtAEFToAneLts4UDTErvK+MmDcPRy+NuNsEDysXMNuX5PBLASIT7m2FQ6Gyax0QuzK01MLAqmvc90hF++aB4EoisDKX8fgOZKTtPpp2IjhY56FU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   0048fbb4011ec55c32d3148b2cda56433f273375
commit: 07438779313caafe52ac1a1a6958d735a5938988 alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
date:   11 months ago
config: i386-randconfig-063-20251211 (https://download.01.org/0day-ci/archive/20251211/202512110721.RFqufwXf-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251211/202512110721.RFqufwXf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512110721.RFqufwXf-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/ipv6/seg6.c:252:15: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct in6_addr *t_old @@     got struct in6_addr [noderef] __rcu *tun_src @@
   net/ipv6/seg6.c:252:15: sparse:     expected struct in6_addr *t_old
   net/ipv6/seg6.c:252:15: sparse:     got struct in6_addr [noderef] __rcu *tun_src
>> net/ipv6/seg6.c:430:24: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected struct in6_addr [noderef] __rcu *tun_src @@     got void *[assigned] _res @@
   net/ipv6/seg6.c:430:24: sparse:     expected struct in6_addr [noderef] __rcu *tun_src
   net/ipv6/seg6.c:430:24: sparse:     got void *[assigned] _res

vim +430 net/ipv6/seg6.c

4f4853dc1c9c19 David Lebrun 2016-11-08  419  
915d7e5e5930b4 David Lebrun 2016-11-08  420  static int __net_init seg6_net_init(struct net *net)
915d7e5e5930b4 David Lebrun 2016-11-08  421  {
915d7e5e5930b4 David Lebrun 2016-11-08  422  	struct seg6_pernet_data *sdata;
915d7e5e5930b4 David Lebrun 2016-11-08  423  
915d7e5e5930b4 David Lebrun 2016-11-08  424  	sdata = kzalloc(sizeof(*sdata), GFP_KERNEL);
915d7e5e5930b4 David Lebrun 2016-11-08  425  	if (!sdata)
915d7e5e5930b4 David Lebrun 2016-11-08  426  		return -ENOMEM;
915d7e5e5930b4 David Lebrun 2016-11-08  427  
915d7e5e5930b4 David Lebrun 2016-11-08  428  	mutex_init(&sdata->lock);
915d7e5e5930b4 David Lebrun 2016-11-08  429  
915d7e5e5930b4 David Lebrun 2016-11-08 @430  	sdata->tun_src = kzalloc(sizeof(*sdata->tun_src), GFP_KERNEL);
915d7e5e5930b4 David Lebrun 2016-11-08  431  	if (!sdata->tun_src) {
915d7e5e5930b4 David Lebrun 2016-11-08  432  		kfree(sdata);
915d7e5e5930b4 David Lebrun 2016-11-08  433  		return -ENOMEM;
915d7e5e5930b4 David Lebrun 2016-11-08  434  	}
915d7e5e5930b4 David Lebrun 2016-11-08  435  
915d7e5e5930b4 David Lebrun 2016-11-08  436  	net->ipv6.seg6_data = sdata;
915d7e5e5930b4 David Lebrun 2016-11-08  437  
f04ed7d277e842 MichelleJin  2021-09-27  438  	if (seg6_hmac_net_init(net)) {
f04ed7d277e842 MichelleJin  2021-09-27  439  		kfree(rcu_dereference_raw(sdata->tun_src));
23b08260481ca5 MichelleJin  2021-10-02  440  		kfree(sdata);
f04ed7d277e842 MichelleJin  2021-09-27  441  		return -ENOMEM;
acaea0d5a63406 Zhang Mingyu 2021-11-03  442  	}
4f4853dc1c9c19 David Lebrun 2016-11-08  443  
915d7e5e5930b4 David Lebrun 2016-11-08  444  	return 0;
915d7e5e5930b4 David Lebrun 2016-11-08  445  }
915d7e5e5930b4 David Lebrun 2016-11-08  446  

:::::: The code at line 430 was first introduced by commit
:::::: 915d7e5e5930b4f01d0971d93b9b25ed17d221aa ipv6: sr: add code base for control plane support of SR-IPv6

:::::: TO: David Lebrun <david.lebrun@uclouvain.be>
:::::: CC: David S. Miller <davem@davemloft.net>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

