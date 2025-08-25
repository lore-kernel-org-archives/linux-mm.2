Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86308CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 12:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A038E001F; Mon, 25 Aug 2025 08:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21428E0001; Mon, 25 Aug 2025 08:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F8F8E001F; Mon, 25 Aug 2025 08:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0F98E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:49:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A69D1186D7
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:49:07 +0000 (UTC)
X-FDA: 83815259934.25.89D2F18
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id D1C9840011
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:49:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HV1nSTp7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756126144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vXE/JZQfiOFAY8LityNc5lKOCwFML9m2hfnchuxSjw=;
	b=7NrKZYVhESGQyk+DE+/X3HespfypV7vy2ufka4YtASb6scxPJQQ8GVFabLULRQjHRI6WwT
	POWDzVLByYrpMnJ32aIHPsZVTc2xAcflzzbVXp2KXfcVX5F1J3v3qhUm8fxn7u7nWdZi9h
	ErRCoVDcZSZvgiYS9GTTo3lfBR1BcGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HV1nSTp7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756126144; a=rsa-sha256;
	cv=none;
	b=FBHqwlxm7varM+eT6mufUopkw2sZP2OkcZDM6IXfYWUWYJaIZDGGb2hvQZpM+ptw5DOixM
	jNO/4GhMHXFX2VKCGI9ny6wJEgjVlhjzE2FZK0uKFqq8rTiz0Y2V14yjjfFdmeNNFn6i+0
	Zr+VJ8qjxPkHNueAqFOW/ryhgkvSTYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756126144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3vXE/JZQfiOFAY8LityNc5lKOCwFML9m2hfnchuxSjw=;
	b=HV1nSTp7Q1GCYDLMq+4QqifxDxb7uYS4woQOiYC5rfSiucsVc4NcdRRzILeC5aQoVz5gJ1
	VSYwyFt/6kpVm+Via2f8IpHsZqabREVOTk60SlKbsQICe0pSG1jDTpnt5HFTSNVgTipQaT
	vz7KDhXANuJ5abMoEjjmje7XP3A+SOc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-kSyumv1JMTem0Mcxx6ksBQ-1; Mon, 25 Aug 2025 08:49:03 -0400
X-MC-Unique: kSyumv1JMTem0Mcxx6ksBQ-1
X-Mimecast-MFC-AGG-ID: kSyumv1JMTem0Mcxx6ksBQ_1756126142
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0060bfso28682555e9.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 05:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756126142; x=1756730942;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3vXE/JZQfiOFAY8LityNc5lKOCwFML9m2hfnchuxSjw=;
        b=Kg16VA601KZXBTKNbHg0E/LsdLEG+aOGVU9R6IhT+tTmKox/MXemX86gKAT/iW9hMt
         VgIpAroXy4MCRxVm5rf4sUh3zCOOFzt7UlR2PdyG7TElf59VNYby6nUzpIM8M5g13L+3
         XW8x8mteambDm/ChSI9IqGbFQPpdaDwV7trYqlrmv7CCZNAxazxh+g/YJwg+IFG+lqSe
         eCCoTK0OUy+XHMqmGuwBA67mHquTu65ZdnCj0as4wZ672o9c2Z6LBik4mX2RKNh3gifG
         64T7SZ5tu+RqwTRhnIU4Z3Ssyj04xu7gZh85ReefkuXuPMAhF2vQlr1/S6xqOLFFaWYf
         7BUA==
X-Forwarded-Encrypted: i=1; AJvYcCXpKUIeCbTfvX8eMoJV/ofB7x35sZf7iDV7KO62v67sgM58+1S46l8k3My99cuV90JOiaZC47G8eg==@kvack.org
X-Gm-Message-State: AOJu0YzANB/vtpnS90qlVJBaAC5FPEC4oAGZqd0P+nmIno26ttRoj4+1
	kFESJosDjwgTyVuyJFqi+IumHvqcqjchl32/yrxy34ZbTZU+yQ7mQZ2K7O6ndsJB3xv3fDzzdXf
	TfpV9x14S9Uc7FyfBrB+GiImf97ciL/feUXn6k5RQ2ONxLxRcwcwd
X-Gm-Gg: ASbGncsjg4QaqF+1ULJ0NwsyGMu4IsahSM3miPk/HwjZYotrsr+byqYJqTKL86J9vl/
	21o/rkDRNWWDg3bn9HDWv2nUVUDzU2QC9bFmHC0HIr8CFLnZpBy6bm8bsozXeiwIfaOvJq9zI6v
	lIH2iw+zb+sRkzjf4UHmzcwQYJHTuGiYz7wSXB1jf74vveMEwC99sF++F9wZ4RYDyMEsi1QWZ+C
	jmVJr6mmf9jsqDfTkGUDjwe8WPfi0JdB2wqH6AhFm2LtyU2kQuv0V8Ct8xxMHrZ8W+YRuFh2NWW
	WxyXhaE1+AoU66udCXgTdidxL8TTV6Fz1+GAVajtNmNEDW+QFf8gAJBdPq53FZk4MFALWyZsIq6
	26q2Qp4jN/1J/KN6dHciggtLdCLf93Q8Cn36M5YHzWe8u8Rwtjq+hs/yk1O8xgfa14NQ=
X-Received: by 2002:a05:600c:3b0f:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45b517d4d50mr117582145e9.30.1756126141751;
        Mon, 25 Aug 2025 05:49:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXxc8CWovMYNQS1+MbZ/J1HLlRjFi84VTIxSAk5gdBYVSg2EOk3SSNbd5GU03jnCMkyvwvPg==
X-Received: by 2002:a05:600c:3b0f:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45b517d4d50mr117581475e9.30.1756126141263;
        Mon, 25 Aug 2025 05:49:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76? (p200300d82f4f130042f198e5ddf83a76.dip0.t-ipconnect.de. [2003:d8:2f4f:1300:42f1:98e5:ddf8:3a76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70ea81d38sm11742640f8f.17.2025.08.25.05.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Aug 2025 05:49:00 -0700 (PDT)
Message-ID: <a90cf9a3-d662-4239-ad54-7ea917c802a5@redhat.com>
Date: Mon, 25 Aug 2025 14:48:58 +0200
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <aKmDBobyvEX7ZUWL@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mys9TbInvZ4HlMXJx1G97tuBvoNN94kTORv_Jk_Rpe4_1756126142
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D1C9840011
X-Stat-Signature: y98oyyhrpop94oh1c6zee7uda845doid
X-Rspam-User: 
X-HE-Tag: 1756126144-62633
X-HE-Meta: U2FsdGVkX1+B5wjT84rYLP+bzOlSTp68zPDmryPTBxOGLEO7MaDhjVaX2jhfL0/P3f4qacUaBDTD3Nhq058F/ZK5cPnGbFcHMQvLqDoPlucog8fAjuUroYYoXI2fppH0eBkah6LC8urd1TgYc0ZV/ckA4OZz1gFqlYjRMtBChaMtHOvs6tyyoDK+ZTQ1xZo1HqJ4HDzY8mG+UtHty9LboCzHa3D2dmPSo/nwyXtw4OOEqSuEGaFQdlSVZ8yiA95L+aJarHehHUCKGDqA5Dzs+toXgyqeKxr0gCvr52rwSWsAVBbth3ETKtq4V+PGPL/PcZYIKFkkveaPudl2L1O+CNZesMZPQ24Z7/ZW9bGulhkWobjWbnRyoQ2fHgCUWBcGfjznfkEhI/+vxpn9WVyFrgrxQEaLiuuAMjzSWBMjFUxIwLzjDGq+gOaobTWqGxV2rW5ZmFrW4wIQW22hj5UHBssc/Gt9XM9vM3/yOd52OFHQ46Ku4y5YDwYR6AtNfko2aXzff2d7WbuNOxGqIwpG/IbUJRXsmmuXw86tIA7SqPnzd6r/1p0Q5Zy/zRvHlj7K50klBG4XP6Gq+J49A+ywlSlxh6E3y2QUh8ydM1627Sy+SEdfQJJj2v4lG2snQAp5ZLPMbQtJNFXXALq6aciPld1OH2WcMXdoEyehlGv9lXwAiG5nIhse5bL3G0N57i6tkwQBcj0YF8s/NqMFdv08J3bzuqNEd5tNiy0AujVRaZgftSZae2a6WX8Gc35ZFFiIjxJmBd8pqxbVJVO+fnnELvoJuNBf2Cby4esxM7H76HduMkiVIoGoIUB4pSym/q4/OcF9y5jmyx/jnPQy83BKuP5dwguxxbneDKOuRzHGhb2YKoBOF2TmvDkxRt9Q+SuQcZUUFaOk1QYIeIt47JLBXphh1Itfot2ZqtTDzRJAvtOEBV4vnSCW6aat4Ytnh/PZTqiAL4PQhpm/VG3drTD
 Hf699rZi
 OeoyfnteVapOJfRiPy0tpUs1zdwiYkKxl/0zQ7j0XzXyfxSVhY6ftpnDhJe8cEhoCAyPtLM0GAeXXJTWknbP+C1NvuCgZSs2Jc9Ibn3nRmsvQ/McMlmjgfli5ZIMr/yxhcA6Y6HXZnkAwUe+dLeWPEEw0bAg8CrieW3PD7SniehPFlmu5vF7Bpj/jmDQxT7KxpocOr7PtexBZx33g2rIEgFrCYoUsMX6VFbiw2xZMDWtHqFPd2hmHTyLDuVHGQYhTlfqhSqJDTYLK65tq5lxCpOsL34hVvq+GPOjOSi6p9VIFcDHrOER/i/DWl2k8mQKXoBziBT0q9Ucf+5bHW0C0r6yRTDi6pul+5dD2E5mBsgYjbmJGZxSzh8/QyJMynyd7PjLYgIb+kFUf/iTAQ1v2NVV+muVQ5++wkqmvhZKlcF2x0EvyZx88YnxvIsi9u4/UEQuASWaGPqSr1zRcD4tyxx590S3yD3JoPEHD708dNz2KcZwLVW7gk6C2aA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.08.25 10:59, Mike Rapoport wrote:
> On Fri, Aug 22, 2025 at 08:24:31AM +0200, David Hildenbrand wrote:
>> On 22.08.25 06:09, Mika Penttilä wrote:
>>>
>>> On 8/21/25 23:06, David Hildenbrand wrote:
>>>
>>>> All pages were already initialized and set to PageReserved() with a
>>>> refcount of 1 by MM init code.
>>>
>>> Just to be sure, how is this working with MEMBLOCK_RSRV_NOINIT, where MM is supposed not to
>>> initialize struct pages?
>>
>> Excellent point, I did not know about that one.
>>
>> Spotting that we don't do the same for the head page made me assume that
>> it's just a misuse of __init_single_page().
>>
>> But the nasty thing is that we use memblock_reserved_mark_noinit() to only
>> mark the tail pages ...
> 
> And even nastier thing is that when CONFIG_DEFERRED_STRUCT_PAGE_INIT is
> disabled struct pages are initialized regardless of
> memblock_reserved_mark_noinit().
> 
> I think this patch should go in before your updates:

Shouldn't we fix this in memblock code?

Hacking around that in the memblock_reserved_mark_noinit() user sound 
wrong -- and nothing in the doc of memblock_reserved_mark_noinit() 
spells that behavior out.

-- 
Cheers

David / dhildenb


