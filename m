Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EEFCA0EF7
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4FC8E0033; Tue, 19 Aug 2025 13:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2F128E0005; Tue, 19 Aug 2025 13:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6AC8E0033; Tue, 19 Aug 2025 13:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B2ACF8E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CAE41A018C
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:13 +0000 (UTC)
X-FDA: 83794215666.16.C159732
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03A1214000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0VJAtsV;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUWODOYu7xl20YNi/5H7WavDXD5EiHAIElpuMjzztLk=;
	b=uVvoDoPci1n2Z9nxUnocoi5nJwWOg0sVozSguW27F02hDP/dp0ravBJI7q7+qUrDeBGv2X
	WFO4ObwHpNYMqXAg1A4l4bTXrcxqzk+thWVxPFyhcECtFeMGVee/ZQ5shAhg7GDSXB9AN3
	BlbZBC6jKjicT+tIatlD3UlpC5F39e0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625092; a=rsa-sha256;
	cv=none;
	b=eDqdCBwwZ83FKHwxk+fP76v92Xq9GCSEXE9n2Rdp/TVc55gmha/CKPes6c4/wJDWymVt5t
	F6OfkMdJltfW97G7WBABGHmL/OcsZCFA8MeBto9JmZfswlDK1H6hbD9uSoHlQkvWSohhrb
	07vaUP0lgAXDDZGMlZy3nFTyv6yRHLY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f0VJAtsV;
	spf=pass (imf26.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7FC7261429;
	Tue, 19 Aug 2025 17:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0661C4CEF4;
	Tue, 19 Aug 2025 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625091;
	bh=6kQRc8M4kSTN6oNlv6UupesxmLI8KrU+a1TL4nhd0iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0VJAtsVM5u2o6C1nUp18HimKN2EfCmaIhrfHn2QNSc0GqPof7zC6NvZWtW7WxBRR
	 p3RzrCBavtqMekvMpM+FFh/Cujilw/RqORiadfmgV0O0WPFzb3zoh9fG9NtA2SaKoT
	 4uJuPVNsL+wJyPMLIlFVRwue/XQQMijoKpQiX1gYXGPLJHRcRcKooNhIu/RI+O4xTw
	 brcapoHDidTXn3mbpESixmE7uBDkslSxKOYNfAAHP/Nup/cmkLiUsTvpENQ4pVyy+t
	 J22UXxZ5+SPlhyjgcQ8KrBLrryIlymPi7z68rps63VS+W0pkPza1dnTv8/Usu1mzsw
	 k69P5i9HZUFVA==
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
Subject: [PATCH v4 09/16] dma-mapping: handle MMIO flow in dma_map|unmap_page
Date: Tue, 19 Aug 2025 20:36:53 +0300
Message-ID: <ba5b6525bb8d49ca356a299aa63b0a495d3c74ca.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03A1214000E
X-Stat-Signature: p37963k95w7fqb67oe58yayiuba8hwyq
X-HE-Tag: 1755625091-468876
X-HE-Meta: U2FsdGVkX1+MyeBm1ESwPvi7pg6bh/tPOlEPbgahwXGaeatgs9XMRfq2zbNmMMNSJWpun/ZOPir4sXLn9MPS7fJvjftUcuNVSNF+abnNvOtBJAlXh7vrRNvgfvqetordgOx+FVTH/BgD8kjrpB+qKdM8/4QXyvZhOHDZY/ZJv1I4d4TdrMfLzIJh1SlQPZc9VH/+ymajx6NBbHgurmLGqC1JC2+SbuoxFfnQD86YIBEsqfy+58CRI+xxPXANmygFMLgrtYNviOKXSktk22in7cCOhvOK3NcgSYmlpIb10INm/WSxiMqQN1V3Z/PvokdIG9HGAZyhx4feH9JNnCSWkrNoY+pTpzyO/l/ngAs2xHxvndBYEz3fRGaJ98AgN2hu5dORO8n9O0bAahYiq19/GuITJlg6dZn+46aZRfXbRmVANWzllWsvnbcFdaVmFq9wNvzQ/IA+4GZdz1VhxNtuCGBmIOh0nutdHZf8OUa7BsY3fjsvClZEELgDt+pR29v5DCQHx+Uul6MROoNagXbi4jAkNEE38psC+NqugiLJWSmPPT5ck2e7VD5TlNm12NEWxrXDNVNzSW2NWYOr2qh8YuceOeBXErwDVZqGXfUpBuR96OoA/u9LMyznXq7yD3Af5sfGVBWSdI9AJje9K016I4aa8eXUOAWtB4swq8ZxsatNUnCg6s36guZeRAk6J2yluWbRrQ/v87Qhmzq9nz2zxK7XM62cPo7W8VDDCfclMv4552LAQ+FyoGl2qIdWefqbhrRHxNgexUin41dWIzvTv+n+FUBudcszPMmdZ83RpaJeveTf48ne7y5rkpB+k7d+zLDcJKMTptTMqyEmDnYmEVm4ndnnJku9lKEg+oMDJQYRf9b3OC2Leuxgg2RcOEMOqvRHv4TMV4Yie2CNv11YLYuUJwGkhkfQtdkbFt6xbXzP1U0iVZEb8PdsE0R6sTNXh+shAFKkT6Uud6YD3l6
 TgmIIPqq
 v6V9z5uFadCkK/oMVyH7wQh4rCOZNo4e5SCmYZXR1X/kPwtf3lQmKtRXWsZb/rb5hPyEwWh11PWJdLHa2uD6GLP+CZcAvHMe1CCCgO09AFeNo4gpByuLn3hS4pINzY1kYuk8cIK0ZLtU6+G2MYMlf6bZ2yZezzuVOoSZo0QKaoxn/GwQaSX54CeV+vgL8+oufdv7YTJaJhDrmXtSQ3j3jOuIfBzXnSs8oCxvpVY4PWL3bzmzkze5X9Nfd8tDAy9UbXtWpT863/QjuyTZkeMeDiOdC5tF6zYYezayD+HOcDZG8g9SibWMBkx2QshxUi7iwGEkm+eCwzLVl3/3jk59XxbGEeg2uEa/rNi14
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Extend base DMA page API to handle MMIO flow and follow
existing dma_map_resource() implementation to rely on dma_map_direct()
only to take DMA direct path.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/mapping.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 891e1fc3e582..fdabfdaeff1d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	phys_addr_t phys = page_to_phys(page) + offset;
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 	dma_addr_t addr;
 
 	BUG_ON(!valid_dma_direction(dir));
@@ -166,14 +167,25 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
 		return DMA_MAPPING_ERROR;
 
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_map_phys_direct(dev, phys + size))
+	    (!is_mmio && arch_dma_map_phys_direct(dev, phys + size)))
 		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (!ops->map_resource)
+			return DMA_MAPPING_ERROR;
+
+		addr = ops->map_resource(dev, phys, size, dir, attrs);
+	} else {
+		/*
+		 * The dma_ops API contract for ops->map_page() requires
+		 * kmappable memory, while ops->map_resource() does not.
+		 */
 		addr = ops->map_page(dev, page, offset, size, dir, attrs);
+	}
 
-	kmsan_handle_dma(phys, size, dir);
+	if (!is_mmio)
+		kmsan_handle_dma(phys, size, dir);
 	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
 	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
 
@@ -185,14 +197,18 @@ void dma_unmap_page_attrs(struct device *dev, dma_addr_t addr, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
+	bool is_mmio = attrs & DMA_ATTR_MMIO;
 
 	BUG_ON(!valid_dma_direction(dir));
 	if (dma_map_direct(dev, ops) ||
-	    arch_dma_unmap_phys_direct(dev, addr + size))
+	    (!is_mmio && arch_dma_unmap_phys_direct(dev, addr + size)))
 		dma_direct_unmap_phys(dev, addr, size, dir, attrs);
 	else if (use_dma_iommu(dev))
 		iommu_dma_unmap_phys(dev, addr, size, dir, attrs);
-	else
+	else if (is_mmio) {
+		if (ops->unmap_resource)
+			ops->unmap_resource(dev, addr, size, dir, attrs);
+	} else
 		ops->unmap_page(dev, addr, size, dir, attrs);
 	trace_dma_unmap_phys(dev, addr, size, dir, attrs);
 	debug_dma_unmap_phys(dev, addr, size, dir);
-- 
2.50.1


