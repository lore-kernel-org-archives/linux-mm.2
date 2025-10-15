Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C99CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 04:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3DA8E0011; Wed, 15 Oct 2025 00:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB288E0005; Wed, 15 Oct 2025 00:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807898E0011; Wed, 15 Oct 2025 00:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72EDC8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:01:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BABC1A0AD0
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:01:27 +0000 (UTC)
X-FDA: 83998999014.08.366A181
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22AA114000E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:01:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGf2UCUe;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760500885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbny4X++b3XhfMj5aDMNgLZNmlxV9Znb4oEvVnXNRFs=;
	b=ozDzrk5hvf00ZIXw0nrTao2sux5KRfqXTGOjb3BP2eSlLP70zvoZb5VVr/jvVsa/6Tnc4G
	zcRKL7egBtek6g7X5ialtBLYeVPIUJCs2wjIjN8Vx9Mjd4kjBjSV4lHrUbtOhEgEp1HM/w
	HbAPMicyuj9Lg4PwdppWCy0Y62Ic0nM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGf2UCUe;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760500885; a=rsa-sha256;
	cv=none;
	b=Fy1bau9ubK1HWukdtXwsCbZ9/mahxdiFBdq/PQz21uqDFrJBSeCDKweGfsvk6IMCUi5I4/
	/K8iucjy4o7sElp4v0I8ru+xx1b+9H9hFSKpbSsHHeYgnr/PsGMk8DNJcxllK5mHR9uMzn
	0KEAYy3RzjzmmVsyN5lwm96h/z2LyKQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760500884; x=1792036884;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xEnKUjSeRVxcox93QyeT+KlvKLsc9ekKmD8PhZkdAEc=;
  b=EGf2UCUeOe4LYAQdewx0kj3k0aEMVfvqZ3cc5/NuEugYBwCbRnn+UBG0
   /7lphB+49CrTmSYVou2SW4lzd2UDERlhrpeSqy4+3mE9cKrfOs5JMKT+F
   T13slTzFzO3MbZ8dDpbmQXOyHsnkJmJYZEzgEyOvySeoBfsXyHWyvhPlp
   p9WTIcI+yp0WzYSKmHwIxtw7r+H+t4WtlTwZdIJodke3mhe8rx4OQUPIS
   4U34XAYR8GU4Q8aZaWDqQbmFdAMzGOBNpZjimki7VgFcXV8H+NsaH4Yy8
   iBzyfOScngETDSAAgbtO84eTaufiOIN2fS4mXyW28JRDZaMk+HULuAPsV
   g==;
X-CSE-ConnectionGUID: covR4IL/RNyeBCX+IXB2/A==
X-CSE-MsgGUID: ZH8FiQ2PSmiaUxv6P6LmyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="73344718"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="73344718"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 21:01:22 -0700
X-CSE-ConnectionGUID: XzVPSFTCQZaGLcABPvsI8Q==
X-CSE-MsgGUID: gVllb85JQhijGcKuXDiMGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="182841358"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 21:01:16 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8sfS-0003QD-0r;
	Wed, 15 Oct 2025 04:00:15 +0000
Date: Wed, 15 Oct 2025 11:54:12 +0800
From: kernel test robot <lkp@intel.com>
To: Deepak Gupta <debug@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Conor Dooley <conor@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jann Horn <jannh@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v20 24/28] arch/riscv: dual vdso creation logic and
 select vdso based on hw
Message-ID: <202510151153.212gVMMJ-lkp@intel.com>
References: <20251013-v5_user_cfi_series-v20-24-b9de4be9912e@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013-v5_user_cfi_series-v20-24-b9de4be9912e@rivosinc.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22AA114000E
X-Stat-Signature: qr7de9zse1fw44biaz4gk9n9qy1wjnkb
X-Rspam-User: 
X-HE-Tag: 1760500883-40116
X-HE-Meta: U2FsdGVkX18+YzfqaxtnZo2Ud67tOY9fm8EvF1q5QS+6mSUfkxwSQ9FI2wIlJ8TBlvwYbPbWJeSOjUcbDj4lGWVN9IjZ3VEcjhRSy7mQO5AIiKpannjzcf0Ju1fh1bE+SuhgzfvDNY2znh6OQK1XnwwouEVX4IHYO6N24Ihtvb3J1GVe/9aGGTOk6VG8rWZ589airqFXHBKHaywatBx5ZiNBII+4mD/zqiSplD2zst8iJDU1KFyFsw5XbGCB8MMAOIt+TzWpxr0V4ekydeupgFJS2f8kVBgLXUjMMTv5jpPz2TXqMcwXEvbCVo20axe95l2kpUvJCos4zRyhC/qRMzBurz5dOXZNI5ELPeCjTFouSR4kR4acFsdplyew7RnfJcRzcnaBWCHaeLquHS4bJ8is2c518pwW1Aj2RvfyfJp5NB9C7FaXuPlj5Ylg7oMDKdAt4z0pmJOLpolElKsZu/NfXEQMzsVxoiSiqbE08J/4r8ISnd+x+HaLfwThFxnTEso7XBolkxDizVarOB38wjJFF45ydVlNJOr+yG4s7P4Um0IHopec0pIxQKAo8Hovu2bMtUUVbNuTvJ12LggbbPJvVt1y41xzFoAEpT7LkY4TsmQxw5gvZutlOT06eE/QrgHmKPuRJBZCfaDXeKMTcozcI4d96+dDZjESVjQZVyPh0F/r9sJehG24gPyvuvCWOy1uT92XWWqivPnatGH3XST9ZD3yfSnhJpPhUSJC+5dYJLBZad1WhZBUowenzvjbhhUU6pomlvbG7g4kDq+eUYP5erIEFhqC+8Vxmxr73BQL4lTZS9I+b6ElJo/Ele4Fzo3fkV2ro3JY782Xmu/iNfQVGiXBVCG1ckg1M/O+ARdvpomdCXYwXaEbZQ9jGPZTDKZ7UV2wZRuUcJcuUX4h3KcS45JZ75A0HQSWtJypjyJNaNAVy2r8uT56WYMhaaatyXmxv3sfFiFsb5IOVZO
 1WwGD3pb
 r+asN4W/mP2Hcom9ZkOwwyNfUm516VtR/aq7npBd6AbJlKcU8opA+mX1WrYv9SqGtk164pc+3TxMBozQF5sUw2DKGvsqA0ZeJ/fxelWmNf5wyhzUUzSvL07TCmVUYGFxx7L4krAqmrxvGx2nITuKXiirD7FeyWc8wElFpoJfvKFF5vs4AbBjozF6NqG+bRFbd/S7udDzD2R3UtTaeGoiqfxeq3X7EEQfHa4rcolmnAiXxwyseJj4Stt7rbv0m8hTVaKuwEdJoh9GAFYQ2YLn/VaIhlvq6lVnNQA5QsnbyTLGj3K2fd4R8vo7dCe4wnEgjJjSEv2UzX8F3OyMXpVfsck3svRe2GpRARkL6PJvVOozWcP65FFX+4wpiKubT99qwUw41Py11yi08JhAv5Oym57yGY5vYDVl3DZedDJ3yjEHe08ntYOM1NvMETSheLXnmZ0aeyhneiI8QaME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Deepak,

kernel test robot noticed the following build errors:

[auto build test ERROR on 3a8660878839faadb4f1a6dd72c3179c1df56787]

url:    https://github.com/intel-lab-lkp/linux/commits/Deepak-Gupta/mm-VM_SHADOW_STACK-definition-for-riscv/20251014-055847
base:   3a8660878839faadb4f1a6dd72c3179c1df56787
patch link:    https://lore.kernel.org/r/20251013-v5_user_cfi_series-v20-24-b9de4be9912e%40rivosinc.com
patch subject: [PATCH v20 24/28] arch/riscv: dual vdso creation logic and select vdso based on hw
config: riscv-allnoconfig (https://download.01.org/0day-ci/archive/20251015/202510151153.212gVMMJ-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151153.212gVMMJ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151153.212gVMMJ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/riscv/kernel/alternative.c:16:
>> arch/riscv/include/asm/vdso.h:21:10: fatal error: generated/vdso-cfi-offsets.h: No such file or directory
      21 | #include <generated/vdso-cfi-offsets.h>
         |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   compilation terminated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for ARCH_HAS_ELF_CORE_EFLAGS
   Depends on [n]: BINFMT_ELF [=n] && ELF_CORE [=y]
   Selected by [y]:
   - RISCV [=y]


vim +21 arch/riscv/include/asm/vdso.h

    18	
    19	#ifndef __ASSEMBLER__
    20	#include <generated/vdso-offsets.h>
  > 21	#include <generated/vdso-cfi-offsets.h>
    22	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

