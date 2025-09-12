Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4EAACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3798E000B; Fri, 12 Sep 2025 08:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364938E0003; Fri, 12 Sep 2025 08:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C008E000B; Fri, 12 Sep 2025 08:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD9D8E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:42:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9C1387092
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:42:48 +0000 (UTC)
X-FDA: 83880562416.11.A3B2518
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D549160003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:42:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjYWnqj9;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G68/Vcl30gBKrC2/x62wn4zQW5Fw8/QtQkhUplaCLsc=;
	b=XDY7/UJCqb9zajnjJ0oQubQIiU4ItSOLQJBicOd68bj6PsY0RweMSQVUUuQTCrUZdrHN9o
	dMeaMwBV8NBLnU6Z2YK32KBFlOMI9SYaYBZKU1QvUn+GpIwolwhZriDMlMx8P76nEvF1wQ
	ToPc69wQah1Wt8wYfTfgW1hoLAndZHA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bjYWnqj9;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680966; a=rsa-sha256;
	cv=none;
	b=H6eaE9vzJauC6Fk4TKG8VNBIDwIUdXM5YOoPOEpROacdpC85iEToO2v/ma34XmJV7ksWWy
	FmEuT+mVgtPYDX5dOXkPyszubvLofgZGz7cPHmkoybufWlO/7VsukNXvmhgiHsWUeFcAhz
	kS02YLQaQSQgd4VssIuoIf8cEi3E5DY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757680965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=G68/Vcl30gBKrC2/x62wn4zQW5Fw8/QtQkhUplaCLsc=;
	b=bjYWnqj9wVb7ZskmKnlTOARIEazbnw4bJ8aYlUKf/Ixt0ykO14QONMq/5O6sShHvQogwzC
	tRJxVFy0vWM9mFjGkU7/eThOo5HZ9EtyBDntQFzCRQvhJwOGrp5MLfIKjwPZvGlecoD+Ac
	qqHUvhExA8MjVKZbtWk9L9HrKS8H6Zo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-m5Bexbe6Mxe4V_ozKoaqqA-1; Fri, 12 Sep 2025 08:42:42 -0400
X-MC-Unique: m5Bexbe6Mxe4V_ozKoaqqA-1
X-Mimecast-MFC-AGG-ID: m5Bexbe6Mxe4V_ozKoaqqA_1757680961
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b990eb77cso11624645e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:42:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680961; x=1758285761;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G68/Vcl30gBKrC2/x62wn4zQW5Fw8/QtQkhUplaCLsc=;
        b=ZuAjcxvc8Dt/O628EOW0DeJ92FzvAVWNBRkBIGc38jlDv1ku505W1VRJWOfJxqZZYM
         9YzBAG906YvOpNaEUOGcF6Jo9DKQ6rirAWbS8Z5vNqjDVJWJckfJODwk926h9ndr1QtA
         t7akROOpWP2w+xlETUzfxp9XAQH9wdxKZV9KutkGbRRX4dW7DTM8GO6RSb8Me0WLDwzS
         lOJca/4/CXOStVSYioeJ8DRcd6d/n+pTnw2vKvuhr9zxXX4x9rLsjfC+sILqUH2SHwGs
         KCOHEwz6dMRQud6e4OMch/UX8dQow/XTI6zk5brzOchAgito0m3xqXMK75Pb7O0vDFVg
         TFMw==
X-Forwarded-Encrypted: i=1; AJvYcCVan0hOHhm54/meqNOGzQjtkr3LDUfniXeswL7L6PMoVhGN8OZzzX9js9FtrPRIssnGBAxWdc6Cjw==@kvack.org
X-Gm-Message-State: AOJu0YzT8QZtey8mhrtfORzduqB+EvYKoTQFDbVugCnJJt4I3BDNMs2j
	T50fmpSewdVZcn9ARpzPf9Ek5GFtj+Ig62zma2Y2xOVXSHD5hC6Avb1qouRCPb3F3ROWIisJDvn
	1Uy6eoW8dSpSLjiSWetZG+PpELx5LJQQEq3pBj7oYYwXNbYiJ/EM/
X-Gm-Gg: ASbGncsv+WTKcW/OfskzYeZtOXO93tLsjMJhonhnsc+i2FJcsXT996lIZaQntj53av+
	Dfnh3a3PTXGRW/W4nicQd3PvWZwe5q+zURk3Fnvz/UJEGgB7ZtPDNwAndDd8X8zCqvKJ3qqcec+
	k75CsAqRkRxjq8/K3LSOkG6wpiP/ffBB9/L2T6E/8lO27+IqJgdJCCOn05bOam/BOXqCkHwOs1F
	aX65ZwkURaJWynLoVp9SwdoWVkZfCpDA3O9ErVrsAdxy3zVO0HeeLKIrvP8bRlMn3ptOeaDiNs2
	VjRhK6iAdUChHrnrlOIO+60e/e8/fBtKEA4B0/2YxuCutNkXie/G8mgbSZl8SA22jNgGMulQ3rW
	ZDgkjPLFLP+EXz6fNgae4P21yyH0YzozThYiWZe44GPSTLMRF6BrS9uH3knVtZAkWxmE=
X-Received: by 2002:a05:600c:3328:b0:45d:e728:ce6 with SMTP id 5b1f17b1804b1-45dfd7e75a1mr44551985e9.18.1757680960989;
        Fri, 12 Sep 2025 05:42:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE8FYlxUSGpt9qV5IWzAmbChJ51bMVMip/23iOY5R9qJCjX4HDDSwisLFfp9Dft+/PJESOvyQ==
X-Received: by 2002:a05:600c:3328:b0:45d:e728:ce6 with SMTP id 5b1f17b1804b1-45dfd7e75a1mr44551765e9.18.1757680960540;
        Fri, 12 Sep 2025 05:42:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e017b3137sm66439175e9.19.2025.09.12.05.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:42:40 -0700 (PDT)
Message-ID: <302d47a7-4f20-4c74-ad3e-b8574970bce5@redhat.com>
Date: Fri, 12 Sep 2025 14:42:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] selftests/mm: fix va_high_addr_switch.sh failure
 on x86_64
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20250912013711.3002969-1-chuhu@redhat.com>
 <20250912013711.3002969-2-chuhu@redhat.com>
 <20250912013711.3002969-3-chuhu@redhat.com>
 <20250912013711.3002969-4-chuhu@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250912013711.3002969-4-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8U6K9iebUHG1uA8_TOMNTFeZS0N9foo-ZuUeVI74_wY_1757680961
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D549160003
X-Stat-Signature: g3opasbhqudtxmus7qahyqseror6bb6a
X-HE-Tag: 1757680966-121537
X-HE-Meta: U2FsdGVkX19zBYNLf91ZRY+YS7FGv/e6mAyANGAH4XBDTg+lfEh+BoN7RosB8YGHvG4YuHhhlabXPTfXs1e70AxG5nkhxHjJPP85r68JzaUSjABGhvJ7A8/UgOLOtL6jsNfQeE46uu7u3SyffMyiXBWK0Yy39uvQDOllr5i0Arxslwo6ioeOifXE7B0utlulMhWsIkohDxxfLrIPuHS4l2YgoeDiv4HNyXsquJ6fVvb3AvxxuQxd+k73tzCYt/wWtbDAT+SrcDe8eMYwIZo1kmwrUq94kVJoJRA4xDOIjZsFiVU45ZbQun2ZhYkxIkEiKwQmEmUZLCGYyTgrJRSRoztfY7Y/3s8FYOEpV5upfI6gF47iSmu1xOQ9rhw6tKg7fTAzN2x4N+6GzSbq6s7GjGjd3WgR0LbVHEvwHHJdxm0mwKFIcLShwZJ/nUFfHVug0OqkbhxAwVwvxfdu/LKdnmc77zAMxvfBbP8VO3PMOC9ve1DYApmyoTpV7ajMAsO1ScjGlV68vrdpyN9tl9dXZiwnrl9jYk56WOpOaJnLBHtrRY2CEekHKY0zeZq8pdudlBLq6w6gy4kppKdHxxPZsk3CmnOMUh/+ZoWoJEWhd0702WoLeo0S+h//M1omiwHZ3EFTDKKU1ahjUPCUXhcQCcaqpqoxJWVH4uOR3wMwDezO/yq0a8QByK4gWBw0H38dydOluCMTftRM8WF+ubVivX/R6R+qnA8UkQ6sdiHDCF5rIxWXd0Nwe4ft+56KvQtP2JMJNLY/6OwPzFvvEkDqnKEW2Sytij5iclHp5istajpe3cmj1w96G3r8bQB55vKyXab1cwcCtmXaQSHvlILQShEByUvazWGhs2DMFZJLSvwqVs5JaWZw0y/vBesTcCJ9l1Y6zI5PozhuhbaZBXlnus4+lmp2MNCq9GHm3wDKplGlzA8XzKU/nndMnCTsN1ydq6UFne770PAKuSOhiqT
 LZq5x21a
 ZNYFJBodR4UCk1SJhjOpUi07q6UNGqGylH6jw9o8rJVVuKG+CuHXp+ye/FV7OZGGKBZiIZZR3/kgrtgG0dG/QfhMg6C+DzxFMoGvIqKVGAS2Ewx7xx0bw/hTi4wVoIyqdpLt5RMfmfxS7Aae7wnZq3ZKoFgFj2AZNX1FuEjRNqfiz2eYDnr2I2CABoxr2UKbo268Rim+IXqWtdVk/L6YvkAvHPTbSIKjBsv+xUKCU/o6Rolj7EPfGzGhKHGCFNEVFW61IKv2HdHlIRTnojacbzhlB2Ymvg8EFjkHFfx36HVbN525VwLOPXZLoxEHg72G/6fCSoLWpE7Sf8wY1AilNn3mYqhVI2SDQ3pOqTsJbvcoEuU4MomxweZhKYADWWlrpypuLVbgoe0BkKTN1TILaUcqSXuXuCNm2j7XNXUZJFZA6Ty+IwvWpGO/MNVwKCbRTQ8DPaC5m0VVLDYRdq0QyJwplQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 03:37, Chunyu Hu wrote:
> The test will fail as below on x86_64 with cpu la57 support (will skip if
> no la57 support). Note, the test requries nr_hugepages to be set first.
> 
>    # running bash ./va_high_addr_switch.sh
>    # -------------------------------------
>    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
>    # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
>    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
>    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
>    # mmap(NULL): 0x7f55b60f9000 - OK
>    # mmap(low_addr): 0x40000000 - OK
>    # mmap(high_addr): 0x1000000000000 - OK
>    # mmap(high_addr) again: 0xffff55b6136000 - OK
>    # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
>    # mmap(-1): 0xffff55b6134000 - OK
>    # mmap(-1) again: 0xffff55b6132000 - OK
>    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
>    # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
>    # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
>    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
>    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
>    # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
>    # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
>    # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
>    # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
>    # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
>    # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
>    # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
>    # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
>    # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
>    # [FAIL]
> 
> addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
> x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.
> 
> Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch code
> arch/x86/mm/hugetlbpage.c and addr is checked with map_address_hint_valid()
> after align with 'addr &= huge_page_mask(h)' which is a round down way, and
> it will fail the check because the addr is within the DEFAULT_MAP_WINDOW but
> (addr + len) is above the DFEFAULT_MAP_WINDOW. So it wil go through the
> hugetlb_get_unmmaped_area_top_down() to find an area within the
> DFEFAULT_MAP_WINDOW.
> 
> After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> functions").  The addr hint for hugetlb_get_unmmaped_area() will be rounded
> up and aligned to hugepage size with ALIGN() for all arches.  And after the
> align, the addr will be above the default MAP_DEFAULT_WINDOW, and the
> map_addresshint_valid() check will pass because both aligned addr (addr0)
> and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned hint
> address (0x800000000000) is returned as an suitable gap is found there,
> in arch_get_unmapped_area_topdown().
> 
> To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
> addr + len is above the DFEFAULT_MAP_WINDOW, change to choose the last
> hugepage aligned address within the DEFAULT_MAP_WINDOW as the hint addr,
> and the addr + len (2 hugepages) will be one hugepage above the
> DEFAULT_MAP_WINDOW.  An aligned address won't be affected by the page
> round up or round down from kernel, so it's determistic.
> 
> Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


