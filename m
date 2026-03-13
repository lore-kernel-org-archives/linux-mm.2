Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C6B3106FD9B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 08:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4682D6B0005; Fri, 13 Mar 2026 04:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A076B0088; Fri, 13 Mar 2026 04:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369BF6B0089; Fri, 13 Mar 2026 04:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25DCC6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:01:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E9EE5B462
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:01:23 +0000 (UTC)
X-FDA: 84540294846.11.8FDB70F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5676B180011
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:01:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDoNG1Oj;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773388881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttx0Tr3kyb8QR9nabs/hfUO/rWJ/GX8YHk+IyxkRz8o=;
	b=ndySng7amH9wp+7+D4qJVtXRzGIplFKhUGyCXQrJuuz7W6IXseJjZ8FXKZNaX4tZ2MAls5
	3aR7T4Vs9Sh+vG5rHjSzix71meYFZjcHtgDFmitIJOYFSjeU+sKg2XmyHNeO4x0IBcD+xm
	8nUFzY3kUY+oTif7pqGFndkm0RzDeu8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BDoNG1Oj;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773388881; a=rsa-sha256;
	cv=none;
	b=Un/yC7u5jiTFFiwrCySjVIhk86GsP01c6V35LgophdRbaVGzglQDL5AE9kPR4Dsg//nJPY
	zx5JpQAc5zwzYIhsR3o3PXAoySthmtHLmAAwlhKHjn/h53WYB1mQaPgQqRBZHDtCF1eFwb
	Bgfs9w4aEs8bDCHhgqtb1Ba3WlDIOec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773388879; x=1804924879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JvNTqagp4mqbAwOTcW6MXZvJNobQB+7EqHcWBKchTHw=;
  b=BDoNG1Ojc9LcCJCByExs6mQ1OcPkzoqY4zqkQsGWP8JGpEMbFEsDgS+D
   f99M7wnp0xR2LbeeKLRRbAv/z0lqXo/CQUvow92bhU4ILQt+5+3l8tYim
   MZjqTu/GjxNNmsUUCUf61pBhc321cPTorP6DHjzEe+qVvW9JFmNVnI8+m
   c8GRuPFoymvggXnOxAtm+6Fq5jG+40MrBzWfvEkrwxJPjjfgiQXavvVbb
   TVOpq8jLvU9gESiNqWvwfulnBOv0lVieMYi1zQ7iz6FtZFH8yx/7/ZHTl
   ym8pZsr227u9L3z9nVuMpmSyXCleip/vWi0+73yIVEaTCASYqb02QA9XR
   Q==;
X-CSE-ConnectionGUID: 5tx3ZPPmT7iiu6eHCsZ7jA==
X-CSE-MsgGUID: 5DsfRMtfQreAbzz7Hnc8bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="85974403"
X-IronPort-AV: E=Sophos;i="6.23,117,1770624000"; 
   d="scan'208";a="85974403"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 01:01:18 -0700
X-CSE-ConnectionGUID: EYl+/SLnSKCFaotlGPV5cA==
X-CSE-MsgGUID: YqZtShI/RQij3bsNb/BACg==
X-ExtLoop1: 1
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by fmviesa003.fm.intel.com with ESMTP; 13 Mar 2026 01:01:11 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0xSH-000000003dp-1Eej;
	Fri, 13 Mar 2026 08:01:09 +0000
Date: Fri, 13 Mar 2026 09:00:33 +0100
From: kernel test robot <lkp@intel.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-ID: <202603130825.eFqVjdWW-lkp@intel.com>
References: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5676B180011
X-Rspamd-Server: rspam08
X-Stat-Signature: gkuh4wtm816xijwui8imnq6urj4da76n
X-HE-Tag: 1773388879-26092
X-HE-Meta: U2FsdGVkX1/z6RR0XPjV/S05BTi1bkFf1IaeWLSzj5otGyTRu6vHvUd/cWLJAAV5v8w6D3ro4gWt+eHoqFfQzofwCiKAjlS2JxXyKRE+s4oqIihzMP7le78meJIfkhOZ+bki4nx2pMDFx/bfzUdeoaF3F/qOTvMbIvpQN1Y8VoDanXR0wYXbuKLUSnXj+b5h0actBXVdJdGCTsVi8ykZq9/ItcNTVJ0dSCbAmEvW41ygGq+mIFK2Eh7lbraUZDjFDx06RXzIEypHKgnN06pVb/Ukd+a3zrF9hAb6oIuXPnp8tht+JwI2FaZZJoFor45bAxqrUqgR95pqBjikZFQbDWPlf3MkTYNTr+3fz4jqvIaSGCuLIBkWqAa6WwXTif5fY0LVCn0mnWTQOX+hJNobJeKiGQt2kGAmKT/cdYPy0cpzkPq7yTfgQyPbUtZ+0t3YIR3UbRjFYWk2bGuK27dZALIRMxF6ra/GfjFADRFNX23G5gntRbIfVU5r7pQ8MfHald7bLwzsfHVNaQaZQI+gF9V1sUtPAtZhAoxWf5VPy7kmc04rLzISf0hWnUWcgJJHsaOcSxrirHMWcspmVGYB4b8P+CubfGjIXutu+jFbCLQmjR7DgGMIrJZbooxRtKWmLXswcEu4fC00Avwmu1U81nV5OihiU7IekQFNPpQy6i3ULsvqyuMbrlwb2Ovu5rNLVLcU6ODfvFi+fF4baIWJC7cb1NL4BwNi8eLNKC3pF+Sxoj8fhVkxKHLTvnXyY75LmkLNIRVWw8zlEjR9r75u7+cn3abdNc1LM0OJpT722DQmzUv7FTwn/qXrE4GIgLIko7VklHUJqktaKu8xSPoOF7onabKiwc28G5f3sRtQK9X3Q/U9QVWKf8iS8fPWcL9pMrQ7DUilLjILQZDeZprn/cihDOPKHjWJz4Ksgt/LGtevRHIjNp+lzWuG+4tbVx7aULunQJx6hgeYY51r0N0
 IQu8LU9k
 LjULBMcaDTEJBfPKZssgx/XTCbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20260311]
[cannot apply to akpm-mm/mm-everything char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus brauner-vfs/vfs.all linus/master v7.0-rc3 v7.0-rc2 v7.0-rc1 v6.16-rc1]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes-Oracle/mm-various-small-mmap_prepare-cleanups/20260313-113314
base:   next-20260311
patch link:    https://lore.kernel.org/r/56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs%40kernel.org
patch subject: [PATCH 01/15] mm: various small mmap_prepare cleanups
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260313/202603130825.eFqVjdWW-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260313/202603130825.eFqVjdWW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603130825.eFqVjdWW-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/util.c: In function 'mmap_action_prepare':
>> mm/util.c:1360:1: warning: control reaches end of non-void function [-Wreturn-type]
    1360 | }
         | ^


vim +1360 mm/util.c

ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1338  
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1339  #ifdef CONFIG_MMU
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1340  /**
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1341   * mmap_action_prepare - Perform preparatory setup for an VMA descriptor
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1342   * action which need to be performed.
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1343   * @desc: The VMA descriptor to prepare for @action.
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1344   * @action: The action to perform.
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1345)  *
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1346)  * Returns: 0 on success, otherwise error.
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1347   */
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1348) int mmap_action_prepare(struct vm_area_desc *desc,
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1349) 			struct mmap_action *action)
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1350) 
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1351  {
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1352  	switch (action->type) {
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1353  	case MMAP_NOTHING:
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1354) 		return 0;
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1355  	case MMAP_REMAP_PFN:
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1356) 		return remap_pfn_range_prepare(desc, action);
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1357  	case MMAP_IO_REMAP_PFN:
732e4e2690c96d Lorenzo Stoakes (Oracle  2026-03-12  1358) 		return io_remap_pfn_range_prepare(desc, action);
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1359  	}
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20 @1360  }
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1361  EXPORT_SYMBOL(mmap_action_prepare);
ac0a3fc9c07df7 Lorenzo Stoakes          2025-10-20  1362  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

