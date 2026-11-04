Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6994F6082BFF
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cPmahXQU
Received: by kanga.kvack.org (Postfix)
	id 80B936B05BF; Wed,  4 Nov 2026 11:48:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B56E6B05C0; Wed,  4 Nov 2026 11:48:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656766B05C1; Wed,  4 Nov 2026 11:48:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 421FB6B05BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:48:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37024407CA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:03 +0000 (UTC)
X-FDA: 85398018846.16.0D4121C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88975C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:48:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPmahXQU;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUPcWaonNrl3fb8O5Y7CNOmq4dU0FH4gssUQavbBAMM=;
	b=4AGEHFxI5Nw6Vw7cfv+IEMblVsa3UQIgcPUHeM7vYUtwK7OS8mws2R0+83nz6gO0T9hp7b
	HFWLQO6padELvdvu3agTiaFDt1ma8oZ2obpgnTSED/PxJR2GOEw6o5eu3MSOIRp9NFre0J
	ayF5wlknf2wg0zTm1l+wkFiaimf2nIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810881;
	b=Sm9ydfugiG8K9Xgja242xkzXvtIMOMQbid05/1iqWr8DxpRjmVUTEzSir8olm2y1wJPKpN
	84LTFoFQ9Ox1ai8oYttVMohJmvuKCU/13lXEgCf85FMjO4bvgER7F+7JwBgRIWjZhiEv9h
	tOPQvC06yh1KxqJK/PGU/zUNj7TsouY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPmahXQU;
	spf=pass (imf28.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 932AF44506;
	Wed,  4 Nov 2026 16:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF6D1F000C1;
	Wed,  4 Nov 2026 16:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810880;
	bh=FUPcWaonNrl3fb8O5Y7CNOmq4dU0FH4gssUQavbBAMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPmahXQUm2HT0fyQppUmsSG58zcC3W7kzJwjwC9+vjp2fpNugB1rRsrsK06XtbRE/
	 OHtCA1YhpJ0We7ep1aIheg+OsugQk9HRuy2duRGha0ESt19yeGKL6CA79Kg3kRrJvc
	 t8ZPmq2S+PPZp7uAqs7vZjixGe9wIJm5NDjusaRJDB0kSeesNhMP+OnYqOR01ZoWGb
	 yK/BlNnWnEK07l7oK5WJvskl6usQW4OOjLt0dFG/X2bUPzf6OJFGp5nsyDsGX+JrAm
	 zbIZqkvz7hZDGsu8vU4VxVw2bS//9x4c3b3oL3FtSiEXt7ew5NL4KnybyjwL17/C9S
	 r0avPyYj6CPmQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
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
	iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	patches@lists.linux.dev
Subject: [PATCH v9 04/14] irqchip/gic-v3-its: Allocate shared tables using CoCo shared memory allocator
Date: Wed,  4 Nov 2026 22:15:45 +0530
Message-ID: <20261104164555.3555725-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: umdrsh35eghip8wsee6k7sf6hmsoihjo
X-Rspamd-Queue-Id: 88975C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793810881-171560
X-HE-Meta: U2FsdGVkX1802BaGPvkRtY57exEPlTEpj7v7jGYDM8qq3yHhNR2VefDhHfFCp65bp/f3npPt2TE56VBiwCTCjFlTd9agDgDIdwW0ztzKZluXqBkiwh6CiQm4hO7v0ibcvefUB3AtE6DDe9ZY3fo+byk7toK9yQmvQRzFa7ly91iqhS+3RBfnVMHQfbnfvwe9XmiMBPpz+BF0ZshjLT01xjxHNxFrYGNO+jeLt3+UfHUZtf2ZV8Ra9yV2hBysOU6++iZjgKqcWb2W2t2RKVyQjigpVfY//Ad/MUJgrL0c7scKtFB6USk1o1WeVyC0RiIa+vQG2nEiaX+F/onWksbU5dtlR/fQVjBNOlnu9qpHqQsNatiVvYREzW0xBIy3FdnXvJ3Zuk+TGBnt/jBhP8nHH6Y4CMN+tr13poFmOY0DmS5f8TleVMlVS/OXjBBcpSkUi7MuTpmEPtQ7xdJrUN7sX+52bTsO4sK6hLs6VOBZzNsIPoAX8bJSbwzaQgC8vWPoULebxAhJ4ZHSyAp+FFxaIb7DbKtFns9fE0hwx1FSbVcNq7I/Uc+rH0xCjuDDbLt0WOnE/I/vam71I4Y6pWQvUZt5jgVVWcOOClulW0JVjX8YWBHECk4T8CRgelCWMXN/vGJEWvPfa7mdYZu7hZAdt5fhm8czS+6CEBX2WhWH8IxR79hSdCuGHEHY+jc2897UOc5HM71NmoLkBDVCFhEG6VHEKjVayihsUxQmzisvdSF6TDnVmi64KnMtGYg2l5LPivwXEKmiEGI3Bwhu+/1lurSvcYPkhCQrnOoKRFcMmeyy6jP8z9nKnNZRbGCYcU84eusWvtUX8eiazDormxjmlKsAP86wuFBCZd5ahxjLmk73juts/iPCjllx4C4TSyvt8baCamIbWvnOHLm46/xJ2IrH1vuXrZ06nIq4EviL5EOCCb2dxTzaSeM5emABaUsPQHgnvOQ1C7cbs+YH6Wm
 djgDS6Q6
 SwFQzKpMk5vZvyv7YM1PGOTpGzTxkjRLENRU0munE+eTjCBlQXps0hCuRQRT4ynnpVLmdlE2x+EY57CZem8HDlkUmRqcJqd6j2WEIj6xFFZs2gJNE+sQJF8qvc2Kwizn/4ViM0YAgBOumyNc0JYsYvbZOrboP84Yiw299hk+B4ecJhFWLOWRRoI/kcNjFeKtMBLBawocxW0Kcq/SrMBrLXOG0qSdUPczwh9dRynkbIKyXRPu6r1patErygHXik1TbOLAxeufgzh7A4NgqWeFWmQqWAQBxOjZ5Ie2TIbkYVVepHDKnaOPRF7kTdhbVRTE+KxDJ7yum64J6+fcDQITQPDnfWHFvRReu7TfLUwul65wH/8zrQcu/aE+S1bdgsW2ahTvQPChGXUTxxlrEA9mb5Hs6af5JQaxhdK6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ITS command queues and tables are shared with the host in a
confidential-computing guest. The ITS allocator currently assumes that
the guest PAGE_SIZE is sufficient for both allocation alignment and
private/shared state changes.

Route ITS page allocations through alloc_cc_shared_pages_node(). Keep
the tracked table size based on the ITS-requested order. On release,
reconstruct the common allocation metadata from the original ITS order
and the architecture granule size so the same transitioned range and
buddy order are used.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 40 ++++++++++++--------------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index a8860aaadf90..9ad66253ab16 100644
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
@@ -216,28 +215,16 @@ static gfp_t gfp_flags_quirk;
 static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 					 unsigned int order)
 {
-	struct page *page;
-	int ret = 0;
+	struct cc_shared_pages mem;
 
 	if (node == NUMA_NO_NODE)
 		node = numa_mem_id();
 
-	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
-
-	if (!page)
-		return NULL;
-
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
@@ -247,13 +234,15 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 
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
@@ -278,7 +267,8 @@ static void *itt_alloc_pool(int node, int size)
 		if (!page)
 			break;
 
-		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     cc_shared_granule_size(), node);
 	} while (!addr);
 
 	return (void *)addr;
-- 
2.43.0


