Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 684D6CD6E5C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 14:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0EF38E000B; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE908E000A; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D49B8E000B; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77AAC8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:22:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 952C05C090
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:22:29 +0000 (UTC)
X-FDA: 84105799218.25.9034FA6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE4F7180006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:22:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WTsyrpdv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763043747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iWLkJrH9N7qomV6SAVK/SLhMiJw0Wd8ZS0HAyiVZrc4=;
	b=4jGcK11622QU+nvJ44H4BuQ5hpJooIWvuuT6tBkKydE6VSW5UARhMfvf2pux3sWmbgKHOq
	OSQZqU84FYGCdocB2YAilAmqen2qse5uVW0OKbM2I01tDFw0z70fzEdqvm9sV3JHEuBGLd
	GQccn6BdpW4zsB0QBLodBJ0w3hNmNDw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WTsyrpdv;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763043747; a=rsa-sha256;
	cv=none;
	b=ViJB305LjeGNc2ZQb0eb5gyI1TXqFlxtroPHceO1uYkYr6kPP/oUvBQIbeIzjN1iLE7sfq
	IUHugJlHmj2b8NBawlylq03YHYITbZV5/4mL2dY6dDMhfjZH89rag3N+CyzluZPD8njvAa
	rvLJ1ThhgYvUlaQop9qST2GljFTKMHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763043747; x=1794579747;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VHm3dGajIZFdLCEjo6RhvwU9h8nLup+9R9J4A/jkTNg=;
  b=WTsyrpdvfVMM94s4sxoDwNUM4scNfDkUwfltxrDfDP+Z3ojTsoHmOgFk
   CGgWa/JCPmc8KnZRWZI+/alQ3JVGIJj2H/bfh0sCRdXEcONIwVW9cUEwp
   sVh5Xz0LqjSjWV/ewta/JJpmcWklzAtnLNGwv+1DVZ8hu2xt1MJTDMMAz
   oYmwaOEDs5h4zZAHtDEOj2C+52RPs03qYrCUtdxP/hrfy1q7ZZxXfjRit
   e0wh5Trma1gRBRQdjPKLrzsf0ef0C9aR+nBW0GM4zlTVRCtV3304BQLbq
   /E2cpG1l9bzPlyb0XqcN95fsDQJhNFWho3ZnxXJv5b16qg2yFjCdGR8/w
   g==;
X-CSE-ConnectionGUID: 9j5050e1TDGqed2XuCm8mA==
X-CSE-MsgGUID: Q7yB719wQj6uhQDb3dTTjg==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65030921"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="65030921"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 06:22:25 -0800
X-CSE-ConnectionGUID: 0nmFRwd+RIia7e4u2IYFLg==
X-CSE-MsgGUID: PUjJmhXRRUaIrm0G484j1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="220313531"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Nov 2025 06:22:21 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJYDL-0005QF-0Q;
	Thu, 13 Nov 2025 14:22:19 +0000
Date: Thu, 13 Nov 2025 22:21:53 +0800
From: kernel test robot <lkp@intel.com>
To: Yuntao Wang <yuntao.wang@linux.dev>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Catalin Marinas <catalin.marinas@arm.com>,
	AKASHI Takahiro <takahiro.akashi@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chen Zhou <chenzhou10@huawei.com>, Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yuntao Wang <yuntao.wang@linux.dev>
Subject: Re: [PATCH 04/10] of/reserved_mem: Use dt_root_addr_size_bytes()
 instead of open-coding it
Message-ID: <202511132259.fWi45yHp-lkp@intel.com>
References: <20251112143520.233870-5-yuntao.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112143520.233870-5-yuntao.wang@linux.dev>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE4F7180006
X-Stat-Signature: oqutg8xdanpxncfeg3o3o9ejq6fxjhjn
X-Rspam-User: 
X-HE-Tag: 1763043746-935888
X-HE-Meta: U2FsdGVkX18rV7Wbtl3YgHd2RGYB1oEUApsyjPNCIdjxn86BlSo8UHDovCwSdi/jZb7kQ2rK/wBpcfocyUPwn7k/Z3La+kHvtvLCokknzOur/gz8t0NdpVeznaR7JHeV4BAeTOzUDk4g5wulUZHEhvCVaCgmC7Eb5zF2aKAwHJyFFgL7NFbB+4IkKQBMwPWaunQu083e7eIjQqjv2P6jr4S9BqhHT0foG6xXu8KdIhmcPsQ/juYJyG1Mx+gjbVRGBmHkHTCaBxxqPMGmn1Mto1q9kcq28O+TRuHZ9NRXGLf1+orjNxelscvJZdB8ehKdsi34qd5VmK0y8X1QR7XTh6GDuL3wNOk5a3+zU2gKPKtDOsDRrgij66MBXCjoR0mwMMUr+BLk3x210TphCmxHJs86cqgicpbbzH0thUStdBl+bq1cnkuu/31CCnbzokg/BBouec9kWpCwAmqnGpS+hZE/OS5n/ei8I8Vw8nb/iTNQpiWT99oSoVYP24u9Cun7jHnllXWTNPreEooNvieArXaq/s3U1xI96GANxuVFyQ+UkipgQrynTEPtW6uPRBv9clHILi81V6fmyfTlmsbe1tumCWYGf+uuCU29IcNzXTdK/Xsd03XomCqlQvE/49Lqg1jkJkVVlvsEaLIyxxS9imDg1696X8tp9dJhKBjHb28wWkG454+LBf8H9BSMf860K84N+ggitYm/MO0hZXNmJ7fQxZCccKq/9eqB8Y+EfGHiai+9CJZDnmF6qEDnSNDOZNo0gAU6wjQG6/5cehPUToRguvcWU2zD51P1xl/narvoC2O4QKssdTd4dpurgLfsP5On088TSWjC0eJaErqr6JWOGVll6saEhN62TCnntn7+8JXHBwS6W1e0yyDx3vNthBtM8s5gBK3i8kmP6E+F13+rwPO6UB1oTqHFEzNjX9Lh3ZtbvQ4fUyzb5ny8vliiAVFBvBnC391vjx50nMY
 OrHrxZQL
 JmcWi5aBEnv1RI46U1vDdQ30KK9m+ZQcenb2MtTzV4WDzF+4A9/r9eQzsHPoltPZAmtg1eKMeAFH754GGDOMJG0W9AVHMfT4UypGppIO4hCMafRhHnCuYgqpWobIxVzD1VyN6TP0JZz1hXHGOaaKerW3WvZqCSMxVA2iLTQ3d+jiZCvZ3hPd3LOkKhxIOi6iu00cvt+CImma+eadkiodXlZXSEaiZBrG9YIQpKTb2im0BWxARCNQc0gtxq7Rj6Noz/xHOXT1/+qqrWTY5UixFxg4KBX+m5IbFRn2Q9Tekonk2gNr0ss2k9uOpMw2LxrN+WXx7zZ0HrCRqr95UV8XYJP6J24WF+GitO6UlHS848DlKlhWfcD86Q94KGBHJLphMRPxpljHxWCbWlmIsV7HwFv7yGrfvJNDyreW+poiguRY/AtK8Lry5k1wjedlBTlLbZyU8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yuntao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on robh/for-next]
[also build test WARNING on linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yuntao-Wang/of-fdt-Introduce-dt_root_addr_size_cells-and-dt_root_addr_size_bytes/20251112-232000
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20251112143520.233870-5-yuntao.wang%40linux.dev
patch subject: [PATCH 04/10] of/reserved_mem: Use dt_root_addr_size_bytes() instead of open-coding it
config: nios2-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251113/202511132259.fWi45yHp-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251113/202511132259.fWi45yHp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511132259.fWi45yHp-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0x0 (section: .text.unlikely) -> dt_root_addr_cells (section: .init.data)
>> WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0x4 (section: .text.unlikely) -> dt_root_size_cells (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0x8 (section: .text.unlikely) -> dt_root_addr_cells (section: .init.data)
WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0xc (section: .text.unlikely) -> dt_root_size_cells (section: .init.data)
ERROR: modpost: "__divsi3_table" [lib/lz4/lz4_compress.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

