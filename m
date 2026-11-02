Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106E1606BA71
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ejWWWD0N
Received: by kanga.kvack.org (Postfix)
	id BE75A6B065D; Mon,  2 Nov 2026 10:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70C36B065E; Mon,  2 Nov 2026 10:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A600A6B065F; Mon,  2 Nov 2026 10:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7747D6B065D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 136A440172
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:32 +0000 (UTC)
X-FDA: 85390583544.22.B78DD2B
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id 55A21180007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ejWWWD0N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3OK7oagcKCJUK7E7CH65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3OK7oagcKCJUK7E7CH65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQb3q6R6QngEoe3ekBduEqXoGdMTuhEwA2ttf4WySgI=;
	b=4gKLuxedNQy/SLEdaQSQqSUmbw3mdRTnjSPYSroSWq8fVJwF2GY0oFoiIU2AdsdBhh9dli
	TTyTghdoAewoUJxcFzusRjFDO/a+rAPIc9rFplvhW3U9IhhOwMRl0paaOSwZHo9FEx9Yfd
	CfIvpWByGANmfOHJdQGMR1eHkwz+Xn8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ejWWWD0N;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3OK7oagcKCJUK7E7CH65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--vipinsh.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3OK7oagcKCJUK7E7CH65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633850;
	b=4EyWaBBjCQIs69LZiOj+AK1xesbSgpTwhOhh4ahanEq3atOxWOAYv2sdfTEwCIHEfSPx2S
	EUjJCbjR6l/uzcde8dZm+BrwDhL1uNUd8Kn0uMV0j/wPul+WNVxWs/b2tSoB+MduvaIVhn
	+3MWg/TZfdNDsaB5qwnPNxzYBYVPB8U=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2e818ca61bfso33412875ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633849; x=1794238649; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PQb3q6R6QngEoe3ekBduEqXoGdMTuhEwA2ttf4WySgI=;
        b=ejWWWD0NUDp7Bbwqxe3d1A/5RhGEnZMRZF0Ke9CamHk/Nevx+qChdxwcq1jQAZ57bs
         QZgVz6iNxD+TYWX2z1KbD5kLfhoLWTzhdBU99FJl9EK6LK1mOxLmI7NN3dbMoeYbt+4b
         AvdX1KUz4YkucRW9/T4nqM5MXRTf2XLJXGY6oxYGEcaco7gJWr4pqkc2mw7fH9d/lWS1
         iVa4BmfnR4ktLz0HA/xXPEB5g9LVGKRJGYRYR4hg0t8Rl06Xf/D62rva7Q6sXq3L7JS7
         LEzk7mMJOW/Ik+MIL8R1qm2FJOeza3DgUI2cpCEVs404YbAOawhPPiP17qJ9zgQYweRl
         baDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633849; x=1794238649;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PQb3q6R6QngEoe3ekBduEqXoGdMTuhEwA2ttf4WySgI=;
        b=dgYg4fsyoAIWzK/tw/8twCUQbwE4XDnVYq1A5S6bU+URvhnNaYDlsn2MDOGGV0j9FO
         a+xeGg85ZvZaTHFq1T2HAGCQAzAk/zhiBPnNwUDQNZAJsiriiOpLfnfCc8b9LB/cS+zV
         2JnDK7k+2Xu1XV+xKUSTsl2H06XVyDsa0KmVGrBwIOL9TwlqZ6rtVl5eoHkhRTO4d5IZ
         KzwYbxkPc0JNdEZjOe1odhg1LSuZO+2//7EWIecx4Y4Pw64dmn5waE0b+GU+9dT+HYrY
         OI85hUZ++0m/v0LlBsj5pvmLPtdUC1iB7BdKmzF1G6kBn010aOU4Q0wLKbaTtnM6pVcc
         IFYA==
X-Forwarded-Encrypted: i=1; AKwUvBz5wpDBq5iGm63xTogmIUuW4gy9oRyMpM/DPDw4jQCPxE+/9HsNG10AB4k3UZ6F+8te3pWPNb3BMQ==@kvack.org
X-Gm-Message-State: APuU4Z+9csVg82S6rX63z0CAJ5y0ghfuSpPv5+T0uwhdvlQ8TWgO9BtS
	qUiKK0v5K7T9tm3oR/dqHuLec7H2vSuble4i8H75InGbbn672ApZAirJrvgOpMifb0hplBsemvB
	J6r5U39V8HA==
X-Received: from plbjf11.prod.google.com ([2002:a17:903:268b:b0:2e8:7c73:6eb4])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2ecc:b0:2e9:9c65:1aff
 with SMTP id d9443c01a7336-2eb364d70e3mr109468515ad.45.1793633848882; Mon, 02
 Nov 2026 07:37:28 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:56 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-28-vipinsh@google.com>
Subject: [PATCH v6 27/27] vfio: selftests: Add continuous DMA to vfio_pci_liveupdate_kexec_test
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 55A21180007
X-Stat-Signature: peo1gabiw84kkphwiyoecarypuspgpt5
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633850-646619
X-HE-Meta: U2FsdGVkX1/dfWt34Hg5ENWwOZqXiXC1Ot1QD9HA18ELKcevUbJ2Tk39DYA1NSAS+So1lT81tZlCnBq+wLfZtcM3GV+5YL19O/Nbqdt8ZkGG/PKnDZ7C6YbcKnE2GwBFBp8kMa567zCm8uygJoFw6cwIH6KbemjoqfkS3TLxvIPSgVKt9SY0fyxvdXsP35hfHZABFBy/A6srsP3hHZLL8t2OO6Kl0f5yyxY2IjGJnCAgTpo5j+mL/LOMF9xHCO42sOcgrPLRk35j/fAz/Ba9h3Wt2xhxBn52icg3IHOIvSZpw4iHOm3qCqRoq6pA8dS6DMaEBBTxvNOLayvOqOwNY8y0AH8AiswOpI6AKO8XHabZBRtIoZXIxQHp7sPKZODZHkPYlayh5FwCjxJ1LjC3de50bfcI1v4Me9Mj2b13nFYHLnQGTSmLHAVDyeHZyksehXsJ+LJd6tuwug/PMrR0hF092X+x3qKqeWXFREBKGeY9oEYY31tLwCXMZ7FZuw55KbRRPtZn23OAZSLFD4gMLY8HTEM9XKjm6AmO2dSg1hPQ+deWSF+RpSrveQwqyhfbyckJQBGpvHd1zFAxJxO8G3xJ0sV6tv1AYwDrPZKlrQxDWLwsxeajKyoz7d1ccoyDbSLnLEBCuJ0MqfNTJ54Uhms+kXd8fn+6c2hUpNrMo1aZme9FuPA1dsbAoBwekrt2Oj7g2fRZO6008wEiPYkmWKLkwu3izEOc6hLF2sFdXdEseuoM0DQzJAPpkt1lTnsGuabtrIB86Q+VoLtDsey/EUolkIWbsesGxRLD8qb1a6nhd/W65nFXyKlN42o5VpWNMUanYiVYoA7gzaJpMHDLpYqht11UyPrG1AFIl9Vwju6l50tu3lTPvydhKXIO9ldKyN6VBMBTbfU9wQmOI/1HQ7aLodBJYKcLq9TFph14nIsp4hz1B+FwjdsnCaRXK3Q73LkfS0q2T4IGW+fF1Gr
 qftdM2Lc
 rXVmf8143TuLntV/tq1HUdZvA49DPpYP/CrvOvTuezmVPM1btJ/tQN2XRHqXQsAHr5pRjSHYrDELJM5FaGoo4PEffQkl5248H/YNAmGvmwUjyLFNeMq9NyqklU+oLpO+I8XgE0AxCKXo8bk1Tp0ZxNKaRLZf8F7ktoKJCWZPeql6yRdvjAq+3Q5AqdAz13lykS4If9G7VzitX6Fh1IDYMFv99VyDbOhG05UlqYfLzA0RBhhei8/gTOz0x5+ZB+WWyMHBYBCEwHzOimmmQqi6QRer9vBzRGXJYDG4Ln81r1EuByzC4FwGbx+gVsNNcgjs+FSNT9lEnMcX4dm73DTgjfbDya1/h+77HrI+b5PKayePEXC3ROj7fIlL1JmnmbknStgc+UV66HNUNrKjg9kbLVgh8m58gg+HYn6UM46iRLfn37DiitT1YvKmw3xJzZdjFBxPaUVnt5niDbg8cGtjQfqmDI8U4F4uF2c5qTGhmRL+cx6UQCqcR/D/08T/Rs+4Ba9+thzm4BYfy/lnC6V70jvB8FcF+SrnZxTCvhYiBZdmR5j6UfIDCjtfi/oNJIIB5rkVmy6Z+f79/3LiXJ+U+nDIo9y1VM/RNjwz/1itnhYjYsnYjqDyymtodsnIW1Dq4IBY3BeXHAlaJW8AoNCX5xEz4S7jbuId5A3lt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend vfio_pci_liveupdate_kexec_test to exercise continuous DMA across
a Live Update when the device is in noiommu mode.

Allocate a shmem memfd backed by three 2MB THP folios (for the driver
region, source buffer, and destination buffer), map each folio at
IOVA == PA via iommu_map_identity(), and preserve the memfd in the same
Live Update session before the device so that LUO's LIFO finish order
keeps the memory alive until after the device is finished.

Before kexec, initialize the selftest driver, run a sanity memcpy, kick
off a long-running DMA memcpy, and disable MSI-X so freeze() succeeds.
After kexec, take over the device via __vfio_pci_device_init(), retrieve
and map the preserved memfd verifying that all three 2MB folios stayed
at the exact same physical addresses, attach the driver without resetting
the device, wait for the pre-kexec memcpy to complete, and run another
memcpy without reinitializing the device.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 266 +++++++++++++++++-
 1 file changed, 257 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 9610fe593cf6..c33b62118523 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -1,22 +1,120 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <time.h>
+#include <unistd.h>
+
 #include <sys/ioctl.h>
+#include <sys/mman.h>
+
+#include <linux/sizes.h>
 #include <linux/vfio.h>
+
 #include <libliveupdate.h>
 #include <libvfio.h>
 
+#define DRIVER_REGION_SIZE	SZ_2M
+#define MEMCPY_FOLIO_SIZE	SZ_2M
+#define NR_MEMFD_FOLIOS		3
+#define MEMFD_SIZE		(NR_MEMFD_FOLIOS * SZ_2M)
+
+#define MEMCPY_TIMEOUT_S	(30 * 60)
+
+static struct dma_region src_region;
+static struct dma_region dst_region;
+static void *memfd_vaddr;
+static u64 folio_pa[NR_MEMFD_FOLIOS];
+
 static const char *device_bdf;
 
 static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
+static char data_session[LIVEUPDATE_SESSION_NAME_LENGTH];
 static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
 
 enum {
 	STATE_TOKEN,
 	DEVICE_TOKEN,
+	MEMFD_TOKEN,
+	DATA_TOKEN,
 };
 
+static u64 memcpy_size(struct vfio_pci_device *device)
+{
+	return min_t(u64, src_region.size, device->driver.max_memcpy_size);
+}
+
+static bool is_filled(const char *buf, u64 size, char c)
+{
+	return buf[0] == c && !memcmp(buf, buf + 1, size - 1);
+}
+
+static void dma_memcpy_one(struct vfio_pci_device *device, char c)
+{
+	u64 size = memcpy_size(device);
+	void *src = src_region.vaddr;
+	void *dst = dst_region.vaddr;
+
+	memset(src, c, size);
+	memset(dst, 0, size);
+
+	VFIO_ASSERT_EQ(vfio_pci_driver_memcpy(device, to_iova(device, src),
+					      to_iova(device, dst), size), 0);
+	VFIO_ASSERT_TRUE(is_filled(dst, size, c));
+}
+
+static void dma_memcpy_start(struct vfio_pci_device *device)
+{
+	u64 size = memcpy_size(device);
+	void *src = src_region.vaddr;
+	void *dst = dst_region.vaddr;
+	u64 count;
+
+	/*
+	 * Rough Math: If we assume the device will perform memcpy at a rate of
+	 * 30GB/s then 7200GB of transfers will run for about 4 minutes.
+	 */
+	count = (u64)7200 * SZ_1G / size;
+	count = min_t(u64, count, device->driver.max_memcpy_count);
+
+	memset(src, 'x', size);
+	memset(dst, 0, size);
+
+	ksft_print_msg("Starting %lu DMA memcpy operations of size 0x%lx\n",
+		       count, size);
+	vfio_pci_driver_memcpy_start(device, to_iova(device, src),
+				     to_iova(device, dst), size, count);
+}
+
+static void dma_memcpy_wait(struct vfio_pci_device *device)
+{
+	u64 size = memcpy_size(device);
+	void *src = src_region.vaddr;
+	void *dst = dst_region.vaddr;
+	struct timespec start, end;
+	long ms;
+
+	VFIO_ASSERT_EQ(clock_gettime(CLOCK_MONOTONIC, &start), 0);
+
+	/* Fail rather than hang if the device stopped, e.g. as it was reset. */
+	alarm(MEMCPY_TIMEOUT_S);
+	VFIO_ASSERT_EQ(vfio_pci_driver_memcpy_wait(device), 0);
+	alarm(0);
+
+	VFIO_ASSERT_EQ(clock_gettime(CLOCK_MONOTONIC, &end), 0);
+	ms = (end.tv_sec - start.tv_sec) * 1000 +
+	     (end.tv_nsec - start.tv_nsec) / 1000000;
+
+	VFIO_ASSERT_TRUE(is_filled(src, size, 'x'));
+	VFIO_ASSERT_TRUE(is_filled(dst, size, 'x'));
+
+	ksft_print_msg("Pre-kexec DMA memcpy operations completed after %ld ms\n",
+		       ms);
+}
+
 static void check_noiommu(const char *bdf)
 {
 	const char *cdev_path = __vfio_pci_get_cdev_path(bdf, true);
@@ -35,26 +133,162 @@ static void check_noiommu(const char *bdf)
 	free((void *)cdev_path);
 }
 
+static void dma_memfd_regions_map(struct vfio_pci_device *device, int fd,
+				  bool before_kexec)
+{
+	struct dma_region *regions[NR_MEMFD_FOLIOS] = {
+		&device->driver.region,
+		&src_region,
+		&dst_region,
+	};
+	int i;
+
+	memfd_vaddr = vfio_memfd_mmap_aligned(fd, MEMFD_SIZE, SZ_2M);
+
+	for (i = 0; i < NR_MEMFD_FOLIOS; i++) {
+		struct dma_region *r = regions[i];
+
+		r->vaddr = memfd_vaddr + (u64)i * SZ_2M;
+		r->size = SZ_2M;
+		iommu_map_identity(device->iommu, r);
+
+		if (before_kexec)
+			folio_pa[i] = r->iova;
+		else
+			VFIO_ASSERT_EQ(r->iova, folio_pa[i],
+				       "Folio %d moved across kexec (0x%lx != 0x%lx)\n",
+				       i, r->iova, folio_pa[i]);
+	}
+}
+
+static void dma_memfd_recheck_pa(struct vfio_pci_device *device)
+{
+	struct dma_region *regions[NR_MEMFD_FOLIOS] = {
+		&device->driver.region,
+		&src_region,
+		&dst_region,
+	};
+	int i;
+
+	for (i = 0; i < NR_MEMFD_FOLIOS; i++) {
+		u64 pa, len;
+
+		VFIO_ASSERT_EQ(__iommu_noiommu_get_pa(device->iommu,
+						      regions[i]->iova, SZ_2M,
+						      &pa, &len), 0);
+		VFIO_ASSERT_EQ(pa, folio_pa[i]);
+		VFIO_ASSERT_EQ(len, (u64)SZ_2M);
+	}
+}
+
+static void dma_memfd_regions_unmap(struct vfio_pci_device *device)
+{
+	iommu_unmap(device->iommu, &dst_region);
+	iommu_unmap(device->iommu, &src_region);
+	iommu_unmap(device->iommu, &device->driver.region);
+	VFIO_ASSERT_EQ(munmap(memfd_vaddr, MEMFD_SIZE), 0);
+	memfd_vaddr = NULL;
+}
+
+static void save_data_session(int luo_fd)
+{
+	char buf[256];
+	int data_fd;
+
+	data_fd = luo_create_session(luo_fd, data_session);
+	VFIO_ASSERT_GE(data_fd, 0);
+
+	snprintf_assert(buf, sizeof(buf), "0x%lx 0x%lx 0x%lx",
+			folio_pa[0], folio_pa[1], folio_pa[2]);
+	VFIO_ASSERT_EQ(create_and_preserve_memfd(data_fd, DATA_TOKEN, buf), 0);
+}
+
+static void load_data_session(int luo_fd)
+{
+	char buf[256] = {};
+	char *end, *cur;
+	int data_fd;
+	int mfd;
+	int i;
+
+	data_fd = luo_retrieve_session(luo_fd, data_session);
+	VFIO_ASSERT_GE(data_fd, 0);
+
+	mfd = luo_session_retrieve_fd(data_fd, DATA_TOKEN);
+	VFIO_ASSERT_GE(mfd, 0);
+	VFIO_ASSERT_GT(pread(mfd, buf, sizeof(buf) - 1, 0), 0);
+	VFIO_ASSERT_EQ(close(mfd), 0);
+
+	cur = buf;
+	for (i = 0; i < NR_MEMFD_FOLIOS; i++) {
+		errno = 0;
+		folio_pa[i] = strtoull(cur, &end, 0);
+		VFIO_ASSERT_EQ(errno, 0);
+		VFIO_ASSERT_NE(end, cur);
+		cur = end;
+	}
+
+	VFIO_ASSERT_EQ(luo_session_finish(data_fd), 0);
+	VFIO_ASSERT_EQ(close(data_fd), 0);
+}
+
 static void before_kexec(int luo_fd)
 {
 	struct vfio_pci_device *device;
 	struct iommu *iommu;
+	void *init_vaddr = NULL;
 	int session_fd;
+	int memfd;
 	int ret;
 
 	check_noiommu(device_bdf);
 
+	memfd = vfio_thp_memfd_alloc(MEMFD_SIZE, &init_vaddr);
+	if (memfd < 0)
+		ksft_exit_skip("Failed to allocate 2MB THP memfd: %s\n",
+			       strerror(-memfd));
+	VFIO_ASSERT_EQ(munmap(init_vaddr, MEMFD_SIZE), 0);
+
 	iommu = iommu_init(MODE_IOMMUFD_NOIOMMU);
 	device = vfio_pci_device_init(device_bdf, iommu);
 
+	if (!device->driver.ops || !device->driver.ops->attach)
+		ksft_exit_skip("No driver that supports attach() found for %s\n",
+			       device_bdf);
+
+	dma_memfd_regions_map(device, memfd, true);
+
 	create_state_file(luo_fd, state_session, STATE_TOKEN, /*next_stage=*/2);
 
 	session_fd = luo_create_session(luo_fd, device_session);
 	VFIO_ASSERT_GE(session_fd, 0);
 
+	/*
+	 * Preserve the DMA memfd in the same session before the device so that
+	 * LUO's LIFO finish order resets an unclaimed device before freeing
+	 * the memfd folios.
+	 */
+	ret = luo_session_preserve_fd(session_fd, memfd, MEMFD_TOKEN);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	dma_memfd_recheck_pa(device);
+
 	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
 	VFIO_ASSERT_EQ(ret, 0);
 
+	vfio_pci_driver_init(device);
+	dma_memcpy_one(device, 'a');
+
+	dma_memcpy_start(device);
+
+	/*
+	 * Disable interrupts on the device or freeze() will fail. The memcpy
+	 * operations do not generate any.
+	 */
+	vfio_pci_msix_disable(device);
+
+	save_data_session(luo_fd);
+
 	close(luo_fd);
 	daemonize_and_wait();
 }
@@ -98,13 +332,16 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	struct iommu *iommu;
 	int session_fd;
 	int device_fd;
+	int memfd;
 	int stage;
 
-	check_open_vfio_device_fails();
-
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
 	VFIO_ASSERT_EQ(stage, 2);
 
+	load_data_session(luo_fd);
+
+	check_open_vfio_device_fails();
+
 	session_fd = luo_retrieve_session(luo_fd, device_session);
 	VFIO_ASSERT_GE(session_fd, 0);
 
@@ -112,16 +349,25 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	VFIO_ASSERT_GE(device_fd, 0);
 
 	iommu = iommu_init(MODE_IOMMUFD_NOIOMMU);
-
-	/*
-	 * This will invoke various ioctls on device_fd such as
-	 * VFIO_DEVICE_GET_INFO. So this is a decent sanity test
-	 * that LUO actually handed us back a valid VFIO device
-	 * file and not something else.
-	 */
 	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
 
+	memfd = luo_session_retrieve_fd(session_fd, MEMFD_TOKEN);
+	VFIO_ASSERT_GE(memfd, 0);
+
+	dma_memfd_regions_map(device, memfd, false);
+
+	vfio_pci_driver_attach(device, /*memcpy_in_progress=*/true);
+	dma_memcpy_wait(device);
+
+	/* The device was not reset, so it can be used without reinitializing it. */
+	dma_memcpy_one(device, 'y');
+
 	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
+	VFIO_ASSERT_EQ(close(session_fd), 0);
+
+	vfio_pci_driver_remove(device);
+	dma_memfd_regions_unmap(device);
+	VFIO_ASSERT_EQ(close(memfd), 0);
 
 	vfio_pci_device_cleanup(device);
 	iommu_cleanup(iommu);
@@ -133,6 +379,8 @@ int main(int argc, char *argv[])
 
 	snprintf_assert(device_session, sizeof(device_session),
 			"vfio-lu-device-%s", device_bdf);
+	snprintf_assert(data_session, sizeof(data_session),
+			"vfio-lu-data-%s", device_bdf);
 	snprintf_assert(state_session, sizeof(state_session),
 			"vfio-lu-state-%s", device_bdf);
 
-- 
2.56.0.317.g454f8302e1-goog


