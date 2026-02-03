Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14246E83040
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D42A6B008C; Mon,  2 Feb 2026 21:46:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68B1D6B0092; Mon,  2 Feb 2026 21:46:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 580956B0093; Mon,  2 Feb 2026 21:46:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 406DC6B008C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:46:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3B96C092A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:08 +0000 (UTC)
X-FDA: 84401606016.01.0F0899C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 49F4120009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1yYY5PHX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3sw/j9BBG4Dh6oS82wo8IAcwV1r7YJhacyoqA3CCk0=;
	b=bYLhM0fmhfoeUHwbGFbwiDFmrJoGE5D3AbVxR/Wl08ZfoC1D2EX5hdWR+Gy0ZUrvpMOzaP
	225aI6XXtCO+vmGxFsE2sHMphObXs5cRprBFGSSgne7bKW4z1URT97jEHgu3+mtkLDNcPG
	8YD70t1z3fMU9to73Upys4gcSEJJcyE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1yYY5PHX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086767; a=rsa-sha256;
	cv=none;
	b=hllU8EfU5HCHKtWdMuyPfwYfurj5x/SumjwEp6f3k8jMc2Czpl1KkILlKC24vZ0kozAzZ0
	duVJhRhYXDNhdEio9pNbCN31m/95qvhyj/7/9lmClrK01C253pBxgwq4jlmRtwWbTw0hbJ
	1jGRLqIt3tUfhZjT6h3iXFOG/2L+zIw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6905743CA5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36314C116C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086766;
	bh=qczuMcs6qhk0HRWP9tZF2u20wbmhzTSkmZciXONCXA4=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=1yYY5PHXqbdzscvmTv9hNiphE27zx8egPyQCjBiwPLrNOwvjZL270dTrvHPAia6kn
	 kEYGh7QWFZ9NG+0xveyYi0VNkDrY9TQItu5/Gcr+cWbKT8KtsVEDgKH+WvZLnjufUz
	 fxW6gepuAQdnx9x0dRb6bBxSi/w2HaNqAOQadnok=
Date: Mon, 2 Feb 2026 18:46:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status (6.19-rc1)
Message-Id: <20260202184605.50d382bd15bce039f928e18a@linux-foundation.org>
In-Reply-To: <20260131151122.32fd05d3b8460c614f26f195@linux-foundation.org>
References: <20260131150936.3b0a5b3f45f6ea5f9930099d@linux-foundation.org>
	<20260131151122.32fd05d3b8460c614f26f195@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 73tfa7cyc6ymxwoatgsk4r7aeq48zfqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 49F4120009
X-HE-Tag: 1770086767-455052
X-HE-Meta: U2FsdGVkX186kO6NTBaIZsJkKX2ozcIiVEYh12F+1k4XvGe5vAAJRrTDc+LFlIhtbNrDUjq08fPMyLRXSB0CN7TN0omNSoqFrhXE4nfqERcCjDmurKVQRPV1NQj8evpMIaEz+TWVsMv4WSwngFLE8YlyWlScV587aL9K3+dqRfCVS2b0bUS7S3Ruv4Nwd7tURAUTsb6y6OgBGA4nI4v0wyXgiWbs7eXA3rfHykJcIeNnCr5ZtH+HT5kD+NMXFTquhTjZIFsdtgkZqMn9rwTk5djg7nS0yI05atH9Z4lXxWBbKJm4IaijsbqIdJozc2ZL5lJl+6K1Mo50F8M9hAazUs96Tf81NBEvlW55+QyZ10Q8leHcKXrqw5l6IgBuewnh3eFTXOEJ6NpVDqR04w7p1k7Zynm55hJ4LZ5VXImWtnwk+X4XDzXbNAVUiJf9MbCpnZ9Sb1G0PSjfY+aCbYlDxVQdAAOXkOHlnYI5zI/YMjoPhjBH/yDz6KaGXhHKxUDn+4YEHl2dO2T1t8jkQltakjLK32RdntP4urBTVPQILr5XUslc4OYJu1s14TYTM+0tYvp8zkH6AoPGmBlEDZO+Fs9ekAz79vB8uYgY0m3q8mm7wG5EnPZn/5khZlTh5PKb70vzKEBi/Yh/QW1YFx5T60cc1ZQs88KJQvXHOrvifA3KH+IcihkzbtYOyPXxKsxwBHiWXy7ZgSzTP1SSEa0hw+Fe9GzRYlqrH3Y59xnOxMfrCqB4SfipXp51R0qxvRUVIF+iRUwns19Av5HTUnRf5A7nVoCd+Wf+lVbszdCZFMsE027Z/RN1XYhQkX6YqjffvC4pRfutIa6IupHoyZF2CmBqR33SMEHL2B+XQ7h05mPwpxeL5iakk4KUP8Ay7urIYty5XfyEcDaTtwXNZyzXHdzYcCDbkymcCd+Atwceb/SWs4Lxsp6+few9QSYkInEcuuGcQHVLXvxT77LsF/f
 11V5MQ8g
 NXZ4rsxwMX2HfLAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


The main mm-stable -> mainline merge for 6.19-rc1
(https://lkml.kernel.org/r/20251203212918.82f1c9d3947940aeae263878@linux-foundation.org);


mm.git review status for 7c9580f44f90f7a4c11fc7831efe323ebe446091..faf3c923523e5c8fc3baaa413d62e913774ae52f

Everything:

Total patches:       321
Reviews/patch:       1.62
Reviewed rate:       64%

Excluding DAMON:

Total patches:       249
Reviews/patch:       2.06
Reviewed rate:       79%

Excluding DAMON and zram:

Total patches:       241
Reviews/patch:       2.10
Reviewed rate:       80%



Unreviewed patches by author:


Ankit Agrawal <ankita@nvidia.com>
    "mm: handle poisoning of pfn without struct pages"
        Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
        Link: https://lkml.kernel.org/r/20251102184434.2406-3-ankita@nvidia.com

Balbir Singh <balbirs@nvidia.com>
    "mm/zone_device: support large zone device private folios"
        Link: https://lkml.kernel.org/r/20251001065707.920170-1-balbirs@nvidia.com
        Link: https://lkml.kernel.org/r/20251001065707.920170-2-balbirs@nvidia.com
        Link: https://lore.kernel.org/linux-mm/20201106005147.20113-1-rcampbell@nvidia.com/ [1]
    "mm/zone_device: rename page_free callback to folio_free"
        Link: https://lkml.kernel.org/r/20251001065707.920170-3-balbirs@nvidia.com
    "mm/huge_memory: implement device-private THP splitting"
        Link: https://lkml.kernel.org/r/20251001065707.920170-6-balbirs@nvidia.com
    "mm/migrate_device: handle partially mapped folios during collection"
        Link: https://lkml.kernel.org/r/20251120230825.181072-1-matthew.brost@intel.com
        Link: https://lkml.kernel.org/r/20251001065707.920170-7-balbirs@nvidia.com
    "mm/migrate_device: implement THP migration of zone device pages"
        Link: https://lkml.kernel.org/r/20251001065707.920170-8-balbirs@nvidia.com
    "mm/memory/fault: add THP fault handling for zone device private pages"
        Link: https://lkml.kernel.org/r/20251001065707.920170-9-balbirs@nvidia.com
    "lib/test_hmm: add zone device private THP test infrastructure"
        Link: https://lkml.kernel.org/r/20251001065707.920170-10-balbirs@nvidia.com
    "mm/memremap: add driver callback support for folio splitting"
        Link: https://lkml.kernel.org/r/20251001065707.920170-11-balbirs@nvidia.com
    "mm/migrate_device: add THP splitting during migration"
        Link: https://lkml.kernel.org/r/20251120230825.181072-2-matthew.brost@intel.com
        Link: https://lkml.kernel.org/r/20251001065707.920170-12-balbirs@nvidia.com
    "lib/test_hmm: add large page allocation failure testing"
        Link: https://lkml.kernel.org/r/20251001065707.920170-13-balbirs@nvidia.com
    "selftests/mm/hmm-tests: new tests for zone device THP migration"
        Link: https://lkml.kernel.org/r/20251001065707.920170-14-balbirs@nvidia.com
    "selftests/mm/hmm-tests: new throughput tests including THP"
        Link: https://lkml.kernel.org/r/20251001065707.920170-16-balbirs@nvidia.com
    "gpu/drm/nouveau: enable THP support for GPU memory migration"
        Link: https://lkml.kernel.org/r/20251115003333.3516870-1-balbirs@nvidia.com
        Link: https://lkml.kernel.org/r/20251001065707.920170-17-balbirs@nvidia.com

Baolin Wang <baolin.wang@linux.alibaba.com>
    "mm: vmscan: filter out the dirty file folios for node_reclaim()"
        Link: https://lkml.kernel.org/r/cover.1760687075.git.baolin.wang@linux.alibaba.com
        Link: https://lkml.kernel.org/r/c91f5ecc5152b647904c7503618a01885d913928.1760687075.git.baolin.wang@linux.alibaba.com
    "mm: vmscan: simplify the logic for activating dirty file folios"
        Link: https://lkml.kernel.org/r/ba5c49955fd93c6850bcc19abf0e02e1573768aa.1760687075.git.baolin.wang@linux.alibaba.com
    "mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access"
        Link: https://lkml.kernel.org/r/283a0bdfd6ac7aa334a491422bcae70919c572bd.1763008453.git.baolin.wang@linux.alibaba.com

Jiayuan Chen <jiayuan.chen@linux.dev>
    "mm: vmstat: output reserved_highatomic and free_highatomic in zoneinfo"
        Link: https://lkml.kernel.org/r/20251027141818.283587-1-jiayuan.chen@linux.dev

Ye Liu <liuye@kylinos.cn>
    "tools/mm/page_owner_sort: add help option support"
        Link: https://lkml.kernel.org/r/20251016054927.138510-1-ye.liu@linux.dev

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    "mm: add ability to take further action in vm_area_desc"
        Link: https://lkml.kernel.org/r/2601199a7b2eaeadfcd8ab6e199c6d1706650c94.1760959442.git.lorenzo.stoakes@oracle.com
    "tools/testing/vma: add VMA sticky userland tests"
        Link: https://lkml.kernel.org/r/5e2c7244485867befd052f8afc8188be6a4be670.1763460113.git.lorenzo.stoakes@oracle.com
    "tools/testing/selftests/mm: add MADV_COLLAPSE test case"
        Link: https://lkml.kernel.org/r/0748beeb864525b8ddfa51adad7128dd32eb3ac4.1763460113.git.lorenzo.stoakes@oracle.com
    "tools/testing/selftests/mm: add smaps visibility guard region test"
        Link: https://lkml.kernel.org/r/059e62b8c67e55e6d849878206a95ea1d7c1e885.1763460113.git.lorenzo.stoakes@oracle.com
    "testing/selftests/mm: add soft-dirty merge self-test"
        Link: https://lkml.kernel.org/r/d5a0f735783fb4f30a604f570ede02ccc5e29be9.1763399675.git.lorenzo.stoakes@oracle.com
    "mm: introduce pmd_is_huge() and use where appropriate"
        Link: https://lkml.kernel.org/r/00f79db3b15293cac8f7040a48d69c52d00117e4.1762812360.git.lorenzo.stoakes@oracle.com
    "mm: remove remaining is_swap_pmd() users and is_swap_pmd()"
        Link: https://lkml.kernel.org/r/1628b00b00c8498bbd2c20b82117ee87845fb738.1762812360.git.lorenzo.stoakes@oracle.com
    "mm: remove non_swap_entry() and use softleaf helpers instead"
        Link: https://lkml.kernel.org/r/2562093f37f4a9cffea0447058014485eb50aaaf.1762812360.git.lorenzo.stoakes@oracle.com
    "mm: remove is_hugetlb_entry_[migration, hwpoisoned]()"
        Link: https://lkml.kernel.org/r/0e92d6924d3de88cd014ce1c53e20edc08fc152e.1762812360.git.lorenzo.stoakes@oracle.com
    "mm: eliminate further swapops predicates"
        Link: https://lkml.kernel.org/r/956bc9c031604811c0070d2f4bf2f1373f230213.1762812360.git.lorenzo.stoakes@oracle.com
    "mm: replace remaining pte_to_swp_entry() with softleaf_from_pte()"
        Link: https://lkml.kernel.org/r/d8ee5ccefe4c42d7c4fe1a2e46f285ac40421cd3.1762812360.git.lorenzo.stoakes@oracle.com
    "tools/testing/vma: add missing stub"
        Link: https://lkml.kernel.org/r/4aff8bf7-d367-4ba3-90ad-13eef7a063fa@lucifer.local
    "fs/proc/task_mmu.c: fix make_uffd_wp_huge_pte() huge pte handling"
        Link: https://lkml.kernel.org/r/66178124-ebdf-4e23-b8ca-ed3eb8030c81@lucifer.local

Ma Ke <make24@iscas.ac.cn>
    "mm/hmm/test: fix error handling in dmirror_device_init"
        Link: https://lkml.kernel.org/r/20251108115346.6368-1-make24@iscas.ac.cn

Matthew Brost <matthew.brost@intel.com>
    "selftests/mm/hmm-tests: partial unmap, mremap and anon_write tests"
        Link: https://lkml.kernel.org/r/20251001065707.920170-15-balbirs@nvidia.com

Mauricio Faria de Oliveira <mfo@igalia.com>
    "mm/page_owner: add debugfs file 'show_stacks_handles'"
        Link: https://lkml.kernel.org/r/20251001175611.575861-5-mfo@igalia.com
    "mm/page_owner: update Documentation with 'show_handles' and 'show_stacks_handles'"
        Link: https://lkml.kernel.org/r/20251001175611.575861-6-mfo@igalia.com

Sergey Senozhatsky <senozhatsky@chromium.org>
    "zram: introduce writeback bio batching"
        Link: https://lkml.kernel.org/r/20251122074029.3948921-1-senozhatsky@chromium.org
        Link: https://lkml.kernel.org/r/20251122074029.3948921-2-senozhatsky@chromium.org
        Link: https://lore.kernel.org/all/20181203024045.153534-6-minchan@kernel.org/ [1]
        Link: https://lore.kernel.org/all/20250731064949.1690732-1-richardycc@google.com/ [2]
        Link: https://lore.kernel.org/all/tencent_78FC2C4FE16BA1EBAF0897DB60FCD675ED05@qq.com/ [3]
    "zram: read slot block idx under slot lock"
        Link: https://lkml.kernel.org/r/20251122074029.3948921-7-senozhatsky@chromium.org

SeongJae Park <sj@kernel.org>
    "mm/damon: document damos_quota_goal->nid use case"
        Link: https://lkml.kernel.org/r/20251017212706.183502-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251017212706.183502-2-sj@kernel.org
    "mm/damon: add DAMOS quota goal type for per-memcg per-node memory usage"
        Link: https://lkml.kernel.org/r/20251017212706.183502-3-sj@kernel.org
    "mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP"
        Link: https://lkml.kernel.org/r/20251017212706.183502-4-sj@kernel.org
    "mm/damon/sysfs-schemes: implement path file under quota goal directory"
        Link: https://lkml.kernel.org/r/20251017212706.183502-5-sj@kernel.org
    "mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_USED_BP"
        Link: https://lkml.kernel.org/r/20251017212706.183502-6-sj@kernel.org
    "mm/damon/core: add DAMOS quota gaol metric for per-memcg per-numa free memory"
        Link: https://lkml.kernel.org/r/20251017212706.183502-7-sj@kernel.org
    "mm/damon/sysfs-schemes: support DAMOS_QUOTA_NODE_MEMCG_FREE_BP"
        Link: https://lkml.kernel.org/r/20251017212706.183502-8-sj@kernel.org
    "Docs/mm/damon/design: document DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP"
        Link: https://lkml.kernel.org/r/20251017212706.183502-9-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document DAMOS quota goal path file"
        Link: https://lkml.kernel.org/r/20251017212706.183502-10-sj@kernel.org
    "Docs/ABI/damon: document DAMOS quota goal path file"
        Link: https://lkml.kernel.org/r/20251017212706.183502-11-sj@kernel.org
    "mm/damon/core: fix wrong comment of damon_call() return timing"
        Link: https://lkml.kernel.org/r/20251026182216.118200-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251026182216.118200-2-sj@kernel.org
    "Docs/mm/damon/design: fix wrong link to intervals goal section"
        Link: https://lkml.kernel.org/r/20251026182216.118200-3-sj@kernel.org
    "Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling interval/"
        Link: https://lkml.kernel.org/r/20251026182216.118200-4-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document empty target regions commit behavior"
        Link: https://lkml.kernel.org/r/20251026182216.118200-5-sj@kernel.org
    "Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter"
        Link: https://lkml.kernel.org/r/20251026182216.118200-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter"
        Link: https://lkml.kernel.org/r/20251026182216.118200-7-sj@kernel.org
    "Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter"
        Link: https://lkml.kernel.org/r/20251026182216.118200-8-sj@kernel.org
    "Docs/admin-guide/mm/damon/stat: document negative idle time"
        Link: https://lkml.kernel.org/r/20251026182216.118200-9-sj@kernel.org
    "selftests/damon/_damon_sysfs: support obsolete_target file"
        Link: https://lkml.kernel.org/r/20251023012535.69625-7-sj@kernel.org
    "drgn_dump_damon_status: dump damon_target->obsolete"
        Link: https://lkml.kernel.org/r/20251023012535.69625-8-sj@kernel.org
    "sysfs.py: extend assert_ctx_committed() for monitoring targets"
        Link: https://lkml.kernel.org/r/20251023012535.69625-9-sj@kernel.org
    "selftests/damon/sysfs: add obsolete_target test"
        Link: https://lkml.kernel.org/r/20251023012535.69625-10-sj@kernel.org
    "mm/damon/tests/core-kunit: fix memory leak in damon_test_set_filters_default_reject()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251101182021.74868-2-sj@kernel.org
    "mm/damon/tests/core-kunit: handle allocation failures in damon_test_regions()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-3-sj@kernel.org
    "mm/damon/tests/core-kunit: handle memory failure from damon_test_target()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-4-sj@kernel.org
    "mm/damon/tests/core-kunit: handle memory alloc failure from damon_test_aggregate()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-5-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-6-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-7-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on dasmon_test_merge_regions_of()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-8-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_regions_of()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-9-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures in damon_test_ops_registration()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-10-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures in damon_test_set_regions()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-11-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures in damon_test_update_monitoring_result()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-12-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failure on damon_test_set_attrs()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-13-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failres in damon_test_new_filter()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-14-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failure on damos_test_commit_filter()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-15-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on damos_test_filter_out()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-16-sj@kernel.org
    "mm/damon/tests/core-kunit: handle alloc failures on damon_test_set_filters_default_reject()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-17-sj@kernel.org
    "mm/damon/tests/vaddr-kunit: handle alloc failures on damon_do_test_apply_three_regions()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-18-sj@kernel.org
    "mm/damon/tests/vaddr-kunit: handle alloc failures in damon_test_split_evenly_fail()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-19-sj@kernel.org
    "mm/damon/tests/vaddr-kunit: handle alloc failures on damon_test_split_evenly_succ()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-20-sj@kernel.org
    "mm/damon/tests/sysfs-kunit: handle alloc failures on damon_sysfs_test_add_targets()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-21-sj@kernel.org
    "mm/damon/tests/core-kunit: remove unnecessary damon_ctx variable on damon_test_split_at()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-22-sj@kernel.org
    "mm/damon/tests/core-kunit: remove unused ctx in damon_test_split_regions_of()"
        Link: https://lkml.kernel.org/r/20251101182021.74868-23-sj@kernel.org
    "mm/damon/tests/core-kunit: remove dynamic allocs on damos_test_commit_filter()"
        Link: https://lkml.kernel.org/r/20251111184415.141757-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251111184415.141757-2-sj@kernel.org
    "mm/damon/tests/core-kunit: split out damos_test_commit_filter() core logic"
        Link: https://lkml.kernel.org/r/20251111184415.141757-3-sj@kernel.org
    "mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for union fields"
        Link: https://lkml.kernel.org/r/20251111184415.141757-4-sj@kernel.org
    "mm/damon/tests/core-kunit: add test cases to damos_test_commit_filter()"
        Link: https://lkml.kernel.org/r/20251111184415.141757-5-sj@kernel.org
    "mm/damon/tests/core-kunit: add damos_commit_quota_goal() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-6-sj@kernel.org
    "mm/damon/tests/core-kunit: add damos_commit_quota_goals() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-7-sj@kernel.org
    "mm/damon/tests/core-kunit: add damos_commit_quota() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-8-sj@kernel.org
    "mm/damon/core: pass migrate_dests to damos_commit_dests()"
        Link: https://lkml.kernel.org/r/20251111184415.141757-9-sj@kernel.org
    "mm/damon/tests/core-kunit: add damos_commit_dests() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-10-sj@kernel.org
    "mm/damon/tests/core-kunit: add damos_commit() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-11-sj@kernel.org
    "mm/damon/tests/core-kunit: add damon_commit_target_regions() test"
        Link: https://lkml.kernel.org/r/20251111184415.141757-12-sj@kernel.org
    "mm/damon: rename damos core filter helpers to have word core"
        Link: https://lkml.kernel.org/r/20251112154114.66053-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251112154114.66053-2-sj@kernel.org
    "mm/damon: rename damos->filters to damos->core_filters"
        Link: https://lkml.kernel.org/r/20251112154114.66053-3-sj@kernel.org
    "mm/damon/vaddr: cleanup using pmd_trans_huge_lock()"
        Link: https://lkml.kernel.org/r/20251117154415.11041-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20251112154114.66053-4-sj@kernel.org
        Link: https://lore.kernel.org/296c2b3f-6748-158f-b85d-2952165c0588@google.com [1]
    "mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()"
        Link: https://lkml.kernel.org/r/20251112154114.66053-5-sj@kernel.org
        Link: https://lore.kernel.org/0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com [1]
    "mm/damon/vaddr: consistently use only pmd_entry for damos_migrate"
        Link: https://lkml.kernel.org/r/20251112154114.66053-6-sj@kernel.org
    "mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition"
        Link: https://lkml.kernel.org/r/20251112154114.66053-7-sj@kernel.org
        Link: https://lore.kernel.org/20250828171242.59810-1-sj@kernel.org [1]
    "selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion"
        Link: https://lkml.kernel.org/r/20251112154114.66053-8-sj@kernel.org
    "Docs/mm/damon/maintainer-profile: fix a typo on mm-untable link"
        Link: https://lkml.kernel.org/r/20251112154114.66053-9-sj@kernel.org
    "Docs/mm/damon/maintainer-profile: fix grammatical errors"
        Link: https://lkml.kernel.org/r/20251112154114.66053-10-sj@kernel.org

Uladzislau Rezki (Sony) <urezki@gmail.com>
    "lib/test_vmalloc: add no_block_alloc_test case"
        Link: https://lkml.kernel.org/r/20251007122035.56347-2-urezki@gmail.com
    "lib/test_vmalloc: remove xfail condition check"
        Link: https://lkml.kernel.org/r/20251007122035.56347-3-urezki@gmail.com

Matthew Wilcox (Oracle) <willy@infradead.org>
    "hugetlb: optimise hugetlb_folio_init_tail_vmemmap()"
        Link: https://lkml.kernel.org/r/20251106201452.2292631-1-willy@infradead.org
    "migrate: optimise alloc_migration_target()"
        Link: https://lkml.kernel.org/r/26E8FF35-503E-4F14-98F7-7B4FA25FBD37@nvidia.com
        Link: https://lkml.kernel.org/r/20251106201452.2292631-2-willy@infradead.org
    "memory_hotplug: optimise try_offline_memory_block()"
        Link: https://lkml.kernel.org/r/20251106201452.2292631-3-willy@infradead.org
    "mm: constify __dump_folio() arguments"
        Link: https://lkml.kernel.org/r/20251106203526.2368275-1-willy@infradead.org

xu xin <xu.xin16@zte.com.cn>
    "mm/ksm: fix exec/fork inheritance support for prctl"
        Link: https://lkml.kernel.org/r/20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn
        Link: https://lkml.kernel.org/r/20251007182821572h_SoFqYZXEP1mvWI4n9VL@zte.com.cn
    "selftests: update ksm inheritance tests for prctl fork/exec"
        Link: https://lkml.kernel.org/r/20251007182935207jm31wCIgLpZg5XbXQY64S@zte.com.cn

Chunyan Zhang <zhangchunyan@iscas.ac.cn>
    "riscv: mm: add userfaultfd write-protect support"
        Link: https://lkml.kernel.org/r/20251113072806.795029-6-zhangchunyan@iscas.ac.cn

Hui Zhu <zhuhui@kylinos.cn>
    "mm/hugetlb: extract sysfs into hugetlb_sysfs.c"
        Link: https://lkml.kernel.org/r/cover.1762398359.git.zhuhui@kylinos.cn
        Link: https://lkml.kernel.org/r/656a03dff7e2bb20e24e841ede81fdca01d21410.1762398359.git.zhuhui@kylinos.cn
    "mm/hugetlb: extract sysctl into hugetlb_sysctl.c"
        Link: https://lkml.kernel.org/r/5bbee7ab5be71d0bb1aebec38642d7e83526bb7a.1762398359.git.zhuhui@kylinos.cn



