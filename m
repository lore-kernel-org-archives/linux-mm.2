Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0820FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312F16B00A1; Tue, 28 Apr 2026 16:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2576B00A2; Tue, 28 Apr 2026 16:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9016B00A3; Tue, 28 Apr 2026 16:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4EB6B00A1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:43:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0F0E1C06CC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:39 +0000 (UTC)
X-FDA: 84709140558.14.8164E81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1A35EA0004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:43:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MFRVWxxU;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WM9DW8Uqa5mm/l4IsSAZjpRr6J5bOZmuTzlMQt6578=;
	b=iJFHxfnU6OESmdua30ITAL7S6EIZd3Dgi/ogZ0UZyYBnu7ydo9e84YltriDr/5fufPzZAu
	LvMQrox+btfoe/0p8083FLRWFI2XWqGZwZ2p2jcXnRDs4AbetGk+ROV6S+QU3/P6oaOrpz
	l8KUKrA6OM7yryc9gUljAebHYGGDDfI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MFRVWxxU;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409018; a=rsa-sha256;
	cv=none;
	b=ChZfG+G75jz/oCd1nveyla1nBZht4iVlTmNzgP8/HF2by3vP2BAIQ1adDVopw9HAvqoC18
	qVGzvgLuO/kaQEH4JPUtIFAYmL4aKWROhikHBYzEAJh4vCXp/x/yyGppLvpXa+KyChHmdo
	p8JbO9g3TSV9xqHvhJHcBztrWjkwbck=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 896A061334;
	Tue, 28 Apr 2026 20:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9BDC2BCAF;
	Tue, 28 Apr 2026 20:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409017;
	bh=9sC3778jKyDFz3Hjf8iXiNoDRSWAhHT+f8fPth7IqjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFRVWxxU2l48pg7KdlcATzh/BQ7El7mawJuXdhfzSUId5u/FV3ENpGrpXoVv/S/5e
	 diGcw13XfZ66wO6iK6hu/nz+PFGHcwnt5Yh9Kz8cgkfNZUENMDb/9cXjrvfidS/0En
	 Q9CsEbrpDu2gG6VRAai5UYV/lv4uWDvGC1kM/eG6mUfifvB+4vsxxt79dAdTkvoO+w
	 UBiE5Xg01xGq0XKss6X4SfkdurzI9BbwHtB04Jn+VmOmuutfi75GehlCP7x5cR+v0f
	 csq7HGnKd78f9EibARdiq0bwCYC+gXAK2lSpyAw75v7VpnTjcNibWt59VaCe8g3kKA
	 zzSHvWYTm+k8Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 07/54] selftests/mm: rename hugepage-* tests to hugetlb-*
Date: Tue, 28 Apr 2026 23:41:53 +0300
Message-ID: <20260428204240.1924129-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A35EA0004
X-Rspamd-Server: rspam06
X-Stat-Signature: u414oor41eqgt8uwknd4b69houcx8osn
X-HE-Tag: 1777409017-752596
X-HE-Meta: U2FsdGVkX1+7T3mIldTlVU2D+P0/UwzCH5UawMrOXDqXoSFo1KVF31R9UwsQTYWPJDw4/wV+9a/0xHJ/DJWlIlvvjrycOKEJzJjkuVNUOxz3pHxTtcnzZF9RM29V0scDk16HcqbLxwHg4/kHfhoLD61qDMWRndV0huZzh9SJvEOWo+dxdOFKlyofaSgKfS0kCddRVQL6uaExNqT5l+1bvn8Q8U0Hr7nWqmx3kKQzs4j0rW2AfiipxkDzrlWjnQ6FLuT51gJhFP0rDBBTSCGQ8MPOK11qERn0M/AslcN0Uyg0GUs/lFp0YUwqj7FjHMmOBuAuUeHqcADXDkoN5ZxseV0jCFtyWVe0hGPR9iNXjtnUM4M/mU+/FUGmNxpF5/+qzi2GPpla+cBxQ8jC9scgD8Zpoi79EBwAfb9EnYgDFOvObAYCstiET2K6ayLY0wm2yJjMopywNUJS0jm4Ibp0f7cXMLAvfDujmhw2yQEZZj1xIgvWtVuXUN4u5EdgTwk9aGyBWEHAmF5oRB6K2vynfYeMUcpdHw6CJEQ+nKGjp7YOGZXwEqSed0Um6k4mTFRKAq23jxJaQPCuh7CZ8VzC3HRVKqNi3vfoaz3E4q2EMu6VFnqYiXLmFEVQauEIM9Xau+Zf/9WYlz9m/jdLO1l0fB1qt7UtQg6CIbwup5M8sD35U6BtrMgOuQ3UqIDzU6980YI9D9y2x6B5ahN1nSTcKCBcL8rLtKyJZGK41h6+0NLsrX02h4p0s+u/+bMobbu9z045p4gLrE/Ze1eIsveCcadeKrH3ky/mtAKPM6NR8KxuvYVgX9v/buCr/unN4ZzQc8fFyZoWQGD5fDhu/aCGBHY4+i2g+Px/bISUbDmZAGoBE4bgId6L1tlizDhSrBpBcUqkDBMUze9EYFT9qTXWgR6xtK1u7S05OQl9XK/uxIpeb8lV6GJLTvDIVf4NtSZyOVruKfCTsbBr6wLVyh7
 QSdDoNsD
 K7jhIRqNjNDoyU+NxQ7ELKo/5zyAZbHeiSTN8jDcfYpy2cW928cUQl4IG+mA9l2kX6YBJQbZ94EcZ1zr+pnZiBb9yf618AbyBuUqIzSm30So/a7tGaJVHjE/2Kv7RR53qIB1YZCM6l0KO5E76JI3aunODMxze53gseuJVVzXclO7noRNQnTqqu8SQOh7BxWovzSlrpRRt9ORarSOGMfNXIDdz4A9AuXucPJTYkVNFBLqIs7TRHrYVJ3L1tt9K+wCnhmA+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugepage could mean both THP and HugeTLB these days.

Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/.gitignore                     | 4 ++++
 tools/testing/selftests/mm/Makefile                       | 8 ++++----
 tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
 .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
 .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
 .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
 .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
 tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
 8 files changed, 16 insertions(+), 12 deletions(-)
 rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b0c30c5ee9e3..9ccd9e1447e6 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -4,6 +4,10 @@ hugepage-mmap
 hugepage-mremap
 hugepage-shm
 hugepage-vmemmap
+hugetlb-mmap
+hugetlb-mremap
+hugetlb-shm
+hugetlb-vmemmap
 hugetlb-madvise
 hugetlb-read-hwpoison
 hugetlb-soft-offline
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index cbda989f6b6a..a6955660a806 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -63,10 +63,10 @@ TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
 TEST_GEN_FILES += hugetlb-read-hwpoison
 TEST_GEN_FILES += hugetlb-soft-offline
-TEST_GEN_FILES += hugepage-mmap
-TEST_GEN_FILES += hugepage-mremap
-TEST_GEN_FILES += hugepage-shm
-TEST_GEN_FILES += hugepage-vmemmap
+TEST_GEN_FILES += hugetlb-mremap
+TEST_GEN_FILES += hugetlb-shm
+TEST_GEN_FILES += hugetlb-vmemmap
+TEST_GEN_FILES += hugetlb-mmap
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
diff --git a/tools/testing/selftests/mm/hugetlb-madvise.c b/tools/testing/selftests/mm/hugetlb-madvise.c
index 5b12041fa310..898cc90b314f 100644
--- a/tools/testing/selftests/mm/hugetlb-madvise.c
+++ b/tools/testing/selftests/mm/hugetlb-madvise.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-madvise:
+ * hugetlb-madvise:
  *
  * Basic functional testing of madvise MADV_DONTNEED and MADV_REMOVE
  * on hugetlb mappings.
diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-mmap.c
rename to tools/testing/selftests/mm/hugetlb-mmap.c
index fa886ec148c2..9f5ea8d6d656 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugetlb-mmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-mmap:
+ * hugetlb-mmap:
  *
  * Example of using huge page memory in a user application using the mmap
  * system call.  Before running this application, make sure that the
diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-mremap.c
rename to tools/testing/selftests/mm/hugetlb-mremap.c
index b8f7d92e5a35..1c87c39780c5 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-mremap:
+ * hugetlb-mremap:
  *
  * Example of remapping huge page memory in a user application using the
  * mremap system call.  The path to a file in a hugetlbfs filesystem must
diff --git a/tools/testing/selftests/mm/hugepage-shm.c b/tools/testing/selftests/mm/hugetlb-shm.c
similarity index 99%
rename from tools/testing/selftests/mm/hugepage-shm.c
rename to tools/testing/selftests/mm/hugetlb-shm.c
index ef06260802b5..de8f5d523084 100644
--- a/tools/testing/selftests/mm/hugepage-shm.c
+++ b/tools/testing/selftests/mm/hugetlb-shm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * hugepage-shm:
+ * hugetlb-shm:
  *
  * Example of using huge page memory in a user application using Sys V shared
  * memory system calls.  In this example the app is requesting 256MB of
diff --git a/tools/testing/selftests/mm/hugepage-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
similarity index 100%
rename from tools/testing/selftests/mm/hugepage-vmemmap.c
rename to tools/testing/selftests/mm/hugetlb-vmemmap.c
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 61b450032af8..b9e520194634 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -282,18 +282,18 @@ run_test() {
 
 echo "TAP version 13" | tap_output
 
-CATEGORY="hugetlb" run_test ./hugepage-mmap
+CATEGORY="hugetlb" run_test ./hugetlb-mmap
 
 shmmax=$(cat /proc/sys/kernel/shmmax)
 shmall=$(cat /proc/sys/kernel/shmall)
 echo 268435456 > /proc/sys/kernel/shmmax
 echo 4194304 > /proc/sys/kernel/shmall
-CATEGORY="hugetlb" run_test ./hugepage-shm
+CATEGORY="hugetlb" run_test ./hugetlb-shm
 echo "$shmmax" > /proc/sys/kernel/shmmax
 echo "$shmall" > /proc/sys/kernel/shmall
 
-CATEGORY="hugetlb" run_test ./hugepage-mremap
-CATEGORY="hugetlb" run_test ./hugepage-vmemmap
+CATEGORY="hugetlb" run_test ./hugetlb-mremap
+CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
 
-- 
2.53.0


