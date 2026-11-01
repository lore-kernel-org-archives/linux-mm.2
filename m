Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3956073504
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 22:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6nTVfdH
Received: by kanga.kvack.org (Postfix)
	id 960346B05BA; Sun,  1 Nov 2026 17:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910AC6B05BB; Sun,  1 Nov 2026 17:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E776B05BC; Sun,  1 Nov 2026 17:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DBFC6B05BA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 950EA140A9A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:58 +0000 (UTC)
X-FDA: 85387961316.15.EEA102B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 06ECF160002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:16:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6nTVfdH;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793571417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmHoPhac8xdzo93RJmgS5fUm3Pc0rWkwSmth62nTPqo=;
	b=yAE+d+DYEaIzi4Y8E7ebRpgsqQNLXX4gZKo7GiRvdygWxKWcOZGKzF7M8+5EiG2W9PWjJR
	QkeaVSxWOD4W3ss1ycOFSEW/EjomgSwyc52DiwC/3I0f5V83iyHYY351zELZPGxr/uqNhJ
	rwi23Dl0uya3/43+VLpgUkOmsE5/V5o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6nTVfdH;
	spf=pass (imf08.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793571417;
	b=SSGBeU1XrckwnYnQYKAgUGSY0j4NEuVVSAla/Fbp+yGvQHVpRNZhTuAgroyswMwWjhssIP
	j7n55wEbcJdDGg1PvD7/r/Z2yJgU6VfEz7fZrAhBrqo/qeZnIWz/kjdU1G4kLR5DfODdQ0
	KdLvHXmHyyUWMbuBxzY1OxcZQJnFgDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95744605D0;
	Sun,  1 Nov 2026 22:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2621F000C1;
	Sun,  1 Nov 2026 22:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793571416;
	bh=gmHoPhac8xdzo93RJmgS5fUm3Pc0rWkwSmth62nTPqo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=N6nTVfdHt7MVhFuXciAxURK0MJ2kI9qDi9HMYYd5jGX4G9Jm8Bg3ANfJkThMy1oXu
	 ZOS0MJoKf+NZYrRifICZK4JbYJKfSjtTWM2uzNWhta5GHaIW3Frqnq+ZKpjjujnOVP
	 QPCsQm/I79caUKsvjHGTBZx7K6VX9iAYPPRFGk0HsRRYu9Vj+Oyg0XwMoJclp8Qauz
	 ZDM7s/DSEeF6wJ9wTTSEvO/iXLh3UGzjQET8W+96a2+jl4HqUqwqgHRmdAbO6mBHKF
	 MKuLE0Umzge+n/nxtFwnx10gepJ/IdxUYc/qA3zMssLCR6fuzFe+eiaevGu9MP/10s
	 c4o6nYNmjvXrQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 4014D38003B8;
	Sun,  1 Nov 2026 22:16:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH] mm/page_table_check: add explicit pmd_none check
 in
 pte_clear_range
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <179357141484.2624073.1401864471103431291.git-patchwork-notify@kernel.org>
Date: Sun, 01 Nov 2026 22:16:54 +0000
References: <20260819025516.2967199-1-ye.liu@linux.dev>
In-Reply-To: <20260819025516.2967199-1-ye.liu@linux.dev>
To: Ye Liu <ye.liu@linux.dev>
Cc: linux-riscv@lists.infradead.org, pasha.tatashin@soleen.com,
 akpm@linux-foundation.org, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, liuye@kylinos.cn, alex@ghiti.fr, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06ECF160002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: waqy64mfhxirhzdafxta94cdusdb69du
X-HE-Tag: 1793571416-977539
X-HE-Meta: U2FsdGVkX18HxwkfYOLNA5ucQ4qFmyox6GW+DpgOgXs8n0jVaTjB9jEej3kcB0LCUZOPeRPJyYZ1QS06MzJqV6g0EGfLywSQRqd2WfWpLyp6E6zEwYbztLo8Z5LBZhOZ7EgSSxWV1ee8LyZTZf3An+CWhD39OS/iAs8qADaf5iv4S8teP85hktf2j0c1WzqzWqoZAjbuPvkXe6KfeycBKhhXeT0A0gMIcbKQFvWJrry2NtaB95/4fAGUuViu1nAeavUHhWBg7pMPGSNbknAc3Kd79U4gvZCowCncAk8N1crguMORffqGzyClsyK6LHXoTGc5Zw4+nW3duB/sG6UK7Q4u6ONAKw+QV5qjwGAi3HxA1bpOn/fgTlryroiz98qO1QqV/mkkh7hoimfNulsP3nSKhkosDMGktJ4ijKWcJFALT0veiiUB5cusph6jn1HWvvMmT8eCFF/WJDD6TKi1ZWmk74JTGiO/kPj2Aig+X2nmJAM5gWcUoCWestjF5hujPt1XNZlWmnTw/GXJoCn8bcM/PMZ8JP3wMPxDNJVTyrnKZknoHoJtqBE9OoJenOjZg/UW35S9lCn43lLXSXS6g7GM5V5lQ7XwYYW0qVg35dqvH4W5ytMn/IIG7oK8QHAg/Wz8fh8BAha2lAEcsAYksdjIV/+KaVBLc3xGoqRLF37XBgPLgXRKH0vAVQ/pi/1GT3e1GBqT0mfZ35xsP8het3w1fBz1k1GKwsZcdgMt4J+eiSuVV16XZTDsKMafOWicc13ZGvS2F/r2RzVYH4ac/DawCU0xQH0hVsNGksHr9viiL3Vz/oblDGtM8T5XM+tHEg2ZrvoEGWQUG6JHJmqnITajJIwFcsSxoOOAyNCKcdU30YDnVKgUjxECg0F6zBVFlBwjQrcYEDBRIIYFKJh32I6E71FEqFf0Hgkb1ZsmOILjdWsIZ/WMq7/ymszWJ6TVMDJc8uL8+WDBZpAL5Ba
 eOTB5zPO
 pGkz+SEIFayvbvHSwUnuMpSxfI+eCwvSBT+EvBRhKlcYEGnj8WiqLmh2DTxIDWK3LflWJd/aqQHq4olT8Y3jtk/x5cfynbH8vjx751+jDBwCbQodWP2KVjIe9PJbLSAHXqJbUNHs2jtoPm6m5NJGaibV95ECfISCAWCjGc6d+Job94OG388MuWaqySYqfTvq+lIGuVXCO26cBkXMnQw/VnvULYZwdLWwaj4tKey79we529+hXEvSN3oquDQun8vY4EzowSzjT5whH1WMHxKLKznvrusIIQTrf9DKiMXuMwZiFHGJXEDI/iPOUNKZUAyUlBzdAwoury4p4vaW3ScdZjimj/LGeoylUwONALZijYpiUO3qdoZXe28RDOPOVJB7KDtUaailWlQfWG+Q2u+NfW9sAMJySNJT1CachoPOacIs/sEUDpSTuzvBYse2oPPijz6C/XF/ioxQ5mn/kyU8upaINZ6d5wrB5dTCO8dMpLA2+n9qyG3Xhhd5kJG0dmqM0K4nE1TP9l6uR9j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Wed, 19 Aug 2026 10:55:15 +0800 you wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> In __page_table_check_pte_clear_range(), the condition to determine
> whether to iterate over PTEs only checked pmd_bad() and pmd_leaf().
> This relies on the implicit assumption that pmd_none() is always a
> subset of pmd_bad() on all architectures supporting PAGE_TABLE_CHECK.
> 
> [...]

Here is the summary with links:
  - [RESEND] mm/page_table_check: add explicit pmd_none check in pte_clear_range
    https://git.kernel.org/riscv/c/0224133dba05

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



