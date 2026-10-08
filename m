Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D74DCA6002
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 01:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A946B008A; Wed,  7 Oct 2026 21:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C456B008C; Wed,  7 Oct 2026 21:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22266B0092; Wed,  7 Oct 2026 21:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98CFE6B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:12:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D1C412040E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 01:12:26 +0000 (UTC)
X-FDA: 85297683492.14.547CD2E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6452140008
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 01:12:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jgycTBaf;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791421944;
	b=78DV+xJ/hXTtTipBC35uxaamjOc6PJ8DEZzG1FK19JxYdbBwpX6TJ3eyOhnjXnmQ6cpKrS
	kERGzbntO3gL+7vgpU6fb1CQfoEP/Kw5U7bYshYAnQN9eDk/nfrcL1wZ+iVZPewWV3Saog
	eqOCAt7BpL18+W1TfGTzBRXC+bvHAYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jgycTBaf;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791421944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ma3Wpv/xFZ2DYFigamcqVz1quneqsnZuTQFwReuOHBw=;
	b=lW2Sc2SACB9QBM+KvQQ8pGpUfBzQ3r+o3n1ZFjgAz3Aqb2L/okCvVncV2WnVbGZi25hVia
	mb0++/qT9qY5Zf6Lvz2M0x9syvnUD7Wp8/xaXC3ela91aHTjazvi0mkw1hPq0WFr2WnjOi
	q2pGNLX5tX0GEXu05LFG48RPXUTby28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791421944; x=1822957944;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Z5ybaKWBPOL6QX0nuxqg9f/Zcrh90lwNVkVMjmF3vBo=;
  b=jgycTBafwF5SR/EfTLGCcmxfOO3fcFi+lLqt0Uizprf9FO4d96KYOOav
   MaZbGhjHhSGw1OL0wN6BDf2vCoBIcnR7pBlnL1+ZMYbAMOaL9mS4t+LI6
   w3sEljqUB/IG1S1qw0IWbtTF2SeXY4F0BWrff6aAHYOmw7x6zFCdvudwC
   7YkCMV7rkWdDGjWy7ZWwNtmy1nAUdX0tCoLOkupyyX/J41OnreY7MDSxR
   Kgh2MFKVpAiV3IlZe6t/+v7kTMHUgAOgEELM5my50FyQURXdfUo03ZYWU
   YIKJUlLjyGCriFt19h2GRQ05wdTWPGokFcXMAYaHViQ/Ke8W3H1tU7BC6
   Q==;
X-CSE-ConnectionGUID: y31q5iDnS9umMjVzIM9wug==
X-CSE-MsgGUID: VjWEryz+RTGdjF4ujS9KKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="83120"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="83120"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 18:12:22 -0700
X-CSE-ConnectionGUID: ZGn9PKkVQWa98h1ZNrPAwg==
X-CSE-MsgGUID: cqNaiWUXTz6lTxb/IDpp+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="285685618"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 07 Oct 2026 18:12:18 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEcg9-000000003oW-3MzK;
	Thu, 08 Oct 2026 01:12:13 +0000
Date: Thu, 8 Oct 2026 09:11:19 +0800
From: kernel test robot <lkp@intel.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode
 sanitizer
Message-ID: <202610080827.zfszZlVj-lkp@intel.com>
References: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev@linux.ibm.com>
X-Stat-Signature: pgnmw4n84nsxhk8zgsf5pxwtc4cqs8h5
X-Rspamd-Queue-Id: 6452140008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791421943-42388
X-HE-Meta: U2FsdGVkX18f14mPA2REGVoHeTpPM+aAzhp144WC1RZOBOBFtiuVnyJOEo6LW3e2/obhY2uGhS129MGvPE1yYTzltZJQ/pZfWE57YbpxTzx5apmc3ORXcEHCdq5xoRVQIbQGCw/9E784OS1KRz9q8phvY1daaUYP/hf0viEzqL9l0OgwbQBNQAD4r5NQGtI/eh8enveFmtYhkQCwZ1fMaiPWqYrl2aceXQwLzATVdPQzPktGTD8wZ/PaFMwhRfOPOTkcaKdULe01yMQ+uF2bNgKnTvMLU87pzI6PHHXuftlzRMNMK1ZDpgcOALL+lyr8fndi8SMNzjX9D9afu090ErPk0u9JLsWtDH7IdjReENoxA5VnDHj49/G3L7fmy8JHisqhclinNUu6Sv3wFPSOBMVwserNxIu8/aeyT5E6Q4L2gKGdIDaSk7aepFN1t0awz0bXML9fVXCU2IJrC4YbRDxZrDut04ylzAg2uxYHy74K20ksVSAeiRdWMsbckFc9YaYAiMU3BSnvVPxlfH3bsQxYg6Kq5GWFUpYgZrvYa+X7JZgzd4RnPDGdLwYavUUUxEiJ1oU7mBaRLqycPYWB7GUFmXMUwi9s4/ItIf4ynozlsqmRRYs4+YpIRgIm8lKQZG5n/pBg5O4ghFNORdi/PmD7z9MNwAmRN9WjVGSGvdt9/XR8zXrLVUtMcRIIMPb/su/shXAK+aNGEMvPX7cJtBUGrRDyKlAGfhm47+MoJUyWG44Qawg9kegGHalhU72LBseYm1hqFqUfnv+O5Qmc5XDFybJkC5/Tv2t0hK8YpI4qvDYljwogYGTcyojiCBu05DBWFg4pPh85pC/AU/4utjs+fZp8hWJh9juNASAFz38bs/grMt7+xXHMKW3gacyGjnOBIqr6Cv9I50FJ1oDaXdE6FXWa4Tz1WtMcmSAwDywxmLKCXpQopKnIk5//wk4X2PbpAOLr35Ztdhzi5xI
 z7qPnhIy
 DduCnwoKKq0C8XZ/VBN+DlhEoOgIOtqYLevNvND97G9yag/Whk6LsMH6RbaMv+NWynAmzuvqNueq4R/MHWpN9gqmckdg3mURdoy1mi8tIrnpxhVCEnzq7my0RSPuhshucNyjAOLIE/+OLEUJlElB4NV/9BUFs/6g7eu2SEyOIxlt7iRAwgzmezvWo8M2/ipReO1sjUgkbA8iC04Nn1qVwZnftb6nAajLzauEpFawbTIseUW221QyswxlNF9wDO2EoN7p9T1h30SQ+eW914OxGzUh3p3INS3msw64W7Qy3TFTb7JnNcrn2K3cV4TA47dFjoIghgtb3Mtk5Op0hJ+iRIIjQJSxNl8pBeAk9hFzAIi0A7zhS3DmPDh+cnnybjRlqfGEBX07YG63XMnA8Br03XptzT7vvsuSjzfOmg/9p9+V0Tg0OXLLdmYCTm7gXE3cJ76Q3PAmbgKzggdk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alexander,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v7.3-rc6]
[cannot apply to akpm-mm/mm-everything s390/features kvms390/next next-20261006]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexander-Gordeev/mm-introduce-hw_pte_t-for-PTE-table-storage/20261007-134144
base:   linus/master
patch link:    https://lore.kernel.org/r/e42d9f02ec1f8478a50fce424b95d0e7ff6a359f.1791365932.git.agordeev%40linux.ibm.com
patch subject: [PATCH v8 14/15] mm/kasan: Introduce helpers for lazy MMU mode sanitizer
config: mips-maltaup_xpa_defconfig (https://download.01.org/0day-ci/archive/20261008/202610080827.zfszZlVj-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610080827.zfszZlVj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610080827.zfszZlVj-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/hardirq.h:17,
                    from arch/mips/include/asm/hardirq.h:16,
                    from include/linux/hardirq.h:11,
                    from include/linux/interrupt.h:11,
                    from arch/mips/include/asm/highmem.h:24,
                    from arch/mips/include/asm/pgtable-32.h:22,
                    from arch/mips/include/asm/pgtable.h:14,
                    from include/linux/pgtable.h:6,
                    from include/linux/kasan.h:9,
                    from include/linux/slab.h:276,
                    from include/linux/fs.h:45,
                    from include/linux/compat.h:17,
                    from arch/mips/kernel/asm-offsets.c:14:
   include/linux/irq.h: In function 'irq_free_generic_chip':
   include/linux/irq.h:1211:9: error: implicit declaration of function 'kfree' [-Wimplicit-function-declaration]
    1211 |         kfree(gc);
         |         ^~~~~
   include/linux/slab.h: At top level:
>> include/linux/slab.h:595:6: warning: conflicting types for 'kfree'; have 'void(const void *)'
     595 | void kfree(const void *objp);
         |      ^~~~~
   include/linux/irq.h:1211:9: note: previous implicit declaration of 'kfree' with type 'void(const void *)'
    1211 |         kfree(gc);
         |         ^~~~~
   make[3]: *** [scripts/Makefile.build:185: arch/mips/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1425: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +595 include/linux/slab.h

7bd230a26648ac Suren Baghdasaryan 2024-03-21  594  
72d67229f522e3 Kees Cook          2021-11-05 @595  void kfree(const void *objp);
af92793e52c3a9 Alexei Starovoitov 2025-09-08  596  void kfree_nolock(const void *objp);
72d67229f522e3 Kees Cook          2021-11-05  597  void kfree_sensitive(const void *objp);
05a940656e1eb2 Kees Cook          2022-09-23  598  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

