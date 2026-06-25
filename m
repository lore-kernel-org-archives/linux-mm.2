Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B25CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65ED26B0096; Thu, 25 Jun 2026 02:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E4A6B009B; Thu, 25 Jun 2026 02:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500276B009D; Thu, 25 Jun 2026 02:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150286B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:51:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F3141405D7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:51:26 +0000 (UTC)
X-FDA: 84917513772.05.3E89468
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA01B80008
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:51:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AbqLeLSg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782370284;
	b=3xhENo5QvEDazSjI7cFSUb6Oa1i7HG2tvLK1SwMqinAEnkEDpHDDswv4YaQAqylMeU7tlP
	EkzuO01V0ht4Z8qyUwwSVGWzo8OHPmDUSiU5gQ2ZwdiGrjYk+6fPsxvPqQQ03OC8aF4BKV
	uPoIVzYoKrE0Aj2ar2iaaAVgOTLxNzw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782370284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fSIHZDdg9v1nAmjBjaqEKMDnpwZqhsPHVio46r9xEwg=;
	b=YDf9cwWe+kSFxEPXNcNVkO5c4cWYSGhhB1lFPCBkF8yCYsUeIArBJwM0Z+tXc4UHUEsGgc
	l/11OqfSWXFHju+e0Dbiblh1GPMI8SuQomKHGnvSsTW9WAu4wXcg4ZjxIvOgdfRDNe8rDe
	1VHkC3kT7sdjkQbCbiw33r8dYiGteRw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AbqLeLSg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782370284; x=1813906284;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JRevYpKLu+UkOXzSPW6dPV1skR2NA7ozHN2uxP8d7qI=;
  b=AbqLeLSghIlnD7ApaKFb46zE0S0wb6ldF44Gzb+LPC3PqZ1aqS7UJuUX
   RPfF+zFlBYf8sqX9KSAf/Hh1eUaPs1CkGO9iCBJNqyBbi0c04hD5o9XCT
   0IJ62ikEucYxkXmjzQeT990XDyimHcddiugcgJaJ8633ZO79/p6qhST+Q
   Rm/Gvq7Rz5YDJOUiVQ0Y5PAGzhzKtpclKCDNqBqzUN21BJ0EFlmUPc3XD
   X8olFyBv9KQqlS514BdIcEQo8BR7lqKSU8cGozoGeSN/K2Hz6UlorbhcB
   /a1KjjbsfsDiL3fBQ5YwjeJwApXEj0uNTut3LYx3SVsT+umnfff26TLVb
   Q==;
X-CSE-ConnectionGUID: A8Ut1kJtSx23SOd0pWcKjg==
X-CSE-MsgGUID: M2M3hnPWRNqfC56ft3XAhA==
X-IronPort-AV: E=McAfee;i="6800,10657,11827"; a="82260025"
X-IronPort-AV: E=Sophos;i="6.24,224,1774335600"; 
   d="scan'208";a="82260025"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2026 23:51:19 -0700
X-CSE-ConnectionGUID: e/kArBR8Q56POi4iqKA80Q==
X-CSE-MsgGUID: dzuyUAJcSp6F0URtHGgidw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,224,1774335600"; 
   d="scan'208";a="244016462"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 24 Jun 2026 23:51:15 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wcdvc-000000003yX-0QD6;
	Thu, 25 Jun 2026 06:51:12 +0000
Date: Thu, 25 Jun 2026 14:50:26 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v4] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-ID: <202606251454.M74ab4Rw-lkp@intel.com>
References: <20260625053958.918738-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625053958.918738-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA01B80008
X-Rspam-User: 
X-Stat-Signature: hgzeznm9xe1dzuf6uyz8zbn4wpsnoen3
X-HE-Tag: 1782370283-481216
X-HE-Meta: U2FsdGVkX1/z7p1ILps9l6hf3vjHboSHKgTgHEea/1kBcnZkzIwbG45vNNHkOl/Z2h0b3j1ZPlU4QuSrR3NEfGQHMi1oW1b1kOXgVRlBGr7XZ2lHCEdSC6I2oQHhyT4ZjFiOP0R0OYkMNNgIMMAfPRSrVvZPW0zr339P/ebEVxMzU01t1KKcVst6GSRbGtGbA53IDoqM6pNhM1qYnZblfnECLGu0otblhFL4saQ/5eG8YyVJ/Hn7ViyPIkuTA7hOW+5id1SVKdt2hMHbdPTDiA+c0yDVDSam454tg0Oq4DZFjpBiAuvKZFB1izHM4aKL9p4gSDuj7pzj8lDqA5CXyWAp2JPbJ3WDF7wnaUG4S7XLHTP9peh5R45qKJ3mJSE/vD5JFpOEzs1e2NzbBQG5idDzXuY+2xM5uen2/cSfY17VAFMFxETOQxj4CxEDVdzoEf9BnQHw7FRY5yLXsOjUOpLSKwsWhef3Gm4nGqmdl0jojwJvMoWbeYPS+vDMqxFwAfyEGC0y+LX3LtOjzS2CpurqExfPOn9/+maQKZzdDTRtHEKEK070pyccYBkgsGaDPpcXSLXphSJX2AISW1sh9hBrj5pYs5ldIqBZ3zy09gdy28Bu0gqEi5UDa58NBsFzehU4RBELnNkhxXHYAC3orpFzDznPSmFp5QMT3ccrig4AXRfPjw8m+XZQbHSGHVm8eC4GQSGbHEpRfNQ/V2ux2V2JxnxmX6uoKzgpX5p39rSQVa+k3FQaU5fUN9VYg1RcAYcoprj84UC2LUdJs7FeQzP2ZySGaPK7H0zc1+9tDnXQ/2wWEtkKB75e4RfjlKE/LEzfOW1ASCGoSgUCmauJVS/r45tFS5CUpZr3k3/f0RN/gcAhJRy3fSUoUTFtXqzwysDfsm9s1397TFjZcBthaDs5whVS76xx4HmWLY+8HjN9M/X0H3lh3wpR/0i0TDZ28KSxE9ddC+XUg0VUClz
 1k+Gcr0A
 6TuPHL1VtYPyFLcRqzTSdGowYtclJg98G9OWnRNr5cbc0b9rC0XnbSnHMV8CxV4F13HCm+4Qqk8Stjso9jhTlQn3Rkv+usXML9nrX98eA26XRXkSkc553uN0yxpivUsf1CduRG+fI4J59C3jhaJLb+5yvYPOn6xqvJvg3z1XyajEg3UpD5yR5orCFK9dVZ6NW7Nd2tpFd9yR4mOf0HjMlgWAAZw11unnehhwK8gxMr0UNcXr/iZkVpCDYJ4MgvdvTcEjJ7LUrUo3fOCMhSbyx/YDXeryjeIfg1TfE4MwF50fTl21dOvxz9u7hCv20Mzrka3Uov15jwOJsqCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Zhu/mm-assert-exclusive-nid-zonenum-bits-at-the-page-folio-access-sites/20260625-134106
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260625053958.918738-1-hui.zhu%40linux.dev
patch subject: [PATCH v4] mm: assert exclusive nid/zonenum bits at the page/folio access sites
config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20260625/202606251454.M74ab4Rw-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 6cc609bb250b21b47fc7d394b4019101e9983597)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260625/202606251454.M74ab4Rw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606251454.M74ab4Rw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/fork.c:258:18: warning: unused variable 'page' [-Wunused-variable]
     258 |                                 struct page *page = vm_area->pages[i];
         |                                              ^~~~
   1 warning generated.


vim +/page +258 kernel/fork.c

262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  240  
449e0b4ed5a16c7 Pasha Tatashin            2025-05-09  241  static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  242  {
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  243  	unsigned int i;
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  244  	int nid;
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  245  
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  246  	/*
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  247  	 * Don't cache stacks if any of the pages don't match the local domain, unless
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  248  	 * there is no local memory to begin with.
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  249  	 *
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  250  	 * Note that lack of local memory does not automatically mean it makes no difference
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  251  	 * performance-wise which other domain backs the stack. In this case we are merely
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  252  	 * trying to avoid constantly going to vmalloc.
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  253  	 */
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  254  	scoped_guard(preempt) {
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  255  		nid = numa_node_id();
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  256  		if (node_state(nid, N_MEMORY)) {
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  257  			for (i = 0; i < vm_area->nr_pages; i++) {
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20 @258  				struct page *page = vm_area->pages[i];
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  259  				if (page_to_nid(page) != nid)
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  260  					return false;
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  261  			}
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  262  		}
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  263  
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  264  		for (i = 0; i < NR_CACHED_STACKS; i++) {
47e39c793367600 Uros Bizjak               2024-05-23  265  			struct vm_struct *tmp = NULL;
47e39c793367600 Uros Bizjak               2024-05-23  266  
449e0b4ed5a16c7 Pasha Tatashin            2025-05-09  267  			if (this_cpu_try_cmpxchg(cached_stacks[i], &tmp, vm_area))
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  268  				return true;
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  269  		}
262ef8e55b7ccd4 Mateusz Guzik             2025-11-20  270  	}
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  271  	return false;
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  272  }
e540bf3162e822d Sebastian Andrzej Siewior 2022-02-17  273  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

