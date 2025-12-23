Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AD25E6F08F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 13:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31E096B0005; Tue, 23 Dec 2025 08:23:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4B86B0089; Tue, 23 Dec 2025 08:23:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD7E6B008A; Tue, 23 Dec 2025 08:23:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACB46B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:23:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A1B513A52A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:23:37 +0000 (UTC)
X-FDA: 84250802874.06.22DBC0E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9BA8B40013
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 13:23:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cAsOJcvY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766496215; a=rsa-sha256;
	cv=none;
	b=Qhmo+c2HrYHOosJVlNsVhJ4zuedCUyTx+5Un4XSHpH0eKk0tUKBvzMXyfd7har5E01A8r/
	mdjpxAyipenslW7TguIug0OfIpvpr1LjBvxtLtj1vW0SZsUyzRTFdkhVdPneDG8FECnR51
	lqTry5WbNBH5orldkXPxPMVUYKe2G8g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cAsOJcvY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766496215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujoc4Did2a4hWKi0PVbKnoK20r76mRneQWS/N7RKfzw=;
	b=EuOsDMHW0gkFHmXVzXyL6qvLx5adFX+cr/um/Is1C4PNGqH6436AP6Ay2eDDEzB/YvTtl3
	FpDvL5XKuj2vItESqXxk8a+ISFq9HMhEWZcEGM9wUPPphP8jFTSDrYd/K8ypSVVlar4Wcz
	andM7S6cuqzNlg/ULPwPjUcyKFgNZ2A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766496215; x=1798032215;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sVjyIGQrrpkyBkTFumzOYIT7xsfvu4X4mrPIwnTXsuo=;
  b=cAsOJcvYibLQFd7awuBSEZIE0tpIPrlwpWQOnuMHevTcWLv1U85VbFPn
   8pNfSO2DSgXM5mMvPAO1GalFpj/FdoIh6EV35/deZzYdpphHRCPh2f8AC
   NhjexY9Wo7fPnYfumGe+gxtIuRoAJY3PDwahMAcT/WBwe9XQHpISUVuze
   TEsylwPNyAMxUG4RofpFXG2ebDPVcp5oeCpBG7UpatBXEzpD8uy/3iH5k
   VsJF4mb1W+7gr/eRNw+wAGgDN7Xc8wIZWxuJFaJeaPNqrNI5iDQVI+4wG
   be0fBeYUoMielAW1zJNCHKxz6WvsucUJVNspQIkZDtjMlicH0ybk1xvrC
   g==;
X-CSE-ConnectionGUID: 3nTDasBTQUmIuPoujyxRJA==
X-CSE-MsgGUID: +HonoM0BR5+aPSUBlpIaDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="68226195"
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="68226195"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 05:23:33 -0800
X-CSE-ConnectionGUID: trY28Fj2ScOhqzvD2TJVPw==
X-CSE-MsgGUID: pablz/scS8mrJb7R/PPP9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,170,1763452800"; 
   d="scan'208";a="199691761"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 23 Dec 2025 05:23:21 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vY2MA-000000001xh-2Udu;
	Tue, 23 Dec 2025 13:23:18 +0000
Date: Tue, 23 Dec 2025 21:22:27 +0800
From: kernel test robot <lkp@intel.com>
To: Tamir Duberstein <tamird@kernel.org>, David Gow <davidgow@google.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Naveen N Rao <naveen@kernel.org>, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
	linuxppc-dev@lists.ozlabs.org, linux-kselftest@vger.kernel.org,
	Tamir Duberstein <tamird@gmail.com>
Subject: Re: [PATCH v2 3/3] bitmap: break kunit into test cases
Message-ID: <202512232124.O36Ud5C2-lkp@intel.com>
References: <20251222-bitmap-kunit-convert-v2-3-6a61a5330eff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222-bitmap-kunit-convert-v2-3-6a61a5330eff@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BA8B40013
X-Stat-Signature: nm6iihhf5ep65hagj4yp9ta1c91eaf78
X-HE-Tag: 1766496214-364949
X-HE-Meta: U2FsdGVkX198/KmSu17DpjsarY/h2VY16cs3xMwrKqEAmkVImNskrhEdJ+Bkrpkny947Mqk/AIUah4weOoemtCWUjbQ7lMD6M2CgnbNitDVN704Liwu8h98Pjlswj16irlVgoEamwJr4JhkaaKpLVfufT5AGar95dFDcfM4jCv3p6ayeAtBGTWO/lQbjwrzbt0rtPZAj5Zpe/Gf4w98URgx2ZV4wrxj6+F4C3rquZt2aunF6NGV6pmkASQSbni4Cge3gOV0Vo7H53uHdQAqEr6t9e5wpBBYjVqz0AX15U6X132BmNRaXgMGrW6HmvUh3Dq9BE9I/xmvCHi8r1P3sHu7JPG4BsI68odCKaycEk7HzGrJJLHI6lPTsGx+WMo4qGWSEvg9OdVSe5SpQxowRc2L0ODajknvi+nA/116E4V/aXUIfsUg0Q2nG/Ks8bXBc//jRm6YdpyrZt/FzC9v8o9fLbeEBrqObcnnJ2ddcj1LX7kfzPqFxc83dfapVUBvw48viVptepzvzb9BYkOHsxfvS9NyNRwKA5ndgoDt5vZx0FsJszx5WPFsQ6mKyyM0d40rogGvVQcnDQ1Urp2OHB5vhlElLAtG5i1AwBuiQEWvPKQNc6sya5yl7j08HfwYevdqH+sFmINXXuaxR53xnizimNJP0iUfv5vc0STnAy1LtAtDX8rcF6XYtadH9E1xVgJZW3Z+dStMXGJT9guTWyHYxJWGG5g98E+AJ8QXJl4w+ZcAgQ0ykGKJ3+lZosmxJaCTHW6wxhulkbHvmJAbqNMUZo0RCxDtqYATDrvbLgnriY1InBAvfWniNx29zxkXq7/AzbcvALk1zrowj5gVA2DC5xhHWiQ/CwGvudeZTukLJcd1N5OpK7QyBgORJQa+ui6MvTh+yXjKjKDtUDhS13IBkgoNDAgHVzeM+cKYbZkcD5qVKApfPXi3oie8U/+H/QHsGCWmCbLtuB0gBX91
 Z4Zf7vtQ
 22J3L1GgVDsxuQdcSll1p/IPO2U9wGS99L9m1M+OacMSILR51Sw96gE83l/7WvlN5+zVd215K+2Q8UTFa+ZdxVXbqtzi55nF32JuOdBwNzV+hs0S7g9vIfoFQ+Pps2HAmXeov/8K/lNeEg2u+heSw+1SpYkzIjQr2xd2rJF1UI5n7l88HP/sc4i1EM98eUQFUDwqgDUQuCqTcIzN0wAV/TQQkw7SGkp2QNBzXbn1IKeqHunvPLvJgnhRo73ljfyK1++91mDtb3sf9W0R51yvmicBacqbd6fn/bGJFMxmYhgkkZ/4Z0SQtohAJRtAkqazXS1n0K0SOeI/UlM4d7I+A4IoKET3A6OL7VxXm0YCD6w4W2u9WAdneYyKrtQM+8Ook1sJi4Ccd+dp1Cm4nYesbFkBsIi5DmnLKUcQVZLLI/acwrVU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tamir,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 8f0b4cce4481fb22653697cced8d0d04027cb1e8]

url:    https://github.com/intel-lab-lkp/linux/commits/Tamir-Duberstein/test_bitmap-extract-benchmark-module/20251222-214306
base:   8f0b4cce4481fb22653697cced8d0d04027cb1e8
patch link:    https://lore.kernel.org/r/20251222-bitmap-kunit-convert-v2-3-6a61a5330eff%40gmail.com
patch subject: [PATCH v2 3/3] bitmap: break kunit into test cases
config: sparc-randconfig-001-20251223 (https://download.01.org/0day-ci/archive/20251223/202512232124.O36Ud5C2-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512232124.O36Ud5C2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512232124.O36Ud5C2-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/string.h:65,
                    from include/linux/bitmap.h:13,
                    from include/linux/cpumask.h:11,
                    from include/linux/smp.h:13,
                    from include/linux/lockdep.h:14,
                    from include/linux/spinlock.h:63,
                    from include/linux/kref.h:16,
                    from include/kunit/test.h:22,
                    from lib/bitmap_kunit.c:6:
   lib/bitmap_kunit.c: In function 'test_bitmap_printlist':
>> arch/sparc/include/asm/string.h:18:29: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]
      18 | #define memset(s, c, count) __builtin_memset(s, c, count)
         |                             ^~~~~~~~~~~~~~~~
   lib/bitmap_kunit.c:468:9: note: in expansion of macro 'memset'
     468 |         memset(bmap, -1, PAGE_SIZE);
         |         ^~~~~~


vim +/memset +18 arch/sparc/include/asm/string.h

70a6fcf3283a0a Al Viro 2016-01-17  16  
70a6fcf3283a0a Al Viro 2016-01-17  17  #define __HAVE_ARCH_MEMSET
70a6fcf3283a0a Al Viro 2016-01-17 @18  #define memset(s, c, count) __builtin_memset(s, c, count)
70a6fcf3283a0a Al Viro 2016-01-17  19  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

