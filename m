Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 715461099B3C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 04:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B98F6B0005; Sat, 21 Mar 2026 00:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669E96B0089; Sat, 21 Mar 2026 00:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FDB6B008A; Sat, 21 Mar 2026 00:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49B2C6B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:49:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E79158876
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:49:09 +0000 (UTC)
X-FDA: 84568840818.30.370E2AD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3288EC0004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 04:49:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WfuY1ZXM;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774068547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=a9RT3kn6Texe7XOZdc3vL8WrxS8qtrVuTIsbF8LfqMQ=;
	b=QadfZtmBUjtu1QTlWAyBMPPmiAXTLplxamFw/HkJ9qzLqmEz2sZfMuWQ+6nm8FMO8+db9Q
	KuAjQAJ/8GNwMR8NYtcf0tqt0pSVkbF5qSu14tceUPZYzVSa0KgfHuoe94P7EpnCrOu3DF
	l26lnVcKzHUtOSkrBv3Uv5vrHJnW6Gk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WfuY1ZXM;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774068547; a=rsa-sha256;
	cv=none;
	b=BSuoSBo2xrXwMWiZ3enewiiMomb8q72pg2bNQbqR7G8yRNEl5oMI+vsWd5UDQ9RYjCvFGl
	BQNDLIvBWX+ZW+d3JoijXlxxqNaHuTVu3/WC/Cw+KbYnS7ABNLjs9zelI5QpbuhWJaf3RN
	wBrXOPIEi0Z/rbF/1s11kCY23osChb4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774068547; x=1805604547;
  h=date:from:to:cc:subject:message-id;
  bh=YpsLFUQdnRxAKWUHhi2dFhscdeXowHwGUXVwOe2VciY=;
  b=WfuY1ZXMMv0O22U27Sm3cvKGNDYt7UITJwObcyqMMKHEgJdZ5m6Q/e7L
   pkGrFea1USK9bLvwBn8c8AeDKMkxfaNFVbNkEEJ6o9sDRw3x4OwLRKzLX
   /oOedHjikLGn0KbCmol+aYv/OL1E2RCnf+Ni8xbw+KPGPfYAltlqKGePc
   E1NGMpuMtqqagf+Ytqu7tq9Z9rxcviKc5RCLJVxrff7Vcv29TXg2M0FR/
   hV9zdp56+onqH2yfF5wjig3ONUEc2jYwQ5ct2+lDhJjbesD8IKezHf3Rg
   6nHh1H2UiTeyLMx/pXkiEYIBh3a5+8E5PjgPzQXrSkltUTFN+mVf7hG3A
   Q==;
X-CSE-ConnectionGUID: GRHgPpi1S9uyDZT0AD2JxQ==
X-CSE-MsgGUID: dG3GNh5mSIWnZiM9XNETzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="86518216"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="86518216"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 21:49:05 -0700
X-CSE-ConnectionGUID: TSdFnOx6QSm8OZXZ42VZdg==
X-CSE-MsgGUID: LI7KgFEwReqfDpiqvii4fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="223528275"
Received: from lkp-server02.sh.intel.com (HELO d7fefbca0d04) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 20 Mar 2026 21:49:03 -0700
Received: from kbuild by d7fefbca0d04 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3oGG-000000000JN-33mL;
	Sat, 21 Mar 2026 04:48:43 +0000
Date: Sat, 21 Mar 2026 12:48:23 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Nicolas Pitre <npitre@baylibre.com>
Subject: div64.c:(.text.mul_u64_add_u64_div_u64+0x40): undefined
 reference to `__multi3'
Message-ID: <202603211216.YTKRdi1b-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Queue-Id: 3288EC0004
X-Rspamd-Server: rspam07
X-Stat-Signature: ngej333ziit7fwzrisn5a64aomgeayzw
X-Rspam-User: 
X-HE-Tag: 1774068546-596753
X-HE-Meta: U2FsdGVkX1+BEPoCx2JvjURCGfJv+bxRLFf9J6UZPHLuOtwkgspWaig8v48/6W6lkZVIxtZ2dT/pRGDdyDpMTaEbYYB5NiOjEW/Hscb51HN9NhmxTy+ubYOhpykE0iBX5cvFl1rWAjt9InmPLLpIiRVvvYaBQdh/xFxa5p+CpoEgf31w5gfOn55IhYGvHxXmtQSAR70iRNNNtgF+FNGJ9pBN7U2C+vDJtwqHdE/CdOhwvEQ2iUm76zDnU2SygvfC5djE3TFl6nM2vspwEaVvCXV44x71V1uslKszxC0J6UC/nqSCV4XMsyhsd9/Y7kBp/ZO/Pd9QipSVbinI5pn12pTctUyPSYgBz9o4zkkIQNvDEfeQoIpz1d5GIXg1/7HhSigXQm9Q8uC4Sgzt0qYWIEt14sNuxrRPLIM0V45ClZEzHvo9dTQN66nHaDpkXQ/ZDabf6ZIQnJBBGoN06KB6yN1twnXFjuNK6Uw4q1Dvdd5TQxFghgV5mpu82uAdU6Dmn/q2BxJmmje0Q+84Evkd3Dvt6wnmiZu165xCFB5i8lCr8/os3COpcY/08yKVyJqq32jLwptYtabVT6ojCQLcXCjU2tQK7MZTo9l+0GlCzbu/pHP697D+JRydTYLONJVrlO5hZyRrgMjRZwFUX5tFUuUjpnaDsT5R9Gs9Jk4f66inge8qYVsa0RfKMTXVN/w7+At8bAdlGqXDV2GswEXzDv6ouAE9lQl9lylPkw/yD19Oir6FVInXefVaYiU7WGrUFv7LI3pdYz+mmU7DyRabBOW2sTqZJlEhYw1SNe98nGSpxL++4fyspP3uaA9fQ/j4FmEwKdxWR6Sj34TfLSmCjwSB97BcRXSAbYm3oiHpYnSkMmpGeXwmdRETlhBkCyBXEAOD+EuVc6dGcu0hcA0xGO68T44eE6afUEOjlMgPm+lBw1eQSQ1wgS9E6XMNXxiu8bYYVJGV60UH7TmBeX6
 7YNd48gB
 NalIorMrwgv0n2+hL0k3oSXbE1Q0DsnL9wIDRlb2QurUgjFGqsL1nHn1Dm6lyzAuPFFM8pvRv59d2CNZuN0Qav+LX7RhkpnnSkY04O8z2BLCaCy4oRCLF+SQkBjuQMwBhmJ6wX0whTZdPG0k9nAQRUAwqI0G1cm/V+oEnb2V2uMHZBM9hlZcFEdniazaMISrrQfUBiPf2vlbgwXd7TSrp2UMIFwhU9sdxWR8Wn/steEbWxPxg8oopqcLPyaMec4WvaqQuLmVVC0ErAwW2Wyyv0i/22RjotMOzneoagvtki+KvRUmtXbGaej4WS2Obk0b+T2T/r85S3RvLfXdjBSX9vroUwjsvO4RGJxuG9bntGYUQeaO9IrYpcWYyqfSDzy3BI8nk/LY3Y+rrN9jTuSeayev0/IGj4djgq/dAmp7+/Vn1Oio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   42bddab0563fe67882b2722620a66dd98c8dbf33
commit: 6480241f31f543333ed0c7a209962412461f6e41 lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
date:   4 months ago
config: mips-randconfig-r122-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211216.YTKRdi1b-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 8.5.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211216.YTKRdi1b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603211216.YTKRdi1b-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
>> div64.c:(.text.mul_u64_add_u64_div_u64+0x40): undefined reference to `__multi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

