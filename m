Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026B1CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59D26B0088; Thu, 18 Jun 2026 13:36:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30C36B008A; Thu, 18 Jun 2026 13:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E956B008C; Thu, 18 Jun 2026 13:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 787C46B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAB431C3B08
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:41 +0000 (UTC)
X-FDA: 84893738202.17.290804E
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 336B2C000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CII9Ru7w;
	spf=pass (imf10.hostedemail.com: domain of 3piw0ag0KCCkFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3piw0ag0KCCkFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804200;
	b=sc03Mw1qoSAtZ2/FRdqyfyTWu0TYWFA4Hc5lo4h3GhmhNw1IGn7ZbKiA22K8WBPjjgncJG
	keRM3PsM6dldXdaqd6/wyfQEtO3zFVxW63/qbG34djAL7QAaSxRltr1b7RANgyYvLsNaE0
	EXpFseNBpBGddDcJ+pFO2F/piwYh4/o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CII9Ru7w;
	spf=pass (imf10.hostedemail.com: domain of 3piw0ag0KCCkFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3piw0ag0KCCkFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GILE6yJhHTICx0l2wbXC+MI6Lt47OxwBJrXXhpJgIEk=;
	b=tE3s2R3o6rvZEhJcsABk1YmG/UkQR24/hnc2S2Z/62AQxGw6VV4gj9xqDa2e4H6qThDzI+
	ZE1+y6tvd29Mn5hM9Epd+KjOHs3ZvTzJ6vBIm1ebUQTJNdumtUGPouBUHRBXIy0Oi+MOsb
	84o9OElToCFdlBWI0NL/wKz8Uyg8/6U=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-30bcb065bfdso2247331eec.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804199; x=1782408999; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GILE6yJhHTICx0l2wbXC+MI6Lt47OxwBJrXXhpJgIEk=;
        b=CII9Ru7wNEAbeY1cOFzFC5DxykhkESJ9QRt3A2OzGNz2vyrpKStbaxK56DqRylqtbr
         +BKHqdxosUPRzBPzHXblaKq6seOZElHbMcf6TkBOfIooGwtLbcfM0l+rfJR4IVpUj7Lc
         PKUhXvFWuYnrnYs75A/jWHC/Qox3y4EeF/aB2jimapDbQx6xpIHWtsZwQGZAeTjCZuWp
         y1/bHFgfgFOCDF0bghvFhnzxJk2xHCLdvowQx4UA9e2qS0F59P7rJ8GpjqwcTY5ji4fm
         uOkVRUdtdAmbwTvRnlIo53PRJthDM4JSv8StALKoWjPw2pcqAZxxm9M84Zj1809yOj7z
         aB5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804199; x=1782408999;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GILE6yJhHTICx0l2wbXC+MI6Lt47OxwBJrXXhpJgIEk=;
        b=q2mCrnUn5/yEhqV62In99esQMzwOiu3HUiYSeoH/zUV5zdu89jXw4kjwoUqCxR9Cqq
         xxAD63UzB+CG9TzBDWxSFOptYHNmsnFXuiD/3sQ0mHKbzxj6OO2L7wAv6BB+S5JXzdqm
         qIlCBPRYIZPkSxLtBjpSiS7f19d6P6qof/xLs5SpsC/OloaN+UbuQbi6dWL8TgK2XQll
         9b48dkr3uPby2DKoTRw/dKLBtJt5EERSWVhISBbjwiIm98vZG4iODA3FDGM+9bSxwRDc
         5JKe+JxQtAvLlAfO3I6WwQ3buRCMIWJe1dezaMSy+p3UtP/RWkNUMyDMggr+tCSozkod
         98Yg==
X-Forwarded-Encrypted: i=1; AFNElJ9CKH8F/bTPkW/ofHObUoH5vNUu1jpi6JF2LN0DkFuZuHSZU1eEFRZjZTBqi20WZJrnl4PGhOv2bg==@kvack.org
X-Gm-Message-State: AOJu0Yypkdhtvn+itt9hVpp+HoT0lrflRMwm1odHR438OGo4iqwNMo5t
	m9ovbIdHBbQzx/OeGdDSO7HKXbbT2sxVQXrkNOG9j7MgohtcFuKvdAWRGTm3Qjybqjc9s1GMAxF
	IqkMcHbb7SAYFcKQJJAh0yU6JCJyfRisEfA==
X-Received: from dykb40.prod.google.com ([2002:a05:7300:8428:b0:30b:f5a1:fe8e])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:3c8d:b0:30c:2d7:cabd with SMTP id 5a478bee46e88-30c070b3451mr141940eec.9.1781804198250;
 Thu, 18 Jun 2026 10:36:38 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:29 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <cover.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 336B2C000F
X-Stat-Signature: uq9jdx7h8hm7e8xhpzik1m6yoc8uiexb
X-HE-Tag: 1781804199-801302
X-HE-Meta: U2FsdGVkX18YXtoEwXMKokUO+ZivoLIPO+oYxP9FCrTA6RLp0J/vSRROibgVJWsFJn21NXDPaW5KjBMZyG11XvjwCs7GiRORyrFEo/UQbkhBMjJIe3hi+KBO7H/VenwoRITfCgEAe5ph3dU3rlJ2ZS3NfNSddC6C3j63VYWqDdk70S3q6QjspC4puc6DJjb63mtpH/iXEjtCybeOzC8jOSiPDWa6krHPc5Vvb2G5ikrh0w/Id/aOxL6tKTCiTGr52d6YnqCP9RdXwxUlUQ1owMNQzwJpjD73pVW4hUKCIcXaxdaHvkbQ8+YRuV3Hs9qMOp8JRN9JKb4XRzYTKFtCiF5RI3upiBT5Nio04r7R5yzl2AQFayJI4hP2ODiEHk9mzfib4IsfdgVZp7pqbJZTU2E+pDQgr8p9xMTloslF6VZbAAc1JitkmSxqFO0vcIsxKIvic6sHWv2B8H64kJoYfGz8FUDwBOU8SM7rxUsGPxo6SFBRd9cD6pQ5S7tSnKb91AYZH0L1dNbGLvAXkOSsiV4HRW0BDmbiY48i2fBMU8B6pwsU1otxp4bmq2I/4ty3sAcS40jeyqnZaw06dbiWCdbiHVzSJhFCavHu23tz9OUnnB9OfwCSECcKEzquFASCjNL7snc1ujnqR0ZnOYjJcVYj0WNtl4EJ90jhqvVDanGbYfA+ViExqJFX1p9YHzJUfBgsKwS4ZCzvnjk9j5zHTGDVOVoGhfInDsSJmj2txn3A1CL7bp7CKKZX2uTq9UUAyglatLEfY9z3nfwwKpGXBGDOwUxoa/xSOMvJnCj4OeIvVqCXhZ6BqmnHfCMDXxHFVrsBAV1/HFOkbmjTzAG6a7Rl3zKVyIvvYU25K11L/SVtaV7c7npGBa+H2P2foeiKM3uPynXS1iF7eM1tFy+Va0BZmmLc14kZ8jaRqFYzSYfrdLm/lKVyCU+7huqBdGMvvcUaU9imC36hVyXjo50
 F0AASxjW
 I1nrf3DJCl42JDUW8dkZOLuFDjljWTyBIgNZVb0oQKJyqY7Z3nqX/2PD4Q6TzCfF5ZNHs4h6cRDHDZufgYdAbvhfWtIHzASCU9OGHGFrtQcdmBLK2VX0dlZOHLJG5umBPx4/6RaGuW4W9jUP5FuJIXnCet/0pSPCKmkFj0E4z6rV3uwwZGAuxcUW3Ylnx5Xa+sU0VtSERdeVUI6UrUalQGdiWUXdV+MxyusrFCHsU3Lua6oLlZYgF5W9DPXHXw4cqfahvBjJuZDawKtDJp3yfB4mg2+/vqwrcI0kltb4D0ZSwDUlEklK0/Tk+Tg8XRFky8Uw6RjqkON9pYdQdEDtVOqt161z+Z9OgZhC7ucfur++F3jUGPA2ER2X/P9CasHXqTQDwW0P4k+Aq1tLUwMplhMhuvrWIpGByvMB6kN3cBnYE3ecQshkX3yci3KiKF89ZLOTYITXMv9FI84amQ2wne4crp51cKFDVzmMpPu+8FtrShMLQuQOQTLj0xmGc1gKUQvDq51smGUd+bcu8wWtPq+GMmf8dpefsxirjKklBxZ0BZBm2l1ReWoAxCV7EwOx9wGm9j8U/AoLbD98+NwhqEjyqr++rnlk1kLobAsuiymnAtpIfYvsbD5x+/SzrYScJfAxuz0Vun0XXj3NV6Oz1qMfrJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, memory allocation profiling data is primarily exposed through
/proc/allocinfo. While useful for manual inspection, this text-based
interface poses challenges for production monitoring and large-scale
analysis:

1. Userspace must parse large amounts of text to extract specific
fields.
2. To find specific tags, userspace must read the entire dataset,
requiring many context switches and high data copying.
3. The kernel currently aggregates per-CPU counters for every allocation
size, even those the user intends to filter out immediately.

This series introduces a new IOCTL-based binary interface for allocinfo
that supports kernel-side filtering. By allowing the user to specify a
filter mask, we significantly reduce the work performed in-kernel and
the amount of data transferred to userspace. The IOCTL mechanism was
chosen for allocinfo to address the per-CPU counter aggregation
bottleneck. A traditional read() operation must report the total
allocation count and sizes for every code tag in the system. Doing so
requires iterating across all CPUs to sum their per-CPU counters for
thousands of tags, which introduces substantial runtime overhead.

The IOCTL interface allows userspace to push selective filtering
criteria directly into the kernel before the per-CPU counter
aggregation. The kernel aggregates per-CPU counters only for a small
subset of tags that match the filter. This results in significant
performance improvement.

Beyond fast filtered retrieval, the IOCTL foundation allows introducing
a context capture mechanism in the future to capture the context for
specific allocations.

Performance measurements were conducted on an Intel Xeon Platinum 8481C
(224 CPUs) with caches dropped before each run.

The IOCTL mechanism shows a ~20x performance improvement for
filtered queries. The kernel avoids the expensive per-CPU counter
aggregation (alloc_tag_read) for any tags that fail the initial string
or location filters.

Scenario 1: Specific File Filtering (arch/x86/events/rapl.c)
1. Traditional (cat /proc/allocinfo | grep): 22ms (sys)
2. IOCTL Interface: 1ms (sys)

Scenario 2: Compound Filtering (Filename + Size)
1. Traditional: (cat ... | grep | awk): 21ms (sys)
2. IOCTL Interface: 1ms (sys)

Scenario 3: Size-Based Filtering (min_size = 1MB)
1. Traditional: (cat ... | awk): 21ms (sys)
2. IOCTL Interface: 14ms (sys)

v6 changes:
- Patch 1/6: Added comments explaining why last 64 characters are
  compared in the filter.
- Patch 3/6: Moved allocinfo_prefetch_counters outside of
  allocinfo_to_params
- Patch 5/6: Fixed fd leak in get_filtered_ioctl_entries() function.
  Added alloc_tag selftest to the top-level Makefile.
- Patch 6/6: Moved include for errno.h to this patch.

v5 changes:
- Patch 1/6: Added explicit mutex_destroy.
- Patch 5/6: Self-contained file descriptors to avoid wrap-around errors
  in retry loops.
- Patch 6/6: Fixed minor issues raised by sashiko in v4.

v4 changes:
- Patch 1/6: Fixed a copyright comment inside
  include/uapi/linux/alloc_tag.h
- Patch 3/6: Among other nits, fixed the inadvertent build failure
  introduced in v3.
- Patch 4/6: Included a comment stating that the accurate field in
  struct allocinfo_tag is only used for filtering.
- Patch 5/6: Modified test to trim prefix and keep suffix for entries
  with filenames exceeding the size limit.
- Patch 6/6: Modified test_size_filter such that if content_id changes
  between the moment when procfs and ioctl entries are read, both
entries are invalidated and re-fetched. Removed the tags->count == 0
check from test_lineno_filter as it's virtually unreachable.

v3 changes:
- Patch 1/6: Modified Documentation to indicate that map supports
  ioctl(). Modified struct allocinfo_count to use
__attribute__((aligned(8))) instead of manual padding. Removed
redundance type-casting. Added comments for static functions in
lib/alloc_tag.c. Introduced a new seq counter for content_id that gets
bumped every time module is loaded / unloaded. Introduced logic to
validate user specified position is not greater than number of
allocation tags and return early if it is. Changed strscpy to
strscpy_pad to not echo arbitrary user data back to the user.
- Patch 2/6: Handled the case where user wants to specifically filter
  for built-in modules. Included some comments for static functions.
- Patch 3/6: Modified logic to only fetch per-CPU counters for codetags
  that satisfy other filters. Included some comments for static
functions.

v2 changes:
- Patch 1/6: Introduced locking for m->private. Also included the new uapi
header file in MAINTAINERS list.
- Patch 2/6: Handled the case where ALLOCINFO_FILTER_MASK_MODNAME is
passed but ct->modname is NULL.
- Patch 3/6: Moved min_size and max_size outside of struct allocinfo_tag
into struct allocinfo_filter. Added validation that min_size <=
max_size. Prefetched alloc_tag_counters if size based filter masks are
provided to avoid assimilating per-cpu counters twice.
- Patch 5/6: Removed the hardcoded logic to skip the header, instead the
test will skip lines that don't match the format. Also included the
newly added alloc_tag selftests directory in MAINTAINERS list.

Abhishek Bapat (5):
  alloc_tag: add ioctl filters to /proc/allocinfo
  alloc_tag: add size-based filtering to ioctl
  alloc_tag: add accuracy based filtering to ioctl
  kselftest: alloc_tag: add kselftest for ioctl interface
  kselftest: alloc_tag: extend the allocinfo ioctl kselftest

Suren Baghdasaryan (1):
  alloc_tag: add ioctl to /proc/allocinfo

 Documentation/mm/allocation-profiling.rst     |   5 +
 .../userspace-api/ioctl/ioctl-number.rst      |   2 +
 MAINTAINERS                                   |   2 +
 include/linux/codetag.h                       |   2 +
 include/uapi/linux/alloc_tag.h                |  99 ++++
 lib/alloc_tag.c                               | 344 +++++++++++-
 lib/codetag.c                                 |  18 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 531 ++++++++++++++++++
 10 files changed, 1011 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.55.0.rc0.786.g65d90a0328-goog


