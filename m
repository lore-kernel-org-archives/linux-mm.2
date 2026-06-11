Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D873BCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06B956B0005; Thu, 11 Jun 2026 14:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C556B0088; Thu, 11 Jun 2026 14:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D0F6B008C; Thu, 11 Jun 2026 14:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D31E76B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:50:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7223AC2964
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:50:43 +0000 (UTC)
X-FDA: 84868523166.07.45CB28A
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7D7B7100016
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:50:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IHpEHczE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781203841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUxfWJt8IGWDlV52x/Qd1ZFtz3KlHMm4m7NO0v4ch/g=;
	b=rknEms9vzd1m0MlxO43MAmjggqX3NKURTV7oWWHpqOrzi/SPG6bcYGGUEi3jFmNrByiFa9
	b12IMz2o038aRu8HZi8dqxUb8hHIWhtrUTZiW8DrCJcBJkAWvTRm3+g4i5DIX3cnZLHE+R
	zKgaQGAzYEQs8QyqkRYfNFXhoujez3k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IHpEHczE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781203841;
	b=VT7yfUYEInwCTgDNvWVHAQsnbovNCJRzPdB5aqMr9r6l/jnr/2ctvHaToLfuIwvyZWID+h
	4dZfhijWLCBDF7T+Dra3Npk3q/COnLedWkqLyFyOZaKjlJCg0Hqj5tA0rLgalxaoI8NnHo
	fRDLPwg7qrq4aI1VNRv5liVEFVIva4g=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-490cdae130cso852595e9.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:50:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781203840; x=1781808640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aUxfWJt8IGWDlV52x/Qd1ZFtz3KlHMm4m7NO0v4ch/g=;
        b=IHpEHczE37DJZsE6/UC7AXw3hkUFKT6YgbuvbcbH2suDFGPG2Gby7GzdozeLRKlQWg
         B4JyTBqEDFrb0RfFmSfto8gUcBX7mchBUxg+jJK+qYptkBXVL/tUOTey6Qt8wdPGPgwN
         r/82tH9V183M2TkR+83L3F9mV9HVPH51ShdQR7/9tsn6Dxkmh0+0OsuFeW2uoamVVt0U
         HaGdAD2M93L66WmJQzyPMvHkFqhYYHMqt652xpdTl7s3GAwVTkelPMejEqzuU8FgIyC3
         UwzBZmq2GFLmte8sDJJ8BzieUjCBLkeHhY0pWb15Hm7LZu9MgbpGywXBCLVp5P7JuiJ8
         jKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781203840; x=1781808640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aUxfWJt8IGWDlV52x/Qd1ZFtz3KlHMm4m7NO0v4ch/g=;
        b=Z4qPSt0cLwsw8H8EbRmjt3uvLARoZ8teTXNQ1Dny4FG9OGoMvkV1hHiZyLB4JS9Zp5
         WXlh/gwUXtEfwf1wxTHi4lFpXBd5e45xA71ryNvahl/MC0v2HdOx6qsTXYRQtsOOB8UN
         5yi/AK885SSP3Exqar+M1feYuj0vzdzTP0BMU88DdFn3tp2aiuYtMKE362KsBKV3AiMh
         77z6tJkqcNzoLzx+HL3UGDqt+uAtO+GQ6PuafghIiBmidyuTXn+lX4fW+KkbaFY4WqKq
         wZ5Fol3WKXG6XR7XuP0v1ZDw+nTYHLRWNXhtK4FkwT3wfHfNKP17qgGT3FmtSFrdgAD2
         xTbA==
X-Forwarded-Encrypted: i=1; AFNElJ8Howm2s9mD8HzbI3LBOwPx28n1eXvGP2LvVHMIEbJB8ChgaOKrbtv+3RnqMaeccA9cFRB1dTLd3Q==@kvack.org
X-Gm-Message-State: AOJu0YwOeJIaQdWCZz4I0YiaMBooJzT1DRp6QrSQgaOG02MKnMNnYm2g
	zt9ejZ0n9pHMdAGUsXuGytwbr0kkJjJGrCuqm+yYEBdMbp0d3j0v5oGm
X-Gm-Gg: Acq92OGepABe5iJ76yoPLzz+ZcbSJ65qKuiNA4cfU6ulF0QxNzoZmY9YThN9qMIUvg2
	qbIYaGNlJxKQ0moIbVXBGHWXxo1dkMZ5m+X8dGqgkj2NH8NMbZ5yBDfyIlFeQsLmgZar3OiQj4x
	nz2nbn/uaxvwaUtByZK3jKZ2vvZUgb+4EJ3MdgCpsBe0KchQE/pJiJ7qwYIOjhAFelc4hX2yXIQ
	qrJSJ6tcy8o9XA3Eeu6n4C4uYp1cYiPLUCa64o3A2DQKI7cL8LpzZAnhKt0LmL/nS5DeoBkyjgA
	bhGeSEYxuMAxgQbl5TguAi69ITsjTageajK9TThiD0Kw6yn16BJBhrIYULctMR5W+5XDqepjNHN
	itOINAvKDPHHG0/9Zo1/uelFGMz04M4eV1fGdt/vfXZrcsUftOa6egqtJjoWWMPEjZT/Z6RYkU4
	v1FWvxCavmSdN+EKE9q5aSjeIsWWe4V+fxRlmuZ0Dow0wEYkhdokxSbm84170Y
X-Received: by 2002:a05:600c:8b31:b0:485:9a50:3370 with SMTP id 5b1f17b1804b1-490e55c3ca2mr57651865e9.8.1781203839529;
        Thu, 11 Jun 2026 11:50:39 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c09bcsm3579135e9.2.2026.06.11.11.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 11:50:39 -0700 (PDT)
Date: Thu, 11 Jun 2026 19:50:37 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, Arnd
 Bergmann <arnd@arndb.de>, Nick Desaulniers
 <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin
 Stitt <justinstitt@google.com>, Ravi Jonnalagadda
 <ravis.opensrc@gmail.com>, Quanmin Yan <yanquanmin1@huawei.com>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH] mm/damon/core: reduce kernel stack usage
Message-ID: <20260611195037.1adec04d@pumpkin>
In-Reply-To: <20260611125704.3386176-1-arnd@kernel.org>
References: <20260611125704.3386176-1-arnd@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ff7fo5rehu1oro3bgs4yd1ipu454bi4e
X-Rspamd-Queue-Id: 7D7B7100016
X-HE-Tag: 1781203841-463263
X-HE-Meta: U2FsdGVkX19VPR/7YTCY8iJE4hVoBcBmkdPGEC/E97VQUegOwLGBvVa0P2vem5/ispSn/CITN18dT0GqfgnzR8TalVu22tDIQtseaoUlaBTOgPu5vQUNVSeWZCX9JVENj7ui89XVLSVvQ5zxOOfhSv+QihaN9KQRdg1AeYeXrqooEXrzuKBVgMwgqoMlWGPg4Wlz2KcAEV9r+rsANJ5CHo+VrsAf/vFXXr+HWHQSpehJej/BXvtACpR6a4jiOwf7N73xbOJFIr9fMLK24YOlbs2sfbYNBnIfakeU0NFW+MUQMR5m5/E47Sqoob3SpiyKBW9NOWNCok/BDh6XwOb3OvTr2dhzxh7jzi2SR5YwsRM1NZRhBozTLsD2t2YNiPSD3G8muWYhVTRvd56E7u0uaUcWSnG1DysZYiHwZQ8l4jR3Oqlcw7icIx4q4Xf4SS/p8g17weSQew6lAR6SRsVtpNdRQixf9PxjdiR2iLY/CUs64x+y+4SlX9Idz2R5kLxnrZwKaLPhRpawbMXxFnEfQhvwFyuVUaFvH4Nci9ILMvqyImgZUwdfecmWrUVH2GBmqeQSzvQ8AaN5qB8Rc/nY8MNcUeYxadFjhHs0durFLjzk3dLgYr3drPNe6W7MdGs2ZQYxpECZdsTtk7qW1daFCjmnNcL5vM0KMo9RTFpx4zIjBolepSKRrBsoyawrWP2709GrgBZz+kEdEd8EH4ALdBJ/DHb5X+2C/tanGq2wP3CC1qj/drcphN+vw3dhkOIs/8AsjPN1He6HR9zsDZeoXGYNjQU8xMFfa/sHg00RZuO1zEqf0y4EcklPA4GnywatR6Hxnd5YV87Gtx9YM12pGbIN/ymFEQeKrafHeu3jvWmu+Fniv8zIcTgDVGIj6x2AxuuJHFQ66KpRTDDgSPcObPjco4FkbSVTWnONkTw+g4M32H1wVoKNfBkVCYR4Kpgsw8rrBr13xUs1J7AUKYJ
 CXIcpIeg
 sxEmR68mPtc5j7wfGbDBRBG8BzoGEumekkC9p8D/39J8KyqLWJq+0AKBTTyl/GQcp4p914YiU7KR563WxB4TZFuONNsUaM7laNShrna1wP9CSFdIGh5Vwi4l2vSWr2L2n0wCtaHBcd+MYTp9eoD0Qdn4X9ml65Xoo9lsNBqj2YyEr4KkrVoFswV2b6ZCuiCALbyaHBhkkUzqGXFNf+QwxptgQ9gT0JiuHQwY4/bnhVqWWb8HuMO9V7InmOSU6Cc3/JhRw/ROpGu6abUY2lljIryhOtRjkBd6Z6m2lB7+PvvsquQIs1pYNyMl19ZpxpNaY3Xys2nMG685Ji7FtwEtUKe0mmvpPkTiqLs05PVxaqwiGj1JgEbqFl/O2TecCGz0RG3rk+rbFDcdZAcf8FjUrFq0TM3VCzFc0Fp2ry6g7b7hTnJev3x0tzlVcqigAZpQkiheLjmSTyuXx9/+CIE/sZdYHTAFWLHNV+++2a7yzqbILQoxP0geQLER1l6OTQPQJHGJRrNU1O8mrNuoojx8V5qAZ38m0Xqbkxcci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 14:56:57 +0200
Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The main thread function has recently grown to the point of
> exceeding stack frame size warning limits in some configurations.
> This is what I hit on s390 with clang and CONFIG_KASAN:
> 
> mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
>  3440 | static int kdamond_fn(struct damon_ctx *ctx)
> 
> The largest stack usage here is inside of the kdamond_tune_intervals(),
> so by marking that one as noinline_for_stack, the functions individually
> stay below the warning limit, though kdamond_fn() itself still uses
> hundreds of kilobytes for some reason.

Does that actually reduce the stack use if the functions are called?
Or just stop the compiler bleating and running the code is still likely
to overflow the stack.

I keep thinking it should be possible to get (say) objtool to output
the stack offsets of every call.
With (I think it is) fine-ibt the hashes can be used so separate all the
indirect calls (although you might need a 'salt' to separate the different
'void (*)(void *)' functions - that probably ought to be done anyway).
Then it is a SMOP to generate a maximal stack depth for each function and
to detect the recursive loops.

I did that many many years ago for an embedded system (no indirect calls),
the outcome was that we didn't have enough memory to allow for the worst
case stack use!
The deep places were all (the equivalent of) printk() in pretty
impossible error paths.

-- David


> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  mm/damon/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 265d51ade25b..69f38c48ac08 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2002,7 +2002,7 @@ static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
>  	return adaptation_bp;
>  }
>  
> -static void kdamond_tune_intervals(struct damon_ctx *c)
> +static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
>  {
>  	unsigned long adaptation_bp;
>  	struct damon_attrs new_attrs;


