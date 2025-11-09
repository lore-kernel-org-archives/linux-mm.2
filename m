Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C21CCFA13
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 13:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA618E0013; Sun,  9 Nov 2025 08:38:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A558E0002; Sun,  9 Nov 2025 08:38:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89CE8E0013; Sun,  9 Nov 2025 08:38:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2F6D8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 08:38:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D7CE12D05A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:38:57 +0000 (UTC)
X-FDA: 84091174314.25.467BA00
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66EC8C0006
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:38:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="WwwPCu/8";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762695535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cr2114I01ec/abmyNG7RpEXZ1LzjDm/1lTsSiym6iAk=;
	b=AVu13HKd3zO9WAk+DtHrj5JmqkrriRKjYPGgTqfgH/NJ07L4v5P42PNb7JdyLLr8O44COV
	qCa2CCKLugN+aKe5k61C9lVBHhjIUG7uaaO64q9tFCPfVB+qktSOW7NFYVudQaM0H4s3fl
	BiHbKGbGaTDJdmykwk22e+IxToULNF8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="WwwPCu/8";
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762695535; a=rsa-sha256;
	cv=none;
	b=o/mzfERCND1EXkQLSp1lexAVCdeAXoCyljm3N+PU6XxOLZXeS5jminOQJyotpe3o9NbFHj
	5YmlXx31iNkAYJf4yEnnafQlLkYuuIQdo66Z+BH456Mz4AQUFffnh44qZFf+kL9jVEckBm
	qgN7nW5SloQ75WmV+q5xtWv0QLpbOIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762695534; x=1794231534;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1x+Mo9nWh2WXI6lONcFe9DSrRcVoSKddorvdA0ovrps=;
  b=WwwPCu/83nIJiBPfq1dM7gy3mowBM2btFEiW5PA98rkNZfx1cLEFYIHx
   uDLvs4rBHkZZKPo5+ay7c3vfpNGSY+e5Lx+lLsUTy9JowmAlL766G61Mw
   wNJglQ/aHdqUJotbe2YMB58/yeGlnQXK3fJZwSMgp9hu6vc4b7hrbnosw
   5qQbpVxmEYseaXU4NuZYUWKouBkBrzhr9NQQXyWQO3rr71hGIefTSLa1H
   XMQLwZQKjI2haJrwgaDkX2KjCiaGKASW309BY6gUsSBTT1L9Qfj5FiVdi
   qdpXonbB5sCyuXaAY3eiaiR881Nz7gnuAKxmG/EObQat7Ph5/eYJJ2xX/
   g==;
X-CSE-ConnectionGUID: Js0CSgSqRyaz4/KDcUyO3g==
X-CSE-MsgGUID: ePCNeSgIRACurU5fXS2V8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11607"; a="64651518"
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="64651518"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2025 05:38:52 -0800
X-CSE-ConnectionGUID: ifjZIU4pSdODEVFMem63lw==
X-CSE-MsgGUID: JRKtoAiyTRuSZxiMKKrPuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,291,1754982000"; 
   d="scan'208";a="192570350"
Received: from lkp-server01.sh.intel.com (HELO 6ef82f2de774) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 09 Nov 2025 05:38:49 -0800
Received: from kbuild by 6ef82f2de774 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vI5d0-00022F-1d;
	Sun, 09 Nov 2025 13:38:46 +0000
Date: Sun, 9 Nov 2025 21:38:19 +0800
From: kernel test robot <lkp@intel.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Sourabh Jain <sourabhjain@linux.ibm.com>,
	Aditya Gupta <adityag@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Baoquan he <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
	Hari Bathini <hbathini@linux.ibm.com>, Jiri Bohac <jbohac@suse.cz>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shivang Upadhyay <shivangu@linux.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>, linuxppc-dev@lists.ozlabs.org,
	kexec@lists.infradead.org
Subject: Re: [PATCH v2 2/5] kexec: move sysfs entries to /sys/kernel/kexec
Message-ID: <202511092102.Qi35GqrR-lkp@intel.com>
References: <20251106045107.17813-3-sourabhjain@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106045107.17813-3-sourabhjain@linux.ibm.com>
X-Rspamd-Queue-Id: 66EC8C0006
X-Stat-Signature: ogd8po6s9qygi1fumswrhnqkrdd1bdf4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762695534-365047
X-HE-Meta: U2FsdGVkX1/w2K2U1g4WB/H3+ga53841N/FY7J5tXtzddat1NvCCUDseFlGP69IymERsH316HcWneu8YsRRFGQt3PwnU7MOLqqp/Sj5boeIaJ081AouzUViVv0T79BAWCOEJVMVQ5ajJG2NLIfl1bJfcrsuIdwcrbugkFC9+Pqnw0QviWMp/1YQ48i3UGG6WegchSEM7e8enCNBXekJ1AQIcMkfcLMr86orNG39yHkKZh8bjUS+dKkeTvybc2bW8CIn4bWxeATT2FCXJAQ2Q0ggpoYihiTfWeyg0kPMTPlzg8cebtlc7w1gMod7WnBN8eJ4pmQ86XzR1CVmIJdQHRG82BjCK9Qlmb3+CUsLHZp/eyD1XcvIyIx1fAsw73DN1aKI3X8dJf7MJOuomvnLl5cPKEAXf/N4CAvZI6Ykb7syxucy8po8SKnW1SF+yd+xtm91GldPrhrca8dWxh/Bl3n3G9g7UGiOd/4tGzUKHusjnwLIqJNi8BojZjn6XWhO3c5yPSKiE98Mp+5hoq7ag59ULVob+l5H4XajRdX7Gx40FUjk7l6wTr0nVvNY91M9pLNHreTmxtJBEVB5VZP97Nij4eExCrPrnaEZit2l+/o1OFeMZX9uezWzYunFbsas6jEzHN6jDi5ssi806YezHNhVV2cLHFweFNkrutVilp2cnL1MAAV8P6n+ErvkpyuhcMI4yZ0zc8fKG5YAnQmCiIEStnNs+1vsCb133cl55gWgEuZ50BhTqH/2esSYW0vVJqgP6vUXb9MjSwu7e/QJB1QTPgp/tvk9x/+KPtFCOxgWfgdbalt1auVDSx4za7qvblekpa1QUnpKOzSB2tJi575DCWjPUjTKzPELaQhGK4P1NbzMqPFZfzUr5r6CfJ8Qc6rer8qRs42N2X8aZR3A+NyBHUwkce2OC03NSttDmUc8Y8QXOnxsdc12KgTxPcM91mIyxGSjIiHwrpQEVpR1
 2wTggrkg
 aahfNxb2gxju3assgnFl1pveFtOrdj7DHvQLW3WdEL5xGp6ZyfQB2mHaDgglpOamMY36hSlKla2D8K927Wt0e3epc6wOe1R2XvCQ/LQqZRB4x/2JqpYzPoFLtdAU8XhmfXkP48NzDbA+eQKThvLc9l77qNGw15aFcyW3gByoLoKC8fqhtA8Chod5kQfyqGTHSBipyuhJNgQsHQJgWUOr5AyKJ2Op2m6ywgGE+RuezOrI8tZrK4K55q9g5jtMjJgnxrGJzzoTkbMXCnyLS10wNE0UA7NGkf4bKVxuB/0E0366kOghrV+uKgVRHWtLeNW3Gmj972FvPwiYJngPiB8XbFelquv0Op2CTrD9YeKzipSqbE26kOtQ1IFVx0lyFoefwPVcE59mRosduZC0bTzFl0qs52sdKoZH+Ae7T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sourabh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on linus/master v6.18-rc4 next-20251107]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sourabh-Jain/Documentation-ABI-add-kexec-and-kdump-sysfs-interface/20251106-125243
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251106045107.17813-3-sourabhjain%40linux.ibm.com
patch subject: [PATCH v2 2/5] kexec: move sysfs entries to /sys/kernel/kexec
config: s390-randconfig-r131-20251109 (https://download.01.org/0day-ci/archive/20251109/202511092102.Qi35GqrR-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251109/202511092102.Qi35GqrR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511092102.Qi35GqrR-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> kernel/kexec_core.c:1315:16: sparse: sparse: symbol 'kexec_kobj' was not declared. Should it be static?

vim +/kexec_kobj +1315 kernel/kexec_core.c

  1314	
> 1315	struct kobject *kexec_kobj;
  1316	ATTRIBUTE_GROUPS(kexec);
  1317	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

