Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59CBCF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C166B0099; Mon,  6 Apr 2026 10:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02F76B009B; Mon,  6 Apr 2026 10:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B406B6B009D; Mon,  6 Apr 2026 10:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A332D6B0099
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:18:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CF5EB806E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:23 +0000 (UTC)
X-FDA: 84628336086.03.E94A850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A78D41C000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:18:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rNpdvEwM;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNqnTIldtyHhcUE2Worv1d8bpK2Atxc162LKR4hRHCA=;
	b=ydBQ7NRH5gKZ/aYYFBu2/PcAyqxBcEjrTZS5c8R5O9gc+l5R+fiyF68VTiq4ADqj4zw6Zj
	pvZNZsUmy3Pr+irvkubyY4g9+pN2OGKbWGNVsKe+21zhnAUQGr+9cwAq4KsBp8qccoSScU
	xISQYKhJ5dZRYC1aEOv9tUXHduqGj8w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rNpdvEwM;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485101; a=rsa-sha256;
	cv=none;
	b=ds6CqAKHyUB/5lcon5HCbfphS7UleHkNt5TZE/CLrG0vnkRizRxrWQ/8Xj3P7wmkb/EPp1
	XoGbF2O5CINcqsw/pIVuXm6AUW21y9QvxW/yznLLRuWQceLRHaewxmgI0OIl/tANajiHBZ
	9c1V+vqUVmqLcON35HArL4yv5tIeh8A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D20B60123;
	Mon,  6 Apr 2026 14:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89CDC4CEF7;
	Mon,  6 Apr 2026 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485100;
	bh=FlieAnc4FruMQ6QrS7CarGSRQDTGnwuXJngoZqFbG3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNpdvEwMpUYGFmdKc0S6GzedlIcHxn4nEiU2s0V1b5U65KtSXqEy2OBmMqY3Wg+Fi
	 +42YEnx2ENiaXN7BfnnqtG6oiQZGkOy4vEkglyUgkl1jnstPtHHil7dwjnZODe3qXn
	 xnSAEsx+Z3S0RK2XcY74X05trQc17q8iKkTiWXa7aDRrTXnB7a0rrB6RRFDXuCG7l1
	 uVySfR4hfvVyGPqWBSK/f5SH3+kr/WVTcSNXMitDqT1vsS80C8ZdnZzayiiFzCl3te
	 VFO4Wn8wsEGlp5KnIVzq+qG05lWAd6bEvJ/94BQ/qqMhOOfru6AiRRS7AJ3ZJtPwrJ
	 EGsc1JEf+d8lQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/53] selftests/mm: rename hugepage-* tests to hugetlb-*
Date: Mon,  6 Apr 2026 17:16:48 +0300
Message-ID: <20260406141735.2179309-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A78D41C000A
X-Stat-Signature: uarh7rjjdgsjrkd75qex63xy6i58qtjy
X-Rspam-User: 
X-HE-Tag: 1775485101-429446
X-HE-Meta: U2FsdGVkX1/g3yGjIObji+OPZXJY46RD26q1h+Y8hWU9jmhLU/GBca5DH0yQqQD9A2nqOF9rEo7o6TOkV3P6drwc0SPdcNxmKJpNkjxmY20ZlIrysobqfaN4xIalWIJLZbbP6q5+5AXENVsenUYvk1eB36MiYQOzFUZ9qvs3ycQD5kSzFkUgFWVnwud3eDIUaaB2O+jq9yJDKWIssgKxbW9ywap68KYqiq010hrnUS5AVpeuqHxzaCj5Yxaigw10aHgf5WjZLAoYGi9fMhXTE/8OeAhOk+u0HK3cUW5K9j1XuUe56QQ0rxBCN9S8PuB6O9qQ+mIkVqtisRLIQWaGhH10KxYioNV0JSBJ1dbpa/G7xuH+LVQcAyyGPsv0MegylHVdkVJWs2M5OPSC/u7tvGYAAllLfci+lboCMQnZ+74yFpv3c4AMSOAb8ao8hz9w5gc/kXglVEDN9HzjRYGi9XvUtn/gXUYI5tZkjup/z63z+whrQOOh+wBKwdQXyP0e0p0szsg7bM2lTe7fF67oBSN/g3F+rda0+7nT+DLat22mIQ3sMosseHrtaQ8R+GbdL/J9hwQBioqEteJboJMsqywERXmgBaQ9YbUzLJGaTedFvGCQqmlPKA9D7gIsHZVG8oP/dIoFi5D5iV1wayaS8c2qUWkCi9yuEeZnPzUKcRqSqAb8IYX2gyEt4Uj51Y9CHeQS+U88uxvMYUf4EvHnSM/ju4Jxq76EckzEwTEtV90x1VgG75naqvYegJkxUbW0Z20PGswNP5ZEG0undKSjCwkDiu7DWRhgJexom+zW+EZHPzvKfqJhbzlOZRV6pKY2BpHlBO9WndXEMJsiP1+hmy3I2crOkgVpv3Bx7DiU2NpSKMCzfSPl+ldPQnQLB639SAdirBbb1mFr36iT1n34/PvDBezzjYKhyHteGfuuEHhN2QUhyLGxECIXOCl9QF3E/8QPCS8xappfgzJSx5z
 pW79XqGM
 9nWl57sqJDuFM79ZF3QRhSBlJZ08qx5G/oTitkzyN9l48w0POnPwIe3iOR6Ct/wCLzTLfw7GgZ4F4hf7ouQJMY9/fKtGvWFNo1mnBpixxEfCv9aX7NA9bUX0Qog8qi1/EsdxJ0iBPjJoG/5jY9ogRPzx/Pn6vjxsapUVuOq0VDzE/jzbR7KmPEL3kR72YxFbNpgKG5jfCqvjyz50tmMDASPFbSk5DaLbv7i2C9W8JjIlAok0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugepage could mean both THP and HugeTLB these days.

Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.

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
index de210043045a..71a444d8b1cb 100644
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


