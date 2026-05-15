Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9CF1CD37AC
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 03:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 274676B0005; Thu, 14 May 2026 23:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225906B0088; Thu, 14 May 2026 23:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1146A6B008A; Thu, 14 May 2026 23:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0BA06B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:21:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A46421C06F0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:21:35 +0000 (UTC)
X-FDA: 84768204150.09.C85C0B4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8F89100006
	for <linux-mm@kvack.org>; Fri, 15 May 2026 03:21:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LneUVduq;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778815293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ni8y3d2spGaSnAsSjHCjCiBxf5TnsJEzmZx7zFuGwt0=;
	b=z9CUCEql20jQmwhlXW/pkzXZ9zroGs5zTYUoKqcXHSmp1BFrlI2sxH28XtwKzfv8TS8oeD
	HwB21GoQ54VFygmHu7qFspqwMNLB8GBpWxrV52ORJToNC6uVqOOyWhkLEMtmW/RPI2b44w
	I6TOVponxjRFqPKvv2YdSiT1LA5nBg0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LneUVduq;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778815293; a=rsa-sha256;
	cv=none;
	b=wM8tnHsaNRMqXMZpM3/mC3dB/INK93m3/mnC+VWMimYBzVqXGNyq2Qu+8kjcpg9bbmr2A1
	YQ4OuMnYr2dFvdSsCbRe4OXIBKMt5Z3B99M9900niB7+s269trIZAzob8Z1Oq5qdzwIgNu
	XfaorbLY9nBcSbMJVgRDC88LOyUiO5E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778815293; x=1810351293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=N/8yb0A/BbnaMtt8A+R96LkfjZ6A2OCd1LWsiX6DOG4=;
  b=LneUVduqUx2NEEtsLUXK5vsiqmRePV1CDFdtoAqxpvnrE+xflncXGSji
   1J4HjQhbI8wQynjkM6XKciPhQqkQmuV6HRkDifPbTQwVJnqFC+Swaqsy0
   TKw2iV0BUs1yUyb6g8sXX5rO8S0BkSc4EfeR0krGmV5wkuigyoR4DQEFG
   O0/gUcp8o5JSJr+qtM1YpL1NGMhdbJXPXsWFiS8808gtzYoEctRqNlUjS
   ftT74fhImjuwHq5bYdLPvgedIp0KpYDfaLh3YD1KhUYDdovltpwSVWfin
   H5qR4JxlIoqj9tbdGgWae9jVswhb7AkVLoPof41OVj5Q/0f2wdnC+j8Hr
   g==;
X-CSE-ConnectionGUID: t4+2wSdZS6uRu8fEiPrnFQ==
X-CSE-MsgGUID: gTcKxJsISKuOxGgo30YE8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="91150691"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="91150691"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 20:21:31 -0700
X-CSE-ConnectionGUID: lMpQNfPqR5+oJkGArwd0yg==
X-CSE-MsgGUID: LXJ6MsJHSRyNFKkq6f8daw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="238448610"
Received: from lkp-server02.sh.intel.com (HELO 7a33ad3e7d27) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 14 May 2026 20:21:29 -0700
Received: from kbuild by 7a33ad3e7d27 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNj60-000000000jF-2NWz;
	Fri, 15 May 2026 03:20:24 +0000
Date: Fri, 15 May 2026 11:15:40 +0800
From: kernel test robot <lkp@intel.com>
To: wangxuewen <18810879172@163.com>, akpm@linux-foundation.org,
	david@fromorbit.com, qi.zheng@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, wangxuewen <18810879172@163.com>
Subject: Re: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using
 guard()
Message-ID: <202605151100.lH0pRo2I-lkp@intel.com>
References: <20260512085546.368911-1-18810879172@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260512085546.368911-1-18810879172@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B8F89100006
X-Stat-Signature: y7je5hs9idtttufsqo83k87cm5kyuas4
X-HE-Tag: 1778815292-456939
X-HE-Meta: U2FsdGVkX192byiwHmko/tnbl5xuZ1NgcdF5FpbOQZxsTTRUfW/I0fOCbOpaAs7gD/l4DZ9P9f6HM2ysyfVw5rPLTWcYo7dttaeTePBfK/grWQI3wMCQrGslporgg4B+sbwOVcMCsy1AE/pEVY8FChIjWNuqLwcPdOIp+qNnpP9znYADhTSzXhvgOrsUcAEEGmz/QSW22EuOZnLE17D21HSZtvpx785abCfx0YGAZkddFNC5Z5l5mQgfzdwlBGpw7mVsxrSWOpTirVGaOPz2+wray01im2vZ4FfjOn6/zGRZ/h1LrUQmW0irgz4w0FVYJy+jBtzHAXsXLmYREsv9ewtn5nPmDwggn9Mp/uNP0yfJTcwG6saLaDwoLYpoaT1D7IVTftk8XUEJwghrRKkUsCPRIbuDOjCR3z6DRzC6G8KBrIUESbnXHA7mw/SWVc9jZ9jYmarxVyE+ghsKJe4Pulniyt/tn8KkdPN0AZu6cZQLngU9i5z30rTxqyncmMknU3xX0CxZ3xsy5GW2IMZ3WT+jGrWvVy7V0lZISwdzmW97PO0wBxgZHz6HlhqyQ9gQFigPObCRHV4C59S0KSnCdw3HOrbAIB9ACXlOz0jseREhkYe+IplHDz4DaBNTBcj+Q6jApQudPauVSVRzlIYRh1IWakOQaBPKFOb8Kegu9HK9cpP1EeH6jZ4OLwMRwXXHuVTMQRo8RANZqGumfcaT/YHeP1kyC8ubD2gKCMAeesty1P5XKfemznivL1nWZhFrm5n60O4a0TzgJRu7HF1Y+KK47wYNGOcL9Q9W8LtNEl8ZOLrIoyt0eW7ay1XD5UigM5NEXVoAeh1fD6Ypdr2khIhGSpm4pCy1cUr/bNUSnBXHGe2TyKeGoFcLfK14aMCJa7K/FatODuLh8W3vI5oxU9/GTIhPD/e1oRC5kEzRCiOfXKO5FT7qXS9izkz2bc2Mj+Ky8XlFUZONhk/oFjE
 ytC7D2jj
 1jQCcL12RsYV2mFCfllqBNTgQxKcxGsdGWvLhS7Ce03eC2xw4sBKLa1d/Qa0f+COrh1DQdWBExExgdfirUWRRJZKAbFcbAlwnbITHngZAgHk6b52hSoFqphEWfTYl7RSKkGWtd2ptiJH4iD8EKY6aITyRfg9GXCiC8h/+4ts3p8aSoBYBQLJ+iTUoU+stY+MD7735kdJ1e02JHu6mMrwMw07BDuSfTg3O6hq9GCKMFf/R1vUGGQGvulYGmtt0k3uYnWNho2BUsgGycvEM09yhfysR4Nv0tx9r01mut0gdO2TpT/lzac2sXYwB/qWdwLimEp1VovrhBvl3oAb/BoTsDvRyteOY6FPms3r6DjKN85NkPVunTiZ/lWga1JAphNpX2fKeTOlCPTah1HIhiK1bPvXakMA9UtvmLDxj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi wangxuewen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.1-rc3]
[also build test WARNING on linus/master next-20260508]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/wangxuewen/mm-shrinker-simplify-shrinker_memcg_alloc-using-guard/20260515-014803
base:   v7.1-rc3
patch link:    https://lore.kernel.org/r/20260512085546.368911-1-18810879172%40163.com
patch subject: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
config: sh-allyesconfig (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260515/202605151100.lH0pRo2I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605151100.lH0pRo2I-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/shrinker.c: In function 'shrinker_memcg_alloc':
>> mm/shrinker.c:218:17: warning: unused variable 'ret' [-Wunused-variable]
     218 |         int id, ret = -ENOMEM;
         |                 ^~~


vim +/ret +218 mm/shrinker.c

96f7b2b9bbb1d68 Qi Zheng      2023-09-11  215  
48a7a0996a0089f Qi Zheng      2023-09-11  216  static int shrinker_memcg_alloc(struct shrinker *shrinker)
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  217  {
96f7b2b9bbb1d68 Qi Zheng      2023-09-11 @218  	int id, ret = -ENOMEM;
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  219  
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  220  	if (mem_cgroup_disabled())
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  221  		return -ENOSYS;
03375203e1da8f4 Michal Koutný 2026-02-25  222  	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
03375203e1da8f4 Michal Koutný 2026-02-25  223  		return -ENOSYS;
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  224  
5ce02a6f6282d95 wangxuewen    2026-05-12  225  	guard(mutex)(&shrinker_mutex);
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  226  	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  227  	if (id < 0)
5ce02a6f6282d95 wangxuewen    2026-05-12  228  		return id;
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  229  
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  230  	if (id >= shrinker_nr_max) {
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  231  		if (expand_shrinker_info(id)) {
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  232  			idr_remove(&shrinker_idr, id);
5ce02a6f6282d95 wangxuewen    2026-05-12  233  			return -ENOMEM;
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  234  		}
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  235  	}
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  236  	shrinker->id = id;
5ce02a6f6282d95 wangxuewen    2026-05-12  237  	return 0;
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  238  }
96f7b2b9bbb1d68 Qi Zheng      2023-09-11  239  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

