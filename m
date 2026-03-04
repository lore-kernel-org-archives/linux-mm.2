Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F38F6EB7ED9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5D36B0088; Wed,  4 Mar 2026 07:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80426B0089; Wed,  4 Mar 2026 07:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0476B008A; Wed,  4 Mar 2026 07:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2C36B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:30:34 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3887F1A054B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:30:34 +0000 (UTC)
X-FDA: 84508313988.25.8DC880C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7FF34140012
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:30:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q9Yq1O9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772627432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lA+aYUQXj58/ok1aFEI1/2/lGWm/U8347mIHUR28+QI=;
	b=uUHQKleglzffKbQ57xKI98RLY37PytdWvPzKVe4agPhR/4nnHMHbn92D3rm2/hnb707PsW
	eh6WH6U+YFa1URgCJlPi5X4V6ZL+xTD2lXouuKkLk2KfNEF151+Nn7vRxda22Kp42A5OFI
	Bl9hzAXYycBttaesDtzQi/t/Kmcso44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772627432; a=rsa-sha256;
	cv=none;
	b=BdxOJltWub8+zmM1iIVuc8ENawgm0sNHaYeBFjDjKIyKpObJ1zkZrkpXv43xDH8Ay7kgPl
	t5Ot3eM08a+dhDLqIX8qGZQ4h/6VVsiV+J/H3ZF4vaytMtYyW4FsPSQt9u0m4IXnpFso+s
	2pe9IMhcl9kj2vl0elSETSaKrnFqQos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q9Yq1O9e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE93560097;
	Wed,  4 Mar 2026 12:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D165CC19423;
	Wed,  4 Mar 2026 12:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772627431;
	bh=MsZhn9HPj8dfixAC6alNeGFOzSftdMRsHBiHTVnEr/M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q9Yq1O9epDse15BKgVQ1oP95tLsSV0203ET9FjY4xDnn7znAoOEzYrx/rFx3L9ujI
	 1tXkZiHZpKA5niRStB1UxeEihRMVzsoOon4lw3deyuKTiOaQAeRkgeJg6LohlSCJ+4
	 PkQ1tz44Wf370hjVll/7Bqyou+Qcfn92vepVHLVahnv3r8hPngz4dUjSeAIEw3ccyL
	 djL6SaSusjodls/fR3KeatoXh3WqNePElLm7azVvODz953ugE8iiHvRbSGXR0rNkmV
	 QNhntKEQTraNsgXNJ+1Ej4D76N3MuTMKjg4Tprot8mv+1WYbbS7/zuEY8tkX2idGTC
	 9MejedcLxtD2g==
Message-ID: <be2de159-91aa-47a3-8da3-f186c2e38a03@kernel.org>
Date: Wed, 4 Mar 2026 13:30:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slab: Update stale comment for sheaf_capacity.
To: Kuniyuki Iwashima <kuniyu@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>
References: <20260228201510.973702-1-kuniyu@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260228201510.973702-1-kuniyu@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7FF34140012
X-Stat-Signature: 8hxpmmo4k1ok187uaxhzj7ysogqnoyy1
X-Rspam-User: 
X-HE-Tag: 1772627432-603549
X-HE-Meta: U2FsdGVkX1/0jmdZYd5nfT/hwEBTMsy694VBEe6K7qKuCsJ1YRXA1OnhR6klkMGjPCC48d6b2qMI1sKgUk+dOWU4l63Yk0HjXjLsgG1WcP0EnWSVq/oZAvSNsMjbbHT3jrGYNS2OSngDktO9zggP1pXehZsnIxmoZ8Pjlbt1ZpzkEmWmIL+LaMuXxdL5J+JvTWcObpcpswV0RiG8jx3QRQnkuYZRF0wfgJKxsbI3TwYqJXakzUuMT3+Qd2izVBBC8ktmrpcoyRrFTzPia7fpGJcP8tLu7j7cYAu7AFvnULCO0eK9STN+Nr9GlEsmSF+bJy1i3zuLNwMwTFqJaBqbrmtXd+qxkp84FRG8zEb+9vfef35bGvDPgQmzDYhO9mRecdJYW58dMz9/oNmxp/mk2eD2Or1fpJJrDiDKFhsdwm6WnBiYc3amITmxBv9XujKZN73m1Z5Pid3HRJcyjuMh07KiU277lui6BzOxadwNoFMoWh45ps+ef3F0zDZmaiXqFgf8HYHTu1OL23qzqxL3+cktMgvKXmPO4Gv8KEUJD+xksMeLBLFy7PfWBZ19a7MGhbAIx8QlN5QOWASyRXpo7ADE2E7L5rsiLlqZ/L/6MhTC0UKlziXhvU3boZsKxGg89tKSdzig+Nta6MNxiDlKaiF0C1prR7g92bR2SRem6ryS/Ori/0YA/r/rs+/TqtTkKjXLNwRCvTTiQJalRFH2YRe3T8BGsNx7mB0rZHGWiGMAbMgRgTm0duxm+48FtI72zj+PYwK8L8SsVjbRvQ7uGz9kQljk629BSIoUy+bL7IJDZTJewonwE4pMvrOFL7gB3SwWJtRWj7xkX/WRTsvTG9FGmBQ6hb2PXYJULDua75utp7i2ltYZPGp4tGIJvoPKcLBIrcXjttQIrs4n7OPAsvxVael1dCZqE9wCLCwAcrLqD0mwl1HaoW5Oyvh24qu+CTtcekBU4NJ+WakGCS6
 uWe1skdM
 8MSrf1tI5CVX6rDhWybwAVYVCgpBWMITxE+qiRpznAvAMx/XGnFkFZpMtLwN3CtfE6rRcSbWpBwl/Z+eH32Z+mYIhltERwHGOh+m5njGpXvyYa4ZXmFSqnvsLtV5/TF+qlOSQlOzVN9ujyyV4vtmgdN88gyLUl13zLmc2atdCie5BG3/14zT/C2mjkjMs4hYl2slntSu+36OI4TKG+61fD52dPI+Td05OV3EGV9QDkTw+A0nzjkn9lqG0tuZ2mzbIr5DWeidb/evoPqEuV337Hl/V7QFvhBg+D49bSIECmAohNhP/lnyQLiFJ8bHlOPPBsNkxZiUo9zd85s8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/28/26 9:15 PM, Kuniyuki Iwashima wrote:
> The comment for sheaf_capacity says it does not enforce NUMA
> placement, but it's not true since commit 4ec1a08d2031 ("slab:
> allow NUMA restricted allocations to use percpu sheaves").
> 
> Let's update the comment.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Hm the comment is now more stale than the NUMA aspect. With 7.0-rc1
sheaves exist for all (non-debug) caches. We probably don't need to
explain the implementation details there anymore. That includes the NUMA
aspect as well. The sheaf_capacity argument can partially override (make
it larger, but not smaller) the automatic sheaf size calculation.

Would you like to rewrite the comment as per above then?

Thanks,
Vlastimil

> ---
>  include/linux/slab.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..7477109eb315 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -359,9 +359,8 @@ struct kmem_cache_args {
>  	 * may replace it with an empty sheaf, unless it's over capacity. In
>  	 * that case a sheaf is bulk freed to slab pages.
>  	 *
> -	 * The sheaves do not enforce NUMA placement of objects, so allocations
> -	 * via kmem_cache_alloc_node() with a node specified other than
> -	 * NUMA_NO_NODE will bypass them.
> +	 * The sheaves try to enforce NUMA placement of objects, but the
> +	 * allocation may fall back to the normal operation.
>  	 *
>  	 * Bulk allocation and free operations also try to use the cpu sheaves
>  	 * and barn, but fallback to using slab pages directly.


