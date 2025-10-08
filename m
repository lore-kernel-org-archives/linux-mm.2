Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C7DCCD185
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DBC98E0011; Wed,  8 Oct 2025 04:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3B98E0002; Wed,  8 Oct 2025 04:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2378E0011; Wed,  8 Oct 2025 04:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2926B8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:18:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD580B98F1
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:18:19 +0000 (UTC)
X-FDA: 83974244718.22.BB061D6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95562A000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:18:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XEhyXyt7;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759911497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2/UyH6Gp/CXE49aAkLm4ZAwJ2vJKxqomz6AYx7ZppY=;
	b=1L5KZH8xMS+vBlQ1P0DkZsb/nPsw4Y7ulQ0CRLA2Dqp38aKCSlNSGY7rSW7NX2AitpbfoO
	e6mxvO4KpUepafGuyXFyhrri3GX7y4uWdznQPGJ2R0Pxg/5lGjR3V2QSU8wzKA6nO2goGo
	wa7aYSn7ZM6WsYXJyPxcSqcd3ZW7z5Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XEhyXyt7;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759911497; a=rsa-sha256;
	cv=none;
	b=c6FtgN+fSJFv5Np+CyxC/r1KVF9q+4IuX97OcnC9TMRj1Srshi1zm/BUw4NyPqFJlKdYaN
	dy2TIK1K4d3vVsm0UIKvktolTdz2WvbYNlxFjYFtrJ4eHsTLiRuNlhmzPZn+CxS91KySgH
	OQYrz7keEAFF0LCnGh60tucQjtJkTrA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759911497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=g2/UyH6Gp/CXE49aAkLm4ZAwJ2vJKxqomz6AYx7ZppY=;
	b=XEhyXyt78a9FH358LcvaYz2KU0VBPPA62f9jwQpYDFsg+6IiEiCuduwHkml5ibH82He0io
	/lMwuuBPCx6XW9zvBJExvaWxzkp0v1p2a+/iX6Xl3f30WX0utGkOg6TUu7n4XV5dqMaegy
	mi4BKmfnwXnt5BL6GHo7/OLhZzQqtes=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-Vz6C3PTIOvWNGFXJ7MEJsA-1; Wed, 08 Oct 2025 04:18:15 -0400
X-MC-Unique: Vz6C3PTIOvWNGFXJ7MEJsA-1
X-Mimecast-MFC-AGG-ID: Vz6C3PTIOvWNGFXJ7MEJsA_1759911495
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e38bd6680so24212725e9.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:18:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759911494; x=1760516294;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g2/UyH6Gp/CXE49aAkLm4ZAwJ2vJKxqomz6AYx7ZppY=;
        b=APyGX6BDmKsx5ds/8eUdUF3jcNP3FPARNgytjGAGBfprhpYd1e5/5RMgw/ElshsLVo
         O6pAQL7yFrYZelEUycvw+v9r6DSIuKoubJP5xNQoHKHBqXO+n97+NUxruV7Vwx2pPikV
         pQymRlmPivK1EzxdwQMzpdocw7FIo+VRoABPBxisgQ0M8WEp0CK7X9kEshnodDbsrVWA
         V6ybvOLP5WXD9ukN2cdXodzfNZ7MZMDSEp53F6WuBVaBNbl4ZUL91aJmSMwkfnTwkWG/
         od8XoRbp+jsPAlbnGUBJDpgEXo/1L6PCU5MYyW8G1YDMMzBqXP0zkggHPC+JHGW4GoRB
         PwOw==
X-Forwarded-Encrypted: i=1; AJvYcCXgTWrzRjKGSy8S3rElfJSzzCDi4E3HVmNaueWrKZVQ11Q1qwbpOei5GN80vqpuOcwZQeBGvOebEw==@kvack.org
X-Gm-Message-State: AOJu0YywzGGCO0PEM0mRD1dhJFWolSdPm3ACXriGYO498Deb9IGXiqJw
	BYaXPoWqvTxRmhskTwFreYB18PmMxL0y+xPzK9mmpRZioWV3tMxd8AUIksz3wxR0/fMZWsJeTyh
	NMg66eyYUtKM0HITACVKHQZGUUC/dCfLjaGFyWpADjNOl8Nw5A+gC
X-Gm-Gg: ASbGncsU8WBLH3qKtwDwAGhSwsMuhhkYIB4flz5uRGPDsLaxOImDlFXMK4r3YmbXNK6
	VSTNogQhiTdLkywVcfn7lvTBCb5lcQwUvS7GT9tGqnofz/9r95QjhDZfMZtXbfTK1ssvOXhzl14
	7XG4Lg/sE0r/i6TmnaVKGwElXz0yPv7keab09B/o2Aco4j9Qj7eXp+xI5SkLwIph0P3XRBNIplW
	GL1k7WCRq1KQRO7Im0EMGRNRoj1nYwr1LWeFypOq04XDcuZh7J0oC1vGJmWHPAo7/PrK4scKWah
	St7FFunmkbyxRbK+XKwxraXSJCei3/4iuxArWxOLqDb2gyKBhj7v5EqN5EfX0z9ZxIuVgAg4wFX
	6WpDpeVr8
X-Received: by 2002:a05:600d:8221:b0:46f:aa02:98b2 with SMTP id 5b1f17b1804b1-46faa02ed74mr10646605e9.19.1759911494573;
        Wed, 08 Oct 2025 01:18:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnk/Uz45vHv0Js/TEnqVijah4F9gyUTG/QIQ/MO0GiLdnBWej945AxIiLU6GGin5Yz5QFb0w==
X-Received: by 2002:a05:600d:8221:b0:46f:aa02:98b2 with SMTP id 5b1f17b1804b1-46faa02ed74mr10646415e9.19.1759911494097;
        Wed, 08 Oct 2025 01:18:14 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9c162f0sm26588105e9.9.2025.10.08.01.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:18:13 -0700 (PDT)
Message-ID: <3c572565-0b21-4136-b0e0-59a5ed858104@redhat.com>
Date: Wed, 8 Oct 2025 10:18:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251008032657.72406-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251008032657.72406-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0u7o7HUgUf-3yDrHc2FneOB8_EQZ7VgybLWxp7KWhvw_1759911495
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 95562A000D
X-Stat-Signature: biqsfycbuzat5wrtqgsckm8kjqux8xgm
X-Rspam-User: 
X-HE-Tag: 1759911497-873144
X-HE-Meta: U2FsdGVkX1/0UWiJpq392g6NxjSsK6tnFmuEwHQDmeiLAuwNNDBrko8KmUBHLl/PIljOKfqrdIww6e6C1yvuUcYrGKxtX4zngSHXUsJSD8k1mJl4TBQ2J5W+XSM4BtIvrbhvioz8UGzAQ3R0jdGGRRg+xY+wzRHa1lk3/P/A3+1I+FBZ/NkuMFTc1dbY9u6hXcaZ/2EjLISHJApMovrzpqpoTKLhKviDSNP5aacfw6T6g9jD7b0VNq+vBMa+PTmYRIFP+rZDWG30UdbUVtUmfv5cwz5Sxll+lJeIyPOECXrm9z3NqhbE65PmwrAe68nJp2V4LCbu+ea5z7k6+q17pZSkrOgig8uQIJyHhQvYGCkDGF1DtLZT/7gSTOUC3TccoK2NH/0wbIPKNhkn697JwUFhCmrtNPgBA6JkayrExFiZM98swweYEbh95Pct35oJ54jgPLE84FQJp3zKqNJYmmXGGDS6Khk4rKx2w99WJIuhTKtCt8QCqt0MSft4O9wPgbrJiurXMIpN7TwJ/jaUg7ryiJRJcFIj1wFHLGHzfpaMe9U+OGM4T/ork/wBPA0rDBiLBIppEcPf8mpQDmxvDpXu9Jwfd0cJRPzx1DCxGmeCp4rN+JoNo+SpXmYChUj9pYSGxFcbNMJrGb9D8mu8u4K0EOQUoVzS4ZgJOHeyg79ZONQD5UtXzC+WPk9aWuu8KHq8gRaxHSkXO9JTt2xRKffbnnzz7vKs7CP3fw9v5CF/Ijd4qicfxbNnOqsva/KnX8yYSjKCl9uzIrGDJP01HVxr5zN0gWneRswBX//jY0HM2RyVhbG/YYTMNbv8TlB68maEkmh/82LyWMR/gAx3lErK92zEXUZn4dNfb0MaY75L8LWzX3j/wYgnfUqWXb9ZRHqaBN79llTxViU1hEQK3Yi5K/TeQxA32wZOCdSXIkn7OvaZivJIz6iZbCZJHnGmvSWWwrHPPEAMmCP+QFi
 UiMGjVMH
 HQxf8e4sYQ6BB8kwK2JWqfzrdGMeFAkfD+2u/Uh3IZPdsJH46Vu9uzEKe75vs2YXM62n4xwLxWa/p9B5UjtS78UepYUhDYKv/cxUED58Koh/cpn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 05:26, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Currently, special non-swap entries (like PTE markers) are not caught
> early in hpage_collapse_scan_pmd(), leading to failures deep in the
> swap-in logic.
> 
> A function that is called __collapse_huge_page_swapin() and documented
> to "Bring missing pages in from swap" will handle other types as well.
> 
> As analyzed by David[1], we could have ended up with the following
> entry types right before do_swap_page():
> 
>    (1) Migration entries. We would have waited.
>        -> Maybe worth it to wait, maybe not. We suspect we don't stumble
>           into that frequently such that we don't care. We could always
>           unlock this separately later.
> 
>    (2) Device-exclusive entries. We would have converted to non-exclusive.
>        -> See make_device_exclusive(), we cannot tolerate PMD entries and
>           have to split them through FOLL_SPLIT_PMD. As popped up during
>           a recent discussion, collapsing here is actually
>           counter-productive, because the next conversion will PTE-map
>           it again.
>        -> Ok to not collapse.
> 
>    (3) Device-private entries. We would have migrated to RAM.
>        -> Device-private still does not support THPs, so collapsing right
>           now just means that the next device access would split the
>           folio again.
>        -> Ok to not collapse.
> 
>    (4) HWPoison entries
>        -> Cannot collapse
> 
>    (5) Markers
>        -> Cannot collapse
> 
> First, this patch adds an early check for these non-swap entries. If
> any one is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
> since we are in the swap pte branch.
> 
> Second, as Wei pointed out[3], we may have a chance to get a non-swap
> entry, since we will drop and re-acquire the mmap lock before
> __collapse_huge_page_swapin(). To handle this, we also add a
> non_swap_entry() check there.
> 
> Note that we can unlock later what we really need, and not account it
> towards max_swap_ptes.
> 
> [1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Sorry for not replying earlier to your other mail.

LGTM.

We can always handle migration entries later if this shows up to be a 
problem (this time, in a clean way ...) and not count them towards 
actual "swap" entries.

-- 
Cheers

David / dhildenb


