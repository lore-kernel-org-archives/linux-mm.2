Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D35C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 20:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C046B007B; Fri, 25 Jul 2025 16:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F3B06B0089; Fri, 25 Jul 2025 16:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1308D6B008A; Fri, 25 Jul 2025 16:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 015646B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:05:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8935140956
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:05:01 +0000 (UTC)
X-FDA: 83703865602.11.CF2105E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 700C7C000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:04:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753473900; a=rsa-sha256;
	cv=none;
	b=mNFi4kNFtlN97C1BI+ebZ5T/HbkMAc+A6iol9totvcxwVoMCT3eAh0brhwDgHvzSE5hi9w
	N5dui2+KdtRo2RWcuOR2oG1t0Z8Jv35r66hNSYGxRe8npoSITBw5SK+5e+nEZFCfOWDf5l
	ql3yPO+sF5xl6L+mJb0Sijqup8TW2GA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753473900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QMHalZqBHj5+vLhnCWsCzA0DqNLiKy2tC9hrHiUhNds=;
	b=Sxs38Q5qI3WOYXGJY4LiwfyrpAOGJ8P/FpLOcLl1wd6OCbQFADUFmedLSwSRNI61gJkrE2
	u7FyPEJcwNGKJlme5ami8hRYqkv/mEUiE/PI4lcRDFWMu501vGVKRgJaGBGk2vYk6Wm0PD
	A5UI7EgUVKGJgwvPkFeO7SWjRPCvukk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E344176C;
	Fri, 25 Jul 2025 13:04:51 -0700 (PDT)
Received: from [10.57.4.83] (unknown [10.57.4.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 167FB3F6A8;
	Fri, 25 Jul 2025 13:04:52 -0700 (PDT)
Message-ID: <02240cf7-c4d4-4296-9b1e-87b4231874a1@arm.com>
Date: Fri, 25 Jul 2025 21:04:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] dma-mapping: fail early if physical address is mapped
 through platform callback
To: Leon Romanovsky <leon@kernel.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>, Christoph Hellwig <hch@lst.de>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 iommu@lists.linux.dev, virtualization@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1750854543.git.leon@kernel.org>
 <5fc1f0ca52a85834b3e978c5d6a3171d7dd3c194.1750854543.git.leon@kernel.org>
From: Robin Murphy <robin.murphy@arm.com>
Content-Language: en-GB
In-Reply-To: <5fc1f0ca52a85834b3e978c5d6a3171d7dd3c194.1750854543.git.leon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 700C7C000E
X-Stat-Signature: ypd41griawc1ekbt9ijy1jq3xcqbwcod
X-Rspam-User: 
X-HE-Tag: 1753473899-509525
X-HE-Meta: U2FsdGVkX1+DmNTeTXv8cjp/VbvItnPH5JLXtWrIlFZPpP3v29lcQAVOisKi/XhPVSWeJroHze6VUWWd72F89BEhUcvdO2EREHBfpcrPEjaGTfbWgGzuyDVPxnfPaCJMXMMOUWRUDOKa7SVCROr6DoAfxtJjMjJmMarp5fpSqsS/2qa8er7rqznoLbeGuIyXY/seFqeiVOH5Zl7T40rjsgRt40wLSl4U52vq/EixrL4hA+vHkDGLn3MLmdnWyOBS5HbD6v3IZRxXYYQQjK+W7M0zy8p/PYY04/O+zJQQ+o0tc2/QuQ4HMDjs6xlk6s+uuO/xC1ppa1Mn5ERt099KMQuVzxCs/wLmPZYrQ+kHB3aFp3Ki+9DEzuTPbilEXC4C5B/T8+Eq9wDRhVsmi/WWV/Vg3centBYyX4cAkqClUA4ajhzBF41ranvG+IRqL1sXz4CzaODpfda/NOd4FVkZehi8tbrA3CheiRXQwf+pvy/+1PdDpueP84I9e+p3txQJu9e2NToodBhlmks383sTF4luo1wjhi36qleAKmN31P/7Uhp0fkTzRq2eNJByz+1DXU/9hVEOuBJqsLIxFSbBV3N5qW6G9jeNODmjcPPVA93AIAGu/y7hPfc6gKOlRYj1A0Tw/IiotJDkyW1Yfc0nwaiIEn982V9FDCjde8DKooJgul+DgobH0bcFwq3g7leb8h2eP8aD/U9mb9dL+6MKjsk9W2srzxcp+NDYOK5Cz/7IhnA1xlX+TFMbacbJSsOBeOA1IVeqzv9YVDOmtEWhjBtJbelWj1PaoFRVP1rlyHTRyI0igfJ1Nm5JMSiX8Sy382KZpaBjU5NKiIwco7Wk9EPoOtpF/P0F8nAFWsbWCyOh2mK0QROd3IYOf1F/lHHZ1IjUz8an+5jdd5Jo8bPxU9suwtWdSrPJ4MteigH+ixavbqdN74vqC3YVvQqV7nw8URURaBSZ9frmT2I6fbN
 gBXgGYJ6
 WlaW5BngNuPqGNlF4UagNpApY3UG5DYyjTzQ3Kw3umda+emQSYGIhXQrEr90hYqxn9KV+AxFNRXp5Mgc5NXr5q5K284Jus//k0VNCtckvhmskTqMbIOxi9nbnaKJiaxcAk5XAXHywHSJKeHdo76cLs4OtbNdhAnrwJTcgovPo9XN2Byg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-06-25 2:19 pm, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> All platforms which implement map_page interface don't support physical
> addresses without real struct page. Add condition to check it.

As-is, the condition also needs to cover iommu-dma, because that also 
still doesn't support non-page-backed addresses. You can't just do a 
simple s/page/phys/ rename and hope it's OK because you happen to get 
away with it for coherent, 64-bit, trusted devices.

Thanks,
Robin.

> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>   kernel/dma/mapping.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
> index 709405d46b2b..74efb6909103 100644
> --- a/kernel/dma/mapping.c
> +++ b/kernel/dma/mapping.c
> @@ -158,6 +158,7 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>   {
>   	const struct dma_map_ops *ops = get_dma_ops(dev);
>   	phys_addr_t phys = page_to_phys(page) + offset;
> +	bool is_pfn_valid = true;
>   	dma_addr_t addr;
>   
>   	BUG_ON(!valid_dma_direction(dir));
> @@ -170,8 +171,20 @@ dma_addr_t dma_map_page_attrs(struct device *dev, struct page *page,
>   		addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
>   	else if (use_dma_iommu(dev))
>   		addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
> -	else
> +	else {
> +		if (IS_ENABLED(CONFIG_DMA_API_DEBUG))
> +			is_pfn_valid = pfn_valid(PHYS_PFN(phys));
> +
> +		if (unlikely(!is_pfn_valid))
> +			return DMA_MAPPING_ERROR;
> +
> +		/*
> +		 * All platforms which implement .map_page() don't support
> +		 * non-struct page backed addresses.
> +		 */
>   		addr = ops->map_page(dev, page, offset, size, dir, attrs);
> +	}
> +
>   	kmsan_handle_dma(phys, size, dir);
>   	trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
>   	debug_dma_map_phys(dev, phys, size, dir, addr, attrs);


