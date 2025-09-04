Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FB4CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0B68E0009; Thu,  4 Sep 2025 05:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FBF8E0002; Thu,  4 Sep 2025 05:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC5A8E0009; Thu,  4 Sep 2025 05:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89F0C8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:38:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ADC813BE0D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:38:13 +0000 (UTC)
X-FDA: 83851066866.22.3912508
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf03.hostedemail.com (Postfix) with ESMTP id 570EE20008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:38:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kJFsqIdr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756978691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXmjjeD0lAKEPrTViWbpBUmMT3X+JeUneOosrIyrrOE=;
	b=KSWJuc35O+MekXDUr+7O2qa4s++HkeYn5VAWcBgP9gfrJfbiTzsr7ZfJ5md6FObrblZ9qp
	5LSWKVq3ttP1VX/6XKormojnI0S2FE27Qmk2u/XzCEYmNITlXwSERCjt3VOnzNHxWupGIm
	mdfgb2WaNw18hQN0n0OJfSBAOBCKo64=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kJFsqIdr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756978691; a=rsa-sha256;
	cv=none;
	b=r5nF1tvwPr4Ca3Oeh15CD/hx1yKZ0I99hkd0VdIic/qYG9RmvKpsj+XbbBi/zbaio/t/CV
	/BzSAGv7xyAu/spIITVngacXK0neNIrI/GnNG0PifxXHT3sCraJUlRIZEy8EhV4Ur9xuI7
	swb9BhNk54iNCDBsZjCTRHNd5l7aRnU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756978690; x=1788514690;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=K2roMTDLYdK6snjjQKgov43nRYmQIvretg5aO99t3Kk=;
  b=kJFsqIdrBSE/G+25WbWoBlFJmEZ78ODcQtd8nzV/r7MpQtXoAHFqQGAa
   LICQhG7Bg/Y3dO9o3ME1soI1Wzs2w4V89YMNTDoszP0QDTgULz1n5G66Y
   PgKMQkrkU8tD5TmSNkN9vxBC2UrmsZzj1t2EDjAjPuCNUTWwWb4HGASe2
   FY4GEKcTWlOrI3NNM4fHL3/EuuEt+3jVxqhTLFe8QIMHMS7YhTgZbzwTk
   82F5ccyrQ8pEswttB892ndIlclUueSKYlNnMs9OEN7NX84tjnDcLdQdGG
   eKPk9UCkIiNcXhkWDtSeDTRXapOKLHn1z+SvqNMpXN4AKOtLBf/4J34Ob
   w==;
X-CSE-ConnectionGUID: QwGwMfMES8iKzV2GrO2C3Q==
X-CSE-MsgGUID: 0LfYfrxlRi28iO/+2ZMhHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="69926153"
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="69926153"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 02:38:08 -0700
X-CSE-ConnectionGUID: xspA0gIYSpSDftwk10r1cA==
X-CSE-MsgGUID: hrUIlaOmSLmIcge8I0Ymgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,238,1751266800"; 
   d="scan'208";a="209028838"
Received: from lkp-server02.sh.intel.com (HELO 06ba48ef64e9) ([10.239.97.151])
  by orviesa001.jf.intel.com with ESMTP; 04 Sep 2025 02:38:00 -0700
Received: from kbuild by 06ba48ef64e9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uu6PE-00054F-11;
	Thu, 04 Sep 2025 09:37:32 +0000
Date: Thu, 4 Sep 2025 17:37:09 +0800
From: kernel test robot <lkp@intel.com>
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, damon@lists.linux.dev,
	dri-devel@lists.freedesktop.org, Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Ralph Campbell <rcampbell@nvidia.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [v4 05/15] mm/migrate_device: handle partially mapped folios
 during collection
Message-ID: <202509041732.UTJsw3LB-lkp@intel.com>
References: <20250903011900.3657435-6-balbirs@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903011900.3657435-6-balbirs@nvidia.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 570EE20008
X-Stat-Signature: 4iuhkw9qs6t4s65kijg5feemjiux8ujr
X-Rspam-User: 
X-HE-Tag: 1756978690-748188
X-HE-Meta: U2FsdGVkX183tCe060kWVVyIykV3s88nxQtl5nF47XHa9oexZVr7MsakwChuQJPq0hJTadM9YaZWZHAPuT9eO4peixF7i0iFxkVzFIysYHPGSKOnOjU40fyX2FeGRq0IO/juwvy9nyzxsL3E1BBL5CAXF8kneLU52hIH7N817w4P2ae3y0COdzDPG56jUuoC2oXTUH86GXuEghxrJhkdnp0ymjK7+3a2Y39n+b6YO+VIpq5uFtXy5YRBfse3yTf1HWywN8L2yJVEz4avEe1HcjotZhLjsFo7RYd/GN1Sw8RwkpwxPlUROrz1W5a9VbUyNtxgMy6Mylgxd2qdUPzjE6g7/7p/bLwgWpQf5R9XIUY7zsNOI2GLOqU7WxxgSTskM/35qotlNWBWOF+2NCbhjRzq/7BRUQjJFgNQeiM5YIYAjXNGfE2pvVE6M1qQJmyrItVztALq+WwySWwlillLgsYdRpXwMwOAml80g6+WUXD9NLlx5E4Z2I1/e1L1V+zl3z8pdMgr73yqco7VNCrRd6Rbi6PHpXw47htR3amMixe26j+Oyk35SzposmAVoBNZ1UU2JIIrxyb/+13WxCyCL7S8eGT5w5A69AKyAZQGKsld6hPA/JV8Bw5siwUatxWPSD1bZD71o/XZ8L45P1rlf5FAHNNdODB3/89LRHNQYp30QCfJc2qkz08mnbTDgY5Vp3TO21ZOu1eoF0dudvj7VzyjGrLSYUl8uD2RKSlZjiWR454acuilnjJgwEB3mUHinPIbAapuU7+AvHKMaPE0pySKmHqIOWogjrM57Mq6UlSVWjwgyZg+PyuHhRas0XnZcIHAGXd9C+rucpnYaBxY+PYoVj0nX/xhxSAWN6xhX+yntvi4US3o2vwVXLrD/uZotO7zw61Sdpy4Xfg+xalumxx4CIpMvNzUjKXzl8mVXeCvgNAmU8aA2s8VGoJjtpLjBs/BLqugNDEFNB6maKR
 I0J1IEpD
 w0qiRVQwv9BRsXFQivBEBTnjZlYAm45N4oACBYMBpbMaGG3+n6tg2RaM3hcv4ilpF+JBGei7ncPFimj4q3yw/9C1m+0UwNuKxFlxX099FjeSF+HowkE92wD9xqg88ZeUyJQEzDj0r+we0/Yu1BaFV6rB1Gn7XkHdAtbOzO8vEWIUzTfxblv8V4Lefmji5PMiEvJhafccQ8IfSIc70Vl+NMFPvbbcjMgY67vac82QWDmntMTIlDaSh/Vgvt7gdD+WU/yRrDkqjJQgaI2Xx0g4YlF2cZgOAHAMoef2LrGO6upkp+yF0AwsA/EXvjqrCJZ/khWDsUdRoN24aCl2gVc1PX8g/ji+76SbZdYkBEAFyp8NckPV5XwvJRaWJYbJ9bkIt1PXMLXJQnKLq7LlrTo5OZCPPZfjeWmrxTkbF90o4SFWyMy2bG7pM+CczlgZZqZMDprCFE+n1TRRFPz2a0ESeQZjPq0i2ylObWLsGsdbJwbg602X2LBiMCussXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Balbir,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on sj/damon/next linus/master v6.17-rc4 next-20250904]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Balbir-Singh/mm-zone_device-support-large-zone-device-private-folios/20250903-092241
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250903011900.3657435-6-balbirs%40nvidia.com
patch subject: [v4 05/15] mm/migrate_device: handle partially mapped folios during collection
config: arm64-randconfig-001-20250904 (https://download.01.org/0day-ci/archive/20250904/202509041732.UTJsw3LB-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250904/202509041732.UTJsw3LB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509041732.UTJsw3LB-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: mm/migrate_device.c:66 function parameter 'folio' not described in 'migrate_vma_split_folio'
>> Warning: mm/migrate_device.c:66 function parameter 'fault_page' not described in 'migrate_vma_split_folio'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

