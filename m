Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA7DC83F17
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 02:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BB488E003F; Wed, 23 Jul 2025 22:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792D18E0002; Wed, 23 Jul 2025 22:00:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D05B8E003F; Wed, 23 Jul 2025 22:00:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 58B7C8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 22:00:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D12CB11188E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:00:26 +0000 (UTC)
X-FDA: 83697503652.28.5D36F28
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0FA851C000C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:00:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZpVLHS3;
	spf=pass (imf18.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753322425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeBKQHu4REtoDiGxmR/wYFvgGjsPsH6vkGgdHIDgaKo=;
	b=WBiLNkqKg02MfZVKAGAp6QxOQSUJlDOwJayFST0yL/rrXPORz0B8Nf/bkHIgew8UgkepLr
	K7EeMf7mgQak68MOuuwnJP7VgkUqhQB85YSomHMeixyYknilkPADgC+LP+GrUJ9IIpZiEO
	buoLPThni7wM35i115Zted6+JRkJbe8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753322425; a=rsa-sha256;
	cv=none;
	b=BHuRn8EI6A/zBmhIOtgwdYu+bJURo9yNVNAXLV6v6f2gTEXVWZSBjhfHXh57qk+XhSylmO
	rTLuE7xZo2SB0pPAk8cFT55qX5TfOt+zOq3Pg07t11kJOMqS6RJHQgJzvvG/BK9708yFZx
	YvB8WFcGYDICXUqv2uLGkvv43jhIP1k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZpVLHS3;
	spf=pass (imf18.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id C194B5C677D;
	Thu, 24 Jul 2025 02:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6749DC4CEE7;
	Thu, 24 Jul 2025 02:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753322423;
	bh=BpiBxoeu56d35+/JzOYrXKdHXbJJT/hxC16C6lp6gcA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FZpVLHS3icbEQYbRG1+helDdBFX+wQpCFSiakNNIv0ThNYsWN8+wKwU2x1N3sV8Gv
	 DXyX6qd9uvS9jbrnH0u1AgyvOaQft9DZtNjlPlsDXjoox7TvcPgZF/8wxi/eoD80UI
	 pIvFlEM4HcIYFB8rWvVJbTSH6/DXIoGZ9E25Df4gXS0SPlyC1AGBcuDyjGXIo4nkX8
	 X35iuPt2DKaZYuJFYaIKvTAJD2ICgAWE1rhevidTMwzKKjRKBODq2DoqE4ZEKRvMtb
	 TxPoHsoPDEoXYaEYxkkgSrElK9ZWMvipIX7CN8ER7eNLHuBZQez7JQAhtnpZdBVBWh
	 97HvXJttZJJ3w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD9E383BF4E;
	Thu, 24 Jul 2025 02:00:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v12 00/12] Split netmem from struct page
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175332244124.1844642.1793292791852018522.git-patchwork-notify@kernel.org>
Date: Thu, 24 Jul 2025 02:00:41 +0000
References: <20250721021835.63939-1-byungchul@sk.com>
In-Reply-To: <20250721021835.63939-1-byungchul@sk.com>
To: Byungchul Park <byungchul@sk.com>
Cc: willy@infradead.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kernel_team@skhynix.com, almasrymina@google.com,
 ilias.apalodimas@linaro.org, harry.yoo@oracle.com, akpm@linux-foundation.org,
 andrew+netdev@lunn.ch, asml.silence@gmail.com, toke@redhat.com,
 david@redhat.com, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-rdma@vger.kernel.org,
 bpf@vger.kernel.org, vishal.moola@gmail.com, hannes@cmpxchg.org,
 ziy@nvidia.com, jackmanb@google.com, wei.fang@nxp.com, shenwei.wang@nxp.com,
 xiaoning.wang@nxp.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, sgoutham@marvell.com, gakula@marvell.com,
 sbhatta@marvell.com, hkelam@marvell.com, bbhushan2@marvell.com,
 tariqt@nvidia.com, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, mbloch@nvidia.com, danishanwar@ti.com, rogerq@kernel.org,
 nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com,
 shayne.chen@mediatek.com, sean.wang@mediatek.com, matthias.bgg@gmail.com,
 angelogioacchino.delregno@collabora.com, aleksander.lobakin@intel.com,
 horms@kernel.org, m-malladi@ti.com, krzysztof.kozlowski@linaro.org,
 matthias.schiffer@ew.tq-group.com, robh@kernel.org, imx@lists.linux.dev,
 intel-wired-lan@lists.osuosl.org, linux-arm-kernel@lists.infradead.org,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FA851C000C
X-Stat-Signature: ja59c86emj5zpcox5gy4hscozdidd5cj
X-Rspam-User: 
X-HE-Tag: 1753322424-728039
X-HE-Meta: U2FsdGVkX1/hxV5n68buuhWZfxE3quk5+ZN+flq32ns7wgWg9ofvOuoVVJMN1aNSAH/THaid5KFnNwXVmWXRE+nRERsTOK3Io208u0cSdYp88S4azZThakjY2EPaw8woyz2iPr44J/ZgcPH44zs8K7Z5yXCG6j2n+iGRgM3cj8E254C5kzRpwIqhCAjiFKEGmJvth4L+wV75A10wzS1Q2212ErKTWBpL6bMWxEkbGNDbXHox8mb0L+4+GfOxrMCX2VOneiSHmJULXGQH8myP7A08YW/FS/DGL+eTYizLiC8jOZPsi48oMCPRP6+gemPF085yCwvqVWdOaon6t2gLasHGdjspKwIE1ML4xU6AphJofKweM/CxaNihllF2i8t/ARHm3TRxPe7ipHk+o1p2aSMW/8Tmmi7E2u1yU3oCvUsVzCpQFEQH1YOteZMotKDJmrkW3c6jFnjNFZQ6rA4MaWZzcCAZCtxDllFXmHsOdlpv4tmzCCff4HVOZCBVlR9Igk0LB4S6A+180yy6RzqReK2E0lBraGpeGS7HKfeW4HAGqEesDDp4gsSfJvW5awrYkWl7Nl1Sozfam6uBZLDOH8E2etevwunXKO/ZOhJlz5lwA6dxYGo0EaGME3Lvk3s7AGz9U81JJI8j4GjzUm7AD4F/laj36xzA6HAHnTl9Fv02J5ULfg4OitvPsOhzyIJ94/fqmp5aEg7QtD0A9yKQ4S5efsuO9PjW1nQnW7ovhtJrzqkreQQ+dSFw5AHuOWwJ/UvG6lxLS6AyLFFfYK91blPUopYkwjIhl1wHM93jbjYh9pPLe83rm6Hb6C6BpBdvzjc2D7+tuNIXr8H9llHbuI4UgsUU/P2xPb6M2WATa26YPL73rsg+1pzb0FIfAGmBEi/KohdSUpM2MSrkt6yrcy6ej3vsBaHjENFDEIWSORZ4bMsAjVn7ZCycFn/+XvTas3MDLsisbFqA0Wdxc2O
 8k6K6hbI
 V6GDcqkw/XHvZ5I1DzfErGGqa5wmjWLovgMdXc2LgEr6yi4lcbtBkkJPUdkzkW5vHLrxLlUsTse/R09ka7680mems8ye861Qh6A83Bcpn/ZuqIx4J7FAQuXkyzL+kdXBK7JJcA+5Yos2ek87xN5yhYF3UAiCHundvQc2BfGdErBMTQLH/Y2qOm8AzTWtNFkk3YHicS8mGjcLIWk7ivO9c0Ww0nHFjXsEAD5PvPba17fJtrIQw8zcJOA/5H9P1rlDUrlb7nHle0ajfXBEQDBjF+6jFk0zHcnI9PxbEvCZ0VkBZyqxXDVOBaiCwCywxYE5FpJ6kfUmfrRLI/z9eTb6FGCXU6v7fYmg6Yi9rZx6Dvs3pXadVQLtWaTEUOh7fFOf8SFh4HJGL0ge48Eb7lIsNnYxMea7e07uhF86+gnQ6KYUkFWdVZdcoWJj72l/rqm1j2+wXftgOsF5s/JRwz0WkbygeihJ7MMcKgAZ3lTUYwvpp9BMNAQ+nEjzVgoWxfdiIh/N7
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

On Mon, 21 Jul 2025 11:18:23 +0900 you wrote:
> Hi all,
> 
> The MM subsystem is trying to reduce struct page to a single pointer.
> See the following link for your information:
> 
>    https://kernelnewbies.org/MatthewWilcox/Memdescs/Path
> 
> [...]

Here is the summary with links:
  - [net-next,v12,01/12] netmem: introduce struct netmem_desc mirroring struct page
    https://git.kernel.org/netdev/net-next/c/f3d85c9ee510
  - [net-next,v12,02/12] netmem: use netmem_desc instead of page to access ->pp in __netmem_get_pp()
    https://git.kernel.org/netdev/net-next/c/38a436d4e264
  - [net-next,v12,03/12] netmem, mlx4: access ->pp_ref_count through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/89ade7c73065
  - [net-next,v12,04/12] netdevsim: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/6fd824342a57
  - [net-next,v12,05/12] mt76: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/87dda483e63f
  - [net-next,v12,06/12] net: fec: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/65589e860a80
  - [net-next,v12,07/12] octeontx2-pf: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/58831a178551
  - [net-next,v12,08/12] iavf: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/c8d6830e32eb
  - [net-next,v12,09/12] idpf: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/fc16f6a5877d
  - [net-next,v12,10/12] mlx5: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/5445a5f71209
  - [net-next,v12,11/12] net: ti: icssg-prueth: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/c0bcfabd7752
  - [net-next,v12,12/12] libeth: xdp: access ->pp through netmem_desc instead of page
    https://git.kernel.org/netdev/net-next/c/9dfd871a3e2e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



