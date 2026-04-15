Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2687F43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:18:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB086B0096; Wed, 15 Apr 2026 11:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BC56B0099; Wed, 15 Apr 2026 11:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA6F6B009B; Wed, 15 Apr 2026 11:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFCCE6B0096
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:18:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6C8DB9A3F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:18:41 +0000 (UTC)
X-FDA: 84661147242.02.E0CBF22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id F039A140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:18:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cy0BooHy;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra6EtkF3z7PFps8jaXuPC6Kmfio0uumOxFyjVmwDmCM=;
	b=6uGoXA0G1S+YXMXIKcrGia4cIoHkBn4H3c7EDL1XIcGaYEjBD/RNxtx2D0ly8o5DYz4fXg
	FFd1Zy+RUeSVwPm8Z9INabUXAWkh/IZ58uy079csJ0dTg3Bka9dtdLOx3j5+avEh+mQ2dh
	tGcdPXNNEwA/UxglGjqzp5sYCEkEaqE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Cy0BooHy;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266320; a=rsa-sha256;
	cv=none;
	b=iT67L0NTskkNdSVyAFpzLvxaIYoDDXpbDurYasVqtztbWM515JpjxIsxcAMvMr5//5ZFdP
	VRRny8eHubMuMMQgVMxMUOD+FEYisRztlqmumY05W1/F7CpsO4ZfkZvnw6nTGaVBkp+l4C
	99wSHNPB7LkQDcn61e/0pHQcFsVAs+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9CC741919;
	Wed, 15 Apr 2026 15:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E3BC19424;
	Wed, 15 Apr 2026 15:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266318;
	bh=spPodaQQ2KV5AGi/Zab2Sit6wY9oszgJNiSDRnTy6So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cy0BooHyYzKBkujHE/ZEtWBSkQhdVdHrxKUGWYpuC29q7sjnOi69xrIbcQBMZku6q
	 rgDgHOGZ6RXC8r7X27Zs3tvqGedq7T0iPVdt8sDJZ2piEuGzQmzy52Z8eiD6xAfQ9I
	 F9xDe05kOkU/+jaCk1nJa4DufC5KxHTOtUuv2uu/4lupouDSlRn2OhzauVYsejZGL5
	 feIBvRa/mVLQ7IBMNzdqATVD6LkBVVJ874MmZIN62yTplT4yE4Wco2yWWBMLZqv9lJ
	 oRyX1p169xSn+Qkh2/t6TagQuonKq/hR3h6GlRZXp+7X1YZXjBfzG9vx3CU0uZbaEc
	 +IBNv/cGUMi9g==
Date: Wed, 15 Apr 2026 18:18:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 02/11] liveupdate: Synchronize lazy initialization of
 FLB private state
Message-ID: <ad-sSRmWYhFiSD-r@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-3-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: F039A140002
X-Rspam-User: 
X-Stat-Signature: tpzun9fmfyah784569o7rcceqa5ecq8n
X-Rspamd-Server: rspam10
X-HE-Tag: 1776266319-624036
X-HE-Meta: U2FsdGVkX1+vFAFVoF3qL1yYVkVYZ8XG/ld6lKv14z9BfZ9+rVQvYpz3tQLvGVHS8hgsdLImg8jx0sQtB+t49bKF08rOxltuytmHAPe1uFIvMpi5jFbE8DQHHob9QM2UhrrW8p/NDK2Zb0d8mL+gzIfxeBQJ1mzQXa0BoBNgNewm/dBnoA3zlniKxzBk2KCjCa4uheyk/BO0QTeQo+HphsaVqjQNJ6cIm4+2OAiSFF6plzDXWeg7OkyBzLLW9PKbI01e2G68OVke0uhjReqgzPawouPOHzfi0z16+c82UGNtgyqt+baGNxdiEA52OV3NN6c2SYuHvA9v/l4q1QMCQsAtaAahio8ZqJw6eqNLc0LJZAb+V3okWYSax5gOFj1JO2LQTXCP4FJMjToKFrKpxij0dtqV4LYNKCGRuNI+bRBeCn440tPtChk8Sburj5AicFfMC9DN4jNLdtNzT6V8Rmm1vZY/XOYfX/sz7vh09CC1bIyQrDfyMmXOcK30zrlMwXMJhpBwoaOdz7J8jzdSppFZQF3WQkcv1wJO49lETMffVIZGR5QxWDe5uVN90grSUudzB8NaqzYYwxvIwfg+rlEPMbWxkq8sOXsmpAMhG0HAR0cqvNrXic1usmIg5UfB3MjEfWCUtbR2E+hyXw3NysG+k/bHNgwzqcGagp7UfXCqVXRNwlHXanoRn3kxoj2nNdBCIgcIcUB/MpxPoY8mMNxBSrZxVyRocLVp9kjLjl3d+ychfbJ17M0Hxcb70D136GsRWLHovKG4yi6kgd8ROg8NOPC5O+ihcBFFKqRu16VasdmPJP68joKvGP4xLE9Q8Y3YOx/bBqmxBIucT5dPoucilivUqcGrbpsfZTaV5pjdFQS4jG2Vm2HOVcdviT5Z7n4orzGrH2riKjgd/t7187tH6sau9ss1nyHWJteVrsI1P1g5CNY8fhItA3miUla1onJ8pGsYP3hrsLow7ZL
 GyS80+3+
 KktRg+k0j8q3867+JgW4TVYlXKIohAUht8QhqDnD+nMAd0aO7r2WqC4jhYTeG7v9JJnP59Tq2WqDHoA44OpWTxZchujEhSHaZMnEBc5X+5klV8mM/NxpanBcn2RUn7NC8m1jn0x5/179+/ACBRkVIjfvaK6xr97Mc5hYdbMeBDiivDbyOnugFwJaaoRkxBuXivB95Ht9z7xcaBAw1jzt5ZV8GO8XEc6lVaCZfhhuOfDkRbAfyQZCK5VS1WPBHjSDUhQBP/YCopgT+bcXE2ioA8yhX1bkNMLG3f0T+whO7bwyqcM3JAj2N+1V/w+cme+ywGRy4VKbkTjLiLALMAhkyV0/jQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:18PM +0000, Pasha Tatashin wrote:
> The luo_flb_get_private() function, which is responsible for lazily
> initializing the private state of FLB objects, can be called
> concurrently from multiple threads. This creates a data
> race on the 'initialized' flag and can lead to multiple executions of
> mutex_init() and INIT_LIST_HEAD() on the same memory.
> 
> Introduce a static spinlock (luo_flb_init_lock) local to the function
> to synchronize the initialization path. Use smp_load_acquire() and
> smp_store_release() for memory ordering between the fast path and the
> slow path.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_flb.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index f52e8114837e..cf4a8f854c83 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -89,13 +89,18 @@ struct luo_flb_link {
>  static struct luo_flb_private *luo_flb_get_private(struct liveupdate_flb *flb)
>  {
>  	struct luo_flb_private *private = &ACCESS_PRIVATE(flb, private);
> +	static DEFINE_SPINLOCK(luo_flb_init_lock);
>  
> +	if (smp_load_acquire(&private->initialized))
> +		return private;
> +
> +	guard(spinlock)(&luo_flb_init_lock);
>  	if (!private->initialized) {
>  		mutex_init(&private->incoming.lock);
>  		mutex_init(&private->outgoing.lock);
>  		INIT_LIST_HEAD(&private->list);
>  		private->users = 0;
> -		private->initialized = true;
> +		smp_store_release(&private->initialized, true);
>  	}
>  
>  	return private;
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

