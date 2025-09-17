Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4B74CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 23:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132DA8E008D; Wed, 17 Sep 2025 19:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3818E006B; Wed, 17 Sep 2025 19:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F13F38E008D; Wed, 17 Sep 2025 19:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DAB938E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 19:37:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 72D2A1DFA1C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:37:44 +0000 (UTC)
X-FDA: 83900356848.13.AC59FA2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C9F2140006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:37:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZGsYgqoF;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758152262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5u4mbrkttDZPXylDQNMtBldz1csoAOz1xispqU5El4=;
	b=VyzVbT1rg5AEvC7KoNy4EV69/MYqHroo7Z0nYpco6wQjgkoBGIRzLymoUu3EZenqLoWSZy
	ZUWZbf3tJGL0KCFcChU1pEQG8GXcoJJqH92gtlIbNtF+A9xJxqN4uEeASXsDkBrYq2/vc6
	4UjZ20AY0JZqlDo1D+So0oePpnZhtPs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ZGsYgqoF;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758152262; a=rsa-sha256;
	cv=none;
	b=uo4tL5+do7+EZ4+6baz3PUiLkl5wDwDFy9g42mVYyqJuC4AfMia6WwDTLU8DwlOYJh7U5W
	gI6uZyH2f8dhuVfRa05iq9of6znqKSiFZEVkIS9Oe+mvBSRvuZIuBDq9bznZOFKYvOS7WH
	y0mQx7uNH59GF1qyCPUabsT3K9oi9ss=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758152262; x=1789688262;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Tm7LDGQYbF/5OYizYxd41PtQk/zW0KgP6XlgKNQteR0=;
  b=ZGsYgqoFZ2X2DDtjUgDAp1X557brU5eelXIzRKzXbXswUlG/qLJEjW19
   Dptf/Z0nhZHGLpTCll+ncWjO1c6iqjahO1ekBY6cv7HOu2tHbuMvyBewF
   6yYLtRQk+68L3ow6YgoyrjilthMOD9kXkviKPBOEJf/kk9IqQXI5VyIZu
   /q6SE3yN/4y1Vhn2wi4U7rabMZYH7YI5fuCxEjirvFm1CkX+qcl4DQbxJ
   KyHaU8BX6dIB3o4ZvziwP4R/oBjoOgj7YGkAAGZM8I5GEHo79dC6UqPKl
   R+1XcUuRZrVVbaFfg3TXVPvAm8uPNcuELeeKfpZMjLGqZeVKpdN6BOjUc
   A==;
X-CSE-ConnectionGUID: GcQTaa/6Sy+iMHTkEMUQFQ==
X-CSE-MsgGUID: i9UZ35AqQ+23SvzSv6dc9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71576753"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71576753"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 16:37:41 -0700
X-CSE-ConnectionGUID: QcxZYuG2QOyvuJ2rkRherg==
X-CSE-MsgGUID: 5O/Z75r0RRWd2IesMQAMfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="175779636"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 17 Sep 2025 16:37:34 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz1iN-0002ZT-2Q;
	Wed, 17 Sep 2025 23:37:31 +0000
Date: Thu, 18 Sep 2025 07:37:10 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <202509180721.GaBOMCkp-lkp@intel.com>
References: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
X-Stat-Signature: p1ekmriocs3txm1xu46e48wyacomijmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C9F2140006
X-Rspamd-Server: rspam04
X-HE-Tag: 1758152261-708803
X-HE-Meta: U2FsdGVkX1+HDpC7YotYot9dogm+9upnFT6yFkuRd0n/FP5nBMddcH6+bufM2Xv7tKKTUyBw+Yg6xzR+5ojFYZmFC7+oYn59LlHeYGVZ6JIgGrZmZn96WCGd6L7UVI9IyFp8AwCsmmDKMfqmaIsMtN8n+EWD/j+6YwcEG6zx/AJM0d20IgdKj3ix5cMspdBohjoxbY74wHxypf540+k65+iC1Ye/UamTaBqpiZQ3EJTo6fy++uubjlOYCtV9Zo2xQFFpA7+eoW3m83I+EhHuuxr/5xoPVYKQAZmCXgdL+f7aZihmk1kculRq4faEcJ+TeB0cNhyk/HlINiH1ccfqHrEzvu50ciTa75Bgr0ZoyNmZlhczdpBnrsDEpWPDsYKsUI3027Ns0if52yuAvBcblaTz/Lw5bi+ICwrmfwiMYWi65dp9ciANESiQkQHKKPhAmw+3+3UhAjaht8RIw1QYwIHb/weVSlnZjKIxVkpJ3JUIYlROaIqGnPZWPR/f7IqJgxVbm//1l8Q6G4JC7UgszblHGP6vkoqGiCe01tOjtEknFqpMMv6fxOUOD9lVQp3PCgw2zp/sfUhPEQO5JZKMrBqr5kLQ511ADGEU/EdmJ2E3wDu4zK47bM1VfOjIWDCU3o2GC11dSPJEYICpCRUY6YLR6wSbHByVg7tX779cRaX5YqmIUICoGYebLVvq2Bdjf9Dnpio062iM4Iab1qUsRnj6WcPk/vi9XNVl4EmuKfOjLCe+q0XGQ7VMrmixE+nPVEQLkMPIdoVy70zPelOyHooIhqBTKZwoCNvfWaOTJBD6KUZInQ3uHMwDPcp4Dg+dYecuho/N46A/7vfxp5onrbBo/gKL2pCMsZMrDlNcaKiizUCWT8fX9vppztIWYRJZStKF/ajfefFPSyvX4Dmi9iGVPqiXavu6a6cNUyFoUTpnwatPZRbAY3pB3LITuGVguGmK/SMW2AP/xaijDr/
 AbbQ0h/o
 b3Tvu3ez7YPGaT/zzFwWgLi/vLVrb0xqg7REa6cfr6qQWv2ZFu9Ku74pjmS57RwuGk3GjqjTxEMTxGOtSaIoPiQaDZOob4PPXegXVecSUjeCDYOyjnCETDlA2R6UgSPmNrfzKic4DxtDyPHHhZoA5U6uYe9XaFew+xsz+o/7fX/Kzm+JD5WmFcAzkfbfCmN3X87QDkzNHBt7JmQDHW4lIJqB4/umnM5KD9aF0PSsolepuUeek6QDzR/jdMZJuRKJ/aXk00l52UVeI8qieSwktqD+UDSu8IsEMYu3gAir1pPWIiNRqlyD3YyLHRQUG68jdsq6zZ9jGez2Nnmf6lVzod28w+lXMT3OCzBOliRyDvFbJnzzgCwyLUaXYJbidvv8J8PpDTY36BrFMaBTNfuUEc1aHqN6wcre6TQyXSWmW4ieRfs+dQX8XsorriJBJZkToL020
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-8-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
config: x86_64-randconfig-075-20250918 (https://download.01.org/0day-ci/archive/20250918/202509180721.GaBOMCkp-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509180721.GaBOMCkp-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509180721.GaBOMCkp-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: pkcs7_parse_message
   >>> referenced by pkcs7_kfuzz.c:21 (crypto/asymmetric_keys/tests/pkcs7_kfuzz.c:21)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_pkcs7_parse_message)
--
>> ld.lld: error: undefined symbol: rsa_parse_pub_key
   >>> referenced by rsa_helper_kfuzz.c:22 (crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:22)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_rsa_parse_pub_key)
--
>> ld.lld: error: undefined symbol: rsa_parse_priv_key
   >>> referenced by rsa_helper_kfuzz.c:37 (crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:37)
   >>>               vmlinux.o:(kfuzztest_write_cb_test_rsa_parse_priv_key)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

