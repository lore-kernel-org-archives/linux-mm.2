Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60338606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 05:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=UhGqxwCm
Received: by kanga.kvack.org (Postfix)
	id 57A706B05C8; Tue, 27 Oct 2026 01:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BFE6B05C9; Tue, 27 Oct 2026 01:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441586B05CA; Tue, 27 Oct 2026 01:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFE16B05C8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 01:04:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9DD7F120676
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:04:29 +0000 (UTC)
X-FDA: 85367215458.17.115602C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id CE121180006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:04:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UhGqxwCm;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793077467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ai6yw3OuibhURm/WO66vXn3DXBjDe0k2rnzBv97yR0A=;
	b=KVT05MqPPWMXSI+1tzWF6QzWe+WgtJfsfmJPopChm0kQVGrMhqvZ8V4z8IOziqK6/nvaSE
	CjyndJFwBjQCcHCDcXPpFCW/CZG9OgZMbq4PfxdRMJZaXaJyypKRBCvL4jGv148xomMUxv
	yzCqkUPjvn0eHqQ+kaL51aOVWPq7u9E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UhGqxwCm;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793077467;
	b=o1Z0kRsVRI+PMD/uI/3o69Sl35H+12I+D0qnKe+0OwIh7ZQ45KZHrygt6U//uzHaf2GOL1
	xrKs4hfM7d1yTzbmalEJvFmWyNuJkmLqtUiqfNQshgMtNwpzu/gniKiqhosaVKGP48jf7A
	zJmm0jM3vAOM2reamRBB+6h/kLB5F9w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793077467; x=1824613467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HAhrArfOGx4d2m+iNXRk5VLLSvyuYaHbyyD0xEP12kY=;
  b=UhGqxwCmc3z1LpSG4EUSUyCFCEx9cbQwPK5uuGJGiEfQeXIHqQO8pt14
   5A71N9XiErTpRAtNv+xgexTQStlc9JGaVMItg7mFZydcfysf/T22kheFR
   6AzRmn0bvpt3vAC2SYGiL1FgL3hOd4lsIOyCstEFjfeTuLNbNG/P3UWuF
   9EuETMtlmhHk03qCY9cH+4tUNuSEtvcqAVps1CUTpqVJzcliFz6QI/TGM
   p6gTG9HSX0o6v+hrd+PhNoFtL5XrwXNCRBip3dFUtahraCP4HKxM55jI2
   Uze4rJi8dyONO24zvrm1yIbI3MtkZBqe8m7iEZfOcVTJPjoRQHImzQN4t
   g==;
X-CSE-ConnectionGUID: C86AulT6QECtlt7DyiRsag==
X-CSE-MsgGUID: BksNzED8R4efTC5dw08aRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11947"; a="1800148"
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="1800148"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2026 22:04:26 -0700
X-CSE-ConnectionGUID: GCpDDQhAQtuGSgdOwwRe2g==
X-CSE-MsgGUID: mzaicXv/SACWC/OGO9hrOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,180,1787036400"; 
   d="scan'208";a="4843596"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 26 Oct 2026 22:04:20 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xLZM8-00000000WrA-3Kg9;
	Tue, 27 Oct 2026 05:04:16 +0000
Date: Tue, 27 Oct 2026 13:04:14 +0800
From: kernel test robot <lkp@intel.com>
To: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs
 mount chosen by userspace
Message-ID: <202610271253.yDB2IOkw-lkp@intel.com>
References: <20261022225035.377445-8-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022225035.377445-8-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CE121180006
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 34z4gcyix31i6rkpybnm7bcqppgh1m4i
X-HE-Tag: 1793077466-595661
X-HE-Meta: U2FsdGVkX18jDvJJzp3QJK7K1Pb9pamCTcqTLbGTYuz3IgX3AC6vl2CVd9i1xkdqCcj5NqB8n8kQs0BU81zER8VkeVL/T/frsmcIfvJDuxX5OLCf+Io1JLq0P+8kWWs+TCV7tBVaxW68ztPplO8+kiobCIqDylhDeihrRdW5qU9nXI68pxjS+XcuqiotCUHiVUujKALemXdbYkSZMwjBQ4UsbwbYolkgUO7FIpujbiCfRDDr9wEnpo04DNV7M0VvZTZ8GIM2WhThWR8qyJf6kzyX5mQV51q/YDWv+AkepL3qxZRUN8ammKG5IEzsKSWlYMXnYPcnZiDwSfuU7x3xc9LG557YfcC6IwbZZZCO2ACN2TVcMUp7jkNAq7xtoIyWWukp4VfVNgsVkYX+NP0KNueIONHWnIWS6xBOjqot4FKqvVyzUuJR2bk6/y1yDPvl6Q6S28gFafbtTMu2wUbA/iZ4fwYXT02+pWNJyX4nBwrdAuGNQ5Cpc9HXvFioBVIIFr0CY8Qx0ybgbZQ8MK/lITtB/bTNQOy6xjkAX+lkYB1Yr5B5soEh+3yoftZRfmUJJh1IHzAvhPtAclcu8W71wUTmvtV4CDGJ9mDUVVNypPwSB/wA+P1K7ArWPJZq08AmbMg52v1bn4LI2mf4pR1FOHyTm4cDnmPX2FppHhy42aU8X6Fu+FCSzALCuvwueCzMDN8k5mLxwbs0LAbrme3JXE4nZwQWcZfTrP2vWpgLr4bxMd6sEc8Gq5pzifFxgMm7+cFFr/cAN46s1S5R2K74A177gaHDJ9pey2p41YnR+8POflol831OodK50SP/6/i4uURwAs3ePqLBd6H15gnKMLF4hERz5Wtr+KWkzjuxfxrofuDEN8/JVvCp03kCY3SWQ3MIz0w/IlEsl6uV3iD+vamRhc1pI5sZI7aeagS9mPXAsepQTscOhLYF8fI9O86MEbgY8ZlJ8hZJVBxxOVt
 y7zH859L
 HQEAg1VwVuVNfPe58MjjYAGXRXkjN1uEzyit059Bw2yRzaK7weshnsgvvNriixFlduOp0KVz9oAfD7voPaBVYeh7xbTBsDARsJxz1nAYo/bCsLD2J4lNE/xyJw4ehERwBVo7A6jSRS+vVp/+884SAdYNbIktlTtFrKG4XIjZA5pkN6C2W6U8frhl2LdL3sqUtucrIZnyACNtl/R7/mm0LXFTH3eKHPrF6r/cz09nmH/Ppi6jBSUrKrc5YGeqKOb6yjGufpvuSYQhNE/rCqVUqMFv16ajFZE9qfOIt6jwAl4qGa2skmzTolEs4eOWRsRDYQCC5nY8NP9BX9+NCRiJdDQ3ePMxBwNBab+PyudTYY88xfy9+x1OJBb+Fu6D5EhgaNS4rbvuCtw928Rj/vw1yOSTe4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 80cf37169daef112b6bea9ae7d9808355a045475]

url:    https://github.com/intel-lab-lkp/linux/commits/David-Matlack/liveupdate-Pass-user-argument-to-file-preserve-and-retrieve/20261022-225026
base:   80cf37169daef112b6bea9ae7d9808355a045475
patch link:    https://lore.kernel.org/r/20261022225035.377445-8-dmatlack%40google.com
patch subject: [PATCH v2 07/10] mm/shmem_luo: Retrieve tmpfs files onto a tmpfs mount chosen by userspace
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20261027/202610271253.yDB2IOkw-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261027/202610271253.yDB2IOkw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610271253.yDB2IOkw-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/shmem.c:5867:6: warning: no previous prototype for function 'shmem_inode_on_internal_mount' [-Wmissing-prototypes]
    5867 | bool shmem_inode_on_internal_mount(const struct inode *inode)
         |      ^
   mm/shmem.c:5867:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
    5867 | bool shmem_inode_on_internal_mount(const struct inode *inode)
         | ^
         | static 
   1 warning generated.


vim +/shmem_inode_on_internal_mount +5867 mm/shmem.c

  5862	
  5863	/*
  5864	 * Whether @inode is on the internal shmem mount, which is used by
  5865	 * shmem_file_setup() and thus by memfd_create().
  5866	 */
> 5867	bool shmem_inode_on_internal_mount(const struct inode *inode)
  5868	{
  5869		return inode->i_sb == shm_mnt->mnt_sb;
  5870	}
  5871	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

