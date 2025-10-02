Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F33CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 04:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98718E0006; Thu,  2 Oct 2025 00:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FD88E0002; Thu,  2 Oct 2025 00:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C860B8E0006; Thu,  2 Oct 2025 00:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B500B8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 00:29:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4314913A9AB
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:29:28 +0000 (UTC)
X-FDA: 83951895216.11.2ABD2D1
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf24.hostedemail.com (Postfix) with ESMTP id A576E180003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:29:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="kblPw/TR";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759379366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHF6h4Ls4dHg3uTjT8RkkFkU4hLoyL8d6PtCtHg7MP4=;
	b=GhaELfKGc6StB5Q21w+vtDL7AU3hX1jkuAydmAC3bdrizTHFAuD+scgITp37JIiyWIKeMm
	9nJncRx/o873kf91lOm59H7HpJYgYa4CEWUowET7Bi1e+54AFH1knuHS+3H/goWuaCtn6A
	AbwIDUO544cAHgiwE4QJ5pzxMBbv4VQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759379366; a=rsa-sha256;
	cv=none;
	b=OekNJKcWtnOzkscwOqHgEZGfB/FqbY/NxI7dBSowE2KuIvLLk7btwsUGD0VY2SxAukcTZr
	4XDsvEFb0Z85wxInVspQnIUINgUfyuesJaOIe76V4vpWlTKVLcquA6LNY2Wi+dPZvCFD26
	gHfWdpzbuxP2GFxTfczdsYr1vcqcACg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="kblPw/TR";
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759379366; x=1790915366;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9f+HXNcD7IOFZER/ertfy9YqZjvmxhL5wyEiNgnR4kw=;
  b=kblPw/TRTxqEnWD6cNjUqdZyg1hObOC97mUQxIMKb2Hg9sllY+QQqBqp
   Az0w7kVZhlofUX8DtyeOpGnd/T75QooVH2OecHBqsbwjRWg4tf59TIi5p
   Um6DXM+3YnBTMrYAsLd/ckcqDOdJpF6euxzy6XL0xtZClXhALm9mm4bL7
   hd+WY6sdbDsPeI+JqYqRl+itlOPdVw7USRTfkEpk6Fydz06aTBSLsaTCe
   TfJwFpKWJeW6XAUerf3k/ydj69Rp+RrzEBC+wZ9JS/Qs/QkhqzKYpCQ6z
   MBnxE+M78ZLN0KCIl01Wiik5VonsPy5w/VjmSUS2merjyY2jQtngwRvyk
   Q==;
X-CSE-ConnectionGUID: YrhKulUIRhGTMzBM2HGPkw==
X-CSE-MsgGUID: /TpfYclVQSioz1UphDpUpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="73016727"
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="73016727"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 21:29:24 -0700
X-CSE-ConnectionGUID: LZEq29e4Tqu8t5/Q3RYwFw==
X-CSE-MsgGUID: wbDqmC1RT0KGjEqOh3Vncg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,308,1751266800"; 
   d="scan'208";a="179734321"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 01 Oct 2025 21:29:21 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v4AwR-0003Z5-0K;
	Thu, 02 Oct 2025 04:29:19 +0000
Date: Thu, 2 Oct 2025 12:29:15 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
Message-ID: <202510021229.mKL5i2Vt-lkp@intel.com>
References: <20251001011941.1513050-2-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001011941.1513050-2-jasonmiu@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A576E180003
X-Stat-Signature: rjr336qysj9hciw8u3m5my6orrw7ywiz
X-Rspam-User: 
X-HE-Tag: 1759379365-524237
X-HE-Meta: U2FsdGVkX1/FsYsZSl1rjAd/DFa0CIKiDx0+AM4tXGgpBl7zLnSQW2clQvbyaHSXg3uGXTNXMM8Fgr7IRCL8dzzr2MkebhuUcQDxe5qMVol9Lv/6GBCTEW0q5ruCavlBfW3jRZsP0yYZ7rmdO7JsLcXxCLDqihJNN1RUegfLcnda8MZVhV9AwuLqgWFy8cl/zlcYxrP1aG/Xep82BWUVb0OaVXCiMKIMt4u+5Qlm+x1UwiBLS/4BC3J6vHQz46BaU2uqq4ehDDMooqMfuEXH1uqHOZS5GGpnefr3uIadYcy46o/dd3oRV8UXLrsqbVWHyqjYHcWgSUN65UEpcWmpygxrXYfqp1fCbs4S/Pg15yxwNy38f8EWVCh6Iab5zi3uJ/n8s6jUmLwcOCcv/6EjVkg7RjinRK3TTkokfQG4F8u36xdt4bPFFuiV88W13Bk2Cr+8QKrL7pxP5K9xF41hh4lFPUDLtwvGn55PJnRKWmaIampzmgAgssuwt8jF52hBgbeoUz33/8CLQvU64j31b34IVa9gmHg97UDBFC5H9nj3nuDrgoZKE/Y6EU2ntdm0BnBuCFexoMI3JJlgYadqfOlxZxlhOQ8huKtiPKEXICaUPlgYaza5iN6AumA/1evsMA8j1WqivnWOXmvxsqq3PMqCXUfMijx0wcueZyRjixfcvuF6cHr+VwEARuRhgaF8sTYK2RWnPWDg6KVEd4Q104bbUYFe82/4f1jrJ6fAVzI48HmYpKjkNAg0N69mzN93R/J+oVBH+oyOxezqxlPxvm6N+iFsdGrwSDXJkeu8M2jQ+2C2c26psBMQrFxTn1mmxc06UWDLjxFmTnXbTYZsoSzk+Tmpk/vDC0cs/de0LbholOATcW/p3fdhsbUxYihP0GvXa6rq795AmFaRhvyEA6kImhbY3vdst+/rEAuo2C4dB29ijjWcpZkD6gYclrJmvRLuozldgX2ff9cAyvf
 FqN7a7C7
 7PlEJxGUu7Q/chB0Py/k9ohypi8LztUVzCZpxOWYvqdywHG7DLi49EXFZZGRxPEkvQLcn0/fDig2q1KvLO9D3RtAWcrT6InW02r6SFcenJf/Sz35BEarL8JvxDYu60FzQPx841YBk22hgOCYjq/JW/nHjvJyzxqQK417j2/uzFhkC3P8JWu3akP0nrl3oITBoIm0fPhSkOHSo7tH5Nbk+sagfz53/QFBi1cN1Bk/Is7Rs1xVcOqxBj/7s7/FFi/gvaZ9nX7I8c4Ht7/xoQpjAYVcqArHx+YjGX+agpgQxRs2SsY0jJMEsOlE+rIjW1nQur0P7X9pm8sYvdMJ4JMHMcJY7sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rppt-memblock/for-next]
[also build test WARNING on linus/master v6.17]
[cannot apply to rppt-memblock/fixes akpm-mm/mm-everything next-20250929]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Miu/kho-Adopt-KHO-radix-tree-data-structures/20251001-092230
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
patch link:    https://lore.kernel.org/r/20251001011941.1513050-2-jasonmiu%40google.com
patch subject: [PATCH v1 1/3] kho: Adopt KHO radix tree data structures
config: x86_64-randconfig-005-20251001 (https://download.01.org/0day-ci/archive/20251002/202510021229.mKL5i2Vt-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251002/202510021229.mKL5i2Vt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510021229.mKL5i2Vt-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: kho_radix_walk_trees_callback+0x83 (section: .text) -> __memblock_reserve (section: .init.text)
>> WARNING: modpost: vmlinux: section mismatch in reference: kho_radix_walk_trees_callback+0x91 (section: .text) -> memblock_reserved_mark_noinit (section: .init.text)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

