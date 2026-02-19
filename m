Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7ECE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 10:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C276B0088; Thu, 19 Feb 2026 05:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FB86B0089; Thu, 19 Feb 2026 05:02:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5DE76B008A; Thu, 19 Feb 2026 05:02:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF9336B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 05:02:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A8301C552
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:02:39 +0000 (UTC)
X-FDA: 84460766838.19.A185DDB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9A9B84000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:02:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jfYE+UXf;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771495357; a=rsa-sha256;
	cv=none;
	b=oV5RPEAidWLiCtZBwr7jqAytRMklviZEOB/hHG6A3IJPdrQEgna5ekog1soHo7tM6qFuw/
	YeSRqEpE1eSEgx2ZLnNyChSUV7g9G5iFXiR+3vKg4DXS4RdNjwtTmLdzS4b40DgzMvRBKA
	OP/vo03YUT9tKhqL9kF1YPBpd+l2hvQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jfYE+UXf;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771495357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cf4KhqSHDGwtvvxD0o8qW/6Q8X7bP2buKsBwfeR1Rac=;
	b=ab1zR+q79cTDm2kgonZeJL+jEJZBLdPxEQuA2ou+p4AHhQWf+eH2uV05n9C+XIhRkGC9pI
	WR7c4EbPcM2CkWY2D2IDIuspnX9IRPdspdPfPwGe3JxiibFMLadWGELklUtFfHC4/ZnR8x
	QM5Gec8je3gHzmCFUCE2PsNMUDrK9/w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771495356; x=1803031356;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZIySGTOKZjo5uD6GuM1RfNj9BJy2RdMmuIZWaUktJ4o=;
  b=jfYE+UXfT7NYbxWcRcHvROJmjHL04p9bMzw1lkh0LzxepIXxg7lSzSsL
   zQGdWQRj6xEQwlhBqiCWaukH/VZfikKyaXUhMSJnWUnDXxsJZGC9j3/yW
   H7EMod9cb1HwWpomy3JU6aAe0d8l6hU7y6WKj5aBenx7f8QGNu1bPJ4zn
   b5h9lv9hw2WgsuEsHK+Sh1SP+De6I3RtLraoRUqmCKtnJMVMOtx77KJqc
   wmAe/YjsqG2CKc7TdeMV/PzMTqNlrC8xPpaQHO1BZRkPpQ7Dq20AyM0Aj
   /6km1vOWkE8oaw23qa1UodqrD4OHV15SzVeoJLWHaWrVYhJqPxAHXZqOh
   w==;
X-CSE-ConnectionGUID: SXLa8fyKSBSbiAKnpD7hPw==
X-CSE-MsgGUID: JdxtKqYbQ/yz6JWwRdRdbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11705"; a="82902060"
X-IronPort-AV: E=Sophos;i="6.21,299,1763452800"; 
   d="scan'208";a="82902060"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 02:02:34 -0800
X-CSE-ConnectionGUID: yVQKBcOHQKa5qE7QL6FLVA==
X-CSE-MsgGUID: /33pId8jSpWDFgIe5csG+Q==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 19 Feb 2026 02:02:28 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vt0rZ-0000000136e-37xd;
	Thu, 19 Feb 2026 10:02:25 +0000
Date: Thu, 19 Feb 2026 18:02:17 +0800
From: kernel test robot <lkp@intel.com>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>, linux-mm@kvack.org,
	mst@redhat.com, mhocko@suse.com, vbabka@suse.cz
Cc: oe-kbuild-all@lists.linux.dev, apopple@nvidia.com,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
	eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH v3] mm: move pgscan, pgsteal, pgrefill to node stats
Message-ID: <202602191719.7nkLTJOP-lkp@intel.com>
References: <20260218222652.108411-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218222652.108411-1-jp.kobryn@linux.dev>
X-Rspamd-Queue-Id: 9A9B84000A
X-Stat-Signature: dcc1xnujxzorp5afzzd3h7mpwgndw5sj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771495356-187150
X-HE-Meta: U2FsdGVkX19JdqzDsnydpH9/ADBcs/OuuFVmNc7Rs4MGCMMOWF/ovztUpsyWNzU12A8Ei4/gDmbmt64bj4LY/BJXniHYgH1bpn4UONPGjSWEs9XfmiberQq+1mP+IphZXQ/AWib7b0gG3e3oPorCp68UXoxaNc32SOnlBWeCfQhpjqWSAS5r+F0uh+iKD1R96SgKSPZxv5OospDhwJ8YovgdJ65gPteddscigzXzDFQiMmfAqUEo9fvcIftBPy6bikQOeHRGxtnxJNokpPe87Wno/04t925aTKxSn3l5MbPdUQhX7UmlLamYKV3jIgtUBD1o9Gm+0pez7u/NHdYKm3iRd+Dc2pz0DvXWytiREp0cKMoYesbqaKv41iyE7unkuqQ8kCjtzNPRwy1damqj9+3Q2IjSUPoixZdhJfkrQrf4p2+rd5tWuqyO+1Xa3c32WDb6LEin7eLzLCG2Yjo3j9LbAE6byT3Ss91zGhxt/VNq+W0xPI/s+TgjvAyCMyv4LmaenCX/vRwNFBBElN0rezimgXqWA99mVL7/gaSyJ1Qv/NXa5/cOMKA4qP5FJK1DOahsQGZBxGtmDMonLrOOJ+tiVKeTtpN1NA7Y978VVpfdC0my5m8jV9PELlpCLmRZBM1cqhd7EchtGsKeYrYVg/+XPdNZMhxtNm34dceQB/whwOu3uneDPUNOeU1oq94PGsARm0imjMID7z0VupqBA0mY6BGEqbm6dz01/b9NRUZtsl9SAnkwBbPmceUmGS5lf6Ka6SMrPhCB7slDd2Ix9ULJ6tBD8bzVPotJ2hHZ7vzETKPACW9WzLjFBUTei99EbuWxU48jZjqxhvbP3B44Y74mQI4P84aTl/yMkZdMs+vdwwlmkmYiLbXSSRapdcRW6BnYuFBh3BKpVAV+TVtuGuN7hQ7CEodtmgkZiCjENkQ6AYdEu2bVMZyzNzp1RKdqnW4Xi7uGYGZeg3YxWJr
 EejOvXB7
 PwXDEnxA/KWSF1RAIdIRfXglMdrD7qfZBmI+coQMT19lDbhZeHQTCCAulDfGXGQgFg88bMcyrgQNpIoa7E9Er8oHeqKjfTl4DOKn4Ap0O+wNmA0bMnXWHQ+fUoA7UPIhqgDA9iR0nmRzMgIBXVcNk96FgiWgZervAIlZNOaJsQDA9uMeFGfrDPSPpqRjmuW2d/5pfyB6LuWC0E/3lX7qSiW9BoRBT1calgyzCWb8+l+WaaoyBqs3df5gLeoRAVIR76mj+OhtjuhUcd5f8kDetnpwGXPl72ESIQVhGqqedIDAXaWJU8dl+7cULnyK3DMy8O63IGsk0JaugvDEomP/5uWAl+RTWJ4LONvQPZ0kM3xBtIG0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi JP,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/JP-Kobryn-Meta/mm-move-pgscan-pgsteal-pgrefill-to-node-stats/20260219-063016
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260218222652.108411-1-jp.kobryn%40linux.dev
patch subject: [PATCH v3] mm: move pgscan, pgsteal, pgrefill to node stats
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20260219/202602191719.7nkLTJOP-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260219/202602191719.7nkLTJOP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602191719.7nkLTJOP-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/vmscan.c: In function 'scan_folios':
>> mm/vmscan.c:4542:28: warning: unused variable 'memcg' [-Wunused-variable]
    4542 |         struct mem_cgroup *memcg = lruvec_memcg(lruvec);
         |                            ^~~~~


vim +/memcg +4542 mm/vmscan.c

ac35a490237446 Yu Zhao        2022-09-18  4527  
af827e0904899f Koichiro Den   2025-05-31  4528  static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
af827e0904899f Koichiro Den   2025-05-31  4529  		       struct scan_control *sc, int type, int tier,
af827e0904899f Koichiro Den   2025-05-31  4530  		       struct list_head *list)
ac35a490237446 Yu Zhao        2022-09-18  4531  {
669281ee7ef731 Kalesh Singh   2023-08-01  4532  	int i;
669281ee7ef731 Kalesh Singh   2023-08-01  4533  	int gen;
b0e9e710c6bb5a JP Kobryn      2026-02-18  4534  	enum node_stat_item item;
ac35a490237446 Yu Zhao        2022-09-18  4535  	int sorted = 0;
ac35a490237446 Yu Zhao        2022-09-18  4536  	int scanned = 0;
ac35a490237446 Yu Zhao        2022-09-18  4537  	int isolated = 0;
8c2214fc9a470a Jaewon Kim     2023-10-03  4538  	int skipped = 0;
49d921b471c513 Chen Ridong    2025-12-04  4539  	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
49d921b471c513 Chen Ridong    2025-12-04  4540  	int remaining = scan_batch;
391655fe08d1f9 Yu Zhao        2022-12-21  4541  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
ac35a490237446 Yu Zhao        2022-09-18 @4542  	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
ac35a490237446 Yu Zhao        2022-09-18  4543  
ac35a490237446 Yu Zhao        2022-09-18  4544  	VM_WARN_ON_ONCE(!list_empty(list));
ac35a490237446 Yu Zhao        2022-09-18  4545  
ac35a490237446 Yu Zhao        2022-09-18  4546  	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
ac35a490237446 Yu Zhao        2022-09-18  4547  		return 0;
ac35a490237446 Yu Zhao        2022-09-18  4548  
ac35a490237446 Yu Zhao        2022-09-18  4549  	gen = lru_gen_from_seq(lrugen->min_seq[type]);
ac35a490237446 Yu Zhao        2022-09-18  4550  
669281ee7ef731 Kalesh Singh   2023-08-01  4551  	for (i = MAX_NR_ZONES; i > 0; i--) {
ac35a490237446 Yu Zhao        2022-09-18  4552  		LIST_HEAD(moved);
8c2214fc9a470a Jaewon Kim     2023-10-03  4553  		int skipped_zone = 0;
669281ee7ef731 Kalesh Singh   2023-08-01  4554  		int zone = (sc->reclaim_idx + i) % MAX_NR_ZONES;
6df1b2212950aa Yu Zhao        2022-12-21  4555  		struct list_head *head = &lrugen->folios[gen][type][zone];
ac35a490237446 Yu Zhao        2022-09-18  4556  
ac35a490237446 Yu Zhao        2022-09-18  4557  		while (!list_empty(head)) {
ac35a490237446 Yu Zhao        2022-09-18  4558  			struct folio *folio = lru_to_folio(head);
ac35a490237446 Yu Zhao        2022-09-18  4559  			int delta = folio_nr_pages(folio);
ac35a490237446 Yu Zhao        2022-09-18  4560  
ac35a490237446 Yu Zhao        2022-09-18  4561  			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
ac35a490237446 Yu Zhao        2022-09-18  4562  			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
ac35a490237446 Yu Zhao        2022-09-18  4563  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
ac35a490237446 Yu Zhao        2022-09-18  4564  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
ac35a490237446 Yu Zhao        2022-09-18  4565  
ac35a490237446 Yu Zhao        2022-09-18  4566  			scanned += delta;
ac35a490237446 Yu Zhao        2022-09-18  4567  
669281ee7ef731 Kalesh Singh   2023-08-01  4568  			if (sort_folio(lruvec, folio, sc, tier))
ac35a490237446 Yu Zhao        2022-09-18  4569  				sorted += delta;
ac35a490237446 Yu Zhao        2022-09-18  4570  			else if (isolate_folio(lruvec, folio, sc)) {
ac35a490237446 Yu Zhao        2022-09-18  4571  				list_add(&folio->lru, list);
ac35a490237446 Yu Zhao        2022-09-18  4572  				isolated += delta;
ac35a490237446 Yu Zhao        2022-09-18  4573  			} else {
ac35a490237446 Yu Zhao        2022-09-18  4574  				list_move(&folio->lru, &moved);
8c2214fc9a470a Jaewon Kim     2023-10-03  4575  				skipped_zone += delta;
ac35a490237446 Yu Zhao        2022-09-18  4576  			}
ac35a490237446 Yu Zhao        2022-09-18  4577  
8c2214fc9a470a Jaewon Kim     2023-10-03  4578  			if (!--remaining || max(isolated, skipped_zone) >= MIN_LRU_BATCH)
ac35a490237446 Yu Zhao        2022-09-18  4579  				break;
ac35a490237446 Yu Zhao        2022-09-18  4580  		}
ac35a490237446 Yu Zhao        2022-09-18  4581  
8c2214fc9a470a Jaewon Kim     2023-10-03  4582  		if (skipped_zone) {
ac35a490237446 Yu Zhao        2022-09-18  4583  			list_splice(&moved, head);
8c2214fc9a470a Jaewon Kim     2023-10-03  4584  			__count_zid_vm_events(PGSCAN_SKIP, zone, skipped_zone);
8c2214fc9a470a Jaewon Kim     2023-10-03  4585  			skipped += skipped_zone;
ac35a490237446 Yu Zhao        2022-09-18  4586  		}
ac35a490237446 Yu Zhao        2022-09-18  4587  
ac35a490237446 Yu Zhao        2022-09-18  4588  		if (!remaining || isolated >= MIN_LRU_BATCH)
ac35a490237446 Yu Zhao        2022-09-18  4589  			break;
ac35a490237446 Yu Zhao        2022-09-18  4590  	}
ac35a490237446 Yu Zhao        2022-09-18  4591  
e452872b40e3f1 Hao Jia        2025-03-18  4592  	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
b0e9e710c6bb5a JP Kobryn      2026-02-18  4593  	mod_lruvec_state(lruvec, item, isolated);
b0e9e710c6bb5a JP Kobryn      2026-02-18  4594  	mod_lruvec_state(lruvec, PGREFILL, sorted);
b0e9e710c6bb5a JP Kobryn      2026-02-18  4595  	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
49d921b471c513 Chen Ridong    2025-12-04  4596  	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
8c2214fc9a470a Jaewon Kim     2023-10-03  4597  				scanned, skipped, isolated,
8c2214fc9a470a Jaewon Kim     2023-10-03  4598  				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
1bc542c6a0d144 Zeng Jingxiang 2024-10-26  4599  	if (type == LRU_GEN_FILE)
1bc542c6a0d144 Zeng Jingxiang 2024-10-26  4600  		sc->nr.file_taken += isolated;
ac35a490237446 Yu Zhao        2022-09-18  4601  	/*
e9d4e1ee788097 Yu Zhao        2022-12-21  4602  	 * There might not be eligible folios due to reclaim_idx. Check the
e9d4e1ee788097 Yu Zhao        2022-12-21  4603  	 * remaining to prevent livelock if it's not making progress.
ac35a490237446 Yu Zhao        2022-09-18  4604  	 */
ac35a490237446 Yu Zhao        2022-09-18  4605  	return isolated || !remaining ? scanned : 0;
ac35a490237446 Yu Zhao        2022-09-18  4606  }
ac35a490237446 Yu Zhao        2022-09-18  4607  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

