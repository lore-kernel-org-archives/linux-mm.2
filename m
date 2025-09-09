Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDB4CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F288E001A; Tue,  9 Sep 2025 05:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6F18E000D; Tue,  9 Sep 2025 05:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D288E001A; Tue,  9 Sep 2025 05:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4638E000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:31:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 500A5C0447
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:31:45 +0000 (UTC)
X-FDA: 83869194570.28.933AAC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7306340009
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:31:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dehOSMLd;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757410303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RhKOMif5HeaPXGU9rJsw3C+g4PtxEHlDXLlDJ4kzaOw=;
	b=FWKwiZZOPPKlSReiPx6+7Y1vtBjBi1iGqrp+T2s4gSyWQX3PXG6DNG9gwIYKNax9VEjEZL
	cNcqMAEC98QFRcAsY3eGWttSyJS+z9/Q4CnDpp4tbBvLlNcCtFHHLgDNjc6rflYm8jSQQc
	/PTRfMXs8d6uUwekPYj2YVxfWBYkYPg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dehOSMLd;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757410303; a=rsa-sha256;
	cv=none;
	b=frRnJwNrwfrP+DfOu1TVYg34aec5aTlAI2Mv2aXN4un2pIjuWztOgkP3Aqwfs/sFm8eLgK
	yquwgrYYFzPAPXuqicF7rjpg0FC7oE/OFEunhpDp2RwYT4S6Y+7o7Fmjzu/PZvu9oxx1QV
	1Rjv2UKBDQU1HyW2sfchqmblXbYSd7g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410302; x=1788946302;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/9ZAnz6aUxALo+IRnMNCQfSI3xw1Dm67WyWwQmaBIqc=;
  b=dehOSMLdIgbV7Qi8gcSAf4JNIEwQIp/dejKEZYmUAXRPNJKQxEOe2Js5
   OkgEIEM8SxpOr5jlzoYILgRivo4hMk+Gk2Tif/8BygxuT0e9Qf6xcLxmN
   slyuIKBVwuDKFfXrkj7DOnMUez5qBOoAeDLo2LhhtzHORsQnorpUTR9lY
   VaxJqnjWxgToWIuUfLXwxK+PqzBW1D9vofc3wMpRMg6Ww3OuaDTNc7HRl
   2iXHYwrhxjmzwIXumPgmRXnKtdINKSUcfgGgl/XevJt8drQzvyTk3GPpb
   pg5NTWvGr2FeWcZbX29PBv5Qwo1nmkLSlL7P1jZEXlXtvEhnVzU4Rn1sT
   Q==;
X-CSE-ConnectionGUID: lZlxDWb3SaSDCU2tqD08Kw==
X-CSE-MsgGUID: +wIaYhO9QmKXshpmIn10gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="62314340"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="62314340"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:31:40 -0700
X-CSE-ConnectionGUID: Z0kNYrfSQ82aEjg+/f9jkg==
X-CSE-MsgGUID: htf0Tor/TOO41ARtt/MGJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="210189192"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 09 Sep 2025 02:31:40 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uvuhM-0004hf-2M;
	Tue, 09 Sep 2025 09:31:36 +0000
Date: Tue, 9 Sep 2025 17:31:19 +0800
From: kernel test robot <lkp@intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [linux-next:master 6034/7427]
 arch/sh/include/asm/atomic-irq.h:69:undefined reference to
 `page_range_contiguous'
Message-ID: <202509100708.5mJZ2cLm-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ixs4xmzy4s4s1a78dcftothshjaexi5m
X-Rspam-User: 
X-Rspamd-Queue-Id: 7306340009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757410302-16634
X-HE-Meta: U2FsdGVkX1+hob/YgXUk1MTmpH5YGOR4LK8RAVfLzC/z8uJexVm3Bq6ri3E+9Aypc1kjn6SNduWuk/hYs2Jzqfezz/13YpXiNLAhFw2hdZR12cAEOfc2RWnYcP65p94shwxnZ/fV3qlIDRJNAB+9njG1NDaKGeJqQisSXgpmZB/wo/5eSCpcZzouBQbwx8XFxRDp2A0+ItOvojBkP5CZ23/gi2N+ILd02u67/+4sYzjeo+mUNy8yQbGMJsAGhLQbLqdrTzW1NTAMihSJ1qs11PhH0PVqk27tff0FSAMMfJ6ova+B4GI8YSJ6Y5s1M4oOIe5AbRn69CnFid/eXSNud11mYOMh73BdW0AaNkj4w+qqiTva52kCu0EsyVEMFLqIf6vPHx6dFGbyG6IQReV0YjQvkFh1veZnOiLGi8rWeqLxr1InVZMIX43K+F+VRIjXVpoTYsWnITo/CQHkJyZjVDsZTtRVZGKA4Y//1RIPYLbDhq1Sh9Slqkktk4RGktd/piKfPBtwE35hYJb64NjPNyKLKOU7nKWeANE6EtVJgssHxgo+QB7uI4Xt/CYinrN4aWnbauyBOJDtOE4gso5rbH8b4SLsGrWMVrkc8r5oVGytFsnc+um96PATYr1BntZUPifolqn54PyDFoLw88JQb1KamdMqdLV4ZXEXWRI2mBMvApHHvzXJbziyLG1VrqgiyZZPG14eJjqxh1Ep7DGfn7xqAxHrhjIl3EagHYBGuRBU7T22Zs8EHgEEH0bG0wmTyInOcjKusYeimYcCEb1j3eKzVPG6qvcgTmSO/1BNJ+GZNB2SeKUKmsHvlt1F/60jNlzcBry8PNbGuyGzDbIahNnMeX/lSA3s0Hveo/SZA3Io0+oXgVtRmGjKBvhQYBRx0lU+1j19jQXgRZBiRXmGFM9eZ5sW4bHhrd56Ler0TmOANPM7rf/HzzIeoD8nVDEoS1fCFaYYs59ceiLDq5V
 Zw5cCAl7
 7Jn8aAAMsREV5F8rfzrIUefnECX2QlbATpLZ4QBdbWE5oCBTlY+6G4er0Nc4cgq9iddwifT+mE6KeDNBoBDF9hBnAJw4Om5Hf5k9zBYrf7jWJOdTssRFwXZwPTGJfyh/kEo2hCBzxeGbQwdn4Kob0s3tYE/K9u0ITc44TBQqd1OSl8zoxnde/tpNTt++xcz4G5ZzZpjnCgyiqMw01zXqKVKznqMBDavcATeCr1ofhsIBGUsZt3t0A/jQuY3CH7UkBfgydXdtAMp132t8ftt6ThyTXAyrOsL9Okx8DzU3tndBmc3FF4t6kh67O+cFJiIX8mrgi3JHKbds1DQG6zMQafqO5ts3kxGBjw5BXovzuIPrI0fq61t4dZkwN4knt20XrwneHX8j8ZjxHYIcUROorkWgxTSE4c9ZfT+B1qBT1BO+KqrDb/zjERXM5lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   65dd046ef55861190ecde44c6d9fcde54b9fb77d
commit: 73f5c4c5c6a36a130ccba6809337e42ccf8350fa [6034/7427] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
config: sh-randconfig-r121-20250908 (https://download.01.org/0day-ci/archive/20250910/202509100708.5mJZ2cLm-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce: (https://download.01.org/0day-ci/archive/20250910/202509100708.5mJZ2cLm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509100708.5mJZ2cLm-lkp@intel.com/

All errors (new ones prefixed by >>):

   sh4-linux-ld: crypto/testmgr.o: in function `sg_set_buf':
   testmgr.c:(.text+0x8fc): undefined reference to `page_range_contiguous'
   sh4-linux-ld: drivers/usb/core/devio.o: in function `sg_set_buf':
   devio.c:(.text+0xd54): undefined reference to `page_range_contiguous'
   sh4-linux-ld: drivers/media/common/videobuf2/videobuf2-dma-contig.o: in function `vb2_dc_dmabuf_ops_attach':
   videobuf2-dma-contig.c:(.text+0x920): undefined reference to `page_range_contiguous'
   sh4-linux-ld: net/core/skbuff.o: in function `__skb_to_sgvec':
   skbuff.c:(.text+0x2180): undefined reference to `page_range_contiguous'
   sh4-linux-ld: mm/gup.o: in function `unpin_user_page_range_dirty_lock':
>> arch/sh/include/asm/atomic-irq.h:69:(.text+0xe34): undefined reference to `page_range_contiguous'
   sh4-linux-ld: fs/ecryptfs/crypto.o:crypto.c:(.text+0x954): more undefined references to `page_range_contiguous' follow


vim +69 arch/sh/include/asm/atomic-irq.h

770345adc38485 Mark Rutland   2023-06-05  62  
c6470150dff9af Peter Zijlstra 2014-03-26  63  #undef ATOMIC_OPS
7d9794e7523798 Peter Zijlstra 2016-04-18  64  #define ATOMIC_OPS(op, c_op)						\
7d9794e7523798 Peter Zijlstra 2016-04-18  65  	ATOMIC_OP(op, c_op)						\
7d9794e7523798 Peter Zijlstra 2016-04-18  66  	ATOMIC_FETCH_OP(op, c_op)
7d9794e7523798 Peter Zijlstra 2016-04-18  67  
7d9794e7523798 Peter Zijlstra 2016-04-18  68  ATOMIC_OPS(and, &=)
7d9794e7523798 Peter Zijlstra 2016-04-18 @69  ATOMIC_OPS(or, |=)
7d9794e7523798 Peter Zijlstra 2016-04-18  70  ATOMIC_OPS(xor, ^=)
7d9794e7523798 Peter Zijlstra 2016-04-18  71  

:::::: The code at line 69 was first introduced by commit
:::::: 7d9794e7523798e1b9422ad9f4e4d808ae5d5932 locking/atomic, arch/sh: Implement atomic_fetch_{add,sub,and,or,xor}()

:::::: TO: Peter Zijlstra <peterz@infradead.org>
:::::: CC: Ingo Molnar <mingo@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

