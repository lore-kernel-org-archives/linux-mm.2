Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68471C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D826B07AF; Tue, 18 Aug 2026 10:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 754136B07B0; Tue, 18 Aug 2026 10:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691F36B07B1; Tue, 18 Aug 2026 10:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41E8D6B07AF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C183C1202D9
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:29:54 +0000 (UTC)
X-FDA: 85114624308.06.7A46F18
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id C125E20003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:29:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LC5h7w25;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7NrMCatC8ufvSDl+4wuR3/sLG8+OS++07jlkcNtqeY=;
	b=7iZOgYmNguqe2mti+IJymHl12do22TJhUq22SQBxhr2zlHlyNf8DGNcWbTuvgtchRiGEth
	OuUdknoyWDgcA7wF77WfCx8GE6km9e1Wwa4V99s6vq2pp7NkFp0bG2ry1Rq8KGuPvbh4dW
	sMaWAH7qMIsfycSLGG8G7ndlstzKJNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063392;
	b=40Hu/0LQB8qQZFgz6mP8OyYIB32fKZ2JMiIBvDDAX0pLxHkQzO8vJPhbnvzJXEFuHh+Il3
	i7DjAvOBt+xLuWqFQRWPD/mBALQGG0UrAvSnEwqW8MSW2kg7vVvCEEDIJbE6hPF9DmcWAN
	P9yrYn/1PfOBWIr46y9ZFJQ/rEyWMBs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LC5h7w25;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso23841385e9.3
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787063391; x=1787668191; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d7NrMCatC8ufvSDl+4wuR3/sLG8+OS++07jlkcNtqeY=;
        b=LC5h7w25KpYLlOiUPyeZaYgNRnC00+HypikEEbxYAhAnXHZWexO/htbvNrIXMLjHjz
         dI2ZjrEQgNaoH6SHuzx7zxMXSSxhpNwtABa79K+grLzVvAZKRUKDiVsZAaqxlgBEEW6S
         hP910V22xdkVdqP6+jDVjwqJ959t0jluEZ01JA4sdmcBAkOhuSwcsagXJ4JLs0PHHWIZ
         6wI7YuEdI1/7xs45JkQ2Jcp0PQij6j6zKiEgQ/VPR8Lp8HDvLLE4eeqINdPGdqHZQ1KZ
         KFzTXLeKJJ97x7bCwcS7+ye6ghYNgF1SQdWlK2LyTIwS+ZOQd6zSLkj0CylIZvPq9i0x
         YGNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787063391; x=1787668191;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d7NrMCatC8ufvSDl+4wuR3/sLG8+OS++07jlkcNtqeY=;
        b=R9URPuOCDZIEn6A6GiIQcBCKAbRUfWy295kTQYqbaoLbniTvc036Q54d6A+z4pL4kR
         ST49nW+gQbsHtlztRqqN0D7ZcOwWUb++uPZOlyE+DKW2nz0FgUfa7daYRh+ZgNfDfgVa
         hjsMQ1kZ20zG7bVctJVQ21YUQaHUrz/neGxKRwvIkzEEBjxn2NGokXrVrJKpME2gipRd
         abaQj3webFmtyP44WUknVEk9ihhWWd57MgajhUdyVkRo73Sz8NEg6LiP+hOif3nrXFsb
         Yc1cD07QajI0/K1AD3vX1RmMKpK9zjaRdw7lO5G+xCkefeycgD9It/IMvslgOmMZje96
         xZlg==
X-Forwarded-Encrypted: i=1; AHgh+RqIT36szfE4k++vhFjsY1CgUMADcUpPALC5GkPz+IxFP0adafCO9cYad+5qDqlOY8wvL5EVR+2emw==@kvack.org
X-Gm-Message-State: AOJu0YxFX3Rd144U3VfIlTPhMefH4eOZOYTMYnDeIm3tVfR3WS4U3gKy
	+JSJHO4TJeABm4eHh9xsDNAg/8ocOvhQGHrvLRy1bq3OUprviAcuDE9yIHjdiH4rch4=
X-Gm-Gg: AR+sD13iqUwK83p6HwjiTsq7ety5cpnpLBzhdqJxuz22jyJhpSmx0aFBQG7side8plu
	YcP8zkE4UK0QrQovKwGybtwO6wjGDUic4d10m6Pb67utYTzZm8tBd/IkWK0Ny7wcEVBs3hhW71r
	TKq4DT/t4T4YkNhGmcvNAhRFIEeip6fapoSKipRgC4KvBr2o6OJIN64i/XhI5JdvTz0R+j51prJ
	4I4lswd96lkTSUQe98O4EXeNbp40aFIkez1mr4RnuRyY8O831YA/91SKWH8ZMo8PMSZ2yBP/kgH
	JHEZwNuUR3ih7Jhz9kgbDAK96f+Py/OyNqwt5XinYQ0S1RCKMB/GX94w1lyrw6BWvC6mAUAEwlf
	8eIVodOEXfQkLz+XOej0iTbfP/Ql8SGzmLDWDuk48PPg3+NwMZF0N9dlem7rsdseIlJ77Gej9Nk
	D7iEEeWY4+ImObxCadsVA49RtFYQ6u0PFqx7h1uuu9t8FMh50p8aW+9TNYCfLTB7opNP5mc5gRe
	Q==
X-Received: by 2002:a05:600c:c171:b0:499:7f38:d77 with SMTP id 5b1f17b1804b1-4999fb2e1dbmr169268255e9.6.1787063391240;
        Tue, 18 Aug 2026 07:29:51 -0700 (PDT)
Received: from localhost (109-81-87-166.rct.o2.cz. [109.81.87.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d0876b8sm189990045e9.8.2026.08.18.07.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 07:29:50 -0700 (PDT)
Date: Tue, 18 Aug 2026 16:29:49 +0200
From: Michal Hocko <mhocko@suse.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, joshua.hahnjy@gmail.com, willy@infradead.org,
	shakeel.butt@linux.dev, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev, zhuhui@kylinos.cn,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH v2] mm: memcg: release the css reference when a stock
 slot empties
Message-ID: <aoRsXafoUYxFccQr@tiehlicka>
References: <20260818130135.154315-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818130135.154315-1-husong@kylinos.cn>
X-Rspam-User: 
X-Stat-Signature: skin3shqgz9p5gtj3a9n9dzkn44b3drq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C125E20003
X-HE-Tag: 1787063392-473625
X-HE-Meta: U2FsdGVkX1+TXAUzxMspR6x3+IzRNdo3UTRKHGKpKwqLx3OJw4ERcFxFQX+lrMfa1VuiCE8j/YJ/6+zAFTBhKfTAa+VZntaJej8f+gtAmpkFOXmkTG1Eb62T71Os1/L7pIqE5gORQyXbE0Axc9SevslMUbwPSIlromMiqj9+UPUpM9iYSvlx9KnMniEnNZ8ekZAdJCgRt0v4XCgyATggfFJUuht4k3OB1Apiw+zHE6LHW7fzu4YzkuclWF6X4KV98EZ1HgqFYPwNUP2cFtFusBYjnFGOZx4+vXBGMHGPXMI3I7til5Ul8EptolEQkrR24KdI1cKkpNd7C6Me7E/mVKJK/hduzCgB8ov5WLCDSJKNXbuZ0jbXKAIKFDEgm2h6xE7MaklnGav/KYOrTOA3eBGH37e1518+efARudPnbrky/s4CqEFbbnJd0DTRqGTD1CZDKJy0LHK31yMnV+kInlb7I6vHx95AmVaG6bGS6GyOIXWbQJZbJRqZBpcDP/Gm7wmsrgBUe4YOZ0qpMMXj7EvjFBwfW4gOa1/pmE3swoe0RU9+M3WFkdEt3SE91MGpL1dg5b6q3yiy4QhISfFTSLPE2ZxXwzpV0GG6wMDM7aXTPDjaGWOQ0tEPh10cS4/lZCQjZmUqjOQoCQv5Y3Zj3p76928lgKHZslKcmpJWFt6CYHZjMmr9dDKH4XvV7Kb3n3swlTEK0TdjGIbbnIg/X/DneVo3/I+Fl+R8uq5PJ2Hq6Tx0uAbYqVdanWsLjMnKu2GjX5ovD0CsN3NXY/XpEtYsSM53/E1kASKZ28VKBlJXtgqJVkquH6wu7k1/WO8tFrAsL+RbMgSHlKQcQVjz/pETLQZ8OIq57Q0GU7WUUN8poH4Q9vjUFRgZE+qifhQX3nDCS5c5tLYPgL9PH+nwtw1E3QXHtrxvwie8hg3XnQMWTyxx4VX41hOe9FMwZCYlYDke/wQQDE+/ySunVsi
 KGrCrQsa
 K9G1sG/O//Wj7ol19JVYx8XZXH0aBQCy3cI9JrIzZGKG6YbXtOE5V498Yv2liG6JOPiN9aBdlhOI3e6PycwAPPQxtlS2to8iiWybC7NHRYpmoewLGBeF0xAzgs66ySRrsbFDao6SA2ykRlCxHMjuIOwo6HXZGdtI5epHMDI/ycX+GwnJ65ZN3PxAJ9auxJtALPT2wufp1Jm//3kUpEY1BCvH4E23sU/o5oayfTwYv0E8Yux8oV9WH64sMoeFNEMtmSNWQc/+Ub0vtIFz8I1lK/n8GB3Ux/uAsJZWQR+/djBkNk+5yyuifrcG1C7uX6SxMXXXMQ4KmxMDa75iWvoawhPRpEPFN6VvbovtgcYLJ6pw1UpguRtrLQHJ4+jQH3lq65fAMFQ7Y1ifmxcVZ3E1nJCtXjIaQLpa+JUNhVMr+fhlSbNay3qy4jL/FjDeHF8ky6QnNIhtWNhwP5DVyX25Y+7XKc+Y8MrVs5GZ7OSyBCXVodCkjBPhS5ZgGuzolqTkn1+pgdu5LxmCHoOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 18-08-26 21:01:35, Song Hu wrote:
> consume_stock() can drive a stock slot's nr_pages to zero while its
> cached[] pointer stays set, so the slot keeps pinning the css
> reference that refill_stock() took.  The offlining drain only
> flushes slots with cached pages, so the reference is never released
> unless the slot happens to be displaced by an unrelated charge or
> by CPU hotplug, and the memcg lingers in the dying state - up to
> NR_MEMCG_STOCK (7) of them per CPU under container churn.
> 
> Keeping the slot populated past the last page only saves a
> css_get()/css_put() pair on the next charge of the same memcg, and
> costs more than that: the offlining drain has to know about empty
> slots, and refill_stock() cannot reuse them either, so a charge
> under a different memcg evicts a live batch through the drain_idx
> rotation instead.
> 
> Drop the reference in consume_stock() when the slot empties.
> Empty slots stop existing, so is_memcg_drain_needed() and the drain
> path stay as they are, and refill_stock() reuses emptied slots
> directly.  The cost is one refcount pair per emptied slot, at most
> once per MEMCG_CHARGE_BATCH pages.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> 
> Changes since v1: drop the reference at consume time instead of flushing
> empty slots from the offlining drain, as discussed with Michal Hocko and
> Joshua Hahn (full-stock drain cost, refill reuse).
> 
> v1: https://lore.kernel.org/all/20260817025917.66233-1-husong@kylinos.cn/
> 
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..1271d390b617 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2140,7 +2140,12 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
>  
>  		stock_pages = READ_ONCE(stock->nr_pages[i]);
>  		if (stock_pages >= nr_pages) {
> -			WRITE_ONCE(stock->nr_pages[i], stock_pages - nr_pages);
> +			stock_pages -= nr_pages;
> +			WRITE_ONCE(stock->nr_pages[i], stock_pages);
> +			if (!stock_pages) {
> +				css_put(&memcg->css);
> +				WRITE_ONCE(stock->cached[i], NULL);
> +			}
>  			ret = true;
>  		}
>  		break;
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

