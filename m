Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A326CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F456B000C; Fri, 29 Aug 2025 09:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576C46B0031; Fri, 29 Aug 2025 09:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465828E0001; Fri, 29 Aug 2025 09:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 364386B000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:44:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5CAC1DE907
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:44:35 +0000 (UTC)
X-FDA: 83829914910.16.3F42699
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C5EE1C000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:44:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he5uiGXu;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756475073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjuXMBMcmzq+emhjc+4nz3INVtnsR/3o1W/HmfSMpGo=;
	b=CKQalG3FpGIIKRjEEt/LJrvDtHYxWaQvEtIPSXrgB21f9rFi47g6FaIxqnoKN3w04Qvjmj
	/Odmq9g7Vj7XlZeg7LWn80nHlzJLXF6bB6c0upEZHxlnIId4xVtRkNdWoejyQcUURH6Xvz
	bO65iQlfS2b73n2+ZmA28DqBSv4+9jY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=he5uiGXu;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756475073; a=rsa-sha256;
	cv=none;
	b=ogOIp4DTyDwyKFrQu5EhzLqT6gMFRjgdqudr5km7PDu4K2Cy9QAesBFj8HEgbCqLVt0E+5
	jB0yZpNMIK65M8TrwY4Zr8A9F04MkPm/asK5dfUqS+E7QspjeXkBI4ZMIpulLWDX/fuLbC
	MrSVqcozht6VFQOZoulXDfxWNwhghYc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756475072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qjuXMBMcmzq+emhjc+4nz3INVtnsR/3o1W/HmfSMpGo=;
	b=he5uiGXuoZVFWxHoqiQBIkVEb19v9W6FNxLMCdW6YthKbiR4YQWriKzkqdLBBQ5PYcd+QL
	HgsMRkFsReja8qyaHY56dRkhRuVldMtCvBY1qOKtHKjn1ojfi9AZ4NCFWiqyX5BDfIt1b0
	K83dTL3Lcr3vF/a7rc6nDUX3JyNAfRU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-F27otpL_NJC4KQ7rWODInQ-1; Fri, 29 Aug 2025 09:44:26 -0400
X-MC-Unique: F27otpL_NJC4KQ7rWODInQ-1
X-Mimecast-MFC-AGG-ID: F27otpL_NJC4KQ7rWODInQ_1756475065
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ccfd90630aso955182f8f.3
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:44:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756475065; x=1757079865;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qjuXMBMcmzq+emhjc+4nz3INVtnsR/3o1W/HmfSMpGo=;
        b=bdlRfkxBBegZuylyiNfmH2pILSJivF+VWyjN4z43o1xbkXEGhnvJhxnmqTidoN4IOC
         IgObVlnLMjTeYyOJLP5pFI81xWec51iE8srJfmSxE6BZD8Nlb8m/wD3AMODyMuerHmV+
         rcP1wMtpbhKDSkYjL7Nt379QBJUYU0dIngTuQIK5RBrjnjimDQUR8TLOLAJzHpMgqTnB
         wm14TeVJQi/f+XgCaApqzACJKJ7xTm2qGu8DolVIaNYplQBwT9trK6gb6vSdS5hQM7pq
         ge/XA2cA/o04ylRu1+bLKHbTLXsaFUnc+U1KLnPRXGfnfCO94/YNjyvPVfnMikweSmDv
         6ZnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg5ViXsfJjL3ho7aCQYJxaDhpUTw/bSxAPI+r26G3aTCVzhUgVVmj55d6J9q1bTpBa7ZgfxkSdXA==@kvack.org
X-Gm-Message-State: AOJu0Yzmdq7+NL5lNPjEBS8w6kqAQmKso+uF9D/ODVNeV5OMhMZt4qqn
	IPBrLXL9PWgE2XtxZtK20wIbTiBmWejZ0VF+WCeOtiw33ajrSY8H58EoarYnSnL4zYf50g3NV0C
	wgU6ZTzPfezpGHBiTGJVJYRHHN0tv4eCgpl1ETWvzupSORBF8/p78
X-Gm-Gg: ASbGncvToc2PWXwQgXuoskzQrCEbrcQ0EO6/qBrRHeDHIFbU+6rFXhqcFx6+ppOwK0y
	pS9GWf5mrbGz6/ee7jkP3DQ5HMliMevcmJLEdxKPpAIkpiur/VScdEmuFuCPVdYHe0i7NaF3M/l
	5jaWB5d6i+JhOWfFJ1t6ioRAuw884ArH/5+3/vdxJ+VGcnjfWj2+Jp9WtZxkE9ToFZRuElas1NQ
	uB4WBFsZg4dfSrQbNd/rxTiBbXXuuDC0yIYFC+ZqHZV7wvLR4whnDVRzGxNPG/EdnPHjo52SaS9
	M70CRkvr4JJGlJWEw9U+J/AQhaqp+nkllzDQBIK2bxxqDy4lz8FpWFiOrdfeidiXHX3iWLUn99k
	3CZIWSU6bIg4Q3ODS7WOdsuf8FlKpdM/5LZH4xRQWSKFUK+81BRgO0o869ilQUEd7
X-Received: by 2002:a05:6000:4383:b0:3b7:882c:790 with SMTP id ffacd0b85a97d-3c5dc73625cmr21478728f8f.37.1756475064939;
        Fri, 29 Aug 2025 06:44:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+LDG7SGqPVe42ftCg4HBC4EBVhYJgcuG7xRsE/56l9/NNaGo5xTMXjkE7lTdlBAQ5z49MkQ==
X-Received: by 2002:a05:6000:4383:b0:3b7:882c:790 with SMTP id ffacd0b85a97d-3c5dc73625cmr21478675f8f.37.1756475064268;
        Fri, 29 Aug 2025 06:44:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c22sm121018675e9.13.2025.08.29.06.44.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:44:23 -0700 (PDT)
Message-ID: <e877229a-ffd8-4459-a31b-ecabde28e07f@redhat.com>
Date: Fri, 29 Aug 2025 15:44:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to
 __flush_dcache_folio_pages()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Alexander Potapenko <glider@google.com>,
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
 <20250827220141.262669-21-david@redhat.com>
 <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
 <2be7db96-2fa2-4348-837e-648124bd604f@redhat.com>
 <549a60a6-25e2-48d5-b442-49404a857014@lucifer.local>
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
In-Reply-To: <549a60a6-25e2-48d5-b442-49404a857014@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XvOlkfXtUz5IRgfSuTYbScJNYZ1ca98Gf4-bPko1v7g_1756475065
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: co91kppxq95s3muxowm3myj9x1zoajfx
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C5EE1C000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1756475073-562505
X-HE-Meta: U2FsdGVkX1/oZFkhBliPknetoQI79voqb4UPlXDycD/inCeYDdudgE0PEF8vZtgFH5aoUwtAT1jVsQPNgcI4zBtjEAVbj0QdUCouz48yHywjI0+4kjRfG9cX+B6QRraCSnRjQEk6d9saVx1fkoLUhXjmxnwO7gKWwdMzqlq3NgIuXW0azhENjTI4lz6pYtffMsmW2dkK3kwFq1ApTAHTqwaH0d0CElbREVS/quNSfp/wsSqmtDR8Kj4NbgrKKZOSO3xztPvlzZ8D+2aSqkmYtoL/1JnElLSjPngxadBSVUAxJGW/LZ2XgpcuVYmdolLGLUUwI693DPnUZfoCpUiEqzEVfhtX8Mp0SKfQ2yJhQ/miXGkRkZauU/UsgQFHtCrH4EIFzRj46Sm99j0vMUtJjotyQ8Dv51IsQmenlpbfdT/Wrmp26c29jOfRb3Ww9Z30Ym+IvZk9y8z6WP3eehQv98AYSCsX08VtNSmWE9yK4cYhKxHsxl5rlBr7NfnXrMQ6KQh8ygXh47AbimITifM3BbtI7Q1tEM26kO+m2sDAFIGpscZKTjFMt61JA/Imldvs6dJlCujgK3JIxSeWdfuSeTgVeekUN0hhwaq9X728v+lPet4DwhjkGnSq0+F/fK0NZ9BsssK/Kao3R7ZtFnmqa4EyYUq+kHE7r0/jfiEwDSPAXbALg79R48EgfvLNa1wx4UNbmVHdzbqonBOht0Dlwtdnjkr/ell15MkB/03TIDLYFxZZyKwNBZsFNPJw6Bv4kx907VGUvrspDaeYie1hxidw6WZFJ1ZqjcA7PaSQlNzmIddGSl4jvL43hyWtxdAs1QBiZk9H+LL36RLezXLwLrJ6zZtGEUAHijIA2P4WOGfrruXFVz7M8zmdK/6xFm4gSFmN1Xt7dFQgNtYrUsXYKpEzw3jkUCTmPz0iWkTyrn3KKZNao+53/LVJTxkwm0GRbamDi3koHnyrnOiAvgg
 m9jTV8/Y
 dh9bCvVV4wOGz69luGcM8SZWZKLvCE0NJxrZtgjjt59RfYgs+IydolfoaFHNNFCV22ULxxPDVDbKWFnrXZ2RPScc+C1gZvVAt/MMBU3JMttT2l3V4n2wvt2LgmWsWmocUXv+39qnnINAdQ8dnUhL32dW2iI/Yd1Knq3L5OIsmOpDihcMqWrYee4ggxXeXestbCHad67rWap4JkL4iUiw9sMsqUj5QyE7D9CGfrjXtYw1HQdr6ty4Cdbh6+L7TVbxp4ZJkq2r5rnEkst0v8gTenGI3Gfh0pzDpL8oYnmwqGi86eKuHR7XwHK6MuYFyniw5+rIogEYBSlVPI74TlotVK0TUoJJIdRFr24oVRTdBsunDmchwsD12Ufi92i7tcoHUbhfBcQRD99eO5RRaJjQRtJCKFBoY9PDQbjRaryfxXR5eg2vxAvwwFkZFg9tak1KvBws3RvGYt/JbvZDnD9MlzHu+ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 14:51, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 10:51:46PM +0200, David Hildenbrand wrote:
>> On 28.08.25 18:57, Lorenzo Stoakes wrote:
>>> On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
>>>> Let's make it clearer that we are operating within a single folio by
>>>> providing both the folio and the page.
>>>>
>>>> This implies that for flush_dcache_folio() we'll now avoid one more
>>>> page->folio lookup, and that we can safely drop the "nth_page" usage.
>>>>
>>>> Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
>>>> Signed-off-by: David Hildenbrand <david@redhat.com>
>>>> ---
>>>>    arch/mips/include/asm/cacheflush.h | 11 +++++++----
>>>>    arch/mips/mm/cache.c               |  8 ++++----
>>>>    2 files changed, 11 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
>>>> index 5d283ef89d90d..8d79bfc687d21 100644
>>>> --- a/arch/mips/include/asm/cacheflush.h
>>>> +++ b/arch/mips/include/asm/cacheflush.h
>>>> @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
>>>>    extern void (*flush_cache_range)(struct vm_area_struct *vma,
>>>>    	unsigned long start, unsigned long end);
>>>>    extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
>>>> -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
>>>> +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
>>>
>>> NIT: Be good to drop the extern.
>>
>> I think I'll leave the one in, though, someone should clean up all of them
>> in one go.
> 
> This is how we always clean these up though, buuut to be fair that's in mm.
> 

Well, okay, I'll make all the other functions jealous and blame it on 
you! :P

-- 
Cheers

David / dhildenb


