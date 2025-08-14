Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EB9FCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA6D9001F3; Thu, 14 Aug 2025 19:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA1F39001D5; Thu, 14 Aug 2025 19:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDEFA9001F3; Thu, 14 Aug 2025 19:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC5199001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:46:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39BBB16078B
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:46:48 +0000 (UTC)
X-FDA: 83777000496.19.AA5401C
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C37340006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:46:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLT1hDk9;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755215206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGIdFybk+kRLges3ScZ8VUkCQcp4M1Wu7yEzp4KW/MM=;
	b=2l1I4yxkVYTHCGAuXIKRJCZ5f6ZeXLPyvbmP0bdQ8v2EgBzxIYyviaqjQ7j3AAi9oLpC9M
	BDemuP29Zgxv3Iv66fBAlpr2fiBddiJCKVPwHW6yY6w/1RO2N/f7u7JaJ92harCawYVLvK
	/VGQ9YNaEWjrhRu2NrjCyH4Lwt44H2o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLT1hDk9;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755215206; a=rsa-sha256;
	cv=none;
	b=lb7pUzikPA1Bqhv3Enb1MmoY1CT2ZqnB3WqdipzwPB0/MCaB16bbVE0V7wjnH43hVHZpzI
	Iop9W1WOLTt9QWHaKF1jzFFgU+ufUwMHukgU2zafRFloeGKBieyjv8Gp57dKZZp1RODDEU
	FIs/5bvr46dnYuL0oif4GeI9KofwkWc=
Date: Thu, 14 Aug 2025 16:46:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755215203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGIdFybk+kRLges3ScZ8VUkCQcp4M1Wu7yEzp4KW/MM=;
	b=ZLT1hDk95uSd62R3ZCt8vxzdrGH0dCDcV8SAixDlYtSQGJ9T0Fb2vbmbfRI0sWncn3K6LT
	2S7D2jdY921fEQgbWRRjyOFwX6or7Qtqj1apAEvgjj6VbF5171jh8eZao+JGgmXjCw1Old
	ivCArvOUDegxUsSqdNG1bqYhuLPFdas=
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
Message-ID: <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j5e37bkzkaop5rmj71eecdbao1cpiyt9
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C37340006
X-Rspamd-Server: rspam05
X-HE-Tag: 1755215205-869225
X-HE-Meta: U2FsdGVkX198iF/oqm2DcklfZdTG7IJ1n0tVBkNN3wtmJSEke0FZsQ9CnEOo4kNfE4CgwSH3GBb3SLnL9TLKEgPY6f2ztwIC0tAP8wXXNt+QjyK8edVvIJ6Ou0pAy3x0pymbhXOad/KryDIvDQ707o2hCC99Xlc7DOLjIIu5VeCsHXAKOTKDt4ze4X7YnE2FozKEAKOAUC5fLU+hBxA+1+XKooRGdGp9XlQV30UZ+todZKkUJxH6vgqf5aNPEE7Exr3Q65trAQhvIy5mQtYehldZVf+Z/shs3rClNPWUE0tRU/7t+xKZ63uYZaW117FfLZrbD9PBs+zQHM/5iI3hQfzbXirMWMI2jc1urN20YfzjXGS16MyIGxrLm56Mf5upMEvrX7BKa5uiCEtP7F77w6GpxJEKRJOvXAHBY+sMRR9r1GLCZuXDGY4oBSVQsTC7jHpvsLfvMo+roaRTsEZZhYB0mkO6z8ohI+mUCDL5a2vGLGZFh4G5UzDBWAkr19Ec2m3oBf3pfnQwurmojqLxG4ccG44G+3G8d+Zhnw2MKvCVvZsyX6UQhOLynGNNPGLYeHYLq42qygwqU79bma663ARmlq4DqkPW9l9pnW6K/Sw9PuWYVWenFbzxJEzq/YlGMA54dI1YZiHxIkjB5qsmu+J/7XsV+OWe04JfAqn4O2vmMh8wjncvb+zwBpjomKIfHwPUz7i5XH/881kW4Wt6aP0INFSR9j0SUlG5SZraE6SJWWFEAZidti7piTajFkCCT7OwZBap/b8HAZkufM5+BbGXgGIRKcNTwcYl+yZmRtgj9tzwnESXy/BZJ45HgquoQVQa02nn6F03J1wEvev72xCjibKw/YuK/sKj6SEnKB/sLGyWrUwefZkESwW3eJQoWvdiIKzJIdbVhA0x5arB5eBl+eE3eQTGvzfutfnGthZE9bnWyUI48wrxnBP/DtjjspZ3wO+Dd0xPQQt0gIJ
 43eECt/4
 PkXNuSxMU4/h72lo7LCilje6bCKxbjSvag6Ct6Wmt0x12/IFd43QDOsBY/4ivGDRAmcqiIYv558bYUKkjgdqnODuXyKGtA5OniCEJImmTT54Y/VsTbQQtqiNmTn9VgfyoABlBKNT2bk1K9MfkxCef9BMNyYO1iAKZm7XhDJnqVw/ZmEXnxlwEqT0LRCzadtFsHZRuEX6meFWqdwdjzH69Y7i/0jRP56YS9w/NJd2gAOl50uAcoKYcL6TjucvyWjoxXTvU9q5fmxNnuKkY+Tomxn0+hHtwcAwwzJN1J4NFBPFc7mhsfGwwir5dZHZPoXWLN7gxRolSdbFTAAWGzYQ27LsRij6YQkz/DGTTm4VnAUHRRxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
> On Thu, Aug 14, 2025 at 2:44 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
> > > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > > sk->sk_memcg based on the current task.
> > >
> > > MPTCP subflow socket creation is triggered from userspace or
> > > an in-kernel worker.
> > >
> > > In the latter case, sk->sk_memcg is not what we want.  So, we fix
> > > it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
> > >
> > > Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> > > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> > >
> > > The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> > > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> > > correctly.
> > >
> > > Let's wrap sock_create_kern() for subflow with set_active_memcg()
> > > using the parent sk->sk_memcg.
> > >
> > > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> > > Suggested-by: Michal Koutný <mkoutny@suse.com>
> > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > ---
> > >  mm/memcontrol.c     |  5 ++++-
> > >  net/mptcp/subflow.c | 11 +++--------
> > >  2 files changed, 7 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 8dd7fbed5a94..450862e7fd7a 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
> > >       if (!in_task())
> > >               return;
> > >
> > > +     memcg = current->active_memcg;
> > > +
> >
> > Use active_memcg() instead of current->active_memcg and do before the
> > !in_task() check.
> 
> Why not reuse the !in_task() check here ?
> We never use int_active_memcg for socket and also
> know int_active_memcg is always NULL here.
> 

If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
infra then make it work for both in_task() and !in_task() contexts.


