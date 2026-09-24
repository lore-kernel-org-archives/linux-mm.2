Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D934CC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B106B009E; Thu, 24 Sep 2026 06:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35236B009F; Thu, 24 Sep 2026 06:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A026B00A0; Thu, 24 Sep 2026 06:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C576D6B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:06:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5731A1402CE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:43 +0000 (UTC)
X-FDA: 85248226686.29.201BEA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A3C7A40003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:06:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OA0Wwjkr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jezVnsczHca2+N3DdTe1/ZWux4ulhsHRjwwcueBcvY=;
	b=LhXO5oifihVdWSllz5DK1ig6cYZEcRfbkmwrl1opXJcU0JnEqqj/Cw9ki0NQ4VyBXjdWhe
	xDKZaNqQVARbDfnT0eodUOeHahdKttPSS+93eRC8fCz7AWGYebTCe3o9rMLqQ5WLbkosSh
	C1fiNbcREUN2f1nqOzEIUnr+7rhB6jA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OA0Wwjkr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244401;
	b=6sT88mMy+Ua2cBPjc6L7RqEun5c7JpPBy9+krYbhbC5n+HaYfKi3oSXqgOKqmWCGxOvOos
	Khgq7UWBV9IAxLPxcoQZHP3tlKWn5sMbm83KaRzKMgAd0qgIS0EEZlor6TrQg0O1Kg7IoU
	bjQqD6acIhVNggHNZSFHvss+lIAVU9w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8144432CE;
	Thu, 24 Sep 2026 10:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982691F00898;
	Thu, 24 Sep 2026 10:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244400;
	bh=+jezVnsczHca2+N3DdTe1/ZWux4ulhsHRjwwcueBcvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA0Wwjkrad2J01S7AVOXgv9vB7OxITzitM9cqnBHo/R+SMmR/Wb6JnEi/VOvV2Mr5
	 2GQ0T5KPCERTOQQyaKhjIMcAEoJCmXuPc/1IlVl4GqUieGyYG9M7bq9V9hdPzuGu75
	 zm5bZ6Vq9QKL5c2wtyNV07tR16E9ZCOrsDt/JCGwoBvTAiOwutEZ44qNObS1JXTIQm
	 thqkWUr0JA9TdGwc9tUQRVAHzwZRsT4bDyZTeHuozNp3wPg4eqZQgmF/val0gVwhXN
	 oIIrRZN/VaX3X3Ibu2efYFQqrrjq3udn0ykeO2gGCkLVxqnNNfkpFsX/NM1LKugnmA
	 wsfiHOZHqec5A==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
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
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 03/14] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Thu, 24 Sep 2026 15:35:18 +0530
Message-ID: <20260924100529.1398790-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: whr7cx9nn7qwckc8d83nj6uzg4ofhu3s
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A3C7A40003
X-HE-Tag: 1790244401-791337
X-HE-Meta: U2FsdGVkX18bYTvgNZZvLWPaIpiC4r2+7QDotsWNZpNYDM2XNufgdi4FQcATlPQoYviH3hKHHySRsZDmq76JeoMwRXqzjzQuPP2+WFUjzuVeBB0hkZ93B6vIHaQhUZWAJbkA6V5OMQKjo9sxBJJiFPB+UXLhmNloXJyFNQnFbFejnPfNy5ob46U8IqM/BiVB0FM3YLlqaTqu4jo5pJg69SVDjrbt1+iML0MS0oBaghHrS35oa3uKQ2SwzsAgCx5WDRMIRSrVvE5aIs6fz4sv/mMGb42dQrh5BN4V5E71kQQdvHVVUv3zTixYiOq8TtD1gv+zPUilVKIQjA2lW553EHUSh/kHuvtV0wJ0zG7Tw/emFakzEEzoqwmfwpj5gP+3FoMPMdUYT9EdUroKO3Ma0vVaPjssJ/9vj3jtp6H3wZsKRPwUvSPOYj3QDmAplGoKhjf2EKACyWSHfd8tkIMeyvZB0WeFjevefs2ProhWkOqCAa3lHlMbDaiRxeSPnsRiVq3LPxPUfr5QTEr4tyq+MYgxfce2ROHcxlsXwxw7RG988/llAw4a91XW14frjMu/dgliljGE5jSZG+CxI2aGBxXkLxRrQDEHnmdkbZUwEUHioNgWaCBk4L857/oTJBSsywtLvS2oULHegHmlce9LkqhGUi5SDK1rxlHFuVAqThBgVO620ni6jkJ2pHkgiCaNV9LLkGquxlVhNVLM/p/eh5XlPQQ4jvSlU1DfY533j1v77OorfpSwiYRxJDtGCDpfHIjT2lTQrHviHNqtZz6dpF2Ahp+Mo2E+5xHNyAenr9+d7VhH39JmvCUxI5jUycMLsD4CsRGZOnPdWxRvKIqANhVBJQUI7sgZltgdZBxYQ9xdxf+T1gLk0Nd96YCeojtSnNoQoL2cN8zoPuPlRrK9SX3Dmxm9AN6fdg9yhDP3o7XG4MnJz2Q4gRgnL/XQg2A3rR1jblfm76J3YiXfv0C
 SpcSvdAe
 bx4MxFJJhqCoI+qtdjBvEuXQwtTIgUexH7YOgp4K4wkXDQ4yheZolRTU4CqMEFgmmlmzkWRUAR+NpbQja+e01qmG+ysf6CKFUKCflywOVgDXNQ/kuK44QOF+aLz6cl2lJ6cEgmh+HGInFoDwL4FBIS2SMOb3zZ2DquTvyrZW0zkgNGWA/cZ8RN+Id4XZ91TyciyVtYOjfRVupAP536ck+cRG3JaXP/O7MR5OP+AD5BJulQItpscrW4ns4nmEy3xhf6VHqSEfIdOwi1CezxtO/hFyL0M1BisFtjzlYWx4t1P6ckZ7JlDyG0Hkt3inXZ7zVQt3RsYoVXhS2TX6/G0r1Z2bH26Xras32akSWsf2ffGniERE=
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

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
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


