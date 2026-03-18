Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6F6FF6E9A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12916B00B8; Tue, 17 Mar 2026 20:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2F06B00B9; Tue, 17 Mar 2026 20:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8BF6B00BA; Tue, 17 Mar 2026 20:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABA36B00B8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:21:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 40170C1C0F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:21:09 +0000 (UTC)
X-FDA: 84557279058.17.D45D793
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4D93D140008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:21:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HVRxhOTo;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773793267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=pm6LvSdoFqvAxJMAJQxyrG0YMtGxdkEybT9cHAq+hNE=;
	b=PwfchVkwJACdjD7vKuZ9wH9GIiISjZPZI8Mfad3/9vz9lfXMTFpO6FxFLTArccNNB633KY
	ibriY2oc0SwRfW29b8Jx40/slWlGI7IptJeANHqHEOoDPmRKDdxaP6Yz50+yRWrH+PO88T
	qOh/CnWpNRBoA4hXJmyxjTmwhDlfGcw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HVRxhOTo;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773793267; a=rsa-sha256;
	cv=none;
	b=Y+VvPO1VCjnrduLzYeivX6FTLucgDL8fR2T117et+7yQ3zK+MNuGIzzrOjRuwHQfVDrU22
	Y9pOwGGdo6MW3vEeuvwDHAnNQa1LSC4QKFIQfkItGVVfcnlCPavlBpRxVpQEmpNYuyq0ES
	4WUKPDdLJ6H0AOpdultDBhNkkjaUVzw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773793266; x=1805329266;
  h=date:from:to:cc:subject:message-id;
  bh=gRkRndKxC6k74U/ynUEHeZYF+y/OWDStP+/LOy0JX/8=;
  b=HVRxhOToKoh4EjwFd/Lt7c1/sZD3Ici8p4Rgoa1kIANLynd8Em5fLFOC
   LqyUhML5Ljz86c/kOOwPQr/7BUpVqupjLwcXTzyGhNhDv7KpKP1P2PLfB
   SXVptAU5GQ3xF6e4s4dUoC0rn99tu0+naG8XQHBjmSTk3k9e7vD744AWB
   TkelCLUAEYV/Y4ioTksEznsISgN/2AtvafHaDlP8QiZXbx5ZFIxkuYK2X
   CZ99/MBO2utYWmB7qljiSXecEHn6lW3tGQZn36DxORLy7DE+RbQQCvCES
   4mKw9N9DE8pUVVpLGvI5CTwE+u5BU0NR1XZVRXQng8duS8bNL3bApkU71
   A==;
X-CSE-ConnectionGUID: QW41VNa1SQiq6TxQBSbD/Q==
X-CSE-MsgGUID: sXaUyO09QUa/iSGM0PGc0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="85919099"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="85919099"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 17:21:04 -0700
X-CSE-ConnectionGUID: /XAVGiD5RWWJivLjzsUX1A==
X-CSE-MsgGUID: x9ZF5Q2pSEWSGvGlUrQwMg==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 17 Mar 2026 17:21:03 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w2eei-000000004Y1-2L4B;
	Wed, 18 Mar 2026 00:21:00 +0000
Date: Wed, 18 Mar 2026 01:20:49 +0100
From: kernel test robot <lkp@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [akpm-mm:mm-unstable 178/373] Diff in
 drivers/android/binder/page_range.rs:762:
Message-ID: <202603180101.Ucu0xecf-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 4D93D140008
X-Stat-Signature: ugnb5r411ojm7ay3iz7y46jo5cca614f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773793266-267491
X-HE-Meta: U2FsdGVkX19kWqa3YMZrv/F88247tNXYj90WhouwFqKmFGsqqK+Q+MpmdpVeSGgYrHTZ8PZWShzb0E5ESjB0XPOpULJaLeQcuKk0JE5QznxLTV/zdlkqqfc5paU5LVcsgvp0cJDRrwpUo3aBNX1LyLvhEXImzUhAncuQ2+DqALpGmjy9ZIQvKZH1R4Xe2Sme4e+e0rfFiLf6GjpMOe+wV+dVp1wK0uHrPuOOCevqwnnLxEgYrb9dpWzb+6bqBl19KLpZnXO6/ldgtsQ2psnoAEx/iHabg1r1M1/Tnj34IYA6R1skshWd3zMtABaBD/0KpsFeeWVxMoQo27oc3ohFhg+edQl5j3NjhPi2lmTnS81bJio/4c8uG/vjE2X9qSdov6P8hovjBrHLRYUPzDFkn++JK6jxic18y1AkKC9adKiY0Ck5iTW7ryOadtbRXon8ItYyRM3qCXrIiwuONWdOWIj8m/FNX9BhgKDtuTj31xQ9ACBfQUMkotMH6wj1ut+TC3rqcntZZB4irI51UYEMrtQX345N29ABSXbX6qexthrUQ7q4stdyO6hw2+8zYzSEjRM6XHAg55KC3CXPd/sdCsfKcJj3YCmAV0LHN6+HnxusAcT9s6xFuh/wV1B2NvdFdKVmnzvAhsiaypc2mxSqKBrYk2dObPRfyXNQDMRfdRqwDxFLbm+TSawp993Qtv29/7ksGftROh5L7P0F4Rg2rRIkGtcTW4soWwePUr7puNTopxkXAwwtMqHKSUNdQMW7ts0iLG8GIxDJ77n99mZQcJPEYBPEio6jXRfQSTs/PAk5quOshDrH6y/qmnOjYJuf7LcsRYiOfneMUy6MVLMhXh23eUaut6aPxsm51wU5/41jtropfEY3oLnCSlbC/O/65dlOEktzr4LtRrbYZq6oyOHVX4wae2d+hRAaeSIqBywD7pdV+ykk1cYUkiDCeTQ6DsoQFXirDLB+AOGXkYP
 ZrPV6pve
 Qu9vBylDkiPcji457TIHJIKni7giSbhYYzDFtVLJuQFBwEzcbE37Fb/MMSzdookxvLrAV/TauB+jqAo0pQzKvHAkJevAp9vQpFzcrOSnWAor7IG1hR6kErzHhtEQTWP9XJLgmULYHv/r4nol5IctSh25BcR+EG/1Ty53LpTLVA8KC6Y7EcXZta7qOAABGgf93Hk6OVMU2rUc2OMs/j0ffUKcbaXbD7L/AjBKq9C4bj+/hKsZSJWuxsM+pLTSkQYy4y1oYZ0J3TXTRjeh6M6WijWyEp2O0gF7MZpK/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   62b00bcb1e330a36eff84d9d976b340a7bef6952
commit: d061c7d44da39ab5ed6e4696a8870d21f1540916 [178/373] mm: rename zap_page_range_single() to zap_vma_range()
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260318/202603180101.Ucu0xecf-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260318/202603180101.Ucu0xecf-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603180101.Ucu0xecf-lkp@intel.com/

All errors (new ones prefixed by >>):

   PATH=/opt/cross/clang-20/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   INFO PATH=/opt/cross/rustc-1.88.0-bindgen-0.72.1/cargo/bin:/opt/cross/clang-20/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
   /usr/bin/timeout -k 100 12h /usr/bin/make KCFLAGS=\ -fno-crash-diagnostics\ -Wno-error=return-type\ -Wreturn-type\ -funsigned-char\ -Wundef\ -falign-functions=64 W=1 --keep-going LLVM=1 -j32 -C source O=/kbuild/obj/consumer/x86_64-rhel-9.4-rust ARCH=x86_64 SHELL=/bin/bash rustfmtcheck 
   make: Entering directory '/kbuild/src/consumer'
   make[1]: Entering directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
>> Diff in drivers/android/binder/page_range.rs:762:
        if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
            if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
                let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
   -        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
   +            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
            }
        }
    
>> Diff in drivers/android/binder/page_range.rs:762:
        if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
            if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
                let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
   -        vma.zap_vma_range(user_page_addr, PAGE_SIZE);
   +            vma.zap_vma_range(user_page_addr, PAGE_SIZE);
            }
        }
    
   make[2]: *** [Makefile:1916: rustfmt] Error 123
   make[2]: Target 'rustfmtcheck' not remade because of errors.
   make[1]: Leaving directory '/kbuild/obj/consumer/x86_64-rhel-9.4-rust'
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'rustfmtcheck' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'rustfmtcheck' not remade because of errors.
   make: Leaving directory '/kbuild/src/consumer'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

