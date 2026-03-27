Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D0110ED669
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E63A6B0095; Fri, 27 Mar 2026 08:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD866B0096; Fri, 27 Mar 2026 08:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D37E6B0098; Fri, 27 Mar 2026 08:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC6B6B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:51:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA389160FC4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:51:43 +0000 (UTC)
X-FDA: 84591829686.01.F2A8C6B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf03.hostedemail.com (Postfix) with ESMTP id E64902000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:51:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C9y2ghuu;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774615901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7eJlsYWA6W8YXtEfvCqWmwAgt7xOZLcbwrCQkHMj4oM=;
	b=E139n5NcjaHJjqkZ3kmep17ekLDI4UZFKKhfsb1NQnpb98iqL6k717jcaisCwSkhDI7Vn+
	VcMyAd1hyJADcrkxMqm7g2umxgm9w16B8r7d/bigHpA6c/DfaXh5Tux6MhD7LCZCrvfr70
	PpF81h73nTCsInOFCdOS2Hv/LbEl67E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=C9y2ghuu;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774615901; a=rsa-sha256;
	cv=none;
	b=KcKbbCKdazEX9Ak7VgvpRU4etwJmfV4+SxwdgdF87o+mdKACUKZUq4T1heJmGhpyZXlDdY
	eonLvBKiBoF8TA3l3vQk3fpOc8ft3sAfWFu6AtiBAJu17RaT7eisxC6AXjxlAPvrWulmj7
	6D6WKoIpLjkjx/PwnoHNEVaZNrAvv4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774615900; x=1806151900;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=igR2uwWnIP1vFte7MCw7gFeiS0hftkmp0XPSK5xd0BI=;
  b=C9y2ghuu6+KHNvJslhJF33/NqF074FAFMrGPvg9GyRU0NN6cDQPzza9t
   K6MmlP6dnArOJkmOb/HeAwPnZ75Z1WL300W3iQAnVYZ4ZpUOylgzfm4gm
   RmAHKz/8JDsNb9GFmklGBHsQZRCE/0/MlJusP0ZpFk36INooD9qx8BHbG
   jW0M2s1LPSfEF75LGNL0EVmyw3zNOaYx33NscQAyQRz4g7x6CDs2IsYBy
   xBYXqIfxPVhdMiegZ+f0qxgo8x4pOWkNZNZ6WQb+VtjgS+V96AgBXAG1P
   kn6L2zGsA8gvF5heRNLaDpBETDpo742GBBe23/ydC67jBT6G8WYoRLIWs
   w==;
X-CSE-ConnectionGUID: qHnYEo7kQ72NbfSGfu69Bw==
X-CSE-MsgGUID: 4lm/337+QECZaxtzlx4xFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75568907"
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="75568907"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 05:51:38 -0700
X-CSE-ConnectionGUID: nq3KOzv7TLGgC553Odh24w==
X-CSE-MsgGUID: Uc94TcatTb2g+eOOvM9m6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,144,1770624000"; 
   d="scan'208";a="221981797"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 27 Mar 2026 05:51:36 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w66f0-00000000AIn-07pQ;
	Fri, 27 Mar 2026 12:51:34 +0000
Date: Fri, 27 Mar 2026 20:50:37 +0800
From: kernel test robot <lkp@intel.com>
To: Josh Law <objecting@objecting.org>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <202603272022.tcaGCvSO-lkp@intel.com>
References: <20260326072737.341964-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326072737.341964-1-objecting@objecting.org>
X-Rspamd-Queue-Id: E64902000A
X-Stat-Signature: 56pgegztt99i4hhpx5ctc5s66rqyrsqb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774615899-404523
X-HE-Meta: U2FsdGVkX1/Iq9Fb7X/NAyEne3jSQKxVo1CK6J8QS/P7K3RfPS0JH5447VAkl3pMN1NPMBYRSGCPxPRaOzcPKClZK6o5bVEIkGb4lVLzMlUI3UoBoKUK988nJRRpHFzGV21X1ySGv4FsUr5SVySmBQZRj/H7KfbmOK6Mf+FZH64WLrL43S7zUFVKhO4qzx0lpaQjiwmwlB17m/5ZwVz5+5CWcgO14fVJ28dVtDhqtqNmtdueLTrgT0Lb5uAgBsdDzO0pRKkywLgGm0sfed3lZWxs0vg52f0cUtGPOgEmVweOY0A8gUbiSZlEAf3KaqKAoqUBWRxCskW7pHGFvVO2alWfBp7FeFLCJLb/bRff1IQCz0d8ktgX+F873B2JpwwVVIJm3kTTSgHAXPlDCOU7806hf0JW3F1GNMsRJ00PkfamVMH9alQmYmkVoT3KIMKJog3AxoTFbPo5G18axr9Sr+SMF2dpixfZHDd8nR+U0opqR784v9tSg9oWwOrgw8HWBKEqin+vsJIyaWeMmOe+DTXye2g9f3IqshB/+GAe339v+hrUG3dA1pxtfqTad8YmKW8XtWMt0QjbVqKfJVolftUdxUjLB97D/FeXKDgvEPdFNVX1ZM171OHWNEfPDWGPOCxXYv9mrOUdoIgNcAiFoJtprdu9DNdwZub5MOILev2YzYfYTa/xb8u0keo59cQZn3gZpZJTYbRIzWBlCW/W5ahSmkxHlb9aZSX1H2vcVVkS9q4IZY3KA9rUeC9A8CsZtK7hhJoLZx34MyWA135PAsayH5s5efssKIZQa2popDl1AVX8DmvOuzfUBf2bn8N6DImDgkqwU6GsXzhxRUovZZGrKVHWETQ3J3YJI5M3UfDxRQx8nMQ+gKaWzli4g0VtwROJH2q9DxGvTrKOK2dyU2cWxKzZ95ERjU5/RNH1/Z87uoKObfgAhy5kQrb6Y+yIAmQF3wd4vv2JROcQLi+
 /cIzz3If
 vVlrVserU2TI/KH/ktLviRD0qCD3d9cIGlenQJWETwoiHWKj4dL4qmQksgu0jL/OdyVQF+jlNZwNHRSltj+1Ks+FJpTaR6N+rOURo1iyHF8lJzf4E1d6fKrmcMzXtHHlRANY+YImRkfqqxrSeq+j1ybjaRkS8fO33pD5dCAAvtkWjmJJnOaptNBRP/CDwaD7F9y6GdIBYlUjXWlQzV0mYhAsdmuNIVXSAYMo/o84fG3pfkJEd+zKq8jBLokDeEZ4xq1s/cC6WmOhjNatvXJ1uKLk0yXm2ZdJw23CXZJZlb85UnLxwhRmLtE9Z3S1QSyLIzzm9x6sISSqs2qP8aFiYZgLdeAErAxxyo9i/rcLK44cZTrgeLM/iBTEgDLsC988Lve3r
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
config: riscv-allyesconfig (https://download.01.org/0day-ci/archive/20260327/202603272022.tcaGCvSO-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260327/202603272022.tcaGCvSO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603272022.tcaGCvSO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/damon/tier.c:283:30: error: too few arguments to function call, expected 5, have 4
                                           param_ctx->min_region_sz);
                                                                   ^
   include/linux/damon.h:995:5: note: 'damon_set_region_biggest_system_ram_default' declared here
   int damon_set_region_biggest_system_ram_default(struct damon_target *t,
       ^
   1 error generated.


vim +283 mm/damon/tier.c

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
   280		err = damon_set_region_biggest_system_ram_default(param_target,
   281						&monitor_region_start,
   282						&monitor_region_end,
 > 283						param_ctx->min_region_sz);
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

