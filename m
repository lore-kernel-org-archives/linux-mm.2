Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39F8CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 10:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835426B009B; Sun, 24 Aug 2025 06:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5B46B00B5; Sun, 24 Aug 2025 06:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4C06B00B6; Sun, 24 Aug 2025 06:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50B726B009B
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 06:59:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2599BBEBC
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:59:45 +0000 (UTC)
X-FDA: 83811355530.11.DAC88CA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf12.hostedemail.com (Postfix) with ESMTP id 01D0F40004
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:59:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jtKYRjJG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756033184; a=rsa-sha256;
	cv=none;
	b=6nxfCMvUf/5fmFPw5iCm87MlaCnhI0ScYsjeW9/Japr9xHTalTsIHOio5eYX3E5sgFoIJZ
	KO2TB0MtvujZYLxKlbb8ZKxZ9hzH8gJb9H1VM4fsteDvRDFHc7rrSWSlEHlxED0Qa7JWac
	GMo78A+THg7CVAdi+CvqSB4DH7ca9iA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jtKYRjJG;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756033184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yOowplzVG9nXMdEOni7fVfTsx2ez+9jgmELGuniqxl0=;
	b=CCAeNznBs527zda/nHTTbwJWdNoQ2P8r5Ez7TLwiyCJoqoFzVMVDDARLkv7JktbscNU4QV
	xlsO8Hng/ox3m16wfCz78ZVBNsyqdNz+BD/X+E9IqknfcorpL8G/UCjC46TQvSEXbBITZV
	+5xud9pOD9CEs0axjTPfhb7emUzjPOc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756033183; x=1787569183;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=F0lWeHRbdG/4Nlqj7hTHDy63+PkTIai8BN9s+1ojUZU=;
  b=jtKYRjJGcOiJ/oWsKeSV8J9YqGy26vb1rds1+U+PzYhnGsMJyVcXWKj2
   862HCFbLw/dvQXUdFM6Jr0lEkb/957WPmXAceAy9LowzzpGa4w6z5Jq15
   YzwUmy2DDSJ16GsGnQ5iJXhFFTKqMCtHQdIx+C418bNNUcraEQA4Nt8bM
   k0/M5W4TD9XgnT4h5YLn3pJ9VB3AC9zJetA05QeIozsnCaDnsGMHU4kiw
   L5dnn49BmOp3iAzuvHLunb0u0H0RpuxhSMvR0uTj5ica7I2ad2WalhLWc
   INJtbOFTSXvK017lfaibZGTrfxdkluWGwtPl0NNC7BoEQy4++09eDDueu
   g==;
X-CSE-ConnectionGUID: mAuvsORBTnKmDLFJryNTbQ==
X-CSE-MsgGUID: sEFST+PcSkm+OkD3127wJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="45842670"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="45842670"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2025 03:59:41 -0700
X-CSE-ConnectionGUID: rQRz4ha9QDaP+C9BtzTEHw==
X-CSE-MsgGUID: esxzoi6OQQKNh2gBmJmnqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="168577898"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 24 Aug 2025 03:59:39 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uq8R4-000MxD-1c;
	Sun, 24 Aug 2025 10:58:57 +0000
Date: Sun, 24 Aug 2025 18:58:07 +0800
From: kernel test robot <lkp@intel.com>
To: SeongJae Park <sj@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Quanmin Yan <yanquanmin1@huawei.com>
Subject: [akpm-mm:mm-new 237/249] mm/damon/paddr.c:193: undefined reference
 to `__udivdi3'
Message-ID: <202508241831.EKwdwXZL-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 01D0F40004
X-Stat-Signature: cxgtsc96z4gknwjstwms6p9aag98mzba
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756033182-622754
X-HE-Meta: U2FsdGVkX18XMCdgnp2vLw/uFKq8g3gDh08OKHzNXcIzyYkHuUBeka+yTRpUuB6f3Z2JrvX+ypiJKMYRRaz0JwkxgY33c4gltX86CPjetoVXVh4zYJcQEzplqPjlwYK/NwXWN8SaEk0szWBAzwaVsW15y5CPdCpSPasfOsZqaIjE7AaowVDl1TwAOCFiMcFebY61Xom7ZlozQNqRazRkuTOPpgs64jmx4sQkIHZ1yl/05Ggfkmyy7Iuz83rTtpy/oBYt/T4FhOiBp4tMmuGeesS973dOR/2ko7tolhhYMLiIAkBIs0sc0So+3xF+bA2YTfhCYqk5VqBo+XdIyPeDGRiPdOlazj2BViVNp9hhGzzUfhT82xg4adrhP5igIHQEGfae+7UEvrNdy6XiniHJBNqNXivhMByLpHv8PKeHfB1F3yyPPJbaEdlReN60mIhNTSTIZ8x6pypQyIw+R/cXWeLpfEWDOhyTR40zzWMpiJdimdBJWaSklvICbdFRF+56O0P590i8sRMkhI1VlcKPIPm6nvhyN7bamgnR6lgVhBtGarKbJNDUfK8t4UVowjdmTPttTAo545RDoOfqJL3224uwvBXpQk/9PcsrPOgdPoO1h7HkroJw8TpF2VZT4RM12MsIJCqsOdbJHvmRfGKTvfD+MsFNMMFpIIL3IUZeyBtzogy7hCubqQZ4PXAIlfgHYp4nU8taITXOu77pRrxA4+5KZ6SaX15cuRO/f9FGbY1Bf6vQIHolq/lOP/tTMZAy05E5cn/HN3BYQQSXe/55YL/ewPCI/m2NwewcmI/ppuHlssXuNQx3YrnX5KlhN4wRME0258+HTauS9304zE9wMHq0sDT38tDKlOhaMMMaI5z7UFmZe+syhHqh/sCUG8jYSQy/wMvMwOxmxkDsRvGySRKXKtSgMqWccOhKNsb6//U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   fad61af0eb8692a522c1f75241e36d405249cebd
commit: 9c8b46a2965cff89ee6d5025ab95a83ff1d59826 [237/249] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
config: i386-randconfig-052-20250824 (https://download.01.org/0day-ci/archive/20250824/202508241831.EKwdwXZL-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250824/202508241831.EKwdwXZL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508241831.EKwdwXZL-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: mm/damon/paddr.o: in function `damon_pa_pageout':
>> mm/damon/paddr.c:193: undefined reference to `__udivdi3'


vim +193 mm/damon/paddr.c

   137	
   138	static unsigned long damon_pa_pageout(struct damon_region *r,
   139			unsigned long addr_unit, struct damos *s,
   140			unsigned long *sz_filter_passed)
   141	{
   142		phys_addr_t addr, applied;
   143		LIST_HEAD(folio_list);
   144		bool install_young_filter = true;
   145		struct damos_filter *filter;
   146		struct folio *folio;
   147	
   148		/* check access in page level again by default */
   149		damos_for_each_ops_filter(filter, s) {
   150			if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
   151				install_young_filter = false;
   152				break;
   153			}
   154		}
   155		if (install_young_filter) {
   156			filter = damos_new_filter(
   157					DAMOS_FILTER_TYPE_YOUNG, true, false);
   158			if (!filter)
   159				return 0;
   160			damos_add_filter(s, filter);
   161		}
   162	
   163		addr = damon_pa_phys_addr(r->ar.start, addr_unit);
   164		while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
   165			folio = damon_get_folio(PHYS_PFN(addr));
   166			if (damon_pa_invalid_damos_folio(folio, s)) {
   167				addr += PAGE_SIZE;
   168				continue;
   169			}
   170	
   171			if (damos_pa_filter_out(s, folio))
   172				goto put_folio;
   173			else
   174				*sz_filter_passed += folio_size(folio) / addr_unit;
   175	
   176			folio_clear_referenced(folio);
   177			folio_test_clear_young(folio);
   178			if (!folio_isolate_lru(folio))
   179				goto put_folio;
   180			if (folio_test_unevictable(folio))
   181				folio_putback_lru(folio);
   182			else
   183				list_add(&folio->lru, &folio_list);
   184	put_folio:
   185			addr += folio_size(folio);
   186			folio_put(folio);
   187		}
   188		if (install_young_filter)
   189			damos_destroy_filter(filter);
   190		applied = reclaim_pages(&folio_list);
   191		cond_resched();
   192		s->last_applied = folio;
 > 193		return applied * PAGE_SIZE / addr_unit;
   194	}
   195	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

