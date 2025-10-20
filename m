Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FBD2CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D688E0010; Mon, 20 Oct 2025 07:21:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945518E0002; Mon, 20 Oct 2025 07:21:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833328E0010; Mon, 20 Oct 2025 07:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 721B58E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:21:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29CA41A004B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:21:28 +0000 (UTC)
X-FDA: 84018251856.18.A5998D7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F01C1C000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:21:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ESHnFv0m;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760959285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wds31+AksH+mUEETdlpxxIX8Pxrsqa257DLCv4vc6Ho=;
	b=q/FljFCGqXSklku11SAvTZFAZPaK44Y7QyKksh+u/wMHLQT/tDnuR8pUJ4XMb9t1hKv3Bb
	9iEAfnsk7sm/KA8Mv+p+ywrLWcI5mvV+BaSckZfw2v9zplnfbMi3GuwtAGs7kUH5izULNs
	My1qiPfPr336cHtps5lF5MGmerz+dEU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ESHnFv0m;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760959285; a=rsa-sha256;
	cv=none;
	b=3RBoBgDuMZBW1CFl71S8YnTFuFafQfbfirWJR1/5lqEZkeE73+gv8NjBhn6HkXmQSqAnIR
	TQwib4YFyXc6V7nfJURcy651luc06RM8+XlfTYpDeUBZZN+33z9Y76p0oQS90SPOGYzGsn
	ZinQrHALqdQYkGQLvm0/ICQdDZuH+3g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760959285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wds31+AksH+mUEETdlpxxIX8Pxrsqa257DLCv4vc6Ho=;
	b=ESHnFv0mV1SygBJ/YjVWJj4NRnCUKpFifr45UKXp/bcDj+ilWPhELIVslu9wPmO1BigmZB
	k5wg7Hhl5v8lgZwUh0qKxJZN3IYWpqz6QckD0MbxoMmj+lEHG3+HZEy7Izf3t/3h2Vyb4/
	7XZOB93oAPefBVbDJWape8qrPqLWmtA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-oBtQMg_hOyu8GgT4tgK2kw-1; Mon, 20 Oct 2025 07:21:23 -0400
X-MC-Unique: oBtQMg_hOyu8GgT4tgK2kw-1
X-Mimecast-MFC-AGG-ID: oBtQMg_hOyu8GgT4tgK2kw_1760959282
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-b548c516b79so487034766b.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760959282; x=1761564082;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wds31+AksH+mUEETdlpxxIX8Pxrsqa257DLCv4vc6Ho=;
        b=NMh51exKRj2hbp31RqBrfyZMuEDhusr7fHKMK2+uS1e8DiCm/4GknF1SxsM1z+BnFx
         /ZzNBDQRXjTNLnWOZ3FrLIm8tkv3ckMRtC0cS6pTDDaaROvpu9Dd0Q+5tlKxX//+DpVa
         yhzgBeIbwGgRrPEtVMMTMcL5K37EFUIg6vTrXPE/trYRYxbCnuy2oOtSObnfrrhXOFfz
         4Zt0VNHx2wIVCvVdvbV631zAnldfhuNgldRo5epEUzZOwXUf4vy6VscRicHGPqjwoItk
         G/hE0yPrYX2yBeQJ1jgxRqLXyqsrk5BfCGoUdDv8Nu1tFuL0ZMZdaRcdq17PofW+Km9r
         cOBw==
X-Forwarded-Encrypted: i=1; AJvYcCU6AljdKmxDv1d2hOhFo2izTZjDLwKZnfHbx2ORDiTxqsJ8fvgh7rg1TtbQu0xYBdnZkIraA95GMg==@kvack.org
X-Gm-Message-State: AOJu0YxUJ0KVQSH2m/mOXk8YWopuBUcan2PamZ69jxBEO7kxoJeM0FQ4
	aw62CVb8XH1/vWi1xR8P23ElBEws6KygFPegNVsIb7Ab08Nr4LAr06B+vdv/MNGhr/zaZRFsQ0x
	S6xTqoXMeSPbqC2Li69ArCb9LbZ/uDXFRZRbA400wRdQX1rfZ4RhX
X-Gm-Gg: ASbGnct/ZGE4nM26hoBvHP8CTLc3Tf/XxiszdD1TFfZxKSvDaZHafZK67GMABytbHy4
	6gbyQcZ0P7r7OW+sV43OWFFjsj8vaXeX7YmNYvi+rSiXJjJ5ak426lrcDAzUwYZQmUQLWQdk5Kc
	AO70nYR75EBggnzPLYduSYz5g6aGEOEbMAg8fZqBOqSRrwh7CsJMRfw29zCkuD7Wck7fczLsCqa
	IK2H47wUEm3ZXL/9mkCwc5iX9oVYiJNmxwxhV0PV3gbZjaypnopfxaqDNtjB+StF3FKFj9w/9R5
	g3ZnXWbeFFT4miCNaMnwD3qXPTmudRwYMy/w2tV8lzxCevLp436GeNixJVB3grB6VhNkrf9vLSJ
	nvzUR7U310+cjCVfdmdUmfJGtxTYv95mAVR6acGI0b17jGkYKew6SIZObaoxZilONTfW9HlzIC3
	tKXpmYfIo6BEcNrUZS0LHqFSkX88o=
X-Received: by 2002:a17:907:3d87:b0:b3f:b7ca:26c5 with SMTP id a640c23a62f3a-b647570a3d9mr1429912566b.59.1760959282334;
        Mon, 20 Oct 2025 04:21:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHenN8DPdLH1YrbWHC6rMNNYQJQeC9HIGErbh2OG0rtzdQbt9zFEPDmXchMbuVkF7mvdkShoQ==
X-Received: by 2002:a17:907:3d87:b0:b3f:b7ca:26c5 with SMTP id a640c23a62f3a-b647570a3d9mr1429909466b.59.1760959281697;
        Mon, 20 Oct 2025 04:21:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e83976a2sm748432166b.32.2025.10.20.04.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 04:21:21 -0700 (PDT)
Message-ID: <dfb9fd83-3fe1-4596-bc94-c3f9c3c916ce@redhat.com>
Date: Mon, 20 Oct 2025 13:21:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Vlastimil Babka <vbabka@suse.cz>, Jiri Slaby <jirislaby@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
 <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
 <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
 <3b97b754-890a-46c6-b892-a0324d529a3d@kernel.org>
 <a95df2f2-5ecc-4d28-9bcc-1f9b457b04a5@redhat.com>
 <48a24efa-a326-4cca-ab28-50c6251bf03a@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <48a24efa-a326-4cca-ab28-50c6251bf03a@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BMUs8I-Z1XYhrQp91cUyMz96fSZiXFWJxDRJIg72BdE_1760959282
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: k7kucafkn63x6d7oxk7gqqa3emxk7x1c
X-Rspamd-Queue-Id: 9F01C1C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760959285-304607
X-HE-Meta: U2FsdGVkX1/fBhhXVh0VIOnvBRN2k5wYN3u+tADKcoaDofdgMSZIidVX8KvKT8FZtqk+llN1tQ4L/3QMSKZ6jjUhiW0QFHP/Q9S3sMVSnMjjDKP+/hCVFFlzbZODMDHy7HFHU8ssRFgYI+JJR3dX+cQbjIz2eKJaoA2N+M+nQFyzAp3Bv1uWHZimnSXBuFqFY92LCWQEoZonFtvIgsQSop8sjzqvpTL/as1rCtA4zh3Dwp6d+JjKm9c0h4IP4k/PAoPIL1oiRp8gB5yJJUT6Gq7rCE737b6NXX/LP1deLApjkqzuI4xYfhonqegYoWpvjaeY4cB1kfny8KHDIQ4siUe+GITxJMFHbLN8ie+95yOfyeV/vcBwxbtyhHMd71CriUgqixJjlNJhv393vyrDUhvum0Pmcc8P+mGqNw+iGy6ecg6nm4oriojJ7LgF9+J6GAX3Zpvu+soDVRSWo1mm8YN2ZY+gLW1NZnJRRPR1Wrm89BXIqZUJHJTHpWLSN6EArtU/j8lQTI9O4qmcjmdv1utPyWmdSekaj72F2uS93+jZ+7FAE714Oa774A3ocULRbU5NzGBoaOPUjh5KrfB3WHsCCvcDkj+odk8la90D+PVAEI6sDTQ+lWCnzLta9SWR6SpET29FtMvrr2IB6QHG/YjYrtlGAM3//WCQhqBkk+pBLT/430CssbH8RR+phCEh8qaGAUXfQH7eNm47uqoLhl2vZxZNPi9mQuhXX7HT7ko3t858gB8VBY4YnfZwU0WktglhQbVIPq7nB3SAT+hPVCuZFSjUizw2d5Euuxq5ZgRsvzUCr1cz7pGFaauQkgLKwz5+ztsoWnISnRGtuyW7YiBM4/yItbUEijzUbFdjNsSfV16YlGPksF7RCp16t4CXjlUj91GtTqd4NN/PiWRyhlullKOtX5H8NO35mlWDIEDViU9WLueAuOyq8pYkvYoaheh06DaASR1+FBW6Ca4
 5eKHjCdB
 y0Rt1WnANBcoJKL43NPHZf4a+8l+yFOhp7q8r8VRP4TC+HUpz+rfscUUl8L07J/RAGfR8L9N444QcLMWYzBD0Ql/vOzqKeckAz6TaOnfOGIus3I2Pu7HmrZLk0IMtdYYe+BRYjCcPqbhiUC8RVHJ3cuigVerhProMvolCyxH66bf2c0W5G000MhyIjOEm2h6rL2mkCk2P9OFpYGxXGxXr0B1F0YGChabqFb8B8TXUg+6oW/YSvExFKWtcRkuqUZJtePQLGNtNxVkFWEFHobtgT9ekJf90xbBX2zVE1TH9czU9kfaypN66Mpw9UlaAgFFLFcK2VY42mnhxkLCKfGIK0MNOxKQAohLaGdh5HrQ7QmYeWmzOWtHQFmFlCPJnk8No/ncCoyr2+q2p3qwbT4vC8qfFml1YdhWE2fdMTIU6vMqZv3zp4nTexX15iuFNnTYVj9mCwsFM/INg1KJGqQD+Xtz8C93BuzQuzUvI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 12:31, Vlastimil Babka wrote:
> On 10/20/25 11:13, David Hildenbrand wrote:
>> On 20.10.25 11:08, Jiri Slaby wrote:
>>> On 20. 10. 25, 11:02, David Hildenbrand wrote:
>>>> Regarding the metadata overhead, in 2015 Linus wrote in that thread:
>>>>
>>>> "Long ago, allocating a page using kmalloc() was a bad idea, because
>>>> there was overhead for it in the allocation and the code.
>>>>
>>>> These days, kmalloc() not only doesn't have the allocation overhead,
>>>> but may actually scale better too, thanks to percpu caches etc."
>>>>
>>>> What's that status of that 10 years later?
>>>
>>> AFAI skimmed through the code, for allocations > 2 pages
>>> (KMALLOC_MAX_CACHE_SIZE) -- if size is a constant -- slub resorts to
>>> alloc_pages().
>>>
>>> For smaller ones (1 and 2 pages), there is a very little overhead in
>>> struct slab -- mm people, please correct me if I am wrong.
>>
>> If it's really only "struct slab", then there is currently no overhead.
>> Once it is decoupled from "struct page", there would be some.
> 
> Yes, but there's potentially better scalability and more debugging
> possibilities as benefits.

Agreed.

> 
>> IIUC, I'm surprised that larger allocations wouldn't currently end up in
>> PageSlab() pages.
> Can you elaborate why surprised?

Primarily because I think it's a bit inconsistent. I would have assumed 
that whatever came out of kmalloc() could be identified as such.

One of the benefits of PageSlab() is that we can better sanity check 
that these pages will not get mapped into user space by accident: see 
page_has_type() check in validate_page_before_insert().

But given that ___kmalloc_large_node() today also allocates frozen 
pages, validate_page_before_insert() would similarly bail out if it 
stumbles over the !folio_ref_count(folio).

-- 
Cheers

David / dhildenb


