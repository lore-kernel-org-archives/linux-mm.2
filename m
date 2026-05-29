Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 886EBCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 07:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97D96B0005; Fri, 29 May 2026 03:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46126B0088; Fri, 29 May 2026 03:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62306B008A; Fri, 29 May 2026 03:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93EE36B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:09:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26CBFC6943
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:09:57 +0000 (UTC)
X-FDA: 84819582834.04.F16BA2B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CC9BC000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:09:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GchEa3v4;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780038595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcoOd69cYkfgsrV+dRR4Y2bFwBglK8L2y7k9wZRFa/Y=;
	b=zBCKr9ENzUjdkcggT897NBmLSo2Y/QjRPAjWDGCi+jHgeyc/mOmb69DPdGyTFVkv8xYq/M
	bltib/Um1iJfzVOB/R1w7STOzhU1SWOgkASEiAoyPj10kAM0d3TEfGiC1J0SSOKHPNeUo3
	nY129+8xzTsE/OLIdFNDBnp1scq+Im8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GchEa3v4;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780038595; a=rsa-sha256;
	cv=none;
	b=pSBt+XBmU0AH6QPDw67S6WT8wo/JWFIvs0DsnuzVclWyOlrbW+PI+XYxF1LH1j6N7sFcd9
	ehk5t7hOInXA0vWDdzVvWpTxyaofZE+xEeG9AD14HZFCPR8perY1pANvaSOJmsMvOSjPvH
	rNTULfIMeoRrozF5Qyy/fDcetCcBN4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780038595; x=1811574595;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IVXGCmJYd3atIRp24DxE9XBI0PNQwZcgFCN+Pv3VN/U=;
  b=GchEa3v4Ga5CyV8tSf9cqucbURBHwcHvQ258XdmyYZ2lfdtMy716i3WW
   +NZ0xqq+8c83fl1Z1DX3p2dWajENlAo7n/JGEBe3eXo9DAyFX02Ffhhcd
   P0aTC4woLTIQSX/FcbrU0L/6hvCP6wDqdPMVz0ex0aCEyzQgFgZ4L8s14
   jg/kSz+LVn5laap8m+mZx55PEgk7ynkB70ECH/LZzaLhm4+F8Plp/7zZm
   qgIHGw243Ia748kHrZ1vvvO22fMzvOwGEDd7SbY7vxlT5N6Iy5t42vr9O
   LEZzxIFGorL87pRRAg8u9NnWRkA1rgYK/iYK8ad3RExDGm9xZA4PVOkgi
   g==;
X-CSE-ConnectionGUID: +uddBtVSQO2pmvaLruC6rw==
X-CSE-MsgGUID: sMeJP6OaS4yj0ews5bFu1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="80741240"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="80741240"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 00:09:50 -0700
X-CSE-ConnectionGUID: vuzsPRqoRTqPEr9XjjZCyw==
X-CSE-MsgGUID: htdXkUk2RJ2fyCEtfaz18g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="239759452"
Received: from lkp-server01.sh.intel.com (HELO f0d55cb201f0) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 29 May 2026 00:09:48 -0700
Received: from kbuild by f0d55cb201f0 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wSrLm-000000006t0-0qZu;
	Fri, 29 May 2026 07:09:46 +0000
Date: Fri, 29 May 2026 15:09:25 +0800
From: kernel test robot <lkp@intel.com>
To: liuqiqi@kylinos.cn, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	ying.huang@linux.alibaba.com, Qiqi Liu <liuqiqi@kylinos.cn>
Subject: Re: [PATCH 1/1] mm/memory-tier: add node_tier_id as stable tier
 identifier
Message-ID: <202605291430.iafzIZCL-lkp@intel.com>
References: <20260528134212.240492-2-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528134212.240492-2-liuqiqi@kylinos.cn>
X-Stat-Signature: ms88nr95x3hawrybzmzuo37erg1scsf4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CC9BC000F
X-HE-Tag: 1780038594-152316
X-HE-Meta: U2FsdGVkX1/dKDBSaXaXGBWfcviMONblxpbiQJoHHsOOTZZNrNRFRdKrPpeJO5H0eAXw+rk2FWkgmAuAJo/ZVw5zVjFunQEinBtHs9/qOO4so9goFjw53238+SWbktbw8jLo0RrL8V51sdSxIvA9aqVoYdk0zhbpAReHLeYjHJ13EMCIGArNfkh7NtLyDkivB22FacBvPuqsB6r0OigMDto7/4xCB5eKSdUT9N3nQLHyoFAQUelHqnymBkCqlL4mo9YOac8u/YVULr2G9U6isnl/REju5CesMiSgDzo8UjlhhN0DEMze0KoTky31BiTvB1folq1dHZdSKbZgCgkUcB/E821FzXTVI7PvXMzlVlOImOaCbz4GYhkHPInrvojuQckR9Df/R7VnpBXlMOrVBe3zFTqZyUiQpkgali93/YeHE5oeRGd5R0eWrNHWVGH+rREwFh9pzHzRR1vm/hcv0MdbWyL7sR0m20cvu+UQ5pM1z4A2j0rmMPU/IDqDAor4+xlw51jPNs3BxDnlU9yTzfHA6IfgA7sfThvcgtcJdZ+KQoDQx9qgmRs/VaMANTqpKW2s4n2GHBK5nAOJByqpWinFNfFFe86puxYCKAQU9rfY4T+br+BxAE6m4G2BXZyWk4pIv4ubuaQZluG3NC5sz+5Hi1xj73lGQN0LObGqHy4k81bvKOBEwTMp66CyQHkfGBIXdeanKRRMJmz+bUznlvR9FT1wuksJTz0llNNvhn2ljTLxdSCjFgPl866os+tlPB84HW7cn2sZd0dNAnWT2HK54aJJXW20lfeSvKuwfxgYu2vN/l0DQZkiR7mas6PbPaNqKAn7BlJWN2swwSxjFw6sbKbOvhqqBeJrNCUE8ILLpFQQ8M6ybam+L0NU+RZvVpuMe+Wqf+E5CKnTb6NlS5TqSXuNR3IcBOatyLhcKw66vDr9FzNMoCmXTtnPrNWgC2oMCQ0LpPo1hg8FjvJ
 JCqnYQsv
 xrC3948ETZeUSHshAfrKLwMRNVokTUZHGTu2EatEc579wvKTL87iS2LYGOl2CDc6lm4NVBoUssrC3QwiroOY3KZSxokjR9y5SsISDv+vrc2dPgiu7Fu//8hMG+b87rHoNAf4TG10su1vKb0vv3YBOmXeFigFXYys/ccb5BVRrTkna7Jv3jVte3iuKBYopUHHp66ZXW2KuLZkg46L29plfHh7aSJ1nrTLZG+jROe+OrT4LoX1+gsb7pKBmTC1ZxDudkNRTw72KbwwKN8b7fXuxsYhzvTvEyQA7VOpSYHt054RWvLxYgymf5Wkd5hTY8JCsWz099rif5UsrhpRul6xFCkx5K+Sxn6X21gHJB0IPu4nLtH57/SLbF6kjP8U4utVhaCE/UkYpdXvCTJY=
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
config: sh-allnoconfig (https://download.01.org/0day-ci/archive/20260529/202605291430.iafzIZCL-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260529/202605291430.iafzIZCL-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605291430.iafzIZCL-lkp@intel.com/

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

