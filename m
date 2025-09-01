Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 085D3CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5718E001B; Mon,  1 Sep 2025 07:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CE78E0016; Mon,  1 Sep 2025 07:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B848E001B; Mon,  1 Sep 2025 07:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17D7F8E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:35:15 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B37B61DEC6E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:35:14 +0000 (UTC)
X-FDA: 83840475348.07.91969F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E97BA0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:35:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oi4kPtKW;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756726512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=89QceRiDVJR9qzpuoMtjZ42nHjE3zxx93/plzyge73k=;
	b=MeKYpqWcqfBQIgE65VLN5FRjb8YxAIhtdq33BiWAWYgO16Ap/PpSQzGu4tGOQtMT9/HAZc
	PNFE4Xho/baKhvQTfRkreJnNGQmpMNc4GVXIU4nUrZcKAY9bozNkRPgqJwaV75SKKx5cr7
	GeSmIlyJmiyvrO1xnnjl49OGNBUPBeQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Oi4kPtKW;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756726512; a=rsa-sha256;
	cv=none;
	b=OBH3UnKLpOKJ3YRNGwrbMyIS3Cjdl0Ua86v8AspHidQV5zYzf8bB1+pBeq4BGJaxrCKb6r
	K4Iq5qw5e8NOShoRCYncRc8uqsi/BoBUuETfIQZUmZsN3jeMt/iIwRtcqsKfKROZFh3f1a
	DOX7XzxZBDH5yEOpJ7Npy6BYxoaOW4k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756726511;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=89QceRiDVJR9qzpuoMtjZ42nHjE3zxx93/plzyge73k=;
	b=Oi4kPtKW6msMclc99VeFrwikaUAGGqFo1qJnSWm3pfX32GugEguMEBTt/RA9KGrQE3tb4j
	YtiYW6OJ1Nf+URcS2bvEOvL21+u3d0ZwUU+NiPfSgFJGlqRVG2YtLvYkpcs3/KyhMvLVUd
	76BrqD6X7mJLnFX2+Ua8oSR8rNiVpn4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-44-n6e8sUK_O9SJnF9oNbyPWA-1; Mon, 01 Sep 2025 07:35:10 -0400
X-MC-Unique: n6e8sUK_O9SJnF9oNbyPWA-1
X-Mimecast-MFC-AGG-ID: n6e8sUK_O9SJnF9oNbyPWA_1756726509
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so40239665e9.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 04:35:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756726509; x=1757331309;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89QceRiDVJR9qzpuoMtjZ42nHjE3zxx93/plzyge73k=;
        b=va7YlKYSV8FfKx0Cth/AY53k7yQZkjawco7F62qIar8t3FqauZq18rD4RlpJdh4jYM
         Dide7tgkvKIwVnfNoAUShlKlhIp2xmfLQbPf549pwZ6/DdnL3kqGyI3OfMHx1e/VsaDs
         zr9IvWT97jFm0mXElpF/c0V2m08coEDeausSyzZSi38cJkT1ProMC0iMzDmgulXCkaWU
         vqhQH6RkVnv2Z0mNpUOBIrQjrrlfI3CGdp8LSb770kGfRVoimbqUABi7gYYWTa5N2Zp+
         A8lHS+gJ+M9vKwlCDYhxikvdTTP/ImOjiq5XVreatYC06UhBb6TCcT/BhDvD1AmQDUCp
         wjZg==
X-Forwarded-Encrypted: i=1; AJvYcCXHl5kJBQFkPNv6yXB2pk7EkE97HsNvXYgkzOdgghcBNbZ1uV75WycZYOp1IknvdJF7bnnN0W9MHQ==@kvack.org
X-Gm-Message-State: AOJu0YypI3eQgi2/OHuU3aB+X1r8ELHYZSjmUUZIBTcdr/C+Ce58KAXD
	FXUY8v1UckekubOkTIr0y0cOnotQ8KEUOOOI+Sbzg7D2tC+vwiS16uXepIQGeSc1Cnm6tS8mkUo
	q2QYm+sTla+igkdjU4oZ/1barTipid377EAnGm0Q9eH4zsHutmjns
X-Gm-Gg: ASbGncvcXc4CVpCn6eMPFaSO0gZtxg8XXQR1lUeXrLNKwdlMOiEwTWCChdzp6CLLGyk
	CJCAOhwHSHiFzuj/6pYv0zhb9H+IlLBLQ8oG4YO7XtRWVtTkqqvjA53cJ2WX6k7p6ZZ2DjfWAiR
	Tp+3mHFICYgMSYNMVq5HORihlZcjrql6ekx8acxeB2YsncCFdFPqII+BwGu/UIGsNQy4nAW35qw
	D2/l5bOMjDxE6gGWvGXkozY0qdM0xuy6Emqph/kLhGd74jOe7oDeVGvbC9Z2iMrq5dGaP7uqz8k
	7A4j5qaAQbcfHpX5mCHlDeOCkMDvNHLXVfhDDtt42XovPz0oxG1zHxxTYL8mjL5fr0w18M5DMag
	SZLi8wfJPbfY+BmHvJZBgzlCsxJI8yIZZwR01Q0a26KJEttZktoSx9ktus0STYHxB8Kg=
X-Received: by 2002:a5d:5f8c:0:b0:3cf:5f17:f350 with SMTP id ffacd0b85a97d-3d1b16f0165mr6056399f8f.18.1756726508820;
        Mon, 01 Sep 2025 04:35:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0RKJ8MgbrMGxtF+aataA+fh1iSiigcyDX0AK/3/6NRoLPIE0BwSmxJshAaTyrpOEmePBJCw==
X-Received: by 2002:a5d:5f8c:0:b0:3cf:5f17:f350 with SMTP id ffacd0b85a97d-3d1b16f0165mr6056350f8f.18.1756726508320;
        Mon, 01 Sep 2025 04:35:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0c6fe5sm233831875e9.5.2025.09.01.04.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 04:35:07 -0700 (PDT)
Message-ID: <44072455-fc68-430d-ad38-0b9ce6a10b8d@redhat.com>
Date: Mon, 1 Sep 2025 13:35:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 18/36] mm/gup: drop nth_page() usage within folio when
 recording subpages
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
 <20250827220141.262669-19-david@redhat.com>
 <c0dadc4f-6415-4818-a319-e3e15ff47a24@lucifer.local>
 <632fea32-28aa-4993-9eff-99fc291c64f2@redhat.com>
 <8a26ae97-9a78-4db5-be98-9c1f6e4fb403@lucifer.local>
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
In-Reply-To: <8a26ae97-9a78-4db5-be98-9c1f6e4fb403@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -GwIMQpIHUhvKnRiVxJIWBFZJXW3gBu6zqbh7HIEovc_1756726509
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jjh4ec4fc1kpdk3teghak5wmfoujo6gw
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E97BA0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756726511-810429
X-HE-Meta: U2FsdGVkX18q8FNvx4UmXJLGrb6JdeRQJLHOR5Wjj7LibYv8OodEIatYoKM5tIQGUE+w1IGXHud7KC9usJifUzHdu41PwPIu/JzCUJzqg/qiUVb5f2YbQZm6KwJGkLc0GFXAd80ZkT1ZNI0jUzuFrTiTlFwHfOmsA2jk+FrdU2h9jKhgmV0DSxCQqLVU76Am50QWHEaUnNuGEtfvVMFz4Ayri+Z58yf7/3hSSSV3rK3M45SALM0HWIWoT+GFAYwzawZBm0HDbBMLjj2/N4gZ91iZ/tRrSwM1RgB4CTAFB8IdJbJCjvGq/XXs+fGIHAuSxxJrotzPycwH+Lt8GC0F2t6KA8+jOA5AL1vIQHdx4QTn5USOOWpMVHPWlfA9EN+lbJt2YuGN7Xm2Zdp88hmHD35BSsYBiCJ7m36RUy7dzSeeN7+R2BCLu/Ten2swYvFHskmyiGzEaRtXh3RxP/U2bmUQmroVLWXMZ+O399kUKMzT3/oMcst79EJEwwRuK4KsAAUptl0E5tw1valdwzQkxwiwgC8mNfvtFc+ixWUES+VyNGUI2s6ZcX6kDyUnDtz5MEE0TEmpChq7ICZZaxPso1jdpY2ls2EbjbhgE9swhGcIxJkbXTsoviVtIe/zzsmtpeJWlpEmIU+B7i+mrR4kyG3Iyac81bBe8BstNIJWNOuU84gZs66O7kCxNaFmC19ChqLDiAVq2FGSqpBe2w/G4Ro5XoGZRYztlYRKDaDGFNXJBhBlXpZ7w+Gan56rkqKBseU9O6nJuRWqxq57plO7RDzvypj0idOVV6s0eIUj84XV7L1yfGHHQIB8NpQC+iYAFjrcBRjgYs5bVEDFDUaTr7EYuMu311L4E9uO8yjEAxxl+5XEXkBiudbO7D+6VyvtpFK9uj98ua9ooCoMHJhKYbHyqCJisFJMQeey7kLzgWvMaeTj3W9Qpr/VjLm4OMgjqvbeFa3wOvgM3fm77mk
 0997jgfK
 8ZX22jrQbee+k2GzetohNkx5w0VUrAnInsMmRLc/LslDaexeVFXr0boN3pIpsi3K3kmYQnAKkMRtQHhgnLS0rBy/M4rEuG3QsVU6wAi30pSeyWP9S9zCuYrhPF0gcZ3eluGCxVm4VEerk3T4cirpZpYQvcM8IztgZ9x5tuihxjL1VgoImGw8abBWzVLfneaG1nXT27qP+SshqdaPK/E/nedImeFaWBOLgK+I2ajOkAZqKjStcL9BuGJhndLa1ETe7T4cEwn4AwSzyNmvl7YRd+K/cYBFkSgtzrAJOGHTD/cJRQB2RjE3HyqSowCXXMGPE1eoeBMJbkldjjdeStpv4/qxcoOTAVZ0hP88To1hjMu4vmoBFgp2PgJjZjcoo0z2N6Ma4wu6AlZ5vBIMAO5lNuYmD0le4TroYT/4pb5MyfAZ42rdx5HhyptkzPdLduolFn3gbCNaNx9HUM/eCYB9pCb7IEIcTj4VQJYutq+JTMuJ4C3okM5x1vWeeNEf/rJGG7mfrfAcMyA19dNc1autAhmA+kWVfciW/AIPDqvuzUt+lM8xoXXQj86/qbZgMulxGwbwNiGTe+5bXhFzstHPdXl1NCA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>
>>
>> The nice thing is that we only record pages in the array if they actually passed our tests.
> 
> Yeah that's nice actually.
> 
> This is fine (not the meme :P)

:D

> 
> So yes let's do this!

That leaves us with the following on top of this patch:

 From 4533c6e3590cab0c53e81045624d5949e0ad9015 Mon Sep 17 00:00:00 2001
From: David Hildenbrand <david@redhat.com>
Date: Fri, 29 Aug 2025 15:41:45 +0200
Subject: [PATCH] mm/gup: remove record_subpages()

We can just cleanup the code by calculating the #refs earlier,
so we can just inline what remains of record_subpages().

Calculate the number of references/pages ahead of times, and record them
only once all our tests passed.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
  mm/gup.c | 25 ++++++++-----------------
  1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 89ca0813791ab..5a72a135ec70b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
  #ifdef CONFIG_MMU
  
  #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-			   unsigned long addr, unsigned long end,
-			   struct page **pages)
-{
-	int nr;
-
-	page += (addr & (sz - 1)) >> PAGE_SHIFT;
-	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = page++;
-
-	return nr;
-}
-
  /**
   * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
   * @page:  pointer to page to be grabbed
@@ -2963,8 +2950,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	if (pmd_special(orig))
  		return 0;
  
-	page = pmd_page(orig);
-	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
  
  	folio = try_grab_folio_fast(page, refs, flags);
  	if (!folio)
@@ -2985,6 +2972,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
  	}
  
  	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
  	folio_set_referenced(folio);
  	return 1;
  }
@@ -3003,8 +2992,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	if (pud_special(orig))
  		return 0;
  
-	page = pud_page(orig);
-	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
  
  	folio = try_grab_folio_fast(page, refs, flags);
  	if (!folio)
@@ -3026,6 +3015,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
  	}
  
  	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
  	folio_set_referenced(folio);
  	return 1;
  }
-- 
2.50.1


-- 
Cheers

David / dhildenb


