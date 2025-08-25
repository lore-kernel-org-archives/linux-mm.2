Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB88CA0FE8
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF598E002C; Mon, 25 Aug 2025 10:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA77A8E0001; Mon, 25 Aug 2025 10:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96618E002C; Mon, 25 Aug 2025 10:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9AC1F8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:38:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50014B9801
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:38:14 +0000 (UTC)
X-FDA: 83815534908.30.6566B1C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8FA9140007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:38:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HoobbtYg;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756132692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S1b1Qn5IdFgoYphqgj6hBBswyK4CJqNFMjotKKBhPlQ=;
	b=Z/K2aW9gpdtGNSjrOtSciP89n36J0FRItxNHUPI8kR5Qbn8jLvy0WQ3YEECgQWi8CIgtvv
	pZTm4vH77AG54ueoxfMmMflL+bo/AbjZIS153utGIzwKBGbBTMg+TeKyLuCAxRp1gF3NsF
	kbEn2HI8RslNdsuLCQIPpiFp8hroDdU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HoobbtYg;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756132692; a=rsa-sha256;
	cv=none;
	b=b/roWkPIU9rz8lVyqiUVwu4ahMoEsXLmWzAtuKRTU2sTH92TW4ua67PxQ65HVD4As6NauK
	E5NgtdYXaSbNCo0/QlFVwLkJ6DolbsryqqU9XBvnKSX6kIH0n9dGB7TuKoAxdX3E4X16FT
	J8eBH4+rckTshUca6BLQ0Wr2zXe9TOY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756132691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S1b1Qn5IdFgoYphqgj6hBBswyK4CJqNFMjotKKBhPlQ=;
	b=HoobbtYgW+PrUqxQN2BTDWBcUPLPsr7Pk9UIYE1NUHoS+P+rFUq9PzfPFunuX3v8+Ds1VU
	UsiDDgP8B+/lzzpSX7uEfEGZy4+26U34EiEQcUuOdl6628d9FLg3hIsOSPReWMV0X57SgN
	3PIAfja/536eEFFiXNk3H/JBFAp1rzk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-9GsO_6OvNr6piG9pYBO1Zw-1; Mon, 25 Aug 2025 10:38:08 -0400
X-MC-Unique: 9GsO_6OvNr6piG9pYBO1Zw-1
X-Mimecast-MFC-AGG-ID: 9GsO_6OvNr6piG9pYBO1Zw_1756132687
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3c8406fb4b4so1457566f8f.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:38:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756132687; x=1756737487;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S1b1Qn5IdFgoYphqgj6hBBswyK4CJqNFMjotKKBhPlQ=;
        b=KQJHg1JVrlQPDmVrZz9j0PvxvdxFxRBoIbBiscBe7BmWCiosmwPsZXKQYpHq2I17KJ
         jDFEKkMqZOsPGQetJVZV6BWPNp+RzA4HWGTOFn3HI2WmfVIuQZv7Pitj0BOUJRx6FbIU
         2dnTTBqodmCjOUyt9H9AwF+phuQ2hhl8ELTC5t/0Ilev1g3TPO0wM8CZE+B+4aDZ+udr
         WRuThedI4a4uKLhXGKbXjvdwCnM09W2c4Hbzda/rOiGbs2LCyJsjQok7nnxz+2xihl/Y
         PaW+q+xRJGkUWKGQ/AUpdxeA5cPet+Uzgmej3NFoHOdQr7QUFfdRXeOs72pscGe2Ah6w
         +ypA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ0G9+v+2M5cgugkS5KTiu3GnJOGLYwWk/leQRr6aRUnASVmtWXulmhjV7KDGga+T1PwnC+xJG9Q==@kvack.org
X-Gm-Message-State: AOJu0YxZ9DF9w8mdEDW2o/BszOcWPMp5e948M4JkU2Tb0/WC8mee8Z0C
	sfiJGOLoo+YCjJDRjx351T8vMbEGVaYaY1jNiU9Klr2nrENibVbdid2VbxPS3zDWlpQd6IGYaM9
	h9cnCvro6Js1/scG7nLlc6h7t4f8m8MQQvNJRH6l7VoV8fo/69HWO
X-Gm-Gg: ASbGncvFgJ3M8B7pcnrNCkPW8yWzXq45IChaKzmZVrr64xnp4IcCcEhXJDP1sSvv2U9
	oM2XdglDzMwWqsNu3+REMYMTtZm2/CuTGkb+mon1N/ASs5CDZx+IJl3DkdmZNDAHGdt995k9ETs
	ZXoFOFoawdKuVY4lW9M6rug9irXTHvd5Gw90twCNB0UyKDKOqkgBuxS5VgegpRHoTBsWz/JTEZ6
	1GFstlJpFZIeVHqcliW6JSADOXIIAjBS1P1QqpHH4Q0K+bfenQQvCS+v1NNlWL8IUVTNwJNrrT8
	A0YSTKP0THjP4q+l4Dt/o1krZlX/uXKRlMj//sxR0I++JwgDOyXdZ7FtJRUaJuTvzrx1GEb7IAA
	ChxK1wz9YbmnwcAvmbyFINvSM6+bLG/ZnhTE4GJKuukS10oYnNhnJ1virVkGAImSlCHk=
X-Received: by 2002:a05:6000:3113:b0:3c9:f8a:f257 with SMTP id ffacd0b85a97d-3c90f8af5cbmr2996373f8f.50.1756132686406;
        Mon, 25 Aug 2025 07:38:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHCFvBJRBfcBEdo8i70/6pukUQNYn2Qrs6ZnSbppOdelrrIoC/z5rNFiWI+fX6KVi1Xqpq2ow==
X-Received: by 2002:a05:6000:3113:b0:3c9:f8a:f257 with SMTP id ffacd0b85a97d-3c90f8af5cbmr2996318f8f.50.1756132685799;
        Mon, 25 Aug 2025 07:38:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5744e9b1sm109711045e9.11.2025.08.25.07.38.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 07:38:05 -0700 (PDT)
Message-ID: <a72080b4-5156-4add-ac7c-1160b44e0dfe@redhat.com>
Date: Mon, 25 Aug 2025 16:38:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/35] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
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
 <20250821200701.1329277-11-david@redhat.com>
 <9156d191-9ec4-4422-bae9-2e8ce66f9d5e@redhat.com>
 <7077e09f-6ce9-43ba-8f87-47a290680141@redhat.com>
 <aKmDBobyvEX7ZUWL@kernel.org>
 <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
 <aKxz9HLQTflFNYEu@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aKxz9HLQTflFNYEu@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9pSwTr-PXDbWjBdbrwMtt1dHeTe5lpTLnw70JdW_Iq4_1756132687
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: banye1bbdbjny9o19xxcxsu6mobrjwab
X-Rspam-User: 
X-Rspamd-Queue-Id: E8FA9140007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756132691-998289
X-HE-Meta: U2FsdGVkX19KLzfZmDqSWYY0OYDC1wnvz5eo/hOr3VgeP6ipuUsEHpQ8FByrMnjMvOqb4gU7KIYAtSWxjBFZPcWSCZRlrDzQscoe7ZtxVs77RuRDdvWTRpOksKhu19zqylgBKTts8kXPpaMXhwR0UGMPBdtTgWiv0rXlVmelQmV2YZFuiUsUnQAquQlJF8sg9vy3be9n4DHjP03sClzQQ7ifF58PsVzGGjS/sxu1ul/R+QrOnSCFhJdjaGXr+2alqkybF8Vl6ECQG0SMvMgE2TykRFHDCCgr6I+mpsh8jcXlBSwT7/R8ZsmkfQlGQ4g2Z1JBxoQObp1I1a+b3SWaYTG9Z2oUPe5OzCBFml2TrNjaeMad+Wzu+f+iEKD9+cTle+oIF4wx1feCxcQysEeZMfyVcuV6N6j6nSk/0FjUIxu03dSAXD1pDmBK3ZEeF3XjKYaBYoeX10faPQ3dEt8x5FKZaAfLLrc3v6TU4Ty4kK9i3OUS9ZTynoU38mq7mFilileRgv29r9P2Q2+1wXpU8lobS35D0RXObquLxZfUsxso559AwjKW/1NWCZ1WO38LeX2Akc3fWtNtDNyhBMhV/0jk6BqnqDJtsA2rZlPcIJ0f7TBmLgkWF5CmuEr8WdwnbkzQQjTf8bpEHfDk4471qmZbsri+8pIC53p4clpGHQZ+tIG/7fUE9FHfcIgktvTEGy3lq+hFgunVvBiYpB5lU3vbRFP/dEzGPrXHVbrAzLAWqjq4mMJY8YoS52h0XtnYX83eZN67Qh4PFQOvnrff0O6MmaO7bl7waUdcUKJDhfca6QX2mMHOVYooZa0C9S/2YE/ZN1YCgtAYE5/jbnbrfoW9g+EYx/i5ojoyECCfnN7UdODKYh29huVnuOHCOhIcwFkpXrPcOynqVMtt33m1Fc73y/JCXrcvT+HW+bvpXq5kuBSoHHxV039DssaWC2UZQVX/uor9xxw9klZnOf2
 x8e2VNvi
 IISu9IEeyKPNsXHn5A2h8yI9Gd0IWJzYDAwjhuBe7dlTTQdHAzA643pL8zA3YPBzWlsIwIVPqyOmHNEJL/p0ahtNyPuTd5VrmOfNEAU4fKslH4rK2SppCXiVQyubJD8CU63i6Qd1YztRDoyYDukaBXUQnYR7xZsL0k/C92jSb04kGc2JLoEuIaPVDJ0i3MmXMIhbblEcXj2r3LxNxYg5gwbAUT2KGhclFJ9ZHKNZzw++EIMsf1gvZT0hqvGO+vXdoMqMaPqGXXtngxymOb9AtgY1S9CIUzjefMptPPDe7ALil287FDWBPhEJD2gEm8FdE87mtaFLoF5WUmnTPGdiyZg6bRg+JcL8YOngsxR1Dr7CfFcvqmwTrKT/SPWFIreoxEqtRSCTumfxs3O8v3mBLr+RhyvZepV9uhGlIq+MM5Nyhep+hggzRsjoEvNP/3TXjLDGIGSV0P5In5W0y0KdnvLBICbKp80MVKmwpIT/b1/RE3aZ5Ajzjc+QT2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.08.25 16:32, Mike Rapoport wrote:
> On Mon, Aug 25, 2025 at 02:48:58PM +0200, David Hildenbrand wrote:
>> On 23.08.25 10:59, Mike Rapoport wrote:
>>> On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
>>>> On 22.08.25 06:09, Mika Penttilä wrote:
>>>>>
>>>>> On 8/21/25 23:06, David Hildenbrand wrote:
>>>>>
>>>>>> All pages were already initialized and set to PageReserved() with a
>>>>>> refcount of 1 by MM init code.
>>>>>
>>>>> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
>>>>> initialize struct pages?
>>>>
>>>> Excellent point, I did not know about that one.
>>>>
>>>> Spotting that we don't do the same for the head page made me assume that
>>>> it's just a misuse of __init_single_page().
>>>>
>>>> But the nasty thing is that we use memblock_reserved_mark_noinit() to only
>>>> mark the tail pages ...
>>>
>>> And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
>>> disabled struct pages are initialized regardless of
>>> memblock_reserved_mark_noinit().
>>>
>>> I think this patch should go in before your updates:
>>
>> Shouldn't we fix this in memblock code?
>>
>> Hacking around that in the memblock_reserved_mark_noinit() user sound wrong
>> -- and nothing in the doc of memblock_reserved_mark_noinit() spells that
>> behavior out.
> 
> We can surely update the docs, but unfortunately I don't see how to avoid
> hacking around it in hugetlb.
> Since it's used to optimise HVO even further to the point hugetlb open
> codes memmap initialization, I think it's fair that it should deal with all
> possible configurations.

Remind me, why can't we support memblock_reserved_mark_noinit() when 
CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled?

-- 
Cheers

David / dhildenb


