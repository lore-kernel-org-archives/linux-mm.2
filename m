Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BCACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 01:21:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46BF38E0095; Wed, 17 Sep 2025 21:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C768E006B; Wed, 17 Sep 2025 21:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B498E0095; Wed, 17 Sep 2025 21:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD358E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:21:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5DA813BAA5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:21:53 +0000 (UTC)
X-FDA: 83900619306.02.81DB3F7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0ABA3120003
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:21:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/qAJ+3t";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758158511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL/CRPWC31oUF+ur7V+pUmTe9mvvwo6vPYfeJjk6t5o=;
	b=2hjy4OwCi7HrJNuQNjXwcm9yh20CftjfhQSzd2hOyCB1EvuvOSbqPQY8gtaetb0grWDpqm
	GErk2tFnZ9Kz2UXX4yIwb7JQj2ZdCqVFCNupz3BKhXu8haDhYCZW4AM4Uh6oAZoofO9D76
	gGnO/nOE+hzeQE9z9+2wmzsfVD7bVLY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="g/qAJ+3t";
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758158511; a=rsa-sha256;
	cv=none;
	b=JReZc4M43j5Y05ht8r54bAyujFWyaK8LxXwGuon/4Td2c7UE4ogNVlLw9WrQ2Hj5RPi8hA
	q0RezhpA0WyY+1zampoOot/Vktad/dJaVe2vrHffhxsrXT5128IXqqHMlnpyYab11oT8IE
	pSn2pNvqLgNC1KziyBYhF+LncNs0Tew=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758158511; x=1789694511;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Vy8OK5kJzvHuwLBFfSz7rPqR5X9KlVDHhZG5vHMcUIs=;
  b=g/qAJ+3thCP1NWep9visMhMbhcOOmzf4WiUCld4nZZtJYk3f3CvpBJT0
   uLpMq1d2J18v0GC47E0QMN/Fj4+O/yCuxtInzdfwUGNkY46u9Dah9Td4w
   juHfzSkINVFD0WO/sAN6monjFAeYbHqe3JCbcR1loupBi/1eToUWo63XT
   xt3E4stBKE0GZ3sy7Au6lgdALx9idcb5WE1BFUO6TQx5EJiYcbXo8HkaH
   H8ZK6OUfq2ep8BWkyJQh+gon1+ZGMkXef/MHoz0pG3EOPxQXXt0ComJS0
   ze/xVhMXmuNY59umfuFhDEY1gDVPX6PHB1mDsoowdnwhJRB3fZhFcuYjz
   A==;
X-CSE-ConnectionGUID: Y30p2ugVS7quyVRCP5t9Qw==
X-CSE-MsgGUID: 8hgn0JoeTM+TxY+k5B1SWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="60628010"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="60628010"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 18:21:49 -0700
X-CSE-ConnectionGUID: 5pkUIZn2Q/6Mbe2PH99Gtw==
X-CSE-MsgGUID: wGtr9egyR3ugRJzUk/HTmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="175477862"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 17 Sep 2025 18:21:43 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz3LA-0002cJ-1Y;
	Thu, 18 Sep 2025 01:21:40 +0000
Date: Thu, 18 Sep 2025 09:21:23 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net,
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com,
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com,
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 03/10] kfuzztest: implement core module and input
 processing
Message-ID: <202509180855.TT6uHpiC-lkp@intel.com>
References: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-4-ethan.w.s.graham@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0ABA3120003
X-Stat-Signature: zmyy3fub49koxgjuersw6c7m4d48b88t
X-HE-Tag: 1758158510-556230
X-HE-Meta: U2FsdGVkX18WZD31KPP6tdCEOOc3IdlYJg5I5Pgl1Woa8X1DfSQFZkfDVqVQsoiboijrKQNDJW9rd4+lZTeDXdcalvKF5gXew2k5ZmSUdTZFhnbKPBNECJOaC4zGoI3WehKIcrBj2jJvoEM+WH8vlWCb8Z4KAwWfWsCf1deloby7SRPKPFTx35F7Y0lL66Dr2+kwLrkGOqrcY0dZnk/pWq7PV4100zHqoKE9TtIhdLrFG489S8hkiRVeqfp3B40PdD01Da0cNsOrtqGIkXrM5mH4xOkvhNMg7MvPqIBxocLnzq5BorrQbO9d99gL0Q8Q0s/8TUhChSNympXmjPZXiR4FQgIvaZEjMUJjd6GHuSPcWOK4wi06Ui8ZiwFzU0KBT7s48IzndkvqsINANvtw9KDQQOqfZW1wIcqH1wsQiP22ZBKFMragKaIDVDiaJqINR9yo4JENtdb4z9LNLdxHuVEiWTT977Mu+WBiOw5EJdlfHdoMkZcwbjrBjq1gZfIau3bVYNzNXXFNYrNaPUU58Ppef4sBXN81RtAirnZuDIjb/x8Gdq9kJftj2a5s0U6issuVfUMp+h4pJ50/pMoqpEEVZrsE8VmiLr5Czf8XDRSS8nN7KnYxoqywO8SDf3kdoQPXCq3oxvRNozmwwKHfeM217JeAeVmNir2cI9MjV/ft9Hpe1QGMEdey4abdbfsVa9OTB8E0UyrzJ6gx1+v3N/gDMZbsc8NaCHrt5fAR87Mrs+oRu1JdDuz7Pgp+vugDUJ/wtl7LSupQhRASCoLF6WntMRWqRrAKLErVkoACrhU9PQkcYEZQ7ky6OwyEBwfY28FJI5dwL4lbUZpHuktD4zqfPkOgMApFY20KR1S/OzN79qzYMlwOJY6kG08w9KzA275n4Gu2VH2qstzFVxyarb6YxjE6z8Q6Wm6dx96agFmOXdtoTHdKRhdBgqMi5QBr
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
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250917]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-4-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 03/10] kfuzztest: implement core module and input processing
config: x86_64-randconfig-r112-20250918 (https://download.01.org/0day-ci/archive/20250918/202509180855.TT6uHpiC-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509180855.TT6uHpiC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509180855.TT6uHpiC-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> lib/kfuzztest/main.c:65:15: sparse: sparse: symbol 'KFUZZTEST_INPUT_PERMS' was not declared. Should it be static?
>> lib/kfuzztest/main.c:66:15: sparse: sparse: symbol 'KFUZZTEST_MINALIGN_PERMS' was not declared. Should it be static?

vim +/KFUZZTEST_INPUT_PERMS +65 lib/kfuzztest/main.c

    64	
  > 65	const umode_t KFUZZTEST_INPUT_PERMS = 0222;
  > 66	const umode_t KFUZZTEST_MINALIGN_PERMS = 0444;
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

