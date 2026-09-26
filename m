Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47BAC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 11:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C28C6B0088; Sat, 26 Sep 2026 07:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CF56B008A; Sat, 26 Sep 2026 07:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814A76B008C; Sat, 26 Sep 2026 07:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5B56B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 07:09:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C650EA6F80
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:09:08 +0000 (UTC)
X-FDA: 85255641576.04.51484BB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id 587511C0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 11:09:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PbUIb/hN";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790420947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=w/6xjGSkMLPDSOa0n+PmIt/NgbLZ0PoDu9G568yTyLE=;
	b=EfVhedVO6i3aMDneJjoa1fo09jMJAlMsZf0HYcw1MQEioTFAKWaOy3fA7DA+tBsexALEUy
	RXVB9vIKiJ/JbecTmxY0N00CtPzeUr5jesZi4YErZAHt2nguoV0QT1EdZbMVdRQCjYXKZN
	Mdt1qH20k7V5kuY8swIZ1Mc6z024tJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790420947;
	b=E1ANdVPZinMx20ywYm0fNW0IcgTnTsCXq4xSqYFSefFydITlQTIYac+Fte9vcoc5MTpgOk
	j/zukW9Gkx/S9QELMsKRMQDBs1bmJaQmWmRFV/faSoMmue/W1yR7095QPJscROf00enRCx
	755b6gdf8AgehGlHOoYizroqzjTO4aU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="PbUIb/hN";
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790420947; x=1821956947;
  h=date:from:to:cc:subject:message-id;
  bh=8vYxlRed0s/hQKmynMf6UjR8wsCPC+MrHFJobeR6PyQ=;
  b=PbUIb/hND6QdaPZey4LSJRGG2gxefw1khJGhpSSXwfzvYA0MelRerjcM
   rfJlLCkY9g2IyjMrylNpo82qIfIOClHHGiYDvkrB5YiC8Jmc4HL9br+2i
   5M18D0Ciezg2K92b1NiTXmDJs+rTc0yrpWHV304YJYwHBw4sxyOSoH7Cf
   k+ARytJNN1WF0Q0Fn0OCFXe30rYQdDEv7dWwuHYdtTvTUIIJw/h1dA5OD
   5uwrPQK168H0AT8YeSkNWHjOSqtfHA0ttZT2rTBhjZs9lIG8Bgy3upkmA
   4YZ5iA6e0ktHQaTAZclUwc1DfgM54/PAYFj1+c6frNKH72QmL5ej/3lTu
   g==;
X-CSE-ConnectionGUID: FHTiJzF2RRSagfGqDukC5Q==
X-CSE-MsgGUID: mWOHT8HKReydVHgHGHsUYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11916"; a="107570096"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="107570096"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 04:09:05 -0700
X-CSE-ConnectionGUID: YjUvJbPCQ5aUIauflumo5w==
X-CSE-MsgGUID: 27FSCWw0TSyq9GXTCvMrsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="302499051"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 26 Sep 2026 04:09:02 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xAQH5-00000000Ljj-3xiw;
	Sat, 26 Sep 2026 11:08:59 +0000
Date: Sat, 26 Sep 2026 19:08:26 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 "Liam R. Howlett (Oracle)" <liam@infradead.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [linux-next:master 8327/9480] fs/proc/task_mmu.c:3452:3:
 error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'?
Message-ID: <202609261818.gGqBcNSM-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Stat-Signature: 59k4y47fa6ywb419fmce6qw3d5nbzd17
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 587511C0002
X-HE-Tag: 1790420946-212325
X-HE-Meta: U2FsdGVkX19Ja1g+DgbguPuUSRObTsqifP8xSmWmZ/+wpYWA8kOM1Gq7QSFDDajcBtaHRZy+HOWIUkdaiRu3KAm+Gw9YRqg7hEyDX306OFRwNTotW141DHozXRD3wUsJ21ABs2QrB1TfmrGGEvCUoZZsW+0R9vOLbEsSQwvhH1bqD1TribXs2+Dc6DP1C1ColCZ34ll6WNO7rusbkA7xHXmWG1fsZ9zwpdOBYH8VYlU+cyG6B68GeGrh4sgiiWAw6fguukwrMQlWCHvOJi2ZgIM17zrr+ipYxX8MmmVXIWPe1wwDhkj1JE44TSAdqPuh6oH9sb1QKc2UrA6EXRDcufURspUHe1EXfeSIsKA4vIOtwN0d6BMxEfVZH6XOEpjrklmOp8MHjn22ywQBZMFc126ptwguphTnpzJGgLEY52mhcqecxH5eOmA1MedgGUqVFE/l+Aw+93qomVhhS/AMREJU+fCCje6q7wttRnhunCD3swTRgq/hv1kabZk23gsZmMZ0xJ2w5Gif7XQ1OpgKLgW2MEvJipDFD5mQIXpH4juC1ltOd+NAzrzFCtqx1D4K5HJJqKCzq4CdLgcs95N/7NNwVMc2DTDIq0Uw0qZ0mZZeyeAc+qwVO+BWSyN4U7vSulx7k6s1jyK1LQgUIg74z1XlPQ884C74zud6qbOVYRyp6vcRdAJpAqtbi8JSjTqQneKJU+mp1dtgi5BYIeuqoItn8Gloa61gqjOlfoCWgSIIftnUJvaIoKsO+DxlVRTExXpxcIuf2JBmlCDEyxEPnfBgf5MeEzzPSwNnnRl2sammxCr4bdVpJTT2h+j+pGsipoDY+sF1zvVqvi8ZfcqNOZyFVudhCuT4B/NE2NToeKL1gNmAxUTdCoQyePK3Uyxcsd1ajtmEbYOSURuXRbYVejxPCPW0MIDCplposYdR2DfMj3MglbPvbrSmnSshO28aiPFSksMKcQH3QGtUyJW
 JdRs/5IR
 hwRmDdKe+Jl0gS2tgFlK+CyZ/0KNy2OmZDY4OL8OefvfN3FusjUeb/yWwv3yXSuBPlePemaofW0lgBQn225iwe/SCA8q/fKh89REIMyrUzPtGxLBkF55rKIpdeh0kjSRv182tOsEuP1hPD+mzMxSVCtkFE2VejwyxIy4nBl34798MShsqmsQOsC8rT1wb1MH4r3cJ802oE1zA9WOU2FfW86YqVjCFro+2hr71KSxDs5jiVXcKjS6CmAjtDQUoJSBeEFYyI+VxIf0apF9iSb0VahFxp+Uzd+ZFF0vVLe9Q/oZi5/jMlinQtsVsmSG2imVI0+2JYcU3C7w470BMi5u1rmlWjEz4MoCTVbD82wXM2PYVRuyTU+5cVv9rXvLOdpYgyXnOjz9yeW0Z50MgS1L8C1d0qTH2XuqhbTIIscaSq82aAsChCv1RxFXUKhhhdvZp9JYXf011x11v1Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
head:   f5f84daefcd92d7a630066635ecea1433ed5eac7
commit: b58393e47de94ac659598675696bb8c281f4c5aa [8327/9480] proc/task_mmu: remove unnecessary inlines in function definitions
config: powerpc64-randconfig-1001-20260926 (https://download.01.org/0day-ci/archive/20260926/202609261818.gGqBcNSM-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260926/202609261818.gGqBcNSM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609261818.gGqBcNSM-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/proc/task_mmu.c: In function 'show_numa_map':
>> fs/proc/task_mmu.c:3452:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
      drop_rcu(proc_priv);
      ^~~~~~~~
      drop_slab
>> fs/proc/task_mmu.c:3454:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
      reacquire_rcu(proc_priv);
      ^~~~~~~~~~~~~
      get_file_rcu
   cc1: some warnings being treated as errors


vim +3452 fs/proc/task_mmu.c

ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3404  
f69ff943df6972a Stephen Wilson        2011-05-24  3405  /*
f69ff943df6972a Stephen Wilson        2011-05-24  3406   * Display pages allocated per node and memory policy via /proc.
f69ff943df6972a Stephen Wilson        2011-05-24  3407   */
871305bb2028080 Vlastimil Babka       2018-08-21  3408  static int show_numa_map(struct seq_file *m, void *v)
f69ff943df6972a Stephen Wilson        2011-05-24  3409  {
5b52fc890bece77 Stephen Wilson        2011-05-24  3410  	struct numa_maps_private *numa_priv = m->private;
5b52fc890bece77 Stephen Wilson        2011-05-24  3411  	struct proc_maps_private *proc_priv = &numa_priv->proc_maps;
f69ff943df6972a Stephen Wilson        2011-05-24  3412  	struct vm_area_struct *vma = v;
5b52fc890bece77 Stephen Wilson        2011-05-24  3413  	struct numa_maps *md = &numa_priv->md;
f69ff943df6972a Stephen Wilson        2011-05-24  3414  	struct file *file = vma->vm_file;
f69ff943df6972a Stephen Wilson        2011-05-24  3415  	struct mm_struct *mm = vma->vm_mm;
948927ee9e4f35f David Rientjes        2013-11-12  3416  	char buffer[64];
ddc1a5cbc05dc62 Hugh Dickins          2023-10-19  3417  	struct mempolicy *pol;
ddc1a5cbc05dc62 Hugh Dickins          2023-10-19  3418  	pgoff_t ilx;
948927ee9e4f35f David Rientjes        2013-11-12  3419  	int nid;
f69ff943df6972a Stephen Wilson        2011-05-24  3420  
f69ff943df6972a Stephen Wilson        2011-05-24  3421  	if (!mm)
f69ff943df6972a Stephen Wilson        2011-05-24  3422  		return 0;
f69ff943df6972a Stephen Wilson        2011-05-24  3423  
5b52fc890bece77 Stephen Wilson        2011-05-24  3424  	/* Ensure we start with an empty set of numa_maps statistics. */
5b52fc890bece77 Stephen Wilson        2011-05-24  3425  	memset(md, 0, sizeof(*md));
f69ff943df6972a Stephen Wilson        2011-05-24  3426  
ddc1a5cbc05dc62 Hugh Dickins          2023-10-19  3427  	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
498f237178a3d31 Oleg Nesterov         2014-10-09  3428  	if (pol) {
948927ee9e4f35f David Rientjes        2013-11-12  3429  		mpol_to_str(buffer, sizeof(buffer), pol);
f69ff943df6972a Stephen Wilson        2011-05-24  3430  		mpol_cond_put(pol);
498f237178a3d31 Oleg Nesterov         2014-10-09  3431  	} else {
498f237178a3d31 Oleg Nesterov         2014-10-09  3432  		mpol_to_str(buffer, sizeof(buffer), proc_priv->task_mempolicy);
498f237178a3d31 Oleg Nesterov         2014-10-09  3433  	}
f69ff943df6972a Stephen Wilson        2011-05-24  3434  
f69ff943df6972a Stephen Wilson        2011-05-24  3435  	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
f69ff943df6972a Stephen Wilson        2011-05-24  3436  
f69ff943df6972a Stephen Wilson        2011-05-24  3437  	if (file) {
17c2b4ee40beae2 Fabian Frederick      2014-06-06  3438  		seq_puts(m, " file=");
08582d678fcf11f Amir Goldstein        2023-10-09  3439  		seq_path(m, file_user_path(file), "\n\t= ");
11250fd12eb8a58 Kefeng Wang           2023-07-28  3440  	} else if (vma_is_initial_heap(vma)) {
17c2b4ee40beae2 Fabian Frederick      2014-06-06  3441  		seq_puts(m, " heap");
11250fd12eb8a58 Kefeng Wang           2023-07-28  3442  	} else if (vma_is_initial_stack(vma)) {
17c2b4ee40beae2 Fabian Frederick      2014-06-06  3443  		seq_puts(m, " stack");
f69ff943df6972a Stephen Wilson        2011-05-24  3444  	}
f69ff943df6972a Stephen Wilson        2011-05-24  3445  
a79dda19fe434fd Lorenzo Stoakes (ARM  2026-09-17  3446) 	if (vma_is_hugetlb(vma))
17c2b4ee40beae2 Fabian Frederick      2014-06-06  3447  		seq_puts(m, " huge");
fc360bd9cdcf875 Andrew Morton         2011-10-31  3448  
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3449  	/* Skip walking pages if gate VMA */
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3450  	if (vma != get_gate_vma(proc_priv->lock_ctx.mm)) {
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3451  		/* Might sleep. Drop RCU read lock but keep the VMA locked. */
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25 @3452  		drop_rcu(proc_priv);
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3453  		walk_page_vma(vma, get_show_numa_ops(proc_priv), md);
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25 @3454  		reacquire_rcu(proc_priv);
ea3085dd7a4ec21 Suren Baghdasaryan    2026-04-25  3455  	}
f69ff943df6972a Stephen Wilson        2011-05-24  3456  
f69ff943df6972a Stephen Wilson        2011-05-24  3457  	if (!md->pages)
f69ff943df6972a Stephen Wilson        2011-05-24  3458  		goto out;
f69ff943df6972a Stephen Wilson        2011-05-24  3459  
f69ff943df6972a Stephen Wilson        2011-05-24  3460  	if (md->anon)
f69ff943df6972a Stephen Wilson        2011-05-24  3461  		seq_printf(m, " anon=%lu", md->anon);
f69ff943df6972a Stephen Wilson        2011-05-24  3462  
f69ff943df6972a Stephen Wilson        2011-05-24  3463  	if (md->dirty)
f69ff943df6972a Stephen Wilson        2011-05-24  3464  		seq_printf(m, " dirty=%lu", md->dirty);
f69ff943df6972a Stephen Wilson        2011-05-24  3465  
f69ff943df6972a Stephen Wilson        2011-05-24  3466  	if (md->pages != md->anon && md->pages != md->dirty)
f69ff943df6972a Stephen Wilson        2011-05-24  3467  		seq_printf(m, " mapped=%lu", md->pages);
f69ff943df6972a Stephen Wilson        2011-05-24  3468  
f69ff943df6972a Stephen Wilson        2011-05-24  3469  	if (md->mapcount_max > 1)
f69ff943df6972a Stephen Wilson        2011-05-24  3470  		seq_printf(m, " mapmax=%lu", md->mapcount_max);
f69ff943df6972a Stephen Wilson        2011-05-24  3471  
f69ff943df6972a Stephen Wilson        2011-05-24  3472  	if (md->swapcache)
f69ff943df6972a Stephen Wilson        2011-05-24  3473  		seq_printf(m, " swapcache=%lu", md->swapcache);
f69ff943df6972a Stephen Wilson        2011-05-24  3474  
a79dda19fe434fd Lorenzo Stoakes (ARM  2026-09-17  3475) 	if (md->active < md->pages && !vma_is_hugetlb(vma))
f69ff943df6972a Stephen Wilson        2011-05-24  3476  		seq_printf(m, " active=%lu", md->active);
f69ff943df6972a Stephen Wilson        2011-05-24  3477  
f69ff943df6972a Stephen Wilson        2011-05-24  3478  	if (md->writeback)
f69ff943df6972a Stephen Wilson        2011-05-24  3479  		seq_printf(m, " writeback=%lu", md->writeback);
f69ff943df6972a Stephen Wilson        2011-05-24  3480  
948927ee9e4f35f David Rientjes        2013-11-12  3481  	for_each_node_state(nid, N_MEMORY)
948927ee9e4f35f David Rientjes        2013-11-12  3482  		if (md->node[nid])
948927ee9e4f35f David Rientjes        2013-11-12  3483  			seq_printf(m, " N%d=%lu", nid, md->node[nid]);
198d1597cc5a12d Rafael Aquini         2015-02-12  3484  
198d1597cc5a12d Rafael Aquini         2015-02-12  3485  	seq_printf(m, " kernelpagesize_kB=%lu", vma_kernel_pagesize(vma) >> 10);
f69ff943df6972a Stephen Wilson        2011-05-24  3486  out:
f69ff943df6972a Stephen Wilson        2011-05-24  3487  	seq_putc(m, '\n');
f69ff943df6972a Stephen Wilson        2011-05-24  3488  	return 0;
f69ff943df6972a Stephen Wilson        2011-05-24  3489  }
5b52fc890bece77 Stephen Wilson        2011-05-24  3490  

:::::: The code at line 3452 was first introduced by commit
:::::: ea3085dd7a4ec212d6c4b50efca584e0928caa72 fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock

:::::: TO: Suren Baghdasaryan <surenb@google.com>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

