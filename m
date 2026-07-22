Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9EFC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5CBB6B009F; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34586B00A2; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AE936B00A4; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5523E6B009F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEBCC40337
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:22 +0000 (UTC)
X-FDA: 85018036404.19.7D6D8B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A77871A0006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Trr2vdLh;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O6Y9ZZepMg/eTd73hFbbRUy+4J14F6MyogBLIrwdEyk=;
	b=PHwhXhEKnrZc4uG1p31XxUdaO/92Ht7ehvxFrrqh+3MwR/bx8/DJna8N0WuQDTGtXqO3LA
	RRocX4kDHTnictAKaAE+0CTS+XNT4jZ10UHooCJ/MnIBTxNa3xF4nY5GD+0zX8DAV94eYb
	khN+gBzGBBMDJ7Y+ovar4CKziwG8/T4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763680;
	b=8KlXukE57wt7ZL2bsJy8mM4YXO8i6k7VxV7C5jncBfieQl0SiWu/L2nGIhdKDAd0CpliDT
	fIZ81sUhz5lfTEnCRe5824OasDcMvnnMC5H/UR/4K06wT7rk0HorauJ8n6zQAVn5sSTUXi
	/CKEVNlqi1b9Gm/K6HEQNVK7/hR2laI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Trr2vdLh;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D70B3439C5;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A482DC19425;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763679;
	bh=NeJlLVVMf++c5nZhAc/KqZ/hq04Bz1Dk6297RE4toKs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Trr2vdLhCdMV6FlD3ih3cgioCpipymobS5BR0iPYq8TOcB9z5cYLm/nNE0q05gzl6
	 jr45Wrb4Y9vCeLPaK7K2EGGMOwz1QsmLJNclQrA01YgfQX6ArjMZLArd/4+5ngNHmh
	 xHZisHt0xQLW7YKXsLAYq2+5LeJxZCz3t4ASwnQTzGcSee3UlkDVnCIs7pC5FQkeX9
	 9RsFPrCA9R7rMfZdYr1NlPeJpKXpypOFUySNGn7Xn7v0pxblChLh+o8D+NKBbchdh2
	 cGDoCDKWHl3OzUqzhVJdaxLnDPDvTHDo3/7uBG2CbxU42duCQeP13SQnS4KpGD3P9E
	 jCFS5eBprIj8Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC53C44532;
	Wed, 22 Jul 2026 23:41:19 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v4 00/16] Fix bugs on HugeTLB folio allocation failure
 paths
Date: Wed, 22 Jul 2026 16:41:08 -0700
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABRVYWoC/33OwQqDMAyA4VeRntdRo7a6095j7NDWqIXOjlZlQ
 3z3VWHgGHj8E/iSmQT0BgO5JDPxOJlgXB8jPyVEd7JvkZo6NgEGnAnGaTe2OFhFpbVO00YaO3q
 kjXlhoFo0QhSoJVQNicLT47aIwO0euzNhcP69HZvSdfp1xaE7pZTRQqk6k7kqM15fW+dai2ftH
 mSFJ9hj5TEGEYufgtBK5RzUH5btMGDHWBYxUYNMeSVlhfiDLcvyAdjqG2xhAQAA
X-Change-ID: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=8919;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NeJlLVVMf++c5nZhAc/KqZ/hq04Bz1Dk6297RE4toKs=;
 b=7dRun2bww5d+94a6EUgKYhDHc0fhMbujyDJkpXqg7z757v09Akq7Esh/Vj/YQiD6CGXdvf1h9
 xn81To5pmSFBRP4n2Z4ZP3HY4t6A6qzSay8cWFJ6jYdnwkqejhXLXbr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: td1fwcdyjw5j1hq93fifyaf8nfmnq6nm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A77871A0006
X-HE-Tag: 1784763680-119345
X-HE-Meta: U2FsdGVkX1+6KrBkiIlsgqK7TSZxrISzExroQxINcRSfYHypYntOfagICDmdWXEZIK8q5DZVKi2i6PTexlDRNCxO11G7+fZ2mIl8qeJ26PR2OHvQgYdx2sNVnxSnBQURvIo8iX74JJIet7/4JjjNfD31WxnCTJZMfWF42peDoQJeD5HaoBcEJpRx1Z3ioCeLlSpVmSg16NjP8F0YJ536FvfSc8k/tMHfAhJPcFwDO5xSHsQojH8PsTjxZem6PRNY7/dgIcefEFm5dBq5Mrz053Gxp9/drgyHyytGW2fQaVYDSEc6lMhsEGohQk5pEPGa58gqBHxH8xoaB/Z2fR9dm5/DPQXXtSiWEVswoFbF97Saki4f9YPoX4QOH2x49TqAKn8rBrWbMlMMwnimW66o2VzEd0gUYUJf5Dwhuj3M4m6PWB5WIDaGlJdBEe7PPF9QnL2q+P0HQ5w1Q4lNpFkJMNUNFSa1d/BvscjpdQS/TDhLLB6MQIY1cGU3oHCq4X4MtYl1ko9M4fqo2gAyktiOpHrw3X8fQFUW+6a+3wV5vGxq3BIEVogQPMqmxMZsrfu6eFLpKePMya26R2wM09uIRGT5A1PMjACaQoW9j6llzADkhnjE/TfZuRz7O8oHuezRM5mAQtiXutpz35DC309jiVWeC5gKvP8HnTTWjj2cr49iDeCrS3j4OW5b/qogIUOMata4X1q+5/lyLeqYqOqcSmI8PX2HTYoW3JnpIwOVS49t21ysOnGoVXt6wdoE8jbq+HsTbffPiJ4qp7+A6/lDRqsZIY6kMfvYYDRx6m3oLbJkoFo38DqrQpH8asR8eiH/XVQIA0KmVwJLgo9kIVfKrp92hD2Mb47Yos8l+wAbYQeKkW2lH8QDAxsX4WRgYUN6MM2UU45T0ynjpRM0B4WuebOprhw3+sqxM9FDkI26WlE74xZvPYuE6HCTQMTMZ+1aL3QHM8Bm1cEwO+trz7D
 gYJG4+kB
 hr+rArp+M2fKYpdvIM4lUBiRUQV0lqwa0tzPThaZX8PF1zrrXJ+g0XmmcpA50uggmS8qtvMMMl7CzATIFRuwuVX1lVvW8jIdaStuht48Zs09/jNX61Z4rurzK97smh4KywR7MLa3cKms3514uQhZUmhhuh9QV4ngaloOaZfr6AVMZpjTWjR6u1CWDPqpyUr4wXB/r0KnlYLMHV23fkeHIMWN57aesORO+junHRiHDlkeyPZ3Ks36+gCIIf+i61BhLyFcCjUykeXxia1I93WsCDh/6KcpsuaoFDu2Df2JhylMXRxsH8dkCiXbFMbOGMVrLnfYUm3mwt1bDfObQLSbtP6939+JM8MgkaNibWcLxBkgG2KSxj0AtBIiak6TNqn8VFwGm7tiz8I8iCG2L909nXcZHy2e92yLY4V0rMEPdy+laCcF1WpEgcuRDv1q0A3ZBHPOqMQgdP+ptbzioF8KZa+NErw99Dq18aPEt2lRcrOb6PJCxI0tsfOOtqc1kmofCwvffZddgM9e2QsOYnq7jf7DqUmIQ8DoGHL7oEW1wV+KpPaz2sYWxd351jw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a few bugs on HugeTLB folio allocation failure paths.

Some of these issues were pointed out by Sashiko while I was working on
[1], and others were revealed while fixing the original issues.

1. subpool usage leak on allocation failure (Sashiko pointed this out
   in [2])

   When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
   hugetlb cgroup charging failure) and gbl_chg == 1, the error path skips
   restoring the page to the subpool, leaking the subpool's used_hpages
   counter. Fix this by calling hugepage_subpool_put_pages()
   unconditionally if map_chg is true.

2. Folio refcount mismatch on memcg charge failure leading to
   VM_BUG_ON_FOLIO() (Sashiko pointed this out in [3])

   The error path in alloc_hugetlb_folio() calls free_huge_folio() directly
   on a folio with a refcount of 1 (set via folio_ref_unfreeze() earlier).
   This triggers VM_BUG_ON_FOLIO(folio_ref_count(folio), folio) if
   CONFIG_DEBUG_VM is enabled, and can corrupt allocator state otherwise.
   Fix this by using folio_put() instead of free_huge_folio() to correctly
   drop the refcount before freeing.

3. Returning -ENOMEM on memcg charge failure causes infinite loop

   alloc_hugetlb_folio() propagates -ENOMEM on charge failure, which maps
   to VM_FAULT_OOM. Because HugeTLB physical allocations are high-order and
   use __GFP_RETRY_MAYFAIL, the OOM killer is bypassed. Returning
   VM_FAULT_OOM leaks to the #PF handler, which cannot make progress and
   retries the faulting instruction indefinitely. Fix this by returning
   -ENOSPC instead of -ENOMEM on charge failure, which maps to
   VM_FAULT_SIGBUS, terminating the process cleanly.

4. vma reservation leak on mem_cgroup_charge_hugetlb() failure

   When mem_cgroup_charge_hugetlb() fails, the error path historically
   bypassed vma_end_reservation(). Since the reservation had already been
   committed via vma_commit_reservation(), this left the reservation map in
   an inconsistent state, leaking resv_huge_pages when the process
   exited. Fix this by moving mem_cgroup_charge_hugetlb() earlier in
   alloc_hugetlb_folio(), before vma_commit_reservation() is called.

Cleaned up patches, updated documentation, and fixed Sashiko's comments on
v3:

1. subpool cleanup in alloc_hugetlb_folio() was incomplete - I folded the
   fix in.
2. More issues (UAF, and another accounting issue) reported [5] - I added
   two more patches.

Keeping this section since I think people didn't have much time to review
v3.

1. subpool page tracking

The subpool now tracks every page allocated via
the subpool through used_hpages, regardless of whether min_hpages or
max_hpages is requested by the user.

When min_hpages is set, rsv_hpages is initialized to be equal to
min_hpages. As reserved pages are used, the count is transferred from
rsv_hpages to used_hpages. When reserved pages run out, as long as
max_hpages is not requested or not yet met, used_hpages continues to be
incremented. The following invariant holds true while used_hpages <=
min_hpages:

  used_hpages + rsv_hpages = min_hpages

when used_hpages exceeds min_hpages, rsv_hpages must always be 0.

With this, pages can and must always be returned to the subpool if there's
some reservation or allocation failure after getting a page from the
subpool. One thing I missed in v2 was in processing the returned page. In
v2, the number of pages returned was compared to min_hpages, ignoring
used_hpages if it exists. v3 limits the number of pages returned to
min_hpages - used_hpages, upholding the invariant above.

2. (Re-)introduction of the try-commit-cancel protocol for memcg charging.

In v2, I took the shortcut where I moved mem_cgroup_charge_hugetlb() up
above committing vma reservations, and jumped to subpool cleanup when the
charging failed. With that, Sashiko pointed out that there are still issues
with subpool tracking.

In [4] I thought the issue was that gbl_chg == 0 (I flipped the condition
in [4], omg) doesn't always mean a reservation was actually used, but after
digging more, that doesn't seem to be true, since if gbl_chg == 0,
restore_reserve is set on the folio, and free_huge_folio() would have done
a h->resv_huge_pages++.

In my opinion, calling free_huge_folio() in the middle of the cleanup does
too much, and I think the cleaner approach would be to do all the charging
symmetrically, so that the subpool cleanup will also be symmetric
and (hopefully) easier to understand.

+ I would like reviews on all the non-WIP patches. Those are the ones that
  I'd like merged first.
+ There are reproducers (not meant to be merged) to help prove
  effectiveness of fixes.
+ There are WIP patches for subpool-related refactoring. Those helped me
  check that the subpool stuff is working and is posted to show how it
  works. I think the subpool-related refactoring and tests would be good to
  merge, but perhaps in another patch series? The refactoring was heavily
  AI-driven and should be considered RFC. Would like to have your feedback
  on that refactoring too.

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes
+ Reproducers all pass

v1: https://lore.kernel.org/r/20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com
v2: https://lore.kernel.org/r/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com
v3: https://lore.kernel.org/r/20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com

The series [1] has some changes that are dependent on these fixes, so I'll wait
for your reviews before continuing on [1].

Thank you!

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8%40google.com?part=5
[3] https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34%40google.com?part=6
[4] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/
[5] https://sashiko.dev/#/patchset/20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee%40google.com?part=8

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (16):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Use try-commit-cancel protocol for memcg charge of folios
      mm: hugetlb: Remove unused mem_cgroup_charge_hugetlb function
      mm: hugetlb: Fix subpool usage leak on allocation failure
      mm: hugetlb: Rename local variables for clarity in hugetlb_reserve_pages()
      mm: hugetlb: Fix Use-After-Free in unlock_or_release_subpool()
      fs: hugetlbfs: Fix global reservation leak in hugetlbfs_fill_super()
      WIP: mm: hugetlb: Move subpool functions to hugetlb_subpool.c
      WIP: fs: hugetlbfs: Refactor subpool getters and integrate with hugetlb_subpool API
      WIP: mm: hugetlb: Make struct hugepage_subpool private to hugetlb_subpool.c
      WIP: tools: testing: Add unit tests for HugeTLB subpool functions
      WIP: Reproducer for allocation failure due to cgroup v2 memory limits
      WIP: Reproducer for subpool usage leak
      WIP: Reproducer for false restoration on shared HugeTLB mappings
      WIP: Reproducer for out_put_pages subpool reserve leakage

 Documentation/mm/hugetlbfs_reserv.rst              |  17 +-
 .../translations/zh_CN/mm/hugetlbfs_reserv.rst     |  11 +-
 cgroup_v2_allocation_failure.c                     | 169 +++++++++
 fs/hugetlbfs/inode.c                               |  31 +-
 hugetlb_reserve_pages_out_put_pages.c              |  49 +++
 hugetlb_reserve_pages_out_put_pages.sh             | 153 ++++++++
 include/linux/hugetlb.h                            |  17 +-
 include/linux/memcontrol.h                         |  30 +-
 mm/Makefile                                        |   2 +-
 mm/hugetlb.c                                       | 260 +++-----------
 mm/hugetlb_subpool.c                               | 230 ++++++++++++
 mm/hugetlb_subpool.h                               |  21 ++
 mm/memcontrol.c                                    | 116 +++++-
 subpool_leak_max_size.sh                           |  72 ++++
 subpool_shared_leak.c                              |  43 +++
 subpool_shared_leak.sh                             |  87 +++++
 tools/testing/hugetlb_subpool/.gitignore           |   1 +
 tools/testing/hugetlb_subpool/Makefile             |  18 +
 tools/testing/hugetlb_subpool/test_subpool.c       | 400 +++++++++++++++++++++
 19 files changed, 1445 insertions(+), 282 deletions(-)
---
base-commit: 4539944e515183668109bdf4d0c3d7d228383d88
change-id: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



