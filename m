Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B31CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249909001E5; Thu, 14 Aug 2025 17:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 220B39001D5; Thu, 14 Aug 2025 17:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1656F9001E5; Thu, 14 Aug 2025 17:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 025019001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:54:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F3ED1389C6
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:54:24 +0000 (UTC)
X-FDA: 83776717248.17.9FB2089
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1B3EA4000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:54:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjboaIui;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755208461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHB/j+0DmL1EK+U0zklBCFzZzy1Aw8M5r+L+sDIIjzY=;
	b=oWdnuGUcUlZUAOmY+P2I4vyhQKKgoCa3dC+fl15ymHA7i1w5JGbTOElSrGtnU0aNFe9Ilb
	4ZEnot8CIGjFOnLHCBqGeH/Mr7hsFUA7jEB6B6vI0sWZlAyS5gMlIjBqV2SfYWkLebt2s+
	G0GJm4hKvNOtoH6XNPhhPvtHtYIDZdk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tjboaIui;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755208461; a=rsa-sha256;
	cv=none;
	b=pqfwZjjnnsjRjX3InPCeEgj8yaKIiLAFRut4hU4J+dsnKx6FI0ppeltfpZUe6c9yMxxTmT
	sYb4PVrD1NOj/agQxJCuKwcydxzaXbJmOW4MluJTH+sOHOGpejx+6xN1RfQDhJvcZ04Dpt
	6ImicBSjlJH2QkLfRJoMSZsQzbb72A0=
Date: Thu, 14 Aug 2025 14:54:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755208459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QHB/j+0DmL1EK+U0zklBCFzZzy1Aw8M5r+L+sDIIjzY=;
	b=tjboaIuiEmzkhcEjR5G3H5Z/cwClH0mr9Dgfa7CWAmuxbKfIiKTN1J4Hc8Yff2omMUoeMG
	bNMb2Cx8niSImfrgsMZEB+M8gjmhPsZjcnw9ARMo4kCXKOV5XUbFscNJCFqpTV7h5oBMdF
	JFM36ZRMOlgbmYLSssVesCI9Ob3Zf/c=
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
Subject: Re: [PATCH v4 net-next 08/10] net-memcg: Pass struct sock to
 mem_cgroup_sk_(un)?charge().
Message-ID: <iqkiuqtubwhdgs5q4o2stonswjbklaxafgfnwclh4bgl2fitcf@ix4r7x7r5ptx>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-9-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814200912.1040628-9-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rh5zosxsp7zig7fczf4wups74m63kmfg
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B3EA4000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755208460-751851
X-HE-Meta: U2FsdGVkX1/SvR+em6LoEVb/nHSzDtNPzbfqmFmNr5DY/1QCUzQeOVL/VyaTl067C2HbqE6iq1jA95l1SIqY24+p1RF6+qakxlPu7A/hR9dqsxqbpH+yHfTABdGe/USu0PCOCkHSD7nZ3QqX/Pp73p/2UYnPeLhv3554jQYXzwjtvKBEHss3pj0gOQjEwRsSgVt4Gi8N1tfIo/k3kEQHPNMxxW+2lEZwu8POyKT+JD89zJq5t8iCGWlUni4noNd/kAYIWMlYMKpkoho56l4S0tZZB4eGB8p5Khd/RKGfas2u3GyjEVYmrA/AzuSxLOSnTSQ/LSxVvtrFVXV+nOcc22w6j1Aij6m9QrWXwm8fWuxy9hjSXQ+tmVw+0z3G8rpuOAvqS2BKauDJM8pGOncDLFwRLdeoKW0VSvGtTsYcTl8YrUtyawWbwTOdM9hIAq3gPiBMEo3Mj+48F4yqhGO8UH/txa9KUiaLWNjI2JG85TC+4LrjgXXqYv2bOoE5x/AIrVrQOnjoC3mOvNxnj7lxPZCHUojcA1bAzQ3syXkvYlAo4mePusywaecIIRbDQl6uiSO9zCv6cJo2Pm7cAKWno6Zw2+PrDq5X2vsgBVgkcNzxlEqwzKVgVI01Dcnj1lsBBWYOOFVsMLRUbt3nG7jfE+TP6y6LijtFr/32zB+sYCpR1WdNaXOLnEKQ+T9AVHK0icDtib+LRrQtXAjjg3xhBwO6bIhg51nNioQoyzT2/tYYsCt2KODJ6sFW1DZNXVqhm7tiygn4FkdrH+QqjvjvaJK9OhBei8CWrM/XR1ncqO9e5cDDx15UuoMq00v8X10t7dYkHz30cW60PFeLNEEdWOHuicpYHCWRvG7cJMkrqTrC5E5/nnrPBKWwrpBCklTZ2ZJBUFYTZ10xUhrhxBDyn12BnVv3i49s+7pAjPH0+V310SL/7f92cKwxoSbpinYpiV6bnJNQoQhQgKE5c/D
 RHl/1WXC
 ZAJxQzCs9b4KfGiWFthjWTpICLeIGKrjPg2yg+bPueHD8XQuVqlAszHdtUFW07vqaF1pU5sB3lIXu0lP/jf+pR6VvZSRS1QEBPXoksax5+GLlglODJwgxUsbUYIiFjZ6TpVpr84T7ELZCEfUHQwCZZ8ERiLpNUVbZE4hzR3jhjxJnu7sIJITMZv1ougpVfzfOGEzOU8WFBIh5eiYsErX9+eWopqY/sBUxzycXs+ZZXB6Xh5z66IjGHhnxNm9vwNux8GmNodWqwqgm0ttDhxtyoA+h698d/EzsrXbn/wrjNVvaqaFLivgmlVfoTUp53Xom5zWPKkrSUFFwFX9QyrOtIqc284v6EZeQqX2nUBDba4wonDQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:40PM +0000, Kuniyuki Iwashima wrote:
> We will store a flag in the lowest bit of sk->sk_memcg.
> 
> Then, we cannot pass the raw pointer to mem_cgroup_charge_skmem()
> and mem_cgroup_uncharge_skmem().
> 
> Let's pass struct sock to the functions.
> 
> While at it, they are renamed to match other functions starting
> with mem_cgroup_sk_.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

