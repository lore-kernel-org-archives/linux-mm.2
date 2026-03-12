Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9FDAFED2CA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DEC6B0089; Thu, 12 Mar 2026 00:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2179C6B008C; Thu, 12 Mar 2026 00:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A9A6B0092; Thu, 12 Mar 2026 00:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2B426B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:37:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED3911B8925
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:21:43 +0000 (UTC)
X-FDA: 84536112486.02.0594C05
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 26F6E40003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:21:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AlAXP2m/";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773289302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=iCa8wKzR85q/vCI7zUO19K1V4IQAycjrRe/A9qJ0uQY=;
	b=RMHDIild8uB+8A53/sfcu/gkS53iPWY4Znsa7kOGSaLAqatWVypi0m4UMxU0LY1k4ZLr16
	TlYZS2YOV9ePiRyHXRrlYXc5lqaOvoYXizRcmIIoibTOTpBBj/2LgSwXza/sgxKxkZ3wkO
	SEO1UNSIP285hoDBVBgnPhACBZmoybs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773289302; a=rsa-sha256;
	cv=none;
	b=pbMp9mexAwynZVBJNYBKK9Mg6IeGqxfzhEpiEYjiPx81gcYQHPzao6shuMnoRqATsxlWF7
	3751ctS+R61U8CieVj6GLy4+5PO9o+GEuVcqXj8HE0AVCsyBInd6AD9Y7Y5qwbVzUhf9+X
	YJESfo2qwi8DQ2tKp7PiMV73XG2vTy8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AlAXP2m/";
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773289298; x=1804825298;
  h=date:from:to:cc:subject:message-id;
  bh=yukLzMZqHtXh/GGuWBRwbEBnFo9PPUiC1EJUBT0Y+kA=;
  b=AlAXP2m/JnguEcS2riAyYYeoskYKxYBLIcgipAoY/w9bPn+ctheS9iTE
   tD3Vqj5g8gbIOlZAU2s9+P+qdBkZxtzCMbQbzHBz2MsFc7wHww8vKqi8H
   LCdOqU35wxA/Dr+w8mxlw8qJows9zMhDPssvNoZstvheannsG8AXcLw7o
   QnNt5k25g2ZdPmmFUK/3LNiAJHPrqygl+kgmzobq9GJe1gPR44V90H8aQ
   NgGpTI9eDBzbPKegNp1qVxfinA6crnTlSjY/rF2c4l9W+Hxw/3pOxo65J
   jyYxzbduwj9Qs40Eg8cQZZnmLtgLsfINuj9Xgia0UUC70YaN5SSUlj2Z5
   g==;
X-CSE-ConnectionGUID: yUQCXHeYSUmziqNuGl7u9w==
X-CSE-MsgGUID: 5DOTAp0lT7Ksy383tyx1Yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="74562523"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="74562523"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 21:21:36 -0700
X-CSE-ConnectionGUID: QjddNRd9ToSPvuVp5Fkqww==
X-CSE-MsgGUID: RoNmFPUwREmUQU+W+6fuaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="218131641"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 11 Mar 2026 21:21:33 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0XYA-0000000024P-311o;
	Thu, 12 Mar 2026 04:21:30 +0000
Date: Thu, 12 Mar 2026 12:21:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 Mark Brown <broonie@kernel.org>
Subject: [linux-next:master 5585/5731] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <202603121235.tpnRxFKO-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26F6E40003
X-Stat-Signature: 5pyirzdnbwbhpqerz8dhsxauacax3ee8
X-HE-Tag: 1773289296-5113
X-HE-Meta: U2FsdGVkX184+So+CGIg4ZV8ulS67z9FuYqJ8DrA1BmxQ44z2HgJkOKBZOyhE2ppWUU9b8aa3Le/aiAn4kqlGvL/uDEZZeBAmb4HCulAUHQnmZmtGUozK0ese+M4WZKpCEEipXS1dueEOL7MrCToPLGev+va0cVoZb7sKgglPPHXYq78R/kqMJNkYm+QaOnNvazsjlghgPFb8BaEj/oXkx6j7gckkqrVbDTe6cFXZDJrniUJM9gh4oaY//sNn1njgjdE9qV8rtDGVBM8NsgsMvy1u1jXQOBTnXAKnV5z+Z2bksGxv+Ms7wdKnoJLlaDbAK1OWXMYc9v4ksWWxcWDA0WuuUSvLA21yLnYEIlwaxI8zDTLVmo6cIF2Z1yxCKkh5sK49UGkpvJznD7WgmwY2diJC9pDQVXuVgXTix7scvD5v5/gcFmrwBfeRODygTL1YFmQbsLdba3rnOtGVxUjP1uoUmoZTY7oW64j0aS8vISg5g3eMjDYOZbFEzDtBxoO/12QquhiKkB2RsZ8SANaEWkO8JpJwm6RrD/ETP0TxcCShi5a/yEls8+q3x6pEhCu0yb1AX7oOjpgpTOgZdRLsNbrgyVzr82Pos0aNK9Ri42plLlDRUuqUQfP8GjZOIQw5J0rvaEMvTFCBHThRW6brsXIt8CGXMPNl2DOEli3cJxIH3IIFWlcx3lojzNhQtLRiUbKVs2Koub9CW5K3gzew4tjY5puUkwn7HB73f2TTm1kDr+ZUe2O4vPTXsyi0ayR2L3scWB+TgXvgadA6h1J3uQCTAVf2UXBBhFg44+AaOIDidUH0vGASUGOwZ3X07iineHmuhz/iNFVSCfuAe4iEsczZsCFfJ2Cw1Mlm9fkSAgQPoIosuKH6SFKusyvqec33SSJ4Vvw9LcD2pxTWWYvbN7tSBQfT3nxTHMKi9od66TXBsOIYB1Y9oKucwa0LE9+/QQK1B4cXz7z4Qlvs/7
 W3lXh8wv
 jlrQHoEu5d1Zl043ysNBSGX/Omq9zuudLALnGcy0PTFT56I5JrE5XGVortFK9IUwkQM3goRUhJjU35dgVK1Kc7r9hlVljleGs9/Sd+lbL+M3OnTLNtm40pnr7mcBvPbcwxQXYWnNqSrq1Sa0ShBrWsYuriUJK72STL5fKuRtmShzE3g4XFSg18+Wd4W0Mpmv0QvQqHjhPfFrBpg4TAMZmqIEZUriLyHMfhf5j9YpK0TZTqF9I324F+TK4xtbqqtU4U8EMeBzEzzpFa5QPHliTTHCYFzHCru2OgecHec9niYhS3yH7xwCoi4als9gYCxjprGZa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f90aadf1c67c8b4969d1e5e6d4fd7227adb6e4d7
commit: 9ef1985c003ea271369c900a93f8b834119fd150 [5585/5731] Merge branch 'mm-unstable' of https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
config: x86_64-randconfig-002-20260312 (https://download.01.org/0day-ci/archive/20260312/202603121235.tpnRxFKO-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603121235.tpnRxFKO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   --> drivers/android/binder/page_range.rs:146:23
   |
   146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
   |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   |
   = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
   note: required because it appears within the type `kernel::bindings::vm_operations_struct`
   --> rust/bindings/bindings_generated.rs:72795:12
   |
   72795 | pub struct vm_operations_struct {
   |            ^^^^^^^^^^^^^^^^^^^^
   = note: shared static variables must have a type that implements `Sync`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

