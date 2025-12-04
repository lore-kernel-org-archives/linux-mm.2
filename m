Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD05ED2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D9C6B00C9; Thu,  4 Dec 2025 10:10:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E476B00CB; Thu,  4 Dec 2025 10:10:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E01C6B00CC; Thu,  4 Dec 2025 10:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C37C6B00C9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:10:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFDEFB6DE8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:19 +0000 (UTC)
X-FDA: 84182124558.02.906E0AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC0B6C0007
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjXxRFyR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861017; a=rsa-sha256;
	cv=none;
	b=aKbtC5OJkrsOrwBlHSwhqePC5PgjTaZ7FoM71loJekf8fpAW4pxcosuMmm6vgS7cYbEisX
	pYM7HJKX8ycjgmjeILDwQWDixqmK7EMXLtIPmfRyCDdowrnoeqvOzQz0ErcnU+8uS/KjF2
	rjRXOHP36hU0+IuU1mtiAsvJBnkzcIk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UjXxRFyR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
	b=uisMmM45TFE7/cpfG6zcNd1arieMOJTzlTnnMWEYC0hwStU+09gH/qcFBXJD7vfG0GnpK6
	rJ1AYb4v4FbIwR0xbhnZJCrjC0sfywLWBz3rkt7Kk1DGiWeZqDChF06DEXhUJ8SL5VR0cB
	jkhXc1Nf8Z8xV1O+Kchm+BJ7kPnm9cs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
	b=UjXxRFyRgUPtYWfloo2tS7mOQre78e3N1XojFjocJ86bCrFPrW/bFREYF+qzeWrTMSNY1Y
	YWjWPB1d+gM7z0qCyVAZcAeiZ9MwCZoqDdrKuZlNeaCOzsKMnzwp74wYW7AJ97lXeLsNvs
	pa4B+xBKvFb3FisM6aLZ0q2DmmnP9CM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-48pR5nyXNX-uhF6fCeqGAA-1; Thu, 04 Dec 2025 10:10:16 -0500
X-MC-Unique: 48pR5nyXNX-uhF6fCeqGAA-1
X-Mimecast-MFC-AGG-ID: 48pR5nyXNX-uhF6fCeqGAA_1764861014
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8b5c811d951so227556785a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:10:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861014; x=1765465814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QqnsDgnWNJJ4lTRWnBZQypy/wcJe61u46quVDoPefb0=;
        b=oLkKDNiFtOZMyXC1m/LURFi95E2ioTDsnTNhwunnJ7oebpn3pZAvSnWlfXj1bgDBKn
         HNiekc66+aAwzldJ20jRVb7QbddGo80ExmxUuu8WIIthAquVYk0mEvNWLya5O5YGVTeX
         wKXFwP0a1MAafhLmhmw0f2uO8jGaJcQs88eDxloPUlLkCQGNjAuG8YuiVMa41WVY+Kl8
         bgPFXDXYsCN7x8nJ5OJq7IzxkCEGHdoJrfRsRwtHGXboQyXtaYlfb1y5wAA3X8IeT6rJ
         MChXqnnWK5Rhwq/wcU7ydSt/gXYUWu+3utF4Uw9ZX0URP7RlaYHcqBNIHfLuexJx0dSu
         Fb6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLuc1bybSQtyfl3+6RisCC1QXp0M7bx7yA4eSBqPBRioVBF7nSdonjhwSNdAn2YSmJWDZokBnkSg==@kvack.org
X-Gm-Message-State: AOJu0YxPDHZ0DRqeH3NlEOjUGm77WHYBr0sedYMSoDgGpwh/exUZT7RY
	wAyu+Qp7f/O3doNZQNV316kM1VyGp/P8odTY7w09/yXZ4oBiqm6LOIzUPzvnTNaRVFBnHpcHuPh
	YUNwlBPmdSGpJrXtzOhAJjj3yJzHsU6rIRHzjSv4VynZnsHAHTdeQ
X-Gm-Gg: ASbGncvfaBT7wpNct+HGIhfRk/GACjjImLwWtqTA+AhsUlI6Ti02qjm4mvIE4Z2+qtD
	wSbzugaY7dUOo/FOzTP8ZkrjmzcahWDBARl8jXsn3l4pJPne4c+9TA7Lb3labHJkZGC1hYdwOI5
	4uj8dGCxgekNs/83wdfY/7Ul8SPIZkoij1yG3Mz8ylNnXOQp884yAIdjqq8Bi006ly/xfeAJ/NN
	Ngkq/lR745v2Nvxj7FPCbDiiHxxs37srKRR/9V0+rg8PPoQmWLybNxZ0kZdRc494E4D4IR0CVMd
	rqGvR8u7t8KjElydxPBgBvXUtu10AbRa/5Ju1KfwIkkGReJUGZ7osHxvFRonKt+iJGTQ4G4RpDF
	4
X-Received: by 2002:a05:620a:4493:b0:8b2:f145:7f2e with SMTP id af79cd13be357-8b5e77339b4mr883014985a.77.1764861014181;
        Thu, 04 Dec 2025 07:10:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHg1P7IVsR21tbM+ynMYgTnLBafpvtkF3gYNVFFKjN2cvYYIUWpdyVgk1EkcF9l/NqzRg+vQw==
X-Received: by 2002:a05:620a:4493:b0:8b2:f145:7f2e with SMTP id af79cd13be357-8b5e77339b4mr883007985a.77.1764861013650;
        Thu, 04 Dec 2025 07:10:13 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:13 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings
Date: Thu,  4 Dec 2025 10:10:03 -0500
Message-ID: <20251204151003.171039-5-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251204151003.171039-1-peterx@redhat.com>
References: <20251204151003.171039-1-peterx@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FOQIsfHrY55frMjbnk4TsKpta99hIwcL0-mQkpfqSFw_1764861014
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AC0B6C0007
X-Stat-Signature: em3wzm6wp43co9e3dmy8yk3z55iy6e3f
X-Rspam-User: 
X-HE-Tag: 1764861017-262604
X-HE-Meta: U2FsdGVkX1/GpXoiXQkUIKQJbh/LOB/x2b3qhAjZXSPo4JAGwiraGyqK34FRGpcPhjlK7a2tFmCJ8C5+n0k0NUpeewzBDPheGbLNJ2QU3+TfUZkTC5rZ0M6+mMTvEPq1HRV/rLhO9bJ5lx9mChexE74hyX6p+JuG6L3anAMN5lNH2gig/7QhS9EFhcu/iuJvMGolXbYmC7gzQGjp0lopu07hHjs9o7Lv5d9YVcZbN39jpfWS52zsOj41KpIL78VssW80ew4pbYHnHQX184ajV3AYxUFA8NA6r517QYIitBQVm+M3RJ84woo4vSURGzzVMrtIF734YeJ5QyFHzqhTICCQ1OI0Y+75G6aCCR3A/F7s2ooIKR3NaJWNWA62Pn31rIt5nsuUWbtxarz3DuqG8fc0sZ5vTwaARy0qCQNYxo1w3KS4LEHFwJWPwjj5ZCUahAHoR4mfECvi7/B9Q0rAymK9+mh4vOEK6Zaf6QFg5s8OigIV8/DT1Wp6FTeaXOs28NWzITjkWv9HR4TSaZL8cO91DiGkU3aExWIAGaHVCeps4nhxZl2yORfoQ2GywGY8tuOxFnCjRaip8W//kBXSmAd5gusmw82kLBE+anJ7MytFO36dezrjQPjD0OiwVgOI0aMM1O9c/XK1EYpsEiZQeqwL1KasxT4f29sWQsmGbMJwGfrXo2yWaWWaOxW/EVjljMvP5rwMR+5P74A93qJU6MuD/87IMvSIuu7H714Dwj1VUnLsyRNjmJ35VRczaZ0iSECesg5ApvimUXV7oqKEtrVuYObPfcLcauayJHv5EnkuOEoIKeY9lLLSnzALq3MKr/x5EYu89fHH5GGHkR8RkeIDAp0/K9i5lIUG+94qK55cvIvEECEA/ytXmFalKGSviiWGljbxMDHj4kgC218KCe1dZzD5I6msO+6tAhGemf7JnTv/Q3cbV6RCUtCLQA5RB7cI3qWsbdNICoCDDCU
 INTfZfdS
 Mi0TiBBu6nSO03xGTUG9ordq4d/4+qfSUtkT7fWZuxX/WNyN397fjhxXqTMN5wRm+LN4zz9U43lTXtT1eB7GMPDxEgSe75KMZnZR7AbSkxgEybGiY9cDSV46l5pd/885O/Jmw9bUbA7gYu8i4aD+I6DWkVcEOBu7QvcuHKpkw+fiHkuJU2sHRY4fYuWzUaD5my7XOQfB7Xyf0gP7X6sqgN0/7SYELOVUp+HVHHq1eJ/XzP7rVH4LnMK5YyPSZe8AUoilFQBn7ldJIotQx1lp8AlXWSwhamRk0uWbV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch enables best-effort mmap() for vfio-pci bars even without
MAP_FIXED, so as to utilize huge pfnmaps as much as possible.  It should
also avoid userspace changes (switching to MAP_FIXED with pre-aligned VA
addresses) to start enabling huge pfnmaps on VFIO bars.

Here the trick is making sure the MMIO PFNs will be aligned with the VAs
allocated from mmap() when !MAP_FIXED, so that whatever returned from
mmap(!MAP_FIXED) of vfio-pci MMIO regions will be automatically suitable
for huge pfnmaps as much as possible.

To achieve that, a custom vfio_device's get_mapping_hint() for vfio-pci
devices is needed.

Note that BAR's MMIO physical addresses should normally be guaranteed to be
BAR-size aligned.  It means the MMIO address will also always be aligned
with vfio-pci's file offset address space, per VFIO_PCI_OFFSET_SHIFT.

With that guaranteed, VA allocator can calculate the alignment with pgoff,
which will be further aligned with the MMIO physical addresses to be mapped
in the VMA later.

So far, stick with the simple plan to rely on the hardware assumption that
should always be true.  Leave it for later if pgoff needs adjustments when
there's a real demand of it when calculating the alignment.

For discussion on the requirement of this feature, see:

https://lore.kernel.org/linux-pci/20250529214414.1508155-1-amastro@fb.com/

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 49 ++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  2 ++
 3 files changed, 52 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ac10f14417f2f..8f29037cee6eb 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -145,6 +145,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
 	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
 	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
+	.get_mapping_order	= vfio_pci_core_get_mapping_order,
 };
 
 static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..28ab37715acc0 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1640,6 +1640,55 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
 	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
 }
 
+/*
+ * Hint function for mmap() about the size of mapping to be carried out.
+ * This helps to enable huge pfnmaps as much as possible on BAR mappings.
+ *
+ * This function does the minimum check on mmap() parameters to make the
+ * hint valid only. The majority of mmap() sanity check will be done later
+ * in mmap().
+ */
+int vfio_pci_core_get_mapping_order(struct vfio_device *device,
+				    unsigned long pgoff, size_t len)
+{
+	struct vfio_pci_core_device *vdev =
+	    container_of(device, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	unsigned long req_start;
+	size_t phys_len;
+
+	/* Currently, only bars 0-5 supports huge pfnmap */
+	if (index >= VFIO_PCI_ROM_REGION_INDEX)
+		return 0;
+
+	/*
+	 * NOTE: we're keeping things simple as of now, assuming the
+	 * physical address of BARs (aka, pci_resource_start(pdev, index))
+	 * should always be aligned with pgoff in vfio-pci's address space.
+	 */
+	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
+	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
+
+	/*
+	 * If this happens, it will probably fail mmap() later.. mapping
+	 * hint isn't important anymore.
+	 */
+	if (req_start >= phys_len)
+		return 0;
+
+	phys_len = MIN(phys_len - req_start, len);
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
+		return PUD_ORDER;
+
+	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
+		return PMD_ORDER;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_get_mapping_order);
+
 static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
 					   unsigned int order)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f541044e42a2a..d320dfacc5681 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -119,6 +119,8 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
 		size_t count, loff_t *ppos);
+int vfio_pci_core_get_mapping_order(struct vfio_device *device,
+		unsigned long pgoff, size_t len);
 int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
 void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
 int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
-- 
2.50.1


