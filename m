Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653CBCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B59A6B00D1; Sun, 18 Oct 2026 21:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DDA6B00D2; Sun, 18 Oct 2026 21:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C94F6B00D3; Sun, 18 Oct 2026 21:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7E56B00D1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:32:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7080405BC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:32:45 +0000 (UTC)
X-FDA: 85337651490.18.A6D7858
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf21.hostedemail.com (Postfix) with ESMTP id 30EB51C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:32:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zmez+VG0;
	spf=pass (imf21.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792373563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D/2L6ediYCoQEHH7aQLiFtTZWbELizMV1kEoTwu0c+0=;
	b=AxPxsrFIRCE7E4XDwwDTJQKmCwYPmk2tHbdmVaHytxH9W3/kJHJkQc85Ve5u+ICIp2+iJ3
	qc2CcCrzIGb1ZyvpTpcJFq9fPKnfI+zcJd/txPcxa5OAAheXIhntHlVfQW683yBc2ZeFdz
	/Z6hn4Rpi2Lp8okft+WSvDB5Ujhmna8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792373563;
	b=IvBTfiTj/lw6TsFMAarfFxcjmv6g+pAvex84sz160ni1xsmXhTmREGQGiD5oeY9D7Wi2Id
	pmbOQmUgwcl/OFmSgBFSXTx6rGHnku1DU986jfzHW8Z4zPExYExtni4JevHwRStOfTZcgl
	kcWu0o1OOMCxZTENJSkQGawwJCB8t7w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Zmez+VG0;
	spf=pass (imf21.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792373564; x=1823909564;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=RXERPTuL/5y/d7hWDRVXc6d/Cd+HYVuMmBfzY3LpxrU=;
  b=Zmez+VG02PPYkvO9eH0GhfrHCU+6+BL4k8upG+I9FyWKB6rbtyWA1v9y
   C5V1/dkYgfPumR5McOFhh4nt9Ud8F18SZ9GJQPIaw7FMPymROa7t7+y/u
   eoUCrFkNr+JpksG676tng6c+bi0Q9mgU81W7cqjau9qurrsOAjxRYWdUk
   VFkDfP00wZUGKgHsHPttk2D6DsJgpmeG8C7sMrOEORK75snguF1g0zQEn
   ipGee3Hjh4ZDLruldwqB7aVZvFFQbDTJpKAv+sr3ppJ21v4ZznzZLZUyi
   WbeprXcg0u0z01U2D4BiMtMaCO7RjnOPz+337i+CbO8hnSzxeZWDvrzMm
   w==;
X-CSE-ConnectionGUID: JKt0dRdrRfuTHLQke0sGGw==
X-CSE-MsgGUID: WsNQPNcGTLeoD7l1T5n5yA==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="1069185"
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="1069185"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 18:32:42 -0700
X-CSE-ConnectionGUID: mNts2OuEQrKepLEn4BeTNg==
X-CSE-MsgGUID: CkNwRCGYSNWthbIVwa2dHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="2728948"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 18:32:37 -0700
Date: Mon, 19 Oct 2026 09:32:33 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Barry Song <baohua@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baoquan He <baoquan.he@linux.dev>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [linus:master] [mm]  8d596d8b81:  stress-ng.mlockmany.ops_per_sec
 10.5% improvement
Message-ID: <202610190949.71c20bb5-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gg39jcwtbi9r4khh9a6ed13eyjtwx3ay
X-Rspam-User: 
X-Rspamd-Queue-Id: 30EB51C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792373562-60374
X-HE-Meta: U2FsdGVkX19i8tXSoR6sNi+gjOKRXH95KDcSnvVj9pHBRBCkQDpSjfYd+CFBuhlxMYXoDIMi0yjiTS5G6YbnbcGUHCod30RRHa9PJmErUCGnRi7xIFLSuFlCNa+pwkzUhCwnlMpheT9WJnh78n1c6MlCDxz2oDWMucaxfN6ncbodPsHgNdtVPW1xk30cTvJqwOh2c8WwIJuc6obH+J8TRAf3v58KJIoynlP00TtL0cyHU4A4Vqnvi1RsJZYlZFEX28g+BQjjYW75JoegQOhzEMb605GSqxf/izN3ioNBNj1phFoHuumx38ukL67HA0Azw8EnfM0QkuRGuaWsnYP99/vLEVJstwlrI+uZkG5DReJmmP8FMS0GLpda8X4z/IbHqEUBZ2DWK/wfOM/Q8rvopwBKOTc2iPza4OZhI/ninZy2af+hodH/CDSCSfXVMJlN/apCgnwmRj435dix7i2HVcPrtGltz9TLEGoVduWPmi7ZElEVYxYeTcaYfUiZBykl35G4cm/F09F/CZ1uQvgb+t2P9xYwQkLoQ3TP4GQuYJ1itAWr4f8oYgueZrZapUTvk6pkxRlTYqF00yAOwNQwYoBk8NbBNAaXp8Zu7Bydi9/NrL45Waps+mSU5TcyN60OYk17Eme4S3cB9zpcMb42G+b+DLA8BGYTZTzHl9PAxiznvdki9qYHw+gAJiIPR+2VhkqbknwgW9rVrZFVvw04J3WFx0ojp2c2ZNkYeyBLOlBQLZRAS0QI2Pw3/6oNFM5tZR+v+rj62cqGkwCp1W0z4v8dPtQ7wOwZDNXunxfySIkYtW60UAdee6m8wr94dVk4Te55BaKa2g5Ps9uWkeI2sVIzZkGrwoIlyA2mh3Nk2F3a1NIubl4EwHyC+UeToXmzR2k6adTGSEi2HcXohkZNyZhaiGTJjBgafNM+TDkMFm6qaFHlIfki/7F5LYHUDHvuVqUB/GManLrGsIzkjum
 CEOLd/ys
 k+rsJ4+OH0+7bvQVzEd3kHKU5kyp8eUOpEH31J4K0J4DXHXWEwt7Bv5dNaEKMfw1ttOLjJBB2sIMmD4s4AApjyyaTCVRFS3lOvUcQie8fUBB5zrE3AizkelycTDhBz5Sak0FfYnShu3d0aJDwnVyNcrjdVT1wfEHiGhvjwwF6g98nz1iDepBOj8Lsv9A5+HfTeUkGYOCDJM0nUqZUa5b1Mj4kvT0dDAC/OMqOaRBKBGk3HzDlYjI0ARMaJnruZO8irxx4qy1JIMUBMkgV1V0vTz+SDvw+LrvKc9ebXNMP/9xigaYjPMME/MRAOyt55mTKIDmDL9rON9z5QrQk8KgW88yIP/mD673HBzGDRLX18Gxt9YIpzZGZJFt3XFooi5aZbQaPahHQxzx7nACDhjyOAYlxVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 10.5% improvement of stress-ng.mlockmany.ops_per_sec on:


commit: 8d596d8b81ef56bf61538d6b4761a7b0d6138280 ("mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mlockmany
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261019/202610190949.71c20bb5-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-emr-2sp1/mlockmany/stress-ng/60s

commit: 
  819bfbd47e ("mm/page_alloc: remove set_page_private() in prep_compound_tail()")
  8d596d8b81 ("mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()")

819bfbd47e49df89 8d596d8b81ef56bf61538d6b476
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1050118           +10.6%    1161061 ±  2%  stress-ng.mlockmany.ops
     17541           +10.5%      19384 ±  2%  stress-ng.mlockmany.ops_per_sec
   2933233            -7.5%    2714192        stress-ng.time.involuntary_context_switches
     76.26           +29.3%      98.61 ±  3%  stress-ng.time.user_time
   2425877            +9.4%    2654908 ±  2%  stress-ng.time.voluntary_context_switches


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



