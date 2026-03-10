Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7553FCC9D1
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 07:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCB326B008A; Tue, 10 Mar 2026 03:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78CA6B008C; Tue, 10 Mar 2026 03:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AEC6B0092; Tue, 10 Mar 2026 03:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A811E6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:30:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FC1A1B8164
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:30:49 +0000 (UTC)
X-FDA: 84529331418.02.9A8E8B7
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 638B5C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:30:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773127848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=lw5GknMq60aHBt/YcK3pWYcpz1Z2ln/AyAgRsoN+0iQ=;
	b=7iKxdF3wQCYzblxzTlWJ1GSEB9IF+hc+KYvY7n4AQKp2AFmR+IdDgnHp36yqYxHwRh8JLK
	RPb+Zvhzc6yveAkG01DHpWTLXS656/wkaP2h69UbpjyobMmuMAJbXMbauhSipOBaf+nrBE
	LLg2hXOBryJFsLYvK3HMS9n2WJlyFR4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773127848; a=rsa-sha256;
	cv=none;
	b=j+/15CVYDij5ESU1BOMLHkbtnuH7GKIEUXPrx/P5PPmtqMkqVi591BXrRe1jC02+aCOADM
	P3F7/136l3RXoWcr8YvMZ04eo3fJGww5qHAUU4Ben7MqKpqdxrrFmmLb0r00VhXqDztHNz
	YpCfwrifG4GrqEkkHNsFA+ZkihakyB4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0968C152B;
	Tue, 10 Mar 2026 00:30:40 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5A5A43F73B;
	Tue, 10 Mar 2026 00:30:37 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: weixugc@google.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	ziy@nvidia.com,
	kas@kernel.org,
	willy@infradead.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH 0/9] mm/rmap: Optimize anonymous large folio unmapping
Date: Tue, 10 Mar 2026 13:00:04 +0530
Message-Id: <20260310073013.4069309-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 638B5C0005
X-Stat-Signature: 7jb3g8jmjt5nr88z3d8jga5uspg9siae
X-Rspam-User: 
X-HE-Tag: 1773127847-15700
X-HE-Meta: U2FsdGVkX18+G0ItXdKlOMoP0ZIf7f0kC7SZ4L0EVjv/7kVMOA4cg/d12JEc9oQjY4hAxq/tkvBYwxdDKO1w/WdIYsGmAOIf8XdZ8KBLsFY6DwdsszbLLM0OtOPOpLqHlqCi6Y1vzH15M0ck9yCe/pC1nW43uUmBrXw8zSqFRFs6dLPrd1Yg4VeSJoTnCJyemHj5wpIoUghUi/Mr7ySor+zNFYNTloUQzzucpfJblL6hu+LLV6kkEc03KzRr5Wv8xFMchsUlcNUr/Jl9L1LQpUDtAUM4Z/LGYuXAPVdHt8az8iuZDUoitozf8VDTHl7sIMf+USnfHEiJb0M0CjMi7L3vlM1qrPpsDXXn981WF9uZDiwsqzl1EEiSKH24MR+8Z9wgKLAR/3D2tVgGuO2TFRY7dS6v6Rz448XcMU85KyI+G+5zcfTWWKoJwYZEmayl08HXfUsnYKw0J3UAj0Ua5xAZDQoycGvwfmxmc6D9fYD933E5bRCSIyRWf4gkwOHPpfHnmqiR4p+5Bmq5CpGJbnDSEO7kwirAoprOFb8sNaiMQbBmfrOzvHZyu2z/QIsPU/mOYgJhZa4tDitJAaMVS3rdqiBBhEdpgE1UnSTWemyGkPpHtyMGRsfgJF5xsROwF8bnHHfKd8vWh16ywhaIkMrJ9Wyhxf82lpSSDQPYYh6Vlc0+7LYrVannPySF+BU7rU2Nc3KzUhKeMA92GjkWpyXrcUO0ET+ioVyqLlDr4HgsGZDhlov3QFSy4pNPj7BdrzCjPWmYu+GFO6fe2njGxQqvlw6qnVzPZuG3XP/gp/foB0bAj+TfDxIJOFu5le6tQvKhbX+gOYETGLU33b4t5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Speed up unmapping of anonymous large folios by clearing the ptes, and
setting swap ptes, in one go.

The following benchmark (stolen from Barry at [1]) is used to measure the
time taken to swapout 256M worth of memory backed by 64K large folios:

 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/mman.h>
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
 #include <errno.h>

 #define SIZE_MB 256
 #define SIZE_BYTES (SIZE_MB * 1024 * 1024)

 int main() {
     void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
     if (addr == MAP_FAILED) {
         perror("mmap failed");
         return 1;
     }

     memset(addr, 0, SIZE_BYTES);

     struct timespec start, end;
     clock_gettime(CLOCK_MONOTONIC, &start);

     if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
         perror("madvise(MADV_PAGEOUT) failed");
         munmap(addr, SIZE_BYTES);
         return 1;
     }

     clock_gettime(CLOCK_MONOTONIC, &end);

     long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
                        (end.tv_nsec - start.tv_nsec);
     printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
            duration_ns, duration_ns / 1e6);

     munmap(addr, SIZE_BYTES);
     return 0;
 }

On arm64, only showing one of the middle values in the distribution:

without patch:
madvise(MADV_PAGEOUT) took 52192959 ns (52.193 ms)

with patch:
madvise(MADV_PAGEOUT) took 26676625 ns (26.677 ms)


[1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

---
Based on mm-unstable bb420884e9e0. mm-selftests pass.

Dev Jain (9):
  mm/rmap: make nr_pages signed in try_to_unmap_one
  mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
  mm/rmap: refactor lazyfree unmap commit path to
    commit_ttu_lazyfree_folio()
  mm/memory: Batch set uffd-wp markers during zapping
  mm/rmap: batch unmap folios belonging to uffd-wp VMAs
  mm/swapfile: Make folio_dup_swap batchable
  mm/swapfile: Make folio_put_swap batchable
  mm/rmap: introduce folio_try_share_anon_rmap_ptes
  mm/rmap: enable batch unmapping of anonymous folios

 include/linux/mm_inline.h  |  37 +++--
 include/linux/page-flags.h |  11 ++
 include/linux/rmap.h       |  38 ++++-
 mm/internal.h              |  26 ++++
 mm/memory.c                |  26 +---
 mm/mprotect.c              |  17 ---
 mm/rmap.c                  | 274 ++++++++++++++++++++++++-------------
 mm/shmem.c                 |   8 +-
 mm/swap.h                  |  10 +-
 mm/swapfile.c              |  25 ++--
 10 files changed, 298 insertions(+), 174 deletions(-)

-- 
2.34.1


