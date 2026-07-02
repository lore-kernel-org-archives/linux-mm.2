Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6144CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E539F6B010D; Thu,  2 Jul 2026 20:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE1D36B010F; Thu,  2 Jul 2026 20:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E956B0110; Thu,  2 Jul 2026 20:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 869146B010D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:41:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDE3F8B68E
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:54 +0000 (UTC)
X-FDA: 84944352948.14.FE227A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A7F2180003
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDPDV4FK;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783009312;
	b=YH0DoMIExaU03ZbUuX9LXyol0gSb+U5QsrTirnCMqZj+2wGvHiSOAGQiEUdP2Goaip3/r8
	jki1NYP1FkLhmw9HAzWMCNT2p4y53QVP4nLk3BN5WKoK8PfttdBuV6mp990vzX4MuigfQB
	iM+XpyYplnUDOXvPjf8wJyCPEV2FsxM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783009312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WZDLBXjRg8Oe1jRy0IEV8CeZjx72SBKOhHr0UsKZtFk=;
	b=zRmRgjqGMk+LzF3RumzvL7ye5TKCjkayZKpL1djms/Si82Bpq26k1HtssB6CRgz7InMrWs
	DVwzWNjIP0BKDOKLimXAdjZ44j+vlHR8uy67Uo/TG14p9hMwSjvmFGeeqC+kQcnvDVB3J/
	RBpBmCreI9lb3I3yaZnfnPg7A8Cgk1U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDPDV4FK;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06CD1601EE;
	Thu,  2 Jul 2026 16:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A01BEC2BCC7;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783009311;
	bh=hiTTHL9a0qLiWbd6zy0olFhlRuJG9+JDT8dd4m9jteg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=HDPDV4FKttd6/K+xMS2wdT7l4NCRYKilHQGA+MuCqJ9a/U8fqoNMxahw7jogE/GHk
	 3ChtnAgOvDyxUZt+A80GP2QnIBI6lG2pHWLqNlscb5InkeZevh2s+v1AYq44Ws9V5c
	 LKgZ9XN3cNBlS78j7E9pXMdvuQcpnslEM85+9rcOnKa0QbISVYIvh2vhqxf8MZxJz1
	 tF9jo/3qazVduV2zfnQEsOmhlsS6nOIvbVtN5az2L9Or5dCWX3DZZaD9/SqohwlbGL
	 wiU8c+Zgz6CjYWSg2o0Ko7xJ2ZEnMvueckSdDN/zJVTgMYm24/6ydw5b9TXui35+W8
	 8GGnBj3NtF38Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E85C43458;
	Thu,  2 Jul 2026 16:21:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v4 0/6] Open HugeTLB allocation routine for more generic
 use
Date: Thu, 02 Jul 2026 09:21:44 -0700
Message-Id: <20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABiQRmoC/2XOwY6DIBSF4VdpWA/mighMV32PySyQuSAZKwaR1
 BjfvWgySSddnsX58m9kxuhxJtfLRiJmP/swlsE/LsT0enRI/U/ZhAET0AKn/eIwDR0NE450mSj
 qTitoZd3BJymvKaL1j1P8+i7bxnCnqY+oT8eEjLGqpQTVciFY5XyqtPnFOOCaRndzIbgBKxPuh
 9b7OYW4nnmZHeZfiXgryYwCVUxoMK1lyppX60jJzQtQq3egKQDWvGuAcSmt+gfs+/4Ef5oKAy4
 BAAA=
X-Change-ID: 20260504-hugetlb-open-up-eaba80571b09
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com, 
 jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com, 
 mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com, 
 pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org, 
 rick.p.edgecombe@intel.com, rientjes@google.com, roman.gushchin@linux.dev, 
 seanjc@google.com, shakeel.butt@linux.dev, shivankg@amd.com, 
 vannapurve@google.com, yan.y.zhao@intel.com, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783009310; l=3720;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hiTTHL9a0qLiWbd6zy0olFhlRuJG9+JDT8dd4m9jteg=;
 b=ERg9hmAD6VrUmgCkE7oQ5DfH9+yxr8RuhcVr2UAd2eaQ+8HZRPQw0bazPfS2q/LlF2fW2V599
 hzJIL49uXUdDJq94xDBCFKDgEq44hMo8g4reAYSPfrNULI/FotDk+5c
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A7F2180003
X-Stat-Signature: 1t7j5e64zydc4buqu3bmsuxkair5sqoe
X-HE-Tag: 1783009312-539065
X-HE-Meta: U2FsdGVkX1856R3WGdEHqqD48YgCcdWL7x/07otDtrLIuLdJrDt4xyT1j3HbvVawLv9HOG2nuNDkwCWty27TR4Hprga+PYHOhHXpyL4R2PTxuPBpEJ6dXhskUhBRfyHbr8A2RfHeHbDrYheNy8L8c7huGT651kYwsNe6oCcb9RbCJ2IUsGRHRWsAolWUon4y2+1bIYLU9TYliWpPnz0zHegyBqCiCezBQZ4M4Kfc93XTzmfi65+wKwoh8u5FrbFKz38kF4xEVDU7DothqWgzbCfS0aBYDpVrPo7BTgnne6QP2gh6tJAEnZlpxew53P9X6JOiTvogwZJHxLxCUxOvnJbPM8ZxH8549AXZ3qi9BWQjzVC9dQbG7SmxR97gBkN8b4JUa/G1h3y/d+25SWx+zfxG3ktsx7Blod1l8yK5sEsd9alKWHXvGxA1JfIODXnsVgcnAJj9FpyXqDdlcne1Yhm5PUTjzXzyB50Me9sitvHUj0SOq688y69HPrPuqy+OBhozJxZNUsWzGryS7LYZjB+WD+jlokeCFKJeUyNqvJuFFw1gM0Ygv23+gfniFkt69rbuUtMSLrdUTfTmIY4yRJVBE5ispkymKjgpW4HLgrkTS2dDJ8KeBQ6XQRUAvuaoPFuGmcbq1Xc3jIgtCjn7J7AIyyeST82BX3JCUzIjo7Fn8LdSeiIS8hubI7sANKNFNo4LmDHUi8hn9k/cc1YOnAs5TvOobuj2l+eLwMx3YFc13Qwc2SU0ksCzQ+7/9uDdk5NWuCSfjrrZDg0LzkLJgw+5tyBI0PuVLIsj0k2+OtM7ltXj3CEe+vwC1PBBD2wruxhn3zmIutDbeJ8kgUnW4hJVCTVkTZjfusuTI4PfHLfYoIdNue18WLInUUivXyKnA84Rnb7FYxDZSx8ockbpezGNAih+NnH/iblqrxHM8JTkE2MqlAn/F4c8cR56MgMi1WEi7YjC1RNq+d5oTtE
 cBxTmmIU
 1TNbemf9/g/yj0Uo07nRu0hhKbk+gX9NCV4D7Hk9WzbpHiDYIGYWRKEX2vpcZOroIKEFyw1swa0PCPQM7wSx0sm3GwJH6ueXnZcET0C/LfmN6gW9NQ50aEGzRW0X+Lagu93TwppJGvD0Y9/9nUd8+0W0SAYOuyesXE8tf4wZ4hHQB4m3d9HFHuvJyU7f08tHCg7JzHRJHZR8xCxut0UfQWUXNxEZHY94gJDcN8z0sv4d23YDcL+cXwH9asS0KKHGTEE98nVvurfRGVuq/zJzaqhI86sfseRenUviR0bODoGR3ZebR4nAD4xUljLctrppzzinK7ZcfjfILa6GtsfYYuUZCS/ylCxOy/SR5uYsgDNwWBlh6woQQplA7KuwcaWsF0wIyQTJ246SigZ/NmSQnhVdhZwHtRZvlgZGCTPD5C5ZMsqAuiJHjPDJ3tTlddQK5N4igIQyO8zZ3UWcFsUdE+smrVD0Anx380ENC3s7DV0rLO012qNVs9zeFSjY5pPakualHoQUS2sFsfTQGm8unlxDfnFmE4uH/OkDDWp3uCbVoQJZ6e9DH4x3JzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The motivation for this patch series is guest_memfd, which would like
to use HugeTLB as a generic source of huge pages but not adopt
HugeTLB's reservation at mmap() time.

By refactoring alloc_hugetlb_folio() and some dependent functions,
there is now an option to allocate HugeTLB folios without providing a
VMA. Specifically, HugeTLB allocation used to be dependent on the VMA
to

1. Look up reservations in the resv_map
2. Get mpol, stored at vma->vm_policy

This refactoring provides hugetlb_alloc_folio(), which focuses on just
the allocation itself, and associated memory and HugeTLB charging
(cgroups). alloc_hugetlb_folio() still handles reservations in the
resv_map and subpools.

Regarding naming, I'm definitely open to alternative names :) I chose
hugetlb_alloc_folio() because I'm seeing this function as a general
allocation function that is provided by the HugeTLB subsystem (hence
the hugetlb_ prefix). I'm intending for alloc_hugetlb_folio() to be
later refactored as a static function for use just by HugeTLB, and
HugeTLBfs should probably use hugetlb_alloc_folio() directly.

To see how hugetlb_alloc_folio() is used by guest_memfd, the most
recent patch series that uses this more generic HugeTLB allocation
routine is at [1], and a newer revision of that patch series is at
[2].

Independently of guest_memfd, I believe this change is useful in
simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
pseudo-VMA.

Testing:

+ libhugetlbfs tests pass
+ ./tools/testing/selftests/mm/ksft_hugetlb.sh passes

Andrew, thanks for nudging me to send a v4!

Oscar, you mentioned that you wanted to do a closer review on v3, hope you
find time to review v4 soon!

Changes in this revision:

+ Define gfp within hugetlb_alloc_folio() instead of having it as a
  parameter so users aren't able to override gfp arbitrarily as Oscar
  requested.
+ Addressed some of Sashiko's comments [4]. Some of the issues I didn't address
  were pre-existing issues. Since v3 of this series Sashiko was updated to
  actually send mails. I'd let Sashiko point them out again and then we should
  discuss those!

[1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
[2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
[3] https://lore.kernel.org/all/agqaUcVp_hwH-VXr@localhost.localdomain/
[4] https://sashiko.dev/#/patchset/20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com

RFC v1: https://lore.kernel.org/all/bb35a69a-5be9-45f5-a557-1902487a1bc2@linux.dev/
v2: https://lore.kernel.org/r/20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com
v3: https://lore.kernel.org/r/20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com

---
Ackerley Tng (6):
      mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
      mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
      mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()
      mm: hugetlb: Use error variable in alloc_hugetlb_folio
      mm: hugetlb: Move mem_cgroup_charge_hugetlb() earlier in allocation
      mm: hugetlb: Refactor out hugetlb_alloc_folio()

 include/linux/hugetlb.h        |  18 +++
 include/uapi/linux/mempolicy.h |   2 +-
 mm/hugetlb.c                   | 269 ++++++++++++++++++++++++-----------------
 3 files changed, 175 insertions(+), 114 deletions(-)
---
base-commit: 4a50a141f05a8d1737661b19ee22ff8455b94409
change-id: 20260504-hugetlb-open-up-eaba80571b09

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



