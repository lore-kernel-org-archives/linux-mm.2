Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FACACA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BAB08E0009; Mon,  8 Sep 2025 10:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891ED8E0007; Mon,  8 Sep 2025 10:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 781538E0009; Mon,  8 Sep 2025 10:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C408E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:35:27 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13D42139656
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:35:27 +0000 (UTC)
X-FDA: 83866331094.11.BA41932
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id D58694000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:35:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IsQ6Yliv;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrYPeuNTiOD7YUu2tmRr54ytzGFvKCHl5sfVYrawVLU=;
	b=G5jr9CI036NgV6LxIz+rF93Jm4mhXLsuJrBSaxwc5yumVAVNkNZvX6lkNRDdFJdlPgi/zf
	oKTxzqxvWZOkabBnNDL7hiI3FVKKQ04fk47beODDyNcYtE848kj7+Euugxw/5p7274WtRn
	J4JL8zRouEOApHlXGDRKpVGLnz0NhTk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IsQ6Yliv;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757342125; a=rsa-sha256;
	cv=none;
	b=mFUr5jWtzmxUHP8I2FHW0iQPQ0uGrX2ml6QTfMYCmjt2UEIAqWu307R4PZABrNLZ5Ql9Nr
	RBwlW/yDipMoxl8SQgds/nfnbUqAE4r83lGbQnbOQfwBJJgfbqqetLOBZC7gmAlotQaZ8Y
	RSodMCb6HVNlmCJ09wKpCPV2+Qnmtgs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757342124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lrYPeuNTiOD7YUu2tmRr54ytzGFvKCHl5sfVYrawVLU=;
	b=IsQ6Yliv0be4Sl2NqZMrEBLF4dkBKkVG/vzX/Bd5oeftZT3jYYPxvm/aBBxbtg9FBcqRO3
	+KSLapVDUfS4DrkFgS+3kLnVIZnvgx/AYqyqPZ4mEdzgwIWC2Pt4aE47BmYrkNj6dlK2UE
	MmQ61LKZVU2SBeYTbi8/f16KLpaF5Aw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-339-REaCC7w5PmaxojDmsO5U0g-1; Mon, 08 Sep 2025 10:35:23 -0400
X-MC-Unique: REaCC7w5PmaxojDmsO5U0g-1
X-Mimecast-MFC-AGG-ID: REaCC7w5PmaxojDmsO5U0g_1757342120
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3da4c617a95so4141277f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:35:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757342120; x=1757946920;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lrYPeuNTiOD7YUu2tmRr54ytzGFvKCHl5sfVYrawVLU=;
        b=LxsjafiqG5ViElsI6nVOzA7WVjoIOXJsqZoO38G9UU8jNP+Xkk7NCC1QYt9FORNFpu
         dFo7evlslQb+Cdc9VZlTJaVwyqebqblmwUO8YgFBfgPJ3bbe60bGlkFNxVOwmd9oSUA+
         xDvSf3AZlPFz0iNElHpiw5VJ/8NtqgnvMOk9lyPxHfcQlMYi16oK1kH7VoODRYZZQtzt
         nx5iTmR/3XW3GQCtxnxPcYV4IdFh1xFYJuAAdMwwY3tZCQO6gxzm/F4rR2GCDByRSUVr
         aJ0iyXu/TDW5KAI0hpKBQjpC8BY5lF9Ns8+lEmvsKk90nDcnKJLuQgKQ83Ws64Ri3421
         X26Q==
X-Forwarded-Encrypted: i=1; AJvYcCXaNdfQnA5JYeA2WTnhfb9iH6D63gV2Hd/MGuG8N50SGksj31qU6Jd4cXqz3jKzIk0V4zqn4RBXFw==@kvack.org
X-Gm-Message-State: AOJu0Ywus8gVKBWpdnZxWETiPh2B95YKkkzUzIzZTaAJdR9a5EtYDeoM
	oNj2APKK3nOYQJh6s4m1bKBAKoPduS7cXk1HDlouQ+s5l3+YOpdZWNYwQV0+8a7Rhd/k9VXtTK7
	gcANg2yQfQZwHKY3zipXTq243DTpbLXwS8gEGO9u72tpIQbD1dilq
X-Gm-Gg: ASbGncvjol0u39PuD5WsGrOM7eywOvKilsArP8IVVYrrK1hgyPz+buTM9JZMhUXNXTC
	y7dTEBTgTu+RaQ3reJx3bXOr/k4t/Xju0OlRgEMt3jLm8kYRanUbp12JWwgRB6QJsJOdhqrncTM
	5V1rCKVHcmB78PlKch8eDA6oOyXPyE9znN6f+5eVe7DXA/r/IlmhhMeZ0eOevqJojPQitP2V1UG
	w4kTTfTNvU8R8m4Jm9jlkXbK8hh20YIwTVv6Q4NKVqK3OSgZvB0PPI+bfIt9gNcNI5Vucho/9h5
	ktZu6naeurRejqmYSKrFN8LKl18WxgC7bunyB+nUaC5RkUKpXk7lnyg4sNNtoAu8/Qw8NpSoYOC
	d7Hdt5uzsgE+EGXNcG8BkMk84KKZY3CGKN6CMr+nnbcLw0ZzpKyo9bvdK71CHdLKI
X-Received: by 2002:a05:6000:2489:b0:3e5:2082:8941 with SMTP id ffacd0b85a97d-3e642f9050amr6551071f8f.23.1757342119767;
        Mon, 08 Sep 2025 07:35:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZLff5juSqm9neyAsOLAPZdqcSj6VvngesFbghyJRBNktZZTQa0GV4i8Hiyffrg0PBXtPEMA==
X-Received: by 2002:a05:6000:2489:b0:3e5:2082:8941 with SMTP id ffacd0b85a97d-3e642f9050amr6551014f8f.23.1757342119247;
        Mon, 08 Sep 2025 07:35:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e18537589dsm16164452f8f.54.2025.09.08.07.35.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:35:18 -0700 (PDT)
Message-ID: <3f76748b-8f99-4e63-ba39-adadc2f58838@redhat.com>
Date: Mon, 8 Sep 2025 16:35:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] mm: folio_may_be_cached() unless folio_test_large()
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>,
 Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com>
 <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com>
 <7113d289-fb8e-4589-7eb5-1f7139965ade@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <7113d289-fb8e-4589-7eb5-1f7139965ade@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eQaUt2f7wOv2PPE0vt-G2ouhSmzGJ9kn7QoJRUqlP8s_1757342120
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D58694000C
X-Stat-Signature: ijm9fiq3gshew1zuciqgtjusyu1scam6
X-Rspam-User: 
X-HE-Tag: 1757342124-878878
X-HE-Meta: U2FsdGVkX1+PidJUwAhLMB11rBuQgbse8Blx1w7mJbXgjwcaS92JxfUq1c4DCgtv34khEtvJgQqmGzhS35EZExx1Mwk73Q5FwPlc6ConD0gii7ge5Pzq15TuG90p+xTtO3QeLKHO1oV6m5Q07ygRmXP8hl23/PV8eLoITF7UyoB/Kpzk1w9At00KKHXwCSG3La9/WsS5TOX4Oibbg3a3OJWs1aT0nEe8pN6e9tutKtW4bdh5Yt6G+JfpU75NaMVN1y4o/RWTLJ8yRnWAKl3bZKTdm716fWdqrmSATIR99eyFWIhV20m3eP7WKBx6Mh8Xrt37qVK8IIkrH2t7ay1HgthaTy8LU0TkgbUD9AEM//mAHzw9v16zMiMhzV6wF3b8RZ4zNzL9FcnDM9+VGa3Agj1GEMazOCOwjD4tiy9pwzgqxpywyz7RnwGyVCXlwuM0V121dSvYRj5Pmc1OM0yEsS0enyj6mkplj6Jw4KRlCnERwlAAmVKIpYUnIFrtpWaV0DUoBBUp7Uj02xhaX7aYKfGFm5SQUCNufWwQOV9X/10MVx2i06Xum92ESfH2dNJ3F5P6hBOHwNw9iOtpvEpnLI8eF8u4wfStt3nYZt+1vXbIoWsomKeRW6psWkVeY2h7gNLYynbul5NJMinA+Zr3MVq4zxkGq+sZxY2Qh5Pv+yYyj1uiJt3WPv/uKEzViwfmSEp1TQaAm7EUEvS2lV1dMqM1A+C+V+Bfckx+RHjx9rTMJ0aKR4Dy2Fe4n7hHDd5kMXFUrgBYs28Lc226gamsKEzovsr8VcQ0X45f2o7OCWJbquZwZIZoQ+LXOvAKZCvGLs8IU/HOsSjBIsZt6YaCvTppojFLGiyDwikdESU+Ue4FF8aqo+Kfqg0D67y3oqdjBQpAanHSA4721yn6HvXcj5LqSYUew62bG3M3VxwBP+wDIizr8aHyk+29xfdHwdC9HMypv3KfJO5Sd1mEMdO
 ugALdlho
 mMHhrx9dRTk08rPG71YEN7AfzsVhAot3hSUCAU8nrADhjiMQ8UtRxeCZDWqhFGflFcLRNJWr6j2ijhUw+0moZ1onVEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 13:19, Hugh Dickins wrote:
> On Mon, 1 Sep 2025, David Hildenbrand wrote:
>> On 31.08.25 11:16, Hugh Dickins wrote:
>>> mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
>>> a large folio is added: so collect_longterm_unpinnable_folios() just
>>> wastes effort when calling lru_add_drain_all() on a large folio.
>>>
>>> But although there is good reason not to batch up PMD-sized folios,
>>> we might well benefit from batching a small number of low-order mTHPs
>>> (though unclear how that "small number" limitation will be implemented).
>>>
>>> So ask if folio_may_be_cached() rather than !folio_test_large(), to
>>> insulate those particular checks from future change.  Name preferred
>>> to "folio_is_batchable" because large folios can well be put on a batch:
>>> it's just the per-CPU LRU caches, drained much later, which need care.
>>>
>>> Marked for stable, to counter the increase in lru_add_drain_all()s
>>> from "mm/gup: check ref_count instead of lru before migration".
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>    include/linux/swap.h | 10 ++++++++++
>>>    mm/gup.c             |  5 +++--
>>>    mm/mlock.c           |  6 +++---
>>>    mm/swap.c            |  2 +-
>>>    4 files changed, 17 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>>> index 2fe6ed2cc3fd..b49a61c32238 100644
>>> --- a/include/linux/swap.h
>>> +++ b/include/linux/swap.h
>>> @@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, struct
>>> vm_area_struct *);
>>>    void mark_page_accessed(struct page *);
>>>    void folio_mark_accessed(struct folio *);
>>>    
>>
>> Two smaller things:
>>
>> (1) We have other "folio_maybe_*" functions, so this one should likely
>>      better start with that as well.
>>
>> (2) With things like fscache in mind, the function can be a bit
>>      misleading.
>>
>> So I wonder if (a) we should just add kerneldoc to document it clearly (lru
>> cache, mlock cache?) and (b) maybe call it folio_may_be_lru_cached(). Not sure
>> if we can find a better abstraction for these two caches.
>>
>> Thinking again, "maybe_cached" might be a bit misleading because it implements
>> a very very very bad heuristic for small folios.
>>
>> Maybe it's more like "supports being cached".
>>
>> folio_lru_caching_supported()
> 
> folio_may_be_cached() -> folio_may_be_lru_cached(), yes, that's
> very much better, thanks.
> 
> (Settimg aside that I've never perceived those pagevecs/batches as a
> "cache"; but lru_cache_disable() gave us that terminology, and we've
> gone with the flow ever since.  lru_add_drain() would be better named
> lru_cache_drain() now, I've always got hung up on "adding a drain".)

Yeah, the terminology is not that intuitive :)

Not sure if using "batched" instead of "cached" might be clearer long-term?

> 
> "may be" rather than "maybe" was intentional: perhaps too subtle,
> but to a native speaker it neatly expresses both the "we can do this"
> and "might this have been done" cases.

I would wish we could find something that also non-native speakers can 
immediately understand ;)

"may_get_lru_cached" / "may_get_lru_batched"?

/me could not even phrase it in German properly

> 
> kernel-doc?  I don't think so, this is very much an mm-internal
> matter, and I don't care for the way kernel-doc forces us towards
> boilerplate ("@folio: The folio.") rather than helpful comment.

So a comment that this is an internal helper might be nice. Or we just 
move it straight to mm/internal.h ?

-- 
Cheers

David / dhildenb


