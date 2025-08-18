Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AABECA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12BE68E0024; Mon, 18 Aug 2025 04:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E428E001E; Mon, 18 Aug 2025 04:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70ED8E0024; Mon, 18 Aug 2025 04:33:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC2048E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:33:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4941F1DE1CC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:33:17 +0000 (UTC)
X-FDA: 83789213634.06.103CF87
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B2C5C0007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:33:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYYsnihb;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755505995; a=rsa-sha256;
	cv=none;
	b=ZaQ0FaWG2UZOyO0qy/hG/dMDs0cSOQIFlZDimqXH0tHKGQHKDQH1gaN+zNygKicf3zwv7V
	FtDFHUXqnGpBD2330uwgh42qmwDu5JwD0I5IlPLX3cUAJ5AUAOPWs3XIVsTYmVANwjfGEs
	scdzHP9q1QquEJ0vPtPk0KN/HhKc04Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IYYsnihb;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755505995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ieVfejLYp5z3U5Is6XG6mFRNxluEHCpmXjf1mF6lHw=;
	b=WMhFqln0dTrGrCLeszj72/1u1nlOtE/wLilWP1vfZFPf/ZcbCilgk4KIUlsWcr2Row+Sv3
	XA1oJj4m/S7ONENitYz5nmfaZf0cHh2RQw2/nYcTtLy3MoDzphxx9QjcR6DTPua40TKt4l
	BhQFtJ8W2m7/qCPKXW1+pG59tLR6wXk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755505994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+ieVfejLYp5z3U5Is6XG6mFRNxluEHCpmXjf1mF6lHw=;
	b=IYYsnihbC9qPaIE5uXEG6Yx+Y3tx2DRHstoH2ojgdkS1Hw7CEYkMRS6xrqtJoJQcWRf6gJ
	4jKXjI303xycm72RnGjjpkVXfHBRAx7cD/bqMvtOHp1qJbHloSHi4CLubEVPBcRInHmhN5
	4EPqQBsoEFGWmS7ABnOfyq48BGt9OFI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-333-W1KQ7Rm2N3igUeaEbY8fIQ-1; Mon, 18 Aug 2025 04:33:11 -0400
X-MC-Unique: W1KQ7Rm2N3igUeaEbY8fIQ-1
X-Mimecast-MFC-AGG-ID: W1KQ7Rm2N3igUeaEbY8fIQ_1755505990
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so1785281f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:33:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755505990; x=1756110790;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ieVfejLYp5z3U5Is6XG6mFRNxluEHCpmXjf1mF6lHw=;
        b=PBzg5P6j85fi+jaw5yphzok7Sl8/JoFsYdhKdyVc8JqizUCBuSy1P8WLdLJscQVgEe
         9LREkciMD/o3Wzm1N8mFKI0eWm6ovnKhInI5+07XEwkljEj7uGFLjvsohCyWvaqdOQ0Z
         vQczobWKOsxyuQRfJ8KjdvU/WaUK2XJwDHRM1yEF08YXuUy14lUOgH5niCvcQWXgIgRW
         2zjbYrCjihW9ACM5xQR37whUrKmBePytWMPrE/kKCz/BZPGgmTyh+CzrrMfVna8TxNlU
         D11A0YtQ2O8HOr9c1B1RAwMcCQDZSpOnyxB3kv6WGVwL4cMd8UYiWNqDvNJQUOlBYeyu
         p+zQ==
X-Forwarded-Encrypted: i=1; AJvYcCWBrxOBHzEWkJTdj1KOl7ZVarJcWJcvZurnOrBsUvZG6ICTyt26z9JklrVS9rGEbACF8zNT1GyH/g==@kvack.org
X-Gm-Message-State: AOJu0YyafjeShpyFdzVCdB72qA3FaFnX9VhsaEJrzEJmIvEYwLeZl47L
	7ZluuDbbCpZ/fqkX1mzmlN567g6RhJnnuGas2IlmLZ9FbJ2gDPqJMPqNfXO/QvE/zzsdXV5XpI3
	fG5oSpxO1UqW2iaQLZmj0MMFAGTFybq5hXfEUXFuQVKH5fkLk6x9MwS/N9mrL
X-Gm-Gg: ASbGncsGecApBqrVQQVIS1FrgbNVwCL/lHLXYMErKhr4/urNcw/21ZA+xIdq4HI4xFc
	uj4MT5051VILZutchSEiGeb/f7E2JpF+IlMKjwY1yZhGfCuyIE+KxTzOmlaPaMxkSI9RHrDDTLF
	d4K1ydelUlFlQGeavozAKdNJK8/jL6B6+Vi9ARSoZs8+cKrQ9eH7RcQjzhOUT6v42kbMb5YyCR5
	8YRwE6BmGK7RcjQzASMnSuuEyNYT8EQcpPQlZ2Afcpv6I2nLIHXRo6bvba0c0Rq9a3pG72elc+O
	e3uAsPqKhYBPvtVoqOKMsRrxczBpX7XttKOo/XPPllY1hvF2J7oVCVUC2uyuOIkLO/G69cVpNLw
	zddEc/0OB17vGK4p/7vOPWKIgLV7lw82I/mGAi2DnTx0ibqBzg0QWyxbVOFaCmJ44
X-Received: by 2002:a05:6000:2c11:b0:3b7:8fcd:d145 with SMTP id ffacd0b85a97d-3bc685cceddmr6728181f8f.5.1755505989874;
        Mon, 18 Aug 2025 01:33:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnT8cs4Rms+akYGBpJjatB4LatGCTIuMIO5Pi1mE/+LnBzXe+Ptq2nucAOqmCsTAOaOj1Cpw==
X-Received: by 2002:a05:6000:2c11:b0:3b7:8fcd:d145 with SMTP id ffacd0b85a97d-3bc685cceddmr6728147f8f.5.1755505989352;
        Mon, 18 Aug 2025 01:33:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb676c9426sm12398835f8f.33.2025.08.18.01.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 01:33:08 -0700 (PDT)
Message-ID: <c31e9dfd-019a-4d54-8237-8c3501c730a7@redhat.com>
Date: Mon, 18 Aug 2025 10:33:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/5] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
To: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
 wang lian <lianux.mm@gmail.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-4-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815023915.1394655-4-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m5xi21v-JJopx-vAlr3Ec_QaUPjCGjEahG97B8bBsUo_1755505990
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1B2C5C0007
X-Stat-Signature: zn5kyro9ynaybhsx3k4xuom1o1okbtdi
X-Rspam-User: 
X-HE-Tag: 1755505994-576937
X-HE-Meta: U2FsdGVkX1+erzLOZCNzU1G+LIQlAJgfbQvFokAppRu/B015wGcxZxyynAGGuO6qaMOzuhUiq4DjoVyWCBROhxrLxAtVk3z6m66VCnJ/vUez4cYN+rxemW27bS8UQo6fK166O6ttAfyb5bewaleZpFmuLBsR4bDdRx8/DZGhzXpfAzDmht/h+rVXWalbPzmlvhmZZ9h9KGtkwx0NMG6/F0oXk6aO49V8yUm5Rm91D/mIYCwfwPwFVbqf0ZQjOAGG1t7WyUCFFtl74El+gBaGvCBr8qrdTxAPBmncd80GAsHuKFD7GFqs2FllPuDHZyVANPI/tjzLVmit3L5TXsQViYo8R8mMzRjbYwBR4keE8uH2w+TMA1NBnMLedcTDJkhUlmxpzKRZBgTorRLCPhPHbl37tRX6v9fOjEIuPiWiGFNyG5fK1uoEd9eg7k1tUM+teJcZoYNdLqobWS3QpIj1LlEleZvqo7b3YimqCKBKhfZhPBoKjP0ROpoh/vDCqe6mli1CIHuL3JgAOPsO0iGTtKvnH3FEiktSO0fcjO6NKOoGbTDSZaiBW/kRJ//pMSLo2UCxQiZ5LOr6PqyBtNwB+J60q7OMsDnO9V1zpFD0ZrHtsxEIeqx5DelRp9lFv4pKJUF9XlLLiQI4bLUi6lQDz3EAvDh4yRsBTTv46B53aetxsCaLyHFEkavjdXE2oFwtc10/LjZcnJYyv8uH00LNngzrl5shjTXwgyVqh45V4JiLotIdztoQfCFx+M/6/ikdYwJ5D7yeAtDSrmk9uIUUF1lqATj4ffjirA9elD8t4iLpNPpiiwg4bxF/ySKCQdtpOvRRDrgXudUgzEkJ+T2tMr80+XyYZuzGXUJKbT/rD6eA1BRGHQ0OVRNfjX9ItASL//ysPS+akhr83FcyPUJhveV5NpvGfiVNxfGbYDJCqwYz4aPhi4MbL8VskGkxnkiO7lXSIs88q1Xr/j70HTq
 yDhEXGC3
 JXLK5C9fXo37XGBlug1/K4pr26nNGGY/ay96l6XAyevI01XbYv2okIle7NlAsr0bTSlwtr9ZcDDVbb31lN3dkzjQCkN185llWQ/x+1lCiKqjK7YMcJBN+5kgv2hXcmtXNdA9yzkGWjzNIZd7LRwpHsUGA39n+gBMdW7Dl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 04:39, Zi Yan wrote:
> and rename it to is_backed_by_folio().
> 
> is_backed_by_folio() checks if the given vaddr is backed a folio with
> a given order. It does so by:
> 1. getting the pfn of the vaddr;
> 2. checking kpageflags of the pfn;
> 
> if order is greater than 0:
> 3. checking kpageflags of the head pfn;
> 4. checking kpageflags of all tail pfns.
> 
> pmd_order is added to split_huge_page_test.c and replaces max_order.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   .../selftests/mm/split_huge_page_test.c       | 90 ++++++++++++++-----
>   tools/testing/selftests/mm/vm_util.c          | 13 +++
>   tools/testing/selftests/mm/vm_util.h          |  4 +
>   3 files changed, 84 insertions(+), 23 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 89d3dc08fe4c..80f718ca21c7 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -25,6 +25,7 @@
>   uint64_t pagesize;
>   unsigned int pageshift;
>   uint64_t pmd_pagesize;
> +unsigned int pmd_order;
>   
>   #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
>   #define SMAP_PATH "/proc/self/smaps"
> @@ -34,27 +35,71 @@ uint64_t pmd_pagesize;
>   #define PID_FMT_OFFSET "%d,0x%lx,0x%lx,%d,%d"
>   #define PATH_FMT "%s,0x%lx,0x%lx,%d"
>   
> -#define PFN_MASK     ((1UL<<55)-1)
> -#define KPF_THP      (1UL<<22)
>   #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
>   
> -static int is_backed_by_thp(char *vaddr, int pagemap_file, int kpageflags_file)
> +static int is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
> +		int kpageflags_fd)

Could we convert this into a bool and simply return "false" on error 
instead of "-"? These tristate returns for a "is_*" function are a bit 
unfortunate.

>   {
> -	uint64_t paddr;
> -	uint64_t page_flags;
> +	unsigned long pfn_head;
> +	uint64_t pfn_flags;
> +	unsigned long pfn;
> +	unsigned long i;
>   
> -	if (pagemap_file) {
> -		pread(pagemap_file, &paddr, sizeof(paddr),
> -			((long)vaddr >> pageshift) * sizeof(paddr));
> +	if (pagemap_fd == -1 || kpageflags_fd == -1)
> +		goto fail;

Should we rather expect that callers make sure these are valid? In 
particular, because split_pte_mapped_thp() seems to ksft_exit_fail_msg() 
already.

>   
> -		if (kpageflags_file) {
> -			pread(kpageflags_file, &page_flags, sizeof(page_flags),
> -				(paddr & PFN_MASK) * sizeof(page_flags));
> +	pfn = pagemap_get_pfn(pagemap_fd, vaddr);

Hm, if it's swapped out we would get intermittent errors, but that just 
seems hard to avoid. The caller could mock to avoid swapout.

Memory migration is another possible problem ...

But this is nothing new regarding your patch, so no need to worry for now.

[...]

>   
> +int get_pfn_flags(unsigned long pfn, int kpageflags_fd, uint64_t *flags)
> +{
> +	size_t count;
> +
> +	count = pread(kpageflags_fd, flags, sizeof(*flags),
> +		      pfn * sizeof(*flags));
> +
> +	if (count != sizeof(*flags))
> +		return -1;
> +
> +	return 0;
> +}

I would have called this function "pageflags_get()" to resemble 
"pagemap_get"

-- 
Cheers

David / dhildenb


