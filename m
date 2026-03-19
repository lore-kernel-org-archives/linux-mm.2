Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3789C1075286
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 09:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C5C6B0450; Thu, 19 Mar 2026 05:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CD96B0452; Thu, 19 Mar 2026 05:29:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A366B0453; Thu, 19 Mar 2026 05:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74E126B0450
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 05:29:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14214140476
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:29:21 +0000 (UTC)
X-FDA: 84562289322.24.046BC70
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DDF74000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:29:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="GLdX/8tL";
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773912559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50t0EU0nC78Y1uj1H0W04uR9q1D5oxGNIJsGhLT6WV8=;
	b=1qh3KBa3KLH/WOjkMD4UvoOjz1B4Nuilg+gm4MK+H8/dH+9Ne6t51ak32I/6O1QRStE18q
	kvvheE/u2SI6oP9rHJENPSAWS+3zvQPRqHJNFDXNxl9j/TxJZIlBiqtqHCDbv/p6Z0vwt+
	pYqdJNiYmoIAvP+k/bT8g8nPoLynWlE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="GLdX/8tL";
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773912559; a=rsa-sha256;
	cv=none;
	b=VJ5S/AB7+iwd0KSzI2usJIHbxAs6tWyTnjSDhbyf5vmt4Uxcx3gZ2xP+ZkRbiADO3gp+H4
	NGnyJr9VieiC23tf7d0cB0KBvZ0/mIIoX9vE9r4vvTirxophh35ITw0GZAytW4mBox4/b4
	pQszNnCBfANzipUYIrhW4YSirlvFhjw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43b467dcf0bso1200733f8f.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773912557; x=1774517357; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=50t0EU0nC78Y1uj1H0W04uR9q1D5oxGNIJsGhLT6WV8=;
        b=GLdX/8tLCWVwuhjnRneuNSPhKuxaOvxd9/By8WE//2M9AFKwnhIl/4UfKgDcy2pUjt
         RSKH4buhWXXYEcd276eAsY3dFidnC8GpppQqfchX1nQREW9SzyArqtbQAAP2EPJsQ35U
         hSBfk3YrHAq/XIIPLz4F5ZZu+RlPD4NL3upSmbBKq1KAfBTp2DBvlXcOvRgA0f8jyCoN
         MhWqE8DqlT0oftpemqBhO9n2kUoeWq/UJ88Jaj4tA9GayFXTRp7aBXS+2La9ppoc1rm2
         BLeI/4Io11MJTGdD+o4lxQTjKLAxFQlaTEEIKjQN99hQgQ1YrpjqO0ogJWkXGNagfiPI
         kWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773912557; x=1774517357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=50t0EU0nC78Y1uj1H0W04uR9q1D5oxGNIJsGhLT6WV8=;
        b=qTL3/m1xVq0ZMfrOpq9qpZJEpxc14WMxBrpqQg4ifEcVDjsSCCGpv/4N8hS9ghkXq6
         D6o+Z4TlvgX4ZardUjL0Z3GP2/gjP/cyni6l7afSSTFOn+icUZceAgZFYC7TkPsQCNRK
         wdNbeVe1siEtiBOdUqEOqhEnKQ+gA3kV1EIb0vHsUzUC//+S57hWtRBAw/gkP7cuucnV
         dhsabEDUzTcoB2bHn/PSaL7X/ePw4xeatVqBZGxDLDexy3qY4oRW9Np2B7cGfRxgnKa6
         NNuIh56VfBpdWHOrqh0xu17J2pPpgTnekg+aIYfdWafDL+sCOwOl2RLKaR1BYuIeLvon
         fj7w==
X-Forwarded-Encrypted: i=1; AJvYcCV7Ef887Df4Ra5EIUw7Q91F9Or+1wLxFu/pNitC6wNsYDThb/3g9w5E3X1URIRo9Rbi8GKwA4FvOw==@kvack.org
X-Gm-Message-State: AOJu0YyQ6WpSVoPfXehKNklOebO8YdnRASaXH38z8c3s3hZWrecxF10t
	naDetuRpGNneo6YGUO3L5Mtr2RooFzgdoxMQMkHe6xyCLnzp6wZi91gK0+y1yBief6w=
X-Gm-Gg: ATEYQzyKIlEfam35z8JHEpNrY63oUzM43pv+EN7mF+EexjDgPpzV5/uEzmCgxdDtyN2
	7z1cXDIBiulR6G4SUt6TLixOqggvOgkD+wWUNU/2EoV1FKK4Hbr0CcxVAO/9zjolf18u933Woke
	hh5IYu8werxcBBSm+HiFPE5ORAu1grRoOLK5UAWHcwPMDsv1dfmfe8lJrSiuql9iX34IF5WEAxc
	ua0OTz/Vt4+jzcmN107J67GZDoDAcTOzRG0FIrDaXVrQhgUByqkKeQqYZlgXoXtgGviXRuUakxR
	QCWozrmX2+rdsZx7PhFohU82sPE4DTgIFgOiEbjiOy7Ic5Btff1AKDr5nc4S5gKGnnJEfTSDm0f
	nzvG557yhiTXNqpD8ClJ8a1v65MaUoTjHonkX9k0a3XyxuDNtYuV89RuK4j5vpki5si3d27jc6K
	v0wgwOrkYbpt5nMpW5sQQStTN69ofscrq36g==
X-Received: by 2002:a05:600c:5286:b0:485:50ac:b8cf with SMTP id 5b1f17b1804b1-486f8aa4c58mr41526415e9.0.1773912557243;
        Thu, 19 Mar 2026 02:29:17 -0700 (PDT)
Received: from localhost (109-81-88-11.rct.o2.cz. [109.81.88.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4bbe471sm41130335e9.27.2026.03.19.02.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 02:29:16 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:29:15 +0100
From: Michal Hocko <mhocko@suse.com>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org,
	david@kernel.org, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	kasong@tencent.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, muchun.song@linux.dev,
	nphamcs@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com,
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <abvB65BYCUDT9JF1@tiehlicka>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
X-Stat-Signature: eck1i56x83zeumk1n4rkpuy7oxyo8j3e
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DDF74000C
X-HE-Tag: 1773912558-512709
X-HE-Meta: U2FsdGVkX1+PQ7xEJTec9nryVMERVGuNwzq7PSb7DVVofvDTfxxthiFvjUnX+/d9fgt7WOSQW7rNdSmhrH4QnlVQz26WaHS/RLt9ydhU1wmzFgStMkhNxt6g3feC/d5k8H65RhE2X9+lxU6F1RhqILDa4vDp4XV7ds0obQe3wDeBXYGngkt+vvN2k3Imy4MkLPCXCDdNo4AmAoAQ9aOeT+fGT1W7xOQzcC+yGFabnepMFnwECDV1VVZwikKRDUB3NMDSPzpv8s19Tj0kWsR9f+G30kWfSiSuilWGak5vx6sK3C0W5fjHlN5S89hG0mBBZIdNA4nPDbOoV/lfO1s6kjQBR5lxx4TxpSqrdncxqMTYgFapEgtkHuoqy5pJVb5UueA60kxoJ5xXDpA1FqzlZsMLFxgU9jleLdKV/C6hi8pjxIKSl0nwOR7F4L6GfwUUA+UMzMnqsgBsyBldWZkmRl54fICorE2Pd9niMSNH/aH0/vwXb0ZOQ8aZRVzf0uzHnWVDCUBlLxHzkEo3w3gJUNgr5AiR+JtDT3le3TrEJHZVaFHGNkRu6o4nBGERct8WVh1DzLSAJ01C6HHSoXOAXyrRyTpF3EsMBdleTzz8JOJ6+1PXOIl6t9csCvngE/A/miiI5u+csl5bJLD2vcPgshmjUTUjA/HYBVFsz6rztqmTfTg2r7Y5X3o3lTcDD8EFg2Q27mvNgfUJB+qtpi1JktNfGIC/y55gMcKCXFD4aKkDlh0OjAYRpDmEe92/MBnviVu9U5Mqwn664k6f4fH4Jc+nO3vSpuba5tEYTnJ6E7/x7m66SsxYllIjbHbFBnl1Ox2KpsgKkAb926WE7/wZYqIPUdMfphMQC9OuSdAQxYwpLbWK8JMDYcBVwVAntbKtXLNQWmZ2A9S6ubr7vdPRS4z8EC0D701IEEmqlZbTrlJwLv+URev4R1oxmG408AJzedCbT1n5fzvWQ4ROHyc
 jXfsS9po
 p6UjlraD6YeLWX+Bc+1ep8qfCu8BGLUVmVH9B/RmryudCoSzVmMdgPocw3U/7rzlobLID0+ruUop+C1cKL5WOrU4oEg3oxaXYS6+V06oXjHAPnobiJexFX0tyom0t0tHYUY5Vfc3E/mnDoNmiHsHm0gfXVXpOOMPEdP1HMQ7p58ASpLA+Zqmz3pT6fuOZXOTp073047KRcxfpflwAvOOujGL+ZMP9L8s63Hk2h6ymwgZgQLx/8jkiJgOgZbjUwLAxpERRnezgxPaNKB2aYULS5uQ8nXJIfT8Jh6fH8b93xqoEpeoDsLjdxvzbAEVr61KwFL444xhCXsdONcDfYgFP0gzvJMgPAq0ZGLOcFylQfrLadjsConH5/cjFkvTvQCOb6Gx99G1ahAs3NkVIvY40N7CxcU9I0o9TLrP7rTBDUcocAXZ0hVi3mDXAKKYUzHALIAV+UnPVmXyIm6K/x4Iu80+myG+c3sS1NkqddUqjHP45Tt2p+2EqKVE9KzxmMvw9DzfgoIkULlo1a5SfiR+dUZp+UvsScchFLj8YcM6qzyuzBhcxSdePPQG/t3NRJ+WPtOsX44iNoKJ39Q8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 22:19:46, Bing Jiao wrote:
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
> 
> This leads to incorrect reclaim behavior. Specifically,
> MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> is reached. After reclaimation attemps, a subsequent retry may
> successfully charge memcg->memsw but fail on the memcg->memory charge.
> In this case, swapping should be permitted, but the carried-over state
> prevents it.

Have you noticed this happening in practice or is this based on the code
reading?
 
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
> 
> Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> v3:
> - Corrected the Fixes tag (Yosry).
> 
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..303ac622d22d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	struct page_counter *counter;
>  	unsigned long nr_reclaimed;
>  	bool passed_oom = false;
> -	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
> +	unsigned int reclaim_options;
>  	bool drained = false;
>  	bool raised_max_event = false;
>  	unsigned long pflags;
> @@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  		/* Avoid the refill and flush of the older stock */
>  		batch = nr_pages;
> 
> +	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
>  	if (!do_memsw_account() ||
>  	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>  		if (page_counter_try_charge(&memcg->memory, batch, &counter))
> --
> 2.53.0.851.ga537e3e6e9-goog

-- 
Michal Hocko
SUSE Labs

