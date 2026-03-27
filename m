Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67C2A10F2861
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0B5B6B008C; Fri, 27 Mar 2026 13:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2A06B0095; Fri, 27 Mar 2026 13:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F8C6B0099; Fri, 27 Mar 2026 13:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81E836B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:46:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0449E8DEBA
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:46:03 +0000 (UTC)
X-FDA: 84592571448.17.81C128F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3D61016000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:46:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mCccbtx6;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774633562; a=rsa-sha256;
	cv=none;
	b=ZsEsXSEZgk0xelYWOBDIK3g8Q7wxTS82qggeLG2WoIh1QFr1fqXU1j+elSpKEtemYwkGVa
	oOSFYScGjUEN3wRy0t3xYzsnu/RGsuevdFLEnHeRa9WURT6UZdAJtXtukIJ/SoAPeKKA6s
	/zZO+3g0cWzal/WN/kHoQHQlMeIfdDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774633562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7cBPjVwMiav16Pbj59QAjmt0eRzJe1kTQmBALnMCmQ=;
	b=iajWs+r33lMa04j3Gu6rHG22xPPV4mBEWmksd8oI6SUMTgHCjFX5T4b+YC81sC/RmZKHDJ
	RzHC6UGvuhqusn2SO+7Xxq/ILOsFz5MrxuBC4odUmfzDtAxpRIt/MB3wrQfnMLBZNNQTOG
	5zS8XsZHrWqfjqJsXELsiUuWcjhk6uw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mCccbtx6;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774633561; x=1806169561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z/CH+fL/zxceLK7ru9wfJerm4tn4XlbqqXD2+K9ew8Q=;
  b=mCccbtx6cOon7UL/w/PTm4DtDkvCs9qqXikcofuBd0gqWRMFc8F2oqQ3
   FYLXnXKAeizpIo3iUtAztUTt+EYHc0AZpJEDNNdsCZaDhwyiWiOu5ZwsL
   GMwImVU79UMkP6qJDxSl+iMt26/rWGn1FiyK7DN3SeKt2kxQp6kX8xDSZ
   yvzasMO6GDQrm8bZcUQFJaHxG2hQ36G/jve+neBwCA/F+lGxLOyUZy1NO
   91Ra+SukWCFXwf9wX7a7f9lzyQwBPLPxb0R88vhUh2LGTGpEIdzBeJ8ga
   khz72JP63KpdVrVkXH49b9HMISkvq2OeH0e5LJD969rF/EE2/C5NWZisS
   g==;
X-CSE-ConnectionGUID: YvltILhTTc+qQbvTYPDoyQ==
X-CSE-MsgGUID: QZj6RZ7HQaybDAF2zZ65KA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="87099745"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="87099745"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 10:46:00 -0700
X-CSE-ConnectionGUID: AH8IA/21QmiQrQt0rorvmg==
X-CSE-MsgGUID: mLSgDg5XTiiWjXhKV+dBVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="229873595"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 27 Mar 2026 10:45:58 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6BFq-00000000AXt-3xVj;
	Fri, 27 Mar 2026 17:45:54 +0000
Date: Sat, 28 Mar 2026 01:45:29 +0800
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <202603280122.ldJtc5AT-lkp@intel.com>
References: <20260326072737.341964-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326072737.341964-1-objecting@objecting.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D61016000B
X-Stat-Signature: bckyhij6ekc7dhxd6k4n6dwqy9xdw5ar
X-HE-Tag: 1774633561-866790
X-HE-Meta: U2FsdGVkX1+sywL6CIGRkr9VpibDAIwHJ5tUmpq4a4+Pj0Ej/S3QWeoreP7bKqAF/BOnfG6JfLou9gJq8t1r6ThU2JBikUX2DbK7vBxjIk70wQtXJ6KlAQw057q33p2d1SG7XDiWa1wu4JATEe0iDf1FYYwDpCFQhW9vB7nlQuIP0FpLnmQxoaOV6yZF9hAL740/+hj0PEDk9Ut39p2mkRmc7x09DT06npmsSTSFjsp7xQkZfZwn47pEoqCFMXzM56GZlPZ9CXVen44AbPjOMlmDzLgCAA1pZ5/y4fesZk0gc46Jy/JVOtRm71vSAXD7IvrAFe16olWy/uPG0XuCcR/VvSc689EwH0bfNAw6e5jQXMt98lADk8Ykl1bczaYiPM+uNsBkYPC+hHC0miBVVnqF40GMgukbbByAQDUB+xoVV0VePG83OOptAG35ko8haiBnBk3Y+HHQC0VjJdUCn0REv3JcUpY+OHGw6DoOWNlOiK5p7Nl9ow0Kz1RnkUTMMIK3WM8cgdAKLDP6+G7DKzkW8yd6McZq3swF6OtQwjQetraZtqANYEMs25a/cFPP7+KHKX9Koei9quxJ51B9wXTtSxmcUXj5zc80i9Nb6Ptfa5apHeNM9AeOmBmOiONQtNM3GnZnXj1HTyAFD2xKqF5hzYZZdy5VYblZFTOS5JxIrZOHLyi68OsK+8/+q6JiUAf2X0vNzeaklyiKJ2DmQ9yzielK40SIWVO8iMrLziRcwI8YjLhfL7R+YxSxph2bBpdcvBeHcsT/QDBixy20ZeNfq5UL8BQ9w4D7ZkmL/7YFAJpHeF8D7YMFGG/TPmP3i+Db/GczJap/0k6pN4mRovh7wVZiu3spZgTMivSJVji/GnZxo3SzfK+4i0NeU2xubVbn58BvEzOAMpRyKRYXjWTtgFSrQWLADkmd/bA+xgOqZZiSBoaZtoCpPMEZ26I1purtSJU7BwQCPEzz+K/
 pvMhI3OP
 TKv2WvRG1c14UXUAgliLBX3OnwGjqCBk5tnULef/AV+NOtaXKYizumk+0BTRZP6ytKiob8F0Q7Lo6POyDMZQNvTAaBvJq4LffmBNB9jqsxfDJPqF9uJt2OacMIhPWRLSGB+O8PDLAxSg+0ClzGTY0fsHMOL1rb+pasPq8ACrdHtgW4gtQXiCPpSXrLU4/Kghb9HbRklMrTDufLdp/vnQ7Z/5Q/6CgjrxtRIOmSAlDFzn/zcZ+coHgkjHrjyv9Nwx3tr38m+sW/X8TFm6RdF607nKx1BRy9Oz6jQfzOKYj8Zv/laND1RisqVsnJ1AGqNCA9UgtH/OC09TfrG6OAtitCI64Bmcx2bMH5VTHO1a+JtWvKzPmv61JUE/ABNRDKa4j4r9C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Josh,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Josh-Law/mm-damon-introduce-DAMON-based-NUMA-memory-tiering-module/20260327-033827
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260326072737.341964-1-objecting%40objecting.org
patch subject: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering module
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20260328/202603280122.ldJtc5AT-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603280122.ldJtc5AT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603280122.ldJtc5AT-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/damon/tier.c: In function 'damon_tier_apply_parameters':
>> mm/damon/tier.c:280:15: error: too few arguments to function 'damon_set_region_biggest_system_ram_default'; expected 5, have 4
     280 |         err = damon_set_region_biggest_system_ram_default(param_target,
         |               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from mm/damon/tier.c:13:
   include/linux/damon.h:995:5: note: declared here
     995 | int damon_set_region_biggest_system_ram_default(struct damon_target *t,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/damon_set_region_biggest_system_ram_default +280 mm/damon/tier.c

   243	
   244	static int damon_tier_apply_parameters(void)
   245	{
   246		struct damon_ctx *param_ctx;
   247		struct damon_target *param_target;
   248		struct damos *promote_scheme, *demote_scheme;
   249		int err;
   250	
   251		err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
   252		if (err)
   253			return err;
   254	
   255		err = damon_set_attrs(param_ctx, &damon_tier_mon_attrs);
   256		if (err)
   257			goto out;
   258	
   259		err = -ENOMEM;
   260		promote_scheme = damon_tier_new_promote_scheme();
   261		if (!promote_scheme)
   262			goto out;
   263	
   264		demote_scheme = damon_tier_new_demote_scheme();
   265		if (!demote_scheme) {
   266			damon_destroy_scheme(promote_scheme);
   267			goto out;
   268		}
   269	
   270		damon_set_schemes(param_ctx, &promote_scheme, 1);
   271		damon_add_scheme(param_ctx, demote_scheme);
   272	
   273		err = damon_tier_add_quota_goals(promote_scheme, demote_scheme);
   274		if (err)
   275			goto out;
   276		err = damon_tier_add_filters(promote_scheme, demote_scheme);
   277		if (err)
   278			goto out;
   279	
 > 280		err = damon_set_region_biggest_system_ram_default(param_target,
   281						&monitor_region_start,
   282						&monitor_region_end,
   283						param_ctx->min_region_sz);
   284		if (err)
   285			goto out;
   286		err = damon_commit_ctx(ctx, param_ctx);
   287	out:
   288		damon_destroy_ctx(param_ctx);
   289		return err;
   290	}
   291	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

