Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D156CCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31EF08E0003; Sat, 20 Sep 2025 04:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2816A8E0002; Sat, 20 Sep 2025 04:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149A78E0003; Sat, 20 Sep 2025 04:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F191C8E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:27:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A129C07AD
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:27:41 +0000 (UTC)
X-FDA: 83908949922.07.594203B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFFEC40006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:27:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cjauWAFF;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758356859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXfNXXk9A113iJPug0O5pITpBB+4A8mAdSqBrRY7WIs=;
	b=SrLfVlOGEYU6VhNhPQeQGon8Rxe7bHi+ad4HYz75PkP9PM090QBioGYymdCRDjONda56wa
	LdqEwj6Qp68iarJCfU6Da5E42//URwkVZVjTzhLo8Z8p2qwPiaQPxqo6hMQ78R4Yi85dCM
	waLpnngFxWZUIQNVIqqSXSKu5MI2Zts=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cjauWAFF;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758356859; a=rsa-sha256;
	cv=none;
	b=iBZ3mrGOeaWgRmfM8acF1j+ZQ6oHVjiNUpEmS2arnxMGQ9/VY+VHoQlhtuHb9hUhGAlpPg
	OYXkwFoXMZ27uk8se8XI7JmvwgIg2IYwu4GhY5ZzGeE3EW+9si2piLRAvl6tTD7ah7PYUG
	wc8HRKUp6br3hQriFMlUBeUddfc904k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758356859; x=1789892859;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fLmBxl6wqNnu65VPgOguy4Rp6FEVvwYxsWhMiq/CrPM=;
  b=cjauWAFFzaQIpwTQ7MNExML3ri8u3zTKMoWzFGeO3NknHG7eC1N2BGqF
   AkLz4hjHpyy880u4xXGD1z8qrysaOGfW5LyfFvh85SxERwbjl3VwWnsjj
   aE0TKG+ya6n7C7c7EIXwNRASj+Yeac7WKHbpWFgKwITvmZCl8odbl8kkT
   TQvsM2RhPgXZ2YoFKi2v/BpML5t5+qMkrmWJmg7dUg/J0jblnGdGbrs4E
   fzswf5Wl8Oo7xbYlcgbpPhVH5d+rcvGgdALM+SgHW9fhiTBNGDMGMGIAW
   LhD+SZlyigJNx4ocQXm+VRhWNAlEXi5haAek/Pclx5OQLEG4I3EBJzKVS
   w==;
X-CSE-ConnectionGUID: XDuRUhxUR6iYY8Ajw88EqQ==
X-CSE-MsgGUID: V+gX5w4GQC+TEU+kzeD0pQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="86131660"
X-IronPort-AV: E=Sophos;i="6.18,280,1751266800"; 
   d="scan'208";a="86131660"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2025 01:27:37 -0700
X-CSE-ConnectionGUID: jgr/78pSTnW+eQNFl3ttBQ==
X-CSE-MsgGUID: nAsLMnuUTEG0Inx+PrPHOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,280,1751266800"; 
   d="scan'208";a="181284823"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 20 Sep 2025 01:27:32 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzswM-0005Al-0T;
	Sat, 20 Sep 2025 08:27:30 +0000
Date: Sat, 20 Sep 2025 16:27:10 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its
 variants
Message-ID: <202509201640.ikJun7XS-lkp@intel.com>
References: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: DFFEC40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dz7kprh58sfrzrsofjwde1npgwhitwei
X-HE-Tag: 1758356858-255784
X-HE-Meta: U2FsdGVkX18XUsgkVeAqHGGi9rjzbXwphU6NDBBwpEHERwf7AiqPcsvU7RZZK/3aMC/OTEb0B3Q9WgOaUpub5cTqBH1ni21mVOk7nWsgwUUXJLN/nxL7Q1r+Hi7hD4UMwwIeTik9RfM7ZULU38EcuNALGb/1lBkMP8/d9PxWIHut0gjmU4ZsSvFii9jLzyFKK3wrnSb9Co7Z/65HLzNX8SgaKWF/UCwpm7YKDPAvG2EtTk6GqwzAI5RTmjbkLoZajIHRNMxi1NQ52yS6TUiI153p04cFFBb/n5TSAzP+ZmPkFLbT6s1s2jzFbjYtLeXpKXHdKpdd8jMuV+FYGcH3SjeAUipWXjLyYWUimV3BBabAN2s7RbSuGosE+CqvludfZ8dKPK5bN1jtYWfYFE1RXQ2ILaC2LuvqjwQaEqFuVrHCgYJE9kLb4SEWXAuA2cf49b2WI+nxxgza2vykZKpNJp9mKhRBYD/DVSOD+T+inE37oVugE11HSO0IWTpP4VamVGYjIA5ehL+O0Qm6Jsz3+CpfyJag1aOkzRhlBXV9FYpTGoJNeGoWQM7dVtLxKaEKezYNbrZR1M/RlJXTl37GDkeSrxygC9qy++915g+Yy1WeVoCgSj6AtP3yfxi4jSES+bWwHTL+7sjb7n1liLfVXeMZ7UtU0P9wY7YjATlal2Zzr6R8eXszChePpCr4AkHdz6Gmd5OX/65N+gUuEOg43JEf9AQOdbpw1fxOSJgi6P8zA5By9Ccyk0/OeSGzgPGlKDFKo/HtHg/2WsV0yd4Lj3j2faZpcY3MorB9Xa/mJkFPiTn9ASYoHSdgH7xV3bqfKZ1n/0NETU1Vluh9QGoqqReQOmxxZ49fJo//K9XATsPO/CnJCh2PqK7dSM4cmFm2GyScwWictUsOKYCOtdbfITSU0MoxL/3Bx74qf7cLtTXFZNtHHD0SgcFIZuf9+KPAw670cmFHBllSjs6Tehy
 4b8ei2Ky
 LNrSTn5zenPRi7f4egX+D/8p+rQHRMeCO8gwLlXtEz9f2Zpq36aF/CUQ+8E2uEWASysnEZDWD2AJSLFrpNQFBWp1T/E+UeKDF1JMiFOZgoudPf8H1BpjO6P7mutnpqXOJR7QV7zJ9XPSxc00k4XNW6C1KMBPgkBlvSXJiTab47xAjbiBoZ4b5E+8XrZeSFTsIIH1PM443RWNGnCtQReg4Pze8g1QY6wfUudJimQi88PVbEhaNgjfnCvQC83sZK4FG1fIuC4RkEWQT/jE/BIVKkikHUE2/30eltgvnpOuvhN6Qk250HImgp/Dlx/8e3i6NS/8rFu9GtRYeCVNS1lPmI8wzBlwXRzi+nu/VztiORx461EHMpA/WK7H1HdhUY1sL6eGOr41lpPctjoennpUpNF2jW9l/j+oNKStGsH6RGP7OHP4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250918]
[also build test ERROR on v6.17-rc6]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes linus/master v6.17-rc6 v6.17-rc5 v6.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-thp-replace-folio_memcg-with-folio_memcg_charged/20250919-115219
base:   next-20250918
patch link:    https://lore.kernel.org/r/eb072e71cc39a0ea915347f39f2af29d2e82897f.1758253018.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH 2/4] mm: thp: introduce folio_split_queue_lock and its variants
config: x86_64-buildonly-randconfig-001-20250920 (https://download.01.org/0day-ci/archive/20250920/202509201640.ikJun7XS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250920/202509201640.ikJun7XS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509201640.ikJun7XS-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/huge_memory.c:1105:24: error: incomplete definition of type 'struct mem_cgroup'
    1105 |         queue = memcg ? &memcg->deferred_split_queue :
         |                          ~~~~~^
   include/linux/mm_types.h:35:8: note: forward declaration of 'struct mem_cgroup'
      35 | struct mem_cgroup;
         |        ^
   mm/huge_memory.c:1119:24: error: incomplete definition of type 'struct mem_cgroup'
    1119 |         queue = memcg ? &memcg->deferred_split_queue :
         |                          ~~~~~^
   include/linux/mm_types.h:35:8: note: forward declaration of 'struct mem_cgroup'
      35 | struct mem_cgroup;
         |        ^
   2 errors generated.


vim +1105 mm/huge_memory.c

  1098	
  1099	static struct deferred_split *folio_split_queue_lock(struct folio *folio)
  1100	{
  1101		struct mem_cgroup *memcg;
  1102		struct deferred_split *queue;
  1103	
  1104		memcg = folio_memcg(folio);
> 1105		queue = memcg ? &memcg->deferred_split_queue :
  1106				&NODE_DATA(folio_nid(folio))->deferred_split_queue;
  1107		spin_lock(&queue->split_queue_lock);
  1108	
  1109		return queue;
  1110	}
  1111	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

