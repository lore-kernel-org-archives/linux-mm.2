Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB246CDC19F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 14:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A086B0093; Tue,  6 Jan 2026 09:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33BB46B0098; Tue,  6 Jan 2026 09:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E006B0099; Tue,  6 Jan 2026 09:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 123FA6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 09:00:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7EB3138337
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:00:43 +0000 (UTC)
X-FDA: 84301699566.03.99700B6
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 94A8040017
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:00:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G2NwG1No;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767708041; a=rsa-sha256;
	cv=none;
	b=l+9fuGsgzM1OPjoFULcHiE3chXnBA493vCQE1JV+HRhsV/2RS7Lvx3DaRkIodJBwoaL3gH
	cbOArUqrhbxSOX/yTps+TJF6cmANowWLm4JAy+6+37jD4uVaC4B51HsKN8u2qYu3sb6fhu
	Idrxn3TjSlZNf7rJoXI8EN8jwiYbJ7g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=G2NwG1No;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767708041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qD8hUJoWpmRPh3qLUw4WPXMyrpMQhfKMlK8mtIKaFIY=;
	b=uGx5rrRHjSqSxku/zVTsaEc3B15iAT5sL3vopx05M2vIM19DgHxriyrcGY28XgsrZwZUnQ
	qyBK1jBd9a6/nmeEHvHfeBUMqDUm6ARTs8TGfXni/7M7QkYegCxFkJ8m2+WJ5gWFmwxE8J
	MEWbQ6fbUNURvPLj3dXKGtSW1RtoHHs=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso9443135e9.3
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 06:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767708040; x=1768312840; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qD8hUJoWpmRPh3qLUw4WPXMyrpMQhfKMlK8mtIKaFIY=;
        b=G2NwG1Non9hN7MiDES0RSo7gFO/sSg64lzICSpD/kn9huw/p/JtbisaS8az3xlC+9s
         50oaXT+RIbDiOvOWUw2mpoCAuui2MLlFiQs+Ve5faVnBbDKVK6+yWYWlbIlnLl96hlQE
         /YILvzyGBL8vd2Br7hDVHP6Xp3ech6V8pH7xmtLjXaBHRlJGqAOk2Dna8casjZCmuB9Q
         4hOhkt1p3e1GzH90pBHjxToqyYsRSSaHtx77AZ/S9lEbmJEJTIa2cbJzaXS/CGcYL/4i
         9zHxHIfuz7EIARtTQAKTDje0Kjp5BTFqv1Qdxqf49xFmdu0SFVhGby2wTLVnCn9E3f3k
         Z5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767708040; x=1768312840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qD8hUJoWpmRPh3qLUw4WPXMyrpMQhfKMlK8mtIKaFIY=;
        b=dYoLSRRz7oO7lu8wQHqZ10/+0AKXL1A+uEbtebVeSX/Wk5I4B8jRAtbrIXIsstK+qO
         4ja6bENHbVgKQtPKJUFpINZfrhAOVWmBmzuG+7r0WEVGWPR2J46BbiW3BrH4bXlP1xcA
         y8gFrWVN5pX+bceRtswAevGwaOxOFKE0Y/FwqDwqbIcm1A6+bt+JtT8O1TcTIIwSG0hG
         ABSBzAPMdfKFEcmTPmLazGLsnU686S7wxxI37JkHJbcWpLAr44k6XGeDPqpaVF+HzFra
         aWq0zqwFRepELLa2pYEW2i+176Lw9PmKlePZCMB3hmtlBuprRr7V1ZyflgK8CinGGse2
         Uk+A==
X-Forwarded-Encrypted: i=1; AJvYcCUmCawCQKbPpHBztL3J6N/mEMiNZGOImi9Jnd2uFg5siKnPVFQ6lQ2RWAlPUCEB8WMn1CI4JNR+Xw==@kvack.org
X-Gm-Message-State: AOJu0YyWVXHhrDjqvg+cTDyW7YGEHSHA/TDpFVEFJuSvZbYYIrY0ZYHf
	flsp1swqcyiDc0iR+Zs/OEP2CPFr9lE6ycay7/xwhtLMFosky+qBrotcFAxDEF0/wn0=
X-Gm-Gg: AY/fxX4RdjkMyXHZbVSs62aFzaExOXdjuuy2zRFFHnZV0n7eTwgKBiX/L/psZVBrZrJ
	aoK1pU7jMNeX6Dmr7j0a2MIaYWvLQeyaq5xkp2uuiDrsfc4YU+o10o09u0isH1Dtjw7Y4+uIabw
	+hM7yFE756xEXqOGxutF3wL5lzN8N6UkfDvq4q199bTmw0c61aILZxNdxti7Lxk5zAY7L/+U9UT
	3l/SVrYgKwGgt97mIsO+1yxmhrBOADszZ7kxnHu87XbFyO+/TTlbHGR9fYGGXYycgw4Epn+23ZK
	IzpM4zwoTlf04EjKT1NCIx+fkykVP7WQ3Pz44phvtDN1klWDk9brriYVTWxXTaQwBCbSpfrvhLB
	m24X3RZbM5ofmzPEp5ayc65L4Ygdt6FgTWPvgs7J8HSg3LIZFdVMhHFh2yU5u+F49/P2U9QphBU
	RJ76RVC875LlN6M0KW2qcMIOfB
X-Google-Smtp-Source: AGHT+IGHQFZt2QvFYPr9z2ERUKepowjPPfzDfhbLzQI8A0YPz1euQTjI1RCGsUbf75Xmp/4xK6snFw==
X-Received: by 2002:a05:600c:4e93:b0:479:3a86:dc1b with SMTP id 5b1f17b1804b1-47d7f0a9556mr30131465e9.37.1767708040017;
        Tue, 06 Jan 2026 06:00:40 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ee5e3sm4534181f8f.35.2026.01.06.06.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 06:00:39 -0800 (PST)
Date: Tue, 6 Jan 2026 15:00:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable v3 3/3] mm/page_alloc: simplify
 __alloc_pages_slowpath() flow
Message-ID: <aV0VhqzLHnTWnZ8a@tiehlicka>
References: <20260106-thp-thisnode-tweak-v3-0-f5d67c21a193@suse.cz>
 <20260106-thp-thisnode-tweak-v3-3-f5d67c21a193@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106-thp-thisnode-tweak-v3-3-f5d67c21a193@suse.cz>
X-Rspam-User: 
X-Rspamd-Queue-Id: 94A8040017
X-Rspamd-Server: rspam04
X-Stat-Signature: iktcus58wj6xiok4wxp45zifo96f7xq7
X-HE-Tag: 1767708041-867025
X-HE-Meta: U2FsdGVkX1/KedvGVTE5dWBKFm97LrnOKkIF2X+0vZmcNuWHb7hTh3iATWUNQ8xOqHbB3kiZZBgogkQm7uyqo00Q1FkCn7mkCmKqFrP6Cn50qRWicUdgquYbNS23UJU+pExPffUNaHYNpOWkrI07sNGBWYwNZKUtZFnJRRrw7aYQJg0xuZx5zx5e2KvFCcCQy0rfYMgKftdHjJjElutSBy6u9r9DbE7OZuP781GpFhWDhWdpYF9nYKMpzbkdZDvXbd/l9MH9y6GZZe3hU0hCdohxJ6ckHR+O5YHlRbS7Dm0nhvCUi7tTh7emyeglLEjljsCU2XKPxeVpWK660diypPQwl748c8IPFpldOvPUqsA9Y7D7lmN8rqUTx9/5/NQgTJIlkb1SBFILAxhsj6ilkf+Gaagy9IXTUuWFnzHlBokYYX0FyCMsuccwfhH6ksnPKd2IRMbXnoQZ2VPFfaS2R8WQYhiz/LYS4sil/esaiMI/nBCT/UgZ3Jp+2Yi1cla8loCw6kOGG41s5od6AKa8oiOeRDhlMcEfg174JNb3L4sh5/vAmAuTNopIB9bPhAu+4Zsm0c5RVmk4EgG3Jq3eGtDT5cYtCL15VmC0UNtxe5KXeqoE7gATz9dytLf6aCyN+tF7zwLRn8kJbBxKgpVSLLQtRufpViP4fRyUP0igorKG2aPGRjMz8iXa3NCYEnhSDsy1uTBBYccXb8YjuIyQwasgfFvxoJXvOc937+bD/SXmhYnnHCXwZW2BG7OTPlv1qmpi63vc+lhOXBP8O3YTI4pnaBdnxYAlFhdMHE33I4CqyzCAyEg0uT0HioWbQPW5KnE9YdVr0apzObHN3K7ShG5DDd7pZHPaFW4I7Sy0R8jY2WuuJsIGKlDGhEW/sDU1g6N8hpCGMHe3CdK4BT+cUETBxMNPpZjoDNmkq7un1u0FtvvFOf36q0roWFMGVPWPLUXOCn3slqB42v9sXT2
 iK6yJ48Z
 1iNYRGViUifdIZk+5Y4eMnZFtkNhxuI9q8eOqGkDOA3j8sVoGDnw7Jss3Qr13QR1DNRD8O0hlhx8bwS1dWM5ScTP0MVYfr9Dqd2Hw+x+wypYP8ozlBqBZ4p0/6oHgHfgxU3X9xGOEjPC5JWMdLnVTQMwzWLONJk4O0bdcvBIJT3MTKGwNyEiKxuOGwLba/5TutQOPybba08ms5815zM5H1hpAizUl0t7q0Inaw7z77Xdi8DOnBsZQZSp53drHaXFTPgN7StnqQiOxtLccsf40OkYATC4YAsTA8Y7IHjpRWSI5CeESsM2p9Xq6UHKSKP8SA+7QrevuVBiY6xhRvapYT3jvsMhjUF+3ev4p04m6U921EH3qTG40QpEss1ELy9GZv5FJD0f0V3wzCzasq4GsPtsy1pjMuw5SKYuq+GejHbZI3jKgEDNEJaPP2MlmVVRQrO332reOSj+LLhfs+40Mtq5HxeY6QFy8jgNVUHGUGRAQdJDKIjGikotEv2C3nhVEOyLA2tyFya2ti1Bt0qHd+jYzxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 06-01-26 12:52:38, Vlastimil Babka wrote:
> The actions done before entering the main retry loop include waking up
> kswapds and an allocation attempt with the precise alloc_flags.
> Then in the loop we keep waking up kswapds, and we retry the allocation
> with flags potentially further adjusted by being allowed to use reserves
> (due to e.g. becoming an OOM killer victim).
> 
> We can adjust the retry loop to keep only one instance of waking up
> kswapds and allocation attempt. Introduce the can_retry_reserves
> variable for retrying once when we become eligible for reserves. It is
> still useful not to evaluate reserve_flags immediately for the first
> allocation attempt, because it's better to first try succeed in a
> non-preferred zone above the min watermark before allocating immediately
> from the preferred zone below min watermark.
> 
> Additionally move the cpuset update checks introduced by e05741fb10c3
> ("mm/page_alloc.c: avoid infinite retries caused by cpuset race")
> further down the retry loop. It's enough to do the checks only before
> reaching any potentially infinite 'goto retry;' loop.
> 
> There should be no meaningful functional changes. The change of exact
> moments the retry for reserves and cpuset updates are checked should not
> result in different outomes modulo races with concurrent allocator
> activity.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

LGTM
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/page_alloc.c | 41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3b2579c5716f..c02564042618 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4716,6 +4716,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	unsigned int zonelist_iter_cookie;
>  	int reserve_flags;
>  	bool compact_first = false;
> +	bool can_retry_reserves = true;
>  
>  	if (unlikely(nofail)) {
>  		/*
> @@ -4783,6 +4784,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  			goto nopage;
>  	}
>  
> +retry:
> +	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
>  	if (alloc_flags & ALLOC_KSWAPD)
>  		wake_all_kswapds(order, gfp_mask, ac);
>  
> @@ -4794,19 +4797,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (page)
>  		goto got_pg;
>  
> -retry:
> -	/*
> -	 * Deal with possible cpuset update races or zonelist updates to avoid
> -	 * infinite retries.
> -	 */
> -	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
> -	    check_retry_zonelist(zonelist_iter_cookie))
> -		goto restart;
> -
> -	/* Ensure kswapd doesn't accidentally go to sleep as long as we loop */
> -	if (alloc_flags & ALLOC_KSWAPD)
> -		wake_all_kswapds(order, gfp_mask, ac);
> -
>  	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
>  	if (reserve_flags)
>  		alloc_flags = gfp_to_alloc_flags_cma(gfp_mask, reserve_flags) |
> @@ -4821,12 +4811,18 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  		ac->nodemask = NULL;
>  		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
>  					ac->highest_zoneidx, ac->nodemask);
> -	}
>  
> -	/* Attempt with potentially adjusted zonelist and alloc_flags */
> -	page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
> -	if (page)
> -		goto got_pg;
> +		/*
> +		 * The first time we adjust anything due to being allowed to
> +		 * ignore memory policies or watermarks, retry immediately. This
> +		 * allows us to keep the first allocation attempt optimistic so
> +		 * it can succeed in a zone that is still above watermarks.
> +		 */
> +		if (can_retry_reserves) {
> +			can_retry_reserves = false;
> +			goto retry;
> +		}
> +	}
>  
>  	/* Caller is not willing to reclaim, we can't balance anything */
>  	if (!can_direct_reclaim)
> @@ -4889,6 +4885,15 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  			     !(gfp_mask & __GFP_RETRY_MAYFAIL)))
>  		goto nopage;
>  
> +	/*
> +	 * Deal with possible cpuset update races or zonelist updates to avoid
> +	 * infinite retries. No "goto retry;" can be placed above this check
> +	 * unless it can execute just once.
> +	 */
> +	if (check_retry_cpuset(cpuset_mems_cookie, ac) ||
> +	    check_retry_zonelist(zonelist_iter_cookie))
> +		goto restart;
> +
>  	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
>  				 did_some_progress > 0, &no_progress_loops))
>  		goto retry;
> 
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

