Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 841A1D43367
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 02:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B3D26B0005; Thu, 11 Dec 2025 21:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D8C6B0006; Thu, 11 Dec 2025 21:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 804A36B0007; Thu, 11 Dec 2025 21:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68A3A6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:55:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA9DCC03C1
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:55:29 +0000 (UTC)
X-FDA: 84209303178.07.4053E57
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E98A20004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:55:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Q/rv8s9t";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765508127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IHH7FISSfyu66uvyvWAbKeSkG4gSDQ0B0NkXAaJWnPk=;
	b=H/AlqAXclJ0YIV6TAVzpnNkRFHoUFACCAehfV8dXn2DzddVK+15s3sNC/TgJRitgwYfdPK
	AUXtvLeq9qqbvVZi7p7giIEeoyZL2/kDKfZG2/sOwhh9sR+wQL+HxL5CMzfjiHbUa2cUqI
	plTPeYMHtE2pCgLaLga/tsQNuC/p5js=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Q/rv8s9t";
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765508127; a=rsa-sha256;
	cv=none;
	b=57HVjMRZI4QtttPgEYWqrycVxdLL/vX0lQ9YYzytjL8QHVhOcjCGyIHQvjNULA/Od5aN+K
	Pjv51jTSDCYx7JPx87V9g4rfrqOl6xxEMl/3tiRjYsNmMnv9B2B32MDpmDSwpuHmX/MY8+
	bBJxZG8d9OJIVsT6dimkj/KWtHxV70M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765508127; x=1797044127;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t84hamvCTNn8P6GklBvJVrOeaVIe6R0pGBpn8MhDhdA=;
  b=Q/rv8s9tjAVcfs6kQflDmdlT72un2k7l3sKt7QEsNus6ENT3t9nQcQJY
   5cycgMovRsD/FIuq+OtwepdnZGAzaQkED6ScxFSmqhsGs7KsdQqDMjePk
   kpBhgJGdf/w0nlVqd+XsG2X1yHDzIV/Qjk5bcz6lyFh7Nu67LnSJ5oiGN
   eTRuaOwiLYiJFNmMjlsnL5wg68q0RguVkklAD/grRTK4uL16o6rhf+MZF
   6HHvCVL/cn99lEkYCsOxm4WknQZp1ZsrsVc187tTJ/r2VRwebRbVBwAcT
   NM4J2t/XEyeqlZmrvSFhRehRlFMW/LIwRCEJpXa30ZHr7LYEhgtOn00ED
   w==;
X-CSE-ConnectionGUID: rlu0jpHcThmk2bg455BFjA==
X-CSE-MsgGUID: cOoCIzuuTSWqtAcvxM3l2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67429723"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="67429723"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 18:55:20 -0800
X-CSE-ConnectionGUID: 6LZGlbssSyWqRzU6u0sSjQ==
X-CSE-MsgGUID: yv0vBOInTSuW28cqNqT7qw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO d335e3c6db51) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 11 Dec 2025 18:55:13 -0800
Received: from kbuild by d335e3c6db51 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vTtJG-000000005PB-3q4X;
	Fri, 12 Dec 2025 02:55:10 +0000
Date: Fri, 12 Dec 2025 10:55:04 +0800
From: kernel test robot <lkp@intel.com>
To: Chen Ridong <chenridong@huaweicloud.com>, akpm@linux-foundation.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	hannes@cmpxchg.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, lujialin4@huawei.com,
	chenridong@huaweicloud.com, zhongjinji@honor.com
Subject: Re: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen
 and non-lrugen
Message-ID: <202512121027.03z9qd08-lkp@intel.com>
References: <20251209012557.1949239-4-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209012557.1949239-4-chenridong@huaweicloud.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: c1qboopt4uuk1gejgzieaysa7t4cycjm
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E98A20004
X-HE-Tag: 1765508126-198817
X-HE-Meta: U2FsdGVkX18ofll1iWxSVrpf3elabovw9+MM3PEHb0b1wfFsEBwy9reHb0OG6Rj+pkVp+ojfJZKbmwqm6ioEQFlrRH/LPOdMOIblL272rvIxmWlC8ppC3XNPphgzvZ7e5MuyIf5E7Fu7ktfkOlWgKKGAT20jHQIGMbp+o9MWKS26ynE1gL6j+UkmwmGiOxHLrLt0NUg3EoDvVeZtpHw6qReJlp7ZRTYoK3sTSkCpfg3c3e3EI7v7Mlf0kR69r5ctknw/ZT67uEmcBHDUi/s5rQxJH6js7KUkgoTk7DJ8d1dpyvwfc0WSXFyNjwb82mIDX372+kCJ8ZVeMe5T05FFJoDL8vCx4cGgfe+7QPOjs506Xdavgx9QB3OY8Pt7le2dSXtL2ZvyGXbSH5mW2e3HEkQwCC8hH+E6jTWNR/xJogE20x/PiXe0YWzzMBVB2gCvfyusw8+OOS9YcnEDUwjBuUPtV67y2vzXJRao6OnahAaa+pRK8zsBNglZCH9tyDES3gvVeli4hZtLEGgJzvJqZEpVJfCju5BYdoZe5sYm12WKhvLmXyw/XQqrRTRv4D+Ed+SPMrKOvUJKsZng0yGmfjIOb0vBh7D8NntxmSl0Mpj6rfCKs5CxGMdhlfZhOYwwotix4NIDt3igomcSFFA/jYljAvTmtrAVHtCBit/x9e1XZNmxD9CtfTKa1yT7U8q2b16oGej3qf4MTXhDJRDeQjOClcKtxylTh7b4rR563ZjZHUrFvYcdkE0PpQtwu3TbQ84QMfSfzjV1aB1g5HbGBX8xMFM0A8fTwvBDra6jSxtOCQPiZGGSjtO2lvdjyn64PstvSlx0EzXzvvuqeLTR9GgI9rep9PooORdyGR/FcDqoEJv+tSRUvHAn/PVGmqntW99EquT0sU9WAh50kLGgAG29CMDLj3eN4WfqH9OJ3UwqyBDyEWkys2X2VIuw1PlVF9m7tIuVRYcdh9L66Xq
 iUp8glTn
 s3qczS3NKt4BclFlVIcpfHKVYcoopizzmwgbqMBsr9+9Tp+F2MXIySPBDPhCQkIDV6f9OLZE1wefwuBF/9qXNLp+elDd1khT/BP+0wSzhbE1zTg2TwG2CnuaL1mZHse6EGUpsJLFbRDp2UpFVcS8Gq0Crx/G8zVmtbTPc/3U0H+n+p3nAbx080rdYIJ66Hj3lPqiUGegbjtuYc95X+XtXeXyhCkBSGAu4pA272MdSTuM/o9FwbNF9yO7bMLJG8H+3LAYRp82yM7PFhG5ITwIrXWGPpLZsgB9i2g3Qss4LoNrdVRIupRdlnlyvWekVA9HNcwOpeJSebPDivxrb1eQujsLThBOTGxZHjR5qA7k32jsjgf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chen,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Chen-Ridong/mm-mglru-use-mem_cgroup_iter-for-global-reclaim/20251209-094913
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251209012557.1949239-4-chenridong%40huaweicloud.com
patch subject: [PATCH -next 3/5] mm/mglru: extend shrink_one for both lrugen and non-lrugen
config: x86_64-randconfig-004-20251212 (https://download.01.org/0day-ci/archive/20251212/202512121027.03z9qd08-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251212/202512121027.03z9qd08-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512121027.03z9qd08-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/vmscan.o: warning: objtool: shrink_one+0xeb2: sibling call from callable instruction with modified stack frame

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

