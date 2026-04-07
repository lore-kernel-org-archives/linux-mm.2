Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61E64EDB7CA
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 07:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916916B0088; Tue,  7 Apr 2026 03:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A04F6B0089; Tue,  7 Apr 2026 03:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768436B008A; Tue,  7 Apr 2026 03:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6068A6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:59:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF16DBAB2D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:59:22 +0000 (UTC)
X-FDA: 84631009764.21.F229EB1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6013F4000F
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:59:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OT3YQ6Ny;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775548761; a=rsa-sha256;
	cv=none;
	b=MJUEv+LMNsM2olDp1a7NiVnP34NS9/01OtmBI8lkJ6por33oZ0FCEzBUx46WBkZruz3ern
	pnPNyJ4DHPvs64Q3uyZLJjqSRKZdS+byfnWS8M3Afu3mLil72PvXNwVUgj+cW+YnEYnfHX
	GmTzGEqa71xbkxR2gbWmQ0t3Jx0IHSo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OT3YQ6Ny;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775548761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9gipofllLJeGPw+/o153rjrDWxdz3aGlA00Edc8Fx4g=;
	b=DrKfGqw0XOLSJpLePrwVCKR2DyREO3KaofTp6N5NjyBU6Qv65G1PBbWK3210WxrPurBQD0
	2+3ZCGsNUFHBuTi0ROjh5P4gs7hIJl/j7Xej1/YHchNtnx/X39xXE3iSbYF5LJ7eQm2x8Y
	rOkejWfN4G/1anGQOJg3SvDEhuB0AyY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775548760; x=1807084760;
  h=date:from:to:cc:subject:message-id;
  bh=rWUrsv1W8qJf9KmFN4h+K6eWgVKlBezYqGuQLWUdenI=;
  b=OT3YQ6Nyhb/gzuGvEPfLRqWLQMo+EuOkLCX9kdzFp7l+PmSu45/7e/8z
   gICa7+d83Pt2CrrtEKjeMFzryreTptDAxtE+7Fz1HYq3E02snF4hq6b9S
   a1CQpoibcVVUqSv4ZQcfHTXdWjxFUg8wERTcITvedAUpmfJFLMLR8KRAs
   bgKxjHdUArVLzvqX1bOZFNjVe7WuBaaxq5Cf3OWjV1XhybLEuvPJF2YGE
   IwuAcgrzRQfiul6PxKkicBiDCgMzeTqLW4F9Gc19kTlIuoX28hJk8wZGp
   ZtZgEzG3fpoHhpPq+CCrSw4Dk4USPDb8AX4RSTdS2wBKCvDk7zpNzoCnk
   g==;
X-CSE-ConnectionGUID: VmgQb4+MSzK6/s2fJmLqGg==
X-CSE-MsgGUID: glls4arRTjeOhW04Ey6Sng==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76401559"
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="76401559"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2026 00:59:13 -0700
X-CSE-ConnectionGUID: CQEOJtvnT/WcNOlTuaHAOg==
X-CSE-MsgGUID: CatIVsrPR0G6T6j+72S9AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,165,1770624000"; 
   d="scan'208";a="223305417"
Received: from lkp-server01.sh.intel.com (HELO d00eb8a6782a) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 07 Apr 2026 00:59:11 -0700
Received: from kbuild by d00eb8a6782a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wA1L3-000000000Kf-06yd;
	Tue, 07 Apr 2026 07:59:09 +0000
Date: Tue, 07 Apr 2026 15:58:09 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 113/133] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <202604071509.y5vLetYd-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: 3u6713p6ubgqp8kimkma95zzyzf3wa9d
X-Rspamd-Queue-Id: 6013F4000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775548760-46545
X-HE-Meta: U2FsdGVkX1+wm/rrVWj5Unb3JEZeAbrriBe7cKN11oDckX3CMPbj5LgKJDHQXV+KCliYlBMZ5mRSXupT66g5VUGqlrT6wttlFej2dDf8mhXWTYTQ4zquXhxnD3AbRbuc7PZwWQEl+7QtQgLtFGDOERsbWSFOzKrGgl9iMg7vaBsQ93kz5UPZgg2l9zIX137yF3BoEJAvm+5LOh0HtXheMjcomll1iDYyB6GaPDptKydc0MiI+LZwLmlwNzk9Hq9rx9pfodt1urPHEhUXNRkH84xYoqejAi3qH5B1T+nN2xpcC/P+7ZMcOOxfyBT2pxhZSFPIjFH3JEd50pqFXmFEE21HvMgDWMHJvBSaz5Nq3adN/dIPW0lj+lG6xv3kWRlswtEyooyYfp3Ss3gv7nUhpaRt+TLeqZBA81UHsLXqEJHNhOvt6aQjjr4PvdA3OWxvubPS7708eJe4E1dJySkE5ALm2yli8LOOBE5mzk/SKfQ81R/cDqtqV+/iag7ZheTK+NISOwSRIYye1qd44MfLqr8gDFvJ82wA48bMXQVhLzxrA5f/l07OkxQcS9CvxHLMSSRFYyQMHBlhss/VUtmesKVArNiT0h12NAcfXSz4l37Q4TYtt36l7quALsbqTljtiAKrVgWUyKagv+xe+gGR4pZjNYai2K9DcAwtAnbuDNa6obzZPCYi6sKOPlkwpsKDyZN5Qbm6A8cvsvYcHmx1I4xSYULFzOF67sT38DzRKbGx+xb9tNSLdzTxFk1ogG+mAN1qLPdtzm/8EmPdgmMwquwb5WDPZD5HvLTXF75mD/rmpfCaExG7I6CdgFwXtNz92h3dDwtr549bVn9QNfVhRv8vC5c30ZZhig1kFPXPRaCYfzd/cwx5jV8ZQlnnvBftWJMVN1hnWYeNq/KPjFfshvy5YnhMSb4TGjM986uhcld0hI5S0/86Zdz3nBvABwfFwM3iMOaENn17k+tsKxr
 BrEe43EU
 tnW/0B7r9qdApSZFW7FKkJ12CXO7uBJp12DtM1MVlggWwWiNdcH/E2XIXXRcQpMHjjKgbqCOCsVnCtut4DVUfbZmGn33V90siDgMBlOPydQAM8sJh9Z4Y5SBJuwIfL8+Oqbl9yXptrhPOIObZ6Wyun6UAwdNFbTk+laPoZmXYOdKdWvm2CLRA2l9mGYXyCGD6jhVZOqF7J8aoEK1+r0wPvgT74VGRVxbnzWyLwRS6wKh7zIqdnNImVNDGWWrqtMlzv/aLLCEmIArpU/7KaCHASXHYWOtLN1WXR+enC+teNqB8NhIanfZM4W5IM9rz31pZpPRz85Vi4vHgKik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   3fa44141e0bbd5062f2ef0c5cdddd98275d3223e
commit: 694fc0bd3ca5420f4e1105d2dec02327cfc5d64b [113/133] userfaultfd: introduce vm_uffd_ops
config: x86_64-randconfig-074-20260407 (https://download.01.org/0day-ci/archive/20260407/202604071509.y5vLetYd-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260407/202604071509.y5vLetYd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604071509.y5vLetYd-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   --> drivers/android/binder/page_range.rs:146:23
   |
   146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
   |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   |
   = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
   note: required because it appears within the type `kernel::bindings::vm_operations_struct`
   --> rust/bindings/bindings_generated.rs:74703:12
   |
   74703 | pub struct vm_operations_struct {
   |            ^^^^^^^^^^^^^^^^^^^^
   = note: shared static variables must have a type that implements `Sync`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

