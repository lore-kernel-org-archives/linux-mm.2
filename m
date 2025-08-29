Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A0C7CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FCEA6B0006; Fri, 29 Aug 2025 04:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD206B000D; Fri, 29 Aug 2025 04:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C3B6B000C; Fri, 29 Aug 2025 04:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3828E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:56:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E34BA44B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:56:17 +0000 (UTC)
X-FDA: 83829188394.09.6C38037
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 49ABD20012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:56:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CcpGpJBi;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756457775; a=rsa-sha256;
	cv=none;
	b=FjumOjKlb2k3HkDGn3ZgMFk1dlcbGAhqxm/o+y8RQh8V276EiD0LMqxMuc7P3G4y4G5eBo
	AHucnCo4C7dh9bRGG+MB7RqutQ3CXfTDwztVLurczFvzuXhikqI7RZqzqGDH2k5u3dPofJ
	OELSfWXF3izcu4XxeCJmnLSWyK0Dpzk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CcpGpJBi;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756457775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUg/m1Qobd5H9EiE8Vi7zYDpEBbxK5FBxUfpxpnhqeg=;
	b=bTR4KzYI3J4Dp4ur6GbRMgM0b/k1l+srLhijQTkKsWCYZC+ex/CZA978W++NaSOhLvns1q
	t95dLV2oxyesk9xKhfJbWmZUjmezkSleuFmJ2kWq4IkRqEFud9FQe5xmFfPvRLP/XLkMIM
	FUAnTqc6vrVZUMXKenIRwKkaNjAW7No=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756457774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sUg/m1Qobd5H9EiE8Vi7zYDpEBbxK5FBxUfpxpnhqeg=;
	b=CcpGpJBipc0uPjBw3Qxt5CyIjxRCcz5DWgtqhjvVxpV4c/pkyDu0pEu4SWB+N5EB1gqAxm
	CBN73EdANXRPzAEjP/3AineOylZ669Vm9anpkYXUkMbq9ox1rAGedC4J8R7ojtoXxvHRrE
	Qiqq+Gby6UmtwsKv6a0NkDZ8zwChmyg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-uuy5UgfrN86ojIQO8TK2cQ-1; Fri, 29 Aug 2025 04:56:12 -0400
X-MC-Unique: uuy5UgfrN86ojIQO8TK2cQ-1
X-Mimecast-MFC-AGG-ID: uuy5UgfrN86ojIQO8TK2cQ_1756457771
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3d1114879a4so89513f8f.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 01:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756457771; x=1757062571;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sUg/m1Qobd5H9EiE8Vi7zYDpEBbxK5FBxUfpxpnhqeg=;
        b=T5Pcpu0aQr0V+zZd5o2fXE1SlWfoAWOEEZRJBdIwAiX7zzTVrh/H1eu1USrqgmQK6R
         jrybq46qael0QvYKVsJaa6cmM2ECBYw5flAsJywMc2KA2HzZcu1Bj6SnUTlarrL7CCsp
         1M3/4bYqQ1P1A4/kcTnHCASVQhiP8R8Ze+jxyVSdk+75xnQi9oZPAnlqsiUo67nGeuNs
         h8jdrvd6IEy3cmGY0OiOZNC2FfHWjnzIfe9p0Be9X6ZmX+Q9ucAq5t5EteNuBRrMDXZ+
         JIMXG2YY9JFBXJWJgTe0Jm4UEbJOgtLY04a8CK4z7X6gAUdnHUFRerPozs78uXDgDyTP
         xUUg==
X-Forwarded-Encrypted: i=1; AJvYcCVLnUCXIsBEFf+1+3JSZntUmvNCq7IctSlFM5bixRQu2SOv514879+JnUixU7LVZmGxksV4JfCGEw==@kvack.org
X-Gm-Message-State: AOJu0Yy/AcHKGo1cY8gN5qmA2L3tk6g+uTCTdexaZBc3+GYwBGqkBx/j
	qsMha16op7PWv92IbSjTA7XQ4rSOfcCj1ItlVt7L44QYiaNEFDcycj+5cseatHXVeoUbwxIIxUp
	7u35Ns9nHUDHB+djBtgbVxI9ciOYv7MwXXkgfsag6O/JlrysTil8a
X-Gm-Gg: ASbGncuDqD9ind5NBh8LOe6c6ck4FPAP6Z0trbY+EwgeB5N3WgNqCPnhVqqt17KXcfQ
	/N4BOtvFBUgQwIJiNJ7iIwk83PydsROu3wiPKmvNkq7Jn7AL0SRsShFf/j64a4/3wh/70BpcsHv
	wTB9m1Bv6GIUISfaiPDoRXSmlppvlw3Soc9jnyLaz39e1xRWYhDEnKlEzuT22lPXhq9073JcdMs
	9JfEz42RBn5zpLde+KJGRRVHaoPl7yKP2ONJDneW7UCNfecWstDW1WoHeepJ6l87L3iyOsUDM2T
	5fkdOSbwjTin26aD/tAfmajRQa4tAeDlXaeRdpqU4M+7I352Auf6S4rbWiXelKo/+L1udtuZmfz
	fvr4cWXKbs3FxwK0lSstMeVoOz7w4wCXSk/WnSCL13/H0BowkGIvJVfVMymUeQhNu
X-Received: by 2002:a05:6000:26d2:b0:3d0:d6e6:5d76 with SMTP id ffacd0b85a97d-3d0d6e664b1mr776254f8f.55.1756457771257;
        Fri, 29 Aug 2025 01:56:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKSfhh3dzFG1NHqZK8Z2zwBhi/GiFCA2R8jwRwnPT18iorgM/4FbKEfeknQwqmNPOImPBvwg==
X-Received: by 2002:a05:6000:26d2:b0:3d0:d6e6:5d76 with SMTP id ffacd0b85a97d-3d0d6e664b1mr776218f8f.55.1756457770796;
        Fri, 29 Aug 2025 01:56:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d12c90a01bsm61847f8f.31.2025.08.29.01.56.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 01:56:10 -0700 (PDT)
Message-ID: <eaba0af3-c531-47f4-bc4e-714a25dfc686@redhat.com>
Date: Fri, 29 Aug 2025 10:56:09 +0200
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
 <56819052-d3f5-4209-824d-5cfbf49ff6e9@redhat.com>
 <d8e8c6d9-2b58-a1e8-d3cb-3f578f3f5889@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <d8e8c6d9-2b58-a1e8-d3cb-3f578f3f5889@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -z4cYEumerFO5htiG2211HovM2AGlPkKqOUDInoZdX8_1756457771
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49ABD20012
X-Stat-Signature: yfggxbspoud96iaccbz6zpbemhd4o1w5
X-Rspam-User: 
X-HE-Tag: 1756457775-109853
X-HE-Meta: U2FsdGVkX1+I9+w7c9l/94yCAco3rnY+RWHkVpOlwWWjVYtBF2qdMl7Ry72w4+cfdEt7OxEK6X44t+vOn9Xq7Z62s/2eUbMrz5fRns5hgCgsvVnx3mINjKqWqfKPebzuXk1wsUx7wr6W2deIlz5gfqVjEU64Qf1C9DcuAVCgtGajuE1uy6zWww8kqQSKPHUyv7uioL5veS5z0+DQU8OOZYL6th1OkySrrdfRoeyUUJzCCGiD/zVM4uSnxdjLYx8h2h92wUhFJYBF9IbpEoshz1gUbxyUIQs3vVvptfNBCQc0yYXOxHms+ZRxqzPPT7see8GQ1o6sz4i3zTLAVr9iY2d3dAX8SEHXUtebCGolq2vLPm8USG6r6buZMK0/QGVax4uuRy4PRVR4NN8chd7OtB2xMwJqnrodapqTEQjf7F78yRtfgShWfrXw0tRE1IlHmPWoVg9sI+Mz57O/96rxPFXIgNVP2MtBhXwnJMXMZSilM4BoQ5ugpC/uivicIzOrGNyqpF1pQxZPldzThy+5e/1oFrn+Fs+YD+YOiNTJFzO/Qz6K06oPkILXyi1D6f4so5dt3sZvHL4tc8/iYsuA1pHzHHxmWmOfOldPFEPwh0yyANjRjzt94XRuhOE411z7GIeHRBohIPY8fnoKFQShTK+LYBMq9XYRGV5h9Vx2jZyiKRs8k7g06YkGKah0QUqrBS5EqteCf70ptwLAZrKL/juIeDnAGb+RMArh0r+sUfkMHAIrHXXycva29EdD/kLXHwfXxaF5+StEACN/JpZ0BY5e2mveZTEza+OG8ddI5Z92/vBwpFeCUDWckh/avth9NNa0bFIYC9k8Z5dj5zBWaYjxS6IWa2XR+o0tfn+hAoq+5yGEdtFAMynGxbU5W0CzMZV5B4qDaBLiOg0V04N2+P0ESNPlXpWHJc7s8uE7PleKOf4c5+QLe4/0cEvmaE0XNTxuUVT8Bkxffe4+V2u
 kxahNL9B
 7lu1t6vSgOHbPPvsu8YjXt2NzwVRIAVeMTsDylRohTmHuXWKTHv4Ers1PXF30z0dP9VFqQJfK2UM9Jw9ZmLlMdRQPRAmtdVetDBZ/DvJddxr+tuSvnZo4/GJ3roFuGTksjFOj0LuEaVXFMPEsPKeOczpPttuRrhNYZrWiF9FSGLacymFMWKY+dAEiG1livLv+k7WhpS9i1vUV0tNth/oMepc3JbPvqyhofyB4VEFbcQbYkM0yv24ts9tvWmGdrJfRAzKbPie+ngPY8+p8h1J40zkpB6vbIVcd6sPeY0qlPd1p2s1c4Ib+Rz2N3r5VfO//HSntjwQS4yNC6AmABXSj8cTs1oeDG2eggThNCxCWWsB2WQaRmAPF4Mb9YL4rZ72AgavWSWuPuO/lhzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>>> :/ If so, I really rally
>>>> hope that we can find another way and not go back to that old handling.
>>>
>>> For what reason?  It sounded like a nice "invariant" to keep in mind,
>>> but it's a limitation, and  what purpose was it actually serving?
>>
>> I liked the semantics that if !lru, there could be at most one reference from
>> the LRU caches.
>>
>> That is, if there are two references, you don't even have to bother with
>> flushing anything.
> 
> If that assumption is being put into practice anywhere (not that I know of),
> then it's currently wrong and needs currecting.

We do make use of that property in wp_can_reuse_anon_folio(), to just 
fail fast -- that's what Linus argued for back then: give up fast and 
just create a page copy.

Essentially hidden in the "folio_ref_count(folio) > 3" and 
"!folio_test_lru(folio)" code path. mlock caches would not be considered 
right now.

Now, in contrast to page pinning, that code is pure best effort, and we 
don't care that much about always getting it right (e.g., no remote 
draining, no draining if there is a clear indication that it might help).

> 
> It would be nice and simple if it worked, but I couldn't get it to work
> with mlock/munlock batching, so it seemed better to give up on the
> pretence.

Thanks for trying!

[...]

>> Regarding the issue at hand:
>>
>> There were discussions at LSF/MM about also putting (some) large folios onto
>> the LRU caches.
>>
>> In that context, GUP could take multiple references on the same folio, and a
>> simple folio_expected_ref_count() + 1 would no longer do the trick.
>>
>> I thought about this today, and likely it could be handled by scanning the
>> page array for same folios etc. A bit nasty when wanting to cover all corner
>> cases (folio pages must not be consecutive in the passed array ) ...
> 
> I haven't thought about that problem at all (except when working around
> a similar issue in mm/mempolicy.c's folio queueing), but can sympathize.
> 
> It had irritated me to notice how the flush-immediately code for 512-page
> folios now extends to 2-page folios: you've enlightened me why that remains
> so, I hadn't thought of the implications.  Perhaps even more reason to
> allow for multiple references on the pagevecs/batches?

Not sure TBH if multiple references from pagevecs/batches really play a 
role here :)

> 
>>
>> Apart from that issue, I liked the idea of a "single entry in the cache" for
>> other reasons: it gives clear semantics. We cannot end up in a scenario where
>> someone performs OPX and later someone OPY on a folio, but the way the lru
>> caches are flushed we might end up processing OPX after OPY -- this should be
>> able to happen in case of local or remote flushes IIRC.
> 
> It's been that way for many years, that's how they are.

Yeah, but I enjoyed clearer semantics: like a folio_activate() actually 
resulting in an activation, not getting swallowed by a 
folio_deactivate() stranded somewhere.

>>
>> Maybe we just want to limit it to !folio_test_large(), because flushing there
>> really doesn't give us any chance in succeeding right now? Not sure if it
>> makes any difference in practice, though, we'll likely be flushing remote LRU
>> caches now more frequently either way.
> 
> Ah, good idea. with or without my changes.  Maybe material for a separate
> patch.  I wonder if we would do better to add a folio_is_batchable() and
> use that consistently in all of the places which are refusing to batch
> when folio_test_large() - I wonder if a !folio_test_large() here will
> get missed if there's a change there.

You read my mind.

-- 
Cheers

David / dhildenb


