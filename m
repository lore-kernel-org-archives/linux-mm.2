Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7046ACCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A614E8E0010; Mon, 20 Oct 2025 05:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39998E0002; Mon, 20 Oct 2025 05:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927A68E0010; Mon, 20 Oct 2025 05:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5238E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:06:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25ACA1A07D2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:06:37 +0000 (UTC)
X-FDA: 84017912034.26.34C4CD9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4A9AA0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:06:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ej/aVTia";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760951194; a=rsa-sha256;
	cv=none;
	b=3n9HxTBUbYqNpajyq8EVWYDwcj/ATWZugK/pVhZ6b7XCRSBEPGjeJKATC5ToxGmbiG++EO
	LCS73/+98sePMpFCdH6Eje1SR6pfwQthGGZZAUXKVCG6zXjk32ynkDAg1LADxpYuK+47St
	rjAUdMDl9S6mooGR9Y1iCxp7JYBSI3k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ej/aVTia";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760951194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0F0AcL+GNjta110vk2zK9kFi7gPz9YyNmnqr5mUKiFY=;
	b=r3ChtzJuE1r1ZHGAuI/HnpXCo8/AzsJQBQDl7IjZ2Rw7JMpFHbE9LSzEEi8UIFlf0Q/u7d
	M/w1E4tMzUGGbCBAoW9HFAOu7Y8dOydMrf1dbCTJmyotWxoUYOOhozX0qenr+k2WH1F89S
	UN8ISYO38Vbe18ouwPRUxyigDBnk/OE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760951194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0F0AcL+GNjta110vk2zK9kFi7gPz9YyNmnqr5mUKiFY=;
	b=ej/aVTiaSrS0B5ak7bj0Fuqz4xDeZCfGLcm5T/OrUhzZfmFrkygRCWJfc9DvoiOLUThjQO
	bpp9KD7hBCB82KyT0EZ3XW/r6z8qVWaC/JdLg1j0MW80EG5pmz0kLjQMutoz8V1fB4ZeeG
	TUNX4I/B3izNsQyoyDJv83MWruiZ5o8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-ntyPXp7MP7eQYbEHCNf1tA-1; Mon, 20 Oct 2025 05:06:30 -0400
X-MC-Unique: ntyPXp7MP7eQYbEHCNf1tA-1
X-Mimecast-MFC-AGG-ID: ntyPXp7MP7eQYbEHCNf1tA_1760951189
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47111dc7c5dso22492995e9.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:06:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760951189; x=1761555989;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0F0AcL+GNjta110vk2zK9kFi7gPz9YyNmnqr5mUKiFY=;
        b=XdqLD5Cvyk+dj7SYKmhDZui3As6GJk6fgRxh7wecD5hptNY0RVwojuy8kG73h0QqYU
         AIfrH6H5chKHTM5DfamDiX4mr04XAQhNyez8Gz9k4GMhIkUttHkHikmhhfMCzqrMzIQu
         +0HYxYmh4ib7rq1wF6BAr5BZPIqjWotlnHIzIl90SwzkQnx2n/sRImKunD4Y128QGUmQ
         kZt364TIM6IGUYZchdBPULJvuQ8gP6cMXndpZKkdGfloTfHD9t1AmhJJUsHtWm/cK3ei
         k2gDXZf9oqLQw65aaCxovgYZYDrNDzuJWPfM5HycSCB9R5I1poljmehLuHvwVRmAY9Gj
         bUGg==
X-Forwarded-Encrypted: i=1; AJvYcCUDFgiHCoewcsa9nbKh4yyqgW9NNKVtJYhPmjvkg3dZdr6HFiqDiyNC5EamsgX0aIXNbR3a/CApDQ==@kvack.org
X-Gm-Message-State: AOJu0YxkDlR61wc+kR0AzQCJflu+j3/Sxr+/B7kcPz+HfJrLJJPhTAx0
	dpoX2W825Ayv17QaoQ/JVbmGsMz+SPzl4Kdsx+rFehJnECZrkxJHnaDuMCpy3kDqLOj8Wmhshtw
	U0fUalOyD0wSee8tx85wQkU8KG+3lSxyKUhVEyT+oKjJHedlZyL1d
X-Gm-Gg: ASbGncuyqKA58dEh3agBG0Od9QhCwA8ROtJKeu0aQHge3jBPrsmmftfbG/wPwHGraC1
	yH6nj5oqOqi7S/m2SRrlmMVOWpsUOCb+F2VWQltBH1e1DwZt88QRXvt17us3RCBrVj8jkH0xQwn
	0jyBdevPqLdg/BNQakWNDZgCMkWqE0bbphSAy7586Qi/CTxrf2Klvt0KvN7LbrED9CYUjL4OZE1
	CGt5uqkLItHrSvh2RdQ9VVBU28JgjZe/t7JSs6nyOt4DIB26qjMcrCoGPqWALQzgyC9Zx3UwJc8
	PYE1C5yfeB7dMBTKDyK1WdU9CcUhcOrKWbpXP/avqaPaEiLjTQaP7qbrk7ajt+BCNgj1kKzMIr5
	1aJ/Z+q2SYGCevHoyllIBvNLakANl/F4g+C/6r6jdm+mGXt5xDwpNJ6wSH7YuAuQp2v0abvjaHw
	ig0fPUKPpWO6kOW8BVD11qoGFDN78=
X-Received: by 2002:a05:600c:8284:b0:46e:5302:7751 with SMTP id 5b1f17b1804b1-4711726487cmr96469385e9.9.1760951189320;
        Mon, 20 Oct 2025 02:06:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF9h56vHiACaFnw/WwPIBJz7YodPPKQckecz4ERg6tBOQGl3/aEulaAlxiFGwpwSpHvjVLl6g==
X-Received: by 2002:a05:600c:8284:b0:46e:5302:7751 with SMTP id 5b1f17b1804b1-4711726487cmr96468965e9.9.1760951188891;
        Mon, 20 Oct 2025 02:06:28 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710e8037aasm113630195e9.2.2025.10.20.02.06.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:06:28 -0700 (PDT)
Message-ID: <553ccfd0-a931-4f2f-98d3-702e8fccff32@redhat.com>
Date: Mon, 20 Oct 2025 11:06:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jiri Slaby <jirislaby@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Al Viro <viro@ZenIV.linux.org.uk>
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org> <aPT0zNMZqt89cIXH@kernel.org>
 <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pr3QD5g3CGT4SvP_dbTQLj_ZWdAIcTD5lrxmFD-RyWE_1760951189
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: nkz7a6f4z3pymfcweorgcnf3wxdu9i8q
X-Rspamd-Queue-Id: A4A9AA0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1760951194-957326
X-HE-Meta: U2FsdGVkX1+JKy5M29/tV2Z4++619sa8JT2nJNG8OO6HI13vOKyYTmFxN7rs4ZhQRuqrUEhxX904ksSZAtQ7HMM08oxGOJyPMo+wFKOlWPNutDkR+KAfeBCcSaQrHkY7Wlze1jAMSfuceZlxwkKMI8Tir9Kd/w7TKaYHy5FRk4GTXAZP/m+K9F44N1EKaFkED0GjQ8I+CB61lZAbOWmzePAbdREbtuFmkutRC6I4V0bV93UAnEsrKRNLPf4sITfTDyh9YZ3wwDumcFwsSacDUiGT4JwWYzYShQk/CacyP0w7vqoCTYRYXRM7q5mcCUyzZ4Q+t6vfZsJkw26MHELQqOR/tMsAK2j6zQnkTnor2W4uswZ7qx59Ja0x6AEghIkL9NHhhUbMIYajAjMVPqu6Io12KzyIGI7ibBZxDaQ+I0owXa+TBAb0EJf14o5N/QDc074D0/9FIVs+SyckyqTEVulaw1eFk2SDUaS43qBke9aiklNE1rNeN21RIZO4SukzbjIfo0824a82vZ3MN+5UIXNVH/6YjwF19+tzPeWu05wSlsKbsUeo7vVH+r9E9yibJkYqnO3RquHoTKA1PDdUR16xC8ijzYChItBblu7Bja3BpWQnXJ2pSSYpFCpRlFW9GX4km+iBbuEEC+7RT0MgjaoBVUhoNxsRPuuMFc1tOEx9MGSyqfArwuHkUlzN16w7UJqS4jsf8JG1GbEbrBFHSneAYuNx0WxeXhIUzMLyqfSYDxQIWwoXn9HyjA7XK9+uHHj84VISXM5b7jHDLsLAVbtyAXynzhFUoSAW8HY/zTZy+HF+FCCWGq6jICp8SLXWzIb3BLJkQWQr6xOGJzwu0FPFwK1ElD+pRQX/wbmLAvxcht9m8vDdQ/v9LIxmLKtl5ONC/bTiFnzLQ7qoWqAkWx8KH7I/Ab474+CLZgDlHTO7Ec43Bs6tWRDCDH33uDhE1qGV0S5de052ROFXfSa
 CK8VwVfS
 EzZtUxfOeaj1VRD/LUuqB3pKUYT9yvuiCy7W+FPI6K5TePUHB/Bz4CZu/EphdMrzEEbimtxNkC+xJQjB2MjBoFxTu+4AHJFZ7XSLLqJAawkbtBPBYNR14jHgYr06zkM9L6yMI14BmQU/7LVjr+AmEe7WKoWHG3RRev32RmkwEo8cp+LSL9h/YbBDXrdNs7sCTKszmZovHbe+4nXyS7GXfA9OF+MMCpyr46aObhS5L6smuzkQuyS5FrfdIMlUMyhb09ddFqzUe4caQLfXQtyA3mAO1DPZmkPy7NImcOrinG2kOJWWnGd0hYGDipPmb316vxQ73ixRNVgxgVOalKBwiJP0RG0HoRh2jtYPBF/WtKGHLYYyFe2DX/HFB0N82TS1oM4cCtyOzkSRxM1UxhYCxUwSf48VtWNuVC45o1pxa1dAkNAqbfcgmUg82lQdGZPchrmht9Y+jd5aSK1Wd8idj2gbK9w3AbJOOWUqfJvzj12Uvb03xI7aj+PIV0fdRXjb/HId/080mUBWLk/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 10:54, Vlastimil Babka wrote:
> On 10/19/25 16:25, Mike Rapoport wrote:
>> On Sun, Oct 19, 2025 at 01:30:47AM +0100, Matthew Wilcox wrote:
>>> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
>>>> Vast majority of allocations that use get_free_pages() and its derivatives
>>>> cast the returned unsigned long to a pointer and then cast it back to
>>>> unsigned long when freeing the memory.
>>>>
>>>> These castings are useless and only obfuscate the code.
>>>>
>>>> Make get_free_pages() and friends return 'void *' and free_pages() accept
>>>> 'void *' as its address parameter.
>>>
>>> No.  Linus has rejected this change before.  I can't find it now, it was
>>> a long time ago.
> 
> Here's a lore link
> https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/

You beat me to it :)

[...]

>>> Most of them shouldn't be using get_free_pages() at all, they should be
>>> using kmalloc().
> 
> Changing to kmalloc() would have to be careful, what if the callers rely on
> doing e.g. get_page() later. It would however be useful to dintinguish "I
> want a page-sized buffer" (note that it's guaranteed to be aligned by
> kmalloc() these days, which it wasn't in 2015) from "I really want a page".
> But many of the latter cases maybe want a struct page then and are using
> alloc_pages()?

I agree. I guess whoever wants a "struct page" (e.g., to use a different 
memdesc later) should be asking for a page in the first place, not 
something that will be slab-typed right from the start.

>> Don't know if most but some of them could. Still, we'd have a bunch of
>> get_free_pages() users with needless castings.
>> And converting callers that should use kmalloc() is a long and tedious
>> process, while here we get an API improvement in a single automated change.
> Maybe a more feasible way would be to rename to something more coherent,
> while keeping the old interfaces alive for a while for easier backporting.
> because __get_free_pages() / free_pages() is not really great naming.
> If possible it would be nice to also make __GFP_COMP implicit in the new API.

Agreed to all. But we will have to be a bit careful with __GFP_COMP.

-- 
Cheers

David / dhildenb


