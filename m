Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B597AF4BB73
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71286B0088; Tue, 24 Feb 2026 13:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EBF6B008A; Tue, 24 Feb 2026 13:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44106B0088; Tue, 24 Feb 2026 13:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0B626B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:54:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57B7D1401BE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:54:12 +0000 (UTC)
X-FDA: 84480250344.10.185EBDF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A382180002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:54:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=La9gLvfa;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771959250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Oa1KzXnkF7xmNHvrWFtHyV6rmQKfhjodK7mykEUJTk=;
	b=j/pLguwYRLTDLv3s1op+rHLysmVkIvGuqiJxFL6tWOomMTMUQPUmZl/nNHa1QfVCcOqMRY
	HV5YpvrCmTlI4ys1FJZz/HfdH6Bb5BRHwwtRaiSALij0A3QxHGRUBnAC/wRyJ8+KNr9lUh
	TtxbZBQNlnTCD4aCq7Xh4zDS0A8BgNc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=La9gLvfa;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771959250; a=rsa-sha256;
	cv=none;
	b=MrdXt+JgoIiCM+leA9+lLKnmKUNK0AcVtV4vRcw8oBdUB/8QcWkL4ZqodrXlAck70daEKA
	Nulwe++nK0EJ+HA3I6+9I6xUqme62Vv+VmnxbXBK1mHHbNWBCIvhbOot1Nsa9l2ljY4GkS
	gu/vqN03iKBZgOVQTKd2VMvGCISYgv4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771959250; x=1803495250;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pA3DPEAcwnPXpmcsvOzdGsmazxFwvvrygWXsa6rpajk=;
  b=La9gLvfa4EP9uK6RWPYXbqpTyqUdUTzcZTnjpIxY7/O6v3jOEmcw1HKm
   y+7F8lHobtN/rYgcpx4EqogsdBk3Tft24B+dt6+aYKC8OGa1o4tHNaPlR
   hcMTU5QsT37jnZkNp56Z0cFMlz0HX87iSgjTZXr6CLNUmjK82QrG5Yh1L
   0KID4fXwVbfVowt3D/e7R0yjWf19OsWotLINcy6HNQW2m6hwZ0H1Ceu8y
   +aXtsKql8KQ5qbEMI1f286c/TlHsushkKbkt0tFqbPgK6c3B0GR+5RzZR
   FYKwOzF9oO6JJldXeVAISA9xBgWMej8wZ/q3NXcwz3l8sM3G98ppyLoY8
   w==;
X-CSE-ConnectionGUID: z5eyju/AQZWogPFowk5EIg==
X-CSE-MsgGUID: CUHdpb4WSyW73lMgArDwSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="95600908"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="95600908"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:54:08 -0800
X-CSE-ConnectionGUID: PZ0PD4OjRaGO0XoD1U21dg==
X-CSE-MsgGUID: oOuji2MwSO6qVUbEwY8SOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="219455954"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 24 Feb 2026 10:54:05 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vuxXn-000000002MX-207S;
	Tue, 24 Feb 2026 18:54:03 +0000
Date: Wed, 25 Feb 2026 02:53:20 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, vbabka@suse.cz,
	harry.yoo@oracle.com, 00107082@163.com, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated
 with __GFP_NO_OBJ_EXT
Message-ID: <202602250250.n38q74JK-lkp@intel.com>
References: <20260224165250.1322946-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224165250.1322946-1-surenb@google.com>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A382180002
X-Stat-Signature: 9so4axk8fq1keh4e3eff9p1exm67pfg6
X-HE-Tag: 1771959249-569763
X-HE-Meta: U2FsdGVkX1/rduvvwKfpG9yAfEUruXDDr8YfRmi9L7h/LbWnlcJ/ypuTeCLv7NI72e1UIM1Gv5NFN4IJviuCQrcH8Ff2ZdUS8Mba8yYL1KJNE2OnNrnteT45QbTr7bmz+N1qHxXR4W0rpjqss1qcwgJDsV+aado8hr0tH281Kt20Xf3W/uRlbdNHWZjBIik08uxs/Sldh99z5EkYTZycIiXj4v6MI4Wn2U75ZdpIX4nyZwcFATqaO1XqDtaommzQwsXH037z1EvWVTqeUOj2GW9pTpc+ryXfUORhz5xdtM4/3j00xxLm9L9WoccruO0avDSFaBQFH68jWtMhPUYhzaexYgbrNbY7d/RomjJFS2mRYLqqVYTaPDIxCjtZhqZYUBuZ29W5V7FiVo4rZzk/hwG1tUGg1LO6DWLi2MqWKuM+ZLv6uAUXjI1rTRNZdVuABO+xPSA3PSc/m4TeL2wP17KuZef/70sZZniqZxInfiqpWAMOgwYydMK7MQ412Jo35PCSFPybLWYX49jgq3QT4EsO1NJm1vixKubxYPcRCutv2WZf/UWYsm89Vp8bRqruLiel1EaBrjNdDwwtDBY5+C4Efmvil9o4jpgOR3qiFAF5ND1CeDPwT7/mA7i5j31ul7BIYtASns2WVrukYs/sqaPPVt0vvDoa0JodQ6BJT7/cS/MhM1DZ03+dn0UGalYEm8jJM/hnrLceK7SPS9EIyntVFKG+33hdZrJubEAm2C+ZufXQwDxU1OZkJcsPSl2S3RvQtdiqF+UvgIp76TIYjlT2GgrQMma1IBblYf2B9PSgnZkAi5k9yvittG7j8eNOsIiN9/oAdWO/ZBjRvjdymM8i0amalz6yxD5thGBjmbYHRomvdpSwO9FYkBe5g8QGeSVZomIl/Yg+iLa4PdtErks0Qm5EZRGhGSG5fhfMD+Je/H5B50x+MaYtXZVHbPCudl66Zh0BxkC7Gme6C7X
 ALG2bZQO
 RTkXxaBslf7BxdaVbot8mvaSlnlNQvMPofwrJla/+eOKxuS0rAEJxDr0eYPo+SRI0+8fHr8lCRpM6/W+lJ3lFNGPpD45bNfdfyr1ew2Un7q1g6lxwhITl/37pkjaCFuWlf/RryN9E3PEQLBlVlaKgAad+5v4LK4uKy2ESS+0ZbOxtXdiYNgaPnwB6oiEftvLt8bgvvzWPQzM+D2hQSvfvWkmyGA1TlFYjLvDXzr4ldwrvnQB1i73gnSWgH8z6MmhVt5wD3AX/Aj93CjlCQ9hupc3nq7xdVlRdHYgK9bRsZJCXm1IuigtGDLydbvdUQIsvXBChX86I4+j5mSYbqNO4oKQHai8t3GfLD6iYDZb6pBXMwXLgfiwQigNZaDamDeHNGptgjKe+HqrKts4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7dff99b354601dd01829e1511711846e04340a69]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/mm-slab-mark-alloc-tags-empty-for-sheafs-allocated-with-__GFP_NO_OBJ_EXT/20260225-005422
base:   7dff99b354601dd01829e1511711846e04340a69
patch link:    https://lore.kernel.org/r/20260224165250.1322946-1-surenb%40google.com
patch subject: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated with __GFP_NO_OBJ_EXT
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260225/202602250250.n38q74JK-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260225/202602250250.n38q74JK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602250250.n38q74JK-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/slub.c:2787:3: error: call to undeclared function 'mark_objexts_empty'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    2787 |                 mark_objexts_empty(sheaf);
         |                 ^
   1 error generated.


vim +/mark_objexts_empty +2787 mm/slub.c

  2783	
  2784	static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
  2785	{
  2786		if (s->flags & SLAB_KMALLOC)
> 2787			mark_objexts_empty(sheaf);
  2788	
  2789		kfree(sheaf);
  2790	
  2791		stat(s, SHEAF_FREE);
  2792	}
  2793	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

