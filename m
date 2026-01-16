Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A9DED4A612
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 08:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4C56B0088; Fri, 16 Jan 2026 03:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862316B0089; Fri, 16 Jan 2026 03:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760DC6B008A; Fri, 16 Jan 2026 03:41:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64DAC6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:41:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EB1B51AE82F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:41:53 +0000 (UTC)
X-FDA: 84337184106.23.C4C3F0A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38093100003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:41:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NA2puf5L;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768552912; a=rsa-sha256;
	cv=none;
	b=gvjMKmyAnOq2Iz0b66aZjVMgaP7hh6EvkflsuYfQ2qosaRTKd0DeEYcYQI8a/qSUyXdYrH
	SEP7H2PSTtDvNhgh7kkSTKErn8eGiheVgIstVyA5VMZUQjv6wx+izSq95AV3YkLxBcRYyh
	dxKXx1xNr0n55q8yJxLx4Aze40AEobg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NA2puf5L;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768552912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g0b+tAL22FLB4QQVjvMaPVszLezBXvw++FYaa3vkGt0=;
	b=EIX7gImHqBzl1Ss/WsN1akCkTE69uVvfFuAchaE8UMnseDRgBm4VD9FYDJjy7ecFGF0wEC
	jr+v1fSfrrPpIsSaIWgj3J5LtgdB7QdBEVdMWlGk01pzoig9einEzYCy0zkkKsHfBqc4+g
	oySoaJKtTGlNMylyG5x7xlVd288Ymew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768552911; x=1800088911;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=O+/cTsTJq5uXcDrgkLiW5OYMeBlhObkDglOH9bffLrM=;
  b=NA2puf5LGigfm8D9wjrGXU5xLEmFW2Rcvp2bH9ZO9Y9LFQ8TksiTkyqU
   rIcC9SqUHR6MiROFSScgRUIBGVZj1d8n/bmcT0zNEIQsPN/vAZilSXd4D
   pjFuy79Me9cqbBf8OlK8hv6+njKEYRGRv/Qn6gdJ7TsbzsBL2GePNftfT
   ImtQIhT4QWVKu51euXmsLWGkceAoIGhDbfBxQ7mNYEtewSf8XGqv6euoQ
   93RhY/HVRNtst05mz5lDXmdjRqrqt3i20s6p8PaH/SOMnDWHSkIQ4ItGX
   t/LiXmaZIQcgW6VcG5/znGzPx4cjPWg2KRiOXoeU7h7l4X2WXOBzos5dA
   g==;
X-CSE-ConnectionGUID: HbO7dR7MSfyx+wW0dtm33A==
X-CSE-MsgGUID: sAlhPfp1QeegS6m0oxlQvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="68875472"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="68875472"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 00:41:49 -0800
X-CSE-ConnectionGUID: ohoL5vfpT0md1YMe/hX2Uw==
X-CSE-MsgGUID: 8FqSe5K7S8+0pcn5KueR3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="205648506"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 16 Jan 2026 00:41:47 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgfOr-00000000Kb2-1k0J;
	Fri, 16 Jan 2026 08:41:45 +0000
Date: Fri, 16 Jan 2026 16:41:32 +0800
From: kernel test robot <lkp@intel.com>
To: Byungchul Park <byungchul@sk.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Pavel Begunkov <asml.silence@gmail.com>,
 "Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen"?= <toke@redhat.com>
Subject: [akpm-mm:mm-unstable /301] net/core/page_pool.c:713:71:
 sparse: sparse: incorrect type in argument 1 (different base types)
Message-ID: <202601161606.8RuyUh2k-lkp@intel.com>
User-Agent: s-nail v14.9.25
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38093100003
X-Stat-Signature: msa37ap66ezq5qcmuosh57gxy8g6z4eq
X-Rspam-User: 
X-HE-Tag: 1768552910-48464
X-HE-Meta: U2FsdGVkX1/Of59r2+AaUBcNnUdQXVWq0ynB42o2ez+V7Sa8dKLcaibgUFp4z7LENADjKII7vzo6Ta2EhJ3Du1nXyChIxtZjWxCXvDN1B5EHfn54bMgouVowRelnXHpSur3PeeOlaAMheWTwsfs5HByeZ6SNQqeckAFtEIVQLPOZDt0CFBytdbyyXQgQttOr4+pNfkiSNfXgLCiEWFwAQsu+fQd30xR6xG1pVbbYca8GLfgx+Vh5Ozjs98WnLsXCYmIpP4Xfi9D1K7rdmciXgd7c5jbLQ4Kw1uVRoS9F3AP94UxWCj4zXaGzelD4IaqFrDcDjhLAhqZTEeQjDU2Dt2IPTuf5FHHR7vmD2CQNaz8R9jHZARrBJPs2IXsUgS2ww1e4dWF6D9+kcYN2nNsWrnUiXx/OrC5tQvllT+bFmKC/2W6g9KJ3O6Luf9lTzR3HjTG1A+WQAmigHiHQpeBhvY+HzdRV3bg3s0yEljeISyexxC5KozxGpAI+MnaqnEeebJ57b/9BiXRS0k6348/MEOCTkhomdyftyMd7juoGjqfH7Tnz7REMvSusiv2DtvxijdYLRzHxbX4uUDjKTvY7WWpmcGO1mvvZi1k2EisP7bGKtoD2daqjrVGmISD3OpIlkaf9Q4akaOzpKNjMJtG+YeHmu+5nmS2iw0WnVTLS7PSh/IXdI6V7/oE3LEPBgesoKVD8OhyyIaF9YehtiLq47HT9SHmEiA2fwzlCaD7kwRv7gf4Q1L9A8qUaCgrL0PkaJW0HQX7DmCAa3R04bUa+iJzbfHYJJ79uM6FcdpVcaZ4iu8OV0iDjaqmEZEkvjtl0MxWOk7xz+JrTLSvHQbYtSoeTMMVMiQ5yrnd4iG+RTRJeco/HABwfmNusy7YM8PiDOrbCJ8KFeA+j0jOwsMtEOeDU7GMrME5/T7Y6jvTd4jEyjBRhZwkcBa1XPjj8158EqJ4skUwiHgPzutyZMp2
 7qSlErq2
 KtB9j8OLPTo8ztOUEzfu+QcGNKqh4YDxRffkKjQWrU86fFRQwZ3yyiEvpbH2KGksf3pCcIFDzX9vHSh2vAn1hhWNw1eGKcBA0jdDaj27HiWP0kvKBh3M72Ce3/Z9fOnRCYZorOVMrCyfT/dGJxAjXhazflg+9vbHCknV+Ol2EELrTwdUMhKlCL3yd67+w0svv3EjOeu0qWBIYbGaictQZpjb6r7sDnWCy74KamOf9mGaBnbv+MRwrQ1iRDMI/WkxdjUsCHdNUqHQwVAXNaHbVgoimYWjBwuxt2cYU4cNWTflOBsWBYMQbgG5q7WxVQPdZ9Bqhm9u8+1TcfMvrcKtFjMupr87D2s42pa6muXXZj8XjPpIhGIDRMLel6U+oE7rSlsY5c9JLvfe/Hxk3R8YJHCVD89W8xyAa7XcU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   fe2c34b6ea5a0e1175c30d59bc1c28caafb02c62
commit: 7699fe82442a62ea29a3745b29dbb8ef8c42d8db [/301] mm: introduce a new page type for page pool in page type
config: x86_64-randconfig-122-20260115 (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601161606.8RuyUh2k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601161606.8RuyUh2k-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> net/core/page_pool.c:713:71: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
   net/core/page_pool.c:713:71: sparse:     expected restricted netmem_ref [usertype] netmem
   net/core/page_pool.c:713:71: sparse:     got unsigned long
   net/core/page_pool.c:734:73: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected restricted netmem_ref [usertype] netmem @@     got unsigned long @@
   net/core/page_pool.c:734:73: sparse:     expected restricted netmem_ref [usertype] netmem
   net/core/page_pool.c:734:73: sparse:     got unsigned long

vim +713 net/core/page_pool.c

   702	
   703	void page_pool_set_pp_info(struct page_pool *pool, netmem_ref netmem)
   704	{
   705		netmem_set_pp(netmem, pool);
   706	
   707		/* XXX: Now that the offset of page_type is shared between
   708		 * struct page and net_iov, just cast the netmem to struct page
   709		 * unconditionally by clearing NET_IOV if any, no matter whether
   710		 * it comes from struct net_iov or struct page.  This should be
   711		 * adjusted once the offset is no longer shared.
   712		 */
 > 713		__SetPageNetpp(__netmem_to_page((__force unsigned long)netmem & ~NET_IOV));
   714	
   715		/* Ensuring all pages have been split into one fragment initially:
   716		 * page_pool_set_pp_info() is only called once for every page when it
   717		 * is allocated from the page allocator and page_pool_fragment_page()
   718		 * is dirtying the same cache line as the page->pp_magic above, so
   719		 * the overhead is negligible.
   720		 */
   721		page_pool_fragment_netmem(netmem, 1);
   722		if (pool->has_init_callback)
   723			pool->slow.init_callback(netmem, pool->slow.init_arg);
   724	}
   725	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

