Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62739CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7CF8E001C; Wed,  8 Oct 2025 06:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFA28E0005; Wed,  8 Oct 2025 06:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5728E001C; Wed,  8 Oct 2025 06:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6D08E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:17:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05FB045C37
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:17:38 +0000 (UTC)
X-FDA: 83974545396.13.7E9D4A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id A9AA1C000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:17:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T7QAB+gr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759918655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRDvi6r03uPeYR37zgwdK7WAMAQMJE9pk5vVw7oFEH0=;
	b=xRqKke5rIite1l8HttIXCvKns0MeluWIQ1s5SXnlJT8LhPeb3weeNeFrHWd/uATR001Pf6
	nUgk5VayGr5SKkt9SOJEw/4UHoeltc917uO1D3yKqK3aT7N1H5l68IkACZnoSFB/L/5Hds
	NnApGopIxbJ3bsSsyQe6OgP3qwHjHEA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759918655; a=rsa-sha256;
	cv=none;
	b=snDfFgCgxqv6+jUP5880kKl/TYSb/eHfpTJgpReEGkv5aQgHJGplnLRBan4Zf4CeIkbf9l
	NFjXcxkUFMw1MLMoykdpX8ijTd7O9j+Ltw9UoWLbf+z7Vp5w6mBYiJJGJnHFP26+GVAb1u
	s8/2yZ3sNdytfOUdWHCkSGMK8rRvv10=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T7QAB+gr;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759918655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lRDvi6r03uPeYR37zgwdK7WAMAQMJE9pk5vVw7oFEH0=;
	b=T7QAB+grxwMrcLCDzdM54gifq9k2FjLG5gku7QWrf3Q29OYqFtNr6aE4SlixYrV/t5EmRv
	lLmCn0eM9YhUXLSp3QkDBQ+CtRMK1cVhfqWwryfzYrUP6qnr5fJwiSJICWrywZA8ho3NMG
	mV5JeybS9GudTIJEs9zIX4iBm8U2lT0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-209-7nu5SFVONbiOWbZYrhy73w-1; Wed, 08 Oct 2025 06:17:33 -0400
X-MC-Unique: 7nu5SFVONbiOWbZYrhy73w-1
X-Mimecast-MFC-AGG-ID: 7nu5SFVONbiOWbZYrhy73w_1759918653
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-42557bdbe50so362701f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 03:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759918652; x=1760523452;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lRDvi6r03uPeYR37zgwdK7WAMAQMJE9pk5vVw7oFEH0=;
        b=YjKw2SNFFg9TTCF+h7q28Ra452eiaijzyHsr7ERpBX54sFXovqblga6rbpWdfkOhAU
         Vi+bBLNcHdVaCGRowZBikXFyFQ/3wD31ifm6N4cgWOetvuuKDl7g8UY4Wu5FDg8k8xZR
         MomR4bAR42HMRbl9n+Q9pa7emkeJdVTiR3msqK5B/wvJcYa0RGbF/cpkDzQtFpk96/Ev
         J5I+drM+qW9e2OwgH9t1niQwoDDM0jOgrFAQgR0VvINd1HPEN8J47yVoMHoKYcdCWoG+
         WFL/eHtREqFDEdin8+eazBSI6a3e4DH9LtDi4VjHmnkZOpHX00bV9WTX26RCOFPajxZP
         K1XQ==
X-Gm-Message-State: AOJu0Yy/YMx47vRn4g0sqeKyareSLIwItdkdsdmmIoqEFJGcyj/DlUha
	U4jBqKSdzfMcYOrsKiY/CYHqcjBKYxll9TPAhVcnX6GvDMw6y3076Y+K49s2LgSyomLMw9KN3vG
	+/d7or2z6kH6dtrdkGWa4YZAcsO3mLEf1I4UYhdwRFseRkJpoQr9q
X-Gm-Gg: ASbGncuEGbOCf8DId0uo12WfS08KO5Kfsc5B+a/7n9dvTaRcVcHVSNStMe5xhTnn8yG
	h6av7/kbGYvKJJS+GTnRcad7g8bEw4NGVtbvv5M8lXBQxPoNj8/aZQ8sZOTqB/ERbTIJox0TuJe
	N4vEb63ZqKYxAa/kViyNnbXFBiTN2DiUINO2ZA5RREo7MFKUlxjyrBTKRjKowSvK/0LjHFBJPoO
	2ipHzFvF4OEx4HxXm8AJNyaga/Rq/osX/a1XckGNASQr3S9xJ51WBRSMUGQbvTSD385+Q2wUilc
	JY9tNBHtaQaT9ghX4XK97ub5KP7nFYPJw/0jLAcRkrCQzbxslgJPfoUx4JatStbT5n7Kzu+negv
	RnLudLkhn
X-Received: by 2002:a5d:5f96:0:b0:3ec:42f9:952b with SMTP id ffacd0b85a97d-42666a9e191mr1946963f8f.4.1759918652684;
        Wed, 08 Oct 2025 03:17:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOfjNjaQsJeBkA4XuZWZLsL4rqOZFlXg1C3d/K+oQ+OmoGGfCjv34iLAg3rUh+O4tgAsz4VQ==
X-Received: by 2002:a5d:5f96:0:b0:3ec:42f9:952b with SMTP id ffacd0b85a97d-42666a9e191mr1946942f8f.4.1759918652335;
        Wed, 08 Oct 2025 03:17:32 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e980dsm31801095f8f.36.2025.10.08.03.17.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 03:17:31 -0700 (PDT)
Message-ID: <3ec7d5c9-27c4-4395-b859-8931eed72272@redhat.com>
Date: Wed, 8 Oct 2025 12:17:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/compaction: fix the range to
 pageblock_pfn_to_page()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, iamjoonsoo.kim@lge.com
Cc: linux-mm@kvack.org
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251002033140.24462-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DJ8hb7OvT1jyj6XgDr05ajgLJzNk_JCTePKX8VjOZss_1759918653
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A9AA1C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: dxz5runbfk3ggyjxukti7wxqfyu1zr5m
X-HE-Tag: 1759918655-3268
X-HE-Meta: U2FsdGVkX18lVK5kHtD75xKEITFkoLIEaELfgfLIJl9iaoNB8tc2xV8+GnThkHNWdFHm6GyyG2SXYpX0yQmXE0XiSYjjlec0PpmJ4UQGXtmkHrtwIXNAeOUA69mIj06xBOycesvNBMkZswsRo1sY9S64Ss4EpeJck2bYeMxBE3bHUa6taXV4qaAqBohp4kGtxWvnvITcnbydX/Nz+m9NgasH09uFAAXoZujp7wRIZJaFMuGexfalWYIKraorEtqjC+O7RzvOvV4PKCOEiZNobmv6LWe4B+3QExA12Bq9JMeoXtxOC5RkF5cK06Gvnp46nXiCFbpc9YrArUYz92ZfweNMh3Zo+QOwGgzs0ueD9GnI5HvVE1aSliKl/oXE07plknmYiYi72GeZVqUHriAz8FjqiRrPSX2hs3HhopKOU2mnQpxXsqnXncIvCk1fizEXKhw1aJl7OSx65vbzvY0+CAD7/Rl6S7EjOey+XlCiBVoX5Kku2pbfR1kIK0NQk4YFaG0B6pXLwY0dALD0Sn3pQ6I52C3GPmsVXh4Vy8PHwqnQXoueTFG+Zdx6l2yIOOyIyI4qvnq9FDzMF/q5Kyk2il0fUIGo/4GAUnRzqSzL+bpg7PbnJeoTelHNrjaJeL0gGh0Ok82cR+4kCre+qoDIB2p8ws0AjeuAh0ObH99LWbqxHm0hMgyeC5nZ7WTmoKgNIUW6clAK/dFu/UO6vd8peN6QIhBgdVkBodd7gVIh1zEzLXLLG2PjeCSHZy5Z56P3YR3ZnSC5ALUn/s4Gg7EQsga+Gi9kJkpM7EgQdqDrVHdmIlfZMcoq3EnyZZamWtCHiT7bbrb78/Uzad7Y7XXMoAx+vLGpsiPEYAWJAbFG+scw54MkI3iKP5MddDrGXcgU2FpDz46K5Yrtkc7T4RMhnooN4R/gFyijzpUqX36Y0h57fXkARUcozAv6v8/Cjm7imx4y6jCql6jhZACzQeC
 TdzaB0V8
 1kEF0fU1meq4ZsUINNiXyN/AfR3X1ZoIxdy6hCzgFD6UbBJKQzn6CSAR/o0CSjxcSHEmjlwoT6ZZzUWEPNmdleyWGZLnWDdu8gSrrtIXOIx8PEU0b45IyBT4hfQR4mxSed4pRkTi63R1Tdm0DBfOOW6UZtW2lk+in9ec8R7+lPBN0mDdiWtNl4nYGZSKIvJ0fnUALA+o3U0evxYAfkWsnFRXnj7Bt6CN4KJ/IUoODW5agVZxvfMWLLooCmWGjy65w6ijczQLJoM/NhTYDh7rbsCFu120lHL+D4JRqWE/Uh2SBQOr8UqpC5C5hA2jBpFD9Df8qL5ifLAjl62dNAtp5Kz4dxZh3xFnG1lnLM6aQx839KgDZYn5u+W9uBH/Ayt09feYMcUm63RX1wSl/80iqvCHlGcN0oQnxQIVq4k9hi3yizKOC3PeQOj1XycbyBVa4q2Zo9QKepj0+u6HM/k3aALKtkJ7KRv25Vi/W2UxAVmiTuBi1TcSeCceS+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.10.25 05:31, Wei Yang wrote:
> Current code may skip some part of the range to
> pageblock_pfn_to_page() to check whether the range is in the same zone.
> 
> Function pageblock_pfn_to_page() is first introduced by commit 7d49d8868336
> ("mm, compaction: reduce zone checking frequency in the migration scanner"),
> in which it checks and isolates on the same range [pfn, block_end_pfn].
> 
> While after commit e1409c325fdc ("mm/compaction: pass only pageblock
> aligned range to pageblock_pfn_to_page"), we operate on two different
> ranges for check and isolation.
> 
>    * [block_start_pfn, block_end_pfn] to check it is in the same zone
>    * [pfn, block_end_pfn] to do isolation
> 
> It miss some range to check when start_pfn and zone->zone_start_pfn is
> in the same pageblock but (start_pfn < zone->zone_start_pfn). The range
> before zone_start_pfn is missed.
> 
>           start_pfn     zone_start_pfn
>      +----+-------------+-------------------+
>      block_start_pfn                        block_end_pfn
> 
> This leads to the range check is passed, but it will isolate a range in
> two different zones.

Can that actually happen? I recall that a zone always spans full pageblocks.

-- 
Cheers

David / dhildenb


