Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E36CCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06EB68E0027; Thu, 16 Oct 2025 15:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045D48E0002; Thu, 16 Oct 2025 15:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4DC8E0027; Thu, 16 Oct 2025 15:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6B778E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:57:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75448C0388
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:57:47 +0000 (UTC)
X-FDA: 84005037774.26.444BFEA
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7BD19180009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:57:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cavN09Bs;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760644665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6QNM0LEjMhDM1AhzKkrXtK0wDpQlcn/3jFNh89PFW4=;
	b=LgGmlABECbgR1LAbA1KWPmIgihHy7y/J2HaiNOz4EOXDBVdOK/NQGy+sLZQx11qVwQillg
	bUuZ+nMn14iYphkr2CuQkVl79Z0T0pjV5ERZ0cxr5ifOsz+yZXxZdhIQegiQDgxRZyjGfL
	huv+NofdX7Tn2nw674DGpRQbuMROzMY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cavN09Bs;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760644665; a=rsa-sha256;
	cv=none;
	b=S3OwajdNbsbMSN0VtA0xwOuWSEvbdPbKDF0gBd3tp8iCFi+Z22WVEWTmydVjrkAMPUiA/w
	SvxGyS9m20UUrNDHMY8TBCGsacQ1ADYDYXkdWkktgt5wmX+0gdR+gm9ERjZAoOtrAApAQy
	pX9xR8rXVY9YowrQ/fp8YvY2R51ViOA=
Date: Thu, 16 Oct 2025 12:57:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760644663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A6QNM0LEjMhDM1AhzKkrXtK0wDpQlcn/3jFNh89PFW4=;
	b=cavN09Bsrq20N4KdKPWHM3D4vp7y79G96geueuYvCN/GClE8DD+V9Zb9uYlORCxcKV8RBo
	wCw6LqJx7EjOCW508calrRTToHHshth4/lAEfrtzLAAibUS8iH2yfGak6KWNIKmsjMiFuQ
	HDZhnN3zBftFsukEePJ+mHPWn7HnDWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Wei Wang <weibunny@meta.com>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] memcg: net: track network throttling due to memcg
 memory pressure
Message-ID: <sntikxyoeveee3tkrxwr5rrztzr26sqzpn63r5nrel6vdyb7as@6mpya3n4mxju>
References: <20251016161035.86161-1-shakeel.butt@linux.dev>
 <20251016124610.0fcf17313c649795881db43c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251016124610.0fcf17313c649795881db43c@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7BD19180009
X-Stat-Signature: atmyxx4pcismmuhfsf5pixrfm7474x1g
X-Rspam-User: 
X-HE-Tag: 1760644665-972613
X-HE-Meta: U2FsdGVkX18+EBd/bNKmvSvxvt0Q22z31k+RbfokW7MKveUvOMTPK3V1hyfN19tncqepXFsTAwhEa1DoGnGnNjd6a4gcqzopkrOqjNq3dOf4KKNX+qgh6ajZ5gUKC3WlPrbetSUR6FqL5R30Jlk13dl4paa2Ui+UuXYqxccPNXv4M5IHEtmarAgTKYXxvs1GLrtBX9cdHr7TAwrTa0FaNixT1uE+okFGyO2oJxDFW4mRoLNFniKsX58WDd+KMN7QT7TdDDpc6R7ShV5hPmF0/I72F+wyh/FEkxuird/2vOvfaybES3TTDdPRaFeuJ7YvjZ602Lb04dxFsrdnix3KAe22Mt1zKWOe9xIWYkPOytICjFjRCrjY+PBsC1yMgp0URhxLeFOZwCvGal3gWlatKOOtwbOaZ1NJgMWvMH1QxyC2vBucTZcynssE7RwIGJ638W7LzTBlXNQuUTNmxT0A34tblt6o8YP4vYWNaFdNirzYbJoqHDRG2iqAABr6GEukKJDOe+3hiJq7PJ7rzQ+h41zFDoWpPhdt9AdBmCJY37e0dpZzkfggMSs+hbecTxeVy4g8i7ay32uZAxHrVxea4+sHFKslG7K+bQ4cZ8FFqsVPsbavzZvpHorIrihrm+iYoudZbrWVenCWc+E76kUTHUoxKTJHl12132o6RcaVwHOrxKeIQxFUvSmqa7vcIfy5dIJiLrb9sSJp0j3UY0/f86JX9QK+rdf/v2dxFebRCImXcyEV3z7z+KEeEJqWVt9PrTztMa9e9Z4b1lxyyPv4oa/6xXmctvCXFjyCbmPtHzoOdDGIqKr98MV7KEYf75bsmhel3Au9FZFAe5c6a1MmG3BZhHNgBWyPkhVIuDqxUZRgDLb1U0BRJ+RqD70UNu0ZHtG5AVc4StIYAAErSwm9kT1r4rtWnSeLxzdKzRzEwhYQw8XJGo+Uh+irU6qX7dzgd6R2b+Su0hKZYDXrodI
 TV0B8mOJ
 XozQgAmhL3DJO1IMN+Y/dmh092Lan1k1Blu9+54OS/jey95gspqht2gFKn2+zfkkLjs02htX9xwakpusTEl0PtlKKSMSwnpoHMa3snu+x2FTKF5qbbf4AZMN7g1AgB017iKmfJs0/ZFDUCa8xKpGdB9CSdAHnT9dCOPPEPnf1KmJQtsKaJs6R4RfoVnU1xS3FpH1g+a1CJ7wg5GA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 12:46:10PM -0700, Andrew Morton wrote:
> On Thu, 16 Oct 2025 09:10:35 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > The kernel can throttle network sockets if the memory cgroup associated
> > with the corresponding socket is under memory pressure. The throttling
> > actions include clamping the transmit window, failing to expand receive
> > or send buffers, aggressively prune out-of-order receive queue, FIN
> > deferred to a retransmitted packet and more. Let's add memcg metric to
> > indicate track such throttling actions.
> > 
> > At the moment memcg memory pressure is defined through vmpressure and in
> > future it may be defined using PSI or we may add more flexible way for
> > the users to define memory pressure, maybe through ebpf. However the
> > potential throttling actions will remain the same, so this newly
> > introduced metric will continue to track throttling actions irrespective
> > of how memcg memory pressure is defined.
> > 
> > ...
> >
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -2635,8 +2635,12 @@ static inline bool mem_cgroup_sk_under_memory_pressure(const struct sock *sk)
> >  #endif /* CONFIG_MEMCG_V1 */
> >  
> >  	do {
> > -		if (time_before64(get_jiffies_64(), mem_cgroup_get_socket_pressure(memcg)))
> > +		if (time_before64(get_jiffies_64(),
> > +				  mem_cgroup_get_socket_pressure(memcg))) {
> > +			memcg_memory_event(mem_cgroup_from_sk(sk),
> > +					   MEMCG_SOCK_THROTTLED);
> >  			return true;
> > +		}
> >  	} while ((memcg = parent_mem_cgroup(memcg)));
> >  
> 
> Totally OT, but that's one bigass inlined function.  A quick test
> indicates that uninlining just this function reduces the size of
> tcp_input.o and tcp_output.o nicely.  x86_64 defconfig:
> 
>    text	   data	    bss	    dec	    hex	filename
>   52130	   1686	      0	  53816	   d238	net/ipv4/tcp_input.o
>   32335	   1221	      0	  33556	   8314	net/ipv4/tcp_output.o
> 
>    text	   data	    bss	    dec	    hex	filename
>   51346	   1494	      0	  52840	   ce68	net/ipv4/tcp_input.o
>   31911	   1125	      0	  33036	   810c	net/ipv4/tcp_output.o
> 

Nice find and this inlining might be hurting instead of helping. I will
look into it if no one else comes to it before me.

