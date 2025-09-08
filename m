Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1ABCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF8A8E000D; Mon,  8 Sep 2025 10:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAFBF8E0009; Mon,  8 Sep 2025 10:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A77868E000D; Mon,  8 Sep 2025 10:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91E018E0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:08:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40C2681B50
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:08:12 +0000 (UTC)
X-FDA: 83866262424.07.542B8B0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE4CD1A0009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:08:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SzQwiTNf;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757340489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5RW7uj9j6VpLJ7e/ThoSXbMV/AQpqw/iOnSCU64Tv5A=;
	b=xRVZISg8k7Gqu/Dxv56kpLtZ0E9IrfiZSZue1/Kmas1JmXiuQ25tDyXFddkYxA5VwMY04U
	wyOn23si6Vxh1bkdK9hQN9N4IxQG8r2C2/P0j2Rt03uPl2mqPcqAiPRu4xYn53FbAyWnPf
	AZJqXo8i7CiyVOvP6YlrB0F8x92XpFE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SzQwiTNf;
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757340489; a=rsa-sha256;
	cv=none;
	b=VKyy7MLhhSpRVkIkHLkBD16292pM1rxqTqOPCRZANOp9Br+KYg2nCusGID1Uwru0K3DaXd
	UAicj5knMBHzXcAs2X8WoacZO/d/0yaaUdj/PU2+t0hkulXpLyNyLvo4Nk9NucLAo2Jpqw
	g1cMnpx4ih2mTBEw/ppn1IMG2N++f4s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757340489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5RW7uj9j6VpLJ7e/ThoSXbMV/AQpqw/iOnSCU64Tv5A=;
	b=SzQwiTNf+rxNUOcQ/XAXSnQSLCAnvMFBqxnooG21nyIyk3l8PCJRxLDSCEJGIfVjI5PCph
	mVq0o6GNTjXGnpP3UrF1F9mOFDob0o0votVCxA0YjGAo4vToUJw1CJ1Fd4NGWpBZTVwpXz
	xo+WpDCu0k5IYN1RP4GMwfJ+uXaaP84=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-414-x1jqVJlgPkmHcg_5RDC_uw-1; Mon, 08 Sep 2025 10:08:08 -0400
X-MC-Unique: x1jqVJlgPkmHcg_5RDC_uw-1
X-Mimecast-MFC-AGG-ID: x1jqVJlgPkmHcg_5RDC_uw_1757340487
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3dbf3054ac4so2613769f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757340487; x=1757945287;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5RW7uj9j6VpLJ7e/ThoSXbMV/AQpqw/iOnSCU64Tv5A=;
        b=fagnF5JLiF51m77RtGk11BDarhVPyezlxvXkXnbfModNvk7Z4zouMZ4fs8FpVbIrBX
         4rNEyw2+PIU+oWoXQvRKnutZLQ8QdSxjo2zZkRVbZnP9iTvNFvLckZmxz1c4V+KK+7eD
         XRXrBqJ/cX2mJGwEjhWYWX/Ax29+fh86whNT/w6MAwvJLtQq8cUtiIB2qJSNtLPoPdiK
         /KCpsJB5NSkWqlLTBzJHw1V+67gkyzKFuRiXtcryAit4mp+WWCneitN3O9o8n30PrUZP
         kqXsJF0oRSx5fmwEsxd8T7ccv+OkHNinDIdIiwsuoTEDs92I6RBaFwkpH4ZIf+0C9g2R
         PS5w==
X-Forwarded-Encrypted: i=1; AJvYcCV7zsAZd93NMpA3zwdxqCnz2ts7iDSCWppp7u/cfwxc/ooBEXvSz9MSB4a2gBJXJJxBishr6atwkA==@kvack.org
X-Gm-Message-State: AOJu0YzMBZjeOIgDHkfLMwKoZJkKHNCTS8uK9mqC6jzX5lmUcCkhkCHD
	3eU6tRMeWGeh2Awl7zlvkQLZjc4N7ZjaVzi7q4BbsnDKEBkyULuyyk66XUW1jq1Bzz8skiZZhBS
	KUj6RsX85q+gL3+mgDhQwBFekfyhk8tCG/4lbuLyABT9iyJdm9cxq
X-Gm-Gg: ASbGnctdNlfyMJ3sBZkDbiRDiq6eHX4soM/9QHQSo51kxuBOzcGPD56QknAOTGUqnmD
	7d01lxokcu5b8nHr5af7rMK+aIck59LC7vjLAJ4Nw39shRDDo7usY9FRrFOb/NF82zdNhUahNzR
	/MgZxHofvsY/O1wFvvsnL8zi+ltVc2wNPk1ROEUVmzWLn7nnNFwoiH381l9OAYqt3fRfSgIr607
	KdIe8VvN9PLQ7SmkX6ECDu7IBMRtwWcCQ0LtlmgUjz3d0/vO2vkL8f2w320VmA+/E2Xpx/oQj0Q
	jbTlLcq0M97Tb5e61886gP3f+d+ioh37Tw6nN8Jn4Y7Kz8GWvkte3750XHYy5AXHJCEzcg9HNCR
	Yh+XtKjsiHbzfXQYiku5NUGg8jXoFC4Z6Y55YfR23aWbw1LVwXqCF/mq1y5wdryKQ
X-Received: by 2002:a05:6000:230c:b0:3d0:64c1:1a40 with SMTP id ffacd0b85a97d-3e64374116cmr6007192f8f.46.1757340486664;
        Mon, 08 Sep 2025 07:08:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGyB0IO3PALAsa1/2Q9RjoytWxnek+k4rCfl8hh9plqBM6DuIG8BW9C6h/pNo7GIvytXSRWWw==
X-Received: by 2002:a05:6000:230c:b0:3d0:64c1:1a40 with SMTP id ffacd0b85a97d-3e64374116cmr6007154f8f.46.1757340486206;
        Mon, 08 Sep 2025 07:08:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e74893acecsm4580959f8f.36.2025.09.08.07.08.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:08:05 -0700 (PDT)
Message-ID: <1f714ba0-cdda-4122-b6a1-e1e0ea44b1f2@redhat.com>
Date: Mon, 8 Sep 2025 16:08:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/gup: check ref_count instead of lru before
 migration
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
 <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com>
 <e54b1d8c-ad63-4c7a-8b1b-b7c3d76446f2@redhat.com>
 <b008aef2-f69f-e2fb-d4d7-71a42d308529@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b008aef2-f69f-e2fb-d4d7-71a42d308529@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nINWofDeYLIckVdYJ9oiVhhNaJwTR1OP3q9CNfbFsFo_1757340487
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE4CD1A0009
X-Stat-Signature: 5g6nriirxiomk6kg77qqo9cf38jqjkri
X-Rspam-User: 
X-HE-Tag: 1757340489-641163
X-HE-Meta: U2FsdGVkX18jNxXl4JD2OHBMl7sQJV0oQPI8Fu5l+CxEpeMdND1PDbMWj+0DjbnDOhqOSpTqXgsGCGEYOmEi/gBL2V9i/CT8HJ3EJQgrYsOXdp49MRrsPd41Ck4ukK81xh8YQQQndivwGsC3hTycrRjx2srKmMfWy2mRZizesvilNKSGMBWSvdUGG9O3laIV4LDXaNQlWkBmcl3kdKQtLrZqvJhg9Req5MOTHgonvjrbmpO5wOeBL4k92nztlyQ5MuehswRsE5j5kHT1Z9SxTEVqkxfDIjw5K1sOvsUnRfmw4GizoKwmcP1HyqeY0L+qzNyXo0zbRqsdSnE8+sEUpAUJeqgiRhG0S+bxoaXPiEeW82Hhm5Izmoggm4ZzD+9fYPwJ//u6eNP9PkOtBWLgzN1xWkLVlC9S3tk7KavkAX6u6ALAgLaUXaAJxS5XO3bCcG29RePageajJ7plG9QZ2RfS25gbyPVJWkoDr1Hsi33FBwrVMxFYp5k/6DVUo9vC6hVG6eAZHtjZN1OExn1AbhGGTSo26MRHM5GRfwM4/uaLs2T4FcfMN2KvD27Pov0e7IEBydr8SOmnSJ4Y1ZkZWDy85T8pC5VpXFvPXS55Cwf6hOD8GymccrGshTWQFe+SNFhjRKRhYgFbpHANw42KEoIeciQQkXhXNtPI16S6MgO3Y5Ht9Q5d2LkZOkiGdqCS648+yxkXg2uQUUqpEpAfFN/aDNUpYHKBhUiEkLvRuAhAoU2G20Btz+x7ZDMVA47GkQnvpvgdsmW46H19g24alUeBT4arBFEBjXFSYuMpDeg2iTetFLf5c+7FGNt7tMATXW4OapjuD2zlcp8IyKXr4j4NOwpTt/qkc9g0rsrLKqP/rIewcz3iWxyrGA95yJrJmKzS/ka8y0CmQ9R0tyovEOU4gRSsTMwbCiBvJphgojUyYS062ciBRpSraXDN3j36CBH51g8ZmV3c/GLdt8e
 jHfqprJ9
 lZHcxbxb/gLAu3ONYGXIXQYEmnvX5UmLmNuSPiftBKoS3md1fr3DtfKVVl0KUplnnKQJoVgiVbEai3b7sjynEB7xS4Dc/PekJEx89PzRgE89/SINy8ryohZaGen9fonP+t/4HEFGzLBOw2dEKjmGz5W4xX+MyQGFCOzEhKDtf15J7h0v4F2NiYbXin5HQHdDzE004IFgKofOvCUIG2U0EYWJm5a8Fv7rwvFatMIcgBwrYOSlp6b0XJxKUA/X8q8qbpkDMqqKruyboxwljVYC+xSvBRB+eocd1ZAiXhbBIA8RCMSaVL0yxkFGiSyV8v1eIdiAsg9EGq9viauFDoc3If5mxrzJw4U+1nnNWHohx4d/F0R+VmoOKh8AB/6PvKRQyQF3vsk6XTcfNQyJUZ70Q5O50LtrFUzYPRQebxMieFD+1i6TMh2NeVY0LG15LVOlDL268nqVZSB1WDO8goEs3Xqz13Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 12:40, Hugh Dickins wrote:
> On Mon, 1 Sep 2025, David Hildenbrand wrote:
>> On 31.08.25 11:05, Hugh Dickins wrote:
>>> diff --git a/mm/gup.c b/mm/gup.c
>>> index adffe663594d..82aec6443c0a 100644
>>> --- a/mm/gup.c
>>> +++ b/mm/gup.c
>>> @@ -2307,7 +2307,8 @@ static unsigned long
>>> collect_longterm_unpinnable_folios(
>>>      	continue;
>>>      }
>>>    -		if (!folio_test_lru(folio) && drain_allow) {
>>> +		if (drain_allow && folio_ref_count(folio) !=
>>> +				   folio_expected_ref_count(folio) + 1) {
>>>       lru_add_drain_all();
>>>       drain_allow = false;
>>>      }
>>
>> In general, to the fix idea
>>
>> 	Acked-by: David Hildenbrand <david@redhat.com>
> 
> Thanks, but I'd better not assume that in v2, even though code the same.
> Will depend on how you feel about added paragraph in v2 commit message.
> 
>>
>> But as raised in reply to patch #1, we have to be a bit careful about
>> including private_2 in folio_expected_ref_count() at this point.
>>
>> If we cannot include it in folio_expected_ref_count(), it's all going to be a
>> mess until PG_private_2 is removed for good.
>>
>> So that part still needs to be figured out.
> 
> Here's that added paragraph:
> 
> Note on PG_private_2: ceph and nfs are still using the deprecated
> PG_private_2 flag, with the aid of netfs and filemap support functions.
> Although it is consistently matched by an increment of folio ref_count,
> folio_expected_ref_count() intentionally does not recognize it, and ceph
> folio migration currently depends on that for PG_private_2 folios to be
> rejected.  New references to the deprecated flag are discouraged, so do
> not add it into the collect_longterm_unpinnable_folios() calculation:
> but longterm pinning of transiently PG_private_2 ceph and nfs folios
> (an uncommon case) may invoke a redundant lru_add_drain_all(). 

Would we also loop forever trying to migrate these folios if they reside 
on ZONE_MOVABLE? I would assume that is already the case, that migration 
will always fail due to the raised reference.

-- 
Cheers

David / dhildenb


