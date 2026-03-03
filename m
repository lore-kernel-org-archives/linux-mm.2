Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED47E67A9B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E0D6B00BA; Tue,  3 Mar 2026 05:13:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E381A6B00BB; Tue,  3 Mar 2026 05:13:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D374D6B00BD; Tue,  3 Mar 2026 05:13:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1A676B00BA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AC278B8E3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:19 +0000 (UTC)
X-FDA: 84504339318.22.CB60552
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 963D31A0013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nAC+WnmK;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Da9uFOMrHgHYHqcOXPTzXHya/2jtJFOK6FZNCXoPrI0=;
	b=F85+2s4emsLJ1V/XVPE2M4LStkwWl0doC3mgtNqjrnK28WoVdnxUT6eunQl24UR9aQKxmO
	cX7Rh7bzZ1+nCBxv1uLf7im8HBsD+LmvRGaCkOvAeEjw7EATr4fZKP0K6OycWOTmsno9k2
	qq8062GM1NVOQsIujAF/WSQrafg49l8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nAC+WnmK;
	spf=pass (imf19.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532797; a=rsa-sha256;
	cv=none;
	b=2DU9/A3AtKcmMZCqvDlSN7Grczh2zTpUTkjHvsNUBzskoQkPKsUrberpSuyr4oIACYNOe2
	az/D14EesALNY0+30FzHKqQeasYAhgHzMnyRfKJW37qmv1HQefyYCARUOreE3Jb933MXHz
	Uyflrp2snRLxGToMjrYooCeIispolhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8DC144164;
	Tue,  3 Mar 2026 10:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A26C116C6;
	Tue,  3 Mar 2026 10:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532796;
	bh=huH+jTTc4+4vRctajrY9Qj1iPUcQ4Rh9vy/rLperoFM=;
	h=From:Subject:Date:To:Cc:From;
	b=nAC+WnmKRlfMtbZ9K5XQk5snQ+o5BtHQCeb/WYovJVKV6u1w0MD/D9C60ZmDCnvp8
	 Idh0WQT4VmNxjNDmBH3C+rPsSIQI8EXk56wKu72Adu7B/lajCv8ty24wikx6XGaujz
	 FWLTDibVetz8Yd5d44OoxxIaDHl6G9Ys/KNgf8fN5u2vhEmuWneaXZ1DKn1saHKAlz
	 212l02YMYaM6LC2c6ujcRdMKTMONjm7PxX1t/S4+rUL427Kk8tFpdHTR23k3ULKvvc
	 ryk5kevylRq+/6MZmpYbUeLGPqW7fmTQf//AZtfUmNK8ddzspIVOcRzfj7pWI5dcBP
	 ELhw+Vd8I8yqA==
From: Maxime Ripard <mripard@kernel.org>
Subject: [PATCH v3 0/8] dma-buf: heaps: Turn heaps into modules
Date: Tue, 03 Mar 2026 11:13:03 +0100
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/43NzQ6CMAzA8VchO1tTylfw5HsYD2MrsgiMbLJoC
 O/u4KQX4/HftL8uwrMz7MUpWYTjYLyxY4zskAjVyfHGYHRsQUglEhWgBwnN3ELHcvIgPQxWzz1
 7SDHLm4xV3ZIU8Xxy3JrnTl+usTvjH9a99k8h3aZ/oCEFBEqxjlsSa9TnO7uR+6N1N7GpgT6l6
 odEUcqLXDJXjKVSX9K6rm9FgDArCwEAAA==
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2374; i=mripard@kernel.org;
 h=from:subject:message-id; bh=huH+jTTc4+4vRctajrY9Qj1iPUcQ4Rh9vy/rLperoFM=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLthir7uE4qVs1b+HWQ8xse5JMMoO7Z06K39+59fuUt
 T5zOg9YdUxlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJtFxhbNizsavS6vYL7u75
 dS9Uv5xu7ta92yehqLe3YvaBq1waPHHOxSnfVk+z1mVb/Vsi2Tr0KWND+2btP29FZ0306P726AB
 vToXZnYrXB2MElk+5+9H5ifzjrVtW8lyaLbyvmWGWzD6238WrAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: ucceaotfn4x1t8cdqquf81bfwexa1tag
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 963D31A0013
X-HE-Tag: 1772532797-614717
X-HE-Meta: U2FsdGVkX18dB42uHF/sAi8JsQuFOfKgUo35ZnUGz9VD12VYtk8j5xNLnnGkLhSGeyBJ2HpzCH2YEPI3dqWpAHzTTBGnc9SkfvTz9DXDf+QJZC8W/7OSGltShonHwEqijDdzGqxx4w1fT9f2zneU9/QG44G1RGnMCzQ4PBvtokArzAmKv7+UePm8FVutf8XsGbNi0yaHXiHk0bxMOlre41/goMrBUzy3tiUtkTyTHDFGd02iAMtXGOqzBWNyP1IWWY2f/C28srpespw90J5PiP1YGCVTDyf+m1ghcyYKX3PQBU6N7EYHdiIdUbKyKAZC1TpDtiAG+0mVWUZ0WOwTm4zCB+4kaXnOHrr6yvQ/KCP39gZSH3gCDt6WqkGVDT41SkTMVLgKcC4R9U94qbIv1zxfUOGluAnyWzm/ab/z9LlfeyltPr9kmwa0yUiOtH9F+SMjSf+LlFSRksCvTICYdKBIKW4h8mZwEBN7O+ddVWNoKllfkmHismSj1Q9D138wlTRRYneN3Oh8TWDTQ+2/cOQTp49VA5dBtsMn+vGPOB23G1aNBEiYxFyOR6biJ6cp4yvNFqHqaPBwZB031dsvVUjDdKTYStxAQSLlaSxTJryiZi+2wK1X3GboDbO2FgXg4oTgqA141AUbDf5gTnROcRLZf3esPVNL3M7oSjnjKIxNmVaLsLGiEA2wl8ehoVoe427vKtW8luKuH7zAJrQL++oBroKQrbn7awkJE/FS4ng3l5HVgEieoiMqNLLN/U3//oDBFguMgY37N9XGNY3ofk9lvYZ82am5abqlucm49nMfYFlm4v20jVxi/0RH0xEDkLwWu2LCC+AqZ3udwdBFQ8TU2u7l/pY6+4DUn3NsWPSOve/Vv49nNGlJCn2uQX5bhldEpWWygcI2Ju53IMApzxeytRTWlpfiYlaBnwKihOd7baMUtm9qwwExiAYXuY8N7FxqNWyKl5RyWOVPiXD
 MH4oCrhx
 ukmfORDHUBjSn8KrMJRVychfl6heeWk3pmxiR+yyog1MTXo8u6EhhbKB9ZI9Dl4OraMoZbzoJgrMb7EzOkTX4jxPXItOmxVIDfnrb+eV5ZnlQxV8GUzI4BDD0sTsSrDl7jSV/4dBPeJdf8IdzwXdJGTtbtMUM+EGzAFK2OTz9mZlpx/O8OU6Vl4hfBJwl5rhX95Y/KYSsSQg32O/ZEVhV5gc/VGK2Al/xlCq0iKI/K8E+EkEiJ+E4wvw3MCS2JRgTVyJrTGIFA3CiJR4jWrPJoz2tl7Hj0LZF5r3ht/mFcqp4ByM8kJ5z5o99Pg==
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
 drivers/dma-buf/heaps/Kconfig       |  4 ++--
 drivers/dma-buf/heaps/cma_heap.c    | 21 +++++----------------
 drivers/dma-buf/heaps/system_heap.c |  5 +++++
 include/linux/dma-map-ops.h         | 18 ++++++++++--------
 kernel/dma/contiguous.c             | 37 ++++++++++++++++++++++++++++++++++---
 mm/cma.c                            |  3 +++
 7 files changed, 60 insertions(+), 29 deletions(-)
---
base-commit: 499a718536dc0e1c1d1b6211847207d58acd9916
change-id: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a

Best regards,
-- 
Maxime Ripard <mripard@kernel.org>


