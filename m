Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9DAC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5B986B0105; Tue, 14 Jul 2026 11:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BBA6B0107; Tue, 14 Jul 2026 11:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FBB16B0108; Tue, 14 Jul 2026 11:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58D4B6B0105
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAC4040439
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:33 +0000 (UTC)
X-FDA: 84987731346.25.FC772CE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F4A22001C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qgTShgtV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3klJWagcKCOkgTaTYdSRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vipinsh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3klJWagcKCOkgTaTYdSRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjEe04qswGeo8Cvf7F1uxuMmAPxZARk/R3E4HFO0u5g=;
	b=p+WnbgTVgdTdI4Ir0pQ159YN0VPf/1Bg/wQeMg4PB1FGnwmTZ2cpLDowGpSFv+XJYIu4GP
	+19OrIH+7y3tGfUEC0OBcLboQmzlreZfqgMEyNbs88FVgIXRueZsb1+TweFMRZy1zwg6lC
	qEAAPMNJvffpVR/R+H6z7MxKJLrV9VI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qgTShgtV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3klJWagcKCOkgTaTYdSRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vipinsh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3klJWagcKCOkgTaTYdSRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042132;
	b=fQTdySYvyHgqzQu8X6Tpmmsnxoo+yCNzB2ZVHDrIZXuVkmoCvmfi935poMP4VEpcZjsdn2
	gFtmc4uqChVaooIWa41Hovgh0PbxW4V/93HDPkLkUBj/bUOX9U1TVh+EDNNa+Gw/Cxh5UW
	nGFStSI62Qtu9JazO70Gv4t2yw2nNC8=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cca3673560so82031775ad.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042131; x=1784646931; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xjEe04qswGeo8Cvf7F1uxuMmAPxZARk/R3E4HFO0u5g=;
        b=qgTShgtVcPEGHFvF9Jnm+tfsCLaI2NmT6X7gN1NclBeMrMepbi1gpvu638AiR9zxNN
         YRx5J8xJEK2yaK0MF2juRWr7Nw4boxB55wmQNLSLC/4UYIY6yUTQdL2v9olsLxbtd+B7
         yDUZg1crCgICNKGxX8L9mxJ7zw/8on34qQ0aaKaeO86h1RipTdRA/6IzRwQcVnBZ5SjV
         IWFkBnMe12gS0eWjmYo90nwSiHQ+i3DAiCCU+MAWAoXCyBuUTAAOzOJKKmTOpQ/Dp8PB
         lxeuLunUpS1gVzr5DoDzHwtrIGooRvDapx0gmfzNWga1kQdyuDzAfREycEog6bCf+lvR
         65gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042131; x=1784646931;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xjEe04qswGeo8Cvf7F1uxuMmAPxZARk/R3E4HFO0u5g=;
        b=EpeZsrmA1escECIFi5rOS7vWcSu8YcxjDCTNzRFOC5G6MGq8MZmFdRCheVzEcDru8l
         ulPukPdlENm+wduvnZ8cuRiOT+uNl/zJkWXDl1whxVnHh0n5K2KmRr7li+abuMOmF7aG
         7YvIIpnOih1t53HEDuFFKwtz+EU7dHP7+mBYXJKfCaLjfJzeuilE7gYzdMDdcWXf/2/D
         aQGjnKqKsetUum5Xicbw+tjuAwRV9+YrCHILHTkCp1VduHrXfHjnhNImhdXoLNR8mTW4
         dqaSTV/0sMJpjfFRwCHJpj+/ZGxDiPaxQtzSsZNtlinq3NoSqJoB3yzDRy4HqUjffAuB
         A9Mw==
X-Forwarded-Encrypted: i=1; AHgh+Rr+pW6AYJ5cVwoDygqIBjtVinWImpaQEjg1SuOb48edE74WpXBFTdRFUlwcNQdkhX/jhhKpxOpYCA==@kvack.org
X-Gm-Message-State: AOJu0YxnKV7HS47g7kRdQeEfhG5Bu8DxeIu1ykKZR7kERPajcLbCx96T
	gHYfGK4L0q7iqnWUjoAWqhUj1/I/QR1Pcuuj+Pt4JW09179NIn+o9cFtgt3+ekLejNYfYDrtq4S
	P46O1Tas8PA==
X-Received: from plbl21.prod.google.com ([2002:a17:902:eb15:b0:2cc:da2c:8085])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:120c:b0:2ce:d1dc:1e1
 with SMTP id d9443c01a7336-2cef1332689mr29905365ad.39.1784042130777; Tue, 14
 Jul 2026 08:15:30 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:05 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-21-vipinsh@google.com>
Subject: [PATCH v5 20/20] vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F4A22001C
X-Stat-Signature: yhq6i36m5sn3cmjxqiu4tyra7st7t9gc
X-Rspam-User: 
X-HE-Tag: 1784042131-382801
X-HE-Meta: U2FsdGVkX18BG8CqEAwL9LEFPnJB5fXptxvmrcl7sM8xPOSM+fx/WZOmYtra0INZso7UxxpHAkgOoGSj+Cz3OjAQxsIsGy6tFRM34NefwDyBJNGzkDUlwxB1iFJaYTQYoLdrSeMrBHLuKDe3fgLIov0KusC5S3O/PabgATlpLOnb4htBoOm8nLceLtWWUVLxha1uQ6Raddg+LTFa8V+NxswiFBwo133wA+0IpDMxFprOr0KgqPsL6UH1byld4lo5MkRTG6XhcwsjLPYV576nfR6zKc4ZvrJ4kDpQvVoUQEoektGnjYZCDPtKDe/dsPpXpMqX+sDBLdh3qR8reAB+NsGinK+WZaOKS1+LDj0wtP7SHmbImoXMDIqVYgwJMay9qlyHgA3T01EIJabJolW/u/gW3RriV+L1kwEs8F9JvItzfYj8IBV9kTgoHOqAYqn9LS+lKA7dW0V7pE/2htAe2Zxw3XljYgyzBcquwf8yikDEonWT0WHPl1Uv1bdhp/xPslHWRcjfYCnl3+S1iaWyyUSzD7iik4Jyw2GJf5IokBLM22e3ZuEleSq/Q/Bj8W4n1zjLqp5499QABZ2dXIj12BLqYAn2KGXFO/WIfWPksRgpJ5cegAZ/tBO3drD7thyfiA1aEIFcZ/yhDXvPTh72Tr/PUqbGhQ3p9nvaE8cgCeOCgWQGnFfTyb2r9+ZLrU7dA2nTtR49454J/KqPmHCSe+mE268l8sROd/Fc1G9A3u/cJ7fiVEG5Jg43feZKEy0Keak08mS/dvjp3vk9aHbd+wt0bbiBhZsxp5MbXCW5a6JwCTYmg6SU3hnOmqrdlsMfmygxLND8C3FX7SVIyx5sVa5v1Wp7tBnDUcYyoaw0p8z/2sYP+QF9Dad4rZer1FINc+ShbyISWRHnEfH2P66oZYkg9H6scCQhOFARRy7ZO7YcMlU7BZz7ln3nUZyHFkV9ZHDlfzDoZub3SpjMsgf
 +cnxH+D2
 7fXZmXXr8hW7rr1mgOsKV3XVT6CGBoFi0+XputVGly5ybAMkSLMkaRupWjSjWBCIjPydiIAnw4HJ9r09gGrLozubLuV4nHSxlE42IlB30ACKdigjg9Un3KKaGa47Gbc2WCxUtvP3fPZ9pB/EzB1ZoWHyrRB1dm3rYUb+WZ4M7FRB7WNKQGrB/bfIjAQfTW55CWFNwy78NHe9jp+uaHd03d/ggI4EgFbVYSRGardlOJltbx2RaR44jG9fEmdqqlm2O1s6pDkIdHHNw0MNIMmDjereBS5J2/J8V+I1igMJ291/bCMK6RLePg7DiPjA3noDVhJpGCeZKPKaP0bdv5lV5Epp6DvLW6Yai84nNUz7/OuoH12XzdwiJeFiWWxhrlk1ySGPtPxyVVDa28LBjm66tO8b2ueuP+uLdf/vthRvY/ZQjW3TpXkBNeugDuGYcJ88lzlAbLux4rCWXqJZ5CzAiA+phAJvgWmgFrh3aakuu5x+YRqC9zuB7rY+oOqrlX4l2oji/Da5iIblaiHlS0mTvWQOux6+D4XU5894wmz05QADSyQt59elFbkil4Ah+WS4AYS00zGR6KKwboAhkJ2R61Ol9k20NCqgCACoaD6qPeMBEn9dqv/N5YXHMKUCLVA4HGaOZDt4Zocyv55Sd0Ra3k+GwTLBWLKOBAEv/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Matlack <dmatlack@google.com>

Add a long-running DMA memcpy operation to
vfio_pci_liveupdate_kexec_test so that the device attempts to perform
DMAs continuously during the Live Update.

At this point iommufd preservation is not supported and bus mastering is
not kept enabled on the device across the kexec, so most of these DMAs
will be dropped. However this test ensures that the current device
preservation support does not lead to system instability or crashes if
the device is active. And once iommufd and bus mastering are preserved,
this test can be relaxed to check that the DMA operations completed
successfully.

Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 129 ++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index ec3fe8f19502..51b2f24f352c 100644
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
+	vaddr = mmap(NULL, MEMFD_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
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
2.55.0.795.g602f6c329a-goog


