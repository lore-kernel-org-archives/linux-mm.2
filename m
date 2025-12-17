Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DABD64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111E86B00C3; Wed, 17 Dec 2025 02:34:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5946B00C5; Wed, 17 Dec 2025 02:34:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C036B00C6; Wed, 17 Dec 2025 02:34:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BCF6B00C3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:34:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEB75140938
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:37 +0000 (UTC)
X-FDA: 84228150594.13.3933488
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 192A5C001A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LJRAz0hY;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IxmNRXRD08owrS4/nto2beYoZnFQZHXI0PSuu79HkI8=;
	b=niEjJy7W1Tpv0rm89CCKUbWy5jxFMmpf3Ngi1W3BL6pphAZl5PJ2MOYs2nd5W32CAz9Rqo
	/vSzxtbjfh8we1Vaw6H0rJmZRowOvJlX1grm0GxRLqv1WVWhNCqF0bJNqhIYYjC68HL7ZU
	FqxihkWjLTGG0qsOPrD8dksswlI7PA8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LJRAz0hY;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956875; a=rsa-sha256;
	cv=none;
	b=lkYsqd/H8fXLGGCBmKxVnC+0Q2KaYZmMnQjX06wWx6GHtucEiFJIFQOxw1cn1MQhOLHQrL
	73eocFzUrMKw85e2hNcMw+WtNVJJ6H4v5zkJaPnTTtYqICfU8z9g94wjDqLEQDbzpvT2P+
	kXTGMYQScVnhkhTNReYbMEjGCd9VToE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765956875; x=1797492875;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2z0McsjTOB+P3exuNFKH0/lauyHMHNPjxuqumEYpnPs=;
  b=LJRAz0hY8HcwtnEI+KrgshtEAdx7eBNfLVD54qmCS6HkyQuKNVo4eNC/
   HWyvZqLb4j6cKIL2izNL78RVfgjjfKnYm95jFOzg4dbXshS64CkMw+Lql
   dq1q1F8bhvC4ygqafFG1LLCiSFv87GA+Aba8Ju59RjDuvYME5BZGGbu5m
   bWfMDFg2cvaEV/TNesutth1xQXY4atjclxAYRfAfCVVlhYhnGZ9kvZOXf
   Lkk4S5OPac8p+k4YHxbeTOriDZ73bOjvs1IqUUFg+tqSll58tQvRNMj9Y
   v6KoYTp3tyAfRpbAlADO0sGICJ1dodGEo69zJ1GRhIHgttJ0tzVzpLxWt
   Q==;
X-CSE-ConnectionGUID: IncdVemERv28NwJh4nmAlA==
X-CSE-MsgGUID: 4652x97dTZq9YnC94gSPvw==
X-IronPort-AV: E=McAfee;i="6800,10657,11644"; a="70466162"
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="70466162"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2025 23:34:20 -0800
X-CSE-ConnectionGUID: CKayANs2Rw6D0QUgkGHKFw==
X-CSE-MsgGUID: xijq41dUSPiwjI6RGGZ3Jg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,155,1763452800"; 
   d="scan'208";a="202733148"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 16 Dec 2025 23:34:18 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vVm35-000000000AH-2k25;
	Wed, 17 Dec 2025 07:34:15 +0000
Date: Wed, 17 Dec 2025 15:34:08 +0800
From: kernel test robot <lkp@intel.com>
To: Sameeksha Sankpal <sameekshasankpal@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-nonmm-unstable 60/60] ld.lld: error: undefined symbol:
 envp_init
Message-ID: <202512171554.G484xf2C-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 192A5C001A
X-Stat-Signature: zni9kasojrh8bouo6fnyc3upyttfh3n5
X-Rspam-User: 
X-HE-Tag: 1765956874-196062
X-HE-Meta: U2FsdGVkX1+mrP90CmDHtqDftRy2GtQDKJCLQ9/MZvx5nad7ABpBpDRRhbvgBBd5P8QdiOpaApN5FZTGwBUhJK+gHONZofwzg+BTQTFbEXPlcNi1AjD6OcZOgTRn0QrKXdJ6Ep/I3HK3FzLPDKXPdrhMSZDIH3PLsKQwdP9faKy9kWsbFTDKvbHDHdh68X4jcdRIxSgRNtp3CRycfx12zqeetHPl0G7jarNQ2qpm+XajAzzSWM2h+P28MlxaE0XMwMCsg2Va1T2jhtUFa0Bo7LUxEmp7zV4b7YSohTns5fykQmaGKK1jsJuoOg8C/sbdePmAJtPeLMOX3xeKab1RdfUmKaEsRyEraeZcCaXzFlzG4nRG2yd7XuMLtGC/UrEiDFT142wVTu/k0WKdmGN6FuDodsBUC0y3TDxnh3MB7ayNrxsOYB6bCjjIpS0Sak6XKthahTIzBFE3dfsNUJxIXTksTjKXYb7TJ5DIAJ/y+SkHqigTAbN7u3PdLrDt6JKqC2J65O/tOkNIugYWf5UXm+fky0PR78W/5itU83/FWtJn3VeAzD2zswfr9rj1WkIE/u9FNDmWb5Nmm4bYAAVMNVKY+DOMCG6nq9eing7msS30mSkrPt6mEgAHTU8cZaik1GOBsBtHI/BbvQXryimTSv4dXw1NjXW9fWNVpglvyoQXtHmP//or/KCj/FKzx1gl3ih83EGcbB420xAwhDEIGdanaAnYEK8eUuaNo3S+C/JC/N//+5T36BR35zSlCXEwQ5/Pjx5ZJfUr+TUQ6sJDZP1YQ5AjPJHLOWgwI/xCFOYxY9Nz41Q6x228hlCNA6tOG67xaPMk9+TnV6rJhhJH/snHSYY/9AzoU8wX+k8rSXuNc1gUVta0+WTnxSzHnOABh6u1HIdqTHySQ0mBP9WAG9l/H89rzOw2k/gzJ962dNGDCCEcAzYV6IpANGS9W9gqXXN50Za98PHhZB7/Gs8
 /Uj0yqZP
 Bb9T5XT8UaxPjcYInmgQQuw0xOKLL4dY5xNngGpLNAlwRFTKUGyu7mwZJ+GQVPWf2C0n/KboCg5GGgakBmizWHoAQOG4xJCyAn1emchnDmiDIetbd0OgeTkMBbgkNgrNFE5f7tOpyBDto0d+ECZHuXrBq1waWWuS3zUeHl34y/30cZa5DvKqYH8KKsLAjX7gVfvuHrTPkcQ6MkSswzPxxm++3vXESl9i1uihqjZNixfCDBjqSpYy0IQ5cSw+yCQx/AWvpB71NsSLqKq3EnKHdGa+/1JCY3/Bv2Ji0XoAPufm0wGKCmyWAJLGJOjJ4cuigy0ZnBAGGQrwjoLC2xnuZeXxa4SzVgN0QHnbpbyvx6N7umG7GTPDeaFbC3/hkIclYBZT4ZQj+uBueruH/+a9B4iFp/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
head:   88800d4048f5ffd0dfd05dd82b89affe6b74e55b
commit: 88800d4048f5ffd0dfd05dd82b89affe6b74e55b [60/60] init: mark envp_init as static
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20251217/202512171554.G484xf2C-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251217/202512171554.G484xf2C-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512171554.G484xf2C-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: envp_init
   >>> referenced by do_mounts_initrd.c
   >>>               init/do_mounts_initrd.o:(handle_initrd) in archive vmlinux.a
   >>> referenced by do_mounts_initrd.c
   >>>               init/do_mounts_initrd.o:(handle_initrd) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

