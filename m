Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0016CCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9066B00B2; Wed, 14 Oct 2026 05:37:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0A06B00B4; Wed, 14 Oct 2026 05:37:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049B16B00B5; Wed, 14 Oct 2026 05:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF4386B00B2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D60C140459
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:48 +0000 (UTC)
X-FDA: 85320729816.15.5AB138C
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8AEDD140006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CNdIwe0Y;
	spf=pass (imf26.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2vqgPBzudi7/wozeWO4xZg2nwY2bakbLYAqbfosODE=;
	b=GCIOcKn7soZTm9Q1YNb1mp13N3DWmB2WTl3OAosU/TEJVbIUSbAAhK/2x0QVYzyqWxmiYE
	uqZ2cuernMerwPJifwyNIMO0nhCjS4h9a79YC38mJsg7idc9MO4nrUU8/OJ0I8OIPTqP2M
	KSRWscxpTCcYyoO/B/vla9j6PihrBkI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CNdIwe0Y;
	spf=pass (imf26.hostedemail.com: domain of griffoul@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970666;
	b=dOSreVA3d5sY/aXfqqqfMu7/q359smM6+0uD1hQ/TVDmKVq3NQ4DaUilFeJaeDq41n5WFF
	HCs1mxK8bdbzHGR/1dmCVCO1f6pb5daXyHOaMh/Gt8V6g4Pgn3msxOOwYa/9PD/82qcCFc
	ZyCVUpj9WiREJAzrMhA19snR9Hilqa8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48dc202a60eso1398506f8f.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791970665; x=1792575465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o2vqgPBzudi7/wozeWO4xZg2nwY2bakbLYAqbfosODE=;
        b=CNdIwe0Yk082U+XYoww6gPKNIsHsUCoG8xSLzdVPFxFx0URfSLO0LZBcWyQWv7fWZs
         kfUSQqZcr5qeVxvAGeYEfG0b32hTIh1M5Y5Kiu4pcpCgGjZrjie7AbM4/V6/i0xGSYYR
         oNJyg5605AK1Y/qZWaEuTSZvgpUtauVMOUo4n8lTDb37PqTSsuTY4pDL83EDDufLKDan
         V6KsH8rNMBVt8S5GCljPVrzFIYPxcadA+mFwT9l6bqB/PaG+8d2sOtiHxcSFgox4FVs5
         WGngrDCJyriZ0mN0S8puA0sHxZz3cBr6wP9nu9pRe7x7ybFljHB0YBkHNf+1p85vpinv
         v6bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970665; x=1792575465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o2vqgPBzudi7/wozeWO4xZg2nwY2bakbLYAqbfosODE=;
        b=HIrOoQKIjfIvHV0ghZj/2Uj7FTG8tia3SgCT3N8aUMMr/XlnPdrd1znFLjo0YZ9gq5
         Ry+awcuGrgBJgdxM89KxjDxYS9UhQLcCaYHz8ew+BbcKUhFQtGNww2xNtRk6HgMFoWR2
         eVqsU+/ZjyYJydanNfQZJQvDCek0cz0KKUsntSnaOu6c25MEJ1CSxU8Exi3dxuNi754S
         7LBFtm+mHcau1NrxO+6t1KWPinqA15O6ZM1J8xODHwaC97IAKuHPgkTlMR4b9Iu1n9f+
         /c11+wCuB+aNQ4UPNzwgg8Mf+F4a67zzp6Y9EDAVxTFDekgpuIWFXUTQR+U9OO35/Gs2
         JJmw==
X-Forwarded-Encrypted: i=1; AKwUvBx+RKng2BbBiQjMch5XGL1Cbv0c7qPuTwmDl5dC3z2WOGcqJ6cuMG049KTh6FIgHs9pWcquBH8Jkg==@kvack.org
X-Gm-Message-State: AFq9FYIKErvKCuS32J7Lhf9RkUnoW+CFrvjNq9xdHCRGt/c8HfS1XYrs
	KpSzU0yh7mCjaT6zWCdbenjMpY/TESWCQFfC1JpZHmkKNtAsUicXSKhF
X-Gm-Gg: AYBFou0ERYbIHj9opDjSlHaLeoh01Qb7SaBSCLCR4mB37XJRDTqqGAhga8ajY/oh7Au
	ruIlwlff+an207qMtLrRIvnvD2dGXVBxzXuoKiek6CKoEdfigg9uCDxZ7AK+0GLlPHw/LEl5gZF
	ajM8ppNjjyTepkrBVrYKQtEHflq3gdqOwlDOu0JO32Wifmy9mmDY6aUoMPPhNLRWSKj1J9+8zB8
	HSeM7vMpRilIHQJO0uJLWxOLgNjsAho3bKaIQv0A1OnrDBdiJrHzCTQIkEqDx8wenIibJgCozL+
	XiQtxIWviQ1cFqFZElKR/Y+enBwEelzBvCQXVxft7LWDuFGD22cpuDoBq1twBYEECsHpS5vUmat
	/lG23coDcQHcy7Ny3LF8WoN5CmZ1dt7bwtpW86Ov5EPsmUBgbmTeNvCT9JST7Zhn453XhhI2YoT
	pv2SLtQK2+WusZ39H6YPo6lpYAVK/nW125lXXy/vW7UqaZVlhAleWG+gyTHlh5XwxHm0T+Ew7DQ
	pbNegE5yU1YV0kRUDYnnpae4kMalZIht3ZRn5bq1vRIx6WkKcobFOmtwha6I4PmguxvREnDsAz4
	Jqx8PONuPIJKusuqLd2VW+Xwzb/kWfcW/9A=
X-Received: by 2002:a5d:588c:0:b0:48b:5083:96ae with SMTP id ffacd0b85a97d-48ddff64e46mr11244091f8f.15.1791970664941;
        Wed, 14 Oct 2026 02:37:44 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm9365477f8f.35.2026.10.14.02.37.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Oct 2026 02:37:44 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 07/11] iommufd: Use large IOMMU pages for provider mappings
Date: Wed, 14 Oct 2026 09:37:29 +0000
Message-ID: <20261014093733.90312-8-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261014093733.90312-1-griffoul@gmail.com>
References: <20261014093733.90312-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AEDD140006
X-Stat-Signature: ps39ju8x3jyhgdfuchwanbg8o8e94m1p
X-HE-Tag: 1791970666-908364
X-HE-Meta: U2FsdGVkX1+mmTYpNF3y4NdmWefbIlwWglw8dDVrHvlYpz4NNYhy5TVQmoGe4zpA6TuM0f7HHJ60i7UrUFef+9m1d6j2jLrbfXj8kuEUYXt4dCxvM4RLRMHxjqa8+pou4yM1UdAzWIQx/n0IdZ+xcjtGzb1Be9iLgJQiU8OzMm9QIreL2y2NanwzGKPRxCiWG+7S/uAOMrsEo+aK2hPD7FZgUyaE1H88zRFackGdh3e/1NWHM2XeX6GYGQdeMGwz5xdds4ab2M1ERqIvwgAaqjwWnHxc6HVh5ZHu1LUZEfyxLWKSM3RXoek1Ug+gzdcFFom7O/fYk/60n/DGcbPmRn3nS7xPf0ctHnaK/eDfLsCMIbR9SkQXvbCAAW9dWPuB3HPxQBWDYGOzWxp+BBnvqYlhtssgX/yd5o97jZ3xZCYFjde6Vxs1R3Aw8v1coxTTuljQGU3UU6JyWtphYKDiIBnTE3gjL/DGjV0lKep085Ky/iSDifbVLHmMCGDzaOEVuCNHxP2w4Trkm4J2vk5m6XfnaiNvtAOqWOJ9SGjmFkEtRhMXBKTAVzip4u0K/5u1w5u9DpddNh2pm+DDkHTlVRm17YedmzQUbvr6twU5dQI8fXyWTnyZCATPuA4e0Otvp/TnWa+itG/oWpYW2RoScRYDpxhLdDe6RDGd9yUuqZrliOs3YBAs1hDssLYqQpqgiDDgswDu6sspU9M5ipWhfOS29ud2ai2qYG9DgIqpM646PI2U1WFhx4ZRNcGpL87GoAEpJ6uRqqFixgZtSk6nKE7lOk3nRBjUFxVsW56aI3lydfVBB0o3hkRqfLi443DXRLU2lfut+9oynbIwGkiW5kzg8sUxSSB/3DcG9SG3Ga79EI2713L3BEl+GjOtOmPBjrjn1RNDnRYuYMN3In5uG8fxgnORc6y1d5ho2vsusDr4nex2wYsx/XSe4B1T9QQShVXpLniL61T5i6xSEpy
 WPs2cbPg
 LtS4JyNKuudd3SzhVZXlMa4amhDsQmlOY6CFrP0AiBxQ4trBFksHgfvsgjRPRFUPZSv+ubsMBlp9uB6bEu2T8+TMmHb9VHENS/qveNirq2RVtn4tC/+rF2stryAFS0hGkENQuhA/BHhFWG0STUwXkflxBqjdHzN3iRZFXdjNoo5Kw58S5KlSOyBtSQoYXUzWb50QOMLXY08ZbIiq5dgnNoeopXgNBm0lxJ53nBxQiKnsMHfT4k5qBuRAbFfbXYZhFSJvO0SOfCJeVw8f3uJ6inGYidOXVqGQjMqPk//kx+6M/8y+3ur7d+mxceu7i7PfT3XRygJTkwNZbmULB9YruWJ7hsvf+bT5eziVi+xg+AQC+GSu5UWI8KOKCmYi6vAJ/F+k7idjfb10Daiy9/sOj3aeQ1y0lVGUT3McveEGs5zcLonFcQY7Z85DMUB9+5+WlyPLiogOOo+NT1nddDRyatsHKdaKwHE4FufF1bhVSvARNM+QVum8B40GXM2Hyc6vDjfAk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

Provider pages are mapped with one PAGE_SIZE entry each. A device that
uses a large provider block then misses in the IOTLB on every page, and
the IOMMU needs more page table memory than the block requires. A
revoke also flushes the IOTLB once per run of pages it unmaps.

Map each block that the provider reports with large IOMMU pages where
the IOVA and the frames are aligned alike, and with smaller ones where
they are not. Only the pages of the block are mapped, as before.

A large IOMMU page can only be unmapped whole, so a revoke that cuts
one widens its range to the whole page. It maps back what the provider
backs now, and a device may also fault on the rest of that page while
it is remapped. The widening finds the page with iova_to_phys():
pages that only look like one large page make the revoke remap more
than it must, which is harmless.

iommu_unmap() may not split the range of one map call either, and
virtio-iommu refuses to. Map each IOMMU page with its own call: the
widened range ends on IOMMU page boundaries, so it also ends on map
call boundaries.

A revoke now batches its unmaps with iommu_unmap_fast() and flushes the
IOTLB once.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/pages.c | 114 +++++++++++++++++++++++++++++-----
 include/uapi/linux/iommufd.h  |  11 +++-
 2 files changed, 105 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index aa7740326ad6..4b284dae26fe 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -241,11 +241,17 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 }
 
 /*
- * Provider pages are mapped with PAGE_SIZE entries, and may have holes.  Some
- * IOMMU drivers warn when asked to unmap an IOVA that is not mapped, so find
- * the runs that are mapped and unmap each one, without touching the holes.
- * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for
- * an IOVA that is not mapped.
+ * Provider pages may have holes.  Some IOMMU drivers warn when asked to unmap
+ * an IOVA that is not mapped, so find the runs that are mapped and unmap each
+ * one, without touching the holes, and flush the IOTLB once at the end.
+ * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for an
+ * IOVA that is not mapped.
+ *
+ * A run may hold large entries, which can only be unmapped whole: neither end
+ * of the range may fall inside one.  iopt_provider_map() maps each entry with
+ * its own call, so an end that is not inside an entry does not split a map
+ * call either, which iommu_unmap() does not allow.  The ends of the area are
+ * safe, and iopt_provider_revoke() widens its range to the entries it cuts.
  */
 static void iopt_provider_unmap(struct iopt_area *area,
 				struct iommu_domain *domain,
@@ -254,19 +260,23 @@ static void iopt_provider_unmap(struct iopt_area *area,
 {
 	unsigned long iova = iopt_area_index_to_iova(area, start_index);
 	size_t left = (last_index - start_index + 1) * PAGE_SIZE;
+	struct iommu_iotlb_gather gather;
 
+	iommu_iotlb_gather_init(&gather);
 	while (left) {
 		size_t len = 0;
 
 		while (len < left && iommu_iova_to_phys(domain, iova + len))
 			len += PAGE_SIZE;
 		if (len)
-			iommu_unmap_nofail(domain, iova, len);
+			WARN_ON(iommu_unmap_fast(domain, iova, len, &gather) !=
+				len);
 		/* Step over the run and the hole page that ended it. */
 		len = min(len + PAGE_SIZE, left);
 		iova += len;
 		left -= len;
 	}
+	iommu_iotlb_sync(domain, &gather);
 }
 
 static void iopt_area_unmap_domain_range(struct iopt_area *area,
@@ -1700,11 +1710,30 @@ static int iopt_provider_prot(struct iopt_area *area, u32 attrs)
 	return prot;
 }
 
+/*
+ * The size of the entry that maps @len bytes at @iova to @paddr, the largest
+ * that iopt_provider_entry() looks for and that fits.  Mapping each entry with
+ * its own call keeps the revoke from splitting a map call.
+ */
+static size_t iopt_provider_entry_size(struct iommu_domain *domain,
+				       unsigned long iova, phys_addr_t paddr,
+				       size_t len)
+{
+	unsigned long sizes = domain->pgsize_bitmap &
+			      GENMASK(PUD_SHIFT, PAGE_SHIFT + 1);
+	u64 align = iova | paddr;
+
+	sizes &= GENMASK(__fls(len), 0);
+	if (align)
+		sizes &= GENMASK_ULL(__ffs64(align), 0);
+	return sizes ? BIT(__fls(sizes)) : PAGE_SIZE;
+}
+
 /*
  * Map what the provider backs in [start_index, last_index] of the area into
- * @domain, and leave the holes unmapped.  Each frame is mapped with a
- * PAGE_SIZE entry, so that a revoke of part of a large block never has to
- * split a larger IOMMU page.  On failure nothing in the range is mapped.
+ * @domain, and leave the holes unmapped.  Each block that the provider reports
+ * is mapped with the largest entries that the IOVA and the frames allow, one
+ * call per entry.  On failure nothing in the range is mapped.
  */
 static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
 			     struct iommu_domain *domain,
@@ -1729,7 +1758,8 @@ static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
 		return -EOPNOTSUPP;
 
 	while (index <= last_index) {
-		unsigned long pfn, iova, block_end, nr, i;
+		unsigned long pfn, iova, block_end, nr;
+		size_t len, done, size;
 		int order = PUD_ORDER;
 		u32 attrs;
 		int prot;
@@ -1752,20 +1782,25 @@ static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
 		iova = iopt_area_index_to_iova(area, index);
 		prot = iopt_provider_prot(area, attrs);
 
-		for (i = 0; i < nr; i++) {
-			rc = iommu_map_nosync(domain, iova + i * PAGE_SIZE,
-					      PFN_PHYS(pfn + i), PAGE_SIZE, prot,
+		len = nr * PAGE_SIZE;
+		for (done = 0; done < len; done += size) {
+			size = iopt_provider_entry_size(domain, iova + done,
+							PFN_PHYS(pfn) + done,
+							len - done);
+			/* On failure, iommu_map_nosync() unmaps what it mapped. */
+			rc = iommu_map_nosync(domain, iova + done,
+					      PFN_PHYS(pfn) + done, size, prot,
 					      GFP_KERNEL_ACCOUNT);
 			if (rc)
 				break;
 		}
-		if (i) {
-			int sync_rc = iommu_sync_map(domain, iova, i * PAGE_SIZE);
+		index += done >> PAGE_SHIFT;
+		if (done) {
+			int sync_rc = iommu_sync_map(domain, iova, done);
 
 			if (!rc)
 				rc = sync_rc;
 		}
-		index += i;
 		if (rc)
 			goto err_unmap;
 	}
@@ -1804,9 +1839,51 @@ static int iopt_provider_fill_domains(struct iopt_area *area,
 	return rc;
 }
 
+/*
+ * Find the large entry that may hold page @index, which iopt_provider_unmap()
+ * can only remove whole, and return its first and last index.  An entry of a
+ * given size is aligned to it, lies inside the area, and maps its pages
+ * linearly, so look for the largest such block around @index.  Mapped pages
+ * that only look like one entry make the revoke remap more than it must, which
+ * is harmless.
+ */
+static void iopt_provider_entry(struct iopt_area *area,
+				struct iommu_domain *domain,
+				unsigned long index, unsigned long *first,
+				unsigned long *last)
+{
+	unsigned long iova = iopt_area_index_to_iova(area, index);
+	/* iopt_provider_map() maps at most a PUD-sized block at once. */
+	unsigned long sizes = domain->pgsize_bitmap &
+			      GENMASK(PUD_SHIFT, PAGE_SHIFT + 1);
+	phys_addr_t phys = iommu_iova_to_phys(domain, iova);
+
+	*first = *last = index;
+	if (!phys)
+		return;
+
+	while (sizes) {
+		unsigned long size = BIT(__fls(sizes));
+		unsigned long start = ALIGN_DOWN(iova, size);
+		unsigned long end = start + size - PAGE_SIZE;
+
+		sizes &= ~size;
+		if (start < iopt_area_iova(area) ||
+		    end + PAGE_SIZE - 1 > iopt_area_last_iova(area))
+			continue;
+		if (iommu_iova_to_phys(domain, start) != phys - (iova - start) ||
+		    iommu_iova_to_phys(domain, end) != phys + (end - iova))
+			continue;
+		*first = iopt_area_iova_to_index(area, start);
+		*last = iopt_area_iova_to_index(area, end);
+		return;
+	}
+}
+
 /*
  * The provider changed the frames behind [offset, offset + len).  In every
- * domain, unmap the range and map what the provider backs now.  A device that
+ * domain, unmap the range and map what the provider backs now.  A large entry
+ * that the range cuts is unmapped and mapped again whole.  A device that
  * accesses the range in between faults.
  */
 static void iopt_provider_revoke(struct mem_provider_attachment *att,
@@ -1836,9 +1913,12 @@ static void iopt_provider_revoke(struct mem_provider_attachment *att,
 		struct iopt_area *area = track->area;
 		unsigned long s = max(first, iopt_area_index(area));
 		unsigned long l = min(last, iopt_area_last_index(area));
+		unsigned long unused;
 
 		if (s > l)
 			continue;
+		iopt_provider_entry(area, track->domain, s, &s, &unused);
+		iopt_provider_entry(area, track->domain, l, &unused, &l);
 		iopt_provider_unmap(area, track->domain, s, l);
 		rc = iopt_provider_map(area, pages, track->domain, s, l);
 		if (rc)
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index b4500fc21368..04ca2a244267 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -241,9 +241,14 @@ struct iommu_ioas_map {
  * behind any range at any time, and the mapping follows: pages that the
  * provider does not back are left unmapped, read-only pages are mapped
  * without write permission, and device memory is mapped as MMIO. A device
- * access to a page that is being changed, or that is not backed, faults. Such
- * a mapping cannot be split by a partial unmap, and in-kernel accesses to it
- * are refused. It is not supported in an IOAS with a dirty tracking domain.
+ * access to a page that is being changed, or that is not backed, faults.
+ * Large IOMMU pages are used where @iova and the provider's memory are aligned
+ * alike; a change to part of a large page remaps all of it, so a device may
+ * also fault on the rest of it while that happens. If the remap after a change
+ * fails, the range stays unmapped; userspace recovers by unmapping the file
+ * and mapping it again. Such a mapping cannot be split by a partial unmap, and
+ * in-kernel accesses to it are refused. It is not supported in an IOAS with a
+ * dirty tracking domain.
  */
 struct iommu_ioas_map_file {
 	__u32 size;
-- 
2.47.3


