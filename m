Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AF19D2E01F
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4956B0132; Fri,  5 Dec 2025 02:45:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855116B0133; Fri,  5 Dec 2025 02:45:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745B06B0134; Fri,  5 Dec 2025 02:45:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60D5B6B0132
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:45:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2936052059
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:45:42 +0000 (UTC)
X-FDA: 84184632924.06.26D7E17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6685420007
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:45:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPgNeUDm;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764920740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFkK1KUqIVxQey7VhKAhtZ9Q/1myuzJnZ71YgsvtbSE=;
	b=IslMw5uo8UOJNYe8LaSMk26ILdXFyD+ZLJO8p7OGYTq/SNRxaxoIl4eClJsA62Idf3omZa
	KHwE9jowFzfdCAC3EjtOX91utRZmVOYj2o2noCi/v1SqwXAfOhCySYeghXPJ0SRalaWoR6
	1Dgu92ZWROOfyz6gmJh+3SmRdrX9YjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764920740; a=rsa-sha256;
	cv=none;
	b=dtzwOG6hTaSAjEuFtuDs7wgkSqySNEmX9MK/pCT6Zrhq8STl5XpYTydcDbKWGESCHa+csS
	Cei4v5DJk2zbuFRGE3dzFpUZCFPMZWEZcJvZ53y8x2nnjWfKLdnh+fOOfSmyswPtzuS1DW
	eSsJz+npL8rj4/S1CqFUM6kRjo0umNI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LPgNeUDm;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764920739; x=1796456739;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WNOp5BfXP7vsIwnY3VUCFcqhsa8pHGlNLBn3Wgn/K1E=;
  b=LPgNeUDmHhb9EnmCkm3fWxk/a+a6hKZXrCHH7VK9yQOf0wY3F8mv32ro
   2XjHWKE5NH8uU9i2VmvfEA4HxoR4GslGD8GAy1yIPxHEYBK9ZEKgSeVIw
   DLuTRW3/ToLsAeQTIPpwDWXMF0Nvsz/Mky596c6K9+FaXF/LtfDubFuyg
   PFOeXdF7mb4/3/rK7c0h8UwnvjNbiYxzlh8Tgq+0Ko9GijAYarH9g7KQH
   q6Z3hm3R6AJ4YNlyAYd2BZ66j1fVgBMAEXmKD6NA5d53+9iBk1/aHnA/x
   kDDU514Z7SFDO8Awlwof64HEN95QIg4Wmebd3OR2tbang/JvIGk885slM
   w==;
X-CSE-ConnectionGUID: qMs4NIFJQReGZl1G2se3WQ==
X-CSE-MsgGUID: DwaJPF7sSzu9W6kjt/QBug==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="78304977"
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="78304977"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 23:45:38 -0800
X-CSE-ConnectionGUID: xOf9AzaoRc2LvDI67wtJnQ==
X-CSE-MsgGUID: xMR7Dl+RQeG5HC6ZP8b+Fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="196025418"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 04 Dec 2025 23:45:33 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRQVP-00000000ElB-0rHZ;
	Fri, 05 Dec 2025 07:45:31 +0000
Date: Fri, 5 Dec 2025 15:45:13 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>, Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com, Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <202512051509.bh8Oncoq-lkp@intel.com>
References: <20251204151003.171039-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6685420007
X-Stat-Signature: ej1m5kiran18sk7e97oet5k8eibbrpcf
X-Rspam-User: 
X-HE-Tag: 1764920739-294726
X-HE-Meta: U2FsdGVkX18D8b6+OXMrn5cFIMubhT6NcK4zTnl81Ept13FBsIopM0TPZH33CHRHTYB9pqzdiQze0jWA0KzXiIzeAh6ZnpBuFrWH+5JNKjKJkFQz2PFgTtUjVewUNKgPfCCLNUUFrhnrL2l6oGcmtEwkrePA1c5QwI35CSgIp8ZatVBPQYh9lDUELrlclajpeX4ZS0TJoE0zZJNFaI/aosMO7cKhq7RHEGu1yf1j4ExRJnfdMzXcSAVC98ZACH4f3+XwdqOaSYcmiWH5og495lJXcf2RrSCLG7CWV5XKQ+ntSr5h+Ffium3c8x+91LHT9xBZPCYJ5jyjuDBDg/bMvWjVp33GfMEwSbv2ttlAQVVErQpMl/ccHk5baQ3L5jPpKnWsaNnTo7O4Ut/JAsAeEclxo7QOnNSLnqfXmse4wTL4917cxOng36TL4V7SLZslaGvZh65zlWxs1TD6HOHpUQb6pl564GLfLTgbIU/6nOoy+TD/NdtGGYdzja1K9RnN9hQF8r0olmf81wltwzlSI17MltacsiHr0BwMqC8WCcosRwZq6kD/vP1l+unI4s0zyuH8SmuLweq/GO9N7uIylt6AlLu4sZFWNgj8NYL802jCwngF4Ql7CkOjZRPlSzkKduGQM+TAFUEqJjZC1hOycDwPpooXE7hiAgFJ3ME4Hd4H+D+D+fSljztIgRaqR1rnld67HA/yW/zpkw8jgjlBzyvJOZ+OcRQdbaa13Urqqe9ox3CKb4iFcy91qh/b2GyOD7DFR9DDg4b0/xaYRvwVT13QVhIvkus5YLqBGwoQFda/CEg6lJF0VIggGV73WNz9co9z5OXOJ3A0C7Bztn0lGUxpaXpj6QuQi0rjuVSOSmbz849Q9S4WN5hBQOS/UymOrdxiuDAHTdm4mHDqTr+O0QIe/ha88UcdtmmXaxS7WIzNMgNRsa0uYKJmqvvdgUTu/7LhAbl+uim5Wc23SHZ
 JYrh3k5N
 1QDTyhPa6Kp5Jjy+MafQiE1i1G2bvoG8jJLFQNA2eOTFttMfUQcUL0D88Q9mW3gfFqNrlKGk1VoumCoTLKk6pdpZ73BUFkg0Ytbq+Q50YJVi5ZupsMw4TjHmryLjpvuHEay4QkSe3CS0TZoJ8qbMMQ4yWKi6iNeumMYF5WC8QFf/v8+ScdTgOiqt0LYXLFQkDnfutpTAX6a5ytQ/zBp+puNjDObyJKENTK6P5bk9yBhLRMhU52ystFm7LnNwUaB6hTAp93t5ASXBqjM01WMzNQLejAUWOpAqa0zuumNmK2XQ5F5mM4qVNLeEehw5+my2LhWgBGwGw3goIfi7hriCAyNE+3N63/+UvteT6r/glUJTAw4cbMZ08b53gbdiMTuSXfLMGzOhGpFmAl4q05lR9mfIUmeMrrHxz1PGZCWnAmCuc7E0FyBY8ZQD6oMOByNgFL5V0iM8HWLJuddX8D1HZhbF7xcZUEQ8aoH0B2alFuq7LXY0QekerFcnlozDU09biPIuSgFnGzE3BsE2VPKzeZW4+hV7cx4KbwpCX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

kernel test robot noticed the following build warnings:

[auto build test WARNING on awilliam-vfio/for-linus]
[also build test WARNING on v6.18]
[cannot apply to akpm-mm/mm-everything awilliam-vfio/next brauner-vfs/vfs.all linus/master next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-thp-Allow-thp_get_unmapped_area_vmflags-to-take-alignment/20251204-231258
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20251204151003.171039-5-peterx%40redhat.com
patch subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
config: i386-randconfig-006-20251205 (https://download.01.org/0day-ci/archive/20251205/202512051509.bh8Oncoq-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512051509.bh8Oncoq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512051509.bh8Oncoq-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/vfio/pci/vfio_pci_core.c:1670:44: warning: shift count >= width of type [-Wshift-count-overflow]
    1670 |         req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
         |                                                   ^  ~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +1670 drivers/vfio/pci/vfio_pci_core.c

  1642	
  1643	/*
  1644	 * Hint function for mmap() about the size of mapping to be carried out.
  1645	 * This helps to enable huge pfnmaps as much as possible on BAR mappings.
  1646	 *
  1647	 * This function does the minimum check on mmap() parameters to make the
  1648	 * hint valid only. The majority of mmap() sanity check will be done later
  1649	 * in mmap().
  1650	 */
  1651	int vfio_pci_core_get_mapping_order(struct vfio_device *device,
  1652					    unsigned long pgoff, size_t len)
  1653	{
  1654		struct vfio_pci_core_device *vdev =
  1655		    container_of(device, struct vfio_pci_core_device, vdev);
  1656		struct pci_dev *pdev = vdev->pdev;
  1657		unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
  1658		unsigned long req_start;
  1659		size_t phys_len;
  1660	
  1661		/* Currently, only bars 0-5 supports huge pfnmap */
  1662		if (index >= VFIO_PCI_ROM_REGION_INDEX)
  1663			return 0;
  1664	
  1665		/*
  1666		 * NOTE: we're keeping things simple as of now, assuming the
  1667		 * physical address of BARs (aka, pci_resource_start(pdev, index))
  1668		 * should always be aligned with pgoff in vfio-pci's address space.
  1669		 */
> 1670		req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
  1671		phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
  1672	
  1673		/*
  1674		 * If this happens, it will probably fail mmap() later.. mapping
  1675		 * hint isn't important anymore.
  1676		 */
  1677		if (req_start >= phys_len)
  1678			return 0;
  1679	
  1680		phys_len = MIN(phys_len - req_start, len);
  1681	
  1682		if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
  1683			return PUD_ORDER;
  1684	
  1685		if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
  1686			return PMD_ORDER;
  1687	
  1688		return 0;
  1689	}
  1690	EXPORT_SYMBOL_GPL(vfio_pci_core_get_mapping_order);
  1691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

