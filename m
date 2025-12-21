Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5F5BD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349996B00B6; Sun, 21 Dec 2025 04:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D0C6B00B7; Sun, 21 Dec 2025 04:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23D556B00B8; Sun, 21 Dec 2025 04:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13A1A6B00B6
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:47:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC3211407BF
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:47:13 +0000 (UTC)
X-FDA: 84242999946.18.EE409E2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf19.hostedemail.com (Postfix) with ESMTP id 375CE1A000C
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:47:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JPuPOLtc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766310431; a=rsa-sha256;
	cv=none;
	b=nTHFvabPO2LULJNe6eZle7S6cYjXJerqo+Uodxxef5kb3ayodyv0IQe3CKtozrkSnErtUb
	w80+GGQOJEnUIT6GBOgdKdF5Gu6KAE1AcsCzFqzvQxbf5+zzEUXJ5SVXXTMml3SI5cbiox
	nA59/T8R1+V2MJNc+wA+kTi1WtJiGJ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JPuPOLtc;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766310431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mp2F8mKyrxxV9vppIbnSemfoD+6obmMGT9u99IFGOCY=;
	b=oYc+KJFFoE66uKKe07n2WjcQ/W1V3z4d9nXlDseSBSenUgxzj2yX5b3UN/nmm1KRy2SMDG
	1vALMcYY9vsVEujmGoFt72alMTbkGcougthEndjWC3SvKIPx1IneZuZBHpLPUsJ1ijhHNp
	8ErfV7ekz+quEY5WbBLGDLBhuqF0OmU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766310431; x=1797846431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4rJv5dqd8vQSSuUWkhvYaw7fdGbR4zlzLZporGj9z9g=;
  b=JPuPOLtcp1U1NjtxFuau/N+G5a9csBPWaeLksV8aueo6F72/2iWMsutp
   P1SHqZj6TE7KeohHX7HxCQ21m950SsNTnxuHwDkLsruQrnygMN/si0PHA
   gpjGbyIAsLF882/Qyf/t6tg9Yg/z7M19s+NOuJKynkVrkdUOAAzgddkFj
   vswlE617wy/HfQvolcA6pHScpC7qO3Ls5fkJqHL3UI8EJ/wWgxVaVILr6
   PvmJ6zWq1JIAdGHs6a05hO4f+tG8hysACs8hIqZUMwAUiM87eSB4lkBOr
   6+yKTxn4N/27HsIoBboAg9sGCB6t1z6xrhTFoDB3Wzc3B6TYHr+6dNCHi
   A==;
X-CSE-ConnectionGUID: dCB7p2gcSuu6nnWKhKhxYw==
X-CSE-MsgGUID: SpVFfthDS9evqwVVc1jKIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="68246098"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="68246098"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 01:47:09 -0800
X-CSE-ConnectionGUID: MeU1WLjjRvyTa7CkqD6twQ==
X-CSE-MsgGUID: CMUSjbIkShmtezCjTP8dpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="229935926"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 21 Dec 2025 01:47:06 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXG1n-000000005Vl-21fQ;
	Sun, 21 Dec 2025 09:47:03 +0000
Date: Sun, 21 Dec 2025 17:46:40 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH-v3 2/3] genirq: Adaptive Global Software Interrupt
 Moderation (GSIM)
Message-ID: <202512211737.PVtnFVdB-lkp@intel.com>
References: <20251217112128.1401896-3-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217112128.1401896-3-lrizzo@google.com>
X-Rspamd-Queue-Id: 375CE1A000C
X-Stat-Signature: ptq6wfr5ammk7mhfpsbk9rkwuc4if4ha
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766310431-429938
X-HE-Meta: U2FsdGVkX1/U2vi0yl9PR6OzRbX7AlU117PXX8CRf8GHpPyrtYybvFih7O6GKqmUSOfdyfyEg7aFB1IvHLD4FtEz4WGd6aYMe7t6u1ngZGbYNRZQ+ghA7/1Rk+h0wknkhJmOz5isDG0+s5zeXvIOERrslbuXLcp2x1CuhivG0PMevwCTh556RtEQav8vRdNQ8OtknGwWq80h4zkUa1uwJxPwo442U5d5lmiJLonPkbuG0VMaHtLM4CV124T1yD3hxwCoXASz3WiFOIBVJuZKZYLt7tGfVyVZwEH3zo9y5+oA30FxMU75gfWNbRLVAwqjk5eQC52WNjQqgrFoNUUug4D86H9sbyaEfTQiGadWdLF6IzEmyYMZifEd6zYafQSplGi25nnHJw8WiRsso4Fbag+z+dF5HspDHX0BIpc+4pfjkY/K5PBoUInV9EHdZC6tqbXVF37R6JYZcttSi3vl5r3/mtV8DrOV2jrxlXYuyCkZlCHQal3XwI8kQHBftIISg1MIIOfZugXVgCPUb/Y44PdhWwqLhZjNSGpzfhr7qETimB7Y/Du3TJL2uaWRetBlhjZxj+ldr+2hRXJ1+K9SXsX8UDWS3ZkP7Z/xxaer/32g40OF4DPX6d7BlMeTEnVOHvIxRdq5F0tx+L9qCRHRfP5aAlKZhM6g4HIvFtoxvn7MmJQ9NKskNahMt41rQy4xmQS8raeL7ZMkDKKPTSnnzK3+KYbzX4OKQLgACx9wM+BDWpt6fEdBacR/Tzj9jb6P2hi8Tgs+XQ+wqszgHbWDOFGHE9ma06hotSWBLaUyHmiMUFRDqHn2vUC2uFBfFJH+UG+Tb2OjPb12qQg+afd8hA4x4K8bk54cXdEeRm64WSXrfiFezvnI6PbipLP/yR7/t8ZJz71wSsOwqLZwpDOiqE8Jo06dsAnIYj6xDfG3IFRwHYcueEqdKAHTPwoVdkD0Nv/QpAj5eCWH5zQbDHd
 OIUjCe7M
 GOplHFP7Qla4nUIMvkcZjYjcY90v21HE4WlVD62C3BwZxOFzdGoNuujjLovb5yn5bOwqBSPqh05gTerZIPVKgDgjrsiBx1I1H3o7DNzJJNCdTxxhTAlnav7OMLaBgAopZdXy1J8oLtye2vpNPOmTLUrYfxBjAObUtuB60rL84v5pftHxVhfCfQL6x+R/zLTA8vWlCWw1GI/UhpAECC59dMV/sZWS01u7wlnn8kcHbVCanJvNzluyJm0trnK5omplrctCIjwMF7mLDZaUWWlitNe+XXnBNkbAZ+9JxM+iuWdB2pOLfjIEYI/2N6rejyGnerx1lGq0zlwRIbB0WlHE3kuRHhRGwHd8GRL646qpuR38LGun0BtPGDgJJHuuhsaH2qYV7gHsTixIxEPUw/HgPZKxWiF2BgL8gdrHx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/irq/core]
[also build test ERROR on linus/master v6.19-rc1]
[cannot apply to next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-Fixed-Global-Software-Interrupt-Moderation-GSIM/20251217-193249
base:   tip/irq/core
patch link:    https://lore.kernel.org/r/20251217112128.1401896-3-lrizzo%40google.com
patch subject: [PATCH-v3 2/3] genirq: Adaptive Global Software Interrupt Moderation (GSIM)
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20251221/202512211737.PVtnFVdB-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512211737.PVtnFVdB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512211737.PVtnFVdB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __hexagon_udivdi3
   >>> referenced by irq_moderation_hook.c
   >>>               kernel/irq/irq_moderation_hook.o:(irq_moderation_update_epoch) in archive vmlinux.a
   >>> referenced by irq_moderation_hook.c
   >>>               kernel/irq/irq_moderation_hook.o:(irq_moderation_update_epoch) in archive vmlinux.a
   >>> referenced by irq_moderation_hook.c
   >>>               kernel/irq/irq_moderation_hook.o:(irq_moderation_update_epoch) in archive vmlinux.a
   >>> referenced 1 more times
   >>> did you mean: __hexagon_udivsi3
   >>> defined in: vmlinux.a(arch/hexagon/lib/udivsi3.o)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

