Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D440D2F031
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 13:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFA46B0088; Tue, 27 Jan 2026 08:55:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1636B008A; Tue, 27 Jan 2026 08:55:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8576B008C; Tue, 27 Jan 2026 08:55:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EF496B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 08:55:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 425511AEC91
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:55:19 +0000 (UTC)
X-FDA: 84377890758.30.6061AB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 97D3F4000B
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:55:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/3eI0M+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769522117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Pf3eP8CHXDi8tNLjjn+imZ5xLmyEQR8t0w5VOyVez4=;
	b=bLJGF0+D317/vDumnbAMvTykjBOicqaKCpx8cxHxI3oERzr/PQOBCEbDeSmPFciwSwNdtm
	LJbelF8uiQRGCfgFjgaE2ufSJXYeCDSEpCo+FUsiuRGnCN9OrCismbXQdOqRwoZ3qcULGu
	WjzunXgKLx2gP1x0oSLAq/kX0chUPKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769522117; a=rsa-sha256;
	cv=none;
	b=L24R3QdFoO0tQz8hix3KQ0rL3un+f3BpT6soreoN1KGDv7q8EAWtth3YRrAJJVuFxLDSO1
	SEXjOgY+gth8SFoASljnYhNYqD3plsqGJLuAllC1zQK+D6Yjiu2gN5iGnKlMkHs++Rd4Tx
	7A1BjaW1T3RCaZdrUsCS0Q63qPQiE6U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="s/3eI0M+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D72EE6012A;
	Tue, 27 Jan 2026 13:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDEAC116C6;
	Tue, 27 Jan 2026 13:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769522116;
	bh=XCH8Wz4CI5ZglnNIsHiUejB2LHfmUzbG247xBvpyHnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s/3eI0M+Oeb//gY6t9o2cY1DgUv36AL1K2WjuI/a3klNxzb+xW37AZ0xqQNVs9amO
	 J59ysBBq4mvMXPI23DPmKG2r063lZZiKt1cL082uI2PzKioV9r+7xCW0caM77GbEJW
	 F7HK0SOT0usLeqgBm/hps7nl+SYxTJzku72e2fVPHtQ9FIi8ILIqm8hC3sh3dC0X8O
	 +Uw8rE+O7ajoL5MuYC+mGfQMyz6u2DPa61zr8v4cVbvzC18L9CMNdLT3q4FQPj8dm9
	 KN1O+A7v97wIDBaU6o0BG0IAAdXVKeLPHCfJO5Tjyj1mJBvKpJxIF4RXNwoFHjuxt7
	 lgFAE05RPAXQw==
Date: Tue, 27 Jan 2026 14:55:13 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 3/3] mm: add WQ_PERCPU to alloc_workqueue users
Message-ID: <aXjDwUpXRdn_JgVZ@localhost.localdomain>
References: <20260113114630.152942-1-marco.crivellari@suse.com>
 <20260113114630.152942-4-marco.crivellari@suse.com>
 <20260124222135.XyGv6OqY@linutronix.de>
 <20260124152241.d97b8b525c1d67ad2b0423f7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260124152241.d97b8b525c1d67ad2b0423f7@linux-foundation.org>
X-Rspamd-Queue-Id: 97D3F4000B
X-Stat-Signature: whupgyfs3yejc1b55cyp93uexeu6tx4c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769522117-481036
X-HE-Meta: U2FsdGVkX1/m20MHir1BuWeSfcLbpwaq67xEdGGAgI3Cs9zZ3NHG/8Vfnu6AvNiI59F4Fl7RAX1Y9yGYUulbkZjtNLoz+zuDQu6Ktn650jqXE7tpnWV+As3fEtxgsEkMrmxkNUSTNQlBCw9RIY0lhfvsQjBHk7NDfJ+J3NSxOnpsUj8Q6fO/AL5JcppGEgXKBt/Liys7e3m+sl9XMi3rI2DmfnHrF8Mw4h8ep4Ey4HBclgWb5nu/U+QYXX4i9AZf6Cc/K9MDSDLkgxqlOdYCHcslaFfu7ErDP8Yq+I7FB+IDLcxCvUoV9ql+7iBdHeAULgSj1GmHz35caGbBZy3tESBTEqmM1xPIUU/9Ai6Z3tDCTQxOfY3KLAZpxQDQtGPuc3dyTqYLy+rAoCQ9PJn32/Wi+kFTLOawBmFbG4FIR7Bh0b+Eaz6234EZ04w4BvCImaQbtVZyVBd2nARDEROp0xIQppEy4x6dlQ5+oh0kjymi66OxuGpA64cb2hHgiRI6L+/7LSmpNyyHeuLzoSIF1olSxlBiQ2Ooy4uwI2Chxii3N38h+JTY5vwHT9uzqiDedQV/XQBEP8RxnIQocPLl8r1u7U0QeocTstdSUZRxb3ZBHXeBuvAqP0qKuDk5It1UtCkEdRWS29UwGgkRHyyT5J+/9fVTsXAfuKBR9iAkd9NTi1md1Zwq7WtPkNCt5K7VlpoFDAzqec2MGDdjxsNuTOxHjbjygoN5ikRupH2zCDymL8FDm9BQW3E24jDbYJfRweLizqBOQEfB5Z8HTxR3lP2Yd9vx5G5lCidRnxwrOHi/a+NIkj/9jTtfI2EEMvcjMPITSnh22GQKUtDh7Qim0yH5rrbTvlAAin5U8WAGTSlFhl+c2Bt2KOjWpUZChjO+cxmFO3qXE8yjzVFolCmL8tj14mASD0xddiWuIHxbtBXA7QphE/4bsWSPuCjcnqptJRkSF+Y+zLxUbeFjTb6
 qpBYDuwm
 qAH7wKivDPaX2rVP53z4u6enI/27Fj/Bm/1Mx6L76LWfgS6H3XyGQaY18uiUD4XjsOWywi0tnceuJg7gHdHMmvqCRU7WxoBtRCDxVbYasRbDRdjhahOaVltphYj1gCuKj8SE2ZxOis6Sqr0g8uRYTksxeGDhCUu8dER3f9Cd0gqGN2lB2AavdMatMzGny072F/wklIHGB9MgxFLvaAMJwlu3lbPvq79poDIIAdIPThxXT2E7O1B/rSVvOa/KZDF4zH543nzbLDlHXu8dft2jzEopkS0uwKo/oxt9FbVOFC9+kQ1pqoSxUGzSZA2iJdCV2bfmNfU33WFMQygvGfxvHqEbrncWufD3HqSc4rhAOnrPF4Rgua8pUfmKAjHFECMJ1GonA4RZ0AlclooYp3/dPcwD9Zbx9lIpdCQ/e2vxVUr+K0x0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sat, Jan 24, 2026 at 03:22:41PM -0800, Andrew Morton a écrit :
> On Sat, 24 Jan 2026 23:21:35 +0100 Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
> > On 2026-01-13 12:46:30 [+0100], Marco Crivellari wrote:
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -8542,7 +8542,9 @@ void __init kmem_cache_init(void)
> > >  
> > >  void __init kmem_cache_init_late(void)
> > >  {
> > > -	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
> > > +#ifndef CONFIG_SLUB_TINY
> > 
> > This ifndef does not belong here.
> > 
> > > +	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
> > > +				  0);
> > >  	WARN_ON(!flushwq);
> > >  }
> 
> Yup, thanks, mm.git is carrying a -fix patch, which is actually wrong.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-add-wq_percpu-to-alloc_workqueue-users-fix
> Date: Tue Jan 13 05:59:13 PM PST 2026
> 
> fix mm/slub.c
> 
> Cc: Marco Crivellari <marco.crivellari@suse.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/slub.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix
> +++ a/mm/slub.c
> @@ -8546,6 +8546,7 @@ void __init kmem_cache_init_late(void)
>  	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
>  				  0);
>  	WARN_ON(!flushwq);
> +#endif
>  }
>  
>  struct kmem_cache *
> 
> 
> 
> I'll add this:
> 
> --- a/mm/slub.c~mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix
> +++ a/mm/slub.c
> @@ -8542,11 +8542,9 @@ void __init kmem_cache_init(void)
>  
>  void __init kmem_cache_init_late(void)
>  {
> -#ifndef CONFIG_SLUB_TINY
>  	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM | WQ_PERCPU,
>  				  0);
>  	WARN_ON(!flushwq);
> -#endif

With that as a fixup, looks good:

Reviewed-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

