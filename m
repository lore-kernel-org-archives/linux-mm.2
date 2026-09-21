Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3219C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C5A6B00B3; Mon, 21 Sep 2026 10:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CCAE6B00D9; Mon, 21 Sep 2026 10:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BBDE6B00DB; Mon, 21 Sep 2026 10:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6BA86B00B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 359B3A4291
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:39 +0000 (UTC)
X-FDA: 85238053278.20.1F3579A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86231C000F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1qRWRjl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUhVS/70oe+xVDq7uGuyK6On8HV25TTU2SaXV4Mxt0M=;
	b=bCLycXSXheiIFK6McbSnpBt2du23NTLLoJjSAk9gwfy7AhnteWsOGEGDJRtJPXyhqwWfZD
	kU0ktWHOlROpyY/pM2g1f9gEURH61SNRS2qXNYgUmgxjN6AvMA2/TqFpZT00nJVxJnx3gr
	7uEFjJub/YZZRqPgy0QyCtlpAXP67s4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002177;
	b=kjUORDfFHXZGxLvkalviYjwwB1/+N/prIHiI9HiG5uggC7YnPMSeXg+LyJ6YGYjtOIgvsu
	1/7BBNzBEZpzvIqeSA7lN+fnZQLdt7YulqQ61F24tmWMJPzpa27TSsNUG40APgZ0b3k1dg
	98/42gggWOKb4YGpYfTntTJy7WUUnFE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A1qRWRjl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5997600C8;
	Mon, 21 Sep 2026 14:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DCA1F000FF;
	Mon, 21 Sep 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002176;
	bh=NUhVS/70oe+xVDq7uGuyK6On8HV25TTU2SaXV4Mxt0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1qRWRjl1RV2uS6/gMaLuJ2pewyPR4lUHdxCKfj6tWJ7rGg/GojHBKVpQxQjMXmS7
	 lY/S//7gau/68XfSGzMXBxaEMlB4ozHdEDhscfQu8EZpTtDlYz4eNXG2JKnXNuWtAu
	 BesJL1+xMU8cIT7oCt0WaP8iyHhp83v3hmLLmamhE4RaEwCPOItgvTeld9nqcMfBzd
	 fg42y/fS6NwDQZ9GpZazOkEimF6PsA6coMmQZM1qB6Wvq/kXB7yjuyaV4YKO3pKgR5
	 P/F300kBVcQYxP0VTJLVWehPnUpnJzr/xmVPpj5xMqxWRog4njX/mK/wons75YlO+s
	 PhP5XTRddPZlw==
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
Subject: [RFC PATCH v7 04/13] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Mon, 21 Sep 2026 20:18:38 +0530
Message-ID: <20260921144847.501151-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86231C000F
X-Stat-Signature: mp9yr79htu69jqne7pg6b4mmfifsbh8b
X-HE-Tag: 1790002177-77744
X-HE-Meta: U2FsdGVkX1/mXrJmp/XVHso8P7hV7NHmm8N1S7wLUQLrRQWlvVFeFQJMo1k12CzmwiFBQLbenn3EvdpWcswh20x9BtZXymP5kvQgFoK1FqFgIXMvdHP2j00jKyAJ77ChERS4ce9BOvDfcmidAWtnwavhAZDsdcOxV0BpAgRW50AaD+mtFOvpaCRE5CukpEkRnMLiYZcoV0eBJaBN38Ay+nZoB3aXCnu1jrO6YfrpAGwhFISAjuXI0oWl6VEUpN8F+/bDKt2JbqIAmLe0P5/y9MxVJJ/RqtLyCAaRmKnEpRA99IFroc3vnURei2wDbp5PgBVFExXbbt9pX+Np9EhA5GEFHEh89m8qSqvXps8DNItbHEJp0pZZDjrL2T7tQrUcCpmFn9deP5hoMww2zkUt5vYYOmU1Z+PpSRd3xbYFbL4SkbrdSw7H0lq/UZF7DEY/C7KHq8gvQoFS5qxjPjBG06vZ7o7n3pMJAkj8siuaF+gqziFOHAO3Coiwdb5FIFjbiOTUwPiSOycoc8t0ItGdGWaIv1pgSFRuSjbCm3sGtDmFBEjzmAbKesCIa+2IS9c9TjHShQW9+FbuVFNe63GFyeyY3LRMvHErC6+46VEvFhcqZbSCiGzq7b8VxunxYq3lRva+/hQtMN4gm+KHHUohHXGjYlBvbVwGWyoeNYHyj2QF/k7HKdTrvY785N3cCZR61nV/uTWs3Lxq7+cGuKIIh9Mte2H9PX7oNT3+I3LAT+30K8ZZeJuqYoVNvbVIvKDgbpVopCU159nYINi0kuW4KZ2uXS4EqZEGhFNgSKv2SPi7TtRfs+nsZS3CnlfQpfgQYIpJS9lw/CK+ysf7vSPV+mouv7NzUFuIqAprePcO9Sg83YeKEu3OA1QVkb9AYp407NMJrHC/HFtydHQIbRJNCZRRwE10CLLWj27U3LgCVBzP8aQHvtyQM967Py405ED+MVXfKHAY1/yexNNo/IU
 RuCZinsC
 qSzVC8HbWH+4ZCbxRn7T+bdSCSvHzuOHIYNj9Wt0QeLhbZvoBvD7Jpu8i8ebOX1qRRk9FyX9bym++04Hkg7pMRzFUQT6AmxYWgjaez2/uReJ0im5d62VO5fnn+/O5WFbrVLOJC/Qy4SWD+P08Re9wZ5wDPaVwssnYnlAKhoDFVOBKKKU/r6RPW/hLNZ7QFj/wzybxG1n0ZjWOOsDDAbjInC0WqHaDpNox/L/pxlUT0OZV7Am1mAisSSQo3APdFlng2ffg5CZ3QfYPljM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_node() resolves NUMA_NO_NODE to numa_mem_id() internally. In
preparation for switching ITS allocations to the CoCo shared memory
allocator, resolve the default node explicitly in its_alloc_pages().

The CoCo shared memory allocator interprets NUMA_NO_NODE as a request to
apply the current task's memory policy. Passing numa_mem_id() instead
preserves the existing nearest-memory-node placement across the
allocator switch. This patch does not change the current allocation
behavior.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e9807af23537..ac5507acb1a0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -32,6 +32,7 @@
 #include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
+#include <linux/topology.h>
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -236,7 +237,7 @@ static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 
 static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 {
-	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+	return its_alloc_pages_node(numa_mem_id(), gfp, order);
 }
 
 static void its_free_pages(void *addr, unsigned int order)
-- 
2.43.0


