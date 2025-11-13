Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B74ECD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CFF8E000C; Thu, 13 Nov 2025 14:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4788E0007; Thu, 13 Nov 2025 14:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809E68E000C; Thu, 13 Nov 2025 14:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD848E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:28:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15912160115
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:28:07 +0000 (UTC)
X-FDA: 84106569414.11.CF2396F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6C44E4000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:28:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z2ZmZeRy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062085; a=rsa-sha256;
	cv=none;
	b=3Kw41szz67eV2y0IMWJbgyeAtIG3tOVWLvSudibgNIEQSEZ+uKovMyvY93fWUgRWuJrx0H
	yaBrzExYNNv5oGkSk69/vtHrLS6PMhHZeC9Lhsj6awAYrKvBGEbwfcX4X2doYD/aDeWy0u
	y5vx1tagZbKthAfUwecwAl7E2G5gXx8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z2ZmZeRy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8wh3WCZWIkweGCnBOrE+QextEl8ts4DwM+n8GzdUn8=;
	b=bhBqqGlYFwgVF97Z/xhmLLM0fz1m4+HhshBcoco6aK/IWETiACMXVwNk4a9bf/uZXSMuE7
	NIFJxdbMSndJ7C3IfNtF3YEGjNIyJL4f82rafuwFZFVO6xv2AtgojIuN8CyDtYVXypp/On
	MvoCNWYoHtY27sg3qmNKco+6XnzJFEM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763062084; x=1794598084;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WQ1At1+ZjGuWbj1pVi4Tp35itYpuTMRzWkOJLkvIEP0=;
  b=Z2ZmZeRyofH9oL3Zk+GCbmPSwBqojwTJypnwSUBZQs11+TfIexxZxkEk
   hEfR1G59kK3sEwZA41OY2FlFtAkK+Rb1NnDl0E9lx6RD83vr9RsTM9DEv
   IlG0DEczXmM4WRx/MY7Tfi1wlIDAlznkkiqLYacR4JxWwzjC48O4CeXDB
   uaN6+KwQ9qx8DHOa5TzfTSjn1Dm6RDVOsHap6Eao5e5QNWq/+p5dAijoD
   9/LfV7hxWrOfwEpHCO1uy/3ngU7/cBDpVp4bTsSzBf0qeeiWM2i+BPH1Q
   tepCGWMp/KfRfXZP1o0lNVuFXuUOZrJeC3AkMFOvpiLfviV0TzFN/I1H0
   g==;
X-CSE-ConnectionGUID: ztTqv4w1StmRRaNiljqjMA==
X-CSE-MsgGUID: 0Mw3e1L7SzCQ4Yty5Jayaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="90630805"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="90630805"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 11:28:02 -0800
X-CSE-ConnectionGUID: 3d1C3fd1Rz+qj/jFYqndfA==
X-CSE-MsgGUID: VtSMtCfgQNuuzOAK6Zzgfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="220218029"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 13 Nov 2025 11:27:58 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJcz4-0005nP-2S;
	Thu, 13 Nov 2025 19:27:54 +0000
Date: Fri, 14 Nov 2025 03:26:56 +0800
From: kernel test robot <lkp@intel.com>
To: Yuntao Wang <yuntao.wang@linux.dev>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>, Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Geoff Levand <geoff@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yuntao Wang <yuntao.wang@linux.dev>
Subject: Re: [PATCH v2 3/7] of/fdt: Fix the len check in
 early_init_dt_check_for_usable_mem_range()
Message-ID: <202511140206.XDGIw3J1-lkp@intel.com>
References: <20251113155104.226617-4-yuntao.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113155104.226617-4-yuntao.wang@linux.dev>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6C44E4000E
X-Stat-Signature: e4jy6utk6yndspydstioouyd5fd1drxs
X-Rspam-User: 
X-HE-Tag: 1763062084-908351
X-HE-Meta: U2FsdGVkX19bEQFt6KO/3gifFT9yi905+FBCfiKvqN/Ljm8w0t4piUYNkFZMz6fcSoMnzNNm9GyD/ktcU1Z+kLF1qHkGCD9wW+UO/CJg1fbzlrBtdAc2gkCr1Sey61iERaBnwyP3haBRBbumLqAD9Ji/K/fdKNlR8LFDYwiUgJUhAVYhsE+uwYWxdzQFcEw9Wq1L/FRKe71rxfFX+oDiK98UfsQ1G0K5W3lXAbW9tPUEz58NRJuY2QcB4VGmMKezgbZlG9m2uPQ8V9lJBg9xul7pKCBfol6lS3iBC5vrzOZS+U71Kn7WUWyGowcQ5MnH4pKhLeNA00yufRA/3zSHMFw8mGbUdZoc8DoQ07Q7hHS5GWCTDA+A2zRsXvyEcKfW9E3F5bxPBUzLYOLsbLHMLpVVsZls4E6ExBTSonQPI7810BGueW/VDu1riayHA45pz3B/2/r/mpvBMb9bTNRA8aHoHobxhz2YAPhqLr/bsgBHI+aY8lY+sZG/+ZTbC0XfCBOy7otykfZ7uJ/PX/FlT3zIRsjgT802Qc5bzP9c3pUiTmrfUfF8T2E5XGz/++dJIHqv1FlpuIpTqugdOAXhmPSVtNB181DVPWjC2ZZUHbI2JDf1JsjOkVoCuWPT4C6dd/KsdFHRVUl8V8aWlW9EoolD07/nYfgqZPAit1rvZlHwyKY4Mz0bWCZP0/lQMff5kEY9isESReExjs/adsNzNPkgPjwFD+vrv5rB02K6pna++D+/r5QVX340ceWlBX7+qgrYNrXmqtXJOQKHKfN/PYS03tkP3DvnAF5Jznt9Z3PO8VZFiQIC0F5SlVo/CMUnz+FFB4uiur7NU5J7Q560DQcknAffQdQ9BJcD3ud8NkIuiUPP02bf9GsrM6tf8hKHfBaYEzH3wypFptFqsIw+sLmvM9i0+iYSCrdS3t9HEtAETBUDSpSjFJy09BdEx3pNXFe+9jbEKieCItNChJm
 9kDfN4k/
 qsxs7DsIPOEIXsk9BjwxTo9AxO+IuRGJ4Fhg2fjW8u1s0flU8NKhrZHjmqRkCdjayBvdcb1Acn9A/BWl0aWBks3sZT598gNnqEPG3CKFuSjpWCkgE/dRGUXKRprEUvKg2V84dUzZD8e3tehKtp+i8yyI5mrkKogehJ6KwoBqcMRI1CaGqns6U1rR56fpCIdK86l0vuoDo1+TJ3Kz8bZXic0wdt0AUDdgp7UcymFONhPH03gPAzvZ9/QBk8yWPNL7c47X6qeLgd6X+vh8Y0MrqLTMXGKkm0rjK/P2SqHqHwmiuo6TQo/YoxVesvyhggJa9ZbJD/UQQlzYecxtDyRhKOLPhhVNWB6XEZX8LitsQ11uYNqFJjwGwtOwwRBR+s7f95pJXMiaD6SU4siGlcZ72FuX+n2bPyqv1HVtWaOA6A4ElfSQf/lM4vdJncigPNwR0rtoz9J89Veoioxw9x/3Rw4yeOtN2ZAw2ffPw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yuntao,

kernel test robot noticed the following build errors:

[auto build test ERROR on robh/for-next]
[also build test ERROR on linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yuntao-Wang/of-fdt-Consolidate-duplicate-code-into-helper-functions/20251114-004121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20251113155104.226617-4-yuntao.wang%40linux.dev
patch subject: [PATCH v2 3/7] of/fdt: Fix the len check in early_init_dt_check_for_usable_mem_range()
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20251114/202511140206.XDGIw3J1-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140206.XDGIw3J1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140206.XDGIw3J1-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/of/fdt.c: In function 'early_init_dt_check_for_usable_mem_range':
>> drivers/of/fdt.c:903:45: error: passing argument 2 of 'of_fdt_read_addr_size' from incompatible pointer type [-Wincompatible-pointer-types]
     903 |                 of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
         |                                             ^~~~~~~~~~~~
         |                                             |
         |                                             phys_addr_t * {aka unsigned int *}
   drivers/of/fdt.c:663:60: note: expected 'u64 *' {aka 'long long unsigned int *'} but argument is of type 'phys_addr_t *' {aka 'unsigned int *'}
     663 | void __init of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size)
         |                                                       ~~~~~^~~~
   drivers/of/fdt.c:903:59: error: passing argument 3 of 'of_fdt_read_addr_size' from incompatible pointer type [-Wincompatible-pointer-types]
     903 |                 of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
         |                                                           ^~~~~~~~~~~~
         |                                                           |
         |                                                           phys_addr_t * {aka unsigned int *}
   drivers/of/fdt.c:663:71: note: expected 'u64 *' {aka 'long long unsigned int *'} but argument is of type 'phys_addr_t *' {aka 'unsigned int *'}
     663 | void __init of_fdt_read_addr_size(const __be32 *prop, u64 *addr, u64 *size)
         |                                                                  ~~~~~^~~~


vim +/of_fdt_read_addr_size +903 drivers/of/fdt.c

   879	
   880	/**
   881	 * early_init_dt_check_for_usable_mem_range - Decode usable memory range
   882	 * location from flat tree
   883	 */
   884	void __init early_init_dt_check_for_usable_mem_range(void)
   885	{
   886		struct memblock_region rgn[MAX_USABLE_RANGES] = {0};
   887		const __be32 *prop;
   888		int len, i;
   889		unsigned long node = chosen_node_offset;
   890	
   891		if ((long)node < 0)
   892			return;
   893	
   894		pr_debug("Looking for usable-memory-range property... ");
   895	
   896		prop = of_fdt_get_addr_size_prop(node, "linux,usable-memory-range", &len);
   897		if (!prop)
   898			return;
   899	
   900		len = min(len, MAX_USABLE_RANGES);
   901	
   902		for (i = 0; i < len; i++) {
 > 903			of_fdt_read_addr_size(prop, &rgn[i].base, &rgn[i].size);
   904	
   905			pr_debug("cap_mem_regions[%d]: base=%pa, size=%pa\n",
   906				 i, &rgn[i].base, &rgn[i].size);
   907		}
   908	
   909		memblock_cap_memory_range(rgn[0].base, rgn[0].size);
   910		for (i = 1; i < MAX_USABLE_RANGES && rgn[i].size; i++)
   911			memblock_add(rgn[i].base, rgn[i].size);
   912	}
   913	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

