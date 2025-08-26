Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B662CCA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA5F8E0090; Tue, 26 Aug 2025 03:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0A18E00A8; Tue, 26 Aug 2025 03:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BCB58E0090; Tue, 26 Aug 2025 03:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD068E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:07:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38D9A1DDD5A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:46 +0000 (UTC)
X-FDA: 83818028532.11.4A238B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 957D040003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:07:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ypy/1xWR28AmklR7ndpW0RCxWsQKov3k1bNo0z16lvM=;
	b=phDmEzSKihkNBHIM2b9Rq8LubNlg1TIkthyOY3U0p0ALkOYZWJ8ylVURwa8w+mptwv4DXR
	sid13PB1wy/QlaAog8LeIMEmQAz43tqg6LDwIN0Q7JLkRYmj/PfPqhTKq7zKhMOWwrhPni
	KZ6iGCMLuDU+ltAYd0r3884lzByWAyg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192064; a=rsa-sha256;
	cv=none;
	b=S8CKoUG82UdVlRij/EV0HDn90QOCSc27lGLXIdlp1WqYf8JlC3RrHuecJLRuP7JVvTm273
	RfKCgcpPQsYnOC919zG8B8rjX6tobhUzs20/iv8FXUO1ypoR4bchhMEAWUXAuL28TTF3b3
	L0Hx5GHtpYD9lfm3BjFtKgZwu+msYUk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56D9E1BF7;
	Tue, 26 Aug 2025 00:07:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.163.65.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CD0153F63F;
	Tue, 26 Aug 2025 00:07:37 -0700 (PDT)
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
Subject: [PATCH 1/2] selftests/mm/uffd-stress: Make test operate on less hugetlb memory
Date: Tue, 26 Aug 2025 12:37:04 +0530
Message-Id: <20250826070705.53841-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250826070705.53841-1-dev.jain@arm.com>
References: <20250826070705.53841-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 957D040003
X-Stat-Signature: 4ayon3fcdiauxstm6cp97u88s1e5a111
X-Rspam-User: 
X-HE-Tag: 1756192064-304761
X-HE-Meta: U2FsdGVkX18ujJBeQ5VIxsTWRTb3B+TA3qtoZ/RkxoeH45rwJVZKmt32SQKxP4VfNByalZbCzaqSX4HLG8OK4pTZfr8ahBqEwAXBT6wv/Har0bRlRbDt3vQkE3Cmmjdk8GgA30mlDbXxJcj4rvav44rEwgtmQ5x4jTTAYKfXH97o0v3L+ZmBHCTYgPkWX2BN9K9tnMAn8Q0UrW3rpH5lXa+EvaazECvRYSexY2huZ9tQ9JMAgWchDHNxgxPKMf0N8YepYqGPktRTw6AGM7wrIW3Etod/qh+ZkixGoLo53YEQGlbJH3eJwmaXOGsgqVJVU77qO66ZB+fufOEIsIevyJhAsJ2bqHNeQgtR8+qhmvTohaVx1cL4T/O0dwQH8ZVIJG9UeU5Xi8pELgKkqySZZUXNPvf+fxUdV+KXtxhRY9hxc/79sCD6ozp5VGtxzT3Xza/+kK9KrvcCFMp0E6PIcAfQNeuvQSoHlaK5CYu7/b7HstYdV0aMNIuLIoTleMNc7rtttk3+HAYOjMx36atFTZSZeb+c/AxA7WJpF8x7/BjgGbpUMY696ABnjEiY4NbWsfx2eUO26FyAs5u5tvy4hyqsdipSaCShzlQlaNRA3cCbQbcSBh6XTSNpY98M7xGABgxmz8K3zezdOrfMQ4ffC3jgkMWP/YyjMdmNLIIfmbcHDVqNSZaO+ve4MtGg8WRfpc6D+dt4Q+UAJx2jWgxOhkugaWxxD6fAEEtjorzasIHe5SoY9nFpIz6HLM7AMgxEJ6M8CJhX9sgPEYNSAU3VupebwOHslC213ITOHgz6QWzhAbjtuD3Xzl16i3eDkOnKPGZk/tDIdqZx8P6OCdYubX5k2n0/1edqgl3zeRCDn6898R62qr5exjbY6lq96doQjyJXdYHmo8oYft9mQS1/u0l+6ik3ZU+QntN1UFIm1zKl4gvQ5rLtLIItQykE7iNzruNw1sVYSs/AEOIuEOY
 GBr6V0tQ
 lOoP5t3r0/Qxx/lSQ7hp8DnFuZ4Nj3HaKxhKH2mODm2OmMAoU6O3x5IS171oiQABQqkrGWeGm9KgHKe8QiNh9CVPTjX5kA51v4OTOVnMBNDPIDeaCWp+jI0VySz4fn4Z97zzt4JAUh2huuoV43z2VgddxPQ==
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
use freepgs - 10, so that the test still has some extra hugepages to use.
Note that, in case this value underflows, there is a check for the number
of free hugepages in the test itself, which will fail, so we are safe.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..6a9f435be7a1 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -326,7 +326,7 @@ CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
 # the size of the free pages we have, which is used for *each*.
 # uffd-stress expects a region expressed in MiB, so we adjust
 # half_ufd_size_MB accordingly.
-half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
+half_ufd_size_MB=$((((freepgs - 10) * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
-- 
2.30.2


