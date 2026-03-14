Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CCA107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611C26B0088; Fri, 13 Mar 2026 20:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BFE06B0089; Fri, 13 Mar 2026 20:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBB46B008A; Fri, 13 Mar 2026 20:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 352A56B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:19:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A834C13A9E4
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:19:05 +0000 (UTC)
X-FDA: 84542758650.09.A5FA33A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 10B37C0012
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:19:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAcuTyRV;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773447544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARizicPnI2oCS6hozSwQM5wA0Iww6PiAcGqv4m4qM/I=;
	b=SEYlm494PxfKgKjrcNZAT/pIiu5mRzhOe41PKDJWSRnLCxCTUN3Rhn1/WLpQXzIdhv2238
	chndPOPSeAUEjIbnb58ubFlwZJGKOCPjzykPz2jOg3zQ8k0kS4XKvdjY6GbG/pDbxD1J6c
	8N3Mv7W1OYMqelrdqHTEbaCeWZxOQJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773447544; a=rsa-sha256;
	cv=none;
	b=5Ygh0upqj1fB79kroh9rsTkz5HMYE50RI646hzZ5bKLqtSwIEYVQjhse5CSWdhuglSVxpJ
	syDxTorYeUu/wMYr0MjMNUwUZ9eRwKcHtzXPOQhkFE+I45u24W+m520ufe/Csww6vPb7o6
	UGnt2rQAudfTpRVjKowlP5Jx2j/mu3g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAcuTyRV;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E44B60131;
	Sat, 14 Mar 2026 00:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAA5C19421;
	Sat, 14 Mar 2026 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773447542;
	bh=cNMOKPeKD570b1ZANTu6NCTIdwORzNvjJjCPyu9Q8JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAcuTyRVPp3Q8d5Up+QhF843kVaGD93G7nBWuA9uhRbCrl/gMusIGrHZzzHijl44J
	 kLS3e68D9atZ+yE0g1uECwG1KNGojQPvU3hDfuKSiEr/G+2NRTn4Y8nDTYxste9tci
	 p7mKGqWP4HliHO6B44oFkcF4/1Unr5zHKGYfFoP0YrCcDoFFbURs1ARq4kDvsMF1eC
	 NLq5L5rt1R6Ivbt4NSuqdYEPrHge7NWvoL6RyfH7xafpenarWpmejyZuOTa4fg7NZl
	 aYmuDolG/hodQzD1NTan+Va/zTt2/eor1dy/ajehVulIK9+u0oC2IFKQ6v/LYuka5H
	 XO2Fl21RiT7TA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/5] mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
Date: Fri, 13 Mar 2026 17:18:54 -0700
Message-ID: <20260314001854.79623-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ype3izbyb5xqzjgoq4cg6efhewhg1cjq
X-Rspamd-Queue-Id: 10B37C0012
X-Rspamd-Server: rspam03
X-HE-Tag: 1773447543-566121
X-HE-Meta: U2FsdGVkX1/lCx/LFYKapdKEAQTtA2bgNC0S4PeW8SBjjl+DIX77DCMjJe8OjxMb/nE6+L5FBIlRTzln4VbeIhTq/EPsCReGjCzPbfuVc5/IM6WaVe5q/bGZ1HVDpdmFDZmfksr0bSYDuRYWNsohTCjwf131IcfQn5aMz/QCmkGdaf2X6xNgYWcPqLi/QwwAGgbcNzINFqqrzdMdpr12d3nMLtZkNjebVMjpNN6vwvfrt4I2f3iBu+gL11trdT/JNut9DNw1zcm/sNOQlidK2DhDwpcMi1liLNRnplZpyCrku6mdb6bSgIpqYp6upLoQYx8jeukeFXmUbrBOTdG508Af2c+zlY80n34Wo56J2BFjtsWAEnbfV98mEorbqGrxhMXImgE+bEC0cY5gi2jD7NoBuKZ6FVu3OWbHA+wrDQj5LidjWVLxKAbhb5m8+zWdPTnqTjPvyw+LFreDEbaSlD+gzo/hYsYbpCzDaeuxDg4JWzmeVebntU/p3e7s23tjt9A38zw1A82irnPNnpoZjIupCNWBoS3rDmvV/0iEKz5cs4B3LLbd8wpp3I9R6BIgiVx/Z3kDigiHOEEdvvQVj+3pQpYdkzbXoh+8yMKWSptHo3CGuFgg3EoqdUBnwX6dHvBzIxhONKLJf5GOJVA92E60sg3zZPZTo5cWWNzA1kfXNGWAFq/bNxTnLWaH2VRMoJhFRjhksIYCEKcVRPEGmi+27AhOyCK5hVlWLD6fMlpOAdJd/p4RzbML5QXXFmi1bk+5nV7f3kaUVu4SW/T+Qw+3iBRkBpsg9baVT+rGk0lBIVUocAt/6vjJtLAuHzg5emeC+xLGXuz55FJuLOWJ0XBnYLQW2bAyCN+pR3xouid1K6/XukIUa9NqLZGXGQWMqjs3ov4yxEX2t6Jbrtpb7ly5CG+M0UbjcDaGG727Bm1NoR0VPPcl41ed+NcgLR4eejGpOQx4R4hJ+fTW+kR
 JXij30Wj
 oXwv/9GSiKHnsmpd8WNnNobzvb5irGrvasdvtRYt08SsWFssm5IqVUHCjYA/su+2WYP3OVmMaURivYAmVQgBMrLPrswrfQfGy21l0+Fy8W8CjO29GFGd2xj9YTByOFgQr5O0nwZguTh7Xk3wIycOalKRkhlPBX0Mqbr3AuryRiJUJucJWUcsGixdQP0wlZ33/o2116/EnUb7iDzqNZrKFRivja8TGm8GvUYllg4chV5F1V98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 22:29:24 -0700 SeongJae Park <sj@kernel.org> wrote:

> damon_find_biggest_system_ram() was not supporting addr_unit in the
> past.  Hence, its caller, damon_set_region_biggest_system_ram_default(),
> was also not supporting addr_unit.  The previous commit has updated the
> inner function to support addr_unit.  There is no more reason to not
> support addr_unit on damon_set_region_biggest_system_ram_default().
> Rather, it makes unnecessary inconsistency on support of addr_unit.
> Update it to receive addr_unit and handle it inside.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 1 +
>  mm/damon/core.c       | 7 ++++---
>  mm/damon/lru_sort.c   | 1 +
>  mm/damon/reclaim.c    | 1 +
>  mm/damon/stat.c       | 2 +-
>  5 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 1130c2f9a92f4..3a441fbca170d 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -988,6 +988,7 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
>  
>  int damon_set_region_biggest_system_ram_default(struct damon_target *t,
>  				unsigned long *start, unsigned long *end,
> +				unsigned long addr_unit,
>  				unsigned long min_region_sz);
>  
>  #endif	/* CONFIG_DAMON */
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index aee61bf991baa..d4f86c20b4f48 100644
[...]
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
[...]
> @@ -3123,12 +3124,12 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
>  		return -EINVAL;
>  
>  	if (!*start && !*end &&
> -		!damon_find_biggest_system_ram(start, end, 1))
> +			!damon_find_biggest_system_ram(start, end, addr_unit))
>  		return -EINVAL;
>  
>  	addr_range.start = *start;
>  	addr_range.end = *end;
> -	return damon_set_regions(t, &addr_range, 1, min_region_sz);
> +	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);

The above line is unnecessarily and wrongly changing the third argument.  It is
the number of ranges that passed by the second argument, never meant to be the
addr_unit.

A similar bug [1] was found by an AI review, and I found this patch also has a
similar bug.

Andrew, could you please add below attaching fixup?

[1] https://lore.kernel.org/20260313234026.48872-1-sj@kernel.org


Thanks,
SJ

[...]
=== >8 ===
From 0d00bb5ca76502aef4a6a97b0855e33435147269 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Fri, 13 Mar 2026 16:49:08 -0700
Subject: [PATCH] mm/damon/core: fix wrong damon_set_regions() argument

The third argument is the length of the second parameter.  But addr_unit
is wrongly being passed.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d4f86c20b4f48..f9854aedc42d1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3129,7 +3129,7 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
+	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
 /*
-- 
2.47.3


