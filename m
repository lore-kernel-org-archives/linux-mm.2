Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 759BAC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 18:06:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAB336B0092; Tue, 21 Jul 2026 14:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AC36B0095; Tue, 21 Jul 2026 14:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A7B6B0099; Tue, 21 Jul 2026 14:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3F36B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:06:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A592B140260
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:06:12 +0000 (UTC)
X-FDA: 85013562984.27.C71F419
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id DF4DF180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 18:06:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WW80aqKW;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784657170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
	b=Nln7YLIK8XM8UVClaMcepJFwAtxKF7m9x7IHftfuaBxNAkNedv7hcysj5NuiJWho91G0B5
	TMsVT2T18k1cGCREIoXxGC+vGxGcy4MjkijkbkddaMukdzB2KIVEfFbD0CZQqUI5gs3L6o
	PSWw/F/z/oftYtuZonkJmDmCsQ+E6pg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784657170;
	b=hQGsQ9DCvjyDxh25icJJFsaebUf3LUf/aAK4TXDUihjND+DLISZd0MMgwrW42Pi//aiIZ8
	q9Hl5N2+1bH1N1SBPXn4WM9axka8RURnMzOWQ+EFj1P3/UxZyOxSvBtEsSF1GVU7L+J6TW
	UulXcZ0mOPjNC5eabN428obwBHxIf5M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WW80aqKW;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8eeb4508f29so117323776d6.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784657170; x=1785261970; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
        b=WW80aqKWmhn70l+6ASUZWHHxU0VAEGjfMvviIluttJH8aFMmHMONOFt05NKVn7jhxw
         84H01sFQp0cZHD1Kuqy2LEYwOdCRkK0DB0kmsuJQ4RnTYAKfMbZHdU6/DUDF2vAiciWO
         8r9sn77jL+bXdWghI5eYUI6f2GnvDd93nmgQI85XaLPs5IOszXCifC+Kwa/8XJbiw9Gk
         x07EHY2UO2LJ73JHsGBPhABLT/Dcak3TGsNs0z+dxqbD3bsIsp135czs7mzz8EPudldb
         tsOidnotbIX5ad2BtbBak7/Ev2BVLNdKS99RMV8ou3K5a7tq/4bvMgysc/ozZB5+8J+Z
         GVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657170; x=1785261970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xV+CPF5YI18r3TAdTBdkPihqc2UD1F8N4LyG6mVrBcA=;
        b=Pf4z8VCO65UswunTfk9w55QzUAtzLA9860Is4ADYQb/L3eQPXgiJyVmJkHbdpe1F3z
         HsOZZRs1LCHxGeVD3UgyABHUw+GgHVKPLBNNNt4CvH1oq7yDTAHJnGqNIZnPmy2s9h+6
         hUhluMa/K7UULo3S8Wqq5NQVRnj1gT1yQM+p3hjUq7OQGcSl5ddJ9kA7hmfyHBxwr5xM
         J4t0kTKOitMGrbye4l9YRXeyj1S0m7wZGV8P+hM1HTCdg1QOI+rB+pVwufTMXYqvtyti
         ynhV3IAG3TNYEV0g17YuHtr08TkrQJHnwYiQeBLoXquMOjbuj4SrvQ4Z4OreHSAWuESp
         wAgw==
X-Gm-Message-State: AOJu0Yw8cEKL7vnEFW2v7PDkqA3BQY/nnxD/jxjSWCFA2vaLKycZ9iHo
	47J14l89+0u2azLuCQNy7GJidOYOWjH1V6xbaJxFiq2GstehldJ7aoUitUqqNFyKR+aXcGk+MhY
	fVAOT
X-Gm-Gg: AR+sD11ymqknncldaPSKUzx8S/vOG9/xs9GHkEMgjLvEy7IFCqmQDwgaZFGyFSZCkKo
	aV2A2Jujre/58Yo9z1OT72lSaKotp3NCBUBPacOY+rYASpKMB44uLxvpL25q7EUt4iR/IRS2W1w
	pl3ekWgb1rh63mx3XHSoUsjRCo06HzsskgFmrfuKj/yYa3kESG/xRTI5d9mhnNC+PoQYa9wpBhN
	559TiO0vc3WM8hyUBUX2uyofq/YzfUeM6rLEbWhbSFulMwEdSHc6kUUtv+FozzPhBl8/G7HkT0D
	tnHWHX0/PBU4o8qbe1+/3gN10dp7Uy/tXHc6akvzu4G7qR9YGyEDYylsBk4xa1U+USs+T8KZ8rG
	VslRsE70ewavsgIhsxJAdrW9pEKtAecc0UVQF9+5yQLG4G0x3URfe2v12TDW93tnxooeaWFLc6Z
	8KLpUpUt3hXM6/AHfDiYnnSzR+GQN2pQJj0pN/Xa+vENyPLFIsmxrkaFwoijWKoh8=
X-Received: by 2002:a05:6214:f64:b0:8ef:892d:381 with SMTP id 6a1803df08f44-9077852e966mr204719166d6.52.1784657169822;
        Tue, 21 Jul 2026 11:06:09 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa27361sm1557796d6.43.2026.07.21.11.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:06:09 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v5 36/36] KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
Date: Tue, 21 Jul 2026 14:06:04 -0400
Message-ID: <20260721180604.172421-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF4DF180003
X-Stat-Signature: zd9h5yde36zk5hnsmsjdgmqouys7bmg9
X-Rspam-User: 
X-HE-Tag: 1784657170-720814
X-HE-Meta: U2FsdGVkX19NJ4ew35lLGUmP3e+F2F9I3NmxJH9VSJba9Teg8WG7tUCKxB23jxcQcPSI3L9htgf4TNQPCf3XsyXtyW2C8m1iRuiT7h1vSIzDjmXa5QwPnZdLhN2mP9x7IhWHnDCVfWtiVsp2+R2fuWLscGDfXWLySZtMjn+xbnmUqyNFDH1YBCf3EFxhJRF+T4CwZ+FZLOKWJiUVjKLzGB6bPJGE523X1gw7H46vpxULkq6HJBbP+UrDGhFmobOGrPK2aBWIp8e7a1Z8UJDyPZTw9iAcUjyYMWLOUdmijWdwzIueOGXI2hbkIjP9QxU4uHhrueR9ffL0vL7OhC+bPc3ePNk6D9w1nvan5fxXsFIv8IyIJLuLEWOtSAB6YMGzxarLbSIK1akO48CUiciduJwA7b8kD2h+5CtYBR4JW71hES1b6NtQmcAo/IiuT2/RKB22pcB+GO4/x7pqtSOyz+hSnvOBLXgHyCruqH6sFi894Uv0S+LaM5O4nlPQoyAKjEGF2aCTStHshE7wv5dA519Lzl0SqS2joR9rS/yUnfsigwa3jZeI5fZQBTk6TRyNDvt6S8BxeKiQxMgOn/PD02/tj5C5HqO47MoVJ4AU5l5xPkCxFj0eTnANC3U5X5cE0GHyJUmyaUNvmXMcE87I/qQBsV+ZardWZ9RDBT/RqPBzj/RJOAP0APCkPzCCPg1HLK2zLzeIhqDngG3uWfaxcbI+2ACWvg9Ke/jhQsfg1wbhZkJFYOtBbA7iPTUhhO0Ic5lodTXjcCLTrFXoTSBF2lEY+Iv+UosSFn4ie7BQJ70T04fxiQdr5QLtUILokyfJR5Rt9stFJS/H0xLPqV3w1m6YIhYGDIu+gv2lXBLl0rm3gLNmOVuT0SEH8NsfGeXV8dd3mb46C3LsGlBOelEiWNbLlplX1DLHfcldWG1uai+HP4MYWQLYZ2GTjTk+yJdgYrd20ySU9dVDt7SULjo
 6Z8nn3qD
 DFtqiuToEXd3l1Sqe4bsnWCU1nyMzKhMLvjRv+XdRTRpxEx3+mge5C8fb6UK8VsBjYMvhg3Gln4u7SrduWKXkhL9a+JgLN98rUQ+rlBAFGhXvSsrs0FQ4TdYbgMZDcEEbCN6UEFwWCPE7pejB0RfB8ua7vwEhjbmAoPkapR1pnRTZTHcqAisLwu7vTNDV4sTYLIefFGhqKARi1DOflRvClPxqf+xyVBcB+GHDDHRSMxO0YBgkqBCHoFFzUjUd86uxh/6CsPdu8HtfIUZxFc+77ybgZwf++J2ZFdX1RncMXPqIaeiOyACNCR1nS+bdzX5odHYKTBIXEngBUyexlhxkkZN4JQsObM/pggGVyC18Up+YARmyQP8lfB+sKA==
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


