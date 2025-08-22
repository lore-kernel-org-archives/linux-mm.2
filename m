Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F6BCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C67F6B8007; Fri, 22 Aug 2025 14:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C998E009D; Fri, 22 Aug 2025 14:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B816B8007; Fri, 22 Aug 2025 14:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8CFF8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:10:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A51A7138367
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:10:03 +0000 (UTC)
X-FDA: 83805182286.16.4C58F1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34F0C20007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:10:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NIdGcyDJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755886201; a=rsa-sha256;
	cv=none;
	b=XzmPP1O1WGy5oAKWBhQHd7ZOCII46YLHy6Q7SBpoib/1Sg2Nd+mxii4UBtxhXHYfkgGqNM
	FAmFcfU2vDG7LH8MBDIW6xQ1//koFjsngHyECFtqrK+1aCAoDtBgEJ7BNhMCNyLIuaXfPQ
	bFGMwYKeZ04XYF9Brebb6tzYqyTr5C8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NIdGcyDJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755886201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Qgw45kgIvklypQIdjW4WKJClwzbVj1vFIwI4+ABCxY=;
	b=FBoMKeDKMxsQJaQZU7m9+2VoY/D8nvIoPsM4b6jPsuiZnI0EYICS6GtMIoFkXpc3KMe9rW
	SliKalTmmy07iliduStWLzggo4R9PEQpJfoTIrKapgg7z9CdwzOQG/fH9tBiTAjziWzOmK
	XlZiGp2sSt46YZ5Dj2S85p5W9Le+eIg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755886200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4Qgw45kgIvklypQIdjW4WKJClwzbVj1vFIwI4+ABCxY=;
	b=NIdGcyDJgCcIFOcCzDrWMG+Isy+eVOFGZlpWnHftHr9DTyZMBLOHWnOft93ylUKPFqFAM5
	+CSHQoTv92HH2FDkPU0dyWHPZ+W/G+TLfNnaNP+Q7+A7kJy/C+6mID4KuHMFwyV3SgQQki
	GQmUhnfwGWTjNMXI9Rjo9WSt9aF4TSY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-TTtDHZDcNAyHcxMj-cjOrw-1; Fri, 22 Aug 2025 14:09:59 -0400
X-MC-Unique: TTtDHZDcNAyHcxMj-cjOrw-1
X-Mimecast-MFC-AGG-ID: TTtDHZDcNAyHcxMj-cjOrw_1755886198
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0b46bbso11561765e9.2
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755886198; x=1756490998;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Qgw45kgIvklypQIdjW4WKJClwzbVj1vFIwI4+ABCxY=;
        b=a3um+y3XfED02WmeP8pSwLStXH7BIerjQVEvZfsKy9vY7xrbUJ691Q7taoChoeMNPm
         MygutxaO+CYBXxaINGOld+/y62yRHRARtS6w9zvCwSk0htumExeq2xPPcSp79pYamdKw
         TCDnyGMey7ChXp7RSPQak1mizCf5GFghXgKhJ3IMkpwleG9q1LWHdSHjsjMqNCPxJUi4
         jun4tEgmdXe/gPwVFWQj30RQ0I6/NgPljEUGpgwyfVNqBUMe9gm0LTyFCF+5tbUgYw1y
         JQbT2xvoEXs7ZwiK0wPuiVcn/BtcTGe76BCvFWtBSGIoehu8jYzBrKPTqL/QjuIyfxmK
         1XaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVenJVXhoYZVanVJH4nMbXONnfc/iwVzqEsmSACG5eq+b74/FeETwJn1UoZ88mQwNVwwguoWp2k4A==@kvack.org
X-Gm-Message-State: AOJu0YzFgAQtpY3C2vtVVdgwNgxXbFCxnIebApCc1HAwOTvIua3F52KP
	XJE/C0GTujGSxkY4hmjAEgivAFeRaIkMz1hozh8dmIw/AOcocIuTZb18gWsOiz2sEhtk/GtQYp8
	YiZGm6mQU2g7Oe1eYIEej20k5fVPXJt0VnhggPZmssIf0mIy/Ys7v
X-Gm-Gg: ASbGnctY/lXQofOjQopQgcIDyVJU6Cd4r0vkV1JuOtDFXMXeu23nLVAKbMdDRdTlnQG
	rhdwo8ZSWpVGNDAJJXAOM6BrYoPSjuDeHpxX1bRhaNf1jWyvTAK+v7ZPmQLVRHbaMl1OkmuP+S2
	8ESspN0J+4hmVOWuEOlqlyOFPh87GjD9Gj/FCqwzwllNHgWoWiJaSmGPF+30OPFAtVDo34SgQnI
	BkDBm/egE4v0KLGI5ixty0NxwL8CwO3HNIDrZWqi2DFlbg0EjqCro/qGc79BKYS3jUTYcLr/ysJ
	Hna4VuRfHq/m3G8fAhqly60za6OL3LOHCWM7OLwXIra35nf6uItGGuGCHUev/UpGI57BbjzxHKo
	N2yy15xBXkMGDtLCgUDnpZ4zS3D3rmgiAQBVLUP0Uq2K1CMphRTZfF0gHLNm7ASN7E7c=
X-Received: by 2002:a05:6000:4011:b0:3a4:f50b:ca2 with SMTP id ffacd0b85a97d-3c5da83bbdfmr2672653f8f.8.1755886197907;
        Fri, 22 Aug 2025 11:09:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGihO/MfCjEADxWF8Q8DVVHHoqn0Rg/Ikr9pZDPhG5cKysecyGKSziAj6ohTWcg7Hwh15RzFg==
X-Received: by 2002:a05:6000:4011:b0:3a4:f50b:ca2 with SMTP id ffacd0b85a97d-3c5da83bbdfmr2672603f8f.8.1755886197412;
        Fri, 22 Aug 2025 11:09:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2e:6100:d9da:ae87:764c:a77e? (p200300d82f2e6100d9daae87764ca77e.dip0.t-ipconnect.de. [2003:d8:2f2e:6100:d9da:ae87:764c:a77e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5753ac36sm7608875e9.6.2025.08.22.11.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 11:09:56 -0700 (PDT)
Message-ID: <1a3ca0c5-0720-4882-b425-031297c1abb7@redhat.com>
Date: Fri, 22 Aug 2025 20:09:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
To: Mike Rapoport <rppt@kernel.org>
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
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-10-david@redhat.com> <aKiMWoZMyXYTAPJj@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKiMWoZMyXYTAPJj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 71_uFTdeIxxtKOt0lZ_cpPQpKihWGg2bib2Ew1_u8Uo_1755886198
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 34F0C20007
X-Stat-Signature: ydbupyxh9d568m8z8t35oaak5j7h3bfn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755886201-155424
X-HE-Meta: U2FsdGVkX18xfBEcmCdXn0WAP5baZ5zd6Be2ldVc3JPePTXh89nqAKyCgqrV6k4ATNT5JXGGfAhfAZ8PHOUM3aP1HVxXcNl56DkuuAGR2EolxPgv8NC7cRiTbLlvAxFJWqtd3mbYOeByZDyDpToI32APgCuuBKwhDyiPYRpfmFBlOcxmF2dUww3EeSPZ8vC9TLyYwiTPA4U70hrgBPdjy98dBgHdH8PdyVUZZu4dKnyyT49j6e+z8oT4TnFlSSAflI8c9L+SofmY4YyKogrtxsg55i2EJiwV2qqrPZWffjiJXZo1zNdbrQZypJkx5rzhPm9c/p0aW2TA4ajHpaXTBKEcB6F7ZWEgM0NknJzP4EQW0ngCpzz3dUzVLaEBc0v60xbif5r6UFwy35SOqt66nesvm3POv/B9yb0v6FpXuABrlieQDn51ULxFP2XIOxxKKcWTI6KPGMXQtrNfQZneJGcsoduHJsg+6FufGMU2gJ3AM6rlqKj1Fbsda0NIJMe3yRm204SDLNdoDgNMQJdm+mSLU6BkcOdUiD5Su4PMg3amNIJRa0GhOqCX40ua4jBxUPTsO7bgGEgUB5ignU/DNS/06R5H9K0vsNFQK+4ClBkACNYYjn6TFW5ENt6VnvprwjDsS9QKwD+L1HcZWNk3x82lo1h+x6kTa2Mut4GQJ5VdX5TadH1b4pqmhhEwBeatdU9eEdQgxv+83aJI2EB7hdbAG6DtGCGuhxIXcBWq23PAIOlBtljCr52vTiNM3IlU94DoWI7Y62gMnuYh2tqgd05l74QqX14B1vE8ax8MPIVwFbZTAqGAw4Hz4gadFfTSjxfm4sKMM9LHYdUGTX9ezNmdZ/xVRMh3E+WaTIY2BjCzeQCnCLIs2lWs5j+Iy4ZKedsJL0mJRSE0gjF8zIruzO0OpjEZBnTr5HxFzJXws8BP8e2tEFG2t9qRMEJr1B+0pzp809MrL+jOGLvEuCm
 NWgUi0xZ
 A14nCp7VCN5e50ms9NhDUQSreBqfjI4vHjd3OVAF1NwzSEB+jfaAEhTB0F5Wcp2Tz5c1wDdMXQDnjz4WmxI8uZFT3X3r3DNBJfOQRgmxqh6mmhMAa//xHEzxe3zMc5ZPib/muwOkweIQXMMYhdrxTcvO/CQWiyd1wLmOcKa88bIcRwaiyLIeFY147Dqd2Z0M57lLZhbi54brQet7ap32Di/zsZdovMV1E/dw4vVY9A2u2iqNo58DriGUmrHBGC6iAfoCkPprLXTGJmYmBVOj6EUjU2S9JZUOSH+9WvXPDRjumhXjG68GVFWHWEw+F0geKuUqNS8wxVcMW76UmA0ZaeVjx5Rud23zOc0FKqNmbqWuYKSSTshit+UUhIlxseBweCnrUguPR0FfrwWi1bGM0fv4MtelLuKzjTvB5l66zameMXCnbFjMhKHHgVNpXxWHfeA3GnMKgkuZrosN8817hqTv4LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.08.25 17:27, Mike Rapoport wrote:
> On Thu, Aug 21, 2025 at 10:06:35PM +0200, David Hildenbrand wrote:
>> Grepping for "prep_compound_page" leaves on clueless how devdax gets its
>> compound pages initialized.
>>
>> Let's add a comment that might help finding this open-coded
>> prep_compound_page() initialization more easily.
>>
>> Further, let's be less smart about the ordering of initialization and just
>> perform the prep_compound_head() call after all tail pages were
>> initialized: just like prep_compound_page() does.
>>
>> No need for a lengthy comment then: again, just like prep_compound_page().
>>
>> Note that prep_compound_head() already does initialize stuff in page[2]
>> through prep_compound_head() that successive tail page initialization
>> will overwrite: _deferred_list, and on 32bit _entire_mapcount and
>> _pincount. Very likely 32bit does not apply, and likely nobody ever ends
>> up testing whether the _deferred_list is empty.
>>
>> So it shouldn't be a fix at this point, but certainly something to clean
>> up.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/mm_init.c | 13 +++++--------
>>   1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 5c21b3af216b2..708466c5b2cc9 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
>>   	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>>   	unsigned int order = pgmap->vmemmap_shift;
>>   
>> +	/*
>> +	 * This is an open-coded prep_compound_page() whereby we avoid
>> +	 * walking pages twice by initializing them in the same go.
>> +	 */
> 
> While on it, can you also mention that prep_compound_page() is not used to
> properly set page zone link?

Sure, thanks!

-- 
Cheers

David / dhildenb


