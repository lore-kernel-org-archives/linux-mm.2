Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 304B8E6F095
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 14:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF546B0005; Tue, 23 Dec 2025 09:19:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DCE6B0089; Tue, 23 Dec 2025 09:19:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F136B008A; Tue, 23 Dec 2025 09:19:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 556FC6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:19:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC898130C7
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:19:31 +0000 (UTC)
X-FDA: 84250943742.05.F33C525
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id 29063A0015
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:19:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DDfAcMr8;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766499569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXvlcOaXAIQVq0t9xJIXeKMuDJHoQWiYerhVoYVIFzk=;
	b=kA8y7xLjPvF3/XVwx07p5ln6bxT7mD6ZgcV/onKFI8KkoVnRIKDdWl7cp+1PIUhX6nUiV9
	V1+5gYCsYUeaw5j7PbVis3TcEss2ef1F3i4t4nY+K5ygiil6EXFXXFz9mb0D0NlBPT1vEk
	MGi7G26arbjxB0dwV21BkcTduZNbZDQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DDfAcMr8;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766499569; a=rsa-sha256;
	cv=none;
	b=W7OSPTX+5vvXxpNQxcZV2IKmBoWP72ShziCtYG4uC/azPSxo/ZB0GjW3mmxWgf3BOwnj+X
	zmMYcTcNix1xwt/w5TmVvnW3c4Gd3HiQyalCGvBn5nRywDRIUc5MJSMa+3h2IBuiuIkkie
	Ve0dcQ5g8cnxaWPDi87lN5urCL7ut4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766499569; x=1798035569;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZZQg8s4/nNF1ZlkzREeuw4bYSFY91iLUDaAHPJx09QE=;
  b=DDfAcMr88uv7/OaW5CCek8ZsB/jDkPFbzHebqKK7H+I94O0a/TI/FMrh
   Oi1aZKFR8lqrmozpW7vqIx1wZ2axoYL6xcOkE/NlzCgbbYdF7R8/GRUNI
   NNsmhfQHmr5gLzN7l0iEuL6pgofgkJUUGoUvKBGhCUzkXtblpWtz9+u3L
   BpIhl14fLDcTAQ/d8T0QZ0ajsR5PEVNe3/DYaLXzT9cAeUSm4grTeaL8f
   hgRLnAW/z1BRZ+Z6PfMjMPzT67Qig5YKPBXH8jFkzaH5R26pWH4gpyKLx
   BNWftowrerEH5ZUwpM7++s9ueX1fqPRDyAyvrftIcRE51a/2yQ6gb+NVO
   Q==;
X-CSE-ConnectionGUID: oFkeUMkMQjW3aCCmYsBLXg==
X-CSE-MsgGUID: oJo/VVrOTgyWfj90xEtAVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11651"; a="79463744"
X-IronPort-AV: E=Sophos;i="6.21,171,1763452800"; 
   d="scan'208";a="79463744"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2025 06:19:27 -0800
X-CSE-ConnectionGUID: Vg9Iuvx1SiG+8Rwxb+2JDA==
X-CSE-MsgGUID: nMqDeak8TR2g8NmJnysUGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,171,1763452800"; 
   d="scan'208";a="230813594"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 23 Dec 2025 06:19:23 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vY3EO-00000000217-3Qms;
	Tue, 23 Dec 2025 14:19:20 +0000
Date: Tue, 23 Dec 2025 22:18:06 +0800
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
Message-ID: <202512232235.vUHmJH7T-lkp@intel.com>
References: <20251222-bitmap-kunit-convert-v2-3-6a61a5330eff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222-bitmap-kunit-convert-v2-3-6a61a5330eff@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29063A0015
X-Stat-Signature: 16qqbeng1md88ghy1jnpizum87hyw3om
X-HE-Tag: 1766499568-654621
X-HE-Meta: U2FsdGVkX18aMEaHhrR5KCPZ7YIDulbSjPc6LsI2px0cRqgM2tsJXzPZX6BmXRUlNw3FO7YP2kCOVQVZVpSfY2AYYgAJq6y6AaCsmgROnUtJ2oVe5U1df0kjq/atJm0doq4tTrY/nCzY6NW92HhA3N0AOzYPBWK006azrfkNUWjk3W7fOkaetOrjOREe4rbgzvdGoWVm79xnNzGnLgYEXnb3O1BoBsVJ+72jTLtwTV9fLYX9JHnZQSjMCkB4fwcxgbOrmqcNxqzj+iCSbWRohtpKXCKy+wVQIPW7fqY2lS5db0BS3LbgDPXs5hx1kngyJHVN/ltZknfhE52dZvyvoYMXty1eO2VviOISFe+IAfaTlOeSXxA57ZkQf5X/OS7wSlM6ZGF2sA+AjcFm17dJVqL5k40TDdMhSxSL1M6e2WcHhuTd+FgXrc+jz+6ODbmYz6EbLu44ed4dZ05Ro1icmTuOkwM3GWIg7RdiUeSTzTTtS5Z1rMzl1Sqpzuk5bidgZeVEybS8I1zwGO9Hq6ATQeaRqbbVc3QpOQ4FK/jKmudmgRDbn9YbQI1tHmld5iQH7ekPwNV3Qnu3Vvizgh/P/hBbnEfWr5GcfhkuXY8S07RZTFhTTMGwBKWWqy8jV2bax3/xIc1DG26NbiWHYW/Soy/G3h9oX6BJy6Ef8/ghUxI5pLrSEZz1svM0w/g8XS6ykLh2azcFcXcuUBue9WDX48MhCUxp2Wiym7iz/g9KqUOp5q/8k4n4q4WaXFC8NWgXxENrqJZ278agJxjWzJWuRIIUxKHnPwmpqWKXukcy+RfFWEVTw2bbpv6N4JLYJTGsP1IBqrVoKQkZlZZhy30eeDqC9uKEtjfuP6Zc4sUC4HtExVPHqQF7i/sIg20lDDqlHTpA2gjZB5vMTekRZPdHSJ83urD1CXmXAFtZ5GETvNDAyKa0VtBZJtKmOT7mt4gFFUQSc3C9ajLjvins8/B
 JSCbBLZ9
 Hlzt/3jefyVG4qWb9u2vRhbsugsxXlCQpbI+LRRrIiz5szzqDPn1K2s3kJmmxjfj6dBT1icN9yQH+/Ser0tntCTlSHUU8OL1ZJmiOvc/xb5aTIH+0ONzxbqRa7huKmpC72Nj+BWC7n3IPHp/Bc32E0OiUVyOSBgbhZ2Lofl4m53nrhBts3AIriuvNsgCJI6/3a4K7qECVvXfdvKQSke7UOCnyxBZ1ii8ta+O3At2eF3oWvA2uhVMEzZw3giIb3L6O0IkfM2+EUV+zIxdDEYiVgblH4kEo+aXYZxO7S0gVoycuRBoKiBgZXHpacpeqbqA09r73o2dq+hrx8k9rXF5+qrSMSH91Rg7jxVf2Qd0WgDwhVCG+OpWnHXXlLdPYEl2W/F58uFnRmGOgBsn0mM2WlfL5EAajBHFrpnM0S9T1CrI0U0Q=
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
config: arm64-randconfig-004-20251223 (https://download.01.org/0day-ci/archive/20251223/202512232235.vUHmJH7T-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512232235.vUHmJH7T-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512232235.vUHmJH7T-lkp@intel.com/

All warnings (new ones prefixed by >>):

   lib/bitmap_kunit.c: In function 'test_bitmap_printlist':
>> lib/bitmap_kunit.c:468:2: warning: 'memset' used with length equal to number of elements without multiplication by element size [-Wmemset-elt-size]
     468 |  memset(bmap, -1, PAGE_SIZE);
         |  ^~~~~~


vim +/memset +468 lib/bitmap_kunit.c

6ea86bdfc169ba lib/test_bitmap.c  Yury Norov       2019-05-14  459  
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  460  static void test_bitmap_printlist(struct kunit *kunittest)
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  461  {
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  462  	static long bmap[PAGE_SIZE];
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  463  	static char buf[PAGE_SIZE];
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  464  	char expected[256];
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  465  	int ret, slen;
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  466  	ktime_t time;
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  467  
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14 @468  	memset(bmap, -1, PAGE_SIZE);
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  469  	slen = snprintf(expected, sizeof(expected), "0-%ld\n", PAGE_SIZE * 8 - 1);
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  470  	KUNIT_ASSERT_GT(kunittest, slen, 0);
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  471  
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  472  	time = ktime_get();
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  473  	ret = bitmap_print_to_pagebuf(true, buf, bmap, PAGE_SIZE * 8);
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  474  	time = ktime_get() - time;
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  475  
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  476  	KUNIT_ASSERT_EQ(kunittest, ret, slen);
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  477  	KUNIT_ASSERT_STREQ(kunittest, buf, expected);
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  478  
8ef3340af7139f lib/bitmap_kunit.c Tamir Duberstein 2025-12-22  479  	kunit_info(kunittest, "Time: %llu", time);
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  480  }
db7313005e9c2d lib/test_bitmap.c  Yury Norov       2021-08-14  481  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

