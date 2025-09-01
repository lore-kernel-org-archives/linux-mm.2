Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C83BCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 19:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E418E0009; Mon,  1 Sep 2025 15:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEA68E0001; Mon,  1 Sep 2025 15:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314BA8E0009; Mon,  1 Sep 2025 15:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 204708E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:41:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3DB88509E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:41:49 +0000 (UTC)
X-FDA: 83841701538.27.67CD14C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 583C4C0005
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 19:41:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cjY6ZXaO;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756755708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fdBLC1cUm5Q5UudCz69QxXF3IRCbD2Oo5UlhHiMrJlY=;
	b=tUhHkz5NmYdOjaeYSN1VEd+lOiUaKtlX6JFxjysKuuXzoCoK3ER/WPJnsSSJtiG7KZXidW
	apC8j99+Qh9yJSL5sByi/fygnqTUTuC22XZCKXe/+4h78QLmnf1T1S5iKtdpR6fdZGJBV5
	eMtE8UYocLCO/c9Po1zb0EBqPq8p9/s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cjY6ZXaO;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756755708; a=rsa-sha256;
	cv=none;
	b=BWkoI3VJvDn49mFoeuxjjyaCDgsbHObaUqecg7qBS5dJuJWCYo9I4jmaJHG3sfI8NLI0/R
	iKDrw14eL0GjS0g9QRD/kg5zRqun3fGJR+bf7UfsI3tROk8C6h4NFViH4NGXho1ObHpziu
	/++YWq54t68e/xanbhwtWFcrs06t/Bw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756755708; x=1788291708;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Z/9rqC9Vy2wI209K3Fl8dMXhC9KQemBOPTKkT40Opi8=;
  b=cjY6ZXaOM1sTg5MlFXrvq/+4fol8EYm5Te/6xQI15V9xK4uYOlfcd+8g
   x/Utnw/Yl78WqL18aQpNTy9GXOj7+qmr9Th8RW8RX28BHRt/n9PoOwp5a
   Ir8P4PlW52SQZyboCsrqYj5KZVxFZh6KIqWRMZ+3PKmHR5i/crPds+w8T
   FUn2jV7UQr3u+/PIHJEcspZaoSs49VGS9F1NuQChdsxwBQRStA3sNc7w3
   cyM7Bu06w3D1RPFlS47NUcKQ3xOuqjtinan3q4g1hXNnuimPEDVVuZueE
   JEGmpi+i4gceQT6VW4oLDAvIVDvr8frNdeLJbPF0D6mQOc7BNA+NCSYFu
   Q==;
X-CSE-ConnectionGUID: QhZrZndgQPyY8HUx1zHQTA==
X-CSE-MsgGUID: 7UCibldkTJOIxtAXkuUF3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="58873398"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58873398"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 12:41:46 -0700
X-CSE-ConnectionGUID: qJEH03foRcygz9NHGQv6CQ==
X-CSE-MsgGUID: /G7pRcArRRKJyrJPi/Yf5Q==
X-ExtLoop1: 1
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by fmviesa003.fm.intel.com with ESMTP; 01 Sep 2025 12:41:44 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1utAOn-0000yV-1u;
	Mon, 01 Sep 2025 19:41:17 +0000
Date: Tue, 2 Sep 2025 03:40:12 +0800
From: kernel test robot <lkp@intel.com>
To: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [akpm-mm:mm-nonmm-unstable 90/91]
 samples/vfs/../../tools/testing/selftests/pidfd/pidfd.h:28:10: fatal error:
 kselftest.h: No such file or directory
Message-ID: <202509020304.IC1Dqlra-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: sisnug731ybmrshwocksw6tutgwgagoi
X-Rspam-User: 
X-Rspamd-Queue-Id: 583C4C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756755707-655558
X-HE-Meta: U2FsdGVkX18Gdhc+7mDymWbOMj9cCVFwVCu4ALNgPgbFT9ePpXP3CDFk5DSlP89KTtmr6cT6RdBdSf2JWXYlI0oi6ApCGakY+ARTUwtG9RbuDcxqYLpc66irHDkM/jNIqgv9fa7qc3j+qBXYaqr+ApWtXrdmaleZIuZEa5QQi3jjcLBMjRZgr80rzjVpNgtbPSmNOhnj6JcMHZbrFCyvoYRQcFF0cATyCGxDWhdT9/SdYpB7cFbJpE58KxWPNHwnSg6DHULa4BYcBlKigopUZizrCTsvzvXveNewWGvxlwPOrqF17s7NFxC1OBRBO34tZBpE5VECKS5jw/cPFDjdGZNumVDmbu/w3BpfKqRtDrSLkNv77yAuLAUGVRxTF49hkuQO9Uq6Vhy3yOcMMsELELB3IxPBABbA2B/EBOZWaaz0vhekqh0A6/XRcLWEyqnZPxFnNAiKiodPh6L69bpfBIMag+aauXEowVm2t3fKVyun3DjCbSVjyQfrpkFocQK98Io9ijEfuWDBM+tmY8m9fSf2jtlsblegUsyt0kDgY5zivqnn1QnNS170OXZYu1YXG+pqvhUrUgPYU4s5dp21ToKPt0KT/c7mgTNwmVr2F9AEQQYELfr/2rNgyO4s75HMtr6qGl8GdBLSwYnFYEof2UNFeP5MEgMVeMA4ZVsy8vRH9MpxAi3yJQ7XU4p4GsovDP74NGpj6+5TTr5TXAcEP/OW7GTrXK4Ntq+3vUJ1flosCAqkuTRyHbM8D6jSg200sdrh/2fCF+d+2sasT5n109uc/s+mAmbUz0+AtQ5ccaQDaE5jJm6Y9WlLP3uOvv+OWz5RkW4WVU+vOn8h6hpfRyV/k6ImYuaH5FhfmvFTXvic4PeC74+3os9flDo/lB3yu5X9hQ4HQbcXX8On0uZ+Bt8O6J58v8KdCA3mjGugHCgYyAuHlWfk9OJQvkWnST5jJoTy2YgZyIjQfyfNjqK
 99knai8I
 JWP/Vr4nDKclLtEqrwXs9YoFsz9Aq8ny6xMx/LoS/PQgiP/EWQ0LU5hb7dJzIh/GVtpdGLo1IHluk1mz0iMXFajz8KOpnKr77MqtSycE/C0eSTGJFnfT1Ln9nmWMW1I74QrJn/6tSMV7nXxwfyJr/ZCbP6gqtHYY0r4AJNvJ4yNFKfZsvukFltI5LsYFBgXzRPG8j1kj0q7LLhVXQ/P16fgYLZCvJSHK517R2CBRHv/2NZ77Kn77dAmKiSsWBVS2e8twTHQd3XVLurLGo8ZYgK1NmQT4z2iIqKAzoZVVLhRZlrXRAQ1zlaVNoEHVlhZKUXfvyxoSbPc0Cyhf7KK/tVEZaeGtGMwedlsa2L54swqFWxVRRPxsMDQJE5OIrgOQhgZmBREyvO7JHjJA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   44c3fe32c28a9a6322ce85333810f02affd66431
commit: 98f3e3d66d6b0e97cf3d3875343d9240699a5db7 [90/91] selftests: replace relative includes with non-relative for kselftest.h and kselftest_harness.h
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20250902/202509020304.IC1Dqlra-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250902/202509020304.IC1Dqlra-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509020304.IC1Dqlra-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from samples/vfs/test-list-all-mounts.c:11:
>> samples/vfs/../../tools/testing/selftests/pidfd/pidfd.h:28:10: fatal error: kselftest.h: No such file or directory
      28 | #include "kselftest.h"
         |          ^~~~~~~~~~~~~
   compilation terminated.


vim +28 samples/vfs/../../tools/testing/selftests/pidfd/pidfd.h

    27	
  > 28	#include "kselftest.h"
    29	#include "../clone3/clone3_selftests.h"
    30	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

