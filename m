Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52805CA0FF6
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 20:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CA46B0023; Thu, 28 Aug 2025 16:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7043D6B0026; Thu, 28 Aug 2025 16:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A0E6B0027; Thu, 28 Aug 2025 16:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA3D6B0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 16:45:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C73AAB90E7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:45:43 +0000 (UTC)
X-FDA: 83827347366.08.D3DAA8B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B1B420004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:45:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xu/iED5p";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756413941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwZlhU01+EV1yk20M/2DYD/S7JKHDAZ7Ux0lm8SsNeM=;
	b=SebOcYil1nkMizc4fR7Yxt+oUg1f0QQsecKH8P7TcFFooFkdgwijbf71sA+DQ7ttINfsLv
	OEwh+gNpm3JRQO0+bSlpfhObzHoARX4/g9VoXDdAbh1npRX0caHN/pZKshQk+mePN5+1Sx
	1/d/RMOfTcjUD4QgkK9iCZq/zoh0iog=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xu/iED5p";
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756413941; a=rsa-sha256;
	cv=none;
	b=1dupLai9oEpRioL9C51t690+AWjknl8tcHz6p61G12uc2aw4oGb+i0lNnG6ecjorSKoxKF
	//Vr9i8UTTNJvHD0/budry3BOJzpe5u20FBizXTwrUY4+8zEl6B6sOEnk86AOcp1oVhUK0
	XPO4fuFpSfsq8ZpVn+Edeyi4j/jjrbo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756413940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xwZlhU01+EV1yk20M/2DYD/S7JKHDAZ7Ux0lm8SsNeM=;
	b=Xu/iED5pnQB9bWRb83MojXSOt6nGynMrJS36t4a4YVDZEoiecnPUICF5POpa3oEnxLqdLK
	N25TPi+hMVVjsxH69flmj4rHCU2MlDss7C/X/C+7KCUv+d2+ZF0Cwd7+r1kM9BUBhu73er
	e5uNvkc22KgeKxPPM8vU6zwsphkuVZw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-XGju52JZMNuClgWzIa4ijA-1; Thu, 28 Aug 2025 16:38:54 -0400
X-MC-Unique: XGju52JZMNuClgWzIa4ijA-1
X-Mimecast-MFC-AGG-ID: XGju52JZMNuClgWzIa4ijA_1756413533
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b7f0d1449so467595e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:38:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756413533; x=1757018333;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xwZlhU01+EV1yk20M/2DYD/S7JKHDAZ7Ux0lm8SsNeM=;
        b=Hk5g4Vsv6LjYYGAOYz6/gGceDcmk8BLb/aApRDbw8PxvGuiUHFrSUd1S00gqcbtLnX
         ggfIw3X7xGGp6KB13BO40ijYuo4tR+iDSmv1nvo11QzB99EGTdm+I4NfJsZu6TmYWZna
         fq6OzcaRBet5FevKhAWXBGESKT7YN4ojfVxstG14fA2JjNZ1I0LUym+xngXo7+N1ngBG
         YsjAoQff9xFX9G0QpvFWlMw6/qXjBG7uQNkD7GkWQOL2noAVayj4N16FcD/snqEjbQAV
         GOWmFJ4KvT2ESf06kSpWPowTJ8gSI8wbaXP+Je8XVr0XxHzu6Fod9+golfZYQDaW0Bn8
         2UTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3GzyhLpcpDfQr++fvF0VN2ImsnVMzyquod82EqNbZISRN+IPlIo6u4CZPohR+U+K0cPUP6g48Iw==@kvack.org
X-Gm-Message-State: AOJu0YygZsbS4dxSWyeRqkAQCEJSMg8nJ0YK23Uw6QOyEmMxb+NQ4xFW
	hwcQDcjOUgn4fwppaiXKlc1ca0fJvVScuPuBAaIGLA+qYl5WwB/fJxbd6Ppo9RDpZBVcaY6XNTZ
	vryLaa5wfGK9evx8lk96qT73MFySTOb/GVIKSugOpp6IhGfclLEOd
X-Gm-Gg: ASbGncuRR1abWjNbl00yzh0bJYVlJvWakVHt6gCJQ1pO03Fva7nM8K7mQcpftYHBdAm
	5L7QrKKIJ/2vqqMldY6qp9WM8i1sUQ6LA72EgYzohoE1YVTVR+INvoLbv74nuTVtOaVpwI89CIW
	pcYex/0CTDJgy5kLJ6+VSkhx7pFeWYiIoXT84Dk2w+/VKxvxP/g2Q3EOH2AS2SDd56HxemcXxzq
	EeL/FB/UBDKpvl9WBpGvcvn9fk3pGCFK3RuHdCYxNK2WKzVeauKckepQqUVJi4h5EI4BIZWlZ9j
	aK9iMJgczbr6hLNHvqidnpgtvbxmVfnBzw42KELn7TFqFKHMr/00pbKPKcBIqlV5QBpJuz8lH5z
	BZaG3P66uyIaB94ctzooo14GFBBadbtBI2iTwiRcPfpnkaY5WiDJ71oAPj6QVNVHbCjg=
X-Received: by 2002:a05:600c:1caa:b0:458:bbed:a806 with SMTP id 5b1f17b1804b1-45b6503919emr91829045e9.22.1756413532909;
        Thu, 28 Aug 2025 13:38:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIljhHhdTBn7DEps/7ORUXkYgebAkXS/5XDYdHFvBoLjnLL6phiG8TBqHSGcnisU+IkK5BMQ==
X-Received: by 2002:a05:600c:1caa:b0:458:bbed:a806 with SMTP id 5b1f17b1804b1-45b6503919emr91828905e9.22.1756413532445;
        Thu, 28 Aug 2025 13:38:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276c788esm596872f8f.17.2025.08.28.13.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 13:38:51 -0700 (PDT)
Message-ID: <56819052-d3f5-4209-824d-5cfbf49ff6e9@redhat.com>
Date: Thu, 28 Aug 2025 22:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
To: Hugh Dickins <hughd@google.com>
Cc: Will Deacon <will@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Keir Fraser <keirf@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Frederick Mayle <fmayle@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>,
 Ge Yang <yangge1116@126.com>
References: <20250815101858.24352-1-will@kernel.org>
 <c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com>
 <aKMrOHYbTtDhOP6O@willie-the-truck> <aKM5S4oQYmRIbT3j@willie-the-truck>
 <9e7d31b9-1eaf-4599-ce42-b80c0c4bb25d@google.com>
 <8376d8a3-cc36-ae70-0fa8-427e9ca17b9b@google.com>
 <a0d1d889-c711-494b-a85a-33cbde4688ba@redhat.com>
 <3194a67b-194c-151d-a961-08c0d0f24d9b@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3194a67b-194c-151d-a961-08c0d0f24d9b@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lHFXoi8B3VelGMMdGV9IkuOlDMFmXG3PHTUhcr0XAkk_1756413533
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4B1B420004
X-Rspam-User: 
X-Stat-Signature: s81hfg3z7o86jjrgtnr3f1yjabhuwdme
X-Rspamd-Server: rspam09
X-HE-Tag: 1756413941-663945
X-HE-Meta: U2FsdGVkX19RPdBLxojelGxbXfQn2y6++7jjgOH4RkqpOH3d9QpMbXKIIc5NHWbKBJV6cP/d95eSs+6MkFOlgkYwu2wV/AATRbDf5W7DO06JB/qQBFLlSOfWdUD4Yp71f6AIv5YOIa6iKUVMsY60IHsdv517pphDRXPG5/W4kTXvklCakdzMsaCSFmMJ3C9G6QtT+iKn1NeLzMWL3fx0zvovXblIQDejE9VHeslcuUubveCokL7fUt4Qjf5x1kpJ7ellKpu3YNxz4kj1OUOwHI9SMxA4KV+HcFScrEBeaQ5KpwrzC2qA8xmevfjCMkGnQ/p6hIOVzrl5NH+JfVP1kSqIN/OzhMYXt352ETu7mXLOI5XqVv3ie3BfxdLwns26/0yW6/QpvGRY26oXNTHoLGmeQfILEYBJouitm44rJ9VWl7t0R+N0fJ8WyPwJhOBDmPYekkrS3LNmAsSfdGsJFxtSejh+BYokLREDRCRrTwG3NMhkK950ZWNXyP+ndTlGVjQBDkQXXOWY/GX0shshZ3pEsj5+klrL1nKrELNYnn3XKxaeKuN+814iH6uuTVvmU1o7voSf/cpMnnzkUW00jPE/rSFGUWtFw1YDWVeuKLNPYSykbjy6E6+Vz799IaUtJSQULOMbhY/ZhCggMk8+AyQ0ukEBH4T9e2eaQdOGbe4AQWiNO8TFNwSebAA9YpWYQIZhFx27D1SbOEOQ+gev3G/Chy51ktyO6A8TsnzHndCcjoZnbobJKcR8N2f1iRLZIeMF3WyFOz1pFLesbWPYTG2RMi9xpWeVGFNHDSopzIqkve+gPTpAvpKcARx8QHZ48WurygsZFJzQ9sH+Mc7KiQFyZK4VTp2vd4rRBd9h9xZX44WkCmakwTk6dN1SJI5AFzlFg+yML1adB/mqzveQETunz8YI7JGbsW/uK/je1iKyzbSnTe6GUCUJMWHqo1r+OBvQ/2JyLfObrPluVCU
 1S/RrDDF
 Ko7b75tXpypNwO7Y030FVyQD4+LD4dKWN4cf0mjYbCJu8bZ540Nipi5arNpdTVWoPqv48v9VaWcAJYC8aBy54alEEopRw+g+/MBa9NmUUdTVjGare9rFKGUm5HkDn8zciKWF5Gv428XN/jlBYJyztBdpvs1OPY2IrWXOj73+a2avc28DECO7AM5KVgSqyCiadk/x/lz63aGmsz4/JHBqyYojrDorlb5RDwMZV0Ecl6dGCOVV8ifed9BU/YY+1DgfglODSir7fjIjN/e8hljJHhiLdqypJGUXBKqL0bpSuQ06fpCMIj5EAiVwbMhwWtearEDgE8zKuRJbzj8jp5yLsVf27nwKiArA6HMTKPuRGrbc5SMfUrr5hBkOzv+B7ZzFh4c/M6E68NnG24ek=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 18:12, Hugh Dickins wrote:
> On Thu, 28 Aug 2025, David Hildenbrand wrote:
>> On 28.08.25 10:47, Hugh Dickins wrote:
> ...
>>> It took several days in search of the least bad compromise, but
>>> in the end I concluded the opposite of what we'd intended above.
>>>
>>> There is a fundamental incompatibility between my 5.18 2fbb0c10d1e8
>>> ("mm/munlock: mlock_page() munlock_page() batch by pagevec")
>>> and Ge Yang's 6.11 33dfe9204f29
>>> ("mm/gup: clear the LRU flag of a page before adding to LRU batch").
>>>
>>> It turns out that the mm/swap.c folio batches (apart from lru_add)
>>> are all for best-effort, doesn't matter if it's missed, operations;
>>> whereas mlock and munlock are more serious.  Probably mlock could
>>> be (not very satisfactorily) converted, but then munlock?  Because
>>> of failed folio_test_clear_lru()s, it would be far too likely to
>>> err on either side, munlocking too soon or too late.
>>>
>>> I've concluded that one or the other has to go.  If we're having
>>> a beauty contest, there's no doubt that 33dfe9204f29 is much nicer
>>> than 2fbb0c10d1e8 (which is itself far from perfect).  But functionally,
>>> I'm afraid that removing the mlock/munlock batching will show up as a
>>> perceptible regression in realistic workloadsg; and on consideration,
>>> I've found no real justification for the LRU flag clearing change.
>>
>> Just to understand what you are saying: are you saying that we will go back to
>> having a folio being part of multiple LRU caches?
> 
> Yes.  Well, if you count the mlock/munlock batches in as "LRU caches",
> then that has been so all along.

Yes ...

> 
>> :/ If so, I really rally
>> hope that we can find another way and not go back to that old handling.
> 
> For what reason?  It sounded like a nice "invariant" to keep in mind,
> but it's a limitation, and  what purpose was it actually serving?

I liked the semantics that if !lru, there could be at most one reference 
from the LRU caches.

That is, if there are two references, you don't even have to bother with 
flushing anything.

> 
> If it's the "spare room in struct page to keep the address of that one
> batch entry ... efficiently extract ..." that I was dreaming of: that
> has to be a future thing, when perhaps memdescs will allow an extensible
> structure to be attached, and extending it for an mlocked folio (to hold
> the mlock_count instead of squeezing it into lru.prev) would not need
> mlock/munlock batching at all (I guess: far from uppermost in my mind!),
> and including a field for "efficiently extract" from LRU batch would be
> nice.
> 
> But, memdescs or not, there will always be pressure to keep the common
> struct as small as possible, so I don't know if we would actually go
> that way.
> 
> But I suspect that was not your reason at all: please illuminate.

You are very right :)

Regarding the issue at hand:

There were discussions at LSF/MM about also putting (some) large folios 
onto the LRU caches.

In that context, GUP could take multiple references on the same folio, 
and a simple folio_expected_ref_count() + 1 would no longer do the trick.

I thought about this today, and likely it could be handled by scanning 
the page array for same folios etc. A bit nasty when wanting to cover 
all corner cases (folio pages must not be consecutive in the passed 
array ) ...


Apart from that issue, I liked the idea of a "single entry in the cache" 
for other reasons: it gives clear semantics. We cannot end up in a 
scenario where someone performs OPX and later someone OPY on a folio, 
but the way the lru caches are flushed we might end up processing OPX 
after OPY -- this should be able to happen in case of local or remote 
flushes IIRC.

Anyhow, I quickly scanned your code. The folio_expected_ref_count() 
should solve the issue for now. It's quite unfortunate that any raised 
reference will make us now flush all remote LRU caches.

Maybe we just want to limit it to !folio_test_large(), because flushing 
there really doesn't give us any chance in succeeding right now? Not 
sure if it makes any difference in practice, though, we'll likely be 
flushing remote LRU caches now more frequently either way.

-- 
Cheers

David / dhildenb


