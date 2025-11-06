Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F216FCCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 15:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7618E0006; Thu,  6 Nov 2025 10:29:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF058E0002; Thu,  6 Nov 2025 10:29:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077CA8E0006; Thu,  6 Nov 2025 10:29:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E93A78E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:29:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77765C0162
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:29:35 +0000 (UTC)
X-FDA: 84080566710.30.1BEA191
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89B661A000A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 15:29:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kDMOYGXp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762442973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hZB5qA4NvpnshTBQfqKkEi7vu8L2pmkh2xYQ3MMNTjo=;
	b=C/gwoGaqAX+PkMYsHqMpFcY1fywvZOI1q8ZtGGNdGXONZNeh8uwpLuOPJoOlYGVnHkQHsm
	vwSftY8nV80A5Mnl00k+7N/GA4gSDn7H7XwCSN3A6AK8J3be/L8wJMtSLpj8gctmsg79ZO
	n/JOjXlOmDrmi1QtM62yK3Esy/umQTw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kDMOYGXp;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762442973; a=rsa-sha256;
	cv=none;
	b=0onPb/UEdmKcsWU1e2nGxDpFmgvaLbgrgwsOZFJ7vOGydcWXPhXziiATlbel/M1CDqiQ25
	tFPQOeHzb1Y6cfa0ZTIBe9dC+o3LXas7ekC4uGhZ9elRhA19EYPOLqeJjvPBewFom41R0m
	amWISLvzSbFZSdAwieSxyJQLYfZRV7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762442973; x=1793978973;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fy5kb+xSEe8CuLReHJSiSgwCvjIGVD2dswSaWqR9TqU=;
  b=kDMOYGXpPoLpNOyuYGOmPmdsNCQ4aA7dMfZakNlwKjY2iatlELSg7Edz
   rKdHfofdqoE/IZ0pn/GFOYHADrkZtYXcvAtScVFiOAkxSQjv3dPn+W+0F
   iFKEF17a1hIVqbrcrvPRUiOB3fExKLrJZFJKV+VDMrB7LnMIDmkzwPsfJ
   Oyss3pPaOHyHVz/ANMq7FGhrvtFi7v7I5XbN3lUGpbAi0vYJM2vlz2y4M
   HFW3la4qXgmLiD7hHXtzAAa1k4pcUJGPn0ZKzlXZosP9aEptemSm/QDsT
   R/Ij+ZcM2HsBj7q3B1bRzoU/vidrQ4XVVkAOwyvi97N7KIIfyJ1smM17x
   g==;
X-CSE-ConnectionGUID: UDDtu0piSySrqz4P8z9fiQ==
X-CSE-MsgGUID: xnYYDzC5RMyVc9s/OGGklQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="76031393"
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="76031393"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2025 07:29:31 -0800
X-CSE-ConnectionGUID: sZfJMlAgRIG2UQxuqDCZKQ==
X-CSE-MsgGUID: Sny0jVoXSGuME85WdEfqVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,284,1754982000"; 
   d="scan'208";a="188502501"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 06 Nov 2025 07:29:28 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vH1vS-000U5A-0r;
	Thu, 06 Nov 2025 15:29:26 +0000
Date: Thu, 6 Nov 2025 23:29:25 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] tracing: Have tracer option be instance specific
Message-ID: <202511062257.TSJTBQ2c-lkp@intel.com>
References: <20251105161935.545400234@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105161935.545400234@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 89B661A000A
X-Stat-Signature: hxwkw9j16bgbfrh6ybusp3qx4jqwyned
X-Rspam-User: 
X-HE-Tag: 1762442972-356671
X-HE-Meta: U2FsdGVkX1+WvtDFMPhJaVDSZ0/BDAXxWK351+nU++MyPf425WsN083JjbfyXQJr5xGUVLMpq313M3FSZO6GpXiky1KocUVg+PlEF1kFa4Ri6/EDjdWbzhjmnDU0XyKLLRx5e0vmXSezXtajp+QgoFkv2Q0/pDOLTkuU0eRj+6zIrenWeHbZnY37p6kqroIwu36Kr0/Xxp7QJC2nlCrgSLscVwn7aP+f0UWD6KAAyNDD3jR+thUl42LeBqFiV+IPu0mlIO9s4ICjE2Q6B7Z0Mu9Rm2gjXXNuPDnF4l3JxFxUR4lPgznc2oCDAh68qNrid2G+M2vHC/6EQSb1/LSe+ppQW4cehNHtNVQyjtSqPodg7dmgc2D3G6jAM37jfl8fPrs/zRo+Rx/hm9Ij0Oywq8+O6oBA3EPSRKIn20yT/ebYtcvVLKtCQ9ygK7Rvwp8avXJdN2xcgIG9UhsBcM+DMDtWK35UUB+tvtKx7Ne6QFPxVaqxVkr3X9EQ1TtVsk5ECcxrzyqC1y+uzW6m8rJFbPnkzvo6J008lASlEI4LmYq4jXbYJYuVzR6mmuUQz0l4AXKR3O3sA08O6ZVoS+d82k1FNy5rq9UjtOPZcz7W3yzXYiixNsZDn5jbtWdLCUDL9f/ecPHEvn9cACFLYE5YJEgTIPMwNa4ZeTIj+v+qinUE7M3n1gfvui/YU37RXzpIidFyjyHRIWsomVOsyyzXnQYs+U8FNcSMJxP8gpZlJFm43M8vvEleaJU67Ec5qrHQvb+Y560/GTw+/BG/xudne9QoRMuIA5r3qcng8NUrpL3zfArt6UD860y0PpdSiSOew6pETrrMpSyMvN5ruSIngX0BOefMq9Cz3kZoFBBB82XLVK50sUD42E9ZCz+/b4suXZKprJlONukkP5IwtH/DFbs+SDFjUJ3s0YSXm4Mr/f3C432GwuofCXz0dStFKiit0SnVSLg7rcbeJEEWyHI
 2OtQ65hU
 pfEokBASPcKRI5uvFlkrcoCiMxyEPCDEmy1kMiRISN59i8Qawffi7PuMHGlkUNck/ZY9DsKYh3lOlpdHVNnX1rRvVfQBv/nt0d29+zqXlob41GNDXG/cRDefIOE7U9qPVyhSxz25N5e9z9Kt9URvJlf5V23OP8fUvRmS2tSjIseGV/QwgpkZwYCbL5NakaVXLAKMCri7hxtHETx0gmb+YSbRRcpzTgXJUdPgm0s9kGYkaLdAM3laGNsfUO+jf69rSAUa4xNtSQ3YlAocI7azsLc7aZlIXQrP0EgHkoPH2Pu9Vu113yqnqoCOAupW+J/GXouPZhz/IuoqsA6Y3p2MwBMVOhyz5Rkp6CFjN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build errors:

[auto build test ERROR on trace/for-next]
[cannot apply to linus/master v6.18-rc4 next-20251106]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Remove-dummy-options-and-flags/20251106-010511
base:   https://git.kernel.org/pub/scm/linux/kernel/git/trace/linux-trace for-next
patch link:    https://lore.kernel.org/r/20251105161935.545400234%40kernel.org
patch subject: [PATCH 3/5] tracing: Have tracer option be instance specific
config: i386-buildonly-randconfig-004-20251106 (https://download.01.org/0day-ci/archive/20251106/202511062257.TSJTBQ2c-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251106/202511062257.TSJTBQ2c-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511062257.TSJTBQ2c-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/trace/trace.c:2174:23: error: redefinition of 'type' with a different type: 'struct trace_tracer *' vs 'struct tracer *'
    2174 |         struct trace_tracer *type = tracers->trace;
         |                              ^
   kernel/trace/trace.c:2171:47: note: previous definition is here
    2171 | static int run_tracer_selftest(struct tracer *type)
         |                                               ^
>> kernel/trace/trace.c:2174:30: error: use of undeclared identifier 'tracers'
    2174 |         struct trace_tracer *type = tracers->trace;
         |                                     ^
   kernel/trace/trace.c:5172:17: warning: variable 'trace' set but not used [-Wunused-but-set-variable]
    5172 |         struct tracer *trace;
         |                        ^
   1 warning and 2 errors generated.


vim +2174 kernel/trace/trace.c

  2170	
  2171	static int run_tracer_selftest(struct tracer *type)
  2172	{
  2173		struct trace_array *tr = &global_trace;
> 2174		struct trace_tracer *type = tracers->trace;
  2175		struct tracer_flags *saved_flags = tr->current_trace_flags;
  2176		struct tracer_flags *flags;
  2177		struct tracer *saved_tracer = tr->current_trace;
  2178		int ret;
  2179	
  2180		if (!type->selftest || tracing_selftest_disabled)
  2181			return 0;
  2182	
  2183		/*
  2184		 * If a tracer registers early in boot up (before scheduling is
  2185		 * initialized and such), then do not run its selftests yet.
  2186		 * Instead, run it a little later in the boot process.
  2187		 */
  2188		if (!selftests_can_run)
  2189			return save_selftest(type);
  2190	
  2191		if (!tracing_is_on()) {
  2192			pr_warn("Selftest for tracer %s skipped due to tracing disabled\n",
  2193				type->name);
  2194			return 0;
  2195		}
  2196	
  2197		/*
  2198		 * Run a selftest on this tracer.
  2199		 * Here we reset the trace buffer, and set the current
  2200		 * tracer to be this tracer. The tracer can then run some
  2201		 * internal tracing to verify that everything is in order.
  2202		 * If we fail, we do not register this tracer.
  2203		 */
  2204		tracing_reset_online_cpus(&tr->array_buffer);
  2205	
  2206		tr->current_trace = type;
  2207		tr->current_trace_flags = type->flags ? : type->default_flags;
  2208	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

