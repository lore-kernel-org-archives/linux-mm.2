Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 499B2F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13ED6B0204; Sat, 18 Apr 2026 06:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4F76B0206; Sat, 18 Apr 2026 06:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2E06B0207; Sat, 18 Apr 2026 06:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 82BDE6B0204
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:56:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CE2BC1D41
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:28 +0000 (UTC)
X-FDA: 84671372856.15.E1539AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 77B5AC0002
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:56:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hq5rUcb1;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509786; a=rsa-sha256;
	cv=none;
	b=XZI8vQex5KpFm4gIKBtPZ9l394CAqDVQTNYmJZS2VNrg0/2V8EYhi35B7xyxcTAxubzMUN
	G2eTwaw5a5/tQqpoXw5POY7qxq79jVcilKBHNZMzU+PoaPiNdgMfX71ODOLPqSduqo8MGg
	fyuD9MmE72SyeZAaB7D8C9N4N+jYPfA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hq5rUcb1;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2W103MRI6VrKBdZ25sfw2Cfo+ElmCMBue0YACpwtBaw=;
	b=psmN7ktDKUvFGKdPOe24w2JqcaodgI6MYmAu5NjNAWdz6Ih3wbFYIX+nsZCkhlEVxfm27u
	OepP5sLpnq3lCdGFGL/rVRasgRiCTWAx6vX0aMn6c3PKRK/NFzY6CMQuWVbrcNxjSlPUl2
	lnFvjd5S+Yy3i1O4hqMyH0K8IJlsrWU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7477540BA6;
	Sat, 18 Apr 2026 10:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B5C2BCB3;
	Sat, 18 Apr 2026 10:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509785;
	bh=r1JAyUagQPOoIgV57/erUlQ+USIFHertsGg+nUFAuLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq5rUcb1CbrCoKQDXme/7aH+Nd7qCvKz3tccYZMe4zTK2+B/eNCoF5gr9b0J7ytyg
	 3l9RiByRT8e1uwqaW+36rYv1fvXpgA0R/sYMk/Ssf/o0NAfLDc+t0077fXZJ0L3Ka4
	 6N6y8peynGmWu+nBtbMoyT4yDPZtwARnqmsSkLPqKCD6N0rKzmmUGw4/rY5lTOL3BM
	 beDvw+/3izONHdg0AjKKrCTdBd33mqCggWuQ1/bWpGosdZWgo+3fHNl3lSjAGFSMwK
	 j2Uw/8bs21nua3MeicprkHYk36+QX+8paP7zE4Xz8llzAybkZZEi39+4j9IeSZ0Abf
	 Sx6WLtfIVBwjA==
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
Subject: [PATCH v2 06/53] selftests/mm: rename hugepage-* tests to hugetlb-*
Date: Sat, 18 Apr 2026 13:54:51 +0300
Message-ID: <20260418105539.1261536-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 77B5AC0002
X-Stat-Signature: 9nxedjpgyg5xfzrw6dy6wmug4uzx17hn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776509786-591519
X-HE-Meta: U2FsdGVkX18ZQ/FL08HRsxuZ4RUS6kIy1Vc6J2EGriNE0kQ60gAll16sxytIv1ACSrf5OyiEyihiIVLXlow70OkpEKA8rWvOSM5R6vt6gA1TaCnahQ/naeX/08IC4CCBIvpgKxnPBRn10ZbKLLanq7OO6FkpfXP3sU6zS+k/b00ZP5R9cl4RgdBthAECsDGsOUpojG6od1x/kbc3OBpEpmOn6wns9D8ju0KxdnP9N0pipVSaMCbc4RVhexqW7ZqJND1R10QgVisbWWo0IqpW4jGvUKjRBAg/f/EaAL2Sev3rO1l8jELE+gMCnlkTWeqURiZljxt6DTwVlG/RxrR52s+0v6Y0ind7LeaEfNHqAYckdHwFVfbIwWJWpEZp/KjZskYVmdY+oOEgZ9EohmN5iqBFOB3B6Wo1AhdWCWBXcUwWfOrhB5m3RNNBOHrGVYeOnHFrhU2P53RicrX+7rDIeN+3NrhB/Zc8fec4DuZMVOAA9fgq1mpt+gNGTXYLIcWWogVBbJoqcOgnvfnCzK9+MJHuMZFv8m6Fmge1U39waJYyzIixrwwTaEWtggBG8Plj90UBFeXI59WgjNqCiZbpLBJAOxMb3nTK9VFRZOLDeQ3dTEL4fr96KorPjBYbuO+iH7MfAt2ZCGYkb9rMpJGwzBF+jprv3uUjdhEoHUqlMH6Xt08AeU6SdnC2D8Ij5mfVb8aGRySxKYlpFs9tVHtsTXu6swzjyUrjIR0r7GkJaWuIeuMm7+8p4sKCnu842BZ2aZXXfXjzR9QcKyVL49T1lHfzgjh775Eh94C0owrw8CajKUmbt4HtPqjJ3kY6Dy0wItX7UwP8/IleD1AlKFGHQVnvgbAAlDOnbvat95n5krQynJy2iXUxMzI3ai7MBUrL1PPhRq5iQI/+npkOlAUL5/6R2p696mP9sxJnCsag4ecWJRxEpqzC3vl9MsA8BvUZRgDgID99vggd74jzQv9
 VKUnLUO7
 aC8B980NGJol41oi4z2loaGn3mYQJ9pxt9R8MylQHcbiBvaSWPlB/viUY2m+fmLXzQ/uHKC1cO1HKWNpHg0OtEHvzTHv534km5gBS1eLO50RNdBfLFxeMQ+GUyoNH9wt5BjVlAFLyj3H5ec24ljPSbsp44MBjPDIgusvpH1JqBocBMkJEyJeWKgeGJRA/3+VTqqByLzI1DFqW6oXws0pgH591T+/7RaVxSOZfVNDQ1AeSMNsqR1PvTZsX4jUZSoIBSNbTfyv0BrAFeNU=
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
Reviewed by: Donet Tom <donettom@linux.ibm.com>
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
index f4fcc7c45875..c0d58dd7cbf6 100644
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


