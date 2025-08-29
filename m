Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E23FCA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 10:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3DA8E000B; Fri, 29 Aug 2025 06:07:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59E48E0001; Fri, 29 Aug 2025 06:07:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43338E000B; Fri, 29 Aug 2025 06:07:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B10018E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:07:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 63FB085342
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:07:54 +0000 (UTC)
X-FDA: 83829368868.24.83865E2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id DBA4418000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:07:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKqynbGJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756462072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/nFDMhWq8V1oJTJ8TEj89R3ylFApbzlPBSZ+h+c35U=;
	b=a3miyzB7qP57xdBwJHLbC+C/264ATUDPivbWketQ37Oftb31XuI6gh4kDWSr0nzF4QZ1AP
	NvX+4hOGGk8sruE8jXcPPrNQcRBtMKNc1FEdX73Pf/Kf+m2VeFgqHNOIc7jpX0b6VVeLGv
	MMDr5Os/yTdRJbqJkOYKnQeiE7V7pNo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EKqynbGJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756462072; a=rsa-sha256;
	cv=none;
	b=mvrkOe324UOeFkrzhiLay7BDYDb7D8t8lXZxx+E6Z+lo0GRKJee38mph01JZmH5Axy/Lb9
	ZrrXJ84QWlOohKcEmjHRIOWUs6Z2nSqqWeaj6gZ65Q2vX1H+FM1afrE80LOHSuSy8uDcan
	UgYbA9GTjO+FKZr9tPuD6EiTI7HWpwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756462071;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=R/nFDMhWq8V1oJTJ8TEj89R3ylFApbzlPBSZ+h+c35U=;
	b=EKqynbGJN8N/UBZZpeafhuKxcmp5NhqhQAjTPSb1b2aZYJR03BkRW56KZzY5HZSDlJQhZw
	aIlF8CUhD73Yt4CyoHofgugUnxhX03MogdBfp61FN7bTu38HcZrowFVqC3EVeqGB4BGEaL
	eP6uj2eBu68BzCEI7XqgwmaXlKnoZIQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-MTtazgCQOEaFxZ_qWKJkdw-1; Fri, 29 Aug 2025 06:07:49 -0400
X-MC-Unique: MTtazgCQOEaFxZ_qWKJkdw-1
X-Mimecast-MFC-AGG-ID: MTtazgCQOEaFxZ_qWKJkdw_1756462068
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so20269715e9.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756462068; x=1757066868;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/nFDMhWq8V1oJTJ8TEj89R3ylFApbzlPBSZ+h+c35U=;
        b=p9uBXblqcKKfDAFIK+baPJ+2eL/VRrSchSz9Hmi64YVI+zkfEz9gWagzWX48SD+qWK
         YN2FOMTrMjnX4EQpwdi8RjrYyry5YuQK9OnRx92Lw8KmRoI2d2UqEN24dEVOzMbbFNtb
         jtp0ysyCj5Juf29W1bMPJY8SA0l21uI0nu7vbiIFhVkxLlgu6319dy1qVtQ8pBWxUTut
         DrB59jJ9VG9wlVcdhJRrsjL2K/E4dPLyvVBmc4xh81//k6RFD/wzoz10Ot2CUMoU5UNk
         lSWwLPJuwg1svy1BK0qTdOovg/ytmuE2opM7ARABcwTD16N/pxdsa7vVy9FRU3c3o1FT
         ygDA==
X-Forwarded-Encrypted: i=1; AJvYcCUpjYwBHSXZkUXUUR616WLn03tFPbYwhUCDrCb3IzdH4HD6Lvv10IjBDiygYmvS2X/TubjUjQCUtw==@kvack.org
X-Gm-Message-State: AOJu0Yz5oqQaYLZ0onKe2jvZSySswJagQm0yShIQHT1KS90z1ql3CEka
	4GjxOV1dorAtzEwc6EAefQTw0IajQhHslaFqmm57RLip9QS59L4yg/2dI9kqp6FBDKyzPopB0h+
	x9Kk8S7OY4PSJwrHmI1z9QTN127yl1MVNgsiD3ZOATJC1j2Hqa145
X-Gm-Gg: ASbGncuQjriVKEasl+EwNvOKT42X5fNI71BPLpMPiK+2EmhBDt3HxaveybuAYt8GPFq
	gZv8f334l6MVN2A5yBbV+exb8+iKgnXhXNlAkvz8Mrk/tyLUWmn0jYp92WZJceaGDPWwKTiI40h
	ku7YsAYJD2/FmIp2xgy84l4gcliFqa44xvT9zQQ+AiY/ZtwHruNVt+YPhzhF2gEak8bVr1wKeDk
	HO1klAkW5/CgSZE+xhZq8Ixd0KE1kcgG9g1zj0eTe3EUrUKl+72PDGCkCOxjvM5GTRKjMtQ6YD7
	HzMa6RCSJNcdYil68rbhO/XolSy+xfdzEwas5LpCqBGS94RRI0hoAqnkqRe+Hdouwq6z15aJP5t
	Jic9LtuU4Y6jA73Vynw070+1RB9pnDxcuWtLZPm4T3sHgyL8PD7CRgbQKgYeBC2ZJ
X-Received: by 2002:a05:6000:1786:b0:3ce:bf23:3c15 with SMTP id ffacd0b85a97d-3cebf2345e6mr2871185f8f.26.1756462068017;
        Fri, 29 Aug 2025 03:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEbF2u4cnQY/Ogsj0UXNN5LpFf/sHGS9HbsWWK0zqGpfLoa5VGc3wGgA3I8pweyh4XaTKNy7Q==
X-Received: by 2002:a05:6000:1786:b0:3ce:bf23:3c15 with SMTP id ffacd0b85a97d-3cebf2345e6mr2871142f8f.26.1756462067529;
        Fri, 29 Aug 2025 03:07:47 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add7f2sm2910573f8f.32.2025.08.29.03.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 03:07:47 -0700 (PDT)
Message-ID: <5f6e49fa-4c1c-4ece-ba67-0e140e2685da@redhat.com>
Date: Fri, 29 Aug 2025 12:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/36] mm/hugetlb: check for unreasonable folio sizes
 when registering hstate
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-9-david@redhat.com>
 <fa3425dd-df25-4a0b-a27e-614c81d301c4@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <fa3425dd-df25-4a0b-a27e-614c81d301c4@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lF10O-_nZ5IupZ8yVABGuhMcXOTi-hRSyg0uOpsA1RQ_1756462068
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DBA4418000D
X-Stat-Signature: t5rfw3hqomwp3pf74594fg3ocwst4guk
X-Rspam-User: 
X-HE-Tag: 1756462071-519525
X-HE-Meta: U2FsdGVkX1/g2DMle1nw0nDmHTDJQdVer0QIQwBnU5gB4pSzgLbjxFLkKTMKVGIg0mLS5Ph5Uxgj+eXjkPn/cp1sqjyUfctxtOdobUqyKbay0Xx0RLTr4cGkRrdj/1sBkKLnmuGPpxPBCJKgI7QtLMleJPqr18LDk3i1Z9yRGFpCCkugiDkdi5DxNQispBFEERLRHCVOIIlHXXUGZBOJnX2bGrlQ+l+haBRVtNEFmwRHePHc250dODmMcffBz/ub8d5vmdSRDZYWankqD/qzufiIBgRsfRBM2Ds7STVJYFn3ndDVsED0HFkl4Z6CcOsZ51mEWx63rAwShAMlt/Rwo3uTndw+h8kJ865kNCxudt4LQDMqmQhF8y4uNpfJ2bauxOpd804Ywgi1/9GxxwppBvLApd3YGvFvjuupzHH7s7RLEar/t7iwvt8xYR94c3Bs4fNfNWpYtf96SVVVrtGIlcHQFLM3hXovRQsZrcZpUwzc8TGb9dGXo2Jk5pSwMbdzFHBasdBc+88TjknSH/fBykKtAg4TesYubChzLD1GgfVTMKxmjPKMURkXm0V04IqIWiFcb1OlwuXKEzalA4slGnxLo64Yr2MyRmbNFtEL9pE1lsgHZiPU1Sq28Y6zVwmdqdx+/LO5KgovGm/PPeXpRuU4qZ9glBm5cPt/0uUODn50O1Uab3F6EFRnyNWwgMiMf/OiZXcFrbtFoArF0Zr8vIclRbE3+R+Tue+5/Lft2DY2JDCjInsrfdiqhHvm4qKwgmr34Yv4ZKHncxmWb4cc19GsI8L620ha6+EUBBzq7PqiH1VOqceI59oUs8532xSiOcDwh93X5399pKFcpYvlsqZAhRAjjIct/MKMW+9zWHT2nItC/ZfcEwhuO6uBxXkDmv6q5t2wPoq+EMNhBqWy+xvoqm0ey/guNvroo05wfz1SrEelUx5dVvbyWn9M6cedG1ZleU/3TeTwS4JTm+b
 13NDix+r
 kjDAwnBBi4QPZqBjWzUWGmk7MXdNwypev3SyMRUJnHZIsp1oC6RPHZWj4/kySCHJVAnSa7uEI4fQM6JNEvB3Rq/4rZnnyr0zr2MbmwML27EzE6t8dSZIRxrc+NEfeYe7T1EFDN/9BIHdCVqhrqgi499Q88F4Ksl36n8pIoXPPKHIJC3kDK3ADSoTWOdNL5g3lOtdHGXLD27O+HvedTh+Jnl9e9aybR5ZUG1BSZWLYj4z5nDCYhJYzd7Wjm2VYOQyvSKpQgW09AxXcfeuZXlz4DBAjcEP9IXohTzJxKqx15i5erLgLHjEAch/sP90gSXZV+xGsp4VGnVK+6iXvIY///lF0wBfY64VMuxGh25KLLaF37mc9OdibeMAtdbum7+ilP2/Btx9avrgdt2LWajIPwyJk8pmJGgjMvVj3kIVqjNbX6zswveJ7J29xSnz8FhUwJmywyVMBOIUG7Yk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 16:45, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:12AM +0200, David Hildenbrand wrote:
>> Let's check that no hstate that corresponds to an unreasonable folio size
>> is registered by an architecture. If we were to succeed registering, we
>> could later try allocating an unsupported gigantic folio size.
>>
>> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
>> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
>> to use a BUILD_BUG_ON_INVALID() to make it compile.
>>
>> No existing kernel configuration should be able to trigger this check:
>> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
>> gigantic folios will not exceed a memory section (the case on sparse).
> 
> I am guessing it's implicit that MAX_FOLIO_ORDER <= section size?

Yes, we have a build-time bug that somewhere.

-- 
Cheers

David / dhildenb


