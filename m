Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2304CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 13:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1EFD8E000A; Wed, 24 Sep 2025 09:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6D78E0001; Wed, 24 Sep 2025 09:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33788E000A; Wed, 24 Sep 2025 09:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C3C398E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:50:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A83BC0539
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:50:08 +0000 (UTC)
X-FDA: 83924277696.17.9B62F7B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf29.hostedemail.com (Postfix) with ESMTP id 333BC120007
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:50:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ig/CQdvv";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758721806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/A2Ch/GtAi8GIZoLCN9t6+BlhVa+r6QoKh4VzB4iqU=;
	b=EvmvSV7sijH+N1BtUfnuA1m974yBNwstyGuHad1v2ITi5iokr0R7kHICz7BNGWcILXoG03
	V9UhIkEK8C7xIPnjDr6BsJYCc5hs38ZBpq66AkCbghK/Qb9ADhCO19pniQ/2uDMTe9D6SJ
	Xb7jsGcpnmBCZlWS68IBH/zicpZcv1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758721806; a=rsa-sha256;
	cv=none;
	b=WwA4baIUU/SPg6Vone9XXMPUraux+WcaThQt9tSQJif90bpddFv+bNoU9Tsw/zdPHufKdL
	PbbdceYX4ApFrewesX81Ok9vlsbBNa3Cth3wgK585JAsa7uos7cuVAXxFbg/GVEl/dLu7n
	R6hmces39QSdqM5CZvMkWwEbx9h3FCA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Ig/CQdvv";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758721806; x=1790257806;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FVTlGQRfhtupRSo1RZWEmSo3V6SWhG+b4V2VQt6fC2M=;
  b=Ig/CQdvvfHUVghP2Fwcf4Y8DUIokuAO0RGyagB4IsJAN9NOgzpGSZaps
   3n9OkEpHNlJTf/gUSw9TZLR161Kx3V95l1Dp5yuCRg4NEsvGPcWpO1RMX
   we2U7JSqnKUiyPDrrw9CKBAFgNUvGe5ezskTW93Fo4iHUmqmNURGmiGF0
   FbSzUeqYRkQe3SELJcrckB44hq9iHi38CEdtfnU2yEgYB614pD9EIusZk
   Eisbh3ELbZllvis8yGA8Kx/qe09d3+9NBDD3M5rn3uwuUuuHhxt9cEE0W
   vgCtGLrcb0M/LMkKkGbALKzTcCOq6kjwipWsnku2MLhLUViKYdGldJAsp
   A==;
X-CSE-ConnectionGUID: uFntkMe1Raerh5+ulC55jw==
X-CSE-MsgGUID: loJ8IceQRUOOFgeVgKiHTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60931971"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60931971"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 06:50:04 -0700
X-CSE-ConnectionGUID: +LyeUF/IR8CAyRI+4elb0g==
X-CSE-MsgGUID: 7NA19qq7SRSo+9WS0jpauw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,290,1751266800"; 
   d="scan'208";a="181051824"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 24 Sep 2025 06:49:59 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v1Psa-0004C9-1F;
	Wed, 24 Sep 2025 13:49:56 +0000
Date: Wed, 24 Sep 2025 21:49:18 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
	hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg
 offline
Message-ID: <202509242123.QwwFy7gc-lkp@intel.com>
References: <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 333BC120007
X-Stat-Signature: 4zpjcfpwjcq19xwxezqgptkrpajrzkny
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758721806-69529
X-HE-Meta: U2FsdGVkX19xSU9Fbf9cD2ICiRK3wivwmiVauJstY0ogOzVMwyRLeG8NLXZo3A19CNRRB20jDGQrDZEeScvg/DV3SPzrkBC5UC1G2NmgywR8KEjEYK+jMgiC94iwZKBxKrDLvmI9s9Zi6BC7/89DJxCdZHKg50LBCMGKFCTal8bj05iM0Gm4S/RvkCdP4VjU4nf0ItsxOosHwScpe1Ut1/UZk2jwpgLNVCp831DDDuoJW+29MLJje0ryXoAjdUsh8H5foy/ODh0NCBZoXDK6R5hXvsBMHHl5MuUc9q5Gq5JEThA2SswgKNTHypgqm+W8SjKiP/r8dwANw7MRgAGnXUbVa+o22XTqJFgaXZkQuJYkjO5tf+aO9uhhJs8Bx5Gn0GRld2fWIPIbjIoIsh5fHnm+qsrsJMCleCGS5ysyrRAEAQpfEKqBM7YjX1OhkPXOE3RxRXSE9GeXoKfltwI5bbNS5RKlhW81GOEYJwl7aSLprKF9K1FuG2WH6kvTPG1ANDmzGCR6C5coMoo7PpJvSdNDdM2wH7p/oYMyl6HHvYUAlPywQ8EQheWeZ98y594rsSgdQi2YpmI7xJjGT0/dmgYKpbyYK3QeoORRT+EZshZsfmniBDyrGDWCvC59S2Htt/Uhb3BkNNn968ct5eVIBFsp8SeNph/WzcXJgEhBUz23kXGdnSFvgrxEtMEQVK9junXMMaSVaDnJqovxZ068gosAh9axUJOidcg5ZYI64omv4ZDDBAdQDMn6m2PXieJYWl6w4laGPYeQzW6fhIHwflqXG15vJrJatdww1/GdAzgn1ie7Yj8otaUZ2AuJBE6FVJppViQ/jArxkvzb3FJRUSnurzzVMayRaV59bAKDAHpBTJ3bGJjYzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250922]
[also build test ERROR on v6.17-rc7]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes linus/master v6.17-rc7 v6.17-rc6 v6.17-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-thp-replace-folio_memcg-with-folio_memcg_charged/20250923-171935
base:   next-20250922
patch link:    https://lore.kernel.org/r/55370bda7b2df617033ac12116c1712144bb7591.1758618527.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH v2 4/4] mm: thp: reparent the split queue during memcg offline
config: riscv-randconfig-001-20250924 (https://download.01.org/0day-ci/archive/20250924/202509242123.QwwFy7gc-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250924/202509242123.QwwFy7gc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509242123.QwwFy7gc-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/huge_memory.c: In function 'reparent_deferred_split_queue':
>> mm/huge_memory.c:4302:42: error: dereferencing pointer to incomplete type 'struct mem_cgroup'
     struct deferred_split *ds_queue = &memcg->deferred_split_queue;
                                             ^~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for ARCH_HAS_ELF_CORE_EFLAGS
   Depends on [n]: BINFMT_ELF [=n] && ELF_CORE [=n]
   Selected by [y]:
   - RISCV [=y]


vim +4302 mm/huge_memory.c

  4298	
  4299	void reparent_deferred_split_queue(struct mem_cgroup *memcg)
  4300	{
  4301		struct mem_cgroup *parent = parent_mem_cgroup(memcg);
> 4302		struct deferred_split *ds_queue = &memcg->deferred_split_queue;
  4303		struct deferred_split *parent_ds_queue = &parent->deferred_split_queue;
  4304		int nid;
  4305	
  4306		spin_lock_irq(&ds_queue->split_queue_lock);
  4307		spin_lock_nested(&parent_ds_queue->split_queue_lock, SINGLE_DEPTH_NESTING);
  4308	
  4309		if (!ds_queue->split_queue_len)
  4310			goto unlock;
  4311	
  4312		list_splice_tail_init(&ds_queue->split_queue, &parent_ds_queue->split_queue);
  4313		parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
  4314		ds_queue->split_queue_len = 0;
  4315		/* Mark the ds_queue dead */
  4316		ds_queue->is_dying = true;
  4317	
  4318		for_each_node(nid)
  4319			set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
  4320	
  4321	unlock:
  4322		spin_unlock(&parent_ds_queue->split_queue_lock);
  4323		spin_unlock_irq(&ds_queue->split_queue_lock);
  4324	}
  4325	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

