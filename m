Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09DB21039893
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 20:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A22A6B00E8; Fri, 27 Feb 2026 15:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67A666B00E9; Fri, 27 Feb 2026 15:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578ED6B00EA; Fri, 27 Feb 2026 15:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44E876B00E8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:31:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A50671608FD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:31:11 +0000 (UTC)
X-FDA: 84491381142.09.42EE0E8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf18.hostedemail.com (Postfix) with ESMTP id B44341C0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:31:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="GWnipP/N";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772224269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ITvchWcldiMRgr3VDiQE9t8JFdaXqDUV+a+BP0kAlo=;
	b=X2xcI3YGr6kaS75NBP/8V1eE+tYW+iEgSfCyS0lYbVa0VqDZKCumFUvWq8sXakSVDH4hNx
	gDf6woP9LWt907YFE28vOMRCHtACuS83VM6BVmeG2ze1fJH+8V+SURJu2N0qg0ypcn2haY
	KyVjxzDuFmIyAX6VE8xUOjTPLiP9z2A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="GWnipP/N";
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772224269; a=rsa-sha256;
	cv=none;
	b=XIr6HrG59txx7zIwLwmVjWTpuCwOqcXOKSzWGaHzW6oVb4YoPnunBjRSlNrxoyK6LdaTkD
	qm78RiKapxUCo8LE9qibL2dwXJd5SxWwVvEsnG6bUB1/YzIhk3ahbcrlaJ4Hf2oy8V5ANN
	mUfM/sij+h8mnDDDo91gxuQmq062BBg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772224266; x=1803760266;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fuAscArmYg357MsE3htAgFOOKf+t4SCUkyfha++zEk0=;
  b=GWnipP/N/uD/trlDIS54i6ITJS2rvQq0DHx9FuNit2YtvNJr5h6fqQ2e
   eaWpqw3qX22wTlrt1QPkjsdg/Faa5IP4Nn1YktQ7SYAmK0UTJqZtt/kAC
   soYW31m6FQq8fcNTrzT0ya3GGu6IzRM9NWN9yhAd4c08J/1+BskmLFikf
   9bskFsuaurvPb1p6OdEsqaamJW0M/qC0/cYePI13032IUJt8l199jYho5
   PIFFH6c33cP8N8DRh4hrO2fgqlvBLG7NrBTphYw6nMC9dVK3h55lIDt+h
   vPGCqiQjhMWEnUjbb0rZ0Bcit/1XEDVZ4iO3i8MEyyoPzjQU5R0TuSmDy
   A==;
X-CSE-ConnectionGUID: siLZMmHRTtqxwxfU04N0EA==
X-CSE-MsgGUID: bN0ScsYoREW4Yie/Dx3JKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="73225518"
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="73225518"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2026 12:31:05 -0800
X-CSE-ConnectionGUID: n5E4HiogTn2++Omp7xOvsg==
X-CSE-MsgGUID: ziHmHMINSxmQwCOKxmGv5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,314,1763452800"; 
   d="scan'208";a="240005993"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 27 Feb 2026 12:30:58 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vw4UA-00000000B2T-3vIz;
	Fri, 27 Feb 2026 20:30:54 +0000
Date: Sat, 28 Feb 2026 04:28:12 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
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
Subject: Re: [PATCH v6 23/30] arm64: kpkeys: Ensure the linear map can be
 modified
Message-ID: <202602280415.zn69IEgu-lkp@intel.com>
References: <20260227175518.3728055-24-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227175518.3728055-24-kevin.brodsky@arm.com>
X-Rspamd-Queue-Id: B44341C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: y6qdmsaon8c1wgu185rbej5cje18bc4a
X-Rspam-User: 
X-HE-Tag: 1772224266-243467
X-HE-Meta: U2FsdGVkX18jcgPdEEcI2Gi0s1ze2dzkIpA++OA6cxXw+7qmWlQbV/POvP6eqrYzEEvIoOpb0anZ8lK8NgK92Xhx0u4M3Cp+1tLXmSU4i8XSaw+lxIs1E8Ji/4tDXUTk5JJRFb0pp/l2P78pmBBD1zUdM21oYQjlMSsrznDEyrjpAocPGDmJagI3bOvn4DJz0p5bKCa/EYB4gnf3Gnue5VROAYfJDaIqiDX/HOEzKkF0c4KIaaDX3CDP8cAedRYMg5p5vn1eJfKJpKBPd4PTPafhw6q+aHs3raTpG+rh645hBPbzgF6ue0cD9YqEx+KwH5C8TCU3EEl7xdDTB1OpwJlKijD/dHvqW5bv/w2y/7cmcz9xJT8ei9ClaH+Q9ZoQOKmQvZV0Hacl7kfA4ZnjvFwb1o888frzOwV4s8k35KigLY8n0M8nnXPKokQ9PNrLQqOb/XUWRVZUbGqlWdc93qQXPampI7lNzImxCzkOl6EZ07+u/iPlitwtHgxMgPPm29r2BtNZ0F7stRAXxl8EUJ91wH52trFAaxMlFFvVJxT3MVSqRwRqGpE7TGCRxJ1kIKde51SRK3M/06U1s0iS5bRstWr23BucZFBtlSPyikGA9nC91IrLgqzBJzWvxlJ/5Z10EIQYLIH8Boc7GiejsL4PTeP8CMuWnaYNm2lHVtqOKEAifO69tT33SY7IeCU7wGqo/M+F9/GeOFuoaLRdoT7ZODQmzcy9c6ef719iKCkVQWJZVamjicebfa1C4r/I4HPu3cGIf0Pry/2Igtz8tft6osrZkiHroNaB6M9WcbWMCeiD+Aqf39fHs9xa/R1mzHsW/fK5D7zfp5KZNshk6PqusZHJSoEplAEFdtgq797HHyM/7nKFcN6rPhVN/EcwDrIqmZ2nuCwtNZUkhQ3Cp8RDDlff+XrFMT3v6JyAXMeJb4JT+4jkbIw51dJTHsHO9A8rIjdvxFJLU3N7zNX
 7t+kBUGn
 3Tom4YcIyGaRZvKYWLp5C6sEwDBw5k8qCKKiQWuj2QU4Fk7z74VGEDgC/TLwM3J6ZVaoMZiKJCStb3v7EZV9g33YDMNKy5lyTmDUBz+22mZxU/v09XcxdYJ3UeIPEzG1BEc2VZDFg9DpPTHd1wXF7nH3m6i6b7P6H+mmSILwJmIbgJAwRaHUWegYosg12YKKAq9ptBS0tykz2a8duAfoN8suYDm+ZwtLxp8O1NJXFnC7Zc2M4VF2iMZNdI3RfG000aeVx6Z3CAua/tb7ln2/EwHO1VX4orca28sWvemPbwuU4VN4lRUZGwjKAeJamoGo7xScsWnvEnLYnYdy1n5DzIKww4Nc/G4SXJJ02MTIqEFtb4FVXaeleBvlcKn3HqlNtvaHWfLntc8aMfYE=
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
patch link:    https://lore.kernel.org/r/20260227175518.3728055-24-kevin.brodsky%40arm.com
patch subject: [PATCH v6 23/30] arm64: kpkeys: Ensure the linear map can be modified
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20260228/202602280415.zn69IEgu-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602280415.zn69IEgu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602280415.zn69IEgu-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/mm/mmu.c: In function 'force_pte_mapping':
>> arch/arm64/mm/mmu.c:768:17: error: implicit declaration of function 'arm64_supports_kpkeys_hardened_pgtables' [-Wimplicit-function-declaration]
     768 |                 arm64_supports_kpkeys_hardened_pgtables();
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   arch/arm64/mm/pageattr.c: In function 'can_set_direct_map':
>> arch/arm64/mm/pageattr.c:100:17: error: implicit declaration of function 'arm64_supports_kpkeys_hardened_pgtables' [-Wimplicit-function-declaration]
     100 |                 arm64_supports_kpkeys_hardened_pgtables();
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/arm64_supports_kpkeys_hardened_pgtables +768 arch/arm64/mm/mmu.c

   757	
   758	static inline bool force_pte_mapping(void)
   759	{
   760		const bool bbml2 = system_capabilities_finalized() ?
   761			system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
   762	
   763		if (debug_pagealloc_enabled())
   764			return true;
   765		if (bbml2)
   766			return false;
   767		return rodata_full || arm64_kfence_can_set_direct_map() || is_realm_world() ||
 > 768			arm64_supports_kpkeys_hardened_pgtables();
   769	}
   770	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

