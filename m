Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1360C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166876B0095; Wed,  6 Aug 2025 19:52:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E636B0098; Wed,  6 Aug 2025 19:52:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BAC6B0099; Wed,  6 Aug 2025 19:52:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB8F46B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:52:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 950721DCFBC
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:52:02 +0000 (UTC)
X-FDA: 83747983284.04.543B333
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id B7CDD1A0008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:52:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MxuonsxG;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754524320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wP0O1tbMn8HVhzrrMtN0N9Bu4W03vBBOSwFroD8yV8=;
	b=WJ8oHDSlKLIUfUUUia9THbEWsaHdSj1DCEOSlXIAkaDp+KBhkM8NFfh9P2r91CdcYjsFMx
	nXbccvNcob0ycFmz4kjgjk03uyMZbR7YqSKHT7+nVeY/kImpJzRu9BRizAG+9WZR2VXY/c
	R+CDn91JaBJUXsYo78E9ygvG3jGajxE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754524320; a=rsa-sha256;
	cv=none;
	b=DZTlJt1ygwieFTaJ8DNbJsK8n2KH83+As+QxmrbnbUQGm6zE7Ud+jNisKL7ojamcB+0fnV
	A4utFE6aQHohJK7lmbsGeH83hmHOzEJ2uRgOuAIxhnk7eBYkKsBDjABIpriP3+WM9siPKx
	zLhMsayw+EHjaxnRKl6vg5loqLu8y80=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MxuonsxG;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 6 Aug 2025 16:51:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754524318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wP0O1tbMn8HVhzrrMtN0N9Bu4W03vBBOSwFroD8yV8=;
	b=MxuonsxGj9mLWiEibLGLoux3An6eyPmDLEpSO+AXBrUnZHWjMFnsjvIjs3km8kAYy1b3O8
	/O/7fHFx5NNDWISuRCDlhqVKSwoXL9wIzA7hIHNo4c0o2srnxCM/JTiQ5Bl3GpYykH5kcr
	FD6toaiINNAAWTaQoYKXpz0KNf4ber0=
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
Message-ID: <ai34al6aocctgjxob7pshhm4lyqfnzlytjefhlum6dxwjcx26o@fj2ca5jdqxa7>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
 <CAAVpQUB_aEcbOJR==z=KbfC1FtWi2NM_wNm_p+9vL1xqfw7cEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUB_aEcbOJR==z=KbfC1FtWi2NM_wNm_p+9vL1xqfw7cEQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B7CDD1A0008
X-Stat-Signature: zeqs5j7k3unr1gosaqnhghwjfcja556p
X-Rspam-User: 
X-HE-Tag: 1754524320-998099
X-HE-Meta: U2FsdGVkX19kGBqcpGy3kUve/K3xVoWIjarDGWzYHgaVzTMco9PCQJ4Mptn9P9ywm5n2r7PRkWohckCTh7PmToESa8rYfFfMOYF7bEfI7DfpvsqNU9H6v39p4xV4YmGS9OtotNDY0oWMrgwBjj/l6SJAFMhrG0aSJn/ZLhLuRKRXIWES5Ae3DEeloYQGV9TmUCAyV89FP0/5OyepR67Ie805atuJz+wgL0udZQPt/E/hH/xleLsPK3UK2rru8hhaEUBo2BsdAdaGjZYK2tUrDEYh6e9g49+lrYN/oHVLnQ16kCoZo80hL4QMv/pBsfCAVZzQpdegAUZHcIw5ZmTi1YHrx+cdkZrFg/nYFFO7jhmFHgJzEsy3uCPpb8qVEB0ZDUcbh+6CFP9EspsypanqCAu93gSZ2nKUAiVD3c1r7EIzPJwlYI6kh19s7sYHTweAA3jNYQYifZitU/3miZzOXkqr0soPranVr67n1s+ckei471JmgzbHk9gG4ekjxfh7LIDdd4euYhygLuw8Fd0ytD+qw/zKJLygMpctDuUivJIP0JIvXugJqjcWKTO9yxoWYdYx91tAsERpdfNDe4U4EXaiop/c0Xlnzh6fGg8pwopzyBNiincAdPS5bdXoQbpw/BzIImiCUiiuoYMYuJbapf3VwET3ckpiqKnFI0UrS/K5rp6CSjX0vNTEeUziA95Q1v7Nim5+ZyVB5zWabZA4indCGX8DwtAdj/JFCH1Ugjkz8SyADqHDk0mSBXO5S5Bjv0E9UV1gKX7hgdQFcy/VB0r1Ob6sy4J3B3K6wE6K7GjXlDYUZazhP7Wq8gQ0hCI2NKDhOtPm9VD7tpX0t/xTZ+1GnPMK9UJMVXWg3Vb6w1zGBla/X7YNB6LpvreNHoC2IsvtuG3gpEVgj8Tue7kAH0osU6Z+7w6Ai+h27Dqs5TVDYHuCkLq71gHlzqwmHFHh+YKI7eZJ3psUXE8f8yn
 3iFREXGd
 BG67VoOFRWMlKKugxAUbnW/aHSGvmv6uLU8g8ZbV/PbwPMwQCc5QUWuK1VoypD7M8rZbUZ0+zh4G0idsUZihWCtHGykZj84egRCmZZPkcqIOm2w6GeSpvJB8lugHaRt6dw+HjiMRVm3HFp+t4qgD4EBXfh9ODRaOe3RFpPYpVlFbGXFu2iUQiyyNbOp7lKNqnOCyaZNHIgfTeej2pz9xx9ZiElJ+lTsVFHBuIK8kXQBf+tFM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 04:40:45PM -0700, Kuniyuki Iwashima wrote:
> On Wed, Aug 6, 2025 at 4:34 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
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
> > > >
> > > >         if (!spin_trylock(memcg->net_pressure_lock))
> > > >                 return;
> > > >
> > > >         socket_pressure = jiffies + HZ;
> > > >         diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> > >
> > > READ_ONCE() should be unnecessary here.
> > >
> > > >
> > > >         if (diff) {
> > > >                 WRITE_ONCE(memcg->socket_pressure, socket_pressure);
> > > >                 // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
> > > >                 // OR
> > > >                 // while (memcg) {
> > > >                 //      memcg->sk_pressure_duration += diff;
> > > >                 //      memcg = parent_mem_cgroup(memcg);
> > >
> > > The parents' sk_pressure_duration is not protected by the lock
> > > taken by trylock.  Maybe we need another global mutex if we want
> > > the hierarchy ?
> >
> > We don't really need lock protection for sk_pressure_duration. The lock
> > is only giving us consistent value of diff. Once we have computed the
> > diff, we can add it to sk_pressure_duration of a memcg and all of its
> > ancestor without lock.
> 
> Maybe I'm wrong but I was assuming two vmpressure() called
> concurrently for cgroup-C and cgroup-D, and one updates
> cgroup-C's duration and another updates C&D duration.
> 
> cgroup-A -> cgroup-B -> cgroup-C -> cgroup-D
> 
> Could that happen ?  Even if it's yes, we could use atomic ops.

I am not getting the hierarchy you are using but yes concurrent updates
to sk_pressure_duration can happen and simple atomic_add is good enough
without any locking.

