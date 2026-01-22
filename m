Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9978D3EE6B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 14:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6949F6B0205; Thu, 22 Jan 2026 09:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 642396B0206; Thu, 22 Jan 2026 09:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5784F6B0207; Thu, 22 Jan 2026 09:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 443E06B0205
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:44:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA0301DDE99
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:44:10 +0000 (UTC)
X-FDA: 84359869860.14.4853C21
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id F2DE240002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:44:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NCphwYqX;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769093049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=h8XykmLemWYxi9zFSLfXx8SKXzYxKo6wH/sn5vJqzuU=;
	b=Ly/U0hj/m462wPjkXGwhIGg54JxPzRVQr5C8QBw9giu76NyTx3ZUWctZsHAMhgfwpBrTRU
	dLGeifo23Am7rxoReAec8eMEI7Eg0bElCLR0XTN9RRhbUvcs0FNwVnxz9C5QElsEzu0R7g
	LeM23FGCQtiCZRpMVKVSE7+c8PGHbbA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NCphwYqX;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769093049; a=rsa-sha256;
	cv=none;
	b=br6ElXkIclD43sIGSgQD0iILQ6+vE7/odZr7SH5naLOr/IItK+/A9aFQrtF4oosWLToWC0
	WYnpy5ZLXA2Wln1ANTR0dr3qNJcZi8BaX+Kn0QmgihX+HIFm5ETleD0WDQ/W5VPrDpQN+/
	IUuRwSI7R3C2SmbP9l8b/PXipZicPNE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769093048; x=1800629048;
  h=date:from:to:cc:subject:message-id;
  bh=ZRVbP8VF0SfpNF15gkPw87CRoenMXvXIhdADs1+Adjc=;
  b=NCphwYqXBeiDaDsKP7XqlWZijIJXtktlEsEff65Wp8hJRSqxHrcWd/Q4
   1EBsd+emqP4gUwoCWKyMSt221UwWGUspOl88rA8p8l+ZJBT2WXuwJtu5c
   imt9SMM5TNgd/9R+MaE3GQLfLmUimKluf4f728aeXj1d5LK10UouYFG98
   IlVFgLPZ/fPEKK7KENen3xcDZSNJcUX0Js9BVdPdI3oFjaZh5qWYzw+/z
   jfiRXi38QfS94fH84WLPJXn/oXJBmmycC4bi5idnV/wBgLRsOtvq0oT+2
   5iAnLsksxdUt0VT5AumZrE5GofkRkBSfaFlR0mhow6ryVJSmiDs9zSc9s
   A==;
X-CSE-ConnectionGUID: xuMsMGjMT8ezq/tRa62QyQ==
X-CSE-MsgGUID: C4WnaJjwTD6z17nUdvRF0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70392102"
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="70392102"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 06:44:07 -0800
X-CSE-ConnectionGUID: pJHTuGUNRDy92Nq0JQIn2Q==
X-CSE-MsgGUID: bVQeI2vWTju6L5wzLvneRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,246,1763452800"; 
   d="scan'208";a="238004404"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 22 Jan 2026 06:44:04 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vivuk-00000000Svi-3a04;
	Thu, 22 Jan 2026 14:44:02 +0000
Date: Thu, 22 Jan 2026 22:43:28 +0800
From: kernel test robot <lkp@intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Nicolas Pitre <npitre@baylibre.com>
Subject: mips64-linux-ld: lib/math/div64.c:undefined reference to
 `__multi3'
Message-ID: <202601222217.uzed54La-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Queue-Id: F2DE240002
X-Rspamd-Server: rspam07
X-Stat-Signature: 4kkf1by35hxqiausdied4tu4jus9asee
X-HE-Tag: 1769093047-347502
X-HE-Meta: U2FsdGVkX1/NW1OTWFRkdptk3hYcucB1tlqn9g406DwkbvdNi4gd4DW8/BrOPaDShZs+q7gzvSO3E4eNn4MQxpG0CQ/JvPVodSLovRH55vEdLt8Y0S0b3t4Qjjc7muPe4pwppAqg1vhe/Y37PpWFBIAlqlkGMFUBq+GhibRjpFP90VzLVrNZagj6YKOQPNDQv4ybg4yEmP150Ens3usjJobPqSgYYV+u730u1ybuSu8xHpHq08UBPu8Qsu6LkSZLZmwx6ut8GxHDpIaEhT577T4fsN4aEYWRDs60N1jbdL9pIMHLMNjTrsi95OfFBxheM27K8S7mzX1aFpyw8s9Z/f6sPDFIgUBSktV5c7lZ34DzC3csONtlv394uGbnZ32vh6bIOYQeP1dojRvGBEIWS0ozZH6kLUBm0RFrnYVag2sKc9wpyyzXUWHw/hHHIVzxECFAZE8pVawQh5BMKHTMOxuL9Gxss3qmR1SWCuKfbRS63DcBJIwRdeQ9uu1mI85NI/UeksR6nH9Ppi2ls7xAHSg9tvGGWli+7XVrbeD30l2EzOZIGDzvUVdBJE7rMZpWHdXNYtNRMA7TBfXHXL1tcaapY6q6CSJfPwaDY5JwVjsoG4SBYE/ffYnct9MKIyi+DYGZGoNw4zxJOuOe/ILGc4kOvSvXgGa6EYZRMsXJY2VJjCxywCXgJVGP1sJsejiko2G8uNlAspA2eLBMdS2iIwgqkjPl/Vi57IvefTjxaZwjH4la76fJUePEKVAnTOBaPpjPVgXVpmkqv+xtFJZL8si0TL2pCZ/+62Ti4zSd8r7xzPuOdmOtDWwx7ltGMQflOqk858qgkj3sPobKF06JqEI6/mRMux0l/dnf5V9cfgVRvF3/2pP4hQlomrozQYSZNx7CB/xi185WNvImHrzkhHaNJy4rSg/s52H5yzjsW30TpC//OU8e1QThgxAzVlqHamSDdqEGCR0nEOoQFIQ
 I05MhQhV
 euNSB0s9UAidF/UqN5s6rNZ8tccN0qEFKsBk5aeN3chLTCehvqU44m0BmMMTrehmlz8Cwe5AByJAnKkRAgFfm1cwQBnzwCGTUnbJG/8MrkaG57VAyijkeessVAT7XDh3LhGPlKgtSScVQ4MxjiyFZNaQxvsBnpkdzgXw3bLyb2j8yeNV7DQjw1tuhoLnT2RW7MCyE3KG3QpdHVdYSr0eV4GXEwJ/Engj8pG2cft0yL8Z83spI0JC39zxp2/3VVyC8/3Wy1w3ZGIWA7SmgsvHmJmQYTptkQ2OT+gBq1P4yGKLWa9hDisWi4AaeiVcatUkQzM87cEhBZ1x+7iLVSVepoJ40sRmq8b8XZRPrC6AeK8mK82s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   a66191c590b3b58eaff05d2277971f854772bd5b
commit: d10bb374c41e4c4dced04ae7d2fe2d782a5858a0 lib: mul_u64_u64_div_u64(): optimise the divide code
date:   9 weeks ago
config: mips-randconfig-r062-20260122 (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/config)
compiler: mips64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601222217.uzed54La-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601222217.uzed54La-lkp@intel.com/

All errors (new ones prefixed by >>):

   mips64-linux-ld: mips64-linux-ld: lib/math/div64.o: unable to get decompressed section .debug_info
   lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
   lib/math/div64.c:(.text+0x60): undefined reference to `__multi3'
>> mips64-linux-ld: lib/math/div64.c:(.text+0x188): undefined reference to `__multi3'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

