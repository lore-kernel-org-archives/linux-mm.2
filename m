Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8DFEB7ECD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E3C6B0088; Wed,  4 Mar 2026 06:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FBF6B0089; Wed,  4 Mar 2026 06:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E5F6B008A; Wed,  4 Mar 2026 06:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74B366B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:29:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1EFDC1A8A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:29:47 +0000 (UTC)
X-FDA: 84508160814.18.0278C05
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5E3618000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:29:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QJOgUloG;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772623786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0ff5Q5o/AqIXQDWdJ4GWxhTWxG+EI6xH7Q5CCFT9DzE=;
	b=EriUAakbCy47j1kDScYBf+5Kl1VGCthDL2KV4Rfh1Vi2dHWbx3DSl9HkWUtz5aFdkxNteL
	IW/AUF1DXClPu1mSaRAzGtJYyONBY+fWBJtmncNVKOftdQAkowzbKjZk00ERLGYf8DE1f7
	EL9H7Qrgq0KuiEClzL//XLZUaEgx3fQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QJOgUloG;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772623786; a=rsa-sha256;
	cv=none;
	b=ZkgLkO2mqiJA5EdGMfOP7sLgnmp3dN7B+cQjVCeZXN04DRlRXgIwUCsLvC8T0FA653XrKv
	ADnqS3don6fQAkf4jyuZdlxBhPOv2e9HD3TWpforYjQ5+7dm+ASZI/cEFgZIMoz85AB8mh
	Q6PWR2shp/GTX+O772LZTrJNiMkwH6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772623785; x=1804159785;
  h=date:from:to:cc:subject:message-id;
  bh=1TQlMpU6hmoK4qwk6KP9PeW6GPyus3gxEyfT0uObLtE=;
  b=QJOgUloGwv6hlOh3JpqEhHJ4qhWX6CP6k5WzlAste+RwwljfMzJ90/gP
   CYB7wV3iKi8Gci5mR26g9Fn1X3BWKhSL8AYZ0XjwkvJ3r/5kyiQ1WY7pX
   VFBPl8TrXlA/iJ53OHWdGvSNwnWOWZ5ZbAV8xBGsj11oTRdiA+aN9E3hA
   F9coJiHZYD0wtuXJ152fI71zP9ZoxqzuVIhEpUtHlYvYsRefnpVWF9ZvN
   y3yi/tI+dsVXAWMS2CDDltY0x1R5MabFf6MmUaXvfd60JXBtufP+R9b6U
   gF5V5Pp4eINgtHVZ+HJ9OU+8CsbW/2dUvfl8/1k0BQycYWXWQI6nDIJeT
   Q==;
X-CSE-ConnectionGUID: ymkZ1CAKRfG3r5jF+f3jzA==
X-CSE-MsgGUID: 0uk8+b0FTl2QZhRFOYdWRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="99153585"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="99153585"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 03:29:42 -0800
X-CSE-ConnectionGUID: I3thCLj0QM6k4dS9fOjy3w==
X-CSE-MsgGUID: gfqTVne3RFGWv6vIfO9PcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218265265"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Mar 2026 03:29:39 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxkQ4-000000003ez-1rm0;
	Wed, 04 Mar 2026 11:29:36 +0000
Date: Wed, 04 Mar 2026 19:29:09 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [akpm-mm:mm-nonmm-unstable 49/110]
 __efistub_cmdline.c:undefined reference to `__efistub___lshrdi3'
Message-ID: <202603041925.KLKqpK6N-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 5E3618000D
X-Stat-Signature: bz9jm474urfy5564pn9zjejhc86q8nr7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772623784-46403
X-HE-Meta: U2FsdGVkX18YWczvHBmhNix0l4Gh+p8Ki/ikGCIZHGlC8wn/lykK3AXj0sJTdu0lP6R9IQTyvo8D/gsF7p20Bl+Ws4hitg9z1YSvi9vihqCyw/njyM0/Vx2ZDchKjgMnWZdtUiO8yQO/S0V0z7U5WX5WJnBDYojOfZm3sJm6mIN+oSXn2IjJ3MJiK77F06jw04RkcxtVr5lUsFGevd4ZSqNPyyoXA9Qu+3eiYPHTdDIfqDTVkgcBZIH8mwGoA91KwLgOAYKeTkRsZ1NGW53GZs3B9tdxtFo/fO3QKRvwqM4ZzBpFz1NCvjgdbBztDO+lNnogFH5cV4a0qJa1JEgwzXVWr+FfDNYO3MAns0X3APke+0QrhBxI/TmY54+hUgmSoxaYXzNXNhIgDB0cJEoRVAV5fdb2UykM1chlfxSUhfP3tR5kK9ZjOqDFkGTfMJLMv1dl+V8cR29QFsE1Ojh/x658v0N0uxirKwPdjJXlhQUG4EezGPRk+mG5zSPtiF58G4ncQ/mLlQB4K2FyXefZ6hJoI4b+F5Bci+oBhTflTz6eNIKXkR9dL1piU2RZdqQrwt/SdhwNpgGCUfKH1UZSzSAva8B3deSThby+tqS4tzXxNfRKW7hzKNDTpEA5lvTtSlQqBPo21vlwj39jAJTlc0C+Ne0vVEKrz9pApGbGtaHAEng63TbEb0iMv9FpoPXZxIN1QXRV/U0XI8pLWaApgZagW3LW61PU7rHfvq6WUqQGbPNcWiTTwNkbMq3Rs8HM97NfUqNkP6+fAiFzE5LfO3I5erQ51S71zVfNwSKCQc+qSADGKoRoOeWSXe5h1JnfeGvNvaECAs4fgBquOM868wjos6589EpRzAq615Oh5tuiTbA4jcNVu9CRISbvDaspgE58XjOVtX/Q/do2PFZXOmGMiMGxwHbIQIvk6W5TKtYL6EGtEr7YJpWNdSSKtF16vgPc4uq2MtJucMmPdLQ
 f/RAvJQz
 q3nD9TiYSka9VqtTvJQ2o8OwnQOBXZzxORXvgIhc+FqCU7NqtPUvwF1P8fjGmWq0pPQHpvbLkGoASPvigQtNGOPpX2xXXCw12MLV6FiYTLSEDN2TBFLid/NLst6prpw9WnqVrsqyKn6nUKhrBYVyIFEh2x62ga9wx1az2uoo6/YLJvPurMKwjTIIWhwB11Z98ENyrlRtUCIcv9XLAhL98df7qMxO+cH3RmNyX56/G/Exz4yLJiUc+puRjyPyV/cW9oyAdFe7KVZ62yVRkNSQQ//c+NsqHJpUpM/+d3y4ze/SAqMwuP5iNSVQrMHLwSb8A/n6yHaJxmGIJY9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   09c4ad73ba08ac959a6afb5e019826743837e0aa
commit: 7c5bff091374a7980431237af80e6da21dce74fe [49/110] lib: fix memparse() to handle overflow
config: riscv-randconfig-001-20260304 (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260304/202603041925.KLKqpK6N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603041925.KLKqpK6N-lkp@intel.com/

All errors (new ones prefixed by >>):

   riscv32-linux-ld: drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `__efistub_.L38':
>> __efistub_cmdline.c:(.init.text+0x1d4): undefined reference to `__efistub___lshrdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

