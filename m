Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9349CD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB5C6B0005; Tue, 12 May 2026 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82B76B008A; Tue, 12 May 2026 20:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98DF6B008C; Tue, 12 May 2026 20:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B67456B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:46:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 627CA1C0FF9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:29 +0000 (UTC)
X-FDA: 84760555698.20.D46D73C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id B733DC0003
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:46:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S2nvT7PP;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778633187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hUUCtQsZcbWiCPzqCtIzJYKeZTZmDtHpVEcwubcUl+U=;
	b=h5uiKnkb5j67mhdUi3pbRicJ54Ypn3S81aty2Q8tNRiB0M9zjIkoMnudJOCzvmDWbXMLAR
	77SzigZL80FwmHkQqPIwsoc9VaH9ndDeV//Tyg892oceEhRhONheXcpgxF1MbOoBFXtjJS
	lmfrqiwT3Vq66gMQrSJhZniThisZ75k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S2nvT7PP;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778633187; a=rsa-sha256;
	cv=none;
	b=ker6mkIbPMHp04M8FhO2aZQ/UUXk4PalxQNKtL0UAhYm2CTcrlvY5yeoS5x0f2ej6OiOmj
	UdTi7MSwhbbhU/y3dGVF9Vkep00DK9Nv4QPyTmV5c3+7S6hL5Ai7xXDfC0LuE5jX6fVWf+
	LEPgui2IHpQV+8XoWNTGO9lPTl5CWaU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778633187; x=1810169187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oq50o2jZ/FE6vpJ/bSMHOFkTcMQ+X7MiMgufB/YUPsU=;
  b=S2nvT7PPB1sltz+g43M0odMbjwFtlHSW0qaS2hcWQvcHSD6eWpS3wSK2
   kbaehoRxWJsaHNcHSC69RCjXM6UaIXLkzUTiKbb+drFK0zg5+1lm7w41X
   wySdizl5Yh4QLmjyyF8Vn2TzTe4ob+RU6fxij2Dc4sOLOwdAyfkKDhYLU
   zVhplmUxypz2RNnHkWvG7lpq98gt5MQUlim72APFmGL3nTMo1ReNwy4UI
   DnO2x5C3NsVP8AZs9a0bI3Vs9x8vCiG3N141g1T9Fvnob9Mkd2YHaWlIe
   3/o1GGPlnfHU2ejgqNqCycMdHF/kjVh/FZnaZVTlw5A95brpdPqMkRHVZ
   g==;
X-CSE-ConnectionGUID: tXZAZ27zS8eQuIDaL+2quQ==
X-CSE-MsgGUID: oVlCTPYjSbCdMlxN6itq9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="79575389"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="79575389"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 17:46:25 -0700
X-CSE-ConnectionGUID: DJ77aG+sRde05p92hl8NOA==
X-CSE-MsgGUID: kxT61vezSeWwPOhyY8Dntg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="235256383"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 12 May 2026 17:46:22 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMxjv-0000000034F-1Qur;
	Wed, 13 May 2026 00:46:19 +0000
Date: Wed, 13 May 2026 08:45:49 +0800
From: kernel test robot <lkp@intel.com>
To: "qiwu.chen" <qiwuchen55@gmail.com>, rostedt@goodmis.org,
	mhiramat@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, willy@infradead.org
Cc: oe-kbuild-all@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, "qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <202605130842.zWTTtyaL-lkp@intel.com>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Stat-Signature: 7511t7rdy4tzbuxfdtc89wbrhqz4bmut
X-Rspamd-Queue-Id: B733DC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778633186-728665
X-HE-Meta: U2FsdGVkX1/TuIeZDWA8w3sYbDTQ6QISkUH3HT0judB+7MJdkqvx8Ihs4P9yzOdL1WjVUN7Sxdir33+S8y29dcKO0D/uL6obLjvayaNKkKxgFsaLZzx2AEnzuAUcA88DBb21QsrQWkPKM9wIKPEEm2SvHAjoNZb3tcTb4HutSwyB4Qq3yLhj1aY4Df1g3TcmVxVrHbmnyeWAS9VT6wmiG+KLua//Y+i371nAL69+O6VzZk7eCMUghASM4TWI1Ndg+MzCvz+V6yBhL4nOxG9kI7rooF1vtHs/sGlmFoXbWMRZIsyVzPcBfZlev+zaZnmg8dHD61YV+nCqbZHnHIFTm0Biqs3HxC/r1Az0gFHb4tzysv5ih61c1o3/Qzf62O7kU0A9fNDIhw7wiD/5Jq8DqzqE//f8RwFzGfv+6ynBoOpf0SYMYONFlJ5xBXXiC8r6wEYYaBlibhD3AKRy3RBihHugsvSGNKHErkzCxoj496ieO3K1i8Qm+N4sEHlMMOCmA6Ktma/0atxOt/UdpzcVv5yPN3uzkKga8K/Sm8OvCIU4IUFCs8ukdTZhq8NABgD7maYRkfmc6m77yv8sj0zNKi6ai/laDVPN5dQj8XqfPvET23sHsrxeqykJWHmznK62479lOrPFrU9ZBWzw1K5Rbf8st1iitiWlDzTvmKvkVq6gADR2QvaYcBfKz5SlHJfU+oG6ablptoURaIspLwl1T0jfrEgwVm4NFcFRobJamWjMXLii32cWaGNZocjiS2lkvwdpWiUt0nwkDiZxxWxMY+od73PHKKOMESs0lqtfz0NjfglzzTsc6Vbkj1Rawv37GnolVhYeDNzALfWWxHKqUIbgwo5U9BrH9/ZgxyuWpDtLPWAW75lu2SrzYGb25TGZhq8ZGavs9qkztddmtkjJeuorVBU+R6q7S8G929tNGO0TyAH68oY+s/rC2eTWUWRvThQPM0+oEKsaNggtxzO
 4v1w/NsY
 HYtKSnDOqVJiw8AtXppBF5/CcZM3FUF79Es4QxWvlhk4Q6qV5TYfvF0RZpGymi8MTrAvRx2+aIsrai7GTg2Pe3Vz7Lfuvo5MiBpQcXmAda4B9iHmXuIGgZqpc19q4w3clOYbcVUz0dPQS7GLNzT1MWgjbpkeDAEr3qHYFolEjaK5NDxpsQaWpDN2pAwttcT4M4WsaDsGDNsgDxeNSNg/wxnU4fJ4ENkdLbjj/s1M+kNdVyBXh7EqZdNRGemw3s/JzmYpxdXnak7umqpEuiQGi2wkdtIkIVxKggIc51FivA5rzDDIylzrJbKtuxR77dv/tdyGKesKC1U1VqKUkFiuN1mAxl8+jf8bIQbENa+cFjb0PCRYjrHqiX+uFts0f+KW/l1bi0chF3B/Ykr8iGjKV97+G0oc8A0/GgYeoAto8P3oejXCRocZopBf5CqoouHYOhqkzi99Kx+zOvI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi qiwu.chen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v7.1-rc3]
[cannot apply to akpm-mm/mm-everything trace/for-next next-20260508]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/qiwu-chen/mm-vmscan-rework-lru_shrink-and-write_folio-tracepoints/20260513-040720
base:   linus/master
patch link:    https://lore.kernel.org/r/20260506083652.100160-1-qiwu.chen%40transsion.com
patch subject: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio tracepoints
config: sh-defconfig (https://download.01.org/0day-ci/archive/20260513/202605130842.zWTTtyaL-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605130842.zWTTtyaL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605130842.zWTTtyaL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:602,
                    from mm/vmscan.c:72:
   include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_write_folio':
>> include/trace/events/vmscan.h:358:19: warning: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Wformat=]
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
   include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
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
   include/trace/events/vmscan.h:354:32: error: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
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


vim +358 include/trace/events/vmscan.h

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
   354			__entry->folio = folio;
   355			__entry->lru = folio_lru_list(folio);
   356		),
   357	
 > 358		TP_printk("folio=%p lru=%s",
   359			__entry->folio,
   360			__print_symbolic(__entry->lru, LRU_NAMES))
   361	);
   362	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

