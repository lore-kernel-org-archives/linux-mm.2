Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4777BC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA8E6B008A; Fri,  1 Aug 2025 08:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB25D6B008C; Fri,  1 Aug 2025 08:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEB86B0092; Fri,  1 Aug 2025 08:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF2DE6B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:56:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47B3114080C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:56:17 +0000 (UTC)
X-FDA: 83728186794.11.6378D3A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77417C000D
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:56:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHE97O80;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754052975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+DsoEtNA0IUK+GsNgyKyYxAv9c9X/6gEWV0IhG0ZcA=;
	b=nQVGb/sVsN3kgQdtR6hI1AhOJEcEiIbilwxBCPx8QozGueP/CKZQ5pY9L+mk/lAdxodSXt
	j9koPgO264oB0+Dyw6dlpHBO/60b1IakubgStmasoYAW5cTGcWTIcCcu5LgN582cN5UrJ1
	VguvypAb6Yrzybzjtd1t+ZxVb03FB5I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SHE97O80;
	spf=pass (imf10.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754052975; a=rsa-sha256;
	cv=none;
	b=NjqpwFjbFJ+xe77gpMZ/y9IrxM223ioUM3Yl7FPJpyPV2cgfVM9t3BBDQoN+YDVKshs6la
	uuqhpAZdeWb2PgHKURjKfX6DavqJLe42Igt+FFTje6DRwD+Vb6FDOPVZ8N51g4jebX6VRz
	PgFasUWZn0dJBUrVVCbUjPathjU9nmc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754052974; x=1785588974;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rtzfcvwkul30C1tQ3bVX6Wtto5iApIgC11igXrCtIyY=;
  b=SHE97O80f0KOsTklh14ECZD0S8NxW2WzWVhnPfMfX6bmBSvnehURjw+D
   GcghGjdNOgUNeqpMz05L6X7S5EBdz7PaMKjFiX0b+6EgnmcBBOXdeYQHM
   aoO4//iI6fIV0xQNIKsMrXlc2YIAKY52WLqd6dyLCscVsAmc65fqcec1C
   Vtp9oAKp0Ip1V7byepRbOPvr/TKDuRCmWYc/QGr1+NhhFaJHn56HYIaas
   NLjj/a30lUfMBWZ4K2IDFb3eldUIhZbD+ptUhdMsgEveToQbjNcYbnzaj
   kAUvmPmCVi7vsjubAyp3Wem/G94oSE7jo1BZb9Z2105CuVivVz4kCyPnB
   w==;
X-CSE-ConnectionGUID: QEK2DHblSlmLKQswBjJ/NA==
X-CSE-MsgGUID: J7AWLwXeQ7mTztlxYAGMoA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="56478311"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="56478311"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 05:56:13 -0700
X-CSE-ConnectionGUID: BGb912eYQgiEW6HwicwKVQ==
X-CSE-MsgGUID: WW8OaP5zRP2oOXCNEXCcJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167820732"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 01 Aug 2025 05:56:06 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhpIq-0004dA-0y;
	Fri, 01 Aug 2025 12:56:04 +0000
Date: Fri, 1 Aug 2025 20:56:00 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
	david@redhat.com, vbabka@suse.cz, peterx@redhat.com,
	jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
	paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com,
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com,
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de,
	andrii@kernel.org, ryan.roberts@arm.com,
	christophe.leroy@csgroup.eu, tjmercier@google.com,
	kaleshsingh@google.com, aha310510@gmail.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	surenb@google.com
Subject: Re: [PATCH 2/3] fs/proc/task_mmu: factor out proc_maps_private
 fields used by PROCMAP_QUERY
Message-ID: <202508012010.9IA7JflG-lkp@intel.com>
References: <20250731220024.702621-3-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731220024.702621-3-surenb@google.com>
X-Stat-Signature: rxfdqmbruxu6nso337i364crw1pzgxcw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 77417C000D
X-Rspam-User: 
X-HE-Tag: 1754052974-885833
X-HE-Meta: U2FsdGVkX1+UH1i1cwtjE44/Hv4C67WQCU5fTv8IiaYa6eBAQ6ejtoJU1qu/Xszxp6RAImAv4QVGwc4ke/2l2WwJDIgigFY+yOEpT2NM+d81DDE4CF3dt8mZGpk6pAQImt3l1/b3gL9ax0GH92GKsdmyiDu2yodPxIWFK++1/NgQpq1+UQauwqDDuv/ZqKiEyhRNC8nhVtINuIoJlO4gMXmMKWvtwCxNjXtKSz1cBeiRZiL5icO5TbQGHgwcKlb5yAlDarpP/eIbXyKE7E/3LUtf/374VbKk38EYGcpHMrpHkZyJ6rnBFDpavcnDsOA94Rs6gBv7dVXarRtrCoJqeoUjrmuQA79xOILysepwGxAaG4LEDqpnnT5rmsPsOqf+fyTGyFhPdb6ouS8qKHrFZ+X56ItCsmxK4f5n2rQh13lS8vLKgesBZ5lv2wW7oqSXJ2AVFS6p9KBQ1q2hk36vDid1655WZccXH4UfOEpDaJMSbHk1D4S37ON4qOVd+kXx4FHEKSSJOn9FfdcvmT9/92YBvHU4a6aOphvkh692a+JEO4Mh0aCwRPveHTUYK/NdEhvJ0i/0djzdqXmsEmSc91milExJK19XeeVv4/DIaBgZiIgdvIrEoqz6OL5Sq9AN1L6GREHwCthcueQbxpHTlfGevDkuCXfNkvY7aHcAhF9XN/bv+fAjmxgyA1k79QyuVOyWHSTVuEg8vAIp58fTHj5/TuntivSGLzdIsp5x5zyYbRx/q9pHUOVmRNGDSgqGPhuF7deX05aF0Nd9m1MPA6+rKbyI6kcPlGaBCIcBlsOtvOG4yrdc6+bfk/kUZtURPmMcmErvsq+rn0MzV7WK1e9rus0bpj6hCCaOzw9Dh1nPjdPnXKFO7XAG5n3qy7/5dzKkLPniir9+s9Vrr29bqaEuY2cvMTMNePlPrLBzDLygTsW0EJki9MkgPq5Ol9Ym80qTh+d4p1R0r/zOJJo
 xRevigcH
 2ePem9gAeKruU6SZ31QQJRBBM+aFhOBgkWpn8xzRqLIREl2h8vC1wxk+xbxLchbDzkAfCqsiIZ1nWt5PD4s3beIMARQ1AhjSOhssMThHJTS1/+lgZeaZuYxm5IQZ20gugIkWcWtb2lB439z4MGRBJvIfqsCaErwW/t8pYw/FUV/NnbimkVYK8zYIBr1BCGv1KU3iyXSSzn3H/jI/a51VMHElVE+2G5OO3e4poHSrd6CmoxK/DR27hjsOhe2ufdw0OJwg5m84aG9z58c9ed2J0JycpHslY3caW7Pn/5QVofxGm0GnBrEII95zuZ1AGW+jMOn8FWyFZwDMrR6VoCn98Pk1aZovMD0X6vZLRVJ4xbAqZfCXVl9WIZbum+oZhcZzMsGTmkgV7TXfK3rhv4XBpUObUjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren,

kernel test robot noticed the following build errors:

[auto build test ERROR on 01da54f10fddf3b01c5a3b80f6b16bbad390c302]

url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan/selftests-proc-test-PROCMAP_QUERY-ioctl-while-vma-is-concurrently-modified/20250801-060200
base:   01da54f10fddf3b01c5a3b80f6b16bbad390c302
patch link:    https://lore.kernel.org/r/20250731220024.702621-3-surenb%40google.com
patch subject: [PATCH 2/3] fs/proc/task_mmu: factor out proc_maps_private fields used by PROCMAP_QUERY
config: riscv-randconfig-002-20250801 (https://download.01.org/0day-ci/archive/20250801/202508012010.9IA7JflG-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250801/202508012010.9IA7JflG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508012010.9IA7JflG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/proc/task_nommu.c:207:13: error: no member named 'mm' in 'struct proc_maps_private'
     207 |         mm = priv->mm;
         |              ~~~~  ^
   fs/proc/task_nommu.c:229:31: error: no member named 'mm' in 'struct proc_maps_private'
     229 |         struct mm_struct *mm = priv->mm;
         |                                ~~~~  ^
   fs/proc/task_nommu.c:262:8: error: no member named 'mm' in 'struct proc_maps_private'
     262 |         priv->mm = proc_mem_open(inode, PTRACE_MODE_READ);
         |         ~~~~  ^
   fs/proc/task_nommu.c:263:27: error: no member named 'mm' in 'struct proc_maps_private'
     263 |         if (IS_ERR_OR_NULL(priv->mm)) {
         |                            ~~~~  ^
   fs/proc/task_nommu.c:264:19: error: no member named 'mm' in 'struct proc_maps_private'
     264 |                 int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
         |                           ~~~~  ^
   fs/proc/task_nommu.c:264:38: error: no member named 'mm' in 'struct proc_maps_private'
     264 |                 int err = priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
         |                                              ~~~~  ^
   fs/proc/task_nommu.c:279:12: error: no member named 'mm' in 'struct proc_maps_private'
     279 |         if (priv->mm)
         |             ~~~~  ^
   fs/proc/task_nommu.c:280:16: error: no member named 'mm' in 'struct proc_maps_private'
     280 |                 mmdrop(priv->mm);
         |                        ~~~~  ^
   8 errors generated.


vim +207 fs/proc/task_nommu.c

fe441980161751 Ben Wolsieffer          2023-09-15  191  
fe441980161751 Ben Wolsieffer          2023-09-15  192  static void *m_start(struct seq_file *m, loff_t *ppos)
^1da177e4c3f41 Linus Torvalds          2005-04-16  193  {
dbf8685c8e2140 David Howells           2006-09-27  194  	struct proc_maps_private *priv = m->private;
fe441980161751 Ben Wolsieffer          2023-09-15  195  	unsigned long last_addr = *ppos;
dbf8685c8e2140 David Howells           2006-09-27  196  	struct mm_struct *mm;
0c563f14804356 Matthew Wilcox (Oracle  2022-09-06  197) 
fe441980161751 Ben Wolsieffer          2023-09-15  198  	/* See proc_get_vma(). Zero at the start or after lseek. */
fe441980161751 Ben Wolsieffer          2023-09-15  199  	if (last_addr == -1UL)
0c563f14804356 Matthew Wilcox (Oracle  2022-09-06  200) 		return NULL;
dbf8685c8e2140 David Howells           2006-09-27  201  
dbf8685c8e2140 David Howells           2006-09-27  202  	/* pin the task and mm whilst we play with them */
2c03376d2db005 Oleg Nesterov           2014-10-09  203  	priv->task = get_proc_task(priv->inode);
dbf8685c8e2140 David Howells           2006-09-27  204  	if (!priv->task)
ec6fd8a4355cda Al Viro                 2011-02-15  205  		return ERR_PTR(-ESRCH);
dbf8685c8e2140 David Howells           2006-09-27  206  
27692cd56e2aa6 Oleg Nesterov           2014-10-09 @207  	mm = priv->mm;
578d7699e5c2ad Ben Wolsieffer          2023-09-14  208  	if (!mm || !mmget_not_zero(mm)) {
578d7699e5c2ad Ben Wolsieffer          2023-09-14  209  		put_task_struct(priv->task);
578d7699e5c2ad Ben Wolsieffer          2023-09-14  210  		priv->task = NULL;
27692cd56e2aa6 Oleg Nesterov           2014-10-09  211  		return NULL;
578d7699e5c2ad Ben Wolsieffer          2023-09-14  212  	}
dbf8685c8e2140 David Howells           2006-09-27  213  
d8ed45c5dcd455 Michel Lespinasse       2020-06-08  214  	if (mmap_read_lock_killable(mm)) {
8a713e7df3352b Konstantin Khlebnikov   2019-07-11  215  		mmput(mm);
578d7699e5c2ad Ben Wolsieffer          2023-09-14  216  		put_task_struct(priv->task);
578d7699e5c2ad Ben Wolsieffer          2023-09-14  217  		priv->task = NULL;
8a713e7df3352b Konstantin Khlebnikov   2019-07-11  218  		return ERR_PTR(-EINTR);
8a713e7df3352b Konstantin Khlebnikov   2019-07-11  219  	}
8a713e7df3352b Konstantin Khlebnikov   2019-07-11  220  
fe441980161751 Ben Wolsieffer          2023-09-15  221  	vma_iter_init(&priv->iter, mm, last_addr);
47fecca15c0944 Oleg Nesterov           2014-10-09  222  
fe441980161751 Ben Wolsieffer          2023-09-15  223  	return proc_get_vma(priv, ppos);
dbf8685c8e2140 David Howells           2006-09-27  224  }
dbf8685c8e2140 David Howells           2006-09-27  225  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

