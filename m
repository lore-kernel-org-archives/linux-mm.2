Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0B4CED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EB046B0030; Tue, 18 Nov 2025 05:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2286B0031; Tue, 18 Nov 2025 05:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7B36B00B5; Tue, 18 Nov 2025 05:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0CED6B0030
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:20:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B16CD88CE8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:20:54 +0000 (UTC)
X-FDA: 84123334428.18.E5AE5C7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4E642180002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:20:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d98x+MfP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763461252; a=rsa-sha256;
	cv=none;
	b=Bl8TXQRPQlngMCGR378AT3ur9jAteKcWWvmMGlXI/CP+/rwHPdWvuQIN0cPLSfe6Payn4e
	5SXM2i1e9rMWYIBcmJxz8zAWp/b67h3P/lQte2u9o80FHIgsWQNeNznRtg1elAzN+B6AUq
	h8h+COlK/j6UcuebxCfVAEaBmg60bp8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d98x+MfP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of toke@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=toke@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763461252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qqdb8OtTIWPqMLICOLkFlFxhk9j2szKMv7aCnVG8Juk=;
	b=j+J0FvlwFYTqyicaujRBi3Icw/CjmHQU6rBntIOh0w/FE+GEVdZYc1XnDmpxh1TP0+GLLJ
	W7W1n6hZMo5g2IzfwXP7WKpN15K5GoQZDyb6geLrAV2lKGqHYeVYiS7jjRH3C6dFiN/Hyi
	y3GF/2rFXy/GLZVO9EkV6pdjhbvMkZg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763461251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Qqdb8OtTIWPqMLICOLkFlFxhk9j2szKMv7aCnVG8Juk=;
	b=d98x+MfPStY23dyEFBiBLNwAtDDH5kgGhpkwSOZbFfasZ1RrkR6puF7w14b0GaJWQUdAby
	MlLkYV7Q7psHD5xCfAmnJfefUj8qf1LigFky9Gz71gwp4pKtUqVTibJ+3caajRVlF229is
	xSUjkOm38qGCaG5IoMLoFn69nmqmkGs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-wl-elA63P7WZjE_KstWRbQ-1; Tue, 18 Nov 2025 05:20:50 -0500
X-MC-Unique: wl-elA63P7WZjE_KstWRbQ-1
X-Mimecast-MFC-AGG-ID: wl-elA63P7WZjE_KstWRbQ_1763461249
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-640cdaf43aeso5854098a12.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763461249; x=1764066049;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qqdb8OtTIWPqMLICOLkFlFxhk9j2szKMv7aCnVG8Juk=;
        b=kDk4faxmEoBPKndgJEfw7fiEevmqHsx6B8Ynrl2qX265OJR/VC5qJHsAOUSTnyqxRO
         3h7+GuBgxmTJo4MWphSr7w1GCPH0bbuCCUxjF0Hv5LYTk0JyHosLZZwlcyGjSNU71rQc
         iSWdegSjlqP9ffWZIH9sr96J65mKFGlUg7dx9kOld5HCsZdIGJD1CiisHodsfxs8Vwcn
         1uQVHOConaHlTnDSRnsSTo4hbMrPRxlgGHrMppHelJiN9wNNBuA1d0NtoayeV6Cu/eCS
         Gp5lYaoUqu+m4bnBZ64gCL2xO0me4g5IUZdPJM3PREu6WIqTpGq9arSNh9vLbPWuAPoQ
         tX3w==
X-Gm-Message-State: AOJu0YwlwN+PpB4t3amvH1f7BPJ2kDFbISB50MWALwiwAfHEGnvbo58z
	zU7yruglRHQMSpwRmQWTHo1pscarramJLH6+MpyS3ZAIZZZXDNJStF6G+KAm1kZO74mafK2SBBc
	9MzDNoeixVe1RnOprmj4+5pzrR8EQtSgZR2LdSOKANgIdnFzX3t/1
X-Gm-Gg: ASbGncut/6lShSsusCM3hN4hjFGl1OezznwlZ7cdDyuGolvzCPPwzG28e0PqiV/cCUQ
	Tzag+D0bH2s8zTGbl7SG/m0tDXQMeXj0otfg4Fy9KEU9pD2DLg3ZCqz89dgLIanLYUtkCdQbs0S
	HZgWVEYvsAFbdZ4ptDMLDwsqU2cR89ciwgUWykNxRbiw7BetRn/Lo9nkR7yyTA3vFKF4e3ib99z
	HMR+MM886t1P0ZWy12SFegB3PboiweNQcVwQ3HqKTfMQxs38aJv7PtvF3+rKhVEf97wxS9MpsJ8
	CKLH3SZR3+8EfLPQP3IPmdlmVCTa3+X76uYPc0shB+5wWf3t4e+4gOoQuJwz37wdcSKoAGuslzx
	RTbwfWRlc5emeYsrnNpyx9N3BMA==
X-Received: by 2002:a05:6402:2813:b0:640:9eb3:3686 with SMTP id 4fb4d7f45d1cf-64350e8e398mr14659677a12.19.1763461249107;
        Tue, 18 Nov 2025 02:20:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMmLVmalw0Ch5oVUFByxi23ViTAeHA9jZ/CP/GaJCrMyZNeJXWNQJXBphzVUwZfa0E+XKE2w==
X-Received: by 2002:a05:6402:2813:b0:640:9eb3:3686 with SMTP id 4fb4d7f45d1cf-64350e8e398mr14659656a12.19.1763461248670;
        Tue, 18 Nov 2025 02:20:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.borgediget.toke.dk. [2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6433a4cbd18sm12247224a12.35.2025.11.18.02.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 02:20:47 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id ABC7F329BD0; Tue, 18 Nov 2025 11:20:46 +0100 (CET)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Jesper Dangaard Brouer <hawk@kernel.org>, Byungchul Park
 <byungchul@sk.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
 harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
 sdf@fomichev.me, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
 pabeni@redhat.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 willy@infradead.org, brauner@kernel.org, kas@kernel.org,
 yuzhao@google.com, usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
 almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
 linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
 ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v6] mm: introduce a new page type for page pool in page
 type
In-Reply-To: <ea294b1d-7698-4f67-abd5-a7b9b67db6bb@kernel.org>
References: <20251117052041.52143-1-byungchul@sk.com>
 <f25a95a4-5371-40bd-8cc8-d5f7ede9a6ac@kernel.org>
 <e470c73a-9867-4387-9a9a-a63cd3b2654f@kernel.org>
 <20251118010735.GA73807@system.software.com>
 <20251118011831.GA7184@system.software.com>
 <ea294b1d-7698-4f67-abd5-a7b9b67db6bb@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Tue, 18 Nov 2025 11:20:46 +0100
Message-ID: <874iqrod4x.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6kPKnZkukFZhB2qYGzTmmFYN43SZesIiUbDAg_FMG58_1763461249
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E642180002
X-Stat-Signature: ywia96ydun55fq7b8e84ktk836bz465f
X-HE-Tag: 1763461252-887384
X-HE-Meta: U2FsdGVkX19ELRNreASxPqlkoT4tZ97iWE/vWx+oW34TFP+Sc4VIeqBwFmpSjtcKGkaLrrUAleiaxs4ktxkZVNEShlRNFRcVpeG3zb1IKzeZI8akY1GyamqkB7fWEogPM5LSzHPIxLF6fTrOyx48dQRowszIvEEPh0sZZMTWZl1hau7bTtugLmE6ssKjNrfI3eNcUpbXKOtlflXoPOBkIhzmUgkdqMFwZA4jecFwPz0mIhyYMGBjdC/GOoqLn57Qo9BqB9bbs+51tFU99WmTZ6ARM9zmWwv3ZT5g3NUwmJJ3Ou4C5qCPrLRgNx5ZSij55E7JbXGZqNZYa8/Mnr0OU/wNGJe+kcpqMXi28ZN3sLjTzPb/7Toew2VkVGdudxl76TBsGlbTna5W9mLviGR2bVpZz/ujG426Ryk/gpCy8G+21RTA0TCk6xoXZn7hiRfXqL+huuqHEHSG1NRTjo3Xl+tpBH6vJrdm/F5cbmfJ7RET+JqDexQg+51VXXRG8n1jhP3lh+oJYHF/N/DkVFKgIyW1uhHbHBdLAFeV5/kC5CPL+8/IZTixeo1DbbAef27K+mKzBmDxacrQ7i/VYNcjkCxtLumler9UXdFAPEP981SHeB3XyJO9vwxpXZvykpqPZ0+5upBcpEiGND843YHXm/pU+mRxsCBMNoyMH0hyaSfUGrLTq7Pjkiv5JSkirnJ/ZAPlq/YQ6DEFTv0M6rRW+mzyESiKZHMYJV5eCMqljfCvyedsas/oPJ6X4aVgDpS+8toJ1yMrc2zs33z7TFl3vpdwL2Us9q8FuHwWoRO/rcn/SPugcWhbF5pgVP+Py8q0LMrRNNIs62kVr1WAZsowJW8WhWKWeVz8e7oNeOK/LHsabA+uun19+vYY45na1KljjPmfPUtKpyrTwOy8wZiQgKyJ9eT6B49vAB4LZfHD7v10awYzHiqTA/SkL/YTbcklqWHmPbusN2ndgr0ps2I
 qm7z+ttr
 FX5PoLbhqSdN7JanhfcEZ8w6bWc/V7stmQi3CuJO0e7d7hLq2DK5o9btHODH8ntbUsy9dxRiZrWlxfzW/fwy18YL//lU7q+dKAG+aOadtqsu75jXMjGtt6UOMBMYWb3/+384C2s19Fzmwa//JHXaWl76wW4rZQ/myYWmItF5GDtdcPdy74nGwl0zw1PREE31mlyN5wulfNpEZo3Jp7WkE7yz+zhbID8dMnuLIJNXtgxBpyy+hafY6G5GfTHB5NU7hVRDFW1IBu0PKXNj0A/uMD+cjDwIvxQdZnqWzaEoycdcS5v7JQBpbR+VSLrkDldDDJAzBVAIjW7vtGpcTBj8GBzuQoS7TfmQvSxWm4FelJN6TeRkFQOfvwIWgGHHlWvYeccsZXLuM4lBIeYKy8JrTLOULBJWb7OPGYQOVjMxGfSs8Pax79hiALRzdnmapCq2HVEBpPkPyPOS3nPKiO33HQwfETsSV7XOgh+nnrozRsKTvAgctFdI5avgRWvcUO2eNN1H4xL5Jd6e4E6jWywEMGOjNARNRdthA3PBBJx/yGl4qhWVAqh41H5BKRlv5kKnOgD+FKKUNuakdt65laLjt38pgIbgMxMAYzt+M3wDKIpRiBk07fsrIYbOSkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jesper Dangaard Brouer <hawk@kernel.org> writes:

> On 18/11/2025 02.18, Byungchul Park wrote:
>> On Tue, Nov 18, 2025 at 10:07:35AM +0900, Byungchul Park wrote:
>>> On Mon, Nov 17, 2025 at 05:47:05PM +0100, David Hildenbrand (Red Hat) wrote:
>>>> On 17.11.25 17:02, Jesper Dangaard Brouer wrote:
>>>>>
>>>>> On 17/11/2025 06.20, Byungchul Park wrote:
>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>>> index 600d9e981c23..01dd14123065 100644
>>>>>> --- a/mm/page_alloc.c
>>>>>> +++ b/mm/page_alloc.c
>>>>>> @@ -1041,7 +1041,6 @@ static inline bool page_expected_state(struct page *page,
>>>>>>     #ifdef CONFIG_MEMCG
>>>>>>                       page->memcg_data |
>>>>>>     #endif
>>>>>> -                    page_pool_page_is_pp(page) |
>>>>>>                       (page->flags.f & check_flags)))
>>>>>>               return false;
>>>>>>
>>>>>> @@ -1068,8 +1067,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
>>>>>>       if (unlikely(page->memcg_data))
>>>>>>               bad_reason = "page still charged to cgroup";
>>>>>>     #endif
>>>>>> -    if (unlikely(page_pool_page_is_pp(page)))
>>>>>> -            bad_reason = "page_pool leak";
>>>>>>       return bad_reason;
>>>>>>     }
>>>>>
>>>>> This code have helped us catch leaks in the past.
>>>>> When this happens the result is that the page is marked as a bad page.
>>>>>
>>>>>>
>>>>>> @@ -1378,9 +1375,12 @@ __always_inline bool free_pages_prepare(struct page *page,
>>>>>>               mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>>>>>>               folio->mapping = NULL;
>>>>>>       }
>>>>>> -    if (unlikely(page_has_type(page)))
>>>>>> +    if (unlikely(page_has_type(page))) {
>>>>>> +            /* networking expects to clear its page type before releasing */
>>>>>> +            WARN_ON_ONCE(PageNetpp(page));
>>>>>>               /* Reset the page_type (which overlays _mapcount) */
>>>>>>               page->page_type = UINT_MAX;
>>>>>> +    }
>>>>>>
>>>>>>       if (is_check_pages_enabled()) {
>>>>>>               if (free_page_is_bad(page))
>>>>>
>>>>> What happens to the page? ... when it gets marked with:
>>>>>      page->page_type = UINT_MAX
>>>>>
>>>>> Will it get freed and allowed to be used by others?
>>>>> - if so it can result in other hard-to-catch bugs
>>>>
>>>> Yes, just like most other use-after-free from any other subsystem in the
>>>> kernel :)
>>>>
>>>> The expectation is that such BUGs are found early during testing
>>>> (triggering a WARN) such that they can be fixed early.
>>>>
>>>> But we could also report a bad page here and just stop (return false).
>
> I agree, that we want to catch these bugs early by triggering a WARN.
> The bad_page() call also triggers dump_stack() and have a burst limiter,
> which I like.  We are running with CONFIG_DEBUG_VM=y in production (as
> the measured overhead was minimal) to monitor these kind of leaks.
>
> For the case with page_pool, we *could* recover more gracefully, by
> returning the page to the page_pool (page->pp) instance.  But I'm
> reluctant to taking this path, as that puts less pressure on fixing the
> leak as we "recovered", as this becomes are warning and not a bug.
> Opinions are welcomed, should we recover or do bad_page() ?

I think we should do bad_page() to get the bugs fixed :)

-Toke


