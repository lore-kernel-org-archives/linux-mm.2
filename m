Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C76D6F532C2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37DEA6B00C3; Mon, 23 Mar 2026 19:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35ACE6B00C6; Mon, 23 Mar 2026 19:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A646B00C3; Mon, 23 Mar 2026 19:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07F4F6B00C3
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0E235D070
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:22 +0000 (UTC)
X-FDA: 84578996964.01.F1697DE
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 123311A0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GV2d5UpA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 319PBaQgKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=319PBaQgKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emXTkfduCARpReH/0NkUqCqksAosTTU4j/dciIvOyCs=;
	b=8TV02+WDEknW3TNQcJXFyI54q9cL8dnPqucc4V8e1qzM/w7CS1R5qjFO6DxJlV/Y6OQ44Y
	zJbPJCXLZ/d/39YSLo8nvqltWwKc8QwIbRj0ZAd7s0uCcaw7iXH2ZDCfHFq7Xz4JbbTyOY
	2O1cZTo+yUpSJh4hhpdEgwp/VTYBdMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310361; a=rsa-sha256;
	cv=none;
	b=5jLF+DmPmKNu8OPNxpf4+yjai1t2I1UY5yxmQxPuENfX4gr4YDFyDPlFk98uQLyiKWAi4R
	QG9fDtoYrDI2Sl66ieNxa8kI7AYB9IozO3/Xxiq1sMPahnLgfZuzLzXyDPtc9R4fK8VUB+
	z9/gGOTm/XVBXrHZXRk12yWX6zP+PxM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GV2d5UpA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 319PBaQgKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=319PBaQgKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b05a3c2421so8473065ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310360; x=1774915160; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=emXTkfduCARpReH/0NkUqCqksAosTTU4j/dciIvOyCs=;
        b=GV2d5UpAySSXSkQXvVAr4mbfr4bQh/mNbEEstnzyn4U1k9ZVFNsW8uJw4UsN3Eot8b
         OhCOrmMLD4+smzJB1TWSBXfmP/Dy0ONRVrNm1l4gbGlzmykBCAPBegFHeA6akUo5Ob58
         5snUhKG2O5d2sb2B2ZwzZQHPxfgbT0y+wHycfnqu3aDaPXtxaz9ktf/5d60EhMqM2kW1
         i3RXNA+GYDKCgOmw2eeNpyWTURtsCil70i+i8HVs2CsO21/PPznPJ41sJKJOjHyWPar7
         7uxOpLl2uNRTnK0SANOPTX18JSQz54kyJo7E/9FDL63sTCxh10xqVJRifyXlPFeeDDOd
         UKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310360; x=1774915160;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=emXTkfduCARpReH/0NkUqCqksAosTTU4j/dciIvOyCs=;
        b=V/gWONIg40+OQKvT1lfNBGE4BtkPwE21L6p3Jr1FTs7wicuEIUh4YH3VExHbz2gtXd
         CAgyxlAnjaNKGddkLbqvSq9BO87CsDUTNHJ2541ShMIZh1dkS445PAZ9yIm9rnKrt2O+
         Oww3+om8bLk9wamJn0wMxR/MvqGrxQ5rCTU1lYC9rKkihP4j91PX8oAQJ2TJzQO7bfmZ
         jL74dhvACkkOzT5j2pNnVH0XlsZuulDN97Pze3VAkIyQwM3CHr22BWweykXi2Y4GzcyJ
         63156TqbHN1g6fPI1lPpZTVicGsi82NfOeOdPou/SxMuqykqeJikmlose5u3hJfAwkxC
         YaZg==
X-Forwarded-Encrypted: i=1; AJvYcCW512ab39XchtHiMrq0HzhbTgIjtjlS5QInoYWOlZLm3Ijl+xOV291T+6M5yXb1EizKwdFPqxj94Q==@kvack.org
X-Gm-Message-State: AOJu0Yw0vyJk4iJihYOC5d3Dv/7ebW+awhE/wVeyybKsaHUMhP65TnVx
	JWllMxJaxkPX3P150kkdKSUj6yP8Ix5o32f7o4JTiwLoADVKNR81ReFkkezmYj3th7uNYtnx/VE
	abOi3YzV0ZHXyWQ==
X-Received: from plcp2.prod.google.com ([2002:a17:902:e342:b0:2b0:6c44:fc55])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d54a:b0:2ae:c9be:5f2c with SMTP id d9443c01a7336-2b08271d042mr130329495ad.21.1774310359658;
 Mon, 23 Mar 2026 16:59:19 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:16 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-25-dmatlack@google.com>
Subject: [PATCH v3 24/24] vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 123311A0002
X-Stat-Signature: qb7ypekynioc811q4gkdozxezkxmbht6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774310360-425501
X-HE-Meta: U2FsdGVkX18/ff23Q1kRoic9kJzPYhpCAEKuY6zewZ0MPBZBFy6qjcHOMBj6+4h2c7lg136bShM3PC/LOSUcjP/KQlhhl85LI0oRgITOOpLSGwT50uOjdCWeoghJYkqsjTTYz1uYfLP4HkCQEcVPgfYNW72jCPHVQP4v3885A9tJg54JBJoF8rOJ38vyfnRi66V3Bh50FRQ4vYZyrdQ3mmGKmovZj0ZkWi0HEP5TE6HS+XmkRYTYRJT80l5qfabSXSXAfP/jI1SKEMiFgoj/ebp3dIbxbv9ZoKt/veycSXVUMprtBmF5GKjtgJ11/GCo8/fZw2rdJFzXKKDyZhieSxULlpkwomn9yOHzTvgVA1ESofQ8y61VxbgYnCYZVrLfHmMIXCMd5QmncxneB4FROpPO/pidI6WlQP80jkPitaYr4/nPOGkTXF52q/1ZAPP1yydV460iEbxVWPqQqb8eKqOexIOXhnyknnx6A9MI1k6TbFKGxFgr/WJiM48IVX6hxB195qmU2dhWxzabmbl/Do36VBhtrJrpLHs38AiXAu9DgG4oTVfyno3Cuj9ONUhOvGQtL31go884v+3vYaRiut+z8hs4nnnYBicGGq0Qc02WosGP/GyVboTRDLOGmmKQFHsHnm5qVxy3cYE+ZmKjhFAmmtZz9Unj6s9ow9NJ2qBJeo7go+QGSqFzmqT3H1Fw6IWEdvWVSlSRH8SmzklPMMW/NODp8UQAZMsAINFMpFCOlxSVV6GrUrXycAqq4nkAvaWlFTJKwoyntfPRDkRGik3uGzC9IaU/iIChWr7JiekunRu0BqJHmZ287QtHcyfIdjIyvjo2fDG7n38bhVKFdtsjWtPMNp/SUa3kCNClcFxlAnEzyial4vdQ7uS8zOClnheAE15Yz7qD9T2ZNDnTLxr2O392h81ETm/Wwo51LatqJiUxgu3wDo3A+fyeRKIoIyHzut01hS6eGSFuYDc
 7ywZUec1
 N5tb/Hn5m3liLGDMugCG1nkLIdiOUNiSmZhQEM2duC7PxC4jG8sf9RKbJ3IKbJ+lPArn4BNzp+kOHPYBOU+5wxwQdOZDH1EmjaOgv0wUhM/9ropJafbe5q07KEWkdfVfhCF8EIlgdJy84c7DStxsVfJqJpII96OhBR2lcIjCI1vTdLkO6/HpJ/JhI+gcWOQI5Nf6OsL9AaemQsSBbFqIoimrMOeY5LQ7oZ4oMQseDQT3LVf9vi5Nrtrs6tnOP4Tx2Eex+7IknO2o5ck94lGK2kKKzczgtR9yrGH4yuggwLJlYWBnOpCghmvoIE+nyDW5fGns4nE5iFFavPQRC4X7nC+IB8HwXm8ELygGYLvXEy8xlgjSmMwzFD4asRrHTh7yrohn+nxMm/kkG/WzUnSPPCjpyYzq6Run/I/8h7aIQj2aJf6GxIfameahGX76J+CztiNgcFI/Gs8gDh6oG6upCs+fYVHW45qXrYeSq0DdDalSxk8wNkK8JO64UNL4jTizB5uGt4Qn73YakDCWNbC9DBWFzaBdcWGkLOI1kAPR3jZopsjUaqhm4LwYkKrCmzebe+2g60sqcNhfU2fAYWt9K5E+YvtdBjcdJ0VLxpJmB76+2N2/w7N9Sem4yaF32RS+83E+2kuqCOBNwo/hwlgY22KZm2zhGRg9AgdYVYPb9qYV8i79x1X3Y0TNp66E+O6zpvkECVnJRQZN68/wOVwqcmMrWdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a long-running DMA memcpy operation to
vfio_pci_liveupdate_kexec_test so that the device attempts to perform
DMAs continuously during the Live Update.

At this point iommufd preservation is not supported and bus mastering is
not kept enabled on the device during across the kexec, so most of these
DMAs will be dropped. However this test ensures that the current device
preservation support does not lead to system instability or crashes if
the device is active. And once iommufd and bus mastering are preserved,
this test can be relaxed to check that the DMA operations completed
successfully.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 65c48196e44e..36bddfbb88ed 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -1,8 +1,16 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <linux/sizes.h>
+#include <sys/mman.h>
+
 #include <libliveupdate.h>
 #include <libvfio.h>
 
+#define MEMCPY_SIZE SZ_1G
+#define DRIVER_SIZE SZ_1M
+#define MEMFD_SIZE (MEMCPY_SIZE + DRIVER_SIZE)
+
+static struct dma_region memcpy_region;
 static const char *device_bdf;
 
 static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -11,8 +19,89 @@ static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
 enum {
 	STATE_TOKEN,
 	DEVICE_TOKEN,
+	MEMFD_TOKEN,
 };
 
+static void dma_memcpy_one(struct vfio_pci_device *device)
+{
+	void *src = memcpy_region.vaddr, *dst;
+	u64 size;
+
+	size = min_t(u64, memcpy_region.size / 2, device->driver.max_memcpy_size);
+	dst = src + size;
+
+	memset(src, 1, size);
+	memset(dst, 0, size);
+
+	printf("Kicking off 1 DMA memcpy operations of size 0x%lx...\n", size);
+	vfio_pci_driver_memcpy(device,
+			       to_iova(device, src),
+			       to_iova(device, dst),
+			       size);
+
+	VFIO_ASSERT_EQ(memcmp(src, dst, size), 0);
+}
+
+static void dma_memcpy_start(struct vfio_pci_device *device)
+{
+	void *src = memcpy_region.vaddr, *dst;
+	u64 count, size;
+
+	size = min_t(u64, memcpy_region.size / 2, device->driver.max_memcpy_size);
+	dst = src + size;
+
+	/*
+	 * Rough Math: If we assume the device will perform memcpy at a rate of
+	 * 30GB/s then 7200GB of transfers will run for about 4 minutes.
+	 */
+	count = (u64)7200 * SZ_1G / size;
+	count = min_t(u64, count, device->driver.max_memcpy_count);
+
+	memset(src, 1, size / 2);
+	memset(dst, 0, size / 2);
+
+	printf("Kicking off %lu DMA memcpy operations of size 0x%lx...\n", count, size);
+	vfio_pci_driver_memcpy_start(device,
+				     to_iova(device, src),
+				     to_iova(device, dst),
+				     size, count);
+}
+
+static void dma_memfd_map(struct vfio_pci_device *device, int fd)
+{
+	void *vaddr;
+
+	vaddr = mmap(NULL, MEMFD_SIZE, PROT_WRITE, MAP_SHARED, fd, 0);
+	VFIO_ASSERT_NE(vaddr, MAP_FAILED);
+
+	memcpy_region.iova = SZ_4G;
+	memcpy_region.size = MEMCPY_SIZE;
+	memcpy_region.vaddr = vaddr;
+	iommu_map(device->iommu, &memcpy_region);
+
+	device->driver.region.iova = memcpy_region.iova + memcpy_region.size;
+	device->driver.region.size = DRIVER_SIZE;
+	device->driver.region.vaddr = vaddr + memcpy_region.size;
+	iommu_map(device->iommu, &device->driver.region);
+}
+
+static void dma_memfd_setup(struct vfio_pci_device *device, int session_fd)
+{
+	int fd, ret;
+
+	fd = memfd_create("dma-buffer", 0);
+	VFIO_ASSERT_GE(fd, 0);
+
+	ret = fallocate(fd, 0, 0, MEMFD_SIZE);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	printf("Preserving memfd of size 0x%x in session\n", MEMFD_SIZE);
+	ret = luo_session_preserve_fd(session_fd, fd, MEMFD_TOKEN);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	dma_memfd_map(device, fd);
+}
+
 static void before_kexec(int luo_fd)
 {
 	struct vfio_pci_device *device;
@@ -32,6 +121,27 @@ static void before_kexec(int luo_fd)
 	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
 	VFIO_ASSERT_EQ(ret, 0);
 
+	dma_memfd_setup(device, session_fd);
+
+	/*
+	 * If the device has a selftests driver, kick off a long-running DMA
+	 * operation to exercise the device trying to DMA during a Live Update.
+	 * Since iommufd preservation is not supported yet, these DMAs should be
+	 * dropped. So this is just looking to verify that the system does not
+	 * fall over and crash as a result of a busy device being preserved.
+	 */
+	if (device->driver.ops) {
+		vfio_pci_driver_init(device);
+		dma_memcpy_start(device);
+
+		/*
+		 * Disable interrupts on the device or freeze() will fail.
+		 * Unfortunately there isn't a way to easily have a test for
+		 * that here since the check happens during shutdown.
+		 */
+		vfio_pci_msix_disable(device);
+	}
+
 	close(luo_fd);
 	daemonize_and_wait();
 }
@@ -78,6 +188,7 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	struct iommu *iommu;
 	int session_fd;
 	int device_fd;
+	int memfd;
 	int stage;
 
 	check_open_vfio_device_fails();
@@ -88,6 +199,10 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	session_fd = luo_retrieve_session(luo_fd, device_session);
 	VFIO_ASSERT_GE(session_fd, 0);
 
+	printf("Retrieving memfd from LUO\n");
+	memfd = luo_session_retrieve_fd(session_fd, MEMFD_TOKEN);
+	VFIO_ASSERT_GE(memfd, 0);
+
 	printf("Finishing the session before retrieving the device (should fail)\n");
 	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
 
@@ -109,9 +224,23 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	 */
 	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
 
+	dma_memfd_map(device, memfd);
+
 	printf("Finishing the session\n");
 	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
 
+	/*
+	 * Once iommufd preservation is supported and the device is kept fully
+	 * running across the Live Update, this should wait for the long-
+	 * running DMA memcpy operation kicked off in before_kexec() to
+	 * complete. But for now we expect the device to be reset so just
+	 * trigger a single memcpy to make sure it's still functional.
+	 */
+	if (device->driver.ops) {
+		vfio_pci_driver_init(device);
+		dma_memcpy_one(device);
+	}
+
 	vfio_pci_device_cleanup(device);
 	iommu_cleanup(iommu);
 }
-- 
2.53.0.983.g0bb29b3bc5-goog


