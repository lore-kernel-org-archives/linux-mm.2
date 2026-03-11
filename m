Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4209F1125873
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 884526B0005; Wed, 11 Mar 2026 15:09:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831766B0089; Wed, 11 Mar 2026 15:09:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712FD6B008A; Wed, 11 Mar 2026 15:09:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E88F6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1AEBF13A752
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:01 +0000 (UTC)
X-FDA: 84534719682.07.85C467E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4DB6A80012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:08:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb4QW1PQ;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b4snO5B/qZTn5+7j9yWmcTPfa7RkcQ33t04AQ5OS/Xs=;
	b=2P6w1chAlSrJ6HhvHmjJkvvQ7upEnrHMiul5eTg1Htkek4faEGa2EFKilmROAds5uDoPba
	Kbkn4QEJZNnetDS3D0I/tpiakIrnEUs9irWdgQ3O+e6aniVo7S1CgToCLx7Wp/PdGITAhB
	fCaav06AUlYYvtrw3YZLWV4E24vgGKU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nb4QW1PQ;
	spf=pass (imf02.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256139; a=rsa-sha256;
	cv=none;
	b=qtAbTH/V0S1o4SpFrbV3zhe9yGMvClo27Yhm8X3fMU5piEgt39i++FbTMGCWyPReCe05vW
	s1dJFQb1ALaKQJkvckud6aiGwiJHZsYd+JE1kqDx5K82x7O9ixomUcqPsdHqQUkZlzIPZD
	LSYrHkty3NNBT/q9xA6oTU3aOUb+2hQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D92E43439;
	Wed, 11 Mar 2026 19:08:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851B1C4CEF7;
	Wed, 11 Mar 2026 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256138;
	bh=f7E3DQ4/Vk970iebVcsUS/bkixZlPLpqM/qiyDK5W3U=;
	h=From:To:Cc:Subject:Date:From;
	b=Nb4QW1PQGCc2fuhrBudNL68gub3pnJT1NUoZY20WoiF06/aAWkB0JKBldKjUQbcRt
	 nDYj2YYMWFjAY7olA0WlQoBI4NSNuyOjPJ75Bz2oxkhP7am4qxvXzeWiyyVH5vDH9r
	 lKR1FEnE1nYADxDgwgP14Z9yf6E+MVHsrijqzElNoggbAPxZnGB6pg8vPdFIMuz5Yw
	 UtnoyNdW4/fqY7gaYkOX/Az/87C7pEWxS/GBeDwt/47J8Ba4kioTIIzhXOgywbmIZC
	 bQCr8sOvI70l79lbyysrSMvTOR5WpM0ykLLg2lpiCyxRInx7Lq0qFAoFt/Z8C3Uuzm
	 1U2j29BEVTnHA==
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
Subject: [PATCH v2 0/8] RDMA: Enable operation with DMA debug enabled
Date: Wed, 11 Mar 2026 21:08:43 +0200
Message-ID: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260305-dma-debug-overlap-21487c3fa02c
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DB6A80012
X-Rspamd-Server: rspam08
X-Stat-Signature: cdo4p558we1goyug5qm1oqwexiej5cih
X-HE-Tag: 1773256139-979844
X-HE-Meta: U2FsdGVkX19E47o6FfgN1++CbuZd8fbq/fxzQv6swTU/MBHCKPA/54ZiQ7etSSAFFJ9inaeUrq7+RBeYmtIbjPSRkTG0tCFZ5XR8eEXhZ6O9yVq9EFj0CAI8hfrXNZDpU1RC3hm09y2apUiS5AkfeWV1iahQiRBOkScVG+5gchYajD1sr6snFqgVTtzYehz0Dr18CHLuIhdBD4imjN+XzwlagCr3SZfhiBnlyh6tQtfvSjdtDvBoTGlCUvwzF9v+ZK94aIJaUabJyjqnnRNgORIfSn/wnY0gl+WMJJedItcfxGBd2upKak9eJeX0S267zVYSpTn9FUFWHalf6geOSrw/P7TZNBpP4s809CdtgVWytXB4tCrCvWgICuwwUt66eVrjcwSzm3L2rxerO4pfOO6npblvhQTBgARJJEmAppvZ1p9ehL57q1djnGLxnq91r/lKbXHzBGyBjEVl5FKiCUCFqCEF7Zi6ufQ4WYCAPMsjPgN344uRpjRLF3TcD3LwnFgyHbhYp+nQzZdq90lnsHvNRlOMdfImIn5VgoPnjsDlyq2zWCBh++kZAAth1u5Dq6Y+pdIpJ6bBwCKK5nAmsCzSwj0VU6TYqYpkp+35hGg8tfoRD1EpLLiHWFpIz9ZezOuWA7/UUVA36Iom0VZlCDqh2vki0cCpw6CW8OySqKDd3hm8/cNZ65ty63/IG//95HMjgcNvzxG6YK0/u2x8+8OKS2xRlpzga44TojYb9LRMsD0bQ6o38GPXDIqJrImAn01aVguMkTe0EPXaqu0QloF35YTfjNhhOc8ZZHqyc4E42a06DC4R6J5SXnmaUhr7IrB2HNb160R97dZRSYl4yBuxsMRaVpaW1JiTynnwS2EFoN/7o9A36na4P5QDuOiDHeF8WjPuRgZrdvhSaQV9ZA1RxdQ/cD1Zr4ZHI6M3CiOrh1So2NE2rpdTKLwvYmTZbqgg6W54xYOPU/t9LMV
 V7nxT1Bp
 cbFZLlvcizPB6O9FEnITNuB312t7U3xgLf3ZVGAFbbnRupa76HoB6kqyFKna9xlL//kwJprCUHmjCRLiaG2WPqA8B+nK7/6JWXEnXzmtoHtq2iyRdBujXWq0Zmwo1D3L+MyIBzx6EHwigVEioKhViaaWBupo6MJ4ME5VQXSyAQI8rTggqX1jerw5fuJ9BNXnVO7BI8SvF/X6pUbgoAto935mWdRIL3iz8ULrMbCHjk+5TUq8lCX3L/eT5Hbued8JWXG8yrP7fSdD3RVG+RycZMnZoRUan0nIbAcs8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new DMA_ATTR_REQUIRE_COHERENT attribute to the DMA API to mark=0D
mappings that must run on a DMA=E2=80=91coherent system. Such buffers canno=
t=0D
use the SWIOTLB path, may overlap with CPU caches, and do not depend on=0D
explicit cache flushing.=0D
=0D
Mappings using this attribute are rejected on systems where cache=0D
side=E2=80=91effects could lead to data corruption, and therefore do not ne=
ed=0D
the cache=E2=80=91overlap debugging logic. This series also includes fixes =
for=0D
DMA_ATTR_CPU_CACHE_CLEAN handling.=0D
Thanks.=0D
=0D
---=0D
Changes in v2:=0D
- Added DMA_ATTR_REQUIRE_COHERENT attribute=0D
- Added HMM patch which needs this attribute as well=0D
- Renamed DMA_ATTR_CPU_CACHE_CLEAN to be DMA_ATTR_DEBUGGING_IGNORE_CACHELIN=
ES=0D
- Link to v1: https://patch.msgid.link/20260307-dma-debug-overlap-v1-0-c034=
c38872af@nvidia.com=0D
=0D
---=0D
Leon Romanovsky (8):=0D
      dma-debug: Allow multiple invocations of overlapping entries=0D
      dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output=0D
      dma-mapping: Clarify valid conditions for CPU cache line overlap=0D
      dma-mapping: Introduce DMA require coherency attribute=0D
      dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is se=
t=0D
      iommu/dma: add support for DMA_ATTR_REQUIRE_COHERENT attribute=0D
      RDMA/umem: Tell DMA mapping that UMEM requires coherency=0D
      mm/hmm: Indicate that HMM requires DMA coherency=0D
=0D
 Documentation/core-api/dma-attributes.rst | 34 +++++++++++++++++++++++----=
----=0D
 drivers/infiniband/core/umem.c            |  5 +++--=0D
 drivers/iommu/dma-iommu.c                 | 21 +++++++++++++++----=0D
 drivers/virtio/virtio_ring.c              | 10 ++++-----=0D
 include/linux/dma-mapping.h               | 15 ++++++++++----=0D
 include/trace/events/dma.h                |  4 +++-=0D
 kernel/dma/debug.c                        |  9 ++++----=0D
 kernel/dma/direct.h                       |  7 ++++---=0D
 kernel/dma/mapping.c                      |  6 ++++++=0D
 mm/hmm.c                                  |  4 ++--=0D
 10 files changed, 82 insertions(+), 33 deletions(-)=0D
---=0D
base-commit: 11439c4635edd669ae435eec308f4ab8a0804808=0D
change-id: 20260305-dma-debug-overlap-21487c3fa02c=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D

