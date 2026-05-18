Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C172CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 00:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEFD6B0005; Sun, 17 May 2026 20:01:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E384B6B0088; Sun, 17 May 2026 20:01:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFC06B008C; Sun, 17 May 2026 20:01:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA90C6B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 20:01:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F8D1A070D
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:01:15 +0000 (UTC)
X-FDA: 84778585710.08.AB8518D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2AA3F1C0008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 00:01:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vybDDYAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779062473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKJ0GIdrQZ+0fdlVCx5KnDan79ZYiW4d/BySO2ZOIkk=;
	b=Esy/orQadXPFi22nYKqOvYL4PE2exppxgZcCZx3RFlw8o5Q6i57BvVymy1L6xjBA4Jw24A
	Gm4NYipiloAqa6oTm4g131OdIolftCfeIA15Z3uOZiO7nL/KyTTwmvV4ZpG/DD2JB9gCDX
	F1dO2SpFqj+EY2bSt6i4/Bf8YgXm0zE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779062473; a=rsa-sha256;
	cv=none;
	b=S0FlOEulINpGmR8oMFaOtuU6sK6yxVHWUyz4i/guz3CKgaP/FcrOvuAUjWjJS/VzCis5iA
	t1yhU3p6jj3bVA7l7Kqltad7IE9GwjWmhexEOsl3jvtMmj/gbUKc+RORVF5Iny71/RVxT+
	icw4MrI5GRrVJwvpGsbwj7fbDw6Txms=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vybDDYAs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779062469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKJ0GIdrQZ+0fdlVCx5KnDan79ZYiW4d/BySO2ZOIkk=;
	b=vybDDYAsuAXRF40f0J8gb0totqZwE9Nq8RWa3PS9ubrpbmS6Z0uxtKv90cyHltEs7hNSHx
	QSrwoDljVmr0eH4rHUelo2oCe09kKPYl++d1OKxQaaZeS46zXuYHxtf5eAWcEhFdt+xNBN
	rrDCMmjK4anHSMhfAzT/wFJlV2lKaLc=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 17 May 2026 17:00:53 -0700
Message-Id: <DILD08GPOB5V.3ETE6IM4W9L0U@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
 <rppt@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>,
 <derkling@google.com>, <reijiw@google.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, <patrick.roy@linux.dev>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, "Andy Lutomirski"
 <luto@kernel.org>, "David Kaplan" <david.kaplan@amd.com>, "Thomas Gleixner"
 <tglx@kernel.org>, "Yosry Ahmed" <yosry@kernel.org>
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
 <00d11da5-437e-4f3a-88cf-66ab0a729cd1@kernel.org>
In-Reply-To: <00d11da5-437e-4f3a-88cf-66ab0a729cd1@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2AA3F1C0008
X-Stat-Signature: 59tbnp3dz7pe3kjb7cjdg1mymn1ie5iu
X-Rspam-User: 
X-HE-Tag: 1779062472-946280
X-HE-Meta: U2FsdGVkX1/G7SPxX/STCoYyOVUX8svShRPVqjujRDMFGjk7C3Xdwbu+A2FSqQYeQy2FrClfqrFLnWgmuCAdQsb0bONFN1XsXxkD/mxSYUr5hto2bvxVgSLwLYwI/wr/RN9VBcx9B+HrzlmA2fcPz6Tgvsm+FtSzmH2wqIp841eoLj0HIL+aVpWHoR66DQDSCiQzgBSemqXd1yo8Q92BvLTd/2lLqbShnsZicmUIWVJdeDUht7rw/L3ybJXPR2EhV1qsnKoFfb9HVQ/dawm3ARZFV+Tfv/SsdqVKvuzlIekHFvIFEsHHN2LkTWZ2EH4ICfDbWimVjZM/+WHMbkDRWVrg4PZz9ySL8H3MU8EvvFTczOeLwX1iTzGNGs6Gf9gSt2O2LExz/L82XKM+nRcJnYmFusM6cLBZjDuyymlt4K7wjiCofOMRMepF6NZ1H4MEhMiMg5JI5wbvD7FSxRR5gXEFtAhTwfIkCgORezMb8E/jvow7pDSiTm0L+u12cVtb5/FIha2q4viOputGxL7hjKPJEF9ZnzMQ9L/UJpzNZ4CeCwIyVm1M/dr7Aedbj0QscrozHSII2QeaQtqI3pYKJDmvpCKr6CMvVDtaLP+Qxh7ikMpRGjZ/ccnmjXToiruZh15f8fcOweWlcLqmXiV24mMAbIn5V4KoynARhj0P5q2JzJRSstjqxcbDaSINnYTsmcr2zbxp/sBeOarqyLy5z3nUJiV8ygSeCovnP3t91sV7oxdFJkqxvhY/ELfrFFlOz8hSudXxge/1IKKI84I3VBU2bMfNMv3LsTsKVRuK4P00MNNy01wxmnlE8SgxRLO7/Pkp8D65QVLb5Fb1w9Iq/Oj/tutvh20stdAC5FamuodLqo6JETzIPd4NUIYQV4tK4h4gRX301ojvSaU+nFYSE5P3oNobVBgSFxywz7aMoE+3y6tvhLiKb/xdAgqz2o85MI1dV/iQ63K2+yGiAp5
 xw6NRo8l
 TS8opdFtX2fyp6h1pWeuap9sqrbdXZmz0jYTuP1gJ1l4gCxr8+9efjj87l8NDiyuya+kDVJgFaKUsED/7qqClkYRHI+b+U+glQLQZnnqxnzkF7COGJlrRQ0zIrHddoDWMW5meBfdaQGSyjOrnhORQm0mE/wFJg9iv0P5XbuJeHc4WIogoNQLF1C8tWMu6TaZxEAGF7kMpSCuehwkcOS41Km54byV/j9CoPfszfL3/aWx/Zj5j15Q9hKMoxV94qxxb2SwlQBMyUf2WM0KrWLjG7iP+TEg7PtexX3lDGqqrzwaWOO8gq5hbMFTghLA94VN4A6sH0I+2odMuH0qsUKIPIOU+NikwskbzjCXPYPPWMLerNGULmidysYzEEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon May 11, 2026 at 11:26 AM PDT, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 19:23, Brendan Jackman wrote:
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -422,6 +422,37 @@ bool get_pfnblock_bit(const struct page *page, unsi=
gned long pfn,
>>  	return test_bit(bitidx + pb_bit, bitmap_word);
>>  }
>> =20
>> +/**
>> + * __get_pfnblock_freetype - Return the freetype of a pageblock, option=
ally
>> + * ignoring the fact that it's currently isolated.
>> + * @page: The page within the block of interest
>> + * @pfn: The target page frame number
>> + * @ignore_iso: If isolated, return the migratetype that the block had =
before
>> + *              isolation.
>> + */
>> +__always_inline freetype_t
>> +__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
>> +			bool ignore_iso)
>
> Hm I also noticed ignore_iso is ... ignored until later patch.

BTW just to note, Sashiko spotted this bug too:

https://sashiko.dev/#/patchset/20260320-page_alloc-unmapped-v2-0-28bf1bd54f=
41%40google.com

