Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E611CFA47B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715906B008C; Fri, 21 Nov 2025 02:46:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6276B0092; Fri, 21 Nov 2025 02:46:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4CE6B0093; Fri, 21 Nov 2025 02:46:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 46D826B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:46:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE7FCB9B17
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:46:32 +0000 (UTC)
X-FDA: 84133831824.05.654EE27
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2AAC440013
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:46:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U0ZI2gxJ;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zxfbvScOZ8nnvuFfdlDMmbK1JnwfXlue3I9knI5n2z0=;
	b=OmPS7VUg7thVveIY0Olkc2H9j2AzcojJaqmKNpnWjy3YDZ6wpYoVaPnLhV/mINcyf1Krae
	IKBP1kIBD/UIq7avt9WzRGqripqNVVKw1QnRngk9kR6W/hzWX0zFeYx8mFO1Tf019YKRsR
	Md68pLCiMRVwmJk7L8l7ioNeFfP5ZNc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=U0ZI2gxJ;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763711190; a=rsa-sha256;
	cv=none;
	b=OQDIl4AffcUohTqtXXVOe6ldEU2Jcr9faUiMAFre8aRziTNZu7SzkneJAsfg7HdxzoukSv
	bEuE90SccdDaD6T5s7BDLRsor0Lst8OPw66tq8OSSXnO/CXTKu84YzGxsziUp5bEAS7o73
	AfGP9trO+WkgBUkJ2gpgRfrF7HTzT7w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763711190; x=1795247190;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=758owg6Uln4p10srjHlihJGGKUBXvqN48Kdezn62XI4=;
  b=U0ZI2gxJT1kpSjykSDaMi/LmH1bH7WWsZw+6OeJA3ENMcBkR2Ut3zOZL
   mhRuH7zIHzCS9aQCMsZNQf6NO/LL77m/cmPK2sZUQVVj2dAiTGHhqsnfo
   w4BAt5VFP/VAKt1rHHGtpRPzZIh6AfJ2SnDgiMipdCMPby+UMnLNSgfx8
   No8NlP6FxvceLraj5JVNfRcNV3iavimC/BK826LQ9nhy0T+lmqwUxZe9U
   B3jnWFyQh2TGIprUOCnkNPa3nFtrBHuQ67Yrstwij5RbLFxouJ2vDU0/c
   gy8GmWED9/h3qMzt/41AmRXbNJEY6uXCxEaeaM7LhXJlmsG/jsRcsixzT
   Q==;
X-CSE-ConnectionGUID: 8ePb9pbsRjmdM5OEjCeRfw==
X-CSE-MsgGUID: 0CP2yMy6SZa1yrNRpyMMXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="65732882"
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="65732882"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 23:46:28 -0800
X-CSE-ConnectionGUID: 1yy6WW1mTWG4UU4LHkbYIg==
X-CSE-MsgGUID: ECscD4sSTZm3PmhQiVjtig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,215,1758610800"; 
   d="scan'208";a="190837512"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 20 Nov 2025 23:46:27 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vMLqZ-00055L-1m;
	Fri, 21 Nov 2025 07:46:23 +0000
Date: Fri, 21 Nov 2025 15:45:36 +0800
From: kernel test robot <lkp@intel.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Gary Guo <gary@garyguo.net>
Subject: error[E0609]: no field `mm` on type `bindings::task_struct`
Message-ID: <202511211538.sHKbv5Gl-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2AAC440013
X-Stat-Signature: cs75sj6qec5thbmrqwn5ye6uts3izadu
X-Rspam-User: 
X-HE-Tag: 1763711189-949480
X-HE-Meta: U2FsdGVkX19GQ2cPAybjUFOqSO1KA1p4vRpHADp5c99jXgouCO/cygO4fp9mPK1NlQmYTtjgVVp//9XNjCU4pjWFk/Jcf9rHeC8g7zrKsr+InFCivCjDYKQDl699kZB4YMMsC3bboo6d0L1a6n5OgP52Sbi8iv7wp9Jtspa8pQy0cdWtGTcdwAn7/MCI9rAVQT9jB4cbKHplqnTFl2bBz5eqpv6CCR0g+q3SQWjixJRRBDgwL+tBQ3A+FU0Zr+SazP71g3y4cOhINsCPoT6kbGOzJ/Vj7hZWdRh8VBQNexbgeE5zOWedSh3qEeFtAQmmJU6wvUWNW9FTrl3c298g6TZAIYoA1LnL33lczOqqcL8iNPvCuFyL6jpZnai9QyXqiOaU5Ju/Ac4JpnKFW1Wu3cdeJUYaEvQi/5ZMIhUJa9fiha5zyaBeJZk8d+ekYxU0a/KAerlDIwF6KqkMjSATBmeSFgrzrNaKJn6Hb0OMMJb2LXjFsZ1X3b/nC44MI/mntWTfLJt2qFAiAZB4aAiGWo94Fo/tFF/34Egc0lanH7iGC3CDIsb+JWBYjGqTpyt7KnN9Mi3hVHeBIwsY1eU2SvtppdczXgWRDobC+8DIfeC6LTcYJNriM7v9QNchnuGX6JeXg8tGy1R5wblp0KuHE11gh0rXxgFrMGOucYISryKnmjuviWapMjfEt5GJemZ+nyd0SaO6nPcU2PReZHQyZMX3q5O/I6AAPcpS9K2HgiPFtzS7CfOXqqw+3I8Trj388t8Wxr67Cqfjs1QUhQMIaRXKs5SO6LOzecxjfXH3F/9jk6GRt4WAANNTaxiRu1HCl3U7rZfwpiw8jwOCyRU39mWsO22rkzAiZk2z7aN8gzm2wVfCgXIVdEGrdpE5VbS7wXI2oYaoqV4Q0uvJONjpUcrVUAljP2pqmYQx1erDA1vxW0CMYHCMP1/XeuD0YXNIyiDS6A/qK5sr2BQUjZh
 g9hQxF1T
 H0pXEhqwW9Ps6FPoGF1M06ehdq7hH9WGht5oUHROv1e+h9tXE39tpOpef9JeY40OpKUpTfp+jX5MPxjw7Q/pB9pYntMZPW+zYE6kvWB9u7llH5+SrDJroB/SEKa7/Mu5o7KQUV+nBCG6VdHfzqHkIcHyUqlfZJFiIhOHmWwzLVUZIDAJeoQB/S7EvOJTW0dXU3TTQEl5BlXxK+oyTz9tUYC4yjOq0s4Ba0BBOYZk0Fz4wZ/DvSgDlM9bvV/frV6zj8Cz50ag+zP8uiPPIj29cYJ2X0UPF37Rv0cEe9F+Ta1e9dDICeazBM9MGUd4eoZlznFurV/zM6XbKWwPeOeFqY27EAr4wc4dlfESaK8tmuijqYAj2iuAuTk7ykpZnof0sIEDx2AI4zGU2c7zzLcmzHQSaZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   fd95357fd8c6778ac7dea6c57a19b8b182b6e91f
commit: 6acb75ad7b9e1548ae7f7532312295f74e48c973 task: rust: rework how current is accessed
date:   6 months ago
config: um-randconfig-001-20251121 (https://download.01.org/0day-ci/archive/20251121/202511211538.sHKbv5Gl-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9e9fe08b16ea2c4d9867fb4974edf2a3776d6ece)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251121/202511211538.sHKbv5Gl-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511211538.sHKbv5Gl-lkp@intel.com/

All errors (new ones prefixed by >>):

>> error[E0609]: no field `mm` on type `bindings::task_struct`
   --> rust/kernel/task.rs:286:44
   |
   286 |         let mm = unsafe { (*self.as_ptr()).mm };
   |                                            ^^ unknown field
   |
   = note: available field is: `_address`

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

