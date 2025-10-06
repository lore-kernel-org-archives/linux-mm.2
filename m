Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E781CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA018E0015; Mon,  6 Oct 2025 10:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81CE8E0002; Mon,  6 Oct 2025 10:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A2B8E0015; Mon,  6 Oct 2025 10:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E9D18E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:19:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25D8114065C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:19:03 +0000 (UTC)
X-FDA: 83967896166.17.0F69374
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id B91F3180006
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:19:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqVuiyvO;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759760340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu5vHzQSpKvoNJE+2NhZfMelQ4GUHMcWAcPCQHUhiTg=;
	b=AczlDchdznYuVIdfu3QblI9XB/h5IEojLa0dBzSkpVRclaD7HYAxpyrIZAMstdt2y5AV0z
	rneuZJkJKvnnUvKJmcx1ksfljhPQWdFnnArPPVA6Yhv8NHLzJVpIrJWBy6clSnIkx3VONg
	ovBXewV86OitVEwhIVKKTLvGeFt6ivw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iqVuiyvO;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759760340; a=rsa-sha256;
	cv=none;
	b=2jA6RwJSEVGqpdouaqQ91prBN+/w8ab542rwnmHzNPyVkbLmd7EoWPaA7+7IZZLn7eZ58r
	kbowWVMTBePdczWnOq1FZti6NvQel1rctNLo9Sq3w09uwBSV3Ues1X4/tjf5thUDGEso8H
	NU79oRsRzLYvcvaBP8H1m4FVQnO72YQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759760339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mu5vHzQSpKvoNJE+2NhZfMelQ4GUHMcWAcPCQHUhiTg=;
	b=iqVuiyvO0D/KD4RVKCdGcqbc+4sbcSCDWOT48E0pgx8p78uG9DKokRN94g3kQsM8/1mHuy
	e9kE1xQM2VYSE1V0djG0oRaniSkeGpX6+S7hl7rwNTJL1cAKsupAxN2K6nLKhLevGwP0PO
	jXQh1doKE05LhpuFBFhytM8T/A6lfZI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-XFiLzmjwN4SeFYr-dNT0Sw-1; Mon, 06 Oct 2025 10:18:56 -0400
X-MC-Unique: XFiLzmjwN4SeFYr-dNT0Sw-1
X-Mimecast-MFC-AGG-ID: XFiLzmjwN4SeFYr-dNT0Sw_1759760335
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f6b44ab789so2576910f8f.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:18:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759760335; x=1760365135;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mu5vHzQSpKvoNJE+2NhZfMelQ4GUHMcWAcPCQHUhiTg=;
        b=KyukS94T13yCtKbAxs1NfYwmdvQ0WCNQnoyIFLlMkAo6aXVAmjb+5/7kb0MTYQbUkh
         AFaOP+jAkyciPbSc4xgTr0622yZ+ZldEeRsC4t9rQdcLe63zZFpewV+Vh4wq/M5zB/C3
         5hiTOHSnLZ7aMqlIV/DyaZde2Uk6xrTZZrsDnn6k0r/x+kBt5crCCXyRj8oBTDytL5cs
         oqo+2Uja+UmrIjD6oEbbyMY2DSZ+5qdG6Q2FBIMimxL1riPgKrjQiWeA46ZjO2JzeW8x
         qSSoVGVWIkNU4yURbb30aCVqNpYlTzOlfIeL/mxaPs3bmx9cWX1fUolWqbn8SveqZ38h
         5BEw==
X-Forwarded-Encrypted: i=1; AJvYcCW2mPKgOA18fNRnZlOvnjds4vIad9HJYhbQ6APcYO8sIowvzxmBGJewtJTgMbY18mGd2L4Fd17EHg==@kvack.org
X-Gm-Message-State: AOJu0Ywqs24gw6axVtgsdFQ9sL/Y2dGCrGrpr3i8EeIQR1LDooDe8bQs
	a+iB64MwtnTuSj9V2yxKUHC2oEW7LELchL7G/8fdSR6n1lltcu79Nb8bTuu2bbdAsuzKzq3Lo8E
	LlFjTFgNDutqo+JTXXm9gKz6ImtQK7yMkky80YqyOoo3QPpwE+OhT
X-Gm-Gg: ASbGncvybr6pvFAmJ/0E83dE7QZAArnl3JFppRuWx4BivEAm86x8V5+pERMa+kXpQJq
	1+EiXdW74VUtJArQyix7NgC6JKRZ2qaFeQcmipe1CiGzq0lheBSAnlGNfjTmR3Jw48lBUVZLPLy
	qizM/sGuDPjxT8ztmbmFY96ltROwLz0SlN9mobRnTmVQe3P3JzCM920x3DAykTbY2ppf3D6RYKr
	WFuuaKEMNHizuu0tJQ5Q1GUgSn6v642+q6Zd7DphA7P2DMQjLTtdKLnozZvnUekR2YXIPrrff4q
	cU35cp83o/ZpJgJUxGN1qcycMHIXOxU3LTf7KYLHFqRSRtZvbPmbeMCDxsr6MSt6L0wwGIyo00a
	zbrLJGB65
X-Received: by 2002:a5d:588f:0:b0:3ee:158c:8bc3 with SMTP id ffacd0b85a97d-4256719e6e4mr9281471f8f.36.1759760335272;
        Mon, 06 Oct 2025 07:18:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/fCfExas8mbEXCQflYkuuVr+7p6ZsXgqYs8eseHXvI+uIq0sprPLuJqkcRw5lRJBk93lPDA==
X-Received: by 2002:a5d:588f:0:b0:3ee:158c:8bc3 with SMTP id ffacd0b85a97d-4256719e6e4mr9281433f8f.36.1759760334739;
        Mon, 06 Oct 2025 07:18:54 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c54sm21431530f8f.11.2025.10.06.07.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 07:18:54 -0700 (PDT)
Message-ID: <09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com>
Date: Mon, 6 Oct 2025 16:18:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>, Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 dev.jain@arm.com, hughd@google.com, ioworker0@gmail.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mpenttil@redhat.com, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
 <20251001085425.5iq2mgfom6sqkbbx@master>
 <1d09acbf-ccc9-4f06-9392-669c98e34661@linux.dev>
 <20251005010511.ysek2nqojebqngf3@master>
 <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <31c3f774-edb7-420a-a6a8-3e21f2abd776@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9Kdx46hjPErmntqmjcJBmK-AvXqMu61Gg8FuSCWvNFQ_1759760335
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B91F3180006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9zoepcwmp8aew8cc5b34csfaw4wjsesz
X-HE-Tag: 1759760340-601446
X-HE-Meta: U2FsdGVkX19xw7eeQbe7fDNH0yNPphMYFTz5FwOU+mLafqRYEOq5VYblYxW256hBryshiCgrBBihu53tw6AORHGQqPX4aBA1s/XdLTO4hx6eLZdzJC1qFifj9aSVTHrhDbrpvvF14qaBZuwHsTCqxsJFks4Jjvv9/3HXSJz0Bi6xz7FGq8QYRdWbZtIKUwifaA7C29GVPTcXxlez3dD0p7VB8oqgIeFvPSEeI3qTFa+ALqSTy0Qpq8AfgAIp2exO+JcFJX+DJ6vmQLgQwtn5BF+RmrRhnLj0l/eZpCwWmiJ/8Flhye9tLt+dDDaHcvXblmwgfsJdu8a2ancTQhMy0DkLunjXd8j4YbmzfhjC/r18F7+kkjGAPQAW/muV+3uYMBNItK9mHjA52Blyz3UbyiOlIlqkD5MlCQRo+HS1ac3DrSgh2dkaQxEn2ddgtzQ3U3lB0ii+Q1tyr5C4Rx7x9rN38+cvBJ642ZVR019P758+ooD3cW+EGlGdV7UYiXwg9I6wCw/gNJh5EtfOPcaf15ZZwMOdEZlHrfIc9TINLlUUunfurVcs6yBmJ7tW3GND3dQO44kvTFHHbuGP3X2JFoPwHW97vSTXiIg8mgI1HXwBRh86n08pNdg+W9TeO0+eRdkJ9LrMqbzU9YK0qlB7/Q8Sgethj6HuX6vby5KB3v5teA90UAlAxqtEiQz3zsyOKjtSgcgxMu/ZBf7IdHEFoL4WW4mACkp/ceg97NffPVbVTW6CFWTIakmR/P4jOxKBpk52XXs2nvHeokzNPQifBn3E0I+oTU2UXz0lTGsA1TgGXlFaEMBBb62e+yJ7cGUfg88/bMHI0nXzofVsvaeiaZYMLeTHW/KQtj6rS7hTuaGSvRPdIJnXNLso9A7FGwz+OUbcq5MfrGyH1w2faY3goAWPpH6PjboVBiHvZjZmNmp3pWfoC/65yNwWN5y4Rad+IzRGOxa6/xo8WNCb9be
 5gzpuec+
 E/SLvm+E8uzFDJsuqiUH5lEkB3f3TRIpLsNCRvIJm7ywuGq+aeloYejFM240ubtga6kcx537M+X6oNDwLkLC6kx6HR6DP6SaJewRZHCRtAwTktHt4w3CDVWggg1NdnLSgc8HrlhyfrRi/nAXd9IlrATCNSr0jSzMobN1vDQrNudlj7iOxxdy9YMeUc4bQP2IXPRT4BwUDwXMkTXSkgn9chWt/KSUgyyO4x6xTpGpWm7mo23+Xc9hvK5kRdiAIYDchV/h/4lfdDSOW4U28bAWJEzsR/Oi7ZmB5HS17M86hTMMx/MuWMZQl2YYWS4GIjRwrZx2pUGbmuyG53jqact/N6d8GQV2tZacnD2Mzz1yYP6SUvtnKbOMMF61XEOz1peHEKqhOQojHVFkG7IChNIPn+Cn+fmbsdjwbCiiikjthD+Bq7Mr7bt5ueLg/vjjxFgHbbkSTPMEuGjS4WyFvT/W7l9EWD7mee2NDJW9pBFUVyIcrP2OF9qn2nXsFLTn7oRNdgshK/EVPh8eRvDYcSo4QDTOxJbnAf8S/MIaSDKEmor3mmZJc+zLEcUcZPbIeLQysUlxUGSR89EpfeQYp0jCYr2XIwwNXTnZnvq+LhkJiYr8IzXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.10.25 04:12, Lance Yang wrote:
> 
> 
> On 2025/10/5 09:05, Wei Yang wrote:
>> On Wed, Oct 01, 2025 at 06:05:57PM +0800, Lance Yang wrote:
>>>
>>>
>>> On 2025/10/1 16:54, Wei Yang wrote:
>>>> On Wed, Oct 01, 2025 at 11:22:51AM +0800, Lance Yang wrote:
>>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>>
>>>>> Currently, special non-swap entries (like migration, hwpoison, or PTE
>>>>> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
>>>>> failures deep in the swap-in logic.
>>>>>
>>>>> hpage_collapse_scan_pmd()
>>>>> `- collapse_huge_page()
>>>>>        `- __collapse_huge_page_swapin() -> fails!
>>>>>
>>>>> As David suggested[1], this patch skips any such non-swap entries
>>>>> early. If any one is found, the scan is aborted immediately with the
>>>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>>>> work.
>>>>>
>>>>> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
>>>>> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>>>>>
>>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>>> ---
>>>>> v1 -> v2:
>>>>> - Skip all non-present entries except swap entries (per David) thanks!
>>>>> - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>>>>>
>>>>> mm/khugepaged.c | 32 ++++++++++++++++++--------------
>>>>> 1 file changed, 18 insertions(+), 14 deletions(-)
>>>>>
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 7ab2d1a42df3..d0957648db19 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>>>>> 	     _pte++, addr += PAGE_SIZE) {
>>>>> 		pte_t pteval = ptep_get(_pte);
>>>>> -		if (is_swap_pte(pteval)) {
>>>>
>>>> It looks is_swap_pte() is mis-leading?
>>>
>>> Hmm.. not to me, IMO. is_swap_pte() just means:
>>>
>>> !pte_none(pte) && !pte_present(pte)
>>>
>>
>> Maybe it has some reason.
>>
>> I took another look into __collapse_huge_page_swapin(), which just check
>> is_swap_pte() before do_swap_page().

Thanks for pointing that out.

A function that is called __collapse_huge_page_swapin() and documented 
to "Bring missing pages in from swap" will handle other types as well.

Unbelievable horrible.

So let's think this through so we can document it in the changelog properly.

We could have currently ended up in do_swap_page() with

(1) Migration entries. We would have waited.

-> Maybe worth it to wait, maybe not. I suspect we don't stumble into
    that frequently such that we don't care. We could always unlock this
    separately later.


(2) Device-exclusive entries. We would have converted to non-exclusive.

-> See make_device_exclusive(), we cannot tolerate PMD entries and have
    to split them through FOLL_SPLIT_PMD. As popped up during a recent
    discussion, collapsing here is actually counter-productive, because
    the next conversion will PTE-map it again. (until recently, it would
    not have worked with large folios at all IIRC).

-> Ok to not collapse.

(3) Device-private entries. We would have migrated to RAM.

-> Device-private still does not support THPs, so collapsing right now 
just means that the next device access would split the folio again.

-> Ok to not collapse.

(4) HWPoison entries

-> Cannot collapse

(5) Markers

-> Cannot collapse


I suggest we add that in some form to the patch description, stating 
that we can unlock later what we really need, and not account it towards 
max_swap_ptes.

>>
>> We have filtered non-swap entries in hpage_collapse_scan_pmd(), but we drop
>> mmap lock before isolation. This looks we may have a chance to get non-swap
>> entry.
> 
> Thanks for pointing that out!
> 
> Yep, there is a theoretical window between dropping the mmap lock
> after the initial scan and re-acquiring it for isolation.
> 
>>
>> Do you think it is reasonable to add a non_swap_entry() check before
>> do_swap_page()?
> 
> However, that seems unlikely in practice. IMHO, the early check in
> hpage_collapse_scan_pmd() is sufficient for now, so I'd prefer to
> keep it as-is :)

I think we really should add that check, as per reasoning above.

I was looking into some possible races with uffd-wp being set before we 
enter do_swap_page(), but I think it might be okay (although very 
confusing).

-- 
Cheers

David / dhildenb


