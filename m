Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EF6F4BB75
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 18:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78DFA6B0088; Tue, 24 Feb 2026 13:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BA66B0089; Tue, 24 Feb 2026 13:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AA56B008A; Tue, 24 Feb 2026 13:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDA36B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:47:30 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6BFC8AC88
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:47:29 +0000 (UTC)
X-FDA: 84480233418.28.E3488AB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 18FFE1C0003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:47:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gRi71j3X;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771958847; a=rsa-sha256;
	cv=none;
	b=mk6ynJpKu9RemtwuJVsXzp/wvI/gCjtkLTQtzJkf2znroDMyxBi/8AcwC/BiP0PnM03SLh
	PdTLRto5zW+BHBTCNDWzQSc/kgemUiuBNqTLGm2QFnSZ3Q3qTwkN0PZrHxOo7pPSaNT857
	rBUWjPX+QqaCKKbLuQ6ncguxOFHbkgk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gRi71j3X;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771958847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ze+VFBwnR6NQKTWrlkIE/pMQ18r77MTSJmduBpR8xKs=;
	b=o7B5pgrwSonaUa16Y2zpqYT/nEZiJHM1BTIz3YqAxRA+0DsEXHcwCpHu6Pb1CwwLie6Qg0
	bJAHOHoq8bp0Qifxwbs/PhxwWwB7N+/l6x09N78XfFlWiQcmdSKPLQSY1rjnYQwvoFPV1B
	1qvAgTfCj6gFOK2+6EgPy71CGtiZ2IA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771958847; x=1803494847;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=actsr+bBxfzCj6H6w71i/mGXt5y66yY7aSENLDOupoA=;
  b=gRi71j3XA88lJgofb7gQwNF4OUY+MsRJvhyTQOx3emnm7WFcriNfbTa2
   EFyeKL0lA+qIOG3zd+SGU2lOsZi8jkGBXveEHsDxMMAIBstqNaj2BfD5k
   VezeDsiFPX6Fcna0OHK9pB9OSCbOAJPOBn+J4GcA2j94n/h2zFJ3LdXCw
   UbNJFx8qzUNlxWX2Ruy2KYpPqFFNWpZdPORPqGc1Lchn44HkzHGfQ2o26
   WI/o+BwJS3OkOMgWFeQRKbw7lzFCxSGuG02uLfLADkC8BhaC1YXnWG9/Q
   P0ekqRo11P9dWK/lH97JgJPsWOGnjcyoyq78er9bQ66D0uKo2TvUHkIgG
   w==;
X-CSE-ConnectionGUID: wD46pAZbRRquBn3t7wmmpQ==
X-CSE-MsgGUID: nmMPaAqbT9WoBm2Ga7a8Kg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="72194230"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="72194230"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 10:47:25 -0800
X-CSE-ConnectionGUID: 2fNVkZlMTAeR/FPtAQQybw==
X-CSE-MsgGUID: f3TrLqaYT86iaVmnKxYQtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="253738807"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 24 Feb 2026 10:47:24 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vuxRI-000000002M1-3GXn;
	Tue, 24 Feb 2026 18:47:20 +0000
Date: Wed, 25 Feb 2026 02:42:55 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, vbabka@suse.cz, harry.yoo@oracle.com,
	00107082@163.com, cl@gentwo.org, rientjes@google.com,
	roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] mm/slab: mark alloc tags empty for sheafs allocated
 with __GFP_NO_OBJ_EXT
Message-ID: <202602250249.E8I3P4Ig-lkp@intel.com>
References: <20260224165250.1322946-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224165250.1322946-1-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 18FFE1C0003
X-Stat-Signature: kiyjaog3s9bcyuygaakp5axh7kfqfqo1
X-HE-Tag: 1771958846-784271
X-HE-Meta: U2FsdGVkX1+eMXsXYEV4DB9meEuvTwfTN8TWWnWQHw6vhL2V8U2sHj/DAV5UrMLgA34sAOvVtpGgPjzXe8OjyO51qRY6tclr0PY7bKqFr2wy58/Fkx/4r6od0brLCq96u1Z/a72+PiZF9QmpiJKwj9ygKLd1QC5rQXihUXlkOgO0ADEZiEL/ON4KWayxL6O7u04zSUwh8KjURzsniJrfAI6YLnaHqTBJs6AMs+ln782aV3MRCf3SjKXd40kKTbNYN9rFGtY5xO6F0JuNSv171AbSi6EgIIm8A/91pkOYKSvUUQUpBa655y7WsAhzrEA0y6iRP5ip37UONBE0LWiGWvI8zwuvgtHMna5mPdtvFkGqxrc1N68I5ia19dwEgZSbg7Aq4fs5JXxUgP5JbgIU/0ORoiXNZ7Bghe1CQfh+7Llyv9U0oZWOGw+ctrNOrkwhI7txHkRhr+VWddUOOyCAEGyUqlIUhFcSSyWXnZBXrUceVaEXillm51UxuvAQzuEnGfrkrpbcciKHAdXoOzgoOdRHE//RTSav95Lvk5PAZTwLgeCBCyXapapXBdxV03dUX0I7TcLpz+l3QbbrD6thWLvkgvBvrUPJkxOQpooMAkJydoGF4DwZKO2sNf44tB+qMCM3s8Ds5RAfpC7WfFO8FXVc2h8Jn77ipVti0IW0CXCbnOEL1ubKoeXbQF9fM8LfdcVKXkBhu83441j6775yP3KSqoeVHtX7OkwGWBnbsuOKJqUfwk2elmTSYmCJgFFhXFzxCLKAs4DbldmWvmqJFNXrGOmwNVYmm87tlZ4VfWQSo4QoaBga//ixwJwfeQQrV1Bph3XFsXC0IzPFZZYnGtxxGrnBlSD3Tbt54i0xbCsydXsDMBCzN0872z0SDoeFgQM6Y56uvjUxvXgbgaSb+A9NZ3+2UQ/U9MqG6l8LvNKKoeW+zWosDgmJEHQiho2cGQBgnYyw8TvJVzbwpXX
 /zzlTdh7
 Uc+2pGlPSo66Z8P4RY5IJ+xlvKYRRXr9tK2DC8InG0rq2PrJMKZ+oqF1eFFUYic5PUbjyJJyn64Hj3XXik0qbFrb8okmwmkP1MsfBgw9ArjzfV+D0YMtFEYifpHxboNkyx/WL0XSEECaAjBTVxpOZKGAdnUu4zyH1wllr/DrKe1TCr8CE80OSGvgLAYWGeOEn7s+711TS89RN8atSkLBOMzr8W1ZhB3L13PITTloBcaWASetoNIT4Dlwnzz2kHxp29wWupLieVzuFoayouEmOqleDGV0j/ET5WedXU/oR7k8QYTsUyUaUaSoFlu+kkGoqlkX78tTwq4gWaGbk41UvW2fKTwwBHmuGrRAoD+7x1QA4gQShXSsyvmYKhHnrB5Ia/vDTBFAC4Yb6y0QNpES+YuVi5w==
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
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260225/202602250249.E8I3P4Ig-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260225/202602250249.E8I3P4Ig-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602250249.E8I3P4Ig-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/slub.c: In function 'free_empty_sheaf':
>> mm/slub.c:2787:17: error: implicit declaration of function 'mark_objexts_empty' [-Werror=implicit-function-declaration]
    2787 |                 mark_objexts_empty(sheaf);
         |                 ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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

