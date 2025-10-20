Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EE5CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097378E000B; Mon, 20 Oct 2025 05:38:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06F248E0002; Mon, 20 Oct 2025 05:38:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77878E000B; Mon, 20 Oct 2025 05:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D42FE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:38:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C412BB387
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:38:57 +0000 (UTC)
X-FDA: 84017993514.14.BB2CCC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1B8D04000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:38:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z9nyNX6b;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760953135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/zzbJqO5pUK5KZflwrGvIYmNvdHHnAW0MFYHCw0WLY=;
	b=RpuFQbbZ4hqJ2zOt2209dXpoR1vqqnL9DTeOsj7P78r6LpeST7l2EXSqy/9pzhIQOktP9v
	K795+MVkYJOZJJWQRAhzg3LXse2mPycxN4V20xPDJ2Jna7ZACehFFjxCEiJByTCrMCuL/E
	qI7R1tHEbjAlmcQ+yZ4qUWknG+kidGU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z9nyNX6b;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760953135; a=rsa-sha256;
	cv=none;
	b=hXGZk3ejNeYMC3NU6Gosiiye1Ds1pzknb7QtTMXzkdcCkVrVt7VppSwr1riRN14g3Jhbwh
	o29FqR8FDFaNQf8YfRG4Mk+wpUHj+x5LWa5uWeDE/IK0OiNmTg1moPcrazQnren2UEI7Eg
	701o/Yuu0tG5qrjXP88R9kMwbhbRThA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760953134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=L/zzbJqO5pUK5KZflwrGvIYmNvdHHnAW0MFYHCw0WLY=;
	b=Z9nyNX6bxDnniel/07WDL1yPLdw6QkNncdseq94NWQ93PHWxECcIvaPSQkE3TUQ28fEsS2
	+81EEmcOFp0YBRBnF7H2VBCD3e3jELpciowX+nN7QAsvEpfHIRLImxZJJ0HJWPLkLrKgDQ
	xsy8eDdHVwLZliuXrlie2i+4yZO4ZCY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-678-B5ePztJXOmCM3eaAQmySOg-1; Mon, 20 Oct 2025 05:38:53 -0400
X-MC-Unique: B5ePztJXOmCM3eaAQmySOg-1
X-Mimecast-MFC-AGG-ID: B5ePztJXOmCM3eaAQmySOg_1760953132
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4283bf540ceso932707f8f.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:38:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760953132; x=1761557932;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L/zzbJqO5pUK5KZflwrGvIYmNvdHHnAW0MFYHCw0WLY=;
        b=D65BVZmvsCk8Ju/rkGurbTJOJznLwQNkIXo408ex7j/KeL/hbVi4DDmsnxkcaTKSmp
         QMLyB2m5giLDbKvpY/qeQSXAPPAjRVQzDYEnscffaJwME0pgMC58WsAEBJkbvHw2Rc8X
         Q12ZS4NU8n/1sd+UTgMSyEtA55BV7xug8WPwtpVO5p3tMwhgvMDzjz+2uStIMGZzApt+
         JAdKvESXJ8cL1qeObQvEYLqH3tXBjZ7qmQY4lNcB7AAwg9qwjeZWBs9XzAoR0B667+p7
         HfnhDmxQX7TAqllQAPK2TrAGchUNZcsIy5jfqO0hLQNDavKPLNBOWmgwkUiqBtxSlOm0
         Ql7g==
X-Forwarded-Encrypted: i=1; AJvYcCUVk3UlLR6LGCwNHar1tlnXFc0be1JMNVTsGznSof1fgX6ceHwilqu44FNVI6ToqeVuRjRjbP3ASA==@kvack.org
X-Gm-Message-State: AOJu0Yyw/+d75deBOt9NjtB0jHL/qwkQtBwUKkuvH30O0j/asH+JwWah
	AjdjDCVf5sYxt2wmNJiE6/1z0b0o3NhMRtb6MRZtWASULgjhu8fkLS0RYtYb2xvOE/Yo4ZMe9Ov
	2D5rHljBcoGEBlLs7YjPOqESzNkllFxtqqP/o3WcSN9kkT0vLO1BMBX5YCg/I
X-Gm-Gg: ASbGncvf0ObYlon8+uDhdEX6PDiF2U+J4uh4H4pq3e3EXE5/m1A3ShRM0Ejia8t8OzE
	cW2cI41SkpIbjzOTyfz9wwofdT/NdGbmNi29Aa67Kpe9aVfSAHQS3bsya7Tk6GiIzF8ZPvKIDBK
	sCfCUKBNbYB8NgG6Tb9G7+OlvIBycxrK6dAJ46/f824NXmcBeTIp3TB0Ikvp2r2iyGsYQiPyE4P
	bwMy3gupByiBAa1vVIFpDgHHX5cDVDy7GAlqF8w187Mkj6yur1L/9OcPksft6b5SYJ4IrnKkZ6M
	WaocZPaRb14LKsN9gVOk5iteq8nCAK6fzHeTpwd0wz+PT0qtNzhTYWmgn0kRW5l8VlWsjrm3LjP
	lC3yhG+cGrwdfy3NydZOGSJmga3MSfA46B8Glwfg2JRtg0aajXELPvZGnyIX0Cfa5X0AHwEWlG7
	6uL4aykEu8de9clAjLM8gBBILGfns=
X-Received: by 2002:a05:6000:400a:b0:405:ed47:b22b with SMTP id ffacd0b85a97d-42704d8352cmr8217692f8f.10.1760953131689;
        Mon, 20 Oct 2025 02:38:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGysOvieUw3a1wAnw/J5or3u9iwC5zOwlC6ClXMG3G5QmykHvYydECYzwnDf+qjuNIRIXID7w==
X-Received: by 2002:a05:6000:400a:b0:405:ed47:b22b with SMTP id ffacd0b85a97d-42704d8352cmr8217678f8f.10.1760953131280;
        Mon, 20 Oct 2025 02:38:51 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a9a9sm14833265f8f.29.2025.10.20.02.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:38:50 -0700 (PDT)
Message-ID: <21e3ae2b-c441-4403-aac7-d9b96e61c6cd@redhat.com>
Date: Mon, 20 Oct 2025 11:38:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] ksm: use range-walk function to jump over holes in
 scan_get_next_rmap_item
To: craftfever <craftfever@airmail.cc>,
 Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251016012236.4189-1-pedrodemargomes@gmail.com>
 <844af749-374e-49b3-91f0-a72e951981c8@redhat.com>
 <6e9ca60a-648c-45e9-9580-27f45a4f2a4d@airmail.cc>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <6e9ca60a-648c-45e9-9580-27f45a4f2a4d@airmail.cc>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 13ucZSHyKlX7MIr4Sv0Ztt2DMXgLXobRTdzQQUzgRSk_1760953132
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B8D04000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hqss3ar7x9eg375rs7s1qyf13tsdtr64
X-HE-Tag: 1760953134-10851
X-HE-Meta: U2FsdGVkX18hd8xM+Rjt+zDzO+NUeCkwWh3oV7FcXar3rLiFyHna2sMLnehJj7eD6/PwftPJlvzc7bIbyoyRSKgMtXNMsg2kq77Y3R1IYH8Cw3rNwUbO4djNpgRBfdo3igDhD3hF0C1dfUwjqM6qnz9XbCDm9T/j6yeh1CzPJYKW5Ugxn7jzQnWsU1NdKDiVPGUNXBTIJsd6zrDmcL4lXFibZ28zRJ0vRrkgAWuq5p/m0Tn8bUFLDn2b43mDtS3es4fCiMmJc2QH5ACq/Vb9lYqrj4Tmpw8SZFJvmiNzB7cCWWMGosvyVK2i9nJJuNYv02QRZIHA11AJ+ATsslZgej06k4dWdNMoU7O0O9fb5o4om/kSh+X7l3gW9DxDuVIM93J2Fdh+oOns20Fk03JNCioRTWQV0JbSoK3MmX+putCZyH7qrOYfINex1TNT/6nU+JgyBAWcapUZDt1vHIWRoCz1XX0PwXtRNTXjnyAD1hvIfz0qVxESHk6pVipXJUsuavba89HIO9xQFe0LPcuEVo4PximbAYDVh1ogPEIZWv3hZy7lB4uGA3YBBexdQb2exTtuBaBLZWHXxA1q9qaDj6CqDEzZHNcksQvOdm5zxY+RAApytOboyxSV/vuSlc56WRySo4TOlPMGcztZ5nxjiC7tCM/lz06TzPzzzdI88B6BP9flTbE8Enp7bhinLTHHvkzu1xE7CGY2bCSMhrPFDkn7vqi4wBrxMd4zVadgFcLj+barLWdYpHSzEFA2Rb/RY2DQxCWAiiVnl8BwaU1nQDQHL5uVjEpdCXgen2qjkeumGTGYljbguKuNt/4ZhI3TrCSjx1ouRCLKJQgTu2JvRCeF3tPhu2i3InQq8Q6aMX/k0eAlg9b6jO/Ny/vVyLjt0ZXTA+hEbI8t7/oy3l0oGCdjEclR4HIDYKkMAd7gvW1JEvEis8t9yR5/OKGzdDB0m5DIsAEgcVVuzE+xu7t
 a0mhJXsf
 4ieoLruFPyuh+2YcQjNT4H/W2Hxty+p9IhPAATFiWKP1Dxv7EujQOFG4N90b/L2XzVgDMLxWaT12hL3K9vYuf+5bdlvy+uoSKfHcxdrRivFOJL62S6ozSiWnPn1+c+2JWjY8ZNEbguj3JVJV/0fTjx5RY4RBh0O2Khwr23zu9WWObq8+WKYulQkO9311Acv4ZOVwni5MkrHNrVO04R+1pmrN9SeePoQ9c8p0y44RpKHlXWOCsoQjjRZ/skv4HbRBN2d6pvo3y0dx5Jx/Vxml3H17WabvrmxRkxSaRPw12DskSf3S3LD1G9+nudkTLGlNwIFocCqI6ABdFq5hQxeOdSX3h6P2E/8d0MmwkJSw1Gl1odc4Tj0ln9YuWbFBc6wWNeO+JgtlStiYIQPJrCH6rYi3DN1/hzlFe1jku1J+Uo+tnUFXNIhtz9kGhVNjAAb5aIaLPV20FaQEa8gM827qwA3VwvCEpky4uCiQ4o3DB9mOKm6DXInc4X5eXbNxXgbMETm+G8ebD4wkFC+pv05DIlFm1yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.10.25 09:30, craftfever wrote:
> 
> 
> David Hildenbrand wrote:
>> On 16.10.25 03:22, Pedro Demarchi Gomes wrote:
>>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>>> to locate mergeable pages. This becomes highly inefficient when scanning
>>> large virtual memory areas that contain mostly unmapped regions.
>>>
>>> This patch replaces the per-address lookup with a range walk using
>>> walk_page_range(). The range walker allows KSM to skip over entire
>>> unmapped holes in a VMA, avoiding unnecessary lookups.
>>> This problem was previously discussed in [1].
>>>
>>> [1] https://lore.kernel.org/linux-
>>> mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
>>>
>>> ---
>>
>> This patch does to much in a single patch which makes it
>> rather hard to review.
>>
>> As a first step, we should focus on leaving most of
>> scan_get_next_rmap_item() alone and only focus on replacing
>> folio_walk by walk_page_range_vma().
>>
>> Follow-up cleanups could try cleaning up scan_get_next_rmap_item()
>> -- and boy oh boy, does that function scream for quite some cleanups.
>>
>> This is something minimal based on your v3. I applied plenty of more
>> cleanups and I wish we could further shrink the pmd_entry function,
>> but I have to give up for today (well, it's already tomorrow :) ).
>>
>>
>> Briefly tested with ksm selftests and my machine did not burn down my
>> building.
>>
>>
>>   From d971b88056fe3fefe50e5d4fa5b359e8c8331b2c Mon Sep 17 00:00:00 2001
>> From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
>> Date: Wed, 15 Oct 2025 22:22:36 -0300
>> Subject: [PATCH] ksm: use range-walk function to jump over holes in
>>    scan_get_next_rmap_item
>>
>> Currently, scan_get_next_rmap_item() walks every page address in a VMA
>> to locate mergeable pages. This becomes highly inefficient when scanning
>> large virtual memory areas that contain mostly unmapped regions.
>>
>> This patch replaces the per-address lookup with a range walk using
>> walk_page_range_vma(). The range walker allows KSM to skip over entire
>> unmapped holes in a VMA, avoiding unnecessary lookups.
>> This problem was previously discussed in [1].
>>
>> [1] https://lore.kernel.org/linux-
>> mm/423de7a3-1c62-4e72-8e79-19a6413e420c@redhat.com/
>>
>> Reported-by: craftfever <craftfever@airmail.cc>
>> Closes: https://lkml.kernel.org/
>> r/020cf8de6e773bb78ba7614ef250129f11a63781@murena.io
>> Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>    mm/ksm.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++-------
>>    1 file changed, 103 insertions(+), 13 deletions(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 3aed0478fdcef..8bd2b78c4f869 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -2455,6 +2455,94 @@ static bool should_skip_rmap_item(struct folio
>> *folio,
>>        return true;
>>    }
>>
>> +struct ksm_next_page_arg {
>> +    struct folio *folio;
>> +    struct page *page;
>> +    unsigned long addr;
>> +};
>> +
>> +static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr,
>> unsigned long end,
>> +        struct mm_walk *walk)
>> +{
>> +    struct ksm_next_page_arg *private = walk->private;
>> +    struct vm_area_struct *vma = walk->vma;
>> +    pte_t *start_ptep = NULL, *ptep, pte;
>> +    struct mm_struct *mm = walk->mm;
>> +    struct folio *folio;
>> +    struct page *page;
>> +    spinlock_t *ptl;
>> +    pmd_t pmd;
>> +
>> +    if (ksm_test_exit(mm))
>> +        return 0;
>> +    cond_resched();
>> +
>> +    pmd = pmdp_get_lockless(pmdp);
>> +    if (!pmd_present(pmd))
>> +        return 0;
>> +
>> +    if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pmd_leaf(pmd)) {
>> +        ptl = pmd_lock(mm, pmdp);
>> +        pmd = pmdp_get(pmdp);
>> +
>> +        if (!pmd_present(pmd)) {
>> +            goto not_found_unlock;
>> +        } else if (pmd_leaf(pmd)) {
>> +            page = vm_normal_page_pmd(vma, addr, pmd);
>> +            if (!page)
>> +                goto not_found_unlock;
>> +            folio = page_folio(page);
>> +
>> +            if (folio_is_zone_device(folio) || !folio_test_anon(folio))
>> +                goto not_found_unlock;
>> +
>> +            page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
>> +            goto found_unlock;
>> +        }
>> +        spin_unlock(ptl);
>> +    }
>> +
>> +    start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
>> +    if (!start_ptep)
>> +        return 0;
>> +
>> +    for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
>> +        pte = ptep_get(ptep);
>> +
>> +        if (!pte_present(pte))
>> +            continue;
>> +
>> +        page = vm_normal_page(vma, addr, pte);
>> +        if (!page)
>> +            continue;
>> +        folio = page_folio(page);
>> +
>> +        if (folio_is_zone_device(folio) || !folio_test_anon(folio))
>> +            continue;
>> +        goto found_unlock;
>> +    }
>> +
>> +not_found_unlock:
>> +    spin_unlock(ptl);
>> +    if (start_ptep)
>> +        pte_unmap(start_ptep);
>> +    return 0;
>> +found_unlock:
>> +    folio_get(folio);
>> +    spin_unlock(ptl);
>> +    if (start_ptep)
>> +        pte_unmap(start_ptep);
>> +    private->page = page;
>> +    private->folio = folio;
>> +    private->addr = addr;
>> +    return 1;
>> +}
>> +
>> +static struct mm_walk_ops ksm_next_page_ops = {
>> +    .pmd_entry = ksm_next_page_pmd_entry,
>> +    .walk_lock = PGWALK_RDLOCK,
>> +};
>> +
>>    static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>>    {
>>        struct mm_struct *mm;
>> @@ -2542,21 +2630,23 @@ static struct ksm_rmap_item
>> *scan_get_next_rmap_item(struct page **page)
>>                ksm_scan.address = vma->vm_end;
>>
>>            while (ksm_scan.address < vma->vm_end) {
>> +            struct ksm_next_page_arg ksm_next_page_arg;
>>                struct page *tmp_page = NULL;
>> -            struct folio_walk fw;
>>                struct folio *folio;
>> -
>> -            if (ksm_test_exit(mm))
>> -                break;
>> -
>> -            folio = folio_walk_start(&fw, vma, ksm_scan.address, 0);
>> -            if (folio) {
>> -                if (!folio_is_zone_device(folio) &&
>> -                     folio_test_anon(folio)) {
>> -                    folio_get(folio);
>> -                    tmp_page = fw.page;
>> -                }
>> -                folio_walk_end(&fw, vma);
>> +            int found;
>> +
>> +            found = walk_page_range_vma(vma, ksm_scan.address,
>> +                            vma->vm_end,
>> +                            &ksm_next_page_ops,
>> +                            &ksm_next_page_arg);
>> +
>> +            if (found > 0) {
>> +                folio = ksm_next_page_arg.folio;
>> +                tmp_page = ksm_next_page_arg.page;
>> +                ksm_scan.address = ksm_next_page_arg.addr;
>> +            } else {
>> +                VM_WARN_ON_ONCE(found < 0);
>> +                ksm_scan.address = vma->vm_end - PAGE_SIZE;
>>                }
>>
>>                if (tmp_page) {
> 
> 
> %)
> Guys, I'm so sorry, I"m little confused, can you lease tell further by
> e-mail, when patch or couple of patches will be done, so it could
> properly tested, 'cause I'm little lost in this progress, is it ready or
> not, thank you)

In general, we consider code ready once it was reviewed and acked by a 
maintainer.

Andrew usually throws patches ahead of time into mm/mm-unstable while 
review is still going one. That does not mean yet that the patches will 
go upstream, it's merely do give them some initial exposure to build 
bots etc.

You can feel free to test the revised patch submitted by me inline, or 
wait for a v4.

-- 
Cheers

David / dhildenb


