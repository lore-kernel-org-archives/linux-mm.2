Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C81CCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830338E000B; Mon, 22 Sep 2025 04:15:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807808E0001; Mon, 22 Sep 2025 04:15:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6618E000B; Mon, 22 Sep 2025 04:15:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 591158E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:15:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A22CC0540
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:15:18 +0000 (UTC)
X-FDA: 83916176316.18.892F405
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86CEF1C000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:15:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tpic6bCX;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758528915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4bziSJL9UR/Qm6TyxCwaAd6httEA1G3wcOzxZ9HxEk=;
	b=UVkSX/j06V7+haa+QWjm40TeBRGF2VS+IvJoP9eBCP5v5Rkbh3Rn0SmHdP0ZforDS+etN9
	f/eGBbbmwgIIWbfd7WxIDfXu7bMP7CoE4Lqda0sAAU2svBSq5rRT3R7BliUcC/waeLRAGX
	zh5rTkziOrlm0dYRWEFro7pxQEA7rJE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758528915; a=rsa-sha256;
	cv=none;
	b=pJVUSZknT2EdTZtpZvxaxl0RKEK3eiqGjVGRU13rsghFZMTkEomkGR3OFBabHC47BZfOpf
	C3e2DYly3ZT0JBe2Te8QzYIGWSE1jObev/2m/HvC7vkh0nGlhwm65LPQYSSsN0KL97IYxn
	89XHE9ogP1PifT9Kt2PGo9vcfHNZFl8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tpic6bCX;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758528914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=y4bziSJL9UR/Qm6TyxCwaAd6httEA1G3wcOzxZ9HxEk=;
	b=Tpic6bCXy0wlOWgPj+zEV+jv7nY01tj+qtWJo0QT/CTA14mkuUk1cPTqjDgl15WPl5kujt
	yuJyrSikGkw/NLQVwWZl6/jJRFqoNy1uY6C8SmD5J6KaWNyUiDQR/e3bg7NIuVxqegx3NM
	C5rSvoMvpHmpIyZTn9wQ+5FFt7vGghk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-351-DQLRx8gpN3qWxDo9nphtmw-1; Mon, 22 Sep 2025 04:15:13 -0400
X-MC-Unique: DQLRx8gpN3qWxDo9nphtmw-1
X-Mimecast-MFC-AGG-ID: DQLRx8gpN3qWxDo9nphtmw_1758528912
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de5fdda1aso20377685e9.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:15:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758528912; x=1759133712;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y4bziSJL9UR/Qm6TyxCwaAd6httEA1G3wcOzxZ9HxEk=;
        b=OYBO0ju5JquahMVsHsXiiKu2tB8pqukgRPeIxMGJdn6n+cvChfhPIa2JyQS/T+08tu
         zbd1LvCo3sfOc4Tsmi8E6zGMt6cRCdUOS2d3fupzfGCXxaebcO9k8SuoDjsQynQrIziM
         YsKXlVTZBBd423rt8+GAHDtr35GJWTwRojqjBZoRXSryD9va6cY1vTkpjRFWVbb7MQr5
         P4k3Te9YDRGZnQJPPQ7+chOUCMsUKS2GCiwom74imtmIUgkqdyYAsEXx+mdUiy7OUwlh
         kn9T2bl1GDX369frAwMo4Sz7/a0dFL7JzC4DP9999shd28fX6oyy8+uKK5SsP48+GbQX
         +vfg==
X-Forwarded-Encrypted: i=1; AJvYcCUh6+6jCTnhnhl6zEGbMFN6UBIkQ9gn/Z5ahLaCIJ7ez6E+MOS8+8Y65JFtmmS6rDj1UXE9D9wHkw==@kvack.org
X-Gm-Message-State: AOJu0YzwtswD2B3jzbJ7r0MBdHVSG//BkCTGCI3cP+nta4IUAgFTOSix
	phr5J6yROx4LhX8fX5dGswOYcsn1T9rRwZQqPWJe0jNGuSoR1/dP9ohQ0gzCbHR7JUeGGAKOCVo
	D0iwkBCwMQJQ2LbinO0fr19O7yNH3fqffDog25Dumnp0AM2a/divd
X-Gm-Gg: ASbGncvDyk33r9CR8Ht/8ucuP6R2ove7yHAG/RcCOxGLRJwTu9YKF82znOhzEn3EOg/
	/5glxOVQnLXDkNGeWdmD3HWR7EKpQa7a1lN6KhNSmHxN/O024rl6462F8keScJnZ2R4l8pbcZkZ
	dKA9lB8pSZjxOlsnJCAdyAuB7Hi6HYiYKc494fD0n7no2nsCY8q+AtkEyT66EA7tbwrjf3T0/Vc
	zMJGAkC/9SPF/yXWh/wD03o0b4Zyum+coRveQLS4qgyOs7fRLIsLoI9ZwoE8aIh2XXhFJ8atmMB
	5nEaSspNnpsGEp76J/0fd/+Pp9C2YB5KYxyd6MbiT6aia0Hauh30OsS8D+B9Cl7zJ5ggv3nKBny
	nKhQCZLVItDim971MKrBF2AI7k4iImaOzfIMQ/Xy3LMavMcN8FODhV4feowHLISA=
X-Received: by 2002:a05:600c:45c9:b0:45f:286e:49a8 with SMTP id 5b1f17b1804b1-467eaa88162mr121467315e9.30.1758528912093;
        Mon, 22 Sep 2025 01:15:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENAOUSzL/l8cJci7x47KhzFNMFxxaLQqca9eiUHlRz0tCsa6t/rZmY1rYxxG86TEOI2EXtEA==
X-Received: by 2002:a05:600c:45c9:b0:45f:286e:49a8 with SMTP id 5b1f17b1804b1-467eaa88162mr121466795e9.30.1758528911668;
        Mon, 22 Sep 2025 01:15:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee074121b2sm18833236f8f.27.2025.09.22.01.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:15:11 -0700 (PDT)
Message-ID: <91041fd5-ca37-4a6f-981c-74aa92bb2291@redhat.com>
Date: Mon, 22 Sep 2025 10:15:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] ARM: memory-failure: not select RAS and
 MEMORY_ISOLATION
To: Xie Yuanbin <xieyuanbin1@huawei.com>, linux@armlinux.org.uk,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
 rmk+kernel@armlinux.org.uk, ardb@kernel.org, nathan@kernel.org,
 ebiggers@kernel.org, arnd@arndb.de, rostedt@goodmis.org, kees@kernel.org,
 dave@vasilevsky.ca, peterz@infradead.org, Minchan Kim <minchan@kernel.org>
Cc: will@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, liaohua4@huawei.com,
 lilinjie8@huawei.com
References: <20250922021453.3939-1-xieyuanbin1@huawei.com>
 <20250922021453.3939-2-xieyuanbin1@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250922021453.3939-2-xieyuanbin1@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 25ZG5w0clFl96ZRw2UV_vAvAXX_-dEbcVJj5w7KAB90_1758528912
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mctwfd7pdbnu7fs39nwb1x5h6ff7ztdh
X-Rspam-User: 
X-Rspamd-Queue-Id: 86CEF1C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758528915-767689
X-HE-Meta: U2FsdGVkX19Sz/wWaxjUbuaoGG6c7lcFlsclllbp9XwEzhJ8G2QMA9/SMA2Z42lLzavGDfBhBZ48VHllYWAdqjDnGQF2ALd94634aep9VOMxRyNcWYcA+RpySAT88ekTvkm+mez+H8zW4x5hAOxF/xjND5cmXIvxa5eMRklWLHIRkSnxEma8k7oGmgZ2OtJhIe7diBYXoWI7jtLAenvxy9xffM3x2rtihZezWahnkAx67qLI3Dbn93I9ibw47Vo7dcD/Kh4UvY85GOxckFTmwhkGnM6qJnxQB+bZTFxcivL1VwRS/67DKSpBjMgeaTXd/T0FSa/22sSHgFL2IfhnLtH0kqpfrZNE17Wx7PfA+mTtGOlF5vJcJ3qAJZ/Z1bymOJIanRiKtx6ifS48cgQeb/C48Cvici3ghrff4DsklufeM3nFVDEFNGXfuAJsQh28LjRbOjo8hqfWFeB6QETSjorfQIR347xem22Dm3ArGaWabW8ZkkPuL3oc3lAPwLM59o6sTxyGj14iYRmZCLGHXSUB0tqA9TvCGNzniTbizrOlC0n/u0mkrrzzfStWdlXO6vb3aAY0P+SEsDLxIkiM5Lt8BeMCmZ2w2YXC7ZhzgfeoWVqU14JDjhnHVuAEmH2wsFajeeILMFIdhYLkdeWb9PwnUOTwJupeYYQhtMBQwVL2FW/Enu2L1s4C6htdtZ1bDNbI8WHbA8rXwz2ruQctlyShCnF4FMamX/LywbQQmt7/940sYMIoB7Zen2rgBCfNsjCWW0Ce7lAc/utdt5GMY3hukyzEVPWEYF2cl1bLkKPsY/X9LP6SBKnDImP/yIWR7Z1epzng30GAi5r3Mgzey0FyosjVqmnKcLDuxuiMveAfj4OE7Bw8AS8gKYH3pjo8sQcfBFxb3SCEELFAWTXavlId/VAeWUrRb10xtnX0Qi7P30U2jSuAtJAOEj4yo2LpOhLFXL4OtBcARzY/rVG
 AdQo6zCU
 wItMJ/TtW7At5qJL15mOppYJLncuO3/owdvWt39UQZWWHcRp0Lz32awbqffKwYnvMKp7g5OHlnHnbKuh69JMXLLzsjkLH0Ecdj8RdZEZazf1r8+EyGtQgSaiqWT9Sq72oChbU0TnXQKaujd282gwkv7/XjoggN0jhEKXiwcjN7qYBaeLhgx6EW0uzhBy6+ZPGl/8jjktM4vrzVKb0bzSneJhUR+VuFrMrXXy9UhsPwX11GZ0AccTAW+0wN6+05xD9iHhHnDgHzemBSqTXRJaUaz1nXENdYbIQjOEEDVX4tgpsIsrsKwbmx6GcKS3gf/pz0Ll9k4ixp1jRn3djBU8l57WdhXwsABB58dXCajewTopYEOvxqYnM7XYpXMXoUtdLlGWFAniZmhQ+VJT6+dGHWOZW2Wi+dCmrblL5b2PhxrAYq5mLpa4MY2RzaQcxWMEM+jyatIiApaWhHPo4tBcEY05xK3LwzCxHEnm5AT83ljrMy5PGyVX3UU/WMxKSC1HlhQlj8aVn3n8UJ4M+lei/lLvPdGc+GMeuF/DQgqaYJhFOeMUhtRHQw6xseXTgTuvBNcj5seE/Gif2lBm0XTU0npdZBdHCT8BE4vCKcw1mYet7bY1NZzCFE5Ktog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 04:14, Xie Yuanbin wrote:
> For memory-failure on ARM, these features do not seem necessary.
> 
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>   mm/Kconfig          | 4 ++--
>   mm/memory-failure.c | 2 ++
>   2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 034a1662d8c1..22eefc4747d5 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -742,22 +742,22 @@ config DEFAULT_MMAP_MIN_ADDR
>   	  This value can be changed after boot using the
>   	  /proc/sys/vm/mmap_min_addr tunable.
>   
>   config ARCH_SUPPORTS_MEMORY_FAILURE
>   	bool
>   
>   config MEMORY_FAILURE
>   	depends on MMU
>   	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>   	bool "Enable recovery from hardware memory errors"
> -	select MEMORY_ISOLATION
> -	select RAS
> +	select MEMORY_ISOLATION if !ARM
> +	select RAS if !ARM

I'm trying to figure out why we need MEMORY_ISOLATION at all.

MEMORY_ISOLATION is mostly required for memory offlining and 
alloc_contig_range()/cma -- it controls the availability of the 
"isolate" bit in the pageblock.

What CONFIG_MEMORY_FAILURE soft-offline support wants is migrate_pages() 
support. But that comes with CONFIG_MIGRATION.

And isolate_folio_to_list() has nothing to do with CONFIG_MEMORY_ISOLATION.

We added that "select MEMORY_ISOLATION" in commit ee6f509c3274 ("mm: 
factor out memory isolate functions").

Turns out we remove the need for that in add05cecef80 ("mm: 
soft-offline: don't free target page in successful page migration") 
where we removed the calls to set_migratetype_isolate() etc.

Can you send a patch to remove the "select MEMORY_ISOLATION" independent 
of any arm changes?

-- 
Cheers

David / dhildenb


