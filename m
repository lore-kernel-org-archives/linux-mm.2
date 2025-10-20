Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A948CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C934C8E0019; Mon, 20 Oct 2025 09:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6ADF8E0002; Mon, 20 Oct 2025 09:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31EA8E0019; Mon, 20 Oct 2025 09:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2F938E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:34:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 443541389E1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:34:56 +0000 (UTC)
X-FDA: 84018588192.28.0D11B6F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD6CD40012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:34:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XPYm/EvP";
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760967294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9ioeJHZmUdCr0Up9JCTGVq2r6uGNXm2isBNF4LcOWY=;
	b=ATO46BHCljDG4iHCWr8cb2eIPNtXHtTWDC1ZYLaRBjTDLG9WcuTxlf5Yt1Fv+qZvofVuO8
	Yoz12FkNRKF5RPsEgWTH3ZnJsjFC7lAd3ZBad0eB6E0P5UGsgsRl99zN87t4PeLTsWBZGO
	qqlG3fpWnUDgz9zcIvKdntYrR2uur4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760967294; a=rsa-sha256;
	cv=none;
	b=sXv4eS92JYfoK2uHe/+IgGU7aU5ZLfzT7erQ7Oq77oZY6CXt03LFVgeWwXt7iOEjIiQbm0
	Fpsvss7hq5AiX+fRvrany74K/TQQPooPE+vaTnGjUufOAOvwJKHPBOkklCwJhYBj0P84N5
	5BQhPDs8plYzkLCVHhM3CzKTWJIpysY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XPYm/EvP";
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760967293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=i9ioeJHZmUdCr0Up9JCTGVq2r6uGNXm2isBNF4LcOWY=;
	b=XPYm/EvPTSEZv3ZO5vhARBnhAifKigpLbEIZ5+gPB+H8edzmN6zEj6Qe4VX1sc0gSbYdbX
	lu8zKZyeQyiYTok2f9QZucJslqcfVtntLq/uiIthJF6+fEjljMsxn6MpvKkzTVfL5iTK2V
	5RYHvvab1mwu/fEzK0XKok4M5XQhHhg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-cQ7Eoq33MVSfhFkzLMtG-w-1; Mon, 20 Oct 2025 09:34:51 -0400
X-MC-Unique: cQ7Eoq33MVSfhFkzLMtG-w-1
X-Mimecast-MFC-AGG-ID: cQ7Eoq33MVSfhFkzLMtG-w_1760967290
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47113dcc1e0so36952065e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:34:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760967290; x=1761572090;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i9ioeJHZmUdCr0Up9JCTGVq2r6uGNXm2isBNF4LcOWY=;
        b=cRC89xNkxMtjvQwn1pJENukl304yimiZNmLhHBrUrPQUinkRtV1qfHfaj+bc9I0ODO
         geQxClKmyCeuiTiY1xWaKGrSaSBqY1dOMfaO33vHq8bab69uBEaZu1lTPubea/49Wm9F
         yhgzWzQ8qyJ7yekYeVRdcp/0jUkJa0DdlHL9jwNKyah/UDrRTTU9z4QHVFf67h0BmRrk
         4lO+cnVB4aJmsoWR8c5UrUvWBYDJOUNZzYCzHrz5nE+5zrZIcRtyxcgtF7vqNAoPH2iI
         8pSM+6a6lIpQbJpaL7p1l6k/XEMcVGsnlcH6X87O+LyXMcFtAZ747EmUGCK4Oo0zQJBE
         MmSw==
X-Forwarded-Encrypted: i=1; AJvYcCXUZr9jaGEiqle+2kereoZdWoOAaqr+evs7rHVXauwj4SkV9gmwGBSHzZ7OrUodsty6/U+SqQ7gog==@kvack.org
X-Gm-Message-State: AOJu0YxUJ3vQ6TVROiBkh4Xb83g9g4wfQQeBorf6raMhDnkKWWsUm6Ox
	t5GMj7PmRKXu/wPwq8+6V5fSibM+Hz+3JfxDN5zoRTtjUYH7Fv7OKyfQqvaOEtcHAgdb1+94hFL
	Yir3m/yBxrWncWPL0hf8kfEYwPc+rXuKqGLKF83klnbK5eDL2zPLy
X-Gm-Gg: ASbGncuE5hatwBUwx97Fwz+EznXjT7K27kV4c3+f0rthrOLJB6bzRNF3oivYHikBQBe
	5FKAKRX47GUjttCUQbrNUY59hYFtNe60FYu6KrDaPiYK8R7tD1HUf+3qE2htehb7p9vay+B89/H
	w4xAIxvOgK55ClFAfZhF6qri1pm+ddeX/+6+DuY6aKn4XV5ycXy/etX0RxsoBYIyXFb/aM+54/7
	EGdLiAdI3qX5BCvHvzT7/GPbJUjZ4eFuPmx8/qQv+V1Cg/0MPb2DMt68VZgLE6fyJWm289KeOFs
	+Tc1V1bPImo+vd1K94zqk1sOs5yJ4EOe+0eQPhLx69iZLObEBfr+RMK+prXc53fpvbkzgI/ZVuY
	PBuU7gbZ4xVQ9u12z6+O7DgvGLse+YGC5KljISEho4cW+5P83mE6BTKFPn9C8CV1BWASRPOxMeT
	uKMMR6uoen52OXpQ7a7A8c3uJkFfI=
X-Received: by 2002:a05:600c:3541:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-4711791934dmr98877615e9.30.1760967290229;
        Mon, 20 Oct 2025 06:34:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFl1/eNGm+pkiPJ5iIQz2LUlBYM8XYMBsULDIjBA6gJeGNAM+fjBYKRlveufT3QXgRvz7K5Hg==
X-Received: by 2002:a05:600c:3541:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-4711791934dmr98877285e9.30.1760967289770;
        Mon, 20 Oct 2025 06:34:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce06bsm15128904f8f.45.2025.10.20.06.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:34:49 -0700 (PDT)
Message-ID: <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
Date: Mon, 20 Oct 2025 15:34:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Vlastimil Babka <vbabka@suse.cz>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Hugh Dickins
 <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
 Ujwal Kundur <ujwal.kundur@gmail.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>
References: <20251014231501.2301398-1-peterx@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251014231501.2301398-1-peterx@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5JKiiRAD0xzCC7ECfWgS3sx_sWNq7-KUjkZ3TwjP0gs_1760967290
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: t4j5jbqrskayywn3syhgfd4uw71tzt3n
X-Rspam-User: 
X-Rspamd-Queue-Id: BD6CD40012
X-HE-Tag: 1760967293-443408
X-HE-Meta: U2FsdGVkX1+TXY/qoMDXj6Ztk/1nAfhP9fD5QBjinNA82xfXuOOu+pZl7wZUMpMQLqfj1soKt+UlGbh0rL22O4F/gv7SOeasfHlq3O4izyqed4FpDhc+kgZ02GKqTbHLen9xjHSOLCS8tyBaAUjp1kD+jcDRLJNJo8iWMGGBi3ZlWtVV6HRNgazGK2WGuddqHmQjtnzapwD8lMnpBV7JF06F7F9QqXZgajPQuN+a0aPniru/CXyFymzhmKRBrKcgVMMOQWUNQaH+sjY2hzS29M8rZ/7H6tObbWYsk93t/ipx+KRNcVG7Kk5ceHvhDLtTdl9VB4P0iSq45/lR3XwCYwmW1bd51QhajlvRFODcQvD8yoE/OcUvTKWoeG5P790M0RPQdw0I9aMqc7JuTg2oe6kIFkSdTkzktOuwKbgTYu1g+lNL2+car0PcDeyDycTHsKekkZJP9cvkJAAY8dBz/w21Yx2pHdUbTJSIHc5+XYCxX1jRZSzv0wYLSmq1i+BWEAi0bfgS8FltTPAcElkpta39gbjZ+o8VnWs3IiPbNgAfLcovN9vkWZp3wz3mBH3LbBfYWV0tuMr9DZW7WYlR6/88z3VpXO38C0oNQ2Z9BUbH2NIErkmjtYWbFM0PRKB6/3DIlQli1poQFrJ7SHX02UtXjYIfepM3otTRfqEYCeYQsynQ4+l7FMgqVLbzLUbD2KVKekYg7h+1+vD5WfyGlhi7/eGhUDzfBrOF7bUhIi3NTbY9NARmXGgk2qRwCDWdTLFHfuMtaR0c30X8egLH8OLvkz7Tnlm4qR/HOLuMsVK33tPI5c5KTbDb4tET9goqtVy+HHRk+4ExBNDBgn0TJSY8btvFOlaN7WgcsUt/b8nxYO9jW4q9dQG689VhbBjMN4Iwaq4Q/LLLRwYp1DLlwlUaojLkeKJbM5KUwzkTTrvtgGRlZiHn/SPIyFzUKPCdJh86skvAaj7hFpiSYWG
 Ww/DYfYW
 59t80YI9KqL5d+CkEwCBmFn4KlFmzk/WqZFqCT+0N2i6ikaWOBWnOnIK/HtDH/m4zNsieXLGXrQonBGu6zd6xfVm3mph5cR88j6FpJPIlBGZqfamekrhah9Tzp0dM27s6OZaKTN2OqlzGnvW8+dDUuPirpVgBamjfn6/d5NEGzvut0jOS9tibPkI56j2olCqnN4NhiM4gvxH3C9fShgv4KGUQjXLAvV/f9JSqzhM605ssEhCw8RZktmOHg2olGi+bqNlIosu9XHuAiQ+yygSzq9H8FJ4miB7MtIV5bycUHnfbmfVS31gXt5sL9rRzYrQmt8ahWGn2RrTvx1gY/tSD92oL6n1TefkK0cSQWMwllNJK0/t8BiTtV2RwKyk8gGI9/K5CS/4A7KxbiGE8x0yjH3vyhHuxFIegQ95iegkOOq91gV+69OsvjYQmRu7quY0Jt3LHXGzE6raeVAgz2G6tSNDaD/xsto1FWNPsEvzP8k92OgdYmYoNkwjZ1sCa2R4CCDt3krMNseZZzYhUnPHIvz5Z2YIvyoSuMKxt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 01:14, Peter Xu wrote:
> [based on latest akpm/mm-new of Oct 14th, commit 36c6c5ce1b275]
> 
> v4:
> - Some cleanups within vma_can_userfault() [David]
> - Rename uffd_get_folio() to minor_get_folio() [David]
> - Remove uffd_features in vm_uffd_ops, deduce it from supported ioctls [David]
> 
> v1: https://lore.kernel.org/r/20250620190342.1780170-1-peterx@redhat.com
> v2: https://lore.kernel.org/r/20250627154655.2085903-1-peterx@redhat.com
> v3: https://lore.kernel.org/r/20250926211650.525109-1-peterx@redhat.com
> 
> This series is an alternative proposal of what Nikita proposed here on the
> initial three patches:
> 
>    https://lore.kernel.org/r/20250404154352.23078-1-kalyazin@amazon.com
> 
> This is not yet relevant to any guest-memfd support, but paving way for it.
> Here, the major goal is to make kernel modules be able to opt-in with any
> form of userfaultfd supports, like guest-memfd.  This alternative option
> should hopefully be cleaner, and avoid leaking userfault details into
> vm_ops.fault().
> 
> It also means this series does not depend on anything.  It's a pure
> refactoring of userfaultfd internals to provide a generic API, so that
> other types of files, especially RAM based, can support userfaultfd without
> touching mm/ at all.
> 
> To achieve it, this series introduced a file operation called vm_uffd_ops.
> The ops needs to be provided when a file type supports any of userfaultfd.
> 
> With that, I moved both hugetlbfs and shmem over, whenever possible.  So
> far due to concerns on exposing an uffd_copy() API, the MISSING faults are
> still separately processed and can only be done within mm/.  Hugetlbfs kept
> its special paths untouched.
> 
> An example of shmem uffd_ops:
> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
> 	.supported_ioctls	=	BIT(_UFFDIO_COPY) |
> 					BIT(_UFFDIO_ZEROPAGE) |
> 					BIT(_UFFDIO_WRITEPROTECT) |
> 					BIT(_UFFDIO_CONTINUE) |
> 					BIT(_UFFDIO_POISON),
> 	.minor_get_folio	=	shmem_uffd_get_folio,
> };

This looks better than the previous version to me.

Long term the goal should be to move all hugetlb/shmem specific stuff 
out of mm/hugetlb.c and of course, we won't be adding any new ones to 
mm/userfaultfd.c

I agree with Liam that a better interface could be providing default 
handlers for the separate ioctls [1], but there is always the option to 
evolve this interface into something like that later.


[1] 
https://lkml.kernel.org/r/frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy
-- 
Cheers

David / dhildenb


