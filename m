Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33DFBFC5926
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C0C6B0088; Thu, 26 Feb 2026 05:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FC66B0089; Thu, 26 Feb 2026 05:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7A06B008A; Thu, 26 Feb 2026 05:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1416B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:49:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9806E1A0AEA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:49:50 +0000 (UTC)
X-FDA: 84486287340.30.D805E94
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AF0D940007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:49:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=exhUTgtL;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772102988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/o6ik6BfaJlx/6XchAGgyqM+lVTFMumekj0JClE2Y0=;
	b=W+/R4AmztnkZhuC82nyw+Ay6lKE7i2/qwH3QURvlyqbibOPJGDAWLxggT+C3otUnrGgZ1u
	IXxXbzOI76idUftfMSzQ5lw3+PVGPAGP6K0ekW+BKsSl+9lrIfQEuodLAcyz+bYiun4PuX
	Gjd5V36XUcRnnPcNPdE88iVs3lu+hbU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=exhUTgtL;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772102988; a=rsa-sha256;
	cv=none;
	b=dw0XfrSbnvWvhdeFzhBxyhhqq+oXDkjHblIEg9pLeLn0c24GjVU5iNeTmILekVAjaQnFVq
	zdB9WAfaVHwGEnLHCaD02dZF3DPnIPcHINQnJacX5EHi2ufsefuqgr2uSnWCKpz1SnVNd2
	s/S8RSiBf7HXWBjtQx/PDZgbeLf98Vo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9673B433DF;
	Thu, 26 Feb 2026 10:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655E3C116C6;
	Thu, 26 Feb 2026 10:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772102987;
	bh=w+0V20EBJh5qECvkc2OQ44zCAneRat/noqNIUiosghY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=exhUTgtLyFPrajFWfC8pgQCO2UoCD8uLPLhnqXImqCgZaJNT6nv/0iY1krin8/HQD
	 YIQerDYd3Z2xGKbU0IaZYtLKP0djcJGyl52lTOAdexsZq55hqw4rbMUWXBcyMISSZ2
	 +/HpDXO8hiT6NVVjRpzXSadZRJ0Y5HndqH+bjAo3YDlCK8EAkEiGNK7qus4iY7WHzy
	 qt+dIWNTGHqM+8T/UCDGBfULdMOwG9jcYAzkHslmmNTOd4SD0MTWbOBXAMDMUKfFLA
	 GbMyUOyvg9LmyfhVzWU5I4gdRS4NdekSsW9+U6DifVjLyVnq7nKjUJtbtvx3WVGk72
	 3GyBkbOh5iXSQ==
Message-ID: <ca7de272-2c14-40d1-9c1f-fdb1a6488137@kernel.org>
Date: Thu, 26 Feb 2026 11:49:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
 <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org>
 <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s5oqsmyhp94am8xe7k7cy1oaey8m4xci
X-Rspam-User: 
X-Rspamd-Queue-Id: AF0D940007
X-Rspamd-Server: rspam01
X-HE-Tag: 1772102988-895001
X-HE-Meta: U2FsdGVkX18EMIJJD0pxQh1dOInW9v1UMAFRIjwou+nXUDiLfsGlm4PqzVcT4pOhffMauFuLzNytb4qOujq3c0mh8sIgAWjIIiFJ5+ZKBEQj9DdA6clPmIrcO1fSNCT7HiViz/oKcNElG0MVjlGC1GeHYkotJc01vboC3AE6jp723iVuO6fGDYKILtWIW26RORnClVOtxF6rF54EuLR4g5Gl2bcQ46MinOcIoqhS3yH1iOLWJuH8rh82icilujElLoGYlCnFoh3JJPuAwbTxEmve7cJgV4jAeMXdGaaVHx/9l+jbFbAvKcDiad+R7jqpuwe9R83IiSFFO6doybSrE10/A6atjFI2kMSnIDboC40WQEEWGSkY4j2frWKgZfpyBvJIVs9MsHh/E6aGluwlUciEZfz9AA1xi9KqaTjM56/FYs9Q3Trfn4FOGUl0Ee0BAZKVnMVmJQv0G8z6QSATvEQ/Z/tLAV4VF12szK1HWwZo2mJzu1yPl6/su/3dNV4YlJAaxfesjOERZ7oxXxwvMxGucge4Fwrw01kCXXooN041txbmMuyJa9H2HrbEojvJ9eIvagf91ityeRYhEPpdqktnyH3cojBXvHL5qGHwreMNC5cZh0/ONEesV2VPWomSM1ZNVvPxjFJQRU7I6a/eNd/oXZA3RMwsYNvcVwMKy/P9LudbVIR8PVtB3/bIw19efx0njmh1nHs/NtBAQCgkjVtprip7R7EVTtouzPHMPIBGF43GpKzTwd8odT06wu/D1o4MFQqdZ4PqnohecXEGaEPWDFqTtUFtemADjn1ZjLgQ1dk1Yqop9DwHmTnzZTewqAkvNP6F5WhC4bkN36BfPOucClbkGT5QknegBpEQ7t3epwd3EtNm1i59CTFn4aV1sZzdFnC2Ita8qkj2sp5hC2hkj7Id/LldFRKcwlnLXDvRC+LCMUK+gIG6syhF2TohmFUidEHAWmXeGbhhzN8
 UtRHKigj
 rs8xQLSrkUscjqTnab4GbHxCnZtywJRWe8NV25mvDjcKxPqDWVPqg/G699yf8EoeVWkfvav11Kgs1qgqyU0sOVjn4yULAkKKsztznl0ls+tc7THVgx3/+C4s+wHCjRN8GfYePpSoeI2YS3cPvgzycbt6+ZxTD0vzfEdj+R4hWNz3cZ81ku18kdcltVQF74a+G7sh37z8RABpiGiEvJC0H8vO7uw9okxaL+4A/GiXdwGpQl630xKVKKvKOLalydW2qHRStW72QnZS5WFzi77rFLkefgQ7mrOjXjr/d5LRUpcL+/Of4AUm5EqMF3Pelc0Us9V06tBm1GcgNO00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 11:38, Maxime Ripard wrote:
> Hi David,
> 
> On Thu, Feb 26, 2026 at 11:25:24AM +0100, David Hildenbrand (Arm) wrote:
>> On 2/25/26 17:41, Maxime Ripard wrote:
>>> The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
>>> free, respectively, its CMA buffers.
>>>
>>> However, these functions are not exported. Since we want to turn the CMA
>>> heap into a module, let's export them both.
>>>
>>> Signed-off-by: Maxime Ripard <mripard@kernel.org>
>>> ---
>>>  mm/cma.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/cma.c b/mm/cma.c
>>> index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba4397f018f6993d962 100644
>>> --- a/mm/cma.c
>>> +++ b/mm/cma.c
>>> @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>>>  	if (page)
>>>  		set_pages_refcounted(page, count);
>>>  
>>>  	return page;
>>>  }
>>> +EXPORT_SYMBOL_GPL(cma_alloc);
>>>  
>>>  static struct cma_memrange *find_cma_memrange(struct cma *cma,
>>>  		const struct page *pages, unsigned long count)
>>>  {
>>>  	struct cma_memrange *cmr = NULL;
>>> @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>>>  
>>>  	__cma_release_frozen(cma, cmr, pages, count);
>>>  
>>>  	return true;
>>>  }
>>> +EXPORT_SYMBOL_GPL(cma_release);
>>>  
>>>  bool cma_release_frozen(struct cma *cma, const struct page *pages,
>>>  		unsigned long count)
>>>  {
>>>  	struct cma_memrange *cmr;
>>>
>>
>> I'm wondering whether we want to restrict all these exports to the
>> dma-buf module only using EXPORT_SYMBOL_FOR_MODULES().
> 
> TIL about EXPORT_SYMBOL_FOR_MODULES, thanks.
> 
>> Especially dma_contiguous_default_area() (patch #4), I am not sure
>> whether we want arbitrary modules to mess with that.
> 
> Yeah, I wasn't too fond about that one either. Alternatively, I guess we
> could turn dev_get_cma_area into a non-inlined function and export that
> instead?

That would be one option, yes.

-- 
Cheers,

David

