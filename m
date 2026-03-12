Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B279B105A593
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21AAD6B008A; Thu, 12 Mar 2026 08:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2336B0093; Thu, 12 Mar 2026 08:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4C86B0096; Thu, 12 Mar 2026 08:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE7886B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:35:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 905F41601F6
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:35:14 +0000 (UTC)
X-FDA: 84537356148.15.0CA16BB
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 490431A0014
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:35:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=TFlOXVGC;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bVLYsZeqdLLR0Cw+BVzWgzWP+lyAr3AqcCFZTxFfl4=;
	b=Iinsu0o7CXOROoY6p/FDBcMi526VD8NVXY5/jo9DEFlfJvuie/1upBerNgAFgbzlDq1ok8
	dkYgoZGen78ReLZUjFF0elX0DxMyIl6Qp36Fg9SdPQogHWeJEnd/UujWBStPQW+LkWsU55
	JZYgQtyfwW6rBzQil1A8RJBhBgiRP3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318912; a=rsa-sha256;
	cv=none;
	b=XYMBm8pQ98PHNupDoOiixNqm2CH7vV9W/ktcB3HT080YEyvv6bauFb4bsxV3tD794NislP
	LsCpzkBss6sTXM5+GB+rcS8A2qpY3rKBapBSZofHOT1dW2P1X1gwGiMqwBQiEHTUqWG/3R
	UY+Uw6Eqe9D3pAqCX7YHWZhgMOxR7Uc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=TFlOXVGC;
	spf=pass (imf19.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.50 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4171ff4cb2cso632629fac.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773318911; x=1773923711; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6bVLYsZeqdLLR0Cw+BVzWgzWP+lyAr3AqcCFZTxFfl4=;
        b=TFlOXVGCIHEmf6h/xZhaOULy9M4c7aEch5wLE1nv5EKcyv9/Pgat2qFrGOhxOwIZnQ
         o63H0WGm0PYsyUg3MIKHNzjHmAkomxZXsoN+ZL3BkRLhx8AKreF1jE6Sjo3Zk4r+7Kms
         4/HCKSAtNqKPa6t1BLz+wlQ0x9vM0Iy9dRcsOx2C0xqjGZg8GY5l1ot+FJ2f6otzzgaj
         bzS/onBN+gopidWXYk41SpSLNg1MoXnFmkJfs04GmuAa4mlIwLJ9CyO8SRdmv4YOR5EQ
         S0CjecVH2zdzVIo0RrsmR00m/ZM7Opb48Wr3rfAGjF/LZQaFxGphiTmfmfQE/KJrbBon
         9RrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773318911; x=1773923711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bVLYsZeqdLLR0Cw+BVzWgzWP+lyAr3AqcCFZTxFfl4=;
        b=uXaGfCQ7iMdlUGXHE7UwPukfC3O5ELukA0VulWaqgsed4XlwMVj0r/CtCFWrqSD28j
         pOus3yUQuPFLD/bGVqZEr+FggV0Su22W45WRI+QPjp5vHrNCsQPBf9X8CnQOkTE7omu1
         l5pu8f8+LT/2ItxF8+TnfWjXFOpRbW5u4qD3XXt+Z98PxEfQlpeMwtTor+9HrgKLPyE8
         OhyIJ8yvxlsiAKpAD+BmvpY/vLgaHzjJiw9XkqBWsjpaarn88RknULiaa5/A3ovwMpaS
         UKJFsSBqY/gtuFiz8/xuVF8qaOwt3fhiqrpLIgBO5pbyur2lJgRdQF/BdGHsWp9kLkVO
         1Ruw==
X-Forwarded-Encrypted: i=1; AJvYcCXrEgUbRhx56fDkUywch/cQWBz0Cn2kkvqkiV6JWflJIMQW0uNBfZHZ+fUAT2ies4MYom1RGqOpww==@kvack.org
X-Gm-Message-State: AOJu0Yw06r3Y0wvUuNuUJG0ZezpR4DPSu1JYVot3Shf35ayJ6kiisrk0
	wKR5o2jpIsMUeXTXH07eN/+dZe0MRygiZjJHJ3KX5lg1DcjgAhJw0cXHoljaU57OkJ3P4bwAvb3
	zf1CE
X-Gm-Gg: ATEYQzzwKcaytZH/M8rYs+BNrx/a5LGGXYjTvoXU+RYy2spZe5SaTpRcMZme2xsd9fT
	YX3Sno+X7pMlxtcgL777UIIYjNVU/7SGh4I67HZXgdEFd4di0j7RQmmwfryyesT2dglQYa/WhMn
	BK/5V4Bmq0sRw176a6aR1oAKrFuFBk2rI/x1VnHMQJRt4HeSAPVLtPGVQ5fL0SufjFGT69xLi/t
	yKyJnKtgnYhTA5uNfnspjXk5gaOG1v937c4AJDuohsE57LP0d205gjMm5451XuTLEBsWxWcYaF5
	845Nvu+ME3kJkMefeN0HusHSSlhcR0S7acndYlYHmbzAuGtyRKZOkMDFciTz3DPW8u6gtCewQD9
	0UqPFSf1DMlcsLRVWCk4J9+AE4JUidshsaYPaWN3417UasGWFNfwHhPKeR+i/cgxUlP49dx9Our
	R4qduVglrd9XMLFzRLfMHi2G2e2L/N8XZsRcS7MMwK5zA+CjybCpy6eiLWMUt5aupZJicAGrmQo
	lomi1v54yoMIq6B00Y=
X-Received: by 2002:a05:620a:4692:b0:8cd:9322:7c55 with SMTP id af79cd13be357-8cda193043amr787228385a.17.1773318418176;
        Thu, 12 Mar 2026 05:26:58 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cda1fddfe8sm328304485a.12.2026.03.12.05.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 05:26:46 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0f7l-00000006ewH-1owB;
	Thu, 12 Mar 2026 09:26:45 -0300
Date: Thu, 12 Mar 2026 09:26:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 8/8] mm/hmm: Indicate that HMM requires DMA coherency
Message-ID: <20260312122645.GG1469476@ziepe.ca>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
 <20260311-dma-debug-overlap-v2-8-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311-dma-debug-overlap-v2-8-e00bc2ca346d@nvidia.com>
X-Stat-Signature: ffzig8ix1a948cm67gm6iq8pq3o9gzkf
X-Rspam-User: 
X-Rspamd-Queue-Id: 490431A0014
X-Rspamd-Server: rspam12
X-HE-Tag: 1773318912-384036
X-HE-Meta: U2FsdGVkX1+8e/ssVrULhuqaiSfgomuA6344ITfoHV1f48gCb8rL/lXNBAZHSRVe5lgY6ta335wNgJm/xgDnUVpj9kA9GcjJCb3osPQopAoRwyuSP6TGVvLXZkx+hVnqMylJaRntCBqPV9ONb7d772134MHcR6p/2Q3iRk0VnDt3coBKvgM8XA3PL5yuQN00E0bUPT529cNUKpNHzRE2ZpiwjyVamPfqi7XKNtMDJSjAxxPGjyaKXytkAO+ftZomS3o11IWLjh3zhvJ5wrU3rRvu3XcQq6uv1CUgBUyouDR3i4QtLC+dGt/As2856qxipqgeFDuMCtnLFa+mHZQriEBR3JzOBj943cUAaXpHXsqG0mzLLfNnwtn/lC/sGGklkFxd3KxbxUg8jiC511NgEPmjfv/XhGZMHfnl/JdajsTbV/ue0JBu7ye4dLpZ77rzkGNwbh/WJWwkLMQO03ZHfaB3M9D7/kAiI9/dTLIDuPjPl8MiDl9Me+LZkZEmrC3+2AGHQEgJh4m+eFVbZsgmo79ZVzQG30V9HCbajemlepyEhpiqCWSA493aJTTEpxXJ9l4xRG0z7tM2SMei/nL+DcVvwe82+buZlwk5eA5fYt0P15bPOVGjEy86RQsh75EvKb9Lr6J1m89Ptu+EFp8VSETFb0njL3ibghrwEzRkSaqKFbEYxlGpv8iOoATumQ2baTrh0cFfkUta9Cx8v0hmOySOtr75egKtHRGQOJ3lmCjYI2cJSrUIc610Lv4M0oQLWAqVpj+HMUKKCUFy9yN1m5JEqQ2kB3Hcw1/BJn1LJ5qQzFU3z9L3Djgg5pBWoAOtLT5tS294bH9sPoFt5/7FAd5HJqsP5ptR3Pd8yHD1gUw9kUj72jZU7q99qxKp6bVTqULQmY5OFXfk8uRVL6RTvGhimBdhCghw4G8CBATgGuvy94/l+vpu6d6r4Q7JYta1xWs2wWCHwozJIObLk42
 7qn2T6a0
 sYeibblXW0aLIM+HGlX88WUL2nF/TLs1Irm7WQmuSq+rYA9rG8PLQks+iOZ4sKfcJdQUyTLHNGQ09A10gqk+I/c3NDhUAbfWIDe8nZAhQhZFxp9UQTYzDYjCgzlGrDjxNFr4/PakMpBUgItpWTiXhQxSlS/dpKTOu0IyQ1hrk78Z/t681lNd5IwXK2mL53qTrV0DX2eDQWEMXVQhCQQWuPHpOhITLxxK01vlnwehwxc8BTvltc6QboGmdq5thd3UdMylk8HG4b9k5RIZ+uyN5Ta7AcsmgLpja/tg4dXS1G+uHcWftalrvTJp88g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 09:08:51PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> HMM mirroring can work on coherent systems without SWIOTLB path only.
> Until introduction of DMA_ATTR_REQUIRE_COHERENT, there was no reliable
> way to indicate that and various approximation was done:

HMM is fundamentally about allowing a sophisticated device to
independently DMA to a process's memory concurrently with the CPU
accessing the same memory. It is similar to SVA but does not rely on
IOMMU support. Since the entire use model is concurrent access to the
same memory it becomes fatally broken as a uAPI if SWIOTLB is
replacing the memory, or the CPU caches are incoherent with DMA.

Till now there was no reliable way to indicate that and various
approximation was done:

> int hmm_dma_map_alloc(struct device *dev, struct hmm_dma_map *map,
>                       size_t nr_entries, size_t dma_entry_size)
> {
> <...>
>         /*
>          * The HMM API violates our normal DMA buffer ownership rules and can't
>          * transfer buffer ownership.  The dma_addressing_limited() check is a
>          * best approximation to ensure no swiotlb buffering happens.
>          */
>         dma_need_sync = !dev->dma_skip_sync;
>         if (dma_need_sync || dma_addressing_limited(dev))
>                 return -EOPNOTSUPP;

Can it get dropped now then?

> So let's mark mapped buffers with DMA_ATTR_REQUIRE_COHERENT attribute
> to prevent DMA debugging warnings for cache overlapped entries.

Well, that isn't the main motivation, this prevents silent data
corruption if someone tries to use hmm in a system with swiotlb or
incoherent DMA,

Looks OK otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

