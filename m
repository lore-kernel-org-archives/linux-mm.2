Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F37C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D7846B0095; Tue, 11 Aug 2026 11:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288646B0096; Tue, 11 Aug 2026 11:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5CC6B0098; Tue, 11 Aug 2026 11:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA0C86B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:16:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78CC780495
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:16:19 +0000 (UTC)
X-FDA: 85089339678.14.54C9D45
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D5AE14000D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:16:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DPkK8msQ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786461377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+TjWxE6INahFNtOeQsNMBtfakKT8DT7FDX3ygEXVY0=;
	b=7P2WqspeIqpktovaghPCLKRtbzxehQj0jTgt30jY2KyKrsxcKDhjYQ1deowhJWc/SgnCVA
	Ka3zm0CXboH+lTTYOvC1IEpFl32F1CWjojgT04aX1HVTwvshp7/wZRH75Uq6XjYmJL75J0
	y/S9u7L6wCVXaGKPdzS3j+o7VccljpE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786461377;
	b=G5YCm/gQm25s7RuvjZxoOZ5SpM8k9HNDabh8Hc+fxjqkLdjmxAfXBoBm41B1JhLtk6VqxN
	2JJp3XOvrNNoxvp4FwdKKT/Hr2JyZpR1QPjm4yC5oW0h3hT57Qsuv5D7M2WvUH/wXnedWD
	ocUathlddUzxXU8/sF39ToWYogMvq1g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DPkK8msQ;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cc97653887so240505ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786461376; x=1787066176; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y+TjWxE6INahFNtOeQsNMBtfakKT8DT7FDX3ygEXVY0=;
        b=DPkK8msQck/RCSs7TTqGQ/Lo3ld3Wn4Pc8AHQditt3DqjZxAFuuFxnr2iwT1L+giVk
         jDTlUOatZl6t5tLA0OvPdHpMDasW2YIi4/WwRvrdjwyH2HrL4SmX14tENItxvxVPVS/B
         ILfpnegxW2fTtNIWBJMB43AbpysQzqRD/AmcMpReMuxJpHUkrqsZyDBXvlEI8eOWxwYX
         SjgnBk7DzMJ+dFL18Yr+hrI1XQGlytSJc/PACdPI7vIfh8VXrN5cQLgtQ0ZStOeRVGGN
         Tq3C0KjFP5OJXiLl0y5kF3zQ/iacjXbHM07HB6x1KCuUCgoZlNfDGQtRKzDts9R8/N/w
         81Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786461376; x=1787066176;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y+TjWxE6INahFNtOeQsNMBtfakKT8DT7FDX3ygEXVY0=;
        b=sUraIO6S5dokF4FGlT3r4S6TBdLCvKcqdKGmCUzxy0OeZ97AaKcotHCDwpEWgHyJ6m
         TVh+44CPx89uzFMQZ21vJvEI3jLLKYX2fBM1R9rP0xAsbzphaMQjTTA8KRH04rrllKHo
         /eA0xRueUCHb2MdYT0lrbHFvDThFDpW/GT4l27mRnqPq4FZ7MOWMT9x1mkhnZ47VjNmB
         lLDmCLLsvPH/ES6Z75S9Hi1KOw46I40Z8mc3pt+bCfwNpmLcAqllITVpr88jLfOQK9Bg
         G2ZEQBKe9d7ENigjC6hw4viQ0QbeEG4XxrsAIDKdfgTn7kf5NsDL5ZWep4auNUQF48KA
         kjyA==
X-Forwarded-Encrypted: i=1; AHgh+Ro40RvGxT6OhNTwsNVkSqxjhpDt9jYlkiaCQaBrKuucnuJ1gjDxc9RSv5Cpac2JhstGxbN4j7aNNA==@kvack.org
X-Gm-Message-State: AOJu0YxUvHw8U3NVz2OZnXjqwgO95WutTI//6ZZA/07pdknVkoBgeWrj
	6/AQgVLX6UBMmY7aZucGBQr6MaCVnXRIc1PdUuTdlome+rprjHNJQifR
X-Gm-Gg: AR+sD12AUuv2EOqu0/JwWDLo7BVbVEfprfqvxIQSjOMeEJfFg+SG+2dIR/DnB+sP5xR
	YvQh5KQFcGn7Cr0vhLEHtWIGMpCPx5hdZHcfCsTwS74/kX6N/BJTIWReXZxfTdf4fLsrP/fAx+W
	IUpAmWLImvMjkLE4tqwQHakU3FTjBIOZKYdGYCBPGPKIbwtoz50gu69kJY8SpMtQiBXpmsAwriR
	Wpq695ds+wUmj1iv3/jiN62w4qc2ZZwWujabe+FRi5vu0EmB9yuEZeCu+nPhQ41IQ9elfCnXUaw
	VJBsdAcZa+X0YJNy5p3m0kl3H2k7r+EgZuNGbCNEZsQ+0qkZgIZl/G57theVPEHAVmZixTY1UNH
	zgIrje7q5WYfDIYZamALFSRHDh6fqBAOnYb0KEOBIDWJN/Qs8Bihn8YgM2SKSueec46AA9YwTuG
	C/Mzg4SE1bMfNusHt+V2k1cC/6iTRslhTl131fF9skz6epYL4lFC+WenLTAPEvLHSwFJKckOtsM
	Byn2JJ28DvBo/UOpuX7lsfg
X-Received: by 2002:a17:902:ea04:b0:2cf:4c0f:5127 with SMTP id d9443c01a7336-2d3177e7f07mr48448265ad.10.1786461376283;
        Tue, 11 Aug 2026 08:16:16 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160f5cdfsm10104155ad.65.2026.08.11.08.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:16:15 -0700 (PDT)
Date: Tue, 11 Aug 2026 23:16:05 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH] mm/vmscan: fix missing NR_ISOLATED counter update in
 MGLRU reclaim path
Message-ID: <anrPeDFIs6JoPqhj@KASONG-MC4>
References: <20260811071703.425097-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811071703.425097-1-hui.zhu@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9D5AE14000D
X-Rspam-User: 
X-Stat-Signature: gy3hpghhkyu76iyh59brmneeh65dddg3
X-HE-Tag: 1786461377-613758
X-HE-Meta: U2FsdGVkX19kM8TLMR534hLmv/lttzIjykwyXnSoda7LciYxoBzKtLbV2Hmz0rhQxlEMrXgyyzpvfFEyFJjTBFwRjjz3aDewYp1fgjPNWE46mksYwMP562aLsHZvDGtFUCPf95oSfuYkoslGues6SJgmaPfrzaUSZTmrc9J8VF2IItPnr//4+a9sU+3zXaYEQ0eP5w3iqhyXdQnSeviZxN+ywrkHZAwDtqN1B/XPiD5XVUoKm34b+vv/FqmIyToew6damtlCUckrOw+S0U46Ot6p+LDUCiVmorIsVzGQIsGf2il6hP9se84rumwOsK9jR2oT6BIKTHuwwM42WMTir+AdkHGPEI/H1pgSDGx1CjSMDDJFIPCfIg3DoWJX/50Uc3xkPCw9rbRJ+uTlfcGHCL1qXDX859pMusvkbS5qbeHb5XTNd9uO0VQKmzRfA/SLnSCYq1eV7LF8tnTYdLtM0/rCol5t9lEd5FrdMxk6Jx2XDVIYqjuHwBNYZVl6bb1TwtDlilMSmYACaBBkhU6jfcAQKwcEA+p40S1VBiZKuaD4Za3vF5LXXLYldpqTJGwQzUj+Wn9dxxt1h2ri4XpajGvjrp3AT732SpChAnhbgQlIqN0wCR3OrTzEhxXaxPL9UC0O34aFfFeFQxJTstqEkHvQ2ipHbbfqoq772X2v26ypnlTD3g20nAYFJ3jOIf5NFgQJrP8jzulpPNoy8mmsKCEmEmyy+fiN2jC7YtVOLc+iIv+2RIkBppE+CGoufT8jBRiuJWr3PWwfe5dzoHIGvZS/1ah6FKqxyGg8H+tfd7VlJiKqw4X5Bd6uQrabAgJCEWerP8WImdO324YPBU3Rhgw3PZIOCQPHNT13pbm3uKbhDSaYp9rKgDIRir+aMYc2QZeKiqXWoVyd8KpHUM0ASwqPjJhCV84V+S4j++UVvElux7+9uoXoRMD+VMyXUsnOPMhnmhoExxeL2GalnGP
 RCwwdEeO
 ONJXoYQ50yD/yf79X/wWe8APdrri4Ex7m37U39D5qmC4Z+N+QqXmENifILfHHhs+K75Q+Lvwr0OCCrc2x2h/tNmQ55IoHkshor4Hssp/Vuf2Ml9OJi2B16RSgtgJ1kXU7rzEJBhT94VTZLqhI2DfhMIHi7QOcHojnQIMK44uMLZ61zfgD/oklCin4tJtADlZZXKDa1Df/O/ObMOD3E2ofVWvEl4ylSL8au58qux4v0GhAdoQgYCGdPnGB7f4Z0RHFJMFRNRGnvlKJHCmXIeKm6jNCO2fWWxv2nf3DDhl4cawVWmm4Ylx/Hpq8A7BGCkLKJjN1FS2dmoryQEzlU29x5dDOGFKgdWwSmjHAPhjlJxlm+jzWYEVK4E6vv7dTjya7WUI+LXvmRlinVYGVJHgMeRzGhlL3MviDMCbSXn8auUaEHqkzFMOl0X4T8x7a8T3hrDWXMllWBNDgzH11lYd8mBbAEFKqAUG1hMdzZQB/9j3Mxxc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 03:17:03PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> The MGLRU evict_folios() isolates folios from the LRU without updating
> NR_ISOLATED_ANON/FILE counters, unlike the legacy shrink_inactive_list()
> path.
> This causes compaction's too_many_isolated() check and the OOMkiller to
> under-count isolated pages when MGLRU reclaim is active, potentially
> leading to unnecessary compaction attempts or incorrect OOM decisions
> under memory pressure.

This patch still doesn't cover the OOM problem, too_many_isolated is not
used for MGLRU. I prefer to keep unifying them like what we did previously
with writeback.

It might work for compaction though, did you test it?

> 
> Add NR_ISOLATED counter updates in evict_folios(): increment after
> isolate_folios() and decrement after all retry passes complete, using
> the original isolated count saved before retry.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/vmscan.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bc324e37c5f1..723b513574b3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4817,6 +4817,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	struct lru_gen_mm_walk *walk;
>  	int scanned, reclaimed;
>  	int isolated = 0, type, type_scanned;
> +	int isolated_orig = 0;

The variable name looks a bit confusing, and what is your based commit?
In latest mm-unstable there is already a nr_isolated you can use.

