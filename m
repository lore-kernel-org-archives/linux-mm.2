Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1C4C55838
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 00:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95636B007B; Tue,  4 Aug 2026 20:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46016B0088; Tue,  4 Aug 2026 20:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BBF6B008A; Tue,  4 Aug 2026 20:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69B376B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:33:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63CD780329
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:33:44 +0000 (UTC)
X-FDA: 85065342768.15.E9ED209
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B9C4180009
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:33:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZsAE/KR5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jic23@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jic23@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785890022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jf/xVNbWPols23hslUUwD7fcUT/RrrsqrpMbZwK78iA=;
	b=2efhhb5ZghZai7BtDPDG8hkS1WBKgiIzBB8EjhQN6K0AZpsm0GrsGumOLG0Tw8S6RpdxsX
	6L3v/e/5pAvrIMERwlnujtAG7h15BTm2OT9g1cD5rZH8XPmiGvOEuhMpAYZIkruH0uf403
	vNq3vcbi8TDDHm/+6TyjV8Pj/1DA97U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZsAE/KR5";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jic23@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jic23@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785890022;
	b=EaYoW7hFJx5AiTBJNHr+yTwLraHM26OkUzfgnIWQg1YZ2zgfrooLFOF+UFwcUPy2h2+cYR
	lzW45WaoYRFyws/x0cqHm/nIKnYX8VMfYOyNKb9AXaoMfAmfuv/RrjUFcKSc3ujXMNFSwr
	DFqRpBrt4e2VMTsd622WubOG61dlpD8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5FCA40D87;
	Wed,  5 Aug 2026 00:33:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8461F000E9;
	Wed,  5 Aug 2026 00:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785890020;
	bh=jf/xVNbWPols23hslUUwD7fcUT/RrrsqrpMbZwK78iA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZsAE/KR5jsl+73ewpPJ90yFlmGYeO7a/wU07gbrHhMBmdf2F7ePh3+D6jz4/Yvg+N
	 675vAD3SbnXCak/e6mSmhMiirV3WDfNQEA2LDct1FWFIuqG+MNwHTbruXgTZbbWtc6
	 MjuMfKZ/wyvQ0Kd+VFExQUnJyMNZ31FnnYVilc6wfpN8Y6QapN+M/XcDG3My7JaY3S
	 f0NwSVZ50X7wH3OHI4nJI1uCw5K+6hRv/gDBJBV/KvkvspNC0xGWkbGohBhhbGBZQv
	 yXlRidHfTfUNxbqlME8YG9BJw8RxuHD6fKpCPpEJhRP3jfYi0XLE6MtCpYBITsXgTI
	 lxGgiv42yPQkQ==
Date: Wed, 5 Aug 2026 01:33:36 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, linux-arm-kernel@lists.infradead.org,
 linux-iio@vger.kernel.org, linux-mediatek@lists.infradead.org,
 netdev@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 9a4cdc958dd79fc6c3b20b51a10debec6ca09fec
Message-ID: <20260805013336.4bd8a298@jic23-huawei>
In-Reply-To: <202608041404.bOHh2XuT-lkp@intel.com>
References: <202608041404.bOHh2XuT-lkp@intel.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B9C4180009
X-Stat-Signature: ckot9iywpc556frqb1wxkb9dop6tcupa
X-Rspam-User: 
X-HE-Tag: 1785890022-252567
X-HE-Meta: U2FsdGVkX19plv4j+SeCMngC8rWT3nUSWLZ17rU8MAW26/bPNEKjCS4I4g6suvzwX1+yHr9RDuIulkCXJk2zRmkBNR+HaSA03QQN/hE+/y8F62LEhwBOpweLDlDQuqG1Uy+H1flBZ6T92tN9UW/FWcrtFMS3DUKoORtwBcTyKDnTp9YiunuHBWnAt6FCI3qPFsJ6geo6TtjJj5DFRw5tDRi5ai3kjQWmXG13Zlz7h5sHag93/jYrgOYUX/U/TgEgsOAIrcei7YCabQseY1HpWRR3SR7+s9+oti+m05kGKm9gssaRYVaYYC+q1t3VNZgnWFjDnoovC/TAqV8g0kai5hjmzjLRQGqin3AJlOBROeeIwqaIAO6pDv0GZpZeqaRXL+Agi+ZwRq3ENLVXZTde7AugSlD0xD4bIiIFoMDkSIfAHBovuEKLXDG9PV22N8RFI+0ci0juJMbJcrM3x/JHn8KsKFTtTnn8a4c2Ivq+ORYDtz1Uv5eK6WeChlpkpTxOAHi0x9M2wpEiKz507G1kj7XTB1fK22Wz4D4dMz7tzMO/kGMKcSDIoqwaSNW/4hUPtBsyTMEV3R0SBcrnkiI2o08V/LXHIWzQH3FJNlu6lFcc8h3u0qw7IsCdqU9H48uAJHe3/PjXCgNYyiLCh3CyGvscp2AfFk+lbELd467dGiEL287NjUU2Y1C30c8ibCNiuMS1ZTgTKRFp7glnxiR/dtvV3A6xnkSMLi1nJhmy2Pi5rLOS2CkExOhfqd07cyypZG2i5yU37WFsEyXlWcVk7IKmHqythihVRMsTiijb499I+CjnPQNYgTuXzniht9e1GgzdNFOGJaSzB6qRmAJ6cH8qtugpxkSPK9/3ZsTaluLRz8xGt/nZeDm1nz2pl/7RsrWQ0T5ZjAOqFhMSxgwjp2dzNntAoXLkkIgJyB6421/qHqIklPrEsDpKI6sn+QMi5je6+SLrUJtfEWnLPsR
 N+/eD6Sg
 d2BuoimZxVn65cEgz9rXg8hp0jxKYAD9gxqqDn2xKebNLG+4tRwAEPDtHj33Vc9ekOMEo2HuKrGQf13q67OxX0YHMY5R35bRW8s/ehblnUpJ6+vDu5ZjNvpm4wEJgpgjHMpyVboFDxkxI0Dix8EZ5HEr+auBfd+NGXX1N12tPj7VxhoKa1Zmtc+aVdl/cKpB7HI6bri1w5iUpGy+Zljiy6ipKrn1QFW9c4xhIBkBqCZnWr4heSk+jeWF2Z+ISprFzSVy/BcYxD1tppKLKgBNOtBAGdgkt5JWCDZuG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 04 Aug 2026 14:24:23 +0800
kernel test robot <lkp@intel.com> wrote:

> tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> branch HEAD: 9a4cdc958dd79fc6c3b20b51a10debec6ca09fec  Add linux-next specific files for 20260803
> 
> Unverified Error/Warning (likely false positive, kindly check if interested):
> 
>     https://lore.kernel.org/oe-kbuild/202608040800.45L57Mym-lkp@intel.com
> 
>     drivers/iio/magnetometer/qmc6308.c:402:7: error: call to '__compiletime_assert_472' declared with 'error' attribute: FIELD_PREP: value too large for the field

The line in question is setting a 2 bit field (GENMASK(3, 2)) to 0.
No idea what is triggering that warning.

>     drivers/net/ethernet/airoha/airoha_eth.c:3470:25: sparse: sparse: division by zero
> 
> Error/Warning ids grouped by kconfigs:
> 
> recent_errors
> |-- arm-randconfig-r121-20260803
> |   `-- drivers-net-ethernet-airoha-airoha_eth.c:sparse:sparse:division-by-zero
> `-- um-randconfig-002-20260803
>     `-- drivers-iio-magnetometer-qmc6308.c:error:call-to-__compiletime_assert_NNN-declared-with-error-attribute:FIELD_PREP:value-too-large-for-the-field
> 
> elapsed time: 726m
> 
> configs tested: 100
> configs skipped: 1
> 
> tested configs:
> alpha                            allnoconfig    gcc-16.1.0
> alpha                           allyesconfig    gcc-16.1.0
> alpha                              defconfig    gcc-16.1.0
> arc                             allmodconfig    gcc-16.1.0
> arc                             allyesconfig    gcc-16.1.0
> arc                  randconfig-001-20260804    gcc-15.2.0
> arc                  randconfig-002-20260804    gcc-8.5.0
> arm                  randconfig-001-20260804    gcc-10.5.0
> arm                  randconfig-002-20260804    gcc-15.2.0
> arm                  randconfig-003-20260804    clang-17
> arm                  randconfig-004-20260804    gcc-8.5.0
> arm64                randconfig-001-20260804    clang-24
> arm64                randconfig-002-20260804    gcc-9.5.0
> arm64                randconfig-003-20260804    gcc-11.5.0
> arm64                randconfig-004-20260804    gcc-9.5.0
> csky                            allmodconfig    gcc-16.1.0
> csky                 randconfig-001-20260804    gcc-9.5.0
> csky                 randconfig-002-20260804    gcc-11.5.0
> hexagon              randconfig-001-20260804    clang-24
> hexagon              randconfig-002-20260804    clang-24
> i386                            allmodconfig    gcc-14
> i386                buildonly-randconfig-001    gcc-14
> i386       buildonly-randconfig-001-20260804    clang-22
> i386       buildonly-randconfig-002-20260804    clang-22
> i386       buildonly-randconfig-003-20260804    clang-22
> i386       buildonly-randconfig-004-20260804    gcc-12
> i386       buildonly-randconfig-005-20260804    clang-22
> i386       buildonly-randconfig-006-20260804    gcc-14
> i386                 randconfig-001-20260804    gcc-14
> i386                 randconfig-002-20260804    gcc-14
> i386                 randconfig-003-20260804    gcc-14
> i386                 randconfig-004-20260804    gcc-14
> i386                 randconfig-005-20260804    gcc-14
> i386                 randconfig-006-20260804    clang-22
> i386                 randconfig-007-20260804    gcc-14
> i386                 randconfig-011-20260804    clang-22
> i386                 randconfig-012-20260804    gcc-14
> i386                 randconfig-013-20260804    clang-22
> i386                 randconfig-014-20260804    gcc-14
> i386                 randconfig-015-20260804    clang-22
> i386                 randconfig-016-20260804    gcc-13
> i386                 randconfig-017-20260804    clang-22
> loongarch                          defconfig    clang-24
> loongarch            randconfig-001-20260804    clang-24
> loongarch            randconfig-002-20260804    gcc-16.1.0
> nios2                           allmodconfig    gcc-11.5.0
> nios2                            allnoconfig    gcc-11.5.0
> nios2                randconfig-001-20260804    gcc-8.5.0
> nios2                randconfig-002-20260804    gcc-11.5.0
> parisc                          allmodconfig    gcc-16.1.0
> parisc                          allyesconfig    gcc-16.1.0
> parisc                             defconfig    gcc-16.1.0
> parisc               randconfig-001-20260804    gcc-8.5.0
> parisc               randconfig-002-20260804    gcc-8.5.0
> powerpc                      eiger_defconfig    clang-24
> powerpc              randconfig-001-20260804    clang-24
> powerpc              randconfig-002-20260804    gcc-11.5.0
> powerpc64            randconfig-001-20260804    gcc-8.5.0
> powerpc64            randconfig-002-20260804    gcc-8.5.0
> riscv                randconfig-002-20260804    gcc-13.4.0
> s390                 randconfig-001-20260804    clang-21
> s390                 randconfig-002-20260804    clang-18
> sh                                 defconfig    gcc-16.1.0
> sh                   randconfig-001-20260804    gcc-16.1.0
> sh                   randconfig-002-20260804    gcc-16.1.0
> sparc                randconfig-001-20260804    gcc-16.1.0
> sparc                randconfig-002-20260804    gcc-16.1.0
> sparc64              randconfig-001-20260804    clang-24
> sparc64              randconfig-002-20260804    clang-20
> um                   randconfig-001-20260804    gcc-14
> um                   randconfig-002-20260804    gcc-14
> x86_64              buildonly-randconfig-001    gcc-12
> x86_64     buildonly-randconfig-001-20260804    gcc-14
> x86_64     buildonly-randconfig-002-20260804    clang-22
> x86_64     buildonly-randconfig-003-20260804    gcc-14
> x86_64     buildonly-randconfig-004-20260804    gcc-14
> x86_64     buildonly-randconfig-005-20260804    clang-22
> x86_64     buildonly-randconfig-006-20260804    clang-22
> x86_64                                 kexec    clang-22
> x86_64               randconfig-001-20260804    gcc-14
> x86_64               randconfig-002-20260804    gcc-13
> x86_64               randconfig-003-20260804    clang-22
> x86_64               randconfig-004-20260804    clang-22
> x86_64               randconfig-005-20260804    gcc-14
> x86_64               randconfig-006-20260804    clang-22
> x86_64               randconfig-011-20260804    clang-22
> x86_64               randconfig-012-20260804    gcc-14
> x86_64               randconfig-013-20260804    clang-22
> x86_64               randconfig-014-20260804    clang-22
> x86_64               randconfig-015-20260804    clang-22
> x86_64               randconfig-016-20260804    clang-22
> x86_64               randconfig-071-20260804    gcc-14
> x86_64               randconfig-072-20260804    gcc-14
> x86_64               randconfig-073-20260804    gcc-14
> x86_64               randconfig-074-20260804    gcc-12
> x86_64               randconfig-075-20260804    gcc-14
> x86_64               randconfig-076-20260804    clang-22
> x86_64                          rhel-9.4-bpf    gcc-14
> xtensa               randconfig-001-20260804    gcc-8.5.0
> xtensa               randconfig-002-20260804    gcc-14.3.0
> 
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 


