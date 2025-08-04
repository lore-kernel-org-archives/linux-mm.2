Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9EB4C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:27:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD126B0099; Mon,  4 Aug 2025 08:27:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE7A6B009B; Mon,  4 Aug 2025 08:27:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D626B009D; Mon,  4 Aug 2025 08:27:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE9E46B0099
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:27:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A49BD114086
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:27:27 +0000 (UTC)
X-FDA: 83739000534.23.69E72A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FC0280004
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:27:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fCMjuonE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754310445; a=rsa-sha256;
	cv=none;
	b=tFUewt2ASs1XLMkFrPiARq+vFVxg49lHLaxWTSsED0k8OlK0WaVk5zZLyEotO5Ov3xz0s/
	uBiyn7KW9Z+bqnnyISqL/51/8pVcKVgaSqCmeClgi/AXYIcKFvudVutAnm+sQTulsVCciH
	6+osMxL8ugAhIh+kFgyFAPpftMGEH2k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fCMjuonE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754310445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqFNZiXIgVJOZ36O1iRoQqXTFYH8uoGigHQTRA21oeM=;
	b=27HHje8p2aIFAXHZKAQz8lJ+F2wmGG4FeIOMgWikJ+u9A0aPImZ9g6i2DjX4dCA0XZOOrB
	7m61dWcpJobuXbMQmh1Z4CQYxYt6EYScW08jF47MlB45jQWC9QuE4+OkcLPcSbEkU+Rcsa
	HD43tW2F4AY/4fIrA4c/QUz9yyTu68I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754310444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RqFNZiXIgVJOZ36O1iRoQqXTFYH8uoGigHQTRA21oeM=;
	b=fCMjuonE4pQnvlfuYoPeVWZSa9PPYWbAm0f/kY1GGQIMuLErwWmYGZabwQEOmYtDn0XM0x
	CHDHVbHnxF7tYTdl9cty1dv4GE8faTfAobx2Q2ZkeWfu351p/O4sCwXh5xJz0zyW9Xk0Nf
	klUnMiajL/kfl340ojr4cDz+TKl6BGA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-XoVFljOdMSaJ5dMkQCYwig-1; Mon, 04 Aug 2025 08:27:23 -0400
X-MC-Unique: XoVFljOdMSaJ5dMkQCYwig-1
X-Mimecast-MFC-AGG-ID: XoVFljOdMSaJ5dMkQCYwig_1754310442
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45867ac308dso14666975e9.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 05:27:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754310442; x=1754915242;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RqFNZiXIgVJOZ36O1iRoQqXTFYH8uoGigHQTRA21oeM=;
        b=HklUFggFp80FmTh+SrCJkzoWLJ5dsNP3Vm3V5atnRmKk6oGZHAq+GKrtensaEXR6wR
         WJ+4+JqwGIyum8cmNn56o8mM2qOX7ypwqw4EwvXpPIkCG9lY+fD7IE92Cm1AdbP4xDWe
         WPYKwCxuHKT+W1k2vm+4aXt8TlUO3DFt+LJq5BiFSD6glcT3MqRKoXNZVhA8FbzZH+5n
         QSBHmMXWICPFRXGKlH4hDveoZtLe33xik3rOlA/Wr+g3bLXO82hOHNMnSBukbxNGL5o0
         UzRpxYDpAdghznp0EHNLFTSilMd9qon3t5Xs340AgD0B31A8wGAyGKj15nZuXRbhZ2wZ
         eOdw==
X-Forwarded-Encrypted: i=1; AJvYcCVMbgyl25LGtPcQOcDITXhwN3iLbUM9jqTjAS63rDg9IFKebQMt9B+VSqe2p4KB+WTuSg+JJlzf8w==@kvack.org
X-Gm-Message-State: AOJu0YxHc2PKSr9dyPZsrKdgVGywbFpWASvinjVz7/v6rgDFVra6o2Vd
	YEmZMq5MOAqMGc5uwUg/ERCoacS/+JsmLqYuOG8W/FSpAGxYA9NTMCWONlbOAEEro+EKhUCUnoK
	x1hp0SRpvvZBoidGtHvBo97M+YesB6cWPpV45ga3VBydBic7Pmx6G
X-Gm-Gg: ASbGncsm+3qMYFNqDYSTGFMuL3/70NkKM/r10pUhvrkap/YkSHUhn+Pg4uErUHWwRNn
	xi1pCoGvV5HXchfS+4Kkl8ES2YnWu7Oc2YFIPNk4c45NMi9KCrmllvXAkxFtXY0jRDe5oNsspQG
	lF+MgvjD5ZEsRUNLbti0w3A+hkwfUnUQbnbpZNfmOcB0njj16xqXURKqBRjJ213VK+nF/g4CbvW
	9Pz+sLKyv4nN5tkLy42LLZ7ITz+vQ9jHK0tK1qDGXChKvpv3K+I65zqqPfU1tHUVIwgnptE8ojM
	Y4FIZlghFEroJpCD0kXR0rN6KvqsQxiR3AP590f6f5B/HoWbtyIkk91IxstQif6eDzfRyUxzwAk
	06d3eC6qOI6kQfF915sxst4CmXPhOVmF141ThIcPm3FXzAqOSVwlkNyVxI2okCtD3C6c=
X-Received: by 2002:a05:600c:4f94:b0:458:bc3f:6a7b with SMTP id 5b1f17b1804b1-4595cffbec0mr46790455e9.18.1754310442119;
        Mon, 04 Aug 2025 05:27:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPCM5/SLg/IlHDZWJYXx2n14ukB77gslG9uesQCvJ2YvN7U6F/6nCutbjz9bA6HnN1x0X9CA==
X-Received: by 2002:a05:600c:4f94:b0:458:bc3f:6a7b with SMTP id 5b1f17b1804b1-4595cffbec0mr46790185e9.18.1754310441659;
        Mon, 04 Aug 2025 05:27:21 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4696c8sm15148041f8f.55.2025.08.04.05.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 05:27:21 -0700 (PDT)
Message-ID: <1e259390-67b1-4d08-8174-a65f1fc9eccc@redhat.com>
Date: Mon, 4 Aug 2025 14:27:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: fix accounting of memmap pages for early sections
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 linux-s390 <linux-s390@vger.kernel.org>
References: <20250804090859.727207-1-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804090859.727207-1-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4zq-ZYQ0aZOR3k4HN9wge_LqqQOqmgrBu4LkDu4Zf2U_1754310442
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1FC0280004
X-Stat-Signature: jz9z7wbi7jdqmspa8wrr1yp33jbhcurf
X-Rspam-User: 
X-HE-Tag: 1754310444-90545
X-HE-Meta: U2FsdGVkX185DcjJZH3/pM4XjBTQwTO3h0R8wkCMfh7gHkqIO3LRQiGU4pda0GwFwTFxCYuKz6En301BaspMhLk0BprZSJ7iW+bgULp2Stg/TtQ2uNq3VZULP5bCB/T1kmm/hbu1/vBlTipHFqT5dM3b0or2Y41t7Hhu4nI88wJBNAwIus3BGhGdnYYhIgBleKdO0wRX4sMbtvRmze7i0FvCIiKA3Vgdk6GaURP4v4yoUNuSpyj1zSq276KN1urQnK10MRYzBHeuhpNdHVRHt71R+H8RpPpUcuLSqVr5fijEThCOyoMPqENhYf4DM+26vkemlFPXwVaQHrwahlqSa7G9ydjN45InTcPkd82wCFbb1PAgnp+4FkK6Q/n7Aa0IPaJ0zoqvJz53xS/cn+c/4fuUMX+wSxZK7WQZVQgzz6GIwMkGncgQVCGHRyxFiqBPtdD9SpxBtGQt51za7coiaheYbzuxXStNM9J5TH3VZZz+ofFTAKZJaoGB2kpYfxc89ZfUqZfePk4rZRDd3hMM9RvByMr2LIk9e1nvZIVEILb9ZM7cTJyiIWY2REVpwWVOitwQfXnLRzZIEsqkF0oMjR4VJi365uLFZll1ALjBAZ4f6DBJW2a5NFRME+WpckjJeDSE/ESy/nApAXrSoN+uOpm+MIS3ehipRcFlnO1TuexwgBzyIxL1ospqedrGvvMXhMq4J3OJJZ5vhKgiogA0+P4Y5ieLdvN/285sdixtNE6PLt5fVBoU7NBjhOsZgRqR07hXYcZDL7ioZzPdVnR5/sJO/ER8A0USy40NNiUlhZpet+fnfmDSe0u304GMMPHwXnor3VP+9p1+MT7f1RRoOfKRjjGsM9cTuNaslUBarYQB4h5kkB7IUnZdwMYLunbef/L3548d/WjG2z6r170dQdXWHSdw5MrNsjR3HJifSSTNYPvwR8aWHu57o408vnZhb7Z3Kw3QP2S9x+FSxjf
 uutSvVTs
 4JF5BzpticY+ev9i1EvsLnAXmoM86KAr0Y7YlQzKj6v3Ys38S1sIDEtbjXh1mV358ftvS1knyW1PeADKgLzm+dWk5wEt+LiDv5wuEtgp2V2rzftbX4uvsaCbHtWtC4lek0gvH2lG8ITUhljuyOXMtH0AVFz9ZvCoO4tN/Op/rrUxCxe0ROEXrM7coosRvfT5H6OtmjQrab9thHO+3Zav4G6ZkuuWFcdxJ+xh3AkQMDDPt+54vgiyGjBpm4lFm6phuan07rGewjPVWbfAdNe/8Ps+FQpVI9f0vF3hxKBTE07HWxW+RDAcAjl+gDFoMRfVhn0lPFwPTNGg3nuIrSRNtcxF7sO93nvm46q8l/Dc7K2gEKQRHfTfw/uKmRr9Ed5fzt7rTv+czOU3tjryEP4Zzw+8QIkatiXF4tEdU0t3p6008DW/SSo0y42lXs/EdjJA+BvBQKGPZUBkrEDonBhBrroJOEd/+op22QWyMBTzvcehN3wtQzJuhsszEOABeRbxpW1THbZqxyBaIfeMrOwsuQLJAQP+zNrBHim+j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 11:08, Sumanth Korikkar wrote:
> memmap pages  can be allocated either from the memblock (boot) allocator
> during early boot or from the buddy allocator.
> 
> When these memmap pages are removed via arch_remove_memory(), the
> deallocation path depends on their source:
> 
> * For pages from the buddy allocator, depopulate_section_memmap() is
>    called, which also decrements the count of nr_memmap_pages.
> 
> * For pages from the boot allocator, free_map_bootmem() is called. But
>    it currently does not adjust the nr_memmap_boot_pages.
> 
> To fix this inconsistency, update free_map_bootmem() to also decrement
> the nr_memmap_boot_pages count by invoking memmap_boot_pages_add(),
> mirroring how free_vmemmap_page() handles this for boot-allocated pages.
> 
> This ensures correct tracking of memmap pages regardless of allocation
> source.
> 
> Cc: stable@vger.kernel.org
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---
>   mm/sparse.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 3c012cf83cc2..d7c128015397 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -688,6 +688,7 @@ static void free_map_bootmem(struct page *memmap)
>   	unsigned long start = (unsigned long)memmap;
>   	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
>   
> +	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
>   	vmemmap_free(start, end, NULL);
>   }
>   

Looks good to me. But now I wonder about !CONFIG_SPARSEMEM_VMEMMAP, 
where neither depopulate_section_memmap() nor free_map_bootmem() adjust 
anything?

Which makes me wonder whether we should be moving that to 
section_deactivate().

-- 
Cheers,

David / dhildenb


