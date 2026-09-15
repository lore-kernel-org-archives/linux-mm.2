Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55098C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 19:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160446B0088; Tue, 15 Sep 2026 15:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112076B008C; Tue, 15 Sep 2026 15:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CD96B0092; Tue, 15 Sep 2026 15:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C6AB96B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:39:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8562120516
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:39:09 +0000 (UTC)
X-FDA: 85217010018.04.A539C75
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8435CA0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:39:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UV+F2VAE;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789501147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=bZQlCBvwSsBNKnXoGzqSi2RN+4wXr/2dE7gN5Hd7GuY=;
	b=pJOBMhrPzevWarDpJCaEnKCtwIzChESAbStqcafHYtagGC6/qsjvVgrhdv4OLCR17ComWy
	7GeVhZyPIsI4/2+Plk0xDU6TjvKGA+0ptyvFYON12hdZANgavZ9EG1TESlveA+OFl/uQh9
	gUrOUZyIMslycjeVf6eo05gB1jrn6RA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789501147;
	b=5kLRmyrBym6zCWhUPYSVB8Vu2WkeNfDwCpHnVC0TzUzKugrndEB6F2r2hgHalvPKlJbyjB
	q08hMqDoQOQkIlif061OKbwt0WwD3PceT09LVPulOP/aRXWMf9DIiosIvJw4a3Mu9ccBLU
	xkeR+OFGrKSafQKRFBISMUSrgK/RcR0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UV+F2VAE;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789501147; x=1821037147;
  h=date:from:to:cc:subject:message-id;
  bh=mpETyrPnt2gx6qCCDWHtDXB7qf63CTS6QqeY1voYvjw=;
  b=UV+F2VAEItyqt9t3fLerq3xEhzkOXYkuTGdBVJ4irjmZWxqC2vX8OKCB
   MJ8qv5ZYmALzfrk6rXTZXQaDQsFssaaPxFO4C1j8o60+OwMdG3562uvs5
   ukGWG87ZQQvYIGNJ4ZpkCWkffdLBal7mWknMI17KsMmt7feVw3G+nKVPm
   gMhxl62mtRL3f+VEsGzXSbll2TwF2HS2FwVKUGboxA5ZHFtpBOXkjl71I
   XTVca3HeqsgU17bMI5QJHmNWrS8AKsycEDDUMJNQIfRIp5sdTf9Ft7MTL
   79R0hRl2XMwb86HA3ywcU1Aco5+kQr98m7mlV1bColPNa2URn8BqlUfco
   A==;
X-CSE-ConnectionGUID: 3rodNMUiRXKtNxb0gq+gIA==
X-CSE-MsgGUID: ALOk3GklQSyZLf/g9SZQDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="89747453"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="89747453"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2026 12:39:05 -0700
X-CSE-ConnectionGUID: 55YOG7vVTZOT4E7dkgfKvg==
X-CSE-MsgGUID: ewrPQrfwQLCfajMLxDFxDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="298166415"
Received: from lkp-server01.sh.intel.com (HELO 462990a40a85) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 15 Sep 2026 12:39:02 -0700
Received: from kbuild by 462990a40a85 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x6Yzb-00000000501-3oSK;
	Tue, 15 Sep 2026 19:38:59 +0000
Date: Wed, 16 Sep 2026 03:38:32 +0800
From: kernel test robot <lkp@intel.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 478/560] fs/proc/task_mmu.c:3448:3: error:
 implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'?
Message-ID: <202609160337.WJiD9BqX-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: t1xuujh7hizwcq99fpmy8goswxqa43t1
X-Rspamd-Queue-Id: 8435CA0005
X-HE-Tag: 1789501146-915261
X-HE-Meta: U2FsdGVkX1+WBynuE6QNY7tZu6zuT18aRWBw2NrqYw9Q9DovV14+bOdG3Dtr8hwC3EI8ny540AxoOW4jfgPurgw53DdS/t97hwRbrR2gVgTBJqZEvXSmdDOh0BRSeiVAmQx3GSWKLcDztBPBNnrGzsepWPy3Ph+HaJsNpPEllIpTBxtDZHfsvGYq11XcWipFlBdUScrQNSZZzKZ5C/kUfUofbiajIL7V4VA2t9fg/6oCDTZ4BqHOBDIxk+D0wveNBSFeMt8JoUNDy/ujLpbYBLHn7/OmRrH1pVFPzjESuGF6lJg35XDyENaw2hG13Ev3AxB9DggAag8KXQsTau/X2Oa3dW1ef13SJtfYmCjdxKLiREdMH+zeuCRHyOzlzODPjlBu3AFR92SW1OCJIQXtwpCXIuSaCmTRE0KQNb/KwKFEKIIccnPw0wwAbeA9ofUtJIA/RpShMcpqd6hVLPhD17z98GsrDUf5Cvgxh4+LJz8jCGJt2qTQkk15nC6s/y963JGRJ6Do5JBmv+SWQEDAcEaSEY9fwMEgmvD5t1CQMaqaBIv5XGxYYAS69zpNd0FNpjpmmk5GaAvw3sx8DYboIA6GSO9yjEy+BwB8TCUPToQy7TtzvuSn++IMwM9gAgmsCaJlJGmHVmGOy8wPIbs92r3tf2ZbWv5MllHNNmLwPqLAPRbQnOL7LFO503i5G5Ns6XXlZuc/N/wxMSU5/ft1BHcH7znFbVlBq1DGQD+XWO3vzwxFg4q9tq6X/Y8C4Xe6i8ML2nanXDBpg5qMh735rgkKNUU1KCJFFOBs4agfyuTUSZb+joiD+HhfWlyQHFfNLHfqr5qc176qwuDkMjCpaNooEaCswC+W8tJ0RpBzoVKHMUAq4C7dQG0jQXsIzBc/taRvdXF9H8s+V0Jw07WlXIIGK4ln0ui8YvJjpatEvxgxtnc2aHFBy4GVnon3x0wjvWzLZ0ctepqLJCGeamN
 E2Td/I7L
 toWr0pnMk+e+J0jQBzSoyo7J8X+ZHDqD10KwqRV55exeC526AzAK1h7Il23P3PFk0YW074iHmNZUsVaK09mc8X026b8SWB3HWmaBnt1VDYrGcEw7fEhDOpNDDWpQqihSVO1Egc+WgtjMnKfh1R0NULjKkq7LpsqgCWmTufwhteoHYENsF9GSdmCYZT3jormPAvDFW14JH9n7bNAzHstelueGUBdR2CHZR9ab8bUncySpo6LqDVuMV4UY02GFOgjh2RtZKINj1N7OajOFJMtPlll5LZKpDXISc3jNxUS3dP1uldkDY05dztBFIMsHZYQiQuFRThopLePmyWH01zoFK0RXK0PZf3iEIJKD2Tf6Xv2F1Az7cgzUyEqW7jC6VKKbW1PM1/hAhxvpWQUk+iDO6rRtivC9+U1ncDp6MCCxyDtsR51XKu0rjnTGTv2dI2do35RypZ2dVEOti2H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   b08a65b93426d86e3f354d655d6225397b591877
commit: 35ba620bfe7feb76c85e06b9ea72c188e1e6e318 [478/560] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
config: riscv-randconfig-002-20260915 (https://download.01.org/0day-ci/archive/20260916/202609160337.WJiD9BqX-lkp@intel.com/config)
compiler: riscv64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260916/202609160337.WJiD9BqX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@intel.com/

All errors (new ones prefixed by >>):

   fs/proc/task_mmu.c: In function 'show_numa_map':
>> fs/proc/task_mmu.c:3448:3: error: implicit declaration of function 'drop_rcu'; did you mean 'drop_slab'? [-Werror=implicit-function-declaration]
      drop_rcu(proc_priv);
      ^~~~~~~~
      drop_slab
>> fs/proc/task_mmu.c:3450:3: error: implicit declaration of function 'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=implicit-function-declaration]
      reacquire_rcu(proc_priv);
      ^~~~~~~~~~~~~
      get_file_rcu
   At top level:
   fs/proc/task_mmu.c:133:12: warning: 'lock_ctx_mm' defined but not used [-Wunused-function]
    static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
               ^~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +3448 fs/proc/task_mmu.c

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

