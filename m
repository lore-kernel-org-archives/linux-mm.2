Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C7BAD68BC9
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 02:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89086B008A; Wed, 17 Dec 2025 21:11:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A146B008C; Wed, 17 Dec 2025 21:11:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968FB6B0092; Wed, 17 Dec 2025 21:11:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83F056B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:11:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DE171A0C17
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:11:29 +0000 (UTC)
X-FDA: 84230965098.14.5B38774
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id A6E57A0003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:11:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ftBfjtyq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766023887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G1629zDR3pL0VdIDtmJWTYzcOaygZtQ8B3KfenA70wM=;
	b=GGkYMgZW5O8yqLRGE8nopchHS7vSPYJNpgqDD3LEnIoyn+9F0qI8FWvW0xC4dAd8jdzuBO
	aPCHCyjLkrFE234RAzV3/YIToVdPSdq/J7rG2BDNo3FmUWFPmtPBjKw8dNGVpz3PJIHdl3
	UtByri2m0HV2WsAQpemPoni0Besvzd8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ftBfjtyq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766023887; a=rsa-sha256;
	cv=none;
	b=oMrTHuaeaHMCN6vo+/no0ca8JWAgPlHHnFar1vTNU267HFhicX7Oz3gOZ0BDwUFKlTFrzo
	rYNND1mijXAjTz17GzoKLXLRGFeaVrj9Q+paV1NLtAUYQJw06+HO2dOikKqzv3aTWHJfTb
	TOq0soNpklGThiqGdkFU6v4G2vkaneE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766023887; x=1797559887;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=JrVOdy5AoRDos3Sg0JrGaeOqAb+yjem1AbYTgJ/v1P0=;
  b=ftBfjtyqAGDZjDgKvHSxzygr4SX5fcJbT0EGCLcxEoUYl4SqZihPPayU
   BAe8HdBtKoq+xg8rqNb1SiUWWsgLgxO2h0jLizdjO3xQcGQGxmyhVuF1P
   g0EClAm/g/ZvDT6e6sRKF5EzRjGXoGOjXdJlesg/G0JI1x20UUPOAUZKo
   pUuIcOy13IoMqHISeN1oYHeJVuZkiwYbIAqMAAlp7mSL00UvGrRoXn8mg
   PPqu8mXcepOQlyww8tsckh51MgCykgjpCVU7FnK3PlwzYxE7t0MYmjwjf
   Vr256hLRu19xRx6rIv4R6IqqLOk3yz9X+WDORCnGvu9qk9h0wnp5Hbri+
   A==;
X-CSE-ConnectionGUID: AcB5DnU1ShO2mE50qjJR+w==
X-CSE-MsgGUID: MKsMRc/TQ4Sgyb4opTGs/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="67852532"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="67852532"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 18:11:25 -0800
X-CSE-ConnectionGUID: RfowAt2zQXmDBmYlKbOd0A==
X-CSE-MsgGUID: OmCJ8ZWaQZe38zHt63ff5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198354800"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 17 Dec 2025 18:11:24 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vW3U9-000000001Rh-3b0U;
	Thu, 18 Dec 2025 02:11:21 +0000
Date: Thu, 18 Dec 2025 10:10:57 +0800
From: kernel test robot <lkp@intel.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [akpm-mm:mm-new 46/101] ERROR: modpost: "arch_enter_lazy_mmu_mode"
 [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
Message-ID: <202512181054.fFRvEL0A-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6E57A0003
X-Stat-Signature: 6e5ghfsgz9ioo9yqba73aa79an9hhrjy
X-Rspam-User: 
X-HE-Tag: 1766023886-77040
X-HE-Meta: U2FsdGVkX1/7Kg6w06A8v4xYaZbju8ga5CT7WvzV+ULVMJEkpHWFShIIF6TL1sOuo/cYQjxGMR2lK9pUjxt+9t04ZEet3/7NEPtkAGrKErCFBpgYukgxiyO9DPGBlZHIQXLah/zmGeQkolSyXr/lkqPNLW/LWPYkfeeMesoiHWx6BJa/g/bj8y1wtCehOsZNgdje2C1IawajJG2RS1jj3NQSao/TPqWTt+IVZFePQLrcTNtWdXrSBeRYRuj8M7xCr9szp9bMfHSOOJ23ZhXIMzfeKjO2fSOH6u6VLxLtvOVNYgfqZ6FO5nP6U1ZXmaK5YaRJaPFOw2qIuE7/JgX3UaleIL5L6EiMwGirB+1qj5rQAqjyqQiJ3k15nRDlyOqJ7Gr6LwBRwQ9pVCxz5HBbMD/PEIinrkG3tOZG1xkcnld6R01b2CcqardmvHw7/wuYW8d40rvrnCE6kroAeRL5EwMzSEl6q98kYcNtWUXCrP8MPp8d8duN6WdJMc4iKPtN7/lN+EXOn7lxzOwQJc2CrdVm2g+JDPcI5Su0wryq5VikK5g60hKjsq8eAcu811k7T74XGca8Bd4bSYQQL4oDYjZZOqlkjwqS+Umpoi+DANv038PCND8Eq++G+bgrxnYiOqYJFkYT/DFU0ugNogmCec9ALPB05GXsx9gSokPp0D3fhwMoFxPVghzgtUjuKnIwnj/YKPUEtiAPxD596dKj4wqmF+FZj2Hcyh2it/jBAiY24pb2gh8J1ClIVCf4L9Zf1Z1ikXYfcTN7PHQ1iPfBPa607gba50Nkgbk1eNqkfe9e6q52pcNUsiUl3Z2KVG3ULc0/y2X/sR5CWkGy8cEaqqxf3Pt1heVQBTvU0rzjIdaU5CrooxnQ4yEB4Mf/gDlJvXplrGF2qsJgw8Fa61rHsbXu7AE7zBgU47SyrRSWWumQ7jIJYGzhzOA4EwIaNAFt+bzhuS8/HH9GKI1kl9V
 C63vUTCE
 fJ/KDteKJ6VtbR/Qt6iUFYsgNLw9Zn7AwmrkrDfkkWaALuugS6Ds4fzDrE73PlUpecnyvryhaoWucRs4Fky8N0ZZFUk0qcJSE+Q+g439rq5oIaWfin0BDgjIZlvEgDE7FdQnWHakycnKXkhEuaDfT8Afind3/db3eMu7oqoWCzRS6laTxraSHSPK1EjRw3zqI/4fL91NbkHiH8E4UHZ3U1SmRL203MSF5qpTYRBYbps0zE3xhzsNq0yy+Z/OpkehhNVMpYB72uLX/HwvensU6aXIsmudOKX5ITYNyIGsBHLakFNEFBfmTSRdejdmpa8gSltdF+ul2qy3YEEiY0KUKFhNBkHcVu+CRJoKZrg4P27QBA0lS7TpW0sAddAbRHN/UTXfMBX0PFIytG8WlZY8unlHAvaCKHxvYg3+T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c224625ec6f8a0476ffffc09807f4d717ba9cc93
commit: ea8fcd8d760d02566427104cf48979a8544eead5 [46/101] mm: add basic tests for lazy_mmu
config: sparc64-randconfig-001-20251218 (https://download.01.org/0day-ci/archive/20251218/202512181054.fFRvEL0A-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251218/202512181054.fFRvEL0A-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512181054.fFRvEL0A-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "arch_enter_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_leave_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!
>> ERROR: modpost: "arch_flush_lazy_mmu_mode" [mm/tests/lazy_mmu_mode_kunit.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

