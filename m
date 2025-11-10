Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F8F5CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8C28E001A; Mon, 10 Nov 2025 13:40:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 041CF8E0002; Mon, 10 Nov 2025 13:40:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73E28E001A; Mon, 10 Nov 2025 13:40:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBE1C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:40:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7AEC9140259
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:40:31 +0000 (UTC)
X-FDA: 84095563062.30.5CF1E5B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EBC9140006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:40:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WYDXDUGa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762800029; a=rsa-sha256;
	cv=none;
	b=F7Q9w0f9CtiZQII43E5dXeukhLjRsaHnFPVU53rlq1pTuPajo95o0Q1yimKMiXpIdY9v7X
	0jbjdqJxQ+qsIeNkS+GaqAmY+X8pNYNv7T6ju0IbWIXuBI90lYWcW60ylZqzE06ODbw7Pe
	GzwTexV3QWfcAGGVKuKNieix+QnZrJQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WYDXDUGa;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762800029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dlSniQZ0oOvfWSn+qXd8yePFNbwcXUVL9Adnx7ZsAg=;
	b=4wsA9GNSwm4vEUPOyCJ2ESR8ukyv3JIKQiL0RrvDOB4jcFYanjjvRBh+0NUncuN7NBO/FZ
	nAZdWvuHrd32sQQXKp2Bg33dP8XlpebGKBQBNU8hy9cMnw2G3Ajl3VoZg4CpTe9HcCX82B
	cLYJ8E05raI1EaTJEY5N2arOd+Yw2/E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762800029; x=1794336029;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ITmLWXo3e+y1YebPOYiecUwtXc4FTLTE2wV3joWNNbY=;
  b=WYDXDUGa9yWcchvKpCgDelGpelTumAEqJYi8EO8YkPhqhbvPgmtKsyLk
   IkQ3Ao+80g9o6ZD1wgJNsKJD6GJHyaCbAssomX552Rch3fxZfmdvZjaQL
   B4IHvWJhfbJZaeE6U0uHXoGRXFbeWljMZDZHRr5vAiyQvP7J7T93WiOyp
   4rYDh4GwsvfkBUc9tgy4bH9H6Z59phpwNLyBRXh96+88VK76gA+4mIB8d
   wuuTALd74rz/CAj91VyVhqdS87bt/rvUnCLxyG9e1ElrCKzDMyjxTlsCl
   3FRvMqGUxlowGpqmPQSKsKi8f+sDnr+azHrmrv2HhiJ+rH0G98FQrC7g+
   w==;
X-CSE-ConnectionGUID: bzl+CUiIRpeT+NQZUN5ELQ==
X-CSE-MsgGUID: yihqNS4/TwqojrV5DUHdCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="68714354"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="68714354"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:40:27 -0800
X-CSE-ConnectionGUID: bQyQQdPqS06MzEkKcaNRTg==
X-CSE-MsgGUID: 13XDg5qEQ9qhGAA2/QwwsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="193747970"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 10 Nov 2025 10:40:23 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIWoP-0000rb-1k;
	Mon, 10 Nov 2025 18:40:21 +0000
Date: Tue, 11 Nov 2025 02:40:06 +0800
From: kernel test robot <lkp@intel.com>
To: Alejandro Colomar <alx@kernel.org>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Alejandro Colomar <alx@kernel.org>,
	Marco Elver <elver@google.com>, Kees Cook <kees@kernel.org>,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Michal Hocko <mhocko@suse.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
Message-ID: <202511110204.IxlIobdQ-lkp@intel.com>
References: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9EBC9140006
X-Stat-Signature: fsxjq3azukp36ecid3hkzt9qkq78qf9s
X-Rspam-User: 
X-HE-Tag: 1762800028-109804
X-HE-Meta: U2FsdGVkX1+BGxMjcWqE8ihKq7xcyLp/Qf74F0eb/c6yYCQ/XE25kcHlUyP82v3VZAwAT6zgrkq+EKjChovA8dCf2smD+Qe43BXNn1TsPWtEKYve/tllYqe0WcmHFnqJxDLqVzKezDdTQDxaFBgOhWp/iP6dGhQ+lP4iPs21Bmc5zxJ+X3ayIsf3nBXHnvg4LqGFIzIM6CU7t67EAh1OPR4jEDCM2+fwbiCpqH1sTIjsUAQLAqD1Sk7Tkl6i7XYZJlqvyOZDCFEIsomug00cgAUzgp5ClwcRvEuoUk8Wr44E0f0VjQ1AKZ+XjqkALR6Kx+E/PBpJEQ446liGwlVMM+826buIcD2uYnwTabaqjz/t3jvuiy61CbGVcsh6gvmo3znkaQDrowzVgHbC31hmjihxCqCsfDQ1K4sI2JlZy5vN8rrAmuVqlCBeiRHwlg3NCKgEyIQzRoCvfjXzekA3gUp0ZRD8Gna1Ydch8jqMiddgrZwz0Oy/A9ybhkCHlCV2NlLtN3x8OHZwj/ZgpUlAMK+ata8sTIV9FJBs9ngAdZPq4BTRlVB8mfwlSIUZtekying3GjAo0uC+B08ccxIIQUsBozclK5U3Gs4XRsbURLH8Ip04FkNHqLwcpCqSMKLuJmi1YVGwBNBCpSszzzRY4YDcwDHLXPtTlnYtDa7UGHtj8KSecMAYs6vpVwCY95ut6Pi77vRZES1PWewmqeUKZBi27neaEG40tLDhYsJTBrSMwUjrf1gP3QHw3xL4VMavlo+tZGDxuvcpiBoGuNvU+T38ZEhsbD0BbwWuk5l8IiG5lLGGHwwtv1JizSE0AjB0c1I8pz9n9UCvJ6hlZ73VyYPfPeqwS0h1sBvCMNOsGUC0cMqZSg5UWuC3ceTU+ysL33H3nDK4G76Ys2q4fYi+OnyEatZ3827P+iTuaveawHVFvlw2b+Ga62DYZyN5eMbQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alejandro,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on kees/for-next/pstore kees/for-next/kspp linus/master linux/master v6.18-rc5 next-20251110]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alejandro-Colomar/array_size-h-Add-ARRAY_END/20251110-075203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx%40kernel.org
patch subject: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251111/202511110204.IxlIobdQ-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251111/202511110204.IxlIobdQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511110204.IxlIobdQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/kfence/kfence_test.c: In function 'report_matches':
>> mm/kfence/kfence_test.c:113:15: error: implicit declaration of function 'ENDOF' [-Wimplicit-function-declaration]
     113 |         end = ENDOF(expect[0]);
         |               ^~~~~
>> mm/kfence/kfence_test.c:113:13: error: assignment to 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     113 |         end = ENDOF(expect[0]);
         |             ^
   mm/kfence/kfence_test.c:143:13: error: assignment to 'const char *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     143 |         end = ENDOF(expect[1]);
         |             ^


vim +/ENDOF +113 mm/kfence/kfence_test.c

    94	
    95	/* Check observed report matches information in @r. */
    96	static bool report_matches(const struct expect_report *r)
    97	{
    98		unsigned long addr = (unsigned long)r->addr;
    99		bool ret = false;
   100		unsigned long flags;
   101		typeof(observed.lines) expect;
   102		const char *end;
   103		char *cur;
   104	
   105		/* Doubled-checked locking. */
   106		if (!report_available())
   107			return false;
   108	
   109		/* Generate expected report contents. */
   110	
   111		/* Title */
   112		cur = expect[0];
 > 113		end = ENDOF(expect[0]);
   114		switch (r->type) {
   115		case KFENCE_ERROR_OOB:
   116			cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
   117					 get_access_type(r));
   118			break;
   119		case KFENCE_ERROR_UAF:
   120			cur += scnprintf(cur, end - cur, "BUG: KFENCE: use-after-free %s",
   121					 get_access_type(r));
   122			break;
   123		case KFENCE_ERROR_CORRUPTION:
   124			cur += scnprintf(cur, end - cur, "BUG: KFENCE: memory corruption");
   125			break;
   126		case KFENCE_ERROR_INVALID:
   127			cur += scnprintf(cur, end - cur, "BUG: KFENCE: invalid %s",
   128					 get_access_type(r));
   129			break;
   130		case KFENCE_ERROR_INVALID_FREE:
   131			cur += scnprintf(cur, end - cur, "BUG: KFENCE: invalid free");
   132			break;
   133		}
   134	
   135		scnprintf(cur, end - cur, " in %pS", r->fn);
   136		/* The exact offset won't match, remove it; also strip module name. */
   137		cur = strchr(expect[0], '+');
   138		if (cur)
   139			*cur = '\0';
   140	
   141		/* Access information */
   142		cur = expect[1];
   143		end = ENDOF(expect[1]);
   144	
   145		switch (r->type) {
   146		case KFENCE_ERROR_OOB:
   147			cur += scnprintf(cur, end - cur, "Out-of-bounds %s at", get_access_type(r));
   148			addr = arch_kfence_test_address(addr);
   149			break;
   150		case KFENCE_ERROR_UAF:
   151			cur += scnprintf(cur, end - cur, "Use-after-free %s at", get_access_type(r));
   152			addr = arch_kfence_test_address(addr);
   153			break;
   154		case KFENCE_ERROR_CORRUPTION:
   155			cur += scnprintf(cur, end - cur, "Corrupted memory at");
   156			break;
   157		case KFENCE_ERROR_INVALID:
   158			cur += scnprintf(cur, end - cur, "Invalid %s at", get_access_type(r));
   159			addr = arch_kfence_test_address(addr);
   160			break;
   161		case KFENCE_ERROR_INVALID_FREE:
   162			cur += scnprintf(cur, end - cur, "Invalid free of");
   163			break;
   164		}
   165	
   166		cur += scnprintf(cur, end - cur, " 0x%p", (void *)addr);
   167	
   168		spin_lock_irqsave(&observed.lock, flags);
   169		if (!report_available())
   170			goto out; /* A new report is being captured. */
   171	
   172		/* Finally match expected output to what we actually observed. */
   173		ret = strstr(observed.lines[0], expect[0]) && strstr(observed.lines[1], expect[1]);
   174	out:
   175		spin_unlock_irqrestore(&observed.lock, flags);
   176		return ret;
   177	}
   178	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

