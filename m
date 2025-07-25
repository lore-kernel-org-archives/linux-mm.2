Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD6EC87FCD
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 07:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE746B007B; Fri, 25 Jul 2025 03:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA91B6B0088; Fri, 25 Jul 2025 03:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96B06B0089; Fri, 25 Jul 2025 03:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C97ED6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 03:38:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CACA8063F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:38:22 +0000 (UTC)
X-FDA: 83701984044.12.F422275
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 194074000E
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:38:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DlF4m06/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753429100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqBO9xBmUQSQOv3t22Yu8O/ZK7eM/acEO/FVmlf3cEw=;
	b=YFnv0t8dWm8gMD3Ub6FW6iGStJKh76G22H16bSmuNKKFgSIpsCkiv0i6AywjO/cfoIEHAC
	aQEDKqGlov7aldGaOu9mBwNUV6KAj06Yi8X2eqrst3gzWCPKOD9LHlJKAMiG05qo4fFTjf
	UN5JbxPtsKp3wZ2j6IhMujPkWJ/E82Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753429100; a=rsa-sha256;
	cv=none;
	b=BU/Grf5xJpQjGpWKzLvVVox31FsgpG/8pc8IXlJQwhlsBUC/FhwOYCAwKyCMxD0puCEH1i
	TJ5Sq3OxYCKVdzjDpjoYQzU3LnI6NYi6BQnmrPfShn4KrazEvjzWq/pLvjGePyjHpsW8Qt
	+MeGK1LbFIjTNcik88QlnE8cbSyR0ng=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DlF4m06/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753429099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nqBO9xBmUQSQOv3t22Yu8O/ZK7eM/acEO/FVmlf3cEw=;
	b=DlF4m06/UTIpeWXnJmSXxtveDE1MVPhufs+TdJWheJGIC1d3aH1sqHx27sHFl1bTFQdOYy
	vhYNDTH9y88evPI3qwOsHikzf80zO8XE5loD3MAFFBd+LZ/v1hr7byu9hdl+TIA7TpTdbb
	LEHD1Q80dnJiZgnKs2VKA9o8VXvWHGA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-6qNjAFjgPFq8FkK4Mvx-jg-1; Fri, 25 Jul 2025 03:38:18 -0400
X-MC-Unique: 6qNjAFjgPFq8FkK4Mvx-jg-1
X-Mimecast-MFC-AGG-ID: 6qNjAFjgPFq8FkK4Mvx-jg_1753429097
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso10830805e9.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 00:38:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753429097; x=1754033897;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nqBO9xBmUQSQOv3t22Yu8O/ZK7eM/acEO/FVmlf3cEw=;
        b=HM6itG2gmxVSpRw7j44cBLfCzjMGuYHcl/Wz9+jU1jYsSjojMrCfosLGFecS0M9qTN
         TtLV7UYJzWa4cjw0Vq8vTOppz3IMrbh0GgA3tlijFfIAxqQCVxS95Ju4M5MtxTJBjjHp
         yKR8/lR6KhOXZXXLx6AU1Dc18J99mYsSQX+dC+4K4kqjdrv+fbv99DPVWknxobqJRD+J
         ++J4a0Yi3H2/SKmDzjNh99aEN65VWP4xqbsmmp4HeRX/aNzxnmynIUe2dQx+ZMPWNdZZ
         1k+wB3ySPMOcXNBPedWtEkRJz1ZiHYe5xzfR3ww1e+R1tBD3YO2buPHJLVhFw1ujAuyc
         0gqw==
X-Forwarded-Encrypted: i=1; AJvYcCX4aQLRDEq3Z27M2n720oVXTy6YDmn+tU2Q2YUc6Y5ZeoMbGhZ3FEDeLrOAb3eeJ4Ho2ANQfhNk4A==@kvack.org
X-Gm-Message-State: AOJu0Yy6Ie7/qyCUxX2YTeoGo1DomQc9WisD/OYXUsDA1EAeRn/FcXtB
	w7QDOHtDNYxVbCuVia3pOhfU6L/3OjtAnYIwDZT8szuGSN+sc4pA5NwlF6PVwyLrJMszFBA3mGQ
	viC9xbxpYXnM9GoGbiFuF/EjMKowjCkaUSfYPoUiqcNsZO9VAJ7jt
X-Gm-Gg: ASbGnctBp7QwVm8BJrhk0nSDE9Le5CixF6Y72sT8HJVHhcl7fkNGuSEzT5ZOCEEsh25
	iWOhniSggv+J8cXuZzYSf4e+S4FMdR4UA/Snf4iE6R6ACYIC+hNdOQnetv834fWc9j+AASvRZXL
	+42Zo89KEJ1IF8FgvM6xtucBxeYRghYxEfcsX1yAI47nj+GE0YZFaGL4nkIXGJyV1TE0xjLGcmM
	lxUlALs7u1Y6HNkl7JbzLBlHgFjuTmzQABfg1QFb+9S2D4YeAbVuY8mH1KIHEjKhQv+SIW0f5ip
	TFThO3C8LdZBeiIDriChC0kDqRlxGl5VCd6G/jW/kwThaKf3Rdw19QZZyZyekpIUkSHvYA==
X-Received: by 2002:a05:600c:468d:b0:456:1752:2b44 with SMTP id 5b1f17b1804b1-4587654e5fcmr5455285e9.23.1753429096635;
        Fri, 25 Jul 2025 00:38:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvfKwpSm5/wram/IC4tM9dnLJQxwvBCyuFrEnsH9dC086EvjWN2n4VNM00MDSTcQOQlFRPrA==
X-Received: by 2002:a05:600c:468d:b0:456:1752:2b44 with SMTP id 5b1f17b1804b1-4587654e5fcmr5455045e9.23.1753429096130;
        Fri, 25 Jul 2025 00:38:16 -0700 (PDT)
Received: from [192.168.3.141] (p4fe0fd5a.dip0.t-ipconnect.de. [79.224.253.90])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45870532a4csm44564315e9.7.2025.07.25.00.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 00:38:15 -0700 (PDT)
Message-ID: <0ad414a1-9a57-4050-a7b6-fdea08aebbd1@redhat.com>
Date: Fri, 25 Jul 2025 09:38:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] mm/mseal: update madvise() logic
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jeff Xu <jeffxu@chromium.org>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com>
 <4f66d89a-631a-43eb-b4f9-c9a0b44caaae@redhat.com>
 <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <692f9624-e440-4cf2-8202-861c679ddb73@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JWTItR_wnQt0T-Y_UtU8D-zo9pCOTiy_AydwiLND5gU_1753429097
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 194074000E
X-Stat-Signature: euyeyf7jmfenoddqn7a3u6qzth9mdpby
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753429099-534986
X-HE-Meta: U2FsdGVkX1/RaWZehiun183kWfbhtanGBAZlKX4TJ9dfYrJ4BDvrSqaW3++AIYiajZZIOQ7HBgdHLU0uIMdBwuiZmN16uSElLBPpf9Q5DBpDrVuDuF4xXcOpoFBiefpV9C1wxErF5thooS95h1We18s6LxJw6dciq81Tfl4r70WzNfP5QYMAzJzeosDAqa7CifpNQRfgksBiiZSsjVpvnzbAbxTBqXM3iXXoDPnnqpdGssp+T7U9rMfj5dZOwIlkT2lqBgXs0BI8DgtxeztDsDrP/0mLhc/fdtzJ81R+6K/8uTJt5VJveyL471BFqL1dpima0yy/Bso+zc9JLfTNdKoECc1D011nRn0Rl93zUGk3uUvdpPFqerfEs8dZuaUGmfTGqnj9ZvhsFFi3zPr1XxsPgsjwk0JClnCu8Qj12mcuqcagXm627V2lf1nTKHBGpN9ie1qtekqUa/s8cpm+qz6qXDI68BZSHpryn3+CQqzps832D/9dqcLRTRLZ0ICghZmzbJLvvMysRo9txU6Xjw+fgbhK9f77JyyZ4c2UlVpOC9ccfmMKyRZ2pk4u2qtuRfWvgd/qVo3PFRlniFaYVSoubom/CMTxGtL3kcAZl9bNjh9Yx6RlCyBEFgEg4UJQwyU6CvNwMoPp49AVrU8MdUy+AwVvve5ls64iEZYanhh+7yQFI6AfjW1YUWr2QdXARIPFiEeldirStPR+Ehjm3rdb6s5oH/QpKnFB8Gad9VyQwLhpGirbNqxAW0mmEdXpLLCcnbs6iNKvWzB45vp+vvBXheVVivqtkQrKK3RN9+GQN4RNYPZh0c+Ywt55KT2mTqjmV9B2BTW3BYwrUCHBaUjFa1l3wAxqFXIXluHbq9iCAAvVqv08of7xcwSdg7MvAIsTBcrCpKqdUmr4xNIDXVioEAO5TLRLLOX8wLkh86dvD3shuGEzVoDNheOH/0xuh5WRoCdVtsV4IxGTRHA
 E2Ie9Mjf
 blzNX+LDgPkqo1ywxbrKR5lUYFlybFCABhUWTRVSXizWDc4qWPYx5lUZHcWs/+q0rjJvy4CpQ3DmSsIg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>
>>> The justification for this change is to account for the case where:
>>>
>>> 1. A MAP_PRIVATE R/W file-backed mapping is established.
>>> 2. The mapping is written to, which backs it with anonymous memory.
>>> 3. The mapping is mprotect()'d read-only.
>>> 4. The mapping is mseal()'d.
>>
>> Thinking about this a bit (should have realized this implication earlier)
> 
> Well none of us did...
 > >> ... assuming we have:
>>
>> 1. A MAP_PRIVATE R/O file-backed mapping.
>> 2. The mapping is mseal()'d.
>>
>> We only really have anon folios in there with things like (a) uprobe (b)
>> debugger access (c) similarly weird FOLL_FORCE stuff.
>>
>> Now, most executables/libraries are mapped that way. If someone would rely
>> on MADV_DONTNEED to zap pages in there (to free up memory), that would get
>> rejected.
> 
> Right, yes.
> 
> This is odd behaviour to me. But I guess this is what Jeff meant by 'detecting
> this' in android.

It's rather weird usage of MADV_DONTNEED, but maybe, for some R/O 
buffers ...

> 
> The documentation is really not specific enough, we need to fix that. It's
> effectively stating any anon mappings are sealed, which is just not true with
> existing semantics.
> 
> However I see:
> 
> 	Memory sealing can automatically be applied by the runtime loader to
> 	seal .text and .rodata pages and applications can additionally seal
> 	security critical data at runtime.
> 
> So yes, we're going to break MADV_DONTNEED of this mappings.
 > > BUT.
> 
> Would you really want to MADV_DONTNEED away uprobes etc.?? That seems... very
> strange and broken behaviour no?
> 
> Note that, also, mappings of read-only files have VM_SHARED stripped. So they
> become read-only (With ~VM_MAYWRITE).
> 
> To be clear this is where the mode of the file is read-only, not that the
> mapping is read-only alone.
> 
> So with this change, we'd disallow discard of this.
> 
> It'd be pretty odd to mseal() a read-only file-backed mapping and then try to
> discard, but maybe somebody would weirdly rely upon this?
> 
> It's inconsistent, as a person MAP_SHARED mapping a file that is read/write but
> mapped read-only (or r/w of course), can discard fine eve if sealed, but if the
> file happens to be read-only can't.
> 
> But we could add a VM_MAYWRITE check also.
> 
> OK maybe I"m softening on the anon_vma thing see below.
> 
> So we could combine these checks to avoid these issues.
> 
> 
>>
>> Does something like that rely on MADV_DONTNEED working? Good question.
> 
> Kees/Jeff? Can you check if android relies on this?
> 
>>
>> Checking for anon_vma in addition, ad mentioned in the other thread, would
>> be a "cheap" check to rule out that there are currently anon vmas in there.
>>
>> Well, not 100% reliable, because MADV_DONTNEED can race with page faults ...
> 
> But hang on, it's read-only so we shouldn't get racing faults... right?

You mean, ones that populate anon folios.

Well, there is long-term pinning that can break COW and other weird 
stuff like FOLL_FORCE. Most of the latter probably holds the mmap lock 
in write mode. Probably.

> 
> Hmm maybe I'll soften on this anon_vma idea then. Maybe it is a 'cheap fix' to
> rule out the _usual_ cases.

Yeah, something to evaluate.

-- 
Cheers,

David / dhildenb


