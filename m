Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C675CCA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C808E001F; Tue, 19 Aug 2025 11:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D78E8E0007; Tue, 19 Aug 2025 11:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C5898E001F; Tue, 19 Aug 2025 11:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2740A8E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:28:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF9A1B4825
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:28:57 +0000 (UTC)
X-FDA: 83793889914.01.F538397
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 090881A0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:28:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VggrpuRC;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755617336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUjpFijA0j4k1JtqfgmhrWzqVw3LyNcsCEew0K6S8qI=;
	b=yqJOXmG9Q8X1YTQPsC5/l4/tRVP2pAPJTZEiJfCgTrzaILtaKsFwkeqSrgxkLtwrdDgFAe
	fxPPwqccKgdwg06vTVRNZrLXTFqsMdRcFIPP4n+MM/636OQuHabFel2vw2JdbwDashhzqF
	YehStZbQawMaawf2Hm72aA10x3UATa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755617336; a=rsa-sha256;
	cv=none;
	b=VjN21zqH8KesrK1MAsdZCEgY0H3H62eCgP4u59dAcOYSTa0Ef0n0/IMyYjahiHDepAhqq/
	1YRkGKDNu7nqAT7Jd9nUOOpcnlckSll/wlXqI5EB8Yf17d/LAn/qfT95LZsNtIBK/02FEO
	nVtxRfIST05ta5RdjhXN+TQnDXx0R/8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VggrpuRC;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d6059f490so46960557b3.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755617335; x=1756222135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PUjpFijA0j4k1JtqfgmhrWzqVw3LyNcsCEew0K6S8qI=;
        b=VggrpuRCEhQO42CXb8oT9N1HqlcIMI1cNWMpmBBZ56H63EAbuPvS0KzdGD90kcAbBa
         /DJ1ThI1RHZTq0ucJaSxJ6Il7M3juH3tckC+mu650kH3J40PMAvsQKfpDzPWN1AIHGS4
         zPU5TPXJtdTR4g/2+aJRzzYzZRTsjias4zojWDdZICIy3xuLjSqNYM82SMNCN6x4A/fJ
         ks59QxgqloG+kEvdVQdaTKgetLmhrHspHkBZzLhtg9GxANW5cd14gr+EPRgDlgtUDb53
         4MW3ob3JD8Ow917b8C5xo/Ngz2/h8sbm0K57wxyRcUxtDy8YGIWfU54AoOqqpdk361qi
         mEjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755617335; x=1756222135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PUjpFijA0j4k1JtqfgmhrWzqVw3LyNcsCEew0K6S8qI=;
        b=qSzd8rW8N/z54bS2eoj/AybOnl3GShAAxgw4pr9Z7qPGLk91JuWw94mNZFuVB8SqEI
         FOAS+BgDXOTbnT/aUsDeH7QlDiRxvjXc4X40ypvgvmD6lchUbbo8olRMT3PTtWiB5VSk
         D+x0c22vwCtRYYSfuOnYMHoCkDpfJhA+y2DANAwALN4lIXx8gOMBnmPhXoAojjAYbfpT
         jxdQeFU+gZNd3oQYHlzKG+kZ5t5Cva9bpQLGVtXKgi6RqW6bLSfFmTQbFqs3ddyTvV48
         g/nc2pxN9yGul+y1skyat4CoJDFKs5oBL9iqjjVbAamsYNNTWEBgZtKCcl1zervrREcY
         1Z+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTHWYftjSjyDGDl8F1AIt5eO3zPaeMLurCeA68AXZ+29J3S8txwafHr/tGJTKrSdGYs62W+5RqeA==@kvack.org
X-Gm-Message-State: AOJu0Yyw032J/2iiAcCYJGpes/dMNV8c4JtxSxA9TzSgf4kdMyRgzcGT
	MOQe02hzXRMusKwwEGzBikSGFit746pvfXmrSVA7bPUezyvWyxMrRzMw
X-Gm-Gg: ASbGncsu8RCr3wogaMkR+ObhAf8NfwY3j4xVlnDRPKjXtnYQPEH7RZpQBm94ofjvtFy
	Q+hofiQBo2hnmuv6z4lZzxp1dyKH6GTEOQnR199WcblHe+H0Ti1T2lzs/wlSqJXsLETb5QJf4lj
	GGhdrDgYyti4MnLGNZuFyqI4ZHew/RVrZbyMgxMzqb7+kTBaoU8dix/HGdjHQqtAuewdDrfrMqa
	pz5MUn8Y9vBWBgovI/rrD++geG9i2XPNdc6d7XbTaIs68R6bzNhtj5hyOXN7lOO8yu6LnVVCoWN
	6prET+y8LB11W11pv+Vp/Agb3b+WrRSyNdzDnQmhp0blPG6kQjrffnx4Mlwf+Z8gWwpf8AKsyJ6
	16ns5cS3HgaisKxov0IhUSA==
X-Google-Smtp-Source: AGHT+IHvvrVwro7ray1QAZTpQIjyhwo8QR0jcpyTSwSpXqLp+chsKKcafMt+YNVzW4XMcgHOHgC8DQ==
X-Received: by 2002:a05:690c:6512:b0:71b:fe47:a1de with SMTP id 00721157ae682-71f9d64d65cmr38206667b3.24.1755617334957;
        Tue, 19 Aug 2025 08:28:54 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:45::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71fab5bdc20sm2010877b3.8.2025.08.19.08.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:28:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@gogle.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Tue, 19 Aug 2025 08:28:52 -0700
Message-ID: <20250819152853.2055256-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <k6fpx5adh45t4jrxgiccq7acubwcgmi746crggxi6e4oihtvpt@thks5zrn53n3>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 090881A0003
X-Stat-Signature: 5crkwot8go7998hjw54cwcqkks8patrw
X-Rspam-User: 
X-HE-Tag: 1755617335-283764
X-HE-Meta: U2FsdGVkX1/D3Pyt7q3LKjaGG9Phqi+sOVY8Z8huOVxiEX8KDwRmdOXcPam6V5BFarE9TqFPt/H3EgUoOWIqcBft7sNA8HyDDdperf5vIyqJ9mDJtb7ft3Cdi1BLLYXTAswl8kA9JvuXEc1TtLOrd9CWI7F4Kd0MtvkHcqOluBAiTVS8SMyxIaKLqEFtqV1yKVc0WCi85sQu4Pe7zhfCvrUCRSQg/sB/yyU55JYgdG5yzpc2Tb6RxxJjWp8BsTaxLs/6vO/FLQr/jb0nLpp5ETwlXo9kYO/+Cuda88x+BsZibWdP/vTlP9ii4wOEjjgeSjyLI94sDp9CChSFXMt6ZHoCCgsbQ5JczMjp1HNsNYg0J39yVibiSF9mzW8S3Umdu5a+anmmZZIl1T4kVlHkiGrYPiYl5oVNBGTJa9Mb3iig7zOCeCRvZ9IgcEvkzOhqLZop+/CgMQssZkZJZwMJ3YIqHfbgIDmUDIVjDmuULlEcsQjGQtdW1p8ZWm5u0XwqFHz+UqVD5BJGfX8h+P2hvDEUNarIgXE8koXeweMLjjTjBaha6GjeTDzaYoPrkF3/2/huojAyHGmIvuODPqX3jqrVzbQB4G1H0CnUrYK4/vWPXujTVGQZnfV8Tils3eJ70Moza3UXIqNx8/oLF3Lq5mmxv92J7H37ggN8xYpLFPtIw/jw1ltJg8uUnigFi3YdHidUPBqk6/YMyxySXFJhwmrWRAa/5tIMDQreH0a7MjXm8vcSj98LBFACSyWEbncCX10OzHjfb6tLP8DeEWe1u+0pyHZEjcZ2Gt5v3hUEeYu0VOoBe4mLZjguRHrJ0m2Hs5U6PD4fF9I18aZbHm8c1cUwJBJCfj+rZOI7yPzZSjejjHjbuMcjONom/NkmgJ7/HoXju8OoHFbtnbhkQ7V7SGNpoSdXr/oSzB/XRry3Vuytz08yBz+8MP6+AlzeYidP61geRISPrma16lWw73E
 2SfmeIhU
 z9JVU5YfCgsvyH4U0aEg2zZDdRrS5j3sMO0jveGgqxog8xFlfquModB0wMyyT65gn/pa9oIo1TkMyiPIXimRW5QXOMxikv4iHzdRYRhbnQ6Y9goQ6pVf43+nLQwSsl+9CDJ/CcDAgNdbjq2FQ6al3OueZ4a5rWfnNIIqgfRuAFv9/NSOj7xrlQkUidvcRLC2mUTPb4aegyMuVljtkVnBmrUdLiKYSUrTh7O+bYZf9oKQrok8TMR8MUVs9Skrlk3AI51GVH3Im6tndL5XCn4U+tnQ7WaHIEU6GIHKVtARYKBvYUcO4h9AtXDw1airog+Ze1vYtpn4b9kIi4AMAQ3QsQF7IzosH+8eVk3sU6Oe5S+tVdkNfEpzxnpUOa7voFck1tCQZ0bHbMonZrjukIIxOu6alnUICjYGWP8eNoVjQoRcVcbWd4hKRc0y0slitrSPTzgMlGZnZZ6IBTYwawMg38kMpBEWUPWARCT2zezhnkMUOEQKnWgmbJel1Cf9CtSH5nH8/TKYyQ1kP9OZcqschQy23SjgDh5Wa+PTZCzghdYo4ozIgjb6kFii7Lg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 Aug 2025 10:15:13 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

Hello Kiryl,

Thank you for your review!

> On Mon, Aug 18, 2025 at 11:58:03AM -0700, Joshua Hahn wrote:
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed.
> > 
> > Instead of holding the lock for the entirety of the freeing, check to see if
> > the zone lock is contended every pcp->batch pages. If there is contention,
> > relinquish the lock so that other processors have a change to grab the lock
> > and perform critical work.
> 
> Hm. It doesn't necessary to be contention on the lock, but just that you
> holding the lock for too long so the CPU is not available for the scheduler.

I see, I think that also makes sense. So you are suggesting that it is not
lock contention that is the issue, but rather, that the CPU is not being used
to perform more critical work?

I can definitely test this idea, and let you know what I see. With my very
limited understanding, I wonder though if 1 busy CPU will make a big difference
on a machine with 316 CPUs. That is, my instinct tells me that the zone lock is
a more hotly contended resource than the CPU is -- but I will try to run some
tests to figure out which of these is more heavily contended.

[...snip...]

> > ---
> >  mm/page_alloc.c | 15 ++++++++++++++-
> >  1 file changed, 14 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index a8a84c3b5fe5..bd7a8da3e159 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1238,6 +1238,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  	 * below while (list_empty(list)) loop.
> >  	 */
> >  	count = min(pcp->count, count);
> > +	if (!count)
> > +		return;
> >  
> >  	/* Ensure requested pindex is drained first. */
> >  	pindex = pindex - 1;
> > @@ -1247,6 +1249,7 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  	while (count > 0) {
> >  		struct list_head *list;
> >  		int nr_pages;
> > +		int batch = min(count, pcp->batch);
> >  
> >  		/* Remove pages from lists in a round-robin fashion. */
> >  		do {
> > @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
> >  
> >  			/* must delete to avoid corrupting pcp list */
> >  			list_del(&page->pcp_list);
> > +			batch -= nr_pages;
> >  			count -= nr_pages;
> >  			pcp->count -= nr_pages;
> >  
> >  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
> >  			trace_mm_page_pcpu_drain(page, order, mt);
> > -		} while (count > 0 && !list_empty(list));
> > +		} while (batch > 0 && !list_empty(list));
> > +
> > +		/*
> > +		 * Prevent starving the lock for other users; every pcp->batch
> > +		 * pages freed, relinquish the zone lock if it is contended.
> > +		 */
> > +		if (count && spin_is_contended(&zone->lock)) {
> 
> I would rather drop the count thing and do something like this:
> 
> 		if (need_resched() || spin_needbreak(&zone->lock) {
> 			spin_unlock_irqrestore(&zone->lock, flags);
> 			cond_resched();
> 			spin_lock_irqsave(&zone->lock, flags);
> 		}

Thank you for this idea, Kiryl. I think adding the cond_resched() is absolutely
necessary here, as Andrew has also kindly pointed out in his response. I also
like the idea of adding the need_resched() and spin_needbreak() checks here.

I still think having the if (count) check is important here, since I don't
think we want to stall the exit of this function if there are no more pages
remaining to be freed, we can simply spin_unlock_irqrestore() and exit the
function. So maybe something like this?

		if (count && (need_resched() || spin_needbreak(&zone->lock))

Thank you again for your review, Kiryl! I hope you have a great day : -)
Joshua

