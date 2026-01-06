Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BDC1CE9D78
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1B046B0098; Tue,  6 Jan 2026 11:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01FD6B0099; Tue,  6 Jan 2026 11:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9F86B009B; Tue,  6 Jan 2026 11:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 803206B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:22:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E8081AA23D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:16 +0000 (UTC)
X-FDA: 84302056272.05.6E2A420
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id 36AD040007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Dzq/z+JJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3tDZdaQgKCOcbVXbcJOJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3tDZdaQgKCOcbVXbcJOJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716534; a=rsa-sha256;
	cv=none;
	b=Vz3e79rX2DBgJ4kvmgjgGo5PXKDYCCfZUsSOksHaU74qJzLnFp+RhLcXsggRLAbaBeNZJH
	jDX1uv6g2MoGATk5QmuzCJC3QLVNlEO2ju/eC5saSI3+B2rkfYRnDROKn1QuUEINaXafPN
	bm5vPkzEemgSjMqk7EQAvTEGX6DQOM4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Dzq/z+JJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3tDZdaQgKCOcbVXbcJOJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--smostafa.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3tDZdaQgKCOcbVXbcJOJPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G7euyx2l/lFhNmo6AV48hUE7kw2bo/jzXTOveIYTXGk=;
	b=mmtyF6zx63iZO44kaL09cj1TJIAnWOBYzcmCasZoQcQhZ3GhDYmVE9+1DRNCpyu9ezWSqN
	CrSnsG/+S8ZsvP6ag5fwtBVF5paD9eUWdruSsgEqT858J14xe4bbc+jZ1D5+/KuX19baNL
	fkEIG1PPQai+yFQUtbwcbFVs9zRszMo=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b79ff60ed8eso135360166b.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716533; x=1768321333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G7euyx2l/lFhNmo6AV48hUE7kw2bo/jzXTOveIYTXGk=;
        b=Dzq/z+JJJT8H1F1nfzbzPifRnpwV4i+tk2QS49/KtUbtZyTbQZDc5whl2j3hRK49fc
         9YRRgJf0pZoNxpWWUMKG8g4VcCp66dgpcJ7LAscJo0TIt9od0kWXjJvZIXgc4C6cq7NR
         EAFxbs7e3Fx2Z6Z5srrU1k2zzw7MoglTBoBF+8v8a6+Av3P/QMKkZt0HJ/J4V7PPPNR8
         EVpRT/7Y3n3OuevGnsDps1qLwu/EZuDSktvVzYZIIV88/S86U48LX8sArIbeeBhMnoiI
         1lmgKGtjlrNLCMv0+hGRz94OkeLo7/zC59GGB1P13uEVyWsaHvRYS9C9lESIhKr9bLBP
         pVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716533; x=1768321333;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G7euyx2l/lFhNmo6AV48hUE7kw2bo/jzXTOveIYTXGk=;
        b=IZtNYelLbssYtA9Leq5BkYaZcLZtZMt4DaTaBspMJqMhDQEVfFas2jD5+MsV+nFOJ8
         yVsujwDhAkcCt8KQ97D8FEQojl6xrb4upRM3pUJmAB4sxv3AxdLNEQj7r+jb5S7LYYwD
         d8+UpARjf5vOLEEGydLQGX4rOjAkZNsu0qNqJN/89EF2WMOsSSssi8HgtLW9DRss5Yn/
         iu/yaXkBrobwvlcJDDz3Sn3yuOKNUsEToS8fE8a36T52VdabeV8ynjfC3sbNZ1pV5pdd
         1Sm7Jtn+yZ/WAuURl0wT6kx/qRlh/bM3/uLNftu0s+DkDgMMW3l9i9GzftYSndYFoEFq
         Cjaw==
X-Gm-Message-State: AOJu0YxrD7AhHBWYwJCd2+lQJHQoXmLvjz9AbZmgwBiicLWozjzYHxAz
	kWnUpEkleMu1YacMar2Ek4uaBi1Pdr/g2fbaXjRCA+6zLMqgAVAlOIu4JBdoDtIwmTpO2nmqHLM
	xsazdk3IIwNk1RqvkYaYToSw0S8qwzLuB0/EIaeqry2vZ/3FckM9kMH/gPejuoHMcyb8nt/9W3H
	UqjVrSId5gH38CRjAgZ7k6rcKyhe0wMJLoXsvNa78LbQ==
X-Google-Smtp-Source: AGHT+IHKuH10kjkZ8zaCmrcCmU1cvF8nSsBKUsUrtCQVeYxLXeu/BwvVsndP2KZRLEWkWRgI2bRUPCcpfcbaHg==
X-Received: from ejcrc16.prod.google.com ([2002:a17:907:a310:b0:b7b:bae3:33a3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9415:b0:b7f:fbb2:baa with SMTP id a640c23a62f3a-b8426bf1f67mr332737466b.51.1767716532695;
 Tue, 06 Jan 2026 08:22:12 -0800 (PST)
Date: Tue,  6 Jan 2026 16:22:00 +0000
In-Reply-To: <20260106162200.2223655-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260106162200.2223655-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106162200.2223655-5-smostafa@google.com>
Subject: [PATCH v5 4/4] iommu: debug-pagealloc: Check mapped/unmapped kernel memory
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 36AD040007
X-Rspamd-Server: rspam10
X-Stat-Signature: 9tzj9hdcwug6mx31p81m1x1xzyaieyz1
X-HE-Tag: 1767716533-104795
X-HE-Meta: U2FsdGVkX18u4aaXym6UaQo8noLB3o4wuNJ7A+04MT6C4wX10WY5x4kUzSgvjUB1l/Gl33l1kza/FmjD+NKfpzos3LCIqB5g0XVvHpG22q5o1aXTqqCVTvf+sBDZidQuvYz4WD8NxzRG0VeoDm+JckmNFsAaPGAtrUL/8hQMnf+NRGI0oHwwlV5GX9hLhNu6SjPCsmfYLrYn/RTFOyzPcOPLFIFEYi2JqmR5Qg602PAVv03aw9PGvPBK8EfW0JI/wdwsA3HjX+WrD2+FPyDdgLYCaP9mbBZTU8IA7P/Z4W1NYMPdVqO6CU4lAExinP9xBCYkMQ2l4zCfKRuUuGCIAqg7j7Cg/+pJAm4tJJnreei2NnxPxR08obuS1aCITCgXp1+faE2SaMtEWiW8RwpxwaHOXBpyiiKama9PYSWCgEm2H38PgdJGsdSo5+5F9vIAdyr1Tm6aV79PVmtKfvGf6+qKhshEAYfkWO4lPIgrlDLE0TIrf7g+yS3TQsRv6Xs1cBSbumNFD6psXm2Sj0naSq4jpS/Todct8hSXiYKkZsRHBmNj3lLEWHhn7Z2p58AuKxBDxNOieH3HWT+iQ70Bx1pl3aW3wPwLUHPtcyt9PEtxj+IwH7ZgPHB4DiTcIXDb5ihRTISWBqfbdt3lEf168umV/SnSgmoAu3Vq0cPKF4Q8VjAbk03lCsk5hUUwi4BBBWkuDupS84EFRaOAf5a1i581heRCdmQT2EwAa7KIH+GEUwGRv1RvGfNEtsRV5zZKW7PTgepDJexAmCOlgrZdq5VIlwNchQnFz51byqPdiIdBoNc0Z6IIGPY9yDUGyu0TFIXI7S0Z3DCmzTsWXtYGnDIAqxWctJQPrmv6kiV60ndzjDBlvUVyurRewOy+aK8sDcYuMGMw9unyEBcbeRJsb6iTCRuoXapEClsq0dJx9GdZwGMsxFu5Brp6LVzo0xjcBeoacFiSoYaFG4q/ZDX
 4GMIF7bB
 KbaSPDrgV3x88gWhctO4SeV3EJhCq1hFOSO2U8e6L1XLKsnewa5r24fzT1oygnFZB8Aib3E3ilP3L8OpVz/O5hJLBCodNpMrBZBTTxHq1IO47hoOgZcFx1AvoimDi+kOTlavqSRTbMuAiHDUoOGVrZuQiqAmhve2CR/+aMQ6WiZLCzY94PO9vqw71oaAQyF02Vi/Y8YdSMAAT+W+kJVO67+W/ybGeoD1GOqblmhRBsxc3zKTFVYbZhpEO3ASDZkbZ82gqFxY1IxyuNRCxypCX/DmY3xLUIg15HwPCFsRTu4TEcPW0n0UzK7DMPCL9lCzOPLXIQmXJtcD3omGSeHyrLAqHFdEmgAwusarJr1f05BeWsr8mQIHKc59EzHjSk4bpw5cFvVdKuqLbTf9JUBSQTnvPWOOrLotGqH9LUTxyuJiR5PfvXp6wxLPKex0MXL8QTIC4mC/o2dlj4Lj8ifZxV5FeeI+s6PHqCl5mi0pb+d86J/G/tiDM6M55xusHOaaih9bO83CxqZcs1d7VLDDEzwA/3GpZL//RposcGAQFyrWnZi0d1IU1USX7FRJwQiM6SchrRlT7CmToxIkbBi/T2Co/1K8bGq2NUL4tPETYogjxN7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, as the page_ext holds count of IOMMU mappings, we can use it to
assert that any page allocated/freed is indeed not in the IOMMU.

The sanitizer doesn=E2=80=99t protect against mapping/unmapping during this
period. However, that=E2=80=99s less harmful as the page is not used by the
kernel.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 23 +++++++++++++++++++++++
 include/linux/iommu-debug-pagealloc.h | 14 ++++++++++++++
 include/linux/mm.h                    |  5 +++++
 3 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-de=
bug-pagealloc.c
index 86ccb310a4a8..5353417e64f9 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -9,6 +9,7 @@
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kernel.h>
 #include <linux/page_ext.h>
+#include <linux/page_owner.h>
=20
 #include "iommu-priv.h"
=20
@@ -73,6 +74,28 @@ static size_t iommu_debug_page_size(struct iommu_domain =
*domain)
 	return 1UL << __ffs(domain->pgsize_bitmap);
 }
=20
+static bool iommu_debug_page_count(const struct page *page)
+{
+	unsigned int ref;
+	struct page_ext *page_ext =3D page_ext_get(page);
+	struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
+
+	ref =3D atomic_read(&d->ref);
+	page_ext_put(page_ext);
+	return ref !=3D 0;
+}
+
+void __iommu_debug_check_unmapped(const struct page *page, int numpages)
+{
+	while (numpages--) {
+		if (WARN_ON(iommu_debug_page_count(page))) {
+			pr_warn("iommu: Detected page leak!\n");
+			dump_page_owner(page);
+		}
+		page++;
+	}
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size=
_t size)
 {
 	size_t off, end;
diff --git a/include/linux/iommu-debug-pagealloc.h b/include/linux/iommu-de=
bug-pagealloc.h
index a439d6815ca1..46c3c1f70150 100644
--- a/include/linux/iommu-debug-pagealloc.h
+++ b/include/linux/iommu-debug-pagealloc.h
@@ -13,6 +13,20 @@ DECLARE_STATIC_KEY_FALSE(iommu_debug_initialized);
=20
 extern struct page_ext_operations page_iommu_debug_ops;
=20
+void __iommu_debug_check_unmapped(const struct page *page, int numpages);
+
+static inline void iommu_debug_check_unmapped(const struct page *page, int=
 numpages)
+{
+	if (static_branch_unlikely(&iommu_debug_initialized))
+		__iommu_debug_check_unmapped(page, numpages);
+}
+
+#else
+static inline void iommu_debug_check_unmapped(const struct page *page,
+					      int numpages)
+{
+}
+
 #endif /* CONFIG_IOMMU_DEBUG_PAGEALLOC */
=20
 #endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6f959d8ca4b4..32205d2a24b2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,6 +36,7 @@
 #include <linux/rcuwait.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/iommu-debug-pagealloc.h>
=20
 struct mempolicy;
 struct anon_vma;
@@ -4133,12 +4134,16 @@ extern void __kernel_map_pages(struct page *page, i=
nt numpages, int enable);
 #ifdef CONFIG_DEBUG_PAGEALLOC
 static inline void debug_pagealloc_map_pages(struct page *page, int numpag=
es)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 1);
 }
=20
 static inline void debug_pagealloc_unmap_pages(struct page *page, int nump=
ages)
 {
+	iommu_debug_check_unmapped(page, numpages);
+
 	if (debug_pagealloc_enabled_static())
 		__kernel_map_pages(page, numpages, 0);
 }
--=20
2.52.0.351.gbe84eed79e-goog


