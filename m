Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3967ACD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7FB6B0095; Thu, 21 May 2026 22:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888526B0096; Thu, 21 May 2026 22:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750F76B0098; Thu, 21 May 2026 22:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF056B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:52:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A4C58FE1A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:52:51 +0000 (UTC)
X-FDA: 84793533342.28.444D30F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 68F741A0004
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:52:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pqqr3yvX;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=50SY6KECMTeon5+dnnwp6H1O79Hb6f/kRHTyXbUxP7M=;
	b=RJSkEvd1GqaEpaF5Fzo1h5GSzpw3DlEF8dBJ2cyBlthF7+nJ3rDrVE2utvyDpo9LnSjLgn
	8SdEiSy/8paVlFN/E/ptF7MiLHr/rQU8JFEtP2HMFMGSwTnjdXdA5R+mZiXzpmDkcVTIab
	S18G0tgQ858owsfhF2OPEgrxARQlSac=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pqqr3yvX;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418369; a=rsa-sha256;
	cv=none;
	b=nHHVs4A4QzRngmMqg3ONT18LxwoNBO47mYyMbGhVTAvgLwkNGyJhBHEqjY35w+nrHooeRD
	OvqeHOuT8ceh4LmNfv46IKSY+2a51rZPlaYQpG/RLQpD6a6NjrHUu51Qpa6fjgbI1CtmAM
	WrddQXyIvj3QRm2zPh4VLLoXxgxMEMI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92FC66021C;
	Fri, 22 May 2026 02:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8121F000E9;
	Fri, 22 May 2026 02:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779418368;
	bh=50SY6KECMTeon5+dnnwp6H1O79Hb6f/kRHTyXbUxP7M=;
	h=Date:From:To:Cc:Subject;
	b=pqqr3yvXTGAc9vOLeulHQya69SLqam/44N/sFc2J24PX7ax+U/NkhbosF4nRSaWkX
	 WhufR7iPTcnIPzKilvJlkMSRWiFoCiJ2OwwpwBqtBWz4NnFwCgjxJqnfydumvZiueP
	 XVXTtraskdZycsV8Gcdas7UPH/+VBuHN8iaMMLZU=
Date: Thu, 21 May 2026 19:52:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>
Subject: mm.git review status at 7.1-rc4
Message-Id: <20260521195246.c562b881be1d4881a19a9d28@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 68F741A0004
X-Stat-Signature: xk4zumisuuae9nbcb3h811i3nqauft3p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779418369-210497
X-HE-Meta: U2FsdGVkX19JtWpVVFoZ2EtUUZZdw/+cke76cA4RbXYTeaO9Ro8JPVySBth57xWqnBFsfcpWTc9kb5Ufo6sme0ECkyWBYNP+2n7nebOMli0qUXDWKSDBlCxGqAFNp0anZEAyqsk7v51bNJfTDcj0xmqbXyi+Zh6W1f6vduur3PjmynB+c9MHeOzoabOZvdbvZ7LQUwTL6Quc+Xv/J3tddISElDRStCPZ3JredC7gqq3Wq7Y/zR0FnqNT2ERdUuxx/f0N+6SRtZq2dUR268dQOJu3VALI5VnWRwpmz9DsdUOkPTOJj/zjuioY1NNUT+kEChka43cTslsAZsJJX1QI4TaPkV3w43Mubkl+4qWorV3qYVSxlRao2xRFZqfK+5R3KqDQGmlVxwmfYgJvcpzcWsgHq1+WF1vQv5o/S7tZ5EpZavz04yXcdHP1CIp77ZJb+lI3b07qZ29b1Q4nEewfnHM31vmgho56YO1f+HZb0DjiXElY+bTODyeyU1yUrZRRaZGRCTtUtIhkYu1oqlLl8szqWXdUiMCKRkZ+eOtH90J84oAye6BIbb06vFfHZUXZ2xPw49v2AJ7uRzHXnIocopNKx8NHiIj712aS9ezTeqg4TFpithglWmjz5e5v9CYL2KaZIisxHSCj0FxKZKH3Y0SvgzjT0cvUyJugif+3iwTXdAdbBE7Yv+Q2yxWSH9sOM+Jl2rn83ma2XetwLHLJRgXtgWTXUfbmlB0FZ4/LsIf6iRV3Mx8SR/GsIf2wf5NyVxfQFwqPJGck9Vc/aOKUR7gK1p1SdzFu7pEvYKEG3JfWR6bFZWAx04IWoA/VryRv+NAX1cfGe0OU5e1aFvEnzo8+GFrYJ4P/3/J5QU1CgOae07Y9rY8lq13wpBtZI1R3v4wYqBduBtwezd/285YDBHVs6FGWWVRai0m8nxNHcEX+3hcLjVQg8sLAylxmjURdHUwBT7mwvF31BKtIbzv
 WyPCbF3V
 K7t4ym3r5DAASMQlweJ13hC8lhg8nYJPqqGLoVWquKFPQUcjlRzn7DxpWWAnkriupb3Vy41WssMYnu37HdsKBa/O+JEvORgcRRgNEYVe6S+gXnCFvbG1wsWK20eO5ITm6ag1kDyH5PeWLcyMyKRQMN4GDndh0kerI+vLL4wTP8PJfMe9/7O8+v0a5jP5wMBGY9nbZU1mMnGcd1ouUu9uAD4mMtiyZ+IV1FDmSxmcMZ2UGQfW1l69AQ0GuxgtmI3CuUIG25WaOJug/lVIc1pmvoYtggQwuYYvF/XOmaESqymOYgBGLvJMuhgYMT+rqFjlBpGunZ4mqaon1TEAx9fDca5lMwl7BABd+uHKAvXIPrUO0kGg1jLugvVnOsLs8xzdbe0cNlo8FxhHm5vgJY7dE7okyomVKGlJuWw03ArVD/G5Hh8jEZBuKMpdHvqxfaNd9rL9+O40XnyZCV/WEVsVDj30+m2EEqGM5CZjLf3ZVVu7qI2lbjC/h/numW7rds9wRNixxQgAetkiiChs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Things seem more hectic than usual (if that's possible), with travel,
conferences, etc.  I'm feeling a need to slow down, consolidate,
stabilize.  Others are of course free to disagree!

I'm feeling a bit more disorganized this time due to having spent four
out of five weeks traveling.  So if you think I've missed things or
have otherwise messed up, you're surely correct.  Please tell me
asap.

We're closing in on 400 patches this time, which is a little more than
usual.

I believe that the extended "quiet period' last cycle was helpful,
although perhaps a little too long and severe.  Opinions on this are
also sought.

Maybe this is how things *should* be?  Four weeks of enormous merge
flurry then four weeks of diligently picking through it all, getting
things mainline-worthy?  After all, that's what Linus does, with
different values of "four".


Next week I'll commence moving material into mm-stable.  Nagging will
be involved, to get outstanding issues wrapped up and sometimes to
request additional review.

I'll attempt to base our for-7.2-rc1 merge on 7.1-rc5.  Sometimes
intrusive hotfixes come in and mess that up so I may base on something
later, we'll see.

And next week I'd like to slow down on the new material, please.  I'll
of course pay more attention to material which has been out there for a
while and which comes well-reviewed.

I'll give preference to fixes (as always), documentation, selftests,
etc - smaller and/or less risky things.


Mike's "make MM selftests more CI friendly" series messed up our review
statistics because it's huge and because selftest patches appropriately
receive less attention.  So I added an "excluding selftests" category
to the report.

Please eyeball the below and identify patches which you can help to
review (and test!), thanks.




mm.git review status for mm-hotfixes-stable..mm-new

Everything:

Total patches:       375
Reviews/patch:       1.36
Reviewed rate:       64%

Excluding DAMON:

Total patches:       298
Reviews/patch:       1.66
Reviewed rate:       76%

Excluding DAMON and selftests:

Total patches:       204
Reviews/patch:       2.02
Reviewed rate:       85%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (3 total)
    "selftests-mm-check-file-initialization-writes-in-split_huge_page_test-fix"
    "mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix"
    "mm-swap-pm-hibernate-atomically-replace-hibernation-pin-checkpatch-fixes"

Alistair Popple <apopple@nvidia.com> (1 total)
    "arm64: mm: call pagetable dtor when freeing hot-removed page tables"
        Link: https://lore.kernel.org/20260521032730.2104017-1-apopple@nvidia.com

Barry Song (Xiaomi) <baohua@kernel.org> (1 total)
    "mm/mglru: use folio_mark_accessed to replace folio_set_active in PF"
        Link: https://lore.kernel.org/20260418120233.7162-1-baohua@kernel.org

David Carlier <devnexen@gmail.com> (1 total)
    "mm/swap, PM: hibernate: atomically replace hibernation pin"
        Link: https://lore.kernel.org/20260430195651.287659-1-devnexen@gmail.com

Frederick Mayle <fmayle@google.com> (2 total)
    "mm/readahead: add kerneldoc for read_pages"
        Link: https://lore.kernel.org/20260512203154.754075-2-fmayle@google.com
    "mm/readahead: simplify page_cache_ra_unbounded loop counter reset"
        Link: https://lore.kernel.org/20260512203154.754075-3-fmayle@google.com

Hao Ge <hao.ge@linux.dev> (1 total)
    "mm/alloc_tag: replace fixed-size early PFN array with dynamic linked list"
        Link: https://lore.kernel.org/20260506022256.32664-1-hao.ge@linux.dev

Brendan Jackman <jackmanb@google.com> (2 total)
    "drm/managed: use special gfp_t format specifier"
        Link: https://lore.kernel.org/20260326-gfp64-v2-0-d916021cecdf@google.com
        Link: https://lore.kernel.org/20260326-gfp64-v2-1-d916021cecdf@google.com
    "mm/kfence: use special gfp_t format specifier"
        Link: https://lore.kernel.org/20260326-gfp64-v2-3-d916021cecdf@google.com

Joonwon Kang <joonwonkang@google.com> (3 total)
    "percpu: do not trust hint starts when they are not set"
        Link: https://lore.kernel.org/20260513085117.1024175-2-joonwonkang@google.com
    "percpu: introduce struct pcpu_region"
        Link: https://lore.kernel.org/all/aegQgyf3KuIZMK9x@palisades.local/
        Link: https://lore.kernel.org/20260513085117.1024175-3-joonwonkang@google.com
    "percpu: fix hint invariant breakage"
        Link: https://lore.kernel.org/20260513085117.1024175-4-joonwonkang@google.com

Jose Fernandez (Anthropic) <jose.fernandez@linux.dev> (1 total)
    "mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host"
        Link: https://lore.kernel.org/20260504-swap-cgroup-fix-7-0-v1-1-f53ff41ee553@linux.dev
        Link: https://lore.kernel.org/r/69859728.050a0220.3b3015.0033.GAE@google.com

JP Kobryn (Meta) <jp.kobryn@linux.dev> (1 total)
    "mm/compaction: cap compact_gap() at COMPACT_CLUSTER_MAX"
        Link: https://lore.kernel.org/20260519200851.141955-1-jp.kobryn@linux.dev

Kairui Song <kasong@tencent.com> (4 total)
    "mm, swap: avoid leaving unused extend table after alloc race"
        Link: https://lore.kernel.org/20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com
    "mm-swap-avoid-leaving-unused-extend-table-after-alloc-race-v2"
        Link: https://lore.kernel.org/20260515-swap-extend-table-fix-v2-1-833d72ad53e5@tencent.com
    "mm, swap: add support for stable large allocation in swap cache directly"
        Link: https://lore.kernel.org/20260517-swap-table-p4-v5-4-88ae43e064c7@tencent.com
    "mm, swap: unify large folio allocation"
        Link: https://lore.kernel.org/20260517-swap-table-p4-v5-5-88ae43e064c7@tencent.com

Lance Yang <lance.yang@linux.dev> (1 total)
    "x86/tlb: skip redundant sync IPIs for native TLB flush"
        Link: https://lore.kernel.org/20260424062528.71951-3-lance.yang@linux.dev

Breno Leitao <leitao@debian.org> (1 total)
    "selftests/mm: add kmemleak verbose dedup test"
        Link: https://lore.kernel.org/20260506-kmemleak_dedup-v3-2-2d36aafc34da@debian.org

Guangshuo Li <lgs201920130244@gmail.com> (1 total)
    "device-dax: fix refcount leak in __devm_create_dev_dax() error path"
        Link: https://lore.kernel.org/20260412070010.2402830-1-lgs201920130244@gmail.com

Qiang Liu <liuqiang@kylinos.cn> (1 total)
    "lib/test_hmm: check alloc_page_vma() return value and handle OOM"
        Link: https://lore.kernel.org/20260521021858.21511-1-liuqiangneo@163.com

Lorenzo Stoakes <ljs@kernel.org> (1 total)
    "mm-hugetlb-avoid-false-positive-lockdep-assertion-fix"
        Link: https://lore.kernel.org/agWZsPGYid08uU6O@lucifer

Nico Pache <npache@redhat.com> (2 total)
    "mm/khugepaged: add per-order mTHP collapse failure statistics"
        Link: https://lore.kernel.org/20260511185817.686831-9-npache@redhat.com
    "mm/khugepaged: introduce mTHP collapse support"
        Link: https://lore.kernel.org/20260511185817.686831-12-npache@redhat.com

Mike Rapoport (Microsoft) <rppt@kernel.org> (34 total)
    "userfaultfd: snapshot VMA state across UFFDIO_COPY retry"
        Link: https://lore.kernel.org/20260519052516.3315196-1-rppt@kernel.org
    "selftests/mm: khugepaged: group tests in an array"
        Link: https://lore.kernel.org/20260511162840.375890-14-rppt@kernel.org
    "selftests/mm: khugepaged: use kselftest framework"
        Link: https://lore.kernel.org/20260511162840.375890-15-rppt@kernel.org
    "selftests/mm: protection_keys: use kselftest framework"
        Link: https://lore.kernel.org/20260511162840.375890-18-rppt@kernel.org
    "selftests/mm: uffd-common: use kselftest framework"
        Link: https://lore.kernel.org/20260511162840.375890-19-rppt@kernel.org
    "selftests/mm: add atexit() and signal handlers to thp_settings"
        Link: https://lore.kernel.org/20260511162840.375890-23-rppt@kernel.org
    "selftests/mm: rename thp_settings.[ch] to hugepage_settings.[ch]"
        Link: https://lore.kernel.org/20260511162840.375890-24-rppt@kernel.org
    "selftests/mm: move HugeTLB helpers to hugepage_settings"
        Link: https://lore.kernel.org/20260511162840.375890-25-rppt@kernel.org
    "selftests/mm: hugepage_settings: use unsigned long in detect_hugetlb_page_size"
        Link: https://lore.kernel.org/20260511162840.375890-26-rppt@kernel.org
    "selftests/mm: hugepage_settings: rename and rework get_free_hugepages()"
        Link: https://lore.kernel.org/20260511162840.375890-28-rppt@kernel.org
    "selftests/mm: move read_file(), read_num() and write_num() to vm_util"
        Link: https://lore.kernel.org/20260511162840.375890-30-rppt@kernel.org
    "selftests/mm: vm_util: add helpers to set and restore shm limits"
        Link: https://lore.kernel.org/20260511162840.375890-31-rppt@kernel.org
    "selftests/mm: compaction_test: use HugeTLB helpers ..."
        Link: https://lore.kernel.org/20260511162840.375890-32-rppt@kernel.org
    "selftests/mm: cow: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-33-rppt@kernel.org
    "selftests/mm: gup_longterm: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-34-rppt@kernel.org
    "selftests/mm: gup_test: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-35-rppt@kernel.org
    "selftests/mm: hmm-tests: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-36-rppt@kernel.org
    "selftests/mm: hugepage_dio: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-37-rppt@kernel.org
    "selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-38-rppt@kernel.org
    "selftests/mm: hugetlb-madvise: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-39-rppt@kernel.org
    "selftests/mm: hugetlb_madv_vs_map: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-40-rppt@kernel.org
    "selftests/mm: hugetlb-mremap: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-42-rppt@kernel.org
    "selftests/mm: hugetlb-shm: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-43-rppt@kernel.org
    "selftests/mm: hugetlb-soft-offline: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-44-rppt@kernel.org
    "selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-45-rppt@kernel.org
    "selftests/mm: migration: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-46-rppt@kernel.org
    "selftests/mm: pagemap_ioctl: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-47-rppt@kernel.org
    "selftests/mm: protection_keys: use library code for HugeTLB setup"
        Link: https://lore.kernel.org/20260511162840.375890-48-rppt@kernel.org
    "selftests/mm: thuge-gen: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-49-rppt@kernel.org
    "selftests/mm: uffd-stress: use hugetlb_save and alloc huge pages"
        Link: https://lore.kernel.org/20260511162840.375890-50-rppt@kernel.org
    "selftests/mm: uffd-unit-tests: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-51-rppt@kernel.org
    "selftests/mm: uffd-wp-mremap: add setup of HugeTLB pages"
        Link: https://lore.kernel.org/20260511162840.375890-52-rppt@kernel.org
    "selftests/mm: run_vmtests.sh: free memory if available memory is low"
        Link: https://lore.kernel.org/20260511162840.375890-55-rppt@kernel.org
    "selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB"
        Link: https://lore.kernel.org/20260511162840.375890-56-rppt@kernel.org

Sayali Patil <sayalip@linux.ibm.com> (5 total)
    "selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh"
        Link: https://lore.kernel.org/fb57491ba83cb0a499c72922e1579b61bee514db.1779296493.git.sayalip@linux.ibm.com
    "selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap"
        Link: https://lore.kernel.org/367644df45c65098f23e3945c6a80f4b8a8964a6.1779296493.git.sayalip@linux.ibm.com
    "selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported"
        Link: https://lore.kernel.org/c3c5af76d71d5f4446f773f4de94882efc33ebe4.1779296493.git.sayalip@linux.ibm.com
    "selftests/mm: use ksft_exit_skip() instead of KSFT_SKIP in uffd-stress"
        Link: https://lore.kernel.org/88202b56-1dc5-43e2-9d1f-a0823a9531f0@linux.ibm.com
    "selftests/mm: clarify alternate unmapping in compaction_test"
        Link: https://lore.kernel.org/da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com

SeongJae Park <sj@kernel.org> (64 total)
    "mm/damon/core: make charge_addr_from aware of end-address exclusivity"
        Link: https://lore.kernel.org/20260428042942.118230-1-sj@kernel.org
    "mm/damon/core: handle <min_region_sz remaining quota as empty"
        Link: https://lore.kernel.org/20260428013402.115171-1-sj@kernel.org
        Link: https://lore.kernel.org/20260428013402.115171-2-sj@kernel.org
    "mm/damon/core: merge regions after applying DAMOS schemes"
        Link: https://lore.kernel.org/20260428013402.115171-3-sj@kernel.org
    "mm/damon/core: introduce failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-4-sj@kernel.org
    "mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files"
        Link: https://lore.kernel.org/20260428013402.115171-5-sj@kernel.org
    "Docs/mm/damon/design: document fail_charge_{num,denom}"
        Link: https://lore.kernel.org/20260428013402.115171-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files"
        Link: https://lore.kernel.org/20260428013402.115171-7-sj@kernel.org
    "Docs/ABI/damon: document fail_charge_{num,denom}"
        Link: https://lore.kernel.org/20260428013402.115171-8-sj@kernel.org
    "mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing"
        Link: https://lore.kernel.org/20260428013402.115171-9-sj@kernel.org
    "selftests/damon/_damon_sysfs: support failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-10-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-11-sj@kernel.org
    "selftests/damon/sysfs.py: test failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-12-sj@kernel.org
    "Docs/mm/damon/maintainer-profile: add AI review usage guideline"
        Link: https://lore.kernel.org/20260412211932.89038-1-sj@kernel.org
    "mm/damon/core: introduce damon_ctx->paused"
        Link: https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org
        Link: https://lore.kernel.org/20260427151231.113429-2-sj@kernel.org
    "mm/damon/sysfs: add pause file under context dir"
        Link: https://lore.kernel.org/20260427151231.113429-3-sj@kernel.org
    "Docs/mm/damon/design: update for context pause/resume feature"
        Link: https://lore.kernel.org/20260427151231.113429-4-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update for pause file"
        Link: https://lore.kernel.org/20260427151231.113429-5-sj@kernel.org
    "Docs/ABI/damon: update for pause sysfs file"
        Link: https://lore.kernel.org/20260427151231.113429-6-sj@kernel.org
    "mm/damon/tests/core-kunit: test pause commitment"
        Link: https://lore.kernel.org/20260427151231.113429-7-sj@kernel.org
    "selftests/damon/_damon_sysfs: support pause file staging"
        Link: https://lore.kernel.org/20260427151231.113429-8-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: dump pause"
        Link: https://lore.kernel.org/20260427151231.113429-9-sj@kernel.org
    "selftests/damon/sysfs.py: check pause on assert_ctx_committed()"
        Link: https://lore.kernel.org/20260427151231.113429-10-sj@kernel.org
    "selftests/damon/sysfs.py: pause DAMON before dumping status"
        Link: https://lore.kernel.org/20260427151231.113429-11-sj@kernel.org
    "mm/damon: introduce damon_set_region_system_rams_default()"
        Link: https://lore.kernel.org/20260429041232.90257-1-sj@kernel.org
        Link: https://lore.kernel.org/20260429041232.90257-2-sj@kernel.org
    "mm/damon/reclaim: cover all system rams"
        Link: https://lore.kernel.org/20260429041232.90257-3-sj@kernel.org
    "mm/damon/lru_sort: cover all system rams"
        Link: https://lore.kernel.org/20260429041232.90257-4-sj@kernel.org
    "mm/damon/core: remove damon_set_region_biggest_system_ram_default()"
        Link: https://lore.kernel.org/20260429041232.90257-5-sj@kernel.org
    "mm/damon/stat: use damon_set_region_system_rams_default()"
        Link: https://lore.kernel.org/20260429041232.90257-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/reclaim: update for entire memory monitoring"
        Link: https://lore.kernel.org/20260429041232.90257-7-sj@kernel.org
    "Docs/admin-guide/mm/damon/lru_sort: update for entire memory monitoring"
        Link: https://lore.kernel.org/20260429041232.90257-8-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: mark scheme filters sysfs dir as deprecated"
        Link: https://lore.kernel.org/20260429150309.82282-1-sj@kernel.org
        Link: https://lore.kernel.org/20260429150309.82282-2-sj@kernel.org
    "Docs/ABI/damon: mark schemes/<S>/filters/ deprecated"
        Link: https://lore.kernel.org/20260429150309.82282-3-sj@kernel.org
    "mm/damon/reclaim: add autotune_monitoring_intervals parameter"
        Link: https://lore.kernel.org/20260501011740.81988-1-sj@kernel.org
        Link: https://lore.kernel.org/20260501011740.81988-2-sj@kernel.org
    "Docs/admin-guide/mm/damon/reclaim: update for autotune_monitoring_intervals"
        Link: https://lore.kernel.org/20260501011740.81988-3-sj@kernel.org
    "mm/damon/stat: add a parameter for reading kdamond pid"
        Link: https://lore.kernel.org/20260502020505.80822-1-sj@kernel.org
        Link: https://lore.kernel.org/20260502020505.80822-2-sj@kernel.org
    "Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter"
        Link: https://lore.kernel.org/20260502020505.80822-3-sj@kernel.org
    "mm/damon/core: introduce struct damon_probe"
        Link: https://lore.kernel.org/20260518234119.97569-1-sj@kernel.org
        Link: https://lore.kernel.org/20260518234119.97569-2-sj@kernel.org
    "mm/damon/core: embed damon_probe objects in damon_ctx"
        Link: https://lore.kernel.org/20260518234119.97569-3-sj@kernel.org
    "mm/damon/core: introduce damon_filter"
        Link: https://lore.kernel.org/20260518234119.97569-4-sj@kernel.org
    "mm/damon/core: commit probes"
        Link: https://lore.kernel.org/20260518234119.97569-5-sj@kernel.org
    "mm/damon/core: introduce damon_region->probe_hits"
        Link: https://lore.kernel.org/20260518234119.97569-6-sj@kernel.org
    "mm/damon/core: introduce damon_ops->apply_probes"
        Link: https://lore.kernel.org/20260518234119.97569-7-sj@kernel.org
    "mm/damon/core: do data attributes monitoring"
        Link: https://lore.kernel.org/20260518234119.97569-8-sj@kernel.org
    "mm/damon/paddr: support data attributes monitoring"
        Link: https://lore.kernel.org/20260518234119.97569-9-sj@kernel.org
    "mm/damon/sysfs: implement probes dir"
        Link: https://lore.kernel.org/20260518234119.97569-10-sj@kernel.org
    "mm/damon/sysfs: implement probe dir"
        Link: https://lore.kernel.org/20260518234119.97569-11-sj@kernel.org
    "mm/damon/sysfs: implement filters directory"
        Link: https://lore.kernel.org/20260518234119.97569-12-sj@kernel.org
    "mm/damon/sysfs: implement filter dir"
        Link: https://lore.kernel.org/20260518234119.97569-13-sj@kernel.org
    "mm/damon/sysfs: implement filter dir files"
        Link: https://lore.kernel.org/20260518234119.97569-14-sj@kernel.org
    "mm/damon/sysfs: setup probes on DAMON core API parameters"
        Link: https://lore.kernel.org/20260518234119.97569-15-sj@kernel.org
    "mm/damon/sysfs-schemes: implement tried_regions/<r>/probes/"
        Link: https://lore.kernel.org/20260518234119.97569-16-sj@kernel.org
    "mm/damon/sysfs-schemes: implement probe dir"
        Link: https://lore.kernel.org/20260518234119.97569-17-sj@kernel.org
    "mm/damon/sysfs-schemes: implement probe/hits file"
        Link: https://lore.kernel.org/20260518234119.97569-18-sj@kernel.org
    "mm/damon: trace probe_hits"
        Link: https://lore.kernel.org/20260518234119.97569-19-sj@kernel.org
    "selftests/damon/sysfs.sh: test probes dir"
        Link: https://lore.kernel.org/20260518234119.97569-20-sj@kernel.org
    "Docs/mm/damon/design: document data attributes monitoring"
        Link: https://lore.kernel.org/20260518234119.97569-21-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document data attributes monitoring"
        Link: https://lore.kernel.org/20260518234119.97569-22-sj@kernel.org
    "mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG"
        Link: https://lore.kernel.org/20260518234119.97569-23-sj@kernel.org
    "mm/damon/paddr: support DAMON_FILTER_TYPE_MEMCG"
        Link: https://lore.kernel.org/20260518234119.97569-24-sj@kernel.org
    "mm/damon/sysfs: add filters/<F>/path file"
        Link: https://lore.kernel.org/20260518234119.97569-25-sj@kernel.org
    "mm/damon/sysfs-schemes: move memcg_path_to_id() to sysfs-common"
        Link: https://lore.kernel.org/20260518234119.97569-26-sj@kernel.org
    "mm/damon/sysfs: setup damon_filter->memcg_id from path"
        Link: https://lore.kernel.org/20260518234119.97569-27-sj@kernel.org
    "Docs/mm/damon/design: update for memcg damon filter"
        Link: https://lore.kernel.org/20260518234119.97569-28-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update for memcg damon filter"
        Link: https://lore.kernel.org/20260518234119.97569-29-sj@kernel.org

Tal Zussman <tz2294@columbia.edu> (1 total)
    "MAINTAINERS: add more files to PAGE CACHE section"
        Link: https://lore.kernel.org/20260520-page-cache-maintainers-v1-1-f93438d2186d@columbia.edu

Wang Wensheng <wsw9603@163.com> (1 total)
    "kasan/test: only do kmalloc_double_kzfree for generic mode"
        Link: https://lore.kernel.org/20260517071713.353579-1-wsw9603@163.com

Zi Yan <ziy@nvidia.com> (2 total)
    "selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged"
        Link: https://lore.kernel.org/20260517135416.1434539-12-ziy@nvidia.com
    "selftests/mm: add writable-file collapse tests for khugepaged"
        Link: https://lore.kernel.org/20260517135416.1434539-15-ziy@nvidia.com

Yilin Zhu <zylzyl2333@gmail.com> (1 total)
    "ipc/shm: serialize orphan cleanup with shm_nattch updates"
        Link: https://lore.kernel.org/9d97cc1031de2d0bace0edf3a668818aa2f4eca6.1777410234.git.zylzyl2333@gmail.com



