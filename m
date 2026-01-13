Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68575D29DF7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB076B0005; Tue, 13 Jan 2026 04:40:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8C66B0089; Tue, 13 Jan 2026 04:40:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7D06B008A; Tue, 13 Jan 2026 04:40:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A46D76B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:40:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A434C04EE
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:40:56 +0000 (UTC)
X-FDA: 84326446512.26.3BC2F48
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA37B20005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:40:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TUBZ7Rki;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768297254; a=rsa-sha256;
	cv=none;
	b=cU2U7YT97MKsZNPwqHmoiBYHiAfU4J56J/vqtnoVaKmS4KTLEToTiqLaVCPP9kN1fm6IlK
	idOD9XaeLciWVbcj7QDBTM9awPsGJd3/503Bxz7oCKRXtJaUEp5r5SDYkYjmekZNzvSFAP
	oL80+Xfly75HEZT6G40JQ3NrL5MJfR0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TUBZ7Rki;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768297254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pDgTzqLTSyKP1tsdp96od7LtCDRced+eXF8PuSdTelo=;
	b=BYWVPDkGDjSJfLVg/m9hSCRSzp+rPuk2udxRsiUOHp6zL+VqHILa00Re2xKTQ7mwKwvEoe
	V0yWBjLq1YFfCpYUUTib6YNSkSSkktKaEFbahk3g56I3YWEM47NbVtfBUCmaPdeNY8BY65
	kBuSyusmaGs191UGAKUNzZQ6nrs4seE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768297254; x=1799833254;
  h=date:from:to:cc:subject:message-id;
  bh=UDNaW7Sn4obq4whRUbXRQozD33l0Xm4m3Sj/R6DL/rs=;
  b=TUBZ7RkijVITWYQN95V1kR+bIAjQIMQ/IPHa+yjNprtsvFtgV2UiVro3
   7TYWA8y5/KBpHdj9S1Nxh7pTaFZPypoXgcEHC2gJkBmUedKgH4wHWJmQY
   yfkn77bmsT2KpezbHC367Zo8GzKd2/5gDrhfOxlX39pzaR/dPo+5sI2LC
   PlOv6zJPyoauLDw0ECxrQuxOZTwjMw82nafGN4tqo8EhbaFH2KkdpijlZ
   IJjBgEsL2DL88Haq7IdUanJG0czEfU5O4UotmTvp49fqDItRZgeAW00FD
   6feIAgxbnAehWrxEr5+6c2i2HDobAPHLnA//jgeGCRjPuVat9xSzzkRJA
   Q==;
X-CSE-ConnectionGUID: q04CIK8eS2K/uWkda5EvGw==
X-CSE-MsgGUID: TJIyGaV0SYOoFdGAllnvwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="80944380"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="80944380"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 01:40:52 -0800
X-CSE-ConnectionGUID: 3facd3uCQAK5rlyj7ZiwjA==
X-CSE-MsgGUID: ccwhKksfQC+RIInLyIw0Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="208808986"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 13 Jan 2026 01:40:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vfatM-00000000EYa-1s9T;
	Tue, 13 Jan 2026 09:40:48 +0000
Date: Tue, 13 Jan 2026 17:40:47 +0800
From: kernel test robot <lkp@intel.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>
Subject: [akpm-mm:mm-new 283/303] mm/kasan/report.c:674:80: sparse:
 sparse: cast truncates bits from constant value (ff00000000000000 becomes 0)
Message-ID: <202601131757.U5JRrwbH-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: DA37B20005
X-Rspamd-Server: rspam06
X-Stat-Signature: 4p7s16rst6u5s9s4j6pow63p9dssoe9i
X-Rspam-User: 
X-HE-Tag: 1768297253-386384
X-HE-Meta: U2FsdGVkX1/wt9Pvo7Y2UsnCOz5miUvejUjZ8YAMI4lz/9eiuPl7OvbMomwu3rB6GJg2MRCEWbnIY4lKN7o2kYhAFGLCSLU6ubIRXbJuemXRWwvLft7bSbg8vhdBcYlO/1byMeY+OoM2dt7znGvFDjRLAZJUgvMBFmPeb4yCSbk5so9sonZD0xSKyIHyLVd/vncnYH1+w3AmHRsJOuyzl8124mnl9NShV3pW5qlNgrFFbuBKYoRdgipN/cqli9HyAWPGwlF+uxE/MzLdQzshI7VUrAfHF1NWpsXmR4HepF/VzRoi6tTv1wXmH/nd2N0+6KeqkYNMQ7n+JHWyig4Apb/bZUlFuN7IgHRVu2YY/dwqu1ruqzMrydbonDZIBsryb0bVQm54g+S4HruwNxr6oR1nh9v/hHRkrxU5jDanggd81IfquUHQEnRvr4W+jrVWdTkGAgHxLEPf7gwKI907AUEqWh62BxxegIDu7rE1gWia5etceibMXfla0WSo57NSA1FCEyLHfP9KttLvCfvBu+I6Z0EYJEcfqrHvmGeYfsh3/ytf3ldIjf69WJAPOS2fkxEJqLQ+aeUfzqUZx+0rWH1npuBtGdjIBUXpoKLDwnDy5VZOq+OF3Wtq05rgqe/9EZkgQLejXm0duiD8j+Ig+uoZ18N2dnRMksxrMcceoOl8ydu0tFtkPozQd4f5n+oXfqOLrSkPKhXQ6nUprks694z9ZS/XwQlzEZiNE4AifDqbTbFPcmCwazfP3cA+yJFckirF2n0oA+KtpPVPDs1+Lzxyw5r3hvJ0xmqHQikD7qfgtarSHKMp+NaN3YUOespDadk8dJ/kg0/sJfEzx4Ovqarsdfzd2H7NlOzgMq9KO1PzR5rZyxiHlmbHZ37Ze3YDimtFVhwqMuaruwkezAbNsX7Pn1Lyg4wpZCzJx+JFUA977xmRlWUG38Dx0TLgIXDXJfGARekvIEP7RuYbi+j
 cnwMGi51
 LhBfgzzIVumdP74ie4AQD6MQMd5joJtc33hPRKq/asZpIUjZAcuIVCsxc5jcM2tL17Qe0lNtxTBueedk5NNOlymIQPf5bRi71fRM1bEpSlFPYyHqelzqtpZ79ulmHilEFyrUoQ8Usugvksprui6DQFuAFReD3gJ2o0J0wXSRFPaNwE5eNr7CgKwpozevFBfoBVebrRVH2E8XL2FKpKDp8Ju6W1Jasr9b1ONEoFT2tjnZTFMhJGKundPPDXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   abb8eb84b7bb668d982e556b2b19f0e3ac42c591
commit: a63f13759f21f65c96a77ad92773d94162380948 [283/303] kasan: sw_tags: use arithmetic shift for shadow computation
config: powerpc-randconfig-r132-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131757.U5JRrwbH-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260113/202601131757.U5JRrwbH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601131757.U5JRrwbH-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/kasan/report.c:206:13: sparse: sparse: context imbalance in 'start_report' - wrong count at exit
   mm/kasan/report.c:225:9: sparse: sparse: context imbalance in 'end_report' - unexpected unlock
>> mm/kasan/report.c:674:80: sparse: sparse: cast truncates bits from constant value (ff00000000000000 becomes 0)

vim +674 mm/kasan/report.c

   630	
   631	#if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
   632	/*
   633	 * With compiler-based KASAN modes, accesses to bogus pointers (outside of the
   634	 * mapped kernel address space regions) cause faults when KASAN tries to check
   635	 * the shadow memory before the actual memory access. This results in cryptic
   636	 * GPF reports, which are hard for users to interpret. This hook helps users to
   637	 * figure out what the original bogus pointer was.
   638	 */
   639	void kasan_non_canonical_hook(unsigned long addr)
   640	{
   641		unsigned long orig_addr;
   642		const char *bug_type;
   643	
   644		/*
   645		 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right shift
   646		 * and never overflows with the chosen KASAN_SHADOW_OFFSET values (on
   647		 * both x86 and arm64). Thus, the possible shadow addresses (even for
   648		 * bogus pointers) belong to a single contiguous region that is the
   649		 * result of kasan_mem_to_shadow() applied to the whole address space.
   650		 */
   651		if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
   652			if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
   653			    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
   654				return;
   655		}
   656	
   657		/*
   658		 * For Software Tag-Based KASAN, kasan_mem_to_shadow() uses the
   659		 * arithmetic shift. Normally, this would make checking for a possible
   660		 * shadow address complicated, as the shadow address computation
   661		 * operation would overflow only for some memory addresses. However, due
   662		 * to the chosen KASAN_SHADOW_OFFSET values and the fact the
   663		 * kasan_mem_to_shadow() only operates on pointers with the tag reset,
   664		 * the overflow always happens.
   665		 *
   666		 * For arm64, the top byte of the pointer gets reset to 0xFF. Thus, the
   667		 * possible shadow addresses belong to a region that is the result of
   668		 * kasan_mem_to_shadow() applied to the memory range
   669		 * [0xFF000000000000, 0xFFFFFFFFFFFFFFFF]. Despite the overflow, the
   670		 * resulting possible shadow region is contiguous, as the overflow
   671		 * happens for both 0xFF000000000000 and 0xFFFFFFFFFFFFFFFF.
   672		 */
   673		if (IS_ENABLED(CONFIG_KASAN_SW_TAGS) && IS_ENABLED(CONFIG_ARM64)) {
 > 674			if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0xFFULL << 56)) ||

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

