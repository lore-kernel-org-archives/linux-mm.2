Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DBCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9E38E002B; Tue, 19 Aug 2025 13:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32428E0005; Tue, 19 Aug 2025 13:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC928E002B; Tue, 19 Aug 2025 13:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEE38E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:37:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6850011625F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:44 +0000 (UTC)
X-FDA: 83794214448.03.60ACB94
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC27C4000C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:37:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcfXQzEM;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfgzUojTM/DB/MYkk7DA2Hi+SCW1x3wlstgTHhLqb3I=;
	b=Z2Gdz1fuqsA3tue0ot3jIg9d1KaCNj1jnVJ6Et1xfz40qMMezEnfypY/r0pDjrAdTs5Vtt
	s/8eUlpmZ6htolf6v5uZSmN06mPaxJ46D7CAgI8aRCgDau7cptwCpbnOxOGDwRr6yc61WM
	baJj9o3P+Pwyc+3rbrvjErYjx5E0XNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625062; a=rsa-sha256;
	cv=none;
	b=6ZZF7FvWo9C8l0t82oolGBqUAUR1+P7E8CshrKLgC/1p84veeoxx2TxwHQKnG9XlkPgPgr
	zmexMmQ8NgIyRC7erDj2eCNoHX9DLVOnabV9PQXEhvLk96eVrWQSNarNuctBDSJ4RoEiLe
	JavCXej4QHttHPN/vIAO0WxzTN20oYk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZcfXQzEM;
	spf=pass (imf07.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7C8405C64F0;
	Tue, 19 Aug 2025 17:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FEBC116B1;
	Tue, 19 Aug 2025 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625061;
	bh=mXPBKGOTAXMaA8YnIACrT4VeK6ColaZH6f/lOi0T5+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcfXQzEMtP4+AZ86jo3dtO0Oekoz5PxnIpxVGiM0bP5sSs9WMxZsIT5kYk/VnUi3R
	 /kc0Vzr2i3fBfcwwoPTgAmdyvW5ST0B2y1uv9wp+i8hWG5QgN6gN0jrKDriRJyNDRP
	 26rMrCRUHHKb1TjV3vj8pKsHfYCF8VeZXtu9+b4Vsvi65u3DslqBcB4jsQub3Gt2qD
	 KJFY83CBFYAED4nL0OxEGnoJhmf5HiiRJ0eyTbwf76fL/xpbF4kq0K7Xr5ssJRHfaG
	 Znxa2J61vk0Pu5GfNVrDFyX+mri+BrC7qwdiENTcRxzxBPp/BwoEirtjDV08OZLE7g
	 87wPEgWDV7Xzg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v4 02/16] iommu/dma: implement DMA_ATTR_MMIO for dma_iova_link().
Date: Tue, 19 Aug 2025 20:36:46 +0300
Message-ID: <62d9a6c3ca03037631f6d0640ebec5fbac41d547.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AC27C4000C
X-Stat-Signature: rbyo5cwhzwnqh96hznfx1us7us9yo6cn
X-HE-Tag: 1755625062-897309
X-HE-Meta: U2FsdGVkX1/c7g05KIdJ83cCRZIu0iDbK7Kv/zaIoslR1RkdXgVaqcSFa/JZvC/XxTJeeEdHldlAlih78qnDe2KRhLl8LVtjz6Wu3juz/xkHWcCcrgFUeMYettoVto8vzalkTdobF1E6IjfJ60xyaPUWEKZVPMm7p0jAzJfWEdXjCb21GFS4fKZSSR5N6BkMm8BRdfmC3TzR+UPGf7gq8R4TLpZ0Q+Nf5DIhf9ecDm1iXk1QI9cznSc2IGbLFIv57IEEVjM0O6dVLNjGqEGcn4HWQlFaeXwJd+50syfRyQOFpHstmpQaZ2cTqm2tuZ+y3smfaoLUB9ulwjYWTiOgGOTDbw6KzBl2c2F6xuG6okxel0qps76P29EtRB1TFMkoAAiw0A2h8vnsZ+/CrHHXvQlmjbcR+EDtaxintGpRU0zSiE0HqNQZWf+To8xFRyHnXgwYmXcP5q6/DI6RZvkIRAthGd2yokUwCGhHjQAmC03Mn5+Fb3hIlGa4rj1ogXheiALyaY7OcTT4lXw7h5ikpDDZW3OhnQcrXajZdkYZA9CyC3mwwFdMHfVoA21kZBUMNEkIIWeGdQYPYaifxxSM+jNyugxLo2TNjJBUOaksQEfFR67TCPL2XFkcIcXxi7qgfHsgLRpUnCjnIflAUO0cPJ92vtZxfm6DdDP9p+L01A3YW5Oo5bMw900QPLTHf/GDVTF6Ae3Y+q44tMimTWEGJ/95YK5B+uVkUbWjtm+CUm4RkINEgzGADyocxHg/oPJbkpHJhGmzd0QWP8OvkM1B0vZ7B0K4Q5yb2oai2fkKk3l5fl45ihdkrcJHDBz+xxiSHp8/lENB8Cr6tyIpX8x+GADmskkLx4qBgR/ySo+ECuqHUa9X72SeYGC8Me2YD3ZPeYJojV1WCPqQ+d52KTrasl8nt8ncbTm61Wtb7Pc0PPO9rLBXN+zUR0oTb4hj5JAqNpxFp1Oy8xg/TQ7g+Yi
 j4s6/A54
 r88YMRPgg/KCrt4Tfe7k24anFEuIy8KkvF2zILwzOHRIW2G5y8FGoKb/oPr+jGSvEV6JwMBQNlr9rGNF/oMZhR5Q5FZNTL64YRwDvHM1Q1OQVX6STNnMBxWsmgE8vrUyftin+XhgVvjgdUKtbqpOXZuRGXNHhU3EbUksIneevLPFtedVP8bzpCf2QzIhtt2e9vokiOdRD/RjX5bFcrmf2Y+FVONPwAEsm9V4xZihJy4X7GVmWZy/WCGg1VbmeJ+tMmoW11DcJ9zfBo9diYHa4Q3hdw2Tq89H5EhgP/hEAXMJPv+KFsD/nzQCwdS8F8mW1xxDZQdBkQB4zK0F+JOy2A5enZBiX29ZhH7C+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

This will replace the hacky use of DMA_ATTR_SKIP_CPU_SYNC to avoid
touching the possibly non-KVA MMIO memory.

Also correct the incorrect caching attribute for the IOMMU, MMIO
memory should not be cachable inside the IOMMU mapping or it can
possibly create system problems. Set IOMMU_MMIO for DMA_ATTR_MMIO.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/dma-iommu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index ea2ef53bd4fe..e1185ba73e23 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -724,7 +724,12 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
 static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
 		     unsigned long attrs)
 {
-	int prot = coherent ? IOMMU_CACHE : 0;
+	int prot;
+
+	if (attrs & DMA_ATTR_MMIO)
+		prot = IOMMU_MMIO;
+	else
+		prot = coherent ? IOMMU_CACHE : 0;
 
 	if (attrs & DMA_ATTR_PRIVILEGED)
 		prot |= IOMMU_PRIV;
@@ -1838,12 +1843,13 @@ static int __dma_iova_link(struct device *dev, dma_addr_t addr,
 		unsigned long attrs)
 {
 	bool coherent = dev_is_dma_coherent(dev);
+	int prot = dma_info_to_prot(dir, coherent, attrs);
 
-	if (!coherent && !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+	if (!coherent && !(attrs & (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_MMIO)))
 		arch_sync_dma_for_device(phys, size, dir);
 
 	return iommu_map_nosync(iommu_get_dma_domain(dev), addr, phys, size,
-			dma_info_to_prot(dir, coherent, attrs), GFP_ATOMIC);
+			prot, GFP_ATOMIC);
 }
 
 static int iommu_dma_iova_bounce_and_link(struct device *dev, dma_addr_t addr,
@@ -1949,9 +1955,13 @@ int dma_iova_link(struct device *dev, struct dma_iova_state *state,
 		return -EIO;
 
 	if (dev_use_swiotlb(dev, size, dir) &&
-	    iova_unaligned(iovad, phys, size))
+	    iova_unaligned(iovad, phys, size)) {
+		if (attrs & DMA_ATTR_MMIO)
+			return -EPERM;
+
 		return iommu_dma_iova_link_swiotlb(dev, state, phys, offset,
 				size, dir, attrs);
+	}
 
 	return __dma_iova_link(dev, state->addr + offset - iova_start_pad,
 			phys - iova_start_pad,
-- 
2.50.1


