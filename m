Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4E1ACAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87668E000A; Mon,  8 Sep 2025 08:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36988E0003; Mon,  8 Sep 2025 08:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25168E000A; Mon,  8 Sep 2025 08:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9938E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:15:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D84FC0127
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:15:18 +0000 (UTC)
X-FDA: 83865977916.15.3CEF876
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8DBD2140015
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:15:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757333716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jWdYV/7I+JjDHZWui78RkH0ZKSkniqiC7z91rtvhp4Q=;
	b=vtkRnMtoheR5BGrGCw9513cwXsxbwf+kHEDp0WuIxfYiRSiK4G46Vr/rjuswNsrGCAAN1s
	zEYCMAdHPhOBfs6Ee8bS3UkalH4AYKJUo3XN0Ul7+KjBvO+nOVaWQnkbsKQwUomXPqMrHN
	8efFC4fgL2X2C/18S9KENUtBC20+4Bw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757333716; a=rsa-sha256;
	cv=none;
	b=gEi8zznXu4dw6CHJK670M5lTFS/UqoFk5CuxrTCpK4G82aDlvEG818NWV3Dr0rUpjzU2g4
	+bwdu75o7Hezw9Dlz0ZlyuqHQXeMs84I7pkyd3a8hnSNC0sg3erg3zViDlna58cis+0XG4
	Xg3h4GaW8e0QBjU2Sru9509cnrBW+So=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cL5VW2CxrzYl3PR;
	Mon,  8 Sep 2025 20:14:43 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 8 Sep
 2025 20:15:08 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 8 Sep
 2025 20:15:07 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <lorenzo.stoakes@oracle.com>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
Date: Mon, 8 Sep 2025 20:15:03 +0800
Message-ID: <20250908121503.20960-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aLmmrvPb6mFHzqCc@tiehlicka>
References: <aLmmrvPb6mFHzqCc@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 8DBD2140015
X-Rspam-User: 
X-Stat-Signature: wa9hnd4drd7ita3bts5fz51gshrbayaq
X-Rspamd-Server: rspam09
X-HE-Tag: 1757333715-100773
X-HE-Meta: U2FsdGVkX18l5diqrIdIQqI0dfTTMNKDfTD7HsyyWvqZROdNd1pHI80Ie5rw+n6nJL03M/iw5G2DDnjEAGr86604R3cVBi3H6l4z7ER6zpyc+DPUh/35Tef0sxqHDlBv3oAbPVbaPhb9nVFowy4VsG24W8kL5NMh3WFVLeiocvOOARzJSyJlb5WrHeN4pQuT/+CIPDj7RCND+6gOLTxU106YhC1KAJN779e2e2CMNA2UQ+FWMJ/ki+585SvOfOPdLDS+dW6qj0tUr281kYm6eZjE629Kbq2P+faNOuhDrl+Lr9lBVzRVJmDg9DN6hCb24K8qQKaBBZUwNsvMPtzWbqwDUCeu5mnO5ID7G8sXYQG2hk2F1iR4hx6EyGd4LPvsB1qJo34nApIBrZPC3gh4uZw57WM6FwtOFo7enH2QghxUXL0QTCZUnTLLutEUZ2UF8MjL1HGvyf5FJ/rTfOvDsM+gPrmwgP/qgE9A+y40pnqnSyBUixikt29II9uHsjIRZ7TQVx/aFCgJanXrWqcay4h9NX+mjCJUtMrf1pjzXsKmR5MAAsBEA+8fdyXVndLfQU6FS6VDqurC5//mmMOq794kWeVzUtcK34sBQTgZivDc8yYdqXQoFz4P5F8b5I2iO2ZRl27pcOsIO/EAyGKfYFs2BUJipq+I0497oRj061u882Cd8H9qmARidTH8MyYSoXo4Cm3c2ltDQwNU7NiCPYkFXz6eyXrAxb0CLp4CP7yNDl2m7IyjKcrlzEcuUXHfx1ojEGRm6NeseaiEAcw9kGP+JskKUXB/kvCtByRCkLfS/uRXfygnK4lzqqig23012q2k6X5jD8/1rovivgj/+tp1/4vZBsSpJZtvj8ezC9kserhh0amxNxW1z8U+N7ZkEMKLwbgoVMhfyIwN4Ce5yKf9+QmXi+ClWXDnRdIy1dQCWTwQh1sIYhzwsNX7+9cKJRr6vEdU3kQB7ltE/yG
 vRp4dSrj
 L+L88gp3y9LAJojHzBODwGS05d21/W6QiI4iKvEs0AJMl96weKa5DiZiIBAdd3XHRoKhskn0C9MFRdXr8ko6iW7rjMq+IanRDuQ58uDr2TKqB7UT1y/XjHxy5FgCwi3BTjx3HsPhdpxcAofonWLk8WpgjzCjFjEneUgEz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the perf report is too complicated, let us summarize the key points
from the report.

Conclusion:
Compared to the version without the patch, the total time reduced by
exit_mmap plus reaper work is roughly equal to the reduction in total
pte spinlock waiting time.

With the patch applied, for certain functions, the reaper performs
more times, such as folio_remove_rmap_ptes, but the time spent by
exit_mmap on folio_remove_rmap_ptes decreases accordingly.

Summary of measurements (ms):
+---------------------------------------------------------------+
| Category                      | Applying patch | Without patch|
+-------------------------------+---------------+--------------+
| Total running time            |    132.6      |    167.1      |
|   (exit_mmap + reaper work)   |  72.4 + 60.2  |  90.7 + 76.4  |
+-------------------------------+---------------+--------------+
| Time waiting for pte spinlock |     1.0       |    33.1      |
|   (exit_mmap + reaper work)   |   0.4 + 0.6   |  10.0 + 23.1 |
+-------------------------------+---------------+--------------+
| folio_remove_rmap_ptes time   |    42.0       |    41.3      |
|   (exit_mmap + reaper work)   |  18.4 + 23.6  |  22.4 + 18.9 |
+---------------------------------------------------------------+

Report without patch:

Arch: arm64
Event: cpu-clock (type 1, config 0)
Samples: 6355
Event count: 90781175

do_exit
 |--93.81%-- mmput
 |    |--99.46%-- exit_mmap
 |    |    |--76.74%-- unmap_vmas
 |    |    |    |--9.14%-- [hit in function]
 |    |    |    |--34.25%-- tlb_flush_mmu
 |    |    |    |--31.13%-- folio_remove_rmap_ptes
 |    |    |    |--15.04%-- __pte_offset_map_lock
 |    |    |    |--5.43%-- free_swap_and_cache_nr
 |    |    |    |--1.80%-- _raw_spin_lock
 |    |    |    |--1.19%-- folio_mark_accessed
 |    |    |    |--0.84%-- __tlb_remove_folio_pages
 |    |    |    |--0.37%-- mas_find
 |    |    |    |--0.37%-- percpu_counter_add_batch
 |    |    |    |--0.20%-- __mod_lruvec_page_state
 |    |    |    |--0.13%-- f2fs_dirty_data_folio
 |    |    |    |--0.04%-- __rcu_read_unlock
 |    |    |    |--0.04%-- tlb_flush_rmaps
 |    |    |    |          folio_remove_rmap_ptes
 |    |    |     --0.02%-- folio_mark_dirty
 |    |    |--12.72%-- free_pgtables
 |    |    |    |--0.53%-- [hit in function]
 |    |    |    |--35.81%-- unlink_file_vma
 |    |    |    |--28.38%-- down_write
 |    |    |    |--17.11%-- unlink_anon_vmas
 |    |    |    |--5.70%-- anon_vma_interval_tree_remove
 |    |    |    |--3.71%-- mas_find
 |    |    |    |--3.18%-- up_write
 |    |    |    |--2.25%-- free_pgd_range
 |    |    |    |--1.19%-- vma_interval_tree_remove
 |    |    |    |--1.06%-- kmem_cache_free
 |    |    |--2.65%-- folio_remove_rmap_ptes
 |    |    |--2.50%-- __vm_area_free
 |    |    |    |--11.49%-- [hit in function]
 |    |    |    |--81.08%-- kmem_cache_free
 |    |    |    |--4.05%-- _raw_spin_unlock_irqrestore
 |    |    |     --3.38%-- anon_vma_name_free
 |    |    |--1.03%-- folio_mark_accessed
 |    |    |--0.96%-- __tlb_remove_folio_pages
 |    |    |--0.54%-- mas_find
 |    |    |--0.46%-- tlb_finish_mmu
 |    |    |    |--96.30%-- free_pages_and_swap_cache
 |    |    |    |    |--80.77%-- release_pages
 |    |    |--0.44%-- kmem_cache_free
 |    |    |--0.39%-- __pte_offset_map_lock
 |    |    |--0.30%-- task_work_add
 |    |    |--0.19%-- __rcu_read_unlock
 |    |    |--0.17%-- fput
 |    |    |--0.13%-- __mt_destroy
 |    |    |          mt_destroy_walk
 |    |    |--0.10%-- down_write
 |    |    |--0.07%-- unlink_file_vma
 |    |    |--0.05%-- percpu_counter_add_batch
 |    |    |--0.02%-- free_swap_and_cache_nr
 |    |    |--0.02%-- flush_tlb_batched_pending
 |    |    |--0.02%-- uprobe_munmap
 |    |    |--0.02%-- _raw_spin_unlock
 |    |    |--0.02%-- unlink_anon_vmas
 |    |     --0.02%-- up_write
 |    |--0.40%-- fput
 |    |--0.10%-- mas_find
 |    |--0.02%-- kgsl_gpumem_vm_close
 |     --0.02%-- __vm_area_free
 |--5.19%-- task_work_run
 |--0.42%-- exit_files
 |          put_files_struct
 |--0.35%-- exit_task_namespaces

Children  Self      Command            Symbol
90752605  0         #APM_light-weig    do_exit
90752605  0         #APM_light-weig    get_signal
85138600  0         #APM_light-weig    __mmput
84681480  399980    #APM_light-weig    exit_mmap
64982465  5942560   #APM_light-weig    unmap_vmas
22598870  1599920   #APM_light-weig    free_pages_and_swap_cache
22498875  3314120   #APM_light-weig    folio_remove_rmap_ptes
10985165  1442785   #APM_light-weig    _raw_spin_lock
10770890  57140     #APM_light-weig    free_pgtables
10099495  399980    #APM_light-weig    __pte_offset_map_lock
8199590   1285650   #APM_light-weig    folios_put_refs
4756905   685680    #APM_light-weig    free_unref_page_list
4714050   14285     #APM_light-weig    task_work_run
4671195   199990    #APM_light-weig    ____fput
4085510   214275    #APM_light-weig    __fput
3914090   57140     #APM_light-weig    unlink_file_vma
3542680   28570     #APM_light-weig    free_swap_and_cache_nr
3214125   2114180   #APM_light-weig    free_unref_folios
3142700   14285     #APM_light-weig    swap_entry_range_free
2828430   2828430   #APM_light-weig    kmem_cache_free
2714150   528545    #APM_light-weig    zram_free_page
2528445   114280    #APM_light-weig    zram_slot_free_notify


Arch: arm64
Event: cpu-clock (type 1, config 0)
Samples: 5353
Event count: 76467605

kthread
|--99.57%-- oom_reaper
|    |--0.28%-- [hit in function]
|    |--73.58%-- unmap_page_range
|    |    |--8.67%-- [hit in function]
|    |    |--41.59%-- __pte_offset_map_lock
|    |    |--29.47%-- folio_remove_rmap_ptes
|    |    |--16.11%-- tlb_flush_mmu
|    |    |           free_pages_and_swap_cache
|    |    |    |--9.49%-- [hit in function]
|    |    |--1.66%-- folio_mark_accessed
|    |    |--0.74%-- free_swap_and_cache_nr
|    |    |--0.69%-- __tlb_remove_folio_pages
|    |    |--0.41%-- __mod_lruvec_page_state
|    |    |--0.33%-- _raw_spin_lock
|    |    |--0.28%-- percpu_counter_add_batch
|    |    |--0.03%-- tlb_flush_mmu_tlbonly
|    |     --0.03%-- __rcu_read_unlock
|    |--19.94%-- tlb_finish_mmu
|    |    |--23.24%-- [hit in function]
|    |    |--76.39%-- free_pages_and_swap_cache
|    |    |--0.28%-- free_pages
|    |     --0.09%-- release_pages
|    |--3.21%-- folio_remove_rmap_ptes
|    |--1.16%-- __tlb_remove_folio_pages
|    |--1.16%-- folio_mark_accessed
|    |--0.36%-- __pte_offset_map_lock
|    |--0.28%-- mas_find
|     --0.02%-- __rcu_read_unlock
|--0.17%-- tlb_finish_mmu
|--0.15%-- mas_find
|--0.06%-- memset
|--0.04%-- unmap_page_range
 --0.02%-- tlb_gather_mmu

Children  Self      Command    Symbol
76467605  0         unknown    kthread
76139050  214275    unknown    oom_reaper
56054340  4885470   unknown    unmap_page_range
23570250  385695    unknown    __pte_offset_map_lock
23341690  257130    unknown    _raw_spin_lock
23113130  23113130  unknown    queued_spin_lock_slowpath
20627540  1371360   unknown    free_pages_and_swap_cache
19027620  614255    unknown    release_pages
18956195  3399830   unknown    folio_remove_rmap_ptes
15313520  3656960   unknown    tlb_finish_mmu
11799410  11785125  unknown    cgroup_rstat_updated
11285150  11256580  unknown    _raw_spin_unlock_irqrestore
9028120   0         unknown    tlb_flush_mmu
8613855   1342790   unknown    folios_put_refs
5442585   485690    unknown    free_unref_page_list
4299785   1614205   unknown    free_unref_folios
3385545   1299935   unknown    free_unref_page_commit


Report with patch:

Arch: arm64
Event: cpu-clock (type 1, config 0)
Samples: 5075
Event count: 72496375

|--99.98%-- do_notify_resume
|    |--92.63%-- mmput
|    |           __mmput
|    |    |--99.57%-- exit_mmap
|    |    |    |--0.79%-- [hit in function]
|    |    |    |--76.43%-- unmap_vmas
|    |    |    |    |--8.39%-- [hit in function]
|    |    |    |    |--42.80%-- tlb_flush_mmu
|    |    |    |    |           free_pages_and_swap_cache
|    |    |    |    |--34.08%-- folio_remove_rmap_ptes
|    |    |    |    |--9.51%-- free_swap_and_cache_nr
|    |    |    |    |--2.40%-- _raw_spin_lock
|    |    |    |    |--0.75%-- __tlb_remove_folio_pages
|    |    |    |    |--0.48%-- mas_find
|    |    |    |    |--0.36%-- __pte_offset_map_lock
|    |    |    |    |--0.34%-- percpu_counter_add_batch
|    |    |    |    |--0.34%-- folio_mark_accessed
|    |    |    |    |--0.20%-- __mod_lruvec_page_state
|    |    |    |    |--0.17%-- f2fs_dirty_data_folio
|    |    |    |    |--0.11%-- __rcu_read_unlock
|    |    |    |    |--0.03%-- _raw_spin_unlock
|    |    |    |    |--0.03%-- tlb_flush_rmaps
|    |    |    |     --0.03%-- uprobe_munmap
|    |    |    |--14.19%-- free_pgtables
|    |    |    |--2.52%-- __vm_area_free
|    |    |    |--1.52%-- folio_remove_rmap_ptes
|    |    |    |--0.83%-- mas_find
|    |    |    |--0.81%-- __tlb_remove_folio_pages
|    |    |    |--0.77%-- folio_mark_accessed
|    |    |    |--0.41%-- kmem_cache_free
|    |    |    |--0.36%-- task_work_add
|    |    |    |--0.34%-- fput
|    |    |    |--0.32%-- __pte_offset_map_lock
|    |    |    |--0.15%-- __rcu_read_unlock
|    |    |    |--0.15%-- __mt_destroy
|    |    |    |--0.09%-- unlink_file_vma
|    |    |    |--0.06%-- down_write
|    |    |    |--0.04%-- lookup_swap_cgroup_id
|    |    |    |--0.04%-- uprobe_munmap
|    |    |    |--0.04%-- percpu_counter_add_batch
|    |    |    |--0.04%-- up_write
|    |    |    |--0.02%-- flush_tlb_batched_pending
|    |    |    |--0.02%-- _raw_spin_unlock
|    |    |    |--0.02%-- unlink_anon_vmas
|    |    |     --0.02%-- tlb_finish_mmu
|    |    |               free_unref_page
|    |    |--0.38%-- fput
|    |     --0.04%-- mas_find
|    |--6.21%-- task_work_run
|    |--0.47%-- exit_task_namespaces
|    |--0.16%-- ____fput
|     --0.04%-- mm_update_next_owner

Children  Self      Command     Symbol
72482090  0         #APM6-IO    get_signal
67139500  0         #APM6-IO    __mmput
67139500  0         #APM6-IO    mmput
66853800  528545    #APM6-IO    exit_mmap
51097445  4285500   #APM6-IO    unmap_vmas
21870335  0         #APM6-IO    tlb_flush_mmu
21870335  1371360   #APM6-IO    free_pages_and_swap_cache
20384695  485690    #APM6-IO    release_pages
18427650  1814195   #APM6-IO    folio_remove_rmap_ptes
13799310  13785025  #APM6-IO    cgroup_rstat_updated
12842215  12842215  #APM6-IO    _raw_spin_unlock_irqrestore
9485240   14285     #APM6-IO    free_pgtables
7785325   428550    #APM6-IO    folios_put_refs
4899755   642825    #APM6-IO    free_unref_page_list
4856900   42855     #APM6-IO    free_swap_and_cache_nr
4499775   14285     #APM6-IO    task_work_run
4385495   114280    #APM6-IO    ____fput
3971230   714250    #APM6-IO    zram_free_page
3899805   14285     #APM6-IO    swap_entry_range_free
3785525   185705    #APM6-IO    zram_slot_free_notify
399980    399980    #APM6-IO    __pte_offset_map_lock

Arch: arm64
Event: cpu-clock (type 1, config 0)
Samples: 4221
Event count: 60296985

Children  Self      Command  Pid  Tid  Shared Object      Symbol

kthread
|--99.53%-- oom_reaper
|    |--0.17%-- [hit in function]
|    |--55.77%-- unmap_page_range
|    |    |--20.49%-- [hit in function]
|    |    |--58.30%-- folio_remove_rmap_ptes
|    |    |--11.48%-- tlb_flush_mmu
|    |    |--3.33%-- folio_mark_accessed
|    |    |--2.65%-- __tlb_remove_folio_pages
|    |    |--1.37%-- _raw_spin_lock
|    |    |--0.68%-- __mod_lruvec_page_state
|    |    |--0.51%-- __pte_offset_map_lock
|    |    |--0.43%-- percpu_counter_add_batch
|    |    |--0.30%-- __rcu_read_unlock
|    |    |--0.13%-- free_swap_and_cache_nr
|    |    |--0.09%-- tlb_flush_mmu_tlbonly
|    |     --0.04%-- __rcu_read_lock
|    |--32.21%-- tlb_finish_mmu
|    |    |--88.69%-- free_pages_and_swap_cache
|    |--6.93%-- folio_remove_rmap_ptes
|    |--1.90%-- __tlb_remove_folio_pages
|    |--1.55%-- folio_mark_accessed
|    |--0.69%-- __pte_offset_map_lock
|    |--0.45%-- mas_find_rev
|    |    |--21.05%-- [hit in function]
|    |     --78.95%-- mas_prev_slot
|    |--0.12%-- mas_prev_slot
|    |--0.10%-- free_pages_and_swap_cache
|    |--0.07%-- __rcu_read_unlock
|    |--0.02%-- percpu_counter_add_batch
|     --0.02%-- lookup_swap_cgroup_id
|--0.12%-- mas_find_rev
|--0.12%-- unmap_page_range
|--0.12%-- tlb_finish_mmu
|--0.09%-- tlb_gather_mmu
 --0.02%-- memset

Children  Self      Command    Symbol
60296985  0         unknown    kthread
60011285  99995     unknown    oom_reaper
33541180  6928225   unknown    unmap_page_range
23670245  5414015   unknown    folio_remove_rmap_ptes
21027520  1757055   unknown    free_pages_and_swap_cache
19399030  2171320   unknown    tlb_finish_mmu
18970480  885670    unknown    release_pages
13785025  13785025  unknown    cgroup_rstat_updated
11442285  11442285  unknown    _raw_spin_unlock_irqrestore
7928175   1871335   unknown    folios_put_refs
4742620   371410    unknown    free_unref_page_list
3928375   942810    unknown    free_unref_folios
3842665   14285     unknown    tlb_flush_mmu
3385545   728535    unknown    free_unref_page_commit
585685    571400    unknown    __pte_offset_map_lock


