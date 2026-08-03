Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A1BC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDE76B0096; Mon,  3 Aug 2026 10:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C49A6B0098; Mon,  3 Aug 2026 10:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DBB76B0099; Mon,  3 Aug 2026 10:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6440D6B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:57:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE8DB1C11B0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:57:23 +0000 (UTC)
X-FDA: 85060261566.06.E2068C9
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20E96A0003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:57:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oq+G0WrB;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785769042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=doE31CPU3agNQxp/VoBL0iESGBCUl1rgFFpxig9/S98=;
	b=aDhIfoqVYK69Ja5ifyT6BxvG/o8zmnm50+4Z2oq356qo2/1E3PTp/PpDEC7N68+9TrGFph
	VdbUBD/BlHnJj0EhqIh+582dZ/c7F3df53+/tuBqXEwH5nF7zcUu+TZfybRnV4SKii2gIb
	TXY8ZOwoputmywH74i1CxEC06d59aYc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Oq+G0WrB;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785769042;
	b=tUHZM4bFbg1pfW5gf18whlRz/EsD7qtyefbigVPZkxUZFSTZ0UQGeeJDRabLwxAtoYQnpP
	lFJyaNSzho+D8CJ+DjHa+7jcOefpLOe2XKsox9jKEQDZ0JFaQUqEnZvrQo9T2InkhCEli0
	zpPw4Pn1yIcQmFtMbc938dc2dWkJ/Ds=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f84023916so3490363f8f.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 07:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785769041; x=1786373841; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=doE31CPU3agNQxp/VoBL0iESGBCUl1rgFFpxig9/S98=;
        b=Oq+G0WrBW6xKXCVfUBl+Dqb8CDE2siZxVOzQpNcPU5hO6wH8jXCJVsjnUForNxkEk+
         ka6RaWVRs6kHBHMTcBjl2fvQf2n7L/mvnmWVhxj2WZUoXLHajttwDjOZ/Ju3vIXL8KMD
         GncMKW4zeowPsfVL24lk1b7zCgSawGstzFYQoWEA/2K3mag8GjVr4XMWqnbzCduR9F2j
         UtisLnyi2kAnsH+eIPjkB1oN2Ms84+tOB3wiKQ5xCQwjd8Wz/NG/HJnZY4S9KdYfTgEP
         KmVAaGSpkXI2XeteziTF47WJdms2/eSLDQl9rIW3myDkk57Zj0SN21ffgeuk8na3KVe7
         Y0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785769041; x=1786373841;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=doE31CPU3agNQxp/VoBL0iESGBCUl1rgFFpxig9/S98=;
        b=JBgI8leBL3r8UaEWsOdoK/fnZ8OtL94DLkuP1uqo+8lRyKtMD63wL0MreR/JX5nmN4
         /JXc0t+ccpRD7Oh9l18g7FGLtrbYiOUnEJtq9S1eWSZgvOJ8hOqMO2VNmXwGkEhFQlHr
         yqdCaqWBjn0IkqA5A1GqiOi5EdnATOEtkxf98eSlCXUKXt7Ro+9g+lipZ9jCUWaOQ6Dh
         VwvKJYbpouYDxiyjkNcvpbPsquVR0qnt99BJOCnLV/7BoGr/W0cZUC+nSyrK3Qet2D7M
         6a/6TNxVt1zniOQO2W2bqn7dPyxJswmgyvM3gWEf2/y9R8A//ciyd+Ix5E8S2TsBuPzQ
         baoQ==
X-Forwarded-Encrypted: i=1; AHgh+Rru2tu+WzkslXsgofhaHFzz7ZdAF/praWPLU4G2yTiCBQ8ASi8RhMQYAhUfkxusFZ3iUK4JYdOk/Q==@kvack.org
X-Gm-Message-State: AOJu0YwTtv2QWejmmJneONUo8XYFfpmYQcFG+T5X1i8C4Re1A3jICpNo
	hOilVLzRj1b5xvB15zVg3u2o/pdWuW6rK1p4iTSC831hZuocGy4v9Zor
X-Gm-Gg: AR+sD13aAAjRm7zVYHfZtUaSUhcy+Q5L/lpnKBrcIm2rCn1A3SSN7dUJjXmucyuE4S2
	U3YKDJPYJl0AouFjdNOheB55q/qfsMi9XA1/hqMhNWQJE6DA/0zBYaooRLxTYgr8vdJpxPHr+c2
	e5i+vYVVqG5F8x9DYexzg8gZK/7GRZSmzFSWl37vjnxGjGDOwbYUMsG4XzC1pqpJfiGh51Y88A4
	Nn5ctYBxDanQ0l97Jopn1Xmqv5ZXWXV7r6ahkRPElraXnZmW3RFqRIN8SDkPxgHzu+LkKnj4g+o
	bhNQX7O6wuzxbkYPhtaUfqn/z7O5J4rHjSiplWRRrUtETrrjlzUrlWYIkrFOPh0g22SiqGDxfmW
	NAftejaeUgkfNmuwAhTM03X3sbBgMwrmaozxckiTmiBu60g7tRpJdOQ7N24ee4R+Wtkx7MZLdcj
	pqPB9HI5TGq8C1uzDP+PX3p/h+GeKAlFq0I6YRvKvmd7bUzmzr0uMmV5tdWIoUyLMEMfevXZCQD
	29kJH9H9mgYhZB4eh9RPDue8Q==
X-Received: by 2002:adf:fdcd:0:b0:47f:8fc8:af01 with SMTP id ffacd0b85a97d-47fd72f1fd4mr22343046f8f.27.1785769040415;
        Mon, 03 Aug 2026 07:57:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fd458bf7csm35015001f8f.32.2026.08.03.07.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 07:57:20 -0700 (PDT)
Date: Mon, 3 Aug 2026 15:57:15 +0100
From: David Laight <david.laight.linux@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/damon/lru_sort: error out for >10000
 active_mem_bp
Message-ID: <20260803155715.08868ca7@pumpkin>
In-Reply-To: <20260803134034.15217-3-sj@kernel.org>
References: <20260803134034.15217-1-sj@kernel.org>
	<20260803134034.15217-3-sj@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 20E96A0003
X-Rspamd-Server: rspam01
X-Stat-Signature: zj68313zwox57q15itwnh1itbnf9t9no
X-HE-Tag: 1785769041-191994
X-HE-Meta: U2FsdGVkX1/xigSXbp5jqzmMDK8QiwNL9D7IjQk5Txj3+jbmwh72UB9u31Fuy6d8BrsbOwh6WNds4+gFBTwGT6Q66GebSoAFNE43doX6Wwo87q6zTDPxKZieeVjjwHwqVHSoS/83nYx40petrmOuv7olG19PpeTorQEUfj/lhKJ1fQnEyTtaylWZxzVAh8IGyQKXexAQWt5XN7L9VD66iQfzc6Kw/EvEGx4vwKL9uh9VF7Br8Ky4JjHCvgXDGtHgZnrZKZ52LvEa3igP1xE8gU5RghVuqozYMNi3xCQfycyqoqbqLHKKMAV9YUP4oHqOgQygPhMOvge6Dfk2xflYRreCMkdALpMvBI4FhFNL6euAp0PjcXnWCKbXVdMTRI95BaPElH4PR3fSdxS5N4+yOwjf4InTsUEk/EZU6HI35GQh24/R0ICEpWQ82Q5lldA8jyb/SnNlPzOWzORiOR17U0Lf48B4txga5qXCd62P2mrZd1HTY7x6asyGfiqXftIhJGt404HPiOPs14drHrWreeOx5MHJoNmS9GCxvMIgSCXzQ8zz3Wl7bZp6nxqmCcC1xXlQT5eTGWbUDcUwlz8G3jp2G8HHPPwoGcdma6NZnbGSij39TMyoWKIb/BAU3SErUb1QDOoNfH59N4hEFm2vBTyPZssdtUOFV6vkGBel57w80fgmKH/baaOXEYCE92mPLu1OJsm+KqHOWVkoKgc33TUWdfuEJHOcAtRK5GofEsNWsLeRRDCAlRSiy19BLGgVyon+hGEqOojPzMriTWAV1uEjTK2X9gGxmqZgFSiv7z8jz8r2qXEhOfS+E9gijLPkpZru07BFEc5vkb2VL+dbcfiz6soYtl3CJLZ3/ANDtDaRBtpmrbcvwwjHL+550jmrR+Q/G1/kNebF4D/ZKqrN57lq0R7ODCTdy+Js6P6YtiHWUyJiYrDrWK3kXL7/C03Eu2HPGhpROTqpvpvfxIM
 OKNrtsCk
 70sb9sgCPYPFR1DRF6DJTqLbp2swQ9rjfx7lsB9mwUbtfaSWCKFDLVWB6AnEYseLzZWi5vwMYAy4CfuNyRaqr7Fe4GayvdFlOUGXiBhc7yGRd+KraD6DQVSThzn6kDVWfP4zcNMFXH72Kgjru0uLWLdtcmx3ax1GJgkM4ScEBl5xSXuXlKzRvQOpG4X/KVqW3ablZMIeO2eSG+MBxRCIv95Ap4uPztbEBl9AgQLg8IUfUivVzzCqjtTozgRX6psuxwwPg4/lEbILgRES1PGDVNz0lLXiY1dcbI0OOzbsmbAuORZfTAuFjbOT67rN7MmJhvL/kFpv3adLIOhQUrOjK69tggyuK7Rn0yKF7EVYheHErhSc9br88a+KkXWLr4C34VF1QbHd0T8gooJwnZhhEXtgm0bgtME5hB8FOeql9AQDj3kJvcHY97Rs/xNzeRjALD8YT4znM3pQpIOyyvNeSTS7MrL+3RPW7h9O06Zc0GnmRExRyqFqRBQebEA3O9T7jSS5+c5wpd/Qvvih/iLRpShPjJ3wK5I78GyjS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  3 Aug 2026 06:40:33 -0700
SJ Park <sj@kernel.org> wrote:

> damos_quota_score() can trigger division by zero if the target value is
> zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
> scheme via active_mem_bp parameter.  It avoids setting it as the target
> value if the parameter value is zero.  However, it also sets the cold
> memory scheme with a target value that is calculated as '10000 -
> active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
> memory scheme's quota goal target value can be zero.  As a result,
> division by zero can be triggered.  Fix by returning an error when the
> user tries to start DAMON with >10000 active_mem_bp parameter value.
> 
> It makes no sense to set active_mem_bp with 10002.  It also requires
> module parameters write permission to reproduce the issue.  That said,
> the consequence is quite bad.
> 
> One reliable way to reproduce the issue is like below:
> 
>     # cd /sys/module/damon_lru_sort/parameters
>     # echo 1000 > wmarks_high
>     # echo 995 > wmarks_mid
>     # echo 0 > wmarks_low
>     # echo 10002 > active_mem_bp
>     # echo Y > enabled
>     # dmesg -w
>     [...]
>     [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
>     [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480
> 
> This issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org
> 
> Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
> Cc: <stable@vger.kernel.org> # 7.0.x
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/lru_sort.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 7e077084cb03a..3920d5042f109 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
>  
>  	if (!active_mem_bp)
>  		return 0;
> +	if (10000 < active_mem_bp)

That is backwards...

> +		return -EINVAL;
>  	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
>  	if (!goal)
>  		return -ENOMEM;


