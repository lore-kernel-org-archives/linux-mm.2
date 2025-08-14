Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A24CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E079001E2; Thu, 14 Aug 2025 17:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F3A9001D5; Thu, 14 Aug 2025 17:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FEAC9001E2; Thu, 14 Aug 2025 17:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6D13B9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:44:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF3E21DDD2A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:44:27 +0000 (UTC)
X-FDA: 83776692174.25.3BCF5F8
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id DF141140014
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:44:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t1Lffbdo;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755207866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19ByPHkfjF5Lwww0ZNwzVRVwJ3xsKPEqJn5AnAvA/3U=;
	b=iE1LhFL9xpymCMRyhYWfeQewWy+F4Lb3zTz/jfeiK0E5fdemSvRNETjeUDnoqEMafbq5ZE
	Zhm7UCJ0SFp+EQuhMhlkwRgBcO5cVYEC908XrhdYLKAQRa0xneQ+FL6yaLguuol+F5M9oM
	vMUZaMqShaiMklwUU4AAPTPqJYfNDQw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t1Lffbdo;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755207866; a=rsa-sha256;
	cv=none;
	b=Gv3eT63Pva+QwNyWttCFKQhmQPR91uic76QMG3mzih5MnyOmtOPdbTG009Ef+jQnjD8BgD
	x2+eEpdVOSIK13u8VcX1Zqjd9L7IumlUL6VxxCHPAfUou7IC7x277HqezQShP2tY26g7mr
	sfNErIlsuHKJgvlcAfyC3ieJZlpd8yM=
Date: Thu, 14 Aug 2025 14:44:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755207863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=19ByPHkfjF5Lwww0ZNwzVRVwJ3xsKPEqJn5AnAvA/3U=;
	b=t1Lffbdo8V4eR10ikc1QCrxW10AzvrgCdPZA5YBsQ6+OleiyAIQA4YUzCr+08bP8URWDg8
	I3WGm7qBbMemh6lNZgLU3P0L13FkBioWFv+J8o7EcD+mc9jCxyJL+fK14ZPQz1+kwyZCWI
	y3C6iL3Q61oALehShym+eszZC21gE8E=
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
Message-ID: <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-2-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250814200912.1040628-2-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DF141140014
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: dpumfrwyxq39yznikjoui6ggxq5zwd7f
X-HE-Tag: 1755207865-544882
X-HE-Meta: U2FsdGVkX1/1C7v06aMIhU7F7rfIZub3QVZAtcGL4G3g0xrrCnMwLjIVRbT0JlArp3+XrJ8wn365AX6mi2lmRSSkFEB9fSUnOJPli/zKHlpFAdXwmu23hX+UlKtFZM67+EA9cr7ST5jo1FQSCQXPV7yEhi9nSBXqv8Pvj3qykZZmdZRheSwLTKVs237ClAFmjdaxh9i+GZOY/s6OR7j0MGXksE7kHCDgiwYhGdfI1EkTv9kU1GHXh+Nt68fOCLeXg6UN8cKpDASHIRBNNKxKuGFWZDx3MlA/TAXmllmWaP23LZtRqOrYMq1WBMqNATa6UQvEbouJoSn+OBKqfuWUSPeWF5BB1fM7D7XtybgMp4w8lPHrbJ/WQZjLJw77M1wjYanKGj4sDDSEWf+h5munT0QIlaYhfKSFJlZRzmXp1gmriUSvW2gEiGW4y8Ywgj/uB/C7r0Plf3z933PbrQ1yEgKDuFYLRW6nwpmkiPKCTO3NlZavIU+xYpDctg1V4sGc5epJ9TebOy7/swMMk7w9cXWqp5bkwfbLeZiaauFkzDBA6VquZzNakaXKuI6MvvGrMW0zFV/VlKc7JKu7qnyicYn4EtWx76EGRBItPulht/qjp28y3Ur9vwphSk7H7ISOUK0+zDKk2E1B3jal0qDnDxGQlZH2DjpCiLMrTyiRWzOPZxsROQWuGtJp73u4YGKqYrwJImdFqbErK8BA/j1HRvjTCYXfbRtUIPndgA/j5Ifgt3aKjkVL4+P8vxZWRz+PvT1twvJL4Pbwck3ss0oi0X0AyaiouL/Knm41EcKKQsaACk1xXbaOT5/QuUsNWp67NJgAUVHuO6/M/BckpjkxZuJUtwdurtitN6jKTb5K8p+EBGZqwG0uu6i9zThtDkz16n/K7YyfghyPf+rQj3CXnFbFD9UI6eJESRRJZIHUXV7k+7bkw0you+hfVQUE4+4okWmVd2/XTxMW2wQzojK
 IohenNJ1
 optZbqlCvPntCj6uH6ohIfCVwA7ilb9depfYj75rYzQoR8S5tlFTkE8ge7RSseEy79BhnG25yJ9l9sclJBZed3V7mZJsDbdstzCD1Si9hBabF2E1KcQlcSzTE+drWoF8lmz2unFPD/yBNNcv7/WJPzgiORrixL9oVln7zttnrKHtixflm8UvYh3T8AlocTDqtYWhHgruX3jHQ8+YPOrXVjzyc/+waG13uAhkmN5tHhbHljPQV7dechBimwlvZ4KXtqfp5hP+WdzCgYVbzmVe3a+mDC6hvr6PmCJOKdnW0GiqQVi4ky+hDW/zxk5KS9AiCp4Qkj2Ae6+RFAMkhprllJw/CSwABMZjD3zgO2mmQxpGiIr0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote:
> When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> sk->sk_memcg based on the current task.
> 
> MPTCP subflow socket creation is triggered from userspace or
> an in-kernel worker.
> 
> In the latter case, sk->sk_memcg is not what we want.  So, we fix
> it up from the parent socket's sk->sk_memcg in mptcp_attach_cgroup().
> 
> Although the code is placed under #ifdef CONFIG_MEMCG, it is buried
> under #ifdef CONFIG_SOCK_CGROUP_DATA.
> 
> The two configs are orthogonal.  If CONFIG_MEMCG is enabled without
> CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not charged
> correctly.
> 
> Let's wrap sock_create_kern() for subflow with set_active_memcg()
> using the parent sk->sk_memcg.
> 
> Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> Suggested-by: Michal Koutný <mkoutny@suse.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> ---
>  mm/memcontrol.c     |  5 ++++-
>  net/mptcp/subflow.c | 11 +++--------
>  2 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8dd7fbed5a94..450862e7fd7a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>  	if (!in_task())
>  		return;
>  
> +	memcg = current->active_memcg;
> +

Use active_memcg() instead of current->active_memcg and do before the
!in_task() check.

Basically something like following:

	memcg = active_memcg();
	/* Do not associate the sock with unrelated interrupted task's memcg. */
	if (!in_task() && !memcg)
		return;

>  	rcu_read_lock();
> -	memcg = mem_cgroup_from_task(current);
> +	if (likely(!memcg))
> +		memcg = mem_cgroup_from_task(current);
>  	if (mem_cgroup_is_root(memcg))
>  		goto out;
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_active(memcg))
> diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
> index 3f1b62a9fe88..a4809054ea6c 100644
> --- a/net/mptcp/subflow.c
> +++ b/net/mptcp/subflow.c
> @@ -1717,14 +1717,6 @@ static void mptcp_attach_cgroup(struct sock *parent, struct sock *child)
>  	/* only the additional subflows created by kworkers have to be modified */
>  	if (cgroup_id(sock_cgroup_ptr(parent_skcd)) !=
>  	    cgroup_id(sock_cgroup_ptr(child_skcd))) {
> -#ifdef CONFIG_MEMCG
> -		struct mem_cgroup *memcg = parent->sk_memcg;
> -
> -		mem_cgroup_sk_free(child);
> -		if (memcg && css_tryget(&memcg->css))
> -			child->sk_memcg = memcg;
> -#endif /* CONFIG_MEMCG */
> -
>  		cgroup_sk_free(child_skcd);
>  		*child_skcd = *parent_skcd;
>  		cgroup_sk_clone(child_skcd);
> @@ -1757,6 +1749,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
>  {
>  	struct mptcp_subflow_context *subflow;
>  	struct net *net = sock_net(sk);
> +	struct mem_cgroup *memcg;
>  	struct socket *sf;
>  	int err;
>  
> @@ -1766,7 +1759,9 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
>  	if (unlikely(!sk->sk_socket))
>  		return -EINVAL;
>  
> +	memcg = set_active_memcg(sk->sk_memcg);
>  	err = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
> +	set_active_memcg(memcg);
>  	if (err)
>  		return err;
>  
> -- 
> 2.51.0.rc1.163.g2494970778-goog
> 

