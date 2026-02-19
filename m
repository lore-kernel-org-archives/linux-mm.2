Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79AE1E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 13:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55576B0088; Thu, 19 Feb 2026 08:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A031E6B0089; Thu, 19 Feb 2026 08:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4936B008A; Thu, 19 Feb 2026 08:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7782C6B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 08:10:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1ADEB8BFC9
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 13:10:50 +0000 (UTC)
X-FDA: 84461241060.16.2488C9D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 32DC1120005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 13:10:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jeaFC665;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771506648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWhqAYrqfQLWG98hJqw5F1xa3WPJF+yKGe0WWcDlChY=;
	b=42VLpNMXSeAjTv1zXI988+oCPIhHLVgwxOzgJQGpHprrL4J48c+aO5TNwlS0Zitq8LhsxS
	UHSF4e18/HJKzeKW0qQObXQXunxbp50g7XrdlfIvGV8rsvBvxS30U1/7xFhDox+Xu3MnGH
	Rvo6+Eowv/qxku/4caXMQJQWAS9o5pw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771506648; a=rsa-sha256;
	cv=none;
	b=enBs+6R7B0zEC/5xDEEWyWkmpCVgtztpSpfouEb4D5HXny/CH5GEv0sB5LvJFXyt8rwQbQ
	KlLFpOLsmwBEueNMHXv5tzlNj4xoDZgf4CuZW1oN8AtOuQWP3m4SxH17TLDBIlSoTWF+M+
	OuOoOmkVu4wbXGnh/24j+ilh/HLICng=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jeaFC665;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771506647; x=1803042647;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+ASt9RW3S8U9bMhrhcg5P9CXnzpEpApS+qGIkng/w1I=;
  b=jeaFC665rwFs3oGI4Yb1Ek/AL7HQ1M3f+R5FQIvQwiF7DzS6HFN4lOkR
   SutSjRq4x3AqyLJTo5jgee4yIhD09kwkMgZHGTdTraMFwK0ttgRqiVWsf
   uUhFp7x3ruJtatWvA6cqo0PvNiaUgYUbdSgPUjQQ0X9/w/eqBXPDcXHR3
   0KQKvrageTSPhKu4itZus50w2vjtWiMDCIxtyMES7YokGOACeSHGeAAPh
   IAPb+3nazcariYtJf2fHa1Ix1Enw87FaDbmq0Nlvv52sR7pUePNx4VbHT
   wMl7bZCMvYhOOrA+A4orzawla+Hdx927F9nbjQRnEZ2ruafNg2mP3A2Ww
   Q==;
X-CSE-ConnectionGUID: QCw9qLGYS4OWKYDfm5/mTg==
X-CSE-MsgGUID: 4CrmUBXjSu6dqqBj/SZ2pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="82914201"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="82914201"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 05:10:45 -0800
X-CSE-ConnectionGUID: NHFBFnBWR4uJA67vO80HYg==
X-CSE-MsgGUID: jVog3KgkTsunK42T2C/5Ig==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO e5404a91d123) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 19 Feb 2026 05:10:39 -0800
Received: from kbuild by e5404a91d123 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vt3ng-000000003yL-3aSU;
	Thu, 19 Feb 2026 13:10:36 +0000
Date: Thu, 19 Feb 2026 14:10:08 +0100
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
Message-ID: <202602191417.23zH3uja-lkp@intel.com>
References: <20260218222652.108411-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218222652.108411-1-jp.kobryn@linux.dev>
X-Rspam-User: 
X-Stat-Signature: a9cw5cc7jpckgdenrjc9nm1kqmtfdx1u
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32DC1120005
X-HE-Tag: 1771506646-524957
X-HE-Meta: U2FsdGVkX1/dolcUelNWvce4WdpaRCtSwEz6Q0iRSOyz7wmjSVrKi3x0jww4BhH8GKkTRDwFp7fU62eCndURJdgKPMAvU8zsKjoSwKithkHSE8w2rUqyRCvvMetd5bwTk9GZ1h8lI1/3ExsO8Hw0ik7YpHqG78wpL1p7MOKoV6dMBrP6Y5eIr8cJgcIs8SINlRpJL45xSyc0uar5JvFPNPtpO6Z8yQ9gS0z7rnC5mISKp1euvcdgqN5jPKD5JMaAw5ubPGvh4DBA3D7m6uaP5grEIUSkJRo0zUhL+sefoKzD7R26CF8LSuxiJuVKcEnE7rk9QVl7uM7tq9E8bkSPM+nOFLWZMNfydRp3E8SbV6zW0I8r+noc/2q8mZA1mq8Oh/jaZNYbdQlKnpBRR2e+9avLsru+n+nJ444Nt/jYVzreN5nkxbifyUvktlkkqsAiEoieZ57e/TigIAsVBrM4cgj3NgtIMcJjV+335KwVQYDbo0JLkUsT3I9rsdyIOz/kQssjMQNEUcx3xjiD4EjILgzkqt+MtSK8BcagV54raMURJTU7ti/xxwZ83iUdh8TjzFrI0RwSl/3Fx0YAxyUd8S8IEBAVLKXuE4hKqoJ9urNb8G8oMkHk2bH/Dclrtjy+evJ3wWM8NbwEdCRawaWH4wI7bKWZvF2JnVRvG+HJmvsC4eGZvx89LrRVFouwOEGlAD0HgqZcxYndCKfXSyZrg6zC8gPbpytX33mcquPon4NAg2dgNtd2IfKEYYLqLyjPz/dbXlcwbXJj2Qw/QYHz2A8o8GMQDmvB4GGQ7kWX0eZiVKuR2mmGmTkd/da9/9XEY12XLbYwQ8D7Is6OOI/sko4wPPSUJ/WqJaFOWm+eycApycHMrHrYN/CDGbCnV9yi8oe+DlCthu61a87DSmFZYaZvw72PLxCm5MkoRJb8+vGupyGT+AQhUdTih45Xq/V2ftIS7E5nTKhxu4tRmSC
 GQOPrFln
 FgiD1J0VCnFz1LHh2HaTwUfFJdI3kXfSRw+A3hyCTjPHK0YeeoyG4n54/ERQbRWfwMFln6rS7i9mhn6sHwGUxzjng3yIF6iSnXK/V8F7MkDUmKXhFoXpXUFXC4hLsT1LGB8Rexe7wWoL+l/BpfT+nsiTaZQE52aTVK+P/540+YaDhtcCfZoRc6lXjrfV63UBsMpWX3dpSJ4GPlwNQ8d2l2K40QnMOYfguWPvtqBXYll0suYf3vcUQHQ8UPsoFwvM8n3ijHyBbqU5l2ywlxNloV5bCdbKzBeG4l0bgb+apkWaow4cdMs1ElrcAZ6QdaXN78/BaOMFGdLr/qcP0yTNEyqYaK5OWwdbk2eiwnaECqEVJh+A=
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
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260219/202602191417.23zH3uja-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260219/202602191417.23zH3uja-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602191417.23zH3uja-lkp@intel.com/

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

