Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF9C6CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 01:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF016B0005; Tue, 12 May 2026 21:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158956B008A; Tue, 12 May 2026 21:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01FDE6B008C; Tue, 12 May 2026 21:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEDD76B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:19:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ED6C1C16F8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:19:33 +0000 (UTC)
X-FDA: 84760639026.10.36563E7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf22.hostedemail.com (Postfix) with ESMTP id E193BC0009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:19:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3Vmqd2+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778635171; a=rsa-sha256;
	cv=none;
	b=a8Wu8DSpqK4mVbZHR6MHzNvxW2vnwe5wSCboSk3i+fvcGGsNnZ5eAbGCJFUPWmJopU8mcf
	v245lJj3euIYqjCYLYcowGcizy4nCuGC9CRCpmKR1fWqrjPa4CiH+cwiPCTVIkLY8eGvqp
	x+idajCaJ/FyAQEB4cpyVSs9E5GIyT8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q3Vmqd2+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778635171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmut2DpF6p2q3XcNwl8bsCd3rve6gYZOW82L2UdPhXE=;
	b=z+XilcM2kmpQGkQernroKZ6zzflTkUjBh/PwakEZhp16v/mcVuWMoxMU595tfNg6Ul7BOi
	07ZVR7hIMoKpEH6elm6cpsYskpdynJ/EwEeTf90enZBkS1+v/jNINpoAkmf13L12zVVxY5
	jBiBn72EuEyfL/EtPQxAhocKogy/mTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778635170; x=1810171170;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xyrOPamgQ4Fkzwm6jfzJfShElBZc1B6GwVMpeHGtwkg=;
  b=Q3Vmqd2+PKASznDUZF+Rpq140nYnou5yf1DvEyydQPVNa/6dFk/pMG1N
   Js1G4+qEkZeG3nLLUg8f/n5BsoGgui8miZioQp69Xm+vxPWMCFaqpcBPP
   374H9u6Dkts9WBfjJTNgrhOYWbmqdlFnD2AjurPhyoor6aS1EHB1zESdU
   OeHCKexIcDQJ7A+FQyg6LlbdvxTsRDg9knOPY3USbk+cJ7kSI1PfxNvXj
   Qak8Te3yhZcIdcrt2RfvenpQOKktivaJ1USzt/01tyzOuW+R5QE/1hg/b
   KCLC4rQj/XCbh/yp0UUbxVuEmGdMt6RHIk9L9nBeUBitnheEhfMfui5u/
   w==;
X-CSE-ConnectionGUID: jdggduHfQASu+UwCMVFOCg==
X-CSE-MsgGUID: KuUyTLT6TqaGc1+UIUtxAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="83169943"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="83169943"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 18:19:28 -0700
X-CSE-ConnectionGUID: yvQzOIs1RfS5MfRMl3+nxw==
X-CSE-MsgGUID: M/6yLguBQL2bk213TawFxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="239740707"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 12 May 2026 18:19:25 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wMyFu-00000000375-1a3q;
	Wed, 13 May 2026 01:19:22 +0000
Date: Wed, 13 May 2026 09:19:07 +0800
From: kernel test robot <lkp@intel.com>
To: "qiwu.chen" <qiwuchen55@gmail.com>, rostedt@goodmis.org,
	mhiramat@kernel.org, akpm@linux-foundation.org, hannes@cmpxchg.org,
	david@kernel.org, mhocko@kernel.org, willy@infradead.org
Cc: oe-kbuild-all@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, "qiwu.chen" <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-ID: <202605130942.9wJFWm9M-lkp@intel.com>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Stat-Signature: 4i5m6kgg4rf4rr4ngu84zfd5ij33rdyi
X-Rspam-User: 
X-Rspamd-Queue-Id: E193BC0009
X-Rspamd-Server: rspam07
X-HE-Tag: 1778635169-257491
X-HE-Meta: U2FsdGVkX195QHZztoNLeaw6pHe6OLtxsf+7UigFl5H2MXfbXl45V0Hwfc86EP5IF7v0xjP1kM3OG7k/orX9ckP1d0xcxfrcdIbpNOFxEX1uIFR3eH0ijc9Pf0EPg1dpITFDS+jX5eTYlTxMVet1IOmYfFD4YVGxBM3J5sgXqeAx+NU2hrVe9HZHrA8m9hoJ0G+yY335LjGmLnT+LBn9fY9hbCDYM02VxHzbb7jxnKwWQidp4ga4JXDYKywPnbWktovEWLnpjokBQMZ9xqMswmnajQGOUKliORH7sfp8KYXYdh93r/ehi4BWWejz1MaH+BrccwcklX8e817+75gP6hfvCXzLI+5LEVBvOBr5q6k8RpiCQDUb6XPdQ8jIXLRhGPBiU2zRtIS/K2pXjxVYujShlGmqcjZIGFGglTyQ19qab2tpmjIYI1jeJDgdqVD7TRcwpPotamiqXUQiCFUMgvfTCOcVLj1N7jZLGCS2TiTyCBi5kGDjgFo4M9MWj/v9OiUA945XHrrb4KKf37MKNLHznMyt/ThggR6TMRnHI9hviu/0xeNmJWBGSHKTni38FRBUoe0bml4z98GwRkMRJQAbJrDnvKPKxv7e0hb5eaV4P0jOWfy/rXJiS99OKxjivvwLvRHRkCkoQVaSfcBFw9T7G3lDPiBoCK179ztGeujhS54aYvlvrD0WOXqJnrHmMSHV/ZXxAxOqFi65+qn5eqv3g8zrPaf/tqFEuTxp176aNma4AH2hDAgqDqlOfHuw7hAIpzWVwnKDItD4L6Xnoj3Da3nJUWCkPr4o2A9xLyM7yl/5z4pAzZ4P5crHB4kPQRY8nHedmtC23FLMLaYNxEpyWm12s0ot8s9AhTK/ctUuEuogK0T+h9sRVqYomEtSqSJvIfraVh5RtH6py5Fk+eI4yMvkGZGJrWY6iKSbKvJFjUIA50+Z42yAKoVKgQi/BV0XvSDw7BXel0Si4pG
 qEyPb1iV
 hAi+JV/Xe3YTevyZ+RQoXS8oXQqxmNriKHgyrSk+K4Ni7EW1h/9eRkoXa1iUuKecHpWaxn0vrkVSfpJAtFcSD7YiiGF1QD4PrJ4kQke1dmVVjd5G3ZBW+pgG0c7L3e4TxM7T6OSrMsmqF5zQOgNbES3zkRCrKA62Jaj6dwpe877n/KbsXQfl255AvAgBBerB2AAqZIitihKfeds6Snzx7PbMu7Y/fHiGZtLbNGJeThVQU6P1zCILSlvY5RErhCMJkaDKyITgK3XH48VsmADHA52CatZyR+1fQsK4lC/o9SMTr0iCtkBHjW4wOp710aqYNlD3Z7ur2ZfWn0tf/ObTGnH+i0rZyS5g+VM6Zv5zF49mlHIJ7QzoDWtIMhVYO5Mnmt3x7LRG/+iS8XyfC22VxucNC51qkCtHOw/JKPnbmne8p7RNYQ/IpM9aXvTmNCR9hKXLRbF8NZrctjpI=
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
config: xtensa-randconfig-001-20260513 (https://download.01.org/0day-ci/archive/20260513/202605130942.9wJFWm9M-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605130942.9wJFWm9M-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605130942.9wJFWm9M-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:602,
                    from mm/vmscan.c:72:
   include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_write_folio':
   include/trace/events/vmscan.h:358:12: warning: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Wformat=]
     TP_printk("folio=%p lru=%s",
               ^~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:219:27: note: in definition of macro 'DECLARE_EVENT_CLASS'
     trace_event_printf(iter, print);    \
                              ^~~~~
   include/trace/trace_events.h:45:9: note: in expansion of macro 'PARAMS'
            PARAMS(print));         \
            ^~~~~~
   include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
    TRACE_EVENT(mm_vmscan_write_folio,
    ^~~~~~~~~~~
   include/trace/events/vmscan.h:358:2: note: in expansion of macro 'TP_printk'
     TP_printk("folio=%p lru=%s",
     ^~~~~~~~~
   In file included from include/trace/trace_events.h:256,
                    from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:602,
                    from mm/vmscan.c:72:
   include/trace/events/vmscan.h:358:20: note: format string is defined here
     TP_printk("folio=%p lru=%s",
                      ~^
                      %ld
   In file included from include/trace/define_trace.h:132,
                    from include/trace/events/vmscan.h:602,
                    from mm/vmscan.c:72:
   include/trace/events/vmscan.h: In function 'do_trace_event_raw_event_mm_vmscan_write_folio':
>> include/trace/events/vmscan.h:354:18: warning: assignment to 'long unsigned int' from 'struct folio *' makes integer from pointer without a cast [-Wint-conversion]
      __entry->folio = folio;
                     ^
   include/trace/trace_events.h:427:4: note: in definition of macro '__DECLARE_EVENT_CLASS'
     { assign; }       \
       ^~~~~~
   include/trace/trace_events.h:435:9: note: in expansion of macro 'PARAMS'
            PARAMS(assign), PARAMS(print))   \
            ^~~~~~
   include/trace/trace_events.h:40:2: note: in expansion of macro 'DECLARE_EVENT_CLASS'
     DECLARE_EVENT_CLASS(name,          \
     ^~~~~~~~~~~~~~~~~~~
   include/trace/trace_events.h:44:9: note: in expansion of macro 'PARAMS'
            PARAMS(assign),         \
            ^~~~~~
   include/trace/events/vmscan.h:342:1: note: in expansion of macro 'TRACE_EVENT'
    TRACE_EVENT(mm_vmscan_write_folio,
    ^~~~~~~~~~~
   include/trace/events/vmscan.h:353:2: note: in expansion of macro 'TP_fast_assign'
     TP_fast_assign(
     ^~~~~~~~~~~~~~


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

