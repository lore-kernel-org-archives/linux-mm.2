Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A923C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCB56B0098; Tue, 21 Jul 2026 13:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A867D6B0099; Tue, 21 Jul 2026 13:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9771C6B009F; Tue, 21 Jul 2026 13:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 470FA6B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:16:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3310120242
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:16:47 +0000 (UTC)
X-FDA: 85013438454.19.52160AD
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id D1EDB10000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:16:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uiJ8RiA3;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
	b=RIyid5BiwiPJadI8yBtWinSrxcVOQN5a9SUv2AB5jrYJyid0j70DmChjGlDOnPGP7HbEfC
	ePQ91w7pTnQpyZNvg+wf0Icit8itreFnABNjRHE/qeTmCORsfJHGlvjFzWZTOmgastM2yE
	SZNoIIttEj15xOPC+HoxSt3vsicvFto=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uiJ8RiA3;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654206;
	b=3mRaS4NalUoxsanTfMKGU3c7D3V/dUlBRzj7dl15Q2xtHLcMVyc+DX9O+B8DuS4Qdi7fk2
	plYGIhoaTAzNXfYPPkA6N2sLyX+lEb6XKUl10P1isXDYlsHMlSq+pFAMiA08x+zInaFmaG
	nWnGgPXc11oVssgKiaMwUPAv0fTrBKQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51bfbe05683so105880391cf.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784654205; x=1785259005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
        b=uiJ8RiA34Im+cuJsQESdLqAxw3wdSP7RifsOvM5ANw62YXGt312nDb05m4RAAgsXoq
         MWdj1zsUroVZN8FnEx8WdMjSZ7GmK/Xb6SU1QOgV3a3CuglMvlstJWobwFqVqS1nxt+W
         tsL2tXrDB9+HmAYG+NXulYP6Lkkq2+CpaCQy8Osbn829M3Ywfgk7in1SjCvVypt4o+jI
         WgCcgoAC6QiEirprVXPronRzT31Bvb5qqQTKQQeHN+HVx9AgBQ9apaextAQZGGFgk2U4
         YxF743Tu/9nHsToNxNUpkkm2XCbuh4ApSU6q+b5KgDyDiLTNi9sH9KVv0vnLsbY/RlOl
         rGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784654205; x=1785259005;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
        b=BW+YwmeI2+2jHPq1U3T2KTZqVruGnAjsvXJlEylxianpwr6wUZnarhPqiYExc4s02u
         ZocBdzSQTaRPDAdvJrXxthm6ybpH73OBrKhIPhiv2AXXusR8BGJwoALFJ48sxZtDtbGM
         O83N10Ub5TtCWZdgUicjUir2gOGsvgoiGd8n5ki4bv7Zt2/VmMj2Lja/W+S/dsCY4dAC
         z6+bp6uV1ESgO4cNfBiDYErhthG/jDpvsYdWKOE2ItxHbluWVUdlx+pGN3jh3iQvDDNF
         SvLqDdgWrquZu65Iu43bdJvIdo7RG3ug1QLVEiQ+7U19Y+4YQ90E73OUf/n+qMSslree
         GH8w==
X-Gm-Message-State: AOJu0YwZVIT8gJ7DCz23f6rkzkvJKkS9l7XUn1Y173tyeP2VNpbjSWud
	BEMKg35uDBsULyttvLTBAtL8MNQMoMnIlHygVYbQLwVdwJOrbIFWKXEfh/ySk/MA3zOTfhSXyRV
	JqvDq
X-Gm-Gg: AfdE7cntt4Ruq0g9NCq3Kx89MTUCUi7YkONh2CI1kHocFEjgQaqA850zBlQMrD5TJzH
	TilcnkRxQVX0W5oqZuhxTQ6DaGqx3sCG7ueI7cHynRTG0VtTMX1xum6xflKfTYSsGaYiW8z/UKq
	40NnggwWmnpYniikqbtaiPPTsNwS7E3+mJE7/x7X2VlEjBz3MYYGLdR2nlsT3g/FfOvNkVlIRmX
	/uRkfZAZQS9L9rZUuODxdHjAe/vpKV86CvCroxRqoQ7VXf4i54j027nynqzEZrW2LhpBGEhPCWR
	lCKEHXgNlNpP/tosPPhD4QF8k+G/ChtzQBuiQgCBhYkXBubJIogb1L4i9DLfS4jW+/aIOW5bBZ+
	AYbbWclSycV2iSFPSbUlkuh293RQkxzAxiUGHSa6KGdhuldXZKpjwz5PN8+QKZrU6++Xn+mOYCn
	DagNQZgd551/EHImmnlgMRt7IMI4XODE39dzhANW8xvqv1hDPeYrp6koKhJEyAuZc=
X-Received: by 2002:a05:622a:d0e:b0:527:6d4a:192d with SMTP id d75a77b69052e-5276d4a1cfcmr16581381cf.68.1784654204752;
        Tue, 21 Jul 2026 10:16:44 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-526627e6a2csm22323121cf.7.2026.07.21.10.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:16:44 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v5 36/36] KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
Date: Tue, 21 Jul 2026 13:16:39 -0400
Message-ID: <20260721171639.112406-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1EDB10000A
X-Stat-Signature: 78be3j6shz6t4q3a8e77nbak7yjyfhhn
X-HE-Tag: 1784654205-117363
X-HE-Meta: U2FsdGVkX1/Howb4BsuHSRtGQ+5pf1q8TqeKdu8sLlHDVr2YWbZcKSN8dp5/1UjfhN+NYVAWSnToMXdXdBXgPajbnuTkVUX/sKmbKtucUe+rtghyLEPXxpykfr/s78La2ySPu9/GJlQhKWaq43jI4DlZNWm8IuD5phcpWj9khq7J86LKcM03qG8jNK1dqGiTiMI5dsTqozMoU8C49alskliUKuZKsVz2Jncm0hMFiQqU8Q7DRkvxsfoW/Qs0LJ5DJeIJY7rBCAFSVWyGhneo7YuyGTMVLl4rFD15ZHmF2rvbAYEWKCI1YDZtjAb9VKKt8d4lpzR4TITbyBKtHqMeJxcbHe6sSfqHFLzT5ZonL3G2aEVW2c3Rk+3ZB75WzYCb8XYTLpGk3ODFAo3d4VUmerbamp1VUHbm9+8EYotJLwD+RQki3j0E9JaolsQS+V/B1+zhDAGQbDc5AEWbrwofEVq4uSVkii/gOb0J4Zci0XW7VhHONjRAWFpXfQaXMsSHu0Ip+sk6GRqXfdnyWeSfj71w/5meVveYBX08xxdUGhSZA1ahx+WypC7rRXxaYkZjOkKTxqr1PZuShRjiOqbNdTqMIzUN8AGZxsLAgNUFX0Dwii7I6C2y8fIRROvcbH79ntyF80jiHtf2Ro4GXWM4Woi3SD+b8p1B0I4tqCbOI6++INs8iRaqlqxQGn5TMG4yvPZy74OI0mstEsX+4lVKt/n0XgTurW1eLr8N/35c8vJElGlOZIgJ2NRa564fLUzKMUqmTaVg3gISom4BCUaTG10zTmejUI4NGd72u+e4QKUS/dDEFeHP9N58BQpqIZBbRdvHJ5BG0oBDzp0fPaX/F25iQ9zqoCwbO6+2AN4TKJbmeJwKyWSD4dOlXwh9QM1dzPprtk49qTJ1Egk9YKG4AzwvEslt6xQSwPTN15504IH5zWtBXYI9SepkVjIy6CF1/kyfuNWvOJhhM8Z6VYb
 CLclSRkd
 uZNFll22/MLh8BG1L6dAxVZ2/r8uYjlRTlOiYYUUErxoQZZ7wClo11G/xctvzuC4riXVBYtTQj9i2wBzgQwPmNcx3Fp8xUNMko0fXqArOK7ZIJZpiv+LtVOeUJzKo/SzqC42QDJDWc8W0UBZGMjoBweAzFpPQX2MayV6WnsPdVNqPTGXUbondsLiAkjX50B+coaOgY9dka0PO/sFqbNmbiL6HDNHwRV50qeqb2lyauN/Cjx0hNhYqi9O6Suz7yto4pVzQWP5TpCGaMUoDUGwoOViScRzJj75r41UPjk4J8lN2hez5/y4uHHigLCzF0V/b6qkCxBAzTVhAwBZXrowex/ltsWgGoxreNWyvwiM0ObC+vAOBxKgwArSw9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a standalone test for GUEST_MEMFD_FLAG_BIND_NODE.

It creates a guest_memfd bound to a given node, mmaps and faults it
from the host, and checks with move_pages(2) that every folio landed
on that node - with no userspace mbind().

It also covers the rejection paths with -EINVAL
  - a nonzero pad
  - an out-of-range node
  - a node supplied without the flag

An unbindable (memoryless/offline) node is rejected at create time.

It uses a default (non-protected) VM so the host can fault the fd to
observe placement, and needs CONFIG_NUMA.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../kvm/guest_memfd_bind_node_test.c          | 213 ++++++++++++++++++
 2 files changed, 215 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_bind_node_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index d28a057fa6c2d..f0ddb5cc39db9 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -155,6 +155,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_memfd_bind_node_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += mmu_stress_test
 TEST_GEN_PROGS_x86 += rseq_test
@@ -194,6 +195,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
 TEST_GEN_PROGS_arm64 += guest_memfd_test
+TEST_GEN_PROGS_arm64 += guest_memfd_bind_node_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
 TEST_GEN_PROGS_arm64 += rseq_test
 TEST_GEN_PROGS_arm64 += steal_time
diff --git a/tools/testing/selftests/kvm/guest_memfd_bind_node_test.c b/tools/testing/selftests/kvm/guest_memfd_bind_node_test.c
new file mode 100644
index 0000000000000..6f33b1ae6c42a
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_bind_node_test.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Standalone test for GUEST_MEMFD_FLAG_BIND_NODE.
+ *
+ * Verifies that a guest_memfd created with GUEST_MEMFD_FLAG_BIND_NODE allocates
+ * its folios on the requested NUMA node, without any userspace mbind().
+ *
+ * The folio placement is checked with move_pages(2) (status query mode).
+ *
+ * Self-contained:
+ *   - issues the KVM ioctls directly
+ *
+ * Build inside the guest:
+ *   gcc -O2 -o guest_memfd_bind_node_test guest_memfd_bind_node_test.c
+ *
+ * Usage: guest_memfd_bind_node_test <target_node>
+ */
+#define _GNU_SOURCE
+#include <err.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <linux/kvm.h>
+#include "kselftest.h"
+
+/* Mirror the (proposed) uapi additions in case the host headers lag. */
+#ifndef GUEST_MEMFD_FLAG_MMAP
+#define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
+#endif
+#ifndef GUEST_MEMFD_FLAG_INIT_SHARED
+#define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#endif
+#ifndef GUEST_MEMFD_FLAG_BIND_NODE
+#define GUEST_MEMFD_FLAG_BIND_NODE	(1ULL << 2)
+#endif
+#ifndef KVM_CAP_GUEST_MEMFD_FLAGS
+#define KVM_CAP_GUEST_MEMFD_FLAGS	244
+#endif
+
+struct gmemfd_args {
+	__u64 size;
+	__u64 flags;
+	__u32 node;
+	__u32 pad;
+	__u64 reserved[5];
+};
+
+/* True if the node has any memory (MemTotal > 0). */
+static int node_has_memory(int node)
+{
+	char path[128];
+	char line[256];
+	FILE *f;
+	long total = -1;
+
+	snprintf(path, sizeof(path),
+		 "/sys/devices/system/node/node%d/meminfo", node);
+	f = fopen(path, "r");
+	if (!f)
+		return 0;
+	while (fgets(line, sizeof(line), f)) {
+		if (strstr(line, "MemTotal:")) {
+			if (sscanf(line, "Node %*d MemTotal: %ld kB", &total) == 1)
+				break;
+		}
+	}
+	fclose(f);
+	return total > 0;
+}
+
+static long move_pages_status(void *addr)
+{
+	void *pages[1] = { addr };
+	int status[1] = { -1 };
+	long ret;
+
+	ret = syscall(SYS_move_pages, 0, 1, pages, NULL, status, 0);
+	if (ret)
+		err(1, "move_pages");
+	return status[0];
+}
+
+int main(int argc, char **argv)
+{
+	int kvm, vm, gmem, ret;
+	long page_size = sysconf(_SC_PAGESIZE);
+	size_t size = page_size * 4;
+	int target_node;
+	struct gmemfd_args ga = {};
+	char *mem;
+	size_t i;
+
+	if (argc != 2)
+		ksft_exit_skip("usage: %s <target_node>\n", argv[0]);
+	target_node = atoi(argv[1]);
+
+	kvm = open("/dev/kvm", O_RDWR);
+	if (kvm < 0)
+		ksft_exit_skip("open /dev/kvm: %s\n", strerror(errno));
+
+	/*
+	 * Use a default (non-protected) VM: it has no private memory, so it
+	 * advertises GUEST_MEMFD_FLAG_INIT_SHARED, which lets the host mmap and
+	 * fault the gmem (needed to observe placement with move_pages()).  A
+	 * SW-protected VM would not advertise INIT_SHARED and the host fault
+	 * would SIGBUS.
+	 */
+	vm = ioctl(kvm, KVM_CREATE_VM, 0UL);
+	if (vm < 0)
+		ksft_exit_skip("KVM_CREATE_VM: %s\n", strerror(errno));
+
+	{
+		long caps = ioctl(vm, KVM_CHECK_EXTENSION,
+				  KVM_CAP_GUEST_MEMFD_FLAGS);
+
+		printf("KVM_CAP_GUEST_MEMFD_FLAGS = 0x%lx\n", caps);
+		if (!(caps & GUEST_MEMFD_FLAG_BIND_NODE))
+			ksft_exit_skip("BIND_NODE flag not advertised (need CONFIG_NUMA)\n");
+		if (!(caps & GUEST_MEMFD_FLAG_INIT_SHARED))
+			ksft_exit_skip("INIT_SHARED not advertised; cannot fault from host\n");
+	}
+
+	/* Negative: pad must be zero. */
+	ga = (struct gmemfd_args){ .size = size,
+				   .flags = GUEST_MEMFD_FLAG_BIND_NODE,
+				   .node = target_node, .pad = 1 };
+	ret = ioctl(vm, KVM_CREATE_GUEST_MEMFD, &ga);
+	if (!(ret < 0 && errno == EINVAL))
+		errx(1, "nonzero pad should be rejected (ret=%d errno=%d)", ret, errno);
+	printf("OK: nonzero pad rejected\n");
+
+	/* Negative: out-of-range node. */
+	ga = (struct gmemfd_args){ .size = size,
+				   .flags = GUEST_MEMFD_FLAG_BIND_NODE,
+				   .node = 1 << 20 };
+	ret = ioctl(vm, KVM_CREATE_GUEST_MEMFD, &ga);
+	if (!(ret < 0 && errno == EINVAL))
+		errx(1, "bogus node should be rejected (ret=%d errno=%d)", ret, errno);
+	printf("OK: out-of-range node rejected\n");
+
+	/*
+	 * Negative: node set without the flag.  Only meaningful for a nonzero
+	 * node: node 0 is indistinguishable from "node field unset".
+	 */
+	if (target_node != 0) {
+		ga = (struct gmemfd_args){ .size = size, .flags = 0,
+					   .node = target_node };
+		ret = ioctl(vm, KVM_CREATE_GUEST_MEMFD, &ga);
+		if (!(ret < 0 && errno == EINVAL))
+			errx(1, "node without flag should be rejected (ret=%d errno=%d)",
+			     ret, errno);
+		printf("OK: node-without-flag rejected\n");
+	}
+
+	/* Positive: bind to target_node, mmap, fault, verify placement. */
+	ga = (struct gmemfd_args){
+		.size = size,
+		.flags = GUEST_MEMFD_FLAG_BIND_NODE | GUEST_MEMFD_FLAG_MMAP |
+			 GUEST_MEMFD_FLAG_INIT_SHARED,
+		.node = target_node,
+	};
+	gmem = ioctl(vm, KVM_CREATE_GUEST_MEMFD, &ga);
+	if (gmem < 0) {
+		/*
+		 * A node that cannot be bound - memoryless/offline, or a private
+		 * node that did not opt into userspace placement - must be
+		 * rejected at create with EINVAL (mpol_bind_node() fails), not
+		 * produce an opaque failure later.
+		 */
+		if (!node_has_memory(target_node) && errno == EINVAL) {
+			printf("OK: unbindable node %d rejected with EINVAL\n",
+			       target_node);
+			return 0;
+		}
+		err(1, "KVM_CREATE_GUEST_MEMFD(bind node %d)", target_node);
+	}
+	if (!node_has_memory(target_node))
+		errx(1, "FAIL: unbindable node %d should have been rejected",
+		     target_node);
+	printf("OK: created gmem fd=%d bound to node %d\n", gmem, target_node);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, gmem, 0);
+	if (mem == MAP_FAILED)
+		err(1, "mmap gmem");
+
+	/* Fault every page in (no mbind on this mapping). */
+	memset(mem, 0xaa, size);
+
+	for (i = 0; i < size / page_size; i++) {
+		long node = move_pages_status(mem + i * page_size);
+
+		printf("page %zu -> node %ld (want %d)\n", i, node, target_node);
+		if (node != target_node)
+			errx(1, "FAIL: page %zu landed on node %ld, wanted %d",
+			     i, node, target_node);
+	}
+
+	printf("PASS: all %zu pages on node %d via FLAG_BIND_NODE (no mbind)\n",
+	       size / page_size, target_node);
+
+	munmap(mem, size);
+	close(gmem);
+	close(vm);
+	close(kvm);
+	return 0;
+}
-- 
2.53.0-Meta


