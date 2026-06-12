Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FECCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F68A6B0098; Fri, 12 Jun 2026 01:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE886B009D; Fri, 12 Jun 2026 01:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C596B00A0; Fri, 12 Jun 2026 01:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9186B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:46:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A54B2165A0C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:46:44 +0000 (UTC)
X-FDA: 84870176328.26.C57556C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9AE480006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:46:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SpSzUCJL;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781243202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEYCBzKX2lEOvbEUmYJVEOAf7Iv5VMqw5VJMJRMHmGk=;
	b=IWdaqJOAdAmk7uHWeDR6eRcs32lPKj1fvDhjHGEGbbLIekN7sLzhbU7SYsdSzBBtJMWQWS
	iC2vjMHHt7o6g6djcxx3XBOXBckpaTEU2X5RldJynrsp9vnIMn9S+wZMOzTTDDa2oLGC9X
	fA9aw8rDRHIgamkbi7Wq1m31ax3TzZs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SpSzUCJL;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781243202;
	b=Q94poCxKBLT7zK+MdnjGzWxQQUHsMYf5DRXgwDMAdkCv6BHUnSNZcgDXKPL5KejCKtLxKl
	Tgblp4nQVkwcwzqyLd/p2PkdtFD8M30k4EwOx4IwS1BW3y7GpW47jtBkC9nIODTIwpOoUv
	ek2utOyra9hnKc31Buyfr79w0hPYr+8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781243202; x=1812779202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KaA366UF8HyTXkjqDa9pvzv1rGq0sZL+FOYgv4qd85A=;
  b=SpSzUCJLAHF5K8C7AV/mLR3BJB8IGdEp6Df6zABkijcn04cCIFde2dX1
   OPZDN/iMR3baAtb5619/eq6M0qOF/oEC71fC1X2yyNun33KhhjWNWuOLU
   cpv1PUwM2azn7T3nsyfaCFSjUQEOmzJBz4dRJgbq+sJOIU6PkpNL7dsY9
   OlMedP4V6LV5ecixXzsQ9v7lWI0NFgxoRseQiNgbalq1CT+Nd9qJ+9cOL
   UHlVAAce2kgIiZy6rGlgoTwkZNV6uJeL5S7VZwKU2nnYZ/1t8gZpGsxbS
   o5lGfiifHg0/zFa2uSKlZAG50J9BXkRNoQ5vmkUpgOdVXbw5BonsXbVc7
   A==;
X-CSE-ConnectionGUID: x++2orjgSFe69tsbEWXcrQ==
X-CSE-MsgGUID: wQYYWMsPTo60WC+NKDENMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="93179820"
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="93179820"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2026 22:46:40 -0700
X-CSE-ConnectionGUID: nEEdCaH7Q06wrOi5DlRThA==
X-CSE-MsgGUID: brFEOOJOSAmRGMxHfJZsPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,200,1774335600"; 
   d="scan'208";a="276925120"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 11 Jun 2026 22:46:35 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wXuiu-00000000ONd-0p3y;
	Fri, 12 Jun 2026 05:46:32 +0000
Date: Fri, 12 Jun 2026 13:46:10 +0800
From: kernel test robot <lkp@intel.com>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v2 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
Message-ID: <202606121305.h0cxjhP2-lkp@intel.com>
References: <3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list@gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9AE480006
X-Stat-Signature: a9wcshz6hqthf5bjsbtobphfm8gjd6dz
X-Rspam-User: 
X-HE-Tag: 1781243201-420460
X-HE-Meta: U2FsdGVkX1+tzf0CgxA/JSWtqp5/ot9NmekBUkKxiVLnBe3bwsJE3f6SpWNsNn43eR3EwCo72WkjPwxmR50+WCoT4wkzf3+Ryj4/P3fbYyDgwGYrPf6rWqUjy8dAsbmtU7HjcJIoQZz80VeVzpi0JDt7Z0h7OlUZvi7Et/zImQgYC6+4s1jWXWrdKEvh9CTJsVMbcUutDv5xjY/4inn7blvJ08L8SqW7+rVrWEysHRO2xcKbCFJuTp2GS7JBTclNdJNthzQ9fh/BjwpMe0WIC4SSSYAh6yoYCndaHqbxu+Z0apZUQQJJ9K0ub0h5voYI2w40SwT5gXIO86p9n27WFWGkpi9eU4nRVu55+yR/aL3y7EHq03wX/1wTvwirsYn1+3xm9bsNpi27qIIM079ONOA4l7Myj7MRMHaS8sBZoZH0YHTO+SkWzCnOreetvXHyWTrzpr47dAsz1vWKUfuvW9TYfUdvNhjAUD3xWPmXbWcom8Qc2lG3Q28Or8Hf1i48Dhh96EDytsJscnQe+PD7ipKqaXXJOD3LfTogd/X/i5jrMPDCaQvZQ3uHJnip2z5xTd/eTNZ+OyY9UckU/jwScWiKNQZ83Iyb5a0OYx/LElP84Wa149OAYclP/ydvCFdy0+Rs1HjwiZra81jUEVeqK/yHR/cXA94FqVHZZ+AXlQgrVKsgYvrfDxLh3IVSiE+TwmZSsmue3LqbSIC8SjQw9Bjy/o9Vi/xqBu+gWk3BMsf/as0VPNrFHy4ogCbqkoVBy63Y8wY1yrpKUsVepRoMAbZKWehmgBt49nOy5JSK52VfIHG6BmMQEZTR9nUItb9pY2byQCmMo9qVJxS4F9MO9dP+g13H8pK4v1Tg562C4wKA8bsQL4k6L4zxDM3jjphklNgc62/ezsYuTQUJbIUWiNnX8hjfYXQ/znW9Q5Kh82JqPOZaNkKja9yhMsMZEX5lZ7OTZpxfL/+DFzcqu6h
 zcrjRklW
 5nBMkoP4ZdC8UJGUVN3xK1WEFbmijuVHaO9tARCw7UfD3VN0sIXtH4LekgpOF3CKeu4arucaiwHuFUj2blA0YGQ1l2gRJ8yUSuskiAw4UozORuf/N7lc6B+83Zb82jNvZDWTvuqGidt9YY7zy4pX3vPpuUZyVrsDjgjpV3H/ElleA8jYaOJk04dCjlbSzTHqi+W7aY5ZWFBPldQBZ4OZ/m2ZtNcAvSGV989mmpmWnRXJ/wV/GkFHWhevrLTztVmbyvfN03/k2/0ougTG69hcMtQxq2xrZikbpofASpgxzT/r+8u6UiJRnJv/OxDe0cj1lwahKBjOC0DDv1Mh2aQI/o2ssV8kfZcCCVMHFJts7JfDfglqvFv8Cbd/parQwvLGr+RhvWo1BtiMKeL3+Y2iUJwOrkSkDtH4cyN2ga5uUWWhhP8Jk95whcsmVJ4PG133YbbdZsUQFaBflcbHAYZzSTn5XgvxZDC91wqBz4FNKYSX6QsvIfiVSDiMqgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ritesh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linux-review/Ritesh-Harjani-IBM/include-linux-swap-h-Remove-unused-leftovers/20260611-111124 next-20260611]
[cannot apply to powerpc/next powerpc/fixes linus/master v7.1-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ritesh-Harjani-IBM/mm-swap-make-SWAPFILE_CLUSTER-runtime/20260611-181121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/3abf510d24c8ef17bd5e324cccc5e03e548afade.1781170904.git.ritesh.list%40gmail.com
patch subject: [PATCH v2 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
config: arm64-randconfig-r133-20260611 (https://download.01.org/0day-ci/archive/20260612/202606121305.h0cxjhP2-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260612/202606121305.h0cxjhP2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606121305.h0cxjhP2-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/swapfile.c:133:6: sparse: sparse: symbol 'swap_table_use_page' was not declared. Should it be static?

vim +/swap_table_use_page +133 mm/swapfile.c

   131	
   132	unsigned int swap_slots_in_cluster __read_mostly;
 > 133	bool swap_table_use_page __read_mostly;
   134	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

