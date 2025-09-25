Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEBCCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 12:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80D398E000B; Thu, 25 Sep 2025 08:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E4F48E0001; Thu, 25 Sep 2025 08:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713598E000B; Thu, 25 Sep 2025 08:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 636068E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:46:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3C37160138
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:46:01 +0000 (UTC)
X-FDA: 83927744922.27.C03F849
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id AB0318000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:45:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LnfFiGMU;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758804359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tliHUGl1NX2itzYwArqZpvvubj/ojpB0Xta8m0g/P9c=;
	b=AhFGPiL0BRMSYLcqSCTcH078TE6avV4ypu0qmkyHxOKDiPV/NBJu7VFhxd6Qv33oRREC3P
	wzP/7IFIJjpDVr8PVG5cos3ArFWqc21EEBUPxGWbKV8UanEGOeOZRfx8NQiadDNeNRzW8r
	c2Zg34WdqIqgSGB3tPe7gy8F1jdFkic=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LnfFiGMU;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758804359; a=rsa-sha256;
	cv=none;
	b=t3VyeiF4flIatkG1CMcGQY+1KDOfGKZRH/bVSMfng7JlV6yjUDqlh0W9TH1jGRD3v7Bryw
	+5PXc4D3MXfwo51ke34ij+tDmcZajU0rOmjfFBJrUTfgCMw5iMshSbrc1fNZaziouushjq
	mUc4lsR0TPclRc5skw8MV+7H+iVRFl8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758804359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tliHUGl1NX2itzYwArqZpvvubj/ojpB0Xta8m0g/P9c=;
	b=LnfFiGMUbLv1N5MjxyW8ABb+emaLyDtTaK6+lwfzJy7Xjv2kCkDGq4XQ7FfybYjRZsnzSx
	0V6ViZK6rRLeU6MRU1N6Hp2svsGJV3TcQ+pACK++nqkp6kKcjCSWaLJXmbOzc92k3azGtY
	5ALUqgMlpNtmMinyzm/FYhzNgwA0ZaE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-206-gQdf-0oIOC6GjakDJCkq-Q-1; Thu, 25 Sep 2025 08:45:57 -0400
X-MC-Unique: gQdf-0oIOC6GjakDJCkq-Q-1
X-Mimecast-MFC-AGG-ID: gQdf-0oIOC6GjakDJCkq-Q_1758804356
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e39567579so187335e9.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 05:45:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758804356; x=1759409156;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tliHUGl1NX2itzYwArqZpvvubj/ojpB0Xta8m0g/P9c=;
        b=Yc8s7JwoPMndsh6azhoJJphctpPBAMb8AmGhuT90sxUaew+P+NxbC0O1SzjANQdraR
         DSXnDOgwHx+uUvSNrx6SBgMK5R2eG2kTZIatF96dIXPBa/2TkmXTAlEY87Lx2BXxNwfM
         Sbtipb0WfrKB2maWL/6eps2TzaEmDlD83MQLhM/E0YJmf9syUIbbyjm8W0MPDiWSon5C
         O0uC3H+iABEnTG3xKnTm8xhblDS8as8j9NX9wBmw2Vz5HAkVxvnM5rQHrRwRqTT9XDS3
         GFOzeav8FRUlC0mAC69aP2pOzzjvtPxNbCAezx2u+awDuaK3DZCB/0Jw/b6ypzom2qHe
         KhRw==
X-Forwarded-Encrypted: i=1; AJvYcCUTPZ5TGZ0xaY+dUF5eJLXW93fAICwRS14zK6O+xXgm6k307nP4ZXrK5BVDS63d75g0hMcCEhub2g==@kvack.org
X-Gm-Message-State: AOJu0YyLM+mYS8+9iZFZbLs3ZHBrRCoq3yX2fiZPAImEP6pZt2QMJ79m
	32j52rouc3xXwo1tzLU8z6aa0BRJwqpwMR+DLWQ8hTkVr/hDhf7sEy/Z9ayWQw+1E76LA0LSo9/
	GaJaTXUlhDioC2m6rGIq3hkPDvT7jX6E4ilN/ViF+GzXD0F/u7x6t
X-Gm-Gg: ASbGnctuRA4se4EpdvBvwff5t9wPUookeST7zE0Vz1IiYh/V859b01WUSzBRnDqItza
	yeQA1QuA9XGSUefwK1T9htJ8c60yI5zWW2/jy8zMhxWqOPKEKfuKERS3t5dOYtPBn1G2F6KC880
	cq1VTpk0il3lje5Mg0X7xallqX4QY83b5KnXgWKT2e0v7oimdmwsOaanfZiDT4LS9Ed10HlJmoJ
	hlo1rfTtiQ93wfx47aRCCXyOyIu2XDcREA0euxKQp1Gx8b3JpiFx8vCDfO7i1178O5XVtydM3wl
	Wfm9Ayz8Hj8UJclEgqGViWOrKLI8kJifDRWffXPL5blZXDFkrYGrp/Upd3slJPgU+xgO8bx2w7o
	JTGZPoMufjOYybmh6FEJj8i6G0xg4+MF/2Xix+NKREUjJM5pSrolVGvEIZzTqllFaZaZn
X-Received: by 2002:a05:600c:4743:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e329eb11cmr37972675e9.24.1758804356473;
        Thu, 25 Sep 2025 05:45:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJhKsYlnFC8iB/Ma/engXkSgdIOoZQ/qaChN82QOE7O7GuUbNoaCoYIvsSrrRCZmzhX+hwTQ==
X-Received: by 2002:a05:600c:4743:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-46e329eb11cmr37972425e9.24.1758804356075;
        Thu, 25 Sep 2025 05:45:56 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb74e46bcsm2945522f8f.8.2025.09.25.05.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 05:45:55 -0700 (PDT)
Message-ID: <43ae76b9-14e2-45b9-83b0-4e5fdb6bfb3e@redhat.com>
Date: Thu, 25 Sep 2025 14:45:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
To: SeongJae Park <sj@kernel.org>, Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, rppt@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, elver@google.com,
 dvyukov@google.com, kasan-dev@googlegroups.com,
 Aleksandr Nogikh <nogikh@google.com>
References: <20250925123759.59479-1-sj@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250925123759.59479-1-sj@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KTPIl93Mbaag43B7qpBYUrystiMLUJz9j4a-wRT4vaE_1758804356
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AB0318000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: worztst6hrtbe6zgrmsnftd31xi8gc1o
X-HE-Tag: 1758804359-867618
X-HE-Meta: U2FsdGVkX1/dSrDldnpYou5lMSYWptKoEokCgi/Zg1uDH0tHgQbhsTc0bGckRYWIXsuVSbe1WIoZtn5DV/zUn02jsdpgeU/uzRW2cdv20fZd99AfAEEls4Rsw1LNRdlVRinf57dqsCMMywE1QLKbLhoVIrDeYefF1qh9kpl9Ly5n813nzPUCKdsvC2JEicbC6dbd0g56rLXmtn8h1Uq7nOQoaeuAXVaXNLjRmGE2i5gVTiHR4iysLy2WBz48d6fWlCuocaL3KQS3EgEgEFri1Js6NiE2DLgxIhYnJbXuMnDLX7oi3zebtQAehorlqYAIctetLz6RMMWuTrUutlI3sZZNgdCRE6SkmM6HJVldoA7nZJI64bHeAHWmagCqxwkmSOo7/NUeWZ7JC94J+VzIbRImwV8KF64cYv4jc2VWROYMRwDGZT0lTEPUqWo4Fe2Wlwsu5sbrg3MavcX2eRpG/ehaOeMeaqNGFPPTkeulqxe6FCfIVNLC75Gvq98WiCQQTaM0sU3lEUsfVVu2nWdfaP7lLveeA3SXzrt0zotc90g2ruCPdZgkGdQXUuF/HJ/h/v4Yic6uXC55V1SHlfJfHISXn5Fmgbo7EEuFDdW2OqC2LHCHfRSWU9F4odsa8kgoZTFmn10/qj7V6U+nmydOHLT77hYCWnvuYyQR9rLlcPWEkjmEwEOJYZv3ghhEOOVqDvL2WGt3A4SfrWCluDd/k3hquzs4IbsjiR03MUu0ivObYB1QWMFjZlWgUCbKG9iqP0+5h/wDoqaR2koAb1N7XeQsg9js680Fj/P89+16ToEI0h4JMB7mVRy36IYO3t28C0k9iBCNwITTnnzHfGieaXItVAGHDAD5K7G4tniZZ+6p519k1fz5hQRhhC/FF7aCxoJpO2PA7gXiTQb01U4ZMD0BvknSKyVzvDFpj8LHwflpszmOl77QSbTN0SzV4gwT8CT9O4rJf/Kz/rnCM5e
 vplAVu1s
 vedavaAVLqjtCrDC5Qmwf5UIsRRkAdZCmWc4kpoVio5a6XhNaBByiQ9hIDpkxPfy/0nv2elnhtvbUWpwooFtHzdrnKQFoOl5c8wUVuVEB8TukW1APnKNzgn3EDWWNjAEH4smuUiq12OpuaCTq9RYiFu9T4vq/3rKREQnRut9WNKtae+B76Yy6Sj5QWb/u/lR8fzG8IuBIcAcvwzhpfqmcqCP24SbufjycujcdUPbrcADfsQakRg3TW+Ctsqtm7UNSqY84eZXNIPiLc4kwW5wZdgejUwylV07WFXJ4JGjzOfm296/z7rXbD+w6Oqbpj//g2GEaVuHx62ohiqs1bqBWAlyU0d8+U1wS2dIQeU/7RP4cadns93sKIOl7d0UhCX0D2B/0+4tbfNYMq7jJfzldHZzQ5Rb73JYOWvn9am9yZ32kD4oEioECdmYfJm0OzJAEdAqQJwrdYK55xI6JSQRi6Y8zUhAy/tv1vViF9arq7rXe1JjRY3VawR2dLCSJcDimgN4J2rFxJxKW45J9cBvPQmWUABNB/+ezwoSZNfLlDZOqX3Wi9ulmf7qo7Lt5eA5uwMkZXN2p0lRxB6Hr6ROBnxGWnhXMekzG2wIH5Di3jKXMzt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.09.25 14:37, SeongJae Park wrote:
> Hello,
> 
> On Wed, 24 Sep 2025 12:03:01 +0200 Alexander Potapenko <glider@google.com> wrote:
> 
>> When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
>> for metadata instead of returning them to the early allocator. The callers,
>> however, would unconditionally increment `totalram_pages`, assuming the
>> pages were always freed. This resulted in an incorrect calculation of the
>> total available RAM, causing the kernel to believe it had more memory than
>> it actually did.
>>
>> This patch refactors `memblock_free_pages()` to return the number of pages
>> it successfully frees. If KMSAN stashes the pages, the function now
>> returns 0; otherwise, it returns the number of pages in the block.
>>
>> The callers in `memblock.c` have been updated to use this return value,
>> ensuring that `totalram_pages` is incremented only by the number of pages
>> actually returned to the allocator. This corrects the total RAM accounting
>> when KMSAN is active.
>>
>> Cc: Aleksandr Nogikh <nogikh@google.com>
>> Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
>> Signed-off-by: Alexander Potapenko <glider@google.com>
>> Reviewed-by: David Hildenbrand <david@redhat.com>
> [...]
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
>>   	return table;
>>   }
>>   
>> -void __init memblock_free_pages(struct page *page, unsigned long pfn,
>> -							unsigned int order)
>> +unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
>> +					 unsigned int order)
>>   {
>>   	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
>>   		int nid = early_pfn_to_nid(pfn);
>>   
>>   		if (!early_page_initialised(pfn, nid))
>> -			return;
>> +			return 0;
>>   	}
> 
> I found this patch on mm-new tree is making my test machine (QEMU) reports much
> less MemTotal even though KMSAN is disabled.  And modifying the above part to
> be considered as free success (returning '1UL << order') fixed my issue.
> Because the commit message says the purpose of this change is only for
> KMSAN-stashed memory, maybe the above behavior change is not really intended?
> 
> I'm not familiar with this code so I'm unsure if the workaround is the right
> fix.  But since I have no time to look this in deep for now, reporting first.

Good point, I think there is something off here.

-- 
Cheers

David / dhildenb


