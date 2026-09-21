Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D885C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887926B00E6; Mon, 21 Sep 2026 10:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837846B00E7; Mon, 21 Sep 2026 10:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726866B00E8; Mon, 21 Sep 2026 10:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFE96B00E6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:50:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE0891601E6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:36 +0000 (UTC)
X-FDA: 85238055672.22.BFF242D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F97910000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:50:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Psocjzb6;
	spf=pass (imf05.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790002235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsGwfxBcGa2X8eifj86iWN6Y5mB+a2kx/vCpPCjEWWg=;
	b=rqEFEHlFbJzEXhur0oLxNLUUHahWBfLvXodHctFU3p5AuPLy9gSDZY5WaRgHUmIyPF2xbW
	qKOlX+HrbAnWlz4dzYNzTNt2b3pweXrCCy+O37PXHzPANZfiyYeVAHj56XtAyzxWja4DkV
	UdOYCkHgClKw5H7LrYi/vJmhdoRFsg8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790002235;
	b=wp6hew8MI4YecWCSjApV5H0yhyNtOCvBRcYKfXOPOuhIZyOJPej508Y9Hloic8uBlK2v0e
	gR6Lm4miB/3nEzxxViuQIYqNiJrPhGU5luEM6zQeTKyd+9ECQs4X58EflzHO5OTxMGUhj5
	N5l9AzbXZvtouvXz+RTgMdhqQGzyjAk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Psocjzb6;
	spf=pass (imf05.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 976D7404F5;
	Mon, 21 Sep 2026 14:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441611F00898;
	Mon, 21 Sep 2026 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002234;
	bh=HsGwfxBcGa2X8eifj86iWN6Y5mB+a2kx/vCpPCjEWWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Psocjzb6bowHSDioUIF9/6tvJDU4QGBRjJjxTFtyWDQk/oft1o4Ri+wYY8Q5qVirE
	 kqBOewXMKNfLKWyfWfmRQDs0BAbqll4f1bcCNdAzPNx7tU7gy+7rGsnC5ILEr6UEo5
	 v1g7rqi1Aht05l0fIpjnwsguZWG6xUS2U2gJWyL4ZxAKLzo/36bVRfUZ9Qfj9OpRRJ
	 MF3cO+ivHMYiYkd+66D0ig61BpdP0tNcsvHZSeuG7LX5q9xooHfyg4toVn00kxehkp
	 8qZq9va6WawQxeeOKd61ivw0oVChTUbrGK15k3D2Ndt7EX//ZubzVxK/gi6rxepOn1
	 6SredcbkRgL/w==
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
Subject: [RFC PATCH v7 10/13] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Mon, 21 Sep 2026 20:18:44 +0530
Message-ID: <20260921144847.501151-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4F97910000C
X-Stat-Signature: jjdapss19t397gebh6w5onxuppz9geti
X-Rspam-User: 
X-HE-Tag: 1790002235-544057
X-HE-Meta: U2FsdGVkX1/UtSD+TPIsrZWlFzUNqdg84ETWKORq8xay/rmzAg1PhAjxm8HfQDCBU5QzWWSiYNmWUpieN3f0vk721PraF75jDYtPtnbWt1qODhph/HHEJ7zzjmaxcq47g5MR0dt9DLW3vvo+BuRNr9m01MzLamtg+BZHesDsJXlkvEyXuOeIg9Yl1FulnARIR4fAPK/NP+OQtGqciF4bcvZmV3GTRRisCC3Z0fREZ2LTq2FpcSBwkBxM3TZC2lg7i0QP3TKeSp0rRqREWMkRdB7jILavqmzvpj0CrVwYxzvJ1PEp+qu87NU5hrZ1z1ENLqFlcqZIXAXhFOBMh5uqxa1ZmQuoMACzzKvz40ueO1X1VSjQ8G02bDyLW00ax85mrTjTuQPzkPcn93gRG4OJy56u0/7tpOOgAT8yrXQxSmiErwRXHQEdQpAOfORDaWuhZc+XZP68oBoP9q3UeDa4mkV6/Yqqm/hCWlMIRmmkQOa5G9zmlyUfZWTgX1rkSxn2kPderArJi/414S3zv4xliyONdzdnYogpLBIp97XUGZbGQSrUYX3cXxFSEDrNzpeDb8PUxCd1Lsq3sSlov40HDWLnchUUv14IToIarxhomCdhkjaMNe/2t7NtINROFc+DD4fdw+ucYffw/H6/Gi3MAr6COTa2/EzsARML39viFmG4IX8Yr9Y86FmbvOblD8/nEDb/hxOlkKZ/eDW+LsWoNOL5yG15x5tafxHmfVcoPNwVQyFqNSYTzovOsfC8sF2m5xnkMxRLWC+1FxHjjwe31PB6BWMdnLdaDdKd9WCdJx8WY7KWRHzawFYwyOWBB0O2JIWKknQ8xOY9RclzqvhfCYvkYelapd9m5V4zGuIFSeZJtQkUxVY8Y+zJifvPDbyxitbNqNQoZ+OFdrFpce0TItbSQK+IriRDkGeH5XGdGVgXiuq82/iTH83xkBzEdWwlgWXCv3TH6HlACO4e7kP
 MgnLTkQW
 bBoCw++VB0XJOLg975DlhFGFvcgYg5ia01ZY07ErxU0ymBohNbAJBLYhSSzPUwbucROSPzMlPkyMMh1ugFI3SPsjQ2iX7Z1l2WUo/Ey4pyFsg2vAKCIcBFJaatuhTK7WTbkIQs1fBR8w5B5tWnv9HHnXgnXVjSIeshMhxCdXY1wD+jhkmYc3HfGtPg5aGn0Vc8cv0gEjrelqUHXHfaRQRorAunQQ5OxXM/9Gz4haxLl77DdU=
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

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 9928d75efc2d..cb67105b8812 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2010,6 +2010,14 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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
@@ -2043,8 +2051,7 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 			int ret;
 
 			mem->cc_shared = true;
-			ret = set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
-						   rmem->size >> PAGE_SHIFT);
+			ret = cc_make_shared(phys_to_virt(rmem->base), rmem->size);
 			if (ret) {
 				dev_err(dev, "Failed to decrypt restricted DMA pool\n");
 				kfree(pool->areas);
-- 
2.43.0


