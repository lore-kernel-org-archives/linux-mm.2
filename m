Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D25C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724606B008A; Wed, 14 Oct 2026 16:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D58D6B008C; Wed, 14 Oct 2026 16:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4136B0092; Wed, 14 Oct 2026 16:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35DA46B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:29:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF2501C4135
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:29:41 +0000 (UTC)
X-FDA: 85322372562.17.6F0F166
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA2B420005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:29:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="nRmaa7/x";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792009780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8KpIQc9Vyaph3vkgeCaoJ68oVGAH4Ek85s5zfjWhrac=;
	b=0HxgcghnGKnkSdMzTQn+5K6AhvRZRsPzTEjLpDN2iC5rADCVbc0ym7desFJYQygc3mRWfo
	mzqEsG9k84bDII7dVLVYV94ly5xmABd+DVR2ptf9YnaaUMhUWYZw66ARffvfc5PM+kU+gM
	D04UFIRxomGMSaAXwi+CTtk+4p5XNmo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="nRmaa7/x";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792009780;
	b=PuYf3KScbdv88UguPqIsW5USpnstjh1TiCQwFc3s8RLfE8ScDKAE6oAitbdD85u6Jj8m3z
	Kw+D/zrTBCVgG3Diy+2pM4Ed+zMol3mwekKlQBuNoOiFjubMPV2JgcGwKUny/WcEs/wlXu
	wK/UYDStpLpTO7XLDu1tO1ElplLIx58=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-535853983f0so43819741cf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009779; x=1792614579; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8KpIQc9Vyaph3vkgeCaoJ68oVGAH4Ek85s5zfjWhrac=;
        b=nRmaa7/xSynSngMMh+fk5U3Q+JydonLBtr6V9drGZOPW4e9LdwqTCz5CeLpx2ZfxHs
         koj+NRTZhV5wOZ3HgJs5Rm7LgcPHBSmMWTdWkvvw1eijOxj5XtzlB5pxl7gJzJYqdwwy
         p33jNfGJ4zASsSLCoRbVX0YPHAkTZyUk0OrEKG/F1QOT29oReZnEi4MXrTG7z64nXCp3
         EJuhbB7g9cKq9K7x+fKq66hIh2v9w+uODgKcZHZ6nWnniwJGAPI3oe36yc30hXTeANwe
         3Y/ZLPEwbheQ+Y01UHT+U/9aANvM4fcGf499w32ykx8L5pLllGeC5KVXofekimnCU0oy
         Nsbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009779; x=1792614579;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8KpIQc9Vyaph3vkgeCaoJ68oVGAH4Ek85s5zfjWhrac=;
        b=QG2Rk17vj8zDrNpx3TtVcwCmgYKH2Bar91DPwfBlU+T91mYIU+PON+7vpf6WuHjRF5
         m1fxV6ZOY+hKnDZ1m3gqUefclfT/hvwpCwUtKzH7+vAPCW9twcYrxp62nSxblG/Dgn4O
         OQ0PBzIRSsSQmhf9tH5bt8/XX/XAUb7Q6SofSXh/famsAU7uXJ9YTanJoqOWm9ZiWIM8
         Ixbl4xWYHjsBnxb18PL+ycvrMADzphby/s1Gjnh70/pGpr7WBM0Albs+ZfYQqvhWphx1
         t9WeOi1SoyoQO5W5x/N0lGxzYDe0qHkZszRI85pgcL0WnFfycwPpseDXDIaAseYJeEDs
         wGkQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0DvoCcgsZf1d2d0EhamShMYSHqhdBqqNTAKdr0foq2vt2fZ7Hj/ifr4cZYrH5ICQCObs/bdIm+Q==@kvack.org
X-Gm-Message-State: AFq9FYLRyF6Zy1wB6RUSNNXQbIwBxPy9XQF5O2xnHINp6IXTywq3ZqG9
	pElah0ccF1MRZLWJYkJ71CvPqPAwuuGczkNn4WBGUktUwtEyQuREcvIRhV1IgI5oQAs=
X-Gm-Gg: AYBFou3QDulc9JwLSi4dRdDAaFI+LQgPbKJOnzbv2tQzm/dYxH1aSY6sx5/flhVMGCN
	KJ8+BjNometif2n1EnaEIRBoIysEUg8Nh8ZT2uCVObVQeFpgSocLeEv6QivPhaGYLk7MacydcW/
	D5eKMQUZabwQ8gT7MGo9P7Kd+rXZgcEtiJb6DFt5/k2izgA9FT2y7FnRBCcJIr3mvmu+Uy/lPKy
	ZPSMmstMkp4cn9F320NDh3uQlpCxjujHBzN7itLjvQTl4MkacDaGCLRxQ7iFSfiPdrkA14UNbHO
	rdHnKZRPiqM8BS2QjVbB5YF7qENbU+heIvH09WS5xFZ9C9fxkubmyYOxQkrtA33MT0qVF+w+eSo
	Y+jTptzvLet/ZEFR/Okhc6bL67N8KpxYo0F6XIsUqM1NNEFOFxh04yq2uFP6qEMjBuXIdL18WiR
	iag8gs9krvMOw7a4rKaRarbGdkxGF9HXfppl0i5euac5+mvDUvKC0HPWoxv0I7WKA8x5cR
X-Received: by 2002:a05:622a:22c5:10b0:535:fc2d:b7c2 with SMTP id d75a77b69052e-535fc2dba9emr47727251cf.33.1792009779058;
        Wed, 14 Oct 2026 13:29:39 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5361281f0f2sm5986961cf.25.2026.10.14.13.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:29:37 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:29:36 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <20261014202936.GC371161@cmpxchg.org>
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as5q14OsbK2CmOrh@thinkstation>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EA2B420005
X-Rspam-User: 
X-Stat-Signature: 9a7tzk34jfqjhz6qru1mxomafxyizunh
X-HE-Tag: 1792009779-399056
X-HE-Meta: U2FsdGVkX1+JPk3b+bGfTKCiZcLn4Z2uvL6/XttlfPFTA+nLtVAasvMe952IdlJNM7pAdu1td7hgUs0K0/8/wQkQNq5lCyLPm5bSZIbO8YfqwS3iMcif3mOpMb9kB3PHnF4YhXcfgCIexCCwbKYVMWEnR3nNn4d3w1PuewIR3oxadu4DbMAAjX1oo0m17rLOWDjE6RQV1ZTZpH4BjqImaA25IUuWLszgNhAQ/p14ktJ2EciVqzJ1TN2+2B09B8QcCWRH+zGEjzU3STw3CtQyoY2Rx0LhyPhkDg16Jh9v5RopYZzA5oTVBysrb+GAi+39zgX7yneqWoJJPviQxw2sPC7mu4erSV5PL0s+XUT1b3wgqgaezdR09O7/1Tfws38FLGotfLTgTYpaHqbekWkYL92kC66tLuhza/C0gd/KmSoXY/WETBR59cQdicuNhwpluWu4Rjq7hwjbjEewVQWqLyJyXLuSfekP3VNClhZMNELGo4nkX5Y6uY5jFhI1hnY9MguJnKCf+GmOzXkOIAPCBRdtZuu5FTqeoRZuFnC2phRpyRMa0ZafFXdtpfRj0euy05gLi2FHS7lrtm/kRb+7zVXsGtZMVM7o2q9U1BuzntGSHSNjNnyFwPThKUF4NwPx9kBr125FAw7lzGgG79f7KF0XBePUn9rckWk9B7eATk8Z6wmLU1RvPpZOpJ7AMv2gHJIhLqa06GQxt2qSCnp7ORFxXqFzxKiS+p0n0XEk2U+4rKliVGX5d3eH5lOQtMBB/+Y3G02Y3gwxxQJJa+7vEF4x2WoK3Kdp8/ek77DrJZ7LUf4rFESjmKhconHAK7k94C1Kb+7idYLOsfR2hYh5uV126/+QYN+nx6RmOocvmmKL4WRTZtqnpW+4vKhK6PK+9egTD85wzAEhoBPOu9tZTic0ZmHgTDcj997VNkYA5bQq+dEe+/Fw0AredzafFQtIP3ZRX4xjNNxH71UIM/F
 Vjt1Iwev
 0KJXDAK8x+1XsA4WaMdak3DJrbYCs5okrEniAjrCgm/kfd39orbuJSgPSM93WwBQDg7AYGQp32s9As4MYITN2nY/49NWcg0j5ySE7hRtVE5Y9f0VOtnK6wD6nbLwsQvVkV1L/kukLo8zN4SeKg9Baixg2OYz5t3hjT3R/oqsIar62eWiWyTA3tFAe1f4E9o+275icjc0IWu/gJl66H8kZdiLk4pNPMXtqlng7WTsRYRIv2y573F1DmIai0aQ4ND4JaFPq8w6sq3dqBkVz/Q9XgohM89D4fQE5LzogPq70ArgT3MUcEFwV9DWzA64vgrUtAKYa7Pq6iUDXeOUugQj8LXA+SR8/j6rh2neoyNDEAPL81+dW2uTx7a7O5B18rOUx1uPnhdgofJscHa7ipo80q4L9tldHZTiKC6sLg9hG2Eqq9EKsxv9KK15GZTE8UUiPkCJWCf8IQOgw/i+Bn1sXq0Pw4bhG9r4yYlbh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 06:37:20PM +0100, Kiryl Shutsemau wrote:
> @@ -4127,6 +4127,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  	return page;
>  }
>  
> +static inline bool order_nofrag_promoted(unsigned int order,
> +					 const struct alloc_context *ac)
> +{
> +	return ac->reclaim_compact_order != order;
> +}

order_defrag_promoted?

Otherwise looks good to me!
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
but Meta is using the feature right now.

