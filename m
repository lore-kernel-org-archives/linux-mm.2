Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7C9CD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017516B0005; Mon,  8 Jun 2026 13:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0AA16B0088; Mon,  8 Jun 2026 13:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E206D6B008A; Mon,  8 Jun 2026 13:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D53556B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:53:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A28EA0214
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:53:54 +0000 (UTC)
X-FDA: 84857493588.04.0F4A1B8
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E2F8100002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:53:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bug903aT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780941232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKaJq/FqOrnnsfhBbbAGAUYIrDaTZV/8Gb9XfRMpf40=;
	b=Oyf+MRmAn6M1e56RegOSDSBGZAkn4T71ikWRnrB6DICFgeFZg6DFeMP9da8wLTn66+6N22
	iFFl8XQajgeYm7PO2E3vdmnU6sVsLcVJz299vE5rJUArTz5W/F+KjjrXyc+j4doYsCR3/l
	OHp2OyTxCwbW44ykt2LXveaakOfdTqs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bug903aT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780941232;
	b=YT6Oqy3/pJEecmcQg0lG2DANg0p3T2jmRrUpbbOEmK9bYY2YWFkn0Oq1duEEhq6iTp3Wed
	oE19yVo8i8vBSpg+Fv2abAgy9P5LShYNZyoLQxvalIGESZLak0kH8+19Ya3JJhgifAACvn
	ewYOXQqFD2SzDpEpoJShZkQ7QiPll4k=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-137ff9a7d5eso28850c88.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780941231; x=1781546031; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HKaJq/FqOrnnsfhBbbAGAUYIrDaTZV/8Gb9XfRMpf40=;
        b=bug903aTx5YPT23yS7QbsteayUpBCQt57PZF9ZGijsJpkL2+alVTmlF+3YeApN9EWY
         llwD0i9mZ/wgigVIQUiXjqR0L8UCWJB8nZO7SVDoTObxwJnTvBA4q3iQwYsWdaA+jfTk
         X5uBt7SvnnnPBVBZgwWx/u84J1vnhZ5wujFZAiOXHzBUN0rfI7vaDP58bi9ZGyapNzVV
         7bcpMcdfph6jxiZHRstSvajSMG0dZ5vfwOE58ZJ0+NLf7zZjT77sBPlmI9z8GLEc2AKx
         8oAoy41c4MmVFyrFLXo1o7RJxezqRB35BYFP8gWc1JRn+dh+EeYGGsYEgQDFFUmvNook
         cf3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780941231; x=1781546031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKaJq/FqOrnnsfhBbbAGAUYIrDaTZV/8Gb9XfRMpf40=;
        b=hAWVN0MZIZ2s6poTE+PojlGDast3qPBqmUdnbxc3I9vvs5NwQkICqcvBSBHfouhCxn
         9J3R+tqk9b71ez1bXGayRN3Nrk0cWA5rghMTGLQHyQY6b3+91l85mUtIFc9+IRifffWM
         5r+reS+ubpb/NvTeUHF3w/Ks5EIS2t2WNdG13cvjPbUjSFjSg0TIF/zrassZ2sR4i5sI
         Lg57g+SBVHdqQld6VXDXq8bOHv8lYtkiTbCW3ka/K8OgvJGzp6d98Iii7O3ZobVRjtnf
         jh/WRhYUd8gzJWiFLmLTe7I/ymlBsOffJQSkTNosJiA0eJ4nOngofTAAybgfM8AFRQIH
         0Tgg==
X-Forwarded-Encrypted: i=1; AFNElJ85ChZDtyTuRTmqwSQzDlc9ze5mXZP01w/OVCofBzNMDOMk4DDA/258QCIhzcKDdcrtGcmuTEfOCw==@kvack.org
X-Gm-Message-State: AOJu0YyEWKOde1JGWlmHPga0baFZw32/xRcjGtrk5CF+JpfmuuZV/kSB
	MrpBSiglWoQ0YUzeAeQJSiX9whX1MYXVS1dpwMiiWOhBLPhp8aDTn+DDxqS5F4jTkA==
X-Gm-Gg: Acq92OH7CSU6xJ+FTrTK7zuIlxg/5AciY+SxoSJq9JqzcYs5ljZ8VWTA9xQUPJ45s9k
	bIyM4LhjblY5J+OXbn6D4p4ANdPHl54Bqxd06WgMvkJwWk8NaASGVYDRkU88QXfjgZycK7rexkd
	RKA5WBx7rhVgpsEQYV0pT+KTjf+rt+Ahll2r4IASzkD9jQiuDS5th2CIjP9JFvgoHRBhv/8UtHr
	bLhDBBTm6d+IPbNbUCfCEv4uTZE/rR1CEvIRPxBC48pUg+7j8SQ+cI5nJXK/MNuLJTxXl7+X9Fu
	ah/yoggv7nq/Ovv1K03YJMKfcn8tzpwx254qshQYQn90bcsRaex8yEOaehpFVf8CA0ApFLK5Foe
	YafFKejUh0Em5nHMmkMGTKWvOJEyVlHJ/hdamuTvsYl6F2uZrYiwpoyemWCs5lxSmucbgZhc6XJ
	Vz8gtClD/QkCXCoX+lcXxRqHdednC49JiPE4UZWrO0085lF22yz8/drdZ+yBRSsnfqVkHO3eM=
X-Received: by 2002:a05:7022:48f:b0:137:ead9:4608 with SMTP id a92af1059eb24-13807cbdceamr310348c88.17.1780941230355;
        Mon, 08 Jun 2026 10:53:50 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db528dcsm21257291eec.3.2026.06.08.10.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 10:53:49 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:53:43 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Will Deacon <will@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 1/4] dma: Add DMA allocation preservation KHO ABI
Message-ID: <aicBp4tSyzyYBnzn@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-2-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505002737.2213734-2-skhawaja@google.com>
X-Rspamd-Queue-Id: 5E2F8100002
X-Rspam-User: 
X-Stat-Signature: yk8y43giejbz51fdfafn3aautgrrnf49
X-Rspamd-Server: rspam09
X-HE-Tag: 1780941232-673239
X-HE-Meta: U2FsdGVkX198keFDRzmqPHoMRA0XTQ3UrLCLlAOywV1jMl2ys/2HjfUhcncarmlEM/VtfYB7cOMG9MEADAF8gV4+8F3Tc/F24EvtFlyI7PkKLCTTjckuRSSfGi2sQRr55eBzlAbXC1MPMqptadYEc2wc1UzahOfc33MAu9OrFk+/1o9Zpi+GuA4kQtMd8zU08UkUGBE2MFBGqzT6JHRCyQCgAuoVJ9pD78HJBonMwCoexQtcFXFIpUmJOCuhHK2l0hC0G2DKd9+8j8yYAectvPwRdnaacmmMAETd9uCy8OnHZCafer9DvOc4t8GmMKTEy5rN/G0nLLoEqQNrqZI0Ui7c+QQZOrOq7bMQvi4UUBBme8F4eXDdkd7VczWtPYqHJd3k25MtncxBqbZ81xRZQCaphWH9CX+fAVigRvZSg2vC8gfuRSbegyHn9eLA9OoD+pHUT6PXV6mSAliEN5WSI0HxAR+m3kb4TfYOYwpPr5rVoVWjuhMAhZR0P+ioDJTtP8Rl/DfDunkIz3GMGd/yDEjtTMpSpsYf0VrRK5b7yzvgpbpQ3GCCzdvCILGKqtGCv1RAsFxBeZBbwrx3lB+pLBEPwDmLZJBC11grzckh1E7nngJFBYbA/IYr4d9nZ3w0HvNcA4BdlCqsKO72fkUEYTs5jjx8wY7QxxVJ1zahhIkWiG8eN6QzXRGO9yyFs6o5gebRAyLQvGF21gCooY2b2CgFXKzg9utmppdxuTQRJTq7Lq7pVSyHrvCdinASfzmf2gVzwoFNix8V3RIvhmoTav+i+UREgW963Y9zKwtQud2GfSkbmymVteGsmg+NQ5Ojms2UNOLP8BwrKd4vWVXdRHg7W47cMhKnN29vsfNVsPpazlZkJQWI1vhcczn+DnLELE6sPy1mCCeQ9EQvymflC3n50IjsyoHSxDro5bglxaxfKbLNt4RggyRl7reGB229cfCK6fWzdE5sb7vLf/O
 Zy2Vhipr
 fYqWNo2lq3FxmH2r0BT1ZvD7YjwwyGut2NvJTpKhQniiJd93ugNLngyIbvrLvpkmH16VtSpAutYpPQ6R4k6UF4JUAVZjgVUcX9/CoYiZ9IT1gS+p3MTvh7OLrnv7zMEP/8CLfMm9k5lvTfxZByIbb6EA5MlmwiNyGSyJpXAs3f1VLWMlteS2A/IpK1PU1Xx9wNBnRY93BUPM7ZKtgeoRJdJt8VCwfDaEoiZ1LOsqJZ2U7xgwSvr1QAotvZX+EvTzVrTurnBqKhaIarKym9buV28WmP7gDIxgT32EfGvP9gxhXRSjv4nJY6/HPDG56F1Uz9/ki8TqQutX1NmXXAMrezSL7rEtlbrdp7/oV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 12:27:34AM +0000, Samiullah Khawaja wrote:
> The DMA allocations can be backed by a variety of allocators. Add KHO
> ABI for the preservation of contiguous allocations that are done through
> dma-direct.
> 
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  include/linux/kho/abi/dma_alloc.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 include/linux/kho/abi/dma_alloc.h
> 
> diff --git a/include/linux/kho/abi/dma_alloc.h b/include/linux/kho/abi/dma_alloc.h
> new file mode 100644
> index 000000000000..46e61db81abe
> --- /dev/null
> +++ b/include/linux/kho/abi/dma_alloc.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_KHO_ABI_DMA_ALLOC_H
> +#define _LINUX_KHO_ABI_DMA_ALLOC_H
> +
> +#include <linux/types.h>
> +
> +/**
> + * DOC: DMA Alloc ABI
> + *
> + * This header defines the structures used to serialize the state of DMA
> + * allocations, done by device driver, across a Live Update.
> + *
> + * Only DMA allocations done through dma-direct that are contiguous and
> + * allocated using alloc_page are supported.
> + */
> +
> +/**
> + * struct dma_alloc_ser - Serialized state of a single DMA allocation
> + * @page_phys: Physical address of the preserved pages
> + * @size: Size of the DMA allocation
> + * @force_decrypted: Whether the memory is force decrypted in previous kernel
> + */
> +struct dma_alloc_ser {
> +	u64 page_phys;
> +	u64 size;
> +	u8 force_decrypted;

Should we also stope attrs in this ser state here? There might be flags
like DMA_ATTR_NO_KERNEL_MAPPING which would need to be preserved across
a kexec? 

> +	u8 padding[7];
> +} __packed;
> +
> +#endif /* _LINUX_KHO_ABI_DMA_ALLOC_H */
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

Thanks,
Praan

