Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5DBBCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275D26B009D; Sat,  3 Oct 2026 17:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226736B009E; Sat,  3 Oct 2026 17:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C506B009F; Sat,  3 Oct 2026 17:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0A1C6B009D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 658C6C0A3C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:00 +0000 (UTC)
X-FDA: 85282590120.21.D5A3A1D
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id B150E1C0003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l+s7NJqv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3MHLBagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3MHLBagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N54zKWi7Lhs08q/THaKTXSODVv5TF25KadC1J/BT63c=;
	b=JVYqTBCj4fG3LoHOWUyFV9UMCJv+jaXJ4/p81c2KIMDXc02Ue4s+43Zetgr/c7Me369TS3
	DULpE/8B6/+BhPhJ0XS7yqqkObjzAcTPHDjYVZcRQAWD+U39U3xotnLaqE+19fPD2+gMSV
	u877N2CQc7xWKEWmuINysGkLeqU6xq8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l+s7NJqv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3MHLBagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3MHLBagYKCHcgmduujbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062578;
	b=YPm+ot3GPO9kxwwuM1RgIB1n6ODO43aD+Obe6gFyM7JjwMuAf/1N2MOI1zwpMAnXQamXzJ
	36DoLI/7nBSispOT2WmvpTY0caEeWeQ/aWl0gtpXzKYhvfzlfYIdTNOMvnRPZ5fYge3lXQ
	zPPMyZNgjq1eDd2cZQrPD2c/Sov205g=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c251c140b41so77580866b.3
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062577; x=1791667377; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N54zKWi7Lhs08q/THaKTXSODVv5TF25KadC1J/BT63c=;
        b=l+s7NJqvwo+kRnaVFSXZMQ8Jt6WBoQcoCWrnaXhAcQrWfHYf9pKqQE8FJjhdtFTYo0
         UKhcv4XW7/9kJ2VX+OFDlJHPboR7ADadB2WpIcgy0iLkYCLB+izofZYzpkzWsWWcvxoM
         eyHPSh+16bVaCqwVgd9mN99zLesli26A5Zj6IItf1KuTqdVEuNW8gdnqb074LPBE5KBs
         kh1DkzIS2S7ASj+1Cbz7BZy9wfzNIcZJyIA6KS2M834oeOZqMZkqORA659y0cdbyrvH9
         DjW6hNfmd2JktWEGvqTC4eeDAZvvCRlzsCTVboN2O0ZfPMsb/MZ++qhlcQDoA5hkAUj8
         N/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062577; x=1791667377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N54zKWi7Lhs08q/THaKTXSODVv5TF25KadC1J/BT63c=;
        b=ury3GuMmrX1NWLbuWps5pyeNp00xuvFo8zaJU20OkBRhHVu8gJW/B4ZDlDSLCwx7rP
         lo+WStiNFTD5h0m8aAy3iGOxUUw3dQq5nMFtdO3UVdlXIt5XW6bW3cLEXot0/+UChi8L
         Zf0TS66BrI6Emkga+V7vU+X3HFUwgsLv7ByemftqtFmcNsQnyksBnGyMcbes4rvGAJ8E
         CO230ov2pT45ibc983AKxAxIQQaohW1V8xZYQdwEERh9HNBWyUHhdqL3nmkc3Q+pugWD
         dznDGuZRRGNmEN/CMpiff+s9tB9ltlj0fjhbU5FJIHaKS9OwcpeycnVLTLu9xL1HmM4g
         7oWQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJlmx24FLQJGrVPx8874QQDhKx6d530sW7UwJD6CiT40KyyZYXhzcCn7XiMOuDXfp+rV7PR9L4xg==@kvack.org
X-Gm-Message-State: AFuF++mafKFODYnBylFGoxhDES2qjhQjJiOvFmyoEx6TFc+CqMlr9m5D
	gaxEnDyWj5xrLHnc4IGtEx5QSW6z2NvQAlw442eJbZdH1tNchNMDoy9Ni8vX39Da46TEMHEAnqI
	IXNb8+Q==
X-Received: from ejze9.prod.google.com ([2002:a17:906:c009:b0:c2e:7b39:59da])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:720f:b0:c29:4490:50d6
 with SMTP id a640c23a62f3a-c2e4b229d3bmr529969366b.47.1791062576831; Sat, 03
 Oct 2026 14:22:56 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:27 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-9-lrizzo@google.com>
Subject: [RFC: DMA_PMD 08/22] iommu/dma: use per-domain IOVA window to map
 DMA_PMD memory
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: q33keomtqbw9utznuqtozj833rwuw4gp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B150E1C0003
X-HE-Tag: 1791062578-686803
X-HE-Meta: U2FsdGVkX19e6FcvWYdoCVsy/kqa4idOiIAN4+5Qfi9l+P2krpoHaXUqiJ2KiN1jnT4j/1Z4DDrl75TZWqKpXtKGC3M62HTJoUK+9z5IEwKn5Xo0S90fbVK2V37wN8Kw+FFc9KpnliMnuDRe7GdSoV2xF5bTDhQrkUJJrviRxksGPN6cbIgD4WIIGtyONDIB8Bsfm4aiwXEu4FXWmgj1T4RbRmpuWuxs83fbLflr1dosNM0P9JeopZPpH85/ytjEbyK+Qdj4ddryvMKXFUzg1msOV5cz6PSZuQVSEPdjWewZ9ZBR928tuXkKfzYV296sLehr2CWOZAlcQZ51WoAJSlWV3O5xDz/eCFHmeeQIzQc3y7zu+KJDH6aIpqtMtedts5YP9B2FSVEozjqGRDB8WprDT3wju5rz47Z/6nf+1q70YsX7E93CblJ3BaST/LYmEQQmvql0YNpbQP1/DMBtV7l9zZlNcaOc69lksu+wNVG8FVjeeVS08Xcvw933L7CmyKXxe1UjNmDTz1RzDiEnCbWYtOfeYpkSD1rTOG6+NoA6sYCwegW/T1/IPGcB+OJBzQJtpP+g5iA6YbgXsZKdDGv8dR14HD1fOPByXk16fd9HBFJL3jD+fNIKG3ZuRF9bHwbHw5klvLrZCoXKxcGhAbYHkGkR0oo5aqIqs9JmqtEPtz70lWomasnrvOw7fPwLyjtzwEAy+X+5K9EmnB4+jwtTHQXhnvLtf2Ai6QiVZIpnMMSbfcBNF0u1/HQU46MpPzKTHnxsQt2cb/nBeJ/x6p5/EiTvjCXjRN3ojkb1dSHCN4OS57l//ltCICfvAKeBV7U9tPXqOWESJUyhqRAWgVIGqV2PcctIp2TRXLcUKwdsbOuHB76qR/fbXMjVzD6Af7UHs43v0OQO0iuDjC/CEnswH87LlD5jbJ0OmT9uuQQ0/BWrXWuckGOE2/dylTRUppja6AYPIRW1fsFfIN0
 yJP2R7S4
 CYM4y520RI3zGV7oB03E1eCIb6q2wHuvQTyQRIRFup1dME3HmOJwfRNhU8KglBOgsKJ6c/cbk2ueR2K2lp/maYTBhajGmP7bt97MHQT67zl4fzgfJwpuu4CnnIhCISv9yROfHgwTgWwIKH8AGyemPT8LzzPJ1hPnWb2rJIVXtTql7poskNEavvDKjRgcMBJYfPQSModSv4SAtQJHrdpmUyy1Qmvoe/fXGFGO/M80zWJ42Gx583W85L/CzVkyctkLCNa+aCyyR2Lc9tOD1mv5kSU7GzLoMd1oLU8NPZx35SHKiVsr8a4IaLb8u4IIZngfFNqfFShfGYurA53Os9hWa82W79U+uWowW6FzyVsCV7MbiGWDw6VTrQ5l5CbR/0oiubp9JlfdUQisAYoxucrp5s0ixlPQ74jhTV3Ojr518Jp/m2kiCCUO6kCmGB1zbjcoobmsKgu5ifcQ99OkO5CdtetjCM4nmoWEEVjJae3ZnhAln/yUjjRISDH5Vv7bZ4NVBX+cK7sKeVQKOlEQuU12DyskaJPlUBQMZnZvHeXaMDQV9Sx9iyoNWFrhxiJFUUi6hWneJ9EytjWlaN5dG0jT8YKR5Ek3npafm+rFj9vwzaChI5q7nuZKYDWX1HLMaDaGaVxUpSMjQSp4zdVIVE7kuzFTTc19YLr7XlLhh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Map each DMA_PMD page at win->base + phys inside the domain's reserved
IOVA window and track per-domain leaf PDE residency in
p2m->domains_mapped:

- dma_pmd_window_assign() assigns a dense domain index in
  dma_pmd_domains[] and allocates the per-domain IOVA window via
  dma_pmd_dma_window_alloc() on first use.
- dma_pmd_dma_window_alloc() reserves a PMD_SIZE-aligned range via
  alloc_iova() from the domain's iova_domain so no ordinary IOVA can
  land inside it, allowing unmap to identify pooled IOVAs by range check.
- dma_pmd_dma_map_phys() returns win->base + phys in O(1) when the
  domain's bit is set in p2m->domains_mapped, installing the PDE_ORDER leaf
  PTE on the first map in a domain.
- iommu_dma_map_phys() and iommu_dma_unmap_phys() route DMA_PMD
  buffers through the per-domain window, making dma_unmap_*() an O(1)
  range check with no page-table walk or IOTLB flush.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Kconfig        |   1 +
 drivers/iommu/dma-iommu.c    |  27 +++-
 drivers/iommu/dma-pmd-map.c  | 275 +++++++++++++++++++++++++++++++++++
 drivers/iommu/dma-pmd-priv.h |  33 +++++
 drivers/iommu/iommu.c        |   2 +-
 5 files changed, 336 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 1bb347fd9da4a..7cb5b036e0f3b 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -164,6 +164,7 @@ config DMA_PMD
 	depends on IOMMU_DMA
 	depends on X86_64 || (ARM64 && ARM64_4K_PAGES)
 	depends on !PREEMPT_RT
+	select NEED_SG_DMA_FLAGS
 	default y
 	help
 	  Hand out DMA buffers carved out of PMD_SIZE physically contiguous
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ee14175b79bc2..6d33e245530ec 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1286,6 +1286,14 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		arch_sync_dma_flush();
 	}
 
+	if (dma_is_pmd_phys(phys)) {
+		iova = dma_pmd_dma_map_phys(dev, domain,
+					    &domain->iova_cookie->win_dma_pmd,
+					    phys, size, prot, dma_mask);
+		if (likely(iova != DMA_MAPPING_ERROR))
+			return iova;
+	}
+
 	iova = __iommu_dma_map(dev, phys, size, prot, dma_mask);
 	if (iova == DMA_MAPPING_ERROR &&
 	    !(attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT)))
@@ -1296,14 +1304,19 @@ dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 void iommu_dma_unmap_phys(struct device *dev, dma_addr_t dma_handle,
 		size_t size, enum dma_data_direction dir, unsigned long attrs)
 {
+	struct iommu_domain *domain = iommu_get_dma_domain(dev);
 	phys_addr_t phys;
 
+	/* DMA_PMD mapped buffer: nothing to unmap or release. */
+	if (dma_pmd_window_owns(&domain->iova_cookie->win_dma_pmd, dma_handle))
+		return;
+
 	if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT)) {
 		__iommu_dma_unmap(dev, dma_handle, size);
 		return;
 	}
 
-	phys = iommu_iova_to_phys(iommu_get_dma_domain(dev), dma_handle);
+	phys = iommu_iova_to_phys(domain, dma_handle);
 	if (WARN_ON(!phys))
 		return;
 
@@ -1499,6 +1512,18 @@ int iommu_dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 			 */
 			break;
 		case PCI_P2PDMA_MAP_NONE:
+			if (dma_is_pmd_phys(sg_phys(s))) {
+				iova = dma_pmd_dma_map_phys(dev, domain,
+							    &cookie->win_dma_pmd,
+							    sg_phys(s), s_length,
+							    prot, dma_get_mask(dev));
+				if (likely(iova != DMA_MAPPING_ERROR)) {
+					s->dma_address = iova;
+					sg_dma_len(s) = s_length;
+					sg_dma_mark_bus_address(s);
+					continue;
+				}
+			}
 			break;
 		case PCI_P2PDMA_MAP_BUS_ADDR:
 			/*
diff --git a/drivers/iommu/dma-pmd-map.c b/drivers/iommu/dma-pmd-map.c
index cffa94a7c7c84..565e10dd1a2e8 100644
--- a/drivers/iommu/dma-pmd-map.c
+++ b/drivers/iommu/dma-pmd-map.c
@@ -13,6 +13,8 @@
 #include <linux/dma-pmd.h>
 #include <linux/export.h>
 #include <linux/iommu.h>
+#include <linux/iova.h>
+#include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/srcu.h>
@@ -218,3 +220,276 @@ void dma_pmd_domain_release(struct iommu_domain *domain)
 		pr_debug("dma_pmd: released %u PMD page mappings for domain %p (index %d)\n",
 			 dropped, domain, idx);
 }
+
+/**
+ * dma_pmd_dma_window_alloc - Allocate an IOVA window for DMA_PMD mappings
+ * @dev: Device whose addressing limits the window must respect
+ * @domain: Domain to take the window from
+ * @size: Window size in bytes
+ *
+ * Allocates a contiguous IOVA range out of @domain's iova_domain on first use,
+ * aligned to PMD_SIZE matching the mapping. Callers on the map path still
+ * check each device's own dma_mask/bus_dma_limit against the resulting IOVA and
+ * fall back to per-buffer mapping if a narrower device shares @domain.
+ *
+ * Return: base IOVA, or 0 if no range that large is available.
+ */
+static dma_addr_t dma_pmd_dma_window_alloc(struct device *dev,
+					   struct iommu_domain *domain, u64 *sizep)
+{
+	u64 limit = min_not_zero(dma_get_mask(dev), dev->bus_dma_limit);
+	struct iova_domain *iovad = dma_pmd_dma_iovad(domain);
+	u64 min_size = ALIGN(PFN_PHYS(max_pfn), PMD_SIZE);
+	unsigned long shift, iova_len;
+	struct iova *new_iova;
+
+	if (!iovad)
+		return 0;
+
+	if (domain->geometry.force_aperture)
+		limit = min_t(u64, limit, domain->geometry.aperture_end);
+
+	if (*sizep > limit / 2 && limit / 2 >= min_size)
+		*sizep = ALIGN_DOWN(limit / 2, PMD_SIZE);
+
+	/* Ignore devices with too many constraints. */
+	if (limit <= DMA_BIT_MASK(32) || *sizep > limit - PMD_SIZE)
+		return 0;
+
+	shift = iova_shift(iovad);
+	iova_len = (*sizep + PMD_SIZE) >> shift;
+
+	/*
+	 * Note: dev->iommu->pci_32bit_workaround is intentionally not consulted
+	 * here. It is an advisory preference (enabled by default on all PCI
+	 * devices).
+	 */
+	new_iova = alloc_iova(iovad, iova_len, limit >> shift, false);
+	if (!new_iova)
+		return 0;
+
+	return ALIGN((dma_addr_t)new_iova->pfn_lo << shift, PMD_SIZE);
+}
+
+/**
+ * dma_pmd_window_assign - Give @domain an IOVA window and a domain index
+ * @dev: Device whose addressing limits the window must respect
+ * @domain: Domain to set up
+ * @win: @domain's window, from its DMA cookie
+ *
+ * Called the first time anything tries to pool through @domain. Failure is
+ * recorded in @win->domain_idx rather than retried: the allocation is a
+ * multi-terabyte search of the IOVA tree, and a domain that has no room for it
+ * once will not have room on the next buffer either. The caller tests that
+ * record without the lock, so the reason has to survive in the sentinel.
+ *
+ * A domain that cannot install a PMD leaf is declined. The whole benefit
+ * is the single large PTE; without it a 2M page would cost 512 4KB PTEs, which
+ * is worse than not pooling.
+ *
+ * Locking: Acquires @dma_pmd_domains_lock (irqsave). Callable from the DMA
+ *          map path, so it never sleeps.
+ *
+ * Return: 0 if @win is usable on return, negative otherwise.
+ */
+int dma_pmd_window_assign(struct device *dev, struct iommu_domain *domain,
+			  struct dma_pmd_window *win)
+{
+	u64 size = ALIGN(PFN_PHYS(dma_pmd_top_pfn()), PMD_SIZE);
+	unsigned long flags;
+	int idx, ret = 0;
+	dma_addr_t base;
+
+	if (!dev_is_dma_coherent(dev))
+		return -EOPNOTSUPP;
+
+	if (min_not_zero(dma_get_mask(dev), dev->bus_dma_limit) <= DMA_BIT_MASK(32))
+		return -ENOSPC;
+
+	spin_lock_irqsave(&dma_pmd_domains_lock, flags);
+
+	if (win->size)				/* another CPU got here first */
+		goto out;
+
+	/* Declined earlier; only DMA_PMD_IDX_NONE means "not tried yet". */
+	if (win->domain_idx != DMA_PMD_IDX_NONE) {
+		ret = win->domain_idx == DMA_PMD_IDX_NOHUGE ? -EOPNOTSUPP : -ENOSPC;
+		goto out;
+	}
+
+	if (!(domain->pgsize_bitmap & PMD_SIZE)) {
+		dev_warn_ratelimited(dev,
+				     "dma_pmd: domain lacks a %luMB page size, not pooling\n",
+				     (unsigned long)(PMD_SIZE >> 20));
+		ret = -EOPNOTSUPP;
+		goto decline_nohuge;
+	}
+
+	for (idx = 0; idx < DMA_PMD_MAX_DOMAINS; idx++) {
+		if (!dma_pmd_domains[idx].domain && !dma_pmd_domains[idx].draining)
+			break;
+	}
+	if (idx == DMA_PMD_MAX_DOMAINS) {
+		pr_warn_ratelimited("dma_pmd: all %d domain indices in use, not pooling for domain %p\n",
+				    DMA_PMD_MAX_DOMAINS, domain);
+		ret = -ENOSPC;
+		goto decline;
+	}
+
+	base = dma_pmd_dma_window_alloc(dev, domain, &size);
+	if (!base) {
+		dev_warn_ratelimited(dev,
+				     "dma_pmd: no free %llu GB IOVA range for a DMA_PMD window\n",
+				     size >> 30);
+		ret = -ENOSPC;
+		goto decline;
+	}
+
+	dma_pmd_domains[idx].domain = domain;
+	dma_pmd_domains[idx].base = base;
+	win->base = base;
+	win->domain_idx = idx + DMA_PMD_IDX_FIRST;
+	/*
+	 * Publish .base and .domain_idx before .size. A non-zero .size is what
+	 * tells both the map and the unmap side that the other two are valid;
+	 * see dma_pmd_window_owns().
+	 */
+	smp_store_release(&win->size, size);
+
+	dev_info(dev, "dma_pmd: domain %p index %d window %pad + %llu GB\n",
+		 domain, idx, &base, size >> 30);
+	goto out;
+
+decline_nohuge:
+	win->domain_idx = DMA_PMD_IDX_NOHUGE;
+	goto out;
+
+decline:
+	win->domain_idx = DMA_PMD_IDX_NOSPACE;
+out:
+	spin_unlock_irqrestore(&dma_pmd_domains_lock, flags);
+	return ret;
+}
+
+/**
+ * dma_pmd_dma_map_phys - Derive the IOVA of a pool address, mapping if needed
+ * @dev: Device performing DMA
+ * @domain: @dev's DMA domain
+ * @win: @domain's DMA_PMD window, from its DMA cookie
+ * @phys: Physical address within a DMA_PMD page
+ * @size: Mapping size requested
+ * @prot: IOMMU protection flags requested by the caller
+ * @dma_mask: Device DMA mask
+ *
+ * The IOVA is not allocated or cached: it is @win->base plus the PMD page's
+ * physical address, so every block of every PMD page has a fixed
+ * address in this domain that both this function and the unmap path can
+ * compute. All the PMD page has to remember is whether the PMD leaf PTE has
+ * actually been installed here, which is one bit in @meta->domains_mapped.
+ *
+ * The PMD page is mapped with IOMMU_CACHE | IOMMU_READ | IOMMU_WRITE so that
+ * blocks can be used in any DMA direction. Callers requesting additional
+ * protection flags in @prot fall back to per-buffer mapping.
+ *
+ * Cost:
+ *   - Fast path: O(1) lockless - one bit test and an add. No IOVA tree, no
+ *     page table, and no metadata load beyond the bitmask word.
+ *   - First use of a PMD page in a domain: one iommu_map() of the whole PMD
+ *     page, once, under @meta->map_lock.
+ * Locking: Fast path is lockless. Slow path acquires @meta->map_lock
+ *          (irqsave), and @dma_pmd_domains_lock on the very first PMD page
+ *          mapped through @domain.
+ * Frequency: Very high (called on every dma_map_page / dma_map_single for
+ *            buffers allocated from an dma_pmd_pool).
+ *
+ * Return: Mapped IOVA, or DMA_MAPPING_ERROR on failure.
+ */
+dma_addr_t dma_pmd_dma_map_phys(struct device *dev, struct iommu_domain *domain,
+				struct dma_pmd_window *win, phys_addr_t phys,
+				size_t size, int prot, u64 dma_mask)
+{
+	int block_prot = IOMMU_CACHE | IOMMU_READ | IOMMU_WRITE;
+	unsigned long pfn = phys >> PAGE_SHIFT;
+	struct dma_pmd_meta *meta;
+	unsigned int domain_idx;
+	unsigned long flags;
+	dma_addr_t iova;
+	u64 win_size;
+	int ret;
+
+	if (unlikely((prot & ~block_prot) || !dev_is_dma_coherent(dev) ||
+		     !dma_is_pmd_page(pfn) || (phys & (PMD_SIZE - 1)) + size > PMD_SIZE))
+		return DMA_MAPPING_ERROR;
+
+	meta = dma_pmd_meta_of_pfn(pfn);
+
+	/* Acquire pairs with the .size release in dma_pmd_window_assign(). */
+	win_size = smp_load_acquire(&win->size);
+
+	if (unlikely(!win_size)) {
+		u16 win_idx = READ_ONCE(win->domain_idx);
+
+		/*
+		 * A declined domain stays declined, so the answer is cached in
+		 * @domain_idx and read without @dma_pmd_domains_lock. Otherwise
+		 * every map through such a domain would queue on a global
+		 * spinlock only to be told no.
+		 */
+		if (unlikely(win_idx == DMA_PMD_IDX_NOHUGE))
+			ret = -EOPNOTSUPP;
+		else if (unlikely(win_idx == DMA_PMD_IDX_NOSPACE))
+			ret = -ENOSPC;
+		else
+			ret = dma_pmd_window_assign(dev, domain, win);
+
+		if (ret)
+			return DMA_MAPPING_ERROR;
+		win_size = READ_ONCE(win->size);
+	}
+
+	iova = dma_pmd_window_iova(win, phys);
+
+	/*
+	 * The window was sized against the first device to pool through this
+	 * domain (and may have been clamped to the domain aperture). Mirror
+	 * __iommu_dma_map() and bound by the window size, bus limit, and
+	 * device mask.
+	 */
+	if (unlikely(iova - win->base + size > win_size ||
+		     iova + size - 1 > min_not_zero(dma_mask, dev->bus_dma_limit)))
+		return DMA_MAPPING_ERROR;
+
+	domain_idx = win->domain_idx - DMA_PMD_IDX_FIRST;
+	if (likely(test_bit(domain_idx, &meta->domains_mapped)))
+		return iova;
+
+	/* First use of this PMD page in this domain: install the leaf PTE. */
+	spin_lock_irqsave(&meta->map_lock, flags);
+	if (test_bit(domain_idx, &meta->domains_mapped)) {
+		/* raced, someone else mapped */
+		ret = 0;
+	} else {
+		ret = iommu_map(domain,
+				dma_pmd_window_iova(win, dma_pmd_meta_to_phys(meta)),
+				dma_pmd_meta_to_phys(meta), PMD_SIZE,
+				block_prot, GFP_ATOMIC);
+		if (!ret) {
+			/*
+			 * A lockless reader that sees this bit skips the
+			 * iommu_map() above and hands the IOVA straight to the
+			 * device, so the leaf PTE has to be visible first.
+			 * set_bit() carries no ordering of its own on a weakly
+			 * ordered machine; the barrier is a no-op on x86,
+			 * where the LOCK prefix already provides it.
+			 */
+			smp_mb__before_atomic();
+			set_bit(domain_idx, &meta->domains_mapped);
+		}
+	}
+	spin_unlock_irqrestore(&meta->map_lock, flags);
+
+	if (unlikely(ret))
+		return DMA_MAPPING_ERROR;
+
+	return iova;
+}
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 8477a8edfac63..355f865f44057 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -2,6 +2,7 @@
 #ifndef _DRIVERS_IOMMU_DMA_PMD_PRIV_H
 #define _DRIVERS_IOMMU_DMA_PMD_PRIV_H
 
+#include <linux/dma-mapping.h>
 #include <linux/dma-pmd.h>
 #include <linux/kref.h>
 #include <linux/list.h>
@@ -10,6 +11,7 @@
 #include <linux/srcu.h>
 #include <linux/types.h>
 
+struct device;
 struct iommu_domain;
 
 /**
@@ -220,6 +222,22 @@ static inline struct dma_pmd_meta *dma_pmd_meta_base(void)
 	return smp_load_acquire(&dma_pmd_meta_array);
 }
 
+/*
+ * Highest PFN covered by the allocated @dma_pmd_meta_array reservation.
+ * Every domain's IOVA window is sized to match this bound.
+ */
+static inline unsigned long dma_pmd_top_pfn(void)
+{
+	return dma_pmd_meta_nframes << PMD_ORDER;
+}
+
+/* IOVA of @phys in @win. Only valid once the PMD page's PTE is installed. */
+static inline dma_addr_t dma_pmd_window_iova(const struct dma_pmd_window *win,
+					     phys_addr_t phys)
+{
+	return win->base + phys;
+}
+
 int dma_pmd_meta_init(void);
 bool dma_pmd_meta_ensure_pfn(unsigned long pfn, bool can_block);
 struct dma_pmd_meta *dma_pmd_meta_of_pfn(unsigned long pfn);
@@ -230,6 +248,8 @@ phys_addr_t dma_pmd_meta_to_phys(const struct dma_pmd_meta *m);
 unsigned int dma_pmd_pools_forget_domain(int idx);
 void dma_pmd_unmap_all(struct dma_pmd_meta *meta);
 unsigned int dma_pmd_forget_domain(struct dma_pmd_meta *meta, int idx);
+int dma_pmd_window_assign(struct device *dev, struct iommu_domain *domain,
+			  struct dma_pmd_window *win);
 
 static inline bool dma_is_pmd_phys(phys_addr_t phys)
 {
@@ -255,6 +275,10 @@ static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_add
 	return size && dma - win->base < size;
 }
 
+dma_addr_t dma_pmd_dma_map_phys(struct device *dev, struct iommu_domain *domain,
+				struct dma_pmd_window *win, phys_addr_t phys,
+				size_t size, int prot, u64 dma_mask);
+
 void dma_pmd_domain_release(struct iommu_domain *domain);
 
 #else /* !CONFIG_DMA_PMD */
@@ -269,6 +293,15 @@ static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_add
 	return false;
 }
 
+static inline dma_addr_t dma_pmd_dma_map_phys(struct device *dev,
+					      struct iommu_domain *domain,
+					      struct dma_pmd_window *win,
+					      phys_addr_t phys, size_t size,
+					      int prot, u64 dma_mask)
+{
+	return DMA_MAPPING_ERROR;
+}
+
 static inline void dma_pmd_domain_release(struct iommu_domain *domain)
 {
 }
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index cd1bca7ede9af..d918d1294eb0d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2867,7 +2867,7 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
 	while (i <= nents) {
 		phys_addr_t s_phys = sg_phys(sg);
 
-		if (len && s_phys != start + len) {
+		if (len && (sg_dma_is_bus_address(sg) || s_phys != start + len)) {
 			ret = iommu_map_nosync(domain, iova + mapped, start,
 					len, prot, gfp);
 			if (ret)
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


