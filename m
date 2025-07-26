Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94C3C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 11:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406146B0088; Sat, 26 Jul 2025 07:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6696B0089; Sat, 26 Jul 2025 07:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F44F6B008A; Sat, 26 Jul 2025 07:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1BACB6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 07:10:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D2465C3FA
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 11:10:35 +0000 (UTC)
X-FDA: 83706147630.20.E2A904F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id D114740003
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 11:10:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="K/a4I00X";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753528233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FlT7NpOhMJdWxS3mezT6U7WTT2ZdEMRbpdsA7w3xGvM=;
	b=4PEqdMrYT28Rchim25rp+LaP8zD0RsVnKwp5oEtRVLVg4xg5HD9h7MkBrpHiZr83n5dAAe
	kTriuhyqxqAhbLBzutPMvvX8GC9UKRs/Etf4xt9YyAmlO5cIZ3PqYZPctMt/OP4+4ywXdf
	2ErPG0k3LZipet3+zHbQk8AnkOBVUhs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="K/a4I00X";
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753528233; a=rsa-sha256;
	cv=none;
	b=Fb5/9OUomcbQddmtKw9l6jxEoQ46FjHPLGLpeKzvMFlfD06mRUGp7PjMZWjmy1mDQb8NUa
	YrndbvGKIt6aQptO2j+sTwo6ENhR+QCVk307wwBMrs+eNR2H+k6aQ17NmigW443+RMDI/+
	IymVokcZ28Bh40hafcOmaQyDLqhvQIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753528232; x=1785064232;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=BsDzL6jUj1vcsiHYQuUaBhwNbzLYvpKYnyq3KRSVMhA=;
  b=K/a4I00XVThYVYqzaAy9xbDB1Efw0Qdw4I0p0/tHTT3A81c3yBr/Nfu7
   t9SFi/6kNLzPOkUZvXXp1l7MLhcFDubd6vNw4Z8QKWlUSVNC/LVsdqwFh
   +McMih+AMEUVWNXvZ/6MJAGIe7Lx+GjUGi4agROAnJ6TCDavZbQe2r0xc
   alpGTE8uxcd79p21KWUS7UF7gc++9y/DkAcDL375r3O/u4guIXLyfR67c
   L/YYKeA/JWYgsgLfgUE8pbyO5p/mc275MVF+dDuJt4DmReLAuIawkEBgP
   5K/Ro/eAewTVLQupdAylfOHY2evpt24kQTN2H26+WTBpwAcHWOIq0BH9a
   Q==;
X-CSE-ConnectionGUID: QZWZUYk9THex6kX22TqUnw==
X-CSE-MsgGUID: eKbSWTddTvaN+T9HLxvcOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="67199193"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="67199193"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2025 04:10:31 -0700
X-CSE-ConnectionGUID: mrSnGx4WSkquPLniUT7T0Q==
X-CSE-MsgGUID: ywykZxh1RP+0vFoPBzc6Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161844790"
Received: from igk-lkp-server01.igk.intel.com (HELO b3b7d4258b7c) ([10.91.175.65])
  by fmviesa009.fm.intel.com with ESMTP; 26 Jul 2025 04:10:30 -0700
Received: from kbuild by b3b7d4258b7c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ufcnM-0000Hz-0Q;
	Sat, 26 Jul 2025 11:10:28 +0000
Date: Sat, 26 Jul 2025 13:10:20 +0200
From: kernel test robot <lkp@intel.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Igor Belousov <igor.b@beldev.am>
Subject: [akpm-mm:mm-new 351/351] ERROR: modpost: "__vmalloc_node_noprof"
 [mm/zblock.ko] undefined!
Message-ID: <202507261304.kdaDjJq8-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: D114740003
X-Rspamd-Server: rspam06
X-Stat-Signature: bkaif86zk7uxzxeq1bw79pb4aaacrcq9
X-HE-Tag: 1753528232-731691
X-HE-Meta: U2FsdGVkX18ejij1BXoYxKtvPzFtrLI48KHZB2lRlqCtDvgrzMYCyJVwV6ogpQXdwE7fGtYGovCmH9DSjaYgE0uboli77Wk1JpstHtT3VurwEVkl8cfK29mAofOwp/6GcRZDZ56Z5cL6nTn+MTcJu2X6tTNVfeDvNAgrT86MsQ+G8zC2c9dOiQtcrh5N1kDvIxKkyS7+hvSZMFAzG+38Wifc+pEvK20GpHLzxaCO+SHR4WctKF77jcclYfWv0QemZ4uy4pF7NikFyUP4Vi6kfjCl8J+8h9Y0dtdnxOcwgrphVsaPbBYLMVptfu2Ebw9Up5KpcqyNY0uunXEYW1SMkIXDrz46XFJ2PvtUIW6kGuJAi1H0mVnf1CG5L6+8Yg4qnvVU5USafUVQh6Mo1xpBQWXlotYgSIJHDs92dk/ZOJ0BTF1k0HAixC7IN7m7DmiOxVcDOCYDMdgdRXNbjlRI2rU18JyhXvuiKHBNkDxeO+P/ihgOqc9rT9+mdNvsVFovaHN5Omebd+o6ADENciGCazHHpJCcLm54PcH8XyC/1vIixWWKxbYuOYV530ZOcLoGaRTICTTyN+RJylAuhJ940JE4wep+ZyOAnGWgllgGz8A1rR6AbyPNFoUwWNh0LQ7FHt3+L1+ZY9w9R1jhdDqd5FYkxmuLPHxiycJweu8uFrM9MPez36Z1F2LBiiWk9A6mvT837YjC3iarOntmiTJeHv8kG3Id4poMIOhp4ppMTKiSs3y8WjNDd95qzp5E1hDkIgd5lTpyE9eqhWPnxi1LoeG0oLBOArNo+5Ko7leBnmzZpw/Q25/By/3+yS7fFAf707fZDu7/l8k/h/RgTg/r19vYHFB1HUuzj/POzgJTwTd4jdfc0IZwOWOtWCn/OjpmVS2hDf6ZsdP6+qBmktk2LVQLmKuf2gvexB5NDcGfiqq3viriWST/1oJ9Z0vIxtjDB8coBpgN8lAMRd+nSak
 IMDorLN7
 2UgyFe36dB6rDKx6tiAipoC/cYg0TF0v3oi1pql9NxiYPxIz1lh4IWQK2rdtQ2qKsxthwcqQtUnT0DBuvaDOs7I9Oqe3i/FKSlI4caMw/BnRRbzHff6WRnLBdnixzfabSDoaS4ORcP5/q/3B2fy+tzYjAwjWScB2b0ZoYnj1oXBsOxHUl9AgM+KgGQ/7eGVtdqFyWY7vFuERZmr4cPLpi0kjFp8VgQ7zjASnyM0m+ZX2usYAsOIWoHpW9MyxT3Qawwg1X8SlCKTN63w7AcNHLCYuOUb58Q+Gseug1RSfNWhCAGEKD2S01x4JHOH8x/mQcKRVwRIX+hGQ70QCBpd11w637ehThjKxMl0A6X6miKBaePdSB9Bmgz3BB5C17XkCCD5xqkO14Men161FcqORiiyvMlwTjSmtHXCc8GgBH38lhLOT/vSaAvq//lPn4GxFqw6Fz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   3dcf95fa6b5546e1b9b5a0b5faac4d5fbf1c3722
commit: f800ea402e875e43aa96e1e6887ada1722760395 [351/351] mm: add zblock allocator
config: parisc-randconfig-2004-20250719 (https://download.01.org/0day-ci/archive/20250726/202507261304.kdaDjJq8-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261304.kdaDjJq8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507261304.kdaDjJq8-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__vmalloc_node_noprof" [mm/zblock.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

