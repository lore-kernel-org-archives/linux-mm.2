Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BA6FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0376B009B; Tue, 31 Mar 2026 06:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079D86B009D; Tue, 31 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36016B009F; Tue, 31 Mar 2026 06:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF7D06B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B71C1B8D86
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:36 +0000 (UTC)
X-FDA: 84605913672.28.5F2873C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 96190C0016
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJvLYjTs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951234; a=rsa-sha256;
	cv=none;
	b=ujZp8XEX5181FrH/7W2G2BU12FZPEiDu/D7NLgIJItgukqeQYCZW6cYNn+LTk4Nn0wQmws
	QkCE+a6+JqKSJ0kIHrB5Kq69QUk/Dm32NQ2cqKlSjfSggABDmO8/9YQmjOGcDb0kCFC8tu
	qR7dqoLlFhFEZ9M9i2jsXTswqdVQ+BM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJvLYjTs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpX+yCVWhexOw7n2KFt90sRi91aip8erw/Nd3z2qMDM=;
	b=3b22IHEfngvweX6EIeZAKJwXiHCg8dvlFt6qHFMvVfsAcb2xy5Io8ctddEdPilAaCb0Amg
	1qjU/VrvtXWRFkmaP85kfL2wcxGnGsa2ptIOfB1MFHSDgRlLqxvMHQQtmCXmNSoU+Pq9u+
	Tus/7nrs5UcdEZHQ7gpdojx/2iYlrXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B62F44459E;
	Tue, 31 Mar 2026 10:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311CFC2BCB2;
	Tue, 31 Mar 2026 10:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951233;
	bh=WYlzG+ukMJv0uKE6bBondQfqi9l4oA5FGcpDNGm8BfQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CJvLYjTsGVFPfmwcssIBPuYWjEXZyeslFXYMGjWslUxnkyWJMRkYWx/l4rHOl4MhJ
	 Cs86r/iSby2dp1Cy3j1p0YGLO8/seT+yM9iTE785mhUngsXG5HrJINhMDZAvJ8kXUa
	 9MteSpTOUqG7xcXMh7lSM12m7OWM2y7/jGQ7ij9uIsRnSyoAWJP5cdy3YmbmeIUWtl
	 3skZX52saIkv3R0r8Zc79v2VEXqEJ5d8ohc75fVF98npAw3lC5eBO+pQYuqJ8skGNz
	 orDcMmp0BajvP9QI2x0X2qP6MS0813wJiAU0+2RjN5K9t2VKQWmbyqxaXS9dG18Kth
	 0N4mtm7SpjM/w==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:13 +0200
Subject: [PATCH v4 4/8] dma: contiguous: Export dev_get_cma_area()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-4-e18fda504419@kernel.org>
References: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=953; i=mripard@kernel.org;
 h=from:subject:message-id; bh=WYlzG+ukMJv0uKE6bBondQfqi9l4oA5FGcpDNGm8BfQ=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZxv81fradDYnN/8Gl+LUDRekPcP7X+5e8vtpaNLbZ
 K2t8qwHOqayMAhzMsiKKbI8kQk7vbx9cZWD/cofMHNYmUCGMHBxCsBEJvky1hcs2svx6NgZ4yLT
 IJXHbfnV+8vfCTVuNBNRuXuBr/aQjfAp4RlrxZYV5B417zYNOlOXythwwin1TskDzm27Z2rb8pt
 OVlje0m/zePGpgNv7l8Yd/GkY9ICfXSqnI+m2pstGTfO58fwA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: 4czho4b1m6z8xha1sqtcf846uujisnyt
X-Rspamd-Queue-Id: 96190C0016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774951234-593336
X-HE-Meta: U2FsdGVkX19lRGYnPuOZOVzsxGXqqKWExWF651QZCyMN3VmHPq5TFM8vVctOUPSE75ntUPxtHh17VeWaShRl9j5ZpkLWbMcqk5KNQ7Ps+O4Dg01rNMjV4kxRst5Qypu7C8W1sGy9z/vGF2OY7MPhWOWpMcwEsmnMQNqtUyIxPXsmtDA9bl/wzNF2X2UUgdyATllWq1S2iRyvuNxOtBIF+AgYXgKswYayX+mcubFZQHDhrAoqz9yQInOUPNRjhdwDT85wfT++TC7rfKI9F8Y2Vy3ER01LSK/cudUqjlGVsTtfA+JbtG4hTvBmWA0nnt9sZ/WiTZp1SXu3kZiOh86yxq77lnv2p91kquE6Cy1O0uL6qNWSMydVeOWTKhcyT8aSWPZps4YOCqC/S0oO5CvOTQtW0NznWA7pBL83HlYvV1O7gSLev3L34Y/TSx4PK+Y5W1QJTXIhFGnH5nLbDdEOotpa1mSuzmGedm7gbGGN2JjMvdpyi01b6qFcETuPoTYsAkAIf0gtYBpQjJ3DPi8Hg3vLR9MMr0JOLtPrICFb4G9KqP6/SwP3gtRITUecCs8gQF5EadtAsm2AdasDYaxk4GvMnTI4oZzmX2K+Xjj6BY2mwUe9XL+2CTK8uMA2JBBIZWTw00p7SfkVmGB098oGjThplhlMhq+tDLGpBO9+u1hZzDskzf/WujBjkIZZa5ntg9orci0ThRYxvg1+Evs4YRnhmJhATEAs3c29O70sFjxhc4kgNVvL81ueJrHo9ZNC1kn6B4B1LBbEfu8RdykoEkTqvs84KbqI3yaL7yLoVoQHmS2rDnWoEGmzMbxK16Af0nqoOHW8opKlshgcwryMwcLfhfGxUEBYXnSleRoYHeyvMocXRZd80Ifk11f3zpIY3TJx4ydCHQh0vCdtKY2oNrLntodBq6FhiXkjYHZOrzRs7EF8TXJEgB+8ZqULxXEGnQ5hNcpw12FwEDstJOe
 VdKfBeaZ
 cw0UhLDZA2e6zKmu215tmG204rD/WZCmBwXgmAlw6gU3/zDRlrr4x+D5N8GraJSSuXIIrWpXlPLyqipSs/evNe3soV9IdRc72AfNSi+RTGgymQxDxJ9pcQbrVE6P9Mc1R6nuCYmZ1Y3rFFd5nuPa0Nzb2sxKPIUMESoSRkV+Kr/oTan2fWI4TIJGbSY3Cz56oXmufYuMq3ezIJj2wgWQnNXGTTxROHzyP5TYV2tdc8aftrlNmIj/GOy32UkdIu8/mhbBaGRirhW2Q8vWAoCjoka9RimMB+06ejqhP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses the dev_get_cma_area() function to retrieve
the default contiguous area.

Now that this function is no longer inlined, and since we want to turn
the CMA heap into a module, let's export it.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 kernel/dma/contiguous.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index fd8d3518a2323f0a631fb185ef92a24c35f8d25d..83a5bd9488e1448cc72e92ed204ce804164cc6b8 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -136,10 +136,11 @@ struct cma *dev_get_cma_area(struct device *dev)
 	if (dev && dev->cma_area)
 		return dev->cma_area;
 
 	return dma_contiguous_default_area;
 }
+EXPORT_SYMBOL_GPL(dev_get_cma_area);
 
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;

-- 
2.53.0


