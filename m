Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C57CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6748E0006; Wed,  5 Nov 2025 20:43:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAE428E0002; Wed,  5 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4278E0006; Wed,  5 Nov 2025 20:43:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0C68E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:43:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 406231604DB
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:43:08 +0000 (UTC)
X-FDA: 84078484056.07.8C4CDEB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 15E50A0007
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:43:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SbrAmcbq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762393386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGjalGWK+vwk9dPNtD22Weoh/gUOm9JIVNkXFSUGeqA=;
	b=qnojFjc3PLrE3HcwjnyT4HT9n51ahKusNFM63O3uxdBmTc6iOHkHqQ/eY8h02HcwWRBCjY
	lOr28UJrezYOqzYLH7o9B/edWxfns89kmvMZNtuD0iUPNUoEO7jo8yeeyWY+dMOdSmOfWQ
	7gDD3cYmwXP1gIivJLsRmE+/KzTYJmM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SbrAmcbq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762393386; a=rsa-sha256;
	cv=none;
	b=53kLfc4POVjdPTXdS+WIXVQOoIKW4Un3Mnal7NGeBaYyOMey5qjg4tI+xMQgTnD4LLX+1x
	2OTcvgBXnymymvWDI+Tu3UccsT/Vm9YgnxHGSd/e9Ew7UoPiCCPKFTeW1lp3GlbQHlTC+p
	UouZ1wYgip3KvRyMcVCgG6dpJ1Y64jA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762393385; x=1793929385;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2BVMpR3FHyZ+X/hxS26Deu2WAC/NgwDf1oq+a7rG/6Y=;
  b=SbrAmcbqOwN3lwaGv+n3OISDKLp8NXV/nVp0Hs5BUUNdKxxaGTNOCWqA
   GaRbgfFEPAOCJS1rS2qKxvqaMbKz28VWYByn21Bgf/hc2q/K5xKLza0ix
   U1asKXqfuH3G+4FGRWwM6303fJv3RH6X7PihioejnokATV76MdibjRBUi
   hWCcRAomMFECwpHckwIWqIKIhu2tsEaCEiQoO2/jQUrkI5KJQH+n6/844
   jesXf7exWzOZjKhPYgZ5QBXcarjXcXwxzEAoRVZ8yNpZYRT2TaJmbOvPs
   KXih1bEH+g3ODCQ7zK68rwbQPvD1e6sb6MJWBIerGBc56XvFyFtS0aZer
   Q==;
X-CSE-ConnectionGUID: MY0cakxpREq/VyAioxunaA==
X-CSE-MsgGUID: LjmKoS2/RcOjSbT7pgQqIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11604"; a="87151543"
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="87151543"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 17:43:03 -0800
X-CSE-ConnectionGUID: CJWimRuKSDGhm1KNZzS0Ug==
X-CSE-MsgGUID: iOJKe8OyRfez6UZyGvb2Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,283,1754982000"; 
   d="scan'208";a="191976026"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 05 Nov 2025 17:43:00 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGp1e-000TL2-02;
	Thu, 06 Nov 2025 01:42:58 +0000
Date: Thu, 6 Nov 2025 09:42:22 +0800
From: kernel test robot <lkp@intel.com>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	m.wieczorretman@pm.me, stable@vger.kernel.org,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Baoquan He <bhe@redhat.com>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
Message-ID: <202511060927.eg2dcKpK-lkp@intel.com>
References: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman@pm.me>
X-Rspamd-Queue-Id: 15E50A0007
X-Stat-Signature: jtjtddjhdmkctf9bafm5emisk7ixckq8
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762393384-892996
X-HE-Meta: U2FsdGVkX19ze346SS6fhm8yONftg0ogv4EfXelCs7Zonktrqh1yCloCuXiH5zOVbH/Yszcmy7yGwBSoNPbDitDVmNQECdmds6U8j7xw2UsXNUJiO8N/t6rb+YbhPq8c9cafuCsF0fZiapzR5qAmjqJ/Cz/VCkVfhGBC+EPBt6RRg+uaKr7lcAaq7Gb3o+9k/AhsSMWdl15oWQhtERjtwSd9w4bIAPoJsO9gsAf8fCs/foP1VIlJjPShjKcn+sUVZZUhkfK2LmyxU6XB764pV8c8KTtPVlXqD2n7cNlbUSRqEFgQNpiX80V8mhMbnx5F37fr4CT2rOx/GZeE7A6maxAtjPWcDOlQFOvTxfuYV92t8l4sy5N2zsgyC17lFrRRRdyaX6SPn2+FanQzYCEMnF7yg2r14YHb7cbiq5HmLe4+RahMIkq6B1sx7DHoA3xIPoAKw8SAG9MGQ6DswdyNNPEEH4Cs4a3RUdrlbq9EpwbnwCi4RsrvcUx5Tg4JTLTGhwoqpMi156l3rHlbsskDmjH6qW60miZ3bMNXfPci6jG+lkee69BGlOSC++mucQ57DQqx32MtRW4aY5dXN6I+Z9/KdBhki60ZZnL39TWsSPtkQvd5FotuAc9iBoZeH/J+8tPF4uQNGKcQrqQp2Zf6Hty2P91CWexRZRNDZT9T+xConPt0AQw91880uPtc3VdzUKSiyU7uXnXJBJ8yJRkXgUqmNYim2Owky2cKSNqSVCQFfsVoHIrJa5asuETCWRg7WfGv4WGOntrmfQfzcC6fKISBjIRBLgK4j2D+EqzzM0hexBKajofROV6VUvmZwCTB8vsByxiD9H/EC206A/qSHa9jbCswX0oyX7oW3F/TfIBVz5fAwmAYqczDoClw45zhECb+KoQiS+jbsrd9z8mJSvrrfNVFnAyeQ4gdATKaG/m9ZOw7H//r135WTBIilsRLInCnl+GaEwKsDAcVOAx
 UOV8l+75
 E8z8ekLZkWzObxVdyzrRa/b7xXeuQzZOW1TRwG1BmzMryw1KazSZA2NSJBNKfg67CveU6keKuHlfPhxvHntPwV+rvlIcCj3y5ywIfhjtQTJQ0DsL8sNs3AgLXnemrEweicYPHS1uygtm4G8SCMHJboB1TU+vn0nCMUpa3s4U2B4ACsajW74UiHmxLDZ0o1bG2eGQDicnWIFoz4aqulQRDeW/VLpwcPytuadsjUThyOwxWiAx/WNVshpa5AoF3haavV5kaGXJV+occASWF937DjyEbGI+pe7VeDTosoDIhXO24wwSzxpVNxN0oJORfjXsmM/6Lssgz545nMfH6FygYA7Idd6G8+SbQolbVRXlmJAjsemQnhuVrruCQ25TeCtd2N0Sy9BEhG02uwlQMQxnaT9fwesWSAS/4yia42wJc51bE3lo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maciej,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc4 next-20251105]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Maciej-Wieczor-Retman/kasan-Unpoison-pcpu-chunks-with-base-address-tag/20251104-225204
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/821677dd824d003cc5b7a77891db4723e23518ea.1762267022.git.m.wieczorretman%40pm.me
patch subject: [PATCH v1 1/2] kasan: Unpoison pcpu chunks with base address tag
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20251106/202511060927.eg2dcKpK-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project d2625a438020ad35330cda29c3def102c1687b1b)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251106/202511060927.eg2dcKpK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511060927.eg2dcKpK-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/kasan/common.c:584:6: warning: no previous prototype for function '__kasan_unpoison_vmap_areas' [-Wmissing-prototypes]
     584 | void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
         |      ^
   mm/kasan/common.c:584:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     584 | void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
         | ^
         | static 
   1 warning generated.


vim +/__kasan_unpoison_vmap_areas +584 mm/kasan/common.c

   583	
 > 584	void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

