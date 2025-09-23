Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 621BBCAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 08:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2FCF8E0015; Tue, 23 Sep 2025 04:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07718E0001; Tue, 23 Sep 2025 04:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F63A8E0015; Tue, 23 Sep 2025 04:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86BA48E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 04:14:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D29F1A03BB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:14:28 +0000 (UTC)
X-FDA: 83919803016.30.623F2DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id B79378000E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 08:14:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CERViAma;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758615265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyzu1dlx6+kRG0E/HaIaqepYdoWq+jcAQ8sNrE2lYVs=;
	b=YSV7EXM/k7MAviZpLy8h8DQuFavL20U+xQEXmPZzsXTx3ftWhRL71hdk48GxvH8P+O9AqE
	GNis6rfofeEg90d/tJWH1p40CVVWPSL5vi1Ur2DlIvqH+2IakRzYvdfyR6JAdO8M7OJ0om
	JipY2lCJfLMAS54o+S9ijE3sOwNDtz4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CERViAma;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758615265; a=rsa-sha256;
	cv=none;
	b=qUAbwDGHy1hwsL2YK3QYeEafEiR8C1zktu3Ds7PycUs1Aw7Sz12g/y2+5l3exoiNJ1x7aJ
	YwBbsaSQ5SiSEWwlbRLUDrvCbb5gJm7ROU5PdlX/uqAvloeb/bNjYU1y2cFX4JeOnU/zcd
	vNac9svvQI0T5kLCpyVmiDQt6HFOwIk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758615265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eyzu1dlx6+kRG0E/HaIaqepYdoWq+jcAQ8sNrE2lYVs=;
	b=CERViAmae2UhGIRPBdV3inXWyhYYsxED78eZF8Vz/UH/g/NRDYzls3Fpl/DPmFWhMK+/xw
	670qqNMzoNh5uaMJ4TD6BCIGAFzyDBzMaycSE+94eH17mokZw8XaZiSDLZfoOFBfBr/VEk
	c7SvrvO+QRWC4hpViTj2Nu5LkTJD1kw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-yIUr5XeqPH29HbZnAceI-Q-1; Tue, 23 Sep 2025 04:14:21 -0400
X-MC-Unique: yIUr5XeqPH29HbZnAceI-Q-1
X-Mimecast-MFC-AGG-ID: yIUr5XeqPH29HbZnAceI-Q_1758615261
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e19ee1094so15915705e9.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 01:14:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758615261; x=1759220061;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eyzu1dlx6+kRG0E/HaIaqepYdoWq+jcAQ8sNrE2lYVs=;
        b=isFSzTA6MolVk9WxDMNCckVgilb8skxCu2Y1EHiRnQko1Zj3htvbwThi3xdiN47iHn
         sU/oUVrqDyGmtOO6iHc/dF7Jj/G/bnVGJdOwWBe877+gaB679VqSTrcGFkN1PHh3+fo2
         Ja5v6/hxgxri8QJ2UmCkYMulfGDt0AIqneYg2//4owEWwtqRj/MGmhHUFNtIIScWQ2MA
         UpLzmYnQAspwKvdfbTMTXXsMbsWUT/3tqNtpM0pVrWCpQ9s4+aBGNRC00DFB4c+WenxM
         Mu8fUJ1hI2fPXg1Iacv+loDcqVOy/WFB8PzVEJahjZ/OlEf0p5n+3JdV7h+IFsCCkauT
         H1IA==
X-Forwarded-Encrypted: i=1; AJvYcCWOeAbk/vow7jcer0tUZXXrDkw114W1o+QMJJMxwf72zVrn2OxNIE+JYqLygY+fSAlldYqPsSPLsA==@kvack.org
X-Gm-Message-State: AOJu0YwpK9DZNhbYnmFRjIHe7RsGuuNr1IBNSQ7LxoQiLdf8BEzfR8N9
	joobbN1u3KMSwgvq4wa7+DUjHusE/yIXgy4261z19ylQyPIYp2eFuEOCUm1pnmZv17ahkU3f9IU
	uK8tfrw0p3z2K3J19a98FAC6LAEAuKZO6mOEFXxEi+uBj6NA+KE9T
X-Gm-Gg: ASbGncuxsbRNPt24yDotYnKsObrWjounIrURZg2Ej/9V+QmF7w75xzEXJ3UkTY0YK9S
	9GqBuBJ1trv0H0I+ndqjV6wkQCJbO+OYWfPd+BfnNhVsz/3jWExmfLA1XNN5s+Q3pn18Y4BRWi/
	RnCVlqvVeJZ0914+i1g0AiMpb6GvZVxobZ3RXTxbU4t7vE5pX3I3f+LjrRE4Vg8GqNIVmIBJ6zk
	xuz7m+0pP3bDnToK260ILCHwxl5F5KyiBVOktuAcsMxblKgD7XYg9LuWe5QK/khsC6IqczNlCwq
	uA6i9nJ21K/moWhB8ziFqrmSJjGBc6x6fF2PC3UfOuGQ/QfBrMSDDcet9wkfwHrKNeHpxFun5mu
	uSJAbJrxWfEnmTxcrSHfiWNxctyW657d1eJv83Sgk/2kxVwHqpJRU1gfw2scUAPThlQ==
X-Received: by 2002:a05:600c:1395:b0:45f:27fb:8017 with SMTP id 5b1f17b1804b1-46e1d978957mr16716535e9.5.1758615260649;
        Tue, 23 Sep 2025 01:14:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZZfMFYPJ6RFT/ih4jtnBu0Q+zWpM8gZCvkxnvk/Mc89Vf/8acIYF+vfUh4O1kBEqqLojGJQ==
X-Received: by 2002:a05:600c:1395:b0:45f:27fb:8017 with SMTP id 5b1f17b1804b1-46e1d978957mr16716035e9.5.1758615260156;
        Tue, 23 Sep 2025 01:14:20 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464f5a281f1sm232993015e9.17.2025.09.23.01.14.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 01:14:19 -0700 (PDT)
Message-ID: <cbe123da-b433-4c91-8cb1-7b19826939b2@redhat.com>
Date: Tue, 23 Sep 2025 10:14:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/16] mm: memory: support clearing page ranges
To: Andrew Morton <akpm@linux-foundation.org>,
 Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
 mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org, acme@kernel.org,
 namhyung@kernel.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-14-ankur.a.arora@oracle.com>
 <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250917144418.25cb9117d64b32cb0c7908d9@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lL32FnHYgSKN1757BYYL-Mt7q04SRYtfRRE74CZLLuM_1758615261
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B79378000E
X-Rspamd-Server: rspam05
X-Stat-Signature: sf7fnn65adpmtyire5t3sp8yapzfxoij
X-Rspam-User: 
X-HE-Tag: 1758615265-246755
X-HE-Meta: U2FsdGVkX18oFpT2mFlQvfEfZ4SvNCWMk7qkK86OYFBZirSNE5aW5G7zdSUpQtqkQCbVh7FrqPsP0A3xDvG6Ajg75iCAtAdcqeRv1ZDOMV8opg9v+wjSqHSQ9q/GtM28GSlxlcYEdHIEogcZq5vZ9FghU/FCetavsRF4sQ6rb1seqY2EeR8aP2WVsCBZXWB1XbP61htG1TJ2wa8L2dqthAL58M7aEMuk4E0A/lyC1UQ6H8iIcyXZIWeCi/LVjsz61iaH6k1f+LM9CL53HEZVu2SemLFXMVGYfpSaXinU/X3CpV5IWGhamTDtw+4NaFM9fUedawSFtflPzSmFIxirNH8TsjR+b/dVQ1xcjc3Hk5O/Gwe4U0VB3D++0hCpu8GhnPQ70p9u87bhk9ILoeIxoQLJyH1XGxx1WDBLeC1/XkW+LA0Jq/y/FfHcLnB19bFcMgRbwZ4hDkHh/Uz5VSCG1zG3VAFd1HypInVUmcLwKYalVs9oOrTc8GDQ0/PfRazqTDTQg9kM6Y6Yp2i7AsiZnG1XYiPRAHW7tJnkGX3L9mQMsDPUin5v5mngb2Q7+POpEcABE8pu9Z8JOA4ekEkNDr5AbSBx79vRPKh1eLPEq1xiMePO5kCCCLyrP6pJWDk6TFv/Ii6bpVeSrO96iVKN+7bwcut9dzVNZjyPRqHTgdxiRS3dz6WRDDo0TPYOugyZHUy/YJg07aq15H1YjS3oJ1kMTuxsvNZ9Yaj/7Nk9plQs1kX/YXRhWYY3kMCei/Dehs2ijQcQ0p+KtLO6hc3MULwYVALxs8FYIf0i0yyhKQE5l8JJ34ZyCTVnJuJv7/6pudaxjbACTcMawuElfIBm/NisvoIQ9GU9ZQnSlq4Q5iqqZDAL7Of99Vrtdl400IGnJ5wX5QxU+FbOY1GJrnolkiyE+eEU1Cmi/YySDyUpCRCiD6bwxh0gnNyEcJWGEwSXhy+P5LOkaX/Glon1Ezh
 g22iB352
 kiftUAa5JpPd++fVpboSltD0Ra60v4v3tPMnI+vJTmJf3ezUdrj/Q1R4FxjEP5ISBXnv6yDh/cWnUhnhf0KtT4fDJVU7g/JIg0Ad3Jagc7anloGc9RcjzDxWExIaY/ykJOy86JcUzQF+gkX+TQ+XCr6qmltt2qmseyiV0rbOb+4IjqjRj7YEw7XrHKadikOq9pARw7BcnaagyxJ1Xx94ghkFaFw7O3z7NmUjkk461Z5Peuv67lxgo86txlJoJsBAr4J8h8ZYQQu+A0J0T8br43RFl1wSOIs4sLyJiWuJqu5tom42cUklspMt8nnYUX/mITJQrzh68Rqt4qqT46wqf56YVDJmtO1PSmPSyV6WXHbcndfzFVGivYBC2Coac/bJ/1tuAZq8sHGqLoOyhHSbzMRCKBgYVETfRJhoCatTSH+nXtwXJG8DudcTZgL2ENg1siY+JpyDLPWfi0TM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.25 23:44, Andrew Morton wrote:
> On Wed, 17 Sep 2025 08:24:15 -0700 Ankur Arora <ankur.a.arora@oracle.com> wrote:
> 
>> Change folio_zero_user() to clear contiguous page ranges instead of
>> clearing using the current page-at-a-time approach. Exposing the largest
>> feasible length can be useful in enabling processors to optimize based
>> on extent.
> 
> This patch is something which MM developers might care to take a closer
> look at.

I took a look at various revisions of this series, I'm only lagging 
behind on reviewing the latest series :)

> 
>> However, clearing in large chunks can have two problems:
>>
>>   - cache locality when clearing small folios (< MAX_ORDER_NR_PAGES)
>>     (larger folios don't have any expectation of cache locality).
>>
>>   - preemption latency when clearing large folios.
>>
>> Handle the first by splitting the clearing in three parts: the
>> faulting page and its immediate locality, its left and right
>> regions; with the local neighbourhood cleared last.
> 
> Has this optimization been shown to be beneficial?
> 
> If so, are you able to share some measurements?
> 
> If not, maybe it should be removed?
> 
>> ...
>>
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -7021,40 +7021,80 @@ static inline int process_huge_page(
>>   	return 0;
>>   }
>>   
>> -static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
>> -				unsigned int nr_pages)
>> +/*
>> + * Clear contiguous pages chunking them up when running under
>> + * non-preemptible models.
>> + */
>> +static void clear_contig_highpages(struct page *page, unsigned long addr,
>> +				   unsigned int npages)
> 
> Called "_highpages" because it wraps clear_user_highpages().  It really
> should be called clear_contig_user_highpages() ;)  (Not serious)

You have a point there, though :)

Fortunately this is only an internal helper.

-- 
Cheers

David / dhildenb


