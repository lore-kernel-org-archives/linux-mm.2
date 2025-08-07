Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53C9C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 11:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD306B00A3; Thu,  7 Aug 2025 07:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D1D6B00A6; Thu,  7 Aug 2025 07:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BF66B00B7; Thu,  7 Aug 2025 07:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 14DFC6B00A3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:20:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C35CAC0B9F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:20:58 +0000 (UTC)
X-FDA: 83749719396.20.A7EC1E2
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0A6A80004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:20:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KqslTqxR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754565657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ddfW087BVCo9R6jS1rE1MnNhGEOPmweIEOxT56WjhsY=;
	b=ZIS4Q+xycIefHZq72jRN/wn4A76YIYgJLp2SKp1zMETHqpAAV7Coi1lNnvSRWgkBkTor79
	4pfU1bgDvfRMpBJ0l8adi5YXsjR0v5Z5OjVVb0vd9c9sk60GH5PxVVlIZLejyxyKvINx5H
	fAeBaoonkEgRpEhWr6jiA4FiOdItwfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754565657; a=rsa-sha256;
	cv=none;
	b=jbwzq06LBSEpnFulPn84+H3MrRvJIhLSFryOVG66mfaQ28jUJrTXyUKukkaqX9H77PXJE3
	sY3ND59E4hzHrj9vuKcKJ4mVyEL88YTiCEKG8MePIwQWLPGeqQED+48LVble5a4xuCthb2
	jaCQIwl2wV4h+h2z1iPUjViyh0EMNKQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KqslTqxR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3b8db5e9b35so429575f8f.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 04:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754565655; x=1755170455; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddfW087BVCo9R6jS1rE1MnNhGEOPmweIEOxT56WjhsY=;
        b=KqslTqxR+7u1gkXh/A+HPTl4VZEfDrP0lP7Jt7WkK1rQZBxDSHeVxcqJcwdYTHe4wu
         BUoJPD05AyMC6VZDkG3QCmznDuV551vyrd0MJBzdm+JF+3zbvDYV0TP4tc7zjNMMNx+N
         oobgCirvDSp0AreRcEVniLoYa9cfACQE3G9xbRVxP6x0MnCinSHK/N86ye0kmv79bvkD
         EZhKh7Uij0hlXgLs5WeLkiEubQXydmiuCT9/xHqfwB8CaPb6NCXBwPCux4Jdvp7n0vq1
         ud85IRE0BZNigjJT/sxENurckdEN+zc89xAK9neMH5zBMsqXKOyF+wD3iF3yK2gPM7b3
         tZwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754565655; x=1755170455;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ddfW087BVCo9R6jS1rE1MnNhGEOPmweIEOxT56WjhsY=;
        b=B/usp/jIc23bIvQJZY9G8SCsvheSFrOHf4oxvnTr+YcjgY7THdiSPb1Tz9vZUWWmkp
         0mg+ee4OAf2qKhpKtx5L7Dm1w068XgnQMcbOIRmq0LIidQCVAK1DWQoVfsItJEbXgMKG
         bFzUZlT3YEdK+HmYAxYqRW/2M9tMk9iF5JvhJdtKMda9HNfG/4ou0hxbD+ZSccw0qWP0
         2gGYG6qNgiV9cDWmuRU2x8NSbbsTEAiYDRz27SXDHpkJ1ZlMrjdApYKUhplsCGsmne8G
         Yv4/cNVJvUH5PWbccqz7zsa3sfImMB+nlnhGTUrrW2GsHFvVS/ZY8r5QIVY8PWrZty9d
         l1ww==
X-Gm-Message-State: AOJu0YzE12Lc6tdLsAW7tjKnu9GNs5DjmNAW+EPTsTMHkEoUpzlFAhpD
	VIGCj07kCtT3M97BZwDKQupqlAaJOZ4YK6+/rfTgXcTbrTGGlhMY4fDd4nZo+kiNQA9YWDyyiIl
	8kea3xDo=
X-Gm-Gg: ASbGncuAwjohXZyU6Ii0sLf7wGYaqtTijQ+d+Tizv0FMbmnX8Ibky/76rRxmmd2tWz5
	LlO+/iB2AAxAPJqSsx2DsmsLPI4Zdh62DWLgleT1ZhnauUghfxOhTmiunnXhFnzZSz4SawsuheS
	RMTwWp+J5aL4B77JT9/JG/jb1tMs63LNtmGkztuYzm6qn+1oCyMK2T7kZ5vlohJSnbdvdUhzd1P
	n/InerZorbh7yqqpAk9ObMFRYV3AKBVKv2k+gnPuDHb5dk5J4K3pcDcPWWljEqPu8wAbqkK/rQl
	/HwSeuFr3n8lqyS24GLWWSFPzu/mYBHvLHq9ZpG49gArKRpzkqQIxC8UneUfLg65Eg+Eu1Bw954
	WS/kzmjkQlDUoAVV+joA7vEBKjwPTgclfHEg=
X-Google-Smtp-Source: AGHT+IHOu/dkjQy4sl03HVD1C9gSx90Y0R1uDAO4yyw9e75J4od/tpJNEfFOepafebY+xXR46niLqw==
X-Received: by 2002:a05:6000:1885:b0:3a4:eef5:dece with SMTP id ffacd0b85a97d-3b8f41ab66bmr5864243f8f.35.1754565655344;
        Thu, 07 Aug 2025 04:20:55 -0700 (PDT)
Received: from localhost (109-81-80-221.rct.o2.cz. [109.81.80.221])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c3ac158sm26896024f8f.4.2025.08.07.04.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 04:20:55 -0700 (PDT)
Date: Thu, 7 Aug 2025 13:20:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] mm/vmalloc: Support non-blocking GFP flags in
 alloc_vmap_area()
Message-ID: <aJSMFgvrLEN-nwdT@tiehlicka>
References: <20250807075810.358714-1-urezki@gmail.com>
 <20250807075810.358714-4-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807075810.358714-4-urezki@gmail.com>
X-Rspamd-Queue-Id: E0A6A80004
X-Stat-Signature: ao6o8itfduxnciuhoeq14pmuirytr166
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754565656-758529
X-HE-Meta: U2FsdGVkX18RRpVygMY5+VPye0tzaddc4Sy8OepSeYhVhyvJwTSqImRrCu1+k41RVD6kZdF09HEb7LXXD+t7Tu3JTDcbpKPL+8GN2rja+EAmpp0sFWjlS5CvelIol6BMP4WjI5nGdbpxZivSYnr6uZSAEZWX2Q8EBy7o+wdiM60StLKHIx8UAScCABjafBXyReWimA2LPWDqRzjsoOWHb8LwN5lDES43XDluCydn1fC0iZhwQe9RiWivDSg9WLDlc4DaidY/VXymrEQAjwZw5k6lveFL4TAoTnSO4owcF8yw0VeLD9Sg9IpWS6a9gyHJNdiljTqLwGWS63OkQTPfh8sasb5vrZUEKF6Dq55npqaT4vAgHl0k3yDJu33K7qbNqESzN9f4gb1E9vmt+FT9ahkVn/WtHhAkgNC2Y8UAdQKmzFkfqKvqQJtyES+WDVMJ0yXjviStbuNQ1lconZxEk4pPR3Zzthw1n08fgtRrd3QeV9EE0h740vw1lGZt//S5VJ285O9B0B1vnIpzz+hYIBqhiCXnv7X6t6KtdY1Lf5juIU+aDVsLg8VifKF4SEO8OFH0JA/7PQRz0+BZXrfl3rHm/Dse0cuWuTGrb2yG3DpEpYr0tq7yt6TVQZYIHFFiSkpSuAgy63N8su2X6IlTNzrctBgkZubVOSapZQPzmT+Ib2CQGE5cd1/C4pBLUAE1r2jIKo/fIpGkiID38b6hFd2K9Ql11Dzav/DAjfyGSulg8uptXrGaUztCDV8Tu3QfjsNYw7sJjIq3ReqQz4KJLyh3zyUZTGmszk+O79Zyi0HyBJRfFNWpZdVXY3lpWkycs9aDSIZM+rB5o0I8tLcRQPFmEuu1eLAinfSXMRiXpCHpfxzp3d5nSkU6fjes1tzur1vPbb2hq3dhYkoX9bwqP/JaN4nCxzsz5BjVgCZkzbRGHcvTnYPfBUA8i1OJATNqR//0mE4P7Wgc2hx+yWR
 XmFVPSVS
 dFrE4oD07K3LZdrCQxgExUj2qSTLEf3cl/OjnwE1gcQZI9f66m3M0Oh+rGDy6bhn013UqOCBX6Vo64fa7SrjMG2zhr4ivMw8+cHrCt+egOSy74b2DtbH6oYvNX2lZNvTGl/QUnhQQGeDoJfkL+BY+whfvrPkJILU9lxAVnjS6CIHvx0GKF4M+pDTGk+oplnt2kymleL1ykeAYLClLTh1GONBcf3ukNj6ILghefEITmT4XrSlloVhLfUFfPixMfLTodIxtZ/pz+7Qg6u3N28i/xLDxR2MLb0kqKrcXbfQBGZ/eaPHFjFsyDJarKxUhxKQDD0MuZy6lTcoGOxpXMn3ZOqxXR7HXY1xtO1WkIqyvvr47esaRI/8wlnrX8Dtr5X7qfdWKTGub/UajkBvi7UDmrgtsx1ZlOUCQZKdqjvNxezrjj6T9jiNnpxt6lFI6FhIlndwi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 07-08-25 09:58:05, Uladzislau Rezki wrote:
> alloc_vmap_area() currently assumes that sleeping is allowed during
> allocation. This is not true for callers which pass non-blocking
> GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.

Those are currently not allowed so it would be better to mention this is
a preparation for those to _be_ supported later in the series.
 
> This patch adds logic to detect whether the given gfp_mask permits
> blocking. It avoids invoking might_sleep() or falling back to reclaim
> path if blocking is not allowed.
> 
> This makes alloc_vmap_area() safer for use in non-sleeping contexts,
> where previously it could hit unexpected sleeps, trigger warnings.
> 
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

With the changelog clarified
Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/vmalloc.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 6dbcdceecae1..81b6d3bde719 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	unsigned long freed;
>  	unsigned long addr;
>  	unsigned int vn_id;
> +	bool allow_block;
>  	int purged = 0;
>  	int ret;
>  
> @@ -2026,7 +2027,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	if (unlikely(!vmap_initialized))
>  		return ERR_PTR(-EBUSY);
>  
> -	might_sleep();
> +	allow_block = gfpflags_allow_blocking(gfp_mask);
> +	might_sleep_if(allow_block);
>  
>  	/*
>  	 * If a VA is obtained from a global heap(if it fails here)
> @@ -2065,8 +2067,16 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  	 * If an allocation fails, the error value is
>  	 * returned. Therefore trigger the overflow path.
>  	 */
> -	if (IS_ERR_VALUE(addr))
> -		goto overflow;
> +	if (IS_ERR_VALUE(addr)) {
> +		if (allow_block)
> +			goto overflow;
> +
> +		/*
> +		 * We can not trigger any reclaim logic because
> +		 * sleeping is not allowed, thus fail an allocation.
> +		 */
> +		goto error;
> +	}
>  
>  	va->va_start = addr;
>  	va->va_end = addr + size;
> @@ -2116,6 +2126,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
>  		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
>  				size, vstart, vend);
>  
> +error:
>  	kmem_cache_free(vmap_area_cachep, va);
>  	return ERR_PTR(-EBUSY);
>  }
> -- 
> 2.39.5

-- 
Michal Hocko
SUSE Labs

