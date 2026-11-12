Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02421606A8B5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 02:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CQPzrCau
Received: by kanga.kvack.org (Postfix)
	id 888216B05B1; Wed, 11 Nov 2026 21:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811BC6B05B2; Wed, 11 Nov 2026 21:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8BB6B05B3; Wed, 11 Nov 2026 21:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4D06B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:00:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BB4AC03FF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:00:10 +0000 (UTC)
X-FDA: 85424811780.14.EA9B777
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C5487A0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:00:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQPzrCau;
	spf=pass (imf25.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794448808;
	b=silKQWcUOUEezkPmdm5bsYCZRCseQM4DkaS9A9GbaoEScKXoO5cRMgMip69DpeAIjNQ0w6
	f03BoWy0MduUTykBgRgskv0+O+JpkMSODTyyc2qD1YF+kAJO0xekWsLoXweTh+1tXv8OML
	5aaTmwP/5A+NjZvTPizKvcuHxTW4D04=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQPzrCau;
	spf=pass (imf25.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794448808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCRfyxHtM7gWIieAFsQRUzzBSJgM17kQTHPB2Hu1iOs=;
	b=Hn8544cBZ8DAjlBL2aGS9tLXkHwnVwR6O1skUzZj7WsHFFU6VCbg6X2nkicBar2nbSGm9W
	G2iTbIIDP8Z3dmbcSzhZif3HPWaBEL7UarNU1liiGw0jx+qVuC/it88P7xrL8fcJxcDSK5
	HigvqJM8shJrcKVnSr3roMKrb5OgkmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4866963A22;
	Thu, 12 Nov 2026 02:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67C91F00A05;
	Thu, 12 Nov 2026 02:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794448808;
	bh=TCRfyxHtM7gWIieAFsQRUzzBSJgM17kQTHPB2Hu1iOs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=CQPzrCauYk1gS86uv74QwbX+ugone0X6LWe7bEpPNMoRJeKKt3NhJUtZLLwOs+fN3
	 NdEuynPzBwssC17dv6rQpBaYyvxfL0MknHWoGmsZlbi1GILHtsiK9dsioXxUTzISQi
	 JQbgSPIK7pftO9sxaakiMITlhaqPpW4rxO/tm5HKgmPRlzW6tGPTHb2ciEURHPPODm
	 0Fwml7Ek/hCFcEub4NjxF8jea1V+WnEdyNnNPTg9Kd7uo+Ai7wvlzylFfb8JsKAHTA
	 bHnmjI5NJRvXW3kN902T9w0VMzZRIN6VhrLB5hzI+2SYo/a93UIz/Qfh9oUpSM4Icw
	 L2YF71zXcoOEw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D81E1391AFD2;
	Thu, 12 Nov 2026 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ptp: ocp: replace __get_free_page() with
 kmalloc()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179444880643.1768068.10714270723125429493.git-patchwork-notify@kernel.org>
Date: Thu, 12 Nov 2026 02:00:06 +0000
References: <20261108-b4-ptp-v1-1-71160700886f@kernel.org>
In-Reply-To: <20261108-b4-ptp-v1-1-71160700886f@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: vadim.fedorenko@linux.dev, richardcochran@gmail.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, david@kernel.org, vbabka@kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5487A0003
X-Stat-Signature: s4gx1643j4797typxc8hrctmup481k1m
X-Rspam-User: 
X-HE-Tag: 1794448808-489262
X-HE-Meta: U2FsdGVkX18KgAeBVOSmS2rGzle/i1h38388r04Qsi3fPYS7khrr+ZijiedhBztrQvmqKPSHd3AnbQQ9Fvchx+qmQEqaqxQXy6olvwu1jTrsTxS41jd5zEt4nF+qDDAseJnd8QhPS+jzJ8Kdd1G6y/0L5IH7fj5sRfqstasD5Lq0ZiWgQgAK413XfyH/AhZyDJlME2XbtInADjod3y42vPlAEWdp3H+Hltsq8KWPGmFz+6QlftcVBIw9jTU7OLFGcnRh11IZWcXlLdcAjQqyjQkC6nYaxoYdGLpgOMTCRwrGZqiiflEG2v1GK4kfNbGRGiAevw5pRUEd9q0HkhqYHPczxZN5OZfny4QC+klpQYBTagyw6SvWPFZsBpyyM7yvGCC7TyzkhDSa4HtK/yAOKimOmJ0XGsg4TWAPepLGy3Xks0eu1drediqY8W1frzNmVSRE5uWddrC0sh//hGXCZAlZXtBCiFBirsY742dhjyHISOwbmUGVDnUVIBbGzn5Ay12QJTdzFuq0ZIi9TcSBB0DxrursiWQsZISc2i1yJBaRfo2hxLIHxtf28J2Q5i1Wbv6ta3dtJO+THtJbUqsq5E34erwyoFDAGak0d7xdU9FJhOwiQPASISPYgHXvWSR3+m0S2OkAV/s0vPv6W6iNeHu7XIx4wZDdBUQoMBdhMVeQUQdZsGTTq/VppkphP0VsAHyRBiYLkPs/VlyBIGXOXIdgXI2D8fSpj/5uo3n2p8FWiwWPzLpvlySdwfd2AITv3fhzw3y0P+B8ggL5QxMLCTQR0L1zEAUDvBLHvN2WRkaKR9sQ6QY7lQHGkV3qo9pyY8+L/hL3p21A/PrD6bC/jGMqPxdKckjGLywyi3iRbu9c/CGHnk/NjPW7/rdB01AfyFgL2ZC4BgP0vp48DmN1DnBgFEvIyIvQnDFUfUobTkGciXKjwi1tA2ADflOu5hS6Vryl9hi/6yp74XbRrRe
 jgaUOS6m
 e0oSZW4RHdTfgL6nwdnjNAabryKK88eytIw7iMmN90MMM+ZLzk21rExXc6T0vW1fTSBEydWofWUfU0g1QB7RXxVcrFFGNpS4iVMBi6Zi8xkRhPHLseJfIYYQoEH0H4XmVMPf1Mz7tkEs7cys5scy7yOYvjAzMAdcWqUKTvOIVZwVBPAhijbm4DvsFzJCse68bd+9n6Ho0Um6zSkFm0KyItzXzVRHlr6m2qDnFA79t3Ht4xT4UKkZjcaBzQwy+/cfDyN0Yr6IJEhD8caVoDXnEB8Z2U2UxAg4JNRmTJVahD0O3ijWRrUU7aOrWOVVSDbgGJtgrEmdyF2GvneBeJvkL6IgzTSIFlVyrMN67L8IQlR8QF2/8MXI12XdQ34dbhs+Uw0uaHDg3aTRJmVbmt98/KJocHNDl640hELzYuKoQatOzxqmQoqVEC6S9rCcRXDuu3J5AeG7sPO0VNT5hJYCwSjCP+WunfMiaQb6hs0LiK9ZeyeULxGeeXwFBC/x05Mumct/ZdRjLzZaTXJ4fZn7uJ5Ncu4XMMZr9FQmf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 08 Nov 2026 10:40:36 +0200 you wrote:
> ptp_ocp_summary_show() allocates a temporary buffer for formatting
> PTP OCP device summary information.
> 
> This buffer can be allocated with kmalloc() as there's nothing special
> about it to go directly to the page allocator.
> 
> kmalloc() provides a better API that does not require ugly casts and
> kfree() does not need to know the size of the freed object.
> 
> [...]

Here is the summary with links:
  - [net-next] ptp: ocp: replace __get_free_page() with kmalloc()
    https://git.kernel.org/netdev/net-next/c/c88fd6989aea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



