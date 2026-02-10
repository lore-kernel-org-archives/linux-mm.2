Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D18F0EA3F13
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 08:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CCA6B0005; Tue, 10 Feb 2026 03:06:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49806B0088; Tue, 10 Feb 2026 03:06:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72D86B0089; Tue, 10 Feb 2026 03:06:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7D466B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 03:06:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 774F9140404
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:06:36 +0000 (UTC)
X-FDA: 84427815192.03.60AAB9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf22.hostedemail.com (Postfix) with ESMTP id B01D4C000D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:06:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cbEIgqXD;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770710794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkjbnAogb3cG1YBqRmKi54uXqQ3l1mbevipFUfi3h3c=;
	b=RiqkRpAkAaxWqG3yqQPs/gPuohUNjqL5A1BU1jMH9z+3XazqZ54uzFpzDxfY/TiSuGMQ5j
	pDLIDPjZk/IOUm6a0p5RV2r+4NZUFd08av/DGNB9C7E008Qrnc6NXFX21k1GXjxZKMNeJ8
	t9XZR1nofuQAFEwnZZir7RBGFz9yjus=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cbEIgqXD;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770710794; a=rsa-sha256;
	cv=none;
	b=eJo85YNpPYNJePkIT17E+G574PdmRIGU6Xtgll8HhOxirYmhRuMl0yfZFDmXXSfLi2KhD3
	2lJKYunHrzQUEAShTnQiy41H07COZxTNW+x9ypFi8zDMKtwJ+x3qWYmAW7KdTESXNUIPvj
	JXRdLNDaEEItjzd1+gKf15lozyKV1wk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770710794; x=1802246794;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H36GOnCGhjb9xhDgS/moSGRxSG0vjpQUoYrBWV6lwF8=;
  b=cbEIgqXDxtfczFbjKUlUyMMeatt5mKvj1h0MANxroSYuf9ZEpr/MZDAc
   dM8AJcV9SF32GnAIjIJGv8MJH1FE5bft9/Z9v9N89EH7w9QN7fzBgvK0U
   NzhrLtwBOqlf4r2sc432FoZZV16JoVPuwbIzj7p2nKgn6mVJ9Hk8UEnZi
   zXZwA6woogWV2Zyau73n0UqhKEoUu5pNxdbbR2LyEf8lYSHpUEw10qDSf
   xUTCTkh2wHZpVsKdN5gbbbnOg2J38z8E6PbRNJfOmJPQfH1jSzKizV3Vy
   3MwWhrWDKA33fX+lFHWE1OrsEIyr+zanJcqE8vYdBvYCgqp+jQSbkSze/
   A==;
X-CSE-ConnectionGUID: PDnq8L5gSP2jX0QrgQvG0Q==
X-CSE-MsgGUID: +uxf+TiWQq6rMdudmkKV7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="74436636"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74436636"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 00:06:32 -0800
X-CSE-ConnectionGUID: mqi/dgZQQO2lNwuWfUYeow==
X-CSE-MsgGUID: hw9q9nG5Rlmig143Qemgtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="216373089"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 10 Feb 2026 00:06:30 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpilP-00000000onk-3bAr;
	Tue, 10 Feb 2026 08:06:27 +0000
Date: Tue, 10 Feb 2026 16:05:59 +0800
From: kernel test robot <lkp@intel.com>
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com
Cc: oe-kbuild-all@lists.linux.dev, ryan.roberts@arm.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
Subject: Re: [PATCH v2 02/11] mm: introduce pgtable_has_pmd_leaves()
Message-ID: <202602101515.tnpQ1Idh-lkp@intel.com>
References: <f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap@redhat.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: mcibd1bmt1kgci6a1b3tcqb7xhoirdp4
X-Rspam-User: 
X-Rspamd-Queue-Id: B01D4C000D
X-HE-Tag: 1770710793-79263
X-HE-Meta: U2FsdGVkX18eOg1xOMUSwisowzlys0MRlC7IGD4pFE4frgylJFzSbS/Dtl49any3UoxyRZs+Fop0q0p1/4hykRH5YtrKZLsH0SWJpQeaLM7QCC5Ugm3GCe2yu2SnMd2hcB5prvaEPjEIniB/pTFtP6X3g7UxC5ALvVCzERVBAunJb3dFIJG+RK+hX7y2CVaAB27LchgzhDm7K8Lag/UPAX5Gz8NtcYXhr2bfthJBoWxd0aFsvBtcOOnC3Cr4K3toEIxmovfBi9C+kTo+Iqm61RHVVtv0y1FmCA+vytqJ+H0YI7mQuJjusuYAH+mCHWGjNA5Uk2WeDgc2zfiset4ujuG2607Bmx1iwwsdWxL+vkdIvMAQ0IYGtbnSrB4Z6+FFiJR+ysCFH0kHQSXuxOOuI14mA0Eho1mxfKZuPpgh8SzbEv1Rq+qBn3R/yV6IT9EhChnbVlffGwttKP+zGH5Cu2H2+KyahTWWMApXTy1qWnawXLi2UluzfbN1eg6blp/FQohqHcm2LHGsvce3VxI5awArcMDlaAxA8SJ/iShiH73DDaBbiDki6+7oSIGAEfEGxLE5JCvYN8Sc9y8hZgqCNmcJ/zSWX37qIxNS/JuqYVfraByu5pj2NKcgUB5eLSlZWeEuQRDl05ohRzQ0np/Rnj8hHHZRUUyCs2HyH+8ELgA8yR5pB48Si9/nDd3MOtouRiXnBhfqGIWgRyur5zesAI2dayJ3OhBygYFRaFkHvXTAIb9n8zZymYDwI87DUJi26yb2zmUX0G6oIFJNhLEY9/97x1x1BvlBIVPsCcMuZrhihdO8+LhQEeEsRtKrIfBxWb2XypIPHPwsKNM6d0uUZlHrbvhPPSLoonyHYme7LRwDl3MdVUGxq0/K9UojzA7ZJCOKeBvRqdM0J+MJvAQHfP858Co9RBglybBNkTb0nRnCUHzBo5FEFM2m7k5YwDWigwB43C3Boxd2Lgxvu7V
 4P6q9oHK
 4V6YZiD9lElZVKO7hF88808/wEzPupBWySwWouagytjJfL95F/TGUS0B22fhi8EVD/h+sz1Ft9jNgY/w2+9vG3cT7T5AnNfthrE0neW9ouF8LeP/udTIDvkxkBXC0RsumwAX2UnLutDcXTP1sCm8jiKVhce1KdBZHRVxsFN0UGZ43ljUTa2PlMOKzBqbOwFkNGMBtiKJps1Po3mzW4glGzFaUGNmYpTDaPwejWUm8Xe1WseYYVc3F3cuGULuCe9B2MFDTklwdV/fdoNANzgGvRP7CjnECLgiFa1Kl5M6joBndSUBw/HkRFBK5nSbJiif5j20RCLfx3HoPrxSyK9L/ueIIoz6pEYYQx5u2aO+Cc5bggppVKL8MUNFR4NbhLBMDwTiZcxj5Ii+JQAlv86/yCOzyCoKFQyAFfOZPscTfEfioN2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luiz,

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/next]
[also build test ERROR on powerpc/fixes tip/x86/core linus/master v6.19 next-20260209]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luiz-Capitulino/docs-tmpfs-remove-implementation-detail-reference/20260210-061806
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git next
patch link:    https://lore.kernel.org/r/f55ca6204336f52f1651d02dc370bc3b771df3d0.1770675272.git.luizcap%40redhat.com
patch subject: [PATCH v2 02/11] mm: introduce pgtable_has_pmd_leaves()
config: m68k-allnoconfig (https://download.01.org/0day-ci/archive/20260210/202602101515.tnpQ1Idh-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101515.tnpQ1Idh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101515.tnpQ1Idh-lkp@intel.com/

All errors (new ones prefixed by >>):

   m68k-linux-ld: init/main.o: in function `start_kernel':
>> main.c:(.init.text+0x698): undefined reference to `init_arch_has_pmd_leaves'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

