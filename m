Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A88CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DDC6B008A; Fri, 16 Oct 2026 00:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36AE6B008C; Fri, 16 Oct 2026 00:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D50A76B0092; Fri, 16 Oct 2026 00:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC2196B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:54:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36C371C1CBD
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:54:54 +0000 (UTC)
X-FDA: 85327274508.21.EF72EA9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 85746C0002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:54:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ElD8lw4N;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792126492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ne/5WaLVSOHVZt6qpQeMQ/aidKbskmmj8ndh+EFrKr4=;
	b=sJHGITQWpW5Ju/KwdFpfacGpr64tfnpvGtrnjiL3yZT235olhc/4Kwdjh5yiFHorF/W5gs
	1Rlh7X3XiogrkAhsjK9in+GrN0hDpT7f8YlxinIf8DlXLbM2vnFWaKAoOf5n2GrXQl090q
	7lhsmyU6IYik4Y4FIrjJPAfqQuboX0U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ElD8lw4N;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792126492;
	b=wHE6SPM4xFnRBTvLjQtGWIdcASzZZ8IF2gr+cqIH1aN4GA6SRR11AYiJY2ilk0oszmFP1t
	1A3JMg7AzIhdofA3Z8/GFCgJqmPyAuk+uyktYJyiymYHWX0v5Y4wCEIG0qAxTv3URp4b7T
	Ou8dX+4SC3xp88QIcrfhkybFIZT4vB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792126492; x=1823662492;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vMokfa1+hvgywCpz3ofj3oYp/nbYqpRWvALkC8ki2hY=;
  b=ElD8lw4N6oL6JpK8Q577BGUJG+5joQJR4TcFKtiX3RPwlnn6Ej6IMFLw
   hY0yrxqrTPrJGUOq9B80s1FrDXPuf8hQFeSXedNLsum/57BxMV4IFDWoV
   M6qQnCMs5wNQZ2fpC7OTU5tFGUqfS9sVdbJ9HR7s6aVSdk6bsRl829XjN
   tKuCv6oQ0yilW2QUZ859AMcVrYzWNxVJzjd25oKAg4FDKik0PjC+XTSE/
   BCXtPQWfVK9DtfEw1MM48xW+8o7EBNV0wJ9IF+nUpzJO3kYO0JRRlW71o
   OVxeKbojoKGSd/D2Ia9RqeToJtL6lLEXG261exJiNIB7yW6SS9gkChPLi
   Q==;
X-CSE-ConnectionGUID: 1eIyutBkTMmGUKq++yjhKA==
X-CSE-MsgGUID: 5T5649ajTDW1jxNHLnxJrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11936"; a="918825"
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="918825"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2026 21:54:50 -0700
X-CSE-ConnectionGUID: REJ6z22YRraItSUsrmmjZQ==
X-CSE-MsgGUID: F81ihg6QT2itneTire3loQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,161,1787036400"; 
   d="scan'208";a="1843240"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 15 Oct 2026 21:54:47 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHZxs-00000000Hcs-078R;
	Fri, 16 Oct 2026 04:54:44 +0000
Date: Fri, 16 Oct 2026 12:54:18 +0800
From: kernel test robot <lkp@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <kees@kernel.org>, Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tycho Andersen <tycho@tycho.pizza>,
	Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v3 2/2] kallsyms: Don't leak pointers for unresolved
 symbols
Message-ID: <202610161209.43Dqkd4l-lkp@intel.com>
References: <20261015-vsprintf_kallsym-v3-2-c175c27f38b7@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-vsprintf_kallsym-v3-2-c175c27f38b7@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85746C0002
X-Stat-Signature: xwuuhpr39qedz3itkgioks8y1tckmr7c
X-HE-Tag: 1792126491-156598
X-HE-Meta: U2FsdGVkX1/Xdkb1jcruxswL8EX5ibSdcmtQ2KBvmu0xwdy8d26rXOoWWDW/L43kfYwEXXvEuuprY5hGMgQQlXMWvH5eN0qPtLRCqCiMtGFmSKe881ZdXwvnEiGPGkXK8Nnztpyk90DlfK1IV/QOSEk6hRWxkUaptbDO9Sjgx6kzd3EuoG9OqmxykQaezhkixm5tFMAupZPuk4kKPi6pmamwf6z8rL5D9+91vDxbf48m5/QrHTrEEjzJxaYM976re8J17Ym+8njPa+KnnLPT82lGyNQhLkXiwW3FX7lL4Vf9qEGMh2vhZady0bbHTG10k/r+eqi6scP0TTlpIMGNvRBpjIiDI4jLnQFbCYJdZTzEDyb8CrwEMm/JlDLYvhETnSrZ0cYQBEMJd6lpPPFnaPaofWAcPTD78VrpAcgAr/kOjBbNfTHQA6tRHw+Ik/8EDrDfzCfIUs+Lsk7v1qGqwnZkj9Gy1s2L8HmgMxJvBsNssRKcVFNzciYmqzcCxsNGvNuuF0K9QGLzLXeT2XmJiWLrvCYl8dWL+lRQGyGY8kvasI7WfOUFNPlAgjRZ25dhRhjS0qDkQSra5s6fXghVk86F/Juxme113n2BTbUXkDpbQdG6bSQfXWf2d7Udt9N8YU1PTLrIZcHYM+f8kHmGrA9X219O5j6rilVJEdnM3hAVvuIT1Cm/NX2PTq69mesx8n9nCLCgBD/WVhJXg7bRI0Pk0SY2twtUXg48ZI2VP3y09JLdBMOWWkGGNupUpMLokixYxv2JWzScKqoOkal1x8cclEdDI0FpHKCw/l0Hbe43WxQW9MzXux9ysOQh8pxNjxPmVDE3lKtfLZpnfgfAPzrJerZaXi8KVKtO83nDKUqpg3tbUC2GTBscOodRzWa+y5W7v0vz3BGeaXSHSC1CPDTP9B1w5bw+UZxPwNaczOecaHdlyFtSt2uC9wzhqZWFFC4UXc2xgL1RUnG5X94
 N3EdSW8F
 j9hzM37Cb0SwzKGFy1Rnps0+9oP/MrBG0KQsyUaKIbN9TKQyCCKEhdklxBQ3MN7c96rbHB2VkaAB3eJDFOtfmbaou/SHN7H44fWoQteXOE1sq1Cu+oPgfCTElVphICW3t8z3ZnvufzFUnc2b1ODA2mUTy/NV2K0zkVGsXxdmQ3xUneIC0gQW5YG4iUQuqMQEqf86o3nJZXj+yIujnrCZUdqIcGzOe8IGKMv+Yd/LZk4wZ83K3IQ+vaxf2A8I6H/9SLjyTuWCERunWvTCmIgQiTFgiUYeIxhakXxj/qKNAD8ZsMguAcEUojrbgmP+o+PelJDH5ZlIeXJ9cQzk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sebastian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ec8bf8280261294a9b9b4520414b42704c7f9f6b]

url:    https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/vsprintf-Don-t-leak-pointers-for-ps-without-KALLSYMS-enabled/20261015-180648
base:   ec8bf8280261294a9b9b4520414b42704c7f9f6b
patch link:    https://lore.kernel.org/r/20261015-vsprintf_kallsym-v3-2-c175c27f38b7%40linutronix.de
patch subject: [PATCH v3 2/2] kallsyms: Don't leak pointers for unresolved symbols
config: openrisc-defconfig (https://download.01.org/0day-ci/archive/20261016/202610161209.43Dqkd4l-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261016/202610161209.43Dqkd4l-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610161209.43Dqkd4l-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/vsprintf.c:863 function parameter 'len' not described in 'snprintf_default_pointer'
>> Warning: lib/vsprintf.c:863 Excess function parameter 'size' description in 'snprintf_default_pointer'
>> Warning: lib/vsprintf.c:863 function parameter 'len' not described in 'snprintf_default_pointer'
>> Warning: lib/vsprintf.c:863 Excess function parameter 'size' description in 'snprintf_default_pointer'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

