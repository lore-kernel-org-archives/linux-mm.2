Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FA1D41C36
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3932A6B000C; Thu, 11 Dec 2025 07:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36AA86B000D; Thu, 11 Dec 2025 07:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FFF6B000E; Thu, 11 Dec 2025 07:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 180696B000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:59:41 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA60D55EFD
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:40 +0000 (UTC)
X-FDA: 84207196920.11.4ACF944
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 038C920010
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W7y/aAJ1";
	spf=pass (imf13.hostedemail.com: domain of 3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4W3L7Gncmv3IAVELs7REX8BF9wWmgyedLiyQWjFe18U=;
	b=h3WUPr1PIAHqlXdKFEvxFJm1vrolCvW04uHIjUpdifhcxGVnmtuQkPVd66ZKMT2cXn7sYv
	rgXYnBU1xFi1Z5kT4CoWOlqkMD6X8BqS2Nxq9QuJFHQT4GJIh+GKKkMIEe8z80FpJSbny4
	L3zFkYWEWjsatAyjiS1d+AgkntWpNeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457979; a=rsa-sha256;
	cv=none;
	b=E7pb9lHmbrpIf6k1HSN2DeEt/w5DsqAZYhPK/EmhGyn0SRBwfgqo/cl1fv4pmSwwcLwOkv
	+qjWlYVu3cCtHoqBkEXXd0XCf8P9YKOBmOzGaJLbB8C9NVaHpEuIASJBtocm0SRvazZTsy
	ZNR+DxPdELifZq3Uk4rt8AhtyzjIel4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="W7y/aAJ1";
	spf=pass (imf13.hostedemail.com: domain of 3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OMA6aQgKCPMnhjnoVaVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2f79759bso38809f8f.2
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765457977; x=1766062777; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4W3L7Gncmv3IAVELs7REX8BF9wWmgyedLiyQWjFe18U=;
        b=W7y/aAJ14JtohGQuZH8qSU4owGiMe30g+C5DtNdm9uXR4k+NmuK7GmXPlGoverdhWj
         rCJhYjLvMBpNndWVFvmdwxTFlCF/OMgfBndLGCP7T+cxOHkU5PrFCArd6X2S+sBtBqE7
         6yV1gTnPelopfztvbiSiJeGvttTYFxVIgvcweZeDSqJy8C2P1M7iNM/pRWrNDTpwDjqb
         Pb56y4dQyxI2fQ/GelwARUA+nQVXY0bdlj8wXfUhhNrsuVsdPO3hVUspehPCof5S/iNY
         9LOwJHrZ0Oq2bC/ezyS3I22zZBdQPd99+hSxepYqEh8rIhEWXkhB1/J9mvrjjWpwwmXk
         ilxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457977; x=1766062777;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4W3L7Gncmv3IAVELs7REX8BF9wWmgyedLiyQWjFe18U=;
        b=gdt7uAYCI1BnJeGKDvnfVqPgoVjvQc8WgnV4BzKYhN42yonf+v0HX1qWMy7duckxvm
         3XcTfhVtunHinTJt7ySpnTuj2bgxFeMEW3nqLNkQOL62ih5mfEPpHpxqNIsqOrQNOqqq
         5RoysT1boWFIQk+Gh3b1KhZRxfA9DvxRwVTWfy6+lT3bQA+EVtYMkO2dGAd9KDk3z2JN
         /0OUm4hK3z6c3a5l+xrF6ARRZbaLuXLp3pDh6ua9ySaywuDLE2DZg7EW+jibuPLxEFtZ
         hKPGp0DiBWLfq6cNEp7O2/z8BM2u30ILZLgmOZ1ghhvoL34uXA6sZqxNExU3ofw5lUjz
         82Sw==
X-Gm-Message-State: AOJu0YzuhYIBA9NEMv5yE7IZl+YaSMZ9uD0hBXuzCWLUh+JoP1lx/5iJ
	k+Wt3XkmNuAR2p2pUPv+NCmdFpcbMipQ9UNuXTEK+QGZ0Kj3e9oyB/r5bWyFHPYBdLMSD1a7TNU
	uVyhrsQ5r2qjlworsfxTZlsO4nRng4FlroNCy5nwhP/q6Lq1+vb0Eo4c2tgUB7259BjKNC4hnWS
	D8xB5y0wQRBGARneuHzeafyvwBhe/Ijm0mIFaerjcA6Q==
X-Google-Smtp-Source: AGHT+IGT9KfwHQf97dyte1BqZ2MoVgI51JA3s7OwveB26iyIwRb9n5NdLB5eerBZ7imEENFZ9FQDui0qZLsYyA==
X-Received: from wrsb10.prod.google.com ([2002:a5d:45ca:0:b0:42b:5422:4add])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c10:b0:42b:4061:241d with SMTP id ffacd0b85a97d-42fa3b137dbmr6252217f8f.59.1765457976998;
 Thu, 11 Dec 2025 04:59:36 -0800 (PST)
Date: Thu, 11 Dec 2025 12:59:27 +0000
In-Reply-To: <20251211125928.3258905-1-smostafa@google.com>
Mime-Version: 1.0
References: <20251211125928.3258905-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211125928.3258905-4-smostafa@google.com>
Subject: [PATCH v4 3/4] iommu: debug-pagealloc: Track IOMMU pages
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 038C920010
X-Stat-Signature: 8w74uznri8x79jsy78kd9q4kppsk1x9a
X-Rspam-User: 
X-HE-Tag: 1765457978-573025
X-HE-Meta: U2FsdGVkX19Ccc9wiCSnFEYgCd2Qh+vMUCU6E3P9qEKx6gxZd3rDwpq0UaaMopnTgHP3hsfIQb6VrF5uAySyINqbBYhAU6LOBn67iCzAmw3yncHcQ9t9vipL0UtwZCgXW0bTUaoMXIQ5OScLzVnKlLTsOXrtDukdx3DDS15+5FOoKmq14jyGDBxgqlisvrU3h1DJz6F/PNUcZtLFDFOtnB99Kv4xRkqljL65tvo3pQcgBauqn57LaDWT/DSrSpzM2dBFzqXrEjeejUi/v73kVLku0vuwsPm//i/o7Vl/QwxA/kKM5QuBV1y4JkzzN47owFJvOctRZ21YU2zPt+SAijL9V3R9lLA4j3MgLQBj1NUkhLAlOWjhJUOR2GLeTR1cUo5xs2jStI5PqWNyAz4w4K4JyeZPuthcPZ/UHrYRKR+EMv+SyRdUCNA0rvEa/KLu+heMc/OXq9jH51NYGrnzqvRLvuCKG9qhvb5hCo4rOmNiDim1HM+OEMUiZJHaFfHI9OjTnXf4nO4gCDaN6QCJ/eYMBlFDHgdU3yV2yMEsyrv/Rhyz/TwhXPkXX8PBO+abK0pWy8/FXhFf2dredIHPZ4gmr0zHcTueVYNWrxgG5C+0XACs3RbgmXW5WABIw6XaxIFEZYOEeRQUy2bzp38LmveL0rve8s93xerWi3H49MTXSdXI7V6Vd4D3v2ezxTQ7xRDGzOERBolujZ2cqUIno+IePIBJFxPdkc9vbWs6WSI2Sg7boWbY80LZN2wLT1r5PmJTjYajNIQsEHLMdKO5xMXfdxUAxj1UfAjPufCbQRwPjRNEm6K0oFBu47WJdJaQPE+rxZdenDDw4pH2JJOto6z27AaWexxTO1q+sZqnory5DEMUONEyL/RG9d3w/bZa2s5nsx3JEF3V4LXmqg5ynC1TXWsm8dCcMBQmgcnqoz2svlHqXE0YW3wFb0aXqGyZEvi2n6oRohNJX91hg3u
 lbduVhd8
 r5iNRBV1rQ5kflLXWex67k14Hq6/nnkebTvLjyPUhXtj/wqRyxeN7S6JBMrgLkFpPMkmAAFBfY4R2yQ08rrc5M/EtJCYYQvrV7j5VDj9OuTLl3nuvEpyiDXm3057Fp+Etz1goSA56A6Je6LxekcSPIqL0V6hJ1/cPU/xc91+l92IY7GYSr3l31cEtVpbmeTSXkPzygjEqtaptli4HIKpS8H3eN63nXD0/AV6Xmk3rqnySazrBno0NLeeZ6m4Gk97IAe2LWmfFPOB2vWv/0T/UlPTbgq/L10hcacIS+C7tAmU9Qm5cQ78Sn33OwAAC6LRNsdY9H0ZjRwciCLIhiHw090HubyC6TGCgwZWpQb/dolwkYB3C5nQD98ZbLhBiZE1yC8p59pJ76KDTzYpy8KzOBmj02LXkvs5RqfPVGbwH0E/XZ2eMgkt5cUsVToRnhCj3QpTjQFhXVZpI99o5YFav6rKLr1Ehl5p0yAgROnwbQUpQE62qVfYU1dfrcYxAmO631YjyEOBzI4HxDEVKwZ4O+Tio2Lcc34oerdvhuZCcX/YWEtbmT00RchuhAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using the new calls, use an atomic refcount to track how many times
a page is mapped in any of the IOMMUs.

For unmap we need to use iova_to_phys() to get the physical address
of the pages.

We use the smallest supported page size as the granularity of tracking
per domain.
This is important as it is possible to map pages and unmap them with
larger sizes (as in map_sg()) cases.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 91 +++++++++++++++++++++++++++
 1 file changed, 91 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 1d343421da98..4639cf9518e6 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -29,19 +29,110 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
+{
+	struct page *page = phys_to_page(phys);
+	struct page_ext *page_ext = page_ext_get(page);
+
+	return page_ext;
+}
+
+static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
+{
+	return page_ext_data(page_ext, &page_iommu_debug_ops);
+}
+
+static void iommu_debug_inc_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
+	page_ext_put(page_ext);
+}
+
+static void iommu_debug_dec_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
+	page_ext_put(page_ext);
+}
+
+/*
+ * IOMMU page size doesn't have tomatch the CPU page size. So, we use
+ * the smallest IOMMU page size to refcount the pages in the vmemmap.
+ * That is important as both map and unmap has to use the same page size
+ * to update the refcount to avoid double counting the same page.
+ * And as we can't know from iommu_unmap() what was the original page size
+ * used for map, we just use the minimum supported one for both.
+ */
+static size_t iommu_debug_page_size(struct iommu_domain *domain)
+{
+	return 1UL << __ffs(domain->pgsize_bitmap);
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
 {
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		if (!pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+		iommu_debug_inc_page(phys + off);
+	}
+}
+
+static void __iommu_debug_update_iova(struct iommu_domain *domain,
+				      unsigned long iova, size_t size, bool inc)
+{
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(check_add_overflow(iova, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
+
+		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
+			continue;
+
+		if (inc)
+			iommu_debug_inc_page(phys);
+		else
+			iommu_debug_dec_page(phys);
+	}
 }
 
 void __iommu_debug_unmap_begin(struct iommu_domain *domain,
 			       unsigned long iova, size_t size)
 {
+	__iommu_debug_update_iova(domain, iova, size, false);
 }
 
 void __iommu_debug_unmap_end(struct iommu_domain *domain,
 			     unsigned long iova, size_t size,
 			     size_t unmapped)
 {
+	if (unmapped == size)
+		return;
+
+	/*
+	 * If unmap failed, re-increment the refcount, but if it unmapped
+	 * larger size, decrement the extra part.
+	 */
+	if (unmapped < size)
+		__iommu_debug_update_iova(domain, iova + unmapped,
+					  size - unmapped, true);
+	else
+		__iommu_debug_update_iova(domain, iova + size,
+					  unmapped - size, false);
 }
 
 void iommu_debug_init(void)
-- 
2.52.0.223.gf5cc29aaa4-goog


