Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5848ACA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71ED8E021D; Fri, 15 Aug 2025 19:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A229B8E020B; Fri, 15 Aug 2025 19:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FFE8E021D; Fri, 15 Aug 2025 19:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 853D58E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:31:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05DC9C02F7
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:31:46 +0000 (UTC)
X-FDA: 83780591412.29.A447D4D
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 38B214000C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:31:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUalADxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755300704; a=rsa-sha256;
	cv=none;
	b=HpvpFMzBzkkt5uNyP3fM4mjMsJ8Zitm+K8DMtoY0NGAq7p8EDmmLk3qrZgPsGsZSjwJ1yS
	P0dp4RJ6z7NUUO02MX5y23qUIg569FtDTLaeUowtHlnFd0VmHZK2hSSfW2IciSj5JFlKkO
	SDY7yIwTT0CJ/4lGZfj1cmR4xmxLkGM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vUalADxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755300704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mWAMiGacIPdo/U9tWrZ4G95PCsJeEqc6aHk78b6x74=;
	b=TkqYZcqLn91HqNjK2dt/XPMnFc7es9B7N65bgG8mxk9CTs9i9J743EXt7/Yql0xTDfLkvs
	+3TbmvW+8pmOjkrp+HlNLlcyHbUWd+l5UXzFYj7PdfmN+zfL6yyIfJkwx5LdP6QYPWc2RT
	miZpGhRdy5lgp2ldMC5f2JoLNXvkQr8=
Date: Fri, 15 Aug 2025 16:31:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755300701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8mWAMiGacIPdo/U9tWrZ4G95PCsJeEqc6aHk78b6x74=;
	b=vUalADxHq4n5TJyKV8RytL6pshWYqmbgSJ52T0tz2UYUci8EEBIB85xnniIlNi5ddQLAR7
	ucGIjd839HqjVorE6RTr1GxfMme8r59DDlekkpWP/EcvAs2oI7tWmFQdBFW5MpBXbUHFK4
	+Rh2quaCh0LQ46ltOhdBynDEnItymNI=
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
Subject: Re: [PATCH v5 net-next 01/10] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Message-ID: <3x5m5rvbvtnta6lqyyx6k3uew4zhg5nxt2wmadkpi5t6tlsko6@peltw6axwvkg>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-2-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815201712.1745332-2-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 38B214000C
X-Stat-Signature: 4yowbcgsmnae1zujuf6eaxfn99sp9ikz
X-HE-Tag: 1755300703-797190
X-HE-Meta: U2FsdGVkX19DKgPdH+pF3MGrLu79ipdJangTIGN+Qc72/O4iOt2wrEl13ojJ1hP5fP9sZdBqlDS5y0H6wHz3U/uauFq7wKmFxiZzOg1+kInZRjWs3bfpbge0XGruZl2B+0OwXxRM0dbCYwGFYGf3OH3MyZdzwoEQMKY+oIrhcEKwn0Apvkrze14OpI+s9SWKEFFuLvDqhJVrD3j/csbmGPKTbOovFgwcuB/8LzHRokfh9w2BuxHNpAVCAfyesHRhLZ6pj2DzQm8t8hb6pdq0b+SMamcIENXGdQEvVqEjT02S0z95J5VHkOdeTIBd9B5mT7NNM+LOUnCW24fJ2H3FiNjuEhYulQ8DGrMsSp/l8s1dyLRlMCdhMZEsS5fDP9hgU8+uxOh/VTpTG7sqous0oZZur/c+D3apsoxPwlQZyDuhWk6alDxjeTaxM9rM2jVp+HXKUU5vLM513yGilgO1HzECmwkQaw+7jT4Y3PBtnq8D72d18b7j14j2huAcL1OXbfTW3OIEWKdiVANQgsPwmCRv3kwp5GGnVUl9JWqgThpdR+5CljGMVlZt0UrCVilPtF7SRyvbDzkaWibTkLhftVo+dlbve7xP+rPUD7BWuEuS4dDTKCHnmaLh/381dt2oGSkamp8q6YnUk9p062b8zVSpDHHAzLincm0/3JBGKvjOiS3Z9yh7eiKe5OLcSbUZiR7u7Ksf0Gef297M8D8V7oCBToM0o+YiK6aHYQOsQy7SWFsc5SBcY7W6XjBTIMBe/U5iqyeVEWDPSc71zHx09UDCH0Cm+VjsAIb8TdrOGN1NTycXS8fDWvB5ylO4O4k89HPpryNvyE2ifLjGH2jEUlkWkkcwnVWsqo2D/VqeDzjf6qKqet8VPb0++GTmNxZ4kq01GqKSDrQtEeck3ouR4CbdI9nieoqpTK2YEcVT3SZpPbyGKRYkCBbWQntGIapPyq/2Eca/w3nLmJSE2Kk
 3+9MJTUP
 6cK9EZnjnmfgWfU0VVA+NnVCUpFwNqs1jDPUxiU6Yt3EeRbLrsp69+PRlReFvsNsY19D7F8cVOOLPzF03JAHQbZhdAjOuVG1TT0yQNqATcl41Py9LYnQ6y01Js0h0JB5B9nEArnAjokEQVIFRohU1k4uT8VmuiKK78ka7ZEJ6IrDLmgnEqJUML6Dd6zSrpnoXLo27aAafP9ChbIit5dCxwuO189DzdrMP8miGy/90UliKmx1TkR90MmLzegGoCLwT+Z1ymgSGoA/6V9OpevkxEepJHBPD8iO73SDfhgd7QTk19fE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:16:09PM +0000, Kuniyuki Iwashima wrote:
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
> Let's move the code out of the wrong ifdef guard.
> 
> Note that sk->sk_memcg is freed in sk_prot_free() and the parent
> sk holds the refcnt of memcg->css here, so we don't need to use
> css_tryget().
> 
> Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent cgroup")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

