Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85114C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 05:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8DE6B00A0; Fri, 28 Aug 2026 01:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A6B6B00A1; Fri, 28 Aug 2026 01:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58FF06B00A2; Fri, 28 Aug 2026 01:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD396B00A0
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:34:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96003C0396
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:34:19 +0000 (UTC)
X-FDA: 85149562638.02.E124BC8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BF64100002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:34:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="f+sF+z/J";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787895257;
	b=iG3hgjUkoyHrpE6T3+oGwwx06cBqseYVnJi3oh9Bhd+1W+cN9XkjH2MWuHHTAUnaAPl71L
	brS71GykMVO9hLrcabexmZMd26qXIfRmErdhtWFFWE3iWKqLpe5VMTJzcZqMd4/YjkHA2z
	eOGrmsVy0LgH4A/lVO/ZLOhSXTYyThI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787895257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNxA61xg/sFWixfr/AGYMYFeaFjndZ7uXYyULbKtlao=;
	b=qZ2y3vIwBkQeOonSv5oKJIVEUiSygjHc7r32QQsd0vYOs/1t+MY8U2LuCruj8FQJ/NIBVP
	dcgCQHiqeRYuGlPg/arAQZ3GQO4k7d7/qERI57r6q0742zh+qY87ArHSFooUgMNID2G/dU
	AbOTd1JTjD8ZixDZ0JIysM30HqNEjKg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="f+sF+z/J";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787895257; x=1819431257;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L12kByngmxm0+XcLwhdT9GBJpdEOxar0JOOmR9A9qck=;
  b=f+sF+z/J6Lbu0TjniittfTdTkUiOPRc7V8CsunZGYJtLgrW2+UJLrTj9
   bPXfjY/ceXVq21q49u7ocGkznr8gPHVeWknyNzVuc5x+HDGbhiOlT0pS0
   KFaK9aFBBpFqLPQ+TRaWAS45sv4596qCXzkChtC0xoUA+jr2dH0BwS8gC
   bnRHtc4LTkOSq6gmr/9QTyYRk86o/PyB5MPsH3R5SaqbFO7kDVakGFEka
   i0P1DvhzOuU7Azobo61Sx5sJQSwX2BQWqGbcMPdRp15Pjd5mVN4wxdRJW
   6qh3K1euNvOMZe5p4InmEc0b5YEgP86pnAj/VI4GttrUaC4WEO8xaLS8m
   A==;
X-CSE-ConnectionGUID: WLxyI9k1Q3e1y3+KaaH9pQ==
X-CSE-MsgGUID: pISc6vXiRPCqjt0o9zfeew==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88525466"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88525466"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 22:34:16 -0700
X-CSE-ConnectionGUID: 2JOw/X5sR7qW4b71mX5Ntg==
X-CSE-MsgGUID: mIi6lFz/Rs6jYJK3+8P47g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="270025508"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 27 Aug 2026 22:34:14 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzpEB-00000000AST-1pk6;
	Fri, 28 Aug 2026 05:34:11 +0000
Date: Fri, 28 Aug 2026 13:33:29 +0800
From: kernel test robot <lkp@intel.com>
To: Zenghui Yu <zenghui.yu@linux.dev>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, sj@kernel.org, akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: Re: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
Message-ID: <202608281351.Hv386MvO-lkp@intel.com>
References: <20260827163953.83520-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827163953.83520-1-zenghui.yu@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BF64100002
X-Stat-Signature: xzk883t17cdd4awjsk3djpfixknifko9
X-HE-Tag: 1787895256-892472
X-HE-Meta: U2FsdGVkX1/MueMAipJgBEKCYaoRPzeB0T5ZTzek7cWcXm2muC1d6qXUUEiOFSG3oV2huuXvOXLlm7Sv3AvF00dvQRb1Uiruaz1+WG3h+rQFFmINGeVLU3CCsqQEY42g/hpsST4VU148Rssb9cZt0ESNfMAdgwDK2A4YW7EejaQ9+s5jWPregnv3dJUsAe5Jx0psSwnqMRvffXtZV85U2DT/9l0EUR0eCWESmLRAg/Gnktox0Jc3p0o1z69ATWSWcn5zF+Kh3X+dE8nzfp3TwPuf/9PUtGrRjlvGfglQQxACiXwRRniGJkNOx7p3ogbo+q0ASAw7w3GccG0u01Wb2wnXzZLkpczjsPiz3ScUL5Kuix/5iMNDuEzLS1HYFkNOPKGagHLJmdUfWZ7kFGgKxwEq4hepiKscAHXCeUdCovueVTN0wH1j7dkTioA1IawEylLDQd5+fxAJuFV9BrLeAlncMjSigf3Xyc0qoWceji8eR6rwdmpi16vgCS0r/JxrYbVQP56Ub66JpNpXzKxSMuvy+RLo7ri3ZEGmbDjrviGUXK6jPgK/GQiXObOVSP6pyMwBSvkbVqFf1Fx1YNNOoYcML3lhC5NR/N+eJ19rf1ECFz0sw0GwwWk71rNwKmf34pjg7R2uaBcP8di69Xa5JP82gyFUBNCgaRQnBoaGKtuhZK4Mm7CoCBScKa3iTfxqz0ZKGF5UFhewlXkpSGVEV91ea/BfzNJ5+86GN8sV2XBw4uW0eEidrnTL9Y+Vv5kLO/9J2Xv/D6stPAZln5wZzpSgb3gN+bB6P1TCUAJ47I2XwkGLUF7XBhMfZ7/3emfQAjHEOEB4hzXvrwTbFyInzAqkW0g4DCDHc6olB9EVQmxtXJDaz6NftY/XBP/uj4JLg5lHogA3Qclrbg/zvSx5olSxC1tzmw5GCZ0oG1BeArje8YYtMM2ACKOoXrWrqToCQwIf0RBItNt8A4djs2A
 /totBn33
 t2kC3FwD1qM0eM2r7KEtsmZLI/q9PGLaa0s41qQSE0y/r9CMN+AMi1yaX6Zmen3rFq6vHONnyJPo7f3vWyd/beMJt4wURkGW+HXhqfzt7QGspiz3GHHwOLY+zhW92bd7QYXmMFmd2hco3nziGtp2ln8hO89oOQN6Z7YLXoE6GFQYG1w81ra8usvsAimq3rhrCuA0m61+r+JIiX+TuM9Gvh1e3AzRcvq1TPjeC1cTu1eqNhVCAEzYiw6Ui/OMtD0SlqIlr/1sjW+AgTJnbhzzkNOnZkHM1l5+S4R4hC4/WEk9hOy8CJd1md2Az9184kMC/8oyCtCXs1/DLENDhRssZRRHEKkZEcU08b2Fvo395bhzemvsZqK6lhi8GiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zenghui,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Zenghui-Yu/mm-damon-core-remove-declaration-of-kdamond_fn/20260828-003953
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260827163953.83520-1-zenghui.yu%40linux.dev
patch subject: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
config: xtensa-randconfig-r073-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281351.Hv386MvO-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 16.1.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608281351.Hv386MvO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281351.Hv386MvO-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/psi_types.h:5,
                    from include/linux/cgroup-defs.h:24,
                    from include/linux/cgroup.h:29,
                    from include/linux/memcontrol.h:13,
                    from include/linux/damon.h:10,
                    from mm/damon/core.c:8:
   mm/damon/core.c: In function '__damon_start':
>> mm/damon/core.c:1941:44: error: 'kdamond_fn' undeclared (first use in this function)
    1941 |                 ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
         |                                            ^~~~~~~~~~
   include/linux/kthread.h:46:32: note: in definition of macro 'kthread_create'
      46 |         kthread_create_on_node(threadfn, data, NUMA_NO_NODE, namefmt, ##arg)
         |                                ^~~~~~~~
   mm/damon/core.c:1941:32: note: in expansion of macro 'kthread_run'
    1941 |                 ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
         |                                ^~~~~~~~~~~
   mm/damon/core.c:1941:44: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/kthread.h:46:32: note: in definition of macro 'kthread_create'
      46 |         kthread_create_on_node(threadfn, data, NUMA_NO_NODE, namefmt, ##arg)
         |                                ^~~~~~~~
   mm/damon/core.c:1941:32: note: in expansion of macro 'kthread_run'
    1941 |                 ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
         |                                ^~~~~~~~~~~
   mm/damon/core.c: At top level:
>> mm/damon/core.c:3750:12: warning: 'kdamond_fn' defined but not used [-Wunused-function]
    3750 | static int kdamond_fn(void *data)
         |            ^~~~~~~~~~


vim +/kdamond_fn +1941 mm/damon/core.c

b1029f29eb1d5fb SJ Park        2026-02-28  1924  
2224d8485492e49 SeongJae Park  2021-09-07  1925  /*
2224d8485492e49 SeongJae Park  2021-09-07  1926   * __damon_start() - Starts monitoring with given context.
2224d8485492e49 SeongJae Park  2021-09-07  1927   * @ctx:	monitoring context
2224d8485492e49 SeongJae Park  2021-09-07  1928   *
2224d8485492e49 SeongJae Park  2021-09-07  1929   * This function should be called while damon_lock is hold.
2224d8485492e49 SeongJae Park  2021-09-07  1930   *
2224d8485492e49 SeongJae Park  2021-09-07  1931   * Return: 0 on success, negative error code otherwise.
2224d8485492e49 SeongJae Park  2021-09-07  1932   */
2224d8485492e49 SeongJae Park  2021-09-07  1933  static int __damon_start(struct damon_ctx *ctx)
2224d8485492e49 SeongJae Park  2021-09-07  1934  {
2224d8485492e49 SeongJae Park  2021-09-07  1935  	int err = -EBUSY;
2224d8485492e49 SeongJae Park  2021-09-07  1936  
2224d8485492e49 SeongJae Park  2021-09-07  1937  	mutex_lock(&ctx->kdamond_lock);
2224d8485492e49 SeongJae Park  2021-09-07  1938  	if (!ctx->kdamond) {
2224d8485492e49 SeongJae Park  2021-09-07  1939  		err = 0;
6376a824595607e SJ Park        2023-12-08  1940  		reinit_completion(&ctx->kdamond_started);
2224d8485492e49 SeongJae Park  2021-09-07 @1941  		ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
2224d8485492e49 SeongJae Park  2021-09-07  1942  				nr_running_ctxs);
2224d8485492e49 SeongJae Park  2021-09-07  1943  		if (IS_ERR(ctx->kdamond)) {
2224d8485492e49 SeongJae Park  2021-09-07  1944  			err = PTR_ERR(ctx->kdamond);
7ec1992b891e59d Colin Ian King 2021-11-05  1945  			ctx->kdamond = NULL;
6376a824595607e SJ Park        2023-12-08  1946  		} else {
6376a824595607e SJ Park        2023-12-08  1947  			wait_for_completion(&ctx->kdamond_started);
2224d8485492e49 SeongJae Park  2021-09-07  1948  		}
2224d8485492e49 SeongJae Park  2021-09-07  1949  	}
2224d8485492e49 SeongJae Park  2021-09-07  1950  	mutex_unlock(&ctx->kdamond_lock);
2224d8485492e49 SeongJae Park  2021-09-07  1951  
2224d8485492e49 SeongJae Park  2021-09-07  1952  	return err;
2224d8485492e49 SeongJae Park  2021-09-07  1953  }
2224d8485492e49 SeongJae Park  2021-09-07  1954  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

