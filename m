Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67142CED24B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:35:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C395F6B0032; Tue, 18 Nov 2025 04:35:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9F26B0096; Tue, 18 Nov 2025 04:35:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD89F6B00A4; Tue, 18 Nov 2025 04:35:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD3F6B0032
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:35:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B7C7891AB
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:35:36 +0000 (UTC)
X-FDA: 84123220272.06.C77FB62
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6205C180008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:35:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWhWi4tX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458534; a=rsa-sha256;
	cv=none;
	b=eQzzvx2w8TXsIdGKn3IWCtNCGnwaEvXE5fbmGmI/FFr5ZkH0T1/54fK7QSpVJeZAkebTk8
	ZovCdZOvzBPKdAPvTJ41IYnyKyxtcaVYwhBD4MFOGJVgdsw0lVTKgpfLmqY0ckf2u2uQKZ
	8KDgcJy/zEdgVAOpJ/4UMKHmV2BiGhk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cWhWi4tX;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmkM6Odc/QB0X+c5pfn2PvbEetlpGWBu1Jlh7QaZPiU=;
	b=V9tkJeuV7mx8qRPgUeZWY8QNBaTL1o8DnuUzLLd/ZW7GLcebE1sLrZFr/NyOAo4JQ4hmWd
	qKuxoD5vCEb1WMQzMfQkfsJTD4NNbgbAsVK4FXenGA9Rt3BDW+laFyd1YYPVEQIF6ALlSw
	EAZOWCPeJoyvLfjDTTu2t5R6fzDAA5A=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59583505988so5830191e87.1
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458533; x=1764063333; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mmkM6Odc/QB0X+c5pfn2PvbEetlpGWBu1Jlh7QaZPiU=;
        b=cWhWi4tXjOU4F29wcLOGeRyA+6nDa4Enph5R4ALK9fcyom5HaSAK/eTB3d2TxjQr0m
         oRotT+lZbimLufIA34mgZ3EZHsJbu6n2YhRlOvrRNv/tDb9uOy8QMTxuNKhpbj5svcKU
         ve5heINdt0bFK9kzgezEUcMEvORFza7iTmaOc8/1fGclOdcc8GsJISMspu+gxWOQO4ex
         0hGWxR+bCg9n1pMCltLtvyky93B3bmuIKacdGYISSbFpgUvlL2rQI61sbP9bQLa/eDdE
         qpniWD1wuTQl8L81f1HClUa0LW2eZmZdKBDM7Gbcy8YTVcUWlCz26zuj5tFuGyduLqQI
         eu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458533; x=1764063333;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmkM6Odc/QB0X+c5pfn2PvbEetlpGWBu1Jlh7QaZPiU=;
        b=giFl+lAdKHVnGRar4L9IZXMmJEA+9A82Bdct0hirYu71TEASU2+5vj+MAYQlKPA4Ey
         rqyfN79e4+DZ79ZnxOTmfgC4EAv8OF/jECMmAiHnR09I5b/zZq6t15qcdOdsrvy3UXol
         hN1rCV9CrkxpzjwI37rA2t43zZ7vJmaSe80sFKCZvqrfv8m48H+NVKKJtNCpIXcZQHoo
         0wWD5RZrCFCAidOPXZPgoWtwjWGYvnY38ODvkPnNUfw2vU1/rWjmuP7DesFVXBTjfWQH
         QW/usyHxfzVuLm5GfDPNh08rvXNkJ0fUDWTzb10JOYpYmd3S/DYrcfzNiUpIKKp2eCAG
         6ABg==
X-Forwarded-Encrypted: i=1; AJvYcCUIK5/bmqLW9CIjUrT//RL0jc37Ko+PGi+Dofmh6lLIuVqPc+SB8W2VG6lz7eQLBnb3UkfJ22R98Q==@kvack.org
X-Gm-Message-State: AOJu0YzjQBVTslZqpI4EoW6vCyN78AlaaQQD0w9PC5F5qrDIhlSY+qZl
	B/KlyNCSIvvIsBsaumF8PfgAwX6cO+z5yslK5Q11gEML200slPPvAz/X
X-Gm-Gg: ASbGnctOgZ7GF2U2lxBrzyJ9+nxFPVOxzIAZtdw/SWjgW71AxGYnqOMhnk2CtzTUDJE
	PgF6KQuaGbpQYBWgh9fwxaHM+GpfNj2wzFfUdQRgI4ZLbSCtG+gPw4l+xZh/W1fhZaLc6GuMrM3
	iRg8kIjyT736HUmNzUxocz4cyCOlEhHsIPEnElN7uZHDc7g+z0xxmyJNPEHSm2jWrj67i/gl7lB
	jgHIvTbNWQOxBKotdVPBvIgLwKu3vnGXTSBauFAEugf+qfGgdyUwArPFM2mJu+m+m+H/ieCzqDk
	X9aEiXipP1zHyUx+RT7u75ye9vj9b+7aoSHEg2qbTjoOw1oQLW1bNbEG2XkI7XISjlHH36RttIc
	fl67m3Utoo1VopON9CCjmIu18Vvu/Q4G5hWs28/jS0yVtZooTrSj0fnfMS+iBqd4fMjGE3m4sE/
	nJTwL6QKmbnTGQAYYX+AwebBst0Lj/bo5WEJxPFXxH
X-Google-Smtp-Source: AGHT+IHAyixml+9d00pn03L9D9JQVUO3otZc1JoJICUNXyrrzweQPTrxGiEHnYlU9O4XvKcrwIkU4A==
X-Received: by 2002:a05:6512:3e26:b0:594:34c7:cb6c with SMTP id 2adb3069b0e04-5959876f719mr812868e87.15.1763458532578;
        Tue, 18 Nov 2025 01:35:32 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-37b9cef41d5sm33577691fa.49.2025.11.18.01.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 01:35:31 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Nov 2025 10:35:30 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 3/4] mm/vmalloc: cleanup large_gfp in
 vm_area_alloc_pages()
Message-ID: <aRw94uC_Obxebk6T@pc636>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-4-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117173530.43293-4-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6205C180008
X-Stat-Signature: 6ffn76nt617kkudp4fmbx8k7qdjh65i7
X-HE-Tag: 1763458534-889928
X-HE-Meta: U2FsdGVkX1+S4fIW4oBu5LAxjfM9bWACYng5uyOMtPR0mCSKr8X5TmI5XNbMI1dU2HP9UeLSzyALA5egTAKGY+16sz899gx8OtYJ3gdwhOLdvXNdIOvtWTpB0K5/QzhD4F4Y/jp+S6PZpC4v1EVMMDksiZ5yHi6YkF9A00HcKzYj4vhS1a+iiSW7u0z/N7AdFlC6YW6Ux5JeT6U8fs3U42/xtpCbh66w/8WBCzjDx+NhKDBId6u+zoJ2XRGxLGO8IgKCHgbeycPVEFRmppHjEZr9XHy942vbKjkThgknU3rMnirEwogb0unWvuwllATGI0xXWpy+ZsG27sT6s1acDh+f4NRXEatVasxtX7XyKJYeQv0D0/7vRo7CzMOXXgwHl4ieA/BEUII7RBza65FOey4EpbSp8zfwCXV+9S7U25Mw3tm6kW3pMFi4eqvgFqQIN+MUOaAhfmFzjDZqG4k6nlLeuH1e8Cl7UZ+gY4HW6pkZO8tuJV9ARL1iE40weYQGoucghRhLNJo5jD7LtBeuh7IaP4R9fC9snq7+/5w40do4Vr2sOEfaoQsC8U5twls5EYSAVUgkDHeSJdp80AZj+gDj64MpsInx28QBh0icwHKNKyKEyA7FwAcfQs+36nICR/20A1Tva1xVvKCM564YfJ/sEoyVW2eZJshcEvHQsPJglGYcHeVKMrtG9TNrEFFkmk3a73jsyTcEZRiM4JFdikG/pap6+m6Hqd4exHxgAXTiwJKHeCrhrxajcKcmH8kUV6XkcmcOsjAFTKzJIfp+2O6C93af3uMT5xHf0Sx0C8+iXYNDbk/xoKLKlX0MNui0csz2nbnd20Hrtb7gUXL31ojiocrI/c6FbIE6N4F+oxz9o/YmP/pqjc5MPgLWEfvrB2MpyiE7fl9P1GgI3aye8BrRvyewmDSJKbo1yNCMPGDZxGQbk6iCk0+ddLXZtCg+4k5IBeMj65z8DyUiuEz
 UsH76lP5
 hoQpTGMmDa7ARSMSTH0PSegEpzf5M3avjsvpCk/iaZSz9+7yz9RW8ecGhQuV2RwwdKihLvACsc4/fJVCZkkUkGEDztXVbkwPiFmm0kJEC51abB/m8HQOXipgsdW+GBjIJbVk/nlj5kRAkVROQJUufKV3SuLz8powKXNQJBiEhDZWwO/wJe6rSzNFKrJ1mZ45v8E4LeGsrlyA0gSO0ftbJDgtJfL/ToP+lLwG9gcrcc86mZFiikiNKrE3GwPu4tfw2Xn6OuP0hVuf3nLQ9+3RjQvzee+QLbfdewtRQj5SUP3F1PNdjsFLBQM2a2DrZtBtd7b62LurIzSPfIbTRS3BaDiijV6FHqlJlkyTTiU/oKwEwQGtw8bGJ0XtLbFTmuWJjNpM1XKffaQ0PRQldM7xfM1GN3iaIC4MNhCJVbuNRxMrQawJmJ4UgBFm80bmP5hGX+XmpDeWYE8ACBgpdcSHP5Ou1vo/TEcUptw4wUD6ewf+F60M2ZOjjVyB1yzEzIjHz+9k/KRqUuAlV3C1gO/XFFSl4EWCr0QMxqQC6dlVADIrAyFRcn3+C5MWFSfzGaITvbhw7Not8m6Qn3KRlVgbbrT+wVAFFZqD/IIls
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:35:29AM -0800, Vishal Moola (Oracle) wrote:
> Now that we have already checked for unsupported flags, we can use the
> helper function to set the necessary gfp flags for the large order
> allocation optimization.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  mm/vmalloc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0929f4f53ffe..d343db806170 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
>  	unsigned int max_attempt_order = MAX_PAGE_ORDER;
>  	struct page *page;
>  	int i;
> -	gfp_t large_gfp = (gfp &
> -		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
> -		| __GFP_NOWARN;
>  	unsigned int large_order = ilog2(nr_remaining);
> +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
>  
>  	large_order = min(max_attempt_order, large_order);
>  
> -- 
> 2.51.1
> 
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

