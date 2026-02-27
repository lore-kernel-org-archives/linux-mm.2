Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890A3FD9E37
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 04:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51F966B0005; Thu, 26 Feb 2026 23:00:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CD166B0088; Thu, 26 Feb 2026 23:00:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC316B0089; Thu, 26 Feb 2026 23:00:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 28A406B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:00:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 984861C50D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:00:04 +0000 (UTC)
X-FDA: 84488883528.10.FCE1E77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02EDE180009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:00:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9Cq02MO;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772164803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S3FkP0WT8e5gqrjQH8xDPr6L3o+0cqY44xbHAQlK6vQ=;
	b=WgLuYMIwlx6q1pX7ehZv27mbSA9Ab5ciuoWl7LQnbRvOurhuHQO+97qBhZxcGWtNqf3PNU
	bMzx3vBLj9YwiRy8ophxUGjeAmtUziQD34tXGHHl5VqihjM8mTVoIOtvD3ATLBANmmO1i5
	VaN8un2GxLvmDx/nkI+T056sfs60R1c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9Cq02MO;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772164803; a=rsa-sha256;
	cv=none;
	b=yyMfcTr6roZmlSvjAw1vEZGyf0LlgYrDIK3aQObi9lNLKqy3O9J+QAEcGT9lC55fTCPCZ5
	SibN5iX7mN2yq13WA69H+37bcRAswtTooq9fnoA5ropVCn85oekl9VF4dgYWAWXveSi4AY
	J6CqrjzDYbwr5SKXteGEI2hQfAlY7p0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F6E660103;
	Fri, 27 Feb 2026 04:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8791C19421;
	Fri, 27 Feb 2026 04:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772164802;
	bh=1+lZ0E55IZSnlIC8aQoz0il+erk4zax1IShpIXOWWWE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J9Cq02MOZz927TYLviYPTRy5DWxNgVdrOf9xFcrbrc3tbBR/HmexUgcCuLgDKBEFJ
	 +fVvEagzJ5cI4qpkKtOszq9KN2TTk4zzzp21aWa4I6Cg75eJ9crAHf1jbVOlYrFMRq
	 wLSotxJBw1IDOBnYnCuoZK5g8jFd5fiSEwFgKARaeLt1hKb7GmTtQBKSpre2AAa0zA
	 PQ/zh8rUizHBbH9dwVifUIHul0ZV5T/NgvOa5YTJP/s3AWEo2MIikVpbd+8JPoSPCA
	 k9EzevIjsvieLAAJeTQPQ3876jMGtGk4CDtmDuIfOLuoE5D0f/uDs4s8h40WOfupoE
	 fps+qgy5TlhOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E9839310A2;
	Fri, 27 Feb 2026 04:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH net-next] netmem: remove the pp fields from net_iov
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177216480555.1965102.13851630546170350105.git-patchwork-notify@kernel.org>
Date: Fri, 27 Feb 2026 04:00:05 +0000
References: <20260224061424.11219-1-byungchul@sk.com>
In-Reply-To: <20260224061424.11219-1-byungchul@sk.com>
To: Byungchul Park <byungchul@sk.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel_team@skhynix.com, harry.yoo@oracle.com, hawk@kernel.org,
 andrew+netdev@lunn.ch, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, ziy@nvidia.com, willy@infradead.org,
 toke@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, asml.silence@gmail.com, axboe@kernel.dk,
 ncardwell@google.com, kuniyu@google.com, dsahern@kernel.org,
 almasrymina@google.com, sdf@fomichev.me, dw@davidwei.uk, ap420073@gmail.com,
 dtatulea@nvidia.com, shivajikant@google.com, io-uring@vger.kernel.org
X-Stat-Signature: 9y3kip7164p97s98jungfkxthxeqyqka
X-Rspamd-Queue-Id: 02EDE180009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772164802-743721
X-HE-Meta: U2FsdGVkX180uGcxXvtaJi3x0SwrUeg9bDDRvZ7f89X27IJo1HXvqmv0mYXzmUIli8g43t24DVf+FVehfY+CqiEIK0Z2kwSZGCcnMtHvcAnLbtGnKOIv2fLCyNA59+7ab9+Wv8yeZK1L67CVC/2Y94U1H1cdXCYg3YBazUqaR/Q107yFMXIVfn4C68zrxtoZGiofpYC1tOAKdJBf2i39g22GV7fXp9GrcLweE8ipCMc1KeI+KlYJ7EjoIMCHhe5RXS+TI9DYz0yHKkUh9mDqQ3dWxCkFzZCP3Fuch4ge4WOgN8Akn7I4K5XttZRNMi6K1JWQtBs8ITsGu2D9LHPTFX/0o9kf4Lh1ooaxVSWJ4jirGtl5tpKX1GwoSTkq2nBFRUR0Gt/l96FNEXLii2iUwBgGGUE+jB2IR3K4/LOxQ1Iuy4NnaTlTDwM+sI/ix3YOgScXAsbQgSBwufY/9Wwfutx4YHSRNYESvfR4kcSw/bf8unqCjg/ufsfN5LE6zgq0qcEfOS2SzxMS3+oOCIGj2JESZkCRXJbyL8y2tyaoQmiiull7bn0eWmxBdw2g5m3Y/OcAR5lvqyOVrK+rRZHC18bzYCHFTAABQWpgntjQ//rCEAjuyS93DW9XSLdsubhD2CMCf3Z7eGs5YJxaHhrf9I4tBQXlQRIA6xJs4pyn6msovqcI4eWxbLT+fLSWNSTCGwZnTgL1gvad3Bz5D57k4/tkbTMRMtmwSnGbqG5SNZjYv3N8+QTVN+mSYiIch9ernkyIYwNDL4/vaYG0zsaPXgTWd/9jvlL4vO++PjnOI5w1UO7UMiAMC2JiUix6JQiG0cou66wnsqhCW0ZVyihWTfjmdmxvlkFCIzYxXLc4qYo08BsCs4Cu5SY3LdZxojYrL2qQnjD23oNOQmDSymlAOCq+1+p9LnnRT2ioZx716wIvqNtOiN72mAPqNJvKQuIzQGErDhAfhJwWPVdPg7P
 F88IUOt3
 FH0GjCgLRWXRqdQm7lewRLmNAvBhXsisgi0OzeieKG0jfj+/0jE/LAutn/OkRdc74/Jti8PCHdGqeuMlgc2dzK6dO/Zm8M7z102JtTyoXY2Mur90Ipm4EOCQUUVGOVNtfwWfTkVM6Q2LeUy3FXUhj7seF11TpuCNI+DGuGv42m2JCAFE4WyB2Nwwq0nrcmBc/DoRygI4fovYJYbNwTfqHT/mGpBEhxPUwiwj69Tyju5N4m/6gBlDWaVxk3c/iTayBf55AfD4YNANjt2Hd0JCk0G0lCWE9qJRbOoit3KxwjaL1BLojGAlVQCmUkIm5sXJNNvyOvfwBaAeMRxEnWFK0YIF1op/W/S9gDaAf6VqDpUbLqy+u95Ch8SmzWbPnxP+Js5GTfvds6fRfVGU47RhQWkwGvfAZgoD6K+2yZqT87sVfktVwbOxX1yh0M5PQgQTXo6Li7Ob5it11QeE+Vo6gbeCeIu61+PCb7PluI6Y5oRlPcTivNNnbFjGAH0I9XkbSFe4c6jgvAqt2X+8trCjEp03oyZBzF+hmScB33YZ0uTgYktc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Feb 2026 15:14:24 +0900 you wrote:
> Now that the pp fields in net_iov have no users, remove them from
> net_iov and clean up.
> 
> Signed-off-by: Byungchul Park <byungchul@sk.com>
> ---
> The original post was:
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] netmem: remove the pp fields from net_iov
    https://git.kernel.org/netdev/net-next/c/fd6dad4e1ae2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



