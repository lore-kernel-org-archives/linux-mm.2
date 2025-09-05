Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F084DCA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 16:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE2A6B0010; Fri,  5 Sep 2025 12:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27F346B0011; Fri,  5 Sep 2025 12:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E606B0012; Fri,  5 Sep 2025 12:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 045B16B0010
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:18:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4B9F1A0313
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:18:47 +0000 (UTC)
X-FDA: 83855705094.24.31AFE5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id BFA4A40009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:18:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KNJUIYsW;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757089125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF+7edAWItVoQ8dK/tjajfpamEWIGwIcYI0wVorBf+8=;
	b=uG5d6us9nIDGQwsoekd79jsVi2wZFEAE+oAcuWL7cDR1184WIJHAPakAi9mrM4OtndydVw
	iCrOFNSSDjYwtfAptsHNk5Msk5BpkNHnW4RCpj9B6Yxln3qperhFI2Kd9jdVzy9eyDMXF4
	uImncIi0TU+WdvFjGiotmaxQovIOMZ4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KNJUIYsW;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757089125; a=rsa-sha256;
	cv=none;
	b=IblYCv9T6NEw8NcdKdq85b/czXPjRdvH06pck1khnYgPzjQrdWLpL1HDYoE1Yj6UBgpC90
	VUyzQsVDXfw/A0CnWCxDUsQ5f6UPC4TAW5s7JFP0NudiSXF9hhPtjYlf8RmM0pgBgdZXnj
	2z6hU8J+7IV2+R4ixOUlKb9wkhthTy4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757089125; x=1788625125;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ehK6v8309NAGVNpv3YQq74SGs25kaSg5kTmdvmyAT68=;
  b=KNJUIYsW+efiB9eHBVBB1B27Rfpf4VlcgHR5jSD1ARQyWXDQl+XecKhh
   4JtE0Y3LMYIi53ydshKXmiTwelKcXbewD6b8zyh1Ys7Qb7aVCZqkH9Iy+
   ZTWxlz+HagBWN7ph9LE5jLnNHZccJaf5vjHBwY7FWkUX5QeRPVcRHJu6W
   culBZEMJwaLwS5nVIwhCEDMZ1y9nnGhc3MAg5HSpv9xq5caRaDgkSO/JA
   zgJE37OZGYZ9NGWPxYQVGBW7bSAN0fX/Y9WUz/eE4lNMQ7PG+UK0bvpN3
   iRnOsoNjCFGhRyhD38uksVMguoemtEjNajuie8C+KMwkGrO3SrKLUAXZK
   g==;
X-CSE-ConnectionGUID: ESVuWefZT0S4B+AJHJw8TA==
X-CSE-MsgGUID: 0c9KtynSQzCYNGyB2JV6Pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11544"; a="70062403"
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="70062403"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2025 09:18:43 -0700
X-CSE-ConnectionGUID: Z6FviSNcQaiHuPqeR2e2Vg==
X-CSE-MsgGUID: 0E2/mkFAQQu9I0wc4t+Uwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,241,1751266800"; 
   d="scan'208";a="176537467"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 05 Sep 2025 09:18:36 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuZ8z-0000c3-2A;
	Fri, 05 Sep 2025 16:18:33 +0000
Date: Sat, 6 Sep 2025 00:18:20 +0800
From: kernel test robot <lkp@intel.com>
To: Jinchao Wang <wangjinchao600@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: Re: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent
 hw_breakpoint_modify_local()
Message-ID: <202509052351.KuHBWdAF-lkp@intel.com>
References: <20250904002126.1514566-7-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-7-wangjinchao600@gmail.com>
X-Stat-Signature: idazar7jwyoxuu5jsjstdmrwudat4bqu
X-Rspam-User: 
X-Rspamd-Queue-Id: BFA4A40009
X-Rspamd-Server: rspam05
X-HE-Tag: 1757089124-817517
X-HE-Meta: U2FsdGVkX19lO8PKXRS6YehhcdUt+lkYDvVbpA8z1vl1HU7vWWw56aQTS59fVir4opLxRrGoI2oAX8qf7QzArRHmWEK2wMSrMdKdDyE0z96SbH053zj488GclY/MQV7omhQkhZzz7Axe0vRFmeOHgc85Q26x6fDQMqKbfp4Cb0FNzEBXG7/LMsIU2l0EhuhLDIHHdqbqbDJUkxTVu5jqpLdEVkuTeF9b/j+tPHXue6WkWKOsguaeRVHG/IJHic15oXQermsUmJFhxJbDl7EfC0PpVS7rkFfP3t3TNKp1/LwEKnOd/yr7XBuMZnTpGrsIMLf4S1w+1p6/BoCuj/7O31t4guELbE+J2UcrAph8kAOCFHno8Ytm2SsJAImiDDRryPApZWWxvXxfe4l6y6e1kZOzg6UWWEHtxRPjyFkBp3ce+Tu1Pz4giI4pwlhjs9L+sxEFdT+XkdNjefYfVKiIIcb10tKkS7Jj0+bwylbxHMdJHTwaYVZD2FC3Tcf+yr0eaKFosQl9uSzYqJcW9SAosSeia7PhyFXfGTjIMiLtUUVxXMa3bO7AbkD3AeOF2maonmixvOPA9xzCgQKNau7UYSqMZGUdUb5w4ZWzfPuiLL7eu6+e+LKQsBuHSldvm9S6oPnIci7JAqyGcrAOmcc+JwbTcniKBOv0IJ3u0Agy3oe1bH12BDQF8PnKNmBbY0Cm0G2C2/jfVMa6sJbakxfXyRrLQDvt6jlvIviG1+B7ahSrow47L49qnedycxVPpjAhyCnhyyHrWjoThl2oEUksAyncXFfbXwompW2Yr5TdajQXO2HOcTL/s1TEd0PNGoFLzc6vhVrSeR+oIOqlsJ3a2ivKSur+o9dWpz0KteqNyJhZlXg9WXeWy9mJN/3Mu6XnRslEHctiS8CdRMxgAvNEQrVQ3ynqorIr+8aB6WV+0XpzCp51r9UVEz2MGoJlPIgLbYGz/3DbaaAkoZHJq7v
 kDUsKhA2
 BOOzIvwPZvWUn8QZEOC2JhLjPwl2DUqoL6BdepD+E/7oVnFVnMOboeWRhApQtRnHxXoHseM7szoQVKoz83GqLq+kfRNJU7eenckoNo5irxUgX5m/brdeoh/cJkHIA7wDAa571ZiOdXqwQGxFCVcNgAIbLWm9z/GGOlObFUojAsLa1XWO1+20sPV0Mt5cEsDmoWoHpWwN0Ak8qN6KITykToPCDpv6yH59tU84b+RQw+wvgCI2bL8Ck619T3ldJUX/vkpYDcKd3eEHxdyY6aFxvC/Z0SUOU58UjQ+PVbHQHCV+Nhapsn7Pf64y7Lv36toa0J02+uRHhw7DUxm9vpqbJWJcAMxvsFMGJ1GcVu64U8NyCQWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jinchao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Jinchao-Wang/mm-ksw-add-build-system-support/20250904-082544
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250904002126.1514566-7-wangjinchao600%40gmail.com
patch subject: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent hw_breakpoint_modify_local()
config: sh-randconfig-001-20250905 (https://download.01.org/0day-ci/archive/20250905/202509052351.KuHBWdAF-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509052351.KuHBWdAF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509052351.KuHBWdAF-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/events/hw_breakpoint.c: In function 'hw_breakpoint_modify_local':
   kernel/events/hw_breakpoint.c:994:16: error: implicit declaration of function 'arch_reinstall_hw_breakpoint'; did you mean 'arch_uninstall_hw_breakpoint'? [-Wimplicit-function-declaration]
     994 |         return arch_reinstall_hw_breakpoint(bp);
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                arch_uninstall_hw_breakpoint
   kernel/events/hw_breakpoint.c: At top level:
>> kernel/events/hw_breakpoint.c:999:12: warning: no previous prototype for 'arch_reinstall_hw_breakpoint' [-Wmissing-prototypes]
     999 | __weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/arch_reinstall_hw_breakpoint +999 kernel/events/hw_breakpoint.c

   997	
   998	/* weak fallback for arches without support */
 > 999	__weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
  1000	{
  1001		return -EOPNOTSUPP;
  1002	}
  1003	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

