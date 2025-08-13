Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2486BC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B136B900076; Wed, 13 Aug 2025 09:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D60900044; Wed, 13 Aug 2025 09:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2C3900076; Wed, 13 Aug 2025 09:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8457D900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:39:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4930682ACC
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:14 +0000 (UTC)
X-FDA: 83771840628.02.B56D51E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1357C0008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XVumdE7z;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u6x3JsIhx0Qrae5V9qZe8mSeS1eQz4BcSBsyhSmJ+qg=;
	b=wRUCIujzQI4M6XwmOEQm5qFmlqKgIslQ7WPcJlubMLfYASgrTB7AT4Xs6m0aSca/1sF2gr
	vxL7oJ4ZDKAAZjvseZ2t1szGJKSEFyQnimQdLWQFkChXoapbqheslslXG9/0Y19fC93orZ
	V0CRBbQLzXXT0WeVunQkvkL0xxfyZOk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=XVumdE7z;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092352; a=rsa-sha256;
	cv=none;
	b=0vIK4h7IOWhsvILv5g18vrOmK1EbW701x9QeAjFiYqjYSxG+j5hwjBtt3ttAsCeQw34m9X
	MjfUIepo7/WmXDSu9fPNv77npzOn5POEG7I9SMH28odTZaMJfzkdcXXMtR2GK6V4jvPLVy
	qB6rWgPHMJwGPbFRtMK0/nc8WKH9Zlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755092352; x=1786628352;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ey8eSMdRLAlmFC09vuKwkFOnHkFG0NstFyZA4ySXPNo=;
  b=XVumdE7zOjB0sdSCDJuRdfJr/ieIutOvcMtLPGBod9IloTU4avE4wMi1
   qorQBRoBxxmP9yo6O+RT0qJ/+TuDL1hjZdCL4cOvn/xE/HwwEuu7xIjz2
   gJMY6s3u5E3zVt6SPp8Kpn1Wm2rx3be3cbUwTdmDG+JsAWAlgzKXFryu0
   uAiJo5nOWav/b2/jg70pNw6jywhzvXV0bDH+XCzSznmhQ+zuXxN4H16MX
   qTvK8LwnsuBEgDvxcu7SHPMBtOKz6do9XClNGbD/sx21kIqbsNFyXZ1Ln
   mcDgEj8Ap3kHQ9r2BIh4xoXg5GEDA0S4qTL7b/CYAiAPeyL6HD+Pyn4x8
   A==;
X-CSE-ConnectionGUID: 48FBXiz+SnW1vsS82bg3gw==
X-CSE-MsgGUID: BoVVaW/tTLGBTmjWi8Pqrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="67659876"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="67659876"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 06:39:10 -0700
X-CSE-ConnectionGUID: 6KWxgs+yQ02+qcBirhtOmg==
X-CSE-MsgGUID: w3KQMHZORJOS1da0gFH+uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="165660598"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 13 Aug 2025 06:39:09 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1umBgK-0009wo-1d;
	Wed, 13 Aug 2025 13:38:31 +0000
Date: Wed, 13 Aug 2025 21:34:15 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [akpm-mm:mm-new 123/137] arch/s390/mm/mmap.c:188:3: error: call to
 undeclared function 'mm_flag_set'; ISO C99 and later do not support implicit
 function declarations
Message-ID: <202508132154.feFNDPyq-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A1357C0008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: okwe3pwwtm7gs7n9ayfunjq7bi3y6qrz
X-HE-Tag: 1755092351-448754
X-HE-Meta: U2FsdGVkX1/eJV0Yf9IIU88V+MdoUu45dyn1U/zOsYyxwvzZzX+/0bH3sfQo/cJ6cXfPcBnrNu5yfUBbsapT6IFdjc+SRFQhJjJWUUbryNMCZJmUfJk5wuLPgeglWazb+G68lCxrPQhViaEyxL0EOM763dnehT4fBatZ3BfESRFZKCk9m5zIR/GYC+rWAM5k5luxkWLClHw7p+ZdXb6QSyg2hgHKlyh5CNg7G5EIKUkFsUgWNUN4L5Al/EDAKhiJYI7Ziq28phuQf6STH0sLLhosOa/lRnx2PLKfvsChP3gAgOC/Az5CiRfw3+x0Wx9H+4YDZwWnVRYQv5aERJj8jC0YUFgOGiZDKurANAxMZtMapupp/k42+AtoAGXbqXUi+ylem6UyjHNkJAfXKD5WVVrn85Sp0Q926P/XfUPkHbcpsQTL1gNPH1Bw0pFeMCoFOL17BHtX9ExL9bvDjPQD5WksxP5mprvBdppWj/2VclpCn2F8IUlTFNI+mTIiZHyhMdBWFlWj33QVWcYDvDzdkgZFbJrqEghpWuCpnWZ5DPMWaw3iro6mnyopHHeoXL4PP8pdksDG31dDUIyQvXHlFZ1tbadZ345P1xKylXIAGtlx6d6mD14fsIiWyEt8G9ruBMH6QXYgAJzNIyLgzrJl+KZJRD+IUZwJXb6pB+Du9Ph/7tI2MImyZAXZ1h3OA0/uGnlbh+mIPkEILK06wY3WBQVn1yoXDNLlLgGy3xI4NjugSZUtRp7Srq7hpOMk1IKbmIY3l370x8g28ey6dKvqGejr6fBhqGEkGbYMAK+TZ7MoaMpt/AWN8+0IG5mToWdp6e7ZMdVkiDr+21/QJmmnKQshZaLVCosW1WWz2YX2ehdCXQfBCRFD4EvcB/oI+P9rBBSjUS8m38OQo9BROLr6ZqF3HL1Z0ztXfcW9d3lEwCqnx/31za9B4mAnf7ydnzX1sG5L+FTA7/p1fB6ifIh
 2pLU023P
 ieP8xUcibx06swvksYOFoa92uNfbp6S5qTBmxjpUaQARViSuD88rngsoItaaB0BmVdv8O3suWKOU+v8lZI9b+7ulKZ263dk4Z5i9dZvM7El5pCgr3X8UVWTfzWR5YsGJz0FrMq7skJuk58JFQ7oSt+5QnzYkMAWU6zWilrVcryzmtHJedK9eGR18v1j6FUUxoCMakRNWjSLniTIfZzI4RAUU5ku2P8atIuG73gPYAPbd3PfZQsRNmcgkTEyf5e9vJAvH5nwthajtM0b5MHN7FNulcqxVNChuKRzfPJLSSwHsfKvGS9nTg7lUA/IaWiq3hqMVbKN/ZglIHOEp64w5BxUPpF7sWKQP/nwbZ6gbcCi5ZSr83A4AjulImUYaaDK2a7XmgYcq8aoYRzhma6odaLrLkQW5oZPfW4u8LeqnHHO7Z7gTF5on9Wvv3dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   694c8e78f486b09137ee3efadae044d01aba971b
commit: 70fd92efa9e96967353bb39665bac8f5276aaaae [123/137] mm: convert arch-specific code to mm_flags_*() accessors
config: s390-allnoconfig (https://download.01.org/0day-ci/archive/20250813/202508132154.feFNDPyq-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 3769ce013be2879bf0b329c14a16f5cb766f26ce)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250813/202508132154.feFNDPyq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508132154.feFNDPyq-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/s390/mm/mmap.c:188:3: error: call to undeclared function 'mm_flag_set'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     188 |                 mm_flag_set(MMF_TOPDOWN, mm);
         |                 ^
   arch/s390/mm/mmap.c:188:3: note: did you mean 'mm_flags_set'?
   include/linux/mm.h:740:20: note: 'mm_flags_set' declared here
     740 | static inline void mm_flags_set(int flag, struct mm_struct *mm)
         |                    ^
   1 error generated.


vim +/mm_flag_set +188 arch/s390/mm/mmap.c

   167	
   168	/*
   169	 * This function, called very early during the creation of a new
   170	 * process VM image, sets up which VM layout function to use:
   171	 */
   172	void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
   173	{
   174		unsigned long random_factor = 0UL;
   175	
   176		if (current->flags & PF_RANDOMIZE)
   177			random_factor = arch_mmap_rnd();
   178	
   179		/*
   180		 * Fall back to the standard layout if the personality
   181		 * bit is set, or if the expected stack growth is unlimited:
   182		 */
   183		if (mmap_is_legacy(rlim_stack)) {
   184			mm->mmap_base = mmap_base_legacy(random_factor);
   185			mm_flags_clear(MMF_TOPDOWN, mm);
   186		} else {
   187			mm->mmap_base = mmap_base(random_factor, rlim_stack);
 > 188			mm_flag_set(MMF_TOPDOWN, mm);
   189		}
   190	}
   191	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

