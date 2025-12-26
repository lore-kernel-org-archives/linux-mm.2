Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1868CE8FDA3
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 12:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2CD6B0088; Fri, 26 Dec 2025 07:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50516B0089; Fri, 26 Dec 2025 07:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C536B008A; Fri, 26 Dec 2025 07:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C22846B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 07:32:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75989161352
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:32:25 +0000 (UTC)
X-FDA: 84261560250.11.B7FAC91
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD3D9A0002
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 12:32:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="H7/kv7wr";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766752343; a=rsa-sha256;
	cv=none;
	b=W5JcmmNKTsyPhIc5PC+qCJ27+brDSYNyCra/VTRZGXInvBMewV1ymsftP5lTRi1rcmXdQ9
	TspAPrQRXf4GGXEpDJ3RWVkMZIJw81fUqTuAfnzO8m1rXtIebliyUPwst2oOhwsMxK+R2I
	XZwys+cGyWXpze4/o54lowiwKm9N8HQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="H7/kv7wr";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766752343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2hh1LAryb01YODI7DsA02mqlaejmGKbAXOcxMK6bkU=;
	b=mDg7Or/HF/2sIUPA8hdJ/21dQgMMb8cZEkIsE9ljWU7oMZtNKNJ1QyxP34eg6oRnUoSVxu
	qVORBG0BNTUOFnOlEKWNdJXJ6ercgaFZ6cZcnETvMc4hm71XENd56WNzkHAyGrFOhstKc7
	fgEb1Tl2gwLAXEZCh2wc0KoSg8Pe5Ms=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766752343; x=1798288343;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FbaYoFfToe6pPkt1KOkYwSAmsyLcTdfKga88xlj7jTE=;
  b=H7/kv7wr/TOTuS94eL+AN/c5bg0DnL3E6m11c/kb6QzXAsVPMhlWz3IP
   b0Rk7eyxdQwnHlEJva3+LfGExI+ZTw9mc666zUjBn2T5bUsnUANc6ioqs
   LNtYNPam0KqgjvvCMmLoRPAe7L+bi0WIcTzuYTRMSMaPEXOTKazz05QVF
   UgSNd2Ga3bguUlxYxK6O1pAKnl+No+Am0ukbXlVPoORlTeqsZJjOIvHXx
   ivHNZoL7qv7ttuTxBeAyMKBDOuWRP0iOnUZhZ1ShV+4xwLEQ78KjL2F9z
   /YZfHnhPSriX7ZiX3GY0GzSRMc9zWWIOmkEbJWBlsNXENc+ovuUg39q+i
   Q==;
X-CSE-ConnectionGUID: +AU1PUNLRoOY2eiM5CcsUw==
X-CSE-MsgGUID: KX9XzbalQCCE7k17g6m05g==
X-IronPort-AV: E=McAfee;i="6800,10657,11653"; a="68264045"
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="68264045"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2025 04:32:21 -0800
X-CSE-ConnectionGUID: BX3uOhXuRGCixMQLyS9NUA==
X-CSE-MsgGUID: dxhpSzVyTHanhs2eBN8uAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,177,1763452800"; 
   d="scan'208";a="205298179"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 26 Dec 2025 04:32:18 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZ6zP-00000000529-3gjE;
	Fri, 26 Dec 2025 12:32:15 +0000
Date: Fri, 26 Dec 2025 20:31:38 +0800
From: kernel test robot <lkp@intel.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	damon@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Message-ID: <202512262045.CkWwCNp7-lkp@intel.com>
References: <20251225232116.294540-9-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225232116.294540-9-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD3D9A0002
X-Stat-Signature: qb8zid8i1ewjmj8sbz5qcy7hym61458f
X-Rspam-User: 
X-HE-Tag: 1766752342-812306
X-HE-Meta: U2FsdGVkX18C/r04B+c4Dg61yfE7n+YZkvVRjLEVP5LBZpozrW+CwunF4tOEOC0s0I3qOm9HgH4H4I7ovqG70v48xykxBx10RIY7fw+Vw0bzTLElMZdtK8ahpi4cNb7lasUjkErsKY8ul/HayyjYtdgmxQ1IEoyCA8SUtX1IIjVYyFyAAonFkG8BuuaSgZmTVaCKIoY9odlt36T6vNXj2ahseVmNhXp6Dxnqrhmw0XLLqRJzppwXMZuO+9gdIgkeKrykxFDixS2NDIYRasUv3Q715ahWQ+m+D6pj8BFBdCgKwbu4xcox0OYlcNbNbwP944g3M4PBGEq9RgZYqizFxJEbFhEYrY+W6zHu96yofg9+yocnwzQSDUfTo9MY3gyYsBXoMoYL/tUm0/lEDbUvKsuuE9uBw3Q2aOe7d2sN0kdp/hZlFDs6wS9mNpmejo2PWVXPOC4NBC+q30WdUMrxKzjAPVQl7mGqxN0ikQqAHgPfgkXbYBLz5er3kpGITkqDEvo+vS8tX9bFlojYso1Csb0lNOG7DEfSVUL1maFgSLJDmbhEG0v40ZIp/5p1bqwbrm2cVy/QzzyE2feiSbZQsNosTEwzWU/5yVKAMQkCDEFGOM4V7iIkrA1ds6LEwQT6X+H0Fw6KsoW/VYDfEAd9KNDtEFfPRJy21oipBlQC5C7oW3Wfopxsvd/iGKhMTd/R5LUbozRQitDbhCMUzNhnnbCYm/RnDyzWXuPVdrphQfzMDKtxWexDDOt74tpInLgC0oxx9l3IFnubIPhTutrBcLqUOqnzLsc98bXPLmShqFIsLn1ZA6IfZeDqHv0j++kXLsLIMnHJ4e8H/SSGx6lzckIj9FJzuxmRLe4vf5MKGWYrFy8dpWdHoNNV6Bk2co/IYcfbpY30BLovGsxSrp5b/JiDYfPwTw5fzmWvTOB4BU9EyVl+HsVXmJ3H5QqG1vBr7MNLb905wRM9c1QPIx+
 xUddRseb
 5MFPQPncrhHcLwNuzcMGxJyY0jVs6JtY9uxLJYyOJGWrsq/6xV4vHWWo/0NGA2xBbXslBbTWTSes7WdtMNRDqqYwjxM8cy3N7AWNxD/01WseUF6PapvEjK9QjgyTlcNg8JuIjtoioPYUbHHmKAh5c/JsyzqUKBfU3BUR+A8ECWj98vNONlHw/1BIqxPNCeGxqv5SrShQ3gdDJ2qX6Un7/1PmLt3nk/GzkSk2fhmyrKp4c0X7B5OsaOUAK5Ve+RsFEK4O7pEDQpXNjfqYKhn+tOPYsTtPWL9BqgXf6kH9o9r4URGxVbhnqjZcBSpmSguATDUwPHoR2+4YasK8nLch85CA4a/F8mvPG05tUpBYxbYdIx3vN+ePRPMg1JmcVm9TWLAIM47RjrTYGiPxw6YoxrkQAWr05XAiPT13xgYfVLM3RXbO3azurWCNdxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

kernel test robot noticed the following build warnings:

[auto build test WARNING on sj/damon/next]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Shakeel-Butt/memcg-introduce-private-id-API-for-in-kernel-users/20251226-072954
base:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git damon/next
patch link:    https://lore.kernel.org/r/20251225232116.294540-9-shakeel.butt%40linux.dev
patch subject: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
config: arm64-randconfig-001-20251226 (https://download.01.org/0day-ci/archive/20251226/202512262045.CkWwCNp7-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251226/202512262045.CkWwCNp7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512262045.CkWwCNp7-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/damon/sysfs.c:2704:33: warning: format specifies type 'unsigned int' but the argument has type 'u64' (aka 'unsigned long long') [-Wformat]
    2704 |                 pr_info("id: %u, path: %s\n", mem_cgroup_id(memcg), path);
         |                              ~~               ^~~~~~~~~~~~~~~~~~~~
         |                              %llu
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   1 warning generated.


vim +2704 mm/damon/sysfs.c

c951cd3b89010c SeongJae Park 2022-03-22  2690  
a25dadf8af8ddc SeongJae Park 2022-11-18  2691  static ssize_t debug_show(struct kobject *kobj,
a25dadf8af8ddc SeongJae Park 2022-11-18  2692  		struct kobj_attribute *attr, char *buf)
a25dadf8af8ddc SeongJae Park 2022-11-18  2693  {
a25dadf8af8ddc SeongJae Park 2022-11-18  2694  #ifdef CONFIG_MEMCG
a25dadf8af8ddc SeongJae Park 2022-11-18  2695  	struct mem_cgroup *memcg;
a25dadf8af8ddc SeongJae Park 2022-11-18  2696  	char *path = kmalloc(sizeof(*path) * PATH_MAX, GFP_KERNEL);
a25dadf8af8ddc SeongJae Park 2022-11-18  2697  
a25dadf8af8ddc SeongJae Park 2022-11-18  2698  	if (!path)
a25dadf8af8ddc SeongJae Park 2022-11-18  2699  		return -ENOMEM;
a25dadf8af8ddc SeongJae Park 2022-11-18  2700  
a25dadf8af8ddc SeongJae Park 2022-11-18  2701  	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg; memcg =
a25dadf8af8ddc SeongJae Park 2022-11-18  2702  			mem_cgroup_iter(NULL, memcg, NULL)) {
a25dadf8af8ddc SeongJae Park 2022-11-18  2703  		cgroup_path(memcg->css.cgroup, path, PATH_MAX);
a25dadf8af8ddc SeongJae Park 2022-11-18 @2704  		pr_info("id: %u, path: %s\n", mem_cgroup_id(memcg), path);
a25dadf8af8ddc SeongJae Park 2022-11-18  2705  	}
a25dadf8af8ddc SeongJae Park 2022-11-18  2706  
a25dadf8af8ddc SeongJae Park 2022-11-18  2707  	kfree(path);
a25dadf8af8ddc SeongJae Park 2022-11-18  2708  #endif
a25dadf8af8ddc SeongJae Park 2022-11-18  2709  
a25dadf8af8ddc SeongJae Park 2022-11-18  2710  	return 0;
a25dadf8af8ddc SeongJae Park 2022-11-18  2711  }
a25dadf8af8ddc SeongJae Park 2022-11-18  2712  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

