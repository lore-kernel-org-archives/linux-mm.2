Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132D9FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 05:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E40216B0088; Mon,  4 May 2026 01:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0036B008A; Mon,  4 May 2026 01:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06AA6B008C; Mon,  4 May 2026 01:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB51E6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 01:23:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53D8DC2DF5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:23:05 +0000 (UTC)
X-FDA: 84728593530.12.0D5FE53
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8347F80003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:23:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T7gtpGWA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777872183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=2ZY7hGzhah6uiTMRLC7SYZGiqkX8UzY7Ehp7srl6l0A=;
	b=ZKjXAf/8iN+qpNjsJNUbrw8fJHmvz8G57ZSKJFrMX3Qbh6iwbU7KLTaCP7aCmkmDXgZzva
	cmjlR2Eo0z5FMxjpOZXmzrMTdshdjOimGDKXV/M1aafT83KQokpsCxfCIznS/qKffl0Rna
	Zmzr5Mu3iuIHveChWY8XlGEmlBL7y1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777872183; a=rsa-sha256;
	cv=none;
	b=iLtM2HMMKaPCn+Omaz3UePQR4yZ3LFUnB0GZUn5y5w/Ur3psuS0tDOq/9FlGNC5Lw5aBiw
	1lsJh9b9Kirw7POX+x6RXWypHmnIfBM5biX5xfziOwDTcwtN0FbZedM2r9i2/py8cq2B//
	z+v+aQkGSqWzKSndlmZIC9rafj+7kF8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T7gtpGWA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777872182; x=1809408182;
  h=date:from:to:cc:subject:message-id;
  bh=p5/Q3yDR7BygkxggtgA8aFQtPso8EZC5q2sNYG0Rto4=;
  b=T7gtpGWAUsB0DdFzfVwwPyifxlKcEhODojRxONyuTt/Wk+2htN2IbN58
   OUz7qx3r7uqhIrkbj+lQvvND7XIFVG351BUVjUcPfkRB9EFix0erTkQNB
   Lzy1x/Yf2FL/GaRN5SsNJwqheV71C6jFft9I+KINmGtnUALj7PylSR/MT
   S5m8Wi5i4a1KRYoZzoar4Ahk4Vt6J+UtHu9mftXliLejw+1X1k9xwM7tc
   6TSFt+svFSmOUdpL/JmKD95qgS73leKEslg+4n6m/wYC1doAF57CH+FY2
   EYiJF2ZKdaDe9yystqXoIWKUzMGamXu/ZrAQU+8Tfdw7RYESk98brMA6p
   g==;
X-CSE-ConnectionGUID: TR6MBvNlR6aif5QFxCYY2g==
X-CSE-MsgGUID: dDqNUBwKT5qRjfMq5NRmQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11775"; a="78919938"
X-IronPort-AV: E=Sophos;i="6.23,214,1770624000"; 
   d="scan'208";a="78919938"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2026 22:23:00 -0700
X-CSE-ConnectionGUID: NHDQNX5FTRqCQJia1xqHdQ==
X-CSE-MsgGUID: cy8ul7rdTqid9W9mhdMQBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,214,1770624000"; 
   d="scan'208";a="265766197"
Received: from lkp-server01.sh.intel.com (HELO 781826d00641) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 03 May 2026 22:22:59 -0700
Received: from kbuild by 781826d00641 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wJllS-000000003Uj-3vtv;
	Mon, 04 May 2026 05:22:47 +0000
Date: Mon, 04 May 2026 13:22:00 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Antipov <dmantipov@yandex.ru>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andy Shevchenko <andriy.shevchenko@intel.com>
Subject: [linux-next:master 14086/14440] lib/cmdline.c:188: undefined
 reference to `__efistub___lshrdi3'
Message-ID: <202605041353.nsZSMiIC-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: 8347F80003
X-Rspamd-Server: rspam04
X-Stat-Signature: 36gn31nrno7ipckwx7381jnau3o5rutk
X-HE-Tag: 1777872182-153275
X-HE-Meta: U2FsdGVkX19LjWCEhP9/eKn8BDKk8h5l4xFagJzu2to/zHtjjOGLlLloHEIjFOm6ldB7TxseFJmI2V5l4ksLjAKH0ncb/md68273DP2ATJHrMSvAdYrtBKKH1YAAjkBlpbB2vmlfmEXaO4VcrgnGgpBM53v01uyjgY39qh6Jf25KiLusjyPQGiQyJMr9sjSvcShJMrLQCGYHxg0y4NZv/yevjygpniKmCiEyyEqiK0Oy8T6ZejR5WMtsN2s89OoYSikv+NYENSqdej/5eJsObatK1UUHpQcGV7zmXTdvQ6CC5uHg56QTmY9EHGiSBppJuudag+gtAVKjlpZUCq+X1EXY3qTfEqZ+vNaLEdf2XaxVawOr+mOZugxvlGR/byrPKKfkeyiUxX6h6NLp4iyMZP3A/vB7iNaND55CKRxqgLOknHXwghjHb67XnGJ2csNk5YwgnARUqAjmK2YZAm9OmMGk5cYFo0XJuiTDdJPoKAkB4djklMepCMaupTEntcCUNzbjno8g7o0tX177xgdrOHXUtqHRlG5hIyJSXX9VugnkDjVdHeq1WBCPN7w1gCaroW2XXihoypqbtDjTLQbXRcYrF36lRs1MXrwJiDlI3e69qTeJRoSH6hddO3SPCN9YVRWSwGquc9R+Ma8eFbolbnMms/9K2rLsjdnl4pHIr8X1zjSI3hvolTjjaGfS6mjlrPYaYZHw4v1AEWywSNkrSXb43fpkfqLnPqrqwgm4roSzRwSekIvIWQTDJjyPOr5InvUcvchHQJxNp9i10jq7KrSivr2fTLFbUiPCN583D0vk2OPgicAxs8fwa/6YiJPy2VCE3kXwck0NCJXvQv3k8Mm2mf6BHCzCJMAEoIGtiTADeO+sPfP32E4SsbLz75662uMRYKZV+1xpBD8uiHL09txEqY3k5rUAx2voNn93flSgR11zJX+2wXjkiFOmso8ZOiS2iNIE/S9u6WBETVm
 e2/jpZG0
 ASDVQObaC3etJe9PFmClQd1/PMupI2J5jF37sa3wDZqZ+mP3rkvBIna0xxiA+pSY2KPVNm2nNvMkHbp3XZyXS51k7mF1d/sI1QVtB1B5ZBwZpgktQaKeeyiI/NayRXMklbv4qKv1CnpYNjQOd08HRby/iC+SmZFLIemqUkWA9AWmtO8NEK8/nONlOVTg0NJwPuoyjM2T7s0m4B+Jj8f5mkJ4vILxjVyhZwUAeq1ZFD6A+cSwQ7TUPkGWJXImQ1jz5JRc843+GKFpObSgs8kIbYcMpy76Vo6DGlQo4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   b9303e6bff706758c167af686b5315ad00233bf8
commit: 7f448f913d6f048e448df40a877be6f5afb5249d [14086/14440] lib: fix memparse() to handle overflow
config: riscv-randconfig-001-20260504 (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260504/202605041353.nsZSMiIC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605041353.nsZSMiIC-lkp@intel.com/

All errors (new ones prefixed by >>):

   riscv32-linux-ld: ./drivers/firmware/efi/libstub/lib-cmdline.stub.o: in function `memparse':
>> lib/cmdline.c:188: undefined reference to `__efistub___lshrdi3'


vim +188 lib/cmdline.c

   140	
   141	/**
   142	 *	memparse - parse a string with mem suffixes into a number
   143	 *	@ptr: Where parse begins
   144	 *	@retptr: (output) Optional pointer to next char after parse completes
   145	 *
   146	 *	Parses a string into a number.  The number stored at @ptr is
   147	 *	potentially suffixed with K, M, G, T, P, E.
   148	 */
   149	
   150	unsigned long long memparse(const char *ptr, char **retptr)
   151	{
   152		char *endptr;	/* local pointer to end of parsed string */
   153		unsigned long long ret = simple_strtoull(ptr, &endptr, 0);
   154		unsigned int shl = 0;
   155	
   156		/* Consume valid suffix even in case of overflow. */
   157		switch (*endptr) {
   158		case 'E':
   159		case 'e':
   160			shl += 10;
   161			fallthrough;
   162		case 'P':
   163		case 'p':
   164			shl += 10;
   165			fallthrough;
   166		case 'T':
   167		case 't':
   168			shl += 10;
   169			fallthrough;
   170		case 'G':
   171		case 'g':
   172			shl += 10;
   173			fallthrough;
   174		case 'M':
   175		case 'm':
   176			shl += 10;
   177			fallthrough;
   178		case 'K':
   179		case 'k':
   180			shl += 10;
   181			fallthrough;
   182		default:
   183			break;
   184		}
   185	
   186		if (shl && likely(ptr != endptr)) {
   187			/* Have valid suffix with preceding number. */
 > 188			if (unlikely(check_shl_overflow(ret, shl, &ret)))
   189				ret = ULLONG_MAX;
   190			endptr++;
   191		}
   192	
   193		if (retptr)
   194			*retptr = endptr;
   195	
   196		return ret;
   197	}
   198	EXPORT_SYMBOL(memparse);
   199	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

