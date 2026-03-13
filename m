Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D96C6106FD9B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F57E6B0005; Fri, 13 Mar 2026 04:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 082876B0088; Fri, 13 Mar 2026 04:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC3056B0089; Fri, 13 Mar 2026 04:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCABF6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:06:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6314AC2A1D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:06:37 +0000 (UTC)
X-FDA: 84540308034.25.D482608
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf01.hostedemail.com (Postfix) with ESMTP id 96EE440005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:06:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nBt6Es6G;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773389193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkWLFC6FTEtqBFhKzchQ4NNPCrWSosGBlTPOxD6BmDQ=;
	b=2/rgDfRDkQa0qbzS8m50vF+/X1TNkomJoT3ARQrV+sNdRcFs+xR2K+N1nxLmb4XHt//WAI
	rdr1thaLF6i867l/E7nUVJQv7/IixXE1IUQmBUlYEpdX5k1NErOWO88GXQNq9m75tUksSB
	k7IvQEB53wyK7uNVloWetuRPf3x9lFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773389193; a=rsa-sha256;
	cv=none;
	b=5FBubUwV4PikUkye3MECn24i8ZvJqIN94lkLU42c9kTZpXsm41Yfu1lQGHv+cCX5Zqg72A
	bG0jcbWB4QhY11LjKGVSfRAnca7oMRMvyKgodLi+aGepRdYj0ccKvCkGauxCtCs9f6ydbH
	tjPLgZfxgvUwK/E6ClLOD8F3eYbg2Y8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nBt6Es6G;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773389194; x=1804925194;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BtMPu3iOSzFTX17F3r8GdSzBKmDkbGnfJl/P9Ya3Qbs=;
  b=nBt6Es6GRgAGv2EQD4ipE/U7+HCjV5LRvqtl1Ht+925y3BROCDW821Of
   hgWUMyus73v6qMakW2anJobifuPmtfVwP7zrHQFVGBXLtjHxuHBMtMrVk
   DU8LK1tAlbs2d1mbNaHsfPPRktQPRJ6i5QOPmSpvMbe9LKIpFZwZHfpFe
   RwpX5O/DR+TZyXkaHYMUZAr4U4UuOBghvUIH9mBbr8drkCJvK2W5ZniNl
   VuICITowy4cd0Rc7bWjM75tKSP8kUMyi5Hy6OqBhTGKdBjuYTXobhU8dB
   2n9awL6fqXZEwKYKjuwiBsjbk7Gohqpj8lu+lBOi3tyAiMAZKkwjeosta
   g==;
X-CSE-ConnectionGUID: fzsYJIP4T2ei9DFooIBwNw==
X-CSE-MsgGUID: /CEEcnU5RWGsCdogzMH1Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="74374929"
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="74374929"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 01:06:31 -0700
X-CSE-ConnectionGUID: gPjGOQENRu+9LBVWJC2E3Q==
X-CSE-MsgGUID: KKxPATFuTuOj68ORIwqO2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="217122672"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 13 Mar 2026 01:06:24 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0xXI-000000003ax-3skA;
	Fri, 13 Mar 2026 08:06:20 +0000
Date: Fri, 13 Mar 2026 16:06:05 +0800
From: kernel test robot <lkp@intel.com>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Brendan Jackman <jackmanb@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 03/25] mm/percpu: Annotate static information into
 meminspect
Message-ID: <202603131622.xpsC6cMy-lkp@intel.com>
References: <20260311-minidump-v2-v2-3-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-3-f91cedc6f99e@oss.qualcomm.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96EE440005
X-Stat-Signature: b9whqfaw81zt8o8ixq7hmigzwmaomgph
X-Rspam-User: 
X-HE-Tag: 1773389193-923698
X-HE-Meta: U2FsdGVkX1/+4ejgdkxfgmDzEdTjjYgXTvbISxDPMnbtLvI57gvsBq5px6e6IrhFNMmkZF4OUcc6r2CvVz4xQoun30rhLH4lgA7BEDiZ4A7RYv/ALLu01Q1skK9zIi7LCF/+ugmL0QXlTE7xN3p8zSNc3XSaNFQ8WajIT03HblWKVpGlacOPK0IF6wmZ5oPdxyQei38fvvmrzchTWVkzBXCUeQUNxe2Ur4JM7OsXCPGVOMsMV71XhTxX1NE+EeZDYWbdobWamQ1+OO8kM+SqPTnP8jOTrGHdEdd72Xo0Ym/3faiDphPk3tEVcCU2kk8CoS9hRlpF4tkbw+SyPlgfBx2RTC2+GPh2H8kSOM9YHzLXyul80Led1qb1uTvIv0ES0IyMC2LHvh7ePbeJoiXPxXGuKtCgnFkmf0hRTFcnl8P9sABV7Hen6K3sfh9W9n9ml2SSgQaHLf4S5Hb2KjFt/A8k1p6A5yWdLj4yXRiieWL6tDBUXqvdRGVhE9rlKGqiUygCctpreN/lrXq3sJOZCQRSvWYM9OP9qu0Om+moH03zckgvuqWLgZtKE7EcMhpDyVG7vRvvZTsIsx9KGVzWuQo3nbG06OglgQSmPM2N7uMxNqPfajr2+tPeSX3serZ7ELuK7FVddl0NSq8WvHDJyDyK+o8YYm4EOjdlCHOux2BGCyw74LPfSavVYsjqZGqU2s9eoSS3hzlv5nER3fjoQyv2BILX8zXtnzXUJN6uOSAi0AxRy9BtyxI+sL5ly4jyDUDM8LoNdMslkUo2khcDspL2Pb0WwCnev7QrTPedYPLmIhq3AfYEZ07RJbSqOqTyn4ACVYLuGFaTZhCDdulA0JEnqvAsxfqyPoZLW29hw5SSozo5DMm/dQfeMCzujOGyU6k4cBetP0/3kFSAyvY+/WcLvh3vk7RQkrUdsJ6dDC9AKBAaSHCHrJ3upabXVGYGm6YYwcneKTRg3H0XCeF
 bh4PtaJ3
 Rzs6pnPPO9RFTXku0xYwHy5c/pfFo3Atk6sSbq01GgRoG0c5o8vdC6eaUBX5jWTrSuDE6NRH0qqsi0AJpAhATez1nFrJO3fLNFdYa4O8GJXfjIonmGaMfASjdKgnq/cZGeDj1r0wxKHeeOU6y3rjSViBmRNc90y5DEb5nKk8EFJeJIKliCtTZIIE1KZTt9Uxz4BcA06up6cSX9+QJRzqduFa+k3q3aoF4JDi1dZcu85KwHhZViOuQn+6A6qR8cnilOO7gXJM2vAxltV5tloMo/bWuci5CHp/0gAYSxuCZCyIMQ3WOAWxaepzE9cZYcWIuQnTag8czIsHYvJjj7b4D6vM26l+CaxMiNykm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mukesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on 343f51842f4ed7143872f3aa116a214a5619a4b9]

url:    https://github.com/intel-lab-lkp/linux/commits/Mukesh-Ojha/kernel-Introduce-meminspect/20260311-042334
base:   343f51842f4ed7143872f3aa116a214a5619a4b9
patch link:    https://lore.kernel.org/r/20260311-minidump-v2-v2-3-f91cedc6f99e%40oss.qualcomm.com
patch subject: [PATCH v2 03/25] mm/percpu: Annotate static information into meminspect
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20260313/202603131622.xpsC6cMy-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260313/202603131622.xpsC6cMy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603131622.xpsC6cMy-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/percpu.c:90:
>> mm/percpu.c:3363:25: error: '__per_cpu_offset' undeclared here (not in a function); did you mean '__per_cpu_start'?
    3363 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
   include/linux/meminspect.h:94:33: note: in definition of macro 'MEMINSPECT_ENTRY'
      94 |                 .va = (void *)&(sym),                                           \
         |                                 ^~~
   mm/percpu.c:3363:1: note: in expansion of macro 'MEMINSPECT_SIMPLE_ENTRY'
    3363 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         | ^~~~~~~~~~~~~~~~~~~~~~~


vim +3363 mm/percpu.c

  3362	
> 3363	MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
  3364	/*
  3365	 * pcpu_nr_pages - calculate total number of populated backing pages
  3366	 *
  3367	 * This reflects the number of pages populated to back chunks.  Metadata is
  3368	 * excluded in the number exposed in meminfo as the number of backing pages
  3369	 * scales with the number of cpus and can quickly outweigh the memory used for
  3370	 * metadata.  It also keeps this calculation nice and simple.
  3371	 *
  3372	 * RETURNS:
  3373	 * Total number of populated backing pages in use by the allocator.
  3374	 */
  3375	unsigned long pcpu_nr_pages(void)
  3376	{
  3377		return data_race(READ_ONCE(pcpu_nr_populated)) * pcpu_nr_units;
  3378	}
  3379	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

