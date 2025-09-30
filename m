Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9392FCCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 14:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08298E0014; Tue, 30 Sep 2025 10:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDFA78E0002; Tue, 30 Sep 2025 10:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE5C8E0014; Tue, 30 Sep 2025 10:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA17C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:43:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9AD7A13BAA0
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:43:24 +0000 (UTC)
X-FDA: 83946184728.09.F70840E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DF9340006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:43:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e9L7Dn/8";
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759243402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhG0plFOvYJCJChP0VEmksJ+SHyux/X3KSN2J9VRcsQ=;
	b=dlFWYzGoneIvD9U/REsYttXd/rqgAQRPOzxcHsMM0KsTmcdi5zz0BA8JgmJJZL0qGuzSAj
	AAtEUUtwuY/tutLihDXA/1smE77OL682iTEh6onfaKh+RM+jJCCCOprfWXsrR+jsSux7/r
	0SHRd8M223I0rwynhri1GRhL5EMNWbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759243402; a=rsa-sha256;
	cv=none;
	b=drLNnc0kUoEpYKiPt735lF0NRWcrj4A/YIWjQeEdq3gr/U/8bhSnFzQYHyxpjHVkldSM6g
	jGZfIWjGFhFFJ9VtG0qu19lAfX7odKBk8q4Nj/Ua+4zcVVn8WRr8PUXiJt3wvGy1bw68KC
	FWprtbm/tNizO8OmA+K/pBSsvBbhCdw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="e9L7Dn/8";
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759243401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZhG0plFOvYJCJChP0VEmksJ+SHyux/X3KSN2J9VRcsQ=;
	b=e9L7Dn/8WSKTz8DQeQcgNDu/hqQma8cuKm8IwdvEBLOlSpX+nrB6YmThnpq0BqdIGHORIs
	5FckBdFH6VR0RMScg9jlvBQ24aK+vfdPjDCSWoS677IybbzzflXYZK56dhUteKlehKx9Ta
	Kwie1ftisuD0JH6oydVk7lgxqKXus4U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-YyqqOiehNfKMnpKJsvu0SQ-1; Tue, 30 Sep 2025 10:43:18 -0400
X-MC-Unique: YyqqOiehNfKMnpKJsvu0SQ-1
X-Mimecast-MFC-AGG-ID: YyqqOiehNfKMnpKJsvu0SQ_1759243398
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46e473e577eso22772155e9.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:43:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759243398; x=1759848198;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZhG0plFOvYJCJChP0VEmksJ+SHyux/X3KSN2J9VRcsQ=;
        b=ZmFAGX3NG5C5oZJDFl6NfWkcs5RucBoyjgWeiz8jz8GMpPKxfRK8gLd3XsPKBuwLDC
         eBMxM5s/0iUvNr85v1kJE003CHEs1oWRV0FPcm3q6WZj7hrQM/rySsHbgH11jGDn1GNW
         KhqhZ77VaXNmKn/B5dQPfzC9fkhcWJEE+dXpr0vaudBdyErkyirBwL6cxKRlSR2tLPc+
         1Zgxb8p1j4mW5nX4YX2DBkf7WzkwaKvVucnvHzL45sg9ZW8uDF9PFh+Vlet+TP4sAZ7J
         GXLpo2hMq6KTUBjb9A33qr5OwrBie6HhRC4UNhBgjbJ3prsgRGd4mnJMMpK/8PUM5vSr
         MLkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaSvSo+Ih3H4oozfJ4vmOH1eE54YNbYaD7Rnmbpxwe3dzqlVAmXFqVohDe+Rl9NCmNeIctNElvfQ==@kvack.org
X-Gm-Message-State: AOJu0YxqpnUqsDcs+T1tnsSuY+RexxqnyES+CsSPqdU3IUuBIAm+Gr6p
	nOZOxzwU8ZJA6PW6tn4rt8CEOoQxipWGRoTcuOeIMeu5Sye+eljSGaoYMBqAXggGPXDjTRhUp/P
	r7KYumi0VXfFj5PQGqH5HK4kCvjSJBJBqYTdmQAO4C3R/qrHBxzlQ
X-Gm-Gg: ASbGncusUkbXVQ47Ogm9Dtdjb9DRFnQRXNF9AeIMtENvrsSnTrY3Bk76NvnBTgF6tuQ
	v7ESMzuBe9zNTX7WQyVyLoZDDRNX5JGcsF1j4KTkXnH7hbjeqtDnyBe68CWscWh2+dQ5vIlcJEX
	hGcPdOpxvQ+Cz5FZy+AgKPDx6gQTLnxqRIizKSgeZ1D1r7qN+DoHzbP0FktGSut0NpYKQl3PxMT
	nWx/KVXwoAD/gqY+dtshtLZlE9WmUmU1lSbyHT1XsU1dzC4LVwO/woUMMlT0YdVqJAf0u5PQMTA
	LfZ+FmQF+d3UyVt4cWv6cG5uLSUc9oB0lOH0yNcfLGR9QO2Wm8nu9Am3QvQAfAyy8KbWVXdBtbt
	gIN2EcrFu
X-Received: by 2002:a05:600c:8b47:b0:45b:6b57:5308 with SMTP id 5b1f17b1804b1-46e6126a7d4mr1116685e9.7.1759243397724;
        Tue, 30 Sep 2025 07:43:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHQrkhChXtCy1UEjLsLjcTjFLDKj5JnDV9pYQbs8AfHCQXVwLHy5iw80nMhJPRAT30HZIzpUg==
X-Received: by 2002:a05:600c:8b47:b0:45b:6b57:5308 with SMTP id 5b1f17b1804b1-46e6126a7d4mr1116495e9.7.1759243397315;
        Tue, 30 Sep 2025 07:43:17 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc6921f4esm22946784f8f.44.2025.09.30.07.43.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 07:43:16 -0700 (PDT)
Message-ID: <25653f37-6ba3-442f-9348-d879a8ad4704@redhat.com>
Date: Tue, 30 Sep 2025 16:43:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, Dev Jain
 <dev.jain@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20250930025246.1143340-1-anshuman.khandual@arm.com>
 <9736fd6a-8987-4b10-9b05-e03106463c34@arm.com>
 <f0f0479a-fdab-4f42-9600-5d7b44a73f4e@redhat.com>
 <1f3c8fe8-cff0-4e3e-bea8-285b00fc7a5d@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1f3c8fe8-cff0-4e3e-bea8-285b00fc7a5d@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EyFCxeyVeQaV2H5Vtx5SEok_N8bxUw-H-WjZhHdPD5E_1759243398
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9py16f5ph7dm6anoxy1r9qhwphizs79y
X-Rspamd-Queue-Id: 3DF9340006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759243402-166409
X-HE-Meta: U2FsdGVkX1/Ww2kgEThRvkKXwgn3+/p4c9LZ3EDSO/eeD++NpR/x+yCYh5HlVQ64hl3IkpiuEr01zLWkLnLJAgml3AJs27icbINiVtvXTnkke3V62nh1Ekrs39IRWBplTD2t4bqjiQ7pB1Ea19E88+APQMZVHrxwrIw68bzuX5yoaQ62KHTjJ4PDL6DujkhEO3pMn30c6CGTh8RJRilcjtaRf0WDTsvpq2NDkamzct8F68U9UqX7e9+i/QKU7PCwxGIurQSag8PE5+2zdRCb0NM9YIeYzb/8gUNXV1SbC6MCRAldiB21g/KmLeJHZgT9D5Xtv3hNt1ZZxlpmodxW5IgmYN9/czZnpKH273wBV8C6ojBsiqD5mAv+NhEICPM8VY2gzRVwMW2YcNbkV1JD26l51C9j0cG1G1fxkyQ4ioQmgVfHm7dJtt/E4vq0S348J7lZWUfQ5ztc7oRA3oPCrjugR+ZnrbDOGGUapZasfupGKsBhvW3qqPM4IeCf7kzR6RttSHwxOD2BPTvgAVbkLsCEEAZZpMCXuCwN4U5n7Vaa2QXG9GJG3Ymvfm/wuhZuIVxjnUENudgv/RooSyShsbgK/ue4tO3uwg2pxsSJt6dPlpK9s3qeLMe1ab94/AplGbRjhu76Qf7LRRJFdd/BUHblbyRWmJrZXyt3v21MdtgV9Mu3M45RDQVGf9D+YoU8jLk3q5j4j7ZoYlxeMdU7ThVWLW7o+2cgeDyYcKWiMfn/44XJD7l/819GFQrG1nTuuyea3+9yOlAfyYid8larSrc1NTJFPOlO+c7MAe+6cHDYMoqm2b1lYQa4MfKfEAa2/SNi+6p2IiF5rfufVenIVsUyO1CGS+I5jQr3VtOZWrbBvvYrcjoIlJzBPTclzZ33jZHwf7yd1S/zj8I0TIszDuXEQ72fNXyC86hP0GQDzgva8II94m1+TegEUfEo+XxOC5JAJBcyUWEzB1GsJMl
 ceI42kio
 PWolV9GhvfNCE6gQjl7c/+otOkAm0BcL5fwaSwKIEFkzHGGzXIMaJB6X/zzbE9i0h/HNcr6oMC1E7QOOULNoekC+6sv4RO3xWY/E4Xr3Czm9ighYvZsFGP1y3c1tFYoKDMVfdpVPgbvFnK3fP1XmwmjfnobOixLjVJRYdVS9W+/4Abs15zH3gP0u+DFfnKpUXkuhfjBgNk831IH4SH20xB9DqmFfpV0Ir4AeYYxK0IEmGS+pJosfFhixNMNzxt1ruy60f9oY50/xDeh7WZdBsgFTwFWXPE74tnDfjql1PDfQF7RRKEX4s0VE3GTPCQergVUawHAEYVnGdmBMoDNS7+0SMXa3MYpIDp+sToDNpav5QqGwQ6yFNJ8orFhGA/6f6hyDuI6TVV2MzGyNx1ZyWPTTpRyohdMpMdhmI2eomYJEKgY5kn9eSCuuGq9pH/FjQMaXlWBXCIgK3T7MU5gjUp97fonf6Mkvj9YTVe0Qv4fQQDx189qxctrMl9YH7ZJQarFh3MLmYBiqD90+3Hcc/MdpKowMaVbpfMkh9TCv3z2r3A7WpfufDbGw82MXetV7ZuAFyBagQJX/J4oSntf1RBbuDfKl9PbKd+6/7FcHGLxkoGfWOzBnoqdS4pmE0ik3bAvKT9ineYWQdq/BpYdEHSahD1VGIkBa/3mr7Y/fO6P3DRPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 09:00, Anshuman Khandual wrote:
> 
> 
> On 30/09/25 12:11 PM, David Hildenbrand wrote:
>> On 30.09.25 06:37, Dev Jain wrote:
>>>
>>> On 30/09/25 8:22 am, Anshuman Khandual wrote:
>>>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>>>> anyways default into READ_ONCE() in cases where platform does not override.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>>     mm/ptdump.c | 8 ++++----
>>>>     1 file changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/ptdump.c b/mm/ptdump.c
>>>> index b600c7f864b8..18861501b533 100644
>>>> --- a/mm/ptdump.c
>>>> +++ b/mm/ptdump.c
>>>> @@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
>>>>                     unsigned long next, struct mm_walk *walk)
>>>>     {
>>>>         struct ptdump_state *st = walk->private;
>>>> -    pgd_t val = READ_ONCE(*pgd);
>>>> +    pgd_t val = pgdp_get(pgd);
>>>>        #if CONFIG_PGTABLE_LEVELS > 4 && \
>>>>             (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>>> @@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
>>>>                     unsigned long next, struct mm_walk *walk)
>>>>     {
>>>>         struct ptdump_state *st = walk->private;
>>>> -    p4d_t val = READ_ONCE(*p4d);
>>>> +    p4d_t val = p4dp_get(p4d);
>>>>        #if CONFIG_PGTABLE_LEVELS > 3 && \
>>>>             (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>>> @@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
>>>>                     unsigned long next, struct mm_walk *walk)
>>>>     {
>>>>         struct ptdump_state *st = walk->private;
>>>> -    pud_t val = READ_ONCE(*pud);
>>>> +    pud_t val = pudp_get(pud);
>>>>        #if CONFIG_PGTABLE_LEVELS > 2 && \
>>>>             (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
>>>> @@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
>>>>                     unsigned long next, struct mm_walk *walk)
>>>>     {
>>>>         struct ptdump_state *st = walk->private;
>>>> -    pmd_t val = READ_ONCE(*pmd);
>>>> +    pmd_t val = pmdp_get(pmd);
>>>
>>> I believe this should go through pmdp_get_lockless(). I can see in pgtable.h that
>>> some magic is required on some arches to decode the pmd correctly in case walking
>>> without locks.
>>
>> pmdp_get_lockless() is a nasty thingy to handle selected 32bit architectures.
>>
>> But given that we're using ptep_get_lockless() in ptdump_pmd_entry() it probably wouldn't hurt to use pmdp_get_lockless() here.
>>
>> Staring at ARCH_HAS_PTDUMP, I don't think any 32bit arch would actually end up compiling ptdump.c.
>>
>> E.g., on x86 only X86_64 ends up selecting ARCH_HAS_PTDUMP.
>>
> 
> pxdp_get_lockless() not really required here, let's stick with pxdp_get() instead.

I'd suggest that we keep it consistent. That is, also removing the 
ptep_get_lockless() if not really required.

-- 
Cheers

David / dhildenb


