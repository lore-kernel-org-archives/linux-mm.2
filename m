Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E8D0F532CF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 03:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814E56B0088; Mon, 23 Mar 2026 23:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C65D6B0089; Mon, 23 Mar 2026 23:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B46C6B008A; Mon, 23 Mar 2026 23:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 537F46B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:29:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0C701412FA
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:29:44 +0000 (UTC)
X-FDA: 84579527088.17.C0542EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 16EFB20003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:29:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CJQNXZeB;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774322983; a=rsa-sha256;
	cv=none;
	b=fOH7WwwGON76pPmcQwEwt3mJ9AxoTXiXNY7WmxAWAGOSBbPcXzvqyFyqpCjaGUJPfrPh/L
	aB/SWmynRZUvJI1vQi0CoaUdwbIboYEmN4qqbKF3tgxBLsocM2MmsBB9bw7kHUZ5anBW8V
	xIS6PJowK7uiV6i6RQfNOawq2tzRbe4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CJQNXZeB;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774322983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tyeFDBECh2ftdpD4GL/6CKGAXvk8PuEZZQ0E1sg/iic=;
	b=Z3OEQdOcURo1/QS3qyk/tMeAwwY71VJK6KSkY9sWIpfLxYzqY5dXerSDs48r4IAMemXnuE
	8KN6yaXUCFI+R+fcYBEQ33pD1E8T8gkgD5IvfIES+visGO40lWagzeTgSkIrthqRjbE70f
	DxDoT0LvIecW9Fp7qEpKmsjHonl35RQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 189A743B80
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA38C19424
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774322982;
	bh=otqMTqFs3skB/YhW3MB6xnlUsi7y11R/pihWgjqqFN4=;
	h=Date:From:To:Subject:From;
	b=CJQNXZeB2ktfR9rvmqOkEKf+NC2XNr6J8AlnVaXkYClhh9m1CbB8zd4KkzCJy4Kpx
	 1uf70IHtGpMgbsFGJgsB8WmWMPICc0Zqgg/F6+0MkFWKkkYry1mhl90/DwD/TZi3UD
	 oa4agmOW2M4IGmXXuMhF07iJdWUe154qkImP2Sm4=
Date: Mon, 23 Mar 2026 20:29:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.0-rc5
Message-Id: <20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mqgn59ssh3jyab7k8ti55489prf4cni3
X-Rspamd-Queue-Id: 16EFB20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774322982-646623
X-HE-Meta: U2FsdGVkX19fp8yudgnwezQz8Vr9eR34cn6/SwY0ujRpgFmTfVVIHrgsBoHgYwHzjduiLi0Q6Jkrc4qQmjJsE1yEsM9U7uomryi+apXhDGhD3BLUln26zdUupWwPmQsPrTv+JRWeJvQjfBMrEjdXQUGgYHBQtyig7nx0RdQTL1nMRnQK+8DLG+gFIflN2rK4EGOiIyA3vhfiBxdH0SYeePh9k4xTt2ezOc6/vm16uRrqGlUkFB3FhHQ/MwG1rvtDQt05w7VxTdt1yzu4IKxL0cXllRt8bxxb0vZuUSGTUNW/h1UZuIO8t8vgAVmmtYhZtuAKJntjcc76FBv4vsFKPqfK1gh/IOz4j63Hk3Tv/pG04gzja7CYee8TYdxiyDIdoMgQcZw23IT2ajd3kcRFM3yiY29ESiQQaociHUJl2U5wdEvllIYxSVdNnXnqAVQC/kPO81u0BbApqVMkaAuH9GfFVpmqbNvoN3XP9GkvHJzbCT8nj+G1wcoKYlOHQCZz3TDSL9lYhq2SYU1Bx/RdAiLlznBEvnUvZ1nnk1JHLzbHZ6ZNIqs3aywsfg1bq0bpacJmWnNz9im8bb4M3278sQZy+mp+/8ASoRa7YWYGF5m4/0TQAmLMGdBpWZQnb4KkgA9fEYOp4DOgKbPhIBRvYP6o2NKEYS98GlpkE10wnPEheHBIq505mcaXqmdmgCEUctRGeDd/SG1HL8n7CdJrWpQKMTuSgWvuFNzXBbsncicWdHq2PmnffI+L7a8CbYUGqTwbkCnbAmdg7sToEllxOosx2umy2UlXtorbJyXIT/SLn94UeRVSBTHKHeHUUfLNzM40Cuyy6i4d5BuWRs7QlxzE09xk9N48fMbzk+zSj+B4dCBKwR//1IvgqkZhUK6x2hqZMPnhvtqX/dkMqK0MAGrVnoTTutRx6QSVjrsie3cjltjTE6+LJ8x+wmhWEKJbagMb9tGSWH6yqWhCUKW
 mxeLNRtR
 ezrqcJLH/TCjWUac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


That's a ton of patches and it's time to close the door.  Fixes only,
please.  And performance increases if they are measured and the
measurements are good.

This gives us three weeks for testing and review of most of this
material.  As usual, I'll send a subset of this material upstream in
the second week of the merge window, so four weeks of stabili[sz]ation
for the later-arriving patches.  Please see
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series
for the approximate merging order.

Review coverage is presently rather ho-hum so again, please dig in and
help out with this.

I plan to start moving the head-of-queue patches into mm-stable this
week, subject to review status.

M:aintainers: please check these patches for anything which you believe
is unsuitable for the next merge window and let me know.

Also, if you see the "added to mm-stable" email fly past and you
disagree with that decision, please holler (promptly) and I can fix
that.


THANK YOU FOR YOUR ATTENTION TO THIS MATTER (sorry, couldn't help
myself).


51 patch series:

Patch series "KSM: Optimizations for rmap_walk_ksm", v3.
Patch series "maple_tree: Replace big node with maple copy", v3.
Patch series "mm, swap: swap table phase III: remove swap_map", v3.
Patch series "mm: memfd_luo: preserve file seals", v2.
Patch series "mm: zswap: add per-memcg stat for incompressible pages", v3.
Patch series "arch, mm: consolidate empty_zero_page", v3.
Patch series "mm/kmemleak: Improve scan_should_stop() implementation".
Patch series "Improve khugepaged scan logic", v8.
Patch series "Make KHO Stateless", v9.
Patch series "mm: vmscan: add PID and cgroup ID to vmscan tracepoints", v8.
Patch series "mm: arch/shstk: Common shadow stack mapping helper and
Patch series "Fix KASAN support for KHO restored vmalloc regions".
Patch series "mm: Remove stray references to pagevec", v2.
Patch series "mm: Eliminate fake head pages from vmemmap optimization",
Patch series "mm/damon/core: improve DAMOS quota efficiency for core layer
Patch series "mm/damon: strictly respect min_nr_regions".
Patch series "mm/page_alloc: pcp locking cleanup".
Patch series "mm: cleanups around unmapping / zapping".
Patch series "Eliminate Dying Memory Cgroup", v6.
Patch series "support batched checking of the young flag for MGLRU", v3.
Patch series "memcg: obj stock and slab stat caching cleanups".
Patch series "Allow order zero pages in page reporting", v4.
Patch series "mm: vma flag tweaks".
Patch series "mm: zone lock tracepoint instrumentation", v4.
Patch series "mm, kvm: allow uffd support in guest_memfd", v2.
Patch series "mm/damon: add optional debugging-purpose sanity checks".
Patch series "mm/damon: test and document power-of-2 min_region_sz
Patch series "mm/damon/core: make passed_sample_intervals comparisons
Patch series "mm/damon: improve/fixup/update ratio calculation, test and
Patch series "mm: move vma_(kernel|mmu)_pagesize() out of hugetlb.c", v2.
Patch series "selftests/mm: fix failures and robustness improvements", v2.
Patch series "selftests/mm: fix failures and robustness improvements".
Patch series "zram: recompression cleanups and tweaks", v2.
Patch series "mm/damon: support multiple goal-based quota tuning
Patch series "mm: thp: reduce unnecessary start_stop_khugepaged()", v7.
Patch series "mm: improve map count checks".
Patch series "mm/damon: support addr_unit on default monitoring targets
Patch series "mm: khugepaged cleanups and mTHP prerequisites", v3.
Patch series "zswap pool per-CPU acomp_ctx simplifications".
Patch series "mm/vma: convert vm_flags_t to vma_flags_t in vma code", v4.
Patch series "mm: expand mmap_prepare functionality and usage", v4.
Patch series "liveupdate: Fix module unloading and unregister API", v2.
Patch series "mm: memory hot(un)plug and SPARSEMEM cleanups".
Patch series "mm: switch THP shrinker to list_lru", v3.
Patch series "selftests/mm: skip several tests when thp is not available",
Patch series "mm/huge_memory: refactor zap_huge_pmd()", v3.
Patch series "mm: remove CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE and cleanup
Patch series "change young flag check functions to return bool", v2.
Patch series "Modify memfd_luo code", v2.
Patch series "mm/swap, PM: hibernate: fix swapoff race in uswsusp by
Patch series "kho: history: track previous kernel version and kexec boot



mm.git review status for mm-hotfixes-stable..mm-new

Everything:

Total patches:       510
Reviews/patch:       1.41
Reviewed rate:       63%

Excluding DAMON:

Total patches:       457
Reviews/patch:       1.54
Reviewed rate:       67%

Excluding DAMON and zram:

Total patches:       447
Reviews/patch:       1.56
Reviewed rate:       68%

Excluding DAMON, zram and maple_tree:

Total patches:       415
Reviews/patch:       1.68
Reviewed rate:       73%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (5 total)
    "maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes"
    "mm-centralizefix-comments-about-compound_mapcount-in-new-sync_with_folio_pmd_zap-fix"
    "mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix"
    "mm-page_reporting-add-page_reporting_order_unspecified-fix"
    "selftests-mm-add-uffdio_move-huge-zeropage-pmd-regression-test-fix"

Arnd Bergmann <arnd@arndb.de> (2 total)
    "bug: avoid format attribute warning for clang as well"
        Link: https://lkml.kernel.org/r/20260323205534.1284284-1-arnd@kernel.org
        Link: https://lore.kernel.org/all/20251208141618.2805983-1-andriy.shevchenko@linux.intel.com/T/#u
    "mm/vmscan: avoid false-positive -Wuninitialized warning"
        Link: https://lkml.kernel.org/r/20260213123902.3466040-1-arnd@kernel.org

Audra Mitchell <audra@redhat.com> (1 total)
    "selftests/mm: fix soft-dirty kselftest supported check"
        Link: https://lkml.kernel.org/r/20260320184010.759461-2-audra@redhat.com

Andrei Vagin <avagin@google.com> (1 total)
    "userfaultfd: fix lock leak in mfill_get_vma()"
        Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com

Baolin Wang <baolin.wang@linux.alibaba.com> (1 total)
    "mm: add a batched helper to clear the young flag for large folios"
        Link: https://lkml.kernel.org/r/23ec671bfcc06cd24ee0fbff8e329402742274a0.1772778858.git.baolin.wang@linux.alibaba.com

Chengkaitao <chengkaitao@kylinos.cn> (1 total)
    "mm: convert vmemmap_p?d_populate() to static functions"
        Link: https://lkml.kernel.org/r/20260201063532.44807-3-pilgrimtao@gmail.com

David Hildenbrand (Arm) <david@kernel.org> (6 total)
    "mm/memory: fix PMD/PUD checks in follow_pfnmap_start()"
        Link: https://lkml.kernel.org/r/20260323-follow_pfnmap_fix-v1-1-5b0ec10872b3@kernel.org
    "mm: centralize+fix comments about compound_mapcount() in new sync_with_folio_pmd_zap()"
        Link: https://lkml.kernel.org/r/20260223163920.287720-1-david@kernel.org
    "mm/pagewalk: drop FW_MIGRATION"
        Link: https://lkml.kernel.org/r/20260227212952.190691-1-david@kernel.org
    "fixup: mm/memory: remove zap_details parameter from zap_page_range_single()"
        Link: https://lkml.kernel.org/r/8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org
    "mm-memory-inline-unmap_page_range-into-__zap_vma_range-fix"
        Link: https://lkml.kernel.org/r/f7732d1c-0e85-4a14-948a-912c417018b5@kernel.org
    "mm-sparse-move-sparse_init_one_section-to-internalh-fix"
        Link: https://lkml.kernel.org/r/6b04c1a1-74e7-42e8-8523-a40802e5dacc@kernel.org

David Carlier <devnexen@gmail.com> (2 total)
    "mm/hugetlb: restore reservation on error in hugetlb_mfill_atomic_pte() resubmission path"
        Link: https://lkml.kernel.org/r/20260322052120.14021-1-devnexen@gmail.com
    "mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix-fix-fix-2-fix"
        Link: https://lkml.kernel.org/r/20260323063007.7783-1-devnexen@gmail.com

Dmitry Ilvokhin <d@ilvokhin.com> (2 total)
    "mm: fix remaining zone->lock references"
        Link: https://lkml.kernel.org/r/aabvc4Xhc9qBfaG7@shell.ilvokhin.com
    "mm: documentation: standardize on "zone lock" terminology"
        Link: https://lkml.kernel.org/r/aanSnywUXTVPaYUj@shell.ilvokhin.com

Donet Tom <donettom@linux.ibm.com> (1 total)
    "memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled"
        Link: https://lkml.kernel.org/r/20260323094849.3903-1-donettom@linux.ibm.com

Chenghao Duan <duanchenghao@kylinos.cn> (1 total)
    "mm/memfd: use folio_nr_pages() for shmem inode accounting"
        Link: https://lkml.kernel.org/r/20260323110747.193569-1-duanchenghao@kylinos.cn
        Link: https://lkml.kernel.org/r/20260323110747.193569-2-duanchenghao@kylinos.cn

Harry Yoo (Oracle) <harry@kernel.org> (1 total)
    "MAINTAINERS, mailmap: update email address for Harry Yoo"
        Link: https://lkml.kernel.org/r/20260320125925.2259998-1-harry@kernel.org

Jane Chu <jane.chu@oracle.com> (1 total)
    "Documentation: fix a hugetlbfs reservation statement"
        Link: https://lkml.kernel.org/r/20260302201015.1824798-1-jane.chu@oracle.com

Jianhui Zhou <jianhuizzzzz@gmail.com> (1 total)
    "mm/userfaultfd: fix hugetlb fault mutex hash calculation"
        Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com

Nikita Kalyazin <kalyazin@amazon.com> (3 total)
    "KVM: guest_memfd: implement userfaultfd operations"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-14-rppt@kernel.org
    "KVM: selftests: test userfaultfd minor for guest_memfd"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-15-rppt@kernel.org
    "KVM: selftests: test userfaultfd missing for guest_memfd"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-16-rppt@kernel.org

Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com> (2 total)
    "mm: zswap: remove redundant checks in zswap_cpu_comp_dead()"
        Link: https://lkml.kernel.org/r/20260314051632.17931-1-kanchanapsridhar2026@gmail.com
        Link: https://lkml.kernel.org/r/20260317014802.27591-2-kanchanapsridhar2026@gmail.com
        Link: https://patchwork.kernel.org/project/linux-mm/list/?series=1046677 [1]
    "mm: zswap: tie per-CPU acomp_ctx lifetime to the pool"
        Link: https://lkml.kernel.org/r/20260317014802.27591-3-kanchanapsridhar2026@gmail.com

Kiryl Shutsemau <kas@kernel.org> (2 total)
    "riscv/mm: align vmemmap to maximal folio size"
        Link: https://lkml.kernel.org/r/20260227194302.274384-6-kas@kernel.org
    "LoongArch/mm: align vmemmap to maximal folio size"
        Link: https://lkml.kernel.org/r/20260227194302.274384-7-kas@kernel.org

Kairui Song <kasong@tencent.com> (1 total)
    "mm, swap: speed up hibernation allocation and writeout"
        Link: https://lkml.kernel.org/r/20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com
        Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]

Kexin Sun <kexinsun@smail.nju.edu.cn> (2 total)
    "mm: vmalloc: update outdated comment for renamed vread()"
        Link: https://lkml.kernel.org/r/20260321105820.7134-1-kexinsun@smail.nju.edu.cn
    "drivers/base/memory: fix stale reference to memory_block_add_nid()"
        Link: https://lkml.kernel.org/r/20260321105704.6093-1-kexinsun@smail.nju.edu.cn

Breno Leitao <leitao@debian.org> (2 total)
    "mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option"
        Link: https://lkml.kernel.org/r/20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org
    "kho: fix kho_in_debugfs_init() to handle non-FDT blobs"
        Link: https://lkml.kernel.org/r/20260316-kho-v9-4-ed6dcd951988@debian.org

Liam R. Howlett <Liam.Howlett@oracle.com> (30 total)
    "maple_tree: fix mas_dup_alloc() sparse warning"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-1-Liam.Howlett@oracle.com
        Link: https://lkml.kernel.org/r/20260130205935.2559335-2-Liam.Howlett@oracle.com
    "maple_tree: move mas_spanning_rebalance loop to function"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-3-Liam.Howlett@oracle.com
    "maple_tree: extract use of big node from mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-4-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary assignment of orig_l index"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-5-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-6-Liam.Howlett@oracle.com
    "maple_tree: make ma_wr_states reliable for reuse in spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-7-Liam.Howlett@oracle.com
    "maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-8-Liam.Howlett@oracle.com
    "maple_tree: don't pass through height in mas_wr_spanning_store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-9-Liam.Howlett@oracle.com
    "maple_tree: move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-10-Liam.Howlett@oracle.com
    "maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-11-Liam.Howlett@oracle.com
    "maple_tree: introduce maple_copy node and use it in mas_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-12-Liam.Howlett@oracle.com
    "maple_tree: testing update for spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-13-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-14-Liam.Howlett@oracle.com
    "maple_tree: change initial big node setup in mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-15-Liam.Howlett@oracle.com
    "maple_tree: introduce ma_leaf_max_gap()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-16-Liam.Howlett@oracle.com
    "maple_tree: add gap support, slot and pivot sizes for maple copy"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-17-Liam.Howlett@oracle.com
    "maple_tree: start using maple copy node for destination"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-18-Liam.Howlett@oracle.com
    "maple_tree: inline mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-19-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary return statements"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-20-Liam.Howlett@oracle.com
    "maple_tree: separate wr_split_store and wr_rebalance store type code path"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-21-Liam.Howlett@oracle.com
    "maple_tree: add cp_is_new_root() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-22-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_rebalance() operation"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-23-Liam.Howlett@oracle.com
    "maple_tree: add test for rebalance calculation off-by-one"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-24-Liam.Howlett@oracle.com
    "maple_tree: add copy_tree_location() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-25-Liam.Howlett@oracle.com
    "maple_tree: add cp_converged() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-26-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_split()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-27-Liam.Howlett@oracle.com
    "maple_tree: remove maple big node and subtree structs"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-28-Liam.Howlett@oracle.com
    "maple_tree: pass maple copy node to mas_wmb_replace()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-29-Liam.Howlett@oracle.com
    "maple_tree: don't pass end to mas_wr_append()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-30-Liam.Howlett@oracle.com
    "maple_tree: clean up mas_wr_node_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-31-Liam.Howlett@oracle.com

Lorenzo Stoakes (Oracle) <ljs@kernel.org> (32 total)
    "mm: rename VMA flag helpers to be more readable"
        Link: https://lkml.kernel.org/r/cover.1772704455.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/0f9cb3c511c478344fac0b3b3b0300bb95be95e9.1772704455.git.ljs@kernel.org
    "mm: add vma_desc_test_all() and use it"
        Link: https://lkml.kernel.org/r/568c8f8d6a84ff64014f997517cba7a629f7eed6.1772704455.git.ljs@kernel.org
    "tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix"
        Link: https://lkml.kernel.org/r/f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local
    "mm/mremap: correct invalid map count check"
        Link: https://lkml.kernel.org/r/cover.1773249037.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/73e218c67dcd197c5331840fb011e2c17155bfb0.1773249037.git.ljs@kernel.org
    "mm: abstract reading sysctl_max_map_count, and READ_ONCE()"
        Link: https://lkml.kernel.org/r/0715259eb37cbdfde4f9e5db92a20ec7110a1ce5.1773249037.git.ljs@kernel.org
    "mm/mremap: check map count under mmap write lock and abstract"
        Link: https://lkml.kernel.org/r/18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org
    "tools/testing/vma: add unit tests flag empty, diff_pair, and[_mask]"
        Link: https://lkml.kernel.org/r/471ce7ceb1d32e5fc9c0660966b9eacdf899b4d1.1774034900.git.ljs@kernel.org
    "tools/testing/vma: convert bulk of test code to vma_flags_t"
        Link: https://lkml.kernel.org/r/df90efe29300bd899989f695be4ae3adc901a828.1774034900.git.ljs@kernel.org
    "tools/testing/vma: fix VMA flag tests"
        Link: https://lkml.kernel.org/r/b19c63af3d5efdfe712bf5d5f89368a5360a60f7.1774034900.git.ljs@kernel.org
    "tools/testing/vma: add simple test for append_vma_flags()"
        Link: https://lkml.kernel.org/r/eebd946c5325ad7fae93027245a562eb1aeb68a2.1774034900.git.ljs@kernel.org
    "tools/testing/vma: test that legacy flag helpers work correctly"
        Link: https://lkml.kernel.org/r/3374e50053adb65818fde948ae3488e1e29ae8b1.1774034900.git.ljs@kernel.org
    "tools/testing/vma: update VMA flag tests to test vma_test[_any_mask]()"
        Link: https://lkml.kernel.org/r/dea3e97c6c3dd86f1a3f1a0703241b03f6e3a33f.1774034900.git.ljs@kernel.org
    "tools/testing/vma: test vma_flags_count,vma[_flags]_test_single_mask"
        Link: https://lkml.kernel.org/r/4af95d559cd2af0ba3388de1e1386b9f94c0e009.1774034900.git.ljs@kernel.org
    "tools/testing/vma: update VMA tests to test vma_clear_flags[_mask]()"
        Link: https://lkml.kernel.org/r/f5da681d3c33039dd4a838188385796eb8d58373.1774034900.git.ljs@kernel.org
    "tools: bitmap: add missing bitmap_copy() implementation"
        Link: https://lkml.kernel.org/r/4dcb2fb959137e9fe58a23e21cebcea97de41a1f.1774034900.git.ljs@kernel.org
    "mm: various small mmap_prepare cleanups"
        Link: https://lkml.kernel.org/r/cover.1774045440.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/99f408e4694f44ab12bdc55fe0bd9685d3bd1117.1774045440.git.ljs@kernel.org
    "mm: avoid deadlock when holding rmap on mmap_prepare error"
        Link: https://lkml.kernel.org/r/d44248be9da68258b07c2c59d4e73485ee0ca943.1774045440.git.ljs@kernel.org
    "mm: switch the rmap lock held option off in compat layer"
        Link: https://lkml.kernel.org/r/dda74230d26a1fcd79a3efab61fa4101dd1cac64.1774045440.git.ljs@kernel.org
    "mm/vma: remove superfluous map->hold_file_rmap_lock"
        Link: https://lkml.kernel.org/r/42c3fbb701e361a17193ecda0d2dabcc326288a5.1774045440.git.ljs@kernel.org
    "mm: have mmap_action_complete() handle the rmap lock and unmap"
        Link: https://lkml.kernel.org/r/8d1ee8ebd3542d006a47e8382fb80cf5b57ecf10.1774045440.git.ljs@kernel.org
    "mm: add vm_ops->mapped hook"
        Link: https://lkml.kernel.org/r/4c5e98297eb0aae9565c564e1c296a112702f144.1774045440.git.ljs@kernel.org
    "fs: afs: revert mmap_prepare() change"
        Link: https://lkml.kernel.org/r/08804c94e39d9102a3a8fbd12385e8aa079ba1d3.1774045440.git.ljs@kernel.org
    "fs: afs: restore mmap_prepare implementation"
        Link: https://lkml.kernel.org/r/ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org
    "mm: allow handling of stacked mmap_prepare hooks in more drivers"
        Link: https://lkml.kernel.org/r/24aac3019dd34740e788d169fccbe3c62781e648.1774045440.git.ljs@kernel.org
    "drivers: hv: vmbus: replace deprecated mmap hook with mmap_prepare"
        Link: https://lkml.kernel.org/r/05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org
    "uio: replace deprecated mmap hook with mmap_prepare in uio_info"
        Link: https://lkml.kernel.org/r/157583e4477705b496896c7acd4ac88a937b8fa6.1774045440.git.ljs@kernel.org
    "mm/huge_memory: simplify vma_is_specal_huge()"
        Link: https://lkml.kernel.org/r/cover.1774029655.git.ljs@kernel.org
        Link: https://lkml.kernel.org/r/d2b65883dc4895f197c4b4a69fbf27a063463412.1774029655.git.ljs@kernel.org
        Link: https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/ [0]
    "mm/huge_memory: remove unnecessary sanity checks"
        Link: https://lkml.kernel.org/r/0c4c5ab247c90f80cf44718e8124b217d6a22544.1774029655.git.ljs@kernel.org
    "mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()"
        Link: https://lkml.kernel.org/r/b677592596274fa3fd701890497948e4b0e07cec.1774029655.git.ljs@kernel.org
    "mm/huge_memory: add and use normal_or_softleaf_folio_pmd()"
        Link: https://lkml.kernel.org/r/c2be872d64ef9573b80727d9ab5446cf002f17b5.1774029655.git.ljs@kernel.org
    "mm-huge_memory-add-and-use-normal_or_softleaf_folio_pmd-fix"
        Link: https://lkml.kernel.org/r/d0cc6161-77a4-42ba-a411-96c23c78df1b@lucifer.local
    "mm/huge_memory: add and use has_deposited_pgtable()"
        Link: https://lkml.kernel.org/r/f9db59ca90937e39913d50ecb4f662e2bad17bbb.1774029655.git.ljs@kernel.org

Michal Hocko <mhocko@suse.com> (1 total)
    "vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY"
        Link: https://lkml.kernel.org/r/20260302114740.2668450-2-urezki@gmail.com

Josh Law <objecting@objecting.org> (1 total)
    "lib/maple_tree: fix swapped arguments in mas_safe_pivot() call"
        Link: https://lkml.kernel.org/r/20260306225849.2824409-1-objecting@objecting.org
        Link: https://lkml.kernel.org/r/20260306223219.2824040-1-objecting@objecting.org
        Link: https://lkml.kernel.org/r/20260306200820.2819999-1-objecting@objecting.org

Pasha Tatashin <pasha.tatashin@soleen.com> (8 total)
    "liveupdate: protect file handler list with rwsem"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-11-pasha.tatashin@soleen.com
        Link: https://lore.kernel.org/all/20260303210733.GG972761@nvidia.com [1]
    "liveupdate: protect FLB lists with rwsem"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-12-pasha.tatashin@soleen.com
    "liveupdate: remove file handler module refcounting"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-13-pasha.tatashin@soleen.com
    "liveupdate: defer FLB module refcounting to active sessions"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-14-pasha.tatashin@soleen.com
    "liveupdate: remove luo_session_quiesce()"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-15-pasha.tatashin@soleen.com
    "liveupdate: auto unregister FLBs on file handler unregistration"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-16-pasha.tatashin@soleen.com
    "liveupdate: remove liveupdate_test_unregister()"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-17-pasha.tatashin@soleen.com
    "liveupdate: make unregister functions return void"
        Link: https://lkml.kernel.org/r/20260318141637.1870220-18-pasha.tatashin@soleen.com

Peter Xu <peterx@redhat.com> (1 total)
    "mm: generalize handling of userfaults in __do_fault()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-13-rppt@kernel.org

Pratyush Yadav (Google) <pratyush@kernel.org> (2 total)
    "mm: memfd_luo: preserve file seals"
        Link: https://lkml.kernel.org/r/20260216185946.1215770-3-pratyush@kernel.org
    "kho: move alloc tag init to kho_init_{folio,pages}()"
        Link: https://lkml.kernel.org/r/20260213085914.2778107-1-pratyush@kernel.org

Xie Yuanbin <qq570070308@gmail.com> (2 total)
    "mm/debug: optimize once judgment with clang"
        Link: https://lkml.kernel.org/r/20260309153405.20130-1-qq570070308@gmail.com
    "mm: optimize the implementation of WARN_ON_ONCE_GFP()"
        Link: https://lkml.kernel.org/r/20260309153811.40958-1-qq570070308@gmail.com

Mike Rapoport (Microsoft) <rppt@kernel.org> (9 total)
    "userfaultfd: introduce mfill_get_pmd() helper"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-4-rppt@kernel.org
    "userfaultfd: introduce mfill_get_vma() and mfill_put_vma()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-5-rppt@kernel.org
    "userfaultfd: retry copying with locks dropped in mfill_atomic_pte_copy()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-6-rppt@kernel.org
    "userfaultfd: introduce vm_uffd_ops"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-8-rppt@kernel.org
    "userfaultfd: allow registration of WP_ASYNC for any VMA"
        Link: https://lkml.kernel.org/r/abG5HFV8yoEHOFkh@kernel.org
    "shmem, userfaultfd: use a VMA callback to handle UFFDIO_CONTINUE"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-9-rppt@kernel.org
    "userfaultfd: introduce vm_uffd_ops->alloc_folio()"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-10-rppt@kernel.org
    "shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-11-rppt@kernel.org
    "userfaultfd: mfill_atomic(): remove retry logic"
        Link: https://lkml.kernel.org/r/20260306171815.3160826-12-rppt@kernel.org

Andrey Ryabinin <ryabinin.a.a@gmail.com> (1 total)
    "kasan: fix bug type classification for SW_TAGS mode"
        Link: https://lkml.kernel.org/r/20260305185659.20807-1-ryabinin.a.a@gmail.com

Sayali Patil <sayalip@linux.ibm.com> (3 total)
    "selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh"
        Link: https://lkml.kernel.org/r/3b5b4275fed509e13567bba7471a9130bbfa6841.1773305677.git.sayalip@linux.ibm.com
    "selftest/mm: register existing mapping with userfaultfd in hugepage-mremap"
        Link: https://lkml.kernel.org/r/da7ec96ee85ccfdb9bec704c6dd534b419212f94.1773305677.git.sayalip@linux.ibm.com
    "selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page sizes"
        Link: https://lkml.kernel.org/r/e4e655c7d7c4e24b90d51530157d024854bff1cb.1773305678.git.sayalip@linux.ibm.com

Sergey Senozhatsky <senozhatsky@chromium.org> (5 total)
    "zram: do not autocorrect bad recompression parameters"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-3-senozhatsky@chromium.org
    "zram: drop ->num_active_comps"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-4-senozhatsky@chromium.org
    "zram: update recompression documentation"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-5-senozhatsky@chromium.org
    "zram: remove chained recompression"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-6-senozhatsky@chromium.org
    "zram: unify and harden algo/priority params handling"
        Link: https://lkml.kernel.org/r/20260311084312.1766036-7-senozhatsky@chromium.org

Seongsu Park <sgsu.park@samsung.com> (1 total)
    "mm/pkeys: remove unused tsk parameter from arch_set_user_pkey_access()"
        Link: https://lkml.kernel.org/r/20260219063506.545148-1-sgsu.park@samsung.com

SeongJae Park <sj@kernel.org> (38 total)
    "mm/damon/core: set quota-score histogram with core filters"
        Link: https://lkml.kernel.org/r/20260227170623.95384-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260227170623.95384-2-sj@kernel.org
    "mm/damon/core: do non-safe region walk on kdamond_apply_schemes()"
        Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
    "mm/damon/core: split regions for min_nr_regions"
        Link: https://lkml.kernel.org/r/20260228222831.7232-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260228222831.7232-2-sj@kernel.org
        Link: https://lore.kernel.org/CAC5umyjmJE9SBqjbetZZecpY54bHpn2AvCGNv3aF6J=1cfoPXQ@mail.gmail.com [1]
    "mm/damon/vaddr: do not split regions for min_nr_regions"
        Link: https://lkml.kernel.org/r/20260228222831.7232-3-sj@kernel.org
    "mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test"
        Link: https://lkml.kernel.org/r/20260228222831.7232-4-sj@kernel.org
    "mm/damon: add CONFIG_DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260306152914.86303-2-sj@kernel.org
        Link: https://lore.kernel.org/20251231070029.79682-1-sj@kernel.org [1]
        Link: https://github.com/damonitor/damon-tests/commit/a80fbee55e272f151b4e5809ee85898aea33e6ff [2]
    "mm/damon/core: add damon_new_region() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-3-sj@kernel.org
    "mm/damon/core: add damon_del_region() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-4-sj@kernel.org
    "mm/damon/core: add damon_nr_regions() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-5-sj@kernel.org
    "mm/damon/core: add damon_merge_two_regions() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-6-sj@kernel.org
    "mm/damon/core: add damon_merge_regions_of() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-7-sj@kernel.org
    "mm/damon/core: add damon_split_region_at() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-8-sj@kernel.org
    "mm/damon/core: add damon_reset_aggregated() debug_sanity check"
        Link: https://lkml.kernel.org/r/20260306152914.86303-9-sj@kernel.org
    "mm/damon/tests/.kunitconifg: enable DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-10-sj@kernel.org
    "selftests/damon/config: enable DAMON_DEBUG_SANITY"
        Link: https://lkml.kernel.org/r/20260306152914.86303-11-sj@kernel.org
    "mm/damon/tests/core-kunit: add a test for damon_commit_ctx()"
        Link: https://lkml.kernel.org/r/20260307194222.202075-2-sj@kernel.org
    "Docs/mm/damon/design: document the power-of-two limitation for addr_unit"
        Link: https://lkml.kernel.org/r/20260307194222.202075-3-sj@kernel.org
    "mm/damon/core: remove damos_set_next_apply_sis() duplicates"
        Link: https://lkml.kernel.org/r/20260307194915.203169-2-sj@kernel.org
    "mm/damon/core: use time_before() for next_apply_sis"
        Link: https://lkml.kernel.org/r/20260307194915.203169-3-sj@kernel.org
    "mm/damon/core: use time_after_eq() in kdamond_fn()"
        Link: https://lkml.kernel.org/r/20260307194915.203169-4-sj@kernel.org
    "mm/damon/core: introduce damos_quota_goal_tuner"
        Link: https://lkml.kernel.org/r/20260310010529.91162-2-sj@kernel.org
        Link: https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com [1]
        Link: https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com [2]
    "mm/damon/core: allow quota goals set zero effective size quota"
        Link: https://lkml.kernel.org/r/20260310010529.91162-3-sj@kernel.org
    "mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"
        Link: https://lkml.kernel.org/r/20260310010529.91162-4-sj@kernel.org
    "mm/damon/sysfs-schemes: implement quotas->goal_tuner file"
        Link: https://lkml.kernel.org/r/20260310010529.91162-5-sj@kernel.org
    "Docs/mm/damon/design: document the goal-based quota tuner selections"
        Link: https://lkml.kernel.org/r/20260310010529.91162-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document goal_tuner sysfs file"
        Link: https://lkml.kernel.org/r/20260310010529.91162-7-sj@kernel.org
    "Docs/ABI/damon: update for goal_tuner"
        Link: https://lkml.kernel.org/r/20260310010529.91162-8-sj@kernel.org
    "mm/damon/tests/core-kunit: test goal_tuner commit"
        Link: https://lkml.kernel.org/r/20260310010529.91162-9-sj@kernel.org
    "selftests/damon/_damon_sysfs: support goal_tuner setup"
        Link: https://lkml.kernel.org/r/20260310010529.91162-10-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: support quota goal_tuner dumping"
        Link: https://lkml.kernel.org/r/20260310010529.91162-11-sj@kernel.org
    "selftests/damon/sysfs.py: test goal_tuner commit"
        Link: https://lkml.kernel.org/r/20260310010529.91162-12-sj@kernel.org
    "mm/damon/core: fix wrong end address assignment on walk_system_ram()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-1-sj@kernel.org
        Link: https://lkml.kernel.org/r/20260311052927.93921-2-sj@kernel.org
        Link: https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org [1]
    "mm/damon/core: support addr_unit on damon_find_biggest_system_ram()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
    "mm/damon/core: verify found biggest system ram"
        Link: https://lkml.kernel.org/r/20260317144725.88524-1-sj@kernel.org
    "mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()"
        Link: https://lkml.kernel.org/r/20260311052927.93921-4-sj@kernel.org
    "mm/damon/core: fix wrong damon_set_regions() argument"
        Link: https://lkml.kernel.org/r/20260314001854.79623-1-sj@kernel.org
    "mm/damon/reclaim: respect addr_unit on default monitoring region setup"
        Link: https://lkml.kernel.org/r/20260311052927.93921-5-sj@kernel.org
    "mm/damon/lru_sort: respect addr_unit on default monitoring region setup"
        Link: https://lkml.kernel.org/r/20260311052927.93921-6-sj@kernel.org

Shigeru Yoshida <syoshida@redhat.com> (1 total)
    "mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()"
        Link: https://lkml.kernel.org/r/20260321132912.93434-1-syoshida@redhat.com

Thomas Ballasi <tballasi@linux.microsoft.com> (1 total)
    "mm: vmscan: add PIDs to vmscan tracepoints"
        Link: https://lkml.kernel.org/r/20260316160908.42727-4-tballasi@linux.microsoft.com

Jinjiang Tu <tujinjiang@huawei.com> (1 total)
    "mm/hugetlb: fix memory offline failure due to hwpoisoned file hugetlb"
        Link: https://lkml.kernel.org/r/20260318020711.3596947-1-tujinjiang@huawei.com

Youngjun Park <youngjun.park@lge.com> (2 total)
    "mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device"
        Link: https://lkml.kernel.org/r/20260323160822.1409904-1-youngjun.park@lge.com
        Link: https://lkml.kernel.org/r/20260323160822.1409904-2-youngjun.park@lge.com
    "mm/swap: remove redundant swap device reference in alloc/free"
        Link: https://lkml.kernel.org/r/20260323160822.1409904-3-youngjun.park@lge.com

zenghongling <zenghongling@kylinos.cn> (1 total)
    "mm/percpu-internal.h: optimise pcpu_chunk_struct to save memory"
        Link: https://lkml.kernel.org/r/20260305073043.571691-1-zenghongling@kylinos.cn

Qi Zheng <zhengqi.arch@bytedance.com> (2 total)
    "mm: memcontrol: refactor mod_memcg_state() and mod_memcg_lruvec_state()"
        Link: https://lkml.kernel.org/r/7f8bd3aacec2270b9453428fc8585cca9f10751e.1772711148.git.zhengqi.arch@bytedance.com
    "mm-memcontrol-convert-objcg-to-be-per-memcg-per-node-type-fix"
        Link: https://lkml.kernel.org/r/20260309112939.31937-1-qi.zheng@linux.dev

teawater <zhuhui@kylinos.cn> (1 total)
    "mm/memcontrol: batch memcg charging in __memcg_slab_post_alloc_hook"
        Link: https://lkml.kernel.org/r/20260320020745.833792-1-hui.zhu@linux.dev

Zi Yan <ziy@nvidia.com> (4 total)
    "selftests/mm: add folio_split() and filemap_get_entry() race test"
        Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
        Link: https://github.com/dfinity/thp-madv-remove-test [2]
        Link: https://lkml.kernel.org/r/20260319190409.294523-1-ziy@nvidia.com
    "selftests-mm-add-folio_split-and-filemap_get_entry-race-test-v4"
        Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
        Link: https://github.com/dfinity/thp-madv-remove-test [2]
        Link: https://lkml.kernel.org/r/20260320142219.375118-1-ziy@nvidia.com
    "selftests-mm-add-folio_split-and-filemap_get_entry-race-test-fix"
        Link: https://lkml.kernel.org/r/D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com
    "selftests/mm: fix sashiko complains on folio_split_race_test"
        Link: https://lkml.kernel.org/r/B0985749-939D-4256-B9B9-C54C0734CF72@nvidia.com



