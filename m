Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C92B6C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 23:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71CCE6B00AF; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67FB66B00B0; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546CB6B00B2; Wed,  2 Sep 2026 19:30:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 065EC6B00AF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:30:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E6BB1C1DD2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:55 +0000 (UTC)
X-FDA: 85170419670.17.1F11304
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7D43120003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:30:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="int0x+/k";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788391853;
	b=nkt6YPkNvD0nS3tS/Z7HplHyknte1OhmKkaijUvn/Zlqn6c1+jtnP5j4AZLmcGb+Jkq8D9
	D0yiFPjnbgkyP/lrfFhv5+Y5ejL+WuzsPyhGRdk4nfiuf6jkGkxZ7aqu96ISNQT8odCXTK
	3w18g6xfGXlYCEtRG/yfxcsCdV115xo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="int0x+/k";
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788391853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=U5w88JhgGYTxR6qTHUmIed7nGrkdecT2+dbfblcfRTw=;
	b=2jR+50XBX2fmWl7bNvCkPHvKpYr0SdjG7gE6pGEGsamChqU4/SBVpXY3F4KQnulVxG77C6
	utpuDiXfhaNzbG9jnVYzSMu3mLBPyhTiO5TGBUjWa8Qsean8SJQyaZe5atSwOCNDzpLIJA
	+6jr9GZki/9ku36ZhuPlLTHBjnvDU5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9FE443F82;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9319AC2BCB3;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788391851;
	bh=Xxc4EGpnsL1t3+z+6iTUEEoO2c75bqIsit8HhK+9hck=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=int0x+/kUqBu0ZGm8vzODKv5PDr+2qiJo71VYyw8LmOj/52WhU8256pn2XjkY2PbI
	 i1v1U6ty7ji4l8EEEFeEk01XuucV3OB0ECrDEJ9A5iYY0zkwrglkiNF2U1txDyQIjO
	 zJdN/BMdw/91OwT6unKviD/ERkY87bdkz6zoWGx0zFrtuq4wH4I6Zni98Is+wd/QhK
	 i94ZNG8YMm0rq8+r2yyykh8O8REqN5Zaiejv+Vcd+8v9QC0CZsAVdyCWg09JqoJM/q
	 ++nZz1uDAOyMDjAr4xtU4hCrE9P4Hdo2CgL+/xEz/cvnm9HRI1NP2HdRbfHcloTjb0
	 VVEwIPMGUnkMQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA8DC624D7;
	Wed,  2 Sep 2026 23:30:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH 0/3] Fix HugeTLB subpool used_hpages tracking
Date: Wed, 02 Sep 2026 16:30:46 -0700
Message-Id: <20260902-hugetlb-subpool-always-track-used-v1-0-de1cd14bd713@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKaxmGoC/x3NwQqDMAyA4VeRnBfIQhG3Vxk71Bo1rFhprNsQ3
 31lx+/y/weYZBWDe3NAll1N01JxvTQQZr9MgjpUAxO3dCPGuUyyxR6t9GtKEX18+6/hln14YTE
 ZkFt2naPRBeqgdtYso37+j8fzPH8U1cpGcwAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788391851; l=6558;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Xxc4EGpnsL1t3+z+6iTUEEoO2c75bqIsit8HhK+9hck=;
 b=j8AYp1AzMewolXJvwnkVhiePaFUKvLV9DIlmbjKhNscsoE4JyIiebqQvBOKGFL0qMPH9bWM35
 k/0zNqPL3VnDvGmIapusqP/hdH0fDfjw9sS3bLTTv4+aEYmCGwFkFXK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: q31etw9nemsy7xn3su347fatrroufjm1
X-Rspamd-Queue-Id: 7D43120003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788391853-161340
X-HE-Meta: U2FsdGVkX18tXr7eOlSXrmqDbc+6vPAa3bTcsQKiIk7XmMmhUM0iCKN3uwOolbXuEm+G0AIe8VoavOJi+BUn9cVuVI99Ctqy82cwcGEzc0ScZ3oAR0/iRVlwkJg8esmdoHxDyJT9cNcfTrgTNYM3Yk0L0rYJ47DHpK8+d+Ujk5x/DRO0kAgFo+NBtR6fccHEbaTqzkltTAYpQV149i1EgAOlZoZ7AyGu8O+A3Hf3IRQDSdDyau2xlnMEu7u2DJ/RMeRy8ba68sy77+1mE72Ai1FWqr9Wx6kbMRnXHoX1f7WeTpTQVGF/zWrvehTz6KzBuQnelvmBRDD6hdSTwscG5Q9zK4O+VpfljTS6T7Nof3/5khChFvn0pASEdgIcxJYpZ11gLt3XvznFkDBfqdue3P40gym8euPygr/aSuPx0djyVVyCB4KBDqqULmvxsqdW3I1WWJoFehXz6+gLqvdCmYOg1dvuJRW7KwJU4oVlzBDQyYNvpYgBRGjHOp9psoisG7aB1ecQZq3LkH0djbmMrvGmDsX4x10+r7zgPvLPLlRfzJJYCqgGydR4NEo+bh7XjDzDH69L/djItp0at1NxfNOa5v2M8XsQmPWT+DqOK+g5auD+ES3tJRiMEaKQjbrgaROCJBHHY+8MgjtgywXjzLPph2SoVXPDB7GhZg6N+Fmn31VC/IzaOOyCdSiRzdbSBHFhB0OieCOtUDd0D+GidtrDOVhJSkmjM7tQuMzhpqLFZSb2PHJ3C+cPx7Ks4/RK5awHCMVQPE78+IHv4AdTXhyTimbaYInQU3BzGAEHA8l4i1Ra0h9ZBijXAWSnVYIqLaVF14niBqlDBvf3tesQo+uE1pdYgaVgCe43EKwudZ/X8TnY6pATC+puvLfjoeQ9W/wM6riiMer51OJ1+jNDJ59dnWwqtBJP2H+bpdngtwlDf8IFwaW+FjyPcLBXobJLhBKywfDRWq/pOM8uV8T
 TJov2A2U
 jH4DoHgK+8fOlLyjityf0f73bDU9x4yFLXq8OF9TwfDIKM/Nr89SO8ng0dqjAG70SwMgqCjgAUpdxD1Q9C/vO5tbOhD1vPt9U4D7ueoiiucWFCndjp7Ycjns5iKC4S6VvOMYGU/kth3kve6aDPwiWclriN46dDhn3p4t0eBTp97gz39ZVbLzYiaTUUMOwGFO8YscxY3BeBkzzf8LzM6vtgzfQSn1MEHzEEbPuaVx3POw21ritbUSi607z4DfAlNnd7LDQBQEb+QEg6NsPPcPVX47M3MdKI0rvUE4dK2Jiitkmkh496bbb8rDGlH4Epf4zEec0K8dOyPcqiLk6XVwd15nL4eHe5D3jR85puGnw2vGaopAzFIhW/fQsUAQR5V8UaXevBMximrJEBPfRKxSbANgPJo7J1P6AJSXxGLc63+40LkHzzBAH6NhXteMkJl++k0zQ3ZMUiFGq7pwx6TkVHjoV4pI7OkUjPxf9CR2ah8hJIbVtBeTl9Ph7c6lGIpxPPQJCnVDoMgHLVyTsx0Bozp/C6xfBrW1axs0zKWttbm3tC2s=
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

I have reproducers, get them from

https://github.com/googleprodkernel/linux-cc/commits/hugetlb-subpool-always-track-used-with-reproducers

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
Ackerley Tng (3):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Fix out_put_pages subpool reserve calculation
      mm: hugetlb: Fix subpool usage leak on allocation failure

 Documentation/mm/hugetlbfs_reserv.rst              |  17 +--
 .../translations/zh_CN/mm/hugetlbfs_reserv.rst     |  11 +-
 fs/hugetlbfs/inode.c                               |   8 +-
 include/linux/hugetlb.h                            |   4 +-
 mm/hugetlb.c                                       | 145 +++++++++++----------
 5 files changed, 88 insertions(+), 97 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260902-hugetlb-subpool-always-track-used-2624840f4c08

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



