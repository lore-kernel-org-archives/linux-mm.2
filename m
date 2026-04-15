Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00268F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412456B00A6; Wed, 15 Apr 2026 07:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2ED6B00A7; Wed, 15 Apr 2026 07:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8366B00A8; Wed, 15 Apr 2026 07:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16F9F6B00A6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:21:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA7F6C1412
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:21:06 +0000 (UTC)
X-FDA: 84660548532.29.50C6DEF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78401180007
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:21:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FRYiPxcS;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776252064; a=rsa-sha256;
	cv=none;
	b=OEW9vzzrgR9i5iOjDTw+/Hd20kGZrJeBDB2ltP/5IffznKbp5NyPmclPIbwuQ+A0AA65IC
	WrZXCeBvJnlRjMMQM2Zb+GuF2oTlcJlVDkpJ7IekstgsontpPzBLZByY+FrD1IxBUh0wE1
	F5D1JDSTwkxgrg7LyP77t8a57dfji1Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776252064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cs/nxVOA4CweHjvhAaTPlSDi6ZP+YTnuKXAknrFeoxY=;
	b=zYoTfUTlzBBodhLzYBJsgwBf5pg7Wkqh9x8Gcc8uEpKc/4OOidikFuqgHErFXJMpM49I7L
	We0eMzBG2q9vzS3qCU/BIhLnxZgB+AikU0/kDFtPwPXboONdG1S5A7lgc/fLi7bl9Uq0e6
	09nDwTT9o5ECm02+XPrBWXf4msBnKU4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FRYiPxcS;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776252064; x=1807788064;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GnUQiYR6RcFc756lrmlYngLn7X0Bum9ba/PdkJRoxdc=;
  b=FRYiPxcSo3jBE5tGpsWXSNRFCNINjYKE4xEiWhijIjrlAd1ReWDYpXEN
   RsnxjtEDW+OGu80sFtd/umXePqjS2R2H9VDISxQmf6AoZb3QOHU+02ubE
   NDG2XAmeJhCvuEwvBKIO4NOnOp1dPYrHFLuwMI9F1UvVIQc2pMtJxcIw+
   yeHMMARzv/Wb28LWVn+3eSAq+ZNOzhgTDx1xjRaPqd4t0F76EHKU1f25j
   YWJN1Pb/wQZGHNy5T1eSfzvsQVC3fShfBBFqsQBsYTDm0fXthqIPZ2r+L
   yvc4SBKkgwdwVxP4+DUKHUKNjq2hQU1OY+0biKdi76DmPWAO5VqxCL4Nx
   A==;
X-CSE-ConnectionGUID: sOORv/KXS4WU9jIDXnJqqw==
X-CSE-MsgGUID: 0AKJradAQ3GiioUHvPyksg==
X-IronPort-AV: E=McAfee;i="6800,10657,11759"; a="94626268"
X-IronPort-AV: E=Sophos;i="6.23,179,1770624000"; 
   d="scan'208";a="94626268"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2026 04:21:02 -0700
X-CSE-ConnectionGUID: Zb3V2/GOTT+zfPANQRSClQ==
X-CSE-MsgGUID: oHspvkrHTTuKSCuGrvejug==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 7f3b36e5d6a5) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 15 Apr 2026 04:20:58 -0700
Received: from kbuild by 7f3b36e5d6a5 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wCyIi-000000000Qv-06QC;
	Wed, 15 Apr 2026 11:20:56 +0000
Date: Wed, 15 Apr 2026 19:20:17 +0800
From: kernel test robot <lkp@intel.com>
To: Yang Yingliang <yangyingliang@huawei.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yangyingliang@huawei.com,
	hucool.lihua@huawei.com
Subject: Re: [PATCH -next] mm: make sure freeram is smaller than totalram
Message-ID: <202604151917.t6ckjppJ-lkp@intel.com>
References: <20260413115736.1237680-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413115736.1237680-1-yangyingliang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78401180007
X-Stat-Signature: 4f3hii3i1uw4nprnth17b7opj8t5xsx6
X-HE-Tag: 1776252063-205309
X-HE-Meta: U2FsdGVkX1/S/tgy6LnvMkuGp4B8/Jxn2EvqQ468e4lBAWa0TSnbOfVcGoHWDEhfqrG+zRc4+LPFbZbU+0bQlx2I0rmovLrOS3doSVN38ahwYM2WLk2kINZ/T5C/7xqoeqtmlz6uUrtH+luRp6+yZpY54W9s2Gxk/EtZAPWxZ8bRFof1ZRMDnXK1FiAHbCdXz+slPEckpMI57Ucs3f97XuzOqi0mPm9vA1Bd5v5F6SFSlUssMalfSnfNwTJvZ4t3AYK0nSMrldghRhoal8/jjgJI33XL+pIBtq94EXf2MF72FcE8VD/7Q0ht+rDkwknTeb8aLveiIlL8sCvW8Bm9LRd/DjzrJzPZGC6hJNmkR44LuGmhfltdFkXjoFZgNDR1xF7r8nxLuxDKwWHieobUYq+YZ+F+P5DXSJb6rcfEulAZd47LTP6+2M1YELxrH1bmLBElNKUeBO2TQ1AHd6DT3L1Mkx7j+x3kGP5CBugO+GXkw268qhXWKZlPSA/5bYt+pICDKi6zZcsTE1GwkV4QLYk4YPrPr+CpphPHr8U5XZ6Q9s+LWvjiW245Ixr60m9YLTdi4vtb4v/VzD95TSRc5troIsbdnRAUpMiDRnjf4V4oJOQKwmoFURZWtkijKbJVNjLNT0dmDZCPe1MbIDqqfVs9JLf1M80pl4NvayT7MUMFD2SLv9Wlr3jTlVW+hkFv+NIg+nBZK5tJnu1v1lV/9dcmsX+1kZ7zWqBhW6ZIfx8Mdfq/5cNnAUGJH9xDeTVzqNWMKT0LQ50r6bekzjXoZYgl9dkkfA4idmGDTYp2jmPzthaBQHne5uyh1JE4Lcp+S5kkFwmlzZ6o1fZMN9oxIF5EgXSk+eaZ/PTzrMec9pjdYHVKYOaIMMMUfuDWli8O5g3cuSKw5a5D3efjIT96sb8STQ+C2/Lr++cLJMKO79oFB5eMUrTP//Dh6DEdPWXPNeXRJhTcda6e1BCYZI9
 I2ZFpTy6
 u/QukxWNuWhqa1//DcIJvLd34/zvdOEmeUV9ZK+AP23T5vJ5WaP844G4Hu7creFRBh8ThAIcVUaSBG/RTHkFRSr0kTpZ7m5LAKfrOTXV07ERZpkDRt2K5EJ3KQM78QiTdq9Qsjcw60WzNdo7XBZD2vS56hVzP39BkdnsdTeEerZ64e8CNLVZ1VsNjTj2KQI7yZulmtj1DXo0cs6SUudeVabZKgFk8Pzq4CZL7Wc5I8DCq9frg64r6VCyERsamGdktQVpWqR3pcaCMkgZwwO3u+WC7SSO/knxBV9ZIXt7J+xQoBajkTPbx1mvNYDu+q0UfvIsmXtr/6MO8AdijhrehgbSZdqtedhmexkBL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yang-Yingliang/mm-make-sure-freeram-is-smaller-than-totalram/20260415-122059
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260413115736.1237680-1-yangyingliang%40huawei.com
patch subject: [PATCH -next] mm: make sure freeram is smaller than totalram
config: arm64-randconfig-001-20260415 (https://download.01.org/0day-ci/archive/20260415/202604151917.t6ckjppJ-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260415/202604151917.t6ckjppJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604151917.t6ckjppJ-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmstat.c:884:13: warning: 'refresh_vm_stats' defined but not used [-Wunused-function]
     884 | static void refresh_vm_stats(struct work_struct *work)
         |             ^~~~~~~~~~~~~~~~


vim +/refresh_vm_stats +884 mm/vmstat.c

   883	
 > 884	static void refresh_vm_stats(struct work_struct *work)
   885	{
   886		refresh_cpu_vm_stats(true);
   887	}
   888	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

