Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5175DC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 00:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264126B0088; Thu, 27 Aug 2026 20:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214466B008A; Thu, 27 Aug 2026 20:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B1D6B0095; Thu, 27 Aug 2026 20:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE796B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 20:48:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A2D6A3688
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:48:13 +0000 (UTC)
X-FDA: 85148841666.12.8C0B276
Received: from mta0.migadu.com (out-156.mta0.migadu.com [91.218.175.156])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5D80440002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:48:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NpBuPJnC;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787878091;
	b=0LXEIwvT1fqMutF99HMTwUxWu90hTQvmysug3xhi2bQmpAd6JiALIjGk8wOX12EZoop+bF
	EYyvfX14kXJcq6d7i4rZuwOlEJ8NUbGbZQtsohQ3ToDKdFyvqs3OO8jh1KXUtk/vmbg9pE
	DkbJdaRkKmMTlnsqbykATwczyWFk1Bw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787878091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lU+cexe9UXnR+VpkxpTMZ201uPRS3TUE/YmSqR5w2sg=;
	b=M+VwS7LuAxzf0JpbqCnYYUUV0SNNBBXITf7dT5czArVLOgvnBRkU6jTjkt+0ROUpVwFsnA
	xDOxhCcxV4WGFVapYT+IfiPigxO910gUYkeaT8aTUKsjBVgjbV56hUeBZ3YsK1Ny/ZL2XK
	0bn23fn1qQFVmkGfg/hCsEwPPZc1LoQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NpBuPJnC;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.156 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Kv7SegtkprBpdAtnxRcZRecFg6c76sWZc/YX/HSXqi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787878089; v=1; x=1788482889;
 b=NpBuPJnCKiroB8N/qNlsW9K8B4fEy1GEaSAhNJFXUQtJ4qDWZH9q7NoyChCwc2lhDZHB3ssP
 0NDcvSxPOtucqEE14JWtuO65iisYR0ggFPCqjtyPie1ZqDmn5EfW/Ng4iPi8f7+vzfU/YdVYpKJ
 3SyCAzgqCG8cbm9wEU4h5RTc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4f6263115d5ea613;
	Fri, 28 Aug 2026 00:47:59 +0000
X-Mizu-Trace-ID: 4f6263115d5ea613
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 08:47:54 +0800
From: Hao Li <hao.li@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: hannes@cmpxchg.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memcontrol: treat disabled memcg as kmem accounting
 disabled
Message-ID: <apDZV9nKW69ZbIj1@fedora>
References: <20260827091813.22327-1-hao.li@linux.dev>
 <apAnveXHmeQlKJnU@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apAnveXHmeQlKJnU@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D80440002
X-Stat-Signature: 1w4buog3fymcgwgr9iw48b7mctyax6sw
X-HE-Tag: 1787878091-421318
X-HE-Meta: U2FsdGVkX18rTE/OuznqbZsCfYhW40ErlCtN+TkaO7WrphnfF/frbrJNPTad1bDcIMdOEfwWB9d+SZfC5vgX6M41G9p3FipI5/tk4/QuU+3HyTjUmpEXFo+lVoSPBbift6zmF2byZbjlwKcPHQPHP4mV+C3orx/qbTorTzTrCZsHXFAvWLMHg62RDh6SUcBsHb93Ba9tkKSZVbpoSyLNOAoQcEf8U41GbPzJKPCz2mhLRxG1/xrl/2WAk87WhBzgNtcBbxi+q37/Wr7Qn9NA22SdJWqdEd9TIJMgO1Ronx7x4dVqdlOD6W20OS/aIE41jVadJJIW7VvwWfruObwC4BUrS3tXBipYFNmOEmFzvgl5QcEJrc2ogUby7eb+0lcxGBgdUE0ryWNrO8OEGR4+HAxTSjpZf+DYeVXJ7yvdS1CpQ0Wc7yFEXmAaWzFipwNbIP385/kWv71EumbwoQXdqed+CyrgztSfMYjjAG4kSvjMXfkkHh513G1AgVPXUXqSrQenabNq7Mvg+e3NdlzCkuZ7+isi2FFxdhQ2Ki70MT6nYcs+zun7jJGIejSX2G9jjImhA15ON+ZWkGtQtlx9t5Scg6TqBsSh1/eQVrknK0Dn9nMSsgfO4f8VEMS/niGUd6B8IxGZWoz57pKiw0IUde7xCdS8C4SVtqTjjQMTrNzBT/vjlBSSLCnR2fbtgP189SEfU4LOjlJL6mr2qf61U1NUhHqj6SJcWBcxv3BYa1aPz4Um3LUjSjLvCSekTep+KcozyRzJFeWBBPN+p1PYn4EiYi8aK9ExNUX/6qsvI96hzAKAxaCNajE0TNQC4RXKXU2dEMGV4iGEMD3sdwGK/gwInbTkVJeaTUl1gj6iTjOkRkI+5LimOnvxS2lAi97QfOxirL7lSgH1YVWYniCigeGSnyTIhh5usnFdW0r4C44h7XrcB+tGDTxOSSiMT/At4neB5D+O2jzJVQ8/b71
 LYiCY8HZ
 2wPkxnKJPnYO4K8dXOJu14+GLLA43pxK+0/GHjhj8q7oUKUJTEXnvS5/yeyifqc6RN1utv76ew3wBvuueJgbxFxYD2AxMLMIPaqcp4dnj9GTx1JLMj8cxLQLMmC9neqnY6PI8PjeQkeZ4EKvb9gfkjEhkCE3whFjriJ1sA7XYpj1jTaCSaaRxUTS+8tgojJvViAB1f7ybZ/qfkZZheh+JDaR107Ex8CbcsmvmVE49QwFAY/htWyjiG+YBPdhXUJH0NsE/vL1mlSiRlyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 02:04:13PM +0200, Michal Hocko wrote:
> On Thu 27-08-26 17:17:50, Hao Li wrote:
> > mem_cgroup_kmem_disabled() currently only checks whether the
> > "cgroup.memory=nokmem" option is specified. However, kmem accounting is
> > also unavailable when memcg itself is disabled.
> > 
> > Check both conditions to ensure the function accurately reflects the
> > kmem accounting state.
> 
> It would be really great if you could describe how we could end up with
> the inconsistent memcg enabled but kmem enabled and what kind of effect
> does this have.

Yes, thanks for point out this.

> 
> AFAICS the inconsistency is possible and it would lead some wastage but
> no functional problems but the changelog should be more descriptive.

Exactly! The most direct benefit is that when memcg is disabled,
new_kmalloc_cache() will not need to create a separate `KMALLOC_CGROUP` slub
cache, but can simply alias it to `KMALLOC_NORMAL`. This avoids wastage.

If this sounds reasonable, I would be happy to explain it in more detail
in v2.

> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> >  mm/memcontrol.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1ebceade4021..b28f6165c354 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -132,7 +132,7 @@ static DEFINE_SPINLOCK(objcg_lock);
> >  
> >  bool mem_cgroup_kmem_disabled(void)
> >  {
> > -	return cgroup_memory_nokmem;
> > +	return cgroup_memory_nokmem || mem_cgroup_disabled();
> >  }
> >  
> >  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
> > -- 
> > 2.54.0
> 
> -- 
> Michal Hocko
> SUSE Labs

-- 
Thanks,
Hao

