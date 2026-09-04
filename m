Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E23C79F83
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 08:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228ED6B0088; Fri,  4 Sep 2026 04:37:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200686B008A; Fri,  4 Sep 2026 04:37:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3906B0098; Fri,  4 Sep 2026 04:37:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C83526B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:37:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50E891A0CB9
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:49 +0000 (UTC)
X-FDA: 85175426658.25.D9CFC00
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F15880003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 08:37:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JyZkrHDM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788511067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3s1LbH3i67Aex+XO8TqzHfYjkZ2LQ+Zdti2dOun8vp0=;
	b=oAsDJMGkKY4fXSyd7RkvZh+q791sfFwrCcZppI2m2jkIhiwHzHesl1LLSREDwOr4K+wLtB
	e8xJI29SMDBRI3W5GB2Unr0NIPoHKjV+2wsKCCpE6AHcvit7NW1VQif2oa9jssDfORXekD
	SdRDVBFwMbQko4xYlUcLy9sAg3jhjRQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JyZkrHDM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788511067;
	b=j42TlOAKZL4IFzygf4NpaVfxaQztDPvlKYznkBVfRa9nFswOuXLta92v79qgR6QsCbA2qr
	VZ62mXVhafbhpQ19S5yYf5/3JkCNYqxU58/HTGL1CNDF6q59BOEW0frwqBToXPcgS83REB
	+N267H1ESgfSMVRaESElOulwMF5Rg1A=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so9913335e9.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 01:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788511066; x=1789115866; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3s1LbH3i67Aex+XO8TqzHfYjkZ2LQ+Zdti2dOun8vp0=;
        b=JyZkrHDMEz8tQPyb189nwiu6yh2sKz9NIttx94cQf6Hh4eOUII7vK6ESncFXsJ8idb
         stgDbA3RHLm6ZGfaOH1QmVYMoFyTCygk771fBGP02+A5Ti41MVz8fXnXOaqemlC9uelC
         pTQtDeBy1B+4s0m4HiQKUM55DgGpBNvfheAOy2HjNMAa2D6fY3b+Ht+fCy/C8bKklkCg
         Dzszv2YXdiwZ2JI7Nt6c9p3gHiIo7SIaQPOUVQNdjvjBT16PGHaSnWV1rJLJEo+tzZXG
         /zW8zPqsuk91KCIAWNzZ8n6k5aAvjuaeyWcPxl6wwEVgdcInpuANgpD6smeH9gqDREQl
         LJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788511066; x=1789115866;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3s1LbH3i67Aex+XO8TqzHfYjkZ2LQ+Zdti2dOun8vp0=;
        b=PTiDii5KcuvnR8sbG9vZi17tktpzR1N2kXsJ8P/RAejBkOkblr0/Kv8LiMcoHdxDVv
         kxqQ1DKrUXjp3cIqfGjdjsTGkriK/1ZKU9xTA84RxWYSHCxur+Ij+BqAjm8NrC/uRj08
         hMzYsAGyaaUBZH0I9Kf5QFFACcYyHZ69h4lsQRZ2eJz6owt6ci3tL6JfWsp/wnp2aFyX
         LDl0HhxRIvh1nY6pqjIvvOIYJambXvrZWNaLbTzKStuoZQLV7Nmh/mNvipduRDmYOd6Q
         ZfyHiczPdW+a9OM0Bfmv/9+IAgJdfEi0d7F167blX1md8QeFj81eQJcNCuCVoTY/Qjy4
         zgKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwUlQsC1LZNMfT/PK6/sxylG91NusKqyaYxwo0X36S5CUmoG1necHzXXO3ACWmA1ZeApqY2q7DXzQ==@kvack.org
X-Gm-Message-State: AFuF++kYk9OuWVQNpWu7Vr7eot3A9ehcfQzWQYHzuz/8C8ar16MftdDD
	zNKJ8BuG+jKv0hAoAkbWbAlz01WI/zG4ngyNtjgDQnTCiznI02U45Yey
X-Gm-Gg: AYBFou3YRTH3GPAI+hgOBernJ3vDDMyttCysJcP1Y8qHshNoSGnFYBhDaoOz7ZMo/YH
	eMfChbk/ZxeChT0BgBVC1zb3UM61V5wXEpsPOXdks1DneeQN6dmjJsKOrKi0e/AtQo86jMrGJa7
	6MTTIqjdGDdQ/n4fbhVCq5MXUH6MyOxMyTBw20nSRr0tNk954JxGNx8WFfujiGDvO+vAaHHuVY+
	lyZjP2PuPKzmrUQpl/NY30gEnrQFJOBcXk1cB764X1UYDRzg/WmljHrdlfIQghqj1LRAYou2FIE
	wVeo8ZhC9mHS/uBthXiQumqQcOn/krU9TNSPrxegD58kzob/LaG9tBslZa3pFXZUknLi7yhctrn
	n7au0b7Q11ZcTUIgKZKwaG4np8Jhubj/nA47cEPCq4mxYW1hmyYxfX/fUteir+QOSiI4lvFZDrI
	juvDN4pNBODTrQ7lK3S9+9UlAiGH0kzSOs8zNXXZ9Oup0rbTwkpjVmLJGbJlVLwaQIbK5elB4Rk
	V2H4v5hJA0sTL+cvw/auqMwEw==
X-Received: by 2002:a05:600c:5303:b0:49c:fa21:1c85 with SMTP id 5b1f17b1804b1-49cfa211d81mr22763385e9.26.1788511065589;
        Fri, 04 Sep 2026 01:37:45 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee5d4938sm137112065e9.2.2026.09.04.01.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 01:37:45 -0700 (PDT)
Date: Fri, 4 Sep 2026 09:37:43 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Muchun
 Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng
 <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Chris Down <chris@chrisdown.name>, Tejun Heo
 <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org (open
 list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
 linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER
 (MEMCG)), linux-kernel@vger.kernel.org, Ridong Chen
 <chenridong@xiaomi.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/page_counter: avoid integer overflow in
 effective_protection()
Message-ID: <20260904093743.23cde26b@pumpkin>
In-Reply-To: <20260903031952.1120321-2-ridong.chen@linux.dev>
References: <20260903031952.1120321-1-ridong.chen@linux.dev>
	<20260903031952.1120321-2-ridong.chen@linux.dev>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: pz4gtxzsr9ye4b387usjxwjysd3cs8wb
X-Rspamd-Queue-Id: 7F15880003
X-HE-Tag: 1788511067-90529
X-HE-Meta: U2FsdGVkX19ZvlzriVrSpyba9sRUpQNILmc8y8OfYuRgG79z7Z46Vh0Xoj3/dnx1VA7zuIW8Gw3Pup61V2rkT0XsjbQRWbaIZ9LliRMaM49PXC/BMev6Y0QObgFRadcqbITqAWS9+Uj4MRQE7J7AHWD1tf7+rDhKtzdfpDT9uVWl/KqVRp6rqYD4HIJ1ehgpfm+rCqOyLNIwWxNcDwIYRxYpvQu5x9lTrsUqoJeeRNdu0shQsSgm++GZPFCZZ1+lT/S2Mlpc0WFInqQRmuTWRFeuoyVcBX7QsWX+Wsvi6RsbHkqiBMZHebHTD32BPExAODgJlnUY450GK3i6qLhfg7WKN86YpE7iBuDXnKRq48XpD1D8S3pa7sSu2LMvYGtABasL4YfGx6i+sxtaMj0k77E0zoRDNs7c5KhK+ebvhTJOlXkEQlNmnbeAYW/K3sjNys97Tk0zn5pjzjEnEjN24Ho4O/3pDN19T86rFIjS+c0AfwcjXhvJxg0MkN5jMUGwQCPbrzVQsBdE0YBgrsBfm+iD9CwbPdpjL/4tgYyp+yjLaPObIZ/ahfvSPDZj8etxVDgRbioBvaoUUI0eLwtdoszTsQCYto9iukF88qu3EelSxgglAOqoFEH2RYwoWI2PPV7zCIeECSZfM5FmH9WGbnRq61uC2PL1dr5R7uLhUmbxI+EGA6OIcg/FWP/d2CtvWEQXVEyozgklaCPazSsPtlXuEkZkVs3dfORzA5X4irk/IzxrhIaxrfgDptwoosUS92Lk0ntKWj/aWOpCIXdDi+Rd/EUC+eMW7pgagGcAlUHe0h1VuXirciu6hTajUdJt2czrRTIavlg0MaNCaAxsit4eY3CR6SWPgoyIu0Wuom4nHD5tfSbbVzbzsTG/gUmut9YbF4rcRp57a+/yNdkACiOoCEXu16/GfeBFO3oNPy4qi97gVJKo1wmXQwpFcpJow9tkI+N3lSjhlu27BlG
 SUJvgnm4
 Bl61H08J/X+Qxj2J+i8+kZV+blU9kWu5dKuvCzlyfS3Q3WfLsPlkCPKDjx80XPr4Jje2xsmGZk2IuVDUiMqSpjCmDyLxBYBHoVcCQtSkpS6wA80zCzujjgNkevC9akoowTnD0RV0OUqhT1HS1CPUppiV9dpuwUpYJ4oZGSguJbRBESkgcqOTFmkaPzyLy1f0hUeXJuWKzVnTm0hJcSjgskZKiJEPwgUx7Ms9H7wVK9MTScituOyejUcl/1U9sCw5g8gphQQqK67eHoXqsnUJyk9iOn7QoMaLU7XAjdfZMRvQSCOWE//is1foUQl7KIahJ34ReHvwQbUYqYIYIlt9tTy549oZ2dzmxKVwsPyNv5CR6xPmisDgZJjz4NuuiM61BuHVZxGrn+avowaDUE9SNymQzt9Nf/De0btnrK1RIl4mX87O1QtaGwZpSDa7L+R0L1jnoOuH1DTZuTGPQ/cmZUEdYk8js+BVxEZK5mTucxGQE6J9avTwEMEiHh5qjYNbITU7wdHNKzO59+K0QZEn4j8wzvUljxDeIEcEYSq9fDar78jjwIUHzYi3TGZMY5P5HXAhrSgipw7nGhQX7rcJa7LIgP9dIs3o8VsmjzkCHG8tpPIPL38VYwoAFl5A1I4clcsgrXVOjqejDiZsbAs8XZn0kk3ZAR5UuKvZ8bs9Fp7PTUoxDlj+7mNVeKelxzFFgPTAk4JeNnf5B3zJOTQ4O/luusaqapz/hcNxI3EWxOoMpiteYj2Ljcjcl6t/bpeFcX+oqhCkk+A102To+DE4c9hYr0RA4f8bepkFVm8eq8Q57tNT/YktnpiRJntL9VmO+0WpVd1fe6qf4YqJN5Imu1DhxRE5HgoO9XPUsZNMzu3bcFINzxD+n0tJmEFpt2PUaD7e8jqAKG4OqR5Wj9ooXBqjcIrMUuUJziiQuGgCXwtq26NEvVDP4OMVgMbSIA5ZvMbvtiB88Ne2S32apxzbuYwSQ20tt
 0Uslv3Wv
 fNF94u5AllmUoVoKuU6fMUPEgkausewVEcDLjJ9Jql7mauP9are/pDGn8IFEVXUUybtXuikkUF4muKtQ5f1Sa733b3VgySEVgiB/nT5uVfcTkgfPIJ/gGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 11:19:51 +0800
Ridong Chen <ridong.chen@linux.dev> wrote:

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

On 32bit it is only necessary to use a 64bit intermediary.
mul_u64_u64_div_u64() will drop back to the (probably faster) 64 by 64
divide (and then maybe to a 64 by 32 one).
But there is a lot of extra code before that happens.

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
>  
> -		ep += unclaimed;
> +		ep += mul_u64_u64_div_u64(unclaimed, unprotected, parent_unprotected);

If the ratio is forced to 1 there is no point doing the scaling.
So maybe:
		if (likely(parent_unprotected > unprotected))
			unclaimed = mul_u64_u64_div_u64(unclaimed, unprotected,
							parent_unprotected);
		ep += unclaimed;
OTOH if the min() generates a cmov rather than a conditional branch
then you don't get a statically mispredicted branch in the normal case
(which is very likely with the empty 'else' branch).

David

>  	}
>  
>  	return ep;


