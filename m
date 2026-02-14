Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DD4EF99FF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 06:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3336B0088; Sat, 14 Feb 2026 01:30:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D396B008A; Sat, 14 Feb 2026 01:30:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94FEF6B008C; Sat, 14 Feb 2026 01:30:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8444E6B0088
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 01:30:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F645ACC6
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:30:19 +0000 (UTC)
X-FDA: 84442087758.23.2603F17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id 103D1C0013
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 06:30:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JcX1SJd6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771050617; a=rsa-sha256;
	cv=none;
	b=IuE9K5RuRDP3GV9U7PKH1Lchb0vntgjxJgAbZxJEk5TVY+jvPyXuHLDvVAgq6xWooGtuBw
	wJDWPpEt4RTR4TOVZCFZWZqCbTR9o76qHpcGF4QmXLQdJiZvbt3KgKH8oy2JvVc9TgaD04
	cjT6wEdZtAsg/GbpQhrxG9H6gjoBPAw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JcX1SJd6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771050617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lfR0unjZ8N9r9rINJr6Ti5BatzjL+jvRT24ms4mwf0k=;
	b=o2LS4pZcigepLcZ8lsFY4b9CAnyLKWp5E+4JbpdAO4sOyCnLSKS0H+sQqDOOdH3INC/ouS
	3BdXG2iIycUb2Mjzbq50X6GEnuP4FqXG3KTzYmARvc4EfXBs/2tf2zK/cuBJ9EF4g7pzZn
	/kTJTlXp3dYdEvaePWLeX9Y6JlhXU9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771050617; x=1802586617;
  h=date:from:to:cc:subject:message-id;
  bh=T/ftUp8knjm7J69TVB17Dj8uJCdl6TMjx2dr/PQ1PyQ=;
  b=JcX1SJd6sM7+wmuaGrbXCw1BqD6YrNIwJTOrorUqzJEJukvUT1b8S5Vt
   JSYxDGEmHDvDsdC6BDWYYHdgOhfeE84zpf8m89W/fgCu7umPElP0YnvuO
   lzAuV0MU6tWYXDXkxA67UMGdMH9gWxavacvQtSOteTum1iW09M9vH0+pS
   WQx+s1pIdJCS3rr+Lri0KCiI8KpLHhVAvYkSI6zQdGfII+eD6K6w1SLJy
   vEC9KVXZ4c7hJg8hQnyA8d3fIkx2b584CRAmIoYCDaVlTqRHtb+M1DmEz
   vOg3Pzn6huOywvgNzCc/Md9mlxs5D8qI9/GRYr7MEKl3/QLW/ZlAkbj+X
   w==;
X-CSE-ConnectionGUID: fucrb3nxSRy3zFi4Ira7Fw==
X-CSE-MsgGUID: hCyaZq32SSG5VH41GnLMNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11700"; a="74825444"
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="74825444"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2026 22:30:15 -0800
X-CSE-ConnectionGUID: rgcOrSP2QlCqDHB3Xh09EQ==
X-CSE-MsgGUID: UwaC/9cHSwuT8jlxG2zCpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,290,1763452800"; 
   d="scan'208";a="236106799"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 13 Feb 2026 22:30:12 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vr9AR-00000000wHY-0pH2;
	Sat, 14 Feb 2026 06:30:11 +0000
Date: Sat, 14 Feb 2026 14:29:30 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Alexander Potapenko <glider@google.com>
Subject: [akpm-mm:mm-nonmm-unstable 30/30]
 drivers/input/misc/pf1550-onkey.c:190:39: error: 'pf1550_onkey_pm_ops'
 undeclared here (not in a function); did you mean 'pf1550_onkey_probe'?
Message-ID: <202602141440.xObtAhOc-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 103D1C0013
X-Stat-Signature: 7hkt5uo8axc347i5aegpjwmbpjfadm3z
X-HE-Tag: 1771050616-15307
X-HE-Meta: U2FsdGVkX18ZixzPxtb3U4Owz1IXwp0rMi9EN6lZO0lPVf5EqiQq5oE9kCpyB7nBs/UHjSaaX+jiOT5R+HFMoPrxenSLVH/yrVPVYiL4bxT0vjghqxdaUnInvhPnfGeC8/vdU49O1pTjyx+51FiFKe4ZH7DTUm1D2/ZhcilT3BN6ocP+tS8hnX3vM4Aco7AgoB6DAiHUsnVU9lul9j3+ahNlVyVreRM7waUvDPyMU5h8VrfOPIeBin2VuDAPu4TBW8wtXF9lpqJ3k0koACI+W8ztoy81wOnign6DrpNprGJF16/RieSfZEZfgqebqBj9ivhZzLEh8dZnXUn26sP1pEitcqN8gBGD5+ZSmcO961ApVuXP70ArQF6AGrvnTSBtWbzD9Yjn6lLT+DnhS/Mxe5EWKhp3HlyyilcpCdEj2u843K3YEVSPksQkgSRgfm/ARZy0va6hPNsgQxBT+Wieuf5wUWvNiiZCI3WRDBclHX8LSlQdSN2mp+1akCyd0OFhWR2pYWMFzgYsAb9GJGp1R0fFfPAs+to130HX9H+OX81czIfTO8tEpnoVamdxebOmD8oikHQtztoB3Fj71VbOISJNfyWw5OEDj/2WhgQA/vdSTz0O2OWfF2qbsvW3BDzxeLXoFtDUWLARSB4ScwfNvj8dkCaZpMUDSGUfX+cMjN5Yf0ntfwCQgxP+latxqskct3TIbROhOfvMqME3vr7yPmr6yd81Eg+6XxGH2eNfx8C8q6xiUJU4u/cVckFUr4dvTxS54s5yJm9MZUdDE0lEBoDvxgE02bYbOdX1sBB5WAmQ/obymMYLcdjEQcwuVCJFbp/9nUFV4c70XCY2GTSqKG66kPUD3r0voQjlEZy90m0wZcfMrF4O0QeqQPcQ+4URHYpWj5XZOzywRbQpYa+sL0ESXnaZRNsqiGa+nBneQ6uVRPtEaDg7vJEWm3K/uLKl0BmpyC8Pn9EwqExKA69
 R87DIbWT
 RuNv1DZgcwgE1d0XbNQXb6DFcZ3eZB0mIkWlPRY6+MGiyZqWQgvanqQy9vgg5huXl8AT7/PV3b/8eu6cSq2TDS/CyemgUC3GA+RXP5CFA9LzE3sezzuKET0TUO5xDpO4tZvDYKmqiz1WV/ShdBp7/th9qIuOcwturPxoOaGnA0/MuDVPg10ScTkxSWPSswypY69kf6OCmHN7jFeRvyHTpUbDZ8RkBFM7/IlM7ekEwkl2bOcg++tWr2VgsAWs89oOiejQIjCxiAeecvBInFJyuo50nML1DqDcfRl13RJjWen2piIBbx9Ng536J9OcGpORtbwigNah3LJyGbFCcJ/5DeUiM4zhKH1C+ZnkrzkcGoCu9RsyvC5gW4LYFhHVy5yBcRqRDv+WJS14rFkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   f88534a6e7afcfe6ad5f93b86f6e64d5d4d23709
commit: f88534a6e7afcfe6ad5f93b86f6e64d5d4d23709 [30/30] drivers/input/misc/pf1550-onkey.c: fix build with CONFIG_PM_SLEEP=n
config: arm-randconfig-001-20260214 (https://download.01.org/0day-ci/archive/20260214/202602141440.xObtAhOc-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260214/202602141440.xObtAhOc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602141440.xObtAhOc-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> drivers/input/misc/pf1550-onkey.c:179:8: warning: extra tokens at end of #endif directive [-Wendif-labels]
     179 | #endif CONFIG_PM_SLEEP
         |        ^~~~~~~~~~~~~~~
   In file included from include/linux/kernel.h:35,
                    from include/linux/random.h:7,
                    from include/linux/nodemask.h:94,
                    from include/linux/numa.h:6,
                    from include/linux/cpumask.h:15,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/sched.h:37,
                    from include/linux/ratelimit.h:6,
                    from include/linux/dev_printk.h:16,
                    from include/linux/device.h:15,
                    from include/linux/input.h:19,
                    from drivers/input/misc/pf1550-onkey.c:11:
>> drivers/input/misc/pf1550-onkey.c:190:39: error: 'pf1550_onkey_pm_ops' undeclared here (not in a function); did you mean 'pf1550_onkey_probe'?
     190 |                 .pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
         |                                       ^~~~~~~~~~~~~~~~~~~
   include/linux/util_macros.h:136:44: note: in definition of macro 'PTR_IF'
     136 | #define PTR_IF(cond, ptr)       ((cond) ? (ptr) : NULL)
         |                                            ^~~
   drivers/input/misc/pf1550-onkey.c:190:25: note: in expansion of macro 'pm_sleep_ptr'
     190 |                 .pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
         |                         ^~~~~~~~~~~~


vim +190 drivers/input/misc/pf1550-onkey.c

9acb215cbebdce Samuel Kayode 2025-10-01  176  
9acb215cbebdce Samuel Kayode 2025-10-01  177  static SIMPLE_DEV_PM_OPS(pf1550_onkey_pm_ops, pf1550_onkey_suspend,
9acb215cbebdce Samuel Kayode 2025-10-01  178  			 pf1550_onkey_resume);
f88534a6e7afcf Andrew Morton 2026-02-13 @179  #endif CONFIG_PM_SLEEP
9acb215cbebdce Samuel Kayode 2025-10-01  180  
9acb215cbebdce Samuel Kayode 2025-10-01  181  static const struct platform_device_id pf1550_onkey_id[] = {
9acb215cbebdce Samuel Kayode 2025-10-01  182  	{ "pf1550-onkey", },
9acb215cbebdce Samuel Kayode 2025-10-01  183  	{ /* sentinel */ }
9acb215cbebdce Samuel Kayode 2025-10-01  184  };
9acb215cbebdce Samuel Kayode 2025-10-01  185  MODULE_DEVICE_TABLE(platform, pf1550_onkey_id);
9acb215cbebdce Samuel Kayode 2025-10-01  186  
9acb215cbebdce Samuel Kayode 2025-10-01  187  static struct platform_driver pf1550_onkey_driver = {
9acb215cbebdce Samuel Kayode 2025-10-01  188  	.driver = {
9acb215cbebdce Samuel Kayode 2025-10-01  189  		.name = "pf1550-onkey",
9acb215cbebdce Samuel Kayode 2025-10-01 @190  		.pm   = pm_sleep_ptr(&pf1550_onkey_pm_ops),
9acb215cbebdce Samuel Kayode 2025-10-01  191  	},
9acb215cbebdce Samuel Kayode 2025-10-01  192  	.probe = pf1550_onkey_probe,
9acb215cbebdce Samuel Kayode 2025-10-01  193  	.id_table = pf1550_onkey_id,
9acb215cbebdce Samuel Kayode 2025-10-01  194  };
9acb215cbebdce Samuel Kayode 2025-10-01  195  module_platform_driver(pf1550_onkey_driver);
9acb215cbebdce Samuel Kayode 2025-10-01  196  

:::::: The code at line 190 was first introduced by commit
:::::: 9acb215cbebdce721af2219e2859ad17342c9084 Input: pf1550 - add onkey support

:::::: TO: Samuel Kayode <samuel.kayode@savoirfairelinux.com>
:::::: CC: Lee Jones <lee@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

