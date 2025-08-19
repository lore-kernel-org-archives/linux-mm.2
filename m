Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8775CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 16:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB468E004F; Tue, 19 Aug 2025 12:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593348E0005; Tue, 19 Aug 2025 12:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8848E004F; Tue, 19 Aug 2025 12:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38B978E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 12:00:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF398C0133
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:00:39 +0000 (UTC)
X-FDA: 83793969798.07.1B50AFC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf11.hostedemail.com (Postfix) with ESMTP id 297E940012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 16:00:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W2kQEUBR;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755619238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxGAnrBU6aGprCbVOGp7RJcH7PP0gyb9f79VILNC/WE=;
	b=b2KP1r6QkGwN+6wuputB5wu5ujkRv9yPTv0kv9aH+27LwbPN2LRW84LcpZyQo4BxMrpgXu
	6B4ISRiki/hVgIZ3W4+GPN5Lek+azktawqlhzXpWJKVQrqpJTdQUSF5slsDASrJgpY2WV4
	3e1hqH6XRz8tBGwpmOAtvHkGOo1GDpU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755619238; a=rsa-sha256;
	cv=none;
	b=Zu7dscVkaD9l4Yqg0EF2415X/hIV1tnp3mcsfTXa4hNggwZXBog7gH9EHuVjurmWDkKOC7
	pTODOAbn+uPg1EnDgJFI+6kFhpUtKYyUPeahhhUs9Uek1O3SaK9nXpxZorBmhAMm2pNmLt
	szqED7GwUv0LO6FFHjxApzj9jl4fNgA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W2kQEUBR;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619237; x=1787155237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9pCGquBfB9iEH+++tWiD+pVK53sSQfG2z2BeRYgVW70=;
  b=W2kQEUBRsPrPbBnm8gGyCOd0gkXFLTjoEfqTi4+0tqvwldhqLSjlGgeT
   1mSDlUS9wZraubae2phPfRAY7tiyZMtpNOz3gFMQ64FdRh0Qi1JJVBLEp
   lzRzLjbN3oggDZer9xXKCjSq3BY5u5hdg+ZfvBrNOUoqQnFTYMENE0Z/z
   YJLRDSyUAwpghsynrDfErsitF0h1gVFFemgKFYaxZglBUTxWMw8wWBLn4
   lWR3Sb/aGRtXqpwJvZGEApSdpZTRWtHLguVH/rnbJSN/69MS9iskEQJ2V
   /8VzgYqdhVZtEWe6W1GhxUbMcskzg08eipw8s3qKx8zz8TFOAsR7rptKS
   A==;
X-CSE-ConnectionGUID: 8NfR8vBFR0ez97wJw4aqPw==
X-CSE-MsgGUID: CqHrm5haTYOZjM+VYXpE8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="56896699"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="56896699"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 09:00:35 -0700
X-CSE-ConnectionGUID: RPcjQSr2QdGwG+6/sj9wKg==
X-CSE-MsgGUID: 6kHb0nwpQF+Tr0QnUKeOLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="191567611"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 19 Aug 2025 09:00:32 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoOl0-000H55-0I;
	Tue, 19 Aug 2025 16:00:21 +0000
Date: Wed, 20 Aug 2025 00:00:04 +0800
From: kernel test robot <lkp@intel.com>
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: add available_count and total count in
 trace_cma_alloc_start
Message-ID: <202508192303.cnpF2rQG-lkp@intel.com>
References: <20250819032654.4345-1-gxxa03070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819032654.4345-1-gxxa03070307@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 297E940012
X-Stat-Signature: darbxcetp64mqfijonyp7u4pfjz9c7mg
X-Rspam-User: 
X-HE-Tag: 1755619236-148162
X-HE-Meta: U2FsdGVkX18K47OhUTu+Y0Rl6whII9mzRG21bwsp3lZvLUIpPdmjhMujEikA1KdckIinRpNg/NF5SlYD5Kq7Xm9fAa1OEW0epTX/qGnj7F8qQiq3cpbf4zs40F4yS6ZMq/aSX/ggF4zu8Zwl4OPbXArCZJBlbPKVEyt2rY8UWHLVi3PXqvH8avDXYUzJYN9a/rX4XXIAvApFHOw7+Ei9Z2IweQtfUXkz/0P5IqTdUUxgy0yq7SPtSK+ckuULpSX5bfO6DN6navOkdCNrRaGiP5p3Ul/Sx5OmqP4Wagx6q6nlixFKS35mLbVn153D1ojVB9auMu/gbwStMmJozbS6Yra7MmCdGe52Ra3834EpD4xkFIIT0L4UwIcbbNsgMnTaK7y0K60O9c49lzdVH1rllnQqvF2U3B4hjqknybGeNLyfQsvTOAMDzopr6usBfc7d8yuy/eq8hzW7a1wt8YCNXrQFf3zNy5CcJMXIgxo9x4e6xCDg12EopnVQAIQVSw1IiLPg/YDKrrJIw4lPdp4zFgBA0a6w4eVD+Ly3yFycbFvnLXiqXUkVIAm3w109i88Ue9Vhd9abHgHSf+vX1d6c+zNwga0QIlYqf82hLjxeeUwmCjrARnaeoAXXL3nz81w/4+uakptxR6xXapKrwInhRCs3Ukv+mxUlwHLwXeZ5omltRfv3KnVybBpIp8QriKACjxSMaSgmq+8q19I8LGNxAVb+eiAtG/9b6i/igv/ST5MEb7hEmbhTaDDWLvfeXN/o+OC+QUL6vz/J8b4ZxHbX9r9Olv5sdwVFKnnQ3guLjaLO7ELMTxnoVg3I0c2hNG88boxQAVmT50m0QU1kBYQnLMJ7czqTCWiQsyvkE6QPum66EWr7Y/KwYuYSr9l2QALp7jc44IcDh7UQNZRdL4AxAzLAuvmIbCvZ8B3+8q9VmiGRCQNiosBTCtPtZwuLuOticbHnmr0irOKnWWi7V/R
 uZ6ElnYz
 nuy/VKTn5Zly3KRwH+ZW5JB4/NUEySTrHZvUvwggWL01AsHU+FWTG+4zB+BShHpLWDqFalcqZylh60pjkwWi3x2A+HKtJ9/FE0CgxgEyYcSr8Q35U8A+YgYrPAtj+HybknoHjyklZkjbsTEk+BQU2tnukHzHtgXBAlaUru1Rpys43Z2cCQENR43gyZiPFwgUmAb0HmKDxqSg/J6LMuXFcW0WrhBvfuOXyVCVb6CEIzMW3t2rkBgd+bvKn4P6Ew9B8bHcoyhk/UWycZkUIO8AYKp4MCIE5dy6YSlDBsy7i+MKJ1Bhw1/rCzJijd5KUp7WNsgNfcnT6l3nK7MZrYvLVuHoMd3hZLYilJ7VanRqVA8Vc0GbElVFzC26kPm3If2gH/FgNAUUjvUNS0ZhH3f/3C7cIlA==
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

url:    https://github.com/intel-lab-lkp/linux/commits/Xiang-Gao/mm-cma-add-available_count-and-total-count-in-trace_cma_alloc_start/20250819-112831
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250819032654.4345-1-gxxa03070307%40gmail.com
patch subject: [PATCH] mm/cma: add available_count and total count in trace_cma_alloc_start
config: s390-randconfig-002-20250819 (https://download.01.org/0day-ci/archive/20250819/202508192303.cnpF2rQG-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 12.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250819/202508192303.cnpF2rQG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508192303.cnpF2rQG-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/cma.h:138,
                    from mm/cma.c:31:
   include/trace/events/cma.h: In function 'trace_raw_output_cma_alloc_start':
>> include/trace/events/cma.h:62:19: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'long unsigned int' [-Wformat=]
      62 |         TP_printk("name=%s count=%lu align=%u",
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/events/cma.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(cma_alloc_start,
         | ^~~~~~~~~~~
   include/trace/events/cma.h:62:9: note: in expansion of macro 'TP_printk'
      62 |         TP_printk("name=%s count=%lu align=%u",
         |         ^~~~~~~~~
   In file included from include/trace/trace_events.h:256:
   include/trace/events/cma.h:62:45: note: format string is defined here
      62 |         TP_printk("name=%s count=%lu align=%u",
         |                                            ~^
         |                                             |
         |                                             unsigned int
         |                                            %lu
>> include/trace/events/cma.h:62:19: warning: too many arguments for format [-Wformat-extra-args]
      62 |         TP_printk("name=%s count=%lu align=%u",
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
     219 |         trace_event_printf(iter, print);                                \
         |                                  ^~~~~
   include/trace/trace_events.h:45:30: note: in expansion of macro 'PARAMS'
      45 |                              PARAMS(print));                   \
         |                              ^~~~~~
   include/trace/events/cma.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(cma_alloc_start,
         | ^~~~~~~~~~~
   include/trace/events/cma.h:62:9: note: in expansion of macro 'TP_printk'
      62 |         TP_printk("name=%s count=%lu align=%u",
         |         ^~~~~~~~~
   include/trace/events/cma.h: In function 'do_trace_event_raw_event_cma_alloc_start':
>> include/trace/events/cma.h:56:24: error: 'struct trace_event_raw_cma_alloc_start' has no member named 'count'
      56 |                 __entry->count = request_count;
         |                        ^~
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
   include/trace/events/cma.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(cma_alloc_start,
         | ^~~~~~~~~~~
   include/trace/events/cma.h:54:9: note: in expansion of macro 'TP_fast_assign'
      54 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~
   In file included from include/trace/define_trace.h:133:
   include/trace/events/cma.h: In function 'do_perf_trace_cma_alloc_start':
>> include/trace/events/cma.h:56:24: error: 'struct trace_event_raw_cma_alloc_start' has no member named 'count'
      56 |                 __entry->count = request_count;
         |                        ^~
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
   include/trace/events/cma.h:39:1: note: in expansion of macro 'TRACE_EVENT'
      39 | TRACE_EVENT(cma_alloc_start,
         | ^~~~~~~~~~~
   include/trace/events/cma.h:54:9: note: in expansion of macro 'TP_fast_assign'
      54 |         TP_fast_assign(
         |         ^~~~~~~~~~~~~~


vim +56 include/trace/events/cma.h

    38	
  > 39	TRACE_EVENT(cma_alloc_start,
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
  > 62		TP_printk("name=%s count=%lu align=%u",
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

