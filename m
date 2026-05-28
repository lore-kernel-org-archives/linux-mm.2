Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A119FCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D911B6B0005; Thu, 28 May 2026 04:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D412B6B0088; Thu, 28 May 2026 04:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58C06B0092; Thu, 28 May 2026 04:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B3E9E6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:59:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EEA21A07BC
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:59:16 +0000 (UTC)
X-FDA: 84816229512.05.212A8FA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9839B1C0006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:59:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NxCJUoT0;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F2/D0i9CIHBPJRDcF9ZZbBMESDywgruN21U0o4opk4s=;
	b=BslnOzUeXK/oTlmN6hh4mp+1qKuSynjXJr63ApAUPsJA6N+zMaiLyU/v18TaLtT0PLwDER
	u4Ert8KYW94ea/fmMD6taDv0rzd7oxCg6xQ7XjNkc71D3dI1fALrOg8MBR9HasT54UluRg
	+1HLHWD1SuWQy+p2Z4cmKLSX4mKdY6w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NxCJUoT0;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958754; a=rsa-sha256;
	cv=none;
	b=We8twZBYy1Cn2fjMJ1Y/DSWoLZl3fPCzRy5M6EJR8PYM1KXpgm8YH7CGoPSe/dxCA6d+a/
	x+7Rie/GY9Q1ugeXtvBfj99ig4W3KXLMI/bdvprUb1NSEcj8fw8NCQ1a4ys7WjAIz7EVIX
	npnVFqy+hop0IaIt0iNlE4dR/i4z9fs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779958754; x=1811494754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yITXz7miJoKkLJkFy0JeLjTGaWJ0V8x8RwQLEqHLRmQ=;
  b=NxCJUoT0tlOcTg5GKrePmhiZh0C/6K383KAH1W2ojOmygeb3MA7I5xWU
   Y7KhplM2jmGgdsZTeKF/JPZtQgFF2JfaqVFqS4DJStwl34G3libpYiP0T
   FwuMRb1J+oHegaKdkG57waf9IRZjR3pFUtVRwi6HQnfDPDkus0DScMXaD
   3+Pgs/lSYy6Nmw8SPGnSPc7ibkp8voqo6o6pVic+CDFEG6nRZEEa6IVe3
   IXMbmBcN7OeosD5QXF96xUBCoL6Sj2+j2mFgKcAReGpS0KCm5VYQJT9vm
   tx7yqPAjcf3E/9sn6vI+nq1huu5MC6fW4QVDut2w7vWMLQth2eHhlpAPL
   g==;
X-CSE-ConnectionGUID: kEH1T308QNK+SJvcA33ILQ==
X-CSE-MsgGUID: o5yy/myMRs2gj3ysvB3KwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11799"; a="79946326"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79946326"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 01:59:12 -0700
X-CSE-ConnectionGUID: OWoJ8s+vSmKaooVbl3p+sQ==
X-CSE-MsgGUID: R+cGajzlR9ql9VHI5YnIIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="246523117"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 May 2026 01:59:07 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSWa0-000000005l0-1tso;
	Thu, 28 May 2026 08:59:04 +0000
Date: Thu, 28 May 2026 16:58:24 +0800
From: kernel test robot <lkp@intel.com>
To: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kasan-dev@googlegroups.com,
	bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <202605281629.y8HhAihO-lkp@intel.com>
References: <20260527070239.2252948-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
X-Stat-Signature: 9kw6pxcxkawu6rfc7ebm8zfmxww3hxbz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9839B1C0006
X-HE-Tag: 1779958753-717724
X-HE-Meta: U2FsdGVkX1+pEhdaVQL2HHfvogL0sIp0BVkp0OiKZ9VzBai9oOWcafDUPTb0OTkiyc2Esf6a0+gQ7gxYok+Du4lYrjD+qAPy//niA0eoPy5IQD1Plm8LlhU1a2xj7P7MuDyuUtqgWW5Pi6553D8cv5Ng8VGd7FgXFHacvUQmwypIMJ9cGLT3oWoXKmh+lUp91DSzez9IHIi0DJAaVMPQZneYUUVSSEONsM/OOCHbU2j/4QXLCQZnYHowYcEx/GIbiz8Ij7l2IV6sRxTdxLs2+SZ2jn0+lb6zUq+CjW5zgAye7cA9gT2b6L6z3SnGDxTxB5t4O4L/YlRtikDyjEjq2BBrXW12k7e1yr9A7TbnVspALzjtz40IME0kv/YVpfHzhx9WM+5Qla+Jm+W6TleLZ4rv0jM0NQZMBvfzAB69vIueV7jula2yutJIZB00Z9qnS7BXFvHb4AvRBDzTO+WzLMBO5SmsOyk2SEIDC3X4OnS3WyNj6Z8bMSteWRxegxkMHAxOknN6ZFDaLxvSIy8TWzl3diEDrddVc8c9qRwjUamWHWPCQnmLHiWOj7iaFY7NDBmivKa62JvUe9CZdoTt3zfGDcG9pCIG9owwHREXP4hmk8dIGuf4EU0WkPpcLZOY2ven6FQ0TGpF6W0rCoGZwb5Vp4o2aFGA2wtbl3J5pKVltmRWA35WrT1CaQ/jJWNM18FPj3Ea3KF4em7K+ss0Pc5l85KmaVlxhuiEpliHr8u8fbrJY+hmYMfb2Pgl9ohu3aOQ1EpVmv3R74B65qD1g69FNf2IFlvcaywHOifo7slnyE0s/ot9vXf12vNLFs9MYX6Cte9YRTKdT0PRPMfdGytveSF0M2WHda9i8vJsxohXAy82ZnIxvdW3iBZUJ7kLYa6TggJQmZsy5+jCN7Jv3sZXoF5Cj1rfh5Y1WClYmC/3ulP2LBr8z9CAbBcsoUISZOONXHsokcu4UxcFl8X
 a6gQgjIV
 SnNS4O7dZejzYqJiMUDZGYBkf88TjE0P0tC1sORG4ji+rwidmP3Ivd2LDYI8lxSOQMlkVXNxc+xxFD0+DiCw35m7BzbtMtRtVcM05C+p4z0bvdIapORp2AKUkmWXT8Mc369GhSfpzYLMtbeqoGUNefa9CRZrxhroy+MKUJc3KvJgRrv4VHyMU71s53itxEup3lTQpGucG4ltWRJQ2p9ioG/2Aq26bNrwPmmA4k+890GdBDbKaXvYJEkTmtzkSrrQ+pZH8qLC5Xz6wKNWR5SOfZD761GaxBuaJNDmpD86WsSNGaJ6Y5K/WU9EGXe1sMJ8V1f1BQy+SDrjfkJZoDYzI5FGjZCqw+XGM0OosmXbnfIUMd8PzAvIrfwtjOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christoph,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Christoph-Hellwig/mm-slab-improve-kmem_cache_alloc_bulk/20260527-150421
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260527070239.2252948-2-hch%40lst.de
patch subject: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
config: parisc-randconfig-r071-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281629.y8HhAihO-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
smatch: v0.5.0-9185-gbcc58b9c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281629.y8HhAihO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605281629.y8HhAihO-lkp@intel.com/

All errors (new ones prefixed by >>):

   lib/test_meminit.c: In function 'do_kmem_cache_size':
>> lib/test_meminit.c:239:29: error: 'ret' undeclared (first use in this function); did you mean 'net'?
        kmem_cache_free_bulk(c, ret, bulk_array);
                                ^~~
                                net
   lib/test_meminit.c:239:29: note: each undeclared identifier is reported only once for each function it appears in


vim +239 lib/test_meminit.c

dc5c5ad79f0cc2d Laura Abbott        2019-12-04  209  
5015a300a522c8f Alexander Potapenko 2019-07-16  210  /*
5015a300a522c8f Alexander Potapenko 2019-07-16  211   * Test kmem_cache with given parameters:
5015a300a522c8f Alexander Potapenko 2019-07-16  212   *  want_ctor - use a constructor;
5015a300a522c8f Alexander Potapenko 2019-07-16  213   *  want_rcu - use SLAB_TYPESAFE_BY_RCU;
5015a300a522c8f Alexander Potapenko 2019-07-16  214   *  want_zero - use __GFP_ZERO.
5015a300a522c8f Alexander Potapenko 2019-07-16  215   */
5015a300a522c8f Alexander Potapenko 2019-07-16  216  static int __init do_kmem_cache_size(size_t size, bool want_ctor,
5015a300a522c8f Alexander Potapenko 2019-07-16  217  				     bool want_rcu, bool want_zero,
5015a300a522c8f Alexander Potapenko 2019-07-16  218  				     int *total_failures)
5015a300a522c8f Alexander Potapenko 2019-07-16  219  {
5015a300a522c8f Alexander Potapenko 2019-07-16  220  	struct kmem_cache *c;
5015a300a522c8f Alexander Potapenko 2019-07-16  221  	int iter;
5015a300a522c8f Alexander Potapenko 2019-07-16  222  	bool fail = false;
5015a300a522c8f Alexander Potapenko 2019-07-16  223  	gfp_t alloc_mask = GFP_KERNEL | (want_zero ? __GFP_ZERO : 0);
5015a300a522c8f Alexander Potapenko 2019-07-16  224  	void *buf, *buf_copy;
5015a300a522c8f Alexander Potapenko 2019-07-16  225  
5015a300a522c8f Alexander Potapenko 2019-07-16  226  	c = kmem_cache_create("test_cache", size, 1,
5015a300a522c8f Alexander Potapenko 2019-07-16  227  			      want_rcu ? SLAB_TYPESAFE_BY_RCU : 0,
5015a300a522c8f Alexander Potapenko 2019-07-16  228  			      want_ctor ? test_ctor : NULL);
5015a300a522c8f Alexander Potapenko 2019-07-16  229  	for (iter = 0; iter < 10; iter++) {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  230  		/* Do a test of bulk allocations */
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  231  		if (!want_rcu && !want_ctor) {
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  232  			if (!kmem_cache_alloc_bulk(c, alloc_mask, BULK_SIZE,
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  233  					bulk_array)) {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  234  				fail = true;
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  235  			} else {
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  236  				int i;
863d4ee245fb4d6 Christoph Hellwig   2026-05-27  237  				for (i = 0; i < BULK_SIZE; i++)
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  238  					fail |= check_buf(bulk_array[i], size, want_ctor, want_rcu, want_zero);
dc5c5ad79f0cc2d Laura Abbott        2019-12-04 @239  				kmem_cache_free_bulk(c, ret, bulk_array);
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  240  			}
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  241  		}
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  242  
5015a300a522c8f Alexander Potapenko 2019-07-16  243  		buf = kmem_cache_alloc(c, alloc_mask);
5015a300a522c8f Alexander Potapenko 2019-07-16  244  		/* Check that buf is zeroed, if it must be. */
dc5c5ad79f0cc2d Laura Abbott        2019-12-04  245  		fail |= check_buf(buf, size, want_ctor, want_rcu, want_zero);
5015a300a522c8f Alexander Potapenko 2019-07-16  246  		fill_with_garbage_skip(buf, size, want_ctor ? CTOR_BYTES : 0);
d3a811617ae629d Arnd Bergmann       2019-07-16  247  
d3a811617ae629d Arnd Bergmann       2019-07-16  248  		if (!want_rcu) {
d3a811617ae629d Arnd Bergmann       2019-07-16  249  			kmem_cache_free(c, buf);
d3a811617ae629d Arnd Bergmann       2019-07-16  250  			continue;
d3a811617ae629d Arnd Bergmann       2019-07-16  251  		}
d3a811617ae629d Arnd Bergmann       2019-07-16  252  
5015a300a522c8f Alexander Potapenko 2019-07-16  253  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  254  		 * If this is an RCU cache, use a critical section to ensure we
5015a300a522c8f Alexander Potapenko 2019-07-16  255  		 * can touch objects after they're freed.
5015a300a522c8f Alexander Potapenko 2019-07-16  256  		 */
5015a300a522c8f Alexander Potapenko 2019-07-16  257  		rcu_read_lock();
5015a300a522c8f Alexander Potapenko 2019-07-16  258  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  259  		 * Copy the buffer to check that it's not wiped on
5015a300a522c8f Alexander Potapenko 2019-07-16  260  		 * free().
5015a300a522c8f Alexander Potapenko 2019-07-16  261  		 */
733d1d1a7745113 Alexander Potapenko 2019-08-02  262  		buf_copy = kmalloc(size, GFP_ATOMIC);
5015a300a522c8f Alexander Potapenko 2019-07-16  263  		if (buf_copy)
5015a300a522c8f Alexander Potapenko 2019-07-16  264  			memcpy(buf_copy, buf, size);
d3a811617ae629d Arnd Bergmann       2019-07-16  265  
4ab7ace465466d2 Alexander Potapenko 2019-07-16  266  		kmem_cache_free(c, buf);
5015a300a522c8f Alexander Potapenko 2019-07-16  267  		/*
5015a300a522c8f Alexander Potapenko 2019-07-16  268  		 * Check that |buf| is intact after kmem_cache_free().
5015a300a522c8f Alexander Potapenko 2019-07-16  269  		 * |want_zero| is false, because we wrote garbage to
5015a300a522c8f Alexander Potapenko 2019-07-16  270  		 * the buffer already.
5015a300a522c8f Alexander Potapenko 2019-07-16  271  		 */
5015a300a522c8f Alexander Potapenko 2019-07-16  272  		fail |= check_buf(buf, size, want_ctor, want_rcu,
5015a300a522c8f Alexander Potapenko 2019-07-16  273  				  false);
5015a300a522c8f Alexander Potapenko 2019-07-16  274  		if (buf_copy) {
5015a300a522c8f Alexander Potapenko 2019-07-16  275  			fail |= (bool)memcmp(buf, buf_copy, size);
5015a300a522c8f Alexander Potapenko 2019-07-16  276  			kfree(buf_copy);
5015a300a522c8f Alexander Potapenko 2019-07-16  277  		}
5015a300a522c8f Alexander Potapenko 2019-07-16  278  		rcu_read_unlock();
5015a300a522c8f Alexander Potapenko 2019-07-16  279  	}
5015a300a522c8f Alexander Potapenko 2019-07-16  280  	kmem_cache_destroy(c);
5015a300a522c8f Alexander Potapenko 2019-07-16  281  
5015a300a522c8f Alexander Potapenko 2019-07-16  282  	*total_failures += fail;
5015a300a522c8f Alexander Potapenko 2019-07-16  283  	return 1;
5015a300a522c8f Alexander Potapenko 2019-07-16  284  }
5015a300a522c8f Alexander Potapenko 2019-07-16  285  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

