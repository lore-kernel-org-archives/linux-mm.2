Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B55C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C066B038B; Sun, 16 Aug 2026 23:15:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F5F6B038C; Sun, 16 Aug 2026 23:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45476B038D; Sun, 16 Aug 2026 23:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BAA546B038B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:15:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4091B160624
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:15:55 +0000 (UTC)
X-FDA: 85109297070.08.CABBD03
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74D14180005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:15:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DZL+GvNE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786936553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mP/kw3LMX/NnG5kUH90aD438amd9t1MOlcI7a9rTuLY=;
	b=Q5/gFTnFqdPK6lQnCdwABl2nXCPI+bDU67iwgEno7SzhqJcBC4miy0y4m5nLoBIgBadkWA
	GJmzq+In5t6sk3sjx8MVKKbwJ8APLkV4uGIx7bxlQw8d1f28ax3vHyf3BWSthT/ptf32Zi
	K+RP0edXB+ugd0ItYMuLQuy86n6MTPs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DZL+GvNE;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786936553;
	b=8IN8AZnTOq2+IO53mcdjuO3xLNIzSXzfVn8XYvyeTJlpXVkrzQndaE2qURvIFzwTKcs4BJ
	7i8NEWGw4o8rvhfDyfGDY1loRKb30NSKFv/tw+NiU5xmQo/GXd5qL/0GMaaVOFZbepKF8u
	o6AC5VFbn+OqwXrhGVwktQM9I2En3Jw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mP/kw3LMX/NnG5kUH90aD438amd9t1MOlcI7a9rTuLY=; b=DZL+GvNEdhD9zaGDTf3tLSh+AS
	G//kFXPnun4Jx3eSwfguz93Zm3HZcH4+j2cdQ6mJct9apx28h+4EoTsVhg9gX+kjE6+BlmwBAJzqs
	cvgpLvni5tRZZgZv7H/1u5120PX+12EujCPQoebEw7/bTGcu2AbpeUAZwj3UyIY7CI0iVpKkkNasW
	RHrwWduslxmQn3VFO7qMG8pw/bztKxGiYOI7Mfg26C5/NAM2EQAkjVexANHwz7VTIfBrQOfneH/82
	MTOhp+ST1s4CSm7gIiVVvjs/0nNn6HjY+5JdelRmbCOY2mxWf0lcIcKfJobavqtff8G8XKDvQlN9d
	crHsFBDg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wvnp8-00000009PbM-0xVL;
	Mon, 17 Aug 2026 03:15:42 +0000
Date: Mon, 17 Aug 2026 04:15:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, zhuhui@kylinos.cn, joshua.hahnjy@gmail.com,
	audra@redhat.com, bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg
 offlining
Message-ID: <aoJ83tk7R1x3Jul-@casper.infradead.org>
References: <20260817025917.66233-1-husong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>
X-Stat-Signature: eg3k4yq79c8g5wm5nzw5epy48eq7exr8
X-Rspamd-Queue-Id: 74D14180005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786936552-275853
X-HE-Meta: U2FsdGVkX1+vHu7ifzWzxAL/tsVzT2+uTIxsHDonrDQYq6XVKs9vTYikhLj3Xn8LV9VkWceOwffQb61QpKd5FJWQIBuqCsaMTv+WVucVKL2KGFugfV2Q6aiz60MVGnekj0tkCZK9Va+uv5ksTRdooZdiAt4t/Ayhq6xhq0d03epr2pXUiw4nTXGE3b4jmaCOW32DlPh7ZWbilal+nV8XeHq/urwbwfSrqVsYRrmrj1RMfufhy0ocWCvzUAqVhZ9a64pP1qMkzeLMwF7mSAjqiq4UVxMKa7AYho/cR05J16GmU3hxdkfJ03MwNfH2/IWaipYjy+1zX+Al+33tU7klnUtyNk3DLwT0FI9Mi7nhLd27vtrGN89xxTwSOAUWmItkz7F8xwZkDsNE6d5XJva7vVMRXH/l0HhKhaSjsghCtKj82qu132p9J5gFN9muD/zelB+1D+tkfMgMIBZEKl2sz4XVN65SXQHeNYBlh3v1h38H6lKkkq2mdGV86x5uQZxmw6eEEEJ8ej3Y73aZ/99fRChV9Tkz6R/nbJDvPyaV3uWD1tILvKHmTKtP67KmoDFJxIkulZpQKtXUyEOVOJl7hB3k80k4DqAbhrBmJbP3WsDWA9s0XlWa8Qo/lFCNBXZL1KmnCub42ptmcTlX124UWf9Ud8CbU3a8CVXiPIwByklgKBD/IJQwR8U7RB2z4PvcghP/gvcue/V1Lbo34/iuVXYUflHD6Je978/0T1GnBfWGSXQdCO8DD1JqB86RiEdkjn3hK6fUbpwmM8577Xydl0QEK4GhUhFwQHh8Lvu6FSWPG5PMAz9Sm7PhqQlJLcDAncH11HRE4cMS4AvvxXT+rqp8omJGJEaoEPdqNoriq3JNW3cIjUhv/qe+uZO2Gvn65C+Zt5OCpRnWJnMhNv7Lsht8lxIq0cG3cDljlBZuyJmH9/3runjiy7slztg4BbigMgu/XkD1IENzdutwq45
 1T/nerYH
 KbX1DmAJ7dDKOZ5R/ms3CCu/3OrbXOmtVy91HQH3yXOAXXGYkkiYwC0/OhBiUOsQdIYN48f2TY6eFSy7KvyNqAvwLvI02JJ/fJhghoAVOSwCiY23CA1lDUkQQ40qV52q6+GjQQU+ooCNOAqqGGTmarOjA5elbbAY8Tkg+/TCQmmNfKgKkATnXTOkmo+/Eow5dCSn/kUNlDZ3FDNL2xW7J0ix7t1bUcooLMfjtwjUEDwSXUDlHxNocUBt2vgKT8GZGIfB7tt48/jzzDqJPkE6cZvY94NngBkPUo/uuMZUpNuxJceh3K0lUx+mp8fVRIjj0X5vV/EhI0yld5O798KcL9wfZsJoQsnoveLFuqTOU3GGdUpG4rccF2ruC0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 10:59:17AM +0800, Song Hu wrote:
> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
> the offlining drain is a no-op for them: the pinned css reference is
> released only if the slot happens to be evicted by later unrelated
> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
> in the dying state indefinitely.  On a CPU with container churn, a
> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
> 
> The sibling obj_stock_flush_required() has no such gate: a cached
> objcgs slot is flushed regardless of its byte count.  Drop the
> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
> empty slot is a single css_put() and a NULL store, and it happens at
> most once per slot per drain, so the extra work is negligible.
> 
> This is easily reproduced with short-lived cgroups pinned to one CPU:
> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
> across later slot displacement.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..b931ec16bb82 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  		if (!memcg)
>  			continue;
>  
> -		if (READ_ONCE(stock->nr_pages[i]) &&
> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
> +		/*
> +		 * An empty slot still pins a css reference which
> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
> +		 * to release.
> +		 */

I don't think the comment adds any value.  It explains why something
_isn't_ there which makes no sense to someone reading the code.

> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>  			flush = true;
>  			break;
>  		}
> -- 
> 2.43.0
> 
> 

