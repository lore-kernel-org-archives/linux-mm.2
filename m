Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B909CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D548E0025; Wed, 20 Aug 2025 11:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE6A8E0003; Wed, 20 Aug 2025 11:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB3B8E0025; Wed, 20 Aug 2025 11:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3138E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:00:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BA7C117DA9
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:00:25 +0000 (UTC)
X-FDA: 83797446810.14.3BE8B2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7977B1A0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:00:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PuCHCwzO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755702023; a=rsa-sha256;
	cv=none;
	b=3kZxEDcc43o8sbak1HtroHS9SIi908oB6I1r7fOE4z6qZNYcid2CeHR1i06mw5NO2RxeQx
	l2hyv9GntXuAki+Iog3ngUaGUdcbSKmBAZ2o943lE8e1h7uLXigMapCQHLXibr6FPJ+zVV
	fiVXu7Xhk254yi1QFwmY+4mDR8cSU3Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PuCHCwzO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755702023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIhIKi6NoREPTW2z8Eler/Z4122rvaZScKGi0m1rAn0=;
	b=LuQT6gulIJLDZJqiWiVP7hE9Pe15QapbXDkCUsvLzRu/cYG8L+ntVsoO8yVnBHVtADFMll
	BlnhBSeugUrOq+sgThieqAizYDfVOUD6gD+dCmnO6hibhwBmPkZmW2Hy//vM0IvgfPMnwS
	tfpPwxInnAZ1A0BuREfNaThPxtEU2Cg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A76526141A;
	Wed, 20 Aug 2025 15:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EC3C4CEE7;
	Wed, 20 Aug 2025 15:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755702014;
	bh=5VGDh1deFiHXVnIppXw95FTI+vfIah2j7mM90eoiq7U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PuCHCwzOkC+TBoUD7rnBo3Wg1ej0Od39GERmYmfaz6tHGalTfP+RfciJl+qNjgu5z
	 TPSNNyzZEBYYDwgxAvb4rqNf7gjt04mViK0eISjRBas7drErS9Gfe/VpMU9Lp5r4nl
	 w1kzGAQbEwksJDLWMQAxnunKieLdJpwYwm55uhOVgyJ2Qlnb69fdLeMH5olssKVHjZ
	 Nv3WjN6tXI9clLIVHWceMZzaXouR5DaamwVzFRFfmdlJLv8RyMgAeO3sIrmzcnntbQ
	 BRU/v73nkMORi/iT3oTf40wQKLhPxQZOZgHToNWtTpJQtUCbdQv3BV71uNpQD5ac6m
	 HIdM6uf+VRD0Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE423383BF4E;
	Wed, 20 Aug 2025 15:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 00/10] net-memcg: Gather memcg code under
 CONFIG_MEMCG.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175570202351.267477.6309911387508861679.git-patchwork-notify@kernel.org>
Date: Wed, 20 Aug 2025 15:00:23 +0000
References: <20250815201712.1745332-1-kuniyu@google.com>
In-Reply-To: <20250815201712.1745332-1-kuniyu@google.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 ncardwell@google.com, pabeni@redhat.com, willemb@google.com,
 matttbe@kernel.org, martineau@kernel.org, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 akpm@linux-foundation.org, mkoutny@suse.com, tj@kernel.org, horms@kernel.org,
 geliang@kernel.org, muchun.song@linux.dev, almasrymina@google.com,
 kuni1840@gmail.com, netdev@vger.kernel.org, mptcp@lists.linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org
X-Rspamd-Queue-Id: 7977B1A0003
X-Stat-Signature: og5y1faxqse9y9ydi9sndc44bxf8st6g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755702023-527179
X-HE-Meta: U2FsdGVkX1+l/oTjq7YTuPKxrkew3cXWsxwXLVNMIXVItaf6AiWV/Nt32SJSuqjxEutGh3ywAAXeAQ5yoKyimmY+sbtogGi3XN8UcgUWH4Kb26ZhjC0VW1MKDp5xbHLC9xrwf3tTI9Vw8edMz//7LZ8Ove5pPH+shNfh0X0I4xy9L6YrGmSA6Utf4ltdF7Ivf5omzHyrHJt3titD4PvjMdn67CTztNM/AAJR0U845yELauwtfo6Lzhib4c6Z0AzXIgx5UXH/xqtyKVtykDUdcGur9VPtmDbxwZFTR3N64K//c3fgW8ORXqq7V3x07l6N6dvAiIVlNVVuTDhOb9EXmjqzFNJ3bHHjM58kpX9754NxyEZM/1JPo4y1GnZmrBIAezySn/e3QI5/cBMQryTnsB66Dnf5GceOHfDC/P6Wvp9W2toN79nPH8tAUsFoJGngzrdCna5WBdBW5ivzm1A5A6U0fwbnrMRw9mosfnO1PK4njvFnbJBVdU6oBunSbBDBx+xX8BqCEUQavK2v57UMWGABN2enfYq9kKKq59+9M1IFMrOAn+ivkkaYu04SZHtFzisUUUxe/1sCJe7S2EMHwGpORJ23EOLewZZ72Q1VikTV9jm47pVTvJmHQ3N+R/Io4wW0/a4UXbPodapb3aBUB/XGmw5PWLpL5BsyWK5I7V+h878ngApK6kW+ITaJaHvtI6Rkt/Mec7fLMNDjE6A6GgQs5li/tgj0Da2FIVNkkCvz9iWZxWZQB5GZRUhq4I9xtg9vxYpAEAaK64jA0VSlY1jUIgnbMe33lppPmh4Qtniu0EWzY2hUPPZ7PDmdesoDZY8P0QYuEw7HU1y4d2lD67Ak5D0W9IlkfnLBiXVSQsvw85dJLcLO1ZaehRXYKr3oGvLmZfj5paPEtTrI4AbCvQXcWzfeXJnxzPC0Tw+gwjrDrN4Eh3vunbWr2i73sWPTYyWuHucHPHRm8Xhmaj3
 s6mCxqzi
 u7j+3LvEV8kc5ARGQvnWitncohya6pmZrhB50zqBXoxRkPNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 15 Aug 2025 20:16:08 +0000 you wrote:
> This series converts most sk->sk_memcg access to helper functions
> under CONFIG_MEMCG and finally defines sk_memcg under CONFIG_MEMCG.
> 
> This is v5 of the series linked below but without core changes
> that decoupled memcg and global socket memory accounting.
> 
> I will defer the changes to a follow-up series that will use BPF
> to store a flag in sk->sk_memcg.
> 
> [...]

Here is the summary with links:
  - [v5,net-next,01/10] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
    https://git.kernel.org/netdev/net-next/c/68889dfd547b
  - [v5,net-next,02/10] mptcp: Use tcp_under_memory_pressure() in mptcp_epollin_ready().
    https://git.kernel.org/netdev/net-next/c/1068b48ed108
  - [v5,net-next,03/10] tcp: Simplify error path in inet_csk_accept().
    https://git.kernel.org/netdev/net-next/c/e2afa83296bb
  - [v5,net-next,04/10] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
    https://git.kernel.org/netdev/net-next/c/9d85c565a7b7
  - [v5,net-next,05/10] net: Clean up __sk_mem_raise_allocated().
    https://git.kernel.org/netdev/net-next/c/bd4aa2337374
  - [v5,net-next,06/10] net-memcg: Introduce mem_cgroup_from_sk().
    https://git.kernel.org/netdev/net-next/c/f7161b234f2e
  - [v5,net-next,07/10] net-memcg: Introduce mem_cgroup_sk_enabled().
    https://git.kernel.org/netdev/net-next/c/43049b0db038
  - [v5,net-next,08/10] net-memcg: Pass struct sock to mem_cgroup_sk_(un)?charge().
    https://git.kernel.org/netdev/net-next/c/bb178c6bc085
  - [v5,net-next,09/10] net-memcg: Pass struct sock to mem_cgroup_sk_under_memory_pressure().
    https://git.kernel.org/netdev/net-next/c/b2ffd10cddde
  - [v5,net-next,10/10] net: Define sk_memcg under CONFIG_MEMCG.
    https://git.kernel.org/netdev/net-next/c/bf64002c94fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



