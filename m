Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D698FB3D15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D04A6B0098; Mon, 30 Mar 2026 07:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97F726B009B; Mon, 30 Mar 2026 07:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F276B009D; Mon, 30 Mar 2026 07:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 712FC6B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:06:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3D7DEE0E51
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:06:03 +0000 (UTC)
X-FDA: 84602449806.17.12A7B5B
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B3EF40014
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:06:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j969veZd;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774868761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xJnFjBcu4R7jUYudnmBvBkJSJvG2IjBRLP7dVtDSPs=;
	b=lBcpdCOCFmugTAwGXsh1uYag/f1nTFfxC1cio1sjBPdB1zx3nY6tryGwHNyWMkfsK9VrjQ
	9b8OUXPaN1YUOr/C/kYBcS2kfhTBgFK1BO00mudQ3dZ/lymGXdvHPWUCFk9lZMcjzd0r/n
	PrhwXU6CholXfWzY3kLucVGJB27O9lQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774868761; a=rsa-sha256;
	cv=none;
	b=2cOOnChCw2nnuznpQqEPTZEHWvczuS/2zu55a+MHRNTBjeJOAgqiyGfSs0kfTPbN02H+JO
	q1vdw61UmzbPTQv7hoyonCHTsjuJmuxbQ2HQQqkxIV14oqiZ1Yp1LpXDLknfGHvrmbA45A
	ffwscoD8buBBwrO+qOPSaa40zbqLhJI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j969veZd;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774868761; x=1806404761;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DriSC4j+6v0Vp09GpAv5avbyXZ+yyv/fxsbtJTwP3JM=;
  b=j969veZdBhlaGEXgSuH+kyk3kWylNevd7LI1or1BdK4UR7ilUuPOeMwJ
   RZEsX4JI+glZIgEvIEmnl7xuri01NKVl0zfsJkD14N72XxqKKMvwQbKhY
   zYW8veNrTmCyWQj046tUeZaPi4gRjY9iUxMVQM6KveF2mJplloR0jhKA+
   O5W4Sa2RV8lEKo8SrZCTiv4a1p44NqDYCURb+f0+jB0AX0UjgQuO2WWJ+
   3WJeI4VGfMUY0pkJ0C3cadrxZyAL+G3ORyiegbMNDqDnSUEXIb5DDZNHl
   1rAjB4mhadk78Ey0Xd4SwZZqefdWeSQMQaBgY8VD1PttTi+tKy6p06zin
   w==;
X-CSE-ConnectionGUID: 6anmV6k/RQq839pZe5drJQ==
X-CSE-MsgGUID: AiiXl7hXTZiOH3gh0/LCQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="76049461"
X-IronPort-AV: E=Sophos;i="6.23,149,1770624000"; 
   d="scan'208";a="76049461"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 04:05:59 -0700
X-CSE-ConnectionGUID: nVSPFUITTmOyaO7upa/Ddg==
X-CSE-MsgGUID: xGUTSOsuTm2yOhiKpRKpVA==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 283bf2e1b94a) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 30 Mar 2026 04:05:55 -0700
Received: from kbuild by 283bf2e1b94a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w7ARM-000000000zs-4BDj;
	Mon, 30 Mar 2026 11:05:52 +0000
Date: Mon, 30 Mar 2026 19:05:02 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v7 3/6] mm/hmm: do the plumbing for HMM to participate in
 migration
Message-ID: <202603301832.rpYcya7E-lkp@intel.com>
References: <20260330043017.251808-4-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330043017.251808-4-mpenttil@redhat.com>
X-Rspamd-Queue-Id: 5B3EF40014
X-Stat-Signature: ufsxwhh5uqmxkm97w674q7ikzdct7pgo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774868760-844611
X-HE-Meta: U2FsdGVkX1+yu3ve4E1ChGRVgvLfpR39oKa4QKgJWkJ6V98c/uyO93X7wLhcTyx0eVqWGwl9/pJczOk3l8AhPSX/sgPST5ytprJak4IK8rPD2RqDwY3NVTfiGDVbgak1AfkA2Y5kT3QTa/OE/NMdSiYlZZyYp0GJvlKt3XuMFEbFDbtfVwzYlDOWpza52DrwqIURKakOyg5uin4uhNZP1HmquOw+UDAxMLMQNHlwCDqf8jQol0zkSek37DRJbXp+RhIHxmIe6KQM2uSDAtHxuzxfsC8SRBqcrPiB7Cy2YKuUTNiDymQtk+QF6+AFLCXaRCPPyakdjmDcnrj9U9Yv1xDL/9AVwii46RjvDVTM4PE0BrDRiVwCxmJfK18OxAKmexd60n0Jg2nQ8AY2SFUBdud8LPEMk7ujd5Fij7IXlGJcZY3JjYP1TrL/GVVCFf/q7hFYYY1REGDByZ+2r9AGDvCsxYMUivjCE5cB/baqNATRXkZyVZxT4t2rVtoY986hefVZTT6jf4PSEOFvqYaHSdYrkYXxehcFVOgdWH3IRWYCdNAsXdxNeYwvDee09A0X0eDEgKls7LCT0CBaanmdT3RHbWDy5nIxx7mRpHz3QZz/ZEeyzkR29i11KV8c1y6rDe4s+3yLJCbSGrcV8TPy3TZtA2aL05oQJNIwGWqSlIPuMUHfzvgF5I1nFfmi5C86CY7Zi9sRZBIqWill2NKNtb5s0hcdDm02p2A1eDFFe6S5c1gICY+lZJ0oXntGx00FstBbEFtIyZ5P5ym9b5/0IopHuaQOmSqlkinG0rWA1OjVBI+w5bsyMtUNvcx5Ty8KVRzYRQczvzSEsg/ry31IDMqdVV2Wk74tGy4iFXocuJHiCn/lvDuy2g3VCB4gpZHtMUfptRp/st1S2C928rY/wCx6rC4n5lrp7wOQkA5ixbctVy4JfCQLeq7AtIf2bFQkHwUwyWV/ByuxYfaNu4R
 B8wGr/eI
 7aoDXY217qa+THDw2I8AiLtRsfDDCMEACt8QRIbn+3BqJ8NIzVobegjM/yshbw4s4lhRCmKZ4Cu2Xqtv1hkEIiFt85ZNhXMid5s18bqvziG+3nXovEqfkvv6stfO6qd5FRh85nj9R+gCACg6KLstxc3XkQZaZVzr44DEGBibKGN6e4cKRbfMaA1iqb9Lv8E2yi7coMElJnJ5oKe1ANHp0RYw5RotlddPhOESrsxDpYP2AyCnbzF73+z1+OeqZtW68aNGnQ65VgvR9iu4NRk+ZqECESYAv2C2LXnXRwV97lJMP8QizJk4EL0Smq4ptgxoDj8KNW5WyrN6LHkuRh0Pr/TtW8L+wTl9Iz+RY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7aaa8047eafd0bd628065b15757d9b48c5f9c07d]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-Kconfig-changes-for-migrate-on-fault-for-device-pages/20260330-124915
base:   7aaa8047eafd0bd628065b15757d9b48c5f9c07d
patch link:    https://lore.kernel.org/r/20260330043017.251808-4-mpenttil%40redhat.com
patch subject: [PATCH v7 3/6] mm/hmm: do the plumbing for HMM to participate in migration
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20260330/202603301832.rpYcya7E-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 2cd67b8b69f78e3f95918204320c3075a74ba16c)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260330/202603301832.rpYcya7E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603301832.rpYcya7E-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from fs/aio.c:40:
>> include/linux/migrate.h:114:1: error: function definition is not allowed here
     114 | {
         | ^
   include/linux/migrate.h:127:1: error: function definition is not allowed here
     127 | {
         | ^
   include/linux/migrate.h:131:1: error: function definition is not allowed here
     131 | {
         | ^
   In file included from fs/aio.c:41:
   In file included from include/linux/ramfs.h:5:
   In file included from include/linux/fs_parser.h:11:
>> include/linux/fs_context.h:141:1: error: function definition is not allowed here
     141 | {
         | ^
   In file included from fs/aio.c:41:
   In file included from include/linux/ramfs.h:5:
>> include/linux/fs_parser.h:75:1: error: function definition is not allowed here
      75 | {
         | ^
   include/linux/fs_parser.h:95:1: error: function definition is not allowed here
      95 | { return true; }
         | ^
   In file included from fs/aio.c:41:
>> include/linux/ramfs.h:15:1: error: function definition is not allowed here
      15 | {
         | ^
   In file included from fs/aio.c:49:
>> fs/internal.h:113:1: error: function definition is not allowed here
     113 | {
         | ^
   fs/internal.h:121:1: error: function definition is not allowed here
     121 | {
         | ^
   fs/internal.h:150:1: error: function definition is not allowed here
     150 | {
         | ^
   fs/internal.h:170:1: error: function definition is not allowed here
     170 | {
         | ^
>> fs/internal.h:214:6: error: conflicting types for 'in_group_or_capable'
     214 | bool in_group_or_capable(struct mnt_idmap *idmap,
         |      ^
   include/linux/fs.h:1842:6: note: previous declaration is here
    1842 | bool in_group_or_capable(struct mnt_idmap *idmap,
         |      ^
   In file included from fs/aio.c:49:
   fs/internal.h:313:1: error: function definition is not allowed here
     313 | {
         | ^
   fs/internal.h:319:1: error: function definition is not allowed here
     319 | {
         | ^
>> fs/internal.h:330:19: error: conflicting types for 'mnt_idmap_get'
     330 | struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
         |                   ^
   include/linux/mnt_idmapping.h:124:19: note: previous declaration is here
     124 | struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
         |                   ^
   In file included from fs/aio.c:49:
>> fs/internal.h:331:6: error: conflicting types for 'mnt_idmap_put'
     331 | void mnt_idmap_put(struct mnt_idmap *idmap);
         |      ^
   include/linux/mnt_idmapping.h:125:6: note: previous declaration is here
     125 | void mnt_idmap_put(struct mnt_idmap *idmap);
         |      ^
   In file included from fs/aio.c:49:
   fs/internal.h:352:1: error: function definition is not allowed here
     352 | {
         | ^
>> fs/aio.c:245:1: error: function definition is not allowed here
     245 | {
         | ^
>> fs/aio.c:257:37: error: variable has incomplete type 'const struct file_operations'
     257 | static const struct file_operations aio_ring_fops;
         |                                     ^
   include/linux/fs_context.h:19:8: note: forward declaration of 'struct file_operations'
      19 | struct file_operations;
         |        ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from mm/filemap.c:45:
>> include/linux/migrate.h:114:1: error: function definition is not allowed here
     114 | {
         | ^
   include/linux/migrate.h:127:1: error: function definition is not allowed here
     127 | {
         | ^
   include/linux/migrate.h:131:1: error: function definition is not allowed here
     131 | {
         | ^
   In file included from mm/filemap.c:46:
>> include/linux/pipe_fs_i.h:162:1: error: function definition is not allowed here
     162 | {
         | ^
   include/linux/pipe_fs_i.h:176:1: error: function definition is not allowed here
     176 | {
         | ^
   include/linux/pipe_fs_i.h:186:1: error: function definition is not allowed here
     186 | {
         | ^
   include/linux/pipe_fs_i.h:198:1: error: function definition is not allowed here
     198 | {
         | ^
   include/linux/pipe_fs_i.h:207:1: error: function definition is not allowed here
     207 | {
         | ^
   include/linux/pipe_fs_i.h:216:1: error: function definition is not allowed here
     216 | {
         | ^
   include/linux/pipe_fs_i.h:225:1: error: function definition is not allowed here
     225 | {
         | ^
   include/linux/pipe_fs_i.h:236:1: error: function definition is not allowed here
     236 | {
         | ^
   include/linux/pipe_fs_i.h:245:1: error: function definition is not allowed here
     245 | {
         | ^
   include/linux/pipe_fs_i.h:258:1: error: function definition is not allowed here
     258 | {
         | ^
   include/linux/pipe_fs_i.h:269:1: error: function definition is not allowed here
     269 | {
         | ^
   include/linux/pipe_fs_i.h:283:1: error: function definition is not allowed here
     283 | {
         | ^
   include/linux/pipe_fs_i.h:296:1: error: function definition is not allowed here
     296 | {
         | ^
   In file included from mm/filemap.c:47:
>> include/linux/splice.h:94:1: error: function definition is not allowed here
      94 | {
         | ^
   In file included from mm/filemap.c:48:
>> include/linux/rcupdate_wait.h:63:1: error: function definition is not allowed here
      63 | {
         | ^
   include/linux/rcupdate_wait.h:74:1: error: function definition is not allowed here
      74 | {
         | ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from mm/folio-compat.c:8:
>> include/linux/migrate.h:114:1: error: function definition is not allowed here
     114 | {
         | ^
   include/linux/migrate.h:127:1: error: function definition is not allowed here
     127 | {
         | ^
   include/linux/migrate.h:131:1: error: function definition is not allowed here
     131 | {
         | ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:18:
>> include/linux/page_counter.h:58:1: error: function definition is not allowed here
      58 | {
         | ^
   include/linux/page_counter.h:67:1: error: function definition is not allowed here
      67 | {
         | ^
   include/linux/page_counter.h:82:1: error: function definition is not allowed here
      82 | {
         | ^
   include/linux/page_counter.h:91:1: error: function definition is not allowed here
      91 | {
         | ^
   include/linux/page_counter.h:109:39: error: function definition is not allowed here
     109 |                                                      bool recursive_protection) {}
         |                                                                                 ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:19:
   In file included from include/linux/vmpressure.h:11:
>> include/linux/eventfd.h:44:1: error: function definition is not allowed here
      44 | {
         | ^
   include/linux/eventfd.h:88:1: error: function definition is not allowed here
      88 | {
         | ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:19:
>> include/linux/vmpressure.h:48:58: error: function definition is not allowed here
      48 |                               unsigned long scanned, unsigned long reclaimed) {}
         |                                                                               ^
   include/linux/vmpressure.h:50:18: error: function definition is not allowed here
      50 |                                    int prio) {}
         |                                              ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:11:
>> include/linux/flex_proportions.h:64:1: error: function definition is not allowed here
      64 | {
         | ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:12:
>> include/linux/backing-dev-defs.h:281:1: error: function definition is not allowed here
     281 | {
         | ^
   include/linux/backing-dev-defs.h:286:1: error: function definition is not allowed here
     286 | {
         | ^
   include/linux/backing-dev-defs.h:290:1: error: function definition is not allowed here
     290 | {
         | ^
   include/linux/backing-dev-defs.h:294:1: error: function definition is not allowed here
     294 | {
         | ^
   include/linux/backing-dev-defs.h:298:1: error: function definition is not allowed here
     298 | {
         | ^
   In file included from mm/folio-compat.c:10:
   In file included from include/linux/rmap.h:12:
   In file included from include/linux/memcontrol.h:23:
   In file included from include/linux/writeback.h:13:
   In file included from include/linux/blk_types.h:10:
>> include/linux/bvec.h:43:1: error: function definition is not allowed here
      43 | {
         | ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from mm/vmscan.c:42:
>> include/linux/migrate.h:114:1: error: function definition is not allowed here
     114 | {
         | ^
   include/linux/migrate.h:127:1: error: function definition is not allowed here
     127 | {
         | ^
   include/linux/migrate.h:131:1: error: function definition is not allowed here
     131 | {
         | ^
   In file included from mm/vmscan.c:43:
>> include/linux/delayacct.h:255:1: error: function definition is not allowed here
     255 | {}
         | ^
   include/linux/delayacct.h:257:1: error: function definition is not allowed here
     257 | {}
         | ^
   include/linux/delayacct.h:259:1: error: function definition is not allowed here
     259 | {}
         | ^
   include/linux/delayacct.h:261:1: error: function definition is not allowed here
     261 | {}
         | ^
   include/linux/delayacct.h:263:1: error: function definition is not allowed here
     263 | {}
         | ^
   include/linux/delayacct.h:266:1: error: function definition is not allowed here
     266 | { return 0; }
         | ^
   include/linux/delayacct.h:268:1: error: function definition is not allowed here
     268 | { return 0; }
         | ^
   include/linux/delayacct.h:270:1: error: function definition is not allowed here
     270 | { return 0; }
         | ^
   include/linux/delayacct.h:272:1: error: function definition is not allowed here
     272 | {}
         | ^
   include/linux/delayacct.h:274:1: error: function definition is not allowed here
     274 | {}
         | ^
   include/linux/delayacct.h:276:1: error: function definition is not allowed here
     276 | {}
         | ^
   include/linux/delayacct.h:278:1: error: function definition is not allowed here
     278 | {}
         | ^
   include/linux/delayacct.h:280:1: error: function definition is not allowed here
     280 | {}
         | ^
   include/linux/delayacct.h:282:1: error: function definition is not allowed here
     282 | {}
         | ^
   include/linux/delayacct.h:284:1: error: function definition is not allowed here
     284 | {}
         | ^
   include/linux/delayacct.h:286:1: error: function definition is not allowed here
     286 | {}
         | ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
--
   In file included from mm/shmem.c:73:
>> include/linux/migrate.h:114:1: error: function definition is not allowed here
     114 | {
         | ^
   include/linux/migrate.h:127:1: error: function definition is not allowed here
     127 | {
         | ^
   include/linux/migrate.h:131:1: error: function definition is not allowed here
     131 | {
         | ^
   In file included from mm/shmem.c:77:
   In file included from include/linux/syscalls.h:89:
>> include/linux/sem.h:18:1: error: function definition is not allowed here
      18 | {
         | ^
   include/linux/sem.h:23:1: error: function definition is not allowed here
      23 | {
         | ^
   In file included from mm/shmem.c:77:
   In file included from include/linux/syscalls.h:95:
   In file included from include/trace/syscall.h:5:
>> include/linux/tracepoint.h:49:1: error: function definition is not allowed here
      49 | {
         | ^
   include/linux/tracepoint.h:75:1: error: function definition is not allowed here
      75 | {
         | ^
   include/linux/tracepoint.h:80:1: error: function definition is not allowed here
      80 | {
         | ^
   include/linux/tracepoint.h:85:1: error: function definition is not allowed here
      85 | {
         | ^
   include/linux/tracepoint.h:92:1: error: function definition is not allowed here
      92 | {
         | ^
   include/linux/tracepoint.h:99:1: error: function definition is not allowed here
      99 | {
         | ^
   include/linux/tracepoint.h:127:1: error: function definition is not allowed here
     127 | { }
         | ^
   include/linux/tracepoint.h:129:1: error: function definition is not allowed here
     129 | {
         | ^
   include/linux/tracepoint.h:159:1: error: function definition is not allowed here
     159 | {
         | ^
   In file included from mm/shmem.c:77:
   In file included from include/linux/syscalls.h:95:
   In file included from include/trace/syscall.h:7:
   In file included from include/linux/trace_events.h:6:
   In file included from include/linux/ring_buffer.h:7:
>> include/linux/poll.h:43:1: error: function definition is not allowed here
      43 | {
         | ^
   include/linux/poll.h:63:1: error: function definition is not allowed here
      63 | {
         | ^
   include/linux/poll.h:68:1: error: function definition is not allowed here
      68 | {
         | ^
   include/linux/poll.h:74:1: error: function definition is not allowed here
      74 | {
         | ^
   include/linux/poll.h:79:1: error: function definition is not allowed here
      79 | {
         | ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   20 errors generated.
..


vim +114 include/linux/migrate.h

   112	
   113	static inline enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
 > 114	{
   115		return MIGRATE_VMA_SELECT_NONE;
   116	}
   117	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

