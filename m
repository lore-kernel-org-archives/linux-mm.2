Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A48C5DF86
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137566B008C; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114466B0092; Thu, 20 Aug 2026 14:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0249C6B0095; Thu, 20 Aug 2026 14:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD2476B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C64812023F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:30 +0000 (UTC)
X-FDA: 85122551220.02.A214F91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 78B4940004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TM8PZnbs;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252128;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DsxN5xdqpKHjPcPGUkgfpkDgSIDM48Y5efx6sT5tqUM=;
	b=aLzWRnKy1EU7KvAsvi9AK1MsuvOdripO1nbxOHFy5+x52a+DpgeLvxbZzgLRiuV1K20dme
	pBokMUhB/1G0+OzqSR6tpnfxeAoUFHC0jDZ44Hlbx5WBNkXQlnfsebo9Z0BYpA7APysbUv
	ClkZWc5VCqvB3i85Im9j8eR38jcqTA8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TM8PZnbs;
	spf=pass (imf11.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252128;
	b=iMygM6fRqq/IW7DvvKG3ZWiIT/NN03sMXVXhKPt0Jd97dJRJJcTKvPMS+OzCnskCRTKp4q
	Y5YCjHQYWCg5CUauNIS0tFTMTVjo0pN0f+GMGmOVl5vz8d5C7uTiuBLw+t32G+ZlYrOYe0
	PuSGRAj2MHpLuPrtTYtCLrQwr/7cN50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D668B60A7D;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80321C2BCFA;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252127;
	bh=Nh1z2UMuz3wh/KOtpGfftf3doRz64lPxSzA8cbjdwuA=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=TM8PZnbso0RBeCT7PB9Tk9yNtjysCh/Jk7plk3anqLQ8OVY/Wv5AI5ifzqXMO4ABP
	 IcQoOwZzExncscLVmXLlcnktap+7Ur91gOM+38ViEa/BKvveIDKWAQxblXPifn2wq4
	 uocrGX8j9/TLCepEHEdp4cIkq/FCytGUdCc/T4ijLIJoEy3O2385wAi4d790mhLPq0
	 2dnxyYsXK9LrwCaVgAiZxR02WvmL8zSLi/V1Jcz1icqFxkQ3MiYv1DoSqQlNIBjQkF
	 a0TyqckZQrIyas7FQvLfkJCs5SlhxU3mrmRWBTMZwxKfMGOCYRfjyxzFDBGNaFUmVU
	 0c5nKVw3YltIg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5B4C5DF85;
	Thu, 20 Aug 2026 18:55:27 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v3 00/18] mm/huge_memory: clean up folio split and lift
 swapcache split limits
Date: Fri, 21 Aug 2026 02:55:13 +0800
Message-Id: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NQQ7CIBQE0KsY1mIoNAiuvIdxQX9/LUYpKbRqm
 t5dqDHR6HKSmTcTCdhbDGS3mkiPow22cymI9YpAa9wJqa1TJpxxyRQrabgZT2PrKVzQuMFTCcg
 rlNCISpE08z029r6Qh+Mrh6E6I8Ts5EZrQ+z6x/I5Frn35tUvPxaUUam0FtpsAUDsIzpAFzfQX
 Uk+GPkHUYg/BE9EzRFLBdKYUn8T8zw/AVZVQ/UHAQAA
X-Change-ID: 20260804-swap-thp-cleanup-6ce2be6cf3b8
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=4769;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Nh1z2UMuz3wh/KOtpGfftf3doRz64lPxSzA8cbjdwuA=;
 b=yuRxAZ3eMnSIl1AX9oYRxwJpXwdFu7d8viw+AtghVUYmcdBh3bpPBdg5oGD5KajA4RSoWK8/4
 QZsZbaj+4ynAqZ27x9MHKAmey8lmqfJ/PlVipt0/y1gzrEIBwiRLahO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 78B4940004
X-Stat-Signature: 1dbmd3pue8ykpgw7zn3f7uk8f3s797tc
X-Rspam-User: 
X-HE-Tag: 1787252128-723009
X-HE-Meta: U2FsdGVkX1/DHJ7DauPjTOPzMeBDkKWA+RyX/K4/nbHmCcjBth/YgNFck5lQ9kw2YCmZmp9jsn0/QCymmwg/UlisOhHfLFOcB3WhTbRR33RWNg5+5A4M0oHP0JuMNGNMnGWy20I3tMJM3nFBnNPk8cMI7dhExenjY9qhJBQNpOnEmNWcoUi7m/yWhaJm2Me/8Fcm0As8WJfyX53h+G+KiGEJD4TKtaNJ9MTv8kgDfht8Qq9ZOs1F4S7maIWIV5ww2fjYLG6S433eb+WzCztHNfaXQQoDVGalWAE8i6QaHy4WA/7SIXheNYOBYWSZqHjOmxnFBtKJuEtBsWw3XZXt7lfT88NBqgJ5NQNWr5yWcX8hw4QsP++E6WPvj30182Nm4k0HnmxuXnvnRd2+nEx3xlEgzYyXf/XYQGvQtBDoKKcUFY3HljZwa+NIV8i6KlbdsUy7Glze/5NSTUlGXZBIlXs25m9OI/3tdU+5C2l4v2ZxB0quZ7UD07JAVDHMvbsz/G0oHirADtVHYvQAK2C/ndw4GWlhJTTHA+02ri5oBmS+J3na24mVqs6igu2vO6WdQh9m6W70fcsDAAGN+cuC3gV48eNwtcFVwFUebN3D2IQk0JbyvyNcQ5BnNdyXUGeQsRjWV9McTKSkHGqS0n6uRhI1Bm1dpjlO7bTljqvmfPgewxUL0bmk9yLD5RJWBRfD7hNmRk8poPKlCSwHvGYAWQdWxwcAIK/HS7YvCIZq2KVZ8x9p7sd5AMXUpDHjbRADAz2mWLITk7SHpOvA9UnuNr6GENrPxyH69CiXl3BarVnORAtipf/RhgVK5CeUUqdWvlp0u2iqRLaql2zj974BJMypGR9wAQeVC1v3st9mZmd8fzJv4XAzPecTBh172vQvVkttBXB+4yKWtqooYuF4sS/9ek9ytYrEantlys2yM7+nARtaWb+ZbsYJVLXg4hTlfQfdCroprv6fsnrDBex
 qr4+GXRY
 F/ld2pnfs2m/owl7aT7C2T3JDL8pWRPCUsu0QeUgb8OaLWMngAkFTkf7eX1rpaBYsJrsyxKyicyC+bF0D9oErb+lg7e401TOGuY/f16cGtt6st+tGlDF4GBSNJMBP6hZlcKdWgTBOlIoy/gvMjjhnzPsh6a1UQej/bKzOC46MNmym1fibtkp9IIePZYLePUx7l8W+qAhxUZXfJdG64kVlQnn9WK3vga9Uf6RypH7ZVNQcQk8z2QhiKN7SFOaKQUzNRGbH7NhzitaXRLcTmqd4naY+3Ct+FnPhuN7+G6bz3A9GBnM4XFSdWXifNbuMqwfJYWxR287YArnFfFPsBXPXOIQFI/UOGMn/L+mS0bYwvm/wJH5N6qsAGpsrli41Y6kjWPpYgLKHspVVl/k/Qy7UIJ+kP7PpF73p/hYsL5FOtTaSfEZGZgjluTJg0F5psjL5Oh1vbVWEfOx3ZJ3UP6iWUhKHf1YHXG9I0wyj+cr5zrbaK7sv2lpt4fs0/uhh+mQ5zFp47CPdpJ1qBjpjy6vf/lUfiXLcGYOOXba0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series clean up the split code, add better swap cache split support
for mappingless, large order, uniform and non-uniform split.  Generic
performance is on par or slightly better, and stack usage is reduced.

The swap cache infrastructure can handle non-uniform or high order folio
replace, so there is no reason for either restriction from the THP side.
What stands in the way is the mixed anon/file folio split routine,
which makes lifting the restrictions hard to follow, and it already
carries some buggy or redundant checks.

So this series cleans up the split path and separates anon and file
splitting into two helpers.  The file split path never sees a swap
cache folio, and that is now enforced up front: a folio that is both
in the page cache and the swap cache can only be a shmem folio, which
remains unsupported and is rejected early.  That helps to rule out swap
cache handling in that part completely.  Only the anon split path
handles swap cache folios, with an anon mapping or mappingless:
either way the splitting is similar, and non-uniform split is
supported as well.

Order-1 is still forbidden for swap cache splitting.  In theory it is
doable for shmem swap cache folios, but a mappingless swap cache
folio cannot currently be told apart from a shmem one, so forbid it
for all swap cache folios for now.

Testing:

The in-tree split_huge_page_test selftest (uniform, non-uniform and
in-folio-offset splits of anon and pagecache folios) passes 62/62 on
the patched kernel.

ftrace function_graph tracing filtered on __folio_split() was used to
compare per-call durations between the base and the patched kernel on
the same x86-64 box (interleaved runs across alternating reboots;
135 split calls per run, 50 test run):

Before: 67.9 us, stddev: 1.59
After:  66.4 us, stddev: 1.19

The patched kernel is slightly faster. The stack usage is also reduced
by about ~10%, with a very slight growth of huge_memory.o.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v3:
- Get rid of for_each_folio_safe and open code it.
- Check if the folio is mapped before freeing it swap cache to avoid
  potential performance lose.
- Initial test and binary analyze showed everything is very similiar to
  previously series.
- Drop the redundant mapping argument of __split_frozen_folio
- Link to v2: https://patch.msgid.link/20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com

Changes in v2:
- Return -EBUSY instead of -EINVAL for swap cache & shmem folio split
  attempt.
- Introduce a for_each_folio_safe macro to dedupliate the code and
  hightlight the reason we need to keep the iterate safe from folio
  freeing. [ Zi Yan ]
- Rename __split_unmapped_folio() to __split_frozen_folio [ Zi Yan ]
- Rename __folio_freeze_split_unmap_anon. [ Zi Yan ]
- Several comment improments [ Zi Yan ]
- Drop an unused do_lru argument.
- Previouse test results are basically unchanged, stack usage reduced,
  object very slightly larger.
- Link to v1: https://patch.msgid.link/20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com

---
Kairui Song (18):
      mm/swap: fix off-by-one in swap cache replace sanity check
      mm/huge_memory: fix rejection of swap cache folios with a mapping
      mm/huge_memory: invert folio_ref_freeze() check to reduce indentation
      mm/huge_memory: split the routine for splitting anon and file folio
      mm/huge_memory: rename __split_unmapped_folio() to __split_frozen_folio()
      mm/huge_memory: consolidate irq and locking for folio split
      mm/huge_memory: move EOF trimming into the file split helper
      mm/huge_memory: move unmap and remap into the split helpers
      mm/huge_memory: move anon_vma and filemap management into split helpers
      mm/huge_memory: move memcg switch into the file split helper
      mm/huge_memory: allow splitting mappingless swap cache folios
      mm/huge_memory: add kerneldoc for the split helpers
      mm/huge_memory: drop the unused do_lru argument of the file split helper
      mm/huge_memory: clean up after-split folio freeing in __folio_split
      mm/huge_memory: lift order-0 restriction for swapcache split
      mm/huge_memory: clarify supported split orders in comment
      mm/huge_memory: count only swap cache refs in anon folio split
      mm/huge_memory: drop the redundant mapping argument of __split_frozen_folio

 mm/huge_memory.c | 633 +++++++++++++++++++++++++++++--------------------------
 mm/swap_state.c  |   3 +-
 2 files changed, 338 insertions(+), 298 deletions(-)
---
base-commit: 4b2ae13f3393ef4b4bce0021e8762790354f369f
change-id: 20260804-swap-thp-cleanup-6ce2be6cf3b8

Best regards,
--  
Kairui Song <kasong@tencent.com>



