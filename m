Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85628CA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 05:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF918E0002; Fri,  5 Sep 2025 01:29:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660B68E0001; Fri,  5 Sep 2025 01:29:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576C98E0002; Fri,  5 Sep 2025 01:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 44ED88E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 01:29:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AED3F598F7
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:29:36 +0000 (UTC)
X-FDA: 83854069152.19.75134C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AE49100009
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:29:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DrPIJnGN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757050174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCKIiY+Hpud5alLJ84h8zn8nLTpcb5sKeX8DKlpM8TY=;
	b=v9BVmXfSci9Wews0JBBhv+cFhJWDTSPbX0tgNxKFctgDuM1fTtU8N+h/PAN28lFRi7kf7s
	zFWcW4prBi8b4ck0F2LyCTMjR7o534r2OfwDpBmRCBBCkeQaRg2t7KEx3LpjPNAwjyu6UV
	3AHFhMebBjaNnNIZUFOzWJXO/zeA8EQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DrPIJnGN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757050174; a=rsa-sha256;
	cv=none;
	b=YzVZlMcMzILh2C0NAAGbQzZXpiC8rRq7cGtNmtwJsMEm+10AhknLFo7gSt4X8N+hu85BrG
	+qOTHm/vWoK6TNkZO+JgUrOQg/BY5K/jSs/c4ioWALWKRc+touLr6w9lwrcIEDuwwhGlQG
	Zi1Bc06V5ZHtnWiFkJJcUEyJNmUrC0Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757050174; x=1788586174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+GGeWtzOnhlywY1SautnLIfVlb/W/eBi0k6tGAU9xmE=;
  b=DrPIJnGNRvfAVtsryRNBKNrEox4IZW9gjTzgqkPOdu79e93k0cJ9iGOc
   gq0KrMGDHdQE/IFEjKvt8KMudLp3yEoytfuCPvEzxECBEv6o6U2zhu93Z
   jGg2f9v1Ykmbyu52VPbMCOx1qZtfeLVtn83ByB/+wy1zgJwnR/B2H3YcD
   SsnMbLzXQcjJkVlDKsysSkQKIu1eqkXbIpr8JQsia4mRHm52hL5B3jQpT
   RpT7Ror03I5ZAhYYIbIvypwjj+kMtAyIx1kWCCJIc/LmjG99Dtf/sQsLJ
   PGgDjX6bUUySIEoVI6jmakbcRISzWVl/SLRI54azv3IFO5zWJReZA0p31
   Q==;
X-CSE-ConnectionGUID: QUpQrtwETsiD1U/ejnZvyg==
X-CSE-MsgGUID: vq5BhDrrRKqgWghs6D8AZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11543"; a="59509165"
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="59509165"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 22:29:32 -0700
X-CSE-ConnectionGUID: Zu57G14KQ228dbPwUZN39g==
X-CSE-MsgGUID: QRofuRMxRbCSJ9Zg5SFtLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,240,1751266800"; 
   d="scan'208";a="176412850"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 04 Sep 2025 22:29:27 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuP0m-00003X-31;
	Fri, 05 Sep 2025 05:29:24 +0000
Date: Fri, 5 Sep 2025 13:29:20 +0800
From: kernel test robot <lkp@intel.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 5/9] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <202509051316.Hlzf9HAw-lkp@intel.com>
References: <20250902154630.4032984-6-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902154630.4032984-6-thierry.reding@gmail.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0AE49100009
X-Stat-Signature: 7fijfm5knsfqju91536qjggfse5995i3
X-Rspam-User: 
X-HE-Tag: 1757050173-633298
X-HE-Meta: U2FsdGVkX18UPFdv+hcu3LnZUi6N3G9RJn/D/16yx0PNg5D5MBU5Z/nURcdKAkrY2R3jSPx72RZjOpnhfBis1cAfVYpHe9XqipA2+jAgRP4K72Iqq+TdrM5e/lfqlJA+N7tk1B45uRpwNqf1t3o1VBEhYXMilUNlXvKaVaJ2/rMZPempwYnaRoOpZMxvXeTqjHrrN/Kd49SwGqql/syoMbgpAwrSJsBR8hHdMdKXno4brP9vbZ7xyatqu4KVsHTj/LMA4b5G0fuzbJQTbUtCIN+if6Vq2C0DksglRTh2xpCpw7uTQ23DFgg+UsudyIa8eeSPTUpo8hiuddBaRuPjGW7X42yD/lB7RImfvul6APjNef5ZywVvWn3XSN/pxkvM1evHnDNMLLkaFiBNf1fjJTuYYv931CWNwU2s9MFfLNA+DD1hmBBVSPHajX7ZYy4G/dVmSgGv1Nsxa3EQorFMSpVjqAFgmX7rNAiqlhx7uTA6V1yfGBY9qcklyGYR+zrZuwMd7rqsa2tpUV49Xfk6HGaALrstzvIkmXRpPiiS2dXl7F9i3B8kPaQaCBpgoPflh/feYsMZHemyaCCKBXBSYhm9vAQYPmJBkkU9pUu/Y6mRNBrBh7mjF4LY9UrtBxIg0ROwIhxwJmT8IJzYsq9JO42Ie933mizKNoXgeoUtOz5YIc9Wwcc76LFzZM7JCVIeVNuGAN41/WWokqlovsLLKUWfFlLBC0s9HC7o4pTxjlKcqqdEyG6/Yp7UL2g1Qqc7dlviTF+a4oAggslg48sBNPcMoCLxpZLH598FjxdRkhbRfdAz7ptXAE05CTBixl8QN7FS+MnuafQzPJDv2kVj1Zo6dtLquPJbLnsoA6/DJD7iMEI4How4un1GfkLYiqMi89oFveLl3K3DNiKiMwEM7/Zf+Bv0gZJZDiqmkf4UOQGM97p/wbr+WUTcbW07vmyoIKdjFg2a1JLj9l6FQyE
 t5Dte14B
 zlN9w2Xxo1V007JyckMmX64jfgbq5ZFcgsCDz9Joll0RH5sTVaseEyUGwomuOb86lAY7HKTNzfP3L/rECZTfjEPNNtfviBmXRb3RyJ2vxU67jxSOWXq4KFxFuEO+jlt+5brWELGXXwW3ug2r5J/+KbqrN6xwxavHmRL2qWO9rL2P2ukIcSJYHMwpR/eeMeDOnN/y+qa9GOAqM2Np6wRhGNmUBMUTj3Plh4m8uIcEW8X0Ln05raxjlD2CIi+kt1C2oc69djG5uS3lvAMkS6o1k5+LCSE6jMyGN3BXBj9KutgjJ0HkGMAJTpz1rseJRt8lV7KsgPrsrXK7Fx92DPtl/BUyjL6cs/ewX/os0sgHsJPXNbFMW3LtbF4hGySdDp18t6l5R6d7uyqqnWm99+GgzzStobPUo6I2HloIR2ZvgxHcKCmWMHT62FLCLepcDIjLjX/u32AUbw38rUkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20250902]
[also build test ERROR on v6.17-rc4]
[cannot apply to robh/for-next akpm-mm/mm-everything tegra/for-next linus/master v6.17-rc4 v6.17-rc3 v6.17-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Thierry-Reding/dt-bindings-reserved-memory-Document-Tegra-VPR/20250902-235038
base:   next-20250902
patch link:    https://lore.kernel.org/r/20250902154630.4032984-6-thierry.reding%40gmail.com
patch subject: [PATCH 5/9] dma-buf: heaps: Add support for Tegra VPR
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20250905/202509051316.Hlzf9HAw-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250905/202509051316.Hlzf9HAw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509051316.Hlzf9HAw-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/dma-buf/heaps/tegra-vpr.c:158:26: error: called object type 'void *' is not a function or function pointer
     158 |                 err = pm_generic_freeze(node->dev);
         |                       ~~~~~~~~~~~~~~~~~^
   drivers/dma-buf/heaps/tegra-vpr.c:175:24: error: called object type 'void *' is not a function or function pointer
     175 |                 err = pm_generic_thaw(node->dev);
         |                       ~~~~~~~~~~~~~~~^
   drivers/dma-buf/heaps/tegra-vpr.c:192:14: error: call to undeclared function '__ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     192 |         pte_t pte = __ptep_get(ptep);
         |                     ^
   drivers/dma-buf/heaps/tegra-vpr.c:192:14: note: did you mean 'ptep_get'?
   include/linux/pgtable.h:338:21: note: 'ptep_get' declared here
     338 | static inline pte_t ptep_get(pte_t *ptep)
         |                     ^
   drivers/dma-buf/heaps/tegra-vpr.c:192:8: error: initializing 'pte_t' with an expression of incompatible type 'int'
     192 |         pte_t pte = __ptep_get(ptep);
         |               ^     ~~~~~~~~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:194:36: error: use of undeclared identifier 'PROT_NORMAL'; did you mean 'ZONE_NORMAL'?
     194 |         pte = clear_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                           ^~~~~~~~~~~
         |                                           ZONE_NORMAL
   arch/s390/include/asm/page.h:122:36: note: expanded from macro '__pgprot'
     122 | #define __pgprot(x)     ((pgprot_t) { (x) } )
         |                                        ^
   include/linux/mmzone.h:806:2: note: 'ZONE_NORMAL' declared here
     806 |         ZONE_NORMAL,
         |         ^
   drivers/dma-buf/heaps/tegra-vpr.c:195:34: error: use of undeclared identifier 'PROT_DEVICE_nGnRnE'
     195 |         pte = set_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                         ^
   drivers/dma-buf/heaps/tegra-vpr.c:197:2: error: call to undeclared function '__set_pte'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     197 |         __set_pte(ptep, pte);
         |         ^
   drivers/dma-buf/heaps/tegra-vpr.c:197:2: note: did you mean 'set_pte'?
   arch/s390/include/asm/pgtable.h:1041:20: note: 'set_pte' declared here
    1041 | static inline void set_pte(pte_t *ptep, pte_t pte)
         |                    ^
   drivers/dma-buf/heaps/tegra-vpr.c:205:14: error: call to undeclared function '__ptep_get'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     205 |         pte_t pte = __ptep_get(ptep);
         |                     ^
   drivers/dma-buf/heaps/tegra-vpr.c:205:8: error: initializing 'pte_t' with an expression of incompatible type 'int'
     205 |         pte_t pte = __ptep_get(ptep);
         |               ^     ~~~~~~~~~~~~~~~~
   drivers/dma-buf/heaps/tegra-vpr.c:207:36: error: use of undeclared identifier 'PROT_DEVICE_nGnRnE'
     207 |         pte = clear_pte_bit(pte, __pgprot(PROT_DEVICE_nGnRnE));
         |                                           ^
   drivers/dma-buf/heaps/tegra-vpr.c:208:34: error: use of undeclared identifier 'PROT_NORMAL'; did you mean 'ZONE_NORMAL'?
     208 |         pte = set_pte_bit(pte, __pgprot(PROT_NORMAL));
         |                                         ^~~~~~~~~~~
         |                                         ZONE_NORMAL
   arch/s390/include/asm/page.h:122:36: note: expanded from macro '__pgprot'
     122 | #define __pgprot(x)     ((pgprot_t) { (x) } )
         |                                        ^
   include/linux/mmzone.h:806:2: note: 'ZONE_NORMAL' declared here
     806 |         ZONE_NORMAL,
         |         ^
   drivers/dma-buf/heaps/tegra-vpr.c:210:2: error: call to undeclared function '__set_pte'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     210 |         __set_pte(ptep, pte);
         |         ^
   12 errors generated.


vim +158 drivers/dma-buf/heaps/tegra-vpr.c

   135	
   136	static int tegra_vpr_resize(struct tegra_vpr *vpr)
   137	{
   138		struct tegra_vpr_device *node;
   139		phys_addr_t base, size;
   140		int err;
   141	
   142		err = tegra_vpr_get_extents(vpr, &base, &size);
   143		if (err < 0) {
   144			pr_err("%s(): failed to get VPR extents: %d\n", __func__, err);
   145			return err;
   146		}
   147	
   148		if (vpr->use_freezer) {
   149			err = freeze_processes();
   150			if (err < 0) {
   151				pr_err("%s(): failed to freeze processes: %d\n",
   152				       __func__, err);
   153				return err;
   154			}
   155		}
   156	
   157		list_for_each_entry(node, &vpr->devices, node) {
 > 158			err = pm_generic_freeze(node->dev);
   159			if (err < 0) {
   160				pr_err("failed to runtime suspend %s\n",
   161				       dev_name(node->dev));
   162				continue;
   163			}
   164		}
   165	
   166		trace_tegra_vpr_set(base, size);
   167	
   168		err = tegra_vpr_set(base, size);
   169		if (err < 0) {
   170			pr_err("failed to secure VPR: %d\n", err);
   171			return err;
   172		}
   173	
   174		list_for_each_entry(node, &vpr->devices, node) {
   175			err = pm_generic_thaw(node->dev);
   176			if (err < 0) {
   177				pr_err("failed to runtime resume %s\n",
   178				       dev_name(node->dev));
   179				continue;
   180			}
   181		}
   182	
   183		if (vpr->use_freezer)
   184			thaw_processes();
   185	
   186		return 0;
   187	}
   188	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

