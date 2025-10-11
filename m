Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C187ACCD187
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 02:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFDB88E0027; Fri, 10 Oct 2025 22:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4048E0011; Fri, 10 Oct 2025 22:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10F98E0027; Fri, 10 Oct 2025 22:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B05DF8E0011
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 22:58:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 191B34644B
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:58:12 +0000 (UTC)
X-FDA: 83984324424.21.CB02D9A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CA0D1C0006
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 02:58:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M8eB+dbV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760151490; a=rsa-sha256;
	cv=none;
	b=iofwaAdZ/13qjyUGSN9iwpM3bgh9G7XI5WUxArx28xCugTu45+ViZplS2am/mKPSzG3CTL
	oyXdtgz6cwbnUKXw9SUx82i4RRqKxfQlJjnjZFJ0YiJALH7Z8UwQl97Mq8ooc4aAhp5A51
	vqMjUlhit8gU8zutarIjPO5DdeZkXq8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=M8eB+dbV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760151490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxNPtdLPaQJxgWiz16sexAjzD5oBdchM7rwkcxvfupQ=;
	b=debWKkx+L3L01hGx0DUoufvdEcPNlf5/zKzMHfFQ4YHMk/Z9zra16qm0C0DyltISI3H5Iw
	aTxHKK1g54sJ1qm9nb3ZhHFJSoxgOxz0sYjeE2mqBcQqQmdHdoGK5TNxk8OubUT8WWpJVn
	Anb8RtkD0XfXdpRZ70CO9Y0LzkPv0M8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760151489; x=1791687489;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=n3Cf2XbDxUMzoSgHrQU9R6SSN64Mq364sx/VyZ4IhmQ=;
  b=M8eB+dbV3tno/fyDUV/o8Yj4I2HsXIkgFsWEHnZnRHNeGZN+iRg60e21
   3/z6cGP72P/1ezeDODmrz8ZeZIgfuaPnIdgQUIFgfbagKIXmpVmuXbv1V
   ANBqYH8H4B64gsJc94VoxvdlFVdU5FQcnJb9SNd3fH1ZhY6DQ7r55+0UY
   1IA7igv1+Kl3T2mbakVOiHTVVTrA4EIhO93jSN1v5IuyFi6NFVZQ2ll5K
   8KBUFS019etbmZ7nmCem9FViVVCij2GH2rkEDCK2NwyQkTmV3PAHwMPPz
   jf2nUR4jy9AHyoC6Hu5SWJb3mfCJ5cmFP/ZBzzoguau2tHBUuI/6MRrG3
   A==;
X-CSE-ConnectionGUID: OB28FRIXS8+OSFEFpqYSbA==
X-CSE-MsgGUID: 849sSirgTGuZAthfAnciyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62267677"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62267677"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 19:58:07 -0700
X-CSE-ConnectionGUID: YrfVI3RNRcqF0tl0N/g1FA==
X-CSE-MsgGUID: kzR2Jx+RQBOJsvHCexOGmw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 10 Oct 2025 19:58:01 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7Pny-0003S7-2G;
	Sat, 11 Oct 2025 02:57:58 +0000
Date: Sat, 11 Oct 2025 10:57:22 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org,
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk,
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org,
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com,
	robin.murphy@arm.com, hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] mm/tests: add cleancache kunit test
Message-ID: <202510111059.aKceYLLH-lkp@intel.com>
References: <20251010011951.2136980-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010011951.2136980-6-surenb@google.com>
X-Stat-Signature: jnqey9efbk494i5sjayiz8zarkf4swt8
X-Rspamd-Queue-Id: 4CA0D1C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760151489-523106
X-HE-Meta: U2FsdGVkX1+Lf/JrklPVWCa5GHxeHpfEv4GZoha6GsmULhpYH8CT0h7hYiZLoDdr82jq6ir0O4WwpmQX39w535xvEbIpLe47JBa/Oy+NJ75KEaINpluYn6hksfZnqdUZZEl21Nuv87HBf7rYqJgPicKvKLy5mJKp5huly9p8ihiKNBbWGb2rAtm7yukGNvbvPgFfjwWjh86/kW5daxM5wyL/De2Vnj6lG3DpcwPImbXOEj7pk0xEMMTl4U7A4rNDMtg0k+0ME+9afAWMnG5Mh6QEmf4PCCQ0mPRlROuPGl5IkjIRIdTxfbAZDc+K8j8YyB5kMvpJ8G/TdzUWbXaMuaV7HyLBfyDAYxcBh3Y195haoz3oIIaabwAzI2PIt2+qvm4mK3KecsxRbrSwSgiz1q5fbVTiWjeUcPJNkk3G2vhCE0kCnCIpVu9grB1Wzi9yc3ZaIm3Q6GFDo8v+1Xdhv2jDkGqQNtBw+qvKb24VcnJTeKqmmlqQz5SewZovcEN1K4d0sgZfJ7P43QJudD34ZH6S91HlA7lRbDxtfA63eEH0Jc8sWToER4OiAQgxw+buPm18phQHb3HrwL4KNGnLk9rUxvFFmmKZ7eLKOeASRqyvN94vD/qiOx+Wn8wEKIkqnsFhEdwK6D7yJDFMeOAneLihuYs2jVC+YjOqo9ZntGYNbU6HiDZR6+EgDWIH4S7lWk+YLPyxjUlJYl4jrjCdjuns74n473j2yae789RR/kiiqI47k9p0CGo0D2yfNHrW3mJHJJ3JYuApGbXV8FvgNQTdSZqgDBgnt4GnJS2EPfJtAKLmqX5Vs6k9QWt0vl6BcsvwkqhzUBQLfd1dZEYOzoMz4G2rrgDgJE92IrAvRnOO1Aiw8C1KeJke/f2RQB4ly5tEWCQ+N/pr+j6JJ7js4HFU96iaq2/q3lTzrl1nSDnmUmlGxVh4oUsucpgKBS+SjOILs/dP5JM3DSv2e6p
 uXZLmGKd
 KctrC4DFA49cRyUI73fAFoBUIQl1tDLx/w/Rl1N1L4AFpqzAxnhJ0T+mwJYFJtZo8QU9IxcOE4lBKyWFBuILh9SI513RUMRBvCvYETbjGwVktSBv/M6LB3zcdvENbk7JgZG3hTPKoSBTZOjjn5hv1ZwxvVJLYMY8MLNkOQkPEvRyx41fbz/4eMH/cV53FZgJOh8FZ9d0LAa8KUPMsHkMkSk6nXGD+V856LBz4s0kREzqdeizKC0f20lLXODB1p/bCtno8DtDKE0mo240YVB1DFv2amXQMpfAmRsMo+22KRgfCu1B9+LxtBYRxral8AB/aJgVhBEEU3JmTTrTF90rlx1Giif0NWTvQ4NMy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 70478cb9da6fc4e7b987219173ba1681d5f7dd3d]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/mm-implement-cleancache/20251010-134501
base:   70478cb9da6fc4e7b987219173ba1681d5f7dd3d
patch link:    https://lore.kernel.org/r/20251010011951.2136980-6-surenb%40google.com
patch subject: [PATCH 5/8] mm/tests: add cleancache kunit test
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20251011/202510111059.aKceYLLH-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510111059.aKceYLLH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510111059.aKceYLLH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/tests/cleancache_kunit.c:358:6: warning: variable 'unused' set but not used [-Wunused-but-set-variable]
     358 |         int unused = 0;
         |             ^
   1 warning generated.


vim +/unused +358 mm/tests/cleancache_kunit.c

   353	
   354	static void cleancache_backend_api_test(struct kunit *test)
   355	{
   356		struct folio *folio;
   357		LIST_HEAD(folios);
 > 358		int unused = 0;
   359		int used = 0;
   360	
   361		/* Store inode folios into cleancache */
   362		fill_cleancache(test);
   363	
   364		/* Get all donated folios back */
   365		for (int fidx = 0; fidx < FOLIO_COUNT; fidx++) {
   366			KUNIT_EXPECT_EQ(test, cleancache_backend_get_folio(test_data.pool_id,
   367							test_data.pool_folios[fidx]),  0);
   368			set_page_refcounted(&test_data.pool_folios[fidx]->page);
   369		}
   370	
   371		/* Try putting a refcounted folio */
   372		KUNIT_EXPECT_NE(test, cleancache_backend_put_folio(test_data.pool_id,
   373						test_data.pool_folios[0]), 0);
   374	
   375		/* Put some of the folios back into cleancache */
   376		for (int fidx = 0; fidx < FOLIOS_PER_INODE; fidx++) {
   377			folio_ref_freeze(test_data.pool_folios[fidx], 1);
   378			KUNIT_EXPECT_EQ(test, cleancache_backend_put_folio(test_data.pool_id,
   379							test_data.pool_folios[fidx]), 0);
   380		}
   381	
   382		/* Put the rest back into cleancache but keep half of folios still refcounted */
   383		for (int fidx = FOLIOS_PER_INODE; fidx < FOLIO_COUNT; fidx++) {
   384			if (fidx % 2) {
   385				folio_ref_freeze(test_data.pool_folios[fidx], 1);
   386				unused++;
   387			} else {
   388				used++;
   389			}
   390			list_add(&test_data.pool_folios[fidx]->lru, &folios);
   391		}
   392		KUNIT_EXPECT_NE(test, cleancache_backend_put_folios(test_data.pool_id,
   393						&folios), 0);
   394		/* Used folios should be still in the list */
   395		KUNIT_EXPECT_EQ(test, list_count_nodes(&folios), used);
   396	
   397		/* Release refcounts and put the remaining folios into cleancache */
   398		list_for_each_entry(folio, &folios, lru)
   399			folio_ref_freeze(folio, 1);
   400		KUNIT_EXPECT_EQ(test, cleancache_backend_put_folios(test_data.pool_id,
   401						&folios), 0);
   402		KUNIT_EXPECT_TRUE(test, list_empty(&folios));
   403	}
   404	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

