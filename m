Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD45D43352
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 21:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5B86B0005; Thu, 11 Dec 2025 16:11:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 356356B0006; Thu, 11 Dec 2025 16:11:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C4B6B0007; Thu, 11 Dec 2025 16:11:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0D90C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 16:11:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DDD6134B63
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:11:30 +0000 (UTC)
X-FDA: 84208436340.01.6E2509E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0C70140006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 21:11:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WvV9J8K7;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765487489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JHoi15bH+o+h9ciNLX0ixL7Y8Xckzt6YtYSoHoAdl7U=;
	b=UsLxTQ3nnf5ycwxaUpZmtr3TQmEcKsRAEWZxI1rraGMVa5EnLwpG20vYBwOAbIrP6ZYaWM
	aQSv7FCVJFS/WYpsajt9dxYK/VLyGAhz8WeRoy0CZJ7v28Kx74+J4+pTGneQnqkU7zgXFR
	BgUjeghl8iweV2EV6+ZBKdlDa5nGmPg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WvV9J8K7;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765487489; a=rsa-sha256;
	cv=none;
	b=CrCx2Mht6stE5U9UQeXrymANmCB/KO7BVowD5uf1/lfiCGtSjYGuYeT8XFy+i+ZfmCjuB5
	TxgPnpTsdY6ciFW04qYgPJmAW2jiwSpX5ly+NgRHDK61w0ye6tC8DGTzAgFrzvCuoFlKao
	C2Nibc6k5BgPwW2r4e0tQG+7yV47vHw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EF276013A;
	Thu, 11 Dec 2025 21:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0304CC4CEF7;
	Thu, 11 Dec 2025 21:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765487488;
	bh=dKA7DY+h/BTnP4TtIZ2JRJA+YNGIcriYupklfmwGn10=;
	h=Date:From:To:Cc:Subject:From;
	b=WvV9J8K7ngLHz/soT1XhSqGFbutC+LYJYIlV2Tdi0h/hoNT2XajYOmkhsDf1xxwnb
	 vBIs2unjQJ2WxWGtx9X8ZMAAX1IPTzl9QQZ53/c5WEjwm6pSG2PCI/C/pc2WU1dDJT
	 PftPFbwhHMBj1kGHAdzAMikU3avcxxvB/7Eb+kD0=
Date: Thu, 11 Dec 2025 13:11:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: [GIT PULL] additional MM updates for 6.19-rc1
Message-Id: <20251211131127.defed99e5b82e49af605108a@linux-foundation.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C70140006
X-Stat-Signature: fm1i5ya8357am4s5cghj3t9pcn64bsuh
X-HE-Tag: 1765487488-799791
X-HE-Meta: U2FsdGVkX1+qH+YFEGdeF3r/p+KIKs9h6XRLOtbtF87/ffRdh8ul2I1m8NwQssTTYYsyJllCJVV+nbRTGnclpSLtC03vTh8v01pFlEx2S5uP4sI4cyxmdEiLCy/PQGrhT9Hf3cMDThzCdlSLxuzBjK4D4lD7fy4f1O0kEu5RHcIGQVCNHhh6WNDeVag98tD+HYWMe5R4i/zPUHgQh1LKsxLhIioP55IQ//DsQu6cc5G/G9O0MZRYylxvO4m/xQm4LvB9dMMeQn372TQA5fieiA4mGUgCOzCVTbcwSn0khkZg9vV29kl/RAVDCQIBn7l/e6Xu+IPuThmGmUnAJ9nJusEiJ4P0yvoMfy1+jtVaXg4KTIzL814tqT56FfUGptF43Sk0FMcvTTDLHF9JwuZcN8CmgIc5Ro9byhfB6LiVUkqSL2+RETULG6QQElMp/PN80K2lnL11A5jH6kl7WPVoZWJCdrok308PeHAnTT/JCFCPM3uZFrBfg8P7EGjEzkqngzStuGyQJVygfYam9OPk26tQdnoEbIkRageSSeZPrtc7rpzM7V+4IhE/y3SF6ssJ/3y9rqbkxUL3jtRQQrrVyuAg8issS0L661NJBZNicfKvjlzuLQnDvpwku5Zw3G9HbR4V+Q6Izg3faO3UCfNn6Ymasx6r+8UA/NZoNstkLYCVkYjsgK1sI1MXXCL/VR75WD/w/+gkFWeuI/IyKlm98WvQmopuvnTeOflFJPIyqOsZisB26YfhSf4+WnqrvdtE6FfIpbHwFmd9+/eztxGUIuONTFYGI8ZGLf1a9jGuopef6alR26hwcbuxyW0E4oMr5k6hzEXqZWSeh3e2A75+jan3RIlMv7pjSc0DlzVIyZHKr9KVMqexHfYIYcuJZc7vXLTaYcQ9lpAJfBE2y2XAZHpIPEW2+Lhvmv3Juw1Pq6i2JvTuYOYEgAdQBz8vUhkPkffuMQS3f/fCW5e/PTr
 fSB1Bzyz
 zKdaGVRZRGNjJrTcQdlKBfv+dFzOuRoPFxXLQBJ9lCevYDs9ix0UvLnzdzKbK2ste1kERhFbk/LtZ/JhFUstnzpbxYCfyoLUmvdLZBdw0zARGNgKZwen9fptI1xyI6rIHIGRTxCWKC1jBP/ztgRFNZP894Ox9icZaI4/GvcJEQVBzXOChKKAgd4tJcu7Y92VTgVIge1Sd9T46cfxy1Bx8usUvwKP+zOgtXVPi+xJjI13nG0Zl2Y9l3kYHhW2xs5Cq06upoZuDkme8Kgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Linus, please merge this small batch of followup patches for this -rc
cycle, thanks.

My test merge found no conflicts.



The following changes since commit faf3c923523e5c8fc3baaa413d62e913774ae52f:

  mm: fix vma_start_write_killable() signal handling (2025-11-29 10:41:11 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-11-11-39

for you to fetch changes up to dafdba0964bd10913fbaa5537201cbbe05df5b9c:

  mm/damon/tests/core-kunit: avoid damos_test_commit stack warning (2025-12-09 11:25:34 -0800)

----------------------------------------------------------------
Patch series in this pull request:

- The 2 patch series "powerpc/pseries/cmm: two smaller fixes" from David
  Hildenbrand fixes a couple of minor things in ppc land.

- The 4 patch series "Improve folio split related functions" from Zi Yan
  provides some cleanups and minorish fixes in the folio splitting code.

----------------------------------------------------------------
Arnd Bergmann (1):
      mm/damon/tests/core-kunit: avoid damos_test_commit stack warning

Chen Ridong (1):
      mm: vmscan: correct nr_requested tracing in scan_folios

David Hildenbrand (2):
      powerpc/pseries/cmm: call balloon_devinfo_init() also without CONFIG_BALLOON_COMPACTION
      powerpc/pseries/cmm: adjust BALLOON_MIGRATE when migrating pages

Jinhui Guo (1):
      mm/sparse: fix sparse_vmemmap_init_nid_early definition without CONFIG_SPARSEMEM

Lukas Bulwahn (2):
      mm: fix CONFIG_STACK_GROWSUP typo in mm.h
      MAINTAINERS: add idr core-api doc file to XARRAY

Shameer Kolothum (1):
      mm/hugetlb: fix incorrect error return from hugetlb_reserve_pages()

Zi Yan (4):
      mm/huge_memory: change folio_split_supported() to folio_check_splittable()
      mm/huge_memory: replace can_split_folio() with direct refcount calculation
      mm/huge_memory: make min_order_for_split() always return an order
      mm/huge_memory: fix folio split stats counting

 MAINTAINERS                          |   1 +
 arch/powerpc/platforms/pseries/cmm.c |   3 +-
 include/linux/huge_mm.h              |  13 ++-
 include/linux/mm.h                   |   2 +-
 include/linux/mmzone.h               |   2 +-
 mm/damon/tests/core-kunit.h          |   9 +-
 mm/huge_memory.c                     | 165 +++++++++++++++++++----------------
 mm/hugetlb.c                         |  25 ++++--
 mm/vmscan.c                          |   8 +-
 9 files changed, 131 insertions(+), 97 deletions(-)


