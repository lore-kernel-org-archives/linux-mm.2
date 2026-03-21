Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 164C91099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 02:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BF06B00A8; Fri, 20 Mar 2026 22:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52C156B00A9; Fri, 20 Mar 2026 22:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442376B00AB; Fri, 20 Mar 2026 22:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 322456B00A8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:36:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC2418B915
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:36:10 +0000 (UTC)
X-FDA: 84568505700.17.C93915F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id AD024180007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:36:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PfmLuYVW;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774060568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=s0WakklSDjzyrhJ/h2VKc1lmF55asxaMqTUGunRzdPY=;
	b=M5OcJm1LNw2u5VvXYPFcjSpK6fbq4FM6PbpeUS0otS2PtVCVx+o1sPUJuwOtJjbafrJCRq
	VbiTBGKyk7dtmIU1UZTXbjetukuLdiM9JMHVYl1xVux90NguZN4Gsmdc/5IDCswAebcJiI
	PNCepVJycRcKXPOqLm67KMBFYQpzEa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774060568; a=rsa-sha256;
	cv=none;
	b=0Dxb/i0NWzHMIalRFElxlyAwdeBlOPVSQ9MNmevG0POwC2mB+/l0iUtemOpEi/qfS6ch2n
	UumH+4UHoxH2Ioxo/RUeqoFTr6qTToqjnDNsX083CDig5GVJG0UKWtlzrg3FaNH+skTrZ3
	EYTc859wUIHoW3tZfag3mfc4sE9nyrA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PfmLuYVW;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774060569; x=1805596569;
  h=date:from:to:cc:subject:message-id;
  bh=ct3uPQhA2nFRuX8rAyBQblfVPe6tO+80d2Lg71onCcc=;
  b=PfmLuYVWK1KrrVbeyozOnxmaLcKjE9PUzTGm7/CJShOnLAGwE3eoz97N
   kwjM50wGyg+qNC8emLN/a0XQK9DOPv+HDjAM+GMGSp3HN8CGFYdP8Utwa
   Vk8ilb4Qql9ycKdtlSPAXx9SMuppcdYLmMPU+1iCPLiFnQGn4e3jykt2v
   4DYN4b6xxm8J7v/33/imEzrcV5dUaOAm04vwMN6PpQXtUfMvfqmHm0f3m
   KehcFTZuQfE77ZzZXByv/dKdk9cRuO+R/BYJVwe84SiXWzxtnkA5ryd/3
   PjP5AnPWoJdYU8LnPlvCnTy4tipH6sj7flP75Vtr3EnjzZwTPTSvECSmY
   A==;
X-CSE-ConnectionGUID: qkxhAgJDQcyZ9Qcha+dgKw==
X-CSE-MsgGUID: yGGXd53XQd+oW8c0tzsYZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="75118420"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="75118420"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 19:36:07 -0700
X-CSE-ConnectionGUID: ahcxBdgmTDu7crXelRLSfw==
X-CSE-MsgGUID: EQCa8f23TteNE7yYpNwdIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="223443438"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 20 Mar 2026 19:36:05 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3mBq-000000000Cf-1Kt1;
	Sat, 21 Mar 2026 02:35:53 +0000
Date: Sat, 21 Mar 2026 10:35:27 +0800
From: kernel test robot <lkp@intel.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 7331/7971] error[E0277]: `*const
 kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
Message-ID: <202603211040.LUJzjyRs-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AD024180007
X-Stat-Signature: oofqp6hwp83muhfy891aerizpm3zqqn3
X-Rspam-User: 
X-HE-Tag: 1774060568-598355
X-HE-Meta: U2FsdGVkX18BsQ11i9jdDQrzLgQ0RbU7+q9M9fcCCdpLLkSV5e6Y358LsXk1VD3mMNQWQRLH0C0FkIQ9c9IzX3o7XYy5erFM7/pA+HcYo3NGSuym9tQPFXSvtHvyooQhfH61Q92mmGT9bmKorRMyInc8c7ASBCoMVh7lMC0njr3fhYpMrUXye/rlxZg6XK8QUotHKXB8YxyyhkfS5YftRVeq2Mxtoz1AgxOsifwyha2lFNgnvRmKBFhitbRpqbp1Z5EUG4tFyxh9oNI7CGYqTIdiUBq6nUHKhUv2DxAgX3hgMyVpBPjc7tppzyGS9MC0KyPLNyEzU/6e/dZkRJf9hRS/5twuXuN/Lbzc1NWQauyENqjLITbR/SxAqk8ZYzTqdoWDWzr6c2oYZLP84+e8KW7UPVtGkGOhodBZgO/brYMhMAxD9T4h7K5jRcjQwG5MdH3fwQpZlhUJKy9in03vBsj5IdI0U2FUgjzYgTqVT3ZVTwjJ9foBj3sc5rbOivmbm8nd+OgJa+oC53qPWHeZgslUyv82ebHR1iePyFdnD6UM9HomD8mGHr6hWoo7+ru8QnZjcG7iAxBF10RNeLYWbQsjWPDfBe+h+6ip7h8U91NNDcRcP8wAHZcXAP4ktJh/kRRw3jbB0lsM2SkpqbwHu6PrGp9eOAjNbrcWW5VaWT1AY6chrse4g2udjy4cYeLYH2sFiZuNkIE318SouFpk1B8BcsVumfbrXhaEe/onp1Sw5sjxaXNU662Ph0tNaMgio1cOopGsKTMKYDCDrd2SfhKlDTW7GgK3+cIcvCPfsB06sz3Ud5ILkwfeuDc5qwKvGOuxdX+owyNyL+QoYFnfHC2c3JWIzSZrmt+6iF5h1OIUGZTjB+ysUYW3kHxm/l32fFUuCJ8LCjBp+qE6h87noRbazh2ZnwiaLeuyOam2KnOI7Ls6sVvuCaLb9SwWb5avzNYT9556+b6Uzp+B2AK
 o8iaNFEK
 UGh3qdl1WvCOitomV46k/XF0yVhUOdeLxIQo4fOk8svf6UMqjWiBSl62tmYLNsOznbQqAGKua46xYNzX4I7EOjCY3blKl1pCMWNCwjKsnHcZntaaTDUyWaTSFU8TE0EByDT+EJRUaCkImmXq45l3O8+pon3SrHfGMevIMCCoN/h9c12TTPRBEpxJha12eezSHXp2X+VFfxy6n6zTKtM6JlgjAQr5fErKAdhM6QVYOzJYiiDSzlaVeLiAMSIGETrDrcmIHKFmRv+y5ZYO4l7QJWGks7ppOdTl/MStY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
commit: 21ddef4fe2b87aee0e4e707866219c3e42a9e2c9 [7331/7971] userfaultfd: introduce vm_uffd_ops
config: x86_64-buildonly-randconfig-003-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211040.LUJzjyRs-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211040.LUJzjyRs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211040.LUJzjyRs-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0277]: `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   --> drivers/android/binder/page_range.rs:146:23
   |
   146   | static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
   |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ `*const kernel::bindings::vm_uffd_ops` cannot be shared between threads safely
   |
   = help: within `kernel::bindings::vm_operations_struct`, the trait `Sync` is not implemented for `*const kernel::bindings::vm_uffd_ops`
   note: required because it appears within the type `kernel::bindings::vm_operations_struct`
   --> rust/bindings/bindings_generated.rs:74249:12
   |
   74249 | pub struct vm_operations_struct {
   |            ^^^^^^^^^^^^^^^^^^^^
   = note: shared static variables must have a type that implements `Sync`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

