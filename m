Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D2A9CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 04:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D24C28000A; Fri, 22 Aug 2025 00:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181248E0056; Fri, 22 Aug 2025 00:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0712228000A; Fri, 22 Aug 2025 00:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E51268E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:02:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E94E59F27
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:02:16 +0000 (UTC)
X-FDA: 83803045872.26.92933EE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE9A21C000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:02:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRydDm1N;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755835334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qwXRPeaS2aqa1lbj8n7nv5gztfyu63EY2RryMM5lfc=;
	b=VDwmCl3FJnRk18p5K/j9T4yVu1pfj0KoibaXgmGNy+2+lgAk+U2Fbtj5aRu0C84/FoSj5k
	5yZWMey25ibjWn8wotY3fwRxe2URW3CogQS/+mBMIjjPtfutCD4COSYpVfkzG5jsvw5Lpq
	IasWbRXDPR9gh+mYRiXsgzk1QyWHeK8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YRydDm1N;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755835334; a=rsa-sha256;
	cv=none;
	b=lJDEeNs0D3ImAJbQVRYd42YoYAPDqOStBxz6AWE3Hm/qSlXqS/twLhQ95e4ZAs48WkEzs3
	a7XzFTIcA7IjK7FgOneE65qHy4CGsHWUSHxCb9by8u+fy4dNJGnd8o8GOs9IRUG0HSaAmi
	2Ebt32rsVC8s4Xt9LK7RJKeIAzxTTNg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755835334; x=1787371334;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/2ROtHmJaUr9LhJbv1++PQhIJX2V9C+1ND0616Z6a24=;
  b=YRydDm1NGDrsN6QF0X+7FQRXjYKOy0b6b7swEGx7oqx7yKnE6UUvEG5U
   IFP3nS7yWt6woo+btQIN0eXAZ/CC3uaGVSuPlKyt5+M+0wf7DuzCQnnLt
   sr5mc7XGtksiiaLHKTvC9d4w9bO5SYxmBAk9ivq58CblTwhgBcNltkKuX
   XePV/P9+7V+pO4E/WCP9MfQR2eNPLB1YME9bvvzqtnj0avYSqmCYKajEN
   WqgO81ha45wfwcQcxD5KSVNOIzj33y57dA1EpidN8OQl6v/5g/iMIOcrm
   qdx9cxyFjXqFALC5uZV8Xf+adPES+UFu2y3LLNWyC/tniIGFoAufN0VBn
   Q==;
X-CSE-ConnectionGUID: 1DORfvhuS/6ho/qEJfBqSA==
X-CSE-MsgGUID: FaTItH07Rs2b2QQQU8eooA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57339851"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="57339851"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 21:02:04 -0700
X-CSE-ConnectionGUID: HoNmLB6YRbmMZ5elSlrDeg==
X-CSE-MsgGUID: VVHpgrRVTgiUxTAicaXTvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="168804505"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 21 Aug 2025 21:01:53 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1upIxI-000Ktb-17;
	Fri, 22 Aug 2025 04:01:12 +0000
Date: Fri, 22 Aug 2025 11:59:51 +0800
From: kernel test robot <lkp@intel.com>
To: Bhupesh <bhupesh@igalia.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bhupesh@igalia.com,
	kernel-dev@igalia.com, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	oliver.sang@intel.com, lkp@intel.com, laoar.shao@gmail.com,
	pmladek@suse.com, rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com, arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl, peterz@infradead.org, willy@infradead.org,
	david@redhat.com, viro@zeniv.linux.org.uk, keescook@chromium.org,
	ebiederm@xmission.com, brauner@kernel.org, jack@suse.cz,
	mingo@redhat.com, juri.lelli@redhat.com, bsegall@google.com,
	mgorman@suse.de
Subject: Re: [PATCH v8 3/5] treewide: Replace 'get_task_comm()' with
 'strscpy_pad()'
Message-ID: <202508221127.LiaxcbdW-lkp@intel.com>
References: <20250821102152.323367-4-bhupesh@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821102152.323367-4-bhupesh@igalia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BE9A21C000C
X-Stat-Signature: f6ka5n5r8jz77o9796gux6awmqrapksf
X-Rspam-User: 
X-HE-Tag: 1755835333-748298
X-HE-Meta: U2FsdGVkX19HG5YeqsJOvzHuHqqfgo2NoO2kZjwyMJKUPfj0MRa8XlgMMF78t3nI7Srk7WM1JRUT0Z+1QXePFw6S8BGKphc/Y8QH2pTfiqqJaNUo9E8iOjRnjpRV1q46IlGWKXjddsF9zONevcppJyMEOyE+8WlWmQK1hNCHxcbPyLZVMV121ph86wS07De/AYS5o/6Dxm/zpDDSXNioqr6zzXMj08/isp4kTVpv7LdJwcrXci3m6fCQYoGZ/s91q8nx9nhmw/wHYFHtPN7uttQju/e7Js8YxuZmzMQBSWCa93444t1NY0UihXm3yqgSWLh4CuJBFEnoj9u47Ltrqt+1YNduR7ZdqI8ZqNhLmZlNczK0lh6whLCr8+tfzhVbRZ/cjPQNZqzPdsJCDRm/E10Bn5i3/nTKRvCDXDBoDz7vn+V81yW2swfk586fQDZzvove6F2WmOdTwUtKmyBK/pu+pkoi87Bj/MB0rRjJKAPfdSwcgTjg3PYdEtq5XHfUiK8y7r/OrMlAiI5xL132mYbnnTcpYvkoxNUDnIyZC9Cs2f9stqhUtWgK2ScGbr4U7CsMUArL5l0iuzaoWDFlyEHHHhLIFjL0AQrATGTtzXmZ+jQZZeoPkbNoJQ54Xz5pTZPYILKxNMi//SjtBVZuq7v5GJCvNFRxK4L+3JvZ6KFGtv1+ob+NNB0C9hfD0h7XKM9WdBCO44H5znKF+g44wSJ2e3AoDFyfegeffRKjzizkPzKlAlLtk9AP/sF72fFE5n6pZ8dCKSv3TzFJfdpRqxhC9S8wixicu0Es6JeQaBcnAhbDSxWtd3kr5GVgbITHzH32S2AqfJXsLgfWarHO+sIZP6Uqcm9vZ1AYu3C1t1TorIZJ99/qIUEx7i6k9BAN5KFQJg8mGglua3VxptzOYSavnF514oAM8LbdFIJ/Y6NH4x7YQ0zPPYInaHf8UTUxzLV5+XiMFVmOp6BjSdN
 0U4B0VbN
 i0a0gifexfFyn2G+jxVZaUIzwuA0gi8Dex3zKIANB/uGsrnXkCgHYXFlX+r/p/8PSZ2bmWtLkvi9rSixkUAmPt4B0NGAo2pGOvdiQlZdOhk/iwhLoc4KDCDfa0pEvOdl10Ezndqe5VI4Ec7846+pgF6CYaU74Wrp4tiAxnIPQUjLT+FhWmjeCRbLgHg2rmZwXQl55OuoW6HEj0vOz1vWIHvhAZSkrouivzOmScJM38k7agM/w0bcj5NsZ+k2npS/hDOLoTX25gwnPBiT9PIrNXRXM3Bd1/jfIL1OPV1OOYvLO+p3ga5aCarvQ1B6xliEX0EAKnSnmv6fzMaGB5PgPKVbJbjytjS2X+fVsPKSIiDU9d9rL+YNqcZxnrcbl6DphCT6jszFNmASwCdj9gyQ/qJP2pXU+tQF7RcL91lLkmXWuTtoYM6EE9uhGRgjpaiLx3o/w8ZFHLvLqjwD5a7iUEju0IK+Wqq7JEszdHsO8Zaq3Y0YgEohe5e2HsMgV3n8FCyID
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bhupesh,

kernel test robot noticed the following build errors:

[auto build test ERROR on 5303936d609e09665deda94eaedf26a0e5c3a087]

url:    https://github.com/intel-lab-lkp/linux/commits/Bhupesh/exec-Remove-obsolete-comments/20250821-182426
base:   5303936d609e09665deda94eaedf26a0e5c3a087
patch link:    https://lore.kernel.org/r/20250821102152.323367-4-bhupesh%40igalia.com
patch subject: [PATCH v8 3/5] treewide: Replace 'get_task_comm()' with 'strscpy_pad()'
config: x86_64-buildonly-randconfig-001-20250822 (https://download.01.org/0day-ci/archive/20250822/202508221127.LiaxcbdW-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250822/202508221127.LiaxcbdW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508221127.LiaxcbdW-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/gpu/drm/panthor/panthor_sched.c:3420:2: error: call to undeclared function 'get_task_comm'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    3420 |         get_task_comm(group->task_info.comm, task);
         |         ^
   drivers/gpu/drm/panthor/panthor_sched.c:3420:2: note: did you mean 'get_task_mm'?
   include/linux/sched/mm.h:151:26: note: 'get_task_mm' declared here
     151 | extern struct mm_struct *get_task_mm(struct task_struct *task);
         |                          ^
   1 error generated.


vim +/get_task_comm +3420 drivers/gpu/drm/panthor/panthor_sched.c

de85488138247d Boris Brezillon 2024-02-29  3414  
33b9cb6dcda252 Chia-I Wu       2025-07-17  3415  static void group_init_task_info(struct panthor_group *group)
33b9cb6dcda252 Chia-I Wu       2025-07-17  3416  {
33b9cb6dcda252 Chia-I Wu       2025-07-17  3417  	struct task_struct *task = current->group_leader;
33b9cb6dcda252 Chia-I Wu       2025-07-17  3418  
33b9cb6dcda252 Chia-I Wu       2025-07-17  3419  	group->task_info.pid = task->pid;
33b9cb6dcda252 Chia-I Wu       2025-07-17 @3420  	get_task_comm(group->task_info.comm, task);
33b9cb6dcda252 Chia-I Wu       2025-07-17  3421  }
33b9cb6dcda252 Chia-I Wu       2025-07-17  3422  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

