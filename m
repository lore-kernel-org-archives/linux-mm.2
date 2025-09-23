Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2CB7CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 12:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DD38E001A; Tue, 23 Sep 2025 08:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2550A8E0001; Tue, 23 Sep 2025 08:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144658E001A; Tue, 23 Sep 2025 08:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 000D28E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:00:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B41E140499
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:00:12 +0000 (UTC)
X-FDA: 83920371864.20.5F01C27
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18B2180010
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:00:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eIVlhxbU;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758628810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mrXBzKlE98K4LjZsBmWzxI5rao/AqbDX4qmTQolpII=;
	b=5nO+43WfMF80NxByvlyaiUwtjaFJqcDpIw+kmhLRbNu8jQV640k0xyXI05FzBrPddIvfnV
	51UmpWb0UwwX/qMfmcjeRsON8SQGUIa+XXmCCsu5AX9q0sE8mXmP87drWp2r6o83dJ1ONS
	9Ju9RQetC/wg8PTJdu6Vds4sFZ0nwFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758628810; a=rsa-sha256;
	cv=none;
	b=hq5H10zDicww2oFxs5UrPWR5AqN1EycA4dLD0kWE8jyOtEZIR8FzPTRpUUpsDAaYNWjpjT
	NtekmknkfXFyMd0MKAtRBHJ5OTWSi0Pi+o39/QnwnAI2DrgPEBZwPBL7DObOwgqpLytfSU
	Q7pUK560vQma+f1i335S9YkpTbsjJxg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eIVlhxbU;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758628809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7mrXBzKlE98K4LjZsBmWzxI5rao/AqbDX4qmTQolpII=;
	b=eIVlhxbUjhJQyvWX7d1U6YbQx8d+VvLWzcsQegn0cAIEM9XFOjOmoKWmmwhJUmvzvuIkXW
	nyPg5l8+B/CGaZRcsQzhflVsv9JxhZKfmu+USmf1vTiJRHK+w72HGAtq0WK9hvl+k/u10N
	PcU77NZ+HGrYDOJ/lRZRZ8E7jBuV6C8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-96P_I_QnMje-o47wccnWAA-1; Tue, 23 Sep 2025 08:00:08 -0400
X-MC-Unique: 96P_I_QnMje-o47wccnWAA-1
X-Mimecast-MFC-AGG-ID: 96P_I_QnMje-o47wccnWAA_1758628807
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b98de0e34so46349955e9.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758628807; x=1759233607;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7mrXBzKlE98K4LjZsBmWzxI5rao/AqbDX4qmTQolpII=;
        b=QW5ahhswf0J4OulEPhplcuI1fUgm+R9SvCnoq+suMydeacA5NA60gmt23KExS0plSN
         LoJXKF1JeR6g9FROOrb3gUC6xn4u85myTumic2xbyBnh/ij13rLoy/WmZNqeNzbKuoa2
         EfGoJi71zmut0YMhooCtelVDyF+n/Y1PpWtzwKaFBIngSxOrW/m34K4i0peZWKdv7mdV
         W4idI6J22mopyeJ8P3x79BnkvZb4fdamdi2FcBQcK72Y6QY228Cy0GZNGMf3QluRvMN2
         uyB4ZwgtErad0KWNAbJOMc3nUCgsCfkC1QvR+4pouoMo3IiADlHh8Bcs+BSF9wO1uk3f
         E/2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWO8CHColLPgtqDXoW3GECetSEyR39SyaSGZsiZhkvUEGXWV+vGI1Py3cHPEDvr4uWIYOPBXwiatw==@kvack.org
X-Gm-Message-State: AOJu0Yzj0ncByh/OvYx+tQ5yzoqrCe7HjyU8f+o2ofyOpzaEOWAnXQ7A
	Wb234ZjqztwGZ0xOk1r2+j7oDnnlvoyzpuF+DlPvrfFhKtpH0NEvZ+x9kFnuFRzr3mxM4SPMw7D
	z4e1IWCPC5kJfYomoVuOIQUwEnyUmoK94FnusBg2UEXe5IfZ6Flab
X-Gm-Gg: ASbGnctclo/CbkyMCOtOrR+IvEpJQQkPAk/jTfFL+/+coRkucTHSYnSIxTzQxJrONRw
	wfE4JC6e28JSfZqVH2P+3JRD9QuzcT4lUfZjB0doZpDNupDEfwrRfTkAe4i4dxJoMNa81oQRjga
	JaVVxjr4EWd9sPJoKJerugnahXgPLcxcOAmgGO2+OiaBQgOrRHu4CMBuLrDjjtrtHMxRjqWU5YJ
	o6U7JDiftx4I3LR9cR2m2HySZD7BcevwCPFkfMsj8XZ21OKR4Z9Vk48FNUAaIqOtalieqesRgYA
	1Wb3nInKgPBi7o88g0AnikPqO8zpm2oW1ap91U6x8CaeqKls5pVoVJ89Xl7HHgMxb71TLODah8f
	ra2T2rXY9vD5Ro4Dmy7IAN4Ov1RqDRf/KCaaJl2xWF/w4tAdL2rOAKksKWjwu2RnkoA==
X-Received: by 2002:a05:6000:1816:b0:407:77f9:949e with SMTP id ffacd0b85a97d-40777f997b1mr755887f8f.21.1758628806758;
        Tue, 23 Sep 2025 05:00:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHc0tnWNhOKVxns9wRVC1qKaXSvIIx3ibWsy3DFh5QbP9+zrm0E/5T5FrXDNhPOpzrAGAyoZg==
X-Received: by 2002:a05:6000:1816:b0:407:77f9:949e with SMTP id ffacd0b85a97d-40777f997b1mr755855f8f.21.1758628806098;
        Tue, 23 Sep 2025 05:00:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f9c62d083esm11713443f8f.32.2025.09.23.05.00.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 05:00:04 -0700 (PDT)
Message-ID: <8bf8302a-6aba-4f7e-8356-a933bcf9e4a1@redhat.com>
Date: Tue, 23 Sep 2025 14:00:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, usamaarif642@gmail.com, yuzhao@google.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 voidice@gmail.com, Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com,
 hannes@cmpxchg.org, kaleshsingh@google.com, npache@redhat.com,
 riel@surriel.com, roman.gushchin@linux.dev, rppt@kernel.org,
 ryan.roberts@arm.com, dev.jain@arm.com, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, hughd@google.com,
 willy@infradead.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, qun-wei.lin@mediatek.com,
 Andrew.Yang@mediatek.com, casper.li@mediatek.com,
 chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com> <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNKJ5glToE4hMhWA@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 15PXUoHo3aA0mCQyIW29uk796SShDaI5UwnM75kvBsk_1758628807
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 18B2180010
X-Stat-Signature: 7xaowaw185ore7ephwb5yyxwekadexab
X-Rspam-User: 
X-HE-Tag: 1758628809-959135
X-HE-Meta: U2FsdGVkX19Pn9etH9YwwZZOU64pYr/2JQeldrpVnxJbmePJ1JlNjcvUgfvqSnnNZvr2biMlWYyVokjtEdqmzhynrI7yQYhDO11wEdcfAvFBpvPjB2B85mzLc66AtXFhw34874qBcta9jjgZU4sIC+d4SzgT2jQ76sLXzebM23jCVBRVYdlUX3gU/tcJJb2tDXd5RaudDKSn24ANRN0513ixoDONLGOeyLUaRtQfgDM+4ag3Zwdk9ZFyDbkIGqXYOKldYzOKY9AoKejn0aZejbh+yB/Zwngonpzu/vyRwGe4ADz/zh1MuH5A6DdE82O70X+ehKiZ7ob91XJ9a1vIFbknfPDLi7pcIuD0R7PSxSMnQXA5VWBTFiolipLHgzRWTR8ojdUZOvvmOZbtr+kYUo/SSTy1gWXAqKikNayB3dRvuOSpAtnppG7Fnrw44ww0l2T2zYcHu2ysvlpguTpjShIjtDhlXU/Bn8kCumz9IsbO8MsiCU5/5dTQGBuCqnuuiAcfKj0H6tdI0HoZSG5iA+WCXhW7P3KDTgKR6fn+8dbBAxSk+aPN9lHrgy4+5zziKxqTg70oDZcaGqd/wXqsDunnoOSLRgweIqvAxMvHYCArp7P5j6gnP7IJQH7meYdQ1fj9zcuu6omMYoK13E1XuLMLiDRHJbH7W9qD7RdSA9PAf5E80/viuUZAi+ehbmrDExqy+dRWqxzktBQLrmU1zQHuQHiy3F03zRkIYQk4NNPI8pGV4HtgL6I0K5LdYZivqgYi0E9Tj8+eAQxrIwWpWdTANabKfxtN4SG53iy1aLOTuZihjMZmBJUyEQoD4+l2eRvIURwLsNpVv067VSrPZnMAzrnGUQm/0LlseuYMsfAYPxQu6I1y4voukF2KhOxHSNJAyzkpvBY9KxMZkhQNnlt0HAsD6qhQmagUiJJa9jcOBe9iiIcpvcB4jwUk6aCA/1JGx04JZCxnY+8cd1d
 BLxpil8q
 I0Nci9nFfyxLgUz02hGAK36jw7qhDeLiH29v77U5bWVnSCQto6InCcqKBax5mW9kRrPW7NR4mnRY0KDI5r7SEM9Tw1C+ZnQBxwMBiGnXcu3GvB3gnujmK0yYfh1yVyxxVauY7/XCUTEsbEyO1oRf9VVACMuKaArgo8A8c0ZbJkh6d2DT+ElrjD3PmQcsb7HSDSoFEvupvPHHz8KVeCylEXbGdjJtsePoBasQA2BVfsLBXzvEetdR9XT3bNTWkOnwNegDKB+QfECBE2dOl9FOPBHjm4oRfrVDeW+q+v0c8G8mRUH0rQGxikydeCcXL4yzZuuGQYyRJjbxfVs7t4jSInAwUgL5oHbMwbtlMyVlyUm7RlB/T94aoh0+/PxoJWpsKXSxleZ3S1ajwfDCxPIM1QVMCw/8z+o80Rv3CD5xgdcjXXPvlJeWzbded5DbmscQh2k8Dx3SAo4zQU5lpuMiAsd9lu+0So5JCz647YyEmGx5SppUCq5Sp9PxrDz+LqF26HjyrGlE2PNsNWi5DwZBn3/3O1UqJouXYKHa4oancgjWRcTRV/+oppSdAz4wYPbb14LDku0cEkG2GKNIg83CiApemIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 13:52, Catalin Marinas wrote:
> On Mon, Sep 22, 2025 at 07:59:00PM +0200, David Hildenbrand wrote:
>> On 22.09.25 19:24, Catalin Marinas wrote:
>>> On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 32e0ec2dde36..28d4b02a1aa5 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>>>    static bool thp_underused(struct folio *folio)
>>>>    {
>>>>    	int num_zero_pages = 0, num_filled_pages = 0;
>>>> -	void *kaddr;
>>>>    	int i;
>>>>    	for (i = 0; i < folio_nr_pages(folio); i++) {
>>>> -		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>>>> -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>>>> -			num_zero_pages++;
>>>> -			if (num_zero_pages > khugepaged_max_ptes_none) {
>>>> -				kunmap_local(kaddr);
>>>> +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>>>> +			if (++num_zero_pages > khugepaged_max_ptes_none)
>>>>    				return true;
>>>
>>> I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
>>> former will need to read from two places. If it's noticeable, it would
>>> affect architectures that don't have an MTE equivalent.
>>>
>>> Alternatively we could introduce something like folio_has_metadata()
>>> which on arm64 simply checks PG_mte_tagged.
>>
>> We discussed something similar in the other thread (I suggested
>> page_is_mergable()). I'd prefer to use pages_identical() for now, so we have
>> the same logic here and in ksm code.
>>
>> (this patch here almost looks like a cleanup :) )
>>
>> If this becomes a problem, what we could do is in pages_identical() would be
>> simply doing the memchr_inv() in case is_zero_pfn(). KSM might benefit from
>> that as well when merging with the shared zeropage through
>> try_to_merge_with_zero_page().
> 
> Yes, we can always optimise it later.
> 
> I just realised that on arm64 with MTE we won't get any merging with the
> zero page even if the user page isn't mapped with PROT_MTE. In
> cpu_enable_mte() we zero the tags in the zero page and set
> PG_mte_tagged. The reason is that we want to use the zero page with
> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
> memcmp_pages() messed up KSM merging with the zero page even before this
> patch.
> 
> The MTE tag setting evolved a bit over time with some locking using PG_*
> flags to avoid a set_pte_at() race trying to initialise the tags on the
> same page. We also moved the swap restoring to arch_swap_restore()
> rather than the set_pte_at() path. So it is safe now to merge with the
> zero page if the other page isn't tagged. A subsequent set_pte_at()
> attempting to clear the tags would notice that the zero page is already
> tagged.
> 
> We could go a step further and add tag comparison (I had some code
> around) but I think the quick fix is to just not treat the zero page as
> tagged.

I assume any tag changes would result in CoW.

It would be interesting to know if there are use cases with VMs or other 
workloads where that could be beneficial with KSM.

> Not fully tested yet:
> 
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..72a1dfc54659 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
>   {
>   	char *addr1, *addr2;
>   	int ret;
> +	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
> +	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>   
>   	addr1 = page_address(page1);
>   	addr2 = page_address(page2);
> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
>   
>   	/*
>   	 * If the page content is identical but at least one of the pages is
> -	 * tagged, return non-zero to avoid KSM merging. If only one of the
> -	 * pages is tagged, __set_ptes() may zero or change the tags of the
> -	 * other page via mte_sync_tags().
> +	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
> +	 * since it is always tagged with the tags cleared.
>   	 */
> -	if (page_mte_tagged(page1) || page_mte_tagged(page2))
> +	if (page1_tagged || page2_tagged)
>   		return addr1 != addr2;

That looks reasonable to me.

@Lance as you had a test setup, could you give this a try as well with 
KSM shared zeropage deduplication enabled whether it now works as 
expected as well?

Then, this should likely be an independent fix.

For KSM you likely have to enable it first through 
/sys/kernel/mm/ksm/use_zero_pages.

-- 
Cheers

David / dhildenb


