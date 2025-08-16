Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5595CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 16:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3748E0026; Sat, 16 Aug 2025 12:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B408E000A; Sat, 16 Aug 2025 12:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532FF8E0026; Sat, 16 Aug 2025 12:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35DB88E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:31:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A5B74B9A48
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:31:00 +0000 (UTC)
X-FDA: 83783159880.18.02B6EBA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E216C0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 16:30:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Rm/aPLPL";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755361858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/zFl6OTdh7Nc1iuXR3BGWZ/+TsSlJrsSXs1/J8+T6k=;
	b=b/qUkbW/PMsirLxreh0skctit/xKKoXMRRmvH3zGiJxmNJiJQFlX/Tg8ib+x/B1K/aodY9
	gcJqkkfC0wBT4HAaiFo3pPD4sS56M7SB8sNCs3ueRX/uekNuRxXdV28u8sBMvQmXVywq9O
	ZwFOlKzaYdOk3hcUPYsFvH5QXMqLCDE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="Rm/aPLPL";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755361858; a=rsa-sha256;
	cv=none;
	b=NRSLaQ/ngJzPIHkjI47zbTIYWy9oj2FOI8BiG0Wl6L9FUVJhgMWX4UN9ioLzD3AI8AFQvX
	MzZrcgSKcC6Al984dBYUsDCQYsWMtVoIuBEHH99+rspck8qozFdVHkPGzYgGKYxtmUHKuZ
	gjf6el9zMLc5/7TWymXha2ELvbsHptY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755361858; x=1786897858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZFfAo8apibsWsI1omhLl8iawazNCfUYxTJ6h2jfQBZY=;
  b=Rm/aPLPLOA9wxKXndJzwdfqN/1HrOR7bcl1MYitmGIZnl9TwMtXUfwqX
   elZyWyRkHDJrLYwSza47/f5pRP/8iZNrnhOTRY/IDR9W/VBL4uy7r3n9x
   ux12CGky5sxkShYHMcU3jvxOs3Ju60BKoqD1AFmMUlMxCDieRQz9qTnge
   Xm0Ctp4GNnsxuMo72PIDevqc6aNsDyAgzYvKk8xQiGx2B5pH/QbEA3lbK
   qk52PFua6BO3z513JEwwQxgyAMdnx1HTQG+nor5z5mFRhCcYmI18HvbSe
   JoQ5zhxWB6pOkCJOARKdhdEvGgt+0WM2Z7gp0zknHjlUcfviEbo7e/xsz
   Q==;
X-CSE-ConnectionGUID: kQsCVfjOQpieB0YUM7hfxQ==
X-CSE-MsgGUID: QhmOuxpsQ9O3y1Hd8/n/Og==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="69020225"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="69020225"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2025 09:30:56 -0700
X-CSE-ConnectionGUID: PZSfjvSKRIqbKzG5XmYmLA==
X-CSE-MsgGUID: CK+ohIFiTxO5RXZQZAbzeg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167481802"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa008.jf.intel.com with ESMTP; 16 Aug 2025 09:30:52 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1unJnu-000D0S-1k;
	Sat, 16 Aug 2025 16:30:50 +0000
Date: Sun, 17 Aug 2025 00:30:16 +0800
From: kernel test robot <lkp@intel.com>
To: Xiang Gao <gxxa03070307@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
Message-ID: <202508170014.PK57XSd7-lkp@intel.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816042842.3959315-1-gxxa03070307@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E216C0005
X-Stat-Signature: m88uqaxyhsgoqza9aurmfy7iyfyzq5bf
X-Rspam-User: 
X-HE-Tag: 1755361857-470079
X-HE-Meta: U2FsdGVkX1/Zm+G/mvzDCsBVT794rz2UNRlxc7DjqyPa6nLxQIm164/6DENpHL3ByMkcFm9OMqKnFOFQwTOGj5Y5Z7S+4Mt+5N+gfDdaY7VaKXv8zFRF6w0ljhhm+NO3ycpHjxxPRL6NKqg9nJ9ARwSevyltyCHHpJdB8t/8EzU62wcG0By4aUiuGFZlasn6ofa0OFl0NFKefCf95AaB+aXREj455U981pfJDq8nP2ghNP8Uit7phoaaHkGiZP3iuWvYyAyr+xx2TK4pqSGDd0K6L6/MiBOmNr/S5VuNGZWEe+fBzIsaRcSmy9vlytrdoBd/5NtPRIBEp/BXAowZEE9Y+e88du1APAbesj9jyB+S7y0YOjGkL7JjqgRr3VnSJJgVy1vG38IwCTvMZHWllOlTEu1DN2Esui6V3iHGWmU4365ttAnfh/nyUXBrymXjsRDGqX/oUflc9ADBzHWft8lLXAGfrFc/H6RJok/7MUqQ3/atKWsW+l2snLp1+RTyGZWIxsOhegSpv+Oarem+iCdYZms8Hpde8DFw8r3JK1LENXTv8MkxpubgqfeGXJab3kYaP/CC9vbnIRyxzGAvJfY3YyAk2lQ4BeVkHkgXXW+Ilh+b0WxVruQbsvz8XyvjZSMo8K+5vwhReH26joI3H+PR2+u1vzzKe7DaPz3cFFSPcApUNRlEQbFphJl8g12sodyF94WwdRm5URY17h77EVew1MZnFu0nVIdoIqKjWFU9msPcAwHeAbLxyyHfOySX5LboI8QrzvB43IodBpPUijjRAwOrF88m33gCG3Tghn5wpb+6LS1WqpkRFAuxPjJ5pOqpf+9ePV0mBmrvTOiTV6Ld2eoiDebIKyB3vIHBHyDIJHTzjzp89GyIeKN8Ckq3BebHY1S0CB+sdlBtHtBXjcGdCbrAtqsMKZTFN6/yDmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Xiang,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiang-Gao/mm-cma-print-total-and-used-pages-in-cma_alloc/20250816-122940
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20250816042842.3959315-1-gxxa03070307%40gmail.com
patch subject: [PATCH] mm/cma: print total and used pages in cma_alloc()
config: arm-randconfig-002-20250816 (https://download.01.org/0day-ci/archive/20250817/202508170014.PK57XSd7-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250817/202508170014.PK57XSd7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508170014.PK57XSd7-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/cma.c: In function 'cma_get_used_pages':
>> mm/cma.c:784:26: error: 'struct cma' has no member named 'bitmap'
     784 |  used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
         |                          ^~
>> mm/cma.c:784:41: error: too few arguments to function 'cma_bitmap_maxno'
     784 |  used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
         |                                         ^~~~~~~~~~~~~~~~
   In file included from mm/cma.c:34:
   mm/cma.h:77:29: note: declared here
      77 | static inline unsigned long cma_bitmap_maxno(struct cma *cma,
         |                             ^~~~~~~~~~~~~~~~


vim +784 mm/cma.c

   778	
   779	static unsigned long cma_get_used_pages(struct cma *cma)
   780	{
   781		unsigned long used;
   782	
   783		spin_lock_irq(&cma->lock);
 > 784		used = bitmap_weight(cma->bitmap, (int)cma_bitmap_maxno(cma));
   785		spin_unlock_irq(&cma->lock);
   786	
   787		return used << cma->order_per_bit;
   788	}
   789	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

