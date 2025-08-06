Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FFBC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC7C16B008A; Wed,  6 Aug 2025 16:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F746B0092; Wed,  6 Aug 2025 16:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E956B0093; Wed,  6 Aug 2025 16:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8846F6B008A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:14:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 316E6598F7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:14:48 +0000 (UTC)
X-FDA: 83747435856.02.4F5BDB8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id BA56A18000C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:14:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IGBWDV3K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754511285; a=rsa-sha256;
	cv=none;
	b=XB6wP1U7IN4T1Ukzgmm/n4ywVVtABmUV7JVvADaIo4JZFdL/bTubalxQDgxWGsTsRl6SoX
	8TFWRVt1zWGIGvVHW88vf1IMInVP91D3rjqr1Hm9mB86RPsE/z5+jrIUqekM9ZfqDJHbJn
	9FogJ1jpmS0bt5KB76uEF1GjpLhLOW8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IGBWDV3K;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754511285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5P3sES8n4ihLK1cm4EwCWnvXovipYsvkDDRkGH7Rt8=;
	b=d0t0iwvfD1bpDa1+wTdOHgRR6ReGgF4BzJ/yAFMfGaTCf4lEDGxlHQk+Zekyitxeyt14Ft
	EWaIokWJnDslsQZlFTPOCggoiuMIhQlu3FgYfK995xd4uR7myBp+SNim5Lv8yvPfvbcax1
	lKKJkQxsp0B+Yu6IPaDAxvORVlCID/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754511285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=d5P3sES8n4ihLK1cm4EwCWnvXovipYsvkDDRkGH7Rt8=;
	b=IGBWDV3KuShD3n1w1IoeJfniyTqzgVSLnYaG12yBdHkJuwz4KczOYUYXtDMq78G1Qpa2OX
	y6hXHS2Tz11iojB/T/SgUyV89KpIYs7zfRkaGn2bYLTzVXXLA1irqDUaXVxUManD6aNDpR
	qw53AsPV65ncdlK1WRS/7EwRI9IPgp4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-ocTEwIEvOJaLgXI6trB8sA-1; Wed, 06 Aug 2025 16:14:44 -0400
X-MC-Unique: ocTEwIEvOJaLgXI6trB8sA-1
X-Mimecast-MFC-AGG-ID: ocTEwIEvOJaLgXI6trB8sA_1754511283
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-458c0845b34so1633835e9.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 13:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754511283; x=1755116083;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d5P3sES8n4ihLK1cm4EwCWnvXovipYsvkDDRkGH7Rt8=;
        b=LscMl5fVeOe9AbAG8KuMReoG2S27A82Op3vVIBB7BKSneGuWFdsl2RGQpHfDWWplFl
         ZMhJifL3AfdmB7F6Nd/zc98LYKvrA0WNTHC3N2QOchiHW9LEouasWWnRct3cS3bBQNY/
         wUYb/IzSvy5aNsr7fDYeIhjXCj1t1H1RbBG18OkK1C5bnDppshgJrBH1CMoxOslQObIj
         7FvEirchTfdlerwuIZBJGO8Fm26AoZyOTmR/zHIJctgQoD6usfNYVJFtCjgicyXET+vt
         JjJT1q92eMCFzrSGn/U6/EVkEXm7BypfrpuwcseAN/bt7MHhWX/ZqLqxXbAvvcbaqd4G
         gsBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEO9lBrJu5l3zFx7ty1x89It3rPVRetot9F7JBpu8llbn/dJvWafXUq4f8lP2NCKJ5Whe/or0aGw==@kvack.org
X-Gm-Message-State: AOJu0YwLErI8FqijsfVjcjzvU47W38rPIxOCm0FzwxEhq4mouNH/WZT5
	7AeK8t5TT2hv/MmFK825S0OOsvwDsAJqnnsGA9btpFn9/P7lQSO9NagdQZZn9VbdlAnxzTawo3k
	yit0WOX/0d9IF1pA6CFUtdudY5v7Pm94W/Bko5T3+HoaySk9wRNYa
X-Gm-Gg: ASbGncu0fZNki7Vip/7vSmt++NHb5DcKUGdG7N1znuxkbryvMLvHqz3prZX1CfIW8LS
	07nMlCh+eNguZ4lwlmda8dFZJmZJ0IymEGe8KrUVlnYj2lz70w5j57sP2SNaj73CBUjnqCMXsYW
	6jHXGOOX9Fv6gnajDLlRb/P0k5DJVaPHoL5lxWOdAdaiv53BVKNSOsTZFCI/jiu+KSiFpMxheZI
	67Mqnqk9zdDKDUIOLJh7kq6Fv33dpbpRJycb+E3eUNWCT+qZ9lSdUqd6QYzGHsHGTAv5o1/FInk
	AWxmsiErFByoEdU4aS7UvfCT7bc0xfy6P3b4sACCS33rYyZByDmnn5e5Sfwl5v7ffeMxnUcvDVV
	3mROBllLuRmihvD7xWJV8lu0Ulk84Ea8fGWLYM5aENy4723/1QZlBX58Y6rDnURVCroA=
X-Received: by 2002:a05:6000:2388:b0:3b7:8146:4640 with SMTP id ffacd0b85a97d-3b8f9f79c9emr194012f8f.56.1754511282657;
        Wed, 06 Aug 2025 13:14:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHG0bY644qbBT42RA/yeTwcYjH2tuKmM7gFFv+ZX33Fj0TwtCMSS0ZQLo9cfyNEiDWpFtTRyg==
X-Received: by 2002:a05:6000:2388:b0:3b7:8146:4640 with SMTP id ffacd0b85a97d-3b8f9f79c9emr193986f8f.56.1754511282226;
        Wed, 06 Aug 2025 13:14:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:da00:badf:cc55:23d5:1679? (p200300d82f42da00badfcc5523d51679.dip0.t-ipconnect.de. [2003:d8:2f42:da00:badf:cc55:23d5:1679])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459c58ed0ecsm81898565e9.4.2025.08.06.13.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 13:14:41 -0700 (PDT)
Message-ID: <055a8a69-731d-43b8-887e-54d8718877cb@redhat.com>
Date: Wed, 6 Aug 2025 22:14:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page
 as-is
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Takero Funaki <flintglass@gmail.com>
References: <20250805002954.1496-1-sj@kernel.org>
 <761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com>
 <CAKEwX=MVBJ+Okfsob4Z30_5Y4P8c2DWoS1dYN4dF5dgp4+CexA@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <CAKEwX=MVBJ+Okfsob4Z30_5Y4P8c2DWoS1dYN4dF5dgp4+CexA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LLvDLJwgY6lbGyQc4OanS8FJjoLw3mW8Dhl70Uc2lYA_1754511283
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA56A18000C
X-Stat-Signature: ax7xbnhsd53cf66e4r8x6b8zgs8nuszs
X-HE-Tag: 1754511285-679512
X-HE-Meta: U2FsdGVkX1+VmJvK/rQ8/yBfSY+HDHRqf1kH5Vr6fSO8WK+MM7BU2R9KcdUa/vmkbEM3ZjmNH0ke1E8W0Ps1cqEHRdN+yp/Tm8nYBlAEPyvVRXUtNyWxc/Gimo4OHJnW4Oj9/RFgmnShSXmnU4T5LVw7y1UOd7Y2fLRD3h9TLUUxAFQAxkJOAlQeGrD/hy60IXwIYdDe/ldShqWN3lbqBpxd0/QZvni7BQNcqE+lrMPBvb4efhVKxbmSzsezOt4FqE5DHSW2vdXNDIcrgtL53wT1wpwekJo8A1mPoWWIywbEStmhAfw1xFLJKnic47HAk5rcOCLERcXNMVoCqX2dGdvwfRgKmjRm7Sunu2RaSrX/OJH4afgJzH1vBm7Aakk2eCUcZgpf/FIqEOv1Jn6On6WLXg574GNa5R8+i6bXEM4nI61KTMD3UXBPbENyzL8kh+tRTFw5hwQBOT0YI9LUnC1+OEvVnU1DBHhb6Mm7ePkZHgDKDvnOmVlfo/RRHY9fTltgFPPBHqy9czTohx4Owy8ALUa5OoXitsqO7C9OMW8J7wMEcN8fH3e/Eme6T/zpoK+RhAXslWQR1LlaCtB1TI4K2migzLuGlgiLSL+fiDdwuPG1SdE3lAQ7+oyoZbOqSQgfslZWBDZFgMh+MXu00WaC3+h6YI7Atxc1hsUwM3sB+fzuUkrqGRXv4EGNQoOVR5xG487zQKjzCfjfMEh5FCZkGlKS0Qd3bzgoOPZy2IrnM+QnpWAgS6SKbfwuWQkrJ46Tr+feNBJ4EuKFtm25dbbk0U5TgtCiERqM/FG8i9scCMl1T0vQLl8KnRP8/fB+qOXdYyDUZ0fL1+QolZb1MwmBQWc3Qk4Gnmp/VaUnuE1UH+kmsh9G0fHqK4dYP8HgR7QP8rZyhoEsI9bvgtPEznd/BbmVSJYZ+H1D6dl9Tr70h4VquSP15o6YReq5ceaSNy41ZufH/fd/xgbQUUL
 e8Tl2yfs
 KVtsF6HwVXqT/XtCChxyHYbNde5E58sA3Fzi47fhLtqr0bPQUmhi4CuT8JKuJh7nl+UU7evf/pFwmBBf3ReNHnjvms91RRTTKg6i8vGIiBOSw2CwEHH5w5rFVmiKebSAHUTbXtvZIOpHsyoiUZsA2l6MCYsFZFC7Mjey6YuaQhGNRzpB5GYIh9gbSqki04fSxxcsB6OGfy4YxyAvv6zoK3RR9lS6IfqrKFhzD6WsRQxjGWO+v9p82X74E7GtgvnpmdFQo5YcERmcfaqi2/dU0MHIVecJy+KO4vpZ/6LUkuIIbBi/xxFroJyk/BzIbBu0EoVFh3Fwk4G+/kUzI7bomauAsbg+iJVdBr483vqe9V8Dm9dygtz2ViZ5YMxrnPsaRxlNG9523+N8bn2BAuMA2KiWNH8b10aORw3bbIiKlg6YNidoFxTuuJ30lUwsS54dh16+XpBuWjzL+j91CXkt1ThQTRPELlo4m8yJOEnJKiN7EAzdJDv9VJnUoskq0wBMEq6Ny6DRl2fCVxy4icaNqLBlcYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.08.25 18:56, Nhat Pham wrote:
> On Tue, Aug 5, 2025 at 3:47 AM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 05.08.25 02:29, SeongJae Park wrote:
>>> When zswap writeback is enabled and it fails compressing a given page,
>>> the page is swapped out to the backing swap device.  This behavior
>>> breaks the zswap's writeback LRU order, and hence users can experience
>>> unexpected latency spikes.  If the page is compressed without failure,
>>> but results in a size of PAGE_SIZE, the LRU order is kept, but the
>>> decompression overhead for loading the page back on the later access is
>>> unnecessary.
>>>
>>> Keep the LRU order and optimize unnecessary decompression overheads in
>>> the cases, by storing the original content in zpool as-is.
>>
>> Does this have any effect on the movability of the given page? IOW, does
>> page migration etc. still work when we store an ordinary page of an
>> shmem/anon folio here?
> 
> Good question. This depends on the backend allocator of zswap, but the
> only backend allocator remaining (zsmalloc) does implement page
> migration.

Right, but migration of these pages works completely different than 
folio migration.

But I think the part I was missing: we are still performing a copy to 
another page, it's just that we don't perform any compression.

So I guess *breaking* movability of folios is not a concern.

But yeah, whether these "as is" pages are movable or not is a good 
question as well -- in particular when zsmalloc supports page migration 
and the "as is" pages would not.

Maybe someone familiar with the code could shed a light on that.

-- 
Cheers,

David / dhildenb


