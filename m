Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8BBC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116246B00AB; Mon,  4 Aug 2025 11:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE8B6B00AE; Mon,  4 Aug 2025 11:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F006B00B1; Mon,  4 Aug 2025 11:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E10186B00AB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:24:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F8BA1406CF
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:24:46 +0000 (UTC)
X-FDA: 83739447372.03.51268BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA2EBC0003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:24:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FP/u5J8P";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754321084; a=rsa-sha256;
	cv=none;
	b=Ul2Lmq6hoVU9yL2q7gCQ0R4AI5cy3A1IcBNeGxvyIF4svB8T1zhUvp1wyBQcqUa93ok/IB
	QdU1cZYe1CZ7jOeTadOvv8rp+n4arpqD3i4eQ0e6JHVgB1T2iNuCfm3C9DceiBUE5A31+Q
	jsN87/4keefFTU29BgkmZxfDQqXxES8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="FP/u5J8P";
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754321084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kW4XtQ/FhoaGY9EkuOe6y+0BG9ZRHFWRVCua+Iw0inQ=;
	b=km62T1krbUPhKA87WU4fGrj8mQZGtIzUWUtNQ+uVdGZWAJIps3mE/leytVZfY3NpUJsM1Z
	cjsHbgkFcIRPy5SkNjKSTpE9hooPEIJz29H3+peBJzJIPfpcsbYkUwnG1K2d3IQpKxLEbu
	JBDZ0+5/HMu1hUY+yce+qIkbKz2oZ3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754321083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kW4XtQ/FhoaGY9EkuOe6y+0BG9ZRHFWRVCua+Iw0inQ=;
	b=FP/u5J8PRZailhzxGwg+rQBGLt9FfmwmkZVFTEU8uQoC9mykiUE1ckeTaj/WPUzd6nrnyl
	ZEkuw+VW3LgFkQzoB20QVoILmi7hUB/0AUO91ZC5OeB3BgfLf3n6AuUzhHlI54LBpDu7oi
	mRokrXBH4yct/OINk4w4wyzwHU2cT5k=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-t5qeH_quPRangocHamHiHw-1; Mon, 04 Aug 2025 11:24:40 -0400
X-MC-Unique: t5qeH_quPRangocHamHiHw-1
X-Mimecast-MFC-AGG-ID: t5qeH_quPRangocHamHiHw_1754321079
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b836f17b50so1962690f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754321079; x=1754925879;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kW4XtQ/FhoaGY9EkuOe6y+0BG9ZRHFWRVCua+Iw0inQ=;
        b=eQebhanabA0C2a0Nmsg6ZomiNowtTzs2GD72xHOrqECTP3x1N4EK3gHCNRJudBunBQ
         mBqV6TypWShs/8vSqFXbJeVhFas4P6K4MJEPLNMXosj6qVFN0GK36NrogKQbaofLMKVq
         IAWIYFz4F4Y1Q7DfkYnySaYCyuC7nlZfSxqwBL8u5e3cYVsnsSdjXIMzYUhGH3M8FPgZ
         2ukEIf47mlHagbRUKUBu5ZPxAy7gecMdAEZsCQJ9t706mTwas8WJe7bA+QfN2RI74++O
         o6XV8pfjGixQZO5udAmoB2g4EPJw5r86RLU84A9v2OGE8p7cqfilmP2ZJrpkw7UJVbhu
         JNhw==
X-Forwarded-Encrypted: i=1; AJvYcCU0RZh9rNlSnboU3YTFOqNUneNH3HIFW9/ZXthLSdMrKdKY5ViD/L1WUYmGodPT2EDuFcJ1T6vNSA==@kvack.org
X-Gm-Message-State: AOJu0Yysvv94z05lcVMwfEs69zgpsv88NPNU9G+YoWgGBSdQmCkwggU+
	a29T47rDwJGPIKeJrYWvySb7SfYw1X3rlEc2uST6xJzpMHeK+W54m1+DxplGJHscU0yXHjx8M+g
	hHLGi7OwUjsu/Z7afrf6Di59T24x3bycRWzUoXwXJCxfNWWAK90Tk
X-Gm-Gg: ASbGncun0gPQFCJ69lp75f7zfFQUQJDgTl2Z5D1TU9+iqNLRvJTTIHllTSfM/uaKym/
	NYduPJJcM+EoncWjd9ZBPGfGu4RyxLJVyi7sg8Qalcxle6WWRuiulCW9lqXTI//BYANkLmeixFj
	afCsURrkrYO+wiIuDxjUVhsMvlsXENM83jTonacylr4kihGaZqx5KtGJ9TBipVlq53Jleg2kr1A
	+7QUmk57KqjN0BfP4J0X4zj2vaC7+5ttIS4zjcHuaaHXbdXo+iB+JQn17VNAXk/sZpF0bweotKj
	Etc8p4VGYOa5YL4H9jogqsIy59/qSRyeP4+TqoTaWOI2WbKRZxhLtSgN0ryPgl2u4PiV0du1B2v
	fxKnG+M0CS9iALbTL0fvnK70Cjop01q90ax/qH9YJ4B4AfV4nUVMrp8tMqsl1hBR+E/I=
X-Received: by 2002:a05:6000:40e1:b0:3b7:8c5c:539a with SMTP id ffacd0b85a97d-3b8d94b997fmr7049628f8f.38.1754321078684;
        Mon, 04 Aug 2025 08:24:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH8UktDNXc+sUhDaDsDt8iUUUu8OhJBBMLKFLygBGUdsEfwIEPiwPZU87tf9aZQY65OJesAhA==
X-Received: by 2002:a05:6000:40e1:b0:3b7:8c5c:539a with SMTP id ffacd0b85a97d-3b8d94b997fmr7049607f8f.38.1754321078224;
        Mon, 04 Aug 2025 08:24:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9? (p200300d82f0e2c00d6bb8859fbbcb8a9.dip0.t-ipconnect.de. [2003:d8:2f0e:2c00:d6bb:8859:fbbc:b8a9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c3b9386sm15914012f8f.18.2025.08.04.08.24.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Aug 2025 08:24:37 -0700 (PDT)
Message-ID: <34d34fac-9a8b-4496-a6db-725c40d0408b@redhat.com>
Date: Mon, 4 Aug 2025 17:24:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: fix accounting of memmap pages for early sections
To: Sumanth Korikkar <sumanthk@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 linux-s390 <linux-s390@vger.kernel.org>
References: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wgoW3YlVqysdxCqLxhy2p86yqX0CbJJRp_lIn4bmgD8_1754321079
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA2EBC0003
X-Stat-Signature: 6yon1ybjrxejreaa57w5xtwaortyrfhh
X-HE-Tag: 1754321083-701695
X-HE-Meta: U2FsdGVkX18jMqTNmuunCLPXsyjYOk5J4QXNF//A3ffnMBHi/faDgRw0qLryZBAktfKq8F362vPhNXTqeYEx84ICoQK2R+mBrTzXHOiIfoTA6MsiBCZsFUS57yFcP1NnJ8akfo6tTnvE11OMJSyfe49sHAEUkesPEEM7KrtwDLyoJDRKoC56TQ0MAk5kjal30LIr0nxjauHtbYNW0nnoAmTEY57iz80yHiEzIx0uWSgIHPvt8TsuhjWnqbJvQxhZxQKAIfEHpHK9VtWcANjdiisKTKQT3fp8+itefb9sDl1KMvKablQUhiRFmlj8aAk2YZX1jH60m7q0gMnwT2O9WAu8CA9YF5ynnkd7EaavhHeBi9xfSF++W/7/qn4LP8ox6fXBvP9oK+6GggjVqjxDOocyohyG4quCZLvuylV2/neNTqiMEHmlayDEZGtegOxNVdlak7dCqqnqfb936viBGxQSiuLGDzF8CDb8V3U3olQ4YLuyihDi3V9+Ml1CSlaSdMI3kACOjWR/7EnDdA6AGstjpPk0BCOdf7cE/EG4b8QrttiM9MCjytxv6JDxSVO5bl1TGAHKZTFPtdiJsEjj86UVf6tLDnJO4c48WcR4Pjc3rEI5bHZ6SKmtUwAdHT4Yqb7Y2CXxn+MnQVp279ZL7aifOKiUaQS7IuHQAUXAOlZO+7g2u+rJYdz6VYfIs5c9Ol1CIyXLb1Aq6kt9DmvOJhX4PQAeQTTxQZRTfcPpBA4m+TGRyBIV6rf3MGgJjIe73C3PPrPZR69/3e0h6bCrOAFBYVKFhil0uNf7q0Q/DlWvw+H0Sb2TqR7ggbHwpGdJiqCSdG0V4Q3z0Q2Gz1TPGmsDbGxlBhMQ1DrOgoJeMWP03gIPuQ8kiqXbFIcso8X4dJMOg4gR+zPj6Q1qK8ncwsLxrgqLMwik68DsCK5TlaeWLAO757xypy8tMxcyddhCdyy9vfaOX/dtxv6H1Xn
 /8KHG2IC
 VCWPY2p06Tdg15SxjbQUPKBDf45tNiMNxn9ysm4w95lze48GA47IOkBF90k2/hRieXvGNFqDd0Vuo2cjnheh2ncaXsqNVazJj845RqdvmiI6/pa5B8EsedUQCdrsiinyXsr1evux8AdN5c3lfO2Vl6rfmKh6oNk1ELgNhxGSpd66muryjsvACW7ii73HG5HhEejI/Pr6ljuxCC1LgW27Z99x8+D9OQAaggIX+B9yRAz3kC7ve2XO0Wni9HFRNKH0uzyUX2pSwUkl8FZT69FsK8bkGupb27rX/q+JarOSdPOGu1/H5V9OmutMcJoOmjC/Ih1PSo5P4wwSmVfGdkdJ6XMApduYJ40/nxawIl41ao6ZtuCR+RsGzLN/KDl7Rfd+ZJFHnwbzlxt6wJ1P+W/CDD8MSgFgs1Kix2jikr3tztfSYooB+a5JhVDvzzlXdDWGA2+DbQfZClvstH012iWubpJfE8Nb9UuoPJFvy4mVms+AKGbfAQScD+zZep5tF7eoAD9W7BKw/SxhF18saMFiByPcOfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 17:13, Sumanth Korikkar wrote:
> memmap pages can be allocated either from the memblock (boot) allocator
> during early boot or from the buddy allocator.
> 
> When these memmap pages are removed via arch_remove_memory(), the
> deallocation path depends on their source:
> 
> * For pages from the buddy allocator, depopulate_section_memmap() is
>    called, which should decrement the count of nr_memmap_pages.
> 
> * For pages from the boot allocator, free_map_bootmem() is called, which
>    should decrement the count of the nr_memmap_boot_pages.
> 
> Ensure correct tracking of memmap pages for both early sections and non
> early sections by adjusting the accounting in section_deactivate().
> 
> Cc: stable@vger.kernel.org
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
> ---
> v2: consider accounting for !CONFIG_SPARSEMEM_VMEMMAP.
> 
>   mm/sparse.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 3c012cf83cc2..b9cc9e548f80 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -680,7 +680,6 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
>   	unsigned long start = (unsigned long) pfn_to_page(pfn);
>   	unsigned long end = start + nr_pages * sizeof(struct page);
>   
> -	memmap_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
>   	vmemmap_free(start, end, altmap);
>   }
>   static void free_map_bootmem(struct page *memmap)
> @@ -856,10 +855,14 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
>   	 * The memmap of early sections is always fully populated. See
>   	 * section_activate() and pfn_valid() .
>   	 */
> -	if (!section_is_early)
> +	if (!section_is_early) {
> +		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
>   		depopulate_section_memmap(pfn, nr_pages, altmap);
> -	else if (memmap)
> +	} else if (memmap) {
> +		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
> +				      PAGE_SIZE)));
>   		free_map_bootmem(memmap);
> +	}
>   
>   	if (empty)
>   		ms->section_mem_map = (unsigned long)NULL;

Acked-by: David Hildenbrand <david@redhat.com>

Hopefully we're not missing anything important.

-- 
Cheers,

David / dhildenb


