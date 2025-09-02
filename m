Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADD2CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1692B8E0007; Tue,  2 Sep 2025 03:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141478E0001; Tue,  2 Sep 2025 03:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F858E0007; Tue,  2 Sep 2025 03:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6D818E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:49:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF1BC11A1AB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:49:55 +0000 (UTC)
X-FDA: 83843536350.08.30ED584
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6355240002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:49:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIKe0zpp;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756799393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHVHx/+P6A3oOw/REhPFFE+HyRwHnNoOuSJdLwK8AQ4=;
	b=vUlTC6bg+xloRVGIRHOZ/4yZGixtNkw/dA18r8GDbj8rCO/luJNyXzE4lkPODBwyizUg0p
	RKSxXv4z6pmVqYFCFCJd1QIxiOGr2gXWaJ0mh0LfgnlnJKdnBCuPUOgG4gGNW4T3O4+k1C
	Eg5ajrD9j6gH6vTKukOwp6trZBN5pho=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bIKe0zpp;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756799393; a=rsa-sha256;
	cv=none;
	b=cRg8F09G8ie7YBt7JVAUYa91jyL0lPnT3Hq7OCI/BSZGl1N0zFqnqTO41e8qWjMsGV95h2
	izShi7hnjClnPAhJsi18+KBVkOfyyErMDPDjUF8opXsGL1FvEuGeWJAx9zIZ0Oih8XNqnl
	YjvsINerQvH/0cNUfedvQ/5fT8pk6JQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756799392;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hHVHx/+P6A3oOw/REhPFFE+HyRwHnNoOuSJdLwK8AQ4=;
	b=bIKe0zppyR7wsEENzUU06u9EeMJJK6lITMmVwJsnelgZuxEcYV04SEPPXUs1AI4ZRiqbSv
	EKqyFKZwtV3I4VxRg+3IsPTlDinRtWe38jSi8qd6xFnoyTVn/1hhEttvle84tj4diclN1a
	79tgqyDqQEtDss0j+TMm8n/ZBzyUGDc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-tdZa3c_yO5m_4LXe0Q6lFg-1; Tue, 02 Sep 2025 03:49:51 -0400
X-MC-Unique: tdZa3c_yO5m_4LXe0Q6lFg-1
X-Mimecast-MFC-AGG-ID: tdZa3c_yO5m_4LXe0Q6lFg_1756799390
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cbe70a7861so3663306f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 00:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799390; x=1757404190;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hHVHx/+P6A3oOw/REhPFFE+HyRwHnNoOuSJdLwK8AQ4=;
        b=m/K9Ys4UbY4fAmaC/MBxaLUUrIfdJSsPMeZcKxR+yQa9rG+jpoqOZmDIw+90sbSdVb
         FqmFKWC60iZiklbNEVFJH3eW63LmQqv0CufrD8S1vw8IKo62MZ8mMJGQZXBeIVINbDyC
         RIoeh2czkouTijes/fMVaUyI6xScHEKBIbZu7r9g7pFH4WsD+fDN/5jdkJMDrwGnbwFP
         xx3RnD5b/swg3CNjFjSuvOP2LXwMjLEWKq4NOegjm9J7xNj2ExQUQA+vYQETom4qwcrP
         rMX0ghZOb1a44xhyQVDeD8MGH0Bjr87FaY+ugk5gWj4IeKANpgPPi3exkx2u0Y6kwBg9
         5tOw==
X-Forwarded-Encrypted: i=1; AJvYcCUhuqzlUYZIdUH51p+YSx8EP/6Tni5tc3Ues4yR8cMoVKHUnaMjYatT/XbgAV5xQikINWgg5Nk8UA==@kvack.org
X-Gm-Message-State: AOJu0Yz6vDNvBfhAPvNEPtokq9lOMv+1jN+kWPQteQnJ46/4iJof0jB5
	eqjDiI8fXSocBDRnwgWqePv+4SM4l47VToN4nUuifuZyGGPjAUBaAJbUP47YcyVLHC7PXqlCHAq
	CR3kGN9MiZOGyXGsZkVfyFVEaxudNDkK7FUhgkIoEdKsQjPWa0bHd
X-Gm-Gg: ASbGncvaBD8vvrdP7B4G+rNsGU+lk+anqO/4NfNTbKF6z2MFL++jB+zUkr1EMvevOy3
	hLwKWvjwk+CMoVpKovj9l7r2eAG5UWVRH9ODFr9sN2rYhkF2lr2m0Tcr8T1KWtkP1o3CIv6AlD/
	5TMkUOYG/m6IIPzVBqyGyFSkR4NndkwR9C7fshD/uQFPvghILfUH4iBjjB48pGveoc42KpNX1e0
	A8+QqEvhG9A+hsX0qcPKV8ehfZ2tp6PCXeXTkLyUxFDY+z+4UuDaAtZKYu0KXlZ+W0p1HT4sezx
	WSss0H9d6wqB3CQ+GaTgqkaizH2goYfFTl48n6usIXfu9Ya3U+wF494231ISvNy3tKMYVZS2t6o
	WzI3XCzhX+w50fScv7gQ68tFqpVIkAQRYrq6OgBk3K2Fl973toKt5PHr/H/d1oEagr7U=
X-Received: by 2002:a05:6000:2204:b0:3c9:a722:e189 with SMTP id ffacd0b85a97d-3d1df920006mr7643382f8f.62.1756799390132;
        Tue, 02 Sep 2025 00:49:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGuDBI69XEEhubRkSjfJw5Jpg1YUgWVdAxF+z/bqhAU2b1VzSp1W9hZ6ptgSepPCQNp5CF6sg==
X-Received: by 2002:a05:6000:2204:b0:3c9:a722:e189 with SMTP id ffacd0b85a97d-3d1df920006mr7643358f8f.62.1756799389677;
        Tue, 02 Sep 2025 00:49:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33fb9db4sm18611700f8f.47.2025.09.02.00.49.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 00:49:49 -0700 (PDT)
Message-ID: <dd30710a-a210-44dc-93f9-1e7ddf096251@redhat.com>
Date: Tue, 2 Sep 2025 09:49:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap
 corrupt data
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
 <f8e942de-1a50-412e-9020-1bc901b4243b@redhat.com>
 <61E58B7C-23D0-49FE-8D0C-CE0B672114E2@nvidia.com>
 <0a0b0018-9427-4201-bf53-6aeb251bc482@redhat.com>
 <1D88E773-C11E-4F28-A13A-1A681898198B@nvidia.com>
 <5a796574-0a3c-4040-b0bc-3ff757402759@redhat.com>
 <20250902025112.d2n3o4imeptppctd@master>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902025112.d2n3o4imeptppctd@master>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CIn0mcqb7zrigqRsJbbzJoEfFFfI0Uaqnlo-NkVzPcs_1756799390
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o8nmxqtm7zswf3djtc5jubtbk6kdr9cd
X-Rspam-User: 
X-Rspamd-Queue-Id: 6355240002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756799393-82428
X-HE-Meta: U2FsdGVkX1/uqcFyc9OjT+07/SK02LuWSEJdHkBvdyaGkDec9EDNbmeURlqrQgt7ac/Z+bR2PchRhoEB7SM6uRv2rFVVpZj18UPoxTZx9p6DfSa4rNHmx9e0HE9ukyILKmlm3yv8+gJE0o7wO/fA+o3pFhdHHYDARqTIYugZBryFyZyJtKV5+vwFICqX7vmAAiaf9orGQsgnmj1LXeKru64HnrHnVyaBuJyoyRBgxtz8Jqb8sLblkglSJQlwVhIW3cTRkgMWEvr8XkT2NR3FDFyJStDCzLdbJtlmbBLHPVaVDrLfU2PLAtE+IXPNbvYFmB6M0CdGmU29u+jHB1Hd5iTKFMeYVCyob/w+IDC68E3CcjQ7fLGG2H+kavYU5oEP7Fe8OuFTx0mzUlmy4RefPV/tP6MhDYuIJEVy+e+YmPAQBLh6V7SeYqwMqMgCIv/nc0P1jlptmFyWbbiZGjX4G1wr0/pgwD8hrRxy4yrv6A6mlW8jKP44SdH20ST1tMT0KdC5s/axkwe6A2kcAx+Iy8I4GcS1m+qA/HW4FEd9prgJIetmBkZFfsCTvSiQhYJunQu47fKOX80klUM1C5TH54WnR4sNS0Qirbodz11+f4cR/hDgM+dyWn09ClEssoIDq4PeQbV3MEULU6GgFO0yABJASKYOBd97y3j5J0Nw9EsXN5p42T15kQuiGi7+LAxIsczf2MQeKb5sXLWxOYXtfRbyIkwrqICdjviQW/QOrcVg3k0u9clu7Ff20y5X1gRgTWikIkzkCjkxP2DyQMBQjXDPy+cYEaRMMz/d+7xFfQ2eZMTFElYSmlumb95UGXjlNrfvNdYV7hPCnrhEB/88swdEA6E86Go0y13EAEb3iE6YWihyaRCwwfcSQWujLx3IkiuE+uJYP7RgVphiwyR6kBGePJ5k3mX+ZYOFUOoa7uibnLIn76DvYWsHxb/l0yYmzOork3KBMsC6vaU+Ok9
 0JSQOWBa
 HQeTK2SKApIGUuJhUhmkiT+oEiQbhFikWE8qXbpjXWxtlCLp1M9kwuiA/e3sqzR+1nRrgq0W0o1BJi+3+WeqQ1y6fk2HnaNn65Nqday4VhCnOQFomQ/7aJrApSy3CbYcWFQ3tUAnFuH/h88Yv/f1NejCk4VSBR/f4uKJzu5qNZoyiZ+z4FkULWMd1FRQGX5hqjXZku8JbnvPqvFIakJFnjFGhaUZGciD9w+PbyvWRFU2mpCFfY9lkb5UBLafVdkcZDs39lF1JqpwHooDImSaCNou0B9u/ZG7+FG5YaQgnuXlSMm76QeAaJuNcfepEtxnCPL+WzW8yXPNi/sueG1YRq3ESZrtDpN/ecGrR5vZJFmdAu6+1Uugxzqt40sL3WpoKZfupRdmC+a6R1XtCpBCVq+CcC3UGzDjJoF1tRxhBtEDwCx3e4lt88ERXBrMGA8i4qssWh1BK/cgJ+26AAz08O4B2BuGJsnFXe4XEw5ARsoNidVfNSymCJz2oQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +	/*
>> +	 * To challenge spitting code, we will mremap page[x] of the
>> +	 * thp[x] into a smaller area, and trigger the split from that
>> +	 * smaller area. This will end up replacing the PMD mappings in
>> +	 * the thp_area by PTE mappings first, leaving the THPs unsplit.
>> +	 */
>> +	page_area = mmap(NULL, page_area_size, PROT_READ | PROT_WRITE,
>> +			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>> +	if (page_area == MAP_FAILED) {
>> +		ksft_test_result_fail("Fail to allocate memory: %s\n", strerror(errno));
>> +		goto out;
>> +	}
>> -		if (i % pagesize == 0 &&
>> -		    !is_backed_by_folio(&pte_mapped[i], 0, pagemap_fd, kpageflags_fd))
>> -			thp_size++;
>> +	for (i = 0; i < nr_thps; i++) {
>> +		tmp = mremap(thp_area + pmd_pagesize * i + pagesize * i,
>> +			     pagesize, pagesize, MREMAP_MAYMOVE|MREMAP_FIXED,
>> +			     page_area + pagesize * i);
> 
> Would this create one hole at the beginning of each 2M range and cause
> splitting underlining THP?

Yes, it will create a hole (this also happens in the old code).

As the comment above it now states: "leaving the THPs unsplit"

There is a check verifying that after this mremap code.

-- 
Cheers

David / dhildenb


