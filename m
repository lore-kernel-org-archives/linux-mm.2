Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6469D109448B
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36036B00E1; Sat, 21 Mar 2026 13:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE76F6B00E3; Sat, 21 Mar 2026 13:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD5F26B00E4; Sat, 21 Mar 2026 13:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9B486B00E1
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:10:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52F4A1DEE3
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:10:48 +0000 (UTC)
X-FDA: 84570709776.02.15B9672
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9F02640007
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:10:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h91VS1GF;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774113046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNYxCLn9cwzlSEQSklNxt57RWjXBe9rQ2MgNFN0t0Cw=;
	b=xprxwOHXK7jf2yWWJF3a06OmIXJ/pTaYCoaUxMBtclJ7eh07UFkEVhBKaNrlvR2xtNCGEn
	cX1vH8jd068ujpjYw7zU0HWNBsvCHiQlWpIZSJGlBKqJHFWwbf0tnw+Te7ZJ+7vBAoOnXI
	equo8sjYn21vq1ZYbO5sGqvuVujyCZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774113046; a=rsa-sha256;
	cv=none;
	b=InYLErDAbGjOpPUQ0Z0CsQKYQeYami138TT3+jI5hMMtBJ/TKrO3Ej6SKJf6lbSd7C2aUc
	+ixu8tQxA3WyJFwueNw5luqwQY0YLHpz+vMpSvx/Aqj32A8mvvQjRxuMuTvK1L657mefPa
	fMb12YvDfNXmrepD/oOMBDnw1K8umE0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=h91VS1GF;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774113046; x=1805649046;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DX5T+L4GVDH6JicyRR4zZ6rjUsRLp6EmYUpASxbOlsY=;
  b=h91VS1GFt7Vpq5Bj2EmHEvbZ48EbxyiCQBsoxo1B6vdWCWCFkCkuBBGM
   2TEqUjnGSBlDYmskiMNrmbe+XVCHgoDUwO7TRiyf/kguMyykPe7t7Hsbu
   fv4UMacAS1P9N+GhSoRJhXH54oE6ALCqgjiwnx2H9RZbaRhoO8RZ5qY97
   fMOlj5k7f7YfbidBkGKrHL+64P6UiE9vfafbDpKRSx4SYhdxAPqpN6Knb
   gi1OOk743V6YhqA8B8ZHpfptHa0HSE0bc+L+SyCBaU1aC52ssmVKu61DZ
   ksK3bhr3EQd3JKGqXEe/4jC2hQ8m6aih+LD+2oleIqD6NCG1pXqiNdx8y
   Q==;
X-CSE-ConnectionGUID: OJJnT9nlQja6O3+wD0CuTw==
X-CSE-MsgGUID: cxUp2EQcT6yUByXWbg7whA==
X-IronPort-AV: E=McAfee;i="6800,10657,11736"; a="74884872"
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="74884872"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2026 10:10:44 -0700
X-CSE-ConnectionGUID: TrDnITc+TiSlkKxgqvh0Ag==
X-CSE-MsgGUID: WK5M9FYqQ0OGwVjL+TaFdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,133,1770624000"; 
   d="scan'208";a="254074287"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa002.jf.intel.com with ESMTP; 21 Mar 2026 10:10:42 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3zqF-0000000014P-3h13;
	Sat, 21 Mar 2026 17:10:33 +0000
Date: Sun, 22 Mar 2026 01:09:51 +0800
From: kernel test robot <lkp@intel.com>
To: Yury Norov <ynorov@nvidia.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Yury Norov <ynorov@nvidia.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 3/3] bitmap: add test_zero_nbits()
Message-ID: <202603220114.k5BHBav5-lkp@intel.com>
References: <20260319004349.849281-4-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319004349.849281-4-ynorov@nvidia.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9F02640007
X-Stat-Signature: equz4tjx1mn6gs4g9k4wtp6z9e7ptnwa
X-Rspam-User: 
X-HE-Tag: 1774113045-468388
X-HE-Meta: U2FsdGVkX19//oWbQ4Qq1qASDEss6grAUcjW0BZv42qxnwrZeOejytB6XKbeXEtLLhdUEswFL8wSh8vRlILBwAcFbzUz//axD8a3qXNV+XrkpNHKSAfebVYWplEQDpeXzFuQTYOlupzb0wI/fifKA0Ni/38UWdq3ChjQTiCwO9JqthANa3riHZklmsbObdf66+BqGqBPDWzDIFAkrC9Oc8zSdnAjL1I96oIgq+lt/gIEUmOf597SFcD4e8fd+BoKrWL3TTTSxWKXdQEBn+bsNDZsncxLuYxTBf6Sm39k6xtJsLG1J7C+WfnG02LkyU/n4iYOqACNvxZugDodGY8s6qNtB0ilzFwYSUMj5T5b2rOFCIPalvdUiHqagoNUvpjFFAqTUJgEi4/iYZWpCn2I3uPshLQbAAGygZdhxjZhfHjFri3Zhz+E64mNAPzwznwFN6Dsf+Le737NF45oQPlN+ZMcq7hBizL7hmg6T1iTffDrRIx3aSx/hPpJYz74hNttwL/qx/m7yCRIV4Z7w+CfoSGTF2kXI5Y/icPK24EtYq5tMoStZ64mX6749y9HFajIugbqcKz1Smd6lPo3g9Wa/TMOTwUlG/83TYrCF4uiMCueDl5rESuAxgFi7hHCcaJkuUDgPYDY7Ao/5bLWB1yDx4+kFQM9XbunT7fWfqk3C6bgaKR52JNT48Y9oPKRBV8Smp+76sp4ikOU1+pT4776BnINLAXcSouzmzYfxR7Qk02Au9YaagmCV76bJdTprxNY8hYN8Z5Pmq7Rdu6RX7JWSinTsz3mKFNLoNJVGpU/nDL0ax6LtYCiw96jAQxWq9X652/CrqWsmcuii4XhPPzGNxq5OCLANeQ8dAaUcdxpf4FSIEe5nuYJo6+gHCTbCDhiJmqIi4BrP8CAQocr0KR8fa2dcMEU2OncuVPOaY5IKiCchUJ2dYtecKCjj/oJEJuOzt6ii5C+PqBDeqggq33
 eeAkjcvP
 LK2ILDqG+HQTkTz9FWdrd4FcKEvRsgV9R5P4TCvBtyjmuctWV4zxWg1ocA0fJbQyVqkvaYj8HcEsJk7rp7l1/39e1eNELeVoxADtXG12IEuk+1LG6NqaUsy2leQ35zQ8nrO8lE0KT4URAncNPAWMKmiTo+vLpdyNAsQ+MT4RQkMBRIQxNfkKi3u1Yo5TmSTsqSsukM9N8gxe/jcljczmMCSrJFePn2lXgQ0Yb67b075Jz0ZybJ75DPphcWubmVIZ6Cualj5hOD9HSxNw7XTei9Obd9qLEf2U4/0TvDWDA/5+LzOO19nnyNhLXXSVjGmyG68m8pQRoL7tmmYj2IchW54PJJ2VBo/8jOeY7YABxNQM7SVw47Z1Ds8rTF118sIz1U+ScThqOP/NPgtKYV9kcZsBUOt7znX1zsjvNTCOxrz/ixe8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yury,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260318]
[cannot apply to akpm-mm/mm-nonmm-unstable v7.0-rc4 v7.0-rc3 v7.0-rc2 linus/master v7.0-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yury-Norov/bitmap-test-bitmap_weight-for-more/20260319-221930
base:   next-20260318
patch link:    https://lore.kernel.org/r/20260319004349.849281-4-ynorov%40nvidia.com
patch subject: [PATCH 3/3] bitmap: add test_zero_nbits()
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260322/202603220114.k5BHBav5-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260322/202603220114.k5BHBav5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603220114.k5BHBav5-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "__bitmap_or_equal" [lib/test_bitmap.ko] undefined!
ERROR: modpost: "__bitmap_weighted_or" [lib/test_bitmap.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

