Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A1DF532C3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7786B00BF; Mon, 23 Mar 2026 19:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0596B00C1; Mon, 23 Mar 2026 19:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A306B00C2; Mon, 23 Mar 2026 19:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1DD66B00BF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C82D140DA0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:19 +0000 (UTC)
X-FDA: 84578996838.03.34EE21C
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1F59140003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gxKka1RS;
	spf=pass (imf26.hostedemail.com: domain of 31NPBaQgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31NPBaQgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6ai3Q1Y7nW49bYKBphuq9xPRlXveX2MorY71NenjMU=;
	b=rNwgjRWf5h+IWthXntHty26jFkV4WC0CgHuyGK0M8anXq5IPbGqHp3L7g2ARB2G61Y9b0u
	+MyfQHSr9414j+LHVRWt7Jnjsm3J9oug8Pf+FbedWOlPA7T7mKvUWs39cHrJZjwrQOdf1A
	nKSr7rlVxFlQQZELQB/cujMFA1pzjmc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gxKka1RS;
	spf=pass (imf26.hostedemail.com: domain of 31NPBaQgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=31NPBaQgKCNc6F3ME35D9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310357; a=rsa-sha256;
	cv=none;
	b=V+ZFK9fqa1flT8aaJm5elFjk+2YfD9ZZMzktq0P3lYeQIZVQzswkwYMGmRi1QfGb9UvQXk
	PY8QUyvYOxtTt/F0s3fWTTi0zch64axS66Srge13+5wkLm3pdG7g0cX3FqwzTAOEGICV+6
	95jhTW9JtSERPK7TjfCj0WDjOGeiZ98=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35ba4bf54beso4265981a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310356; x=1774915156; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a6ai3Q1Y7nW49bYKBphuq9xPRlXveX2MorY71NenjMU=;
        b=gxKka1RS7w3QfvHh/75Pl/DNIU5J995rs12q79OyYqVf98WV0RSBEDM9lZ2U1KtrX1
         s6myKCQ2dA5M0b7dskCP/etIYScbJfafj1WLUodaBVVhIoOgl3WnA2P2SYivF3mDYJyY
         blBFaLMWdhqLzNIiDdSaSYAcuaGp/66zdRv7l25Mn3XYN1hcjILEdDsMZ354ekZtpyh+
         yNrqA4TKvReBbOI6scP9HcjlPhEkpuI+UV39i05YULDibS61yKHByLaMe/aYm8vy7Qph
         XIoFkxhnga2FKyLbZF0mevZmH/WvivdSxZyLkN0Sx890n5WtjtNs6QZ/llV9Ku5/ITv4
         7hhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310356; x=1774915156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6ai3Q1Y7nW49bYKBphuq9xPRlXveX2MorY71NenjMU=;
        b=fXIFTQO/4fmd/lUd8DJazIzuS7GbwKm2xb5ACiMzw/KnEoL4GJJipUCbyFftRrmkms
         tTzwcnMpoZJHnHIr6Lxq/doIlVeSlShV1EQ1hB7sPKdsw7nV/Pu11v+bazh9U+XYeS8w
         RyOw+hgu+NKx0p6pyO896JgjSbCMzFCoABf9fKRX/w/wBwErlNpgaOL8ZiJxV1sFYB1j
         522AqQ1t6vARCSq/sH+R3ajBE9usmyiOx9C7o10hA1jSIjaOIrGjQIIIdKqMze3ByNYH
         y2FgPAC+wRA4gpGYV3bUCBapyPFszr9rGiQ/te/C/3z9xFTXhdhzvPzYLfFLkkRSD1Dz
         roLA==
X-Forwarded-Encrypted: i=1; AJvYcCU3BNDc1PFICv3IFhvMwZzV6ucU+lBkk8phcgvmqPEZBPxSRQCuriFKKmOlhXjgO1J9z4PY9obKuA==@kvack.org
X-Gm-Message-State: AOJu0YwC6PaBDKviOjCW7glWgZToSk/NbHM8BrW6aJI9GyDtk8aZmNE6
	BjPHqjvKrlHYSYo9ydPTP8qw9GLQ77NnoFnRsm9rPsgSPGq5qk1UQvzsJQlNynkW29S4pS8y1Wl
	2k1exMSQyUl1xUQ==
X-Received: from pjxu14.prod.google.com ([2002:a17:90a:db4e:b0:35b:a2a4:de5a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3891:b0:35b:e85a:865e with SMTP id 98e67ed59e1d1-35be85a8693mr5878913a91.33.1774310356298;
 Mon, 23 Mar 2026 16:59:16 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:14 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-23-dmatlack@google.com>
Subject: [PATCH v3 22/24] vfio: selftests: Expose low-level helper routines
 for setting up struct vfio_pci_device
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1F59140003
X-Stat-Signature: 5xz4yiytt6qr7ztrxkg4fm7bun6kfoxb
X-Rspam-User: 
X-HE-Tag: 1774310357-81623
X-HE-Meta: U2FsdGVkX18wTlqSzyUBwcxmBVYvweLq18aMu8Td4jqQRTeBlsw3fAcNc0F9xU2yGtovQ/QEUEjhgAofpd811aeD5I92yB4kUOyE+A8+fd8D1aMvDpBpWUT6Po8USJIzyb8oZzjcZ3YGlbCc2JSDBpgihgQI6DFYrGQ8PYRPLFH8BGa+NDNIV6tvkdAqtnYj2ROMdPQ2JroAINqoKVnDCCThktXX09b1Kb0R4mGPy6gqkeCRdaQfxoYOfwWUgZGHArbJUPuk6tXMHmHZFkhvZNVNbDxAslbxdh8DHzXBgGpd7DXnPAebOGYlxOZWuHBLnxHCrRbrr0liqME8mDSeLxYHqBykil36OA9v5jgPCwIKYyT8nTmlfVNsrz+gry3hS/nrYf3UTYX3NOIaD4UlIamBdWXuz7TJ+R3trhfsOEaph4yeJx87GX10FAnL/pOmnDx0/f70YK0A3IDKF+v3S952B/xoRvANnMoTXDl3kexSSmDsatE1513f3gaArpPXTUL3h2LG7KVE65uhG7M/o5zbu/t42rV6gWAjeQ5oySojb32I1tSW06tT4iikxYmdUFd8gfxQeOpYZnCUL14pWPvqdZ0K1tzy0VklpU2FVB+Dj6ffNaU5YJUTR/VjZyO7A5Cqt2vWpocZ4BHZBaRqtPYYpzG+ITYocTKZEVwDPCx/C261xwZp9R/xAOoOcOVJ1zeSwfypuEVdSrlTAn1yTpk2G9baD5/GLyLSvq3Hfcbx7R8lmmDWfjrPLXx2S8TjM1mjI/LwGiNKdKfon3MSLAnBmlKaMFXum97LsKzVNtAwuqr+aCCXPPHj+dTKF318hsVGlGhzcIyj2fH3n7PeAvvbOpy+Wq1RWZbKWFO3yj1C5wyRD3i5g9O9RmisO/XwnwbGa4I+OHhhNrIyO+2G4EbhnNYcnl9t0WbZ38hrtJNLILqAz4NN28/oxdtl1i7X65ffNuC13wsJNamjqRp
 tBQhV2Z0
 4bqhxfSLo8iFDz7GutHjCJOQusvC4CdBxETmO+wgu0M0+cviewDUdk9iOuK36Ix4VT1Y9khw6M/w323iGyygQmPhqkI+DbiNBahEeGpB+a6iMaHWttG2wzm0WhIsqFq3GFQAtYHJXkXvem7O1wbragOtgxmkD56Fao7LKKOGhj4Fe2Tw+OabgT8+LKhSg1Vw5Io5PQlEHKtKgKXh55QcPaZdZLF3dSnQ2IGbE+CdaAtIllUuQXq0FkQeArbIKAak93euPuDsNPBwIlvvzJE/jbvrBLlhKpJTP5FCP0T3hk40Cl+/ucsNTuyURFu5kJX2q3/QXC0ZDI0JooA523HjIT1L5AGrmI1oyj3YKStEinv2kADJJotP7DCrao/4oq/hiq/Cx3RXiDgvr7P5eE//IxgttJUBvQIkWRTWwpyK8W0gzYYgnIGrPajouyF4RJSySJF39wuyscBFpc+fgqFv4WV7UVwSUNtXhGpr+oUH0kxYCsh07jhRQsvYA3heiWfBefs1lLQu293BJThfVkOvNBDZnNc747eXCsoqBB+io1z7fR9hbxHXcoCPGX7nFOwSaB/Z6gTKmkJGoP/wF22aYyT1x1C/m8J3Dit4DyR6hZic4UCo=
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
index e9215c712cda..66ee268110e2 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -220,7 +220,7 @@ static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
 	return group;
 }
 
-static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf)
+void vfio_pci_group_setup(struct vfio_pci_device *device)
 {
 	struct vfio_group_status group_status = {
 		.argsz = sizeof(group_status),
@@ -228,7 +228,7 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
 	char group_path[32];
 	int group;
 
-	group = vfio_pci_get_group_from_dev(bdf);
+	group = vfio_pci_get_group_from_dev(device->bdf);
 	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
 
 	device->group_fd = open(group_path, O_RDWR);
@@ -240,14 +240,12 @@ static void vfio_pci_group_setup(struct vfio_pci_device *device, const char *bdf
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
 
@@ -257,8 +255,14 @@ static void vfio_pci_container_setup(struct vfio_pci_device *device, const char
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
 
@@ -358,9 +362,7 @@ static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
-					       struct iommu *iommu,
-					       int device_fd)
+struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu)
 {
 	struct vfio_pci_device *device;
 
@@ -371,9 +373,20 @@ struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
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
2.53.0.983.g0bb29b3bc5-goog


