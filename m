Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9C1EE6B4E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 05:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627ED6B0089; Sat,  7 Feb 2026 00:04:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609576B0092; Sat,  7 Feb 2026 00:04:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5075A6B0093; Sat,  7 Feb 2026 00:04:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4826B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 00:04:40 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E662C16031D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 05:04:39 +0000 (UTC)
X-FDA: 84416470278.28.B691F6D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1EE46140004
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 05:04:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dk94dV6P;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770440678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CPBKR70Hzin0/XJrtEAyvIZnVJ6P+yNy/gC9Pv4y/4=;
	b=SQnTH0E+owiufNXTOEHyEbSsoyCUv33YGotWv8hbeoKalaNdPbLQ8fTeVKYsDwdPtmdRpQ
	XRCsIgnvVWBQxXK3OmpSef5rAjd4xp8fmavkPgJ1QEdxILgzuInQahz5Yd9p+lnYPEFEZc
	Y+4PLH/1W+1TV+Ulv3TafIhTvLayJls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Dk94dV6P;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770440678; a=rsa-sha256;
	cv=none;
	b=qK+sD/+HUGFVa0BXqFWQlmu3yVShjgp3xC0074ghsO68yVjXf2QSPDHliZdoY0pTqVxKT5
	nOO+JOxlGxP6Xdegia/0teXxJdcPPkKeybVbtrcZrB6bD5jOnhFe+PprLvFw5ZaUcjnzdT
	mNNRQ7c9nJ1aLAZKGcsuVO0gfXwATxk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770440678; x=1801976678;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ngYaAqvtxnSUbIiuZTs7bVh1k+OObb19G2nulu3ITjQ=;
  b=Dk94dV6P7S0Zh1m6KbYhrZayugdvd2xuonHtn8To7jN4KeTNJEERouL7
   bSF8LhBnO7VeaMDUDawaZUJyCAceb3bfvnmvShNub2deGIX684GRThDXB
   6NEz+vdNRkcH0AVcpU8E2Vtg6gZryhuznC/+pfIYfTJ9fw1OOC+0SiNHq
   58GHmaA8g9zcAc1qlKLiBWz4KMGZIyRn67335X3X1SWPNdGFphKMwyod8
   wU6I01OVbgQQPbLsM1UJdd0y65/AV0ztwwThdinW7aIvzSD0figZOABEi
   HX+Yn/frpqqNoF+u+nm9lHSi2LgtAqc/secWQWe81kI/kUx0MTFyrS2p7
   w==;
X-CSE-ConnectionGUID: oQMGynxvTTWESeJq7ZDZNA==
X-CSE-MsgGUID: DEMsHxGeRBW4E3FbxRPlLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11693"; a="71547753"
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="71547753"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 21:04:36 -0800
X-CSE-ConnectionGUID: AQ6xvpxDQgOxgrsduql4fA==
X-CSE-MsgGUID: F95+kT66TyiVclkjb3H2oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,277,1763452800"; 
   d="scan'208";a="215567363"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 06 Feb 2026 21:04:30 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1voaUd-00000000lOq-1wWT;
	Sat, 07 Feb 2026 05:04:27 +0000
Date: Sat, 7 Feb 2026 13:04:03 +0800
From: kernel test robot <lkp@intel.com>
To: Andreas Hindborg <a.hindborg@kernel.org>,
	Tamir Duberstein <tamird@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Hindborg <a.hindborg@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: Re: [PATCH v2 11/11] rust: xarray: add preload API
Message-ID: <202602071349.6yvINDvm-lkp@intel.com>
References: <20260206-xarray-entry-send-v2-11-91c41673fd30@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206-xarray-entry-send-v2-11-91c41673fd30@kernel.org>
X-Rspamd-Server: rspam11
X-Stat-Signature: rsgtujiu3y1i3mjzpoggaogicxyphuuk
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EE46140004
X-HE-Tag: 1770440676-579672
X-HE-Meta: U2FsdGVkX1/aiiY8cNflJA+vWd4bH1sbFTBWRiXPQUxSGHKxozWejtRVc2bFjXEVmhWWFmVvQktWg6Zy/4WvNwN555dVCNiXXeU9FpNBEjEwBotF03LXQFLO+b690zaurmv1U9Oll/BO2gjRVF9z/VUSlO52LwybZgkAOHGoE8JElV+Lskyo1Ik1DsX9MadYnBpNtw9LRr6KC0LH8bvQL4pE6X8H9AbPFCL8kD9oI/SCEkCCTjr+9twEZcmxLDsPyyzAVw7BIXCamfXqOU0xVz8DMgl0imkhuOL/IqGOVW5rWDgv6da/Yw9AYg+iWFe3h4yaphB2J1+V6cUyfssrqjGSpHw4Jg2JuREGStwJvLxMEoC25QpopKcs3+0LWfuEesqhmjVTgl0nrGtku90PtJMtvrZP4WyF5QhpApamyq/CYnZwLMuxftclBPXJkesxg610qfc2TDNksmxDsynNvN4FMvp7uDrYpS7H7XAHu1RwyZH0OqTFe6Bxuh/SSVq20rTNXcHaCcYjV8vxr3D1Y4Z+OlBPX4QHsi23UFjoKPEJ4SsrAqmtca/u2OxfLZurbU6wLzJRqsmrMu728UdBonec8kt1Uc/YJBaLPbgghWXlEPDkODJddDxOROpOqdPNGRasH+EgYXX7L7KWZQbHBwUPK5rOXo2TE2rwS4hJ4VLi4i20LDjWgyXm+EzrPhJkuyLvAX7AZkXpM/erYebLUv/4rZizycW03xMrRFm9RI3PzrP/cnhXsT4yosd0gV0aFB2Akk0wh/GIqARmPwL/eGoL6UJDj8IvhLuHUlgVGF/J1v94U8tO+1wLSjlKOYtAOayw8M0K+g9fCl+fC8n/pWs+XmdznQ4kXO+yGlnx63gvdoRCGORSXxgixIbhMeuvci8AQZiubD8/H7OX+p2ZTBCNSz/Tepz/kDbR6aC4qFXKrb6r3ep1T3OmM9spst6hubSD8UUcIyM897VpOTc
 fptnL7p0
 OUCPIbLbc31IEOajd8OPngWeVyVLNz5WhoDXVL2zcVvGQ3y7jT6QOw9yTMNHkXvqao5zarbpFMO+1nSRUUONAhd7Pg77jvm+DSDNckOaKrDuy4N3s6WYT8Oq1e8JQSopwEG+FYcI/v9704uEE84NUE8Gt/aFxn/BVTRfUqKy+OxEghWPuiO3zzfCwj3mhfPGF1Q57YaLy7rlr2yy/fUWwlRzwOKyiYdWJ/f7YyyLCqW/Y3of4wTZrQVO7cwXXtfsbErbwbs21N3QjWtrx+3MZCf9n2Xve7caVwZe2GYV2YRKvARSWCo14M2pXyOwgNgRtc/Plqj3jeP6i2iELzsXy2oB/kG2fE3dFpSt1Hngon2vY3K4x+kqp+SDNRr/g9xU/ce8Icbgk86UoWeYJwx+oQGiMog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andreas,

kernel test robot noticed the following build errors:

[auto build test ERROR on 18f7fcd5e69a04df57b563360b88be72471d6b62]

url:    https://github.com/intel-lab-lkp/linux/commits/Andreas-Hindborg/rust-xarray-minor-formatting-fixes/20260207-051500
base:   18f7fcd5e69a04df57b563360b88be72471d6b62
patch link:    https://lore.kernel.org/r/20260206-xarray-entry-send-v2-11-91c41673fd30%40kernel.org
patch subject: [PATCH v2 11/11] rust: xarray: add preload API
config: arm64-randconfig-001-20260207 (https://download.01.org/0day-ci/archive/20260207/202602071349.6yvINDvm-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260207/202602071349.6yvINDvm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602071349.6yvINDvm-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0432]: unresolved import `kernel::mm::sheaf`
   --> rust/kernel/xarray.rs:33:9
   |
   33 |     mm::sheaf::{
   |         ^^^^^ could not find `sheaf` in `mm`
   |
   note: found an item that was configured out
   --> rust/kernel/mm.rs:22:9
   |
   22 | pub mod sheaf;
   |         ^^^^^
   note: the item is gated here
   --> rust/kernel/mm.rs:21:1
   |
   21 | #[cfg(not(any(CONFIG_SLUB_TINY, CONFIG_SLUB_DEBUG)))]
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--
>> error[E0433]: failed to resolve: could not find `sheaf` in `mm`
   --> rust/kernel/xarray.rs:75:18
   |
   75 | impl kernel::mm::sheaf::KMemCacheInit<XArrayNode> for XArrayNode {
   |                  ^^^^^ could not find `sheaf` in `mm`
   |
   note: found an item that was configured out
   --> rust/kernel/mm.rs:22:9
   |
   22 | pub mod sheaf;
   |         ^^^^^
   note: the item is gated here
   --> rust/kernel/mm.rs:21:1
   |
   21 | #[cfg(not(any(CONFIG_SLUB_TINY, CONFIG_SLUB_DEBUG)))]
   | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

