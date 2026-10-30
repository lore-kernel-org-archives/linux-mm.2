Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F11E606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 07:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=W3jyIWaF
Received: by kanga.kvack.org (Postfix)
	id 830446B05B3; Fri, 30 Oct 2026 03:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DA826B05B4; Fri, 30 Oct 2026 03:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C9B06B05B5; Fri, 30 Oct 2026 03:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46A226B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:33:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC1064061D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:33:47 +0000 (UTC)
X-FDA: 85378478094.11.AD57784
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 12CBCC0003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:33:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W3jyIWaF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793345625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+GxroivXOXnIGiRc6t4AzQb29umfEUWlMNvPoOav9M=;
	b=vKG0TXHaKdw3NKQvNK51eD9aLpzG5i8qb6zE8FckAUhNfVNg6bsnFniqTCFmhX/uNkt+MH
	rPl4rx70nC4Ck1/BNxBXHwCbYaO1J9wyjJYt76mj0FFudN+Acf34uuPmW3GZW+FMvns1C9
	5unupJnXbYTSJfw+0s0nWf25v8MkvEo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W3jyIWaF;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793345625;
	b=wF2rxT/o3HzBHdzQMp0oGEoh1BCdsCKhsLZxVfrpRHBbdF7QwB+TdY7nRPvPZWm8zdeHWc
	wMQnWPbfHjEmNBH6W37NMgjBsglRJsZGNQM/9IQ3+NakTLpekBxiDB79sAoxb9wwv1K1yC
	w9v0RBfsk3P0imztysNLyBZvE6v7p14=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793345626; x=1824881626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OvL84YuB+sd7nusZ01AizX9eVWHoZzJ3a7z3XIO0Te0=;
  b=W3jyIWaFo2gaPS0w6mX23gQQ6S1v9El5LSvhOqahi73dYMUIcG9p2kwX
   8d6RRuAiQBr2c+zPw0lcgWorO1Q30ey5xyOq8HQRi7ipJHffU2qLp9E+i
   Y6tgIqPO/L5wmytJFeYX/nojR89lL0gzUPG+ED1BdduMD2rcl15rboUs1
   pmLUGBFyn7E/N3XBG94OsoT5TF2beWEDDzJquORIo+0kigE05ZhoFMzfV
   G2IxfN5Oo1z7Z5mu8AoY/6IG5soVi0wmFfrElhfurFw7fiAYQ/SX2lD8k
   vt9WhYO10KHkuoEdnOB/LBiru8aop5SGTCm3lc2Baa3R5QCgSl3B4Yh/z
   w==;
X-CSE-ConnectionGUID: 2NFr8KYvRnycznzRGGxdbw==
X-CSE-MsgGUID: r5riLKXSRb+wgT2j1Be9Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="2130594"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="2130594"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 00:33:44 -0700
X-CSE-ConnectionGUID: n1B27IJ1RvWE7D3KAUe0Vw==
X-CSE-MsgGUID: 2ZzALyrXQKyc25Ph53vDLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="5706029"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 30 Oct 2026 00:33:37 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMh7F-00000000bRG-1zGx;
	Fri, 30 Oct 2026 07:33:33 +0000
Date: Fri, 30 Oct 2026 15:33:05 +0800
From: kernel test robot <lkp@intel.com>
To: hang.suan.wang@altera.com, Dinh Nguyen <dinguyen@kernel.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Gabriel Whigham <gabewhigham@gmail.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Thomas Zimmermann <tzimmermann@suse.de>, linux-doc@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com, chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com, adrian.ho.yin.ng@altera.com
Subject: Re: [PATCH v8 3/3] firmware: socfpga-fcs: add Altera SoCFPGA FCS
 driver with SDOS feature
Message-ID: <202610301520.wvw7Vv6S-lkp@intel.com>
References: <d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang@altera.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang@altera.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12CBCC0003
X-Stat-Signature: ebex6ciabehjufbmh4435a7qzb7wkg8f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793345624-493239
X-HE-Meta: U2FsdGVkX194Q3M8300gc//mVzZNF+vg+XX6rBpG56DLcwMOYUqVM1qPjsV6S/oedB2iGPj/ey1x5ewxd+HG3DI4R5hgxX4fVnDOsi/Ymz63qgbZ1av8bJUse/+RhYU13W+cfc3xDn79yncAZBwtp8LZDrh1GqmSNI6HGxO6Dlrvgu3ZZDklZPCIcV8AnV8aqMTBuHEe39Uot5SeGlBan1ezeN+3tLWP+1kAOWh24wYEEVPaNBeGtX3g6YtBIEoKBMnYiOSeq5MvM2C8v9uZoNvPHmoWNeFJFtlBkLiKLN0Y+I2Ct8IQnOGjB6eNhSjNt2u48FykhzitBm+/l8L8paCrGDNFoRL8fB6LJYIBIl2sp0/j5pLVhF6Xv/kURviqpNGv8VMni/PWvEt3DGySl3KDmbwG6S4cE02ecVhoONNitTDf9GScsWgvshN9l6XnlTE8Ef/iB98Es7UnLtmkUV3IrM76to9ZcCrQsocjZqVgAQUBMTU5aeV7sF0iy6QbAiPnp32b4DjJzfXamLLkJimauYvQeeNpPadXYgGGlUIMxmoxfJuOCXNdfDTglAQd2rTZDOTGoCh3z0bwkM6W1maPCYYXw9yC9aHZoyL7yUknyxcO1I9/uyiBGpdJKVnR3IdFJ9WEBE/Lo4NrOL10TUS19QnekwK4wQNBTH2oBs+G1DiDhllb48I068QPlsgLrYRwINWYhfQzUwkspugBcCoSeEL49i/b3T1EVUn/GsWNWBxSaHybCPNy8zNMCdJurfPutw5/86aVPbUpGyNrbw80aclnmdq68PXHGrDZSsJQnRN8tzdLCfcbSKjLX1HHR7m5SW8mW1IZo9yVkQFng54l8EnKd8qgW1/TEInAf3BcS20FaNLS+3m7rAFxSJZhgT74qCcnVl+9c+neff2/gLDRFxVOcbvHtnzSS5a5QM3bdMqbJ1H0JtG/JuvffDvUf5JpNS0sjjFrXVpMRLB
 1l7tX+yE
 i4Ckkd3dqNlnFzPdf+6UkKJ58IgmpALkduXNKBq2OqXgnTVSU2IWYajnKD8/PpaNfXFGU9+NRQp2hRUdlDQN/w3ttewThiYFMzlJQLRliGXuAFRgF0pjEUEPFbpeDQfP/8p8wnmINaTqlLhejx14sFW0w7cHnppnlvWc/dLWnxrXTS9+GTcR2rJK1rCn4XdfH7tvr/Vt4HKUfxUiEqvtpe9MQia3k2vTQsJ3a0T8Z7QqCv/rhf/JAeB6kTqvSwFtkwXvebw/o1bmajtALK+DE7/WrxqYV266fhKtSgh2LfwmdOQL1tKtXgYsfYgrqZERtatMPApiJzibZdQETja3ZiKpamR9wM/Pwwg6+bEWV1v/UgP1r9382rOKuW1v4hW+a4RN1bJoVCUmeRNWFHQWDaCDapzX7pzUdHhnm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on linus/master next-20261029]
[cannot apply to v7.3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hang-suan-wang-altera-com/firmware-stratix10-svc-increase-args-array/20261028-221419
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang%40altera.com
patch subject: [PATCH v8 3/3] firmware: socfpga-fcs: add Altera SoCFPGA FCS driver with SDOS feature
config: nios2-randconfig-1001-20261030 (https://download.01.org/0day-ci/archive/20261030/202610301520.wvw7Vv6S-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261030/202610301520.wvw7Vv6S-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610301520.wvw7Vv6S-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
>> ./usr/include/misc/socfpga-fcs-crypto.h:43:9: error: unknown type name '__u64'
      43 |         __u64 error_code;       /* ptr to __s32 (out)              */
         |         ^~~~~
   ./usr/include/misc/socfpga-fcs-crypto.h:44:9: error: unknown type name '__u64'
      44 |         __u64 src;              /* ptr to input buffer (in)        */
         |         ^~~~~
   ./usr/include/misc/socfpga-fcs-crypto.h:45:9: error: unknown type name '__u64'
      45 |         __u64 dst;              /* ptr to output buffer (out)      */
         |         ^~~~~
   ./usr/include/misc/socfpga-fcs-crypto.h:46:9: error: unknown type name '__u64'
      46 |         __u64 dst_size;         /* ptr to __u32 capacity/len (in/out) */
         |         ^~~~~
>> ./usr/include/misc/socfpga-fcs-crypto.h:47:9: error: unknown type name '__u32'
      47 |         __u32 op_mode;          /* (in)  */
         |         ^~~~~
   ./usr/include/misc/socfpga-fcs-crypto.h:48:9: error: unknown type name '__u32'
      48 |         __u32 src_size;         /* (in)  */
         |         ^~~~~

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

