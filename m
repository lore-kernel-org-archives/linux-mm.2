Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FCD606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N1is7NP1
Received: by kanga.kvack.org (Postfix)
	id 903306B05B3; Sat, 21 Nov 2026 19:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA0D6B05B4; Sat, 21 Nov 2026 19:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A23B6B05B5; Sat, 21 Nov 2026 19:09:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7766B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:09:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4D141A0626
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:09 +0000 (UTC)
X-FDA: 85460820018.28.AD79076
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13069A000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:09:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=N1is7NP1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306148;
	b=SF/DIcucSrI3p8c2B0rCCzI6mU3b/2UbDKBrTKPxAsYOku/GCfAdMhTFa8GP1lLHDTyDQT
	7FDvCphOWTA6zaOqRKMLxOnHQ1rpCsbDjoZGuQefG/P9W+tHgdVSvc3rNYLawJdjnqw79q
	DrmU93CPFEGd+H5oX2TTKL/FKCoYQqQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FWoGJyOOx8MBudK/SXFqYhSZuLve62rb6ctG2QCZRF0=;
	b=aYcUhuK1d+mWb3jZK9A2Pc+Nj93JXkUKmjJi4tflrwQtg5Hnv9AcWvFd0IIgiEtx/AtOqb
	VQNerL0Wq2GTzdSmeCJSHlaVniWeFAbpG4DaLzMuXkEWARk2tvr9Ls9CJPTxrdD9iJP86f
	DXKk2yGiAueMfgu6MEcEPA4u2PGsGmM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=N1is7NP1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f048bc09d7so49955ad.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:09:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795306147; x=1795910947; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FWoGJyOOx8MBudK/SXFqYhSZuLve62rb6ctG2QCZRF0=;
        b=N1is7NP14KkVVE39/wK+xqgDbj+8wyv4Smz9YEx7gdo/tvThqRnES6d9qG4IUf4S7P
         KHPVyPA5qSRL/rPteSiOoiE6CyI44TAmEhAOLdeecb6r9fylkyr4eLxksbub6nEWe3oU
         grXyuyl+w7hLnGePoCD6Ys+msU4S7q1cU6JqNWGiw+CwITnabypcN082jJXqUbgPZBPa
         K8tYf5zEcqwTOTb0SaB8XHrkYnzfq0yAMgNrGuudVF8Bj4yUi/hi0afRXI/NOILMduEK
         srbhWNxeA1sK29c/cgtpc8IDCapdNJyD88AfwT3QE6eeHEhBMaxdiWg4RZXh1w9CZdDh
         4ccg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795306147; x=1795910947;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FWoGJyOOx8MBudK/SXFqYhSZuLve62rb6ctG2QCZRF0=;
        b=T5eOPbqTPXfDoBny5/Z8QogNGfvjx313Bsbl8xK0bR8kt5GeapTstInxEtOx14x3/+
         eqOEldsXUyAjBGnJvvH+qqNWEzFUoGndPNdC03o1ayTBmAjrTCQJicCcPQRFNig1mCWP
         xe9Q/gajZvXO2wwuOupzW7AaZSACG4AIQ6CKrQiwaVe/yNpxoRH6C2PXNYlNfHfOR6ic
         xiaQKXSeV+xs+SZZbJb3M8TQP1ePiQlJQZy+TvBpnqD+b95+Y4kA64+ZAXcmYMyid67Q
         Za/mdlccgXdM+pdHGh0u+uj96HGYPlWrPghspl4HVj3qUB5gWU9sW55DREjwPI8c6HEu
         dIjQ==
X-Forwarded-Encrypted: i=1; AL+hErG8KFgVG1gc8pXRqD+f92c1TRH2VcYV9J2rbc3Gcytm6HrP/njV9AYwrD3hNnISwgX94wCa4r6WZA==@kvack.org
X-Gm-Message-State: APuU4Z9G1KMWUt5M0lhGYENGU5Ji7PuNawEhHizAr1s7cWgkQVfxSjPE
	givJSSKV9dKRuo8hBMau/CfkkCrGCvUOTl64HUOrBzsN+jXbARimZon0SWMc1yhyFA==
X-Gm-Gg: AZFdTZeHkcQMkHWOT/+AwP5OcL3F14xEFoFjFGxy9aE61oQyLnUOC+qzcf5MeEOtLH3
	W62EnrU4f+lZBxN3xX4FQfeQmJUj3wC+Va3/HGPaRB3+UDJTTNXMOD/nURgseb3cetmPV33S2rK
	JD5iNuhEfu//vKP5okInR1sOnmQWIM12UM5ukt+gijN+wwbzXnHTDDDp1kP081GZxwlaVsqABA8
	NghAKB34cvj5vYHZTRQ21kmvgfzQfO5ubu8l6fHcTnUL1rTxM6V448Et/AjwL9DEN+2Psu8bsc2
	AQDKvHu74gxOYxU5ruLoJk6mFUC4sV6OCF0kSeiUkkM0n3i467gxZ6NnFxQsmzlKb9+uK+bKVpN
	G1aam40hMjBkMWWDAFtl9EpEXJJUfP5bTl/FCzKBozbDcHUnWnP/M6gPNKYjgQwEB5bWaCNWKwi
	SGDT3G8MGzWsjCFkx5pC+c5byYSRW7TUVuO2N83Wo949ZgGNostFaPQAy7mAYZ1qCtqIROay9aO
	uxEWZ5oY6j6jkvKmxmV7+dsAbGmrGzGBjzYbMnflAAxwy7F20m6LOg4ARB70qg0GfU1jLsh7O0w
	AfTT3F7+4Dx2F1Wr22rSmJRdbnnr8ewyZBBUUAnXdUQ5lbvoJ1Mk0ri/xQj69jrh+jYuNQ7nVGw
	2ReiJ5cS7NqN6E5F/UWDWHvK2khvyjCKYoVaON2DqKJpr1gEAmOSRXe8FffHdasND+q7E/ml1zA
	4Hv/qsE8Ct90w0qUoNR6NfzEHxi+xLxrQju1CPwbKzYeg=
X-Received: by 2002:a17:902:fc84:b0:2eb:188a:1c06 with SMTP id d9443c01a7336-2f06657180bmr2795785ad.9.1795306146077;
        Sat, 21 Nov 2026 16:09:06 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:575c:af4:36d9:d404] ([2a00:79e0:2eb4:9:575c:af4:36d9:d404])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40f4312dfsm11918127a91.3.2026.11.21.16.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 16:09:05 -0800 (PST)
Date: Sat, 21 Nov 2026 16:09:04 -0800 (PST)
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
Subject: [patch 2/2] mm: slab_kunit: add synthetic benchmark for the slab
 allocator
Message-ID: <ae9aa46f-8b6d-6c10-ab8d-aff30ebbe338@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13069A000A
X-Stat-Signature: cfj1b4h61qs7yxor7t4hono7w65df7p1
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795306147-733109
X-HE-Meta: U2FsdGVkX19Uuq0zG5SSgZ4OHaSlCdDrhNbhBmKxu6Kk69BnfYhDZ4QPKsjjnYPDzWCji/otBTTrLtPdIz7r1ZH06JyPaLjAgAuN0q/1ltr7krocAIbIOJ/HKvKw8AP2DamAN0y9LxQe/fPKn74Vy5gGEHqD///NJUPrAkxINtw0f+GbZ9qKR+PBpMc1yaNhjSNG8sjeXS6W45wYcMeQCUOekDGIucbAjw9UnFYclILwEIzN3dJfcFe3/iNa4tQydi8AmYjWBZ62ydpoSbznbNTdUEyD8r3gi3MQyx0z8UF3tbJEZLRAAyP8TDptb+f5/mODOYfJhvZyv07+CUdyn9zw2TJKC0I8k+2jr2zLkseVpnaGe75ESCbikvdMHZojN4m1lKDRn8A2F53YEEoGA3tWrG54VKtgMYz9M7bCPDsnN0NzXq8dwTavuk0vYroBT2S7uxWop/6XrrKzPElCRHJLp0LxODDVUF4Fb3cQL2BK3yNdlP8MszCenSFdEQLnqRJD49w2vK1ivY0zNB7fnPKzsOsnWlXFpSBIm9C1sXil3ljX4mP/BPKpqNOMCYwjLd7qtxx0oIaprGK3dok3w9hY7TDSBLDtYM1qZpdISVfhi1N5FTRa2ycn5qIi3T1Y0QhJ2k/Avg/iQrmFs7McKbnEt1V6pnOsgbIx0csHJpJSNYlOL4zWT6iAVmckDI3MN8fUfu3Q2gYyEptUIug7J3OGFgEivmuURcU/Y0uXdML2+rqxycvYq51cTrx3a0OeIwKHr41coB+NQTZUSbFdd3TtdW76tlgBxkfaM12kYW6J1OC9WjB/ZVmskd/25ftcGovQzy34eGS3qibeHZi3EQXolbS8kf5umvUmIhwhnVgAQMpmk9znTWR4o5VdUGwCy2bYDgUze//y4c0hd6sLrD4KS653iiaS+OZVoH9GECQInzQCJAajeJov/g3aiVPfWsxv/gjNY8/smSDmf0r
 ubvPntRl
 iktB6JKFM4AVoYGplSD6pLC3FN+zNlZEDnm4ocp65g3aoxMi7kzvkVcrmegMhSLajQNMP2C4x8z824iHwZeKtv5KHaIxcBCy7NBphsDUFgqKs7//fl/W/Dd3m9BY0aMuZKXmiIMIm5NOw1qyYS9gF6lHM02s9JdLLTL8cBrsApfk4zMaA6+KsozNVqB4aASWHoPOm1BPhKfXlVIKhz9r28oi7leGo46jADuZHcir0266L298Y7+Sg7WYg76hd/WFNip0xiowWBFvxKk8/pjgxz8za52ttemk9J00CUs9KV4yxQkbKW94wbsj3DPJTyzvF4ui1gZsgUZcNH0MJ0KVnc6VXbeUQbleovFJfSBCA1oGSsemJnZNJdKdYKkMFfuCMPlrDQemSc1nSoi2IfaPyIs/q5YrCctuARuqtPSfw1wqZGerwsETYUkpgRxJHHTe23J65up7xKSAUPrglsjSdfQolJK0kzTg7yA+O9x5gPVqDOH9aPa7TOGyCLWLpfSlX0CBcHb/UyPCkvF6dXl3wFm/um5LT+AiwPLhz795ZNphCV/IbEshNMnARY6YV+ah4L2vD/TRqEcCkRl/XjDj3K88GsSWsIKQjCUo0FzJ/RcGyIg9q+Q0xhUs28nhCkfoMmsgQgF52wZR5xU6U2BqpG70mBlvGb/d/HhadrvFhYbu4MPxzQ1oIhtfCkfZrCcRGN9e+uvcI7vz3UNUAsx6p5N2EZeBRl9ZsELnbEOo5R1RTdcnfqmKOfeBLZVnMUvjgeBt8kcVVQeIrC60mbvHeYHS0hH0/G4cmnLQN0SiTiKUjb50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of the
slab allocator.  This is used to analyze any improvements or regressions
in kmalloc() and kfree(), which are used throughout the kernel in hot code
paths.

This is the third of three tests that measure the execution times of
critical MM functions anticipated to be used by developers to measure the
impact of any core changes that would end up causing workload performance
issues.  Google has carried these tests internally and kept them updated
since Christoph posted them back in 2009 for this purpose.

This can also be used to detect regressions over time, from kernel
version to kernel version, independent of development use cases.

The benchmark covers, for kmalloc object sizes that are powers of two:

 - allocating a batch of objects and then freeing them, from a single
   thread
 - allocating and immediately freeing an object, from a single thread
 - both of the above concurrently on all online CPUs
 - allocating objects on all CPUs but one and freeing them all from that
   one CPU (remote free)
 - allocating objects on one CPU while all other CPUs concurrently free
   them (1 alloc N free)

Allocations use __GFP_NORETRY | __GFP_NOWARN so that the benchmark does not
invoke the oom killer on small systems; if memory runs out, the results
are reported for the objects that could be allocated.

This is a performance benchmark and is complementary to the functional
tests in lib/tests/slub_kunit.c.

The test is run by KUnit or doing modprobe slab_kunit directly.

Sample output (abbreviated):
 KTAP version 1
 1..1
     KTAP version 1
     # Subtest: slab
     # module: slab_kunit
     1..6
     # slab_test_kmalloc_then_kfree: size 8: 10000 ops: kmalloc -> 996 cycles (248 ns/op), kfree -> 449 cycles (111 ns/op)
     ...
     ok 1 slab_test_kmalloc_then_kfree
     # slab_test_kmalloc_kfree_pair: size 8: 10000 ops: kmalloc/kfree pair -> 832 cycles (206 ns/op)
     ...
     ok 2 slab_test_kmalloc_kfree_pair
     # slab_test_concurrent_kmalloc_then_kfree: size 8: 4 cpus, 40000 ops: kmalloc -> 951 cycles (236 ns/op), kfree -> 530 cycles (131 ns/op)
     ...
     ok 3 slab_test_concurrent_kmalloc_then_kfree
     # slab_test_concurrent_kmalloc_kfree_pair: size 8: 4 cpus, 40000 ops: kmalloc/kfree pair -> 1071 cycles (263 ns/op)
     ...
     ok 4 slab_test_concurrent_kmalloc_kfree_pair
     # slab_test_remote_free: size 8: 4 cpus, 30000 ops: kmalloc -> 1118 cycles (280 ns/op), remote kfree -> 420 cycles (103 ns/op)
     ...
     ok 5 slab_test_remote_free
     # slab_test_alloc_n_free: size 8: 4 cpus, 30000 ops: kmalloc -> 902 cycles (223 ns/op), remote wait+kfree -> 2705 cycles (665 ns/op)
     ...
     ok 6 slab_test_alloc_n_free
 # slab: pass:6 fail:0 skip:0 total:6
 # Totals: pass:6 fail:0 skip:0 total:6
 ok 1 slab

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 MAINTAINERS           |   1 +
 mm/Kconfig            |  14 +
 mm/Makefile           |   1 +
 mm/tests/slab_kunit.c | 614 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 630 insertions(+)
 create mode 100644 mm/tests/slab_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8747eff14532..b38d38916e46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18012,6 +18012,7 @@ F:	mm/mempool.c
 F:	mm/slab.h
 F:	mm/slab_common.c
 F:	mm/slub.c
+F:	mm/tests/slab_kunit.c
 F:	scripts/gdb/linux/slab.py
 F:	tools/cgroup/memcg_slabinfo.py
 F:	tools/include/linux/slab.h
diff --git a/mm/Kconfig b/mm/Kconfig
index 1fa0c824fbe9..0cfdf3dac0f0 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1504,6 +1504,20 @@ config PAGE_ALLOC_KUNIT_TEST
 
 	  If unsure, say N.
 
+config SLAB_KUNIT_TEST
+	tristate "KUnit test for the slab allocator" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test and benchmark the performance of the
+	  slab allocator: allocating and freeing kmalloc objects of various
+	  sizes from a single thread, concurrently on all CPUs, and freeing
+	  objects on a different CPU than the one that allocated them.
+
+	  For functional tests of the slab allocator, see SLUB_KUNIT_TEST.
+
+	  If unsure, say N.
+
 config ARCH_HAS_CHECK_WX
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 9e0c4c6c6cbb..11b695539357 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -151,4 +151,5 @@ obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
 obj-$(CONFIG_PAGE_ALLOC_KUNIT_TEST) += tests/page_alloc_kunit.o
+obj-$(CONFIG_SLAB_KUNIT_TEST) += tests/slab_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/slab_kunit.c b/mm/tests/slab_kunit.c
new file mode 100644
index 000000000000..7aae29196fd3
--- /dev/null
+++ b/mm/tests/slab_kunit.c
@@ -0,0 +1,614 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit synthetic performance benchmark for the slab allocator.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
+ */
+#include <kunit/test.h>
+#include <linux/completion.h>
+#include <linux/cpu.h>
+#include <linux/cpumask.h>
+#include <linux/err.h>
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
+#define TEST_COUNT 10000
+
+/* Object sizes used by the single threaded tests */
+#define TEST_MIN_SIZE 8
+#define TEST_MAX_SIZE (PAGE_SIZE << 2)
+
+/* Largest object size used by the concurrent tests, which run on every CPU */
+#define CONCURRENT_MAX_SIZE PAGE_SIZE
+
+/*
+ * This is a benchmark, not a stress test: fail the allocation rather than
+ * retry hard or invoke the oom killer if the system is short on memory.
+ */
+#define TEST_GFP (GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY)
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
+ * Test 1: Allocate TEST_COUNT objects of each size, then free them all.
+ */
+static void slab_test_kmalloc_then_kfree(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	unsigned int nr, i;
+	size_t size;
+	u8 **objs;
+
+	objs = kunit_kcalloc(test, TEST_COUNT, sizeof(*objs), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, objs);
+
+	for (size = TEST_MIN_SIZE; size <= TEST_MAX_SIZE; size <<= 1) {
+		bench_start(&alloc);
+		for (nr = 0; nr < TEST_COUNT; nr++) {
+			u8 *p = kmalloc(size, TEST_GFP);
+
+			if (!p)
+				break;
+
+			/* Use object */
+			*p = 22;
+			objs[nr] = p;
+		}
+		bench_stop(&alloc, nr);
+
+		bench_start(&free);
+		for (i = 0; i < nr; i++) {
+			u8 *p = objs[i];
+
+			*p = 23;
+			kfree(p);
+		}
+		bench_stop(&free, nr);
+
+		if (!nr) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %u ops: kmalloc -> %s, kfree -> %s\n",
+			   size, nr, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+/*
+ * Test 2: Allocate an object of each size and immediately free it, TEST_COUNT
+ * times.
+ */
+static void slab_test_kmalloc_kfree_pair(struct kunit *test)
+{
+	char buf[BENCH_FMT_LEN];
+	struct bench_stat pair;
+	unsigned int nr;
+	size_t size;
+
+	for (size = TEST_MIN_SIZE; size <= TEST_MAX_SIZE; size <<= 1) {
+		bench_start(&pair);
+		for (nr = 0; nr < TEST_COUNT; nr++) {
+			u8 *p = kmalloc(size, TEST_GFP);
+
+			if (!p)
+				break;
+			kfree(p);
+		}
+		bench_stop(&pair, nr);
+
+		if (!nr) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %u ops: kmalloc/kfree pair -> %s\n",
+			   size, nr, bench_fmt(buf, &pair));
+	}
+}
+
+/*
+ * Concurrent tests: one kthread is bound to each online CPU.  All threads
+ * run phase 1 at the same time and, once every thread has completed it, run
+ * phase 2 at the same time.
+ */
+struct slab_ctx;
+
+struct slab_thread {
+	struct slab_ctx *ctx;
+	struct task_struct *task;
+	unsigned int cpu;
+	u8 **objs;
+	struct bench_stat alloc;
+	struct bench_stat free;
+};
+
+struct slab_ctx {
+	struct slab_thread *threads;	/* indexed by CPU */
+	void (*phase1)(struct slab_thread *t);
+	void (*phase2)(struct slab_thread *t);
+	size_t size;
+	unsigned int single_cpu;	/* CPU with a special role, if any */
+	bool producer_done;		/* 1 alloc N free only */
+	struct completion ready;
+	struct completion start1;
+	struct completion done1;
+	struct completion start2;
+};
+
+/*
+ * Allocate TEST_COUNT objects and later free them all again.
+ */
+static void kmalloc_then_kfree_phase1(struct slab_thread *t)
+{
+	unsigned int nr;
+
+	bench_start(&t->alloc);
+	for (nr = 0; nr < TEST_COUNT; nr++) {
+		u8 *p = kmalloc(t->ctx->size, TEST_GFP);
+
+		if (!p)
+			break;
+
+		/* Use object */
+		*p = 14;
+		t->objs[nr] = p;
+	}
+	bench_stop(&t->alloc, nr);
+}
+
+static void kmalloc_then_kfree_phase2(struct slab_thread *t)
+{
+	unsigned int nr = t->alloc.ops;
+	unsigned int i;
+
+	bench_start(&t->free);
+	for (i = 0; i < nr; i++) {
+		u8 *p = t->objs[i];
+
+		*p = 13;
+		kfree(p);
+	}
+	bench_stop(&t->free, nr);
+}
+
+/*
+ * Allocate an object and immediately free it, TEST_COUNT times.
+ */
+static void kmalloc_kfree_pair_phase1(struct slab_thread *t)
+{
+	unsigned int nr;
+
+	bench_start(&t->alloc);
+	for (nr = 0; nr < TEST_COUNT; nr++) {
+		u8 *p = kmalloc(t->ctx->size, TEST_GFP);
+
+		if (!p)
+			break;
+
+		/* Use object */
+		*p = 12;
+		kfree(p);
+	}
+	bench_stop(&t->alloc, nr);
+}
+
+/*
+ * Allocate TEST_COUNT objects on every CPU except one, and then free all of
+ * the objects from that one CPU.
+ */
+static void remote_free_phase1(struct slab_thread *t)
+{
+	/* Perform no allocations on the freeing CPU */
+	if (t->cpu == t->ctx->single_cpu)
+		return;
+
+	kmalloc_then_kfree_phase1(t);
+}
+
+static void remote_free_phase2(struct slab_thread *t)
+{
+	struct slab_ctx *ctx = t->ctx;
+	unsigned int nr = 0;
+	unsigned int cpu, i;
+
+	/* All frees are completed on a single CPU */
+	if (t->cpu != ctx->single_cpu)
+		return;
+
+	bench_start(&t->free);
+	for_each_online_cpu(cpu) {
+		struct slab_thread *remote = &ctx->threads[cpu];
+
+		for (i = 0; i < remote->alloc.ops; i++) {
+			u8 *p = remote->objs[i];
+
+			*p = 16;
+			kfree(p);
+		}
+		nr += remote->alloc.ops;
+	}
+	bench_stop(&t->free, nr);
+}
+
+/*
+ * Allocate TEST_COUNT objects for each of the other CPUs on a single CPU (the
+ * producer) while all of the other CPUs (the consumers) free the objects as
+ * soon as they are handed over.
+ */
+static void alloc_n_free_produce(struct slab_thread *t)
+{
+	struct slab_ctx *ctx = t->ctx;
+	unsigned int nr = 0;
+	unsigned int cpu, i;
+
+	bench_start(&t->alloc);
+	for (i = 0; i < TEST_COUNT; i++) {
+		for_each_online_cpu(cpu) {
+			u8 *p;
+
+			if (cpu == t->cpu)
+				continue;
+
+			p = kmalloc(ctx->size, TEST_GFP);
+			if (!p)
+				goto out;
+
+			/* Use object */
+			*p = 17;
+			/* Pairs with smp_load_acquire() in the consumer */
+			smp_store_release(&ctx->threads[cpu].objs[i], p);
+			nr++;
+		}
+	}
+out:
+	bench_stop(&t->alloc, nr);
+	/* No more objects will be handed over, e.g. if an allocation failed */
+	smp_store_release(&ctx->producer_done, true);
+}
+
+static void alloc_n_free_consume(struct slab_thread *t)
+{
+	struct slab_ctx *ctx = t->ctx;
+	unsigned int nr;
+	u8 *p;
+
+	bench_start(&t->free);
+	for (nr = 0; nr < TEST_COUNT; nr++) {
+		for (;;) {
+			/*
+			 * Check whether the producer is done before looking
+			 * for the object so that no object is missed.
+			 */
+			bool done = smp_load_acquire(&ctx->producer_done);
+
+			/* Pairs with smp_store_release() in the producer */
+			p = smp_load_acquire(&t->objs[nr]);
+			if (p)
+				break;
+			if (done)
+				goto out;
+			cpu_relax();
+		}
+
+		*p = 18;
+		kfree(p);
+	}
+out:
+	bench_stop(&t->free, nr);
+}
+
+static void alloc_n_free_phase1(struct slab_thread *t)
+{
+	if (t->cpu == t->ctx->single_cpu)
+		alloc_n_free_produce(t);
+	else
+		alloc_n_free_consume(t);
+}
+
+static int slab_thread_fn(void *data)
+{
+	struct slab_thread *t = data;
+	struct slab_ctx *ctx = t->ctx;
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
+static int slab_run_concurrent(void (*phase1)(struct slab_thread *t),
+			       void (*phase2)(struct slab_thread *t),
+			       size_t size,
+			       struct bench_stat *alloc,
+			       struct bench_stat *free)
+{
+	struct slab_ctx ctx = {
+		.phase1 = phase1,
+		.phase2 = phase2,
+		.size = size,
+	};
+	struct slab_thread *t;
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
+	ctx.single_cpu = cpumask_first(cpu_online_mask);
+
+	for_each_online_cpu(cpu) {
+		t = &ctx.threads[cpu];
+		t->ctx = &ctx;
+		t->cpu = cpu;
+		t->objs = kvcalloc_node(TEST_COUNT, sizeof(*t->objs),
+					GFP_KERNEL, cpu_to_node(cpu));
+		if (!t->objs) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		t->task = kthread_create_on_node(slab_thread_fn, t,
+						 cpu_to_node(cpu),
+						 "slab_kunit/%u", cpu);
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
+		kvfree(t->objs);
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
+ * Test 3: Concurrently allocate TEST_COUNT objects on all CPUs, then
+ * concurrently free them.
+ */
+static void slab_test_concurrent_kmalloc_then_kfree(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	size_t size;
+	int cpus;
+
+	for (size = TEST_MIN_SIZE; size <= CONCURRENT_MAX_SIZE; size <<= 1) {
+		cpus = slab_run_concurrent(kmalloc_then_kfree_phase1,
+					   kmalloc_then_kfree_phase2,
+					   size, &alloc, &free);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!alloc.ops) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %d cpus, %llu ops: kmalloc -> %s, kfree -> %s\n",
+			   size, cpus, alloc.ops, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+/*
+ * Test 4: Concurrently allocate and immediately free objects on all CPUs.
+ */
+static void slab_test_concurrent_kmalloc_kfree_pair(struct kunit *test)
+{
+	struct bench_stat pair, unused;
+	char buf[BENCH_FMT_LEN];
+	size_t size;
+	int cpus;
+
+	for (size = TEST_MIN_SIZE; size <= CONCURRENT_MAX_SIZE; size <<= 1) {
+		cpus = slab_run_concurrent(kmalloc_kfree_pair_phase1, NULL,
+					   size, &pair, &unused);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!pair.ops) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %d cpus, %llu ops: kmalloc/kfree pair -> %s\n",
+			   size, cpus, pair.ops, bench_fmt(buf, &pair));
+	}
+}
+
+/*
+ * Test 5: Concurrently allocate TEST_COUNT objects on all CPUs but one, then
+ * free all of the objects from that one CPU.
+ */
+static void slab_test_remote_free(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	size_t size;
+	int cpus;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "remote free requires at least 2 online CPUs");
+
+	for (size = TEST_MIN_SIZE; size <= CONCURRENT_MAX_SIZE; size <<= 1) {
+		cpus = slab_run_concurrent(remote_free_phase1,
+					   remote_free_phase2,
+					   size, &alloc, &free);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!alloc.ops) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %d cpus, %llu ops: kmalloc -> %s, remote kfree -> %s\n",
+			   size, cpus, alloc.ops, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+/*
+ * Test 6: Allocate objects on one CPU while all other CPUs concurrently free
+ * them.  The cost of a free includes the time that a consumer spent waiting
+ * for the producer to hand over the object.
+ */
+static void slab_test_alloc_n_free(struct kunit *test)
+{
+	char alloc_buf[BENCH_FMT_LEN], free_buf[BENCH_FMT_LEN];
+	struct bench_stat alloc, free;
+	size_t size;
+	int cpus;
+
+	if (num_online_cpus() < 2)
+		kunit_skip(test, "1 alloc N free requires at least 2 online CPUs");
+
+	for (size = TEST_MIN_SIZE; size <= CONCURRENT_MAX_SIZE; size <<= 1) {
+		cpus = slab_run_concurrent(alloc_n_free_phase1, NULL,
+					   size, &alloc, &free);
+		KUNIT_ASSERT_GT(test, cpus, 0);
+
+		if (!alloc.ops) {
+			kunit_info(test, "size %zu: unable to allocate objects\n", size);
+			continue;
+		}
+
+		kunit_info(test, "size %zu: %d cpus, %llu ops: kmalloc -> %s, remote wait+kfree -> %s\n",
+			   size, cpus, alloc.ops, bench_fmt(alloc_buf, &alloc),
+			   bench_fmt(free_buf, &free));
+	}
+}
+
+static struct kunit_case slab_test_cases[] = {
+	KUNIT_CASE(slab_test_kmalloc_then_kfree),
+	KUNIT_CASE(slab_test_kmalloc_kfree_pair),
+	KUNIT_CASE(slab_test_concurrent_kmalloc_then_kfree),
+	KUNIT_CASE(slab_test_concurrent_kmalloc_kfree_pair),
+	KUNIT_CASE(slab_test_remote_free),
+	KUNIT_CASE(slab_test_alloc_n_free),
+	{}
+};
+
+static struct kunit_suite slab_test_suite = {
+	.name = "slab",
+	.test_cases = slab_test_cases,
+};
+kunit_test_suite(slab_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter <cl@gentwo.org>");
+MODULE_AUTHOR("Mathieu Desnoyers <mathieu.desnoyers@efficios.com>");
+MODULE_AUTHOR("David Rientjes <rientjes@google.com>");
+MODULE_DESCRIPTION("KUnit benchmark test for the slab allocator");

