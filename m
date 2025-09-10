Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8294CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 03:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D908E0012; Tue,  9 Sep 2025 23:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3978E000F; Tue,  9 Sep 2025 23:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020178E0012; Tue,  9 Sep 2025 23:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E5F3C8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:13:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0501A0481
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:13:28 +0000 (UTC)
X-FDA: 83871870096.19.F9D0AF2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE97E1C0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:13:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kfwTjgji;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757474006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxEagVF5dsaHkjnhm+CTNNm22a8YhkgPBLuaKAJC9FI=;
	b=w0zjGWvNWIEIApkgYkHWlWNdzLT9PiTdKVVaX5wpUwESNW+8wbH1DPLtqd1bCtnjA6BI9Y
	feM06ah0qCK4ECeVdx9BO8BswVlsx0DdUiTtu5FIVAs+ZFCJLnHIN1pLn0qWI6mhGxTk0m
	n611Aex6cH186i/x96vskqdawMfSlFc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kfwTjgji;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757474006; a=rsa-sha256;
	cv=none;
	b=jLmktSeTUJ2oUQ+HmvBKC+HAvFpDi+1aFD6qv1Dr6dT7zAPLjyLfqxnDIVR0aEzCF0jOMT
	i22kgY+oMV7VT/IoaSqkBsFYnawPuSe5TU/VU26hWqeA2IiXzB0j4sGg6gob5iC++bNrbZ
	wg6iKPHjtWGTbeeQblfEebPTLfxHSvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757474006; x=1789010006;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=azEefx45TdCa/zkD0xRHe2VIoxx9ubvwiW/L4N+YSNk=;
  b=kfwTjgjif+MwkOypZbVjfKsLlar81FScE+3WM/C4fEyu3+GdNY+7zL4S
   A7ElNQWgJSGrb5RKmTYpTWHZ37hOz2+QpAxKCnPMS7GWDioe2REdUhyHC
   7J1W7G/o37FqkObvPkjfK2fwe+QOV/O47BsEXsVuAViED3vzIIOs06RCw
   u99RMDSHpSSuRjKEAtWCGZDq3mrhlzL73tiI0DGGyWukAWqRK0lbHHOfD
   Sx1lrQdYEvfw/9GECUMUoF/DvAZsU0t7lscUwYUC4kUqcNESFKNLGUvz2
   cRlaxWtiuKRiNh+BUPU83jeOyYFI3B7XFgA7dWs9sMAx1gldfu19E2BGt
   Q==;
X-CSE-ConnectionGUID: +j3Km57uTD6CP7o3aXgDrA==
X-CSE-MsgGUID: tqSly0raTPKHmH715B2VAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59724065"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59724065"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 20:13:24 -0700
X-CSE-ConnectionGUID: wLsWgiNTSWqdjV2TetIDAA==
X-CSE-MsgGUID: E5jKlrrtSwSIRX/feJzu6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,253,1751266800"; 
   d="scan'208";a="196935786"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 09 Sep 2025 20:13:17 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uwBGl-0005Ur-0q;
	Wed, 10 Sep 2025 03:13:15 +0000
Date: Wed, 10 Sep 2025 11:12:38 +0800
From: kernel test robot <lkp@intel.com>
To: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Chen Yu <yu.c.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>, Hao Jia <jiahao1@lixiang.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v0 1/2] mm: swap: Gather swap entries and batch async
 release core
Message-ID: <202509101043.MFfNJgKH-lkp@intel.com>
References: <20250909065349.574894-2-liulei.rjpt@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909065349.574894-2-liulei.rjpt@vivo.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EE97E1C0006
X-Stat-Signature: ecud8ekqz4h5xxdm7myxza94q9qukk6u
X-HE-Tag: 1757474005-152513
X-HE-Meta: U2FsdGVkX19jz4rSzD6tAtx/PODzBgsNs+Yx5A+Bs/VwDdfHv4tr+wx+Y5YcIBLKhjzhUkYkKiNwjppk513gR67L8tiYd85g60uQRT2ah2zVv9S9qsHFaFUiuyqjQhw4qeefkuvkOOSKKpkAjdDvypZok1Mp5d7ujch1rLQrDyXcXVeja0TIXAHSeU3v7unMzejh73hjl7Hx/yjwS28jc4hkIHnvqaHyTG8xkJBLbueJMBJXnApTBZPkCa16lilvihjs0vSirh6G4nJHGs2mto26U5qapOul50JomgDeWltIU7P/Cx+pJss4q/BOk0rY7qCuXOAikdA5Z7ocS3JVeERURZpcZOUdisSFmN0w4H2IdgKZ9RILDWZWrrWicpWftWKp4SgC8YgBsG1dePZT3HhRWG3a54kppToj+WdoeVvs+JrYxHxpw9AHcNGrYlU0aFj6/fytZZDYWchkxbjjZpnAJrbpk86Y0vhR+4aJJGv2JvdFDvSowPdShDlRvGqKsmJ4kdTpoEmxC/xisxS7mjTThZ/cR6Hp/N209o92Dj4ofkFATLVmrMGpx9UfkcN3/ARw2/oo59l6l7+GQxrU9abAMQYrPYbZKzs2jRxu46LmPZN/wSq8bIIgiw4epK34J9OWQCkYfEJkao5Ia8CqhiDfzclZMyMcS8UrHLFDjGJKvJYdebxfKQppnJpMCJueO4ZlMMVnsXp2w9799HMe3h90r+kO7zU9ZMJN/rznCCfT7IYsepcJkChvCSeneyOpNa4IUUg8U3tSsU5gL0HBWtHnmxxDlXh8gt2ouG+7porzn1nwd5oldLkLgIhz6RYz9dAUxEzRNCUywzul+waLMsQAPa/OnEsIVgJ1zHktsk2tI7aW2gdHtfMYKFw8A4Iy7Gez/NQES+lbOCBI5COEFP5EZZkaZELlkwxhf3Shvq9N2+n8sXBQ3NvTGCKVT9h8Wz4tLSXeEUleqeEYemM
 f9/LdEaq
 i8Q2fvDLInyjg/Eao84yds0qYSRN0/okiwnQ+1kw2K3J8N8tz0gxLmtlf7P8CF9gTQwamnAzLYQPuK++vn9ukxiBm08Kb2lTJ5lA9dZGbXwkFcZiGKrxJinqzRIHc42EU2IURKTHv70Hshjrvknp8CZQMgaLZ19EazhD5DeRaUH0RVgflykg8L2Soy7FWpNPjF/DTCQag6wRkaDXSwTsBwRICRkrvpmlN9VodKBXQDGrRTJ214THqkY6ssUDcOB4gHom8zXnPoGJFb+7AKQynElYcfOh0YbtwtplfadZksBAddJeoPItJqqUkQ8y+GQxvmZi0sBbIXZEstpY6DrhEM+9ezzvbT1uA7dnd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lei,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lei-Liu/mm-swap-Gather-swap-entries-and-batch-async-release-core/20250909-145620
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250909065349.574894-2-liulei.rjpt%40vivo.com
patch subject: [PATCH v0 1/2] mm: swap: Gather swap entries and batch async release core
config: sparc-randconfig-002-20250910 (https://download.01.org/0day-ci/archive/20250910/202509101043.MFfNJgKH-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250910/202509101043.MFfNJgKH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509101043.MFfNJgKH-lkp@intel.com/

All errors (new ones prefixed by >>):

   sparc64-linux-ld: kernel/exit.o: in function `do_exit':
>> exit.c:(.text+0x19f0): undefined reference to `exiting_task_count'
>> sparc64-linux-ld: exit.c:(.text+0x1a14): undefined reference to `exiting_task_count'
   sparc64-linux-ld: exit.c:(.text+0x2124): undefined reference to `exiting_task_count'
   sparc64-linux-ld: mm/memory.o: in function `unmap_page_range':
>> memory.c:(.text+0x46a4): undefined reference to `add_to_swap_gather_cache'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

