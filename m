Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEC6E67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 11:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216796B00C8; Sun, 21 Dec 2025 06:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E55F6B00C9; Sun, 21 Dec 2025 06:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11C336B00CA; Sun, 21 Dec 2025 06:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 021876B00C8
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 06:22:17 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF503C0F3E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:22:17 +0000 (UTC)
X-FDA: 84243239514.16.EB47803
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf15.hostedemail.com (Postfix) with ESMTP id D513AA0007
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 11:22:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bxls/pEz";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766316135; a=rsa-sha256;
	cv=none;
	b=E08YEVPQGeThlKWj30Ksmi++Div1Ffm3PhVbl70Syu6R6+2DGhQfD5an1qdoL6KcUASYzw
	Uz6wT7cJ5w4fkFPj8UkS0ctlN0US5LuQUEDOmXrhdh4EER5H4CFG6rC3nb/YVCmmCvmO3M
	uFA7E7YownOwZ1JXFA7dIyuzDafTR9o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="bxls/pEz";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766316135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h3Zpi5DOMzXo/NHsFweMwe6ItVIwCBzZpkUTcEbnJW4=;
	b=ynwjGhh/35WXEMqKHtjZpK35JkhVe7VhnS9c0Jr1aL9naj4DqEXkANx/L8cQGvjQ3+kAI6
	yCS0s2C+1vOj5MH3GxmaIZ6I+5LY1tsuIykb3bMwM4/hmC9Z6zKrZ8rI61m+L+4ZiITUCA
	YGIgw4YdepauWeJ/H2+LIykbewfS4vU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766316135; x=1797852135;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eKcsE2VJnI/4lSfqhwMzJl/DukDh/7mH6GBUXDAbjv0=;
  b=bxls/pEzhegWS8rop7d0D7rAPqWJy6nzc1u1+FhuyWJ1Bbxz2lV2oUli
   nzOumhwsruEq5thGiqgSJLqlmeehmiHPc7RoAXtH3rfgeCqvAvyOIrFub
   NvRQ3A3vxuD+OIcai0r4mJwnROlSsH0ssQaOCYnsTomfnvFiEQsBQd3TC
   kCs1oa2tRFsOwu0cPl9ErO89Xwn9R/tlSZfgOS+4VqLqY837KpYRs2RPy
   xemaOpOe1sM3pLufPZRmmOcVxwmR6vogIE7225/AIhQHb80TWZlsV7tF0
   l/dtz8OpMMyqzZ/WeLEDFQ8l/5x1Cf+PQPrPmb8FraoiAf1wADcKvO+qG
   A==;
X-CSE-ConnectionGUID: h6ew68hGQl6pNQXEn8n/eg==
X-CSE-MsgGUID: XyQkFFvJS7G1pFsxLYB3sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11648"; a="67399300"
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="67399300"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 03:22:13 -0800
X-CSE-ConnectionGUID: etHw95yLTB+B+7dyQ9t8Lg==
X-CSE-MsgGUID: i2dI9tmSS4+zB5KsAJCk6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,164,1763452800"; 
   d="scan'208";a="199253512"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 21 Dec 2025 03:22:10 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXHVn-000000005bB-2OgN;
	Sun, 21 Dec 2025 11:22:07 +0000
Date: Sun, 21 Dec 2025 19:21:23 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH-v3 1/3] genirq: Fixed Global Software Interrupt
 Moderation (GSIM)
Message-ID: <202512211933.p2Yg8Zzq-lkp@intel.com>
References: <20251217112128.1401896-2-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217112128.1401896-2-lrizzo@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D513AA0007
X-Stat-Signature: cfdoqqgaqfpegret49kn8b5y8kpx7t6o
X-Rspam-User: 
X-HE-Tag: 1766316134-245845
X-HE-Meta: U2FsdGVkX19BirZhj86bIv8xioCFrNRmshT3fK44c5NXfm/TipldOflxLBfbfKd/sKRnC0KBxjOifnfzdcg4MnMQWYa0d1IIu7Tq3/rrW+qOfHXqcJ+ZAoFzb2Gv+/T8CXgHGODZ77IiJvmkC4IaUY0wkPCJ/s+rhUm71HuzvjEQrVVpPlp3ZFm5NBWa0lt8AP3JWknw+3e3xyhnkecxRWNtZpF8byZP+emB6Fxikvl1tJWNlDw3afSfvrZin6mxHXk/KK16iEdrbvuIBY2eiTXCeuWxbTbmJV3+nJTgm3vdeflLUialEgPKYWo2mQzdWjZOUyiR/VrhCqmMQaXnSzPJ1z0mjiWLYw1u9frMKm1AiKPAx/ShVTOiQUtvZ7mY+RekeeYMQMiNN+Ce3JEp9RtsSilMIys2KSvsaCBw5vTysahxCaThB1Nri17mPPdsHe8EM9QBjOMhM5C1Bqz8DxGwypMohnHAKUTMuh3H3GY0+L91tzJbeUHgYK0TDowyodCvxBa6RfnWfRO62whAecFiNVZNQOBuXeZU6MJ+JiOaRFgcdWnLT8KizgZDsM+w8jdBd3mPexstkdwPUBeZwKJP6ZaHA5+pHHoJHkoqoJZ11PxYmDPmFqA71G7MAwNvcA9twMyXxOEjTHRPv9Jiv+cNUuwsmTiQ2mx3NcBKgeNDnuKq30VmekcxwnRRwebn6ECqeS0vlz7vVZ+5mlwsUQFl6fNfYemud8zzTeOJy74jVhj6l2d6b4s9FFER+zIgSnjrhk3xOPTnJVk3uiDLi+2x3leACTY8FwvPTGv/ia3LARoZdtjPx1xAs4iPitbb4gVxwg4VyxTeLUhg/FnPmmlrqzKUQJw1UYTFMe/AoXRwMZ2bTcrPLSOIii1H1EX/dE1AX4Y3hdtTnxkN0WWJbffbGIkdHHgMRENGRpXpuN09YT1Pw4a+cO/tqH1u6Cd6gQdlKAuUgQ49SwzOzkA
 xBCzAPwk
 l2ZaIKVUdelNVOpmfC/YKVAJR5cH4esJodAzd4mFkDjD63dW7Zz3KLa7fMGtTChIC81Qi43tV2LFcpd4mj5/78L+gCPkDVMAJKoNHkL0R33pA+DHRlZLgqmEZWJpkp85fcdMWOIev4jprT5lPr0tiSpSorothrjw4S9wkGaL55h5EFVS0JnUbchbMItwm0CNiz8GEMGVnJn3BUUcP8Eqwtyw5qB+N0v6pOzj4uDgsIgL1L58KS0fiYLKYdCHklg6swNNaW5g2xJkRx2CSpco/88XUHJf5IpB8UEXv1QbnZvRTSyIQi1lGNchdgO7lhT0TAIcq3bZ6Kl5q9LLf2WtZelsEJTgrS1wMmteY/eXOxW1Mi9kBBdkQ6TxtU4KZUVbvXkDP1XVhqaNB2O7RWFPncboDXz47++nPPSFNeue5rueFYaWUgT3EcZDbH1cbZbC4G+cv
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
patch link:    https://lore.kernel.org/r/20251217112128.1401896-2-lrizzo%40google.com
patch subject: [PATCH-v3 1/3] genirq: Fixed Global Software Interrupt Moderation (GSIM)
config: um-allyesconfig (https://download.01.org/0day-ci/archive/20251221/202512211933.p2Yg8Zzq-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251221/202512211933.p2Yg8Zzq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512211933.p2Yg8Zzq-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/irq/irq_moderation.c:141: warning: ignoring '#pragma clang diagnostic' [-Wunknown-pragmas]
     141 | #pragma clang diagnostic error "-Wformat"
   In file included from include/linux/uaccess.h:11,
                    from include/linux/sched/task.h:13,
                    from include/linux/sched/signal.h:9,
                    from include/linux/rcuwait.h:6,
                    from include/linux/mm.h:36,
                    from include/linux/kallsyms.h:13,
                    from kernel/irq/irq_moderation.c:7:
   In function 'check_copy_size',
       inlined from 'copy_from_user' at include/linux/uaccess.h:218:7,
       inlined from 'mode_write' at kernel/irq/irq_moderation.c:259:6:
>> include/linux/ucopysize.h:54:25: error: call to '__bad_copy_to' declared with attribute error: copy destination size is too small
      54 |                         __bad_copy_to();
         |                         ^~~~~~~~~~~~~~~


vim +/__bad_copy_to +54 include/linux/ucopysize.h

808aac63e2bdf9 Kees Cook 2025-02-28  43  
808aac63e2bdf9 Kees Cook 2025-02-28  44  static __always_inline __must_check bool
808aac63e2bdf9 Kees Cook 2025-02-28  45  check_copy_size(const void *addr, size_t bytes, bool is_source)
808aac63e2bdf9 Kees Cook 2025-02-28  46  {
808aac63e2bdf9 Kees Cook 2025-02-28  47  	int sz = __builtin_object_size(addr, 0);
808aac63e2bdf9 Kees Cook 2025-02-28  48  	if (unlikely(sz >= 0 && sz < bytes)) {
808aac63e2bdf9 Kees Cook 2025-02-28  49  		if (!__builtin_constant_p(bytes))
808aac63e2bdf9 Kees Cook 2025-02-28  50  			copy_overflow(sz, bytes);
808aac63e2bdf9 Kees Cook 2025-02-28  51  		else if (is_source)
808aac63e2bdf9 Kees Cook 2025-02-28  52  			__bad_copy_from();
808aac63e2bdf9 Kees Cook 2025-02-28  53  		else
808aac63e2bdf9 Kees Cook 2025-02-28 @54  			__bad_copy_to();
808aac63e2bdf9 Kees Cook 2025-02-28  55  		return false;
808aac63e2bdf9 Kees Cook 2025-02-28  56  	}
808aac63e2bdf9 Kees Cook 2025-02-28  57  	if (WARN_ON_ONCE(bytes > INT_MAX))
808aac63e2bdf9 Kees Cook 2025-02-28  58  		return false;
808aac63e2bdf9 Kees Cook 2025-02-28  59  	check_object_size(addr, bytes, is_source);
808aac63e2bdf9 Kees Cook 2025-02-28  60  	return true;
808aac63e2bdf9 Kees Cook 2025-02-28  61  }
808aac63e2bdf9 Kees Cook 2025-02-28  62  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

