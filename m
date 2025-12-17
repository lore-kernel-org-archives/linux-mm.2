Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A77D64079
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 511296B0005; Wed, 17 Dec 2025 02:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF136B0089; Wed, 17 Dec 2025 02:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A07E6B008A; Wed, 17 Dec 2025 02:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9C06B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:00:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9BB88B62D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:00:20 +0000 (UTC)
X-FDA: 84228064200.19.A7045C6
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A534C0007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:00:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UKfS7UF3;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765954818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Mn20+r2GcTv/N27AgRFdKA/i5Cse4iEZukLPIlDEUAs=;
	b=VfQUIQGjxFcs6aZXxufhf71VN0eRmLlB4VZ74lEgpvGOEUpyLUx6WhRRWqSaF8kcUO6+nY
	5/P5A6FZWY2bGfQLFdgrQPdLNeFh7hIhDA0TiXbeyMIiW2xnksYzXN8QL2v7DT8ioNwPYv
	MGjrNwolrxqEpvqelGO82fjF36eIq00=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UKfS7UF3;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765954818; a=rsa-sha256;
	cv=none;
	b=wDi8Lp04FSBT11cLWZ1+cCtzQCQJW6BUQGfSs/gLbr4eBv+zXjR/rjOT3wAyJHqdXfbIw/
	awxUfEVTdE7W5WqYmsX5BaxtAmKGOqKurtYkgyqHdz+f1jGZywx2kr47VOLgKT+24lPZpV
	aPZPuCdueQa2u8KY4tbO+Qymo/UL6EY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765954818; x=1797490818;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ixiCHs68OVhN8Mw3P9mN6bITLbPSuK8Cd4sCrT7YrMs=;
  b=UKfS7UF3zc/kpDjvmPtHn/dxd10EXec8L9oHZe3JZRVZ5dXqYgBr9w6D
   vHvu5FmesuUumPXXQ+6qa+di5lCRV/qP9Eh5sBl8aPeXj6gsoFhQ31W5y
   DDVbHRy+pgOSXN5SOxw3N/3DRIh+Zawwf5G8kdEdc+G3A/ILgHtYLdWtv
   /qeMn8sgNq/b/s/mRyfTf6+DQBR0R3zMttZqZInvrVMhJCgNuD6JcWHw/
   xg/H+WHWH7IrwJlUgnBqmr8/1q1l8ihAmNUeNEmGNBnxlE5fewa3qWma5
   pNskyanwKa/qQdYqEypihLyUlAmvpJtE2Ixfhyyymqk8QKX2ZYAj2igiV
   w==;
X-CSE-ConnectionGUID: d4RN+WsXTMeyQAya0pgwMQ==
X-CSE-MsgGUID: ihIBWPzIRHmXLEctZ3f8Jw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="71742609"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="71742609"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 23:00:16 -0800
X-CSE-ConnectionGUID: QdMjsLMGTHqCS4eznrVHIQ==
X-CSE-MsgGUID: Y8DU0QR6SASMO+qdL8/Dqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="197978073"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 16 Dec 2025 23:00:15 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVlW8-0000000007Z-1j2f;
	Wed, 17 Dec 2025 07:00:12 +0000
Date: Wed, 17 Dec 2025 14:59:39 +0800
From: kernel test robot <lkp@intel.com>
To: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-nonmm-unstable 60/60] undefined reference to `envp_init'
Message-ID: <202512171450.PtEMRk88-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: x7e65xe9pwk5jh5d1rtbf1mk3yha4sut
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A534C0007
X-HE-Tag: 1765954817-380642
X-HE-Meta: U2FsdGVkX1/02u7ZNL2FC5bUsHXp4z2YAs88Xh+yuLfiXorWGTWzVs6E/dAKBIWvSNCDrS6USOvN+oMqsLkMUPyrCK0v8rpCgB1r6WpP1YXe2P4vZ2UYRShd5mXlFGlyxLrd7KShcKcpcJdt95XeQj80K4gcDszhg4XAr4nsX86ywEAqKx0cwyGJMIePM/Mb6ulTEsCy7CRgepL6sd3BvXMXqmBfwpMvrcCNvfBRrykOzwI3qg7hFpEpmAuUymBIEbFUV/SIkmC+y8B7LyVBGthQkbmO+wSeI9BOm26FBknH7RZLd6Yr/I2vEkVriGivmQyJmJbWQB03gFSIvaDimSKw4HFpptFfdLWDocmWDgwCg4SWhXbfAhnX2DpOXgCP2LQ+815tX6lmtyCMiIsRRn8zQbXRfL6IE9kjOwiLzz6FoRr7jpE83rnVmatYZ5b72nzLXFUkPepbvnGLHKxUlTDk0jh7ktPu4lkf8TRb1E7E27B/TQuQRnE6oLoMrLQR1VVmwvAbVyZly6xXo+hAi8gdyDzjDOKCBOiZV2jVzYZ3v0D2yhL20htCnouHoigWuPvaocWaaks+cTdi1rzlBkaoEwoW+9eO8BTHe1/3e7YrEQU9ESLbCtAXhwvhYKBMzRu52Ugeg3/uPqxypkG/k+tvLV6B06g0VHwebq8bgeMJgbLdRRCrsR/3GgWBbpwESrEHavqkgj6r2xaMTPxNa5Ifu2RNcYgjP/a1Bh7O92+9V8+R70bW6Aq909HyVJLwNMsEIwmkAnNZ4Medc2WRGjMmSPGgHcTDPBFGWHHPd/73oI4ZMvv/IEx+uaorI7AtJCqM/M+v5zrSSTBGazJVj4N+iKP2FpY33ejRysIzlzQiSLpc4e8cMzOI1ijV93ojVsJAnFDgz2UK9ohpOfp7IQn/I7TExOn0LRUsqR8crrz3alut7jj7dt0up6DPat849q0i6wx0v+92TQf70oD
 +i5LXeu4
 LZjipr1pvaZk/DOR79GGOGA/DuYlqYQtJsU3U6iS9ZXL1/i/62lwIak6wf1cKT4KIRLLP5JGdvV7zy+CU2ISW5n+7GimsnK+vSiJ9hGkhODswOQrM4RtfimV48qZo9R6qrozHxlXWeMTbmik4pa/yntdsLjAS9uFHaq7tX9rnGrYBqPhf5qxzQ422bhYA6AVboMseXQJzISy4SjpavDmIg/IK5Vt7wvPK1iQj2kHhT5U3hTRrtMjv9LGKBbAbRFwlRHViwmYVscKWu8S6pcyxRvTQQpJArQiXrJF7v0Jjk6DT/YrFfTsAQ9TV3B6c5zoEHgaCQ3SBl2L2nOVtiVX4X+1XP/vQCOum0TIa+nu2JYeroibyHAurFQyQ/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   036a67646ce675ebc350c4f60b67578cf9b246dc
commit: 88800d4048f5ffd0dfd05dd82b89affe6b74e55b [60/60] init: mark envp_init as static
config: parisc64-defconfig (https://download.01.org/0day-ci/archive/20251217/202512171450.PtEMRk88-lkp@intel.com/config)
compiler: hppa64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251217/202512171450.PtEMRk88-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512171450.PtEMRk88-lkp@intel.com/

All errors (new ones prefixed by >>):

   hppa-linux-ld: init/do_mounts_initrd.o: in function `handle_initrd':
>> (.init.text+0x254): undefined reference to `envp_init'
>> hppa-linux-ld: (.init.text+0x258): undefined reference to `envp_init'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

