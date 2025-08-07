Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC09C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 20:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D169C8E0002; Thu,  7 Aug 2025 16:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE7A8E0001; Thu,  7 Aug 2025 16:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04A78E0002; Thu,  7 Aug 2025 16:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE8718E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:52:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36F07C0A9E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:52:52 +0000 (UTC)
X-FDA: 83751160584.05.43694A3
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id 23F6E20005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 20:52:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cv+2G9TS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754599970; a=rsa-sha256;
	cv=none;
	b=0MzcuCycs67rhcBpTsIAoS6jEp0neuXhK+t8US0ylT/2j73/+kQ3qxqxkO/MtAqPvw3OVP
	pxrE/YenwmwROMF99gj3Xf63fkUlExhmsqXcHRbJDmMZtkfM6m/pmkVutF8HIJGU183zmG
	EeYel+uJXXCoR7VK2IfNdwoWFJCbyH4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cv+2G9TS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754599970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vOPUpSlPIiZZc2oV/h1m7LERhF2i5s7DpFEXBoy92xw=;
	b=FwmxYKSy13QJg6ytIO74EfZL7JeAdYXW/zzIVbiPYG1nLVYQniMFYN+27a6eZ4LYblJSFR
	/NItmwkuDpsjo9v2c19CiwOC81szhH8IW0rUFSiilWJe7q7ohurqU2rzvvJZHPwXjUqZMw
	UoLgBCHBQqsNc3XNt0UiMI3irWiHtXc=
Date: Thu, 7 Aug 2025 13:52:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754599967;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vOPUpSlPIiZZc2oV/h1m7LERhF2i5s7DpFEXBoy92xw=;
	b=Cv+2G9TS/mizvM7tGRu57w71x5ym/SU6RYjfXnEqPUY6X3fa1F5zCW/NAMWE1gHtrmjqgq
	v/jXuwxYX0Y6ACEqaL4ydjvAtqxb76JAAOUFrtO06qMgpWW9hjJ0WkDTz1I93VKLwXj8kL
	+lcikozCwODHKJSSghRHUhxds3NKhAo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, 
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
Message-ID: <qsncixzj7s7jd7f3l2erjjs7cx3fanmlbkh4auaapsvon45rx3@62o2nqwrb43e>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
 <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23F6E20005
X-Stat-Signature: jnow8j6ec7da98kegzsn73jdn3d8zjxb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754599969-670566
X-HE-Meta: U2FsdGVkX18C8vw/5/RUbjq94o9E/OsWJPZ0X6R2tOyKp61cxsHaJuIxCRzZGM8clUWS7w2soxEZLUWAtAVDSu9ugSbt9UaabFsC0h1TLFwXdmkQHJZtxDfIPGW3Ws9JsZUfbrOhGWd04YQ2vB5k10H0hHv4hRsVyMtCc9icOtzPkPTs1jUSBUrv0Icwl4bvz8LC+fICM71iwzYfYltGIJnRSSHnz8diXS10zODPYl6oz9NyxU9qJzSPtC6kjC8J3i5v+G+q0dCFf4VJvghhzR2p3+7jFPDLZWaTof3SXIf30A17PJ15pT4teaOPXA7N6wQ/btxM1QouPK1Bd3/tTK+F/x2Ssw8ve7MxUrzBsRvumZLtrG3kfxAnPy+GLCIPBxONbSwyP0mrytkYGHo67At+UCPPMcgPXzauWrQcGYE1lqK74R0rCtWBxX0WklhjlyjizfqcFjSP3XK4kI5jeHfSj2/cyUD1Suf60AMOtC+ohmS5Au+ofjm4m6t2OoUyybYjnRnl2dCTE7IlybUKtakjgM3ZMcl92S0tAo0umOHGo0pv+yeYJ6baPd4mqx4zCamGTgvfrrUuEmYPDhZTA3MOJh7wHwyaXy2pGaYuIsv2Z7pLVWVhyLhNCi0w1gzyVKr62cYvUzRXsjDOmkXb9BW/sXsH7y1/SXNZhWlUc5gDcZp6l7L+AgM/0AlaaaXvYvyZNyBg1S0s8BqvXpujHfBL/dsdE6poufvmMjzlxZJB4CD4dvlKdXeAhZ7vVEaTN3bntcZYpkVGsfmhPeVnsKHsrXfeHiWNZr7XFlyIv8PEXiRSaymsnKUOZASI7gQqA/IYUZl7QkF74HjD7u9ydOzHxy86/BAWl/xe3uNLOkd1Zbu6ayb+yu8XDgp+OgmaRvpShASvGWzqswwcdXPlFOfp/7KT2/HRfXHOpxhLwuTeD71zBbmg621lWKCmDql/ZI5TDEfTGq9GnMQpmGD
 E7mwzhIe
 KndyVSfwkbxyvYrGm7mQIeVRYN5VaxbY2zo+0+bDMv3ei8BBKT7URYbuJfh7Agz8N5VUV4vdYsV8XeAt1Om7d7AFvFp+O/FCLCgiT/0FsRxa8Qrd2m/rlyD4tpQkUh3HvpyxsvOI8RqnPop58G5l+OsMcljrbCX1LGUmLQMiODqLojaZV8uJLejyGtDjVs+7bZVuPOAbtPdIjrWKFhfZbAeoMWfkz9WwF3eeLXADNdfHUyhQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 12:22:01PM +0200, Daniel Sedlak wrote:
> On 8/7/25 1:34 AM, Shakeel Butt wrote:
> > On Wed, Aug 06, 2025 at 03:01:44PM -0700, Kuniyuki Iwashima wrote:
> > > On Wed, Aug 6, 2025 at 2:54 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > 
> > > > On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
> > > > > > > -                     WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> > > > > > > +                     socket_pressure = jiffies + HZ;
> > > > > > > +
> > > > > > > +                     jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> > > > > > > +                     memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);
> > > > > > 
> > > > > > KCSAN will complain about this. I think we can use atomic_long_add() and
> > > > > > don't need the one with strict ordering.
> 
> Thanks for the KCSAN recommendation, I didn't know about this sanitizer.
> 
> > > > > 
> > > > > Assuming from atomic_ that vmpressure() could be called concurrently
> > > > > for the same memcg, should we protect socket_pressure and duration
> > > > > within the same lock instead of mixing WRITE/READ_ONCE() and
> > > > > atomic?  Otherwise jiffies_diff could be incorrect (the error is smaller
> > > > > than HZ though).
> > > > > 
> > > > 
> > > > Yeah good point. Also this field needs to be hierarchical. So, with lock
> > > > something like following is needed:
> 
> Thanks for the snippet, will incorporate it.

Cool though that is just like a pseudo code, so be careful in using it.

> 
> > > > 
> > > >          if (!spin_trylock(memcg->net_pressure_lock))
> > > >                  return;
> > > > 
> > > >          socket_pressure = jiffies + HZ;
> > > >          diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> > > 
> > > READ_ONCE() should be unnecessary here.
> > > 
> > > > 
> > > >          if (diff) {
> > > >                  WRITE_ONCE(memcg->socket_pressure, socket_pressure);
> > > >                  // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
> > > >                  // OR
> > > >                  // while (memcg) {
> > > >                  //      memcg->sk_pressure_duration += diff;
> > > >                  //      memcg = parent_mem_cgroup(memcg);
> > > 
> > > The parents' sk_pressure_duration is not protected by the lock
> > > taken by trylock.  Maybe we need another global mutex if we want
> > > the hierarchy ?
> > 
> > We don't really need lock protection for sk_pressure_duration. The lock
> 
> By this you mean that we don't need the possible new global lock or the
> local memcg->net_pressure_lock?

We definitely don't need a global lock. For memcg->net_pressure_lock, we
need to be very clear why we need this lock. Basically we are doing RMW
on memcg->socket_pressure and we want known 'consistently' how much
further we are pushing memcg->socket_pressure. In other words the
consistent value of diff. The lock is one way to get that consistent
diff. We can also play some atomic ops trick to get the consistent value
without lock but I don't think that complexity is worth it. Third option
might be to remove our consistency requirement for diff as the error is
bound to HZ (as mentioned by Kuniyuki) but I think this code path is not
performance critical to make this option worth it. So, option 1 of
simple memcg->net_pressure_lock is good enough.

We don't need memcg->net_pressure_lock's protection for
sk_pressure_duration of the memcg and its ancestors if additions to
sk_pressure_duration are atomic.

Someone might notice that we are doing upward traversal for
memcg->sk_pressure_duration but not for memcg->socket_pressure. We can
do that if we decide to optimize mem_cgroup_under_socket_pressure().
However that is orthogonal work. Also the consistency requirement will
change.

