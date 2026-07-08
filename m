Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95505C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562386B0005; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBB46B008A; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2BD6B008C; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DC356B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82B4B8CC4A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:33 +0000 (UTC)
X-FDA: 84966376866.02.010EEB4
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf21.hostedemail.com (Postfix) with ESMTP id A49B31C0017
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ml/q3xCj";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3epBOag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3epBOag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=L3mTA0gYhkAgxZHcuO+pnWAJxLkZ8vbuRIM5XQ6i/IM=;
	b=45m1+o6loF4cJMx2AYX377p2gnOoKqGYZo7uH39/u67JMRqM97nvWVzo69DFXIpdyGwL2W
	DohhemsBW8VLyxdq/bHhO2LY2HT1otQTxPtvGPV7FrTdOQVVpx7SUj2lEjRGXtShdDWldA
	MFFJtFczXyUgUkypn+ErxSUnCefsDAY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Ml/q3xCj";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3epBOag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3epBOag0KCC8LMSTdSPVMLaLeRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533691;
	b=aXABrQt+X81C9xafJi2eHrInW4Pun+1nLBi1A4Ozz/QLaPIcJCg5jThMOsMBLUGfd7ggyC
	BC1Dpzc+BwJ1e6wqxVEmKvv1ICfqiP0Xkl1a43WYRbVSlS9giILp87ajDaaTuHOrbXjrn+
	oIK+Dt3LRC9Lowx7IkmQFWHW3ZIeWM8=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c894391f000so2150111a12.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533690; x=1784138490; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=L3mTA0gYhkAgxZHcuO+pnWAJxLkZ8vbuRIM5XQ6i/IM=;
        b=Ml/q3xCjoPibFbik9yRii80p9F04oMYm4GIqAiIbo4bGpNd584xWAtEXv6oWHLx+aA
         SgogueG75fgfiyXigCtfjGEc62wC4wmHhMg5HVOi1OMtgfrMrADkzWr+LUua8lAsgKUL
         a+HCHcWq3P1xt3emIwdhNoUk9qOssIop+IUGcq3hMfOlaflKx1bmnFmBY0Se29xB2NSM
         rIEpevuv3OlhjX1sosfFkJJIrr9by8PXoUOY7ZJ4UjP1dG/mAAWt+LMtMidO4D1C+11x
         jpjuVfbMFCMMx48R6wLCEvuQXI1sJtR9u8C4Hb7F6h9AUBlsTM102VlT6SLr+d9+m/LA
         6qlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533690; x=1784138490;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L3mTA0gYhkAgxZHcuO+pnWAJxLkZ8vbuRIM5XQ6i/IM=;
        b=eZr5R+Y164BAK882NPlAbYmbFXhbEb02tTBTDH1YU9cR1JcfGKZqPW73HGa9uvx8hY
         6pHQP+Nw0fKzwxChQjMOrmrY8jhIBFKVT4QL3grbRpZVwyFPNg50Kw8/hmGO8EwMe64T
         MZq+Xrhx5irm15/Nvx3NwMU3xWeMlg9cpFeQFCFJgMaMG229WkuH2UlRlI4NwC4rOBj4
         FgiCiOtUr/zzraCwRAgJQtMeuNsO8lkltwMZ3cYm6HkC/bdhzBReGLYV7adrHqsEqy5R
         PyfQm0+eoWf95bxGeCmD/4aFOB1Hl4O+em3sP1wiLFEMQRvGO5k957ujGYJWE1qtkjEe
         SpIw==
X-Forwarded-Encrypted: i=1; AHgh+RrB9og6F/76cRGeeBG4IU7bGzvSybbCMt5Cw+Oqhov1qg/mATReF2V62NWkrWoAtlDMh2bbfVgTJg==@kvack.org
X-Gm-Message-State: AOJu0Yynfg6TM3Cmo7kOVlVYuepRxuVaOvcRKFoHLRwOKZ1sjT57km6p
	46Wn+fFy6Lg7p1P68jmnNtwF9nAaxIrYu8w3i8uMGHAtgWri+Sapy9bhsYkn5N6IxzLRgtOcVjG
	n9mN5XbS1hGa8vbtZgMMGzhJz3NjqTwIiTQ==
X-Received: from dlbtp3.prod.google.com ([2002:a05:7022:3b83:b0:139:c6b6:f966])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6110:b0:3c0:b62a:2b89 with SMTP id adf61e73a8af0-3c0bd3137acmr4688169637.67.1783533690325;
 Wed, 08 Jul 2026 11:01:30 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <cover.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bk4p5uzye1rhmgr1f65izs4zn4br4gqa
X-Rspamd-Queue-Id: A49B31C0017
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783533691-877239
X-HE-Meta: U2FsdGVkX1/M0gpvAsX5O4AgbpfLTNXFrxrXHMiyinjy8sklpzTeOa2n3aaHjBQnySZzo+e0epE4zVOYJlzccDEIh/ss8OdYCOcA/Uhhu8C1cy4S0MSSVe1mc0IyklC/JEUKzHCkFiZN+rQ8n+/7mt6FFBNGhty8A1gzIyBSch6CG+cXOanpLDxJydKYFqZYxbO49JcNrECLwWhT3B6ALXV63HdCcWc08OiNdc8pL/P+TJ3AjvV5oxiBjNJS/wTwrN1V62cc7eENjUkUQDjOm5T+GQLBWnUBbb7uDDoGdInHu2nvv4tXiVOIweTfiN9eKFecoyKiCSpeCchGCzZR4dwKRd2s16uWDEZjmZr8W4MxVMl6OLbHUhOx9RsUHwyaVqYfPlhIcCF2+1532mm4AXwvo9wejkO1TwMnfwM6Sfh97SSK+J/ea7UffMC0cGY3CmXRoy9FE3ereslkR156TSzwKq0A72zDwfeMxjPPVmofDmBwBoThKZQRQVPtoscfFCHMxGPWWsJLF9hnEvSG+ToldEC/d8LVHjWezfvTqABbt8JzXiJuFttos7JROA1nqBp4tVaFP84JxyhxZrK7xU9e1+tWgIWDtn+ZPms8qaX9XsAKtpdIKgnOuK6Xa+8y56Y5I61dha4EKA4uG0OCt3G5WnLrS8R2Oab97yrNd8Y6dKtJyHu+c1Hd57nweEZxksig6tilLhrt0zMuSpEoBdOiwdNRHZoR1jl35hc0/GENKRgn6b1oblcvsZos13sYFpRDV78SBZ9NaZZHd+JhW+KGl8eUj5IZ02z0AML4XsEIxoET9TcjD5SN143skAAqSq1bhDip/0ybMvHuE6WAadkMm/u3LH1QdNxfUY1TW8U4nO4CnQsghWk+xsZjVVB5YVbybedN+O+Y13+RP4FpfytM2neIV56bHa0PijUwBeKm82vr6qV55xiDYk2kzFup7Q5Uis5WAznoASTpTTZ
 swqpkR3A
 jokbJUvem+S4au/28cfl0rqQphs3pWBFTYlM8R2opooN0HMCBXkxvBTQr7ihoHOQL4QFQIQxj3fXZNGxg8koNnkTg/NGly14R82WVyKVwXjFzl55L9mCdEcsYPpUwcBz2HcXaKFTXY/J348iidoeh8DTlLzUhb/iQUImNHmjhtTx+H+6xl4Ek+yu3FXoxf4VuJrM6Wz16ARUQn+J6jNtNvxpFZFsz5Aum8MBP9dA1/r83WXI7CpiPvi5Aw45xSAIsrR/HpIkLHmW4xZfDP4ztuIXGyNPtSuc2FDCUHilBq8yFkIlNC/rAmiSDCMM4mUz0O8/AOgGpX90ZeW3xROzdRnAgznfgHE98Y3/K1VHozh/retcdTsOvffcoqaJ6kwdy8rjlU6RHR9LbDcDsP7jBdhKtXM/qaYBtuV/RgQqG6YYg0dFUePsV0mSMQh2O4c7EfzD79Jsv+sLkZR/OzJ5tKBxZKuEyYN8hkE9akF06LwUweyT8HSn4jOjzFXwNxOnYanF/JudN5N+RjziS7fxULeOAp/mbA/2O53Wh3OArP5X+4whhzo9qqaLUVOdjLg0/tGXIUiyAu5LjozQ4PA+jE1R6uETujuOtASx4FIIfOgRp0FEE8Gj6/gzYy2htWB6fqQA3KfvqnXb5jsjGSBCTNU/mXfjIBPWp0z0eL+b5y+Gkr1WqvwP5wCHojtBRiHTTXpwt
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

v8 changes:
- Patch 6/6: Changed KSFT_FAIL to KSFT_SKIP for scenarios where the test
  cannot run because the kernel wasn't built with
CONFIG_MEM_ALLOC_PROFILING.

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


base-commit: d11ba1f570615ec8d4814d6313ee1d7075a33787
-- 
2.55.0.795.g602f6c329a-goog


