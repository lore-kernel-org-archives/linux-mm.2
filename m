Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76ACCFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 00:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95896B008A; Mon,  4 May 2026 20:27:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DFF6B008C; Mon,  4 May 2026 20:27:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB5A6B0092; Mon,  4 May 2026 20:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABDDB6B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:27:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B762140331
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:43 +0000 (UTC)
X-FDA: 84731478006.11.7088694
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id A6A3140002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 00:27:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U18LH0n6;
	spf=pass (imf12.hostedemail.com: domain of 3fDn5aQgKCCsZROHdHQHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fDn5aQgKCCsZROHdHQHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777940861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+FOv1S5jZxTI8xiOq/TIFYAKVGB2GSKJ5eXMG7ksgc=;
	b=Fk0Z7nfG9tJz8cVUNauJQkWhMpTF5n/DXBHqUlxu1LIq4+ut1u2M+86fSIyDy9UeaE3icm
	NZNIA+FBgmlvMhsAluKrO8EIg9bNnEJLb1GhGntioqBfeWSgP6L1VthmFlLv31LGoZr1bz
	y+DA70k91cq9nZD7B3cyBtZRAWGEqMw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U18LH0n6;
	spf=pass (imf12.hostedemail.com: domain of 3fDn5aQgKCCsZROHdHQHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fDn5aQgKCCsZROHdHQHNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777940861; a=rsa-sha256;
	cv=none;
	b=ZfHcj02sYdHWpR5Y70eaLCUAMnBQtjgNvLiMZlmS2iWK4HJz6nag05JOO8c6Cz7XuZfhIF
	O6lVNS0bbXuGXxeEVtB+mQH55AIOeSUl3jx5zFBMFbl8rQT6ds0IS7JIUeWBt0c5wMYMaq
	oB7zAlvSDGVlGgqqLTTq5/t1hHNwFVM=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c822ebaa40dso578663a12.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 17:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777940860; x=1778545660; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+FOv1S5jZxTI8xiOq/TIFYAKVGB2GSKJ5eXMG7ksgc=;
        b=U18LH0n60U7804zcxpLpTWNgEZvElRPFmnEn4tRRUn2rOiLIBvbfR4ilE3AseTY8Fe
         MDMNYx5PEqkph7jF6EYlGW3WxWbZBru2Keeo9Xn0F9Ao7jNhLCyBR4Su9Koq09hekz8p
         jaUcZrJ5xV6R0KgHMkn5iuqmsfu90ng6ADE2WZBHGguGsbC1D+O0Tmaf5R9vK71hCI1j
         bz4m068YIuzUnBp/MjUsb3MdYkRWd3uRAe+xW4LNT7f6uiXndIKu0T8DJ4LhimEHXM1V
         VoFsAyfDlmHxAjadDYZSTdXXoqwm0Hrafs9LCPvge21g91SuW1RI5mBySe44n6GXQ1y/
         SEhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777940860; x=1778545660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b+FOv1S5jZxTI8xiOq/TIFYAKVGB2GSKJ5eXMG7ksgc=;
        b=GFb18B0s8ADCAGvlu4UtZII6ADpKLdFPWvXKsBGKHKM57HHwA4CGPDLVFejbW1SWqc
         74qbhg2RE16yCPWdHxNiIgnBtcYDCrkI4rc9fIvi31cuTPw4xj3mN9ahuQ9CLOrkIbP2
         i8J82iCd0r4GVe4/pKJXya+rskMFIJ9BIeow8TJfLXKXgLZz+xOcWJ3bPxgyovHRhiBX
         Wm4BXzo2ShGpi2Xwsh5v/zwKwOXT6Xiss8pzJva2H+q+VZZLi0aduBHm5bONs9coI/fE
         D3WJi1mGPRKXLw7TRspDgZexMruhnV6p7yvG2dqkH0wz9g0/Wv16HS3dRTUmsCF5q+Zg
         B6Eg==
X-Forwarded-Encrypted: i=1; AFNElJ/2sY8LrUJ/I58gEtk31WqdJBwO+IaBUD67dnqlbDYK9CTb5uqp7eMs3fZaLT93N31djCwZTCFLNw==@kvack.org
X-Gm-Message-State: AOJu0YwmCrbCEZnrqTVHRjm28Gv2wi8vemAEsDXmkP3m5Vh1LMVKxfEG
	6rbqoFfwlO3fnQZUEK+WBjn4vrEbCCbtlrQn9clVyfdi/oVxC0tg9hSseXEK7ywAvac/WmGyjiq
	f8Euae6LOToSIag==
X-Received: from pfnj5.prod.google.com ([2002:aa7:83c5:0:b0:82f:8a3b:87f0])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1f04:b0:836:5c3c:2051 with SMTP id d2e1a72fcca58-83923d96a31mr1009427b3a.23.1777940860319;
 Mon, 04 May 2026 17:27:40 -0700 (PDT)
Date: Tue,  5 May 2026 00:27:34 +0000
In-Reply-To: <20260505002737.2213734-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260505002737.2213734-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505002737.2213734-2-skhawaja@google.com>
Subject: [RFC PATCH 1/4] dma: Add DMA allocation preservation KHO ABI
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: km6g9joyc6hezobnbdjso1iyo98bsqbm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A6A3140002
X-Rspam-User: 
X-HE-Tag: 1777940861-783290
X-HE-Meta: U2FsdGVkX19gPvlqQpAvFQRyD1M2Bhy9lUgUgcv1vO0vpzcWWPPFmkDOEPOvzK0+j/J/wzUH6vJ/Uqx40bGL1DWFHB0oI6wQBHAc5iFyomjyHTHilVlG0aUDrCc/H56G0NEkEDHVK2o9APeMH1oizKLnjXzXmFNJMb7LAddLjRuQo2oNFguYioqWmvV/vjAky9e0tPnREax3k15uZtM7J1+U2qWjA1VQ4+gNmOinNgmejzJc3Nxuzlkg+IpCf54ZkISC7QGSwxVvN5gseVmcy9LxqFIkROhLk5dhiEM8GIpotsRK01ndWdYc106AmLNGzxb30KwjX957sUqQZT3rOX3fxmBxMpt1UzDyN9Dt+Tt5dwi5rCpXvvkjvvAbR5CHdb5UmpxcDaI6BM/SPAmwwY/D8rL2zCzUKek/wB5k+cd5tdUIHAKRzbpbxWDfep8mB9AG/du0zETO2a9faWjrKRf+qUlrsWv4RBQsHIgI9xoW6QrnGPE91Gads60pa1CUjzD4U+TY2q6d03hWC8rlyeZ5emd15qngG897segFnn+b18h+bXObVKjloFwWxg/ytv3U6SdCxvFE0J36EQFZVoD2cmUHWa/e5WrvPIULaUJuNBY9KrpJL3xSKgZiaR9F3ka0tywSYUu6Ti41/ymb0UddnOWEfx3BrXIyvunS/QVyvMaRwjWbjOsoctJWya8eQJB1GQDcCTL0+Wuc3nJFdN3edAWsTlGmecAZ6jb4CsW9vioGnAvEHH4X73h3pOIk29zvw6NSyekBf+VmqWqfIHfPYpLUKHZH6gzNDUsnklMCFKt/lAsZfoILFyugreyWIYqSzN+1a7Y9T0YzT3Vd/ZbFEl+W2cLsoDD3j6hVOu0vU3Bsx2MkFr9N31FiEyY6WnDqkAthfSbYgU2dwjI8dwvKRlqA2INpJzto3bQR7BWhPG9OQgab6ZsBp1nLmM+6Zr4UrfSY1FSFcnwgAs6
 99MJNhw4
 t7Kj/rnXHZzn9/w12p95jqsl+Zir2zoVi+sUzQq30Jotj1BJvZXhY/PWT+mF2WJRV8ISwC8VQIuKFLm/wtaR+u5SkYrpiLVOgWD7bVtjyI6LPc+/FuQ+KNrbPJ1Hl2/rfeacQwZF23/BvIUL33mC02ByL7fBIYrPMFRzNsMe4piS452/JXDJwnaJFRfy0ZS6oywfpPybnSjnTVuRwAxbwsB4D5Ub94Mwry9pbByzJGsWrRp7YeYLQWnKKeCkatuy3TFsew6krTMeE8wcHZRaebmeMbC4dQtws6kYKA1h7tKBlGU+VtNaGuUFmZTZfN80auNZDZoa0aww1qiaf9bsJDAwTfCCGN3Ya1fSc6pY2zyJvgV2h80UnzCgNmTUSQVULsO5NUIlK2tcUtcq4lYFNuWwYhihSDjM2Jv0aJIKGzHKpulg6AGHdKBZt/Coo1PClx/1pKO25aeTPiEDTSsHZqEjM1fgcRMvecICtciCXcDM9i5TlXt+ZGxwrzmnXT+gJnD6ibvRIS1bzcBrWjySmNV/6lxDOd0RvrSZ+nIgd32zISvRAYOcgKOfn4nUp75krFUzVpn/ESdvuFxkiCxICEX8KxcxUibetfjGikZfpbmcJkG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DMA allocations can be backed by a variety of allocators. Add KHO
ABI for the preservation of contiguous allocations that are done through
dma-direct.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/kho/abi/dma_alloc.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 include/linux/kho/abi/dma_alloc.h

diff --git a/include/linux/kho/abi/dma_alloc.h b/include/linux/kho/abi/dma_alloc.h
new file mode 100644
index 000000000000..46e61db81abe
--- /dev/null
+++ b/include/linux/kho/abi/dma_alloc.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KHO_ABI_DMA_ALLOC_H
+#define _LINUX_KHO_ABI_DMA_ALLOC_H
+
+#include <linux/types.h>
+
+/**
+ * DOC: DMA Alloc ABI
+ *
+ * This header defines the structures used to serialize the state of DMA
+ * allocations, done by device driver, across a Live Update.
+ *
+ * Only DMA allocations done through dma-direct that are contiguous and
+ * allocated using alloc_page are supported.
+ */
+
+/**
+ * struct dma_alloc_ser - Serialized state of a single DMA allocation
+ * @page_phys: Physical address of the preserved pages
+ * @size: Size of the DMA allocation
+ * @force_decrypted: Whether the memory is force decrypted in previous kernel
+ */
+struct dma_alloc_ser {
+	u64 page_phys;
+	u64 size;
+	u8 force_decrypted;
+	u8 padding[7];
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_DMA_ALLOC_H */
-- 
2.54.0.545.g6539524ca2-goog


