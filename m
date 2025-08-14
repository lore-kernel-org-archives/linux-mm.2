Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320D2CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40CB9000FB; Thu, 14 Aug 2025 02:54:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18A6900088; Thu, 14 Aug 2025 02:54:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07B99000FB; Thu, 14 Aug 2025 02:54:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDBB900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:54:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 507831603FB
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:54:52 +0000 (UTC)
X-FDA: 83774450424.28.4818912
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id D4E884000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:54:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GyLLNvce;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fvpvxhWPdoJkSDZ8MlphGYTdGzSm3/ja2JHmLogOOeo=;
	b=LwbhJtcmoR5mKE+sTTBtZTOnPkCF7X1iV0CapJPggRLq5cC9OwsLDUUCU0MqFrl8ZhTsg2
	PzGcZKjr/+pwk5+YJSRWQIpt5hvJbu8bgbLdq6h+erCdbTmi5N6a52YGt27aJxipcEIoul
	wjBmbL3Ug2rtRsu8VYArsYtaXaCo0So=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GyLLNvce;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154490; a=rsa-sha256;
	cv=none;
	b=b0PvmhMvqHVEU2xrqkpnPXvX8r2YDzBTdw7SjWeJa0C1BM+0w5ibXOJHWYqT7dyFPLsQp7
	Mu5w0hGl3MlgehhMBJaRggjaiGHFwPlX+bhwL90HXPW9q3C+QHNlrNe+SRojSjlrTr0WNy
	e46GLj2BL369s5GxMkvpCGR3QuoFQHg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755154489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fvpvxhWPdoJkSDZ8MlphGYTdGzSm3/ja2JHmLogOOeo=;
	b=GyLLNvceDwgjh6G2Pb6Fn4KGxjVKHEpHd8NbFjBYo/koePORyyQTpX6Q8YMSQs0DuVaqmh
	3l+rdkx2+SUM79v9R+KAA/e1oYKf7qYkOl2j2vQHHyAErCEI1sCVGpniRX9CweIoUjSpIA
	EcJws1xcdSYVenh2MAPM9ugtgzfzrfk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-I7Frj3v8MR6JymlR7eg7Og-1; Thu, 14 Aug 2025 02:54:47 -0400
X-MC-Unique: I7Frj3v8MR6JymlR7eg7Og-1
X-Mimecast-MFC-AGG-ID: I7Frj3v8MR6JymlR7eg7Og_1755154487
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3b9dc5c2ba0so254389f8f.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154486; x=1755759286;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fvpvxhWPdoJkSDZ8MlphGYTdGzSm3/ja2JHmLogOOeo=;
        b=pxVyCvpcV0H3+45e0b+V8+fCbnSsxpQm5Ibt0njZf7uzF2Ht/1hhetIRxMaTY6TNWu
         4cJhuVKVX8dbq4/lVgI0i91g8Fu1tlhZnx8uaM+sfUKicdXnWwQouJU5TEtDNfvA1yt5
         f6wrOogsoP2QaBhbP2Kx2JEt6dcgyVXrF0uimNsFyJsAQA6fytFHAHQuW0ZTv0VixjQZ
         kI9AFIbFgzmgc6eLAYOXWCp9CgX6Wb7MqKz++2KC8oIvaEdwnojEifKtwChNzR34nwnK
         FvWkSRkZ+OUPlp3eMtbecl1GvOh9LefHa0jMcDhCwQ1uj8Ja9X9RjpqEFAOSxCwW7DB4
         zPkA==
X-Forwarded-Encrypted: i=1; AJvYcCUFk+qpAlvEwWS+VutcxRe2g3QHjXuWVoXf/1+RZlKd7O73/vQMeAEUToydhhoDqOYDG4i2rKwzPw==@kvack.org
X-Gm-Message-State: AOJu0YzHaL/8Ufv6zHDWfA2hMXDVAL9BAU9Ae17wyyVleGJf+x9ztO0R
	HoUEVpvOl/zmlcLKhzqAk/jgIq4Fjb8AyzbkRdhb838+RE1uQ7b+r9JOa/KRjTYJR3f/5r78scu
	STvisZ678d6pcPlEDsCjNcYqBYyqctEWVBJrkRCG2nF/rYAON+MBR
X-Gm-Gg: ASbGncsT08XA8Anon/C7psYYXESm7MhJtB2DD3Eor2WDrPj0IFgPUa9HECnqq9/UuG9
	2uLlPInf4Z/4StfPBB5BmpgrBveA1JlzrUfx+HTfK5Z41NFjCNpYLT75cjBp8lT5TcStg2rXLYN
	X3CpVqO3TizDSPYsvE+0GTx31VWlUPBbaacYreT6YDg6z95kxt6LX6BvKXF8m2/TpER+wt8m4ay
	fyRUJ+/QGOA0SZCrvdmVqADNsMP2tNSd6LOVUZ8bX7BZDy6dWb60KMIk1RwrMY7DgWk2ce0CYiO
	a8MzCI0DbwmLFsQRDDVN7l9qLiBaknCgBRsUh1ns2tpm2swBrlHsPv8+mbUD6FuA4yWCUE9FLSP
	gOkB7Ait1ny4oXrU2IM9pJgaI61XFsboeYSsnp/5QBXQTq/j8ACJv25ieU+eFSgtp5v0=
X-Received: by 2002:a05:6000:1a87:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b9edfbcbc4mr1265104f8f.49.1755154486531;
        Wed, 13 Aug 2025 23:54:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuwbSd1hfoguf19DDqWvE/vkGc7hbRPXw59LAVpN/NURRA3qyTI3CteiBCp7opzPeFpODmtg==
X-Received: by 2002:a05:6000:1a87:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b9edfbcbc4mr1265091f8f.49.1755154486121;
        Wed, 13 Aug 2025 23:54:46 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1d200fe6sm6366685e9.10.2025.08.13.23.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 23:54:45 -0700 (PDT)
Message-ID: <b426d3b9-c674-436e-95c3-fcc7647a044b@redhat.com>
Date: Thu, 14 Aug 2025 08:54:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/5] mm: introduce num_pages_contiguous()
To: lizhe.67@bytedance.com, alex.williamson@redhat.com, jgg@nvidia.com
Cc: torvalds@linux-foundation.org, kvm@vger.kernel.org, linux-mm@kvack.org,
 farman@linux.ibm.com, Jason Gunthorpe <jgg@ziepe.ca>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
 <20250814064714.56485-2-lizhe.67@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250814064714.56485-2-lizhe.67@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 71Jbnrk339W38vhFCy63QCz3HtA16GIXr0qb9fcreSY_1755154487
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D4E884000E
X-Stat-Signature: nxmdz16xxufiwg5uaehmj9xod5gufd76
X-Rspam-User: 
X-HE-Tag: 1755154489-677585
X-HE-Meta: U2FsdGVkX197rNsU7cN3TDkkrsnIjRw5dpHiqevd1Bp0PXY3er3G11KVAQEkjC+pyG8tuZ23QPUo/RTJo/ikErGB+uiX0VW7F7fySeV16CKBsZ4y/dIfuRWQAb5zJGmPJVVRzyMrVYJRGkQp4ssOX/jMqV+0yviZHdBgBWjcZg9ftVl2t0/D3P30/8yIF+Q3kU53xlSsSo7SDTnwl5QE+D3wU5T3tQCEjMXSx3hKbbKQnmj4gJee8xwtgWyC8Gl4dRVMVZcPupbQyhQuFET4xokApCmo6TBa6oI0q435W6Bg6FoEQx2wa24XNXeqTU0PrCFvrnc8VAQNnm8O2kRVyOY19mu9MtzMtO5z3tzYtiWpdu9X5ZCoGvQQObjnts1JFCTGbag+yedvrwn7ipRSvkxzVPIUweTvJZVpeDhj5cFIv08pF+4MSkRccvwptOxUNODoEnj0oEOO+Q1RqQenNDrgumNHkbEAjdfOS4bvoRJEwcTvFOXEqFEQ35rean3exPfZG/3zwXDCTvYEx2VOhpzhM0ZMAsM8/BZIe13QYtUThDwt3cVnO8yG8/Lst0XsqSGZsO4FQd4BtimFqGgveiS6YQuW6U4mDJeJZ9ksEyYIxHhs2qpkJZaoYwSowXQKsuvq+lzDJNExXPFR+354VoCLVZ3Mjs2dV3q3huMvGSZ/4GJslLClTTX0ZDRuqLbhOXwJPqJrDm+Mdf1dT5/ZmzjBXlItCnUQ03ywXPjvXc5aS3QQ7c2tzEwcJwt9zO4lqHyx1cAugi0K1u7KrsR/qoJ52NxeJVZsQxExmPyqpn6MkYMmymBecbNYNlkrP/lQyXgcrSptg3WdoRxVa7RNmW31dk+UIJY38fYF7rvGBYTHdZqqL7XFxuZZoFpOItFtkXax4ISi06nZJnqXo22N6QhASpXerPkguWZeGtAg+EHuyeFDtAFHFOA+pgn8nj7+aiJZ4PzqY15j/MzV2CA
 SZ1iZt9a
 v2XS5NmLMwzUiPhSkblgbAnafy3EED7Nmjq2zti9ZAhzXL90hhYnpE+MaMv6jcdde2+Z8CCSouTAODvjzq0tWM6zBOfiqWKxDNuQhjFbCtunIuMnryMdsg8YLzOTU2rWPpdA+m9VkhQWRDpxS7s3SBD6UMs5WCeXPVJUaGXjElAYyy+5uCYRLur227v6lRP0/JJ1dpz3mXMimxgnPjAKRREa3LJ6DaGX18VDdkhR5jBQNv+yubmYdQm7Q8jUllfSFUav9fPS3SAvxge5O4s7gzY+CENt9vDCJKtI8fS2/o3LapXxbO1t3thqHBqtZrv5wmoMw4qJKtsgSF1ruUCw2P5fqpaw20Nmh5KPXTWykx4u8hQXfk8FvG/fHh3NnhLwHmj/0xJPifNmE3c+We/aFUPXzEtJBV/mHEOwmX42DbEjAEHWBnIcKrJw4hB4znl0fbn4x+ufx6PjbNzqbZm7G0MpMOMCFcdiWnrC5ApDPb0UiDYeZtXwDavPftelCk913YI/8Pdg5AtXvr956GVoqiUzSe5RFK/P/xUf68EvA6vwnuXyHLeOQryrguAw+XeDh96JCbBGVodJiH8v6wznWo7zWODRulg4kj7FcZkuCfdSAx9f1Gnlq3cmGPxLsOglE16uP9ZBZKr5LM8uXHGjLJS+LlFZ9jTgZNca/BFvuFe6Mey1fnL1PRE5UEYIo7TXNCLxdbRJT+ILM84pq0oRU06k7/Ya6f5hHqBNR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 08:47, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
> 
> Let's add a simple helper for determining the number of contiguous pages
> that represent contiguous PFNs.
> 
> In an ideal world, this helper would be simpler or not even required.
> Unfortunately, on some configs we still have to maintain (SPARSEMEM
> without VMEMMAP), the memmap is allocated per memory section, and we might
> run into weird corner cases of false positives when blindly testing for
> contiguous pages only.
> 
> One example of such false positives would be a memory section-sized hole
> that does not have a memmap. The surrounding memory sections might get
> "struct pages" that are contiguous, but the PFNs are actually not.
> 
> This helper will, for example, be useful for determining contiguous PFNs
> in a GUP result, to batch further operations across returned "struct
> page"s. VFIO will utilize this interface to accelerate the VFIO DMA map
> process.
> 
> Implementation based on Linus' suggestions to avoid new usage of
> nth_page() where avoidable.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   include/linux/mm.h        |  7 ++++++-
>   include/linux/mm_inline.h | 35 +++++++++++++++++++++++++++++++++++
>   2 files changed, 41 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..ead6724972cf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1763,7 +1763,12 @@ static inline unsigned long page_to_section(const struct page *page)
>   {
>   	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>   }
> -#endif
> +#else /* !SECTION_IN_PAGE_FLAGS */
> +static inline unsigned long page_to_section(const struct page *page)
> +{
> +	return 0;
> +}
> +#endif /* SECTION_IN_PAGE_FLAGS */
>   
>   /**
>    * folio_pfn - Return the Page Frame Number of a folio.
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..5ea23891fe4c 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -616,4 +616,39 @@ static inline bool vma_has_recency(struct vm_area_struct *vma)
>   	return true;
>   }
>   
> +/**
> + * num_pages_contiguous() - determine the number of contiguous pages
> + *			    that represent contiguous PFNs
> + * @pages: an array of page pointers
> + * @nr_pages: length of the array, at least 1
> + *
> + * Determine the number of contiguous pages that represent contiguous PFNs
> + * in @pages, starting from the first page.
> + *
> + * In kernel configs where contiguous pages might not imply contiguous PFNs
> + * over memory section boundaries, this function will stop at the memory
 > + * section boundary.

Jason suggested here instead:

"
In some kernel configs contiguous PFNs will not have contiguous struct
pages. In these configurations num_pages_contiguous() will return a
smaller than ideal number. The caller should continue to check for pfn
contiguity after each call to num_pages_contiguous().
"

-- 
Cheers

David / dhildenb


