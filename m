Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FD9D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8FBA6B00A7; Thu, 29 Jan 2026 16:26:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE8D6B00A8; Thu, 29 Jan 2026 16:26:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1DC6B00A9; Thu, 29 Jan 2026 16:26:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7B86B00A7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:13 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A4AA16028C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:13 +0000 (UTC)
X-FDA: 84386284626.10.EAF1394
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id B1C3640007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KpNNh4Az;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3ctB7aQgKCFU09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3ctB7aQgKCFU09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721971; a=rsa-sha256;
	cv=none;
	b=rOgEWiQmnTHCiGAE/GCs5Xbvdl+W9R5ynNn/VQhNIL2ZAO05oXItX4SOYK+Z07R3TH6bPT
	FHPuSi/SlPTfCptpHLQ1qyo27BGyBUp4Gzpi/zNtbFwYYAciI6piuLUOBB4lyvd4tbrpCz
	E7cYQINo+LAJi0YTWPUx/WFgYhOpkMY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KpNNh4Az;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3ctB7aQgKCFU09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3ctB7aQgKCFU09xG8xz73BB381.zB985AHK-997Ixz7.BE3@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY83qjLDePi9A6Rw0FeAVcPg0HBWAQ4uS6Od5NUhNZI=;
	b=SFF1swGB+DVLE9h7mUfKurMZhlwxG+R51yFaOqISPTW6bTGEKEWk4menwELbsms9+6sWyP
	Dj0jIBvVLecmCYpgBDWMyqZlhd5JFzznPoPEcDCFShMzyogWXDAeFuQd5O/fVNjUPJKJW7
	afLWl6C8DX9GHI/qeHQlbsp/YH8YUT0=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d203988so2580401a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721971; x=1770326771; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jY83qjLDePi9A6Rw0FeAVcPg0HBWAQ4uS6Od5NUhNZI=;
        b=KpNNh4AzEJYH1EmA/pdlbQz5ocaxwVN/yRd/8RqWNrivvv0h6MPr4qjBeFAmONRCUM
         ulOZ2HslGNHscQn5vK4wcu69pJBpoqwekENWEOcTXQIpvokIEsFnk553MVb+CWr1TTdj
         uictsQqF3+KemehlBB5wmAE7XjDimYglhd1fN+Fsff+sQh+7eRBlnfcl5y9PQO3huiEb
         GSUYoMBl+oknRF/zmij1AgW+MSGQzsUfpsHaVYiiORIuC38mrJCCZSVz4r0/hWBmtHoG
         cw1OfEtCM+WP9TkjKHXa6pwP4FJ8rxTaD0gZ+EO8aW3Qxyyv1ZMQit2sUmbkPrYL7fi4
         NR/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721971; x=1770326771;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jY83qjLDePi9A6Rw0FeAVcPg0HBWAQ4uS6Od5NUhNZI=;
        b=nkwwuxt964FwL8MZNrh/qFFrebxZ3YZt95AXdUeHOWHKHa9JytPEoiDsnjGyAEQ90i
         bn7q2CkUXH+P60T45QjFSbJEJa+s5sfbZE8JwLJZvBjj34ToBeRAM1+kLHRQBni7VAqm
         yUHKGdYoEvXHTJi8GVhfg3ng4KZrxmfCuVyvqUbbKZJ/I/y7M9UuTbENKByP9mmr9kyw
         2xdJGbXUXI194nocwKYmUt/eQ9kTRNAtOtchKDEsipqRLvHTH54flAwLnsNZU00r2ZgL
         w/8pY/Z2HH6lnLnSBk3UYSF1dmVhOHaEMJ06t4fTYU6lAKeocCjY3XImlF0hOi7HL5iz
         R3HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWY3/xudmR4c96M+6F66TiLz7pwL32kXULg5w8jmnpaRMIxccyEw4p+Q9BW0KNukNvcmhSNXf9OA==@kvack.org
X-Gm-Message-State: AOJu0YzBnzZHRc1/J4xsrnaLj+/pzUq7kpeXuv4tXTZF2TNMwVEnTENL
	f9+1ihgObuJRChztVnRuDCGeDYbZlfpJ/TzWESwJACmRnXwWEGzaGzPrmg4ilNpRjP42Yyx2hBk
	aS1qoaDNluFiSvA==
X-Received: from pjvf5.prod.google.com ([2002:a17:90a:da85:b0:352:d19a:6739])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:510b:b0:340:a1a8:eb87 with SMTP id 98e67ed59e1d1-3543b3ba97dmr804461a91.35.1769721970642;
 Thu, 29 Jan 2026 13:26:10 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:07 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-21-dmatlack@google.com>
Subject: [PATCH v2 20/22] vfio: selftests: Expose low-level helper routines
 for setting up struct vfio_pci_device
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1C3640007
X-Stat-Signature: f3up4rtzzrx3m44w9bz8o5o731bu7w6o
X-HE-Tag: 1769721971-715790
X-HE-Meta: U2FsdGVkX1/IQaniWEKP/2LzmJY0r3g85XjEFKPuT3O+AbttQBwGcujpazOedZtXBsJxJ9og7VFdGvw8MU7NTlzFCnH78xwB92p48A7Fk+GpAtpWp2i8oDxNJUecKt9lOBrtzLB2/DHTdvS9W8Z7o4yeHAhe6hpG7KZNtAidsexFhkDjM869xcxGgImj6F86byNwauHZ+JijEo8GYFnVkY9EZBwQOggoZRL1UNPE8xarGoEnwM8yDi6dFzI51PuoUnfsryvTknxkS1LSTJOo09e9hwF9lzg8Bmj2KZf355Bt2mbk3XwGetpR5V4TyjfCR+6np9YftUJT39R/kgTT2/lPJMP3qcUIH9DQ+Q7VlXJCNk+SceBwaZe4r3oQJGqBY3vj+i+s9AhUAQu0KBZqNFE/2p15dWoROOtBp59aIcQPjwPANx0+YjF7Wf/QjLmBMMLUR+DyQJgHd37EuWWF3a3Iszf/UJ+XTgh6qbnvagBCl1Hvwa/AxYGM4LcwH759EibK/iedyxEhECjQef02zGIE8Jqhpv8/mpbNri9O3KBFbIt/5RbndeOshG1LCjqW80ZeSwg/YW9uiq+s3qWGo4kRhuPrtOUaD5q7PuzYQPYpZpSIs3eh5n5IBEuWaXiECb0gHHGVSaJzDOh7OpiA2+g7M0dX7XYi4s3tMhQWpzMpvBXKJwR00vSz5seaAMyYBw6bap+qoOkCiey4IYNhu79tjmsmatd7NQJX6rS91FEhAGq5I6P8UrbczaciwMR/B1b9PRE1AWnEhqzJNqWGDce1ZqIjjSzgn4K9CbrKS2Gk2iKVTDi1VwH9/mwBs/LkKB7ALP4MU1xr8q9XJ73xUHgSSIh7tpE10zwMEbWS9P3l6+GKm4vb+YjWaQyv1Qz4zd3h6F86b89Tb/Mmed7BrT7WxZGe0Jj7+Dclr8D1CoQerZYMF2nwEeiG8urVG2FlePKoc+h0XwNOY60Yb4P
 ShRDqmbd
 CmgFeF32rRHV5RLlRCVRmXqsjVQFuwyWie/xhxtIXUWENhA5XFx1RLzJ7ocITXMCs2PJ6fmMrVQA+ePJYcl+vvv1BA2GraLYx0kjesBor2ikjnv//QgUInvN9RQeX3bg1ODTZ9XG90L/Wxi/t0jiVJ9QkqkUfKe72Pcn8+2Uf4DTYrWklhUYbv5mP5XWUmDNnFqrmd6jUV2KajQS1xYm33/tjg0vCBywI1jW07lvk3IX4EFZVrrobkIhsUfxVGCzzqHkCb7Xdh2XSSlGYCmXoU1vtfTZaDWAcASaXH5IfOMEUr+H9cf09Rcp93bScFglLrqd5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a few low-level helper routings for setting up vfio_pci_device
structs. These routines will be used in a subsequent commit to assert
that VFIO_GROUP_GET_DEVICE_FD fails under certain conditions.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  5 +++
 .../selftests/vfio/lib/vfio_pci_device.c      | 33 +++++++++++++------
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 896dfde88118..2389c7698335 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -125,4 +125,9 @@ static inline bool vfio_pci_device_match(struct vfio_pci_device *device,
 
 const char *vfio_pci_get_cdev_path(const char *bdf);
 
+/* Low-level routines for setting up a struct vfio_pci_device */
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
+void vfio_pci_group_setup(struct vfio_pci_device *device);
+void vfio_pci_iommu_setup(struct vfio_pci_device *device);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_VFIO_PCI_DEVICE_H */
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 08bb582eaa8f..76597c84e956 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -198,7 +198,7 @@ static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
 	return group;
 }
 
-static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
+void vfio_pci_group_setup(struct vfio_pci_device *device)
 {
 	struct vfio_group_status group_status = {
 		.argsz = sizeof(group_status),
@@ -206,7 +206,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	char group_path[32];
 	int group;
 
-	group = vfio_pci_get_group_from_dev(bdf);
+	group = vfio_pci_get_group_from_dev(device->bdf);
 	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
@@ -218,14 +218,12 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	ioctl_assert(device->group_fd, VFIO_GROUP_SET_CONTAINER, &device->iommu->container_fd);
 }
 
-static void vfio_pci_container_setup(struct vfio_pci_device *device, const char *bdf)
+void vfio_pci_iommu_setup(struct vfio_pci_device *device)
 {
 	struct iommu *iommu = device->iommu;
 	unsigned long iommu_type = iommu->mode->iommu_type;
 	int ret;
 
-	vfio_pci_group_setup(device, bdf);
-
 	ret = ioctl(iommu->container_fd, VFIO_CHECK_EXTENSION, iommu_type);
 	VFIO_ASSERT_GT(ret, 0, "VFIO IOMMU type %lu not supported\n", iommu_type);
 
@@ -235,8 +233,14 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
 	 * because the IOMMU type is already set.
 	 */
 	(void)ioctl(iommu->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
+}
 
-	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
+static void vfio_pci_container_setup(struct vfio_pci_device *device)
+{
+	vfio_pci_group_setup(device);
+	vfio_pci_iommu_setup(device);
+
+	device->fd = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, device->bdf);
 	VFIO_ASSERT_GE(device->fd, 0);
 }
 
@@ -336,9 +340,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
-					       struct iommu *iommu,
-					       int device_fd)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -349,9 +351,20 @@ struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
 	device->iommu = iommu;
 	device->bdf = bdf;
 
+	return device;
+}
+
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd)
+{
+	struct vfio_pci_device *device;
+
+	device = vfio_pci_device_alloc(bdf, iommu);
+
 	if (iommu->mode->container_path) {
 		VFIO_ASSERT_EQ(device_fd, -1);
-		vfio_pci_container_setup(device, bdf);
+		vfio_pci_container_setup(device);
 	} else {
 		vfio_pci_iommufd_setup(device, bdf, device_fd);
 	}
-- 
2.53.0.rc1.225.gd81095ad13-goog


