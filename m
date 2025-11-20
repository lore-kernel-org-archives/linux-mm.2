Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE26CF8558
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 08:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC4C6B0008; Thu, 20 Nov 2025 03:28:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3AD6B0012; Thu, 20 Nov 2025 03:28:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00DB6B002F; Thu, 20 Nov 2025 03:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3966B0008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 03:28:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FCB0C0772
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:28:49 +0000 (UTC)
X-FDA: 84130309578.15.3384F3E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id D2C3D1C0009
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:28:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MQwig85z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763627327; a=rsa-sha256;
	cv=none;
	b=bgHaHyn95enn+uHTGIUc+kqbCTNFPOHmDgi1KhYU6DdP64d71Y+J58TeDFxri7SXHVB1/y
	TtMWUL5HfDeIE87Xf7gzs6OeeDyhH7mZBIbHHKGS62+JCHSsuAiKxOmWdBETjyhiTFeq0T
	8PZ7m7jV659cGEFAwFDN5k+2xbVFRm0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MQwig85z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763627327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U0yoZgi3eauA4Q5ICZfxrJ9ZkdxOIbJK6pCrVlyy27w=;
	b=P0R8Lfwbncw452JqKnXu6vMxQK6g3au+79b4aYFtxoS1wAjHHIMRjdT8F3lmJihP7oBWMn
	qCFtC1H38bxsAOQ0lY6STGDfb/NmXzucSBeuE9jsnGyKxD1D0nQ+JPiiy+VMo1h5Mdq91B
	nVvcLJkqlISLapzVVZaX+foERPLIuNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763627327; x=1795163327;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=w9id92dSuK/H8vr+0x+ToNWSKyQXWE5M6/aywEWdNxY=;
  b=MQwig85z7E4Vi4nD7WKJbbCsRso2D5iyDKKgsQnSXk06l2i3D5OwPRgV
   k41xo100x0bMYb7os0dFFo4DnMoCaET5eZKrXr5ovhhcBkfbDBgJJcKhM
   ds5bo9+7CKWLZ+dWhqHSjtH+5y9wUcsungcL+YHnKeMMrmNv6UmEzTYt3
   kUh4MftzfsWN5Zop2ZRRVnX4ZVI+Bn2GZ1w87pYSjF8CSbBrF4LXw2xgO
   0jS2EZQLPVDz6XL6OmGp82RPfWF0N+bAWFOvN85sgOZI8f71NaoEIklol
   2zIZv+AJHWlgpT8avKfmRLkZkL6E9VHg6I/7fad/+KzIxr3aN3zDIvNes
   g==;
X-CSE-ConnectionGUID: JcfT37TlSrqaiCKEhgIxWg==
X-CSE-MsgGUID: pXExPRkrRuGvOdLwYAohBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65717597"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65717597"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 00:28:45 -0800
X-CSE-ConnectionGUID: KUAb6sGcRlWr9Fr1IPcnCw==
X-CSE-MsgGUID: 6Nrx0hePThiv1YTdpc733g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191098604"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 20 Nov 2025 00:28:44 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vM01x-0003mB-25;
	Thu, 20 Nov 2025 08:28:41 +0000
Date: Thu, 20 Nov 2025 16:28:21 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 169/175] huge_memory.c:undefined reference to
 `shmem_uncharge'
Message-ID: <202511201656.UKzZspkR-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: D2C3D1C0009
X-Rspamd-Server: rspam07
X-Stat-Signature: j7ba8eqgamdjh6tncbi1ud4ewba1d7n3
X-Rspam-User: 
X-HE-Tag: 1763627326-735301
X-HE-Meta: U2FsdGVkX18L+BJNV/P5foKJ10P2djJbHgLWZ5QLFK2jRpmhQPTy0jI7TdWCku7xbigvJqUfbgKFg/PfvcNCX3442qPT9/6ZvMrkRSBagZHdMl4BgLETVhsx290QquASTWeL90KlghPleeHKluGr0A8MaFCbmdYuz4tmtTRqwRLnhl9wvsuuWDxOAOf83tCop1X4XS6RgoZYxOThOhJoQuMU8lfwKgppdCx+JHCLD3HMP0fNzeKKl5vWwNlunzVTXMoxhfhwZ23xJK4UgBl+zBCWmLrlfcyTevqdOpB/vGC6KyATwhtnlYUXrEvPCSuYpKQ7K9jgBGKoBupzLSqoVo9QdIJEQzJgc8dwXDhAEEjPwaRlkN8l1vUvunflLCigBMj6sf6CUpXWbzat3YA6LfB03tclQUfpSUSaYVKH8Iot2oQVfEiaDftl/Ya4TCeCvy6nwD+jLc0tN3fd74PafkzkimdJfmzC+TePqwOAXd5hGbHCGuHV6SOVpuiGW8uSv5BihoFR0pvKNpHIdvY+y6yvJZ989Up0x9x4BSM0urFoesVXIZM028e5ATgXKosg5M8deq37FeQ1a9lIAZZqt2lf6d0XcAH9r5R8N20QPalNXNxChSqlY4bNujb1mw6s6b5B/8TUC6h71F2lVFIN4/Sd02rLHaC5eDsPEpFPsKyWCO0Ko28TUDYuXelom7nLkhP+mMZ6AbMolnSY9PUHVtsxNcOrULjAOI8hD5TiTeHUkFcdQFvhFvCGpYHsdUz7HcZSmMEDffgIoJDqVJfwo5VXU2ih7e3sJ717TH3kq+s774jiVRYCyFfunJUjMrs3hljerRGY8ABkYumu9C6b6+itox56/HPU6EQD6EOZQq0VCpC0eMjEySSj5Mq9XaZU6pQdyPzUxPKokouSf53IGGqwAtfgNAMMFkjO5KfA6aWsfxC99ErSsbLwKpxORRm1oNAT+vCLuFcWUetTvVw
 jhay+qEe
 +69PAR4sGiVgu4ds1jccUaHLHf1K/KsNYFicdCRv6yS6bjKt07YyI0KLfyArCx9RYEdvGIwhwfpY1HONXkqbYayQOQ80kK8xPFRwpZ/4GCSTnaWkTjsZNsq6IWgdepsq4FJhARPJZkchJjHUzRqYrvNnJZ3Dc4vVgKTplQaMzHCmwCLs/FS1M4dDl4gTS8SCwF1RPJ0Me+XsVdXCCDfPml03gGjbvLQaKSXlSUCc3Ddz4tolsArm1nAgbkHIPoXal/wlcHHzUzVWo5HEwqZpi4IMtE8g5HnNI/wkGyKgue9kV+zYy1Z/QuVeiJ8q9uaNAUFx/M6roecQXT2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   5a6a999252f63accde14d4851310f10ba962d3bd
commit: 9a655bd0773b41af6d8515502de102544f3ec4c1 [169/175] mm-huge_memoryc-introduce-folio_split_unmapped-v2
config: i386-buildonly-randconfig-005-20251119 (https://download.01.org/0day-ci/archive/20251120/202511201656.UKzZspkR-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511201656.UKzZspkR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511201656.UKzZspkR-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: mm/huge_memory.o: in function `__folio_split':
>> huge_memory.c:(.text+0x572e): undefined reference to `shmem_uncharge'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

