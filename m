Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 179A3CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2CD6B00B3; Wed, 29 Apr 2026 23:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A806B00B5; Wed, 29 Apr 2026 23:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E816B00B6; Wed, 29 Apr 2026 23:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB996B00B3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A6801A033C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:42 +0000 (UTC)
X-FDA: 84713785044.14.0557245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70C39120002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+rUA1Ca;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irN3sUl5U/2G9ZbUNN5pT1IakeEStdX4LSvw5xKyFgU=;
	b=2rjVfh7tqjMbdTU3sujsvxZPkr1uLR/qBCNDd8qtP+mow/YjQtUqZy5L2HtL7/9OvHWGrq
	LmDBcNg2CXM+9KGVVJfFsd28Cm0m+2p+nIsFWx4XGQRVrXWaUoBv/cpXGO1Irm5//ly8Cd
	RdJZP8C5TmkWR3lI3KESaegnR39ld3o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N+rUA1Ca;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519600; a=rsa-sha256;
	cv=none;
	b=n7Huhc46+Y7lN2Wi2c3RDN+0dhmBI8RHMh5Tk/b8FjYxg70UGkW6AQ3o/Rek+rPjQUq1+k
	SK6YxXr/U/P+xpRmSMq9vh8/0o9WiUrcVHBD3MXiALLftzIQxrDLKaxhb1rnAS/QO6R2sN
	D1hLEoscuUHGCAb5osA//r7aaCoLWjQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F265B6133A;
	Thu, 30 Apr 2026 03:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35E4C2BCB8;
	Thu, 30 Apr 2026 03:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519599;
	bh=qiWsFnvghBXNIkuBScVpFgUN25eAK8sfKgLJRxbUuL4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=N+rUA1CabGjbI7N7bttoPb3GmTGr0zK5YcDinIrMTNz8LOA/nYcKYZu90HcC73Jgc
	 h5YAbBJ2SR1TwRxmrSF0vJDo+hgHIG60Wz9pF4sYooMH6rXUFQUb/ETFocmoX44g6J
	 J+auvxIiTtEkAj3I9PqMraUpRRzWvNE6cLTFP6d0QxR5tApKvXaC/eTTMP9soVVQWB
	 hi6cbt2o+eRvnVzv1g/kLMClhFpgI3gJVp3YNYredvjmXgw2jf54NktRIVKw4yE5n1
	 Gv3W8Fise08cpOmQq3Q5g8ByL3SoK9YHL072fVWI8uuLZOjjliCnaEFrAfH3pSY7dK
	 4SOxrim9gnT4A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02D1F3809A07;
	Thu, 30 Apr 2026 03:25:56 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751955479.2274119.1708184854494774643.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:54 +0000
References: <20260227193030.272078-13-kas@kernel.org>
In-Reply-To: <20260227193030.272078-13-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 70C39120002
X-Rspamd-Server: rspam06
X-Stat-Signature: 4m5o33r59xw9xa7qcqmaxw1ry88a5rob
X-HE-Tag: 1777519600-45356
X-HE-Meta: U2FsdGVkX190ZlF8Wvz8KuGJzZHt57hvp8XE9lYjROgIDQ3N/5kDrL1k2mOWQR2ZobKTSBYbwHStBUSnd0AxPm7/xK7ogXKzzFCNKV+Ma1dqrmXFHb+BBPo+zAv7lTRV5r6xAJDi3yVSXRyGJ9ZEUWn9TWuvy3S5up4ATLnkDihXEalmBO2l8XPUQwSTJmrMi95XWzifgE7EhBbw2xbZ/l8qmhZm5f8ZG8T+pZq4B+Rvq0czPIdws7ZCMF0+8RFrE5tkZv/jubZftvyjSsZxCkOQArKDeP1rzNE4/Ew5z2Dh7oZERn0iV009OjD0xtsReyA7KkiQdqPN10fjjdhKeBXzQUqDFCun+w2FPBwOxz5foYB1oLfBceFEecf0tyIhCH/YJcfOO82UzML9iCmGG+qbwcmxIaWWeQtVcE7eP1al9xpAfhFF9WAWryJTm/wwcY4EkZqbHAEG6NYOTP4QL207pkZz+AQ0IK11WTh1YXrLSfeiqA4xLRj/bKvtXdTl/6n6NyzoicEyuvlAHjZZXSto6oUzD3XE3iDo3Kpt6R2LShkIU1mn7XoY8uKnoKhqGGmSCQersHJk3kdGRMqmEU2I2z6tmX6G0O7/PZDHrI58XqxABZZ9Pq2J4AHBXcEQeUddAjEohBJwr3yPzJF7r2t3DdCu5kfYZMTASHtJOHtVIQ/Z7GseqYBpzWXXhfAs49N/G7GASZYXronnOnwurUzi8OWiawOc2nx+UiNwX8/L3YYc+TWrF1ewxuGN6sORETljeo6ZmzW5fxZcOLmA8U5mqRF24bNJEa3LnKqJ0bsUY0MZKzOR4uKOxPLGWUmKb/NotE8Zk2NQCt9kUiW2E8+3F41rB8C4VhuKTvOZ0NKr39zqh3TdXz5Oyeak84lkbmOS0LVisjNFgqwOrTh4e3QdV9wCIbOg4eAw+C2n2hPmNIMT1WITm1Spmpj2iPuGR93l42LmMO3gJzMNzqr
 mZ447YNB
 p6ospHrg2jyrRryHIkPonmsgHrXMeBMpEHZqqVahVT+Y/sapwrxYB/puh5A4Q1diradif2+qdyBiDtB4panLqwA6rZoAvpgGzSa1JtOQ/qF379lWVnwhXouxP00/6nP7GyDBuIVtRg5hhFrKN69fsFpMJcCZeTGdKg9P/5deaDJcoG1lnUF0dqVKaZPnymdKiFNbiRahmD8ngE6A9rQt7GU2d10qAMrn+vtfXo0OWCcG4ZoX5/ZhYuZFZIXaiHbEXhUDAbkpLnGwJFVnkxh6BX73XBvYCvh9dV0o/2X9sPqPVgyt5bFjWGm7iL17VjVhoq5EIX2E0N5nJF46624pdlfQ0c6Z5wYYHEIhHeO/IVtEqqrNKP+kd+B7A8UG869jDWxGXkqCzsmXdKZgfJ5Vd6kEbAmOjUYU3g1m2DZTNSJn77xUCwzQWyZvEgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:14 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> With fake head pages eliminated in the previous commit, remove the
> supporting infrastructure:
> 
>   - page_fixed_fake_head(): no longer needed to detect fake heads;
>   - page_is_fake_head(): no longer needed;
>   - page_count_writable(): no longer needed for RCU protection;
>   - RCU read_lock in page_ref_add_unless(): no longer needed;
> 
> [...]

Here is the summary with links:
  - [PATCHv7,13/18] mm: Drop fake head checks
    https://git.kernel.org/riscv/c/32c440d67e6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



