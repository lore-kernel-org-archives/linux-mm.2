Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E731062868
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A17F6B0089; Wed, 11 Mar 2026 07:24:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8452A6B008A; Wed, 11 Mar 2026 07:24:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D616B008C; Wed, 11 Mar 2026 07:24:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3906B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:24:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95081A0128
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:24:32 +0000 (UTC)
X-FDA: 84533549184.11.472A3E1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf01.hostedemail.com (Postfix) with ESMTP id A6CF54000D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:24:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PG3lUej/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773228270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RU+rcs31a/v5hO2cCxiaDgl0I9IyoEi+IhVH3pVqJa0=;
	b=jBSBaigElpGwtkUa+Cu4ql45jJXCAvSUEHs6Fjd/h83vDhKwTaPw1PLnkH0LiHKcU1LAfL
	gcoyLZP4Icirb4zAippDD/7YYyM8hJLU9PcYuHnpBSTA/Oj999afIJkIKU+drdFmm/kFS0
	a8B+jdOkfaqXHHSX5vdHQ5SS8oDEppM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PG3lUej/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773228270; a=rsa-sha256;
	cv=none;
	b=B1zb5NOsFXD035Enoq6SudpOazgBOva2yIhfKCqxcjTYpJlCG4GqOcX1mjXePT11Cgvb4U
	j/ZHQkIBcpxKiMnpkpKzQESJMQgGjk3IT2e+3Kb7EISdtc0O2auzZl4bGhedCAvErmVOav
	x4AhhwP9U4XYStpwaPDBLzXC7hrBM6M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773228271; x=1804764271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MrItGMIwck97yHNleIjnWht9bi1GncmtA9PeyGCwBMs=;
  b=PG3lUej/LozGcCGbjM7PXqamQrwEgRn6GShtey4cXTeniO6K4QGtDC9h
   eoKwQoj19f3NsDLa8L0M4f/NRB9vPfGN/u0+HHnBMKc4p6HMn23MKOXBI
   3F0PZLralRbEOdln2ikobiHJVfmE2ctv1zjUFImYbDVRS40Ue2RnEh8ES
   2XVu3h2iS8whYjtpg1iE6OQV6eAK/+UnD373OMvV2QW+wO8XFEWPJFjoQ
   c60bd7s3lxR2SUEdPNBkm0FmxfiMbjtuXbpBK8cOFj9eOT8NeRBGXNpIK
   a8m1ApW5d8v5eMInysrL3C0IARoqMBsVDH6YjBUZKBz0RzxgzMc6Yijf8
   w==;
X-CSE-ConnectionGUID: JF+tllLkQtaPYA5P9MCavw==
X-CSE-MsgGUID: pRPd2DBOQ3+fch2Vxw8pdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11725"; a="76903773"
X-IronPort-AV: E=Sophos;i="6.23,113,1770624000"; 
   d="scan'208";a="76903773"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 04:24:29 -0700
X-CSE-ConnectionGUID: fw1E74arR96VolAP3q/Egw==
X-CSE-MsgGUID: gTH9KMjeTPWUWgVUI7QD2Q==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 11 Mar 2026 04:24:25 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0Hfr-0000000014P-0HV2;
	Wed, 11 Mar 2026 11:24:23 +0000
Date: Wed, 11 Mar 2026 19:23:39 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Brian Geffon <bgeffon@google.com>, John Stultz <jstultz@google.com>,
	Ian Rogers <irogers@google.com>,
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v2 1/3] tracing: Have futex syscall trace event show
 specific user data
Message-ID: <202603111911.zAWpiGlz-lkp@intel.com>
References: <20260310201036.542627924@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310201036.542627924@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6CF54000D
X-Stat-Signature: 1bx1d3okx8skkosjrdcsqzyd7dhjg79b
X-Rspam-User: 
X-HE-Tag: 1773228270-828074
X-HE-Meta: U2FsdGVkX1+766lXrm1B21zM+QeAeWhZ3QJdtRwlyO97JQMvj5kFfRcsiIokVzramvXHU9fpa68c/liNatRoOxr9XUsL4v+OvmqOIIOxVCp5R3PmR9na4F0snK4FQmWKRJC70i4l8mAMV15lUGscpHAx8x0op8HCh0ruZcMtpO1mDUTqKuc1+A6L9fdt+LLgrBVFIMaquS7kvESN0wgHwaocO5XXE3/Z2hch3dsnM7mr9vmMD1pxSMCWB31M4Z5FZGasg7hmDC7lPKy88QJ6NZnYpaRkvbPodq/aYhjiqUD3xpsI5hqqYYyTk44OzB8jiabgPZi+v/AUVY8W0mzlA9nkvYWOJhPs+0Rj6kLIyPqqN/rRzEXopZVfrsOejhHFjqRhqTQSIUrIPJqBwD/JtYinpWOEU9cwDa3AMsyF6A739at0ltuvX9qWnzMo/mUPBZ1vZc+3BEtTQe8C93ZPlnSIXtfeVr8Hi8TJLnEKdBe8gE5KmGJ3OSFTe3ugrpoqu0xF5KAN0KVDZtPKCu9ZUh1pwjuVoJaX7rzlUgPfbO9c9gKkMkQpEvBtYpkBF+4qdrZ2fVxTE5wpyr/Me1snOCpSLLkiHasfbhKiv5+qSyNX5yALmW7AZYHzRkd8BiEjCjh9t7mByHhfLPZPRdWbcZgINUuFYV2baUItamRJSk1JWwoEA1bIlPnY9UH9jSxgBZLQE7RSwBf3xwENDXE4Tk5FF4ZDtaAko+W5Z0X+jYLew1/8i8O/rljWc00qtOZaLQQkHPwX1FEjvNte5MxiD2DAZox63fd3P9YR4wJrag+OH8Xun1/Hxx9NPkTWWkDwg1MfpgAQBEe/RC27YHXFmMzd0wPIuO7SmFb/FqZ9z8gdfp7bCKfN09yj2cZjDDv4yJK7UXnLn/q29u6ewiNtpsHPKtBVeKWL+rr8CT+2P/mXrGJSS7Ga3IZis/sVtyN5ExEvRXEyIO3W05Za/BW
 wQ+dr7vK
 xj2yE09aDov52Kr+Hm4v7v8gb9+U1MIVZQ76Hlm3mrxvW8ikl+OIzFgh6hp3N0Kejnm/14L6R42P7RWpEeiCc3TN77o0mHRJ9JBvdG5fI1xJSoOtB3WnpyeyC2Ycu56wSEQahjqjLtCTYoLFF1tTqOTLmZjwlZjyz+mwas1xM4p2W6tZcg73pMKEdJYANRWfXP835sF7qRusG6e4kQkGiD5hgDLO0wbl5UYRmbHImTsFf3kO8FAmo/mPVl7Ev5ILZR4wSEPzvWsC+rrpknnPoJcCzgfZXLWpB9IE9rmetReOtplwxRVWk3ccsIfuycwYgWzy/jaNyukhfI23CkeLB9xLHtFdGa2jeqPkm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/locking/core]
[also build test WARNING on trace/for-next akpm-mm/mm-everything linus/master v7.0-rc3 next-20260310]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Have-futex-syscall-trace-event-show-specific-user-data/20260311-041422
base:   tip/locking/core
patch link:    https://lore.kernel.org/r/20260310201036.542627924%40kernel.org
patch subject: [PATCH v2 1/3] tracing: Have futex syscall trace event show specific user data
config: arc-randconfig-001-20260311 (https://download.01.org/0day-ci/archive/20260311/202603111911.zAWpiGlz-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260311/202603111911.zAWpiGlz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603111911.zAWpiGlz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/trace/trace_syscalls.c: In function 'syscall_get_futex':
>> kernel/trace/trace_syscalls.c:807:15: warning: variable 'buf' set but not used [-Wunused-but-set-variable]
     807 |         char *buf;
         |               ^~~


vim +/buf +807 kernel/trace/trace_syscalls.c

   801	
   802	static int
   803	syscall_get_futex(unsigned long *args, char **buffer, int *size, int buf_size)
   804	{
   805		struct syscall_user_buffer *sbuf;
   806		const char __user *ptr;
 > 807		char *buf;
   808	
   809		/* buf_size of zero means user doesn't want user space read */
   810		if (!buf_size)
   811			return -1;
   812	
   813		/* If the syscall_buffer is NULL, tracing is being shutdown */
   814		sbuf = READ_ONCE(syscall_buffer);
   815		if (!sbuf)
   816			return -1;
   817	
   818		ptr = (char __user *)args[0];
   819	
   820		*buffer = trace_user_fault_read(&sbuf->buf, ptr, 4, NULL, NULL);
   821		if (!*buffer)
   822			return -1;
   823	
   824		/* Add room for the value */
   825		*size += 4;
   826	
   827		buf = *buffer;
   828	
   829		return 0;
   830	}
   831	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

