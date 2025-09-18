Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF708CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2D08E00C0; Thu, 18 Sep 2025 02:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E737F8E0093; Thu, 18 Sep 2025 02:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D897D8E00C0; Thu, 18 Sep 2025 02:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C817E8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:52:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60A4313B3B8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:52:27 +0000 (UTC)
X-FDA: 83901452334.19.710784E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5197B140007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:52:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=htshKVTl;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758178345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaNIHYQ/DPl2MmUXlucY+XCYwvRuaIbPphjKYBOBrbc=;
	b=tCdZpnaKrTKHE4bajXextqpdDopnEHFRCLGA5YhucbES0dDDRW2pxLiO1bfIKKy3Eflmfa
	uhFWze5iK2azURsXHdgBsg++Jufo6eBFhaqRvtBHp7LvuBTWLhPGojisSCxtYjkR/9hn4A
	UbzeO5I/gEuVe2fsVKcCioQ/X9rcwoA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=htshKVTl;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758178345; a=rsa-sha256;
	cv=none;
	b=MrUy7b84nIac4u61inP7aYZb2UWm+XFC50thXlmMHez2fxL/fBIu3C4gVGcEimffAVIl4x
	m9edf6qgZXvB8SucrheQH0WLsbf30jvPnvCoShA3wkaf/NfVyKw5nsXXFlOTnWyevWxBtm
	wYQeYDSQbM7WMhyRDp+rWjpVe7rcJrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758178345; x=1789714345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8guvnPhfYkC4UXz0FVHEuKdw/NOn7dkFZfu4xpqkqzY=;
  b=htshKVTlEl5b66i6oTZAIq0UE1xu/p6Ni8AK5Oz+kPE0btseCDoeyW32
   jOLsnvIkzgYZU+D5aVvSO12W97a3cXotXNd0yMKDsVp1R4G4xkjTz0JgL
   Yx08MhgMsbFt/IXWU0yjPg3MBUSdgrVYtuEl6jo7gMRgFNe4PNsrBGHwf
   +aemns0xSBC7qXgQVgtSTd+ShCbn5V6/4bLzLBTJGFxXSO58JiIYUxosT
   7PhRFcGAIUIVAQion5uV/3F6DLqtd7q7MX787bdNBvrlp5fuBIXo90DaS
   FPmdOH5MmMGvN99BhimvAXh+VckxV1pNbAPOnjUwl9oPsJb6NVOsRsY2E
   A==;
X-CSE-ConnectionGUID: 2ZQMhYKlS/u46XZaJ6A4ag==
X-CSE-MsgGUID: 2paam2bcT2iKt+/xUS+/nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71925021"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="71925021"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:52:23 -0700
X-CSE-ConnectionGUID: Yc9nWOABRheo1JBzKZ9rOA==
X-CSE-MsgGUID: t2vfJQZQSTmlR2nJnRGstw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 17 Sep 2025 23:52:16 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz8V3-0002ql-1m;
	Thu, 18 Sep 2025 06:52:13 +0000
Date: Thu, 18 Sep 2025 14:52:04 +0800
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
Subject: Re: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7
 and RSA parsing
Message-ID: <202509181410.XN0MIpCh-lkp@intel.com>
References: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-8-ethan.w.s.graham@gmail.com>
X-Rspamd-Queue-Id: 5197B140007
X-Stat-Signature: 39mdpce1eqgw5cjzknk6khqgicu3ky9j
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758178344-984523
X-HE-Meta: U2FsdGVkX1/3Kodw5ZBA1JV480XDqfKVv3wVcsbZXWPhMzn3MWlrgNzyXpGiHwno5UhP9fRg/XhuC3j6zrc606r65QEhvv6+DiG8U6qmvRjXYc9fOyQ8faGaRWTkIuDF9tvhPlDPMskezHJuhVwseEUtlDPTfbv0esVElWFanR/+R4w7moZvDDbNF4+aWLKdu75De1wrCJHRFpjK3mgljZZUAhRm9/L3/KuEt/D2XSRVtGN6E2jdp53egFCpbr7pTd9PnWxwfw4eMJUqm2x20hk39mzZgLr2tWoJPa73WqYiBsQwS4v07gMN8+chV39qBHMB6400E0FQxlP2zl2vtfqWi/543/SbwnZr40scdCWYQA0ACOJLBw9QL1BR95q92ScuZE9mUyJ+VBzBmYwJytyeDh9B4kL0qZ0rcJtA3X1Oq8Vewnjwq/8jxjONIh43y7f+jJY4gdonNKoWhWNblg63WdsBGE4IiC6NGe9Midalcu2ZJvq6APkFprwmQ5RsCMXichky0BmxLlhozrzQ992FZHq4JEUOqcAaK0yoDsobeFMS5nh2ZbgmWn/K/Yhnz62xPSG7trZgrqfOEHUjdapR0z/r4Alv4M7J6n4H0QS9uTyusC71MJOv/GsMdvdngg5T/BM+xyyIN20jbmCi4IsUWlitg50yufm0Oey+8K8aOZ/RffR+evETNsZNEpVNSbtoBye39iFRwJ4+Z8B9XFYvkWFv33lY876Yd7m1DjuBDgNmiVkEVO5kZP3wolzKj8jvISAqmyX9MJy/UVkR2/rFPxHieN8F+OUTeKW3fnJbP8KPJgP4E0aiPJI15xxe+e3hXhb/DpGEfotPip8xvL+bLOqGUgkOEKes6odYIJTV0wOc809crBwx5KcAi/CbFED5IUv1/5AlR5bI2NQw+TR581/wZ5FaCG+owrZx6s6cr7fR3OoukXwvNtD1qNyBCE/p8th0fVqSO9PrnT2
 fpMH7ErH
 6jCAQwcU7ymlBNBTZswU118riPfVcE6jYlQluY4QkDzv/YKfW5U5Pjjy7FD0crTFDv55/DLooTR0Q02GcLW6iwqSzt/+i7xfQuu5Bf2GdolTGteQ9idSMO7e81s2+TQmsULhB2M0VbumKvPyWU2RuuU2bx/uKvC8Qrt/i2mVFboIZHQsWQ32Z2ncUfRZzim9Mp7yGs/s//wKO4ivuK9ycEQ09fvU/ENWQ1ygmEk6nmp+VzVIYa4PjNKpaKnH6G9Db7SFRQ8WIjG+YRvx1byUTEQ4VrgcLRIykN+3OTcbIYK5HgZB81HTpfM7PVr/IBuqOltn1opH/61EIrYLHIlGnSbwjVM7lDegserlTrx9G79JpjwDKmo/mbehUI3jrH1mNlY5ugy1iTkIW93XO+sAVy/yRemrQoN/Xfs9SrBOAQ9uDe+EQ33ZeSoRD7bsBrhT7ctuI
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
patch link:    https://lore.kernel.org/r/20250916090109.91132-8-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 07/10] crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
config: x86_64-randconfig-121-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181410.XN0MIpCh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181410.XN0MIpCh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181410.XN0MIpCh-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> crypto/asymmetric_keys/tests/pkcs7_kfuzz.c:15:1: sparse: sparse: symbol '__fuzz_test__test_pkcs7_parse_message' was not declared. Should it be static?
--
>> crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:15:1: sparse: sparse: symbol '__fuzz_test__test_rsa_parse_pub_key' was not declared. Should it be static?
>> crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c:30:1: sparse: sparse: symbol '__fuzz_test__test_rsa_parse_priv_key' was not declared. Should it be static?

vim +/__fuzz_test__test_pkcs7_parse_message +15 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c

    14	
  > 15	FUZZ_TEST(test_pkcs7_parse_message, struct pkcs7_parse_message_arg)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

