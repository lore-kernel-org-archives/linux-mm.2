Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EEBCDB462
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 23:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFBD18E000C; Thu, 13 Nov 2025 18:47:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC9B8E0002; Thu, 13 Nov 2025 18:47:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9B238E000C; Thu, 13 Nov 2025 18:47:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B47A48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:47:30 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F6C612CA78
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:47:30 +0000 (UTC)
X-FDA: 84107223060.27.C279CA3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id 97E221A0009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:47:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UON8YVR4;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763077648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWT1FvU0sBzkn1kQJ9RzDNaGTHMLE02ERIatRdBAS7w=;
	b=Rc4ez/phdIHttHYFEjGqdoBbnie1mXB/dsdmo7k/hE0gRAJONgYufzLjFZFdNnD/Gs6YtD
	S122Chr68ANtnVF7p/yypCOLqD/OX/fKppvjyNlhZlhJ095Kscz4iyxJavjPFPvKYhBQN4
	+8D7lqjG7lVKAx0uOcHnBtd3rb6aMJ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UON8YVR4;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763077648; a=rsa-sha256;
	cv=none;
	b=e2sIac3aLaG/hoPmvhAVaMXuPNya2Bfe4AjLiSrAHAlYiwNjwFjSZyUZV6YtQGANSbMBZ2
	6HjvEN4I9mXrvNz1ZbugWFSZ6VBdJS7s79WGNv08xWIQ07mpQh12Md3/hCMhj/NjdvujJw
	65fJ+bkts6l7Mr8Q9LepOIr8VGiY2gE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763077648; x=1794613648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Y0Rj4ZRe5ERECMPOL/Tf/uw4avMT1HmU7UJTbesrIqc=;
  b=UON8YVR4V16bxO3Uox52s/QuZco0v0afneG08u5XLnoGsbcsXs4nS5ya
   v2ogCaulgp3fCk5xQsYNymYydYcfj8OYZN8jVccfDXtNn52e7Tz1xSvaz
   HkzjXmQg30E1IW00skQtqN5IUkCvW3axGIKhvo3UTfe+x6PzJy+M5R4na
   hoeOnQB0lOPFxac+ZUDqMEDbQEcBfDC8U2K3qRIhuSJGhNxEAbGe7raXV
   CU6gm52XYPO3D0FZHQWUAEtaSJnrxa3u7qT2D8Pw7P64Bu6TlmzLLRZdP
   rvmkFoEaDSL4hbpsHTPd5lrDA/HKuBcXwpB9kFRjOYh0rucznn9FaRTVT
   g==;
X-CSE-ConnectionGUID: TtduAWj5RIGZJt3ZraB4SA==
X-CSE-MsgGUID: 05+ENoh7Tciw9Z9pVzNpTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="87816440"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="87816440"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 15:47:26 -0800
X-CSE-ConnectionGUID: Dq9YV3/3QBC9a11GdiOapg==
X-CSE-MsgGUID: nXbXL0z/T6OqbjgYjMo1qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189267507"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 13 Nov 2025 15:47:21 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJh27-0005zX-2L;
	Thu, 13 Nov 2025 23:47:19 +0000
Date: Fri, 14 Nov 2025 07:46:40 +0800
From: kernel test robot <lkp@intel.com>
To: Yuntao Wang <yuntao.wang@linux.dev>, Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Catalin Marinas <catalin.marinas@arm.com>,
	AKASHI Takahiro <takahiro.akashi@linaro.org>,
	James Morse <james.morse@arm.com>,
	Chen Zhou <chenzhou10@huawei.com>, Baoquan He <bhe@redhat.com>,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Alexander Graf <graf@amazon.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yuntao Wang <yuntao.wang@linux.dev>
Subject: Re: [PATCH 04/10] of/reserved_mem: Use dt_root_addr_size_bytes()
 instead of open-coding it
Message-ID: <202511140700.auD70FDr-lkp@intel.com>
References: <20251112143520.233870-5-yuntao.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112143520.233870-5-yuntao.wang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 97E221A0009
X-Stat-Signature: zjgumjf67m4s71sn19r7pj9b5yhe4oy6
X-Rspam-User: 
X-HE-Tag: 1763077647-145080
X-HE-Meta: U2FsdGVkX1/0Dszm8LG3+4Qmr1UklY+PSbzCMrusTJmGbk5csWwdcS8cHkADNcygHkiley2LBjJoAV0hFkB8FvJkU2eucjB7Wp/5F3ELKjgAqi+pVo08FtuQHx4oKMfqOC1o+05XiUNnQ22zojP5vuR82G8Uxj7ITnNDXqnGX2bl5tvUqLznbv+on9YmezpBUFYJ42TKJRAIXugPjYh9ujeVvck7omaBCvKZkcu1W/TNSsqzbbIA5XS25rPoBnMlvdkji4XgvML6Fwi5dNkoX2C6KgcrzYkwpOOg5PE7LMDivSbwyZakd3gz3TjirOpuqBgY80L4u/u647tFTbYZVNZyCJxGSQOMXbw6RQzhnQf5T8qjmlHyR/wSyzp+23wjpoGWB1V8FZCKCrgCBEkvaNYlO/CfBcwjhukb7+Cdv5poS45blgbgq7c2K0cLhw42umrHZmRVM8s97Vl6Koz1XFwnPn+7wz1kMitIi8ziz/GKQWi6OufzKtGZS6FxFnVSSni8vBQOIg3c3CqT7Iw2ko1JGoMb/nnVMhsE9NTnD0X4V/Ypo7FixVFGIrWlZidLTrCU4zK0RKPKaOpVvoSlcYNcJnKSaPNlPZSQsHDwlchC8ywToS8kcQw5REmr6HzHgvzRluY4TO9i7UVpOtfZI8cD8ZD6mA5r/Ap7Tpbw5s98v4klnmV5BibXlpASkFagNvv1/VejbPgLYFqX6McJ8SQQwVRwBBYWozzeNdq53DLGJU++yzxjB5emsJlstuIH5UfKsX5lLF5n2ggf9cjaUMZ91uzvDH5xiUVEn/Ai1wshpO5Jx5AxF4Etxi4kcrRp2efKHkex3r2AzdFJ1xwt9Q5IzS37LN+W1gX/Vm5N4oHj+gDuYHYTQjxedC6JxR0SHBqJD8EqOiD6rI5D6GjGlwSK8ZP8J5GACFxT6YK3dSG1+AH5z0rr/AlnX/s0CD8nibIwsG74hLAVQQuZpaZ
 jBsdjdSP
 /VoK4dow2VU2PUyLwnQcfxFQiFGMr25fY5vJQRPc9Q/Vh5yam0ZTvDY+TO3HGInccgQJ/Xo84UgXXuF+nx0we7gh5p7JfSMP9x+UdcsJnPv3U7JPk0/ZpZbp/r4eyMtdFps3tc7hYhN15xLHEXUAo5TQdVfvU/h1tn9pIfnvWXA0fWE9FTIQAW+WVAsvlDC7G0PpKnUpSLrebIc2b3WPyrN7V//ExSF+QqwYxMQMjl73lsvh+X+4XAw/KmWk6uzTs9REaWfWl2nIkPZoescopgve/acG8G2nuoF0oDEPP7omhz0rIdTfixlaRxYD9lgGYmj0mBHTzblXfrRV2fNWbNG3RCtUgyy9VI+LyUTBXrm4X/w9XRDmJMFEifvqX5f6MyFqSDpvuYIdud75rjjPalWn3/Ye98j+855tdCXYdzDZlucTu2Zg4YEFZaEnmp8HmBu8CA/HWs+pwggyLXV7YMNUNap4/QdFqaUx2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yuntao,

kernel test robot noticed the following build warnings:

[auto build test WARNING on robh/for-next]
[also build test WARNING on linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yuntao-Wang/of-fdt-Introduce-dt_root_addr_size_cells-and-dt_root_addr_size_bytes/20251112-232000
base:   https://git.kernel.org/pub/scm/linux/kernel/git/robh/linux.git for-next
patch link:    https://lore.kernel.org/r/20251112143520.233870-5-yuntao.wang%40linux.dev
patch subject: [PATCH 04/10] of/reserved_mem: Use dt_root_addr_size_bytes() instead of open-coding it
config: i386-randconfig-011-20251114 (https://download.01.org/0day-ci/archive/20251114/202511140700.auD70FDr-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.4.0-5) 12.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140700.auD70FDr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140700.auD70FDr-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

>> WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0x1 (section: .text) -> dt_root_size_cells (section: .init.data)
>> WARNING: modpost: vmlinux: section mismatch in reference: dt_root_addr_size_bytes+0x7 (section: .text) -> dt_root_addr_cells (section: .init.data)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

