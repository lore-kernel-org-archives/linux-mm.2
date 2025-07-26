Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C83E0C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 10:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD98E6B0088; Sat, 26 Jul 2025 06:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89E16B0089; Sat, 26 Jul 2025 06:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9F626B008A; Sat, 26 Jul 2025 06:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB6076B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:16:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 244AA160A46
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:16:32 +0000 (UTC)
X-FDA: 83706011424.02.E981D4A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 686ABC000D
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 10:16:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EZ8nJ+TB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753524990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i8Zf1zp/ealqhGBavcPjq1WE/FPfh9VOVlz5M2PXbsE=;
	b=lifp1mxyFQp1I/0nbmsqy098ouWrJBjB0XfdtwKpNWH1nR6ZvZWE74iubw7qVsguD2KNUn
	DP2fWPSfvriWHgUgW7orQKYJtJmqD3SXGZ2DwCiuos9BGtg8gaINx3dcnE6Glulv5ZM7Qf
	p82x6aDVjoyvZUCqxs8JeqSSMheMyV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753524990; a=rsa-sha256;
	cv=none;
	b=DX9YeM+umGqh87kUr/WaRqVQtxm16NFN2YQ7LxAIDJOPWrzUlvtfpAHp7vwlN4jPBj5/Nc
	ghVJe8d62BCVrbWTfD8cjkZb9AuhYD/UNlL0yPkWe6+QBrigmp3z5AC8r1W+I3iR6LcqYf
	ufHbFg5AR+4gemFzgqmybFKhAXicScA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EZ8nJ+TB;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753524990; x=1785060990;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W1nUY5JRvORjm+vb1XNGGtov6ZtefmvCdZ1mHgN2mlk=;
  b=EZ8nJ+TBu+d2cZWW4G8LgIGRXb+D9HdiCez2H/zmobNIXQoGOgZWELFv
   VSPmcUYjim54huXbsOgpouovlAo9aD0pqpcR2DhRySdFFcaD1QdFzRrvp
   Vt2b6P14mR1MHeoFoTUsxXEnFXOdzAjIfSbC6uhZ68SQLpIgpCh2m4CRS
   dG4RQIG6KlGVHviufCuIu3c/1dF81Yk6NG3QXEG4LbPsXNs+2a0VmpO1i
   ZYfPvJ5y9zGh+hK36aXaZjwTh+L8vUZ3B1iC4Qs4p0RfGnujEhqg9w/Xy
   M0ISP0b9FNvcihCRb4I4iD9IakLbppbcMbPOWPJ2NRC97Q77u9DJY4LAk
   Q==;
X-CSE-ConnectionGUID: jOwGSD9USBGEThkMBpZapA==
X-CSE-MsgGUID: rV2ag778TwqZqzqiaSiYNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="59646441"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="59646441"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2025 03:16:28 -0700
X-CSE-ConnectionGUID: qT0WqMIBTVuDvvUSqVicjQ==
X-CSE-MsgGUID: A02kl49eTdGcIXBoeLSxSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="161180536"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 26 Jul 2025 03:16:24 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ufbwz-000Lrb-2T;
	Sat, 26 Jul 2025 10:16:21 +0000
Date: Sat, 26 Jul 2025 18:15:44 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove io-mapping
Message-ID: <202507261811.4FJjX1bu-lkp@intel.com>
References: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724145313.65920-1-lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 686ABC000D
X-Stat-Signature: bduxkx5xcab77zn7t6x7ebt45pbe6n53
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753524989-268853
X-HE-Meta: U2FsdGVkX18AHyZp1P/IjWu21Ws0IMGeaLaa/UYxpu++1Y/3HTPValXRqRyF/LqL61D8KwBua6ejrq6w/2h/GDGSsQlhXW7yltOKWOoOKNUlfs7rskPRb2JvEIkbh1czDj8gaWALIdaHTZzrrx8w0eOrnhMtyEt6q424HR2S5Te5zqBp2BHdkGYFM4zH9SRzmPU44Sq5dlsMJ383ACuM9MqDV8/5NMLNlmOpLa04WOcV8S9wRBs9Ik18Qffe4Cx4TGtvm/zqfORNSVSbMNQhYnNLRtrLYFOlcde2dqiG20XvauTEaDawkzbMUTqGrMQXxaN1IBD59S/xVnLsdELndj87C83f2f6J9JpIbTmGsfCmszblnZ2JnLVvYZIKkCjdAoAP6enXhL1CZKIKKuDNo0Flv7NJZ3EAqfojfSVy8eR+d3eizOffGDO/K/qnXp34QdW+5GOJocjefkyaUwOSc9peVVRhFQ0P0eFB/RVKIjShJ9OXJlSzyF19XF9lbe7f2tV7RQpaad7Lv5+4rgYm2KIdb5yjFVOnCH/afbJZBKfzTmljbxW0UHZvZtBC2Wb8Bb+zJ2SYplfYuxeFYkydb95sQ7FdIU7wiBnfSDE8PLtjBAB8cl+ERb1zJwRyGZZqQHmMVGJCBpd+PB0/UtDTBgC6WDFs8W9fzeXC3d/pIYKVVvugesSoqcWGtgG1kSdDRzMKmE4oWJJxUYIf4LC8D9VWMHu3eXX54PyG3Re4RfkEoDAMeOfaEOHIjiMQk+Y+ieB8hsHAFVpCtsXYIYLSpdHD5svnH/eWlG8bTH53siJoaIoGxWmajwsiW4ttsc+3fU47xtmU7roTIqlWj7mXmdHhosGMVODu2hFYyB29iPDVYYa8KVeXx2UUwUia69K8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-remove-io-mapping/20250724-225556
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250724145313.65920-1-lorenzo.stoakes%40oracle.com
patch subject: [PATCH] mm: remove io-mapping
config: x86_64-buildonly-randconfig-003-20250725 (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261811.4FJjX1bu-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507261811.4FJjX1bu-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/ethernet/mellanox/mlx4/main.c:43:10: fatal error: 'linux/io-mapping.h' file not found
      43 | #include <linux/io-mapping.h>
         |          ^~~~~~~~~~~~~~~~~~~~
   1 error generated.
--
>> drivers/net/ethernet/mellanox/mlx4/pd.c:36:10: fatal error: 'linux/io-mapping.h' file not found
      36 | #include <linux/io-mapping.h>
         |          ^~~~~~~~~~~~~~~~~~~~
   1 error generated.


vim +43 drivers/net/ethernet/mellanox/mlx4/main.c

c1b43dca137f21 drivers/net/mlx4/main.c                   Eli Cohen        2011-03-22 @43  #include <linux/io-mapping.h>
ab9c17a009ee8e drivers/net/ethernet/mellanox/mlx4/main.c Jack Morgenstein 2011-12-13  44  #include <linux/delay.h>
10b1c04e92229e drivers/net/ethernet/mellanox/mlx4/main.c Jack Morgenstein 2016-12-29  45  #include <linux/etherdevice.h>
09d4d087cd4869 drivers/net/ethernet/mellanox/mlx4/main.c Jiri Pirko       2016-02-26  46  #include <net/devlink.h>
225c7b1feef1b4 drivers/net/mlx4/main.c                   Roland Dreier    2007-05-08  47  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

