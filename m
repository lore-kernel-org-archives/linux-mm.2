Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70FFFD8779
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F306B00B9; Tue, 17 Mar 2026 20:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646316B00BB; Tue, 17 Mar 2026 20:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498976B00BC; Tue, 17 Mar 2026 20:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 295956B00B9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:21:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B685713AB6F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:21:09 +0000 (UTC)
X-FDA: 84557279058.18.F168B2D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8BF3E4000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:21:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRbp8JlY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773793267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slSiDCdp6j8mdMprnReu34c9JHWXlEUaV22L2rIoZ0k=;
	b=Vy7g00hkkWZUFbBHe3ULSP6Jha1xvyUBmUzA+XFRt/Ro+5yqm7/j85kpK2RAxgUzC6ltfY
	+gE87g8gg8THblmSWtpyx5vFB6hglK7pOmq6i/ypNGWd//mqHrZNB7vSJJS6DZ6H7rgC4O
	bPulj8yeupdjyssfCJqrPQVC7pxT9Qc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773793267; a=rsa-sha256;
	cv=none;
	b=jxr/8JRJGcIpm18othZFEXStCY/wKfyAedSAen0gQkzmYPnxLlzht6zAO7fj1iWHmbLrgh
	axXH9hyhBGaF9Lsrx1GpnrzyC6wI/b6/F3rYhu0/GJoyUJa9+gDgfTF74PD7difkQh+AIP
	FCq6zcANkUsuuqhlKamD0z+XISagcMQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VRbp8JlY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773793268; x=1805329268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oq2ZqhgFm//+c/ekDPWe+BbwOsCbRR7oScQ9iJZbg90=;
  b=VRbp8JlYjD66TR25Cr+aWKNJEiYRK35I08B0vuZ5P1Xh5mOcbLrorze7
   vBDce/Bp42FVE5DMf0ecC7sK2bKbJou0RLdEVke6XeWQUSwyh3MrcwU8R
   CSjgqgdZBgPoewpn/ZvO4GLNmT4RImMcMk5tvnrvirRfC0Euc+VQg9zyg
   7s98otulf4vEkwTCCXjH6E1iJ+mk269wVwdC40Y+RIY+XCpbtvQuKRJ2J
   xdoKiVq2VLaKeV5Ap8sywLeEdJfc4uDPE1CI9/yTuMtEwiWVtVt4IWyS6
   iE7wJH3EUYLu4E1sub5xB5+GcETOm4UNf6ybiXnGy1Ka96EOMcLpiut+J
   w==;
X-CSE-ConnectionGUID: uZr6SSvDSYaGY4cBIdme0A==
X-CSE-MsgGUID: UQqnj3+6TNWrJkuGcFgeJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="74729612"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="74729612"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 17:21:06 -0700
X-CSE-ConnectionGUID: pHP2SPTDSjmpEfKqdytMLQ==
X-CSE-MsgGUID: MwgKDGBXTvGcpquxZJK+mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="219903878"
Received: from lkp-server01.sh.intel.com (HELO 63737dd503cb) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 17 Mar 2026 17:20:59 -0700
Received: from kbuild by 63737dd503cb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2eed-000000002EX-2zNc;
	Wed, 18 Mar 2026 00:20:55 +0000
Date: Wed, 18 Mar 2026 08:20:41 +0800
From: kernel test robot <lkp@intel.com>
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, david@kernel.org,
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: oe-kbuild-all@lists.linux.dev, weixugc@google.com, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de,
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
Message-ID: <202603180851.hRAaHR6o-lkp@intel.com>
References: <20260310073013.4069309-7-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-7-dev.jain@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8BF3E4000B
X-Stat-Signature: 4pngpnwr9b6gs73eafh7g9saezw3qr8a
X-Rspam-User: 
X-HE-Tag: 1773793267-533531
X-HE-Meta: U2FsdGVkX1/wGijURDz5dZviwLkuCHXXm9qM7mGfatm/VrFTzT0vaB2mM8EYHfSgbePJbsPYhv8G+c1qwBZaVvonty8yCSapqu/mxZrKHDJpJ9pPFNlD3v9kBe+cwzPWEzowQx5rbvYelS8gA/Tav5WpCbbYYjXQy92Q3gquhAjhSmtGLz/CCBhXYHvSjnp8xrYWE7HL01kH1U+Vrx+Kn7CN4zzseXp/ThNroeLxKKaBmXKUwhj1DG/wob6FlsC+hXPTXk90mH22dYCSyL+57Eq09yV3VI9RFADxAynKc8RlcfZUkS9eSKDRnM9ol86oZFU/CRKHmLaJH8bjQlMwRakn4kLDQVmIXD0e8Y1ITqGaSxML1HImCi84XpIlAvVU61IsznL1P9CLbE/p8e9/X7645pSWklM+9RJJNIyAgx4jPPMZ1O4DgE97O8iEGk9zo5hkPHwTAz/z9SQb5oYfnM3YpOIp42tqQK3nD+OHqI0EXI7RZ4mJCt1J9l8gNjAAZFuHIg5cBvT2yhY5cSX6B1P+nfHW4mkBc3Qyr211i9Ilpp8cpzyadmErbmaHtHOS3uZQrcG1iqNjTITUkxDJ71MKaP3t8AeLbNFlILOmFiL5aBNB6yTVaIiYA5Uz5jNHsg5VC35X5bv4bsEWirycFjvmmzQI0JRQ5Arj589XKmqkf/FNGMM05751vB7XPua2fUD/vTsoFuqr0DqA/z3SvXagm0ZSn5sjSQZfNVZ2xqIeZi+6c6TthexOUAX01WXp9qx++xaCS5w/Bb9rjpp60tL8k5fJE9QuKh5XCWfCPPIrHSK+4E0NbbOHOSmxDMbmzS7jz3kVt32JjvvMYf7C3WxBQpbs7FkBfsqp3iIqnS+v27m3eIr8oadqjE54Y5Ky81wPu4oCZlJWlg+hSSt1QrL1iSguvGnlBKrMID+mXmUeFxLe7FeBhldTltCUCfipC08Av6hg6plBZPSuKml
 1JldttUb
 6S+cYBmYxJlPujBalwdIAqy1JfrpOeZQ7+XSU41hkHaQ7nthbbPrKEIC6o8sdngGnUU3fCUuV1WYDmM0h2oA1WwVeVmOXVTCxFv5n1X9tdTs+xu8Hx094icFsfjl3PAN6FLEDsAPjCwUE9GnI/c2AuTGeGGY2f/WCSUkNJgv2Pf577BKjpORHkZ9/2wHR9Ae0D9yRxnT8Iai1NP23J72jfKuNT/27n1S59jr175gEr8yBD6ChpQ0wNXqR16U2Utt0OTILd6ETIUzCmwXnOzf9Qdm0KNCEmkw5T7eq8qXeO/foJq3WdtVBqiOvBVbJKUkH9hSmWkYVHAunY21rurUiY7xou6GyKNFtwVOlWNHP4GY1wIpW1LSQtRYKO95AGX8HMst2LtqeG1tDYR2PVSElIChu+6d6MI34pGVROEusWALvAcTSs2MBBw4iIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dev,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Dev-Jain/mm-rmap-make-nr_pages-signed-in-try_to_unmap_one/20260310-153604
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260310073013.4069309-7-dev.jain%40arm.com
patch subject: [PATCH 6/9] mm/swapfile: Make folio_dup_swap batchable
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20260318/202603180851.hRAaHR6o-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603180851.hRAaHR6o-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603180851.hRAaHR6o-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/swapfile.c:1757 function parameter 'nr_pages' not described in 'folio_dup_swap'
>> Warning: mm/swapfile.c:1757 function parameter 'nr_pages' not described in 'folio_dup_swap'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

