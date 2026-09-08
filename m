Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E462C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265F76B009D; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218016B009E; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106686B009F; Tue,  8 Sep 2026 09:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E431E6B009B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:52:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 826C5120693
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:06 +0000 (UTC)
X-FDA: 85190733852.17.51C034E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C44EB160003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:52:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWAnosmg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SZt10/kbg4dBrQBGOpfHdt7lQPvcQoF9Yzt06P+161Q=;
	b=v9YkXX8GCrXqqnjqJRTdmTnDpAKXQ5avEn5ToYGQLZaiMKGDz3GyhLIpAv/7LSU8AOVZ8y
	YHYbZrylQrMxA9JJ4WUbyAkZ22ACougqjOjl+c6O3YAb5al6bYyYog9EUBrAWaGcsHnuh1
	gorlFs2J+FGT9wlrtnxBWrPW9zE+Gs8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875524;
	b=V/HicnpSZaGmXsCvt/qzXyuva+daI7PEZ8LulVSg77WrKz7/Zl+QccyiZa2U1SBt19xBSV
	HG3Y3AbrTjD0yc/EDd6OcMGLgCc95EjRUnCp88e1yUib1Qg64TYsb9+7TgB/Rey/NKVRLH
	Kht3qwHhNeRFZq5Av7yRvkBA16B0iJI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWAnosmg;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E1B0B4163B;
	Tue,  8 Sep 2026 13:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCF91F00A3D;
	Tue,  8 Sep 2026 13:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788875523;
	bh=SZt10/kbg4dBrQBGOpfHdt7lQPvcQoF9Yzt06P+161Q=;
	h=From:To:Cc:Subject:Date;
	b=KWAnosmgGjBBtakeFBzQt6a0+nRkTuo9pUfHhAak7/qUDiz8VM3IsGRE0XtHCboIy
	 URa2FeypaVWmYTiTRiqOXIus3LM1hgLS3VoatWswVL4wJqT60k0TKrDyhWJxgihZEH
	 4IivP5Ul/mhbjb/j9GpNx4Jp4QETmCGGUBv7HgK6l3YjN+CDtY+4TmhT4lHK9jmYua
	 T0JQS3aSiNt7klBt13djiCz49JgylFilCtnAiqWfgedkwTnFN7pT+We0bh2mZmh/6J
	 fuLqmhJLq/O84O8MISfe6EQlUM4e/p7hMsmOq0FkNttTPj512evi/FzSGJZcIIU3+y
	 DtC9RnuIWWIyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] mm/damon: support access monitoring of hugetlb-backed memory
Date: Tue,  8 Sep 2026 06:51:52 -0700
Message-ID: <20260908135156.97481-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C44EB160003
X-Stat-Signature: 6sgi4m5sppa9xig98debm6h3oqnfwhg6
X-Rspam-User: 
X-HE-Tag: 1788875524-893080
X-HE-Meta: U2FsdGVkX18NEKkjp9eqVDArmKmCoZfYo/MC5wkHbYogvaQ2XuAa5vzwup0pyvyGx7OZYIz4VY9iGLxFsxt3aVS96NyZlYATurwo4Y1TuAhUNcEGR32M/RDrlN7Fr1XKWW+UxsSC5Jgi51jca/2BIMb5nAh2QNTnvoYW8wpxpj/wu5jc4JpqqO4lrd2Dkx3dgTqm5EzcKrq2m0dNobUZAVUE0vRNUoTFw7o8IeXZr1/0rFezd0E6W5Klv83Iomm8O9Z0XHv+n3AsYfCMqVMulA9uBdCIde3J3xnykpOAgDzThHpIms/vnUugiEQ0R4/hylmO+qMJoyL2mBd+kVe/Mr0UVoS/99UT7K/bI8Su4TL9M8hK02FgHW/t6gp4nU8Xuq2z0gPKN2O4VUSCwYqS13PGkG2SSc1mD9n9dPsgDUhCOGj/oxA114afftitoGNh3vfez9O66WemygLYijJKhN96SsUHi1vZrLG3S7ejVuidBw2DunEw/lrrgUwM9sDbS2uzaFTiWQPECVU9oWyv8f+3HJ40T13ZoNe9ei9daPBOW20rNiJx8b4W2uJdMSE1HnBDL8qRnsRgY+m1FyP8lKWf3csg+ZE2EoxeLYPL/bq0cys9H58+g/WNHqf65nn2XiUKFoDExHt5FdaPPK+rpfwOD5CQrkwxUl+Nw0p5WeyOQLYV1w2OuLfWuFzjW9enwP3HWNOWRv3VHDk/dNlWHtMKMh5HPyyV8+1yVPGwKuFKK3JTat7RJ2EdII/tXFfHflNq0C1M9K6ixQFC556gVBTkqQFA/egK4HL1kNyGGCz8k3YXDrK5hvlMTD4fpzPzx3ciF5JwcgjrJ5SQub9F7pWTVANwi/KVGNLMyX4yMCAu5W3A2OjzNsXxhdoJ4ogO43imMSKU77d0q7xLn90seTn/FNRDBju+oytNLPJvbTtlc8txql1Z/48fOjqsE9uLQh9Jt2zaRGlUYAEPD5q
 hrlY75nA
 s+fYwXuPhLA7uRuOcvM4Niwgm83RNc5PGb/BvNRiH/mojxZix9UKalCcd1Bry8SkS2vol7PrUvn/mxYKzSotNgcfrkBLOBAWHU/729kRyWmrUKh2Lnez53UvXeXANF3h6ZAhZkhTcU1i0uPJet2AFOLCWTR6nLxxy1EtiUhlJGcUMShrs82GjEiiQl8BZoqjAV8zsyEMs8xxYWH03CDM5P94xJ3BGiYP0NzttE6hBorwEAd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Krishna Iyer <kiyer@crusoe.ai>

On virtualization hosts, most system memory is often backed by
hugetlbfs.  On our production hosts, for example, ~95% of RAM is 1 GiB
hugetlb pages backing guest memory.  DAMON's physical address space
monitoring is blind to such memory: every access check starts at
damon_get_folio(), which rejects folios that are not on the LRU lists,
and hugetlb folios are managed outside of the LRU by design.  As a
result, all hugetlb-backed memory is silently reported as never
accessed.  In testing on a 1 TiB host, an hour of 4-thread random
access over 842 GiB inside a guest was statistically indistinguishable
from an idle host.

The first patch moves damon_hugetlb_mkold() from vaddr to ops-common
as a preparation.  The second patch teaches the folio mkold/young rmap
walkers to handle hugetlb folios, aging the huge PTE and notifying
secondary MMUs across the whole huge page size; the secondary MMU
notification is what surfaces guest-side (e.g., KVM/EPT) accessed
bits.  The third patch adds damon_get_monitor_folio() and uses it from
the paddr monitoring primitives only.  DAMOS action appliers such as
DAMON_RECLAIM and DAMON_LRU_SORT keep the LRU-only lookup and are
behaviorally unchanged.

This series is the first half of an earlier six-patch series [1],
split out as SJ suggested [2].  The second half (the 'aging_flush'
TLB-flush-assisted aging) is deferred: we will gather more
quantitative data on the gap it addresses, including the workload-side
impact of the flushes and the working set measurement details SJ asked
about, and post it separately once the data is in hand, aligned with
the ongoing monitoring preparation actions work.

Per Documentation/process/generated-content.rst, this series was
developed with the assistance of an AI coding assistant (Anthropic
Claude, via Claude Code).  The assistant helped draft the code and
changelogs, and applied the v1 review feedback.  All changes were
reviewed by the human submitter, who takes full responsibility for the
contribution.

The series as posted here was regression-tested on its base commit
with a full x86_64 kernel build (no W=1 warnings in mm/damon), the
DAMON kunit suite (41/41 passing) and the DAMON selftests (15/15
passing) on a kernel booted with virtme-ng.

Changes from v2
- v2: https://lore.kernel.org/20260902025700.17975-1-kiyer@crusoe.ai
- Drop verbose comments on damon_get_monitor_folio().
- Collect R-b: from SJ for patches 2 and 3.
- None.
Changes from v1
(https://lore.kernel.org/20260830051407.50008-1-kiyer@crusoe.ai)
- Split the first three patches out as their own series, deferring the
  aging_flush patches (old patches 4-6) until more quantitative data
  is gathered (SJ Park)
- Drop too verbose comments on the hugetlb branches of the rmap
  walkers (SJ Park)
- Factor the non-hugetlb PTE young check out into damon_pte_young()
  to reduce indentation (SJ Park)
- Rename damon_get_folio_incl_hugetlb() to damon_get_monitor_folio()
  and damon_folio_observable(folio, incl_hugetlb) to
  damon_folio_acceptable(folio, monitor) (SJ Park)
- Drop 'kernel' from the host-side monitoring example in the patch 3
  changelog, since kernel memory is not LRU-managed and hence not
  monitorable regardless (SJ Park)
- Add SJ's Reviewed-by to patch 1

[1] https://lore.kernel.org/20260830051407.50008-1-kiyer@crusoe.ai
[2] https://lore.kernel.org/20260830180411.103772-1-sj@kernel.org

Krishna Iyer (3):
  mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
  mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap
    walkers
  mm/damon/paddr: support hugetlb folios in access monitoring

 mm/damon/ops-common.c | 123 +++++++++++++++++++++++++++++++++++-------
 mm/damon/ops-common.h |  10 ++++
 mm/damon/paddr.c      |   4 +-
 mm/damon/vaddr.c      |  34 ------------
 4 files changed, 117 insertions(+), 54 deletions(-)


base-commit: 7aef702c0e8b9870275f8ec9ac1d63dc1d254a2a
-- 
2.47.3

