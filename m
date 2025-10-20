Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C61CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B64F8E0008; Mon, 20 Oct 2025 09:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267748E0005; Mon, 20 Oct 2025 09:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156998E0008; Mon, 20 Oct 2025 09:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F35B98E0005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:07:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AA8E5B63B3
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:07:34 +0000 (UTC)
X-FDA: 84018519228.05.A41D4BF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id F1A03A0009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:07:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RYTIL5yp;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760965652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQnGr4b9U5QOBYe+dmGVBE88kZZJ6il0l1xseD4fJuk=;
	b=zcFAvHrQNAEdRMnruxHB3Xk1A6rSDlJyp/BJMkwnM2EWDED0giu4AC4GbkH4twM9LqVeaN
	77nzc0hnpT4VspFqRV0mtjs7YlVgFxmJPxHEBrNmNeSLQ3rR/nzv+oE9WVARVyHwqiPmQi
	HNJEi96aEyBNxfOBM/Z6vbW85h5XHMI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RYTIL5yp;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760965652; a=rsa-sha256;
	cv=none;
	b=v9oDPXJpLMZzru7mVigS9Orc7rqS0bbJzxP85uopGq1//2nvssJLGZcaWgsK1tSFkn8ySh
	geCNoIqosF9U4rd40NaWkQfGVofIrQXGyRIlgYE9EWFT51bbQDqK9QfjaTIFmUzaYj2Bhw
	08gtYe7/ILdZN/HU/I/rQ8URWl7h8ho=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760965651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TQnGr4b9U5QOBYe+dmGVBE88kZZJ6il0l1xseD4fJuk=;
	b=RYTIL5ypHd4WtFsuPdUrmDW1nw1ih+gOs8moh5u06E3Ko4rlB1DkPNSjwbGpXf36D73HBm
	UZxVcNG2kspD4jQFre+oQ2fdvt0DBU2vt1xbi/ACdZepTlaX5YLiwiUMijCCXTU+dgamUq
	0Xl+J1VopJEGbnJMYIoz7cn+ZWU2kqk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-1bHKbQDxONC_en0LzIDdpQ-1; Mon, 20 Oct 2025 09:07:28 -0400
X-MC-Unique: 1bHKbQDxONC_en0LzIDdpQ-1
X-Mimecast-MFC-AGG-ID: 1bHKbQDxONC_en0LzIDdpQ_1760965647
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4278c82dce6so1537622f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:07:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760965647; x=1761570447;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TQnGr4b9U5QOBYe+dmGVBE88kZZJ6il0l1xseD4fJuk=;
        b=ZwUwmCxPOKAFXZfxdZgK8SXPZjBwyWbHkUpNEsItnjiiU8+iMaEXUV86Cn+hMVyg3R
         kELJ/Ez+G56GBcpgsqlYJfMKSXZl+96hzTDX6053p/xcwC0D7V7AHQx1N1MQj+q7fTfl
         j17drK5LhlKKUdp91kdo4h35iRr9ZOtncQ9zqkts4taLXIaVftB7MKpCCXLgiHnaxalE
         L38jdPJO3cpzAOWCPmXbwiwJMQErcsi8uI8vJycYOgSbwiO3cvFRrLYt9FQEJWXkMYUz
         QnpxT//04BoYZrOrSJJ6J4pd69emHJemyhy9qP8MD4n6iXV05PjEae03nkT4v2B6MkK/
         OHdA==
X-Forwarded-Encrypted: i=1; AJvYcCVo2TWvxcgc0VaIBNYFFbuKG1SES88nEyd7BDoMkxN29NgHc4tFsewc6E+1kH/J0AhPDP08JAywhA==@kvack.org
X-Gm-Message-State: AOJu0YzE4KVkT7uoSemmkJJI1M7hnDI15/BSaxcOb85nPqrLu9+huvVy
	tOlnbFjIDOzSQABnwKvdKE/5k5nJ0I3iv/ORZu4HvTeC8fbzToxPaAY3pNcl0TsRrZsfIMBL8m0
	I18sSFouNxSmx+Q3Z5dHumFosV0zTzsFm8oZ2/1bt2vkIQGJxQnb/
X-Gm-Gg: ASbGncuwuWvbAdx0PRn1FkuP/57Uw2c18H9XPRGRfJsEXyD+w7CJuzNQhLvI52H7jSL
	l3T2y+v3sHpjTxuvVYmkt4oKAYopksV5+9/1t4/TOoLCOUlYnn8qJlSP0IglkE4UiB8Wpr/5xxU
	sUdRiXlOrIDxnpelMg//6jOlFb7VpSwen8RG7jQxchwHiXV0BoKLk9p0ZUujk7l9Ku4OsJC4dXS
	ZpBZcAQlHkXxXovcio911+qfIei9jVC4WSAnCOY5PdkvzIr/OSSW3EnRxqr5wqwfyg8nnzqZLdv
	ihVU/FUGdxUfpG05YrMeWZOtbH/a2l0lhLFZMgMyGOhizFmfqeQmbz5AYDbE7N5Nwi0QYlsOtC9
	gS0gMZesGW5OgWswrbu/bTUIPLxUAV4Bn8sibf+zxZaSpVLe8LsyoPRjR7et4cic6agSUsf5aO6
	7IyYIHud3D586FVGSJQgGX5Q81mNk=
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr8780790f8f.44.1760965647424;
        Mon, 20 Oct 2025 06:07:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHv0VtqoqfOvl9BPINa9H4p8Dd8b9uYgovR/692Ug1UdngPFZejw2dnn2oKeiilZI4vzwyCxQ==
X-Received: by 2002:a05:6000:3105:b0:427:64c:daaa with SMTP id ffacd0b85a97d-427064cdaecmr8780762f8f.44.1760965646926;
        Mon, 20 Oct 2025 06:07:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d8b2sm170909275e9.3.2025.10.20.06.07.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:07:26 -0700 (PDT)
Message-ID: <9ee230da-3985-4fd7-96a1-6ea5ce55d298@redhat.com>
Date: Mon, 20 Oct 2025 15:07:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm: page_alloc: add
 alloc_contig_{range_frozen,frozen_pages}()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
 <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
 <56ad383f-80c4-43bf-848e-845311f83907@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <56ad383f-80c4-43bf-848e-845311f83907@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fi43tZl_14AwpnyrukBsras9slvE9_e4D8n-9O6avmo_1760965647
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: atkier4bu3jycdn15zj9dtyp1hac5npa
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1A03A0009
X-HE-Tag: 1760965651-235007
X-HE-Meta: U2FsdGVkX18cBA9m1srkrGvOaSOww3pq+P2UqiBLKRQdps9ars2jIPlxXNnu89RkG1nhA4ETp6MC9joT6A3jKwIqx98EwYFsBWwp8G0zVQC8/LTj0UfrsdlMpFN7Ood44cvVRVOnQt87whqdjHMKjF+wL31aj4/hb4bhVkBpG/CncgHDY6NMcZg5n48EkK+6tANYO8pRwjQP9ip19XI1p/lpbNS2OSIyfe4eiaIAK8XjZjRjiXBeLsjmcRMY4MuAe3uoebGIvg5RxF2ik9/KqYymZxjGHhMidJlIyqxj3fyjTmPyRw6dIzhdpXyxiGSj11kpqZehIu3e1+ZzwgUBk2gABxZoKVPM0WVQzZWg68T3uFsJTLcPyGWdoaDbhZHVNaUVXgwyJdW4vXk7xRrVpp8FDAbEkk+jrF4QKWWObsScyULnZn7AmSAHNtNfaJ2oVT5bqVBCNpYu3XHbXNfNIeh/Ee8yPv56b29DbkskGKPqJ1MHE0bsnZaL2hCec/k3E7v23sWxBT2YwQqB7m58ciZefv/ueift5AAqDUAPRwqrUjo0DPpdMO8SY6l8cE5iWfwaa7NxeA8T1jVUjrHuAToERUW16v0nsnFTEbqFpeYjZz0TjzoKODusdOJET6YAFGPnqWvDNXeXn5dcBdghpN6c+hWdcp9bGD7MTgfUg1suaopopfUtRwVyXnWcqYMBKsfvtk4dZmwHLBD0v29edBLBrtbyfTT3oFMVi0SOGVmkQu/yr7X/emuq/Or4EjXPsbalpGlWzrzpwmJRzMrYGKSIOOSBs/dtBGbiJbQsy1M5F12OBrlZiTGYl7dsyFopqWJRaeRlys+JaE6/GXQkx9fp85HgGIl/PCo6heB4+jvyqJOXhO9iz+KLVh8Q2btnBwd6g54bKZTTAvegpuKcpZvd//j40/wl/bQMCj9PlaWYmbfUqHKQ7fHiEMbx2p2SU9aPQk4NCPqs4rS6SZw
 rqO8HY+p
 OQpQOz8t8a4TiV7pIgGXroa76O2LrTPxODWHPfYA6V2FkW5H7Q2fyJUje14CFAGQGE8/gOXKKYnAZCzGQeTyP8xOI1A6CSkpE6q/EYAeuJsZ5REX66eFN/9G0nggEtyI9dhS3OkQApFpRSGIeGRyaHHX7wduF+peY0CovBdd/w+x5DQM1VaYpEajDXx7Zh5YBXTh+R2GK1fgfG5llm0GbCC72xU2MdfKl+M6AZfkaHaAUvsgahJKq4FGbtF9if3K9zX48T1TQjOTE3yvefgQIhldE2kAih7ODyKNipn1GJe7wxVXJ9Ci2VT15nGTuPpfSKoshFLf0p3+msSaVy7cgqe9UtJ3XkaCvReoY8Y0I2KG6EUVn8+YS5CoptmKCB+h4NGTTU9SpzRLo495pAy368Gis72sr4eeNc4C5yw0oZzJLTwnw06OJ+4k7G6kQnGJkXZlfSTzqkqajXoO9eBYGtUyuPqYDup1sN1smmToyoIuiIyH2+722n3EDtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>>> +void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages)
>>> +{
>>> +    struct folio *folio = pfn_folio(pfn);
>>> +
>>> +    if (folio_test_large(folio)) {
>>> +        int expected = folio_nr_pages(folio);
>>> +
>>> +        WARN_ON(folio_ref_count(folio));
>>> +
>>> +        if (nr_pages == expected)
>>> +            free_frozen_pages(&folio->page, folio_order(folio));
>>> +        else
>>> +            WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
>>> +                 pfn, nr_pages, expected);
>>> +        return;
>>> +    }
>>> +
>>> +    for (; nr_pages--; pfn++) {
>>> +        struct page *page = pfn_to_page(pfn);
>>> +
>>> +        WARN_ON(page_ref_count(page));
>>> +        free_frozen_pages(page, 0);
>>> +    }
>>
>> That's mostly a copy-and-paste of free_contig_range().
>>
>> I wonder if there is some way to avoid duplicating a lot of
>> free_contig_range() here. Hmmm.
>>
>> Also, the folio stuff in there looks a bit weird I'm afraid.
>>
>> Can't we just refuse to free compound pages throught this interface and
>> free_contig_range() ? IIRC only hugetlb uses it and uses folio_put()
>> either way?
>>
>> Then we can just document that compound allocations are to be freed
>> differently.
> 
> 
> There is a case for cma_free_folio, which calls free_contig_range for
> both in cma_release(), but I will try to check whether we could avoid
> the folio stuff in free_contig_range().


Ah, right, there is hugetlb_cma_free_folio()->cma_free_folio().

And we need that, because we have to make sure that CMA stats are 
updated properly.

All compound page handling in the freeing path is just nasty and not 
particularly future-proof regarding memdescs.

I wonder if we could just teach alloc_contig to never hand out compound 
pages and then let the freeing path similarly assert that there are no 
compound pages.

Whoever wants a compound page (currently only hugetlb?) can create that 
from a frozen range. Before returning the frozen range the compound page 
can be dissolved. That way also any memdesc can be allocated/freed by 
the caller later.

The only nasty thing is the handing of splitting/merging of 
set_page_owner/page_table_check_alloc etc. :(



As an alternative, we could only allow compound pages for frozen pages. 
This way, we'd force any caller to handle the allocation/freeing of the 
memdesc in the future manually.

Essentially, only allow GFP_COMPOUND on the frozen interface, which we 
would convert hugetlb to.

That means that we can simplify free_contig_range() [no need to handle 
compound pages]. For free_contig_frozen_range() we would skip refcount 
checks on that level and do something like:

void free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
{
	struct page *first_page = pfn_to_page(pfn)
	const unsigned int order = ilog2(nr_pages);

	if (PageHead(first_page)) {
		WARN_ON_ONCE(order != compound_order(first_page));
		free_frozen_pages(first_page, order);
		return;
	}

	for (; nr_pages--; pfn++)
		free_frozen_pages(pfn_to_page(pfn), 0);
}

CCing Willy, I don't know yet what will be better in the future. But the 
folio stuff in there screams for problems.

-- 
Cheers

David / dhildenb


