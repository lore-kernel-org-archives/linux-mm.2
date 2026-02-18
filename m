Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D64E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 00:27:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86E16B0088; Tue, 17 Feb 2026 19:27:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61536B0089; Tue, 17 Feb 2026 19:27:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8DF36B008A; Tue, 17 Feb 2026 19:27:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B54F76B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:27:30 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E9A358929
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:27:30 +0000 (UTC)
X-FDA: 84455688660.14.A918C64
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id E7FD518000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:27:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ayyBQH6z;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771374448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuHqmpdnpPSOMPmEbUpkXO6SYL63yYRi9xI4YqpucJc=;
	b=56zK1PgExc0NNVIUWVMx+WAjIy/4OZbzrsgJBqFL7cgu0O51qY2k+MuKZ13qtsDHI2iWIo
	A+H2g+Qd+J3+hf4O6vg08muIOXhxNrXUgFqNmWJnJJVmzfeGFkUnucm1Z0BZUbP51fceWI
	APkTsig9NewDtpzvUnhE26IxBqnXs58=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ayyBQH6z;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771374448; a=rsa-sha256;
	cv=none;
	b=dywadxdPv2eDkAejVDRPU6+5wzdjeyiuWQG1VTdVH45u4PeV4/2hW7WFCXwxeL/LdavnKp
	Y8NsM0IzMI6Ha2BhOxcT6pFvNz4P94UB/f81NmCCweVrvHMhPtCsFu7dZ5Hv2pIhQzZBMM
	qyo2atybKAcXC6xdI2Mliz/yiD6i1Pw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771374448; x=1802910448;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fcWenNUMcYV2dYTPrnEXpTkuHZTjKtFPqvvPipIHmQw=;
  b=ayyBQH6zsR2JYT852KJtWivKH9wFiQPRpUY1oacOovRfLfPjf24J+RzJ
   wdsfJCdM56Amdl+Xil3hdzx2nyTwANKRj2lAX/HaAFXOhXBO0Zd6M/XkT
   VAmL/oP5rkC2sHDf8kj+zS+6oyL6n1jbwSKhv+u++BUZ6DxtF9l6gDhqF
   c5etoB9crKnbJIF1hhlhY0QkjG2co0vidkgxr8H+MZxRaGqIkGAfjNtpu
   3SoTSYlUwTr/wYVT59mxxhOl8cIsPbeWcl8W6pWpnK+rBOjf7E5g35PZa
   ZJmYwA17azR+ksOtiQS3sFB6jbvIZVu7XXyCAi9bV1+9MmNvfeaIi9sTK
   Q==;
X-CSE-ConnectionGUID: C+mwpXFJSgmBURCHv0f1fQ==
X-CSE-MsgGUID: TWREDzs9Q0CBGIxfAagkqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="95082140"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="95082140"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 16:27:27 -0800
X-CSE-ConnectionGUID: AoyUbSm4QxWvTyl/s2K+PA==
X-CSE-MsgGUID: ELDlXahcT5mjgqeEhxUaKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="244632599"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 17 Feb 2026 16:27:24 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsVPV-000000011s0-24GQ;
	Wed, 18 Feb 2026 00:27:21 +0000
Date: Wed, 18 Feb 2026 08:26:35 +0800
From: kernel test robot <lkp@intel.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com,
	kernel@gpiccoli.net, gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <202602180820.Vi6LlvfF-lkp@intel.com>
References: <20260217195816.861684-3-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217195816.861684-3-gpiccoli@igalia.com>
X-Stat-Signature: mnjh3m1d86qqzbj7uh9nubiyqp4dw4wn
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E7FD518000D
X-HE-Tag: 1771374447-936347
X-HE-Meta: U2FsdGVkX1/Isie65KuloBIKVWsLlApYwsld+2J5mGLTQLD2q+Om2B8K+w+DkH+9hjwrsYXdX9N5Ge2s/k8xXF0MgX2iipDj8mwVs+X3evbznG03MXp0vxMeR1BpAJTW1oqpzHy1XAap1ozVIHX3fWDeBwVkODQwqy4sxLUrCMwbIj3oGNrxVkx/Kfcs320FIlKPaRMlBovclphz0j0RPVaZvRQIJjXI2WVbsjD5796uZhq1j5c5R/nwNicapC3RURoOtypLNoEvMb/+6nbOi+zD3XtAv5dkblh5pfcFqnZ4yTcyfRrN5yJQ5+Vhc4BEvbmMShc6RWB8HliUKc6EH/khK5kSIa2f5BSwJ64eO/EZvgzMsxBWzeBSwvnsyfoFktU1AKaXye4RqHqCPoCyuEypSXMD/YotkObhaaBX/0OgUF0oo9qzcMrbmhylDWJ8tWTYBx+vLxUKpVNbnb38QQkZPphUV8W4yRIOzpVMXJrqP2wU1u3CE2UaNtEUvh50q62iBc3kLUni5H9rOD24rCbfh2Uef5uzWUpqbUzv2zvioUPbzgN+9zCTtQIXMU+OHoTf1Su/aENmsbVrEINs31q34LG5xv8LVG9C3ZXWchMtiEpUxKYfE8vIaFk20yTxb7JbLUTMWcnZ0BmOw+3lciUiSA8vZtP9iUjErzEG/BA45QFZ1R+6uO/EyUykQuNg0Zig8oXDvnX9ZKcPtZCO6ZFRmS0lGJhl8XIYlKr0PRT8/LeUrHIDvU8DNxcJIEYa8SjPgL0140WEL8bzhBQ2G5svXG20tuGywWl7IgZT5ERKHUUAQ7uGNJnjPT0NxxC7tqA+NEqMyuoXbUV/CCxB5mt470FDlIyU5mkfWVamXKw7JLqKDG/qjFVaCa0kjjTkE107fYoL+8ydIJznhGBeZXzOpCy8iJXiWPAxX8+cg5iS9gqAARswo8ACQNLOjoIp7GkeplKV6wS/fBFR/cY
 2/lIQZtO
 9/83W3VwfF9aF31bNdvOZTdIIdgrmCRGbvVAxlbtIvfwvV1cJ0prurot74j5CGUnfZKkV2rp+TrcVhhXk0eMxGT+pHX/9ayCW2xiBpP9o9Lx3JDuDFD6wd0QgrV+5qtsofdq2dFw2+0s/QQ1OD/6RMfI4Vtu8/yPEyvYWQUCvZt0Y+lAk/4AddnEYhWQa/jmixngJfujElyRrwamnK/7Algim5vn4ePnRfO32n5shK3ySR6IRJtPVqIKJ5kEz5rSHR5DG/DgGmaKjsiu+cZL98AA2joWGC92lznHoYOjZYdHDhehgM/W+9iYXNEeUCxu2R68fRbjsvtPaOdsmtG1oSBaUiJr6djT0qev9fIOkd0aReP5Z2ZphERJ2ho0YDlelsMZqIvJ2GZ2l2X3QueIgShRQQf5CQU6DGvFKptUvuXrvctIi4lntbtCRFpcimC77WcNDypHlNkv3iDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guilherme,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rppt-memblock/for-next]
[also build test WARNING on rppt-memblock/fixes akpm-mm/mm-everything linus/master v6.19 next-20260217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guilherme-G-Piccoli/mm-memblock-Print-out-errors-on-reserve_mem-parser/20260218-035935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
patch link:    https://lore.kernel.org/r/20260217195816.861684-3-gpiccoli%40igalia.com
patch subject: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
config: s390-randconfig-002-20260218 (https://download.01.org/0day-ci/archive/20260218/202602180820.Vi6LlvfF-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project e86750b29fa0ff207cd43213d66dabe565417638)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260218/202602180820.Vi6LlvfF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602180820.Vi6LlvfF-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memblock.c:2721:27: warning: unused variable 'flagname' [-Wunused-const-variable]
    2721 | static const char * const flagname[] = {
         |                           ^~~~~~~~
   1 warning generated.


vim +/flagname +2721 mm/memblock.c

1e4c64b71c9bf2 Steven Rostedt (Google    2024-06-13  2719) 
54091ffecefa11 Guilherme G. Piccoli      2026-02-17  2720  #ifdef CONFIG_DEBUG_FS
493f349e38d022 Yuwei Guan                2023-05-19 @2721  static const char * const flagname[] = {
493f349e38d022 Yuwei Guan                2023-05-19  2722  	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
493f349e38d022 Yuwei Guan                2023-05-19  2723  	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
493f349e38d022 Yuwei Guan                2023-05-19  2724  	[ilog2(MEMBLOCK_NOMAP)] = "NOMAP",
493f349e38d022 Yuwei Guan                2023-05-19  2725  	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
4f155af0ae4464 Anshuman Khandual         2024-02-09  2726  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
4c78cc596bb8d3 Mike Rapoport (Microsoft  2025-05-09  2727) 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
d59f43b5748092 Alexander Graf            2025-05-09  2728  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
493f349e38d022 Yuwei Guan                2023-05-19  2729  };
6d03b885f0926a Benjamin Herrenschmidt    2010-07-06  2730  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

