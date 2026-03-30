Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA7EFF492D
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 02:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01676B0092; Sun, 29 Mar 2026 22:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1A06B0095; Sun, 29 Mar 2026 22:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879566B0096; Sun, 29 Mar 2026 22:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 728986B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 22:53:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A68C213B76A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:53:25 +0000 (UTC)
X-FDA: 84601208370.06.139B5D0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED03B140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:53:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jkXo1ayq;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774839203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=PWhNTbXy+Eo2ryLtvkn6D3TUeHZTGTMkGSgFFBYbcBY=;
	b=K3akkuIOgqFU/bUhbfq4eziukkM0nnp+q/0JMcQ2ZU1hC2Z+KowtB6p5AvC92i685kgiFU
	CgFJhA+ILNoqvodODoSsWCaDvvulWQznb7foQ4zMgO3j0spA0eFU+3v8blumTIYyfIF8ma
	Qddoc+580i0yYmyg9O7F+Ob1RHi3NaE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jkXo1ayq;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774839203; a=rsa-sha256;
	cv=none;
	b=GibcmckTQfcY1Lh/21OMrbRDGqbxTfCbPWx+RFfRtQ9lMIcZ+tuRaF+hoaj2hneeZdpCWx
	NAPeItrDiSLkNZPQsPaoOCTMu6WIf5R/8+c+04hurfKZsSr9QpkwUmueRxJ0AE1C1QM0Lh
	Mj//BVsNEu2Fg50T1oadFzperFvGnMU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774839203; x=1806375203;
  h=date:from:to:cc:subject:message-id;
  bh=tfbepM8W/GqyPM/r+8M3yzka7RjStN//uYlRUCBBves=;
  b=jkXo1ayqVayWw/vnLk7C/H7Rhd46QBg5obGz8HWXKvM+PwNXrjIw5ySd
   FUwYMUhFhvmEPiRHiyilSoUIiL6NM9FzWtuHNQILswDrU4kbUcW62hjTq
   kM/eexGwmQqii+IHgcw6pf92sTfOoyV3CK7BCOwdlKMkyB9/sXcapPymp
   ijcxG6K8yFp9NmxBfkde1tD/4gFAwZ9KBm27L8oZ1bKqEpZ0C/PUrRK6C
   o0/5AyS0mjv7932RrbyMCSYiYF29gM/L7GpFrzqQvJ5f0yEU4W3NLPtwe
   1BjEelrYoiPmD+rG+BcIZkwe4BM9BTJp6PfD2cYhaEQs+XrunSBzy7jdb
   g==;
X-CSE-ConnectionGUID: gHZzldXhTZG5OO0vs4y7/A==
X-CSE-MsgGUID: 7JNY1eAMRDuVlXwxslkNrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="79688601"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="79688601"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 19:53:21 -0700
X-CSE-ConnectionGUID: A7vf/REBQX2JbTckhR8Log==
X-CSE-MsgGUID: FNSFnZScRLaSqmXNdCMtiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="230720052"
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 29 Mar 2026 19:53:20 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w72ke-000000000aH-30RB;
	Mon, 30 Mar 2026 02:53:16 +0000
Date: Mon, 30 Mar 2026 10:52:23 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: kernel/cpu.c:607:21: warning: variable 'cpu_smt_max_threads'
 set but not used
Message-ID: <202603301003.dnx2tDpD-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED03B140003
X-Stat-Signature: c4xqjskwpu1af6r34dhcr9u14gestq5e
X-Rspam-User: 
X-HE-Tag: 1774839202-874316
X-HE-Meta: U2FsdGVkX19xfX5mIBvxAkgZhacwc81noxU8T86hzcELLw09G8Qafj4v3gDRpQuPENWEt+S8z+ysdPbA/LenJhnxQ8NV5H3rLOI1jUn8pWuP4mbpjMHkOrgHXn/hn2Vdzadi9UK/QTBW4DbOeyzYkBi/9j+d+fWAjbbMwiKmY/e3Qi7jcCRSdRZSt3As9SFGl+VgqPDO9pLXxfpJkSNSsCrbTPemAUfmm7QeH2IHPR6X0iDENFg4p7M/dr77qXjkaFXk+az47ReqAAOWVFs8PsvVQea1wF/yucYJXzZzLxBTUtHPltCthGUKbQdseN1SwSsvolxKTqv5NiP/gUhIuhhjiubUhBqe1kje2Rw3pC+y+nifxs2aV3A4K/rGcuX8i9b0l6DE/F7IhkSf5kHVNUM3lHXQLHQknw+ERfyrW88S1u0zscTaXIfwwx0v264B6zzvuIZg2P8MIT2cn7JnZOKSgst0u7QFKEEOYn7lSfG614uMJmRPRCg14zAXn7sGJJ0uCUGBk4OB8VDI1fouSdxl0485+jEO/y8WVaPtssv53HgRXx0MMMkykOHV4sGEIYLHahcfrpmrrtbAq3fHssd0ang4arnONZyywygORk6BzwTITk2B/85YznVhfP+8BnHQUkzoH6a9dAUTyzRPV3ubUV5LIb/JaPeGBKqvyBVx//LMXhKj08ATU4u2pO3kJIsI+pu8NtobDrY+ABo/M/hLnnLxY1t3UhEsMnw/8BcBm7/tb6PjEYmqF3GVnODcctf88tyEckLzIbUtNNGrz4bCVl7HuRYRBpt/itT3Tk+HStuN2m9LASNxoM664RC2WNGNfPNk3d82rLd3ASkQSA/QXrYVt3BVu8OJtz1S7Wo76THAuSjkWlGnNuFd480yOY1BrrdMD7hxI+KMUwvbphhxCRoOxNMKKhQ/b1FSbrJTuscqbFZgiel3Xfc9VipQm6GiD0a8qyZyjYmiqth
 YlHyhhqF
 aWdIok/IM17soufEuxTlKEqYf2Xy4YlzP8DT3kQ8W/62bpjxi4ISksdFd8xaxyn58bwrysjcmtT86Ha38R1oVW00mZmb999/SYXy9rFM4DYsfFEzkaSsBHuCfz/7YKM32NfV9mxdKJM1xJdJq76uc0r1kjKBv7zdjMKGSBUkmoJcvlgqj8Yh658T5k1P6LbbBfKID8neysDPouPR7fi2NV4g3pCnMf6lmWZlBq4uQJ+KT1nbla9yNlbrbZyKcNehJrzbJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
commit: 4496e1c1354bd4837bcc1414f6e1a4d042857903 crash_dump, nvme: select CONFIGFS_FS as built-in
date:   10 months ago
config: s390-randconfig-r072-20260330 (https://download.01.org/0day-ci/archive/20260330/202603301003.dnx2tDpD-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 2cd67b8b69f78e3f95918204320c3075a74ba16c)
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260330/202603301003.dnx2tDpD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603301003.dnx2tDpD-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> kernel/cpu.c:607:21: warning: variable 'cpu_smt_max_threads' set but not used [-Wunused-but-set-global]
     607 | static unsigned int cpu_smt_max_threads __ro_after_init;
         |                     ^
   1 warning generated.


vim +/cpu_smt_max_threads +607 kernel/cpu.c

3f9169196be555 Michael Ellerman 2023-07-05  605  
0cc3cd21657be0 Thomas Gleixner  2018-06-29  606  enum cpuhp_smt_control cpu_smt_control __read_mostly = CPU_SMT_ENABLED;
447ae4ac41130a Michael Ellerman 2023-07-05 @607  static unsigned int cpu_smt_max_threads __ro_after_init;
447ae4ac41130a Michael Ellerman 2023-07-05  608  unsigned int cpu_smt_num_threads __read_mostly = UINT_MAX;
bc2d8d262cba57 Thomas Gleixner  2018-08-07  609  

:::::: The code at line 607 was first introduced by commit
:::::: 447ae4ac41130a7f127c2581a5e816bb0800b560 cpu/SMT: Store the current/max number of threads

:::::: TO: Michael Ellerman <mpe@ellerman.id.au>
:::::: CC: Thomas Gleixner <tglx@linutronix.de>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

