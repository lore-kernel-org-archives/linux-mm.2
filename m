Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81390CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4A1F6B00A7; Fri, 29 May 2026 16:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21B66B00A9; Fri, 29 May 2026 16:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39326B00AA; Fri, 29 May 2026 16:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 985EF6B00A7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:24:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D6D21C1130
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:58 +0000 (UTC)
X-FDA: 84821586276.03.58C1F10
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7FC73A0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:24:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UChFRWOx;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780086296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jk9XDW9v2nLX4lb2JUVfOq7f4ioXiFEnEXu+iktPAaU=;
	b=5fMSRSBwlYvqwSTG61i9lfc/ynUWNmAVHYL2m80x/tHInssrsqvKzzXMVLCwaqdp229ODc
	kYkSY+kwaKaByZ72APk19Y6TN5dSCmcI4Qx8oC3vXBvv4sxxnNhRIANAR9CCCRZ4PuQnhj
	8dTLxYfL3W9Cc8BtNo2Rw4BqfMXPUkg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UChFRWOx;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780086296; a=rsa-sha256;
	cv=none;
	b=ekfOBnl4gMN3zf3OtLMJ7KLhaiC/H0b8iP23EOR+gyRV70slIYEjFe4vGWIRNKdzuJ+kzl
	4SJAfT5VPmyNYC0emfwvGEKVo2F4PivZjOYDnUMsATa0qF5Zg1lN0kUsXotPJbcaEILIFT
	Bd1/p4gGSK1Q35yIRpA61EA7KyN51rM=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c8585cd8400so77692a12.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780086295; x=1780691095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jk9XDW9v2nLX4lb2JUVfOq7f4ioXiFEnEXu+iktPAaU=;
        b=UChFRWOx0IDTl/bkWz6P4odOHIV2rQZAGOKAZyPL0xiFLSqvZEFrM1lHxw/noa2D+V
         CPPoxypp+d/gQjXBxolhmP8yQUB+ySqJueMMQOF21JusCtmX2QDTcJ4+wBfiiXH6GwJA
         /YF8Lv2X/L+YummFg+ch0BOt/ZXaxmn1mzjgSWzuaAijir0M5Wx/6zEbnQnrG0f9qgva
         775wrVRqHes23oWyNPwX4fFs/0FAmee7WSJcn3DUnXEr2+g9lO8IF2CMEn1qV7HbOqsA
         oa0dW+AUvMNk85rwTZ6+JiHA/INOm645lIWqS8Mp4tfMtSQ019jN0CvmmriNYyawL9Hs
         BocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780086295; x=1780691095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jk9XDW9v2nLX4lb2JUVfOq7f4ioXiFEnEXu+iktPAaU=;
        b=Z2IbAV1mNceDJfVRC06SvagAek6US8CJfZnJKR7VsVQujQ673PCqzV/bZK1fgCTrzk
         qcfKwxhvYLBskqSgo+CWLH3c9T5ZA5+u0e+14bp4jQ7Oqj0588vB7Bgfhoul3Myshmn5
         3+WTSqmjyxKnhk8zrs1nLH/CN/EcamdHLDvCecq9vTa2Vrs3FEjs5nET4ZEh4u7VvW0f
         qXqqwJslrfyKL5oPMW9+k9+KUozK9uVNo5ZblpXx5WJ+xolM/xvc6un2NJUxHe8o6eYU
         UHZasJ6+ev1bU9l0/11Acc67YuvxAXcVRbv0fglPp1j9G0yBjbV2mkXmRyWvb/rY441F
         O7fA==
X-Forwarded-Encrypted: i=1; AFNElJ8FX5ArVO9w797QYFoo8BlBDg0+Nk6VAY6+IaJQjez8WVh9300hwNC6p7PWmGbMfRvnfPdU4Tkvfw==@kvack.org
X-Gm-Message-State: AOJu0YwS64wrqXTqgBoKIwqmLwYWxBi/2aPOmb3PaKHqQnk7uze+zO3d
	gobHgYsamn/63cFfrx42QWkoaIseYZkgLafV+ID/gc6mS4IMWHMCP56T
X-Gm-Gg: Acq92OEU2YoyeRCbDoaqMnQvr+d7zD3dUjx58Qng7BHSqWaK1H53QWHjKXi6DXd/YjD
	IhG4aaTu8HpNfCqhVtuq/wMbS4tph/ZNbqLmd7LpzT4numFG1GQuXFvRmQ2D+2ijDciKWcFsRU1
	vM4P8076CLXPT2exvFAoMemTsaOs9IVXkdPLFk+v569tUyPsI0xRlfIqqXl+0PXZWSGKnIUHFRU
	XS3+AxDAdyP9xeDwmhU/Xpb/un/UBq2XApwqL2NP9cvIdHwUUpHxvAVWoM6XQo/aulwq7rT1Zbw
	vtUMNw/loiCV6RTUYxywe4zRPtgeLE9qzYCWAOQcnA4XmpOaEha0LP3Ef+M6oLAR4vL25jjXaNT
	E9Y6pDfPcp6yQGcJgThFVzVKEJiFaX/pzjl9QrA+pvFjiecghBd9JdcK7fCBZFnHmBwu17BMS9m
	gvA6YJ7Kv0uw+SXdKd8WKmnWRLdYap+CZyomn+gjZzjsLC4qoAIWCxn4eo6yx6OXYXW6ybVWT3I
	oAXTYfrgQS8K0i2NomQJTHsMBWmcyU3KA8AtWnofhEXh2UFyHdnBgwiY7diS9CSABp+/7Rp
X-Received: by 2002:a05:6a20:ce4e:b0:3a2:d79c:416c with SMTP id adf61e73a8af0-3b427f97563mr848424637.32.1780086295129;
        Fri, 29 May 2026 13:24:55 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85773e4d91sm2754203a12.31.2026.05.29.13.24.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 13:24:54 -0700 (PDT)
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
Subject: [PATCH bpf-next 4/4] selftests/bpf: Add tests for arena slub-backed allocator
Date: Fri, 29 May 2026 13:24:37 -0700
Message-ID: <20260529202438.16408-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
References: <20260529202438.16408-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FC73A0002
X-Stat-Signature: yxgantcq8ir5kxqtrk9n8aeazd76kaq6
X-HE-Tag: 1780086296-820686
X-HE-Meta: U2FsdGVkX189AZmbhleHoUZYYSSO466H4k1MPNzew51IT4TbFHFH5Tb670DoE7lB3VE1HNl+qLayaGkPFhxZLMW3DcNvbtURat7xBWFIjQYkmzU9Uzncry7JDQjdsKX6vLGwvGooOpNFqWlcbWyW49imfIUl5NSTC5NtFPGI67S4x1k4qYEL+jXNUNKnpkRSr5n/xyCrCuHGTLaG2mlWHqqYtLMlUHL6+JeU0tl8Z2E+8H8eHHZ8cLAhud+Vt5j3jzWZPtppOBQTj+Xy3ol+s8LQGYJHgBnqfA4TzAIlEL72AlVikiWXsTgZZTJXMnktcdcSmUdRMKG5NNogzjsd/N0RU+MCmn2mDNY4v9MqHZGW5XiQ3U2vYplitY/jKsFKPpMUlW0UOtXCuMQaFj9yBgFNBy1/MUaxg3GF3jsYjTF/m1icRM3feUfYtSh5D5Xt1dfL7dTj+vtJ3hEmkSDK0IrcSLvO+wqEAUg4V3ULPCO7/xqWKgFjymQmLOcl/JSd4Swl2MsQhUZM+0wNZsW1K2YCPuOlMXCXzTXTIjHR357rEqQUA0DM6XdRLNt4WUXV8ojcsNsefFcZjqz8EQ87w+SrA5Z94GIJ8qZUHA8OKwX7emr/IOBwasCUTwnbSbS29Ile9LnkGN/KfwrBFsF/4Ax1bB6JYfxXsw6MDPE9S9NGtFvwAqopm8C1J/PpjUJKOzvKS4fsyLnkfrIjKzCxXiPrikYZAUfIULhd2qRCoW+Mq5YJtoX0UzdatqS/u7eKfiT5KJHn1e06JVZI1N+vBeaG1aAOvvCfXztaxRim5HiiD/g5r6CizJWp6/r9pPv8IHgT/+55RjbWVGhAy1dbhPJjp4uE3ZI6hK1KG549d81MvRg97tpW1y/4lZQukfltpKzq9NfJzW6s+nxGL4UqDh1t6VQ2E3QTJCfdoU51QmwrzqQ5Y41cNUY11GOUIOSzOYUw5DT+PS06O6mygav
 SR75JIs/
 ttnputkVJEBDKigXx3VsuuWEXivS+8qHl8a019Lcl7gjQdQkbKPyBCEalYkzCkBRVAFiqGjiUPmKghDcXMdNdYaGZwDxvr8Dx0dPHbCbYJrANNJBywzkCCtV0km2j5jrJ6MG6SZ/Co9e1sq4jzer1FG7PLFuSrBg/D0aQse7NeIswZ6O5FugAJq8tFbxr/CJRvdHNdT1Qk+qIXUxHcJz9iBO6vCm3KWlY2vy+hZ+YptNQPrJaeOgimqxMZynoA/Uhn0UOg+XWpCvsWSNlNmKDqaCKJp7oN3+K6S2uQhgi8oAm1ctJHWaAC3wELBM3ZqItSb0ECc80EJ4qGkrv7H8i9Vn2eTTZUxn9Lsj2fVDzPfAVr1EeHGq1ekSJOE2oDl9fZ/o8RDBlqY4Cz67IFiHT5vsEyP7VVzLH+zeFnVp27rU/xBdpMwNBFHTKx2AUA0pJd0wDpturWQCgFqauhG0JkyGjAR6Byv0Vcxzs5abNdEeT9IB6NsViO8riVah33zfaALZ6raMQwdKbpJN4S7FTDdLytA==
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
index 000000000000..4d23d75419d6
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
+#define OBJ_SIZE 4096
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
+	 * The 4096-byte bucket has one object per slab and a 4-object sheaf.
+	 * Free @victim while the sheaf is full, then turn its encoded NULL
+	 * freepointer into any non-NULL decoded value. The arena clamp keeps
+	 * non-NULL decoded values in the same slab and object-aligned, so this
+	 * becomes a freelist self-cycle back to @victim.
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


