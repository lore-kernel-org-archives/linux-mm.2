Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1E1C88E50
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 01:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1196B0099; Fri, 11 Sep 2026 21:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C6F6B009B; Fri, 11 Sep 2026 21:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69BE6B009D; Fri, 11 Sep 2026 21:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985916B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:24:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67FEE403AF
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:58 +0000 (UTC)
X-FDA: 85203366276.21.1B6096B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 732C5180003
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 01:24:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I73Ozs94;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789176296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6eWC2LYqppkKpq7EMVSyDw1KfCw2OmQu+q1Gz2f6VE=;
	b=i5h/lwu0YqC4TGkTJPYkpv4LY2VJXxMwBikeuDwi9bw+2u/ts2tw+HxvdyEtNP72LCQvr6
	8ZSG/RSC/SBrx+Xy7XuYPdOUVI1h0HM94cTWDb7Hpr2+YXcHYmr2g7yVd6g500vPR2JXuH
	CPlxaAGr02FLk+aHpVTj1/IPXkdqhc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789176296;
	b=peibFTaHsTb0WAxUllHB80NlYytt7ZS0cWb6D8dkWUyLrQWHPO/EIIsc1UrcUFfm8JYfnK
	G1tbY56bqoZiTEEw8+BDAGE7DXSN0ZKUcBUPqzaYC7RentFvrqhNWhBnVhS117f5QTFmeZ
	/SvzQZoQjOrHPlWhEvP37EVEBK09x/U=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I73Ozs94;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789176295; x=1820712295;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kWyKl8nspQAtl9ZLH0jHzigC1FX5K2ydejkIwl5FZXM=;
  b=I73Ozs94ZR80zrcuhAMEqK5NffcSGRMVcSS3FmIWSFzxB0oYyI2Dqxr4
   bI409nzfJ+rBx2D5GlX01cepU1bXPyDLFTJ8MRexoinSsVsvLrTO+xmNe
   c9gYI5RtYOz9+3fTN77QCrdRhtcNdD2s1XydY2pu1dj3AwUtlkpyoGSNz
   cm5R5qAAS5aufJCgVCH3B3Ve/ah1i2nc0kISC/RFDl0fZ54QRDN0KKtxn
   u5zZrVoVcvSTVF8tJIT0bpS1RhcVSbX3dWixfYSls5wlkMFFq8GdtAf4Q
   TPhcgJkD8f4QmMOM2xWJF3uJQB+yD8zCuJbvgZry6midUsEFlSW39NNPk
   A==;
X-CSE-ConnectionGUID: zNUkTeuCTDKi2FbV2zIcEA==
X-CSE-MsgGUID: 5mtiQIW9TEqmvZ+4YVCb6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="93337074"
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="93337074"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2026 18:24:54 -0700
X-CSE-ConnectionGUID: CQuzOJr2TEG9R/SXou2QCg==
X-CSE-MsgGUID: L2n3kEUiSQ+y/WITewQn/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,98,1787036400"; 
   d="scan'208";a="295565944"
Received: from lkp-server02.sh.intel.com (HELO 0a3643a6ed9d) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 11 Sep 2026 18:24:49 -0700
Received: from kbuild by 0a3643a6ed9d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5CTe-000000002VD-0ZI9;
	Sat, 12 Sep 2026 01:24:35 +0000
Date: Sat, 12 Sep 2026 09:23:24 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Ingo Molnar <mingo@redhat.com>, Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] x86/mm/pat: use pr_warn() for early W^X warnings
Message-ID: <202609120952.vcYnJp5p-lkp@intel.com>
References: <20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-fixes-verify-rwx-v2-1-e2cde39b6693@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 732C5180003
X-Stat-Signature: 4e4oj8gbujqn8xcocc9nok9b4tq9kioy
X-Rspam-User: 
X-HE-Tag: 1789176295-55943
X-HE-Meta: U2FsdGVkX1+B9lKVgkf2P2OV4KRDCAPU8K+BpCDxFSyKYxiDCDG+cJxXA3AIjr/ms5DRiFLpfzHhJUJKIZKYQK+646YwRQit/PWWCPxy37zwgzxRvUdNCdiZ6ttD7wIPTbMB5OVMvlrD2xGYILbDbXHqSRiP+rh3eSRNyNUpAC4rcw48bzzAeEGmTy7RcVVwgznNVVr1IK9ym4zPRTJ20dYspCCqzOJTmSICylDpwAI1TDr6DiEOmxMknLC72AHR4MLpp94ibryLNArWH1yOKe+TpqwHyN6zp3bxmcA7LM4D9GApxXyWr3KM5wicBabgug8UjRbvqhIy6+karfq875BqiRBlMmv8LXCDxb0B2+R3mdhrecUrjbJCKsmrHfEzXF2R09ZXeFyPNSLhq5CxUnz5wGHpzTCsOlgmjF6YIQss6f7gEvc50qeAQ6oSAurtsmnvnKQRJ2jn7hftSTKToKH1d//SjzaSdwUgc5JIc+yLkGZAOIiQhg2BCwdkSBCnSjKTFK1/tZkoTVmbQy8vFzvInROlJmUQTvIB14ANM0XH+61kh8RY/ICs57E4f1Ni1JZdm690sunumPhvwuqMPhCOofo0JssxHzEpKLe8K33yk1mK0tYkkxj1Q/wiKZeJ5JJYT85qZNm+RvxcMl1q8WvQIzAadhCQWAi/BHNWDNb9k6hIbSzKNeLyUXGm/eYwgi11Yb5Lo4mqExBRbadJkj0bsWOztvSQ6OihcX9g2GuMuIseDVaVyKjSKNht6kTKuiR1HxoQ8cbuL8jVmYDum11gND0TElqG9KglFzXepUJ5OSTYzbQPy1b07zw+CCmP5KKNCdHQOBYd6m1TFj9TW69YmeiPnPqKPmVTTCFlj1zHiheTxI8ZoK/hltbR/bhDGLVdWpJM6qgmzZ5bpUfexYK1YJMtk4CrKfslBcPbZNmBNPcjth9ZTQdNaJg3ATtkW5OCLBVzVWAYN7caFMD
 vY87zOd3
 eotReIcgwR+4vDRRoXtSpmVyEMSt8zWbYQPfRhZ3HBm0gf3C0B6CK4zWCcbLx0AAj0gl/+xJzIeKP8rO8yQ5VQVwMpzdHytZ8l8j9t6sUPDcq0N7uXCdzL3GOxj9ULKE74OjTvjx8Sy8YZBON4qof1b039KNpE7D8EBW2HLLcERPRUckZlyMTN2bDYt6Ieduc1bMMcsqHCOO2E4gVA3EL2F5OIWWD9bSKLirrT68H8QXUaDaHEabUm3HqCV9n+PZvSP0ZE35G2fDp1ukCexJmDNqfEIOzSDHJvZQWEYe6MygpYn9SdczlBpUocyMY5Cb8kEj2XWVi4H1bnMm6b3W+eEns3v6UzueWL+Bl2dG1Nf0T7iW1H4d72JyQmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

kernel test robot noticed the following build errors:

[auto build test ERROR on ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482]

url:    https://github.com/intel-lab-lkp/linux/commits/Mike-Rapoport-Microsoft/x86-mm-pat-use-pr_warn-for-early-W-X-warnings/20260911-142843
base:   ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482
patch link:    https://lore.kernel.org/r/20260911-fixes-verify-rwx-v2-1-e2cde39b6693%40kernel.org
patch subject: [PATCH v2] x86/mm/pat: use pr_warn() for early W^X warnings
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260912/202609120952.vcYnJp5p-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260912/202609120952.vcYnJp5p-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609120952.vcYnJp5p-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/mm/pat/set_memory.c:708:16: error: expected ')'
     708 |                 pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
         |                              ^
   arch/x86/mm/pat/set_memory.c:708:3: note: to match this '('
     708 |                 pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
         |                 ^
   include/linux/printk.h:669:2: note: expanded from macro 'pr_warn_once'
     669 |         printk_once(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         |         ^
   include/linux/printk.h:650:15: note: expanded from macro 'printk_once'
     650 |         DO_ONCE_LITE(printk, fmt, ##__VA_ARGS__)
         |                      ^
   1 error generated.


vim +708 arch/x86/mm/pat/set_memory.c

   667	
   668	/*
   669	 * Validate strict W^X semantics.
   670	 */
   671	static inline pgprot_t verify_rwx(pgprot_t old, pgprot_t new, unsigned long start,
   672					  unsigned long pfn, unsigned long npg,
   673					  bool nx, bool rw)
   674	{
   675		unsigned long end;
   676	
   677		/*
   678		 * 32-bit has some unfixable W+X issues, like EFI code
   679		 * and writeable data being in the same page.  Disable
   680		 * detection and enforcement there.
   681		 */
   682		if (IS_ENABLED(CONFIG_X86_32))
   683			return new;
   684	
   685		/* Only verify when NX is supported: */
   686		if (!(__supported_pte_mask & _PAGE_NX))
   687			return new;
   688	
   689		if (!((pgprot_val(old) ^ pgprot_val(new)) & (_PAGE_RW | _PAGE_NX)))
   690			return new;
   691	
   692		if ((pgprot_val(new) & (_PAGE_RW | _PAGE_NX)) != _PAGE_RW)
   693			return new;
   694	
   695		/* Non-leaf translation entries can disable writing or execution. */
   696		if (!rw || nx)
   697			return new;
   698	
   699		end = start + npg * PAGE_SIZE - 1;
   700	
   701		/*
   702		 * If the kernel text is still RWX, gently complain, this could be a
   703		 * false positive.
   704		 * Once debug_checkwx() becomes mandatory for CONFIG_STRICT_KERNEL_RWX,
   705		 * the warning can be removed completely.
   706		 */
   707		if (!kernel_set_to_readonly) {
 > 708			pr_warn_once(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
   709			  (unsigned long long)pgprot_val(old),
   710			  (unsigned long long)pgprot_val(new),
   711			  start, end, pfn);
   712			return new;
   713		}
   714	
   715		WARN_ONCE(1, "CPA detected W^X violation: %016llx -> %016llx range: 0x%016lx - 0x%016lx PFN %lx\n",
   716			  (unsigned long long)pgprot_val(old),
   717			  (unsigned long long)pgprot_val(new),
   718			  start, end, pfn);
   719	
   720		/*
   721		 * For now, allow all permission change attempts by returning the
   722		 * attempted permissions.  This can 'return old' to actively
   723		 * refuse the permission change at a later time.
   724		 */
   725		return new;
   726	}
   727	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

