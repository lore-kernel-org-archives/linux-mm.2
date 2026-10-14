Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B10D0CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591706B0088; Wed, 14 Oct 2026 13:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A9A6B008A; Wed, 14 Oct 2026 13:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2BF6B008C; Wed, 14 Oct 2026 13:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B3316B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:37:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 969F440718
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:37:23 +0000 (UTC)
X-FDA: 85321938366.24.E42D28E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED844C0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:37:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E12MS8Ai;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791999442;
	b=7UREzI2b6cRHh0O7vywrAsOKn7DPNEHU/qmNWmP8YITWWEhm/TY7azDY3+lpbKQalRTKbh
	iEVMg7DSOkXLlKj0yrBUx2Nz4XVqCLR9sqRwJ32ZbkdVB/ESSmmXXrf+EWgf13mi+thMF1
	EG25D9vn4fkkbLgQxE29Mj3cbuMJYu4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E12MS8Ai;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791999442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWmhVhzlmIF+Rj1oqypGhYslt6dIJzfsU4ORR9YUvgA=;
	b=mEt8LIXhMOwAGkm4nn+ehRDUrdBkuNq4/FusRJcDVXYvIL1Uju/gF3mviEBdTfxenJTZBE
	Qm26RLDvraON7pVvafwkUF52NaGaVYLJW8Vfin+a5AQo2MUzcS5eDyQoksL8aOtfcVdhpZ
	bsevtXE3aFN5IJNnEB7CKhxrg5K8ZUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6278560098;
	Wed, 14 Oct 2026 17:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FB261F000C4;
	Wed, 14 Oct 2026 17:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791999441;
	bh=ZWmhVhzlmIF+Rj1oqypGhYslt6dIJzfsU4ORR9YUvgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E12MS8AiMR8dRNc+UY0RqzdFVDz49lbTlV0q1h6OI9C3Xk4rbkwf8udPrksrM5J7y
	 HVKvxQ2ytS8SsXT7xRcd4TA8B7QCgJdZFfHQArbrqXppTST6+4SRp66ITsgnkKh5d9
	 VZD8hWWK0S+d2EUecaO1/Kcr6NOV60gCLjawRWxmtIf31ohvW72yhM93zWf06vhAFw
	 GWwnS/sex374D6IsrTwiayTS56Cc7VDk8nYc+MUd1kL5PpupANYBWrrEjJA3jsSpFk
	 uXgmK+bI1nKVH6Tti31bcQN8LCLZNcjyQuSH4DV+WMqir6mwmnFZL8QHS4q8ohOXtG
	 iuFnylLGz8yag==
Date: Wed, 14 Oct 2026 18:37:19 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/percpu: account full object size for percpu memory
 allocations
Message-ID: <as-8PlmZFjB_d-kN@thinkstation>
References: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
 <20261014164349.2332145-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014164349.2332145-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED844C0007
X-Rspam-User: 
X-Stat-Signature: jispa8fe5qihyrkdwd598juuqamxnh61
X-HE-Tag: 1791999441-293042
X-HE-Meta: U2FsdGVkX1/8hZcUeinc4R2MbQQo+6NRBi/itrrRtskdavwasEQJRK1t3Da+idCqYoni6DY2gbzzsH2NMX1zkYneFa//t0iTeQ0KcW3eQde7iMF5MSjkgwx7i7C7tPnNDbOamjZV5kxhfOUSqtc12okj8uyBVap1BgY/g4P+bNC8cRL5FP/Tw5qJc7NnlaigzghNENxD7JzOS7jpnTZBgJOU0QnM/7/7D2kU8Dduk86zwJ5TaIuuBg0HipahfztKr43Ag8tmI5xDSxG4PsaMWm5vHmqYQJRTPB/ZSEAHPH1+DVIVTMLvp0CQLyuOXmQmee5TeSeCCFGVdNiqJlxMUvLID6rqmSHMEeODQexQvoBPc22oqF8DsjoPa8OBbkqankof46CNakqRvryV7eX3gdm7OtB5BLDZxBHNlW7xAYsqBnXONRzDJZYFD8MNLtHOo+HVLcf/5lo4PW0hsvhGboWqdxvaoj5tE3z5c8AM63tF8ajvHoKlKjWYhWHHE5ubFyoJLizEC4Hc5z5VsnDNaF3VF76Stksl/oDXV8Linsd8ciHdLOke354g3lXWm4LEUUDoGP5k15N09c8YEqGLjUvqJFHMcw5xIa1HKBBaoi3Ldnv/eU8qCsbOy5H/HktPani3ogPe96uNbYYmAQWCxQVmmrCfASC7bIKfAAtY3xyJ/Udreg1cK3+F50mW1cRf9FhQ2es9Up7eNwtOk9rUDzP821cnwtbEXD5yOdNb+oOuZh5//mB3PVm96bF5IXZh7pogOq/fhBSU5+GMadAuvHSB58bPFa7wqOYSWigyMYqS3MV8FTB8VlOEzNpskjMxlGcNhZxojt53hU/QtuQAQR4Jf5+VgsmnwgyMTUUx2Fp4peLa509Yvbi0ZEV7asGsPXgqTmDaVfPqyylEK7VCSRuKYFSQqwYwibpGPzYT1iShHK4xDX6LwShR99uEaRNBQBJhS54k9pVzKSXDZeW
 8/3Ow+xp
 vPGuGmRxALq1s1zMplkZj34ftpxI8I00RQVKX4N/YLoGQYwycdHbqrkH3yQn+YiWZg/sa0570NeWfkJFp2875pQ8pziy7ZPx+5ueZtd7+zszIL9L1P+j8MiuZb3aUKn+UAxx8b5X42l8w5tJda0ZaAr5UCvHpNiZRT73OgG/b7si0+/hJJlaBB/pYKZxdx8pGVmcPQSTgZPsuhUltrbhfSY/NnO15daT68KkLajza0tZyDO9owZazA3IPXAdxebYrgUB00HM4x/j6btODplQHJyCZV7KYkEhM3wEiVy8vTkaCykBnjYYw1eHu12uJg3UdWep0YYSUgMqWUcrWdkRzEwDjFVb9biPrrx2Sti1wsMGfuyDRjYiyq6fftg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 09:43:48AM -0700, Joshua Hahn wrote:
> On Tue, 13 Oct 2026 20:34:39 +0100 "Harry Yoo (Meta)" <harry@kernel.org> wrote:
> Hi Harry,

Hi Joshua,

> This looks quite good to me. Thanks for finding this!
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks for reviewing!

> > diff --git a/mm/percpu.c b/mm/percpu.c
> > index 3eff382e565a..d7883507dc15 100644
> > --- a/mm/percpu.c
> > +++ b/mm/percpu.c
> > @@ -1696,14 +1696,15 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
> >  {
> >  	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
> >  		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
> > -			      current->alloc_tag, size);
> > +			      current->alloc_tag, pcpu_obj_full_size(size));
> >  	}
> >  }
> 
> So @size by itself isn't used, so I was looking to see if we could just
> pass pcpu_obj_full_size(size) to the function instead. Looking at the
> call site, pcpu_memcg_post_alloc_hook() also has the same oddity where
> pcpu_obj_full_size(size) is used for all calcualtions.

Agreed.

At first look I actually tried to clean up things, then realized
I need to backport this and so cleanup should be a follow-up :) 

> So I'm wondering if we can send a follow up to just unify all of these
> and pass pcpu_obj_full_size(size) where the caller never uses @size
> by itself, I think it would also help in demonstrating the intent to
> account the full size. Same idea for the free hook below as well,
> paired with pcpu_memcg_free_hook().

Makes perfect sense to me.

Perhaps mm/percpu.c should still distinguish 'full_size' (uh, naming
sucks) and 'size'.

> Happy to follow up on that myself too : -)

Sure, thanks!
Happy to review that from my side.

> Anyways, the change looks good. Just wanted to bring this up as a
> follow-up cleanup patch.

Thanks!

> Have a great day Harry!

Likewise, have a nice day, Joshua.

-- 
Cheers,
Harry / Hyeonggon

