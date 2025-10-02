Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 372D1CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925D58E0018; Thu,  2 Oct 2025 16:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5AD8E0001; Thu,  2 Oct 2025 16:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5628E0018; Thu,  2 Oct 2025 16:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66B838E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:53:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 093E413B814
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:53:55 +0000 (UTC)
X-FDA: 83954376030.25.931CE9F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 89F0B2000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:53:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tnuu0MFW;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IScp/RSrtk4JAYYkDdSACBSDjbaqW24QPU0y3hCA6yo=;
	b=2flLluunJaFXxOlckbihXIQDu1ichbfZkCowXWYJgy49aqySjCXp9Hjn9xvRKfDHUqhP8b
	Fag7YT+Rz6zHLKGJRnjwZYo6UORYqpklKgt6CK9mavnbsvDUIokJ8CxI/bDMFLcB5uMtuw
	/xsY3whoF8yXW80IVNEIgLJzlZBg+zQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438433; a=rsa-sha256;
	cv=none;
	b=RYurUufhgwD3tMPvlS4Xzl36K0ABehOVrgJzjmebbBi53ndbuNImQHWXSqVKswTqVJrjPR
	d7zx1qsjcrhMAnzP1d93fBeQ5j05ZKtRdj+7vTfDMsdKhKFcCwNcOrIIGQbBQzSoqpAiAY
	vFwG5DT/RZQ+0pU4Yql6b9qZSs8fBf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Tnuu0MFW;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759438433; x=1790974433;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=KtFqP/arthrRztirKPKtAcTBBOI1/NQx6QVgvQWd7LE=;
  b=Tnuu0MFWuve13m2A/daYTHKQhklrbF6ybahK4ifUVZZI2HJjraNhjIrg
   qqcHNHwHckBxw7QhRNuOqr3bO7+uelUV4fmFPrDgFk5/d9owj1x9Rcwa/
   MqGR0rfkYT5tYxexYoCMjp4MPgTHv6etiDUlFlmkXboiSs0jczPzJTp9x
   uHJywxv5ku70QCY4xrsWGYFlAojUDryiiePm62ce6nTV6cBB7UENTnUNd
   d7wBqcPLAD63FBqRLicu4LEu3eDrmtpjglpftDWg4Rv/BmKAhLVyTl69R
   gzQ0Ph/kXycYcrLJ55XoCGNSFJuv+eFXev1ZMGcnnzMKU6e69OXs/CZaV
   w==;
X-CSE-ConnectionGUID: KqUklHcVSwqiymL6sU8Dpw==
X-CSE-MsgGUID: 2SPt4EqURbKlx47ieNxCGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11570"; a="72347705"
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="72347705"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 13:53:51 -0700
X-CSE-ConnectionGUID: gj90oZk4Qhq4z+xJTDbB+Q==
X-CSE-MsgGUID: kZK23Pl8RkKIBDW4eFEjgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,310,1751266800"; 
   d="scan'208";a="179571947"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 02 Oct 2025 13:53:50 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v4QJ9-00047b-2M;
	Thu, 02 Oct 2025 20:53:47 +0000
Date: Fri, 3 Oct 2025 04:52:48 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Acs <acsjakub@amazon.de>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
Message-ID: <202510030449.VfSaAjvd-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 5hmmajm33yrobm5sb7wx1413xzyp7jiz
X-Rspam-User: 
X-Rspamd-Queue-Id: 89F0B2000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1759438432-964068
X-HE-Meta: U2FsdGVkX19tYm2Ugn7U8hv0Er8/tpnwsS4zwDoiHynrnVuQyyLaR4UuEQpz/40ccAf/Rx04oWQ0zSuNYluUlj+5qlKfQ/isYQFq/s8pOEoDejjjAbu/BTul3nQ1q86c6qZ2CgCRtFohn11GXMVnwR4epJ5iqoEDdZoeb/Pa9sjPnNuoLDEnl8KURUb+nvFa/HI0LQRtoa2/hh7sjvjTqZb6KvN+H3f7MZrgDqFaa53LZEdAWjPgbCfNs1L/TJiToEZ74skgM3W8ZIxThgTiCfUeyAp1mAC/NkYLzj6L+FYPC8e0gASuA/yotRbnjcT9nD3dOzkUWQrQSRmbiSJfgBrTo71tOWLo2mTh3Wpu9+k0poxBhvzQKNxDfMWxl8ZhUSVdL1naT6cB8Zn+QWI+rrFKOh5IDUAnNi1NXHx2+bIYfKqgPjmmjTgUMfPnkFxsiPYAuB2GpLrPdSBLwXtb2ekty03jDrnASSdvYggLfI5m+RKvz79vem3FRf/5hm9u1nC6FQ6tOKSGXQYnSFAYqvGcWxoNNJ5/VeNLZrRDRzni8bY9pZ2aitU68Wl05EFK08HqvEoGsiHlxeZ+/67x1tUCLNgQ6NGbj7gBSABFkZIc1BCPwwBegmt+RPxDCmg9fsYI6kArUlPPNBKcupjXXA4fi7pve1bx94iWUlId3nC5/zMQR1JIRcYh7foIZWKf5sfzeiolgp9EprskkOQCt8tTcY9pMI7CqSipb+Yef3vWPlW2CWa+vhK6ASq0JhRBYPy1uUt0U0t1mMbSBDR+G89zEtaxtD15Ho+WXuZipC9TIss/kWo94Mz8olG+YZQnbvmUj2D5CACUwQZKTO8ge4pEOu+B3Bvun5Fc+k8VHHYS5+UhIyEdE7EiLYoPQPNGvyKZ9Hf10cwWzdF4DlCeajSiUKtviELIk77RrV9czWXE9A2+uIp54SglycoDiWulHNH6ZbL3MzdO9GXInbg
 EqLEaKjW
 2FsvVGLGq3fQK5LRm0JxXDCQavCPkDGHWNXXYhRgqXb7DwETsgkqeEni9DosKt1WOUMwFa5zWKiV/M3k+2lePa4v06Om6TDlLAe8JhXHoVRClbPUWyTi9p9lfOKjbc0vw5l7p2olKx2qgjILIidjlr8CgQWQlvrKx3rIG3hRjeI+M8LmEZGpJKuVFPxXFxTiPxDmyNUE1YxeJUsit+w+dnaZzoEDT6jFhpy7fJ4QLb93eAjGnW3jAGrRHhM77ZfTcoXQTAnAG1d4Bq9hQRQ2lwnnl9IFeNC8a4YI8fi4dUUqG1eW+S/wFX9c37ovvgpzuadJY52n/Ns+cAZX5ipvKRTf3+ZbbxoAsrQ6W3HRv2QKPtcGcdRRC4AzB/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   7396732143a22b42bb97710173d598aaf50daa89
commit: 8355c2312fdfe590a296b8abf9414ab7ecb49d1d [13069/13300] mm/ksm: fix flag-dropping behavior in ksm_madvise
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20251003/202510030449.VfSaAjvd-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251003/202510030449.VfSaAjvd-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510030449.VfSaAjvd-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0425]: cannot find value `VM_MERGEABLE` in crate `bindings`
   --> rust/kernel/mm/virt.rs:471:49
   |
   471  |     pub const MERGEABLE: vm_flags_t = bindings::VM_MERGEABLE as vm_flags_t;
   |                                                 ^^^^^^^^^^^^ help: a constant with a similar name exists: `MMF_VM_MERGEABLE`
   |
   ::: rust/bindings/bindings_generated.rs:7936:1
   |
   7936 | pub const MMF_VM_MERGEABLE: u32 = 16;
   | ------------------------------- similarly named constant `MMF_VM_MERGEABLE` defined here

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

