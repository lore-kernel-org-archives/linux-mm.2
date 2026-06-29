Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 963FAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476846B0005; Mon, 29 Jun 2026 05:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427F96B0088; Mon, 29 Jun 2026 05:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DC36B008A; Mon, 29 Jun 2026 05:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF4A6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:01:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9204B167FA0
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:01:25 +0000 (UTC)
X-FDA: 84932356530.28.8EA67D0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4ECA040007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:01:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MoQu1htK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782723683;
	b=dIc2FwvpY6kZLhByLRyB6K2a6nB44CKTgfr8eBmK0pKStchZ3iz6cOcPmNS76pKu+JNPl6
	SZBdujt+lNY+vzbTSJxui2duscztdqmqoLVMaR0l0bH3oGHJ4zIhotSf0Kc+arV6cHCPKV
	DbC22nHwCkFZGClQjMFDGpT0lgQYkhU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782723683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=CN760gR5nIE9UxvpfSkta70KuOQlzZacgkDGfcP2CY0=;
	b=htwbKaAqETzuzw5oMiKDYrfulMhPagfY5tcGb7nirTjRpmDjoNo8/TzCkYzNYxbYcOh1/n
	cmxeAf0ZyNHw8Zk1Q/yPAgFq/pg94t6lZsvDQVeFjpBiY542dxYIYk5guCw+lAOX05dxhV
	SfQ+Qjk8Gj5gfmScQ32n3TUX9L00RvM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MoQu1htK;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782723683; x=1814259683;
  h=date:from:to:cc:subject:message-id;
  bh=KbmCoknG2orb/kPH/fe4sjn//vOjVoCFNLotR7tHsdw=;
  b=MoQu1htKDAzYBikKOOna49+jH5hF5x6NI3B7tOG1YtvgMkDnYhQU//ps
   utS6P6b29VHeLVfncMDZJidd/htUdZkmjxREvGbwAK3zmBK1N2nkgvD4k
   fQvl8FH4Zs+VY6mJ15CtopZfQT1mKu7p8dIZ55a5OJW6RdooteJ70lwuH
   M8dsN49nIzeaaJQylnVUeDzO4O1JerMkV79cXK6pCqDGGkEWHztZ1rVjA
   Yf/JjS5nEr6DbkUNyxLrG8mNcv3R7bCi4OyT9w1Rui8MUbDh0+DNUi7lB
   wIGN3NmDkmW0pOugUU/d3mouRs/tMXby4RyJOhrMjwYIVWoOg1JpO2sIM
   g==;
X-CSE-ConnectionGUID: M1uTbHoGSjuSXu1asUN+mg==
X-CSE-MsgGUID: dhmST/o7S8WJdwhk3EhIAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11831"; a="100947233"
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="100947233"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 02:01:21 -0700
X-CSE-ConnectionGUID: Y4U4qRQeT7eCJD9RDEdEZA==
X-CSE-MsgGUID: h1txXwLdTdaMp4WtOw0Ylw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,231,1774335600"; 
   d="scan'208";a="247448708"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 29 Jun 2026 02:01:17 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1we7q9-000000007CD-0bBm;
	Mon, 29 Jun 2026 09:00:00 +0000
Date: Mon, 29 Jun 2026 16:58:34 +0800
From: kernel test robot <lkp@intel.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
 Wen Jiang <jiangwen6@xiaomi.com>
Subject: [akpm-mm:mm-new 59/142] mm/vmalloc.c:3590:23: warning:
 unused variable 'start'
Message-ID: <202606291606.9h8aGniQ-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4ECA040007
X-Rspam-User: 
X-Stat-Signature: cpzy1ndzzc9ajd7yesjt1j6d6gh6kuk3
X-HE-Tag: 1782723682-185643
X-HE-Meta: U2FsdGVkX1+mEHl3YdGXhWySxXDFJd8qlP4m1tEq30MxpPvL9GNtsN9uW1xdkJpzDEtyNFdq+13LfaTVu/I7KHtt/bSt6duFQjzZTbjnT2fRD0wfIO65zlRCkLDZM6BUe/Ns3Ll02grpZy5tdBEOMyNVMSlvWL8xa92Ef3DllObVngp+VYLYdoAETajSWfXV2zdUzlvFjO3oh5r5K76m/Ge3KO03NynGkq97UIl0shor78B3P9YRhUQC3smszcf4Cn0JZlx1A15OV5J2mhB5Dxp4kM5xcX+dN7W2oP7H89LT9s98XBWZsZfm7T6mCTelCkclpsBuL/TxmtVNshxAWaIPbX9pFSzfhcPwiMgqZgeDipFGCgjyGMe/aZUWp9Lfkzz1vnEOLKdAIP40HAVVhCLLuGPxws9RGNcOZ47WrJkFFQGjW+XnoNImIQJIqhrJF8o+DnCB4enYHpRz2LQLNA25y4NPtVxAAu2f2OE9Kw9QqslLAJ+JeTdU/A8G8JPCMPFsSZ/z1BwU1GAuay+GiGLsfBjW9aJ/oJvr5Q6146S6Wbex64pR6IqRjpYnt/c4NtlM+0f8q/Lj+yOgKYOp3N0CcvS77AlnhC3kDrXkemSEyCZb7fDV6SNGhqZgBdIiNtg8ugYKVoUl6irubER9wnJ5IiSxBamoYifSgbbtUXJAKGQBpbRyH9ttYscRAvb6wJtnxR2mnxZ39aX+FAHYwp9TSpyzkpVip4HSJmRwDK7BwnmnhzzHr6K+Ce/U2q7T2mIxho+yK09HndVFXD+Gc1XU7ulN9TXgBsEjujIubkK5klf9mJcpsTcHAvsRYmNjoZJ6bQsNG/MS/advT1WAu584kj18OTc4yKoTK/02l/lRK8tdqV6eBqvuhJVyJvHxlOb3GdjSIHHoUvnOnMzpAx8RoGuXwttrE+F0BooLiG45ZSdrYTcWYucIauSAAsHITkHMhLMU7oI8EyFlWeQ
 4gyM+aQE
 Bq3Kb8YjISK2Y0guJfJUEKyvjSflI+4mRClyi3EuRXQKK+pWmqy/TbBuA2Ih/YwWq+DTKb2M5A5pUWll3pmNTt12GViRXQtGFLMkAA5051ecwlSMyUHivJ0m/gTDuaRinWGFkiy3WPkTSuibuiRUkKdC0XsJJHe2xi7DAbS7N0UpPnjq77lZzk5WXZwXwqbURRpL3gMThZQQyTEG2zwCKYoMc0MOdFtwCtusR38qiOo3P9uX1u55ukShQTO/48ahOjgbYWLvt/vAOdnua74umcSdiwJXZnasWBNvz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   88cefc306c43b58d9bb65c9e96e284306710d961
commit: 80c453511b6ee1af0e4db83c3db0020215c4eaf0 [59/142] mm/vmalloc: map contiguous pages in batches for vmap() if possible
config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260629/202606291606.9h8aGniQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606291606.9h8aGniQ-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/vmalloc.c: In function 'vmap_batched':
>> mm/vmalloc.c:3590:23: warning: unused variable 'start' [-Wunused-variable]
    3590 |         unsigned long start = addr, map_addr = addr;
         |                       ^~~~~


vim +/start +3590 mm/vmalloc.c

  3584	
  3585	static int vmap_batched(unsigned long addr, unsigned long end,
  3586			pgprot_t prot, struct page **pages)
  3587	{
  3588		unsigned int count = (end - addr) >> PAGE_SHIFT;
  3589		unsigned int prev_shift = 0, idx = 0;
> 3590		unsigned long start = addr, map_addr = addr;
  3591		int err;
  3592	
  3593		err = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
  3594							PAGE_SHIFT, GFP_KERNEL);
  3595		if (err)
  3596			goto out;
  3597	
  3598		for (unsigned int i = 0; i < count; ) {
  3599			unsigned int shift = PAGE_SHIFT +
  3600				get_vmap_batch_order(pages, prot, count - i, i);
  3601	
  3602			if (!i)
  3603				prev_shift = shift;
  3604	
  3605			if (shift != prev_shift) {
  3606				err = vmap_pages_range_noflush_walk(map_addr, addr,
  3607						prot, pages + idx, prev_shift);
  3608				if (err)
  3609					goto out;
  3610				prev_shift = shift;
  3611				map_addr = addr;
  3612				idx = i;
  3613			}
  3614	
  3615			/*
  3616			 * Once small pages are encountered, the remaining pages
  3617			 * are likely small as well.
  3618			 */
  3619			if (shift == PAGE_SHIFT)
  3620				break;
  3621	
  3622			addr += 1UL << shift;
  3623			i += 1U << (shift - PAGE_SHIFT);
  3624		}
  3625	
  3626		/* Remaining */
  3627		if (map_addr < end)
  3628			err = vmap_pages_range_noflush_walk(map_addr, end,
  3629					prot, pages + idx, prev_shift);
  3630	
  3631	out:
  3632		flush_cache_vmap(start, end);
  3633		return err;
  3634	}
  3635	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

