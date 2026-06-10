Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7757DCD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26AD6B0095; Tue,  9 Jun 2026 20:13:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE236B0096; Tue,  9 Jun 2026 20:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93FE16B0098; Tue,  9 Jun 2026 20:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 824CF6B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17B251A07F7
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:12 +0000 (UTC)
X-FDA: 84862078224.15.C697076
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 653D8C0004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q5N+rjgU;
	spf=pass (imf22.hostedemail.com: domain of 3FKwoag0KCGcFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3FKwoag0KCGcFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050390;
	b=kYn52LjwpzdKcr9Hv2vp/hH/czRV6fhBvCLAHoykH7Cb13EI/4CtsoPv1sqxOdCYiTmKmy
	8qIUoaV/h2Ai+O3yLr25X11dpP51he0biOPZUNzOZere/ppx3aZsL24XlNcP9fzgUH94RO
	KIDn8/Uk3THUH3D8paPZRKENnZqU/9k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=q5N+rjgU;
	spf=pass (imf22.hostedemail.com: domain of 3FKwoag0KCGcFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3FKwoag0KCGcFGMNXMJPGFUFYLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+KurXsmQkrjxNctSa6vetDbe6+yRllRZmR+Fu8BSvHE=;
	b=NwK43tEnwb6sssyLPMjR2IAnhiXF3WeKe7IbqhEYZBB6brXK9kDwZjCVL5GvrusZmp/tu8
	QUOViy/T0siYEcSL4IBWwW2qLtb6KmQNGtKJE/mzX2I0i6T7KU8PxUOLG5dM+B5V+p6WFI
	SM27b2Hppl/bq78voJddN3d6UedxQm0=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-304ee7d1368so6082482eec.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050389; x=1781655189; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+KurXsmQkrjxNctSa6vetDbe6+yRllRZmR+Fu8BSvHE=;
        b=q5N+rjgUA/xTKUtHpLTLbwQd1keJRHAsr99Qco7e/LKZHNPSSG1khdQGb3ijQi0q55
         u1oxtPpe3LQgT/nFrM/1R9Q12LPq+KhVVCIdrXE07jTRWJcLwXl0cXh2Ry0OMXtIZUN2
         MfyD0SoLG02XPARQRdW2ZPg0W3ljqTgX2d1vjsDuLr1c+mfP3mgpE69H0DfNne7M/jFT
         lvRW5TTLGeOSYDiB/jCtuTGAxJFsBo8Tyzy3nC1mgfEa/ocej8bHV3TIcnWKRoyLyana
         hwTAcSQAKhZEjVEM1Yf/JV911SKQL86tGhsOt6DIVWr2w9iF1U3zcmJbJNoIC5mvSiHn
         eppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050389; x=1781655189;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+KurXsmQkrjxNctSa6vetDbe6+yRllRZmR+Fu8BSvHE=;
        b=CaScTCYIqWN9nW2alrZ+ky9RhT+sHEQ6UIkJAb2W9zXN/rnd/AWzNmjR9IpKQQjtrR
         0/HI+VCb1Idwtjw2n+kLzQ53cl/P7/p0tVHkpyzOPbqfG2SnVODQ5I6mkPE1aje0QOB5
         12lwCKJ1xXUJOY1ykkx+jGmGsRRfpPY+pDx0dWxgDMSMIT+8Xqgzoo5/udX2q725P7An
         XNssqw9jVD/ZsV33v5uuhf0L+UjJlLMlN7KK1PuZ3pH8ptNlL3o7Dfl/uRlNHvPhtp0W
         FYjlBr/yMFIsR6L3Pe4OUhekYOoJSN3tewsndfuKrGn29eiNM8wzJt2F+ssFWr1n3XrI
         zkcA==
X-Forwarded-Encrypted: i=1; AFNElJ+1FArVz3J37dPQRpn3KTnIrZU5Mkw8FEyj31Wvojm/qLPhhrZJyjZ1uaG935CLBBRfCVQvGim8og==@kvack.org
X-Gm-Message-State: AOJu0Yy2R7wLD5inR0pk3VKpbBexnFSEWRAPq02yphMOhsiKXMGbhoVN
	2+XL2CQtaeOTx7coIkCCx02Vm9/ePp8TZdeTk1Lh26o8XhE/YPAY/9F1IqcS8MhVBFRDZUEXuNr
	aoflL2UbFLQYTEQfoOPHWWJcZI8dEg/VfbQ==
X-Received: from dyej22.prod.google.com ([2002:a05:7300:3256:b0:304:cffc:fdf7])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:5f14:b0:304:4f23:542d with SMTP id 5a478bee46e88-3077aef8be4mr14537902eec.11.1781050388874;
 Tue, 09 Jun 2026 17:13:08 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:53 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <cover.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 653D8C0004
X-Rspam-User: 
X-Stat-Signature: cqn9bhxfnzwucn3g37uuxkjefnpmdh14
X-HE-Tag: 1781050390-484947
X-HE-Meta: U2FsdGVkX19cDId3NLjS5hCUIZYb5wo4v+ul6iB+RJEq62si96vQrTZK1acQp4+Rs0c080Fn/EDppba1jj7VYMs2nPAb4px6zsyMNbJhnr4O+pc+3XJeK5HHlTmnTg/Yu2OY75MUw3lBRt4kPgmw6o7GWFoG3PXdw7LkkxG0y1hrbAMXtE0gLfC0Xn2rV1EJnLDQR6GsdazTgsYYswaPVk6X8T0XUE5EFgPa3bXw8Y0HsNSjYPKRaQpxw54gQ5jwGzZz9ppU0gPGIybiACz11wHG+2CKBc9D0FhJ59RsoNVylY7I7IleeLeXbL/nO0778FV1y+8e/3QgaXLomdCzctQU6Ez/DFD9akquSr2Ltv07+dX5bZs7aHC9n/LjYhw2t+3wG6oJ2WsXCdZP2ZK4to6rwymaKbBUG8cNavlImwjbN9hsGFeLF9Xn/0mEZM8wtI3Jt6uRcZzrTRDovvoOtodSPaLHKdFYPvAem6KITy29W9lFg3YNGhpS9MwirM1ueCb9Awh6ozaNMzNGW1tnJ+hQQu9gA76IzJEquqkiFajqgMA52RwhQOwiI8Px15U6Hud3VBTbUo3Hgf2WKtxYYORPEswJAesvmflufY60WdGjsxEcnpnu/9JRl2f0zQhYP1IALiiS7+kgnfezHuVKCHp3d1/OQQeAiIW0pyuhmh+qnZdKNODPcWdbTXfwvzHLLXLQANlE9JXomfzUGqIOGnHx3FXzTq8lTzk7Mo9q8S52345/YRgwpW+bNmtekoM769cN6UDWR2q8YVpUw3ai5eUfUChvIVkdY80VzyuGME9Hc1I7PyRncDV+JY6z4dyrNY+99+bFv9XF1uQfu/lnp0B7rfkblXwIGQTf8ndbMOp9wYsqFVg9+uPQCm2+S/rKTHUcQCFPY/VEuTR3C/pNbfBj34i+xJojHm4EWBuz/SOJBCw3CILDgdU61cjB6fI8gmjhY5C7/kAgRuK8Hvp
 7k4yjKZC
 ZpBNB8H5h86tXwaI90o5XRYP45CeP1ic1kuHcmaswnW8tVZplZDsiuJJJdWFQuf2HaquBd0WuNrUyLlieiNId/9SQ702Fls4WhI3rEcl9buNNYHbTYDdUajSpbqUPc3OjSuEkB+RPM4ufDbqBUFK1IYuVpYHpVi8nmF3+jXVLRkZPHEBLzyELfDi+qiBVKqWLcpuCM34O9ef+qregFfDd2+RBL1CDH+iKM3Ee3chrDP6DwbHv45XikSWjtxucytGBgk2Mt9/oPWFF+Xw/kmucP/G8ZOqSRTyA/sxFbyc/dFAgjcaW6SxQSdh1kqutNn/1j84k3aErzOeWDPMf7CGnHvqZxN3iWVrjV1xAgzd+D7GRCnYeGHSQEbPxLTnJi097yNBJKcVY0S9mRS3dtAmPqA+9urUWnRd2guinVlOZ6wjDz4Zj4fq+ufhCcLKC/fqWSzxFYS3S4MJyPeHS+/7AnAPhyM1eTm2MbFq8NO3q4QdIJxvQ4vq1wb7Au1dppLt4V6Ms7XyXIu1JgiVrm86v/7uxTdz8Ld2ICMMlSVTEWaS3kjlvwAAlmPocZxFsrKxTHvS9to2oHKQU3iCH2kS8GCPD3U2Vv4yi6jv0MfKTr31P2wmPCTUl2IqA3CRPDGucbw+I732VqgqwAH9/Jac+MOtCbw==
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
 include/uapi/linux/alloc_tag.h                |  94 +++
 lib/alloc_tag.c                               | 341 ++++++++++-
 lib/codetag.c                                 |  18 +
 tools/testing/selftests/alloc_tag/Makefile    |   9 +
 .../alloc_tag/allocinfo_ioctl_test.c          | 535 ++++++++++++++++++
 9 files changed, 1006 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/alloc_tag.h
 create mode 100644 tools/testing/selftests/alloc_tag/Makefile
 create mode 100644 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c

-- 
2.54.0.1099.g489fc7bff1-goog


