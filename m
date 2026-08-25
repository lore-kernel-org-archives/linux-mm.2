Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A27C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7259B6B00BB; Tue, 25 Aug 2026 09:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6846B00BC; Tue, 25 Aug 2026 09:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6153B6B00BD; Tue, 25 Aug 2026 09:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9E76B00BB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:30:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5EFA3C0403
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:30:23 +0000 (UTC)
X-FDA: 85139875926.09.4FF74E9
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id 97FC71C0007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:30:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U0GU8Aap;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787664621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ffr61aL56KgBLt/J6XPN0BmtDpJCqOJr3brUaXaDkBk=;
	b=vMPm2tQtgzGuH2rKu8PEXvJfzv3VPgqRD5vG+CfblGGmpTDisYt9pMEhp8WoiqJ394+VjR
	r3J3Zxi+WRHphh90hDDpMafvaY2tW7qXFcUdn7aeavM6WWz4ZTckFgRFQxqkPizQospLnX
	hnn5MgiaL3QyPIq9mKtbs3DoLwrum1Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U0GU8Aap;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787664621;
	b=aHNgW7AGFp/QhuiLMvmzQauafAeoygdqLOAqgfCQejqNPbb1isFWdZdCds7YrjAgB/0g25
	aPY9eA8F+LxL6vwR2h1tc3xT7nb9uJsC7I71OzCZtNXu3UiquzdohFZ1UbV2fFnZ8ecOjz
	RM4AwhIRxtkk8+74QJ6jYycfyijNb0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787664621; x=1819200621;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c9Nacj099i9lPcssMyGzzh2RUKgFpgy/wc1032AQhHQ=;
  b=U0GU8AapE0o6UDZVDjSEvY9qMW/u89HOVXnUql32TSHkH7MG+/qYcciU
   qAuAOgRH6rn+5CH6X2Ip5gJif/XN13/mwWQhIzRy/mBNcFn77Mjspq4pU
   FSqvru/5xRyJ732QHjKO4Mfowa3bqIAyFk1zxIqJw8lNgJ5TQDT6KJOUH
   maxCW/VLWVWX6maIAoq9KrMt5jL+AiOUDdHbtpG6gXxHyilmiKVJAsYMe
   3ZFuRqWfVKPy0YsQ53pxAePXNRL557wOZJmDt3SY6sE2RAsaLXqSeT8DD
   xancmLXeyKDdatCfUKDw0U9AnwhD5jHhGOdswB6kB3orfwJIiqWL2o9Ps
   g==;
X-CSE-ConnectionGUID: PeswoGXwTDq0UGFxfZ4yZA==
X-CSE-MsgGUID: JN4IV2EES7mct92XUpvwdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="87895808"
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="87895808"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 06:30:19 -0700
X-CSE-ConnectionGUID: MEWBwBDZRsa/qt+torgjBg==
X-CSE-MsgGUID: 9HFvW8+aQ0+q20RIrypkow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,242,1779174000"; 
   d="scan'208";a="267857094"
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 25 Aug 2026 06:30:16 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wyrEC-000000005uV-3vgb;
	Tue, 25 Aug 2026 13:30:12 +0000
Date: Tue, 25 Aug 2026 21:29:42 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm: workingset: account MGLRU pages in
 count_shadow_nodes()
Message-ID: <202608252128.XbcsGfzh-lkp@intel.com>
References: <20260824091631.836473-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824091631.836473-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 97FC71C0007
X-Stat-Signature: f4gz45oqz6nzuo3fmas9ktkd3tue9ph4
X-Rspam-User: 
X-HE-Tag: 1787664620-303679
X-HE-Meta: U2FsdGVkX19uhV88m92iAgUj/WD5npGYImIyUO/oGBwF2zvckCa12zei12aeduxL5KxqqZjmfR3V0qkhzVs/yp+2OjqIvCBlCkLGSw0R+50ojkeAp+nweKLS0wG5FDegtu6mAS6/nm05oJOV0FDcriaJhkCHQsaFd0WJ+3aGYO2NqoSi1sXZ1LVEnswaPrMSsjcC/hyDvM4z2Z9oZmwq5gwbeEV1x+PxiS4Fd+7i5ury/fw7mFl7hHlpwrTKgNp62jCt0PZjcv/7/cpJScK3ZyXFSZuh11Vk5hop73ziIDU3XVOwNvngSVU//AddgalWDsJfBaxpkIYD0Cw5nb6rqQBm2D7D9coRfJ/y87MdkyA8qBpuEUZ0DHFdbQ2n6CNS+EJN3GJVGBQDsGR6quzDNVNWaIYHZl2t9oP6Q/V8lCLfZsgPgUvAQIUF4RJ1Rnr9p2+cpoCkJrNccRNZGUZ+2sdZ5qRzkiCS3Dq176ZSVxic8lnWznM2x+CdPV0zlQ50aD3gyaY56EKG67/QDzaltu5Fz+/MTHus0Y//r+N2oLdiV/Uo9+FDu8P60ok8b8UuvnyOBktoa+HxNtaGIqBPvtFgC96kbWEXnBpLs8QTJ1CSqaKcl1OybgJ0hwA0f8L6E16AuUBq2+P934f3uStz09VzGDWmpbHbBULCrP/Uic7jpXPKQSsmLOnv+rYqAgVZZCbvvWqbn6UQjcHRNjXgsggdSo27clfBXjLbEsEIJiZVXnxyg6tNuI3bhRlsN0B44CFqQkCtfYfLOI/KfteoZBzmtsRGqfd+xJU8eX9YjsLxixpbofX+DBpdlWQCHEaLF3HhwECBWSFQhAjBwlGUYGIX7DyTMumtLlaTCNbE29tmB6AW9uaMIBOcRLdxZwwEZ3OJaSuqNIoKwwZ6/ehm1+fk9G6HzlDuLim0aHkKVgMcR/Kh3snhcVQbjGFQ2SDrgt2stsRo/HAizz3tIyB
 wcjbtMOU
 Wgfd9U+G/J7WSBuQe8ZZpuIczWixEPl3atqEEZBUXfSav21Y838Ke6zXpU4K9/01JPyAnM8VJ8EzNNgtORrfguRzuNKHKUhEIldpkmGF1djxi3+BMtT872c3NOlCDxrzcN0/DP2551v3hsQl8rW+xC+n6C6icbSvkSY+ujJ9tyDKHW/gen3NeMcHLNDaIhUyuJETkm+8KFbEWq56ZhExZDHNqm+h08BTYtDnJ8csOkCrbHUSM558aK0lVDBFrHCc0Vae1qjirn7UvVcAbgm1mzP7UyWzVnWmk2u2dEe92HCHcoe250t6JMXvuwGuv8G57M2J0+H0DMlzliOAB7Dpm+7QaJU0ImYCLGSSM5eMyKQCa+hcliLm3gdlZiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Zhu/mm-workingset-account-MGLRU-pages-in-count_shadow_nodes/20260824-171630
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260824091631.836473-1-hui.zhu%40linux.dev
patch subject: [PATCH] mm: workingset: account MGLRU pages in count_shadow_nodes()
config: parisc-randconfig-002-20260825 (https://download.01.org/0day-ci/archive/20260825/202608252128.XbcsGfzh-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260825/202608252128.XbcsGfzh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608252128.XbcsGfzh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/workingset.c:657:22: warning: 'count_lru_gen_pages' defined but not used [-Wunused-function]
     657 | static unsigned long count_lru_gen_pages(struct lruvec *lruvec)
         |                      ^~~~~~~~~~~~~~~~~~~


vim +/count_lru_gen_pages +657 mm/workingset.c

   650	
   651	#ifdef CONFIG_LRU_GEN
   652	/*
   653	 * The per-generation counters are eventually consistent and may go
   654	 * transiently negative while batched updates are pending, so clamp
   655	 * the sum at zero.
   656	 */
 > 657	static unsigned long count_lru_gen_pages(struct lruvec *lruvec)
   658	{
   659		struct lru_gen_folio *lrugen = &lruvec->lrugen;
   660		long nr_pages = 0;
   661		int gen, type, zone;
   662	
   663		if (!lrugen->enabled)
   664			return 0;
   665	
   666		for (gen = 0; gen < MAX_NR_GENS; gen++) {
   667			for (type = 0; type < ANON_AND_FILE; type++) {
   668				long *cnt = lrugen->nr_pages[gen][type];
   669	
   670				for (zone = 0; zone < MAX_NR_ZONES; zone++)
   671					nr_pages += READ_ONCE(cnt[zone]);
   672			}
   673		}
   674	
   675		if (nr_pages <= 0)
   676			return 0;
   677	
   678		return nr_pages;
   679	}
   680	#endif
   681	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

