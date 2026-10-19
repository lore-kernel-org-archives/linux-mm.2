Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73E2BCCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816D76B0134; Mon, 19 Oct 2026 01:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF536B0136; Mon, 19 Oct 2026 01:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DD1A6B0137; Mon, 19 Oct 2026 01:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 490AF6B0134
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:44:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C72B91A0646
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:49 +0000 (UTC)
X-FDA: 85338286698.17.80880BB
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF8A01C0006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:44:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfZyKk5L;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792388688;
	b=luCXxhJlUZO8jjLZf4qTBGQX6gqhBZYMhuy6WX4trTQADJsL7L2SnDwonOMyB37TN+nO0Z
	stjlEi3Z0CctsvhUOUCAMRNg9WN5+c7WXch7ZLh9rEMH0q40oC8xxC5ACGzNn5RUQuGlEx
	9t9Tvepr5fsfPvvoScRrSEE4iK0fSAI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bfZyKk5L;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792388688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8GPmNrrbDyVAn3i8pP3Irq5ZXZX7zbqtdgKc3xpyyA=;
	b=mL54aY8I5WjvYWDqHzFGIdjJVDCZ9z/kiFGmK41UdaFnFovJYG2MVKlZ+ZhdldrnL6gOMv
	tdxhimLo1eS2aekWuevF/OyTatyomriGxcAN5XO/tIngkuUFTfEXLJAt6n5r17THizDt3J
	Gz5dr5lxhfFIz4Ts87GdCsmfmOF9/wo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kV3VwCyfCvJMLMAaZdOv60N3vXq9IpfkDxA+THuP2XI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792388686; v=1; x=1792993486;
 b=bfZyKk5LZX7dRUf/o3N3SnxRArbKpVZE0qurYqe4J6IzwXfLBU1qcz/J2eKM5L5RI4zqmbkg
 JBvwTJgyGtuKl7ECfapy0D2k6KKaXkiPMWhNBoU/EiO+sAUS7LNpZ7H6AqB9hsCiVAE7Nxfozlx
 TlUl7BIUqC88uRwtWqauXZ8k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 21b0a6f41841bf49;
	Mon, 19 Oct 2026 05:44:46 +0000
X-Mizu-Trace-ID: 21b0a6f41841bf49
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v2 4/5] powerpc: drop redundant unmaps of failed vmap mappings
Date: Mon, 19 Oct 2026 13:45:29 +0800
Message-Id: <20261019054531.87652-5-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261019054531.87652-1-hao.ge@linux.dev>
References: <20261019054531.87652-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DF8A01C0006
X-Stat-Signature: brw7w9s8fomn491sb3pqum91qu8o44di
X-HE-Tag: 1792388687-489488
X-HE-Meta: U2FsdGVkX1+cNbFN1DHq8CbgQO65HOuuX89X3nAojXgiPi7tP0r/v4UAkTMsuvDdjFarYnofXYKs2b2EiOpUCjjcnk4vm+rfdTVNtensEJc/ze2DE062wSVuK6SGKBkaCnCHOxFXJpdsJR+vN3BGRCbVypuE9+TEpQ32V1+zZN6jcYAbu/RZ8ffsM5PdzsTO57fr0qb0ZAeBxAMHzKO7y2GqkGu/4i1+YgWHUJqoHIbU/QIr8pHVXsou/SAeaXwYXv49jN76VoXrjhHkGfkNqfJIZli0rNW8QSrw6mY8YLoBRjnZHjWwWY4LLM3ddHhgHrNvfWVaG/D8ugRvZGgG19HCLJ97luBTZwIvK49cq0xAhLWNCcMUDn2s53cZBWTC8YvcP88rZKMSYL3bfEVCgopx5IkI1mg92QdUYndA/zOqgiRHhrC+VfiONk1TnWrzz4pdjRBdhEXq9iZ8/H5dS4CMGBvv+EorvkpIDne7RczM1TlUJaXyB9WvUZEnoD4MAlkKLOUgWuCdJaKwppizZFoWGVd1xvYQBpETyMXWDeqlUaTRE5cZplTB5q8YfzCCtYCazkI0OpbVJN7j3JxIQi+yEyhwq/YKKmEQHLM8k+6eYydcV9e0dlRplL8py0wPPir3rs8SR07ZyQbT5Z4l7ix2VWhrPYdF3X/9y6XbmfZZCaNrefW1CrzDIssenozpncgw72Dy+w6Ejp1K8tVYeFszcRREh0uxb0uka+ft4rcqoAZGvqcbrndASioiBnBPVPr+WpMLJoP91CIwO/dXaeEuSuL5HH5wWzu7UQJVG2MckA11WVM/gb0RfRLpT+q3oiq26fF707P+Ks2F94X7O/hUcDLlCgaUTtRcI6wFainGKdIhnOvHsWjBeiNSKbYULryJE/uL1yzg4v4T58WaxtRI/1B76sXTDC2rRtIaOCACGe4RYN4l3Mr2EFzOkNFtJlc8S6eWslz0afVp6Gh
 POGdRsLP
 gxhwLOT/71jGZUHwd2gBz/rjzt+Lkt/0PARIw+5hjOpO6pOAczeHKsW3DFCJG+b5XeYU+exCojf4QVsNW7phBvW4EnGGv5clK2A+2aiJbk3w/URM+IrBHzm0u/vu13jYQDB+zvF7dQMOkxVCE4q8dBFCH3EKINySPEL4aOJ9Opw/Brc1qYcveODUrrKsfrXcjBoiC1byLrPnh4LLyW5ep4SFoynNzlN/P8VVyyZ7q3NlKdzYUX9T1AWiv5hr1RT2ZaPI18qmWFXZc2iyyTtBm7XZllKq58wouHpgI4kLbI09tHeAi3K6g3EjYbeLOvqvHJODET0FKiO1AF+1Wn5rKLk7JpRf2Z57aEtrD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vmap_page_range() and ioremap_page_range() clear the PTEs they
installed when they fail, so the vunmap_range() in remap_isa_base()
and ioremap_phb() has nothing left to remove.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 arch/powerpc/kernel/isa-bridge.c | 5 ++---
 arch/powerpc/kernel/pci_64.c     | 4 +---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/isa-bridge.c b/arch/powerpc/kernel/isa-bridge.c
index 5c064485197a..93029d85e6ea 100644
--- a/arch/powerpc/kernel/isa-bridge.c
+++ b/arch/powerpc/kernel/isa-bridge.c
@@ -46,9 +46,8 @@ static void remap_isa_base(phys_addr_t pa, unsigned long size)
 	WARN_ON_ONCE(size & ~PAGE_MASK);
 
 	if (slab_is_available()) {
-		if (vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
-				    pgprot_noncached(PAGE_KERNEL)))
-			vunmap_range(ISA_IO_BASE, ISA_IO_BASE + size);
+		vmap_page_range(ISA_IO_BASE, ISA_IO_BASE + size, pa,
+				pgprot_noncached(PAGE_KERNEL));
 	} else {
 		early_ioremap_range(ISA_IO_BASE, pa, size,
 				pgprot_noncached(PAGE_KERNEL));
diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index e27342ef128b..f74269636d5e 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -139,10 +139,8 @@ void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size)
 
 	addr = (unsigned long)area->addr;
 	if (ioremap_page_range(addr, addr + size, paddr,
-			pgprot_noncached(PAGE_KERNEL))) {
-		vunmap_range(addr, addr + size);
+			pgprot_noncached(PAGE_KERNEL)))
 		return NULL;
-	}
 
 	return (void __iomem *)addr;
 }
-- 
2.25.1


