Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2886BCDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 04:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54F2C6B00AA; Fri, 26 Jun 2026 00:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5001A6B00AB; Fri, 26 Jun 2026 00:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7026B00AD; Fri, 26 Jun 2026 00:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 179E06B00AA
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:55:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 858474039A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:55:03 +0000 (UTC)
X-FDA: 84920849286.04.A42979B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf17.hostedemail.com (Postfix) with ESMTP id EED8440003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 04:55:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XPwjl1zH;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782449701;
	b=F+HrluJ0oxKzUGQ9i6WzJeCasAEnsZ0bZ1r0qhEb2qpJYcu73amCPoAEqQYzm8btW+4/mr
	W8oddoRBwbuZFkyjF9o7kxNL702tbXJfBwaz6iyfG8zS3EOFh62PsqeMvXryUc6N/qwjE+
	dIQBaLSAOI2u6vXia1XnQvtiPLowUxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782449701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aqCS10w29HCUyyDrQgMhmUaKtaZBHTQiO8fdKXN5pqU=;
	b=d0nj6UEOpXIiX4BhGUt4P4pNwFMViChhj+SXgHbnCYvgamvAY2U/KVuOhW5ge4CF9wC5Dy
	mC8MzL0MzGlV741FoAeUpWCK0mXTtpHB6UbPQ4/us/+YbaeW7y42NZxf2hGJvyjw9o83se
	/USm+eF8hl2N1/53vlyOhiWQlzDo82s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XPwjl1zH;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782449701; x=1813985701;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u3b1STjl4yzzFtELpqEEALpMDyw71hALYZ6LVdfVQ8k=;
  b=XPwjl1zHxQj3lKAX7//4mGN+dGGD7AC5SPyjW3Sf4hmyjU36oPXpIoGm
   OxEZy0QZMtMvwy0Zn/GZBbzmqo1RzzgttWs+pNnEc5BXAKFioRHkyUOce
   w7z6oURHQ2SqNgBTGgcrDM93Hs46KoOoHCQubX5I5JhSOCVOvmd6etYMh
   huOa44hlwBfNwZ1YPsY8DXxA1vmThwJ4WSHwugmlG6lqGJ/CLEhLXD4fz
   uc/Y4FPNOECcdUV7t/15Dw4x7K9KbRSp6GeJteMnm+NHtGV+td/LqtXWF
   VCP6+3uuZ1ndK0Zj0fzvJB3jnoT+ESWEsuzaivIIFQOkce3qYwMXA336/
   Q==;
X-CSE-ConnectionGUID: BULy5uzhQmWw+fYkRl60qA==
X-CSE-MsgGUID: vZ5pJbqHR82XOhNnQv1E6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11828"; a="83378626"
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="83378626"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2026 21:55:00 -0700
X-CSE-ConnectionGUID: PnRCxRIdRAud59V/9KWdQQ==
X-CSE-MsgGUID: FUOmsUQ9S9e+AvWQsoG2nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,225,1774335600"; 
   d="scan'208";a="250841154"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 25 Jun 2026 21:54:54 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wcyaY-000000004mN-40QC;
	Fri, 26 Jun 2026 04:54:50 +0000
Date: Fri, 26 Jun 2026 12:54:39 +0800
From: kernel test robot <lkp@intel.com>
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v7] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
Message-ID: <202606261257.rnknH3QK-lkp@intel.com>
References: <20260626032012.1049667-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626032012.1049667-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EED8440003
X-Rspam-User: 
X-Stat-Signature: buiba15o84a1998b8fw8sxc6m3c11fk5
X-HE-Tag: 1782449700-624060
X-HE-Meta: U2FsdGVkX1/zsyT8uskTk7mAT2B2PBCY/iPrXL1f/585Jv7/IDsE9UlhxS4GYMI/cwlqfNZwURahl0yiTgLvDNdf1jyUhgo1wSgm4DAo3UDNpHAfQB5V7q4+MURFKzaZQkE7CNGnc+RnIQQ7eibc1i8AuXi1ydB1LTcHprQscV1nxk+MbRGJFGAyJ/D9V8XcmPH3HALF9mlpCAyK+HER7itlLAM8YkrSKd276ET0XvA5/ERYLE4qEFJyHvq1v2hzTykV6Fd2SqSKpkiw8li4g5ZaGAOQBirqd8ZrBStlZB5+ChNLsCU9WqqESOMzhWEW/H0pOuqGAht8LAljKFHeLS1/4dFBMBwbBOSRAykTW9A+v9FeZ82+ul5tSntt7aDaScU9hoosy2WDfFSbKKhDGKsIbsZQJIbogNxmEiEkYtvHcL1ew6xHBVxO/qMszxmbB8dbZ3tcg0xK/ZopgwnzkKeHKQRfmoMx+67Tu2L8d45KAj5xIndRLpPoQ411yaRl9LVYXCWgOy3kI/+Gs74TKjLang/k8wxLJeVoeEF9dAr5mW5DyGcvaa6D3nGwx+DIbwv5yYADJFBHwiTkq/7XritJprwo0enSLMhHkyZgIT33520k/ogKZA9kMBQze2+u7KTrHcx1AaqPkLCVAQie8wXzm1/dtRZMIOqHnLp6ZU+ogC1HPK1eLwQeU5yDRnTNVwvU8d3XxMbcL2RfJVM5fZhkUM2auKGEYZhFDXDu2LJ3WmFpG+G9ubR2ILs09OAgR+2fAHV53mdwOnTS6LZwsoHA4BrWT5fmdBVg6kwGh5PE0y4UwmcrBoCj9a0JPOwgHqT0ENV7RImPQZq5cTXhQ8WNrTXey3Nwf97taNbMtB3BmPhXQL8X8cY5HJm3LovnYNj3z+cQAOgJO3zvUiFyzfZ3+TGQw8BxF9vrl34mBwilBDC1ZJJB2fSg3yUHdzMADJexwV356/lxpaRKKqt
 OLjuwiCy
 pTB71LS3SPR065EMGHrbvwPQ4f4T4YdcwbJgHrbbQ92BPybvPnatbHAxYfvFTwJ/NfvD6N//i0frdQk7Xlsq6QiGSmoseWjOZ1cS2KhT/A4Ng3pTarZ+tiuQd6KFPYdLLvRwVFmXisfmogReQ7HIAGeorX7vRT0d4E0Nt8jVfmk8WMG5VeiNkvtQE8DCIEeZw0oCwH/8PXsjZnTgncjF6LxyK5/5TaX9+Qg6xJDbktJNIfFN08I0eTbCHNFY7iyeYfwUm7+rbo3qLKH6aOFNRIrel9iMIMK9A3t5zVBFB9OuUT5pgdV1fLNjfadV1o08laJYmHjSBIrV6ycU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hui,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Hui-Zhu/mm-assert-exclusive-nid-zonenum-bits-at-the-page-folio-access-sites/20260626-112119
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260626032012.1049667-1-hui.zhu%40linux.dev
patch subject: [PATCH v7] mm: assert exclusive nid/zonenum bits at the page/folio access sites
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260626/202606261257.rnknH3QK-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260626/202606261257.rnknH3QK-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202606261257.rnknH3QK-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from arch/nios2/kernel/asm-offsets.c:10:
>> include/linux/mm.h:2: error: unterminated #ifndef
       2 | #ifndef _LINUX_MM_H
         | 
   make[3]: *** [scripts/Makefile.build:184: arch/nios2/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1390: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +2 include/linux/mm.h

^1da177e4c3f41 Linus Torvalds 2005-04-16 @2  #ifndef _LINUX_MM_H
^1da177e4c3f41 Linus Torvalds 2005-04-16  3  #define _LINUX_MM_H
^1da177e4c3f41 Linus Torvalds 2005-04-16  4  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

