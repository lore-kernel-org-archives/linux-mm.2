Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07BD7606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 02:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IqS9y7P3
Received: by kanga.kvack.org (Postfix)
	id D98A46B00A4; Fri, 23 Oct 2026 22:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49B86B00A6; Fri, 23 Oct 2026 22:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3B836B00AA; Fri, 23 Oct 2026 22:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 978F86B00A4
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 22:14:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4F1C140254
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:14:51 +0000 (UTC)
X-FDA: 85355901582.10.8BB092E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id CC8B7C0006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 02:14:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IqS9y7P3;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792808089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAuYor1soPIZA7EX+lfFc4BA32TSGeGLXRlLw71DcRo=;
	b=frwcv5H4M9svwuK82iY85zEyCGlqFAyd4gvhP3LO0OGLBeG73Wlr+L/XFum/iBp4VOA75Y
	jDrdEjWBPAwTerGolMfowQQxZmTAuYUe8EmIHCIitrisJza4JCxt9ggCLtHLn1zucOE8fO
	BFgyUHWtqLGOdO4JSSZaAtfkYac6kRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792808089;
	b=PoPFYlERluhpExEInSDxdlbbiSOg2gbrFpc0w0MTisYRWt9pCLosvn0lFPlpbeBRSt3CID
	QvND1w7BWsFfFaDhX/sEuEetxEpgLxq3tTooS7bT26FCZ0MipVxT4u/l08e2IVZ2GLKaiU
	oBm8/tBy82xc1TQWIWA0JZc1g49jel8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IqS9y7P3;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792808088; x=1824344088;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3vGAHWAWj47J1NUauqlbfdNw4l7B+4Puz5dEkbTphJg=;
  b=IqS9y7P3XVB416zVw/sj+1q3pJRuDIjiOlaUikMd78tD0HTfMv8JTb0x
   gf+wtKIO6RrvHTtmtjI34Z23pI5NrmCWVjrk6inkaRnao3Rf9m9p67FW+
   losQE7vr3cMZCWEA12XYFH8iZai8RAPuOntbHDhXLA0Z5OgrLaqWdrAlG
   FLiaEDPBOwwr+yOqmt//Je+bhNxt0qkfbdonzRh/C33NefFpGP5q+hON7
   DzZWpcTVY0P8wfKK3f2VtZzcntedJu9X/vOxFdUuc4bnmh0UNQXjTc2rZ
   tiM8UdYzKq1sVbtnsC/QUV33g6UEfLcrVuQiEO//pgMGKFawOKHT5sgfp
   A==;
X-CSE-ConnectionGUID: X2AlgkZ6QLC+zhVZxyeJcg==
X-CSE-MsgGUID: M2p/AOnlQHm3wCEShWlgJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1587783"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1587783"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 19:14:47 -0700
X-CSE-ConnectionGUID: 8mSKeHZjQkCC22iIBpRuVQ==
X-CSE-MsgGUID: meTqIDLFRqyS9kxVhu4S9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3710658"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 23 Oct 2026 19:14:44 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xKRHN-00000000TVO-1kwu;
	Sat, 24 Oct 2026 02:14:41 +0000
Date: Sat, 24 Oct 2026 10:13:59 +0800
From: kernel test robot <lkp@intel.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Kees Cook <kees@kernel.org>, Petr Mladek <pmladek@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Tycho Andersen <tycho@tycho.pizza>,
	Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v5 2/2] kallsyms: Don't leak pointers for unresolved
 symbols
Message-ID: <202610241049.9evBxlP8-lkp@intel.com>
References: <20261023-vsprintf_kallsym-v5-2-57ff92187c1d@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-vsprintf_kallsym-v5-2-57ff92187c1d@linutronix.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC8B7C0006
X-Stat-Signature: mmiix9dqqtmyp8xy44x44af1ygq3neo5
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792808088-5929
X-HE-Meta: U2FsdGVkX19BeirAwqgeRKt3PO6MyVCqMQnAggOAd2afRLGbz1Zb9n/bk/RgdUldAWDasVfI/c0SHGiF6zUQOy05+iIiw/NARmxRoGLsFzazObiVaxRVSdEDihSQ06BEGLz6/lCjqDsZDN6AyA/D5k143kwmaKqdxdbAd+R/5Fw7PTqfMx8WJggL1Q6rGHPw2FC9N15+TOBl3I+Gb+O4NgraL2yDz+3E7Z4YmMLOdm2o5uSmxz2VCiIWltToBSg82kuBkqkj/sxFd6q/w5shtXqw8z+xb8tQlLDpVkZDKgndwQOmdus5XnhjFFdY+19GWKYzgg0R4S7I3y1g6ArputltLrjp6aM2xs32ydDmMcm0ag0fFxGKomNshcC8Vk6jo4O1YSVQOQ3DvDaAkBA1YsqpnajqYDk4FWd2KBWxHHaoJs2DLLWiagGTfviffwU2NJg/WZl2Ny+fIo0Fhmx475jOOE5s1Ac2gOEhollX9YxZkoBHX90psvMWWSIAT7Zwy7miMpS1Pvex9riLdQ1+sOeJ6NOYgf2MUH39lS/1IcIApuRU/CDJxizpFt1EfAxY3esrIgESR/8S2xSQ4/jym+45HPVHUKQevjjrAFPwAFHVUaAwU3oJL+PizS8uaswov288WTxNPB/THinNReTOGWGUm+tpfvqbhZvFlcdj6OqmlfA70ghfHpHe+FPznyfFvYoOZzRjiUYFhUUXFLBKx/qrAjbT7srQHFjyWbZWsfxx0FvLusRkSoZGHM1ruaoOGXFJa/3Vw+LEn6uXCFrEnLrqZ3o9DZH9MmXHCD3kwo9+Xq/UBJcTr5TrLwzWAPg5zbFHs3yEUQhF+5aaZE8Fcqw5rFsr2uJJU31fYe4TT7MJ0K458mHhg9t2y/w0GpYcPpj6WEc8tzclPRVc0nmSflWAnmj3RZ/cmyCTOxMRvCibiuXO77m26kkRswS7GBBK5MnXsQa04YR75xGEhIW
 2/ZL/xlJ
 i2p5AZ2aaQuB0JUMDSJ51YVYWRNXyDhASaz/8l2+8hwejb7dfhPGYEbCrvyBHcosyiqHXWv05ugRNkeOmH20ABnKhhX81fzAiZfpLU8XPZUlZVKFNIxxF8Zh2N37CBSCOQzWenNCLmOu4Hl+lnIdbfCQX0rdo7l9AnN/r1iYrMso2iSBlA5oa4JhiJ9kYYznu43T7pSMwsSEZGOmgM1w6um/gkqaVsqahLOcxNoZeqxPzQOmJUBkXt8p/0m3ElfpE+GYz1HVYxY/XOBhJxSdM5SMUPYNgO99voBVOZJJq0jw54SBDSIaZcrzcdH+6CFgVuzy6wMa0ilnedqM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sebastian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 091b06388b117fefdcb63336ac09956a4914b961]

url:    https://github.com/intel-lab-lkp/linux/commits/Sebastian-Andrzej-Siewior/vsprintf-Don-t-leak-pointers-for-ps-without-KALLSYMS-enabled/20261023-184623
base:   091b06388b117fefdcb63336ac09956a4914b961
patch link:    https://lore.kernel.org/r/20261023-vsprintf_kallsym-v5-2-57ff92187c1d%40linutronix.de
patch subject: [PATCH v5 2/2] kallsyms: Don't leak pointers for unresolved symbols
config: sh-rsk7201_defconfig (https://download.01.org/0day-ci/archive/20261024/202610241049.9evBxlP8-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261024/202610241049.9evBxlP8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610241049.9evBxlP8-lkp@intel.com/

All warnings (new ones prefixed by >>):

   kernel/kallsyms.c: In function '__sprint_symbol':
>> kernel/kallsyms.c:486:44: warning: format '%p' expects argument of type 'void *', but argument 3 has type 'long unsigned int' [-Wformat=]
     486 |                 return sprintf(buffer, "0x%p", address - symbol_offset);
         |                                           ~^   ~~~~~~~~~~~~~~~~~~~~~~~
         |                                            |           |
         |                                            void *      long unsigned int
         |                                           %ld


vim +486 kernel/kallsyms.c

   469	
   470	/* Look up a kernel symbol and return it in a text buffer. */
   471	static int __sprint_symbol(char *buffer, unsigned long address,
   472				   int symbol_offset, int add_offset, int add_buildid)
   473	{
   474		char *modname;
   475		const unsigned char *buildid;
   476		unsigned long offset, size;
   477		int len;
   478	
   479		/* Prevent module removal until modname and modbuildid are printed */
   480		guard(rcu)();
   481	
   482		address += symbol_offset;
   483		len = kallsyms_lookup_buildid(address, &size, &offset, &modname, &buildid,
   484					       buffer);
   485		if (!len)
 > 486			return sprintf(buffer, "0x%p", address - symbol_offset);
   487	
   488		offset -= symbol_offset;
   489	
   490		if (add_offset)
   491			len += sprintf(buffer + len, "+%#lx/%#lx", offset, size);
   492	
   493		if (modname) {
   494			len += sprintf(buffer + len, " [%s", modname);
   495			if (add_buildid)
   496				len += append_buildid(buffer + len, modname, buildid);
   497			len += sprintf(buffer + len, "]");
   498		}
   499	
   500		return len;
   501	}
   502	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

