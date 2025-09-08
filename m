Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00673CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336C86B0008; Mon,  8 Sep 2025 16:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6B66B000D; Mon,  8 Sep 2025 16:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187C06B0010; Mon,  8 Sep 2025 16:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0298A6B0008
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:17:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 960B1B6ED0
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:17:30 +0000 (UTC)
X-FDA: 83867193060.22.F474140
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41FFA80009
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:17:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gsu8tWZi;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIdc2B3/3kj+ymcwj5i/pUFxxLC6d1gkotCHsH6YjzU=;
	b=zwyWF+ULQ3e8lURp8I8bblHDC612jZKNKipWSGcJyUlTpNHkjGIoW/rCAHqejGbLhoVt0n
	Mlbu0GasTT/PgMFhmZZmxmGotTBjeboOj1NALPqJU4kWYsrVNcu/LtGrdfB1yLka/JGUOd
	gGwsOa8tnl+EGeGsuErtLP9pctCdQEQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362648; a=rsa-sha256;
	cv=none;
	b=dOEA1A3XVvgOSfmS1U/oBnNx08yz7oXIJzgGmkA4+VDAntpbvpaR1CcS8KliJ7UeRZ5JuL
	NPmoh3UYDo+7cdv8sAkgzHinUxjlUgv4hw5HlCNYeP02NwxJ9vXBqNoPX6KTFVm+vVfHcm
	EN+qyiGTguk2zeP5xT5SXAuVBbgDF+A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gsu8tWZi;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757362647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=uIdc2B3/3kj+ymcwj5i/pUFxxLC6d1gkotCHsH6YjzU=;
	b=gsu8tWZiteZZXWX3NRkAEnGaKOQJ4OL48JTLaKj8TbYPiBlJ29RZ2E91DgysYvFAgbT3mF
	pxmiIm3cyVc9tVFYNeaT3HlMKJIljk/37XkeaUvWIn+eWYGFIGDK5K8/mhi4a+1sbVTrLi
	i7F5GcNodatOkY+j/wR5KRDDjE8sjS8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-17-AqlYg5H-Nbq2obVJ5KkJ6Q-1; Mon, 08 Sep 2025 16:17:26 -0400
X-MC-Unique: AqlYg5H-Nbq2obVJ5KkJ6Q-1
X-Mimecast-MFC-AGG-ID: AqlYg5H-Nbq2obVJ5KkJ6Q_1757362645
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so26166545e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757362645; x=1757967445;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uIdc2B3/3kj+ymcwj5i/pUFxxLC6d1gkotCHsH6YjzU=;
        b=sFl8qnucQPQ2CIk0C+GNntJ0G33+P8h2kozcO3M/AsgG1tqsoDAkSy0VF2dojJ42OX
         hpVl12Wo7kn4pcuYJ6qfwoYviZ3xF88Ntd253hQcp4+mYsvyn+fhkDOvdpekskTX/Ite
         zjwlT2t2bEpeCjGCGPsW0b/84jW0fjHpfoO/P/eQVNu/QRqpkzPRJveKIqW3MsPlt5wh
         YLALoKxzRo1PHxATIPHf7nwKqVr/zxh31LcLTd2m9pxI88eittNcurStNyafAmbp9uc5
         6jBDTA6Am0XhfF3JHDJsLTwWVBWPG8h5XS947LLENjEFfOuOnrDxYVC/axH9de3vuJE/
         AJdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvH+gLDBeABUOWKnZ0l57L+52AjYgqtlnb7pTw7SNMUuvev6wafCbCzWME1ofH1nFehIoxfE7CuQ==@kvack.org
X-Gm-Message-State: AOJu0YxlxYb4Fau2xxR2ZTxgzGLcEPwNhciV/mnpmQBTQLsI0aK2Bh8L
	S3/BbNUigcRs1XpjpMoX0HE5fE13BSh2Hhtx6TvB/tIu6N9zMmePm5KX2dB74gcuOWUj3VKy15T
	oTPM76nMVMPjDXo9iBWFThHu6DsBjwRaPRcQGp54fjZZAmJDDvCL3
X-Gm-Gg: ASbGnctLbjoIQCfcgB0zlXTX+kgtSygr9MLrOmcSt6IAG/KEB08M1Kka5HBeYbOv+ZX
	ln5AykX+2oBRpIpIOd0HLPnLKnXB/INBvdW/ilV7y4sWmGJ5OLgnDgx9pLbXPbWgXF5WTc1m8Wh
	J3sNab9Sc0RFsH2kfa/zPnaovX4gwVjt0aNYDtrO7wj/cDmzirMNALLuQ3qQF40GQSV08jfpjJU
	jDDN29RlL6q2f3EcSz6RfeGS+KTw21gwHjv7ovZ3YVAgAf7+3yUh5T/lhRcl9ynTB1V7UFD+E1O
	TlT4LiB5w7GbHeaLn6gKDBzj/FBIExYVogOtKeOjzy0ERs1kMfaDZWu6SztU9qko+0J4KLw=
X-Received: by 2002:a05:600c:1c04:b0:45d:db2a:ce37 with SMTP id 5b1f17b1804b1-45dec615a1bmr11841585e9.0.1757362644751;
        Mon, 08 Sep 2025 13:17:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7VTWXL8MTAyDz7RkkeZe8eMmnkRUN5PlJ90kWk1wvnC5CLCcvu1WLdP9XdvnFdls022qPbA==
X-Received: by 2002:a05:600c:1c04:b0:45d:db2a:ce37 with SMTP id 5b1f17b1804b1-45dec615a1bmr11841315e9.0.1757362644276;
        Mon, 08 Sep 2025 13:17:24 -0700 (PDT)
Received: from [192.168.3.141] (p57a1ae98.dip0.t-ipconnect.de. [87.161.174.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45decf817efsm6223815e9.18.2025.09.08.13.17.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 13:17:23 -0700 (PDT)
Message-ID: <919ab2ee-6493-4415-a75b-e1a2b08c0d3e@redhat.com>
Date: Mon, 8 Sep 2025 22:17:21 +0200
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
 <1f714ba0-cdda-4122-b6a1-e1e0ea44b1f2@redhat.com>
 <d5333648-7b88-9293-dc1f-e080dff65d1a@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d5333648-7b88-9293-dc1f-e080dff65d1a@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iahwUVYVK7mjsU1uP2sjL6tj4QQJSTesnzsymCepmSw_1757362645
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 41FFA80009
X-Stat-Signature: bdaent5poppy4pycogsrontd3kkpjn6o
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757362648-375280
X-HE-Meta: U2FsdGVkX1+Q6IyW/v7povlHyWxYPlvfIF0POBLbZtRAi7z8tuPdNcwcRkmchBZFkIHGk8mmhUQyR/stPxb4EXqhHGHU6fLDFgecInaHGCl2V5ALxESNsYpEdzq6Vdhp/gGc12Fi0E8bB7EEiuFGw2qB2+2rUpm0NFKj5VqFRBUZRJPMxJESeDIOJ5jbOC1G7oW+bIZhxSpOmSzOSJDa/esYszH8xUyF3VaJvZi6oVUvH/pXOK6pyglgMzxUKK8Fmnp0V3DpD7GfOtTjj/uh1iSKKeJvty8woJPBXPzbdC3uaY6vYiVoAGV6olEQJ4WVl4IWb9iMnoXcKZEU01y6I+8qvubvTbU1nVKFSoppmPA4jyFbV7CHZPCkIUMDqi31LUyJl+fVDwO1XKBbw8llwyHeDwsCNYhGUXyu1nOxsOyYottI4xKgmBW13mK3Tmg1iflAQ4fTrPdl4vz8IrgWpC2NOw6S1daMfiEuksaZmQdaanwNz5LpBO9CIacaZZcNMyjd4O0k+hR28EUXQSBg4cgXFOq7+mdROOo7LyuEq+UXEBd/0d8GuRwQPJn38w6LEF6iqr+1uSC/nxTDdZ6hurbj3bW5TuzNHCppQhjzN8f0zG7xppELrESXKRPTT5nwdDwgYSrRjRvvZd9k5Zz6BSjqSsmtyzwTHYYgL+1O0xk5DRaWWnCaSuy/QEn5mfeJgrsPQWFxi+o3cMP5g+4QPf+daYtXTYmBqHLV+GcsmijUE+QuXOiQvjonUbrXgVNf+vNUgKPrmCnrvzVoOo8N9PBYk2sC5jYRliL3s6UcrwFl3O20DbeWZcvm6Qs70Dn/nJWpRH27bp/bLW+WM8VWEX9kZw5USzYPeB3SmI8pFZVnXUsifY38twigPWN9n0DfHOMVj0SJM/jDzlKVKl5/hWCibvsIdiTgCKywQMXmSrGoNqesaoD/9yTaeAQNOoimS4D+TOpJehmA3P/956Z
 CgbbRZby
 0+5qhylkZUNL0BLSp3rnndZ5m55RYSfrlOWKBafKAClDDelS7v1AfmhgxzNxZQalOBJVMiD/KHd7Kpx6c9hITkvgU+ZQH3Og6J1Rak09Iq+FwFTvKRECVbL74Ci0Vv/Yx2+iR2LKmNu3yDARSA9JEC/vaf4VLAb3VAQmKy3Uf7xZAxi0HxrQnWQvdSSSU2EnXz68ccqoM6eAXnRIZhPoX8LZETr1NvkLlPeYU5rxWm+V/YBgLdl6VgDhssxK6oRIACudanbRCZx9MNsbPk1cly2RTUGWD8hJ6eMvKha2GOIZ72MH5GWUm8Pe4VXvf+je79CQhZi/eYq5iYkJCHRFyTlh4lGhiTsEbjfguUnE79/tW4pB9b3xh1EJScQNWAmGTrhKRwVqZBksa1voWB0C2Kj6SPIRDgJBmNvFcrO8JhSudzuqDdMYAITrCNLwaNDQCuWm1KR/PAWdp26U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 21:57, Hugh Dickins wrote:
> On Mon, 8 Sep 2025, David Hildenbrand wrote:
>> On 08.09.25 12:40, Hugh Dickins wrote:
>>> On Mon, 1 Sep 2025, David Hildenbrand wrote:
>>>> On 31.08.25 11:05, Hugh Dickins wrote:
>>>>> diff --git a/mm/gup.c b/mm/gup.c
>>>>> index adffe663594d..82aec6443c0a 100644
>>>>> --- a/mm/gup.c
>>>>> +++ b/mm/gup.c
>>>>> @@ -2307,7 +2307,8 @@ static unsigned long
>>>>> collect_longterm_unpinnable_folios(
>>>>>       	continue;
>>>>>       }
>>>>>     -		if (!folio_test_lru(folio) && drain_allow) {
>>>>> +		if (drain_allow && folio_ref_count(folio) !=
>>>>> +				   folio_expected_ref_count(folio) + 1) {
>>>>>        lru_add_drain_all();
>>>>>        drain_allow = false;
>>>>>       }
>>>>
>>>> In general, to the fix idea
>>>>
>>>>   Acked-by: David Hildenbrand <david@redhat.com>
>>>
>>> Thanks, but I'd better not assume that in v2, even though code the same.
>>> Will depend on how you feel about added paragraph in v2 commit message.
>>>
>>>>
>>>> But as raised in reply to patch #1, we have to be a bit careful about
>>>> including private_2 in folio_expected_ref_count() at this point.
>>>>
>>>> If we cannot include it in folio_expected_ref_count(), it's all going to be
>>>> a
>>>> mess until PG_private_2 is removed for good.
>>>>
>>>> So that part still needs to be figured out.
>>>
>>> Here's that added paragraph:
>>>
>>> Note on PG_private_2: ceph and nfs are still using the deprecated
>>> PG_private_2 flag, with the aid of netfs and filemap support functions.
>>> Although it is consistently matched by an increment of folio ref_count,
>>> folio_expected_ref_count() intentionally does not recognize it, and ceph
>>> folio migration currently depends on that for PG_private_2 folios to be
>>> rejected.  New references to the deprecated flag are discouraged, so do
>>> not add it into the collect_longterm_unpinnable_folios() calculation:
>>> but longterm pinning of transiently PG_private_2 ceph and nfs folios
>>> (an uncommon case) may invoke a redundant lru_add_drain_all().
>>
>> Would we also loop forever trying to migrate these folios if they reside on
>> ZONE_MOVABLE? I would assume that is already the case, that migration will
>> always fail due to the raised reference.
> 
> Loop around forever?  That would be unfortunate (but I presume killable).
> But when I looked, it appeared that any failure of migrate_pages() there
> gets reported as -ENOMEM, which would end up as an OOM?  But you know
> mm/gup.c very much better than I do.

Yes, like I expected, we just bail out. __gup_longterm_locked() will not 
retry in that case. It's interesting that any migration failure is 
treated as -ENOMEM, but well, that's certainly material for a completely 
different discussion.

Thanks Hugh!

-- 
Cheers

David / dhildenb


