Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236D5D73E8E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7A86B00AA; Thu, 29 Jan 2026 16:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E4B6B00AB; Thu, 29 Jan 2026 16:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E51F6B00AC; Thu, 29 Jan 2026 16:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B8A26B00AA
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B75E213A29D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:16 +0000 (UTC)
X-FDA: 84386284752.21.34C2A09
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0114718000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PzSTaG5o;
	spf=pass (imf24.hostedemail.com: domain of 3ddB7aQgKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ddB7aQgKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/muCk34u9aT1IY2gVvKiXcNAAUfYmiU08gi1alRQns=;
	b=Js1K9t3vggC2zTKADbu4BUwO9HwQGfAabkUPmTr4Pxs2XBXWQglmOAc/irmvxb5BACAFIt
	NCAh02DFNoyEZp08f1/sEUgck5S7esiXpUEOp5vKyGHVJHaQahX4WY2NKv4OeKPUU+WKSU
	9yH5xyU6WJXKq2FpJGXfiSROD+pdmtI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PzSTaG5o;
	spf=pass (imf24.hostedemail.com: domain of 3ddB7aQgKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ddB7aQgKCFg3C0JB02A6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721975; a=rsa-sha256;
	cv=none;
	b=SBHyB4BbT3DEPZWQOIQf2OCeggWGQrWB3/ylm7BDS9HXj9BWpv+n5AYs/hgy4Bnf2YyANv
	t8RCCZQeG3rAMQREa4z97ZepuWaqjuVjXxNooWeRtO9l5qlKasFcyvQDe5gdZNc1q9SU/s
	PGI88JzfEtX4suxyu+MW62eSSzpmvZQ=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c5d203988so2580493a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721974; x=1770326774; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J/muCk34u9aT1IY2gVvKiXcNAAUfYmiU08gi1alRQns=;
        b=PzSTaG5opWpbM36q9GJFbxBvb5XzdY4KiX/QNA2zEbfWDq5LNdGDOVSI+veb1k/09H
         boINMjXlGF9iFb0gleeGrDFzcZaIuwRZMGx5qKEBa1zAHfb7g/BY5cJadnN2UeOY6AVX
         0vrK7kakBHb1uJmWhxYE/SQmC8ORb8JBQpmg/UCVKAmUqa4e8bYOD6+qEi0UsDiJkEd1
         wmPiKIAH3nDdqaLDteKLhgRHv/PiV+iMelO4aJXwNmw2X4TEvKx7k85pAzMgBTRbZHIH
         JlN5vckbpEdQNCPv4gS+OcGqgDppvajaq7Ol6xdirbVrGyj1ifldjnQjThI1zOri8DKA
         N7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721974; x=1770326774;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J/muCk34u9aT1IY2gVvKiXcNAAUfYmiU08gi1alRQns=;
        b=QdbLjWSAh6MBT+IkWoW0SSaw6dg/V5STUpIsZH8J+swhNheVDCAIYsmN7RkJE9AcOg
         GwFbUMuZ5IA+NZK86F01SV9gUNv1oRPw/Q5uhaGyWA7gXffGhOK9/YbhKS6+gPcf2u2K
         adBiAO3yIB9qnI+DiM2kc2KE2oP9hSH4mMjM+TV2m1jPdjRyaQx+yxyLvNJqvluplEnd
         cXEnuYDa25EabpXNFyqNIRnMghDgrL9zWCNejLiuqpHhPDubd1jmdfTxui4HTHQL98Bw
         QjK6gGQeasMi2lYfYjlvEv+5XaGYQUCul3UYWqQNPAB/XHt/hBdsxyGm/YnCytUHf3c9
         FC0w==
X-Forwarded-Encrypted: i=1; AJvYcCW+QX/4FVMVM4VJ6WjyJBqL3jtm2mrfZvnaDiLav3K3Yk6atRS4AQF1YPXyh8w1WHO0nL7b7PsWMA==@kvack.org
X-Gm-Message-State: AOJu0YzNWFa6ASW/UN8OllzfbVYU8XkZzWEwGipwtCkt9XNrKQ78MABT
	8vpsfuvUcNEsKGtrEq9VlRot3ct0OgN2LmYXvtCeoqNmEcisYvILfR2lCsBbGIgaFQlSaObK+cz
	8UEp35u8rIQIVoA==
X-Received: from pjbso3.prod.google.com ([2002:a17:90b:1f83:b0:33b:c211:1fa9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d60d:b0:32e:38b0:15f4 with SMTP id 98e67ed59e1d1-3543b2dc1c9mr828054a91.7.1769721973868;
 Thu, 29 Jan 2026 13:26:13 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:09 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-23-dmatlack@google.com>
Subject: [PATCH v2 22/22] vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4xz1k98nmn7poo9y67q8qgeknjwecy5k
X-Rspamd-Queue-Id: 0114718000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769721974-620809
X-HE-Meta: U2FsdGVkX18yQ4j13kXf86uMntUI8sxGXTm8enpxHPMpg0ftzTLoaD0d9qhsI8tCTdNJ72PRmt90jGwwxgOOWNlSdWEqaV4mqwIXpHHcmdKqFdpiwpG0Z6UfrjuLtKs9OFPYnSw/spHUh/MUPQzUPaxhZZy5VbAqzCuksInDn8cL1Wee9djgE5j+opFEtX9DW20xB6oVdwHuKF6KGxlbYoX619h4w5KVG2fCoxhzEXbfgqc4fJLf1b0xD1wUup2Ek5SmuU87zkaqNwDo+inDh5cVbgmXNroMKEB9ndx3AsvpNpxzEKQtw8eenjf4lGqCjCoXzo38jNPS/LmgPIu/SrFA9coe7c1Byx46f0k5H2NYj9F3Eo4abzftgfRmwQZfH2Fc1U61MK36epjnqhQqM2lkrqPaOBcRQgzY91MTMTpAwcgIQvPkM6aHaNWNSldYnQA4nD65gZJX9Cuy9h31E5MEkZCi6i+9jm+dkJHaUJCBpBtkNRRBf+MgL0cDeyfGHY8eCG5OyzFF/Cqr/3Tc5bY0655a28S+gVgyN2uEHLv04WieAJBA7+2gCvP5AzmCWu41T25f4bdFPI7Yt+dJttaVqPBS4Nk+fYC7udrya3Q2gcfyr/lvbIF0Aecb/13fW9uT2ElZ+us5F+ACj0iW6UXRhHy7ofavtRUXp8TEEWfGOm3ZtHXexVUi7jY8MT13DNNYFI6AnH6obiNOqHql7IRe2CLXV/UTAy31MPU+7fHTezOBQjHQZOYBTVV5KRMjVhTcAYHHJTOGqUvJzcvI6kiNVfu0SrgoEBbp/GhcTDbzGq4pht/aoOYascHVtHegBXswg+YxcFzm0PURD3XKkaIQU9kFV8N0QJSIWnkUuo7bLzO3sYNPfOeyMM61jxtUW76lgurHMRgeFTr5IrEety3zAMvI+pSYwk4388z+mbDKC+OrtInzmbUM1VTsSHs+G91fQ6ow0d45Nn/QDPp
 6cmLlnDX
 ukVD481+D+PrFQtYsQ/WF8hSV5u7bZ9pNjzE913xz4Hz6K8txpiEzEJM0+4+i11x7QJdS/KhApUNSjruroCQfS9GcxvxL9qecw+uKxFi4uVKlS9fmt6GUWjBQPEhL+Nnuw8Nc8TwYLzggitGJH1AiNtI/8dqRONoGJL1RzAC7AwjH1galB+o4kfCaUFPxsViHvbtpfGiflvMEUweb+uUr6IilA1seaz94m6ETIRyEk1rpaMkcyzSqwq+3Vw1UMuoZbQR8agzJuuIpMLdlTMToH/b4nyKRbsuzh/5lAYk4PmUbhPpehbvz9aqyhQxg7yJ+fq6Spxcyg5Eqnh1jKXsvRRcgz7u3E09qw0tJvIuefLDr5N/E+R2qY6qJ4fApubK+/Y6wTg/k8DYBweSUOX+WUePsetEAuAIu+T9gJBgpoMJZNGr0uS/Xq0knmULvki92GuWo7/U8kICTUol4f10zGbXV2vf87QFptg5Rp3TLmGXVeFYI+nmGKYZ5JpGY6Ip5K4VEnbOXnU3l+oU5glLMEkqjsJFEsEvk9RIOC8Uw+58xChp8aqA0yUUvRcbuJ6k7VBXQDmiArDh4pcs0YS0r8NTRB0zs+I/7dQg6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
2.53.0.rc1.225.gd81095ad13-goog


