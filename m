Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32AA6D49C92
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 10:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C9C6B0005; Fri, 30 Jan 2026 05:29:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574096B0089; Fri, 30 Jan 2026 05:29:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480156B008A; Fri, 30 Jan 2026 05:29:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 35B236B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 05:29:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B890BD47DE
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:29:13 +0000 (UTC)
X-FDA: 84388257786.30.FED1A27
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf03.hostedemail.com (Postfix) with ESMTP id C0C7220010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:29:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JN0IcRLF;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769768951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKF8X3pE882cWr/4cWrmRouYmpeno5NPBDdmWMasVKE=;
	b=LdCtsACFCBdtaN00GW5TfjpIDZfvAlCm0yXgUf1kr0PqShQ98GarmPgrbqMlyVsDx8Zx9K
	sgK0iJD1aZunjVOPNGj7Wd9yxJyQxLFJG6BYYRXHfAnn2h1Y/SWKuAipqQNpKR86lTWrZH
	INSWzZmJiSVQ6fglXjIvoRfFTTFJCFc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JN0IcRLF;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769768951; a=rsa-sha256;
	cv=none;
	b=Ip3ftTqzxkqUL8rT/V5D4vJyjdWA8f55g4i42mu7I0TwukXt09Ravpitn0Ad27DFfLT3mC
	YTa5Wco303+2Dl2GCLjlid1a2eYfTrGLo3kXspncyMOvp1LGuM/HdRaHbUe/hlW7yQ5xaH
	RMPIq8J+inpEjRs6DW2Fq0X4UKXAX6A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769768951; x=1801304951;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FHGMwOuDMyqUbdmwF7i7VTLEoZIkyO/zzJwWJ2VhDBI=;
  b=JN0IcRLFbl3WAOSuHhd+3pspxLo2JDnZXmOAsuzYIqMHfE3PdJCvyHxB
   7qVGWRWl9RraSrBfRJ6F5ZiQfoSPUkABSH5Pvq/eYC4RBKwMJ0Gb47gpw
   1bRCJkFFLPEQxMrCr1E0n9V9VXUJBZTMcM9ux43B5L4B59tQIu6yc4YbC
   hCN0lf/tIRTf+DTH9Q6f57FJSW53Jpy+cehHdpl1lDpRmvfNlToSYoPpP
   gSmhRKQ1R7bTUO9MAerPLFJEDQhiTo6plmH6EFqLQ+hCZC8AqatsHsPDc
   n34XUXUwOn9aCNfE5i1j5XWghjr23m/4680/4mrgCp2ebMX+Ij5w+Ozvj
   Q==;
X-CSE-ConnectionGUID: pokTKTAFQKeAshoburRwww==
X-CSE-MsgGUID: 30sqU1I+Ta61JkGhz9CVgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="70996991"
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="70996991"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 02:29:09 -0800
X-CSE-ConnectionGUID: map7TzjeSMuclFBRztNn6Q==
X-CSE-MsgGUID: vo+SFuKvQPyHGzrU5yiCCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,262,1763452800"; 
   d="scan'208";a="208418862"
Received: from igk-lkp-server01.igk.intel.com (HELO afc5bfd7f602) ([10.211.93.152])
  by fmviesa007.fm.intel.com with ESMTP; 30 Jan 2026 02:29:05 -0800
Received: from kbuild by afc5bfd7f602 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vllkN-000000002Tv-1g7X;
	Fri, 30 Jan 2026 10:29:03 +0000
Date: Fri, 30 Jan 2026 11:28:47 +0100
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
Subject: Re: [PATCH v8 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <202601301107.1CQsWeRT-lkp@intel.com>
References: <20260130005739.3163049-2-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130005739.3163049-2-jasonmiu@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C0C7220010
X-Stat-Signature: kjgfr5518urf1cmfqfaj9t9ygewmam8i
X-Rspam-User: 
X-HE-Tag: 1769768950-111230
X-HE-Meta: U2FsdGVkX1/pZLX7fTjHQC1MmWdwIX+1BA2VMThTvFpEA6XMJBxp2m6e+n4gaFQrrAHCBTmFsjgvxadQjMD9rpFEjhSzdorVnw7gZpa0yyIN/zOwgACzXDEYUJTO8LcVcvuTt/afgq5uWTNaaqJLFDCDE6QPQvecca4F01J3JvuH+oWswiHki+4SQnfOECPNgrlCqpj3zPMieactAp6E7Q15BsZtLAbk+XZE1Cgb/y9RhdSQEMm7R222/wWzXIs/XgXaHkdUJtHZTIoTM4ijzNvRV2GIX32AgtJODtCkYXYUJOx305/gXvxwdsREXWnYerwtqnIuQJwD6eCAI+GpuHisQb8xCt2XqsnkZM79UNIrPijy76WemcofEvcoFH0XdlQ1+9ntA9HB5/3lM6xex6fBR3vKoUs3zeBSKcRy381GZQgC5DrVTSee7iDjVGRhk9TpipJBsTd7uNrRpwCjC0gabVi+W9a/kr3NCkQdTP7emeVUPpfr1k0NICEkz/tNj8t/QbpdpjQJdOz8IRTDekYXDB7ksmlZ7JjI7w/caFObK/RhAgfLe3NM2sDLDfUv1j3Ohp6CrsBA2Vb5F1/brW6SKT9j0FRm543pjfAHLuuCfsH6pMu0zvXaHTNKHwL2Rw9eI3Fs7TFmn1DAnAKWsSUbHgoF52gMiVreHRKtQEMAK/nJCPuUf+Pg68NwHfX1I/tE8tp9cmveRKlgbD8T4MinxyTOGflcmKVqPT8JBr1LB1V1p7fUu/1Su6cHSTq3jDoZ8UiQswMS5m4v7K/d0YM2QYJykzDRzWso0gzO3K4GuYMDgc5K6RmdHXKImwVwgCeiig8VGHwvxSdKfncNc/dNhP08O/JwyNQRcnzTtuCRB6StDMiv8rtFEb96DCqhj0Fjm3tlAONqdjHrLuboJhdVGpIFe3nDIFPEVGrtNsWPEjGxHWFhBapu54cWalZIfTahU9FfNypuxPyBpYJ
 XnSc8u9X
 miNV1cb1OV4nX1hWE1qNBo2Hk+aaD0Ke/Sx1RHUOHVlK/2v3BMDkJ2LUe6pCrx2o+O1RAFAg9sLhPLfqOlm4ayuJOp4JvaZKylELx+lqFmOzd+o6fCZSGfex3Dyn/pgcOOsoaIPe/aIJJ/ubEwmoV/2/tc7AbtnLQhq2ahTYOHdf7sg7qkD6Zzsjnun+GcH+KfJnrTbVFS8fINC3A8sgjgBLfu9bBATwB60RpuQP8oiMJDTkY1IiyX3m7YMo95NQG3D6Uc4lV9BSGk3dHwQUgdBAS785mU01dX5WNtsDprX0JD1HNpBi4uf0L5ARi+G/94IPldefTqlHBFEligtBjtpxjVlPivRTZyYiE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

kernel test robot noticed the following build errors:

[auto build test ERROR on 33a647c659ffa5bdb94abc345c8c86768ff96215]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Miu/kho-Adopt-radix-tree-for-preserved-memory-tracking/20260130-090027
base:   33a647c659ffa5bdb94abc345c8c86768ff96215
patch link:    https://lore.kernel.org/r/20260130005739.3163049-2-jasonmiu%40google.com
patch subject: [PATCH v8 1/2] kho: Adopt radix tree for preserved memory tracking
reproduce: (https://download.01.org/0day-ci/archive/20260130/202601301107.1CQsWeRT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601301107.1CQsWeRT-lkp@intel.com/

All errors (new ones prefixed by >>):

   WARNING: No kernel-doc for file ./include/linux/kho/abi/kexec_handover.h
   ERROR: Cannot find file ./include/linux/kho/abi/memblock.h
   WARNING: No kernel-doc for file ./include/linux/kho/abi/memblock.h
   ERROR: Cannot find file ./include/linux/kho/abi/kexec_handover.h
   WARNING: No kernel-doc for file ./include/linux/kho/abi/kexec_handover.h
>> ERROR: Cannot find file ./include/linux/kho_radix_tree.h
   WARNING: No kernel-doc for file ./include/linux/kho_radix_tree.h
   ERROR: Cannot find file ./include/linux/kref.h
   WARNING: No kernel-doc for file ./include/linux/kref.h
   ERROR: Cannot find file ./include/linux/rslib.h
   ERROR: Cannot find file ./include/linux/rslib.h

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

