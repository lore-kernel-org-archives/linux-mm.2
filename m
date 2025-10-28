Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CE6BCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB8F80167; Tue, 28 Oct 2025 10:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA2DB8013F; Tue, 28 Oct 2025 10:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C928480167; Tue, 28 Oct 2025 10:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B948C8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:15:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7087AB9A18
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:15:37 +0000 (UTC)
X-FDA: 84047721114.08.F034E0E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 133D54000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:15:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tece6p+v;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/glKqaox2VJfoe06FG5ShrOzZnm/RxmixqK0X1DIb4=;
	b=bGlCIj/kPxMDuKJPlzvmMHX6amXrcNG5rMxRazn9myrPnZUZVvmZvzI8ik05qU9li9dRhd
	5W1Mwzs0AqolWCjcOWXlHfrdXN7rLogmoGRlWxoY8wZFPrzVw7oGsaIN+b3hwvxp4lJCkM
	439C8oPEm5k7iNxi8poYIei64xP2Iy0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tece6p+v;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660935; a=rsa-sha256;
	cv=none;
	b=jJ/PTmQuhFz6SF3OEfgKwGGfv28djUshOwmzV6xnWw0BTFkZkkRctWQwWAa1igmfI6OSqX
	aqq7qUE2BW8oB3kvSKnU9C9I5kbRHOLn9Dgmum6s5JC8VBBrXISGUik9DOMFtlaOJwx86p
	hJ4UiZ4nKNcyyT/m4uv7PbIlPE5xUEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761660934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j/glKqaox2VJfoe06FG5ShrOzZnm/RxmixqK0X1DIb4=;
	b=Tece6p+vvkfxTYGVk+o+hHMFZ3T/RYtnh1Vdj12B9UM1Z0R5X208RXSe952gFLsHpcxuf9
	mP3Vnmj2NHJ0Gd8ENXQw2G6YNXPbIjtkrgIk6bLcPzkgovjBZF3B4a51R7/lVDJ37U0NNC
	a0q7Ci1Y3ThXscPZmO2D1uXIvIyujJw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-280-KZZvW58COwy7bjA6OyTi-g-1; Tue, 28 Oct 2025 10:15:31 -0400
X-MC-Unique: KZZvW58COwy7bjA6OyTi-g-1
X-Mimecast-MFC-AGG-ID: KZZvW58COwy7bjA6OyTi-g_1761660931
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-47105bfcf15so34530595e9.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761660930; x=1762265730;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/glKqaox2VJfoe06FG5ShrOzZnm/RxmixqK0X1DIb4=;
        b=vbltnig2mIlrfRYf4Ikod0EDDssoO/oGwegSWbivLTpGr/+fGnyiQWd9H7lw8Bh4yn
         RauzHqbvdmH4mtYN64GOQ9d8qSs7cV53Mgq4ZtRHxrrMdCbIa5T25xtju7D17bus+Uqc
         I+vgj5fENjLqTt4xkr/TntAy/9SmqWJrkRUxDyR3j4+asEDkm8FxamDvLsq98Ly7BSR4
         8Kq9BqvO/gWhR/umANumfNKDOTlbUX6pECYw7Rs0e1tIJSb8tAkYHUhJ+vcFivXAOskM
         e/jtEm/aE+HyDZUiz/YVlm1QTyHVjdw8k6hGYW0tcLVWeHT5SJkoonRykjU9i3VIXg6m
         WHxA==
X-Forwarded-Encrypted: i=1; AJvYcCVeZPgS5F3JqyrWVWSMuIfMJIja24Js2qSE3Hgi92H3Hx/fV1RSt0IibR08/y5Dcequq/zg4hPh4w==@kvack.org
X-Gm-Message-State: AOJu0YwTwo7x82OdtstNll2lnWuNkwmx1lMuQeQW+r1YMtB7gTQtWchv
	vprabfBa0u+I5Jpx8daDF9nzqqnQRwGaCsPiGO1ciJkaZbki6WNZ9qh3zuhc8Yr0a9UXzEUnfrS
	2GWQUHDyUuwgj2rURkukD+QLCVpE0ZmudiSEqZ9Uh8BFARiqIYHrc
X-Gm-Gg: ASbGncu0tJRUNot51zhyjthelXanhjW34Ze/nqwPtlbGtmFHzp7n31I/T63rgoz5f59
	/T/ne3nHO1PgxwRG48Ngocjp8XbKRsqCST63gmnBlNFvoNTQfbnd8kkCvKaleAouuEE8rpsmqj9
	Z8KBjc0XluHZhxSLhfq4JoFGO3rfuWWDZVl3zJtCXGTVQyBdrm1Bdtgz80e5QERLtTYrj7oYtNU
	8zPJIMAMObgPgQZ3Xqv7Dzfu1HD9MRWcNni5wmvklnK1TD8gAwnfDTd+fvavfKHoFx7AKKn8HKV
	jfd+Grl/Sv2kqJqvKx/SWZvx3BD2fhGkbtyhLhzwPwXcp4bxC5sp2svdI+2xRTQO7iS6XmKkudG
	5kxeywM7oZXdZW1CCJc/BSeYcHBZ4a+U2
X-Received: by 2002:a05:600c:3510:b0:46f:b42e:e394 with SMTP id 5b1f17b1804b1-47717e7a904mr25568325e9.41.1761660930385;
        Tue, 28 Oct 2025 07:15:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6iHKdLinZwipLvbxyK8tSUWzITslXdYkBnM4jqasA/6Z+uup38j+j3RmLA0yP5Cd8Tmrz8w==
X-Received: by 2002:a05:600c:3510:b0:46f:b42e:e394 with SMTP id 5b1f17b1804b1-47717e7a904mr25567925e9.41.1761660929806;
        Tue, 28 Oct 2025 07:15:29 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd4a36easm199704855e9.10.2025.10.28.07.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 07:15:29 -0700 (PDT)
Message-ID: <e69acbc5-0824-4b07-8744-8d5145e2580b@redhat.com>
Date: Tue, 28 Oct 2025 15:15:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Nico Pache <npache@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org,
 peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
 will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
 <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcA4AcHrw18JfAoVygRgUZW3EzsN6RPZVrC=OJwSNu_9HA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H8qzGTZU3wxcfrkbGy84ToPYe2qZCgwT2cX9mT0tZ0E_1761660931
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 133D54000D
X-Stat-Signature: q71q4xxbgzctqa464g6mqqrm8td5aojf
X-Rspam-User: 
X-HE-Tag: 1761660934-109573
X-HE-Meta: U2FsdGVkX19Uyr4kroR94pmkOe/bstr4EZfLDVbRVuzGGFbGJxh5cTWP0qCYz45W7jz/lPXaIbaRuCZZ6E1PrmiIxigdx+8m6epHhYIxb7BAimNQ/XcM271ggxWDKbbJKUnAKVLN1ul7E+Y0PDycRMd8p61Tuub+E6mfbW6nGpH1SH7+b4KZSqNfd7ePZ6IoMNsGErnysMp5fE1XxKmHV4dUDkMNr3AoFX9HX7ipibCUE4/WIez9GqqOBEE15bMOSeAYLPpxo5029+Rog9EYVwlR3itfb4Bx4tUbVRflYbt84tbBQXwIHXFV/FUyTCySn7rTG8dZ04INGDfd5l5n/ic96CWTipi6ay2CNo0xsMVQMCfF8qhsRI6UybSdeauQNFaGtvX3u/eqUz68ijV+k/oPXymViKOcQd3AzDI733Fe8goxqT5Z4HdcmhDWHnZXLdbyqwSJci4rf2HhdNNUDvKMnwb/m1GH6logDP/DGgT5ABd6GFhRg/CuVZ965cvuvzxIJd4rcu4QfKlQh+mnM7o/qpNsCvPQ2NpvajEo1/QM7amtZSsmLzSF6jsg5GQz7T/vUiBHKio0dwRUP9iGIhf6wVQR7+eB8RiY0trBJYQ3lXSmlnmgB/BRc5naJEuneiO/y0lWzoPgphwtvAD1HMTsUAsp6zw2CSx9jcnL4iv073v9dLv9Af5XCp4x0ICF9O6GQB0n7QPhm+zJhz7GWUznoOHvw1QWdKm4xqGkw7f6eIAFIfBhRESx0Ya1WotaOSEyCp88Rp3pj14+rGiys6rFL1WdQGHT1rEB9xXVcO7Cf240KGM7dY2p2Yva7s/0DCmbjLVCYmhA6F/Dbw3/7lxAIQq9L277fl49dXyQE9xuabpWIhilq9XgMOm8jOEBJe67BxkoTCMwyzOQD0np8zS5uuK0I16grzzAZ2d0Eb8uz5XGqWqWCl5MGBIfMmqpQhDbHvK9N/4cHRzXP3q
 oTbkojXp
 mIKba4OA6B3bxaGciQrqeVZ/YNp/zDLqo+fYKSCEW7as/bBKLC4Ezz6d3iYt7gtU5rBwe07aRyuDBUy/eHFkmd8EgUSBu3v5P2JnQ0eqihlhFQiFTMnrPwbAwOQnTO7k6/8vjS/48GvT350fRodxYTYFhu3y+c9t9+BqY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 14:36, Nico Pache wrote:
> On Mon, Oct 27, 2025 at 11:54 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
>>> The current mechanism for determining mTHP collapse scales the
>>> khugepaged_max_ptes_none value based on the target order. This
>>> introduces an undesirable feedback loop, or "creep", when max_ptes_none
>>> is set to a value greater than HPAGE_PMD_NR / 2.
>>>
>>> With this configuration, a successful collapse to order N will populate
>>> enough pages to satisfy the collapse condition on order N+1 on the next
>>> scan. This leads to unnecessary work and memory churn.
>>>
>>> To fix this issue introduce a helper function that caps the max_ptes_none
>>> to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
>>> the max_ptes_none number by the (PMD_ORDER - target collapse order).
>>>
>>> The limits can be ignored by passing full_scan=true, this is useful for
>>> madvise_collapse (which ignores limits), or in the case of
>>> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
>>> collapse is available.
>>>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>   mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 34 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 4ccebf5dda97..286c3a7afdee 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
>>>                wake_up_interruptible(&khugepaged_wait);
>>>   }
>>>
>>> +/**
>>> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>>> + * @order: The folio order being collapsed to
>>> + * @full_scan: Whether this is a full scan (ignore limits)
>>> + *
>>> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
>>> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
>>> + *
>>> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
>>> + * khugepaged_max_ptes_none value.
>>> + *
>>> + * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
>>> + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
>>> + *
>>> + * Return: Maximum number of empty PTEs allowed for the collapse operation
>>> + */
>>> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
>>> +{
>>> +     unsigned int max_ptes_none;
>>> +
>>> +     /* ignore max_ptes_none limits */
>>> +     if (full_scan)
>>> +             return HPAGE_PMD_NR - 1;
>>> +
>>> +     if (order == HPAGE_PMD_ORDER)
>>> +             return khugepaged_max_ptes_none;
>>> +
>>> +     max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
>>
> 
> Hey Lorenzo,
> 
>> I mean not to beat a dead horse re: v11 commentary, but I thought we were going
>> to implement David's idea re: the new 'eagerness' tunable, and again we're now just
>> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> 
> I spoke to David and he said to continue forward with this series; the
> "eagerness" tunable will take some time, and may require further
> considerations/discussion.

Right, after talking to Johannes it got clearer that what we envisioned 
with "eagerness" would not be like swappiness, and we will really have 
to be careful here. I don't know yet when I will have time to look into 
that.

If we want to avoid the implicit capping, I think there are the 
following possible approaches

(1) Tolerate creep for now, maybe warning if the user configures it.
(2) Avoid creep by counting zero-filled pages towards none_or_zero.
(3) Have separate toggles for each THP size. Doesn't quite solve the
     problem, only shifts it.

Anything else?

IIUC, creep is less of a problem when we have the underused shrinker 
enabled: whatever we over-allocated can (unless longterm-pinned etc) get 
reclaimed again.

So maybe having underused-shrinker support for mTHP as well would be a 
solution to tackle (1) later?

-- 
Cheers

David / dhildenb


