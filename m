Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB11FCD6E53
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED8F6B0095; Fri, 29 May 2026 21:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F796B0098; Fri, 29 May 2026 21:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3A426B0095; Fri, 29 May 2026 21:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB96A6B0095
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:14:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82CB5C0157
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:14:03 +0000 (UTC)
X-FDA: 84822314766.18.F508D4D
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8F4131A0002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:14:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rCabFY/e";
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780103641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JemCq4xOu13sv+NHnX0mdoKsOWsBmY6CG/eWTvjKDMs=;
	b=h1t5Lyt4SymknCCsW6NXcua+zcNCS0wUYzLhWxXTwWQ0x28rt1yk81dYUIJvlx1irfLOLr
	1ARHh3GUP73M4IE28I3TCuSCoG+GZAwx/vT9CAOxhBlMRtgA+uf6PgVhrk42pF3ySh5+en
	mFDmo5vRlB/Tg/JvjA1x44X7qJCWMYs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rCabFY/e";
	spf=pass (imf19.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780103641; a=rsa-sha256;
	cv=none;
	b=ov82x9tJAFfARsEuRx5ywRchupssLMdbIqiry4fLZYniCfJbS5io73Yngu0Kb0p6FKcZK+
	+e53sECl1i+htj30XSdP6zGG5J0ZsefQXYsmj0nHVhMrJC5Uouv5BkKaGooBDPurxb6lCg
	Ne4c4B9BHcqxhLz4zrwX1yDp1SnAMig=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2bd266f6fc0so71381265ad.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 18:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780103640; x=1780708440; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JemCq4xOu13sv+NHnX0mdoKsOWsBmY6CG/eWTvjKDMs=;
        b=rCabFY/eyP/q4h4z7p6MWTOqQ+xUQ+vMAjk5hqq/xr5N14ZrQRviZB27W/AObj3mMV
         lfuCO6AwLTzAHqcuNueATViCcGHV5aNeT1c7Pi+3wRrYmTSmJ8HPOuHRmPvaP0XzDnw+
         w1yRx7CXPv+TWHtWSuAUcLQkWHo0BkVgX8ffp3M0P8YdmNS3BIJT5FqPmzObPFG98Xnf
         5U1WMGAavVZZixGBkeqjFlt3RsK+kPXnjg2iwWmuCow8SfKW+iB5wrYUMWzl8bgHKVct
         uhbPcp5XdZD2Dr9oFRZfyo6incF1LW5DdIAPQCTuY+d8ZzrK8CKbBFpNhsWZ5a22Q8pB
         jrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780103640; x=1780708440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JemCq4xOu13sv+NHnX0mdoKsOWsBmY6CG/eWTvjKDMs=;
        b=ESlpMYiFSaiSdV/KbHjl1Elh6EXSqmIMgxdjOmHamg74RU909GvXAg6p/Vyt3m/XXM
         uwxct0QDECZ0vBY9nBRWkqK/lfHutAZxWvxbLj8Cdvyym5jqtuTY31VjNnzZIU09361y
         SyoomUWlxEzK5ktr8rikhJyck5Kn+IS1BDG//25XAeB56PiUWCXiMpk29MaBk7TB2K2J
         bIfjELw+90KMFbhYaxkWYHSLeBQqrupxomXRqx2MrWnK9ntwopyHKt+k0LfHTQ07QS4G
         1KNqxjHweeuFdXlaiVprFdcb/Edqk8x9aNs1c6hFVEPovAZ2y6LuIj8y82dzuGqCGYFl
         jm/g==
X-Forwarded-Encrypted: i=1; AFNElJ9fpvae8NrXKBtRZsxMjMGbYcJC3Fsx6I27ucl++gvukr+Uw+NKpkyA9b8W5u8OJNqLMP6yTzFb8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx3lgpC4i2VEInNbba9J3AiHlCWXO1G9QGcJUTj49aYphiAwCyM
	JhsuJkEsXgSlHA90dPhN88VXWTJ9QH+IZWTJ2MBEVVvI0RCAT6XM17m/
X-Gm-Gg: Acq92OFMVQhSl+oY+gyIcqURFVlUzk+UvY2ExEX8F+1a27/zGGkS2Lot7sNjdFjZpsX
	TbUbzpMB6+s0iJF+2dPT1CvieukbFX4Olo9O+mojRkGokRTVF/UIlxIkoAXZmSHkjyMyTTbT5lI
	f4dHweVnHGxAPK2LfdZcUVjaBrQTrn8vAb1O7bbj/R4dmVR0OQIDMRYJlM3fhO4Z+xrrZW0bKfQ
	+DHPuWCMLZgYIRvNtyrTFeqFp+pJZt6bOxovY7T9Cmd3MzNxZwMVrqv01zgNEReHv50DVN4ODt4
	7UHQi5wKTDTNCrQAGdtJrQKKDNKA3Y+TXG6SzJwuaxuJmeV+p+N0/rEPuJB/iQiEXLZVc1u13pV
	IQHWuJsBcmInPJv3vzPd3JQNSfw31F4ZTd7aMf3xC2rVRT9ZuryeWN4u8CLCuNh3d2LE9mI9PlZ
	U1jrw5LI/JIka9fmsuWRRPmaruKvctuB34wCgXUhWc7p1FghNVO7VYYx7u+sVo8mQuqdUAEU+yj
	DA1tmhGLiE/qFFpQyZuo2oSzRKiAr42yK74gBAnYJZolszrm1iMcW8Mc4viHrDU2NaRAAAz
X-Received: by 2002:a17:903:1905:b0:2bd:d7c5:9272 with SMTP id d9443c01a7336-2bf3679f5c3mr26348515ad.6.1780103640226;
        Fri, 29 May 2026 18:14:00 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm31712065ad.25.2026.05.29.18.13.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 18:13:59 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 bpf-next 4/4] selftests/bpf: Add tests for arena slub-backed allocator
Date: Fri, 29 May 2026 18:13:44 -0700
Message-ID: <20260530011345.99342-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
References: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqfiktug3yokotds6k8i68aju1adm4hi
X-Rspamd-Queue-Id: 8F4131A0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780103641-2377
X-HE-Meta: U2FsdGVkX1/XUvVrhP+UxmD7z2/jjTbBu/Ze/ugu6NYeET5Gtc99zgAwEzxwc1XAR+4KcswwxdnafIlcDnqLb3uzVmuyCNaCpHKwaeZpreRGy6UYmNQeCLdK2g1WFXZ3le23emt6FAFeMAEbVRucb6vEFL1auj08vywr8epSYjCfuq7C4FS+2RTcUAukgFtbQSvgICfYhMFvtWOZCP9fvU1LwtZ9R9KQUKveE1J/63Q+1D5u4aWrIsvuBH0AaAdPVFVC2a3qmUkfN7+bM4oVAo3sjTS4ytTUcxWREiF+KjwuXApjYjR5Kr38vHofNbfKOMIaCvn2s+okjK+CkOBJd6tJXEuUih3CaoQL6PelNWtJLSebX4Yybyb3x8T/tV4cVDDvjB7ooXsBj7yBsr0RQttsK00UpSNcrpPiAG16nS2Gjr8Wrp226zt7ywFvNg2DRApbOebX6VYWDQEakKeTwO7i8sZ3q/ncN8bpGLIgb+M4wvZcDLu6VYvPoVeNjPby4yPbZkj4ZUYqMflwwDs0EVVOBwB1scGLDGeOayFZfuFP0NlvrxZ4tWS5Mp9lpEy5SZy0ayoG2G+5pMBxljPP7KmPa0gA3g7WNoeWkgIvD6e1aqJiri1XbJG+DB214sQ6pCSPAPg/hu88CYSeyHpbZdmYfRe5XZz4ag9kA/tJWX2XyKmvIVRzrz85uNSrf35axcqmfa+WxZRgRQJwI1w/7DHiRKZ+fzX8hFOnXK5fa0RhHpC2jWj/WyBEcKpknwGb1UM1+TmbM/uCGZuI5O31rJNGvMhxz6c5PbAgHMJe0wgwkvohLh19T2nPZ/NmI55KKHGG+14VkTlNh83Lhchq8fZA3h0BMpfLkVhnCx7mrikLTGAsE3iqvlS4G3bXnVPcqTP14E44NmSoxsr4swrEOmxchgMYbsIydtDEaU2vPaaCkvZrtRCCvjuVRbgBMGjyUeCAoEii6M+miuV25cR
 aYCRo70p
 xsM6msWVugx2tKjknd31DVnxfkZrf1yXohR6rNuEbgNG33ttVs+wGqMJBtOWJBxfovuu4zlCZ1XsxHcfAawS5wrbQZRQaXO5DLi5vd1eLEN4VsqCh0sKjdc1t+5BiWFUXMMYir3Esuq3Si/aTzqMYUcKt4HkiNoxbNYAw5ibiNZNVXbde9XFlfn0dg51a3ii6n1SoXtuKJ7z6ss3Pb3NJVSr3HgAcJ0RMUCgWQwlbnM6+/DKHkq0otKLmReNel3e1OLKAZFwZl97Azej6NhaGTk7RJfWzGkCLXbxWDjtGiFK5+K2fvYbFEc0iLzJNsJyQp0mCQK1ESDeehnkO90hbnTLpC67TSwk8F5qj+EwcJxhDcpjv4oQaYR3Vp62Qmmy0LLDtV1J1aeRPanRHU/nN5mTpcSY7X1MuhLVnEMK3dwAoAOwU9pOlrc/HdO17R4nRkgbtMYuozSyt5yKXNhUbUkT5L8fyX7VFpm7q4qQX+9Tr+gbMgDvPnFg03sm8By1bgk5gFnmwHZ/uWa5nSZFLF1O+Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Cover the SLAB_BPF_ARENA path end-to-end:

  - arena_slab: smoke tests for the bpf_arena_alloc/free kfuncs.
  - arena_slab_freeptr_stale_pcs: exercise corrupted in-object
    freepointers to validate get_freepointer() clamping and the
    __refill_objects_node() bounded walk.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 .../selftests/bpf/prog_tests/arena_slab.c     |  59 ++++++
 .../prog_tests/arena_slab_freeptr_stale_pcs.c |  28 +++
 .../testing/selftests/bpf/progs/arena_slab.c  | 179 ++++++++++++++++++
 .../bpf/progs/arena_slab_freeptr_stale_pcs.c  | 120 ++++++++++++
 4 files changed, 386 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/arena_slab.c b/tools/testing/selftests/bpf/prog_tests/arena_slab.c
new file mode 100644
index 000000000000..6cbaa6991c6b
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/arena_slab.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#include <test_progs.h>
+#include "arena_slab.skel.h"
+
+void test_arena_slab(void)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	struct arena_slab *skel;
+	int ret;
+
+	skel = arena_slab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "arena_slab__open_and_load"))
+		return;
+
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_alloc), &opts);
+	ASSERT_OK(ret, "alloc_run");
+	ASSERT_OK(opts.retval, "alloc_retval");
+	ASSERT_EQ(skel->bss->alloc_failed, 0, "no alloc failures");
+
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_free), &opts);
+	ASSERT_OK(ret, "free_run");
+	ASSERT_OK(opts.retval, "free_retval");
+	ASSERT_EQ(skel->bss->free_done, 1, "free completed");
+
+	/* Realloc to make sure freed objects can be returned again. */
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_alloc), &opts);
+	ASSERT_OK(ret, "realloc_run");
+	ASSERT_EQ(skel->bss->alloc_failed, 0, "no alloc failures after free");
+
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_free), &opts);
+	ASSERT_OK(ret, "free_run_2");
+
+	/*
+	 * defer_free() corruption repro. Allocates CORRUPT_N PAGE_SIZE
+	 * objects, then with local IRQs disabled frees each one and
+	 * immediately overwrites its freepointer slot. With IRQs off the
+	 * irq_work IPI raised by defer_free() is deferred; multiple
+	 * defer_free()d objects chain onto the per-cpu llist via the
+	 * poisoned freepointer slots. After local_irq_restore() the IPI
+	 * fires and free_deferred_objects() walks the corrupted llist,
+	 * oopsing on a pre-fix kernel. The spin_trylock __slab_free()
+	 * fix keeps the freed objects out of any in-object llist, so the
+	 * test completes cleanly.
+	 */
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_defer_corrupt), &opts);
+	ASSERT_OK(ret, "defer_corrupt_run");
+	ASSERT_OK(opts.retval, "defer_corrupt_retval");
+	ASSERT_EQ(skel->bss->corrupt_alloc_failed, 0, "no alloc failures in defer_corrupt");
+	ASSERT_EQ(skel->bss->corrupt_done, 1, "defer_corrupt completed");
+
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.arena_slab_leak), &opts);
+	ASSERT_OK(ret, "leak_run");
+	ASSERT_OK(opts.retval, "leak_retval");
+	ASSERT_EQ(skel->bss->leak_alloc_failed, 0, "no alloc failures in leak");
+	ASSERT_EQ(skel->bss->leak_done, 1, "leak completed");
+
+	arena_slab__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c b/tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c
new file mode 100644
index 000000000000..fbf4f5a7e4b3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include "arena_slab_freeptr_stale_pcs.skel.h"
+
+void test_arena_slab_freeptr_stale_pcs(void)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	struct arena_slab_freeptr_stale_pcs *skel;
+	int ret;
+
+	skel = arena_slab_freeptr_stale_pcs__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "arena_slab_freeptr_stale_pcs__open_and_load"))
+		return;
+
+	ret = bpf_prog_test_run_opts(
+		bpf_program__fd(skel->progs.arena_slab_freeptr_stale_pcs),
+		&opts);
+	ASSERT_OK(ret, "arena_slab_freeptr_stale_pcs_run");
+	ASSERT_OK(opts.retval, "arena_slab_freeptr_stale_pcs_retval");
+	ASSERT_EQ(skel->bss->alloc_failed, 0, "initial allocs");
+	ASSERT_EQ(skel->bss->drain_failed, 0, "drain sheaf allocs");
+	ASSERT_EQ(skel->bss->cycle_alloc_failed, 0, "self-cycle alloc");
+	ASSERT_EQ(skel->bss->cycle_alloc_mismatch, 0, "cycle returned victim");
+	ASSERT_EQ(skel->bss->stale_alloc_null, 1, "stale sheaf alloc rejected");
+	ASSERT_EQ(skel->bss->done, 1, "stale pcs trigger completed");
+
+	arena_slab_freeptr_stale_pcs__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/arena_slab.c b/tools/testing/selftests/bpf/progs/arena_slab.c
new file mode 100644
index 000000000000..738a48c45da3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/arena_slab.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Meta Platforms, Inc. and affiliates. */
+#define BPF_NO_KFUNC_PROTOTYPES
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "bpf_experimental.h"
+#include "bpf_arena_common.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARENA);
+	__uint(map_flags, BPF_F_MMAPABLE);
+	__uint(max_entries, 256); /* number of pages */
+#ifdef __TARGET_ARCH_arm64
+	__ulong(map_extra, 0x1ull << 32);
+#else
+	__ulong(map_extra, 0x1ull << 44);
+#endif
+} arena SEC(".maps");
+
+void __arena *bpf_arena_alloc(void *map, __u32 size) __ksym __weak;
+void bpf_arena_free(void *map, void __arena *ptr) __ksym __weak;
+void bpf_local_irq_save(unsigned long *flags) __ksym;
+void bpf_local_irq_restore(unsigned long *flags) __ksym;
+
+#define N 64
+#define LARGE_N 2
+#define CORRUPT_N 8
+#define LEAK_N 16
+
+int alloc_failed;
+int free_done;
+int corrupt_alloc_failed;
+int corrupt_done;
+int leak_alloc_failed;
+int leak_done;
+
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+static __u8 __arena *objs[N];
+static __u8 __arena *large_objs[LARGE_N];
+static __u64 __arena *corrupt_objs[CORRUPT_N];
+
+/* Sizes > PAGE_SIZE force bpf_arena_alloc() onto the arena_alloc_pages() fallback. */
+static const __u32 large_sizes[LARGE_N] = {
+	PAGE_SIZE + 1,
+	3 * PAGE_SIZE,
+};
+#endif
+
+SEC("syscall")
+int arena_slab_alloc(void *ctx)
+{
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+	int i;
+
+	for (i = 0; i < N; i++) {
+		__u32 size = 8U << (i & 7); /* 8, 16, 32, ... 1024 */
+		__u8 __arena *p = bpf_arena_alloc(&arena, size);
+
+		if (!p) {
+			alloc_failed = i + 1;
+			return 0;
+		}
+		/*
+		 * Write a sentinel that depends on the slot — proves the object
+		 * is real arena memory and not aliased with another slot.
+		 */
+		p[0] = (__u8)(i + 1);
+		p[size - 1] = (__u8)(i + 1);
+		objs[i] = p;
+	}
+
+	/*
+	 * Exercise the >PAGE_SIZE fallback. bpf_arena_alloc() routes these
+	 * through arena_alloc_pages(); bpf_arena_free() recovers page_cnt
+	 * from page->private and tears the range back down.
+	 */
+	for (i = 0; i < LARGE_N; i++) {
+		__u32 size = large_sizes[i];
+		__u8 __arena *p = bpf_arena_alloc(&arena, size);
+
+		if (!p) {
+			alloc_failed = N + i + 1;
+			return 0;
+		}
+		/* Touch first, middle, and last byte to exercise every mapped page. */
+		p[0] = (__u8)(N + i + 1);
+		p[size / 2] = (__u8)(N + i + 1);
+		p[size - 1] = (__u8)(N + i + 1);
+		large_objs[i] = p;
+	}
+#endif
+	return 0;
+}
+
+SEC("syscall")
+int arena_slab_free(void *ctx)
+{
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+	int i;
+
+	for (i = 0; i < N; i++) {
+		if (!objs[i])
+			continue;
+		bpf_arena_free(&arena, objs[i]);
+		objs[i] = NULL;
+	}
+	for (i = 0; i < LARGE_N; i++) {
+		if (!large_objs[i])
+			continue;
+		bpf_arena_free(&arena, large_objs[i]);
+		large_objs[i] = NULL;
+	}
+	free_done = 1;
+#endif
+	return 0;
+}
+
+SEC("syscall")
+int arena_slab_defer_corrupt(void *ctx)
+{
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+	unsigned long flags;
+	int i;
+
+	for (i = 0; i < CORRUPT_N; i++) {
+		corrupt_objs[i] = bpf_arena_alloc(&arena, 4096);
+		if (!corrupt_objs[i]) {
+			corrupt_alloc_failed = i + 1;
+			return 0;
+		}
+	}
+
+	/*
+	 * IRQs off so defer_free()'s irq_work IPI accumulates the chain across
+	 * iterations instead of draining between each free.
+	 */
+	bpf_local_irq_save(&flags);
+	for (i = 0; i < CORRUPT_N; i++) {
+		bpf_arena_free(&arena, corrupt_objs[i]);
+		/*
+		 * Freepointer slot for non-debug caches is at object_size/2;
+		 * 2048 for the 4096-byte bucket. Poison defer_free()'s next.
+		 */
+		corrupt_objs[i][2048 / sizeof(__u64)] = 0xdeadbeefdeadbeefULL;
+	}
+	bpf_local_irq_restore(&flags);
+
+	corrupt_done = 1;
+#endif
+	return 0;
+}
+
+/*
+ * Intentional leak across multiple bucket caches; destroyed arena must
+ * still tear down cleanly (no kmem_cache_destroy() WARN, no leak).
+ */
+SEC("syscall")
+int arena_slab_leak(void *ctx)
+{
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+	int i;
+
+	for (i = 0; i < LEAK_N; i++) {
+		__u32 size = 16U << (i & 7); /* 16, 32, ..., 2048 */
+		__u8 __arena *p = bpf_arena_alloc(&arena, size);
+
+		if (!p) {
+			leak_alloc_failed = i + 1;
+			return 0;
+		}
+		p[0] = (__u8)(i + 1);
+	}
+	leak_done = 1;
+#endif
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c b/tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c
new file mode 100644
index 000000000000..79aeccabaeb4
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0
+#define BPF_NO_KFUNC_PROTOTYPES
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_experimental.h"
+#include "bpf_arena_common.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARENA);
+	__uint(map_flags, BPF_F_MMAPABLE);
+	__uint(max_entries, 256);
+#ifdef __TARGET_ARCH_arm64
+	__ulong(map_extra, 0x1ull << 32);
+#else
+	__ulong(map_extra, 0x1ull << 44);
+#endif
+} arena SEC(".maps");
+
+void __arena *bpf_arena_alloc(void *map, __u32 size) __ksym __weak;
+void bpf_arena_free(void *map, void __arena *ptr) __ksym __weak;
+void bpf_preempt_disable(void) __ksym;
+void bpf_preempt_enable(void) __ksym;
+
+#define OBJ_SIZE __PAGE_SIZE
+#define FREEPTR_OFFSET (OBJ_SIZE / 2)
+#define SHEAF_FILL 4
+#define TARGET_IDX SHEAF_FILL
+#define EXTRA_IDX (TARGET_IDX + 1)
+#define NR_OBJS (EXTRA_IDX + 1)
+
+int alloc_failed;
+int drain_failed;
+int cycle_alloc_failed;
+int cycle_alloc_mismatch;
+int stale_alloc_null;
+int done;
+
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+static __u8 __arena *objs[NR_OBJS];
+#endif
+
+SEC("syscall")
+int arena_slab_freeptr_stale_pcs(void *ctx)
+{
+#ifdef __BPF_FEATURE_ADDR_SPACE_CAST
+	__u8 __arena *victim, *p;
+	__u64 raw;
+	int i;
+
+	for (i = 0; i < NR_OBJS; i++) {
+		objs[i] = bpf_arena_alloc(&arena, OBJ_SIZE);
+		if (!objs[i]) {
+			alloc_failed = i + 1;
+			return 0;
+		}
+		objs[i][0] = i + 1;
+	}
+
+	bpf_preempt_disable();
+
+	/* Fill the per-cpu sheaf so the next free reaches SLUB proper. */
+	for (i = 1; i <= SHEAF_FILL; i++)
+		bpf_arena_free(&arena, objs[i - 1]);
+
+	victim = objs[TARGET_IDX];
+
+	/*
+	 * The PAGE_SIZE-bucket cache has one object per slab and a 4-object
+	 * sheaf. Free @victim while the sheaf is full, then turn its encoded
+	 * NULL freepointer into any non-NULL decoded value. The arena clamp
+	 * keeps non-NULL decoded values in the same slab and object-aligned,
+	 * so this becomes a freelist self-cycle back to @victim.
+	 */
+	bpf_arena_free(&arena, victim);
+	raw = *(__u64 __arena *)(victim + FREEPTR_OFFSET);
+	*(__u64 __arena *)(victim + FREEPTR_OFFSET) = raw ^ 1;
+
+	for (i = 0; i < SHEAF_FILL; i++) {
+		p = bpf_arena_alloc(&arena, OBJ_SIZE);
+		if (!p) {
+			drain_failed = i + 1;
+			goto out;
+		}
+	}
+
+	p = bpf_arena_alloc(&arena, OBJ_SIZE);
+	if (!p) {
+		cycle_alloc_failed = 1;
+		goto out;
+	}
+	if (p != victim)
+		cycle_alloc_mismatch = 1;
+
+	for (i = 0; i < SHEAF_FILL; i++)
+		bpf_arena_free(&arena, victim);
+
+	/*
+	 * The sheaf is full of duplicate victim pointers now. Free the four
+	 * filler objects plus one extra object directly to SLUB, leaving enough
+	 * partial slabs that the next target-slab zero-inuse transition discards
+	 * the target page instead of keeping it on the partial list.
+	 */
+	for (i = 0; i < SHEAF_FILL; i++)
+		bpf_arena_free(&arena, objs[i]);
+	bpf_arena_free(&arena, objs[EXTRA_IDX]);
+
+	bpf_arena_free(&arena, victim);
+
+	p = bpf_arena_alloc(&arena, OBJ_SIZE);
+	if (!p)
+		stale_alloc_null = 1;
+
+	done = 1;
+out:
+	bpf_preempt_enable();
+#endif
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.53.0-Meta


