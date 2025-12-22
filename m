Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD21E6B257
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A566B009E; Mon, 22 Dec 2025 17:19:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21A646B009F; Mon, 22 Dec 2025 17:19:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127A06B00A0; Mon, 22 Dec 2025 17:19:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F404F6B009E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:19:21 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4B48132AB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:19:21 +0000 (UTC)
X-FDA: 84248524122.06.1F73218
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf10.hostedemail.com (Postfix) with ESMTP id 233A3C000C
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:19:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nafX/XMc";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+XC5YT5cdsj1nRAWBzUZkuED3ebpY8hPxGLJsyURVA=;
	b=NFUb/BrFVhQOpMR7AymTRiA5ywT8YZqKQEpaUCdzVYFKJl6WER/ZNsXkescuuiFvHppgiU
	DURbHZafYETv6U62fWAfB6rXLWWnz/TkjEYPFcdbjuD1TbE8zSF4MKehm6QcD8jKmf5hg4
	JfB4x7T3ZYmkKiMnmHRVumLCjh4wfyI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="nafX/XMc";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441959; a=rsa-sha256;
	cv=none;
	b=GAevG/RDWlwqMeWZLTxRATpOhKdPRsNn3zmmpbje+c+x4XxSe1oZUiYQwBqXc/aLh4mkFb
	GrQDdI1Ly/MpxfS4hvqRubcl8i5w7XQSk8V9yF7JrLthxfZLFTkT74IRm85ev93qMiDOfq
	zkksuLEa/KIC4Y/O0E+8PoROV3HE1Ko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766441959; x=1797977959;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dQ/s5g4Ian6ioHx/lf1wibw3buSKQJjac3nIOVr/Irw=;
  b=nafX/XMcjWTZvpx12UIJdqTTiBF0JJsyOYtxXYtTzBAQHzQayhn0xnHW
   +7fwn6qbiRm+U45j2tO4nxsYywU8v/jwsB4Vq8wSN8gz7tnPdUbVfqLt+
   GZ7glPH7ClJln6VTH+9+uDwZlrJ1k2HXVIUodoRzJSxFDjXnF4J+6+2ir
   Vt/imhwLO4CNHpceoi4oiomj6PdFl/xAY6IliXqgbkuzI23t0+WZKJdUl
   8IMEJ9wyQm6t28PtHYUmKxDRsR0dkxU2PDSmxNmo9iyR4FeeJLmjfU1vp
   mWNhz4OZs+D2kNOgBexw++yF/iLQf2PjXCZXYEsAE8YmcoBcrIZDGwCRm
   w==;
X-CSE-ConnectionGUID: 9o/iWeTNQ+evFmAS1lep7g==
X-CSE-MsgGUID: QfuWQJdHRyqlHMaHUdX3WQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="79017622"
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="79017622"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 14:19:17 -0800
X-CSE-ConnectionGUID: 8ZdtjugMTpaUyreTt9B8MA==
X-CSE-MsgGUID: w98j602qRNi2vVHfzDgBYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,169,1763452800"; 
   d="scan'208";a="230287947"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 22 Dec 2025 14:19:13 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXoFC-000000001Ap-13Vn;
	Mon, 22 Dec 2025 22:19:10 +0000
Date: Tue, 23 Dec 2025 06:18:50 +0800
From: kernel test robot <lkp@intel.com>
To: Bing Jiao <bingjiao@google.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, akpm@linux-foundation.org,
	gourry@gourry.net, longman@redhat.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, tj@kernel.org, mkoutny@suse.com,
	david@kernel.org, zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, cgroups@vger.kernel.org,
	Bing Jiao <bingjiao@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmscan: respect mems_effective in
 demote_folio_list()
Message-ID: <202512230655.QvO6dmjt-lkp@intel.com>
References: <20251221233635.3761887-2-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251221233635.3761887-2-bingjiao@google.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: ry9w9ttwamu6amcubsd3434zucz7ygzm
X-Rspam-User: 
X-Rspamd-Queue-Id: 233A3C000C
X-HE-Tag: 1766441958-199363
X-HE-Meta: U2FsdGVkX18kSA7lVSmTLkmumISYThz7VV/0Lww3Vsa9VLfCdJPjSn6s6AXKO8ItTVNqUwSbiQOJ46ntqw+gK5uepG+N0peKKFKKSV26BpAZ10Xe9YMFdYSzyiut/4GBxiOX7n2cjT1rehfWSlDQvzeW+5w3VEhTTDrWArloF3p7nVIcI0xJi+6RpMwB/atKLUL04yWTNuhaKrw5k2EsM31D4AX3ZWSeQOu9BhVKVGzQNh/VRTldGMEM4pf4UljCKJN6TuwZGlktGK3+rG4NFJ7OLQ8e87o/xPp8WypWs4epWnB8nXK2Senkd7FvOYSsk9in4WkTSRSLzT+dfbj/9i2fmlX4h7dcKDBPbh4inU98xsxyMe74qfyN8b+odF3H68YILSA8+7Teq9W1iDe7Uf/hTrvGxYEdlPztOE87ByYwvz4JFQ1i62VX0wNY1TjolNv153YOfvoDPipPHuGGF5q9K9WUUo68hmftSTq8PAoaX4CZnrmI++RCTO2AMxY03XLp38nW9aCH39XRluDonxrmLexjMZ+5drjkrhLO1h4wKo49WGdiJujVdZP30JB1u46MhJ3xpSUaDrXxA9/dy4/yLgsSyUthUiezgKoAkv1/5cjXu41bQB2VLmT1s7pTnAoy3dSV0ocMh24ezYK/6OgRyV+moqUDXgjrEmtoQ+PbhprpGxDGuQFuOQXJCAST07gQMCyoBho/iFBaa/GNeO4PvVnl/QbWP8pjQtsq2pglYQGxKndt4X1x9/eFr2r3XtW8cDJCF6gVzdwMjqva961WTO16YQMqLQJxBAgBNlSyZ69pAplasdzWMl2caE3tyzlOtXNmyPUA6jRcw1wUS88fUT8Cgh9TcTgPcZkB7xRFqY+Ia8Aze/lDbNiAsqshTKiZ2yNB2/qVoWWIGci6wtdoU23ecl+b0ZE14qsfWfictWOM8NpP9B6I5YnwH8GI7FscHy/w+wqIynROfop
 SDExZp3R
 VU77XF80ovwZ0JfNf2ltyLZ+aeoSEG0xD6b8dv50CfptjZvg5Jaw16THO6NGF9PV0LSmDhDFAmr+m216xyawwtTVxjECdlF43RafMJjbyW8MY0hriLHGepO/To3Ln31cmNjlbXqyJXWkdKO6sNPes0nb0EM5z15yRSyB2nKehzaw55zxVFv8IRNASPtX0Dq+jM80hIP47ecJJDm/rLf9YRUk4SfMuKPv4kGp/1K60WwWIbTVqyH/iS5F941YFB/0/SP/RyoCU/2kEaZ0Y36mp+C3lAHtA/mXSXFrPcHI3AY4vcOgLmOHicHcg4xdfgfIWl7gRNO+WtfalrWsVm4uLkdpwYIMtCMriieI9RoyqXxeYuh+Mpmo9rNhc/ChQBQQvFJozQgJA6sH/8gscfMypGHcAQG7o7VDX93ALzE0PUC7ZD0MtxEb9RkMiZy2Yoov0rQrft0/6j+5cb08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bing,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on tj-cgroup/for-next linus/master v6.19-rc2 next-20251219]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bing-Jiao/mm-vmscan-respect-mems_effective-in-demote_folio_list/20251222-074143
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251221233635.3761887-2-bingjiao%40google.com
patch subject: [PATCH v2 1/2] mm/vmscan: respect mems_effective in demote_folio_list()
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20251223/202512230655.QvO6dmjt-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251223/202512230655.QvO6dmjt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512230655.QvO6dmjt-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/bpf.h:32,
                    from include/linux/security.h:35,
                    from include/linux/perf_event.h:53,
                    from include/linux/trace_events.h:10,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:96,
                    from include/linux/syscalls_api.h:1,
                    from kernel/sched/sched.h:61,
                    from kernel/sched/rq-offsets.c:5:
   include/linux/memcontrol.h: In function 'mem_cgroup_filter_mems_allowed':
>> include/linux/memcontrol.h:1824:1: warning: no return statement in function returning non-void [-Wreturn-type]
    1824 | }
         | ^
--
   In file included from include/linux/bpf.h:32,
                    from include/linux/security.h:35,
                    from include/linux/perf_event.h:53,
                    from include/linux/trace_events.h:10,
                    from include/trace/syscall.h:7,
                    from include/linux/syscalls.h:96,
                    from include/linux/syscalls_api.h:1,
                    from kernel/sched/sched.h:61,
                    from kernel/sched/rq-offsets.c:5:
   include/linux/memcontrol.h: In function 'mem_cgroup_filter_mems_allowed':
>> include/linux/memcontrol.h:1824:1: warning: no return statement in function returning non-void [-Wreturn-type]
    1824 | }
         | ^


vim +1824 include/linux/memcontrol.h

  1820	
  1821	static inline bool mem_cgroup_filter_mems_allowed(struct mem_cgroup *memcg,
  1822							  nodemask_t *mask)
  1823	{
> 1824	}
  1825	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

