Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26467C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18436B007B; Thu, 31 Jul 2025 12:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C91C6B0088; Thu, 31 Jul 2025 12:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B79A6B008A; Thu, 31 Jul 2025 12:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 787D86B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:02:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBF581146EB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:34 +0000 (UTC)
X-FDA: 83725027428.30.91732D0
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16417180018
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:02:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=kBCYLhCZ;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=meNELh8LR1NAeAvdziO/ZgYgHuiniypSBrawhPsx+G4=;
	b=k9WO7DjeUuktIs9yOFs/67Bh33wpXbWDNU71/5y8O3oF5Gveib/Gj6nD+Qg6zMnmsKo4O7
	l61BneTT12Z8+5OYBOmCY9o6srZpJFWpnqj4HJ/fRYzbv/TpOGrYa0PZv0IULuTeS01tj2
	UrCoD4J5cua3xJc5+/vftV/ihCiRyFI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977753; a=rsa-sha256;
	cv=pass;
	b=WytelUh1S/IQk4DvDWoxoxTbsk61hyJclPF3XZxnJsK9lZgtSt/y6/vXQT6szqmjFMWz0b
	Ed05THrAQqJdVu/D7s7xrCbjKAD0CZFs0MYapvoLUHthZbO6Mxn+UfFtNAM+/xUJiL55aN
	uYKIovbSEJuyXLPRNiQpQ7VsSALN2I0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=kBCYLhCZ;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1753977731; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ZEWeWRS9NSRtAoYJxrk6zRnSS7qa1OVpBdM2SJ3xXuAG6R+eXaSMCIA8RNptxud6zJNpzEJC5teZqBpSmHzg8QBojAmMCg/fxqV2N8FDI/+fAZy01OKFsin5Ai4uGkvKTtO8U9wrHCbcJg1hK6DcO0uC06o2t0tEApFWiaylDDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977731; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=meNELh8LR1NAeAvdziO/ZgYgHuiniypSBrawhPsx+G4=; 
	b=jHVH1kgjVLXRvCR1F5I0VoPOPqohdomaXMIZAhRmwEtfMjpLxBCNC/mepNDk3dJdLvqCyO29aEzfE010htlexxv9SyI4l+/nXqZq6pZa5UuBftOcXTj8quN2lBKIuAJWbOOAyFPRWtHm0iydZq7ygxyLuea7862o7QbiHn3R7UM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977731;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=meNELh8LR1NAeAvdziO/ZgYgHuiniypSBrawhPsx+G4=;
	b=kBCYLhCZOgzVeWLofV1x57vA+k/CUZJZToOl5buYcqBdy2YTFJGa6G+bdE2wyS7g
	LN6BRD4KO/J+zQ/2kjx2Qz6vDoj0JQIIzGh+lG55+SYCNMDIx1VlY8YgwgWJbVtyDT2
	uj+RMFayNJ6gciYtQVYIp+1rscQQVv2cQUoqxLe4=
Received: by mx.zohomail.com with SMTPS id 1753977728569555.2914754706031;
	Thu, 31 Jul 2025 09:02:08 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 0/8] selftests/mm: Add compiler flags and fix found warnings
Date: Thu, 31 Jul 2025 21:01:24 +0500
Message-Id: <20250731160132.1795351-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 16417180018
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hwggx1offxsskt98z69k6ywyxm3jccij
X-HE-Tag: 1753977752-853505
X-HE-Meta: U2FsdGVkX1//kJrj1rF02tkIQneXjO4Zmd9vpdlIBjj6qBZYTHVT//N+l4HagZpDV45ZGEIL3Jz6kFOQL8eiP+8M/PpTLpW49/ormonCJ6Pc1WvRRC8ZVeitYXaH+/U/X/GPoq+pn5UV6Yopvr0owFl94fGlEzso7prZGwX1EVg4fgT/sYsyxn4X3ZpbzMH6qlfzpa6q9l2eeor6fzjKXgoRSog9eSa9XC5Y0bRX2kzNdJtdKuBShfdcaRXURb7d55yYUBCsOWmqgHxXil1c6ylAPxIyBUiOvG25irFm6GVqy3ynPsmzZG1vlgksZCJUGusoHMDtNLvmZ2YuWdfyTGxclBC8IDuKdeX30A7awkLuvv3A9kbNunFPoaZcPkHX1aq6QIDv7wh5cWLmOxI7rPJrUvJeSjYwY+td1EXyo9B8kEXu4OnQAtScTgIuuSQ9prH3rhESm5ELZO65hPEHoeQQZE5pToxvv3y6OAwzmg/gOSV+ivsZsVR6Q0UoztSa635KgZ9YpQQgcB+XLL8fEC01ISYRcIYBqxKyIr4ACpi3dsrxemY4LQtq7KBN+kumP26XAv8Vat1HM6I9LKCmcSV5eodzAQNW+sei3/hSpaUC6JrcyfIsodUuk31DbaJGOCXLdbC86e4ibxxo11W99q6bRRTVsTkXNs1nMFSwxpMjvBmqQULtAkC9euRU7omK4lq81E7cHMRtWmcWmgs4s8Yxjq/SvmsHd2parAV1H1V4SHFSb+LO+ewZwdlvlDgFekuih0odMD0TPGQcBp/Iy+iN0xPJZNRd63ue2YQ+T7nzd9rTXrY8oh6Pgb5AEtr5GwwwGQmPUg6WD2ThQQlGUuGKiG5Y5D0MR5fdJGkLnzHpLkNgXPOw6yV0D2206B3DRls0jhOd8UBy4mkt/QRqnhkU8nU2cIfhDsvzV2CwlabsFBMkYGih9GgoQVxMmHmoHdE40TY2BBqeEpib91X
 EQOGos39
 Rcu1ojLgx/sk9WVL0+tnZ15a813clOLIfYJMKYZmdDEI/5uTuT0M4XiuJ3KolCY4a8c27LnDiIBfkyphmcnTbzKsb2CssJUQ4P9rFErAcRBmYFmLP2Fa8TRqbGsEcID1btLTLTT5+Y7T2r4mLvo5Nqfhh6KUU5sbh1FTK+VUasGU08/dqehroMD5JYpS1j75ijHWl7I39xjHiZ0XIGoqp8XMc5b3TeAYyd554JUR5vPLL8l5G0aZ6g2PoJAYRGotY3unxxNhTcfTcBoH5fPPk8WAtmbqsFOD7WuwRAiFZsS5WoRugehF9kgoPf7SZcItmBjZLK+e/g8AOTDFtNVr2eS9ozMbTF/J9yJDVbdAEx7mNHlM=
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

The changes have been build tested on x86_64, arm64, powerpc64 and partially
on riscv64. The test run with and without this series has been done on
x86_64.

---
Changes since v1:
- Drop test harness patch which isn't needed anymore
- Revamp how patches are written per same kind of failure

Muhammad Usama Anjum (8):
  selftests/mm: Add -Wunreachable-code and fix warnings
  selftests/mm: protection_keys: Fix dead code
  selftests: kselftest.h: Add __unused macro
  selftests/mm: Add -Wunused family of flags
  selftests/mm: Remove unused parameters
  selftests/mm: Mark unused arguments with __unused
  selftests/mm: Mark unused arguments with __unused
  selftests/mm: Fix unused parameter warnings for different
    architectures

 tools/testing/selftests/kselftest.h           |  4 ++
 tools/testing/selftests/mm/Makefile           |  3 +-
 tools/testing/selftests/mm/compaction_test.c  |  2 +-
 tools/testing/selftests/mm/cow.c              | 22 +++++------
 tools/testing/selftests/mm/droppable.c        |  2 +-
 tools/testing/selftests/mm/gup_longterm.c     |  2 +-
 tools/testing/selftests/mm/hmm-tests.c        |  5 +--
 tools/testing/selftests/mm/hugepage-vmemmap.c |  2 +-
 tools/testing/selftests/mm/hugetlb-madvise.c  |  2 +-
 .../selftests/mm/hugetlb-soft-offline.c       |  2 +-
 .../selftests/mm/hugetlb_fault_after_madv.c   |  4 +-
 .../selftests/mm/hugetlb_madv_vs_map.c        |  6 +--
 tools/testing/selftests/mm/ksm_tests.c        | 17 ++++-----
 tools/testing/selftests/mm/madv_populate.c    |  2 +-
 tools/testing/selftests/mm/map_populate.c     |  2 +-
 tools/testing/selftests/mm/memfd_secret.c     |  6 +--
 .../testing/selftests/mm/mlock-random-test.c  |  2 +-
 tools/testing/selftests/mm/mlock2-tests.c     |  2 +-
 tools/testing/selftests/mm/mseal_test.c       |  8 +++-
 tools/testing/selftests/mm/on-fault-limit.c   |  2 +-
 tools/testing/selftests/mm/pfnmap.c           |  2 +-
 tools/testing/selftests/mm/pkey-arm64.h       |  5 ++-
 tools/testing/selftests/mm/pkey-powerpc.h     |  2 +-
 tools/testing/selftests/mm/pkey-x86.h         |  3 +-
 .../selftests/mm/pkey_sighandler_tests.c      | 35 ++++++++++++-----
 tools/testing/selftests/mm/protection_keys.c  | 22 +++++------
 tools/testing/selftests/mm/soft-dirty.c       |  6 +--
 .../selftests/mm/split_huge_page_test.c       |  8 ++--
 tools/testing/selftests/mm/uffd-common.c      | 15 ++++----
 tools/testing/selftests/mm/uffd-common.h      |  2 +-
 tools/testing/selftests/mm/uffd-stress.c      |  2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c  | 38 +++++++++----------
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 +-
 .../selftests/mm/virtual_address_range.c      |  2 +-
 34 files changed, 130 insertions(+), 111 deletions(-)

-- 
2.39.5


