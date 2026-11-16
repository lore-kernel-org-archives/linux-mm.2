Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD1B606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K8zHPTFK
Received: by kanga.kvack.org (Postfix)
	id 3E6656B05B1; Mon, 16 Nov 2026 06:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3106B05B2; Mon, 16 Nov 2026 06:03:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3396B05B3; Mon, 16 Nov 2026 06:03:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020126B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:03:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8793340978
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:40 +0000 (UTC)
X-FDA: 85440696600.18.B6066B7
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id BEA78120003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K8zHPTFK;
	spf=pass (imf29.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827018;
	b=HBvZctfyIEsm2gdWuNXVO7ZOCpP1zajNKsSAjV6w03rfkZcDr/oB2/Bgr7/YJJH2lMKlO3
	Po47G29+YAEaCcTF3H8Sw0AhnKk0rc+Ru/pabHHTfHLCklW/zf4UrT3yrbEDFBGXNcWDEX
	MPd9uS5bSPRmGDHzNxAKcv6RedxIMac=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K8zHPTFK;
	spf=pass (imf29.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
	b=URLnje1aTKiajdeg+H/ndLo7eGiugDkxDqPDpoKw1oAM61zk/aHo66TBK2IP8poty/2SNs
	Ks64Uri99H5boinLRFasTpLKKMhNc5I2D3vUE5Pw1x69/QaIu3Wuri6lqWCtF7W8cV0vOC
	QKmUA99QKRv+NrvX90kdusyYHePlemI=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b244fb7fffso3721547c88.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827017; x=1795431817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
        b=K8zHPTFKs3+X0mLBt01awGscrV3LJu0K1Y+T9O6XCc8Xcwekkxm+Ofvo0gARoRnmYl
         A6xTFCOmdwUN6XzJYPC/KOG4haOEGTZVHCpYsYXe0YCgbdQkk1e5UZClIKfA59jpwQvI
         j0ff67g13u3a5NGdVR3+ooK9c7LYUDaxGm1eE3GiqeidvWYf8Ar4EWyAcbHcsFgpnkRw
         z7SOum8GWMIP+JTqx0daVXVywsi+Zi79JIa8qfUslhEBwIcdzSFa6SLJIesc1z+MxYW7
         0Im+QtCu9C+9i1WAiy+NNxzd3PppUitQ5RxSn5BHG9TngPa+xnMdGl699kTDlBJ3Vxm0
         Q/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827017; x=1795431817;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dtkPIsMJSzldfEnqyfpO3Kcdd14xhNY/Wofzn7QSnQ0=;
        b=OzDtT+XuMz+ZaoFy+ZkPtz1y7N4DOvg9qmgjnKpjLxPDkRlySMCutonGSozMnY82iO
         0VP8U4npcLAuEWgnISZC1o+Ggvd864ycGcJ03NeW2J/c/1l2EyW8TmkhHljfyd5/xH+i
         AI180vqiD+rlrxlkslV1DbsXfFf3ollsDycmL/aQSFu0pCNszCwNUUOQdOGjOR2NZW/s
         vrWsu2YF8lnEihpjaugy6EZ+2djwc/4aUW+LDmikqm/U2j8UcqVmX+xTEBijWoaAwC1y
         SVUurT+8yN5JjNIrQuOXy3XnMJslomsNg34DzlE4k9gWepVUaMY1SdHu9/9cZEupFfdY
         NqAg==
X-Gm-Message-State: APuU4Z8atyKcZggumRL8ftXCLmnGMg/9ZWxixdDl7GI+QNodcFKexiKT
	haq0sDhXQtTkvcFqPsFm04+8uqtOim41OW7EwOuWWrNUy0Zn+ZuDYWl88IYQkunlCTdqshAP
X-Gm-Gg: AYBFou2gXMH2x4SIplKmPGeQku+28JddFBmgMhpaqqUOxHppMPiaoS3P63w42F3C5V4
	AEcAh95rD0A4v9raxZch1MtHiHMT/HIapBL3rQtRDpJVjpo3UimBBu0qmP1nTwbtU60ag9jtg7N
	wnuDbj+PaiBeQRvPTfbItGVWODJ//JzN0eV+NTiyBJIDXyvP78rGgprzs77NpZwevtyz1MBa0Na
	aT9SlB4wm5Y6KTee5EdyZc2IpaNROnzdA8fBp0FpbbmctkLyVKWraA1S9Z+wdhUl+8TxLrC3KhW
	Pd9nfBSQTFnB/F0CZSNt1KK68QcVQWf1xd0e2nRY2IHCCnqyAYL9UxAZ8hGtqH8V1bAId/4ajwg
	QWzIliASxgeg1g8zvjsj+8nuQGysweiSpbIO0RvgvDUTqTRv0sSBKzUQbx5/xMXpCbylXfnSMf9
	rpNdO2/AyG6XyaSne92C3LNRNCoqP3PMyG38rDCmTafv9re4+gMT6DyYE2nuVf41UekACCastXX
	F1z41FG/asTQKtNZxQbJvy8vdTbJ7x4lrMFgUPFXP/EmsTJAh8heLLtjmLrcNlL372lT4OSS2Xa
	6SS0iprbddVmsXYrUr0kfWw0VnMX2/bqgTycizacM0TT64U=
X-Received: by 2002:a05:7022:5f01:b0:151:2e62:fe8a with SMTP id a92af1059eb24-1b50313d8a1mr9131206c88.40.1794827016955;
        Mon, 16 Nov 2026 03:03:36 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:36 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 00/16] mm: add in-memory compression of reclaimed pages
Date: Mon, 16 Nov 2026 19:01:06 +0800
Message-ID: <20261116110122.309748-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9geqiix1wf3kgf6oyitebs5f858kysrg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BEA78120003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794827018-684901
X-HE-Meta: U2FsdGVkX18iurIZDsGyEr+CLqPHh0LAFMmKLeuHv7oH8a3x1RTv+eaSGXhNEGl+k5v5XprCnvvZc6uFc7/Rocj0Y1b0Jda5+MiMboR+GZGkRmZJQhG0tQ5d1OvQhalvPDt6LZ3cJDBq9hZrCd5r86mybFHRJrTqyIJQceOYyOxfT/66cYNdBVdENwuwX79ATtephv0SqDgBURZrcu8F9ofcT3s8oU6PAIaGDIbC7pxm1Ak6kjyrAuSYUIz72RPr8+vIQb8h8DpoX1rM4jyRw5ssEi+lWQD4D/lhApINuXE5/wRJdFGFFl4e/coD+8RPA0riRuWpj8Yi/CHhCl+QZWg+dEBpKNgtHxLTJ7jKAUfy3Uq5NlezoqZQonSUBKM1SXF0V0dmmY7NDg7m2wKgXszcaxqpn1/lRve/9eKQZr/PnuvAQhOSR9htG0JikXSvcrrckMloRpZfbu8ApjyER7uhhzgcSnXkDkZxAIQuly9j7AR4Sohebc5f2plTlM+Bn0+w343tsk9J5Q905o4eTNxAHIr0ddvxrMaAgbTghR1mBMOQx2aBHlQWskpWvwqzWbBpPOaM/dGMQHUMfxtvHwHWlkmpcKuPKCdexenqw6z32QZ0hM5wELWwriyWyL2vGZxx7kXu1odiEKiHlQMLlJ5uh8Gr7NMqzBJcp4KBupZGZrkR0W0EdD+bkDKmTU25CwLreVnRHIMeHm0i7lqLHLnUjAOj/l78UxqLYNAVJOGuvhQf4fRViWNZTx1B9F5Hr64QK6r4genBm+SB0Zz0LYbQZt4mQsVDnGiksC0CAjEm8TmwDZyc+ELI9RZPrIgUcuEc1wwNWVofgZbO2mhhBiEjlVGT9V5DUx+9bIcLsgvVaaeWZoSrQSdpHWs3ahFloUyu5gzxJHzWEfis+zQEjbjU/YCnVLYbj3DfTnVTUbCldJLWwFVHfFLy9q5YfjWmLQ8SWwIHm7Ea/Cnsqme
 LCyPum1h
 7qph0cvogSpmWGEP5/c4HnoHHKYKuuagi/fPHn6SpS37tqlOw5sBQS0WWKtiR6l9c6ZwPBrxE9eMKO9tzCpmJtkIoNsrLy1oweKH3zpDoDXxDpyWF2niIENlZAEEb2keT06GPuQq8g20ZHVs44TlG/MPyQfbnggQztLQJNXYSXjjlEGbZaS/JTD+9IpJnFqMbTbCco0FBcj+aEpWtG8xgemTbhSzE44U+foKaKxJ/Ar7HDI+amfJ05SRj4NNDlOnstiGH7u37fqeMrrIdL4CHMup/gWRpLHrxl1mhYWh1PIEE3AMtMBAtiuEMinsDlyiyEbk0MJLv6RxI3qan4cl2vOSJVKbPMI6PgqsW0D00/48s7+mOKed/4jZMLQGT+wBMCwBg8fMOqL9q7j/VdKNwldJk6N7IXPadgiJgjFMO8Erhn1CweC1C6BzdqIIaaKU20l6S/M/4GlS/wOQutMJax5DwwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a proof of concept, posted to ask whether the approach is worth
pursuing. It is not meant for merging. The series is based on Linux
6.12.23, not on mm-unstable, and has not been ported to the swap-table
and zpool changes that have landed since. If there is interest, the
next version will be rebased onto mm-unstable.

memcomp stores reclaimed anonymous and shmem pages in compressed form
in memory, using the kernel's compressors and zsmalloc unchanged.
Reclaim replaces the PTE, or the shmem page-cache entry, with a
swap-like token that names a 16-byte slot. A fault on the token
decompresses the page and maps it again. No block device is needed. If
swap is configured, cold entries can be written back to it. The sysfs
interface is under /sys/kernel/mm/memcomp.

The implementation uses 16-byte slots, a separate owner domain for zero
pages, per-key storage and bounded metadata aging. Memory-cgroup
accounting, cold-page writeback, asynchronous compression, precise
residency reporting and mincore support are separate patches.

Refaults follow stock workingset accounting. The first reader claims
and clears the shadow under the slot lock. Feedback runs after
charging, outside the PTL and slot locks, before the page is read and
installed. Consumed feedback is not restored if the read or the
installation fails. An mTHP uses the shadow of its first base page and
clears the shadows of all its pages. Swapoff returns payloads to the
pool without building user pages.

Base and branches
=================

The 16 patches sit on Linux 6.12.23 plus eight prerequisite commits;
base-commit below names the top of that layer. The prerequisites make
the series work on 6.12 and are not part of the proposal. Those already
upstream drop out on a newer base. An android16-6.12 port carries 18
patches, the 16 here plus two ANDROID patches for vendor hooks and
gki_defconfig, on a nine-commit prerequisite layer.

  mainline: https://github.com/nakixii/linux/tree/memcomp/series-v1
  ACK:      https://github.com/nakixii/linux/tree/memcomp/android16-6.12
  whitepaper, benchmarks and results: https://github.com/nakixii/memcomp

Testing
=======

KUnit: 492 tests pass on x86, both with the classic LRU in a debug
configuration and with MGLRU. On arm64 ACK with MTE (HW_TAGS), 487 pass
and six are skipped as architecture-specific.

All 17 cases of an end-to-end test in KVM guests passed their checks.
The nine cases with swap ran every check; in the eight cases without
swap the checker stops early, so those results are partial.

These are retained results, not reruns. KUnit ran on the final test
candidate, before the sysfs directory was renamed and the matching
comments and documentation were updated. The end-to-end test ran on an
earlier implementation checkpoint, before later test additions and the
rename.

checkpatch --strict reports no errors and no checks, and 17 warnings:
six FILE_PATH_CHANGES notes for new files; one allocation that would
use kzalloc_obj(), which 6.12 does not have; one ENOSYS in a selftest
that compares a userspace errno; and nine BUG_ON warnings, eight on
assertions carried over from stock page_io.c and workingset.c code and
one on a shmem token reference. sparse was run on x86 with LLVM and
GCC; arm64 sparse and W=1 were not run.

Not covered by tests
====================

Hibernation, memory hot-remove, DAMON and khugepaged have had static
review only. The paths without an exact test include swapon unwind and
retry after a bitmap allocation failure, a genuine shmem charge failure
as distinct from an earlier allocation failure, zero-page refault
windows attributable to one operation, two concurrent readers of one
token, a pool return followed by its first consumption, and ordinary
reuse of the same swap offset. The error path for a failed pin of a
still-online source memory cgroup is defensive and was never reached at
runtime.

Questions for review
====================

- The source and patch layout: the implementation is one compilation
  unit with internal headers split by function.
- The multivalue sysfs ABI and the debug counters.
- Whether direct reclaim should skip folios with a high mapcount. A
  failed store can cost an unmap plus a reverse-map walk.
- The encoding uses one swap type and supports only 64-bit
  configurations, and memcomp cannot run together with zram or zswap.
- KUnit probes are kept in production code.

Results
=======

The comparison ran 965 fresh guest boots on real application pages,
under nested KVM on WSL2, with a paired rule fixed before collection.
Selected results:

  Without real swap, single-page refault p99 was 10.7 us against 20.7 us
  for zram with lz4, and 22.0 us against 27.3 us with zstd. Under
  512 MiB of anonymous pressure, refault p99 was 37% lower than zram
  with lz4 and 36% lower than zswap.
  Completed-switch p99 with zstd was 33-36% lower than zram in 10/10
  rounds and 20-22% lower than zswap in 9/10; these differences were
  smaller than the reference's variation between rounds.
  After writeback, readback p50 over an 832 MiB target was 11.9 us
  against 105.5 us for zswap and 114.0 us for zram writeback, with
  70-76% fewer bytes written before readback; p99 was about the same.

Less favorable:

  With real swap, single-page refault p99 was 4.8 times zram with lz4
  and about 1.5 times zram and zswap with zstd.
  Sequential refault was 30-31% slower than zswap, since there is no
  swap readahead. Single-page pageout p99 was 35-38% slower than zswap.
  In the pageout and refault workload, 64 MiB of real pages per
  application, memcomp used 5-8% more memory than zram; this leaves
  out zram's disksize-sized table, which was larger than the difference.

The measured kernels differ from this series only by the sysfs directory
rename and by seven removed header-comment lines. All decisions,
including undecided rows, are in the whitepaper. No phone results are
reported: the variables on a phone could not be controlled, so all
numbers come from KVM guests, and they do not establish device latency,
energy use or compatibility.

Tool use
========

Most of the code, the tests, the changelogs and this letter were
written with LLM coding assistants, working from my design decisions
and under my review over many iterations. I reviewed every patch and
take responsibility for it. The assistants also ran the builds, KUnit,
the KVM end-to-end test and the 965-boot comparison described above;
the test programs and raw results are in the GitHub repository.

nakixii (16):
  mm: userfaultfd: check the exclusivity of the page being moved
  mm: add a swap entry type for in-memory compressed pages
  mm: memcomp: compress reclaimed anonymous pages in memory
  mm: userfaultfd: let UFFDIO_MOVE move memcomp entries
  mm: memcomp: charge compressed pages to the source memcg
  mm: memcomp: store shmem and tmpfs pages
  mm: memcomp: write cold pages back to swap
  mm: memcomp: compress foreground batches asynchronously
  mm: memcomp: batch unmap reserved large folios
  mm: memcomp: queue restored large folios for splitting
  mm: memcomp: account user eviction and refault
  mm: memcomp: report precise token residency
  mm: memcomp: add KUnit tests
  selftests/mm: add a memcomp pageout and refault test
  mm: memcomp: add the design doc
  mm: memcomp: add the admin guide

 .../ABI/testing/sysfs-kernel-mm-memcomp       |  363 +
 .../admin-guide/kernel-parameters.txt         |   10 +
 Documentation/admin-guide/mm/index.rst        |    1 +
 Documentation/admin-guide/mm/memcomp.rst      |  149 +
 Documentation/mm/index.rst                    |    1 +
 Documentation/mm/memcomp.rst                  |  215 +
 MAINTAINERS                                   |   12 +
 fs/proc/task_mmu.c                            |   20 +
 include/linux/memcomp.h                       |  481 ++
 include/linux/memcontrol.h                    |   45 +
 include/linux/swap.h                          |   52 +-
 include/linux/swapops.h                       |   22 +
 mm/Kconfig                                    |   75 +
 mm/Makefile                                   |    1 +
 mm/hmm.c                                      |    3 +
 mm/huge_memory.c                              |   44 +
 mm/internal.h                                 |   84 +
 mm/madvise.c                                  |   10 +-
 mm/memcomp.c                                  | 6181 +++++++++++++++++
 mm/memcomp/access.h                           |  132 +
 mm/memcomp/anon_folio.h                       |   84 +
 mm/memcomp/anon_store.h                       |  268 +
 mm/memcomp/api.h                              |  205 +
 mm/memcomp/cache_folio.h                      |  103 +
 mm/memcomp/cache_store.h                      |   97 +
 mm/memcomp/consumers.h                        |  129 +
 mm/memcomp/defrag.h                           |  169 +
 mm/memcomp/drain.h                            |   83 +
 mm/memcomp/fault.h                            |  320 +
 mm/memcomp/fault_alloc.h                      |   23 +
 mm/memcomp/fifo.h                             |  136 +
 mm/memcomp/folio.h                            |  434 ++
 mm/memcomp/format.h                           |  308 +
 mm/memcomp/lifetime.h                         |   87 +
 mm/memcomp/load.h                             |   96 +
 mm/memcomp/migrate.h                          |  155 +
 mm/memcomp/mincore.h                          |   83 +
 mm/memcomp/owner.h                            |  157 +
 mm/memcomp/payload.h                          |  151 +
 mm/memcomp/query.h                            |  187 +
 mm/memcomp/refs.h                             |   83 +
 mm/memcomp/resident.h                         |  106 +
 mm/memcomp/scan.h                             |  115 +
 mm/memcomp/span.h                             |   89 +
 mm/memcomp/storage.h                          | 1131 +++
 mm/memcomp/swapoff.h                          |  190 +
 mm/memcomp/swapoff_walk.h                     |  122 +
 mm/memcomp/tests/.kunitconfig                 |   16 +
 mm/memcomp/tests/access_test.h                |  197 +
 mm/memcomp/tests/aging_test.h                 |  771 ++
 mm/memcomp/tests/anon_store_test.h            |  704 ++
 mm/memcomp/tests/async_test.h                 |  703 ++
 mm/memcomp/tests/budget_packed_test.h         |  435 ++
 mm/memcomp/tests/budget_swapped_test.h        |  292 +
 mm/memcomp/tests/budget_test.h                |  542 ++
 mm/memcomp/tests/cache_folio_test.h           |  627 ++
 mm/memcomp/tests/cache_reserve_test.h         |  447 ++
 mm/memcomp/tests/cache_store_test.h           |  216 +
 mm/memcomp/tests/cache_xarray_race_test.h     |  193 +
 mm/memcomp/tests/codec_scope_test.h           |   94 +
 mm/memcomp/tests/consumers_test.h             |  478 ++
 mm/memcomp/tests/core_test.h                  |  119 +
 mm/memcomp/tests/defrag_test.h                |  601 ++
 mm/memcomp/tests/drain_test.h                 |  581 ++
 mm/memcomp/tests/enospc_test.h                |  236 +
 mm/memcomp/tests/fault_alloc_test.h           |  119 +
 mm/memcomp/tests/fault_test.h                 |  851 +++
 mm/memcomp/tests/folio_test.h                 |  769 ++
 mm/memcomp/tests/format_test.h                |  520 ++
 mm/memcomp/tests/late_async_test.h            |  331 +
 mm/memcomp/tests/load_test.h                  |  133 +
 mm/memcomp/tests/migrate_test.h               |  795 +++
 mm/memcomp/tests/mincore_test.h               |  462 ++
 mm/memcomp/tests/owner_test.h                 |  400 ++
 mm/memcomp/tests/payload_test.h               |  220 +
 mm/memcomp/tests/public_api_test.h            |  422 ++
 mm/memcomp/tests/public_driver_test.h         |  358 +
 mm/memcomp/tests/query_test.h                 |  480 ++
 mm/memcomp/tests/refs_test.h                  |  224 +
 mm/memcomp/tests/replacement_test.h           |  360 +
 mm/memcomp/tests/resident_test.h              |  796 +++
 mm/memcomp/tests/rollback_test.h              |  163 +
 mm/memcomp/tests/scan_test.h                  |  422 ++
 mm/memcomp/tests/shared_test.h                | 3477 ++++++++++
 mm/memcomp/tests/shmem_retry_test.h           |  340 +
 mm/memcomp/tests/shmem_zero_fault_test.h      |  121 +
 mm/memcomp/tests/span_test.h                  |  128 +
 mm/memcomp/tests/storage_fixture.h            |   84 +
 mm/memcomp/tests/storage_test.h               |  468 ++
 mm/memcomp/tests/store_transaction_test.h     |  587 ++
 mm/memcomp/tests/suite.h                      |  693 ++
 mm/memcomp/tests/swapoff_test.h               |  558 ++
 mm/memcomp/tests/swapoff_walk_test.h          |  562 ++
 mm/memcomp/tests/swapoff_yield_test.h         |  532 ++
 mm/memcomp/tests/test_api.h                   |   41 +
 mm/memcomp/tests/transport_reclaim_test.h     |  298 +
 mm/memcomp/tests/transport_test.h             |  114 +
 mm/memcomp/tests/workingset_load_test.h       | 1095 +++
 mm/memcomp/tests/workingset_mthp_error_test.h |  164 +
 mm/memcomp/tests/workingset_storage_test.h    |  442 ++
 mm/memcomp/tests/workingset_store_test.h      |  572 ++
 mm/memcomp/tests/writeback_batch_test.h       |  688 ++
 mm/memcomp/tests/writeback_test.h             |  540 ++
 mm/memcomp/tests/zero_callers_test.h          |  717 ++
 mm/memcomp/tests/zero_carrier_test.h          |  405 ++
 mm/memcomp/tests/zero_convert_test.h          |  694 ++
 mm/memcomp/tests/zero_hint_test.h             |  860 +++
 mm/memcomp/tests/zero_load_test.h             |  645 ++
 mm/memcomp/tests/zero_test.h                  |  313 +
 mm/memcomp/workingset_load.h                  |   97 +
 mm/memcomp/workingset_store.h                 |   62 +
 mm/memcomp/writeback.h                        |  133 +
 mm/memcomp/writeback_batch.h                  |  398 ++
 mm/memcomp/zero.h                             |  205 +
 mm/memcomp/zero_convert.h                     |   78 +
 mm/memcomp/zero_load.h                        |   91 +
 mm/memcomp_rmap.h                             |  139 +
 mm/memcontrol.c                               |   99 +
 mm/memory.c                                   |   42 +-
 mm/migrate.c                                  |   11 +-
 mm/mincore.c                                  |  125 +-
 mm/page_io.c                                  |   42 +
 mm/rmap.c                                     |   41 +-
 mm/shmem.c                                    |  251 +
 mm/swap.h                                     |    4 +
 mm/swap_state.c                               |    5 +
 mm/swapfile.c                                 |   49 +
 mm/userfaultfd.c                              |   94 +-
 mm/vmscan.c                                   |  651 +-
 mm/workingset.c                               |   32 +
 tools/testing/selftests/mm/Makefile           |    9 +-
 tools/testing/selftests/mm/config             |   11 +
 tools/testing/selftests/mm/hmm-tests.c        |  112 +
 tools/testing/selftests/mm/memcomp.c          |  831 +++
 134 files changed, 46825 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-mm-memcomp
 create mode 100644 Documentation/admin-guide/mm/memcomp.rst
 create mode 100644 Documentation/mm/memcomp.rst
 create mode 100644 include/linux/memcomp.h
 create mode 100644 mm/memcomp.c
 create mode 100644 mm/memcomp/access.h
 create mode 100644 mm/memcomp/anon_folio.h
 create mode 100644 mm/memcomp/anon_store.h
 create mode 100644 mm/memcomp/api.h
 create mode 100644 mm/memcomp/cache_folio.h
 create mode 100644 mm/memcomp/cache_store.h
 create mode 100644 mm/memcomp/consumers.h
 create mode 100644 mm/memcomp/defrag.h
 create mode 100644 mm/memcomp/drain.h
 create mode 100644 mm/memcomp/fault.h
 create mode 100644 mm/memcomp/fault_alloc.h
 create mode 100644 mm/memcomp/fifo.h
 create mode 100644 mm/memcomp/folio.h
 create mode 100644 mm/memcomp/format.h
 create mode 100644 mm/memcomp/lifetime.h
 create mode 100644 mm/memcomp/load.h
 create mode 100644 mm/memcomp/migrate.h
 create mode 100644 mm/memcomp/mincore.h
 create mode 100644 mm/memcomp/owner.h
 create mode 100644 mm/memcomp/payload.h
 create mode 100644 mm/memcomp/query.h
 create mode 100644 mm/memcomp/refs.h
 create mode 100644 mm/memcomp/resident.h
 create mode 100644 mm/memcomp/scan.h
 create mode 100644 mm/memcomp/span.h
 create mode 100644 mm/memcomp/storage.h
 create mode 100644 mm/memcomp/swapoff.h
 create mode 100644 mm/memcomp/swapoff_walk.h
 create mode 100644 mm/memcomp/tests/.kunitconfig
 create mode 100644 mm/memcomp/tests/access_test.h
 create mode 100644 mm/memcomp/tests/aging_test.h
 create mode 100644 mm/memcomp/tests/anon_store_test.h
 create mode 100644 mm/memcomp/tests/async_test.h
 create mode 100644 mm/memcomp/tests/budget_packed_test.h
 create mode 100644 mm/memcomp/tests/budget_swapped_test.h
 create mode 100644 mm/memcomp/tests/budget_test.h
 create mode 100644 mm/memcomp/tests/cache_folio_test.h
 create mode 100644 mm/memcomp/tests/cache_reserve_test.h
 create mode 100644 mm/memcomp/tests/cache_store_test.h
 create mode 100644 mm/memcomp/tests/cache_xarray_race_test.h
 create mode 100644 mm/memcomp/tests/codec_scope_test.h
 create mode 100644 mm/memcomp/tests/consumers_test.h
 create mode 100644 mm/memcomp/tests/core_test.h
 create mode 100644 mm/memcomp/tests/defrag_test.h
 create mode 100644 mm/memcomp/tests/drain_test.h
 create mode 100644 mm/memcomp/tests/enospc_test.h
 create mode 100644 mm/memcomp/tests/fault_alloc_test.h
 create mode 100644 mm/memcomp/tests/fault_test.h
 create mode 100644 mm/memcomp/tests/folio_test.h
 create mode 100644 mm/memcomp/tests/format_test.h
 create mode 100644 mm/memcomp/tests/late_async_test.h
 create mode 100644 mm/memcomp/tests/load_test.h
 create mode 100644 mm/memcomp/tests/migrate_test.h
 create mode 100644 mm/memcomp/tests/mincore_test.h
 create mode 100644 mm/memcomp/tests/owner_test.h
 create mode 100644 mm/memcomp/tests/payload_test.h
 create mode 100644 mm/memcomp/tests/public_api_test.h
 create mode 100644 mm/memcomp/tests/public_driver_test.h
 create mode 100644 mm/memcomp/tests/query_test.h
 create mode 100644 mm/memcomp/tests/refs_test.h
 create mode 100644 mm/memcomp/tests/replacement_test.h
 create mode 100644 mm/memcomp/tests/resident_test.h
 create mode 100644 mm/memcomp/tests/rollback_test.h
 create mode 100644 mm/memcomp/tests/scan_test.h
 create mode 100644 mm/memcomp/tests/shared_test.h
 create mode 100644 mm/memcomp/tests/shmem_retry_test.h
 create mode 100644 mm/memcomp/tests/shmem_zero_fault_test.h
 create mode 100644 mm/memcomp/tests/span_test.h
 create mode 100644 mm/memcomp/tests/storage_fixture.h
 create mode 100644 mm/memcomp/tests/storage_test.h
 create mode 100644 mm/memcomp/tests/store_transaction_test.h
 create mode 100644 mm/memcomp/tests/suite.h
 create mode 100644 mm/memcomp/tests/swapoff_test.h
 create mode 100644 mm/memcomp/tests/swapoff_walk_test.h
 create mode 100644 mm/memcomp/tests/swapoff_yield_test.h
 create mode 100644 mm/memcomp/tests/test_api.h
 create mode 100644 mm/memcomp/tests/transport_reclaim_test.h
 create mode 100644 mm/memcomp/tests/transport_test.h
 create mode 100644 mm/memcomp/tests/workingset_load_test.h
 create mode 100644 mm/memcomp/tests/workingset_mthp_error_test.h
 create mode 100644 mm/memcomp/tests/workingset_storage_test.h
 create mode 100644 mm/memcomp/tests/workingset_store_test.h
 create mode 100644 mm/memcomp/tests/writeback_batch_test.h
 create mode 100644 mm/memcomp/tests/writeback_test.h
 create mode 100644 mm/memcomp/tests/zero_callers_test.h
 create mode 100644 mm/memcomp/tests/zero_carrier_test.h
 create mode 100644 mm/memcomp/tests/zero_convert_test.h
 create mode 100644 mm/memcomp/tests/zero_hint_test.h
 create mode 100644 mm/memcomp/tests/zero_load_test.h
 create mode 100644 mm/memcomp/tests/zero_test.h
 create mode 100644 mm/memcomp/workingset_load.h
 create mode 100644 mm/memcomp/workingset_store.h
 create mode 100644 mm/memcomp/writeback.h
 create mode 100644 mm/memcomp/writeback_batch.h
 create mode 100644 mm/memcomp/zero.h
 create mode 100644 mm/memcomp/zero_convert.h
 create mode 100644 mm/memcomp/zero_load.h
 create mode 100644 mm/memcomp_rmap.h
 create mode 100644 tools/testing/selftests/mm/memcomp.c


base-commit: e728da875eb1d50add12357d01f44a3edf9a6f8c

