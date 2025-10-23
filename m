Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01341CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6278E000E; Thu, 23 Oct 2025 12:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49D9E8E000D; Thu, 23 Oct 2025 12:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38CD08E000E; Thu, 23 Oct 2025 12:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 253938E000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:13:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCF8C129CC0
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:13:33 +0000 (UTC)
X-FDA: 84029874306.11.2311E38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5350C1C000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:13:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O4kSxcFr;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761236011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ig3HQ8bYhCVLH2BAUocbNQ6YHiWBZLmjBb9TUrUsFyA=;
	b=z1EP+dA3KQeAkmjTep4vRJaATd0Lx898t6KFywmhGn4bhGTlSSSje8vjEJgkRH8APB2u56
	PD+KjbDSt5GRFqwkbwPZ0dmDSKwHUUqRfatchdhcpkLjAPW4zqoD1x9PIags0RqgeeNi/D
	JxQ6Ft7UBgiOWIdjQloSHTQFY4iWfHc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O4kSxcFr;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761236011; a=rsa-sha256;
	cv=none;
	b=fSQNaVAjfjNlJV9xWP5VjsdYY2su9bkB5NTDF5i8tOKSavRMTygH73K7Mb0jNBQvpAWPqd
	yEtzHZtpxfiqktAopeYNpZJXe0EyQurJkirAyhHpYuCzEbIGXL9tIke9tod0mfadGJpeeR
	senEl/rYnHe0tNfHTtQLJJf66YKIDeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761236010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ig3HQ8bYhCVLH2BAUocbNQ6YHiWBZLmjBb9TUrUsFyA=;
	b=O4kSxcFrYrd7qBzsgs0fVLd127wpkN4f260T+XCHedTgToTNTnzbPfg2V1CQX5Ejp6913X
	inYCXNMPsonIPxsccZrTdLK8c3nYRh3ln4lT412LDD0G6IhnjEA7E8TxdxN/QRfC0pSN8C
	nF/56cj4tZ79fm9e09FFZbkdJ0/wTmA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-246-UevfMEhJMnqkgz4BrfD1Og-1; Thu, 23 Oct 2025 12:13:28 -0400
X-MC-Unique: UevfMEhJMnqkgz4BrfD1Og-1
X-Mimecast-MFC-AGG-ID: UevfMEhJMnqkgz4BrfD1Og_1761236008
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e39567579so5261545e9.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761236007; x=1761840807;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ig3HQ8bYhCVLH2BAUocbNQ6YHiWBZLmjBb9TUrUsFyA=;
        b=qj+5ZINECwuEgVTLfcmoSx32WKbn3xbuL7HOPlFCVu1mCOzY1y+RHn6l4REFYGZjR6
         ySL6TOQkT+rnhB0zK6bwe163vpD5rtpTfH7yzLzv3KKEAIMCKTNVM35cNcNypQKrmoL5
         p8USvirr1OmofUhqPVPT6evJERBlAoRhCllGLJbbhh1n6i9c8bTgR+K8mTlt/Iaojd6S
         fJVwanEV54qg3M8NicjW1niRyHZ3FmanN/4+ytIHe1PSQVi3x3JQMSPAuFoQW1XZlUlR
         oTO7vIlpU1q2Wv+wq7y9QKfOagt4diEgr0MdnjElrHEbgLm10VD2sw5I+pkFUdyajn/O
         Klyw==
X-Forwarded-Encrypted: i=1; AJvYcCXd4+H/JdE7RSu4bZq4c6e/BlyLBfMlioxp7pEhpLMm9icgqk49hxUpnN/GD307VTXWSKGXxWMGwg==@kvack.org
X-Gm-Message-State: AOJu0Ywcalzqxgm0vS4/OCG9AgcyuLpGfKpM+zyo0MsnMtkPFGvpZmLN
	VeijC2Wp3KgShSXIuYEd/Wn0kR/mYcD+Cx81DW/ykWFCE27XkNKtjTKth4a05gKnvuIV+RDjBYS
	qPwT8mgqUDoCQR0soJJe9altn2jWJML3FQ1bciJzvLwOQA9b10Gi8
X-Gm-Gg: ASbGncuGEyYLOLrPixEAjsQOWBBWfRY8b9Oi4igmkou8w029fFPx5JV3s/AcbpkoNoH
	+OqraRQHP1HsNrGoz3ExycB22PEz4MButfqNpnVHsXheBkdIGkBxrwvWRIT4ySL/1spykNO3dXK
	4mtQzVG0GaXC8kyIWQNUZNdibSOUacrcpYQ4ejPbxzcaHX/PwnzQoaB/65/ghtv5hxLlT2v5wbm
	ovfDPVLnoryCMVLKUZs5ijV8ud2jYIwPzXq3sXSvVfzg7g4k6WVzlbT4Vlr9rI+eHP/Waq3n179
	vB3tT/24ZD4ObpdnbCQf7gpJjQYAfhNW7cBwCVgkOFoa+xjuPYh1w4LByhUmrAZ2qxNMPaaLSUN
	mdikTrUsj6YKV9hcpz1sq+BVWEuQLZBqzAC0GewVl0n/oYuuA0ffMKcc7hI/Ks5eAqGJPxIU6Jh
	VLUMblMKxLOlICt1TLY06o0u6hyvE=
X-Received: by 2002:a05:600d:8231:b0:471:1db3:6105 with SMTP id 5b1f17b1804b1-4711db36173mr118253955e9.33.1761236007588;
        Thu, 23 Oct 2025 09:13:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIBFxSSw3+IKAFXz0EGdOjGrB1iGECsd05YGqHD0B7YU/PNcL8LH4TmKfjCrviJIPRDDTiVA==
X-Received: by 2002:a05:600d:8231:b0:471:1db3:6105 with SMTP id 5b1f17b1804b1-4711db36173mr118253775e9.33.1761236007181;
        Thu, 23 Oct 2025 09:13:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf4642fsm42674025e9.17.2025.10.23.09.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 09:13:26 -0700 (PDT)
Message-ID: <774c443f-f12f-4d4f-93b1-8913734b62b2@redhat.com>
Date: Thu, 23 Oct 2025 18:13:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/shmem: fix THP allocation and fallback loop
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20251023065913.36925-1-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251023065913.36925-1-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U2Lg5k-weNII9HV6l_WyK6z5hhf-BABFDBuafdNlx1s_1761236008
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5350C1C000A
X-Stat-Signature: t9ornbwbfj5bngkhxfsmpfineoucng44
X-Rspam-User: 
X-HE-Tag: 1761236011-789047
X-HE-Meta: U2FsdGVkX1+eNmXyNjO8aB4ctzK1I9XaNbtYjtnEO9GuKyUIfU7H2VNgyP2yN8doHCfKmOHryWexRgbJ1YO8YiqsPuIlp4i3qW+HdOeBhKwWISMZzLjaoxEd3uJHMt2h8gO+LzmYbFN6s82rmoh7fNiRbTQeG1Ql+yWa2+kCnoExo0aOWwhOHQI/lvI0SwX75Zt4NeHpwDDSiurFIvp2QJLU6J13CCkffuGjDFy7FMjnAxaIStR6VGD2m2pigTOb8wxQi8WlYR0dZsiZvpJjFuxrrKmrbbEAfbOwSdOaYb1D+cxjxQMbL4Wg9mcQNB+avEfH4BXHncEThyCkE7koFtjKKUhy/ylBpetLJdJ6eGvMYRmfTwuVRFU9bb6Sn6kIlqoZPHfHWgJK4+FIChGTlWmUgIKA8s9jTl2+Dxokr8uu/KePPquI16y7UFaqBwWn0VpCOQqazus9yYlGEydgMU5o7oGMUzRQYea+FHwffzDH8mndVoGP4J+a/Da1ir5RpbMiunSt68SrTrGlrASTyu2y/9gEzQmrX5JMkFIS0iciStfaQUUVXDAP6s7EyWy9Cy8gsR+EsJ2msgKLnYSKifJnjPOF86Knxl9v6N0vTxbGxwCi8ABAS9uxoPQ0oupmKu6nV40oA8BHG6e0JXVdvKaQvABPvK6HwKWDGTJBeoTX6A9qbSEax1NB4hDXW6aHt6dfqfEj123JkX8sGwtW1pLme4yjTHcKB/MlI5qiyi6eAi2GLieZPgHCRJMEKiwP0zAtdIfOiHGlUZMg8MtdAZCkf6imeroULWFEdPdhlw7jq+IV79Hp8Rs/e8ASYiKGzv5C7PzsYU15hCvW5k4HSdbjWrrtTcmPfTxNDzxchBAXeo7xBdZDYPr2dTAyJzHkjL4b0CZSG5U5b7/ybDxlkcO2qhHBvz/uvMjEKLc3SbUlZ79uS/7wDTIK+V0yphU49JKiIoLMWnlZP0KAqe2
 2YnsAZRI
 kV36Bdr2uH45m1LSpCRNNX8JLzEAmyfwq5p16bIDMEN/JAZl/zsj8efRmq2wndnyy6ecY2W8sD8CrmS7e2hZ1mYXFBQBnTBQBMoD595/KiPhH3N5giI82v5tisruy+Bcrm6h738RN1KKbaZw10/MSIegB4kCwwi1EgvcskYefYWZhSnwDLPi9cwFLHZqoDgG0MHPR2fNGIbj7KJyK9KgCYzH6H0tthbfO6w1QYagBIMjH+6vZMSkfhCWMJ5keCWKQu/+aRZz0OExRSxqJH2LlyZHhvFiEPY8PRCgzq87D6W0jwlhBO03Z69o5M0j6iLiE9VwTETjCSx2wNL2jQYkaNOhl8v+jP347rB04E4YPcFQ3bGuHTeiSOF8HUMxr5DzXMrf68UZsVorFcYQuX4DglkQWiMhZWcclFNPOVqJ+DISxhI9MsvLzhk/TEHt0sb0A0DTAR7ndatRB9AAEms93xm1m5xnyCLom6sUK1ar9MQb0S3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 08:59, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The order check and fallback loop is updating the index value on every
> loop, this will cause the index to be wrongly aligned by a larger value
> while the loop shrinks the order.
> 
> This may result in inserting and returning a folio of the wrong index
> and cause data corruption with some userspace workloads [1].
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> 
> ---
> 
> Changes from V2:
> - Introduce a temporary variable to improve code,
>    no behavior change, generated code is identical.
> - Link to V2: https://lore.kernel.org/linux-mm/20251022105719.18321-1-ryncsn@gmail.com/
> 
> Changes from V1:
> - Remove unnecessary cleanup and simplify the commit message.
> - Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-ryncsn@gmail.com/
> 
> ---
>   mm/shmem.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b50ce7dbc84a..e1dc2d8e939c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1882,6 +1882,7 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	unsigned long suitable_orders = 0;
>   	struct folio *folio = NULL;
> +	pgoff_t aligned_index;
>   	long pages;
>   	int error, order;
>   
> @@ -1895,10 +1896,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   		order = highest_order(suitable_orders);
>   		while (suitable_orders) {
>   			pages = 1UL << order;
> -			index = round_down(index, pages);
> -			folio = shmem_alloc_folio(gfp, order, info, index);
> -			if (folio)
> +			aligned_index = round_down(index, pages);
> +			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
> +			if (folio) {
> +				index = aligned_index;
>   				goto allocated;
> +			}

Was the found by code inspection or was there a report about this?

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


