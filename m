Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69215103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDFEA6B0098; Wed, 25 Mar 2026 07:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90BE6B00A4; Wed, 25 Mar 2026 07:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA69B6B00A5; Wed, 25 Mar 2026 07:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACCB76B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:44:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 47D355B6A2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:44:35 +0000 (UTC)
X-FDA: 84584402910.30.CE3DE29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5424100008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:44:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WE01X80U;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774439073; a=rsa-sha256;
	cv=none;
	b=hXi3IMEk++67ounYh7IGzfsDCXB1twJGQ+E/yJqA7JJ/WOfr0XcB5kRlurcApix22Qsxl+
	KuxNCR/zI18xfKt7y1vxJA309Bmcaou3vb00mWfRDSixneWH0eEGiwQMuO5kprT0W0cNwT
	ZWgyaGTE5ANHrmWoDpF/kOh1vssDe34=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774439073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qtZ4Vk/beUdNeQkf+F3gnzA5HoZNj71cIa9Kuah/ycE=;
	b=Ex8LCDxouf31KtacPbLL30hyU+jRttW4Gys0XymduA4m3/RjZ6hcuJLuQI3z7RCeh/UEQW
	LxrAmMp89WXczE/qXo0Krz/yRQn4jaSrLl3paCscOicGa0IDfrYba9ZmIgsk0S83CcHNnv
	zt8goFkHatfa5mYMSr74JPq2TzHRmNk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WE01X80U;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 623B543776;
	Wed, 25 Mar 2026 11:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B273C2BCB0;
	Wed, 25 Mar 2026 11:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774439072;
	bh=pKVdCOZoVAjLpPuiIxXK8FJ5i/nD+ZtRmI+rGCs029g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WE01X80U3JTZ99uJZb1BVs0ne1U7M3iJ0z/EzrC2m7NdUvD+7zIisfiojH432mzKn
	 6jFn6hxOtwgVFeDn7GrGHQPDWUxFTt0MtpYt0EUlscS19sl84VifZhrfNiAc6fhVEy
	 n6hRWaosWiY3RhpWo9RR4T0temchRzW+IT5m5nCylBKgRi4qk9Ser1kCEZgqwLrzUF
	 IXUscENlMx2GIONiWVTprgc8lNo+ffBoajJheXau+HVfP/1En2+PGreDIFNwx/k6Ex
	 kNWkOnjJnsJ+SIzK7MDg6JwSH41gEqbQCsB5HTMRaTDakfn3yJ37FIcrSMAgsH314o
	 fGty/buHuipeQ==
Date: Wed, 25 Mar 2026 11:44:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 0/5] mm: khugepaged cleanups and mTHP
 prerequisites
Message-ID: <3704445d-0501-4f3b-a5f3-806f23e0401d@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5424100008
X-Stat-Signature: p7tktqstk81nh8rcg1chc35sq4hj8uqx
X-HE-Tag: 1774439073-579673
X-HE-Meta: U2FsdGVkX1+0tBanZPxSn09xPl++UIUOD5LYQ1yav0kvDjmEWYuqOKYKW1Y3n/BC3q6hBljwIYd9ywK+q1EBqlLUzkOU4YzoMr+EBKDWTXqjieoZxTp0MN4mMJXbEkQoZTP/nPiNnZm3kJ19e1huQPPRR5v5QNzYEJrjgcjpthT/TzfuuQIyk+RO0OXxn4G4AZIoHmIDQxIywAalNIzZMs3vzca4D19p1QznBGbg8daK2bwJjOVwmdpIPJmaIsl5W4Mb1PoZaoRfFZl8JeLHMdNWobEw4s9UShqHxOIwC13CQyjvpH2XXe7n1O1JOtIaQ7IKA8RiSI6oOAiQdebpoI8Lf+3lCKZs6yTcB2BUZZOePvhlQ70X9l9XRwuPNAty6eeRQc301FB1z3yWQR+IxCv4m4Ii6lhJkAeBHu84KGK4pfHO8t0HsEKDabegDvIVuRETCNjY5bpvAsfUCbQmevO+y57F7PCK13FBQYs33YT1jm2jeIm6ZvgsdEeJZQAvq0BKVx87R3AVxMX8MT3sTWrl66efWHsFGpnPPc7xeiPvnlh1lg3+PXv7OKjuG3gtPxJVtPDlk4FHDmpalzB4E0x2raF8Pz8VdzKF8gHV59xJ6br3fY2Sp05RIDQBb/8CiXLoz2ajExySvwyGMJUlOhrNMUs+GmeO0MxgPg73HVOHKueMjuA75z6vCpjuAAhxcziz2q/iK6VQBflFOa88wFoJvIo1YWeMXd6reN55uxWnBDGta9I3loL5GBZXQ6CJA1KIm0QTagHDq+DaiTSOHy4c4setLKESWzD8dTX3x7MccWYx0Bq66fbi3N+gntWg4K+lpEiRFzsQ7bH8CysAgTid80YhJcyMDidPEJnnB6ugP+dSrfi5Z4NAcycR3oDgcVq+E11cD0xZGtR+kV5UMx1ClNrVkRjzXyO9q579U0YMb/xlqwwNqvSGM5hWaiEke7IExQ+ZnzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc old email

Gentle reminder to please send new stuff to ljs@kernel.org!

Thanks, Lorenzo

On Wed, Mar 25, 2026 at 05:40:17AM -0600, Nico Pache wrote:
> MAINTAINER NOTE: This is based on mm-unstable with the coresponding
> patches reverted then reapplied.
>
> The following series contains cleanups and prerequisites for my work on
> khugepaged mTHP support [1]. These have been separated out to ease review.
>
> The first patch in the series refactors the page fault folio to pte mapping
> and follows a similar convention as defined by map_anon_folio_pmd_(no)pf().
> This not only cleans up the current implementation of do_anonymous_page(),
> but will allow for reuse later in the khugepaged mTHP implementation.
>
> The second patch adds a small is_pmd_order() helper to check if an order is
> the PMD order. This check is open-coded in a number of places. This patch
> aims to clean this up and will be used more in the khugepaged mTHP work.
> The third patch also adds a small DEFINE for (HPAGE_PMD_NR - 1) which is
> used often across the khugepaged code.
>
> The fourth and fifth patch come from the khugepaged mTHP patchset [1].
> These two patches include the rename of function prefixes, and the
> unification of khugepaged and madvise_collapse via a new
> collapse_single_pmd function.
>
> Patch 1:     refactor do_anonymous_page into map_anon_folio_pte_(no)pf
> Patch 2:     add is_pmd_order helper
> Patch 3:     Add define for (HPAGE_PMD_NR - 1)
> Patch 4:     Refactor/rename hpage_collapse
> Patch 5:     Refactoring to combine madvise_collapse and khugepaged
>
> Testing:
> - Built for x86_64, aarch64, ppc64le, and s390x
> - ran all arches on test suites provided by the kernel-tests project
> - selftests mm
>
> V4 Changes:
>  - added RB and SB tags
>  - Patch1: commit message cleanup/additions
>  - Patch1: constify two variables, and change 1<<order to 1L<<..
>  - Patch1: change zero-page read path to use update_mmu_cache varient
>  - Patch5: remove dead code switch statement (SCAN_PTE_MAPPED_HUGEPAGE)
>  - Patch5: remove local mmap_locked from madvise_collapse()
>  - Patch5: rename mmap_locked to lock_dropped in ..scan_mm_slot() and
>    invert the logic. the madvise|khugepaged code now share the same
>    naming convention across both functions.
>  - Patch5: add assertion to collapse_single_pmd() so both madvise_collapse
>    and khugepaged assert the lock.
>  - Patch5: Convert one of the VM_BUG_ON's to VM_WARN_ON
>
> V3 - https://lore.kernel.org/all/20260311211315.450947-1-npache@redhat.com
> V2 - https://lore.kernel.org/all/20260226012929.169479-1-npache@redhat.com
> V1 - https://lore.kernel.org/all/20260212021835.17755-1-npache@redhat.com
>
> A big thanks to everyone that has reviewed, tested, and participated in
> the development process.
>
> [1] - https://lore.kernel.org/all/20260122192841.128719-1-npache@redhat.com
> [2] - https://lore.kernel.org/all/7334b702-f6a0-4ccf-8ac6-8426a90d1846@kernel.org/
> [3] - https://lore.kernel.org/all/25723c0f-c702-44ad-93e9-1056313680cd@kernel.org/
> [4] - https://lore.kernel.org/all/81ff9caa-50f2-4951-8d82-2c8dcdf3db91@kernel.org/
>
> Nico Pache (5):
>   mm: consolidate anonymous folio PTE mapping into helpers
>   mm: introduce is_pmd_order helper
>   mm/khugepaged: define KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
>   mm/khugepaged: rename hpage_collapse_* to collapse_*
>   mm/khugepaged: unify khugepaged and madv_collapse with
>     collapse_single_pmd()
>
>  include/linux/huge_mm.h |   5 +
>  include/linux/mm.h      |   4 +
>  mm/huge_memory.c        |   2 +-
>  mm/khugepaged.c         | 207 ++++++++++++++++++++--------------------
>  mm/memory.c             |  63 ++++++++----
>  mm/mempolicy.c          |   2 +-
>  mm/mremap.c             |   2 +-
>  mm/page_alloc.c         |   4 +-
>  mm/shmem.c              |   3 +-
>  9 files changed, 161 insertions(+), 131 deletions(-)
>
> --
> 2.53.0
>

