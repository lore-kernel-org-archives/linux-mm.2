Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 498B8CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 20:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF10A6B0005; Wed, 10 Jun 2026 16:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1CC6B0088; Wed, 10 Jun 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB77A6B008C; Wed, 10 Jun 2026 16:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9EC56B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 16:58:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FE011C1458
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:58:01 +0000 (UTC)
X-FDA: 84865215162.01.6318542
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF678C0008
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:57:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cshvOao6;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781125079;
	b=Ozw/3HBaAxovBnGd41LJ1AXyu4lLHEw1iGWv7n2oF1ds0+SEJnsWt3KyVs5+01fcUkAaY/
	RXYRSRX+/ToaqJhh3M8qqzCLI/Rzs9RsLVg8wVuU6J5TurZdp5dWmwarXnOWhNJIO9OjSt
	Zk6UDJKwYzwMdia4jRCpPFgroS7BgGo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cshvOao6;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781125079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdtW1becQz7imrRsMFHLMWulynwYa1UeOsHgq3oAlsw=;
	b=4w5Rk6GjCJGKr0vzKVtyac9HX6wuVLvfjH3LLDFtx5d1+u12sdyaH71kMz8z2Ft3xDLCxb
	Qi8Cec5ctakyiLnlTqVMy4JWWOgeJekutIbl73KI6ZtWBtqIYaZzXWv2hLb4DNITJl8r0i
	Ky4lAOFcP9B/D9V3xA1bKH1n2woBe08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781125079; x=1812661079;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q6FiXZY/j5YuhQLvlVa3VnejylmiONQ3vGkSHgpj0Ws=;
  b=cshvOao6xvH2daQmEP+xt4o7+flOFwjwfGK+4HrFZZpaMsRWyUHEEWYJ
   RgC7oRzfpF5C9ORDVo3vqlVRnqLTyV8qEvuVAReru7Nlsi9ZSyd1oVtjn
   02X5LZl3bZWaRwC3W4djiiP6V1/FkfzsQc/7o3jdfMY4W/gUj77+WxQ6e
   BvfIj+SmygZ0dd7cI6v/0QgnRGc07Ht8kDxQmLQxOTUgdjLMJKPUfMo5z
   ttxLOSqkPPpbHVIBu28QmeKrdXdwOP+/0K2+5xEUwbunVqXB9dk+So7Fm
   SwD/3xyI0EvPgkp8ck39gwTaoZmIfHgzI4jVlysmRBS60KV6+l/tr9AGM
   Q==;
X-CSE-ConnectionGUID: Pgb/NhiAR66poaVRHPnT+A==
X-CSE-MsgGUID: k96K/VmLRvinMYgUHUkemQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81670624"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81670624"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 13:57:58 -0700
X-CSE-ConnectionGUID: ScDz+liFRbC+coxUyRfGPQ==
X-CSE-MsgGUID: 2+hJQl8DQsy+iBkrZXj0vA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 10 Jun 2026 13:57:53 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXPzi-00000000LuA-0tiY;
	Wed, 10 Jun 2026 20:57:50 +0000
Date: Thu, 11 Jun 2026 04:57:20 +0800
From: kernel test robot <lkp@intel.com>
To: sk@gentwo.org, linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mike Rapoport <rppt@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	cl@gentwo.org, Sayali Kulkarni <sskulkarni@amperecomputing.com>
Subject: Re: [PATCH 2/2] arm64: tlbflush: Reset active_cpu on ASID rollover
Message-ID: <202606110405.ytZbcvhH-lkp@intel.com>
References: <20260609213615.2788698-3-sk@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609213615.2788698-3-sk@gentwo.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF678C0008
X-Rspam-User: 
X-Stat-Signature: 7sbncwwwj5x1ggyncgxxecz19wuwi86q
X-HE-Tag: 1781125078-490550
X-HE-Meta: U2FsdGVkX1/pSzcIjkos3NAvI2bpnFA4C7Px1dJT7SR+T7JfmLkZVbNKM0ZW8CDP0fqJ81xyzei7QZMfzwD4/XB3A/DO9CAlpsdTH9IKdw3eWXHg6luzCxIkvnL2hLHyXIhAHORGYpXwyF3YSpUIC1AGgnZ0bcZR7/z529A//RbuisabVUrYYr6UJCRyD91yUhnbwNlIxpIVJJck42SF1PCJgi5t0yxG3zl9GrUKdkIJBYYJibSwEeXSKlaZmc2m3Bb82yvTgAjG3s3a8hudI23CjFgsVQ5OYDCHi/wJnjt4ICgfVZHnNH4XwOQM1tYCfOgIVwajQj6ZLIb/rRtb/UYlYKYoniJTD3rLU8LaBXmXCDdnDy7lKJDapzmkKnKG/ucVuvDgS6Xt4Otw2uPb0sM2Ixc7+uc1ujYnW2wfWS8W6PM7BFrETBCSM3O3a0NddOg4uqLmKUUZl3Rzu/0t+Ph0hOXfw/CZhiSmyDJtsf2COf4gl93eubSAzKuGXVSEjlvwCn9lIdxykIiui9gONxdTMit2nBeQtgKYnh6Uuj53JEqlJiEzOR4mQBK9gl+HzplTVHC2ABQkOSHgVNBJDu8qEri2H/SHnMtVwe0L+K4cSBYtYJc03Ptx0uAgvm0LFyg7TvbTheYkqtPeftHcXzPjx9kumoAhiySarf7uRaAEknlSJHpT6KS+cmi0Jqe/Sn/hmU3NtAGfzbifBOqmaPs6H9uvAkUw3ifX0uoYHdu9Fm4FJywmliKJglgHclrnI4hY2B6WSiTeaxj8IwGHcLgO7vAC8uyxyIQczl0Fb4JsJxEjIwVaw3IWcbV9uSkED+90ouwU8cZPpBXTNKJFTHWj7LJe/1qIJl3oi1JjB62XddLjiNkNLiveiQfT/URHE4TVc/DAyHh94rp1vQLXbqHmbMMTnpfI8LziIGSngdHpe4SX34fBjT/f+R47Mlod1MIr271eDvnuNTisyok
 XpX02Nu0
 Q8pD7HpqVshZAPY+pVW0pEpi2AduGXuMtM6Ik49vDOaV25VpHBAK1kTemxBye69HEtX7egrOqpyQ3gNUbhE5kRlioEsqkSt2S5n2XbI9BSlteRQQNsJbx54sMIlyN7wKeYRj8ot6ABvKJMnUHrlrC4NzTCGevw6uP4lCUarYKuevJoxgPh5mZGx637TethSZF0ZLGkV8PuF2XioetoPM4kiT9yU9fPoXTzuTCPKi3rjwrh5T1qHgD9vTKLQmfsMEakZscu/eO9u+Jrlhjt07ArmzEU2VI2I+jVdZIXkwihDOXp7frtA8VlrQu4nS+GJJbPFM5d9yFPiYMVywAtjslwxgOBsU3M8aN5Jf9JJFYuLTG1llduYXxTg+P/8xhZnfxOsxtuGklOP1bx+/Eo3zWXXaOnOd8gGGsQQoAAFehM+v2hmim0HZD29s9JUxEtz1wP6Cfj+NdKohBtww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ryan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on kvmarm/next soc/for-next linus/master v7.1-rc7 next-20260609]
[cannot apply to arm/for-next arm/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/sk-gentwo-org/arm64-tlbflush-Reset-active_cpu-on-ASID-rollover/20260610-063444
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20260609213615.2788698-3-sk%40gentwo.org
patch subject: [PATCH 2/2] arm64: tlbflush: Reset active_cpu on ASID rollover
config: arm64-randconfig-r132-20260610 (https://download.01.org/0day-ci/archive/20260611/202606110405.ytZbcvhH-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 12.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260611/202606110405.ytZbcvhH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606110405.ytZbcvhH-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   arch/arm64/mm/context.c: note: in included file (through arch/arm64/include/asm/atomic.h, include/linux/atomic.h, include/asm-generic/bitops/atomic.h, ...):
>> arch/arm64/include/asm/cmpxchg.h:169:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ff)
>> arch/arm64/include/asm/cmpxchg.h:169:1: sparse: sparse: cast truncates bits from constant value (ffffffff becomes ffff)

vim +169 arch/arm64/include/asm/cmpxchg.h

10b663aef1c2479 Catalin Marinas 2012-03-05  168  
305d454aaa292be Will Deacon     2015-10-08 @169  __CMPXCHG_GEN()
305d454aaa292be Will Deacon     2015-10-08  170  __CMPXCHG_GEN(_acq)
305d454aaa292be Will Deacon     2015-10-08  171  __CMPXCHG_GEN(_rel)
305d454aaa292be Will Deacon     2015-10-08  172  __CMPXCHG_GEN(_mb)
10b663aef1c2479 Catalin Marinas 2012-03-05  173  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

