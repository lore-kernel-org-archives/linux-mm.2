Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758BDC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830236B0088; Mon, 14 Sep 2026 13:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E1346B008C; Mon, 14 Sep 2026 13:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7F06B0095; Mon, 14 Sep 2026 13:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C80D6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:03:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 695631201C1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:03:06 +0000 (UTC)
X-FDA: 85212987972.06.7111BD5
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id 49E37C0009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:03:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enkSHAHX;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789405384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kiXS9rBNSo2wTNrsiYMKi3HRNXfyiTJkObuItuJbkY=;
	b=3+8jUaMsPn/Z9Eu0dnshaLu3F5qCd+vl/n3nr3BgrKXOV8LPV3y/OnwjFHi+vrIFQOXQmw
	pbGW+b2iRAwAN6mHZfEhTcAy1JDQYa9vOrMXqEXV6xDMzv7tHnDFkZdKECATwc/Hvm1HqR
	XElIq5j4U7GGdPKvlfjaRtHzXvjKgN0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789405384;
	b=yub9AoZ8OJhbEpiAE3m45j3+IVFUjSTXcOg6ZAEypQ8ARZNssphasDXaG8bB0Iq/ro/tNE
	JJpJSL/qW++mND7y1wexExqmYHhgR4GkpzLYB1HGOd7CiaKxZR8zcAmeHJSWMkzDAEUqQz
	Ya06ivLmUj1klqvJwAagOI9NK/MFuVg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enkSHAHX;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9c4c3e3b2so2834282a12.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789405383; x=1790010183; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7kiXS9rBNSo2wTNrsiYMKi3HRNXfyiTJkObuItuJbkY=;
        b=enkSHAHX3GUtkGmgruCqNFOhozBIRwR35cJvCwIedYWP6xmTFYd3IfcXcGQ3hfms47
         KlxVn6OLLz0J06to0kIf9X94nIMeq8BynY4NPx8ylyzBPofACfUY9pIYgv0KYDIOo8xh
         OVWqScYamNSvcPQgTffQhHx1JCoTREQFqCfR1v0P0hncugZY3kHY3H4h2XoOeWhLCs8Q
         FDqwwZJ+b1Bn7MaZij+BkoS8sieGXrW/AfjKOVG5iRnyBoOH31j38/M3S6lHCVgBOpLe
         Zu6XKz3BcQLwkHanuz7ywvXAQsg/eVAp9Om5MU2sNJuVlv8tENXAUC28QJuUk//6VDfP
         0WEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789405383; x=1790010183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7kiXS9rBNSo2wTNrsiYMKi3HRNXfyiTJkObuItuJbkY=;
        b=aEso8bb/JnOjL0yuXZY2Ta/u50F8rbNcbhEya47yTKLfPygpcTgJcL8216AyW75RWv
         6cydZa2t0tcqx1MVAB68TQFglqFIpNwYPIaEVp5a3Tkg3ZaLp3WHkZBzfZJSL/Q+cdyr
         QEz+JASQUCCId816K2q46N+FtD49Fh2lNDSyAG2Xn8jwDKkD3zKce+H/GVSPabySV1kn
         yfmuNycXWw11bYCHUnp51FyEn0WAsw2I9dqmaERe7jCupindOMo64YqkietFru514Rvl
         CCqa9Caz1V/t1ryAhYDUcsozItLirRfRbiooeBunro7AeisT4SsBqdzT+EFnRq02BTgF
         aWOg==
X-Forwarded-Encrypted: i=1; AKwUvBwJtROr/D7SkdJLowzJ57xYrguG65w9j6Yw+Lp7qfvpCknNJTgo8arfrjnWb8XoaLYOoHQMZx+c4g==@kvack.org
X-Gm-Message-State: AFuF++mnAOc7q75Wd9NsdfEBzk6BbPLFX9xTTx532zYEu1Z2c5oIXGPG
	ytEDOc4XlIV/tSIhke8pg6HTReLUCAp9YJhdpru9QNQEypf5e4VvwAkH
X-Gm-Gg: AYBFou2RFKgvfBNmWJHkzBIqOEG7z0wsSxGXusaO1HTeZhyOMihiZvHt6ZPi+FvOVLj
	rOMWlG4jIYYkON5NrcXXFRJ+6S1QBPD/PGPmVE2yoANOAGXryJ3Xx0qPJzY9i6O/oP0nUJZkrSo
	GcYXwqXtb69qyl2dPnhKqNRUrcQbrINDIdtMTKwNHx1N7MZ1JY/OybE0iYpvh6rKocYFJjTii8E
	sPRzWUyD5G3zOYFdfUMeDFv5Erv5v/Zff1NqmqBqmStSaPmoruX8qfuRdwYqXGnwXwPoYHHXTYZ
	TSBi+rfKn9ezewgB9q9fLrLRKPTEUGZ6l3rubXwrewKeGtz1X1P6s+cgezBqF5TiHu07B8PNEak
	tfX+d9Zg5FbTV5pNP0XOcZw75UC93V2jMlFPQXhZrek2+xI5OD/4epWcpKnFckYUJdeWJpl6FuR
	HmMxyueBc8zae28prxmK494akkeAQDbPbPcIOr
X-Received: by 2002:a05:6402:400b:b0:6a3:e813:8457 with SMTP id 4fb4d7f45d1cf-6a9f6256adfmr5299859a12.12.1789405382771;
        Mon, 14 Sep 2026 10:03:02 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9d0ef7228sm2946016a12.9.2026.09.14.10.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 10:03:01 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 14 Sep 2026 19:02:59 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH 2/3] mm/vmalloc: extract vmap_insert_free_area helper
Message-ID: <aqgow3u0GSlj0P1Y@milan>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
 <20260914-vmalloc_study-v1-2-526f68559706@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-vmalloc_study-v1-2-526f68559706@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49E37C0009
X-Stat-Signature: fa6wm8bi61nd1coys46kuzsfhznzb3cx
X-Rspam-User: 
X-HE-Tag: 1789405384-836289
X-HE-Meta: U2FsdGVkX1/GK6h9iBlDRQLBtct7hBmC9MC1Q6BdpOk0OhwaW8icxi8cetMYNO1J6hV7pHhS/KopxLY2drfTdXihWm08yKGguAFlFmhrbvyFMGHDCSv4xC4NJV2LZZKx6T6pMjqRPwAOrdov7trL/6g62pqen3bUYSdAAgop/Qa6wocnjlSWgWx6mwREiaBFOa7qK7mw9ZgKJThll/V0kEauZ0hu0ctcOo9IK/AIMWMgbu9J6HB1bjtM81op1dEBFH5X5wa1UIxLHy+HQnwV0iHdKviD1MoSqMyXxWt6DVPqAxuip5TdUofE6X5RPA6gYBKNiWHQhyTT9Iv8TOClSRgqlpxnE1kygEgPVG5kRKmw4PvIYKAVk93of1P/PpVf3yDy/8C3i6tNSwOAMxC8+RyHpWtr/b4XqynCPWyTit+3xAcwCbZroegYfCVzyNhaUG9B1MTqTimH1cdoLkR3XUUv3QKJNxI64qGiLUh56IaJX8IeKSVNnxAiUdTc8eyQ+Vi/kKerfV1oBRsm0cSFilMNdTMoJyZo8eWr/7NYgHmd/1WI3Ar82j41xh4iBtpr21zFjOK+JpgBID/0KbjOsxEQw7iAiQQ7zFZbmRIuvu1hO5cWx1do24c1uoU2cYyI8HSM3Cd1BsE5SB9sH4GhlwNtjxoB45IDFAZfygJiahnFau0JLv4H30D6v88y0bTUGiM62DnMSCXTlYRNGiBMDcj553aNASCgKLKO1f0qiIS1vAHeAeGT+8lmTEdGxjU5wSfn5/ptgw+SYut5laR4qhObiDZwCCzts1KRR3d6eGgN8rA9lBCqObZO9UkxVkr4qJlYDgCEkPfOn3six8lTHKUYK9/6UUp+fVc26E6oXIEN1wsEsGf7yUZjs2xBm64OxVhCXYL6cHuhO2qypVON49Eyaayk92qbv3ulpI38Hjip+vQ0a2zKMOiF8do6weu7edSUhD0U0Bl7/oxiTOn
 5NF2fBbW
 Q6Dyyb51z+VQFaJqyWTJ2dtv83aRwE5+LKsFPGW6mH607+ikE+hReLMX2hDQCdoSe/SfuHZGZDAgL81U8LyOcSm0xec1qFutNTXyXmCfov3KBawDrkrenL6ac3G+lELsd8V1Flxr2A5UO/2mYWXmBPOAEJM7275djsmiOmZSWjcsyHc6oKJDEhFv1yLawdrYHk2fvHNBByJ1yi1F9iJ6av1Ye5Pzry+mmB9pVZLTjHmSoy2MSaG6VG5bMZDuY9OHIpfCTSmKZxaJRM9WHGAsdIjO0a8e4G/auTHbbgVHbRADgukKC+tOWLsIlBA1ZZKuGXfZ9/sLyLTFCVypmAdB0NzBO+DF2sFk0mPLDCf9a1lTKlFJ5fL2aPg6EPeEvTe+bl73GYAzqXpU2QSB27aSG4SaDgbS59NchBgnJpoiQZ0n7ZslWykSsCG2t2PqBUyuiyY/NsMUHNbRzbVBaybiMYf3O6yr9khWUQRnGBDeYYxJlWuY3870oH091+TwQ2dCsAdaj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:34:01AM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The allocation and insertion of a free vmap_area is duplicated
> between the loop body and the tail of vmap_init_free_space.  Factor
> it into a small helper so the main function only deals with computing
> the free gaps between busy regions.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 41 ++++++++++++++++++-----------------------
>  1 file changed, 18 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 117483dd048c..797933ba9451 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5433,11 +5433,23 @@ module_init(proc_vmalloc_init);
>  
>  #endif
>  
> +static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
> +{
> +	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
> +
> +	if (!WARN_ON_ONCE(!free)) {
> +		free->va_start = start;
> +		free->va_end = end;
> +		insert_vmap_area_augment(free, NULL,
> +					 &free_vmap_area_root,
> +					 &free_vmap_area_list);
> +	}
> +}
> +
>  static void __init vmap_init_free_space(void)
>  {
>  	unsigned long vmap_start = 1;
>  	const unsigned long vmap_end = ULONG_MAX;
> -	struct vmap_area *free;
>  	struct vm_struct *busy;
>  
>  	/*
> @@ -5447,32 +5459,15 @@ static void __init vmap_init_free_space(void)
>  	 *  |<--------------------------------->|
>  	 */
>  	for (busy = vmlist; busy; busy = busy->next) {
> -		if ((unsigned long) busy->addr - vmap_start > 0) {
>
This line gets removed and then re-added below because of removing space
after (unsigned long). Maybe it is better to keep that space.

> -			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
> -			if (!WARN_ON_ONCE(!free)) {
> -				free->va_start = vmap_start;
> -				free->va_end = (unsigned long) busy->addr;
> -
> -				insert_vmap_area_augment(free, NULL,
> -					&free_vmap_area_root,
> -						&free_vmap_area_list);
> -			}
> -		}
> +		if ((unsigned long)busy->addr - vmap_start > 0)
> +			vmap_insert_free_area(vmap_start,
> +					      (unsigned long)busy->addr);
>  
>  		vmap_start = (unsigned long) busy->addr + busy->size;
>  	}
>  
> -	if (vmap_end - vmap_start > 0) {
> -		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
> -		if (!WARN_ON_ONCE(!free)) {
> -			free->va_start = vmap_start;
> -			free->va_end = vmap_end;
> -
> -			insert_vmap_area_augment(free, NULL,
> -				&free_vmap_area_root,
> -					&free_vmap_area_list);
> -		}
> -	}
> +	if (vmap_end - vmap_start > 0)
> +		vmap_insert_free_area(vmap_start, vmap_end);
>  }
>  
>  static void vmap_init_nodes(void)
> 
> -- 
> 2.25.1
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

