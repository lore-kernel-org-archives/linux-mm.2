Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB571CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EAB8E0223; Fri, 15 Aug 2025 19:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BED08E020B; Fri, 15 Aug 2025 19:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD488E0223; Fri, 15 Aug 2025 19:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38C958E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:52:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5D83586C8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:52:54 +0000 (UTC)
X-FDA: 83780644668.03.F2094E2
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id EDD9DC0006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:52:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dtc29LYM;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301973; a=rsa-sha256;
	cv=none;
	b=t5FU9qNv5ncXul9fbbCnF1TsHzUDGqhLXPFGlTg35pxOkoo8Kc+Llq9YhQN13b01A/OAkv
	PLsfbE01cw21W1T366V8g+0iNuhqq+OqYK64IGW7dXpO0GNksZuIr6XAMpRITMAZGxSchd
	+3Cva8kD6O/eylVDNeI/vIiz6lDpPMU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Dtc29LYM;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=44mrTSttEiykRrZrwK94sCaa7posB77laqbOo+14xpM=;
	b=d3TrNZozFEzafIsG/BKjMxNyUASNF5oG9cZWbrXMbKnJZZV5L/BYpZIb9zhctCZEyPEY4r
	54+RYVRajt4+IDfQGRjKwRp2gsDzaY6uVkmMz1DoXiakugSojoHN50bdjcKYttwhdw91mp
	bXvpiD6Tp6aVLhQIR2bh/IIHNBSXLOM=
Date: Fri, 15 Aug 2025 16:52:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755301970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=44mrTSttEiykRrZrwK94sCaa7posB77laqbOo+14xpM=;
	b=Dtc29LYMtA/hYmueZXIsJmfMnkavasnCVPDJHF3t9HUseuMaeHO/I9+XMGcy1dd5Di3tAR
	z0q5EKjvP/AqSn7PrGOGunGBOrSSw0noHpc4QA0/sLDYOUKHzqJRU+/NPRnaoIbhCNJ4qw
	ENJpET8DF5R6dD8KrMALzgQIYWjwpC8=
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
Subject: Re: [PATCH v5 net-next 05/10] net: Clean up
 __sk_mem_raise_allocated().
Message-ID: <ntttvqtkf4epnw2cstpjvdrokzkhgjcc42asuxrmoesk2pmvw7@hvnlluilnvbc>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-6-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815201712.1745332-6-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDD9DC0006
X-Stat-Signature: hixxdgo5wh58mdhd5my4m39ohe97jwg8
X-Rspam-User: 
X-HE-Tag: 1755301972-703634
X-HE-Meta: U2FsdGVkX18nmv9LhJ5SVIMHFshTYTrChZPOp35EAM7qEr4Lp2095AdFehXjJ/7GVsIz1oUoXVib8ZhCmMO7de7uDJJvCF8UF9Og2BeudBHokwA4JBKfsRENvvLUvKN9/sWo57Tsg8nkhcug0YcjNktuNdwuH97bpqFMBenzVWtpO34VpWx9FsbdF/dLJ48RYMHGoLEaY8YZHsN/ZQeEh/+/sIuR0mt03QjBoI0KLCJka+fkhBghZw90oP0k0mpFs8omEzrmE28PxQ9G06TzhFXk4QCxOestPP5k0xJmuPfUFY03Sns9Her9L5ACk5CoL/5iJP2/FUQM2Dnd2SyBoIgpE8boVRwhQNwmdXWcoZZ1dHFkxeOZVzy1QrZa4ZdmOopmnZuCY9fiPhHn3uClz/UvlTFu6w0qzGfn0R/iH8FqqJMOZ1PN+DueOuloC8UQMOfp1En5+B0CPQe2/bOrmUTXEEnTRtjS36RHwmBDWLc9L2VtHnPzrKrEn2AKcwi8XahjTNvrmdm9doZbnfBbZivyzwjN3N8fUB3ACXDjS9QnGHc1v+d9b+GHwhaec9xPo1cBg7DZpWHvgy08k4bZwjpnAb9zLzFGPc2QFBo720asAvC2pxU2sCPFHFr1CFLw90sDEiCuZZ3Ce6pueefU36Y3VlMKMOJ0cAbJ8gCsBQWx1mPq5bSK7WANi9yM6TtCsZ/2cU/KchbNRM6ZRMHTdsO3jh1v/ucVVYpoz5WTDCaFeR54+GTtud3ApDtb8iMOejVocggpqjWq/03fj6ZNG9FJ+dsvcCSmq0RWKP2lTPO2kO+PzVPBY/hFhytoNuYsNWS+xE077e9IUKkW4WK1CghXCIHPZSYvuzS98UxXVMDo0HeKIFMRgubKfhpmd+iMVu/q7l6c2MQcn4caDElBsPu0aTXgz0tWZSL1a9O1/1yTvbgHwK/wxkiDX6dQZ4bxhYbHUQRIlDUmaGyIahW
 LXLi/Yho
 qOrquedi5R733xGdL5L7YoypCmsBOECI0CUhqq0n/IyvA8kS8NvYY3sylutcfwgo+sjbC5CBWkEBiHhbt5lMwSOTrMuLymiuDScKmbb1/ifK4zcR9IoUs8cpMl2fPjsaQjuUP5koRCDDq0Kpf4AY/D2HkVPlqR95yqWZtMT7imnpE8GqRGOxKAdlwStk1Ixg7t9lTDye5yLFA22VbT9wsGUU8WdAx5mNPoNOU+E1melrP7d1W+M5+ajsnwhPeIzrlVMEuK1yLKPdOaZu2pu2R8ZVHOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 08:16:13PM +0000, Kuniyuki Iwashima wrote:
> In __sk_mem_raise_allocated(), charged is initialised as true due
> to the weird condition removed in the previous patch.
> 
> It makes the variable unreliable by itself, so we have to check
> another variable, memcg, in advance.
> 
> Also, we will factorise the common check below for memcg later.
> 
>     if (mem_cgroup_sockets_enabled && sk->sk_memcg)
> 
> As a prep, let's initialise charged as false and memcg as NULL.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

