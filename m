Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA4C4CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 20:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C528D6B0092; Wed,  7 Oct 2026 16:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03E66B0093; Wed,  7 Oct 2026 16:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0BF6B0095; Wed,  7 Oct 2026 16:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB4C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:24:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3D58120312
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:24:23 +0000 (UTC)
X-FDA: 85296957648.30.670D155
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7EB16140007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:24:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L2pwZhdh;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791404662;
	b=uHFJnPRw0iT0mNt9c5zbAavNL0DWbPocKPuKQ0TnQt4Hu2Y/b6qgaJBTBO0SQSmztOwpl2
	B3NCiXZ2hMB6DQPweShaZyTp970nhk59wZlKGXDb6SfvURNaXbu6ho1Wf2QiOSkMuF/Lsf
	MzFf5ltvmJpFwjaLZTN4bYW4wlsVfNM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L2pwZhdh;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791404662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dYqDQTlOxcX5gc0sxP2F7wrlmyt5LdjOZG9nO7GlTI=;
	b=CgS6zWGR8zxDQ/xOXdfOWacuiuER+xcMHeSkhbKMLEPF0iqPAO6qz0Iun+H4UU+85sTY74
	cPmbM5k6yEOddL/9oX1N9JqyQaHRsW9tm1AfPAcp7phNyvQKV4lr2Dvi1kKAp9GIEfQncw
	qz8fej6JCFi2QQBQMLuMnV7aqMDXQ6Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791404662; x=1822940662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N9l9ulXCPIg0gc7OkBVvGgXXOJRlDx+6Pbz/KdymAdM=;
  b=L2pwZhdhSMQvaX8b2wh+S9MKWTXAGKCzPK+b6avk0HduuNZmE8o9vrAc
   4OoTKyNURJSZTctKMgiypmF9NiVelpKc/qjt3zyE1+l5mD4/RGQT47IUz
   VR/jlCDb/BZVe8GKxNiivdTEENeuotAeycfCKNEwZh1Y12amGOP5Zo1nn
   Eq24Hd/rsL7ojP1JyBMYV2CNZ3Pb/tUT2P2cvb89uPAbpcFZ136LIYA48
   XDr/TBciaHihdAO/cKYypa3N7xFlR3sZwkEWG8kVkqRcNbcHdBoo/Gz5c
   I/gGTjhw9GeC1zsmi7haMi+cPmjitdEpdYeI1pEuNCdWRbWFr4UsxLqYU
   Q==;
X-CSE-ConnectionGUID: B/EcO9O8TOqon3946iqDCg==
X-CSE-MsgGUID: 8GT8tXeuRdafw6dw9VaN7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="63067"
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="63067"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 13:24:21 -0700
X-CSE-ConnectionGUID: WcP3pJg/QSGJ+Mlx0LNeSA==
X-CSE-MsgGUID: bqLGbVI7S1mkD+FD7SJiBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,144,1787036400"; 
   d="scan'208";a="315569616"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 07 Oct 2026 13:24:18 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEYBS-000000003VM-41fP;
	Wed, 07 Oct 2026 20:24:14 +0000
Date: Thu, 8 Oct 2026 04:24:14 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <202610080445.ZlyXFoBC-lkp@intel.com>
References: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
X-Stat-Signature: omh3z8wu3gahoi8gdfmeoii5odk8a1uw
X-Rspamd-Queue-Id: 7EB16140007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791404661-561324
X-HE-Meta: U2FsdGVkX1/rPJPE2g6pbMhDBrlgp+XvfjT7WGEc70wWmnGdwSPr+7wYtpPswy94HGQCO6IMKZGZo4bCs2mU5RpMHutU7VpOtuEYAohpeshLtNMBfPrHRdZxKG0opNjnwbKBKs4zTXGDWL0eMWWHcNDwMuh35sWhHC0B3ibXHZ8IqWHEyyPwcdLK4hTnzpeKDuYGExLFfVavbvMkdmt4SEr1TfcNc1J8p5P5NZQpxxSdzBHrAfA+YGL0mlb+wQJzfyfBdutSlSKGD4hBaptyBmIkn8w6oXbc3r7yZbKWGtzPjNRxmwhm5qycVLyG7GU4DZebOFsWgcqBNn+ktx1doTebEJ7TzmtXQi4JJU+/cw/zEdO8lMYO5eF99GC3EZc4AJLt5Xka/UY0ZjNJi3EwntRQK546fVlVad/SKVLNkjeFfxJTUOt5cAMKIH2PaeTqqMnu8rYkVxggq4gkdrwA+1ztOc/5D4cU8caf2lWwjSYczV1b6wMPoHA+bR4tR86VuPQpf02YS7cqaaK8HX1Yna8Sye/uL+NFoIXYxKLwNm+2UyLi3es0hwqa3RfYo9ydU+kzksoH4/PJ0m1/vu7TCD+gLE2sAkqMN4zDC3Auv5Z0H7e10p5EebBxMvkD1ivjhc6638ReiLB6nso208N3/HwstnYz+c4x748MC+Rh95uMl2Q6Angv4ZoxHFBfy0s7cMHQnwRjD/pMgfDISFxKYsSqI01dy6zPIooJeQ7RBdU7mMJuMi7HkyZpLX4RFymx5HqwlisfsoWus6uWDAMhLCzTRJKInQDDiHietMq9uWqsChNt0eU8q83LWAdboYHgaNhkeKx2rJ1d9kmTRD2sYdMVagD/HjLM3CkR/4qRtQ33ce1wGefLMalLSW7qniU1gLcwetj1Zlkcf3d41mQXMCPJgukoIHaU/h3I2LXTh9QDjy/j/LvYNx7vvw+A3hhXxh4W1EuXBCIPaI9qThu
 8LLkXWiy
 aCtMqK6quOYm3VFVA3/kwlI0QcG+8G+qsu6y6QXR0C7hD6tnME/uP7Q1iyTS0VGorbb+HZrEpDLPkalOB2Efh65kCY8Mdd4eIh79sEOjP2wteko32ZYUTW7MUx3I23dN9SCdWzYohGdFe3ktRGGKjO+7sjHHHxNqm1/Rx527685H+HpDdZ9sJtcuBtWtPQQzmqUZ2j4HKZuNfWc6fWxzSJf3KoZi7mMuaUaGRUQg1YM2+rT68vIu8U6hfM2KUF3ZmRrRg3vGcLbeRpMa9X+tzdxZmutFIF79cwJkaElXk9yW/g2knCHoO/dg53xUnCRxA5toJPviFFan+1ELFWnFx23o9arpfZeJC220L0tQRvofL2Or/XKovun5jSIm81RhStp+zL3NX9yfSLSySsna0YrNtVu+m47XpIL4SRJ01VJhDJKK1W78gBxchungQwDvKvWJxbvSuvuxwGzw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.3-rc6]
[cannot apply to akpm-mm/mm-everything s390/features kvms390/next next-20261006]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Gordeev/mm-introduce-hw_pte_t-for-PTE-table-storage/20261007-134144
base:   linus/master
patch link:    https://lore.kernel.org/r/e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev%40linux.ibm.com
patch subject: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
config: mips-bmips_stb_defconfig (https://download.01.org/0day-ci/archive/20261008/202610080445.ZlyXFoBC-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610080445.ZlyXFoBC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610080445.ZlyXFoBC-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/mips/kernel/asm-offsets.c:14:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:45:
   In file included from include/linux/slab.h:276:
   In file included from include/linux/kasan.h:9:
   In file included from include/linux/pgtable.h:6:
   In file included from arch/mips/include/asm/pgtable.h:14:
   In file included from arch/mips/include/asm/pgtable-32.h:22:
   In file included from arch/mips/include/asm/highmem.h:24:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/mips/include/asm/hardirq.h:16:
   In file included from include/asm-generic/hardirq.h:17:
   include/linux/irq.h:1211:2: error: call to undeclared function 'kfree'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1211 |         kfree(gc);
         |         ^
   In file included from arch/mips/kernel/asm-offsets.c:14:
   In file included from include/linux/compat.h:17:
   In file included from include/linux/fs.h:45:
>> include/linux/slab.h:595:6: error: conflicting types for 'kfree'
     595 | void kfree(const void *objp);
         |      ^
   include/linux/irq.h:1211:2: note: previous implicit declaration is here
    1211 |         kfree(gc);
         |         ^
   In file included from arch/mips/kernel/asm-offsets.c:26:
   In file included from include/linux/kvm_host.h:5:
   In file included from include/linux/entry-virt.h:7:
   In file included from include/linux/syscalls.h:95:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:6:
   In file included from include/linux/ring_buffer.h:6:
   include/linux/poll.h:134:27: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                         ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   include/linux/poll.h:134:39: warning: division by zero is undefined [-Wdivision-by-zero]
     134 |                 M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
         |                                                     ^~~~~~~~~
   include/linux/poll.h:132:32: note: expanded from macro 'M'
     132 | #define M(X) (__force __poll_t)__MAP(val, POLL##X, (__force __u16)EPOLL##X)
         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/poll.h:118:51: note: expanded from macro '__MAP'
     118 |         (from < to ? (v & from) * (to/from) : (v & from) / (from/to))
         |                                                          ^ ~~~~~~~~~
   2 warnings and 2 errors generated.
   make[3]: *** [scripts/Makefile.build:185: arch/mips/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1425: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/kfree +595 include/linux/slab.h

7bd230a26648ac Suren Baghdasaryan 2024-03-21  594  
72d67229f522e3 Kees Cook          2021-11-05 @595  void kfree(const void *objp);
af92793e52c3a9 Alexei Starovoitov 2025-09-08  596  void kfree_nolock(const void *objp);
72d67229f522e3 Kees Cook          2021-11-05  597  void kfree_sensitive(const void *objp);
05a940656e1eb2 Kees Cook          2022-09-23  598  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

