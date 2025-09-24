Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4135BCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB798E000B; Wed, 24 Sep 2025 05:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655678E0001; Wed, 24 Sep 2025 05:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D0E8E000B; Wed, 24 Sep 2025 05:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37DF08E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:29:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5479C0475
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:29:15 +0000 (UTC)
X-FDA: 83923620270.19.2A64CB9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id ECC74A001F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:29:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ALGIDVXY;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NQxhHDKJBxc1HbO7bdi2pKWv6xqO3AMW4eLlFgQFTOw=;
	b=xoM+ZuNYnfUp40IpMHdqYdNMUjkVbXVWql1MNTiq2RbXUP+1t5uKHNVNL/X2dBiuwG6oBT
	lvzjytnQU2wc6H2Vo1ye4EgR2RRkWRkA4EUxu+uXG3s7l6C1nm+LaFdxU7rMnKa2YI+cdy
	XXW4QyaQDWiYmTDS3TUXoHmoHykbp3M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ALGIDVXY;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706153; a=rsa-sha256;
	cv=none;
	b=s+tRP/GvfVtdvgyUWz6/n5iD4yj7YJqatVaBM+w3bTJMTDOpluibLtmRhx/SRuL0WbrNuq
	J/FhVPzMHAKqsPurud8Ap39JIspDvmUI/3YMCECVjXn9C+7KHz1Ug2RoA8dLkGUkoBD9nz
	sDpnanbTl7bctESrgmexLB7tI2pu36E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758706153; x=1790242153;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yMSkQplP3rHZaWo2oMDZguxX9qzRed9Ka3XpCLi17Ng=;
  b=ALGIDVXYf9G1GVMEIcCBBiF/L/zD0VOLb//g/lN1fnjna/InvszGt2f0
   OuFZyxTkL3lhJXvbS4IVpKeLvMovPgch4LicwzP/geXST/ihyDp9ypxIR
   omdF8bIV3iN33gbfJ0z80Wl48wzdtPF5kWOm6sLPaX80IaYQuBvdVROll
   aIShP5pL4SQmvbsnkfbgEU6bE6+gAMzFwzf7K7wjsoP119hKMWsNLp8sm
   CpLAacAc9KwxK+qLUslAActaWx6nqUVYUujvbMmK0wzsoj9TpVfnPV+Bf
   FggoMw/JJLbYZKRmVmJDN45bO/xfLrbUbQUqT82XSyQAeqdmiBzsPzTWx
   w==;
X-CSE-ConnectionGUID: o1CIC61PR6qqxI1QS1Awjg==
X-CSE-MsgGUID: NxugcwUnSB+7oIrzSEtr7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60702501"
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="60702501"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 02:29:12 -0700
X-CSE-ConnectionGUID: AoNF+o4URPO9+pRaHhaaHQ==
X-CSE-MsgGUID: /rwmqYRdQFCX2ffO479rtw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="182159717"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 24 Sep 2025 02:29:04 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1Lo5-000409-2y;
	Wed, 24 Sep 2025 09:29:01 +0000
Date: Wed, 24 Sep 2025 17:28:49 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for
 parse_xy()
Message-ID: <202509241655.GL49TRF9-lkp@intel.com>
References: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919145750.3448393-9-ethan.w.s.graham@gmail.com>
X-Stat-Signature: 6b85jigdrd8i4ebmimk8eogdubpn6cna
X-Rspam-User: 
X-Rspamd-Queue-Id: ECC74A001F
X-Rspamd-Server: rspam04
X-HE-Tag: 1758706152-600483
X-HE-Meta: U2FsdGVkX1/hF6roD3mKBcxhPD5RH8XqVoRd3iyH0Y8j+GQVIh4yjmf6P3fijofxnAUEcew8CudHb7o4cqx6nmHnR42QT/TUHsnYQHO1BQ8q3wdm+TOMuIHkBahDr7fzKgaSl8OyA64f+1ED6+oUJyd6YTgkG53M2slLy9tsZ/c3u55E5mf72R/TKi8/aY3v6JP3YBx7IZHCplmLIctYoGs98T4NZO+a8/zuZZ/vM1rn8t7q9C6qPqRpJl3wBj27JpIcuJ8Tze+6ea3waS3FXdC4b7hPzOLFAUIFbWHnwkLM4zq3QQr36i+83T0/t1UK+MrG+0gtEUq7uF3fVeLVjtAgZmMVas0XgbhBwdphVIjT/WXXKcsIhmUhlDaqQZYMiRwBXR/C8tG7Ql2lPIQXYjANYRG4CK42phX1frefAji2y6hIwWdtjHe14B8Ywom/EcS7B4asZHusAWRjrs3lFjo8unseFT89EQhxjpbKgbTfXHD8RcA1LWQ2w1HTpw8MIWVxiCcZJMtZgyUPRg5GOp/ug97Kt+etlOiSgb1rVrb3wQTS3TagGY7JXzip8rpC0Hp2xU4qwafJ7RAr3u2DPznchok/4NvZ/FjMlaLm0azp390fYAy5QtJrpRQznoQv7Ks0TCz229XB6NKI7YrkgZ77Gl10cIpn/lES9uCRv7Ml/8SGkvpr8mfTeEvpq4i/4x+fa3+/iPGLUG+PHzlm/7nBhDfxRqWplC5isnia9DZGVUn5/P04/92foCzOJbOtWdq077EfonckVV55vi2TUhuayaHQsms78P6gg3IPREgmQJKdKUI/y9pDWNVs6E1pDRe2NQXTvN4Ah6RIxSk0p5/SQkevaR8Gi3Ns5K1I7gpFR0ZCkGMVQIdSAbYzQqafcvfudcVsrXNbAel5xnI4Okrdob58Cut8CDjea5LDqwZKSxZCZp3fUCpH76FOIYvStCIcip1xy7m5xWWaq65
 cap9fgkO
 s0EWg4McaaUFEfA9Rza3i4w6/PLyjIAl6Y+bffL8ly2BZEG5cnv5woB2w7lbIstp3RlfYe8715/hxQdB/goB4n4s7hyM8fGkWuyq7rn0RU2Au1F7r39Hji5a76LjXhoJROMiZVAgoeAN2noF0FWFo2ilN0l3A30YRHlRaStXnqPQix+xWq5hURWXl7pZ+fvVtRVCdGcE/ittaNTKvJDFiAJ8APbdpZK+b7M2MBqwVmdkevDiTFwXQvLdYqCGUY3nSd7dfmtJLlvZdNCKuPHwSrJtyQb83GP9yxKn5/axTcDKP+TG0FvoARmJm6j67CP+ikQEOvcTFQc7ZnKDSHuY08Uxt3RCRTsUxTDS2tld36m24LUk7CxASj+UYMUjyOqwamAjBVl6uunvE9RE7B/bpOk3/YUPbM2enWVbJm/9iFzfook/c9tqJHs6caSUJl34hsNQ5fV6PuHxo/xjdjrxDsNZmMvMeF5EbzS06BW5jCAdhNeG0lzuHUNqleA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc7 next-20250923]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250919-225911
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250919145750.3448393-9-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
config: x86_64-randconfig-008-20250924 (https://download.01.org/0day-ci/archive/20250924/202509241655.GL49TRF9-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250924/202509241655.GL49TRF9-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509241655.GL49TRF9-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kfuzztest_parse_and_relocate" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "record_invocation" [drivers/auxdisplay/charlcd.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

