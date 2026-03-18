Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C000DFED9E9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 01:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77176B00C4; Tue, 17 Mar 2026 21:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EF16B00C5; Tue, 17 Mar 2026 21:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B396B00C6; Tue, 17 Mar 2026 21:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C92766B00C4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:05:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C8EDC1D5C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:05:14 +0000 (UTC)
X-FDA: 84557390148.19.F6E9B3C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4879F1C000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:05:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hphg8S04;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773795912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeAIdgJyl64l2XuxwR6IgUsobixKbEoOhwDMTFzVp0A=;
	b=KR0buydMTy0IvCSRA37ZskLELThqu50mmg7GygP/cR5u623ThcwRB1yx4Ott3Ji1pkFhki
	+cUK0EawbWm+KP9DiVjwe20moWGXQXP/kFdpqq06WMcUs0L6KfKzhMeLO1Wp6XTsNe6dmm
	ii9vIb1Jv6tkeXFuTqh+wSoyh5v7vy4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hphg8S04;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773795912; a=rsa-sha256;
	cv=none;
	b=YossBBrNxcPSYhuNZi1Xo5wtLC/jPqRskfOoQyPW/xh2V4iH/2XwEPacb/390t9E3YzQcM
	r8CJpvYGodc6hNWRBwLxCdv98ILuweMhxwosH4BJUXpFrfTLH4fGETT2tdKhsrZ1LpPhkz
	KXU24Jb4QCuZiq24Xvc7fiRV6vQ9qt0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773795910; x=1805331910;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DqdV9FtuLjFNAw73HM7SkGmefSXM7s8ErntUEXLJrQY=;
  b=Hphg8S04bzdAiOSw1CC+f+pC5PgFn2MJNwO66aHAke9wTgSD0YhMAiRN
   S8H+fz5UkOZqu4U8h7v+s6qunjARksS/tgZicV3gI2ueXrm5s4otfaLW3
   8MALQiqtluvX3VZstiOUlT7R5vRUG+8SjPt0EjIEJD8Dau6SavUiWZjoY
   U5QSs7yIEwPWUNHEFiMZaJc5gLeHqSP2WVj3t2gNrXhe+AkJvQG1PTY+B
   uLNjVq0yzBqdPmfBLctRBTFwN749zpvstGiRmHx1zjDmQxmy9ZpE4AvN3
   4tf5FyrT3UH4EMPh2MB1HDnzUvTwS/243yVuZs/4SyN/g3QuLF5oqjk6J
   A==;
X-CSE-ConnectionGUID: cVGHtPYwS9+R+sGdypgHeg==
X-CSE-MsgGUID: hNROUh32T3SyqVDHbM9s1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="92413959"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="92413959"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 18:05:09 -0700
X-CSE-ConnectionGUID: hcXHrC+wSBu51Eo09hRS3w==
X-CSE-MsgGUID: YaSiG27uT6uZUJRofN+SSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="226905586"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 17 Mar 2026 18:05:02 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2fLF-000000002Gz-3yzV;
	Wed, 18 Mar 2026 01:04:57 +0000
Date: Wed, 18 Mar 2026 09:04:10 +0800
From: kernel test robot <lkp@intel.com>
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, david@kernel.org,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: oe-kbuild-all@lists.linux.dev, weixugc@google.com, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
Message-ID: <202603180953.FNgOslIG-lkp@intel.com>
References: <20260310073013.4069309-8-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-8-dev.jain@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4879F1C000B
X-Stat-Signature: hdqf8tk3ywnnn5z1g4bx4x7abwd75o1u
X-Rspam-User: 
X-HE-Tag: 1773795910-96323
X-HE-Meta: U2FsdGVkX1+pXK/+Nv8GIT+Wm7E3Z/O79GJvlOOKkKJ07Xb8XDps3aDtiRI4ublyXmaaoX9MuY5RLpbXFVfELVkK9Y3IMuqxGZ8ohX5DVilgZ4RNO/bSkQNh5naucwjwdlz0hA9k8zqJKptTeyiye5TLmHqRm50N947lM5QRqUz1lYJOY3wjSM8x2aRpG2u9TdrBqWTzgz34hsd/4tZj/fbJ+/M1l15J54f5NrrUQ84W/5kwfLyqE9vrK/4OrQTa4zljHzCY9k1C3rkuFak2IDqLcp8I+pousZLEKVsdvwu6iyayzvk6u/gwgl78Goqw6a8sQJQQyGAZid87MrnBASlsHPEjGBthq4EH3Dfn0lZ12DLFYYNnu31N9ud7vbSO0V6TENSMPafqP+7mXojnnLyIVhTwYr92qdJqlai4wgm5bmGS3YvWLw3fbJBfnRE8QCGCquvpDaAHCDoMvJZDlNc6WIAYvJaozUsjQEVk5jPALaNMRmPP6Dt+xHuOX76/2FG44fe/qf6IWtz5hNsPK3x6zp6lHxxrrLlhISHX+WKEq/Sm+HVbHcwpvw9Dt3OyP1Ov/SRWijGRfD72wOI3B3mG4ZDRcNy08z6taklM5AKPRhlOCvz5aVqlFP08hLXbxHaJUzynjpl2r71gBn/NUj/dRwvDcEA63V37d3u4cwR9a3cpj/5ZbfGR9iwDPlJ8AgogXs8sVJJPcNuzWAfA3snMMb4gWwTf4FrtQpMuqVfJfWTPlAVBCwF1PuSb7MHJiUMKbFAtQP2lbeUCLXNunY24I7lm/YPmcmnP2U+GzKMya46K2RALUDQPi55Lv2hi9ab2V3dmrDzc2kfgUvosdQ2t2RuEOeujtKlIvKRuK4AJM7fHDAXIhzsrIws9e5WITbaa5WkMjLleRBc3keejBEnCxFpMBNIMfXlTgX9/sedRvdqHjZ665XWUPSW38pkeMMJRVzvds79sLLL2PD5
 sBy3v/b0
 CL+M/drruPzNtTvyrcRQOuAFEZIapV4XzIVBSs2pOVP67q4/4Huf0d03GaIkgy2oOTUvkX85gQMdvqt5IDvW6TLiS19+j3wEjM8lkh4fyMXJ7I/J//1DHiboU9FjPX/47B3jbd6kbdvFsvT29DqH9KNnGVYSNVquQJCKUIvgskXAiekNGk070e2s8fBteKYWV0Xgpgk1S+S0IjZYVS4pxddZtVSVHbs7wgjQZBPR6oRIuGHh81A9uUlXuNehvoDk7coRdQ5JwoWPPCn6TVdv1TFh7FZHD9OU6ySmRrwbMLOQEbJnfKJMAUutVdzxf1KWpVePM8eqzluoIIcIcUnuKIUNtllV/rXbfY1nzPxkEE0UXC6dUEjp54tAb3JJ/9B9x7T2GbgXozLJDZrkxAxIkqx0jIiUw+2VBqEMYY2SKDirdJ50LEJTuRS7U9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Dev-Jain/mm-rmap-make-nr_pages-signed-in-try_to_unmap_one/20260310-153604
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260310073013.4069309-8-dev.jain%40arm.com
patch subject: [PATCH 7/9] mm/swapfile: Make folio_put_swap batchable
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260318/202603180953.FNgOslIG-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603180953.FNgOslIG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603180953.FNgOslIG-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: mm/swapfile.c:1757 function parameter 'nr_pages' not described in 'folio_dup_swap'
>> Warning: mm/swapfile.c:1780 function parameter 'nr_pages' not described in 'folio_put_swap'
   Warning: mm/swapfile.c:1757 function parameter 'nr_pages' not described in 'folio_dup_swap'
>> Warning: mm/swapfile.c:1780 function parameter 'nr_pages' not described in 'folio_put_swap'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

