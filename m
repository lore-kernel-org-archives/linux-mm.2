Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F16D116F1
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 04:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66B26B00FD; Thu,  4 Dec 2025 23:34:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E696B00FE; Thu,  4 Dec 2025 23:34:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B086B00FF; Thu,  4 Dec 2025 23:34:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAE656B00FD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 23:34:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6380AC0449
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:34:04 +0000 (UTC)
X-FDA: 84184150008.27.151C9F0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9590510000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:34:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O3I0RVdW;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764909242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3G/QEAEYc+ywMLy+OS2bRbGMYJ2zdM0MibhSvFFqAI=;
	b=clk2Azcfm40c3mO7TuV/q1yPN/iMi8qaj6VsyM1S/06AGgEC2IRVd3CxMrMSgFjFinOqUr
	Tn4xGKw2QGrqrz9xmpk4SfeGtoU8xpAHjRA8ECfVj1cHJeUoVjWWjgD8d6KlUkgR7Oi0Yc
	hZujJIbInMsdQDd7eGSwM5HOkV7GE7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764909242; a=rsa-sha256;
	cv=none;
	b=fu8V/xOScTTydjBg7a5yGY7YVeM/XxwqrvPZCaLIhAxIX2+Zz5X8Oj3biU+i8A6bz/LBRR
	MxJNU0Nx+VdVKBfit3d4tiUOwO9HnvRz3ORl78jnHsJexlsXc8aCBjPHMOFVaQ9Wi7NVG4
	BJqW4X5kuGhBqcvtL1sTYceXNrGRFIg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=O3I0RVdW;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764909242; x=1796445242;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aIXWLsK16waG7MXWO7e8zEfJ8XBA/lm6NJ3ih7dA7wY=;
  b=O3I0RVdW2E9wBwk108OH+Alno7UfIxu2q9f/WFNM0lWDfr9byiTcFTcQ
   9VzEsP14iH/LTqd0udOYNU3DDGt9HDPLX/qGHlo+HOOpPygSfqCh43R/u
   ctftf1qbamJ8mmz1Nvz//cho8vrQDhU0yL+5b0/JQL1XqEpHe4Mo5pkfn
   5OExAjuOquPANA5YYxcz5MDDYLiE+Bk7apZGcErU07/7HR5dsDr5EkvGZ
   3lDa9sPoBJfjMfT4QC+inimwvxNrFC7d135PIpZVi6gancj1Ev6p7lWm6
   D6nOSDFwU9xml7cbEGUpMxFOb4mm9Bxw+VUox0RppptOVJkEOBZ+kfek+
   A==;
X-CSE-ConnectionGUID: 814CWovFTAmGIQukJ8XxQA==
X-CSE-MsgGUID: 6GQtT2uETXKTA13750gloA==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="70790464"
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="70790464"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 20:34:00 -0800
X-CSE-ConnectionGUID: KFDHs5pbRk6nNvnHN+SREw==
X-CSE-MsgGUID: Ml7yRMGORvitt4XmZ/muEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,251,1758610800"; 
   d="scan'208";a="195221686"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 04 Dec 2025 20:33:56 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vRNVx-00000000Eao-3R11;
	Fri, 05 Dec 2025 04:33:53 +0000
Date: Fri, 5 Dec 2025 12:33:44 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com, Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <202512051241.QtfYgqkx-lkp@intel.com>
References: <20251204151003.171039-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204151003.171039-5-peterx@redhat.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9590510000A
X-Stat-Signature: r5wmey51aoqytwqrgxgso4b6ko9b84ss
X-Rspam-User: 
X-HE-Tag: 1764909241-231555
X-HE-Meta: U2FsdGVkX1+mAm6rPX36nWNKYRUJIkQfGgRo6/FB6QMO7LjSg4ogsCpYFeHNkt/BBYiE7fApi3sEyxOaACSDf5TzCxXzqQYmNGNZ1CnsDBB3f7Ju+Ku9vsmX79NNgqzMMrNwvAppLgLOK0pVXAO9/uidTCPyERdA2PsrKXz1UBuT36dOKBjdtwTcq27im53lek5L9nzBsOwR3WJiQI6oipEMXpoIDhNVfD8JyAvwhapwwwVbz0JFPaYkvpr2rOtVTkMDKaQVWikD/BI6HCKJRa51NXwgbj+NEp4RXLrrMdNMSAQlNOK5O5ogfFneG6Exw2GtOz2A6so7nHMDrlzcPZ9MoLe0tFi3o2lWlGhBEid3Yvi++u3GB+Ef1jiW6DgoWk4U8yQ5SpDy0hChUqAyOr6Q61Fyyv8KO8N/jm5t9yg2nSth/PkgVPOxiIUGnUvuyQdq8NHP1o32tlf6mUu8xho37MN3/ku4RK2cfVCPYFtGiA5bG1ixk//691qdAar9fm0mjYgyATXs+F2u7m5hTmAzKvHTONDJ1zyfrStxqksdWO+XB8c4zg+N0wH/o9dOPvgXAlYm6JuVhf3bgfOKqO+cE0r5H8E8diEcEQEneguUmJVPeP/TtkMUbyis4R40XZsklck75Pj8UqmA4gkosiWqwA/FqzuHqyca1BA51aFe5upZq3SQG/2DNMdCwg9rFGbtYhCzfrG1vFfGElZDzPvYErDsAsBp8Q4ZQ15TIVRpshigs7HB0opnv4MLO2/nuCqKzStNiwkzDO5FQ2QaJ0NVjaHOlbqM3dmPSaxqkQBIMS9gWBLzMnPi6z9hLOiu76vBGLCH34eVgHP2dQXpcCgwWNlj/z2KKzimxZP02X4RBblTmij8onYEMlCPh/couomH974VnOPi/xhpIdE89uzz1NFJv0pTXSbQTW3Y75xxdbmc8SbGbL9i+wY3/kUEQjbVNiuhLCGTZEIKTDw
 /RttFaxn
 bdmVTM7lZsV9uxFb7d8a7D06SvjxVEQTG9qsuLqDS3Wx6pQbQKl/DGZAbCnUVaN0ArSjZeU9rQPm6cyrBGTMZ+8aLZAHRhntzz4+BRi7+h4EpwISoeDBakeLNho3VvhcQSwzW+COYD9JGb74ZIrFrsbS16Av7QMpTqCovTDCB1bBrmn+tRi2V6ZF1dXVJh8LUgnJ5HGPnG+M14UI9QnXF6+YVz0DSjJa9E9EW7gk+D0KQFAtdfHaU4pVSQCjE6UZ1dm/jvMTKHLUMkbyqHeyZEp/7hOcw2I+yo/hCu0hHHLDXA+Il2b8sqJfRzgatKk6K5IPBn6Du1AyV0TO4/he1OuE/77uWUtdkzunUbBHXBulPsw4Jeisv8e9532KO7eP9lcAXM+26IFQHVjGhUebW+46E/eriBhROfjvhrUyihUDGrJjre+T1QOkW/1B74LXoLcur0c52nFSs9hkdpAlk9lGo7WXQFujANfnjI3pEg2XnCrTmpZE/H4vB2EcioWz8D2BZbXetnCp8/sXSP9qzHQ2SIV9t1aY3/kcl
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
[also build test WARNING on linus/master v6.18]
[cannot apply to akpm-mm/mm-everything awilliam-vfio/next brauner-vfs/vfs.all next-20251204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Peter-Xu/mm-thp-Allow-thp_get_unmapped_area_vmflags-to-take-alignment/20251204-231258
base:   https://github.com/awilliam/linux-vfio.git for-linus
patch link:    https://lore.kernel.org/r/20251204151003.171039-5-peterx%40redhat.com
patch subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
config: i386-buildonly-randconfig-004-20251205 (https://download.01.org/0day-ci/archive/20251205/202512051241.QtfYgqkx-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251205/202512051241.QtfYgqkx-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512051241.QtfYgqkx-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/vfio/pci/vfio_pci_core.c: In function 'vfio_pci_core_get_mapping_order':
>> drivers/vfio/pci/vfio_pci_core.c:1670:51: warning: left shift count >= width of type [-Wshift-count-overflow]
    1670 |         req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
         |                                                   ^~


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

