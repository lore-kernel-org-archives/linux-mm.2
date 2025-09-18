Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B12CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E838E00A6; Wed, 17 Sep 2025 23:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F798E006B; Wed, 17 Sep 2025 23:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77498E00A6; Wed, 17 Sep 2025 23:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D56568E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:19:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6D10A1A0785
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:19:05 +0000 (UTC)
X-FDA: 83900914650.21.0D2967F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 98E24A0006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:19:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HT15zk2u;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758165543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQg4VOw6/IdS7zCdlkkwiGHYivVni7H2YH1AE7eKIJ0=;
	b=zXC9Q2E9F6dQ6Uavb1bB0gnGu63F8X1LqrOR4eR0zBOWj05VXQADXNEursLIaUmtggWLUq
	Tm2NVWNka4q6yCFJtw+avRtG2JL9btiB/JHnQeiKMLN8Be/OVdhGCwzpDoaKYNF6hbsZQg
	iWgC0YuiVimkvVeAyn7wNFHdaa1Sato=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758165543; a=rsa-sha256;
	cv=none;
	b=zf++5BCXB1uVvv3AErA9cB9K37kWIUzuDt31hVlG19uK2sjIToY5MQJVnIZjFwlpga/HoJ
	56OMZySfROmzPbgOMB6+oHmNPp4wVy34adPZeWu2F4gwjI68i0w/TEPfhDrDueRESCEP/J
	gfB2Au3fof1Wdu6OUuloeMWu5jqFb2I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HT15zk2u;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758165542; x=1789701542;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F5lh9XX2wr6nkkLJ+ixkgrNSuR5uHERQJKhZx7YZtOw=;
  b=HT15zk2upXskmw0bS82X57RLKjEjuG5MrcU55wsVBmhzlUYtzsxhSBSP
   BmqxoHHRpmBznmPxleUVcSa0h3gu0cDWNFbWJ+JjaWVpWLFVeLqGGZd2w
   /H803woe0ZEHbvuwVxSbmAQGHf/XOroD5VKMcAA4hyOs0rKDHHqIHWZFM
   UBfbJ/FRMc9pZJ58Sq3ZKHxfNw/WRGkZMBYQFzVzPlZdA1ideqBzNfhnw
   wC/vlzf+YrvrISVVuV0wUzL6/BAKf26GRrZmWBD28HzQ8M8OHtlH3uBjE
   Wm2uG6fucoG6TSA/qNyI+stb6Lx0DlhKevhbgtkzqflEaktOOk6PRf0/z
   w==;
X-CSE-ConnectionGUID: DueO4pCkTpeWHjRxk6hdkw==
X-CSE-MsgGUID: 5y5wfjiZRXmO6TGp1Gzs3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="71166104"
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="71166104"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 20:19:01 -0700
X-CSE-ConnectionGUID: 3G2x57egTrGvbePk9Tt6tg==
X-CSE-MsgGUID: VibjPdNIQKS4LH6sSyukmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,273,1751266800"; 
   d="scan'208";a="174709563"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 17 Sep 2025 20:18:55 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uz5Aa-0002hL-0s;
	Thu, 18 Sep 2025 03:18:52 +0000
Date: Thu, 18 Sep 2025 11:17:59 +0800
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
Subject: Re: [PATCH v1 06/10] kfuzztest: add KFuzzTest sample fuzz targets
Message-ID: <202509181042.zCqqD9To-lkp@intel.com>
References: <20250916090109.91132-7-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-7-ethan.w.s.graham@gmail.com>
X-Stat-Signature: pzi3b1uzkn3wgcat15ycjn6nf5y4jmbd
X-Rspam-User: 
X-Rspamd-Queue-Id: 98E24A0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758165542-115116
X-HE-Meta: U2FsdGVkX19txScAC7EgzVGrn8F+BYaWLtT732U1GmPdDxxtlN2XmiKUnzpUACBLsTiOTyCCCy4+o0qWcSSdAKa+NzN+lofB1A2xv+2BTKjY7EjZnxqwFYZggsAj5t1jcdfKSzXcn3ufemvsl0kO0BLQOKVkews2KZgwIJljCgj+pAKaIrbYGkGsUJNWk+x2mipHTvYwHeK9MGBSVv670Bxku6vjiDNhvSAQkBZoXhS0dgLNnKmwWcz2Z1v+uMbBMhf62M9gqR7w3kvxTYFrSSXdwjkm9+esJwsQUU1+VCQSanaqrtv5sEnwBA3qs+FJ8ny0EONP69nmzmkwKINbEH0LwoMsR2z0awy81KVWKwES3sBIpR0Pk6XATJwnmjytMoMYqifBWcAOOY9/KSVCd0X/ekw2Bn8axhP7htW7jSKm8a9N0WyjBVFdLD9TRx6Pise3y97KFoz4A7lxcO2SQxGjtJjuQVQAdwyeXTDmLlJoaD2HD0IxUNZAEiA3Re8RXTIv1ndM8WpXPFCjZYDmyF/5TqNIv+wbd9Sg9uOiiGZiJ8Y9ZiFTXMbfqfPfgm2+4sv+prHkH2N0EpoWcVyTFtQXSjUtc/rEMMqLEkNzYU3cA73zk5dAFmUIG3221+UNEa6HauVBPxTGqH7Tf7DcXmPI3EjeuLVNxT72xUG8ePW2FAfAT5E/YdXpN/dV03fpvdIOnpBElkzcRVrdGH511WglU7NhSCDSn8MYx7ANWHgfdsd6WBb/Y5NwqFJxDdbn2zmjrY8OMyMs/mvhZ5kQDZUgJ6aSkFLa56+lIC37T//WhA9a8QP7taugrepYZxtPIOpzbKWUMc+7sx3tTrQA+Ggogdk7k9q/1MOfnl23d0TPKjY9ldeP1U6e94NpWErEyxcn1n05QgqQCVG+P5tF5JRPTaU+92/1bNMnBAAJM52YcrPWCx7NxJ27aw6R7Ip1fGLq6fk4Kzq/JjpadBe
 IhQ8UaYJ
 +iIPi5x6xnMvX6lf1kq0IPjBzLoAVFJZSaSASR97dP31iR384cyI5sf2OCwahoDZWF3XSKpuNV6rq4rU9tpaFzGV1q6GhSw9CmjuE+DsSLvDdHTG9YHGucQhOn6D5bkPysp6oj2JGQPYP5R0Ji/PpNQhHNM85MexOvKJI8iAE2lI/qS8XRen/n4IJxj1e/scwWccBrbocq/yaIDHqxlGqGhAAx1vyuGVksmOWOJ0d6q3/SBcZIhtfoJ8OBEACK6UEzUYB8DwQ0qOIXoyj5moVPJaZRrj+OA1Nic9CKJc2pXNz2EEimDYTX4HQpMXtWp0JYQJEJQ403xRVwn3HFKTFDA/vBaFQncico8gu01pfIItP1O3Mg+IbsnBqhB2hhsZOANrtm2NckLqWnAUEkyYcdb4pN2gxxL4CimOgdVd3JavdLx4I7/sGzyKOoRulkRIbVpsR
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
patch link:    https://lore.kernel.org/r/20250916090109.91132-7-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 06/10] kfuzztest: add KFuzzTest sample fuzz targets
config: x86_64-randconfig-r112-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181042.zCqqD9To-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181042.zCqqD9To-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509181042.zCqqD9To-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> samples/kfuzztest/overflow_on_nested_buffer.c:63:1: sparse: sparse: symbol '__fuzz_test__test_overflow_on_nested_buffer' was not declared. Should it be static?
--
>> samples/kfuzztest/underflow_on_buffer.c:53:1: sparse: sparse: symbol '__fuzz_test__test_underflow_on_buffer' was not declared. Should it be static?

vim +/__fuzz_test__test_overflow_on_nested_buffer +63 samples/kfuzztest/overflow_on_nested_buffer.c

    53	
    54	/**
    55	 * The KFuzzTest input format specifies that struct nested buffers should
    56	 * be expanded as:
    57	 *
    58	 * | a | b | pad[8] | *a | pad[8] | *b |
    59	 *
    60	 * where the padded regions are poisoned. We expect to trigger a KASAN report by
    61	 * overflowing one byte into the `a` buffer.
    62	 */
  > 63	FUZZ_TEST(test_overflow_on_nested_buffer, struct nested_buffers)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

