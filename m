Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5293C87FCA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 00:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35D9B6B0088; Sun,  3 Aug 2025 20:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E996B0089; Sun,  3 Aug 2025 20:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223E86B008A; Sun,  3 Aug 2025 20:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 122CA6B0088
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 20:21:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EA9C1A08F0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 00:21:04 +0000 (UTC)
X-FDA: 83737170048.05.EBC4C2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD5C0100003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 00:21:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bF91+p0M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754266862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=iqkU9R+KWvgh8RqrLnhYm59osjJpclSu2tVm/Sqqd1U=;
	b=SjGl3FHjhIy/vo+GxLPby+PiIvADDsWIoWQkSVaHbwQ5D7vgO94WcPLYhHdaj3qutfLnRB
	VfG+YgxOiNLlzcuvU7S+GkJTp1MQHANDqz2LttX4O/P9YDIJFSKqxzdqb45qXF503ohb45
	2bGQtTPBMix8hV7CxUPy36689h2Mx6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754266862; a=rsa-sha256;
	cv=none;
	b=lcuxlEZH41s8BSDHby/ulLj6NPLFGzLx7y/g0JvcPOMpXaXHRz/ysm19i7EFqFRBxBrvnW
	hzvLnPYUAOlC8chD/f0OvSh9btgY8F0IIbkxRsUCrwBOarWIW4xYHqQNdB6/ka1tTdJ+dJ
	OHjk8c1lGEKNK9kyKVob2/mhGVXUv7c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bF91+p0M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D091A601DE;
	Mon,  4 Aug 2025 00:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8758FC4CEEB;
	Mon,  4 Aug 2025 00:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754266861;
	bh=+GBsBj5oUsMncRZo4f/B63sXL4D/YxmZlZeMzZIItms=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=bF91+p0Mo+ZwAnP4Kv71RfDEWHtWROz4VCUZ+r9oc8g/0g7PzaRlPRZWebMV/UnCB
	 CLJg3SjYUTA/OqxNoHpEF6KvCiDizw0xAkE+BrjXkAULQfU/7epS2an9AL5PtDLOQ6
	 MbrO6BAMOaGkftTcjUcxkSjYyOfLoxR+GOMlEifJRQ3ub9dmtobyNHsGK8AB8YsTWm
	 DWgmxXg2sU8r5DRZO0xxeEElyC7WYKrA0iucBc1lCT4QiHc5wJEibaEPEhGVazH4BL
	 kOrJEgJGEivthM5eQevMyZW9T+E/eQTjEqybswBY+u8d6K1ZJoUm6GtPYExrX37lkj
	 BZyM6Grc5v6LQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 37251383BF56;
	Mon,  4 Aug 2025 00:21:17 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM udpates for 6.17-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
References: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20250803124842.f3412ea09d7396677e270ab8@linux-foundation.org>
X-PR-Tracked-Remote: https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au Thanks.
X-PR-Tracked-Commit-Id: 085dece6cc88b5c6fc6f2eca0403bfd2c5fbc7cb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e991acf1bce7a428794514cbbe216973c9c0a3c8
Message-Id: <175426687581.577274.432913297714282579.pr-tracker-bot@kernel.org>
Date: Mon, 04 Aug 2025 00:21:15 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: AD5C0100003
X-Stat-Signature: twc6dy75crzitc1h1fxzp8fw7krw4f8h
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754266862-729602
X-HE-Meta: U2FsdGVkX1/nEqZ8caPnAXEfKtF1VimwWFHNcHEk2CWanN56FHUULvE//4u52ADzPyy8APKgoH4USWc9Fk758QpbsdzXKt2EacnfS0c2hsE7g6xgNKB4vjCQqRlD1lDyPgXX+iiQbTkhP+8pw6JcrBygHcZwLzfe/PSdaeHBEmUnto8Rmx3i5FE1exUWVoOjm71pWlBFhKyPDh7x674BVZffiQifTyLF3CzT0IYugMNdVOs0XxIhQD4wnefoBRdkXYptXBp/mZ+VhEgavzLs3bjM6MVYfOnwQdnUCQD4o5aXmDFljUBF5G25s2qPP3HBK71MKcezLiN/r60e9rOEXkZ5uk6lBLtHzbK0TOzsKnA6AZcKxzd7ZGOqQxtnTiV8RGICq5ympdGR0x0hjnazy+PCdQdAXfYrAcel+tAcTHoQFxEYqhKsRRuzyAv0CbYwAKWobioEDzw/pra0B6WidAE8RgO6I56Ovlt06TOGt7ZtltSx+uvixZqTEhk7Vcpk6VVHgByiPilTQDZind88Lj6pNj/abePRB7ab/kcPV7UgtxC11e/GArpqVrUGnpQ0W3c2kOHF6WSD18elAYfW5q3yKq7jsujK/PVfUAvN05oe2seopumdl7Yt+eYv+2PNeyv5XH/Mt0eBCC4YnLkbvBlkOi/7OQHNhODJULEl1mltD/ppHLMMYEYDLuCAA/Cxo5Jj79W5TtrlwPq0E+yjq32Pzc2s8JV0W1O9Ts8QnSXpnuyFsvfJy5aZUXpFYkjsVItQAkjyXnGAIZcL+mQU1LJEV8Hsd0Xnb2DtRyrHALkK5XB4Ksw2DzoMpPqOaiqtXkb3AusUIhIgo4k9ZoIhD8vpxe/jYtOMvVm64O2CNzA6yNKfWgukZgZ/ROzsAv030ci82EYWNz9zIzX+h3uJ98r+ahwQFnPWXOEFtnyYHl4phDzxap/pKkk6P6IgpjoyEEXXGGHGPEoxgE0F/+J
 W35GeMNM
 3/O7w9fxWtallfoWx+/TaEJ0pNW/vesq13FCSvp+4ot0Y98T+g34u1pTTYQTEgelUKb40ggeza0O06yvR3QNFPcYpg70JRBh45yb0Z3tlh1UQpUIQ9YJwpk08+yqx+/Wfx6LS/gd2iLFb1aGU6tVRgzylb4JsDBjNZj2i2MERRefhbAshX/848cN1epDZwL7sAo5lNmHu86Ra7kzl+gVkgwjKRZHg2YQXfwYLL2cI1Hj61+bmty98wCoEPauGb+Jbdl3v7VLMD0suhvvf9cgp9heKQl1ntOwqnV2TFl+pvQRr5uIto+gQfg3zcXI34CwyiyDsggqr9h4/8UE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 3 Aug 2025 12:48:42 -0700:

> https://lkml.kernel.org/r/20250729104245.6be6957a@canb.auug.org.au Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e991acf1bce7a428794514cbbe216973c9c0a3c8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

