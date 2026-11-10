Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9444A606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=MHi7lakr
Received: by kanga.kvack.org (Postfix)
	id A3D0C6B05B5; Mon,  9 Nov 2026 21:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEA66B05B6; Mon,  9 Nov 2026 21:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905206B05B7; Mon,  9 Nov 2026 21:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBF76B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:29:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01BF54060D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:29:30 +0000 (UTC)
X-FDA: 85417628142.17.D345864
Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1EB2A0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:29:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHi7lakr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794277769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HlBsGgt5fdLLxh9YoMRteCkZdpeZNQ5ocKkLttwq/cs=;
	b=P8Swm1N45WlG3T10MTJboDyV0/nkaB9GfXZ0f/rN9i5MXiuVgj6q8pYs9qDC6ym9aNhYYH
	ZpvAEkvbNPlnk/EJ0Vp9Q4J5zc46naVHaSEN+Z67Idj5WeFfHVyXmt9M1s8FizpE5j0nij
	6dhVixtvTLXf+f/BTGOQjvyeTygzj5I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MHi7lakr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.210 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794277769;
	b=6xIZeJA3Zao2Mz/0o/gP2LOQ9yI9C1D+fYBSmhBAP2FD0gxPtAd1QJg+CtOIgYHOL46d8W
	4uF9PaIhy6G84ZAFcpeUjMUZeT89xjlkpwVZIBVShYUUa9crFJ5jkWUTUFgqeVug60z8gr
	eUEsNbOKnbjoB98xbcOq6xXKK06lmP0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nJ1jpM7lqQ282X/00v7kNslXHVmvQXR6WNDc0r1eHOM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794277767; v=1; x=1794882567;
 b=MHi7lakrdBFbW0z4ZHt/a+z1o57vugjPvSGPMIUlI7HJGy5rqZo1+kOjkLByKq+jmJfoywDL
 Elmnz+9VkimY4PMFGuNZOyrMkHWuXHimn6V7ghaPJM3Gwgl6mcjyV08ABl4jyH+AnRe/904Z/KU
 2UtK4p+ZcZUoWMhxf9rzkjAU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 532814c464d3ffcb;
	Tue, 10 Nov 2026 02:29:27 +0000
X-Mizu-Trace-ID: 532814c464d3ffcb
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 10:29:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Ridong Chen <ridong.chen@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
Message-ID: <avKBgtWHe93uea_t@fedora>
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D1EB2A0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gf3fgjgjr7yd9eodo64sumekq8etgthu
X-HE-Tag: 1794277768-938706
X-HE-Meta: U2FsdGVkX1/T+uaox1dqpGh2zEPWkM1yMd1KSvUQHZ8cDd+fVh+keNxRNHosGn00eRlV2AJe7udZe2Mkwimt1qVq4KLhC/hVfZm4SHFZZ7TxUOf173Igyxe2MF0nq49sEeTu7zH0wge49TBtkqxwhfngc2eQenE7h/E04aEQ7HKe52XVrYVcV2186cKT1fyagnPy7kIdPOfWue6onz6VC51rk9JAcnFbM94C5wxOhHe5r+bnOrlbbts+jlajnycegd59IM91ZP3DE+3SVJnOKt+YG+aXnfwmZ/7Y29uG8QY/absKxJHdJ7CBNAosmyn9lP7xLgypStmi+7LUBlkc3B6B/5fb9JSckUWxN6vgUB5KpH4ZPog2zU14sfqdSklyKtO+Fqpe92WHqNdYBL+4Ryktj0gaWbNuQFvkf+vtlWXrxk8YRsBabo2Jn9Rtn7rxWLJc4p9OgIYWHycI7AQDYQ58HyB1D1AiNkNDF533zB0vr1+gJ7DrNbNHu+pRFit33y/ncz95yzN4cPmP6NiN7Wewwt4W/59MgPp4rAH7Jp7t+HcjuERJaF/TFS2dasAzs17Zb+RVqckHvu2ruPFv8y/C5N2ADWqdiKKMgHw3IeESaTNms5qbRlKY/wHPHGxd9N01D/s1D2Mf/rjLOfNmiAda96yj9oQab8/i7mlcFwi/oKlbgxSuROCTQ1cspdgRY67l6NPgRP2/Phu5SrZci5tLfo5Ohb7CAsNwuYRrnmdjS7UTNoDO9rt39eYT9j7Hx0fdOuT/k2+BNzc3r+V6ocRMY9vEGaZ14J8w/aEcxiC6BDHVngOeEkRyzMO1YTFk2alKfKf7FXmGXDi6vklQaVR8jyEpeYNU0MHDDgyXLE4SBzed8ShvQ/JtLSpsJ+8gQ2f0UtAoY7fWlx9c+A7sr1O7sGKNJcw6nANV24jl9c6pO/zuP88/IVyrq0u9TPud/wX2baPNSHVJbGj/hz3
 c4I2AWVY
 I7M6p3iUl7s5/A32yHdU3saUijCGGCYLEG+Xorj3nnREJJ44/QgrjLXq/pmIDCnooe/lgr4U3jshR2lIMbtYTkJGwqkIrGQPK9j2uJN0vousX8McNv7LB3Bg068dYv3s8mvhugP0qr2GG8eWxhIryYXMKw294pj2H43ZcDV6JCLaifmErzl9XDm7UuTl2hgAnwMJ94LQTld1HwIT6d3Diiz99PQlDMkEmZ37ILQMCSTf0Hu+tdv1Y0v+5PSBtJTCJY+ETVGh+39MRhuPIeDGmeY3WAcPam3ddW2jb7y5GdLYouKObQI9TzkHuh6NbPbrH697JNhNgEYlLBm+OQx00zdyNa884LUZcO2ruVfnQ0y11Ix967EQOAtLMJaJrbjXAx2vWsI9j6gyvwOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/09/26 at 07:31pm, David Hildenbrand (Arm) wrote:
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Well deserved, congrats to both.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..e7ac319a570c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
>  
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Kairui Song <kasong@tencent.com>
> +M:	Kairui Song <kasong@tencent.com>
> +R:	Barry Song <baohua@kernel.org>
>  R:	Qi Zheng <qi.zheng@linux.dev>
>  R:	Shakeel Butt <shakeel.butt@linux.dev>
> -R:	Barry Song <baohua@kernel.org>
>  R:	Axel Rasmussen <axelrasmussen@google.com>
>  R:	Yuanchu Xie <yuanchu@google.com>
>  R:	Wei Xu <weixugc@google.com>
> 
> -- 
> 2.43.0
> 

