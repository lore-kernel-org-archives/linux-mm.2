Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60DED47CAA
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1701D6B0096; Thu, 15 Jan 2026 18:54:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E5E6B0098; Thu, 15 Jan 2026 18:54:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C306B009D; Thu, 15 Jan 2026 18:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E52756B0096
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:54:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9943C1AE5A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:54:29 +0000 (UTC)
X-FDA: 84335855058.02.25D6E82
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4ED3940013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:54:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TueP5E1z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768521267; a=rsa-sha256;
	cv=none;
	b=5N79PweLZ/zsyxXw6VIc9UuddI/5Tv2Oq8iQn7AOT7gSal5mU4Cudwx8Up/+mfKGiCc4Uv
	2pFa7i/CdyOO8iqOC57yw0OOa8fxNfAJTpAhTYeGikb0HI2ozmnS2TvgpdZ/vsuwIObMG6
	6gFTEso4nbj2qREQ9ARft7AynkCE3Cw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TueP5E1z;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mns02VIJkmDNwUYKuBgTBIOANw8QXbnzM8KSfan2bVE=;
	b=XHP/lU3AAA1Govop9U1EcDdVCoCnyy7tOPfgvG0DB+8lmpo60rIPT4YMYCSd88+X7uCYY/
	syORrGkQh9R75Lkk+jundFVhEueHpYwB7tGl28AKEs3vt50hacDnR7Vk8ZJu9NZ57xsTq7
	2PQt6/gfwUSuvXvKCqswNNlED29V6G8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768521268; x=1800057268;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TLB0GUviRxxyCEFiz/4tv7JnV3jow9C9gs3jm5o9LWM=;
  b=TueP5E1zQeXr8Z7NWRpY2qo2icLfHV+VwANdxYmVWBjz9M3GT5zMc9zm
   lGmbFUIsQ832U80qCSoTvk4xq6xo7fGcwsLSYlgtK2IysAzGqoMsWsENX
   WEg9TLJveezr9s2nWU+JATYO657mJYJbLOM4+P3SUTKgkP3LESCtLi8WN
   hmvjoaGxlzuvseIKo0ttIDAu2IajlKC2jzJ+TOJ8k+qUEh54fNjCRw54E
   9KFl15feUuIB9v5dq5rS5if6uBy6wdgDVfz275q4Hs6xQSHnPnN6JSVD3
   juUKsSGv/HiG5xjIkvQlqEXxL5P0fDi17t9GlQzm2UdgO6/8d1uR6f2hf
   A==;
X-CSE-ConnectionGUID: 6O8oc3yDREGjwZEBhaCQMA==
X-CSE-MsgGUID: EcZWR5MMR8mU1AtJfhoRCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69735402"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="69735402"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:54:26 -0800
X-CSE-ConnectionGUID: 4gOa7NMDQfem323HlpNySQ==
X-CSE-MsgGUID: iI6604quQG2dHhkVyzFeag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="209953714"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 15 Jan 2026 15:54:22 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgXAS-00000000K7w-2JtM;
	Thu, 15 Jan 2026 23:54:20 +0000
Date: Fri, 16 Jan 2026 07:53:28 +0800
From: kernel test robot <lkp@intel.com>
To: Luigi Rizzo <lrizzo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Bjorn Helgaas <helgaas@kernel.org>,
	Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v4 2/3] genirq: Fixed-delay Global Software Interrupt
 Moderation (GSIM)
Message-ID: <202601160733.QNd6lcMA-lkp@intel.com>
References: <20260115155942.482137-3-lrizzo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115155942.482137-3-lrizzo@google.com>
X-Rspam-User: 
X-Stat-Signature: 14taqc7imubx9yryhgnuatx43rukmw74
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4ED3940013
X-HE-Tag: 1768521267-602693
X-HE-Meta: U2FsdGVkX18OL7qKIpLFMiPzy5aGryN5qws8DI/tk43OIl8YuoSMDLI2SWiKGcHaNkLlkfFVRGvmptRldxMMrsyl4Bj4jV59yxGC4xdz0FOQguP5A+l9OrpQF8/Pc2s8tmHN2ci/aWAQckB1R5UFGVEilGEekwZnDzH2sJH2IL9Burn5yJX9nYzOIu32mGzzGWCm0pCjCf2fWJLsdJLgW9jeoGvBYQqU52Kfak+9G9WuzlG0PRW6d8wE2B6+warGuua4d/GNVEOLAaYvcX0PnaWb3m1MbJOsumN+9kF1O3lPZI7HS9+D22wxM0kL34sT8PZ8iBSUf8EAQN1hkkA0r9BlTgfYVNrqDSNpM17WkvCbKrmUyCmnHIjrtun4C7c+stBeR68/4fYwICtn+S/zY8pkBpgH5ITKrvh8b/Yr2IZKjF3u4MPA6uO/cveWsMdazXISqHU0Auxr+6apUjBjMLKjYz7nIFse2WlTCipAdEpp0yHM2MzsCDWC6gulxa8F4nTzMDV2S3TBJ8GS6lACaqRM3i8moypXLPNK664UBDav8XoYIKe23Y+YaWtZ0xaDY64VMdnHTyuonUO6p+2Vt2mNmuorpl2dnXn4eeunGwegk804tHf6wp9t5oYTLqOhgWtaBTmTbTM0mksCbY3E4GWFPcP531xz5l/F0fiZQeV2IRk8/61tFgImeEjShy1rEfK0cg4WD4dTqD9jE4DwrQO5yMTUJEs5j46b4RZjjeGOdAviJe8n8XZkxAgUeKOGrmYrJYkmRMzt3fXh+8Nh9QZTUAsRFM1qZT/nsMnXlVqenT5MVN6THsTIFmS8c4eDIcEns+dRu2avT09lvVZ4dXQ9dUSQgiTJL7f1nL4ODKgyjlbzUSXXC9Hk+Re2ZHGYo4cKWjc939mTrJd9T6+Mp7V8njW7WEB670vgIJo7S+iXIcuvHG3/OMHOuI2UglZH7t46IR9mqFpUuDO6kyl
 anYpq3YI
 MsJyr6PBL4nbJa6JilJXyNksKBaL5Zm5oO7/iV5cTp9roaMcJwpfsQIDg4YmKqXa68o2jhL0eNMc20rRxEP+6zw2hKiSt4xNL8Rd9QrJKnRXHyE1bpluKtNpUzKwYbg+yRq5nfk6LGJ+wxB8CBLukbLT5maEzW2JEOfuIJkv+0BFN0nNhfgU/qvrtedxPYOSIY29HhkqcIXXs7ugRDYvxnM/6Klq+Dj8UEl1w3r8rLx8W2+wXJ5kU4J6o+tNgr4c52E/O78Zu27O+7+s7k0U/EyB+oQK8l4W423jqMt/ilQNVKlaeRpQHLcs/XUpZseN7Ksn4NTXMKcd3L7TyhS/IlfPo3PqYjGu1r0BG3M23JAl8cGFM0kfjfG1dUL33jmwMM8UZoktXbycQFBwnv6VnpGrxfrkaBLEJtQr3UCJY+qUPfEdNBlvoyu1DiMm1Y0XRx5Ju
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Luigi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19-rc5]
[cannot apply to tip/irq/core next-20260115]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Luigi-Rizzo/genirq-Add-flags-for-software-interrupt-moderation/20260116-000808
base:   linus/master
patch link:    https://lore.kernel.org/r/20260115155942.482137-3-lrizzo%40google.com
patch subject: [PATCH v4 2/3] genirq: Fixed-delay Global Software Interrupt Moderation (GSIM)
config: arm-randconfig-r123-20260116 (https://download.01.org/0day-ci/archive/20260116/202601160733.QNd6lcMA-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160733.QNd6lcMA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160733.QNd6lcMA-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/irq/irq_moderation.c:404:23: sparse: sparse: symbol 'mod_nb' was not declared. Should it be static?
   kernel/irq/irq_moderation.c:298:9: sparse: sparse: context imbalance in 'mode_write' - different lock contexts for basic block
   kernel/irq/irq_moderation.c:330:9: sparse: sparse: context imbalance in 'drain_desc_list' - different lock contexts for basic block

vim +/mod_nb +404 kernel/irq/irq_moderation.c

   403	
 > 404	struct notifier_block mod_nb = {
   405		.notifier_call	= mod_pm_notifier_cb,
   406		.priority	= 100,
   407	};
   408	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

