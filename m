Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C23BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E1B8E0008; Thu, 28 Aug 2025 04:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 815AE8E0001; Thu, 28 Aug 2025 04:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704AF8E0008; Thu, 28 Aug 2025 04:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F0DD8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:18:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EDA61DED38
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:18:35 +0000 (UTC)
X-FDA: 83825464590.30.7CAE0A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92E1A14000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:18:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BJjycywl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756369112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQiayb6TF/jkGdLdQdDfmQoC9oGAqREv3FJiJ/1tw1w=;
	b=wwX82AjtIV+euBr4QtLio3URO8AXk8tW/GfhkvK50Z8SudcVB2RL8irO2vJ+NUIFjJvdvO
	5ze0IF4PXAzm1jrz6srqAtXBr+AvUKfqsrc1Ah1KKrJ5sIhwOAQGt+7Ag2vB9vYHVyU6wW
	fa92Hvz3w9/OLz+K2b8qWAbsbymKWN8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BJjycywl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756369112; a=rsa-sha256;
	cv=none;
	b=19F/JDeFb5pMxbanb7sf5rSJoDf5mDOwBz99AQbcd8ErDLOAA220swowLOyaGboRFjwY28
	MVgPqWqBIMgOOeTgWYzdx0TCTEd0unDodaZqfrUswy+RUqTBbkFP9tso7Ux9LQpzhR6Pf3
	c7NYy6FmKgiY19wSIK5sjG9lHQelCaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756369111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dQiayb6TF/jkGdLdQdDfmQoC9oGAqREv3FJiJ/1tw1w=;
	b=BJjycywlYO5+tYRwfuhNoHaRnlIVEGBfCCFaTXgc2Vw009UARHGblqpX5Yb6y23UTWh9Ni
	/z73jVbcE5pBXdr0LvJfF7W22QCe9VtqCEqPujRtbmCJE/aqYnt+7o0KfJ9Y4xURQl0ODR
	o82KDX7aPlCQVSCVepY/c/zjiVqDVtk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-bBGWly7cNm-u0Ys-Dd2IoA-1; Thu, 28 Aug 2025 04:18:28 -0400
X-MC-Unique: bBGWly7cNm-u0Ys-Dd2IoA-1
X-Mimecast-MFC-AGG-ID: bBGWly7cNm-u0Ys-Dd2IoA_1756369107
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b10418aso3308235e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:18:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756369107; x=1756973907;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dQiayb6TF/jkGdLdQdDfmQoC9oGAqREv3FJiJ/1tw1w=;
        b=VTwdPtH4uIr06Kf1r6nDIggKWig0v7/vYY16rfemDkhtERh4GWOpZjX5ZzevVQmSCK
         +5Q7iUvza2uQcxUyJo9vrUCBrvOYHRDrQEOS0LcFO0c47fvWnaEF8lOiWDOaEEHblCw7
         M+GR0FBcUzwimdB1rZrqry7gNafApUiDsb1VL6lu/myh74X/D/TO2602KDFOmZO33eMA
         2xhEy5O1XgXrzZOhDV8zFAObJUtjztqrAiZWPpf5+MfUgPJrKFx6yQK7WL8a6esvcq29
         PICef8O2AKjhlQoHFgI9NdADLTaLR7agMrK0uCanRH65HEa0Gr4wiZOEnKrewC0By6MR
         YPdw==
X-Forwarded-Encrypted: i=1; AJvYcCWwA2x/rxdQPHHAQ+1jSEmTE6ZvNqdHTpHjDRpkeo20fgnDoFtYn42R3Ty7O4vX4P53P1KPG84XeQ==@kvack.org
X-Gm-Message-State: AOJu0YxwKEZXy5bLfjnIEd9GPfwaX746ooiy+QlcOwf3yR5S9wqxqnpN
	/2Rxi1UI2aHv6G7YcZpXxLcAeh6skREXdCVYx+u5CMFk5vl0W3k8Jne0ewECD6xuVeBwoFIrq/f
	HqT2Dg2jLoJnOuSsSorguiCQldh5opGnT3ZXlYaqTfGuwR1pyqBwG
X-Gm-Gg: ASbGncthRe922zaA/YtM5C3jzQoArE31+4HxpfHQFdL5rQJg/S/6PoWljy3iwTrEK4d
	ZFusTub7jtZwNFwyhDc6utIVx6dBuX6O2v0acJH7eEFsn6XmEnA668YdNrwXqjEl10RU3Ku+AFf
	fLuuSqt5ngddWluMvNupV2HgnpsPFm4dYy7NsBOeHmszyrB/hzvLx5JqRKRsjUtwKYkgvWNhh4s
	LxNx1831i1tVVmyw1wnQt+J/ALfU0+H66AL67q0kkARJfCBsEeoAr/bhC9+f0AEreYUH+zqVEYW
	lObI2jdHnbFcIfawXyeoh8IKQ91wymXE/Fg0hU6MlpXuRxppndUhIpEsXk+vhd7q17m2ZKteO9/
	jv8Fk+NlGynW4Pm6nAIC147/wBjtpR1eZn0GKE1mmGFDjXNLMizg1DWpX/xb4hcW180g=
X-Received: by 2002:a05:600c:190b:b0:45b:6743:2240 with SMTP id 5b1f17b1804b1-45b68aa25cbmr59784645e9.27.1756369107126;
        Thu, 28 Aug 2025 01:18:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUJsaR2J7iF3R+ldMkn3aeuQzBBUKQPNZcZ93/+SZsto/QZ9LRuZpML8ujkA6ncDdKY9np+A==
X-Received: by 2002:a05:600c:190b:b0:45b:6743:2240 with SMTP id 5b1f17b1804b1-45b68aa25cbmr59784365e9.27.1756369106625;
        Thu, 28 Aug 2025 01:18:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b732671b7sm21138515e9.3.2025.08.28.01.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 01:18:26 -0700 (PDT)
Message-ID: <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>
Date: Thu, 28 Aug 2025 10:18:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
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
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com> <aLADXP89cp6hAq0q@kernel.org>
 <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
 <aLAN7xS4WQsN6Hpm@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLAN7xS4WQsN6Hpm@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 85w633kGLq06rqYfCJgvI_Ys_iQutKLXn7KErBms0uU_1756369107
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92E1A14000F
X-Stat-Signature: fo54n7jytmktcwoasx1d4qizwqtqg3uh
X-Rspam-User: 
X-HE-Tag: 1756369112-318936
X-HE-Meta: U2FsdGVkX19gx9lsY1AT0VsLgSvF0oV3DwZ6no4E6c0JdnRzhg23lLnmPFjGvkKFXtWYBVqe1dfziQqks350HND80lnJriNALX6miab5xoN7fhvkeJ6XbxOGm6UbZidg5/jcu8f1TClwPRnU7PFXBc7IOjAW42Djb2t65LWbTf5A0PLPGTE1cR901oVPTUtxYc4ngi7TlTE7AjZNV5mDIIoD1SJiWQ3Jol+L2AdIBXY43/zxBO1onelx04XKneJZIYiX69b8pxzrEZchPCLH7oLmJd0cwI3ZdbXjnulyMqD8CixBvBDldrjmmfJA2pDG5lwDj7dUxcyga6h9BlR+LJLYY9syrVXVqed2FwanzuOVps3iu72E8NBg/33XkXCTFBVSlybu9tBGalE7Ug9P5fwy9BvUe/QXXHylNQBWRGjREJmmGsySJT5a8UGmu4+ZHBbNXbHA7DB33vaB7kGg99IaV4CVAFAV+8Qije3qEDpT8KeMPo2zZcmLbGrX4RV78HdYcgKv+dfaO8svIv2PpIY/7YZQFHB75IZ96ew4/j6iHRuWMKwHcmI4aY5gk4SCunxYVWVH7pNvR8C8/N3YAhmBKQYyE5bA/5/Zt1hnnmbdZMxhmwH1sLSMRtLUdJsU90TTnC1KOdwppKT+wW9X4Atk9HJh5OH008h5ennz0WP+Mx+MNrlE4Rqq8D+va/geADzM8hQTFF7NVHgK3WMh+fH8EStg2nEcWvBfVLyKT8aisQJRMNsKzwl1G2CVDnNQjqH1T1I1wA0SkpicrCodM2HlKHazwZ+etxM75enCyy63L7Y8pL288F+xuElyE6FZXUwJHQhvdmOU7sGeDUMlF4OYk3WI3GZ94sM6HgoazVYjnoUp+3w/a59Z3DHmVgA38xq7PNQtNIWo4mYX35Dop8n8BOLJPzORMTmn1g9tsHoCI2esPMQKjR3M7pYxZ/ddx29KTXbhNLYYFU/wHRb
 Hx7YWGKK
 D150NWPnozazVWcc32ViRqE3bMhjLnKlmywfbvczkRGcgnJWVAt81pzUsuAycMGmHEEvSuC0o8Qa3r7rbvtE0P0OnLooJ6nrGLNefJa7Gja5XRvx+ZXvAB3dioAZ/cs+M8FtbjPXt+lWYe1Hqe3vIBbLKe4lxXBlpcZuTpnVmGm0lK8ZZX0Ac13U+gh1H4Acf6r5uLWIQ/0lnvz9XcWA4A9mygxIIm5uoXfNcoEC+CFzxbI88HzvOyELrKS77RueMwDksO8ty3D4np2jjtT4AVSMT/08+TeVY62GUVTdX8+5ukG+imesQ0dhpBRMoBrK5s57U8/UWE+U2rI7886uCxjDobk29qF9qF4AjlVdvtDIR1DWbCZ9tiH5vver8xzT+apK1ALzStMuIA/oz0pCFnb91sSdqqyaRlbCM6mrdB+GAwBnO0EsV2NhHnDYWQjskgeUnvJ4na0l27xtDuLB8j4MuGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 10:06, Mike Rapoport wrote:
> On Thu, Aug 28, 2025 at 09:44:27AM +0200, David Hildenbrand wrote:
>> On 28.08.25 09:21, Mike Rapoport wrote:
>>> On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
>>>> We can now safely iterate over all pages in a folio, so no need for the
>>>> pfn_to_page().
>>>>
>>>> Also, as we already force the refcount in __init_single_page() to 1,
>>>> we can just set the refcount to 0 and avoid page_ref_freeze() +
>>>> VM_BUG_ON. Likely, in the future, we would just want to tell
>>>> __init_single_page() to which value to initialize the refcount.
>>>>
>>>> Further, adjust the comments to highlight that we are dealing with an
>>>> open-coded prep_compound_page() variant, and add another comment explaining
>>>> why we really need the __init_single_page() only on the tail pages.
>>>>
>>>> Note that the current code was likely problematic, but we never ran into
>>>> it: prep_compound_tail() would have been called with an offset that might
>>>> exceed a memory section, and prep_compound_tail() would have simply
>>>> added that offset to the page pointer -- which would not have done the
>>>> right thing on sparsemem without vmemmap.
>>>>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>    mm/hugetlb.c | 20 ++++++++++++--------
>>>>    1 file changed, 12 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 4a97e4f14c0dc..1f42186a85ea4 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>>>    {
>>>>    	enum zone_type zone = zone_idx(folio_zone(folio));
>>>>    	int nid = folio_nid(folio);
>>>> +	struct page *page = folio_page(folio, start_page_number);
>>>>    	unsigned long head_pfn = folio_pfn(folio);
>>>>    	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>>>> -	int ret;
>>>> -
>>>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
>>>> -		struct page *page = pfn_to_page(pfn);
>>>> +	/*
>>>> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
>>>> +	 * so these pages are completely uninitialized.
>>>
>>>                                ^ not? ;-)
>>
>> Can you elaborate?
> 
> Oh, sorry, I misread "uninitialized".
> Still, I'd phrase it as
> 
> 	/*
> 	 * We marked all tail pages with memblock_reserved_mark_noinit(),
> 	 * so we must initialize them here.
> 	 */

I prefer what I currently have, but thanks for the review.

-- 
Cheers

David / dhildenb


