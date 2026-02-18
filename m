Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C112FE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 00:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110B56B0089; Tue, 17 Feb 2026 19:16:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0910A6B008A; Tue, 17 Feb 2026 19:16:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4E66B008C; Tue, 17 Feb 2026 19:16:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8A476B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:16:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B6601B474C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:16:29 +0000 (UTC)
X-FDA: 84455660898.14.8ECD358
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id D213C20002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:16:26 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VAKBQbyK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771373787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIBL72HywDtQAgr6LdqL2eR9ENXwZGMt1omtN6JdF6I=;
	b=dreI96U2sY5YxMTY5RnTEZfXTiNtwHWecgGBTSsz8ULUW8Z/bAfFE1ZS74Jvsp8/mpqiNf
	12RA2BqngsL2nsc6C+IHjRcSYduRqgv8Bhs3wI2mOBlTXg+kYXjaBii1Whb1S4CcSR9ewP
	foVCxpKu/zkusTOyi6myHEMhDS9JnaM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VAKBQbyK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771373787; a=rsa-sha256;
	cv=none;
	b=H6S9j8h66dl81O0K7m3CbXh+Og6agHm1W92bivDYev8KohVHVri+vVe0RnHsYrtOZtji9E
	EbBhLRjMpME0CkHOmQGYMzy/l+Ose7N51KXocXVNZaNMG6lZIYvL/Q3mPxgkttZMvw0E5X
	dIbbRxTRRc1qdXiuxe3SRTTzry8fOcA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771373787; x=1802909787;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=df97MMO2eoNDCxasH4a7NtVpAoJ7yeCuVAaORQvW+ao=;
  b=VAKBQbyKUp+O6xNnNXeX/YB7FBk9QViszixkm4y6/qhCYKfrL2UdCunw
   BFM/a7oewcoNhk3qAzzpP7h72TufrxOjOm79FIVF35IdYuWsKXTfYPAru
   QB2fnVwXTvJY0nbCinb+qZ8N/8kppImKyH9dMbG8A2WbAslHxOXBiHurv
   birnSpL/yXRE1Tbvqv/a5Ocf2sZ3Nws5+kEG1WlvAufHu2bvDirmDRsNq
   n/4WpntZwasCaHNkAGgtnSA3aDGwIL2vGmqgXUgM+otaoT1vHxwPfGpPO
   Aq1OTZzPIy4Xju0Dqg3DTnMFgUUdj8DVP64fPaSYdoESnSav3IPHap2eC
   g==;
X-CSE-ConnectionGUID: 4GYFgNPsQEyWzDLCbSLesA==
X-CSE-MsgGUID: 3EdBPU0wQD2Hi7yReOJ0vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72353838"
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="72353838"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 16:16:26 -0800
X-CSE-ConnectionGUID: wEdj9cgFSY+Ly9Qou3PwMQ==
X-CSE-MsgGUID: 5ZXTv6PnQjCNZfdxKwT8kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,297,1763452800"; 
   d="scan'208";a="217923992"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 17 Feb 2026 16:16:23 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vsVEq-000000011rU-2EYe;
	Wed, 18 Feb 2026 00:16:20 +0000
Date: Wed, 18 Feb 2026 08:15:45 +0800
From: kernel test robot <lkp@intel.com>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com, kernel@gpiccoli.net, gpiccoli@igalia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Mike Rapoport <rppt@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
Message-ID: <202602180841.dpP5OelN-lkp@intel.com>
References: <20260217195816.861684-3-gpiccoli@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217195816.861684-3-gpiccoli@igalia.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D213C20002
X-Stat-Signature: wfe5asczkngtmo3e9a7sk1azdrfrou8y
X-Rspam-User: 
X-HE-Tag: 1771373786-279635
X-HE-Meta: U2FsdGVkX18VIvWV8LbkOUmaSp+JcTo/7Mner/cByJEcuNRzO2XlBrJEGstIEtOpVI7rWo9Ga//cJOCOKnJLep9Oj2l48TJ3no41KICg4jHbC05A6iDhVLAO675NBkhUYplOSlpJAoi/E19+Q/tQHV+keARh4Y9wOt9EEUkFeSn2azQqsjMDBn2q/4tf6VTF3NEtVoYuDcpfnhQOQfzxk3ywXqnl0jYiZYt69dsRnfB7YgvBajzDYZZ1ln16pgsS2e10FLUubml1iUY5lOiudMwpvscc2lryIfNDA/OmU9gq2y30zafeJB+8xNNAOJQPdCb0fdj66rCWWooeFcWIqzwGvU0jo4mwaQUu9Q8AhYibgKRvCxMbbXgCAGWRF/xSG5fH14JetOOuBPNAz00EOaltZWWGEONcMRNZO8m+LNCc5e36P7eSC+KSJbBzafns3v4BkqZMY2StWmOiCvReazzbXB+Cdo8rqCMHLdhYaGzxxUwOPsba9cQI1fYF7Td/Ustn7CECXVzHbm+qIXJjVNr79mkqDKddgEEiF9YAl7WOfjtAAcJR3zqo8KwoOC3JSoNOupgajwsgAm0BSXI1SBgzDzcDB5JDin326xfD5MsmS4er2CKxxwwWX7aUcBecSuFmElnh2+eWgT1yfiRLBr6Fc+pJL53J+csPTq3CZQwUdCuftgcgW0jHmFFbePVlpYzuPDQMZ8qrPAHYKyeeskqSof8kAul8HBpYQjSTw8an/8TKAp9nOqXVErQ794lWwuhNld0yAdYY703hnCI7lrt6BsQOvbnMf6wy1a7/MRnX7lfeNM6t3TYXUycyt6X+qwE+Kgq9JNEPuGXWLK3NtShRQLwex92ZMnFLtwxN4NTeO66fh8G/irdrU8w3QCeijkiMXUShiE1FP+9myLX1v7JcKw2Pea9/wlg34gyHM0tBRTNfgJTwqAkwPeE08WEo1a4o+9T4wvf3n435+vd
 7MLN2GJt
 ieubeVT9DPE3yFPC0qvJlwLHns42TnsG/t7rYBJlXhfT7afvPFZT66G/aHFjg1bKoXzc+xOXdMBbumuvLurw8IlmILTrd4eUaTq/Mi2y7ClMeM5jmFYj8LlQgkequY1wIRloW649maQOtLm+zGso7FlR2xVaXMc5g1iKs+yJX1Y+eosiJ4nUhitu6y6HFnIOrh24A31oTDB8eEQ8UxXS5XgMSlBsOUmlnOFk4ZcwjyMhiQPn0TrEVu2wpbj1aTyZEkyIXVYMdowe2WxwByChxg/VQUHGojmZvVakF1Gja+8W6C/O5cj8zYWNv7sPGQvlAHMLtCAvc26ZP5CiJ1O4B7DEpB6QqMiqNgq9hhJQS+i6dizY9/MRz6vkAt6HJTFhW7R/4af+xwA+yxR2GjPZLDRKHhWBjB/IASAWqa4bH5osE9epdwYk6h88flzhHE2tMf1IsZF4dLFAuEzs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guilherme,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rppt-memblock/for-next]
[also build test WARNING on rppt-memblock/fixes akpm-mm/mm-everything linus/master v6.19 next-20260217]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Guilherme-G-Piccoli/mm-memblock-Print-out-errors-on-reserve_mem-parser/20260218-035935
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
patch link:    https://lore.kernel.org/r/20260217195816.861684-3-gpiccoli%40igalia.com
patch subject: [PATCH 2/2] mm/memblock: Add reserve_mem debugfs info
config: xtensa-randconfig-r071-20260218 (https://download.01.org/0day-ci/archive/20260218/202602180841.dpP5OelN-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 11.5.0
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260218/202602180841.dpP5OelN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602180841.dpP5OelN-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/memblock.c:2721:27: warning: 'flagname' defined but not used [-Wunused-const-variable=]
    2721 | static const char * const flagname[] = {
         |                           ^~~~~~~~


vim +/flagname +2721 mm/memblock.c

1e4c64b71c9bf2 Steven Rostedt (Google    2024-06-13  2719) 
54091ffecefa11 Guilherme G. Piccoli      2026-02-17  2720  #ifdef CONFIG_DEBUG_FS
493f349e38d022 Yuwei Guan                2023-05-19 @2721  static const char * const flagname[] = {
493f349e38d022 Yuwei Guan                2023-05-19  2722  	[ilog2(MEMBLOCK_HOTPLUG)] = "HOTPLUG",
493f349e38d022 Yuwei Guan                2023-05-19  2723  	[ilog2(MEMBLOCK_MIRROR)] = "MIRROR",
493f349e38d022 Yuwei Guan                2023-05-19  2724  	[ilog2(MEMBLOCK_NOMAP)] = "NOMAP",
493f349e38d022 Yuwei Guan                2023-05-19  2725  	[ilog2(MEMBLOCK_DRIVER_MANAGED)] = "DRV_MNG",
4f155af0ae4464 Anshuman Khandual         2024-02-09  2726  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
4c78cc596bb8d3 Mike Rapoport (Microsoft  2025-05-09  2727) 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
d59f43b5748092 Alexander Graf            2025-05-09  2728  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
493f349e38d022 Yuwei Guan                2023-05-19  2729  };
6d03b885f0926a Benjamin Herrenschmidt    2010-07-06  2730  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

