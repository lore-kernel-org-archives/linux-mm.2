Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B170606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=NaFJfyfF
Received: by kanga.kvack.org (Postfix)
	id 672B36B05B1; Sat,  7 Nov 2026 02:05:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BC86B05B2; Sat,  7 Nov 2026 02:05:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7106B05B3; Sat,  7 Nov 2026 02:05:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0A96B05B1
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:05:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAE1F1A02C6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:05:25 +0000 (UTC)
X-FDA: 85407437010.02.62F87A8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 194A380002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:05:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NaFJfyfF;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794035123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAwYNWjlqw18PRKfs0wfc6QMvEJ/l8q6K3xULLq/RJc=;
	b=TrfmQdgPuuVWIFoaqmYtn1JHUNZbMTmCjHg9UrNhenyxw49chm5V9NYpMHxrfbdlwZ+u1v
	KQLb6XOWO0au4WUNKezYO39ukoGbmJfTS8yf0seqthVOYlJwNWwPStmA9gyRG1bd+CYynw
	KyP7F8LC1yY28oIt4REOyT+6RmHROzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794035123;
	b=dg6ndW1XdQ0GqhfDy2Wrj+GCS5VWGY7JySpoXB62p4h7koUB6gLyF/5v6XqcOgLt5XS36A
	+QuQLDo8EZBwbOlrpzAgkdWC6sI5M5EEKXdhtUVSs5EwnfwetiUc71IlaZsV7C1TnGjQPg
	/t8hm2jW6reTeuWxy72a8dMk6KrpWWw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NaFJfyfF;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794035123; x=1825571123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MlHqtS8cT8ajIw/2dp1+/XcpibT8MY0x6er6vc3ClcU=;
  b=NaFJfyfFLQ8fVFchaFpMq8uorPi0StZdUbRASrKZTD2PdM5eV9dkoA0H
   wSkfjPZsd3eZkyKH9ZKXlj9/vif8MPkdGs6eHsyxQqAnpnanpQdHuWN4M
   31uM8GfgRs//Z4R3fqg7i+CxFbqDQ3gkvSDmI/BNbr4lW3Qm2BHfbKnDx
   h+JL4M46FbIjkNZS6/oTFPobBrDnNVqnchhrRAf2KUi7ATcRVi/aBXtif
   KKr8fisKzKKHScRVCPblJ7KNcYtGPaoWNbg3SxU/hTPPtSr1XgywpVAh8
   j/Q15Y5pX49vZjamqxkyetqcAVKYrFIvhNtix3pQRzOYsteCyrpnBqQe2
   A==;
X-CSE-ConnectionGUID: G0FbaHDEQg2VbaQR42QSTw==
X-CSE-MsgGUID: wWtBrhhNQnGcITn4seFXEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11958"; a="2734859"
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="2734859"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 23:05:22 -0800
X-CSE-ConnectionGUID: 9+2ftNMKQAqc50tJyR7fxg==
X-CSE-MsgGUID: pNt5NwnMSVqZrahXN4gQYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,200,1787036400"; 
   d="scan'208";a="7444739"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 06 Nov 2026 23:05:16 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xPaUC-00000000qZf-2cVD;
	Sat, 07 Nov 2026 07:05:12 +0000
Date: Sat, 7 Nov 2026 15:04:50 +0800
From: kernel test robot <lkp@intel.com>
To: Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, Alexandre Ghiti <alex@ghiti.fr>,
	Jesse Taube <jtaubepe@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Himanshu Chauhan <himanshu.chauhan@oss.qualcomm.com>
Subject: Re: [PATCH v8 3/8] riscv: add ptrace requests for hardware
 breakpoints
Message-ID: <202611071408.gyIRvq10-lkp@intel.com>
References: <20261107023917.40606-4-himanshu.chauhan@oss.qualcomm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107023917.40606-4-himanshu.chauhan@oss.qualcomm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 194A380002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tbishefjur1k9towdk67fze5ff6dg98k
X-Rspam-User: 
X-HE-Tag: 1794035122-360914
X-HE-Meta: U2FsdGVkX19/VGMByQK5M5r29NahWAKGIO8rOZpNAC84BViP+tqryN4lpGXq1FIkZKpP3zqm0rtnxXu+Whbyo5uv+oBoSyfqDP2ilAH7CmHTGnwS2zeZK9stcXrggoq3Zxi+63trGTaBbdURa6GwuI57xjZFFx9ONWSyjvqc9WYErKQWcs8UIuDKr/z0wqlQWNBmKZrSZk5ApOKfjmCtEDWzeh0nSjz9lFMf7UQu09GTLG+L4l15cDnVu0GFuD7wdPfKBXdbF4oCx6cIQjQgWksYm4cuINumQ4hrsaBlP7QY/X9ogx38ddsiNUsa1yO2BKYLvD11XiClHwx78SBvM5xA7zxELTKry/HhdKloz4ZW3wKoq5FzjnHtk5FUK4It0oMBwOX2ryItADeQPSLu+nPn5ZAtj9ESHHcrB39gB3xR6NbJQlgWJO2gpdh+ZaDJ/sq1Npzt+DCKQQOKEbZ2CtEaGO6OoUdguKpW+Bx/qdkrvNgoD3ZA2cAOlq/OZ2bvfSeOVYj8bF8Xs+3AIpmzpJoL+vH8VV7w4d/fTx9Y1PmO/p0RuH3lhTKI4hyt97KD2WcGqw/f0fIptgDaBTI5kH/di9opKA93jB2rnFAbyB10wx3jcW2j+fvLco+DmskuuJHvBEa6RJ5f3C1EJIV4JBn0EIxKNQZ22HtSEkhXbvSzbmDz5suhEBlbmFcBJwM1W0A/tEZ2fMI3skquaos4FSbdUFNNqzvf5cZGS1sRTXI1egw84Ho37Yk84/r4/Zcf1vYooDH0mtcY0GvZNqWerAxb/Em7zlMB1TFuFTgr6Bf15IDroofkvofIHEXQtnTVZvGS7DRvQJD6Y3YvyCkjFrhWu9rERddwIKpPHet64ceZN0SxFQ8j/gPEruQ3imnBgiSqZCJ1eLRepSLqOyfUt5Wrg+lLt1S9jKQxt6poSxGcbk+s6cIAJL1LSdDoSNXuvud08g4mPA6l7tkSf0f
 +/Im4IZT
 Alq/BJPtY+Ysvzqzrbern3cuonzd+eEwZHCO0hpArY6DJMwrM3k4+ybXC7hi5AeXvoS36tz7yCzcuPEd4zqJuA6wEzRaKBByfhSi8+NRtoRomsEMnB5eLNlWebqHjwrSPtN6WBl1AZLQL9pqT2VXgpy15wz8xsqpP+pWpEKo88slo34xFf1avg4/QQFldj02ZEB0VGjAmAmHuYG0d6CFIpTS/CAyQcLvJY+Nui0idWr+jPEnZcUzh2cbWgig6iYYphYG1DLu3z4w5F6QbI5Bkqoc7gFjjbDO6Yx0IwGgeohSC/MIBOTfG/KJP+nGiYyiyGBDcmyrfO3blQp4Dn+aHYTWR1K5HmfmaSfYdcyTZJHxDCFCHXJ+Mk0WIt7+dNYhCDp8G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Himanshu,

kernel test robot noticed the following build errors:

[auto build test ERROR on shuah-kselftest/next]
[also build test ERROR on shuah-kselftest/fixes perf-tools-next/perf-tools-next linus/master v7.4-rc1 next-20261105]
[cannot apply to kees/for-next/execve tip/perf/core perf-tools/perf-tools acme/perf/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Himanshu-Chauhan/riscv-Introduce-support-for-hardware-break-watchpoints/20261107-080910
base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
patch link:    https://lore.kernel.org/r/20261107023917.40606-4-himanshu.chauhan%40oss.qualcomm.com
patch subject: [PATCH v8 3/8] riscv: add ptrace requests for hardware breakpoints
config: riscv-allnoconfig (https://download.01.org/0day-ci/archive/20261107/202611071408.gyIRvq10-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261107/202611071408.gyIRvq10-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611071408.gyIRvq10-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from kernel/exit.c:57:
>> include/linux/hw_breakpoint.h:137:20: error: redefinition of 'flush_ptrace_hw_breakpoint'
     137 | static inline void flush_ptrace_hw_breakpoint(struct task_struct *tsk)  { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/riscv/include/asm/processor.h:18,
                    from arch/riscv/include/asm/cmpxchg.h:16,
                    from arch/riscv/include/asm/barrier.h:14,
                    from include/asm-generic/bitops/generic-non-atomic.h:7,
                    from include/linux/bitops.h:28,
                    from include/linux/thread_info.h:27,
                    from include/asm-generic/preempt.h:5,
                    from ./arch/riscv/include/generated/asm/preempt.h:1,
                    from include/linux/preempt.h:107,
                    from include/linux/spinlock.h:56,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from kernel/exit.c:8:
   arch/riscv/include/asm/hw_breakpoint.h:58:20: note: previous definition of 'flush_ptrace_hw_breakpoint' with type 'void(struct task_struct *)'
      58 | static inline void flush_ptrace_hw_breakpoint(struct task_struct *task) { }
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/flush_ptrace_hw_breakpoint +137 include/linux/hw_breakpoint.h

24f1e32c60c45c include/linux/hw_breakpoint.h       Frederic Weisbecker 2009-09-09  136  
24f1e32c60c45c include/linux/hw_breakpoint.h       Frederic Weisbecker 2009-09-09 @137  static inline void flush_ptrace_hw_breakpoint(struct task_struct *tsk)	{ }
b332828c39326b include/asm-generic/hw_breakpoint.h K.Prasad            2009-06-01  138  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

