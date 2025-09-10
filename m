Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3FE5CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171778E0006; Tue,  9 Sep 2025 21:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149258E0002; Tue,  9 Sep 2025 21:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05EAC8E0006; Tue,  9 Sep 2025 21:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E519F8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:39:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90C76BB396
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:39:18 +0000 (UTC)
X-FDA: 83871632796.03.E8A1E4B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1D11C40006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:39:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QDSbVQ37;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757468356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35stMALT0zaYckbwckUecTZkFG/lHueLFLlqk7gCpgE=;
	b=DYHsJmdrr+14Lli3yfnJuzneiAmtC/3szI+e+iqXpuPdxinpKrWN7uQteWjJHw3a7o/0BQ
	WYmDp9ASP9fb5OBplrO0DeuxViJJVHIQdU66+UmIyD118ngM081XUgNgtLYbXACjpeyquX
	QE62emxdtVPogiv/j3qooythfBuajYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757468356; a=rsa-sha256;
	cv=none;
	b=kxLG9EUFvcrGfii6IUoHGDxqVecBVrJFk2kninx6l2v/uw1OII/7NTnDOKKBpIEadbQnxi
	mLln8VFbNDliFfmYAAw0hg3mJKZ+NSAqdyMh2+KARPnEo0Rxzanw9fBSikKjSKb3WNFjBn
	jpImNd2U3mGczzMcYJnrHJgIANDzpz8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QDSbVQ37;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757468356; x=1789004356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GWmdpp0EogrvTC9TsSq61OLSNkyGJ4QAbt4wB/Nj+VA=;
  b=QDSbVQ37EiJZipmRwdzK8lJXufNZicvgKciaNYHcfv4b/OA3nghyxA7Y
   k8spDHQM1ao7OEjLloys/+1Qajf58U5ASgrNin3q82KeK5EwBwYJ/pC5x
   fuMv8UDv4VqyCEJU7yhiB6LmgIUOd70iV27Neyxoenj0ezhaf3ze9eqSp
   lLGieOaK+7f/5OQkq7v8RJckO4rV18h6GxMHNXGZjeVM9oMngwJHeCMfQ
   xESDA4BT2rOIH5eHYgJym3jNiWoq1q0+jehzKK9TbhWmm3Ryw1mVq9QvB
   ZLl/2YO7l+gbJiW1Ch0xIjSCuqlz86m7Xv2rZFUzURqBqndA/GwE4fh9v
   A==;
X-CSE-ConnectionGUID: vkEF2dotTYixgI2zRpxAqA==
X-CSE-MsgGUID: ddYGzPjPTQymnjqRHcSqIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="59842948"
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="59842948"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 18:39:14 -0700
X-CSE-ConnectionGUID: 8CUqBdplSfO00Pm//sWj7A==
X-CSE-MsgGUID: GGHTSNawTJ6p1TJCI6d28A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="172414600"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 09 Sep 2025 18:39:08 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uw9nd-0005QN-0P;
	Wed, 10 Sep 2025 01:39:05 +0000
Date: Wed, 10 Sep 2025 09:39:03 +0800
From: kernel test robot <lkp@intel.com>
To: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Chen Yu <yu.c.chen@intel.com>, Usama Arif <usamaarif642@gmail.com>,
	Hao Jia <jiahao1@lixiang.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v0 1/2] mm: swap: Gather swap entries and batch async
 release core
Message-ID: <202509100935.w5zKofdt-lkp@intel.com>
References: <20250909065349.574894-2-liulei.rjpt@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909065349.574894-2-liulei.rjpt@vivo.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1D11C40006
X-Stat-Signature: 3znaiam7ekcqr9ej13f6f6mokshrunw5
X-Rspam-User: 
X-HE-Tag: 1757468355-608145
X-HE-Meta: U2FsdGVkX18sVV5PhtfTo7kcviEp8HLWXrZssZ2w6XG3P+EhDyguyi0UbkLXHgUep2eD68rape7mRUywpJLW/2tdG/5F2Vd5/p2AvGmXA7sK3S4zoFzgF0dF8S3cBFzWEjTUNItsQ3xQqrOgJk2ZEyjUyxn9ZGHMA8qLWit5rnFJ3a+3R5ELgOZgyskPGRdEai05xqFc/2Lg0sMFLht8/wn8nqfavQBU0jSGFIKslFDvpMTDKGVXcOmqqHD8DWDPvuU7OMYDMIZUX3Zj8TVt+RSOb9PphkcgpSqCAtTNgEJsdD3+KSdXtugbyMDTvF3cy4pk9M5r3r403Js3OEPVYelfE6adTCkmeglRVYBXd7we/yhsrnHVWxyoUUOqCV9FKt7HxVwwsYwhIDHNyHKsjpjvYN4ET+IY6BCPh2CM6r8LslXs8avDnVXVIgfo0BRrNeN4GMREWURaATvRzYSlX8ldE33jUlhEMm0u4nBP2LU0T4hGQPZ7PU2myYtlPMJUieGOsQcPyq9Wt0r7tPCvIO/nsXmrtRMMaBLHw5qu9cWYWzx8UkoSelmqreZ61Ix/4mG6NskJDxB2IjuE04UrDgVAD6mJlP05YmmEw3ZYL7Nt5r8SHdC5Joy8EqyiTshngnbbIqJ6ngwI0z1WQk0aqvItLJ+KNOKYJ4EpH+GIuhyFgwkAz/+xtpqGTm40WuDFboxNX1MDPJIVT9EZOn858YTjYqBgqArXULhvK4IK+uiXTC+To4uMk2LbbCwrXgFHyDGn12ckOhF1fPdkhEZerFUd3MOGxqkjUh0BFOEbREQ8ja1kv9lE8sGunyxPdSm0JcCr9j2GZiECKJPRZ5aZpzKy2WPwTea7IUBNFccPbohYuk6w5iOwleongzdEzoCVuTrDnt9h11oNcuj1r0VGdI+Og3FHxxBvaDVlpFsxlI1wqmwEKrqlH7QiEkcCbnKf+r3EX7DDLPUqKFICDgG
 f9R6nZjg
 wXav9Jlc4HCuTnbX+LN+t2I4dRO2u2M32al3CIoIImWMk5eq6LeNip3QpmEGEn9oOK+1U/Ppk0MT71DBSU6JrUuNKcAhmOUGbU35CPkbRQnbMfa961cy04PiUbf4D7mWVXPR99VgMaPgVaTdP1bksPIHm1ZlBzdNcaIFg4sHyoaPD+lzVjZBYShZxZjaKcvqWoVyUGGP1p3QmhySgLnadfoscUPNgj+y+Dy0K8JXsuxYb7+KZaodJfKNuk3cZKux9P9b1UYc6tbDXT2Z5XDEj3E4HjdeucS5ixkkaHkpFWelCc1VZ3w+krnIQIl8JiCR64LG8bu6Eesc/7l5NFIkM6E/LPmUFZ5XTOIre
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lei,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lei-Liu/mm-swap-Gather-swap-entries-and-batch-async-release-core/20250909-145620
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250909065349.574894-2-liulei.rjpt%40vivo.com
patch subject: [PATCH v0 1/2] mm: swap: Gather swap entries and batch async release core
config: x86_64-buildonly-randconfig-003-20250910 (https://download.01.org/0day-ci/archive/20250910/202509100935.w5zKofdt-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250910/202509100935.w5zKofdt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509100935.w5zKofdt-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/swapfile.c:206:12: warning: 'async_swap_free_counts_show' defined but not used [-Wunused-function]
     206 | static int async_swap_free_counts_show(struct seq_file *m, void *v)
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/async_swap_free_counts_show +206 mm/swapfile.c

   205	
 > 206	static int async_swap_free_counts_show(struct seq_file *m, void *v)
   207	{
   208		seq_printf(m, "exiting_tasks:%d cache_counts:%d\n",
   209			   get_exiting_task_count(), cache_count);
   210		return 0;
   211	}
   212	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

