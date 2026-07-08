Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEDC0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A256B009F; Wed,  8 Jul 2026 04:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDAE6B00A6; Wed,  8 Jul 2026 04:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2006B00A7; Wed,  8 Jul 2026 04:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE106B009F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:50:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EAA590F6F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:50:35 +0000 (UTC)
X-FDA: 84964988430.18.F28E9CA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 749CEC0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:50:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=el5z+yeQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783500633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y76FFC23c7SAB1YbYSOwuwTdxocIu4x8oXq50/TkRl4=;
	b=EJBcIefyJgHqpLCtrHFzU2MxKwebiZIG4hvUYwbYdI0rVjGa++Ju3L4B4HcX4yqTygNf5l
	UYI0QFpDaI4TnQrVxJXkQgpsQfy7IlJ8A5u8MI5YvZHoH/QLmnCi/eLl/zeFa8rNfIG6b+
	pUWbBMC8wcsYBIRJ3UxqkJMv/P8SX18=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=el5z+yeQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783500633;
	b=wnL4APNfJ9fGM1jscP4bDIbaHNIFbRwSM19vsh0n/oSj/PI5rfj/7UZxje3aoF9mBHEqZU
	LJkEAneFQqN2caj8dRt6TFlcUuYVqfk4JlgnGAMc07RFNkJhlQ/iBjbFaCTUYL8y08+2Tb
	+jVYUTUZEt5aIYLeb/pxvqIF49HcKRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA2E660008;
	Wed,  8 Jul 2026 08:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA1B1F000E9;
	Wed,  8 Jul 2026 08:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783500632;
	bh=y76FFC23c7SAB1YbYSOwuwTdxocIu4x8oXq50/TkRl4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=el5z+yeQ9R5b4pp1+Im//k9FzR8zywA+1wiGpWt8kl2AjuJ5Cj8EWJNS6OZnncL6K
	 xOJdLLhilJz/HreFUjspTnU7HxY8VafhUrZsN0fKl5oXIGlRi3n4zMhlvcliPEi8u9
	 +VnvA//bTpemuC6ZcM/Pgc3G95d830tn75dTCKvfp0TcVPO9Dq+Oz42wSBfC9P3RoO
	 gbUHt4tf4MU1j2ivBJDXOCT6Ps3jvi9tjj/CcOKc/X3H7dO7vNRWcLOTkkLo5+KNYC
	 m0+XjW0wy2R2mQEGyNg2z72O71XnBzMUDWD2wpGXEedaewdLJEfho7oX1OxPS0E1hj
	 8y2x8D29o401A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198BD3926389;
	Wed,  8 Jul 2026 08:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/4] drivers/net/ethernet: replace __get_free_pages() with
 kmalloc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178350061164.2381125.12226069469974368415.git-patchwork-notify@kernel.org>
Date: Wed, 08 Jul 2026 08:50:11 +0000
References: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
In-Reply-To: <20260701-b4-drivers-ethernet-v1-0-58776615db6e@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, manishc@marvell.com, pabeni@redhat.com,
 ecree.xilinx@gmail.com, przemyslaw.kitszel@intel.com, skalluru@marvell.com,
 anthony.l.nguyen@intel.com, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-net-drivers@amd.com,
 netdev@vger.kernel.org
X-Rspamd-Queue-Id: 749CEC0007
X-Stat-Signature: nag8hk3gx19ybngjrxtorhyk4pas4je5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783500633-362529
X-HE-Meta: U2FsdGVkX1+lf3MbFV/ZP7gKyLqi0yD7CCDoAGBipq4piOYzDQHgPk2+0+utB5o0o7HlhW6fBvlWzCeGCCS5gl2wKwadGGWTbE3KUnpbsyyzjYuvR+SmkmXtBm6uGL2RPlGN87ALylEGjTBbZ6qOcyUOetAtpawoMVw9r4aHLXoNeAK17kzj/FKJuRkyLsjh7yyfifpWvQ0zq25L3RKesl2ANuXOvLcPSaAxVdANYmBz9W0aJ9Dqt378E1Lkzvcicrpw52K/rdwVPxYDh2Qa/qckJ3Q+WziPPyL1IZ4yUNOVjHc/ae6fLZQWvG4odlpZ1TNkXgVjyh+PThWCnil5Kw1BokVdWqxt0X2Vaqm4hdy2XO1mLBJjVfmrCZl4QlmX9tg+lbOj6BjGFoorMwFb+eRrg+d85EHfCynEJiq1sXW3ahTVFWwKyR9m78G4fOVkAZm7HXoZ2LgpDVcnb4Hxi11Xff2sb+Sjt8T7zVufkU370gmMhdyvH2VLhq5A3E3+5QVipsqMBqQNJALIrv3EiyxBZUX10V7Uf9s74BHGYn/9HtJo9w+vrFqdwLMn7Q5Bdvxg2xj7HvlicrjQSZ5YAtjL4VZBTpPe3D8j7KDxAL7M7bo99HGuEeolZHjyD62wuS4oModit+1i7sZpx50LLDJtryWnK1V3bGdGimM+wZwTb9a+DEw7xLv7SmaZinHAV9IN/CG8NPSNgOgB9wkDA2MJgnaIHf5xn8MQ38U7qKXXUBiJYi0XgxUNWVubtS/UiZ+T2y1Itnlc67eGRuyyL8AHddn9LwhyVreIp8Trqtn5Ro4Ft1QSC79xU5PIRPY+0U4i+3rqktxp1jM5AYZECkYNsMRhJ23WCNH8I9qfGAEFfMvClpPyxi31u0mzlrpvrtcQWiF5xFAQ2V5th6WmfM2AdGYFE0u26QTsNmDXrtr+MBxkZQX1WJMkKCrsmu4DO5hWOuDHzM0YkotJvSR
 UmoER/Pt
 R34hUO4tHLTLBgnGd8Sqt1JYKZOyFSTDVpq9LR5hd32m7GddSgttKQPZccnao+fL3rwDAmrLLcCZOddYnn/PUDBZfwzG+jzhtpAH9vvWKa6dIx5zExDclncrYq72O/vuBtpKf2vRhXmQ6hYD6aMroo3/4ANZubl4qaPru4jcVmGFgPx6lmu1+nfgZBCpXTYnbDfsnX6e0ZPKa/LCVifPoZJP3/8VALxmCj4J49XbZa35MqbEx48xdOHsrBvvLMLuLOjD/33t3LRCChtNmCaBPNqfBlY8TklwDLdkcdRP5s71x/U3OeD2qKrqDwuptC1DDc9r11lOBVZnKMqFEdcI2sFS1gLMICzwxsnL2OfvLyVe5/O7BInTftNNeLMfToG2tZ88EyzXN9i6arcEpPWaDlm14LOyDmgIi+6pqFyHh42j0UYmbWb9RaPrLUZw+VsLya1sWMn/dS60BfdDbqS7jcugcM/Z+0FHWOaWy/T0J1sHoWO/Nz0XudJfoID96DkKGeXO8f4kM44LmXfJKIlmEwiKwGZBAFN3k0dlwqdhmmJtMkNpeiKOWJ4SU1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 01 Jul 2026 16:57:17 +0300 you wrote:
> This is a (small) part of larger work of replacing page allocator calls
> with kmalloc.
> 
> My initial intention a few month ago was to remove ugly casts [1], but then
> willy pointed out that Linus objected to something like this [2] and it
> looks like more than a decade old technical debt.
> 
> [...]

Here is the summary with links:
  - [1/4] bnx2x: use kzalloc() to allocate mac filtering list
    https://git.kernel.org/netdev/net-next/c/28a236c54c9a
  - [2/4] ice: use kzalloc() to allocate staging buffer for reading from GNSS
    https://git.kernel.org/netdev/net-next/c/764f2a0c6d1e
  - [3/4] sfc/siena: use kmalloc() to allocate logging buffer
    https://git.kernel.org/netdev/net-next/c/50bfc5eac4cb
  - [4/4] sfc: use kmalloc() to allocate logging buffer
    https://git.kernel.org/netdev/net-next/c/e8cfc70720ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



