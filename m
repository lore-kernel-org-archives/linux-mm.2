Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69311CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 10:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD3258E0007; Tue,  2 Sep 2025 06:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAAF58E0001; Tue,  2 Sep 2025 06:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A238E0007; Tue,  2 Sep 2025 06:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86F238E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:21:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E4461A0BE2
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:21:49 +0000 (UTC)
X-FDA: 83843919138.14.F865072
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id F1C4840003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:21:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LS92d6nz;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756808506; a=rsa-sha256;
	cv=none;
	b=qWNrZKQcSPazirXI2aTsddoi0KIToxgehuCFYimlRmHa9YQpfWxgQzH7wzqNoaesvp/npa
	wGTlERyviNBOgOoM+IRHmDdDhbw7J7TZ2D1uWSk5hhGCaoY2IDO60nSX993wgwftdr404V
	hREJra/MTe9EmgV2KBA6wtbzh2bcI0Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LS92d6nz;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756808506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGigtSodY2ufJETuQQ6JObO7ddBHNbjmaKCUTXaU8Xg=;
	b=AyKaWkWzdLmeqzGjTFy0XtOa+xUPl3KSlXynNsGyYKfOtpim1bWQTZSGroooH6vFYr0lgb
	q27NCXJ+haRca30671MzyjDX2Tpv/wlGRNtRqE/oQpOMWBVTweZAl/Y18tlBKU4dc84P3l
	xzf/iq+AY2H2x3tGxeu1tUB3/xWVdp0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756808505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MGigtSodY2ufJETuQQ6JObO7ddBHNbjmaKCUTXaU8Xg=;
	b=LS92d6nzwc5u1dyd0Gy8l5AVMbfoaCXX8oe+XmfcDWxZcnEQOHp6i0zmPsoubsT8HmR869
	sJNaI9DHTi1jARAZBPJJ2NJ0hpFruIVe5JxJZdeEi8h/mkdTh2PwU5fKrTxiTWAJzqBAqM
	+fF4D23aMDZ97hpt25OEi6B0ncmSvb4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-S5rhdf9NMJq74kXF134gaQ-1; Tue, 02 Sep 2025 06:21:42 -0400
X-MC-Unique: S5rhdf9NMJq74kXF134gaQ-1
X-Mimecast-MFC-AGG-ID: S5rhdf9NMJq74kXF134gaQ_1756808501
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ce059e3b83so35423f8f.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 03:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756808501; x=1757413301;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MGigtSodY2ufJETuQQ6JObO7ddBHNbjmaKCUTXaU8Xg=;
        b=bvQN4O6LwHqob0j5PzFcg9dBvE6ttql6sxflNkHFvrlzmn7rHKVNXZelyEamDvZgsa
         9giNnh1BVx+wLMX+2o1O1AwtOOAIC5yRX8kPv8JMbfIY7fHy8aei4ImJjdTk16fObrwv
         vUYCuN7uAayoub5BNx9nlndrQbkZu2ej3mPOxiLrVGHbGrHtvd6VE8uCk4byOkSOGNSF
         ICdMqH36kJrIgoTxC2hlNgmqmrXCjN96JiGtd+l9I/PdOJjkC9ESM7TqTPydNLB+zgPk
         Y5mmlkTW6wLJyn6S5z0YCTiUPJLB9eUbL5Xq4Vk2yJkoWMb5onbeDtfTCNjogzHiCYh+
         d0pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFNQEetVApExvdUzTPCq3UpzEAXavEqg9BRKAWbyAC3IQxp7Mw8abAmL44tZugSlzD52I2KOcMQQ==@kvack.org
X-Gm-Message-State: AOJu0YxBa2KXRhqv2KxvxSLOcUvbKK29BWJEGtA1naLicMae7Ga76YI2
	HfyRvp4ADyVBKuHm1NltmUDKwhqlaXkyjHJrkWjv8MPIXkhIDuwaXbdggnvLyHwvZWdHo4ZltP4
	nyaLM/BlUwFg8shrDhGo51ZR8uswBGonBvfExLMlvzMmL+bUsG3q/
X-Gm-Gg: ASbGncsZUq3dk7bijQxUvR0uog56LK9Rf8pCWbZSWQzfMWNw/OJ55H0RQIYWW3Zba10
	iqITim8VRD3YG9uAAxFuNz9O10EUi9raX8pS0WZMXVlvd9DCB+t/USnbuSj7Su/grhEVmukDbx0
	KQG9yMkI9cdJxCUgsI5vI+AVquEN4ZfBECQ1ZruW3mD0TMkqRIb7hUBVmXz8oDdqGF4u7OrCBZS
	+bJocnPpmHd1LFDafa4QiZedZLtqkERCKx6mcsPy0mkw5fYM/A+Vo5ljzaxqCiGjfqWVY0GwdCV
	gyi1GgOCVjUmedmr0W9Rib+GmQkpWMccPSOQDA7ABaCFDqr1DsSylRMbJhwGIGNfc9RNVCqcQvc
	WKi9lN+bhRhGo9aKOKCv/OhZpu9sIfWuyrk8D/CPbbLZ+5Dg1VhQIpoxfp8A6aqXkIFc=
X-Received: by 2002:a05:6000:2886:b0:3d7:7def:8424 with SMTP id ffacd0b85a97d-3d77def8cb3mr5101947f8f.24.1756808500788;
        Tue, 02 Sep 2025 03:21:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuwAQ5AtqvG7eXO2gkUyF/tXrtUAMsjJ9ZGj6VVfhIUzEBqb3ntAVaiYHv3ttfnME/tutQ5A==
X-Received: by 2002:a05:6000:2886:b0:3d7:7def:8424 with SMTP id ffacd0b85a97d-3d77def8cb3mr5101917f8f.24.1756808500236;
        Tue, 02 Sep 2025 03:21:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6dc1sm274580235e9.1.2025.09.02.03.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 03:21:39 -0700 (PDT)
Message-ID: <387271d8-7ad3-4f56-b6da-b0deb0a6be6b@redhat.com>
Date: Tue, 2 Sep 2025 12:21:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
From: David Hildenbrand <david@redhat.com>
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-3-ryncsn@gmail.com>
 <911dc3b4-c511-4ef2-a159-091780987965@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <911dc3b4-c511-4ef2-a159-091780987965@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QzJV7D-tnakr96jeGbRnD_9HJMDSUDthIFOeq5iP1VA_1756808501
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F1C4840003
X-Stat-Signature: tk56xnrc9j19ujwoxrzza9nw4qbxobro
X-Rspam-User: 
X-HE-Tag: 1756808505-53021
X-HE-Meta: U2FsdGVkX1/Ag6vlE3LClJuedp9jOdLdzw9tlret7tElxI6AOIA7gmkJP28IZ1KOkhAe2CKYnumVsFCkAB5Z25cAlHMSDUKaCtlVe5V/Tn0P8tqDJpyvpQ/TFdS/6OJ4+zWqjUJTNBY5KGucHIwpmqTEc4KJtoGXDNMxbW32XvhlRHvFqREvNfCIG69rOeSYY1dpjHSAFM7qLB58KtjSrGkItHGOwXwVZaTfabVDX6d08CYTss8MIMeWE/hqptSvkKIG4IE9kdLWy0Xmk19eC79TTxOo27vPKosPxteGA2wlf5wpLN4dyZp7ZjlwHOhDEnt0XaXRZaUbL2ooLtigV8+UbNsGB6vRXrET02abJ+86oZGWI5ap0JDReW0BXTXR0MFce213Lt4ecsR9edaPQxQraSD4+manh8gCPz49EJxRWzvmKZ0PJv9w2ipYHNNJNCE8k1ZmAbekPTIiu89ze3ek+1CK/HgGLkXns2pGrGJC0aFOGFYKll5LJoyWMqRU6BpcoElf6kK5xlPGBS9cUXfdyApLHk3fkw4/a8GAUrUSvzCi4cEYIURdZjzeuIxF1b8U7HLIzehdsQCR1e8c6hgbEcmJaL15bI8f/FfHCSZ9x5C39KJOiXE5d6Y+jXjtZB3K+NLJurNV0wElSrA+ekuP6Rur3lsbblKAsBcWll7tyj1oycrrTkYNMDx2ZcAlcWOi5rGX97Gzv2dOU/6NSfs4pXp6HlauvWs/1dCPeJlPm/rXtw3g1BtTtETwlx49hdNmi9RC1aTLyHf80JXhcobtfs7355uNOKQDDo2L2sqE9z7FNyWl1oIytplNvAWhkTquqV0Ek0nVOwKV1NwklkI8Do7IUA5bKlYmUSzMoe6UL4USf1qd+RT+JEDiuN9oJtn0XCePcyVA1CNDu4D5jI/io2B7aV37i7Gf8WhwZ+CluidMkoTTQv7xXb/oE3FSGyq5cFiiaCaaoNbYw+M
 CHPK8OnJ
 iPoTi4IY4ABA3StAFhJ7NBGjALpTqsLJtl6KGjc7U8vCQIcA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 12:18, David Hildenbrand wrote:
> On 22.08.25 21:20, Kairui Song wrote:
>> From: Kairui Song <kasong@tencent.com>
>>
>> Swap cache lookup is lockless, it only increases the reference count
>> of the returned folio. That's not enough to ensure a folio is stable in
>> the swap cache, so the folio could be removed from the swap cache at any
>> time. The caller always has to lock and check the folio before use.
>>
>> Document this as a comment, and introduce a helper for swap cache folio
>> verification with proper sanity checks.
>>
>> Also, sanitize all current users to use this convention, and use the new
>> helper when possible for easier debugging. Some existing callers won't
>> cause any major problem right now, only trivial issues like incorrect
>> readahead statistic (swapin) or wasted loop (swapoff). It's better to
>> always follow this convention to make things robust.
>>
>> Signed-off-by: Kairui Song <kasong@tencent.com>
>> ---
> 
> [...]
> 
>> +/**
>> + * folio_contains_swap - Does this folio contain this swap entry?
>> + * @folio: The folio.
>> + * @entry: The swap entry to check against.
>> + *
>> + * Swap version of folio_contains()
>> + *
>> + * Context: The caller should have the folio locked to ensure
>> + * nothing will move it out of the swap cache.
>> + * Return: true or false.
>> + */
> 
> I appreciate the kerneldoc.
> 
> Intuitively, this should be called "..._swap_entry".
> 
> But I wonder if "contains" is really the right term to use here. It's
> more like that a swap entry "belongs to" (was assigned to) a folio, right?
> 
> Sure, we store the information in the folio, but the "contains" is a bit
> weird.
> 
> folio_matches_swp_entry() maybe?

folio_matches_swap_entry() is what I wanted to say :)

-- 
Cheers

David / dhildenb


