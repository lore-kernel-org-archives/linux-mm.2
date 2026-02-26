Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DBBFD9E1B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40296B018C; Thu, 26 Feb 2026 16:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A825C6B0193; Thu, 26 Feb 2026 16:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9397D6B01A7; Thu, 26 Feb 2026 16:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF5D6B018C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:49:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C9BD58057
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:05 +0000 (UTC)
X-FDA: 84487948650.27.2253EF0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf01.hostedemail.com (Postfix) with ESMTP id 753B240006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:49:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X6RxJfFb;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772142543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtHCoGN4pBpiqniuwwWkswH/EVBJwY+mb0LQaV3AETU=;
	b=KOtgro29lxqlVdk7FThz0Qzuf9WpX/kt5WhouWZt5tUs6cEg7ovIeE/ZORh5eg7tsRNxyS
	sCAuX+6T48hiDXzeCLOki3Rg4pXX8mRKrhe+YzSheWWXHRH6Pz1l+2xcOOSpit9Zh7QJAM
	68JBS3jQ1BdTWT6gPkHWYGR9I1B9Qbc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772142543; a=rsa-sha256;
	cv=none;
	b=kn4YXw48l9qlZ/URPNSeVLCYNC1jM8JNpwU01fQhaWGmi81Otkl4IBpqqxC6kexha0n5qu
	5JBr0EjG/4eSBB3vi3ZyWQSuakVxpCu8+o0Ve32tPI8lU4xfj3HibL1YwEpax9TRf6VXOT
	gnvi6hZIEmyFHYfjlKdBtnL3ukQxBdQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X6RxJfFb;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772142541; x=1803678541;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mDdNfF4vFA9G+p7Lcuc/r/WYyaBGmUyqdhgXlIoQNSE=;
  b=X6RxJfFbjtmkpk3NV/qnowQ+oRNCEf1mTTXRbHHURtyMHYVo3JAepIpz
   XUGEA1ABEVTvsr+lxdoS2MKJ+nrWWMdGnS/eQR5YByBM0XpF9Zn/DTm9d
   3zc6/AixNClT7Ua/BnHlwLJfWRnuEqb3T6Zwuji+nytJ0ifYqbT3emjJR
   ZUfkrQ+bublOsGvcyvBJk/QnugDOtxx1MRETLbAI4HmbEHmaOllOreZIv
   SuqP6GqhHSQGLoIzOOzhNL1PxsXQQ8xb5SK0pjaK5rGBKaPGKtNug6d0+
   1Gx/ggMqQNwia1l7GPT0/OrMu5JZaSe14l59gKSX/MhRj1S6qoqCuqOu3
   A==;
X-CSE-ConnectionGUID: v/wO6nkVThymXR5e6pi36A==
X-CSE-MsgGUID: WyYXw4TaQGeDVP3SE7BnSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="72921069"
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="72921069"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 13:48:59 -0800
X-CSE-ConnectionGUID: Hd6wjXKgS2SiCJxOoEzJUw==
X-CSE-MsgGUID: 6UPgMho/RmqrsOX4n+kmCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="221702877"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 26 Feb 2026 13:48:52 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvjE1-000000009uN-3P1V;
	Thu, 26 Feb 2026 21:48:49 +0000
Date: Fri, 27 Feb 2026 05:48:05 +0800
From: kernel test robot <lkp@intel.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>
Subject: Re: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <202602270508.8MKXotxZ-lkp@intel.com>
References: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 753B240006
X-Stat-Signature: qrguqc4455kqi8915k8h6uacw3gmfwkq
X-Rspam-User: 
X-HE-Tag: 1772142540-400292
X-HE-Meta: U2FsdGVkX1/I7yz3fHHvuyVO4aSIj5apX/08HVgDnL1o/spf/NM/Ek5/Neo88/AZomUTnviec9jLlZT5WbZc6gdS88NVd+LKpiZBYha6G2VLxK4EKbIb3Gt0nPjD/LaWlSRDa28pxcpXp50P7QBKXvOmZjizi+lH1xvF//panxLGegSgcHz/rucPw+yTZ1Jqd/OQbTOXz2vQHkHD57EOTidnb9fqV72Z1DD2eECkVSAGt+gRYBV7MIvjq9tq/adm/Q2m+PI0En14F3S1JxgIpv231tvkqeAYUIgzg2U4sCDInhBUsrCdEAk+FCRI/S2VnRPNsbvDCTzI+OpPhw6caxo6uYbWZEAMlAjJnfEl5yx3z8OUNpR4hYgIX1BdENh3sczHLHAVbmW16mA1rxjLtDRmQ2PQURtaisJUrtOP99QbMjNT5Lll+Hkm6OgBjk76RIrE5IwQ2/3yr1h+oORzGRTJDRP2odhgkK/FsF6C2hri6kYjyC81CkwgWYyZVQelzeL4nJ3Jzgvhc97Z28S+Nba8oyliCGF2dfOsqulh0RysAULFaFcKv60vGVsKR8uOqvk/prxZd8mhW1Z/vtA09LUt8ourT74nss6kkO79H7R2oJ/IQzMNf1ezR7Z7jmyPL82smSOsx/QWXJaipFtUZISIYCkSJRFAUBrjBkje+Osj8TEjwZYcVweW8Gvtg+GU27SXzqxTDlHJgP/p4FN47HI5jxXA1ROandU7VyYY6xJl+fw52kE1kUnkfoScn/ysPkmP2UJc91A1x7987No3oSsuzb2pxZvvAA+R1QYjeybvgTxNIPoBk95bg5Nik+o1bBn3vJvfIB7R+EBzZuYGlXzh3b5heShau4ebcToDn2kfr4Opo13RPPiE9TtDEB9smC5VvFSgY7a6V0mbwXys2TB+QHuwrpsCjJFHFEOr353TC7nldqoekDVI1RP9UIW+kkokN7FG5G2e1Wf0udE
 avhnrPeW
 EL4Rjv/eVCV3tNOhKx1KtyZRaNFZVxzuE88flJ7QURvlPWprITYLy6dnEmF5Rvcdyv+eHHP3IyMIO4T0FPdrPP+UIF/q+p1Iad9BrML/oCRyJdPbOeXQIVQRxTyST/LqBxuqY/+uIW55egbmwF+88E3zHFLQ4VdsIGyTUJr1cRKwF2Xs4KS+MXOJaQlsKMa8JPHUmitWwj6LsiHbO7elDFCTonPV4+Rh9G6GNN7I2BdOQ/j/mwOgysejxAjRby6StK503DArMpGsuqzs5UrE2hIqdOZnLHWiQou0VovAocsVzLwl9GUcJEgPzkk6Zf/P49jr5kP2eSe5iP2NWkN96+lDSrpLSI6OPa25ZX0HRHD//SfxqTCCXmCoZDwJnDxJD4jG3XMOnV+VSRpU5Okadgz/IFwSLPdGdIf+JjALAXkmJEpIX54ZdwAQfS40PZgUzHGYtKQDIhrPsFcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Dmitry,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc1 next-20260226]
[cannot apply to akpm-mm/mm-everything rppt-memblock/for-next rppt-memblock/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dmitry-Ilvokhin/mm-introduce-zone-lock-wrappers/20260227-022914
base:   linus/master
patch link:    https://lore.kernel.org/r/1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d%40ilvokhin.com
patch subject: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
config: microblaze-randconfig-r073-20260227 (https://download.01.org/0day-ci/archive/20260227/202602270508.8MKXotxZ-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 11.5.0
smatch version: v0.5.0-8994-gd50c5a4c
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270508.8MKXotxZ-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602270508.8MKXotxZ-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from mm/shuffle.c:4:
   mm/shuffle.c: In function '__shuffle_zone':
>> mm/shuffle.c:88:31: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
      88 |         spin_lock_irqsave(&z->lock, flags);
         |                               ^~~~
   include/linux/spinlock.h:244:48: note: in definition of macro 'raw_spin_lock_irqsave'
     244 |                 flags = _raw_spin_lock_irqsave(lock);   \
         |                                                ^~~~
   mm/shuffle.c:88:9: note: in expansion of macro 'spin_lock_irqsave'
      88 |         spin_lock_irqsave(&z->lock, flags);
         |         ^~~~~~~~~~~~~~~~~
   mm/shuffle.c:141:52: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
     141 |                         spin_unlock_irqrestore(&z->lock, flags);
         |                                                    ^~~~
         |                                                    _lock
   In file included from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from mm/shuffle.c:4:
   mm/shuffle.c:143:47: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
     143 |                         spin_lock_irqsave(&z->lock, flags);
         |                                               ^~~~
   include/linux/spinlock.h:244:48: note: in definition of macro 'raw_spin_lock_irqsave'
     244 |                 flags = _raw_spin_lock_irqsave(lock);   \
         |                                                ^~~~
   mm/shuffle.c:143:25: note: in expansion of macro 'spin_lock_irqsave'
     143 |                         spin_lock_irqsave(&z->lock, flags);
         |                         ^~~~~~~~~~~~~~~~~
   mm/shuffle.c:146:36: error: 'struct zone' has no member named 'lock'; did you mean '_lock'?
     146 |         spin_unlock_irqrestore(&z->lock, flags);
         |                                    ^~~~
         |                                    _lock


vim +88 mm/shuffle.c

e900a918b0984e Dan Williams            2019-05-14    3  
e900a918b0984e Dan Williams            2019-05-14   @4  #include <linux/mm.h>
e900a918b0984e Dan Williams            2019-05-14    5  #include <linux/init.h>
e900a918b0984e Dan Williams            2019-05-14    6  #include <linux/mmzone.h>
e900a918b0984e Dan Williams            2019-05-14    7  #include <linux/random.h>
e900a918b0984e Dan Williams            2019-05-14    8  #include <linux/moduleparam.h>
e900a918b0984e Dan Williams            2019-05-14    9  #include "internal.h"
e900a918b0984e Dan Williams            2019-05-14   10  #include "shuffle.h"
e900a918b0984e Dan Williams            2019-05-14   11  
e900a918b0984e Dan Williams            2019-05-14   12  DEFINE_STATIC_KEY_FALSE(page_alloc_shuffle_key);
e900a918b0984e Dan Williams            2019-05-14   13  
e900a918b0984e Dan Williams            2019-05-14   14  static bool shuffle_param;
e900a918b0984e Dan Williams            2019-05-14   15  
85a34107eba913 Liu Shixin              2022-09-09   16  static __meminit int shuffle_param_set(const char *val,
e900a918b0984e Dan Williams            2019-05-14   17  		const struct kernel_param *kp)
e900a918b0984e Dan Williams            2019-05-14   18  {
85a34107eba913 Liu Shixin              2022-09-09   19  	if (param_set_bool(val, kp))
85a34107eba913 Liu Shixin              2022-09-09   20  		return -EINVAL;
85a34107eba913 Liu Shixin              2022-09-09   21  	if (*(bool *)kp->arg)
839195352d8235 David Hildenbrand       2020-08-06   22  		static_branch_enable(&page_alloc_shuffle_key);
e900a918b0984e Dan Williams            2019-05-14   23  	return 0;
e900a918b0984e Dan Williams            2019-05-14   24  }
85a34107eba913 Liu Shixin              2022-09-09   25  
85a34107eba913 Liu Shixin              2022-09-09   26  static const struct kernel_param_ops shuffle_param_ops = {
85a34107eba913 Liu Shixin              2022-09-09   27  	.set = shuffle_param_set,
85a34107eba913 Liu Shixin              2022-09-09   28  	.get = param_get_bool,
85a34107eba913 Liu Shixin              2022-09-09   29  };
85a34107eba913 Liu Shixin              2022-09-09   30  module_param_cb(shuffle, &shuffle_param_ops, &shuffle_param, 0400);
e900a918b0984e Dan Williams            2019-05-14   31  
e900a918b0984e Dan Williams            2019-05-14   32  /*
e900a918b0984e Dan Williams            2019-05-14   33   * For two pages to be swapped in the shuffle, they must be free (on a
e900a918b0984e Dan Williams            2019-05-14   34   * 'free_area' lru), have the same order, and have the same migratetype.
e900a918b0984e Dan Williams            2019-05-14   35   */
4a93025cbe4a0b David Hildenbrand       2020-08-06   36  static struct page * __meminit shuffle_valid_page(struct zone *zone,
4a93025cbe4a0b David Hildenbrand       2020-08-06   37  						  unsigned long pfn, int order)
e900a918b0984e Dan Williams            2019-05-14   38  {
4a93025cbe4a0b David Hildenbrand       2020-08-06   39  	struct page *page = pfn_to_online_page(pfn);
e900a918b0984e Dan Williams            2019-05-14   40  
e900a918b0984e Dan Williams            2019-05-14   41  	/*
e900a918b0984e Dan Williams            2019-05-14   42  	 * Given we're dealing with randomly selected pfns in a zone we
e900a918b0984e Dan Williams            2019-05-14   43  	 * need to ask questions like...
e900a918b0984e Dan Williams            2019-05-14   44  	 */
e900a918b0984e Dan Williams            2019-05-14   45  
4a93025cbe4a0b David Hildenbrand       2020-08-06   46  	/* ... is the page managed by the buddy? */
4a93025cbe4a0b David Hildenbrand       2020-08-06   47  	if (!page)
e900a918b0984e Dan Williams            2019-05-14   48  		return NULL;
e900a918b0984e Dan Williams            2019-05-14   49  
4a93025cbe4a0b David Hildenbrand       2020-08-06   50  	/* ... is the page assigned to the same zone? */
4a93025cbe4a0b David Hildenbrand       2020-08-06   51  	if (page_zone(page) != zone)
e900a918b0984e Dan Williams            2019-05-14   52  		return NULL;
e900a918b0984e Dan Williams            2019-05-14   53  
e900a918b0984e Dan Williams            2019-05-14   54  	/* ...is the page free and currently on a free_area list? */
e900a918b0984e Dan Williams            2019-05-14   55  	if (!PageBuddy(page))
e900a918b0984e Dan Williams            2019-05-14   56  		return NULL;
e900a918b0984e Dan Williams            2019-05-14   57  
e900a918b0984e Dan Williams            2019-05-14   58  	/*
e900a918b0984e Dan Williams            2019-05-14   59  	 * ...is the page on the same list as the page we will
e900a918b0984e Dan Williams            2019-05-14   60  	 * shuffle it with?
e900a918b0984e Dan Williams            2019-05-14   61  	 */
ab130f9108dcf2 Matthew Wilcox (Oracle  2020-10-15   62) 	if (buddy_order(page) != order)
e900a918b0984e Dan Williams            2019-05-14   63  		return NULL;
e900a918b0984e Dan Williams            2019-05-14   64  
e900a918b0984e Dan Williams            2019-05-14   65  	return page;
e900a918b0984e Dan Williams            2019-05-14   66  }
e900a918b0984e Dan Williams            2019-05-14   67  
e900a918b0984e Dan Williams            2019-05-14   68  /*
e900a918b0984e Dan Williams            2019-05-14   69   * Fisher-Yates shuffle the freelist which prescribes iterating through an
e900a918b0984e Dan Williams            2019-05-14   70   * array, pfns in this case, and randomly swapping each entry with another in
e900a918b0984e Dan Williams            2019-05-14   71   * the span, end_pfn - start_pfn.
e900a918b0984e Dan Williams            2019-05-14   72   *
e900a918b0984e Dan Williams            2019-05-14   73   * To keep the implementation simple it does not attempt to correct for sources
e900a918b0984e Dan Williams            2019-05-14   74   * of bias in the distribution, like modulo bias or pseudo-random number
e900a918b0984e Dan Williams            2019-05-14   75   * generator bias. I.e. the expectation is that this shuffling raises the bar
e900a918b0984e Dan Williams            2019-05-14   76   * for attacks that exploit the predictability of page allocations, but need not
e900a918b0984e Dan Williams            2019-05-14   77   * be a perfect shuffle.
e900a918b0984e Dan Williams            2019-05-14   78   */
e900a918b0984e Dan Williams            2019-05-14   79  #define SHUFFLE_RETRY 10
e900a918b0984e Dan Williams            2019-05-14   80  void __meminit __shuffle_zone(struct zone *z)
e900a918b0984e Dan Williams            2019-05-14   81  {
e900a918b0984e Dan Williams            2019-05-14   82  	unsigned long i, flags;
e900a918b0984e Dan Williams            2019-05-14   83  	unsigned long start_pfn = z->zone_start_pfn;
e900a918b0984e Dan Williams            2019-05-14   84  	unsigned long end_pfn = zone_end_pfn(z);
e900a918b0984e Dan Williams            2019-05-14   85  	const int order = SHUFFLE_ORDER;
e900a918b0984e Dan Williams            2019-05-14   86  	const int order_pages = 1 << order;
e900a918b0984e Dan Williams            2019-05-14   87  
e900a918b0984e Dan Williams            2019-05-14  @88  	spin_lock_irqsave(&z->lock, flags);
e900a918b0984e Dan Williams            2019-05-14   89  	start_pfn = ALIGN(start_pfn, order_pages);
e900a918b0984e Dan Williams            2019-05-14   90  	for (i = start_pfn; i < end_pfn; i += order_pages) {
e900a918b0984e Dan Williams            2019-05-14   91  		unsigned long j;
e900a918b0984e Dan Williams            2019-05-14   92  		int migratetype, retry;
e900a918b0984e Dan Williams            2019-05-14   93  		struct page *page_i, *page_j;
e900a918b0984e Dan Williams            2019-05-14   94  
e900a918b0984e Dan Williams            2019-05-14   95  		/*
e900a918b0984e Dan Williams            2019-05-14   96  		 * We expect page_i, in the sub-range of a zone being added
e900a918b0984e Dan Williams            2019-05-14   97  		 * (@start_pfn to @end_pfn), to more likely be valid compared to
e900a918b0984e Dan Williams            2019-05-14   98  		 * page_j randomly selected in the span @zone_start_pfn to
e900a918b0984e Dan Williams            2019-05-14   99  		 * @spanned_pages.
e900a918b0984e Dan Williams            2019-05-14  100  		 */
4a93025cbe4a0b David Hildenbrand       2020-08-06  101  		page_i = shuffle_valid_page(z, i, order);
e900a918b0984e Dan Williams            2019-05-14  102  		if (!page_i)
e900a918b0984e Dan Williams            2019-05-14  103  			continue;
e900a918b0984e Dan Williams            2019-05-14  104  
e900a918b0984e Dan Williams            2019-05-14  105  		for (retry = 0; retry < SHUFFLE_RETRY; retry++) {
e900a918b0984e Dan Williams            2019-05-14  106  			/*
e900a918b0984e Dan Williams            2019-05-14  107  			 * Pick a random order aligned page in the zone span as
e900a918b0984e Dan Williams            2019-05-14  108  			 * a swap target. If the selected pfn is a hole, retry
e900a918b0984e Dan Williams            2019-05-14  109  			 * up to SHUFFLE_RETRY attempts find a random valid pfn
e900a918b0984e Dan Williams            2019-05-14  110  			 * in the zone.
e900a918b0984e Dan Williams            2019-05-14  111  			 */
e900a918b0984e Dan Williams            2019-05-14  112  			j = z->zone_start_pfn +
e900a918b0984e Dan Williams            2019-05-14  113  				ALIGN_DOWN(get_random_long() % z->spanned_pages,
e900a918b0984e Dan Williams            2019-05-14  114  						order_pages);
4a93025cbe4a0b David Hildenbrand       2020-08-06  115  			page_j = shuffle_valid_page(z, j, order);
e900a918b0984e Dan Williams            2019-05-14  116  			if (page_j && page_j != page_i)
e900a918b0984e Dan Williams            2019-05-14  117  				break;
e900a918b0984e Dan Williams            2019-05-14  118  		}
e900a918b0984e Dan Williams            2019-05-14  119  		if (retry >= SHUFFLE_RETRY) {
e900a918b0984e Dan Williams            2019-05-14  120  			pr_debug("%s: failed to swap %#lx\n", __func__, i);
e900a918b0984e Dan Williams            2019-05-14  121  			continue;
e900a918b0984e Dan Williams            2019-05-14  122  		}
e900a918b0984e Dan Williams            2019-05-14  123  
e900a918b0984e Dan Williams            2019-05-14  124  		/*
e900a918b0984e Dan Williams            2019-05-14  125  		 * Each migratetype corresponds to its own list, make sure the
e900a918b0984e Dan Williams            2019-05-14  126  		 * types match otherwise we're moving pages to lists where they
e900a918b0984e Dan Williams            2019-05-14  127  		 * do not belong.
e900a918b0984e Dan Williams            2019-05-14  128  		 */
e900a918b0984e Dan Williams            2019-05-14  129  		migratetype = get_pageblock_migratetype(page_i);
e900a918b0984e Dan Williams            2019-05-14  130  		if (get_pageblock_migratetype(page_j) != migratetype) {
e900a918b0984e Dan Williams            2019-05-14  131  			pr_debug("%s: migratetype mismatch %#lx\n", __func__, i);
e900a918b0984e Dan Williams            2019-05-14  132  			continue;
e900a918b0984e Dan Williams            2019-05-14  133  		}
e900a918b0984e Dan Williams            2019-05-14  134  
e900a918b0984e Dan Williams            2019-05-14  135  		list_swap(&page_i->lru, &page_j->lru);
e900a918b0984e Dan Williams            2019-05-14  136  
e900a918b0984e Dan Williams            2019-05-14  137  		pr_debug("%s: swap: %#lx -> %#lx\n", __func__, i, j);
e900a918b0984e Dan Williams            2019-05-14  138  
e900a918b0984e Dan Williams            2019-05-14  139  		/* take it easy on the zone lock */
e900a918b0984e Dan Williams            2019-05-14  140  		if ((i % (100 * order_pages)) == 0) {
e900a918b0984e Dan Williams            2019-05-14  141  			spin_unlock_irqrestore(&z->lock, flags);
e900a918b0984e Dan Williams            2019-05-14  142  			cond_resched();
e900a918b0984e Dan Williams            2019-05-14  143  			spin_lock_irqsave(&z->lock, flags);
e900a918b0984e Dan Williams            2019-05-14  144  		}
e900a918b0984e Dan Williams            2019-05-14  145  	}
e900a918b0984e Dan Williams            2019-05-14  146  	spin_unlock_irqrestore(&z->lock, flags);
e900a918b0984e Dan Williams            2019-05-14  147  }
e900a918b0984e Dan Williams            2019-05-14  148  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

