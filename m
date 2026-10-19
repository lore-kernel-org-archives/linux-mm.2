Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60D20606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=QedMmAPa
Received: by kanga.kvack.org (Postfix)
	id 729E16B0300; Mon, 19 Oct 2026 13:12:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9E16B0302; Mon, 19 Oct 2026 13:12:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9116B0303; Mon, 19 Oct 2026 13:12:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB846B0300
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCBCB16082F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:11 +0000 (UTC)
X-FDA: 85340018862.07.E86F5DD
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1492CC0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QedMmAPa;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=m1D9F1bqmtuCwdKBGEYxURhHSspZbk4MECxRgLpYlqU=;
	b=bTnqNlSGjxoeXug9Yu7cYXKUAyIdV/twu/mKpHd6pHOj7RLFdi/yO6ckjhZPx2gt+i3i2D
	6iBGmdAdjUkwhH7vTcCcOTC8Y5Zam40wGRZehCmG+4JJ81R58KQKmkge9d0MxDNo77+bT+
	SEbhBI1ruSx8qxT0Sur3Rjmezn7Sv0w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QedMmAPa;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429930;
	b=LdZAZhI7UEGMz01quydlq8xGc/BiFDMDJQqaDLqm5QpB2hCQ4f76O3WWIdsPnlEbrjga5a
	TXgtfhgZ3zmWk71I5mFmoCQrcJWcDIbRhkS/F7hNZ7hHA/H1ioNuuPddvmT/ZQvcUJ1JHU
	G5SIi4wNuUow2kKoeTEPKP0212x6KeE=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91b9e758c50so34736076d6.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429929; x=1793034729; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m1D9F1bqmtuCwdKBGEYxURhHSspZbk4MECxRgLpYlqU=;
        b=QedMmAPaDVqnvy/E4wncvG0CKBtBOL3bHSGY0LGFuKse0OxV75Ys6RO+w6a95gzRPu
         8a9wKFOhQ+iFUpDtW1UpYPVpZmZClK537Zxubk7FscAp19phEpLiHrwmcXXSReth5GcI
         Jo00Ap8x3uKFEDIDjTN+YbhsfoHvGmceTzZ3WbC9cgrmkbhfH23Azp+1vMJlEqKV+DEx
         Sj/E6DZj9WO0GIBxD/a1+8qW9qe75vWW8ipniJnuvHgYleK6kK7pEMTdrn5L18aOgwQt
         2op0pVKHYQdwjtGSQWGYMfbk6fOtONAYd0J1EALoQII89v+JMJrd7FfZPeKECgh/qvCQ
         C7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429929; x=1793034729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m1D9F1bqmtuCwdKBGEYxURhHSspZbk4MECxRgLpYlqU=;
        b=hmNlwKfpNN3uPXLQtiEEz7grjQsly605lvPV6YvJ3d+ECVAM9Y9GxHP4uYv4oIIFqB
         J+XxnYmw4+S9GT1QOnSMRNCJd77ET0tRbeqzrXS7f+feKRI3FEnYTyFbO9miIJqLtiCH
         AnFHabL7m431ZxNfXDklsu3XKjvVMA1WWniHVviC2NXn6tXTRth4vZpC1abp3x9CX+u3
         FmYyMCZSaJ3112KuxiAIekSw6aWEeRqtfPlYvbRvOqYOI4XArB7V1y9CL9eDvMFadUZM
         D8UvOlpAk2yqpOCPE1YluvjLuzzGsNComcXM2crVZAEFHhwq7OssjBrHZNyNElzhqnBt
         MhjA==
X-Gm-Message-State: AFq9FYKHfcf4gD8RCQxfLUHHENSXYNmhKJlrry3maKZ+ipEQLr9OUDYQ
	yKnl/1BZhFMJn5jhr16b2kbPjyEtHcyQvAucL4uhbdZTkCrCjrcSFk7Df8dcZARB68E=
X-Gm-Gg: AYBFou1qhrYlw703dGBZR8sRY2Mes7Pmat2XJOK8733Bk7NxW2lHun7J/KAJBhfYJU+
	e51HVr1DPd2cqUGwfa2oOhtlFZvA+2riprK/5xR6LBk/fWOQ5/xY1ebOuFbxhOH/CwWqPlBNEd5
	smRz+u73ZxatzL1OgF/NF+dOOkIx0721Mz6TjepS+ih/fAbsXDKYG4f/sACq+EQcIlW+IpAg37J
	WxA/wWogamXHt7QuZwEFQmUdb++5W5UlxiEp3YoRVR0hY/oQDVWkawFg6c7yclJsSSEB/UbNrxQ
	9zWoYtkJtsveBvohvnyE5s86jZ2qzNSyBHMwEdZKysGugZdfEZiRL+EBB/P71/320oJcoQAjI4k
	nF34D1a56M9tBu6PoDGNs2bO1YOPIXsdF7RYIe/088JcXezmuBTR+mzhQvAP2krFnGT2nipIs+T
	iI+P4UDIkgLxV0bofo8hSYHcFXQ5Lmk9QX6g6xtc7fyeRDDS+yon1gS7M/9bnDyQ0NltRh7qnN+
	vysJrIX9O/BLGYYbwgb/Tn41vlBqyXlKqhLxSfIkqPCpgdhwsAo8RZ6pSeD
X-Received: by 2002:a05:6214:19ca:b0:91b:5d39:e135 with SMTP id 6a1803df08f44-91bc96fb591mr195486326d6.32.1792429929055;
        Mon, 19 Oct 2026 10:12:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:08 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH v3 0/7] selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
Date: Mon, 19 Oct 2026 13:11:59 -0400
Message-ID: <20261019171206.3331374-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1492CC0003
X-Stat-Signature: px4ih4pfxicsxqs5b69xtyu13mqbbtpx
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792429929-822960
X-HE-Meta: U2FsdGVkX1+7YXGP/wbmjed/zWpFzslNOUhnY8n5QErlIAR3O3beaPhHKHAQlOt1NuFLqPPBzbVYoESRzuBiqqwDnzjTr2+7rMhvwNqSKhWmSMYWhjqAynuI2DfIgQS7Y6vXdy5RtbAmlG0WrFh1pJEj/Usq+82Lf6jSJeUo0ye/+lIcHE6s2TzymwrVc6mKgXXoG8I2T4doj1QeYdGc/lIHpnX1D4vKp46blIDVvcvLsTXRnER7BBd/P8Rx5I9EDXUsPaxGiifExwZG5oEhfZhDJWeD8M7QVKd4sHrRuuGQG09hnloGcZhYfo0Sunng8YyZDSG1fBrlWoEs34HYgrRDojhi1b2ePNwUA34LJamxRVOWwnfZZ4vFuZ4+U0RmY3gCts7RkzDvhUG/S7lZBKvNl9ra3LNdcILZgS3+QWAVU+FqVcEShXpiKWV29Aa2OgtaKRKHwFALubMvSqrfV9EVZJ2Muj/4VgFhFRLhf52jPieDZufI5VEYCLVp0ISSk3oJzcu1NHBHKTel8lAcIY0KjaV9LMC429p/2BqY8Eioqks9IBhhx9NehnAqiJN5ipc754VYWPjLtJUxkjWJB2zZeZ6yBCL6QhpBF8WfjfnEMnR/eDuWA3R2xzLu0S02CU1bcEg+TKYJfZHsOtWs+R0lSs5vOe8hvzYka4SLbygYav1jXi0pXeB0wr8wcQGbFgqbwtISsK6I/6wkNkg7VvCSquKvsTvsOq7bSzrsiH43am2Uj7gAYHyXbJLoEhPEiNSO+/RNJv6SvHb5AKq/e5utB9KKBeBz7kzFBJjqkUKNdSv0UMPkoMz9zxyucZn/DPJLvOF1AV3R0hm/VcQaEgGtNqCPsZVwpdLAxt08V7I46VHPqqr9BOPsHMOsaMLvCnp7CFWysBjI4O3nSNQ02ANWNNcrzbgez+3f3DK65lEOYUiYsOgBxACmyH9Hzf9d48vkTV6rYv0JqSE9+Xy
 Tu0KCJAy
 YDpA2lnVYG6gxt2TShPSPnMohOC1N5vjLNZDOhaHpENgQ8NVhmqZ0ho1TYm/yfcv/iQCdVj78TBtk7uusuMYjm0TeEXXJXj122u/P3CyK2TIyzi9SXL23L5tOsrl1213q05Un/OqSK0e6RpYr0zhgv/QneC57iDh5Z0bMX54a4A8xyC3hIgQ3CqY6BRLZfjdas+P+I6Qh5L9in+Yq5MqF/ltTmrccwUAvJTP087CDp7XkCK1uIeqGnlcUsxa4dyuDlS+SudEidt3oDFXS38ZkOSLqNfxYuuT5L1IpOVUVYPnn+6MXhHILaO+dLN2LVozeHS1YKlHF5eFK0/81IBr62UyarGhINzI3gx72Kl0B1v9Ezi2EfIrE+ab2ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_COLD and MADV_PAGEOUT share a page-table walker in mm/madvise.c
that handles ordinary PTEs, PTE-mapped large folios and huge PMDs.
Existing selftests cover little of its range, folio and permission
handling.

The walker has needed several fixes recently, and it's clear we need
to refactor this walker to make it maintainable.  Ahead of that, let's
add some selftests to at least cover contractual behaviors.

This series adds tools/testing/selftests/mm/madv_cold_pageout.c to test
only behaviors userspace can rely on, so that it stays valid across
changes to the walker's implementation.

Each patch adds one group of tests, simplest first:

  1. neither hint populates a hole, faults a swapped page back in, or
     accepts a locked VMA
  2. a zero-length range succeeds, an unaligned start fails, and a gap
     fails with ENOMEM after both sides are advised
  3. neither hint accepts a hugetlb VMA
  4. both hints preserve shared memory, and MADV_PAGEOUT leaves a
     SHM_LOCK'd page mapped
  5. paging out all or half of a THP reclaims only the advised pages,
     and MADV_COLD on half a THP leaves it intact
  6. only a caller that owns or can write a file may page out its pages;
     anyone else only gets their private COW pages paged out
  7. nor may anyone else split a large file folio, whether a PMD or PTEs
     map it

We check whether MADV_PAGEOUT can swap/evict pages at all and skip
relevant tests that would fail if it can't.  We do expect that the
swap/eviction will happen within 1 second with retries, but this has
been reliable on a reasonably unloaded system. We may need to increase
that timeout if it becomes an issue.

Tests that need root, THP, or hugetlbs skip accordingly as well.

All 24 tests pass over three consecutive runs, with no skips and no
warnings in dmesg, as root in a virtme-ng guest with 4 CPUs, two NUMA
nodes, a 2G swap disk, THP set to always, CONFIG_DEBUG_VM and
CONFIG_PROVE_LOCKING.

In the same guest:
  - unprivileged: 18 pass, 6 skip (5 need root, 1 needs hugetlb pages)
  - root without CAP_SYS_ADMIN: 22 pass, 2 skip (need page flags)
  - no swap: 16 pass, 8 skip (need swap)

Changes since v2:
  - renamed to madv_cold_pageout.c (Sarthak)
  - pin to one CPU for the whole run (Sarthak)
  - check swap and file unmapping once in main() instead of per-test.
  - COW test retries, and fails if the COW page isn't swapped (Sarthak)
  - gap test checks ENOMEM before it needs swap (Sarthak)
  - reserve a hugetlb page as root, since run_vmtests.sh doesn't
  - ignore /proc/kpageflags when pagemap hides PFNs (no CAP_SYS_ADMIN)
  - shmem tests no longer require swap
  - owned file test no longer needs /tmp writable by nobody
  - folded patch 2 into patch 1 since it's really the same thing.
  - comment and changelog fixes

v2: https://lore.kernel.org/linux-mm/20261014175756.2035176-1-gourry@gourry.net/
original set: https://lore.kernel.org/linux-mm/20260922235830.2350770-2-gourry@gourry.net/

Gregory Price (Meta) (7):
  selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
  selftests/mm: check MADV_COLD and MADV_PAGEOUT range handling
  selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
  selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared
    memory
  selftests/mm: check MADV_COLD and MADV_PAGEOUT on partly advised THPs
  selftests/mm: check MADV_PAGEOUT file permissions
  selftests/mm: check that unauthorized MADV_PAGEOUT skips large file
    folios

 tools/testing/selftests/mm/Makefile           |   2 +
 .../selftests/mm/ksft_madv_cold_pageout.sh    |   4 +
 .../testing/selftests/mm/madv_cold_pageout.c  | 971 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/selftests/mm/vm_util.h          |   1 +
 5 files changed, 983 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_madv_cold_pageout.sh
 create mode 100644 tools/testing/selftests/mm/madv_cold_pageout.c

-- 
2.56.0


