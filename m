Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430EFCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AADA76B008A; Wed, 13 May 2026 07:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5DEA6B008C; Wed, 13 May 2026 07:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925DE6B0092; Wed, 13 May 2026 07:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 815C86B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:49:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DD081A08D4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:49:28 +0000 (UTC)
X-FDA: 84762226416.06.700B31B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92AC2A000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:49:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gXVoc4RV;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778672966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=7m4jFTU2b9QmvGjjzqZFMP4+mOusIXNJiMEQvQN1kWo=;
	b=Zc5T52meHH4RlEHqspdoIoR/k2nzsXlI3mwvUP/Qt406RDAvivqM5CtSw20c959rm2igGb
	XfKsstbVvRZGW2WuuMEgsgPuY6ZC7ntu/byd8RjutdMmAMOlEiapRWBaMjPO5z+dvlh4Co
	tHseS8g1dJI+NKj3r/DWENbCHATINkY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gXVoc4RV;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778672966; a=rsa-sha256;
	cv=none;
	b=CKgGjQTt6Me6xkHVFIPOscPkOO/hP6Zjv5nfOvrEnZKPmD7OKvdirsu/ntWNRR8UestAF6
	1ogRaSrKGXcdGDhS6sw8TgROKwnECjVYduYVtTA8xyJ9rg3LJ6UZRsNzkW9Zk8Q7cAW/p5
	koIboT6eTeVEcEbtNj1CbhAk5KyEIwc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778672966; x=1810208966;
  h=date:from:to:cc:subject:message-id;
  bh=u7jv4jN6Lh/mir8HFqotaq2V3/BMrw/PzxsSJsaVNNc=;
  b=gXVoc4RV1K1xi7PCfZNC6icj+0UMuCmMKy2C5rQN1R32oSiNw7JYY/AI
   tZQScSDbcP1Ti43iI4gffG6fr3GwSnFWyYo9ojI3fuVUVDyeoq54uy0ZP
   pcw1Rzgp18KXSNUA1dzdyuvHGXEayO5CcnTn5PFizngjhueDJN837QA9J
   LxIVwDtWbPeGuN+oVKN205JyHn5ixzPO0FA5D1xldbMhTckN9e5SBz2Xo
   n6DhDKqB9YVnRJNCvywrdXVgTPtuIv92FwZ2zJTixdBwq5kHubIEq1DD5
   DrVHlOZqLLSeRdnzo0WsqH7Ux4zoRlL5rs9Jyz78tilSFSG1bbPR9afQL
   w==;
X-CSE-ConnectionGUID: 9V5DEbHyTamqW/g7B/Q+pg==
X-CSE-MsgGUID: Gv3HgmLjQJiD1CgGCKXTIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="90176991"
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="90176991"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 04:49:24 -0700
X-CSE-ConnectionGUID: NLQtFxtQStqkjVPz3lc95g==
X-CSE-MsgGUID: YO4mpxTHQaSHtjsav0r4xQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,232,1770624000"; 
   d="scan'208";a="238309793"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 13 May 2026 04:49:22 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wN85X-0000000041D-1TiE;
	Wed, 13 May 2026 11:49:19 +0000
Date: Wed, 13 May 2026 19:48:25 +0800
From: kernel test robot <lkp@intel.com>
To: Minchan Kim <minchan@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
Subject: [akpm-mm:mm-new 301/315] mm/oom_kill.c:922:12: warning:
 'kill_all_shared_mm' defined but not used
Message-ID: <202605131940.kEzvUaiR-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92AC2A000C
X-Stat-Signature: bai5h5b6wrwc46dor13eshebzo8cmihe
X-HE-Tag: 1778672965-317755
X-HE-Meta: U2FsdGVkX18/B+7M1BBNDnW6f3xU6Bvsv1bU4s6v2ueb1RqMRSS21AL8RVMbXoCt4UhlCb190i5TLb0xQbxVRGqKCwftssAbogUeSfmE8jrkPoWfJo4ONxUBmgc+zrhoU9A0WCRSbu+t08+o/ZuxobrnSeMVLrCnJYd3UXXKSlQW6SyueMpRzEQjY3DiFJ6gKcnQX9CSbYgB9uSqvzyV7x+ZiUuLUWppkX6pw4q6KGsT4tDzdnPBc5WQRMRbfV3Vl/BvSn1RyhOwp36BJSweBsv4bNPVRbPQhpFpDVjL5nPS4zC1tBeF5/80pBw1ioyTx4fz1QDpY/k1JwWmxvf6fCf1lCj8tBMQbjVhW0smOoYZXM5qZ+jI0rfWP/JVO4DZLNdNJ4QI2IlKllC2extz1KdHr111kt/6mE/8DnRHPVm9DY2lO8c4dDxaCTddgL44ewpkH39n9cXzSSThn9B2BTMxaQ/pbiLivAn21d9McXYWeyd43ISKUoDGGbtERmN3pRBpuae7TyxT/NtgYx3QhCt7e8RSxfKpW2vtHne1587bcpX/xnn0gQagU6++NrATUB1UkMCs8MaByy/CvRkuWSllWBXc1VryzPvHGDdKeo1h/PF/tn2safkS2VzOAguo/pmlKz45OueDck9nKi4y6+gHCdJ+6pDQ+mbdSlpnUPFGsTWNnkzr/8Zne9kYigI8SY3ZwRoh9gZruC/ZeDHU0gvBA7p329RjxNaMJRdO03Z1JPcLI/ehXRXlJr3L8+LQtJ9GfOMftCyGGarTvdK+wTwHu6h/XN92epfonCuRnf3nuM9+abcpr7LveQfaBH/rPgJkBJSaEu5voZH6O2XCO1U59RHLU0e2GzqdV714OBNxJdlhH2dn5dYlD9FqdsVcvtCfdy17jjFDefFMgJsp27X+o9KB6FD8PRF6WFV1vfq5EGWGjgqZsT04B/TglfHeEFMQz4XW8+pjm3tsdRc
 G7FHQPcj
 3PT+enXO8yBfEHYLW2KZDNh//B2sNIVzcHmlnAnXzFV3GQrrUQZfrloXDxW57K1Z0oyXTo39C4WxQmsgpXcQuzN/dd+XlKnRoh1+Xd8b4A+bF/StePapZxEoeELHMY6fdvKCiF63ShsOWclYb+bV8ewff7HeOXp+BAZ2VvMkzGyheOeuW3FhVk+l06Mcf+TsAaKTOUfdcqwicyxIj9bJ0E6VH4uKquVpZaTZV87H6xuFLjb9dgBLE436SmHAWvKRDHVxG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2c3f468717231305523ddcd94d91c0d5e4a72419
commit: def36547cd98fa3f7ecac1bf860479f500bc6b1e [301/315] mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260513/202605131940.kEzvUaiR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605131940.kEzvUaiR-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/oom_kill.c:922:12: warning: 'kill_all_shared_mm' defined but not used [-Wunused-function]
     922 | static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
         |            ^~~~~~~~~~~~~~~~~~


vim +/kill_all_shared_mm +922 mm/oom_kill.c

   912	
   913	/*
   914	 * kill_all_shared_mm - Deliver SIGKILL to all processes sharing the given address space.
   915	 * @victim: the targeted OOM process group leader
   916	 * @mm:     the virtual memory space being reaped
   917	 *
   918	 * Traverse all threads globally and signal any user processes sharing the identical
   919	 * mm footprints, ensuring no concurrent users pin the memory. Skips the system
   920	 * global init and kernel worker threads.
   921	 */
 > 922	static int kill_all_shared_mm(struct task_struct *victim, struct mm_struct *mm)
   923	{
   924		struct task_struct *p;
   925		bool failed = false;
   926	
   927		rcu_read_lock();
   928		for_each_process(p) {
   929			if (!process_shares_mm(p, mm))
   930				continue;
   931			if (is_global_init(p)) {
   932				failed = true;
   933				continue;
   934			}
   935			if (unlikely(p->flags & PF_KTHREAD))
   936				continue;
   937	
   938			if (do_pidfd_send_signal_pidns(task_pid(p), SIGKILL, PIDTYPE_TGID, NULL, 0))
   939				failed = true;
   940		}
   941		rcu_read_unlock();
   942	
   943		return failed ? -EBUSY : 0;
   944	}
   945	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

