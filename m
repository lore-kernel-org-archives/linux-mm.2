Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DB9C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442A86B0088; Fri,  4 Sep 2026 18:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3BF6B008A; Fri,  4 Sep 2026 18:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30DF76B008C; Fri,  4 Sep 2026 18:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 008296B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:33:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81FFA140139
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:33:11 +0000 (UTC)
X-FDA: 85177531782.27.D5851CD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9041EC0008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:33:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IxBtX3U6;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788561189;
	b=ppJ4VMRczgMVfJZ77fyDGkLsAf/rDntxtPWz7yIzcvlE4m1iD7H++BsXo4vwxOsC5go091
	eHBRGMWY6z+Zw6vnBJYp+iwjaAbw1H5l+qfLxAdc6yD5NOUE5nZMtFKS5Eac3f9EgP9jeo
	LqjH5T3pBZ9DWZIslTRLaw4mApN8oKM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788561189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bTRfc+f6+z98XzsZj6SrSB+VCB7F5Iy/l1vA1k3rFCE=;
	b=7Jm4T/6UQLNIs8EHxsVOh5k9X5Dx7zNbVCFhL3RoQkMH/WufY/n5FvS+96QJCwV0eJgGUT
	yPXhTQuAwdz9GngQWLDwverptIUeFbXYI09LdamWfE0140u/I91gM6hfMl7mjPp+v4n9Dy
	kUSlZZT+P4Zpqmyvo7xG7Xw23cOJfqM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IxBtX3U6;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788561188; x=1820097188;
  h=date:from:to:cc:subject:message-id;
  bh=VmuDvGGu5gYnC6uQaNYccGAJzm010w0N5hZH+dEWsE4=;
  b=IxBtX3U6yv8wLix6wL6alp9f3ZBPluFn6xTAkRzadEeUfTlLXXvj6Zan
   4JbiUXByC1zaFUiMDkNS2T4wn1A9NAVkEzTzrShMoi0CEEO1NzE7fR2By
   Hk0NL+Rk+8FFOfemFUOCr0nXUQwaTu1qe9F1gWfKD+zXNQ0GPlMFCnrJL
   9iHE9CftvE8f6fk14RNWR0rd5lBMl/0cDhifuzPQ6MAwrTV7BbX8skeyQ
   AjiRnxds2f3k3x/MK4WjMdR1V/6wrFMOjvBrq4WzQasHRum/WyQHE2sXK
   zgZ7u+XkVXRYoe+P1VG+G4Eiv5TGg/WMItGFP2mvKxBvFrUHAhneHhtGJ
   g==;
X-CSE-ConnectionGUID: IxB8et+lSWmfFPW26z/ymg==
X-CSE-MsgGUID: Vi57hlqqRDevTMEBTwmKrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="106584645"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="106584645"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 15:33:07 -0700
X-CSE-ConnectionGUID: LrHTzWPBQl6cMnrSigAXOw==
X-CSE-MsgGUID: 1SdEnM2xTwyPVLZOw10xAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="270683256"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 04 Sep 2026 15:33:06 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2cT0-00000000ADe-3wVC;
	Fri, 04 Sep 2026 22:33:02 +0000
Date: Sat, 05 Sep 2026 06:32:19 +0800
From: kernel test robot <lkp@intel.com>
To: Gregory Price <gourry@gourry.net>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 301/316] mm/memory_hotplug.c:1507:13:
 warning: 'node_is_memoryless' defined but not used
Message-ID: <202609050628.ywCLhOj5-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9041EC0008
X-Stat-Signature: uhx6bur956nz1xrpyzphy8xdixjcf5q6
X-HE-Tag: 1788561188-138321
X-HE-Meta: U2FsdGVkX1++GRWwx4eAcaayZV6QlGT5YwbZqE8nCEYfNy0nHT3ZEmtDTIZus40wuHr/OopM32W2fT/bSUuOdeL/ofnyelPYkITGMZYy9yj94STczMnxSp4XfH1z2gMxTlkEsR2Yylzt69ZeggYWxvW/a3FxFmXvoou6lq03ViPWRWAV+wHwNnW6uIQ63Kp0McYpfJ5fFfQZMEiF3/Lb2zvYLeLv8EHfXbgTlgeq7vfqT5E2F2r3/9y3NsXawe7uL+//dghpOpTPYUp+PMwThS6JdTk3DEM2JRuyYHnyaROj9MiwsOugD8f6MpiDV7UgtbRnLgZInc5ZSTcjzZC/bKEIQJbvuwsJPULJk4zFOrjDEv9WEJSSFfWYd1IMk+xrHl8xKtULB8/I86y/+ZUa7fLnf9Hly0yTPFcKgWI1YW/CgSt8s9zhaSXJrEU6D5yM6gzD+9wq7Tmkw4z5xzVtHPL6Xb6HnDnhzsGvd5gub0fenllv2ZRvf+w4MAWK3J4tMqbk4jA85a67R8xAVVOl5oZzBxGp4PF4+0aU4NqV4vxK8ePl8LsyOjf0SO4MCBQCXqPh7o6h0BCQJTonrwLBv/atGdx+kEvLREQbfVJMBPuKA3PNRC8vvyJ+WnA2GOEh5YzZYl1pPwxT2055+PZ7slboVAqepIe8f12NGeaYinuk3lTDiVpm3Py3/UZ66mSFBkm5Z3GsQFk1ugkH3yhpbIEoqV9ejo8wXKq23quMgHJEYqm3vtq+fC8ch6g0f6EDIqeCAfb8FIDwqHizG+5ZvV+P/txbX0JAJE5i1PQhZHpIaH/wFuaW0g2VoHVEjlFi9QmJ+ekanxfn3l9mT4jydEHsQCz4iRelcixXcxswmRdIFOMvWPnFD186Hl2E+pkPz8AlIdF+Jqh1qJ1z4k7q4UnffR9YtOn9XVvLxf3FolnyR+h3e8t4VExYyxNOanyV3OwZNtcVX6EESbmptvH
 KWP1MrDi
 xGV3fatdXMYA1QhmEsSE8YOEnqCMBwkNAIZ39w/5qNzCJaATA4aw1SllpZM0HnGbVNEXXFxP4zfh6zj388yjOkWiRMXz38TQ0++Pc8KimAh6+T9QDkvcenibstM9h1CjrElOoSZBXwPkm6jwBPa1KHtYsygynYre2I4z6T1e6D+PgvW/S2Mi0vpMkpOSvCv6WqwihxFVtz5bugU1ecn/cAAbaB80TpRmEqSd/sBQhqvoPn/8DTqQWud4uxTUUYghevlNH6ZaVnRzKIoA/Bpo7oehQRlkxyw9JjWtmldrIP4Y9Zbr7JfVvAEoudI5thh/BMUZMB9pMtcXhFs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Gregory,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
commit: 77a622e07892674da28eb3ad349ddd96df10aded [301/316] mm/memory_hotplug: factor out node_is_memoryless()
config: x86_64-randconfig-161-20260904 (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/config)
compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050628.ywCLhOj5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609050628.ywCLhOj5-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memory_hotplug.c:1507:13: warning: 'node_is_memoryless' defined but not used [-Wunused-function]
    1507 | static bool node_is_memoryless(int nid)
         |             ^~~~~~~~~~~~~~~~~~


vim +/node_is_memoryless +1507 mm/memory_hotplug.c

  1505	
  1506	/* Caller must hold the memory hotplug lock for this check. */
> 1507	static bool node_is_memoryless(int nid)
  1508	{
  1509		/*
  1510		 * A node still spanning pages (especially ZONE_DEVICE) is not
  1511		 * memoryless.  A node spans memory after move_pfn_range_to_zone(),
  1512		 * e.g. once a memory block has been onlined.
  1513		 */
  1514		if (node_spanned_pages(nid))
  1515			return false;
  1516		/*
  1517		 * Offline memory blocks may not be spanned by the node yet, but they
  1518		 * link to it in sysfs and can be onlined later, so the node is not
  1519		 * memoryless while any remain.
  1520		 */
  1521		return !for_each_memory_block(&nid, check_no_memblock_for_node_cb);
  1522	}
  1523	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

