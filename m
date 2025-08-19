Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BD6CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984978E004E; Tue, 19 Aug 2025 11:40:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9355D8E0007; Tue, 19 Aug 2025 11:40:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8243D8E004E; Tue, 19 Aug 2025 11:40:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A63B8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:40:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 384FC1A0108
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:40:07 +0000 (UTC)
X-FDA: 83793918054.14.AD38ED6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf14.hostedemail.com (Postfix) with ESMTP id DB5AC10001C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:40:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="azggA/8z";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755618005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQly7Armv0YnyO/4eUEP/eSZtTy6OaogFQx5PGWallg=;
	b=kT1jLd2e16cv9u0LxIzgyYGcv1HqsHnRr9Oofjesz4uWamZP+4CAIEBT5WqNL18dVMZmUT
	eOv9FjkpWvycR5Qgpj+PFV8gYDDfA17YapzXCq70hzeYvBZF7BdJvsJjI52AkU9/pla3mY
	1+aOT0OLkJT0WSdW6zbuHairUfU3ank=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="azggA/8z";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755618005; a=rsa-sha256;
	cv=none;
	b=IB1Vdum0pIUKBpoLUiTvcpdZcQgUgLU2ZzxKKxXvb3t7Aq5U/9zqkS1RhNdvnva5TjRf1r
	g4QmONOKI+2BGYm18mG4vTwjUHo/3EeSbpQuBczppS6Dv/StRTs6gIjKrqFENkBDkNQ8PJ
	iUq8KZkBZ9px4eia7eVKRBDd0w38WwU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755618005; x=1787154005;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/CJ0ug9oHBwhNXsynWG5neEMiGIVAml0VWRpYVhhYDI=;
  b=azggA/8zeJf//pRA+aHLORvcRKK2dmjDmxGxpZ/B9pD8ePGtFGmys0pX
   25CuerA5GATYeu2iGhL4rx3b6LMabVZs8KXJw5xKeK9Br5FEVLsmbPXvk
   1oMR7vSgkSpLGDNNhNGiPPWMgu7B0n0i7qE21DpBFhX9/1CkIBishhaDQ
   kEs663R4vlOPQkvS0X/eh2IEdc96ObMYTM33wojnSphYvC5xB7oy3ulky
   Hbrh84UvHhkG6Vl3M1hZ7HWN2Bm+zeJfb8jOUFsj7XjSRTABjRMIBQ6zM
   vO2svVQqZ+c6fAKvLcHzcKj/kphIuYQ41ni9QVXqo9zW7dPynQGkUKmBE
   w==;
X-CSE-ConnectionGUID: O9gBnzTyQDKopY2U6PPP9Q==
X-CSE-MsgGUID: IWuaDv3LRTGdKGeLLq4GhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57792185"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57792185"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:40:04 -0700
X-CSE-ConnectionGUID: 9k0W7MGIS3G85O+9jphhGw==
X-CSE-MsgGUID: WNSp3JQsQ9C45o1KDg8vxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168675856"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 19 Aug 2025 08:40:00 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoORJ-000H4V-24;
	Tue, 19 Aug 2025 15:39:57 +0000
Date: Tue, 19 Aug 2025 23:39:16 +0800
From: kernel test robot <lkp@intel.com>
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: add available_count and total count in
 trace_cma_alloc_start
Message-ID: <202508192304.gauRFPJE-lkp@intel.com>
References: <20250819032654.4345-1-gxxa03070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819032654.4345-1-gxxa03070307@gmail.com>
X-Stat-Signature: i9h38chhnr5jxgkmfqkgyu9kyz9wwk87
X-Rspam-User: 
X-Rspamd-Queue-Id: DB5AC10001C
X-Rspamd-Server: rspam01
X-HE-Tag: 1755618004-652550
X-HE-Meta: U2FsdGVkX1+teW7AbJtkNV0JVPG0gvJGfnBGkP8xKva27LTnZIS6ltB2ieAVh54fJD4eNn3TtKFmtG4IAszBsgPjmXmHDfQ2dDjyjaqVGzZvVGB5+M7L7sYSUkP9BTD4HD44WqqIOK1QH6G0wYFFCyNleWW8zfW5uocRFwpXCjYOGd0qNiwE1ktNfi7zNZWw/xBV2LWGAAbznK8CywI8Pog3lcZ3Yvb+Sp/xtjsClf9zZvhvG/ydEhYc1CNBzcbdsOs24k8mU4dzNMqzjbcbE0JVg6EPGIdoGhRehJA/wA7r/aUPxKR/iw3yPEoM+YaobsUp72HW1rWtiKXMF4vJc7Ky0jvU6AhdoCtgkcGGuO4sqe4mTIKmbggZ1zAtUrd+8kPF5DjLrbfX/96j5jA++UoFjg2HOY6dljYqLH6tKU2VoYhhZdgNCHM/9E7OgsKDh3UHRIcPciamYtOKQK38mdm6tJvm+V87NotiaaFiWQJk1DoNCAjt6RkSijnnX6YUkIIcNHIrY+qIOVSHxwpIs8C3tsgjaoiNDQciNIEl0kN4HUd6tGQLMuishfRmIK4V9noJ0Iyf3gQMpeAIHcHGJC6588nDqbon8xvgYeFaWC8yPsnZ03F1+C+E8r4O2pKU7ZiMpIiQcWgWzoTXtJcmvc4cg/1KB5+leUwx3BbCmx5ATlucxuX0nRvVqADtKBg3IqtKEGsXPxRbICwFhQ1k41mN1QrjSaZx/7DByEYgY+/5LyyBHmTuxRffu4MeQzoV9p4wYX/12WXabJYttaIMRzLY/+PtszW6hGxFwVlC9pzYYuWNpnTJbPy9p2+WTlZOtbVjFHxk6JI24RyXJ+P0jP7uNF7AvfkaBXYSWNLr7ErZZF0aDPLMPtZgMHfmjgon0GPAeCGmVdAhCXp6PK4Sr66jlDNGj3VYZiSPc5gM0GdMBj75utfejgZez2+ZI0NcRAG/RzFYg3e0wb5n0mg
 biNM8dz3
 dR9Wkgv2Fk2vVa38UIIZjkE32If6rXDD1hn1fTDO80BVArk80luDjiRQYRIqfa+MzYqzUlu2PMZF9q1MzWRqWgUgmdP5GTIw883IlwpEfyRzztRAkriPpO/lvDu8A9UdWlq0D8idL5MvOomclxVtV8Qkh/olea4uBGwGSSmU699vv1rjz9lkw5CgKXY1CqHNst70Zzl+qXx7P4tKJyLqQdV9b4dntDZ0AVnDchN0S12OU+Rs3Hn7yvukHHaMF1Ai7AGG69ZJjpsqNvlqbUuCtCiGicZraniR2oI6vN7rGSSaSnpt/D1MfizviGGYZlOEzTFJ7EhaEmQimLh/5Wg7fOENYSVKFmLRhyW28qz20JPM/hcC/+qGfG03MN1qcckY+JVupodI18pls6MQcrufFsdh86A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xiang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiang-Gao/mm-cma-add-available_count-and-total-count-in-trace_cma_alloc_start/20250819-112831
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250819032654.4345-1-gxxa03070307%40gmail.com
patch subject: [PATCH] mm/cma: add available_count and total count in trace_cma_alloc_start
config: x86_64-buildonly-randconfig-002-20250819 (https://download.01.org/0day-ci/archive/20250819/202508192304.gauRFPJE-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250819/202508192304.gauRFPJE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508192304.gauRFPJE-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/cma.c:31:
   In file included from include/trace/events/cma.h:138:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:256:
>> include/trace/events/cma.h:65:5: warning: format specifies type 'unsigned int' but the argument has type 'unsigned long' [-Wformat]
      39 | 
      40 |         TP_fast_assign(
         |         ~~~~~~~~~~~~~~~
      41 |                 __assign_str(name);
         |                 ~~~~~~~~~~~~~~~~~~~
      42 |                 __entry->count = request_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                 __entry->available_count = available_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                 __entry->total_count = total_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                 __entry->align = align;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~
      46 |         ),
         |         ~~
      47 | 
      48 |         TP_printk("name=%s count=%lu align=%u",
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                                            %lu
      49 |                   __get_str(name),
         |                   ~~~~~~~~~~~~~~~~
      50 |                   __entry->request_count,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~
      51 |                   __entry->available_count,
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~
      52 |                   __entry->total_count,
         |                   ~~~~~~~~~~~~~~~~~~~~~
      53 |                   __entry->align)
         |                   ~~~~~~~~~~~~~~~
      54 | );
         | ~
   include/trace/stages/stage3_trace_output.h:6:17: note: expanded from macro '__entry'
       6 | #define __entry field
         |                 ^
   include/trace/stages/stage3_trace_output.h:9:43: note: expanded from macro 'TP_printk'
       9 | #define TP_printk(fmt, args...) fmt "\n", args
         |                                 ~~~       ^
   include/trace/trace_events.h:45:16: note: expanded from macro 'TRACE_EVENT'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      41 |                              PARAMS(proto),                    \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      42 |                              PARAMS(args),                     \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                              PARAMS(tstruct),                  \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                              PARAMS(assign),                   \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                              PARAMS(print));                   \
         |                              ~~~~~~~^~~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^~~~
   include/trace/trace_events.h:219:27: note: expanded from macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   In file included from mm/cma.c:31:
   In file included from include/trace/events/cma.h:138:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:256:
>> include/trace/events/cma.h:66:5: warning: data argument not used by format string [-Wformat-extra-args]
      39 | 
      40 |         TP_fast_assign(
         |         ~~~~~~~~~~~~~~~
      41 |                 __assign_str(name);
         |                 ~~~~~~~~~~~~~~~~~~~
      42 |                 __entry->count = request_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                 __entry->available_count = available_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                 __entry->total_count = total_count;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                 __entry->align = align;
         |                 ~~~~~~~~~~~~~~~~~~~~~~~
      46 |         ),
         |         ~~
      47 | 
      48 |         TP_printk("name=%s count=%lu align=%u",
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      49 |                   __get_str(name),
         |                   ~~~~~~~~~~~~~~~~
      50 |                   __entry->request_count,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~
      51 |                   __entry->available_count,
         |                   ~~~~~~~~~~~~~~~~~~~~~~~~~
      52 |                   __entry->total_count,
         |                   ^~~~~~~~~~~~~~~~~~~~~
      53 |                   __entry->align)
         |                   ~~~~~~~~~~~~~~~
      54 | );
         | ~
   include/trace/stages/stage3_trace_output.h:6:17: note: expanded from macro '__entry'
       6 | #define __entry field
         |                 ^
   include/trace/stages/stage3_trace_output.h:9:43: note: expanded from macro 'TP_printk'
       9 | #define TP_printk(fmt, args...) fmt "\n", args
         |                                           ^
   include/trace/trace_events.h:45:16: note: expanded from macro 'TRACE_EVENT'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      41 |                              PARAMS(proto),                    \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      42 |                              PARAMS(args),                     \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      43 |                              PARAMS(tstruct),                  \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      44 |                              PARAMS(assign),                   \
         |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      45 |                              PARAMS(print));                   \
         |                              ~~~~~~~^~~~~~~
   include/linux/tracepoint.h:139:25: note: expanded from macro 'PARAMS'
     139 | #define PARAMS(args...) args
         |                         ^
   include/trace/trace_events.h:219:27: note: expanded from macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   In file included from mm/cma.c:31:
   In file included from include/trace/events/cma.h:138:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:468:
   include/trace/events/cma.h:56:12: error: no member named 'count' in 'struct trace_event_raw_cma_alloc_start'
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
   include/trace/events/cma.h:56:12: error: no member named 'count' in 'struct trace_event_raw_cma_alloc_start'
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


vim +65 include/trace/events/cma.h

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
    56			__entry->count = request_count;
    57			__entry->available_count = available_count;
    58			__entry->total_count = total_count;
    59			__entry->align = align;
    60		),
    61	
    62		TP_printk("name=%s count=%lu align=%u",
    63			  __get_str(name),
    64			  __entry->request_count,
  > 65			  __entry->available_count,
  > 66			  __entry->total_count,
    67			  __entry->align)
    68	);
    69	
    70	TRACE_EVENT(cma_alloc_finish,
    71	
    72		TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
    73			 unsigned long count, unsigned int align, int errorno),
    74	
    75		TP_ARGS(name, pfn, page, count, align, errorno),
    76	
    77		TP_STRUCT__entry(
    78			__string(name, name)
    79			__field(unsigned long, pfn)
    80			__field(const struct page *, page)
    81			__field(unsigned long, count)
    82			__field(unsigned int, align)
    83			__field(int, errorno)
    84		),
    85	
    86		TP_fast_assign(
    87			__assign_str(name);
    88			__entry->pfn = pfn;
    89			__entry->page = page;
    90			__entry->count = count;
    91			__entry->align = align;
    92			__entry->errorno = errorno;
    93		),
    94	
    95		TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u errorno=%d",
    96			  __get_str(name),
    97			  __entry->pfn,
    98			  __entry->page,
    99			  __entry->count,
   100			  __entry->align,
   101			  __entry->errorno)
   102	);
   103	
   104	TRACE_EVENT(cma_alloc_busy_retry,
   105	
   106		TP_PROTO(const char *name, unsigned long pfn, const struct page *page,
   107			 unsigned long count, unsigned int align),
   108	
   109		TP_ARGS(name, pfn, page, count, align),
   110	
   111		TP_STRUCT__entry(
   112			__string(name, name)
   113			__field(unsigned long, pfn)
   114			__field(const struct page *, page)
   115			__field(unsigned long, count)
   116			__field(unsigned int, align)
   117		),
   118	
   119		TP_fast_assign(
   120			__assign_str(name);
   121			__entry->pfn = pfn;
   122			__entry->page = page;
   123			__entry->count = count;
   124			__entry->align = align;
   125		),
   126	
   127		TP_printk("name=%s pfn=0x%lx page=%p count=%lu align=%u",
   128			  __get_str(name),
   129			  __entry->pfn,
   130			  __entry->page,
   131			  __entry->count,
   132			  __entry->align)
   133	);
   134	
   135	#endif /* _TRACE_CMA_H */
   136	
   137	/* This part must be outside protection */
 > 138	#include <trace/define_trace.h>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

