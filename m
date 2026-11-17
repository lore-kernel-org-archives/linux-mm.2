Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EACA606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=kkPMKqBI
Received: by kanga.kvack.org (Postfix)
	id 5AE106B05B3; Tue, 17 Nov 2026 11:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585D66B05B4; Tue, 17 Nov 2026 11:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B1A6B05B7; Tue, 17 Nov 2026 11:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBAB6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:09:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA4441C3D1D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:09:48 +0000 (UTC)
X-FDA: 85445096856.13.5BBFBF0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F5FF180009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:09:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kkPMKqBI;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794931786;
	b=nVJ1legJ4q7UN8ODR6HCA8GCFyLekTl/991y/57X9YDJ1phUOWc7c3d0BQTGYLVjNNOk0h
	8JEEQ8EhWTWqOFAl5B8Ig7JHkUWh89UW/fP8gQsDNQNkQukO3jb1Y6i5pparDYZhUu8tC4
	ngPU4WYa+Xvh9V4/CizSEB0xDH3pIqo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kkPMKqBI;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794931786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=UvScUGHsM15lCFKb8FKHXeRBorNMwqwMVFB7TYVWqMM=;
	b=toK9+NLPHVTxN57liYhlJVg47jbf9XWVJV5KIJkaE8yAjJAv1gudU/oN7LYo1NbA3KHLLS
	0UmyVZ9mUW5A5nw2WQUdkfCC3RWOoVibZY8pA9Bofod3UYIoUN8/7lMKGyAP8xoYYwI10r
	WqWyPdkV50rCqWDrKCOoHlRllotjvug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794931786; x=1826467786;
  h=date:from:to:cc:subject:message-id;
  bh=vkshbKx18VBVh0xRXNCtSh4UARbaMCneq8MscDrz50w=;
  b=kkPMKqBI7YidYrEe32jVn8t9r/MlkPQTX/yFiXOumH9GgZsbg2qNeUkv
   nnrfX+ocYdsnlJ/RZwGdeJgFIJ10/bVZiHQ5A2ijU4eInCbDCyMDaeQHS
   Wv0EI3dGcYHYQco8p/CqbEU9eku2M5JyLib1ERRhjKnwNoklrHhMdMkgN
   na1Qzig9XqiZWG7D6s9xIOebU3FpyoX6gNsKQBxl74gSNQrivK9nDQ09t
   bidNzlE3jDE4QhA3hHeBcbCou5/FGw2eORLb/ktbDMgFekDNpTcZ3WgiL
   /nB8G0MPoPSniNvKvnhvwGFy35efec4emVa7LU6F9PVoa3IZVnzluEtrU
   g==;
X-CSE-ConnectionGUID: rHi3bShCQl6AuJaCrkDu3g==
X-CSE-MsgGUID: F+XEiBwbRi+NZBNv63N4dQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3699030"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3699030"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:09:44 -0800
X-CSE-ConnectionGUID: R48YbB6nSZujGKMjG4IOuw==
X-CSE-MsgGUID: v/9V68TUQ2SSifJ3U8nRlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="10183685"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 17 Nov 2026 08:09:43 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTLka-0000000039i-3G6D;
	Tue, 17 Nov 2026 16:09:40 +0000
Date: Tue, 17 Nov 2026 17:09:02 +0100
From: kernel test robot <lkp@intel.com>
To: Aveline Noir <jm5905938@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, SJ Park <sj@kernel.org>
Subject: [akpm-mm:mm-new 316/342] mm/damon/tests/paddr-kunit.h:37:9:
 sparse: sparse: cast truncates bits from constant value (ffffffff000 becomes
 fffff000)
Message-ID: <20261117170155.fEdeuuhm-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F5FF180009
X-Stat-Signature: a7piqdrfsr1x9pdtj1hcdfhefjwpqx3g
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794931785-727699
X-HE-Meta: U2FsdGVkX19jQXj1MzIKbdS66QyPsAJfD+LSa3WynEuTRfj2ExF1HXA3Uk6zxkjmlkRtbdoKd9X1OFXII0Ra+pPOgifEKpr9mfVoN/4DScosSh9WQhpA7ShphGb+Dur6pB/xgzQkpy+5nL2fN1w/m80iPCM/choAyXIsL2GtpnL026ibQhSr9Ljw8nQu59oiUC2zpvyU5Ksabpt7JUDWITxjOZteiQ+sK5rfqC44FF9/E4eVWm3vKDQEWc+M3VcjhBPkbYC6EHnXfUNrPKd0sr3U48iWk/gxz3u5fI2bOCgJlc8rOZI7k7wKQzfpMsDdvKm3XPLO6o97ZKyWuxGy2NhVadYEAvN078DDEtmb6kve6ZmIz34tL9ZeakmMcqn9GucW4fLzEKpVeERFsUVcyslKHoOWhgm9VJzxitPKlaZCAGMgPXKQ5dHeDQ6m29fQZPB0JcsBcj5m7WSWB8fadsgU1razoyWwKu6JsJxP8bTauBmGNQ0CDvdCw92K/HSv4UDYA/QMQaYjBHZKPeAB6u6W5o1Upl+82vvmM/A+7WvdMjTxBd22Sh5jnPix4t77cbzO6y3UtLmARt36uCGSi5H0qcAxuuFK4a2nkTLtfKU7XGUIuy2ue+Wi0TyPAo10nZqfwju2cadXLykTW+0LyCtp8tzGvqgLnJYmHtR8ZSTseNmJy+Rb1K7MelLCPejwOmXmrQOIR8+dAluWimHOm+4uzWDA46BHBj78FLjjubqT5qWruXlD3NRfnE9s1loU8VkysYBTWtMzxTD5aVAz5RJbiiUq0dXrQwi9+zCcrBeN5Uc37d0e/+yvSIOkoOX4kuWKj7vftumxYZL1Dpim0Q6iChSxIy5Nln96SNx4D/1fW2TOQ7C2G2gu/wkbTzyWIyp2KdFz1h/QANp45/A3d3bK9h5uc6G1Cm67HgvIC1bGsWKE9OPfFGYt38D8kf1Jbs47EGl1IE6amZhgqEP
 QcKGmsl8
 aaNGnv0LN3ivyt/CxcdUpp6yH0q/FWk7DWkGEs8KJ83709NNUjV6qwzcyi6cSOhGWzHpqRs6uLVuKK8s7Hcd1Ih4v6tO5ERGeyQ2PMtz3d+jjQMLpD47LBr3etAZWqNpjYNkZp3Teijo37qou1/A0g7uGJOR75kV8vz0W13qGm+a/B3D7VX3O1F/IjqT02gn6CQoRxZIv13ggjQmmDd1PARUXRkrluygk8RU4Kp0H1LnbZo6YfWuDXtZG1pgkdXtpiLY6jtBhzL3KuzY5IhLkgZ7VmjN1pAwL4opi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   c37b2f8a996722ec8fbcfadb045f9f787df65510
commit: 7a983cc1b57309a875a9e07a934c9944bf3d088d [316/342] mm/damon/paddr: add KUnit tests for addr_unit conversion
config: i386-randconfig-2302-20261117 (https://download.01.org/0day-ci/archive/20261117/20261117170155.fEdeuuhm-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
sparse: v0.6.5-rc1-21-g84ec0658
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261117/20261117170155.fEdeuuhm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261117170155.fEdeuuhm-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/damon/paddr.c: note: in included file:
>> mm/damon/tests/paddr-kunit.h:37:9: sparse: sparse: cast truncates bits from constant value (ffffffff000 becomes fffff000)

vim +37 mm/damon/tests/paddr-kunit.h

    26	
    27	static void damon_test_pa_addr_over_4g(struct kunit *test)
    28	{
    29		unsigned long addr = 0xffffffffUL;
    30		unsigned long addr_unit = 0x1000;
    31		u64 pa = 0xffffffff000ULL;
    32	
    33		if (!IS_ENABLED(CONFIG_PHYS_ADDR_T_64BIT))
    34			kunit_skip(test, "phys_addr_t is 32-bit");
    35	
    36		KUNIT_EXPECT_EQ(test, damon_pa_phys_addr(addr, addr_unit), pa);
  > 37		KUNIT_EXPECT_EQ(test, damon_pa_core_addr(pa, addr_unit), addr);
    38	}
    39	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

