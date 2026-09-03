Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD58C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DD36B009B; Wed,  2 Sep 2026 22:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE596B009D; Wed,  2 Sep 2026 22:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314716B009E; Wed,  2 Sep 2026 22:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13B6F6B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:24:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 981DA1403F6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:24:47 +0000 (UTC)
X-FDA: 85170857814.15.9BC890E
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8D93100002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:24:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c37DBLQX;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEnLbsLjH8lfXnlpNq4YY44i+y0cC+hZ66l4ewIS6QE=;
	b=w9U9cLk7UEPrOvi/JMLoBFcL/XlBlBO9IXVksk53Lv66igqY9Io1AfB967UHEZ9fikTRt6
	6CojVeA03Wh2DLcZzElHbhYJeOuKpVlIa46qfSgJ5dtE1o5PNnokw4QcQ2r2K7TTP2HVFC
	lUKs2g5lsdquqrbOdOEP2NjEe7mTxho=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c37DBLQX;
	spf=pass (imf14.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402285;
	b=EVZ64PT3RvPvtMJo3PR7MOUlpL96THmXfICEb/UWwJlJIYuLcXz0AcpXEARMQ8s1R6xjv/
	yPlAJUK539DI0ZbNdi0knJPa02wwE+PNZXsb9tfCvQqXY2PxfmSnJStt9z3I0FN17tDFNM
	i52NFnh/7n64pebYNIA2XekAvKiyjD4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-ca12086c06eso1503025a12.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788402284; x=1789007084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nEnLbsLjH8lfXnlpNq4YY44i+y0cC+hZ66l4ewIS6QE=;
        b=c37DBLQXwb5B7yiNsSPT487RPamPHRgFV3klgQtnGTJ/cieGCMGjeFsluFvbWdUC7U
         6hP3nARTrV/PXuLXDjYRnpFaR2vURhPJA9Tx8cKnJae/bdVn1OGpM9ASbL/WBjip9NCN
         eKqIlWNJO2PsedOKTbG/9QeVdqFHH00z8rZz3zx8Geig3CFjdyhOme2HlWrpNkXhWuHY
         YLqowaV0rTLR2Z9XgOmqGjUQLH4uwqwqFb8jfKMUf/ipJbi8FMMFB56BfQNzNTl7o3My
         5XRjRP//k/uIqvo8EYejKSBgeS3B983PGL46RAABUywCPzSprfLJHi1HxCNaGWeQ13IU
         ZzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402284; x=1789007084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nEnLbsLjH8lfXnlpNq4YY44i+y0cC+hZ66l4ewIS6QE=;
        b=nh8Cd97iXExBC4rNfLgy51YmJxKBzr7JiLhwQv6SHgXkerQFLAHRR1LyE/doe7ntF4
         LcTZiCl6gcYIT9zSTRlZgEA2skoR+bO1D0W0pF2Ja1lsr/u5TkkSh/fMo+K6wgsFExU6
         4KAdwgchKv+IVQOlXho1JfEJRSqsAOBfhL4pOgnPyLzbcxsHz90lfRxamg3MoDzlrpGD
         T5ZKvWYfp7i0Y+XInZtd3DPS+tBY/IthUS44ppZsrg8Cjzb7pOvbzft64vsDxHw7cc4w
         p897paSWkqKC3EDckWCBp/ROXdWPMgeAbRIWLxrOXwlG0c6SfMKXAmWLBObA3xM1Rzyj
         ctVw==
X-Forwarded-Encrypted: i=1; AKwUvBzP4MYAOuEOIUJwxoa4j+FhJNQgV1eQgMytzbSusLNNeITY+Tyq4Hq/TTjELju0zQiQ/n35Ahzq+Q==@kvack.org
X-Gm-Message-State: AFuF++nyG9sjalCcZ9wSvE3FVzD8vcHis0TzdWPlBSHQ34yfqdj/DxPb
	2Kf4S2hQ616fybOzWY7fbj+ZRt65vM2N93t2dOTIhedUPkL4iV4uUnDV
X-Gm-Gg: AYBFou150ZkeUFjq+vuv8ZOicy+6RvreOHBNGcUWe0o6AlGerSal17tySutR4CPhC0t
	zWZSOg8+TQZ1dTdy8U7Lj0uJvZaCMiPPGr0Q4bzQLXoBe7fHOIjiJTfP+9go/NaTOaOtacwj1KI
	VhGDtns0wMI/iJ73riUYsQ2dVZ62UIHUPctrUZZqHeB5BuqJ/Z0RdzRDf5yV1LZzngaLEO1ukED
	uvtR5NnKQZBV2nDaLEiUhGQBQWkzji6O9mXJH8crOe+qknOzxR0w2/b1fAovE7n06BkKWVfJoTn
	hSnXL/Zrr8DWnyckCTfV5lX0KBV0uD/SNO8WpQpgDpt89R2NH0xcifxAgV+pm4jtu9OwOA9FNdI
	8dQXtkCja97keIkBqF5KeOtrZfQHgIhQz18Z01olILMVEI09CGc3LoWxhfOodFazkM0vKbF3yqe
	UZTYtfeAlaoDJiBc94zfdWi0rekIkmn1DAHfyipKNtRwPq41xJsQ/yEFwIgJM=
X-Received: by 2002:a17:90b:5384:b0:398:ceef:edbd with SMTP id 98e67ed59e1d1-39aee1bbae0mr14243570a91.18.1788402283444;
        Wed, 02 Sep 2026 19:24:43 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08766a2dsm2107662a91.15.2026.09.02.19.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 19:24:43 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [PATCH 03/12] mm/damon/vaddr: remove a debug message
Date: Thu,  3 Sep 2026 10:24:22 +0800
Message-ID: <20260903022431.74074-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902054747.99370-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w7igs51z15ii4rt17nrift81p9gha16z
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8D93100002
X-Rspam-User: 
X-HE-Tag: 1788402285-940073
X-HE-Meta: U2FsdGVkX1+gm63SJwkiDKio1QxN4XCMkKKGthBkveoL3LjrZ0vitFcd0NgnD0YTahhd+mTXzNUzUuevei1Xg6lCljQKUArJIYGa3p/RzztFLjv0zhonp1t4dZ1pbgruiuf9dORWwqoMnmkpxj6FUJmd67sw/ywhoez5LH3P/D4Z4X2SJgQiKRzskeoKsqSI2Qv6JI/S31/v6QfQ+9XiURyZ/Quz7CudS533pMDNP44NTsn4fQ71XhvOTOmFCFBXNEKexixzaXZeI4c4KCBhNJ1GsmEaYGNsca49o5FWDB3STe28UaLV+DVpm/gdV6hNzlIVdCA218b8aZiPKi/oCh3E6kCCsNfiyAaDg/T2SYTApZX6y72wk9I7iuADwz7i4AdeAMC8cFOD9IxkCR1OcyYVZ/CN6lKpsdxgTCYv4FStihcCB5H2+TLZUr3OH8u4r6B3uSqvYoL2+2/peccmvUn5jJSdlL4GA+ArHW1oh4lJaxvI0xZyx61WKVRuge/ROaVPA/DRDfkm3T+0bJg3uaxIFLUPke79seW17GZqBbVh0c5i1SWxSOutKayIha2TamziuJlBsRu3xcX1AF7URVWiZnWuGFgYBSABQkJdSIj2SLyHaCNteqktEjtpoTGrcBnHSwVcOoi/mhmwOzSxw4aDp9zwq3bcBIQ7D1JW6HiZQGBqSa1qqCPuCT7MEkdgajrv5qPROa5f1I8IrRhTIgjKn9lCSl51qvUxsFmF+DoG39xz2a/ir5T2yLxUoDyEIiOzvgXlghGiiwWzQ0LkcxJZnHy7FAgGJxkXxAtCaShqYToC3Lu5JxQ0hyCGSXd9QkCU6/rPuy0ItiqKpcFWwj9rW8e6hVCJa2YmX1tRISZIglDTvdglyCij3pCm+IA6px6JAzmrjZEFiKifvAB4hLDTg/a2WECvoo1ZeolHNUjJMw1X0boyZfJGhS+WSKka+lqcUvfnGeVhAt3CIXt
 9iqGg/ty
 zbhwDbnfHFuTxIZ/cpmywk0pVNPzsBpRbiqkAravmBTT2i9fzsPh9GuG9TrYOM1clNEd4ktO/CoR60OLWHz5ODkVK/xw+rZ2lmjMlOBQAYCBbZ3vi/rS8/Q7/6D0lOvs2SqUq0mYDuulFAUBJR4wK5ZT+/ZJf+OuFpeATEBJAvv/en/t2xqsJlON2WgVMK6+p68K2rtn8kBKp6lRJs9Ku+4mrvPChm0KZQA1YbSOiQ9avkzJKl1Q/C+5EnUM1f7+B5XT0SHnV+JSF5KZ7OsH3C+9VO8/dYSA+tQQyrMwEOluGNt61WoubQsY264PAIHf/jS6HHNCOQOtIkji0hAryVgDBkTyDasPx3GeCPtcMp43USca0ZpVxge5LBbr1sijegCpIeCg9v2iqFkJ/XvPYxnnMvCvQgMKedJBvkiiv7ym97BZ4aT/0vzcf+qz5M5gyXOoG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 22:47:36 -0700 SJ Park <sj@kernel.org> wrote:

> There is a debug message in the DAMON virtual address space operation
> set.  It has not really been used in a meaningful way for the last few
> years, though.  Remove it.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/vaddr.c | 16 +++-------------
>  1 file changed, 3 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index c8c32b2ae0402..f884d3f78f30a 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -189,22 +189,12 @@ static int damon_va_three_regions(struct damon_target *t,
>   *   <BIG UNMAPPED REGION 2>
>   *   <stack>
>   */
> -static void __damon_va_init_regions(struct damon_ctx *ctx,
> -				     struct damon_target *t)
> +static void __damon_va_init_regions(struct damon_target *t)
>  {
> -	struct damon_target *ti;
>  	struct damon_addr_range regions[3];
> -	int tidx = 0;
>  
> -	if (damon_va_three_regions(t, regions)) {
> -		damon_for_each_target(ti, ctx) {

Thanks for the cleanup. The debug message was the only user of
ctx here, so the signature cleanup follows naturally.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

> -			if (ti == t)
> -				break;
> -			tidx++;
> -		}
> -		pr_debug("Failed to get three regions of %dth target\n", tidx);
> +	if (damon_va_three_regions(t, regions))
>  		return;
> -	}
>  
>  	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
>  }
> @@ -217,7 +207,7 @@ static void damon_va_init(struct damon_ctx *ctx)
>  	damon_for_each_target(t, ctx) {
>  		/* the user may set the target regions as they want */
>  		if (!damon_nr_regions(t))
> -			__damon_va_init_regions(ctx, t);
> +			__damon_va_init_regions(t);
>  	}
>  }
>  
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

