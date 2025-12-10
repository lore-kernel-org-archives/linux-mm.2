Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A092D3C924
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 15:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF60C6B0005; Wed, 10 Dec 2025 10:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDAF6B0006; Wed, 10 Dec 2025 10:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3AD6B0008; Wed, 10 Dec 2025 10:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBFEE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:50:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6AB3D1405B9
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:50:31 +0000 (UTC)
X-FDA: 84203998662.26.2636D90
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id B2D881C000E
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:50:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F3UMcMOm;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765381829; a=rsa-sha256;
	cv=none;
	b=2FxOxExJtK4cMsTcTaVCH90T8iIxNBUyV9PCUo3S+IFDwJ+EnnwUjko3PANZlv6F0Hqdvz
	k9cvXkCyoUiV9qiPjhwq15jGWiprZYYuk/Bm9Ycq1WDy+ogJ8StWBKm2zXQHtUoysWvZFU
	kdaivNJvQFKB8jcxooX7DpmZWO4c4ho=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765381829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L+lUy/nfBDSeygptvUwmIxWkC95vRD1JGw1vhIhOMv8=;
	b=mvZDmA2JCUrIJsxDjvMbeyDg0LOT/CIMKCnRyc5F5aLkCM0sBaShcZ1osooGUZ+jEY+w6R
	vh7tRFAB8vkKnHVCJdclj+W7XgSJFS+2PAlgRE8rchzZ4UZm8DyS5cmjbHqXFzYyFROizc
	JtwdZzn8B3O51aDjRk82zqOx5Vep4Xg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=F3UMcMOm;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765381829; x=1796917829;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VEcbpiLkpkrEQ7cGjKn+Fn2OtIAlycq/PQz+Z+qvjZI=;
  b=F3UMcMOmQSJYdl0/rT/vWVE3M0W2xMXKd3K5zi/oKiEECLjvS4BIHlgr
   j46NGh3HSgkDTo4W7iI3hSAzaJgjEVykCAT+DuPi6dQoYybAtzdcLF6Fd
   jtnpT5ZAy9i4IE1m8ycbaFBsFNWfIZts3K3QEyjCva+RM2jlEV0u4Hbbj
   Ah17E00Cr61q1tBoyJT/KRyPmL3jLHKLM9hn/u6JQSLbDEbnDgI2boeZe
   4xroylX93kgeDkLY3uMj8wILri6nBl2kDiCCwnGV5qKLRe99JSUcUQ/L6
   oAxtLgOwBhTfhiMfrQYWsnVwIkaDp39MwFdCv9uEEy/nyswzmN5pHjEdS
   A==;
X-CSE-ConnectionGUID: +SVFp6tvQBiEr1D36j2XnA==
X-CSE-MsgGUID: 455jme8vQ4O6he33WvOxzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67292954"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67292954"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 07:50:26 -0800
X-CSE-ConnectionGUID: CF0fDr5OTCC3qUdCyKrFWA==
X-CSE-MsgGUID: 4Wy54IWUTs65bCvDMIQXdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="233954107"
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 10 Dec 2025 07:50:24 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTMSL-000000003Kf-2ZvT;
	Wed, 10 Dec 2025 15:50:21 +0000
Date: Wed, 10 Dec 2025 23:50:05 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: fs/dax.c:728:39: sparse: sparse: incorrect type in argument 1
 (different base types)
Message-ID: <202512102350.z1VCJH4s-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: B2D881C000E
X-Stat-Signature: 1mmz3qyk3x6zqn8jx7rtyobgyf8584ua
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765381828-401649
X-HE-Meta: U2FsdGVkX18YZLezUMJqT8F/u8Req/dc1xQaLvlfsgxnywMoCY0t1pOyp2vHsoquPeT2L9JApwT+gTs34/gkJhbQ8eZ76ZFwzfxmoCxPeZXg17Hb7+rwkrDc3qesfPTLvDICVafj84itxGXJyUaUIYCiCkKkGA6kEfICicNF2Bu8Tb1AHMKyjpccvdHGWRDbyB+cWJutClUnGO7fH9ZMRQiF33I8zue8lgxpUzGH1era5ZKLvAymyoWXzmwYXqL1WI//GsiyU29mcDHq6qZi8PxWqJ4Q+DLf+2NDQs4Bhbs67OQCvnrfT9D+uRXxdsTghlLvSmlJGsoEwkHjiBRgVVMyvwX2NX7Q9tVwMxDkkRcVg+z7grDT8P5M4Q5u0sksp1p/oP4bZmD2z3xre/ctf1JJQKG9++S6xNi8rXCul8SBpmTYQXP4VZbiOceGEEi8FrjWhhPlcNURx9MrzFc5PHaSEyOh2HTCkVGV/Gf6XY/X9nF2jhTG4K/kCpc0KqCW9kl2SMuJWEfvIJu4NVMnhA0zRyNJx6D8hi62OtMal1ZEBSYJCL0FTNPB0BrIw4MdxX/YOekg+FPgDV5el1mBi/BCrLUSBjrBe4PDfCdd+8WzedQ/teZdYkRaoA/hAUqsSasF6VbhVXW7B7BXc618t4bLZu6pXMvJFMdltdyYKDpy0Nw/JQXyyTgRBODEKwwSJRuFXSaQYmjcknpivamfL/H7dXXVh9yWsJHSy74yfhkRqwjM/DLC2GqxBtSzx8lg4lfhUiSKxH+FALsUMVRMh1NJ6/to3/7fY2VfCUGAj+W6g8jBm7Jx09sO6Vme5kC+jrXg069fL2t/RwAxFHhereJ5XSdeKqGW8BHKzeIxdxdVP3UY2Urc+hjbTssVi5+2bZ/nlomXeDQF/aZE1iuzUZH6X2e4gUsbGTl9v8mZRZprAFMyiWSxlz0YA0gL37/mKQ4S3Oikt2h6A+eoqmg
 /MJ73Qtg
 mpZ7MZ/71BQBYsMiL3XXViuU/0bDR7pc4Y/WAEG2UJINDDI1/5lz8p7vgwyD6lmS/jMKmBH1sVgSO4pxHZTTVp+3lynZsRaDNibE93L9WTeu7zBcXVf58+i4Mi2kVsrcHM5jyrq23/oHCN/AD1A50WmOA27UiawSAcXR+4Qr+jTSOJgUczQ/iHi9esyb9XCAo930ZQQaeNgnobf+1S1t3Xy016ptdS+J6UCNYAiLibYXl34DcNijt53WpUsKyK8sZ+cyXWAg7coGuOAkQSOzA0RQUjPRW6jU8PBkWZC4lxKIkWbfiLrmulZNA3ViqbNySEqsswVToWEgw2chCm/O1S5Epf3Dx7XaCzN5fVd8tAwD1PGO0TrN4UcOKDz0IiAjs71VvfZ6yx5NGuGQ2ZomsX5p5KttRWapMtMhr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   0048fbb4011ec55c32d3148b2cda56433f273375
commit: d438d273417055241ebaaf1ba3be23459fc27cba mm: remove devmap related functions and page table bits
date:   5 months ago
config: s390-randconfig-r111-20251210 (https://download.01.org/0day-ci/archive/20251210/202512102350.z1VCJH4s-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251210/202512102350.z1VCJH4s-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512102350.z1VCJH4s-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   fs/dax.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/fs_dax.h):
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:10:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:10:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:10:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
   include/trace/events/fs_dax.h:105:1: sparse: sparse: incorrect type in initializer (different base types) @@     expected unsigned long mask @@     got restricted vm_fault_t @@
   include/trace/events/fs_dax.h:105:1: sparse:     expected unsigned long mask
   include/trace/events/fs_dax.h:105:1: sparse:     got restricted vm_fault_t
>> fs/dax.c:728:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:728:39: sparse:     expected unsigned long v
   fs/dax.c:728:39: sparse:     got restricted vm_fault_t
   fs/dax.c:730:39: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:730:39: sparse:     expected unsigned long v
   fs/dax.c:730:39: sparse:     got restricted vm_fault_t
   fs/dax.c:734:31: sparse: sparse: incorrect type in argument 1 (different base types) @@     expected unsigned long v @@     got restricted vm_fault_t @@
   fs/dax.c:734:31: sparse:     expected unsigned long v
   fs/dax.c:734:31: sparse:     got restricted vm_fault_t
   fs/dax.c:1370:41: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1370:41: sparse:     expected int result
   fs/dax.c:1370:41: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
>> fs/dax.c:1878:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1878:21: sparse:     expected int ret
   fs/dax.c:1878:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1881:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected int ret @@     got restricted vm_fault_t @@
   fs/dax.c:1881:21: sparse:     expected int ret
   fs/dax.c:1881:21: sparse:     got restricted vm_fault_t
   fs/dax.c:1884:16: sparse: sparse: incorrect type in return expression (different base types) @@     expected restricted vm_fault_t @@     got int ret @@
   fs/dax.c:1884:16: sparse:     expected restricted vm_fault_t
   fs/dax.c:1884:16: sparse:     got int ret
>> fs/dax.c:1902:46: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [usertype] ret @@
   fs/dax.c:1902:46: sparse:     expected int result
   fs/dax.c:1902:46: sparse:     got restricted vm_fault_t [usertype] ret
>> fs/dax.c:1918:21: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted vm_fault_t [assigned] [usertype] ret @@     got unsigned long @@
   fs/dax.c:1918:21: sparse:     expected restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:1918:21: sparse:     got unsigned long
   fs/dax.c:1961:51: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:1961:51: sparse:     expected int result
   fs/dax.c:1961:51: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:2138:55: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t @@
   fs/dax.c:2138:55: sparse:     expected int result
   fs/dax.c:2138:55: sparse:     got restricted vm_fault_t
   fs/dax.c:2156:58: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected int result @@     got restricted vm_fault_t [assigned] [usertype] ret @@
   fs/dax.c:2156:58: sparse:     expected int result
   fs/dax.c:2156:58: sparse:     got restricted vm_fault_t [assigned] [usertype] ret
   fs/dax.c:279:13: sparse: sparse: context imbalance in 'wait_entry_unlocked' - unexpected unlock
   fs/dax.c:509:49: sparse: sparse: context imbalance in 'dax_lock_folio' - different lock contexts for basic block
   fs/dax.c:576:17: sparse: sparse: context imbalance in 'dax_lock_mapping_entry' - different lock contexts for basic block
   fs/dax.c:1142:9: sparse: sparse: context imbalance in 'dax_writeback_one' - unexpected unlock

vim +728 fs/dax.c

2f437effc689ef Shiyang Ruan            2022-06-03  621  
ac401cc782429c Jan Kara                2016-05-12  622  /*
a77d19f46a37c0 Matthew Wilcox          2018-03-27  623   * Find page cache entry at given index. If it is a DAX entry, return it
a77d19f46a37c0 Matthew Wilcox          2018-03-27  624   * with the entry locked. If the page cache doesn't contain an entry at
a77d19f46a37c0 Matthew Wilcox          2018-03-27  625   * that index, add a locked empty entry.
ac401cc782429c Jan Kara                2016-05-12  626   *
3159f943aafdba Matthew Wilcox          2017-11-03  627   * When requesting an entry with size DAX_PMD, grab_mapping_entry() will
b15cd800682fca Matthew Wilcox          2018-03-29  628   * either return that locked entry or will return VM_FAULT_FALLBACK.
b15cd800682fca Matthew Wilcox          2018-03-29  629   * This will happen if there are any PTE entries within the PMD range
b15cd800682fca Matthew Wilcox          2018-03-29  630   * that we are requesting.
642261ac995e01 Ross Zwisler            2016-11-08  631   *
b15cd800682fca Matthew Wilcox          2018-03-29  632   * We always favor PTE entries over PMD entries. There isn't a flow where we
b15cd800682fca Matthew Wilcox          2018-03-29  633   * evict PTE entries in order to 'upgrade' them to a PMD entry.  A PMD
b15cd800682fca Matthew Wilcox          2018-03-29  634   * insertion will fail if it finds any PTE entries already in the tree, and a
b15cd800682fca Matthew Wilcox          2018-03-29  635   * PTE insertion will cause an existing PMD entry to be unmapped and
b15cd800682fca Matthew Wilcox          2018-03-29  636   * downgraded to PTE entries.  This happens for both PMD zero pages as
b15cd800682fca Matthew Wilcox          2018-03-29  637   * well as PMD empty entries.
642261ac995e01 Ross Zwisler            2016-11-08  638   *
b15cd800682fca Matthew Wilcox          2018-03-29  639   * The exception to this downgrade path is for PMD entries that have
b15cd800682fca Matthew Wilcox          2018-03-29  640   * real storage backing them.  We will leave these real PMD entries in
b15cd800682fca Matthew Wilcox          2018-03-29  641   * the tree, and PTE writes will simply dirty the entire PMD entry.
642261ac995e01 Ross Zwisler            2016-11-08  642   *
ac401cc782429c Jan Kara                2016-05-12  643   * Note: Unlike filemap_fault() we don't honor FAULT_FLAG_RETRY flags. For
ac401cc782429c Jan Kara                2016-05-12  644   * persistent memory the benefit is doubtful. We can add that later if we can
ac401cc782429c Jan Kara                2016-05-12  645   * show it helps.
b15cd800682fca Matthew Wilcox          2018-03-29  646   *
b15cd800682fca Matthew Wilcox          2018-03-29  647   * On error, this function does not return an ERR_PTR.  Instead it returns
b15cd800682fca Matthew Wilcox          2018-03-29  648   * a VM_FAULT code, encoded as an xarray internal entry.  The ERR_PTR values
b15cd800682fca Matthew Wilcox          2018-03-29  649   * overlap with xarray value entries.
ac401cc782429c Jan Kara                2016-05-12  650   */
b15cd800682fca Matthew Wilcox          2018-03-29  651  static void *grab_mapping_entry(struct xa_state *xas,
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  652) 		struct address_space *mapping, unsigned int order)
ac401cc782429c Jan Kara                2016-05-12  653  {
b15cd800682fca Matthew Wilcox          2018-03-29  654  	unsigned long index = xas->xa_index;
1a14e3779dd58c Jan Kara                2021-06-28  655  	bool pmd_downgrade;	/* splitting PMD entry into PTE entries? */
b15cd800682fca Matthew Wilcox          2018-03-29  656  	void *entry;
ac401cc782429c Jan Kara                2016-05-12  657  
b15cd800682fca Matthew Wilcox          2018-03-29  658  retry:
1a14e3779dd58c Jan Kara                2021-06-28  659  	pmd_downgrade = false;
b15cd800682fca Matthew Wilcox          2018-03-29  660  	xas_lock_irq(xas);
6be3e21d25ca2d Alistair Popple         2025-02-28  661  	entry = get_next_unlocked_entry(xas, order);
642261ac995e01 Ross Zwisler            2016-11-08  662  
b15cd800682fca Matthew Wilcox          2018-03-29  663  	if (entry) {
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  664) 		if (dax_is_conflict(entry))
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  665) 			goto fallback;
0e40de0338d005 Matthew Wilcox          2018-11-16  666  		if (!xa_is_value(entry)) {
49688e654e48ae Hao Li                  2020-07-29  667  			xas_set_err(xas, -EIO);
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  668  			goto out_unlock;
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  669  		}
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  670  
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  671) 		if (order == 0) {
91d25ba8a6b0d8 Ross Zwisler            2017-09-06  672  			if (dax_is_pmd_entry(entry) &&
642261ac995e01 Ross Zwisler            2016-11-08  673  			    (dax_is_zero_entry(entry) ||
642261ac995e01 Ross Zwisler            2016-11-08  674  			     dax_is_empty_entry(entry))) {
642261ac995e01 Ross Zwisler            2016-11-08  675  				pmd_downgrade = true;
642261ac995e01 Ross Zwisler            2016-11-08  676  			}
642261ac995e01 Ross Zwisler            2016-11-08  677  		}
642261ac995e01 Ross Zwisler            2016-11-08  678  	}
642261ac995e01 Ross Zwisler            2016-11-08  679  
642261ac995e01 Ross Zwisler            2016-11-08  680  	if (pmd_downgrade) {
642261ac995e01 Ross Zwisler            2016-11-08  681  		/*
642261ac995e01 Ross Zwisler            2016-11-08  682  		 * Make sure 'entry' remains valid while we drop
b93b016313b3ba Matthew Wilcox          2018-04-10  683  		 * the i_pages lock.
642261ac995e01 Ross Zwisler            2016-11-08  684  		 */
b15cd800682fca Matthew Wilcox          2018-03-29  685  		dax_lock_entry(xas, entry);
642261ac995e01 Ross Zwisler            2016-11-08  686  
642261ac995e01 Ross Zwisler            2016-11-08  687  		/*
642261ac995e01 Ross Zwisler            2016-11-08  688  		 * Besides huge zero pages the only other thing that gets
642261ac995e01 Ross Zwisler            2016-11-08  689  		 * downgraded are empty entries which don't need to be
642261ac995e01 Ross Zwisler            2016-11-08  690  		 * unmapped.
642261ac995e01 Ross Zwisler            2016-11-08  691  		 */
b15cd800682fca Matthew Wilcox          2018-03-29  692  		if (dax_is_zero_entry(entry)) {
b15cd800682fca Matthew Wilcox          2018-03-29  693  			xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  694  			unmap_mapping_pages(mapping,
b15cd800682fca Matthew Wilcox          2018-03-29  695  					xas->xa_index & ~PG_PMD_COLOUR,
977fbdcd5986c9 Matthew Wilcox          2018-01-31  696  					PG_PMD_NR, false);
b15cd800682fca Matthew Wilcox          2018-03-29  697  			xas_reset(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  698  			xas_lock_irq(xas);
e11f8b7b6c4ea1 Ross Zwisler            2017-04-07  699  		}
e11f8b7b6c4ea1 Ross Zwisler            2017-04-07  700  
d2c997c0f14535 Dan Williams            2017-12-22  701  		dax_disassociate_entry(entry, mapping, false);
b15cd800682fca Matthew Wilcox          2018-03-29  702  		xas_store(xas, NULL);	/* undo the PMD join */
698ab77aebffe0 Vivek Goyal             2021-04-28  703  		dax_wake_entry(xas, entry, WAKE_ALL);
7f0e07fb028951 Matthew Wilcox (Oracle  2021-05-04  704) 		mapping->nrpages -= PG_PMD_NR;
b15cd800682fca Matthew Wilcox          2018-03-29  705  		entry = NULL;
b15cd800682fca Matthew Wilcox          2018-03-29  706  		xas_set(xas, index);
642261ac995e01 Ross Zwisler            2016-11-08  707  	}
642261ac995e01 Ross Zwisler            2016-11-08  708  
b15cd800682fca Matthew Wilcox          2018-03-29  709  	if (entry) {
b15cd800682fca Matthew Wilcox          2018-03-29  710  		dax_lock_entry(xas, entry);
b15cd800682fca Matthew Wilcox          2018-03-29  711  	} else {
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  712) 		unsigned long flags = DAX_EMPTY;
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  713) 
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  714) 		if (order > 0)
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  715) 			flags |= DAX_PMD;
23c84eb7837514 Matthew Wilcox (Oracle  2019-07-03  716) 		entry = dax_make_entry(pfn_to_pfn_t(0), flags);
b15cd800682fca Matthew Wilcox          2018-03-29  717  		dax_lock_entry(xas, entry);
b15cd800682fca Matthew Wilcox          2018-03-29  718  		if (xas_error(xas))
b15cd800682fca Matthew Wilcox          2018-03-29  719  			goto out_unlock;
7f0e07fb028951 Matthew Wilcox (Oracle  2021-05-04  720) 		mapping->nrpages += 1UL << order;
ac401cc782429c Jan Kara                2016-05-12  721  	}
b15cd800682fca Matthew Wilcox          2018-03-29  722  
642261ac995e01 Ross Zwisler            2016-11-08  723  out_unlock:
b15cd800682fca Matthew Wilcox          2018-03-29  724  	xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  725  	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
b15cd800682fca Matthew Wilcox          2018-03-29  726  		goto retry;
b15cd800682fca Matthew Wilcox          2018-03-29  727  	if (xas->xa_node == XA_ERROR(-ENOMEM))
b15cd800682fca Matthew Wilcox          2018-03-29 @728  		return xa_mk_internal(VM_FAULT_OOM);
b15cd800682fca Matthew Wilcox          2018-03-29  729  	if (xas_error(xas))
b15cd800682fca Matthew Wilcox          2018-03-29 @730  		return xa_mk_internal(VM_FAULT_SIGBUS);
e3ad61c64abcee Ross Zwisler            2016-11-08  731  	return entry;
b15cd800682fca Matthew Wilcox          2018-03-29  732  fallback:
b15cd800682fca Matthew Wilcox          2018-03-29  733  	xas_unlock_irq(xas);
b15cd800682fca Matthew Wilcox          2018-03-29  734  	return xa_mk_internal(VM_FAULT_FALLBACK);
ac401cc782429c Jan Kara                2016-05-12  735  }
ac401cc782429c Jan Kara                2016-05-12  736  

:::::: The code at line 728 was first introduced by commit
:::::: b15cd800682fcaf27048b05e42f5c208e4c756c0 dax: Convert page fault handlers to XArray

:::::: TO: Matthew Wilcox <willy@infradead.org>
:::::: CC: Matthew Wilcox <willy@infradead.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

