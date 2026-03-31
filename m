Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF66FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D816B00A0; Tue, 31 Mar 2026 06:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5362E6B00A1; Tue, 31 Mar 2026 06:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473236B00A2; Tue, 31 Mar 2026 06:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A886B00A0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBF60BD4CB
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:44 +0000 (UTC)
X-FDA: 84605914008.09.5957B10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E6A9A4001A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Up1CxMKO;
	spf=pass (imf11.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Up1CxMKO;
	spf=pass (imf11.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951243; a=rsa-sha256;
	cv=none;
	b=C9ME+IdKzvdGQjX5wQpM83wEiWW53tTD/hc3ucka74WEDXyYn0I2b8PhA4Bfcy5xMpCwKp
	99dAeSPYGQ5LJdqa4IZThVdrAKKy1qDWhM/hnhBklpbJbOmjrQrgCfnPrs8QoJ7zdqeoOq
	iJqNE+Z1S65GPUeNncQbxdeEdoS2FOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYpQ4eC80OBeBm8qBkwo4RkyX3YYLUiZI9VrBAzp8gM=;
	b=ZCoNjiLCHtAxSQhxRXpa90QAnT/3GpUaJD6F/LRxrd6j4dxvpNlfiUsWjYdoFF0TLYN5FM
	x/JNgwClzpxq0ljJxTLV5ucOgnxr58STFrfYzuGDEoSYq3Qw5JukIWdMaz0BAPk3fiO76R
	uQbMpD8ZmhyW7VccoFBEkQpTa8yniXU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 213C24099A;
	Tue, 31 Mar 2026 10:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FDDC19423;
	Tue, 31 Mar 2026 10:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951242;
	bh=XD1ohQhO9zZA1+h5cJdCf8noqsv9utcIYdzdurGWIrY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Up1CxMKOAyN1rLwyQza8/sAk+vuTStw21qVWIaeT0nv7/i2FS4hW1rDu2o22IyXEN
	 KKa5Vg1LLUbpLbvjhb8zh9awLQxhplAE1M+xTJ8L4nCdl3cjQ2uhrO36q6X6Buto1Y
	 tfUcsp3l4j89be0q9tm1gQnuH5PromlrCiPR4/nrg67weWLfiN0M+uaYpQNacjCkh+
	 g+G29chbogcDCTSGyLBYn2A0b5DGmhrxkNzYIfWxzmKDL0c96m5+Ia5YlCSC/kw39e
	 C+SDDZTbdOUeTGc95q0Rbc2mPncZYH6jGbvfdwKsAke6Qi0IxqrllwEc+J1jHuMPBs
	 vpQqXEfrI7rgw==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:16 +0200
Subject: [PATCH v4 7/8] dma-buf: heaps: cma: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-7-e18fda504419@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1869; i=mripard@kernel.org;
 h=from:subject:message-id; bh=XD1ohQhO9zZA1+h5cJdCf8noqsv9utcIYdzdurGWIrY=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZxt2/QrhDmEWnJyuEZ53bFn8sXkc/fdfaT1zvGv9R
 LA4sj+hYyoLgzAng6yYIssTmbDTy9sXVznYr/wBM4eVCWQIAxenAExkoTZjw5nbW9wPGX2XvzCp
 NnIfb9ta1a19Tar+HziFhd6HPjo/df3qyE3LS7byVlas//HX8DaHKmN9uOtdhR0Ge1ts2rp1L+r
 Psrpy+l3A5P2zWGvPxGWffLW7YLeUjuTjde96utSmCZ7/spcJAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6A9A4001A
X-Stat-Signature: m6c5zkmbaw3564j787qo3xxju8knrudw
X-Rspam-User: 
X-HE-Tag: 1774951242-476924
X-HE-Meta: U2FsdGVkX1/znVYBr1L8+qevq3jSKOvlJqoG98GSZWbYGNEkh7onYWpc1khRm1R5mrU41bGGDDKOz3V8j5JjZUbre54InS6ECUs8p8+9Y/5T6UpJK9SqjweeSbI79mbbOeJBnrmsMn3OpCvPq8TFiAaO4cT00h4NJniXhK4AdcfFaMr+2L2bzFKD9JNaSAcrJJoVgIUsRp1Roa/9ZpZ3nMTxQ/8dc25/UuHfpNmh9bbynHl9etBweNH5Se8K0qAR510+OAkQ/z9i6TOim/H94ievC7oM+yAsBuLrNJADC6HYsbJPO0yWY9p03DRr7/ae1cYIezJzlRqmhpumf50xN8W04sGofss5mzrWsLjfH0lUhYmddJ+DFlcInHplsefJx8tza9tJJLyTHpVhd3ifwZZCvGO8BVl/pdFF8w+DA4jxHGeUL+TsGFrV7d0NL+BZXzK3XHvP6fOua52DH2ymYGsVe5ALkTVvx3xOSuhJ8KdGCO4sFKdfBudbOxi/a+G2PjgwyT2kzfV+rMOt6oCbZ2YOnPDH1AYPRfVz3zYK0fCv+hLTY1pwrqq5zg53THFqxoTdnILd38twjojPZ8Tr5RdvpiCIgI/5G835LDfFfs7cPYSH8UKikIUEp+CWruHtv3uteGo3V/K3I7hRL+It+N8O4MxwgnxvwKuNajhGL3qV3KagxOAd/Bg3q7AH2WihbnfhmbfjPwZUZSPUTG8EhIIksi3hi1OF0MUuMDGeDntOeOhQfIPKCgdqo8mRPWRqYJY5MifoNG0GkKAkVhSWwhAhcywzaW0/uVLKHhkB0zj+jPv1XeDdntHriraZNuO0i9l/ZR94jYvs9d2r6sHYCxq5YKc3BmJloq9DJVhNU3kW18qZNzfSTkLszwXymk/Zi7Ce30rV23lcg3fBL9Li/rw5Vtn9Pu86zIPIRB7EgRwEgUc663WF9f+OKwfLLUJJki98d0xB081393MbjKo
 enR8tfK5
 ZyNAgS/WboeSSq5aUxFXSKf9SrUxyqOArMxU2lC614oWj4pWZpCXVhsL2sSFs3wml4IVs3eXboqftxlJvj5YyWxCFBZh8u7mjJgG1o8vknooB8zHzy+GyLiKJ3O5ZZZwtlx841pDz+WHZT8vs5NAco2X7R7t4TrTPzlo8W0rH9thHlgYmKRK6hPXFfvbT0lqZl4/YRDRrWVEgdoJgGFOrvoCAbbXWXwreqza2H2onlQRDoncItlxw69dVvrHcseMc9BMsRTcAYk4/sjw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the symbols used by the CMA heap are exported, turning the
CMA heap into a module becomes pretty easy: we just need to add the
usual MODULE_* macros, import the proper namespaces and change the
Kconfig symbol to a tristate.

This heap won't be able to unload though, since we're missing a lot of
infrastructure to make it safe.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig    | 2 +-
 drivers/dma-buf/heaps/cma_heap.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index a5eef06c422644e8aadaf5aff2bd9a33c49c1ba3..aed0b9b4febf388376cfc41be9843980d010c4e8 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -4,11 +4,11 @@ config DMABUF_HEAPS_SYSTEM
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
 config DMABUF_HEAPS_CMA
-	bool "DMA-BUF CMA Heap"
+	tristate "DMA-BUF CMA Heap"
 	depends on DMABUF_HEAPS && DMA_CMA
 	help
 	  Choose this option to enable dma-buf CMA heap. This heap is backed
 	  by the Contiguous Memory Allocator (CMA). If your system has these
 	  regions, you should say Y here.
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index 33cac626da1198e3c4a1cdcd562223c1924b6ceb..0ed519a19da455df7441396c96934a107fd72ffb 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -421,5 +421,8 @@ static int __init add_cma_heaps(void)
 
 	return 0;
 }
 module_init(add_cma_heaps);
 MODULE_DESCRIPTION("DMA-BUF CMA Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


