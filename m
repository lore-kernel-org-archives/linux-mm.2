Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C874606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MjgapjCp
Received: by kanga.kvack.org (Postfix)
	id 376CA6B05B3; Wed,  4 Nov 2026 20:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327B06B05B4; Wed,  4 Nov 2026 20:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216AB6B05B5; Wed,  4 Nov 2026 20:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0A4C6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:53:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BED15808EF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:53:34 +0000 (UTC)
X-FDA: 85399393548.14.472C8B5
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 18D50120004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:53:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MjgapjCp;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793843613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+1mhMcZ6wBwJDhXjji70I1zijmhMiV3vbRPegD9QPv4=;
	b=LfBciS4n9pKtwZeTdDJc0Egst/TbyVT0Qt77HNPmXw1+V25DjHSYLyDafwZik+h/Ngedd6
	q3gATl3ZfxxnPDSIXYZZ4GTfrteceFYoezNAAbGGT4UucfHNzcnLZQrFXeE1HwnIRY0NFa
	rMn9HI5ZM2dr+yUFf0Ura1uz+4IZsO8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MjgapjCp;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793843613;
	b=C5TxkzxbH8D1bBg4e7o+vuiX5Nb8/QRTgXqhdS5lOfMmL0iUN5ZMaRCQ+lm+1zt/6k6C03
	VywM/b0OriD7gTHMfAAXpQ91fNEo3lXOJ25dNyrflBjbEz6kk2jH7MRSHOld1WUb9DPxzf
	w8+wuKe/c/g4+Z6teg+s9Z6AKZJ65zw=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so21775ad.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 17:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793843612; x=1794448412; darn=kvack.org;
        h=content-type:mime-version:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+1mhMcZ6wBwJDhXjji70I1zijmhMiV3vbRPegD9QPv4=;
        b=MjgapjCpIxmSEQnPNz1/ymn+H1cac9vN0MeJHXLhC61Kea5eXawrAe0U1b7au9OIdb
         m91t7wov0I7WQSxybcFZI4kn2Glf9meIWT6dB1A24CDM4wbQG4x/NEcIxc1Gw8jNZv3N
         OXoig9wc3ec820neGSJKvN0PxDBaxshY/VIsP1UnpjBegBECQVK+v4A18H0LSEsiQ/Ek
         /GlLvcdxqVh8bjq0VevuI3iqOgfYRkoWGFnhAT+Exx/h6+HbLA8QJOZF0+avrryG6COw
         mBgFKTvKjKXH0os0/h4JE7ytDqwfWY43LZVbqyP6necHK9dBLMkboHWuTDPRAo32n4Wz
         4rKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793843612; x=1794448412;
        h=content-type:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+1mhMcZ6wBwJDhXjji70I1zijmhMiV3vbRPegD9QPv4=;
        b=v/ekACVwsRO8sctLv/5gcxNXfWhoyDzyzseBQEMNcLVsoU42Kebjibmfj4Ru4YcpEH
         R+uO3++sadHcyApGanzym/0qhI3vJI8czJuWbzFZd1fLrsBwBCdcGVf5KO+i4HGOUVn2
         5f6LQRb45i/zwa8gtAgw3ZSdVDRFSfPDhki7VnhIS4QS+pHMQ6paikBJgDAUCZuXKCYQ
         hXobj2u87wH2BduyJjdFFqr+9o87qGsfWAmy7nnp7NML2pZDJlKNaloUw/gRWQ+glZlJ
         +lkXLntdPTK82BKiqErDkgRLTVauwIP7Lcy4CHLZ4Q0Q+FhqyLfWeU9ThYuVrZakzHJO
         0rTA==
X-Forwarded-Encrypted: i=1; AKwUvBylJnfHy1BktL9txk5Z+uLLIcXu/CEKg8Ta3W9PCKfUurrD8VSwGWNUsA0mVui+ji6RPOrJ7EtrVA==@kvack.org
X-Gm-Message-State: APuU4Z809DnyEpLlMbojdOlI0gAuDeV9p9sHSNAfAaYKIG4q3ZUGnKTx
	nBS1cB9mZJMQnSvjX32BjgWddms+wR8Q6upd+3vUxVpYtvlZ/SWBYlcyPiHxjOUAVA==
X-Gm-Gg: AYBFou23FQiPvPTb1ytpMVtLefGSjjBWJwv7CAdksPFnX+dBchprDHdgnLXdlC7bOIk
	ooQLm9yr+hy9yAyPdpOJywvTr56QSWqESCZfr+4r5cCwXo1nLGMi7B6VUo5KoftVLy73mmFD2Jk
	wJ9fq2l+oikLu0Z5k1u+iWngXI4KXDITuQdLBaLdKnHM8tGx9S33vxXvUCTG0XAqiwobf7aJ1f8
	OP8JB0XzpW74D6WUz1Vg/ZyiY8w+V8GHzUIXrbXYTkTOTs9U4j40Ys33XTHttYYajMUNHQScB0N
	3JBQepl1kDqEaCM/OLL/Vdi9tfTDnLouWlFZF/UWwgvAiDPv+oDN/aGbGjDQ/WmwNbVulVw46ks
	ojAZ4K9CXyp0oNvtR4YZ5KLIrsfqPJziVuK7s7Ti9BWLmFeoCQvGLyC7cEj8ryXJbYDRSwNN1XE
	B4gXPs641fYn2WEXwIXkjoBlHlHrsUXxibqp+vjCfvXc3ttJHLS3t2q8RCnesmsXjhHgwHU++sB
	CkuhANISb6tAvYLTKwxTdQ/acd47OO/c7Xl7qC3QvbRIZWjg+Tc1u5LtfX4mnPEYXpajNMYBd+K
	hpl26NZ+ZDthduINNRcOn6Da48blS0EbB+jh+uiw7sUe2FcYTMXb6Dd8gkxCE/sSCQ/N1jO2g/i
	lyNCNs+ruv77R9GlW6fcLycF/W4wEAGhNnxYG6fmD+cgwMKx7w/2CNp/gJSWYwFFTZY7AiqiYIW
	Pt2SaPABjel3Er40XSeiRN59qETYFYCe+0i+WnoofMQZxr
X-Received: by 2002:a17:903:32cd:b0:2e9:5a0b:9f3 with SMTP id d9443c01a7336-2ed27dd6431mr1871075ad.7.1793843611246;
        Wed, 04 Nov 2026 17:53:31 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:d9a2:1982:1881:ce82] ([2a00:79e0:2eb4:9:d9a2:1982:1881:ce82])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b90def97sm539539a91.7.2026.11.04.17.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 17:53:30 -0800 (PST)
Date: Wed, 4 Nov 2026 17:53:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>
cc: Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
    Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch v6] mm: vmstat_kunit: add synthetic benchmark for mm stats
Message-ID: <21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: ihw84gs56ff7zpxdi1bjz5hbk8y1qasg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 18D50120004
X-HE-Tag: 1793843612-741805
X-HE-Meta: U2FsdGVkX1/2ySYKV/nX0ERqu4AhFcOd4c9h5izlnpoxU9scLF4bVaBLLIwgahaXLMs/VLnFdqiwRXfaAl8NTa7gOqrqhKHNvuLEMgO8+nNsm8X+aJeKjIHkj2ekIvhxbpax1wf+/bO+1QvfM1G2x9bGtXwFde210J6IUgJweerQc3BgALVXiNYaaLNH/+rJCBVfFnG3ITOkE4iPtFx64Cfw3GrCEWsHVgi4ZaBX7lrMIXlF5URxg4H8qMHFO0Mm2DBhnTn1z64tlRU+biYgV5TetBuQvDopT7BC1O01WLewZU8uhZ94BmjOU+qEBHVl1Dm4vUT7Y97qsuX+ExHn/BJzUJEYZU+Y+jvmw1mfL76rmfB4GpvSaGFSv/FINki9Rcznp7wd2Xn+U/NazWFADetyKxmyeKuicacvuKnWg9b6EXArF/ObqxYrP0FDewWHXW7Hf5OJOVpTE8cpOPxTbLJUEADSDXzXrwR6HuGtDreQaDYH0nuGT8IHH3vo2UNjyQvEQQFul6pvmVW6dHEKF6uG2xU+02XjQGm6oo/t8cUGZ5X2POSCr7i3i4SoWkfHl9DIikWgqR3RlY/vrZEPAiaiRekh9rWGfIV/QrqitRHCSO4PN7pryTaX9Kt85CP2pYdskWTEEli0sA9VuhkOcpkOfbyM4RFigEoJu51SZqu/2HQFsKRJ3VQBN7/aR2dLFv5G/ts1MdAHnk+3TxeKXIDVuv+HEfdS3Hg44sD01jQvAVFaSqaeSlZf9RS6WlsXB9AG1Fg+eSy4pEfnS3/YFUjhX9850IBarenS3Q+cgwjh0gnwYXWnDxRn82y2bgIpPSAAq8GLofcrS0cssixGKDOsvOkvToGyYV3meTe62IndJ+u2lDT1XYw1AhegY6Ss8dViPcxB4bxKZfbKPMUIHMV7JCajuxU/dwCmv1ne919a3t17JsPuBt8Gj/GKyNA/Q/0dVq5louurRKYJKyq
 tAmSDMZP
 7va+QshS1FsqllBoceQHrzDRI4V7uFGCX+3XeXmCi4xqRbhaxszEng5bu1yeAVwLgQSA1mvG3i/X7fsOXo406hNyACK5xLC80bwE0avC15R05vT6tidBwjLFhONjdMglMDRchJKK6sYOn7CAFQ6pw0iOPABVlVoYKFvqnXKlsHUZ4WyZFmQ8XA2BSvYj//yGjyisPuc0L8eOas7MSSMVPkntFt9PJF6hT8qmDkdq7MoDUlYqvPl+QyOBN2xYykMdCJYtKDcgn5/kjJceppQgIffiz1eEqgHan+TJH4b+M7i4PJ7cwuSJp6sjqA4/2xSsf5LvESPQVv0kWp35qdgOTmImVy5ZpFzLsM0FUHz4BJCJh5ShFr1YiSlerDWz9U0tEcYJBPSnF7FPM+p/UvHPOs6uNAy1C2GyZCpANpfHDl64Fa9ptAweft5tnlIyhkKf/khzEANGMWJihqQiZbO6dJ8bApg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of MM
statistics.  This is used to analyze any improvements or regressions in
functions that are frequently used in hot code paths.

This is the first of three tests that measure the execution times of
critical MM functions anticipated to be used by developers to measure the
impact of any core changes that would end up causing workload performance
issues.  Vmstats are embedded into MM hotpaths, so any regression can
cause performance and scalability impact for users.  Google has carried
these tests internally and kept them updated since Christoph posted them
back in 2009 for this purpose.

This can also be used to detect regressions over time, from kernel
version to kernel version, independent of development use cases.

The test is run by KUnit or doing modprobe vmstat_kunit directly.

Sample output:
 KTAP version 1
 1..1
 KTAP version 1
 # Subtest: vmstat
 # module: vmstat_kunit
      1..3
      # vmstat_test_inc_dec_zone_page_state: 10000 ops: inc_zone_page_state -> 8 cycles (4 ns/op), dec_zone_page_state -> 9 cycles (4 ns/op)
      ok 1 vmstat_test_inc_dec_zone_page_state
      # vmstat_test_interleaved_zone_page_state: 10000 ops: inc/dec pair -> 17 cycles (8 ns/op)
      ok 2 vmstat_test_interleaved_zone_page_state
      # vmstat_test_count_vm_event: 10000 ops: count_vm_event -> 4 cycles (2 ns/op)
      ok 3 vmstat_test_count_vm_event
 # vmstat: pass:3 fail:0 skip:0 total:3
 # Totals: pass:3 fail:0 skip:0 total:3
 ok 1 vmstat

Assisted-by: Gemini:gemini-3.8-flash
Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
v6:
 - rebase on top of 7.4-rc1
 - resend per akpm

DavidH said "Works for me. The tests are rather small and I see value in
them." and I was this >< close to infering that as his Acked-by, but will
leave it to him to do that explicitly.

Once we're happy with this change, I'll apply the same treatment to the
proposed pgalloc and slab tests.

 MAINTAINERS             |   1 +
 mm/Kconfig              |  12 +++
 mm/Makefile             |   1 +
 mm/tests/vmstat_kunit.c | 157 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 171 insertions(+)
 create mode 100644 mm/tests/vmstat_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 93abbb315065..c6aa67db55cd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17551,6 +17551,7 @@ F:	mm/mmzone.c
 F:	mm/pagewalk.c
 F:	mm/pgtable-generic.c
 F:	mm/ptdump.c
+F:	mm/tests/vmstat_kunit.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..33f269f6e8da 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1490,6 +1490,18 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config VMSTAT_KUNIT_TEST
+	tristate "KUnit test for VM statistics" if !KUNIT_ALL_TESTS
+	depends on VM_EVENT_COUNTERS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test and benchmark the performance of VM
+	  statistics updates (zone page state and VM event counters), which
+	  are used frequently in hot memory management code paths.
+
+	  If unsure, say N.
+
 config ARCH_HAS_CHECK_WX
 	bool
 
diff --git a/mm/Makefile b/mm/Makefile
index 2a3ec53d62ee..b671c5060a3a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,4 +148,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_VMSTAT_KUNIT_TEST) += tests/vmstat_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/vmstat_kunit.c b/mm/tests/vmstat_kunit.c
new file mode 100644
index 000000000000..899c957091d1
--- /dev/null
+++ b/mm/tests/vmstat_kunit.c
@@ -0,0 +1,157 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * KUnit synthetic performance benchmark for VM statistics.
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ * (C) 2026 Google LLC, David Rientjes <rientjes@google.com>
+ */
+#include <kunit/test.h>
+#include <linux/mm.h>
+#include <linux/vmstat.h>
+#include <linux/timex.h>
+#include <linux/ktime.h>
+#include <linux/math64.h>
+
+#define TEST_COUNT 10000
+
+static void vmstat_test_free_page(void *arg)
+{
+	__free_page((struct page *)arg);
+}
+
+/*
+ * Test 1: Sequential inc_zone_page_state() followed by dec_zone_page_state().
+ * Net change to zone counters is 0.
+ */
+static void vmstat_test_inc_dec_zone_page_state(struct kunit *test)
+{
+	struct page *page;
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 inc_cycles, dec_cycles;
+	u64 inc_ns, dec_ns;
+	unsigned int i;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	/* Benchmark inc_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		inc_zone_page_state(page, NR_MLOCK);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	inc_cycles = div_u64(time, TEST_COUNT);
+	inc_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	/* Benchmark dec_zone_page_state() */
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		dec_zone_page_state(page, NR_MLOCK);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	dec_cycles = div_u64(time, TEST_COUNT);
+	dec_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (inc_cycles || dec_cycles)
+		kunit_info(test, "%u ops: inc_zone_page_state -> %llu cycles (%llu ns/op), dec_zone_page_state -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, inc_cycles, inc_ns, dec_cycles, dec_ns);
+	else
+		kunit_info(test, "%u ops: inc_zone_page_state -> %llu ns/op, dec_zone_page_state -> %llu ns/op\n",
+			   TEST_COUNT, inc_ns, dec_ns);
+}
+
+/*
+ * Test 2: Paired inc_zone_page_state() and dec_zone_page_state().
+ * Net change to zone counters is 0.
+ */
+static void vmstat_test_interleaved_zone_page_state(struct kunit *test)
+{
+	struct page *page;
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 avg_cycles, avg_ns;
+	unsigned int i;
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_ASSERT_EQ(test, kunit_add_action_or_reset(test, vmstat_test_free_page, page), 0);
+
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++) {
+		inc_zone_page_state(page, NR_MLOCK);
+		dec_zone_page_state(page, NR_MLOCK);
+	}
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	time = time2 - time1;
+	avg_cycles = div_u64(time, TEST_COUNT);
+	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (avg_cycles)
+		kunit_info(test, "%u ops: inc/dec pair -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, avg_cycles, avg_ns);
+	else
+		kunit_info(test, "%u ops: inc/dec pair -> %llu ns/op\n",
+			   TEST_COUNT, avg_ns);
+}
+
+/*
+ * Test 3: count_vm_event() benchmark.
+ * Restores counter balance with count_vm_events(item, -TEST_COUNT).
+ */
+static void vmstat_test_count_vm_event(struct kunit *test)
+{
+	cycles_t time1, time2, time;
+	u64 t1_ns, t2_ns;
+	u64 avg_cycles, avg_ns;
+	unsigned int i;
+
+	time1 = get_cycles();
+	t1_ns = ktime_get_ns();
+	for (i = 0; i < TEST_COUNT; i++)
+		count_vm_event(SLABS_SCANNED);
+	t2_ns = ktime_get_ns();
+	time2 = get_cycles();
+
+	/* Restore balance */
+	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+
+	time = time2 - time1;
+	avg_cycles = div_u64(time, TEST_COUNT);
+	avg_ns = div_u64(t2_ns - t1_ns, TEST_COUNT);
+
+	if (avg_cycles)
+		kunit_info(test, "%u ops: count_vm_event -> %llu cycles (%llu ns/op)\n",
+			   TEST_COUNT, avg_cycles, avg_ns);
+	else
+		kunit_info(test, "%u ops: count_vm_event -> %llu ns/op\n",
+			   TEST_COUNT, avg_ns);
+}
+
+static struct kunit_case vmstat_test_cases[] = {
+	KUNIT_CASE(vmstat_test_inc_dec_zone_page_state),
+	KUNIT_CASE(vmstat_test_interleaved_zone_page_state),
+	KUNIT_CASE(vmstat_test_count_vm_event),
+	{}
+};
+
+static struct kunit_suite vmstat_test_suite = {
+	.name = "vmstat",
+	.test_cases = vmstat_test_cases,
+};
+kunit_test_suite(vmstat_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter <cl@gentwo.org>");
+MODULE_AUTHOR("David Rientjes <rientjes@google.com>");
+MODULE_DESCRIPTION("KUnit benchmark test for VM statistics");

