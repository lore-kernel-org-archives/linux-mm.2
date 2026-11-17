Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2345606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 16:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=BdqVL2gN
Received: by kanga.kvack.org (Postfix)
	id E39886B05B2; Tue, 17 Nov 2026 11:51:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11806B05B3; Tue, 17 Nov 2026 11:51:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4EA06B05B4; Tue, 17 Nov 2026 11:51:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2D36B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:51:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD082C0422
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:51:21 +0000 (UTC)
X-FDA: 85445201562.21.0A25CA7
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf16.hostedemail.com (Postfix) with ESMTP id 499EF18000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:51:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BdqVL2gN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794934280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RT4X/T0EuH0TmEYOt+HYB/RGMpJQFe8/Bu+i4DTLK/k=;
	b=tTpXob4mag4iEZO5LKoN/xD8QKPkgCAmNzQbOCrx95/P/+A4q6KOM154S3Q7VcUxrHdicr
	chHH0GBiGvXNoOGrUH6pVZKkyd9i4Z+jkA//YWUE1xs3ozZY0NpZVua+1NGlCT0wtN7Ten
	lfR8VgOPsn9zQmZqVab8N/b2kworDU8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BdqVL2gN;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794934280;
	b=o207hq2ELVEmotOf8UvnVjqHMAThn3T2tudy1yaIze8yDmphepE5Q86+VgwD/4hI8EuYh/
	jClPxW+NGWgOI9X+eVPsHG6bxQudCR13wYdAWBHOU2Msh/x5cQPGePE8hIKAPZayZQEBUH
	Y4VAariaMuZ0kM3uMCnrXQgEtuiGncY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794934279; x=1826470279;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XgS/tf3vpO0tulClCI8eLPUH78J7AQTbpyP5VYST+vU=;
  b=BdqVL2gNRomceLMKaZ8A7prEFqHT1Ae5Ex0herHaKl2tccJLESw84b0M
   OWpSJbaZPyjJdtxV0mLOOZHYwiG9ga+4yi+fzNik4dQWVq6cTiqg30wpE
   rAqeAGC2TzEgNk8Oai6w8uF+JeVPYMkI7cumUskBmU76vF0qFepdtvPes
   S7/ZZoQpecyejlGZbbsmkRNkj8MK3HlPThNiu1znu4uCSDatI5iu7NfGc
   CVC3NG/tHumNbVqUCJaM56DX77aMBisFk6eJk+DD/B86tspeiORUNnScC
   irTgMbpNMUdhD6VBWLL2i2v76L7Wcu4n+0dXcB1OLpAL/sPxxWI9XfMwq
   A==;
X-CSE-ConnectionGUID: eOXuvnhzTluIP90cqAeF9A==
X-CSE-MsgGUID: FsePuSPhRxWjalqEJIYkrA==
X-IronPort-AV: E=McAfee;i="6800,10657,11969"; a="3604021"
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="3604021"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2026 08:51:18 -0800
X-CSE-ConnectionGUID: O0tcxq0VQeyK+L9Lp1UEoQ==
X-CSE-MsgGUID: uCw/BAsQQmWYgbRaBlw6SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,218,1787036400"; 
   d="scan'208";a="9732926"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 17 Nov 2026 08:51:16 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xTMOn-00000001C4R-1v7l;
	Tue, 17 Nov 2026 16:51:13 +0000
Date: Wed, 18 Nov 2026 00:50:17 +0800
From: kernel test robot <lkp@intel.com>
To: xu.xin@linux.dev, David Hildenbrand <david@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Donet Tom <donettom@linux.ibm.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Xu Xin <xu.xin@linux.dev>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE
 markers on fork
Message-ID: <202611180030.dC8BHX2Z-lkp@intel.com>
References: <20261117081821.7211-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117081821.7211-1-xu.xin@linux.dev>
X-Rspamd-Queue-Id: 499EF18000E
X-Rspam-User: 
X-Stat-Signature: 4a1p4o8qzppkzxe14ebe4ahk8tj7u8z9
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794934279-160637
X-HE-Meta: U2FsdGVkX1/jFCeqPasyEmAo4Q+cc7GPVwtSa5UShNRYpQcbu/srz6IYuW3gj33yHfVWh89pK+FbZDoYs/jARDhopMu6bgrL3A3ypYYCVe0+1qXnneeaZWmpVTRpp14+Yxhthad9tUrX133iczsaAKJnupvwtnZpWghEkGPvLkAyOMkT9Ey6EiNvtjjWtFY5xdxu2wYyfEdPZ+bQVypztXp5PCmcHKWGV38hIgjD8VuEDhDvmoKa6h/XS7T1CXz53qYFlqJEp929XVJkYlLuap1En+f1Jhu5f5TOHR7DjsvOg3D0TyY629pOSio8iniM7MU2L3iRElx9GrdBJRNY38z6pJJDJrJuaBDidvGUf2ywGL2iQSKrUoPOsFY+jyzbV8hxT1gIe9omK3behWQUZ1yquouqX201jnlp+O2C4hy/Y22ctNoMUWCIQG+FyUplZj9gbiKW66usjXQanhz1PwwVz4xpzcKIlhNeAL1IkNO0kPtYrNulYP4fOCrmaLx5d0yKQ6V2zNPRRgzqEpO/W5P2jt7Jtao3lAw2KT8v8awf9OcnSPp8Yee+EcY4lkhIpnLkuzwCHOzjSN38wBm6RhhoVzE7rwkGcaB9DG6unZ7HESlOkbo0MLUBbApqBNDeY4TaVKAzaFcnzmXPkXfw33prmcqn9PTdY5k40Flf/Xya4VThxMrYiAxaXat6zAhEEkWaTm3462K0YwQSAr6QkZzSqXPal4gRmYMN7YBxsBIIffvi4u2HiW2KpbrfzsF1JsyPU1YrRNqKFAGjc7+6v4sV3agoU+wP2CLCIOIPsmsgCm886E431Ugq9ocBtS4GH0YHA+s6rKwQpkymZEPxSIvEdUqOHkA4EHOs3AjE1aT2GWVEJ0ueDufu+taKFAt1uYMN6FYAyWGv83k8ucyDxeE37jmuIofX1YFsGOTh+w+UDZeVUz9oEHokYfApWdFQC/xcm78P01KWjO4LPjT
 Nw71XVnB
 HBKS6hmpgbvNGHwt7IaA3XZJwcddEEBxH/PsVPDzI+HJJEtnHtuCaMXXnefXfs6G3rlyUlKvVzHHfH25eKs4rsh2VFh6kBKCLQMM8g55z6IL2yDkHadYvwYf06B1q/5WOIL7isr4m7WHw6T+UmERcQFQIH6Kj1fgKZwdGX5ruVDcFB5Uqlo/apmxoS3IsMH8n+KxC726I3abTezwnV4IkwSVYAslIIgZgwhLkJwXPYJ49J4l6pOwpvHPUMrcMIwMm0VIBngi0BXsKcQ42SJa/nL0jMJ6bcRF6nOHz0kYpWqQGe2XXoVzj/hH8wCs+xvUziBrr3wrSXT/G9FGn+lx150WfNubmZpg/bW3YC3wM8nBRfT6T3sKYlzPvNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/xu-xin-linux-dev/mm-ksm-do-not-inherit-ksm_zero_pages-counter-or-PTE-markers-on-fork/20261117-161821
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261117081821.7211-1-xu.xin%40linux.dev
patch subject: [PATCH] mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20261118/202611180030.dC8BHX2Z-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261118/202611180030.dC8BHX2Z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611180030.dC8BHX2Z-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function '__copy_present_ptes':
>> mm/memory.c:1168:13: error: implicit declaration of function 'is_ksm_zero_pte' [-Wimplicit-function-declaration]
    1168 |         if (is_ksm_zero_pte(pte))
         |             ^~~~~~~~~~~~~~~


vim +/is_ksm_zero_pte +1168 mm/memory.c

  1123	
  1124	static __always_inline void __copy_present_ptes(struct vm_area_struct *dst_vma,
  1125			struct vm_area_struct *src_vma, pte_t *dst_pte, pte_t *src_pte,
  1126			pte_t pte, unsigned long addr, int nr)
  1127	{
  1128		struct mm_struct *src_mm = src_vma->vm_mm;
  1129		bool writable;
  1130	
  1131		/*
  1132		 * Snapshot writability before the RWP-disarm rewrite below: when the
  1133		 * child is not RWP-armed, pte_modify(pte, dst_vma->vm_page_prot) can
  1134		 * silently drop _PAGE_RW from a resolved (no-marker) writable PTE,
  1135		 * so a later pte_write(pte) check would skip the COW wrprotect and
  1136		 * leave the parent writable over a folio shared with the child.
  1137		 */
  1138		writable = pte_write(pte);
  1139	
  1140		/*
  1141		 * Child is not RWP-armed: restore accessible protection so the
  1142		 * inherited PAGE_NONE does not cost a fault on first read. Gate on
  1143		 * pte_uffd(pte) so unrelated PAGE_NONE markers (e.g. NUMA balancing)
  1144		 * are not normalised away.
  1145		 */
  1146		if (!userfaultfd_protected(dst_vma)) {
  1147			if (userfaultfd_rwp(src_vma) && pte_uffd(pte))
  1148				pte = pte_modify(pte, dst_vma->vm_page_prot);
  1149			pte = pte_clear_uffd(pte);
  1150		}
  1151	
  1152		/* If it's a COW mapping, write protect it both processes. */
  1153		if (vma_is_cow_mapping(src_vma) && writable) {
  1154			wrprotect_ptes(src_mm, addr, src_pte, nr);
  1155			pte = pte_wrprotect(pte);
  1156		}
  1157	
  1158		/* If it's a shared mapping, mark it clean in the child. */
  1159		if (src_vma->vm_flags & VM_SHARED)
  1160			pte = pte_mkclean(pte);
  1161		pte = pte_mkold(pte);
  1162	
  1163		/*
  1164		 * Clear the dirty-bit marker on KSM-placed zero-page PTEs in the
  1165		 * child so inherited mappings are not accounted against the child or
  1166		 * unshared by MADV_UNMERGEABLE.  Special PTEs always have nr == 1.
  1167		 */
> 1168		if (is_ksm_zero_pte(pte))
  1169			pte = pte_mkclean(pte);
  1170	
  1171		set_ptes(dst_vma->vm_mm, addr, dst_pte, pte, nr);
  1172	}
  1173	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

