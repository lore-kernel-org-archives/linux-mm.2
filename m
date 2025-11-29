Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B27DD116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB386B000D; Sat, 29 Nov 2025 04:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77936B000E; Sat, 29 Nov 2025 04:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB3996B0011; Sat, 29 Nov 2025 04:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAEE56B000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:08:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51BE81A08B2
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:08:01 +0000 (UTC)
X-FDA: 84163067562.28.48C3979
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id B4CE620002
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:07:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QjR5pZrB;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764407279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xba1EYyhemTExnicMR3JLsveK87vtfAOSaiZRNOcKLo=;
	b=JEUGxoXvT1yQfYuwGATeKnpoafbRDkGFoZNAta9xSTDhuPNmhOvbOZdgW6xfzz+l2FPxQd
	LzH4Div5X+xIq21mOz2mSq2lid7+J3u01Rya5h3RPl4rZk7vzBZs4Zp/Pz2+x3C99ShLzt
	e9O1zyy7R82RfCvwENxWYvPQkEybgu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QjR5pZrB;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764407279; a=rsa-sha256;
	cv=none;
	b=ukSPGJguZjpshezpV+E7oKS2GddIkO12l5XFVkvRMz6gYoGZV/kXkzvcFEq2PGr4ErpPr0
	HkrISess5pf94rWzB0RGf9CvajI6cNwQ9zi51Bf3spovH6wm5QisldCym3c0Wy15z6cSeF
	C29pQUGWOMbo5nnovdm8WsSXozNFt+0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764407278; x=1795943278;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LaFWmCSuL4KQQ+UT/MEIhGMRgAIrz8Sy2tDbRWfHTC8=;
  b=QjR5pZrB9GtKjpMNiViSMLu00pi45ypuOK/qGG9v6+2VNKB80jySinuH
   2qvF/28EgU0N2/gKUHpOvlPGTvf0TEF7SYsIIBbFAjgjrTQRSXHocMaVd
   gNuci7fi3nOeSHHL7cdWCPUTm5OmejlezN/7HGhYL6Y8S/X3pdoOzzsxA
   nC2JBCqm0nHBGWUd6IQy1/jVxUmGszYXYl/UMH2ME4UEQyI2Ja0PDL0KY
   nPjw2om4v0Qkg0WaPR17CvWTRxafnJ4No1+G8w8+6I94chMYRqsssLZfb
   i2mmWoIs+CHOX5WWqAOFx/lMmVuisEdYNywCTtVczvCul+ebs6qHablbo
   w==;
X-CSE-ConnectionGUID: gjWZGj0KRi6KNOqN0d0uVQ==
X-CSE-MsgGUID: BaWLw3k7QsOAFAOSXQ7FUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11627"; a="65419290"
X-IronPort-AV: E=Sophos;i="6.20,236,1758610800"; 
   d="scan'208";a="65419290"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2025 01:07:56 -0800
X-CSE-ConnectionGUID: fmPpZhEQRmiKI3VGGnD6Uw==
X-CSE-MsgGUID: Iv5FX28QRx6kcI6sEUS0Pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,236,1758610800"; 
   d="scan'208";a="193289632"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 29 Nov 2025 01:07:54 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vPGvo-0000000074r-1bCf;
	Sat, 29 Nov 2025 09:07:52 +0000
Date: Sat, 29 Nov 2025 17:07:17 +0800
From: kernel test robot <lkp@intel.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
Message-ID: <202511291628.NZif1jdx-lkp@intel.com>
References: <20251128170442.2988502-2-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128170442.2988502-2-senozhatsky@chromium.org>
X-Rspamd-Queue-Id: B4CE620002
X-Rspamd-Server: rspam02
X-Stat-Signature: tpkpdwtznj7it3oixssr3xgp6to7k6h8
X-Rspam-User: 
X-HE-Tag: 1764407278-574567
X-HE-Meta: U2FsdGVkX18Uby1yFKHGH24tZGC81NhFM7bkWBE6gHu2HMk1XyrJxqHKu6hMAFONJVTPD0tVpk75UQ+GUMF0ru7X1Xg/7p7MQQU0DanMuVtYzvh3geVY3tRR3A1XZLPB+9W+gPgm4IC+8ICrBtRu8WzyTJ8Jye2ObnFdkIT9ZrvMHN/s2Mx3IQL8WJR1I05R2vLb45+1gRJowZLeOuPrzezMINXND+TD8tD0t3X3WotNTM9rcNdep6PBBEyOf8xWYDr/lxiOA/Olc7cCUs44lNCkqU5nUTHR+6vRdPCeBqkHkA8UQc6qDQb8YlebN+npcN5m8KJP+Gs3+e1f/G0UYuJRTtUPdp5XRYAMUI+DFH9O+qQuOaKjhGjRwGnd7ni2FxK3ojlyvuFx0DLqcRzmyzh0KpjKLLJ0jQufjHtqA+iqi17Jh2qpaCt/CqjsadTcQ67DOBXLsklgWWH5xBDR5TxZhn9cvC/HyeZJuQRnc0lmte7FiqWlLmtMCqORGSo/wh9fkUnlpjGhpqmsKdgP2B8USyMG4Sx2d1R9HUVen4vHiS4oz+jmhhjJiCqk27C5MGtR+2I/173acwZP9DLf7G2laBc1ynDfVMOsQ7WxHMK2eT0vGmScG9i4zOQWQJE6RZiQjWa2/4JGfvXKNUdrD+JtYk0O4AqCH7lhhVKcF/hYFJPB2XYlYiQyGY8Hk/BS+0BFbYsDNyFwuzshZP0S6ETle7PZ9y2uU4QCxZpxFbhk+ZQKj/kL+FlNyeoQyot9oDZIghBOguAW7AVRqYGgVkL4dr9fi+rW/CYPGweOvHYe5WiDj0EsMrtjCPpfBX58op21AFEpseg2lEI8G6lx9ermoEf8nUImJ6t8gh56wUi9xlJ477NpYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sergey,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20251128]
[cannot apply to axboe/for-next linus/master v6.18-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sergey-Senozhatsky/zram-introduce-compressed-data-writeback/20251129-010716
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251128170442.2988502-2-senozhatsky%40chromium.org
patch subject: [PATCH 1/2] zram: introduce compressed data writeback
config: x86_64-randconfig-011-20251129 (https://download.01.org/0day-ci/archive/20251129/202511291628.NZif1jdx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251129/202511291628.NZif1jdx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511291628.NZif1jdx-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/block/zram/zram_drv.c:2099:12: warning: 'zram_read_from_zspool_raw' defined but not used [-Wunused-function]
    2099 | static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/zram_read_from_zspool_raw +2099 drivers/block/zram/zram_drv.c

  2098	
> 2099	static int zram_read_from_zspool_raw(struct zram *zram, struct page *page,
  2100					     u32 index)
  2101	{
  2102		struct zcomp_strm *zstrm;
  2103		unsigned long handle;
  2104		unsigned int size;
  2105		void *src;
  2106	
  2107		handle = zram_get_handle(zram, index);
  2108		size = zram_get_obj_size(zram, index);
  2109	
  2110		/*
  2111		 * We need to get stream just for ->local_copy buffer, in
  2112		 * case if object spans two physical pages. No decompression
  2113		 * takes place here, as we read raw compressed data.
  2114		 */
  2115		zstrm = zcomp_stream_get(zram->comps[ZRAM_PRIMARY_COMP]);
  2116		src = zs_obj_read_begin(zram->mem_pool, handle, zstrm->local_copy);
  2117		memcpy_to_page(page, 0, src, size);
  2118		zs_obj_read_end(zram->mem_pool, handle, src);
  2119		zcomp_stream_put(zstrm);
  2120	
  2121		return 0;
  2122	}
  2123	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

