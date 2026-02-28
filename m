Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBF2FEE4E6
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 09:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A376B0089; Sat, 28 Feb 2026 04:32:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7577B6B008A; Sat, 28 Feb 2026 04:32:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660306B008C; Sat, 28 Feb 2026 04:32:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 532DD6B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:32:07 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E07BA1A07BA
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:32:06 +0000 (UTC)
X-FDA: 84493349052.15.5CC8D38
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB3C4100009
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 09:32:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gio4Io2U;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772271125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eb02KWI5v6xRYlVEKHGfhA0doNNDlkQw4RI1rzH60jI=;
	b=yF4pmoQUnfR+bmMd5OxQsoSa3ItVMXmC9IAccvYTUzjDtEYci5mYuLjmLX02D8L1+WQAGD
	w7jY1Iy28eeOyOUwnWa/ITm+orgGjvUtcUBSefnR9aWGWMQFwuPfxrktitYPb/LVkESWx8
	RwtjbxPLyBYoI8v3E1iBHhqBwEYMdaU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gio4Io2U;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772271125; a=rsa-sha256;
	cv=none;
	b=xhSh0hwVe5GVW4uitOmelbgmEoi5cQvVEe7tgaQB1F7/TgJik6amKU3BQunbvW875JBnCK
	UtbLknUdClX5d26xps+fghKTVSgIN2RqCYue8Z0dnRcwxL2SlKAfOauQTxcHjkE8tfBYZy
	KQfxb6cs7U/k/34FOFSmy7LLTTWn8Rg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772271123; x=1803807123;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rrx8y/C17jrzfE6kvyZzwZwuPU1bRbyLhVZrjF/dgcs=;
  b=gio4Io2Uw4cvhjxSGDgIQaub/eTKANM/B4nFo6YuDVC4dgkIk4olpBNH
   s2cU3PwR4JjLx3OZxLY7rPIlYMpxWQZgUGJH/R7Y2bzaUDmDU8/nJY6ky
   R1Ajj+q569+w6HMD4qmw6eqVHNCJvZzTc23zvR7IkEHWpwLEEAhjOywNQ
   xj/Wd+hF896lcgu4a2wCoeY4+84jSe/dtBsi5AitQqfUX+cVsSr71oqw5
   anVzcndyFyiJuN6ciLs/onEumPnFC3wiAh90KoYMnIDt88gVnGhf0bWlR
   DcCiCg+2m8RR1qxJvJ0B1nTsIamf37FnTf8MJH8IBMNWoOtK/8dXgEoTz
   w==;
X-CSE-ConnectionGUID: u16ZUOsSQ6aDJSsnRbcGAQ==
X-CSE-MsgGUID: W99R5+qzSpqzqtNj+58ceA==
X-IronPort-AV: E=McAfee;i="6800,10657,11714"; a="84053342"
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="84053342"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2026 01:32:01 -0800
X-CSE-ConnectionGUID: pykYmDP9SDaeLcRLYXMDlw==
X-CSE-MsgGUID: M64QioP1Qv+fcwnEXOpsQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,315,1763452800"; 
   d="scan'208";a="222113504"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 28 Feb 2026 01:31:55 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwGfw-00000000BQt-0KRK;
	Sat, 28 Feb 2026 09:31:52 +0000
Date: Sat, 28 Feb 2026 17:31:40 +0800
From: kernel test robot <lkp@intel.com>
To: Maxime Ripard <mripard@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Maxime Ripard <mripard@kernel.org>
Subject: Re: [PATCH v2 8/9] dma-buf: heaps: cma: Turn the heap into a module
Message-ID: <202602281751.KRAYsRVG-lkp@intel.com>
References: <20260227-dma-buf-heaps-as-modules-v2-8-454aee7e06cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-8-454aee7e06cc@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB3C4100009
X-Stat-Signature: xazkx59bcmrh48wm7mfxmmdzhspt6rkq
X-Rspam-User: 
X-HE-Tag: 1772271122-905961
X-HE-Meta: U2FsdGVkX1/2bi1sfPrr1BHCBp/pOhUfLSMkA7UuykZIgMoLvhWtGLamst2aXL7SMyonYF2n2b0wc4+Ju+i58SGDL28aRQKbRRY/cQ0MVM1ZMMNJCXgbx8hJmgk9WO5t7sLQDGoXhcmO2hI7PnqMwxNIVKujaKFCdzCEFswjjPgz2FPiBw3qvoE8gQ0w53BCZJNFfauZoeZR3KTV5pPIWpXLYg762NozbTG2v400j+9lnhcNBbT2GWGtzTLOnlv9pkpRIcBT+vWW0L5Xwv1py9BFJEHKytHFdVurljoRhIBjSbubntRFmkN2m/sJRkE2QR2z5L3ZqrBv7NWSaLMLWA+dUYYXW1aYlFAQSv551ybbV22df37JFpN71blafyKi9UDA9HRwJskadjeKghb1JLMRwcYRvoouQyzvspJq+vy9l3kZMcWiayM9bIcc095P3o8MMvafnX6ek1V/SCONJVWNZVKqat0K+RmKPwZxue8sQMx0Pq9456UfxIRJ78TpR1H9TnXGMIMdFL44tLGtaZ77GBPfrYewutJF+/IKTEhIxcCBhy+dwT+tGZ4fl03ly2rFuZwXbWrM3nd5MvjHLn6IQ7JdDCPG/JdMIROpful3TY5pjgTfolY8xcb1LYMwuW2SXYK/fnJX4v34lDJGv+Tz2z/SHizpfJZ+CE3PG0mycF0OWwvTBNvCh0HUuzGlX3c6gkyjyoe23g/fxIy85pF5gsVlbyh4PFFHe5t66VtVscQ0FcDzWRCiz/mNjeGZ3HxpjYrpkLGdP4Zha//enRYIzu8q/T+NexJCLevkz3Zu7j3kbE8/mAJMyXUhAbY4VQxg4EEWcvI7LZmxLHPCcyWgt95jrV7nOINewts6Chd7n67Xu93KkFmjsup+Rxtay44bjBx20cig94K58yVqoAzw+T7niRq6bO98H2eYfsAsFTNCk4+Frh1OaVWS4iuylFtwj0WzoHNv41mByAV
 IBxkOW7R
 sJ7hUcHnX+AnyOmwlEYvnUdVIzaHeEIGcsV7cXqW+i+hm4c+Yi/Kb88lxsOfEuyv26pEU/Xx3yWVtcPcCL4ThmDASMDHKULxLGOzeL5HhiOca9IC0rtAYuooGAlU4mDVSpQNZtm4fHs3cL7JndXGwraaofZqPdBzkRv9XsTTXP43RxS0TnzaR4Ie2nVNaDjD2LRK0rfTLZF+o4i8qZzdgn0SNBCFc93Vj06H5qYtXf0GfZ4IpgWsy1cZiSQ+BxB9VbGQjP71OvwsPDEaCqdNiFyYvM81XfFDz5ZHh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maxime,

kernel test robot noticed the following build errors:

[auto build test ERROR on 499a718536dc0e1c1d1b6211847207d58acd9916]

url:    https://github.com/intel-lab-lkp/linux/commits/Maxime-Ripard/dma-contiguous-Turn-heap-registration-logic-around/20260227-212606
base:   499a718536dc0e1c1d1b6211847207d58acd9916
patch link:    https://lore.kernel.org/r/20260227-dma-buf-heaps-as-modules-v2-8-454aee7e06cc%40kernel.org
patch subject: [PATCH v2 8/9] dma-buf: heaps: cma: Turn the heap into a module
config: x86_64-randconfig-002-20260227 (https://download.01.org/0day-ci/archive/20260228/202602281751.KRAYsRVG-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260228/202602281751.KRAYsRVG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602281751.KRAYsRVG-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "dma_contiguous_get_reserved_region" [drivers/dma-buf/heaps/cma_heap.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

