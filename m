Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889E9CD3447
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 15:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F376B0088; Sun, 10 May 2026 11:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF966B008A; Sun, 10 May 2026 11:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF4FF6B008C; Sun, 10 May 2026 11:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD076B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 11:12:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FB06160442
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:12:33 +0000 (UTC)
X-FDA: 84751851786.07.3F3E04D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf23.hostedemail.com (Postfix) with ESMTP id 765D1140005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 15:12:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a853YaOk;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778425951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Hcz1p5dvOMuOXfg/7dzp9g5tJFAweWNPonpCXhgIq4=;
	b=iEzq8RxNB95v9AORWizmQwDT6nlA7asffrVx4vIuiQ2IsF1Eesct2uQcFdefXIMoUaJylH
	dsL/CVwwQVRWAVm4t5D9hS85ELivldQtvgR6dyl3OB37wL7/ld5wJtw5epGiuXOP31ar5E
	ONHs24j8dY81tMzK8sr+No9mYotlpS8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=a853YaOk;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778425951; a=rsa-sha256;
	cv=none;
	b=b/u//izAB2/uQD6McGkkjC9WlxKFBBr+wG0m3F7X1dTDqLgCY4Xa7klZRQ/3Fq/d1dVBWX
	sn13te0cmMFu8/+Cg5ZfSUDUGbpPtJdy1lsz1c2nJjTqcZ6BKvgFlpUwYQgt03fhz6FMKL
	tNKIsVtVqEzuP4T9iMdpRrjxL0mJM84=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778425950; x=1809961950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=N+XZMSgicn8mI99CZ460axGdpor6zxJtBh7/Zgbh1yk=;
  b=a853YaOkAv8D4rbzqf1vQjpbfg3VahmmUp/kwa1e9eXETIhUHbgAzag9
   uK0/QEypT0MX8Q0mzNXIjAJ5m6U+nSu0YY4KvXxZ6XvmMB9n9gJXtushP
   0Y3pB1907F0f3f1kIorhN9m+wykmDCwbThQCX0w1x9W0mBP2LsRIGXvnJ
   /nbv9YA7o8WInn6IUH4eqiSs4sfD3SDzQ42+vTuS3uk7kMG8KM0CKYqnI
   eoQGPS70BaVzfPwguRaZAuY1MLorSPi6mG74rrCbixmHfpbqj2BKXAnFM
   9bqT05fuhlWdooo8x8T1At6ZDoyXWAm6gLr9oDfOyk8gwzZyrRTLe646q
   g==;
X-CSE-ConnectionGUID: 8eeHig3gSWGIJvroJIWHSA==
X-CSE-MsgGUID: /LDLijccT5GbOCaRCDnqmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11781"; a="96753733"
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="96753733"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2026 08:12:28 -0700
X-CSE-ConnectionGUID: AM6aWGUATqKZXBH+JQ1pSg==
X-CSE-MsgGUID: KfSRvOSTTuKI0VJjlUESPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,227,1770624000"; 
   d="scan'208";a="237175762"
Received: from lkp-server01.sh.intel.com (HELO 82327192134e) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 10 May 2026 08:12:27 -0700
Received: from kbuild by 82327192134e with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wM5pQ-000000002LB-084H;
	Sun, 10 May 2026 15:12:24 +0000
Date: Sun, 10 May 2026 23:12:21 +0800
From: kernel test robot <lkp@intel.com>
To: Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org, Jann Horn <jannh@google.com>
Subject: Re: [PATCH] mm: make zeropage read-only
Message-ID: <202605102300.PHd18T7k-lkp@intel.com>
References: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508-ro-zeropage-v1-1-9808abc20b49@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 765D1140005
X-Stat-Signature: ty4kjm3an1bo6tgdf46zrbbpbsza5exc
X-HE-Tag: 1778425950-675983
X-HE-Meta: U2FsdGVkX18xP3JvUtApt1OyQDzmP2g6YeckYoN6eAii6X4XRwPVdol0R5ZmM4s+EkAVRKjw7PWBxPQVMRAm1dV9h5H+OL+Wi2BF3IHydzwXUFmjOQqnRT43EA+xiWmAm/xfHrnOGw3w2Zei5BCEPLHydyAYhfWff0Y3QV6QLoQC3+o+eOvZFupko7toJgSssN/19kTOIRRLxqRNSJm5zvSxh7Pwm+xixzwwNyjJ3BoaJfVsNOUNivXkgTVTW5RBxMJ2YZ3ieQrRUbwGBW5H8IEkqR14OnRSJv3ZLA3UD9se1319EOKB4w7VWW/S+9YjWtvmQHE24ThpLq6yeiJOMFVb7C4Gq9/wPjAI/ZfTtmKYh9v3iAOiVOjzcv8xscnWEZFnFc789PvErC88hVbvVVZsgUsxccFaX1eCW6bUGXN+RzKnebVwxJaKBotVLazOZ20t6f5zot0J182kvPiADJFsenrqVyFrBiS6DvOE40JuI+suNzJcbmPOAFqI6XBB5hVeoDqRjKu8fpXqUPkGbWDB+s+5sCsmR/hGyJhvk3xg5DsIcBghCrsfaNkamd7SyEM2W1AugfIHJdMXidVYwKBDYyhM+tA890HCdPhvjNcJLgHxb5TzyF8nDuK1vIFjuB+oXD+eoip/lC8+miVLkYtyQFrtv82N1Js18sJPT8TqcOx1smwY89Uq2OyXaqqY296Elqn3mtyAi2TcJcyf4k0P/SjHBkvcNqpb3uJZ9Qo7HGZlOsuMjxDkERhAMH1EVgGtyI5IPZdHar1gPUTSGAQ1V0XG2GuDOV8dSBwPdTXff9FEg56Igj0mQWkw5JvkBSbWXefXulVlUI+x+ZL8devefpfeTeOcaZm7ne/i+6KavfmTryFiiWEg/URS+MugvhlNTUTPRdOe10E3o1nytsqakIpSIScmnNYuW5i502PJoMTyzJQakiZk/8twOU1KqB+yfsnqxa/AEAPp5GC
 8U302Mc/
 AWns/KFGbZx0KwXOSNrfmoH550G+xirDTD31xV9yGeKwo7WZmarLuSaCyUYl0vmwzEV1m2OTjRr45rLpTH+JTAvBGiL6NIyaSYEdJYFUBgd2360yB17MXx4NqF0QMuxa8Si8MYH/x5mmR2xZmaQKtkTjOULcMis23qJfLTc0reSKKM+csVtXUAiDNlFxES2uM106SGR1QDLoXb78+ANW7ewsE2yagnAoeH8SJxeVNTPyscBEwOztBnKAgmrq/d6HB+v9IjtVRnLXlyMXl03LoVViyctT6+O841+XJ4ETkNtiSRwHkSyM/310cKI4XhViTwPmCCEn0p5RmG6kq99L+Esx54QgrsXRqwhs+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jann,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 917719c412c48687d4a176965d1fa35320ec457c]

url:    https://github.com/intel-lab-lkp/linux/commits/Jann-Horn/mm-make-zeropage-read-only/20260510-200814
base:   917719c412c48687d4a176965d1fa35320ec457c
patch link:    https://lore.kernel.org/r/20260508-ro-zeropage-v1-1-9808abc20b49%40google.com
patch subject: [PATCH] mm: make zeropage read-only
config: powerpc-allnoconfig (https://download.01.org/0day-ci/archive/20260510/202605102300.PHd18T7k-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260510/202605102300.PHd18T7k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605102300.PHd18T7k-lkp@intel.com/

All warnings (new ones prefixed by >>):

   /tmp/ccjZQT3J.s: Assembler messages:
>> /tmp/ccjZQT3J.s:3163: Warning: setting incorrect section attributes for .rodata..page_aligned

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

