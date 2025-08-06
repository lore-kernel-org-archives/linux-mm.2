Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64745C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A19B6B00A3; Wed,  6 Aug 2025 08:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0526D6B00A4; Wed,  6 Aug 2025 08:47:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83DD6B00A5; Wed,  6 Aug 2025 08:47:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9DB06B00A3
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:47:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8CA9C115877
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:47:21 +0000 (UTC)
X-FDA: 83746308282.11.88F6B4A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 206CC160012
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:47:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOljfUj2;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du+uAPV+viA6SIQNfFwbJjlhxucMQkz0DAyZJ6nNc3I=;
	b=Rx0n9eZQEUmZzxQURsF1WbBp+t7G5CFfo2rXmlASpD32J91LVtUfu6bqCgBfUcBPIGkNmO
	LFcZNuO8N6ImVnIC41LMxLtaQ8WuPoPZBs8PvasfG/a37w9sDhTgrYQYV9hgWizGx2PJqg
	fwrdIglNy8ibpVVdydSIx3157A34N0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484438; a=rsa-sha256;
	cv=none;
	b=AgIiF6CJ2b8TPshEK6ap3y+qXXfahwmBFtGhlS5J+UHd+uBfwGaVDstiH0xdy7TWANDFj+
	dHJu6kXBqOWDGgi9wFTckIS4BzvXgTsQ7pTvgXL/Iy3SKtfGiCacZRAvi0xp+1lY9actCX
	gYpPdJyl3HYAjJAvUpn/iJzOQr6UCwk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JOljfUj2;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754484437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=du+uAPV+viA6SIQNfFwbJjlhxucMQkz0DAyZJ6nNc3I=;
	b=JOljfUj2i/CP0+qgYo2jD6z3fo3bQYZ3EgrCXjZhlvY6sQqSab3j8MmEgiO/HQe8n3d/v9
	3Ff5rf/ZFPKgMCsHiOea9hDyML0YZrlrEGaWi4MrxW9ZIft4LJrdn892xnzDQUjjVG8rLL
	9XhEBYu+jU9DZgLU4+gFZgrTkk2z0ek=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-UeaKe4NDNSm84AlU8gRtsg-1; Wed, 06 Aug 2025 08:47:16 -0400
X-MC-Unique: UeaKe4NDNSm84AlU8gRtsg-1
X-Mimecast-MFC-AGG-ID: UeaKe4NDNSm84AlU8gRtsg_1754484435
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-458c0c8d169so20164795e9.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 05:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754484435; x=1755089235;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=du+uAPV+viA6SIQNfFwbJjlhxucMQkz0DAyZJ6nNc3I=;
        b=aUssVlonC2igRTKxNsv/Y1acgUQ1/a16YL76FBBU5gUMPwjAHFl8CyMi9W0Ly+6Pcw
         vIH+sFQPziMkQKBfy3tRkgnjzjJ9KJ9sZkX3kgAqwSSXxFngj/8wXldpyTeBjsRX1sgM
         zZR0sjiNTYJ7Sd1H28eSMOF9YCmkJ/A+yVtLphi+GdpVidbHV+tdumfTRxgHjxOUHWUH
         FNLX0ATQBhZ3cJoZoGmZnQK3lLdijJ5Tetu8Nyev/nknSwvKltDsdH6Sq2+r5K6fsDHI
         Bl8fz8oV+qr3dmRp8SHzqbooVWXQwYU1ZS5fMh6YFgC1a2hpNZ2Tr0G99lIhyu9J5tFC
         3Lig==
X-Forwarded-Encrypted: i=1; AJvYcCWI0SnERzExqKfQmSWU2aFuFaBHKaWqnJtKkQghNv7lQBk9LMOLJevoJ7yOnf9hyJKCCQfuQuL9Yw==@kvack.org
X-Gm-Message-State: AOJu0Yw2O7dd5dt/l7zYz+lWFJG8mziR20aOR/iFJrkOimugaRJ3KOMM
	KBtv0rN5jRMj3ONFi2W1nv1n3DlFByRwzPZ360dlA6lNvF4f0dYLCGuz4KTVY10feGy/iWXrS1w
	6voFTCqHQ4yU5C3loJ3ohs/Mj8hxylHQ2722tMT+w8sz5IR2mFN3/
X-Gm-Gg: ASbGncvFo9IBKpZmetvHSg5t0CHTdzkE8MwhJq1ItlAlNp4INiMc3WC7bge5m7ZNmsu
	XSv9b5d3lw2BuJcpbvtqCUV8UHwTXBoEYYyGr3op+jimIz7CuGbftl4hK7hu8+wmY6aWDoIcZay
	LsQXD5XzaEuoAr+PQpTBOV0rzkYcOdKlhG1VEWpwwPgUCBgDPVjpjV1CU6q5K+5KH05boFw4PFD
	Rh2mQQgnKjYN91UdXJUMAjg9rmbeqnPJ0xZHdr4oN9o+7RyqgKhdoM4HhHwK5O9Wucde3IHApuN
	/1Ete/oGQ4GXgt+I6uUcWZrmVVtusJyOimFA1iQSTPT4xdzGYRCy3Pzs7mKBObTF68S/V057vb1
	L/AA6wbny/0XJQNQJs1MuNM2I/P44IOJqtlfYxmapDpbWQJZxxawCuS2+RoaU32bXwgs=
X-Received: by 2002:a05:600c:1550:b0:458:bc58:850c with SMTP id 5b1f17b1804b1-459e7447856mr18428665e9.1.1754484435064;
        Wed, 06 Aug 2025 05:47:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWLZ8ZHFSzUGM3QUGYEAYSt+YHr4y08dG1ATS1v5CDniPdYt8JEUnU0hkuZRyg5nvDeoR8KA==
X-Received: by 2002:a05:600c:1550:b0:458:bc58:850c with SMTP id 5b1f17b1804b1-459e7447856mr18428415e9.1.1754484434644;
        Wed, 06 Aug 2025 05:47:14 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533f1sm23238259f8f.42.2025.08.06.05.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 05:47:14 -0700 (PDT)
Message-ID: <60b6c458-e3d0-4123-9815-44e8e8ae0e60@redhat.com>
Date: Wed, 6 Aug 2025 14:47:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm/huge_memory: move to next folio after
 folio_split() succeeds.
To: Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250806022045.342824-1-ziy@nvidia.com>
 <20250806022045.342824-3-ziy@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250806022045.342824-3-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: D00ELZwW88McwzMiDrn6YZBtJM9sonh7t_nJoBkgZR0_1754484435
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 206CC160012
X-Stat-Signature: ij9rewxqeuyq8kedayc8srosdgdczyek
X-Rspam-User: 
X-HE-Tag: 1754484437-122202
X-HE-Meta: U2FsdGVkX19rzIlcL5HeRxnVEVzJlHwwgGYgxNH6shbFrwtJDvUbqdkBMOHnBBkrYcepBleh0jk99Om4Bj8eoIFMacLaphaE4kqAtzuPQPpEDkDOuwdXhZxw4jXPx4aVhCafD0OebwktouOyHbNudDpqS1qrnWfaI5p52WxjLGGqsjXcbxYmvpVwre2TrzBly3QMD/DBbC8He+v1WAMa0dEqXM9xaR+gTFy4N8BZvxO/hXZAWB3+5Hx8y0HQxb7YC7HG7fKB7usPCe+z2n6tdM0c3HTmLP4X4ZcX5wYrsC+q/Ajrhlc7D8WVeTqE2Y5h93fCwJmcHF6NrRXtICDsr/V1GiOpuIUtq7E65FohvBQ+lQhF04N0CnSD1ohIycNNRZzo/MjVFRGCMinhsVLLrL2nTG391SbKscGkqtSEqkScEJehyyy6GjKOCKAGjF1JXjfpyZUkycWmvzXDT9v9xEEoDUfzTtVD0b+maP5oP7O2fEjScm1LZC90WSQt6HMBzlaQal9HdrQALsPR8STv8fwFBlyTm5Kn1KU5pWuK5PDE4Cw+W0bRTb7EqQbd5GSy152zlyWFNXBUZLjI8zhwYE2sefrYwNFdKPG1Ar0zlUplIQdJuS12RAziF4y0pbpPk3HrjqtfD2DZJpkDgUs2i7hOuRFqdIZwnETFNzTCNrgJa+lJ8UtlJeveq+CKBgHcFKdF/WWnDGEjzzGt4iEnTo+0rEKlAkVTJqkptqplLVdBFjqSTn5EyOf88vICmieHwBj6h0uj1vLPFotUOg2lZUJk+Nm5NkEpDTOYy5GoNgL9wxNXkdtU6GNSA3QEhHB9nYYnhCu0hPvS1FK2zQe+ONPoIZroqAYnguKdY2x7t1cQyHN/mBrx2X3/KlEAK4EQNl2P5OwnNrDZ+NEbAC28zTafDSVSf18XK3LR4/5C89KL0HcK/D5ZrVujAsj71lsbiC9uLh5qMmMijhJRMMi
 4DS5vjXY
 Bav3/3zQoL01Phn6OdluY0OLGViaJDecW8WgbxUkaZRbjd+Mpp3vPLB/QL3oImVwi8kVKJqdmUF9MTpEbOYSi1J6d+rnr4wdEs4jGL7RBRP2CSfCJsS4EFZJ4MZtHyg8tfscmissC0Dlu7fi6QH6dVDylUhWty2yT2KZlt3zLzEvginbBFUylObNoxExCGK2zGcBQyrK7Ze85/C12M5CWCL8LtADtOev7AsvwbS2bwBxcyU06Gwj5FbhiJJk014dxvEHG0BDur1YwIdtKr9+lKN6xdci6RzYinlYqqK3K1jliFRznUB1Jbg711B5oS+BEjcattUbtdoKyzeLYw3rElx5vcL412Q9lkSEgD+Nygo7ty1he01CvrB1TtZmscVaYt8U0tKvMf1KOi3HbMDI1wSMyr3ICuVrQ/t+c5IH7szxQEUGPcTpXSIY8etyfzNuUJvB2130RJv9990i8FwEsuYs/btQqXU99Jmq4yf1URlkSuZzaRrJVHimX+33AIOUbcgo4bpVr5uRJ+NcyQD8tBJ1+AUlX5TXyCKEW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 04:20, Zi Yan wrote:
> Current behavior is to move to next PAGE_SIZE and split, but that makes it
> hard to check after-split folio orders. This is a preparation patch to
> allow more precise split_huge_page_test check in an upcoming commit.
> 
> split_folio_to_order() part is not changed, since split_pte_mapped_thp test
> relies on its current behavior.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

[...]

>   
> +		nr_pages = folio_nr_pages(folio);
> +
>   		if (!folio_test_anon(folio)) {
>   			mapping = folio->mapping;
>   			target_order = max(new_order,
> @@ -4385,15 +4388,16 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
>   		if (!folio_test_anon(folio) && folio->mapping != mapping)
>   			goto unlock;
>   
> -		if (in_folio_offset < 0 ||
> -		    in_folio_offset >= folio_nr_pages(folio)) {
> +		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
>   			if (!split_folio_to_order(folio, target_order))
>   				split++;
>   		} else {
> -			struct page *split_at = folio_page(folio,
> -							   in_folio_offset);
> -			if (!folio_split(folio, target_order, split_at, NULL))
> +			struct page *split_at =
> +				folio_page(folio, in_folio_offset);

Can we add an empty line here, and just have this in a single line, 
please (feel free to exceed 80chars if it makes the code look less ugly).

> +			if (!folio_split(folio, target_order, split_at, NULL)) {
>   				split++;
> +				addr += PAGE_SIZE * nr_pages;

Hm, but won't we do another "addr += PAGE_SIZE" in the for loop?


-- 
Cheers,

David / dhildenb


