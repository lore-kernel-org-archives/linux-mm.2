Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7F3CD6E75
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 01:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E3E6B008A; Thu,  4 Jun 2026 21:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E8A6B008C; Thu,  4 Jun 2026 21:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B8E6B0092; Thu,  4 Jun 2026 21:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4323A6B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:07:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BB181C1E32
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:07:45 +0000 (UTC)
X-FDA: 84844071690.25.2649E49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1108D80008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 01:07:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N/0+lD+7";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780621663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6Gg1wHz+7cN1hY8/vVyTvoUinFijgJCfIbH3WJD0eTw=;
	b=ZJdmXiIEnkJSnEVwtE0JeW0x2+BY3WscyPVbKYabyX1vaAu9ZgcMr25A8aqXLhK58xhCAM
	UzZdut4nDRWN7/EvUMQeI8i8BJMQiHi6syOUbtUnoBmSyoUBbCPAmtdej+7U+4PNn0HdmM
	lcYXGQqxCcQN0qgJab8E9iqL9sbMKwg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="N/0+lD+7";
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780621663;
	b=EftZWObmShZS/J3tN4EVLdFfhVeJZ4V5vdbzbzTZDJEHEBq6jCeoQMVEnh4yBF1QA5R+KA
	0oqlNP2pPBrKM/WMk8GwbpnCzf2dgrREnoVzNpfwnSUogW6SVk6MHSFYOKU/bmi943cQan
	I5ZNM/LtO3Jnc4KtEWlRQpP1KK08sFM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48D3A60052;
	Fri,  5 Jun 2026 01:07:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C781F00893;
	Fri,  5 Jun 2026 01:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780621662;
	bh=6Gg1wHz+7cN1hY8/vVyTvoUinFijgJCfIbH3WJD0eTw=;
	h=Date:From:To:Cc:Subject;
	b=N/0+lD+7WaDvS1ogFVC+m7NAeo3h5DJX95hr8w31IT+Yly5klFHkHXqlr1n1zhpbn
	 HKbRzEoLcw/AC60sppeTsc4ICRUNT2GHuENpJu/tBCkCXk6q56o1yhZuF0y109/2aj
	 XiO7VY1GQVtIfFehofkqpMMHA9ifzxQLDu47pRK8=
Date: Thu, 4 Jun 2026 18:07:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm.git review status at 7.1.rc6
Message-Id: <20260604180740.f0efbf05dbd9e5f6e456c630@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1108D80008
X-Stat-Signature: tzpkba6mm9e5xd4jx5c8b37nyumy4hi3
X-Rspam-User: 
X-HE-Tag: 1780621662-866041
X-HE-Meta: U2FsdGVkX1+XnYASuYHeDzGvD6PY2siIs1PGuFbw5Z0nxss5UAftWtS3yi9JSqgQcgjS0xgTVpyIy9+W/66Gdo30N23EEGVoNsQxMycAiBB0zOBFrHJ9805oFPi+IMLVCnLFZYXdFYWn6N73OLRbrbY80BkW+d6wxzNm2k78tw07m49FbRlmJBLAVaWmU9tRrOhfBi6iC8GUA/9WiBzX2SFwg18kl25Gob1lmmKQNgOgTspnTF8wruCP2zacQYHFeAuxUbA/pbM8noauvEZD8vvI25+ryP+62CLRAtS5UnVRtqo9/4RTjQBKGt8NQF/o8HhqLl1MB0Ewj3JwAHHwWaVlu6kyPwaYMbjWV4GImgZeIQUdPrw/MKhqNhSFp/A72pnCqvqsF9T4Rq/SaPI33yqk3AuFRfaZtdpZqxHo2TbTP4Lb5OmFEhVii9b2NyyP3d+Dtm2xrircd7YWkoUb3A0VW8deVPNefj3DDtVP3XkHPsYVco8NkfNXUXuf6nu2F5sgWLKC9xbfNH2vr78rqRB6l6CJ9x12gNmU+y9vZ70DdVz/PNd3p/eCecDP+vFjKSAYKf4vBxsyeCDUm06sclTM2zIkwJg3MjaLx2s0PGYQ64z8WjKOboWNlZw6XQioDLCUYgTjoF/Y8B7DVJohfXae4IKG5PC4CGfLfqSpXCna1bPVvq9lfptRczXixj9tJxBXpmwGIwkv9SplWX7+lKZCUtiFm9ySXe3/AypMjNP6c150gSA0B3NXAaCHvkmPX43lnARdr9mC1mMmD6DfR37FZ6kh3EHh9MdFEYTnV3+4CdacdzwsKSrzXWZ5Dd2mRVD42Cjw5OxVK/DbJ/ZfqCaaMTNr1GrYyB5L1l2ABKHkqS+l+cPaLlUExIbzr2D+W2vYCKU5+tXRtUvoJD1I4m4sBJccEzOukZhYlTcV2zRXlu04oTH3s1cMBsjqNUn1mamJUMv0xrKLD5YRubl
 wElQOCXe
 LzlY1i7g+5tAxzYmiQPsnNJwTpUkgzQ8VPaduuWRT5f9FYh7WSTVnnlo9IgMcN1SE/P35t+ySbeubdupTy3xXO73BPFPR/4cb0B405kwXXk236BqvvSkooyFlgoKulEuaORu8VgkmGhVerQBjVOQx3ew00UMLZlSZc2Ve+hjiizWuqzWE19GnWUsYtSsb2Q1fRIjODRyVAwap2FVbrL9xNAXtnEYcvst4EwsrNTVq6PG1oKv/Nmfy7X1HJJzgBaUIlspm5Y0kOn6CXV9c49KJbAr4HRC7ysLgFIcVX9nszaOmzeNb2uWthGifLs21vdrC3QFcIohxNBo4er1ZIA6JCF2TA1j+2v8GR6SZTJylu2Pz+sEFki6z57aQAa1hD7iB7sdKpvIQP0rZDdhIB876yc5Q2ZcgN8Fdc8qrjNC80Sytfdoo2rEPlnISRWsgzpAcx1FfzuMUI0T00a+KgkJs5CboLmfWAAe8zQZNjsdQAaUH+O/+JMfVTIdnIsgqolkexkleSb1IMKbeCX5n0xVWphg/ll8mrEk6Rujn0U1vEyNH+vKiqN6gy5kgtX0eV0nNa8tMPaQhMOqmPMEOPQO0US1KrJ3AQRi8ixS/jnARvbB7Lj7wCLnDEE2ijeM2mHyYAdXylqNiMdEgyF2gf31zYwMLUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


282 patches are in mm-stable.

I'll add another 40 this week, then that's it for the first week of the
merge window.

Those 40 can be seen in
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/pc/devel-series,
preceding "Second week of merge window".  Approximately - this stuff
changes all the time.


The remaining 110 patches are all churning around due to uncertainty
over Nico's series "khugepaged: add mTHP collapse support".  I'll add
some or all of these to mm-stable mid merge window with a plan to
upstream them in the second week.

If Nico's series ends up being deferred then redoing Zi Yan's "Remove
CONFIG_READ_ONLY_THP_FOR_FS and enable file THP for writable files
series will be a simple matter.  Fixing up Mike's "make MM selftests
more CI friendly" series will be more involved.


Stats for the mm-stable patches:

	mm.git review status for mm-hotfixes-stable..mm-stable

	Everything:

	Total patches:       281
	Reviews/patch:       1.42
	Reviewed rate:       65%

	Excluding DAMON:

	Total patches:       187
	Reviews/patch:       2.05
	Reviewed rate:       89%

	Excluding DAMON and selftests:

	Total patches:       164
	Reviews/patch:       2.13
	Reviewed rate:       90%

New Reviewed-by:/Acked-by: tags for mm-stable patches are welcome but
I'd prefer not to rebase to add these.  But I'll rebase for Nacked-by:!




The patches which are still in quilt form (mm-unstable and mm-new) are
below.  Review is pretty decent, with some holes.  Please do scan the
below list and see if there are things which you have time to look
over.

	mm.git review status for mm-stable..mm-new

	Everything:

	Total patches:       165
	Reviews/patch:       1.50
	Reviewed rate:       65%

	Excluding DAMON:

	Total patches:       163
	Reviews/patch:       1.52
	Reviewed rate:       66%

	Excluding DAMON and selftests:

	Total patches:       90
	Reviews/patch:       2.23
	Reviewed rate:       84%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org> (1 total)
    "mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse-fix-2"

Alistair Popple <apopple@nvidia.com> (1 total)
    "arm64: mm: call pagetable dtor when freeing hot-removed page tables"
        Link: https://lore.kernel.org/20260521032730.2104017-1-apopple@nvidia.com

Baoquan He <baoquan.he@linux.dev> (1 total)
    "MAINTAINERS: update Baoquan He's email address"
        Link: https://lore.kernel.org/20260528131454.1996752-1-baoquan.he@linux.dev

Dev Jain <dev.jain@arm.com> (1 total)
    "selftests/mm/hmm-tests: test pagemap reads of PMD device-private entries"
        Link: https://lore.kernel.org/20260604055308.1947679-3-dev.jain@arm.com

David Carlier <devnexen@gmail.com> (1 total)
    "mm/swap, PM: hibernate: atomically replace hibernation pin"
        Link: https://lore.kernel.org/20260430195651.287659-1-devnexen@gmail.com

Markus Elfring <elfring@users.sourceforge.net> (1 total)
    "zsmalloc: simplify data output in zs_stats_size_show()"
        Link: https://lore.kernel.org/126a924b-6f68-43bf-ae5a-449fb93e527b@web.de

Kiryl Shutsemau (Meta) <kas@kernel.org> (1 total)
    "fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()"
        Link: https://lore.kernel.org/20260529172331.356655-4-kas@kernel.org

Guangshuo Li <lgs201920130244@gmail.com> (1 total)
    "device-dax: fix refcount leak in __devm_create_dev_dax() error path"
        Link: https://lore.kernel.org/20260412070010.2402830-1-lgs201920130244@gmail.com

Qiang Liu <liuqiang@kylinos.cn> (1 total)
    "lib/test_hmm: check alloc_page_vma() return value and handle OOM"
        Link: https://lore.kernel.org/20260521021858.21511-1-liuqiangneo@163.com
        Link: https://lore.kernel.org/oe-kbuild-all/202606011329.zWs2BKy4-lkp@intel.com/

Nico Pache <npache@redhat.com> (3 total)
    "mm/khugepaged: introduce mTHP collapse support"
        Link: https://lore.kernel.org/20260522150009.121603-12-npache@redhat.com
    "fix potential use-after-free of vma in mthp_collapse()"
        Link: https://lore.kernel.org/2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com
    "add back note and edit doc about khugepaged limits"
        Link: https://lore.kernel.org/b457f6e9-ae12-4e1f-8484-f3043ca62276@redhat.com

Oscar Salvador <osalvador@suse.de> (1 total)
    "arch,x86: skip setting align_offset for hugetlb mappings"
        Link: https://lore.kernel.org/20260601125015.216110-1-osalvador@suse.de

Mike Rapoport (Microsoft) <rppt@kernel.org> (33 total)
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

Jianlin Shi <shijianlin11@foxmail.com> (1 total)
    "mm/page_alloc: only update NUMA min ratios on sysctl write"
        Link: https://lore.kernel.org/tencent_5891052AF9A4C2D490A62F478D446F74AB09@qq.com

SeongJae Park <sj@kernel.org> (2 total)
    "mm/damon/reclaim: handle ctx allocation failure"
        Link: https://lore.kernel.org/20260529000104.7006-2-sj@kernel.org
    "mm/damon/lru_sort: handle ctx allocation failure"
        Link: https://lore.kernel.org/20260529000104.7006-3-sj@kernel.org

Zi Yan <ziy@nvidia.com> (2 total)
    "selftests/mm: remove READ_ONLY_THP_FOR_FS in khugepaged"
        Link: https://lore.kernel.org/20260517135416.1434539-12-ziy@nvidia.com
    "selftests/mm: add writable-file collapse tests for khugepaged"
        Link: https://lore.kernel.org/20260517135416.1434539-15-ziy@nvidia.com

Yilin Zhu <zylzyl2333@gmail.com> (1 total)
    "ipc/shm: serialize orphan cleanup with shm_nattch updates"
        Link: https://lore.kernel.org/9d97cc1031de2d0bace0edf3a668818aa2f4eca6.1777410234.git.zylzyl2333@gmail.com



