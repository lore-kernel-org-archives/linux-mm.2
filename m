Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43359CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 03:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D086B0092; Thu,  8 Oct 2026 23:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FA66B0093; Thu,  8 Oct 2026 23:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E447F6B0095; Thu,  8 Oct 2026 23:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5D246B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 23:31:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F136A0221
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:31:21 +0000 (UTC)
X-FDA: 85301662362.25.1C44B40
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5AA0C180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:31:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JupESIEE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791516679;
	b=T0zN7IoVUouKem0G2uVRah/0BX4z6vJ3B3eqS7EPUsYWdI2Dj32nVDYJDik4uZawVZ4Q9k
	D1FtA0JhLFwm8KN/I3O8U1eT4pjeUui8cwNzHxSfxvQBY2+/uqwL1LZjBRYltgpJz8AwEl
	v1Vh8WbgImJPHqUxkJaVS1oifWRLB+4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JupESIEE;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of yi1.lai@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791516679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+W7wFGcxDhN0qsemt9LATz5+QKoBHYpotn/G/C1lCPQ=;
	b=oA6UkECR+xN6enj9B8ySRlv40gO4/5fePMEzyvnJ9skH3NCOpFoT7ggTRc92BHLb197AP1
	gIYad4t1hT/oqkqVY5Xs6v9+KpKfjtcCAH5SDQWbV2mz6TNONaqVDXQS+3S33FRctZ17n+
	VkiakSkiVripkvo9PweRPNqO7T5jJLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791516679; x=1823052679;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=bLCjJ2qDKu+48tLpSPvLn/9TDbJUSjqorra8kXtkbTQ=;
  b=JupESIEEQiDCAO0myHzVE5wH5/HT8pSRyHemXn3y3X03khe8c7pfp6rV
   0OoaanMAYBa5Ge108uqcaxQPTLLyVIiKzF25kQUV2VQ1EALnYyGmZn/iH
   yC4WR1Xsqz7vwbhYuvEInEcgFSBF2iV0eiTLyb6441remFdPBl/EFtBEa
   fmpeHjcObbN97EBTcoqznybJ0ePHEUeVvYQVGx7thDeWlq1oFOiJvGCcm
   sm6Qq3aYYew0eTa71+E4J3ZtooMGIuQybUFjyIQD6REOSCCLBPdWLcc4I
   cHkHnTtMt21+jUvRq2IZUOsfkDCZB6AuQ429WPn4arslhhavOfRd0O/Vr
   g==;
X-CSE-ConnectionGUID: Z7S18sQvRPqwrEDPjCtXmA==
X-CSE-MsgGUID: QJxzn8SrTHm4D9Jjtw9nxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="215495"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="215495"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 20:30:39 -0700
X-CSE-ConnectionGUID: gKEfUMn3QGSKSWQrk9hvsw==
X-CSE-MsgGUID: v4Hf0qCsQx+mHt6yBcX4VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="654599"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 20:30:36 -0700
Date: Fri, 9 Oct 2026 11:30:33 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@kernel.org>, Hyunwoo Kim <imv4bel@gmail.com>,
	Zenghui Yu <zenghui.yu@linux.dev>, Chen Yu <yu.c.chen@intel.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	aubrey.li@linux.intel.com, yi1.lai@intel.com
Subject: [linus:master] [sched/cache]  28f9c0e0a0:
 stress-ng.fd-race.ops_per_sec 5.2% improvement
Message-ID: <202610091149.c00cf9f2-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pb695fn4hs5pdrryg1dkw3np9ttdnstc
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5AA0C180003
X-HE-Tag: 1791516678-421023
X-HE-Meta: U2FsdGVkX18Sf5ZPmDPU+E/tZcZUD9aH9XE4XW2fu8YcSgbgc0SHk8NgVpRuLS1o5MHICDzl9wgEEyjR+kMxk1qXPZMXh+a3lt4JagMBjX6wvWmfj8ejD6o4UyTrZE/s0pms0fkUGJYgDEiC6LvomQKnsvXgFl9ufW68yfoU8Auy3Kfr9FL8aXz0xOjiYUhv/6ejHixSo+BcOqrDDLgRxn1PZBeugebFioQZGREY184dvGCLvJsnBs7pn26xxTq3AdKGyFe8JI4r1+YkPfXmWt9ZMZFlm0UEBZjUnod3h3z3/L2Qb6T2Roc6WyvmhU9blxfWimNT3UGz5IkX20dRl2xFljY5jNgEnKVPzUteWI7bcj6oLNytOCRbd0Pkxlkm7SS0p6uZFIn68FrLwGweFRfMuIHqluhfl1naPVnF6nl+Z0n5CQ16UxhxD5yyGsGQ/dIbvcV8Eb7cghuQlEKVyF8Q4CcQhTGk17FNTyliX2y4jxdM1pOzIT7gTxFJ4vm42Olwk37SbaYjInv6upf8gp6D3OLIgwex+IkfPjxVsVQLF6QUY7JWHYdjgJdFnquU2F3HxAzIkMW7kUh9czB2DsKWDOGaxAcfB8Bn5ebel1pbLYoP+hkR64ABUGUZd+guIYR5zBkdhmzkop+Pk+AGTAuSwgHcLpmXE8ReUTPCyVpzAX7kdUqf/5F/xyrGnNqrASciHCYM+ORL6HshlhuKmHe6WXNq585MxyFDrAOBNYeOuvKv1ozjKq3ou9ijfYJQO6Wsd/HfBJc7OJeGLI3lNJbXTiumLUfIYxUjjgW4BRrRFJDIki4VEMBgIhDC2N4rzfz0TsWxHROIJbX0jiuiL8AT5EtlyPVsoG90rFXnFYxCyNNdnCUGWzakcqifaJvCU2vnr6mHWmjTwxz3nnKh6qJmQxW0CMyTku7PKNwkUyE8txrpozwjGoEbigaO27alwZIkChAKdnAztoC8bKF
 tt6z+hEe
 NEgM8SPSRchEFZNP7yR5Vl0+CY3UQW5HseDJSnbO9AIY2MB/pbJkY87FRGhj/wiLr3XHnidzUlT6nGNhQHNSWa9hzNKOGxX40HgtWuOjTcn8ZjvBqgXUfboU0Hh9NxCEF+JTtxp1TNxbSaPUcjFUe/kvtOfsiatObueMdXFTHOpMP56IoMOyLR1QG9xqp8Ncqn0w9fdIgZ3a8t+hv+6uzJpcecOwOVlr219rJlileisOwqWcJHkCwiwBvzpyP5mxirzt9RbZePHjAgjnAifYM1PQBLLlBmienAU414EiQ7v52a8VLUEaQ3wLKofEA6Jchq7aP7Qt2g2Fit+LwG9rfWm0i3hbjh5PHPtqlsQHU/NnyrE/PQ/guDjoAK+vG/rgwwMAkG5VvB+4VZgucF3ySIduS+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 5.2% improvement of stress-ng.fd-race.ops_per_sec on:

commit: 28f9c0e0a0b94c5d3e1b634db545f6e1f94858c5 ("sched/cache: Decouple sched_cache_group from mm to fix UAF") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets GENUINE INTEL(R) XEON(R) (Sierra Forest) with 128G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: fd-race
	cpufreq_governor: performance

Details are as below:
-------------------------------------------------------------------------------------------------->

The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261009/202610091149.c00cf9f2-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp1/fd-race/stress-ng/60s

commit: 
  d6013e2465 ("sched/cache: Honor migrate_llc_task semantics in active load balance, to fix LLC mis-scheduling bug")
  28f9c0e0a0 ("sched/cache: Decouple sched_cache_group from mm to fix UAF")

d6013e2465d98d52 28f9c0e0a0b94c5d3e1b634db54
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  28370042            +5.2%   29834431        stress-ng.fd-race.ops
    473267            +5.2%     497702        stress-ng.fd-race.ops_per_sec
    843367           +27.1%    1072325        stress-ng.time.voluntary_context_switches
     62132            +7.1%      66565 ±  4%  meminfo.PageTables
  48712422 ±  4%      +8.4%   52824690 ±  2%  cpuidle.C1E.time
  62293414 ±  2%      +9.0%   67917882 ±  3%  cpuidle.C6S.time
     68069 ±  2%      +9.6%      74599 ±  3%  cpuidle.C6S.usage


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



