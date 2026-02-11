Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C929CE9E2F9
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5006B0005; Wed, 11 Feb 2026 07:32:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62E36B0089; Wed, 11 Feb 2026 07:32:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C433D6B008A; Wed, 11 Feb 2026 07:32:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B3AB16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:32:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5FE661403C5
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:32:46 +0000 (UTC)
X-FDA: 84432114732.27.F1F3CD3
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0171180014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:32:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dX1GSjYQ;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770813164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpbkHMVOiy7h6xzUa+olz5JyQXkDzh45qhabu9+m2n4=;
	b=sSC3eu0dq10Z7WYnUIZ0ESdK9zaxYYbRXHxks9DSND4JeATHuIczF+nkizn9yhJIaoPorr
	pFNId2DfKH7KS4ozO9HeO/iideNczQD+mEBwmYD6l/g4P+VHG+7jKPvLilDs/TObBUjpRd
	SaeAG1+TXodwD+qOub9ejCAvBaxi6us=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dX1GSjYQ;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770813164; a=rsa-sha256;
	cv=none;
	b=ynLjCee7aAvC3ZClhIARYkaf0Wq6q2b8RFvSMIfcT51wJiMeCZyBRy/rjmvnL5vJvGDLRr
	eR3fddiiK7WCqBfXPfWfBsgpqIxt57OaBwUI4DxQt23+toFHD+pT41DfkPkUC5gfzcmq/W
	iZxwIUN/c9Ss0dpP/Uq2HrPkDzMGa9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770813164; x=1802349164;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QAByPVqT09++FJk0uuU+1F6APVuMo+EbFVRjVQuki6A=;
  b=dX1GSjYQnQtK6RMIDfmq57Kz7lzyzuv/21PiSXrpXuQvALj4OX4OpQQF
   w9AHKJhw7GurDl/o8A/xj2nT8RfhkjlnKjTY3euXOy1XHUxVvlUSeKdNl
   I3VLLFgoL7GKnGt+Gq2hYcga/mlNv9o0nsJrj27+JHQjRFAeTNzBg5JM9
   7r7SILOxOfsNNh+4530wuBNJReYvVdIYZMuEIXcHQAIib6psBKRle3pIv
   Rs7mIQJ9nvjZOzZs2eoe3usR5jsRX8Z3xX7ZqodA0tJTndqunLlxDVCQn
   ZqI21eCWmIM0DiQOABd8bT/nyo52D5xxDyFThQIwsyBVnaYwPMdjJF8Cc
   A==;
X-CSE-ConnectionGUID: YpIQTDxuSVyjsMle6GQGog==
X-CSE-MsgGUID: b6nEoF09SGeOgVX4U9+Exw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="72145098"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="72145098"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2026 04:32:42 -0800
X-CSE-ConnectionGUID: Lp5x3XOyS7a+N5GY+/X3LQ==
X-CSE-MsgGUID: VWmLSFPXRma1eVX+c5/yVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212327590"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Feb 2026 04:32:29 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vq9OL-00000000py8-3rO7;
	Wed, 11 Feb 2026 12:32:25 +0000
Date: Wed, 11 Feb 2026 20:31:53 +0800
From: kernel test robot <lkp@intel.com>
To: Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel_team@skhynix.com, harry.yoo@oracle.com, ast@kernel.org,
	daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
	hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me,
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
	pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH v3] mm: introduce a new page type for page pool in page
 type
Message-ID: <202602112054.QKfqC0UR-lkp@intel.com>
References: <20260210114712.55072-1-byungchul@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260210114712.55072-1-byungchul@sk.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: xf4md1eoirexqyrp8w6nj7nbfk1enujx
X-Rspam-User: 
X-Rspamd-Queue-Id: A0171180014
X-HE-Tag: 1770813163-197690
X-HE-Meta: U2FsdGVkX1/sMJODFT+zWSFweXmzUg2tE9xO6qwa+nqga85jqiNPPHbDwGmEy9rO+5h4lboGK1EY5VafSnFN/Ptlz7pVnwMnC9a7Okx0vPavi7HIWhR2jxmyuf+Q/BrjEtnzXkwDozsBR/tfdopraPIRx7JZSAefTpDIQD5npS6g8fHNPatbR6jGXzFa4XR/vgdzz+lfyfBIANWroTyB6IwUuSmJeNqyISqUVjw8GE3RQdUxPJUUubfmDpv53xN+CRW+lRLvIb1qKHGp+HlJzApToHfVtVCny6APadt6FmDsy0/4FvyaqsZicH7XuXSQd9J5hYzm5A1uShJKYqjlO369ZRf9VSSMvKWy4+xcFm6zojAAe4Fu8qJcthCQRNWppu0BvaCPR+Vk1NZVlGhfWrGrfAzoK9ojZftd8nkdxZi5EyyS0uGfnqgE+f1rxf1xef/EGSX4CBWnU1FHVzusDUstVrNIehSuYLMSXMRyF2IPOTuOm/WsAadfIXVO5tQBgu7v61W8LhaK6uWKgfdR7r2z2h7lyaRiFOU+aQeTfxiL5wfkW9xBYccXXUsO5I0J/BFyX1cFntaKX/I3MOdyaU2s71TMiS6YDhK/O0gFsKB2v0sW8TYvBY8yKfmhbw4+tJr/HCpX5aFUICOAXsXWh06ZhyEBrFEx1c8G841uMntr+3J+gaU/ucCE+63Dip5c9viuWoh2qHA4I6fT1mv9HT53JNUxya3em2Gd+wkY1L3N8T8JtXmCT8CBTAD54CDBUrErZN38lXJEpGY4wvOuLLRaVoW62NBtH45nSItRab4GKAkt9HM9ZyUW/o/f5hmy8S2Ljz0rlWGTE77UAmWFYfPNF35nzNDUukhjldmtE4ULqoaIpV85f7AMa0H5rA/+Z7IOkvtNXle7mlLlqahDOgLHcgEvcv1aGVVYtyJSxLGL/JvzVk0xnYkmCYMZ1OWLYoJOirbNJsd4FoT+fE6
 Hb2KMCp7
 XdH/yzjFxhidokSEPJgDXaHdntaFXDAuRVfvaYtsxOi0R48znQWYRJ+HzYHg81EWiNaur7iAGghw3wm5AxGg720FG9ZOXHBRjKbJjFzPam8VdvLUC+xTKpX2a08PyMFCzU3YnWAgnFYvBpC1rRYHrv1nc82wJ3VN5i1/SMAv5268h01FNooZ0tQyQSStOOLyAizlOsJ9as6+DctbgIa7FyqCTIeFowMYLxIT8xRGvHn5AcNNTwb2bi4R3cNvE8UpdUlqXTLOYnSmU6P7yLcuE96MP7hMYmeB5Ci7yBkCvDq4x3YKNfGuhmYOdV+t8meUUqqnA9BJ66RqnO7yOHVy6ehrwIuAF1rUhy7AHBRF9nzXJ22HWSf5RUgSirhSQKmFACmtDh/dIRANX5aqXD7G1u+MKkhrZo+AaXkDHMNB0PwNLNEXageUMHX6LTVXZS3Iu+Q7SUjhczSmn+6RkO6TXFXDciAPa2ZeHdeghby4b9um3ktZot0mMSkK+iA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Byungchul,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Byungchul-Park/mm-introduce-a-new-page-type-for-page-pool-in-page-type/20260210-194920
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260210114712.55072-1-byungchul%40sk.com
patch subject: [PATCH v3] mm: introduce a new page type for page pool in page type
config: microblaze-randconfig-r134-20260211 (https://download.01.org/0day-ci/archive/20260211/202602112054.QKfqC0UR-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260211/202602112054.QKfqC0UR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602112054.QKfqC0UR-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/core/skbuff.c: note: in included file:
>> net/core/netmem_priv.h:21:20: sparse: sparse: cast to restricted netmem_ref
>> net/core/netmem_priv.h:21:20: sparse: sparse: cast to restricted netmem_ref
   net/core/skbuff.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/inet.h):
   include/net/checksum.h:33:39: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected restricted __wsum [usertype] sum @@     got unsigned int @@
   include/net/checksum.h:33:39: sparse:     expected restricted __wsum [usertype] sum
   include/net/checksum.h:33:39: sparse:     got unsigned int
--
>> net/core/page_pool.c:715:20: sparse: sparse: cast to restricted netmem_ref
   net/core/page_pool.c:739:20: sparse: sparse: cast to restricted netmem_ref

vim +21 net/core/netmem_priv.h

    10	
    11	static inline bool netmem_is_pp(netmem_ref netmem)
    12	{
    13		netmem_ref clr_ref;
    14	
    15		/* XXX: Now that the offset of page_type is shared between
    16		 * struct page and net_iov, just cast the netmem to struct page
    17		 * unconditionally by clearing NET_IOV if any, no matter whether
    18		 * it comes from struct net_iov or struct page.  This should be
    19		 * adjusted once the offset is no longer shared.
    20		 */
  > 21		clr_ref = (netmem_ref)((__force unsigned long)netmem & ~NET_IOV);
    22		return PageNetpp(__netmem_to_page(clr_ref));
    23	}
    24	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

