Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC8F606A327
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=e+RRV+B1
Received: by kanga.kvack.org (Postfix)
	id 313C96B05B1; Tue,  3 Nov 2026 07:54:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4B96B05B2; Tue,  3 Nov 2026 07:54:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3D36B05B3; Tue,  3 Nov 2026 07:54:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9D266B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:54:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A5F2A03AA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:54:17 +0000 (UTC)
X-FDA: 85393800954.01.2F98E98
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id ACB13140006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:54:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e+RRV+B1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793710455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T84aiAJqcr9eIc+RMHEdRg8f3K7zIQJ4MBqlwh+rBPc=;
	b=kV/jBU1bFowKFKkfTekt/JkNFCOvN7gdvyH8IEfEST6fws2ljFUM2RRWon4x32kKtQiH83
	ZsCkdUqXZSy1tsqZk79BZPrpb+EDy5CoclYmMeSy+joHDVrBxMt6OV6pieJaS0aWQ+XL8n
	Ds2ycI9nAwGvBXrPqn01/EJatvdweoU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793710455;
	b=CG8780MCX5W9A2z4RlTQxBdrrZYs+lhkOucCG9zwTK8Xmjcwsji9lV7usBKzw+xHjmgVLi
	Rv0hGch9VH6xSf86cQr2yIUn9hcEn+B3Cq77az+a1E2skNSQysNJlQJ4SLR63qyxrffe14
	Gsxp5QpxvK6SygpjJxmR9rcQsuqUa/E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=e+RRV+B1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793710455; x=1825246455;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IhRkmlNFW8wvqh1/ycRf3KZ3oTStQ6uioF6qvXYIdxs=;
  b=e+RRV+B1MZN1DV7HxdLxGsQvJ2uHJudxvDfBNW0ogHxL4oPBQIrxAaMe
   mH2MxucbD2jOf6pNyWDeTOmU8f+8sx3HSBqrybjln7dvmWciXS0dSPud5
   p1skYaJrErSyvOubqiqjGyNkYdW1wlzunmmLeFEJUKIdEGdIa3IE7JsnG
   odFq5AjnDh/2rEWAUd6O7u3csDdg8YgQczIslVBLAyoKtOGLySqa3nzwx
   0DTKcBAXClGm//KnyXRy3jZ+piRUH+sK61Ua1mjodjBhB9n1y0mvhVlyN
   9UqP+6mlTfFY0fvsUqJFkU8PjJa5oSLfH+TZ9Rg8G+yT16iWNT50I7cji
   A==;
X-CSE-ConnectionGUID: KbUzy653THGJLmNmNAw0Xg==
X-CSE-MsgGUID: MoaphYFCT0i2daxu7q+luA==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2323236"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2323236"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 04:54:13 -0800
X-CSE-ConnectionGUID: bIrfVphKRsiEpMbkrvetPA==
X-CSE-MsgGUID: 3fvg2CqPSWirao/zO/h4zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="8203943"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 03 Nov 2026 04:54:07 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xOE1a-00000000ik4-3PiJ;
	Tue, 03 Nov 2026 12:54:02 +0000
Date: Tue, 3 Nov 2026 20:53:34 +0800
From: kernel test robot <lkp@intel.com>
To: Matthew Ruffell <matthew.ruffell@canonical.com>,
	Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: Re: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU
 LRU caches on isolated CPUs
Message-ID: <202611032053.I3Ud8d11-lkp@intel.com>
References: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103075940.110308-4-matthew.ruffell@canonical.com>
X-Stat-Signature: 7cpbmg37k8xd71tke1fnnf4n3a86egmb
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ACB13140006
X-HE-Tag: 1793710454-489932
X-HE-Meta: U2FsdGVkX180qvu8C9ZDj16e0Cyy1NnIpC46Bs+2Chy7owgWNomnCKBpvh/beKOuloI43ydPUBwAzq/7iriZAa+7rt8aLi4IrVejOqBy9sGDo19Y6NzEAiVSYWxIc8tAkCkL11FPuil2IIUVAgLVCRxSepCq19kpv/1qxcV4OrWberZ19/fUM2EN4hpXGqS9UD3G8A7qYMhPPR0pWrAsE6VT9bxfkQwL6YGS2XN1Q85Td4TMwZqB+1E2NYmP7UZA9xepwYVOnKYsHy8muWVm1+WAICgdXnYtBa+9P1qvEfUMkLJvSuYPBAXBN2Vpboh26asSxZpT8i+f8h07KWJAFCqZvoF/RIOY/D7UyCufsBi0pSQdnwo6lGUOR9t60wPsLBIdPHFVxzsyuJd0sGsVBavkMdnupPANQBV705w9h0YZQP3E49uk4Hq8npvNjeWJDAIXfPevRHhDc4PZ4PVc0K+teKCW5k9WGkiIEq2k2JPEZp3nGututhNmf3jVyRFbWLXQgCSaH0JiHtK8MNddFZf/gfjZcSp1aEQLGFhmXk0AlJMON91gKKaPZ0BWq9HXkyr/K9YtO4ez7ff1XjimHIIvpIukNcSFqR3NIOeR7gx+jK4VTKHCqNriJ2WneLzlxBtaq9PHZdqa4GnkqZgC9YpivpSGhtIFZlSskqT5wExnG1tObclVx4kZ7XI19DdHAX+nA9DVFLJzvJnEp91JZqY3GyJy+u5HuMlVfU0M+H1RXwx1hI0Kzc/cfjyhlZlwQzi8CCxkPLLa9hlPVjSkCBEzo7dMn7Ezx7/QLTUp7ZKDoXT1Jo5SiFkpvzoDHPqZjaz/cnOhBZIj4aE0hwTqpAsAsSoM3s0FZZ+bcoWS4I5zja5Ex7TwWxciTREoMMVwXIJcp3VcQE/JjBKXdH2IgtYr2CdpvhL79+PTs1ErLRR6PnufvA334nUMlvRhGRy1AbCwJ+Qd5Q0+ckZrvXx
 f4qzyfXu
 Lstwi8vFINefaTA7i22ygSU+zzSOvvNuhKNTVgUT26YZhf5a58w6cqk0ZfQNn0rl+InmQt3UhYDxeiw+KHHrB++UeVmoIMU/6ydUVlXFg2wrCmGBOy2JI+87JWgFQOuxANtEU7b4YVqxHcHMVSQgZbQ3IqUZv1G54IEqBCWJj4j/owU0MoogGqRd6eOPXoFpH6ZSblrZppANy4QxlFCveZKD2cDvvVxx3+q6LQCb9+ImPWtJRdUMFZeEGujpu5R/+hEIU9u4a6VRm7AqkAz4KkBsy85v7Gn8Kt0FzxerrOCxwFcxjBOwAsp8ywKD9qhxr4PgflyM/qwY6OYODaujNp3wt7qb5vf1uUEYtjv3mRXhbKacqasysIQOLvjwWRz9XEPsvgDmXy3xupGs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Matthew,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Matthew-Ruffell/sched-isolation-Consider-nohz_full-CPUs-isolated-in-cpu_is_isolated-again/20261103-205935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261103075940.110308-4-matthew.ruffell%40canonical.com
patch subject: [PATCH 3/6] mm/folio, mm/mlock: Don't batch folios in per-CPU LRU caches on isolated CPUs
config: um-allnoconfig (https://download.01.org/0day-ci/archive/20261103/202611032053.I3Ud8d11-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261103/202611032053.I3Ud8d11-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611032053.I3Ud8d11-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/folio.c:293:6: error: call to undeclared function 'lru_batching_bypassed'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     293 |         if (lru_batching_bypassed())
         |             ^
   1 error generated.


vim +/lru_batching_bypassed +293 mm/folio.c

   280	
   281	static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
   282			struct folio *folio, move_fn_t move_fn, bool disable_irq)
   283	{
   284		unsigned long flags;
   285	
   286		folio_get(folio);
   287	
   288		if (disable_irq)
   289			local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
   290		else
   291			local_lock(&cpu_fbatches.lock);
   292	
 > 293		if (lru_batching_bypassed())
   294			folio_move_lru_now(folio, move_fn);
   295		else if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
   296				!folio_may_be_lru_cached(folio) || lru_cache_disabled())
   297			folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
   298	
   299		if (disable_irq)
   300			local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
   301		else
   302			local_unlock(&cpu_fbatches.lock);
   303	}
   304	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

