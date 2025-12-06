Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DC2D12692
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 04:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237216B00BF; Fri,  5 Dec 2025 23:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8296B00C0; Fri,  5 Dec 2025 23:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD7A6B00C1; Fri,  5 Dec 2025 23:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B956B00BF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:46:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7294458CFF
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 04:46:46 +0000 (UTC)
X-FDA: 84187810812.06.58764BD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf04.hostedemail.com (Postfix) with ESMTP id D476240004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 04:46:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YcMdmBAR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764996404; a=rsa-sha256;
	cv=none;
	b=tIjOEXxgYqZXZ2rxY1aGRlD2pjfrKXOGyRN8bko8ZqjCkhwGQ7RLfN3pjbNgu3fQaK26Dt
	w2WM4BvQdJmo6arUtABy/unnqZjOgg33HniRbA+zrCElRd12z7hSZWvYWHBR7vmHYNgWAG
	HeirG18ygaf2Y42V3lr6P2TZO9kEkhY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YcMdmBAR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764996404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhP7S8qlErGHiwE2TF7DUYgSiMwArrAPCORjneejlhc=;
	b=GQPV6cdibtlilHbq6m0UXA++Yz8mdI2MCO56qEZM0hlon5YbhTiQ6wSILM7Pt1uvjZoERq
	nNo/G+FQTbkzc3rHZKAm5c7rYWBEC0pOrlIsgxN1DGKr0P10rgz/DNiRR17PxKdoNJflpk
	viUmLUHwkaGQiqEJniG0n7IKu6Ss2t0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764996404; x=1796532404;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0/OFQQ1evWTB8rK2UtfDgnk9iVMhRHz6Lo1vbaODj7M=;
  b=YcMdmBAR03pNvDs/zggsUnq/HC11FkslIdRVtweODTSjNRCu/nOpzC/l
   kqkXhVIp5aFCAobCvdGDoPmmA+80qZghJgo39IBPg+mzFKuXO2QVYsv9+
   OeAd4K47bOQsBoaMcm6WCRqJJhsF3AeRqdMqz95QXPzj5iff56uZiZO9Q
   vc7OydNUn5BV0ZKYbKbOAQdDPC5rsqyywUtI6UGo9hgNIH8OX98AoYPu0
   sO/9aDiDjfe521lXxB52+eSrZzoDuBH4XJnCUSNwA6f70iXeBRixGBaKo
   az1vndd72Ajf8U9BKE54SvEhoX35cKh1sKX0VPoanqK4V5ljYZXvgxvkR
   Q==;
X-CSE-ConnectionGUID: d9w7kp4XQeqHOQRqtu8Muw==
X-CSE-MsgGUID: d+bzizErTemXNymr1CD5PA==
X-IronPort-AV: E=McAfee;i="6800,10657,11633"; a="70647713"
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="70647713"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 20:46:42 -0800
X-CSE-ConnectionGUID: bLCFu+86SBSWq0DTMpHGIQ==
X-CSE-MsgGUID: xb3xY/zMRWCGLVwNVeCjNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,254,1758610800"; 
   d="scan'208";a="218817889"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 05 Dec 2025 20:46:38 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRkBo-00000000FrN-1VtG;
	Sat, 06 Dec 2025 04:46:36 +0000
Date: Sat, 6 Dec 2025 12:45:46 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kent.overstreet@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com,
	da.gomez@kernel.org, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if
 profiling was not enabled
Message-ID: <202512061204.aGmmZds2-lkp@intel.com>
References: <20251204220957.360838-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204220957.360838-1-surenb@google.com>
X-Stat-Signature: yrs4xqfiqnth76xihe11pqhrxqrr88ep
X-Rspam-User: 
X-Rspamd-Queue-Id: D476240004
X-Rspamd-Server: rspam01
X-HE-Tag: 1764996403-753534
X-HE-Meta: U2FsdGVkX1/l+bsu0v1DanNEG44YBdXQwFZHd85HDu5wDzAjgs7Y281nfo/jgZL0Xh3xX4hOFopWKUzexhav10M14kZaPbG2XIfvWFo3q2NcouPR7HrSrC9qvpzwPLsnfrQbqCGgNs9M0IwMMDba4+PPZS4DBa8EAMIDMDCquDTgPBiZqe+FhOfE5CbVHAdY4WTD2IsZhHqSkKY1if0JSx/QjwwxffunXiIk6Ru4LwmsoYEJJrPLcs6Kuwtn+wCfaSlYvRBtqFhhPeuB/Ndb5XDVCd/tWw+vPNilMszTP7rPwxQQVdSwSeNcXNJkxmM1WkeMpaHid+lWDH2Y6zUU4EodGp9B0+NWOft1Y7wE99mfvmbX0kBQmEVgn5oJId8TVuQ6v5QsyYDbTLzUs5eh4mrb4p1iLiPY6ZMheBcNqPH414QLCPrsJikKl1tTMO0QCkOJsHQtXC2ApOVu2cK4JsVrYE4P9JfchN+qopJfxHozB6XGpvkbHCISHmLNEzm37a2hLgxrBNlNsRjotvYkFnxcS0lzjR9cIYzMQwrbfw5IOgYw1WpU2c+4rcUSXE4WWLeWv7cYIo0xil1Seht9JKbgptBMkgRSBIeuh1G+LGbulTKHmUVMqqfg7NG47ugvk4Yl4tpn2cMs4O3e/wWRqfmEHOijZFJ4mTn/LKwDVzZv+v1ZDTcmBKVyl4cIStJB69j0+tA7YwIH2FXs48CnbPgadIkWfslj5qX2GWEKyQGCiw/emUXZOUFHkRlpcLbq9QILQzjjXUXgUCDzVtR8euHFwx+CDSzohdpMNCWFsMVxvGRU/hNNKwf2d/SktiaW5YckADP4MbTfxasuIDM22Zbqa4+oDoSxqZ1aZzpe53PEsW12E5cQiN565ifk3saDcA/ciT/JEpecNBViJguRC5V67gGGY9xJsN4wHoI5rpEiW9h/5kJdHG5dd2xYKzawe5NeXoQL0zY5FAXAHhx
 TI+h90bu
 adok2/qmc0edAtlVRTcr4Sjyko+qX+2ntG8Gn8bx2ebUsK3GejlLL6XUe96rSvqv+i5TruBkSPbx/nQgtJsfjnQKYKs4VpYfFmo0j/rI03FO6WJMB/D3FjCV9wLu7PBFkXQLxQWAiX8wdHNdXvg6NfC145kSiX7f2xiNTfNyFn0/LH7cRo6oFcDI9pNZPDbTG4DMeDITvFWXNZSSPNplXakiBXsnjnDqL24eOEUmXcj0XCYokWjMW91UaKL2v/xz0Y3e+ypEI1R17xHo3MK0lrVHdq5sRIy+uW1NjbTVzdmnzqZkIcxqCwPyO4fXmv06wcst/h9BI2ouctURE2GCIxJyq8zM4bT+AOzy0dht1Q0CY1j2ZLZUKotHk/5w55ARtx6Afo8PmNGLa7to=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 3f43be96f919cc611dcb2a4e38dd464831f4513e]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/alloc_tag-skip-rcu-barrier-on-module-unload-if-profiling-was-not-enabled/20251205-061310
base:   3f43be96f919cc611dcb2a4e38dd464831f4513e
patch link:    https://lore.kernel.org/r/20251204220957.360838-1-surenb%40google.com
patch subject: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if profiling was not enabled
config: riscv-randconfig-001-20251206 (https://download.01.org/0day-ci/archive/20251206/202512061204.aGmmZds2-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 14bf95b06a18b9b59c89601cbc0e5a6f2176b118)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251206/202512061204.aGmmZds2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512061204.aGmmZds2-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/codetag.c:37:13: warning: unused variable 'flush_rcu_on_module_unload' [-Wunused-variable]
      37 | static bool flush_rcu_on_module_unload;
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +/flush_rcu_on_module_unload +37 lib/codetag.c

    34	
    35	static DEFINE_MUTEX(codetag_lock);
    36	static LIST_HEAD(codetag_types);
  > 37	static bool flush_rcu_on_module_unload;
    38	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

