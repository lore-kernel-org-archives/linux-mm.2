Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E82710F3DE0
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 09:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CE36B0095; Sat, 28 Mar 2026 05:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E0E6B0096; Sat, 28 Mar 2026 05:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72DC66B0098; Sat, 28 Mar 2026 05:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63E0F6B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:55:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C48138FD96
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:55:26 +0000 (UTC)
X-FDA: 84595014252.03.BFCEC4C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9782F180008
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:55:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P5wOHDeH;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774691724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/IQhpBIUdvnO+K29qERVMLBYlywQoustWg83ZRnyBA=;
	b=FE62nGrwCm4HzR2NVOsLnvRAbs4QluToc7aayJR89VN8+w8YchpLejYhf1zk9F0BJmo/7D
	L/h4hSmOkiqFFUScxLl86Jk4jdRKaw/uOWVDeyVITDwqfI9mICzDONxT1/GukJaZIlc5yX
	vbubbewgr9AND9H506DSvX0JmDTFKMQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P5wOHDeH;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774691724; a=rsa-sha256;
	cv=none;
	b=qhmkTpYYsSQkwluFqFb46dxlK/Vweuf30+apHh3N6bVcpciSJLgAu8AfJUsaJuuhxQBcxf
	CelSUsl+TGcRRVX2OvQg8qtW4SBZpvtjOFDItTWSQTp6KBobh4fWT4z5rc/Xio+BWf9Jlg
	kprggcjexityvho545Fnr12E5YZnHhU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774691725; x=1806227725;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=GAqpCsRCdatJLMn/LB4VPXAG5/+DxNvNB1DDK+7U/SA=;
  b=P5wOHDeHRp4Y66GA2KWu7x+/JXMAz/bDWQghr/AGejDrtUmABprJI2gk
   FAuqBzBQDGgOqUhKha19PwENkQFOtFObymk9lR0d0GMmHQbCW2HTmQ7T8
   MkxVlKYFHIi919wTWOA/DmgBinAxjr/ropKKWt07Xrai/69slvekeXExu
   4udq553lUe21k1q3ivXMC9RFcGcbY5wmAT3qpzAs+7b5y4lJYTAjEIlbB
   +UY5jHvXC9kuVqfmNBwNTg9p9w90kAWJMRw8/O6XCtK4X1anZ1kHU7vrR
   ++wJUetmIMa23JfHvpl+YbnxoEV8VBcswnVnVwMPIjME5erajILsssQL/
   w==;
X-CSE-ConnectionGUID: +jgp05pwQ9OF//OGsv8Cpw==
X-CSE-MsgGUID: NhRKG1qfT72nN54C+xtt2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75633837"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75633837"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 02:55:19 -0700
X-CSE-ConnectionGUID: mkBLqmVQQa+7lsX1dF1hXw==
X-CSE-MsgGUID: nMNCMgLgQ7q8oZG85wWGBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="248786209"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Mar 2026 02:55:13 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6QNp-00000000BI3-3sXI;
	Sat, 28 Mar 2026 09:55:09 +0000
Date: Sat, 28 Mar 2026 17:54:52 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Chris Mason <chris.mason@fusionio.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Message-ID: <202603281736.bi9GWnsF-lkp@intel.com>
References: <20260327014255.2058916-8-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: bpagnrorqo3xwizbiosqoatw7zt3puhm
X-Rspamd-Queue-Id: 9782F180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774691724-543801
X-HE-Meta: U2FsdGVkX1+teoCeryPKZqvM4QUlTBSHs9LNVdKc07S2kows2tnDs22dfO+af2CKEIP5G0XD2guI1CahIegi1RSvtHU1z/hFEWbKu9pAQTUe4vXDnoH7pP8W8UWuA+p5FHkQUMZz5QcA7DBbwbyFClJ912DmYNULD9O6fqKgM/v8sRCBuTp2R2DBmo8iHmqZHdEIHTqohYGRQKZPd8638rs+XxQBDGkjEcevr9eUzdHzFZjRE5s+2DKDXsthssiQaTcrhDbX+02+Yw0NekaABkyStDg6ILsxvcakJGQg6iOoq95NKgQ8vDHvVWebATuPIG6aAdSJoYPlszDlLdqbl3ZmokFVMcascrLAXcr2Pgi8Dbkyhd8P65oOwhaInH0Zx3VN2Zku7A/kqpcy+Mfo7wIpqGBshIe1UyvdicbKZAqFmZGK4xJCSAuzhsk2OpFwzJYw5KutgkdBK/mMI7TWeFdHu9cdF4evIBCQgDkxUo/k8/8rKSoU5fQVi5lMbAeg0DasjyFtLCjBl0+I9XXAMkEOVeIyrHMGiKS1ZjFled7jorgqrhFojmGRfy3g8rMPd6ebYmgg18U7/ElAgY8JKvp+T0U7HahW5igKX7P0eanMKvnvmUGZdlSlWt4k2I7DBl3rnjibc61m0LvMo6t0wh9eXFp/kRwk8AOQZ6HX4BOYUGYaGxmuDmRlJAczbgUcpxxBVUdR21e7K3G3Iux7Mnux7erI+lFyj6ACrVatPu4oh7eGGi+/cwRRDvLDwxsWz8IMAhtaKl7TJohoIIrM3Cw/LicOCDsVSBVOVs4RQo968FFZg+nDf3hBrO+qi08mLCC7Q+vH6xkGJnG5GcIYck7Z0g2lL/2yXybYbnnFCzJ/MMnV9krCo7chW3FCM86CjrBTAEBPYCPwT9OQCXYTyrzBERQ/tFSGyrbPNywyDjo9SBCg5KOfILNEBNRkwd0NcBjnbCKiCaXXi+RnW5t
 AysYSec2
 7SWL7fNl0hT6/f7o5+cmcUz7Z2jPoACm/mEbM4aKSJrzYT9PUVBCKTu6NzMWjcltoEHbxa+m047DpehdA+aMH0wq5cLQGMmfB0WPR69NBQ1GM3lAzdLVxVCN7S3ibE031qx2cY3eBU2+TGmZcys8XfTaeq5UE1MaUh3qxrTWCyAB9iX2MdRQZFkQM5y2yQTwmegz7F22Gp/jaiPWyuu8wQLGbw4dic7MNqD3qIxql4mDjPvOVQl+wX9ntroFzuT8KSpyL5xoj+m+1CQ0LdyTfL3n2VAehYQmKDvnoGMubO28RT/JpuWZaPbUMZlqsK10EwkKG6NbYOUOll5keDBPPtvQ9Bc+gJhg/P9W1rqKmVRrP6eI7bkBGqFLwtqWpNmjCC59B7phuL5hNiFk9Ha+cHITo+JKJkGWO5cF6R0hyFWuFVfYRi2tMuhq1NImYRUyuc/0cY/uNU3WLbAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on brauner-vfs/vfs.all kdave/for-next linus/master v7.0-rc5 next-20260327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-remove-READ_ONLY_THP_FOR_FS-Kconfig-option/20260327-142622
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260327014255.2058916-8-ziy%40nvidia.com
patch subject: [PATCH v1 07/10] mm/truncate: use folio_split() in truncate_inode_partial_folio()
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260328/202603281736.bi9GWnsF-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603281736.bi9GWnsF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603281736.bi9GWnsF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/x86/kernel/asm-offsets.c:14:
   In file included from include/linux/suspend.h:5:
   In file included from include/linux/swap.h:9:
   In file included from include/linux/memcontrol.h:21:
   In file included from include/linux/mm.h:1746:
>> include/linux/huge_mm.h:625:1: error: expected identifier or '('
     625 | {
         | ^
   1 error generated.
   make[3]: *** [scripts/Makefile.build:184: arch/x86/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1337: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +625 include/linux/huge_mm.h

e220917fa50774f Luis Chamberlain 2024-08-22  622  
9ee18d22957981f Zi Yan           2026-03-26  623  static inline int folio_split(struct folio *folio, unsigned int new_order,
9ee18d22957981f Zi Yan           2026-03-26  624  		struct page *page, struct list_head *list);
7460b470a131f98 Zi Yan           2025-03-07 @625  {
a488ba3124c82d7 Pankaj Raghav    2025-09-05  626  	VM_WARN_ON_ONCE_FOLIO(1, folio);
a488ba3124c82d7 Pankaj Raghav    2025-09-05  627  	return -EINVAL;
7460b470a131f98 Zi Yan           2025-03-07  628  }
7460b470a131f98 Zi Yan           2025-03-07  629  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

