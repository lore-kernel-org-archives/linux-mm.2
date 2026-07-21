Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29204C44524
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373A36B0099; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108416B0092; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6736B0092; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5C36B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92680140339
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:11 +0000 (UTC)
X-FDA: 85011262182.21.1016CBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AEBC140006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4prhHvb;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rOXZhyAQUiOyL9C04w4GpK7kBAaX3/6bgeIucN8faXo=;
	b=hWUIoy2HRbKimGlIA2r292bIlo54nPQPT3S0pcd55lmA+Mtv1fo5H730Vf2qw4bmPpnCYA
	+u567eFrJimLWFrx5yLsa2WRvg9JlI6XTjrdR0f3TXKK/fRAL5Li3rI//xVXpWlCMyheDa
	gE4Iqv7VkcV0xsZYqBzMhpoaXgY/Ay4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602389;
	b=HOU12a1+ROdPIvqfs/iqPki17XOQdO3g8eIqvjirQ/4Wcre1JDdYeWAkK48jvQJEqI+dy9
	UQFH/BZ3loLvuQOzixG7YNG+ye+KdnbFv9+NMUFXyAXH6CYNfGcWQYJyLFsHLGO6xH2cwQ
	abArxYJUSslB/Z+Jxt50FRGEgaqOUJY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4prhHvb;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34C3E60A61;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CBBE1C2BCB8;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602388;
	bh=/b9ba+DuL1XbYBDfD0yTQkd8n1jGFBevhBO73RcsrOw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=N4prhHvbXa9zbxYxxFLrSirMBOit2L8pcrb0UOiOmG6k/SUJInGIwP5dlbxxLsO/+
	 0iRHGyBc+rb3+xT3HCb0EXscU1AHuQvRIeW3PRwOAbEH2c18Z+mXcEYm2TEaN8tM2h
	 Q9TGxslak3H74dfBwsbubJJiEoR208OYsMHpcBrYRy0Uenx0WzNHtDqx3WFiY7IIk5
	 saFp2DxSp665ttlJU4WZN0i7qndeB3fOH0cUdn+S/CElbcRAG/hriFwo1biX+3thdZ
	 Ll7DN5dUyzkF/tkLsAm+YQoWmyInUM2fE3L3FTLY4FXiFFuEc6xUg/m+XFhX6u2f1M
	 HqVYuaAn+8RRA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AFFC4452F;
	Tue, 21 Jul 2026 02:53:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v3 00/13] Fix bugs on HugeTLB folio allocation failure
 paths
Date: Mon, 20 Jul 2026 17:25:03 -0700
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAF+8XmoC/33OSw7CIBCA4asY1o6h9EF15T2MC6ADJcFioCWap
 neXNjHRTZf/TPLNzCRisBjJ5TCTgMlG64cc5fFAVC8Gg2C73IRR1lBOG+gng6OTIJzzCrSwbgo
 I2r4wguKa8xqVYGdNsvAMuC0ycLvn7m0cfXhvx1KxTr8u33VTARRqKbtSVLItm+5qvDcOT8o/y
 Aon9ou1+xjLWP6UcSVl1TD5hy3L8gH2imHdFAEAAA==
X-Change-ID: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=7782;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/b9ba+DuL1XbYBDfD0yTQkd8n1jGFBevhBO73RcsrOw=;
 b=u+DAtxRvaQBp3wEDBRcruWX7yr+brSFQ3qMVQftTlM5gUEZdbUYZ6FNBsCubXBh8z34NyIOJe
 yDJ2EeTPmasDKEYWVrtqEz4Wg1LWCaDklIVDyLrG8h2NlcC3WGP4aQw
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: cwok9afrdn8copfbuwdcghsbbh3uwuig
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEBC140006
X-HE-Tag: 1784602389-852214
X-HE-Meta: U2FsdGVkX18S/AbQqXA4cj93QKTDukJLb1FS1/8+w/zQ+yOgBpG7/RVWNFpy1efugv4jjDh8Fddef4QigBS0KLoJdA/TNe5r8apw7GwL7FRP6fqNz5uaJkaSEHYVZ5Zf/XFyYFxE4JQXt1qQ7uxe1Vwfos0QV+KebUHm9OMWGfnuIJtVd4HHaB66GhIyX7qyAKrq0S29/p+QbbJCLLYX6YBqSgMBbbsBmoxPGlEe6wc1kulg7PLSeg1uMPJYIgEybQ0+bJBcMCNfg1/oJcy2v3rZnhGuURIKIJVGo6/X8KOnFBfj09E2blEMmepmXZ7v50kLaCkRZjjfUe7j9G08fBlS79kW5uyfmx68sPTUnFt2+u+pQxB4iC9Dn22dkaSQB+vs5ICOsjsHtqP0lxLfecdjs7RghfeNUR9JjwRqZwNn6d1CRn1Sh7hsDzeMQuPzJ/zDmZCdpodZSYdl0n/wzuZXcz+yYcLJTZTfb8UdyppxN/7Zdg9dkw1Manr5JgJfzvLPAJQtQp6Pty5ekWwBQJ4BS8nmWBhf2MatCcmSynJk7fBeCSHBlrgk7yNiHdOB7K4lIJ7M4yuCVWCS9N4x0gJqhM78ZbpAG1NoSCDtfikb5M8D1DBbmw5fbjuMhcOfaR4lTGN7swxLvGggx4qNTL6EU8OOuY14+UHTQymt2ajCAqOLWT5ktzrFYDMRcCFpDz3ueAx1aw+KcFLpzgiLvWVfUfj8x8d/H3gu/HILLnENPE7YlfmLBk2sm4OrGqYHu8cLMbArLhVjQdxDS5AAjxE5D5oLeA9MHMdYbmrIoUPi1zywcqFcixPDIvHpvpHqyEms4nnJ0bD/4gUC+F79e91AlbIVjVYJJHXHBjs4onYzMXK5vZI8QHpf42U0S1WsKQkcaQrOL0M1Noa3MS8pJYfAE4qk8rYwkFRrojN2bPdZKOWkucdClDY2rWtCNR8ve5wPgSP5e0KyFl91zda
 wmn4SaGC
 GCfUbyHALSGE97O5IyVJHJDxE8E1c2Ww/YpXURBYevCS8+23mbGWUDP1Gn+UcxdvKOxBMw17iXCL+Es7JFuDmqDOzMQNJZWaDyFs75Vbi8sU75x61LtDV1F9XRc9zNypuRypAqERhE7Qqcpvab+hKWFvyFFbUmnDPPkoETQumVrQC9S4Xl4lA0sSov0Gb6OgT2Vh1BCOE6/Q8U+gjGwRv3vmMfqs2h4CklTR2/d4racxyVww4BCP+KwfJXzcDgYjZEPELnUGnZ4vMqwDWT75qRQTic+Muu8K4xeafgjI/JhgeYpIjK76719jcWeQvk6xE0gWKtSs5dWmKZkWmnXPhhlWV5F1/IJ8nDSyyOoBm87SGRNKwJ38BY86+x1IR3oxnMbyZdMh1eqm5dT5hjksiVBZ+HtTUkJIAKjETnZNVawuKgCPWpldWAQ3D54VIozGw5kGuez38ILO3By8C3QTx1BC8RUK5KSpnSHII3Q+o/cHOOOd0A0SHvblYhFgBewkfIdeJmXwKlQVkhjjcQ7nobt/VXh9OGF3LtcXMlSNEZBgj8zlUm7QvT2NeXw==
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

Main changes in this patch series

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

v3 is posted with reproducers (not meant to be merged) and some refactoring
of subpool-related code, which helped me check that the subpool stuff is
working. I think the subpool-related refactoring and tests would be good to
merge, but perhaps in another patch series? The refactoring was heavily
AI-driven and should be considered RFC. Would like to have your feedback on
that refactoring too.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes
+ Reproducers all pass

v1: https://lore.kernel.org/r/20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com
v2: https://lore.kernel.org/r/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com

The series [1] has some changes that are dependent on these fixes, so I'll wait
for your reviews before continuing on [1].

Thank you!

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8%40google.com?part=5
[3] https://sashiko.dev/#/patchset/20260702-hugetlb-open-up-v4-0-d53cefcccf34%40google.com?part=6
[4] https://lore.kernel.org/all/CAEvNRgGN0HSJ2iLSDD2haSKOxifa-uhkO9Hwossh0+Q_d9fzOw@mail.gmail.com/

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (13):
      mm: hugetlb: Track used_hpages when getting/putting pages from subpool
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Use try-commit-cancel protocol for memcg charge of folios
      mm: hugetlb: Remove unused mem_cgroup_charge_hugetlb function
      mm: hugetlb: Fix subpool usage leak on allocation failure
      WIP: mm: hugetlb: Move subpool functions to hugetlb_subpool.c
      WIP: fs: hugetlbfs: Refactor subpool getters and integrate with hugetlb_subpool API
      WIP: mm: hugetlb: Make struct hugepage_subpool private to hugetlb_subpool.c
      WIP: tools: testing: Add userspace unit tests for HugeTLB subpools
      WIP: Reproducer for allocation failure due to cgroup v2 memory limits
      WIP: Reproducer for subpool usage leak
      WIP: Reproducer for false restoration on shared HugeTLB mappings
      WIP: Reproducer for out_put_pages subpool reserve leakage

 cgroup_v2_allocation_failure.c               | 160 +++++++++++
 fs/hugetlbfs/inode.c                         |  25 +-
 hugetlb_reserve_pages_out_put_pages.c        |  49 ++++
 hugetlb_reserve_pages_out_put_pages.sh       | 153 ++++++++++
 include/linux/hugetlb.h                      |  17 +-
 include/linux/memcontrol.h                   |  30 +-
 mm/Makefile                                  |   2 +-
 mm/hugetlb.c                                 | 244 ++++------------
 mm/hugetlb_subpool.c                         | 223 +++++++++++++++
 mm/hugetlb_subpool.h                         |  21 ++
 mm/memcontrol.c                              | 116 ++++++--
 subpool_leak_max_size.sh                     |  71 +++++
 subpool_shared_leak.c                        |  29 ++
 subpool_shared_leak.sh                       |  86 ++++++
 tools/testing/hugetlb_subpool/.gitignore     |   1 +
 tools/testing/hugetlb_subpool/Makefile       |  18 ++
 tools/testing/hugetlb_subpool/test_subpool.c | 400 +++++++++++++++++++++++++++
 17 files changed, 1399 insertions(+), 246 deletions(-)
---
base-commit: b95f03f04d475aa6719d15a636ddf32222d55657
change-id: 20260706-hugetlb-alloc-failure-fixes-c7f775eca29f

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



