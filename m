Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DC71CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 22:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979D06B008C; Thu, 28 May 2026 18:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A9E6B0095; Thu, 28 May 2026 18:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840636B0096; Thu, 28 May 2026 18:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 725AE6B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:04:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C69F7C2F41
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:04:27 +0000 (UTC)
X-FDA: 84818208174.09.5CD9E24
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1B58380010
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:04:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hdfX22hZ;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780005865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLymEW8b5erFIxZe5AqE2FnMQSpodSWZEWZEF2koXhI=;
	b=u+z/g8BKTKpbEiIEpvbYVm6qOJ/grGdt1vqyolSjgVMgkRgSEn33Igs3/qpjESH/Iy2Dr7
	l5QnkJmNckoiubDeHrhlUij0bziJobgTXfbqxx5ejrqnCJhQ/+k6i2mVxzvlVQ4HMRnLcd
	6YzuYQBF2PK1eXffVU3cBEBFAn5yjU4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hdfX22hZ;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780005865; a=rsa-sha256;
	cv=none;
	b=BnD/hq4wOsijebD3P85ju1wqMkfhH9mRQm0+ZQopCGWuoItXtW/0Mn8Xq1BybT/b91nJuE
	MfpUQE9EmMDRKMQQqJgAcepnfsvcaRehaFnz91+4L3b7TPAa4ILfYof3f92WthncpZycFD
	6yMmYxUGj1mSoBIS2J/wrqGUUf6H+I0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780005866; x=1811541866;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KXANSzq3npn4gHxXw7HD8cjwtP8lf3LwPWFpqLA0t9A=;
  b=hdfX22hZTJeIvcoBEgerSBUrFLitZ5vR9f/6sMyzcYiMHHeMB5TnZxdZ
   9SkDlxCFGZbusEQEg+C/GdWUI1W85Xr+M8AoZKlxNtVExvxkx4MS9Y5NG
   OtVsCBkr5aqW3faWaryR3WMyQFb71+fgocIWAE6uvF9O/b2CxH5O8rZu0
   hb7JwRG8Ed7LyXUJDJLWihwWCz/WyKSEiKc1gn4zZGvQ4P5DDHkPMKweN
   z+uTiod7z6g3igNQfB44PzpJGslSFA4nMyRMpER0jMjAVuHSDACQmGmmZ
   +rfezFeXORWsFQAoIHkcedoigBBK4AXG6yVlhSzWxcA+PSM8V1iTjMQ9/
   g==;
X-CSE-ConnectionGUID: R9NDLFhKQayyosuBQs85Og==
X-CSE-MsgGUID: cFOES0VEQ7ixvGPT004WJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="91970928"
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="91970928"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 15:04:24 -0700
X-CSE-ConnectionGUID: Fc2NBKKYTg+jKwKxusjcqQ==
X-CSE-MsgGUID: eyQdqu0WRjunSGv5FH/+OQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,174,1774335600"; 
   d="scan'208";a="242770782"
Received: from igk-lkp-server01.igk.intel.com (HELO 892db79562d4) ([10.211.93.152])
  by orviesa009.jf.intel.com with ESMTP; 28 May 2026 15:04:22 -0700
Received: from kbuild by 892db79562d4 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSipw-000000000bN-1AZ2;
	Thu, 28 May 2026 22:04:20 +0000
Date: Fri, 29 May 2026 00:03:48 +0200
From: kernel test robot <lkp@intel.com>
To: liuqiqi@kylinos.cn, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	ying.huang@linux.alibaba.com, Qiqi Liu <liuqiqi@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier
 identifier
Message-ID: <202605282306.klBh1nb2-lkp@intel.com>
References: <20260528134212.240492-2-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528134212.240492-2-liuqiqi@kylinos.cn>
X-Rspamd-Server: rspam12
X-Stat-Signature: hhbsp6hcfrsf6wrn7e6n9ietjd1do4jj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B58380010
X-HE-Tag: 1780005864-153818
X-HE-Meta: U2FsdGVkX1/6CYtOklUsDqh9d1AlFPNqi/McM3oAOXTHOCOXyp+zjZDLKbfo69HSjOsMuZAksgMJspunFoCvV0qWsDMs1LBbhyd6aUB7aOW+fi1P7yWLE7ICy2JUeGmrUf5DLjdtDAykFkWzmDKAniAjSizLJ8EHUmGJHL3SJQkMv6ggxC8GXtu+QaZb2ndm09VDpEximZfnV6O/jAC57ZfVygrUPyu9aiTyLI+zThr/7rdAu6TyL1HzPjWvkasfRuNxg1JFXPdOL+QoffIVOmIOET7SQIdT+HyxFG32PGETCyizgkEvl9KDZpLRiSjEDfyULYpSPkFGcg7EUZiRQaYhI+PuJ70pBQSApvV2ByOaAWC5bAc/PgrNIzK+wjQwWl9AB0m6IDUNcCONWJ96MnVcVRBjj8VqI5xv4MabR5yQM81WnspoMqxoguewYGbdBPqV2bc8S/Qias34arFzd+RZy5yCDAaJLdkE/EbXtY7e3iiomafc9E+FCKf3H1Vnl+WpdyxFSu6js8sk6unapXocLbOISLftS2EWn4+A2vyAKbizVB3mAhi/vlaZ4EPskwCI1wnEYOcGPVzJOA1xHBMd2PpvfJ07GrC+33Av/IShvO/LZMZ0G6nvCql8oN9cf8wqNKhQlRacfdelBnI+au3/ymlN6BEq2KD0Nxzq8bNRIGJQgeo6wkaCCuWSno/r9eUSEj+ra14qyXvgmjveELE80z4uK06g99ox4wY5AjKPjzzmiioYdbduIm+rkrhfp03jj220+ifZSGEH0u7itHT5MNbGnktRCtiiMP/DrnWDpO4BtcbdsAa2OmqH71RN/tX1hmM6w+SBiqi96JGHCrsCzOesaEZVwlXoTjAC7d2iM3PFTflsDUYTz/XT4IEpiiK90n/V89V+vZlXVG2PI8JDwZZKZLjVLI5wNu5+1Ftn/QnM3k7b61mpUKiHplZil7xYHRsfIsbK8hXMBDq
 NMty7n0E
 mYz4/+LzMA83BYGgWDse9CVlN+XzAACPGExpkDWtuDqkuG25nKm4TvA7oeS1plb5PA6T9JjRWd+fpultSpnKb34hjBtsvBgzhCG0djdjCphkBd/NOlcfRWUQCBd39MGnh/tZGznixtdDKkn98ipVFewyUZ81p0xtDLId4gY983suSCCGPJqy5LY94tORZ6CEzimqxSWTA7Qr/FHWTgHh17GZ0fX7DqF1te/LN3cnTPHjOjJ2FXCUMkLSlwe8wqhJ59NeqNa7DiHju0nvSWPQGB9bGndp/0++lQjF3n9PZmqo1Kjmfo/6QbRHWUoJG1U2Vw5ZZq6T6t0pYwK9aLDtpAfBAU/7YjWOUObOyVSCPUTeHSlf3kGDwQk4eHRlBZXq0/Ye2zRZeoLdRQvzFd+x5H6u96iVNDXHKkcjIdyAmhmr/njw6mPBAetQFd19W+Gg4jy4R3Vp2v1aXUgdjb0tgpfG82HGs92akFFguXoHk0dsBmG7C779U8gsaRANnFOTD8IfS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on rppt-memblock/for-next rppt-memblock/fixes linus/master v7.1-rc5 next-20260528]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/liuqiqi-kylinos-cn/mm-memory-tier-add-node_tier_id-as-stable-tier-identifier/20260528-214338
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260528134212.240492-2-liuqiqi%40kylinos.cn
patch subject: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier identifier
config: s390-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260528/202605282306.klBh1nb2-lkp@intel.com/config)
compiler: s390x-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605282306.klBh1nb2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605282306.klBh1nb2-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/mm_init.c: In function 'free_area_init_node':
>> mm/mm_init.c:1713:14: error: 'pg_data_t' {aka 'struct pglist_data'} has no member named 'node_tier_id'
    1713 |         pgdat->node_tier_id = -1;
         |              ^~


vim +1713 mm/mm_init.c

  1698	
  1699	static void __init free_area_init_node(int nid)
  1700	{
  1701		pg_data_t *pgdat = NODE_DATA(nid);
  1702		unsigned long start_pfn = 0;
  1703		unsigned long end_pfn = 0;
  1704	
  1705		/* pg_data_t should be reset to zero when it's allocated */
  1706		WARN_ON(pgdat->nr_zones || pgdat->kswapd_highest_zoneidx);
  1707	
  1708		get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
  1709	
  1710		pgdat->node_id = nid;
  1711		pgdat->node_start_pfn = start_pfn;
  1712		pgdat->per_cpu_nodestats = NULL;
> 1713		pgdat->node_tier_id = -1;
  1714	
  1715		if (start_pfn != end_pfn) {
  1716			pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
  1717				(u64)start_pfn << PAGE_SHIFT,
  1718				end_pfn ? ((u64)end_pfn << PAGE_SHIFT) - 1 : 0);
  1719	
  1720			calculate_node_totalpages(pgdat, start_pfn, end_pfn);
  1721		} else {
  1722			pr_info("Initmem setup node %d as memoryless\n", nid);
  1723	
  1724			reset_memoryless_node_totalpages(pgdat);
  1725		}
  1726	
  1727		alloc_node_mem_map(pgdat);
  1728		pgdat_set_deferred_range(pgdat);
  1729	
  1730		free_area_init_core(pgdat);
  1731		lru_gen_init_pgdat(pgdat);
  1732	}
  1733	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

