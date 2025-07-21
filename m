Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D77E2C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78EB86B009D; Mon, 21 Jul 2025 19:36:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765F66B009F; Mon, 21 Jul 2025 19:36:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3036B00A1; Mon, 21 Jul 2025 19:36:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 548256B009D
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:36:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DFD811D8E5A
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:36:37 +0000 (UTC)
X-FDA: 83689883634.07.FBC1155
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id C31BB100006
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:36:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CqxNo7/1";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753140996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kp8g9LzZiiD8KsqNcNJnQGCRp67TTybO6GLmtquzemY=;
	b=iKaeuoI26ByIdq7l1FC7VXtHbxTFocp2yjAFAdT+ulWM2dMEKELkrK6GQPaPox8AVdQzdY
	qf+r/7FTwufHafXMHrsUwPhCpnttYEXtFDerZVzp0FGSj+SYhntxReG4n51dGzGJYQO6jf
	R1YGvsngDFhqYz4xWdzQSee1y8UcZBs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753140996; a=rsa-sha256;
	cv=none;
	b=3LqyekjbkdKOlQaeqvgi/FQ3+BNx6HybXxQeJ/Z3nCpTP7MqXY9cGF1VBd56PwoZN9sXv+
	zwhz6RrWWdTNW7xMI4Pfb3SPBr4orn5uYjKDPkOMGXtWJr7nalQXMonzC1wFjIiJaetfax
	vCPYX1yEvEYNs4ZtQ7htvvX7agIuU8E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="CqxNo7/1";
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753140996; x=1784676996;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Wsiho+ou8o5+XfQj6UuVq2Xs9UbBNM8jUtUD5ORmnu8=;
  b=CqxNo7/1VYs6NukjpMnScljIQB/FnnxAZ+PIjnmdza9f5ToPVqOTP6Rn
   EWawYhC2z7K2rdrTTxSQr45cpAHJLLenNH10iqLmlJxxlNSzl69dZjV1k
   0qmIuf4ZZIkrkYb0ADOIsa4OkSqWrZx/yVypONYuNGABlPLamvesNYh4o
   cX9IsbGAFfZ4LWZ+PfPDwWksP10UILTLJBfcsiQlcpqdt+MYEVRU3+Gqc
   TsuwYSqtrSDPE9uiwro2MyM2XkjlwyDJEZMWQXK2EpXucl7GaFJaCqmRN
   Iskz5uoO2BWojx45z8GYV0UOIGknLzqJmD9xIEJMXq87gi/xn3kKalWbp
   w==;
X-CSE-ConnectionGUID: oCXU8kF6QMuZD3knOguGIQ==
X-CSE-MsgGUID: chXUmQMTSWaZP2/77tKbpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="55485703"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="55485703"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 16:36:35 -0700
X-CSE-ConnectionGUID: qgVbYK5ZR4aaYVNEf0xivw==
X-CSE-MsgGUID: 9vPRKyWBTzyvIusO0YFNzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="189923475"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 21 Jul 2025 16:36:33 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ue03a-000HFS-2V;
	Mon, 21 Jul 2025 23:36:30 +0000
Date: Tue, 22 Jul 2025 07:35:40 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [linux-next:master 8632/11398] mm/page_alloc.c:6773:62: sparse:
 sparse: incorrect type in argument 3 (different base types)
Message-ID: <202507220742.P3SaKlI6-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C31BB100006
X-Stat-Signature: juk137r1x6xpiehzw6jsy5a3jeowpru5
X-Rspam-User: 
X-HE-Tag: 1753140995-58091
X-HE-Meta: U2FsdGVkX1+gVUOqc+W+G8Z1a1Z3PWc+/NiSF/1r6Bx3gCTwbwdOkOF89iELlEZZFQ9uegGYQV8DESuX/dAoQahqT6sco/k2Egmx8jFUN4t9AD9DKwRrYruvQLICOgtlp5/JLn3q2QcqH8FsmJGrP43caLXLEhALl9CP6ssGeOCOp1jkDbjxy20mX/o3MiJHuDJq8bcZiDI8mQivE5lcJ6sb/ZcfVGVpreIYQ+sVfJcg7kNZthPh8NDO42aR6leDa+CTNmjNqilInV/TfoYrs0HN8Irnd45KF+NdUiycS+rBwNTEIVPGN6W3O6boev9s18bhc5zoZtcxnLI1bJsntuAcYuaeqALxB5VDlEDiyMgxcg7LS7a4YvDRHVOCq5P+9J36gdLKY4/AHKVGgL2eedU+yyR02zBKkByHbwG390zUYrJ1OiAvyDPK0TGxjO5ioG1YfFYgx7RHP77IaWP957Ji+tyHJO6o8yCNylTV0C9mQx5BXqBM/ndm2UbOn5vvOUywN9Gh6XoKIKAXETt2Z+l06ikQVCDyqL66pzAFieJkcA8Ef8yVVkgbLnOjrcIndwh+P6F2qzimfHGZjJMyC7CvFx4Qsta85HsVq3NK0iW5W4tZEhShGJSnLxkvXdlkmsJtGTy/w5EgQymo6sut8/jsZpVK0dTSUhS6CXQFaNLbp/Gs6ZehRvp3ID/8Hg5yLJbTfBkbQ3/jmsruIJXmrAzge3D4t+QasOCQ/+ZKsOH4rirzccUBVSyKeSY+6Fpopb1rkSSbKwBLP7iR0+hk7PePxfs6KMRMmmPYuei/CaA4qSvKVPwIaPLOv1JHDfHG6R1LVGmU6HOLZjV+vtVDkCkVG3ToItdSbYDCUG6bBg5Rra7eT/zKFt9P7zzRbbamyAU1OYjBuhpWJC/30ggPX4VuyByR5IMF4QB9xCu8HWJqu+uV9NNAYrDQWvAnqR0RTYqFgS0cQ/QbPqNnZta
 utcBjmQM
 c6UPndhzzoyQRluXhe0fBMVbKfKM7qiQRDl/6drnnhr3dEZiYLILI0YIMPTRyyaFxTwAYg351rASoQje1QABKUunFguDmFZoUbBvoIL6FZ8oijUqaPjLyfeHB/3dJq41ivKA2rq97Ly2a1yOmipVIpHdcS6uNlB78oCXEGMrAXKajjN+wfB3gfIsh4gt8LoXZ8pcqZBs0hdxog/adLuKTlLCw8c9Pk7EHAi6LfBSLc16u6K2hSoTQOgJh3n2P3UMQWMkBfBc2BomHO0UiFlX9pM2ZsHo4hdLlPq+qPM/SAER33tKzZeDoC22VnhV1hHIBZUN7tPj/Sv+8Kpo+fv3RU2pPUP9UdgVUCEow4baPlnCOFeJRs3ZiXnkk3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   97987520025658f30bb787a99ffbd9bbff9ffc9d
commit: d1554fb6302093d353c8bf4601f9bf994b836904 [8632/11398] mm/page_isolation: remove migratetype parameter from more functions
config: arm64-randconfig-r132-20250721 (https://download.01.org/0day-ci/archive/20250722/202507220742.P3SaKlI6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce: (https://download.01.org/0day-ci/archive/20250722/202507220742.P3SaKlI6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/page_alloc.c:6773:62: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected unsigned long nr_migrated @@     got restricted acr_flags_t [usertype] alloc_flags @@
   mm/page_alloc.c:6773:62: sparse:     expected unsigned long nr_migrated
   mm/page_alloc.c:6773:62: sparse:     got restricted acr_flags_t [usertype] alloc_flags
>> mm/page_alloc.c:6776:50: sparse: sparse: incorrect type in argument 6 (different base types) @@     expected restricted acr_flags_t [usertype] alloc_flags @@     got unsigned long [assigned] total_mapped @@
   mm/page_alloc.c:6776:50: sparse:     expected restricted acr_flags_t [usertype] alloc_flags
   mm/page_alloc.c:6776:50: sparse:     got unsigned long [assigned] total_mapped
   mm/page_alloc.c:1526:13: sparse: sparse: context imbalance in 'free_one_page' - different lock contexts for basic block
   mm/page_alloc.c:2520:12: sparse: sparse: context imbalance in 'rmqueue_bulk' - different lock contexts for basic block
   mm/page_alloc.c:2878:13: sparse: sparse: context imbalance in '__free_frozen_pages' - different lock contexts for basic block
   mm/page_alloc.c:2981:33: sparse: sparse: context imbalance in 'free_unref_folios' - unexpected unlock
   mm/page_alloc.c:3271:20: sparse: sparse: context imbalance in 'rmqueue_pcplist' - different lock contexts for basic block
   mm/page_alloc.c:3143:13: sparse: sparse: context imbalance in 'get_page_from_freelist' - different lock contexts for basic block
   mm/page_alloc.c:5099:9: sparse: sparse: context imbalance in 'alloc_pages_bulk_noprof' - different lock contexts for basic block

vim +6773 mm/page_alloc.c

  6693	
  6694	/*
  6695	 * [start, end) must belong to a single zone.
  6696	 * @alloc_flags: using acr_flags_t to filter the type of migration in
  6697	 *		trace_mm_alloc_contig_migrate_range_info.
  6698	 */
  6699	static int __alloc_contig_migrate_range(struct compact_control *cc,
  6700						unsigned long start, unsigned long end,
  6701						acr_flags_t alloc_flags)
  6702	{
  6703		/* This function is based on compact_zone() from compaction.c. */
  6704		unsigned int nr_reclaimed;
  6705		unsigned long pfn = start;
  6706		unsigned int tries = 0;
  6707		int ret = 0;
  6708		struct migration_target_control mtc = {
  6709			.nid = zone_to_nid(cc->zone),
  6710			.gfp_mask = cc->gfp_mask,
  6711			.reason = MR_CONTIG_RANGE,
  6712		};
  6713		struct page *page;
  6714		unsigned long total_mapped = 0;
  6715		unsigned long total_migrated = 0;
  6716		unsigned long total_reclaimed = 0;
  6717	
  6718		lru_cache_disable();
  6719	
  6720		while (pfn < end || !list_empty(&cc->migratepages)) {
  6721			if (fatal_signal_pending(current)) {
  6722				ret = -EINTR;
  6723				break;
  6724			}
  6725	
  6726			if (list_empty(&cc->migratepages)) {
  6727				cc->nr_migratepages = 0;
  6728				ret = isolate_migratepages_range(cc, pfn, end);
  6729				if (ret && ret != -EAGAIN)
  6730					break;
  6731				pfn = cc->migrate_pfn;
  6732				tries = 0;
  6733			} else if (++tries == 5) {
  6734				ret = -EBUSY;
  6735				break;
  6736			}
  6737	
  6738			nr_reclaimed = reclaim_clean_pages_from_list(cc->zone,
  6739								&cc->migratepages);
  6740			cc->nr_migratepages -= nr_reclaimed;
  6741	
  6742			if (trace_mm_alloc_contig_migrate_range_info_enabled()) {
  6743				total_reclaimed += nr_reclaimed;
  6744				list_for_each_entry(page, &cc->migratepages, lru) {
  6745					struct folio *folio = page_folio(page);
  6746	
  6747					total_mapped += folio_mapped(folio) *
  6748							folio_nr_pages(folio);
  6749				}
  6750			}
  6751	
  6752			ret = migrate_pages(&cc->migratepages, alloc_migration_target,
  6753				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE, NULL);
  6754	
  6755			if (trace_mm_alloc_contig_migrate_range_info_enabled() && !ret)
  6756				total_migrated += cc->nr_migratepages;
  6757	
  6758			/*
  6759			 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
  6760			 * to retry again over this error, so do the same here.
  6761			 */
  6762			if (ret == -ENOMEM)
  6763				break;
  6764		}
  6765	
  6766		lru_cache_enable();
  6767		if (ret < 0) {
  6768			if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
  6769				alloc_contig_dump_pages(&cc->migratepages);
  6770			putback_movable_pages(&cc->migratepages);
  6771		}
  6772	
> 6773		trace_mm_alloc_contig_migrate_range_info(start, end, alloc_flags,
  6774							 total_migrated,
  6775							 total_reclaimed,
> 6776							 total_mapped);
  6777		return (ret < 0) ? ret : 0;
  6778	}
  6779	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

