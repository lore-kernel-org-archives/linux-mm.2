Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B941606A326
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=T5I+gVlw
Received: by kanga.kvack.org (Postfix)
	id A42926B05B0; Thu, 26 Nov 2026 14:23:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3726B05B1; Thu, 26 Nov 2026 14:23:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932B76B05B2; Thu, 26 Nov 2026 14:23:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 719D26B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:23:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD4501C30F3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:23:42 +0000 (UTC)
X-FDA: 85478244684.10.992EE28
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51E13100006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:23:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T5I+gVlw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795721021;
	b=OH8/tEk5fMyplxM4APihyvde7xRgP/YInFZWHlzlfwOoei/v/C78pSL6EhkY/DXgVfrMHv
	tQkoju+t1p78nqQ4hmjVglCH+fQdrzhkg596HmPsNbq2rHB7LBLnXqdxzOZahkeZw81Jdx
	gIsyXGamMRktoPavI0DyO5wLyiyAT7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795721021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=reZx33itXesoqpLVrB5YcOMc1lHHTizPKhzfToZFD5c=;
	b=UrGBBVtypaf1+CDeELugpqphgQzxzgNWL1ogXvEJV18tls0XvXZogKLuLqWEgNElWRQ/kP
	Gc12KPtlN1YxgoZ/MqKUFrGU7ku/XrdBOcAVtvhQPyj15D/lPB1MhF3mNNpdQaQbqyQH+6
	MnMqIVn2MG5JyD/YRhBUv0fAVXUClIs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=T5I+gVlw;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795721020; x=1827257020;
  h=date:from:to:cc:subject:message-id;
  bh=LZwtRVPVNQ2nUITxTNK1eMCihSKO8HeFLYAh9JB3L7o=;
  b=T5I+gVlwIST2yw79kEcARNFNqPF0bBT6VRXYAqnuxnGpMKz1O+rqMF8Q
   Z1G6sn64rPujPmakMjsQfdC0D+7zVxxBznno/BZ4GZUFCvxelclC1yyS8
   VM2SE4e2mPcBi4XomQsFyq7MK5vPh4DKXamMRc4wl8Hywhv0tyR0YmLii
   3DY7X01tlTlfk4y9XMBxmLNRBCX4gryCvgdMUH7vaHIfbHiN/eyxbKcir
   EfnCR+VeE5hjwMjYOPsvOq5XsCje9PYVbWDTvDs3/hrDi1rfAyNzhSNYK
   3DXz1Xx16nNOnVpn2UqLhla8xAFlBOKXMHzqjxQ+N1vdbUzaHJWZwHD6M
   w==;
X-CSE-ConnectionGUID: h2ja5HKLTLCK0JavcLdFZA==
X-CSE-MsgGUID: 7OLjwWy9RRmrLy+UiL4E6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4546406"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4546406"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 11:23:39 -0800
X-CSE-ConnectionGUID: sZGTmspiRaua58rsFZcf2A==
X-CSE-MsgGUID: xD7piIEORZ+3BBD+O+YLTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="14275948"
Received: from igk-lkp-server01.igk.intel.com (HELO 800201f3098f) ([10.211.93.152])
  by fmviesa013.fm.intel.com with ESMTP; 26 Nov 2026 11:23:37 -0800
Received: from kbuild by 800201f3098f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xWf4B-000000000AK-1nFF;
	Thu, 26 Nov 2026 19:23:35 +0000
Date: Thu, 26 Nov 2026 20:22:49 +0100
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [mm:for-test 8/10] mm/vmscan.c:6324:33: error: no member
 named 'nofragment' in 'struct scan_control'
Message-ID: <20261126202045.MhMXQxU2-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 4wprgeyhdmns3q3zygmndg3rhd868m1m
X-Rspamd-Queue-Id: 51E13100006
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795721020-773881
X-HE-Meta: U2FsdGVkX19OrOjcW8UXe6iG6XPGvYDnWw6mUmLxo/HByVe6NG4mwVQQ+jQRExKeeICV3QTZhOH5dysAgd5Jydfghc/A9TjuLmV3UsfrJawaL5J2X7pZnl8CK+BENLIeLqadLF/iOA/YkJ75Pi/EvVKkrSaM7TSSfEGPps3qbwQ58EF5ti1eWedXJxEWyYie5pyRnu+PCOvq1rCNz2bwWNJtppssA8w3qgRvU6OHrGU4zCnMnsgOn71iawzNpgQMGwRhI7GfLHVreo2N7LE66h0DuECHkX/Fpf2lnPyXidNc5krJSa5b/hbH5fY9/5Gob1n2xbKb/tUyIVAaFy1fgGVa+uicbSPJlMWJp7lvbfYJB2Hbt8NGrMIuOgjRIAn8jh7euOB1t3dcak/fTZeqNQW5QCs5EdzzGbQjbU5wTllO2ORvnXqm+D++Cyo5vZL7W8GfwPiNOP0FWrFopjQdQTchzvN701HUg1ccD+CjWJXEzG/SAhXsJsiOLRF/cgEvDJU8CqDlmgkWtRbu2UObYJ6MjtlHGTlmvp1s6WbpYVo+PRxTTV+TECg+3GkNxSUk5Ur4abFv1ze1OPonR61c619KEcCbZbGZeFvzeIEya3wx+pFRYQL6EGZguMNPbETHJ5hhgHAbseYv+jbJ0Hq/bee0ow4AL6a93FPnafsckSNP6CYrIeqJDP773zD19WhM+XVDHBM9ea4QSLYom+KRgbuzxhkLO9rMcAWAZ6UF2rqPCm6yK0ORuTCHS5ApmIBcdkE+eUWl55KwoV14q+Kgm+374v6a+u2z4MZtieKKtDTabEu1wbNMaY2dWotGnkirRZxrYgJYqSsuQ/ktrwKfL1FBwOAPKpygfreIJHtGv4fP/f6LbUCCLrdM3p5RwtnFZVDNafDnVSKCiJyqltxhGNW+Qr7ADfMLejYnBrkc3axwR/XtPmMW/hG/OlVYYmSbmTr4NuQeDpysNtsS7AC
 chCGwLrf
 /erFkpPHk7rY6+6vc5UkS4qD13RJcYilzy+K77okNNa/DMrwXARdIaS677/Ssq6+LstkiIXAZY/OCpIswofaMdGjM1XaHnN0UAFPWM4I5LBa1Uy61T1Wh+5lR2rZpF2JnXzsjb3a2hXQImaGQnuVH7KdTOKidhHkWOnvfPmCM8gmIOlTjaLywnIBBgQ5uNChzDTyN3NuTFICXvSFsbLhL/wBiz+urLWYuJG3Dr+Y+QzPBqdknn6ltCssg8DAbcSeME8kZ6kyYEZYMjiet6eY7Hnx9DOzAA73hn3aTF/L/Cf7Xc1DRd3ulDH7hr4MlDMuA/gY/C+toI8zpqO29rzVB6+jZ44MBzgjsk9r/+QpctN7IY2kzgOEMO3Aju1IAubEDT20cpVo4wWtFQmFJ+QqczGWjsqS0Eh+QlW3i7k0crHTZ/DVhHULGII01vAf5IBJP6Ta4Wspy6SPDZdI3yB4n0ZFxJyNkuUc7LeLZS1QVC4o+YLm+0m15SM5Cv7cWBuG9nptFyQPG3fPw86mzMzStolRkGz1E3Rwctv1ZKP98lLnebBA=
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
config: hexagon-randconfig-2200-20261126 (https://download.01.org/0day-ci/archive/20261126/20261126202045.MhMXQxU2-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
smatch: v0.5.0-9187-g5189e3fb
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261126/20261126202045.MhMXQxU2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261126202045.MhMXQxU2-lkp@intel.com/

Note: the mm/for-test HEAD 36a5408f22c511a0e2a3105244b88e0f8feb772d builds fine.
      It only hurts bisectability.

All errors (new ones prefixed by >>):

>> mm/vmscan.c:6324:33: error: no member named 'nofragment' in 'struct scan_control'
    6324 |         unsigned int alloc_flags = sc->nofragment ? ALLOC_NOFRAGMENT : 0;
         |                                    ~~  ^
>> mm/vmscan.c:6993:4: error: field designator 'nofragment' does not refer to any field in type 'struct scan_control'
    6993 |                 .nofragment = !!(alloc_flags & ALLOC_NOFRAGMENT),
         |                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   2 errors generated.


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

