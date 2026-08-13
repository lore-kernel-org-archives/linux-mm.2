Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6769AC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 13:16:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CC26B04E4; Thu, 13 Aug 2026 09:16:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECFF6B04E5; Thu, 13 Aug 2026 09:16:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC766B04E6; Thu, 13 Aug 2026 09:16:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED6216B04E4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:16:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82F691C0223
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:16:34 +0000 (UTC)
X-FDA: 85096295508.05.E0AEE01
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id AEABF140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:16:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BwkKHIEC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786626992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7szPNde4Qo9DXChUbMMX+VaPs38RPJ7eiVjqjPd0OK0=;
	b=fcapZWxNPWu1wx754hnut0/Io7wU3M2fsIeY0PLkv7p+bylL6NtDEk//gOa4pdeI7v3loh
	9L/DgzdGa4M6+vpby8DMKKbTO7j9sFwnyc55kYIOIcE5XwRaKgZUGvE+uuqrJnzFh7rgwN
	S7p/C5VkpqOtl2XPHx4Hfw2kgNRT7NY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BwkKHIEC;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786626992;
	b=zxktbv4G3h511TlLZhv9y+MhHu7yv5d5Ch9J5e5NlvScTzpfeZme/JCqxypQscPutYo+dO
	AohHhIkvlZwm40yuvqATHFM7iFWNdNVXxIw8HLGy+bATzXxRlKzPJmfhaUnG3/kqm9IsUK
	YZkJtYOVs531DkVtgX1iQ5E2UgbAYfM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786626991; x=1818162991;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Lf9SZ0pwZEYsjvNWHi7qkXhT5ob7kt+GLztd/lIRdy4=;
  b=BwkKHIECLRI0tiSg6/ovzJQJLjHlZm680rYluRUwe4D59s3KYiJXKwH4
   0hwkdZI60hJQNE5BgjTRyYHYwT2aJGwJnFAXtudkJp3ym+kRCcaO8gZ6W
   yuk1JXn4KaGbF+0PL+COfQraChS2Ym2P4g1y0/hw1VxgyASv06lLLfe+K
   peKRI0A65SJKC82IKUQDyIWbAsybNak7zaUr2o+UQsWw4ICl4u98NDNCS
   7uDlJ+FlOFoul/91ZGk/WPBVGTnLMC7vRw3N7ksYV/02+py1zQjf+atft
   EBi62F4Si/6mBqQN/JdstUtkqtzI/3vZV0Qsz7AOeOKsgZL8wpwBOrHHj
   g==;
X-CSE-ConnectionGUID: I2txO8TgRuma2rKI5PkxtA==
X-CSE-MsgGUID: Np2fJbJPTeqQJ5bVdyH0CA==
X-IronPort-AV: E=McAfee;i="6800,10657,11873"; a="87221291"
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="87221291"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 06:16:29 -0700
X-CSE-ConnectionGUID: Je51M1g8RjO4yb82bTtaMg==
X-CSE-MsgGUID: a8tbCZAETQO+2o7tS8Y+JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,221,1779174000"; 
   d="scan'208";a="267454311"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 06:16:26 -0700
Date: Thu, 13 Aug 2026 21:16:22 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, yi1.lai@intel.com
Subject: [linux-next:master] [mm/vmpressure]  ea928e9e18:
 stress-ng.mremap.ops_per_sec 36.2% regression
Message-ID: <202608131743.c6a7dda4-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: AEABF140003
X-Rspamd-Server: rspam07
X-Stat-Signature: bz535w9i1o14bju75tdqjeiyembhkadd
X-HE-Tag: 1786626991-938738
X-HE-Meta: U2FsdGVkX19BlWjsaXQaEfCxwcN5QTwc4K3/TPon/xTNIg7QEQqTLTHF9YFhsMuiiZEEQ+7F6BfQ9d0Y4nwJaD81/bKpX1K4CKucQyT5TVijWCUZPmxv6UeWH3/zDrSEnoTZxsuK9MHLwumJQChVONYte5YIBjjqbjHN/YQfpXIrWLt+dcfwKddUoNprUEWXa6gFBs8S1x6wrXYkSsp2tzNEEuENeRBv2UGcGqauVNSK+4U/mvC9YgItLPM30gNQVaKmL8pZtzu0NfduLLQFnkiJp/EGAA3iuHIjntHhBKxSSjtXtzoJEp08xtJvA+sNjUFoI1/vZof0PHidjNg5/eQszMMewPs0+BGx87KeXTS9pa6Nzgr+USmBysUyqEWXrEh2br0H0IpRgfG0kAE1IDsNDwqtKqTEs4CdgnZb3vsWyME3vpBndHVW12fM9sp+hu2aNd1keBKFVJgj8EwU1WDRBMHcVWUm3SyzW5HJeV5cYFSyVbHURn8UcGDREnrlBBwnexEq6qV0TCeop938eq7jt6OF0rynvRndr0yhac6nT0+8kVywrST2YPG45UoBHOL/oBhhmasbuT0SBl+NORKOpMgGJQcex7l/BEeaBQ1ggM8u/moeGORnx3V+SFwAp3+vQd/HotBDSKN6ivPQ4AuXrjXVlnuWURVuZADzimACf899hv9iMDIXxhM007ky+ex5Z9Aw0ghu8g1W9Y+2zL5k2qXjoz8obudoQdPYpnqz66W3bJfrCa2+otm5x536xLTP52BqvCcDf2BmXzIsPvqsjnQHVMSIHhZJe5c0REnYHyE9nEEXw/SykBZmkf891bAHYNgwjthiG40JgzS5CPqWrsmvhBKE2JMmCw0myqSrOff34wRTfe/vbWwws2xldjm4vOiYPqnJxTrAsiObI3Ui2ZbwJkACUQhQUXbt31Eviuc1giUvO3c8nppC0djLaTWirVKzKAG2xe7Maui
 pQ5nhoPg
 NN7eAZW8u/Ss//nIP+lq6lgcs4xQ68I+0PsjjMnlArM0SiZ6HCr12JiI452cDWDUDFzCgtfH0AOL6AYncZVWHdtVkaaSeZf//IWJA5jLZpIHg4QV2hPr7CxqhYp7RYER0+YGicZI7UM3lc62YUR9pT83QjHUvdL/5gn6UpAPJH73E963WQ4iEU9wJ1Q1o/Z2GqWgwpsVbKA9i+E4QgEx/P1sxI05FTGFEE4ZJyMPFF6O74WpKtaPfmnZgSY40cubfxpeQIae845N1rGGw+WmKtyYKR4Kg6jQWt0EqVF0donoHH/44pWNwyoNjT+IhEmZORAnHG9UghZIaV1XQdqXtnT+WN7a4RDXm0eQHNVW7EmL/fGKXw111ZRffYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 36.2% regression of stress-ng.mremap.ops_per_sec on:

commit: ea928e9e18da682e9a5bc40aa862bff7ce5ae42e ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c") https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: stress-ng
version: stress-ng-x86_64-29ce10a2c-1_20260712
with following parameters:

	nr_threads: 100%
	testtime: 60s
	test: mremap
	cpufreq_governor: performance



config: x86_64-rhel-9.4 (CONFIG_MEMCG=y and CONFIG_MEMCG_V1 is not set)
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com


2026-08-11 09:13:23 sysctl -w kernel.sched_autogroup_enabled=0 kernel.sched_autogroup_enabled = 0
2026-08-11 09:13:23 stress-ng --timeout 60 --times --verify --metrics --no-rand-seed --mremap 256
stress-ng: info:  [10886] setting to a 1 min run per stressor
stress-ng: info:  [10886] dispatching hogs: 256 mremap
stress-ng: info:  [11033] mremap: using 1MB per stressor instance (total 256MB of 243.06GB available memory)
stress-ng: metrc: [10886] stressor       bogo ops real time  usr time  sys time   bogo ops/s     bogo ops/s CPU used per       RSS Max
stress-ng: metrc: [10886]                           (secs)    (secs)    (secs)   (real time) (usr+sys time) instance (%)          (KB)
stress-ng: metrc: [10886] mremap          2212529     59.96    209.34  15014.92     36901.22         145.33        99.19          6684
stress-ng: metrc: [10886] miscellaneous metrics:
stress-ng: metrc: [10886] mremap            151372.07 nanosecs per mremap call (harmonic mean of 256 instances)
stress-ng: info:  [10886] for a 60.01s run time:
stress-ng: info:  [10886]   15363.58s available CPU time
stress-ng: info:  [10886]     209.34s user time   (  1.36%)
stress-ng: info:  [10886]   15015.19s system time ( 97.73%)
stress-ng: info:  [10886]   15224.53s total time  ( 99.09%)
stress-ng: info:  [10886] load average: 163.54 47.28 16.30
stress-ng: info:  [10886] skipped: 0
stress-ng: info:  [10886] passed: 256: mremap (256)
stress-ng: info:  [10886] failed: 0
stress-ng: info:  [10886] metrics untrustworthy: 0
stress-ng: info:  [10886] successful run completed in 1 min



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260813/202608131743.c6a7dda4-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



