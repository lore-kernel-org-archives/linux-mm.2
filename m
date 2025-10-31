Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB2EDCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 18:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89FC68E006E; Fri, 31 Oct 2025 14:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877888E0068; Fri, 31 Oct 2025 14:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765DC8E006E; Fri, 31 Oct 2025 14:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6042C8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:24:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDBDB88C7B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 18:24:43 +0000 (UTC)
X-FDA: 84059235246.20.51ACFEB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D8154000F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 18:24:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WWRzr8+t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761935082; a=rsa-sha256;
	cv=none;
	b=DhIV/XqnHLLzqz9mHeIfmYYLlbSJbwCCEqPMr8fhyDhLzFRwAs2wBj3UPDkhWFPPR+ToLM
	q8/pCaj9IbzzW6fQDo4RImMJkCreVRyRihpnDoofTvateUN0pFNdhpDY8wwBzb8xglrZRI
	6z2YKcYuwIpXC2yePMTwMu2VB2RRV4k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WWRzr8+t;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761935082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CXQGiBFVpf1k2tQdiWNM7d9He59FSkgsbDKsYSO+lxE=;
	b=2aAltUPZExD5axzJOEjZh5q1AmlT+X7DrciQSonT+ZxBG8TlFUHI29SuIhM6g3GvEoWdli
	lwKtFeM5D9EnFfZpVOW5acW5PFcyApXWHSDBspJHqlv8/C46qlmHTzeFn4ARFdk6SsmC/a
	vecebY35FKA2KEhIXcGAXNBxAz9M1oY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761935082; x=1793471082;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2espfBKaEXR9ooZJUhynsBbxbOlStZ/Y6Q0tHqQ8/gE=;
  b=WWRzr8+t0rdQz7T9S7DVWzT/+c5t1PwxJOG2nErZltGv8hteDuK3AqN0
   3Ps2MIO1Wzy3P6xjz61d7eWZjRd243JXpbwMSATlBehLpzhkdFyWf2rwb
   W+PTrwZMubuZupb16zRBAGEJmOeESj6J1SbN7/ED9SbCgYLnNroiK/q07
   YCvMV19rRCmo0+ACO0Cyzot5OIBzm3w1dhhXMcjVgkeaRlpl/jQE5E7Ae
   Tv5g+fSC6kYlE9V9bGqDaHfIaoRaLZmNiUdZw/cROu6RiAejSunLN9hPj
   TfH6gSh8ASoUov+P4zEya7ugtwGNVjw+QJ7O8MrFQcTgNzfn/2A/uP+wy
   g==;
X-CSE-ConnectionGUID: /TJtqixDTGKlebRPxIbyDg==
X-CSE-MsgGUID: TkX+NkNWQEGqQwn8ICrY3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11599"; a="64253552"
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="64253552"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 11:24:40 -0700
X-CSE-ConnectionGUID: KvGSivJ/THu0a+YqiyR5sQ==
X-CSE-MsgGUID: yHB7rlV4TfCiUP/04vgoCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,270,1754982000"; 
   d="scan'208";a="185986972"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa007.fm.intel.com with ESMTP; 31 Oct 2025 11:24:38 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vEtnf-000NYW-2a;
	Fri, 31 Oct 2025 18:24:35 +0000
Date: Sat, 1 Nov 2025 02:24:24 +0800
From: kernel test robot <lkp@intel.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: arch/um/include/asm/kasan.h:29:2: error: #error UML does not work in
 KASAN_INLINE mode with STATIC_LINK enabled!
Message-ID: <202511010249.7L7FB7IA-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: dxf5get1n3nd4t4gowawtcnj99tqxj8h
X-Rspamd-Queue-Id: 2D8154000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761935080-494214
X-HE-Meta: U2FsdGVkX1/ueCaK3nUcMTujp5rOZPqjkq6eclTf32FO0Tfv2C90NAA3xrKsWbOXGFyzwQ8kSv8HQjPkP42wbMQf0Ncx9z8fDHHPqBPN6LuHLdeM+dRbJY7ERnRD3anwuS3V3IpA6PBdFRwr1f4qrNLq+upoGbZ0NfN3hm8oIGnDxaIvfzZ97Ailw6kXn/+U5R2UFGDCthg+TbE8HT/MlyF4q2jmgy4S/qyvc3EbSDruBb+Djov0f6Q1aAKy7bHwyZ8xHRwRrq6P7Al6VCaqj+TGVJO5pzuxI2BSYo/vgbwoYc2wvH8bPOK8wjTxDwtuQyvOqglqXuVMSWo2wJJ+3PSBJP778pzttHJesQf50l6i7x2PSqDxIz5IajiIC7ZZdyoNa3xgnKTYLvu/o5ifQINCS1dSGJzD5eRhf3G1roYHpuHLhKJvpqH3i6cNSbsBSmALSaBldkACN3X4Zxb6vabDqsvIBAt6MZX7wnY8lKjW16K9NRv/5Eii9BecnOAjr0yxcms8Ou5Sts3ymP3ZVOzjPlg7gQ0ET7290ZOKOeTEwYzcRK3BA87u354GRYvnVBhCjBBcoLgu7bKEl73BD00WGR4nHL7/gYq646BptTAPtNJukogc6pW+EwfSovJc2UFj/XvCF00C0Ri2Y6WvGWECmxExsiJvUPvHM7pdVwaPiCcaWh608PsU3yYL8st4JWae6eezbFOCmFJJ1F1rj1wVW7UPCCaINV3InmYfmju0MUghLW00rZFHoI1NNeTeOO26qZ2fXedDPn9K6pKcDHzxgfHC8msSguPkyKj/8RLp24yxLfqI6Ar+Dq7gLnpSUxPZ8HbGH2wZ0Iedn7F1dS7akL6bWiwLowkpTI7RJdbkgVwhNk8VPvA1tKQ6B2bn+Cz8y/g9gUp6E4iFhKmlEYitQMFQETGsb+Sh6lwxs3NEmP+F2MIQfF5eEiKhC39X7EJJaNxe+2CSObb2ARn
 Vm92xAOY
 WyzPYODFZDhS5ufVlUdAspzAql1ZV+grtejStsHxMd+FcbzaIwRvUn6ux7/IZ+BdRB4UhNh1CGjjSRq7tKSGH0//K40Y29reqxhzTM4BoCabYxd8hMYJabhINVXt5bc45Wx55TELYGxRORSLTqd1qESHy89ukTy8XtfjAq0vYHTiaFHw8VfsmYHWFbBoBiR43ayqG7jlmQBbGtlI7WmKi6ZGxUS4WldxYer8Vfvgi5Uk2SQMAvo2pzgDkIuTMOBRNiyijAsrGJyp2sxB5i1/ngGUXrL5SrBcGHufQMcaylvgm6jP8NqQttnv8dAdeG+agPgBiD0z45zTol/k9cRykYGm1mz4RJ+2pVhLQ0EkrMIDozgHSIurXTrhdKwh7TXizvdkLYUc6twtXeKNI59DrgpmFbGH2RR3d1naGRoPC2WkQjkSKmsmzDgU+1rximT0cO+pAgl1HMQ8x+Z1X6Hw2yDY082is2tqULktzwVv26wETYhk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b909d77359b82821e1c6b6a3a8a51b355b06fdb5
commit: 1e338f4d99e6814ede16bad1db1cc463aad8032c kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
date:   6 weeks ago
config: um-randconfig-r052-20251101 (https://download.01.org/0day-ci/archive/20251101/202511010249.7L7FB7IA-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251101/202511010249.7L7FB7IA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511010249.7L7FB7IA-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/kasan.h:21,
                    from include/linux/slab.h:260,
                    from include/linux/crypto.h:18,
                    from arch/x86/um/shared/sysdep/kernel-offsets.h:5,
                    from arch/um/kernel/asm-offsets.c:1:
>> arch/um/include/asm/kasan.h:29:2: error: #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
      29 | #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
         |  ^~~~~
   make[3]: *** [scripts/Makefile.build:182: arch/um/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1282: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +29 arch/um/include/asm/kasan.h

    27	
    28	#if defined(CONFIG_STATIC_LINK) && defined(CONFIG_KASAN_INLINE)
  > 29	#error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
    30	#endif
    31	#else
    32	static inline void kasan_init(void) { }
    33	#endif /* CONFIG_KASAN */
    34	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

