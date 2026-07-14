Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2096C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7546B00FB; Tue, 14 Jul 2026 11:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182046B00FD; Tue, 14 Jul 2026 11:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F086B00FE; Tue, 14 Jul 2026 11:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEAA16B00FB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 591F2160413
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:28 +0000 (UTC)
X-FDA: 84987731136.11.16AF493
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CD78C0006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cb52OKqw;
	spf=pass (imf28.hostedemail.com: domain of 3jVJWagcKCOQbOVOTYNMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3jVJWagcKCOQbOVOTYNMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgKrbgFKZxbxCBaliRqkNgo/i0ql++Rr7PTW+pok5fM=;
	b=CHnecpg3C0aolPWLUCncVqBR4ZVICD5W6fEMH/haY2Y3yzv+0TrBI5wMU0VGyr4GEH8cKt
	3OSYb3dOmJzlmV1GUw5e2novY2XsE/SViL3u/lMRJtBAuGPH+MUqaEwEhCim2Ok0ygP/gi
	l1XCdP0ZUEhniuBnm1Eafsla299Hom4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Cb52OKqw;
	spf=pass (imf28.hostedemail.com: domain of 3jVJWagcKCOQbOVOTYNMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3jVJWagcKCOQbOVOTYNMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042126;
	b=pRRvULuJq0pftU3SJbvvnWD7TbcfGuPZjQPgoPg2d+HNjimOU05xiE59PLoYzEjOEHwLl+
	bH0puSUwi9p7eP9tO7qw5SnVOF8/Dvotb9jyDcIr25jxlFDQJzUs0NR5EjT0A91CyMmas2
	HkBiDbUAh303PoAElLuXT8ab4aHiERE=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8485d853b08so11060109b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042125; x=1784646925; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JgKrbgFKZxbxCBaliRqkNgo/i0ql++Rr7PTW+pok5fM=;
        b=Cb52OKqw00yM6UEev9zn6RaNxn4yoxKEjeEuQf9SSiU1vCFX1hSSnM5E2lv2/U8+rL
         eeNzZatKZUEal8dHuZ+9dt60vp3Ans2nPeb3iFRj/VVfFTHpg7f0KXqmgDclNI/29dji
         L57F+4ONoH/LlaVMmXDtzNR1aOZU71mear7ShSSPWfni85AE91bXkNV+azAiEVppUfU8
         GsAWWCB4AglmEZYmoBaeDIAO/Uu/5xvk7k94xjzuTigsertsjDQgw5/e/TET4VIQ4uA/
         RwJ+7AjJFrVtrs/jhILMyw2XKq/NwqX0zLBCn0QkCenjeUdYFxbcsN2C43sqH3BEImW9
         tt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042125; x=1784646925;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JgKrbgFKZxbxCBaliRqkNgo/i0ql++Rr7PTW+pok5fM=;
        b=Odlx8f3TeOzvD44IcpXAMXdGR4y07JDgEEHKxL0VYIyt3o/b4e5NalGkmiVlo/Ckz4
         3CwkF2iT5v7jzHPS34yrwyOYwZNgv+Dnh/cLUPteqydXxpk4aNDQrCAyFxiW0hTG54Lf
         TAubhWK3nW4Cepq+Y/O82wS4vICDxZqRg3zynvsUO3lw2dQN4DLD86Ge0He2s+OxM1dc
         0cxkq5LG1OOKQ0/kvaUoQoYaPAtHDce9w3Fyv1mYytL6NRDJ0is01nAaf7wkFNKlr1Bb
         GUiyhRjPUS5YQfxpG6618Q86pPyZscT+WJ8NWxgh8TIw6TKJRTocxhnkE2Wnc5qFGnzw
         Z6ig==
X-Forwarded-Encrypted: i=1; AHgh+Rpa3svQ26d2+iz4LXf1ysU7HkSIVLqXPF32mFQEIIhrRg5K5oHVG4gvpfRLDqkGgdOmys3O2wGeyw==@kvack.org
X-Gm-Message-State: AOJu0YzfLqhJcA06kZBt1IjKnb3eAyeNldJ4/rumvXnVRP43+GHrDoUj
	Xl8tabJnha5PmwMUXUT2ZcLA644Qq/Ht9WSCyse9CJL8rZGatTr3IxCWnz2Su4vUCyqXW7y5rEr
	x9HNZsHw64Q==
X-Received: from pfbll1.prod.google.com ([2002:a05:6a00:7281:b0:845:e386:e036])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1f14:b0:845:e9e5:cdec
 with SMTP id d2e1a72fcca58-84a559bb7dfmr2554072b3a.62.1784042125277; Tue, 14
 Jul 2026 08:15:25 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:00 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-16-vipinsh@google.com>
Subject: [PATCH v5 15/20] vfio: selftests: Initialize vfio_pci_device using a
 VFIO cdev FD
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
X-Stat-Signature: sbzu87yztifffptocfsytwczjqg5cbcp
X-Rspamd-Queue-Id: 9CD78C0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784042126-838057
X-HE-Meta: U2FsdGVkX1+q5vgpSEjXMxbDsT4IEUnTOoebS/rAvHytK4GdIKMpvO2Bme2GXFSqqnfoZbjV2Dsi4bP2jYd8iVZlitZpdD12fDzVWr9xkP0Cadq/c6wX0nka6dl8YP41BpTtRSUzmIqpg51jcvbAeW9lIfUG+j79KWvWiWijJd4wjzaBNTtCBu/pmQw9YVXCgh4a2j+TDErKU94PsubcCkc5umR5CuAlTDqLHs67HqT9h6MWXvxDM72OomEZhQNsGoK0pxyv+P290DkUWhFVWfVs2phSwC0CqXJrr/fS7BH5rYftMud5C2zJHwd0vMRq7ID/ReEpqbJsDzNTGRbmTSCnQWjSVAjMGIEaBTLLo+mudR+XnHS1po1xnj2aYgyzgEYD1gmtEWJ5pOHaGRY6BlSL4VwiaK4j+ewFVbMDocru1hikAo5XtA8A+Wu96alGPmULm/JZ2snYFWCWsLItGDgDbTf1XQZp/E7+TKOHXr7m1iS9FWRcViLUoKUwfcEnw4cI+E+bd7TriVEhr/2WXGhCVW2M2A1c+4XktPo7PtJqL+0LRYBorWfSevBVyuTdR9kCjuQyi8uxEpppgVb+mvzowwru7eclWdlk05QY11tjm51Ej64ZKPiPxshH1aG0sITrASWTXx0ixScOj9vV6d+uFZw393DygZ3ANpaaUpoINt7AV9i5W6Q9gkgJCsYmt6ASjdPyaUGWna3cFxTz4Oik+aidRd0laBc62Am2dOI2LkZ3TNNKsSIqFAj2QWv0T4LxTH1pHvWesNjk65q4IRPQn2P2IRJaAoaimI3jFxjIUaiblkQY9Q966gZIzKY0EwIzoDLk7sovfVeJH8rQti9gw+pKISSlF/ZZcsZEvvHXVcUS2kOMyu4cHptyqgBwYgauVpahTfSMx0sRM6PJna2XSBCs3Zebi0j6SBha4dUdmZ3R7igHE+VpI2HOxvKR8GlNGegnrs5tZJKi7gB
 xW8R7PrS
 5MD1csmgwl5puXCFH3g3OPFlB4TcUrexoVNWDa453f+UnTXSr8SfqRY0g4SE9Y0GzO9839BTarF8YDtIH0Ilv48glBJBfRHdP5EziYrUvfQq+9O/6ZTJ59qi8kctBeUjUNqtuNNHyM/yQzQCT2OmGKSaVs8WZVAG4eJY/Nqf0xZskNnuyr//jwPuFuW8GMDzUVIq0do2jpAmBGokWr4PLINQctx6SoxaMPfoLlu3DdEtfMgoU1Si1toY0LyQXuUMgZWP46wBXVVICWKI3UMWZNymDDbUnwNRXuFV7n7t7e88dnMV10i+VNns7vm7x5iMMqDr+uMnejQivxbD1uNAdXZfqg/Rd4odDVJvMyYk8ZUCkadnNvHutS+YGaJoQwjjZjUkX70GHBK+jjMpKD/3C3rjm2EVybjjCuefPRACT7HcNctkLaSg9g7/21OKa3O9pj2CQIufnGsGcMqOWkgK/GUZXD4wzXAD1w7k0KWXPhL+oSdTmwniVgikHOorxvI0WShETmiyKqzyHimwnVjQApDVXFQgYuHx6AZWxa/co4i2ZoAk4J1tpu/mbLjUQlDYRlo9fIbr1JEKP+c4XZaSwM3ef5qO5Q+xm9aFhUAQlJH9StvpfoygOZvDUGlO79AjYRE8o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the given VFIO cdev FD to initialize vfio_pci_device in VFIO
selftests. Add the assertion to make sure that passed cdev FD is not
used with legacy VFIO APIs. If VFIO cdev FD is provided then do not open
the device instead use the FD for any interaction with the device.

This API will allow writing selftests where VFIO device FD is preserved
using liveupdate and retrieved later using liveupdate ioctl after kexec.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  3 +++
 .../selftests/vfio/lib/vfio_pci_device.c      | 25 ++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 3eabead717bb..66fc29662daa 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -40,6 +40,9 @@ struct vfio_pci_device {
 
 struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_free(struct vfio_pci_device *device);
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 94dc5fcecbeb..a6e0e7c6e18e 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -414,9 +414,13 @@ void vfio_pci_cdev_open(struct vfio_pci_device *device, const char *bdf)
 }
 
 static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
-				   const char *bdf, const char *vf_token)
+				   const char *bdf, int device_fd,
+				   const char *vf_token)
 {
-	vfio_pci_cdev_open(device, bdf);
+	if (device_fd >= 0)
+		device->fd = device_fd;
+	else
+		vfio_pci_cdev_open(device, bdf);
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd, vf_token);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
@@ -440,16 +444,20 @@ void vfio_pci_device_free(struct vfio_pci_device *device)
 	free(device);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd)
 {
 	struct vfio_pci_device *device;
 
 	device = vfio_pci_device_alloc(bdf, iommu);
 
-	if (iommu->mode->container_path)
+	if (iommu->mode->container_path) {
+		VFIO_ASSERT_EQ(device_fd, -1);
 		vfio_pci_container_setup(device, bdf, NULL);
-	else
-		vfio_pci_iommufd_setup(device, bdf, NULL);
+	} else {
+		vfio_pci_iommufd_setup(device, bdf, device_fd, NULL);
+	}
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
@@ -457,6 +465,11 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	return device;
 }
 
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	return __vfio_pci_device_init(bdf, iommu, /*device_fd=*/-1);
+}
+
 void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
-- 
2.55.0.795.g602f6c329a-goog


