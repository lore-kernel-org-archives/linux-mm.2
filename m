Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71196C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E746B0099; Wed, 26 Aug 2026 09:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564F76B009B; Wed, 26 Aug 2026 09:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B716B009D; Wed, 26 Aug 2026 09:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1601D6B0099
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 568EEC03AA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:18:30 +0000 (UTC)
X-FDA: 85143474780.25.82993BA
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E5CF100007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:18:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=cptM55Wd;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rw0+g5eoKmahgtE3CqR+4VOpRqHEDZMoAaxPRmz5Fvs=;
	b=Zm5l9Bojnz/GLYfZ5pK8XubHa7UCTQXCsNFkkTFcmB7LAGdSDy7swHQ+92liKtCm0c4vqy
	Lmbb+h3cYRopsyy4eNWriMffMymaImp0MihxaXfN8T67zvXTOKAezi9XU94LOstmTIIWRX
	jTWngHujmqBKUUudarpwtVVo1AeIZvs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=cptM55Wd;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750308;
	b=JLPe4XHN6hUk0FUh1QGF6SmrA8Aw+xQ+bhO6J52qV0x9/ayUZn1DQvhZXQ+wmap8O2XsuG
	vA4Kc1kSWowiIJWWwXNDuwuzzuFSICaj2d+xLJnT3Okf5QWv7AGDhDpnHlM5oLh51vXWby
	wfPe5S+FThCS1SzFSVAEGhEIt4gBg54=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260826131826euoutp02435ee2d0afc4fdbde2aac2f83f6c53c0~PXW6a4Xqh1127211272euoutp02B
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:18:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260826131826euoutp02435ee2d0afc4fdbde2aac2f83f6c53c0~PXW6a4Xqh1127211272euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787750306;
	bh=rw0+g5eoKmahgtE3CqR+4VOpRqHEDZMoAaxPRmz5Fvs=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=cptM55Wdq3sMeNOoEAR2ynQcJThhoMnGBKRBzr9uCY0ycpNq/GnjNrsGnTMeYDWFQ
	 zFKq+MdvUuB9EaQ2BLvBkgHviwBbs0TsvFFM0TYIKIKWk0aD3nWdFpWcMbXRdLdQ35
	 XayFhH7ICIF7Ax4Yrd8o5ZmBRvwcdYLu0NR0+nsA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260826131826eucas1p21156d47d87f5b0f5206e81457ae63092~PXW6KCuYl2176621766eucas1p2g;
	Wed, 26 Aug 2026 13:18:26 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260826131826eusmtip2a69d2b2f4487d00ec98febb8fe8a669a~PXW5wXy-E0873808738eusmtip2V;
	Wed, 26 Aug 2026 13:18:25 +0000 (GMT)
Message-ID: <cb8a910d-a1e8-46a3-bd3a-bf56b2a2848b@samsung.com>
Date: Wed, 26 Aug 2026 15:18:25 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 5/5] of: reserved_mem: retain static no-map memory on
 init failure
To: Wandun Chen <chenwandun1@gmail.com>, robh@kernel.org,
	saravanak@kernel.org, rppt@kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260818092420.2859026-6-chenwandun1@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260826131826eucas1p21156d47d87f5b0f5206e81457ae63092
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260818092456eucas1p14bc953974fe7bb755d530829af4060cc
X-EPHeader: CA
X-CMS-RootMailID: 20260818092456eucas1p14bc953974fe7bb755d530829af4060cc
References: <20260818092420.2859026-1-chenwandun1@gmail.com>
	<CGME20260818092456eucas1p14bc953974fe7bb755d530829af4060cc@eucas1p1.samsung.com>
	<20260818092420.2859026-6-chenwandun1@gmail.com>
X-Stat-Signature: tc519dfcx7yimj19nrursic6d1tt6zmj
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E5CF100007
X-Rspam-User: 
X-HE-Tag: 1787750307-435564
X-HE-Meta: U2FsdGVkX1/HVU28TRfLlcCoxidGGul4FfXvdBAw5o93jAiPsJJ0BFPQS57WvxEF3VQT1zM0dThRgYPxp1v6CbT7/Cp/kgYAs7/EcP50XcpnxzGX+I3ZNAhngcluA92u0pGcAZVUWoLbkGOQbUXbaUvII4EPdSxRvIy41xzV4lNE7Mu8uSj1iIIbBvTKQ2gq329EU8S+xksImOQIiXE91o8TPbgJdf87/L2FL0KDfBVpwUiR0juUnDN7t0e50UifTncfvDl1dTqp0P+T94dxKWO4St160TkXGv6jsWqEd/UJaR3QsVZCzID5xmptAFoQpaoKi8NwEB/CB6UD/C03SeLE6t9dGk53alPpCmTLik8G/NZBUinayb2WOIVxMTV3gbEMk1wn5cOx5AajMJl7vs55Kam0UFX7tnyK7HR0bDSj5x3vEk8iB1YaKxPnJTiyu65LQCYuoX6qUs34XZC/s3ebmh/u3xYuQysPBKTJRYW8ircXNLJKY/xKLsd3575sDsBDHY2c/tdl70d3DB6V6O/vC8zZnc+777/uSw2N7zSx/iY5dDS7jJQrAdH67cTfhPuVg4J9S8sD80usNZ7BnyrIgZzKPRH2sk+dURfICxD4Ge6fMC5KYf/MaKe1R/FcUeauhxCtXHZXU7bvjRyYj06mj+qez5nH38iULXPdHdKDCo4fs4DTseEoPuPDR467w0jAJcb7uzwu4u1Igc77BZSLJZPU2REdE/vQUh/7oRluH/LN+/e8xQMx/JE07lu5QSwsyYvCnbR8lq1X3zdRXh3CeDubmKjnSHLj6hL54Yjp/1nzDf4OxMJyC/JsKwVHHb5lVIECJM9dsrOyKokZ4Nusc/nwrcTeBral/6UB6VTw/q0HmdmXUXygAbrCozzAM9jT0IjUuX1lQnpkcvXSMg/VzhbohbX9OXpxX2435qpKB7qb0Uq7LAcmy0PH8sZ3vLqYKXs+687GLRcjjD1
 gs8rtqGQ
 oW1HjGNGCGbTdZuzT0d3G6F+LmFvxYw+I+erNrcJmEUemq+2RN4Y21vHtZG0+EN/ZC7WI4AC6KTdnpVDMjo4PCKWhJRD9a4oKBn6fjHumJSp+tdkiWlHwwKFp20eY97XYVFxishrfos9SvlKXi98SuUr6LLXWy/cVqfWTkKnedeUm6X8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.2026 11:24, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> Static no-map reserved-memory regions are initialized after paging_init().
> If initialization fails, MEMBLOCK_NOMAP would be cleared, and the memory
> is available to the buddy allocator even though it was excluded from the
> kernel linear mapping.
>
> Clear MEMBLOCK_NOMAP only for dynamically allocated regions, which are
> initialized before paging_init() and can safely be made available to the
> kernel linear mapping.
>
> Sashiko found this issue in [1].
>
> Fixes: 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory regions are processed")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Link: https://protect2.fireeye.com/v1/url?k=b169dca9-d0f63c99-b16857e6-000babe403ab-705f8403a3aaee16&q=1&e=a8dd8ad7-74ca-479d-8b2d-d49b0225734b&u=https%3A%2F%2Fsashiko.dev%2F%23%2Fmessage%2F20260814090305.4C8741F00A3D%2540smtp.kernel.org [1]
> ---
>  drivers/of/of_reserved_mem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
> index ac5db19dcc93..0090fa86dd10 100644
> --- a/drivers/of/of_reserved_mem.c
> +++ b/drivers/of/of_reserved_mem.c
> @@ -709,7 +709,7 @@ static void __init fdt_init_reserved_mem_node(unsigned long node, const char *un
>  		pr_info("node %s compatible matching fail\n", rmem->name);
>  		rmem->name = NULL;
>  
> -		if (nomap)
> +		if (dynamic && nomap)
>  			memblock_clear_nomap(rmem->base, rmem->size);
>  
>  		if (dynamic || !nomap)

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


