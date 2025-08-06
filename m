Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC341C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9B56B0095; Wed,  6 Aug 2025 17:54:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A546B0096; Wed,  6 Aug 2025 17:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0196B0098; Wed,  6 Aug 2025 17:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68A2B6B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:54:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1A88F81C2B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:54:48 +0000 (UTC)
X-FDA: 83747687856.26.330EA2F
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3E2DA80004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:54:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/YrO4X/";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FroE7+qI9Ws4d3iwncGRIwScgg54/aqmzkwV6db+qLE=;
	b=Xqens3KfOClJz6r0kt2tm1/YSxIqavuY0wOyurPJO54lnzFmsXARfqBm4absLIm2Tx56Pi
	FfWtPiN/Ou6g1fWhy/ajrYtaC3w2jhLWhQREdU2bR8EfjASOiFrTm0kn6CUTyQUvC23HwR
	P/DtH5IipZVVbHB5YU/GmRq1MLeISug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517286; a=rsa-sha256;
	cv=none;
	b=5/LR42MdTwOD/Od6wI5f2FTpexitl0gUgjG1O51+nXXT+rus62CzR/mK9fzcIf0dfuQbsr
	S2t/IjcV7B4YR0b2/A7tT0ubn0i+CyBShi6KPC77sToJOiAKS4leTehEJhq05i2tQgiLSh
	V+w/I2e1eLgBvWjaxiPFMVb1FFf/ASw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="M/YrO4X/";
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 6 Aug 2025 14:54:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754517284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FroE7+qI9Ws4d3iwncGRIwScgg54/aqmzkwV6db+qLE=;
	b=M/YrO4X/uY1dXXir3zZ9a3prwZFo4vvvo/bxNJD3qVEX++L1F9Qr6UqFtm6JJAPgTvQ3Sa
	VNSzm5l5hh34xnTOEDBOgRpAkghQeTjJb9UpdIT76VIuSt6yKlfYj/YfQgu34PCDSEsrC9
	fVWa1H7e/q1UughGACwJiKKyAr6kQ6w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3E2DA80004
X-Stat-Signature: fj8mum1t9dgi16husd416qsm9hgp89gc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754517286-912703
X-HE-Meta: U2FsdGVkX1+k4MBvviGoeSoBO8yAtj+KAhXmSCO9NItBoOgTifHyUztlKue2xBFhd5ZfNkNkcuzn0vw1DBG9kKCg5sIZOUgk1YKNSpsdq46K3lTURLL482oRWa6M/+TtIYWr3oRLvm8LWvvR+ijcHNCmnaLjx7xRm/RrDEyUsLjjWoeXLB2J4rfj8IlSLgcuoVnpHwlejIG5UNhjwR4soIebfexUiFaMJ3UagD2KHgNrO5AQIOKF8eKMd3avOdiq3EkvZS0k4BHHEzrxkmW/n6/5LBt+nxXaeww7liamEFP6exEuEwxLX3UPDylWww53WYRAT5+GC+wleOG6Lj/iC+CVlEaMwKPPxWv9w4hciivF6HQH3ECkfLjHmPcJuse2qkromTT8G4u9LiQmYuza0WNZYX58Axx65Tl6TKaWGurjdDueaiX2qtcXg2BmPA1m+Dr3sJAhHdaYv6nHjUT2LN1RZhhIlS2U4fZNRXmRo/w6HYZ4UgUwoPzOzz+wRUulOROisC9M4BT5MchcJmqrA72fNBvRCJFQWP+5bsM9JsbKCqmF3Xa2P7GsDt4ce8j/5++NilKln6RSuO9OCvWTQ9ozwPsvGNbblCcFgGklWFiSf2AkqO+/FJGKxc7vrju749JdOZt6VFccKge+3ufRlgvBlemVtVNvSDlf+vN621ClYq+wFRJYmPEp8FXqdZh/l7Ah5kYn4DanDb5ENAExWChFcf1YiMXy8AoYGp/WzFZcnIlWcYOMxt2xwP2tSGK2QpyTBLT+Hm987eGp4bQT2B2gweirnj+giHr1BJmLxYq6+WXQXoc2ytLMQNCxI5tj6KjOuELIw1j2nYMJLefzjqoIh4vHHpDSdSsnVCSfYUtaTDkFX7mmYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
> > > -                     WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> > > +                     socket_pressure = jiffies + HZ;
> > > +
> > > +                     jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> > > +                     memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);
> >
> > KCSAN will complain about this. I think we can use atomic_long_add() and
> > don't need the one with strict ordering.
> 
> Assuming from atomic_ that vmpressure() could be called concurrently
> for the same memcg, should we protect socket_pressure and duration
> within the same lock instead of mixing WRITE/READ_ONCE() and
> atomic?  Otherwise jiffies_diff could be incorrect (the error is smaller
> than HZ though).
> 

Yeah good point. Also this field needs to be hierarchical. So, with lock
something like following is needed:

	if (!spin_trylock(memcg->net_pressure_lock))
		return;
	
	socket_pressure = jiffies + HZ;
	diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);

	if (diff) {
		WRITE_ONCE(memcg->socket_pressure, socket_pressure);
		// mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
		// OR
		// while (memcg) {
		//	memcg->sk_pressure_duration += diff;
		//	memcg = parent_mem_cgroup(memcg);
		// }
	}

	spin_unlock(memcg->net_pressure_lock);

Regarding the hierarchical, we can avoid rstat infra as this code path
is not really performance critical. 

