Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A29D232D5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BF56B0088; Thu,  8 Jan 2026 23:35:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39C86B0089; Thu,  8 Jan 2026 23:35:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C366B008A; Thu,  8 Jan 2026 23:35:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDA06B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:35:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE4B81402EA
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:35:23 +0000 (UTC)
X-FDA: 84311161326.13.0862F56
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf07.hostedemail.com (Postfix) with ESMTP id 76CD240005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:35:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eQ2QLpAy;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767933322; a=rsa-sha256;
	cv=none;
	b=6XTEPpBGVLKs08+k76Z2qzY200mi8G3lwuBOs1MFtnYh5pfHuQZRS36KNFjizclc0ucM29
	j4Y48vqJILTrstNxeyehpDxkxHA3vOZ/YyKWYivS3qX9exCWJvEUxjUaGXFgXMqIOjZsqw
	Bx15ZeKcLa3FsMt7I+dAwUtVR3tJ7rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eQ2QLpAy;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767933322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=WYNq6ZPOrCpyY82vNa7lG3lWYBIEADkvw8c3ADtdru0=;
	b=6bX+lkmG+6rHjtAGEQhjx/jrtOSIj/UdvHhjOUkUULFeJV5LTH0fZdXHelpwcRaCibvVv8
	QJuU9P5FjEmE6EBnHmmodcopmQjb//V5cgDQV9aZmijq9SQZ2i0SY4H86KwU/ZcfkjqkLi
	oOsPsJxszlLgvkKHpUi7GjDjEBcK9k8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767933322; x=1799469322;
  h=date:from:to:cc:subject:message-id;
  bh=AQVrbWesm+Xpz75jwdMSqr5lIi4++FrnOyDZfe1IlBA=;
  b=eQ2QLpAyDBaYoLPCyPIjOMbwGrvB/5Jn9fkCILP+Ll85LVagxOJ+FkVO
   F0/otqou1VrGdmxgHd2KNttBWumkgwp3e/dml/fua2jnQAJrkU/bD+tV1
   2xkuUjlhE+noTgGsf8gpyp68xJaZz45b7S+CBijoFXtZrrb4VxuzYcJtk
   vKrLk33wQq8SFNvDJyW8WX8hjATUwB0fwfDqXEDlXt/vwPXaMKITuBa0M
   ECFexy0rVaIrgj6TXj8/8iI3tuWIxsWLy/6K+xvtnC2zU+oE3zmG393rm
   Su060rHOC69AqS339ryv/lV7Yoeotv3m8bmR1s8JHFq9CykPEkZrw8NNk
   w==;
X-CSE-ConnectionGUID: Tgxx6wA2StC1Lhv7HUbN/Q==
X-CSE-MsgGUID: WUq8CsZpRxGBK5yckc8s0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80424596"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80424596"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 20:35:20 -0800
X-CSE-ConnectionGUID: Zdx5cAszSJO1rz+sIucS8Q==
X-CSE-MsgGUID: IPnlsukmQcig7z3lfGrpMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="234088854"
Received: from igk-lkp-server01.igk.intel.com (HELO 92b2e8bd97aa) ([10.211.93.152])
  by orviesa002.jf.intel.com with ESMTP; 08 Jan 2026 20:35:18 -0800
Received: from kbuild by 92b2e8bd97aa with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1ve4DU-000000001ye-16JP;
	Fri, 09 Jan 2026 04:35:16 +0000
Date: Fri, 09 Jan 2026 05:34:28 +0100
From: kernel test robot <lkp@intel.com>
To: Bing Jiao <bingjiao@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-new 259/263] mm/vmscan.c:1046:6: warning:
 variable 'target_nid' is uninitialized when used here
Message-ID: <202601090508.cVHh3bJo-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: biek9cyz7i13obfdfjik1ow7zypqnwui
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76CD240005
X-Rspam-User: 
X-HE-Tag: 1767933321-125565
X-HE-Meta: U2FsdGVkX18OdctdLPWM50CeIwb4hLK++h8GqtKEiBH1bxjOel3Op/mHiMwdQNBbWXCDiScjSfPPazIw5WUcDnTrNSBIlpk9FLQqNeNiQxucaViu5GQjx/BJftuJxEod9qv/EYDXokAKQapOv2y8IYSbjTYEJTtOfsRhojcl8tEnGjefRAgLi7tAyUKVBTJqOB+txy1MB8rzEKxNbrn+Vylqn5evAMFVuUZu0K8xH4OzSzJgh6cAfPKBkIT3+q9ywc+44KEp7pCBXxJdV3xT2fZY8VZiosPt3M7yBVFvNEX1BG5XbZO/uCx+r3thmJ9f1TOsoIh4JK1v/9OlDtjhFmJ4LHAezKKeJlQbehrs6a7ShM0cAve6lXE1SD9O24Hfbtym+5qIWmvoIv1HnAyQ+QcKpr3a5UCZPj7iFah/XGl2VZWNH9PNikEIw++aiO9I2N0BtDYikNFFiWka4wBL6vnSefbdBLvBuUfDurvNMXgHinwYBtBJBw1GDVQq7m5HyfaYmUqSeYgU98rPOVXlGsnlB7uAeqaFgkl0N74Lpc646MeBVNaBWHUniAs3c7zPhnvH8/ksei+e2AcBF6arfRsVwJZwYi8RxalXp/7yDPO+HTjMQ6IqBV8UhrvuFNF3z+/qqLLJQDpX+D6QLCRf/wD89UC97yUTOF5Kn090EjtLql1eu3YO+AFcT5u+U7cCv5AwZHNCK/YIPtnfj31yaFtzmNBYFPw5e3uJQZcE8e8M28Kd25aBn1AHoCu3Jkj91QITVV0X7c89TED11o/0S9O1ASSjBWtV7SJVGBf7/OUuPxzQtoHVcX6galA6ZhkoaTk2Jr9+K1ef3zvAGF1BUw4K0LBv0O9h/CNrap3tItU1I/+rnEye1wrdTr4yYyzbXTYwsnyt7iKH3qAQh+K7u1iOMD4mmFEjedskYJFlIuObYZzGJyy7oTC4KyON4DsYIasETAMbYkiLCXfQ2f/
 AkdXlKwC
 ukNq0B8ENqeYfLsc4o2ZPEvOFnzQjpC9KdVTyDiM7xAsHvKhPFX1dyFecvwdBxVJZq1ufJo7b7UkCqLwzeAcJJb3tTeUS+xoAaP9WapoYGoGb+Q1ZgJ0sWAfvzVr+0dqumXs9v5Mt61O9+zhaEoPbfl4L92P16He0Oi82Fd+C34fi34LOfBuS+l4IdPSpvUlQypx3yiGLWWXtRF7MTCDtaAkH3AcgjSW0r3ZqrPevoizr2xpmUNVqLehR+W9iC/6WHFTwuYK7lXNZyVA997qubHXLynzsgMcYFVkY9T7a+EHAjT8nBzmCjga3J3fS5XKuX/rhFe5x0DC8v+kF4GwfIouTWA44hwFUQXmO8ZbcRYG5ddCiC0m1bdgKDdSpAw9wPWwl
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
config: i386-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260109/202601090508.cVHh3bJo-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260109/202601090508.cVHh3bJo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601090508.cVHh3bJo-lkp@intel.com/

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

