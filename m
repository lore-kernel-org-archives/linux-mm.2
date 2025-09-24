Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1042CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88F288E000A; Wed, 24 Sep 2025 06:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8186D8E0001; Wed, 24 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706CB8E000A; Wed, 24 Sep 2025 06:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB9D8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:10:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEBF1877FE
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:10:54 +0000 (UTC)
X-FDA: 83923725228.01.10592C2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 785D94000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:10:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cSXE0eJQ;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiCQ8BU0umsCk09KhhxkGDVC5GBSrUKugfQ68xhIVCM=;
	b=KjnKpmUH5nCrS+WWIIB1C7jZvUBMWRNpECGLcA8kaZLuJFWxrJ/Y/AvGBcq3Ma4LgRn7P1
	rwiyiFYwfaWV4DHCWvO+499zLep17doy7F4MOQtZUPWek6fNufqpS8UbrST1u+CrQ13tPY
	4n+0iYI42urdz1nxmdqAQTg7qTRJhac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708652; a=rsa-sha256;
	cv=none;
	b=F5cQgWNk46/S+iwJBLWpK08gsAR3qr0j7QwiL0sWldYFjjLbVC0KWbEImaI344ljRO8u8T
	DWQA4SWJROpqNcKNo819lvGvOJEQ0JIV1swNhKOFVpfE18fKYGhM/h8OOfgkGt50UdNoHo
	C9lnJ0vHORGO7ze2VoOcd3eVghWzk58=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cSXE0eJQ;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758708651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=xiCQ8BU0umsCk09KhhxkGDVC5GBSrUKugfQ68xhIVCM=;
	b=cSXE0eJQ2jgDZuGDQTMVkVwZuMxcmye+uVUcPNgKWrt4cjD0j4sbqDDWoGfC6H2z4ZZyqz
	lUGRciuJsAC2W3OdUGGK6MwKi2GGbGytLu0h0ldxPlivfKeYpLUZSUyt8fNKyEBMMjxYkc
	ADgAJm3fJwEwWWzHJ/FS9UxLlBTjwng=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-dvP-0VvMMNyWCnC92is7Ug-1; Wed, 24 Sep 2025 06:10:50 -0400
X-MC-Unique: dvP-0VvMMNyWCnC92is7Ug-1
X-Mimecast-MFC-AGG-ID: dvP-0VvMMNyWCnC92is7Ug_1758708649
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3f030846a41so3012255f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:10:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758708649; x=1759313449;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xiCQ8BU0umsCk09KhhxkGDVC5GBSrUKugfQ68xhIVCM=;
        b=WFMyj+Hs1IeS/i/yRaBI2SfiZSWETMuJyY8ZCuUUYDMWzOY+Yq3ZCj6r6l8b4WgYqr
         bGCz8b67+lMdwdfMg9aOZ9wF8s4LTatvFsR+reRVkt73rkfjKqhohj+ZvOptMAJzEyX1
         91IpP3SooEi6rHnMMpZPQMZsgXywVT5k6IHb3vs4O0rXaNXTjSY7dhNisKPEGv4bxguT
         2w4k8uVTtpETiegO/eCTgbjwsKwuYR2Ce3HBmSdewvIhSfn1FJz4GBXkaNLKxiPCm8vD
         5YBQOuVmAqh+hyYWNtMx/a2xeSC0l15zCcc1ZuMBnC1b8aBcNaipXhEqbq93a94X1bB8
         jIGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxhB39/MP/xwNrQe76tnsIJiXFND51bwYuILLNOQUTfG8NylMF55cx0xitMu+8Y2q3SYZgYbAkeQ==@kvack.org
X-Gm-Message-State: AOJu0YwjAYCwJINS3AkfHqa/Fi8O5wa0Zqj5Q8HaSo6jjPRjTKB99Uet
	O+780jqKb2gurtDV3/HUdCs3EvYo2TQ3AnoCGT93S3xoIwOHDadndQynExYwnwbII+bmpY85AZ6
	sDNn1dVdlrNykfbYhB8BegV1EfzCDmKaOOXcMk/+SdS9+5YrL3gTE
X-Gm-Gg: ASbGncuhzP2fwC8dys2JmVBH5atrwScfp818aPtUg3kTZgIhMSh0Cfglr/e5rmDnj7V
	OuoViuFj5zeTHCQrpPrGtlw05jpLI9ykLhLdfDDi2TdRMxjgkSsa7clplNrxF4Vi/MmYlKU3LHO
	vOsX6Epm+XNrtO2z6pqvlhq0m9SnZ2gL29NrPvg76/7paoaNGj89txS1L4XxA66x2YFChc4hU7p
	Q24vZQfWp21bF9cUpnY4eN6DWG7AZYnEyBuLCuvWguD5RgAQu/yJVSBD5BkwOpLiV8w9UCruktm
	MfAKkjK/MqkIfju+BXaKYx/BKq6X5rAMVC933ggkKyUF4bYgYzLIyEHS3bbdbQrdXbqgTQ9x2QI
	Yz8eFLjdqjiFsmHr/5uBfMWyHQgk8+R64opnEXb1AaRhmeB+Sl3YcUujpi4+3yzGyAQ==
X-Received: by 2002:a5d:64e8:0:b0:3eb:4681:acbc with SMTP id ffacd0b85a97d-405c523c244mr4992813f8f.23.1758708649504;
        Wed, 24 Sep 2025 03:10:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIeauiTh4AAMLabIhLe4f2o8VtghIpe344vFSC4Y6rzc2lojFu9KZ5/l8ek2CRup7aJ2viPA==
X-Received: by 2002:a5d:64e8:0:b0:3eb:4681:acbc with SMTP id ffacd0b85a97d-405c523c244mr4992790f8f.23.1758708649098;
        Wed, 24 Sep 2025 03:10:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40c5c156a48sm1447555f8f.48.2025.09.24.03.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 03:10:48 -0700 (PDT)
Message-ID: <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
Date: Wed, 24 Sep 2025 12:10:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap
 entries
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20250924100207.28332-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924100207.28332-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uOMUTexBpiJke0heBlLC8s7HY93vEOeEr7SmdPVgOUQ_1758708649
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 785D94000F
X-Stat-Signature: oegzuizork5mwtgmxcppcsc34nbind3u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758708652-714423
X-HE-Meta: U2FsdGVkX19A4T1AsJp4sNkXX9YkATVQQw5Vkxxji/b/3kckrmxtYant7KhzmC0V0GeKikxVU4lRyQa3GLXY9F4d5YbfUS9YNZAYfewCfw3wvATlyW33DuY05VOXGt46H9oo9EQR3sxqY1PpEfKH+X0Lal1LdZDd+pLN6GmRTtm+c8kYqkvIGdQRKNmhRNEofbi/HjwjLsw+iaJ0H61WGFDJL+8TnFF+jhy+NphJ3Ybo5qiZwiA0wmpa0PAemsndrTNGD5HFvf67d136Xb2u3HfPdKXTfEOMspTHAAx0IxTBAxj3EWuwV8saI+cr3dmnnRiEB4wGepk5PeBZMH30VbxFcuenjeNRGeWHpK8cZEmzOvcl1aYdCRt9tgwbZz9qPaCtasCMZjyxEZqJ6FFS/TfbsVpdG6lha2wRrhbDVrYT/kQzHUxNyx30n5hLLbFfN07ddLaBWZ3BRvIDHwC1vx6F05NQI96X/7GVgKEal1VFHv2GUFexAHV4WymJ/n8PkysIdstqWNSgouhWY/r3brLUY3V2fTRijPRgXhOvaxPP1Cnw1Ap7kdV4E4NFRo4861GMxSoFK6BB0ux9Z7q+mkIx7A1oEOXRfMVjZMb1jrsX7vbyvQekCNr3MguPqNoRLHtn25hz0BY4Ki8s3yevYd9cuZ9Q6Ytn4dPE4QUA1dvQ/Zs41y0CZ+C5jlshJ8PS1RURIG+OHPxomTqZvksYIXsSm+xzkJUoeZ6b7V3G8a0UECzFOuELPRvqipixPzDp10IiNpru6Cuv3W1ma29qkIJ1JiGdg9fcktbILXLSrBVfJIhJcU1YgirO1bKMGXjk8Yn/rhRGkVlcZgYQbyIheH+CqrbIUweGu1n5Ucp/HwsGmtRzf+jwLKvO8lx2L3WTOcXhf8bP8REH8fPjpbBpA7uRZAV9Wp6MPKqXZiO1yFlcPLTZRUxoCQmyhjb1FR9c9seQZeEiX8FGb4WYIoS
 q1FMmvg4
 wxbyNA120Tt1qPfj40ep2/pHu2ZWSkONy0Opl8vCKMP4UPClQJ/mC3Ea3NrLIlQOkiW1z/2Cz+jqx4GFIDFXpxa6ii9p++2oIWxyzEE/cfmYoyKCg1EVn38D8BZR5J4qylqFA8ThC6ltCv6Ju15Y/wvjJTuKN27pVxzz8pWJdljma0RDrh1SSVJqREAReKYTi+mAjIqWVrOgpqMRA+aFtiURrvFa0TDrWHnIqY3uWbKGccW2qChuT18RTfLysB3jhYR9UvyMZZeoO9MHXkGat0E3qimWg+tpPYCEznyW4Mae60rRbHsf2FlxLleode0ylWBz5V2MBw+Yg1i5Rdc0m7qaZTrQT7YyPYqqoHKXHol42gXjXimegZzeFCSj9SBJI5lNpg82a3/J5pWelgsTlrJslr/K868iPli9//4ULecxhLcsbb3NJZ7cBCt29PV7VxFFjWotV7K1B1fin8JmRORXtbw6zj/uzau0Yf6m9UNSfi3OHX5MaOMoMIbtclT+AO4XN6eJBfi9ZTgK1tkmMTcAjQjdRqwB98MBAjpAiIbxntU8Bjgbj/6esUgzZJNWMQKuitU/QXVc6mPXH7HZ95IHseg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 12:02, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
> markers. Other special markers (e.g., GUARD, POISONED) would not be caught
> early, leading to failures deeper in the swap-in logic.
> 
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
> 
> As David suggested[1], this patch skips any such non-swap entries early.
> If a special marker is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work.

Note that I suggested to skip all non-present entries except swap 
entries, which includes migration entries, hwpoisoned entries etc.

-- 
Cheers

David / dhildenb


