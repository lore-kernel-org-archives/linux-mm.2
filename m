Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F5B7CFD315
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488226B0024; Tue, 25 Nov 2025 02:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439626B0026; Tue, 25 Nov 2025 02:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3280E6B0027; Tue, 25 Nov 2025 02:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4F36B0024
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:53:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A246313BAE0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:53:31 +0000 (UTC)
X-FDA: 84148364622.20.D39D62A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id C5683160009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:53:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nmixa3sI;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764057209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BYVBU09N8VzET4G7hgFelokUfvOBGj824TAqxt5oNXM=;
	b=nDYBeaDJDtC0PhC02fl5b5xYiBtEIQOpz5/5rt3QFPGGX/Tdwm8iyZkqXbo8Im6AvlFmTz
	8RjCAqOhpP/SZ6F2aqCxGFcF7umB+5H0SN/pK8huwF2MR2T3gPIlqZ5M8HWOh1HUfSV2hy
	fTMGOsd2ET6JbqYCbKoyRN51D2tciU0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nmixa3sI;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764057209; a=rsa-sha256;
	cv=none;
	b=hA2YK6uW3jhjtjGhJfpOl/1/B42WzuZOACtJmyxN6kCkHayyKVFp7OBvo5w0v5nHkR8dI2
	bh/DfeMKH2FpkYY3UMbV3hxPBrozAD1shBHUJlR1bpp5nVtKiCjVuOzYSoup8IbceiZU0m
	/kErHYi6Hwpee9A5dosnNQ4IWieyDfg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764057209; x=1795593209;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vrVOl7EVuhETDdmJkVuWCXbygP3HAoSjVC9NVD6yA+8=;
  b=nmixa3sIzYOqkqKDS94tnQ9MZ36sWs0HRGo1tITx2cBIpeooyuevoV0Q
   NtV3JrdaoCmz4behw29WwNd1baP3rEdByAHcohECT2sQK0PhfU/Cpn7Is
   Qid6nbuJvAl4aV/trIMO4OOskbzceMaZ78IAR/T0p21Wgzs8URJP9dXLL
   V0rx4W855NTKA9GtoC5/QzOxes3DbDThmnCLGDbsWBFHNVnwFd1E2li9t
   Ri4+QCSp5iVThHw5f89BDweYYItGv9AxRMcw1Knbmr9yk1l90ANdEVq4F
   pYgdmRsCw22oKVaT6Hs5uGOK+qWcFF4HgkiURJePkmgF4iHL655Zfrn/9
   Q==;
X-CSE-ConnectionGUID: BhHc20f9QImDX32yjNnsqA==
X-CSE-MsgGUID: yc8wpI71R/mYM7KAmZMLsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="77542613"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="77542613"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:53:23 -0800
X-CSE-ConnectionGUID: HuLq3zmzQfyc5+eHB9dUgA==
X-CSE-MsgGUID: TPLWqce7Svan9mkEomQuIg==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 24 Nov 2025 23:53:14 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNnrL-000000001Tp-27Y0;
	Tue, 25 Nov 2025 07:53:11 +0000
Date: Tue, 25 Nov 2025 15:52:26 +0800
From: kernel test robot <lkp@intel.com>
To: Tim Bird <tim@bird.org>, pmladek@suse.com,
	Steve Rostedt <rostedt@goodmis.org>, john.ogness@linutronix.de,
	senozhatsky@chromium.org
Cc: oe-kbuild-all@lists.linux.dev, Tim Bird <Tim.Bird@sony.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Francesco Valla <francesco@valla.it>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH] printk: add early_counter_ns routine for printk blind
 spot
Message-ID: <202511251534.9kMSsAH6-lkp@intel.com>
References: <39b09edb-8998-4ebd-a564-7d594434a981@bird.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b09edb-8998-4ebd-a564-7d594434a981@bird.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5683160009
X-Stat-Signature: kawu63dwx8x3i9k3xewn1aj8xewbihau
X-Rspam-User: 
X-HE-Tag: 1764057208-317855
X-HE-Meta: U2FsdGVkX18DykhBFKh2LV2zw8gepuUgKL7ZxJ/hD0CTQRVxXbq8Hdbqz5vsv5dzlxciAWGkfprxj0SgX4yGeEwfGyhzuH9nNfLI8yfsTzCgexk4XfKQYn1i+2rTJrD41VRMfHp/NkPpOkpa54CB5ZP4FWwOsgxxuSsOS0ODqcRlGo+JNei1H2ZYFQ2Xkpgci3MRFQTvE8NZsgzwix+x+CVlDX8abdyk1+lOwVDRgRcqbL3og2pnS53Iahq6VuR2TheURNPlVTvx1/WAyE3zKK2/wrpiYVPYoOVYnzHbLFALMXeSNtL7oaBeLiXW4vlCpzCxkptnvQToSTHpZVeP6FJf8we+qHruGaGpFB5St+D7oYiydwkkzPrfFdg9yjyMlD4hBNQbl2C6xOglwTH3cRVYPkk7EZrvevS1Wb2lpGiv4/DViDCN5eysbHLeauTjPZZvwNBTN+W3ZRkpVs5uVuR+AoTPH5Y38k0q4FidsgvuexHuG1EpVMMpEDRqrh05w7BUeXlufRyK3ybkncNEHB9S2NjpsvyJw2RUAiTkiJv3CUigx0kXXaXyUDrF2FHoUpMlr2OMUzeBwRpxsnsbihd19o8Y6nj0jQeqYwTV0sraHz0JWy3a6JKp5jrjWcjOZfmI1cY2dP5/i4/xhwlLHqFZN4TECn8pazi/X34syn75qG2jITv+Hkc/o0KHhOVYnuhbofabaB3cEjMUole5FRwDRh9IwYhpZC8i1dA3nhhxF63LSXfO5EpaHFQrsjA6AzCeSnOl0+SEzjQSwZ23WXs1Wz9ulRm926LZarmM5VijRfA1vUV6HtplkikQ6DrK21zkpvJGcyUw3rXaw2uSghGR4XiVXAGJnmojJPkxJMt433WMwh981KFzn/x+Zd8oq5TuQWD5Ds0thMnzueMt2VUeCmJB3Eja+FTjMFc11EDs1IG3Zjab4acLDtD8i9P+IDNmh4+D9b40fRowwfX
 kbOdodal
 fuGNkcgTKVJieJo6VDRJSslVNm8RbhRNMQpJJlDSvIEjw7+MyThu+znYW2mX+brm8eh4tbGkvVtYYdfTqCmh/yBJJO/5hSQSkT1tCPg2+e/3q8mAHxKBTDATFBPaiN4M3f3OhDR5Peu21fYfb+zQta9dGXeAkbuoIw/MuQO0RC/YpXKJcc937cjacnxNkgZq0Iz9TPHrjXEa/W1cTVU/PQ3AMTTrDKlVKkSFMq5mSzfbEfhKbRqmA59myzdm+UBJtWE68OAFmway4vC9ajCYq/05mVX7pApoxYWp5bQsz3ReHCroSOOfuHJA4hFgKdLSQO6tB6zO+Oo14dm1sBbJQ2kBuGwVyF6Yp3GRxIK0+AtPhQJbTMvogRQOXiKReomTxd85PmMa9lHO2DszAE09Vltn52cO60LQf23QB8Trym2oOaMAuv1+90IEU+TbAe/xbJwjIWhtSTP5mKtQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tim,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.18-rc7]
[cannot apply to akpm-mm/mm-everything next-20251124]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Tim-Bird/printk-add-early_counter_ns-routine-for-printk-blind-spot/20251125-133242
base:   linus/master
patch link:    https://lore.kernel.org/r/39b09edb-8998-4ebd-a564-7d594434a981%40bird.org
patch subject: [PATCH] printk: add early_counter_ns routine for printk blind spot
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20251125/202511251534.9kMSsAH6-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251125/202511251534.9kMSsAH6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511251534.9kMSsAH6-lkp@intel.com/

All errors (new ones prefixed by >>):

   powerpc-linux-ld: init/main.o: in function `kernel_init':
>> main.c:(.ref.text+0x144): undefined reference to `__udivdi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

