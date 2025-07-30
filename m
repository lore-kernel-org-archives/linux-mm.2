Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C880C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 03:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA676B0088; Tue, 29 Jul 2025 23:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B206B0089; Tue, 29 Jul 2025 23:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0C26B008A; Tue, 29 Jul 2025 23:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D61A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 23:37:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FC821DA170
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:37:28 +0000 (UTC)
X-FDA: 83719520976.27.DADB44C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf18.hostedemail.com (Postfix) with ESMTP id 34E1C1C0011
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 03:37:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dT0qXdHD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753846646; a=rsa-sha256;
	cv=none;
	b=TB/47ViByuo/oS6ehWps0f9JSYevW2+nNlyKDjD208ESRzTAq1rZf41WEyag5riw56AaMQ
	bVNhDVR3ksfj0KkZIgPBo/1utg4rFM+pEWCc3v6EtLLwqPRtXg7N52xb9gGOV1wdnL0zhX
	ETqGEdmVlOh/Y4lfugN6fFes1uaLK+w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dT0qXdHD;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753846646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr4BLJFJx7qvKKs257AqFW2YZaqfSdsv5b8ugL4qXKw=;
	b=6Z56fXUe6sODkmQ7QkyMjDsk1SVXyzno15jSldQgq9PjBaboWbbXTt7c7pZuv7ESsz1teo
	mhqGEROln7Kdq9h55lyjf+86KhURZNyb+lVkFCeDJjX7Bu7EUT/7hcWpYtdSkd/AcmoCo5
	Eg4+7dg80L7QGjGzLA/M2M57Dd38dRs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753846645; x=1785382645;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tErcFQmELNFkZAm+D7dIZT/EMgu6fqy/433QwaB7TmE=;
  b=dT0qXdHDWno7IMifKCXmMF0GWtg2JpuCIAsPmUiuz6YZsmmEy1oToc+Z
   RYaWv9NnB4s2p5eYtRM/0zz8s61s5xedSOpBuroW+/KPqjrMZpvbFJNwu
   BMvxffGGA/vDz7nlqRyAMS2e8xN9Mcwb0Thgnl4rdykiaRvUapA0VfaFe
   ahoFfBuraEtYtMsyQPXiKjrYY2cjlI0aD8ZmHxUSowKxSbUt8tb0nTrwd
   D84PV5aY3YkSGMaMONjgm7eBoaqOIEzEeGGjzIp+8K8nB+azQy5FYQ2HE
   /Z/ie/tBWijiKWqxCbiY6BJGHHC/Q5N0DW5NGHbfT5gR18EehMBq3yskq
   g==;
X-CSE-ConnectionGUID: SFDZq+pcSNiAWJ1xzkq1nQ==
X-CSE-MsgGUID: +6Gm7gaDQ9yyG5W4hkWbCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11506"; a="59962348"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="59962348"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2025 20:37:23 -0700
X-CSE-ConnectionGUID: O4ZFxuSxRRmvq+dwbILU7Q==
X-CSE-MsgGUID: bvmVB8HMQx6T0R2kOy7R4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="167051793"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 29 Jul 2025 20:37:22 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ugxd1-0001xw-0J;
	Wed, 30 Jul 2025 03:37:19 +0000
Date: Wed, 30 Jul 2025 11:36:22 +0800
From: kernel test robot <lkp@intel.com>
To: Zhang Qilong <zhangqilong3@huawei.com>, arnd@arndb.de,
	gregkh@linuxfoundation.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com,
	zhangqilong3@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
Message-ID: <202507301149.ILLCBOyz-lkp@intel.com>
References: <20250729134942.900517-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250729134942.900517-1-zhangqilong3@huawei.com>
X-Stat-Signature: c9u3aekfwatf48yascogfdufmgubia7e
X-Rspam-User: 
X-Rspamd-Queue-Id: 34E1C1C0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1753846644-984219
X-HE-Meta: U2FsdGVkX18P4hHforZNUORvEi7YKtMbDXJ6cEcqiFxQ143xoQhK1jT5Ph/vhQvan7vBSlNPHNGrh+o2Tcrul5w6mCLAhcsyWtgWw9eI8v0VXrhJgHUDS4gDgnTkWCpwkcGrCRvSoFkSoyjrnCvsCOa434Zk4Vw/Ba9flQOOE86jjo44yUGq8m+oSay8ezf3WYFOKbxgbEyYgxVZRA7BWKUu3Z3JXhh5RVr6z+NrrBgwni8tfI7tzlw4Lw4BHTylIYhmEEN5QQOO6/zoqAD4/gPnVU6L/JVmhdz4X1PWiQI9LlF/W7YxEfLmcnzgnqx7X9ziGycIbkQojC0Hkd7N/YgBzcZxJYyPDDbmI3q2BEs+rxL9dP2A4PM2TgBzm79b5f4xlboBLgitdoecKyjyR8ZSRAMQJb4TItI/Nonq8R2JmicTShJS1el9/Ze33C4AXqlI9t61FQElEAPo1QBSGtES+94wJH5iVmt3kMMKup35pRIk98Qa3TGrDIaNeM+XIiJf+YhWFCcSkHAzTpQqjCDSKTQR7t5+v1T5JR9MtdTdRnamk48yFBLBAqqcckQY18V9BwcW6a8slznfuV0tqenuTBorE8obUQbcvwL/Kyhczh+IH8i7H/9jyx+bnTl5jxZcCdKQlubwJnCouNq8P7qtJS4jTKT2G3FR6d3j5F0g4MQDm2H2zIH5LMmh5XCeUsPn4rjLLP4D2CmTgBikYob/ZdyZUsa/TDgf2WnVeLuKNTPZWkJQbBpVIWwPXzUJSS9xLWfCiAO1ae1Ie3lTbLfgw+rl+pcElB9dKYJikluuV5J4WZaTd0aMhUOl3GN8XJef8RY1Oe7+KswFJCEvIUmsyH1eHiakqLPgiwPEVe/Vg0noFUBjx8ln1pSEHkGZ2RFTDUUGttw86NkGvjd80ZWf6kBpelDlb5Te64grmqkh2hRTv517idjmgqSp6RbsnJdxHd6fo7MAjZik/pG
 wBK/o9XF
 ngjm/gYeW9A0b0Ou2hv2mqMrJ8OZk/l5jB/kUDUdI01cqy/AxwL7uabwhK5yMqUNnMy3pBX4zPO17LpwlZQ7/7uLd8RpCgCCRZerR7OKO65tUjpJ47MTZVYPJeM+uybf9CkjoIW0yd2wfBhI941g4KTxl5XnvKRIbJCrAr8+qgvWDgd6UoBRPDO3K10SYfzzJ8U/oumC6D/FtlvQH+pnn3gdgbnZ7QU+cAab3dCeiF+ARVFcZLxlkycyp3WsU1FkniuDlxrWXss8XZz0sas4NsyOB3JBHyf7PqYy7P6ltJV/9Ok6Kl7XS/UKYTbOIyP+AD4eKttN9XtU1m1eTkhqF1HO2IzynqhEesLrXpJ/7QOBXxhPjWvTN2uBnbgpiCWKn79+3S3HlS5DkegCgk9JleptIufEXYQbFX08zDHro0nkcEJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zhang,

kernel test robot noticed the following build errors:

[auto build test ERROR on char-misc/char-misc-testing]
[also build test ERROR on char-misc/char-misc-next char-misc/char-misc-linus soc/for-next linus/master v6.16 next-20250729]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zhang-Qilong/dev-zero-try-to-align-PMD_SIZE-for-private-mapping/20250729-215253
base:   char-misc/char-misc-testing
patch link:    https://lore.kernel.org/r/20250729134942.900517-1-zhangqilong3%40huawei.com
patch subject: [PATCH] /dev/zero: try to align PMD_SIZE for private mapping
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20250730/202507301149.ILLCBOyz-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250730/202507301149.ILLCBOyz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507301149.ILLCBOyz-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/uapi/linux/posix_types.h:5,
                    from include/uapi/linux/types.h:14,
                    from include/linux/types.h:6,
                    from include/linux/kasan-checks.h:5,
                    from include/asm-generic/rwonce.h:26,
                    from arch/alpha/include/asm/rwonce.h:33,
                    from include/linux/compiler.h:390,
                    from include/linux/export.h:5,
                    from include/linux/linkage.h:7,
                    from arch/alpha/include/asm/bug.h:5,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:6,
                    from drivers/char/mem.c:12:
   drivers/char/mem.c: In function 'get_unmapped_area_zero':
>> include/linux/stddef.h:8:14: error: called object is not a function or function pointer
       8 | #define NULL ((void *)0)
         |              ^
   include/linux/huge_mm.h:536:33: note: in expansion of macro 'NULL'
     536 | #define thp_get_unmapped_area   NULL
         |                                 ^~~~
   drivers/char/mem.c:533:15: note: in expansion of macro 'thp_get_unmapped_area'
     533 |         ret = thp_get_unmapped_area(file, addr, len, pgoff, flags);
         |               ^~~~~~~~~~~~~~~~~~~~~


vim +8 include/linux/stddef.h

^1da177e4c3f41 Linus Torvalds   2005-04-16  6  
^1da177e4c3f41 Linus Torvalds   2005-04-16  7  #undef NULL
^1da177e4c3f41 Linus Torvalds   2005-04-16 @8  #define NULL ((void *)0)
6e218287432472 Richard Knutsson 2006-09-30  9  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

