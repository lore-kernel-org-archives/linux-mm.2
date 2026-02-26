Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306CBFD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF886B00C9; Thu, 26 Feb 2026 17:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6866C6B026D; Thu, 26 Feb 2026 17:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586416B00D7; Thu, 26 Feb 2026 17:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 391296B026D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:41:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B6DC1601D8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:41:12 +0000 (UTC)
X-FDA: 84488079984.10.5CC2E91
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08FA340006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:41:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MVKpuDKn;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772145670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVOVjtruTRX557rE/SjojwqJ8DC2Wiig6p3Z3YjFbpo=;
	b=mTei5J5VzC+75J4vOLsFXaLL0iBSZkZafZo4cEHWiV+bz7bN+p/a48pOKOdVkQcTx4T6dd
	qaiwyFelnQBIhlKMVk/a+g0D+j3EOTIRVgqJaRaLfB1hakV2CBeNPhaAUXIcWKl+EUWgLD
	k+ujvmV6BBLtHYWQsY94SPK3+fUbpAY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MVKpuDKn;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772145670; a=rsa-sha256;
	cv=none;
	b=AKWHU1YPFNWIPpNpSnGZy59EAxiagy23vXHb+kjoJY+Gh+Ejflm+LzgTxOjczvPIaWkqFd
	qrbrz1f9ZPniBTVI9YK3NAe6IukognlOAevBHjFqv3qj7M1lxucu90M1r/3/9Pax4US9Cq
	9oPu7V+r3bfZHcF+jFVc2PnEpxnh2UA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772145669; x=1803681669;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=d/6m10PYexKC1cVhq0Hde/ttL8fwWTtpBRAU/d9YlHc=;
  b=MVKpuDKndQj6gWcbu+1okdmbeWfeHwRms2iV9273gZ4x/KZQfeM7Uz7a
   mJNiwCUj/t/1Y8TmWN3RRFwHbwgIOOR/KFazv7Sl3NZQWyiqfNYGx98um
   Mp00qEETwQayFocDt8DMVPo7lT2uBEFLN/8PphqTw0bQN29xtCqfFtOkJ
   Ehdm6SXhyLpQS5g2mCl6+UdQgfYL3KlOu/5yaqfVMd3XynXpp2klkkDlg
   vdjSF1WwIWR8mhj7duHev8pPqWnX+lctTA11PJRc/ZaYL209FC9lOIWam
   8FOU0Au/58Pgv65WlPgwrXSQBkre4gxpQ4sVk3/yPrzRlf11gUhR0b6ke
   w==;
X-CSE-ConnectionGUID: OICcxkJBT5KN2b9KmEUfWQ==
X-CSE-MsgGUID: xlXKr445SEywgy7Ce+nwRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="84684605"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="84684605"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 14:41:06 -0800
X-CSE-ConnectionGUID: 0Ew5H71QQsm/kaO3gZMK8w==
X-CSE-MsgGUID: NPS72Xj+SEqml45ybSgtXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="216833273"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa007.jf.intel.com with ESMTP; 26 Feb 2026 14:41:01 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvk2T-000000009x9-42O4;
	Thu, 26 Feb 2026 22:40:57 +0000
Date: Fri, 27 Feb 2026 06:40:18 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B
 per-memcg-lruvec
Message-ID: <202602270607.dJP65LGH-lkp@intel.com>
References: <20260226192936.3190275-9-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226192936.3190275-9-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08FA340006
X-Stat-Signature: 188aj1erpgxzmhgrwkskahg7n9n615y8
X-HE-Tag: 1772145668-265048
X-HE-Meta: U2FsdGVkX1/rSP++qNmn7ep5Pw+CHA60oPabGekpRV0261haahdgC98HLM0P2BI3z/mbEQeiHaFn+ynFPJYsZKWlyUGx4X+E/ZGHEjhw0fet7P+Z9ntBv96qezq6upCp8Fuy+8S8HwupnE7E7C0MFrQb+fGHMMn1j1g+qiyCO/cTw55r1+3+5eJMZaL+G9wsiYScBaYuKZko1TW2o+lxtr6xvT1vlgwT9A2IUW63RNneRpipSQCtu1Pc0enJEo2CJsS3ntdWkyZeqkYmGnlKWPj98wycjNbzRLZmhnahsJumqYkI3ROOq18MjS3FFHI5oLcMaUgkajvocOajzgJ0QkVdSoND0vM2uXoHzqB+l5Jj8w94+W6ZTlQzegDlkH6f+/MqLCSPedWOwJkqOvNnYwOG5EKLYzCEdEc3/Kt1QVNVbS0eOChN1ZijxwMINn7lRlOCansBJltw3ZQhAqJpmQUYgc7aHj7UQzzt2VXGvbU59P6yulMvXXLTPt2Lrttcbk0vdGuPuYpf1dMMdv9amFYqKRDqoa91BWGncKUGWPLLrWdKkSXLV7IDjQvCgWCS1p/PfHLr7vS8zEcjb2tDhKk8+mn6QMQQYPSmzPFr9VBCwKlSjcM7p61qxuE5R4axNglv5sNhDV4SwhPm4H629kVFFVbGEL3Z0KQZ6vDjs9AcU75fdv9+R/CXQ0i1UjIT883vFqz2UV4gx46NnvdHzFdTe4gM6Kqztzh5mowE7GYJsVw95sX2G8PHyPnHQgjpqKX4sDDawAtIQIkNHzH5Lgf7eie4jfciNTH7W9rreIEtSI4i9amm0nBwfiCrFDNcHRSktCU+iNAUoCtQRk5JaKn5uLu26oZoS/XxwRNkodUVzCTmVTFyDtZlGRVFUQxvmWQQgwAJhx/Nl5K2oGQkfpPoRkg8JcECJjKahjGW/KDeGsSJVeg1b4z+kiUl1/F0szvagBLsvnQa/isqGcn
 QuRaYsou
 SRZG0bnxp/elMv6OEkWpr+C70qumy4dgY19Iy9vckmsAGjJu+zGZMKZP71fKvyKgQT0C3kjCAdLCxSUYWZzV2dXBUQF+naXbAn2IQrBHbZg6LmsqgdW62qac/oOZ9Wqd612GCTxBbaxtXQKPZ0B2UYwC+13VdC9nFc9Mf2K901QgLJ+ir9LUpHb+FoQiJb6g5qdkRsAnKYBO0A0bqS+ujtyy+TwFoCpLgyDUQRj0kAwDpmBsessuwiLj1WbaP3ajN1xCXsZIqC21HYBqxXqiSzgZLftQ3mvLwomSHlWAjCCkyt3B/zC0jBe5SDoQKd1dC2mVuxsvCRgJXgqrO9NP5Cm2u2c8bPW5u1+bK6vnxwGBaLpPSY521vDTSvgrHXDh7q3sfw63tsAVi2HnuzH+4rqgGcjytBLg/vNZcN7bZRxNyLlCJp1Tach7Saoeis6hIhInPFDqCY794Rk697HEaxd4kyC453of5hW6sJpGhufTbpFEYqkKgUu9btA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v7.0-rc1]
[cannot apply to akpm-mm/mm-everything next-20260226]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260227-033239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260226192936.3190275-9-joshua.hahnjy%40gmail.com
patch subject: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
config: powerpc64-randconfig-r072-20260227 (https://download.01.org/0day-ci/archive/20260227/202602270607.dJP65LGH-lkp@intel.com/config)
compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270607.dJP65LGH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602270607.dJP65LGH-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/zsmalloc.c:813:17: error: call to undeclared function 'zpdesc_objcgs'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     813 |         bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
         |                        ^
   1 error generated.


vim +/zpdesc_objcgs +813 mm/zsmalloc.c

   808	
   809	static void __free_zspage(struct zs_pool *pool, struct size_class *class,
   810					struct zspage *zspage)
   811	{
   812		struct zpdesc *zpdesc, *next;
 > 813		bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
   814	
   815		assert_spin_locked(&class->lock);
   816	
   817		VM_BUG_ON(get_zspage_inuse(zspage));
   818		VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
   819	
   820		next = zpdesc = get_first_zpdesc(zspage);
   821		do {
   822			VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
   823			next = get_next_zpdesc(zpdesc);
   824			reset_zpdesc(zpdesc);
   825			zpdesc_unlock(zpdesc);
   826			zpdesc_dec_zone_page_state(zpdesc);
   827			if (objcg)
   828				dec_node_page_state(zpdesc_page(zpdesc), NR_ZSWAP_B);
   829			zpdesc_put(zpdesc);
   830			zpdesc = next;
   831		} while (zpdesc != NULL);
   832	
   833		cache_free_zspage(zspage);
   834	
   835		class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
   836		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
   837	}
   838	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

