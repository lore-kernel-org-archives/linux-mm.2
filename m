Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A63A0CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:24:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389976B0006; Mon, 17 Nov 2025 06:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3609A6B0007; Mon, 17 Nov 2025 06:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201B36B0008; Mon, 17 Nov 2025 06:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 067606B0006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:23:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BAAB25CF5E
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:58 +0000 (UTC)
X-FDA: 84119864556.21.FB271A5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D68540010
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:23:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FgFZ+pH4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763378636; a=rsa-sha256;
	cv=none;
	b=4pwU5ktBJ9Agbe7PKHkJ4wqzYwEA8k3fcNZh2vmHNZY9B9tspyn8DyjaCcQj94dxnxNWAu
	PQF9xPYqPQOQPRv6VECx7GCOC5LU8ZIkFRa7Q+zo7OC4suBZs9VcO+mRCbdhXAkleF/k/X
	1Kyj+exCXu5Mfumbb1SylooLd5U45e0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FgFZ+pH4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763378636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siib23t+hNtukSvoLOuzUZmC/PSqKEvTg8Q+6OABCwo=;
	b=8n0pIwIG074eL1JP5HMOVE7a9Fg57LabzgcRiL0YKNsej3jHlUcTpESnTtL4eDSTP0zYPb
	wZeWYNRXrbJeQWCzigJ046iV59rFzM54cUii+ko9kI9G8BlyoAopYzku3EmVpXuudV6Cfn
	UjI+PKObRV/iKVyDRITyU3O3II9d2Zc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763378636; x=1794914636;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IyRsD3dFuOO27FuFU8cJdLCxe9lG0I9aLgo2AGV7OmQ=;
  b=FgFZ+pH4ZcR8T8WsLSL0K67TMiRkI8QZuoUDWV4I6LtVcb88OIFUNj3w
   MTLgm3qAJBJQkhKensJ2qaF+Ei8XPthidc3sML12pLlc9n5xRiwxhGqXW
   7LxyoC6D5rKrFvApJHixtZ1DEMzDixo+6DIdoJZU0iaQI8m0dmcnSHuhw
   SwBmtqsee3wBoSNEb1kOGAXmlPtOzCc3YrGV9Uj/HqPnEiVVPKnS9zHri
   NzO3jn/AcD1+fPSgHo+3wQg639CGEZoH5A9g8BE3crT5NBeC107n6hMtl
   H9MmkojZwZkQ9DJkFAeDAhCnltxiRbTqFY3PfobfdV3h0v7kemo+DEdZE
   w==;
X-CSE-ConnectionGUID: DwRq9XFnS6ePv9c9f+T+mw==
X-CSE-MsgGUID: r2ETNlOVRZG+nW8QzSeaIQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="90853245"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="90853245"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 03:23:54 -0800
X-CSE-ConnectionGUID: Qhd01F23SFSHkb5YSclT5g==
X-CSE-MsgGUID: r/l+7D0FQDeMDh9iiRGZFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190220827"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 17 Nov 2025 03:23:49 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vKxKk-0000U5-20;
	Mon, 17 Nov 2025 11:23:46 +0000
Date: Mon, 17 Nov 2025 19:22:58 +0800
From: kernel test robot <lkp@intel.com>
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
Message-ID: <202511171912.yMOEajkV-lkp@intel.com>
References: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D68540010
X-Stat-Signature: q6jacbdw6i5u8ayc1snp9qkqpju6u8bm
X-HE-Tag: 1763378636-625094
X-HE-Meta: U2FsdGVkX1/2H3g7YWpLemCD69Y321n/froynEikGKw+uP0WjBwfQ3wYlPisXslCWW8/lFIV1nYCV3exdPXtKzJtRIX3K875Q/qDqHfmtr2eQo+cCXbNB0H11xhw1TLXP9A1h9B1838D85Gs4VxmOHYARGZQAafSMr6YAf68jW5bLgQJo9oKIvbkLRUD3U+lbaNvxjKcvg5pze8hVfbDcXGq6aTUvqcrCBaWwRaUsT5XwQrKpN2RMbo/fQ3G4Tij/C4EKNg2hu0E1iOM7UJOZwedYQ5bnebSGNHvwpH1SAo4HZzPI5aOhegZw1un0oLSBWoC7SHajzoGa6Cgy0LaH0Me7L9t6PkEdK27J5DXjMO6cOVir+kSYX7AgC43DUBg3x55uSyN502/L90+QH22uTCg7LS4zRNFJrZZQ+cqi0GUN6KR5/Pkg2mUN64i8pFg2LL+tKzsXU0G6m1X0GIFIHBKZsgtrSVXzGQJq/L4/n43xjH1HDqMurub4NxeFR8OZLezB2KE9ol4dZpt+WsSBvowNXM0kPc/bXw4LiKOgIjMXXmrBArAsGeDUvEsbENzei5OnnL8sj5uasNr+kzubDXsSSfygzatkfKEyI3i1/DIIx857efxBeJRkMXnTZunY4Q+Mfrc4R4p8DMrRvfzv0rgLiPMDqtIiNhnwi0XNm1vA5RnJGY53esA6ccCSFBqP9EhmqFuJymP8jPeiQseGjAc8AUjs6yV3RF9DvnXe+CBj89Hq9aITVFXmDo/VWYGaXZFrh7ja0zPelHV1U66E5NVyEr85OsFXTxO5kR5azT2KhVcusoL+46aiRwBy39PZRKi/OD2uWSbscg1b4/ZN8PvtIaVj7xYxsslnLr/5oU9URrBthXLTK6bovPbZ2gln7aaIs85w2/mhyJmVED58VVezDpx/A1kzEpsTlvghlkBJnoDtYVapvX2YfTTtTWJNopJNv6TbxDlC+8t0Xm
 2K77OGz8
 hC2Na4RXHI+s2DacZxQRZ9Yt4Z03ZqxbdTidEV+8Sc7+N3Jgw7eL70Gg+z+cueOqLhymqNq2kE/0tDdhe7DckzusyBKjkQJiFRxNmao0SccE+EsPNm4yfnYKj8wYl/+hRWBjhvq1xeeoT0vSfVPVdjrKAz8f6DjVXZDdOwyGSmLm0b9psvKhCroPTmU2R+kTmIIBqwUrPkd2Tt+2aVDA62/3sTMdes9d5ZZbrwQZbFwAs5PPm0nc+mEgG/rbSiZHNSEZdQ2gIuobHPbwmHL6C6SdoG22rlpf3HPwc4LfUriEslRJrLezhUCaqi75b87Gert7MAs13cYAPm4GR3XWvkxF5Jn+5yDgHkOweN1TQ0JznKmrOYBAz8kCIm8bU7KGKRTagecGX/aeso8OftSfH7hrtGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 41218ede767f6b218185af65ce919d0cade75f6b]

url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swap-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251117-021532
base:   41218ede767f6b218185af65ce919d0cade75f6b
patch link:    https://lore.kernel.org/r/20251117-swap-table-p2-v2-18-37730e6ea6d5%40tencent.com
patch subject: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20251117/202511171912.yMOEajkV-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251117/202511171912.yMOEajkV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511171912.yMOEajkV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/swapfile.c:88:19: warning: unused variable 'Unused_offset' [-Wunused-const-variable]
      88 | static const char Unused_offset[] = "Unused swap offset entry ";
         |                   ^~~~~~~~~~~~~
   1 warning generated.


vim +/Unused_offset +88 mm/swapfile.c

^1da177e4c3f41 Linus Torvalds 2005-04-16  84  
^1da177e4c3f41 Linus Torvalds 2005-04-16  85  static const char Bad_file[] = "Bad swap file entry ";
^1da177e4c3f41 Linus Torvalds 2005-04-16  86  static const char Unused_file[] = "Unused swap file entry ";
^1da177e4c3f41 Linus Torvalds 2005-04-16  87  static const char Bad_offset[] = "Bad swap offset entry ";
^1da177e4c3f41 Linus Torvalds 2005-04-16 @88  static const char Unused_offset[] = "Unused swap offset entry ";
^1da177e4c3f41 Linus Torvalds 2005-04-16  89  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

