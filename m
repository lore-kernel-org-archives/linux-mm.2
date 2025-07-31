Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C91BC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D20CE6B009C; Thu, 31 Jul 2025 08:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7F48E0001; Thu, 31 Jul 2025 08:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFB26B00A4; Thu, 31 Jul 2025 08:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD53F6B009C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:56:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59D7B1142BF
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:56:33 +0000 (UTC)
X-FDA: 83724558666.05.04D85B2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF531C0019
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:56:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMOPoOOv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753966591; a=rsa-sha256;
	cv=none;
	b=ar66MBPxpxsobPcnvAE6IIx7B49NJjKQ4P27SccgTBgkj2Ww1qknTnaDSzLEw57Ucg6Gnc
	W6TJDypH99p88EP8/G5pIkrkUPyV9GVUK6wmLROjB6mGw7JI2YJVklAONZ9NjufqVzvK7M
	gVDr8UkhliVCD1GgMZhvZH+V4ccfHcY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aMOPoOOv;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753966591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UcOt3lDwl5HSBcRvfgdcxrISNXFWOJA2vLtr2p4qtLk=;
	b=AuS/ClmuTV0PMhHzxPvs3Y93jV4dgWpjY5qJk6XYpREUhTUzuqQ+xCfhuYiNfCyCjRWNIk
	KJ9/0JHbZogmxJuAEzDEsVhNzduCaMN7Vak/xnwhHCPIKPT67zuNVEn2Y1idTxFUqaRyOo
	wQwP+ODq1KWvu6LsRJSfo72tTDUfFjg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753966590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UcOt3lDwl5HSBcRvfgdcxrISNXFWOJA2vLtr2p4qtLk=;
	b=aMOPoOOvJ8OslHZw1KKiWKQCWJXBzRWBrgPV2NpxMEzbQs3ACGosCKvtlILXHssL2Qyk16
	UTC8dCdWP12NhaZeZXaaR0Ya8qtntgyz+VptZfzuHXrnJ9OBq53RtpvoteWvzEJ4qYPL8Q
	OD/S06SWV8/SCKsqZMXp7C2BFMgMGww=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-7FSfZ_m7OU6BIJfhmmkw1g-1; Thu, 31 Jul 2025 08:56:28 -0400
X-MC-Unique: 7FSfZ_m7OU6BIJfhmmkw1g-1
X-Mimecast-MFC-AGG-ID: 7FSfZ_m7OU6BIJfhmmkw1g_1753966588
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b7886bfc16so207356f8f.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753966588; x=1754571388;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UcOt3lDwl5HSBcRvfgdcxrISNXFWOJA2vLtr2p4qtLk=;
        b=TwRSuG3Zd1PJaj9YFe4T5B3bszSF9G58BRhePStKmK0KqqQs+ZYLdcEor5k7kX4C1X
         RUBYLeYRPcC6IMQLLKtiWlqEOn6UgzQR1UrACJ8UAuvWO4mQX5JIA4hy8yHTNDShKahQ
         z0yHh8YV8S96EINUBjHwk7UqREhKkdBb6xSyasdRSo5C6ggAQuVp2e7FBGBVsxzcFshw
         vqgJB56s2l7oibnVsvHl75d6Sphy1F4dvueaLt0V4S7Ck61bjBDP8OP/qeDGar75iVKM
         3bMweAtxoPQtW2/pNXqgJjqayH7tCkrFDTu8TLG/7lnTOUpgyU09TXK8TXqR96KVMrv/
         ALHA==
X-Forwarded-Encrypted: i=1; AJvYcCVCsNhAu34Ym6n4k5MtPU4j71TV01cc0u98/civEI/pHRzvStCbNvrbjJknc44n7cjb6K9EKajv0g==@kvack.org
X-Gm-Message-State: AOJu0Yyug6+xoqhGJ0Y8vA1EHMZYfFIRd/GgW8Qf/fKcuFU21dw0hSIW
	xN9iDLp6KR7jZR7hsqKXnUzxvAx0j5yDHzh9j0VMvJTtdZHpVwGfazT/JqHD1gJwiomHSBTwGXq
	Mbt0zPmMhz5UFnl98EnA/F5md6MLkZX5Wo/msalqD9lTVjoultSo/
X-Gm-Gg: ASbGncvgdygqbH6ZMSbQfegkQ42IJ5SvRlj6Uaj0tNf9PJlkGeSL8F1Xo3ZJigc8PZ0
	Y8I0+5pLhirWVgG/tq8LPJrxN8UjeEA155gyR/oI5AYbhJGzpQS7t+IohDmAvW5Oc36lOxJBcbp
	YxV19yFxMrfQNPvqnk7NjIYquZ9haG3J6r3F56HX1QUMnZ86rwnkPCLiHwL66Nc8Ce3UVqLRMrT
	yYl7kDp4j6HB1hR4TUqIopqoPeCECWpSNoqp4TrjzbXa5dytaTmAQp8JQqyG1xJpCsq9HhV9vDW
	fuSpVfFygqvxCmLCpt7yXlnBRNcUQoW8NZXRhd8ZVKI+uK+9CvfA5X/2tkWg3ZnFY0VpdUWfbZ9
	xopUDxc3weMo9GhlJ2TorcdfDywFk5IeSsIySI8+UqnjUNJUFtJNv7jOZyb1KDMbEdRU=
X-Received: by 2002:a05:6000:2911:b0:3b7:9917:8b57 with SMTP id ffacd0b85a97d-3b799178f06mr4399058f8f.56.1753966587594;
        Thu, 31 Jul 2025 05:56:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGEUGKyzKSROBWxRnVn35DU5KVo0FuypEf8UC38ej6rUCj170PDhpYsaBjudCBG7WOmh6rwMQ==
X-Received: by 2002:a05:6000:2911:b0:3b7:9917:8b57 with SMTP id ffacd0b85a97d-3b799178f06mr4399028f8f.56.1753966587144;
        Thu, 31 Jul 2025 05:56:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3700:be07:9a67:67f7:24e6? (p200300d82f443700be079a6767f724e6.dip0.t-ipconnect.de. [2003:d8:2f44:3700:be07:9a67:67f7:24e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4a2f03sm2278296f8f.72.2025.07.31.05.56.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Jul 2025 05:56:26 -0700 (PDT)
Message-ID: <214e78a0-7774-4b1e-8d85-9a66d2384744@redhat.com>
Date: Thu, 31 Jul 2025 14:56:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix missing PTE unmap for non-migration
 entries
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
 aarcange@redhat.com, surenb@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20250630031958.1225651-1-sashal@kernel.org>
 <20250630175746.e52af129fd2d88deecc25169@linux-foundation.org>
 <a4d8b292-154a-4d14-90e4-6c822acf1cfb@redhat.com> <aG06QBVeBJgluSqP@lappy>
 <a8f863b1-ea06-4396-b4da-4dca41e3d9a5@redhat.com> <aItjffoR7molh3QF@lappy>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aItjffoR7molh3QF@lappy>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: t8f-zwVgurq9HaIJ-jA6uy3sTEi40Nj6G2_-xUoXOQo_1753966588
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF531C0019
X-Stat-Signature: 7x31e5wq8qyrxetpc1s6wxi66uw1kj8t
X-HE-Tag: 1753966590-688471
X-HE-Meta: U2FsdGVkX1+vWaiq9hqqm2zGxWUx3HIZgQR7Sw9Ezgev3PdL3oL+NmIZiqqcUp8NVbzPEyYUEEzqmpm1Edo9TbOR8ynx1Hu4Jcc4ouzlLOFOQhBWrnS7pTjQbv976oEiyGVAYyjHe0IXr2Cse/47e1Zh7VivJC+SXJIlf/a+MigiIagIQfiv4VsP2UrDYo7eA2jx/0UEPOC41Xa4DEhpZzuKALqAApr6fZixaaWNYDI8mBjLF4sp10/kd0OoFr01xoyxtJY1T3DGw4wVkYmrKl01J9ge9SiJ+TICGU9y+GMPAFXUfsiMOiYWcJb5dDPVFW4xR9snaznU+LlWjyDssD2HzYqwz1zjP0sSjXMAOCOBvw4ZP+e2wRV99odw/bK+cbm4M9SFbjjULIiywLB5MOmtaZ8IT/1A4D6OWYTgDyEIZlhQsLYiw4txB+++FkpeZ8rRrzKIPw+LHX4G5W4EwpPq7emQsVY3fHg9FXM5ptRIZIcNc71jItppNFogWjIA9lNUhZfO5FavhRYN98QsRobx+jLBrOf9AZIigjeg1quueu7fDedq4CRIvzSPK/MkFGe9CsDm4fEHhOSa1Xcpb1TmO977sSajlBDL+DK9FAq8A3aRk67KCdHb8RAucveihORxIi6JaDUxiYiqaefLcH2KlfAfC+i0ozMJ5L/vTv/+y0jTo7FWqAYpLE45d7GB3ZVN2YtsFHV2Q1pZWHqb2bPw3YPNE5pHDerDkgLi/s9g6Tqwkr8CExXkk1RSlqw8tAe1+mEK0s1q2+yZgQ4G1bBozhd9kuxgX4LkAphqRazKz3vXxzS6zDv2z+EJgXdr1FIJseOcDBDMx2r/7BRyYdnotNvKKj4VAIq4fa4qNiY3DLuyB4S5Hg5zW3TkPMzXyp/ui0kxxAST9bo/FKPciPBh4ZNyFDOKPnXN6lnxPQ2zgrvLKC/tTW+mQQjNZAIH373SJ4pZdBl8pfu8FoL
 aPrrJavZ
 /TNilTYtqLJ3eDD/mSuQBxWCaBKpV/615K5NjuajwvR7eikZYtfWISsg6jpnq+wqi7tmfG6ACg+bcaXwSiDzX1ejbQQ3HoF1WpiMbVq5s522rc/TX0lOq4Uj7pZw4sXKJ3y1JseR55MdrSRFrbrZD6ZvYKwroxhXIYsAKFyOrLNnG7daQjR9UJMxELuB4qdCio3azpJdWwmgECLHJ388ark/6440Lkz5Z8FReAo71xbT4TM+YQXQy6uNKo/0x/pS2OabSUOOKYxwR9fIJlj3VO8iiCWJgaMnjRFbYKDqs/9EUHYlWLL4uBkV1e3SQ+ZtwZmL0SOckDzkkWJUkp/OACAWw5XhtRPpRaE1gilAgiTaQeDIcgIEm1yAigbcBA3KAC9ANzvuNd3mvJLKspcxD+ciKmRiwU2e6SKCzd3z0oI6Zg4dGY/NM1J14zaK0w3WOV/Iz27D5HjQOvB87SQdN72O0qOYOP3M9oDbo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.07.25 14:37, Sasha Levin wrote:
> On Tue, Jul 08, 2025 at 05:42:16PM +0200, David Hildenbrand wrote:
>> On 08.07.25 17:33, Sasha Levin wrote:
>>> On Tue, Jul 08, 2025 at 05:10:44PM +0200, David Hildenbrand wrote:
>>>> On 01.07.25 02:57, Andrew Morton wrote:
>>>>> On Sun, 29 Jun 2025 23:19:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>>>>>
>>>>>> When handling non-swap entries in move_pages_pte(), the error handling
>>>>>> for entries that are NOT migration entries fails to unmap the page table
>>>>>> entries before jumping to the error handling label.
>>>>>>
>>>>>> This results in a kmap/kunmap imbalance which on CONFIG_HIGHPTE systems
>>>>>> triggers a WARNING in kunmap_local_indexed() because the kmap stack is
>>>>>> corrupted.
>>>>>>
>>>>>> Example call trace on ARM32 (CONFIG_HIGHPTE enabled):
>>>>>>    WARNING: CPU: 1 PID: 633 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>>>>>    Call trace:
>>>>>>      kunmap_local_indexed from move_pages+0x964/0x19f4
>>>>>>      move_pages from userfaultfd_ioctl+0x129c/0x2144
>>>>>>      userfaultfd_ioctl from sys_ioctl+0x558/0xd24
>>>>>>
>>>>>> The issue was introduced with the UFFDIO_MOVE feature but became more
>>>>>> frequent with the addition of guard pages (commit 7c53dfbdb024 ("mm: add
>>>>>> PTE_MARKER_GUARD PTE marker")) which made the non-migration entry code
>>>>>> path more commonly executed during userfaultfd operations.
>>>>>>
>>>>>> Fix this by ensuring PTEs are properly unmapped in all non-swap entry
>>>>>> paths before jumping to the error handling label, not just for migration
>>>>>> entries.
>>>>>
>>>>> I don't get it.
>>>>>
>>>>>> --- a/mm/userfaultfd.c
>>>>>> +++ b/mm/userfaultfd.c
>>>>>> @@ -1384,14 +1384,15 @@ static int move_pages_pte(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd,
>>>>>>   		entry = pte_to_swp_entry(orig_src_pte);
>>>>>>   		if (non_swap_entry(entry)) {
>>>>>> +			pte_unmap(src_pte);
>>>>>> +			pte_unmap(dst_pte);
>>>>>> +			src_pte = dst_pte = NULL;
>>>>>>   			if (is_migration_entry(entry)) {
>>>>>> -				pte_unmap(src_pte);
>>>>>> -				pte_unmap(dst_pte);
>>>>>> -				src_pte = dst_pte = NULL;
>>>>>>   				migration_entry_wait(mm, src_pmd, src_addr);
>>>>>>   				err = -EAGAIN;
>>>>>> -			} else
>>>>>> +			} else {
>>>>>>   				err = -EFAULT;
>>>>>> +			}
>>>>>>   			goto out;
>>>>>
>>>>> where we have
>>>>>
>>>>> out:
>>>>> 	...
>>>>> 	if (dst_pte)
>>>>> 		pte_unmap(dst_pte);
>>>>> 	if (src_pte)
>>>>> 		pte_unmap(src_pte);
>>>>
>>>> AI slop?
>>>
>>> Nah, this one is sadly all me :(
>>
>> Haha, sorry :P
> 
> So as I was getting nowhere with this, I asked AI to help me :)
> 
> If you're not interested in reading LLM generated code, feel free to
> stop reading now...
> 
> After it went over the logs, and a few prompts to point it the right
> way, it ended up generating a patch (below) that made sense, and fixed
> the warning that LKFT was being able to trigger.
> 
> If anyone who's more familiar with the code than me (and the AI) agrees
> with the patch and ways to throw their Reviewed-by, I'll send out the
> patch.

Seems to check out for me. In particular, out pte_unmap() everywhere 
else in that function (and mremap.c:move_ptes) are ordered properly.

Even if it would not fix the issue, it would be a cleanup :)

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


