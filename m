Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB273CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 06:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDA48E0001; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DAA8E000E; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B537A8E0001; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 964648E000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 02:15:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E65E119BA0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:57 +0000 (UTC)
X-FDA: 83868701154.14.6C5B94F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8C5D10000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 06:15:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757398555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fxEcztTV2V1pzzDxF4C4sCr/ft8l7I7sjdEBRaFjjJ0=;
	b=G3nervrxF2MbsAbLMOQes0fuRgi0VsCsPn7u+n3T/x/jFwDR50/7nuttKyUdXxhAFKJtpi
	k0a9eZD+GhpXT417bWoirdeA8WfNAJbKl8iVd4l1RrlKLKAIk2biiVjIsPBR4Mg49faRqK
	Ac9nBbYKi9xPisSYwQEFotckjGRYiWc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757398555; a=rsa-sha256;
	cv=none;
	b=cL1iBpF5ly03XXXHGI/HvO5X/oTMuOpeiNs4iAKD05EZqTk/XPMhCNp65cTSm/qIQCoIX9
	acgcd/8nOsnX2W1ZvfsIhuPzv7r12ZRVDb4dZOU3Dnat4MyRbfe2dZNwuIZGuuSGy4KTfU
	G2atnrK0VjCCA+G6FAxwppYdVD3/Wew=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A77DF1655;
	Mon,  8 Sep 2025 23:15:46 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D8D2D3F66E;
	Mon,  8 Sep 2025 23:15:50 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 1/2] selftests/mm/uffd-stress: make test operate on less hugetlb memory
Date: Tue,  9 Sep 2025 11:45:29 +0530
Message-Id: <20250909061531.57272-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250909061531.57272-1-dev.jain@arm.com>
References: <20250909061531.57272-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8C5D10000A
X-Rspamd-Server: rspam05
X-Stat-Signature: nbjnhikjnrc5t4g5jq6x84fry6a1bnhu
X-Rspam-User: 
X-HE-Tag: 1757398555-723379
X-HE-Meta: U2FsdGVkX189/mYfwW8xWz/ILkmTa7LdM1W05edlj7WSOOtjFi77jlR/h5onk+6f6jwdqeoulgh80N/kYL9yXXxf52kTu6SXUCf833ZQQRJfclpPWNd4qViuFkQrzNgl7oLEsmFeA+Bw7yfYJnOIV8JkMPQLcUeJOkmmfnX2omieBEfi5EeoA8B33KK+4QjqHADZM6D1TW8mNWU/8f7pX+tF5ywP46pHYnKOmwFwRwPyTdYUpHCOcDhhDzMirN8Q1QugZ5k0bNk7Ixb5mutW57A2ZoM52pIQgeCxzHcbxhYu2F7/LT/Ndrw4H1jYT3YLvcJRmoongAFlJMo6marTh+hn7EvDjtHuKTkf4TWiWsx5WZZCOm3k9YdT3YHSJBBytE/hLyxPpaJWvtryH3ozxsrI6HbbJ+REDFuIH0dL39VzKF7AkZUpDpYZ6F2w4ZQ1j5pja9v6DtZbl7evszBxwZR+GTksq7e6TnJE1xYsWUElfHOS4qGofR/fRRLCQYULuyFBx23PNO+V5gBA3YnZ/rgQhCbfEasPAMBR+FzRebCjfrcxu7H496bju1rMgumDTh9qZsf9vVummKO0QuTDrQmUMZR/KFhytB5upu6eA0KUHJy13IrFSA1vBo1xBO1rCqqMBLO+6G5qQi6/NVaDYF3Zo1w1gpOHxiCSw+7UYt5+S9S3pihzS6FLnEb2+Rbs8mdvrxvbEtRZYBjEjRG0oqDQ0QO/5k1zmCL9//9JWEKdTGnhRrc/oHlcNV5q+degesr1WwjMCRkHRZ2FG1qNVEn5fcF9zPKbPmjfWtilK9zQQ+IEDhwEoPCUwB6U6GbEqBlZyq8d/YaTVtP0eZKAaVCQotprc6L+GUZb2jFjt0J08IIkqh1SPAoJYpVcF33E81nwnXAG+8wcc+YOwseuup1x/jdHscZrEhtA2HQbHHSMNqVyen6vBiCGxaqqSeJYoOuRkTXMDQfj39L2Wxs
 G8W8IWVD
 mJYg6/obMhVaUQmjCxR7FyIhOho2LRg4jm+alYtJB4AOFVCZgBRfFU7micOhvYjU2KMGLqZpkIhAcc7CzedVW3drrmHYLpwvxCmpqD3pPfIFgUduvDk/3twDwkXJwmctWxMg0EWylm2E+1ySs2H0cu00ibA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We observed uffd-stress selftest failure on arm64 and intermittent failures
on x86 too:
running ./uffd-stress hugetlb-private 128 32

bounces: 17, mode: rnd read, ERROR: UFFDIO_COPY error: -12 (errno=12, @uffd-common.c:617) [FAIL]
not ok 18 uffd-stress hugetlb-private 128 32 # exit=1

For this particular case, the number of free hugepages from run_vmtests.sh
will be 128, and the test will allocate 64 hugepages in the source
location. The stress() function will start spawning threads which will
operate on the destination location, triggering uffd-operations like
UFFDIO_COPY from src to dst, which means that we will require 64 more
hugepages for the dst location.

Let us observe the locking_thread() function. It will lock the mutex kept
at dst, triggering uffd-copy. Suppose that 127 (64 for src and 63 for dst)
hugepages have been reserved. In case of BOUNCE_RANDOM, it may happen that
two threads trying to lock the mutex at dst, try to do so at the same
hugepage number. If one thread succeeds in reserving the last hugepage,
then the other thread may fail in alloc_hugetlb_folio(), returning -ENOMEM.
I can confirm that this is indeed the case by this hacky patch:

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..39eb21d8a91b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6929,6 +6929,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
+			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
+			if (actual_pte) {
+				ret = -EEXIST;
+				goto out;
+			}
 			ret = -ENOMEM;
 			goto out;
 		}

This code path gets triggered indicating that the PMD at which one thread
is trying to map a hugepage, gets filled by a racing thread.

Therefore, instead of using freepgs to compute the amount of memory,
use freepgs - (min(32, nr_cpus) - 1), so that the test still has some extra
hugepages to use. The adjustment is a function of min(32, nr_cpus) - the
value of nr_parallel in the test - because in the worst case, nr_parallel
number of threads will try to map a hugepage on the same PMD, one will
win the allocation race, and the other nr_parallel - 1 threads will fail,
so we need extra nr_parallel - 1 hugepages to satisfy this request.
Note that, in case the adjusted value underflows, there is a check for
the number of free hugepages in the test itself, which will fail:
get_free_hugepages() < bytes / page_size
A negative value will be passed on to bytes which is of type size_t, thus
the RHS will become a large value and the check will fail,
so we are safe.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..b9c73ef81c03 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -322,11 +322,15 @@ CATEGORY="gup_test" run_test ./gup_longterm
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
-# Hugetlb tests require source and destination huge pages. Pass in half
-# the size of the free pages we have, which is used for *each*.
+# Hugetlb tests require source and destination huge pages. Pass in almost half
+# the size of the free pages we have, which is used for *each*. An adjustment
+# of (nr_parallel - 1) is done (see nr_parallel in uffd-stress.c) to have some
+# extra hugepages - this is done to prevent the test from failing by racily
+# reserving more hugepages than strictly required.
 # uffd-stress expects a region expressed in MiB, so we adjust
 # half_ufd_size_MB accordingly.
-half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
+adjustment=$(( (31 < (nr_cpus - 1)) ? 31 : (nr_cpus - 1) ))
+half_ufd_size_MB=$((((freepgs - adjustment) * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
-- 
2.30.2


