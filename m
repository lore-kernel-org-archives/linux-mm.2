Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FA8F53D67
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366546B02D4; Mon, 16 Mar 2026 11:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326A16B02D6; Mon, 16 Mar 2026 11:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261156B02D7; Mon, 16 Mar 2026 11:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 148806B02D4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:08:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4CB857946
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:59 +0000 (UTC)
X-FDA: 84552256278.27.D73DE83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1DB2420011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/71dJAg";
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773673678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIXiIkMKBSx5alUKudrVvMHs59i35MsVHo4rN4Xzqj4=;
	b=x0kkInxPoRwxSD9ulKKwOeSfe+lfxB4DfhPNzmmHC+PszgjPd2LMFJwkOoTFk5kLHSFn3k
	D5US2Q9T9Hz96d+buozesaELluqybc3RrQa/0vJWd6x2ArKnxkw9j2pL3Zk5xmMQ+YV8tL
	Gzkgo9IHeK5VIBPjlZZF3dJH4DRyVD4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="n/71dJAg";
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773673678; a=rsa-sha256;
	cv=none;
	b=ON4zKIZbZ/QxeS0v0Dc7Ec9UCmGLs/lm5xsCUEN2tqY2OqqaTafgoCHJJ9wsIxE8nwptap
	z5gse9k99xq5kOTrOW64ijK/h/Cm/c9pxVfZqkVhFt17oqKJNhElQN+97Pe1WbXAo0I3TS
	MVVihk28tTjAUwZQW+T989gyBCgJ+p4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 27CD4435AA;
	Mon, 16 Mar 2026 15:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5946C19421;
	Mon, 16 Mar 2026 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773673677;
	bh=SFx5Z/wna4xcu75GgBDn3B1RzhlnGEjnrkDyKE4lF20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n/71dJAg3PTsVQDyQK41XU4dKdci50IV808kKjc4dbMh4rOOlhlfu3u0JSoFlaYe/
	 V8V1ktqJdBbfjTc/RG2rn02jK96yT+alvCIOXwXkPhlMaMFNENnD3V+laI5Q6fl4+y
	 rqXP0MnMWsF/723x2nosaqnVS8txN0RPoE3I64Xs2jy8NcTIPV303d/YhTHXOsnatS
	 2AdlzruJ7OrxZjXk6PNoudrnw8jwmbmP+BZwwbsPNntVnVQC1iFo3VObk92PBh9OTV
	 Adns6HSKoI1/vHqIYvBjoPFIKG39gSAky8PMVapwRiHSb7GAlgWY4ldN7QT/i1Uajx
	 SIQY0BqihKPUQ==
Date: Mon, 16 Mar 2026 15:07:55 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH 1/2] mm: zswap: Tie per-CPU acomp_ctx lifetime to the
 pool.
Message-ID: <abgckU4DPI0hb6LV@google.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314051632.17931-2-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260314051632.17931-2-kanchanapsridhar2026@gmail.com>
X-Rspamd-Queue-Id: 1DB2420011
X-Stat-Signature: xp958upmgt1hok6i7gwgzze6kyq48fie
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773673677-814036
X-HE-Meta: U2FsdGVkX1+EatnF28m9POpz8uX7jIz9j+JUXxw6kBgayhsOCCDT7ccCjDr2LbETKzSRFLuJZ0cLKlRMq+4lgR5hGnx2sQNIoESA43kz/z18U3Po//H2G8aVi7l8SyN0nMekWa8h+qjIzC34W5a0B2Jr4YjeKTyF7AM724Frqn2ClKssC+0Scc+3dukkVYSXzvrNcJbwLcd5vLfL/off9LkGRIo3OwNeSOnQt6DKmEgJN/i/hxUXbG6QaKmuyKyDCf4ksC6b37nFVKHfruQsDVUQdJjSstP5h/kpJcwaz4yQiB+IQV0A9IxXHwvDg3a27+1TiZi4BoCcXoCWGFYyb2Z4lha9nouzNd7rpob6eyoDreEa0lLvROt4Q3pBVoMoyWqZQhwwt4dBWUoejNEm0564VQ+8810BxwIxgtusFDxxzT65avtG5bwnnv54NEdBhfWGr0fr/PHwQ+Tr1JgwN2pr4cGmQ/6DyzdaY+90TwFqjuQuULPKWiwAOc6HYFgYZm9yra2SAdDiB8voJjroXuAf7s11jTM4jyhmeZerJkXQxLVi1yHBUrKk1iR4fIgwcGnouied/Jl+ziyeEoiKK4SFzD5A7LVbxG3Q237PMXR5dODijvlWpIXfH/GdnDBvmqtu4N0YsBWu1RDKOvOMCB5r7fz6JU9iTO6lM4Pm1FmLDCNJ5WGrOeQWLkol5LeYKETyb+NhnSl2t9qeaztajo5jHZjVc+Nz2erikvFqqpLWi3rRSbQ4q0laYSubaR1jLEQu0R6aZP9D+kPb6DO9Hv3KQ2NQP3u5e0F0A78ziT7gPNNXOQLMPuWV7krG4PdVz13GeQJ4DGEnvc87vKUHfbM3nPJO3WFdd4PZlAwNM48xiT9sR6UcZv/Xvr8Iq8aTOR9rGl9BAMWXd9uk5WybKju2fNnZDPTd+40l5weevOgorgKEG+UQraVH+Cuy2zDC4S1ayva02PXXIBieNOE
 2NEbHS1R
 Bi3gd/oSlSxJXWNE4xq+63dJxiV56vnWIfxl0WyFApZ2WbFjCEfZa44nb1UOwJx53+A8JSyfRxPfvcLK9TWlUjjOEZmjl55EwFRxeFBchQuMDbn4V5bpY587sXSeyedIQhPqg1vdVD6xySLGFl1fwUQHbSPEShmJNdX0ocVi5sABRphZIQIizzX3HmnmW0wLagRad4XGh5D3TbSdW5WPItjB/TGuss5dWY6MVFOAZ2IJRNVoNu2JyBfEcuYEvXA4Itzq0aPI8smeF7/0nP3qGNI3IOEsdG2MPb9+ib+W3Lx3QekXUku5ZeDJDXatjBMsgV2YybCpxUhNCm3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/zswap.c b/mm/zswap.c
> index bdd24430f6ff..26de0468e33b 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -242,6 +242,20 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  **********************************/
>  static void __zswap_pool_empty(struct percpu_ref *ref);
>  
> +static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)

Nit: If you respin, please call this acomp_ctx_free(). It's more
consistent with other naming in zswap.c

