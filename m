Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88C8EC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECAD6B011D; Wed, 12 Aug 2026 14:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F421E6B012C; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09956B0125; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9EFEF6B0115
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BF43404BB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:17 +0000 (UTC)
X-FDA: 85093505154.21.84330DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 25FEE4000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EaCvF6Uc;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=toKhu0TxcH5ntwemmHv8Mz40UJ3KjjbTDR1LDZDtaL4=;
	b=aVdnu6Ua1vTAY/vpnbn7Pnd9XbaOc56Q3BEOvKeSyv+z6WIBbHa7mfaWt+9c3lzQiSbSga
	HLayzrxmGJN1BGyXFptAhob3z/VsWuOl1xEmnewkRo9rN/Vx2C7KNpmg+WQbv06dZfB9g1
	h6O+slwxn48CxoqLWzceMukCotCfQ3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560555;
	b=1n2MrJEN86OrJFAfcXDSHHSCXVm1Q3IbQGyUMIMOcjp8KPq6i3RvPZFzs1TL2+SdJw4N8B
	Cb1aroTI16Zi40FutkqtM6wW4LVVi3Wa/7MH4jCX4GGjKYaUi225jWT3YMqsmMmREDd/xc
	TiNTWm7jsKVTzec5KDYL83loFRycWws=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EaCvF6Uc;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C91D060A7D;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7240DC2BCB9;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=cS/DRm3T1w8AnhEL+a5sNkHisk1wBvpNnNQjFJ3QUD0=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=EaCvF6Uc8Dgu5xj/Gt9BQEcYEgoUX7i7R9BcSJdoX8+QCFSIb4prsp6S26fOnS2e+
	 lR6u4OciS64bFfqc9D2rZ4k60aPj7gp0+JV5622bFtoOKtl6AM2OhHMhW8J0m1Kjoq
	 9A/vyexrSjxzSBeGNAhoKDVSvZLmtPfTV/8OwZ8RBsKL0GB0egJeIfsHdhk2bA+HQL
	 3JXU2IcOLyth8KKUODL1DrqPZwA0kk7FvmqvlsWUdP95G1Glb6HvBNNd6jVohRleZZ
	 YdUhTPeLQJ6RXIsQv5SEI4pnWWGgR4aCUqzdQWMQiyoxzacap18ONKnPR1siOgJAEX
	 tEztFjQ2KdmxQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0CDC5AD5A;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH v2 00/17] mm/huge_memory: clean up folio split and lift
 swapcache split limits
Date: Thu, 13 Aug 2026 02:48:40 +0800
Message-Id: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNQQ6CMBBFr0Jm7ZhSTC2uuIdhUcZBarQ0bUEN4
 e4CxpXLl7z//gSRg+UIp2yCwKONtncLyF0G1Bl3ZbSXhUEKqYQWB4xP4zF1HunOxg0eFbFsWFF
 bNBqWmQ/c2teWPNdfjkNzY0prZzU6G1Mf3tvnmK/eL6//82OOApUuy6I0RyIqqsSO2KU99Q+o5
 3n+ABime4zEAAAA
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=5389;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cS/DRm3T1w8AnhEL+a5sNkHisk1wBvpNnNQjFJ3QUD0=;
 b=cGb0ihuJjQseJijrhkFcKel7j9wankm8y87HLfO+Egg1Uu5a4fL8JLuIQHqpaq2bZvLLUzeoz
 bicEUiLx9OPBvo3rx/8Oz5G/duOtIwUhEkn2vRqyodP/qAORhVCk9MH
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: 9mguc1kckkn1a5yjdnh4b5r3r7k3cq6z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25FEE4000A
X-HE-Tag: 1786560554-829484
X-HE-Meta: U2FsdGVkX1+5CShG0ftaZMDu7FmuXSMrZZYzeGI1ctNSWlQ5naxJcvjYfZw13zv6GQ/xA4De3dLY2Sfyz+W+OSfsq2b0HJ8XauX9LRaARpDZodnLyfqklJZZA3vK9h6zRkFphWdQ7K60MktHsQJ/zYayJPorhoAzbrbnZu4A2e/eLVKySotNNcfOTbhvz1aHldKrqM9ySP4afLP8iFR8OZ6hWyTLAxnZXhuq8TEtYcFdEyXJ5X37mHBe4AU/GLl7mmbwheE5AmEg5kuGxYJc9SmsQk3RDZ9O1HckI1U3b/qliXnCFXL8IEAv634rTGcj0sOx1v04CE/vcfZcMIXdLOZ5WAwElwND9rYtvOq/0lUfu0php1g4fqlLLhjGw8NbVKZngfzi8RFcsP35uiMAaxvYv991xFG0TBbvpOOoVJCPDEsWM4kkp1YifAR1BKo17o2dKxlzGVF0oUZuBLVfT4EWR9bSAkNHG00CL+mJxf2f54YeDhAWuSJdGw5fm5W771Hn4XdEEiCx/rrcqORQmgpyT+NgWrzOi2Jxw+T6JLYdTP0PCpt53WKykBhRva+Opma+rjvsAqeye6OOqzsi3zoRM4GkEF4cFAS10QpK8sHwOjfwOGY8pp4XGqvrZ2pmOzeHrg5XgeXiswI3RJBE9MURQXlvFdvvawqmNKKkuFCgn5T4BUqFgcdbVDeQKZY7Zdz7CYc/PG7b+4RQsa9evCgZE4IKMOlwhXsEKCFOFXy1apjt1ZzIOSSnuyl9n9eLD9pGMJZ/hXGY+p4xZKlSpsVqEyOtfeOm/9sWZi8juS0jdkFOl+zu5mfYcJS5zyMWrZ+Ot8lfXx9OHvOyjcclBSSoNMv+51ZqHsU3xdbj8E4yZ6w0gCUdS9nNQLl2W8gXBNZYpoKV5dD+rOnhQHECaBSEFWw18nKy8L/HdVZFrn3p6QBlAb4K6rgU/Avban9i+JC0txtGdagTrCTuY6a
 IFSSjC04
 /+TBb8cRCMiUbwmE64NdTr7T1Ng9frXSxviurk3oMHTv7cnTx6QFy+OwLjRI7YzR1vf4y1r2gFQqLN25k3REho9yRr90U14a63Y6NBFw+jHhg6ZFXBG8O20faqvQdQ5oZc654EQBz0Z8jdP4GFrL4x6Tt4kXzcxa4P0cLrEsgK6PiiFfCJeGDUtxk8JImdfWULQLmurJOPll7kWxxjMwZ5vgAWEfW3+2CrKnqNAnqCvPQV67sO/LHSbJCQmWF2xgugGtbFQYh3F1rILUmyvD2JN2GKBmwMCm47cqQd/bAFHtEVwRxSw6KZ4MNmI4HrEBrGgIUHCJZ93dtIApN/xbmYeCgjrJFmr5VNfHxcbJjW0w67N4ZG6p5ZaW1ghd8hsFrrC2wluUtXRg5b2hEwOYidQZYtAJfgK6M+8Hh/aus3C6nKsI07zLzDXn7zjoXG1MQ27vZJt8fvtRNobQOAd58jLcd8G4EgoQ6w4vgKcHDFBHlaon/2rS5k1VR4XdwG2nvW28VmhT+pvgrGhtp4jU2F7yAiTe5hZxEFnWuMlxzMezlLAc0qB/ZEro9UmfciHLWeNiYWM9y2EkR/JtNs5Az3/wFxV8+Xlw8LbWU7hz1DH1ta01o4dbb1yht3fK3FTG9acHaaBmad/T8enDCuOskaAC6/c+UWailWc2x5X+3OgYVuMLDItItf0GSJvNk1K8cRyT7smrQgWN+ulQL2ckb1ZsXLuN/nlcDDqL6IFzhzsleTMmYL2VjFvtp9EraRxFb7NczcBkl35cC25hkxw2pUnP1H0dpzXb9DgF/baxCUxPyZ5eaCJo8wIgttqoiIa9T88l2DdgduY29EnmNDNbzIm1TJF6n4pdVn5uRqwf0phz4nd6oh0e2hXhbODRX1kUfwzSPfoEeXBBQlP+q/Eu+Mi+CSHOide/0Kkp8
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
mean +- stddev of the per-run averages, 135 split calls per run):

  base:    24 runs, 69.6 +- 0.7 us per __folio_split()
  patched: 26 runs, 68.8 +- 1.3 us per __folio_split()

The patched kernel is consistently ~1% faster; with this sample
count the difference is outside run-to-run noise.

On x86-64 with gcc 12 (-fstack-usage), the stack frame of
__folio_split() shrinks from 240 to 96 bytes, and the worst-case
split call chain from ~544 to ~384 (anon) or ~464 (file) bytes.

Bloat-o-meter shows a tiny growth of huge_memory.o:
before=58419 after=58446, chg +0.05% (+27 bytes).

Signed-off-by: Kairui Song <kasong@tencent.com>
---
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

To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: "Liam R. Howlett" <liam@infradead.org>
To: Nico Pache <nico.pache@linux.dev>
To: Ryan Roberts <ryan.roberts@arm.com>
To: Dev Jain <dev.jain@arm.com>
To: Lance Yang <lance.yang@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Kairui Song (17):
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

 mm/huge_memory.c | 636 ++++++++++++++++++++++++++++++-------------------------
 mm/swap_state.c  |   3 +-
 2 files changed, 344 insertions(+), 295 deletions(-)
---
base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
change-id: 20260804-swap-thp-cleanup-6ce2be6cf3b8

Best regards,
--  
Kairui Song <kasong@tencent.com>



