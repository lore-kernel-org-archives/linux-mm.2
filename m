Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22440E9271B
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 02:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77BB6B0005; Sat, 27 Dec 2025 21:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25456B0089; Sat, 27 Dec 2025 21:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07E36B008A; Sat, 27 Dec 2025 21:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF0C36B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 21:02:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56BB3140182
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 02:02:55 +0000 (UTC)
X-FDA: 84267231510.27.02E5640
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id B05AC180003
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 02:02:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YtmxuZo2;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766887373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91LLRF+LJEzruR9Jf0r60m5ef0ENCWH72kVbs+WrYxI=;
	b=VQpWcEW2FOq8hOlngBv1h4bclGDLXS25oyTdOBkBS6hdwFWzKQyuBmxy+YIahngjiba9D9
	W/FVzcgPhWlCvQYQ9kZlPne1YnRUtAY8SgcFbbxSlL1FQNuoxq/gDiof5wOnc/g8/Gf14E
	MhuI8cnosR+tJZXRu3UKc8BPYfD9rHo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YtmxuZo2;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766887373; a=rsa-sha256;
	cv=none;
	b=QFARkfBVkvTWR1lHRFA8CNXbulzPDoeaRkZJ5pfDFkN4Et19p8Oj6DeOnG/Z6JLTUv+tFD
	BMYit5721pOkQnkf9UR3dfZfUXrmqU95kl9dmDdQyJ5kxGf4sWJ/L+yOxH2E/H7tHD/wNY
	sN815J1aSeP1cDPb31LWh/Iz1zdDqLQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766887372; x=1798423372;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=z2IaYp58Msew3QS/60tkLCoX0j0xeHozTFQSPz4iw2E=;
  b=YtmxuZo2DkzMR3ptFfxWnm2Yo3iP+T7eUz0Quz65YZ0+LLNKxLODKyI2
   dKe8J9SF00PLqgBM37ckMLR0BWCNd20SWJsyEx1EerPrbXo9IzpD/SOOK
   zr6SdkfGJXTyKlhjR8i5JwxdrAFAWiJOnbaz3k4fOCqQSUMpdFVdDekuf
   TNu6QJtqtigMK1iWtA4YbXrsz+J6Nf+g4c0OhBNrI9doqbelEHe318vqA
   0oEGphOpFEFEmZaQZt3zG9ToHgk3vCtMM1TH11anx5t1LsVw102nZpxSP
   Caw1WZZhx1OmbMAqkgH1CCpfKngsOorDGPosnK/alAjUqepa2kXnYm75d
   A==;
X-CSE-ConnectionGUID: 25Rb1dkHTm6rBHCwawitSg==
X-CSE-MsgGUID: KpGPBrGBTdyKbbXPDO305Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11654"; a="80008899"
X-IronPort-AV: E=Sophos;i="6.21,182,1763452800"; 
   d="scan'208";a="80008899"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2025 18:02:50 -0800
X-CSE-ConnectionGUID: fId7WcIxQQ6EbFuYnqCJNg==
X-CSE-MsgGUID: 21J7Q3W4Q/6LKmiB1y74FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,182,1763452800"; 
   d="scan'208";a="200936737"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 27 Dec 2025 18:02:45 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZg7H-000000006Bx-07Jm;
	Sun, 28 Dec 2025 02:02:43 +0000
Date: Sun, 28 Dec 2025 10:02:18 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com, mkoutny@suse.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huaweicloud.com
Subject: Re: [PATCH -next v2 7/7] mm/mglru: remove memcg disable handling
 from lru_gen_shrink_node
Message-ID: <202512280931.jlaLW51Y-lkp@intel.com>
References: <20251224073032.161911-8-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224073032.161911-8-chenridong@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B05AC180003
X-Stat-Signature: geju93qr8dxeckxqcpsjic1o1niidpr6
X-HE-Tag: 1766887372-855366
X-HE-Meta: U2FsdGVkX1/WQUKw68srDCToRRHYTw44EcPQT81orJyh1Rdp7YJX6uh/yT/zacBeZZw/JqC8eehWQRf49gcdhhf1QuWvVHbGT43GDCNlfF7PRa/de1/cHsJVnGe5eA9rUzAL/T9OmZ4Wf+rlPkMuAO+EyWkZZYyPuOnhQpGWVnOB0MaeytpUbGPKecPbSQY2iOSqfsesL8f/Fn+G3h2ISjpobIMii4LOF6+ncajpaYec82wItUSkYZjb5w2I2K4E9+0CRgPgKj9nBaO2sygBeZQO0RBQ4FZglXgN2ak9XfhpqOC+yqDv4wHnnrgyaR19xrCzY9aPnigOV7xTtiSNRuYEbkwI+ExCXGFC1ivA1o4+ku81pX3XqrlK592td/cu+MEhS2z65MdT9Hl/zjsymURuKVTr8RdJwjTFO+ylnXJC85WCNrL5dOTWBUU8MkwBKeOkeNbtYhkuPDCH0AEPRoNMlKHucSraZ3JFYM6H9cSk3dl/aqHpioP1qM5XFUI4C2sAlnYhFPUfYhb54pUm9NLnZ1frksOszEzVtJgeFOIZk7/mxw0ax8bjm5jqSSfl2+HykLd41gH6sszKEkA9c6Y31mgaiCb236TDEQO7AN6D/WrMN5c0SEYtsi8YVDN9146+g+ojneKttOLQOo3NRYio2+oZ7EnmozuOxnF8YIeyt98esHZQ2/zbWT7OI6YzpUgL8MVdPI7plin8Ok2h7Mh5J3BnYScpXu7S/rz3x8nrtND8VDqtQLw2cGutE4Gd98d125GSFrJyPL8giA36MzY49UnP08fQUzPnvYe8PoRoaj+6neBKGMznKMEKNxxe+VztlvfkYyDFWKfc5W2pK6o2ib4AFC2vtdMHG0x5N64vQ2IGrWSx7sF51OwGNV9HZjLPOrvTL+ogXXkMt6M2ZUrU8Q1NUEE1rgUgP5SyjfX/otO2aSTst5DQr/gqbm8uECBRCqKaV0Tqq84lxlX
 V4QnkTPn
 YRtf5h6KGmqB1+d/dtBmkWhZQjnjTiybbKWE+7yOIvH0rfqeLV4N4M+wdL2DrglYSBIz9amPV0/C1pDkeSRfCDIgE5BX+6p+vKQXKvN7LiJGlypK3K+EQtGl36H7bOKHfR3U1kWWuFw3TE0lCLzSB8t6btF43/jF2gYcRPDUGqwUxooxsgtQglx0l5zwA4k+vLpO1ZTtThrmlozkGk6hL58WS6huXEgsjgbDUBzxwBFSOybVmslAaoQVE3/ND7YpuWSUnAsg7t4Z3w83dCvsI9ip+0ifOUzB2iDDG4Ih19R2+abATeyTHqufCQQB9kAhKXQiLYBzqPSQnMsRvdcZuOUMKm/IEuCGZYPAu0lXpA7hi+Lz4C47dBPdvkSQhPr4tdXp0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v6.19-rc2]
[also build test WARNING on linus/master next-20251219]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/mm-mglru-use-mem_cgroup_iter-for-global-reclaim/20251224-154725
base:   v6.19-rc2
patch link:    https://lore.kernel.org/r/20251224073032.161911-8-chenridong%40huaweicloud.com
patch subject: [PATCH -next v2 7/7] mm/mglru: remove memcg disable handling from lru_gen_shrink_node
config: x86_64-randconfig-001-20251228 (https://download.01.org/0day-ci/archive/20251228/202512280931.jlaLW51Y-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251228/202512280931.jlaLW51Y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512280931.jlaLW51Y-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmscan.o: warning: objtool: shrink_node_memcgs+0xc16: sibling call from callable instruction with modified stack frame

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

