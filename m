Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1FFCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 12:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFBD8E002D; Tue, 21 Oct 2025 08:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7CB8E0002; Tue, 21 Oct 2025 08:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5EB8E002D; Tue, 21 Oct 2025 08:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B3A18E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:08:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA23E13AF85
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:08:54 +0000 (UTC)
X-FDA: 84022000188.04.BE9500A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4727E1C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:08:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AypoJTu4;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761048532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBk/hMZm1AU2HUgl06IU47txGUglYm8peBHpiuPlFXY=;
	b=u7Sl6NHSgsKYKxiT65ReaSlvi9zCwhsav51FuvSzdqudCyGuMnN58wueajNDK0tG1Ru+1z
	Nwunb7eA+D0jXM/pu8LXlSGb5LTB/1J+pvYWd9Hu/NZUr4+h0laJUKd5yGYa+H/W0p0jMy
	xFOVSphcl+NuNfeXj1OmRno+YCUCth4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AypoJTu4;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761048532; a=rsa-sha256;
	cv=none;
	b=HOQqmsbBhhj8zh+tpCEnK7mulkznQ1vf4iyzecD3dNlWIOuJ0x7IuTsA81hZ7TlFSWgyeY
	CA29ynv/SUKX2yotiqFkB9FcQFTPK5FadJAYLjHE1/own0GFAE+5saBnRWRJNbcUon/Wrn
	xPP7PghiFc4PrbnNc752IdMypQcc2ZM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761048531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=jBk/hMZm1AU2HUgl06IU47txGUglYm8peBHpiuPlFXY=;
	b=AypoJTu43LiblfOyRSnnCwFGkdGiLP2EATCZgQYIibOdxZGLMo9hxfbuyI+JU79UskoJtw
	x8RtAV7zSiJ935OdLwvg1TFPT30uSARgr5qEKiTbPjHMCaVADuHS2Icz+ybr7OMDcBBbiG
	lDBobQcCvZvu4+FbZ7JM63K5RNMp8lA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-4qO5sT-mP3qvorQq1bAM4g-1; Tue, 21 Oct 2025 08:08:48 -0400
X-MC-Unique: 4qO5sT-mP3qvorQq1bAM4g-1
X-Mimecast-MFC-AGG-ID: 4qO5sT-mP3qvorQq1bAM4g_1761048527
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso2403579f8f.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:08:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761048527; x=1761653327;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jBk/hMZm1AU2HUgl06IU47txGUglYm8peBHpiuPlFXY=;
        b=vLLLaiPIcMdGbalyyGgqiab0J2TR0d/K0Nrb/h6/JRPu/71q7z5+LU71YuEYxDWsaj
         24Izx0X3peBYwg+aGhsBoK87UsgQUre/nTIJtb/EGopHSntchkmQgQ/03yAj0slkpmcu
         hoyp3ERmksoYW2Tntxc1guFtvmMTeWhyvo1cCqoecaOIpITFhWNgteG8RgqJUjOHr9b6
         Jxxl/IqwfmrKxO60PKxXxJq9+nYxTH+ayUM04QLaJUHv5cuLkncwgJe3M8LBUkc8li9D
         XIwmegPiRQBovOW/dfviptnyP/YrywxgYj4s7xJBIrlnD9c7NLh+m11N0hAtOBMHtQJO
         M4dA==
X-Forwarded-Encrypted: i=1; AJvYcCXz+GyX0ETYqLJ7awJpQmY3PLKGRkiYSdP1zX8POI+MzZB/1yrXGH0uHOEgeQGMeO8bSescXubhbg==@kvack.org
X-Gm-Message-State: AOJu0Yy81jneMNRZrqCl9nmI8tmkRcCD/T6Au9tl4ll7dRb3SgulPLUG
	7Zlf56axX93k7g24xQ3B7gvNypCMns/Um9nfLoclya8n6INR9A6KtzD6n+ZxCZ5iNtIsYju/lZc
	IoeM2guAcP/n9nDBalhkb4/1RdTot1sKTRYu5RboYD9oZYczrFlES
X-Gm-Gg: ASbGncuoWr+ajlRJNnIsalP/6omwFFjBvJ4sk5wsPrurjDB2PZbfFS58/kGHiGy0iQ4
	pEh+LvZcW/HSkWRY98qSyDZrpj+m1No+t1lUnruwCN2O05Tt5Zw0voqwlpDIg1NjKkvEaI7dyQV
	QYotDDq8z1yvqMeVgTFTPvHzaRuy6pmt/wLYhbSmUL6zuCFqlvDsDgxjzFRstmE/f/Qk9l5eYW9
	0AS/D7ZqNKLUQWOcU8g1WouVqxIKWBxUPbpdHYs/8Zeb1XQylD1OASF+Xgeck7B2DXxvXhSjkuM
	LyNF4rAOnuBEXYKBWVQ/oxOA/7ROn7ohFgYvNwnyOpWFto4rgA//OdAYZ8SvW2W0W6RMoyV9uki
	aGeXmflrkHPbXVr268gJcss7uxFWvmJqXwRrpJtltiscrobcAEcKKkQicBiW9aJ5mJ3ZThGRrVS
	itS/D6N6FpQ7Xs3ZZ1Xj5N+eGf+fo=
X-Received: by 2002:a05:6000:612:b0:425:6866:ede8 with SMTP id ffacd0b85a97d-42704d49a78mr9955319f8f.8.1761048527232;
        Tue, 21 Oct 2025 05:08:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZ5mwIbXc0FupYjOjOI7qYovL003CpULMJ3bbgFzgJ3ZkyizTtVqUvrxQ5Ewt99StNhrhgpg==
X-Received: by 2002:a05:6000:612:b0:425:6866:ede8 with SMTP id ffacd0b85a97d-42704d49a78mr9955285f8f.8.1761048526794;
        Tue, 21 Oct 2025 05:08:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5a1056sm19970736f8f.2.2025.10.21.05.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 05:08:46 -0700 (PDT)
Message-ID: <8379d8cb-aec5-44f7-a5f0-2356b8aaaf00@redhat.com>
Date: Tue, 21 Oct 2025 14:08:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/memory: Do not populate page table entries beyond
 i_size.
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20251021063509.1101728-1-kirill@shutemov.name>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021063509.1101728-1-kirill@shutemov.name>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IycCj98vFp3bjUXlqv8eo8Tig_P72qumuel_ueSH30E_1761048527
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4727E1C0006
X-Stat-Signature: ijxfxr1j1mq3a4ozsy7gir3n8yb6tr3d
X-Rspam-User: 
X-HE-Tag: 1761048532-275431
X-HE-Meta: U2FsdGVkX1+f6oDzDu+Zdi1tHNclt/xRx3KBhhhJNP3DIy24/CvsD4Jg7VofFdsq5Ll/j4JxFJuEW8Kk7rfbUH0LNg+mV9skpdrKGBjp5+Z0rP8JAQReKCI7jEsJ8IoBQoH+zz9rsAjO/t6vAWEMkULh/v3tiiFnQcMMokuX2KnjDFwTqwbVBXYo8yxiytffUcHflBe8byVfLedlGyoyErbxZJ5iaW7z8Wpo3iiiFtqcUZ1frIGt8SmFBdEcZsVcHWJ24qSrdoTGT/IahdDuApFXJUrBCDUH3Q7JX9nTjN7bGkbjT9h9rC0bWlpLsvGT17slmwiki2t/whVAdqg1L2z6vxD3inv4eG7CUIRNc5hC7EU+AMXbYWpgoX68Alm7Exy/F0MND+U6L9iWd6gn8S3eRXAgWgSeNf5h/aNlJJNVZjckx/eg6QwX/dj/fTpujNG0TbGPOxnIwj2RxRxkvoNMJWUIchWhGHenBUwRyK2THHW8qjT5b+1wRVmYAo/JIxiuxW0E6CdK+vQH+4TRUN92HGjEqEleN5y0S1TjxI7diwSUPTp06kbh5LeQVbPx17TH+R9PHilzu7xB9YzihS15HazhngTcT8HitfH9v6Tuuc+bOBf3w02OG+GQSDv8fHUgNBPHQ05cEdtF9Ngp8hr2ym+fuTs/k5KKhs6zIm2/i7DULGsAdQIQZuk2UfP9VzpuWJWepV+3h7nEbPvfuOH1lSmcctvfwebpJkfjYly1SAQxY2GyjTIMRrXbqpnehWowji3L1eDUfTqx0BOw8PEnFwP4LKqYxotYhBTVlb+xY6gY8pQ5GzFoWxa/+x4FUdQcMCPoRc4OAynKxogbBWGeOtWds0LRifs+VOXT0pGSySep+VbZqxPYCNeuKo57jCDy1aR0DrkC6A6xuXWQ41bTyeJjmCh0993R0pxxmiD8L6yGrwrydCL0cC+WEXV19fY30zZiTYvq/4ca5aC
 ZgXuh/s9
 X+oPjWj9toYJc6Sz+QOAdjOxG+ymJXC5VkayVzyA0lz3bBMVW5nlRSN7Mx+7OA+oZjAaTmruDuG6ydbnMtiwET4jA1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 08:35, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>

Subject: I'd drop the trailing "."

> 
> Accesses within VMA, but beyond i_size rounded up to PAGE_SIZE are
> supposed to generate SIGBUS.
> 
> Recent changes attempted to fault in full folio where possible. They did
> not respect i_size, which led to populating PTEs beyond i_size and
> breaking SIGBUS semantics.
> 
> Darrick reported generic/749 breakage because of this.
> 
> However, the problem existed before the recent changes. With huge=always
> tmpfs, any write to a file leads to PMD-size allocation. Following the
> fault-in of the folio will install PMD mapping regardless of i_size.

Right, there are some legacy oddities with shmem in that area (e.g., 
"within_size" vs. "always" THP allocation control).

Let me CC Hugh: the behavior for shmem seems to date back to 2016.

> 
> Fix filemap_map_pages() and finish_fault() to not install:
>    - PTEs beyond i_size;
>    - PMD mappings across i_size;

Makes sense to me.


[...]

> +++ b/mm/memory.c
> @@ -5480,6 +5480,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   	int type, nr_pages;
>   	unsigned long addr;
>   	bool needs_fallback = false;
> +	pgoff_t file_end = -1UL;
>   
>   fallback:
>   	addr = vmf->address;
> @@ -5501,8 +5502,14 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   			return ret;
>   	}
>   
> +	if (vma->vm_file) {
> +		struct inode *inode = vma->vm_file->f_mapping->host;

empty line pleae

> +		file_end = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
> +	}
> +
>   	if (pmd_none(*vmf->pmd)) {
> -		if (folio_test_pmd_mappable(folio)) {
> +		if (folio_test_pmd_mappable(folio) &&
> +		    file_end >= folio_next_index(folio)) {
>   			ret = do_set_pmd(vmf, folio, page);
>   			if (ret != VM_FAULT_FALLBACK)
>   				return ret;
> @@ -5533,7 +5540,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   		if (unlikely(vma_off < idx ||
>   			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
>   			    pte_off < idx ||
> -			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
> +			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE ||

While at it you could fix the double space before the ">".

> +			    file_end < folio_next_index(folio))) {
>   			nr_pages = 1;
>   		} else {
>   			/* Now we can set mappings for the whole large folio. */

Nothing else jumped at me.

-- 
Cheers

David / dhildenb


