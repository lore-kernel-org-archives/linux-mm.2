Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6627E95372
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 10:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F9A6B008A; Wed,  4 Feb 2026 05:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D8D6B009E; Wed,  4 Feb 2026 05:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1C306B00A1; Wed,  4 Feb 2026 05:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB5066B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:06:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4ACA05AB22
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:06:22 +0000 (UTC)
X-FDA: 84406344204.18.DA3D0EB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9312220011
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:06:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CZKXl+dY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770199580; a=rsa-sha256;
	cv=none;
	b=2gtAm0iKWSjFDOhavaU82MCSOHV7qnd13XCgxqHPXY6lnwvJfZ/SNCbGMVHwSwJImmochl
	9QxPrVwocRfIRHJqUeFfaxJdKjtf0t1i1unC+n4WVwt97YYpFXpt3cvge5i4zLm4gTYTGW
	vStk37lhK7LRBuqlB0dlFMb+U/F9UEw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CZKXl+dY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770199580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=D9HxAumNmpe8J8U/T7Gdsq3VAUwZDXQg+B2McB0UGQ0=;
	b=LWJCBILy8OgU39LVTjokYatq/HjGEF7BJQ6ACyr0kLW/J14sfmDfSLNBr6IafbQ9+vv4Cv
	LntD1I+ABatqG3xgbBJooZECbJax+H/oSmoKPH44IGuyofufImwVQ+3Zcz76i4uvZ6cM04
	vEerX0cWslaV23Hvug50f+7nFXCvXeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770199580; x=1801735580;
  h=date:from:to:cc:subject:message-id;
  bh=2EDTZrfHuRej4wOgRYjVsCkOS7HIHmRDyJymP4OlmCM=;
  b=CZKXl+dYhhZUrwp43LY4WI6RuE829bWLzo2N5QdMzu5Steg9w/i0iavg
   sbATryDc3EL0mSOYxzAeFIP0JPdXLkEAIv0gU8XnN/e82pt1PjplWCwFR
   YXQM/vkhgdyE9Oln9D0L6wNpqyemgaL+6dwe3OJDUWg+BK89OmZfKni/f
   AItsNW8c2kpJtySrdQ4ziyHc7uRlVjA/T/R9XYQ09C3zmxL9MIuek4/R8
   xvuo6V5t8TLHNBnkYApKK2mNW2d5aWXuvCVRFqYQn2JlB3pn7mqVmUwIt
   nh5ZmI/W22WSg5RzBvmkcSAxDfZylIQ6LPOOtgRNGiRhj8aWztOsATSKI
   Q==;
X-CSE-ConnectionGUID: Vs6lGwxMQ8G1CSodW+KqBA==
X-CSE-MsgGUID: HOJ0oCXcSOKGqk+qQKM1GA==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71280970"
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="71280970"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 02:06:18 -0800
X-CSE-ConnectionGUID: 6lVpEMlETViWPFgtDkPMLQ==
X-CSE-MsgGUID: 4CVukEYgQzanFSMXOMLMVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,272,1763452800"; 
   d="scan'208";a="214601410"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 Feb 2026 02:06:15 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vnZm1-00000000hfU-0VQo;
	Wed, 04 Feb 2026 10:06:13 +0000
Date: Wed, 04 Feb 2026 18:05:28 +0800
From: kernel test robot <lkp@intel.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 102/124] lib/maple_tree.c:3364:38: sparse:
 sparse: incorrect type in argument 1 (different address spaces)
Message-ID: <202602041809.nfXcWI84-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9312220011
X-Stat-Signature: i6thartpnegrp7n49m5idfm3jfx5fiwz
X-HE-Tag: 1770199579-592214
X-HE-Meta: U2FsdGVkX18AbdEMRVgGP7e6CLz47qccXfj0b4wiSua6sn0LtR7qO6X0mhfacV4BwdD3AbynXnZEPNQa2WD1PvsiwTZP+HNX4u8MjpMCY9Cq1hHfMcz/28ePCLQ+YNhOiQJiQ4lM/lIzl3+hCMI+YWCSw6JLhg92XXaL2Svu8yEjB7s6HJKbpmOqnmoRV0Lt6u2lqcD1vnsJJILcAHrLD+/YKCJamzYxjLyiH9skli1cgvobrNwf9bpveQ4YgAlutjFDLpeJYsIdMpAMhyr6eWg4yWWSMlOBOKfzvTv9+LZSbH3YnwkKd7/ar5oq+VQldm9V3JdD2vkyo46yrtJ6ALlA9tye6uGF5N0JFOdKLBm24rOqXLut+n3OGKEeiowtDwF4CFR6YMoBkUOVZP7f30c7P71qpBgaA/XoYU0D+93FiZTBRg8uKxgCYZaDcXDti9DXBvgDL1A4OgAyuNW3bgtOre2+ZUcSGcf3DqG4Hp7i8XuUDWZRbSL7GpnHOyZ3hDFlfS2036h1wYRSfP/GY0LL5UnOyPYGH6Exifug2+BDXDpj6Z5shCwFe8Yslt2i8rtAf35vhzQ9H+yFVIvHkUYuOygFhlTiBGYC8lT4LeR7FmI4Ab28IIoOBr16+MzOIvgsCc9cwkmVv37J4twDhUj/wYPDMsDgJ37/oh49AREll6YWRlN4LYeuTkmOpdWulLU7UvUAsSBTDI5yK+hxWoKhtncZP+lQrELWcPcXlyPF3XDJJMCTNdqQXSOZ+1wLdThTmFBF2kCWhHCTaawJHFs4IQ+mW+L+afL+lgIL2m+98jcowHafQ1QT4Lc0XqnN0SP6aBCb9NtnPcbe7HGm0r3TJ9DaZWw4wo1AZqgcryweRK4VArryLeiwjpady7qUBz+lCQJwOc/HNIatghMp8fkcAyWnyVACNRlvE5dS9Kfv3Vq2B51iMKAWnpTDlCE79o7Wk65N0hdiVGhmAFz
 sn/oK+NQ
 wtebijXiHmymip10TgW9yx0TpMQgMOJA2NNjLV5RtqWp6qO+6Nqya2W8VKwtGKZncSgBKvCA+snqH3HC9+m6SzycjEbwl7AopHx6GjQDLgcPGHOEo04/jAIqiueQaslyNGGu4swLpcKGG5ScLGOijWsWCT+Xy4zBjTuevvTL0y1Mtoc6dCjEfVGkkWcO2xNDiV78UciAeqNQwqWhxWRWeG05JAIQO34iC5V9SJKTUQ2ZXTYtrohBBWZgc/y+/Cb2qW8moA2Hu7yJ/KlA5Psw3wN1rD8lc+fO78J4D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   3b688128ee79df55807d8b3e60e9d0ed62db009d
commit: 8b56f4dfdf0a4aa460fde0212eb270c943288bfa [102/124] maple_tree-add-cp_is_new_root-helper-fix
config: csky-randconfig-r122-20260204 (https://download.01.org/0day-ci/archive/20260204/202602041809.nfXcWI84-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260204/202602041809.nfXcWI84-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602041809.nfXcWI84-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/maple_tree.c:3364:38: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void [noderef] __rcu **slot @@     got void [noderef] __rcu * @@
   lib/maple_tree.c:3364:38: sparse:     expected void [noderef] __rcu **slot
   lib/maple_tree.c:3364:38: sparse:     got void [noderef] __rcu *

vim +3364 lib/maple_tree.c

  3339	
  3340	static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
  3341	{
  3342		if (cp->min || cp->max != ULONG_MAX)
  3343			return false;
  3344	
  3345		if (cp->d_count != 1) {
  3346			enum maple_type mt = maple_arange_64;
  3347	
  3348			if (!mt_is_alloc(mas->tree))
  3349				mt = maple_range_64;
  3350	
  3351			cp->data = cp->d_count;
  3352			cp->s_count = 0;
  3353			dst_setup(cp, mas, mt);
  3354			init_cp_src(cp);
  3355			node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
  3356				  cp->dst[0].node, 0, mt);
  3357			node_finalise(cp->dst[0].node, mt, cp->end + 1);
  3358			/*
  3359			 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
  3360			 * documentation.  Since this is a new root, there are no
  3361			 * read-side operations that can view it until it is insert into
  3362			 * the tree after an rcu_assign_pointer() call.
  3363			 */
> 3364			ma_init_slot(cp->slot[0], cp->dst[0].node, mt);
  3365			cp->height++;
  3366		}
  3367		WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
  3368					mt_slot_locked(mas->tree, cp->slot, 0)));
  3369		cp->dst[0].node->parent = ma_parent_ptr(mas_tree_parent(mas));
  3370		mas->min = 0;
  3371		mas->max = ULONG_MAX;
  3372		mas->depth = 0;
  3373		mas->node = mas_root_locked(mas);
  3374		return true;
  3375	}
  3376	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

