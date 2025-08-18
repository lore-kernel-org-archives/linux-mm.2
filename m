Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB42CA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 00:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2FB6B0099; Sun, 17 Aug 2025 20:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96CCB6B009B; Sun, 17 Aug 2025 20:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8347B6B009C; Sun, 17 Aug 2025 20:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1F96B0099
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 20:14:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5A5CC0731
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:14:38 +0000 (UTC)
X-FDA: 83787957036.30.051B68E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD8DF180005
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:14:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ID6HqLMD;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755476076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJghPZDANcUiW5wXtsrqlleYuYJUnUmNG7Z7BobLTXA=;
	b=BuV/rgjSk1LQiiecMtvEpLIbgcw00wyubxVo877jQM54GohR6+PFe0QdTHeoUMRAnT2Gbw
	bY/931Y/sTHk6O10Z3t+QBarFQlTO6ZfhkgUTzMW2rcZzDBalZU1TsBq+Z5yubH9gXFndq
	mJ/R6TYrn4XdsER1E0KDpHcjH4yCdMg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755476077; a=rsa-sha256;
	cv=none;
	b=onBDwq/Px6lmBDaf2ClW//bFp3ms3Cj1SW5FpZ80uCrxw+WZzFOMQzMKOS1+t580sna4A6
	zTvHEmocPECsufVbUG072hS1oLFt4MpOgHfkK0gNaqO9UThyKodRN9O8PL1Ial+H+OygPA
	4Wj9clmNdmVWveg9tZqShYQD/00YW5o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ID6HqLMD;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755476076; x=1787012076;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cXw8V/2WdskHtmRrZ40s0eLq9HPcJIsdXKFvs+zG3Fs=;
  b=ID6HqLMD2aQKjHNvw4e5VnNH58jsKHGajbrqXlvy/tY6DDyUhl6I4zjo
   5daraYblBRQhQnrQFXjhzmJIlLpoWw7gomg+uxpCcRt+yLk9O5Q/bgXtX
   hZWy3ORuRlYconsXR9L8w3gkHOEOXjjq6POmk22EGS9ZVpKV4JBHhHoG4
   Ydri4weu5UGOQgG9O/avOqOlg1bI8rEJoX8Rys520aMBh1TZ5MwQtraOS
   GpbLCiQ5ey6i+8PnqU5C5TcovnZzkbmuT8b5xN3DqJ1HNdBnpHsrJUKH3
   0QdfBInv1Z73zlzWwGVb3tnzJaE1mERC9YwCYCJaNZiHChk7gc6abuDH5
   w==;
X-CSE-ConnectionGUID: 6D08i7s6QbKhcXJH1tAJLQ==
X-CSE-MsgGUID: rVvWZ+EOTaCVa7UAoC5pOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="68409222"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="68409222"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2025 17:14:34 -0700
X-CSE-ConnectionGUID: rPkKLnjSQ5CNumytd/zTcA==
X-CSE-MsgGUID: Yli3IW/hTpGQPtHWPRWhLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="168250450"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 17 Aug 2025 17:14:28 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unnW6-000DnH-1M;
	Mon, 18 Aug 2025 00:14:26 +0000
Date: Mon, 18 Aug 2025 08:13:56 +0800
From: kernel test robot <lkp@intel.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, ryabinin.a.a@gmail.com,
	glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org,
	scott@os.amperecomputing.com, jhubbard@nvidia.com,
	pankaj.gupta@amd.com, leitao@debian.org, kaleshsingh@google.com,
	maz@kernel.org, broonie@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com,
	yang@os.amperecomputing.com
Cc: oe-kbuild-all@lists.linux.dev, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, Yeoreum Yun <yeoreum.yun@arm.com>
Subject: Re: [PATCH v3 1/2] kasan/hw-tags: introduce kasan.write_only option
Message-ID: <202508180747.PxkbPnyA-lkp@intel.com>
References: <20250816110018.4055617-2-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816110018.4055617-2-yeoreum.yun@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD8DF180005
X-Stat-Signature: wcmgx34zr7k1sadgn3jgx8zgwqeu4jeq
X-HE-Tag: 1755476076-426880
X-HE-Meta: U2FsdGVkX1+oYaL6mkYJdR+M/AFYoVQjVorad3CXNMNjLkck/SKSSVIFzLZk7lMbcOzk46FNLw5+gA8+9DryL0b8ADhytYMFufjdwjm/O/sw4SbX6Rhm1MkR23GyEbxTKbIk7qwgkNI58SwZxLfrFAXCr85DfZSDpXjh1lP7Tne3D/IMPyCxQg51fq8I5XPnLV7hWx6l1NWh8CB+xD6nOFeQj+ojspPQahKO+RNMHBH5aERRF3aUx5IJn7FxeYpOqNsRwr2YUZXLUxTpitXRKwbd15rwNsUEdiJ4ml37hzid61HAMwEiJxUpRHuZl1xde+NCMzZlQAVAyGsYk/i8/bHaRtdahzXldVZfetgayNmI8uXtSBPLjbV2zAGPecP53j/Lo4LF9kNEQMQRjJb1l1GAdQ1mDC/Eqz2/ehBjQP6TOpGsAV9Ez0NzM9L20B0j+0a9BMOEnu+RA6voFytpBEFb4TiumimfYl7LnLNszY3qZtit5HLJ3J84twHqT8+1/bAYUmgSDnyHJbUlJGXh9Qb5kIeMZJWdHH55wAUQdqiLpltTxkXAJS/C/50XDm4c/ZzAmI/REvDrl31o7Kpld6CvmXu09kCR7ZA/wbJJFXtmxZQd4ZeIPiEhAtggP2Ci4TZC7geTsKdCm91MzXLnVfjdJlk+P8Dhuz35TiTS79h1Js/aRWVSUhVDcM2lPLcxYBWzZpetpx38HG7Lrj4NLRp1xN7w98B6q0I0B3TeXS4osCrfBiNwlNNkS6mmXEe39GUGbRcX03KYdMP4IAQC+PMqtyf65WscIGw33HcwlcW0GO3YK+i2dJuh3eP1oKsKas0vUXkFTAF0HNCDwpMFF/Jsx0ija4XJm0cpJ2MEjdBFqKpemk58JF/OqUocusy235ZCSnFTVi+g+C+ucZrm43ZJllJkXSV/qQe4yi6VBrdrvEN6LQ6HynlmI0Dh0t7ultE7bC4Gi3rxZp66lvN
 NJ9PZd/p
 16GCcWyWTcAtegVo6cxu4k7RDs1gIz4Yw9l9hxPc47K1j05D5piOw8zadl4f8hmMKAmMzS5alH+aBW9mwMWMfIl6rtbmm8nC+ngDfl/J/YCOKw0AZMulUJ5pCEhzOYSCofdUa8Pzg3RHoyeNY0KYc2qELrPMZxx1KZCQPyo4zNNLCFnSTkBoK6Xm0sX5iGdGXgP2xyj3n1dXIiyj3Ji4YuySEspl69/FZe++uFMgps/bd8RembtHiBFfWzVAV3uJg70Lk71iMJIf/M6UXRfY2q1lJDckRgO+vqrCiUsh5Q6ZpX2ZdGbeqIGRH/hFxVYHdF9HKoZMNBchFjfXFo2TQtvmRiH3SuEsBxUiUc2Yz98TocGOMYzlbCIs07y70DLeSlP1mfRdiLwgWWKsxBNZ4Z7DGDwuaR5KH+JFUiyoG/B321bqGQ28/r/JKB5lGpROkMeA1vqumQaIJyV8CBtW71eIxfVjtycp5Kc1WW0AU/7V3NSTK6LbLYO/l9VCBYNIG+sFZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yeoreum,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8f5ae30d69d7543eee0d70083daf4de8fe15d585]

url:    https://github.com/intel-lab-lkp/linux/commits/Yeoreum-Yun/kasan-hw-tags-introduce-kasan-write_only-option/20250816-190300
base:   8f5ae30d69d7543eee0d70083daf4de8fe15d585
patch link:    https://lore.kernel.org/r/20250816110018.4055617-2-yeoreum.yun%40arm.com
patch subject: [PATCH v3 1/2] kasan/hw-tags: introduce kasan.write_only option
config: arm64-randconfig-r053-20250818 (https://download.01.org/0day-ci/archive/20250818/202508180747.PxkbPnyA-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250818/202508180747.PxkbPnyA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508180747.PxkbPnyA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/kasan/hw_tags.c: In function 'kasan_enable_hw_tags':
>> mm/kasan/hw_tags.c:433:21: warning: comparison between 'enum kasan_arg_mode' and 'enum kasan_arg_write_only' [-Wenum-compare]
     433 |  if (kasan_arg_mode == KASAN_ARG_WRITE_ONLY_ON &&
         |                     ^~
   mm/kasan/hw_tags.c:435:18: warning: comparison between 'enum kasan_arg_mode' and 'enum kasan_arg_write_only' [-Wenum-compare]
     435 |   kasan_arg_mode == KASAN_ARG_WRITE_ONLY_OFF;
         |                  ^~
>> mm/kasan/hw_tags.c:435:18: warning: statement with no effect [-Wunused-value]
     435 |   kasan_arg_mode == KASAN_ARG_WRITE_ONLY_OFF;
         |   ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +433 mm/kasan/hw_tags.c

   423	
   424	void kasan_enable_hw_tags(void)
   425	{
   426		if (kasan_arg_mode == KASAN_ARG_MODE_ASYNC)
   427			hw_enable_tag_checks_async();
   428		else if (kasan_arg_mode == KASAN_ARG_MODE_ASYMM)
   429			hw_enable_tag_checks_asymm();
   430		else
   431			hw_enable_tag_checks_sync();
   432	
 > 433		if (kasan_arg_mode == KASAN_ARG_WRITE_ONLY_ON &&
   434		    hw_enable_tag_checks_write_only()) {
 > 435			kasan_arg_mode == KASAN_ARG_WRITE_ONLY_OFF;
   436			kasan_flag_write_only = false;
   437			pr_warn_once("System doesn't support write-only option. Disable it\n");
   438		}
   439	}
   440	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

