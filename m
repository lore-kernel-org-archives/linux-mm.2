Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC61FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C846B0096; Tue, 31 Mar 2026 06:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423736B0098; Tue, 31 Mar 2026 06:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3120A6B009B; Tue, 31 Mar 2026 06:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3556B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:00:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A386E8CEEF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:30 +0000 (UTC)
X-FDA: 84605913420.23.38D7C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99F6DC0004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:00:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWOBMbVZ;
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951228; a=rsa-sha256;
	cv=none;
	b=IO3zTcBKWiNk5UZXzgb4VV1yDu7A76PObBi3dsHgj5BgSePMHa6vSFebdBaYXq52jywL26
	dyqQUAjoEXiyCEijeL8VK8D0E3LatX4Ym2Ko50D+Zu4WQPIq9DdALg4+alibnLE29YYrzQ
	OQL+att9Sr/aAhlhH7scDKRLzzx6SFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgAo/4A4smuJFu/7d193wUa3ABspm0u6DoGDuJKA1Lg=;
	b=0GX+0K27ZAPFGHVH0OC2L8w6aWuFTL5zP9kovh2G1tTT/vjG19g1iaxAX/zAIEr9uK9Fho
	5xy47SkDGSS2uQBUaPjy1srZzJCuVh2L+UMZMTw4/1lZST9ZbBleebuCFtbc3vGSV9ZiM1
	X6Gwg16PF1U/euleUy6+TxkAJ6+lCSE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pWOBMbVZ;
	spf=pass (imf22.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C131B43AF7;
	Tue, 31 Mar 2026 10:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAA6C19423;
	Tue, 31 Mar 2026 10:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774951227;
	bh=HViJ3A2FjlDEklvSisEqyQ3MoBEs84TC4OJD6vWGvCU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pWOBMbVZv+nHWUv6rnOHekogJLNlvQSUhgs8kiDRIVR4rb9hs6nzcs9z32W5KqUSx
	 jxGAJCaQOrRjegiJHCr6ThMqNcbBZvZw2yQQNAn+z8rwClG72e+aZRicYRFw/86EfY
	 kcpt00GzP4E0wABRNZr3nSZM9zbjE21lWfsOOfbQ2j6KHQiFemBCvxEkzfMADhlym4
	 hMrdpY/Sd/4r14/IJzWd2v1qVcFoNffqZaobMz2sHgTQCwiixND4wVHTkPvuCELveg
	 DcKPabGsZ3PW8ZDxD0PPNKheRO99RhsFLuY6ZIP2RY0TwgwW3e1aQnQxuR8TIqCn3P
	 Hyzmhs4UMbZ+A==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 31 Mar 2026 12:00:11 +0200
Subject: [PATCH v4 2/8] dma: contiguous: Make dev_get_cma_area() a proper
 function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260331-dma-buf-heaps-as-modules-v4-2-e18fda504419@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2404; i=mripard@kernel.org;
 h=from:subject:message-id; bh=HViJ3A2FjlDEklvSisEqyQ3MoBEs84TC4OJD6vWGvCU=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJmnZ+srzBZWUjrEa3fu2IUTV3l+3Pyqejiwi/mKUVuvx
 /9je98d6pjKwiDMySArpsjyRCbs9PL2xVUO9it/wMxhZQIZwsDFKQATsZ3BWB/kd67z+pUXtTGW
 h1sCIzZvmPJDbYKbcWmbJsvjppVXzMqeXZRy+tB68e/zt3Pknx3+qMDY8O5/7p6p2rZvbY82FMU
 caGgs2sBsqsXk9lA5WNn6cqf57Z9KEkyuq/KPLJH8LPlwVe0sAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99F6DC0004
X-Stat-Signature: y5sicn16bw9arp7w1p687fhjzi7y8yuk
X-HE-Tag: 1774951228-442645
X-HE-Meta: U2FsdGVkX1/SnzHijQqo5rfG7wqYbEtoMAzd7UgxDlDnZXnmna1/Earxouwm1GyWrJ0haL+Lf2uOXy9VRrtXAnzFcv8b9apFlD6QY8Y2pPjh9rng1Cp4p1mdDUCE9Ij8rc6pKGSrjYYF7yXsw7i8RBynGy1PGt0tqnBSrIeecGrmrzz2F2YlpcEd/F0DHn6lzQxFUV81dcLUTWYvCQ7p2OXJZjmO47RYGWK+eiYBu0VS8NxQuenWC9ZbdcGrzX1jViDxkcKzOiosLoOC7U0+BkpftQfDjjK1Ce+Pv92D46/REiYrWmZtAHSxSCIV9Wx84OjOXpwAeKjUwuFUrT3nWvDGFbseV4jU5lz+TwkZjhl6m8b3MfrlAiuYQasJrZo5nXrJ6+n5S7SrohKHNf+mi7zV5nXvr6lt4ipFXS9EqcxuqZyQgGvU/R8rEQoMiKmVpRWfH9bBhmQIjOwXzqkg1AxvM+4AuZOzCqTCMqWt3ZRG3yOKLkLoKHwQgoBtQZMHCHFwhhfrgr4HPaUQ45i+N+SUS1398hNn0nfiy6ySaUmilMp8uX7v/7rctP33MqAf06PU9rt6BcHWpSypxY10Io8UQCqtpdY8DUJqCb0M7sPMtiYszfWGhxIiV1UgtLCjH9PInRRwYxo50ERs6dqBE+ZeAomJpxmy09OU4BG7ekmU24S561BIkgIazjxHtz5rd/ocVvSvYpX+3Uz6FRjD2t6BozdQ/ro3VXXZmwYNqxRsj7gbSko0AVU6ffXL5ObqgbskIQVkYPEiNM+45P4AKUHqQOYR7dZLBop7kIGqM8RVIGrG3EKA4qCdCqGMqsbPCylf/sKos2snJHiDwJEyKPQe4ibKUKs9davWJJx6i2bVHidBhJIH3+Cnycnz3XPjyg7qHTNNh8NnMfAy8Al9IWkKil9y+fc4lft8ZL+FWgFptDlUaNPGEUH8322kYeSoCe9DdNq2wxCcYWFol8v
 yV5ZeZbE
 OgOF23z7QMW5v5XjXJgOdeMrFPMbotwnLVrFEoG9KpZw7KWmb2JqXuObo0cwAZHo7Kpf6xDJ6fmmmCGpI4G8Jp+1T+MU1EcVLsWLwE5QjJomPjkFAmbosz6qFCbuyObSYTsX31uv8BMg7gKUgcrAUGPUt+gJbe6CJ1MqAD9KLos+8PwIwKY7dL1TIPL831zk4mwa/LJ1lnMLtc9YZ5NdblEDqa3IW852KM4UshEqE6EgGqBPDtlKiGkQir2qktHgcoMpvo0hidzRRBc3UwtjFAsfG28j2kYyHmMN4LYaOb8tFobnGtdVF1C/yQTrevHfBXbQ/tenopSO8F6w=
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
index c4c93c72ff6ff3ff5c59b7161970805422e9dccb..8604106c0c01b6a9dadc45263f3b1d9ecfacd4aa 100644
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
 struct cma *dma_contiguous_get_area_by_idx(unsigned int idx);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index afa9fd31304051d200cd4396dec26dd50becc375..40a0ead24979cfdf25e4779545536a5438e26356 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -129,10 +129,18 @@ early_param("cma", early_cma);
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


