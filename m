Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37988606D835
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZaU4mJTK
Received: by kanga.kvack.org (Postfix)
	id 596906B05C8; Wed,  4 Nov 2026 11:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E636B05C9; Wed,  4 Nov 2026 11:49:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1E56B05CA; Wed,  4 Nov 2026 11:49:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1852E6B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:49:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 71C5D16075C
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:25 +0000 (UTC)
X-FDA: 85398022290.21.04A748F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0B4E80009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:49:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaU4mJTK;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810963;
	b=x7L8RHgOiO0vH8xGF85r0i0kXAa9k0diKgYRx5PyIyUmC61+A6W/+8CPZweBZVZiI1lDhM
	1mHtJQpixXjqH2KxstOdF50gt7LbYOJgU4qlNSnv/Gl9E3OAR8bIXAuCPcyByuARXrqTMR
	mpsjsxIFCTbDxBw1A9WuElf4lR8yRPk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZaU4mJTK;
	spf=pass (imf02.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/8vjYvtupLf5v8TU9CZJ1WziBquBZCxwcYljZ5lOwY=;
	b=xOPfz4tm9++x+8eR1ZY3M1MR4aDyB4bLnBc/I7afOOdR9emRKXJ9wdsz352XiWtoe0Y7OH
	KGCUUOu/uylfWV4avsHNupk48Yfi0Qyx/q+Go9PSdyiKmGrTHRaH+mvYvgjFFvgSBX5mWh
	CZX1TqmrilmREjaIry9G14QtJpNQz04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0A20419DB;
	Wed,  4 Nov 2026 16:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93C01F000C1;
	Wed,  4 Nov 2026 16:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793810962;
	bh=E/8vjYvtupLf5v8TU9CZJ1WziBquBZCxwcYljZ5lOwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaU4mJTK07JhJXoOkHugFNOLKSBOtcBwxVlKLdiuNzvBXN3LpTwlbBjFzVqSVbTH5
	 LuzRV8aOWucDBQ1u9vOK0c+4vhcf/3rYEbeq8jcehdhHJ6lF3LgdylELGHFOcisJ7t
	 Fy+EAPnct469u07A8EYfuj2ozRASkB7gtHRUuDSp5vUkpujtSRh3FPhlAjA7Dw+UgF
	 YacoSPx62c9Q2O6xn7F9aYhQ6JDOUxRkw28L8HkO5uZtIP4e4Ox78fAStd0D5p6eth
	 mxnUf4FsSSf4xVn8adZv6TbiNv124uPo6C1aJORBOTSNnHWHbDc7S4c3yUtm0rdH2F
	 Ahf4K0XkiJutQ==
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
Subject: [PATCH v9 09/14] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Wed,  4 Nov 2026 22:15:50 +0530
Message-ID: <20261104164555.3555725-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0B4E80009
X-Stat-Signature: 7oaun7q3xs7hzjax4ywf86d61owxeurp
X-Rspam-User: 
X-HE-Tag: 1793810963-656541
X-HE-Meta: U2FsdGVkX18jNjcOYUeBvJqJ5lFL48/tLTdim1TvVogOYL9k4b2wabmUknII2WIL8xbACL6hE1Z7u7f+wAG1YSRVpedVIEA49zYp0vzlzUx2YOtB5gxsmcIQgnU9cpW2mnCFhrJUe8NKDppcVVQHUJ59P9Ky7aj6Gq+ht+0gshqvd+SWWPTnYyxzmvDqBetysDRYWbc2FEAVkpJjnqjAWuGb5gtEzAyQ2DEG4zhyIYH5ppI/SlF/+To3O20eaO+sGnVql5hEow+xKI5gPEk/tDHs0kGsrx1PxYo5Kph5J2/OjS4iAePVyaMwN7u6ydodv6cca05W/Ve/dNWUEhJNupfMvUQmRoFw7SIV7yfFOsqO10aAvLrAcuvlHnuZn9Fj6FrPB0WJFMZXXxUeYo0dQUs87AYFOY9cCyODrfc7tcqXK0Z1XAwcFYD0xBKcKlQkfw+zHkSaKY7Cv72Bc2FScaPT75f2xnlmzf1vtsdEZTfieHYTwsY0DU2w8TSlTFIIzC9LjXusIszlYd14Yh5EZjAx010TDOPp27Udu0aJnOjtpwrNMPZ+lVzeUazeFDakOawXbAU/sY9WHgozSoov+C1m56B6sHrh6C8uklwGQ95Zz0+1o4mo45/NEAkkfiU2TKAHZ8wjre0rTV642Mk663bn2OimvVuxTDq9fjoiANYn3VZkD3ymHrB25zSvdEhh+sipqoZWoaIWO3d2L5w9fzlnszLqv2S1bU/e1OOosCeEYKiG3yPOHwE6Y4x/OQ0d3NQZ8CaEln2+J5sFMCrsAiXy9FAqE6uVojPYHpi77DQurpdpi2GsixvSs8RZ1btOTITFiEM83Zc7K9wx0HZhMVPYaSIDPVwx0p0zjJka8iBMr+Z9Bu0nvwClIqiq00yjIqGHINz8hrVv5MJFRrHHWGDWfTAlb5gJR537I4f+uiOsnyZHmAFAEkyPInp1HJXXFBWK7Cq/EN0O0wwcycs
 DdKu73Q4
 ecujYCocsyQHW98vLj93HV6fCzXO6CQj2FmZwdyV0Pd11d2lMSWwFUEGhg3m/xygh44x05etKcNkUdCYo/hcAUtY+5jyqvu/MdL8Y4CsFp6NSYeLh1yDN/oXmIMlMTG+aRO9E4NY01NuJaTg2nUfqcf9oHqMyWzdiQCNDJnOu3bh7tQTQ5gNaSsaoX+dwZ+5sV4Bkmv+t53KnhVvDdm52APLErlr6LVXrwIcidOjO6zWWxoMAwTjXeoqrM6+wkde3a5if7uXDWD+eiHmzaMqangjblJ1yGmiT7XLxoH/WxW0MGVZ8O9/nWPwE3xZWFqnETDILy/9d7Q6goJGN2yeZnkXKA4JWFTTeOD7a1xpMBnZuvszjPfckek3Oc820WrRmO7Oa5g7pTcnZ7uE=
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
 kernel/dma/swiotlb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 36fbec2241e4..a3fc33c54cec 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2011,6 +2011,14 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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
@@ -2044,8 +2052,8 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
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


