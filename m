Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FE08606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LM5n551J
Received: by kanga.kvack.org (Postfix)
	id 9D6F66B05C2; Mon, 16 Nov 2026 04:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE696B05C3; Mon, 16 Nov 2026 04:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5056B05C4; Mon, 16 Nov 2026 04:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A54B6B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:14:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A073A8683
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:43 +0000 (UTC)
X-FDA: 85440422046.12.B8E52A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5DB9100005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:14:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM5n551J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794820482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4jy8IbP53ZuSPYyRskO/hfiiIRx+iysrGQG2bzb9wc=;
	b=4HL5Hm/BEG4phWtIFvY3CRQQgzeduxzQZz1T5Z3elAwDPsTONedyO4BmUXDYjStpPNTMUX
	wg7yn7s/upvqmOCrisRUOU2r7AJSZwjfZoLjsPzfyBDmMnJNntGiGp7ThpL2P+4m//vgn9
	Vp+X8TtQu0FdReAICymn59TVEBGtOSE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LM5n551J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794820482;
	b=3qsbunlIS5kxtF8yUQ4IkdNDEAw63yb5lMnN1tVjugK0HtPmAn1P/YrwaesOqarOitccJ4
	emMnDsxskf9SnOpXVODgX4CiWvNL8sqK/bAeGs6qi3+urXMtfJP6ppO5+sp+zNRA2FXy5P
	21JDTgtrJlnXEndq5jI2IvYa/cxm1bw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35074402F7;
	Mon, 16 Nov 2026 09:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE25D1F000C4;
	Mon, 16 Nov 2026 09:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794820481;
	bh=K4jy8IbP53ZuSPYyRskO/hfiiIRx+iysrGQG2bzb9wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LM5n551JdLsydZmHMtrzZTVMgbKp3UNt8LIepdvq5vXecnB8jqO2/e1PBnAnqwLYx
	 MHC/xxNyvkRhgENg0YivIMEi1NzQ/pK0XOtRajfws6WJlYcxdiaO8rZ0sENQvewqZq
	 Xmtpy9NW2zIdjike3QZwnAdQYMlWzPpOW4wLVrG3ZzdHUqC4hnVq10WTMHNs1bQLxS
	 wlVQKBh4GVQfjjQi8xJ4gckbg+XTk9EHkUHmom9GVd7GoGgq944kL0BI0ldTRHl+TY
	 gkYFmgnnU/TcFc7xHEGyn/eiBju7caeobi/FMlP1OOMOYrzylAEXXEOOVgVp1l0FAY
	 VkdKDndimmsMw==
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
Subject: [PATCH v10 09/13] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Mon, 16 Nov 2026 14:41:32 +0530
Message-ID: <20261116091137.94252-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5DB9100005
X-Stat-Signature: 7pymtfb7s7p7c4hhqruab9za4bsd8yzp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794820481-752880
X-HE-Meta: U2FsdGVkX18D3jaksohBhRgAoS4OTX+ioKyhoSgRnjtGfnwaAaswb6kp9bjNQ3P3oPkJRXFiAzxRbZFIshPctB/hsxge8qZDvz6axfj5xHT/qhxzXzQ/f6IBGD/GNXqf27nrpuFsBdcIbDGoktb9ATXCCrJxv/cEnDuU9lfhV0TFS3mShbJCGbAeDej/1yQuXby2ydPVAQWuMY+98etR4BjOOv3TaKUHy5X+AAtNj07MyVPijgqM88K3Y7Nc4cBUbkeEvRkbGoUMDs4ILKiwRPDuYvtZW2uBk3hp96OTxa4Vp3mRZSFSBAVFaEaW+A5/Hx/2+dVu8aP7xXwKW6B3B4NdJiVL73h7O955uIXSg/tobvlBqQZLJIMSjeewQw/cShxICRYRElpBz/DETm230MzMVTfeBiqlP9zYGXcFVqgoipvmuMrbc78X/YzMEAb+v4vJRPFs8GU161ZE9txKqOEq6RMVFhzzTM33Dpei5vjHSiU+B2E4iw5+BP+/hYmFRjp4ndPhi6iQvLJaC5LDigErJ6RHY+46u1ibLro6meUtVdrdVNM5SZ7+2WiJSZ3jAUZKU4M4FszyN6FdVsqGa4qLgCcLb86WKJWlln7hM+5WYe5KWomGIUH/eCySpkWRZjdTOj1hn9xKzWLeoPv3G5kehPrIxY0RxpG0KAxajPw8/HouYhvaWeG1PfYY6H+C8MpsgWZRCsmF9TC8xS6RnJy+sZCxw4pElQxLyFOerFa18h8esKqtktN131PNC4URZbGc6LSR7/e8DCT+P7CLSLiLsSpdEZfb8Pvar44KBLL94KA/8C00xypvltHIlcEJCpC9VK9uSGL7xzFZU+A4su3/W2Nd/n4byjAE+ZIOAjZc9lDYllCCJT/Nwhygxl9MMIVJ+iCIlNncYraoxZ6xL3GgJPs8o9//GJ4a5Kx+BFBGdJWC+DJmDLosmS48q7oR+aNpDgTKqXFQ4l0SmLx
 Ge+0GIx4
 ne2wOzNTKSO4dIn2AGDCVdBZJTt9GhlOqcBswFEQ3cVcJlNzgud7LXUCutLXPkuNpbGzpkCdPFQDoJssJQy52mQKv/iu6BtBsGTSQs90n+PIYAkEu3T+goN+xb6G/DzSBoqcvUuPpg78qA4DxeqnBojqrqQRMFu4AR4y2tH6RO3ZHiSuflkscINxMIwN0y2khDshHF/q2TyMup40LfWtTLfdZPLVEGIX2FnrhHH+CxRAGs/dQ8plIXNi7vfMnrBi3j8qzj5uE6hwH99U8ZL+lj8cOhu9h7H/Beno4NWTo8z3bgHKwa2rikIDyH4iID4Q3hIo1GfDbOEJwHr9qOA2xTUaxoe/3oqTzlO0p3Ymvg0txgW//WN7WukOOdYxG/Atm+6jVAmv/wVxZffCPUFAbZq3NgtUuqRRjmXlyTTsRBP9n/QpYG2NMAqgNLHMMdiOoU57y+ATnqxlfuD74cL0d48Wgp+Udxz6cILsCcquVOBYN4AJ43ofggppeMhSFrSyQM3Yx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A restricted DMA pool is a firmware-described ownership boundary. Unlike
a pool allocated by SWIOTLB itself, its base cannot be moved and its
size cannot be rounded without claiming memory outside the reserved
region.

Confidential-computing guests may require private/shared state changes
to cover units larger than PAGE_SIZE. Passing a misaligned restricted
region to set_memory_decrypted() can therefore fail.

Validate both the physical base and the complete reserved size with the
common CoCo shared-range helper before allocating SWIOTLB metadata or
performing a state transition. Perform the transition through
cc_make_shared().

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 2bb7d83ee479..24366038dfd3 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -39,7 +39,6 @@
 #include <linux/pfn.h>
 #include <linux/rculist.h>
 #include <linux/scatterlist.h>
-#include <linux/set_memory.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/swiotlb.h>
@@ -2007,6 +2006,14 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 		return -EINVAL;
 	}
 
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) &&
+	    !cc_shared_range_valid(rmem->base, rmem->size)) {
+		dev_err(dev,
+			"Restricted DMA pool must be aligned to %#zx bytes for memory encryption\n",
+			cc_shared_granule_size());
+		return -EINVAL;
+	}
+
 	/*
 	 * Since multiple devices can share the same pool, the private data,
 	 * io_tlb_mem struct, will be initialized by the first device attached
@@ -2040,8 +2047,8 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 			int ret;
 
 			mem->cc_shared = true;
-			ret = set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
-						   rmem->size >> PAGE_SHIFT);
+			ret = cc_make_shared(phys_to_virt(rmem->base),
+					     rmem->size);
 			if (ret) {
 				dev_err(dev, "Failed to decrypt restricted DMA pool\n");
 				kfree(pool->areas);
-- 
2.43.0


