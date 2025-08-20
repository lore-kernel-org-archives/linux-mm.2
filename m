Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02227CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9729C8E003B; Wed, 20 Aug 2025 18:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923B08E0031; Wed, 20 Aug 2025 18:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8397D8E003B; Wed, 20 Aug 2025 18:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 716618E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:53:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E50214017B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:53:12 +0000 (UTC)
X-FDA: 83798638224.23.1E5CAC7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5EAA240009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:53:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a1alIB4u;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qo2QWyMh3oShR0B9sbXL7LgAv6ZIpYD1+kX131e5C+k=;
	b=VRTMHuHWArZpqPUTwoUniGY/e0/SDTB7gtNnGmFFZSFAq/6VgQHCQLOVDp+/iIJaoR+yyg
	QIBrnIl0BFjuHjkuN69iTOWCL+3sceqV9Ay3NKegWIsMwmFjXlaf8vaKhSDIoLwfcoEl+H
	m1TKyIp2pV5UUqZk5rI/PdUP6Da3MZw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a1alIB4u;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730390; a=rsa-sha256;
	cv=none;
	b=uUeyLHBq+JmZNJB9JScp85VjQCJbV/sFJ9ssYo4NjQD335LSq1um88c4tKWFO6zvPiuQp0
	sLhqE6Dk5d8Hw1XIOS+NnXSH/ObQ2Q5KhXzFVljo+rEQMHpW2KSMjPWkY1pNrnd0ceNDP3
	b8GH2TXtVolh446S9UGHdvScD98qqoE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755730389; x=1787266389;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xDRP95yA4J3OJjOVL49YPRpnANZi0tgCgOIZTfJwTVw=;
  b=a1alIB4ufMU9k1/AkTSeJJKFuHyX2b/w3YG2JPgzyrc/jbLvi+6P0a3X
   wifpUswKVG3QyRahGeb1qfJfJT67CaX3kBgbY7cxbiOx4i9ZMy54e0qZn
   NORdJYAQdBJj3GDbhXdbnOivVQTslvXBCkBNcp0isBffu/wsxaPh4XVgo
   49mix9yXzT3GFU3gHoqx6fQdGcUyO44AuC2LjgdDCFiH6HHso7XYr7sXW
   W7c+aBxMsUcZPAL1Qw4hb9MPHAiT4qC5lSJ8AjRljZttLJf1NpcTWFXqM
   JytxLjFaQOZnfbFu1eO4gGSefMf/dfb0On6it5GfVhLOWrZF6w9QYVTzc
   Q==;
X-CSE-ConnectionGUID: /28OeSdjSC6yKXWpaFS47w==
X-CSE-MsgGUID: 9vFEG9xqSxKsfF0vnbxX8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="58079343"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="58079343"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 15:53:05 -0700
X-CSE-ConnectionGUID: xft/3dHuSQ2BVAfciI/AKw==
X-CSE-MsgGUID: mT6JVZh0TluWdr+Zal7KOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172674938"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 20 Aug 2025 15:53:02 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uorfv-000Jip-1I;
	Wed, 20 Aug 2025 22:52:59 +0000
Date: Thu, 21 Aug 2025 06:52:26 +0800
From: kernel test robot <lkp@intel.com>
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH v2 1/1] mm/cma: add 'available count' and 'total count'
 to trace_cma_alloc_start
Message-ID: <202508210642.kUloVYxD-lkp@intel.com>
References: <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17@xiaomi.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5EAA240009
X-Stat-Signature: 6d65urxno7bhjneyw9zwnjkuugurs6jt
X-Rspam-User: 
X-HE-Tag: 1755730389-916519
X-HE-Meta: U2FsdGVkX1+llCou5T9U0XUcW+xXSCE+773IHnuLprEGCoqCg5cdHfsVpZNdtKVrEDaX4vIq9A25cXEIyIn7tAlZRYFq7XlSlToN9EP0mlEFKVX0Gi+ZOvmt/KSpnWfMm/NAjzGSui9c9uEceqr6Uz1l7K2DI/VRxH8vyYpqktPDBT6YKz6Zf4FRoxCaABXLSmEtxo3WqztA70Bw4lliXluvjcaLWP+CevNhn6TZUhfBRb3z2M7NY4V2nv6tvBIKtGHurkAYNhiezJQ1OH7DPgir8zjuXtXNBz2A+vvMYHyICXwiuIeZ4lo5dXYPokALjfrjZQYf1DXb46QILgpK/xLdUYYz7RBkaYU7fGJiOp5tltK0AJZXdq+QnfVc1K1jOSCAlUZ2NO8Ik6IyaxwbN7pcL3tzlHEPjcoxCZdOMSkurwcHfzae4vDpiC6SVYSsKNixB2xdvKqOmaowlUtgVNnLsBWvIXG5VHnf+7jEIQVV/ekOR/n8Ea15Tw4eEmbFEHAICbHHNf5fcbq3mh4Qoxweb0pOSw4TDbkXU1NMKsp4Z6LBF1OzAFkTYx8kVn4u7YfgUlF3/1gmQ3keMBQvKUFIRu06nzH3oKpNaZqHA4Mic6Sq8h7jEMeQz8LIvVhnJUU3RcetVdppDt9a2EYVwaBQXRXJYrVTx+fepZFuhNQyFSrgl29aXK4nM4AG4tsoGB9ZVmXNveISamJvokjz9bB/svRvgWtuZVuCOuNuxp8dxJmzfIilRGmf5HvTEjcBi2rdx2TBcuegE6DmfayI9uJROcSf0Awi3qeN7CMN2yqDcYTjCVBJtC4OvEgJaoeTVgBosMRVDQfTkGFkF+KMMTONKzV9nwDvShHsAaxCFrmZEe8iLnK9QuISI29JLBH/ObLjnaZxviyqyBk9+588U4aZzAN8odI00fPZoUC6dtHjaD+LWtS1sLxIz3CSbzH6GIYwGkeH5NBhE9RLXW7
 X+1ddKpU
 adiTikyE9IYm51j3HPIlE6+dhQhA3+jIjTWxdqlxZEITl4+DDbfFeF9l9NaOD9NE+GBjy4tfeddki1GDLt/QnX54F6uzbQz9ew5dezD2mlViciSNAJKGVglc91OCckK53mi2BWKHXJV7DfiLHz6gmB0Y51OyQVGso/nCMzebMj9Qwjb6nt6Nzc5yxFH4Uogi6a1juv9jdA78JECgzagRDIk3sa7oTlkbcUpoemrEftPKQ6Ao563VYoj2AWqEWCh0ZLTA89Em7Krnl5qb8MdKU2n8uXyUQBY7RC/Ew+rsXrU34pRPAsn0rR66pO3IdaaZXhhP7iqpdPVNBh6b6Oyd+nTmCix14EVrLWo7OpEiObxHQZzyuNBH++GKHjWQRupvhlvayJSUkrsH1V3GG/oQ6PO+VFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xiang,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiang-Gao/mm-cma-add-available-count-and-total-count-to-trace_cma_alloc_start/20250820-105438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/d30f91137e3a296152463ea65474e1ca56f4eda3.1755654367.git.gaoxiang17%40xiaomi.com
patch subject: [PATCH v2 1/1] mm/cma: add 'available count' and 'total count' to trace_cma_alloc_start
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250821/202508210642.kUloVYxD-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508210642.kUloVYxD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508210642.kUloVYxD-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/cma.c:31:
   In file included from include/trace/events/cma.h:138:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:468:
>> include/trace/events/cma.h:56:12: error: no member named 'count' in 'struct trace_event_raw_cma_alloc_start'
      56 |                 __entry->count = request_count;
         |                 ~~~~~~~  ^
   include/trace/stages/stage6_event_callback.h:133:33: note: expanded from macro 'TP_fast_assign'
     133 | #define TP_fast_assign(args...) args
         |                                 ^~~~
   include/trace/trace_events.h:44:16: note: expanded from macro 'TRACE_EVENT'
      44 |                              PARAMS(assign),                   \
         |                                     ^~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/trace_events.h:435:16: note: expanded from macro 'DECLARE_EVENT_CLASS'
     435 |                       PARAMS(assign), PARAMS(print))                    \
         |                              ^~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/trace_events.h:427:4: note: expanded from macro '\
   __DECLARE_EVENT_CLASS'
     427 |         { assign; }                                                     \
         |           ^~~~~~
   In file included from mm/cma.c:31:
   In file included from include/trace/events/cma.h:138:
   In file included from include/trace/define_trace.h:133:
   In file included from include/trace/perf.h:110:
>> include/trace/events/cma.h:56:12: error: no member named 'count' in 'struct trace_event_raw_cma_alloc_start'
      56 |                 __entry->count = request_count;
         |                 ~~~~~~~  ^
   include/trace/stages/stage6_event_callback.h:133:33: note: expanded from macro 'TP_fast_assign'
     133 | #define TP_fast_assign(args...) args
         |                                 ^~~~
   include/trace/trace_events.h:44:16: note: expanded from macro 'TRACE_EVENT'
      44 |                              PARAMS(assign),                   \
         |                                     ^~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/perf.h:67:16: note: expanded from macro 'DECLARE_EVENT_CLASS'
      67 |                       PARAMS(assign), PARAMS(print))                    \
         |                              ^~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/perf.h:51:4: note: expanded from macro '\
   __DECLARE_EVENT_CLASS'
      51 |         { assign; }                                                     \
         |           ^~~~~~
   2 errors generated.


vim +56 include/trace/events/cma.h

    40	
    41		TP_PROTO(const char *name, unsigned long request_count, unsigned long available_count,
    42			unsigned long total_count, unsigned int align),
    43	
    44		TP_ARGS(name, request_count, available_count, total_count, align),
    45	
    46		TP_STRUCT__entry(
    47			__string(name, name)
    48			__field(unsigned long, request_count)
    49			__field(unsigned long, available_count)
    50			__field(unsigned long, total_count)
    51			__field(unsigned int, align)
    52		),
    53	
    54		TP_fast_assign(
    55			__assign_str(name);
  > 56			__entry->count = request_count;
    57			__entry->available_count = available_count;
    58			__entry->total_count = total_count;
    59			__entry->align = align;
    60		),
    61	
    62		TP_printk("name=%s count=%lu request_count=%lu total_count=%lu align=%u",
    63			  __get_str(name),
    64			  __entry->request_count,
    65			  __entry->available_count,
    66			  __entry->total_count,
    67			  __entry->align)
    68	);
    69	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

