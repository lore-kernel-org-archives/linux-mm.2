Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAE1C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6482B6B009E; Tue, 25 Aug 2026 08:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1B66B00A0; Tue, 25 Aug 2026 08:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0F36B00A1; Tue, 25 Aug 2026 08:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 202AB6B009E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:13:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF193140333
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:13:03 +0000 (UTC)
X-FDA: 85139681046.27.53C1E6A
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id DE94C40007
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:13:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZctkmKAO;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787659982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBJ/vcOaP1xG+Rh/R0z//WBNgvz+tz7qG49hmmpRSwg=;
	b=LoyegoE+mhburrsWiYgS8XLRdmzSyrn0zzbDfHoktDp8OQePGQbyRWX0o5pGu5Jl3oOifB
	lQuhAzWroF7G77lBMWYZRWARJBHcLuQkrTx5W+Sqh9h587WFeWblXeX35yXz8xJPTXNrpc
	Ookkf9jK7qiq9GrwXLbVstQerZHfyFg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZctkmKAO;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787659982;
	b=hle1JahK7nJGfLZHYOQPrtofjz/SaRKfa1TASDQHxSW9KU4inqmDmWF1v3oGi8j/1og4rM
	+Gt6AndwPXyGcXgyDh8AV8pqmJ/LGRybkYXkkRrordWiC/RrNYdVG2uTcn4wglUqmWjYFw
	4G/t+RXoBOTsoK0RRghc3LG5L5BKkFg=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15c42a45adso103935566b.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787659980; x=1788264780; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MBJ/vcOaP1xG+Rh/R0z//WBNgvz+tz7qG49hmmpRSwg=;
        b=ZctkmKAOq1IYMDVpzijXxFC95tay1W7K9ywM13ToeFMs5Tq8PDXzEnieroyw1QqL3k
         UedF8KfSLiocgMplhJRsMQTEz1I/4Y5MBEaGkj3clWkt12L3qwykIzB6o5QEq+1qi9E6
         WHDO4TcIxBOggKQqunav38cUDLMdSm6kB5jkdAn27eKhNpW6DPUPHPP6O2Nj3oj7sL/0
         mFnapO5gYuVPcQU1+06gbxeSxjeJ39VjGwxEgjN1QXMC8SaB+igVlMXSZeOSD3WiFJX8
         SZ0bmrynrQZj+YZm3p3u/ETLjLa15IAkcdYCgN6xz9UJmTsQoQ6Mv1x5HVdOBXjy4yuU
         7dsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787659980; x=1788264780;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MBJ/vcOaP1xG+Rh/R0z//WBNgvz+tz7qG49hmmpRSwg=;
        b=OvLaJyiOwSgEprJc9HeuiL3GP+YBa9zoSSp1SEWL4gYK0ClnQaqh1oWh5/lGXcqdTO
         QDif4Jq8/bN9gaWII1J/NxBNVkTP9mNSxAol/UD+5D+tXKdXoEACS33eQX4qIo6P+NwR
         U8nIaq6/1Oi6OCuYKJkWITdDnlI2FnP9PyxLPTZQGUAkTvWm33syrbvqMHJ7bT71A4q8
         QpPCk45S5TRv0reGZyQA7mTdmAonDwxiFcLeAmOfcfhsgzYpKfDjJ3ZalR1rEACKuExw
         168wJiitn4ihwKx9dXlEp8B2vY+YB/4GO6z6SVA2Ce9xUvhc0ztuXefuE6D1LQXVIUQZ
         H4KQ==
X-Forwarded-Encrypted: i=1; AHgh+RqN0BRY0W+t6FVLhDHlT17XknqLZJQMpdoYerEkSYvScpWFWYSTv1pqFO5H5cvSc7zE6x0BcptF0g==@kvack.org
X-Gm-Message-State: AFuF++meJPuGeF7cYQtjpvTIJyQm69eGTWvpQIs8INgmkIXuUqxTqGXl
	+LBodwIKR1Twhm9RCf7KdfaAgjcWQjpwcpc+b8L8qjN0n5xV64g4UxJogz8pgQOQf2U=
X-Gm-Gg: AR+sD12HwW/O8sflFiOjY4w3pE6tpU0SIju+G1dzrRovzH5dQCJfLgUMuHl0f64mBrE
	PRJbi4MtD2InY+HK7i1mfTmQXRbNqK28q94jW20qvfUtq967XrD8zH2FGVa+lgTGNY+SH8KdS91
	sUM0HPRFXL3H6AP+kZ048uI98CWGMqYHaRMc7ecj2a32IbZJaaDFSXh5CnJRUvQOu8QFlAVNYr3
	cflOpefL+wrXb4N+b5jtlEWGuJrnr6oAC+vm2ZgBYBlh1HBIsQH+w9975YvZFrWT+CVx9bAEkqQ
	J0yWz8Ihw4n8VjyfuVVQD0eFsl9dKS8Vl68L4509fCua8ekXtKDKDfdP20gAFZzJOH/t0WLdMDI
	bAOumUxvRQk5IoIi5n8E2VUiAR8eUjKu9RR/XHdxkEz59FyA/Qy+cvxupWhV0RW0HOW2JRp5nCt
	CjqZjdwoDa0wj4wl9U3AcLPvAEg5Gh3cqMX6YPp5n0Kd0qZVPz37E6osT+rv7i5UCa9Oe/3YZIT
	g==
X-Received: by 2002:a17:906:eecd:b0:c24:6382:2648 with SMTP id a640c23a62f3a-c24e2cdaa43mr742664866b.5.1787659980407;
        Tue, 25 Aug 2026 05:13:00 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24966f9c9fsm1859755666b.39.2026.08.25.05.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 05:12:59 -0700 (PDT)
Date: Tue, 25 Aug 2026 14:12:58 +0200
From: Michal Hocko <mhocko@suse.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcontrol: remove unused memcg parameter in
 calculate_high_delay()
Message-ID: <ao2Gyjq7VvqCGnZD@tiehlicka>
References: <20260825120153.1405-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825120153.1405-1-hongfu.li@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DE94C40007
X-Stat-Signature: 3kxjfojsxnq7198txt4zfza8jm7t3oxi
X-Rspam-User: 
X-HE-Tag: 1787659981-216294
X-HE-Meta: U2FsdGVkX1+Z8TMpai3Qf52LxWxY1THc9JSm3G09drXkeCWnFVw/phIB1ue2zYz9VlX/1L7PKBO9AY84ncwgriCFPgJsHB/X0jHyASMNCUqnELa1F+8Emg8ksyHvXjBYXafuNJe20l2GV76nBVeGym8GDnCvqN7Lr07R4hciYOp11EmWk+UjwxQ4bnijtsieL8Za1mLk7OBulRKSg9BEyXKzAVQYoD1nPs65f09czn1ufYfx+IOyMj+Hnt2bbmHxYvxwgizRUaH4jrM8avUUQgS/1LWrXVDjVX2X1B4WBMS8JxEsW2d56K3YTzQtAWWSQc1JaZ7VbNnTTD+3si+waApPl28SoSPXWyOvibI1YdSeUDygs++YDgVWaRnCNHN5MdwsW8+8A7sxMyQG9R5woLu6QvY/Or9xZaLcYqoBOPwwTCJch8RR3Yo9VN73IfovINHUr9NGDzfKyxeOHsXLgLgcZMzzsi4R4T/yypxOBQcmI1+sPgCc73iQL/Kvbuz71Txy9fMLen2RFpJ870fIHXsIpC/Du25uPQchjschH2jrNTpO8TiYNAQ3iTeHYhuL+Iem3KR00eLKdUvfWgtqQj4b+1uU271F7DdLKSs/nEeg5An/Is8KZd5nSuZAwtpCzNqcbTAZTw4Nvcrds4qCniMW2vcAjspScGUDh+cWDYxUHr5/T/a117qwfrhOYhE9c1VygD0zZn+nIBofIH2wbn/ZqwQ3ExIVwJMlYq7yGGxpnmPG08mZCqca/AorGiQwDlRrgzkKLLSES72kxuzO5RqPKsStRG/C8sUDoXWmY/ucMFzmGwjI6XnKwlUPfZdYzr7UX281p/LGwtyPr4A81t2vNEZee9raEixDkyBK2LYQHle4CqHy/nT0SNY0R2ikqmpgQO8OKRBoYRZerwTZkyPqpuv95AWXCwXzwoiD6DeJ4DCnJYHgjuM41PIejDNS1pnKd6mqU7Zg+oDP4te
 Jj3qpJFY
 MXb5zPuclWbQAmn40HunTtgHX+xWSC+4dGTgz3XF5qVymf9ZFsfhgcQbjx8K7wkWbdOi52HSCN/ODt2SpMeAk7q5g52qy0bZo20drr+tqg410O6AmyBuDfNTB0YQxuNk7XqbtWLXJq7Hc3SCQ/r0WL2gwHmYBU4GUXafFtc6o1FctkcMWyErfceML3WJVGXubbCaWi8VdaZn9SyKsgI1N3Opt0EfXDCEGW9DVy30VYc+iBWITEPY5m+j8VKzpGkoWxiFm9udnu9QxyaEPzpuAPD0FGOEB5nQ3d+YA3kpvd5sI/kfmHXpQtYYDGJ4ME5eSui0MWNe67ehHoNC+D3BoBkvq3XrhW9K1kk8HteXW+k8w0wVnwVFXLVp7YH1OIEEsE4TDe4EfllGDlejovrRO3onyeBdoEz6Xb0lBR0pVatNgYdUp4uXAqNgMSP6gr1nI8gsF6J1xXBDeazw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 25-08-26 20:01:53, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The memcg argument of calculate_high_delay() is never referenced in
> its function body. The delay calculation only depends on nr_pages
> and max_overage, and both callers have already obtained max_overage
> from the same memcg.
> 
> Drop this unused parameter and update the two call sites inside
> __mem_cgroup_handle_over_high().
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  mm/memcontrol.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11b85f4b6828..8bdb6988e7f0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
>   * Get the number of jiffies that we should penalise a mischievous cgroup which
>   * is exceeding its memory.high by checking both it and its ancestors.
>   */
> -static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
> -					  unsigned int nr_pages,
> +static unsigned long calculate_high_delay(unsigned int nr_pages,
>  					  u64 max_overage)
>  {
>  	unsigned long penalty_jiffies;
> @@ -2594,10 +2593,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
>  	 * memory.high is breached and reclaim is unable to keep up. Throttle
>  	 * allocators proactively to slow down excessive growth.
>  	 */
> -	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
> +	penalty_jiffies = calculate_high_delay(nr_pages,
>  					       mem_find_max_overage(memcg));
>  
> -	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
> +	penalty_jiffies += calculate_high_delay(nr_pages,
>  						swap_find_max_overage(memcg));
>  
>  	/*
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs

