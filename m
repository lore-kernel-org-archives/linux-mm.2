Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7528CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 16:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8348E0047; Fri, 10 Oct 2025 12:14:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89A48E002C; Fri, 10 Oct 2025 12:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77F28E0047; Fri, 10 Oct 2025 12:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A316A8E002C
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:14:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34ED5119DE7
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:14:05 +0000 (UTC)
X-FDA: 83982701250.11.E8BE283
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id 837DB1C0017
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 16:14:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hI/5PRwY";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760112843; a=rsa-sha256;
	cv=none;
	b=xq+Tb49FujhiXOdlCtNMrAqzYGgPDSbBJE5KsCOQGJwhVwfdjrWProxGH6KzYsYxTGiQxq
	mP+B6/no3YtOngyW9pfnt9D8vN4qw3aDHISSZK39+RMyXnNdq6HZU5HZPlQc3AMlQTLiYo
	pcq7e2zac7p/VWvnpeyWe6rzplMjHro=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hI/5PRwY";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760112843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPcp5MGpoD6xujB9lt/m4eKdYXr6SEIO1soXC9C9BUE=;
	b=3ioLLy4mgXRYUrUostrGQvbkFoguYAmNQ2Yn/nywKfP90t9lAdFyZd/pSEGnTDyFR8qDva
	jKBCPmk0/7uKP0x8w18bleILG9CcagZlRCRMo4o3AzRKX8Vp59mrCorF9yZTmg/64I/zC+
	zbMHHYSFkEMrnzm9iPhFXkR5tycpCOw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760112843; x=1791648843;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=r8lG5PY+ABtxRfWMyUbSWrVWqHmAuGupMmW6GEw4j5Y=;
  b=hI/5PRwYJpX+PKcSODXK6wDdFRUkbANpJkLq0POtpLFeI5Fp7iYMu6iH
   bXhbuJw1hZuChS6pTyMbwGd6CVvGD19wzviHphhPKFPgAmI2p/39v3x+l
   Km2DjgBD7LmeWGGYLxV77rISC8uPkZ74gwVn5ee6A35eZi5/XUaH5ABK5
   iGCSsQnY/lDko0/lN/kG10ffH7kugFErgVvC+J4eSOZTmXssAwXQSOcnL
   qKu3+6g+rWOwSaiLR0VEUZDRMc2CrgSemtNyQHQ9y10c+uL2DmgBXbK9q
   sk0vyWCL/6rq9u8NbDR3SQYjP8QCpD/9UZMR+qcb8JoA5W6RtlZ52A8Is
   w==;
X-CSE-ConnectionGUID: 6fLtA7MWRnOuaYFtWesBNQ==
X-CSE-MsgGUID: tHgZqkoYTze1n9B5w/8B3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62037856"
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="62037856"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 09:14:01 -0700
X-CSE-ConnectionGUID: RYXnv2CBR1qMJeNJz+4Dmg==
X-CSE-MsgGUID: GvanR2LkQ1m8cCrFDCZc5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,219,1754982000"; 
   d="scan'208";a="211961209"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 10 Oct 2025 09:13:57 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7Fkh-0002wj-1D;
	Fri, 10 Oct 2025 16:13:55 +0000
Date: Sat, 11 Oct 2025 00:13:50 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>, acsjakub@amazon.de
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	axelrasmussen@google.com, chengming.zhou@linux.dev,
	david@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterx@redhat.com,
	xu.xin16@zte.com.cn, rust-for-linux@vger.kernel.org,
	Alice Ryhl <aliceryhl@google.com>
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <202510110039.N3gHQwXj-lkp@intel.com>
References: <20251007162136.1885546-1-aliceryhl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007162136.1885546-1-aliceryhl@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 837DB1C0017
X-Stat-Signature: owcrt8orj5scsuwcroo5bn657mdxq817
X-HE-Tag: 1760112842-620576
X-HE-Meta: U2FsdGVkX18X58kJaE31t4qbD4F+jxQJr//lVCf7BLLxseSaKO/ZmG6Y9pBn7jxDE7FWu1BLvkfORH7Aj5sMvbF9ySBzwIujMthmF6ixa52d6tutGqrj18LTAw7UjJUajeDsCHqArgjiiMBUZjh6e8D9nV3e56djqR5aacEqKPUCxMOCL4klmHJZKaLbvKfONmE45ngHus3myzOvSG6PHbcgjkqkHdKzfSqvecjMBWLp1Ol7ed7ezteL05CY/FQpctjM3urIdN0VouCxFbWKYFE0fwwOLX4tAsQp4KRcTOdcqgsR1+u7v+EyfaWSEWzz9DLnmzgO38w3Una0lLBb8DQL8Tuv9pH7a0CYk83e1lI3WtGAIEBUwNCgqIpgbVPrVW2nElFM1SBUpZz8mn2lI7RsdgTdZ25KuRAbjlpZ2jipFns6Qu/t1ThV230o5N1ZZy1pYkH86U7XJ5z3jItUXqWDY1p5lSt04pGqGHJ9/qYIvRM+zm2XqOasEfCyx7njr+lb+V964rQDA2K8fB5b5E/Kfsp6fMrQKWp4utUdMQxHHHIF2M0/5V7JSLHSP5IdN4mJsSI0/cI7LBXVNbJzNPNg2adYcICGke3hD8Hq7jQItnS+4vbElAwddb86gjKqa6llGkS08osF6wuZmg0f8Xb1pvkaKdxgTRN84lKUf0iiQ8vufmsfAdRifMEuXNoCsH4vRQQCq/HviL20HRBd1OcNjbzI0WJJQrsyW6zi9BjjtcBHBuyyLW7DDXRYmn2hxF4oC35B/nL+mtCJAicuy6Aa5IT17sHYs+WfbcVqKT7JvnlzlOoHUiuUtca2wssHbuzn86TEJZ764DvhjksI69E4LJlXJYljm72kxvfPFUrl8Dw9iqiMfoXdb4D4ieA7EI9UuPnBOS5xy5nuX10onPNqGsTnR91VjHIijs7tMPcArTSPoWY4m11ETD8MtPDkRUOmkm2VIq/k2qMXypZ
 NPV/mKvf
 AMpdVpzR1qxSuoDfn2guIv6riwLpuiiBkj2gT/Zi7od9dg7Qh9M7USB4taY7IvCpdng042Fja3GxptYy5Yf+vsmIDvuoHadvQGb5DSc+NfxDl69RN1Qi8BpCirXY3iP5TJkmVfV20C7KaqAbkRjFXChoSbt2j1/FdNixRffUFZiI8vmhCU6MknfYHF0nsFUNsXsFJFGZo+v7ZtQluwZicypzNoNTCcethAGw077rkI1oUS1kTaNun/XUUHkR5SMtSMeuRxEKmi3GrxZgd/eFyY4Z6fxC6EcSCnVfw6EcPCDLZFqzDys+dzyAbFRlNuQ9QAEBBUtmalJ7aawfcmsktNhtWSROqC2vcPD9URUjeyoHt2/dA82zIeYWJU133hli0j+2aJDvp6tAhC3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Alice-Ryhl/mm-use-enum-for-vm_flags/20251010-095004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251007162136.1885546-1-aliceryhl%40google.com
patch subject: [PATCH] mm: use enum for vm_flags
config: x86_64-defconfig (https://download.01.org/0day-ci/archive/20251011/202510110039.N3gHQwXj-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110039.N3gHQwXj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110039.N3gHQwXj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/pagewalk.h:5,
                    from fs/proc/task_mmu.c:2:
   fs/proc/task_mmu.c: In function 'show_smap_vma_flags':
>> include/linux/mm.h:353:24: warning: "VM_HIGH_ARCH_3" is not defined, evaluates to 0 [-Wundef]
     353 | # define VM_PKEY_BIT3  VM_HIGH_ARCH_3
         |                        ^~~~~~~~~~~~~~
   fs/proc/task_mmu.c:1184:5: note: in expansion of macro 'VM_PKEY_BIT3'
    1184 | #if VM_PKEY_BIT3
         |     ^~~~~~~~~~~~


vim +/VM_HIGH_ARCH_3 +353 include/linux/mm.h

63c17fb8e5a46a Dave Hansen 2016-02-12  346  
5212213aa5a235 Ram Pai     2018-03-27  347  #ifdef CONFIG_ARCH_HAS_PKEYS
8f62c883222c9e Dave Hansen 2016-02-12  348  # define VM_PKEY_SHIFT VM_HIGH_ARCH_BIT_0
9f82f15ddfdd60 Joey Gouly  2024-08-22  349  # define VM_PKEY_BIT0  VM_HIGH_ARCH_0
9f82f15ddfdd60 Joey Gouly  2024-08-22  350  # define VM_PKEY_BIT1  VM_HIGH_ARCH_1
8f62c883222c9e Dave Hansen 2016-02-12  351  # define VM_PKEY_BIT2  VM_HIGH_ARCH_2
9f82f15ddfdd60 Joey Gouly  2024-08-22  352  #if CONFIG_ARCH_PKEY_BITS > 3
8f62c883222c9e Dave Hansen 2016-02-12 @353  # define VM_PKEY_BIT3  VM_HIGH_ARCH_3
9f82f15ddfdd60 Joey Gouly  2024-08-22  354  #else
9f82f15ddfdd60 Joey Gouly  2024-08-22  355  # define VM_PKEY_BIT3  0
9f82f15ddfdd60 Joey Gouly  2024-08-22  356  #endif
9f82f15ddfdd60 Joey Gouly  2024-08-22  357  #if CONFIG_ARCH_PKEY_BITS > 4
2c9e0a6fa2bb75 Ram Pai     2018-03-27  358  # define VM_PKEY_BIT4  VM_HIGH_ARCH_4
2c9e0a6fa2bb75 Ram Pai     2018-03-27  359  #else
2c9e0a6fa2bb75 Ram Pai     2018-03-27  360  # define VM_PKEY_BIT4  0
8f62c883222c9e Dave Hansen 2016-02-12  361  #endif
5212213aa5a235 Ram Pai     2018-03-27  362  #endif /* CONFIG_ARCH_HAS_PKEYS */
5212213aa5a235 Ram Pai     2018-03-27  363  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

