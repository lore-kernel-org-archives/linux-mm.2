Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37E0BC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8E36B00B6; Mon,  4 Aug 2025 08:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9676B00B7; Mon,  4 Aug 2025 08:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B718D6B00B8; Mon,  4 Aug 2025 08:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A39956B00B6
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E0461342FD
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:17 +0000 (UTC)
X-FDA: 83739042954.21.09DDC59
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D635C000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtgAnXB9;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njJVaIqIe6sqKLpFp72s28bWMOkerJgS7/NyUH+svec=;
	b=Hx12yh9cMknjMwt4zcXj3XcNHeaDyvFkjJLh1C8+vUHeTZ0I2wK8jkGJJGD+4wl8XQf8EL
	ykfLTfwdQ8ekxYssvRpoKEyWyev0VAmMh0Jxc27RSrpd8psNX+W+pbnTzNCFmdDrPYEg45
	OeN1ogfTT1f/4KcIZ46pw8Cq+bMmTmA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311455; a=rsa-sha256;
	cv=none;
	b=Ih6P92ozqJXBuMHp2YO7l6pdeRpzirleFsrM4BX64OsNTkq97kQ54+ompdLgkGJLsDuFfG
	EA5VtXd5C/aMacX9EWqgF6wTUfdlIk091f2shs4vLbjENpKisxqgdFIs7IDdpZnjjlDeOV
	Z1lv4ajipm+kyn98IKerfKC4sB+eBTk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OtgAnXB9;
	spf=pass (imf28.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 0920DA55826;
	Mon,  4 Aug 2025 12:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58081C4CEF0;
	Mon,  4 Aug 2025 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311454;
	bh=qnVGWPERMw1BTa2/gk85Rr9nCLsamOSAPU4HKvyJS1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtgAnXB9G/hO4kHiG6lUbx1lGdhplK8QSnQvERbDkZeJ2rBPi5BohP2fOcU1EY1H0
	 LWK7JmM6eYjvDV85Iv2oqAeUvxpoecgv6pnhGevxoOAJjwoIKIBVlnyhDtWl6iMFdx
	 RkkwEUkNj1PK4RIEa7lvhblH+3HASR9LDXUdd9ooPuLmkTQNLafsqp7vExm+lHX79L
	 xgsW9Dlqtb1H+ROfUItFyQuMNgUa0HHgvJ+5cBoMm5E0OKANto/+eCMPooaSWD2S6k
	 W4Hqu5Itep2BtJPMCEt1CECg7NNUHsl45+R6007i0eogZT7o+A+uJhsGr5xPHo73g0
	 Vn+VRBXex4Xsg==
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
Subject: [PATCH v1 10/16] xen: swiotlb: Open code map_resource callback
Date: Mon,  4 Aug 2025 15:42:44 +0300
Message-ID: <e69e9510d9024d664133dc788f5186aac414318e.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9D635C000C
X-Stat-Signature: nukzyzarroh483n5bm3wjo35s7k8u3x6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754311455-54979
X-HE-Meta: U2FsdGVkX18IbkDg0oKOfQxAsOEZZsYr55ARZPQHps9VAY5jOKdlmOm+iKiBIJOGdwcAMOwclnVWnCGEXoGPKIjcxDpSoQPTIFrZJWsuMu5v0FotSUbyVxu1F2IYB9GoIit9kx3l1r7BGsry5UR6AePc0xNtkmdann66GfBD7J/gpf56GSOfHdQjOk6ItjjkxKK3/4F7gGSQG2X1pU/P+RZ/UcB9xryOkoCzsK7inOWTNEvd95r8z1kcdRgUCW7LzHxYE+jp1rpOOeuoNjvLLno7x4GwnQq6tOCryHsjhEpkGb2+4NfUsAh2ntJW3pWbuFHFGsOFgsR8sv/vBPtBj9ZmdAFzMPQcPY119yUOt2bY9WqLvKzuxX0F9THuPXlUGO6Hj9iLIH5v9tEYn0Eaei1PXeLjQhWutiLIG7mKMIBn7Xv8G7+EhQ1KjxFymX+foCJ8+ixVACrS8t3zgUkNaHMtfwrpR4O/qQsQLwcqQeVseMDuwlV2Lz6D4mqNnkPIKl+7YPckm18+bo4/kBo6Nb0wcQcE6ey8R8fjeOrbRbq0/bjkUqpfp7RzTL+2OvqoxkbiR1anV0I9UJHR3hLpzYbq0bvOzXBlNMmsxaOdfD92FB752G1EYmVEHx+d4sghF3Ito8PHMhK7S1ioZaQE30HdfpFZjmW5lsUjHzKvqHwyH2iUkDZ5LlcggqfQZs6MzxrtRLY0tpnkiCXdNUJA5pvx7oYV/1+JumuTcaSuTf3Gf9+dcDe5QyDMUrE5fAcoQpff8XCgWfVx/bYRSVSDikyp8rAPsT23s69xJtSP0w0ibBMZnturmK1g3vB/aLOV/tddu1uex0g91GLAdY4fSgnvxVt1uV6jSr/ns1L8yvl8YU8c6QmE3IZCrrJ8Kahit6WTsliQKc/HANR1JWwyl6CcXBalijJM44j+Jy/GTiDWu4yo7RHuK4XQotOBeb7rY1hUlmsEApyDHUllBEx
 3Z4v03p1
 E+UZH8WlVl/cABU6bFPLBaES/isHd7i9K4GhgSXjDgJcyMqEvd2hVXTgdUYwZnRZtgAoFBJIg/ukjhIBGQHTmLC56yNPJlbtVL2xkyCUbLiPEuoTIvKXMdMyHW/r7DZukAzvLBvFkZ/A9i4oFZGaqWhRw4Jg6O0T1YS6+x1nvW00p/ER9tWuMzZNh4lRHUD/IJ9AKA+Xwv71f6Eisq4jh9q5y7976M+edZdED1Vxj6S803IVcIEBdlqEFmWkdFZY4pPpv0+JApfi869VgEsFiR6gEm0HXG/nFanToc7PI6Un4Y4ssTZGyN2POZhaUqwe5wEIAfxriCFp4WTSW8YWt7+IYuucGHiSXsuMD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

General dma_direct_map_resource() is going to be removed
in next patch, so simply open-code it in xen driver.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/xen/swiotlb-xen.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index da1a7d3d377cf..dd7747a2de879 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -392,6 +392,25 @@ xen_swiotlb_sync_sg_for_device(struct device *dev, struct scatterlist *sgl,
 	}
 }
 
+static dma_addr_t xen_swiotlb_direct_map_resource(struct device *dev,
+						  phys_addr_t paddr,
+						  size_t size,
+						  enum dma_data_direction dir,
+						  unsigned long attrs)
+{
+	dma_addr_t dma_addr = paddr;
+
+	if (unlikely(!dma_capable(dev, dma_addr, size, false))) {
+		dev_err_once(dev,
+			     "DMA addr %pad+%zu overflow (mask %llx, bus limit %llx).\n",
+			     &dma_addr, size, *dev->dma_mask, dev->bus_dma_limit);
+		WARN_ON_ONCE(1);
+		return DMA_MAPPING_ERROR;
+	}
+
+	return dma_addr;
+}
+
 /*
  * Return whether the given device DMA address mask can be supported
  * properly.  For example, if your device can only drive the low 24-bits
@@ -426,5 +445,5 @@ const struct dma_map_ops xen_swiotlb_dma_ops = {
 	.alloc_pages_op = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
 	.max_mapping_size = swiotlb_max_mapping_size,
-	.map_resource = dma_direct_map_resource,
+	.map_resource = xen_swiotlb_direct_map_resource,
 };
-- 
2.50.1


