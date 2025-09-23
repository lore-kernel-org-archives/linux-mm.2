Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080D7CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B948E000A; Tue, 23 Sep 2025 03:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6231E8E0001; Tue, 23 Sep 2025 03:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55FC78E000A; Tue, 23 Sep 2025 03:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 45B1C8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:20:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDFA4160320
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:20:12 +0000 (UTC)
X-FDA: 83919666264.04.4D5F726
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf04.hostedemail.com (Postfix) with ESMTP id B25AC40003
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:20:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g0PLu25+;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758612011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQAM5HeB+E2S/wpbN2PwHbZ4/TyMc16X8uDG1CirmwM=;
	b=XnyORj0jUglQwRf7tumvzS0qWrKIVm7ykdzu/e/bTtfViRpD4nOX7IHTF+6HRfSxXOfCPU
	gmsXsWDGcHcx1gyOs1sHXUdLtZc67OklCqOGtBNsJFEm30gg0Xqpn1EgYb5TaJUpdiQqP8
	IU3jtskPycH4rB5YnEMivsONNcWtl14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758612011; a=rsa-sha256;
	cv=none;
	b=wvfgCKdVH31ZUkpLNRKUuBTCMRhD8hzOGt/cGOZaYfCQR/gdrtNUtzNH2rKineVIESco7W
	WMCc+EpZl824qwW5xBkkeVj3BKz8wvTNxiMjYNQCqri4tb6u1973PSP3pIDvLxITvNJxkg
	Q0T/M70cXe5PekxbTliQdhyK/JuTcDA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=g0PLu25+;
	spf=pass (imf04.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758612010; x=1790148010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lwJ9UOqD//PDM/RdW1ujxGd44CcPYvzNz6RKR54u+xI=;
  b=g0PLu25+G28lY7/9/fx1WAsbwJfK+zf1Ht9d9y2vlpRyftOfWhhXd5S6
   Uy+9qLezb17pqQ1p3OV71cWcPwWXW0vkkt7OEjG/XDpy2dKfE57nL55S/
   t+UcwIkMys1zElRdL6OYd5AiDU04FWbaSO/ucQag9qFclYvT2T8ueRtnW
   jaZ4f3PwvymFokrzZq3nB6M6aLf8ZpLe84/COuCG0QSiKQvFKESHniMU2
   okpsPe3N5HKTL/2RxXfvfCsWXMQ0EEMCn+GURQGrq0UZQJZxKbodGb1Dk
   TG0S9H9B6RsGgMg8WsDhG5bfX5+pL9MatCQ2pXAb1y4i6/luVdf1FLKLI
   w==;
X-CSE-ConnectionGUID: YmBokY/xSdm53YOISMEHNw==
X-CSE-MsgGUID: rK8IAu1qQcKxCreQbesBuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="72310791"
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="72310791"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 00:20:08 -0700
X-CSE-ConnectionGUID: Yfyb9R4/Q+iN3TxSgmOafA==
X-CSE-MsgGUID: tJaYf2dMRTq2G+2tFbHnZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,287,1751266800"; 
   d="scan'208";a="181079366"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 23 Sep 2025 00:20:02 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v0xJf-0002rB-2I;
	Tue, 23 Sep 2025 07:19:59 +0000
Date: Tue, 23 Sep 2025 15:19:38 +0800
From: kernel test robot <lkp@intel.com>
To: Tariq Toukan <tariqt@nvidia.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Will Deacon <will@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Justin Stitt <justinstitt@google.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH net-next V4] net/mlx5: Improve write-combining test
 reliability for ARM64 Grace CPUs
Message-ID: <202509231437.exOuF9vQ-lkp@intel.com>
References: <1758528951-817323-1-git-send-email-tariqt@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1758528951-817323-1-git-send-email-tariqt@nvidia.com>
X-Rspamd-Queue-Id: B25AC40003
X-Stat-Signature: hbs15w67yut9acb7qs8cixuxdjc3qdmw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758612009-622221
X-HE-Meta: U2FsdGVkX190mZ7P5cyucIAe8hXKbBDeAKIUWzD6pPbCaVJCUT4Lc9rAs25aBNDWepiGw+GHyU5CaCUoQpoXZgg9DYoIv+P3+8D6ge2sfHix5SQC4lcamfmnaPJPe5E6wsrqN5+B2ZJCk6/NL8lXT/MJ9/kpD6fi8qbK4KcBQpnc2Bsc0eQh/zMYg/8nnt7YoHcmnxpDdHHjXa56g4Ow7dgC1IA2i5OeMqET/346lQAdYwhk5WN/K4wMgRGNcH5542gGM40RvNLv/JjsBt5Ph/pXnCuxNU2+QFQYtMTiFE/MRuhWsu+4oGnr2VGRypLKSCYukvigMTVZ7z8xLQf0EIkkh2Zi5yeC04M0wVOEeaOfAw7mXJ4Qdf4ZypcThKKdEZl8TKRL+ydARyONZEPxD4u8EHIi1T0iiHwe5dZDbtStOUIjKGGKrwGY3OCDxN2nQm/QRItUzUjkDFkSgv8cnFUw/5VwYUBU8+YlBtlz51xyzJdyWEkFAZcfbu08NsaMHO4djEsJ4cLCKFyEpgauRmvnNi4gsgHM5Ec0QBIwMgyC5UFBIwnMAmIhHbb2bmVcqm/5rgmLz+CVWQEW7a18MKGY/ymVFr8ZvcczriYnMPsnGdW73QN+GlCCDOzE16Pa578LP0KNEUe0PSg0obMREvC1dK3OrqFKyGak3+0YfrHi5Lc39ylShCw5V37jDxmKING31gL2or9PPlQhg48HcpR4KkHzB6B0g9w57fN/Cef0i5tUxGbIJ3NCv7+YgNAxN2ziioAdYV/kLm3VxPvIZAGE26cHFBYeAwqLC8IVcgNbLw4qtL+5A0p1KzcdefWaJ8tg5n+xB9eaEYHaW8KPAL2tgBYV5veDJ6X34vYCV5U1ISanK/g7MR9oXL6mMJ/hlPiggyqe/1HR/ppz73qRrFXyofpkQ+mleZVUj6UeycjdUWHl99028GrkwbmsuE/+DasJPb4u6hsm4SjeWkv
 YZjJuf4K
 20Rt2Wgs2GI88Yr3TB3DGfXRw+JcGL4jRdFKBv3ax2/Li8avrBULi+4BEDCu96kVHLnpo7sF1MPsMvfefKx3P6PCljK7Upr6vxIM8QOPnUfeC/GJFm83Rpbo3UmTSGVBVuzleN9MUKuyDSjt74Dq3L5JtBlzN3VyZnyTuaCdMSXeEDQS1uTX88K9HA91nGr7eVsok3wxy59v/qSJp08U4XnhxQRI/YbWNCz2+8HpnuUi4S4SK4DW4AULvWBwo0NKBJy7Fs1/p/WWkCRjXblp9Scy3ESZBPdD1c7a9GgAGkTJDGLtm2mD0gNthGKyl6cUn69tjs1MjlUFgSGKOg7igZH8DDeHUxxRTKvYVzPHlljCBsIWRbgL18pcOjfGmvwFbzvD9wRd+VDq2j2qBAj1GKfpzQTNnnI0F+Nd13pPpX+EcvsGnipJwyCpewQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tariq,

kernel test robot noticed the following build errors:

[auto build test ERROR on 312e6f7676e63bbb9b81e5c68e580a9f776cc6f0]

url:    https://github.com/intel-lab-lkp/linux/commits/Tariq-Toukan/net-mlx5-Improve-write-combining-test-reliability-for-ARM64-Grace-CPUs/20250922-161859
base:   312e6f7676e63bbb9b81e5c68e580a9f776cc6f0
patch link:    https://lore.kernel.org/r/1758528951-817323-1-git-send-email-tariqt%40nvidia.com
patch subject: [PATCH net-next V4] net/mlx5: Improve write-combining test reliability for ARM64 Grace CPUs
config: arm-allmodconfig (https://download.01.org/0day-ci/archive/20250923/202509231437.exOuF9vQ-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250923/202509231437.exOuF9vQ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509231437.exOuF9vQ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In function 'mlx5_iowrite64_copy',
       inlined from 'mlx5_wc_post_nop' at drivers/net/ethernet/mellanox/mlx5/core/wc.c:317:2:
>> drivers/net/ethernet/mellanox/mlx5/core/wc.c:268:17: error: unknown register name 'v0' in 'asm'
     268 |                 asm volatile
         |                 ^~~


vim +268 drivers/net/ethernet/mellanox/mlx5/core/wc.c

   261	
   262	static void mlx5_iowrite64_copy(struct mlx5_wc_sq *sq, __be32 mmio_wqe[16],
   263					size_t mmio_wqe_size, unsigned int offset)
   264	{
   265	#ifdef CONFIG_KERNEL_MODE_NEON
   266		if (cpu_has_neon()) {
   267			kernel_neon_begin();
 > 268			asm volatile
   269			(".arch_extension simd;\n\t"
   270			"ld1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%0]\n\t"
   271			"st1 {v0.16b, v1.16b, v2.16b, v3.16b}, [%1]"
   272			:
   273			: "r"(mmio_wqe), "r"(sq->bfreg.map + offset)
   274			: "memory", "v0", "v1", "v2", "v3");
   275			kernel_neon_end();
   276			return;
   277		}
   278	#endif
   279		__iowrite64_copy(sq->bfreg.map + offset, mmio_wqe,
   280				 mmio_wqe_size / 8);
   281	}
   282	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

