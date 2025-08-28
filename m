Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45DA1CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 05:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E47C6B0028; Thu, 28 Aug 2025 01:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC336B002A; Thu, 28 Aug 2025 01:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F95C6B002B; Thu, 28 Aug 2025 01:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9896B0028
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:06:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82CD1852D6
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:06:26 +0000 (UTC)
X-FDA: 83824980372.09.D17D05B
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9823640004
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:06:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GoCTdPfU;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756357584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bj0F3xKSUaIs0J65GjGl570XOpaBhxurzoqhx6e2Cs0=;
	b=PnulRLboIPy/eYkKu0zVF9S2kuOKjq2oTZi5tdIOrwiFLRNQlAn6d9jzUxz3dshqH7XUVj
	u3JsNrYurClTNYIu2FfHmqO+sEAwbmoOEnM8e9ARAXrZj5ezjsO5kuMBbnnzbqIVnuxWXQ
	kLRkUMp8yL7cKWWXCkaX1hbe2bUnUVM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=GoCTdPfU;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756357584; a=rsa-sha256;
	cv=none;
	b=F0N94fAJQst/j/nd8d1n+qvEd8uyaKr1CwflVDvAljgvL0y/6Hs22KHAb81taDssm5TF7l
	ocCasyj06qXy6HgT1SmT/WqpKXUEcKdKzBSuvXG+MKURAXjLhOrvzQcYk2/0lOW42Cuyvw
	WZMpUz4UVKsVClL99FJK/Sf7UdIKzCU=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b49d6f8f347so567140a12.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1756357583; x=1756962383; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bj0F3xKSUaIs0J65GjGl570XOpaBhxurzoqhx6e2Cs0=;
        b=GoCTdPfUKhB1ZEdnw0Nw2co4HE385KHtVLotTveF5N6cd7RvQHt2nJeO9UB39jxw8c
         ugYOUQ5s9s9gBifTaVW+oysLs76Va/B+ueBPZtNDVJ2tCEPT3LiFjE+ZJDveBwVXd2+s
         Eg95PvXrqfL0VIjBGW6SX0OldDYVJOCrwoZpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756357583; x=1756962383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bj0F3xKSUaIs0J65GjGl570XOpaBhxurzoqhx6e2Cs0=;
        b=Nc35OjVO1sl6fof0zLwkEtErxINZFPMcn5xfwR4MsQFfP18SA8hWWMJiHZoufiiZLj
         HoSSmbAvdKeHJE9XzmSr6xiigk1+zDJZDRzZxEx1ttosyoMkeal+Gqrbv11l4vhkCN1v
         q7idr9WlHFL6PPww+xleMSLpwFMSiUtPS6SutzzLpQrMxaa6Fq7silkewe4lQNJ6qyjP
         p8ULtqwKLCmtq4rZtxf3hj6cfzqNZQ5Gkpco4FRApp9ROGU8YQDbcGBFULABkEs+W+6T
         npxKngj6y0Zb384HBQ1G4AsqWetjrNbfZreRhGsoqMPK/p66XixDG5MqNELGaEhUkXF4
         z38Q==
X-Forwarded-Encrypted: i=1; AJvYcCUMWaIryeGKvaohRY1tyHTUBJeXyy+8qZ9lcC/uO/4qDn5VDVruDXLnTqwWw9yIRaZtp0GYguTKqA==@kvack.org
X-Gm-Message-State: AOJu0YxZkr9plC3HzyDPjy5UUmlIEFd4avR0+lSIdT5MY/WPY0rDgu4/
	eKLHKdtu/eIPIU5bIBJBhnpBL7ITknR7Dme2aEU+BjwmvZSBWFB4u31hrJCX4X0l4Q==
X-Gm-Gg: ASbGncu8XYjZlHG2C9ZFuGMKSc47uGlz6qCzb1vsyQExiMx44mWKcg7I+e7uX9SePyp
	HjDv12xvNuSO2pZOKnMKqipGPb61QYtEhD0rivbhrNrhjEIPBWzVgzblCLv6JxB8EgAi6oDe1VS
	RWfhR1p0U2maG+TfodjsRYxw8gLo2grYWL366axEsNO8k+TwiMzA6CiJYaoB971J7h2tUrewbTN
	bM8Ny7BqUr6mpLDLTCFojtxtzVJNjOEsRAkq3b2vSGesQ/RQUe+xhkGCmeEXa93xXAko+rWU96l
	4yAthtQi/UPY+MELHLefwnVBwWKM7xHcK4y892ezdBFu/at/A6HRT3TSFAOhNhfI1q4CLYgSaLc
	pYYrQJvMuhr+kVJpqosvL/ZwqEbEai22NIYak
X-Google-Smtp-Source: AGHT+IGFzXqVbx52FiYF4GbIQed6e1Rc69rllf8xeojp/PpiJVnMDg3NfKpiB0qKqfrDT5fxCIrDEQ==
X-Received: by 2002:a17:903:283:b0:246:61c:a67e with SMTP id d9443c01a7336-2462efdd639mr263243935ad.61.1756357583296;
        Wed, 27 Aug 2025 22:06:23 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:5da4:f999:f527:70c9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2466885ed21sm137543975ad.98.2025.08.27.22.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 22:06:22 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:06:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>, 
	Mel Gorman <mgorman@techsingularity.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	kernel-dev@igalia.com, Helen Koike <koike@igalia.com>, 
	Matthew Wilcox <willy@infradead.org>, NeilBrown <neilb@suse.de>, 
	Thierry Reding <thierry.reding@gmail.com>, Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Message-ID: <xzjclrwdgtzeufjpposi4aqj37qe4cf5mla2mv4ss2fu7llrmp@r6yjikyew6ej>
References: <20250814172245.1259625-1-cascardo@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814172245.1259625-1-cascardo@igalia.com>
X-Rspamd-Queue-Id: 9823640004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: koe34tdjomkbz8oaibfscumemz4y4s4a
X-HE-Tag: 1756357584-966491
X-HE-Meta: U2FsdGVkX1++TExnTPCCsk6kt1c5uKQB+aCvm1gcWOC/ERNND+YQ8Y0Y+eMAGqRdRLOCIVUc7oWwrk6S8VwiNN2ETZm/18tk5L50kpQ47e58gnHbmCxYzzbj+8nFQBPxNJSMMYOOW2GFN3KCjpQXnnGK2/NDYYSq7/xHSR6r20XsPuF0sxf9HNfFlMdAmPqoLX0LAboTUFSvzwHCItENW6gMLr0NI0t9KaSFog4M0MvaK4tsl99joLFD5t3ojhaEgB5Yt/0+S/UvifUMAmOv8ZemUDUlYeu/ES+pyM+g/PoX80mxlSSUcNm3uCXiorqkXeCuxXJDgHa3aCu99VU8nQWuacVHWKZIWzL0KbPOaYb+yNcG07F6OCl4mjTBZwjOkm7HxcyeDabTRkpIRTYvrrpv6xNNEgbeYPERyq6gAYrU+vw1LvaGwH2Y46+jyaxm/Aja051++/bUwtGEeOiURe/pE84yJKX5DRb5Q8qHWIDf4k6RyvGyKnbJoBnwG1UDNlmmbMtCj9zkziu8/ZLhI2Q9BQdNNPxFv2zHq5R7ghN7BvF2sZ16RbqVM47B3YfVRZSOgQxQwj+KwebD9Bw8GphAo11/yz3HHlprl0Evrjuh+61lIlkhmOzx7k8BcsYmFPntWpQ2jdmlMPQ2Uo5Wr7zUqLF7gt6aHgBX/f6tPzFhLFa1CmQO5I1zaB5Q0Z4sea3IsWavtRAz0fClH35ja8CljsgaB/7diQsKLlYWIAtZqEFFp0jQzilp/HmeTQOojEuy0bK/fEYYeH4vLUHFa99+hJZiZbNFaQFT4mDL2l4Mcjda+EXVtIP3dQWCAdgQO3IdYr75FoQp0hvrCfqb/m4alf+Jm99IoHM1jJoRBf6VdNnzagy6CQ67DawXVUdZOIxiJ1ysHB7Lyp6SCE+b2q0oKQLup8VWhuX9Zb1em6d3Dv/CGPEicKXNtff9UXze2M5b/biCIFBCGqL1fEX
 EcMZcB51
 SA6EDn0rbZh2tmySdH3fP0cuW3/jhTyBHpBziHqEG+6PBuj9jrXpoaHGrAkjNK1P05beCw4N1dLBMQlZbKU/2QMkaiLAjJcn5lKy92Hpz7/WuJQv2O01SPbTnM84+7FTp59aRJxV9kPnVwiFI7HLAt6c5Y2FQsaM2QEgCC4UCZS/aUUQohfMmbRjJjI01LL+2mVU0LWIBNXPXYUPoa/CSTpX5AEYVilGnRsAr3ZLN21TvuV1eqhDmF4kNo83Z5z287NLWQtYi7FXabEzofx5/MQrFPEXd583eatO/qTUTXQINDUtKs+yAv/KvD6d8ErWxClZSplxzMq3bAhH2PgMSzXsmV/uZrl86CfXfok+h3i33vun1CuYyzhfMeCzKNMejhZ652Df8PyLW8kJjwctnncojWz/1bO4ztEYIVKCYhX0E1iEfbW3zSdj4k2TWG6lKjZiZ8EENvZu/pBddVJ0Hkkss3KnAjrjAlP+R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/08/14 14:22), Thadeu Lima de Souza Cascardo wrote:
> Commit 524c48072e56 ("mm/page_alloc: rename ALLOC_HIGH to
> ALLOC_MIN_RESERVE") is the start of a series that explains how __GFP_HIGH,
> which implies ALLOC_MIN_RESERVE, is going to be used instead of
> __GFP_ATOMIC for high atomic reserves.
> 
> Commit eb2e2b425c69 ("mm/page_alloc: explicitly record high-order atomic
> allocations in alloc_flags") introduced ALLOC_HIGHATOMIC for such
> allocations of order higher than 0. It still used __GFP_ATOMIC, though.
> 
> Then, commit 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") just turned that check for
> !__GFP_DIRECT_RECLAIM, ignoring that high atomic reserves were expected to
> test for __GFP_HIGH.
> 
> This leads to high atomic reserves being added for high-order GFP_NOWAIT
> allocations and others that clear __GFP_DIRECT_RECLAIM, which is
> unexpected. Later, those reserves lead to 0-order allocations going to the
> slow path and starting reclaim.
> 
> From /proc/pagetypeinfo, without the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      1      8     10      9      7      3      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic     64     20     12      5      0      0      0      0      0      0      0
> 
> With the patch:
> 
> Node    0, zone      DMA, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone    DMA32, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0
> Node    0, zone   Normal, type   HighAtomic      0      0      0      0      0      0      0      0      0      0      0

[..]

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2ef3c07266b3..bf52e3bef626 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4219,7 +4219,7 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>  		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
>  			alloc_flags |= ALLOC_NON_BLOCK;
>  
> -			if (order > 0)
> +			if (order > 0 && (alloc_flags & ALLOC_MIN_RESERVE))
>  				alloc_flags |= ALLOC_HIGHATOMIC;
>  		}

From my limited understanding, it does look like this was the
intention.  Vlastimil, Mel, got a minute to take a look?

