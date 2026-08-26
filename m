Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23228C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:23:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94326B0092; Wed, 26 Aug 2026 12:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C8C6B00A5; Wed, 26 Aug 2026 12:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5356B00A6; Wed, 26 Aug 2026 12:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEC16B0092
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:23:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 280671A016A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:23:31 +0000 (UTC)
X-FDA: 85143941022.27.BF91B70
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB4B1180009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:23:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nih8bIuM;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixqAsn6TGsKjb4uz8wyzxl1SAvJQxPNub0k9fwjenCg=;
	b=7SiJ6iEwtZ7o9GFOQWcRH28N2tNxCFqzACc2zCrILgcHIeiJuDoBK8PapWLtG8OP8/6nvT
	bwJtDr6sydXIjCWaO9MQN/g6doA/sqS2rs49Hshd4nwpmgcdTPryaLsdetdSyX1hSaLOO6
	vB14Ml9zuQuu+dmVM8u5nZsNXaw1kR4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Nih8bIuM;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761409;
	b=c96dUruzvEbZBwFDRe6IWn53y2FDoJpP2rAXJ1ahA6MqxhmLv00CR1Fy6/lEDaen6L5IrH
	BvTnAjlzNscE6Y5w2qsXQwo/ZARXFJG80bZ+EHevAg3KG8kLtXl1u5cbUSjjE1vRNJ5pmg
	XwepE9n2WYUW/jTK0vOFHbqijY7Xl3I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787761408; x=1819297408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6kzQ95U1YQGNGVH/1wyaYETJmIZw4uwWKvlsrvcnlv8=;
  b=Nih8bIuMicgdw6fsMYgnaUW6XkkwwOvLuMUJ3yF7Jqit98sI6BqrgVh9
   KlQBfaETlrrT0rto9DWDebpAUGjXzDPm7y8BdkWZYbzYa8ai965/cDx88
   vEMggOUIqrLJvvCOmrpRC2xIt1MvQO0ctAp3pHDUyDpWmpz5MSL8+PLNE
   inQ7TLYZ+onKPl5BktjReU2+0Lz9dY0+nf7iewaRxUMIf1mXZzG27f1N5
   jwExSjns0K+KbOCaCqGZJCmOiM6ZMn87F0Ypm0egR8o37ILTmw6+0euG1
   h9NRN70XChRP5TW9Az/Wo0JqiMqox+MLtOmM5Dt3s/h8wBoCr34SfXIAP
   Q==;
X-CSE-ConnectionGUID: DYwmB+vpQJeL6LvL4c1rhA==
X-CSE-MsgGUID: 6TXV9OIYTwes14rwN4zN/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11887"; a="87378563"
X-IronPort-AV: E=Sophos;i="6.25,245,1779174000"; 
   d="scan'208";a="87378563"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2026 09:23:26 -0700
X-CSE-ConnectionGUID: lR7Q+sj3S6C+exrR/EcD1g==
X-CSE-MsgGUID: sTlQIIJsTYG1G5BfCPibWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,245,1779174000"; 
   d="scan'208";a="291144168"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 26 Aug 2026 09:23:23 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzGPH-00000000837-3X1S;
	Wed, 26 Aug 2026 16:23:19 +0000
Date: Thu, 27 Aug 2026 00:23:14 +0800
From: kernel test robot <lkp@intel.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: workingset: judge cross-memcg refaults by generation
 age
Message-ID: <202608270037.JUsg3wm5-lkp@intel.com>
References: <20260826075133.751049-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826075133.751049-1-zhaoyang.huang@unisoc.com>
X-Stat-Signature: 9u69wf7hwxr3g7pza8aebgdaun4y9b5s
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DB4B1180009
X-Rspam-User: 
X-HE-Tag: 1787761407-298434
X-HE-Meta: U2FsdGVkX1/R1LBz47mRrjloUNMJfFZgMb3LBeRCOPMr3Uyd9LH9IZFzGRurzX3odUUs0oGg2bnoBj+Tysf+PjTGM+/x///qM0zwTxSL1i9n/ekWCoRPGOoAoF39rum3wHjQPrxuXMuuyPXLHIS9YHDWczxZxKwJW/WgqpUg13hQfFrNxCYojdcXn6wugMajFJttoucB6k5mcjUN6XboMhFHPu0DiCMkvZ1u0b0R/qctTT7wVbeaJuknPuI3lIGqfH502t2ipOv68JqDhu5na4SBj7jPvygHOmtyXvTvjaf+o+qHIQfFbuAQhXP62OqG49NpUcDtOCuPps2C7+c/wtgHXdzQPsTMPcx8U/Zi7woOB55VQbsewA79IJXPnz4ashq2X5LtbLXqXR0X8X0vF8rEjWeIsUc0t4EELgI+to8rKhsPrQ+WSY279qCK8/MBoUHNMI5mb8E2AqRDLE9jfozbkb+r7I5zYgbVdaL+q1RreLEFnM+2eeK9B8IRGqpGuUdUIGCjRTCmWO2QaQAgrdf25gSb5BnLuyPz4oQfywDzYa41FCgvWf0BqN0/tQYP4QinNZjBNxsGcc4QtxFS/gqF6U2fziGB+jG+D70s38UTL2gfYBd27jHZrsYzxIl/mCJSSABycLu7uMoKkHKYg57rOD8XoCYrzQjg7P/J6X7NEwvngYvZ3n9oDf+fE54k9AU6GV9Bc2UBnmtnLO7FfwxpLtVXzQMJ2QCsWF6lworQTd8uFOQWkJHCPHuWhcoJaCxmEQyxYKubY8ju/kQ27XywUS4Au4FaxEFFm7v7/O7Mgw2qP6i2Qpi4Loc3ngOY7pDydqIKL8I9D3cIJIUpNcgzYW0HKEo8ZdHbdPE8UMuRvn4/Kx2F2M1kkaRhTt/9ooRDVNw78cGPxHxBqa2+nIk3Mfk3syo+5h2n1lS12AQoVVKLEs+zCWtBCZPRblXUK6gRKrGQYdV3HJ6nUGY
 e5aYzZvV
 6s+fmuqs6Fe7EPt9kMA6ABvipdqkzvURsRYq+NulO3CQ61g7V4W/9IbSAuknlgSqrN4idVfL9G3K8Af6AWGalwBffhtfvpVbA/9sxSKYo054jTVyxpzd1y5ef5vCQpWXUUwC2bnUz46MS8GyVbDVjOsXTjriTfVxPMrLEZkWEBurSCU2VtriZakw11sQNVjZT3Jwe7IArmBpv+VbbsXW+ByeIuZ7qc+s/jWJ9F9aF4EYj5h8srJVojcZk++GrvafRRcOizq75qpwZTnj5RbTTExOxnOKWtasUswbF/p0qWRtM7DGsoMTHlNUNaDay9+XT0tunEtqWRr3Hb0mtILIWHB1PbHXXtaGFk1cuOonIfV/QfW1NOOke2jpj2gVl5PAK8W2XZY6rYYLtMVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi zhaoyang.huang,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/zhaoyang-huang/mm-workingset-judge-cross-memcg-refaults-by-generation-age/20260826-155133
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260826075133.751049-1-zhaoyang.huang%40unisoc.com
patch subject: [PATCH] mm: workingset: judge cross-memcg refaults by generation age
config: csky-allmodconfig (https://download.01.org/0day-ci/archive/20260827/202608270037.JUsg3wm5-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260827/202608270037.JUsg3wm5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608270037.JUsg3wm5-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'lru_gen_eviction',
       inlined from 'workingset_eviction' at mm/workingset.c:459:10:
>> include/linux/compiler_types.h:702:45: error: call to '__compiletime_assert_649' declared with attribute error: BUILD_BUG_ON failed: EVICT_TS_WIDTH <= 0
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:683:25: note: in definition of macro '__compiletime_assert'
     683 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:702:9: note: in expansion of macro '_compiletime_assert'
     702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:40:37: note: in expansion of macro 'compiletime_assert'
      40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:51:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      51 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   mm/workingset.c:275:9: note: in expansion of macro 'BUILD_BUG_ON'
     275 |         BUILD_BUG_ON(EVICT_TS_WIDTH <= 0);
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_649 +702 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  688  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  689  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  690  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  691  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  692  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  693   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  694   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  695   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  696   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  697   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  698   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  699   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  700   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  701  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @702  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  703  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

