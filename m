Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D79CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691A78E000E; Tue, 16 Sep 2025 23:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669588E0001; Tue, 16 Sep 2025 23:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6638E000E; Tue, 16 Sep 2025 23:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 490228E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:59:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5B0D1603E7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:59:49 +0000 (UTC)
X-FDA: 83897388498.26.ACF0887
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D1CA40004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:59:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DBelvs2+;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758081587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxH3ebGI96ZajPSG4F/6sPmWjW4W9BFD5gYTw4M5JDg=;
	b=wkQEas6Zg4VnjtL/MOc5yzzW4H1fcgI4SC5ug0TSC7oZgKhuN5MfCs28Lo+ewdnTK51Abf
	BCFAt3pQtUO4PRNqEFnk3jT0HRJfuJmnAGvbtKyPJ4vFvbb5DKSFXHyls7egp9uv0jbxbx
	MeUqaSrhC3fjNsNSR9io+8wuheNDDvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758081587; a=rsa-sha256;
	cv=none;
	b=oZji7jFG2/i11R94/YdgJEW+juIuNhol6XHaYoeNvM5i/rcOUxMKFUV59w5pmjccHUVl7a
	9+aUddpCEVufYEmEY4CcAjKomePSinlWTgm3+O1JfsDXWF9DDoE+AGRJrWpkWzcMivukk+
	Rwjnrp0QR3v0OpCajDZG0uGLYq62KaA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DBelvs2+;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758081586; x=1789617586;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H9thyNiLTdBDPl30sbess+15GJm36k6HegAlHIfWnHU=;
  b=DBelvs2+fS+ZAGbH8kAqbpxPFhJGtjk71UoA28vZSiSbP7IwWWMgNIFI
   huYn7ORuvDpUP64HZ3IeveXv44fizWvx5W2T5Np2/qny/s0ITxI+3tjo6
   qbCbITWXOY4pwEFhFZ8E4BzBxTH2GWFRNpQ3e4JCseIyz+p8YOl9n0/M7
   A4Zi4+bCXKJ98S75cd+BbcxIvCCA35vKSs/nszHijM0lYcYPBbIXDjN1e
   4nnxZyMfzsh5E0Iku/CadTJtaCaFOG44qTWbWqiKzRVXjHGqU1ux+wQMM
   mJiQ8ViET2f1Jz8j9ca65S96YKDG8kh8+TpMsJBUrKFIcV1Vc7zsp/vYp
   w==;
X-CSE-ConnectionGUID: zGI7xWqiQs6bSk1xZYXpoQ==
X-CSE-MsgGUID: H4owiFteRIeO9nhj1ZGXnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="60305014"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="60305014"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 20:59:45 -0700
X-CSE-ConnectionGUID: 8r1RW9JuQCOoNSWzEvSMaQ==
X-CSE-MsgGUID: 7cId5LfgQUu8YUrX2ncqBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="180266969"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 16 Sep 2025 20:59:38 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyjKS-000127-0B;
	Wed, 17 Sep 2025 03:59:36 +0000
Date: Wed, 17 Sep 2025 11:59:20 +0800
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
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input
 processing
Message-ID: <202509171131.vod7tLWH-lkp@intel.com>
References: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D1CA40004
X-Stat-Signature: 5ppir95r6zirn8rk54j8j4xc9qwcuoid
X-Rspam-User: 
X-HE-Tag: 1758081586-925414
X-HE-Meta: U2FsdGVkX1+rIDaVKxZQNU9KRzcRPYCy+gc8mzcesyz+YVw3wVFXoLhHFL2Kjr3olJX5D15fm1kbw8P39jLsIEDufu1/aG6sj4GiAHAxM5Js5v1TUeSbVgLyB21RopnEXOHa/rqBqfqrxrKxv+ABJwzJjwS59gYPc2Husaq259lTTQV0sTpmYbPJ3+xcPR9UsGbi78IWg4uN/uyCmFuk8ZovbY/J9Ilb6Da+MbVnqY7MBtJqSIvuNYmkLiyvC40GoriH3Bxq+BI0dSBxFdbavW2Rd9bXhXFiRYV26vkr0LiuVoTlmMoDJZzAgw3UGwwqBMDHF/+IW3VkhInDVpo6/kywxAbZc8ztfxN8NbFaZtKmPIT9U90rdG/N6Ui++/idUn7jJKpqJlGa5fmsDpMBYUlHUxvmLXW1ctJhp/ei0wGbUqr2EmPgGAl7LxP/C07CjHl61ZuFCmduViWDgol4eoijQVsh1klB8j7Ax2FraMyr5EqMwu9qekOEqZkwL3QPm5ecVkSBpH7zPq1EsA3u0GEBYWzke9Ab38LYmCbr4DLAd44uQLDVwm255RQJsCD+cgrCDo68cWwwT35xts7m2rg6CN1cb8WP9NYO5WPrb0Jgzj0pMjKhuACMi6CBSLL4JIWYU84Wgqmc4FHOVZK9n3I4oerFQHoDR9eT490JI7o5Lu5Q8QKaJcI8oqBlNOQbCTFsnJVyJbPVgojpnSSnb8ACuu7lFfDq0NaByl72mfz9qKqAAua58kEnHAAeftZICydTs0IuzAonee21alzi+locAMjSe4XmpX7cePyI4AA8/rbBTaBZsChb10sqHBOGhASGdt8Vk1DOW0f2ku8QbbwES9KkBPSsb2XttYOWG9phZrbdeFiKr0O1WICHJXlLAhRDTSfKV/l5qrrEb7qJqQ3nVDPCFpD218tqjmZQn8KSryXZyfo2YzitvPTXaRQzn7hKDAdFUfa3KeuwUJo
 mGQVOIHv
 79xJhRDWkm1cGKGJhahM4Yb4JAu6ihv01MvNGMlakkPSrsuzqNILvTwyEnTra9gSBN1AHWRDBTMQjCD5/SC1hcPRuwMwLZYBoy3ZGF3bnYzobvBeDPsorW2aDaTUGyluwUVySdn8hNTs02TxicOuimQ2r7hZRST8g/JSNiaGV17E2WoSictiflEPOwoYQrB8q56e2Nv4BpBdbaEQ4mmORipAtBn+T48Vfeuq1lo0wJjbqPTd27b3XCDwG99u5H5chbIjstaIkdpp1WqSGRKyIY9SaseK6GzYXY3xAun2VEDbZD8eBu5lCaM/lZBcJRdtDLFfuZB+K0H/l9m4LKNQIzwayy+ud5GzPy6DFBcUCYQAE1dBuhwNulO8mdbGIg2xEI2OFRwWp1LWWPvNTptwnPhaqm8E82xcIL+mpM9Iv7B4hIj94MWb2sAuSNX8MJhk4gfDz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-4-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 03/10] kfuzztest: implement core module and input processing
config: x86_64-randconfig-004-20250917 (https://download.01.org/0day-ci/archive/20250917/202509171131.vod7tLWH-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250917/202509171131.vod7tLWH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509171131.vod7tLWH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/kfuzztest/main.c:46 struct member 'num_invocations' not described in 'kfuzztest_state'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

