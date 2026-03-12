Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8532106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8D146B0005; Thu, 12 Mar 2026 16:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10816B0088; Thu, 12 Mar 2026 16:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6306B0089; Thu, 12 Mar 2026 16:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA08D6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:19:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 491F71B7E00
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:19:27 +0000 (UTC)
X-FDA: 84538525974.22.19A1872
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf15.hostedemail.com (Postfix) with ESMTP id A5AC1A0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:19:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G6/NlaGZ";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773346765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LcIOVw7wvVMb4DrAoPJvycUtJI5vMnqTo+pR1xmv5I4=;
	b=4PqD/jtwPqLJ2q7jJFwWUCnvjjplfzWMrHVA/gUa69bhTcaPE05cjRE8jAvgIUlbH9y/20
	Zr2Yq686WAuYNQXCJ4jpugho84IpyNtW3sysDWmEHtfVqbOaWbGxpNSWrnCWhHm8IboZzx
	F5VHxz2OxCz6LFJy0U3Q1+GqHjODNoc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="G6/NlaGZ";
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773346765; a=rsa-sha256;
	cv=none;
	b=ZD5aQt/wG89ZR9t02piT4V2zsKlF+E8uR3FidZHNKkTWuDhSSGsL8+lZMYAV8qu8io0GO9
	+R0zjXDIn8Cyz3mlXOod0oXXzzMmLERbsXgMhLDq2H++eoi4fIaDw8vg95msLBDuxwois+
	sZv3vk7Hfocbu/xdj/5gt098oS+A+v0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773346764; x=1804882764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=q9i0aNYEP5JbHJFthJWj0hPcbi62cBIHgZdzs8kAjUM=;
  b=G6/NlaGZSqkar3c1Mym1SAH53QTDjleyCt6xeFD3G2OnFvG+45ueYEKf
   lVAUxhty0zeS7PHvah9O08pPhWwW5Jxlf6z26fQZ2RuNKnOjZN+I5z53A
   nconfWEyqC3DQlsuGWiTOJn7b71nGDTI1vUcFMgxn6alo8ZDe3Ak9Zmph
   UnaVn9D5hONRp1339yGUtqCn2yoLVVcRZSzxVO5osY6LUElcNnAcXVvVt
   ++/zkXamJgMtsEwHpiPHK5wq3TOftqi6khj1iS+glk9nopw13Y1mbrDSQ
   vJtD5PBHEQphM0chCnm779lyVQXEVetSyOHxr++KstOQjFMOEzSxD2a5u
   A==;
X-CSE-ConnectionGUID: X3i6w2YeTEOR1YBPcuJQyA==
X-CSE-MsgGUID: HCGvA2YPTmC4SIeW8dqvbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="74335547"
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="74335547"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2026 13:19:22 -0700
X-CSE-ConnectionGUID: AYg91w3STzKB947nCvtOpw==
X-CSE-MsgGUID: 631cUlyuSmizJuoqoO5P2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,116,1770624000"; 
   d="scan'208";a="220027894"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 12 Mar 2026 13:19:14 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0mUw-000000002wx-3Wq3;
	Thu, 12 Mar 2026 20:19:10 +0000
Date: Fri, 13 Mar 2026 04:18:25 +0800
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 03/25] mm/percpu: Annotate static information into
 meminspect
Message-ID: <202603130444.K3MmZnxY-lkp@intel.com>
References: <20260311-minidump-v2-v2-3-f91cedc6f99e@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-minidump-v2-v2-3-f91cedc6f99e@oss.qualcomm.com>
X-Stat-Signature: hdtfu3ies3nm9rffj8wnrdrz8ouausgs
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A5AC1A0004
X-HE-Tag: 1773346763-140837
X-HE-Meta: U2FsdGVkX19tgRpiiY2PyIWfOLLspPb+RUh20tPz27z1lxAMQf4Ygv4aL3LnVJnp6FoMpOa3k0ZuD40o1vzm2zZoXPKJjxTN3D/UAzD4f4h/WXeQFPYtw2O8lmKnFcnP2WjH5o43FoORpLI0XDkLD0mY0pfwUF/iPx7F6SY1RKh9yXKjy3VCdz5FpNgKC2n77ISOPNWsoXtRcefD3e6KBYoiRmjxWyGrloSvwSBBDYj55N36Se0KFzYGVigCxjO0nXetAbI6yLAvr8Lv/FFIhqv2jWagTdqGboLZuMD3zVsGhHar23v1IzUzWUT+/DqVDpEV9rtJxjXg31HpsncmDZYCfuU4SAwc4YUWlxB4uh7lmOXPAZsI9Fc62Es5WARkgg5dbX18ahoCR1i8SXC6fMVm/HDrebDrrPLKgAE0MjBu/qKuKLXIC4LVASZh2RaoGhgkhGdYbYfqZwhh1WCderBYT/Bli/smjP8ZnXXpcUUadFngM+Bu5Ze/Zjkbw6Zkwb/2epc3AQBSCDcagoZWyKsS13X/kQNnX8CSie3Ea7fM6dODImMwFguuSeoSEtUHVf89vc2taX8hmM/rH7Y/KNs0bJdiVIKyjNzUDA/Wab9UkMtjQLVry2Eoz1KBcAHVGB8gLkqR+QApSGUbBMNxRu5ag6DMpBuT3JBAEUTBLFXpras84Gc251dSr5Zo92pMXwU6YFNl8jjjQ6frCiezhlX2QNmLOCV2+r0/oyvuFh352tYgeS8alScohl0KnVQbnHECA1Qp6BXBh1eYV4LswL021QCBS7ApwCM5AGxprEFQLpPGLSsii807HuWzIStjNmVP3NTElVR9dyxuyLOUn+KC8ouC/YjzkSGamySgXnyHrPR8BDOgAvM35A6i5mfnyfskf/F80Il8n9FUVuorRH03ixzojM7FY1Wk3e7LS3JCTCa2a9fiVfZAeskY6tl7W3EjeqBjuy0Gzla5W4J
 lwr6bVU5
 pFlvhg56gxPDQZAsIABAVkGLWx5K0jjDS+UpUaz8YwJw9U+r0p/LnR8tvRJOaars8nouNB10GBYHDL5gFAXCYeexoBegGkRF9x+Swy7vKizHMFbOm3OYeNBHBdB2IkZKgfHV3JzMWfyEd6hNRgnLBSGzYPJS2Xh3pIVoYcdPQoHo5VvLMXYCK64iu8EhOXiayHnxQTqjIi8TFpb92mvVx8xI3q5n30jm2dAmVKAgoLLy/yhSk4dNlzEyKaZrZn+0PgHPKFrj75l1nDQiRlHxXFJNLiJxoW+STmLM8Py30O8oO29vN9SHmSFGDvNmB/cI/mXjsblpV44PDFNoP07t0V9r9uF7o9LxdRGqm
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
config: sparc64-allmodconfig (https://download.01.org/0day-ci/archive/20260313/202603130444.K3MmZnxY-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 7d47b695929cc7f85eeb0f87d0189adc04c1c629)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260313/202603130444.K3MmZnxY-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603130444.K3MmZnxY-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/percpu.c:3363:25: error: use of undeclared identifier '__per_cpu_offset'; did you mean '__per_cpu_start'?
    3363 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
         |                         __per_cpu_start
   include/linux/meminspect.h:103:40: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     103 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |                                               ^~~
   include/linux/meminspect.h:94:19: note: expanded from macro 'MEMINSPECT_ENTRY'
      94 |                 .va = (void *)&(sym),                                           \
         |                                 ^~~
   include/asm-generic/sections.h:42:13: note: '__per_cpu_start' declared here
      42 | extern char __per_cpu_start[], __per_cpu_end[];
         |             ^
>> mm/percpu.c:3363:25: error: use of undeclared identifier '__per_cpu_offset'; did you mean '__per_cpu_start'?
    3363 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         |                         ^~~~~~~~~~~~~~~~
         |                         __per_cpu_start
   include/linux/meminspect.h:103:52: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     103 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |                                                           ^~~
   include/linux/meminspect.h:95:12: note: expanded from macro 'MEMINSPECT_ENTRY'
      95 |                 .size = (sz),                                                   \
         |                          ^~
   include/asm-generic/sections.h:42:13: note: '__per_cpu_start' declared here
      42 | extern char __per_cpu_start[], __per_cpu_end[];
         |             ^
>> mm/percpu.c:3363:1: error: invalid application of 'sizeof' to an incomplete type 'char[]'
    3363 | MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
         | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/meminspect.h:103:51: note: expanded from macro 'MEMINSPECT_SIMPLE_ENTRY'
     103 |         MEMINSPECT_ENTRY(MEMINSPECT_ID_##sym, sym, sizeof(sym))
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~
   include/linux/meminspect.h:95:12: note: expanded from macro 'MEMINSPECT_ENTRY'
      95 |                 .size = (sz),                                                   \
         |                          ^~
   3 errors generated.


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

