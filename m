Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BAF2CFD360
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 23:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91EA26B0011; Mon, 24 Nov 2025 18:13:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6346B0027; Mon, 24 Nov 2025 18:13:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832126B0029; Mon, 24 Nov 2025 18:13:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7386B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 18:13:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9391B9FE7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:13:28 +0000 (UTC)
X-FDA: 84147054096.10.599DF41
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 00CFD180013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 23:13:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="2TK/ucke";
	spf=none (imf06.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764026006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqCSyh/ldHEevO91VA549tj9DNL2UTg/ugPa7E64c1Y=;
	b=yTJF5FktFFdM0zT/bsy8WYjQkzci100jZ7rmLNHUPppZfGpj6/zGrRxpB+aIJMceYhZj4M
	pgJcocXglhUgp7sPKWAp5DXGmGGg3FawcrCx8u2nPOAeJhg6CokGCWEjkYLFzgp1d8Tuc3
	JIqCUhEYsLZArmaLTfQhUVEpP6cvFgk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="2TK/ucke";
	spf=none (imf06.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764026006; a=rsa-sha256;
	cv=none;
	b=BBcMpzqfxjmR6if17kMvNsUeTWkjt8nn1QqSZRBkjhOuDy9uToytuGW7pGlTnSiFrkmli8
	2jI2fZaE3HJGKzCQzmjTDAdkveIPnWTo2txVtJR8hz/ks3I0HdkmiQd5BGzbQ8Og9OVAXR
	i5B2+rrWVWmEkBjfjNqNCWgmATCUcPg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=kqCSyh/ldHEevO91VA549tj9DNL2UTg/ugPa7E64c1Y=; b=2TK/uckeZkRVDDYOfr7nwpb6sn
	/0qDKxuglHn9IFR3uyiAqDh7fgtJjOnBiYZCW9nxYCRjsZJjCslKTEJFRSo5LL5mbIGVoSHaHQKuX
	OxZYFaPfNtGQR+xbsY6R4DraE+xQ0M+1W4LotYo+b8bwuaKyZimMYSRQeRD/nabzgzovnY6ar8IFl
	DGUSIOkvAaKLShQnP0/aD/EauNWUOezOCqVBomfju4+nvcXh8plPW7egRbtVPwLNCYD0XnSv+Qt51
	V9iMTWXRgJGNZ4k/h9gRP2qL2+KKYfhotsRtPq/03Cwc6Twve7wqOsFJccsFgI9pS0GrA9ijTKhEk
	505hKvcQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNfkJ-0000000CRAF-1sKi;
	Mon, 24 Nov 2025 23:13:23 +0000
Message-ID: <7854489b-bc9e-4bb9-a19d-cff96badc180@infradead.org>
Date: Mon, 24 Nov 2025 15:13:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-2-smostafa@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251124200811.2942432-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00CFD180013
X-Stat-Signature: zhc4k18huwdwx7ajq4u6ptnqwa9xkwuh
X-Rspam-User: 
X-HE-Tag: 1764026005-841706
X-HE-Meta: U2FsdGVkX1/kcl5MzRaY7gCo/qtJW3yp5oYvCjNlG4aOL2YjZe10nJYExzuI/tGdVRTEOiDcOmjeWajt/sO6LXmtBbvNj0cEIAa+rBSc7eKz8/Hcrvnm1cIB5NYS0fCzMJCUkcI3OZLcJr84iYcNwTKdMO3fnKD2MWFTBdKBmYndR/K/DEvQU/D3cT7NnqJyoGsPkt9F1xTG/F0kSTLXZIr8m4Eh+Slfp//jKO9mrplRq+A+qrUJ32ndLehQt/ThFtyppYb0oE3kWZ5An4laRLTDsmMT0FUl9z79mmA02gfdFqlTOXB+tQFeiPk58tjWhW4UsxmwTeLgYTtXjCdl/mRC6B8t91omGW3OHDKGZpyz2fiiOLV8oWalsSqSqrnzaA2sGJOluxRcg2SgCIV4gyKiEfDUVzY9TFlBfLZJ8JEkmM0yTVvf36aAkxUg+JwqUHceGuR4AE9kJLTpl3gCsET5wJPYFxxlnEEyhW33KEmBPTcGE7kkFgVkOL0dZiK1S9tziIpRC3XEs7FxllFkD6epc+XjKdMDRXyY96HgJ0MM3Nf5sqrqKet4R508UkXBKRKlpqGPhxpG714MMBZJmZJGHpC1uT+kHAeVJRSqLybuTlIoBvjmFT29MS31L+Ci1Lk8O//7K5G/nVN2UVLnfkf747g/akG+CoTRiEsmWXHm09bQMMWfrI9NX+rqEWCqaaHxiO65uZnp7Z1re2K4YQYKu3bx+CO9GLdfUFXk2eeVyVnzXLZIfH818w1pjt8Qr7Z5tGeuEq7ZY6NQ7HdNFLatrMpQnUadDKUPeLsmTvk+lutYKwgA0xt5AIMn7UD1XTauupiYgLhty3on0xp98xKWgL3O/ZeB+ji/MTJNqDTH9m5yevCq8/KRHycAeMKOVzRVHlnRGJ54/biy/Bpui2wo8tsSMXfZs05iYesooRYtXa2G7ADkWWx9BsJ9fYST6eszrCAui6SjDcagMir
 +G9b75rM
 YvHzizPO6taDyug4REdNf6F0NRl3v1hioveAjNaWx1zb9tt8eR2gLndctTjAgqR/0AsWE+kx7U8DciCZoaOTl7m2Pv+u8wFiOkux64VQVb/4M0c+MOkgvdPBKfx8D+xbMZODXOD+BKVx/s/ZKKC+3Q/0fMcwAgk6aBNFn1KRfSIwopxvh6AJ+FTKjVeaRAGR5+Rtu7182syioSuhE1Ce6+kGlTLYvI5wgS6S22nBbPv/uA2nnulvz8uvp9aSVow54FyynpdO+TnhEZ840K7qONeX8VPJKOpY7Utjm696v5nFXsczCLrtl0ygv5jKchUcnMEMc3FLhjxHdTBzbH+w6/e9pW20ruBrlZr2uKSW0ItzqWdE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/24/25 12:08 PM, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> 
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> 
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  6 ++++
>  drivers/iommu/Kconfig                         | 19 +++++++++++
>  drivers/iommu/Makefile                        |  1 +
>  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>  mm/page_ext.c                                 |  4 +++
>  6 files changed, 79 insertions(+)
>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>  create mode 100644 include/linux/iommu-debug-pagealloc.h
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..dddf435a1c11 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2557,6 +2557,12 @@
>  			1 - Bypass the IOMMU for DMA.
>  			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
>  
> +	iommu.debug_pagealloc=
> +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
> +			parameter enables the feature at boot time. By default, it
> +			is disabled and the system behave the same way as a kernel

			                           behaves

> +			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
> +
>  	io7=		[HW] IO7 for Marvel-based Alpha systems
>  			See comment before marvel_specify_io7 in
>  			arch/alpha/kernel/core_marvel.c.


-- 
~Randy


