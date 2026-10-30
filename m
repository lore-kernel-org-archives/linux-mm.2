Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768BD606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 20:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Eo7n+B9e
Received: by kanga.kvack.org (Postfix)
	id 897236B00EF; Fri, 30 Oct 2026 16:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E3D6B05B1; Fri, 30 Oct 2026 16:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AB996B05B2; Fri, 30 Oct 2026 16:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5180E6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:22:06 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2E62120830
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:22:05 +0000 (UTC)
X-FDA: 85380414210.30.CCD673F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1975620009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:22:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Eo7n+B9e;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793391723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZKYNvV99olnOAN3/wz742NSCo6uP+fRvmVfRPXXfag=;
	b=kdb5lFcR6uDjJ4XpRxtQIRQvrfD61jhGRBTQ9wDOll93jEz82Wm27jJm5MQIwRNlfEh12e
	+7rdRsS3GqxDiAVB9kCxbFSiD7GnPI7wrpYErkt8vqLzHzSyluIHVWhUz4b89p6jYHX/MB
	1b5JY81Po5rJBapdsJMlrJATsP7+hg4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793391723;
	b=uQesGQenc7tYrm3R5ZL1tSj2htg/bsn9sXn6QO5GBPMJedYlutg+UI1VPz/ULgfSGKXRAQ
	99Nmils/LkDqP4EtfC3KKtpiMzuHSuQ41PhxI/j/K+/SxwZF3kX62L75X7eLtkXUZYBLgr
	nydvUfI27zrHVYBEnqApenvf5HKMvYs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Eo7n+B9e;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793391724; x=1824927724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vPSnCcsxmoggsBL8AhqusSxvlXgXWzci4B57bAku3no=;
  b=Eo7n+B9eN7OuR/VuUsdFLuZUwr4Yh998/azIsQ/vS0/waKX9EM7nLZzh
   QvmxE4SvjMqtDJiQlTemxGyq5e/jGQ0N9QtBKDR1Ic4QQPHquFsh/lZD/
   rdKBTO2rM32rVjysppyGELJeRZDRB9/bSKvZmSdmGgwxsPNzEJvqY5xuL
   +1pD/bhUFrtediyIgP8sH3ZT8R0Ithv90zbS2q77cpsa1wMZmMOjoGaIV
   WN1XhFAFL+m3uAMlEOf1Re/sWmchvck1Vtb3PYlu4bmQ3nESUBWmQZWfF
   tIUE5FS0YeroE1sRqAA6SAaVrh8SlDnyCX9xHlUUk1s2c2z/BaTMJgMPo
   w==;
X-CSE-ConnectionGUID: CawPj3/yQeOqgVVQJrx34A==
X-CSE-MsgGUID: NPbcho3rRJCB9yHk2c7xQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11951"; a="2257866"
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="2257866"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2026 13:22:02 -0700
X-CSE-ConnectionGUID: uq676+OpSbuSH9Qj21B94w==
X-CSE-MsgGUID: mVKp5fG6TpmsPslS7cKOTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,186,1787036400"; 
   d="scan'208";a="6069808"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 30 Oct 2026 13:21:54 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMt6k-00000000cBs-3Ksb;
	Fri, 30 Oct 2026 20:21:50 +0000
Date: Sat, 31 Oct 2026 04:21:16 +0800
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
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com, chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com, adrian.ho.yin.ng@altera.com
Subject: Re: [PATCH v8 3/3] firmware: socfpga-fcs: add Altera SoCFPGA FCS
 driver with SDOS feature
Message-ID: <202610310455.KTHdfiRf-lkp@intel.com>
References: <d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang@altera.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang@altera.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1975620009
X-Stat-Signature: 1cm94yk563f8ebr68wbh95cdcxtp1ws7
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793391722-904594
X-HE-Meta: U2FsdGVkX1+KZHI3cOiNkeNEth4AFXWvIOxN78hJVK1SIWygxiSUojrPQcKr/10QiPCcBV55hnSuAv9SmtmQt7syH8c0XI5Ikywrqi9ZGHvnmU/B/m2SmWRRvvcPa+fRFDoHrmf0WDypZ8WhT3Ogg3j3DbEfoK32B3ET1myowSdWZlxUQ7GkLKpdW9kW2OoTY/IZ3s//CZwcoXPyD/1avXTiLFIb2RptaQhZ9CfukbcEsL3pj8CRsmqSXhDVih+WF4Y66WHQCAf7dSX36J6GzqBV8Gb/dZ+Ul5/zcZWkFXw3KcmWukH4txk4Z9pWUm31ZbqLhRQTq0i1eRzkCnt7AfFlilqtioP2iVIb/wi6dIDHr5xH5AT14fGY2hB4al+KvB75Nv4SNaWLbxUxc12qEFHGHylPHhZUFtGvcG2ZEIi74YiXAcdcJU1vt9+FOHVIseBwpr+x2EMCzVDGEQ6jJiAmbCf4HEyfSny2FhQyloDcYNmOFzpsOf/t270tr32PU9nmN8wmQVIPVFAq3kKPMzJJ7HxZ20IpSsPkfRWeJ26FV9O6AZHOScqFMjXcNd5TSbL6k2I3VW96jY9Ia/ya3MfBzm+K58L06O8QEW8DxxS1Q9QNChawaMmw9LF+HCV1VKB7Tu8Y7RT6wZLOYN7luz3BnR8wQWauc2Dag6PP4nWig67IFFr9t3ijPOHDuKBDj353hYQVtf2gFg/XSzEaTx7sIKBjZVXPq74uDPpmxdcK4Im/iWLfDvHZHFo4lcyAsRkIT331QoNQRWPsIfVTBzErw92At/keD7CQqA7uqsImzJUpjbCCjRVGLHoPlDIseXOzSdhz/XeRHCheCPieOg11a44skuSvaGP8rdkKfTnrIsiYT+SRzC7kz99BAKAvluMLxOGlMT0ybzu+hdisXw1E5BBCYgNNgGc1zw3o35BmHopgH0isUZ/sFvj8SZ6h5NER4xtVnDgJC+wKI8K
 zrE5SNOW
 /VaBM61YTrKxq7zP4cISA3McZmOV+B5LqVffX2H7ClO2vpLpD/30KxiDhjleq58q+MC9myyw5R/MNyBMUbePKy1ybNpGp6tbG8P6hfIGX/QheLVIcxZVSBocm7/FZ9J/scljfju3wLzdZ22aPx6s9tIwj375CLKqnZOgWkfQSVDgvk8N1VeQzWMqKXLQZAf0/biF8wuYJkim021LcS1aCnTKMUrCFJz5KT4IBRcIcXxfjowcIggtKcFp73lM4Vks+MK/bdK4nIOcja02ffEw0neaEbHiax5GF5DNiczxrfg/60TTMWb1jEDYlZeaKA2yVQWfyUc06QYvxOFRdLrsU9FCjjNbdKmDFRlLhHwMkdDuaOdrm1Fi1rVUAea/UXg30biACrDkMhSJHEv4ypXJS6+GzqT14/lONNkA1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master next-20261029]
[cannot apply to v7.3]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hang-suan-wang-altera-com/firmware-stratix10-svc-increase-args-array/20261028-221419
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/d2a662d1b783146e48642dc85c920008a02b433c.1793197438.git.hang.suan.wang%40altera.com
patch subject: [PATCH v8 3/3] firmware: socfpga-fcs: add Altera SoCFPGA FCS driver with SDOS feature
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20261031/202610310455.KTHdfiRf-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project c2ea4440d4b64c148de4fdfca1fc2c437a0701e4)
rustc: rustc 1.96.0 (ac68faa20 2026-05-25)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261031/202610310455.KTHdfiRf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610310455.KTHdfiRf-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: drivers/firmware/socfpga-fcs-core.c:74 function parameter 'priv' not described in 'fcs_svc_send_sync'
>> Warning: drivers/firmware/socfpga-fcs-core.c:112 function parameter 'priv' not described in 'fcs_svc_send_async'
>> Warning: drivers/firmware/socfpga-fcs-core.c:197 function parameter 'priv' not described in 'fcs_svc_send_request'
>> Warning: drivers/firmware/socfpga-fcs-core.c:282 function parameter 'priv' not described in 'fcs_open_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:282 function parameter 'owner' not described in 'fcs_open_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:318 function parameter 'priv' not described in 'fcs_close_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:353 function parameter 'priv' not described in 'fcs_ctx_begin'
>> Warning: drivers/firmware/socfpga-fcs-core.c:384 function parameter 'priv' not described in 'fcs_ctx_end'
>> Warning: drivers/firmware/socfpga-fcs-core.c:417 function parameter 'priv' not described in 'fcs_get_atf_version'
>> Warning: drivers/firmware/socfpga-fcs-core.c:465 function parameter 'priv' not described in 'fcs_sdos_crypt'
>> Warning: drivers/firmware/socfpga-fcs-core.c:612 function parameter 'priv' not described in 'fcs_read_version_from_atf'
>> Warning: drivers/firmware/socfpga-fcs-core.c:669 bad line: 
   Warning: drivers/firmware/socfpga-fcs-core.c:709 bad line: 
>> Warning: drivers/firmware/socfpga-fcs-core.c:74 function parameter 'priv' not described in 'fcs_svc_send_sync'
>> Warning: drivers/firmware/socfpga-fcs-core.c:112 function parameter 'priv' not described in 'fcs_svc_send_async'
>> Warning: drivers/firmware/socfpga-fcs-core.c:197 function parameter 'priv' not described in 'fcs_svc_send_request'
>> Warning: drivers/firmware/socfpga-fcs-core.c:282 function parameter 'priv' not described in 'fcs_open_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:282 function parameter 'owner' not described in 'fcs_open_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:318 function parameter 'priv' not described in 'fcs_close_session_locked'
>> Warning: drivers/firmware/socfpga-fcs-core.c:353 function parameter 'priv' not described in 'fcs_ctx_begin'
>> Warning: drivers/firmware/socfpga-fcs-core.c:384 function parameter 'priv' not described in 'fcs_ctx_end'
   Warning: drivers/firmware/socfpga-fcs-core.c:417 function parameter 'priv' not described in 'fcs_get_atf_version'
   Warning: drivers/firmware/socfpga-fcs-core.c:465 function parameter 'priv' not described in 'fcs_sdos_crypt'
   Warning: drivers/firmware/socfpga-fcs-core.c:612 function parameter 'priv' not described in 'fcs_read_version_from_atf'
   Warning: drivers/firmware/socfpga-fcs-core.c:669 bad line: 
   Warning: drivers/firmware/socfpga-fcs-core.c:709 bad line: 

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

