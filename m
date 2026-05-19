Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C98CCD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 21:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E64E6B0005; Tue, 19 May 2026 17:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896AE6B0088; Tue, 19 May 2026 17:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785136B008A; Tue, 19 May 2026 17:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67A3F6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:11:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F4038C329E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:11:07 +0000 (UTC)
X-FDA: 84785414616.02.681ADDE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1888DA0011
	for <linux-mm@kvack.org>; Tue, 19 May 2026 21:11:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dC+wd7SB;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779225065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8dF+KpqIUAwrSm6ee5/0zglhOW+X1/lGzuDyA+Wovk=;
	b=l8Ao6vRK7kkmtatuiMzM4jAFY/ydnHMJr3jAm0zcxbvT6rEnRfcrY8aE2ySnCQTJg2p2ak
	f6qi3QkR2C+3OGvpdD5Fv95T+EfZEMtJosCe32mZvX4d++OUwjhsWrKd9v9+R2AJVu813N
	Ozc496KhVGc/SYyDBaflYEu6rhSXm2E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dC+wd7SB;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779225065; a=rsa-sha256;
	cv=none;
	b=DrPlaL3WMjmINIrylgZ/uBIkaIGknDPPcp1C0BcDq4L8EgkJ8LLn3k4Rm3Vg03LgcPXUnW
	ic1pBUfUtf+1RwfMjfw9WHbFG3iuQj+V3U3THd/JxdEhJ7TM/3K+oVgiOrO3mFA1g2CDeh
	c5O0DiuzIN9m0OPAXXzOuiz338cX3xg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779225065; x=1810761065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cQCETGmDqQbProNekXgVH2umQrcT5F2oaEv9arVNF68=;
  b=dC+wd7SBYUOHmdqj3AQ8O+nVihvmLad2aK/OUQ8iNFPMw1MVeFuZAUMg
   KJAtSax7boRmmwmelDDIT4HPDoWKi4mxQxr624SSZpPvrufCjwv2RYZd1
   xkVhqwJWAjhBr4DErkB/d0Y5km4XE8+nwwBQa+QTsP6b1+uMRHnK9+v+p
   xNmQwTfzjIMt6TuLNc/5KgemgIJsabEgwSiE0AEgdOqrjqDf0usgzyYvZ
   x+AHPfranHsFlwTYOl2HIVOP1ehbRdTzQnU6N6706jn4zWmQKmhI5tYXL
   6PqwCeThX3Ut6QRRsuMRNuKFRJH93aM9fhkCUt2qTgOnolZo921Sg37ZC
   g==;
X-CSE-ConnectionGUID: g4kFyhXMStWG4RrnqFmpqA==
X-CSE-MsgGUID: y8gD5FSYRRWEOOZg/TeHVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11791"; a="97547180"
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="97547180"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2026 14:11:03 -0700
X-CSE-ConnectionGUID: CoQjoB/NSAai3aCAu3qk8w==
X-CSE-MsgGUID: 4v0xHdqcT4SzGr1t9tjm7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,243,1770624000"; 
   d="scan'208";a="239949807"
Received: from lkp-server02.sh.intel.com (HELO 30e86e9c1927) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 19 May 2026 14:10:59 -0700
Received: from kbuild by 30e86e9c1927 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wPRhx-000000001v7-3iDF;
	Tue, 19 May 2026 21:10:44 +0000
Date: Wed, 20 May 2026 05:09:54 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
	bpf@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>, Jiri Olsa <olsajiri@gmail.com>
Subject: Re: [PATCH v5] tracing/eprobes: Allow use of BTF names to
 dereference pointers
Message-ID: <202605200427.0xXjKghz-lkp@intel.com>
References: <20260519130144.40e71a00@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519130144.40e71a00@fedora>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1888DA0011
X-Stat-Signature: 7iz6qwo8gaoekmr87gxua8mgw7aetdwd
X-HE-Tag: 1779225064-445933
X-HE-Meta: U2FsdGVkX19PRntUK8ivbyR65IACxyOZVmiheO1MrW/1PQKRnPIW/HWrvLpmAbMV+goqVEPEdhU4rUAdDMKONMaW2XbWHMZxtdoBwWxUnL1bzgzABAp5Ovqt4p5pFgpsvtJxHAViE6Pd8R/3nfFRqzELYEDdcJgQRHfAiuZeHYco+BuEcHsNSIg2DHipufNFfouBDHktYg78jKWn98ONzCYkpKxT+yGfLAr93zc1XLU9qASeUgos0OUJgZbSV6j4mdkLytxHQIVg5U/zLrmY1nuUPlzFEnOcT+wyPwW8Be0//VDBAmqKMM2mu//zt+ayGvnOPvLuIH8CCFgxnWe9oDxiPxnNm8yszC67LMsg3e+CYT5P+Oo/NJY7gdK4LsUONvGvZ8xp7+QkAUaE6O5SoKR+2EwMq6PhXHQnIzmxTJJJVJoxONXWqlb2YEy00hCerR1+jV7JkTm9ioSaBQ6pjgOiLuAsg6/vFlK2SiC3ZT1omkQ2P/JIQjQN9YfE1YogSk3OAwCHsWlpI6FATHBEbSEKL5on/SrKNKc5fw0mi6i+etF0ImxzWOfNMav4sflzthtW+db9ks6RJb0VdlV6QYJhyvX7jWTK+A66lwfj9SiOAhSb1QDwW9TIRvx5mhGeX0L0gFqshl3PEUk3ufo4C1EQuLE5bPipTS2uK/SEq9ESHfzF1gHH0rpPCr6G3eNqq41+v6BkCxFSOTH3WsBHjtmUOgQ9a0si++xabv+XLDJbHRYsFGumuWNu+UUza9tKDqiHGSaX2fi+4Mk2APaWpcolaX35yZJkhe59wQQ7qOoI+SBA+/AzI3o9vfrWMhjneY5EcNykgVJpGZ2i0lp5iYniYaQ4MOt+feLvk6/p2e4ImXNeqCVJrxsDTAZGobdlOEuhJDMX7xEj/Lxp8HlkO1XLxwxTjdta3Jqji9EN7Q02R8W9q460pdLvx01NQwKvHA06y5bEipG63+L0He1
 OIuTdb4i
 aWSZruxz+wuzzbbNybdPk6GKoacgY7ertPMGkk9oXdHpnLFfj5xkIX6khE1fp6JkIiNh+EQHRvTFR2WG4115xNlb08UhEmVrCn1MWpdhbvrGg00Z0ZJHkAR+iQwql/ybnZt8SFPyH56+RzhlvKdfa9ZYKP8sqotZXAxfKQ1Ki/tjLD4vvslymR4MRLiTz0SPYGV4uu0IE9jaM6nCHFpqpfXd9scBG8NMOIdFkSDnYsTM26CMICp/PNiLWdpmCVxh5lQNPhuxGVnoAxOajw0+VIPc0UpnSyj4dEG8OJSBg0CIoSN4eQTTNCzOpkP64xgzgjOL/vHhY+W3B7N90dc0m35Pqz9Ww6XxJD78p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[also build test ERROR on linus/master v7.1-rc4 next-20260519]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-eprobes-Allow-use-of-BTF-names-to-dereference-pointers/20260520-011353
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20260519130144.40e71a00%40fedora
patch subject: [PATCH v5] tracing/eprobes: Allow use of BTF names to dereference pointers
config: s390-randconfig-r071-20260520 (https://download.01.org/0day-ci/archive/20260520/202605200427.0xXjKghz-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
smatch: v0.5.0-9185-gbcc58b9c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260520/202605200427.0xXjKghz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605200427.0xXjKghz-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   kernel/trace/trace_probe.c: In function 'parse_probe_vars':
>> kernel/trace/trace_probe.c:1035:7: error: implicit declaration of function 'parse_trace_event'; did you mean 'parse_trace_event_arg'? [-Werror=implicit-function-declaration]
      if (parse_trace_event(arg, code, ctx) < 0)
          ^~~~~~~~~~~~~~~~~
          parse_trace_event_arg
   kernel/trace/trace_probe.c: In function 'sprint_nth_btf_arg':
>> kernel/trace/trace_probe.c:1803:20: error: implicit declaration of function 'ctx_btf' [-Werror=implicit-function-declaration]
     struct btf *btf = ctx_btf(ctx);
                       ^~~~~~~
>> kernel/trace/trace_probe.c:1803:20: warning: initialization of 'struct btf *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
   At top level:
>> kernel/trace/trace_probe.c:318:12: warning: 'parse_trace_event_arg' defined but not used [-Wunused-function]
    static int parse_trace_event_arg(char *arg, struct fetch_insn *code,
               ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +1035 kernel/trace/trace_probe.c

  1020	
  1021	/* Parse $vars. @orig_arg points '$', which syncs to @ctx->offset */
  1022	static int parse_probe_vars(char *orig_arg, const struct fetch_type *t,
  1023				    struct fetch_insn **pcode,
  1024				    struct fetch_insn *end,
  1025				    struct traceprobe_parse_context *ctx)
  1026	{
  1027		struct fetch_insn *code = *pcode;
  1028		int err = TP_ERR_BAD_VAR;
  1029		char *arg = orig_arg + 1;
  1030		unsigned long param;
  1031		int ret = 0;
  1032		int len;
  1033	
  1034		if (ctx->flags & TPARG_FL_TEVENT) {
> 1035			if (parse_trace_event(arg, code, ctx) < 0)
  1036				goto inval;
  1037			return 0;
  1038		}
  1039	
  1040		if (str_has_prefix(arg, "retval")) {
  1041			if (!(ctx->flags & TPARG_FL_RETURN)) {
  1042				err = TP_ERR_RETVAL_ON_PROBE;
  1043				goto inval;
  1044			}
  1045			if (!(ctx->flags & TPARG_FL_KERNEL) ||
  1046			    !IS_ENABLED(CONFIG_PROBE_EVENTS_BTF_ARGS)) {
  1047				code->op = FETCH_OP_RETVAL;
  1048				return 0;
  1049			}
  1050			return parse_btf_arg(orig_arg, pcode, end, ctx);
  1051		}
  1052	
  1053		len = str_has_prefix(arg, "stack");
  1054		if (len) {
  1055	
  1056			if (arg[len] == '\0') {
  1057				code->op = FETCH_OP_STACKP;
  1058				return 0;
  1059			}
  1060	
  1061			if (isdigit(arg[len])) {
  1062				ret = kstrtoul(arg + len, 10, &param);
  1063				if (ret)
  1064					goto inval;
  1065	
  1066				if ((ctx->flags & TPARG_FL_KERNEL) &&
  1067				    param > PARAM_MAX_STACK) {
  1068					err = TP_ERR_BAD_STACK_NUM;
  1069					goto inval;
  1070				}
  1071				code->op = FETCH_OP_STACK;
  1072				code->param = (unsigned int)param;
  1073				return 0;
  1074			}
  1075			goto inval;
  1076		}
  1077	
  1078		if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
  1079			code->op = FETCH_OP_COMM;
  1080			return 0;
  1081		}
  1082	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

