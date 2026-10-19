Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A936F606A320
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M5ZEqEz+
Received: by kanga.kvack.org (Postfix)
	id C05146B0326; Mon, 19 Oct 2026 13:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDAFA6B0328; Mon, 19 Oct 2026 13:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18ED6B0329; Mon, 19 Oct 2026 13:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9155C6B0326
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:49:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2961FA0756
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:49:31 +0000 (UTC)
X-FDA: 85340112942.25.F8E6873
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C3D2C20003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:49:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5ZEqEz+;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792432169;
	b=1/mfsrhb85cjclpee5lsVVdiO6u2SZrruWEpWeE8soZx+aJirAAacxLzH92uXVvsoHjqVx
	W2bQvEmgfPRg+mwPFPdYkKoC3RyNYEjtYrqlUQGfLotSIxxLfMUbR0LSiD8TFoTqpCvxeX
	5tpmoKRdgyCy4+pY1NXUorYsXKw5ge4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M5ZEqEz+;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792432169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84vZokJdy1G2Wp0ECYuYujiRQot5ob2MnqXlmNb25mQ=;
	b=rca+XqektkRMMrd/CQTHkb4yhaj4lci0yVXXFQthOI9ziWsMzrvIZzJGWB+MtwY47ME3ta
	Mzg7T2MeETwMmUrfMVsZrgS3Qyy43eidI+qJ8E9sEXNXaGwbqZtYiZuK8m0iW0bJGwDaXe
	ANVZcHFM32qb+J6a590lzIivviIrpKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACE6A42D73;
	Mon, 19 Oct 2026 17:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E051F000C4;
	Mon, 19 Oct 2026 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792432168;
	bh=84vZokJdy1G2Wp0ECYuYujiRQot5ob2MnqXlmNb25mQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M5ZEqEz+0N8eLpvUxe5VAvH52RopY+l1Q2dtq/dgjRTIT5zyLGqAynY3wXGzxPxdV
	 ynoZvlXZm6uUe4LjEjw9qEJgcpCIVREb7qyvEq2KQWPjqrjhn/yJ4XzkCvSv0czel/
	 7kfOXqhCAOdCXq0W9ad+68B7nra4FtCSmHbH6xKBQG7ZtKctlq2cUoPqlEK/R/MGZD
	 LiGqowNpethjEgsQt4zzThq0G6BwcvZhPltZW5pz4lF/ltN3nJKHGQQOg5GJzVbuOK
	 Qu2K9VddvwVGPJejoaqk6u6dRqZFq6AJW9t8D8Lh50YaAUVNlG61nbmp/2s2MjjZvJ
	 b8TGdBo5D8tYQ==
Date: Mon, 19 Oct 2026 18:49:26 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu: clean up callers of pcpu_obj_full_size()
Message-ID: <atZWW7V0MI--HOke@thinkstation>
References: <20261019162803.281810-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019162803.281810-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C3D2C20003
X-Stat-Signature: 7fidg55cmc5oqm7pzmj8rzmgmoqzgpqn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792432169-535256
X-HE-Meta: U2FsdGVkX19osoGbVSgWiToFrxXjlFkrhC2m597LPpbZwTlUm6zcMH2zirWknQQhyKRHv9iWYEo7TvS0udOwitdzdPiaqY7AwhLNTsijJob8dCLL1PWLQXOu4pAXQ9EGKPTIKUF1pb8+H9DXYQnF05KcRcWD1oyxlg5hDhIVQNpLmcSR0UyLGLsfyEl97lbZ2n9ojDYqied2N5kRp6qSXHcRu+FXlHdk7ECik0GGZMswywZq7Kqr8woEvgXkTYs/s/SRFQ8Z4CstNgeWFLh3NX4p6A+ysLEydnoFx6++51ZvZ112ENtJNPUeJxRxQdGQI7MtZgDEtg4JsrSrNmH6DlyrX297Tr6uIAHQmZUNcn/bKZLcZgVaFqy/4BFYIQJ717fm77t0Q0OQk9k5iR6OJTFnbiXQS2VeaPqT7b+9kyqbLZN1dxfJX99PHueryF3i2gc1JniBxeT5HmlH3GzWyp0g21d4HuBWfsYt0vCIHkjLYxHo5dJqDomQDL40JmagmQYukbJW8VXpHIX0/UqZquX4OHA1Dy5AMqnqkgIPmQMEiZeUScrNjDNs/cV+247jPhhWP0iuJzM/Yhfjx0X5gMjRSjt/LiWhdp3HVyuQxYBxOgfTegeWitSLa8us6lqoHf42dkF5LYTrTXN8bR/hSWqibH91lXI7AUi8wf99VPDts/gRDtiijCXIPGZ+Ss725nGNr9+Ox6q9Y1J/C4WNiY3fs6lJH1muLfvuDxcrvhhHzTdUXv6xg2y6itae+TauzjCcs3Rxx9pAKjDa5oZUYkq5pYjzGo23wmN+xGQ42wOpzcHrtSUExw+I9jbU/0WwD+61/lyQ+Movx3M6ek4N2VnOfkKYVbaF+Jp+Lzk6+sykU33uS3r0KtdsTuEekcow+aTAd29WSidQDyQ2+U3jvoSv+vS/KwFou+tJNiPur3s3ClA6ZBQnV3ou8iJ9Ug2NCUBs4jpQYmEytvx4bli
 AkwL+8Fx
 SBvTthl7PI3nHtBnZIjaUyVC54H8nzOD0Nxw8iVfZj78D2ZRvovNINSAx5UWqPk8SPkFWgPuq2E4OK60swQfy9pc3dO1OqMtqeu3JQMxNL12glDMLwFzNFCpWQ8tTAsMQvZv56hiULyfAoIgYFvK0cYBJmoAbTrGNCD1l0/tgoIML1is1U3yuMyxLf/u3hy/TZYELTL9FXnFh+e5XJ1oVqA9okZff937FEW8daNYDe1q9wmykMBr+Hoe/rC3vz0dVuzYFwJEaqmWBPG7WKUaytkrGnS8v/YQIJQeONAPwSZyyxJ1ROg72rkxzVGqtLhfBzr7qBCshVTNCjOFWoz/u6P2zaKtbASc2OtSU1GNnpuvNdwnrGa9NL0jqxrklOtoCIHGOoipO1YYwZxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 09:28:02AM -0700, Joshua Hahn wrote:
> The size of a pcpu allocation can be interpreted in two ways:
> 1. The size of the allocation attributable to a single CPU.
> 2. The total size of the allocation across all CPUs, including the
>    allocation overhead (for obj_cgroup membership).
> 
> In most accounting paths for percpu memory, we need the second
> definition (total size). Make this more obvious by coalescing the
> callers of pcpu_obj_full_size().
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/percpu.c | 39 +++++++++++++++++++--------------------
>  1 file changed, 19 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index d7883507dc151..76848e096caee 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1623,7 +1623,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
>  	if (!objcg || obj_cgroup_is_root(objcg))
>  		return true;
>  
> -	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
> +	if (obj_cgroup_charge(objcg, gfp, size))
>  		return false;
>  
>  	*objcgp = objcg;
> @@ -1642,11 +1642,10 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
>  		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
>  
>  		rcu_read_lock();
> -		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
> -				pcpu_obj_full_size(size));
> +		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, size);
>  		rcu_read_unlock();
>  	} else {
> -		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
> +		obj_cgroup_uncharge(objcg, size);
>  	}
>  }
>  
> @@ -1662,11 +1661,10 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)

Perhaps it's better to rename 'size' parameter to 'full_size' in those
memcg hooks to make it clear it's expecting total size?

Otherwise LGTM!
Thanks for cleaning this up.

And it might be beyond the scope of this patch, but I think
trace_percpu_alloc_percpu_fail() should take full_size instead of size.

Wdyt?

-- 
Cheers,
Harry / Hyeonggon

