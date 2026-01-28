Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B8ED25B48
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 12:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDA86B0088; Wed, 28 Jan 2026 07:18:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19AA66B0089; Wed, 28 Jan 2026 07:18:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F1A6B008A; Wed, 28 Jan 2026 07:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4EF36B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:18:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92C221A061B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:18:46 +0000 (UTC)
X-FDA: 84381276252.22.C5892A2
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id C3CE520003
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:18:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LkyM9apP;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769602724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DffyQC4Cucd/5UZil+qyIvLPTptHa4pIhfTfJoQ1+uM=;
	b=fAtHHK3WB7f8NOBfP7TqdXSSwWX3hQ5385Ll1Ypefo1uRCRTcns6JVZ+2UMiwusdNskDWD
	X/cdYbdt3Skd+djf1ro7jx20hPaZs/8VgXtyaZclmUsAuXBtdz4Zpr5KnwV73z/uNrJIv9
	K0YqouyyVz+yk5EEViZBChzbKgXVxfQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LkyM9apP;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769602724; a=rsa-sha256;
	cv=none;
	b=0FsiSsQYcgtxAdIkCOppHpMpBKvTQyWwj0Q+iyZqYDedsJhhmnnHRc6/UVu9+E7993a2uj
	rdyRsFhoZKS+XvekrKvBHkE9wmUv2oiINKyymz0rHwDZvprtzXEMqFlWI8FBXJFk4k/iNh
	bDDcnyMlSiSTgquH63EX+J4QoXahZZo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769602724; x=1801138724;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=irHF387VhKHjsOnpsnW9NUk3sxxbxWzln/uy9xgtwqM=;
  b=LkyM9apPgcQrf3qFNUYGDEup68NPyxSQcSTVC4cq0sEmkrKHYRakPRuk
   uII29R5iRhVptnZMPW3uPOGtLyzCzVXrQC7LwmxJZ/gXQ8R9mcTtMyPiI
   guN//yc+2MmvQ8yvZu3iSFgngrh2CuBrnB/kfaWY0Zuqkrw/3vo+K2auH
   BuOrUdDHunvJYCv71CCyOYSXc4909y+GTiMb4tSa1BBD2zu9pJzvDUu9X
   hBDI6NnowY6ZglY1eeHZZKl78EoLYCY6JMwLA0HNW0tqS3DSZPVi+jNnA
   XR8bY9gziMpZZOS4k9ANEYtjm3/+/ldRg0JAgUwkpKvJBdLAgftu39ob8
   w==;
X-CSE-ConnectionGUID: cGPgNaA7Q8CRk9OhydfddQ==
X-CSE-MsgGUID: KSETFIPrTMCBJVHqEmVL+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="93469835"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="93469835"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 04:18:43 -0800
X-CSE-ConnectionGUID: Q7Z5V0R1RjCKaaK9/1JSxA==
X-CSE-MsgGUID: tIAdhHReTWOiiIA7g/WWbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212353797"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 Jan 2026 04:18:35 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vl4VE-00000000ZeC-2fMW;
	Wed, 28 Jan 2026 12:18:32 +0000
Date: Wed, 28 Jan 2026 20:18:08 +0800
From: kernel test robot <lkp@intel.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>
Subject: Re: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
Message-ID: <202601282023.vzRHJBfU-lkp@intel.com>
References: <20260126164445.11867-2-kalyazin@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260126164445.11867-2-kalyazin@amazon.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3CE520003
X-Stat-Signature: 9s7nqdrqwwxddnsou3w79cxftbpnz4pi
X-Rspam-User: 
X-HE-Tag: 1769602723-75147
X-HE-Meta: U2FsdGVkX19AZ5v51Ccnbb0eeneDcIyo2hKfASoomuG+Q2XW6H/fpBvRp56YH+j/TLiX6K2gpHfoW+OcAknh7av0l3rGPbkUDTfvKr7oFc/J7k+KeXzoVsstTVPJAmgq/QDhWDsYSK90R338Q4Xm/2iRsxmWtmJETksFWG/RriSh1UQ64GdGlg3g/1CuuyHxFnv28pjsQh8mXYCuH7PghU53C4+Ggm5I2XiK22kk+Mi765wyWyr4us/7+ZD0/4fKWCETQgMJowOjbh9QbdPfLrVJO1Ni7DL1uK5CEsYPCzzicLWjTvcP632u8g30GVWH0NLLT7LBdEDGklifBGPEZHB37tZLPITU4Mxgnms+KyhLWc0cqZ5oRruK5Nfcpe0JWGzxfpa2VWG7GcOC2RSQzkknvs10CCTBH+qNtrXtrLAWo1kqljQOG7WX/5dARc4GR+Dtq1hujmB3aoQTj4w59m7vdSqPojrGV3cCwLU7ru986Llvv6O8ULDRQbURRWamIuHB4t5deJ2MGVcO5L2GbP2y2mf0JYSaW8rQR0bTtzn7fp//NWSjOgMdgRCIQKmpeFe+6YvY+U7MN2+mbyjoE+axpwyIcY3Lnx/rnaaWMZ0MrxwZLrU0kBZ7FSCgPxwmBG2YUfrHP2zK4suSBuH1FCE9PTqgRfMbyd4tWF9ESC9RTFi8NqDCp6D0lowFDzV6stVNmuVedo+CCFN+FuqtuuQo7OJcn8Kv6EC026rU52GaWtlRCkgTg8TkI5am1dBfJ5s+sj0fBNJ7Wdrt4hkH8SWGsDeLhf+R2Ek1urjKKeR+d9p32yfo88T6WyvtvWCjLOYKpPptjYcLQGk49cOxj7aRBTIRd4wKLNA9t4Gg4uu3KU/mFYz3KG+4qktQQsuPshv5uV1W8kPp0oXsL7EiwqOL0fRfjqZVM/PVjNO2ZpVnqxZvTQZtMJExshrWe65LBIfPwcnSbudO3fA30Lv
 5pLY0Eku
 LqEqFKLwKk5FaM/BT2Y8yT4zS+juciNPDRvsZxO8eMHfOTz8NnXYNKYwvyhyBas+0xt32mEyinyYFrp3bYQDfyAVPa+LAmgVmF+KQW0jxmeTxjk2FUTctJfs1XAyAsUzwjn7HpTwxo9oYrCb/3e8gOk9aBjdnnV2pyEy5N+DTum92j5/hDQ0RGoW6BXXvDlOFk+GmYRZmIy2DAAJzeH7qaNNGofy/Ln74E9a+eLUcj3eq2sxZi1IKpZ0J5Vm/kcERUFKHfGJ5YjuZEPG78sG16GtHesyjmqbN6q0irYqU8+cpmhvb6suwPPwQl2BtItcwkfM2DVpui4GhrnfAsSl50N6GLM0hAAbxECdC2n+djs1uUXpAghG9kFNjW4KlE/Vsuyyc9Xnyw3dJlxo//yayb19MpOmFKwMPNPBj/iAFlRGZuiVrPot+bPsd4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nikita,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0499add8efd72456514c6218c062911ccc922a99]

url:    https://github.com/intel-lab-lkp/linux/commits/Kalyazin-Nikita/set_memory-set_direct_map_-to-take-address/20260127-005641
base:   0499add8efd72456514c6218c062911ccc922a99
patch link:    https://lore.kernel.org/r/20260126164445.11867-2-kalyazin%40amazon.com
patch subject: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
config: loongarch-allnoconfig (https://download.01.org/0day-ci/archive/20260128/202601282023.vzRHJBfU-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260128/202601282023.vzRHJBfU-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601282023.vzRHJBfU-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/loongarch/mm/pageattr.c:211:16: error: redefinition of 'addr' with a different type: 'unsigned long' vs 'const void *'
     211 |         unsigned long addr = (unsigned long)addr;
         |                       ^
   arch/loongarch/mm/pageattr.c:209:48: note: previous definition is here
     209 | int set_direct_map_invalid_noflush(const void *addr)
         |                                                ^
   1 error generated.


vim +211 arch/loongarch/mm/pageattr.c

   208	
   209	int set_direct_map_invalid_noflush(const void *addr)
   210	{
 > 211		unsigned long addr = (unsigned long)addr;
   212	
   213		if ((unsigned long)addr < vm_map_base)
   214			return 0;
   215	
   216		return __set_memory((unsigned long)addr, 1, __pgprot(0),
   217				    __pgprot(_PAGE_PRESENT | _PAGE_VALID));
   218	}
   219	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

