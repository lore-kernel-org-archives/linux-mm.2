Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F224FD0055
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 05:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8CC6B0005; Sun,  1 Mar 2026 00:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0246B0089; Sun,  1 Mar 2026 00:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9F36B008A; Sun,  1 Mar 2026 00:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8C8F6B0005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 00:40:58 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37361C1F2A
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 05:40:58 +0000 (UTC)
X-FDA: 84496395396.11.231A8F0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf14.hostedemail.com (Postfix) with ESMTP id EF5BA100005
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 05:40:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HRZ89tj2;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772343656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOJ404YK5kY35YM14YgxI3j+U3ajXtmwt69xwCeyr5Y=;
	b=siuZyOoBOo2VDzfXsE2URMzhgskqzPLAWfiDJO+om69VdtcVo7MaSMZ+qLQhz3152Ug4+1
	E4rfi2BxHKxvrqdHYRk4lgPXcQlDpY5fvt7MkPSI89ArgDzea616h8YDS0scg4qll3/K5m
	1df/J8jMvtUhH+8fo44c9QzJw1ckLkY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772343656; a=rsa-sha256;
	cv=none;
	b=IDhMvAZIbcwfknsWmXMtXfWiE+nUm0TwlzhWD+FCwbJRszLAQBccjUxLg96jobFhGBOsCn
	fhgyim4ZdT0XZja2b23juQb9CD1P4rZt9vtQGez0W0tk95qb+QTs0pDRqKfpY9BL6jSrfS
	R1Gb9s3uz1ZacGPGNwZht/FFIOtZcdA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HRZ89tj2;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772343654; x=1803879654;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bX7Bh1sY4G62w/8Ni4dMQ5sJQC9mYDffOQ5bN4xsBXY=;
  b=HRZ89tj22waShpzPgcLlOJyx+GGhWUt99g4mrZBZOFQfVREiT06NFoRd
   2Dm+THFsThH/pjMf4ELGqbatXinh2Wg+rBWw5si8ZRx88UDJU8XyNxTiK
   NfOF16l/CAQfDt2SueggMxy7IDYBqaVb7OBmKeA5GKKQtsebeU0+xCMJK
   F1FV76lf5RJ1BFSri7JqJQg51cjMwM1hwQnpMDOI+AeUuMnIN//5+F4rW
   46ofA36BWpzqaDDsTGNtFdxRC1CPxnF8/VUYB9lagBOEh4J9RC8+6ComM
   w2Rzro2UJ1M0zIXjxBs1+9tH1PNjbXWz4kQPkz4ATQ3oDalc+/sNBfOxe
   Q==;
X-CSE-ConnectionGUID: SGX6X7X9TIKcELuYYD7ETA==
X-CSE-MsgGUID: cDO8J6XfRS2NzlfqJrIheg==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="72409789"
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="72409789"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2026 21:40:52 -0800
X-CSE-ConnectionGUID: GZJ0svEdTPK1NcJt53chug==
X-CSE-MsgGUID: gjnKd4RaQFedczhA8nPaBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,317,1763452800"; 
   d="scan'208";a="221430091"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 Feb 2026 21:40:45 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwZXl-000000001Iv-1db7;
	Sun, 01 Mar 2026 05:40:41 +0000
Date: Sun, 1 Mar 2026 13:40:18 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [PATCH v6 29/30] arm64: kpkeys: Enable kpkeys_hardened_pgtables
 support
Message-ID: <202603011334.LWFx8OiY-lkp@intel.com>
References: <20260227175518.3728055-30-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227175518.3728055-30-kevin.brodsky@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EF5BA100005
X-Stat-Signature: 7c4kb75z9hbmt114kx1zz6emf7pcor1q
X-HE-Tag: 1772343653-912955
X-HE-Meta: U2FsdGVkX18FcHoZ5AFuUvOjK42hQP945vNEEF0tWMHHh45ce8kKxkLgRoGba9ho/ZQS2n5sxMFnEMhjl/z9xTowm5iVwE3ZCaTnMUGwx01ZWvs5gUrCjpxylk40YUAQjqhZpy3tB4o1Rfh+PVnJVBB0r7iHPLLpkTapEF3Cj6ZPCBKtvb+2Bssfbyjwo2KXKGdVoqDE8Lloa15OCXD5M5CqOtjveyqjZxKrkVsphh07YEBEt1ElFJkF2yZQYYWKrCsSKeXQ82ywNcA+vHlJrmMe6wQQdkRtsYuWXg0LFbK9UT4Bcv5stKPCy7w8tWRAsVzoZ8dQNVMBKhYVHs8t/7NUB6PlPwcHuwwkzESbE4RCtDO65sv+z96EueaMJw6ohyk9Fy68WfAPwDK88EL7Oa3ahPraIa7QAjgwAv5fEPquL3Bi1S1A5BwFg9GBvBZkzk6+kKdR9HszD/pkynbcrqnMW6SL2nQioEzZ8b/YBdXAMnRVZU71rM4R9eOhKE5L//bpSGFEu0Zj1Nwb2xN6Tjhks6wqxEqIVDkDUSDY6k7g0m4GbXjKDZeJ0hnH7ygFdMMA0iVcYCyHfynMkrX56YnV3GPcjnVRsboMxFIDYDI9VH1lCYUEeQdm7CFGwV8pLmjm01ibN0Cuaepg64gGtBOTxR4zF3sd1v6O1rvaaoLkHMoaDUB+1I6jM8g6c3GDgBtR5s6ibgwwO5hqUuJEJp2xfvLkYBeWQUgfZe1D/FfLwPsDfO6rH10vYGCASfkTWpiT1sc6+v+6ul6o5rhOHOvqKh0aBSJTEKkkOxL51JhNOF79vEbIOnEO9O7wtOXldZYA4ZGBT2ZnwRPXacXINIPJ50yqsbo4o9CnLylPwBeGagNw4fvvlVkhL+GiP73YVNN8gcuDCwuzQQChqaP8e2Qbct9riCKd6VxkUuRvUAGbqSqs4pFPnLy6Zf+hjb0wa64EWlm3mhFlpLyxa9i
 HzsHwbYl
 KZPU34xCtOZld0QikT1OzNE3DvFC6KpWeN3Smq6gqqu1yNMiUI/rMgO4cgDSnTcndbupRTTv3UH1Rnvmz2Z4vvBTkiLbO6jgN6vf5Rbenrmm/ynl2tX6YGwiDCphRGNXTuQxJCShnWue873rjI7B4PVs7f4wgiDkM6dUU3etML12BALrzl7arqj7hwFjlYQ8+Rc5oaixvu1AYrNOvCMkK6Xy0XXHWsKG7leLrnwT9FLrecN0S72xPuEOic96Ni9xFMLlKsFIgix+uVpTpfQ19akUxDFCnd3ZuLEzEnwCVURGNgso4CEG/0UkyGIhwvNyIWfteUK5ZOIHuSyX1oURQ1IcLATDDBP3K0Mp5XnKVx8RD9vTBhdXZIuEODXI0rSiJjOCT8oW9NIkyqtfJ5IkYf5IT2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kevin,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f]

url:    https://github.com/intel-lab-lkp/linux/commits/Kevin-Brodsky/mm-Introduce-kpkeys/20260228-020115
base:   6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
patch link:    https://lore.kernel.org/r/20260227175518.3728055-30-kevin.brodsky%40arm.com
patch subject: [PATCH v6 29/30] arm64: kpkeys: Enable kpkeys_hardened_pgtables support
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260301/202603011334.LWFx8OiY-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603011334.LWFx8OiY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603011334.LWFx8OiY-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kpkeys_hardened_pgtables_key" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

