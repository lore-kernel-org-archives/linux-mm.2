Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A816DCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0E96B009F; Sun, 18 Oct 2026 21:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B81116B00A2; Sun, 18 Oct 2026 21:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A984D6B00A3; Sun, 18 Oct 2026 21:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9158E6B009F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:59:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25E041205F2
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:59:15 +0000 (UTC)
X-FDA: 85337718270.13.A6D03D8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id A2EBE180003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:59:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="d/ldGeBd";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5A3o0YyXGxodAzwdKg9agnXDUoySQjN+sSNyI0/Yu5k=;
	b=tpaWJ+muB2md41/fwcAJdbeQmlr6X67ydyv5e18zJCR3I3AXDZmxMl01L318OOohBWzwmc
	os3kXXlMGNCy83h3E3AiCL+igopKt6jzTCTOAWMijuQ0rePx6xsdeTXTCATMevsw73gbCC
	Ucb/1GMWUTUQoLaLiOs/N87C5Cjyh/c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="d/ldGeBd";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375153;
	b=Im2PhlxjRihIOwZHHnyxu3glQ83ClrPR7/tW4DSo4MKKwV+yXIuCLZ0O70KojOithQLYNC
	cEl8AZ25Kta8S/yQ3lWd2812PavHxNHD8TZQ59Ddx7IfL5ojEJ+yDQKnDHhsCfWwG2HgJR
	FL2itZxv9+q8y/Rs8F4a+B8FqbQkrHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792375153; x=1823911153;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=7fnx3dXsI2wRJdwIsrpwQJW0BoY5IQYr8pQyudxvv9Y=;
  b=d/ldGeBd69D0MpwfvW5dwJ11MCa0T/+dEtZKo4RNNFuaKF5opXXHWo5C
   oxFtzSj3zlkVliDO1z2yhi9R35dTKkoUJRm/+wMAKjX07vLIBZflPtrbX
   84zprih3H72aDN8tGq489YEgpVDg2uK3WOk+KZqlvYP6j75l4GWp5FKtq
   KGCGm7af8EQzawyR8mR5HklCkFDnMi1bqVFOmReDNryNMo6bdMqpykw9C
   tYOJLjCQBfrinzHBXuDNOf2XmK1EIZCT8htaS7vaRvKck04Tba7sfma+K
   FDzC7o1gDuhorzDrdxAvQp8hdXpkJvmuSiWMvp0yhqreHcPs0h6s7Cmj+
   A==;
X-CSE-ConnectionGUID: RUAxmsOGRH6s5jYIIDDPSw==
X-CSE-MsgGUID: bYBFYXu7QfWt2Xva2yYQmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11939"; a="924658"
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="924658"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 18:59:11 -0700
X-CSE-ConnectionGUID: peGbbfOhSn2jwTT84XRp+A==
X-CSE-MsgGUID: rwe68dC6Tkma6YgMmPfUFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,166,1787036400"; 
   d="scan'208";a="2839779"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2026 18:59:06 -0700
Date: Mon, 19 Oct 2026 09:59:01 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, yi1.lai@intel.com
Subject: [linus:master] [mm]  7625cb5673:  stress-ng.mincore.ops_per_sec
 28.1% improvement
Message-ID: <202610190930.7aeab52b-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A2EBE180003
X-Stat-Signature: kbheo5juspa5cfnomw18anwqbk51w4c6
X-Rspam-User: 
X-HE-Tag: 1792375152-850079
X-HE-Meta: U2FsdGVkX1/4xDvh1MLymZIJ2/ZxvI7IrXlRqV0Rr8fXv+NXpUF6MKYWU8batGCeShqvmW+S488JbsW7/MKYEuwwNGMFbUquNKAyiRxaD+/4EiguS8kpjgN4nGnMzPkqlIHJaNmGWGfmLbGHa4h7jROy4Z3RCP0D5F+dzDEaoJwJUWU+tiv9jPRSdaI/v34bkUGcdKvwssYfijX+QX9RBBHOMHYe1gQPBzqeqB606fzFaYZY3xUOzaHrRX2okFtnuxZb0Wajj2L/6H6Q1JmA1XrS2MfbCgjMjUx+iOILnvKP/3fUY023yomJL/D/wsptb6hcY8z0lVVUy82bWgbYMJGeAdXHDAeksLVLvdaVw3+ivqbkJ79MhRPpbiFpk+TDgvg2Xy/lsNIl7fWmS4MA/Qub++4hYW6xEGyujQ0p/11zJOgYsE+z0yjzji/carzV8YFh4dMaL/PN+hGBJJmGTGIY71AKawdDhaCL05kjJEXgY/I5dfun2Jp3x176cko9HSTElD7FwViEcL04vymcs6Gf2J9gdbp50mQXgtTTJN9kwZWt0I67MvFDpjS3k2JLO+htytnJOM4k480l4h41msry42AeM8xcKi6WTAhlQjkH4UJ77/XVCf4Irgi+jW4vMxhW7sUp/LoSIFNWT2E3wG0hqyhPms5XW/fzxlfKVYRmpbpX0FuGHTWzDuh+STKjeeRXiGSyzot0BJyS3M8WcvJtIZ78APPkcrjFGcVbBVRZI3x+iHgal4xWd6vtCdlbrvhvOGPz+2Re0xaTVupTN7f6SKToZGOAO3vjCp/CV4xNpuFr3svECuaxgM/sBxg8PAI2NYWnF6ql2QSKZwQRLXKbV7uUyst7htT25aEvgymHPS9M+9s5ANZzgNTt5IPtg9emtr+Azjao2JEEqiwESkNLXGoPFKVmnNvoIKRZjLKsd6PZcOIHfvl4M7h/41NoxBnb2x5vHSmrXOjKOZo
 CC6Ibjzr
 bEwy78sHF4yOpLvwJxNgZIuEJnbyz48K8ts5zd2ZrybhqzXdv3wH4hM30DWE/qnW9Iy5dnhnmVGn5saB16VzPz7jYccVug8sGWlTxULNkk2AkIic3SxTHn51QzcaDszsB4tjKtR3wBo5A71lKJeJ1pe2y6EwZbtftM+2eys20nBYeb70A1zajz51s9i76cx6HFf3mzx9VI+5Fz5Rla4FnMyOg2v9GRTKxu/QLjZGnlWtaYF3v3r5Ium8jbM+idKFlm18zIP7Q2m7x6jElMRAVWhuzxpr9P4GaxVK4TlQzEk0AC3qh+mHazs5dgDOFLH8A94fvTkZnoP/jG91oFqfc+taFzqPBybxZDRs65a6SEw63zX5Q/B6XdnbblQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 28.1% improvement of stress-ng.mincore.ops_per_sec on:


commit: 7625cb56733bfd470e9fae69a1b8b78aa8b1d3eb ("mm: mincore: replace __get_free_page() with kmalloc()") https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 4 sockets INTEL(R) XEON(R) PLATINUM 8592+ (Emerald Rapids) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: mincore
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261019/202610190930.7aeab52b-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-emr-2sp1/mincore/stress-ng/60s

commit: 
  006943a9b4 ("mm: mincore: remove special handling for VM_PFNMAP")
  7625cb5673 ("mm: mincore: replace __get_free_page() with kmalloc()")

006943a9b437b2d4 7625cb56733bfd470e9fae69a1b
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    547.22           -25.4%     408.24        stress-ng.mincore.nanosecs_per_mincore_call
  27632999           +28.1%   35386493        stress-ng.mincore.ops
    460725           +28.1%     590032        stress-ng.mincore.ops_per_sec
      1729            +7.1%       1852        stress-ng.time.user_time


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



