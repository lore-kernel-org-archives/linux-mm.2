Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5178CEFD17
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 22:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5A36B008A; Tue,  6 Jan 2026 17:04:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CE46B0092; Tue,  6 Jan 2026 17:04:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09C436B0093; Tue,  6 Jan 2026 17:04:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE6276B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:04:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9D60DBE072
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:04:11 +0000 (UTC)
X-FDA: 84302917902.15.D9B12F1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1101E2000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:04:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hj638dO2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767737049; a=rsa-sha256;
	cv=none;
	b=6og7F+xxq39xChvZFAyASKMw1uzqb9/zS8AglkL/GhOQrUwPZNViK0nEapEtHQuLHX/q/9
	ZcKDIQ8OzS9jR8c3sHXQI4b9VhGn7iEcWcb6WywGVUCwAPjNcFzepEbOvFknLWon0nEjFr
	jSt6hdjIIBIh/3SZkzhrr3y80WinsJ4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hj638dO2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767737049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=qfDErPEgoswHZGx9gFwhoGjSnnvS1nGIn9gWV/KEVjo=;
	b=zy3HTeJi2eSob4BMXJ07E+Gqrv1N6giMFgHnrOG/kGuYvMY+iRiho16IuRellNYjPtpEW1
	dohuKJJYnWdo3zfEmEVWC5x6omnhezDa3EzrlpPoclODvApFUeXgHXIbY7hiz/K4lqpzEv
	6xjkjLEZ+HuH2pI74U81M6+mPafG3Mc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767737049; x=1799273049;
  h=date:from:to:cc:subject:message-id;
  bh=UFTG9aL3f9/XmUP+1PBndY6CARZ4FneNWM1ttoPXAEU=;
  b=hj638dO2SKSSpmXTge/VIMSbnbtlAb7HAoO2iTwhUmk/nOeVofytEgJd
   Q8mz1+1uITI5Sx3IrkLQc5tAt5PeH4+CZALy0zWrzL36HqetGLoM49818
   fMpEO9o1PU07oX0USqAMKL0b1Ie6ZOB+h0hgxQ7MYRnxKV+TpL6LiFFEd
   JBi8lmvxKoX+TXgidQcCG8d1Xzz8ZLYpMT8PAPQRrrazNfG4TWBUaXkAc
   grbHvapfbdAig6HQsEVbhRt8GZml0qVjps4OP2HNZzAiCJBBPd9SFt/kq
   kdRoXVxol9qZhq3K6Knl6Wzhcwc65RT70SeRP6I75P/Ko9g9dgk9kgNUo
   g==;
X-CSE-ConnectionGUID: iP4+MZCeQHqPWGRbySxgaA==
X-CSE-MsgGUID: dIMY6PttSnm3EEz+ENhEQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="86692917"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="86692917"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 14:04:07 -0800
X-CSE-ConnectionGUID: f951dwc+TXSmbgrI9VCqbQ==
X-CSE-MsgGUID: W0PEiAFmQh6buIR1uY0ONg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="202522720"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 06 Jan 2026 14:04:05 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdF9l-000000003GP-3evx;
	Tue, 06 Jan 2026 22:04:01 +0000
Date: Wed, 07 Jan 2026 06:03:52 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 224/226]
 include/trace/events/vmscan.h:238:54: error: incomplete definition of type
 'struct mem_cgroup'
Message-ID: <202601070517.0yxdw4WK-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1101E2000B
X-Stat-Signature: nsha7ub8fpg1kt87h1s3g4bdw9zh7a7m
X-Rspam-User: 
X-HE-Tag: 1767737048-73468
X-HE-Meta: U2FsdGVkX1/7SGErENMk9r8LxjeHXTdbY5+v1Qfvk9FGj89y8K+5JDp29sRGK2az5HwddTwvz3HeJcm4qKNo4m+FDzMYJ/svTKEWWbbsAwChCIhGJE8XHviW/9iObNN3pl9rFIcU8HBzfmSrfGxXZvMhjegongMMcC95/1vkJHFduA0KVDtYgAsqXLzo05nuyuqQtUJxHbZ5YXTaLAtFgS5WqyWvOWfBV23/rxX776mjh70HR0cryH1sj7RSWGcUhfy7O+386qXARKM9i7vgz/zfRtiTtSFm0GWk9lVq1NRPbcws6j9pNmP1CQxIelGFht1+UBCVXDpnT+/ew9mMMOcVW1rnfzHx3R55SxXCJIwmndr+RKCz9vnSdKhFPWQWpUziC7xjMR5KO5uHAAM1awFbwK8R0IjZ64n3mU0TrQA7KdajZRrvG0Dv2r3a27/crGrl11UDJXadZPP2OfQfQwKYM/0ZjTqZSb8vrIQ8t2ltkNm0P+SvgboLgj/lF6LdQZ1lAOH+KnwTG3mW2KKFaU5bWKynMhy6yM2fI9Bia2BNtwlKCFsFqwx+eRk27jxM5N7wyMak/SN3YYdMkg4Hkymz0BjzzQ5eY0BHs+GgAVTQqzPVMhEHXo2nCxir8ztmE7zr90s0Q0Iwj+s3FEXLF36XUyBnaPI20x5IvmOay2r17xjF37VrEm0HNzi/2FtqRzO5gd8KNlICBiuvpMHsM8RNSBaCelP3IukXv8pw4P+7tKvQK+34hljfyNzPOy1SG8RsVrOUw0cPBCJ0SlrAtyXI7pEm8yjcWoVPgxRSWU3uA33gFp5tWXYJ0X15kGBwP9SeGMkqDMhaOntWAhRDpwkjGHqPNQqO+z5kgOgRZNZN2v1wvlt3a3oA8AdpdRcsc9DNQ+7Nhrl6x4d5/0c2BlAFZlzIRjxp0lyz1QJBGys/5/Bzwf7cbzjHFXBzt6AeKtbcJvX7UxqO27EXjPZ
 3AISmYno
 QJMRb5esYpTa7vM6kZzyzxQMb/a+47HVQ+juNVUvWPXP0Pcv4d0VXu7J0i3qQSix677EEXMj48Yw+uHifDVgiXNdjGvjCTVJzb8T8f+1wezAoAFx5qu/aCl3xkcQY6Yp1MkGLriPLHmaV+lb6cls9FJg8IUr3Ae5sVOyY+O/4nLKgoTnXM1wsa6cTWPj+vUCSglrEn5XwWAvrHh4usXMoJs3gvl3Dwox/h1F/VQapdFpVprjv7g0XAEuHdMWlFivMAh5LaO+EXoYPATYvyrw4MGvoMJnv43PokOnl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   d51d3f6765d29ab5cdc6a59ad832017e660d5add
commit: b84bca52c8e661aa7da507a03cc3f6831fef2edf [224/226] mm: vmscan: add cgroup IDs to vmscan tracepoints
config: arm64-randconfig-002-20260107 (https://download.01.org/0day-ci/archive/20260107/202601070517.0yxdw4WK-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260107/202601070517.0yxdw4WK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601070517.0yxdw4WK-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/vmscan.c:73:
   In file included from include/trace/events/vmscan.h:554:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:468:
>> include/trace/events/vmscan.h:238:54: error: incomplete definition of type 'struct mem_cgroup'
     238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
         |                                                           ~~~~~~~~~^
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
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   In file included from mm/vmscan.c:73:
   In file included from include/trace/events/vmscan.h:554:
   In file included from include/trace/define_trace.h:132:
   In file included from include/trace/trace_events.h:468:
   include/trace/events/vmscan.h:280:42: error: incomplete definition of type 'struct mem_cgroup'
     280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
         |                                               ~~~~~~~~~^
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
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   In file included from mm/vmscan.c:73:
   In file included from include/trace/events/vmscan.h:554:
   In file included from include/trace/define_trace.h:133:
   In file included from include/trace/perf.h:110:
>> include/trace/events/vmscan.h:238:54: error: incomplete definition of type 'struct mem_cgroup'
     238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
         |                                                           ~~~~~~~~~^
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
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   In file included from mm/vmscan.c:73:
   In file included from include/trace/events/vmscan.h:554:
   In file included from include/trace/define_trace.h:133:
   In file included from include/trace/perf.h:110:
   include/trace/events/vmscan.h:280:42: error: incomplete definition of type 'struct mem_cgroup'
     280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
         |                                               ~~~~~~~~~^
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
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   4 errors generated.


vim +238 include/trace/events/vmscan.h

   205	
   206	TRACE_EVENT(mm_shrink_slab_start,
   207		TP_PROTO(struct shrinker *shr, struct shrink_control *sc,
   208			long nr_objects_to_shrink, unsigned long cache_items,
   209			unsigned long long delta, unsigned long total_scan,
   210			int priority),
   211	
   212		TP_ARGS(shr, sc, nr_objects_to_shrink, cache_items, delta, total_scan,
   213			priority),
   214	
   215		TP_STRUCT__entry(
   216			__field(struct shrinker *, shr)
   217			__field(void *, shrink)
   218			__field(long, nr_objects_to_shrink)
   219			__field(unsigned long, gfp_flags)
   220			__field(unsigned long, cache_items)
   221			__field(unsigned long long, delta)
   222			__field(unsigned long, total_scan)
   223			__field(int, priority)
   224			__field(int, nid)
   225			__field(unsigned short, memcg_id)
   226		),
   227	
   228		TP_fast_assign(
   229			__entry->shr = shr;
   230			__entry->shrink = shr->scan_objects;
   231			__entry->nr_objects_to_shrink = nr_objects_to_shrink;
   232			__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
   233			__entry->cache_items = cache_items;
   234			__entry->delta = delta;
   235			__entry->total_scan = total_scan;
   236			__entry->priority = priority;
   237			__entry->nid = sc->nid;
 > 238			__entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
   239		),
   240	
   241		TP_printk("%pS %p: nid: %d memcg_id: %u objects to shrink %ld gfp_flags %s cache items %ld delta %lld total_scan %ld priority %d",
   242			__entry->shrink,
   243			__entry->shr,
   244			__entry->nid,
   245			__entry->memcg_id,
   246			__entry->nr_objects_to_shrink,
   247			show_gfp_flags(__entry->gfp_flags),
   248			__entry->cache_items,
   249			__entry->delta,
   250			__entry->total_scan,
   251			__entry->priority)
   252	);
   253	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

