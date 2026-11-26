Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 027E1606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=msB+tvWY
Received: by kanga.kvack.org (Postfix)
	id 14F936B05B0; Thu, 26 Nov 2026 14:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100B16B05B5; Thu, 26 Nov 2026 14:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016D76B05B6; Thu, 26 Nov 2026 14:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC176B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:12:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DBB8403B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:12:44 +0000 (UTC)
X-FDA: 85478217048.26.1E3913C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id C563EC0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:12:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=msB+tvWY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795720362;
	b=DbhyvMUZSO2nBq3oqM15KIBPOxXbjuWB/pD1x538EFJ8NaNFXdPOKMFsvwKRHrCXBKnuIZ
	Kw529+Ge8CzGjl4eTTj09AYJa1v2vk23S+rXMp82/k5Vht4hq/gpeWwBqXTGGLayKuNzU7
	gykUqbuGfQ6utKz3xT538i3mwlBryXQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795720362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yMX/WIgWWXKdWFq0loUbH9QdBxREazrXEzbmQjJFf5s=;
	b=vGtI4fEfZK86em0F3M8+Tdf1QAkt6FddlWQFxFp97e0DP3V7ZEdh7EHNukvIDU96N0t2fd
	YARySih1GRP0fior1KNfVhLj42Zzt8M1+4mEx2Eb+m5TS+ImN/bxOPyxjK+qpOSDFmgX9M
	lEkIVGtvuXvuY19FADo36zFMqUD57As=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=msB+tvWY;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795720362; x=1827256362;
  h=date:from:to:cc:subject:message-id;
  bh=EyEA8NYw2I5lCV/VMr7fHwN6g3ky5bubMNF+yC1KPm0=;
  b=msB+tvWYxiL085hWniUqN/SL2w0xhtXIdh/NtAAITyeo+S564ezAOI5W
   hFCfswghrrt2alLpuD5imBfZksYN/OYh8mp+puB1csDW3Gw7IVcFB/oOX
   osR5kf2mcIsV5fAstBWuLLIPBBDC5Lvu//1oQnQ06mIqVERt0wbPTq0e1
   fkLFrTs1ztKKCz3tEiPNTFu/Xwaue85VnVIPNRCot3GToIghZCHV/Dz4h
   ovxfJF/W2MqalCxy1RYQDkvxwQtxHGAGk/6nQl1x9ZqSMIlGyBUh2O1tQ
   IqxioRqR8Y75YVms+p3JdrDd6Kjt+t8KmMBKeK7uAlcc5NdbTCT0RXHBR
   A==;
X-CSE-ConnectionGUID: xwN2mlenQEWiF0bqL+64kQ==
X-CSE-MsgGUID: UsrKOKNPTsGOq1nP/uE1Yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4644022"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4644022"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 11:12:41 -0800
X-CSE-ConnectionGUID: wYa/3BwWQlKoWuGQHZWRhA==
X-CSE-MsgGUID: B7ZI9DU9SvuRdwpz8dYPbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="13915930"
Received: from igk-lkp-server01.igk.intel.com (HELO 800201f3098f) ([10.211.93.152])
  by fmviesa012.fm.intel.com with ESMTP; 26 Nov 2026 11:12:38 -0800
Received: from kbuild by 800201f3098f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWetU-000000000A2-1F3x;
	Thu, 26 Nov 2026 19:12:32 +0000
Date: Thu, 26 Nov 2026 20:12:07 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [mm:for-test 8/10] mm/vmscan.c:6324:38: error: 'struct
 scan_control' has no member named 'nofragment'
Message-ID: <20261126200319.fbiL0kw3-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: C563EC0008
X-Stat-Signature: us69z8xt65py41e65ndqgqtfm9jpn7yp
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795720361-923119
X-HE-Meta: U2FsdGVkX1+kF6LUaDma6CpF8bBCkuwvlyy451Ukci5ZYK2XrliIIiCYLsdIVF8q1XKrZ8+wJBWjNk/7GsPsXq1nV4fqPl/b973GkWtv8C7JSmZ/T35swRIz98zW/yJ7Rxkzcu/zBeUWde0mMYvhfOG112+cmCBOwnH29Eb/rgfcw04+NXp38TSUa8Gv7Jdl1QqMlvCkfNCVnPROKBNF1CejDsy+JshHQN2hJnmSl/Mx3tBsmqx76B8i9HsFVYkLKJJUaZFSVmmRGgT9bOLhj/2+mfl8F1OF1r+YB8/7lAX352uZAeofG2xE71GadvSS51nl5EeEMhfig/tnDwwV6X2uz+uex27GFEHFEEDev/wNfsj8ElFFDsvAwTB/qvwbj6MROhkqkbcgCxVRs+lPMWOM9TyWzVtTJcJ2YtzkyFiVh+JUenOiBSrYrteNdMaylBJ6h7/kBSUvAz6Go88otbtdR1Z0++fT/hwOGkvEwiHg4wNjCyigDZaEW02dXByLIjaxAdNf4Sa0ZouXHnoS3f7pObDI7OIl0D3dHLf3oQC5QLSJwNfI/0ng5M+kSxYrk5m06Qq3EvIyaQ0flymO5JsqGVz5p9xURRoP4gJe490qCbmw1+jTYbSroEzOA4BVVs4WKq8oUFEGpNLgwk3uNsWOYoLKElZdtHaBio9+vCB/lc7Kgoc5mFaGAExQfc5QRv4AoS3l5GqA5c/+gkL94zfgEFM3tScToeDNi4gJ7UclSyk9fOkRKvjheseJQnplqEGIkk3hC1Gq2frO6WT3pe1Ffim4wFyICNrfyV79XoQMa4w47D32csxv3bCtEy9gr5vj4nCBhGMpfrDwfXC3HBxdJ5SJIj/4Z3lxGS6z84Xf1a7gYKSBThwO27Kiiptl3ueAPEEV4hDE8VtVi2k4JVU2oxcNTMK2RmL6cNVGc6ig5qW0S/qaVT7y5teJQpKm0RcHMKCQAlI7MiaiMUC
 SsjwWl5o
 +d1AO8je8mkAxATqT+rj6H2DZMLA+jJPZlqJ2hNQQYIRT1mG9KnMK0W4PLLFpS63q/cjEGvz0gWO64JhLtwM9tpLf7zqYg19pZ2SXmlFApYP8Towk64QUEVYVnhQRc7nRI2sNHOAyBCrr638APZbOEdEIF/yNNV4xaALN829PVaMV0yc0RS/wcYOc9ysyNPwJ4ET+xehLYGjHtEUux7vvEFpDjRowvEecpHoti5+TpA2ePtWYCmDOL/RTclQGL/95+Xl4jpAPNFEj15zhmIpGKR/Ilps6WkNuN+5T0nA2O9A/RcFcHd0hKAp1yGYhV6K/ABI/gLWVrJjSLr+NTbuyrcpm3m6q98veD/MJt1/Dtww+8wSiL11fwwGk7W8+ycKmbKu8rpxpF1Uj3kpm0oiOYn4Y/+a6t0cT6mWPUJpH0x/iiWCHWhRjsNEsF9qKG2VtM/2gcjV27z3vil/f1UbIKHKsubu3rFbHDljVX0HDxkHE+QOfWGDT0ZPPlcuvjhYxR/YFQLRFncf1yoP+N+NE3m4knBLPdF8+MoEHT3oRFFHcUV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mm/linux.git for-test
head:   36a5408f22c511a0e2a3105244b88e0f8feb772d
commit: 5cd57ec259efa2dfa64c2b7a48553febb8ab6149 [8/10] Merge https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable into for-next
config: sparc64-randconfig-2200-20261126 (https://download.01.org/0day-ci/archive/20261126/20261126200319.fbiL0kw3-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 12.5.0
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126200319.fbiL0kw3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126200319.fbiL0kw3-lkp@intel.com/

Note: the mm/for-test HEAD 36a5408f22c511a0e2a3105244b88e0f8feb772d builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

   mm/vmscan.c: In function 'allocation_can_succeed':
>> mm/vmscan.c:6324:38: error: 'struct scan_control' has no member named 'nofragment'
    6324 |         unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
         |                                      ^~
   mm/vmscan.c: In function 'try_to_free_pages':
   mm/vmscan.c:6993:18: error: 'struct scan_control' has no member named 'nofragment'
    6993 |                 .nofragment = !!(alloc_flags & ALLOC_NOFRAGMENT),
         |                  ^~~~~~~~~~


vim +6324 mm/vmscan.c

23b9da55c5b0fe Mel Gorman             2012-05-29  6320  
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6321) static bool allocation_can_succeed(struct zone *zone, struct scan_control *sc,
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6322) 				   unsigned long mark)
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6323) {
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16 @6324) 	unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6325) 	long free_pages = zone_page_state(zone, NR_FREE_PAGES);
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6326) 	int migratetype = gfp_migratetype(sc->gfp_mask);
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6327) 
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6328) 	return __zone_watermark_ok_mt(zone, sc->order, mark, sc->reclaim_idx,
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6329) 				      alloc_flags, free_pages, migratetype);
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6330) }
dbbc5a3d50f9c0 Kiryl Shutsemau (Meta  2026-11-16  6331) 

:::::: The code at line 6324 was first introduced by commit
:::::: dbbc5a3d50f9c0404903d4ca31311175fb6aae8c mm: vmscan: tell direct reclaim the allocation is ALLOC_NOFRAGMENT

:::::: TO: Kiryl Shutsemau (Meta) <kas@kernel.org>
:::::: CC: Vlastimil Babka (SUSE) <vbabka@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

