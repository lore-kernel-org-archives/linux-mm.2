Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACE710ED651
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AF76B009B; Fri, 27 Mar 2026 06:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62586B009D; Fri, 27 Mar 2026 06:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C789E6B009E; Fri, 27 Mar 2026 06:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B85186B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:20:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 350E41A107D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:20:58 +0000 (UTC)
X-FDA: 84591449796.16.589EC5D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 85105180006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:20:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WZ6g9CfS;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=gNiX2z5Rt7eJXgdyZ/DQF4R4N7nX+gIlrDE74nSGgTQ=;
	b=2Ic/eRMiv5SPRNWWx3iLM4gKo13/jR2aQXF/9BI+4y+FbYeRCxBKVFVvcci/DnGyWp2v49
	/oWSj/PE7zBy/wp2ERCxdv6K07f0Rk1f4+9N8r512eZ9IaxNlHZdEl9zZfNjPIoBnsBG/Z
	DOR014Ev+xyMOgwZDEokx61o0Zxfa0Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WZ6g9CfS;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606856; a=rsa-sha256;
	cv=none;
	b=Wib+9gWYvOUBvO1AtxlhEbi6qvRXQT1SZ8dDxxqrCqdWQ8T3y7uoCzFm9DVARe+zic43hg
	rh456iyMcfNZRVZXa+C9VZ3plB3fcVtRK1Dppy0z0J8kMbmg6lrgxbiqkbRg7qWOjPtNyP
	dUlrjW1OWoyc1VfuMMGZYeLjLqxOAXw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774606855; x=1806142855;
  h=date:from:to:cc:subject:message-id;
  bh=xZAFi59AJSs1E1d9hb+Z/RYKTP/h7jN0DjNoQakie6s=;
  b=WZ6g9CfSubGRPk0YlP3tD/DLKXerBeeAvtTCskSIgSRoOO733Cz2STsK
   7VWs20qmb4ZOzfRlRm6c/Nfq4JKiHPaFOhSM+dfik3qBfYwCHycRz+mjW
   s31zHZ9RlGRY1awv2Kh17smjIJBnbSl08MdGuyuZl5fIRdBRXarfLQ+eG
   yN+rk/+LdZDlquA89E23C7NWzsACwC1lRO34D0+4uajvaPfxbesHb+61I
   6BsfacnShWhC8eBsr8jAqmKbV2v7lUq6jFgNF+JxxmTFT6R25G5fej25E
   VtWiZPPafuZDd9P3P24SC0xYTTlu/pfUln2UK2xOwSZQNeUIuMg/iCb5A
   A==;
X-CSE-ConnectionGUID: hzeQfr9dSuaxNrYSlYT23g==
X-CSE-MsgGUID: oBzKBeCCRZubTsqmByn/Eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11741"; a="75793268"
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="75793268"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 03:20:54 -0700
X-CSE-ConnectionGUID: Xm6neMTrQUC8vqSJcIkEmA==
X-CSE-MsgGUID: GY0DnxXOSSOUIjBufEwuew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,143,1770624000"; 
   d="scan'208";a="230199435"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa005.jf.intel.com with ESMTP; 27 Mar 2026 03:20:52 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w64J7-000000007TV-3eco;
	Fri, 27 Mar 2026 10:20:49 +0000
Date: Fri, 27 Mar 2026 11:20:28 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Chris Down <chris@chrisdown.name>
Subject: [akpm-mm:mm-unstable 199/330] vm_util.c:127:14: error: too
 few arguments to function 'pagemap_scan_supported'
Message-ID: <202603271115.uE9vpppi-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 85105180006
X-Stat-Signature: oqob9sy7yfaroef9mf8bj5n8a56xmnwx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774606855-23547
X-HE-Meta: U2FsdGVkX1+ISTfMYigQmRDfujnSHh/Q/z8iiQp+C5AvsBjpF8Skh4FlJdX7xCCGSDbR1T1BVGu+aHK9Xnj9ce/l/SthIwmPOWGo2VeRLErTtjT5KhCPIskqFk002lszHp+80XHC65BkenSm28bn8EWm5hTIoQ/Ptctr3jYXu5bOCk31coqd4eJJ9b/0q87s6V86DU7qOTbbQBJa+Y2VD4Cf8AoP+RScYZ5RyRBsJ+UoeaxkdobgfUHHj/3cwf7n8/+gZPTqnKe5U4Ut1umr61HG/+zx8qSEFDBg3Y2B8FNUh+UmRKSXA7wEN/hjTGTmpFiYE5UVJ/6oOckgIJLfzzL7++NkpMSa+xJhZ+ddzz8i4duWisom3MYzO0V9UtHduiIKxbyU/QBvhyY8XENjkHF6782ip5VcyCt4QTPEYDVqy/6BENUv+J9a7Lhqctju73DrokfmD2aNl/GubWe0T8le01Ek9G3JvxC0gOosfzF87G5Ziwaje/Ov2qx+/OmHTtkY4W0LirnFNckG0YdqxanglP40LnPfRLwj4IIzc7GZVl/AL2qFg60ORAO1wb7ULA72LG/OYUzBaSiAy5EI/Jazc7qnKatt1t29rbb+XLW2cRoJPzBHEKtvRrKyixUEU5AZuQf/s0oqdBl4ii/Rt/LU39g5Jx7bLGy0PuxaIbYh3n0gTbhFAaKqer8B6f6fzjFHqIEqbFlW4pjx5UBEMHAhcx5Uuy6ZNPW/niHbFuoIXL/V4OnJKgbXSFEH+97QgKKS9n9UOUnNVRqjZNU6iRq95h5kAkwzlS3LFMWbh2W1YOEw8BaglaK2WDsLkBlWcQLcWF/9lx4XAIOY04dqt1htpUCiJgQQTTZR2qItjnfe/QWvyRdKle7As96BbfSTh248Wu7fKg+ABVC9liGE5HeHZn80OtAvPsy7aCxLzH/LjNKD6f8DFjibyeNDCFhtRnBLvoHZQnNXgSoH0gw
 h/UlfSc4
 +5Ym94a74hIOey85HhDBZSqB/DzGYdFRW8+b3IqKAaE4MX43UnrX2LwiX7S7Z7omvx7ilUnKZvqCSfC1uyVN1nB8PYiZfidC4A47IqOxZ8/fI8Dk1AgaQ5QY6YR9YanHwOsTgks3LHGDwXO+yU9P+nPjRQUyn25e7vBcNgl0rpPGJLFzF+0Sw0gJFKMhSDoi9MvS7CBmQQAlkYqLvFpKXiImeWASZb1I0bBGJOZvkIpP4MZE5qkhWQ8prc8vSjcyqkjOWRgd0gh67s2iGpNFlRhF1ZeJHdDc9nm5p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   74dc4627271e6e367176b519565e901ed72d6e4c
commit: 9652b82ca963243fb80e645319d473a7dc65ee79 [199/330] selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260327/202603271115.uE9vpppi-lkp@intel.com/config)
compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260327/202603271115.uE9vpppi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603271115.uE9vpppi-lkp@intel.com/

Note: the akpm-mm/mm-unstable HEAD 74dc4627271e6e367176b519565e901ed72d6e4c builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   vm_util.c: In function 'pagemap_is_huge_zero':
>> vm_util.c:127:14: error: too few arguments to function 'pagemap_scan_supported'
     127 |         if (!pagemap_scan_supported(fd))
         |              ^~~~~~~~~~~~~~~~~~~~~~
   vm_util.c:70:13: note: declared here
      70 | static bool pagemap_scan_supported(int fd, char *start)
         |             ^~~~~~~~~~~~~~~~~~~~~~

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

