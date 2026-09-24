Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A2E3C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5001D6B00AA; Thu, 24 Sep 2026 06:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6F06B00AB; Thu, 24 Sep 2026 06:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE036B00AC; Thu, 24 Sep 2026 06:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF4E6B00AA
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:08:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A81491A02B6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:24 +0000 (UTC)
X-FDA: 85248230928.22.170604F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id F2DF9C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:08:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5n6MGK2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790244503;
	b=7kxH/ZeV0cJVOdA69ykgcNQTE85HizJXe0/OOWmZJaXGwmIF1fazw3+DEe3/78kMuKFmEx
	Ki9KM9K2xLDX3DUh2vQQ8jKPCtvYjEfOKQXdic0zwIhdWDAcR42UyNug13s2f1ZZfl9ikJ
	h5wyphameLT2jNTGhtfhgRoHliuUw6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P5n6MGK2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790244503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJJYWMaIvtyGybZXxXutyXnVsQUWKbvJkU+PAxP2pXo=;
	b=Jm2b/2KDsQaqcGcLMedMfMx6Y+iwSflG1+N3SswMtf1mrk1GEqM4f3F8xEF90UG6V8cXi9
	hlLHm4PuWps79wOXcK5QsjmVBZ4THeBErcCF+GJF8bl0EltEcH4C0U53+YYvcvZPCUtvLb
	t29a/GJr2e+lWUjLf/xObPkUoAKs+Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D92C40199;
	Thu, 24 Sep 2026 10:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFC51F00893;
	Thu, 24 Sep 2026 10:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244502;
	bh=eJJYWMaIvtyGybZXxXutyXnVsQUWKbvJkU+PAxP2pXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P5n6MGK29mMINRCHXIC8ydY+dR/BkV3ROd/aUdApCPS+tbFHhPY9xh+IR68I0PFZX
	 qdeg4Edf9fGFKzHej5CvdNa2YRkY0pKwBFvYUy0sQDmi8swhQP3oWtFnfxTcXfbUHP
	 1ZlVi6klX6hVnRO31ygdNMLxpMEYjdZIeH894C1JnC9BS/PlnPfqVEt2z+3MFrEC2R
	 PicLxLThzW/dl8ZVGDCk5J0DJiWSl7rspSCPEHVq1HnG2MDl3siNIpqesN4z5Q7Zbh
	 ZHj+EnHjZ0NNkfeLftPM+pEIwR7vHerabIurntNfIjJLl15srVpl7Bxc2nciD4DSb7
	 9ifohJ9q8AY+w==
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
Subject: [RFC PATCH v8 09/14] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Thu, 24 Sep 2026 15:35:24 +0530
Message-ID: <20260924100529.1398790-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tjz8m1dyi5zb8ycm1zzrxzgauyo3u5nb
X-Rspam-User: 
X-Rspamd-Queue-Id: F2DF9C0003
X-HE-Tag: 1790244502-676572
X-HE-Meta: U2FsdGVkX1+IXPNP9KQ586TA4GLa0FmFiw8UVBjsyMQYs8ixE3NYGQ5f44bbriP2/aLvF1VUdDVmgkrB1KDo2M9+FAj2kx7nqSZiQfCvvbTrRUHmd079WUZX9vTLrsscuryU5Xq7yd9KYUFYFRnr0J3BebobkxkwjJVQHkTJ8APd5Lt/6PMvKdzq79X92K0taHMDlpXHJnaMEar5/bjuRcopaPuyyEiDh4cetQnXA1BBPB2/bEWTHbfWgTghdXywBPvdGniYrvlYLyH/WUhqbvCSqJJveujvkKQ8TnLVacIYEm6q1Om7yE6aWVMpfsEaHy776eqX632Bp8YQnpY3OGTj/WTHufFTTp48iUwJd6PfeAMToleBhXQX475OeeDyFo29MzLltfVB2kFd2+JuLnk43xO55IYuVHIrDxtcnuheMWoLOfnJ1nCsEAyk/Ya+6dZUUKqtBdMjlXz1FBfrafz2i3jz+E6gHUWZnNNKQcWiV7MwN7s99ZFTpKG9RdFJ4S4FfR1EcWvf/mxp8tLKvCj5D7+29Zwk0qV2KzpNhuljC5f8yyEbTxyN6HyrKnBGOwHnA6Yde0O6WLFKHKzmZ/nosT9D8dZLDAS4AGKQ4WzDPTHep+T0UN6DwPIKIkJtbgHu0FLX6gAacf9fd1tzuBcw6Tkcjm2KpXHvErjVreToRgrveR/P61CpBv5SqeQWm8oVLFNhX1Z0emm+UQos7rPXr+AAZhKfyzkItfLbkT8sUnxQStI2pSljBQe9f21dSAkFw4vltJhTw2jJJnB4MntIJMXVyxUHp/biJxgyd8A8GrWi/Li3I/rS5NWkgqnnGw8IQ7Nr4xWMuNJEI8PmQMT9qPlLd0mTd5YQ28V1BfogdVb8kG0jcuEELmjlBDF+CIzKEu0mWtpr0HbMOBjDwrXfDhbo/ltSSmNrckknqQddaKJSaijbNQNuepA/1kDVknc5PfVbMsBN1+iZ01p
 xgWoAr4m
 4mG9SuZcpizLwi0uBabrWDBki9Hm07CSUbkd+Hv+1nwT1VQB7kvcQ63ffw/ayppwOy1LGyPkQHwhLItf+qIDpddk0D/n5zxxz7i1N1IX1+Im288I1/3SAHfEKOtYRAR5Zw1Jc/hJmiuDlk+L6OqWTUeK4/0U3nfdZ0eHID82IgjecBS8M9gdYKdruaXFE14hQ3nsy1wJE0YRno2DbQKWpDkIsgi7y7HbfEW7LFy2Q4fxvjB3NyW/r3cj07qJtBXBnAUHmTuWgOI1fJkD/pNwrSI3fkp8WYu67ZDx7aIGeQCyGW7vwH0XbtI21NCrODzoWwhYv6lJZdtvKeghDQVkelVCR/0x4bToXUbTzEKKQBuzJm73NRkNnsvTldUdKDrIA4VmFtAWL2EKPFL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 kernel/dma/swiotlb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 394db93b7eb9..5f65b11260e0 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2008,6 +2008,14 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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
@@ -2041,8 +2049,8 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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


