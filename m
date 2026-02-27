Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63672FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5166B0005; Fri, 27 Feb 2026 08:23:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957E56B0088; Fri, 27 Feb 2026 08:23:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CBC6B0089; Fri, 27 Feb 2026 08:23:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 696626B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:18 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E9E5E8C11C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:17 +0000 (UTC)
X-FDA: 84490302834.22.7C353FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C460A80009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A0uK8pIA;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eqZIsprykG8yif9JvFC2heMuELCT4DGDiolIroyb5bo=;
	b=3R0A5T/RNqRPl2Qi7CC59k9mFCdhIaUHtMnYWXV87yIpClls3wQexs2aJSlBpv1YnsdBT3
	SXYYRmc2zn07mVgJfDTMWaal88jLlcgdMpM48Hh4f5UdMGEzPfSI0HFUgNA9HvVeCRCcSD
	lcXGbneG7vgGxVXjSgGydhMMhjRbB0s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A0uK8pIA;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198595; a=rsa-sha256;
	cv=none;
	b=8GnOnMqIzd1ZsX6xOkr6Xfh5+pf6EEqxPbndAAX5EKyka6Oc3JbzkZdA0nlru661yt2OIg
	Mo26TpVTlEhWpHJHaOzm2LkBsoh6iQMvQJOtCV8AdLKygjM2Nj4a+CzdtShV070QZoH3+2
	yv6dwXaeBJtsbAqEHlDbc6mzZ9fwi20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 270D760054;
	Fri, 27 Feb 2026 13:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E885C116C6;
	Fri, 27 Feb 2026 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198594;
	bh=mjmT4w11Wfq0ynV+KWTaTpvGkSiB5WiaBYudNN248UY=;
	h=From:Subject:Date:To:Cc:From;
	b=A0uK8pIA9bybdYhTA2eIMWK2CKAddEEVXTlrKyNUFRgyjp5z61iBDziPXYKWc3qNU
	 BKreHJgju60WflwCbE6o7xZnoJgE785fP2GlTMNIe/hoRkGCpVXpE6X/O2d4Xcd8qW
	 juvytmljqRQZwanmzNSRn3oDghJmwgcGws5CRlXfxq2bz0JhKhaz8x0eWDZKMAYUEB
	 3zV+wWz3V4rR0DZCILuf0cRxPIkbLXFGlq2yQXeTQZAs8ycAW7iB/CsROzKdw8ntut
	 Q/Gfy3fkymQnzF1med4+NEilU0OpawBfP9Kde+FgZMOsuGeEYJEtroOAl3rbNMzIwN
	 Weh8sp9K9rpbA==
From: Maxime Ripard <mripard@kernel.org>
Subject: [PATCH v2 0/9] dma-buf: heaps: Turn heaps into modules
Date: Fri, 27 Feb 2026 14:15:39 +0100
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/42NQQ6CMBBFr0Jm7ZjpoCa48h6ERaEDNAIlHSEaw
 t2tnMDl+/n//Q1UoheFe7ZBlNWrD1MCPmXQ9HbqBL1LDEx8I+YrutFivbTYi50VreIY3DKIoqH
 8UufSFC1bSPM5Suvfh7qsEvdeXyF+jqfV/NI/pKtBQjZUpJalgtzjKXGS4RxiB9W+71+k1vmdw
 QAAAA==
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
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2081; i=mripard@kernel.org;
 h=from:subject:message-id; bh=mjmT4w11Wfq0ynV+KWTaTpvGkSiB5WiaBYudNN248UY=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ233vsYj5JpYrLbY+435oV9Ka1gWd/zcdlDWWzTkX
 NULZadfHVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAi+88y1hd33xXkmvXP4kfW
 seOxsrWpzodV8m4dz/OZ3jr3zwQvia6rj09/utFxY/nquMQwkyMPmBnrQ8PrZraVVhxN0j8UNqV
 J5qXU/XeWsjpCsxZ979Yr+RbSpL3TKIt5Lf+Px3cXcB/ycuYHAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C460A80009
X-Stat-Signature: wzmpjhz9851dsewathyp4omjd11i7bwa
X-Rspam-User: 
X-HE-Tag: 1772198595-310972
X-HE-Meta: U2FsdGVkX1/otQDSQiT5290ZXfSgGZD7tkdeY7pb7Yw4hIWgpfgMnJJiasXUoSGfmmABqoMZmMmh1kobFaPqKYAp2cOBA9V7aTIAMW1CEMniXDNgfYo5QOGsnNXXk1WKt8bBv2W21bJB85a7tS6pCybs3OEOzZjkcQfQ6GsvdlJUR8FbWISKkEzk5CBelh5xulUShhQAZC4TH3chnIVe8jaznedQNNys5sAQdgd/D2RzXd1R80/EOcN8BU2mn125Ir7jww8eamPrD/yFXaO46geNSKJz8I3NsrbOoES7qVq8OMHyTP6F0DXJu7BkimpIcTHOpiZtxkj9wwAy1tXIkN8/qTWH76e/vprvlBdtcBE32xnVmCeeX6/iv9lGlMAkzvO3jklcnpAiwRH69Rf1I0hCmTseGH+G/dMTXmqI2qg92mpIaQoA9TKERo7pEQW///KMXmliL+yrmTByhMV8V6GPXYJajP+7L2Kk0DK/eLng/TYEBGkfFZuHfYePAwHPstwDielJ64qPW4TCKEjc83HniD2Rh6QBqw6JLlNkjk6mog1sXxEQ/nUfNKBl1ncWwg4x9hFQgT47jahNNd8ziZxaRQYMkhMFIqz4dveeuRIJfRkd3zX0d+FmgZlnppgAznHudDfTKLYjT4nQ2Wrf9aCB/vFBQaDBdj4AJrlZQSvSEfjWV9CUUlpMPhAt3pLA27+vtGY403cWz06PbTZW80ixFAEjShG2XSmJy8iD0s056FNv3jO759YenBMiirA0Fk40WLKgJ9KmaSeALIsHvQ52z4Df2P0xLI6oKc5v1pEH8VC40P+G1QWODWhpmdfgOLbX5MeLAvlTFupBRwISnfTEZGizfCh765L6tDG8jRT9JFPSqDGQkZFmfaPREeIjTuxso737gp+viDjgLhXek4wvrCwf4HBQrvLq7XYAqoJ7KfDRsPBePbgNJolGdLUTNUvMKWZLN2f+YrSOG0w
 iH9alz8F
 jyQPvguU+OeBJ0KJtUwI7Q7R/V80nJ/+N/jVbW3fCVhxni1fF8Xvd+jEdfo4pcbpO5sSKZWzs3h1U4ZernVhKh21nd8ETDgafaLpHdrOcdTK/UH/cylr0p95wYRFfBdAutMEPRxii2KZAmqJjxcDvsigcgjCR6rf4SMxbJGawRCe8qpPWN/9G9PPM7ZQP7neaEIvtf6Q2oGeAjTD6IrI5K5FN4geoDZqfaWJfMeaj650+mxL5NAx/01v+6J1M9MxWRMASyXCaRiaZbASYqOguIXnnFhydmnXXmAw8zowTKtptsK0DriN90428yA==
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
Changes in v2:
- Collect tags
- Don't export dma_contiguous_default_area anymore, but export
  dev_get_cma_area instead
- Mentioned that heap modules can't be removed
- Link to v1: https://lore.kernel.org/r/20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org

---
Maxime Ripard (9):
      dma: contiguous: Turn heap registration logic around
      dma: contiguous: Make dev_get_cma_area() a proper function
      dma: contiguous: Make dma_contiguous_default_area static
      mm: cma: Export dev_get_cma_area()
      mm: cma: Export cma_alloc and cma_release
      mm: cma: Export cma_get_name
      dma-buf: heaps: Export mem_accounting parameter
      dma-buf: heaps: cma: Turn the heap into a module
      dma-buf: heaps: system: Turn the heap into a module

 drivers/dma-buf/dma-heap.c          |  1 +
 drivers/dma-buf/heaps/Kconfig       |  4 ++--
 drivers/dma-buf/heaps/cma_heap.c    | 21 +++++----------------
 drivers/dma-buf/heaps/system_heap.c |  5 +++++
 include/linux/dma-map-ops.h         | 14 ++++++--------
 kernel/dma/contiguous.c             | 37 ++++++++++++++++++++++++++++++++++---
 mm/cma.c                            |  3 +++
 7 files changed, 56 insertions(+), 29 deletions(-)
---
base-commit: 499a718536dc0e1c1d1b6211847207d58acd9916
change-id: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a

Best regards,
-- 
Maxime Ripard <mripard@kernel.org>


