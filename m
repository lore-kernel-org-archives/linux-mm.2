Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF84ECCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 01:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B938E009F; Wed, 15 Oct 2025 21:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3528E0008; Wed, 15 Oct 2025 21:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2303C8E009F; Wed, 15 Oct 2025 21:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 102FA8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:40:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9E0E1A0190
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:40:23 +0000 (UTC)
X-FDA: 84002272326.23.576B8C7
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A009160008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:40:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVQIDwjy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760578822; a=rsa-sha256;
	cv=none;
	b=5aQUpWqQcvxrRcPPjrQc/r3sT7roH44STBaxuxfT8NS7QF/y53JkiShTHWAoHaZPxO3Eka
	jZvpS9LnvwwNUv45rfNgWKSTmD4V+jUcDjL/7+uxE4Aki1dbSzABk1GqgQ6B92xwe2XzLQ
	Ml7Zl/CHhSOA8fX1vKTyGU+7nJu1sK8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FVQIDwjy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760578822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8j77l8B/4CaGghMinMZVNzQZrb0KQZNw9uL/x2i+5pg=;
	b=a725D5Q/xQDaMgKtcEa7bV60TwGi8djNutNg0q2FAOhIhb5tf+Tls3o/Q5EcFB2raWNwUh
	ESOo9e/y5SYnaQxFsNHLarEej2s7AEPlRaMmkk0SRJ9rdlbBZdKJkd2r4S08oAlM2w21Yi
	FXAlKA4GlP8gVJ5DGXV5n05vCiZzrIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760578820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8j77l8B/4CaGghMinMZVNzQZrb0KQZNw9uL/x2i+5pg=;
	b=FVQIDwjyLwrgfsQ9ZgN0VC3paYaWI3yRv04UlT5EMyyAXUVIr4sKEme9jspNGClnzu0jm8
	qpFtRWn8QHyTS2xll53HCNN0IPcGwfXSeux8e7VNKPmGH0ovn67oOqWf9ttLsfGaun+6GR
	4HFwY21reLopqPQtP/hmBvQJqGA9/l0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Tejun Heo <tj@kernel.org>,  Eric Dumazet
 <edumazet@google.com>,  Kuniyuki Iwashima <kuniyu@google.com>,  Paolo
 Abeni <pabeni@redhat.com>,  Willem de Bruijn <willemb@google.com>,  Jakub
 Kicinski <kuba@kernel.org>,  "David S . Miller" <davem@davemloft.net>,
  Matyas Hurtik <matyas.hurtik@cdn77.com>,  Daniel Sedlak
 <daniel.sedlak@cdn77.com>,  Simon Horman <horms@kernel.org>,  Neal
 Cardwell <ncardwell@google.com>,  Wei Wang <weibunny@meta.com>,
  netdev@vger.kernel.org,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: net: track network throttling due to memcg
 memory pressure
In-Reply-To: <20251016013116.3093530-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Wed, 15 Oct 2025 18:31:16 -0700")
References: <20251016013116.3093530-1-shakeel.butt@linux.dev>
Date: Wed, 15 Oct 2025 18:40:12 -0700
Message-ID: <87o6q77hfn.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A009160008
X-Stat-Signature: yox158zrezc1d6ebmkqu4u8a3unkd8bz
X-HE-Tag: 1760578821-825210
X-HE-Meta: U2FsdGVkX1+7+Qg26gVFgu1UWHm0e9pMXzGy6nExE0CdENE8J9MI7udhPD2s09QXP+UOnBiGQ9IZU78t4Kbwb/IIr6nXnFQ8xk5B/GPJObO2EHjtWwtRlJyh/baGdXWxm8PkpCSFb6cwntnDKzvCl3i/Zw+VxXRcxQLc0T9/t3dJJiWGVn2XOmh5BN5z6h5ZnQmsImyuujJH4PS69MwGQ+oyGmzDXldyijCg/9DS8bkc5URZpvsBh7EkhnJ0rnNgzQY/FSJ+40Qlq3qfDfmrJ/P1yt4JuMnRFW6ScrFEM4UdRIvqBhI9NNiARwPGrYKeb5gL5aX/a9D+ha0qgl4yfP4BqTeej/n8LX5p0WnnvVRqg98/rRHuT6y0uQq4+h7mtnGAvWjakv/BjcNcqAd5IggBJGKG0hjjdm/njdiSYclb9v5eknqjew7nrEpD3Dui3spAZv6b/eWkwcf+I4A5xupEm8dEMMdV4UR6PXVGTmuLyL3hBNKf/wXkGIGrolD8TAeB8PKlU3DExnKcfpaz959YW/eQtk2xFQqxSPtxRhfPkn8rSDM6XZmC6nKCp065bAIN54FfEKMfuJZBTG2JzoDRsndlNwj5HUuPd02RDX2cho7DgEYxao7cU1BW1P/ZhizxPLLnAMYsDyg76nMJGlAIhtQU4n40I5GRH8aDDahajybIMczDUt9wIQJvjNVaBePcMf3b18uEmj9D3mpxHPft573UMOD0DKGg1j79GSUZAnmtkIAJ13MaRmplrb/DAhw+dITT0PTJGgOR/B0Gd6HXtXGVV8hKM3eDEIQXwDjchigckX8kLuWpxC8dhyvPuzli/FDVObGLItCoFcrQNcr2CqXRL9gPJ1+kVVHWgK/e7xpylG1EzdYZdNGg/xos1U6TU+gUWB1uojuPWcK/7eSij+ODFFaNK/MHYaH011EVKACFUaV8EWZgP98sMJm5qG/BZtQm+UODZk9/BMZ
 bJy3cS3m
 iT1x+R+aPRhXJf4qZ36ud8YDLJRrzPanhVbhYWS+B3N2kXpn4SE/MB4LO+Z1zIKFgLMwu+w7W6aqeslwKXnyHgCjOQ1UL6SWdb8U9+gzffB5TkDGjQ6wTPsPt5OIuexOF+EjQDNwDAz6ai8PGnu6GP5rj1eogMsEjT2W8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The kernel can throttle network sockets if the memory cgroup associated
> with the corresponding socket is under memory pressure. The throttling
> actions include clamping the transmit window, failing to expand receive
> or send buffers, aggressively prune out-of-order receive queue, FIN
> deferred to a retransmitted packet and more. Let's add memcg metric to
> indicate track such throttling actions.
>
> At the moment memcg memory pressure is defined through vmpressure and in
> future it may be defined using PSI or we may add more flexible way for
> the users to define memory pressure, maybe through ebpf. However the
> potential throttling actions will remain the same, so this newly
> introduced metric will continue to track throttling actions irrespective
> of how memcg memory pressure is defined.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++++
>  include/linux/memcontrol.h              | 1 +
>  include/net/sock.h                      | 6 +++++-
>  kernel/cgroup/cgroup.c                  | 1 +
>  mm/memcontrol.c                         | 3 +++
>  5 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 0e6c67ac585a..057ee95e43ef 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1515,6 +1515,10 @@ The following nested keys are defined.
>            oom_group_kill
>                  The number of times a group OOM has occurred.
>  
> +          socks_throttled
> +                The number of times network sockets associated with
> +                this cgroup are throttled.

I'd prefer sockets_throttled or sock_throttled. And same for the
constant name.

Otherwise,
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

