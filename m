Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB30ACCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18F6C8E0021; Sat, 11 Oct 2025 05:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1667B8E0005; Sat, 11 Oct 2025 05:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0551B8E0021; Sat, 11 Oct 2025 05:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E304D8E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:00:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60E951A05CA
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:00:44 +0000 (UTC)
X-FDA: 83985238008.08.3296E83
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FF5F1C000A
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:00:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OfxBEWPv;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760173242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QULWKdMmT0SjmQmKhqmiaBMuzwkTFLfjlsmYFW9HRtM=;
	b=XnVaz5bXVof61xizmfebX7aKgahQAmbyGU7Q66I9H0bkFYpfJB6Ltn8j1qsmUND7c+HNRJ
	F++TCLN5trcDX23HNZDxBdiKFmMtI9mBLKI191QP91y0ZI5YzqWAl9ndm0lknk6WQGh6Po
	ReXZYik9igsJoEh0s7pCz1yy1KJ9PO8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760173242; a=rsa-sha256;
	cv=none;
	b=nf4qDDWNf7eNUXQQSR+GVdDlBjQL7n3kHUVFQEc2SCam191yyQW3/K9MhcoBLCx0Y3ZvJB
	qHmSp0xEkEe3xyiaDJWrsrWvRRHwG7fXhunGM9cpO+Td/UswIWmsHSC8/24jG5lHQtmop/
	Ysige7WuFzXq38DQ7phCRFB2KdTAucA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OfxBEWPv;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760173241; x=1791709241;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NmICyN7z5pd3yUB5P/aHf1eTN2vJpiuLtAiyWdk719s=;
  b=OfxBEWPvucB9HGTXoh9O9ARboa7XhHXkYDKAdBAcM2ghE/o5COWTeesK
   9VpElkak2p/kYuooLPu2IYHFe+fmiRi0HB5SNbUdTMyDSRl2XOxu3zFbC
   APavLQjNJx3sP0f0Y8ERYdEMPVA0WSkAojrY8DoHdAzkJ2dpYrsdCpKmT
   xFkzPjh9vCvMW5PF0xkTMYUoTCL2TWWAaDNzv54MUGW/Nw6cS3EJOVf7e
   YWxAXvE5kl6hr+nG/XWkLitTOD86emAK3SqkXcnr7jSkXx/OPwH8pPXuS
   JxYS2MGiiTrZldY/rq1pXyiY01p6agAe1GbJxCWM+x7XbOd1aDhq1eai1
   Q==;
X-CSE-ConnectionGUID: QLxFpnGUSiG8c69pyFMxcA==
X-CSE-MsgGUID: 2+0abBhgSNaocqDHDFQ1uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11578"; a="62277606"
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="62277606"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 02:00:40 -0700
X-CSE-ConnectionGUID: 4mnZvWzqSiqoAc10AJdWXw==
X-CSE-MsgGUID: GTrHiaj5QCSB0FokPuEspA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,220,1754982000"; 
   d="scan'208";a="181590217"
Received: from lkp-server01.sh.intel.com (HELO 6a630e8620ab) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 11 Oct 2025 02:00:34 -0700
Received: from kbuild by 6a630e8620ab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v7VSq-0003f5-06;
	Sat, 11 Oct 2025 09:00:32 +0000
Date: Sat, 11 Oct 2025 17:00:15 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>, linmiaohe@huawei.com, david@redhat.com,
	jane.chu@oracle.com, kernel@pankajraghav.com,
	syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Cc: oe-kbuild-all@lists.linux.dev, ziy@nvidia.com,
	akpm@linux-foundation.org, mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*()
 target order silently.
Message-ID: <202510111633.onu4Yaey-lkp@intel.com>
References: <20251010173906.3128789-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010173906.3128789-2-ziy@nvidia.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: grwmutephdtrx1bdq61gipwcukd7n1ha
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FF5F1C000A
X-HE-Tag: 1760173241-387563
X-HE-Meta: U2FsdGVkX1+aMUMwC4iMZxl1sdS4Mkh+bOpjqhyPeYHN2id+gtvS5x4pg4LlIuktCAKmdlc6toaUPrBWGrDEhfIjt98Egv054vFn+OOUXWv5NkMwplkWShGAcfzykphlLXKEyKhxKT94jqBq1eLFVowBEcKA8kfpwIAJ4ey98wTJFOab/PWpw39u1WMPLfNK7odGX4f+9cNAU0DYXreyjgigd1ERSkxOv6yy4Rkbzg6y3FsGWU9MdfpCYCbsJxvauGPvcNhdqZyL6OMcdxgu8aoNq5bQRbztuj6pSWhsM6hndPl/Y9pO2EJVYa3CqqiDd+jc2my6mvI89FWIYGOLFgwTscpjOGRTHOkT2IBPq90bU4OKCeDygl2B4rGYgpFEnIeSF4P3+4+91sPYC0YNRsLP5dGd0EDLEG6tDGu5edmrFafM6Vos0J6sYKM+391zfccSszR3hELEHf5ANDeqIeTCbFlyynd4lRmEid0SPVxScTsRzRnjoWz0i164Puk0wF5b9GKtwV4Sg+GZFFLp0vxVBJMPD+T7zNxqoQ9bNtupH3cOFNwF2/rcCoQWybuQpSBaRCnCCTHv/wBRtlEjkBVN6tkuQPFynwVZxtfFfe3NiJXXXbhW7djIaD68XSXc27my9qibTWSMWQW+K9GvadQVLwXNhugllhEoy7uRebj7FolqiwLePmHYXLq9BhsG3EUfnv8to6z767KHJdzPw/q6wizSbZ9WHHfmkEtxpp5JociJsb9uZAZOg+IyujYAD+7BKdMTUMmmlvY1d2jJ+ANqTrUBlkvPnr3lZ7Has3wyzUQ0Uv8J76jJaTmB5bzXJ3IN6aprAX60T4dWJZ2LEv2uJQrsX7yNgMacaiXW3lrTZBgHvUjN6HxJVAVQ6iyEHK5pQQ5KJG6tUUIh3QnzJMcAaSyo64AZvOqnL9mafw23hrIiWW1Mbxh+0ybnfgANiMnZHg7zL0QxhRmC41Z
 dlzsv9Ww
 CuYbfuBT8a7K2Gv+pPj7chEq37+xxZ0NGhFtgkC7p1uYyIs/OA2aH/myWoC73qpD73MAu9Eahwx+DaUwARh7KnfY+m4J47SP5MVa79qsrMnvgITwh9or6jVq5r6GwN+rNSJk+K2kFXGyOPr0mmwbFLsOvkaPEl8lir5VuwnncLI/jSlX/wW/6bF+HooAMNlRM0CzTH11sTNEiaIJe5NgPJQH86KSYkAa1hBNhkrsuuuEHToJdj2BREcWz16jEjD0uxW//gmEzTVkOMrBRRECNs74I8ugxMx5DHs3VuUqsbLdvIYiMhI0cPSnnEzhLXuAvpLAmmToxbdYL61532/agV3brXsz/Cy0sOMYJeKvOe7GlEioCZ/FdJRXjQqHWPYGkQqPjf3r7zDHsBkXz3AnPKPGNCePOk1tnHTP1bLLBxUO1QvDnNvpiLj7Gnv3tH32WGE4c7fMHLVeI2l80d6pXDGWQ/7jxLf1fm2bRYNlh+jfRnNLtiGNpBPtqwkn+yIk1WTg0ONWbauY/jg8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.17 next-20251010]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-huge_memory-do-not-change-split_huge_page-target-order-silently/20251011-014145
base:   linus/master
patch link:    https://lore.kernel.org/r/20251010173906.3128789-2-ziy%40nvidia.com
patch subject: [PATCH 1/2] mm/huge_memory: do not change split_huge_page*() target order silently.
config: parisc-allnoconfig (https://download.01.org/0day-ci/archive/20251011/202510111633.onu4Yaey-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251011/202510111633.onu4Yaey-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510111633.onu4Yaey-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/truncate.c: In function 'truncate_inode_partial_folio':
>> mm/truncate.c:229:14: error: too many arguments to function 'try_folio_split'; expected 3, have 4
     229 |         if (!try_folio_split(folio, split_at, NULL, min_order)) {
         |              ^~~~~~~~~~~~~~~                        ~~~~~~~~~
   In file included from include/linux/mm.h:1081,
                    from arch/parisc/include/asm/cacheflush.h:5,
                    from include/linux/cacheflush.h:5,
                    from include/linux/highmem.h:8,
                    from include/linux/bvec.h:10,
                    from include/linux/blk_types.h:10,
                    from include/linux/writeback.h:13,
                    from include/linux/backing-dev.h:16,
                    from mm/truncate.c:12:
   include/linux/huge_mm.h:588:19: note: declared here
     588 | static inline int try_folio_split(struct folio *folio, struct page *page,
         |                   ^~~~~~~~~~~~~~~
   mm/truncate.c:259:25: error: too many arguments to function 'try_folio_split'; expected 3, have 4
     259 |                         try_folio_split(folio2, split_at2, NULL, min_order);
         |                         ^~~~~~~~~~~~~~~                          ~~~~~~~~~
   include/linux/huge_mm.h:588:19: note: declared here
     588 | static inline int try_folio_split(struct folio *folio, struct page *page,
         |                   ^~~~~~~~~~~~~~~


vim +/try_folio_split +229 mm/truncate.c

   179	
   180	/*
   181	 * Handle partial folios.  The folio may be entirely within the
   182	 * range if a split has raced with us.  If not, we zero the part of the
   183	 * folio that's within the [start, end] range, and then split the folio if
   184	 * it's large.  split_page_range() will discard pages which now lie beyond
   185	 * i_size, and we rely on the caller to discard pages which lie within a
   186	 * newly created hole.
   187	 *
   188	 * Returns false if splitting failed so the caller can avoid
   189	 * discarding the entire folio which is stubbornly unsplit.
   190	 */
   191	bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
   192	{
   193		loff_t pos = folio_pos(folio);
   194		size_t size = folio_size(folio);
   195		unsigned int offset, length;
   196		struct page *split_at, *split_at2;
   197		unsigned int min_order;
   198	
   199		if (pos < start)
   200			offset = start - pos;
   201		else
   202			offset = 0;
   203		if (pos + size <= (u64)end)
   204			length = size - offset;
   205		else
   206			length = end + 1 - pos - offset;
   207	
   208		folio_wait_writeback(folio);
   209		if (length == size) {
   210			truncate_inode_folio(folio->mapping, folio);
   211			return true;
   212		}
   213	
   214		/*
   215		 * We may be zeroing pages we're about to discard, but it avoids
   216		 * doing a complex calculation here, and then doing the zeroing
   217		 * anyway if the page split fails.
   218		 */
   219		if (!mapping_inaccessible(folio->mapping))
   220			folio_zero_range(folio, offset, length);
   221	
   222		if (folio_needs_release(folio))
   223			folio_invalidate(folio, offset, length);
   224		if (!folio_test_large(folio))
   225			return true;
   226	
   227		min_order = mapping_min_folio_order(folio->mapping);
   228		split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 > 229		if (!try_folio_split(folio, split_at, NULL, min_order)) {
   230			/*
   231			 * try to split at offset + length to make sure folios within
   232			 * the range can be dropped, especially to avoid memory waste
   233			 * for shmem truncate
   234			 */
   235			struct folio *folio2;
   236	
   237			if (offset + length == size)
   238				goto no_split;
   239	
   240			split_at2 = folio_page(folio,
   241					PAGE_ALIGN_DOWN(offset + length) / PAGE_SIZE);
   242			folio2 = page_folio(split_at2);
   243	
   244			if (!folio_try_get(folio2))
   245				goto no_split;
   246	
   247			if (!folio_test_large(folio2))
   248				goto out;
   249	
   250			if (!folio_trylock(folio2))
   251				goto out;
   252	
   253			/*
   254			 * make sure folio2 is large and does not change its mapping.
   255			 * Its split result does not matter here.
   256			 */
   257			if (folio_test_large(folio2) &&
   258			    folio2->mapping == folio->mapping)
   259				try_folio_split(folio2, split_at2, NULL, min_order);
   260	
   261			folio_unlock(folio2);
   262	out:
   263			folio_put(folio2);
   264	no_split:
   265			return true;
   266		}
   267		if (folio_test_dirty(folio))
   268			return false;
   269		truncate_inode_folio(folio->mapping, folio);
   270		return true;
   271	}
   272	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

