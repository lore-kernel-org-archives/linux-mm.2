Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CBEC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465AF6B00B1; Mon,  6 Jul 2026 14:25:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416F46B00B3; Mon,  6 Jul 2026 14:25:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308CF6B00B4; Mon,  6 Jul 2026 14:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F28046B00B1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:25:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 747CA1C728F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:57 +0000 (UTC)
X-FDA: 84959180754.03.016821E
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id D3BB51C0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cdNahas1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MvNLag0KCKEBCIJTIFLCBQBUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abhishekbapat.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MvNLag0KCKEBCIJTIFLCBQBUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qc2L6Kdu/a/xe4gb6oPGtuJlo6tOjRnEmbZIgntO/B0=;
	b=6Azymjeb8naFUk0cwfR8hfCOLS7GltMQdRiixSy1H6Mq60d0wC1PkBlYJNLtyeZyps+5YO
	VJ/Qp7TgR8rL5QTriT2DDY6fbwna0WuJod2feOYhZDOZsIqIaY3PEKtCPfQjnf7UZluZN1
	SjEYwGOovtAtG4i8CzBsTjb5EtX59cs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cdNahas1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3MvNLag0KCKEBCIJTIFLCBQBUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abhishekbapat.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3MvNLag0KCKEBCIJTIFLCBQBUHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362355;
	b=AGecU1Kr+X+Mt1eawOQPl0cwYgOZNNizUvMRqJXYt2l3NYbjQJhATQFfPp1q18Vn5W+q/v
	pcECIin156hJ3VRd3NAgu5lG1RgGNVpSBjH+QhCyRK5zaVInFHkbm6IvnlJtKsIfDYXlJP
	siSZK+auvfCZh1EQtn6/In6radU9u8w=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-380fe2a3fc7so3061812a91.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362355; x=1783967155; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qc2L6Kdu/a/xe4gb6oPGtuJlo6tOjRnEmbZIgntO/B0=;
        b=cdNahas14vCW+Eq4LomUENF5sC55l+InxqUygm8qsjpFhYAEAklRrk6iJEwUztf7FQ
         izlcFLk5feLI7qtdNLBYxF4nc1Wx3PAecvTNhEW2LbUpXQdoobZNZvtxHFYCAI+UeIgk
         k7BQwcSTldLX91DqBhOWEmoB0NhXHiQRicM/0EA5zN+VI51VfLvILlWJfVM5lngk6nB7
         yvuZkkzaalgYz/CrDJ7cawvmAvMIhbAYhUpjWAGcNnJsoioOaL8zUyfmaVUQIQJ+v8OV
         7F2GqHiEuAQyiqZs4FnneeExQMLL1mtbtptsytf+vJyJNcvP5q0r6Ih47P5SV/ZUwer1
         izZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362355; x=1783967155;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qc2L6Kdu/a/xe4gb6oPGtuJlo6tOjRnEmbZIgntO/B0=;
        b=q92ZD/xbBgDoX+3QSDme0eGDbNuKUPX+Pk00D2MZklr5q1Ipw11R+2sJFD01SYNunH
         uQ7gnPBX9hDNKjWOHchQ9V/kOsvmUAowAtoaQdY8nVtRuHmKc/uC3dsgZPpVE+1AV2iR
         0E1A5hSR0eB9gzAwKGSc7nOYs1o9jvxAmmaZHxvmaraNtcOZDviG7p1qqYWP/dM+fCl+
         JO0XoGmgyNTpSQWSj9s69U88C+pXJjvTLhmtHLnGTNt2E+qZdleLl3moiy2EoC+9uTak
         DycI53xN46HIMkleLHojfN3jMNLlaBycoyA+yKmUuuW90iBl93kAvM7yMxFoCKNzUH9q
         7gAw==
X-Forwarded-Encrypted: i=1; AHgh+RrscBScmauwDTtQuFQkRoLLY/aHNu6HTTtohrlSeq3W+N696SHCATtABo21a9V/rT7WpPMiXSLO0w==@kvack.org
X-Gm-Message-State: AOJu0YzoT6/hAgzz7vu8IOv4Hvu/0SVl8e8o/WvwsVJwhLigQbBVcRAx
	a6Tjv9fRDP0okQMlbqEZyllAVcKN7dJOVwKbdUIIScfyvEx2kB0JrKmELcyxnHpTbhNHFXfLFQ8
	HFYUjOD3Jh3XgTa4wpQXp2uWEOPUqMSWO3A==
X-Received: from dycop6.prod.google.com ([2002:a05:7301:9bc6:b0:30e:ee3a:f2f1])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:48c1:b0:37f:f4ae:5f25 with SMTP id 98e67ed59e1d1-38756ce281dmr1653545a91.20.1783362354324;
 Mon, 06 Jul 2026 11:25:54 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:43 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <cover.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D3BB51C0003
X-Stat-Signature: xpx4rnf5jyxhfhhn4fqiuo9t1s5aoryp
X-Rspam-User: 
X-HE-Tag: 1783362355-682809
X-HE-Meta: U2FsdGVkX19SADyv0PdJbmkrNGSPgfz+2tLdR2mxBGVsCgBgNzdwWM2mBQy0RPwtle6h+aOVWYQcBNhK5OC/KQgs2Ko/ncVZ2iQt7Q0tr/QzdJdZV6EliyGjgAPRNSEmhrkvamW/jMoNZTDCHlyLymyYnjtc3Ue+8e2FJ63ysZvMCvzABnZTNRGFaNjpJkWX+ICm6nA7GfZqH6q3GLZOXrtNkkLxe8Y1Fg607NzsZQlVGiVqaN5GTj6I8KpmccqdUCXL77ztJdCwj5HLNVAyrcz9QQzcjcq/QMkf3NFnPEdmD7uxmVB2lHR8UzZWM7eeg+HWlnp4g8PlHlHdtYTayU35mSh5UoBUzcooOfHj2Mr9LpdWIziY3kjAef7Clor4p37QiPUD3Sdag7L0rf1XrZ5FYiEi7oqJVx3CWJDDLNpv0s9t31MnLyy8AW5FujLiStXRdi80UZ7CAlHxbybf+N8XWcvvEtkZlnaSwEQnd81mJTul00OQHnZxrrwD2QvXqKbv0cElrXd9J8/rP7m86yT7mx/vwbvIidO/ckHXGZf0bYBUtuYfLqFmgEz0t73JAreZ9ECS7tZGGiSEF2X9DNVHtslN0lKB5/zR9x6yePqsEmu5KyUpz76tTn3qNERGfo/63whspyEGAPQ+K5mb8TP/24v9EcPgDpKr44zkZTHgtjv9mQj7dlOArch4RRKAgcmqvWsnTwm0/XlIoHRy7RLauelh9yNdpiydlC1MTJaME6nFTBPbJIMRtVCanKdH+3EgWtjvVLx16nS3v7ESTTRk4o6hjnOQWwVH6mdYGMOphUJ8mzA2IWLZrNzO+T3RoJQnkgBILka71/bO0+2Qgk0UdqoZgq7kh1VbRKXqWRFqNvDyg3vCDclEQUxnyk7NQGg9ha5sUA9O+RVtDz7bubwPA5q+EHZzzi03duHPTqRQ9h6/ImOlVYY5urW31YyO42QHcT1bi8yRnOVU6NM
 qMXAZHpi
 G9fPx17UOE92nyaOJkNB1rR29TmlAWz8c6eE8jpCVQLPXa7AsueETrVU8OjNTS1E586rdXAz8a134ix7TsNhyehSp9el6ihg7S5s8PiH+ZlIU5qlvi7dsEZbXMEkSVBWNHsCbJC8L4XcG1V51YbMib+c1hU4TKDDLDbGhJp31pGAsFcEBhGJsokm3qNlhAfTwR+xDjH4iwgPEpeOjURfeGPZUtSEczUpb3/EHkb3ZIBO9DrrgMfsuCiVngNqfM5e4eIeP8D910zLuoVWwOzqO6y+bNJK315yXU25hPhj7Tw9rWRTjINQa0rIS/xlihSWaysXF5Hh1tAFwKqzhnqSMk183pucSNOG6l6WZm8uFXuadKioGOsNxcWjPFPc99aaFiV4oWqhsXsRIVJhRZQO8uupGZYSmUHfPTiRdG/wsKK/1UPYUx1rrKa/RV3dEVARqEieYnb0X3dfDc33pFyqUCv9ouvuMVTYsIIctBQM8KL/TMKBFER7rx0IXL6dY78sVfuj0K3gpx0IihkHM0ML7BtCMhXDR5ttxyuVXZlDNWuVpC2dSy1iZlWMi6NJL0K5BgaBmiS/6hI1H02cjIRQWN7RotnWC+qLJCLxpoDjkgyvs8mO0/emygpyfSs/kYIYoT6WYGAsC3gp1V2QfFFo+u0w+m1Ojo+EJPiGaYwlFqIW7boz+HnSRv8UhNiCs7CC2mxG4
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

v7 changes:
- Patch 5/6: Used $KHDR_INCLUDES in the kselftest Makefile. Replaced
  goto statetments with break in get_filtered_ioctl_entries function.
- Patch 6/6: In test_size_filter, added a verification step to validate
  the size of the found tag matches target_size. In test_lineno_filter,
improved the comment, and verified that ioctl retrieves the original tag
that was used to record target_lineno.

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
 lib/codetag.c                                 |  18 +
 mm/alloc_tag.c                                | 344 ++++++++++-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 548 ++++++++++++++++++
 10 files changed, 1028 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.55.0.rc2.803.g1fd1e6609c-goog


