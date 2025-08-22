Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B4E1CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC3D6B0170; Fri, 22 Aug 2025 04:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676F88E0056; Fri, 22 Aug 2025 04:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515F96B0172; Fri, 22 Aug 2025 04:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 209B16B0170
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:15:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C56CE1A06B4
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:15:12 +0000 (UTC)
X-FDA: 83803683264.13.E24BC01
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F842180013
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:15:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XKfzn3o3;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8D7LpAOoviBYk7WIQ6GdtJERZ5Q8as878mTjAUnE/1s=;
	b=fHSCp1WzS/Nzv5VVh4aawy40yFKYxSudWwcdY7hfRaVLfrzjyHdNynJ/SvXyTx/GYT1WE2
	lP82rL/bRIm81Qx+KE7YeR9P+TZNXpWe2yPDFaEacGwcvoKU0b8QCtouqhvQWHey7Pemva
	ryW/xkrzR7DjutZ8wZGpfKH827+iyUE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=XKfzn3o3;
	spf=pass (imf06.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850511; a=rsa-sha256;
	cv=none;
	b=sZkh560hmCmZi+RdBdL8WIvNW+oS0LAVqNUGtEkF/AJWJsucoHQm6jNLT130qlCwODeOnt
	g9LA0HBU5ZqIAZfPVH5/uO8djOHtV5P4QkOELlN/qeo1n+97tzQMHUsbOtdJDTolGC0IwM
	xbDzgOyK4FSLvY3Qn/VTTB5cNPUCfaU=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250822081507euoutp011eb6e04748c75467354f864a5b13dcb2~eCLvKXWHt0802008020euoutp01T;
	Fri, 22 Aug 2025 08:15:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250822081507euoutp011eb6e04748c75467354f864a5b13dcb2~eCLvKXWHt0802008020euoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755850507;
	bh=8D7LpAOoviBYk7WIQ6GdtJERZ5Q8as878mTjAUnE/1s=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=XKfzn3o3WVKTQX9bE3/cpVfy9yW+H778T92W7lBVbU6kRm4mXQcKAfiloG9SVAIl1
	 DBMfdB7LnCnsIfysL99KcFBB0FogAV6kQBHI3K43plBR35f6vTvEXBvPziUq5zs0kR
	 Az18+L1Qjna/KGD88qj7IvZXFIdKHX7QWAyUJp50=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250822081507eucas1p2f6977174baf330e1c895de7ac7b91cc1~eCLu2KEdp1444414444eucas1p2a;
	Fri, 22 Aug 2025 08:15:07 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250822081502eusmtip2e6ed6d47d5194e587353269471a8bda2~eCLqth-G50411104111eusmtip2L;
	Fri, 22 Aug 2025 08:15:02 +0000 (GMT)
Message-ID: <debc61e1-683c-4fcc-9040-d55324f096f7@samsung.com>
Date: Fri, 22 Aug 2025 10:15:01 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH RFC 22/35] dma-remap: drop nth_page() in
 dma_common_contiguous_remap()
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Robin Murphy <robin.murphy@arm.com>, Alexander Potapenko
	<glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, Brendan
	Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis
	Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe
	<jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner
	<hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com, kvm@vger.kernel.org, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, Mike
	Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
	<peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo
	<tj@kernel.org>, virtualization@lists.linux.dev, Vlastimil Babka
	<vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan
	<ziy@nvidia.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250821200701.1329277-23-david@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250822081507eucas1p2f6977174baf330e1c895de7ac7b91cc1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250821200816eucas1p1924e60579da49c1dfed300c945894d83
X-EPHeader: CA
X-CMS-RootMailID: 20250821200816eucas1p1924e60579da49c1dfed300c945894d83
References: <20250821200701.1329277-1-david@redhat.com>
	<CGME20250821200816eucas1p1924e60579da49c1dfed300c945894d83@eucas1p1.samsung.com>
	<20250821200701.1329277-23-david@redhat.com>
X-Rspamd-Queue-Id: 1F842180013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ohku6pxqhwmkszwkfqunrgqqocerur1p
X-HE-Tag: 1755850509-440131
X-HE-Meta: U2FsdGVkX19SRwd+7i0Kk1obbaTpK5c4bI68Ck//qdpdZOw8tKmA2L0e1NU2qU25gNw4PvMWl0odRl8AlfcYPMk8uTaGeNrCSf1wQ4PgTfpnhF1oaoWI/mZyH+2xMLqXHYCWRgu80ftDV6+r55Dbs+37BQ0uI6WvsxxRFhGK6CCnutyZz0B7qPJbKeP45pDcjviLVw3S0tcuMdxp5vusgkpOMvVSuLYADDeNUqNbXT5fGQRdcxNTUqkxSM0OD5xYF5abNxYnmYa70nI9MmMF8ixZTjoxLweiThggrHGxrnqbxqvGTy1x0sJvnBTnbSDsksCPw0d4DlE6/lnOvuE6ITre2mSC2u2uw48jPKTP3D86HuCw7ujJbbL4KbLKug726u9XRWAflZp5+s9hm8hsc5qDWuptjCppF3afj4Ks3pC6kr7skdSkt5IoPmujr4hVYtdlUGO8MAilnHXl2W2a15+pkF42elYCz6uragrO/oeAaYs4sK6XmonDKsmuxIkphulUDBjxCD/6hEScJqOGrfa62vUXhgcuAgOVmHNUh3qzhoSf9vQk/Ng/WFJUgioKXYsFx+KzKscUiOKCFgPKAvu4q8U7wk54Ck7PBe/wdoQ2yVmLbzj+cTpGo5jmieFoNwhjzpL0fQG6pV4hPFgsEcwGkm2szlAoGKdnWfrMf+3UkbYrHt/eJpV8+ZyExRPwpBsWD8cevIPAI04NaqoTMv2WRBr+z5/tv4941HbKBvBpnWT6dHx/fj3+2CFWVeR0SsfR7nQL10qfaoTa4PokH53BEEF5nqLZantMwdsreU55IRfrMh5jm6ZhJkmQcGRW4ln7a9XRWgqNVoRdmUwnWM8hE5w6TwxTjWYphOz5AbIeDBMcrVLq6xtgbaxZDokUJqjz8OBdDDbf7r9uePZWD+xGmbSy1qW/5KIpiFKUR0WyGNSAIILLDoqf0OYHq2jq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.2025 22:06, David Hildenbrand wrote:
> dma_common_contiguous_remap() is used to remap an "allocated contiguous
> region". Within a single allocation, there is no need to use nth_page()
> anymore.
>
> Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
> ranges.
>
> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   kernel/dma/remap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
> index 9e2afad1c6152..b7c1c0c92d0c8 100644
> --- a/kernel/dma/remap.c
> +++ b/kernel/dma/remap.c
> @@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
>   	if (!pages)
>   		return NULL;
>   	for (i = 0; i < count; i++)
> -		pages[i] = nth_page(page, i);
> +		pages[i] = page++;
>   	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
>   	kvfree(pages);
>   

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


