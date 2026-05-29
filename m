Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E75A9CD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C776B008A; Fri, 29 May 2026 04:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533C56B008C; Fri, 29 May 2026 04:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4706A6B0092; Fri, 29 May 2026 04:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3707D6B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:59:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5E11A0B9A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:59:08 +0000 (UTC)
X-FDA: 84819857976.08.E5B4E5B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8E8C4C0007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:59:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMyqNsDw;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780045146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NH7IMRL43BZOIBOOdaV4MADR6q5EEB0yRLWDx7JoyP8=;
	b=8H6LxwlK8bqqZWs7f6RWiBWwwLlQqQJAA0xWhY0uxoy1+q2g+UMDlh5pKYG9Yr6gKDKMir
	0dViP5e1wJDL/u92SXA9itvqZh1YXZsWOLcHIIYVnFfRbhSMybDgFfEqPMAm7M+UzEB8zW
	CQFkceHf6HXM7C7aXTV5eSTX8pGl9TU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dMyqNsDw;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780045146; a=rsa-sha256;
	cv=none;
	b=BDGSB05tuQ7ElVao76sGnRa9YKOL53wGojfBWKt1rf51yi240Dob3OTg16hi36hmAl89xm
	BMNOClPuqdktm2o3RgzzL3L/PtnCIOzezQ6UG0P5+WGdkZ5frk4hMzQ2kL5KrTytDW32WP
	ds5oT78mcL+E4FKQWtbnEd6FMv66RmA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780045147; x=1811581147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kT17TFaVMuzhehcDGfOX5jz4/y7vwK9PowtC8aVxbbc=;
  b=dMyqNsDwFEtBCTJon41RJVEe7Sr+2cAk4YR2gi0XUSVIoDXjVOmZnHpu
   eqmVGW7JZKaLXxCp3AYRqfs2Oa8b8uuTtOMdwT2+y4oF6JP/ye0NuDiYk
   vY/W6UGTpKR/hsoE7iLlQOJhd90QLMrwOHkLz6wOBNgXBhSYt79VQnZD9
   jG8BB+SVXPSchRo1Wy9l6QQGVS2pvqMDXO0lRsmm0Je+TNmxsdhsj/t/9
   xrvL4sElpmJqXnYgwxWnP7p2SGvj2AEwNO5GP5H0K9lXKib5QQx+9k5Qj
   3FV7wSAvxoLyv44nZ8PHPwel2bk3F5D8Z0szyr4BZrJmHyQWJuX0mds3N
   A==;
X-CSE-ConnectionGUID: amhvIXD5Q+2Vw8TMTTvO7Q==
X-CSE-MsgGUID: QG8wRBUlTAOSSsWVHqn+Zg==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80795029"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="80795029"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 01:59:06 -0700
X-CSE-ConnectionGUID: fTjGFbSZTdOevsLtgfQEfA==
X-CSE-MsgGUID: T68RK7tKSXS5sDa6pImfFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="247740206"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 29 May 2026 01:59:01 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSt3R-00000000714-14pf;
	Fri, 29 May 2026 08:58:57 +0000
Date: Fri, 29 May 2026 16:58:03 +0800
From: kernel test robot <lkp@intel.com>
To: Yury Norov <ynorov@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Yury Norov <ynorov@nvidia.com>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Waiman Long <longman@redhat.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	cgroups@vger.kernel.org
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
Message-ID: <202605291609.AR5UEvmT-lkp@intel.com>
References: <20260528190337.878027-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Stat-Signature: ppqqswbocu5ct5ebtqfm3933bi7u1ues
X-Rspamd-Queue-Id: 8E8C4C0007
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780045146-519781
X-HE-Meta: U2FsdGVkX1+tOCrTIj2dAuF00wMya/42FJqtpaTXCN7XwiKD12FrZc5GIP9LwaY/wBm4SXr/agcJ6IrVFODC0oAfuZD27yF/vLlB/t/Qw+/fze8Pl2WkYhnKbMTRmkfrz9CtzmCsLi2/VX5EIblDBSRAZY9t+zqpgW2I0Jrd8xway3NaDXVipj4S+rhHI+AtcnGkxtB5+t+FFJvv9I2e3OdmKFlhd6llJKcid0ctG5e+t+717JIrXvYsXCU0CW/BhIpMOgi2D+Do1aAEH1hh39iUbIGHMVEUkMbR6qa7eyVIftBHT5AqYtn5HU5brE/1UuDZXSGAXkqJZWAiGf0VsQntFLX1EqOrNQWAAiz4qKIKUw5oyAvloCzK3HubL50XWpvdg/fiQMa5rzbZxsFTkd9ae89J3ZIeVwRBsIiKSqjzqR86Hd8U+8ogxXCpN0rPdGBXJ2bEjwrWeAHK8ZHxMd6cZWFWo13PE+2LI3AITxV3vQ4FR3PKUUtAM0ZHhI1dTEQG9JrDkU9oFsf57jsDlgJ0+F1JQRqHDDKRQ6dCyedVXb0VGrN6pXYEumNlFYOQPOUPHVa/M8X0kyq8SVifLmsWw3Zsfz3iGxJ7G/Zh+yJDm//yLMLtZOmwpNIc7daAy371mu0dwa+P7T3GcOemH/Pp9I/DWsMAVk0FU3m2ounq8TNkzB/iHNnDaswzhkvC240DY2rgYootFxHu0jGvDFLbSNwEzxCYKpdZKmPXya4R6hYxgDJf0aI0+GOQ0okb4GeI8b8U/B6UfgX6MW8cvUUGkE1zHePNK3IsASWn9n9RCRvCjOhd87Trlsmobpsyz4f0mE3tzxHqfeKVI1ROcZLLmxOqiEleLGX2Ohj0otcFYR89xbLz3XHaBi6lvOb3YXNvAaQcMI4RbQfHJaK8qG8NkF2G4dijJ6y5fLU2RzKPJvvGDrg+/fVsZkuHcySjoodi0E4EtzlTIW5xM7b
 W9AK9v+r
 qiyR8mp8lxonBzY7uWIqeRHkJ/kR0LTPIzZRFyElzndPSHjpeZVhNL4A5Sh27UOyKyvsZ37AyFoGj/wYlf/ly0nRR1ebeGEzfvIWU9KbrVmMugEA2jDAbiJnUFZvatekkkomMn1Ywn4ROknBCh1KNOLSe+mGa8I3WeaPN0gMzTK0HFMWdjpNxdjcWi/PBBdsvepr25aVqVvqg0br+eKeQgRF80Ao0crk4WJH5MgUPBhAaG4e7B1mN3pSNWEksdREz7AHPAYEiYn4KP9ODTY082ez9i247Ci58OehDrphMq92ydvbO4HN+c7wyKVnKx222uxcwS1015MnOkAyHtdP8OskWKuObGD9NNNeS1GAZssPF6RW6b93jygdtrsbGz5HPR65ggbiX3fv/Cmr+XDbuzWnD09lv0ZVedmsMZ9ke4bcmyQc9KnsS9BjGC0UstHW3kml++c5sUSMWqFke+28Rnh3eV43HNYAHNoZiBiswZ3QJUF/hiUmMoqEMng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yury,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Yury-Norov/mm-don-t-allow-empty-relative-nodemask-in-mpol_relative_nodemask/20260529-030835
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260528190337.878027-1-ynorov%40nvidia.com
patch subject: [PATCH] mm: don't allow empty relative nodemask in mpol_relative_nodemask()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260529/202605291609.AR5UEvmT-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291609.AR5UEvmT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291609.AR5UEvmT-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/mempolicy.c:377:3: warning: void function 'mpol_relative_nodemask' should not return a value [-Wreturn-mismatch]
     377 |                 return -EINVAL;
         |                 ^      ~~~~~~~
   1 warning generated.


vim +/mpol_relative_nodemask +377 mm/mempolicy.c

   369	
   370	static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
   371					   const nodemask_t *rel)
   372	{
   373		unsigned int w = nodes_weight(*rel);
   374		nodemask_t tmp;
   375	
   376		if (w == 0)
 > 377			return -EINVAL;
   378	
   379		nodes_fold(tmp, *orig, w);
   380		nodes_onto(*ret, tmp, *rel);
   381	}
   382	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

