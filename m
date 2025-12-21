Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B593BE67482
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 21:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E52B6B0005; Sun, 21 Dec 2025 16:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793E36B0089; Sun, 21 Dec 2025 16:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674346B008A; Sun, 21 Dec 2025 16:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 534BB6B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:50:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6A74160964
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:50:15 +0000 (UTC)
X-FDA: 84244821990.19.F32D1F2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id D277F180019
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 21:50:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=apI5a3q7;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766353814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AsX86w0AIZpvJjYGFXzwbCuPEZhD1h5q2dDo7gHAtH4=;
	b=Sin15URvZVXMewUrpfeURUsPeFGA15UJhD0OKiqa2kIE8HSjhNI21y0Tp5+6jUh7EkmX3V
	aDESgJuT0ZVykl02ZbPO0ceX4NEUgPAIES78y34rNxQlpamiTxi4o6hiZk/OsnKVu+zM+y
	e8neHtSyhBmxGXFNcRetRVmQslEXxfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766353814; a=rsa-sha256;
	cv=none;
	b=VgNo5edWKTWBhmFjySxUrPBi7dJHJP6CvPZ3kI5XTS9vfQVwu+nyYlQIt5PL1YnpqKYnwO
	Q+NWAtSTREkNaBL7yQjyC3ObK0/vh1HNGcjbvdyDrnW9KxWKNmR7Vk125O51TW3u2gVe15
	cX8hJlmequ7CGBx9M0nPc6JzDIEoY/g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=apI5a3q7;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766353813; x=1797889813;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=wK4hv0liv6fI13orAi0jiRtUoKbQmRln9wYbtPfdaww=;
  b=apI5a3q76F7LSq+NbzFp0yX4JSSOY5lOMLpxdsNdAkMw3uJIP8vAnR/K
   wz+LMNaLdteY3Dw0M2uEDmrTa2l5cOonm/Qa659u9QexUktzifzCj+yS0
   2o4TtUKpk5NtBkZVWXqZ2ubN7TAr5tC29sfSRTeaFEGqc5LjcmsDSux+z
   m6AztBjAXSZ119G1QUQn2pAUrTRIIwIBGc77/+kF069g4X8VT47uYGtHK
   8Bl1dgdI26RL2kqO+hUO6fuhegMsd/Yat4RiYy9B1xWmQeQWZxn9SRU98
   GaHMRSl6CcwCx0HM83CdoGznz9vyQZjRVaBtfINL6TQPx1oGZD5MpSYwL
   w==;
X-CSE-ConnectionGUID: s4c6f+pSTq+t12EvNxzrOg==
X-CSE-MsgGUID: VnxC4TfbR+SpYdHaO2YlHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11649"; a="68297120"
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="68297120"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2025 13:50:11 -0800
X-CSE-ConnectionGUID: uo4ihW/PTWSHu3aVVECjsA==
X-CSE-MsgGUID: YRLluMLfRx2WOVe2/d3vTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,166,1763452800"; 
   d="scan'208";a="199388689"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa008.jf.intel.com with ESMTP; 21 Dec 2025 13:50:09 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXRJW-000000005Fk-2E3C;
	Sun, 21 Dec 2025 21:50:06 +0000
Date: Sun, 21 Dec 2025 22:49:44 +0100
From: kernel test robot <lkp@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-doc@vger.kernel.org
Subject: [akpm-mm:mm-new 98/101] htmldocs:
 Documentation/admin-guide/laptops/index.rst:7: WARNING: toctree contains
 reference to nonexisting document 'admin-guide/laptops/laptop-mode'
 [toc.not_readable]
Message-ID: <202512212211.GvfwAGPP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: x6zbwarcagdmdjfpiyr1yo3r3hh9jp6f
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D277F180019
X-Rspam-User: 
X-HE-Tag: 1766353812-795395
X-HE-Meta: U2FsdGVkX19Rhm67JX8aGFZWPalwcKBsQwSARFNyN5cB3FKuWkRBWWWvclFSOIMhcBumWJ50VZz5foII7E5LtHuAStzz+b4NVqK2AReBKGvfntV/Qck987qtAVPf8eDizf2xyKFmZddP4zCULDhjpBcPIXr7lJNbJ3gSVJA6l4P9M5sZ5KKK3w0tnHuM0silopRs5ZyX8NvBjvkXVzeGdrfVi/FmTMrhblEUtck4iwR8fiPmR9VYthO+aYV0lxqCMXvyATLH/XArWXF3WUzs+Bg0tlVu6JEmugeJUCiXUfysj/uvpO/P7nQyfW1tPE93wpPDJpA6TWClFW6zbbo3DfKAetoOjZmk05W1z38sux2jxOmnEqPI/HW4E3fdsyGxpzXTa6UcuUpToywctVxSBdJkVHvO7cJLrOOasftGeKNdYMXbm/7sUQqvAGP+ZS6Klpcp2mdKASiHEZQs8o80srldZ4+4x3FYuHAd/nX8Vumh2SLdTcT5V77oozjU4i6/h6+JU6gCR+/rvlJAU9pgYkstdjeX94naFpNzeFwsDGCTWkYsLQQibITGpvk1822Eq1UtK6tYw8xMhR0NUHabaxoec/hdsq/yOcsMNZ8IWnT+36F88KsQVTBMen3yfXc9nDN2HMRhZyoE1nf+p2HSqqKyn0dFCfdmLoI/pSPuPLmWVfdQ++YOJ7+pM7eigMr4zls7aoRqx1wsstsbgO88Wcibp9y6UfKox7mlU/5digbtR4y7ATzFsBb/UEZhsd5miMgO1sGG9zuAhXZJBsYA2LcmJsV73YnVskLsZC5r16upOSJ6jJ8a7HddBgI/JF7SNn9asK7W2ru1ta6KDWOvOobo+uZWbW2S/ZZ92mt6Lcdwhp2PpWsIcvoSw5sZRXfjZ88Eh60hptcuQvSkM8IltmIxA2Nu5fkuEbSHBgptBv2AWJjb8E9kr/3GFLOlltrp3QGBeUzMDPN1DDBHyFz
 MLPj9Lw1
 9A1iaHYkA6anWMitVvOl03adinQPXn8MG0C2bJVIfR5OP7jQ0SdwJZryom3lJLR7T9DvulZaal7pjcBMzM+7EJIW6JBdeI+TLVZQxvxOoyCTyZgV77gqN/x/cYWEtEzi2A/ygm1Nfw62JIjEFcslZ7nQkvO4PDzn9/Zw9j16GMwetJ3WLng46VDsUM0bq+Xcd3Q2DxOv53sPmF6JZuxTC7Bhf1NHo7MRppZSemr1OSYd8YIkZBmD3iErIlLxhP/N7PfLoBtPvFTFirQfbhxTHR5GQ5B9OIe6yrFQ70TaFK+HQ2Qys3fEkQFWGxEtjrdR9mOHsrE5ZTTa0fvlrG/h6uLzI85mQntdeLic5LGVksS4I+ecwmAFSLFcg+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   287373d0b6ee3872d95edfd1921fb2f18535d6cd
commit: 7cc91bf52584387445d654cde466ba5cb1235757 [98/101] mm/block/fs: remove laptop_mode
reproduce: (https://download.01.org/0day-ci/archive/20251221/202512212211.GvfwAGPP-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512212211.GvfwAGPP-lkp@intel.com/

All warnings (new ones prefixed by >>):

   WARNING: No kernel-doc for file ./include/linux/pci.h
   ERROR: Cannot find file ./include/linux/mod_devicetable.h
   WARNING: No kernel-doc for file ./include/linux/mod_devicetable.h
   ERROR: Cannot find file ./include/linux/bootconfig.h
   WARNING: No kernel-doc for file ./include/linux/bootconfig.h
>> Documentation/admin-guide/laptops/index.rst:7: WARNING: toctree contains reference to nonexisting document 'admin-guide/laptops/laptop-mode' [toc.not_readable]
   ERROR: Cannot find file ./include/linux/pstore_zone.h
   ERROR: Cannot find file ./include/linux/pstore_zone.h
   WARNING: No kernel-doc for file ./include/linux/pstore_zone.h
   ERROR: Cannot find file ./include/linux/pstore_blk.h
   ERROR: Cannot find file ./include/linux/pstore_blk.h


vim +7 Documentation/admin-guide/laptops/index.rst

b02f1651ff7758 Documentation/laptops/index.rst Mauro Carvalho Chehab 2019-04-18  6  
b02f1651ff7758 Documentation/laptops/index.rst Mauro Carvalho Chehab 2019-04-18 @7  .. toctree::

:::::: The code at line 7 was first introduced by commit
:::::: b02f1651ff7758c4db0d759ab765d39986a79f5a docs: laptops: convert to ReST

:::::: TO: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
:::::: CC: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

