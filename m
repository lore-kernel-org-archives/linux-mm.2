Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFC1CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 03:05:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021DF6B008A; Tue, 12 May 2026 23:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AF16B008C; Tue, 12 May 2026 23:05:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E514D6B0092; Tue, 12 May 2026 23:05:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3AD86B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 23:05:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 707441C0F7C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:05:43 +0000 (UTC)
X-FDA: 84760906566.19.4CEF71F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD769C0002
	for <linux-mm@kvack.org>; Wed, 13 May 2026 03:05:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mlJ4w1Dz;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778641541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORa/l3dBGL8BomGwk2cHAkwFaajn8OsAlfNaBed1Rpg=;
	b=SBdne448kGLGsb99s+gzuZQf5tg9uJTYHl41oE6tFVz1kAxHRlPJ8wtCH0Wtr7dMp1lMQm
	r8YAHHIELSTJ43KxUMBFPLHfrfpHp2gNB3FSRAwrqSR2V4mQDc6dKIuyc38mnDapKM5ikr
	7sMMLXLq11id5bXGptqURxktxSGH+Kg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mlJ4w1Dz;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778641541; a=rsa-sha256;
	cv=none;
	b=NAMCvbBhSiHZMCHLBYve+on1KZWWKjmrxBXeCKeqzPf0nKUBt5A42pVTyv8GUgxEnLkAGO
	JA+4TL/fBCNMf2/KUd5/kQXxd/ZcUy2ydp/OG7NMwVk/R0dqVtADKLaQ0xLQxCTqW0nj/z
	HTG8MPb8w0D0WhteZ0kF+IR2EgTf+28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778641541; x=1810177541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pj6DprnSLzLdRwxG/z4tUqiwG0zZLLNzGp7blWdCEo4=;
  b=mlJ4w1DzNj3KzPY5FHP/49oUALvzF2ujDamS6bKgHRS8nruoYess9q3j
   R4cRq7B37EAvwLlIEfNI1cHG/pWShmvFjhJ/Q25AhTOa6AgMJxKXdXCwd
   KycHVvdleQeWqk+t2FJBjU1Ggqsvhs8qgBSeEVpWzfSxvRJutO+aTVUpV
   mO+28ptHucyVjHZX/+AFZTrd1IBFHmJ2iQNbx1dAW7mi8ZEM8C1mayCRb
   HowtuLsNKW5P65gZT52EGKobSz/wUXIFL2PDtgz3Gu1Rd9XUPu4ZpHTMk
   QjdqxBQLIfvqca7HaKKgwN6xfcWrmfj4Fbp41ZgFa1y4+8wIZcaW+Cu/K
   w==;
X-CSE-ConnectionGUID: JYe7wQMsTcycVEX7eOHZxQ==
X-CSE-MsgGUID: 963zvt2FS/6vddfS8K4yrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="97128459"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="97128459"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 20:05:39 -0700
X-CSE-ConnectionGUID: VID22wTxTu6w5XRAEflmvA==
X-CSE-MsgGUID: 4Dk1B6vrSoOzvncDQIDeIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="233676690"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 12 May 2026 20:05:36 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMzuf-000000003HH-2ZcK;
	Wed, 13 May 2026 03:05:33 +0000
Date: Wed, 13 May 2026 11:04:59 +0800
From: kernel test robot <lkp@intel.com>
To: "qiwu.chen" <qiwuchen55@gmail.com>, rostedt@goodmis.org,
	mhiramat@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, willy@infradead.org
Cc: oe-kbuild-all@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, "qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <202605131057.E7FZbuAc-lkp@intel.com>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Stat-Signature: 8f1sp6ktarkqtgjfmkxykn8t13afsoah
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD769C0002
X-Rspam-User: 
X-HE-Tag: 1778641540-637769
X-HE-Meta: U2FsdGVkX18BXqolRg8DOG5dOKuPxHXCOQRmx+jfQmH4PotovxDQl8YL3QeC0vNG4GWuMZU1avvr8F9O36+jePGc9E6HnmEdAxD5k0ayBRtbaaj2GZrgfqsXP1mcXv1DRFstSJ6XrbR3zE+1Q67LKwUMQ+SLcPNAKM19MZwtQZoO/l4A91k0fK8Oel7z8lpmMUZmqIQ6yTGeJROnBi/BF25H41VdxwC6yzmWUg5z6+4JNSeS1pxq9Q6RExUPdbFAf/duJqsPXQXF9T0yq5NsimwWI2aWyAgXqReOU05DPwwWFH6aBILWZ7RApdqBex7xmR+Onab7ACOlG1tw3atzgNcsE7zOm+3Laz1ovUxzrdSaD+XqNjlhG7XkYSy3e8ldutzhUKHjjobyYlbsGRvXyzJ6D/xaEzkcbGZGaCagRjcNw4QzfG5lmVcY9oalC9Ppn4OaeBTlES8b7UVRhNy+moJS6ngoZc+8BjjzUVZHVfTHWKNthJFG1UBp7mtT4QQ1xozfk5lPMuKDNbfs1suvXcY4A/sZarjz2Znt//VVOqpL5lLxi7LP5829WM5wBhdFh202bAR8FULHJe0ygXfMiYTvdMLNUvPN9QeNLwTfvnrW/o9M4JuHi27fzWdASLfnLp5Y7rJ0DSGTLFiRYiBIhXoEbjpLUC85Zsk9XCRSRDqdrq9aC0JdjoImwOqlphRGWe6+1KKf+SDtltRLL7sjaFzPVRJ1fXUcT+eDI6EsX3TLYNwGD06OSRua9E5TJYP/zu7K1/ixIyz2ulbDxM/G10SKWCINk7miV7g+LIVIgg3DrDUTIZfXvQK3hwhHztnWi1vR5VzDQiZj20z4n6zWeaTvRE34NWPJgFbYOk0kVKIk8EAKQ1ebTc/z5AsE0Sg+POJmihrURu1uKPWBInD9bSSUdQ1Fbo7lNL0cS0Ac17IHOv0pq28VD3EWUd94KId0ZQHSv1gxvnvwCnU1/LU
 STDpukk4
 vpr739bbbA0RsY0kUeoeWzx9gmPEDeXrCea4ClVSQwMfsZ5D5BejLoqO9PUj0GCGTtXpdd/3BWaMh61tU1bGce3n1iBLdzmZWpJR8CL9z8sGbQj4dapibehmo/zERENbjJcmTsFjDLyGdbdZPdYpTiOtMsq2GAd1gk4bZUqcK0B9nY2FIJST9qaW8imTGl2/6ZwHBBl4rbErulbOI3cpT2Ivvc1NDkfBQB5GSWX7GwQTRaJoDkjt17MYvQNnFgzDfBl8dak7k1TuN2sfQ6JJiT1rUy5cGMelyMGHhxyaXV0Mgxj2CaUqnw3Vq6Y7mq/qADZnmxnNuUNIhuzWN0i7vcKt9LVAIbVEthS2+KHAQLWncomChf7nOR8nuO2FP2+df/ngh5U2gC1JMchUz/rDFzQV7GfPnQ+NRGI+TmefEhviOEFiAc8fJtq5ZO7IIWJbjUuBQvEl5PR4iA14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi qiwu.chen,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.1-rc3]
[cannot apply to akpm-mm/mm-everything trace/for-next next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/qiwu-chen/mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints/20260513-040720
base:   linus/master
patch link:    https://lore.kernel.org/r/20260506083652.100160-1-qiwu.chen%40transsion.com
patch subject: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio tracepoints
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260513/202605131057.E7FZbuAc-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131057.E7FZbuAc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605131057.E7FZbuAc-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:602,
                    from mm/vmscan.c:72:
   include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_write_folio':
   include/trace/events/vmscan.h:358:19: warning: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Wformat=]
     358 |         TP_printk("folio=%p lru=%s",
         |                   ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
     342 | TRACE_EVENT(mm_vmscan_write_folio,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:358:9: note: in expansion of macro 'TP_printk'
     358 |         TP_printk("folio=%p lru=%s",
         |         ^~~~~~~~~
   In file included from include/trace/trace_events.h:256:
   include/trace/events/vmscan.h:358:27: note: format string is defined here
     358 |         TP_printk("folio=%p lru=%s",
         |                          ~^
         |                           |
         |                           void *
         |                          %ld
   include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_vmscan_write_folio':
>> include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
     354 |                 __entry->folio = folio;
         |                                ^
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
   include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
     342 | TRACE_EVENT(mm_vmscan_write_folio,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
     353 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   In file included from include/trace/define_trace.h:133:
   include/trace/events/vmscan.h: In function 'do_perf_trace_mm_vmscan_write_folio':
>> include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
     354 |                 __entry->folio = folio;
         |                                ^
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
   include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
     342 | TRACE_EVENT(mm_vmscan_write_folio,
         | ^~~~~~~~~~~
   include/trace/events/vmscan.h:353:9: note: in expansion of macro 'TP_fast_assign'
     353 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~


vim +354 include/trace/events/vmscan.h

   343	
   344		TP_PROTO(struct folio *folio),
   345	
   346		TP_ARGS(folio),
   347	
   348		TP_STRUCT__entry(
   349			__field(unsigned long, folio)
   350			__field(int, lru)
   351		),
   352	
   353		TP_fast_assign(
 > 354			__entry->folio = folio;
   355			__entry->lru = folio_lru_list(folio);
   356		),
   357	
   358		TP_printk("folio=%p lru=%s",
   359			__entry->folio,
   360			__print_symbolic(__entry->lru, LRU_NAMES))
   361	);
   362	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

