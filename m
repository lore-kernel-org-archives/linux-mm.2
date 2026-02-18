Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5658CE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 10:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49526B0088; Wed, 18 Feb 2026 05:40:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACCB76B0089; Wed, 18 Feb 2026 05:40:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1FC6B008A; Wed, 18 Feb 2026 05:40:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80A7C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:40:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B8ADB9710
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:40:55 +0000 (UTC)
X-FDA: 84457234470.25.69AD4C6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id 45D134000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 10:40:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCKRTwWb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771411253; a=rsa-sha256;
	cv=none;
	b=pM1FOzQci2oL53J9O1VZBoGkIuwBsynzGpWR21jiv4qbckUc8kuXVUuiAvF+xWqdqiStSJ
	F6D4gEO3bTvbPoywpuftQKmjrYxBffeLx8p4ITQhommmb+qq1JarKL8bgiOgLTcHFDjogv
	D6aWvoEw5laerUzd0wbUJbmxQnrmaGo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HCKRTwWb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771411253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN21/7l7a48Rt54T39SUlP9i708r6j7Tv1vUMG/t1as=;
	b=4pyqbRuaqPpfHcC6j4DdGWaNC2S6n6pVioWWBly/uCQF0RKmQcg5W9CtDDmlnF0uJbOTWy
	xXdyG5nr7+NZ09vqkGHD6BFEyk845ibUlau3ue7DwyjDpHBi1VJ6y1fGneGFljdoRgeF7J
	r+R7gbupe3Jyw4T5QE8agSkxWonYhtM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771411253; x=1802947253;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cd26PjeVkqMJVQiI+SjBkCnU4JV9CmmiLOsGMTatUp4=;
  b=HCKRTwWbTOJ1MLKUZq1s9gJb6ZqeaEpxUNfBtITyUV4y8NIUPX90BBs0
   eIlpDmBXPnQa7EHmwcF1k3c0EQUbZOEYWYeqeV9rUAKDMjdHbc44zjPEI
   AJ/7yWaGksU9R/EE7bd4iNCCdLijlwpOWD1hzPkdMsCTmgoqneH1PEgzk
   7wJfaLS/DZ2lg3pp3Kc4AurUVyiZLwg8qQ0g7ss6orKvCEf6m0FH7WxfO
   SUZj5wzx1SJlrf6LbHdbKhIfclHxCqIW9O8pqGe85Vf2Dv6b2PppMWP6o
   90TsZfs3M1a9Q4kanb6bsBG9gobNEtVjLpoW+rpjZHJTCI2EkwyBe4djJ
   w==;
X-CSE-ConnectionGUID: F933tuM+TPWRiabk5J9JbQ==
X-CSE-MsgGUID: W/ZpTsjmS06jgG0rI/G5yQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="76344974"
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="76344974"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Feb 2026 02:40:51 -0800
X-CSE-ConnectionGUID: d6xlXNzzQI+9kyepzCAGCw==
X-CSE-MsgGUID: 2I4IkMg5TO6l4UKmR3Hdeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,298,1763452800"; 
   d="scan'208";a="214148730"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 18 Feb 2026 02:40:46 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsez6-000000012HG-27wy;
	Wed, 18 Feb 2026 10:40:44 +0000
Date: Wed, 18 Feb 2026 18:40:16 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
	linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 09/12] mm, swap: use the swap table to track the swap
 count
Message-ID: <202602181835.58TEynxc-lkp@intel.com>
References: <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218-swap-table-p3-v3-9-f4e34be021a7@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 45D134000A
X-Stat-Signature: 8dumotxjjy8unh75sjmxr6rptdkm866x
X-HE-Tag: 1771411251-166464
X-HE-Meta: U2FsdGVkX1/5JFoycSXCiwavkWNWpWLIqIwhkb+HIPnES8j5p6ZIkdAyu0cDtr9xEMfqRmrvYx8jJy0CgWCBe11mxcOz0S8uAWqgKVwVvr5ZL6t63nI0HcmJpsiXH6drqQghh1f+N3RLJ5cgO3iHFG8pyLTc0tKWgBcadhzl7leOSfOlxXzLSgnRi1aFPyXPFNHxdAye3A8xpTlluEDOSDbNGx/pFwgMkvpFa81n8uOYI6TFDsd7X8YvMHb1quGyw8wjv2zolUsesY3u485j5E4Fze7YXaWdJOInIai4w3oLsqDQD437PvQn3xpUGNlyJUu9iQfleCNLwC3KY38pEk88nQCHdRusUcrjqCeoo7I6Jc2euQ23nFyRzjZZUhLbO63nVZO4gJxk7tz7bALCoU0/a1Ar8tzR/dhAI7HVRZJUiRA9BpEkmtIgkfijWYXBGr0ZEk3gMeYOSZPdUun6z6jJt8PGvT8+bHQDit6XTApHO4aqpGmF0DpNlevrb6yu3mTq6Lohn5nsKICBbBscWeL7w2I+rm3NOuJKXAMJo0cusQJ+Eh6/iZz8WjC6OHTymVNydkhUhnSDRQ/R7UG7GEkb37WhGRorFXimD9Ed4+A2Rg0lrR8VEyYrjxcVTxZXUYiodnNitJ39YYjYJ4rgjoMlfPaRzHYzOWZcV0Syg+K9u23DxuZQ0ITkJs19jk/SopLmZIWMDpUB7NKeD3YK3WH6JdqEQlvZT3ywa8Nd9DGunKr1smkHMUAPlBeCrmp5dfOpZWqw5OFSyxn82Q0QokT4iFmHr2BxBoVaBCqmbs2FeOJtN5+ewzH/gMk5znPPwxbcc7kcx2n94hsu2C4S8s6Lbg0PrgttrMfp/YwnHT3RhZnmCn3Zz9NmSkPu8VlBYoDEq+uiswTDrzvhSTj1RshE9d1nL4HF6SUAFM3hEnv4mhN5bjxfgllVu0Mkxe8cToG3sU/k5nJ0zTzLs8k
 YFhSebZ0
 19NNZVW6rvtkiR50wB+ilVJxYGTSUFWPJWx6FuQmfB9imtVmPuwp7MPEWYDjEds2ieDimr2HOXmN3zLKK7TddEn6aBvWRhLpMxHkjqHXCRisxpZieExHHjdotqbng03cSvbRjmNJ7FBuRPoWo7c1DDtgQizNF4QS14t41HnD0J82HSCaXS5LHO+CbrVMuxpuhQgOPvQajuqPMwa2vaKdGY7OLmTCXu/qBNjqUgCkVLowP1m3Nz8JRW6zcGptDLMRt+nrSdeDrXRaBXpki5nUXiMnOb5EAocpxM70NLwKrlAgqw9YdXEM7MxoRlL0+MX+eE1WFffIBNYPD/eedsyIZbFnQHVCMaOsp0GkBWytTvTfo3B3eO/Pgjs2/qTE7zhD2xCzr+BYlE7YTdhwLB76ErMfIOXo5aKC/IundQKsJffvf9PTl19HDzShJ4n4zK/LYDLLk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song-via-B4-Relay/mm-swap-protect-si-swap_file-properly-and-use-as-a-mount-indicator/20260218-040852
base:   d9982f38eb6e9a0cb6bdd1116cc87f75a1084aad
patch link:    https://lore.kernel.org/r/20260218-swap-table-p3-v3-9-f4e34be021a7%40tencent.com
patch subject: [PATCH v3 09/12] mm, swap: use the swap table to track the swap count
config: i386-buildonly-randconfig-001-20260218 (https://download.01.org/0day-ci/archive/20260218/202602181835.58TEynxc-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260218/202602181835.58TEynxc-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602181835.58TEynxc-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/swapfile.c:1627:6: warning: shift count >= width of type [-Wshift-count-overflow]
    1626 |                 VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1627 |                                 (BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
         |                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/vdso/bits.h:7:26: note: expanded from macro 'BIT'
       7 | #define BIT(nr)                 (UL(1) << (nr))
         |                                        ^
   include/linux/mmdebug.h:123:50: note: expanded from macro 'VM_WARN_ON_ONCE'
     123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
         |                                     ~~~~~~~~~~~~~^~~~~
   include/asm-generic/bug.h:120:25: note: expanded from macro 'WARN_ON_ONCE'
     120 |         int __ret_warn_on = !!(condition);                              \
         |                                ^~~~~~~~~
   1 warning generated.


vim +1627 mm/swapfile.c

  1596	
  1597	/* Increase the swap count of one slot. */
  1598	static int __swap_cluster_dup_entry(struct swap_cluster_info *ci,
  1599					    unsigned int ci_off)
  1600	{
  1601		int count;
  1602		unsigned long swp_tb;
  1603	
  1604		lockdep_assert_held(&ci->lock);
  1605		swp_tb = __swap_table_get(ci, ci_off);
  1606		/* Bad or special slots can't be handled */
  1607		if (WARN_ON_ONCE(swp_tb_is_bad(swp_tb)))
  1608			return -EINVAL;
  1609		count = __swp_tb_get_count(swp_tb);
  1610		/* Must be either cached or have a count already */
  1611		if (WARN_ON_ONCE(!count && !swp_tb_is_folio(swp_tb)))
  1612			return -ENOENT;
  1613	
  1614		if (likely(count < (SWP_TB_COUNT_MAX - 1))) {
  1615			__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, count + 1));
  1616			VM_WARN_ON_ONCE(ci->extend_table && ci->extend_table[ci_off]);
  1617		} else if (count == (SWP_TB_COUNT_MAX - 1)) {
  1618			if (ci->extend_table) {
  1619				VM_WARN_ON_ONCE(ci->extend_table[ci_off]);
  1620				ci->extend_table[ci_off] = SWP_TB_COUNT_MAX;
  1621				__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, SWP_TB_COUNT_MAX));
  1622			} else {
  1623				return -ENOMEM;
  1624			}
  1625		} else if (count == SWP_TB_COUNT_MAX) {
  1626			VM_WARN_ON_ONCE(ci->extend_table[ci_off] >=
> 1627					(BIT(BITS_PER_TYPE(ci->extend_table[0]))) - 1);
  1628			++ci->extend_table[ci_off];
  1629		} else {
  1630			/* Never happens unless counting went wrong */
  1631			WARN_ON_ONCE(1);
  1632		}
  1633	
  1634		return 0;
  1635	}
  1636	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

