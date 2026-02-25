Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E07FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1098A6B0099; Wed, 25 Feb 2026 11:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8726B009B; Wed, 25 Feb 2026 11:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F181D6B009D; Wed, 25 Feb 2026 11:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF6936B0099
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 923EE13B4D3
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:20 +0000 (UTC)
X-FDA: 84483546840.01.DBB5CFF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B976D2000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foi508gH;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFKDVmj0CinZSS7YmnSAlz8Hpn6r/coX9z34irVZW70=;
	b=JqKqxr+t/OI8RMA7V6rVM/sYQA6/aoxP2QwH5U2JTc82mVTBajz/WJJc6FjyctW1qwUOq4
	EwRX8sLxPIT6ktsmuRofELwZfhDUYXh9GoPuMCc5bh6jeDG+LoZZ0xwEeLfUccq+4s+s7o
	IcAUC8r0sTFoUohfGKwX+lDS0SxLEmQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037738; a=rsa-sha256;
	cv=none;
	b=nH8J7+smHqNaoGFRbptq/rf/8xp+H1tLGucbTF8yF16cdwl793cHupuxnYAqgYIGiJOT7n
	RgK1lUpazYHVvYhH8WQVvlFT2nKjdEY9i0bxLorTNRmFYbG2xvgUcwj3+yw5aKq+SD7j7q
	7MFX8CwmiTxF6iArQ4yeyTezky3Bvu4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=foi508gH;
	spf=pass (imf13.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC2F744560;
	Wed, 25 Feb 2026 16:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBB4C2BCB4;
	Wed, 25 Feb 2026 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037737;
	bh=OaBx+qmc/uRKfph2nG7FL8m6owN/oNoP0WGfZ/DlULU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=foi508gHAWxe7or8Ff8K9LaNjitKTIq9tX/AEbBcki4x8JH/k7DW0GY4ULxRQFsBF
	 vp9Yd0tdFh7xjITX9qxUHrQ9pb+jnM7UGdeuqRd3/8Ddm5iQOOulSLnAlcTd83H+vU
	 Y5N81hlXeCY+3VrAA7PGaQ6e+CetuY9p1xqCCXPVtFmoCYZ410GP8Bi6mmv+4yn9yY
	 yZPM2Qvq53OrWGjpn51CLg4ed6i8mTP9pKek4PWtu6e2aRBSL2uvd7mfbwk+3bCAll
	 yiuHkmvIGrZKcPgAfesl/niZ/5zvznj3CpNDwc01y99RFh1poPConXRF83z1d6FuLM
	 Zn5kvI2yEyXAQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:55 +0100
Subject: [PATCH 7/7] dma-buf: heaps: system: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-7-2109225a090d@kernel.org>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1488; i=mripard@kernel.org;
 h=from:subject:message-id; bh=OaBx+qmc/uRKfph2nG7FL8m6owN/oNoP0WGfZ/DlULU=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1QJVv+lv+M06e+6fB2e5xRaHXJjZ98Ejf5pdZncoe
 9vh3M3POqayMAhzMsiKKbI8kQk7vbx9cZWD/cofMHNYmUCGMHBxCsBEgnsZG+6Uvty3f9Nj4Xl7
 Jl2zrXeaGqC8JKhd4Y//wtQDJ7+u/lqVW/+d45h+USoTr2/0DrntjIx1+kbeJhr6B+oZfF877c3
 uETw2f7vx3YeBbkV1Qc+468x/XCgttJES7oh1WLNf/vzmxEQA
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Stat-Signature: 6zr1ux758cfmsf8z1o39pg8e1bcd38fo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B976D2000A
X-HE-Tag: 1772037738-57704
X-HE-Meta: U2FsdGVkX1/M26ecxc0h4BqNmeDu7CD7RTc2BeiQ/Cnk1Ikm1v7D+eTb+4OG/DRVE78g7rOC+JpbaKwYY1IjW+pDXnDWHCBdUJaA30MLbnHy9H7cikrkcPr5T3Cmpml7Oxa9e60/6BO1ZmNha7ND6jCVBE6PGy1YOSgLn2uayKDMefj/bysXZbeArSyfxp6erDVB2NeZT7JKmvAKBOsHuHs55pL69m5BlVT8kTt4R4IJ79BeU2vMddUZFjAcy4A68b5cPnkrZtmJHEhtnqV3Jm0KzKKKkLcc8f/ejB6LlcDkSW9wgyur85KwPXT8qtV8fPHwXg/tG4WF0pGT6X26xfq/ITyE8FxoChJlar0CcF/P60LOsKxX17pwgYruXsW4yP6hNeeRM+nF5JrGrQT02M/fMUbDk7SOgIWzO6QYaroIUdSm9kFXT0DIN4OCLOsHrVW4VJRgDF/q98IzYv74hXQlvWlytGmnCS5NL98U2UHR/wIVbfzG7zLJUfMwcK86wZV3PCMvkWR21xRtVFNh2Y6zA4Bu9cXBWIjJy1DST+yN6EgS2iX4x70LUT5cn9T4hprAXRc/qVzSs3LhZuw4DzvdPM8b58jtkns0dizZrQEBn50mJ6dhqcyxnrZhwJTE8GYBnvXFZS993H43xLDGJDGo7Yn4YTqQsieW+OvWbfFqxTukqaGzxny3AtyaRzCo+DcfVyqYurxdtCB/Yl4VFdCukPRK1bmXnwHMGXtU5a7Qvdqb3mH7Id+M+6ulA/BBZIu5oFsVae+L0Wwz27oQMT7h/KOUOL0NDYlu6skFJZddviVVlSeY3RzEATIZkVxS5Kd5F0hpqmCqhIveSqqjeLdnGobGLc4iObkEZRTAW9Hc+YM1/S3SjTDoIq1ft3QDbPJ3Mehlh0p+eyio4534+LsjmHfzL9MZ9T+a8XMOgimVk5x6FSOHJOpjMItj/J4Z/3pffRceNvYrrFbtLDG
 1y7LDVVc
 7Afd22iHL8jgVXqgyvyscrpWioLZ1hjWRicgJMjLRMPOyMK6T95rezznO9EmD74/QlvsAEEMzc3CsnISopqL7md3l8psEgcYUVechRTJi0hNr+gh/tnRs6TN6OcmwJ4yLR6I0u/0IIkKKKiIUeT+6XJFqnCxCCbPFH0hNpajk8j83CX0BKHP36KoEt7TvgWMnvJvCarqIFcT1Cm9cIwf2CjkAAd6YNr+XhX10T+MNDrzWBzYXd2jKvzYfUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The system heap can be easily turned into a module by adding the usual
MODULE_* macros, importing the proper namespaces and changing the
Kconfig symbol to a tristate.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig       | 2 +-
 drivers/dma-buf/heaps/system_heap.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index aed0b9b4febf388376cfc41be9843980d010c4e8..e273fb18feca091ccd9b406e68f86c12efb339e9 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -1,7 +1,7 @@
 config DMABUF_HEAPS_SYSTEM
-	bool "DMA-BUF System Heap"
+	tristate "DMA-BUF System Heap"
 	depends on DMABUF_HEAPS
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index b3650d8fd6511a4a755612cfe3a9d9fee796f80e..1957403b0f2ae5e82ab39f5945dfe82808e93964 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -442,5 +442,10 @@ static int __init system_heap_create(void)
 		return PTR_ERR(sys_heap);
 
 	return 0;
 }
 module_init(system_heap_create);
+
+MODULE_DESCRIPTION("DMA-BUF System Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


