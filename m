Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4EEDC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 05:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DB46B0088; Wed, 23 Sep 2026 01:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DD06B008A; Wed, 23 Sep 2026 01:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD2A6B008C; Wed, 23 Sep 2026 01:29:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76C566B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:29:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6DDC71A06A1
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:29:53 +0000 (UTC)
X-FDA: 85243900266.22.CA8BD2C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id DAA48140004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:29:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e+1vUWUJ;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790141391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2vrYuRJ8qL5kWsy9Tz/qOHqUgXc8+IhHfJ0Nm3O5oI=;
	b=k4hZe7b64YyG1eeG1554EVgZ/ejXCUfsac8/1njYLrguSL1kBDf7rEfpDiVTJLyQCHrDit
	bN6iX/7Mes784Rr7I1N8SjCcDDher2fLh9A1YZNeT0Ume1A94QX1NwyWIKlpjtNQlljHCS
	w6PbeKYUJF3mIDEjH6XSVAOh4hHd1Wo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=e+1vUWUJ;
	spf=pass (imf23.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790141391;
	b=MN3+10u3F/gtnSTEtzfsKr74bK1OE2Dc24KxUhtlNJX1alIUr8kfu9U8QUXl8YoVH7FQHH
	IYMtbzqlGRQ1Y80JtS/rokvg6PP15Mz2Emi1RRQC2/ML6OwZQJgaga/b9vEFiUFUFMKijR
	qogRXYjDWeD/dYYnlLgV7qcnqFjxcOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790141390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2vrYuRJ8qL5kWsy9Tz/qOHqUgXc8+IhHfJ0Nm3O5oI=;
	b=e+1vUWUJzuXaZZOaj+ck6I4B8IkNdBLNwCKHCyuuWSQwx/OMMf790TE1UmDH+sawY1ciBO
	1Kk4cpwnBmL56dfJQdFv/xGXbKCrLyIMkNPsLo5rgxDJe651N4hj32KgQk+BF4GlH4nf66
	GEFnOE8Mp24Bhy5DYU7yrXZwrAlgw5w=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-iRKrHIxjNOSgomQLv0FjOw-1; Wed, 23 Sep 2026 01:29:38 -0400
X-MC-Unique: iRKrHIxjNOSgomQLv0FjOw-1
X-Mimecast-MFC-AGG-ID: iRKrHIxjNOSgomQLv0FjOw_1790141377
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a592f20c7cso2377991fa.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:29:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790141377; x=1790746177;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w2vrYuRJ8qL5kWsy9Tz/qOHqUgXc8+IhHfJ0Nm3O5oI=;
        b=gvxx5Mo2emkgOnD3uFkECPwJ11blSS9S5+gUsl2iwi60VRvJAkNJ9lm+uxqNL1L003
         acdE6bVatTHX+InlowdBIgjMS7jAvM0gRx+kfmhGy4pvsdvh/u3lD80uv1nO3XKYXkBB
         oFD6/lvvI18oK/qtTNYm+4HaAkPaI25Sn2AlvVIsjOg3WEv/79Y4uX0XTrQ1RSCGey6X
         P9aZzzaAstjpQ+IOywVu2R7OtTLRZRLbVedY3XtsieEosSzEP3ALlDsPG3791jAqjdKF
         lhon0KgvtRFM2+5iD7rDb2nYCee5P71ZntSQv0NtzFNGBOqNTV3wF6jM7nOUq7EiMetv
         /ehQ==
X-Gm-Message-State: AFuF++koCTu/rOCimBQfOB1GZRdJWgjVPViiI6CAfrLN207BgwLuQbFu
	vsgeaHWY0653ccWOwUv7ARB57ozUneFaF+mYMwd1aaelWsMHIfZUi5tB45X2fH3/ZP9HnQZCeED
	3knOylgXsZf8jyuo5T8Z2cgphtTozvGcaMV6TgYDoLgqWCa4lOqc=
X-Gm-Gg: AYBFou0KHk3vdbvD4UxbWjX30EdD6UDcHAzJCb7u/NC9u3VulVPp9a+h+HeOzZQo1TF
	KOXMmWuUxYOh4IVgPWGJXooRw4ounWKQH2AHYtKqKQgeOxVT6lmrqhZC+FUnS1gPt8Aer5mRSkQ
	EAYdFnUnKsa7Jb/yTLaBwzd1oBi5Tg/+Makh2UcVwbMK8L2jbUUCffgIO9n5D7eZO3K7nuuy9W4
	YGxJVJ4Wnzeg0M3qoabbXj1qBlDbfHykFlxmBM+pEhiyGGRx50Be2FRURtWjWiQbPG8+EvPc0VU
	68UStDJ3gIE60uKe7BhEs7tv8Qf8coDYelCg9Ebd5OpdRs3K9bZ7dVEIsPwuEpdPvJSC2CRLK9Y
	Ps7ewmfG0a5wM+kgTj+S9ZhAdz7WoCyk=
X-Received: by 2002:a05:651c:2119:b0:3a1:980f:5907 with SMTP id 38308e7fff4ca-3a63062bc97mr2957831fa.8.1790141376712;
        Tue, 22 Sep 2026 22:29:36 -0700 (PDT)
X-Received: by 2002:a05:651c:2119:b0:3a1:980f:5907 with SMTP id 38308e7fff4ca-3a63062bc97mr2957691fa.8.1790141376203;
        Tue, 22 Sep 2026 22:29:36 -0700 (PDT)
Received: from [192.168.1.86] (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a62f507e7bsm3916101fa.22.2026.09.22.22.29.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 22:29:35 -0700 (PDT)
Message-ID: <5b1d0fa6-d183-446e-bc52-56e0afd3f398@redhat.com>
Date: Wed, 23 Sep 2026 08:29:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/12] [PATCH v14 00/12] migrate on fault for device pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
 intel-xe@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
 <20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20260922192726.90dec3c4c77b8c9063dbf218@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TzvQ13caamcvC7sXgCk21xBu92qk786kjTd5artXk7k_1790141377
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zgkiq3wyhn7u841mty1mujg6tmmr6xdd
X-Rspamd-Queue-Id: DAA48140004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790141390-807182
X-HE-Meta: U2FsdGVkX1/1/9gABccrCPDaUkx/YIpFJ8w5Zhclmx+szKFgdmthEWOQZgoggT6Ubz+T/NWclQu1uJdwEUzAv7AGpJsUztIVLzKERKgfyXnYXu/HX/3FjwanJ8Awy1OIbdws29sl+30LzmZwGZW5kCw+iSy9JSFrLn51nXGFNDHAeuBRc47N7n2wdAhkuy89QSSLBSdlpP7qMYt/k51p1SessB6Yo/Up26dID2bPVYOmgpNoflcYG2kAW7XykhKjaQutYfm/8pyhbAkgKalKoR9M+KBJaIEX4ZsLwzNrJhomS0DecDTQHZ27OfEqP2VUkeIfvld/GAkJ5x5TtN30GiNJYC83HXaaIx918DGV69b44tTYhEsC2dSeiVyeAqtqOyaOcpWgwrvDej11PMeB6Cn5eLCLGRmifhJ2Lqv/bmv3ZyBgwrF3uZerre+KziVi3jb6qqbuINOe3nubhCeFON13dW7slRpL3Rjv7x9PU9RzVT8gheoTlizGt48K/w/sGxm/W5zV1GRGS2Vi18P5RcVQexoel8ei414n6303FFn4taCd4ST4xgHqprOZpathJi1+42dfyxbQxKPd8AmR6ARWupGNQB/GrHcPThrDlMKymlHcUkyz6JO5n1Jo11Ux3alEgZaIAWSKyqwBsqPStWYBkuaT+rj8j+eaLAi4oXBo9vRpMexXz4rx/JPOUK/NpiK+/PmIP5Az5B6cvxzMMpB4DOqh4gh2A/f1Eom4q2JGSGA7n5XWwhC3hUPLJ2gv4mqyuXRpWOfAhske6YUK2LqVrn5Sbi/hw3uUQXPpfTZjxGjYYtkg+/LHNRXt/o9TKTkoc4XlsgC1JuWuz9arWJ4Js82NjQCqGocloTHFiZysV4ibw9UJvSqyy1LUKdj6WxU3Ga5a/EKUtVBf2YBM2u0wucrk0MsTDA9oDHNfAoshxW6/DhUjCrtcJaBb5pZR7z8g1cA9Iop/PSLzQQp
 gTEAiSAo
 7oHZ3Gk6GxJZKL20KM2e7QBY02cNgSPbpiFScRasTzwihNmopkZLwwL0xVK6pnCm20p/9VDfq0erAPnt+Uvv8YjTq41Ngw7Pqtx4HXVoQgnVvMwbjxSNBArtD5GhPKvShDAcflfzLq8FHkCy0Db27k2EbSX2T48ePbs7Wnhbq8Pvb3cyPWnScXyHrB5iXiMJaKDpFKPP3MBHLRZ2nskY4qYxpozQpvO7Y+kMRL2ecqwU5P+G7VkyCsVqWZd70tY6WgerIAWrCxNYxxPTAtTiPWEYrLcRsfT7i8Rk4Fm41xXWmLthNWQBMGBrvjmYqWQbpb6IV54ABZO0U7uMCldpi7qdKicZOMiruzEJTv9vwEFS0I3ZZkval/PoGE1dtbKU/jLweJFObe9w/SPcf64nIxTx+b3SqBCfTSWABP36sow10iFTrF69vMzubApTCLZu20C9rRiAEkQ78sWEftr/gLr6PmqfetCKWdYjD9fM9v8ei/Ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/23/26 05:27, Andrew Morton wrote:

> On Tue, 22 Sep 2026 08:34:09 +0300 mpenttil@redhat.com wrote:
>
>> From: Mika Penttilä <mpenttil@redhat.com>
>>
>> Currently, the way device page faulting and migration works
>> is not optimal, if you want to do both fault handling and
>> migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the
>> following sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It is also tricky to code correctly. One page table walk
>> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
> Sounds sensible.
>
>> Tested in X86-64 VM with HMM test device, passing the selftests.
>> For performance, the migrate throughput tests from the selftests
>> show similar numbers (within error margin) as unmodified kernel.
> But no performance benefits are demonstrated?

There are no performance regressions for current tests.
Real benefits come if want to do migrate on fault.
For migrate on fault today missing pages are collected as not-present and
the caller has to fault them and re-run migrate_vma_setup(); folding 
HMM_PFN_REQ_FAULT into the collecting walk removes that extra
fault+retry round-trip, dropping two page table walks. Page table walks
are not cheap. Not to mention simplified implementation for driver.
Also, the vma looked up as part of the walk is readily available for
migration, eliminating the need for explicit vma lookup - one more
performance benefit. Net effect two saved page table walks and
one vma lookup.
This series also addresses the vanished/reborn page table while
collecting problem which can crash current implementation.

--Mika


