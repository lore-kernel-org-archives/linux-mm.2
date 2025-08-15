Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4934BCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 01:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99DDD9001F7; Thu, 14 Aug 2025 21:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E9D9001D5; Thu, 14 Aug 2025 21:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88BD39001F7; Thu, 14 Aug 2025 21:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78AC89001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:06:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 077441DDF02
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:06:06 +0000 (UTC)
X-FDA: 83777200332.28.8B284DD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id D2347180009
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:06:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SJ5YDnsB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755219964; a=rsa-sha256;
	cv=none;
	b=WIYJYZWnFZJLOYxkUxQAHizNV1Pqb2mda47eCEgzkoClGPOJoKPAFb1GeZ4vXIibX/Jsos
	SdCEwv7M2E8zhjp/2H+0D+MpmH2lWFHLEEMNN/bryE5vXmr4TOxlfe4QzVEU4Ae/GrSggG
	THC4qfpkbiUq5eL8U5PbK1xu4rYadZ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SJ5YDnsB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755219964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=meWYiTmUDScKABPl2O7R845IioH2Heb/mh0B6qa7TBU=;
	b=7qUZj3aj7IP0/MR39H7LWIfvPYop1krvPPUFsdSSN7YWJjzhPFaq+Um4pMWGFzFmB2mhoK
	RvBWbguPb5a++OAOc6CdQ4cAZkRqdFnfsptsAoJScdST5iY4Tpto4e5SvbrACXI0QBn0k8
	jU4dmStm7VVmdVmevAY9eXZpSiPK7hE=
Date: Thu, 14 Aug 2025 18:05:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755219961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=meWYiTmUDScKABPl2O7R845IioH2Heb/mh0B6qa7TBU=;
	b=SJ5YDnsBvMYFhc/KlqlDBClj6OTe+WrHP1a5N8p2RFqM0BsFX20eKDNNtYkQWBjzS7fYAu
	pfaPMcEMMfHqV+ZKDFVXi95j7AbwNPbLt15wNcyp+ySMuOyQs62Qh9Hsu2UgfSBJ4cW7Na
	G64fs0jbovc/jG/lVMi2rv1JjDyfsTU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Message-ID: <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
 <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
 <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D2347180009
X-Stat-Signature: aac5r879nc3y8myzkrubttrg9n9hosx3
X-HE-Tag: 1755219963-239934
X-HE-Meta: U2FsdGVkX19x8dxxg5gVer6c3ji7AzMabWznATkMVRlIWM4hS6b4MWkL3pWjq0Whz4vPUmnpArzXgddpASJxSTCK7SweHeK7cMJD4/b7q/JZt3TbpKuACjTL2+69FdYbOoSnSnEusDI99CYD6oItN7+vOk+5J+m6VWxDmgElqNOqBUz493WGvWa4iZ0q2hjkfxvZhtZs2dZESAVZM1kuf5XAPukhpZMzXtojhKX0oKMBgESI+EKhO9A9xnSjX+uEfKo+vIOJ7N55dLik5rIHkja12kE0kYHz4ov3eA/Lfrq0b27tQh/GD7+S6cvDzw2spljzMSWAMvQYem3EAdBNYQNWUoTdHpgSBW2HlpYnsyBQ51xDKBhorHwuaMXPXQGMYuslYWBr9afiQugMerDgHD4RL0x80S8Ry8uidn/2hbWoB9/V8ajn0SPF51c5K+gWPtYu8F8muo364tHH9emgAXmgHA1UZ+2WHELWwQLy/tOU1InYhb/y/U5UCxyyJSiq4DUh7Y0GRF/+l7wavojH+loUZ7qGb/9hgG7Ne9/5aGpkJNKrzpFClNxCrWg2UehyDSBPl7qbKk7lMlnT5KfERVoOqZi0cn/V0D3iY41/Th4dACcVoM8SaORNuesqUnQC8QzU7jhsmyPMQgMWGKRw4uDBrBR9DLL5TI2stko/tZ9We0Yx6T5IcfNAcpp+vpqqAcDbuAKXx+171SSOCxyz2gPb2R7U9beb1hoBcNuKlUADt4x+ApWmN6ZVcWyLck/vV6P8NwiSoRRlc0507Zz5moZ2AByxI8uYFd5fiRTOSu95yHEKXCtoxXQfTxXujB3vGDWoeg38/gtDioQu4OT/B0f2wL/SyQ70Iv7DmLzeD4fEk3hK9ZU2zdEFTnUKGQSnas8YJAkNQZs5neDHUdKp+UqNdA+fXg2n3QpK6RpUJKVtxpoNExZ74flSgasQ1mabzXcqSupWUk1VB8TeDmD
 xeHxbjHL
 yuQ0hnL4JNBd4aa16lPNroaasOSpTVOTlCKQxEiRVdFJpoHvmx5/88iHoLw5uVGPMKPBivIcBG3juey4OyBnAr7vRz42fzrtp7l8Oi5O7DTYR9Bf0ruDdur/XeEueWxw2pzBuJzeBpT6iyteNr2YrR8uMs7C2IK0L/RpABIIunl+dFb4PKChZeiKcXf+ByfCY7r3OiAsVv7y+sldlrnToj+yEfhxFd/NceOsYtvwkhzVWH5cZKiQX1lNQ5n+slcNboJrcwR7RBLjOFNgd5CCANW79lyIcFtVVNzhbyVIB+QGYzDnFS9xjjMJN/TG5te7hRTDnQo9Fy7twHsNtypTauujIu0lBl7QkTi9C8Qju9RRji8Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 05:05:56PM -0700, Kuniyuki Iwashima wrote:
> On Thu, Aug 14, 2025 at 4:46 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
> > > On Thu, Aug 14, 2025 at 2:44 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
> > > > > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > > > > sk->sk_memcg based on the current task.
> > > > >
> > > > > MPTCP subflow socket creation is triggered from userspace or
> > > > > an in-kernel worker.
> > > > >
> > > > > In the latter case, sk->sk_memcg is not what we want.  So, we fix
> > > > > it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
> > > > >
> > > > > Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> > > > > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> > > > >
> > > > > The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> > > > > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> > > > > correctly.
> > > > >
> > > > > Let's wrap sock_create_kern() for subflow with set_active_memcg()
> > > > > using the parent sk->sk_memcg.
> > > > >
> > > > > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> > > > > Suggested-by: Michal Koutný <mkoutny@suse.com>
> > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > > > ---
> > > > >  mm/memcontrol.c     |  5 ++++-
> > > > >  net/mptcp/subflow.c | 11 +++--------
> > > > >  2 files changed, 7 insertions(+), 9 deletions(-)
> > > > >
> > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > index 8dd7fbed5a94..450862e7fd7a 100644
> > > > > --- a/mm/memcontrol.c
> > > > > +++ b/mm/memcontrol.c
> > > > > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
> > > > >       if (!in_task())
> > > > >               return;
> > > > >
> > > > > +     memcg = current->active_memcg;
> > > > > +
> > > >
> > > > Use active_memcg() instead of current->active_memcg and do before the
> > > > !in_task() check.
> > >
> > > Why not reuse the !in_task() check here ?
> > > We never use int_active_memcg for socket and also
> > > know int_active_memcg is always NULL here.
> > >
> >
> > If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
> > infra then make it work for both in_task() and !in_task() contexts.
> 
> Considering e876ecc67db80, then I think we should add
> set_active_memcg_in_task() and active_memcg_in_task().
> 
> or at least we need WARN_ON() if we want to place active_memcg()
> before the in_task() check, but this looks ugly.
> 
>         memcg = active_memcg();
>         if (!in_task() && !memcg)
>                 return;
>         DEBUG_NET_WARN_ON_ONCE(!in_task() && memcg))

You don't have to use the code as is. It is just an example. Basically I
am asking if in future someone does the following:

	// in !in_task() context
	old_memcg = set_active_memcg(new_memcg);
	sk = sk_alloc();
	set_active_memcg(old_memcg);

mem_cgroup_sk_alloc() should work and associate the sk with the
new_memcg.

You can manually inline active_memcg() function to avoid multiple
in_task() checks like below:

void mem_cgroup_sk_alloc(struct sock *sk)
{
	struct mem_cgroup *memcg;

	if (!mem_cgroup_sockets_enabled)
		return;
	
	if (!in_task()) {
		memcg = this_cpu_read(int_active_memcg);

		/*
		 * Do not associate the sock with unrelated interrupted
		 * task's memcg.
		 */
		if (!memcg)
			return;
	} else {
		memcg = current->active_memcg;
	}

	rcu_read_lock();
	if (likely(!memcg))
		memcg = mem_cgroup_from_task(current);
	if (mem_cgroup_is_root(memcg))
		goto out;
	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
		goto out;
	if (css_tryget(&memcg->css))
		sk->sk_memcg = memcg;
out:
	rcu_read_unlock();
}


