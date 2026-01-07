Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89816D0D179
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B780A6B0092; Wed,  7 Jan 2026 17:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B259A6B0093; Wed,  7 Jan 2026 17:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A250B6B0095; Wed,  7 Jan 2026 17:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA1E6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:58:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAF1E13B09E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:58:25 +0000 (UTC)
X-FDA: 84306683370.04.CE055D6
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id EE33A4000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:58:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="VRD+/Ddu";
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767826703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hnvqPEHU52omac+VeWfKg3uyJtrT0juXVZSOaBY7xc=;
	b=k1yS5jS9mro6o/BM/VJPAzJZgOKlGsejsBg00qgoAa/Y2OZn5ePhb1AFWrYQDghQGRTxol
	qfiCHsaBF7zzUx0x5n5RlUYouQ17329DUF3ENkxQ5Rs+Bm5COD2aJ8js/wLutKOl4xh9x1
	HfdbzRtdOcePzjHdV7oSzMHXvxtKnY4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767826703; a=rsa-sha256;
	cv=none;
	b=CwoRVxgy7Q21WwAcAKbxhpGP1PAGXeXdnw3vWYOqBVy4i1pmt7wEvP3+SWz3xsOfGbKpK5
	rjZyj4LIx7bJpfXEME2U+y+Q47mVG5vlhzjhACSXfbVmT87+VVeZ7kvdC64NMFrPuIQNgf
	R5YfUEbyAEedqVmxx4s6l51Ddo73IwA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="VRD+/Ddu";
	spf=pass (imf17.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260107225820euoutp0168aa947d9301c81fed89b9546669b5ad~IlQR_8gG52825328253euoutp01c
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:58:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260107225820euoutp0168aa947d9301c81fed89b9546669b5ad~IlQR_8gG52825328253euoutp01c
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1767826700;
	bh=8hnvqPEHU52omac+VeWfKg3uyJtrT0juXVZSOaBY7xc=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=VRD+/DdubYpFt1PzAZC9uL6ev3gYRmjj/YEpE6HGnk6pM3G6C2BPzh9m/QHBUlNDh
	 5SnP8S8CIvjF9kdQJn0gGVvy0YtBkM4uapOk5nVwiMwLXtk+uUpwNuchVLXnvxNlXz
	 1TRDDerWw5OWlZq+HXSshGcy1iKbtqBq0qLf+RLs=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260107225819eucas1p2de678d4e810fdbde87192b83033a814c~IlQQ2xSTS0857008570eucas1p24;
	Wed,  7 Jan 2026 22:58:19 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260107225818eusmtip24181b50e59ca4bd4b7e2c9f57edab3fc~IlQQI8akI1368013680eusmtip2J;
	Wed,  7 Jan 2026 22:58:18 +0000 (GMT)
Message-ID: <6c61225a-f4ef-4b70-b34b-71fea7ae6cfc@samsung.com>
Date: Wed, 7 Jan 2026 23:58:17 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v5 mm-new 0/6] mm: hugetlb: allocate frozen gigantic
 folio
To: Zi Yan <ziy@nvidia.com>, Mark Brown <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea@tuxon.dev>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Oscar
	Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org, sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox <willy@infradead.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260107225819eucas1p2de678d4e810fdbde87192b83033a814c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260107225819eucas1p2de678d4e810fdbde87192b83033a814c
X-EPHeader: CA
X-CMS-RootMailID: 20260107225819eucas1p2de678d4e810fdbde87192b83033a814c
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
	<4211be25-3fc0-4395-9b24-a5ff0b3caa34@tuxon.dev>
	<13ad5888-2d53-40c8-9269-22bc6001754a@sirena.org.uk>
	<7253A444-97D1-4256-9AD9-BCFF66437510@nvidia.com>
	<CGME20260107225819eucas1p2de678d4e810fdbde87192b83033a814c@eucas1p2.samsung.com>
X-Stat-Signature: pky34hkj5z6fraat6kzpecjpo335gwos
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE33A4000D
X-Rspam-User: 
X-HE-Tag: 1767826702-834324
X-HE-Meta: U2FsdGVkX19Onapdu0/6Qr96Li7FOKJW6BTfgq6allDFyss/O8gvZ+b8Pqy4DptWYmviTZ6p7eXGJzYDyROpxCoEtJ+85ZexTC17IREhCE4MlWbk5IlF34I1PA38yUQb25swttJRNd0v3M42Cu54/TXfP7C7zQCC+ZCyFcy7z825sMco8nlyhVH5yNd7tiLnr4a2PlXz1ZcAtM4qZLbO/7woVnx8FcoipD0WJ5kecFlOtoT5qm1ixucEKp35ARA737QsG28rAQhPmsmAduS/wxFXsoYYW353Xh7KGFCMjjZdcwC3J8fze4XOvaYCNrDQohau4JQfnj4fMHCnGXkcDZAvrhstiDe3HjSzCqszQEudoYpgMMj0I7I4nZTPhR9Rj/PZf1WtnLhNoSDPwxISVPZyHd2OuuZkbb2sPkbQCtXyaBzyISqzv3lOzKLt4KayXWgz9eWIoEApsA1nuYydLtiTjSWa3MQCu2CDp7Pl7KC0JMzOuVrt/iGRTDYCRAusaBHF9nTt/7cH0lHBL0mrbW50/a9Qr9IqBM6xBRjfvroBM5ISc84eqRtve1frwCaX9OGZp5mD6+qdBwhYfn7wIvMKwN5e2xqB+Z56rELzNIvHw0E2eKMzp6RuxoKpiDiyATSgoZYx0/69+FqvpqSzKoBdWx7Rp8vnSE3hCsb7y5NclpTS/HIYBCTABcjOiqpuir1LOzqy/OfPx7GMkvYshShJCW9lpemAMWBPaeUgslWRpA7VpXzoa0rrGCIXny2HKeH8Nr3rXWawl1yaPs6OLvcTL0QR4OukoYNG3EuqIbdTAKvESjb9G6oD4uAFShwIgx23Hsn79bxcXUhYveclzqat1zsh1kfZYi/MuqDcyfIeH5ORY7Q6y/HzdM/b6GCcp49FJRhk0HQrZZySktuAfLnEQ7ukPMVErnO0z9PicHTIGnIRWo3cWG4odrffLSDzFn/2K5d6uxKt3vVD2lp
 pLRQWlML
 RMxofyZXlFRqW4HsyEPHdSNeIv5GNeaKtDLpBmQLg8BsS4mo7fO3n0MG0srSQxt8vehbePKy/kebuAJZ+dt7gtFKo5gI7Gv/ZYY4vk2XWcXXP1cMcLI3Cak51n35YBYZ5f/RD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07.01.2026 20:38, Zi Yan wrote:
> On 7 Jan 2026, at 13:39, Mark Brown wrote:
>> On Wed, Jan 07, 2026 at 07:31:30PM +0200, Claudiu Beznea wrote:
>>> On 12/30/25 09:24, Kefeng Wang wrote:
>>>> Introduce alloc_contig_frozen_pages() and cma_alloc_frozen_compound()
>>>> which avoid atomic operation about page refcount, and then convert to
>>>> allocate frozen gigantic folio by the new helpers in hugetlb to cleanup
>>>> the alloc_gigantic_folio().
>>> I'm seeing the following issues on the Renesas RZ/G3S SoC when doing suspend
>>> to idle:
>>>
>>> [  129.636729] Unable to handle kernel paging request at virtual address
>>> dead000000000108
>>> [  129.644674] Mem abort info:
>>> [  129.647456]   ESR = 0x0000000096000044
>> This is also introducing OOMs when doing at least audio tests (I don't
>> think these are super relevant) on Raspberry Pi 3B+ running NFS root
>> (probably more relevant):
>>
>> [   64.064256] Unable to handle kernel paging request at virtual address fffffdffc1000000
>>
>> ...
>>
>> [   64.087583] Call trace:
>> [   64.087586]  kmem_cache_free+0x88/0x434 (P)
>> [   64.087598]  skb_free_head+0x9c/0xb8
>> [   64.087608]  skb_release_data+0x120/0x174
>> [   64.087615]  __kfree_skb+0x2c/0x44
>> [   64.087622]  tcp_data_queue+0x948/0xe50
>>
>> Full log:
>>
>>    https://lava.sirena.org.uk/scheduler/job/2341856#L1721
>>
>> Bisection identifies:
>>
>> [fb9a328d30400dbc8b2ea5a57daeb28bedac398b] mm: cma: add cma_alloc_frozen{_compound}()
>>
>> as being the comit that introduces the issue.  Bisect log with links to
>> further test runs:
> Hi Mark and Claudiu,
>
> Can you try the patch below to see if it fixes the issue? Basically,
> in cma_release(), count was used to drop page ref and decreased to 0,
> but after the loop, count becomes -1 and __cma_release_frozen()
> is releasing unnecessary pages.

I ran into the same issue on my test farm with next-20260107, then 
bisected to this patchset. I can confirm that the below patch fixes it. 
Feel free to add:

Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>

>  From ece23da65ea7210e1fcb51ee9c27aec19b84811c Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 7 Jan 2026 14:23:15 -0500
> Subject: [PATCH] mm/cma: fix cma_release by not decreasing count to 0.
> Content-Type: text/plain; charset="utf-8"
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/cma.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 5713becc602b..408b07f6fddd 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,13 +1013,14 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   {
>   	struct cma_memrange *cmr;
>   	unsigned long pfn;
> +	unsigned long i;
>
>   	cmr = find_cma_memrange(cma, pages, count);
>   	if (!cmr)
>   		return false;
>
>   	pfn = page_to_pfn(pages);
> -	for (; count--; pfn++)
> +	for (i = 0; i < count; i++, pfn++)
>   		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
>
>   	__cma_release_frozen(cma, cmr, pages, count);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


