Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B3FC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 03:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1556B008A; Wed, 16 Sep 2026 23:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C436B008C; Wed, 16 Sep 2026 23:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A736B0092; Wed, 16 Sep 2026 23:11:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7D276B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:11:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9E881201F0
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:11:45 +0000 (UTC)
X-FDA: 85221779370.01.1F63B19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf17.hostedemail.com (Postfix) with ESMTP id 35BE140008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:11:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WdZ+LOnW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789614704;
	b=Po1crSMdoQkXc3lYnygbv5fjev5ZyCB65r+vGRUnaK7+KxQLygyZ8Wcw2GVvY1zMFA7oH7
	4N6oFm2eAomvGoefekokjDxKFT3AHa+Bf56gk1lF6wF/HvTDlgJ6o2yMtl5YqFX4GZR9FW
	6zSPR6H+mJ9FBWSO9B2FfyI3CEkm0sE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WdZ+LOnW;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of lkp@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789614704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=RSz67puNDLLfG/cdO7rVexztqG1VgqGI9fm9ivmtMH8=;
	b=x8mI1Z2JeTueknSWkc3745BcWvKNPpyEATcrsWFm8FRoWzPf/YCLnw0yN6iW4S0+Y78bum
	RTDVjloE0+bAB4kx0n5IbRsfeUjv8F30ntPoq1JvFkntZFVQ9rBj43MqvCxB484I3jEi5C
	6WuSzYdMGRQJh7bzGSgqmPgVgL1g2y8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789614703; x=1821150703;
  h=date:from:to:cc:subject:message-id;
  bh=NbGYQfvcFVItkR9TIAHQyFOTWfE9cJM/aBYDvFnjBIQ=;
  b=WdZ+LOnWpuGCaoqRufP/7XNyQJpWb5AF3E8NiCv+BSinaSlsn9dXwbw0
   Xmdv0HtnlogPh09Ketwq3D/yuNsbMkQHrrbH7F6RhxC7NR+px4WsTS3E5
   51+KtuTjbKECF7ShbN5Gips0T+n1iP8kBiPKIMsy4EQn9k2QHHyfPsE7/
   n+zbKkRp+6MT6kXuG318NtasttZeq9AIQUdSjnDMAomlDWZ2Q/oHQV7qL
   xvdNBrwileeTo0oJaHglGZVHqWMUhh620za/lzMvV35E4ODLBe+Toe4pa
   8h2EzqiANro86sngi0HpmF8SB8d/PyxEyelqWJi+DLAXZmCAkCGk3AUv8
   w==;
X-CSE-ConnectionGUID: N9660963QPa1yniMAq+BEw==
X-CSE-MsgGUID: oRA2tkjDSmqnQpD9boyXTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="115534557"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="115534557"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 20:11:41 -0700
X-CSE-ConnectionGUID: nfpyEJFmSmCGwPAjYY/nIQ==
X-CSE-MsgGUID: 8qE6xmIJSbGsPWxGK4PnTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="277079898"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 16 Sep 2026 20:11:39 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x72XA-0000000073l-2czK;
	Thu, 17 Sep 2026 03:11:36 +0000
Date: Thu, 17 Sep 2026 11:11:15 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 479/575] fs/proc/task_mmu.c:3448:3: error:
 call to undeclared function 'drop_rcu'; ISO C99 and later do not support
 implicit function declarations
Message-ID: <202609171159.oaB1OaSG-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35BE140008
X-Stat-Signature: 3z7yikaotijewcfacnmbqsrxe87pydqb
X-HE-Tag: 1789614703-134579
X-HE-Meta: U2FsdGVkX1+vBYjy7OR+McseYtrgX+XhbVFlQYpnRZsjT0syQdh7aWVunOBPYh3bG2JYZ2vn3osMgLd9tv+CIeRzOvYo0dGzCN8IGmpEbvbL3OQVJgJFv470Mv8Ovpn/Cz3Wj+iEmzMFJlIku81gtOQjojPM/DJaoxuy/dz6Z8klmqrcqe1SRlRI3hu31GbmuBgKELKwwKFa5oKbGzef2HR4Zpnct1OHONANKUELXpvORg4/VpakaVswTiFfZlp0KFwzGclMmI4IVIRBshz1dRW6XDekBoMCKajU+aZRIciMXonxGLkyHnKlGiQFhWtg+wVzhhWI6TFX2VCyHxUIrfVw7M3WhZkuE12gK8Gc1vR2E7HuyqhQAZ+4YX6xLK9yCvsfDS0wSutC+l37ThUO4poJO/JQ+m2P8jfGXAFa5gZagARGzBnqYUvmpCeHwfUcaD5BJd7fSypgxdjxXef3I9DbcTinRbrZk0gKRhntEHPV0ouP05bFs+2A+wUCygBfmZS6Nb76bApautDoP8KiO6ZN2GIXEFJFhbD1edLHuNJ3VouWo3/eJOgleu/+rc3xhgIrL2QhlFgLwSQBKNgn5aZgpOCkgOyiKr6+iRLwhsFRR+p5DrzwQRqseFXubveQ3ENq9HTRfGELLui8FJGyg2hRxSlqg1+fk1my6YNv6KDEInCmX1BAgcTVwBB4g8futOGn1DGi2QJ7zu6WykQyhPDTx8XLSM2te7SP/qJM1Fg2V0U2Aw66w8uzQJ2mxFMHCbPWoxYnCJPj8Kx+wS6DggnGsc1IhdML4nShQ6678ba0P3EqPsn4DN/jNFsKmZdVwi0vSzVbBcf/vMf+IAcVxSez3hvM8yJgqy29cYwGmlqukBSg0wgeXdCBvDnqy2AKiwNPZVh/2PnmoXnU0DucJvM8FvlXDGOYD+3C5mKpqljX32C3+5NBC2jJqnYm6H6uw4i9a4gbMuB2aMKxNvQ
 N1GEomSS
 QSnJ6V8JdZtJXaWfjkf76t7DQAy2kQ6bEgFseNqrwrENFJ0xzNHs7NmfqxzAIz3r0R4GEWj2q2lYFksF0Ai8GMnr0z4nOwywhPWNfu/6lGksbVfZX/GxFauTpgevbF86AK7DuD30vnAlxngz7D8NwfbM0RDWchBy50MENKZkHHdVBB5Gq+o/lz2oWOgBsYhnm5r3OnCbdAUdW2QjCRVB83tS2VG1uP6J0sR6VlcR3i/DZxyKXDCd8MwgZaE6/bdfXJcrQZfCxGZ5mOT0bpxZLIFBiJHk56+wHfmXBHn/N6rOVU0F90RvG799g5KOPsqo9tu4e1Jf3xcwybKOOnooqIaLuwTxvsRLqg3cYQh5qUYWCK07McA7aQGQ+GdTaipAazkuAaMTvIWr77FX/V6/okowrwdvvNyNscw/UwKamZASnEKv07vF3A3ZSx2dd6XBPla9K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   892f5b3b07e5b07f2f29c87750ff94fa58dcab73
commit: ba1552b2bcbd7adc40512846abeabb02659e6f92 [479/575] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
config: x86_64-randconfig-1014-20260917 (https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lkp@intel.com/config)
compiler: clang version 22.1.3 (https://github.com/llvm/llvm-project e9846648fd6183ee6d8cbdb4502213fcf902a211)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260917/202609171159.oaB1OaSG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> fs/proc/task_mmu.c:3448:3: error: call to undeclared function 'drop_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    3448 |                 drop_rcu(proc_priv);
         |                 ^
>> fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'reacquire_rcu'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    3450 |                 reacquire_rcu(proc_priv);
         |                 ^
   2 errors generated.


vim +/drop_rcu +3448 fs/proc/task_mmu.c

ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3400  
f69ff943df6972 Stephen Wilson     2011-05-24  3401  /*
f69ff943df6972 Stephen Wilson     2011-05-24  3402   * Display pages allocated per node and memory policy via /proc.
f69ff943df6972 Stephen Wilson     2011-05-24  3403   */
871305bb202808 Vlastimil Babka    2018-08-21  3404  static int show_numa_map(struct seq_file *m, void *v)
f69ff943df6972 Stephen Wilson     2011-05-24  3405  {
5b52fc890bece7 Stephen Wilson     2011-05-24  3406  	struct numa_maps_private *numa_priv = m->private;
5b52fc890bece7 Stephen Wilson     2011-05-24  3407  	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
f69ff943df6972 Stephen Wilson     2011-05-24  3408  	struct vm_area_struct *vma = v;
5b52fc890bece7 Stephen Wilson     2011-05-24  3409  	struct numa_maps *md = &numa_priv->md;
f69ff943df6972 Stephen Wilson     2011-05-24  3410  	struct file *file = vma->vm_file;
f69ff943df6972 Stephen Wilson     2011-05-24  3411  	struct mm_struct *mm = vma->vm_mm;
948927ee9e4f35 David Rientjes     2013-11-12  3412  	char buffer[64];
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3413  	struct mempolicy *pol;
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3414  	pgoff_t ilx;
948927ee9e4f35 David Rientjes     2013-11-12  3415  	int nid;
f69ff943df6972 Stephen Wilson     2011-05-24  3416  
f69ff943df6972 Stephen Wilson     2011-05-24  3417  	if (!mm)
f69ff943df6972 Stephen Wilson     2011-05-24  3418  		return 0;
f69ff943df6972 Stephen Wilson     2011-05-24  3419  
5b52fc890bece7 Stephen Wilson     2011-05-24  3420  	/* Ensure we start with an empty set of numa_maps statistics. */
5b52fc890bece7 Stephen Wilson     2011-05-24  3421  	memset(md, 0, sizeof(*md));
f69ff943df6972 Stephen Wilson     2011-05-24  3422  
ddc1a5cbc05dc6 Hugh Dickins       2023-10-19  3423  	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
498f237178a3d3 Oleg Nesterov      2014-10-09  3424  	if (pol) {
948927ee9e4f35 David Rientjes     2013-11-12  3425  		mpol_to_str(buffer, sizeof(buffer), pol);
f69ff943df6972 Stephen Wilson     2011-05-24  3426  		mpol_cond_put(pol);
498f237178a3d3 Oleg Nesterov      2014-10-09  3427  	} else {
498f237178a3d3 Oleg Nesterov      2014-10-09  3428  		mpol_to_str(buffer, sizeof(buffer), proc_priv->task_mempolicy);
498f237178a3d3 Oleg Nesterov      2014-10-09  3429  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3430  
f69ff943df6972 Stephen Wilson     2011-05-24  3431  	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
f69ff943df6972 Stephen Wilson     2011-05-24  3432  
f69ff943df6972 Stephen Wilson     2011-05-24  3433  	if (file) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3434  		seq_puts(m, " file=");
08582d678fcf11 Amir Goldstein     2023-10-09  3435  		seq_path(m, file_user_path(file), "\n\t= ");
11250fd12eb8a5 Kefeng Wang        2023-07-28  3436  	} else if (vma_is_initial_heap(vma)) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3437  		seq_puts(m, " heap");
11250fd12eb8a5 Kefeng Wang        2023-07-28  3438  	} else if (vma_is_initial_stack(vma)) {
17c2b4ee40beae Fabian Frederick   2014-06-06  3439  		seq_puts(m, " stack");
f69ff943df6972 Stephen Wilson     2011-05-24  3440  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3441  
fc360bd9cdcf87 Andrew Morton      2011-10-31  3442  	if (is_vm_hugetlb_page(vma))
17c2b4ee40beae Fabian Frederick   2014-06-06  3443  		seq_puts(m, " huge");
fc360bd9cdcf87 Andrew Morton      2011-10-31  3444  
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3445  	/* Skip walking pages if gate VMA */
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3446  	if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3447  		/* Might sleep. Drop RCU read lock but keep the VMA locked. */
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25 @3448  		drop_rcu(proc_priv);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3449  		walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25 @3450  		reacquire_rcu(proc_priv);
ea3085dd7a4ec2 Suren Baghdasaryan 2026-04-25  3451  	}
f69ff943df6972 Stephen Wilson     2011-05-24  3452  
f69ff943df6972 Stephen Wilson     2011-05-24  3453  	if (!md->pages)
f69ff943df6972 Stephen Wilson     2011-05-24  3454  		goto out;
f69ff943df6972 Stephen Wilson     2011-05-24  3455  
f69ff943df6972 Stephen Wilson     2011-05-24  3456  	if (md->anon)
f69ff943df6972 Stephen Wilson     2011-05-24  3457  		seq_printf(m, " anon=%lu", md->anon);
f69ff943df6972 Stephen Wilson     2011-05-24  3458  
f69ff943df6972 Stephen Wilson     2011-05-24  3459  	if (md->dirty)
f69ff943df6972 Stephen Wilson     2011-05-24  3460  		seq_printf(m, " dirty=%lu", md->dirty);
f69ff943df6972 Stephen Wilson     2011-05-24  3461  
f69ff943df6972 Stephen Wilson     2011-05-24  3462  	if (md->pages != md->anon && md->pages != md->dirty)
f69ff943df6972 Stephen Wilson     2011-05-24  3463  		seq_printf(m, " mapped=%lu", md->pages);
f69ff943df6972 Stephen Wilson     2011-05-24  3464  
f69ff943df6972 Stephen Wilson     2011-05-24  3465  	if (md->mapcount_max > 1)
f69ff943df6972 Stephen Wilson     2011-05-24  3466  		seq_printf(m, " mapmax=%lu", md->mapcount_max);
f69ff943df6972 Stephen Wilson     2011-05-24  3467  
f69ff943df6972 Stephen Wilson     2011-05-24  3468  	if (md->swapcache)
f69ff943df6972 Stephen Wilson     2011-05-24  3469  		seq_printf(m, " swapcache=%lu", md->swapcache);
f69ff943df6972 Stephen Wilson     2011-05-24  3470  
f69ff943df6972 Stephen Wilson     2011-05-24  3471  	if (md->active < md->pages && !is_vm_hugetlb_page(vma))
f69ff943df6972 Stephen Wilson     2011-05-24  3472  		seq_printf(m, " active=%lu", md->active);
f69ff943df6972 Stephen Wilson     2011-05-24  3473  
f69ff943df6972 Stephen Wilson     2011-05-24  3474  	if (md->writeback)
f69ff943df6972 Stephen Wilson     2011-05-24  3475  		seq_printf(m, " writeback=%lu", md->writeback);
f69ff943df6972 Stephen Wilson     2011-05-24  3476  
948927ee9e4f35 David Rientjes     2013-11-12  3477  	for_each_node_state(nid, N_MEMORY)
948927ee9e4f35 David Rientjes     2013-11-12  3478  		if (md->node[nid])
948927ee9e4f35 David Rientjes     2013-11-12  3479  			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
198d1597cc5a12 Rafael Aquini      2015-02-12  3480  
198d1597cc5a12 Rafael Aquini      2015-02-12  3481  	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
f69ff943df6972 Stephen Wilson     2011-05-24  3482  out:
f69ff943df6972 Stephen Wilson     2011-05-24  3483  	seq_putc(m, '\n');
f69ff943df6972 Stephen Wilson     2011-05-24  3484  	return 0;
f69ff943df6972 Stephen Wilson     2011-05-24  3485  }
5b52fc890bece7 Stephen Wilson     2011-05-24  3486  

:::::: The code at line 3448 was first introduced by commit
:::::: ea3085dd7a4ec212d6c4b50efca584e0928caa72 fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock

:::::: TO: Suren Baghdasaryan <surenb@google.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

