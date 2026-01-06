Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25502CE9D6D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402086B008A; Tue,  6 Jan 2026 10:52:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6276B0093; Tue,  6 Jan 2026 10:52:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F6AA6B0095; Tue,  6 Jan 2026 10:52:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD7D6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:52:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEEDC160388
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:52:57 +0000 (UTC)
X-FDA: 84301982394.29.BF6E1AC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18B91100003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:52:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mA2SawdQ;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767714775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WjoBC93TUCy9rsX/bNO2Bebf9c1QdjXQKGTse0OyowE=;
	b=TW44wTClZaqVSmjIP5yc6UkZtnvvgr5wtlpYZUdKMgsRb6KBzzkB++sJIG6Atpx2xxUoj7
	HWZP0grmUvBw4Vtwd0tEeBmCHffQO/PX+a32DCAWHpbrvXN9DFx5W1L9ndW8XtrNnypiQJ
	phbUy7t1qQ3rN5k1Hu3ad24VzAkR4So=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767714775; a=rsa-sha256;
	cv=none;
	b=ImaqrcHbbWfMsBFZoRZvEjwTNLKGzwd1tPLxbmmwVYbMLoohO4HWQTEHs51BldNJEfuP5y
	dnlZu4v/Dki2Dm6c3vML/bZ64BhauXVPVJSxVjbW8C2UFDGIqGxyplVV63Mn201k1s0XFh
	ih5LKMdhMyeUPfxR6muW2RFwima463o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mA2SawdQ;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767714775; x=1799250775;
  h=date:from:to:cc:subject:message-id;
  bh=FsWDkextg+s4K/LAsZZx114K4unANqAGAbpmuNHBxKc=;
  b=mA2SawdQuT0g+LjiU1xckv1pJbWgPM6kSMsqO1GoHb51z0CwENKQPQkr
   Wu0xweD5mN7NyTp4MvA8jk6ck1aEv5cV1YYXNcPkaxMw0IBJcdM3h2c9e
   Ne7YufQyKI1FQMXucKD3eNxmY/B+Tjl6wHlVdvzm0sivRwCsL4ZtATnd3
   oaHKZ2jPjMw1U22m+bVF2bXxBHxDi9D4ACQDKlspz1fiNsWZZs5rcvWkj
   +kBkFEEXEgcjW+Z8kNWhvbdY8Nbyn6vVfH+5FyZc+xrzmTsgfDDMFUVqz
   gBxZ5aXwwtGBZfM3UTF848vHERySnkU/GanHesNqDcGOfgj75JYjwK/3x
   A==;
X-CSE-ConnectionGUID: SCj5nBJBTByK0lBYpx2dMA==
X-CSE-MsgGUID: qaPhUyTsRzeeQNGEHiJWEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="94548372"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="94548372"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 07:52:53 -0800
X-CSE-ConnectionGUID: 3t9/P79hRO6lIO1TRL8uMw==
X-CSE-MsgGUID: U5So3CQLS2Cgmglt9T23Hg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207555033"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by fmviesa004.fm.intel.com with ESMTP; 06 Jan 2026 07:52:46 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vd9MR-000000001Jl-3jFN;
	Tue, 06 Jan 2026 15:52:43 +0000
Date: Tue, 06 Jan 2026 16:52:06 +0100
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-nonmm-unstable 102/107] htmldocs: Warning:
 kernel/liveupdate/luo_core.c references a file that doesn't exist:
 Documentation/core-api/kho/concepts.rst
Message-ID: <202601061635.i4VQmlUw-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: q4kwjyb7gaxmsroh1943jrstt6qk4g4o
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18B91100003
X-Rspam-User: 
X-HE-Tag: 1767714774-565436
X-HE-Meta: U2FsdGVkX199WxKD4+rfdCLfmipoUb5aalwPcHhszah1+59NnO6Brd63p8lhv4gPlCRqdeP7FvEW9noaqi3BgqekcQnFk6PqjspzTFCWkbFW4IIZAgvK2V9V1/jb2cftK8Otm+U/58nPzjZti7tEjnQRcP9gFfBT6NC3SO+Ipo0TR0DwlIYzVl0uYLBbiqicsh/cgzA7RRNG23S1bfZ/cmxl2W/yB8WlMAp8rexFguKT492qIyJYh9O/7xZGpFxm1hSFzLeOFYHwvIxb8n9cDiiKVpdUzTPM/+246OptxTprG7/L20E4PLk+mR3IFA5h1IiGWOf/6VH5jl/24p7uZVrzvuVQkZjk7cCQW+g+4sOqI0PDHbdhGOnwzryvCuC1Pg/mf5TW/ARUkTSi9UvhGSj3fBlol0cN2klShgJfFqUpo57d+QX0AAn3iNDZ8cLNM62cu3wxwrUc7CSBNaW03RfeWWmBrEANWifczatROOluxi187/5MebV9mWV/Xb9pYmZQRFtCz5Q4qGSdHooIR4L5ihoxTyrinLThJAMTy6ArdRGnniy7QEe8Wutj5YuKolDuyvNz6ojNeZIhHl1hPK2aj3Mdx0ikL4Uv3uxuqm5UlUJlN+sEvf0zn7U6wRhS0kDF1sU3GtaiifuY0Z7EF4SbqcU6H/2cogChm1dVCC3PN/m2pDR1m5h84CYodtCDlrd8t4a2+STVp5t4zDMgROpTZTiQnJ3EgSI7xBecfHdmO9YCmg0RsmrJHr6JCfKY7kZYWttbWdwJivVehhbl2n7W00iR2e/J0R0g/IGCYWqVXpHe3vAmln6JUM09FOyVznDL3wjhKvXOayyQOBS6AI4twVty5+PeR2NNkpxOkSyaLhPs7I5B1Bhfnau05L+O3+Rsk64i5BwJfrxm2C3+I3IyVtzafS+REHb8NSt7Z2fac7zBB+oAHHsJTZolCM2ulKbW7WhS7XMZ+hwr4PG
 yIcKS1pm
 3D9Ooqt1iKDRmnRnAr8Znv1wLfyP4PEoXVncJ3afA3ACKcU1m1x1RFdMWQFaycdHjl03Uy4Ri1BNiduXfT3rkQhQx8OYiAanIT1osKVWRexHj8CjxeMLcs+QokQ76W50AjRD5O4oFRyI1rc7z3Ze9uXsNT+rhIFozRhaxw/hI+USa6DpRdtQpCDCdhARUWPFsLhbtvEuHtkzHtRAJxWMjGPaYjSrLKpxmhR24rxoc+i9QEC+EVza9gZ1W5Ff/VrwPAoTT+lJ3qXoPOrkSSszof1vEaq/Z9omQ5feC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   bf64790fd7f2a71c84dada79a573d37cb08adbe6
commit: eee99407da66f5f657ba0599b4d6157b59be3721 [102/107] kho: docs: combine concepts and FDT documentation
reproduce: (https://download.01.org/0day-ci/archive/20260106/202601061635.i4VQmlUw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601061635.i4VQmlUw-lkp@intel.com/

All warnings (new ones prefixed by >>):

   Warning: MAINTAINERS references a file that doesn't exist: Documentation/devicetree/bindings/display/bridge/megachips-stdpxxxx-ge-b850v3-fw.txt
   Warning: arch/powerpc/sysdev/mpic.c references a file that doesn't exist: Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
   Warning: arch/riscv/kernel/kexec_image.c references a file that doesn't exist: Documentation/riscv/boot-image-header.rst
   Warning: drivers/clocksource/timer-armada-370-xp.c references a file that doesn't exist: Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
   Warning: include/rv/da_monitor.h references a file that doesn't exist: Documentation/trace/rv/da_monitor_synthesis.rst
>> Warning: kernel/liveupdate/luo_core.c references a file that doesn't exist: Documentation/core-api/kho/concepts.rst
   Warning: rust/kernel/sync/atomic/ordering.rs references a file that doesn't exist: srctree/tools/memory-model/Documentation/explanation.txt
   Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: Documentation/virtual/lguest/lguest.c
   Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: m,\b(\S*)(Documentation/[A-Za-z0-9
   Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: Documentation/devicetree/dt-object-internal.txt
   Warning: tools/docs/documentation-file-ref-check references a file that doesn't exist: m,^Documentation/scheduler/sched-pelt
--
   ERROR: Cannot find file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/mutex.h
   WARNING: No kernel-doc for file ./include/linux/mutex.h
   ERROR: Cannot find file ./include/linux/fwctl.h
   WARNING: No kernel-doc for file ./include/linux/fwctl.h
>> Documentation/admin-guide/mm/kho.rst:10: WARNING: undefined label: 'kho-concepts' [ref.ref]
>> Documentation/admin-guide/mm/kho.rst:31: WARNING: undefined label: 'kho-finalization-phase' [ref.ref]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

