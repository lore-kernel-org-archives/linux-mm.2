Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA9EEFCE56
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 00:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA256B0005; Wed,  4 Mar 2026 19:35:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87BB6B0088; Wed,  4 Mar 2026 19:35:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93B66B0089; Wed,  4 Mar 2026 19:35:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B64AC6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:35:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 450611CAD3
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:35:00 +0000 (UTC)
X-FDA: 84510139560.01.4BDD450
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6094E100004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:34:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iWem+M2k;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772670898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZUEa0NTJRtniDt+t4lWZxR94N656WY2igsSNxuBFiPw=;
	b=Mdq+YfcLc9cqULy7bZ6b0N5mvyP+uVtHF3q2TXez1iBoNCYzHnyXjQWvgJVv/msZFJ2w6v
	CrB9xpZ0pMfnwJpkuFtFL8e3OqeMIfafZd4yD+rqgDNHFHOcKCR/TeqUD8HgjAE3d6cSNj
	dSsCjc52nJH+jCweNTW/YNHePkoq9yE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772670898; a=rsa-sha256;
	cv=none;
	b=HD1oASRTnopxjwu/4XYuM+rXLVTLWnEyCxbLoNEycKiMbG7RM4tLkYcI0MW9f4KNhQBS12
	cZiBF4uhofyLRovvANhmWXq7UnXGT33eY2WJOSaO+MrWfD0OhmwlFKWU0seBxEAqvgdr/g
	qV0edbf5XC8Ym1TYXUzhVRjCGHb3wRE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iWem+M2k;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772670896; x=1804206896;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bxrd2fiwvhsKyZsl+nxo29zi+60R+/EN/vFklSOWd+8=;
  b=iWem+M2k4R5tDBKp5myNyeqJOonpQGtIIMWXWsKH4DhuBevj0jekOEi0
   jZ2vu2LgxmDLZDNPSSIte09fGjpgGT1Sngj5zi7W9oA5fAgANGB2UQ4Fd
   AwVH1tXxL6evwcxSd9W+HQA/Dql8gAvyNZeY1ND0wWcEgkYdQtjKvw4M8
   3w1gguEvko56xe1RQghu2xKyIdS17B6llgz4g9AzQ4FBSaTQ0ELebQPQz
   NDhXf//ie7VRm9vNdwV8kesfLY9drTBllXuO6qNlvMBqYlcxMNfC92vEF
   df6RlfQgNJ6Iju2JCFTMoVRTVKNZa4ivt7RwG1Kp80JWH7dD9G/X77ccV
   g==;
X-CSE-ConnectionGUID: Nblf4bnlTxKlW0lm/37Puw==
X-CSE-MsgGUID: shQ4ZFYWS8qXUd7KhkNnvg==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73653561"
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="73653561"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 16:34:54 -0800
X-CSE-ConnectionGUID: sUWpvx1ITcW6G79rW8WCKA==
X-CSE-MsgGUID: y/9N3ZxqS7ePC3zmt8m0sQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,325,1763452800"; 
   d="scan'208";a="217751914"
Received: from lkp-server01.sh.intel.com (HELO f27a57aa7a36) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 04 Mar 2026 16:34:51 -0800
Received: from kbuild by f27a57aa7a36 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vxwfv-000000004r7-2iLs;
	Thu, 05 Mar 2026 00:34:47 +0000
Date: Thu, 5 Mar 2026 08:33:54 +0800
From: kernel test robot <lkp@intel.com>
To: Maximilian Pezzullo via B4 Relay <devnull+maximilianpezzullo.gmail.com@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org,
	Terry M <terrym3201@bugzilla.kernel.org>,
	Maximilian Pezzullo <maximilianpezzullo@gmail.com>
Subject: Re: [PATCH] mm/vmstat: reject zero vm.stat_interval to prevent
 busy-loop
Message-ID: <202603050819.oMnaHoIC-lkp@intel.com>
References: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15@gmail.com>
X-Rspam-User: 
X-Stat-Signature: t7whdr15up81suzcdfykw3oa4qbikrwu
X-Rspamd-Queue-Id: 6094E100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772670895-200904
X-HE-Meta: U2FsdGVkX1/asMC1MR3ou+Yj/1yksNUiXHpEyuVHvwXklUYYl5NxkJpmPFauL6MelE1fakS+MbYD48NNVAKTDeVemrCybIhRbu8PQ6vR7JqTTb7m2LJVJcwnVBDbmWzMx3HWe0ak0FWn6e6vTkGs4GmjxUEsiu+SeUo4e4KyyMc/HpinrYTTu+0sOESF9oXofGspS330sCP3yHNAEQ0LYHoQ9T2HMiv9AMXmAx1scHr2q+nq1fpjRGOfQF1Dr8WEwEh42wnGUz+Dg7ogdOmUa9V/92DT6Mq1l5bQ63138ONEzybu+/tyFZlDrVE4E0Ku0f02XpG1GKVV2rU1pAAhAOJYFzahF0R/vLMwASCZi0pzrbEar4tIVwX4pndpvIYASjlqZuEW3L58fQsNfBeh4nZLkbVLpYkYkiLR4nRHpbDkCLjJH6a7mYUt/oPqSjYGBABa389cjeFh+2qDinEXSegTuOcgiGKjfIiaRwuL3Q/gwMFfZ/ZsRxoGTfCm3U4J1DaINt92GGU3ECowIEaIWqQA5ZdjVDP4YCqinYthN+UGzyhCsM0+oTvom6pyZEGBvoy/ItAM+M+LWNLRXl3JB0S0fPmMNLo9C6P693bZ1PA+vZ29D3ayzRkQtP+wPpqb84WFwxQBU/KBf1lMBndVChodmUG15Da1xqfAfKQZZwyCkWtJlK805EYtDBEZeIVhJQ4r3XQW84cBMHuEkisaJEqefDaevqRE0tQcfjpkOc2O8J0jbooV6IpuPUJ00vMzOfr6hzuHrQr53ctQ9tbHaGXmtPtf1gI0c9/0g/mzBXd13aY3IBBuEGPj/6CDrzSrSh/2KS2p0+VNOteY0oWrsum1BxoLvdQfcEa42d0nkIIcQO42X/A8KsoEvb3pXG8j9ekWiwtCo+gtlzXf/KhgSouv39YxA8gECvR+Ow2QxDSRQ11HWLrpUXWJott/cfglCvUW73NM2xROUQvHEvv
 zokwviP8
 +b5Ux0ZSX1+fPQ0W77H3aB2T1myHvUC9pxSjBWWo6CcfJ74ii0HqE/yyVv7AmJNchO6dKHakF4Njh65OJowGT4i1W+5rK025y86mxx8o90pNnMROfZfKTi20oVG/zlRYJRdG11KdfVYWKkIJ6Dbby4coSM487XkoYu+Oz62AEaPaiBbWsFI82tvZk4OtAxtgDoBAATmohjtMeY3qCFlTeIG8gy17iUhaOwbGiJrHo9ZZTS4ukteYqs7IVIEm+iQjgn36kLv6wL/llK2eihdzdAvBlvTzXXCiy5QGXrr7DQovjoXfxaAXp6yAZjIYezclof09ZimMlz6iaK9oYsGWzRoDTlx747zkgi7AabM3RLJSJoJmJsc0Oz/HPiZ+2lMeu7Xo8sjJ5gJLnIXeOf9Bm+dqToZnv5Zgt2/plrmWOf94GrAwBnDkJ1fljG/ByDSZZWJr/43GoXKE6TQdx2m2J6a7xAhX0YEhzcA1XcfTklyFymDfSQ6DcdCdFXXQesISxXObL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maximilian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08]

url:    https://github.com/intel-lab-lkp/linux/commits/Maximilian-Pezzullo-via-B4-Relay/mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop/20260304-153052
base:   af4e9ef3d78420feb8fe58cd9a1ab80c501b3c08
patch link:    https://lore.kernel.org/r/20260304-mm-vmstat-reject-zero-vm-stat_interval-to-prevent-busy-loop-v1-1-c03c9555ff15%40gmail.com
patch subject: [PATCH] mm/vmstat: reject zero vm.stat_interval to prevent busy-loop
config: parisc-randconfig-002-20260305 (https://download.01.org/0day-ci/archive/20260305/202603050819.oMnaHoIC-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260305/202603050819.oMnaHoIC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603050819.oMnaHoIC-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmstat.c:2117:12: warning: 'vmstat_interval_handler' defined but not used [-Wunused-function]
    static int vmstat_interval_handler(const struct ctl_table *table, int write,
               ^~~~~~~~~~~~~~~~~~~~~~~


vim +/vmstat_interval_handler +2117 mm/vmstat.c

  2116	
> 2117	static int vmstat_interval_handler(const struct ctl_table *table, int write,
  2118					    void *buffer, size_t *lenp, loff_t *ppos)
  2119	{
  2120		int ret = proc_dointvec_jiffies(table, write, buffer, lenp, ppos);
  2121	
  2122		if (ret == 0 && write && sysctl_stat_interval == 0) {
  2123			sysctl_stat_interval = HZ;
  2124			return -EINVAL;
  2125		}
  2126		return ret;
  2127	}
  2128	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

