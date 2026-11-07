Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 295E4606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dThzy8Ic
Received: by kanga.kvack.org (Postfix)
	id CB6C26B05F2; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68026B05F4; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E776B05F6; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86FB86B05F5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33AA1A7B8D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
X-FDA: 85406458998.07.EED1844
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 343A720003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dThzy8Ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011837;
	b=dcvAPMmzF4YCvOXlmIqXWQ7gkPpnUDymqYv71vsagXRXikTH+vFEUKuzglmHw9aExaiuvc
	xU0Yy9RhrI9EP+Uezq21zVMi27N4BqiiACEhIsFiH3oZ5fR5Y5q2eiTablqmy8Ma4YT88r
	gXlkx3mrOL8FGsc0Ae+Z2epkRByhx+g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TL9FInk1lsYTO6u3AurrE+L/R7/5SJZwcNTYD3x07NY=;
	b=c3NQrywhpfzkUDT/MvMKKorJ/jkh9/QTimLgPMdThio+p9qD6iV6AOM7w6CXiNKCeLEP3a
	DvQfYELgosaMEtagbOmC0YBsZGP48QQaa+8BjPU/sxHp0TXl63ScNDR70I3KT5NyL/6gRP
	Jyagh6jc3BRcI8H/EmQVsTuBbYbUdX8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dThzy8Ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ED9A60E16;
	Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011836;
	b=ZP1GUijFtEzbidW4eUgaqyLm5ucNpqMmUOJi7TCzBnZ39BeWVOSUDXUp/Jg7JS73FB7v
	 01idXuvKrzOnpjHIBH62F7OSbk2xtq1V4PmfhVLwphSmAsHXCzsSBWyqCliwf7fm04a83
	 Zh/Y55J8y2W5XGCyM+epft25mxeUk8lrI5MexXU9uLJgm+8oBX0ILLSzu07Dv+9iMeIeS
	 hPEWN/RfRI8YPuu2d102Ur5QipyXsKdorsjzsB8HRHaTjgxJSWIyU4OkVHGuT0Cd0W/AT
	 yV34TKgSKcMZV9PKgS+2jhPJVwry+cIX0LQKiJfDtHj9AgDyHqgp/MaCo3UvwuCvBYQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TL9FInk1lsYTO6u3AurrE+L/R7/5SJZwcNTYD3x07NY=;
	b=W8K+THvjvbAqseMWBodDs8O0KgiTQCp7BNoV/H7binfzHUha4ybLFZ2C30m1+pNR2Duq
	 9o/rCvmU1/AEhZFOIsnH4QVTNLvc07MzrL+2NHqGP/xRtzNvSbrIE+ajKRbmsUv92UHhT
	 oqU+ywMVHN0sVXT5YK9aSykQsqpgYQ3Ll8pzCxE0xGxHJNUe7ZVD2hAkr78No1vEST4Eq
	 DbKPk28kc/wUMLjjPvw6Rc4td7HbEec37/EozrYbV/xJLRfo39kYf3OxvpSLvIXelBv//
	 VnRkbyZ+FsXDftB8tWbTbkkvR2NyyvIKS/2sMBR61gua3qm5+qZKhOIgxGeFpmMoCgQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7ED001F00A06;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011836;
	bh=TL9FInk1lsYTO6u3AurrE+L/R7/5SJZwcNTYD3x07NY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dThzy8IcI6ehayDyxI0zAuDMyzNm9+BOR8wBcfTFFrYX5cZw5H1ZBdV4h5dRpJcy/
	 YIwfWJE+OlTgLbzy3AZiR3UqB97qWvBB8GW74sedi/d6ZOUYKY+liPVngLYubO5xzr
	 r512JhuuORdUSLqKGIYZPWxYNCGEkuut4E/mVqEtj7fVTlwQ6k7MEJ+bK6JJeXCRVA
	 gVjYTv+0a2i82UvSjxm0X0kuTVDibo7foo744UjUxt+xmwdttWSiOwyA0IdGVvtpbO
	 xeyO3dsNDrmaa3V+eY1dt4xXjgUVRegswkDkqwQDulMBw9IO7XBqaYIlHAZDNrStce
	 poGxkKI/lkKrg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6E06447A18;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:41 -0800
Subject: [PATCH RFC v3 67/88] vfio/pci: Implement lookup_pfn_range provider
 op for guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-67-8484dde66a7e@google.com>
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
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4149;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kj53wX6TjCo3Ls7iAf/tE3qQ5I1YbpBFtjSmhsKoAw8=;
 b=UGqcrAcsVv3SrllNwFHYRvuMS7F/yXTwffU/cd078QBJ78/flhmGFZuIuSDz1BkYLHrR2J02l
 9Cn3sq8yzYtAYcXlJUg+cZzJjY4YvshyegR2hh6MuqaBiUkKqmjR6Fn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 343A720003
X-Stat-Signature: zaegnotwp6r564c8ttx87kpqgrd5jnpd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011837-923325
X-HE-Meta: U2FsdGVkX1+ItekoGLHhTCPxcVsT4D3t5cGpnlaSuLcXtlGNA2sU91qOSb3gKYv66mqP8+YdiQG0Tm5sYYw+dYkC6WwBngnVKmhnpJIEvQ7U5G9EEVob7S3AM8+jneyBOAhJsf4yYTFcDo7gS2jTpZPz61lQyKwZtQW/nqHhJRgwBR5CFuYsGFxXO1CJPb0ipG7IV+W3bvOSICGSv2+HqzSYPsA/Ccx7l1DrDfWiBeJJThJJmFBgDgSOoVHA/yxcapbQQUiOhIbsVEftgtTwudrdd1kqvYnJMO7qeS5S3waxF4UivtEOrtr6mZhcZmfbQ0qcm2vrs8inVIBxOaDz0a9touBrS0eoHbiYhFsgVas+/V3bWc2MJZPgOg0gqN3KKt4zOJ3Bi2QFEPQxHCVKTcyHsXowebavUt1W3y4car38cA7S6q31ntH/udiwV30+y6bs17F8kl+Pg5BimoYZ407AGZwgJOnNM8aVQXLOSVUiaYP99k2k50ODWLkDnGec6KIiH/RMkf2ArRYiRulO6fmYOjGNy2aWDFjzEXLxUl+UnQN/s8D9mnKcS+jxqEueagNoYcVrD9EA2fboL55m7XiV0rd7U+++MiYBv7wN2hjrMHzDdXmflHBm0wNSHdfmqWr7OGSB7TKGlY7N9swicBf9VTzy+zBsDm/eXtj8cBbgjBmhFPi0fYSOWUnuV874SxjGb5Cey2SBRJJwcC4MFEuRRCLE8r5ZhheHy3Y5+VktX3xvCwS037tZKesc/icznQhHOsKx7YnqI0kHwrdfiqGB7n7ajdC1rr1Heco3uXN6gCyUbOnPgU0CCv1m3GBvu0MhHL6VO4n2UV0Ju42RxkRDoVKLkBSF0KLrsNUTgAhrTfSx6BWZLkXG5LFjZvFabCtfu1wNv0C3oq/HeADM75UUho0W7Y4sVAuPzumOr7ZmFt9jv/5uPq9FOj2T1MPn1rsFSHnbHOzmU71wUvI
 22d5mEAN
 4g2X6lRZ66yeJixsMpEIC23YyovUJOubAO/C9pCT2BjZ35bjB7frEoBhH3Y0QiG3vrsLqABrd3RZnBBmLMsrA6zRVZWkaV1V8MO0AkJP7IDFiudtSoXtoyX/Ob80y6bYZWcN+x158RLD9x2GcofnxC4Aztsm4bPpwZ03BAB3ci1SlmNzODuSQg6t3G/u3ns3K/MLrB1wgdIzTtJ+9kXS/mgAoMd0TIEM+nVqovfm+XnfmRD4Ryoh7sojSW7EhU7XkHpZl9MC+iJFiJWqPtBCuPLUerQto8Mtob3+Udu9rNFE/GHA4aWS4NEeTRWcRvSx1X9l5RejpD55mPGf5MGH2kjdGC/PQMb+fLxYlykXf6uZt/P9ufdP7w3dt6L23uhD9p1989Qzbmaz/vPeGVm86sboEu/vjuOhIjGswYTOFgu9ma9oQO0s6SQmCaza0PcTcKYtcoHeoTT65p7EJAVTZIVI0JHWGnwAkTenyf+6u43+VJ9YGVSJhXn7Im/iZ2lLtKIrrGPkmqjc5Q/ZO4gjrF7J1b53Q6E4Exl29w8bUsFvur9SR2iROSLH+eXBk0m/lM+g7qPIREsNrl8ypkzieF21tZNv/zuSkLwvYa9FqTxXIY+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Mappable PCI BARs are placed at sparse 40-bit VFIO region offsets
spanning 1 TiB per region slot, while unpopulated BARs and non-BAR
regions past the standard BAR namespace have no backing pages in
guest_memfd. Without reporting contiguous backed and unbacked extent
lengths, guest_memfd conversion and reclaim loops across sparse region
offsets would step one page at a time across multi-TiB holes.

Decode the 40-bit VFIO region offset to report contiguous extents:
- When the offset falls within a mappable standard PCI BAR, report the
  starting physical frame number and the remaining page count in that
  BAR.
- Otherwise, report the hole length up to the next mappable standard
  BAR, or to the end of the page-offset space when no further mappable
  BARs exist, so scan and reclaim loops skip multi-TiB gaps and
  trailing non-BAR regions in bulk.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci.c      |  1 +
 drivers/vfio/pci/vfio_pci_core.c | 42 ++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio_pci_core.h    |  3 +++
 3 files changed, 46 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index f42422c1b7bc5..6f28f1ffbad0e 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -172,6 +172,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.gmem_attach		= vfio_pci_core_gmem_attach,
 	.gmem_release		= vfio_pci_core_gmem_release,
 	.gmem_get_pfn		= vfio_pci_core_gmem_get_pfn,
+	.gmem_lookup_pfn_range	= vfio_pci_core_gmem_lookup_pfn_range,
 	.gmem_check_set_attributes = vfio_pci_core_gmem_check_set_attributes,
 #endif
 };
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 2b29d0ec6a0c9..a9274d95e9066 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -2829,6 +2829,48 @@ int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_check_set_attributes);
+
+int vfio_pci_core_gmem_lookup_pfn_range(struct vfio_device *core_vdev,
+					pgoff_t index, unsigned long *pfn,
+					size_t *nr_pages)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	struct pci_dev *pdev = vdev->pdev;
+	u64 pgoff, bar_pages;
+	unsigned long bar;
+
+	bar = index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
+	pgoff = index & ((1ULL << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
+
+	if (bar < PCI_STD_NUM_BARS) {
+		bar_pages = pci_resource_len(pdev, bar) >> PAGE_SHIFT;
+		if (vdev->bar_mmap_supported[bar] && pgoff < bar_pages) {
+			*pfn = (pci_resource_start(pdev, bar) >> PAGE_SHIFT) +
+			       pgoff;
+			*nr_pages = bar_pages - pgoff;
+			return 0;
+		}
+
+		for (bar++; bar < PCI_STD_NUM_BARS; bar++) {
+			pgoff_t next_start;
+
+			if (!vdev->bar_mmap_supported[bar] ||
+			    !(pci_resource_len(pdev, bar) >> PAGE_SHIFT))
+				continue;
+
+			next_start = VFIO_PCI_INDEX_TO_OFFSET(bar) >>
+				     PAGE_SHIFT;
+			*nr_pages = next_start - index;
+			return -ENOENT;
+		}
+	}
+
+	/* No backed standard BARs remain at or above @index */
+	*nr_pages = max_t(size_t, ULONG_MAX - index, 1);
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_gmem_lookup_pfn_range);
 #endif
 
 module_init(vfio_pci_core_init);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index af74766d7c90a..b6e2fb93f9500 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -178,6 +178,9 @@ int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
 int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
 					    pgoff_t index, size_t nr_pages,
 					    u64 attributes);
+int vfio_pci_core_gmem_lookup_pfn_range(struct vfio_device *core_vdev,
+					pgoff_t index, unsigned long *pfn,
+					size_t *nr_pages);
 static inline void vfio_pci_set_bars_available(struct vfio_pci_core_device *vdev,
 					       bool available)
 {

-- 
2.56.0.455.g6c5a503b38-goog



