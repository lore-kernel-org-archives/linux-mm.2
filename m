Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC8BB1125873
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4266B0095; Wed, 11 Mar 2026 15:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1756E6B0096; Wed, 11 Mar 2026 15:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0952D6B0098; Wed, 11 Mar 2026 15:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0F286B0095
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C71C71603C5
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:26 +0000 (UTC)
X-FDA: 84534720732.24.7C239A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id CFED040003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbG1uNUg;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3hCjNE0PsuKFI31A90NZYstBEHm4rTAw4KXiGv2wWw=;
	b=6LQ47LF6YratVOM9Wa188G5kwcQGPCA8rvT2uPk2id1RwRdS706UeGqyi5X/WzvvnuvRoC
	+Hqu5pGNKdUm6XYX3fnxsMUpHD+NSZ62iRC5tiqfeaxcxyp0BDkZ6KBobnM7NGj9nZ+7k6
	RnwsB8RLEdYIQay2uzVrwrhm+3RIw70=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LbG1uNUg;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256165; a=rsa-sha256;
	cv=none;
	b=uSCEUqAoUJ4EdplAnhFs+TcobH2hydZWk/4qNeZejhU/l7frLCTWqGzvh69UKr85MsWAYV
	DKob5156jhHkJFo7uWHn2sw9boHX9qOl3VO0nsosWoRwyA7Vq2+FybH7x4tdklAM/zoYjK
	44TLGI8B7DnrUn1Srh80w3hX4SP0Ay4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 015B043E03;
	Wed, 11 Mar 2026 19:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11621C4CEF7;
	Wed, 11 Mar 2026 19:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256163;
	bh=0UoS5bXBagSWSjZg7zeW+3A+vnJkjeQqWbOv9i9THFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbG1uNUgq/sPRE98pW+ZT3GTFULJ3gWkdpAIhlzPdLfdX5pxbYb4ITlF1lhbKP6iq
	 MQghWEVT49xo+z6Jd1VwWinJTQF25MNokpn8ET2N3EwR8syaKhSSHoWafZm52xyvQM
	 0KkhwoP8HpVYEKOfw6TefQuqKlcbeGxQQdMP7j/xhwru4WpEu1Rq/0kN0tmpmcvwCU
	 K2zLd56Qbc+IV0Qp0sp9JYawQz8u83W38bdwA8Pab+Bwk2cIXDM+qCJB+/qWhFf4sT
	 3aEVAVELkWJ8vkKSvt+0Kot1TRelXPsq7crc7VKcS9VDPgF8WwzsW+jpN/wXdaYTuh
	 MNcha2q9yYS6w==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 8/8] mm/hmm: Indicate that HMM requires DMA coherency
Date: Wed, 11 Mar 2026 21:08:51 +0200
Message-ID: <20260311-dma-debug-overlap-v2-8-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFED040003
X-Stat-Signature: 3ey8w7ef8yrptt5nxfuqq4ow43fcgzfi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773256164-565639
X-HE-Meta: U2FsdGVkX19USpLUEF2aSbOLykjvnPY/xY15vjAqvM/jB1uYVfd3rDEZ5KDs1+m2t4yPycYERTpQIBHzWKepceubj2O6siqt5HY+BXlB51p4YXjn5gH6hEIfQ29xN0kU9IvnU39TiMww0YEfPHUloxgPeNg9JGffnJswwCxHTUn7ZIra3E3vWIkoJx1KOP50iXfHvBaw0elS4/Cs1snwdOr8vFLdxWOg/qTCbDY9S5i0CaK79LVINAAuVzlzsVA/ccJ9QsWLBX7ubBkmweqHbTFar6USvUVsm0dTr2EOxDcTIgLfDeA1ly7CVqhvX1IQYXWS45CfIOV37Y8jTei3m04wT3UTyvlpzl3ZCd26XzT3lgE8tPNe/TDF6gT3HAHwjXZgBHJ/wCoDYPInT/UHUYiWUJbsDrdF+AMbzGh0Vc9nvWwxCj1ICdPRP14GhUmhiOP2K8lfe1QDtvIJs54c32iOkM/3LZdfne2P37nhW7hiC+VdGSYzMX2kPNLsewkB6LvkOX1kT8JbackxKEA2vyLt58Nj4U0LlcIctqjFZASx2AJPNxr8D9FEitmgug8DtaYZwiBhFGxPeVmTO5dU5t7nvweVSu70rnJmrz3+fBnWsJFiT2KDBnFXaCaMYUl3RNBJkFQrT9emEtUb/hih93WNRIJ/YyQFxTIbughLPTfYWOy1A4NiFUp+v76HhkcunXFsTYQYDznaG0px1iyyKfnNklogt4QiMDOO3Drh4whOYYsTJpbkuTeP9oAH86XpsjTPj+y1NK7SkHdF2RDzoI+2Z1xVyk+iw/xmFsQjyW1iurQdo9U0bsEHakpFWxMcQa+Xaw7kq1Yabo2DfObKetQLsLReB3n5dqPUd0fvlx0juOlnf9JohTBcd2gUpj0AgeAnxgPvT4m2M1KRXMfDRlwp/uVjkLdOZE/2zLrq2B5L2pWukvBhIvV8eDO9oxelLnl2EvXR6Bwf93d0A66
 j02OMGhG
 weLNucfUsfgBamtWC4isTaaJ3kzT6vHkLGxJpe0Q3dOIoHDpjm5NJvFL9/LbyioPvF6UUc3meeLnus8J++s3FCMTV7pmQe00IJ8Ga12HjS3/2v2mPORRwOq4PraSa4RFtGvAwMQpv4LACmG+apz6xPmq6/DVnLRfbP+RXrKLt6Qyxe3UW/6IwXYic+PwQ4aQYSUZ0nSYh1xtu5kQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

HMM mirroring can work on coherent systems without SWIOTLB path only.
Until introduction of DMA_ATTR_REQUIRE_COHERENT, there was no reliable
way to indicate that and various approximation was done:

int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
                      size_t nr_entries, size_t dma_entry_size)
{
<...>
        /*
         * The HMM API violates our normal DMA buffer ownership rules and can't
         * transfer buffer ownership.  The dma_addressing_limited() check is a
         * best approximation to ensure no swiotlb buffering happens.
         */
        dma_need_sync = !dev->dma_skip_sync;
        if (dma_need_sync || dma_addressing_limited(dev))
                return -EOPNOTSUPP;

So let's mark mapped buffers with DMA_ATTR_REQUIRE_COHERENT attribute
to prevent DMA debugging warnings for cache overlapped entries.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 mm/hmm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index f6c4ddff4bd61..5955f2f0c83db 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -778,7 +778,7 @@ dma_addr_t hmm_dma_map_pfn(struct device *dev, struct hmm_dma_map *map,
 	struct page *page = hmm_pfn_to_page(pfns[idx]);
 	phys_addr_t paddr = hmm_pfn_to_phys(pfns[idx]);
 	size_t offset = idx * map->dma_entry_size;
-	unsigned long attrs = 0;
+	unsigned long attrs = DMA_ATTR_REQUIRE_COHERENT;
 	dma_addr_t dma_addr;
 	int ret;
 
@@ -871,7 +871,7 @@ bool hmm_dma_unmap_pfn(struct device *dev, struct hmm_dma_map *map, size_t idx)
 	struct dma_iova_state *state = &map->state;
 	dma_addr_t *dma_addrs = map->dma_list;
 	unsigned long *pfns = map->pfn_list;
-	unsigned long attrs = 0;
+	unsigned long attrs = DMA_ATTR_REQUIRE_COHERENT;
 
 	if ((pfns[idx] & valid_dma) != valid_dma)
 		return false;

-- 
2.53.0


