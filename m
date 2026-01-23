Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E122D6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2606B03A5; Thu, 22 Jan 2026 23:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD9A6B03A6; Thu, 22 Jan 2026 23:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0863F6B03A7; Thu, 22 Jan 2026 23:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9E0C6B03A5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:37:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9848DCB312
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:12:37 +0000 (UTC)
X-FDA: 84361604754.27.EFE5E1B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf19.hostedemail.com (Postfix) with ESMTP id 016431A0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 02:12:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D0GMsk11;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769134355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh2akg1saR5k5ykvtx8pipSUN2zAQL6257Trwp0QkWM=;
	b=z4lwTEwLEjxpOqM+1TV0B6A/cpNyVYBNJAyL0JUA3y5BA9LIZrpGREY+INmBU3EH3XYtJx
	IBDEXYFfUbaBM4YwvX+tC5FKKK/BF3pAOVLRE0ebhsIwT5iAtTgs89Wby+ZxMk+2FJaOvO
	Lagj3MS/pfAu38xpyJlZGrhq2LN/K9U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D0GMsk11;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769134355; a=rsa-sha256;
	cv=none;
	b=7u2VGloIS64I1G4tMdLktgk/zv1yr/inr/Gvq/HhlT0HMkuRaT9CvvgZknyTABGunc7OGX
	2rsoUB0m5yeM4qOFRCF6eorTJMuHUO64YKfuhDhNcctYSP9z640vM+bPtB1Md8rKf4aJQZ
	JRxqTphIaJPYgvvKkSDIXD7hhWMipQo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769134356; x=1800670356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Urg92rPlSCxkcW9xwWZMP1kRZiw/qhuHYe6F6frl7B0=;
  b=D0GMsk11ZC8G29S8zhE7fdk/5NOIKBd8b1k8AloGtR0u7nY235YshAY3
   QXKkUlj2P8zj3PuEKF/CrzgCZlHjzM1J2fsj51LEah87RwueIDeOBLgVe
   8qie3OKTMwj/ZS7BhqA2iHErBsCIlp5+RGKf7xjigWqfog82IUrVuyZO1
   Kcvuji5JiQKRP8yEN8KKU8TVfoIjwiJefZ/ophUYMJooKKhanHeuGlUKU
   E5MuBhz9hVdvQI+BZvwReOFUdQLUgUiMgcn/5Yv1yxcuOLhoN4ZWeaVuI
   t1sLOs797Z9aIAJR3a/r0LL0+AN2/lecdYcj2NjGWprkFTA0CWoehk/qk
   Q==;
X-CSE-ConnectionGUID: SkB20qZbRbK34jw0NzJ7eA==
X-CSE-MsgGUID: zD7EYiLnRT6qQlgP/oFAkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="81827756"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="81827756"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 18:12:34 -0800
X-CSE-ConnectionGUID: ZXJ8HK+9RoiuAX4b/V1nhg==
X-CSE-MsgGUID: kenf7FazSm+yHFpZFug07w==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 22 Jan 2026 18:12:29 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vj6ew-00000000TQo-2Ia2;
	Fri, 23 Jan 2026 02:12:26 +0000
Date: Fri, 23 Jan 2026 10:11:33 +0800
From: kernel test robot <lkp@intel.com>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: oe-kbuild-all@lists.linux.dev, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <202601231052.RfGOFd3g-lkp@intel.com>
References: <20260122161009.3865888-5-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122161009.3865888-5-thierry.reding@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 016431A0004
X-Stat-Signature: mqphxgtw9y1t33ti681kx4yqcezhtqsy
X-Rspam-User: 
X-HE-Tag: 1769134354-299056
X-HE-Meta: U2FsdGVkX19VeOErl/LC+q256sKYXvyPg8DyJAx+hDSeWWye3bBek6mer2i5Of89BhNUK9Ez/4U4UvwnDhTZqJmWjvmd4KMOAcUVvL+FJBx9Scui4cV/ylenDr6F0dvQccUpQ0MzN0qIw04jspEZZBRwA07Jofpnrsd42N8/YS11tXVuQ8lBKpck6uOR1b8L7rbh/PsIFLjRBVxLMxCIhy9vNebcEPDQWeMPpRh7GMRfOKASK00R/xuTK58ZhrnJHK+Oh4eX30QHrrjdrPg40oP8/XCnHQ+KDCLpki8fxueWYgxQxmuoq5uDaG6909Ncc8KoEA+JHWLsPAPf1LYNCnK7JeJ8E29vfJ4oO3T9kBg+d3x83YTlqaTdQzTwH83+Ck/nkqaVzMKUmOR1GM4l19afcZiUlHjdtQXWIN2/4kptITJr+2Ofiel+QDk842Jl+b1siPOEavSiaH4OLpBPJIfOF/n/HViUoGyBjcfNOC1xKtj6PRhWzBF83bg+NN3cFYDvyMppj23NMB2eaucxa2qP75IeSFekMfH62iRW+sLilDctcZTdfqddOeF/Bx78UecvCnSx/rORTFsmsjqDpwvHeayBA83rgJxif4DbcmaBTgesr43MSLgcOuuRAUqqSF7VuYLxifh3C3MrzMMGvdlDSzx2juXyI11PYBC/vg6kbl/jnzfNMsEvAQWY05VIdBmRB80rYaq7wDvj05J8WJEAvC1zwE1IyE11KvfS82xv5Pz6Sh4Byksu5XFGiiZo3xQDeL8C3GFsLTy5o08Zow2FYPiTJXVwVEKws2MOWC+XdNlXZBJ6alSdrTR0nl0Gv+k/ZYsMbPnmMqpn1DHMP+T5NqBhDpuX5OWACLExN15v5hkNJOB2VHiuqkliCUCsP+0csv4kK3HFpMH5PUCIpPUA8XKLDJSPjX4eXgip6q6uqeiSKFMgbbcCYS5/hiTbsWc+GkJYYGedo2bBoRa
 WYIeRkK1
 Aq78gNdCTGKvkK6LmT1J3wy0GYdjZT3rhdPMsA0iaDBshtx1iq/2awtJq3GajXtVIaAy5kCa0bfgslrOl3rcrOVG59QGjRmcDjYw0iXLbzEejBf3eaDgTPRIf+X+iZks05OUUGth/fIsEZK0rIQe1/HSJQVfW2lbxhUKzd42FAK/a0a/PJRujkdzi4cQ9eztX0kx9vkMztLrwGYUshKLqpNuvHVQmdCLhtbdnMbQRBfEmCAA2lrhWZ/OktITVEOXqCyVUl+l8AofLSW5r9dtrA0AhvnEZrqsfqbmhpKXB4wlTlRECfbnKUy8c96mBVoRHP87TNuhOLKZOX9g+ZzjhksDcUQ02cyGjHhi1/V05l6GztPY4SEHn2A6mgxV3P8OY2th3HUAkf/k8qr6hn3w2aQplPLWcXWzvwpOYXgW1LT4R62EHprX9E8hQMqQI6TxtBcuYE9QBlaKZ2jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on next-20260122]
[cannot apply to drm-misc/drm-misc-next robh/for-next linus/master v6.19-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thierry-Reding/dt-bindings-reserved-memory-Document-Tegra-VPR/20260123-001244
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260122161009.3865888-5-thierry.reding%40kernel.org
patch subject: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
config: openrisc-randconfig-r072-20260123 (https://download.01.org/0day-ci/archive/20260123/202601231052.RfGOFd3g-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.2.0
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260123/202601231052.RfGOFd3g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601231052.RfGOFd3g-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/cma_sysfs.c: In function 'cma_sysfs_init':
>> mm/cma_sysfs.c:119:25: error: 'cma_area_count' undeclared (first use in this function); did you mean 'cma_early_area_count'?
     119 |         for (i = 0; i < cma_area_count; i++) {
         |                         ^~~~~~~~~~~~~~
         |                         cma_early_area_count
   mm/cma_sysfs.c:119:25: note: each undeclared identifier is reported only once for each function it appears in
>> mm/cma_sysfs.c:126:24: error: 'cma_areas' undeclared (first use in this function); did you mean 'cma_attrs'?
     126 |                 cma = &cma_areas[i];
         |                        ^~~~~~~~~
         |                        cma_attrs


vim +119 mm/cma_sysfs.c

43ca106fa8ec7d Minchan Kim 2021-05-04  107  
43ca106fa8ec7d Minchan Kim 2021-05-04  108  static int __init cma_sysfs_init(void)
43ca106fa8ec7d Minchan Kim 2021-05-04  109  {
43ca106fa8ec7d Minchan Kim 2021-05-04  110  	struct kobject *cma_kobj_root;
43ca106fa8ec7d Minchan Kim 2021-05-04  111  	struct cma_kobject *cma_kobj;
43ca106fa8ec7d Minchan Kim 2021-05-04  112  	struct cma *cma;
43ca106fa8ec7d Minchan Kim 2021-05-04  113  	int i, err;
43ca106fa8ec7d Minchan Kim 2021-05-04  114  
43ca106fa8ec7d Minchan Kim 2021-05-04  115  	cma_kobj_root = kobject_create_and_add("cma", mm_kobj);
43ca106fa8ec7d Minchan Kim 2021-05-04  116  	if (!cma_kobj_root)
43ca106fa8ec7d Minchan Kim 2021-05-04  117  		return -ENOMEM;
43ca106fa8ec7d Minchan Kim 2021-05-04  118  
43ca106fa8ec7d Minchan Kim 2021-05-04 @119  	for (i = 0; i < cma_area_count; i++) {
43ca106fa8ec7d Minchan Kim 2021-05-04  120  		cma_kobj = kzalloc(sizeof(*cma_kobj), GFP_KERNEL);
43ca106fa8ec7d Minchan Kim 2021-05-04  121  		if (!cma_kobj) {
43ca106fa8ec7d Minchan Kim 2021-05-04  122  			err = -ENOMEM;
43ca106fa8ec7d Minchan Kim 2021-05-04  123  			goto out;
43ca106fa8ec7d Minchan Kim 2021-05-04  124  		}
43ca106fa8ec7d Minchan Kim 2021-05-04  125  
43ca106fa8ec7d Minchan Kim 2021-05-04 @126  		cma = &cma_areas[i];

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

