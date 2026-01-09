Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC8A8D232D1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 02:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77526B0005; Thu,  8 Jan 2026 21:24:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EFC6B0089; Thu,  8 Jan 2026 21:24:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95CC36B008A; Thu,  8 Jan 2026 21:24:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8478A6B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:24:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4655C1AB73
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:24:43 +0000 (UTC)
X-FDA: 84310832046.06.CE8CD99
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf07.hostedemail.com (Postfix) with ESMTP id A6DD240005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:24:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lawQ+N1C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767925481; a=rsa-sha256;
	cv=none;
	b=iXp2tybv25poowFGsNuvIn/XRXn75ZM+mp2z7XNWZb5NCtSVcLv7xaeE/6VdNRCMctyXsL
	xiEUgHacbbwtAwnUaUUi7fEOvEhcD/1hOJQqvZPakHeVwCnoR3t7b9VG0IiUoGASzyIku0
	MGR2gxwy8pV6TEzfi9ZuQ3c6PSmy88U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=lawQ+N1C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767925481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=wc9Ry/+z0B8fdPNAEzjTbrzoNDQ532ZonOXMhGFKItk=;
	b=0E2M9SoxJTqFf3zZDxbrIULJvydQ99YAJ4eJaLDJP86RIlaDklTm8nmhid1tJ1N104Em5M
	q/X0dEZaoMlKOkiNruEZkLi4hjmZ3k8m3m/TdGd6spUWZMI0UVD16H5pOCiCs7sOT4pzRg
	nrU1Rjpf55iAuh26Fj+U1fxBeRCMgk8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767925481; x=1799461481;
  h=date:from:to:cc:subject:message-id;
  bh=lQ4GGjt0Rj3i0mrurqMR6fqMwzGvomMJPo78swHAmzc=;
  b=lawQ+N1CN7WMhKyftfiD0Jn+m5M7HlJKfxNlDIgdKA7Tw94+3wVwS6ry
   LRQaYtYK8stdKstPBPRoXVI1Yitx2p+kUBGLS645CdE9P00MqSHrZvzRk
   qHA3+DKj2tNzQVgkk1JgKJ3uTZfeOQZX0ijvFuXnn7Hq+Zs1TKwfZuMhM
   531BIHd9dLsVUVPuthVPNl26Gx23pJoiEkxkQYP6MgthiGrJSQfd5LXqO
   E5WToTjni/L51t6J8YpLghK6wtECtttVBXjuw9wiaSBcywqXoO8BX4l3e
   bxdaObiOMDvme8vJwCUzf0IwqGgqm16bzFmznVLFXRxzOSJqyDIUJt0uc
   Q==;
X-CSE-ConnectionGUID: EQAeens9TYKgaYJNDozuUg==
X-CSE-MsgGUID: 9febi4OwSDSeKw/lbsTFDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69384679"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69384679"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 18:24:39 -0800
X-CSE-ConnectionGUID: aaUwJGcGQkeQo8yW3hsZsA==
X-CSE-MsgGUID: jdjLckdMTwuSmtf3ZCoP2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="203387294"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 08 Jan 2026 18:24:37 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ve2Az-000000005Ka-3wjx;
	Fri, 09 Jan 2026 02:24:33 +0000
Date: Fri, 09 Jan 2026 10:24:28 +0800
From: kernel test robot <lkp@intel.com>
To: Bing Jiao <bingjiao@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 259/263] mm/vmscan.c:1046:6: warning:
 variable 'target_nid' is uninitialized when used here
Message-ID: <202601091037.vUSHeJCH-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: qyf67ub7bnw3dczwwidz4ymp8r47sunt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6DD240005
X-HE-Tag: 1767925480-781654
X-HE-Meta: U2FsdGVkX1/yBn0v28mxUEVM5IjNGhU8cQzIhT0So4AWnIHwg+Uzr2BDh17dXGImgQpe3yAghQuXx49bCcT4HfZf4rYRi9eD/ypAKkCWSJzcWrWC4VNcXg/RZk8VMJL+4hK0isgDcjRBjqk0RbCO9nMwwwUIaA2eF3iGuUxO2kwaYVlhw3LG1XKkHJ//IWZcczl+HP3XJvLORcK5YQm+Vpich2z9eDPS8Sq/tH4PCepVcHY5f91A+fMvT+7pc68DmHoQeFouS4TxkhGSltP7SteFNF7b+0ithd9UL0SrYXrHrnRvKBQgCtpDuuiG49SjUanCTlaZ3XB2ru+80k/SuggRBc+NO+HjFj1/cyJH9fVSpuZ2ReSJQKlY2N7H0OHoyYymze35huk+/f5VjzpRp0nH+eSoozW9WtK94DCd0vRFB6DouXVKQLtlv6Y5fAhNusbfYIRx6T6WAUFAv+wDuGoGTuOyabURVFwGMYK1WwnTSooWczu9GZAfWAIolOkod1No6BS4/E4tezdTc3OtS4/2GM2v7iTWX/exDKqtOQ4TYHKjF726Zu4/pgWtFB4GJPW4yBEewsx/wrzTem8dYk45w8mmboq0MgmskChww19sKwSsqT6DKShSfnm57RcW5opZY9wM6FYP8P2ZLdOAkHQd8+pNjDOFODtDLE40g3vTkGR0mu/R1KQ6xZsnMS1Yt8CtfVGxkXA3UpBfRu1ZbE9B/IUY9YQKqwAluCKfcZnHJ0SHINU1qiAPnrHZ8IfCGivI/OG6mf/arqS9hSoWBq3J6xIZpxhAcW2nps5FtUQdkAG6o+K7m+5AmJ2uXY3sDi/G/63JPKHK7UuckNEH6K3Uwdu0mZ8H3CYXF+21UkDcwGVDC9LVYTax6gszxPtkdfsokQ365adQAD5sVY1A2RmHkKbrtY0k12LNu+cr3YYcEltdwdjg9dMzhFKsXHjTkhOizesLLm/QG5LNd/K
 NXUWN/FT
 oLHEKYzOfpITnYHRdDEW18juZvrL1TUTIh5k4GT4PAZXkIq1BV4wpCgCyC1x9BOw86W9Wb4sD2GvMyGdKfMpr/fYbOicK0g5kNLqnnj/62Yqf2LgQEIGztr/Z9T83StWWqasl69EF8DoW/YUiDBjLzy4h4ctldFJdDUMhrHLP4JY7XFxi72Z2ycJ3W+nvsS20stb9ElK1LJ3vCAUpsurNw1ypUA4t0dhU68MvGH/Jm3GwGmRfSt6dA63z6CnBM56vXW9SCoTETSLKpQXRlTmiB/SGWJngB0LHfQDlJrhmAYP8GfVBioEcMLPnUgfebPyM9OE8casXjTvEkgEab8aBL/wxDlUBzSiGXvoY/u3OWZ4di1KYtKWYA2Eny+ZcZKS9B1Db
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   ba756a5e4580859e0b26f6679d882f81935a7b14
commit: d92027a5f30a6c5c582169114b1e56d6536ca8f8 [259/263] mm/vmscan: select the closest preferred node in demote_folio_list()
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260109/202601091037.vUSHeJCH-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260109/202601091037.vUSHeJCH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601091037.vUSHeJCH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmscan.c:1046:6: warning: variable 'target_nid' is uninitialized when used here [-Wuninitialized]
    1046 |         if (target_nid == NUMA_NO_NODE)
         |             ^~~~~~~~~~
   mm/vmscan.c:1026:16: note: initialize the variable 'target_nid' to silence this warning
    1026 |         int target_nid;
         |                       ^
         |                        = 0
   1 warning generated.


vim +/target_nid +1046 mm/vmscan.c

26aa2d199d6f2c Dave Hansen             2021-09-02  1017  
26aa2d199d6f2c Dave Hansen             2021-09-02  1018  /*
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1019)  * Take folios on @demote_folios and attempt to demote them to another node.
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1020)  * Folios which are not demoted are left on @demote_folios.
26aa2d199d6f2c Dave Hansen             2021-09-02  1021   */
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1022) static unsigned int demote_folio_list(struct list_head *demote_folios,
059c4bb2dc3b93 Bing Jiao               2026-01-08  1023  				      struct pglist_data *pgdat,
059c4bb2dc3b93 Bing Jiao               2026-01-08  1024  				      struct mem_cgroup *memcg)
26aa2d199d6f2c Dave Hansen             2021-09-02  1025  {
d92027a5f30a6c Bing Jiao               2026-01-08  1026  	int target_nid;
26aa2d199d6f2c Dave Hansen             2021-09-02  1027  	unsigned int nr_succeeded;
32008027289239 Jagdish Gediya          2022-08-18  1028  	nodemask_t allowed_mask;
d92027a5f30a6c Bing Jiao               2026-01-08  1029  	nodemask_t preferred;
32008027289239 Jagdish Gediya          2022-08-18  1030  
32008027289239 Jagdish Gediya          2022-08-18  1031  	struct migration_target_control mtc = {
32008027289239 Jagdish Gediya          2022-08-18  1032  		/*
32008027289239 Jagdish Gediya          2022-08-18  1033  		 * Allocate from 'node', or fail quickly and quietly.
32008027289239 Jagdish Gediya          2022-08-18  1034  		 * When this happens, 'page' will likely just be discarded
32008027289239 Jagdish Gediya          2022-08-18  1035  		 * instead of migrated.
32008027289239 Jagdish Gediya          2022-08-18  1036  		 */
bd63d0fde2a2c3 Fushuai Wang            2025-10-06  1037  		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
32008027289239 Jagdish Gediya          2022-08-18  1038  			__GFP_NOMEMALLOC | GFP_NOWAIT,
e42dfe4e0a51b4 Baolin Wang             2024-03-06  1039  		.nmask = &allowed_mask,
e42dfe4e0a51b4 Baolin Wang             2024-03-06  1040  		.reason = MR_DEMOTION,
32008027289239 Jagdish Gediya          2022-08-18  1041  	};
26aa2d199d6f2c Dave Hansen             2021-09-02  1042  
49fd9b6df54e61 Matthew Wilcox (Oracle  2022-09-02  1043) 	if (list_empty(demote_folios))
26aa2d199d6f2c Dave Hansen             2021-09-02  1044  		return 0;
26aa2d199d6f2c Dave Hansen             2021-09-02  1045  
26aa2d199d6f2c Dave Hansen             2021-09-02 @1046  	if (target_nid == NUMA_NO_NODE)
059c4bb2dc3b93 Bing Jiao               2026-01-08  1047  		/* No lower-tier nodes or nodes were hot-unplugged. */
26aa2d199d6f2c Dave Hansen             2021-09-02  1048  		return 0;
26aa2d199d6f2c Dave Hansen             2021-09-02  1049  
32008027289239 Jagdish Gediya          2022-08-18  1050  	node_get_allowed_targets(pgdat, &allowed_mask);
059c4bb2dc3b93 Bing Jiao               2026-01-08  1051  	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
059c4bb2dc3b93 Bing Jiao               2026-01-08  1052  	if (nodes_empty(allowed_mask))
059c4bb2dc3b93 Bing Jiao               2026-01-08  1053  		return 0;
059c4bb2dc3b93 Bing Jiao               2026-01-08  1054  
d92027a5f30a6c Bing Jiao               2026-01-08  1055  	target_nid = next_demotion_node(pgdat->node_id, &preferred);
d92027a5f30a6c Bing Jiao               2026-01-08  1056  	while (target_nid != NUMA_NO_NODE &&
d92027a5f30a6c Bing Jiao               2026-01-08  1057  	       !node_isset(target_nid, allowed_mask)) {
d92027a5f30a6c Bing Jiao               2026-01-08  1058  		/* Filter out preferred nodes that are not in allowed. */
d92027a5f30a6c Bing Jiao               2026-01-08  1059  		nodes_and(preferred, preferred, allowed_mask);
d92027a5f30a6c Bing Jiao               2026-01-08  1060  		if (!nodes_empty(preferred)) {
d92027a5f30a6c Bing Jiao               2026-01-08  1061  			/* Randomly select one node from preferred. */
d92027a5f30a6c Bing Jiao               2026-01-08  1062  			target_nid = node_random(&preferred);
d92027a5f30a6c Bing Jiao               2026-01-08  1063  			break;
d92027a5f30a6c Bing Jiao               2026-01-08  1064  		}
d92027a5f30a6c Bing Jiao               2026-01-08  1065  		/*
d92027a5f30a6c Bing Jiao               2026-01-08  1066  		 * Preferred nodes in the lower tier are not set in allowed.
d92027a5f30a6c Bing Jiao               2026-01-08  1067  		 * Recursively get preferred from the next lower tier.
d92027a5f30a6c Bing Jiao               2026-01-08  1068  		 */
d92027a5f30a6c Bing Jiao               2026-01-08  1069  		target_nid = next_demotion_node(target_nid, &preferred);
d92027a5f30a6c Bing Jiao               2026-01-08  1070  	}
d92027a5f30a6c Bing Jiao               2026-01-08  1071  
d92027a5f30a6c Bing Jiao               2026-01-08  1072  	if (target_nid == NUMA_NO_NODE)
d92027a5f30a6c Bing Jiao               2026-01-08  1073  		/* Nodes are gone (e.g., hot-unplugged). */
d92027a5f30a6c Bing Jiao               2026-01-08  1074  		return 0;
059c4bb2dc3b93 Bing Jiao               2026-01-08  1075  	mtc.nid = target_nid;
32008027289239 Jagdish Gediya          2022-08-18  1076  
26aa2d199d6f2c Dave Hansen             2021-09-02  1077  	/* Demotion ignores all cpuset and mempolicy settings */
29ea04095b9697 SeongJae Park           2025-06-16  1078  	migrate_pages(demote_folios, alloc_demote_folio, NULL,
32008027289239 Jagdish Gediya          2022-08-18  1079  		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
26aa2d199d6f2c Dave Hansen             2021-09-02  1080  		      &nr_succeeded);
26aa2d199d6f2c Dave Hansen             2021-09-02  1081  
26aa2d199d6f2c Dave Hansen             2021-09-02  1082  	return nr_succeeded;
26aa2d199d6f2c Dave Hansen             2021-09-02  1083  }
26aa2d199d6f2c Dave Hansen             2021-09-02  1084  

:::::: The code at line 1046 was first introduced by commit
:::::: 26aa2d199d6f2cfa6f2ef2a5dfe891f2250e71a0 mm/migrate: demote pages during reclaim

:::::: TO: Dave Hansen <dave.hansen@linux.intel.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

