Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD224CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28D748E0009; Tue,  9 Sep 2025 11:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DEF8E0003; Tue,  9 Sep 2025 11:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12CC78E0009; Tue,  9 Sep 2025 11:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 01AAF8E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:18:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A01811DE217
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:18:19 +0000 (UTC)
X-FDA: 83870067918.18.8140794
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50EDF180011
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:18:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYMIy5ZC;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757431097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CftawZr7rfdLaKHBorroP5fxQHxVIg34Hy0mtfMoP4Y=;
	b=BEa023FXrqE4lGCw2jUv4Y6XHUh9dL5Vx1aY9xhwVIFbSHnkBzW7DfdsBLukZFXtvrGTSH
	wXP7SjI7/F6+Yi6mYLgLkZW3I3qTQVKX7IE3/B9ZGgg36AoUceCF7eEwodln0bAjTv9HbJ
	x5paBk6rfpPbgQeUozMltyoiJaKK0U8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UYMIy5ZC;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757431097; a=rsa-sha256;
	cv=none;
	b=3+TKSI1iCURm4t2hsjizE4Ep007uGIW+22sg4uPoPR+xtcT53eE78laQMfP4dT7Q/dUw3g
	0mCSDGCEWNuCuvRnxchi2GscDalXUewhDTvqaRmH7XPBxuXO1ES5eGs6JCKppPvQnuaLnd
	+1B6fe2OV7FFy3JWq9PG0+PjpUwsbe0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=CftawZr7rfdLaKHBorroP5fxQHxVIg34Hy0mtfMoP4Y=;
	b=UYMIy5ZCZ8BeOMyKLsHT4SwZMwIKXVUgxi7a0OhYBx1Hok1J+Y9PJB357jkFoVy6CY2NK2
	fg2N4hUMN5hKmnD856rwLOSUY37wyzjVLYyMfZCGfUbpvPZxeu1EpOa/gBpjNdpXxaxrna
	xd9nS3iisU4cDqSo/kBShodwDI7mKNY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-o4XryKQ3Mqeq82Zc8FTM7w-1; Tue, 09 Sep 2025 11:18:15 -0400
X-MC-Unique: o4XryKQ3Mqeq82Zc8FTM7w-1
X-Mimecast-MFC-AGG-ID: o4XryKQ3Mqeq82Zc8FTM7w_1757431094
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b467f5173so40936425e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431094; x=1758035894;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CftawZr7rfdLaKHBorroP5fxQHxVIg34Hy0mtfMoP4Y=;
        b=kjo1G9OFKzgduzpMiX3MrIBZ42vE1Jaj5ZGWnaDYvDT//N00zYElw5mW50NfANQUyK
         0mT8ePTwbJs143gRK92AegGX1cXv5IzxZJ/7Bkufj2JvRmS2SUDBrop+S3CCOvr85KDl
         ELoEN5ST/LOHaOZSZd7wxD8EzQC9ekYCtKeI8KJg3ORtKkKkFgyyLzvTOFlqGwIaaG9r
         x2feAdMEWqYlbX3iAcwvSgbWhsOK8VSVUUYOgkjxzViYBNXcpcRgqZahGKNm8VutYsPi
         bWfU3ogej0qD0vgEuzVtIJsH8B0Ad4jq5Mnz2uvkEg2J9xrF/015VqfNdhVGv4pCM//K
         byVA==
X-Gm-Message-State: AOJu0YyUtt+PRJa2mDaPp7Z3x8R9A/gU5YJvEzqTrlwanIy/7V5fOSVg
	0fMpVpqaJpDXsFT6sM09tgASEFoZQT8Yxjky911ftIaTIjeY2w2YC7A1S5HUSblD67nJFjtO3qZ
	WAKrk/me0vQORz3sTD1tC3QLe5afLRifj1I0sDQK0zq9M+dWEpoO3
X-Gm-Gg: ASbGncsR/EKEPjflruljFdipvn/8IetGZm3iRILQvaCdeN2+EuJD919mQVAdvuGCTrE
	c9e+c5bJlnisJhLcwpvZSvq123fZi/jLNxE8M0+7IqiIEIzUbFL0MaKzF3u2ALrXgPoqo2i7fEx
	Tmt3q5n7e7XL5uVg2rMdaDLhRkGFMnrJMZBtB0tlbYlSFNGZs4sxgHHPM5QkDfdJhZUgReLyYR+
	NrrKBe2nxsUhqnf7HDnYRZPAEyV9rvEYxQijBWtVr8O8lH8RYBnbJ/R12suVsD3JZCgUOqCSIvq
	y1j4QlDwsm8f68XJxYNWddTcDRBqYr27kkRdaVANdpTgPAIltzqb0151ZWs2NcN3aDX3OwcCjuj
	fxZ1+ms2rOglV/6lFguptKXXdXLZgcz5O1J8VdlWdy66vp9T7cIyIDlZy4UgDDCeMbfY=
X-Received: by 2002:a05:600c:3b9f:b0:45d:edf6:367c with SMTP id 5b1f17b1804b1-45df1228190mr25913735e9.30.1757431093870;
        Tue, 09 Sep 2025 08:18:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHw6Lb67cLGpYBVgnVwWX1UQSM6fovL58P0tQZLYw/wsEhx0Z87VnEgBCuQy4LuoXQD/jMb7g==
X-Received: by 2002:a05:600c:3b9f:b0:45d:edf6:367c with SMTP id 5b1f17b1804b1-45df1228190mr25913185e9.30.1757431093360;
        Tue, 09 Sep 2025 08:18:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda4f2a0dsm189504735e9.2.2025.09.09.08.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 08:18:12 -0700 (PDT)
Message-ID: <fba37e0d-b809-48b5-9637-7cfffa469801@redhat.com>
Date: Tue, 9 Sep 2025 17:18:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/15] mm, swap: check page poison flag after locking
 it
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-5-ryncsn@gmail.com>
 <bd8338cf-6723-46ef-9043-3ced8be56e62@redhat.com>
 <CAMgjq7BPk1PJn0JGo+ERnisSimG0FSuiQZHDY3bf2gBgE5rU1g@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7BPk1PJn0JGo+ERnisSimG0FSuiQZHDY3bf2gBgE5rU1g@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iLgXaqRhxMNkGQPF8UtDNqNZ80X-mf94TR0ZG6jsyP8_1757431094
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50EDF180011
X-Rspamd-Server: rspam05
X-Stat-Signature: kyaaxazuwya6ztnn7curhjfr89t473y1
X-Rspam-User: 
X-HE-Tag: 1757431097-567632
X-HE-Meta: U2FsdGVkX1+QAUiqfZ07cDZbLK0sDXOuWg9oBQkHRaLw4sWSR4CFcp3UQLkPkamaRt8RrHvxVAAyxluSPpanExiM2LsnyHg8tGQ9qDDYfKB+aloHeHEFIqYrWnKIxKlE3S259tXWCcp/1sX8N0e9UWQ38ppDQh+FCDmuRMEMoUgiq/+pAAmzg74VnUPa41rbhZEAmw/sZYOx4gzprocG3RR4d+c4CDDbM9oKK/e+Tukok8i55RdmF0DkVDkfUgChOMzK7PLLO3/+MSQieoRp+hZUkheYyM2YGgctfQyU5h5+uM6IkxAEnBSPCcdBXP9/r6eANTCbgvNqS6z4vdZn/seBmAQ+64bFO+Aeg1tl/fghvctntZcbsPpGmQGbuaH6qpaxDlI8o1PYCENziUJshQ+XZax/ogRr0AM/Def6ALBfmdVO+24vpzl8PIT9zLc5PtWWCmoaQK5VSHcSbr82YPJCOJHZ9vwTcTd7W2+LEOVAM+BklFsPejMReT+gjWJB9Ysj/N3GaGcVGPxcloHaBn/da2iYOP5Kvd/GM2L9vswIe1v8Hb7X8ZcPdl3g9BxbAqQHF5eg5LI2HBLIvCQggaXS1VV+pJwb+NPy4tfaTbXA0qwew1+4L0ZALPq7p1gKaev0LQjNbjDKPzJuA7MoDcU8czEjgfJO98ta1FDPRFXLLvnZO0Ehz4ZzKKRxd1+ylvzfAPosgMJEJgNRBSQtMrkfwO166OgU2TZgOS5B+NuCUcFSgNq5XY6YvO9wGl3CoZW6pTKhmb6eKGWA9viy9lyXQl6bunIJsbf217R3vl3rl5gPieLAPQSCXfoDgYJzuaalJ2VTMe5V9yo9drJxZ+WTIa3mXtARMxeZ698gQKP5gaVBGFOYCt89Fz3N5z3pr36vFizRvi9Pf8JYJqQa51+F1w/oAwRk4ol4xyDnG7NlyOxs5gqWaf2JOnHhoyR8az5HBl9p2J2Jnjq3zm3
 BCFdyXBl
 hgfC819aP/794H4440liG4sQtrrO+PXMDjlKST2j1HirXoDc6JiCHcebzsl2MsYEob+tYStwLHWqEEC4PCGMm0V/l674GeAdi5It7f4zfEuwgbqK+1X4JgdU63nt5mVKgzHPq8p/42G2hP5hdP3rLIB+zvHHFRaNxE7vV7Vf7qKDsX+nuPFOangPgDNKQRLEKj+gbIGv0P9FdIiI9qReeDoYg4Hw+0Bhi1PIsOouqMTBigw90VgW8AbYeqka0Gti99jJ9gqbjqdqzFWdFoq/drBoOsAtQ17nsiP1bday9CQAHXLdAkvoandPFXtHXVEzyQ6v38koYLvXozF3GV8AvJ7gD4CVO9mkjkmEQjIxhHxadFrQFLv9r1PhC1sKDJXnmk5kssoTCVM5VIN8mrW15GYEvuX4QJ0dqXgR3Qqo7w3SftZJfJjHYG4lYpWvuV9NwagCbyq8gIH/KmHPNxeG6VPdzLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 16:54, Kairui Song wrote:
> On Mon, Sep 8, 2025 at 8:40 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.09.25 21:13, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Instead of checking the poison flag only in the fast swap cache lookup
>>> path, always check the poison flags after locking a swap cache folio.
>>>
>>> There are two reasons to do so.
>>>
>>> The folio is unstable and could be removed from the swap cache anytime,
>>> so it's totally possible that the folio is no longer the backing folio
>>> of a swap entry, and could be an irrelevant poisoned folio. We might
>>> mistakenly kill a faulting process.
>>>
>>> And it's totally possible or even common for the slow swap in path
>>> (swapin_readahead) to bring in a cached folio. The cache folio could be
>>> poisoned, too. Only checking the poison flag in the fast path will miss
>>> such folios.
>>>
>>> The race window is tiny, so it's very unlikely to happen, though.
>>> While at it, also add a unlikely prefix.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>>    mm/memory.c | 22 +++++++++++-----------
>>>    1 file changed, 11 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 10ef528a5f44..94a5928e8ace 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -4661,10 +4661,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>                goto out;
>>>
>>>        folio = swap_cache_get_folio(entry);
>>> -     if (folio) {
>>> +     if (folio)
>>>                swap_update_readahead(folio, vma, vmf->address);
>>> -             page = folio_file_page(folio, swp_offset(entry));
>>> -     }
>>>        swapcache = folio;
>>>
>>>        if (!folio) {
>>> @@ -4735,20 +4733,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>                ret = VM_FAULT_MAJOR;
>>>                count_vm_event(PGMAJFAULT);
>>>                count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
>>> -             page = folio_file_page(folio, swp_offset(entry));
>>> -     } else if (PageHWPoison(page)) {
>>> -             /*
>>> -              * hwpoisoned dirty swapcache pages are kept for killing
>>> -              * owner processes (which may be unknown at hwpoison time)
>>> -              */
>>> -             ret = VM_FAULT_HWPOISON;
>>> -             goto out_release;
>>>        }
>>>
>>>        ret |= folio_lock_or_retry(folio, vmf);
>>>        if (ret & VM_FAULT_RETRY)
>>>                goto out_release;
>>>
>>> +     page = folio_file_page(folio, swp_offset(entry));
>>>        if (swapcache) {
>>>                /*
>>>                 * Make sure folio_free_swap() or swapoff did not release the
>>> @@ -4761,6 +4752,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>>                             page_swap_entry(page).val != entry.val))
>>>                        goto out_page;
>>>
>>> +             if (unlikely(PageHWPoison(page))) {
>>> +                     /*
>>> +                      * hwpoisoned dirty swapcache pages are kept for killing
>>> +                      * owner processes (which may be unknown at hwpoison time)
>>> +                      */
>>> +                     ret = VM_FAULT_HWPOISON;
>>> +                     goto out_page;
>>> +             }
>>> +
>>>                /*
>>>                 * KSM sometimes has to copy on read faults, for example, if
>>>                 * folio->index of non-ksm folios would be nonlinear inside the
>>
>> LGTM, but I was wondering whether we just want to check that even when
> 
> Thanks for checking the patch.
> 
>> we just allocated a fresh folio for simplicity. The check is cheap ...
>>
> 
> Maybe not for now? This patch expects folio_test_swapcache to filter
> out potentially irrelevant folios, so moving the check before that is
> in theory not correct.. And folio_test_swapcache check won't work for
> the fresh allocated folio here...
> 
> I'm planning to remove the whole `if (swapcache)` check in phase 2, as
> all swapin will go through swap cache. By that time all checks will
> always be applied. The simplification will be done in a cleaner way.
> 

Fair enough :)

-- 
Cheers

David / dhildenb


