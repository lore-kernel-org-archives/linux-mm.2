Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF97105D99A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32196B008C; Tue,  7 Apr 2026 22:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E090A6B0092; Tue,  7 Apr 2026 22:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D467F6B0093; Tue,  7 Apr 2026 22:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6C376B008C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9314DE296B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:41 +0000 (UTC)
X-FDA: 84633863202.03.FDC9F24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0254C18000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dx7NiL2d;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfPtFj5B5lJqYQYocslP/VZqEDVBz+14COSNMVRnX3k=;
	b=vynH9gJouAxmqHFq4Ormro5bGU0gXC/lwCVDyzlYq/+ay1Er0r+bZfT5PzsKy69CIwFIkT
	6CqoG7XvS7kp+6eqAacbttdK2yoqwmisktLir9bf8cZCKq0vQ07ogedXDzDPAtyWZRW0UP
	1YbVvs5eBzSMz4b0C9LTiGdehIpurTM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dx7NiL2d;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616700; a=rsa-sha256;
	cv=none;
	b=x6EzdT/Eipe7SdovJLnOJq1gFHp7yEdWv4Wm87BxgOnnOIi4Wb2rNJitHRrrra3yeSkA/a
	hSGjpQMmNCx0WAYdbtuM8bwQnzQl4UYzQ47Wt82CHvCoyYiWgC6+Auivt9ekaFVPeHEWUZ
	u1TZxQ6WdjmZDdWk6RpYzdfgSu2Hdso=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 77F9D60138;
	Wed,  8 Apr 2026 02:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715D1C19424;
	Wed,  8 Apr 2026 02:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616699;
	bh=WaU87kHk5fdaxiwAyibksVupa8Ba+++SUKhvjx8Yo4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dx7NiL2d22U6fw3kZORHXgxH7PInpyHrU15js7b2oe2n3ns+9bjxR6fCg5/6GWmbZ
	 X100BzWea1lmMJjJ6MdI4MUdHcBeVF7B5uM/WEvWcCEm8BVy6Pbh1p/3A+RD0RPLyd
	 ibBOiRdc68xmP+7tu0ifGfDelO2NXJ+pGkpj3oWQRlDQvP2UoUKzd/9deSD6GkZpfj
	 CWHUftf54l4oWYzxj53bFKSLczJLFYUKvXew2QSbMul0LTXPMa71Mw+zyAJ6cgsVd6
	 2i+tgpHiraeRUGyW7OH5pBqjXSAwzzFJJYGcfEpN75VTBYNu2rwUlTiNTjPq/GQsBi
	 vAmBHA+W6YXnA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 2/8] arm64/vmalloc: Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE
Date: Wed,  8 Apr 2026 10:51:09 +0800
Message-Id: <20260408025115.27368-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0254C18000A
X-Stat-Signature: 96r7t6ocgb8cuia5jzdnhswnezkak4pp
X-Rspamd-Server: rspam06
X-HE-Tag: 1775616699-457009
X-HE-Meta: U2FsdGVkX1/WFApbZAJuxyYypg+2ZkC3rBj6w5KXCe+tkQpLiplwl6y7ZGrluy/AYfS/ndotDO1DpOGjrQEbYNB4oArPAOlSJoDIpxoFs0yLCObZeAx943XfdOgJtxbjlocoYZGVtUNCwTC+xnzOJwjtff2ku1ap3UjQ5y8+6k9Pnk561+oPYFpBngBHHA8BBTpeoCCyBgLnOyF60q/eXIS8/7gPzAZV2XNGro2s7fcUbMyxNCn8U+CNenVvl5TNMm+i6U+l7r1BDrvp5hITZHxGLp1o9JmmXOcA9eWIWI3zUs/UV64eSPGSyfm2bMyx8TWV7n0dUWmrEnTI1wSaBzsfPIyEgPiDfxgqblASxtnbyG8Xii1qKa+x2PcqTd/8CLsfKoGF1sklNAZNFQQtmfqkfUa8V5zv9ZdVjA6I0wGF/HT7uuqEnkkMmRolsNtZ+Uwk1G6jIoYOaa5BiMKEYwxqxYsB7LKPjloO83XNN9TjtOC3+ONRl8f8ze0o87woiXS9WvOpKSSQjInBrfvmkWi0auRdXvRsvSCnYlXOq6sTRxekrRtZ5G0dit2pogBFgl6KpohNuwyIb3M0osG/BMWthIypjsmL/DX1TPp64Ha66XMJ5fSyy9y8Q6ZiYwp6GzJfYABWhoCW2jHfgbWD+9pcu8PWCQlkILMN6ETYam3bBDlthnFcAF0xJ3r5num7X8FVoYH+rFaGKCRrK0qFiC7rQK2XUsbYjofOaVwQEz49riMADJ6Vt5Jh0B24XnCZPUS/Q/+FrGG6i9BIeCdlWUOkDBtQBW6VUqCoDizRB4RgIwC/cQToGLQL9GPyTqfItxUy3cMPyzdV8qUCLebnxcETMRq2eiq29+RimSh59ujyn1yIs8wsg9V1Ph6JSYyi3qWJeZLzUrK9ZHHEU1m+3eHGYJvvTmcVycS+5u9rVxGUVAQMbhbM3+3h2acFLatWGnaLRt8q7n2hrvSmaPP
 CNRz/Zm7
 uiVHU4fY9BAQI/veDAH9IswhRdzHI1kFOsmaCZvW+Ouo4Qrr7kIMaNKlwJZOxyQzO1qALuHHWzfV2Yh7D+F/fKWlYmPscT+ZUgdj7/ApWtNfgS41KhFLqg4lPm5JcuSFE0bKKgmYYBROa1DpESFx+0esie/VhKryUVPA6KWjCPCWnciFJ6vlE0gboeaXAtcwTWVhoNRlRBwsCCTW1fueGkhfA/FWNimmKg3yMw5RcO92IgdwBt8oxzqzmPYkJzkb5Tt6gcvSOWIhwJSdb+zHkVsD0ZPTGK2tZbz9IIDJvjXZImyJ0b/vXLHKdGdCTCtD2LnYGpQIL8HLN0pLB78ZMLkOcpHMw4EOnfyc5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow arch_vmap_pte_range_map_size to batch multiple CONT_PTE hugepages,
reducing both PTE setup and TLB flush iterations.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 arch/arm64/include/asm/vmalloc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b3..9eea06d0f75d 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -23,6 +23,8 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 						unsigned long end, u64 pfn,
 						unsigned int max_page_shift)
 {
+	unsigned long size;
+
 	/*
 	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
 	 * aligned in both virtual and physical space, then we can pte-map the
@@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
 		return PAGE_SIZE;
 
-	return CONT_PTE_SIZE;
+	size = min3(end - addr, 1UL << max_page_shift, PMD_SIZE >> 1);
+	size = 1UL << (fls(size) - 1);
+	return size;
 }
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
-- 
2.39.3 (Apple Git-146)


