Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311D3CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 22:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600C28E0030; Thu, 16 Oct 2025 18:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8408E000A; Thu, 16 Oct 2025 18:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514CB8E0030; Thu, 16 Oct 2025 18:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F8838E000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:28:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D620113B032
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:28:49 +0000 (UTC)
X-FDA: 84005418378.14.6C4F741
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8BF61C0009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:28:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fr3Ib8E1;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760653728; a=rsa-sha256;
	cv=none;
	b=6kdF88BXOZFyvACvsAiPQerl1lotjae33h+lC6Ut1EtDtniHFeMyIsRaczfh7c9QdMIBsX
	nc62Zm4wMf/dC4yCWQBxnyWKAE6KAcq23mOq4vih/6SO6ogCCc/dEW6OzKqh4NBLcyuoFf
	NfWWeljZjFGmwwGxssG5REnOkg0elM8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=fr3Ib8E1;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760653728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nj9+IfJZF5APVuTp7YjLZ/pdP+otEkyyNxER/NRZbH0=;
	b=I2PUgKyXE6wwOqxQ/R81OM2s6gZgx1A8eI1RT4mXJJifMCiL8+tOU0o0VhwztRwJEsjMzq
	dmM/pbvfqHXvXdJWGsg65pGl4EJYQVJ1eifdUMcJl82mk2uFKjgec+dnTZAb5iyNBQ5VJI
	zIZoUlaHRrdT+QWdNWUtqWWaeSAjWxE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760653727; x=1792189727;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ciKQIk52+iRfgjCWilAdkX6YNbNDCJyfo9BtEuwQYqQ=;
  b=fr3Ib8E1DPpXXyOHBgiXMvGqvT9LCUULAsCtbtZcqdiy+P6+7lzQIY8n
   rIZ366anklcImXwRDM6vSV+ReH/FRwBM46hQWE0xALQM498u+TorXuMUM
   Vw4hImJZv3U1MXGN5qLj4PJlaHO+gyn4ngOWp4O1pUsacn/zo7s63M4Fq
   ifDyvc0c4HS0s4iWfX7O28EJ4auJI6eio2KkwYZ64fZPo11vt7K7tse3R
   HkIuYNLv5SVWdsanpR0QJ5GvmmRZLxYEm4JC1McyfGXPrmGDsBlLGsHJR
   7uBT6RgFftAEcjEaNdMY+fjVDbAkNqKzqN64xSFZmxUJKjf3fnjHdQcSF
   g==;
X-CSE-ConnectionGUID: j7epWjiSSd+d2dxF6BK5fQ==
X-CSE-MsgGUID: Ztn3KxRMTueEUcHMq1Lwug==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62071724"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62071724"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 15:28:45 -0700
X-CSE-ConnectionGUID: /2MsaDmgTJmh3x2o1fWcuQ==
X-CSE-MsgGUID: 4Xm1/v/rTaScrK/tKgO49Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182132113"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 16 Oct 2025 15:28:41 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9WSd-0005J9-0C;
	Thu, 16 Oct 2025 22:28:39 +0000
Date: Fri, 17 Oct 2025 06:28:31 +0800
From: kernel test robot <lkp@intel.com>
To: JP Kobryn <inwardvessel@gmail.com>, shakeel.butt@linux.dev,
	andrii@kernel.org, ast@kernel.org, mkoutny@suse.com,
	yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org,
	akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
Message-ID: <202510170654.s2j4GuCs-lkp@intel.com>
References: <20251015190813.80163-2-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015190813.80163-2-inwardvessel@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 7tigw5xw51x1cfypeuqi6nbf4i1apbmn
X-Rspamd-Queue-Id: E8BF61C0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760653726-764768
X-HE-Meta: U2FsdGVkX192/jXeMNoqewEaOXtVT+EEAA7mG078U71YbHPitCq4eQzuWLApL/Di2RpDlDJ+eisJ+0SkG8i68o5N4bOryMtBVnqCNHTRJwxwv9IYr0RBMaIssLgrsk3TH72hoCTJzoyHOZW0LdWwbM7PH3mp4OsjuKvuVuraxs79IMKqeR95JbXtcZlMIW7sAKFbGdSvcaQNij9G7rUZn+tZolhEEurYr9fDAB1f8oNSFwuKCiPuRAG8tvL6ekzuMftapwrPXT8ygYNNiwRRhaoECq8lyJslDAkk0Hc2LLL1UXnqrvSH0MzvRdyEWdO2VXxB1EeqzTx7tzmrYi7aJVFS2gRVmMP6EHwLwdUnttCeFcA0Ypbvitq9FQzdlPgdR62AIxOXY/xC/YO9HwJdJMucVtuRiAme5h36P9FSY3iUzvQEfErhHFmE0knn1Ix++pnYUKfxekFHoGi9Bxp2JErxIMVb0nqPT/bhWHdhqnRxFNXw82oAcMsZYWru5HLXGFjFVdFnj6giOhVfDjT+xeIajhvdU2p5rrOdRj/IUWYgZNs6BwQsDsLwQ2q5Vcd+/tPFzdNrfHrkBpbC6UGTl6BBuuF5jcMBcvKeYazZB7vclIwWVDqC/G72nHzRlnIE0OKfllP2LR2UPT3Qsbn53x+gZhjsccwV2y3xGUTsYxdeOhoAYgwjJLYxyFTgs/zY6ubJFdIUO1+b3iy+YVUHZJWGkC65NWiZmc71o6mZ4qi/8sZ2x+tDmwFOnl/5WSf8m8GEWfY93/ZalO4Lb9n2TuGTSxD0Nw/+Ib6I4D7Hf6x0rhv9UmxJiDouftp1+kuAz2NRkTzbcwJOFzzZtJs3NWYrw0C4NaKvJ8GAlX1vYXNyJgIQlKwWFgcb1IsFASUY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi JP,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bpf-next/net]
[also build test WARNING on bpf-next/master bpf/master akpm-mm/mm-everything linus/master v6.18-rc1 next-20251016]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JP-Kobryn/memcg-introduce-kfuncs-for-fetching-memcg-stats/20251016-030920
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git net
patch link:    https://lore.kernel.org/r/20251015190813.80163-2-inwardvessel%40gmail.com
patch subject: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
config: x86_64-randconfig-121-20251016 (https://download.01.org/0day-ci/archive/20251017/202510170654.s2j4GuCs-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251017/202510170654.s2j4GuCs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510170654.s2j4GuCs-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/memcontrol.c:4236:52: sparse: sparse: incompatible types in comparison expression (different address spaces):
   mm/memcontrol.c:4236:52: sparse:    struct task_struct [noderef] __rcu *
   mm/memcontrol.c:4236:52: sparse:    struct task_struct *
>> mm/memcontrol.c:876:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct cgroup_subsys_state *css @@     got struct cgroup_subsys_state [noderef] __rcu * @@
   mm/memcontrol.c:876:55: sparse:     expected struct cgroup_subsys_state *css
   mm/memcontrol.c:876:55: sparse:     got struct cgroup_subsys_state [noderef] __rcu *
>> mm/memcontrol.c:876:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct cgroup_subsys_state *css @@     got struct cgroup_subsys_state [noderef] __rcu * @@
   mm/memcontrol.c:876:55: sparse:     expected struct cgroup_subsys_state *css
   mm/memcontrol.c:876:55: sparse:     got struct cgroup_subsys_state [noderef] __rcu *
>> mm/memcontrol.c:876:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct cgroup_subsys_state *css @@     got struct cgroup_subsys_state [noderef] __rcu * @@
   mm/memcontrol.c:876:55: sparse:     expected struct cgroup_subsys_state *css
   mm/memcontrol.c:876:55: sparse:     got struct cgroup_subsys_state [noderef] __rcu *
>> mm/memcontrol.c:876:55: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected struct cgroup_subsys_state *css @@     got struct cgroup_subsys_state [noderef] __rcu * @@
   mm/memcontrol.c:876:55: sparse:     expected struct cgroup_subsys_state *css
   mm/memcontrol.c:876:55: sparse:     got struct cgroup_subsys_state [noderef] __rcu *
   mm/memcontrol.c: note: in included file:
   include/linux/memcontrol.h:729:9: sparse: sparse: context imbalance in 'folio_lruvec_lock' - wrong count at exit
   include/linux/memcontrol.h:729:9: sparse: sparse: context imbalance in 'folio_lruvec_lock_irq' - wrong count at exit
   include/linux/memcontrol.h:729:9: sparse: sparse: context imbalance in 'folio_lruvec_lock_irqsave' - wrong count at exit

vim +876 mm/memcontrol.c

   873	
   874	static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
   875	{
 > 876		return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
   877	}
   878	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

