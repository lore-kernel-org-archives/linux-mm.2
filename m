Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34958CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 04:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FAC6B0005; Tue, 20 Jan 2026 23:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD136B0088; Tue, 20 Jan 2026 23:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4606B0089; Tue, 20 Jan 2026 23:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5CB6B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 23:57:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95C39140613
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:57:38 +0000 (UTC)
X-FDA: 84354762996.11.3B1AC1C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83072A0009
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:57:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bKRImkAl;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768971456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=0DsvDzBohPssCCnHkebRe3z+OyfcXAxOwulORRBQipM=;
	b=2YawdMMeTuatnIep7rUEdkcETX5jWH0OyTDzZpwodX5a1Sk1kzNGMd0rhGOYd7UO+3DY+e
	ptN2dQaK7g5vezhGZ96+g+TlQYuHUI+eTZeML/iiO5bje7vJrcMWMLduUJgbE7p6+TMXFS
	sE1YP3sxDstmKozVtr04LNVJU36Kcms=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bKRImkAl;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768971456; a=rsa-sha256;
	cv=none;
	b=WlkmK9RcPSV2NR+4KcK2tGqxeoIlluQnJ8KN7B21RW842NwntFYhy9lEB5sif2f/vRpzf6
	981Yjz+TCDdj8pWYw5t3xZ6601lmOKncbXjpHLsxaIgwheNN2PxoPPyzyDVA2A6LODNlIm
	BvvxZVyMK6WjB0qwFf/HgbVuURYaARI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768971456; x=1800507456;
  h=date:from:to:cc:subject:message-id;
  bh=GIT0JXLtzHau/BWSlIoC9YCgdzfrB8oIKkigY13+HaY=;
  b=bKRImkAl8zLK7yg0TWzLGklv2B8eP67+t9H/V+Aiz4X8b0xtxUrCXJ4Z
   7ZkkksThEJvotDN5d1PATSmZ+04rnczfYq4EMmbLXuiPwRCoZ7JC3Ff3y
   eux95CGLxW40rhHiZymI72Q9fGPZryJhAzSg+od8a4C5aRwRSVNctFDsR
   TQC4hGJJUuITPLbTP28omKmrxP5V/tbbH7S55eYqhC/lIcsGl0fghoHFB
   AElxNMB0fBXY/GRWGHSo28OLzxOMnP9DqHisA9NYGXscKyyyQVg48KHlQ
   y73HQmZSCeJdD7tzOPt4LxD1dMPcgOQaG0/C3joHeLwQ7uJNFKy0UE3ev
   Q==;
X-CSE-ConnectionGUID: 3yEY37srQvWUhqvJZLswdw==
X-CSE-MsgGUID: /YMTK86BSpuk2/L46Bv82g==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="57754706"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="57754706"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 20:57:34 -0800
X-CSE-ConnectionGUID: J+3WM+jwRxOXmjm6JVWU8A==
X-CSE-MsgGUID: d31Jqif9RfKBbZhxjbCfcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206570206"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 20 Jan 2026 20:57:31 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1viQHZ-00000000Q01-1Jeq;
	Wed, 21 Jan 2026 04:57:29 +0000
Date: Wed, 21 Jan 2026 12:57:21 +0800
From: kernel test robot <lkp@intel.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Andrey Konovalov <andreyknvl@gmail.com>
Subject: [linux-next:master 7687/8302] ERROR: modpost:
 "vrealloc_node_align_noprof" [mm/kasan/kasan_test.ko] undefined!
Message-ID: <202601211250.6uQzZrQp-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 83072A0009
X-Stat-Signature: 3g5b1nqgmqxbn3zebujrmc6pmbdzxjgu
X-Rspam-User: 
X-HE-Tag: 1768971455-532373
X-HE-Meta: U2FsdGVkX18Y11J4t5orLXGmJIQ7DgSJsTS1q6t3K2aZ+dCUDxcwd7yVDoYVCmhxpI9fzcMsBpuS/aNE9vAOKTxMu5eVxBbg/Zy+CjB41uktQOGqpxZPxmgG2p9lHRlAImcGA21ln0iVWj7wMsFqeo9gNSlZKjjHMNxevETnRRckynSNPGPiEglv6/0IOjHcMB1wR3mf9KUYlsP339KmRjsyJBj97QGpv4G/aU7wAJMzqglKfSd/7+OWn2VyUJX3gRb+3X88G4e44GR0v3iLtFAgNrm7P7N4AynYJSBLBCCwjOs00JWYwvPuOb8na2kZj0fedw1QI/DaVaiT+ddQW+ir9ddCemrf8i2z1shUP/w/h0wPrLOjn1iBrj3clEVx5l/2CCE+AADB+dA2eRX2Re7mQzVIiBLLICP5QjphXzhPBTdnXI7U2l7ERF35kibw4JhzlZBIszruXmseKpn5b8AFvmIduCQsOI7nhCESggmg0PWOCISoHcuf37WZ1EvfSYenTbXXjAGBVeVRveaqUTqn+DgKK94c8sxjJJHFvYSAb2fdw52mGLUKUgPA89iJHGLH6Q1owPIxl8Nw6baZhIMoKgTlX4ztQnkvSwifsJ+p65ZcVvoKIrUVpthxNqAQaDp0clmIdIF5m0igkuYJWNqLPwze1l/0emCEg/6TvZuO+d6ITCEvxQhmV29seWviSmrjWHBQTHUssY9WcA5RRepNYTUl0OfA4UeWH27oa6a/jUbVlXk3yq0VHbmr48vFEhspdnXOHSoQq2qEzv9/56g4U50aa4qkAxVIZT6qs/mx87DnzDy9hvCiIdIbGEJEbIz7o7YAD/ATkca++gOmlp2U8/+ASaU0SW5YWG0mjWrpj4KUpQo/C6VOoA9bSwse+WOb6IZIU+vR3H/VZrBQctGUiTOy2eaRl0DTZIljlR2Q1lh8t3e6YlqQDqle2MSfXpEWPqprtOaZvH7LBcr
 KkgQZ0kj
 fmRqbr7plJZUpOUtGy12N3I5CdN6JLM24rHCdxhAGmvurlSK7lhDWQsl9/yBb5Zhj93hUmYLaN2wK58Ex9YRnARI3EQQAed+NNFpd09RuNanSu2rwQ01vPUhWQCs2oXbtV8lEZ1OgtDsGFFXC7JhCgEGw46SQfhCDVcVmWR9K5+EmoU3F+6FwY5U5NlbX/WgWZvyTwca3WoGHGsBs6uqmJXVIeWDHK5x0Rutw/GbJM6Y77Wll/dQloaOh03JsSAmJvMuDW2oab8NMA6zWMzGGz+9oS0p62q+mSBOYQq9VOulEWWmCZab9NgMpy8d2JEsRgiFlBWiL369qUlLRSP0Wuv31SPWTUaTOa/ehppYVGZguErNysiV43zV9JbTH2Xc+dOFU7cHYKtsNwbn520Xa92RE1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   053966c344dbd346e71305f530e91ea77916189f
commit: 22228c860d2633a22656cc506022c657fec15194 [7687/8302] mm/kasan/kunit: extend vmalloc OOB tests to cover vrealloc()
config: x86_64-randconfig-121-20260120 (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260121/202601211250.6uQzZrQp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601211250.6uQzZrQp-lkp@intel.com/

Note: the linux-next/master HEAD 053966c344dbd346e71305f530e91ea77916189f builds fine.
      It may have been fixed somewhere.

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "vrealloc_node_align_noprof" [mm/kasan/kasan_test.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

