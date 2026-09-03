Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6326C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C866B009F; Thu,  3 Sep 2026 10:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63416B00AF; Thu,  3 Sep 2026 10:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B532D6B00C0; Thu,  3 Sep 2026 10:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 926296B009F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:00:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31B1940548
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:00:13 +0000 (UTC)
X-FDA: 85172610306.25.46692AF
Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	by imf19.hostedemail.com (Postfix) with ESMTP id 165621A001E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:00:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="gjzZC/MD";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.194 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788444011;
	b=3A08xk5aVZBKfA5uGzXsU8K4yqRJFBP6r41aNGLWvfPAkM+0DhfPCvTQL7IJwkCH//okq/
	CBqvj5XBdUGoYFMvjhSXdj7wYq6FyZXs/3Ltb/VlvHoLxifdk/h3xNvXwespyIl1hFMeBe
	Bn+f/P8cpDUy5sscFRP9FKfz9lifaMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788444011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6ffg0EsM9Oq53XXehfd0nBgBXlCf1MLMwzSPDpkFdE=;
	b=SJEdU6G9ocP8XjAERhYikoG4D+MwQiIunfSp64z/l750GdQA0nC0broCTL4iahJS7C8O+I
	Zd85tmyW5Tl29H3n2KdQiPTYc5+Res+zviYjZIrljLer5ouIQuPkchAP42CAW1XtwMhtWA
	lDl+oFXNqFttnXbLCWMS1s/glk3S0hI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="gjzZC/MD";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.194 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-86162c086f8so15444997b3.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1788444010; x=1789048810; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q6ffg0EsM9Oq53XXehfd0nBgBXlCf1MLMwzSPDpkFdE=;
        b=gjzZC/MD0cMVHvhwkvfyWedTEvqc8mpwQ8CovdCm2PEXx2y4acnvsvDeDW0M28L0VV
         G72J7iL8yM4C4vdlANhXIa43aHf2xb4VF+86yBAAP/lH7fYBG4PrF0F9p7frxfLV9cdo
         RRQysCWa1CAZ8olvt/xC97uroWnFgestH7LmQZh399nWV4jW9xuiHmSrlZ15DazLxdcg
         WRS1XN6WDm7f6q3PxSwCrGX4VswdXjyLf+Jj9n+EJdU8Sz8X1czJBLCIOLZQ+ZvZTcNg
         fK04KcjEBBVgIu11eaoF0VsyofLCVZY0A8TGj2g7Jpnt6Fgtn87k8wDR+sAKz4ZBcf+J
         AdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444010; x=1789048810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q6ffg0EsM9Oq53XXehfd0nBgBXlCf1MLMwzSPDpkFdE=;
        b=pZLsVdJKxx8mqCHnPbLyhw+Gl0DNN08jbINtAnIPTSN+0NeLd8bkzuOteW14iZwwof
         Q3GD+qtUVsphzQykCMMTAJeT7pd8hJK9eKRiqaANnEgE1UNAo5XEUKoKbsjKPfS57aRc
         2AT+lnSnUVi5doodQXUkoMNf0FT+jg31/+vp3gRv9RPTGMJojuyu4Pyw7Z0mA7MaVF+z
         IhFFOr+BQkNOSb/f5ty9px2DYRdl28zBa8Xt9ZsYslGGomgGbUckdOL8rECIrsXVVN9F
         mbbbnDqGNu/CkWb7+HwrsaK899tq+UkLUUYhI8+QlCX4QhlqXxEuIdwb0iVhjpfDMmXK
         eE8g==
X-Forwarded-Encrypted: i=1; AKwUvBwVovg+Xr9PxO3YBpUv7+qLgGTTRrfqq94xke2Ysav2NesJsXWAys57YqqHw3/BPqNrXPMTEuPE2w==@kvack.org
X-Gm-Message-State: AFuF++m/MPKKSJh2IL2kpiXk1NWDSBKNyb1AYgPIU32FOWmWVs5gomnl
	4B/cWOhs8CRhoeMfh79jKSOh4Q7l+y7gnvr4r91zNH6J8G3UbtwD+P/HY2xV0AjHrNs=
X-Gm-Gg: AYBFou05WnD5wbocK2B+dbAkEjprtokdpIyI90LmcvyfMWXmlOWtzBzijvF/6FvciQg
	8Qj7QuIBTycDvd3TWccFYokT9jP0/GX6qrLnILeX7qRleFidQOckJ5oHVVvopUT4pmiUpex+CjE
	diRceRhlT+ALuWB+IXokfEfdTxsQm/rOuMr9PQpQi25KBytuO1GIboWCabALI6Eg69xoBMt3lWP
	6LeFlPZWZLa8ckHz6iPIUdMW/pWzAAXVylrCAPh5l5jLAit0mNkwuLLRHsJOBDVzrQER2LMMdwA
	O+LBkVvdXLIFqu6mkpMo3GN6z2NKOr5DYfEysfEYs5n6YHPyOY4kzKtnWJXhPNHMdahGLzSJAWe
	l7RllLqCjZ3pohgdiVwZK/ZmHmbdx0KzVcg3Dxp+qvcnJBxcxmYOVVrwVCKGmju5yDxEeyq8F/x
	hG+0HwGbcVmj0iBNEpzVcm141aVY9u8dD2GKpM5pLVf8pwBK4e2/T/LDPKZxYf
X-Received: by 2002:a05:690c:a84:b0:7f0:38f7:6ca6 with SMTP id 00721157ae682-86e6d7905ccmr34387887b3.5.1788444009533;
        Thu, 03 Sep 2026 07:00:09 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-86c12d92d9esm40198227b3.22.2026.09.03.07.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:00:08 -0700 (PDT)
Date: Thu, 3 Sep 2026 10:00:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
Message-ID: <20260903140003.GR3004@cmpxchg.org>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
 <20260903031952.1120321-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903031952.1120321-2-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 165621A001E
X-Stat-Signature: gjj1yzrbe1139ygqou6jeu6wyn9ums6n
X-HE-Tag: 1788444010-915771
X-HE-Meta: U2FsdGVkX1/6Qvfl0EXbtf5TM3VdZ2vJ4rr7J6z0MYKQR9qkJ9rQDY+NwEcEF3XCYm1XehEGTXCshCa52KuOE7BTizlBA1UvBFAMdZn+gw4lcMPdjJbCyxiAttfZSypLWdq02Rqelo++1U1hDLzQR1rzznLQI/lh7JcgsyVDHNuTr2WIFUZM2Ize1KjdN0mU4OmEzwEL13cL/7Ebdx7cbVJPpwIjhxuxvVUpSSKVSlV4aDGAU5tZoNM60s+1ZUyNE7MYHTDL46ZJR0ENJfgbAV1YaSXeD2nOnlw92jZHRz/HneFY4orb3XUJ22MGrSMtkJzpMc6Ms2h4M6wKcUxFdrdCJEXfZBL4C0vtWRgjmKA7MatQXbCLo/65SEmJT7y448kiLsVqxiQg1hDkuwsUB2Zse1dTSiseEJpACfJ8rTx0+EQgvj+ysRPh/hWX2oL9pVe8eLJrbOc0qujXBCxriUWSILJKBi6gtQxzmCn0JetTSd93deBXpssdeWr07K/KX639ao6GFuFveduyKMXrc4taCaMK37GiA7in4eS8Hi866rY+LsWebu6p5lEv8v6xeHcZn5z3J/BdNLfOjp5xKzu9s2Z/4+nquI3W6GudTC8aXQ2fAo/LjEhIucEtZnMyZq7KcEyM9Bql+WV3iOdfZVog4mVAcosEIer1fMmoHhz8CltwlIG45uHMIEikZnN10jv8z/RTn6OpIR6d3bkI55iJ/uZLD1kNtE4q9p2AssKMeLcdihM0PIyjVPujlmxFok3eMWNn9wJCeKJwcuPHhW6kcW2hXc0RkuT0e3/1e6ajje4l+9Srj5TI6SJFwrKIVsTWqgkgB/r6VEwrNpgtkO1WRqAIoR0nFgdCVP5Ri6uOEMHzt3h9nNEFNesk91nJulRQJgrMZ2RvYaRvTzsJHMd1fQ8N2IkOr2knB0MR8OodAYx25A5/nUTeKve2bDzrxBjd6Vok0nsY28xoXjj
 4frUk5Ld
 dqMXVzeLvi9CeZsz3Mqz9BNZjFt7Le5SYO+fvuDdStSNgL9o8+MdrsiaBok921uXtA9cvM2O4AycGhApIse6Me42WvepYb5/GZAFuLBX91GjmVNaSqehq+6Zr3L0S2Qb8QmgKHMwhFZvl8jg8IwvFcf6l6YKJiitieEvuYy9H+wnhstBg1gp6uXMJ95SDkn2asvCQB0UrHkQvisuQyqaRGaOvQkQbrO0z4gAVor6o1EYsJmns8pGLoZJf/t3QuAsI7JKWxOxLdMY0t7ov99WvrYyKWYiRT83JWqfsl+6QwTXVIFzTal0p01hdbpDcOkdUuYURgI6RmeZggMAlv0LPfuvN1C5d/wEwjPz57QNXS4hHdTEygTMgSYfz9hhmBS6Ma60QZEw/PYLuzo47gcdbydYsN1kbZF4vmk8L9QZm0O6VrXvv7b8zT/zG3iFhcHeMDZkKYNw8m1iR9x4wZuEVGByRMl0wjzGndMnj1RluMu8NAUQJV62/OOmt/4MTKZTrKkq4++psP1cV9V1zp6EgySft9hDqYX/d0cLACyaoEJYoLAsf7WsZFR29vvbW5dTwP3h/1DmB9IT19Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 11:19:51AM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> effective_protection() scales a parent's protection by a ratio of page
> counts, e.g. for recursive protection:
> 
> 	(parent_effective - siblings_protected) * (usage - protected)
> 		/ (parent_usage - siblings_protected)
> 
> The multiply is done at unsigned long width before dividing. On systems
> with >= 16TB RAM the product can exceed 2^64 and wrap, giving a bogus
> protection value and silently breaking memory.min/low enforcement.
> 
> Use mul_u64_u64_div_u64() to multiply in a 128-bit intermediate. Because
> usage and parent_usage are not read atomically (a child is charged
> before its parent), usage - protected can briefly exceed the divisor,
> making the quotient overflow 64 bits and trap (#DE on x86). Cap it so
> the ratio stays <= 1.
> 
> Reported by the sashiko review tool [1].
> 
> [1] https://sashiko.dev/#/patchset/20260826133054.88529-1-ridong.chen@linux.dev?part=1
> 
> Fixes: bc50bcc6e00b ("mm: memcontrol: clean up and document effective low/min calculations")
> Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/page_counter.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 661e0f2a5127..e8bd512069c5 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -8,6 +8,7 @@
>  #include <linux/page_counter.h>
>  #include <linux/atomic.h>
>  #include <linux/kernel.h>
> +#include <linux/math64.h>
>  #include <linux/string.h>
>  #include <linux/sched.h>
>  #include <linux/bug.h>
> @@ -356,7 +357,8 @@ static unsigned long effective_protection(unsigned long usage,
>  	 * otherwise get a smaller chunk than what they claimed.
>  	 */
>  	if (siblings_protected > parent_effective)
> -		return protected * parent_effective / siblings_protected;
> +		return mul_u64_u64_div_u64(protected, parent_effective,
> +					   siblings_protected);
>  
>  	/*
>  	 * Ok, utilized protection of all children is within what the
> @@ -397,13 +399,18 @@ static unsigned long effective_protection(unsigned long usage,
>  	if (parent_effective > siblings_protected &&
>  	    parent_usage > siblings_protected &&
>  	    usage > protected) {
> -		unsigned long unclaimed;
> +		unsigned long unclaimed = parent_effective - siblings_protected;
> +		unsigned long unprotected = usage - protected;
> +		unsigned long parent_unprotected = parent_usage - siblings_protected;
>  
> -		unclaimed = parent_effective - siblings_protected;
> -		unclaimed *= usage - protected;
> -		unclaimed /= parent_usage - siblings_protected;
> +		/*
> +		 * The usages aren't read atomically, so a child can transiently
> +		 * appear to use more than its parent, making the ratio exceed 1
> +		 * and the quotient overflow 64 bits (#DE on x86).  Cap it.
> +		 */
> +		unprotected = min(unprotected, parent_unprotected);

Looks correct to me. But a few nits on readability, since this code
already is quite painfully complicated.

Please don't do math in the declaration block.

`unclaimed` made a bit more sense when it held *this group's* final
share of the unclaimed protection. As an intermediate, it's *the
parent's* unclaimed protection.

Put together, it should look something like this:

		unsigned long parent_unclaimed, parent_unprotected, unprotected;

		parent_unclaimed = parent_effective - siblings_protected;
		parent_unprotected = parent_usage - siblings_protected;
		unprotected = usage - protected;

		/* overflow comment */
		unprotected = min(usage - protected, parent_unprotected);
		ep += mul_u64_u64_div_u64(parent_unclaimed, unprotected, parent_unprotected);

With that,

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

