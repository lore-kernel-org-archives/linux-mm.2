Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDFE3CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1307F8E0077; Fri, 22 Aug 2025 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108788E0056; Fri, 22 Aug 2025 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E1B8E0077; Fri, 22 Aug 2025 04:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC97D8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84B0383D35
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:03 +0000 (UTC)
X-FDA: 83803703046.16.F719B64
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id B570A4000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=n3hw1yrz;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+cttTPtuPoKo8xpKNyFHI5N4RxJj/1G8phFVFuSpqkk=;
	b=1qODq2LIXnZ5+Q7rMTldyJ4PW2PV1BmFWzNVoyFdCkRAEdMUBME5LR8KlYpskn6XE8zzYX
	KAvdlaOJ22y9CAMwM2HRuzJW/G9ChtD4+52NzUmwiSvP4cPWuIPkLnhIMa3Uh554H2Bjym
	z2UkddxErtQCRefoWCQa3XHxt+C5aAs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=n3hw1yrz;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf11.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850982; a=rsa-sha256;
	cv=none;
	b=zpJmaKH7SLlq9nEctl8r6yLADFA7hMinaDT1roZ/+u5OWw28B93hcfnB92OcqFnahHmU9V
	gQMP68TNYkg2Ts1hySst8u/X13VQzkFdK7/ymNpj2L1O+VrO6EJo6an9ZfjCkqPNdffD43
	SKp/dN44iJ7KjlwX3s84B3m04/x0eMk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755850979;
	bh=hVavycqMrPemBzWjKcAFiAsh6MQHU/3hvyOrGOvCTsk=;
	h=From:To:Cc:Subject:Date:From;
	b=n3hw1yrzFgymnMe6I39Ns8dAbaU8ke443nB8cex/RWNnDprZnhw0sqOPfZd4Le99v
	 hPXcfKSRVBu4C6xGfAg4cssdVFfafUv8ugUAapbCOl2TmLMVFQYQoD3oEtLxbl/zeS
	 GciTxfY981eGp4kmylCkGfyZ0M6ADazxeVrzmuxE/QNBk3KBbYFFbBTs1N8z7AItg+
	 CFWwaYpj/vmujGXXm52IYTyLG+3fQi2RpwYFpU+LCXWvvfA71bg53Sp49dPSse3sG7
	 cI7woKUzjOu2DCLTMz2L5ky4xCn+DNnWh12gWAzbToSFmmrV3Yzfm4b9qBiaZSCQT1
	 /UcWVZwNiAf/w==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6910617E12FF;
	Fri, 22 Aug 2025 10:22:54 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 0/8] selftests/mm: Add compiler flags and fix found warnings
Date: Fri, 22 Aug 2025 13:20:57 +0500
Message-ID: <20250822082145.4145617-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B570A4000B
X-Stat-Signature: y3yz5npqqqc3e3sne5fg9i4eqfz9kkwo
X-Rspam-User: 
X-HE-Tag: 1755850981-927098
X-HE-Meta: U2FsdGVkX1/rqSylGwZOJsswmLBTuXFi1Iad1w1eU9mZKjW9iJGzPZ9P7W89rN1F5VSbbZ/d9X3aiDwjg95easn6b5maNiNg7bjDwOE+E+PUA6hI7oPfEx492oKSaCmJLlI+MP7FeKBtydbXi1e0czj2GsXlUe74DRRXyu3fVTwy/IwpXWR4f03c0NH5qeBPvU5tJLFGnnO4d1MNtE7R40tqaIjbu6rqS5KrgQj7kuwMnMytul8IFGf1YRp1ickaa1lXfd7fQWFfJuoimARZGqUtRaYmGyRRp1VMgZrBHX1rFltxjIa6WHARgKkooeGBSYLLXIJR7AAXAyIq4nmPTxfVCq0HIJhBseAz4I5hKsy4YSeKA2t+zJq+e7618weqzRCwGpLMFpvrnkPvQLbbv6FoMEA4T2p/8teKrrARUSzfMbanSFpEMK7PeFTdkykJMlUtrR7st/4w0IlK9LHaofdtkBvTZthSR30mHjDQUsN8m41WZSKNLBaXKy1n5u6OID82B15fYqicLYqGWLw7t905L/mB5mCzOzWXvwTKnPlwR8vaUDvzeajO7EpktaDsYe97te5vETKfNWXCC00oSrwyy7wKuGfwLmQhMP/ZBxi++Lzxi+TAh9/aH9T/G8N8tdbD+Isd+QdDR3Mj/Zl90vBnoi+oLC7XffHV1VOk2VPfRN45WX9ELn6Y4t7DdP5nQ+KheA4Bw/POpO9RcSdrS4kVMED6jLHK22DXxAb4cZ6XT8QoIxN855doKsOLw4KnzpyxOnZ5PfxY148mtEQj1VqVFEHoiY1AFewGOglVOb3XjYUiB75K2xQMsKUeH9lDvGRILMFYnw5M4DdchUz/Cpd1mnRJ3t0SUirI0gNTgoEA0qEcbUu6ZDR05dIZGiUgT7qQbnjd6+W7pN97Lf03Xu2nTDDCg7557sQhW1aYyN+ROtnp+nuv8Cq0MBUYriPd/+y1QcsAnHT4M7csdBj
 C1ms75zw
 GnxiZRHKBOKGRX1qUg/oWaoztRmbXVbq6n3io6FHWlVDEF3/6xcVV0dYFi+VLAfmVm9Bs6LFLLwBqhd5/Ca8KbhB6KRfPc4vUDxbgqOJAIO72MrR5F50RKHI3A7WIAmcl86rseU6MQogB/NIV+JQbvnM4vtxvKeS82mkCKwIt28f2+A9qPtfNcmVUp/ltpTZ5sT4XgY1+8Q7lyCE1yLx7dFcal7LjgFDTckZaFrtoJ5B0WVcNpr7q7h4cSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently, I reviewed a patch on the mm/kselftest mailing list about a
test which had obvious type mismatch fix in it. It was strange why that
wasn't caught during development and when patch was accepted. This led
me to discover that those extra compiler options to catch these warnings
aren't being used. When I added them, I found tens of warnings in just
mm suite.

In this series, I'm adding these flags and fixing those warnings. In the
last try several months ago [1], I'd patches for individual tests. I've
made patches better by grouping the same type of fixes together. Hence
there is no changelog for individual patches.

The changes have been build tested on x86_64, arm64, powerpc64 and
partially
on riscv64. The test run with and without this series has been done on
x86_64.

---
Changes since v1:
- Drop test harness patch which isn't needed anymore
- Revamp how patches are written per same kind of failure

Changes since v2:
- split_huge_page_test.c: better deadcode removal
- Drop -Wunused-parameter flag as kernel also doesn't enable it and it
  causes too much hassle
- Drop previous patches 6 and 7 as they are just marking unused parameters
  with unused flag
- Rename __unused to __always_unused and also add __maybe_unused

Muhammad Usama Anjum (8):
  selftests/mm: Add -Wunreachable-code and fix warnings
  selftests/mm: protection_keys: Fix dead code
  selftests: kselftest.h: Add unused macro
  selftests/mm: Add -Wunused family of flags
  selftests/mm: Remove unused parameters
  selftests/mm: Fix unused parameter warnings for different
    architectures
  selftests/mm: mark variable unused with macro
  selftests/mm: pkey-helpers: Remove duplicate __maybe_unused

 tools/testing/selftests/kselftest.h           |  8 ++++++
 tools/testing/selftests/mm/Makefile           |  2 +-
 tools/testing/selftests/mm/compaction_test.c  |  2 +-
 tools/testing/selftests/mm/cow.c              |  2 +-
 tools/testing/selftests/mm/droppable.c        |  2 +-
 tools/testing/selftests/mm/gup_longterm.c     |  2 +-
 tools/testing/selftests/mm/hmm-tests.c        |  5 ++--
 tools/testing/selftests/mm/hugepage-vmemmap.c |  2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |  2 +-
 .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
 tools/testing/selftests/mm/ksm_tests.c        | 17 ++++++-------
 tools/testing/selftests/mm/madv_populate.c    |  2 +-
 tools/testing/selftests/mm/map_populate.c     |  2 +-
 tools/testing/selftests/mm/memfd_secret.c     |  2 +-
 .../testing/selftests/mm/mlock-random-test.c  |  2 +-
 tools/testing/selftests/mm/mlock2-tests.c     |  2 +-
 tools/testing/selftests/mm/mseal_test.c       |  8 ++++--
 tools/testing/selftests/mm/on-fault-limit.c   |  2 +-
 tools/testing/selftests/mm/pkey-helpers.h     |  3 ---
 .../selftests/mm/pkey_sighandler_tests.c      | 25 +++++++++++++++----
 tools/testing/selftests/mm/protection_keys.c  |  6 ++---
 tools/testing/selftests/mm/soft-dirty.c       |  6 ++---
 .../selftests/mm/split_huge_page_test.c       |  2 +-
 tools/testing/selftests/mm/uffd-common.c      |  4 +--
 tools/testing/selftests/mm/uffd-common.h      |  2 +-
 tools/testing/selftests/mm/uffd-stress.c      |  2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c  |  8 +++---
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 +-
 .../selftests/mm/virtual_address_range.c      |  2 +-
 29 files changed, 73 insertions(+), 55 deletions(-)

-- 
2.47.2


