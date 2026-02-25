Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8BEAFD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8366B0095; Wed, 25 Feb 2026 11:42:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398EB6B0096; Wed, 25 Feb 2026 11:42:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 212C96B0098; Wed, 25 Feb 2026 11:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE846B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:42:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDD3B13B4B8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:11 +0000 (UTC)
X-FDA: 84483546462.04.F1FB252
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E1CFA18000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:42:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9SbsQH4;
	spf=pass (imf16.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vrsWIzRkDyevKAzf6jtbUNKKDPdp4sokIwc0BoZgux0=;
	b=l/IHhoH93dVhRg2V9KBeBLHiiqLY08CMxXFkLtaws1XnaWHZYmLwuwUi1x5dQYGJsEi5eH
	NLx6MaE1rIaDDjABsOjvTl+VYBVph/w1kZiCkAoa10k05AsnkJHI9o5QpTvCvPfUVMng0h
	7yf6mvAPGfyCu5c5G48NyUGN+YOvgtU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R9SbsQH4;
	spf=pass (imf16.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037730; a=rsa-sha256;
	cv=none;
	b=56O4bQXGdHp5pQDl1Gxmz2w7c4wcWuJKNZPccFnk6CulJ78O5csVm8IXt0gEdkPe/GHDZ7
	hWDiBQ3w7Bm4Fj+R2Y+/dWH70Oy/ZmU3m6tC80Bm5vxYYoPR3hve7foxj3bQ8vzMPc6+da
	KM/CiH2o8JLr3P4BICQCvZzIm4Lh0TE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02B89444E5;
	Wed, 25 Feb 2026 16:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C74C19422;
	Wed, 25 Feb 2026 16:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037728;
	bh=5t5YBl6F2Q9NBmrbuy0kWi5Y1JLcv4Ia1Fv2DnfmLP0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=R9SbsQH4kO433LJbxIRQ9G2QyIvijqX+2UUdxf2AUxhpkZL8D/w1n1UnLOE5WcFHo
	 W7SnFVYG66c559MuvTJfU6g4OrKlyo7phg49rhhs6jppBjtf+u6SNVc8bIwsdjRrHB
	 ylDLpReT23aVYZp1JXVTm/ckzy/h9XZacpwGuWKcOCmiXOFiEPsdEnvbBV7C/HS/11
	 tT9zghsIuqAIhm8PKHKgLHVKNuAfAS3S1Z+unOmWa8txIeH9YgiZ92aP8lwlP+dvh9
	 KatmDuDrBKraDIZwCsQDrmLXCCpX4Tla0yk2aIZFbHV++fuiHkqFq2jlLL2kGuMjPS
	 iAIxksUcUg5Fw==
From: Maxime Ripard <mripard@kernel.org>
Date: Wed, 25 Feb 2026 17:41:52 +0100
Subject: [PATCH 4/7] mm: cma: Export dma_contiguous_default_area
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-4-2109225a090d@kernel.org>
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1222; i=mripard@kernel.org;
 h=from:subject:message-id; bh=5t5YBl6F2Q9NBmrbuy0kWi5Y1JLcv4Ia1Fv2DnfmLP0=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1fwlD7HqzlzmFiUT9/locsXjSdPy5/duZv67Q2xH2
 cMJE172dExlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJTJ/LWB/ps5DNXZhFfnPS
 0a/znj9cOXHb7Xz1BTOTd7PF+XT2KHwQvFN/ht8lk0Xkc/T6mR8KMxgbFu6MVBDJ9RL69WvG3mK
 ziocv1YyVTp6YUjW3Oe9TtvEBpZidmxSFCxta5F9+Vk6p4hUCAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E1CFA18000A
X-Stat-Signature: iy6gnmia5unpaepmcfdiitg7xitsg7pk
X-HE-Tag: 1772037729-493847
X-HE-Meta: U2FsdGVkX19gMQx04B7vzIvVFoBd9ceqVzy2vaJEi7TsE4QUI4idNDi9eKOOCasILUD3J0ewMsv/X0P/u0IrHExueihN+iFXMRJiUwN5CGazRYQGOwyiSX73pxFpu2pPOBw3Ibg3ZN0U4CKKPdcqqA1Fgwlu6cqp2FUy8Nuh00JBznErlPDjSbun2t9fqzsLKGFO65IO3EZSyaCcXVZr2ZEwYrHcUOdpQFr14ir5cciggCY0vg06T1o9COSwEDxblbQX9UD9ZCo+XaJio1DCWK2PXw0Jpu8oQdbn6IObCp1e/AW6Ss2aO7gl3tnPC8AW4/DcWz27ppi+BYxZlXAIdYmKCoD6QhtiU19RioXkF3ZaEXO2IJ1tAwBIcTi4DBDw1XS1dpGA/QrBOowzx+EcO4vx5WU0POcGNQaqvavRDMoW+wacU6/f0wI6ySA5VSmWMl80KZWE+dvI7GBJ6zV4nhCf65evomGJKcW4FlGCeIZUmaC1NTxmhhBE3E8nuSv+XY46PgCuh+tUgzFeUu3Nc44ZKLEn5zw+CtqfOMX534DgzIFyLnQDFowV9BmHfLSoedOGs8u8Xbn33xoiNhjQ94vh7XKHX4W5Avxmh1BDrHgdk+otYn6CUd7ZiUm6ZsM0hGLh4U55BH09FnMkbwmSB+4WP8rcWV9xgWJaphJCHZRTkWD0jBShOKloVxxy/ggG12bqIPhxp/Je8Bbf57XeE9it1IV3yDJI/XTOGEj7U+MqWJjKXoW9X3j0v7hxDgARF8NnVCg29ZJkjfYwBYYloYyRa/fU5MzRl1yMcUpoKsVqKoCOxLFIxByemRPfwyGkjz3k1NRc6Ml7tWLF52MZYYtgXglLSMnHAaE6qVZ+oYUE+FVSJiyTdMMEQ17Xs1xeM9U0hmuYuu0pkB1t00kqiotJfCXos4E1l2NFX4BWbRhwJa1avQJe+kbtl5oLfpKveoe67pelWEqA6PjVIwp
 JixCtelB
 6wq/9Jn6RxWaIfuyHQ3odziAMdiHpH2vo4XtljyOIGbx9qehP8lw6biHuQKO5ezuzNdBxIw8ZxudGjrc21xZ2aGORP8LSJHmFZ37QEaDCEsPrRYATgYahgDJmy5tLQCEpviV4u5DrUotnxWhECEotK35L9uM9DZ/mTlFSiwSPoplBMK8hmBoRpyeGK2BGC5LbnnUhMEb0u32wre9+Hj1Pc0ZT/bZ6w2kD4cWzWIhPqfFFHgVA1DG2HDi5FVyVByS56hp6jnL/Jtq3t1JLbPKeI7/DGonHWvEMwVhi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The CMA dma-buf heap uses the dev_get_cma_area() inline function that
would either return the content of device.cma_area or the content of
dma_contiguous_default_area.

The latter holds a pointer to the default CMA region, and is stored in a
public variable. However, that variable isn't exported which prevents to
use dev_get_cma_area() in modules.

Since we want to turn the CMA heap into a module, let's export
dma_contiguous_default_area to allow modules to use dev_get_cma_area().

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 kernel/dma/contiguous.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 14bd54fb758537f01a6fe27318e7b683964e20b1..fb64ccb99243e3cfea4890391a723130db69ee94 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -52,10 +52,11 @@
 #else
 #define CMA_SIZE_MBYTES 0
 #endif
 
 struct cma *dma_contiguous_default_area;
+EXPORT_SYMBOL_GPL(dma_contiguous_default_area);
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
  * that works correctly for most supported systems.

-- 
2.53.0


