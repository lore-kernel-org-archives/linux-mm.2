Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1628AC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F36B6B00AC; Fri, 21 Aug 2026 14:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 253ED6B00AD; Fri, 21 Aug 2026 14:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE066B00AE; Fri, 21 Aug 2026 14:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C89D76B00AC
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39C0E16022D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:14 +0000 (UTC)
X-FDA: 85126186908.14.94704DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FA3A80003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWOhLED0;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338692;
	b=mSOe5OdDV9jUGDDfSWeMVU1Td9+m2dsHmXwZ5NkhKmZjbtXl3LqhdWI4HJABaxrtlzevbI
	9BsiAe8dbQv/0nsYU84om0xL58T5vlXZSjXKLrRAbfIOH/IzGv8fQ+XRG2esQgTp3g1E1a
	WBAKSqO0A9MoNZC5bhBQlHSMIPvv0mI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gWOhLED0;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
	b=UA68YvjWJFJXq4vtRlU3pu2HOaq+5RWGmW5IG65j6+Ky0PDTgIyR5wgcQ2MjK1XRR7xhsC
	I6kpBjsmc+nEujop/jp+D5362NtkDMX3FHPqVe4ZHCI9pHiUjPxJDIi1pk9amoaGE7Iof7
	KXjAatNJrAvlea5Gu548UJaX/L8uMa4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
	b=gWOhLED0UTiTgfFNH/tGin9atmfL93ENnG6Uic6Pd3wDl6GC5js35aGazYKcxhaBTvORd7
	Y93dfsg0WYqgn+J9ZOEzj75cYdT9lSbAnvvyEvDXUe9jOBTsYNh1suvbIBdDTatUmzw2n5
	M0eYvr1/rl7oxk70AvP5+sre7ibaLpY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20--Bp02TEnMyKrb8Chn0fp6Q-1; Fri, 21 Aug 2026 14:58:10 -0400
X-MC-Unique: -Bp02TEnMyKrb8Chn0fp6Q-1
X-Mimecast-MFC-AGG-ID: -Bp02TEnMyKrb8Chn0fp6Q_1787338689
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-51c19493ac2so14896761cf.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338689; x=1787943489;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kx9TWcXB6g4zQsYJ1k0m/LLY9asJkpc0FRvOq2JFBz8=;
        b=bu+6WJl9erVunl36TQaN1rKAoYow2DYg03jpi7NiTLZvKL6WcsqmwsZdHB3AIJFUZW
         oSZ5+/3090JRBvBIYslXfFovSfBdaTjbwrpHTt/9yT+t8b8ZmGTgew7djF738MEvmcc6
         euTKa0EDTFvOVhDqXwtIXRY1NLfWeIszxxAeZ6WAD78sqG/UhZfS74K/pKgdTPg5KTop
         D1CCCXXq9w4LYGPTO82/frqIFFV2tM5ORuUmTNGi4Oh5EegNjkkiSMCNS3pqort3fb1Z
         e9lPFJzXcZ1SagldLrBw4MP9ySInWdU8oN3NiYeweUj1rRxZGrN9HNWcIACXIRcwqhOP
         cp5w==
X-Gm-Message-State: AFuF++m7UUR2RpYf0dgDgmyYgiYTmzJqVN4L0umfbv0G9n5qPXZlAjrQ
	qHDsqQRPTBfa0EV/jSBmrys/piH/yYdDashQZfwXcsS9EFs/byd4BIl7Mc0KF7P7s6z8xooxbOp
	ayZayNaBzCn7tqOfS3xhmSHEu8b2Ht6Fpl5CTMls1IdAXFE+rTvQx
X-Gm-Gg: AR+sD10UhT6myZ3DwUU9paN/wJS/MWQCWbyJ1zKHURemKK7CofDbfTwhRSxlJt1SfMa
	okUFH17hkHuUo1mG1wXkUSpd9XSebKq8E+eKAp8UtLwu6BOCsd1zaaVoZ7h8PkRsLqiPgLlcy8F
	pmN4Z/ePdTHC18yxnF02ppROAvfzZX9NHKTos+IelOR2gjF5h78M9I+njwclRdxve+u8zPk7I30
	74R8sxy9nTD6zlt1KJBHWa0F1cgX1QQGTT3nI1Pq9J3FW4Crrb3cCTlJb+eSuf7CSG05AwLWr1y
	dm2er7eykw6wNjW+kJo+lJ4ULZO+ea2kbqCVeA12uZrLxFyuFfSvCVPaEjMtWTmGymqsN4LfCFd
	kEow6DxoMT2tO6/qfkRKFmHV43q/6AyX5JKQxibyCsAGZ
X-Received: by 2002:a05:622a:1496:b0:52d:a4e5:6b3c with SMTP id d75a77b69052e-52df5748a04mr82975981cf.15.1787338689310;
        Fri, 21 Aug 2026 11:58:09 -0700 (PDT)
X-Received: by 2002:a05:622a:1496:b0:52d:a4e5:6b3c with SMTP id d75a77b69052e-52df5748a04mr82975391cf.15.1787338688779;
        Fri, 21 Aug 2026 11:58:08 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e09974c7asm1255941cf.6.2026.08.21.11.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:07 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:00 -0400
Subject: [PATCH 08/11] selftests: cgroup: add memcg cma tests
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-8-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: esq3ms6vVRsZOodoPOd7U9eYOqniblyYtRC3w8URZPI_1787338689
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0FA3A80003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 78ys1tqy5si3bppbybsor15n73dif7kx
X-HE-Tag: 1787338691-700381
X-HE-Meta: U2FsdGVkX199jknT97pm+UhOBIUvMkH8QQlBlAeCm1/jvbpYUwOpmz0btEBsGZdJ+uSorQ1dFakUTReG98OcqVPU5WfVaYWzLOr+OoofVHVBmIVPwndBcvZ10/ul0kJ8Wp8jcDbnSv6lfmNAlOpcsq6KZ//va7ZhyX3FvrT4CZssqOXtDxqUqNbUM+UU0J/6YH6VO6slp8vqBALFWsItX+aaALDXKYYmgKPvqA6HytQPCpkmCRjF68Qeq1jJGVQDuVFjXOxRs2p9A1Hnqm/DWUkP6Vu2vHfUxF8BJ4Ew1p8vXzeqrN8WtzSHXoChmLMLs5bSckFgltMaqKM+cphpXXuhGhSltLVj3PaRvmp0Y0qprB3+Sz37h7pA0yjJljda///EnbNDDrPfGTMCETXOjUfcyD1koo+48DCmoffLnjGCXnMCFvS8lqO9K/INU2vSfVdcG0N1YuBXhVKufkyTxEqUVyYQnXdg0MH1gbCPWe1aoWjYbaEHcWWnynWdYF5R6E9InP/b/gZTBqY2PGnfbRSuxjQSddBx4Ye9IICT2Kd98UH9NU3lfgt51h4z08h3eugi1ze++/yuSARrOfT3NHFAe/9W8eV/m26vPHkDaOb3LAcCnz2bdT5alaBS03zAYN7tsFZY3UM7jZv23nyN/z5Zzr6Q0AwN9JpzMcJKGxWLa+7pYYfc2rSg0JFm59xbbeL1VBATOgy5UEAwzz71HmxD7hmbQUCfoH/97TjEEUIe5jyiuPwgDWqpxGtRD7P234vXTyGcd3UrfomQ7WwFKBHck0oSPqhMNIaJWVh64gSkRHz1iU/CbEY67mnRdKtWvYOPCqdkWr+FxK2oGD5wGiU8zYS0tIRta0vrK+CR4Liywecx/ypPAiVwnbu2vH1gpRNT12wWbEQD995L0mQcaW0aSsqt0XNrzrDCO2ejE25QDAJgX9NstYs0nCXhxcd54tYLucCq78Jv3WEo4gu
 uy2JN5Lq
 WH437YiIg3oUIJBKUoqycu3XO7hlLV0phekUzzKcshWdU6tlLA7QENrSNmmrNpR3PhVzVoh8r0D6exGxkZorBJ8Ngh9yPcw3dGXUiRbqFVaW3UGML+j8pXPULpvAtqiJL5TnaXE5xfBOJCiA4F74KxhnpftR32AGAbKCN8B301bKYDQawKhibSKJmB+y5AO96KEueWGMCZI8TRbEyuG59oIAwI3+Y2K6tqvZUFoeZ9QS2ITPWs7dy/zXRLX5JM2BmYue96GQAPd9Z859gdbdqpZyYgX4er4wIGai6xr6zRzPzypaHeg6jW7pzlFGuqM8KZmhUFliITu2XiJPyDmAFB8LmOuGjlolHq2xr8F2AX+/XNUTkDymS852C6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test_cma_memcg with two simple tests to exercise CMA memcg
accounting using the dma-buf CMA heap
(/dev/dma_heap/default_cma_region).

test_cma_charge allocates a 4MB buffer in the default CMA area, verifies
memory.cma.reserved.current increased by that amount, then frees the
buffer and verifies that the counter returns to its original value.

test_cma_limit sets memory.cma.reserved.max to 2MB, attempts a 4MB
allocation in the default CMA area and verifies it fails as expected.

Skip the test if memory_cma_accounting is not enabled on the cgroupfs.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/.gitignore       |   1 +
 tools/testing/selftests/cgroup/Makefile         |   2 +
 tools/testing/selftests/cgroup/test_cma_memcg.c | 193 ++++++++++++++++++++++++
 3 files changed, 196 insertions(+)

diff --git a/tools/testing/selftests/cgroup/.gitignore b/tools/testing/selftests/cgroup/.gitignore
index 952e4448bf07..b9a4298d4944 100644
--- a/tools/testing/selftests/cgroup/.gitignore
+++ b/tools/testing/selftests/cgroup/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 test_core
+test_cma_memcg
 test_cpu
 test_cpuset
 test_freezer
diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/selftests/cgroup/Makefile
index e01584c2189a..601d930160a4 100644
--- a/tools/testing/selftests/cgroup/Makefile
+++ b/tools/testing/selftests/cgroup/Makefile
@@ -8,6 +8,7 @@ TEST_PROGS     := test_stress.sh test_cpuset_prs.sh test_cpuset_v1_hp.sh
 TEST_GEN_FILES := wait_inotify
 # Keep the lists lexicographically sorted
 TEST_GEN_PROGS  = test_core
+TEST_GEN_PROGS += test_cma_memcg
 TEST_GEN_PROGS += test_cpu
 TEST_GEN_PROGS += test_cpuset
 TEST_GEN_PROGS += test_freezer
@@ -24,6 +25,7 @@ include ../lib.mk
 include lib/libcgroup.mk
 
 $(OUTPUT)/test_core: $(LIBCGROUP_O)
+$(OUTPUT)/test_cma_memcg: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpu: $(LIBCGROUP_O)
 $(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
 $(OUTPUT)/test_freezer: $(LIBCGROUP_O)
diff --git a/tools/testing/selftests/cgroup/test_cma_memcg.c b/tools/testing/selftests/cgroup/test_cma_memcg.c
new file mode 100644
index 000000000000..b5b5ea140518
--- /dev/null
+++ b/tools/testing/selftests/cgroup/test_cma_memcg.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+
+#include <linux/limits.h>
+#include <sys/mman.h>
+#include <stdio.h>
+#include <string.h>
+#include <fcntl.h>
+#include <linux/dma-heap.h>
+#include <sys/ioctl.h>
+#include "kselftest.h"
+#include "cgroup_util.h"
+
+#define CMA_HEAP_DEFAULT_PATH	"/dev/dma_heap/default_cma_region"
+#define CMA_RESERVED_CURRENT	"memory.cma.reserved.current"
+#define CMA_RESERVED_MAX	"memory.cma.reserved.max"
+
+static int cma_heap_alloc(int heap_fd, size_t size)
+{
+	struct dma_heap_allocation_data data = {
+		.len = size,
+		.fd_flags = O_RDWR | O_CLOEXEC,
+	};
+
+	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &data) < 0)
+		return -1;
+
+	return data.fd;
+}
+
+static int test_cma_charge(const char *root)
+{
+	int heap_fd = -1, buf_fd = -1;
+	int rc = KSFT_FAIL, in_cg = 0;
+	size_t size = 4UL << 20;
+	long before, after;
+	char *cg;
+
+	cg = cg_name(root, "memcg_cma_charge");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	heap_fd = open(CMA_HEAP_DEFAULT_PATH, O_RDONLY | O_CLOEXEC);
+	if (heap_fd < 0) {
+		ksft_print_msg("cannot open CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	before = cg_read_long(cg, CMA_RESERVED_CURRENT);
+
+	buf_fd = cma_heap_alloc(heap_fd, size);
+	if (buf_fd < 0) {
+		ksft_print_msg("cannot allocate in CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	after = cg_read_long(cg, CMA_RESERVED_CURRENT);
+
+	if (after - before < (long)size) {
+		ksft_print_msg(
+			"invalid CMA counter after charge: before=%ld after=%ld\n",
+			before, after);
+		goto cleanup;
+	}
+
+	close(buf_fd);
+	buf_fd = -1;
+
+	after = cg_read_long(cg, CMA_RESERVED_CURRENT);
+	if (!values_close(before, after, 3)) {
+		ksft_print_msg(
+			"invalid CMA counter after uncharge: before=%ld after=%ld\n",
+			before, after);
+		goto cleanup;
+	}
+
+	rc = KSFT_PASS;
+
+cleanup:
+	if (buf_fd >= 0)
+		close(buf_fd);
+	if (heap_fd >= 0)
+		close(heap_fd);
+
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
+static int test_cma_limit(const char *root)
+{
+	int heap_fd = -1, buf_fd = -1;
+	int rc = KSFT_FAIL, in_cg = 0;
+	size_t size = 4UL << 20;
+	char *cg;
+
+	cg = cg_name(root, "memcg_cma_limit");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	if (cg_write(cg, CMA_RESERVED_MAX, "2M")) {
+		ksft_print_msg("cannot set CMA limit (%m)\n");
+		goto cleanup;
+	}
+
+	heap_fd = open(CMA_HEAP_DEFAULT_PATH, O_RDONLY | O_CLOEXEC);
+	if (heap_fd < 0) {
+		ksft_print_msg("cannot open CMA heap (%m)\n");
+		goto cleanup;
+	}
+
+	buf_fd = cma_heap_alloc(heap_fd, size);
+	if (buf_fd >= 0) {
+		ksft_print_msg("CMA limit not enforced.\n");
+		close(buf_fd);
+	} else
+		rc = KSFT_PASS;
+
+cleanup:
+	if (heap_fd >= 0)
+		close(heap_fd);
+
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
+#define T(x) { x, #x }
+struct cma_memcg_tests {
+	int (*fn)(const char *root);
+	const char *name;
+} tests[] = {
+	T(test_cma_charge),
+	T(test_cma_limit),
+};
+#undef T
+
+int main(int argc, char *argv[])
+{
+	char root[PATH_MAX];
+	int has_memory_cma_acc, i;
+
+	ksft_print_header();
+	ksft_set_plan(ARRAY_SIZE(tests));
+
+	has_memory_cma_acc = proc_mount_contains("memory_cma_accounting");
+	if (has_memory_cma_acc < 0)
+		ksft_exit_skip("cannot query cgroup mount option.\n");
+	else if (!has_memory_cma_acc)
+		ksft_exit_skip("CMA accounting is disabled.\n");
+
+	if (cg_find_unified_root(root, sizeof(root), NULL))
+		ksft_exit_skip("cgroupfs is not available.\n");
+
+	if (cg_read_strstr(root, "cgroup.controllers", "memory"))
+		ksft_exit_skip("memory controller is not available (CONFIG_CGROUP_MEMCG?)\n");
+
+	for (i = 0; i < ARRAY_SIZE(tests); ++i) {
+		switch (tests[i].fn(root)) {
+		case KSFT_PASS:
+			ksft_test_result_pass("%s\n", tests[i].name);
+			break;
+		case KSFT_SKIP:
+			ksft_test_result_skip("%s\n", tests[i].name);
+			break;
+		default:
+			ksft_test_result_fail("%s\n", tests[i].name);
+			break;
+		}
+	}
+
+	ksft_finished();
+}

-- 
2.53.0


