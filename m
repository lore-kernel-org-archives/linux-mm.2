Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFBCCAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 13:03:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72898E0006; Sun, 14 Sep 2025 09:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C498D8E0001; Sun, 14 Sep 2025 09:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86AF8E0006; Sun, 14 Sep 2025 09:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4C468E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 09:03:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79F561602BB
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:03:37 +0000 (UTC)
X-FDA: 83887872474.22.F915971
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id C90C24000A
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 13:03:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AzZ45/N7";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757855015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0hhVShVYhYdWFGJ+R+g6scseHo0/gN3iHrrI50fTkQ=;
	b=SPgOEHalA01ycKLTj8/fMmeRm9dvkTYAaMjMEd0uGkqxFLcbgntwwTJ6kS7m39vgA23sc5
	yHsiWVC4oRqrjT5iZQjaePfNHIY5OGUaP9nim7VqVVXuktgJ+1XnuXRDyT2LhoGMD7SAIP
	4cJF2861hPbrQ0Ep7bSamnk+4am6vmk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AzZ45/N7";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757855015; a=rsa-sha256;
	cv=none;
	b=5NVZd/B50JDm7aDamJYePiyS3EbPKlf+5XTT220g+P/76RDyYPclHfKRFHYnJJI05v7O3S
	Xy+1s8amU+x51BC+Qt/TQgKoLEdvZiIJFpON0tiWKvm4fLcoap2Mp2kr50ft3ch2lkuaNx
	jz0z0AGo5KacVA6SkBGR5qay8gMRdkQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757855015; x=1789391015;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YvQSGv3+ITrtWtqX0tQjYwlbtPwK+65J7QAVpMnWBSs=;
  b=AzZ45/N7C73WKynfkHMwZLwlqMK1hBMQM8yqNbmb9axLqcpWXI+Hwu1d
   HHiMTCC5gNkrcOzDTG8IP+CgGZvbRA/9q2T/6BPS+1pUHwokXaZ3BOr0+
   KyYJufhx08L2QMB3QPerPUMBKhWMQJ4sF4+sH2S7SC1dWBgHrGjIxPwYB
   yb0oBXIg/vDa9qrbovb6Trw/nS7lUoTXhNFnloJoGu2JN5wMCVy5D1gZG
   FVEL1zZptXiNL6g2QoP8ETnpLhiK4s0YlWA2DB5jTabPT0I4+wNfmM/aS
   rE32dWibY7j0kPeOa4PIbT2v9NnBJkVmSB6V9wMKNPJnSE1acAVFWed2Z
   w==;
X-CSE-ConnectionGUID: akTaYlpDSVal4vGkBti4ag==
X-CSE-MsgGUID: ae6Bu9UkTqCXI6XWYjqAsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11553"; a="63950942"
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="63950942"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2025 06:03:33 -0700
X-CSE-ConnectionGUID: XsGtmFeASWi9vAkPUg6x/Q==
X-CSE-MsgGUID: /KpYDJz7Tqulsy/cge9/1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,264,1751266800"; 
   d="scan'208";a="173941581"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 14 Sep 2025 06:03:30 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uxmO7-0002PM-1p;
	Sun, 14 Sep 2025 13:03:27 +0000
Date: Sun, 14 Sep 2025 21:02:38 +0800
From: kernel test robot <lkp@intel.com>
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, david@redhat.com,
	chengming.zhou@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH v2 4/5] memcg: add per-memcg ksm_profit
Message-ID: <202509142046.QatEaTQV-lkp@intel.com>
References: <20250914180750448qMRz3iTon78DoExPyZusD@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914180750448qMRz3iTon78DoExPyZusD@zte.com.cn>
X-Stat-Signature: unzd6xue7tz51csssnepk4atxpz1td11
X-Rspam-User: 
X-Rspamd-Queue-Id: C90C24000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757855014-834027
X-HE-Meta: U2FsdGVkX1+fqDpiT411F7gPL0OHvq8MVRzN/Qqpx8RLZmQ/4PggsczdpX/pR4iFI4XhiWyNRdyj89Td0XNnoZrxwXBRb3ZP5CtOcVxh/Rz7v75mYkWSIPuWkn2kbgWFQL9fFr3wVlNnEEd9jkXoDMLKNeTuhW92TZEsJN9qpMV9pOpGwIq3WhAbuo1xWyyf504gDwxYQ5JYlHZxZhJfRpeIzZIhklRiy88Q9MffXyi1ZekCQSziOytcFtWXdJPn4nJSw9UCbq7Zv8t+NWf6fyz3a7EvZmBsx938Yw7ohpukK3X7ABv++syFqsh4wwMKpMPCqFI/ijnSEKKcF2AAzXvH9+qov06/Be3gYgpEMy7va7JHn0no1gHWdViAnClB/xlmfetCZpO3ncTlQw8AQr3RsWDqRGf/hXrTFWHUUAf1eTFiTT7Z81lLtqNbuNu4ncKT08vzFAQwr6KmIXzcRm3Iat1wDJEeFVcimFcKmZ9q8Cj8qke+OxflF8cI4deSLLmR9M/zLpLr/pAkg/ATjgP26COISlJFeDouz8ER3Q25wqzFeyWjFPGLenLjf6M1fidzm9PjxZhORKsMBn7kegyceCCpJwlOqZbJuEhBBV+otfPMjcIXsL4Sm0/DIXzVOkvfrbgi6SF8kBbzIeT6bgqclJqGMujQ41PuRcoGyR4Dq3jwTSQj5X9crEn+ST1iV2rVNjo2jtfc607tAOw+KTeCNHMmQeIoZzSRhoHJ+8mLz6JoCUZLsotFQBIwuL6J6aYj7lfaSxV8FAxASrgS0Cx+ozWcDkJfqe8qMvIV1pHyyUrXN47sbfw2zAIDdC9tgdlY0qY6yy+pyGaxtI+AnrfkUcFnee4un6fWahF9/oHeqprmV9lrum3pTtzFOYI+nWISKdJBcTIgnD78wpyUp7YNwGh3CCBKvbVEMiFCKJRqi7+pbOjU8ho5pH/X4pk7D1vIHAIZ0O2beDYZ7ve
 8d/rMlpR
 ldgVFLWf6jKE/znIwiI3Q8Mu8hfotynJ/gPQuSVnKjTDGoH72pTV0IsqPZlZ5eCQfPgvIxEU+7ooqipJv0gC6N0Cuco9MpiuEqe3PRq+x53gq1c14WfjR8KQ5NVBkEFGAFdvhj8mIFk0tQ49Gk4+TieTVa4GzZmTe6B8MKDEmp2MePjnPdQm0Qm6QFk237zqws7sc6DWBp2ZWI96VjytYI2gzeKQhmbKcl/ro3eeOBKwcMTwvBhCwlrgDf3KkppkcJksK2au3AGS1LrwgXDUBhN+pSt/Y04TDnHnkGD5zBdxagPCisjzkmA5lFf0TvoQUlhdjEp88WgMua3KwnUnblI1PcFnALpjVttHKLYUUgdcrJyidCGkWfZVCDmj2rl4we/E+yXtujrAtjXO7Qhv6xrOt+eKYT/0n7Ti3pt2Qfy4PMxh3LG2HxQiRi7QC5SbBG7dp8dqZkGmq7Zk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on tj-cgroup/for-next linus/master v6.17-rc5 next-20250912]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/xu-xin16-zte-com-cn/memcg-add-per-memcg-ksm_rmap_items-stat/20250914-181132
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250914180750448qMRz3iTon78DoExPyZusD%40zte.com.cn
patch subject: [PATCH v2 4/5] memcg: add per-memcg ksm_profit
config: um-randconfig-001-20250914 (https://download.01.org/0day-ci/archive/20250914/202509142046.QatEaTQV-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 21857ae337e0892a5522b6e7337899caa61de2a6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250914/202509142046.QatEaTQV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509142046.QatEaTQV-lkp@intel.com/

All errors (new ones prefixed by >>):

   /usr/bin/ld: warning: .tmp_vmlinux1 has a LOAD segment with RWX permissions
   /usr/bin/ld: mm/ksm.o: in function `evaluate_memcg_ksm_stat':
>> mm/ksm.c:3335:(.ltext+0x163d): undefined reference to `ksm_process_profit'
   clang: error: linker command failed with exit code 1 (use -v to see invocation)


vim +3335 mm/ksm.c

  3324	
  3325	static int evaluate_memcg_ksm_stat(struct task_struct *task, void *arg)
  3326	{
  3327		struct mm_struct *mm;
  3328		struct memcg_ksm_stat *ksm_stat = arg;
  3329	
  3330		mm = get_task_mm(task);
  3331		if (mm) {
  3332			ksm_stat->ksm_rmap_items += mm->ksm_rmap_items;
  3333			ksm_stat->ksm_zero_pages += mm_ksm_zero_pages(mm);
  3334			ksm_stat->ksm_merging_pages += mm->ksm_merging_pages;
> 3335			ksm_stat->ksm_profit += ksm_process_profit(mm);
  3336			mmput(mm);
  3337		}
  3338	
  3339		return 0;
  3340	}
  3341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

