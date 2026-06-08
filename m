Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460CECD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00636B0088; Mon,  8 Jun 2026 08:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD7596B008A; Mon,  8 Jun 2026 08:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14446B008C; Mon,  8 Jun 2026 08:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93E5C6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:00:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 45BE1164D9A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:00:15 +0000 (UTC)
X-FDA: 84856602390.15.C29E66F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79C24100009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:00:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VbshWzMb;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780920013;
	b=JO05N88rjoBN/qFHgImUKXfdtLPJ0gWlmwONQlHygsdter9UJN0EFIZaERSsbT+0RP4TR9
	uRBBxYC9l/AWlyOiaL5WFM7k07CPrQhdT+uLdRfyWGokoYw+p19L1EKLDmK2RWHlbAi+RA
	4fhUEqgU40gtd1mdj+kHygqkOhGaSR4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VbshWzMb;
	spf=pass (imf05.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780920013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQAir/XhNgzln0FRrf8cgFa/spk0WCi7bswkv8ztqtM=;
	b=qwqTjsQJcieQLl37gH2boAUFc3ENYKf584srVBnQx0+Uq4wN0xYg0okWMV4UnrOLlXn7zY
	I9FwPPByirLmUeSji+y9pL8N3KwxkLvx2HFF4i/4fzuNX/cJNMzdqwSg8ERw6/hR7wTenT
	oepbJajX/AHs/wVeBrBFsM4Z+Aw3h70=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BB5BA600AE;
	Mon,  8 Jun 2026 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5A11F00893;
	Mon,  8 Jun 2026 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780920012;
	bh=AQAir/XhNgzln0FRrf8cgFa/spk0WCi7bswkv8ztqtM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=VbshWzMbj8MuZE3fQBjIspMvk6Z4L2Uwp7JKBQDi7zG7PNGbjZK3FOiOyMtngTPId
	 CkklEcZg91CINj0HiWVC9Gfc80+yDZibAE9nBvMPSJTfxTDEKqHrb0lb9w8/An9BC3
	 9Xl+UnrxOrfGTQCSmcitJ3pVQ+6LKwQMJfY9ZcsX0XNPtKpQEkuSgjGS1npPm8Yabj
	 zZCHUyW7t0Cx/M5eZPzlXgSExpuE5ueuuJ4zMNjja8Xlq35MjDAuiHyJtDoilmbwy8
	 gC7j2SZOAcubRcT42zNoLs8sKFkCNY8v/D8sxnqGqf1kS1gPjGB+j6ydvtKLiE/0tK
	 p8dcPzmqCGdgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 938DC3930D69;
	Mon,  8 Jun 2026 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] arm64: mm: Complete the PTE store in
 ptep_try_set()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178092001114.1007295.14338085080112012433.git-patchwork-notify@kernel.org>
Date: Mon, 08 Jun 2026 12:00:11 +0000
References: <7f5f7c94601312c1a401fb18998291cc@kernel.org>
In-Reply-To: <7f5f7c94601312c1a401fb18998291cc@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, ast@kernel.org,
 david@kernel.org, arighi@nvidia.com, memxor@gmail.com,
 akpm@linux-foundation.org, rppt@kernel.org, andrii@kernel.org,
 daniel@iogearbox.net, martin.lau@linux.dev, eddyz87@gmail.com,
 yonghong.song@linux.dev, emil@etsalapatis.com, void@manifault.com,
 changwoo@igalia.com, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79C24100009
X-Rspam-User: 
X-Stat-Signature: kt1tyyj98718uu7dgea6tkqhn3axqotk
X-HE-Tag: 1780920013-886516
X-HE-Meta: U2FsdGVkX1++xDvlM4GQ+TlYEQze6zOpOZh1Q0+DQzAzt5PCLPOhap5LiLWp7kNc8vxeLSbxb8X2tHG7FNZhMyjZsUk1VIEwyz6r1Jx4XF1eFFA5XyZbLBLeo8K8PBDFfrCFSFSil+YGcZmVe/3TwUCWJeRU1Zm3VhJKUA3Yrii8xWj9djBT7jSOdJ5sIH15jMLUecM2LSKzYeytnRGZYgMzucJxZ51Bbku2pIZHzysd6fBOJ5Y5ev9blJtmN9ELbagU2cXho214+Os3yZKXnBkkEDHYLYO9F3GZJ9VghcEsL/DjFPbqD+rYIaepNh+xfXe00h3yG7UEo+EIo27NUKKatpmVtbDx1FHRxaE8Vq7v5XCqcB7TfKhacrEw8DhkqVx3hvAETMaiQLhXhKzWhmxwICW7TfKWMB6wky5dLL8HIiF5ZrHxww8EFEHqwTsmqzP7zlk4ColGzr96V3wfN7R11j9u7ClZkxHaVeAMeREMdadYcQ1OBaxCslxxnL+WDmwgx7kZq1KrVOc9L+epBSMqDoQn33LK+DZwf6YSqbIN1z/wb2zlzPEVsA7qLyIjBlAbLg0xz6yWRD2dcPuTsy7+hPrlYWkJUuqtD0x5JgSbYZAlDn+rGrv6WXIJGiQCbJIDfluM24ut0H35n3pYwmDFFdsc5toK9kdKcdmy0NDLLrixEJo/fCLVmt21kU1SQR5ojAiKBHY1Fa4hswTFfCf+lIkzBKNNTSG737vMk1yuWDYcN7NZudIrZGWSng8LQonBMG/tgVBtwpGe1iGsJ4bxi5GSBX6eamx4FtLT3F8JqJH7JKj041sFeXjKLR3wD2H9jMsBYORvoXFRJFfuyhkeeU1S6XYI+s6Fh5ydWEaAXoMfh90c2vbLo6sNCmKzBwJctCpE+Q07Ewgqe7dItXKmw70bdvvPvvSm//rTlGJSBWfJofqDOksj8KbcIv37BL1Ka5BgI95vGyT+6gP
 qHrw+hgm
 JoWFqJ1169k6hBPYLLk/cR9Nn71aG14A+aNeRIBSkB6Il4+d/+qLEKeQpYiC/ikhsP26vVFXHJUBm0oJO3b83fK6arCNJgeB5qOsV0NqbZmpZHhjDTf54Pq2O9gKmdxCYwf0EZ0ydCCXgC1FWB/2UnT9nzlK2LdWkuC2hoBiRlmxHfVS1ldHby3V64CTWx+tO9h6dr+t/KT0+voqBOJgOXvfKBYUQsEWWU613yDIK/H6e16d5eYZ0Qlg/VbGI5Wtpqv4K5/gfVvY40El5L/SbNQ6GSTfTSi0Rx+LHgfGiKaJQODIWGrg5oiY/l9yujPfHE12jJlfWkw9axSt0S8mVB/mQyWIN5U+Jb72kEUTQCSYwnl/bou8IF3+mtMdxeTC2l2iMdqLkzHDGolgeJt8x+szprPw1JQoM/2aFYx/YUrnFds50adW758OgrubZDI4L4U7GNttrPluP/Y8IXxkjJ1DTj2mTDB5sTFAY7ZFeix38UVFNWJctWF28qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Kumar Kartikeya Dwivedi <memxor@gmail.com>:

On Sun, 07 Jun 2026 21:25:47 -1000 you wrote:
> ptep_try_set() installs a kernel PTE with try_cmpxchg() but, unlike
> __set_pte(), skips the barriers that arm64 requires after writing a valid
> kernel PTE. Without them a subsequent access can fault instead of seeing
> the new mapping.
> 
> Issue them with emit_pte_barriers() rather than __set_pte_complete().
> ptep_try_set() must finish the store before it returns, but
> __set_pte_complete() would defer the barriers when the calling context is in
> lazy MMU mode.
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] arm64: mm: Complete the PTE store in ptep_try_set()
    https://git.kernel.org/bpf/bpf-next/c/71385b78dbc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



