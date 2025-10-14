Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C634ACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8F68E0138; Tue, 14 Oct 2025 10:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079718E010A; Tue, 14 Oct 2025 10:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB438E0138; Tue, 14 Oct 2025 10:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5AC58E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:50:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EDB94754C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:15 +0000 (UTC)
X-FDA: 83997005190.15.DACA43C
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id BCE4F4000C
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E9XwP44A;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760453413; a=rsa-sha256;
	cv=none;
	b=Zx8SOXUJYvnvcNgGGhPmv4U5WadblVOf/gdLN4+wsgNxhFqJlG/a3je4t26uXrFOeDs2jL
	e3q+lZhsdQ5QHV77uJHo5+VS+SGDuG3LnK9OxEOB0+KPYVeYtjRZYFPJmuMaegHjBGiOU5
	RO4oePR1CpfZataYHSW2Lc9ToAOxPaw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E9XwP44A;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AhiUCIRsJh9/X6gFFF6AAeo3W+sNR4EDIfl/mL10GSE=;
	b=6X/kaz5Xkzg+ePDppQiVr7rjLkd8rZ9JLHQ3jR6c9teYnQ4Tybz3BycAFbXxGnIfNJaAI/
	zmCyQJZbuNxFRZZeca9+wV2yO2YoapJDdu9VE6ubJBgmFLs7sRY4lkoMU5AcL2xIPDJMjB
	MTjEEBAtLVdIVU9fekFXKBOO+mxEg7k=
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-635355713d9so5236973d50.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760453413; x=1761058213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AhiUCIRsJh9/X6gFFF6AAeo3W+sNR4EDIfl/mL10GSE=;
        b=E9XwP44AgalejDL6k4MwlRhSmfM8buAx8MoV+bJ0mtT7kFMBEJjuQm+GuJ+6rsH5C8
         UN23Pstc0wQ/rKhgKinasMRId/cJInOP0nT2miF/pXAbHsrXi1ZBtC94628wdKBKXa+f
         3gMRAQtqTNnrY5rkORx6pCCSddcUbPjQIN+bKnn2Yd4yDglTigzUGvbyJXxFneaNME8J
         B1Ah6D82Q7sbfESMlyAOHZAzP6yTVG/dK1/Ze8bMtYjnHrQVr2LVcXE2ilf/Sbr2d2dE
         7CnJfQSyeA7u2ZLtHHeviAAtJmi67yJQJ685KzhqrTCSEOyDISWGxxHZBjw5rJU8izqY
         PaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760453413; x=1761058213;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AhiUCIRsJh9/X6gFFF6AAeo3W+sNR4EDIfl/mL10GSE=;
        b=gXt50T3kBgWvSKTC5kcYrt9S1qozFlHpqBrNNumJ7uRalDne9TiLqZSDfUBK8/h99A
         uiZVFDU22SVygA1hM8cpJmXNXjSznZHGmWFVIdIEUPSJnvQbvlOk8qrPGEU0uQS7otcT
         2ZSklKnzaUYe36BPufAV00FeTYTbgzzRj6WPTCkAjWAdAtysVOeyc1g4wXo3933bgVQ7
         razj5Aw/AwLVJ13Kgcnx6TMY0AGY2lElj/5hH5JiXu8fCIVxiXRZDZLRwiZiAJcXVb2x
         M5dvBd1EF0CROwD5hxBc/RhZmdV31V2eRyLfJXC+ud9M6HkZbuSGWirvAutYycFu653g
         QPYg==
X-Forwarded-Encrypted: i=1; AJvYcCUjec41XdJuJLmjA2oJsrwljhb/uvO6ZGrc6s450tBuy/4GLol+oRgC+3wA1wdD9iSt5OMFq1cRyA==@kvack.org
X-Gm-Message-State: AOJu0Yy3FTSFBNetaTIxm1dPsAX4SW4//KBsHBOB8p7YBsRL1rP6D7QG
	CZ+oLOl8kycZWelXI1EKn7KWVsv/DU8549BAZcK20Jib04hjwho7p246
X-Gm-Gg: ASbGncsGSS/NhqmPiTdcEgTRKtH3yxmH2yZKSu2P7AbpsHaiTGnq0PLUFdCSN9hbDeH
	3pzHnneLfp0IRiEaaNfbGbKCrKAFywWQJwLPB20AL8uEQp5YoLss4LyQYDQsrddP+iPgDcnzE9d
	LxUragWIRTnzqm4bdnSrXlMaDyEUn0Nt5YBpaFqj7FECFU8pE3nAxxxk224rNzCSCzOtwbRCrI7
	Dp6PvL8bUv/HKGrBT09I1XBNKWmsjlqijtixC87cZWRzzzmZ8fl5GBUTYDBZLq3Ans2W7MGy+21
	1IBq2ZDibM9VonEwq4pzWb1fbcMQW+GI5g39yvL95vTkWmsXuBthdc5W3fcXYIZGXQ3i9BVOxFB
	glg+t4STW/k2I8ZE6jSFNE95Sc4G+7p3YQWnI1GKpTKTeBeN+lsY4hf8rg9awc5KJfRFLFTJGLO
	xb07VTIlRcboaDfkB3zw==
X-Google-Smtp-Source: AGHT+IFVB7X559i8Ow1TBdbFEuH19J9C6JBi6GTmKNR0KPidIxIOmo+0oh4Oa2lzmnmK9+xR9kM4RA==
X-Received: by 2002:a53:a081:0:b0:62a:b339:20d4 with SMTP id 956f58d0204a3-63ccb82412emr16372072d50.21.1760453412563;
        Tue, 14 Oct 2025 07:50:12 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:a::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63cd952e16fsm4812844d50.12.2025.10.14.07.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 07:50:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v5 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Date: Tue, 14 Oct 2025 07:50:07 -0700
Message-ID: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: yxyac5b3bkobgjaqrrhpfmygyfk3f1f6
X-Rspamd-Queue-Id: BCE4F4000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760453413-355734
X-HE-Meta: U2FsdGVkX19qgpXns9W0w8o+mIFG4oKjOfa2FN43Lf5ks/CopSmuFyfs9pfKAvMXM4PSj8fFMk8ml6E7b+t0Zv/voJNYbVtxaihVetpivjhy9UbKYecv6ElDnh4igh1aqSJE5vDNo6pAbNQgdHJ3xt4kRNyJYLe/rs0iFXARClAbVT5lOqJEYYgvGYCVcNN3CfztELyOraNh1nhgxOOcaKCjr2xAOgbheR0dXxHybzDCcHPD3y0J6E4TMBSkBjC3tP6GksSqXnv+L72xco910HOtMrBM/+qW2RR+xjjgEUbh38ZmC162lB1Yt0FrHGCBKoCXa2ZA3DmaX4Yz0vRPaDTIW45DwLjC+RTME3ykZuTbjh2fDhikcQv/6Yji1V2SdPv+u5lOFqIdyEJLYVVkJ998QvFB2tJVdur9oOX3G0HwvhKfNi3djeiSm78QWmbhW9fjxwDI7pCugLTJVMNZvZNbyzH7VNDzs5qqbXq9FIDtBCbfWIfOkxHFrbCQd5XXQ3SaHMVfFEHA3BJlrqEHbuFx79cbyrTdN66AxbSsCT/qNFsh34+FqzCLlpuTgDNEcjLBtp4sERm6H4+n5Ju7Siq5xYGuwjiON3SgGM8Xkzu++RnoJDwZvAzSXPJvuG8ZzuTAaaDG8QsngUgd7kYvMjR7tE/WrLGjmfSVhUJB8YUSMTeOG+e0OaRnTRtrxQJZbIR4JJszIfVm04Q49lIqOGnNwWrIZF9TD8k/TMTrKc7asoeXXKqHnanolJ2HvpuaaN1t2BjlmoRlOUVZNRm+8oyjTkCrzjvnX5UiD9Ktrj/zcqIvnKDaFI0hbKlsVuvII5A8tnddURQfVCrL1qWpAfIY6uHhPdHyY76e4DI3RboJWrscqBLKUigDROqysnzfj2gbchtF6oI13H0cPvOO/ieY7XfJDpu49TFmbqMBq1dpMxOF2gbRvdC7mdt5/f7KAkqQh6SjgyOQw1vzOXc
 0RSkRITk
 0lXGXhXoNviK12tiCRCFETh3/LsrTiTZr6k/9jFsJ3R0n52K91LrxQCg5Tmy/wDmGFrlLt+W2qbVkvLSn9MfmtUd1Ew7t/NMFdzgTrOtviFqG+o3qOtQAHde7M+9Hpf4HidNvZ3zFAjBhKH9ziilY09jI/Jzrg95l48nH9beBbR1ekqvAboqjmqFfD46F6+RdiulnbUQp86aVjntUmyVNW22s7rjlKSz2sEDxO+2WXA4EE4lM1lbbNDrmlh5OM9uYdpvvDdE8vCOotOk+Vg3zPgthQnWgzNnt3JK80cV2tTW6bfCuOWYz1ELUhWq9A9itVzV41ELpSZsJtzzSwHBb5aCgJnlpYQ7C6OAY4SHIR4VawM5Mvgfc4Oi8kSR/O2d2qlfDjL/jzYrxtcAjR5Z5eFfv77Lh7kQokIhavOpg+JgbgkpDFPJfXhzC876cgn8VHZmxXfcKyKOLNsyrRQrFAXRApFVcAQclR0jeP3pKT2HZRe33stvRo/c5HzdJ1GBwcnzHSZ5jxRIrlEVKKQD+LY9zICxez6U6aGGFX24eIYQnxH8x4yaI1GiOyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Motivation & Approach
=====================

While testing workloads with high sustained memory pressure on large machines
in the Meta fleet (1Tb memory, 316 CPUs), we saw an unexpectedly high number
of softlockups. Further investigation showed that the zone lock in
free_pcppages_bulk was being held for a long time, and was called to free
2k+ pages over 100 times just during boot.

This causes starvation in other processes for the zone lock, which can lead
to the system stalling as multiple threads cannot make progress without the
locks. We can see these issues manifesting as warnings:

[ 4512.591979] rcu: INFO: rcu_sched self-detected stall on CPU
[ 4512.604370] rcu:     20-....: (9312 ticks this GP) idle=a654/1/0x4000000000000000 softirq=309340/309344 fqs=5426
[ 4512.626401] rcu:              hardirqs   softirqs   csw/system
[ 4512.638793] rcu:      number:        0        145            0
[ 4512.651177] rcu:     cputime:       30      10410          174   ==> 10558(ms)
[ 4512.666657] rcu:     (t=21077 jiffies g=783665 q=1242213 ncpus=316)

While these warnings don't indicate a crash or a kernel panic, they do point
to the underlying issue of lock contention. To prevent starvation in both
locks, batch the freeing of pages using pcp->batch.

Because free_pcppages_bulk is called with the pcp lock and acquires the zone
lock, relinquishing and reacquiring the locks are only effective when both of
them are broken together (unless the system was built with queued spinlocks).
Thus, instead of modifying free_pcppages_bulk to break both locks, batch the
freeing from its callers instead.

A similar fix has been implemented in the Meta fleet, and we have seen
significantly less softlockups.

Testing
=======
The following are a few synthetic benchmarks, made on three machines. The
first is a large machine with 754GiB memory and 316 processors.
The second is a relatively smaller machine with 251GiB memory and 176
processors. The third and final is the smallest of the three, which has 62GiB
memory and 36 processors.

On all machines, I kick off a kernel build with -j$(nproc).
Negative delta is better (faster compilation).

Large machine (754GiB memory, 316 processors)
make -j$(nproc)
+------------+---------------+-----------+
| Metric (s) | Variation (%) | Delta(%)  |
+------------+---------------+-----------+
| real       |        0.8070 |  - 1.4865 |
| user       |        0.2823 |  + 0.4081 |
| sys        |        5.0267 |  -11.8737 |
+------------+---------------+-----------+

Medium machine (251GiB memory, 176 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.2806 |  +0.0351 |
| user       |        0.0994 |  +0.3170 |
| sys        |        0.6229 |  -0.6277 |
+------------+---------------+----------+

Small machine (62GiB memory, 36 processors)
make -j$(nproc)
+------------+---------------+----------+
| Metric (s) | Variation (%) | Delta(%) |
+------------+---------------+----------+
| real       |        0.1503 |  -2.6585 |
| user       |        0.0431 |  -2.2984 |
| sys        |        0.1870 |  -3.2013 |
+------------+---------------+----------+

Here, variation is the coefficient of variation, i.e. standard deviation / mean.

Based on these results, it seems like there are varying degrees to how much
lock contention this reduces. For the largest and smallest machines that I ran
the tests on, it seems like there is quite some significant reduction. There
is also some performance increases visible from userspace.

Interestingly, the performance gains don't scale with the size of the machine,
but rather there seems to be a dip in the gain there is for the medium-sized
machine. One possible theory is that because the high watermark depends on
both memory and the number of local CPUs, what impacts zone contention the
most is not these individual values, but rather the ratio of mem:processors.

Changelog
=========
v4 --> v5:
- Wordsmithing
- Patches 1/3 and 2/3 were left untouched.
- Patch 3/3 no longer checks for the to_free == 0 case. It also now checks
  for pcp->count > 0 as the condition inside the while loop, and the early
  break checks for the opposite condition. Note that both to_free and
  pcp->count can become negative due to high-order pages that are freed, so
  we must check for (to_free <= 0 || pcp->count <= 0), instead of just
  checking for == 0.
- Testing results were left unchanged, since the new iterations did not lead
  to any noticable differences in the results.

v3 --> v4:
- Patches 1/3 and 2/3 were left untouched, other than adding review tags
  and a small clairification in 2/3 to note impact on the zone lock.
- Patch 3/3 now uses a while loop, instead of a confusing goto statement.
- Patch 3/3 now checks ZONE_BELOW_HIGH once at the end of the function, and
  high is calculated just once as well, before the while loop. Both suggestions
  were made by Vlastimil Babka, to improve readability and to stick more closely
  to the original scope of the function.
- It turns out that omitting the repeated zone flag check and high calculation
  leads to a performance increase for all machine types.
  The cover letter includes the most recent test results.
- I've also included the test results in patch 3/3, so that the numbers are
  there and can be referenced in the commit log in the future as well.

v2 --> v3:
- Refactored on top of mm-new
- Wordsmithing the cover letter & commit messages to clarify which lock
  is contended, as suggested by Hillf Danton.
- Ran new tests for the cover letter, instead of running stress-ng, I decided
  to compile the kernel which I think will be more reflective of the "default"
  workload that might be run. Also ran on a smaller machines to show the
  expected behavior of this patchset when there is lock contention vs.
  lower lock contention.
- Removed patch 2/4, which would have batched page freeing for
  drain_pages_zone. It is not a good candidate for this series since it is
  called on each CPU in __drain_all_pages.
- Small change in 1/4 to initialize todo, as suggested by Christoph Lameter
- Small change in 1/4 to avoid bit manipulation, as suggested by SeongJae Park.
- Change in 4/4 to handle the case when the thread gets migrated to a different
  CPU during the window between unlocking & reacquiring the pcp lock, as
  suggested by Vlastimil Babka.
- Small change in 4/4 to handle the case when pcp lock could not be acquired
  within the loop in free_unref_folios.

v1 --> v2:
- Reworded cover letter to be more explicit about what kinds of issues
  running processes might face as a result of the existing lock starvation
- Reworded cover letter to be in sections to make it easier to read
- Fixed patch 4/4 to properly store & restore UP flags.
- Re-ran tests, updated the testing results and interpretation

Joshua Hahn (3):
  mm/page_alloc/vmstat: Simplify refresh_cpu_vm_stats change detection
  mm/page_alloc: Batch page freeing in decay_pcp_high
  mm/page_alloc: Batch page freeing in free_frozen_page_commit

 include/linux/gfp.h |  2 +-
 mm/page_alloc.c     | 82 ++++++++++++++++++++++++++++++++++++---------
 mm/vmstat.c         | 28 +++++++++-------
 3 files changed, 82 insertions(+), 30 deletions(-)


base-commit: 53e573001f2b5168f9b65d2b79e9563a3b479c17
-- 
2.47.3

