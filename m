Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D01C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 21:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEEA16B0096; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E566B0092; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6636B0098; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 261266B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 061DD140340
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:41 +0000 (UTC)
X-FDA: 85195566162.13.E816B3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0DE1F20004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 21:49:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gkQC/KRr";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788990579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U90ud9Q4Gx0EiL8kL/2MAnMFndVn4l1bRQEmHcojSIc=;
	b=jkG9+uwOJxU6xNKtL3a4zk5Q82DSRikpYy8WpnFKZypyl9vzvp5ZdWDrL3F8vMRj4GdhK2
	/q3O/0pkqpb0FIfVF8tqrHbyhpDlHr5XZb9VZysIZWSvYWgbWH+DTyzTf+FCQ91Ycn3irt
	jBLoDtbFcDdxnVmaGLtqFDoXRrmuAtI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gkQC/KRr";
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788990579;
	b=PDw1HUgR4kvmp727zgXhp43XHUUaA18R9Ex01pK4VyM3s4ss99vG1nSE3RAnUeOp/sxwpj
	iAxEvtpAoI7DtnhdE6wYfcoMhoU4jVZOdBZRutHv8m3OwBOQg9sxlf5LQB3Wit0Fxoq8de
	jgpq/Un8Js3/LPTEDjZv/+KkY6R1wyY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECEC0434D2;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD5E2C2BCB9;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788990577;
	bh=9MpyGWIxUngkFXBOPjetH4RYkQ+9UxFhMjL5z4190vg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=gkQC/KRr5M9eb3CXKh1pFzjIhQjYdVLCRNaTJVXdryUuiOKHR9xdZXMJkiJciScXV
	 4pidhzLqEpzMP5s9Xw6POiMWEtRz1BdEJ+hli2DtlObfuswoHDxbyEgvGKdwBLbUIW
	 7lw7eMsgq98eJw4nlq/93kgXY1O8B5+AXJ5/L5COfbLiREHh/xvwH2gFIZLEscM/Ni
	 9vUvuhPla/yKnihOGXUhGrnQzF5BXchL09D9JPe6PJxKSDfH0s0vwxCpHwnef8L/GS
	 kt4h15qVx6ywIRTNpDgEnXeWryIylI2yDraLIvS17EQFoBOFcuU3Q1t7fSKkUOTh9V
	 c56pSDyGXBB3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93B1CC79FB6;
	Wed,  9 Sep 2026 21:49:37 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v2 0/4] Fix HugeTLB subpool used_hpages tracking
Date: Wed, 09 Sep 2026 14:49:25 -0700
Message-Id: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGXUoWoC/5WNQQ6DIBAAv2I4dxugxNqe/EfjAWFFUiqGVVtj/
 HupP+hx5jCzMcLkkdi92FjCxZOPQwZ5Kpjp9eAQvM3MJJclv3EJ/exwCi3Q3I4xBtDhrVeCKWn
 zhJnQgiylqhTvlOEVy50xYec/x+PRZO49TTGtx3IRP/tPfRHAwaIwVqjWXsWldjG6gGcTX6zZ9
 /0LvU/MwtMAAAA=
X-Change-ID: 20260902-hugetlb-subpool-always-track-used-2624840f4c08
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
 Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
 rientjes@google.com, vannapurve@google.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788990577; l=7030;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9MpyGWIxUngkFXBOPjetH4RYkQ+9UxFhMjL5z4190vg=;
 b=2mY/vjTdLF0f8ExceLHlruHjV16Yg/8F5fthq5IUc4Zvg5MAXGlEEuXzOsxThqB6Wlzirq3kp
 9jAopCxFgbHAJHrDM1GJIrc3eGI6MgrcEFEb/fC07JsEJffr4f/7+O/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0DE1F20004
X-Stat-Signature: kscc9ixr5nax4mon7u9uzhhjktzx6xfy
X-Rspam-User: 
X-HE-Tag: 1788990578-532745
X-HE-Meta: U2FsdGVkX19JVl3kVAWpgtqzeDEY3jxPgkhxVhVBaZ16MbLFaRpZA1jOaNNk+WaGnD5+ORpUNxGPO2CQrBHP4D/c48MgYjMLzHh48Jie5mPO1d7Vsa9SJSWxB8Et8S4gEqoBZN4ATHtSuzYxTEbraCV2QEUHwo84RldD9CquOK2msbWYw1wEPmyoCHspd8fXGYi3BamqofP37X7o4yYsFgeideFGGXFo2fvqrhJQgOfA2ppRM23LPBvXnRid9GTrquVfGeUduc3LeDnrzcivNx4jbY4rLnUVnU2kXs1sxzn0p9Vet4hjTIVx/EXqI0ldL+xyYXlAU0MErC4m0XPGEVLW4jmbkPbctC1y0ycrC5lzSw3Cr5r6kNP7Ywf67iUJtEF38L0NvgYRdK9tbEJ0WoDFG+ShLStdchhnKMzSfSrTC8vzWny4TrILNO3SfBxL+OdX0uhewVZaq3NI5UMumxenvbjQSJOTCb4aN4H2N+VbCwqKbyarBCLVgRNdwIie/MUc7PB/PFXvc45w8HK2y/Ophm+0NOoKWm0kvIKoZMR/BsbDtOOzzliS5VqkMp+oA/iSoAtJzw2AHu1h2NAj5NnVXExEop6gDqM3M6nB34YZD0r54flDfXlCBVhvxOODiHabNbgHPNE2Cpu9qVQjQb0aQX06OxLxCl0S9+zMRUNJnHJnv8qAMhCZeC8/t7q533B/dInGM5I5JQByV6/NMLuO9CWKdIcyjJbDHmVDcADt+PQfvIBrfuKuu1sJO15Q1W9YSRfFJp0ryz9tX3SyWZocJOGL0vo1g1Y2bLkSi0hAOkJy1F6zM8E62wl1erY0mMLb7LO2fPVlxtiN3CPafs4sn5j5fbn6KVo94mmFHq4SMq+igf3UbOJr8NDkEXenqp+QUmhwnhLPUgF8KR0cD3Ihri+c7W9Smb/NhH90FNtNzpclCl2RhXiSKJJwj9aKqjeFLfJqAXVlSgjqwCq
 rKVmF/2f
 gCJ99hpMhmyqcJWnKE8zDDmPCoMnnMD8QZ2p64IN+tUWL8N084GDYNPHH+HEDtPx1r6eWx357G3p4+64pAqHEDsp/EHJcHDWow9eosIdxdgoS2t9q/JXNYwkY9Sk1wQyHWi9zJF+K9oe7NbvvFPrsfDD57wJlJNK9x2UAfkBAEGYfU6uqvdnLbGXeYRheHW4fPZgXW9PH20LaH8+SMDzyj/Xx+YMDzN25WUZLXjc70LZuoN1abu0hDlBRmz6G84/Ea9ZhzT642Az9cUHd6wxv6oTdjdwXINtrRqG+lXvt8iWoPXwbbQ+bZjvoDmaRF3tgzuTinKzQ2DZHfsWvvq1698j32hXgaEl3WEWd44Wt+nf57D6hni4UxGafCyGF1O4QVpIcA+AMezUshWRpnSJeyFdCHZ/6KfEMHWgpGy1BNMTwfuf5nh7Zf8p5+x61chzrgo9WzuSf2CzPPLJcx4BEi15e2vDivGvzSe3OMH34XaxTlqBYP65Sw6Uov/2rYcHFA7tFlNu6Yzv2a53hlpGLuEujD/Vh8GyEUtVeXfNmEhFFlzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB subpools currently only track used_hpages when the user configures
a size limit.

This is buggy since when there are existing allocations from the subpool
that would have satisfied the minimum reservations,
hugepage_subpool_put_pages() will still restore a reservation to the
subpool. See below for an example of a false reservation.

In addition, the subpool is considered free prematurely, is freed, and this
ends up causing a use-after-free.

The fix is to always track used_hpages within subpools, which is also
beneficial in general because with that information, reservation tracking
is also fully managed within hugepage_subpool_put_pages().

The invariant is that now (if min_hpages is requested),

  used_hpages + rsv_hpages >= min_hpages

This allows hugepage_subpool_put_pages() to always be able to report how
many reservations it can absorb and hence return an accurate number of
reservations to be returned to the global pool.

Hugepage reservations and restorations can always happen in parallel, so
relying on local variables to compute whether to restore to the global pool
(on allocation failure) is not safe.

There is complexity and some bugs in hugetlb_reserve_pages() and
alloc_hugetlb_folio() failure handling paths.

+ In hugetlb_reserve_pages(): On hugetlb_acct_memory() failure,
  out_put_pages manually calculates how many pages to return using local
  variables, which is race-prone and can leak reservations or underflow
  global counters.
+ In alloc_hugetlb_folio(): When allocation fails and gbl_chg == 1,
  out_subpool_put skips hugepage_subpool_put_pages(), permanently leaking
  used_hpages.

By tracking used_hpages in the subpool, these allocation/reservation paths
can handle failures by consistently returning pages to the subpool, and
relying on the return value to restore reservations to the global pool.

This series changes subpools to always track used_hpages, which itself
fixes the false reservation bug, and then uses used_hpages tracking in
subpools to fix other bugs.

This series is a subset of patches from [1] and replaces [1].

[1] https://lore.kernel.org/all/20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com/

Tested:

+ Reproducers (see below) pass
+ tools/testing/selftests/mm/ksft_hugetlb.sh passes
+ libhugetlbfs tests pass

Changes in v2:

+ Add patch 4 to avoid a possible page allocation in the cleanup path of
  hugetlb_reserve_pages(), addresses Sashiko's comment on v1.

v1: https://lore.kernel.org/r/20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com

I have reproducers, get them from

https://github.com/googleprodkernel/linux-cc/commits/hugetlb-subpool-always-track-used-with-reproducers-v2

Here's an example of a false restoration:

1. Mount time
    + spool->min_hpages = 1 (user requested min_size=2M)
    + spool->max_hpages = -1 (no maximum size specified)
    + spool->rsv_hpages = 1 (reserve min_hpages)
    + spool->used_hpages = 0 (not tracked when max_hpages == -1)
    + h->resv_huge_pages = 1 (reserved by hugetlb_acct_memory(h, 1))
2. Shared mapping of 4MB (2 pages) created (mmap with MAP_SHARED)
    + In hugetlb_reserve_pages(), region_chg() finds chg = 2 (pages 0 and 1
      need reservations)
    + hugepage_subpool_get_pages(spool, 2)
        + spool->rsv_hpages = 0 (consumed the 1 subpool reservation)
        + Return 1, since this subpool only had 1 reservation
    + hugetlb_acct_memory(h, 1)
        + h->resv_huge_pages = 2 (incremented from 1 to 2 for the global
          reservation)
        + region_add() records reservations for pages 0 and 1 in the inode
          resv_map
3. Process touches and populates Page 0:
    + hugetlb_no_page() calls alloc_hugetlb_folio()
    + Page 0 reuses the existing reservation (vma_needs_reservation()
      returns 0 => map_chg = MAP_CHG_REUSE = 0)
    + hugepage_subpool_get_pages() is not called (map_chg == 0)
    + dequeue_hugetlb_folio_nodemask() consumes 1 reservation:
      h->resv_huge_pages--;
    + h->resv_huge_pages = 1 (decremented from 2 to 1)
4. Process closes the file and exits:
    + For MAP_SHARED mappings, reservations persist in the inode resv_map
    + Page 1 reservation remains active
    + h->resv_huge_pages = 1 (retained for Page 1)
5. File is truncated to 2MB (truncate -s 2M):
    + Truncation invokes remove_inode_hugepages() for page range [1,
      LONG_MAX)
    + Page 1 was never faulted into page cache => freed = 0
    + Calls hugetlb_unreserve_pages(inode, 1, LONG_MAX, freed = 0)
    + region_del() removes Page 1 from resv_map => chg = 1
6. Inside hugetlb_unreserve_pages(): hugepage_subpool_put_pages(1)
    + delta = chg - freed = 1 - 0 = 1
    + Because spool->max_hpages == -1, spool->used_hpages always = 0
    + spool->used_hpages < spool->min_hpages => 0 < 1 => true
        <<== subpool assumes 0 pages are in use, ignoring allocated Page 0
    + spool->rsv_hpages + delta <= spool->min_hpages => 0 + 1 <= 1 => true
    + spool->rsv_hpages += 1 => spool->rsv_hpages = 1
        <<== false reservation restored to subpool!
    + Return 0 (subpool absorbed the reservation)
7. Back in hugetlb_unreserve_pages(): hugetlb_acct_memory()
    + hugetlb_acct_memory(h, -0) => does nothing
    + h->resv_huge_pages = 1 (remains 1, not decremented)
    + Both reservations have ended (Page 0 allocated, Page 1 truncated),
      but h->resv_huge_pages remains stuck at 1
8. Later during unmounting:
    + subpool_is_free() checks spool->rsv_hpages == spool->min_hpages => 1
      == 1 => true
    + Because spool->rsv_hpages was falsely restored to 1, the subpool is
      erroneously considered completely free
    + hugetlb_acct_memory(spool->hstate, -spool->min_hpages) decrements
      h->resv_huge_pages by 1 (1 - 1 = 0), masking the leak on unmount
9. If the folio outlives the inode, when the folio is freed (Page 0),
   free_huge_folio() will read subpool from the folio and act on it =>
   use-after-free and then double free

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (4):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Fix out_put_pages subpool reserve calculation
      mm: hugetlb: Fix subpool usage leak on allocation failure
      mm: hugetlb: Avoid re-allocating global reservations on region add failure

 Documentation/mm/hugetlbfs_reserv.rst              |  17 +--
 .../translations/zh_CN/mm/hugetlbfs_reserv.rst     |  11 +-
 fs/hugetlbfs/inode.c                               |   8 +-
 include/linux/hugetlb.h                            |   4 +-
 mm/hugetlb.c                                       | 147 +++++++++++----------
 5 files changed, 90 insertions(+), 97 deletions(-)
---
base-commit: df2908090cda368b01ff43709f51890076c56157
change-id: 20260902-hugetlb-subpool-always-track-used-2624840f4c08

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



