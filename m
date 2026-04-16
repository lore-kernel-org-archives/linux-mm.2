Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A529F433E1
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 04:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8022B6B0005; Thu, 16 Apr 2026 00:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3356B0089; Thu, 16 Apr 2026 00:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8996B008A; Thu, 16 Apr 2026 00:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8696B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:13:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB5C116072A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:13:18 +0000 (UTC)
X-FDA: 84663099276.23.161BFF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1FFC82000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:13:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a68wlh3T;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776312797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKb9JM1yW4OGzm0QYdx5qXRXuSH6UikK8GqifcEF6hc=;
	b=dHOhVCBD9n6B3R9Edp2zZNNjYim3ZHXMWeqevtYCqda8F0udcrKug5i6Qxpp+cOYtRyZZD
	FUpXfSX7k+lRAiYItjHZql3z5zbLZ7xtB+zWHFxkfUr1vrCNbkA7MXFKVJQVihpuyj81wc
	cjlzIfouznpDHy5MQ69B02eENOKUPTw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a68wlh3T;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776312797; a=rsa-sha256;
	cv=none;
	b=FnDyRpO1h9pITYeUs/kiWUXTTsF8me+BBeijGDHbcHDUTnb7JekkkJfIj0PKzvZoml0769
	f8AbV4zvrnlL/OcWVogVlpKzZsVMe+Qg4Pb7rHZs9OfjMxtHQKhjBu1Gko7G5vkrq/jDly
	GJ8x8GjAUxc+PQwhs6J83HLny2U3ZKU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 869EE60120
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8FCC2BCB4;
	Thu, 16 Apr 2026 04:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776312796;
	bh=vD/gcfMzRsuavrVDfqMZ9Hv/UoqXXZdxe2zTSNX13zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a68wlh3TrNLWL226PEY2wRj8qC4CEkv1VGgX2ByJ5PesKDTKVok/onKStNEgl2RCE
	 tUrM4MT4GSwLuSiJV2sP9f0xYPjHM68sulgAq09yIEAwItHHUqVy2Yp5HxdusOjmbZ
	 hblkQvYk7pCUiyVXWLBsTbbeTfgK7MIl0/zjQAbPiLgCfpSpmgyYJ3ntZs1gyvs77v
	 aEOEaTUeyD5J2QrFiJOJjdg3UCFofNhF63gKQ52CrfErnj4CuC7QofgxFPka9BMbah
	 d4y5NT19OcRG736N248zx1JwAAM5uRvBft0nC1S6AwI50XIQ42bB6JyKFlTHAxsTyw
	 IRURg95W4VlpA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Wed, 15 Apr 2026 21:13:05 -0700
Message-ID: <20260416041306.88803-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414053742.90296-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r6xp4uhsi8npoxrkdomti5im3w7rcxxi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FFC82000B
X-HE-Tag: 1776312796-769799
X-HE-Meta: U2FsdGVkX1/VAyR8CGmRIW/0uQHnyN2sk5qaugSD8CaMpfhSPo/E4TkjDez8lFL/o64fzfyWmuu9HlQqH936okVFcMsK7UUy1gPoEMUMCmpUh1u2eiuLlIBtb8iUfX6AMLi1xClAdPooStdfVGOKXt3SyT7EsJOO3QOwmcTMliSl148kmq2rh2h7bKde8d9CAH4dv0nh0iFxyXatrt+fcNkZzpb9s0wzIN6kmK8idjNIr4WDWpNYC3tfI9e4AVgvWkWb3kYpnBDBNSE5adFKau7i4v+HpPsnWpoJ+s8IDuPCW5rhwjf8dMH+btOmqI6UXGKCCRT7GkQXvT7bH44IOnpB63y8pslXfhYw7HCYUh3OgM0ti85i4UTBout+PzSjWblq+IfqPJR5cAqzp3q5pWsWPWVb+4mvmJuD7Oec51J/MoSSisLcpsSA/d8LS4g86aFN8TLeGQ4TW3MkMgMVwOU/fxiMo7dYa0r0Y4TNcilSX3/7S9Dca79ywL44e/liVqkTiw88UICk6LdOvcT0F1kokpGPKE5m7Z0cKdJJcQHpV4SLs29LlhRFnDfhOVcmrAO706kRlAMgpPHD0cxZWnmN2WZqwsfZNUrgIMRBwafFyEubUjRJwCbeWBu+TJqNEVnokklwb3I7FW98XUWMi8gUOGcp56Y3TrzX7IxdSrqJM2+fyenupkPRiYTyQbfHUQxbZV9T36GKW/16dBPJZ8Ftx/QTBqMCgea3pku1Xi5NCisV51cCBHaXw/1mbQazNa10G2nlPsRtxUot3/fs8aLUdO6X1ocIHoCmuii1zM9iJiSp0Ss4/PiBTxNlw9yXmvzHeq5mnZJS/CaV9xzaiVOIl8jvM61B+1iwgMMpmZ+QMtQYjh/Buh2jzmxIkew5PZ+DSprvNGWZT/5BWctE5VZopZJsPZNzWHEEPrt5dDL/BGl2uPyRkViT3LuXlfut7Bajio7asB2M5nJqGkq
 vUL70Kax
 LSF7CRhKbGfg3yt5mYxQJXh6J53ow9TCyLTs9BILaTrm4hwm0bquEduzNJ/DvtubazD6u74yh42lqnVcdQudYB2zSDtXQ7VwAKSWagd9MMRB7TyCKqnZVYIHS3qs+5MjnzuWBygflFnRlPNOst1x2E8CyUbDQ8nt9OgGIIixvEiI7BhRutuQxFKqmpQAQubYPsZyWLjLjJoUnnDdHnI/bSl3kxvj62+3fdU2BrNUInXdGfJ8Z5WXUocTjkb9BdAA0r46Gk1S47d4T65cF9NC0fb2BSp8LOQwfoPhUXdnPSgj+kFTMzPZkUF2baBzUrPVsxHOEQ6Nz0bp/jfz3kZXWMgCkeMef54RLIe8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 13 Apr 2026 22:37:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR: Sashiko found a bug of this patch; I will fix it in the next revision.
> Sashiko also found one issue in the existing code; I will work on it
> separately.

No, I was wrong.

> 
> Forwarding full sashiko review in a reply format with my inline comments below,
> for sharing details of my view and doing followup discussions via mails if
> needed.
> 
> > # review url: https://sashiko.dev/#/patchset/20260414045002.88110-2-sj@kernel.org
> > # start of sashiko.dev inline review
> > commit fc6c9ec12df0df57fcce5c90c7a0604cddb1cc78
> > Author: SeongJae Park <sj@kernel.org>
> > 
> > mm/damon/stat: add a parameter for reading kdamond pid
> > 
> > This commit exposes the PID of the DAMON_STAT kdamond via a new read-only
> > module parameter, kdamond_pid. It intends to set this to -1 when DAMON_STAT
> > is disabled.
> > 
> > > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > > index 99ba346f9e325..21fa04d95eeac 100644
> > > --- a/mm/damon/stat.c
> > > +++ b/mm/damon/stat.c
> > [ ... ]
> > > @@ -260,6 +269,9 @@ static int damon_stat_start(void)
> > >  		damon_stat_context = NULL;
> > >  		return err;
> > >  	}
> > > +	kdamond_pid = damon_kdamond_pid(damon_stat_context);
> > > +	if (kdamond_pid < 0)
> > > +		return kdamond_pid;
> > 
> > If damon_kdamond_pid() returns an error code, doesn't this leave the global
> > kdamond_pid set to that negative error code instead of -1?
> > 
> > Also, if we take this early return path, does this code leak the
> > damon_stat_context allocation? The error path just above it correctly
> > calls damon_destroy_ctx(damon_stat_context) and sets it to NULL.
> 
> Nice catch.  I will fix this like below in the next revision.

The kdamond_pid stale value question is indeed a nice catch.  But the
damon_stat_context allocation leak question is not.  It will be cleaned up when
damon_stat_start() is called again, by the cleanup logic at the beginning of
this function.  This is not a bug but an intended behavior.

[...]
> 
> '''
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -223,8 +223,12 @@ static int damon_stat_start(void)
>                 return err;
>         }
>         kdamond_pid = damon_kdamond_pid(damon_stat_context);
> -       if (kdamond_pid < 0)
> -               return kdamond_pid;
> +       if (kdamond_pid < 0) {
> +               err = kdamond_pid;
> +               kdamond_pid = -1;
> +               damon_destroy_ctx(damon_stat_context);
> +               damon_stat_context = NULL;
> +               return err;
> 
>         damon_stat_last_refresh_jiffies = jiffies;
>         call_control.data = damon_stat_context;
> '''
> 
> > 
> > >  
> > >  	damon_stat_last_refresh_jiffies = jiffies;
> > >  	call_control.data = damon_stat_context;
> > >  	return damon_call(damon_stat_context, &call_control);
> > >  }
> > 
> > If damon_call() fails here and returns an error, the caller will handle it
> > by setting enabled to false. Does this leave kdamond_pid holding a stale
> > positive PID instead of being reset to -1?
> 
> Nice catch, but not this patch's fault.  I will separately work on it.

I'm wrong here, too.  This is this patch's fault.  But, there is actually a bug
that pre-existed before this patch.  I was somehow confused.  That is, the
'enabled' value can also be stale, and it can make DAMON_STAT cannot be
restarted before the system is reboot.

I will hold this patch and fix the bug first.

Refer to my comment [1] on the next version of this patch, for more detail.

[1] https://lore.kernel.org/20260416040602.88665-1-sj@kernel.org


Thanks,
SJ

[...]

