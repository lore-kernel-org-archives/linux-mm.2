Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58851C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076096B0088; Thu, 27 Aug 2026 20:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027536B008A; Thu, 27 Aug 2026 20:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F786B008C; Thu, 27 Aug 2026 20:55:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C370B6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:55:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 556E540222
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:55:53 +0000 (UTC)
X-FDA: 85148860986.28.03FCAA0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9F4561A0005
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:55:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFyEkNBo;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787878551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IlvSVTecqNCJFN9tgALZfqGCQGFnM7T16xqImSG+lvw=;
	b=J1CjGTefh8zS6In+j0IeZ5aX6jQCjRBknqk0t0ypfqB5QV5B/jPDbr/tpX8kagJD8StYzo
	EX7GQd8RZR3J7ALarGuUfHTljylQEY1mrxDtbpQE8SDCO1NEtWP9J7eZvlDC+RxMZyju6T
	6yyRxE+xCcFKPI0M+2Un2xAoTbCGvo0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kFyEkNBo;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787878551;
	b=gQFyFvD5VyW3/9ObMDtpqk53ZKj0GDP1uSDUAVeEG5nUbaZvou27MykfOiYKMQN258E5Bk
	uUTGd3csFHH8trHPen+kK0EELHWMfvvGwUZ/6mEc21QRZMjlvOdFR/cv7NqjuQGWituhmm
	mktClHT9jeq+N9EWu3uY7kjUX+JvUsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787878551; x=1819414551;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pxJJ/Gq2BOZaGKWbI4sy8nb0IV9yvaOJO4OZ8lJb3Fw=;
  b=kFyEkNBoIb0Dw6KrzXUM5J22rpDNsbVwdjCKW62QRUHAaqL9Cmg5oxRr
   5tPpQeINC0DvkGjLpcIgXGYwfn8qMWbX38ioc4XJjxvQkqUWcpo7sV1YS
   TvfNomv9vkLx1MTl4N/DoHaSOihDO++UBrQ+1sYEy7NC3dAs2A4Z/1RFT
   mufG8hajmTn4ZpJ5TrYAbR7JA2uO+UyY5ziAQN5KUvIvAVtlOJq0bVFJi
   zsixNDyycrInW3fpOlclbwNpt5H50IzbtqOQhLbDgZU802Fg2Fo7n+UsO
   waW1CemnjfbXNLqDpb28DU8uu4oqjeEZZ659koWFIovjnQwsNslhAiJTL
   g==;
X-CSE-ConnectionGUID: VwKfy0EgTbuyaRvhpiCkaA==
X-CSE-MsgGUID: 27axfN0qQJu9Y92u89LWoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="92246512"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="92246512"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 17:55:50 -0700
X-CSE-ConnectionGUID: D94VrNDqS12fWXoUw+nM9w==
X-CSE-MsgGUID: TwDvaBS/Q6qrl8OnJjoNTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="271834038"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 27 Aug 2026 17:55:47 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzksj-00000000ADN-27PO;
	Fri, 28 Aug 2026 00:55:45 +0000
Date: Fri, 28 Aug 2026 08:54:51 +0800
From: kernel test robot <lkp@intel.com>
To: Zenghui Yu <zenghui.yu@linux.dev>, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, sj@kernel.org, akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: Re: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
Message-ID: <202608280848.9o0Z64CP-lkp@intel.com>
References: <20260827163953.83520-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827163953.83520-1-zenghui.yu@linux.dev>
X-Stat-Signature: dnctsuztyz518m86n9e5ou6thgsbe5rb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F4561A0005
X-Rspam-User: 
X-HE-Tag: 1787878550-840033
X-HE-Meta: U2FsdGVkX1/lF7LIJXL4qEBR0BgX3zXDNHrStZ8OvUWlSc/z16RdcrzDLfw69A7NS5UaIFScxi2ZtwBC6pc4oBziuCeHI2afZxVJzhI9nwcgt1nuUf563YWAW0CZqVvIDyy2F0tSznUVCAPQ7/EQq671FJPknUXwRWa0vFVisR2mOGrJjonhNZXNnqBU7QImyAITjyjN08uWwxlNvi1hlm3Fnh8INSZGiA0m0XKxXAclK/Y3j1XBxOzMKNpvXCyRvZ9JL4iCM/6vbBTXetZ9xeZlIpBx4sbbUSZJPjjbwhi0jJb8uin8IWhAX0i7ZSzXjTxZrGsNeiABls4owIdRM1M7OQvPdSvhztUEB1BXJvOQclWRHBlX3AXvPg292c+bBHZ3/VJQXDw50HiZNXbm9nApkhIcPTa4TsG0FDvB2LC/Khu0kDNp/bzcsnvzXpoY1gOkZGJWNv3hula14LyUw5DAQZ7Yobge1pjNimJpjtGapR9u2P7uLvH65wxnEATeN3k7/Q/pOKQ0DpwtzzFmzxb664JWmnoNCGdoQCx45QaRHO5eNIg6kwssl803qbT5TLWgRRtyHtxc4EaFIwOwtaPFe/OUBSG8Tlh6JNbDHkm7HSBxwnBINzpPaNVk1SkagRJEn25LzEb+CgEFPXsZpltInBT5cPzZvXeFrZO/QPAhdkuho8mAdvV2sisNOUPzZBsjTZ+cUpbioXSbLsLkB7crE/1divze2TyJ0WofbbKJVa6x2GztLXdrtzxesGIv6AOYp1qvmfRGOoGxTTszNGD3hSZ9xHCWqs1/wwFRq/Q6ZoAzjKd57jonjCIITrxJnybrNtjFgXJN4sj0yHWgc18vAcJmo2Qo2biLSM93ORAbmpgVb8HkzI82eZytY2naQewo9zL5NcD6vYJsariwZm5iq2xPvsIyG9dlnTRcsNE6cQe+WvK3VwrP0MFBbf2ldUcofBiOdGM18WOjUhq
 OpLw4eB0
 Yuf6EIabFQ/4+qaloCx7E8cJl6aLCcbb5XGOkoIz9VHEVTMcj46ozdARr+S29Mb2tOg/jPfC+iuMxbIr2+/QiKs2AbFEtnuWRLpY0F0ICbw6efcwdRTwlxy9A2dJnd5Vj03ifVvQzOGYrtoXMBjxvow/DT/npg+UesFSZfSxwBYHPMSsz5a8GTokTjT54dCY4ApUeMOG1cbdc26MGrb3MSCgNG20MkqIjH31V+arur9my3wEPIr+EXxXDZd9AWqAAWG0L6j91OeVu9e1R3b22vcupWl7uidTpeTZL0dPts4yuDttIfw4JZhpwbPIgzsJMWsrqfVhsIve+eiR7sI1nUiTdd5dTKtFlJ8Z5fAvudGfKxTGt1z9+nav3lg==
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
config: hexagon-randconfig-r052-20260828 (https://download.01.org/0day-ci/archive/20260828/202608280848.9o0Z64CP-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260828/202608280848.9o0Z64CP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608280848.9o0Z64CP-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/damon/core.c:1941:30: error: use of undeclared identifier 'kdamond_fn'
    1941 |                 ctx->kdamond = kthread_run(kdamond_fn, ctx, "kdamond.%d",
         |                                            ^
   1 error generated.


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

