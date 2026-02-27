Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C460BFD9E3D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1AFF6B0005; Fri, 27 Feb 2026 01:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC92A6B0088; Fri, 27 Feb 2026 01:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7D16B0089; Fri, 27 Feb 2026 01:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97B56B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:03:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F8221A052D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:03:49 +0000 (UTC)
X-FDA: 84489195378.20.7C55FA8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id E97EA20008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:03:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gB+YZJ+x;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772172226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sshwigJAX6f65gNTlOH93R2NUq9mh/IkLNRZoDBujjk=;
	b=hVHYXnZsG4wR/jGkgXXFEHwdy3E6XtUn7OHKcM3bEnbq//lReEBn6WX91SbXfkpj/mUlfu
	MMojciiy89drR8gEN+AhXlQpboHybHLSTxbg35baGaBiw1+IwCnoPCRCPyhQXkquSgh+1l
	ndJoR0P79Q9sPLLAhKf6p3y6Mo/e9zI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772172226; a=rsa-sha256;
	cv=none;
	b=b8StYtWx+49afLrXNS6vCvDQePgex5v1BNr4fE4Dsfb+9p51m23QTQUxkaug41rP1IL/Fo
	9Q0jZ0YWeNxQ4XgaAkFK3spvzrLvKsAWuK0Y37eH/a4g/r0SywK/2FX42jZo4hD6QOwpz1
	m5qapxkI88UpVKfn+jYYp2uvAD1lebs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gB+YZJ+x;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772172226; x=1803708226;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=womFZoMcXmoknjkJ674fsDEBofqxqg/e+sw1HuqnxWc=;
  b=gB+YZJ+xnubZqvIH0KuYUImARH+QyyrRmEZjvpesTtptBrRi/+B0NnsB
   ufv2piUckrA4Taukwd9KTJKVxEfJf0J6cV+m1mx2MT41CLnfLEdFs9rBw
   bSPUw6LcWPNNDBPuptCF/H7rR39xr4SL0Je0b2py14SP2IGs4h92kC9BT
   OyHYcUZeOLU44CnR3mdT6dksbxCONjw+Q0EPri3Szadt1j9r4YdKysWv5
   4QWfS4zLJdXjBRoGDFJjkHCu7HJxBUY/X/6rrIjksyDd25CylB08Hhn7f
   HntdcLmiAzLiBovSn6u2rVa7+LYdXtETPBJn23vLz/4WYk6wkOSATt3PX
   Q==;
X-CSE-ConnectionGUID: qsduuaFESBm8WDvshkbt7A==
X-CSE-MsgGUID: wp1mNDusS4S9xPHFe2fzJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="95868712"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="95868712"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 22:03:44 -0800
X-CSE-ConnectionGUID: vtUqWWtBTrqQu561y1GaXQ==
X-CSE-MsgGUID: VE5jgSE6RpmJV3IxR2vKag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="214690739"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 26 Feb 2026 22:03:40 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvqwq-00000000AEF-2p3i;
	Fri, 27 Feb 2026 06:03:36 +0000
Date: Fri, 27 Feb 2026 14:02:59 +0800
From: kernel test robot <lkp@intel.com>
To: Harry Yoo <harry.yoo@oracle.com>, venkat88@linux.ibm.com
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	ast@kernel.org, cgroups@vger.kernel.org, cl@gentwo.org,
	hannes@cmpxchg.org, hao.li@linux.dev, harry.yoo@oracle.com,
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
	rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, surenb@google.com, vbabka@suse.cz
Subject: Re: [PATCH] mm/slab: a debug patch to investigate the issue further
Message-ID: <202602271339.xhIvS2iX-lkp@intel.com>
References: <20260227030733.9517-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227030733.9517-1-harry.yoo@oracle.com>
X-Rspamd-Queue-Id: E97EA20008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: r6g3hob5bikwozmwbjdyifk7soghieqc
X-HE-Tag: 1772172225-359866
X-HE-Meta: U2FsdGVkX1/eMlKNLl61ibWSGlhuiKuEVGaoql1OZEdlzYdSjESOtBBFG3x9OfIQsHWqRncDbjoBVfrOHmC96U8SV1WzyGyMKAisFSBWPVgf+OjGtZVkbhEJfZRiIWrCtPcM2ktpH+IXi14q5XqROBmxq4JOsNDCqeLKJ2KbhHyIy5roW6omtsXORH0JHT6K4hHGAlROZGqOHTmpTO2A0olBWgBStft4SM5XD7OHsI9UOAJmUOEvgIJUeRd2+nKcdTeOUgUQrVw3O6nXigiscn8INUsSraKmt8+FMfmEPoPJfdnfPgTBXvQT8YvtNe53TI+MMcOaRuLVxJcbynF1iUQoBz4gUMAw7Mi0i/QVZYFxUSaiRf6W/Dr9owrPtZbEwbUsoUh/JAof+7WehECS0fYuQGEhSORxiSmoQ+Ao4OMZ8HxvM2ke90pxTTp9jxAMe04OuROy7AuAaIWL7rLCZxqPvdz20vKi2uSe1lJgcXkORgL2O8UaLhyMSxRzkp4T4gcE9OT4qokn0ni/tYMO/aRcfcwsYEDvUxGs+KYfiAVaoyEgAp2UAjTBZyybLNR1UuobJL9XMDDu6/kLX3O7vNS3smOLBldCXy53GyErxKcB5nAYqtI0yAzdnDJ/deV09vALG1LT7oAJeldZsb3ptIxfMde7tJa+MibhNkso+749M5RICoOEXR/tTHVC9FVWjeJfh6+Sv2wrECNw481D895rjUSjoP62pX8DDyYvGhiV8+ezc8vbz2jh9QTEvZmwV3q7EEOL/3vJK4dbi4IxwOw1heIjWVXAcREaZe7ZQiByJ8K+B7OP+FrSsfoznqg7e2vUJpIVo4kUoevamUWcQAy0dJctT6MlEl6E1hIXJwkN6D8h0b0aIgAyJS0DaY3cmoEsg+yE/rdjJn1+sFVl1e/4xhrFJ2DF7O4ZuHllfS12ctoDP/dhuIEuDQqVni87+gnENg/vNSbpr3gO+Gt
 yz58uarU
 KI9zic9BIlUqKVXALPWvQvE45e0BpQ+8Kr23+l/dUmH/MeyfsIMYeCt3R+0qYG9tre2LTkkPTblSKrPF576aG/2hF5fFWbA1WIqeKX7sAlAHlVoeS15pu3kZGHCFf+LZrVe0Y8pic5uXvYeFlJFEDyP28OfNvS7LYX3HekI9ZFj0SRAqyV9uW6vIFAAqh4uDb3QxOfiWp0w2xcsaSZAJuAyti/7CIX5pf0p+V+zqv3MnzJsFuSDAc0Px/X8M/z7+AY4ho4m/IdIHYubjRLygreX76eWIKExsdrJdBVE21ZeQKHF1fSYscQxd5REy3GUIzUiPqmT39DPt9a+CgGKQ6xWSmdDGp6RqBdClc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Harry-Yoo/mm-slab-a-debug-patch-to-investigate-the-issue-further/20260227-111246
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260227030733.9517-1-harry.yoo%40oracle.com
patch subject: [PATCH] mm/slab: a debug patch to investigate the issue further
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260227/202602271339.xhIvS2iX-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602271339.xhIvS2iX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602271339.xhIvS2iX-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/slub.c: In function 'slab_pad_check':
>> mm/slub.c:1330:13: error: implicit declaration of function 'obj_exts_in_slab'; did you mean 'obj_exts_in_object'? [-Werror=implicit-function-declaration]
    1330 |         if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
         |             ^~~~~~~~~~~~~~~~
         |             obj_exts_in_object
>> mm/slub.c:1332:30: error: implicit declaration of function 'obj_exts_offset_in_slab'; did you mean 'obj_exts_offset_in_object'? [-Werror=implicit-function-declaration]
    1332 |                 remainder -= obj_exts_offset_in_slab(s, slab);
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
         |                              obj_exts_offset_in_object
>> mm/slub.c:1333:30: error: implicit declaration of function 'obj_exts_size_in_slab' [-Werror=implicit-function-declaration]
    1333 |                 remainder -= obj_exts_size_in_slab(slab);
         |                              ^~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +1330 mm/slub.c

81819f0fc8285a Christoph Lameter          2007-05-06  1311  
39b264641a0c3b Christoph Lameter          2008-04-14  1312  /* Check the pad bytes at the end of a slab page */
adea9876180664 Ilya Leoshkevich           2024-06-21  1313  static pad_check_attributes void
adea9876180664 Ilya Leoshkevich           2024-06-21  1314  slab_pad_check(struct kmem_cache *s, struct slab *slab)
81819f0fc8285a Christoph Lameter          2007-05-06  1315  {
2492268472e7d3 Christoph Lameter          2007-07-17  1316  	u8 *start;
2492268472e7d3 Christoph Lameter          2007-07-17  1317  	u8 *fault;
2492268472e7d3 Christoph Lameter          2007-07-17  1318  	u8 *end;
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1319  	u8 *pad;
2492268472e7d3 Christoph Lameter          2007-07-17  1320  	int length;
2492268472e7d3 Christoph Lameter          2007-07-17  1321  	int remainder;
81819f0fc8285a Christoph Lameter          2007-05-06  1322  
81819f0fc8285a Christoph Lameter          2007-05-06  1323  	if (!(s->flags & SLAB_POISON))
a204e6d626126d Miaohe Lin                 2022-04-19  1324  		return;
81819f0fc8285a Christoph Lameter          2007-05-06  1325  
bb192ed9aa7191 Vlastimil Babka            2021-11-03  1326  	start = slab_address(slab);
bb192ed9aa7191 Vlastimil Babka            2021-11-03  1327  	length = slab_size(slab);
39b264641a0c3b Christoph Lameter          2008-04-14  1328  	end = start + length;
70089d01880750 Harry Yoo                  2026-01-13  1329  
a77d6d33868502 Harry Yoo                  2026-01-13 @1330  	if (obj_exts_in_slab(s, slab) && !obj_exts_in_object(s, slab)) {
70089d01880750 Harry Yoo                  2026-01-13  1331  		remainder = length;
70089d01880750 Harry Yoo                  2026-01-13 @1332  		remainder -= obj_exts_offset_in_slab(s, slab);
70089d01880750 Harry Yoo                  2026-01-13 @1333  		remainder -= obj_exts_size_in_slab(slab);
70089d01880750 Harry Yoo                  2026-01-13  1334  	} else {
39b264641a0c3b Christoph Lameter          2008-04-14  1335  		remainder = length % s->size;
70089d01880750 Harry Yoo                  2026-01-13  1336  	}
70089d01880750 Harry Yoo                  2026-01-13  1337  
81819f0fc8285a Christoph Lameter          2007-05-06  1338  	if (!remainder)
a204e6d626126d Miaohe Lin                 2022-04-19  1339  		return;
81819f0fc8285a Christoph Lameter          2007-05-06  1340  
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1341  	pad = end - remainder;
a79316c6178ca4 Andrey Ryabinin            2015-02-13  1342  	metadata_access_enable();
aa1ef4d7b3f67f Andrey Konovalov           2020-12-22  1343  	fault = memchr_inv(kasan_reset_tag(pad), POISON_INUSE, remainder);
a79316c6178ca4 Andrey Ryabinin            2015-02-13  1344  	metadata_access_disable();
2492268472e7d3 Christoph Lameter          2007-07-17  1345  	if (!fault)
a204e6d626126d Miaohe Lin                 2022-04-19  1346  		return;
2492268472e7d3 Christoph Lameter          2007-07-17  1347  	while (end > fault && end[-1] == POISON_INUSE)
2492268472e7d3 Christoph Lameter          2007-07-17  1348  		end--;
2492268472e7d3 Christoph Lameter          2007-07-17  1349  
3f6f32b14ab354 Hyesoo Yu                  2025-02-26  1350  	slab_bug(s, "Padding overwritten. 0x%p-0x%p @offset=%tu",
e1b70dd1e6429f Miles Chen                 2019-11-30  1351  		 fault, end - 1, fault - start);
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1352  	print_section(KERN_ERR, "Padding ", pad, remainder);
3f6f32b14ab354 Hyesoo Yu                  2025-02-26  1353  	__slab_err(slab);
2492268472e7d3 Christoph Lameter          2007-07-17  1354  
5d682681f8a2bd Balasubramani Vivekanandan 2018-01-31  1355  	restore_bytes(s, "slab padding", POISON_INUSE, fault, end);
81819f0fc8285a Christoph Lameter          2007-05-06  1356  }
81819f0fc8285a Christoph Lameter          2007-05-06  1357  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

