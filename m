Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1099EFEFB4F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A866B0089; Fri, 27 Feb 2026 08:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725C66B008A; Fri, 27 Feb 2026 08:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E086B008C; Fri, 27 Feb 2026 08:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7976B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C8551C7CC
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:25 +0000 (UTC)
X-FDA: 84490303170.26.90E9EDA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C7362C0014
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/XIt2WI";
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xdf+kf9TY+2jNega6w6E8N4pY1PIk//DFm+sHjMJ5A8=;
	b=Op7noN1i6T63r+F9h7HOvkoJ+X0Aj1uVMI+F5s2es1hMXCub/O5ZCypHuhWQdbuRWfObdV
	q0jWKEA/dzDZa6ZrNsfYwgH79ia0uHISGWrkzLd43N36aq6DNpY4BnrZ205SOOikkM+/PD
	l7iHWnPC25mTDeBK0mRGPhV8gm6+WK8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="P/XIt2WI";
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198603; a=rsa-sha256;
	cv=none;
	b=FIP+Hv/Xd2wvWseMmisXyTtMFDVtkCF8RIIbq1fnMBCB+LFTnSH3XScrKfkEzN/S99y+SO
	f3T7Y31xHRCEY0Rbrm3iSwOQulIK/y8YTlMkTisuZwK6S6e8dkDlxH5sqDF9LAiJtwXZsT
	VKvXBy0BqBq6Dbv3pPIyEWgoUFyXNR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F233B43F67;
	Fri, 27 Feb 2026 13:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23EC19423;
	Fri, 27 Feb 2026 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198602;
	bh=ecBBNr07Tr5A8D/sRSoG9EjORGZ7DumNUTGgwyKHMSU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P/XIt2WI/WidM++Hn39WGIZWA7aWF12X5bGXmPZqw+SFEh7isAmWCC3IqBpF5zrke
	 i0SFNqaKfpB8UymBOh0q5A7MCmkFKYu6JfKvR20UgV9mM/3zK9TgVr1+8BhM365GHE
	 Ehzws1hufeCM/uQQx3uoNxZ+yrLLzIlDrrCK2kDR6mckl6dyxG9I+vqI4BmjjCRLZw
	 Kmm2lEmuHqKhynAXUw5231JvjEwVJhlCMv+K7zQg6/KXBSI1NErnHsMxEsyYeiZ/iB
	 o2zGFJGd4irX/x0j4btOyS4z0j11JSg7seHNwhBkmnH5iM2m2MhDpPpWX5qy68FNHv
	 56c+LQhawGnbQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:41 +0100
Subject: [PATCH v2 2/9] dma: contiguous: Make dev_get_cma_area() a proper
 function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-2-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2341; i=mripard@kernel.org;
 h=from:subject:message-id; bh=ecBBNr07Tr5A8D/sRSoG9EjORGZ7DumNUTGgwyKHMSU=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+244WWftFg15Nznw5MXh/93WaX5OcMif+a2y8qp9
 zhDXyd/75jKwiDMySArpsjyRCbs9PL2xVUO9it/wMxhZQIZwsDFKQATidnJWMl4SPHI5Is6cRnF
 2vtyzyVbt0rVvbi56vAD1WNcqyx2ttY8FN7340HzyWeFR0L9DS+UiDPWmX+c8Fhq3+e5dYun9+7
 RjYhtOiwpPD/lnkhEadFJ6es8y1uUuI4ErhWblnSFsXPG2k9dAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: zqd87b8s6hqknshhpbgzfqt79qecsrjr
X-Rspamd-Queue-Id: C7362C0014
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772198603-667041
X-HE-Meta: U2FsdGVkX1+pkWP3FmhwkZrT1IJLsaZWDpws6JBlJvqMxY9Ligv9RAtnktUrsxN8ckN0crdJhiWR9mZpO6QWAZ7a9Cy5uDpjAsCgQ5ZPu54QSCVNY5YKJzTvQXg3VjhdwJlEhpY2E3Ql4nDBV03g78cYCTTG3dN5x9zApj09e/GoAbPDJYSd0Ab3rIAo+RSrGTRCHMAdW7stduZFHJdupM2/tPKn404+UNFBj4wgxjvCDuZ8DyqTOCo7O1bS2Hjrd0Kly+fstKNqAzPbUA9F/3Vkkaf1Z0ovo1yo46Pill1QIJbQb9VnERUliIrBr8vzLuTdWB90j/7gW8AnEY6ubFZP0UC29Bjgos5wy3SW6MwyBmyxCOlf350WtRqRB+eK0xYt+D6ertB1gYqPdwo4w7sZstUAGH5ynR0SL0w3TpLa0MW0sATaDwzuYxMRbDcVC0qICiGlDaXY/FZu0QuU+AdgR9GQNnGuUw/pMliy5jGc/khTL1E5C8kM53Yf5VSZvGQKvB6Vkln9KBlrl5Y6ZaCJhxke0o+piZR92p5WlzVRgEZ1ArAH5QCHXOUJXLMB9RbKmALo9FYQ63fYVJEovp0NwLqm01pk+gy2ZBtojJq68456VpbjrPxKmBH2Ymx0nmFxytRDcQsDbyeBqKjmuZVIABg6uW58h5SQFRadVzH6WQEFKSsg7u0tl9rfiuMgZ+hbDuWWFcygTo7fVwmEOc56oD4vlZ2H2isLJvs7fVUIWlV7iq2YdIPRBvI5CXF0+CoU7c7UIW3ewSgGKDn7LW4KRUO5GoZ6o2onz6/F9DwVdr6hF1+hCoaDS5VnxoNlYr2ok5pnWVkLOxk28iMISw3r7pV4utKkv1TPyy8y/mTDbNjtEGSlB+sAWDjBC+AyLA8wtW+E/i+NCA6UZ+9uPysbCucI1MaTnVykQPquC18OFvzPQ57KEel9Si4nr1M4afFMD67EVWz1UxFHJiV
 tlpQqzqH
 BTls5ObfRgJkOjn+Ffzi/VGktbS9n/uJnykgab2tyBg7Lfh+pQ/ZCzwGYb3T1GAPtIocISDZ3MUQfRFPBvXrAB8FIRWpsDc+foK0EWGqiqt7Ml+EjXPJNZhCU6HipHm2uzVOzy2nG3YDu2J1cIJBSvh/ChnL1aJJeMOB7dlXDFu5ltWsforjIe429LqJrsa+WVcpvmCbcrRO6juWEBG4OBLtFMy1cQKyX3TyqwxT/hJMz9Nh/XC9eJeHl+GZO5oYDbjqUZ+i/XFYwngTPG+Jm889y/zZrBThIOU/Jwg2nHuweZ7Fisj0VKqWqwAKA7Hq+AmxtZLPK4E47gdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we try to enable dma-buf heaps, and the CMA one in particular, to
compile as modules, we need to export dev_get_cma_area(). It's currently
implemented as an inline function that returns either the content of
device->cma_area or dma_contiguous_default_area.

Thus, it means we need to export dma_contiguous_default_area, which
isn't really something we want any module to have access to.

Instead, let's make dev_get_cma_area() a proper function we will be able
to export so we can avoid exporting dma_contiguous_default_area.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 include/linux/dma-map-ops.h | 7 +------
 kernel/dma/contiguous.c     | 8 ++++++++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 3007c68a8ec5b85990d1938d04a2f05c1a71acdb..dc7d54ac5dd66bd22ef868d7894cc1cb2ee4c156 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -91,16 +91,11 @@ static inline void set_dma_ops(struct device *dev,
 #endif /* CONFIG_ARCH_HAS_DMA_OPS */
 
 #ifdef CONFIG_DMA_CMA
 extern struct cma *dma_contiguous_default_area;
 
-static inline struct cma *dev_get_cma_area(struct device *dev)
-{
-	if (dev && dev->cma_area)
-		return dev->cma_area;
-	return dma_contiguous_default_area;
-}
+struct cma *dev_get_cma_area(struct device *dev);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
 
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 14bd54fb758537f01a6fe27318e7b683964e20b1..9a9ed7248fb823105609c5db5a51113e54a40192 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -99,10 +99,18 @@ early_param("cma", early_cma);
 bool __init cma_skip_dt_default_reserved_mem(void)
 {
 	return size_cmdline != -1;
 }
 
+struct cma *dev_get_cma_area(struct device *dev)
+{
+	if (dev && dev->cma_area)
+		return dev->cma_area;
+
+	return dma_contiguous_default_area;
+}
+
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;
 static struct cma *dma_contiguous_pernuma_area[MAX_NUMNODES];

-- 
2.53.0


