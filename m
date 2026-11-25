Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4F0606A684
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VwsvQWjN
Received: by kanga.kvack.org (Postfix)
	id 874FC6B0960; Wed, 25 Nov 2026 04:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE8F6B0961; Wed, 25 Nov 2026 04:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAD16B0962; Wed, 25 Nov 2026 04:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47ABC6B0960
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:35:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2822C80E25
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:35:36 +0000 (UTC)
X-FDA: 85473133872.04.C3D555C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7F6B61A0011
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:35:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VwsvQWjN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599334;
	b=KD0L+M/vq7qTjKFhttllg+NUv4lKGAmmDThaqxsyRdD9VWp/A6j9UhVJxJIHMdnF1ksu6q
	0Onjsj8haFzjReN1to44bjna5T2xpOPECDNl0uRfk8TTBbVS40gk5U/FGfgC2UJOxzCQ+X
	BIsQUuiT/kJrKXK1sYDcTl64323HZ2k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=lWlGP+Ou3VbMvXRiWf2VUrbZoItxcuCKRD9aSDkrNIo=;
	b=ere36sm7s2SCniBfocU390lzuW3B9KVXHhHeMCdPuZ/siF4CHAMEHA7x/f8pZ5Km1e4JQM
	6PV2m5jqltF7EafwtyLm8bbbIZE4nJyULZS552ujqk9SW1TSZzclH83dForyfF9lNinied
	SBffRyExFZg7u15r3KWRk2hZcnQZ2Wk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VwsvQWjN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795599334; x=1827135334;
  h=date:from:to:cc:subject:message-id;
  bh=00uX1NQG46bUWx6NkRFg/fsjUJ6HFdTMVvTYmoFvSuA=;
  b=VwsvQWjNY7WNNMfQ8IkdXMe1py1AfAdUBUOI53t6c87Lx0QVrgABB1AV
   SEDvMy36GwgF3vA/xiqjFN/zp9dW/HgQjjjTxlhcjWD2UuGPss495cCEI
   civ2Lbn0JkQVuc5yuvK3zC8bP9U+7cVrj6K2WrotJqFxUd2D/kHKbi/ZQ
   7L+5l0MF9urtJ9gdEMLSPzOioDTFmRaehRy0/Jwijmj/roYyDALFTceZY
   ujKP9RWGUgOX5R9mcTlrUNtDrKiCz54mmtqjdi9tAxd+kxVw7Xw5mv/vr
   r+RGpzWYNsdMr1KnVy9hv6/y3jzNxHvN9ZOk2XFXX/GDm0LjXrHLXzEOL
   A==;
X-CSE-ConnectionGUID: j5dZNJ3ZRwWD1Tqofi+xug==
X-CSE-MsgGUID: clAK4BRsQxqBr8YZWUEhCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11976"; a="4531278"
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="4531278"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2026 01:35:33 -0800
X-CSE-ConnectionGUID: kVIqQh8DQMOkWK7WBYaiTA==
X-CSE-MsgGUID: 33zrC3G/RhaZAVdAtpNkpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,232,1787036400"; 
   d="scan'208";a="11686482"
Received: from igk-lkp-server01.igk.intel.com (HELO 99c479ab0aeb) ([10.211.93.152])
  by orviesa004.jf.intel.com with ESMTP; 25 Nov 2026 01:35:30 -0800
Received: from kbuild by 99c479ab0aeb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xW9PS-0000000006N-1lpK;
	Wed, 25 Nov 2026 09:35:26 +0000
Date: Wed, 25 Nov 2026 10:34:55 +0100
From: kernel test robot <lkp@intel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [akpm-mm:mm-unstable 33/408] mm/mmap_lock.c:572:14-33:
 WARNING: atomic_dec_and_test variation before object free at line 574.
Message-ID: <20261125102827.xQ94ZCi1-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 7F6B61A0011
X-Stat-Signature: xy1hpm8izsy1zskcq7wwnz6e17yga5a6
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795599333-91610
X-HE-Meta: U2FsdGVkX19tdc/0F3lILUl4O2mrxw8dLXUOp/vzwcP8r7fjqujFwEgHEO0fovzNlrazSiA3k6gNSA3q5JmIvHFFrkkMyJuUl4XOV0LE0LnUlFIGVe7n7kvQuJVmxjKaf6iSuP8OYRQTej3ibawCp76SkgW8g0EBdDWaE/NN/PiGusVKFpB2M5KWFv7NbNP8PaozJchuobyDNhBPnCDg5ipGkA2HHrSvICngGhxL5n/DhHpoDMjN32gzA4EZmfv+RxjLMAfc0ehVDxKNHPRwOH+BhLLSICMs8GCzn7w/G7hczBQY3yDsWXpOGNcMANpOrciWkXQjo75N2Qn2WAa352SJd/eV16eXSWtF9HjZtwRJ+iEtaQa7pW1AsMuhgoN4LKXhSDkZcVD/+b2+TN9x6grih8HuBvoK6U3r2BKfYlkbC+35hIqBX+ir5Qmwh/PoO59YlaNjGgJ2UeaG0lL2YW0yfQeosgWKNH7A0s7uEGYbhhbklgCK7PTjr/L2VSBBQP6q7E8j8vrVElH0j/riHQ0+6VyYU+EF5cqRSd64kTRIOkbXpxM6GFDNuBqPxBCbsNnoleQqx47iBHTbmj2L5oFiqDSDZGXe2Go75o/DI16RTXl2sFTm/jnO7SmhdxQNK6LDiFGOPl7o9D+8vIN1h+c6MLOPirxuX5xEagQgJZE7Fid83zv4Of4mrpZ3ck/W3Mrf0P5oLPylSdEYAQ1h+txkBoaLzNGBrC6ur7jw7zyp3sLsWhGCoZqwgaDh61U4Yphx/BwYS+TsoHSi6X/1OswMb/cUppA/34hO4t67UNm8wKzNkUlsStrBS/6WJE78LeS7wVd13ibCmd6VWR8kb8Dl9Cid0kfCe/kkEuibRGJriv3lwVU+S9KZ9heaGsTHC43odGNzzKJiJubhSb6BevfUN6wqZ+plHVbIiKnRsI0NIBnvnuq5KZNdlOolV8bUsvPWLzfZpSKr7rLktVF
 aR890q9g
 SQqIa0MXtQpi8i0LKWDgNuUDLpiRR4nmeGwjdeQNqB5dIRD56M0yYxarJbrN9gBh+TJMDddd9/STI7QXG7kSYbJZ3AZd2dzfSSNu+E5ojMOnZ3xnJ+IwMIb25rO8lX1nenRfxo83WkS918I741CdFTJz+dE4u+0DGPtERx6gV3NJzGewyLjb1YtZrYMKKuRjWliKij64b27iLZecAy9jyhqb/rqCZIi7SyDA2yqzrOkJILub5HMS9wQ6ob54u3LpfM20HxkIySoKvEYyloAPsHBsl1O9ldAIAkkRFfQwhTfL147S/+jW/Fa2X8wCipAeJoBP9hZN9uQ7FLeI+ukYnfzMuyATiMYKml3kgUGhW0ZKxQLYktPUbAA3WojN87pma9/nTxrLG/L4unqbwXGdiiYl69OlFETKogFYsdEn9o2lU3UBldn7gPBpmTydCTGbRT1d5QWzSad6iKrd4+Ym6IU1DGE+UCCH4hRPzOWHw9b5EYGscdNSOxnLny1FcPCM/RboljuMoteo71jOaar3uruCZtvRPrgg2FFAGRHCiL8+BOQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   c8117bff684306f5c1f959d055cc2b24dd67b1eb
commit: 549e0b6c9835de4cc4e8e4a56459ef09febfc2f7 [33/408] mm/vma: drop mm asynchronously in vma_start_read()
config: sh-randconfig-r2100-20261125 (https://download.01.org/0day-ci/archive/20261125/20261125102827.xQ94ZCi1-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261125102827.xQ94ZCi1-lkp@intel.com/

cocci warnings: (new ones prefixed by >>)
>> mm/mmap_lock.c:572:14-33: WARNING: atomic_dec_and_test variation before object free at line 574.

vim +572 mm/mmap_lock.c

   569	
   570	void mmdrop_async(struct mm_struct *mm)
   571	{
 > 572		if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
   573			INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
 > 574			schedule_work(&mm->async_put_work);
   575		}
   576	}
   577	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

