Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C6AC79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 12:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA776B0088; Sat, 12 Sep 2026 08:41:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B3A6B008C; Sat, 12 Sep 2026 08:41:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A3E76B0092; Sat, 12 Sep 2026 08:41:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E59A6B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:41:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6934A4FA4
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:41:02 +0000 (UTC)
X-FDA: 85205069964.12.B5E6BF2
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5B54180002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 12:41:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HeNlkQ8i;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789216861;
	b=g0Ayk5LeP346R4I1GetNJriBH1008NAEk8deSV8B2n5JtM8WD+DS7X2IdEV+T1RfE3ZjZe
	g5q2N4v4dn2pN2pjp6ir4Nwp+NlBshKQwtE9Dua2FnUak0OXJyF1BeF3eY0bXWecj7oK8u
	R1qicVXN5cIKc2GG/W43/vDfQQJRRx0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HeNlkQ8i;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789216861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=l74gyqrz8/MJowHDFchxtMfucDTuhbXucq/OWQtwKrc=;
	b=QIQPnJlFNIbnjbkro5oRySQb4xPKiMohPvkqrC5+0se+Pu9/LWng3YK3UCeWZo6PigpdEc
	ywn7hHslaHvkzeJoF+ioXYh8QEm75BErl3k2AVhMLGxLVxE1I2qOUiV2L4Gx53KAH/3bzg
	pP1Yw4ZOQC4/sZShUC3MRvYjiNAs2wo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789216860; x=1820752860;
  h=date:from:to:cc:subject:message-id;
  bh=7lectQIPGXCgCOBPrkZyTB4t+CqQCOILs57H2YCieVM=;
  b=HeNlkQ8igSANx48pFTWeUtx78WmIipk3M8Rq1ZpcgWFwfq3196gFXY24
   tJiz9wQTHW9ayjjX7+NlYbivf45D0PPbW+Iyj3tIRPhG8sLUZL+leBBsy
   p2/bKAuk6H2iK06tOsFYXHiOXEUCGa0VZYcWG87bGTAbrwt9pAGdF5w5l
   qc6LVJAKWiapY0FSUTbY+lVPwCOWbF9ZliG90lafjfSpA0KNVJ0Xe/NbY
   24Wuz/JMSzXxHJIdcCmSXhe4J1KvnVRuxbK50+Rs4zrsYZJcbDW/meicR
   iuIS8E2gLqLbXbAlfBPHlG1OqWB3BFmOVGQhet8m9CqfL7qW9ULYCY+KD
   A==;
X-CSE-ConnectionGUID: tA3YkhCDQkG2hELIBSzK0A==
X-CSE-MsgGUID: W7JFYvleRKaeBkwT68sx/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11902"; a="107167702"
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="107167702"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 05:40:58 -0700
X-CSE-ConnectionGUID: R+f6GkJhSQyCkNeJ8fuaOQ==
X-CSE-MsgGUID: fTuW5ZLiQf2bOazhZPgjdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="268485128"
Received: from igk-lkp-server01.igk.intel.com (HELO 2232cf45ba3c) ([10.211.93.152])
  by fmviesa010.fm.intel.com with ESMTP; 12 Sep 2026 05:40:56 -0700
Received: from kbuild by 2232cf45ba3c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x5N2M-0000000016B-0vdA;
	Sat, 12 Sep 2026 12:40:54 +0000
Date: Sat, 12 Sep 2026 14:39:55 +0200
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org,
 "Liam R. Howlett (Oracle)" <liam@infradead.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [akpm-mm:mm-new 439/459] fs/proc/task_mmu.c:205:13: warning:
 'reacquire_rcu' defined but not used
Message-ID: <202609121422.hkKWuy7K-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B54180002
X-Stat-Signature: wf8o55m6oi7go17uotudjxqpyh5oc6y5
X-HE-Tag: 1789216860-447104
X-HE-Meta: U2FsdGVkX18bj4W3rQUqSFszBmmE+Fzvc35X7W36CVGQkYzAl09mHMOz/1pcaoRkejJkLj1Eml/o5EpUGUA9imcY88PicHJKPazPJVvGZBF4zdor9OLmAecPgM709WQh69HKJxl8nY1ukRzlOkmtutz997RhIcUU1OCsFGQiF1m9Y6Lqe8uyd+MmDhfXuGRYrpRl3y27nHRYYjbkxQG1EgS1ak33Qt3toFoXqjtF3S/k54pcqXMCOSTp+aykms2tIMxGv/GkUGWuCtbAQztRHshATK5FLWJi114pIsTbqh2jkVuzxeFSBsam68M/0f5P32QdzKDOebxR6ej0V7HfPfGXH9RyvT/WzJHS2bZ2NmVp3BIcSsLC0tSjI7toWFIyRDI+UQ48CsB5xxlxyqMf0yqwqNwLudyKKeTvGYbIGBX1hePDVYw2zK9sU6zvTbx71zqw+37B8in+oXbqf4LjFDA/hy+Ko94WwVnmgP/e7Qo2IexJJqdQ+Jha1Ai6lBoWMX8rwqH9LH+eZm5TXncYsRv9Bd/9MDV/yoXSTlDEP8GcpSfGUSN7Cp1BcDBHjb0DKOrB1AxWk0feqwJ6wDHun3tHiS6paxUyDK63XEaDYFaR/LVMKW1JdkxPipFHyaOuYsapuUKPZ9j8B7h/6s/7mJPVrMAO/t3s/Z/EJXnSAzA/ydYr720fxW/2uzanN/Jtz2xqn9Q0l36t7w+hHqlc0vkoEsJPNw5YJGBCSP2HjO2CrnJ5jpmX6mUQFa9l8zqKQmNQNYG0qtjTgmSi2nG4bI6WtS1usTR6+c8UPAWCPUYad/GeRxhRHAUg7psQ3VssmiZ0UltMIFnoMFVF8Aza9QSxgS3t+RmFSlJ8ujV0oNlWtfoB9T8STjvKiqPorXfQ5ui8BLxx+kr1jWe9Wc9CNYDB+DI7UA3ofw6y0DAjTI0EBO9qF9dwQwfOQ+yVZ1KnWYhwQZCVGCsp7rfl1wd
 9Ru5E+C7
 c++3pg418tGTJOrGkWobwh1WtiBUKqd4FOOcQulhyFxUiWO4mBxozbqrGyGgcFcoJTCIXvObqNUx9lTrdLdcSQMziIGVHoWY6MM03PZ9owHafG5GQdyBtpgK1zOHKuUGbPnCQo0FNTL0GQlqwPPOHK37AWp+/5xSIc++nWvElCUZ6Kf+ZmWz0JUEDle4F0K5YY/4d+qAsy8I1WzlAB00VHfJB/9K008DTu7o0hID1eo6YyJH/tBdZeyyOBs1XMVtWLqqIZQNZsZo6t5A/ebt1ktmUdEtUHoCLLdvt5NrKpA8gQmdikY1Nixk98f03DBMyRR0znmsHgxgYMHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   383fc05d4650b021f3c17e36a145106dcc61a294
commit: 2a61a4b80dc01581dc9f6935eedefbd596e77409 [439/459] proc/task_mmu: remove unnecessary inlines in function definitions
config: openrisc-randconfig-r053-20260912 (https://download.01.org/0day-ci/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260912/202609121422.hkKWuy7K-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/proc/task_mmu.c:205:13: warning: 'reacquire_rcu' defined but not used [-Wunused-function]
     205 | static void reacquire_rcu(struct proc_maps_private *priv)
         |             ^~~~~~~~~~~~~
>> fs/proc/task_mmu.c:197:13: warning: 'drop_rcu' defined but not used [-Wunused-function]
     197 | static void drop_rcu(struct proc_maps_private *priv)
         |             ^~~~~~~~
   fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
     133 | static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
         |            ^~~~~~~~~~~


vim +/reacquire_rcu +205 fs/proc/task_mmu.c

   196	
 > 197	static void drop_rcu(struct proc_maps_private *priv)
   198	{
   199		if (priv->lock_ctx.mmap_locked)
   200			return;
   201	
   202		rcu_read_unlock();
   203	}
   204	
 > 205	static void reacquire_rcu(struct proc_maps_private *priv)
   206	{
   207		if (priv->lock_ctx.mmap_locked)
   208			return;
   209	
   210		rcu_read_lock();
   211		/* Reinitialize the iterator. */
   212		vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
   213	}
   214	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

