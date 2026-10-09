Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70CC7CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 06:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AF8E6B0096; Fri,  9 Oct 2026 02:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EC26B00A9; Fri,  9 Oct 2026 02:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1748C6B00AA; Fri,  9 Oct 2026 02:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E53ED6B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:39:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58F49140225
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:39:10 +0000 (UTC)
X-FDA: 85302135660.24.6CC697A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95AFDC0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 06:39:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QeYxkIlO;
	spf=pass (imf10.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791527948;
	b=SaI+3lGWRXE1uch4pRd5Q5JOsUgo0S4m9udzT7F157EGG3+9Tr25IpkVjEeviQa6tpsQC1
	zU6Fpqt3wRg1CMsOCdwQ/IP/jmET9wtQd3iBI1SKvvUy3i5n6vaFWnT10X9u5cIO8lTGzD
	ujgOTcEej0BT/RWkLQaHZe0Kk4vVKxg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QeYxkIlO;
	spf=pass (imf10.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791527948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/tyiYdORXs+D696ENEjSrqbDlAtPluXUTBdOIdd6qN0=;
	b=7wS2ypScw17UoIuS3pqR31LzZZXEj2DGy3Bboi7FN5eeu5OyhRiaA9JdPbHIPEAybdSrLD
	mLm7IV1MzpifWYyNa5j/vBphFHB97pmNecSApWI6VcsdWgTvrcBYm8KMrGNXH2N3wTbaG/
	zIEs+UFbJ6xCAdCsTtFM52I467BVJy0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791527947; x=1823063947;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=HyCYDcwd4p7v9CaOr/TI8WqjAnbtu3SXQcxglqX3xRY=;
  b=QeYxkIlOiPRy5NtDHxUCv1g+2RCtIylmLam3j5mne1+WrXbDOYTQ18zm
   S6WUcfPxbmJUzTNae77h6BY77pAXPE6+H4hEJ1q2nHhP4fBz4j87RKmRh
   nOivf3BGNN7P4R1P4+GfSuAulK9y3D0ECFOnMCFvWk2DfwJ7NZUtrGCNK
   9DqRPMLSuHEmX9vMdap5NAhkdVevYAkTYUUGuuUMLEa/JNxeYK1JE7faU
   EODLGoarOd7UgKL8igjq87ntGRiu782409Eb41pJBp/fF44y4+Ekupnkl
   Eo58hN2utr/lomTtQGOaS6nzlpxjNr5tgcTpiLgPvlA5aombCOja648q3
   A==;
X-CSE-ConnectionGUID: 8F/CL3tDTSGSzq7HBaNoKQ==
X-CSE-MsgGUID: l2uzhsGsS4eGejfIyL0ZCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="201179"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="201179"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 23:39:06 -0700
X-CSE-ConnectionGUID: Tpg1035cT+e4bln+P7KYGQ==
X-CSE-MsgGUID: bqsZdNQwSJi7cq+Du3SAZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="244059"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 23:39:06 -0700
Date: Fri, 9 Oct 2026 14:39:02 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Harry Yoo <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [harry:b4/sheaf-size-round-up] [mm/slab]  ddf56dfc79:
 will-it-scale.per_process_ops 54.5% improvement
Message-ID: <202610091451.beda4ec3-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95AFDC0003
X-Rspam-User: 
X-Stat-Signature: btpwc8rmt7auwku5jkhr6ee6g6f1muyf
X-HE-Tag: 1791527947-236846
X-HE-Meta: U2FsdGVkX1+PsVeykndjZUBW361AMEy3zsWaTsDLlneSzmXHWRiJzcAGpUx47yKlqZQnNlCKEZoL8OuQZt3j5gqlIIABUZn8m2PQGKQZSpMD1LZkp9CEjVqPP84rCSNzaeimmQy2zm12uZdwU9YdLT45gH0hfvHZLAB0SofQR8Jy8KUn1S/LPncCRNPitxVaaftAkOCGIpNSzvlyXklmfNj4dCp/kcv0uq8Ip5HvGWjflzT3e4afHcXC1E2ao1EpQMm0RB4KBowg0og+eemgYA1IsxRXHWrqQnLP49ppCmsY/lBL7iC+uczfl8ueQ8A0MzZ70oywxdvGYs1vJndxL1AsKBDHTyVsf+bScNI0BK/lvczsoY3O5Ei5uC5bcSYyiQwYvO8TbPtFYNncG/Yk12d6mb7jCBrOEJzLoSnuu5m6A4TKLsTs7gcahvgIltyOAg0RWdDi+iPzI+IcPf9kuDWL9bbnmwgyQkBBvrvffI7w/5Vb9wseCXp22NOwlML7pJOjwsBUosaXOUAukP6Wh68ecp2s+dPMKFphw8r+A3KDH2qGhwI76TcJBwdW/5V79pBAgMl5xl0OGi1nNK4daTxZiD7Sp8IShvaei/TuPZC+qRn2sz8AKL5yjIv4l+ASu0eHtJH2NMHerDP5bsJ7mPQAPO9HtS1AmVtPM3pCVT2rV+eqlcs6G+EpdIlitJ/xCbHzv2qwFL+qVxPUTc6Km4vDWcVHOcPy9IpXZRE49Zv87JIfuJMy80xxSZQVSglNKgmxW6NiWgNSb/NNmanfbxFt5J6y4oeVkw193fYhwm7D3de+CqBNhW3A5zXftmtqk4DwkMgR/CxFu6r0l7fWFTHaygywBFDcb+PIbykVHRGAKOrz070a+C+OQ7IIzregN4Og3NJTheWl3zKk6eVwKokVSO8NYmgFMnRnnu+kyi0Yk1K6EB91PTpFF/eZiZxMnG/mHzG8QzfxzJe27mE
 RoFrZ4fN
 NKJk9O+Ye3rJA/t6Glxho5pvonZhzkmYZhB8l+ZPB7dhGs9weWGwHm5yc4Ij3JWD5E3Oma8fITaa+pgrOXaONW3js2/IdvVtTYTBCDhd6IIa8kqx3PWCApQa4ukEC6dOy4XFBpt9n+C2dHSVSmER4T6fuhdE1d6vovYMWbzDwbCNZRLs8ZoOLaG53Z0HvyyNrPtsS5MBOvEc6OAxYMqJo1v+CC/KuXKIjyKyl6oYYDFgBOqI2Lcig1hrcS/MaCdaPMjBH5OqqDcCF3XrV/PIHO5kJOmC74FLd8Qfg8BQVSaLYpAlHyGUheGY5G9odv8wSM55WkPmOxxQwLSgIvGDdELBjI5gKFbIHmb+M3MODeQrqpfhjQDHCdGEgxhEwfUKvNDFw4+jPcXrUONk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 54.5% improvement of will-it-scale.per_process_ops on:


commit: ddf56dfc79f5734d7b3aa8ba81f195d52b3e5823 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git b4/sheaf-size-round-up

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets GENUINE INTEL(R) XEON(R) (Sierra Forest) with 128G memory
parameters:

	nr_task: 100%
	mode: process
	test: brk2
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261009/202610091451.beda4ec3-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp1/brk2/will-it-scale

commit: 
  675a745c61 ("EDITME: cover title for sheaf-size-round-up")
  ddf56dfc79 ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")

675a745c6113e420 ddf56dfc79f5734d7b3aa8ba81f 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  70440501           +54.5%  1.089e+08        will-it-scale.256.processes
      0.30 ±  3%     +35.9%       0.41 ±  8%  will-it-scale.256.processes_idle
    275157           +54.5%     425248        will-it-scale.per_process_ops
  70440501           +54.5%  1.089e+08        will-it-scale.workload


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



