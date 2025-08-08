Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4A8C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E7DE6B0088; Fri,  8 Aug 2025 03:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BFCF6B0089; Fri,  8 Aug 2025 03:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4FB6B0095; Fri,  8 Aug 2025 03:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2406B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:45:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 922EB5F91C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:45:47 +0000 (UTC)
X-FDA: 83752805934.28.D2D52EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D382C1C000F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:45:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9IfnXmW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754639145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=off+V+WfSdu6BkP2pk0d17xfYRqm/hECfoU7LMpjnbw=;
	b=HKGD8WtOlsj9PbAF175VNXuJvgIusSU++qtXY2ElI8KSQZYf6nzuYYCRcYkqaS8RcLyesK
	mMaG+x+3WnUEDY08ffS7tvrJZOmwdNLR+kmftVsW5S7kOWYZD1fgfdPoswEVrCyhmKqpuJ
	9WXbfUq+qmpW0rfWN2uNcHwjGZNbqw8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754639145; a=rsa-sha256;
	cv=none;
	b=MxmnG8ypvpqgON4EEh1SbmbAwNQ+TRW3XGzqwiPo3kh5u0C02NPJwKqXoOZLjBXYQZpkvU
	l+KC4oT0/NAkbc1S0HKY8gTxPorC3AVuUKNyDHQ49RvD0lar36OpmB9SpT9dgkojLsZCeB
	4Cwbmwz22elVLvWr1n66X6Qs/wd1hGg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b9IfnXmW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754639144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=off+V+WfSdu6BkP2pk0d17xfYRqm/hECfoU7LMpjnbw=;
	b=b9IfnXmWnaqRdNRqB93CE1SUH4zojEI2XS1gzmloejglu1KpOb+chg5TYYGXeJsFIG9IlX
	IhiKSZBYgoIX0D3TL2KQiZJPwjwBY6QbKd8p2GMHzTKO6b5vryeu1/UXlT4OXHdOjIdzZk
	7EeFOsgi0T945i7Z06q7xGEOg7llL/E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-84-jSy7zf6VMPKlxe38o_bh6A-1; Fri, 08 Aug 2025 03:45:42 -0400
X-MC-Unique: jSy7zf6VMPKlxe38o_bh6A-1
X-Mimecast-MFC-AGG-ID: jSy7zf6VMPKlxe38o_bh6A_1754639141
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3b78b88ecfeso950556f8f.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 00:45:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754639141; x=1755243941;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=off+V+WfSdu6BkP2pk0d17xfYRqm/hECfoU7LMpjnbw=;
        b=s4AWcj8nZ0u30AEVSrnFABm88RqcSRbBT4IwtbADxilAglzdIl3dkJaYw5YsvdmzTM
         G0hRYzk8oVwSYw4QEl4gFcZFRHChwgoo/r/U3aIZ/UV3rG9Hv4EEDUPmu7uSxz9v6vx3
         B6DiyLhACqzczPf/XbzcULi4EJJxh2rNzmLxGooq1BFgJ296xSDVFFmi+PAD18S2F9nt
         zFcR4tVeOQsIPt4CH7FwbIesV/ebPlyd14Kb1zA0cLpbkVNI13VKe9uMBuh2QoAlySev
         OxdBDpTuG5oqvdKx7KSjClX/o4ElchVMd7qV56lCYsQugcafaOtOgszejPdRlqynogSY
         ZKDw==
X-Forwarded-Encrypted: i=1; AJvYcCX3NGpWaq7i9h09k/+IulrqNdBAN6n6vad5ndFhYGMnKlLs7iJerlUWwRRcrZydxxF9a+dOnkgJWQ==@kvack.org
X-Gm-Message-State: AOJu0YwOG94HAuk8J6mRL0FbYQSBPsZdF7Phfed8zNnt9kwFKFCyD6XO
	dxaazl03iXRzhjQV4f2ezBD68pK18o3qnfeJkxbW15ytmBszDXED/D/8BCry77+6MBKkTxGVpuV
	5zKcrDnTMYwVIvDdhe2NIfNl0veVgz1zXvtwmHSL/1yDDorEao7yL
X-Gm-Gg: ASbGncvglOU9GCSCG7dmooARs+KUBGxo2gVM9UamywGvJRD34eM0NCRhPviWsu3v+Ag
	qAxQ0FTNb0L/iwzdXsFmzwvmuwkme0fNoI/ZRP/1Z5m1zt/ofOrxfC2OU2O/hLNLut3tW0CWH3v
	4Gwn9yRF1uQS/Wvqf8AagpuVv54UdZN0RicwBMy/9unlMIMTyNau9NOID05SFkocpHJpDCAvOs3
	2A98Os8fy6BNJXZelEpH86zL9PKag/xFKn5hla0u1dB+c+Yo5aocdu9lz2CE9IsHne6h53GZamb
	GWB0NF5rttJo7q/Q3sxAEaH0xhZTu0o3bPMZ7rrlyr0aKBneUDGRT76EOhefc091jiIBjdWYOZR
	yiglEyKZvyTFbW5hyEwMNGXVP3kbmwyZK8PunXPMLlsr1BIMrwjkN4cb80SeDOKIl
X-Received: by 2002:a05:6000:290c:b0:3b7:94a2:87e8 with SMTP id ffacd0b85a97d-3b900b4db70mr1365793f8f.18.1754639141347;
        Fri, 08 Aug 2025 00:45:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSQyZ6srhCQNBWcyjP7G0L44E2w5msI6TiW+KZd297AXzK4cJgdtoPU5jB4A7wacNHhMiWvg==
X-Received: by 2002:a05:6000:290c:b0:3b7:94a2:87e8 with SMTP id ffacd0b85a97d-3b900b4db70mr1365770f8f.18.1754639140894;
        Fri, 08 Aug 2025 00:45:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:900:2e1e:d717:2543:c4d6? (p200300d82f2509002e1ed7172543c4d6.dip0.t-ipconnect.de. [2003:d8:2f25:900:2e1e:d717:2543:c4d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3bf956sm30052328f8f.24.2025.08.08.00.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Aug 2025 00:45:40 -0700 (PDT)
Message-ID: <b0d257a4-a37d-41da-92f9-4d1c0a11c30c@redhat.com>
Date: Fri, 8 Aug 2025 09:45:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Ryan Roberts <ryan.roberts@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <158e6422-fc82-4d6c-a442-2ebe956a66da@redhat.com>
 <3fc75720-8da7-4f6c-bdce-1e1280b8e28f@lucifer.local>
 <6870e24f-dda6-421c-8df8-58294927b62d@arm.com>
 <ae01c6bc-019a-4263-8083-8ab073e72729@lucifer.local>
 <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <303b1764-6471-421f-b4c3-6a2585cee2ae@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g2fKovimzJAhX3NhJMAMICN7ehXtypzKHDAvdalRGuo_1754639141
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D382C1C000F
X-Stat-Signature: 817cx98kh68kx3xerjdp4dojpf9gwsa1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754639144-902667
X-HE-Meta: U2FsdGVkX18beXPIvu0HTQwrueWdXhVO2uu2OMUObxaDodRfKCuLCKE1M4wCF5iMiqLtuKt4D5oLJRGJNVHTK+VTGxlnEFT1mfwkAwd6DZ3QJj+1U5SgynjzgrXqzXb27Knh0FB4M+5cirJML0y+W8zWvwGT8PXXRZ4HUZxJAEyN70glHY5uZ2AaKlAT4RbO3dwZm3dMeU7NYQQ9qKgdaiUSZCQLOBh+8rOxvFU+6GknOYZ5LLNnLWxgCpb9koTT6adqsAr3CgzWIIAqFRBb8tOmMdYNcrgXO/uObzD5kK+hrmAeYEGQz6dQ+FWXnSKX10yxjZMvarCAf0tcY1IYtIJ69QmKOqmg7jaUM8der/7fC+HAzJA/A8VfnVbf/UxLpXczwcn1GeJJ1nyvaQSJpICNL+nRpjEfVjsFi6oHMJin4VRpheCjrgKVwDedqN4n2IDcf4LHAQ7qRE/lyyPl1i/5H8MLtMwdFRfnCCZ3NupwcJ1sK/A20WXwudE+vj/h02m3ouAnlRxwJmuGqlTF2pAfod9rchjRDwTFvBMaiOOD9BMJ+OPhUrkii69oX3iDjjLwTAMQMmWz7iZO/yt5fYjrDCVEjzuwmYAIMtJFndv6sjcEBKu/G4S6GvKOL1RPnBhyHyXS3bNF/Gu65HbnCXNmjfY8E8PrPyb0YUPwLQRvyXxFoSX2kdYSn9OAvxGIo0w7eI2XWkuwmu9wRdTXSSXKH7SAyVfJ845JH6PfEoXay28yE+fzmt8gj3aCZbU5H9r2yJhzB3boo5yz7njrKJreSONrfYHxWpZzlw3P46KFUAVFkwsJ8OX5qLFMYhYalQpD1WH8waWHgkDNkm6wY/npwGktlrPczhg6a8raSD0DHoLyDsEBQjdfnaUT8KJGA+2WZCgoJyJgo8SLWplftfTrOMVrCyiB0v2tu0Zu+BaH9tri0P9OMp71KdlcUJPBCcE0P93dHe87GtL8WW/
 M8NELZEZ
 IkThpc1uJi30lq8/2g1dS/7ebeedeYnRmItLHPolG4ohVWyJC62iZmuV+m9RG2P6qQQ2DTuYbGLP0nadZ714qSQYxOKxUXpLWH39vqxfucZkcB03QKLhjlmiHc3fF6GvHzA0WWdO5g3vaJ4iuVOPQKgCLmkqAJX3xHe8GzZFv6IV2jyRqMJynmRK1W7UvHJJyE4neg4YVgQk4BZUaIebxGgRRWDjnaV6m2J8KfdnTCQciMPynLwRU9NYkjyYkMXIIZj+2usgEHti0bP+up4FtopURgozYlAxAVioNgvchiMi8BrJKLsbYsrNiF52iLs7TH4pKaAbWcfG/miwAvaUDFAyvPC+POl5vooDV7MYrvK/Caj0I4Ssi2qgvMdYWHTDzi1VMh43IPfSGuP1NnuK7i/6Cy4EFIXQqYNsrxX4tvYqKUM5cV2WJ6HRQyrDTIwwjoo3EymcWqE7gs2FxzqcVAW0nuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> Not sure if some sleep has changed your mind on what "hint" means? I'm pretty
> sure David named this function, but for me the name makes sense. The arch is
> saying "I know that the pte batch is at least N ptes. It's up to you if you use
> that information. I'll still work correctly if you ignore it".

The last one is the important bit I think.

> 
> For me, your interpretation of 'the most number of PTEs that _might_ coalesce'
> would be a guess, not a hint.

I'm not a native speaker, so I'll let both of you figure that out. To me 
it makes sense as well ... but well, I was involved when creating that 
function. :)

> 
>>
>> I understand the con PTE bit is a 'hint' but as I recall you saying at
>> LSF/MM 'modern CPUs take the hint'. Which presumably is where this comes
>> from, but that's kinda deceptive.
>>
>> Anyway the reason I was emphatic here is on the basis that I believe I had
>> this explained to met his way, which obviously I or whoever it was (don't
>> recall) must have misunderstood. Or perhaps I hallucinated it... :)
> 
> FWIW, this is the documentation for the function:
> 
> /**
>   * pte_batch_hint - Number of pages that can be added to batch without scanning.
>   * @ptep: Page table pointer for the entry.
>   * @pte: Page table entry.
>   *
>   * Some architectures know that a set of contiguous ptes all map the same
>   * contiguous memory with the same permissions. In this case, it can provide a
>   * hint to aid pte batching without the core code needing to scan every pte.
>   *
>   * An architecture implementation may ignore the PTE accessed state. Further,
>   * the dirty state must apply atomically to all the PTEs described by the hint.
>   *
>   * May be overridden by the architecture, else pte_batch_hint is always 1.
>   */

It's actually ... surprisingly good after reading it again after at 
least a year.

> 
>>
>> I see that folio_pte_batch() can get _more_, is this on the basis of there
>> being adjacent, physically contiguous contPTE entries that can also be
>> batched up?

[...]

>>>>
>>>>>
>>>>>
>>>>> Not sure if that was discussed at some point before we went into the
>>>>> direction of using folios. But there really doesn't seem to be anything
>>>>> gained for other architectures here (as raised by Jann).
>>>>
>>>> Yup... I wonder about the other instances of this... ruh roh.
>>>
>>> IIRC prior to Dev's mprotect and mremap optimizations, I believe all sites
>>> already needed the folio. I haven't actually looked at how mprotect ended up,
>>> but maybe worth checking to see if it should protect with pte_batch_hint() too.
>>
>> mprotect didn't? I mean let's check.
> 
> I think for mprotect, the folio was only previously needed for the numa case. I
> have a vague memory that either Dev of I proposed wrapping folio_pte_batch() to
> only get the folio and call it if the next PTE had an adjacent PFN (or something
> like that). But it was deemed to complex. I might be misremembering... could
> have been an internal conversation. I'll chat with Dev about it and revisit.
> 

I am probably to blame here, because I think I rejected early to have 
arm64-only optimization, assuming other arch could benefit here as well 
with batching. But as it seems, batching in mremap() code really only 
serves the cont-pte managing code, and the folio_pte_batch() is really 
entirely unnecessary.

In case of mprotect(), I think really only (a) NUMA and (b) anon-folio 
write-upgrade required the folio. So it's a bit more tricky than 
mremap() here where ... the folio is entirely irrelevant.

One could detect the "anon write-upgrade possible" case early as well, 
and only lookup the folio in that case, otherwise use the straight pte hint.

So I think there is some room for further improvement.

-- 
Cheers,

David / dhildenb


