Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D75CCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84ACB8E000C; Mon,  6 Oct 2025 16:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821FC8E0002; Mon,  6 Oct 2025 16:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760218E000C; Mon,  6 Oct 2025 16:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 636AC8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:34:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20555140726
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:34:45 +0000 (UTC)
X-FDA: 83968842930.01.CE6EB58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 69BC316000C
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:34:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZBtdUVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759782883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhXHXemV4+7gQYu3I4QUoO7WBhJC7e4U6IHRoELTUwI=;
	b=z1q/82DRP8ArFP7nJRZ/dvBXekVcISDwQ4QGl1NyjiHk8oHtdpN36PWMoBMeTeWEZjHLf6
	SwNbIhACw99mpuznIpqc353Eyx5EeEno0BY9mj8sJ7YVJduhiiloSk+dD3tqU/heyK2Wzp
	u4dNlFHikGvjjmyE6Q3FR+KJCEBGiRU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QZBtdUVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759782883; a=rsa-sha256;
	cv=none;
	b=aArc/urLqYgJTA+BHayHV/aSLAzonsytM1QR/Ukj1v3iACIcbxLBW2M2k9/mz1nEGgvwvv
	No4L2gx1Otm3IuhwwvdCdu4ddbtdY35hWshcKpfKh4VAnR9M55KuM8CAM6mdIRKyq8bEpt
	u07J1eQe/zkyg7wU5PyoAkaA7cKfLpQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04EEB45890;
	Mon,  6 Oct 2025 20:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB5C4CEFE;
	Mon,  6 Oct 2025 20:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759782881;
	bh=c3t15lOefwVAAOuvSSShpCGZ3VoHfG+ZXf5muYks8Ao=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QZBtdUVaB/vr8yjrPFPdFk/BaAjok3QsdyhQOTFxmddT51D5FqoqKlQHNwJQeoPo8
	 Uxo+h2WQS32HlsrrxedD/xaNoFFHq8tPMT8O27UWeZIRKlydjm/mNR6ooRuZOKjVc0
	 idYxTx5Ofo7bXJ1h3Qf4+6jf6TkgbHGB9FQHGx43kGV0FpuDU4SIlkR6s5cnmEglYn
	 O5g0TbG6DJ3XecHcx/44NQO+8nk3gtFwA2elL1Gu9pIa+DYQ3Wv8H6+4K6aItrOBQs
	 4C4a1kvpqssXWGwUbrF56Dk5Oo6AXOFnBkOyKcWOjJ1iXIshqempi9MG36WDvJ5Co9
	 /iku2fzIT/wLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CA039D0C1A;
	Mon,  6 Oct 2025 20:34:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing on
 some
 32-bit arches
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175978287125.1522677.13468458175773865166.git-patchwork-notify@kernel.org>
Date: Mon, 06 Oct 2025 20:34:31 +0000
References: <20250930114331.675412-1-toke@redhat.com>
In-Reply-To: <20250930114331.675412-1-toke@redhat.com>
To: =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hawk@kernel.org, ilias.apalodimas@linaro.org,
 kuba@kernel.org, almasrymina@google.com, stable@vger.kernel.org,
 deller@gmx.de, davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 horms@kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 69BC316000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 1xrezznfpwj6bezz18osms4nndmtj4zu
X-HE-Tag: 1759782883-238594
X-HE-Meta: U2FsdGVkX19iA8/EqZueAEOdmA2dYUZH43MmEH1HsmWomsAVQezbzaMB0zpfwsUm5eWHsGamcmi9POSgTELFJuLAudUo/ltSrLFvb1pygY2SOlGR10OigN6qA+V4DzH5CNK6EOmRP+yDmfYjYbWvwZYWIBRONSAV8SsI363Y2bmHU/JXewbVJQgeBDCJmXpLhrzsc15vREFkxkaf9olntp5nltsgwzf3HKOhx2gLyu3GMDuWU+2fyJHRLkgnIxQ4njC0BwrTq62yMuI2IdZbFX1PBhYei+rr2STQ6q87+Kj8WMwEdWN5XITFsR74Q6pV3GBJj2HaXIpRRbT8G1ZD3u/OsKyAgEcWa6Mh+o1b7EDl+edJAQI844q4D/WGGQW1kL/4B8Mf8JiI0OlBKs0WQvnO1VyjcNSxD7Jk0ZQo+Y3usvp0Wsh/IKdr8hRedkjbz9LC3hHwEOF3n2f700HHLCVeBxKKMqt4lz3cMvKZo1ru8Zw7Rv4tGZTXEQEqnByPl2EN16FSX9pXjMMC1pVnWVvuaGkqml2xw8zsSr4rX084M1bvobYYkfU0dKEW0LfUgnDNNuGYu758ac5KIuhw8QbfHKBuewWDc0XMnLlAUlTpyzIAmYPtJDIVCNef6tbKb8B1mpGaLtBiHO1BdGmCy2ZqarJ2rZBLy1V4To2Ax9l56q4yAeMeEruqUViMOkU5B9W7JEUEvlqDeh5jaseojK6+ABy1yPIswZWVDX/BRWOLsSO0ViBiM73Md5VCg6V4V4x3uaInz4i8qsgEsJW6xWKNNeXoLhoeSCp3jg+1JTMmAq7Tkx9fyely6qRxPw+DBBNAhhu0bGoGPP5cxrQf47G4uq1QEYmPlE82pgxr4vDiSVbKNgn0vC3pdMqxYH6+s0exRHjqqZPnMEbS6ZM6Nca+hBihqqs9dNY0dc5RGXCOg/9VtjeLJBI40QiYJYuQMSN3gABlNMiNuLlff5K
 rgfp4/HG
 Bwyy1s2Dl85ST9J/dp8kb98Nm+2ScwCgULgV1hMmGtH4j+dNDCPo4wBghUyiARJwg0Nh2Da2uDrXh94tZvDt+pKFIB3vxF6+e99HH3OfV27W7T+ZaB2CxP0wspQExxOtGmxZVQjXdI9aBgnFC+vyCsfa5Ya/vCDx7cqRs1+qu/fphvB4VgWV1lutE/t2yz5bzyflvWDt01n866ZPlF9gJqbwIaR/VHDHdhJPu6UgXitnKmW5RMNRZAtjzQrJ0tkTp/uW9de91V6r4wYLUDDNEBpr+LLUtht/jwxWPNxFVuv7hHelo5UEdgUFf3mV3d7N5PEzSIWGlCr9KFhy2iiXzrf8oxpopUcyBoW9hsEPSr3ESUDtIURcJbHuweFjcA/FJI2Szj4i+DrsJUHKIeJUZ+Cs/JSMDOX4jwwdPV7pSMh7f2TnY+L5k5oF4FETDPfFKVKAnKbuWQUf2f4HUzbT9K+l3HGKkOVcrqlxEvuLcs0vPKugRmSVf4NI4a7r2mc4HySo7EvajJ5m6ifw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Sep 2025 13:43:29 +0200 you wrote:
> Helge reported that the introduction of PP_MAGIC_MASK let to crashes on
> boot on his 32-bit parisc machine. The cause of this is the mask is set
> too wide, so the page_pool_page_is_pp() incurs false positives which
> crashes the machine.
> 
> Just disabling the check in page_pool_is_pp() will lead to the page_pool
> code itself malfunctioning; so instead of doing this, this patch changes
> the define for PP_DMA_INDEX_BITS to avoid mistaking arbitrary kernel
> pointers for page_pool-tagged pages.
> 
> [...]

Here is the summary with links:
  - [net,v2] page_pool: Fix PP_MAGIC_MASK to avoid crashing on some 32-bit arches
    https://git.kernel.org/netdev/net/c/95920c2ed02b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



