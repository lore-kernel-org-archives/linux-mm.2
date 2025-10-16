Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB64CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF32C8E0016; Thu, 16 Oct 2025 07:07:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2E38E0003; Thu, 16 Oct 2025 07:07:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91978E0016; Thu, 16 Oct 2025 07:07:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C29B98E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:07:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68F6F58359
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:07:59 +0000 (UTC)
X-FDA: 84003702678.24.2322FC6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2420CC0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:07:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oI3KR1/Z";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760612877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sdQ9RHb7v7NNLdjW+oTREdHZ4KKafpNrMj5Dc8vh2Fk=;
	b=ezWsdLucfP722Xj/0nbLuYVOxbkALuHOq6Pl32fTkysuvdrNwUF9fZkoEooczJ8zxi9WSh
	twlq/XZVCumeh5pLotxf0S5Etpbl3KvgAnZKHcSx90hcXFT1wG2atthWdxNcG/TpAzZDf8
	efQHoIS4FmddnT4ro4hRFioRay5PM7E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oI3KR1/Z";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760612877; a=rsa-sha256;
	cv=none;
	b=s7DiPvd5oz3gKqyd2F8QGG3HROrV9sQjQAcI9DDRqDiZEvZzqsBa0vcTrf1aWgDiwu+NTx
	HR4DKPdVQ3tEN43uFFt+Fh7jH+TqwgLwQEghx+K6Hw7SgW0EfKs9Mc+BcLS0mzLlAzCdcs
	l7XfLE5M3YKs1Mj+OkCzB3uHiK9JrRI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760612877; x=1792148877;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X9aFNc43N2mIzbQN88dQuc9eSgi7CWull+Rn9afMSbY=;
  b=oI3KR1/ZBJ7uP75OvV8dZ2UCkewBMeJLlVOlKn2N/NUzUw52SXTg/bH0
   wNOyFc4B/DWeTgqcnfK2u+w/8tSxdOKgOEwG7EfJiBJTtnEH+B5KYX7y+
   RMXjno21Kv9CCs17MRNHZKMlOKsCznDCn1lEu5Mv7zyYmQ4k1R+grBqMo
   t7GPm3UKRE186IbD6zVEhUtCspYRYnexMFWXnrYWqd4iZGLl4Mol0vqW8
   G07clOxG2haO92xHAVZoV0MWm9NQBR9X7Yeq+isjO8UJhUATTZUjsDNsP
   5yE0Ru+0I2u/G7GUJpWkgF7wjXQiqsbf5JVYKhCeWkY7t5a0E66zz55sF
   Q==;
X-CSE-ConnectionGUID: c04vRDeZQniXY/bS+3WdlQ==
X-CSE-MsgGUID: WfezB8z2Q5mww8Iik1LOAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62011187"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62011187"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 04:07:55 -0700
X-CSE-ConnectionGUID: ci2VY5XdR1OYxkSl6SuILg==
X-CSE-MsgGUID: +Wi3BTgZSgu3rjkmdKn1pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="181557081"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 16 Oct 2025 04:07:48 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9Lox-0004jL-1a;
	Thu, 16 Oct 2025 11:07:17 +0000
Date: Thu, 16 Oct 2025 19:05:27 +0800
From: kernel test robot <lkp@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Takaya Saeki <takayas@google.com>, Tom Zanussi <zanussi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ian Rogers <irogers@google.com>,
	Douglas Raillard <douglas.raillard@arm.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 03/13] perf: tracing: Simplify
 perf_sysenter_enable/disable() with guards
Message-ID: <202510161858.5hz4HLnc-lkp@intel.com>
References: <20251015173548.540984239@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015173548.540984239@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2420CC0002
X-Stat-Signature: e3xsrp1amzs389jxnkoqy4o3bg5c63qj
X-Rspam-User: 
X-HE-Tag: 1760612876-692225
X-HE-Meta: U2FsdGVkX18etIKovvHfEj2NzVtkrWlxVMDql2pOxDaz0GuWyi5KcgfMt+fBTbsdkTv7qPI/T/78pg2ZI3CwduV8p112nZCDrZXSKXOV0ZAMz84nidZx0ripqIqTzUhZNC/qkN85CHP/V/SJ3U6EOcMDrf6O9TL0xm+Xj4sgzOSrMupX/BpCl51rmuKHTFxItEaFCCjWMEHtaKq2Qlq8igAH2doUrPDc+v1/HMYGmNW8Crf1WPBdNZhUBT/w94afgauYbdx7wywLlR/aI/22Sqv3dZM7uZD6EMHyVztEUtdIaXQqVT7ky1C7J2sscLoDBNFBjDHdmWl+D0w3cvLRCs1LVRbT9jIRHtuEtk9uz914xkQV/SGP/jZK00Hi5WtOVcXQkmpna0rPQlXccHWkXvtAHCpu6GJ+uM0PPKFRo+veAjnqufDYNXZvVZB7Uta+JTVtGH92G7hoXjfPnS6bkgSlkzmx3jBIJjRIz9hqUDgX1rW9g+Rgy5HTjYsm7T1bu81OGA+vepoe4tIaUeszdIzgdm+3j123JkaYrKe18kjPUboW3J2XCT8i+6hJp8JW66BVYU9PiVdpekgyN7xzmx6Z2XsSYoEgDHBBnnANdkOvqUe87xfkRFZHqJfYhQARyCyqwqFXxuAth/Iqv+6j9tk8WnSg79rRoTNPWOlFK0n+obWzkilYABPzb0YjISyxiNZr5BlKVAGxMdiplUf4J9uFpnAYVCl16rdJGcu6elBTsWr49q2dsxLmdyhyCT9TVsjOzf74MXu+nuEDceZ2+f5W3+NtaLUwLuTzezi+HMofBO79/g0YcjKagMCD3RUh93VrSt+hidACY56HB3UprsQZzEuD123PkO7FwAxNOvAOACYm6xPTIghN261936uQr46euxn7MWb2aYjCowe20ZZHArVmY6tDUuEhwst2/Jk4oRDYzJxINNFtd10xUA5+velJBAD9FxUMVZcYBp5
 S85Ai73d
 a1bLFjfhSkNvMzY0/NFBWZKOWIYT8UekOhT1Em9FAqrjBEYA7ERAzKOes7BNBBRaNr2dkWaq+eNVA8w3h2KyxVrxPU5ZAKSxa/+dHNxx74XkfqpRvok0j3JLUWFohB1d5V1heVR+qVy+mZunVtbNrTcH3pNvnIhmQxIxcgJqrvSO+13fAP/8CenP6xuMbGRKzETrWmvauK89IYxI2n3FIqGQDKmmFORFMeT9nrzZeRM+CRkrZ01/EBhfE1aA913JBgFiiiCc2eNLomHIP6PMUcYCQVaEmC2j21/Rbwgbm+72PpUmcYnApZ28xe1XwOnKWDf9GmDesFo45HuDB/4v1eK4Aom74Cb3vtax+ZLgDMV7n9fFO4tpAtf6bUg1UEy/Hk/H8CGElAorFs1Nrc2sOvuXUsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Steven,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc1 next-20251015]
[cannot apply to trace/for-next acme/perf/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Rostedt/tracing-Make-trace_user_fault_read-exposed-to-rest-of-tracing/20251016-014059
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251015173548.540984239%40kernel.org
patch subject: [PATCH v3 03/13] perf: tracing: Simplify perf_sysenter_enable/disable() with guards
config: x86_64-randconfig-r073-20251016 (https://download.01.org/0day-ci/archive/20251016/202510161858.5hz4HLnc-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161858.5hz4HLnc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161858.5hz4HLnc-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/trace/trace_syscalls.c:1018:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    1018 |         if (!sys_perf_refcount_enter) {
         |             ^~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace_syscalls.c:1027:9: note: uninitialized use occurs here
    1027 |         return ret;
         |                ^~~
   kernel/trace/trace_syscalls.c:1018:2: note: remove the 'if' if its condition is always true
    1018 |         if (!sys_perf_refcount_enter) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace_syscalls.c:1012:9: note: initialize the variable 'ret' to silence this warning
    1012 |         int ret;
         |                ^
         |                 = 0
   kernel/trace/trace_syscalls.c:1123:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    1123 |         if (!sys_perf_refcount_exit) {
         |             ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace_syscalls.c:1132:9: note: uninitialized use occurs here
    1132 |         return ret;
         |                ^~~
   kernel/trace/trace_syscalls.c:1123:2: note: remove the 'if' if its condition is always true
    1123 |         if (!sys_perf_refcount_exit) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/trace/trace_syscalls.c:1117:9: note: initialize the variable 'ret' to silence this warning
    1117 |         int ret;
         |                ^
         |                 = 0
   2 warnings generated.


vim +1018 kernel/trace/trace_syscalls.c

  1009	
  1010	static int perf_sysenter_enable(struct trace_event_call *call)
  1011	{
  1012		int ret;
  1013		int num;
  1014	
  1015		num = ((struct syscall_metadata *)call->data)->syscall_nr;
  1016	
  1017		guard(mutex)(&syscall_trace_lock);
> 1018		if (!sys_perf_refcount_enter) {
  1019			ret = register_trace_sys_enter(perf_syscall_enter, NULL);
  1020			if (ret) {
  1021				pr_info("event trace: Could not activate syscall entry trace point");
  1022				return ret;
  1023			}
  1024		}
  1025		set_bit(num, enabled_perf_enter_syscalls);
  1026		sys_perf_refcount_enter++;
  1027		return ret;
  1028	}
  1029	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

