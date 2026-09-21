Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE3BC982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:50:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134576B008A; Mon, 21 Sep 2026 10:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EBF16B00CB; Mon, 21 Sep 2026 10:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D626B00E9; Mon, 21 Sep 2026 10:50:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3D0D6B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:50:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 701A1801F6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:46 +0000 (UTC)
X-FDA: 85238056092.11.4D05D05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C3E7E40005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjUxmdmq;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siS6q1O96r8tBJzuPFNLC7opJrdAHxEvYaTkWIfgUUU=;
	b=N4ORojbh53nLxYwL3AaJm9d1AKlf98giqvdWy7sUSEjNn5uXWuDVAvhKBeG2dPu5y8mDXb
	lqz9wqBHY1o08ldcwdPTjmkCz49xOGLvJSKf3S8czfqKLUV1ZsJB5+hCkozpuZPnyoskWW
	XXT2F/7Nck+fqRZ/4AN5ftbj88Jvqbs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002244;
	b=cYAhwC3ayu0Mbol5lF/AXrqzAG1qRXERjGMu4f5gKk9vzBd85PDi9ia54ToJga/jK8QbDl
	m/a4E8Pq+FpdKXbgyEu2gUW2yfUj/TW8PEXdu3QVRd64BOpa0buED1lKUMXl7LOYo/2VRK
	jYV7FSmJJo0mvJ3+YRTgJDudn4AsXWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjUxmdmq;
	spf=pass (imf11.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E8534013A;
	Mon, 21 Sep 2026 14:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612241F00893;
	Mon, 21 Sep 2026 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002244;
	bh=siS6q1O96r8tBJzuPFNLC7opJrdAHxEvYaTkWIfgUUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjUxmdmq75evpjC4UkLaIYo0hP1XgCpj8SoLSF8Mj/tcBn6ZXbtjFhVAaKSTA07Pz
	 lcTzehyS2LIa8dVZJu0DH7jWgBEqhuXNdci/JIOQjepi2K6XsYv9W8nt+AQOrN2R5A
	 GwhI+wHs4GccO3WeI8bWmNcjtBIETFgcFnkfcJJEuwLLSycNBG1sqPgI3051Zr8kZ6
	 U97zOFM3SrsTI1AnQl5GJtgARF76druhEyK+73UdsBpZrzCA9fClz5xVqiCrtuMxzV
	 w1xa4hEs4oNB/M+V03LS2ikLG8NnJCu3G2/YsWbURiG3Y/RuHL5MIzUGNI/ccucgQc
	 T9CCrMe1mJY2w==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 11/13] dma-buf: system_heap: Limit scatterlist entries to the buffer size
Date: Mon, 21 Sep 2026 20:18:45 +0530
Message-ID: <20260921144847.501151-12-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 78zwhw5r9xukcot9b5k18egf1z6z3eu3
X-Rspamd-Queue-Id: C3E7E40005
X-HE-Tag: 1790002244-300067
X-HE-Meta: U2FsdGVkX1/zcR/8f4ReUoFQogi/YUla8j4e+oq8VNCB4Wn1/NxkcbNOIBXzsNnCxWrd8f1xw7sRNbM1lO1/rdN+gT+P7ZTfs818adZBXQ1bq1+xUNbB0e8QYKe+Erz63952sWyvYdT9Ri9jq6/dOFuwxkl2DtQRSYtsVh2OEXWgyT4bwUvUpn73ImlbMVjc8/+30W8zmscSfABoKWmGFbZ9TpCTUg5I1FaOA9UGkZKBLn9LPn9s79Wj5RNo92k+cbHDML0XhzrB3/oCE/6tR5CRgnr/Dqitu0Q+8v42rmCF60T3YKGBNdFkXNzbQeE+cS3DdLjIyEurLXQcCHWDT8JgyhCAOlD+8Au6lYzi6KTPQBrz6ZX3CJUMG2q6G3wGVRSaxqKcRUpodHzhxrRpWxv19N7fX8VJ3U0A2nrucYgntpLP0uvVXU6iNqGCSUyWDg3e0eF13r+OtDhhtADyfpmVk0xxenOR/d43KFKDABfZlckulQV2XlBJQgTwZ5RDYmoOsF3r4S8hp0qa2o5NWrE4PmW7jZx5aE9+aALHdwwKeOk6sxyz+zeRap6vSsPqbR5gh7Yr8KpeMd77d90FfO6ukNDx4xfL7TZR2Oa0U+3nyMKa7XVt4aVvinknjxDMsiUlaXcg7W7a6foLsfvOa7iGljt98BTXOTMKRgZTpQjONzQxS/IRkT17lhxmA2srH9WaMLQWQW3EkmRXFV0bX1P4e9T/GJYbrw+n16l+GYVxdhMbE9oAS7H1cUDJeqA5iaDqYRCpzuD2kQFkAYs6E6wVY7u0Cqmq1KUWL8tLbGvsR8r+PRDNVxpKpZqPKawaGfweLdvzQVehZg1FLtWigaUPm72P0in+APBTrP20d9sqk0kVgsVnYMC6YpWDXBTAybBT3WOIgIpUirqINoiwbvPWnJFBggOQqWwaNBa2DoXXqPOM83FzVHApOvNNqHzfzh0o/0eTiwjC9aGDBhb
 mTvdZLBm
 Leqc4B5JpqElQ4OWcD6zJdtoQz68Hsz/d800JJ6pGS5ken+mtnYx0spqZ8ydXWqjt4HFMZdrz0Mi0CrUm3I7KI5wDd7orWnPPOIuTt74CT/U8gDg6mpcF15f1TPf1U0eJF6QYKQyDZZZpQYZIKWRRzl6VvT2lGoSaNmP+D8AbkqO0S7T430u/qEUO5XzHewkeoW4Uu7bg/7M//uFB55n4Q2mTWwMUpqb9xwYQn3gs/3jtiAfyQtpA/IiZTlcKzwN80IHvEF+adZG48DB29ujrtG7RSYWRJzMAqZdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The system heap currently allocates each backing page no larger than the
remaining dma-buf length. It can therefore use the complete
compound-page size for every scatterlist entry while keeping the total
length equal to the buffer size.

Shared backing allocations may need to be rounded up to an architecture
shared granule size. A backing allocation can then be larger than the
remaining buffer length. Describing the complete allocation in the
scatterlist would incorrectly expose the rounded tail to scatterlist
consumers as part of the dma-buf.

Track the remaining buffer length while constructing the scatterlist and
limit each entry to the smaller of the compound-page size and the
remaining length. The complete backing allocation remains owned by the
heap and is still released normally.

This does not change behavior with the current allocation policy, but
prepares the heap for shared-granule-sized backing allocations.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..b5b8cdf65f23 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -406,6 +406,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	unsigned long size_remaining = len;
+	unsigned long sg_remaining = len;
 	unsigned int max_order = orders[0];
 	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
 	bool cc_shared = priv->cc_shared;
@@ -454,7 +455,11 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 
 	sg = table->sgl;
 	list_for_each_entry_safe(page, tmp_page, &pages, lru) {
-		sg_set_page(sg, page, page_size(page), 0);
+		unsigned long sg_len;
+
+		sg_len = min_t(unsigned long, page_size(page), sg_remaining);
+		sg_set_page(sg, page, sg_len, 0);
+		sg_remaining -= sg_len;
 		sg = sg_next(sg);
 		list_del(&page->lru);
 	}
-- 
2.43.0


