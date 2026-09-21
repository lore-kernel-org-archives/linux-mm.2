Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8037C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6B806B00D9; Mon, 21 Sep 2026 10:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42B36B00DB; Mon, 21 Sep 2026 10:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32476B00DD; Mon, 21 Sep 2026 10:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5246B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:49:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11497A49AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:47 +0000 (UTC)
X-FDA: 85238053614.25.ABDA110
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7004740006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:49:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc8P2140;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kc8P2140;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002185;
	b=vb0IYNCRJF7gJzCjsUM6ZJAwX1YvqcpLZRiog7N6Y1xpbKxYDoGQZU38g0iVXoOn0F6AZv
	38ztUrdDH6yiTIsBw/xcQS2eEYCvdRlggLzYrzJI8tcuVNQOD6XDYz2eR/9jiY3jP6mnaT
	6hQhREFcQ7SvQcD8sya1dpL0HQesbT4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSe1gOHGix6Y2SkfM68PVLIwg5C/r0qNlcWeNP5Fwxs=;
	b=jH0QpaE4DkBZ6uW+tvkQn7ZLyFpSndLTb21hI5e8MSdh8h1a42ADrwyMDNNycM0jDLEpde
	eoPFeIXiPWs+4MVfOV6sADwpYuQ/skymj4xi453Pn9m0pIWVhs6ldnPt8jmYb5P9RrZOnT
	QS+rWOcSZ+nHpl+rJBXItaGWwJlW2n8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA2FB410B9;
	Mon, 21 Sep 2026 14:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CA71F00893;
	Mon, 21 Sep 2026 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002184;
	bh=HSe1gOHGix6Y2SkfM68PVLIwg5C/r0qNlcWeNP5Fwxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc8P2140ujn+VDpWuuA0syxxlPiR5Dl/sChZvXp0DKgAkTCax/cLTbAp8LB0IWXAB
	 R4hVFA8/L+PQBfe/eKPRAHKK3vjVTVdKREnLY52b3114xvDk3GOmnJLuphnn5R+2sm
	 uOTWUiy5I/4uo1Ehng06km71pPSO/H3d3vc7lO+Gx1bVyxhyybF3v6MrEd5Hy3uB/W
	 f1R2+b/CTIVMQSZLAmFcf1ixeWZgNZEF7GsQ3UxDkz+aw0go90MnrLv0EykJ1GFlpI
	 enwffS8MUCShd5hX7jN0XvuJEjTM/ibsrm8B2tGuAGjBx+1oFq7lO33iYzkp/Ypz4I
	 NeRaMoJfvCMAw==
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
Subject: [RFC PATCH v7 05/13] irqchip/gic-v3-its: Allocate shared tables using CoCo shared memory allocator
Date: Mon, 21 Sep 2026 20:18:39 +0530
Message-ID: <20260921144847.501151-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7004740006
X-Stat-Signature: ypbaidw9qjy8awib979ork1zq96pgtsn
X-Rspamd-Server: rspam01
X-HE-Tag: 1790002185-132738
X-HE-Meta: U2FsdGVkX19SWph7sIkkPJ6VrtWqt4Db7hJ/yHRGJ+iwddNI9YtTMvcYXf8nF4n5bv8CjMtXQnexpSwPO8kh/7h3kpRiLBK2bUpqVnSIn3zZ80MXuSknGTmV3yjOsEYr9w1JB1y+1hpYe7UCd0+aVjyPCDbqlyJiNq8x1ohm7hHrlOWrVBodWAuzlcNw6cJALEk7aKe2qmv4HgNjpnGNS0rOqkhCsVsxM2StCUCxIWj8Gc+36nyKo75I8BdMYQoZ5yzqXyGFQojVyF7z7H+0MeYD5t3tO4wfjXhKXsymfRLabZn7KWXV1UniD+AdA/rICINOuF1pK10ZWzXlLXMoegjiuTNVVc8wEap9xgXdjWD+otCUl89mCskDBmWkv/DrY0vvrtbBL9JfXKIPDtIvpsRfzSmIaPPgRlgPA16SOCVIxcnUsDxSJaK8X6eWi9webbffusYHssoUE7kKaHnl3qkgAi+hKL4ymXogTIMOuGjcpwaWOL7lNLx5bFMBsNeF4gV83w9sXo8L8J9LfXUBGhUN4mCk5te7B0rE6R5f9NJZdXECVc33ATN1R4g+0IzgzxD4nfTMOulQZzePvmxF+H55/eO5+i/hmUm3dCPjHXgRpk8lci8C49xZCtib+JzFdU3Xt1JWCQQZQpfXBzMXyrAEr4yEDe+jumeBmC2kYaw0lVRuAwmnDrhX06Fx5uQXTxkCblcbQ1cRNXo7klqkI3krDPQ/nw3OYMGGGvR+j1cdm9Pw7PuAm5734qeYL57vuUGzRahocPaBZ1GQdCY1VfA8kEFKTtZeDAc48M4rXuF+tSkADSOkBc/LtBwQgs5RqxEpfALacvF5avCyz7vtzHE3Hol+yUWYah/vDtEzLN8wxTQydPzlaG5Jz4ALSRQzsh9RrCXSFCrDtKQkp/gqVUkHCjgmDDT9PL2W0/ZR0+pWtdR1yy11XZ82ZhjPfNB9d6+ERaX1WZd+/6MYbA9
 fmjPyVPv
 yr0Rp/eaDz/bq1wDdUs4+wcFdZpiRQGWEe40KmbPncK3/dXEuNhCEqxAUAkJaI4wxarcukhvKvOJIgw3m2RzQTBXEny2L62EGCGAGEQYLcqc6fN2WmUEAiERIr5Fy6djv2tIUFpGsQXINQVAONoxyF4G6AUwV9T6qrzqY8s37sAlnRdj0dNLbbUncp0w1lX1OS681b3lcY5jHXsy4+A0ue+rqE7WzD6fXYECwZ94XXjPo49zV6zrRXpgjl5sRVD5D5EUoWY0kSVVFQ8XcOcRmE5xrUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ITS command queues and tables are shared with the host in a
confidential-computing guest. The ITS allocator currently assumes that
the guest PAGE_SIZE is sufficient for both allocation alignment and
private/shared state changes.

Route ITS page allocations through alloc_cc_shared_pages_node(). Keep
the tracked table size based on the ITS-requested order. On release,
reconstruct the common allocation metadata from the original ITS order
and the architecture granule size so the same transitioned range and
buddy order are used.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 40 ++++++++++++--------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ac5507acb1a0..4814161df02e 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -8,6 +8,7 @@
 #include <linux/acpi_iort.h>
 #include <linux/bitfield.h>
 #include <linux/bitmap.h>
+#include <linux/cc_shared.h>
 #include <linux/cpu.h>
 #include <linux/crash_dump.h>
 #include <linux/delay.h>
@@ -19,7 +20,6 @@
 #include <linux/irqdomain.h>
 #include <linux/list.h>
 #include <linux/log2.h>
-#include <linux/mem_encrypt.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/msi.h>
@@ -29,7 +29,6 @@
 #include <linux/of_pci.h>
 #include <linux/of_platform.h>
 #include <linux/percpu.h>
-#include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
 #include <linux/topology.h>
@@ -214,25 +213,13 @@ static gfp_t gfp_flags_quirk;
 static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 					 unsigned int order)
 {
-	struct page *page;
-	int ret = 0;
-
-	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
-
-	if (!page)
-		return NULL;
+	struct cc_shared_pages mem;
 
-	ret = set_memory_decrypted((unsigned long)page_address(page),
-				   1 << order);
-	/*
-	 * If set_memory_decrypted() fails then we don't know what state the
-	 * page is in, so we can't free it. Instead we leak it.
-	 * set_memory_decrypted() will already have WARNed.
-	 */
-	if (ret)
+	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
+				       PAGE_SIZE << order, &mem))
 		return NULL;
 
-	return page;
+	return mem.page;
 }
 
 static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
@@ -242,13 +229,15 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 
 static void its_free_pages(void *addr, unsigned int order)
 {
-	/*
-	 * If the memory cannot be encrypted again then we must leak the pages.
-	 * set_memory_encrypted() will already have WARNed.
-	 */
-	if (set_memory_encrypted((unsigned long)addr, 1 << order))
+	struct cc_shared_layout layout;
+	struct cc_shared_pages mem;
+
+	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
 		return;
-	free_pages((unsigned long)addr, order);
+
+	mem.page = virt_to_page(addr);
+	mem.shared_size = layout.shared_size;
+	free_cc_shared_pages(&mem);
 }
 
 static struct gen_pool *itt_pool;
@@ -273,7 +262,8 @@ static void *itt_alloc_pool(int node, int size)
 		if (!page)
 			break;
 
-		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     cc_shared_granule_size(), node);
 	} while (!addr);
 
 	return (void *)addr;
-- 
2.43.0


