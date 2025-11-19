Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0142ACF58FE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 21:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BAC66B0092; Wed, 19 Nov 2025 16:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B8C6B0095; Wed, 19 Nov 2025 16:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381346B0096; Wed, 19 Nov 2025 16:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23E4A6B0092
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:26:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDD1D12FC19
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:26:46 +0000 (UTC)
X-FDA: 84128641212.29.86EEEBD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2606A40003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:26:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KE2dbWWl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763587605; a=rsa-sha256;
	cv=none;
	b=vHnFpT7x5zUeYNPcGPVPUUZYUH6TZfhMWd2MCj0sIVTZEHIMkbyGPL8w49sJ0qmYMhX7EJ
	mfyjYsVvLLOeF2D+DlRPgXzn4djBM+Eb5SnsEzv3J/SUqrPGfWUnFt1jWJYjRBP7afVE0H
	WJkdZrqAs3nraKNz4tBHE9JnLp8juzo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KE2dbWWl;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf07.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763587604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3hJroERfgo1uf9wh99bz+5+XCGh9K+oVxFAcUGRMMoM=;
	b=iJJkuHcByRnposNkQJ8Oh/0hRiPRL/oTus1srK7pLtTlzHrQQ8TmNAI1g5fR8/dS/rZjzp
	WMv7DVa6PsKvWwMTuJfLEuK2iSbl1muVslN2qSVlt7F21qVZfHv0LRxd6ribCPmaDKAZd3
	SdbQqAuIqDBdkwK49v5ldhP+ghEP9K4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763587605; x=1795123605;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=VXpb8c6Eyu0LfzAhaSbbq/3u6RZ8AeVIN2gukefPNcU=;
  b=KE2dbWWlE7+aSxpGt4+EJmjjlj4+qTNjXQOB0EQdX8tGVLIErD8uKbK0
   j0tCHO5gyIyX3EzN3liFR0qE6XlSAo++O4hyq4DFabqTG0eQJw0YnyjR1
   5d9/6sVEIWp+9Ucg9JMltpoPoVWPF+Gg7tDeDX0lA0CNdcTIyoTzoEqip
   gHBUfUfEcALbiMARLAxDJZiNumD8dIGJgPG5S1ypQ/YpaUOv2upwva98b
   qQIz7jUSnCfmPN2Nw9PdsTvxfD48RpQZedxZVp52qGEvb1OOJ69mr4Lc3
   JJip8LTnhlGYQ2/HbRADhIYSg3UHDhCLNTzU1lkeqksWsKKv/i6ODAiw/
   Q==;
X-CSE-ConnectionGUID: r0c7FbTdQsm05PvtX78xsQ==
X-CSE-MsgGUID: UrXgiJs8QsSpLIbPVLaabg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="88302637"
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="88302637"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 13:26:44 -0800
X-CSE-ConnectionGUID: jeeDDt4ZQMux4XyBKTBL3g==
X-CSE-MsgGUID: VR3E+WemQ9aDrw18UJDh4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,316,1754982000"; 
   d="scan'208";a="191198315"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 19 Nov 2025 13:26:42 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vLphH-0003L5-0P;
	Wed, 19 Nov 2025 21:26:39 +0000
Date: Thu, 20 Nov 2025 05:26:38 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 169/175] ld.lld: error: undefined symbol:
 shmem_uncharge
Message-ID: <202511200534.o4hsMNEt-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2606A40003
X-Stat-Signature: 85wkb4mjaxw5z6cs5eig37a9bycr8qb8
X-HE-Tag: 1763587603-531173
X-HE-Meta: U2FsdGVkX1+57gXmz7kNrb3LYkVgoQn+2kheGAAqYh4WKccblMmYKTL4vJxFo/DP/feOSVhAnisfl0We43asJMbyJxx1kKL+ap+OwWLXlhM16UGbmooC5LvCPeGcEgmRLG2N+Qp/EHQbVxn4wyUbpxsA8wekMBdirBOJ165wCht4KZcgFlAvfKQwXkAk1Msx2/ATHUjb5zgHVcKfPTF9HCOdf4pkEn6gPMng/tU6y2UjwIWQC8u99/NU3j7INnju1Y9g82I3+QGG5SxWZP1SV8XiFYhY7G82EFa9zsz3NINbZbyPQLWD305ceLuQQmSPkKRFlyCXcVNWNQXeAmmylofONlsRkNy+QW7Lj796DUZ9JH2t3AWOtMz5Gv5OAmiU85ZkY1oxtBK2ut8oKA1O/l2pgL+ZNdMc3uTVNJDg3iCcWLywGjZUkB1kl+bkjhMqJbuFJaV74xBU+hVIz9zD5xRy79DKxxFR2cueFSMFDzSbui5+uB6Q28RFXoWnA04zqWTzE3kKi23211cRR0+nzQp2/wi1u2DWpL/UmKhxols/UdWibYKin1c4uj1T4j7SMmwwVyFc8Dp+kaHwpcAMLDLEY1JAqrzpVjU4kSSjjjdQjITF703osIWBjiWA1vSQcsVDBtvdP+619CQYXw02OOvSXjUeCN/5QNFthCKwv4cLsDjtkxK4M1jbGWnHDLUC7mAZmW3rWkxdrxOwLRV0H0YYLm2M4c3rg2aXphOYhohoBOB37wbpWBAL8dvSLOCtNockkD6PiNgCQwRlul0w1yqGiabSPDTLleWJIjiI/9IlE94/k3dDw9AcUyTvT576ythafvt/BAf/j39CANk6fkfb7xNgqbjwbmXknnfTNQw01AkLxWPT+ePFMV/1yp5YnCRNQUc/4U521fG0Fe07GfVEBAd3aSueVkq1lMVJ0NdjpRXDVrDv2/vstdSAJdfpCeZE/QMuKKUKEi/H7Ej
 L7O7I376
 WsQ9bUYg4lKYJJjU7sSRpQsnlFz3wvMT2NStmErsCIq2P5YNBXKqb0My0Q+TFKBEGTVw5HWQZVioMjbfe8u8zd3AAbm4cggwfqcoL29QGRbWx9Owf6Y+zMZ8YsUCuBiIUmhDEe9AUTR4GY7kpA3YWDbwFjTbKSomX4W8CA3qK5Kq7iJamk5BtAPAMpY9st49Dy7wBGf5QgivwDscEEjfM9iQt00AB2h7Sg8NDqhPhWw+jkbsHB4cn2d5rVURixElYmbUN5xpNCqICuuaCTVh6wq7PFRQ/mSCNabP9LZofE0nj5OHooE06EEiSJnrDX3nn2udBUDg3UFgGdIuNITGS0AB5TPDv7oFzqV37x+l/+0U+07e9mPNnUciFw6z4Fc2D6w3Xy64wUN3/l/bq6EEPHUP+Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   102494e6776f316b6cf2924976681d790f278cf1
commit: 9a655bd0773b41af6d8515502de102544f3ec4c1 [169/175] mm-huge_memoryc-introduce-folio_split_unmapped-v2
config: i386-buildonly-randconfig-002-20251119 (https://download.01.org/0day-ci/archive/20251120/202511200534.o4hsMNEt-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511200534.o4hsMNEt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511200534.o4hsMNEt-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: shmem_uncharge
   >>> referenced by huge_memory.c:4053 (mm/huge_memory.c:4053)
   >>>               mm/huge_memory.o:(__folio_split) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

