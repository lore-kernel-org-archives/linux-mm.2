Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724E560A382E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BofzkP3x
Received: by kanga.kvack.org (Postfix)
	id 8682A6B05B6; Mon,  2 Nov 2026 08:57:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 818526B05B7; Mon,  2 Nov 2026 08:57:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E4B6B05B8; Mon,  2 Nov 2026 08:57:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 532F06B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:57:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9342140C63
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:04 +0000 (UTC)
X-FDA: 85390330368.20.02F1A34
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id 23AF0C000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BofzkP3x;
	spf=pass (imf28.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627822;
	b=zTdokWVmqmUGRMB1xrwyrPoBTAIiKx6QuzuY7cMbukjWkmVJsE22idu5rOpKONgUXyrp4l
	iReQdML3bdychXIJ6UvCZGQEG/gNYljL0fu/fWXn71rd5gBni7S4csLMoqnGuY4XiEPUR5
	svxlfgDGMcuMj6KE2vGR2gfqQ6frr5g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=aY+uTVkzrvNotrv+R7o9XjTGrkI7pqN52rACqDEBwvw=;
	b=Qg80nbCa5DlgJzi9yQv0Xjiqc4Y92PIXiZi+0g93COu8UJwxyPQr+SKnAt8AWU9ht4pDw1
	8NNdMtVDcEnSA6Va35cKlrHAYRpO2iblN5r0pFfyaden7Sgn4SITyhhADlz+89/JNv3PNE
	LecUlakecow9BajMHgF1EHUQ4j95ERQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BofzkP3x;
	spf=pass (imf28.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=yi1.lai@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793627821; x=1825163821;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=/+Ka65ISl0O8qoyc0FUTNy5aKkP2xUp+ZgLvLFN/wz0=;
  b=BofzkP3xo4OBfyP/dBD91xDQTi9fR28P1yCQs2gEKeJ+VvOG/76v1wCg
   pXRVUfXvtTmDGQqJWaWs8fmfquDTqMlRPPaGKCM1MU3zEcK0AfAi1uTmx
   8bR01J/zfEvR/h7dl4hETv91ddNASbb2budfK+YJPXsvsDniIwgXPgCkn
   /vVjtE+YvnbvIx5RrhsxOfu+APL578+T6C239/KUFlkeE+/HQsGe0+fWi
   tZ6u/tgYo4N4q/dig4oS4N2k9VmokG58HbCO+2od8JDm+9ttemafKgQwi
   Cdrh/AxN18ypr/HPevtQ/DTYVOX9pdnUwke3516YAuzPHCSy7L4mnEafw
   w==;
X-CSE-ConnectionGUID: wcQSysUiRnud5TUQqkZUMQ==
X-CSE-MsgGUID: WjM6L6yFTk2zPFOu/ee6cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11954"; a="2328558"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2328558"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 05:56:59 -0800
X-CSE-ConnectionGUID: OV2TL7GUQu6q37LKLBaBmA==
X-CSE-MsgGUID: wZ3pGcFlTqGwtH2rwJfoWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6252146"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 05:56:57 -0800
Date: Mon, 2 Nov 2026 21:56:54 +0800
From: kernel test robot <yi1.lai@intel.com>
To: Harry Yoo <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
	yi1.lai@intel.com
Subject: [harry:b4/sheaf-size-round-up] [mm/slab]  7d63a6c06a:
 will-it-scale.per_process_ops 54.0% improvement
Message-ID: <202611021441.984cb0bb-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 8mk5gp75oxptpq9ocd75f3171xj75usr
X-Rspamd-Queue-Id: 23AF0C000A
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793627820-653742
X-HE-Meta: U2FsdGVkX1+BwP/wy/QNseqeOr6UFnKkXRM+R2wEqU3Zth7EqKAkNdHrSK8eOsg7P/YEAjG44/5lR0G2iLCCmOFhiqnxFX81vXSYQX8WPAEzzF+L6NxF9TlM8y+PEmt05etPU2ASA/Exu56LwriCV8VgmRl2MuivY72qetrJH2+OJAwbWEHy7+laI73SA60vfrwmPtnzsD0SwKqIJsn6jeNSIZ1nH4iJg6RYhN+jNF9jyPHF/uGAsd0UZizCgR3t9+WcdpGhBx/+A41sbScumptKV7VB0hfdwvuCSrtPLQdsK+QJ6GOduw5IRM+L+r4hY0RhqqQRxp9OLVAu4IXP9dfO1Zl+nf89cLJwTBJudOydfgxrxFO9M5WZVtFtD4nffWTzqwlz4ndVeHCGsY/yrt+5VH3OD8bI3pBROw44zaWHi84rktNlnw9h9u3aYQ18QuhG7KCYM2Ku+sCLFSXq/OdKPmdbq8bnPc0QIf7Y07YvwI8nJo1SP1OPSB+tqQ2CD5Gaw20V9QIlRZomdbIP2Aj45gVl79fK7lO0DsYbrv8s8EDnJ4msH2zMvJZWDCJ/PhtjlHeO0HvyZu8gKjY0te8uzZS79LF+9lQe7bX3E5MwRkP7YVlVmGLbI2Kybmz50jl6gVntijGqJJNAY9E+ESAGKCGN0fBG1XSGpULSoNmUnvzvtFRMcmXG9NL4T1mQ/n9rH9F5+a792Gwu1ZuI8SKUQMNu6ehhk+bHckrp8SUXnCz6TFrm/X5KKmefXOPYFZBysmfpvOz9AFmXgQJhPcUnKrc4rIHE+U73FS8tmis9lMIOQC5u+7RlVKFaOEN2XQcMeWpoZO0fLe6vs7s/6goVPDN3JpEN9bj2/JQDvfSNuzm/lzz4fOgSv1baglZYSiXJBAMqOz6RacXdL+Qd3qlr4Aorybnj/rOKomamDyHdnYxpxGdtyckk8PAtYOYRuidOv+08hid0ItKDlCI
 1t7ET9KL
 xAmYyWlWAUCzh4hEPVV8i0sMTa0yDlx+y/PVQtes0lHEJP4lzq8VMaxVmFpUSx+fPUGUmDEbv6Za8sRCMogUz8J0QBabZSTyH+25nGk1CLb2cV2IDgs+uxee+tKY84B+4IEPxK5bI+jDCvByZD7i0Tv9lTqTk5c7XQpHaeOX+/+TkoX6PhTwdJc/UtnOiPXGyUIGmIaR5qrtXIjHjxVkekGnapvSeNwrXKiNWSXrHwTAn+vlJzlHS9yur622y1EbP62aD63gEZDE/b1CFzgXpVtIsrtm2RVtMgwHK1CbgqGAy3S+CQmWbw4KbIkVnuwqFFyLiA75IMoNXIx5cZk3er1WM6/3z4sg93mUtc1FRbipCnpEvdQXBiqKkvSANfDIv/eY0KY+1EctxlSGdYlcVa+ENg3jIRkbpcx3P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



Hello,

kernel test robot noticed a 54.0% improvement of will-it-scale.per_process_ops on:


commit: 7d63a6c06a85030dc4344dc0884883b115faa64a ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")
https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git b4/sheaf-size-round-up

testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap1
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261102/202611021441.984cb0bb-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit: 
  6ae424d6ef ("EDITME: cover title for sheaf-size-round-up")
  7d63a6c06a ("mm/slab: round up sheaf size to kmalloc size for explicit sheaf_capacity")

6ae424d6eff8059f 7d63a6c06a85030dc4344dc0884 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  38572109           +54.0%   59400688        will-it-scale.192.processes
    200895           +54.0%     309378        will-it-scale.per_process_ops
  38572109           +54.0%   59400688        will-it-scale.workload


Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



