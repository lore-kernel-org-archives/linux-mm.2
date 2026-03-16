Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4358F53D89
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1436A6B034D; Mon, 16 Mar 2026 15:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB0F6B034E; Mon, 16 Mar 2026 15:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E666B034F; Mon, 16 Mar 2026 15:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6B7B6B034D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C0058B61F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:10 +0000 (UTC)
X-FDA: 84552859020.19.077CC27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC31E1C000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWmygqKM;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EFqmlHjR3pDiI92cSDTfMlFfRYTkLuQ3NOkR1E8pGlQ=;
	b=ZssIHtjIo+ZgXq3phgkCOFzFPGIOGpWh9oIODOhXQ9AhcKieTqCC4xvEtxN/g7xbgd1DvV
	QXjEu+02fLTb3fneRMIMh9mwGtoVAT7FCA1dqfTCKHYSjlIYfFAsh3QWD6nNcrf7iRlhDo
	ITLHR1y53cCi17waXYYUDrWlr4wberw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688028; a=rsa-sha256;
	cv=none;
	b=YE/UM/LUry+LU/Kc+knfzlOB01OqGJl71vcQaxqiLaFqO1bXUVu7ak71FxyAxrHMw2d9l0
	S3Buf2PcAiOSkB46HNAUeMUl3jpINrK8JQWpM2z/k8Z8Awji5ZPs8CkbQ5U38alNM1JN/6
	lGlgW7NUo0UNc9Y3K3IoDRdd4HgrkFQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MWmygqKM;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4FCA43F7F;
	Mon, 16 Mar 2026 19:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25585C19421;
	Mon, 16 Mar 2026 19:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688027;
	bh=BSXcvjYYI+K8eMOu0kcX0bUqyqggIH8za3wTFUV/fRI=;
	h=From:To:Cc:Subject:Date:From;
	b=MWmygqKMf5IukIzyE0mKREyeicovCoeVR64iIVzD/t0+K7KBI5RvzMPxKz/LoHb7x
	 xOHXIZ35Rt6sF53pc0zOVPn3frwe6PNiz+hfwCDaysJ0ukJP5/95D+6yNtmBpk4Bbm
	 w6o1s8KKmA2UyWAdUnxBUfYwgJyG5hnjBpOjB8OK/7X3U3LXNz1h5XGezAtPbB3D79
	 eMEHi81CfmmIIyk96FzF+FY7i/uyjM1oGTs4oAYO9rXntJXyFZV3ez7eZpaJgqvH5M
	 uwSBnECwVz4eYc/YVKIJB8co//nPy4WwlgS8dBUToeWtn+SQS2G60403HC9Trukn0I
	 6IQCI2/vdISBg==
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
Subject: [PATCH v3 0/8] RDMA: Enable operation with DMA debug enabled
Date: Mon, 16 Mar 2026 21:06:44 +0200
Message-ID: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260305-dma-debug-overlap-21487c3fa02c
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BC31E1C000C
X-Stat-Signature: 4jw3tpsh74rztzuahzit3718nhgzknr3
X-HE-Tag: 1773688028-911439
X-HE-Meta: U2FsdGVkX19/Jpj1RXRP3ep8THfViymJGsoOhMxPfUPr/pj2cDUEhis6s/9iC5ehF0BkpD4JKQTJ2j0WrT87cA1OpQPUz0DEfQ9iI8uNK3I+N7Prc6bDOKKr5wKELKsxNDcb51+F6JGmfc8fidgPJ6soqM/VQqLZooBd4kCshfFlwxLA4VouX9Z2eymXc+FX3T2uTzZKbWiiS0DpXDIQExQAoXveBGYQx7bDFtq08HyTh7OZH+hyY6YX2Lb0/i7NXvwlnd8XODXtFFwXfeketHpYGgn/bWA9MerO2izm6ZcaJc/uPN8PBlqW2O85CP3c2CioOw2108WVhsq1F7TYSBo6F+hkSqmAiSHsaPdvzfSPgsvJHq6FRBn0dVCdti0ih/0Upuw/x23dUT4LBEsoK2cOH9B4L8msa/WNfZ59UaFJLNA3FRsX+wzC/VGHLXyA082zGBU9yYk7DnwuOSYLz8vC0ccTX2hyfhoI4Aed7iIAstMYrSqXfZ5GAu7ZrSUFQKCWeDCsa6YbL59+xv6VpHLL0LfvFcIs+3SDS7+uxkmciRlplSEUjzUpF0fiDZ6UWal7DF+rDSKHzAgOmuQy4C8rsibfmHFwi9ETcxTDWzq4fuUoV7RR4+kBvRqJt9oR7oHAlkdCyFEKghxR6f+QI8VWHPVctpMfQrccvTCQKxf0NP0CHBWwogk7FHSPYqLN1i6pFkJX8tGyCaoYeKX84GP/AysrbFVpUGuaFcxvffy+/XksS/MUmoVeAy+Flm/XdYJKSFdly6MCulgjwwZi5thd9fivrrvwOQJbSOYzrReHvslXQ/QMXog5Y+pQwKg3rSVMcsxZmKt9pHOFNPVDjni1HgMGr1QOqLYNHoNTjEB8xaAsplQfg/jouDn20z9Np2Dvp00tP35Yo/hdGUEZo8QsCxq3ICZZUD+5XhZZzUp54XTz57j46JWyiARK9FMD+YfemljD6NtbZhnWl51
 p5vd+Pyv
 x6/wwwOIbjpKSimJWQT8JQm8JLdwUPUf6HDAv80zM0fd/NCEXOWOXl7CrKGTy5o+4behehttuW1XNvKLqcafAnL0s6EUipKzkighNqSUJznd0YWsOk7HKrDMgd1i6HSwacsb3OIOkNqH49XW9aY2R0i2/WZ1Ozo2aHMcrYT0i/03TGx8AWVS0rsZkQHDTt7ef8IdBUld8ZXHe/L75k8qIuSuQJPbcZRWckT2hiSGKem2DLcRxLjqKoiNtS/b09RYcQl75+0/tZ92eAZt7AMy/W9O85ungxRUkxs8i3tbj0OpCG83zrhwXvL6Ufg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark
mappings that must run on a DMA‑coherent system. Such buffers cannot
use the SWIOTLB path, may overlap with CPU caches, and do not depend on
explicit cache flushing.

Mappings using this attribute are rejected on systems where cache
side‑effects could lead to data corruption, and therefore do not need
the cache‑overlap debugging logic. This series also includes fixes for
DMA_ATTR_CPU_CACHE_CLEAN handling.
Thanks.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changes in v3:
- Enriched commit messages and documentation
- Added ROB tags
- Link to v2: https://patch.msgid.link/20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com

Changes in v2:
- Added DMA_ATTR_REQUIRE_COHERENT attribute
- Added HMM patch which needs this attribute as well
- Renamed DMA_ATTR_CPU_CACHE_CLEAN to be DMA_ATTR_DEBUGGING_IGNORE_CACHELINES
- Link to v1: https://patch.msgid.link/20260307-dma-debug-overlap-v1-0-c034c38872af@nvidia.com

---
Leon Romanovsky (8):
      dma-debug: Allow multiple invocations of overlapping entries
      dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
      dma-mapping: Clarify valid conditions for CPU cache line overlap
      dma-mapping: Introduce DMA require coherency attribute
      dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
      iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute
      RDMA/umem: Tell DMA mapping that UMEM requires coherency
      mm/hmm: Indicate that HMM requires DMA coherency

 Documentation/core-api/dma-attributes.rst | 38 ++++++++++++++++++++++++-------
 drivers/infiniband/core/umem.c            |  5 ++--
 drivers/iommu/dma-iommu.c                 | 21 +++++++++++++----
 drivers/virtio/virtio_ring.c              | 10 ++++----
 include/linux/dma-mapping.h               | 15 ++++++++----
 include/trace/events/dma.h                |  4 +++-
 kernel/dma/debug.c                        |  9 ++++----
 kernel/dma/direct.h                       |  7 +++---
 kernel/dma/mapping.c                      |  6 +++++
 mm/hmm.c                                  |  4 ++--
 10 files changed, 86 insertions(+), 33 deletions(-)
---
base-commit: 11439c4635edd669ae435eec308f4ab8a0804808
change-id: 20260305-dma-debug-overlap-21487c3fa02c

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


