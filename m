Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90CC3C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 20:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40326B007B; Tue, 29 Jul 2025 16:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1586B0089; Tue, 29 Jul 2025 16:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFF96B008A; Tue, 29 Jul 2025 16:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC016B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:54:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF8AD1D9348
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:54:44 +0000 (UTC)
X-FDA: 83718506088.25.D30C514
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97B40140002
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:54:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=ShHf+ekc;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf26.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753822483; a=rsa-sha256;
	cv=none;
	b=F+KWUTE/V8wZosEDkbNLuCg6IMVKEPh4yLpsQ6KmSGRh8AtsMczvjkoRiBOEFXkTQRPYGH
	O9sFO5gxRjWWTUfFtQLmhyMHO7Z6YJil7bzrfw53Sa32qZuUc0qw5ZbM57+Y8j/zNId2kH
	DxaEESmgV1dgpJbTdFnKGI72lauf1g4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=deltatee.com header.s=20200525 header.b=ShHf+ekc;
	dmarc=pass (policy=quarantine) header.from=deltatee.com;
	spf=pass (imf26.hostedemail.com: domain of logang@deltatee.com designates 204.191.154.188 as permitted sender) smtp.mailfrom=logang@deltatee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753822483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNh1yThG7TvPWKpLvY5OC7tLgkYClB2Gxhne1Vp0HTw=;
	b=BCIlw4RQQ0E7DKKkiA96tZeBnAe13frb6ihWHU8LxuSKGb+rj4izHoXxcssDgHkXrYlcjy
	WdHJaIF0NrNUOEtNMXV3q8N6+L6HfhmFtXMMNq8pMTlBUnnetBNxPy+euZK8dwRKu3TQ03
	bJuyAirGJkK2fSY2I24Natn/Bbyn0VQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:References:Cc:To:From:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=NNh1yThG7TvPWKpLvY5OC7tLgkYClB2Gxhne1Vp0HTw=; b=ShHf+ekceHcINuu8D0K30j3qUO
	L9xqTvYP9Zh8bk//ApqFzejUahb6bACPQNlM5iV2A1IRyuDGPfzEQSqmXhx/bf9dL9cTxYDN4p1dO
	50kSae/x3VuYLc4DSVcE7A32AkN9a8vnc7cWq76JX7ZFC29ItBPasnUx2PUIOypT5NvQJIqqQpb+A
	hKS/mcRzJw9NmBzbYunfCu5/y6lbCyBnLxF5fuWkORd2HDquxo3R8hxzx9e/Jxu7yv1HNrpU9R5TP
	HOqWZkyevVjQIYp4dmyfA+4gv+aeKblKfLpxMhglWKNR2gAcipr0qNsWYlfNjGHBFoQ3Nad1bjaCo
	0fckrAUw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1ugrL8-009DTi-1i;
	Tue, 29 Jul 2025 14:54:27 -0600
Message-ID: <f332e2b9-151f-49ca-ac0c-8c9494c38027@deltatee.com>
Date: Tue, 29 Jul 2025 14:54:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Logan Gunthorpe <logang@deltatee.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Alex Williamson <alex.williamson@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
 linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Vivek Kasireddy <vivek.kasireddy@intel.com>, Will Deacon <will@kernel.org>
References: <cover.1753274085.git.leonro@nvidia.com>
 <82e62eb59afcd39b68ae143573d5ed113a92344e.1753274085.git.leonro@nvidia.com>
 <20250724080313.GA31887@lst.de> <20250724081321.GT402218@unreal>
 <b32ae619-6c4a-46fc-a368-6ad4e245d581@deltatee.com>
 <20250727190514.GG7551@nvidia.com>
 <d69e0d74-285e-4cde-a2e4-a803accfa9e1@deltatee.com>
 <20250728164136.GD402218@unreal>
 <d3c8c573-f201-4450-9400-cc3ccafd2c04@deltatee.com>
 <20250728231107.GE36037@nvidia.com>
Content-Language: en-CA
In-Reply-To: <20250728231107.GE36037@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: jgg@nvidia.com, leon@kernel.org, hch@lst.de, alex.williamson@redhat.com, akpm@linux-foundation.org, bhelgaas@google.com, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, axboe@kernel.dk, jglisse@redhat.com, joro@8bytes.org, kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, m.szyprowski@samsung.com, robin.murphy@arm.com, sumit.semwal@linaro.org, vivek.kasireddy@intel.com, will@kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 05/10] PCI/P2PDMA: Export pci_p2pdma_map_type() function
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 97B40140002
X-Stat-Signature: p1cofge3whoi5p35gqj89tpt7tkcn1aw
X-Rspam-User: 
X-HE-Tag: 1753822482-655383
X-HE-Meta: U2FsdGVkX18KMWK0zzmpp1bQvyJQkpjHu4Im+wTkJNcStwCem13rCaT/srCr4vrNB5JuJFw18EdDJoIUDuwROC55xbsS/qb9twB7aEwbQc9SNScb1Sny7KyFVv7WUMW8YAm4jXzg+gkHq5OmmsgulwVGJ1814FzBWT04ryEMARSUOohbVsWRxuCq1f/pUF4P3YXKSkyYJyT4e9U+gYCkfiyJCdx1RJ+5sBCo1SPCXOeZ3RxANXgrsYgao5JNqOEC8uXzYLbq8d31vMZHYL+/DsluL+/zlQ6fBgziuHbvNJEZX3yhrP8LD2Ziekyxr6tEg5ZmhQ5XL9vmTPmfi0Gqdj1TvHyFaUpRt1lEhU5KND/LYatoSVmMf9sP8ehsiy2/hDoUjRz5+0mKdJzidVOJ94x3AsYfHPQvd4JwXjm9fanwZRVZexceXJ9xBMCoZIxwKir4pffGKlGLbNqABG1BN+YJHo8F4bBEMq7yGv/qk3yIaIjrXDVcOYAvbgiyaJdLNdGRNM2Ys/85WKwn+UAF66jo/aXcqYup1oqcXG0+QCGCl29r5yNuLgNNG35ZcxwekLkjEWfCLDlg3ZOoMIWHo32NMklSvcJvdm7VlpmE41qV1/K0uROgYk+kMWTtE8ehE/ZvYsBQKqb563fqpRE0ELlpQMZgjqS2nY/sr2dav0wSG1JEvsaJWF9wD63lyhCJGXi0XAhh2IYBfxTd6lh7rtRPTKgPml8xV5OoOBxIkWjtqYgJASSnSyQWo37DF5BN7Uy4ihplIbExAjR2yKsjO8DE1/pKAMcZX2A/g4PqJWs0awAiMo1xgEkqWoKiM+bmzDxOaHiwUNmNCQEqKq4YxDL10OMEL9ckfDOPBHCuOy6KuDKl7K3oyT0h6ivsh9ZbjgAwNlL1Wx41axQG7OddvXKWqo4nmIkDlxT/3uQSE6t0EFl6M7ZAoQu1opPsQEt7UCOOJazPgieY0jmUkPb
 IeH49JOm
 /+p5GFthPsWV+3lpt3fz8ZCFJNPka13+uYvbebpzr8sJhN1KTeUWsxpbs3FMbJdWRomXd0AuTgzuwHXLANvZSoH/0/a74VwSdtucbjlkOCK4Az778ekoYIJ3/Q2fhzPF0Qs7s5bZRkK6vQRKUy0x0h7b+dmq2p+gFkMP0qu9czxhkKaq7Ydd3fTs9uwMz09INCwTq2jdVnyOTXsEF58udSGyvc7Ep71jfKAUVbXGfrouIqPoMTGmXbfPonqMnnjaNqm0cIT0vnGZrEFLGS1tkScM3w6lTY8vkjH+1l6DWCNwPpw3sg8XpmRzaA3mFC0Pm68Bydz08qaTSFfz3+oPx8PPVdwlTVsjdY6v1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025-07-28 17:11, Jason Gunthorpe wrote:
>> If the dma mapping for P2P memory doesn't need to create an iommu
>> mapping then that's fine. But it should be the dma-iommu layer to decide
>> that.
> 
> So above, we can't use dma-iommu.c, it might not be compiled into the
> kernel but the dma_map_phys() path is still valid.

This is an easily solved problem. I did a very rough sketch below to say
it's really not that hard. (Note it has some rough edges that could be
cleaned up and I based it off Leon's git repo which appears to not be
the same as what was posted, but the core concept is sound).

Logan


diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 1853a969e197..da1a6003620a 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1806,6 +1806,22 @@ bool dma_iova_try_alloc(struct device *dev,
struct dma_iova_state *state,
 }
 EXPORT_SYMBOL_GPL(dma_iova_try_alloc);
 +void dma_iova_try_alloc_p2p(struct p2pdma_provider *provider, struct
device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t size)
+{
+	switch (pci_p2pdma_map_type(provider, dev)) {
+	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
+		dma_iova_try_alloc(dev, state, phys, size);
+		return;
+	case PCI_P2PDMA_MAP_BUS_ADDR:
+		state->bus_addr = true;
+		return;
+	default:
+		return;
+	}
+}
+EXPORT_SYMBOL_GPL(dma_iova_try_alloc_p2p);
+
 /**
  * dma_iova_free - Free an IOVA space
  * @dev: Device to free the IOVA space for
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c
b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 455541d21538..5749be3a9b58 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -30,25 +30,12 @@ static int vfio_pci_dma_buf_attach(struct dma_buf
*dmabuf,
 	if (priv->revoked)
 		return -ENODEV;
 -	switch (pci_p2pdma_map_type(priv->vdev->provider, attachment->dev)) {
-	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
-		break;
-	case PCI_P2PDMA_MAP_BUS_ADDR:
-		/*
-		 * There is no need in IOVA at all for this flow.
-		 * We rely on attachment->priv == NULL as a marker
-		 * for this mode.
-		 */
-		return 0;
-	default:
-		return -EINVAL;
-	}
-
 	attachment->priv = kzalloc(sizeof(struct dma_iova_state), GFP_KERNEL);
 	if (!attachment->priv)
 		return -ENOMEM;
 -	dma_iova_try_alloc(attachment->dev, attachment->priv, 0, priv->size);
+	dma_iova_try_alloc_p2p(priv->vdev->provider, attachment->dev,
+			       attachment->priv, 0, priv->size);
 	return 0;
 }
 @@ -98,26 +85,11 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment
*attachment,
 	sgl = sgt->sgl;
  	for (i = 0; i < priv->nr_ranges; i++) {
-		if (!state) {
-			addr = pci_p2pdma_bus_addr_map(provider,
-						       phys_vec[i].paddr);
-		} else if (dma_use_iova(state)) {
-			ret = dma_iova_link(attachment->dev, state,
-					    phys_vec[i].paddr, 0,
-					    phys_vec[i].len, dir, attrs);
-			if (ret)
-				goto err_unmap_dma;
-
-			mapped_len += phys_vec[i].len;
-		} else {
-			addr = dma_map_phys(attachment->dev, phys_vec[i].paddr,
-					    phys_vec[i].len, dir, attrs);
-			ret = dma_mapping_error(attachment->dev, addr);
-			if (ret)
-				goto err_unmap_dma;
-		}
+		addr = dma_map_phys_prealloc(attachment->dev, phys_vec[i].paddr,
+					     phys_vec[i].len, dir, attrs, state,
+					     provider);
 -		if (!state || !dma_use_iova(state)) {
+		if (addr != DMA_MAPPING_USE_IOVA) {
 			/*
 			 * In IOVA case, there is only one SG entry which spans
 			 * for whole IOVA address space. So there is no need
@@ -128,7 +100,7 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment
*attachment,
 		}
 	}
 -	if (state && dma_use_iova(state)) {
+	if (addr == DMA_MAPPING_USE_IOVA) {
 		WARN_ON_ONCE(mapped_len != priv->size);
 		ret = dma_iova_sync(attachment->dev, state, 0, mapped_len);
 		if (ret)
@@ -139,7 +111,7 @@ vfio_pci_dma_buf_map(struct dma_buf_attachment
*attachment,
 	return sgt;
  err_unmap_dma:
-	if (!i || !state)
+	if (!i || state->bus_addr)
 		; /* Do nothing */
 	else if (dma_use_iova(state))
 		dma_iova_destroy(attachment->dev, state, mapped_len, dir,
@@ -164,7 +136,7 @@ static void vfio_pci_dma_buf_unmap(struct
dma_buf_attachment *attachment,
 	struct scatterlist *sgl;
 	int i;
 -	if (!state)
+	if (state->bus_addr)
 		; /* Do nothing */
 	else if (dma_use_iova(state))
 		dma_iova_destroy(attachment->dev, state, priv->size, dir,
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index ba54bbeca861..675e5ac13265 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -70,11 +70,14 @@
  */
 #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
 +#define DMA_MAPPING_USE_IOVA		((dma_addr_t)-2)
+
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
  struct dma_iova_state {
 	dma_addr_t addr;
 	u64 __size;
+	bool bus_addr;
 };
  /*
@@ -120,6 +123,12 @@ void dma_unmap_page_attrs(struct device *dev,
dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs);
 dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		enum dma_data_direction dir, unsigned long attrs);
+
+struct p2pdma_provider;
+dma_addr_t dma_map_phys_prealloc(struct device *dev, phys_addr_t phys,
size_t size,
+		enum dma_data_direction dir, unsigned long attrs,
+		struct dma_iova_state *state, struct p2pdma_provider *provider);
+
 void dma_unmap_phys(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs);
 unsigned int dma_map_sg_attrs(struct device *dev, struct scatterlist *sg,
@@ -321,6 +330,8 @@ static inline bool dma_use_iova(struct
dma_iova_state *state)
  bool dma_iova_try_alloc(struct device *dev, struct dma_iova_state *state,
 		phys_addr_t phys, size_t size);
+void dma_iova_try_alloc_p2p(struct p2pdma_provider *provider, struct
device *dev,
+		struct dma_iova_state *state, phys_addr_t phys, size_t size);
 void dma_iova_free(struct device *dev, struct dma_iova_state *state);
 void dma_iova_destroy(struct device *dev, struct dma_iova_state *state,
 		size_t mapped_len, enum dma_data_direction dir,
@@ -343,6 +354,11 @@ static inline bool dma_iova_try_alloc(struct device
*dev,
 {
 	return false;
 }
+static inline void dma_iova_try_alloc_p2p(struct p2pdma_provider *provider,
+		struct device *dev, struct dma_iova_state *state, phys_addr_t phys,
+		size_t size)
+{
+}
 static inline void dma_iova_free(struct device *dev,
 		struct dma_iova_state *state)
 {
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index e1586eb52ab3..b2110098a29b 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -13,6 +13,7 @@
 #include <linux/iommu-dma.h>
 #include <linux/kmsan.h>
 #include <linux/of_device.h>
+#include <linux/pci-p2pdma.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include "debug.h"
@@ -202,6 +203,27 @@ dma_addr_t dma_map_phys(struct device *dev,
phys_addr_t phys, size_t size,
 }
 EXPORT_SYMBOL_GPL(dma_map_phys);
 +dma_addr_t dma_map_phys_prealloc(struct device *dev, phys_addr_t phys,
size_t size,
+		enum dma_data_direction dir, unsigned long attrs,
+		struct dma_iova_state *state, struct p2pdma_provider *provider)
+{
+	int ret;
+
+	if (state->bus_addr)
+		return pci_p2pdma_bus_addr_map(provider, phys);
+
+	if (dma_use_iova(state)) {
+		ret = dma_iova_link(dev, state, phys, 0, size, dir, attrs);
+		if (ret)
+			return DMA_MAPPING_ERROR;
+
+		return DMA_MAPPING_USE_IOVA;
+	}
+
+	return dma_map_phys(dev, phys, size, dir, attrs);
+}
+EXPORT_SYMBOL_GPL(dma_map_phys_prealloc);
+
 dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		size_t offset, size_t size, enum dma_data_direction dir,
 		unsigned long attrs)



