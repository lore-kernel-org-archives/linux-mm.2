Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DBD01061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CA36B008C; Tue, 31 Mar 2026 06:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23B86B0095; Tue, 31 Mar 2026 06:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39B66B0096; Tue, 31 Mar 2026 06:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B27A06B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DB30E16F0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:24 +0000 (UTC)
X-FDA: 84605913168.22.CA90EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8042F1C000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ss2nXoTT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nJBWUowhXuuE85TdNa2zR+egXPHe+6mZoFcItGAcCJc=;
	b=W04ohnsyvJLS3XpWNq3LD4CbxbYERuYlcZR3oPhC3ntRf10Vr5QVQwJvAfVhMT7HKAvXVs
	ar35DpFi3eFgOg6io2yBB5ru4HcED3EVRQ3psvX3fCkfnl+VkzCaR4dq3wWHqNEv+gZm2K
	pXmQmquYKV70/9ueR0w/fVDo9av6Ow0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951222; a=rsa-sha256;
	cv=none;
	b=hel6XwN3A7sduJCsk6GU8Gaj/q8ZQZXrCDKzX4f71RwxT54jw+p6AqdMe3cw1TlMH1iHBO
	YuK1J+QDh4x6EhLJwMVwpERpNRJSzRYDhtsQx1SbEPXANoKMVGXpVcy6ItcU4itWc1v+Px
	OHbu2B4pBRLqOUC4kSFO8x7sBPbbcwA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ss2nXoTT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C4B8760121;
	Tue, 31 Mar 2026 10:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3DBC2BCB0;
	Tue, 31 Mar 2026 10:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951221;
	bh=NmPYacRlRMgDK6wlfQdVkWEvsfihThv4t5CQJjQ7Y7I=;
	h=From:Subject:Date:To:Cc:From;
	b=Ss2nXoTTqQTPpFf+vd8KL2TOHaj3gYelQORnJjYSaDskPaCsG/ahwxR5wQyo09pev
	 QyEsyS4gOFfegOmiVrVX41jQ1kJ8mXgEz1yDMzeH+1LykYYKx4+klu1Dxmxho07FAZ
	 one1+BWa39lVLE8FS9yHz48EUzN+8WFCQGli65jzK4ESyd09ULQ/ayN+8J1Zgr6s22
	 Hq1dL/OncUCyQuhVYvy/MACSqKFlizO2SoIp9uFCRVxm6cyOdM5dZ6CrIxwWwaazWW
	 iARNOAknbGwHy+620T97BwjBbRtB6vLJ3XFlG2X/w88YFvkuNwrGQ9E57OpsA48hGP
	 sDSIXDEMWJb/g==
From: Maxime Ripard <mripard@kernel.org>
Subject: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
Date: Tue, 31 Mar 2026 12:00:09 +0200
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43OwQ6CMAwG4FcxO1vTdQPEk+9hPIxRZFGBbEI0h
 Hd3cFFjYjz+Tf+vHUVg7ziI3WoUngcXXNvEoNcrYWvTnBhcGbMgpBSJEiivBoq+gppNF8AEuLZ
 lf+EAEpUuFNu8IiNivfNcuftCH44x1y7cWv9YLg1ynv6BDhIQSGIetwzmWO7P7Bu+bFp/ErM60
 LuU/ZAoSjrRhjljTK39ktRLUqh+SGr+SSutt5JshtmHNE3TE6FYwwtVAQAA
X-Change-ID: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2731; i=mripard@kernel.org;
 h=from:subject:message-id; bh=NmPYacRlRMgDK6wlfQdVkWEvsfihThv4t5CQJjQ7Y7I=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZ+vtyny391ST68fupKZOXg+LP5MLLv56Wdf4VfGRu
 aKiLp9Sx1QWBmFOBlkxRZYnMmGnl7cvrnKwX/kDZg4rE8gQBi5OAZjI7jjGhjMPOeZ5mJ7+U1+7
 xX37xEN5MWZqs+/M9C8X8bm0z/FoLz9j0KvsW/Pit7Gqf5wid2nGZsaGyfNf758uxcDkcvtFq+j
 R52FKkjJPNM+bFbHOO2xhN0OHoWLtsnPrFVSuunzRmHlE9U0nAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Queue-Id: 8042F1C000E
X-Stat-Signature: czswrwg3zhqiubgzmsi6ae6rspm3tzd5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774951222-63751
X-HE-Meta: U2FsdGVkX18ChtaThQlIt5ZN2QcDJckE8UobjbXpppLlKzbqEmj4cV/NKgjwuiWEfWsU1nPggJJo3m1Al0S3ekVpba6msKOULSCE7rh859o8pvISGTuU44PB2KYdCf6nFm3gVTHTyJMFLY7pNGtxqeBdEWBK9xB6HtKmm76m6Y/zLEJNkig2TndfZUtw+Ou7KYix22YOtyLF3z78xUV2xwaSGKTeQnNSlWZFOU1mgXwEaN2nhxz3oz4tmQREbFN/5y+bXMgE91h8xnwIvX80lgO/dbEdEGsvmXtq8gN/An995tO2lALil34jOjz7amOGo56VJns+bkX1TcK25+VbNGzhFAZdtdi/qprx53yXz7xhn0P5Pj3dQL1wnZkaONmubC3Eo8pFJhghi7YZvyudfRnZzVXj/LntfUid/Bn3R6qu6WTNQk1JCLOrLk2vZFtWMxDI61q2ab+mTjYnQrlIe86O4V6yBe13ztKe6/dZdjnE0P4doAARZrwhwwO2u1ikMasX0xl0Ky2jIz/qzJVVGHzClButlEIDCEVB0PSQ+63VXGsxyAtMAvWpa5IsA2rQU4dOqBVZ56Mx+1Ir87mRDuQFJ1kopCjxqvQ7elA7HftTZcPkP5yID5dUDYSVGaHJHc60vicwOjuNlzRDkuFPkEO+6XA1eohSZ9SIQ371+PDvxa4gptBuDI6EFl262MQjIc9wUsMCXXPxJOst157rAQF5juZtFL/0JH8G1eK35sEtkuVV6DFrbofANAJlALAvj+Gr8uDsip3BsV3DL4zE3H51Krzs89hrhgLh0iWEUPKHPKmScZ0DuXfUSxqDLbWPx6u1WBF2XrvXi1JnHQykJU26p4Aj39bcGoywWrhaRdwhfHoL0lJsqtlvehQZ/aTClrWTAlb0JOdZf2sOUJrB761k+T4IkyjBN4YvjiwMjEVklVwfOVG0Q2p7niQ2PetC/sibepRfONVNxezwtL3
 rEdMyep2
 VvQwGqmdCu4VBY0l6TDVcStk5wQ67vWu8G1WnK7VVQOpSvvVtbjzOtDV+6/7s6YQedjrMS2mjHEraoNnGM3HfmWXpSia1s/UCfa7kqvl/yIjd0QAoCTyWuhaUgraWNVLYnbUWNB1BvEEFGMhHhGOTET+DPuMosQdqT+6vlQHMCoPZOM4jbMAclsruX+34mQYLdkelo+qC2rm2auH4Cu292F6YN+COIOyQ/p8leBoPAoxlu/8BrlFxagKhO+JLirY5zE53XD4MWYTCP1xit+TjMJiOEOZltP8TOYzfiwDpA9gY7rn+oHKw+MmUSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The recent introduction of heaps in the optee driver [1] made possible
the creation of heaps as modules.

It's generally a good idea if possible, including for the already
existing system and CMA heaps.

The system one is pretty trivial, the CMA one is a bit more involved,
especially since we have a call from kernel/dma/contiguous.c to the CMA
heap code. This was solved by turning the logic around and making the
CMA heap call into the contiguous DMA code.

Let me know what you think,
Maxime

1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
Changes in v4:
- Fix compilation failure
- Rework to take into account OF_RESERVED_MEM
- Fix regression making the default CMA area disappear if not created
  through the DT
- Added some documentation and comments
- Link to v3: https://lore.kernel.org/r/20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org

Changes in v3:
- Squashed cma_get_name and cma_alloc/release patches
- Fixed typo in Export dev_get_cma_area commit title
- Fixed compilation failure with DMA_CMA but not OF_RESERVED_MEM
- Link to v2: https://lore.kernel.org/r/20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org

Changes in v2:
- Collect tags
- Don't export dma_contiguous_default_area anymore, but export
  dev_get_cma_area instead
- Mentioned that heap modules can't be removed
- Link to v1: https://lore.kernel.org/r/20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org

---
Maxime Ripard (8):
      dma: contiguous: Turn heap registration logic around
      dma: contiguous: Make dev_get_cma_area() a proper function
      dma: contiguous: Make dma_contiguous_default_area static
      dma: contiguous: Export dev_get_cma_area()
      mm: cma: Export cma_alloc(), cma_release() and cma_get_name()
      dma-buf: heaps: Export mem_accounting parameter
      dma-buf: heaps: cma: Turn the heap into a module
      dma-buf: heaps: system: Turn the heap into a module

 drivers/dma-buf/dma-heap.c          |  1 +
 drivers/dma-buf/heaps/Kconfig       |  4 +--
 drivers/dma-buf/heaps/cma_heap.c    | 22 +++----------
 drivers/dma-buf/heaps/system_heap.c |  5 +++
 include/linux/dma-buf/heaps/cma.h   | 16 ---------
 include/linux/dma-map-ops.h         | 14 ++++----
 kernel/dma/contiguous.c             | 66 +++++++++++++++++++++++++++++++++----
 mm/cma.c                            |  3 ++
 8 files changed, 82 insertions(+), 49 deletions(-)
---
base-commit: c081b71f11732ad2c443f170ab19c3ebe8a1a422
change-id: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a

Best regards,
-- 
Maxime Ripard <mripard@kernel.org>


