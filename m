Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF86EA3F2B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07EA16B0005; Tue, 10 Feb 2026 04:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BA56B0088; Tue, 10 Feb 2026 04:20:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F3D6B0089; Tue, 10 Feb 2026 04:20:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5CF66B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:20:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5576B1A0461
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:20:23 +0000 (UTC)
X-FDA: 84428001126.14.F156679
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf25.hostedemail.com (Postfix) with ESMTP id 99950A0009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:20:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YxD//zBC";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770715221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZJbvlmncuW+SvX3EnnoOnQFpAxERSq5MZkzJb5871c=;
	b=6AX8zZkw2CNGkPnxH7p+sKicHPhvjF5ToVVTe7z/KN+qI0w4YPXUkQnzZSWXTrZhevk8XR
	IZ9YWjfCdt0mGZMk5J6Jl/kPSaX7xcEKiD6ksYYDdTyr/TZk013/UQzjqrHqXUXiBlwZdo
	7afOTPXwk6jBJXtAWtncm1Ja68yEjPI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770715221; a=rsa-sha256;
	cv=none;
	b=u8jADNosw2iWvaArEMximctHHM0Fa8cSPO8vLCR1sBNZiciTggZfL3l8XSQ4zWYyDaKMcF
	hOkcRo4ojP92t4ZO3iuJa+CciL6Pc8k8MkE+Y2RjJ0QUa9BU4lpgclldnasFfNqcmkVeYM
	UBHVIGb7nj8Gq6PAT9IDmk4dcynSUiI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="YxD//zBC";
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770715220; x=1802251220;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eQgsNikdLA9WGtV+2Jc8iCxtoz8PhA8OzOuvWT7p0vA=;
  b=YxD//zBC6MsjBvSSM8SnhHbnGwZfFpknUnYhxlXjzQFCZQEykVpedQ8R
   OwTrf0esixz7C4qaj6Kpf/AuZryH1Vlqz80Y9NNCItc8gSeEJv4QllMXa
   iqwl3F2xU4RsumO2m6y1lBhn0BzDYhF/e7GQ0cKI7GPPlnZgVcAj80ix+
   9ui4SAzTRiflOSJ06qNZq/ix/nb3RXreEF6ogPLDtkBgti6v1rav0FTAe
   yBnXdCrmsJ4bmphHqiovvSnwMO+DfBFxg+1jbcm+P2LJAMkTeQy6+NvGP
   HRqYD7b52UmUXL5dWvzXE5p8RICOVwR8Zq8Cd6wsQFsBFEdJXzDPU5Y/I
   g==;
X-CSE-ConnectionGUID: +lJzFbgqTn6bXBWTI2Tn+A==
X-CSE-MsgGUID: NNAJGCZwRBGtLjKsUrdBwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71907989"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="71907989"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 01:20:18 -0800
X-CSE-ConnectionGUID: X9Ft9ZWpQxOKN25NCH+yPg==
X-CSE-MsgGUID: ugjiqRXdTyWfnyhzJcwVwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211190798"
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 10 Feb 2026 01:20:12 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpjuj-000000000kb-36fu;
	Tue, 10 Feb 2026 09:20:09 +0000
Date: Tue, 10 Feb 2026 10:19:57 +0100
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	willy@infradead.org, david@kernel.org, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, lorenzo.stoakes@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
	jannh@google.com, rppt@kernel.org, mhocko@suse.com,
	pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/1] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <202602101014.tdhEXT8X-lkp@intel.com>
References: <20260209220849.2126486-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209220849.2126486-1-surenb@google.com>
X-Rspamd-Queue-Id: 99950A0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: x5ac785a3fke6uhcmte71zogcxfaa5m3
X-HE-Tag: 1770715220-475287
X-HE-Meta: U2FsdGVkX19Ks69kvWdeqxDEG1NsvL9j6LBkJosuHJF0QozsLBeeMZGQA+NSTZk4s80EUxSnEdLeISEfdlI4Y1HkKQMx7Y0fGIVuMriHar98ESqsCaTaevyjDOBKz/bMWFSimMlzm0HaZfKtv65jM8hOHx5fkBUbttTgkFFPLYKuppnnIw3h3P3TwfGdSFyHpp3s+C+M/iOd3isrEgjtmpoBKQqR6USkVUgJNMqOZQFn2am3MgGtRQENGOyMBqO/GYVE6Na8Tt6zG/iEV6bQvpov2AAQ5nuZ9yzQTVbn3wX7leReNmGccm0CstmS01P7QUO1EgQVww9pCYx0BiGU5M10NvgfY1wy9+D6P1SC4apk+zBh76hethpwGH76GpkVTwKZ7QtiptG4BgrRggwS2kGZ2i7bkZyIz5lK79Gykjm3pkADVgaXruL5dPh57nMrtYdpiwNct9KgAYowboxeDrWZL0kYGqZJ0l7AY9mAE59y5RilGvaM1LGsQ0XE6Yw8CGQmboLoGGD9qWk50ElSDNLEeE+FaE56GiptptYZWQwg73CL51NMIPDX9ysZD8+XbCHeS39qv4wqRT5aMe7C6LZz72RRjcnXnVvOP+d7ou9+s1H5QrzKsYgzJPotds4Dn04jJ/dxapXqgxQNmV5/VGMunF6gct3qkY/FJpIFk4oqchRqPUcRJWVuuzBj/AG0a3BSYMckqDBOXmXmnMh193ZTK2VPwG/9GsODGxAKdXD5enR/SrnjwcbQKzqQdXtrwhH9LYDyj+GtAC8epJG6xId6kLudwZMU381KSfliYNbyOkcw0aC1E8H/y88ApBY6CGDM04g7TvTcOlSoPcRJy8EDSFUpoIF7gVfD32ZOP9ikvAYy4TNEvsxcsly/P39g83ckaAjXNdX6dAOmsQbpj3+weS0wt4DMIOt/y0uCl7xEUt4mxra/vEncQkjggRYETH4m40jpzCcl4wHPwtn
 9a5nlHRG
 V82xM7mmuo5GrSnifnK0hYiyZ+076oLaskVKqs/tUcJuI46/bmnXwEtwIF2VFwysaHKCrnOwZiWwJMxGsaxwb755Vjy12S2pM77XM+s0THAbDdghfYZ8DsdgLulgFmUBuzpbnKeIvVaJKHtkqWM2BqDwVPuv9105y9V59Qhh90ICyWvTEVnB8yMIO8ADyRdhAM11pLpfrVQaZiPfxdDHdh+EIL104JzSV9/ZdLgdGB/7fBG9BcgGiCI+PTA6ccqrRAYQLck3yAhjbj5aYAzfBXy42TIScDo88gaKw5qZSMG6TUW2OdTx5aJBQZ/iO7VFIOBlBjG/mZQr1jNa0TrQJXownfC8zs47jei0MaIGT7juZudrPa6DQiiwYdT8Xd0sAeKnTlfZwY/4IpfqAmxS39f5h5ChyvIDtnKlZ1Sg8YpkOTQo6pG9I7P3ArzBsKciQEvL/4stv1CvEDGYZ3AP76M779g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build warnings:

[auto build test WARNING on a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/mm-replace-vma_start_write-with-vma_start_write_killable/20260210-061104
base:   a1a876489abcc1e75b03bd3b2f6739ceeaaec8c5
patch link:    https://lore.kernel.org/r/20260209220849.2126486-1-surenb%40google.com
patch subject: [PATCH 1/1] mm: replace vma_start_write() with vma_start_write_killable()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260210/202602101014.tdhEXT8X-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101014.tdhEXT8X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101014.tdhEXT8X-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/memory.c:381 duplicate section name 'Note'
>> Warning: mm/memory.c:381 duplicate section name 'Note'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

