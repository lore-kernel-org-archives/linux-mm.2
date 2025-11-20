Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D99B6CF8853
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 12:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257F66B002D; Thu, 20 Nov 2025 07:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EFC6B002E; Thu, 20 Nov 2025 07:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C756B002F; Thu, 20 Nov 2025 07:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01D676B002D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:52:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A98961A087D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:52:15 +0000 (UTC)
X-FDA: 84130973430.12.6AFE874
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1844712000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 12:52:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yy9wioS8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763643134; a=rsa-sha256;
	cv=none;
	b=yHFULqsXjYKvCGW7vaaaJfZYKswNvv9SLfBNQ6D59IXB/xPwv8BQJtJI8HIbIiEb81JvHN
	f0rR1BnbSTWTwthn1bCr6vv+P5yRRsEBBaCpy3jH1OLFWFHzcd3nmi0p6kkGkoeFxprYRQ
	9fS5LsS+75qePXo8noElpUSL4JzWHUA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yy9wioS8;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763643134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YEG1cnPA98Mb0Unc4XKsH4o7o0/3y8pzfl/+Qyh8qVo=;
	b=H7jqh+8+XnklOoG+x+UApHifDUnYxZmeAkCRJmtXgyn1cIwfNGV8vF8nX/b4c6kr5/K1dr
	RsJEQYujhLFweIs2DIUyjQQxpIcodVyVgpgWEOv6TrZf8CMmOu8tndNkIKbpPJDTkSxcE3
	i05o+eXQsMupPLJ+gHi/5MNG+xLBF8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763643133; x=1795179133;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=5ILxYBsGFpbcNrcTKLSOYFqCfCANKwBbW0exq6e1c7g=;
  b=Yy9wioS83/w276uGa5kTEZLUXu7JYtTCUlhXr3odsBka4Ulofxacvc8j
   rhonM+ylViwJrHqJDhGJfEhal83vkq+azgm0pdW4wXotTMgciK+bon0Ly
   yjFceB4sbawrvzQNUKTtKUvLdsf9ivuBfnP2DKbzaY+2PSV3/164MVOEY
   n8JeogpPjH0dYCFzSqZWtdHQBJHQgUubY2yTUDyeCpcgUIi+yw7SO70wi
   4Vo72KoPrHZwlzNeFC7hUnKFD6+17g5uk7HmyKDnLv3EjZHg40dkyfqYC
   NqoqCF+VkgObF8hHm9+6PROI2CaDi4xrNdnZ+Ry+omVgZD4v+LMeJwc84
   w==;
X-CSE-ConnectionGUID: 0PDAD3MQSUiFdMtqIycpZA==
X-CSE-MsgGUID: 9jn31FUxTqKF98ZED4CqwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65603351"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="65603351"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:52:11 -0800
X-CSE-ConnectionGUID: 3up7XwbaQwCEnxSPEAXXiw==
X-CSE-MsgGUID: jBKFzKiLR0yWSVzjXOV/3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="191478466"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 20 Nov 2025 04:52:10 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vM48t-00040R-1t;
	Thu, 20 Nov 2025 12:52:07 +0000
Date: Thu, 20 Nov 2025 20:52:07 +0800
From: kernel test robot <lkp@intel.com>
To: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [linux-next:master 7315/10599] ld.lld: error: undefined symbol:
 _copy_from_user
Message-ID: <202511202005.7GzetV3D-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1844712000D
X-Stat-Signature: gu66nx7urg8x5tafu84fwqcst64ftdwz
X-HE-Tag: 1763643132-320357
X-HE-Meta: U2FsdGVkX1/mMVK+4cNLPNnMCuOkOETsT4zWFqEDvTeCeGK5cxVEJfLH8CWWxM1onrt1BAaTuCvDbn9WFtvcnSMRHYer3Z7X5Xn6vj/aXcFfJ/CKMUcCXlySvPnOUSgVwbMrv+mtXZqQFCa1qD0HNCIrQqiBXLSBaaK4QBPLVPtFjLWP4uUAuFh5rC9ihEiIRqHZjVIF8AK/sfLuVfoOueQ4zRltOojewigz6Y2bQEjcGGJE3UaTopoiySnUSk/ulLmiMPG0nT/xnNxWEitOPWgYIqQzXzgUqCioqnbgDzfJgvEyYvsDRmP256HKA0DKQH9x5DIX8v9vVBRF6XPtsYNsZiDIU/2cuiLtlxQSnZo4Ka7gisflov8zR+Ktwk74HAB+wdck/SOMw/XqKt5oOASZGFA2923sChPMg/95iRVrbx0hjXnqpOQEgqalhseX0awzPcdIqu1blFXZc7yBs+jaCjAO0coZmWHYCHSMc05TOdRgjnP7+BAHrROf2PzEVHm+5dfI+HhXL1Arthe242qj/yGnIxdICrKGmEM04p35w4ccRGpLH485f3tUx0qwvuOrdO4rp8LOBLdivcom64B5D4rGxTJwAV4+lOD0a9Cs+cb6f3Uyq6bq51Ngth2NVrQU0J7jRxt69j/XsJg/gKOG1j10z1JCh/ucfPZHq7c5jK7ov/WawuXeCVPWI3Rfud1OChpAoxLpRJMyNNIGhkKautJIcT77eoBHZjR2OOMKgkIh34hBgwPrfjdhhG0pHMHMqyutYdWtXOFop4Lki11IWg3OfEjQpINcTs1o/LgBs0XkQCw+dtjdxki5jfJOV8jAzF2syPsf4lSBJvdtEStZUjFmu/+amlqkJ06l65Y8xH0LbKl13jFQHTtnaYcmljDwDuLkM7U9Fi+Esukx793ZFcEJ4mZCQn+XbEE9GFSuXRT6/jX5C/Uwzf1Q9U7QvGssZOF9/huPMEpJqkR
 XQxiN/UO
 /Vtk5WpEYlmZO7Us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b
commit: d99dc586ca7c7729450af2ed39ca1483c0eb7b5c [7315/10599] uaccess: decouple INLINE_COPY_FROM_USER and CONFIG_RUST
config: loongarch-randconfig-6002-20251120 (https://download.01.org/0day-ci/archive/20251120/202511202005.7GzetV3D-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511202005.7GzetV3D-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511202005.7GzetV3D-lkp@intel.com/

Note: the linux-next/master HEAD 88cbd8ac379cf5ce68b7efcfd4d1484a6871ee0b builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: _copy_from_user
   >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
   >>>               samples/rust/rust_misc_device.o:(<kernel::uaccess::UserSliceReader>::read::<i32>) in archive vmlinux.a
   >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
   >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceReader>::read::<rust_binder_main::defs::BinderWriteRead>) in archive vmlinux.a
   >>> referenced by uaccess.rs:306 (rust/kernel/uaccess.rs:306)
   >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceReader>::read::<rust_binder_main::defs::BinderFreezeInfo>) in archive vmlinux.a
   >>> referenced 24 more times
--
>> ld.lld: error: undefined symbol: _copy_to_user
   >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
   >>>               samples/rust/rust_misc_device.o:(<kernel::uaccess::UserSliceWriter>::write::<i32>) in archive vmlinux.a
   >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
   >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
   >>> referenced by uaccess.rs:458 (rust/kernel/uaccess.rs:458)
   >>>               drivers/android/binder/rust_binder_main.o:(<kernel::uaccess::UserSliceWriter>::write::<rust_binder_main::defs::BinderVersion>) in archive vmlinux.a
   >>> referenced 15 more times

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

