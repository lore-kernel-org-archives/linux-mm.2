Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8071CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 12:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292976B000C; Fri, 29 Aug 2025 08:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A136B000D; Fri, 29 Aug 2025 08:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1593A6B0027; Fri, 29 Aug 2025 08:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 053C66B000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:00:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90FADC0660
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:00:51 +0000 (UTC)
X-FDA: 83829653502.01.F7F7DCB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED5A5140014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 12:00:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YeVBDPsS;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756468849; a=rsa-sha256;
	cv=none;
	b=5nmC6+UmgzWUojjlubZwyFsYvgkTD1kl5w1+x4wIR1dDfZQ1AvJ03JijPzSyZsPzZwbrrI
	B9RfBrlzb1fmFWLUE5dYlogGAcklbYGyXU+Mj3996ozC+2XZcxjxFZNVxRcfJ4fYO+LDsI
	KZDmSyHMHOQMTYwOMLfk0RgnCnOMMOA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YeVBDPsS;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756468849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WRODc3MDTNqLHIXQzOQ9QRmb2QGRyzsJAWu0HJ+lHgE=;
	b=mgZW6rpvLpSdHwoqQjOjL6UV3qw5NvDalTpfZymFA8V+M3kAzqqL2gQNqDH6p5Z/6SSCAm
	/aG+Qjq13TnSUIFVMIx9IjYBUm3E6O2EU3zJwRU6lvNOoHRm+HniRq7BWWN4I8PXWuJJQe
	2NUdjr3jZupumbTqvCeeSp17FjyBPrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756468848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WRODc3MDTNqLHIXQzOQ9QRmb2QGRyzsJAWu0HJ+lHgE=;
	b=YeVBDPsS7XEW4XPkwZfLsQCSQs4+XTM3E+FrJV0D94+6JPvosFvSwS4mh6pxrrGrcUpMtR
	4mGOR+whKTtfYpWTZI2KiQiSeXJU5n2u7xAAZK5a6gieK9v6guwTT6TimzAlm/1OkKcYBZ
	V7tA2NYl/5A3TRUo1dZGN+M/wYhHmnc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-jS5KtMO-M62MiVFHk_llqw-1; Fri, 29 Aug 2025 08:00:45 -0400
X-MC-Unique: jS5KtMO-M62MiVFHk_llqw-1
X-Mimecast-MFC-AGG-ID: jS5KtMO-M62MiVFHk_llqw_1756468844
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cef6debe96so629582f8f.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:00:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756468843; x=1757073643;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WRODc3MDTNqLHIXQzOQ9QRmb2QGRyzsJAWu0HJ+lHgE=;
        b=l4VGzEmUp/Kfjr8489q8vkI9hDUrjL2/AclSf5DYyKsfzI4xTfvgc6ahrACrw1BtcJ
         uRf6PVv+ma1HwxE+ZwUOg5+m7GzVsSeWdOYQ8P1vE7dleUlM8X1l29FFKYgm5vHQyjdQ
         S2DfqivgL0D9qbGx2ZVO0mJys7GSnMyyp2twZDqzoxDo9w7LrvEMJbVITkHTzMIwJklj
         nTns52/XsovfjOa/ouci5e9XT23Ze7ZdezV6nmxr+3wDrJv9yAM4Bvn03xT+dkMpNDe8
         9BWvA2c20eLcb5sX6O7TM/+9O8lKavtCinQ1kn/AJTS5mZ7y3/2Sxj49kYc15rkA3G5f
         mU7w==
X-Forwarded-Encrypted: i=1; AJvYcCW/GTlzXIH1fiYp3M74hfeRSfE0ByWCw3Y5ZL8vJnlFps0cgRGt1yAVKW7gObqImT8LVw74OBVtJw==@kvack.org
X-Gm-Message-State: AOJu0YxIianxupQZgW01k6wxHku5Liu8GzvShFTT73qBGrCMLg13Z5QB
	0JZGSCiaWhxxJ4JdMNLbgWBdpLL0Dl5rgvekDL1K+GcfDQDD/34sJNNpv639A88rqjr6LzqcUFj
	Q9d+N+oMDwio/t2E7wLXS02Xp2k5dsGS8TVolPCkxoIVKenZY6jIr
X-Gm-Gg: ASbGncvIVZeGHm+pj743ZfhIWaIOTVhBumO73k2n7OrXnTHzLt4atYWiAV3RZF2MKTc
	am84KsUTKWHYOl7yQuiSII1uNFCT3FOE8X/y2pPBoS0iLS+q4q/kcip/9v3/JdwnVkv5cajlF9s
	fKDlrfwK8CEx1cZIGCpDIFuGdYex6DhNWjHFEwGLnx4vqjeHPEWVTTPvqY0g1b9QyZz8jBnjgM1
	6RWeWpl6qjAG3C7brqGKc+axw+Q25+unhwm0pYhtdn9jGs/oS+Lmeqqe1euTbtTkoFzYTDfxcdX
	hBG6MsDwMQofwjwMQt/IZgaSR4gxNWZb8JaBV3q80plyp3tGB5BMwT732h6pKF94BDCl3K21Rg6
	SRkqkiD/0uZfU/SIkIJwRFxAGzKMrUYOQMuUaASBSVJyQqNY/MTDVz82TTo1VUm8=
X-Received: by 2002:a05:6000:4382:b0:3c8:89e9:6ac0 with SMTP id ffacd0b85a97d-3c889e96e1dmr12052196f8f.3.1756468842737;
        Fri, 29 Aug 2025 05:00:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRdmd8Qo16pG8X+TFP/6YOZ+W4nkc8QhqQPHcWWiC5lStBhb4N+Shci4juwvPlMY9VjElJMQ==
X-Received: by 2002:a05:6000:4382:b0:3c8:89e9:6ac0 with SMTP id ffacd0b85a97d-3c889e96e1dmr12052085f8f.3.1756468841352;
        Fri, 29 Aug 2025 05:00:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf270fc0a8sm3118235f8f.7.2025.08.29.05.00.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 05:00:39 -0700 (PDT)
Message-ID: <d0b06885-9f04-483f-a7e1-f197c8431491@redhat.com>
Date: Fri, 29 Aug 2025 14:00:37 +0200
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
 <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>
 <aLAVUePBQuz9D89T@kernel.org>
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
In-Reply-To: <aLAVUePBQuz9D89T@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1HCBDvUq65ScdfHnlH-ig3YS_s7CDi7qMusAo1zyrDU_1756468844
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED5A5140014
X-Stat-Signature: 3ard5i7jhcqpid5nmi3qefg4gz9dhnjr
X-Rspam-User: 
X-HE-Tag: 1756468848-419503
X-HE-Meta: U2FsdGVkX19vip0vJ9E2OxRz58xPgGK4pgZvjjzl0n7lR2YxOICjFcN9sfgiZgGEhQJkFcV/gxLqJBWpM75L8rS2644Nv05LzWY/VNMOcTr/2r+nDI2hWL26dDG+tjABywir4RjGbXkkmXHDJJR+dBr4PXcUONluudnWpo61L5x2VUXPj+MlsXkBkZTp/VIHfXnYQIVeygdGQOMNZez7v/ejX4E6k/iy2jsQ06fQcYnJsyNG9fcJnmULfgT6pUXvYxJF8ArLvniN45GbOMOhIsGzl2BJOYCzrchmLa2qap+BTcA3bLYkF+SzDT9FylYFrJO7qRM+VyU5wAEy4p8/LaDP+8PNGXeec3bcqJ+vYAX/NJ95FL7MUl0k3jyC6g3ek/9UnYAIxTdGBpL1zUNpb6waCFtQrunhgkOrBABq/yLth+yWH5/f1Cm/jMivy6gvbCSyIlY+fSAS/WPt3uHV7zB8bK0EyWHG2kzh2GksvZsOOX7lQ2LoxBlGIGok4dKeyXGxeVK09SD34UF8bQnQLL3TiYdl4jnQ8jWbm7+h6zdbiYZPGn1U9RFGz8Q7G543yqkRyQYcUeNy0czmh3jC5cBMUfVLcxLpZ/1F2Y4aiC1PjSbtNXip2K+WQKodM1iq8nwXt0d6fI11LSas5FdSiyi9AjkYJLR2NtA3YhJ6QQkW1QO9vPwq39UyO3UVZCynkdtpdyPkHefA3ZUNIQoZiobxZkBNJdCxF62h9iEYdcXyGjg18FX7LE1PCNyZmyTov8ujVFng7j3dQzV0cH4bIvNxbQLoxvwwXkykGZqBGfNMUuX2iJICMJc0MD6elS3FXm3x3DpFuz40oLRVUnhVUIGDVWpsI58IXdBUyly8rBQ2bnENiB4TH50tUMqNXfNRxawQo3flU7GqRnggApVNSMlnnTS926fDUb4JxbPilmX3QTH022k7Ai1hEpMKTGyisk8Nzj/RRK9RZh2mROy
 RWb8cysA
 AKIKRldps1mjpPMQeoZCRNKCSLFzmsIVFa3PylgKRQZM3VCLgxf2Q0IPFYCHwNROTZK0CJNuiGyO1pS8LBRBk6l9tT8iu30XWb7nANlvwLmjk0c4zcCwXQw93WyCJnxXDl5uax+22qI7Ani3q6FLdcYAkRQvjqpFrF+yBic1xdy2IPfE5DkRTSxTkZlf4it3E92ev+gZg/JfAEQv7tToeldM5hksOPppVHtXfRf2Pk/aBxA7IqGjPKPkJrK0rLfWWUse2NBr6QEzQRC3BqmLNEZiOhdfs32JMW5k6TbYrR2lYsBfotGUJlkSN4BDuRKHMD7agPI0eK6BETfJKMT03Wy6eW9DmMXREgJYoFMq7zhB5Cxs43CcKmye/ZdXM3wAzq7E5W8wGN+TULXXUgP1Pp8rcuGHvYE7dALR/5TxpI+mrN931VM1abiAhDgkMYrK+19B+XGIwr7lG0TgH5lwoeSy7DVFU6v8N/puTIZzIShKmgnsZG3IMyYB+Kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 10:37, Mike Rapoport wrote:
> On Thu, Aug 28, 2025 at 10:18:23AM +0200, David Hildenbrand wrote:
>> On 28.08.25 10:06, Mike Rapoport wrote:
>>> On Thu, Aug 28, 2025 at 09:44:27AM +0200, David Hildenbrand wrote:
>>>> On 28.08.25 09:21, Mike Rapoport wrote:
>>>>> On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
>>>>>> +	/*
>>>>>> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
>>>>>> +	 * so these pages are completely uninitialized.
>>>>>
>>>>>                                 ^ not? ;-)
>>>>
>>>> Can you elaborate?
>>>
>>> Oh, sorry, I misread "uninitialized".
>>> Still, I'd phrase it as
>>>
>>> 	/*
>>> 	 * We marked all tail pages with memblock_reserved_mark_noinit(),
>>> 	 * so we must initialize them here.
>>> 	 */
>>
>> I prefer what I currently have, but thanks for the review.
> 
> No strong feelings, feel free to add
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 

I now have

"As we marked all tail pages with memblock_reserved_mark_noinit(), we 
must initialize them ourselves here."

-- 
Cheers

David / dhildenb


