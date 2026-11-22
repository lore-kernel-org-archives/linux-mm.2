Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA3F0606A334
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hj2E+HQr
Received: by kanga.kvack.org (Postfix)
	id 273326B05B0; Sat, 21 Nov 2026 19:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FCF36B05B1; Sat, 21 Nov 2026 19:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3FB6B05B2; Sat, 21 Nov 2026 19:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D54C06B05B0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:09:07 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AC971C3E12
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:07 +0000 (UTC)
X-FDA: 85460819934.26.C1F5EDA
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7A45D1C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hj2E+HQr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306145;
	b=X0jmnXfKCKSuQJzMQuNDH5qp/Bl3TMOjum5EdR5965r2BefWCBen+SCPf2s4W1MgxPI8Ie
	X9OTlQiUkn6OGDNu5XZRSUyfFCsAcgVBU/mXDTFyWLhJR565frQmTHPGFba4gdRZQN9GUx
	i/s9P/zi89YnHT/uwy8/WYTqQgSq0aA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eZ/C0MjLctzDUF6Twskdb3vgozRB4N9gCenz5ZATy2M=;
	b=nfa28epXa0NgsCkOCaES+D6eHVWfxueEwfUEZQ4U0TYFHl485FjGYUD4Ypeb1UcgSrXAkd
	deZyO89Hb6lhyuWfGCYQ+TpK4Wup25AoZzDxO53TPKBYb2s4/GCXQFeGp7f+DOZ6WXeXna
	7XEfQpYI4TTdZEwVWbAZytIu39HMLA8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hj2E+HQr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e9f6a16afcso32275ad.1
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795306144; x=1795910944; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eZ/C0MjLctzDUF6Twskdb3vgozRB4N9gCenz5ZATy2M=;
        b=hj2E+HQrfvnlea1BXCqTEK/Y4FYyMkNP49qkwaryVk+5WvU3rVgqEciNUtVOUZRg73
         ywgPkyIiMjKnTV7g65Dk9sA27HBFFTyZK1ViO1bEwD66gKljlHFaKoIS/Lg4+aUHp0Td
         ZjWuKDXclsIXGmeNvCHb0sKrso8zR3yjvIR2d/P1mY97G1ZA6tkvtnROnolpxjF2aPL0
         z9KrIJVD6bfiexai3zHJfm9TuM5y9siYSi+/ixnU92Ms2RuU2O0X9/7UU70M5ePm0t8Z
         bi05ZLc2VmaxcFZNemuov7GEPxBGNlec/o0KNdDNF5WM+RRSnz04yoOYQBi3DYjAGFa1
         7Ehw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306144; x=1795910944;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=eZ/C0MjLctzDUF6Twskdb3vgozRB4N9gCenz5ZATy2M=;
        b=vwZXxSXqx3B2so5rP2H4cvsICXuPy/pholIRXr51LLePrh+hSKxZ6P1mM1mIxABzSz
         mjB3I/a+0XHk6lYYu+dhj4HNZrRhQ8sa0G24C6v3qADNxXi8QvrHd+3HWLuoVBgt4HCA
         DYgIDp75mwCEjJr1LppQHa1+w976dUUmiZEW69ChHn1b+Ey8aok3fWqYF6emgX1V9Pu1
         CQtc7JIeOb4M45QNdinmudlPjEcEVc78w3uLSiCj9b9loq6ywcrJm2V/cC7HSEQyv6rT
         efvNCIpZ6rhk/x6ctzq3GaBuiJv+6Ht6Tdg2XpwmanFTqY30YSULXLk+2nI3lLgiRJyq
         dyuA==
X-Forwarded-Encrypted: i=1; AL+hErFx8lFo3lM48SexDpIqXq45TvKrDrkIkG8RCyTRpV9cImgWD34YQN09x01rn4L3pjRhkyazQjVmRQ==@kvack.org
X-Gm-Message-State: APuU4Z8X7g6KleSYa1dYKWPzlDTA1gigY+1WtD7t3NQC4Jou4ZxCeHjH
	1np8WSORgV0buSn/r2gNj6K6KhPqTFxqubJkxedZg2aK432V+Bed1Q+NeWcdC00ifNl9hTZpW8N
	wE+juiB4S
X-Gm-Gg: AZFdTZdOhV/hN1QrW0kMu8C52dpkyiqdt2pvZ94MFWBMTZcGNMCKgg75URxyKDcWWnB
	KlLdqjWXMCTPfDitq+rX7Wih97+90KQ24Z/xjTWRNBIkXiXJtU32Xs9lFjWtGobUicmuwIqpaHd
	t1T8eSmnxyOccTWkm73//QfQ+Aj/6PcfxXkGe+gq6htBgneICDob+9OkwbNp4OX8A+xGqjqeTof
	/rW0bBhCf+jfD1MZcMZEQTOp1wXbDOHNe3kk4/pbw+0S+Na2lisY7TAepHfegbnBfDiFQNexaZA
	edtkey3R82TTv/8Ew+D2AVI1R8Y6AIOthFu8TBktqKY8M7mzpeTc3Qds0joRaomHD83vWlsVukB
	Ow2iKA9pWzFvgt5xvndrpEIYy51Ti27PRyp8bpLfBq5RhnvD+OuamOmKxtx+vUkEbb4/WnOT4+w
	isFHiPpz+ODl1dWDv4iduGufbP9CWWjQAkN8Gtm4Ob6MTPId+f6OT3rZHQfMUmty6HdTLRCv8f3
	H4zn5wLGeCfCDFJepzW+MC7xazFXFj1p54k54LImcD7eW0vIvZw7Jv/O6KN05SftXe6DHg3hr58
	lHWfR9nieZmQ+ZqffDBhRg/CY99GczJaGzQNcmhGy+kHT90h6UZJ6YWg1PtaZUmCx7Buzpckv/Z
	T5oj+SuiACu4q1aEljPkMPR0YRXGwaV+HsNJ8r05JrAo6qAFF4qwTOMaAc/QIhwnHOARnQjkBgX
	1eMQNEGb2rfQT5QABGsoD3PQML6dxLaNi6jq5UCttAb4w=
X-Received: by 2002:a17:903:fad:b0:2e6:23e5:4934 with SMTP id d9443c01a7336-2f0666ca266mr2919995ad.14.1795306143466;
        Sat, 21 Nov 2026 16:09:03 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:575c:af4:36d9:d404] ([2a00:79e0:2eb4:9:575c:af4:36d9:d404])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405ffa98esm12953309a91.17.2026.11.21.16.09.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:02 -0800 (PST)
Date: Sat, 21 Nov 2026 16:09:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, 
    Johannes Weiner <hannes@cmpxchg.org>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
    Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 1/2] mm: page_alloc_kunit: add synthetic benchmark for the
 page allocator
Message-ID: <c872d827-76c8-f765-0634-c84c7d9ce853@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: hwj9kjw4a9ept11ndrk7aikshyrhb1w5
X-Rspam-User:
X-Rspamd-Queue-Id: 7A45D1C0006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795306145-634948
X-HE-Meta: U2FsdGVkX19utz92NQk7kPzxV4IYELJX2Hg1qtolWkRmt5vgou5hJTFQZt2RdtCqTl4jeWUEFtaik5me4ZvqN3x6Uvi2Na1L6Z1hDqqZMptQVzRSM8iI8STz75Fkrg2Wnyfdb48+7Ip4amcNmFZJeut6KcjcDTKsKDGhmop7Wn0A6hYQ31PVv/+EIxxgvNua+yCjgpPkjYsS6I2ul1QLlulRj0+TRcnF8VVWjE7Fw1O99UGu+RbvWuZTWiwc9c6Nb2JCV5v6yWZxtFUiR5P6MK2IqhANcZdDFSkJkoXxOCIpCYriRyATg4Fkago1O1XAJTagKmGmxes/4QZkv+1bONOBo8z2Q4pmJm8O49cS7ubKvGO7o+Fr2S+kaB8B7k1Rcvp6dJZsLwsNechWv0QfUGza61KRAhoe9fmCtLo6hfSZIoSBAq35de3LYgEpEzfk9lVgf1/zmEcgpqykUfKxFM3qZ+ExuZZsFkYkgkCsxmh8cfk+r+h014L18fU6/AFBn5kpCTWmE2pIcr1wdClrZohiy2FtithBpY3wWk3X8DfJDxOKx1izzfOAKxs5Gb7I1U/aSkICEBbewqMLdxPcuTOAjDtwCt8OGjAcy++xuu32H094YpkfvCIPZmxlFz/Odqa9Fy3QsIdM/pV0FFYusFlQGW6cREpSk8OIi45N9YfS4hQHJesUJZ15dAGofaJlSy/FAP3NvtJ4dRQGDLidYqRu4ZREUry1CroSrxNADJsbOilvZZAg6frMqR5z6L89tQaBspV3zRut3LoGOy9wXlXCLbDc6i1PllXBMH7SQU/zAADBnzN3kmFSkboGTf+sEkLbt8GTVr8dyGfsaJY+v2BqNKKXDYSK54TTLdMTBC/D4+IIyrphbOpmMJPk3Ns0gyXeGzL8jiZl6KJ/F2L2tqKyXZ41mpab57zqqCJIiEW4AzcK8PEFfFjJmN5VoXiMKA2GeebNOFdSUKJssld
 IFoVpIqC
 WHrYUi7RcA49/KsJkLJYFxMSaNeha0B5kx4X48KQ8YUMekq05W6piIXDgcLEcRrem+RQMU1Y5jRrUn1nzfK6Tu9snXgz/jSYzx1qprR3F2ud2oMALWR4BBVB9jFHEBPWLDyb8U8gf1oT+UaAcxDA6AwMFqbycIrYmLJW6jPh/IzVk+t0ccLDKR7kaNiM9gu3Qv6kc/WutEHVchhtqvZIns192vuSeHf9GR4Ea7dc1Z2sMpOot8mDP9tMDB8QtXwaOaR+OdeyH6Nbf4Nx4IUJ/QZir+su88FaS9tg5lKZXy3rzts7f9xF9rFOOy+5SI/gDyUlm/54BDjD2pr8y4vCEZcTwwO6URTOtBKohKzo5RQchgYG0rqe2RvcfaIunGvHFvGZ7BrcCI4p3mtLFJqf9Fe/vPDwCs4SrND29PCLXHQLMLlprE4K4jPYjwVFkDzZeoYSKyOGxQnfbjH9ibJtFUXsVtFMoF4l51AQbk9yLjut2JtSGWQGJF/7ZUrqisBSwna0TzREsxSijODsly7eJnQ4PHgcvWQmhqHonljjjGGXg6OONJTf7CAl8eoQGreLB+cPPaCDC9HC0CGgvllDXDmtAXJA4Nkrh+fsvR3FdCMXWO5dg2dPr0YcreFKh/5r4SgpzzCmNLTl/LBedKYt7q9T/f7SSpa5tWeAzJYsP/1L/S9X7+4SDToxxnoyIF+/4yUyIotUdISK8nSYV3F+NAdCptVlkLBe4wS6iB+yyxiSaoWiTHTNrR4U8Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of the
page allocator.  This is used to analyze any improvements or regressions
in the allocation and free paths, which are among the hottest paths in MM.

This is the second of three tests that measure the execution times of
critical MM functions anticipated to be used by developers to measure the
impact of any core changes that would end up causing workload performance
issues.  Google has carried these tests internally and kept them updated
since Christoph posted them back in 2009 for this purpose.

This can also be used to detect regressions over time, from kernel
version to kernel version, independent of development use cases.

The benchmark covers, for each page order:

 - allocating a batch of pages and then freeing them, from a single thread
 - allocating and immediately freeing a page, from a single thread
 - both of the above concurrently on all online CPUs
 - allocating pages on all CPUs but one and freeing them all from that
   one CPU (remote free)

Allocations use __GFP_NORETRY | __GFP_NOWARN so that the benchmark does not
invoke the oom killer on small systems; if memory runs out, the results
are reported for the pages that could be allocated.

The test is run by KUnit or doing modprobe page_alloc_kunit directly.

Sample output (abbreviated):
 KTAP version 1
 1..1
     KTAP version 1
     # Subtest: page_alloc
     # module: page_alloc_kunit
     1..5
     # page_alloc_test_alloc_then_free: order 0: 1000 ops: alloc_pages -> 4074 cycles (1008 ns/op), __free_pages -> 1240 cycles (298 ns/op)
     ...
     ok 1 page_alloc_test_alloc_then_free
     # page_alloc_test_alloc_free_pair: order 0: 1000 ops: alloc/free pair -> 3036 cycles (746 ns/op)
     ...
     ok 2 page_alloc_test_alloc_free_pair
     # page_alloc_test_concurrent_alloc_then_free: order 0: 4 cpus, 4000 ops: alloc_pages -> 4880 cycles (1208 ns/op), __free_pages -> 4832 cycles (1171 ns/op)
     ...
     ok 3 page_alloc_test_concurrent_alloc_then_free
     # page_alloc_test_concurrent_alloc_free_pair: order 0: 4 cpus, 4000 ops: alloc/free pair -> 3695 cycles (892 ns/op)
     ...
     ok 4 page_alloc_test_concurrent_alloc_free_pair
     # page_alloc_test_remote_free: order 0: 4 cpus, 3000 ops: alloc_pages -> 5763 cycles (1442 ns/op), remote __free_pages -> 1707 cycles (414 ns/op)
     ...
     ok 5 page_alloc_test_remote_free
 # page_alloc: pass:5 fail:0 skip:0 total:5
 # Totals: pass:5 fail:0 skip:0 total:5
 ok 1 page_alloc

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 MAINTAINERS                 |   1 +
 mm/Kconfig                  |  12 +
 mm/Makefile                 |   1 +
 mm/tests/page_alloc_kunit.c | 490 ++++++++++++++++++++++++++++++++++++
 4 files changed, 504 insertions(+)
 create mode 100644 mm/tests/page_alloc_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index cc8e9dc4c98f..8747eff14532 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17927,6 +17927,7 @@ F:	mm/page_reporting.h
 F:	mm/show_mem.c
 F:	mm/shuffle.c
 F:	mm/shuffle.h
+F:	mm/tests/page_alloc_kunit.c
 F:	scripts/gdb/linux/page_owner.py
 F:	tools/mm/page_owner_filter.c
 F:	tools/mm/page_owner_sort.c
diff --git a/mm/Kconfig b/mm/Kconfig
index d6131fb7c1e6..1fa0c824fbe9 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1492,6 +1492,18 @@ config VMSTAT_KUNIT_TEST
 
 	  If unsure, say N.
 
+config PAGE_ALLOC_KUNIT_TEST
+	tristate "KUnit test for the page allocator" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test and benchmark the performance of the
+	  page allocator: allocating and freeing pages of each order from a
+	  single thread, concurrently on all CPUs, and freeing pages on a
+	  different CPU than the one that allocated them.
+
+	  If unsure, say N.
+
 config ARCH_HAS_CHECK_WX
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index f49994e61b03..9e0c4c6c6cbb 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,4 +150,5 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
+obj-$(CONFIG_PAGE_ALLOC_KUNIT_TEST) += tests/page_alloc_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/page_alloc_kunit.c b/mm/tests/page_alloc_kunit.c
new file mode 100644
index 000000000000..3cb78514c060
--- /dev/null
+++ b/mm/tests/page_alloc_kunit.c
@@ -0,0 +1,490 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit synthetic performance benchmark for the page allocator.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
+ */
+#include <kunit/test.h>
+#include <linux/completion.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/err.h>
+#include <linux/gfp.h>
+#include <linux/kthread.h>
+#include <linux/ktime.h>
+#include <linux/math64.h>
+#include <linux/minmax.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/timex.h>
+#include <linux/topology.h>
+
+#define TEST_COUNT 1000
+
+/* Highest order used by the concurrent tests, which allocate on every CPU. */
+#define CONCURRENT_MAX_ORDER min(5, MAX_PAGE_ORDER)
+
+/*
+ * This is a benchmark, not a stress test: fail the allocation rather than
+ * retry hard or invoke the oom killer if the system is short on memory.
+ */
+#define TEST_GFP (GFP_KERNEL | __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY)
+
+#define BENCH_FMT_LEN 48
+
+struct bench_stat {
+	cycles_t start_cycles;
+	u64 start_ns;
+	u64 cycles;
+	u64 ns;
+	u64 ops;
+};
+
+static void bench_start(struct bench_stat *stat)
+{
+	stat->start_cycles = get_cycles();
+	stat->start_ns = ktime_get_ns();
+}
+
+static void bench_stop(struct bench_stat *stat, u64 ops)
+{
+	u64 stop_ns = ktime_get_ns();
+	cycles_t stop_cycles = get_cycles();
+
+	stat->cycles = (cycles_t)(stop_cycles - stat->start_cycles);
+	stat->ns = stop_ns - stat->start_ns;
+	stat->ops = ops;
+}
+
+static void bench_add(struct bench_stat *sum, const struct bench_stat *stat)
+{
+	sum->cycles += stat->cycles;
+	sum->ns += stat->ns;
+	sum->ops += stat->ops;
+}
+
+/* Format the average cost of an operation; not all arches have get_cycles() */
+static const char *bench_fmt(char *buf, const struct bench_stat *stat)
+{
+	u64 ops = max(stat->ops, 1);
+	u64 cycles = div64_u64(stat->cycles, ops);
+	u64 ns = div64_u64(stat->ns, ops);
+
+	if (cycles)
+		scnprintf(buf, BENCH_FMT_LEN, "%llu cycles (%llu ns/op)", cycles, ns);
+	else
+		scnprintf(buf, BENCH_FMT_LEN, "%llu ns/op", ns);
+	return buf;
+}
+
+/*
+ * Test 1: Allocate TEST_COUNT pages of each order, then free them all.
+ */
+static void page_alloc_test_alloc_then_free(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	struct page **pages;
+	unsigned int order;
+	unsigned int nr, i;
+
+	pages = kunit_kcalloc(test, TEST_COUNT, sizeof(*pages), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, pages);
+
+	for (order = 0; order <= MAX_PAGE_ORDER; order++) {
+		bench_start(&alloc);
+		for (nr = 0; nr < TEST_COUNT; nr++) {
+			struct page *page = alloc_pages(TEST_GFP, order);
+
+			if (!page)
+				break;
+
+			/* Touch page */
+			memset(page_address(page), 22, 4);
+			pages[nr] = page;
+		}
+		bench_stop(&alloc, nr);
+
+		bench_start(&free);
+		for (i = 0; i < nr; i++)
+			__free_pages(pages[i], order);
+		bench_stop(&free, nr);
+
+		if (!nr) {
+			kunit_info(test, "order %u: unable to allocate pages\n", order);
+			continue;
+		}
+
+		kunit_info(test, "order %u: %u ops: alloc_pages -> %s, __free_pages -> %s\n",
+			   order, nr, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+/*
+ * Test 2: Allocate a page of each order and immediately free it, TEST_COUNT
+ * times.
+ */
+static void page_alloc_test_alloc_free_pair(struct kunit *test)
+{
+	char buf[BENCH_FMT_LEN];
+	struct bench_stat pair;
+	unsigned int order;
+	unsigned int nr;
+
+	for (order = 0; order <= MAX_PAGE_ORDER; order++) {
+		bench_start(&pair);
+		for (nr = 0; nr < TEST_COUNT; nr++) {
+			struct page *page = alloc_pages(TEST_GFP, order);
+
+			if (!page)
+				break;
+			__free_pages(page, order);
+		}
+		bench_stop(&pair, nr);
+
+		if (!nr) {
+			kunit_info(test, "order %u: unable to allocate pages\n", order);
+			continue;
+		}
+
+		kunit_info(test, "order %u: %u ops: alloc/free pair -> %s\n",
+			   order, nr, bench_fmt(buf, &pair));
+	}
+}
+
+/*
+ * Concurrent tests: one kthread is bound to each online CPU.  All threads
+ * run phase 1 at the same time and, once every thread has completed it, run
+ * phase 2 at the same time.
+ */
+struct page_alloc_ctx;
+
+struct page_alloc_thread {
+	struct page_alloc_ctx *ctx;
+	struct task_struct *task;
+	unsigned int cpu;
+	struct page **pages;
+	struct bench_stat alloc;
+	struct bench_stat free;
+};
+
+struct page_alloc_ctx {
+	struct page_alloc_thread *threads;	/* indexed by CPU */
+	void (*phase1)(struct page_alloc_thread *t);
+	void (*phase2)(struct page_alloc_thread *t);
+	unsigned int order;
+	unsigned int free_cpu;	/* CPU doing the frees for remote free */
+	struct completion ready;
+	struct completion start1;
+	struct completion done1;
+	struct completion start2;
+};
+
+/*
+ * Allocate TEST_COUNT pages and later free them all again.
+ */
+static void alloc_then_free_phase1(struct page_alloc_thread *t)
+{
+	unsigned int nr;
+
+	bench_start(&t->alloc);
+	for (nr = 0; nr < TEST_COUNT; nr++) {
+		struct page *page = alloc_pages(TEST_GFP, t->ctx->order);
+
+		if (!page)
+			break;
+
+		/* Touch page */
+		memset(page_address(page), 14, 4);
+		t->pages[nr] = page;
+	}
+	bench_stop(&t->alloc, nr);
+}
+
+static void alloc_then_free_phase2(struct page_alloc_thread *t)
+{
+	unsigned int nr = t->alloc.ops;
+	unsigned int i;
+
+	bench_start(&t->free);
+	for (i = 0; i < nr; i++)
+		__free_pages(t->pages[i], t->ctx->order);
+	bench_stop(&t->free, nr);
+}
+
+/*
+ * Allocate a page and immediately free it, TEST_COUNT times.
+ */
+static void alloc_free_pair_phase1(struct page_alloc_thread *t)
+{
+	unsigned int nr;
+
+	bench_start(&t->alloc);
+	for (nr = 0; nr < TEST_COUNT; nr++) {
+		struct page *page = alloc_pages(TEST_GFP, t->ctx->order);
+
+		if (!page)
+			break;
+
+		/* Touch page */
+		memset(page_address(page), 12, 4);
+		__free_pages(page, t->ctx->order);
+	}
+	bench_stop(&t->alloc, nr);
+}
+
+/*
+ * Allocate TEST_COUNT pages on every CPU except one, and then free all of the
+ * pages from that one CPU.
+ */
+static void remote_free_phase1(struct page_alloc_thread *t)
+{
+	/* Perform no allocations on the freeing CPU */
+	if (t->cpu == t->ctx->free_cpu)
+		return;
+
+	alloc_then_free_phase1(t);
+}
+
+static void remote_free_phase2(struct page_alloc_thread *t)
+{
+	struct page_alloc_ctx *ctx = t->ctx;
+	unsigned int nr = 0;
+	unsigned int cpu, i;
+
+	/* All frees are completed on a single CPU */
+	if (t->cpu != ctx->free_cpu)
+		return;
+
+	bench_start(&t->free);
+	for_each_online_cpu(cpu) {
+		struct page_alloc_thread *remote = &ctx->threads[cpu];
+
+		for (i = 0; i < remote->alloc.ops; i++)
+			__free_pages(remote->pages[i], ctx->order);
+		nr += remote->alloc.ops;
+	}
+	bench_stop(&t->free, nr);
+}
+
+static int page_alloc_thread_fn(void *data)
+{
+	struct page_alloc_thread *t = data;
+	struct page_alloc_ctx *ctx = t->ctx;
+
+	complete(&ctx->ready);
+	wait_for_completion(&ctx->start1);
+	ctx->phase1(t);
+	complete(&ctx->done1);
+	wait_for_completion(&ctx->start2);
+	if (ctx->phase2)
+		ctx->phase2(t);
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+
+/*
+ * Run @phase1 and then the optional @phase2 concurrently on all online CPUs
+ * and sum up the results.
+ *
+ * Returns the number of CPUs that the test ran on, or -errno if the test
+ * could not be run.
+ */
+static int page_alloc_run_concurrent(void (*phase1)(struct page_alloc_thread *t),
+				     void (*phase2)(struct page_alloc_thread *t),
+				     unsigned int order,
+				     struct bench_stat *alloc,
+				     struct bench_stat *free)
+{
+	struct page_alloc_ctx ctx = {
+		.phase1 = phase1,
+		.phase2 = phase2,
+		.order = order,
+	};
+	struct page_alloc_thread *t;
+	unsigned int nr_threads = 0;
+	unsigned int cpu, i;
+	int ret = 0;
+
+	memset(alloc, 0, sizeof(*alloc));
+	memset(free, 0, sizeof(*free));
+
+	init_completion(&ctx.ready);
+	init_completion(&ctx.start1);
+	init_completion(&ctx.done1);
+	init_completion(&ctx.start2);
+
+	ctx.threads = kcalloc(nr_cpu_ids, sizeof(*ctx.threads), GFP_KERNEL);
+	if (!ctx.threads)
+		return -ENOMEM;
+
+	/* Keep the set of online CPUs stable while the test is running */
+	cpus_read_lock();
+	ctx.free_cpu = cpumask_first(cpu_online_mask);
+
+	for_each_online_cpu(cpu) {
+		t = &ctx.threads[cpu];
+		t->ctx = &ctx;
+		t->cpu = cpu;
+		t->pages = kvcalloc_node(TEST_COUNT, sizeof(*t->pages),
+					 GFP_KERNEL, cpu_to_node(cpu));
+		if (!t->pages) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		t->task = kthread_create_on_node(page_alloc_thread_fn, t,
+						 cpu_to_node(cpu),
+						 "pa_kunit/%u", cpu);
+		if (IS_ERR(t->task)) {
+			ret = PTR_ERR(t->task);
+			t->task = NULL;
+			goto out;
+		}
+		kthread_bind(t->task, cpu);
+		nr_threads++;
+	}
+
+	for_each_online_cpu(cpu)
+		wake_up_process(ctx.threads[cpu].task);
+
+	/* Wait until all threads are running */
+	for (i = 0; i < nr_threads; i++)
+		wait_for_completion(&ctx.ready);
+	complete_all(&ctx.start1);
+
+	/* Wait until all threads have completed phase 1 */
+	for (i = 0; i < nr_threads; i++)
+		wait_for_completion(&ctx.done1);
+	complete_all(&ctx.start2);
+
+out:
+	/* Threads exit once they have completed phase 2 */
+	for_each_online_cpu(cpu) {
+		t = &ctx.threads[cpu];
+		if (t->task)
+			kthread_stop(t->task);
+		kvfree(t->pages);
+
+		bench_add(alloc, &t->alloc);
+		bench_add(free, &t->free);
+	}
+	cpus_read_unlock();
+	kfree(ctx.threads);
+
+	return ret ? ret : nr_threads;
+}
+
+/*
+ * Test 3: Concurrently allocate TEST_COUNT pages on all CPUs, then
+ * concurrently free them.
+ */
+static void page_alloc_test_concurrent_alloc_then_free(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	unsigned int order;
+	int cpus;
+
+	for (order = 0; order <= CONCURRENT_MAX_ORDER; order++) {
+		cpus = page_alloc_run_concurrent(alloc_then_free_phase1,
+						 alloc_then_free_phase2,
+						 order, &alloc, &free);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!alloc.ops) {
+			kunit_info(test, "order %u: unable to allocate pages\n", order);
+			continue;
+		}
+
+		kunit_info(test, "order %u: %d cpus, %llu ops: alloc_pages -> %s, __free_pages -> %s\n",
+			   order, cpus, alloc.ops, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+/*
+ * Test 4: Concurrently allocate and immediately free pages on all CPUs.
+ */
+static void page_alloc_test_concurrent_alloc_free_pair(struct kunit *test)
+{
+	struct bench_stat pair, unused;
+	char buf[BENCH_FMT_LEN];
+	unsigned int order;
+	int cpus;
+
+	for (order = 0; order <= CONCURRENT_MAX_ORDER; order++) {
+		cpus = page_alloc_run_concurrent(alloc_free_pair_phase1, NULL,
+						 order, &pair, &unused);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!pair.ops) {
+			kunit_info(test, "order %u: unable to allocate pages\n", order);
+			continue;
+		}
+
+		kunit_info(test, "order %u: %d cpus, %llu ops: alloc/free pair -> %s\n",
+			   order, cpus, pair.ops, bench_fmt(buf, &pair));
+	}
+}
+
+/*
+ * Test 5: Concurrently allocate TEST_COUNT pages on all CPUs but one, then
+ * free all of the pages from that one CPU.
+ */
+static void page_alloc_test_remote_free(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	unsigned int order;
+	int cpus;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "remote free requires at least 2 online CPUs");
+
+	for (order = 0; order <= CONCURRENT_MAX_ORDER; order++) {
+		cpus = page_alloc_run_concurrent(remote_free_phase1,
+						 remote_free_phase2,
+						 order, &alloc, &free);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!alloc.ops) {
+			kunit_info(test, "order %u: unable to allocate pages\n", order);
+			continue;
+		}
+
+		kunit_info(test, "order %u: %d cpus, %llu ops: alloc_pages -> %s, remote __free_pages -> %s\n",
+			   order, cpus, alloc.ops, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+static struct kunit_case page_alloc_test_cases[] = {
+	KUNIT_CASE(page_alloc_test_alloc_then_free),
+	KUNIT_CASE(page_alloc_test_alloc_free_pair),
+	KUNIT_CASE(page_alloc_test_concurrent_alloc_then_free),
+	KUNIT_CASE(page_alloc_test_concurrent_alloc_free_pair),
+	KUNIT_CASE(page_alloc_test_remote_free),
+	{}
+};
+
+static struct kunit_suite page_alloc_test_suite = {
+	.name = "page_alloc",
+	.test_cases = page_alloc_test_cases,
+};
+kunit_test_suite(page_alloc_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter <cl@gentwo.org>");
+MODULE_AUTHOR("David Rientjes <rientjes@google.com>");
+MODULE_DESCRIPTION("KUnit benchmark test for the page allocator");

