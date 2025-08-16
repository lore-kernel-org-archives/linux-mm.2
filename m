Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3493CA0EE9
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 17:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EDBA8E002C; Sat, 16 Aug 2025 13:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5488E000A; Sat, 16 Aug 2025 13:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB5D8E002C; Sat, 16 Aug 2025 13:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6738E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 13:43:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C6F21371F9
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:43:38 +0000 (UTC)
X-FDA: 83783342916.13.CE4A11B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99EFFC0008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 17:43:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=evt0mvYC;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755366216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FCws2rMaEQ0GCLwo88ObhglZq7cJCucg5vstvdLVv0=;
	b=jz9+OWJgGDzQCc9osDdx0AvOmY6NDJnlBR0XeRAvkREkUrJuR0ypsxpeIHYb0hzW2turMq
	jzKgcuDbzlEcLqU/O11LL64Bt0d1cnaplTfq5EFPkvdgzfGjChSlt6JCQkXDKum4Z34kId
	uvuU8YaeHabSV45urVgEE7CHc/2PdzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755366216; a=rsa-sha256;
	cv=none;
	b=zN+yzvhSU6cvinCbIGXWLqiEE5qa1bVSJBHAS8bf4bWMA8nf+HHAWyeHBiQ1fkX69+AMC4
	C5s4genu/i/rYUSksV6elccQcQlZUfXj1U0S+kRWo/T8Q9i9UiVsYa0HI8I+GnYJtXW5af
	d+iT7Fl653FrTKsP/3pJnjFMikjLS8o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=evt0mvYC;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755366215; x=1786902215;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y4+5jv9bJIBFZQ94IeivVBSbqAYFaK3hmZElluVcB6I=;
  b=evt0mvYCgQvEraDNidZpbwzEBzoCkqchmweQ12fcQY9uiuwR8qERR0ml
   9H/FfJSNLlAS1p+ETBBHTGtqoakuhel89xn+AaKMUW6v5hoxfvE/GTgK3
   1RO/zV1dbZfswce/coDubh8Lext/Y8umg0FIyrYv+C42ejYqpW6hR/VtW
   U8eMOayCTcKBljJ84UchhEBQZDWjMQf6JFSku8zereKWItvFyOM+xpZk7
   s5WWkQOC7vgXVvAcEVljqiGDSmPJYeeYCAjbBh6cXCjh/aOvoZzMhiIhc
   a/GKTlGVrpFkP9zRk5o+rl5f2Wm0bj+t01byWaym2VC4A9epFWAW5vKoa
   Q==;
X-CSE-ConnectionGUID: 8YNEtCC8T2e3a7+p8Al9zQ==
X-CSE-MsgGUID: AqrlsyNfT4Wb7jwmcVvuKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="57729988"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="57729988"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 10:43:34 -0700
X-CSE-ConnectionGUID: u5fyoiCRSxqNtJTZgcMK7g==
X-CSE-MsgGUID: +IACfkfOQvyRdCq6GHi/iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167621159"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 16 Aug 2025 10:43:31 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unKvy-000D3o-2K;
	Sat, 16 Aug 2025 17:43:20 +0000
Date: Sun, 17 Aug 2025 01:42:33 +0800
From: kernel test robot <lkp@intel.com>
To: Huacai Chen <chenhuacai@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
Message-ID: <202508170118.0VFEAq7Q-lkp@intel.com>
References: <20250816072149.1952348-1-chenhuacai@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816072149.1952348-1-chenhuacai@loongson.cn>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99EFFC0008
X-Stat-Signature: rak47uuefxst79rftfz8x4kci4e4e1jb
X-Rspam-User: 
X-HE-Tag: 1755366215-132269
X-HE-Meta: U2FsdGVkX19QQSLErGlYLJZZJ8QNkMhv3H9f3Q+/yqkRT89sfsdfBfyBnK1MgWLm3t+m7yLOAtQ5BqQfTjlqpMjIOMCjOk4cZcvLw1fpm2d1/k1TjguSIykvY/gn1HBkUAZOoEnGrgKtYORyfW5EeA45pZAx970icBeuInn61YPvB4n/7OB/KPI6X6HfRbP/DLxZ7GNLwFy6FH+hVzLwL5JBKALI2gVLTotfZp3UFlJtfObnk/aMzrZdxmQNgWenkrDfUldPZUUSxRrGdFEUNU/LaOjEkbmVBIN/8Puw0LmpRQwGYtSD16mt/1N/Fcy7n18cIYxYS3zW3J7g5euO97bo+16JFl4OrXQFBpTRdGrXPfjFDVxOQE/cx3IPfEVeH3uBzruIPUp+4Zufo7M1E6YEjHVDnzbR4QHmZZd6wLnZ1y5W2EhEN8/f3r6wMqc8c8pFX4Hiyr+iUyNcTBiHiAdvE2dICvujl3YaK40g1uuothzQucpmi0lgPXmQddND/y57Y7E+IxNpTFzI/1kYVw5AFPz30LSjFYNB3joKgWvNdDhidI+x1q//Y1CqFj/UV8F01d3jgSsyMckZGlOJ/D17KVD8Qi8BQVpLUYew2HKYzXl0yQj64IVodGEQtiYGn64q2hWUwQb9biLWNtTJfFNy9ewFnjspHHHkruJBF3qwflMMDoBCC0PqFQ++NFTjeua8jAm5PqWc82LOtqTTd6wAxtn57EEgR8vjqxDRTqWIICJ37ISCbn9hCgtrGcbkzlWuZgbPmNf0YbGF+sMSrTDubhVoRCxwK+jNrBS3NK87v82FnW2BJmnGbj1iJ9hdAItlm4b78xYhIRF5P+M+uXqmcz1umC8VSTKYFLHuTq7cKAWLQBwpLminaA1tkiP6q8LdtGQ+niKQpMF+cOjtj56/nTT0LzXxawxyYGw/+/HwKVOIwkUfYfETUZQQBoZM76TPDDZYiC6S5uBLbik
 awkclp7D
 Yjhhs6Aazd3I6nqYq3Sjk2QaY0crQ3ntJeXH+gMnZZ4gB/Pyjpe3lJMoHGDkr3EY+aha4pLMGmAk1AX9sMu3tokMxoHwFN8tQJt4/jifc4WZA32yfN8KHriY5guCG0FWZRg6D8Rgc1vuVxeQP8x8l9kKd9WNVNPdNFUY09/ZQGztsTMKaC35nd+DpTAj3Hl2UvOHbKs8SVoxPIARd9FfxM4XPJRVk0gCj1zRla58P2HrfIcIcPUV78CAKQcLOxvohYUBhIScJ+eIdpxaFIRv+wl5vObL4GdEat0dFWgwnylgs6+xBe1hTVyWRqZ6m8Phc2e6JiiT31d9lgSe7wbPetgDENSLuWE4CQB2zezv8BAlDQGz77pWN/jvzTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Huacai-Chen/mm-migrate-Fix-NULL-movable_ops-if-CONFIG_ZSMALLOC-m/20250816-152326
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250816072149.1952348-1-chenhuacai%40loongson.cn
patch subject: [PATCH V2] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
config: arm-randconfig-003-20250817 (https://download.01.org/0day-ci/archive/20250817/202508170118.0VFEAq7Q-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 93d24b6b7b148c47a2fa228a4ef31524fa1d9f3f)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250817/202508170118.0VFEAq7Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508170118.0VFEAq7Q-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/migrate.c:58:42: error: too few arguments provided to function-like macro invocation
      58 | EXPORT_SYMBOL_GPL_FOR_MODULES(movable_ops);
         |                                          ^
   include/linux/export.h:94:9: note: macro 'EXPORT_SYMBOL_GPL_FOR_MODULES' defined here
      94 | #define EXPORT_SYMBOL_GPL_FOR_MODULES(sym, mods) __EXPORT_SYMBOL(sym, "GPL", "module:" mods)
         |         ^
>> mm/migrate.c:58:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
      58 | EXPORT_SYMBOL_GPL_FOR_MODULES(movable_ops);
         | ^
         | int
   2 errors generated.


vim +58 mm/migrate.c

    57	
  > 58	EXPORT_SYMBOL_GPL_FOR_MODULES(movable_ops);
    59	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

