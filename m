Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7EBCCD185
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 00:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6598E0023; Fri, 10 Oct 2025 20:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D828E001F; Fri, 10 Oct 2025 20:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA918E0023; Fri, 10 Oct 2025 20:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB3F68E001F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 20:39:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E6A94626B
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:39:54 +0000 (UTC)
X-FDA: 83983975908.29.EC0E15D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D3D7140002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:39:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fl/0tFOQ";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760143192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFBdrbjjejIJ8tRPiRmoqUrozh3da/HoJ87Y9Mg4ea4=;
	b=oDXIH0yJoKuAdS2+M7IY9kjSgJZcXzg5boTsHzqzKtfQMBcOYZvB8QzMUYDHGRd5EQT0OL
	IlHro83Tz+WzkssLT0bxXQYGHATAd0Zy+oySNpzY97j4khNXwTtjmqvG2OsaoL69aF4kWB
	hQ/oGHbNnzxCpvzilEpZNUnwxU8Y2p4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fl/0tFOQ";
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760143192; a=rsa-sha256;
	cv=none;
	b=RCh5zi6EpZlFLDrG9ZjpdC1mITB26F40UAfovfLOSUi2Y41JVuDEK5qqVO5I1duh4LJQse
	jPmAXX02BaPu6D0Sboqpd59LI10/wyWftPH3TqGa9+Lf5T2PAxaxcC9ZN9hSFCybZoMIC0
	CPEjMAB8fYzintg24CHdsm+6snMoXC0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760143191; x=1791679191;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3WZMGE84ie4C++BzAywiY54anJ7ajFY4nUNbpZUz3/c=;
  b=fl/0tFOQWs67LEZjJr9/YSh5rOGGs34AxAzGFxGhez+gYiTYVJoJOJ3X
   FhyZGc8TQssNrVduryUtjcfritOur1Lw48WP8xbHpkCsGOQzkNEPGEz1W
   w9FXDwHgXrrk287Fs7DYyVxgOW3q1IO/cZrqs3YJ45gkamlwWpSO7b5Lr
   bjc8F17taaZLkM+T5v2JkeoTYwHyPsKhLBFRjwwDh/VSr3x4HmQPmj4iH
   vluxRDcdyv5PCzJA51Z7H4bTKhw4J67Scl5o7xJvKfyIVCxvfP/wEGQAN
   Guex5rWQYzORo6O/52GxMKx0FmuncWM09UHvEYHCICAf1XG5okxcmkdS1
   g==;
X-CSE-ConnectionGUID: NJZn2ciPTqKK70cm5lNk+Q==
X-CSE-MsgGUID: 4DyGwclHRfaoyunUDYMTKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62067004"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62067004"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 17:39:49 -0700
X-CSE-ConnectionGUID: SD3AyhJoS8q/jAeJ2WMHuw==
X-CSE-MsgGUID: 6XtPKSO+T3qohp3M8bZxKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="180791567"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 10 Oct 2025 17:39:46 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7NeB-0003Kp-2l;
	Sat, 11 Oct 2025 00:39:43 +0000
Date: Sat, 11 Oct 2025 08:39:08 +0800
From: kernel test robot <lkp@intel.com>
To: Jakub Acs <acsjakub@amazon.de>, aliceryhl@google.com, djwong@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, jhubbard@nvidia.com, acsjakub@amazon.de,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	chengming.zhou@linux.dev, david@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com,
	rust-for-linux@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <202510110802.EXLvwqhL-lkp@intel.com>
References: <20251008125427.68735-1-acsjakub@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008125427.68735-1-acsjakub@amazon.de>
X-Stat-Signature: aexstw33bzyzwrp6c6od4xtekehzpde3
X-Rspamd-Queue-Id: 3D3D7140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760143191-756095
X-HE-Meta: U2FsdGVkX1/X0m0+AEKgyi9QOS5CHdvfTDHasicCllQv95/FM5h/SXGoEN8WiljuuUBP5jc29CiLNSpr/p6wcXz5jxpVtq8jPbMRak12WP/GpmA/ev6Ee8IKqwWGprf9U7cE9SG4OTIJkhaLvqLhiO19GQDHglM38S+NTZ3bkM1ypT7HTC7qFID639paZfnbhj/bYnQHqf5hdQU/5dnoWfiKhTlCNMWSiiy97P4wROs8jU1a5K6dXN/sqYtiNdY8z95GSxJuGEIgUa5BEPMzYuEEFhZJ0WgHjj7mvu8dvL8Tf8TGP6UDowe7RsNFARC8fsVa6Up/QwVDvflYWQTCWxHABQ5LwUKCyyBVrOkvMVNf5hPB62Vdnhuk+5OCAPY+Cff41YAhZgn7LjWbixfnUVVL0TZOQLTNxI4tOWo1zTw3LggI93EAXvfoDHfVdgZWjX34bcyzVki7dk003Q6pFHU0cLoiJutF/b8KrlhXxQw0zSTtD/1cqoePpaADYSa6tFuJqt49dsd/9hSNbinltjjuA5/6/LXXQDcFKM7BUGC5SxAu81LCvvMNBk6NR5SS7k4F0Bruk+dePap52E1v7jU7DSF0yJ6jnizkaCI0JYaOx8uOPE5LvpaLmhZIjAYaLsYKN8jKWxztYNERHghKlwkyMTktv8vSR2Fkb+i9iANyDZWoqJVnEECzkkkPt0Hm0/5/xoNtDYmRCgx5Rtarm9Gio7GGkSRj6IC5BoDxVcaWtMMF/ctn5ncP2+N3bTdQzQSNY2z+br5McvAtzr1W+ntEKl0sdYoPzvMfCub0pkHrnXnjXgNqo7r6VxW+l+xNDGRYKvuPd0nFnEiV77TJXCE8vSIE5dvLgbw7B6TZfpGOOO2ISjxgc/sigSog17COk8rXlY7KY6gPpmqnibnUZTiHztbdMKwKJm2zJxNMhStd87DbUfkGx6IINJ42KeOcVgTnup8RWahKWo0lgoq
 VeHMJDUF
 HhL6hO2+S8JTqtdRePDs5We/Rt1+3yEzEEFQqUyutRPn750STK8m+deFaegW1lf1Bd2Z4AlCAc2GkfJxyajFLm62hEBu0gufwwVnXpmJG0brZ9yQr8861Fc1VwyG5Ul+lgh+H9sI/GAXQXdkJqN6Z+5wqIt1nuhZ/awLuuroB7JLyef0ztjjdzjRW9y2b9JsO8FuUtr6EKn60SOfWz4TTb0Ev0V7gs04tmGPx3R5JG24tntp3i4/9uDzpq/+fmnXpsgVcDtJOhV+Eab7/nomxRaG65q67OPk/73SabvPnO/148xbNDYJEdFPUnsOiEKWjUUFrKWVzRY84OOc4tuNGtup79+fZ0/WIE2Rs1gBIwrY2oIAOsGfrxzccTwAaO4+F71FIl/TUemXDuqJyWbdEm2Wf9r/rzS/UuLPs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jakub,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Jakub-Acs/mm-use-enum-for-vm_flags/20251010-124738
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251008125427.68735-1-acsjakub%40amazon.de
patch subject: [PATCH] mm: use enum for vm_flags
config: parisc-randconfig-r072-20251011 (https://download.01.org/0day-ci/archive/20251011/202510110802.EXLvwqhL-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510110802.EXLvwqhL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510110802.EXLvwqhL-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/elf.h:6,
                    from include/linux/module.h:20,
                    from include/linux/device/driver.h:21,
                    from include/linux/device.h:32,
                    from include/linux/node.h:18,
                    from include/linux/cpu.h:17,
                    from include/linux/static_call.h:135,
                    from include/linux/tracepoint.h:22,
                    from include/linux/mm.h:39,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/nsfs.h:9,
                    from include/linux/proc_ns.h:8,
                    from init/version.c:18:
>> arch/parisc/include/asm/elf.h:320: warning: "ELF_OSABI" redefined
    #define ELF_OSABI  ELFOSABI_LINUX
    
   In file included from include/linux/elfnote.h:62,
                    from include/linux/build-salt.h:4,
                    from init/version.c:11:
   include/uapi/linux/elf.h:386: note: this is the location of the previous definition
    #define ELF_OSABI ELFOSABI_NONE
    


vim +/ELF_OSABI +320 arch/parisc/include/asm/elf.h

^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  308  
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  309  
71d577db01a517 arch/parisc/include/asm/elf.h Helge Deller   2018-04-11  310  #define elf_check_arch(x)		\
71d577db01a517 arch/parisc/include/asm/elf.h Helge Deller   2018-04-11  311  	((x)->e_machine == EM_PARISC && (x)->e_ident[EI_CLASS] == ELF_CLASS)
71d577db01a517 arch/parisc/include/asm/elf.h Helge Deller   2018-04-11  312  #define compat_elf_check_arch(x)	\
71d577db01a517 arch/parisc/include/asm/elf.h Helge Deller   2018-04-11  313  	((x)->e_machine == EM_PARISC && (x)->e_ident[EI_CLASS] == ELFCLASS32)
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  314  
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  315  /*
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  316   * These are used to set parameters in the core dumps.
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  317   */
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  318  #define ELF_DATA	ELFDATA2MSB
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  319  #define ELF_ARCH	EM_PARISC
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16 @320  #define ELF_OSABI 	ELFOSABI_LINUX
^1da177e4c3f41 include/asm-parisc/elf.h      Linus Torvalds 2005-04-16  321  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

