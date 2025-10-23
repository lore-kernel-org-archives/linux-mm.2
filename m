Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D93ECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 23:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B16A8E001C; Thu, 23 Oct 2025 19:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961CB8E0002; Thu, 23 Oct 2025 19:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F278E001C; Thu, 23 Oct 2025 19:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 78F8C8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:45:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 27B0D160BB5
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:45:48 +0000 (UTC)
X-FDA: 84031013976.15.80EE9F8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86AAD1C0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:45:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBICLUy9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761263146; a=rsa-sha256;
	cv=none;
	b=Ig+eg8B9+IUWb7CS9JWwilSHuo0CnzJTyxDAHinkZg67kCkQEr5BlC0GoL88SWoMFl+bPC
	9Rh3+Cich1pj1oxAQjkeBRBv4S1tJC5wG58VCaEmQyevwFKY7givMELLMyE2SNCaekBMJJ
	PqV3dGCTZlm7VHVs6EHsjUMM+LA0Ajw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RBICLUy9;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761263146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K2FCMB8ITuyMdvuky8cvPRdgZfbDzIcJXrkLiJow74s=;
	b=UBJDe9I14QQ2i8IyS3lXScoLfdR+5T451Tb9sQaXWGpLsVf9jHdL8wUucUXkc/EGJ90Xc2
	Lp7cdrDNzXRVI2go2Dxn/Vd4Fc7Ifn447ovOyLm58COcS6HYjJDikbQFnVtSc9BBNlSWwj
	dWDxDSdA4KNjZA4hTPcmQWuSXVUVwdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761263146; x=1792799146;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=UN9o9S2vOXaFPu2d8jQ4pHsSzun2EI2pxvSUBqqwLFA=;
  b=RBICLUy9ty4QLQstgsUSQ+7D5fW2Ht+nhqnZtqILrm1vQUzJbsLJB3TK
   AVggIyJ0+ZlY0QSZrI09bJqFfZEZxig7gBP3KDrdh/4aLb8yeXfWWVYt9
   ZnAoSt6rMINgGKsuzFHlmHWaaDw1tyaKwjUGTXC8osjTnPeNEkGBZgw3x
   /ZTQYZ4ICBI3h0eg+SFn9E+DPi/lFAO79Ss8mnGCGFhYgj7u97xUovzLJ
   w8YLLAarqauZcnrkIILC6oVrb+wSmZVY0ll6n+wgxDSXWvVjEjVOPc5Qb
   PUhSTu3Dyzmy7YBRr58Ziwtxo5trUw6ITySTf2A1bzL4YcA4SOwfYeekO
   A==;
X-CSE-ConnectionGUID: FnV1j8rvQdeIEsmdleKESQ==
X-CSE-MsgGUID: /QMQcJspSoCiW5ie0Lm2wg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62654358"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="62654358"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 16:45:44 -0700
X-CSE-ConnectionGUID: F70XhnZXQlecmKVXiCoWEg==
X-CSE-MsgGUID: 5uTiptLKTZ2sfWRZydmpYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="185064452"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 23 Oct 2025 16:45:43 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vC4zv-000DzN-1N;
	Thu, 23 Oct 2025 23:45:36 +0000
Date: Fri, 24 Oct 2025 07:44:47 +0800
From: kernel test robot <lkp@intel.com>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [akpm-mm:mm-nonmm-unstable 40/49] ld.lld: error: undefined symbol:
 hw_nmi_get_sample_period
Message-ID: <202510240701.eB6r97V3-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 86AAD1C0007
X-Stat-Signature: 98kn8jzr7txep69owxot475jjdt1p9yj
X-HE-Tag: 1761263145-721870
X-HE-Meta: U2FsdGVkX18XwWx+cbYg/+qiNz7/xXfxWPfKy/nR61BJL+DbRH0BrQLfmsyvrUbz+XXACiEX6VuLv/SI4zPc4beX/Z0CCWCM6CzpY+hsEZd5vrvpv9rU1G+5owImp016yVK3lkRAHOBde0V00c2GuNJ3XQ6IhpHraHGPSJavDx97WiB+aVR1W05E+9M0/jgjmgysYpZuR8xiHJt1kEyX1iAx++aS03eNqVKJz9nfvJ8tL/pMvMg0M+/DKOkxNByfuYiic4u3IjdWSUHm1/rKM+JoKvQCtdY/ZakKDiwjSr2q280e7x2JvWnyKmtL2PrfSDcewixNMhopj+rCGwgm20QmX1Fw6qI5+JZUyIg/faLXuzracA540Eq/Q1iq7m+l+TRMINVd1eZ0IWCYbveRH43E57a8phE76WjG8UDnG/W7RTWHx7b+zRaffY0ibCQSo04NyybC/Jik/ydjfeQQBb3D7Bz3OOKgenCkS8naUh7fmL4AKaMbQ6PkiiGcqWsAVfhRgolbsLisQ9zdUMbzt0nV6UZjDEhr4tep6XtAPYZedPrdero71i//yJY/dFasGOUQkBNkQJjY1vLrBU3XYeKkDnIaaKV2ZEp5FXr5fdL6tMSlJUSCwPRIM5ASzAX+NM7Zk0yUsWDleCA7SCLCNpXb/HZwgV38BaP8092owcYc36KNiD0tvLrYeV8mPUlunDoBY3Dj63LomdkO2GAuW8EmPd4bCQJHANN9I8EP1nztc5uGIIWgcLdqWfM+66I8ChkMJH0HLrj8ZCRunUKcfAvMsGS54qN6vLddEOn8YseO/ti//isL4ZFfStNQWHT+KIY147jTKH7AS8qId/Yq7ZKVgbVr86QN4y06K0ZHRRuV6ymG5s/08Eek9PU0p2XgqE83LsWk7/ewdjFUoY7CFuNOIfuIi9w5SPXayxOPG5fGXRNVDCLnwt7flSFdtujW8VI8UAsa4Dj+ptA9JoE
 oVZ/hipZ
 S3gm/3aF/xnl93krfj1YgHkU0U6yjDBB7xZs2gBxI2DX+BkZm9xcfA8MxS52pSwIVdU+hn/CcJAXvLBc1KGfxtbNNeZHWqXtZojUvsI1GAL0D9j9w+bigCxCIXTOBEJAPBXbhrT7eK51YxesWumwim179RjKgz87StBF1INYNoHyzC5ToKbShVO30CgzeHg88kIqpK0D4p34hXHnCQscXiKk6o8KvOLtUEEsu8sxVeznQUsdkynXuZGHwY/3L1sHZRGqRRrZqrqsjmMvktD/tS2B6WHL1PrBKtEZXsOwX52E7OgfaeOhpJ4WhLc4xN3POONM9HPCptYFUo3Nm73n50w1tp6euAeCE4LiCa6YwLiqZ+nodyyjWlUjkdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   b0165d26ed76a1d8825e54ddc5c0b62db5113f13
commit: 5ec1304ad3434337b407db8e6e3bf6e2964c045f [40/49] watchdog: move arm64 watchdog_hld into common code
config: arm64-randconfig-002-20251024 (https://download.01.org/0day-ci/archive/20251024/202510240701.eB6r97V3-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251024/202510240701.eB6r97V3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510240701.eB6r97V3-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: hw_nmi_get_sample_period
   >>> referenced by watchdog_perf.c
   >>>               kernel/watchdog_perf.o:(hardlockup_detector_event_create) in archive vmlinux.a
   >>> referenced by watchdog_perf.c
   >>>               kernel/watchdog_perf.o:(hardlockup_detector_event_create) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

