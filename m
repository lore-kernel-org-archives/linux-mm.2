Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA60606A82B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kMhXHIRI
Received: by kanga.kvack.org (Postfix)
	id 05A246B05F4; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27666B05F5; Fri,  6 Nov 2026 19:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F5D6B05F6; Fri,  6 Nov 2026 19:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7A796B05F4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64BBEA01A4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
X-FDA: 85406459040.20.7045BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 512F810000B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMhXHIRI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011838;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANWT/yfx2UhN0rafXVKWKPXBTCBXsWp+E5MMs+sD+/M=;
	b=WcNYdE7Bg7MSBPfYZIPTrlwJ495VJKvFphUPwMrIm07FXBNQtS9hrBDiaXJrwZLVmvxQEy
	FwgoqLlJsKf9V9DBFJDDPXw82rl4eLRKOpqVWSfui1P8iywRJ4q6nVyq9CikushB1995nE
	eprpeV5Y2nQUaJ2Exk9c1tAHTxy114M=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMhXHIRI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011838;
	b=3NmEbqBS7o4bp+iKOSrXG7xVj6kQUz7rx/I/q+ONFtwovrf+l14k4sYPRTuerrvAqEmyIg
	wVQV4M98ESMrkaB8ZUYBGYEWHTZCBkOlwlcS2klBIG5Jwf/pKwOQOQQzMfcLIHn6pmeNf0
	w9h2ZgVjAF6OC1gR25lAKBlXdRIJyo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C3DD41142;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011837;
	b=ykgojiHXCIygWkG0/JPqjnYV/HZ4gGttqOalTu1Zlg1zQTWtCvwGLSg85Z9ruRUFnGax
	 g08MCHqCn3p4eA+LB0LdK7Vm4BO/sAUOq6rK58E59FS7NjeOp/kzrwm4JwtWio+aDvq4p
	 qO2YmXVhwMthtt8Gcs1RgABpjGET3uiUvTAbUG5u3RNCtiYnneW6XOT2v3cHszhy8dgIt
	 HfhN4vyKYx5uBIB3boG38paduYpqqAf1CZ6Nbf3TFcrAS0nDt4BaTdtTAsYqJuqx29nor
	 ZZFBqQhRWxMf4A5WczPp2smCYqjjj01gLf+ChWUVfCjK4CwjxV4L/zhXOXOayUwRRZA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011837;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ANWT/yfx2UhN0rafXVKWKPXBTCBXsWp+E5MMs+sD+/M=;
	b=PO70nIr1HAS5b1IKxYR+Lrxa/Y9Y1pKyel/9R5zQg+7XsOREMFZDLZJAnCTDJKCGR8cV
	 M7epETpLYNLg/5IzpGOFKxKPI5MKcWw4QGjgMnaqfIpnByuZL8a92nRbKnTRYqhKtdpKu
	 l40NEIApykGW/uc13HEXr6axb+tmlrHgbBl6bCgC+vPWjCijWVOgYh7PzjtxW56i/urNJ
	 TlnwbbzhfahvpHkHpL6DsXCJQ0AFtE8RIT+RJjLSYr32R9VW6MBhpL8GYumHLDwrBWr80
	 hC49xdCwHtCZq+nBVRA++eLW2F9/ydZHlzft8HlKCHig1c+OEwjMbP+mS3sOrccfTJA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 58D301F008AB;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011837;
	bh=ANWT/yfx2UhN0rafXVKWKPXBTCBXsWp+E5MMs+sD+/M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kMhXHIRI8gNSATPETteSO2ApCNxqYfTFx7ivg+GysltwNGs0bAGLGsrjEx3d8B3WM
	 FPatWjXzPLc4jxkF+0UWhtuXtPlljLxr1Sot6JH1ET2agAu7QaVtQWsPkSQLe38sQC
	 x+3oIRxvm1uxHjy3PO9A/YuKsoPiCmKi2BT7P2hFfQaD+jPfcNQutfZp4lR6/fryil
	 dHFKXChyT7XGafuE0Dkz7JdHSNNiZ0lEWBVU9xJbtHhu+Huo5hGTu8mtEtKiOWmewj
	 dpSX99cuOIBLEJd/5hHVA3jVZCbXyBRi0BaEDsTQK8B+liFVk/JHOHGGdSr2w2aWl3
	 Y54D8wh2+FsgA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BFD4C47A2C;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:46 -0800
Subject: [PATCH RFC v3 72/88] KVM: selftests: Add initial VFIO test
 verifying device info
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-72-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=5637;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qwwY1wogTiFJkGLjVl6X2EfDY2DAV1c/GKKv838ghMk=;
 b=NtT2E6e6NOXKRJJI6K8IGA2kAqoRSKGa8TTX9X40Mk2ZO0d+8X6Uf5VI8mskLD0aG5AXW51ZN
 DL61hLwxxv5D5p+w9bG47JvOxpnd9e/seVW7PI53w29SMhPOwZq8Bfy
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 512F810000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jpt4mymbhx3p8oic4r11uczas6xr68bo
X-HE-Tag: 1794011838-154600
X-HE-Meta: U2FsdGVkX1+JC+oh59YQq66SgepfBci1YCxBXtGwwzvLOBssw1TlxA6VzUeXylKMJtjjHx4G5GGRnCFsfL1v4yXYq5R9+kPqmcUfXBQmCCw+VuXggLShznG6PRw+6RWg5icScjrLwrVZCa8pIit1DUl6aAr0yc0khuRgsu/902IcRt6kJEpe3wZE6afyhS25vns1cKkxXcjObeYy4O8Q8pDe3lCv10U0KyEEKXvV9XH7vP3jY9XYe9WDyfM6VMvqzglnk98h/Dmw8O7jA1ygRoocXLt1oE0uiQ3jXoFUHXyq6jrrGjm9OK34DtcDRjegLjWPImzYtBRBLVwJa6HPkh+Z/Fm8Nl/CVN6/bk3u7XJyjtDHT0KNnMuvDucm91VTSblvS0MBy4nxzuRPE6VdpRPC6RPX1iE85Ntc0bIKiXWJPJqWWYfkWgXhrZ5N5gmMXyKbBLf3v1aVc29GUNzp0f8Q4G7sMLMGBOyht2eCHew/fO/Rp+QaNJT1d3jBAk2Iu7nusArUaxVL41YfuGklwyQY+w//znw36lGufR7qufysRRxiqCAutc4f/NMGgPXO36yEHK97vJqiBViDKYdSAEaJH3uljyeEnhdLsRq++Qorqt3jpZd5OBwzHWRSqc3HaomIzUC3gokrUAp9IhAlkV3iXkXSDZN4Kl7srQk0xyO6AhlhMqE88cRZAXQU1bkFzB+NLUT6Pvh4cuwTHk3d074+F/aTRfpJNI3RnP8n3kNujENvSYsa/V7MRnaPL34fmWEG/QbDjc0O9WjI6yXF63DCaGl+05kcd8LK6+KG7BYGmA08Lr7LeIV44EpYOGuGNeqcvG+iXy8UjAMGJHr1KMBccCsArknFLo/lPkLSEEfHneKude5PxrF0XsH7dnmmtPtgC7ciznridNVftLq2Y+/g3nifq4BDuBR5sVcO/5wZpR3ocJsL9qGHr9E6V70rUTEsAQKshFqG5LFRIKF
 0TJr6CqI
 v0DAim7fG/LVGCVNuEwyjUV+ZVwIGakeXXry4r/nx1voR37OxxTVJeeEYNTqs1Puv99MzbajpurwQ515bbIWK6y5pMxY/OmJvMegSSY2QO/DCkgQxxIDP01a3I9bNq+PwzyGdBoP5UBxsVtZu0rBxS2115dIKQ1aycHcfrttXlAP4vEOtxfQNtBObE5b3XhVjWulK7FWT9oc3qMZoZNRa4uDj391Kjh1ISBexjHqUCwnoJgHC8Ffvc7UdNJP6j2vC8rnFYWHVCRDUdX3Dnk+LocBhZP3lXs4FuP+tHOmCMUrCaTS8IZ20GuzlNOaeyJDOfPrLjzihk6FvxZAQ7x+L0D1LxRG96WydETK6hGKSM/JPUHVIi/XQklfTo8ou3/p/5s6ZwytgOyUR6qOWk09JNC9YXUxuHSV44fjU7PXd5qq4h7/rd0+D7op9jnKv84xHouEJjmjITO4QUjtmmGohyK9cr7ynAoQdGaoJKPazF0cTi+ZfdrKIApNeIyyXLRLIKDFHFG+TRmKKnSYqXPZCzmewphHI+pFD73DP/oIX2rwpNeOT0Rn7pu9eXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a standalone selftest to verify that an emulated or physical
Intel 82576 network card bound to the vfio cdev interface can be opened,
bound to iommufd, and queried for device information without requiring
an attached IOMMU page table or a running virtual machine.

Structure test setup and teardown into a kselftest harness fixture,
skipping cleanly if the device or /dev/iommu is unavailable, and
verifying that queried device flags reflect PCI and reset capabilities.
---
 tools/testing/selftests/kvm/Makefile.kvm           |   1 +
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 153 +++++++++++++++++++++
 2 files changed, 154 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 5f7118bddfc36..05f87764b71e7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -162,6 +162,7 @@ TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
 TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += x86/guest_memfd_conversions_test
+TEST_GEN_PROGS_x86 += x86/guest_memfd_vfio_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
new file mode 100644
index 0000000000000..669acc6058b5b
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -0,0 +1,153 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Minimal standalone test to verify an emulated or physical Intel 82576 (igb)
+ * NIC bound to vfio-pci via IOMMUFD cdev, without creating a KVM guest.
+ */
+#include <dirent.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+
+#include <linux/iommufd.h>
+#include <linux/pci_regs.h>
+#include <linux/types.h>
+#include <linux/compiler.h>
+#include <linux/vfio.h>
+
+#include "kselftest_harness.h"
+
+#define PCI_VENDOR_ID_INTEL 0x8086
+#define PCI_DEVICE_ID_INTEL_82576 0x10C9
+
+/* Intel 82576 BAR0 register offsets */
+#define E1000_CTRL	0x00000 /* Device Control - RW */
+#define E1000_STATUS	0x00008 /* Device Status - RO */
+#define E1000_RAL0	0x05400 /* Receive Address Low (0) - RW */
+#define E1000_RAH0	0x05404 /* Receive Address High (0) - RW */
+
+static char *find_igb_cdev_path(void)
+{
+	const char *sys_pci = "/sys/bus/pci/devices";
+	struct dirent *dev_entry;
+	DIR *dir = opendir(sys_pci);
+	char cdev_path[PATH_MAX];
+	char path[PATH_MAX];
+
+	if (!dir)
+		return NULL;
+
+	while ((dev_entry = readdir(dir)) != NULL) {
+		FILE *f;
+		uint32_t vendor = 0, device = 0;
+		DIR *vfio_dir;
+		struct dirent *vfio_entry;
+
+		if (dev_entry->d_name[0] == '.')
+			continue;
+
+		snprintf(path, sizeof(path), "%s/%s/vendor", sys_pci, dev_entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+		if (fscanf(f, "0x%x", &vendor) != 1) {
+			fclose(f);
+			continue;
+		}
+		fclose(f);
+
+		snprintf(path, sizeof(path), "%s/%s/device", sys_pci, dev_entry->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+		if (fscanf(f, "0x%x", &device) != 1) {
+			fclose(f);
+			continue;
+		}
+		fclose(f);
+
+		if (vendor != PCI_VENDOR_ID_INTEL || device != PCI_DEVICE_ID_INTEL_82576)
+			continue;
+
+		/* Found an Intel 82576 device. Check if bound to vfio-pci cdev. */
+		snprintf(path, sizeof(path), "%s/%s/vfio-dev", sys_pci, dev_entry->d_name);
+		vfio_dir = opendir(path);
+		if (!vfio_dir)
+			continue;
+
+		while ((vfio_entry = readdir(vfio_dir)) != NULL) {
+			if (strncmp(vfio_entry->d_name, "vfio", 4) == 0) {
+				snprintf(cdev_path, sizeof(cdev_path), "/dev/vfio/devices/%s",
+					 vfio_entry->d_name);
+				closedir(vfio_dir);
+				closedir(dir);
+				return strdup(cdev_path);
+			}
+		}
+		closedir(vfio_dir);
+	}
+
+	closedir(dir);
+	return NULL;
+}
+
+FIXTURE(guest_memfd_vfio) {
+	char *cdev_path;
+	int iommufd;
+	int vfio_fd;
+};
+
+FIXTURE_SETUP(guest_memfd_vfio)
+{
+	struct vfio_device_bind_iommufd bind_args = {};
+	int ret;
+
+	self->cdev_path = find_igb_cdev_path();
+	if (!self->cdev_path)
+		SKIP(return, "Intel 82576 device bound to vfio not found\n");
+
+	self->iommufd = open("/dev/iommu", O_RDWR);
+	if (self->iommufd < 0) {
+		free(self->cdev_path);
+		self->cdev_path = NULL;
+		SKIP(return, "Failed to open /dev/iommu\n");
+	}
+
+	self->vfio_fd = open(self->cdev_path, O_RDWR);
+	ASSERT_GE(self->vfio_fd, 0);
+
+	bind_args.argsz = sizeof(bind_args);
+	bind_args.iommufd = self->iommufd;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args);
+	ASSERT_EQ(0, ret);
+}
+
+FIXTURE_TEARDOWN(guest_memfd_vfio)
+{
+	if (self->vfio_fd >= 0)
+		close(self->vfio_fd);
+	if (self->iommufd >= 0)
+		close(self->iommufd);
+	free(self->cdev_path);
+}
+
+TEST_F(guest_memfd_vfio, get_device_info)
+{
+	struct vfio_device_info dev_info = {};
+	int ret;
+
+	dev_info.argsz = sizeof(dev_info);
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_INFO, &dev_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(dev_info.flags & VFIO_DEVICE_FLAGS_PCI);
+	ASSERT_TRUE(dev_info.flags & VFIO_DEVICE_FLAGS_RESET);
+	ASSERT_GE(dev_info.num_regions, VFIO_PCI_NUM_REGIONS);
+	ASSERT_GT(dev_info.num_irqs, 0);
+}
+
+TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



