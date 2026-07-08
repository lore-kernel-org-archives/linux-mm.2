Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97711C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65B16B008A; Wed,  8 Jul 2026 19:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA1166B008C; Wed,  8 Jul 2026 19:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A50A6B0092; Wed,  8 Jul 2026 19:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEDF6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:48:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D0CFBC13B2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:58 +0000 (UTC)
X-FDA: 84967252356.04.3AD6540
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 15C71C0002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BWwQDki2;
	spf=pass (imf10.hostedemail.com: domain of 35-FOaggKCEAumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35-FOaggKCEAumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JfihMOdYGKLErlZtxkO4c74/sv22I0BBbL2ChDUSts=;
	b=HQw+dFnPL2ClnAp0nXxSQuCU4Ioyufl0Jez5hVsgYjWjzxuy3s/ORrJG8ca/jcPC40keaL
	cQrkFgtcY22hQCBODB6I5ZJ9BPi1Mb0BEUSAOrKgybOjS0kb0YLbTm+SurJFwOOgLqVeob
	Nfi6iJfQbB3ateMcbIDTP58DzsWcxk0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BWwQDki2;
	spf=pass (imf10.hostedemail.com: domain of 35-FOaggKCEAumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=35-FOaggKCEAumjcyclciqqing.eqonkpwz-oomxcem.qti@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554537;
	b=NcUYdx/LR5Vv6re3WK62r/q1GZihSRgq7XiJTYhFV+vqceUY6HUg2EPGJoWNv1o1qKsknG
	RxJuyc16wT71ENVdvDivn1le3C7rqVBerXoh/Tc55Zm2OLyAQ61VSEzyxD0YeREBcrUBus
	Fq5wZcd9TDX4o59gZf+bmwa5N2ZB8lA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-845bc2e658aso1365038b3a.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554536; x=1784159336; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1JfihMOdYGKLErlZtxkO4c74/sv22I0BBbL2ChDUSts=;
        b=BWwQDki2ZcvoMjQdowMWsm+g5Mcqfn0u4aPTLNrMuVk2f7lkFWpndjsb1wMGimDrfP
         Cw9mpWPvIb+Xpe2iG9DSxZCyVp+BIZwb7Lhf9exsg/NqdMZKITzTrLBEgtGyvk1oExB9
         ZYnG8zm3aXBAyPsyIKj1lGu2ZAad14C+IfOyjLCS3bZuWnzkSOGQsbdmVDgujlBVBHbh
         9rrG4zC8EUztwBZDMeaYJ0JBv3qeY064qs1D8qI6x6ENwUzsXBKolt+i4/goJM3nfk9w
         rJsDNylBhOmY1/r/O9YMn/LsC/KnEPu/yqsbI5CmVJHljY+1htBz13Uv2TZkumWadkYI
         sBFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554536; x=1784159336;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1JfihMOdYGKLErlZtxkO4c74/sv22I0BBbL2ChDUSts=;
        b=cWJiuL6R8j20CNbBM+54htRFGlxozi+yXPXIU1LKYTPo+/3oUnmeTGd3yTQ8fZ7w5V
         l9ZSwuj8m3k4TnymaM91FXMT48cZW2lhWy+SZ6bJIuDfJ8s0NULeFv6oSdNhxKXqky1W
         mBQagl35u2vgbVJq3tDAyO2Jcd79QnYD+s+ID6JcLhwjTkULJhd/HgF0UrrBhGudVNaE
         gzX9LcpjeyfgCLFb9QszO5ShUASaaWDwf/20o3GsZ8RYo33VwuHGZ7mDbia8w3qTzSBV
         tpkzdB8skbs3uDjr9fmZXZplUdeWdSXxNwy+7G4tf/NOpIWj5T3FRq3QjxvAMzIX8yb5
         Q+tA==
X-Forwarded-Encrypted: i=1; AHgh+RoiyK6sx/b32YQQeWgyW8K5bwIresTrbmCd5P7mzkxAaR2+KCilt+DatKYvBZcZge8SSRRL3ErKZw==@kvack.org
X-Gm-Message-State: AOJu0YwjhjYue84fV/hsf2fGocviOIAwM0GkhBNdxhvcqTYh6MXAZk+D
	p4Ma9OXBfUmvLnyMKolsHXqipe3GdeaDcoTh+6w9Dzf0WbuCavMynyaFN13HGh7S6X7W1t4fZqD
	Bg7Fz4rt2mq2jLQ==
X-Received: from pgcc16.prod.google.com ([2002:a63:1c10:0:b0:c8b:2706:11a7])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1144:b0:845:ec31:26cd with SMTP id d2e1a72fcca58-84843436d38mr4585247b3a.46.1783554535737;
 Wed, 08 Jul 2026 16:48:55 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:45 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-2-skhawaja@google.com>
Subject: [RFC PATCH v2 01/10] dma: Add DMA allocation preservation KHO ABI
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15C71C0002
X-Stat-Signature: gthua8su998wdf9jnouyhqcstzot5qcp
X-HE-Tag: 1783554536-217610
X-HE-Meta: U2FsdGVkX1/4AIyugbF2uVrp7rr0iVOPHjWMiPNs6DvW7XeDykgKITUiKknFZsYZJg2Ev8uDXFPr67IKyQkQ0W6RleD3rsFIj9NVoJXGBGiIEwNXjgxjJNS7hn065BS1EP09Y26lm3FS0TNi1CVyE2xRgupVz4Z+9xL+WBjh7KNeZ96Sh9WVpBiUOfi27M0sxkkAgHLw/3d2YAco+smGfHDtbfN2P6L2P9zyFwvFTfFMXoNDUA0C+rTXUJ9JLnGy613YwFh1j4k+ucnoOIRjP5Gl6LA6WYBRol6X+VAWjjqha2uubmk7/9Qf/lgzQSG+WoNDwD2cti4ehIGEwC0nSIzSJQuZaUNXOmHwSKrLDLJCLpPPVM6+VZ7sIZRrCg2ioFcZEzGSYGnYhh7Y/oatNZ8Jn4ylNXdM8sc1KpGtX7kWnl6V1NIo3BatIkiGalq+CXTAWVShLW/ruklF6JoAOuY6/qiQ3Ma/1HtPKF5CzHvXVhkk7WXfaFmQBOXNlfd1fIDUFYPgBrlRrHrtrYcXmmM1vfVGdJooUah6WBVU0v5GTAoONUoTLpbRlqfJ60ab3q9tXHtuX28uwbxY9fR6RzC/U+4yTNYhgY5SznuomiBpiMjl5rELLzrbXiSSBmjYR9KwbYPaGtqSGKWtXIJkO0yi0GNaRyIy8c4EHASABFauG9AT6EmQF0MFVq6ZRmYu+CKpgAT3z35U+3qn7xQcmq+BwYgYGjB/yIBXmhy9ITe6aeRQktxPXHyR9INidCRcLV2D0UOUXqBLGXb9x5PV0DjIz2DD+GevvS+Et/wWHEVeOexkOYOQkpfnVPHTklK7fywqxxh+ePzFpBj9a3rj+ZKn84uHTBshO9yK2dC8XQmt86y23qiym0VR1/+/7etFhRl6aazamvEN0xQJ6NaHoaua1VKZ6i+jFn7UTcyL2qZ+lueH9iB0m5fM91jeP7adIa9JJJZidkFx2vjjNpy
 0BVKlLjk
 aeQ6uxINfGq2M1KRwpzqowCHrdYcQQaRpjMKL/4oi2RUCa5u+AmBtNcYFlLrx3aV89BUTE0vWvhiyXZ8TYCpvURRqOg88daIwDB20K1I5Q5XnRCOpE8DFlV5vv6h/FfsxPuAPAaWafAQiuQwpX9EnOqD6GcirXnupgg331X13Dk1WMnrkXxP6Djlabjd40V8lTlvdBkSsWI0kYJs4btBt3z/1tdI1zzPqfZ0kzlqZKUZoChP30s4TWiNJJusE79ELV+psNmVY+9O1PA8p8HksWAVlhQ//JE1bxYXsfJ50nkF7GNrLkrd2ulNR9W/S/AvPBaKXQQC+OQdRCvNRXqXN3UTbl5HVFk3//zwddjA/1vVHh1OA+y0h7xECL8nIA5QD9PSUFVrNvYMEHgsd/RvpBzn4tR3sT+RKPOboN9b+nRwNps4YfJej4kf41EEa79gWEGBZQROv+6T1bEcBua2+Evi88VbNrpVwOmssAGsu4RgKrXW6yKUZ3Inxoh34dBvI3sy3Bpom3QZI+H7yo6V6LWCxhUsH3o891SkaTCZM4zWtWZGRCQJC7XWUkkzUO8CwKiNeYYyHxbim4V9QIm83NJCYwg==
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
 include/linux/kho/abi/dma_alloc.h | 32 +++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 include/linux/kho/abi/dma_alloc.h

diff --git a/include/linux/kho/abi/dma_alloc.h b/include/linux/kho/abi/dma_alloc.h
new file mode 100644
index 000000000000..ae38cf1a1fc9
--- /dev/null
+++ b/include/linux/kho/abi/dma_alloc.h
@@ -0,0 +1,32 @@
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
+ * @attrs: DMA allocation attributes
+ * @force_decrypted: Whether the memory is force decrypted in previous kernel
+ */
+struct dma_alloc_ser {
+	u64 page_phys;
+	u64 size;
+	u64 attrs;
+	u8 force_decrypted;
+	u8 padding[7];
+} __packed;
+
+#endif /* _LINUX_KHO_ABI_DMA_ALLOC_H */
-- 
2.55.0.795.g602f6c329a-goog


