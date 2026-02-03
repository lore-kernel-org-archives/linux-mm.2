Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 185E2E87821
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 12:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D956B009D; Tue,  3 Feb 2026 07:13:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634436B009F; Tue,  3 Feb 2026 07:13:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D746B00A1; Tue,  3 Feb 2026 07:13:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 439886B009D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:13:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4321C1DA9
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:13:15 +0000 (UTC)
X-FDA: 84403035150.26.ECB77D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id BFCCD20002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:13:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPNUOp5h;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770120794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JrGbgaz3YKBELaGhRBLveiPmJ3xQcCMLNkOFNoesi4w=;
	b=Nw3/l/r+AQTPVDXVUyMccT5uM1My59KS/0RVir2QShiFVKXLyVckXoc9FyB5NAwbW3HDrY
	lzdu+wWEmnTvnTmDfkBZhYoWPljfmpxHydtKTG14m2KOGUP1fFZtPd6/h/R5Iv7tuDG6up
	Mig7ghuTWAVW/BJ1kRJniaLZvaIKfsY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DPNUOp5h;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770120794; a=rsa-sha256;
	cv=none;
	b=Vb0P6hgld+WFxQ0CgRvnvCPXElWLngWyrfDlhQPoNgRsgQgG70GywCLsFBpIvxbWgputHN
	U9giRGr6sxTPXTnA7QkUcJOuUK8Xaf8RRbS7KUrnbLjqRugZa2xv9kWEofPOdjYKDpXUhv
	js8Z9EuJOcjaTKPod0SgUndCEInniig=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770120793; x=1801656793;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=EJ3LnE8q3TaYue/6JRSSE8ScZ+X65Vqv7A3J1Op26pU=;
  b=DPNUOp5hECF4gxQ+8ZkKxf/oN5goAy19BhNznfQwBdrLe+h3HUmTuztd
   VFlfTbPmr13JpvKRJY9dsd77w21zqVpP6uqm8QWpFPmMgir6izxE59DbM
   CGIUoGjAxU6HBFfiWTJfUyXT61m/sKf/PAcmurQXwup+g0CDeP4UdCmo2
   4jWRQv01t5Uu4poZ1HMwbksL63IytaoQPBnQUP6A/J4pxKi1UPtrd7bXD
   rr7g1l1juA4asSuWXEUhnUpiS33UCDBH6ypw4mlKB5D0w2oh2e2tqf8Kx
   ayFnFvkzRwFDGJQU6Z92mzIvgNo4KIgX4H+W9qTiRlrgAdfVSVwz7BhQj
   Q==;
X-CSE-ConnectionGUID: 5iIq+7HfR8urTiC3t1pEOw==
X-CSE-MsgGUID: EbiwiHORTuyXNhIPeWz9xA==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="58869531"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="58869531"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 04:13:11 -0800
X-CSE-ConnectionGUID: fQ0yhWwURwO+qWpT5qZTOA==
X-CSE-MsgGUID: 6CdExaoMTyel01JhIX6pkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209250856"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 03 Feb 2026 04:13:07 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnFHE-00000000gcK-1HST;
	Tue, 03 Feb 2026 12:13:04 +0000
Date: Tue, 3 Feb 2026 20:12:57 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Simon Horman <horms@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Yury Norov <ynorov@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: remove __printf() attribute on
 __ftrace_vbprintk()
Message-ID: <202602032036.FQK7gJvV-lkp@intel.com>
References: <20260202095834.1328352-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202095834.1328352-1-arnd@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: BFCCD20002
X-Rspamd-Server: rspam07
X-Stat-Signature: ojh7n8qnrawtepacwr783zj5g54fdfud
X-HE-Tag: 1770120792-57658
X-HE-Meta: U2FsdGVkX1+Yy0GxIpejlTX14hY0GhSuTXZLhKGXfntUdEJc7BqgGAEEJtHO41C1tZBkmQRvZtnw8SAmVyKfIZkONwMXSSV+4jeoxGmT39A7MynqWmagWhEYj7OXx8334jUbzZT68ntIrNeQRfD7YTh+RLuET4rQ02TIoefz+WddGl/g3Om3EyV4i7SNdyW2vfxu6IhxVwpzjuRwaanz5ZYHlDNEEHpboT7a6BLMMA0x9NHrmB0k8NMQ86ueT08HHxa5xOp+NoIE1p4IRaJ+NX6v3yL+pUVj4EfoXik7alK89WQSJE1D1GtUzHQ7zMejJFs5FSLSlAS/k2xrrUoRujkYjQFTcDmoHUi1XSPTOvYK5/J6rnMeXX/9+dE7GLUTfhIWgny9uSxugk3+Ro+iKT5z9LRoLUUHOI2lXmkZQ+Ait3tMed+f5sQddI9OXFnuOdELfTmR1wL5svrh/cEwErUfVue5l5MBDUTxaNjtrOovgWEpRzz59sLqV91s7iTTc3uDPHg8idm78WZwOsWnYUGMV+0Osvm8gE+xRpgYd4VK1okqXdm/dtspPk/J5EbKYzhk0YOK/9XuEixmwWstVx9sAmaxI2v8bJ0sXdPtdH6LuyJW0qp8cYMhZFVqSJBFmp5ryTirnLpqIMrbAVnSZ/aY7hgGK0P5tMLdUun7wfm6KIllTVctnYZrkLDCBT0ZefS9pzXoKQXxG/jEHZqPbz3yIruqzcffzErHkuXEXTlSr5s7FB7nKCv9iw+zbftLJR4UN7HQdqlJIX/ozFMmqnJxwBtoZ3R7DD7CVKXaRJT8+Zw7kKNN3a6Tfr9B2OZsFv3dhf8uPcm77L918lrfKFm/B1J50Y8RyV72tWRxzzo/BxKE8peezIK7jSc8C2mCSqGhRJ8df1D6OynMvY/fWWQ1MqIpHHTHGLAQ6fCKUKD+YU1Mz9WX7b4nGZrZAT1+CSRb9Z3XNgnOcs7AnzA
 8l7gTeKs
 ccX09kXH3XJg2pVU+EWBsL5JZIQyE1Q5yznZi8L+JjVnHfLnekAdugg+1jlsUvmHI7uCHQFe7w51w0vl1luZEqsxYCm3ZqhCW+AtU+zZcakh/LMOYuR5CWLay+FGIoDotPxoosvP/pn/no7iqZNZz99GsmGbsmAGVXceWitcsnZ4EE1pNnd5xB/xRJG7+rgoXGDNDhkKnQk0A34889aPB7qgx0b9gRZWM4K2v5ecWGNkZyzrwJYPZdDIwlJ7orX3jYiitZtmTVzaKO6QjpIHY3VzOIwdxIrk0ib4sVhr7o4YzUHAWT8rIOKZQPvgYAIAUw+xpVKzoMS7uzTb0DO1jNMpzM1qeEEe8tnF2047CJwzcA6T+sQ2x4pHth3OUMukxDKXii2HGOe6tZMpYLAMkNP35Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260130]
[cannot apply to trace/for-next linus/master v6.19-rc8 v6.19-rc7 v6.19-rc6 v6.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Arnd-Bergmann/tracing-remove-__printf-attribute-on-__ftrace_vbprintk/20260202-180958
base:   next-20260130
patch link:    https://lore.kernel.org/r/20260202095834.1328352-1-arnd%40kernel.org
patch subject: [PATCH] tracing: remove __printf() attribute on __ftrace_vbprintk()
config: riscv-allmodconfig (https://download.01.org/0day-ci/archive/20260203/202602032036.FQK7gJvV-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260203/202602032036.FQK7gJvV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602032036.FQK7gJvV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/trace/trace_printk.c:212:34: warning: diagnostic behavior may be improved by adding the 'format(printf, 2, 3)' attribute to the declaration of '__trace_bprintk' [-Wmissing-format-attribute]
     212 |         ret = trace_vbprintk(ip, fmt, ap);
         |                                         ^
   include/linux/trace_printk.h:110:5: note: '__trace_bprintk' declared here
     110 | int __trace_bprintk(unsigned long ip, const char *fmt, ...);
         |     ^
   1 warning generated.


vim +212 kernel/trace/trace_printk.c

1ba28e02a18cbd kernel/trace/trace_bprintk.c Lai Jiangshan            2009-03-06  199  
48ead02030f849 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-12  200  int __trace_bprintk(unsigned long ip, const char *fmt, ...)
1427cdf0592368 kernel/trace/trace_bprintk.c Lai Jiangshan            2009-03-06  201  {
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  202  	int ret;
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  203  	va_list ap;
1427cdf0592368 kernel/trace/trace_bprintk.c Lai Jiangshan            2009-03-06  204  
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  205  	if (unlikely(!fmt))
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  206  		return 0;
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  207  
b9f9108cad3998 kernel/trace/trace_printk.c  Steven Rostedt (Red Hat  2015-09-29  208) 	if (!trace_printk_enabled)
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  209  		return 0;
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  210  
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  211  	va_start(ap, fmt);
40ce74f19c2807 kernel/trace/trace_printk.c  Steven Rostedt           2009-03-19 @212  	ret = trace_vbprintk(ip, fmt, ap);
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  213  	va_end(ap);
769b0441f438c4 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-06  214  	return ret;
1427cdf0592368 kernel/trace/trace_bprintk.c Lai Jiangshan            2009-03-06  215  }
48ead02030f849 kernel/trace/trace_printk.c  Frederic Weisbecker      2009-03-12  216  EXPORT_SYMBOL_GPL(__trace_bprintk);
1427cdf0592368 kernel/trace/trace_bprintk.c Lai Jiangshan            2009-03-06  217  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

