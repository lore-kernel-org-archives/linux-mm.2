Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DCDF3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 11:10:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DD86B008C; Sun, 29 Mar 2026 07:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624A16B0095; Sun, 29 Mar 2026 07:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513F86B0096; Sun, 29 Mar 2026 07:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6B86B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:10:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5F291B7D7B
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:10:51 +0000 (UTC)
X-FDA: 84598833102.10.0AF52FC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0D52C40003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:10:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aM/6fEeR";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774782649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8MV1XKYQTUWDRvfn+9qcGV3cYnQe+ulFyWLoYGCFi8=;
	b=AJ7z+Pg0UumHo8C8MG30sp3etkiRzDqwBHP/bVhtilRR1Zpiyb349zvb1cB3cCSp3aK6GW
	8ckgErymSXGlR+FMEkGjDyF+X486gl9Ulur55LgdtjECyPcN0kwB4AP+LtuMhs8bN0awpH
	Yvsehd9qaWSPKQv6bp4zGb+XiI7jvOE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="aM/6fEeR";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774782649; a=rsa-sha256;
	cv=none;
	b=k7kMgGqdSIjKeRBx2vdBoUPg60EgUJxfSqIMH1G86TmXESSmQeDSBzrosmWcqFWoOorlHv
	iKBwTNMlFWbvkQjGhSdnXZZB/P0+yCLjtdCX1DEOBW7WHZ5X3X9P1/yBUjaHsGNd9dFCFI
	B+qAeRwBB8mEJwdXJJjV/JcPXRjcyNo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774782649; x=1806318649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MUWehC6zCYW4cAnKQsgp35esVCOepJrsC3TRNFKUwZE=;
  b=aM/6fEeRplspTI/bXU4vvFhfPGbhIQPpM3aeHWfqkkdjVflWLb6pyf/6
   VwJ3+cHYJK03GZbh8ONyWVl4D+V9Nfiv4URaOF35Z3hRIaYBZG6/cAHaO
   dt2IIs9xe0dHF200XNeWDas/nSkARv+elpvixlIYTarNrfR2nzK/3RM8h
   IeZQFKW0veR/zb6NRG4XzS1aFoSwXZcPK7ze9R8w8rNo+40tT3APsNM3z
   2G6AouDgqJyzSJ/b3mqZ2FId+i0WwAGNMs4mdoIBjc5aAcFp45WQRFWgi
   9mU6s9E3ESPsHLCW0PufFBLD8xOIr7kYwM4cUaLeydsxqUAHFGDH8eXgv
   A==;
X-CSE-ConnectionGUID: EXyY/RlHTleIHlhWtVYmTw==
X-CSE-MsgGUID: 1aq28PP2QmqD3SUFtXt73w==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93179805"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="93179805"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 04:10:47 -0700
X-CSE-ConnectionGUID: xg+7iKEOS1u5jqySaqKt+g==
X-CSE-MsgGUID: Twpja17GSbSivtk87UES1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="229848129"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 29 Mar 2026 04:10:44 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6o2T-00000000CJ5-1PLT;
	Sun, 29 Mar 2026 11:10:41 +0000
Date: Sun, 29 Mar 2026 19:10:18 +0800
From: kernel test robot <lkp@intel.com>
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, bhe@redhat.com, baohua@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <202603291919.Y8MwFsok-lkp@intel.com>
References: <20260328075812.11060-3-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260328075812.11060-3-21cnbao@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D52C40003
X-Stat-Signature: xwrmmp18awrb89dqx7tn7tk5h6ftsj1i
X-Rspam-User: 
X-HE-Tag: 1774782648-452765
X-HE-Meta: U2FsdGVkX1/ZzDSq+oHKEfYjaIgu7fU5tQmYX4DtzlLQEkjxiqEzamJzQ7Ivou5nQexVmzYwmV7paPkG1DvpwpoBqxnX8TlwFqjOuSj5uWY7OwOCjbfu4Ptqz3pa7xesFp0Znhar9C3qIkwTELRg3E72GA8opXXV/hq58RVJ6WXwcUAmRVQ8bpXhOWk0e81kgiFc9P0++GNsPVpd26GDb585+I/EwYOY8n+8Oa2ofQlRs80Gnfd553rEdKX2t46qrCsyHb/rJmw0XRSjmPQwIQOeX/Ai7kB/OAN7ZVdhxLoYOB0lp4rVxuS5MapG2mYlMT/Eja+hO3v1NwTWRwL1Apg0gQa1/ey/cGycsM0Lzr1LzlI/pzTrGJn60B/TqispPPGG/B9qNcBWGI8LXLv3gIvDXxJCByrqzZjiPrf9piXMOf1IkC7yzqLTFSNgN0gokD1jN3sl0e1gbokuwSiuUGapilzeuZFmz/eNTvD3kr8e7MLUu/wyVcCRuFuG0CaP13JvBvVnkZIq6A4Gg/4g05sQ+pAKHXBXYlXATrqJD930I8qj6wCK4Scs2JC9NgvcYEFwF0PrlZOQOkDpPS1kfzNYwPJCN5jgKJzpv67xiGRvimDOLJWY4Fk5aTAhY5WJkVbnZtHk+/wRlod84yf6uX2ZT2KeKLC7//cn1a6hIP/k6fopcvua615DlwiqTUQ23qs7yHC/Cs+zG13k1XvrIYCg/kC2tiEPhrTnlbNDapTXVk0fNrddAng7XsF5Fn2Yec9H5xE3YMFZlwlwhSoXCSs0VRj85LOp8baIaDo2Y/PmyaQs/CmbEa4hvRBlE+fYhK/Aaa9KCvQV6rH1K62UVEajideoCN3vAhoI+4tylH0PL6mJead6IUtyXWSTkOTYXP8E4MCFeB8vmRA0fMa9cA7hxRqeURCot6oF4ofuhmc5efKk0k3B1vhAme4xq061mb0dqyZBaZEMrUl80FP
 2D5TbnD3
 AmUgeVsgZRbotbQ0M39UEXLXXGxruFSuQsnyChLamYBjYizJ8nos/mDbbJv9NckCSEKSHLl7axKl+XH/mKJwlEi4LcGDnOdtRhXnI+NAfY6aCgoCiIpqolVBug8gyVDWTHm2lh/cirFXTCka+e1RR+2JyNzLdc7YfkkMVEL84Ki61YRhkAgHVK2LKD1hmGl/RymiX+DFY9BfsMUU+zQuxQMNioJX/eQfcsS26yF8pMYEsI1ZdR+5rCcqga5gqbyZK1UrMsHI1uIXsYx6yzkj0IFSgjoCt/8qsD8OGzq1WKSx8Kqfwd24NfSUbw8uRoPmSP7pY739rZoIVw3OrIAYtWaODAFd3wlEMd/3hmc2iwgzDpGF/LK3O+GAimZYTeFrMgPBrb+yWu+KM/nY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Barry-Song/mm-swap-rename-mm-page_io-c-to-mm-swap_io-c/20260328-170852
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260328075812.11060-3-21cnbao%40gmail.com
patch subject: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
config: um-randconfig-r072-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291919.Y8MwFsok-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291919.Y8MwFsok-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291919.Y8MwFsok-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:7,
                    from ./arch/um/include/generated/asm/bug.h:1,
                    from arch/x86/include/asm/alternative.h:9,
                    from arch/x86/um/asm/barrier.h:6,
                    from include/linux/list.h:11,
                    from include/linux/module.h:12,
                    from mm/zswap.c:16:
   mm/zswap.c: In function 'zswap_writeback_entry':
>> mm/zswap.c:1057:26: error: 'sis' undeclared (first use in this function); did you mean 'si'?
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |                          ^~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mmdebug.h:123:37: note: in expansion of macro 'WARN_ON_ONCE'
     123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
         |                                     ^~~~~~~~~~~~
   mm/zswap.c:1057:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |         ^~~~~~~~~~~~~~~
   mm/zswap.c:1057:26: note: each undeclared identifier is reported only once for each function it appears in
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |                          ^~~
   include/linux/once_lite.h:28:41: note: in definition of macro 'DO_ONCE_LITE_IF'
      28 |                 bool __ret_do_once = !!(condition);                     \
         |                                         ^~~~~~~~~
   include/linux/mmdebug.h:123:37: note: in expansion of macro 'WARN_ON_ONCE'
     123 | #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
         |                                     ^~~~~~~~~~~~
   mm/zswap.c:1057:9: note: in expansion of macro 'VM_WARN_ON_ONCE'
    1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
         |         ^~~~~~~~~~~~~~~


vim +1057 mm/zswap.c

   971	
   972	/*********************************
   973	* writeback code
   974	**********************************/
   975	/*
   976	 * Attempts to free an entry by adding a folio to the swap cache,
   977	 * decompressing the entry data into the folio, and issuing a
   978	 * bio write to write the folio back to the swap device.
   979	 *
   980	 * This can be thought of as a "resumed writeback" of the folio
   981	 * to the swap device.  We are basically resuming the same swap
   982	 * writeback path that was intercepted with the zswap_store()
   983	 * in the first place.  After the folio has been decompressed into
   984	 * the swap cache, the compressed version stored by zswap can be
   985	 * freed.
   986	 */
   987	static int zswap_writeback_entry(struct zswap_entry *entry,
   988					 swp_entry_t swpentry)
   989	{
   990		struct xarray *tree;
   991		pgoff_t offset = swp_offset(swpentry);
   992		struct folio *folio;
   993		struct mempolicy *mpol;
   994		bool folio_was_allocated;
   995		struct swap_info_struct *si;
   996		int ret = 0;
   997	
   998		/* try to allocate swap cache folio */
   999		si = get_swap_device(swpentry);
  1000		if (!si)
  1001			return -EEXIST;
  1002	
  1003		mpol = get_task_policy(current);
  1004		folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, mpol,
  1005					       NO_INTERLEAVE_INDEX, &folio_was_allocated);
  1006		put_swap_device(si);
  1007		if (!folio)
  1008			return -ENOMEM;
  1009	
  1010		/*
  1011		 * Found an existing folio, we raced with swapin or concurrent
  1012		 * shrinker. We generally writeback cold folios from zswap, and
  1013		 * swapin means the folio just became hot, so skip this folio.
  1014		 * For unlikely concurrent shrinker case, it will be unlinked
  1015		 * and freed when invalidated by the concurrent shrinker anyway.
  1016		 */
  1017		if (!folio_was_allocated) {
  1018			ret = -EEXIST;
  1019			goto out;
  1020		}
  1021	
  1022		/*
  1023		 * folio is locked, and the swapcache is now secured against
  1024		 * concurrent swapping to and from the slot, and concurrent
  1025		 * swapoff so we can safely dereference the zswap tree here.
  1026		 * Verify that the swap entry hasn't been invalidated and recycled
  1027		 * behind our backs, to avoid overwriting a new swap folio with
  1028		 * old compressed data. Only when this is successful can the entry
  1029		 * be dereferenced.
  1030		 */
  1031		tree = swap_zswap_tree(swpentry);
  1032		if (entry != xa_load(tree, offset)) {
  1033			ret = -ENOMEM;
  1034			goto out;
  1035		}
  1036	
  1037		if (!zswap_decompress(entry, folio)) {
  1038			ret = -EIO;
  1039			goto out;
  1040		}
  1041	
  1042		xa_erase(tree, offset);
  1043	
  1044		count_vm_event(ZSWPWB);
  1045		if (entry->objcg)
  1046			count_objcg_events(entry->objcg, ZSWPWB, 1);
  1047	
  1048		zswap_entry_free(entry);
  1049	
  1050		/* folio is up to date */
  1051		folio_mark_uptodate(folio);
  1052	
  1053		/* move it to the tail of the inactive list after end_writeback */
  1054		folio_set_reclaim(folio);
  1055	
  1056		/* start writeback */
> 1057		VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
  1058		si->ops->write_folio(si, folio, NULL);
  1059	
  1060	out:
  1061		if (ret && ret != -EEXIST) {
  1062			swap_cache_del_folio(folio);
  1063			folio_unlock(folio);
  1064		}
  1065		folio_put(folio);
  1066		return ret;
  1067	}
  1068	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

