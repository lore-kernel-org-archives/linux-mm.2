Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37ABCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16BE68E000C; Mon, 15 Sep 2025 20:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141E58E0001; Mon, 15 Sep 2025 20:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0305E8E000C; Mon, 15 Sep 2025 20:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E67ED8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:35:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 976B611ADC8
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:35:49 +0000 (UTC)
X-FDA: 83893245618.11.E0E0067
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 797D5A0004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:35:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WBe79tc2;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757982947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjoRsvHsZYXt7+EAXnN4dy8sqoNfE40WDZtHM8WnpCI=;
	b=XNFOujpUFYDk7grD8TPWi60jiBz269iZJDf9moej11s1ESxIeYYzBcVF+ZtLaA0oSvhVcN
	C/+CRYUvp2s1LAHMHj40DfEYKu5DBdnk5mgX/UleDkLHZ8FmTHB9KKEsh3/+eb3ZfS9cD1
	nQBVEejQMS6AhuBh4k46mgu6p7+fQNg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WBe79tc2;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757982947; a=rsa-sha256;
	cv=none;
	b=Z1T+lJt0dMRFNpjAvloCj1WTdep5omLnwr261e16tmuj70iC/LMNmWTOnlSMKx8vWLDTEX
	YEIkeu2XNfYtAz+YDj0VKUdKtshIEyB6m1F/Fs+0zrMvxYdH8J9SlIij1i+s/E1RiXH3vN
	k3R7I5gfwNLg1qrl1hLdFS4icRc5BXk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757982947; x=1789518947;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LmJHPD9NHoWsBXvcXhrQkihPJobp0T9K6gUq47vVjC8=;
  b=WBe79tc2jFOJ2388Cs8iXlNd9KjJsbx8zFGi9fuajeN2kMzRsWlxQkgQ
   qh7mSFw8t6hBeZ7MLyiZ2QXUaVNYXl0j0YWb5qLaXhyEbTekA878clqcA
   SdqRYilqL3rIawTeAHhlRp5Ri8edpchmuDXugK6pmCx2opXQNr3HORaYn
   mltyLoSotU4hvMJ2u/FFalL95Oqhb7Dsz1Dkm5562Hxzyu+7kdoiozWld
   PpgeLkH3N6x8HL2FN4uc+6YRqM5JBnaLnxWgJRH2chiOGUTcorjrsi+bL
   ituWClY7AjD4low5dnjbGEGIii7evZIACd4v8WSaCm013PMxrrv3gw2SQ
   g==;
X-CSE-ConnectionGUID: OwbWh4SZQoetZ3bYk9gXyA==
X-CSE-MsgGUID: VuM2XnUNSz2r1JkvnpHS2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="59950171"
X-IronPort-AV: E=Sophos;i="6.18,267,1751266800"; 
   d="scan'208";a="59950171"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 17:35:45 -0700
X-CSE-ConnectionGUID: TdDvCJkJRcqdFr636SwQ8w==
X-CSE-MsgGUID: TK3RuA7ETMiS+F2G8Urczw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,267,1751266800"; 
   d="scan'208";a="174607853"
Received: from lkp-server01.sh.intel.com (HELO 5b01dd97f97c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 15 Sep 2025 17:35:43 -0700
Received: from kbuild by 5b01dd97f97c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyJfY-0000qX-36;
	Tue, 16 Sep 2025 00:35:40 +0000
Date: Tue, 16 Sep 2025 08:34:46 +0800
From: kernel test robot <lkp@intel.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH v2 10/10] mm/vmalloc: Update __vmalloc_node_range()
 documentation
Message-ID: <202509160821.gR75Zhnh-lkp@intel.com>
References: <20250915134041.151462-11-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915134041.151462-11-urezki@gmail.com>
X-Stat-Signature: dqpqd88uyqwsr69xduib4mb7wfkhzig3
X-Rspam-User: 
X-Rspamd-Queue-Id: 797D5A0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1757982946-494406
X-HE-Meta: U2FsdGVkX1+R6VTpqE1DiVM5Dp9ZqSL8V/GQQfbkdrqnRSRvMetdVxRr8f7nK54/BWYI5nHXXPxwxTo/AdHgoN0bYPvp3VZnOpv4EMJtB89rw+oaTYknKaxzoKwpvmajn8qWksPwLYaZqcZMT7bNFa6PCzldM/ES5MGvvT3D21sB7qmbSofYuGhzk1T+uAP8jDsuaU+uAGZMw6GSpaaW8kaPDw5jfVUCwTCjUR98UXjGL6zNEaeUda3CkdJX4o13eYQFsPQj7BHpzq7WPJGPSL1nG4d4KPT0xLMo/VX1EVTXnJJolCDGfmdOxwi43SuycY6n+M6PQdc5JRcJ/OT564n39X5+Y/IPqjlkkCY+/4LNYUpgOcD69RkDk2tCfM145P8TpLCbOvvJltJK4kkWZ/4iqLCK8fneSi/QQmNAo5vpkF2pwh2Hz2rkLkHpJ3LaoKnF1sTuyFWZvOYzkBl1XP4HbYVWN290BcP3/gWj9kOE7xEwjWWezneyrrshz9riMjj1lxuMCxE7dDVptLqLV81J1pjglL/8cMNVfPsPj8CUfbHbS6ZA7YptSfnEM94Om4ywaOzVCnll2NoTxFGyeFGO836hFgjhHBqAyr9tqHoIHxoZXjK02FGa2mZHZO5yI5GrM39wii0r5r/VLSHTWY1TuM8ktd1ABk1yTuLjbeVHrQBjAfIA6Xa86xpfK6DSk6EOIU2L4ioV6XvpJj1Gkozvcx9azcE/xyhASPJNWZqCH5+WhoUlh3yVMWWtFYpaqZRFZRTGfYEs0NKGE3RIntfYaZZKLipZGkQkD+GikaaA5sirDA4WiXFCd3qaHVLFE1rnHTft8ed6VyfS0KVz4j3ODpUphceiD0j4py5C8LAGX3Yl9cD370LI1uwj3lCUwSYPSMnlMHbZ8xJN7Y5ZJHmCq/loSbvufYakQ2tAwc5/RBbuWtb4YA4sN3IaEsGjZVBfF1J0J8FTFPcF70H
 uWghJGRh
 zaGcL7lPGHsERoJDmLfVErS4399BXuEBGSoRRm9ZumKtP5NEbVCSUYnOGqAEKaOYcMMSwq+vzmYt3b/3TYtAvPk6dbb62qSThkZ3wdJKDtBk2mBDmzv+tU0aexzTh3//OoyocRdZgACGy+2ws+S+SEHd67ek0LtONsjCRL2DqZhZLx3SaZ0I2ulzboi9UxsQIx+4H073yaLHcufL5ZOGPI+pK5ziSH9rqfUYHICL0Gh4GxaOA/YtIoJWivSElT5TDmYPjjzFO26JXDS90v++C1llx2gE1deSHGJtCadcAPC8OfKCZMWfn8Igl48fKy2NMd6eLi2167GF23e42CKGrVoqTArrTgUthZSydE4GpqEPDBcjFaXUMWJdmHpVUYAQZepXIiQpqgcDugbeui9iMRcoBvAo/lwrmT6AfhdnjFPA5BjM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Uladzislau,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.17-rc6 next-20250912]
[cannot apply to dennis-percpu/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Uladzislau-Rezki-Sony/lib-test_vmalloc-add-no_block_alloc_test-case/20250915-214352
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250915134041.151462-11-urezki%40gmail.com
patch subject: [PATCH v2 10/10] mm/vmalloc: Update __vmalloc_node_range() documentation
config: alpha-allnoconfig (https://download.01.org/0day-ci/archive/20250916/202509160821.gR75Zhnh-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250916/202509160821.gR75Zhnh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509160821.gR75Zhnh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/vmalloc.c:3889 bad line: 

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

