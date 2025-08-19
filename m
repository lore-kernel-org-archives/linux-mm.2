Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E31DCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 344B98E0047; Tue, 19 Aug 2025 14:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C5A8E002A; Tue, 19 Aug 2025 14:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2596A8E0047; Tue, 19 Aug 2025 14:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1486F8E002A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:55:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66F6A1A01D1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:55:14 +0000 (UTC)
X-FDA: 83794409748.23.2C7DF06
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf29.hostedemail.com (Postfix) with ESMTP id 85974120003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:55:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iAKy9ljF;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755629712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SydW5uDyMxt+461cvb6vXKm2D0LcZRub0lHp9a7wk0=;
	b=D0AX0A1c2hKqFHL5hAKg3iSAlHB2JQpyadXheUEOB716AZ5xMUPNrdfjTwAOWHbXaFJdNI
	vwmm/YUiFnyHEg7uR4nZ6UBIsk0qXchMBwTc9P6yMncSj4KE2HIR61qvPl4DKDy/Z1+FHn
	4EltYjzM1Ky2dtJLyu4LiQUATqegYq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755629712; a=rsa-sha256;
	cv=none;
	b=66HSRuPIBnhnwHrXFLIUTDNkpLxI4cFCg+EscUeO6cEqiB9PiBYB/Gco0M4nCy7+7l6/xG
	4Ajbot21yHzbsl9JTh5vjI7OqKYPmWvFy0AKByQIYRiK9Kr25qVBbHw3s+hW/+W+bWWkbK
	o6LPLWO3pPNtorPLjiAg8kM/9b9UuVc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iAKy9ljF;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755629711; x=1787165711;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N0364bt9jMRC3C6+N0XTj3sLdDMekTNts+hQ0L3+ZhA=;
  b=iAKy9ljFzzCfVfJndE+50DJI/vdEfb47rHBLTNV4gD3Zp+InTD3Nsney
   jxF4ziA4Vuk78xLgT9Ly8F8lmrbVIpiyrWU5QZDqBifZUwH15qXuyC3Hr
   StBUsdLKd1PzwmCmQxl+TgN8vXWxIduCKrI2q07YwhGNStTaLn8r5Dkqr
   cfLlWzCYucaHgn/IkmIhwKqX8K4W1oZYoIWYdhLfgqIOHeTnKJXTW36GI
   jglVtxTRu505LAv60a6C+QzvSFByQntnne7w7wZ6jrdwg3ZqK3+Ln4oMg
   CQfABSdnQ/MQjXrnbpc/reRVS5oFhtTkHxpzohERg280WxYgZIPG7mrlF
   A==;
X-CSE-ConnectionGUID: 3sQETgCeRHqmJxghD6gIRw==
X-CSE-MsgGUID: Q253nptvTRyi9qZ8KBvS1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="83313115"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="83313115"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:55:10 -0700
X-CSE-ConnectionGUID: 0/ig0LXNStKG9JH+moRfMg==
X-CSE-MsgGUID: fmte1CfuQNaazIakoZsu7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="198785908"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 19 Aug 2025 11:55:04 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoRU5-000HIT-06;
	Tue, 19 Aug 2025 18:55:01 +0000
Date: Wed, 20 Aug 2025 02:54:38 +0800
From: kernel test robot <lkp@intel.com>
To: Pingfan Liu <piliu@redhat.com>, linux-arm-kernel@lists.infradead.org
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, Pingfan Liu <piliu@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jeremy Linton <jeremy.linton@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Simon Horman <horms@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Philipp Rudo <prudo@redhat.com>, Viktor Malik <vmalik@redhat.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>, Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	kexec@lists.infradead.org, bpf@vger.kernel.org,
	systemd-devel@lists.freedesktop.org
Subject: Re: [PATCHv5 10/12] arm64/kexec: Add PE image format support
Message-ID: <202508200238.hckz21nw-lkp@intel.com>
References: <20250819012428.6217-11-piliu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819012428.6217-11-piliu@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 85974120003
X-Stat-Signature: 1gia4tpqzxo447tg1r43ybcrti9uipcr
X-Rspam-User: 
X-HE-Tag: 1755629711-631704
X-HE-Meta: U2FsdGVkX19mQQrzQELaj/WfXA7GMrRyQpTV7cv0KKKJoqythYKm8lYmIOaT60g3nkIZ/WnbUnCKlpojzpv5194LGllN+asbJ0+unI2R/tXg+QjwlrkRkAlrekOS1JpXS2pLVqI9sz98DWf8UaDXV1aSmL4oKqRjrwKP8QWid378pW1KPuaF45LnTwQK4MvSJjvcs2lkoesv+wlcuXz8/bNsard6CuKJtlctnBFaPEw6Lc8ay5UdOUQ4gFqkVvhpE8xWaZe1gTUbUgarUNCIxaA2xTeJ6AQJFC8P7Bkw5xYyw7kYmlqU5OWdYSSCBDwJG+MByppOrg9VbCN4YBywmVXviMsiml1nHf0RA82hAl8QYhV4ELdiSAzIoeLmMKIOcRXXlE9MQpdwAcQR65ksw9Qnuh/YeehYIKvld4M3Do6o5wlyOaR/PFNXtHtx9CMgZcWEPqYDWNlNrMDyZGiWdZjaYm7jiT1c8p1uBYVVB3FecCfWpfL0WIT11WilSrN883TTm6ybnGQJmbihAvCo7LlcngvxPujOHxjvmlBI+FegPMcelXFrtRhS4tu85idAFUDzg7xUN/ExoOpYI6D8dPDOHkE6Udhc8XweCT7abesNKV6pBxwh9lYQ2lT0+BanLGvqwX5GscrxF9NIe2MfzXiOYFoJlLEoszKC7p7Ez0cOCVuu31KdOIrLJzQdBJg049aBNii/Uo7pQ5xDlKZLDN/qDeRzIDfk481EdwKYo2HxQUUkILks9zmNLtUpE5pNm7iEIbiwBd3VjwUr+BrG5rHRwxtlHgc98+LUPqiPqZeJ7x6gLtJqK4xGCp8f7jCP+80PIwncTHkN6OgzMQsiWEfEyLRKcuQXUcYncuYfL/fkT1tEYV5ywiS2aJ7s8Df+29OtXhWvg9i9u3PrrvRC2KCqYKzhx/gFnlny5NFjCZ/nZxeIFyRrHQUJUOFiq1zATNMC3G2P4Wd5/KjUj+a
 ggYBMBQy
 3Vmqv7t7mgBlAVkKLaxrsoyK1ly1rVjw55J8sGYLBHMXHQYoo4e/sbI6WolToyxm2mJsV2wZYIoxkOWvdMfO2F5QKuPaoRTRw97RH/idPO0SMCKEFXzX8CaIKzl90JgIJymqysQmkHxV626FAQ5L/vLTPRKnmjwxbjIqV+v1bzJHPtL4UjEXp98v4nrkCtxQ58sW/F7gkWqTryd9S0M3/TiipCs6nJs+tx7u/aUSMRPIQmbcHmfRPRBOA/R7DHqhv19hq0yyNRTZ8fId6nsPZDSVqAvU0W0N9qXZLOMYElmW0AYPvELZpjGn6yESUIEdD/0BLSX5pyrCCtrPkxeAqPtHn/X58W8iUMmMb0Q2MxRtLlwbK3qK/tZZMqlQFCYJbPUTCktcgu6BCVgl4tJuxKAWI+f58XnkgNyJ6CQjyboQBqGk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pingfan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9]

url:    https://github.com/intel-lab-lkp/linux/commits/Pingfan-Liu/kexec_file-Make-kexec_image_load_default-global-visible/20250819-093420
base:   c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9
patch link:    https://lore.kernel.org/r/20250819012428.6217-11-piliu%40redhat.com
patch subject: [PATCHv5 10/12] arm64/kexec: Add PE image format support
config: arm64-kismet-CONFIG_KEXEC_PE_IMAGE-CONFIG_ARCH_SELECTS_KEXEC_FILE-0-0 (https://download.01.org/0day-ci/archive/20250820/202508200238.hckz21nw-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250820/202508200238.hckz21nw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508200238.hckz21nw-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for KEXEC_PE_IMAGE when selected by ARCH_SELECTS_KEXEC_FILE
   WARNING: unmet direct dependencies detected for KEXEC_PE_IMAGE
     Depends on [n]: KEXEC_FILE [=y] && DEBUG_INFO_BTF [=n] && BPF_SYSCALL [=y]
     Selected by [y]:
     - ARCH_SELECTS_KEXEC_FILE [=y] && KEXEC_FILE [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

