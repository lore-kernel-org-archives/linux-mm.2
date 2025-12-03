Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8741CD1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 07:31:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE9186B0005; Wed,  3 Dec 2025 02:31:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99B16B0007; Wed,  3 Dec 2025 02:31:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0496B0011; Wed,  3 Dec 2025 02:31:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B89F6B0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:31:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D5351404CA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:31:27 +0000 (UTC)
X-FDA: 84177339414.15.3C19B10
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf16.hostedemail.com (Postfix) with ESMTP id 12769180009
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:31:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJnFWa4v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764747085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cLiTXIy1EK09AFrARgD1ELJ1CUAENnUntSSvkMAdFoA=;
	b=wh0KtNsNXYBzHi2r4fMYGO7ZtnQzp2Om0rUCFRTU6gsZlq3uDHCmN0BQc7No0TNL7VE4eZ
	xY0uNxwIog7L402rSCX43uL8y5tavJS7sAmRKR+kgD9xplZHYNbV3rbrxjgL426jCfh+do
	qbC033rj7K6V5SwPqC6e54AsAz62RK8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NJnFWa4v;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764747085; a=rsa-sha256;
	cv=none;
	b=GmYyCQZyxZvoM5bE5Qt7fnwLSCVxFmrYm7kUTwBKDjQ5Jb6y7b+sA2VpSfMXv/tsXUuprw
	aQIjBwRwx6VF0BGiA5TT3GNfDVrB4pyR0N2Q2pg6555j7+hvX+pxqO9marxm7zKGPoX88K
	FC6xumQxHB22iyLxemv61zbmzY12wD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764747085; x=1796283085;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=G1g4kTeDoN/gzH0PTtN/ZSScTjIaNIu2g7J/DD0IXaY=;
  b=NJnFWa4vVUBPEseGk0UTx6FjUWycEWOEyrEihHei9dSe4kScG4UF8+G0
   lv2j8YRs1gFYsObx2Z9GAGHWcYed5msWi6TqB9nCTwVgnR9UjdH7EAihg
   svabqxnDAld0dWzLPVo89+SCo6BRA0vE5foTw2p4GwvIfVCSKQkM2jlcu
   wu5Fe0UPXJvZBzvZxLai072L/afCjcoA5k0SlfMzIZZPnKxOR45/aYqEw
   ytqR4Nh8P/6MCgZe9jGm8hwTmFLshuPOfp1q+TTwZROLEECbWhuQMtG1C
   DkXkAMW9io6fcs+gzy+cFa6kZoHEjO8b+cAaAJb50oaNgsKk7gH6NF+UT
   A==;
X-CSE-ConnectionGUID: M0BnhL3jTmOzkq8T9jPuEA==
X-CSE-MsgGUID: 9tN3G3QFQTyLM4hflgkqAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="77412477"
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="77412477"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 23:31:23 -0800
X-CSE-ConnectionGUID: Dn76+ZHVQ+GaRIClVt0zcA==
X-CSE-MsgGUID: ATwKRMtlTvaAWAynPf12WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,245,1758610800"; 
   d="scan'208";a="217933721"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 02 Dec 2025 23:31:22 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vQhKZ-00000000Ai1-1LjY;
	Wed, 03 Dec 2025 07:31:19 +0000
Date: Wed, 3 Dec 2025 15:30:40 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: error[E0560]: struct `bindings::file_operations` has no field named
 `mmap`
Message-ID: <202512031542.URVb8ITS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 12769180009
X-Rspamd-Server: rspam11
X-Stat-Signature: 7ayi9yzt5orxorrghu7bt8ffxqoe9cak
X-HE-Tag: 1764747084-809922
X-HE-Meta: U2FsdGVkX19CGLofeP8touzqy3C0dLPmqr0Gi983gjwgjc5A1eEw8x2MWdYRP7JfaDcq/P299+68MA61Px8rcACVfu6gFfYZvxvyAkP6cJsIJI74w9ojT+9i4mA5KLLlGVEj8kBiBJh+xFDUre56mWQJzS7MOHOpgFdsF8/hPbjKpX/o1d044yWKJTmyzNs6NBBgXSbZ6ijAvq3v2OUGsR8zLww1jR/gFJZhduNz2jqUGhnL9Umsg3tkm4iqSo82ci4SskydlIVp5/1qDogXliGA4Yg8z0GsSKzhB+nnrE5VaEGdSq5m1UneNQ9KUhrcMMPyup3s/EfKrDB0nzmQYaIYW9/p+6K19fJea4clukHhShAtOAUhoLl+Yw5tf061+nFCKEZabXM5aPSayhiz8BYBjUqA2JCgkGUI9YGks3ygwqHs7497NQXrea7VG9VNz9MAjS4hPfRwKgCm+6N81yVZs5DuzZvfp5h+uueObIaDzpiWFPOKXbChzROL4SdEU/TZ0A0RWTUsIdPAqn4gIWPPg22TwgZr/MhZCDx+VMbzfku8aW7S70PDaA/JVtXNbM/AKwkaRrYukG5bIqNjYZIoX3oUwGXZgYkP0O6NlWbB0llJkNLarxoO+MsVGL8v5qPWtAWlhohU55wSrUd7YpBUge4kwSSSCjmeb6KIdqppi154VqFEvlR/Uny5KWddDl9Ds5uj5Pp4EzC4QHVPFJ8cJ1kHQaGbugGsRP6V/kOPBM01XpjXzWeVrY2iG4+Q187TMa/hFIgRC22K7CKQTCR3sqQbBalR1Y3bj/aOEiMrF126B3sEhyCpGZCFFhICCGSZpojskuNZaQAuwxaVikL14qbIoJq0wXoZkiqru6yW+flF/bdL4vlxMFM9BiVOsx68x1Zi5Y+IbtQQ6U7Ko0XH/j9sVbpwxKo4X+RAX+u16qPZDrx6COMbGX+8X8wCBpqPo86MUWec095nq7n
 u9V3VZVr
 P24hsCqosQf7AIVaYyKU/6rt2c3w8lJWNadtspAMRff8jJdO6xX/srXW9WwFdm4XWKxEdu1O3gwJ0TnLxg5hzaGow8nHCO7s2jvu4JcqbksDCialJ4AyacsqstKBgLlE9kkvOgodDPlVrvHxCMFRcQ1yYWurGFInKwgPvOXIBsVnOPNkJjFBD08vpxumuXAlW7fyMs+q6UZtmPxy9XpSz73ndcgGhx1zEg2m/1usuaSkdV+yMQJopY+za9Kwe9jSHJmeNCwNPsgT12BB7rm3zcxay9BqDCntRpDWlubywfj6+WcuC9r9t/eCoJ1x0/w+AmLbmx0+pZEwxT+uOqMX/IpYQgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3f9f0252130e7dd60d41be0802bf58f6471c691d
commit: f8c78198816f04619da6eebfc5b67741bff56325 rust: miscdevice: add mmap support
date:   7 months ago
config: arm-randconfig-r121-20251201 (https://download.01.org/0day-ci/archive/20251203/202512031542.URVb8ITS-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project b3428bb966f1de8aa48375ffee0eba04ede133b7)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251203/202512031542.URVb8ITS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512031542.URVb8ITS-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0560]: struct `bindings::file_operations` has no field named `mmap`
   --> rust/kernel/miscdevice.rs:338:9
   |
   338 |         mmap: if T::HAS_MMAP { Some(Self::mmap) } else { None },
   |         ^^^^ `bindings::file_operations` does not have this field
   |
   = note: available fields are: `_address`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

