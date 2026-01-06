Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18032CEFD15
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B8B6B0088; Tue,  6 Jan 2026 16:42:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633046B008A; Tue,  6 Jan 2026 16:42:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5695D6B009F; Tue,  6 Jan 2026 16:42:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 403FE6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:42:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C526E140C1A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:42:08 +0000 (UTC)
X-FDA: 84302862336.24.E70E64A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf17.hostedemail.com (Postfix) with ESMTP id 17CC24000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:42:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AL2i237B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767735726; a=rsa-sha256;
	cv=none;
	b=g+8tSsExbolSizyvvkhyyniUlJEIRb/Gpn+iSkzpjDhfOVZtQ6wcic9yHQmk/9RhofXdQR
	QCMHY0g8pJbVtWtb4E0cXhm2elNCd7suwttx/oxs38R2XlMrbX+96c22/gxpBvJ6CsU6K4
	9sHVdhZRjDLOzrdyyNCrlB2zRP3eji0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AL2i237B;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767735726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=3Xh3WmGuuY/3JFcCfixCfkqD2cad6Nl55lr9TX56RbY=;
	b=uWF+7wDg4CxvmfV2E7h6wuq4/mFSeUSFdoGwUNynqUf0foSh+fpGRTwK1ljgh8I48dqJCl
	ABL5ECMtdd+IpX5WE1QAFypO09nlU0qZAVZtvUFKRQvRbklZ7tFqGBdrsmX20h3qzBJo7G
	/O07pA3c7j0Vdk5EIViNfH/rYFcV/Mo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767735726; x=1799271726;
  h=date:from:to:cc:subject:message-id;
  bh=pQbpZYihmAFaoBBeTjRW4B1U3HNmrdEMH8y/mTnU6F4=;
  b=AL2i237Bub9i+1jiEg1xfvvk2V8eXLv7CrAGDWQ+tA38TJeHFFr9LhJW
   KeiPOmBcJ15Mcc4fwJnD7X2nqOKJeJgdaq3NcTXbD8d7NiCPwR+jgr3kK
   oLEhyVun6QfZ79ttR9zk1N+IybMsjme5I5wuP0dzv8b+UceMqscI3N2H8
   FWl12mYtx6RXfXjQJ6dr7Aq3HLkDMVIJg1fIna2PwMFYqAUJfjRL8VmOD
   +wnehC01k08fagXW62IYqJ5A3fJcEWXcZX6yOojMJMjIaowdU5YtBf1tx
   RKH4ca1lHc6gqQkZiS4DFlA4/pY5dhiVsUgnvJv1vIGmt63XKvZTZl4jg
   Q==;
X-CSE-ConnectionGUID: Sl7ZVVLjTxya8Ic5Q54DeA==
X-CSE-MsgGUID: cGFSsyAbQDS9JHSraNDiaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="79824892"
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="79824892"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 13:42:04 -0800
X-CSE-ConnectionGUID: WuPdg22rR/KkV1ED52XSJg==
X-CSE-MsgGUID: CcXda9FxTyC2B+M2jtz0hA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,206,1763452800"; 
   d="scan'208";a="203011927"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 06 Jan 2026 13:42:03 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vdEoS-000000003FZ-2HJn;
	Tue, 06 Jan 2026 21:42:00 +0000
Date: Wed, 07 Jan 2026 05:41:55 +0800
From: kernel test robot <lkp@intel.com>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 224/226]
 include/trace/events/vmscan.h:238:68: error: invalid use of undefined type
 'struct mem_cgroup'
Message-ID: <202601070540.h0lMglk1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17CC24000D
X-Stat-Signature: dxdh5knn7ycjzqhx4ohrerxuoipnd81p
X-HE-Tag: 1767735725-195177
X-HE-Meta: U2FsdGVkX1/1TvhJlUOEPAPRgyWPw5HcwQOY2dWOKfRDKTaT2mSakHzOho44HDqb/yxL9ox68sKbeM4jVgfBgxeitb2xFEKj5fEdmJZhurUfGTr5ILgfyx4TSmGdz52o1437PuuGxRlg8+6wLLK/8Famz54MrfHBfSNYMJ/D9WkEqENhp997f20J7MGmhGiGMhscFET8IyHZLzaldlWWFAnro5fc/L9GljKGJMMqteVkQinMQZxkMvmSMQb8ROxxO3/wfgheZsr0hBO9sipklYb1mjK5u0gAjMRQb+gdaOFqkQ/mVJBBDsykcT60nULTHT/hOTe8GylhQGViUCQLpi8CyG0zKY04nfPsDsaMiepcaMVVkc7dnbW/ydHJtU0Sh6izjEPyEE6UEjSPqvyq1zf8TGZhxn98R3ExTIuE9l1vzr7MYf3LpNnL6V1n7Lf9unqc55LMjLIzVxoBNngep7C2rSd3SNHFIiyPOHFpe3XOEtvw97IDPyDdj9R6pKioCll4Y8b4oU00zD/4bFqDk9d0Qsp+iUAFxLEGHc0pgp/+Re5FoXSsPe3hkoY7yiAzocGHNYwNY7dUUkblxEmRWxCiVdVvkSJcW8pwwCoidseMcyLq7K6RNQYembXfM8eqIK0deRDD2kDFewaqOqhyUdCBqNUG4Feti/Fhg1QGNNeqcuTVTl+bLfsjW919xReinV8cmvLs/YaUBMlVejywqWG6pg+ccbst0k2cRV4K797mCe6JkqnbJoWdLKpClvIqPuJQYM0lAGMFlxrfsWF6l/u94t3N9UCRF4PPkd9+pJLC/tAgHRAgTK0CA4yG0pKkMLPj2Qvhx6Jg+6xKvICroRmZ8oz1+L5lz15SKH3ynt4LlO05ERMwRjS45BB1sVIb2nwMUvoEru3us2NAem8glyHLEeTtlPbG8mNbKclwy7b0MZPHsN2JfuymAaFHr01CUmTmmc1KSh6aZ6x//yS
 /lqXXTEI
 U/F1l2x/w9rwg6E16/lAaT6GBOlOsstyJl5GPKCgmNjePDNlOCgdpsdPWhu6iLGFhvp/unHI/IwDl9KhsmbZ+48wLLh5icdkYL9XoCncj+W6Dfaw+pLM3YVvlsIvW67En4/rwpjEVnjJ6JAlkw8ij5qQnan1qYTxm8vY2AnRQ7ZsfoOrI2d9WyL7KC4IStQDWVFRytf5K6soliqRR0XQMcGvrCVFr52T4zJhGOLPSqDlbSlAhLfvIRdgCwE2gure2R8gaQRCHBW4f8eQVVAV6W+RSmfMskaaXzX7K
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
config: i386-randconfig-011-20260107 (https://download.01.org/0day-ci/archive/20260107/202601070540.h0lMglk1-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260107/202601070540.h0lMglk1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601070540.h0lMglk1-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:554,
                    from mm/vmscan.c:73:
   include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_shrink_slab_start':
>> include/trace/events/vmscan.h:238:68: error: invalid use of undefined type 'struct mem_cgroup'
     238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
         |                                                                    ^~
   include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
     427 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
     435 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/vmscan.h:206:1: note: in expansion of macro 'TRACE_EVENT'
     206 | TRACE_EVENT(mm_shrink_slab_start,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:228:9: note: in expansion of macro 'TP_fast_assign'
     228 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_shrink_slab_end':
   include/trace/events/vmscan.h:280:56: error: invalid use of undefined type 'struct mem_cgroup'
     280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
         |                                                        ^~
   include/trace/trace_events.h:427:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
     427 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/trace_events.h:435:23: note: in expansion of macro 'PARAMS'
     435 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/vmscan.h:254:1: note: in expansion of macro 'TRACE_EVENT'
     254 | TRACE_EVENT(mm_shrink_slab_end,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:272:9: note: in expansion of macro 'TP_fast_assign'
     272 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   In file included from include/trace/define_trace.h:133:
   include/trace/events/vmscan.h: In function 'do_perf_trace_mm_shrink_slab_start':
>> include/trace/events/vmscan.h:238:68: error: invalid use of undefined type 'struct mem_cgroup'
     238 |                 __entry->memcg_id = sc->memcg ? cgroup_id(sc->memcg->css.cgroup) : 0;
         |                                                                    ^~
   include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
      51 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
      67 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/vmscan.h:206:1: note: in expansion of macro 'TRACE_EVENT'
     206 | TRACE_EVENT(mm_shrink_slab_start,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:228:9: note: in expansion of macro 'TP_fast_assign'
     228 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   include/trace/events/vmscan.h: In function 'do_perf_trace_mm_shrink_slab_end':
   include/trace/events/vmscan.h:280:56: error: invalid use of undefined type 'struct mem_cgroup'
     280 |                 __entry->memcg_id = cgroup_id(sc->memcg->css.cgroup);
         |                                                        ^~
   include/trace/perf.h:51:11: note: in definition of macro '__DECLARE_EVENT_CLASS'
      51 |         { assign; }                                                     \
         |           ^~~~~~
   include/trace/perf.h:67:23: note: in expansion of macro 'PARAMS'
      67 |                       PARAMS(assign), PARAMS(print))                    \
         |                       ^~~~~~
   include/trace/trace_events.h:40:9: note: in expansion of macro 'DECLARE_EVENT_CLASS'
      40 |         DECLARE_EVENT_CLASS(name,                              \
         |         ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:30: note: in expansion of macro 'PARAMS'
      44 |                              PARAMS(assign),                   \
         |                              ^~~~~~
   include/trace/events/vmscan.h:254:1: note: in expansion of macro 'TRACE_EVENT'
     254 | TRACE_EVENT(mm_shrink_slab_end,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:272:9: note: in expansion of macro 'TP_fast_assign'
     272 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~


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

