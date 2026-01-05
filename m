Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E63FC79FA5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FFA6B0198; Mon,  5 Jan 2026 11:47:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3A36B019A; Mon,  5 Jan 2026 11:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD64A6B019B; Mon,  5 Jan 2026 11:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAC716B0198
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:47:46 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3C52B55AD0
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:47:46 +0000 (UTC)
X-FDA: 84298491732.20.BDEAE6E
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 19CAE40008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:47:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GzuPGAG1;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767631664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dVf3u2DFHBy+G2reAT7+xTPxrhj2Q9BCnr/QUBSKiK8=;
	b=nedUl/cBn/GXF/nI2pMz4IrR/vvxsxyvNmu5OHQlm3320Dhi4OCtGXe7Bpw7DGLNijWFOh
	0Ua3CUQWhD4KBkf2h+1EyTefCErKOa1JMiuRE7UXoo3h8/QjjP6+9xaavAU+awGPjAPk/Q
	sXCz1hXnfsgsAt+HPTXSif3DtZ5h5tI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=GzuPGAG1;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767631664; a=rsa-sha256;
	cv=none;
	b=Ge2ST0M3Y985Gn9ICs86tE0dfqYPeuxoMJBpeitp2UkA2s3ycETt6qSEOGJtYxk5Lpy7Ol
	DV5T8XEdxMPj7DdLYTSRUJQQBOrYk/IBVaeGKZd5Jng+NFatCHizbQBNS14T9/wbp2NCZk
	PV3GbODoNlHE3MQjvgaNQniiSOMF9e8=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so784575e9.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 08:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1767631662; x=1768236462; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dVf3u2DFHBy+G2reAT7+xTPxrhj2Q9BCnr/QUBSKiK8=;
        b=GzuPGAG1cRxvL6bscNuN8d7u+gbtVDMRzqNAaiXenNp36vKuVjR1P4BywbZs84gl+v
         7neFLv9E2q/xz2cGW3t01FlSb7RB6fCvbKgo9IDYo2xdLdThwL0bSVJgFcpqOR2vuyug
         N3+4UV3L0H76bdx63kOTQV+yhI5nYTVYimLtXtuf36Ddck1hcpbuoLislFBK3r0eLny6
         emmBC9n1kR64xuIaKJuNSiMU8/ikNOBbJWkd/721v1Zp+vEoZkH3DaDjWp5BTSvdIa1N
         QxvAvkpCMRh/xsrjwTlLxndYCN34Y4aPbKsFWdE615TbonJk0RIVLV9RMvChmfKkuh1J
         zT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767631662; x=1768236462;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dVf3u2DFHBy+G2reAT7+xTPxrhj2Q9BCnr/QUBSKiK8=;
        b=WidGSREgFYXYwY7t/vgxxPkNBCf3EV4fFHC3jAucGUWkEqDM6xZtZlB9S4RgToUrzs
         +3Dnd1eVKfHKHN0hPyC+r7yorlSlIhnX5/FBl2DujaFaYS/xvb4g+A66UyaPtiCRN8ub
         Hi3JBLwH9cfJMzobZJrNpgSE7lDGggkD75I62bCozzxGl8qwXd4VgggyrgXDzH0gUaKD
         JWofcSJIslxx68n8SMX3x3IwRZH/tD1hJhfw5jz0+SBA0q0EQkAt797w/MYBjTcjtHX/
         a4rQ8a0UpuSH5biuw5+S0xLseZEv93TtxWSiq6uk+SBZveaf47E2rEOe6y6nDh3w1OUq
         r/4A==
X-Forwarded-Encrypted: i=1; AJvYcCUKGmxfckBenNVIe6uwhPSYGezYZOZVeqEJGhjNDU4gET5gRen2/yjppBeZpuS58ahf1Vc5aFtVbA==@kvack.org
X-Gm-Message-State: AOJu0YyE3MGNMsRr5MYwDQbi7dlnwwDYemU464FmSR8ReGuzcLjQPQvT
	cgOZxsli9J9SefQUm7/YxqUK1wxM61dKRpbMrewXnjnTtGjIRYxlYH6JwUr2ad94m5I=
X-Gm-Gg: AY/fxX63Zwq7/dcqBc5OV2sDxs/H4xkMvhIie+Lb7Xb+GHfAktIU+M3G6zNXyqPkXUV
	05eW+yzT0hifj+3Ec1w8JDi0BniLORlJsodEJ/2WpS+Vd26wZo19RFSUU5xQiWrm7Vcen3HJgE1
	3upHxnU1pwI0NU3q7vX36fPfxNqYAnXwglsFO7kt+8S+++7yrgkCYpnivEHbvhZmsvjYV3J3jOg
	hiXzXhJfUY2FC3ldHPV7VoqfPDUjeASpyCo/uk+nEEPgzrypnw9r85hcyhweUE3Q5IsKDK/CPyF
	C7lR0/f1uXoRY4yI6uQ4T/0mjqzvf08TdWN/lkH3BjfLJC1Gve0e8yrDGNc9QM63qwCJzVWpBmB
	qMxWYSbHlCZ/4cz9co943EDZk9l6el+rRSRCkWugfWbwCJJXHqSI5GuD4zjNYJqiAaDd+RuU7Gz
	bEoWW1vCEvI2zhWOVgeu4vK6ld
X-Google-Smtp-Source: AGHT+IEbXwEOmbKLHAAdWfErBpN1iq2Thm7pkrNBOzof7I9+NvjlAAF1JhXxTvcoCCGSIEMhKFN87A==
X-Received: by 2002:a05:600c:3b87:b0:477:aed0:f3fd with SMTP id 5b1f17b1804b1-47d1953b7b0mr684658085e9.8.1767631662427;
        Mon, 05 Jan 2026 08:47:42 -0800 (PST)
Received: from localhost (109-81-90-116.rct.o2.cz. [109.81.90.116])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d7ece8088sm3482295e9.0.2026.01.05.08.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 08:47:42 -0800 (PST)
Date: Mon, 5 Jan 2026 17:47:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: wujing <realwujing@qq.com>
Cc: Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qiliang Yuan <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH 1/1] mm/page_alloc: auto-tune min_free_kbytes on atomic
 allocation failure
Message-ID: <aVvrLekQJMMJk9lD@tiehlicka>
References: <20260105063830.15140-1-lance.yang@linux.dev>
 <tencent_8CE8292766552797836FEB198A402CA2CF06@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_8CE8292766552797836FEB198A402CA2CF06@qq.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: nbij9k3q6dx3o8ru7tfsitz19b1t7up7
X-Rspam-User: 
X-Rspamd-Queue-Id: 19CAE40008
X-HE-Tag: 1767631663-711546
X-HE-Meta: U2FsdGVkX19tAYY6LF9phifmOF/Uc5hBXTY3KOgjuqrm+Ra6Hup300ZXyBbTGYhU8oujlUxQ9OA3kF2sUuc4Acdrh5Ne2CYWJ3fuFgMFaRGdx+rz+cKoBkliSi34EYZBDlOf7ZwTNSWsLsyvJP6SRvwi7tie6FOSiwuAcyCaUERMa0SPHcxkeTR3l3GKsIcJbDyqsVvzzNpUfvdnqzXJqOPP6cLN8u9XtCvx3zKMsfCHxvexcz2e26aYdyMvs/htFkzEyOt9Sy/3vvvFvYD/nyvtxIG51gzjeE4z5VkRTS1atCBgHlgB7CffRP7QsOUkgpqv1qP0lnlXAPPMscNCNFbqR/ktPjqXqm4ROS3A6L/Y7dEdHOJrB0NffnqSpEWeTSmkrPB0Ammn2cetKqh+sfrbymiOjK8sQRSpRI9WmzKpeJvglPU+5/v2M8DPmY5IT8WzXQ8uODQQI2WNAoHZ+nbgIzpk8V7+iHRuO5wTo1GkOmH+sHILhX5H4yebFkizr1IXQxxY56NDwDvdWr/XZVgzIjmhKnbR01bY/rwGO0UzyeBfnlZ0JXT0ja8ir4IinTSSQa/pyBcjPbNr8XgY19V+UOTBYTA2xce8vknHFTt43XLu2GD/gfGn5fY9nAGlIRWhv85+/MfBLpf6FhA4YT+KpX4lMa4hF7LyMviDNNlcNnVHvAuj8qW5ojyQVOD6Fx0DjgMQ4vmUO/jsMQP3g6t9+aLEsSvp3/Rei+Oq8BzhdBxbbOSbIq+QiKCgxzuKZGhi1fV16rmrELx1SkTiSBv9l7L0N7kMHeRT0HBcxP5U2wheLXKd9UOzpJSq9gVb6slCQfT8/w8scHSlcxcN4UMIEaVTIkbDO07A3GRz5Lc4/XROqT74zPGxawQXHgIpuoQnJRAl/hb0TczyHR9mfxkGqK5GK7eIL8QrAHeFVZAFJVKa5imprbte5k3UNT+OiQqQVeRmLwXbRZVOVc3
 ZBbQfogM
 dKI50uVysmJJGAmorvLiPi/HOXC87MpD5hkowoAO9HmyYItS3TvDQgcknJzQMHHrf7JAjWrMbgWhhShoZIFqf3Rf2k6oNRor3qH9tDaoC554C6hrkSx9FR+BbCvAUPo0XZjzV5UVNLmP45ibYFtq92UfxFDwyY+UWdxsv5bAcwhVfyaLp79aQliwjeR+RPGb0c9+gVvY5gxv+RC6FywDPVt8MXiLwt2VgLMlKlk80HW4AndWWdRcSmauyYe7RW+pCrIq7FQzUFqOWbnEStn6EzVdfMlLO+JBMpMH2262REd/HFv7u5/TqYykca+OVO0ll9GPzGq7qJui9nO2+ETXfBhWHMwycKoVGolNg76AXSRY9HRHU0RRtuDx1utUGQubEQaXb36aVH2BzJdSc22TdrSoMq+Si16PUZzGYc7AqOfFTeRA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 05-01-26 15:29:04, wujing wrote:
> Hi Lance,
> 
> Thanks for the suggestion about using watermark_scale_factor instead of 
> min_free_kbytes. I appreciate the feedback, and I'd like to explain why I 
> believe min_free_kbytes is the correct knob to tune for this specific problem.
> 
> ## The Core Issue
> 
> The failures we're observing are GFP_ATOMIC, order-0 allocations in interrupt 
> context (network packet reception). From the logs:
> 
>   [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC)
> 
> These allocations:
> 1. Cannot sleep or wait for memory reclaim
> 2. Can only use memory below the MIN watermark (the emergency reserve)
> 3. Fail when even this emergency reserve is exhausted
> 
> ## Why watermark_scale_factor Won't Help
> 
> watermark_scale_factor controls the distance between MIN and LOW watermarks. 
> It makes kswapd wake up earlier (at LOW instead of closer to MIN), which is 
> great for preventing memory pressure.
> 
> However, for GFP_ATOMIC allocations:
> - They don't wait for kswapd
> - They only care about the MIN watermark itself
> - A larger LOW-MIN gap doesn't increase the atomic reserve
> 
> Even if kswapd wakes up 10 seconds earlier due to a higher 
> watermark_scale_factor, network interrupt bursts happen in milliseconds, 
> leaving no time for reclaim.

The thing is that your approach is not immediate anyway. You are
scheduling a deferred work when allocation already fails unless I am
missing something. Which is too late as well.

Lance has a good point that updating the scale factor earlier might help
to smooth out the reclaim for the increased demand.

> ## Why min_free_kbytes Is Necessary
> 
> min_free_kbytes directly controls the MIN watermark — the actual memory 
> reserved for atomic allocations. Increasing it immediately makes more memory 
> available for GFP_ATOMIC, which is what we need.

Well, if the memory is hard to reclaim for kswapd and earlier wake up
doesn't help out to reclaim any memory then is realistic to expect that
direct reclaimers can do better on the min_free_kbytes (and watermarks)
update?

> ## Alternative: Hybrid Approach?
> 
> That said, your point about side effects is valid. One option could be:
> 1. Increase min_free_kbytes for immediate relief during failures
> 2. Also increase watermark_scale_factor slightly to make kswapd more aggressive
> 3. This could reduce the frequency of hitting MIN in the first place
> 
> Would this hybrid approach address your concerns?

I would much rather start with a simpler approach and only make this
more complicated when it turns insufficient. Scaling watermark_scale_factor 
seems like a more natural approach to me. Could you give it a try or
have you tried and it proved to be a worse solution?
-- 
Michal Hocko
SUSE Labs

