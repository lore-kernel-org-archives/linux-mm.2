Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0669606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tsNHEGy7
Received: by kanga.kvack.org (Postfix)
	id C72D26B05B2; Mon,  2 Nov 2026 08:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23296B05B3; Mon,  2 Nov 2026 08:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B396D6B05B4; Mon,  2 Nov 2026 08:24:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84A236B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:24:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 10E9AC0CF0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:24:54 +0000 (UTC)
X-FDA: 85390249308.22.51722CA
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id 82D9480008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:24:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tsNHEGy7;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793625892;
	b=zlqspwDSml9qKaq7un6GfHYwtcF7vn9hcYoD7gjaLCH/StvOGsc4sIwmp/Ynk9Ug/+MGFy
	XsgMozpwaEu6ad83eEaBD4zIiRxDp2LTVogDkbrQKbiUbw0Q5HBYFMpwosxLYrDIZNl55h
	1+jR0N0jSyC5YdyCZGm4Jy03G4C4c9Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tsNHEGy7;
	spf=pass (imf30.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793625892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PFdEbpMzyrUyOoAPQkPaKowKrJxy58xu6akDhFUV31U=;
	b=LTHAo8Pj/rkJnB08/vn2wFNdfei+o6HG+5Sf9v9fl0/TjixNA6fJDbxkd2092/HDjkSzyn
	PXtopSWecpxa1WBPnz5EdlBjegN5NGxZZzDCfjXO0llz3E14a20c0K0loMOSRm6XSJRAVm
	7yHHWNScYufc286Wco94guta0cHUTfs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=14eoNhxcSXoUqAVClMXRlOVC5qS0wm1dHShObxBrvnQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793625887; v=1; x=1794230687;
 b=tsNHEGy7YD1vRjByHNMbZlh/7ScUbsxdjblYaunIdvljJ6gzjao+9sPt3JrebH474B7/8107
 O8uSIYUzGokSi0V5mqDQJ1yEsciYSGOPnfUdkFHJVgGqjCKrgnoIuN40ZGq3W2jvq04wMrSPhW4
 rlTx/Wpy2KxCLLYebDEt5C1s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 19717573b0124653;
	Mon, 02 Nov 2026 13:24:47 +0000
X-Mizu-Trace-ID: 19717573b0124653
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mhiramat@kernel.org,
	oleg@redhat.com,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	james.clark@linaro.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/4] mm/ksm: use per-VMA locking to reduce mmap_lock contention
Date: Mon,  2 Nov 2026 21:24:16 +0800
Message-Id: <20261102132416.300084-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 82D9480008
X-Stat-Signature: tyc6wtox86f67rpy7dopnjdko4ojfrx8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793625890-283551
X-HE-Meta: U2FsdGVkX19LvKzOd/bJZoyNucmJfcyMycf11X9HiKeKV7HpBOhatnWeJQKYUEdEZtG5ZGgPf5n+YOLPicbckluvHWL3O3t8feX4khsqrx5ii1VhJ0mHE5wEau9Jo64KOZuG8ngP3WIo9boSx6gE00FCDBle34X0w7pkWjxwpRqluszRCF2V9EVrtDkRu+I8Sqh6QAOAnQX3P4ipKOj0wSMqbv+TsYmuhXrFirMfnImuIgHI7PSNKytpbbhOlf6v31NxiCwMZ7rRwVKXccSzUkC58P8bqBvzR3i9fkQ6jmbT97mxLFW/SY4W/CMeNUKP6cSyL3MY4bV6BEHYXliyJE9umqBsFOiyJiAlggIulesHvcoiFyTKWnrBI2jgz/Rx/DHg6rHx9/sec1Lhv4p9MxJifdeoF/cPhb8JuahIC4kWNUeplSd30hKF8TQLnWKCtP1XpgwVqdQFBkcRFvmi+HESvpMIztWWFgfuukSQj6rHDwAaxw5Y+6DwrUtWTL2mzB7NkW5KUeND7AmuvTqaQv2P1X2X+ShsmfhsbSfDit0C5D9VP2g0qO4gS6nBPGu0jCsU8B26Hz1ufu7J/H0zlU0IE0bpP3eTDY9lXYFJCwgXBeaeOND6eE0aTiXjrDEjgKCB04RG3Z0z9cLYNg9LpXl5LnKIsZTaYvOf7mGRDCnw9Kzw1wARYQy7rHTKpQcJXU19+La7Dp6QnjlWWoYEjnEg4pRNNNXNZdA/AsmMWqNcpJFRDsv/TLEuuXSwmyhYWT3ojLMa5AydESjvbo3lXVLixwFiLBOeXFv7ZHlAU2CGOPG5T8aOA4ZAlbwhCfA9weK114fE26JeQ3exwhNHecPd0b5w5E1vAqcqSQgLTFw6s3p25ZisdRmuJ09toLzZ6giw80JcTeUAeKA9Arm4YLpOMiHCTpBfP150ycvGXc2HehyZGwzmSpk+ISqflIDTOFiOrG1oUH0s0oDVESD
 Wo9bIP5y
 uHB5Hf1CIJI/uVj2W6r/rvrpYv+k2Wljiosi65ATdB8RK9i5YZ9MgaysweqpjvlzOCTJkwGMBdXUTIFNGOWMvUTWTnHW3QZaaFtLR2XrxLWa9XDmZM2BDCVVKMHyWvoc5mSpAqbTCNI37/Za/XgB52i0W3j1qrJv6fs2Fvw2kp2qW3wdy4IWA08nAbJdgN84XOISRzfPJp4hLfFR8i/gGPUuAV7c+wzz3lam0Wus9XQqHq7U6HSl1XGUi7HC8psRUWXJhs4PyTCGJ2hI46OJZK9KCdum80BBRynlyRe78E9v4ICYR8H0gjUx58zoWLePTjnb8187zdWy3ey5U5j0cPicOgdId5ctkiwbo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xu Xin <xu.xin@linux.dev>

KSM scans VM_MERGEABLE VMAs and currently protects each scan with
mmap_read_lock(). Per-VMA locking allows KSM to read-lock only the VMA
it is actually interested in, so that unrelated mmap()/munmap() activity
in the same mm no longer blocks ksmd.

This series is organized as follows:

  Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
  never been used since its introduction and is pure cleanup.

  Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
  folio_walk_start() to assert the required locking mode.  Existing
  callers are converted to pass PGWALK_RDLOCK, so there is no functional
  change.  This prepares folio_walk_start() for callers that hold a
  per-VMA read lock instead of mmap_read_lock(), which is needed by the
  Patch 4. No functional change.

  Patch 3 replaces the boolean 'lock_vma' argument of break_ksm() with a
  KSM-local enum ksm_walk_lock and builds the mm_walk_ops on the stack,
  so the function-pointer table stays const and there is no shared
  mutable state.  No functional change.

  Patch 4 introduces find_mergeable_vma_locked(), which uses the
  universal per-VMA locking helper vma_start_read_unlocked() to look up
  and read-lock a VM_MERGEABLE VMA without taking mmap_read_lock().  All
  KSM call sites that previously used find_mergeable_vma() under
  mmap_read_lock() are converted to the new helper, and the locking in
  get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so that
  folio_walk_start() can verify the per-VMA lock is held.  Because ksmd
  no longer holds mmap_read_lock() while walking, __ksm_exit() must also
  write-lock every VMA (in addition to mmap_write_lock()) to keep
  serializing against an in-flight ksmd walk before the page tables are
  freed.

A microbenchmark was run to measure the time KSM takes to merge a
victim region under mmap_lock contention. Under interference from 4 churner
threads, the merge time of the per-VMA KSM-optimized kernel is
significantly reduced by 50%.

Changelog:
  v2:
  - Patch 1: rewrote the commit message to explain the introducing
    commit, how the VMA is actually used, and the audit performed;
    dropped the Fixes: tag.

  - Patch 3: 
    * replaced the boolean 'lock_vma' with a KSM-local enum
    ksm_walk_lock instead of exposing the internal enum page_walk_lock
    as a parameter;
    * build the mm_walk_ops on the stack rather than
    mutating a global struct, so the function-pointer table stays const
    and there is no shared mutable state; rewrote the commit message.

  - Patch 4:
    * Fixed a per-VMA read-lock leak in find_mergeable_vma_locked()
    when the VMA is not mergeable;
    made __ksm_exit() write-lock every VMA (vma_start_write()) in
    addition to mmap_write_lock(), so that it still serializes against a
    ksmd walk that holds only a per-VMA read lock.

Xu Xin (4):
  mm/pagewalk: delete the unused member
  mm: make folio_walk_start()'s locking asserts scalable
  mm/ksm: make break_ksm() more scalable
  ksm: add find_mergeable_vma_locked() to use per-VMA locking

 arch/s390/mm/fault.c     |   4 +-
 include/linux/pagewalk.h |   2 +-
 kernel/events/uprobes.c  |   4 +-
 mm/huge_memory.c         |   4 +-
 mm/ksm.c                 | 124 +++++++++++++++++++++++++++------------
 mm/migrate.c             |   8 ++-
 mm/pagewalk.c            |  10 +++-
 mm/rmap.c                |   4 +-
 8 files changed, 116 insertions(+), 44 deletions(-)

--
2.34.1


