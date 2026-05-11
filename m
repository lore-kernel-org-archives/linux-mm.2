Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC11CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866D26B00C7; Mon, 11 May 2026 12:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83E986B00C9; Mon, 11 May 2026 12:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BC66B00CB; Mon, 11 May 2026 12:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A30B6B00C7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A4AE1201C5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:38 +0000 (UTC)
X-FDA: 84755674836.09.A94A546
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 707F74000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZmkGkhg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kk8qQV0vmuR0vWzmf4jaZkO2i86vMkXq/KiFWSdf+yk=;
	b=tl4ubODIhb0x0WMTrKETceLE/xAcX+nmMR3yTWK4zUzRsb+G2zABP1WY3YLHxVHsEQS0uo
	1+nWbgzAaMFQbeHMwhBGYUjTI6g9R9lRsWgaDDuJPUXDAj+2tke4Lp8wd6yz+ZEn3/2MNT
	WEv8uWKlN03oYt3+zY+2+SReS0+96f0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516976; a=rsa-sha256;
	cv=none;
	b=l4AwAZLuuBZcjee4/UTKaa9ubu/xOm5LyrZGoYlwPQo+gF5bf+hgUOhGWJr8vVeLfV5zRO
	djF81MLDyTLqSe7oCWOUMQ5fAczdZSnPToM6zO53i4HggEF4kgwkinzQ47FHKk3buGkqlg
	BnWST06/+AVqEr9Qi50typYi8dAjRzk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MZmkGkhg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1C7640DBF;
	Mon, 11 May 2026 16:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8039CC2BCB0;
	Mon, 11 May 2026 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516975;
	bh=XM/E6RiTwMVLkc1zq72XzF67EPrzPPpoLBiNfkdb+tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZmkGkhgypxgIvbyI7TudTr3PyKLhImU07rltNGBxj4SB1loVH0tBGUSpxOgnllij
	 aWUQvNQzqLBz6G7u1l9BbLs/Z9WBxUSajTbRks/HeW9Y4VVR9p7vXETTY823D462TI
	 8gt9MbkCVllMOOtFTGQ+hG0mNvrEPqV2/ew7AnBnbFhSoH426Af7pxYeKgJz/aStjp
	 ar+Bf9JKSaexeaGm5iuqQImuYf3xh2hjy1I+8icnGcnIsYq6J1Ar8IY7S+aKJMqBTg
	 MlWgmio1xey0CeoWhwtAiPKLaLqtWLShrypSST8DCK7V2buU08izOeolM8Jd4OzXR6
	 tOEG/qZESWmLg==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 07/55] selftests/mm: rename hugepage-* tests to hugetlb-*
Date: Mon, 11 May 2026 19:27:51 +0300
Message-ID: <20260511162840.375890-8-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 707F74000F
X-Stat-Signature: ngnsen7zdcbh38ggf9odscyykzdm5q87
X-Rspam-User: 
X-HE-Tag: 1778516976-522248
X-HE-Meta: U2FsdGVkX1+QepWcFVO+Cfh/PYg6mjsZYfhGYujT8ymuqa9NV04X3QQTrSwjVWc2KlfKum5Fj/32jCk0BY0XEDiSWFjhqkLR2QgArQhYQz/3YJb3nqcIGi5NBzfKaYudPKs7AWEtlBpWKB6ycLlrd1H8YIi4Wu49NnnIMauan+zpKMo7y9OevH78yoYCoxkSddV/wjH3fD7PnLaR5Ek4M+N6Ed8x1sWuGaNQtGpqQRks50et1G4ZIvNIj6xhwo9PIicla8XQTvUm3WiLwtB1eTB1s/uM4vX9aTcldQXL2bemUzkeNGh3v7pR5OfQdhukaiReccnR7oIZPPOirtK8Xj5hMogOI7ZyVLAMK3mBnihPEQjE9iRf/8TghfQ7YRhQ9jsRFQM11nUsJdcuAO5k3PXZtRLC5dT+rbVTlUjq8atZ8tpZlRpYnt6Y/leg9mkJeTZQpp6rCVJ4byL8WUaakbDiiHL6LtefFt34MI6nGXA7H2hZ6d0lBHkIURQi9mtiEmWXWnvFaKwqfN7JJPvCbtwZpNJ2vg5HcbqbyLfWxxDhaaCx8Xv3MbNvZNWQXwxkbsJ7TwOPFCzBiVEOyNyy9DOzqWflip3WQVgt2T1s85m+HfpSYBdV/1dbEtq7IwZ1u/n8zWQXnrK/5kEJb6Ir/RbmqstS5HLyWV44YTrZOkvbXj3fvJT1DJ5BL0ku12j11he9hQ2AnpiW9sJ/g7S8vSf1PTXgPi4rrpfj8h5yEzgcmYXXvGUp/TcyqmbsoId5HNoHXf4uTFQwX6GGY892HauE0TVA39YGtFxb5wLtKDmZhHNo1EQoKXE7NhOOuDzLUFectC0lk+wNzdhj3OhqNtC2Wn2ldrm+8tVeN7ky+Rwh/71lq1Yp3Rooq5nDxD43eLKucq5zYd47N536xg0vhTsNkOf2NdKmA1X/eCccA7GXFhVmtqu19Ol058bU0t7No10yrvrDOk86okeEnt8
 lBZJED57
 mrvugtCIwRsUTL8X/9/2s3X4K8yGx0nqVkBAwZWjomU40Mv4tPoYBkqD5xloOKEShqr4LUvCelF/zwg/q4G/sZuk/k8ywchrEksQuop7fkbSky8iSXUs7OskJNoFPqByhZmB6bJiXZXjDAMALmW37KNrED4lygE77Flc0uWfk3tE6KfjFT4Vt6cSIASZp8xy4HJqsKg9PnhdfiuzfY6pv5FP6lAPh6470cPDD3vVs/4UWRJRIv6Owsrdx7CtZGnRutGGySjHhctWL5Cgevgq/TnqpFzwFdb/C2o8YL/38zrXG/ec7H5tVDnijprm2QwfH6sS76yDEhQqrrsx/ZusREq9YSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugepage could mean both THP and HugeTLB these days.

Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.

Make sure that Makefile update keeps alphabetical ordering of the
TEST_GEN_FILES entries.

Keep old binary names in .gitignore because Linus prefers it this way.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Li Wang <li.wang@linux.dev>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/admin-guide/mm/hugetlbpage.rst              | 8 ++++----
 tools/testing/selftests/mm/.gitignore                     | 4 ++++
 tools/testing/selftests/mm/Makefile                       | 8 ++++----
 tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
 .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
 .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
 .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
 .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
 tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
 9 files changed, 20 insertions(+), 16 deletions(-)
 rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
 rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)

diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
index 2dea8c636641..3cc15d800be1 100644
--- a/Documentation/admin-guide/mm/hugetlbpage.rst
+++ b/Documentation/admin-guide/mm/hugetlbpage.rst
@@ -475,11 +475,11 @@ Examples
 
 .. _examples:
 
-``hugepage-shm``
-	see tools/testing/selftests/mm/hugepage-shm.c
+``hugetlb-shm``
+	see tools/testing/selftests/mm/hugetlb-shm.c
 
-``hugepage-mmap``
-	see tools/testing/selftests/mm/hugepage-mmap.c
+``hugetlb-mmap``
+	see tools/testing/selftests/mm/hugetlb-mmap.c
 
 The `libhugetlbfs`_  library provides a wide range of userspace tools
 to help with huge page usability, environment setup, and control.
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
index cbda989f6b6a..d9ecfb02e05c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -61,12 +61,12 @@ TEST_GEN_FILES += gup_longterm
 TEST_GEN_FILES += gup_test
 TEST_GEN_FILES += hmm-tests
 TEST_GEN_FILES += hugetlb-madvise
+TEST_GEN_FILES += hugetlb-mmap
+TEST_GEN_FILES += hugetlb-mremap
 TEST_GEN_FILES += hugetlb-read-hwpoison
+TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
-TEST_GEN_FILES += hugepage-mmap
-TEST_GEN_FILES += hugepage-mremap
-TEST_GEN_FILES += hugepage-shm
-TEST_GEN_FILES += hugepage-vmemmap
+TEST_GEN_FILES += hugetlb-vmemmap
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
index 66cf74b73dea..a327d90d7a79 100644
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


