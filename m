Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8879EEDEBEB
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F156B0093; Tue,  3 Mar 2026 14:35:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2346B0095; Tue,  3 Mar 2026 14:35:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BAD76B0096; Tue,  3 Mar 2026 14:35:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2C26B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:35:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EDC91A030A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:35:20 +0000 (UTC)
X-FDA: 84505755600.11.E21390B
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id C96851C000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:35:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="TeFjwA/Z";
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772566518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTHkte2RUvSWtiFL+zim574JKvRQEGOa3ktAOhw9pjM=;
	b=IqSX0M1zkBVfOrmEawBOMXBG+zQZxqDzResenflx48cjTch3yC3W9UxCDKchqJtsTJ4ZmL
	hkiFJNqEw0Nz21OrRCC9rHD1hDWStgyc5AK93oDyrQmK1I2I+il8O6BVNdZS+l8bnJZVIF
	uHsqP3gNp7FWEpFPIYT1ugfNmba068Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="TeFjwA/Z";
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772566518; a=rsa-sha256;
	cv=none;
	b=7jAcYJl2PTfGaM4+5BgCAZXe7RQB61ziiZ9u0V5oY8hHBnPSyN96jYbq8gOFMaB9eM6BIj
	uetXIlpnv9q8DAo/6OgZmtAsfCARHa5ckHf/SvbtlF9Gj8xq0BfDzyXWiON6xYzRmFDLST
	JjIzd6fibR+6DBckrsYwqEHp0oxkWpA=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a9f445cbso76152516d6.0
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 11:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772566517; x=1773171317; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xTHkte2RUvSWtiFL+zim574JKvRQEGOa3ktAOhw9pjM=;
        b=TeFjwA/ZVKKlt0EvAI3FrsZiupTdRUFFqxrWrU1BR8lvg2VH5/xBZVtoQeuHCtAyYs
         U0okRznGf0i6i9XYaDlBJgEK/Tt1ZStuzDRFbRa5GCk8OJOY567r6GsG56etQwg7y3ud
         gjzu9tsSjy0e5atysl/kIDSCewEJxF6ULfCSsgDIysc4SV/9foMfnNfcVJJr/BuVKemM
         eIypZQybcAdwAnWmi0E8qQDZJZK9u6ug1Qmw52/40q3MduVTPZ63UoT+rV40+xSFuHM3
         FAhCJ38IvoeAIKkTFQIlfRDhgJXHqlcNN/HdHuQWj47Nk1awf5P2s3HYYY+w8lQkjIwl
         dGHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772566517; x=1773171317;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xTHkte2RUvSWtiFL+zim574JKvRQEGOa3ktAOhw9pjM=;
        b=KsW78subxybqYsTDxvcs12KhJfOKgIeVX359OV5MrGYg9zct/OulimyjJc8qZAlzTs
         lpxOp0D6GHv8Pe4NZBQDG0phPAweLB3M7Dot4aIs1dSYdumjpUUVq8XI4tS7dWws+diA
         M7dseDIdN4vF6gPH+TPVcIW+QQ3jMxUHYVlCG1iXPAcTCdeRon1V5ftiM3G4cjlig0iK
         KFBKYUNcToS1lg3RKDP379erPJOfAi46wRu/5Fa6iY+5r4WgRcE0yVQsuD7JnDB+KMw/
         f4wcmmwTG60+IZuvp1OBRCM7+6EqKGqb5LYLvjiynhTyR9tvUiGiYtQ/H+5b59sD8R8K
         YPWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxGlqIw9XoysnTVOsSaQoe72gStuJBB2RrvQ5vkkw4SX/JEz+7Tl0JwqLWkzG/6UaBrIlB0em41A==@kvack.org
X-Gm-Message-State: AOJu0YyjXw9rAmxIrfkwCnwQaRpdyxHAk+0O5w7Z19ZhdO4Ss4os/6ZF
	+hMnjIoAr7UH3PP2lJXkTMJMoWeQX9Qf2r7vc08xmi7u3pqwPhm2Kc1JPRAeZTxUIhg=
X-Gm-Gg: ATEYQzzb6Xj8QaTVrnyYsfFyE8a/nz9FJhCx4NIwj7tPSEIfJjzxTPaZJLq40oNLsY0
	SatBZ6cFlGCMeoKMn70kS4LPWgwbYHN/jMUWzbKCmy3sSSr3VrZRAOKzwFBS0rgbAy/SFOlBH+K
	ubrl9XihkZcjKM9zU99YHf9aEn8jSgNe8vzORFjM0XK4zr3Io/StwNt5c5I5T5QBbBGcnp11N8l
	xNnMw6PoTIBRa9WhYR7BRr09S6woocwIhjnU1YUni1uDoUgZkHbLsYifSjCb08VaFbsk1SaMcnM
	NtGX11LRsOneS3mwdXGH9y6LxVz5UOY6TFeTvw+fCRWYbvP08RV5iW/0SouuJds33Nbu+9N9ODU
	bZWCid25xCdd20Ss+gWIGI9cYHjnwGqnmK87+ZYvKLYuxM4sG8L/0u/35PfQETB/5jANdwUSFTo
	LuUVoHw8VTjF2P2eQk6YQVpg==
X-Received: by 2002:a05:622a:190f:b0:502:98a3:3496 with SMTP id d75a77b69052e-507529912c6mr206565681cf.45.1772566516729;
        Tue, 03 Mar 2026 11:35:16 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744ab2fd9sm133192891cf.19.2026.03.03.11.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 11:35:15 -0800 (PST)
Date: Tue, 3 Mar 2026 14:35:12 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <aac38JHJCRB0PbjJ@cmpxchg.org>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303115358.1323188-1-matt@readmodwrite.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C96851C000A
X-Rspamd-Server: rspam08
X-Stat-Signature: a5nk984xo9e57o76176i9a68xpc4honr
X-HE-Tag: 1772566517-830078
X-HE-Meta: U2FsdGVkX1/Vdq4TdDZeM/0/bPsYJ67p54l3YNoPFzYc6P6kPnifhNLY7ZyUSyutEqRLzdMiYhDZSVIdFsEnxj4Lvr+/N2Njq7qUhF9Qd1pU9jDgvCF8n8YL8GuLBT6umRqe+3TTX/A3tBRzuknO3nl40dcLnOX7QJiPpGmikbmIfwZS024RBdLGyB5aFXubOwSb//w2laoBYdXQkrBLS20m8ZBt4dLKPxdDbuh/EPYVAh3k+9EsuXPMu8uyQQc2yZ1hPFepJjPH8rOyFUQGlza9hRPjfRHiS5YrYXl0dcT3gEZl6mbxB/pH2nhgeVTx07NSEwTaizA7nkUaqvPSXxP+oOe8fiUiSLzq/jnssMmH7UjlfK583Z4LBkZ4nHP/HDJpHHyX3Z0vKdbk3uud7hOnT9GXfnhQdLLUzqPRUgkvoJao2jCuEBONXbpLii0lJwzPqh4MrTUZs9nOenaE4vQp2hDHFvN/QdmdKul44hgj2hnx0fEt5tPbGvfwH2fMwxEn5f11y6JIloPMLl1JzjSP1wQc5BndMJT4LEq7APOSiY6l17XZTi52B5FzpCqfL/ydpvAhIyoVoPw2hexq8fCzWwRlzzxcAbUBk3FQbXcN1O+cxQ+ECa7QD8H3aGG/Jnrttio4MUPTgQRozSGfvIj/HhpQRVxgRPqL5DxWTkmIU2d3w3YZgVCF6VnZ2TSBL7W9YyRadulCADWGiAyQaqP0ppp+0HiatpATS/RXAeOxlCS4kk0DS7GZG/p9RAmXeaNa6Jrry9xFKxPRDkwxBKtUUDo+4lV15mBMbZG5Xq0aonG6yLq1TixHm5hvbpYlUNwT4okAE72o2UrFMjbgEiqSrQQGYyNV+enKLZ6TJdhYp/h/Q33AIgF+uQkq8OR6+meJ9cTUmdZ3Njbs2PSP+f/LhcBwL/3UHFkPCBsm+JIAB1Xt50vt9/WOX1fW+Fxdck8geGSHMfJVMjqPcmI
 z4fZzAup
 JShjYZwZzwJSXHNWPkjmSvwEQS8W7Kuwh78rggW40wzCTkX032owrXnnsqV0r14m+X6EuyrwZjKNsXS5RB+f2rd3bqBaGlHW4IEsYiJhjDVDBcSXdG2q3xaNv0H63/iDp3PXQUCjmP8glEGil+CLo+uTHHltl8rGUlddUN9uQUojVPZVT87QtmR5+bvWAor3gTwj7Jog/kgottNe6GVw/yniKDmLjypTxQ6cstOFKhwhWmekBPXKcpD/livR2WwmJeA/npi0iWDVJfpc40jiohYCrUnqif1cm0RzXaDdmzipj5j/VDx3MnThLfzW3V4noXRl5U0PKLGQWwhVu4iJzvNuk3suCGR+9tPkoW1Ix/uuZrrmb6CCzM2q3b0LOaXvyQ1RagIKdEJ7GJ0RIJfybXjt2VQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:53:57AM +0000, Matt Fleming wrote:
> When all active swap devices are RAM-backed, should_reclaim_retry()
> excludes anonymous pages from the reclaimable estimate and counts
> only file-backed pages. Once file pages are exhausted the watermark
> check fails and the kernel falls through to OOM.

What about when anon pages *are* reclaimable through compression,
though? Then we'd declare OOM prematurely.

You could make the case that what is reclaimable should have been
reclaimed already by the time we get here. But then you could make the
same case for file pages, and then there is nothing left.

The check is meant to be an optimization. The primary OOM cutoff is
that we aren't able to reclaim anything. This reclaimable check is a
shortcut that says, even if we are reclaiming some, there is not
enough juice in that box to keep squeezing.

Have you looked at what exactly keeps resetting no_progress_loops when
the system is in this state?

I could see an argument that the two checks are not properly aligned
right now. We could be making nominal forward progress on a small,
heavily thrashing cache position only; but we'll keep looping because,
well, look at all this anon memory! (Which isn't being reclaimed.)

If that's the case, a better solution might be to split
did_some_progress into anon and file progress, and only consider the
LRU pages for which reclaim is actually making headway. And ignore
those where we fail to succeed - for whatever reason, really, not just
this particular zram situation.

And if that isn't enough, maybe pass did_some_progress as the actual
page counts instead of a bool, and only consider an LRU type
reclaimable if the last scan cycle reclaimed at least N% of it.

