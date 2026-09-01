Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B683EC624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1E2C6B019C; Tue,  1 Sep 2026 09:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980796B01F1; Tue,  1 Sep 2026 09:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896326B01F2; Tue,  1 Sep 2026 09:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63DC56B019C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:41:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E24B414041C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:41:54 +0000 (UTC)
X-FDA: 85165306548.21.BD5001A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13102180006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:41:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a2x4MF0q;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788270112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkBqQIbzItUlb5ul9BtUyQnTsn7O7onQD+B4jNcuLG8=;
	b=VSzIXfo3MLfU77xp7+vcr8bDiy2ywVbeNwPM0c/5reA/64T5zWrz1/qbryhzjeRCWlTFk6
	J2zHZZCctLL4bNsOtVg+PlxYin28g8uDnAd4UqyK1Tck8GWdFNUnn1YbapHVhxgcOhRio4
	LMAdPcNNOwO0+ZF01bg117MxTyMiI8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788270112;
	b=S7qPnXkCOCU2ilslu9njC1MvXR5k896j6ZEi5GXpKJBxIcTwYFIZWiC9UDI326IMvZ8UuK
	zD2XTGxBa8T0PbodmTVHfGkJ9BTU2PfYc1uIjI65JDWw4F4Wcso0g4c0fF0fIjh8VBTwoU
	kPuk2qaASsUNWbVQi6xmbdV3isTiJXo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a2x4MF0q;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788270112; x=1819806112;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ef4X3KrThBCfzNj00N82Bs0EyfQsa2udrQuRrXWCqew=;
  b=a2x4MF0q4nq5XgWfwjBqv+tWEWi63sWIsVP4ootd0pJd/wqvLqgUGHYR
   QBhtB3ERJbf4YSG1KlrkYNTIUsWx4BGk6b+5ybzgShrU9FxJJzOJC1m0s
   QHl2PAsSG5RP68rSOo7TNbS+map2i1jU3D+tE88IDk7o/gixfyMY4jxR/
   j8/A08YuBLvVsoGsxpaR1Rp0TrFuRdQ97kNyQNdJ9ABnlw194GxGcK2vV
   5NBl3b+TUCCGsSMai8ymYu9PZ2uvhCFt1ZN4KxA+UO4XNe/KdWJnwVmyr
   qkThQiDiEqGJzZ5QwgGR0bY0bAgZ+ylyZU2wh/6K3wg+mID3ZWySKYo0x
   Q==;
X-CSE-ConnectionGUID: eA9V5PcqTQKjutzPj1lapQ==
X-CSE-MsgGUID: X635MU2ZSjC+OwuB32kKGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106218183"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="106218183"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 06:41:51 -0700
X-CSE-ConnectionGUID: xF4XZyquQGWdm/NY+bcZhQ==
X-CSE-MsgGUID: Vi3SeTLPRMK1o+3SmmDfRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="268571051"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 01 Sep 2026 06:41:46 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x1OkB-000000000rE-2GDC;
	Tue, 01 Sep 2026 13:41:43 +0000
Date: Tue, 1 Sep 2026 21:41:34 +0800
From: kernel test robot <lkp@intel.com>
To: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Bingfang Guo <bfguo@icloud.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/memcg: clear folio memcg after changing per memcg
 stats
Message-ID: <202609012136.TM23t7zi-lkp@intel.com>
References: <20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 13102180006
X-Stat-Signature: jbrdagro318djp6fz6hae8cfmss3zots
X-HE-Tag: 1788270111-130397
X-HE-Meta: U2FsdGVkX18GBp1P5jyZ4RCMpb9kwYvXQO6l+9w1Xv5avjfkQc/aFbD2nlc+YeyP+4qlmjHj2mmvsZA1N3dekm3hfgA3fcpenZALAZ+dkNWPFMeQCR2w7ztBw2omkdJamCKohsZkjPOSpBkBtmUcBZOOuqlgtSxShc2uA360ADQPGYpWy4itEMn9u7E/yxZSMoxzMUeNPZJvFNOm/pJzkOjk0S6J5sKeRM6o/yfgPAq5AOOZ2gsaj60QLSaYKLblBi2/YJ9Gbwi8Mov3mbxbdxkNzUKprTWZ2KgIdB0GpvGTme6DUyH5JdyuGTc8hQOHtfYUe6yXpEnlgtyQReg0HrWXVlJ04bgKieQe0K+ypnKK55drctSibmZBHaOs1uEOjhrViU2FEhNBP7l2ZZXJSrdeOFctOJFV5Tra1q65xxaL0gmYz1OnDuuH2q9IJEQMVNTm5xICEcFBDEPJ/bhZCBddxyU0+6NCu1wPSidy1xifPhqsNS0LyrgTphvMyH6++VtYDQSl69HTBqgyUFO31N9rFsjxRRfaoI+T/elaflCdfsOL9WJm7y/26SN5woqNNBwhUs3XPY97MfMVfPKGDuiBYtVUBSd+8y2srWocVlDMD7wfZ242MGkaR61Q9nl4u1IvzuYjT9ZWsVKAfUbvt/2SsY2nD2PB/ZlHXds5YQKS8+J7JEeApbc9b/ONxC3ArdSjTgpZOZGHPX/C5D4X4cxbaRkJhdjrIbetHFiUvxc0f/Keite2sWzQeVtTmd8HMJMxLVOBhuKxoLJwmHr4fuTBhV+/06fy3IR4zA2fQWRMl3lJce2b5l2w7E/xk3JNTKmFU0Mh6r1r0MU9VPE5WeXl0NztvUfUeNuMrBIU+QZ3I3yJ66n/wPh+GGgSI9DtwZTue1MvbdNANqSju9LNuIBSdxmnyp98Atrl5QNmVO1QoYV2Z+aF52SEknKEWjL0RzXnTCzDJJr01L3/lmr
 D4Vx1Tbv
 qUJSLrsxYU6IUn4W8aor/X+66HbvsKYUiZGdHYrx1h4MM+0Q2yl6M9tBl2jQvAUWFnIA/f1TqzCXR7Xi3fmO/S5ul1q0xnYyg+PHuEJ6dtoGTTN3E69O2kjKA0TS8CrZKW+RJk289Z0c50N7ulG9beXhSM0JaAcAasSUy94gid1nFrgdfeUlh2UVS9XlP5nsbtOAud2+1DkgkCn/8lKwEkBIhp+pK0ggkccU2pZ0bbF+PKDp+6ZKwP2EW6auBGJLRikrTFDCm2opSN2dNOQMY/8wu0hxrYH+DfPBhLXof7tJ0NZ1x9m/Th/lFnMCTSQZ/DMecI3HNgItrBxgKUn36Y/GzDa9zflMx6JnJGqP5gHfIHgroZ8Vuo7CPO0tgvNC3DcZD8Vz/WcBYewuHOP7E93iXVPBgfxSeseMULE/pyVi3+osuXRyGoScwpBy9frVkDY5WNC/yid/8J+8/R9O+j9UDUsJMRebxeHQBHiA765BFu6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bingfang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 88297631d4d42f6004cb39c0ba3da7d2d10a616f]

url:    https://github.com/intel-lab-lkp/linux/commits/Bingfang-Guo-via-B4-Relay/mm-memcg-clear-folio-memcg-after-changing-per-memcg-stats/20260901-144911
base:   88297631d4d42f6004cb39c0ba3da7d2d10a616f
patch link:    https://lore.kernel.org/r/20260901-memcg-swapcache-stats-fix-v2-1-9caad330459b%40tencent.com
patch subject: [PATCH v2] mm/memcg: clear folio memcg after changing per memcg stats
config: powerpc-randconfig-r071-20260901 (https://download.01.org/0day-ci/archive/20260901/202609012136.TM23t7zi-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260901/202609012136.TM23t7zi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609012136.TM23t7zi-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/swap_state.c:317 function parameter 'swapout' not described in '__swap_cache_del_folio'
>> Warning: mm/swap_state.c:317 function parameter 'swapout' not described in '__swap_cache_del_folio'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

