Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 309A2CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A506B008C; Wed, 13 May 2026 20:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831316B0092; Wed, 13 May 2026 20:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F336B0093; Wed, 13 May 2026 20:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6109C6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:17:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 08AACA04BB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:17:19 +0000 (UTC)
X-FDA: 84764110998.06.A647A4F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D416180007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:17:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cTw0zBLe;
	spf=none (imf06.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778717837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oX9g8faiVJzlK7ZAYPAWqKSR4kw1omN99Y4wRJE0l/U=;
	b=fBWa9RHUe6BTC4sK/ugAHIZHxTG7hKEc9P8H/6EJB1TX/ISUsds9fqRnIE0VwAQs/7tHmD
	aGG6qT1+LawEhZJCGT0/etkgBOGdRj1wPp/FyFxzwy8eR1XkJAnPo1zb6DLb6OPvj/DhYJ
	l0u9rPtPc+D69ooIq5bVffBRdQi9YDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778717837; a=rsa-sha256;
	cv=none;
	b=BYvpihSu2HpyP9NfvcIleiB2CZsbtTYLZ4bklmqTjnP0in8xUKlLq9uaFLwb1LncTbnn3J
	ltcVTh01tEMbf9kP/EqbIxgVy5uJBPvE8F2u8k6uttotkFBqcZDyMh4QUNMOLgQR5Xad7E
	RyPqGy87fXOMf68JVfRQQDEyvZeVixc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=cTw0zBLe;
	spf=none (imf06.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=oX9g8faiVJzlK7ZAYPAWqKSR4kw1omN99Y4wRJE0l/U=; b=cTw0zBLegyACp1ucpmniwTRfPT
	ZnPzj7gEOaF61y6VhEN+n8s+iB8qNtL6+G0rQ7NPnFWrD6GIPBKrg5JOWCMF+6SCWodRJrcykSUG4
	rar+wxHxSvsrDwYf9lZ+tlyFhXjV4WlY8rIlUKFwy7PEjVl6iFh3/7RlmGWHNvRzCu7iq9G7MgagL
	zBJ1GbteJwGe/jp784QedX99zVr41MolMl1Vj4PIKqU2w3z1r+UlZeuu5gpdgtKpVnGpm/JHyD4Zs
	E6LzZSpFwoFyDofhgCr1s1vXjXBoEFPcuVKSdG3OKEa/kTIRZyf6cvYFrgZxc7fuNHGtXo4QwS1+i
	heVi1GXg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNJl7-000000048eV-1Qmy;
	Thu, 14 May 2026 00:17:01 +0000
Date: Wed, 13 May 2026 20:16:42 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: kernel test robot <oliver.sang@intel.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Matthew Wilcox <willy@infradead.org>, 
	SeongJae Park <sj@kernel.org>, Sidhartha Kumar <sidhartha.kumar@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
References: <202605131554.92e7df6b-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202605131554.92e7df6b-lkp@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D416180007
X-Rspam-User: 
X-Stat-Signature: tsoys8j6emam9x69m36surxrur8mtkob
X-HE-Tag: 1778717836-189163
X-HE-Meta: U2FsdGVkX19Mg00UGIYcwsnSTUMnvy4lKCIEAUiC5Z7aJWWSUBqFE4fq5MSnrhB5NCeGgFeSECN3nD+OQLwBDZAnAb8zhBOeUE6sbM8gA3zc5d1LLFtm8Oa+az982W3OywRcKCwzGYcTedQSg9396vauSLkIxglnFdoD9MA4aD6fIeq2/5yoJQ5smJ2onB9lILHJz6O/aOd3aZ66qAZmlOKurRZB+8oLIs+1eyqqLU/wZLqh7XE5Q0ZEYVArXrTSscCd5udbim+IC0tMT6runsgkC3zOdG+yd4FaRGFyI3zriWxSeXxijgQqGJX05djHrW54cJEmpVYOC4wt2vqjczSywlIE8mLNwilBQ9WaCutH6dHL5/K9vx+rjRh1AoofxbolVEHWPcAfBjAVuv0dFfBWJTjylJ2FirILfaWBOffQD47vr/nzOx0up4TWgyJUOx06isu6YfKrN0A9d4tfjXHWsO8zN6lTQYOhIWrKpqL0d96rdlSf3OxUZJpD2DIZRX4DCeM5O7xaHg9VcNknVz/9fPmp3HXSc4E5N56AeBSNhygO5zO41GvgHXerwZMQxa0c3yyqfZjLg/ySoWDlLcxDoQl95agkPgW9+t/GFy+Hst7I9ob0BGErnNLRM9DqayvjUfLzcQSRV0nBV11jdnzRnkYTtfCU6f+f7nsFNGbG9Vp0I760p5lD1vggxhYsnn14ZAGanWf4h7Kgf1EMr1RCa6rxOsI/q44ix0KMj9j2xP9cr+2mY39oaqA7S/ntTICMlt6fftcxWfwseb0Z7HJu+3HWWkAMqPoZYfVzuKNDJC6ZnsIK3dUzNcQdMjLqmp0hGChSOoo/Dh230cCwZXbXXGQzLyJNrllRIdvwtQMLC7TKeoN/GE4qLhSCMmrJkSkvOmnfGACxg9WqGwsKNJ65lR1IFuxI/ff4ic/Zw0qRmN730+Ma40WOPi/QsCd4Av9xCIoyvoPlSOJjhqv
 M7HYSUVn
 uMuGfkcJw8hXzog8E/leEAFyWY62h5yJzYBvbQJt9f0WlEBvS+Un23Ngg3ARSSsmTzoCNjc/X7Inq1exAL6b1tVuu+hsWmVTK9Z4zCbpS8/uRXl6OhZWUQ+n5KZovISIl9Qa1ZC1SAfEEE7UXvOuP1RN+vr1bqf4/H7GEV2SQ5tzE9XDVSg+9dm58g8heRNkpv/q1NJrZe7jDF8i3+wrBFR4/kva81ms8ahJI3pEzaaVg2e25X79JHJP+uclZq5NuQsI9DgQ9HahWrNshWw/MRpk02XFXthNeqAZD/t9xX8pHlLOWdlcpqJWZ/7x+lCiK2GkoDBaXPsthalJjcnE4ZyLRHKiQQqVsJylTsc18lLIuIDtNe5OCHDTIVTp8S6e2xmEm3zEMAF/9IlpFXsijlzvFsGnTFdB1Nirt6EvRofrk31C7FFsOK/c08X4MBFNT9NTOfmv5bad+y/xYj0H+P0DgJBRtgEWcN4aQMurHAghdsZgzJiHCdJcdjpENkvQvuJX3H3iLbkFawUrVNdZeC/S75sTdXhxSPvSZBOpWm91XNbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/13 03:40PM, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:
> 
> 
> commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
> [still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]
> 
> testcase: will-it-scale
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> parameters:
> 
> 	nr_task: 100%
> 	mode: process
> 	test: mmap2
> 	cpufreq_governor: performance
> 
> 

Thank you for the report.

48 threads on a 2 socket E5-2697 v2 looks to be 12 cores (24 threads)
per cpu (so x2), or exactly one mmap2 process per hyperthread.

Is this across all process counts and peaks at 48, or just 48?  Is this
across many runs?

My testing didn't produce anything like this.  I'll have a look into
this when I can, but there isn't anything obvious that sticks out as a
likely cause.

Thanks,
Liam


> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202605131554.92e7df6b-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
>   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> 
> commit: 
>   11e7f22f5e ("maple_tree: add cp_converged() helper")
>   280b792cac ("maple_tree: use maple copy node for mas_wr_split()")
> 
> 11e7f22f5e85058b 280b792cac62ddadca2935766ca 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>    6885401            -6.0%    6472359        will-it-scale.48.processes
>     143445            -6.0%     134840        will-it-scale.per_process_ops
>    6885401            -6.0%    6472359        will-it-scale.workload
>      14.44            -1.0       13.42        mpstat.cpu.all.usr%
>      17.55            -4.9%      16.69        turbostat.RAMWatt
>       4812 ±  4%     -11.4%       4266 ±  4%  vmstat.system.cs
>      17354 ±  3%      -9.2%      15750 ±  3%  sched_debug.cpu.nr_switches.avg
>      10034 ± 11%     -25.7%       7451 ± 16%  sched_debug.cpu.nr_switches.min
>     674817            -2.6%     657530        proc-vmstat.nr_active_anon
>    1446441            -1.2%    1429254        proc-vmstat.nr_file_pages
>     505185            -3.4%     487999        proc-vmstat.nr_shmem
>      50084            -3.1%      48542        proc-vmstat.nr_slab_unreclaimable
>     674817            -2.6%     657530        proc-vmstat.nr_zone_active_anon
>       0.37 ±  2%      -6.8%       0.35        perf-stat.i.MPKI
>   76468991            -1.9%   74991763        perf-stat.i.branch-misses
>      20.62 ±  2%      -2.6       18.02 ±  2%  perf-stat.i.cache-miss-rate%
>   34114286 ±  2%      -7.8%   31452733        perf-stat.i.cache-misses
>  1.675e+08            +6.0%  1.775e+08        perf-stat.i.cache-references
>       4800 ±  4%     -11.4%       4254 ±  4%  perf-stat.i.context-switches
>       1.55            +0.9%       1.57        perf-stat.i.cpi
>       4185 ±  2%      +8.3%       4534        perf-stat.i.cycles-between-cache-misses
>  9.151e+10            -1.0%  9.063e+10        perf-stat.i.instructions
>       0.37 ±  2%      -6.9%       0.35        perf-stat.overall.MPKI
>       0.39            -0.0        0.39        perf-stat.overall.branch-miss-rate%
>      20.35 ±  2%      -2.6       17.70 ±  2%  perf-stat.overall.cache-miss-rate%
>       1.55            +0.9%       1.57        perf-stat.overall.cpi
>       4163 ±  2%      +8.4%       4514        perf-stat.overall.cycles-between-cache-misses
>    4010019            +5.4%    4225135        perf-stat.overall.path-length
>   76161250            -1.9%   74678157        perf-stat.ps.branch-misses
>   34001097 ±  2%      -7.8%   31340807        perf-stat.ps.cache-misses
>  1.671e+08            +6.0%  1.771e+08        perf-stat.ps.cache-references
>       4780 ±  4%     -11.4%       4233 ±  4%  perf-stat.ps.context-switches
>   9.12e+10            -1.0%  9.033e+10        perf-stat.ps.instructions
>      19.40            -0.9       18.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>      15.57            -0.8       14.77        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       8.86            -0.5        8.39 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>      12.99            -0.5       12.52        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       8.50            -0.5        8.05 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
>       7.73            -0.4        7.32        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       8.46            -0.4        8.06        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       3.94            -0.4        3.56        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       6.70            -0.4        6.33        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
>       6.08            -0.4        5.71        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>      55.07            -0.4       54.71        perf-profile.calltrace.cycles-pp.__mmap
>       3.59            -0.3        3.25        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
>       3.72            -0.3        3.40        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__mmap
>       3.09            -0.3        2.79        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
>       4.14            -0.3        3.86        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
>       3.54            -0.3        3.27        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__munmap
>       3.22 ±  2%      -0.3        2.96 ±  2%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.57            -0.2        1.37        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       4.98            -0.2        4.81        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       0.88            -0.2        0.71        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff
>       3.78            -0.1        3.66        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       1.82 ±  2%      -0.1        1.72 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.65            -0.1        0.56        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
>       1.53            -0.1        1.45        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__munmap
>       1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
>       0.65            -0.1        0.58        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       1.46            -0.1        1.41        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__mmap
>       0.97 ±  2%      -0.1        0.91        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
>       1.36            -0.0        1.31        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
>       0.76            -0.0        0.72        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.69            -0.0        0.66        perf-profile.calltrace.cycles-pp.__filemap_get_folio_mpol.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
>       0.56            -0.0        0.53 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.__mmap
>       0.78 ±  2%      +0.0        0.83        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
>       0.72            +0.1        0.80        perf-profile.calltrace.cycles-pp.vma_link_file.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
>       1.24            +0.1        1.32        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_final.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
>       1.38            +0.1        1.48        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
>       2.39            +0.2        2.55        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
>      45.68            +0.2       45.93        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
>      45.52            +0.3       45.78        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>       0.82            +0.3        1.09        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       1.59            +0.3        1.89        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
>      44.54            +0.4       44.94        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>       7.12            +0.4        7.56        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
>       6.68            +0.5        7.16        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>      42.98            +0.5       43.52        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
>      41.67            +0.6       42.29        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       5.47            +0.6        6.10        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
>       0.00            +0.6        0.64 ±  8%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
>      32.58            +0.7       33.24        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
>       0.56 ±  2%      +0.7        1.27        perf-profile.calltrace.cycles-pp.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
>      34.16            +0.7       34.89        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       4.48            +0.7        5.20        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
>       0.00            +0.7        0.73        perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
>       4.32            +0.7        5.07        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
>       0.00            +0.8        0.75        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff
>      34.96            +0.8       35.72        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>      35.97            +0.8       36.73        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
>      35.80            +0.8       36.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>       0.00            +0.8        0.79        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap
>       0.79            +0.8        1.58        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.00            +0.8        0.80 ±  2%  perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +0.8        0.80        perf-profile.calltrace.cycles-pp.mas_prev_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>      35.04            +0.8       35.85        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
>       0.00            +0.8        0.81 ±  7%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
>       0.97            +0.8        1.80        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
>       0.73            +0.8        1.56        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
>       0.00            +0.9        0.95 ±  7%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
>       0.00            +1.1        1.09        perf-profile.calltrace.cycles-pp.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
>       5.22            +1.5        6.75        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
>       0.00            +1.5        1.55 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
>      19.61            -0.8       18.76        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
>      15.58            -0.8       14.79        perf-profile.children.cycles-pp.unmap_region
>       8.68            -0.8        7.93        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
>       8.88            -0.5        8.40 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap
>      13.03            -0.5       12.57        perf-profile.children.cycles-pp.__mmap_new_vma
>       8.56            -0.5        8.11 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_event
>       1.40            -0.4        0.98        perf-profile.children.cycles-pp.memcpy_orig
>       7.75            -0.4        7.34        perf-profile.children.cycles-pp.unmap_page_range
>       8.08            -0.4        7.67        perf-profile.children.cycles-pp.mas_wr_node_store
>       8.48            -0.4        8.07        perf-profile.children.cycles-pp.unmap_vmas
>       3.96            -0.4        3.58        perf-profile.children.cycles-pp.free_pgd_range
>       6.72            -0.4        6.35        perf-profile.children.cycles-pp.zap_pmd_range
>       6.16            -0.4        5.80        perf-profile.children.cycles-pp.free_pgtables
>       3.61            -0.3        3.26        perf-profile.children.cycles-pp.free_p4d_range
>       3.10            -0.3        2.80        perf-profile.children.cycles-pp.free_pud_range
>      54.52            -0.3       54.23        perf-profile.children.cycles-pp.__mmap
>       3.24 ±  2%      -0.3        2.98 ±  2%  perf-profile.children.cycles-pp.mas_preallocate
>       5.28            -0.2        5.06        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
>       2.34            -0.2        2.13        perf-profile.children.cycles-pp.mas_walk
>       5.00            -0.2        4.82        perf-profile.children.cycles-pp.mas_store_prealloc
>       3.46            -0.2        3.31        perf-profile.children.cycles-pp.entry_SYSCALL_64
>       3.06            -0.1        2.92        perf-profile.children.cycles-pp.syscall_return_via_sysret
>       1.95 ±  2%      -0.1        1.84        perf-profile.children.cycles-pp.__pcs_replace_empty_main
>       0.30 ±  3%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.mas_prev_setup
>       1.83 ±  2%      -0.1        1.74        perf-profile.children.cycles-pp.kmem_cache_free
>       1.40            -0.1        1.32        perf-profile.children.cycles-pp.__refill_objects_node
>       0.70            -0.1        0.62        perf-profile.children.cycles-pp.vma_merge_new_range
>       0.27 ±  2%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
>       0.57 ±  3%      -0.1        0.50 ±  3%  perf-profile.children.cycles-pp.mas_prev
>       0.23 ±  2%      -0.1        0.17 ±  4%  perf-profile.children.cycles-pp.mas_prev_range
>       0.38 ±  8%      -0.1        0.32 ±  3%  perf-profile.children.cycles-pp.strlen
>       0.43 ±  2%      -0.1        0.37        perf-profile.children.cycles-pp.fput
>       0.68 ±  2%      -0.1        0.62 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
>       0.62            -0.1        0.57 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
>       0.76 ±  2%      -0.0        0.71 ±  2%  perf-profile.children.cycles-pp.prepend_copy
>       0.79            -0.0        0.74 ±  4%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
>       0.99 ±  2%      -0.0        0.95 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
>       1.12            -0.0        1.07 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
>       0.36 ±  2%      -0.0        0.32 ±  2%  perf-profile.children.cycles-pp.security_mmap_file
>       0.38 ±  2%      -0.0        0.34        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
>       0.19 ±  3%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.__x64_sys_mmap
>       0.63            -0.0        0.60        perf-profile.children.cycles-pp.up_write
>       0.39            -0.0        0.36        perf-profile.children.cycles-pp.mas_wr_store_entry
>       0.11 ±  4%      -0.0        0.08        perf-profile.children.cycles-pp.get_align_mask
>       0.24 ±  3%      -0.0        0.22 ±  4%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
>       0.40            -0.0        0.38 ±  2%  perf-profile.children.cycles-pp.mas_next_range
>       0.30 ±  2%      -0.0        0.28 ±  3%  perf-profile.children.cycles-pp.can_vma_merge_right
>       0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
>       0.33 ±  2%      -0.0        0.31        perf-profile.children.cycles-pp.unmap_single_vma
>       0.21 ±  3%      -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.mmap_action_complete
>       0.34            -0.0        0.33 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
>       0.33            -0.0        0.32        perf-profile.children.cycles-pp.tlb_finish_mmu
>       0.09 ±  5%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
>       0.14 ±  3%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.get_mmap_base
>       0.06            -0.0        0.05        perf-profile.children.cycles-pp.barn_get_empty_sheaf
>       0.06            -0.0        0.05        perf-profile.children.cycles-pp.rcu_cblist_dequeue
>       0.08            +0.0        0.09        perf-profile.children.cycles-pp.mas_nomem
>       0.06            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.unlink_file_vma_batch_init
>       0.31            +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
>       0.13 ±  3%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.vm_area_free
>       0.11            +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.build_id_parse_nofault
>       0.14 ±  5%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.userfaultfd_unmap_prep
>       0.48            +0.0        0.50        perf-profile.children.cycles-pp.hrtimer_interrupt
>       0.20 ±  3%      +0.0        0.22 ±  3%  perf-profile.children.cycles-pp.is_vmalloc_addr
>       0.46 ±  2%      +0.0        0.48        perf-profile.children.cycles-pp.filemap_get_entry
>       0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.vma_wants_writenotify
>       0.13 ±  7%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.mmap_region
>       0.11 ±  4%      +0.0        0.14 ±  5%  perf-profile.children.cycles-pp.mas_next_setup
>       0.27 ±  3%      +0.0        0.31 ±  4%  perf-profile.children.cycles-pp.__thp_vma_allowable_orders
>       0.31 ±  3%      +0.0        0.35 ±  3%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
>       0.13 ±  3%      +0.0        0.18 ±  4%  perf-profile.children.cycles-pp.rb_next
>       0.08 ±  6%      +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.ksm_vma_flags
>       0.47 ±  3%      +0.1        0.53 ±  3%  perf-profile.children.cycles-pp.down_write
>       0.35 ±  3%      +0.1        0.42 ±  3%  perf-profile.children.cycles-pp.vma_interval_tree_remove
>       0.74            +0.1        0.82        perf-profile.children.cycles-pp.vma_link_file
>       1.24            +0.1        1.33        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
>       2.44            +0.1        2.58        perf-profile.children.cycles-pp.mas_empty_area_rev
>       0.66 ±  5%      +0.2        0.89        perf-profile.children.cycles-pp.mas_wr_walk_descend
>       1.62            +0.3        1.90        perf-profile.children.cycles-pp.mas_rev_awalk
>       1.71            +0.3        2.04        perf-profile.children.cycles-pp.mas_wr_store_type
>      44.55            +0.4       44.96        perf-profile.children.cycles-pp.ksys_mmap_pgoff
>       7.13            +0.4        7.56        perf-profile.children.cycles-pp.__get_unmapped_area
>       6.69            +0.5        7.17        perf-profile.children.cycles-pp.shmem_get_unmapped_area
>      43.01            +0.5       43.55        perf-profile.children.cycles-pp.vm_mmap_pgoff
>       5.53            +0.6        6.14        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
>      41.71            +0.6       42.34        perf-profile.children.cycles-pp.do_mmap
>      32.60            +0.7       33.26        perf-profile.children.cycles-pp.do_vmi_align_munmap
>       5.05            +0.7        5.75        perf-profile.children.cycles-pp.mas_find
>      34.19            +0.7       34.90        perf-profile.children.cycles-pp.do_vmi_munmap
>       4.49            +0.7        5.21        perf-profile.children.cycles-pp.vm_unmapped_area
>       4.34            +0.7        5.09        perf-profile.children.cycles-pp.unmapped_area_topdown
>      34.99            +0.8       35.74        perf-profile.children.cycles-pp.__vm_munmap
>      35.06            +0.8       35.87        perf-profile.children.cycles-pp.__x64_sys_munmap
>       0.00            +1.0        0.99        perf-profile.children.cycles-pp.mas_ascend
>      81.44            +1.0       82.44        perf-profile.children.cycles-pp.do_syscall_64
>      81.77            +1.0       82.79        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
>       5.30            +1.5        6.82        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
>       0.00            +1.6        1.58        perf-profile.children.cycles-pp.mas_next_node
>       1.84            +1.6        3.48        perf-profile.children.cycles-pp.mas_next_slot
>       1.75            +2.0        3.72        perf-profile.children.cycles-pp.mas_prev_slot
>       0.00            +2.0        2.01        perf-profile.children.cycles-pp.mas_prev_node
>       8.62            -0.8        7.87        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
>       1.32            -0.4        0.91        perf-profile.self.cycles-pp.memcpy_orig
>       4.40            -0.3        4.09        perf-profile.self.cycles-pp.zap_pmd_range
>       2.96            -0.3        2.68        perf-profile.self.cycles-pp.free_pud_range
>       2.19            -0.2        1.99        perf-profile.self.cycles-pp.mas_walk
>       3.05            -0.2        2.89        perf-profile.self.cycles-pp.syscall_return_via_sysret
>       3.07            -0.1        2.94        perf-profile.self.cycles-pp.entry_SYSCALL_64
>       0.38 ±  7%      -0.1        0.27 ±  3%  perf-profile.self.cycles-pp.current_time
>       0.62            -0.1        0.52        perf-profile.self.cycles-pp.do_vmi_align_munmap
>       0.80            -0.1        0.71 ±  5%  perf-profile.self.cycles-pp.do_syscall_64
>       0.25 ±  3%      -0.1        0.17 ±  4%  perf-profile.self.cycles-pp.mas_prev_setup
>       0.76 ±  5%      -0.1        0.68 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap_event
>       0.24            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
>       0.52 ±  6%      -0.1        0.46 ±  6%  perf-profile.self.cycles-pp.kmem_cache_free
>       0.80            -0.1        0.73 ±  2%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
>       0.73            -0.1        0.66        perf-profile.self.cycles-pp.__mmap_new_vma
>       0.36 ±  8%      -0.1        0.30 ±  3%  perf-profile.self.cycles-pp.strlen
>       0.40 ±  2%      -0.1        0.34        perf-profile.self.cycles-pp.fput
>       1.03            -0.1        0.98        perf-profile.self.cycles-pp.__refill_objects_node
>       0.36 ±  2%      -0.1        0.30 ±  2%  perf-profile.self.cycles-pp.vm_mmap_pgoff
>       0.68 ±  3%      -0.1        0.62 ±  3%  perf-profile.self.cycles-pp.unmapped_area_topdown
>       0.77 ±  2%      -0.1        0.71 ±  4%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
>       0.34            -0.1        0.29        perf-profile.self.cycles-pp.__build_id_parse
>       0.53            -0.0        0.48        perf-profile.self.cycles-pp.__vma_start_exclude_readers
>       0.64 ±  2%      -0.0        0.59        perf-profile.self.cycles-pp.ksys_mmap_pgoff
>       0.28 ±  2%      -0.0        0.23        perf-profile.self.cycles-pp.mas_next_range
>       0.30 ±  3%      -0.0        0.26 ±  6%  perf-profile.self.cycles-pp.vma_merge_new_range
>       0.24            -0.0        0.20 ±  3%  perf-profile.self.cycles-pp.__filemap_get_folio_mpol
>       0.60            -0.0        0.56        perf-profile.self.cycles-pp.mas_preallocate
>       0.64            -0.0        0.60 ±  5%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
>       0.71 ±  2%      -0.0        0.67 ±  2%  perf-profile.self.cycles-pp.mas_empty_area_rev
>       0.37 ±  2%      -0.0        0.34        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
>       0.18 ±  4%      -0.0        0.15 ±  4%  perf-profile.self.cycles-pp.do_vmi_munmap
>       0.33 ±  3%      -0.0        0.30 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
>       0.25 ±  3%      -0.0        0.22 ±  3%  perf-profile.self.cycles-pp.__get_unmapped_area
>       0.10 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.get_align_mask
>       0.16 ±  4%      -0.0        0.13 ±  4%  perf-profile.self.cycles-pp.security_mmap_file
>       0.34 ±  2%      -0.0        0.32        perf-profile.self.cycles-pp.mas_wr_store_entry
>       0.59 ±  2%      -0.0        0.56        perf-profile.self.cycles-pp.up_write
>       0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
>       0.30 ±  2%      -0.0        0.28        perf-profile.self.cycles-pp.perf_event_mmap
>       0.21 ±  3%      -0.0        0.19 ±  4%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
>       0.18 ±  2%      -0.0        0.16 ±  3%  perf-profile.self.cycles-pp.mmap_action_complete
>       0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.khugepaged_enter_vma
>       0.30            -0.0        0.28 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
>       0.15 ±  4%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
>       0.06            -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
>       0.18 ±  3%      -0.0        0.16 ±  4%  perf-profile.self.cycles-pp.unmap_single_vma
>       0.31            -0.0        0.29        perf-profile.self.cycles-pp.tlb_finish_mmu
>       0.11 ±  3%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.vm_unmapped_area
>       0.33            -0.0        0.31 ±  2%  perf-profile.self.cycles-pp.tlb_gather_mmu
>       0.14 ±  3%      -0.0        0.12 ±  5%  perf-profile.self.cycles-pp.__x64_sys_mmap
>       0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_nomem
>       0.05            +0.0        0.06 ±  6%  perf-profile.self.cycles-pp.unlink_file_vma_batch_init
>       0.06            +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__pi_memcpy
>       0.28            +0.0        0.30 ±  2%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
>       0.12 ±  5%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.userfaultfd_unmap_prep
>       0.15 ±  6%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.freader_get_folio
>       0.23 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.filemap_get_entry
>       0.19 ±  2%      +0.0        0.22 ±  4%  perf-profile.self.cycles-pp.remove_vma
>       0.24 ±  2%      +0.0        0.26        perf-profile.self.cycles-pp.vma_link_file
>       0.07 ±  6%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp.vma_wants_writenotify
>       0.12 ±  8%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.mmap_region
>       0.23 ±  4%      +0.0        0.26 ±  2%  perf-profile.self.cycles-pp.vma_interval_tree_remove
>       0.10 ±  4%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.mas_next_setup
>       0.26 ±  2%      +0.0        0.29 ±  4%  perf-profile.self.cycles-pp.__thp_vma_allowable_orders
>       0.11 ±  3%      +0.0        0.15 ±  6%  perf-profile.self.cycles-pp.rb_next
>       0.27            +0.0        0.30        perf-profile.self.cycles-pp.freader_fetch
>       0.29 ±  3%      +0.0        0.33 ±  4%  perf-profile.self.cycles-pp.__x86_indirect_thunk_rax
>       0.45 ±  2%      +0.0        0.49 ±  4%  perf-profile.self.cycles-pp.down_write_killable
>       0.33 ±  2%      +0.0        0.38 ±  3%  perf-profile.self.cycles-pp.__vma_start_write
>       1.55            +0.1        1.60        perf-profile.self.cycles-pp.mas_store_gfp
>       0.07 ±  7%      +0.1        0.12 ±  5%  perf-profile.self.cycles-pp.ksm_vma_flags
>       0.26            +0.1        0.32        perf-profile.self.cycles-pp.shmem_mmap_prepare
>       0.44 ±  4%      +0.1        0.50 ±  3%  perf-profile.self.cycles-pp.down_write
>       1.00            +0.1        1.10        perf-profile.self.cycles-pp.mas_wr_store_type
>       1.69            +0.1        1.79        perf-profile.self.cycles-pp.mas_next_slot
>       0.65            +0.1        0.75 ±  2%  perf-profile.self.cycles-pp.mas_store_prealloc
>       1.10            +0.1        1.23        perf-profile.self.cycles-pp.mas_find
>       0.62 ±  5%      +0.2        0.84        perf-profile.self.cycles-pp.mas_wr_walk_descend
>       1.16            +0.6        1.80        perf-profile.self.cycles-pp.mas_rev_awalk
>       0.00            +0.9        0.91        perf-profile.self.cycles-pp.mas_ascend
>       0.00            +1.2        1.18        perf-profile.self.cycles-pp.mas_next_node
>       0.00            +1.3        1.27 ±  2%  perf-profile.self.cycles-pp.mas_prev_node
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

