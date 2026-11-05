Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E36A606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Mzk93Mp9
Received: by kanga.kvack.org (Postfix)
	id 3B6C36B05B1; Thu,  5 Nov 2026 10:16:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 341316B05B2; Thu,  5 Nov 2026 10:16:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230186B05B3; Thu,  5 Nov 2026 10:16:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F15256B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:16:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76F87160A58
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:16:24 +0000 (UTC)
X-FDA: 85401416688.15.70C3CA7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 991FE120016
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:16:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mzk93Mp9;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793891782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMjn8XjiAzeUPvVw/+o83TJlFUPnqRfLNFAmNRdAxMk=;
	b=l6Ju1mSGV4HeWekVBty8vKq/KyhbDKZWVFE2WTxHRxscZVDQWe0f7btKU7r26N05u4ELdQ
	Gf9UHJRgMBGee7RQYOF3LJYh3duNsajoUQB2Tk7cvnQ3SxPrbFQOwVv8jb3JkSC2ZJmEqg
	N08GnpZTPmfh1Np+RuWwAyMjuu0oqIE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Mzk93Mp9;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793891782;
	b=MlWZ0jg3Uus1Bwtsskx4EF5Eqk2mrQNdvicgkjKnzEe9EKt3BxDUuc94FKBNETe73LVcc6
	2XfNlYNxKYCg3tatPujeKjk137lSLGL6XtVhWQcpHCYi5ARDUqJZqYk582UYcYk83I5hMD
	lh4INRlBicm8sEyaQRzVEWerULJfvvI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793891782; x=1825427782;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rU8SrDDryY+CYHj9KsFi4pCuuYIXMwEz4SCd8TjDdnI=;
  b=Mzk93Mp9uA999Dh33t8o56BFh+wU4C122WMfOOb17dlls2t1QVpayzCZ
   KoZhMBoD1ZXJ8U8ziciorVCzGNv46GcSS4dWiekO8KLVQ2/7N/6xa9eAR
   8oclFFd1Dq9nuozK9gnCa1LFTeD3QXUwwfVhJrBQi8sdBGgCiNguwSB1t
   Cy/D05RETkh9T34W/Gtw8GDoi4BxIAzSoJru+dGht3IXKP4xeeObP7w05
   dsvK33GKzw/1PDsjPryQEml4mIfXYdqPO4pDz5l6XpTBq/G+UrsnmTkfC
   Q8XRVnHEh/g8Cm6Xw36p94xCX4sSWDZ3beGQ6hMiqNHYtpFLNSRGm6Ls6
   A==;
X-CSE-ConnectionGUID: QCqFzJ9YRZ+dvsu1ltoVrQ==
X-CSE-MsgGUID: /izhY6T9TTiMIOEOtl6+5A==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2593747"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2593747"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:16:21 -0800
X-CSE-ConnectionGUID: bm+wbRSvRO2M5N2cjZGNDQ==
X-CSE-MsgGUID: UJYW7TIAQwe2gmUnKJ9jBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7193564"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 05 Nov 2026 07:16:19 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOzCJ-00000000mOh-3sHN;
	Thu, 05 Nov 2026 15:16:15 +0000
Date: Thu, 5 Nov 2026 23:15:33 +0800
From: kernel test robot <lkp@intel.com>
To: Abhishek Bapat <abhishekbapat@google.com>,
	Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Abhishek Bapat <abhishekbapat@google.com>
Subject: Re: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
Message-ID: <202611052344.mDV2DB89-lkp@intel.com>
References: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat@google.com>
X-Stat-Signature: tfuj49jyuqz3ib14ng3oam76um1p9t5w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 991FE120016
X-HE-Tag: 1793891781-871549
X-HE-Meta: U2FsdGVkX18aitFuI7P/XP2pHlW+TlaqJi7cz4wGV4HefrIXEiD0kSvQ9XBNTYKGlHvskoGWWJTktcmTL397hJOZBBxp4oe1jasZ4wFAAZkF/GFG9RwMdc4nJH2hx57u/M/jezj5r5C6jG3fxn2zB0rN0uOmqRltNM+Kt0QRYTRAlWuEuxjiNzi/+2X+l5H4IvXC7CkxbdUhxWgSusXOEUh1+XHodvAOVLKMz8g8rWHsngex3La87BJdb+cn1XHwmUtIl2kZylKR+0FLslWawmqvwLXvYk7AxwYrao8WvnyFRqt+NECqyXA1g9hhBIk0+Frq/JmCM00ym4N611Mghn0mru/lWuT76YbWgkuXNQ3AFjy+QIOprBsCWfbFHToJd+Yua3A3goK14AcWTIhInjfCWHDx1CpzoONC2xefpUtlPuUgpw5ITMZZtpqgIGvoId3qVceA9NsQLpbTgRO7sJdRyqSVlYRamXJCNq8BNoayTrezhZP0Iv8XmCXd64D9PAbuQJNr0EWLyBTMKRdCpEQvunrP3EVHAXfIOZL5hYY53q9RRPO//TviroKr3/xh1XwriCudv74LI1PpMiIzMVuLbJdfN9xI9yvVXmqsbl6gKcrIkswChB4fIDaXunWo7LJw7/xOdk6kSqSiVhgLykuW7xEr+Vr6YkSdG2js3p18zDhTJ8/ELE+w71YefY74Fnr63wAOepwys+X4xKwgmkUOo8o32S2oq5giZnEqHsGp3Ks3U90reduevaehQBWf1EhbmlBekNUxhIa+jQjs8GsOEfJg5MdlU24WndkBjAUKEhxpzRz0JzsFqdaTQKeNRXA2wS/1FENJBx5v7H3YVngs8mapXKIEX2wGfWmBvME6Qv4zjnqhJN6J9Br+EezUOdJNcP0WbmscQ1j04fmS8Esip6z2SG6MXJTmClvhA4rerzuFGo7ViyqcpaxI0ZA9Sh4ZB3WJpMDda0lJYe6
 eZzvTHxJ
 Yl1h2aJArHppX9vCX8vKcDLpTmfYRDWM2zliLCf4ePHJBo8SsKK88P7BG+wtOG3BxEUwSHzXzB939gZ6NuulKTX2JsBq2CkjSN85lRe169g2UXrTCY/D04ngykzXClrXuGB47jahHGt+IyJWHhgOcYDOEc8z9PlHs79f6ON4wLGH10XDRtzTtVp2Vd5EgbIGcwGC08mg07MM7hF0QMspp1yIPuvMvb/HvAadfK0M1fmlSn3UeEglrRv8eIL+Fb8+RTyQiN+bt1Rqf0aV34pwgQpcyU63zpQ1d9sYs+NwYCbFHw2e8m2rEVD8Xfa+cx9s6Hj2oyifExtCMoVwZ9qyYqeTEMNEYS4+w6GYy2Jpcjs1G8YDZOsjJW7SqvijgDm5AxeTZ64XHTjZEL2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Abhishek,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bcc036cfa1670a64500f6d857eaa71908b79e3fb]

url:    https://github.com/intel-lab-lkp/linux/commits/Abhishek-Bapat/alloc_tag-Add-trace-events-for-tracing-allocations/20261104-190336
base:   bcc036cfa1670a64500f6d857eaa71908b79e3fb
patch link:    https://lore.kernel.org/r/37ae7dca766994d3872fcc65b623a80d5d506369.1793818636.git.abhishekbapat%40google.com
patch subject: [PATCH v5 2/5] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
config: xtensa-randconfig-1001-20261105 (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261105/202611052344.mDV2DB89-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611052344.mDV2DB89-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: alloc_tag_trace_enabled+0x2c (section: .text.unlikely) -> initcall_level_names (section: .init.data)

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

