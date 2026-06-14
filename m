Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E7BCD8CA8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 23:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456F46B0005; Sun, 14 Jun 2026 19:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408046B008A; Sun, 14 Jun 2026 19:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F506B008C; Sun, 14 Jun 2026 19:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20E226B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 19:30:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C884120854
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 23:30:12 +0000 (UTC)
X-FDA: 84880113864.13.0A815C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DD56DC0002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 23:30:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkDvCDE6;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781479810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/rbjK59HUTf0wE3NhmbrJC+irGOkjOo/XNW6yQgv5do=;
	b=5Jis/lVDAJw8HI0YPBzEyl7Nww+Dny2chskk7FfUbgjthUAN8rY3i8iKlPM5KAljxAX+cN
	v/QVEwGE91sEhIvItvbBPlJh2Rbl2N4EMNTlWZ6eOu2cOEj5Xx5ScT5HJhF7TRcnYjBNQA
	kHqeNGqJ8HEz82my0cqXbCtIiEwXr9Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkDvCDE6;
	spf=pass (imf10.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781479810;
	b=omlXLBmUnVob/VvPFTxOFzgKvGiFc73Jhvy6P9BTJ7CQY1gw6YV2R8uIHdG/Elzd4CEtlw
	Yxnaq3blc8TCA2RPqiX4rZVGAcWNX9Y+HVzly2kjIR78jL3tUNXTMYdrFkzd6XO4JjyeXG
	pjYbmiqon9MOfonJOGC7FZJVACGhv+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24F4360132;
	Sun, 14 Jun 2026 23:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1241F000E9;
	Sun, 14 Jun 2026 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781479809;
	bh=/rbjK59HUTf0wE3NhmbrJC+irGOkjOo/XNW6yQgv5do=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lkDvCDE6RMD8G5/LvLDstEOtWKW3qYZnvDKAkirS3ZRQ1e4DjIJMv+wIsrCVftQu/
	 SwwQOt7+n2s8FVoYyGBqEeS/iZIdtX/oboGnZhsjS508f5JwhOciNbONguC52q8Cpi
	 TyE+T70fzf7tCLi7Q/G/sEwSJCaiCjfhKsjxSNc8pvGk4VefKGdmGVkoI6/u2sSc/z
	 +chmkkiAnRJeHB2OLlp2rtimjFLmoSiHq9JonTMlZLHviDpRx2D27jH61dQkceOwAK
	 VNpuY72kcyOXNPgItk5csB+PITWpppuyfnwe4HcV3elu7Mi3hAJVTV73AopQ9Yx975
	 NvLyIURINvuPA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BD53A566CC;
	Sun, 14 Jun 2026 23:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] arm64: mm: Remove misleading pte_none() comment
 from
 ptep_try_set()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178147980539.2349009.4002197585422309428.git-patchwork-notify@kernel.org>
Date: Sun, 14 Jun 2026 23:30:05 +0000
References: <20260614210209.2371030-1-tj@kernel.org>
In-Reply-To: <20260614210209.2371030-1-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: catalin.marinas@arm.com, will@kernel.org, ast@kernel.org,
 andrii@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
 memxor@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 rppt@kernel.org, arighi@nvidia.com, emil@etsalapatis.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: DD56DC0002
X-Stat-Signature: n5pas6xdicihgmucnqn5em5uxf7s86ks
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781479810-258263
X-HE-Meta: U2FsdGVkX1/sN8A4ibPeXZoz8zDASVHZBIRZkf2BXlTBzI1eIs5m7TvAjtTiJ7zb5L2wmbpH/kRPJfLvydK2cNTQDNVS813lF2nBU4hQ8IRkLlbHgJ5UPHRpkir6WaCpiF5mpa2e/ifyONRaz10uOXYckPWIzBv8bo1aNtEgu1IPHnwMwfkJ8ZCyDsfyhHSd6i1dfHVv2LZr9WEhZ6vhn5T14IM3wQgHQF4oJr3gZspZANvpIrUpv1Ej+T4imJ48b8r7hm858dFDXAuOjR05mDK0ph30LJHGkK2g1XmDRY0EK9FepojiR24aCxfy0HzBjrTdC4igTyH+DxWHUubTHU7ZRmM0Pb68+NUSVL5DmrUTs3/QfNaM/7j+UMMcaw7U75DjLMi6pghcnRw7PWbUiaewzo5BaC+mKXmgprub4unI+FxpOTnKJvE04mhaB2nNM3ergfq/fgXq12ssO9N5glAzBcwYFdVsrWxcVWTDwY6nxo1paB4QeZebCfbGdRTTZsTpP3KPuhYbBF2HrV87NWgYBTHgNYkeHBgnwLyU6/cFolaKQoQ4S/kJMdsGg+mLDp1JK9Ju4hMWI3kF2Gpm9no4wwk5/TvyAVRtc0KFYjHsW7P8K0BNX7sd/zig8WiZv5148vmT1qz82Y+3L1GIDo/mmVN5BDDIt5Lt0gz66b4DlVHYi2e6yvvfXh1Q9/ZPfiJCKR7mJVIW3mfiW8kDTv5QfHb0aZ+LNbzFMCi7V1RPfXqQBNIdhXrLrP4YoslDXOGBKmyjHO/gxkCHzwmTWVWNMxCxva1DhgJtVr4FPP7h/Y0azVsei7mmO3bBX5irUZEZnObnkXBtqMnhASpkcTy32UsX0fGHDSs+MlK+Yz4ClT4jTS+MDZoOEfVxBU1x9uN834W8cdB3rUbPiaFvX7JnAvp3sX+joyDWAZYtlD8uUlRbrZAmLVWPxj9UQDuOniwlj3Ykwv1XL34Fyah
 ijsFIIkR
 r46sLKYD/PV4dUNnqiAr+uTviBX9kfmUsO076pFGWAILu0D2HzCSPrvRSNzldawmbLYOu80k9WDI7phszQHC7VK44ceC6Wh6C7DwZxB1FCqTNY80l2YlaSm4kkQ4rpk78QL/HXnHdUzVn0Q4pzzQZkqsGUr2pk9bU7lkfccQ142uQjaLuqH5pZFGlQIiHUNFFllZz3zhmSbcndhoh2HdHYzNAMxXZ4gQqx7Nfp4Yh7H8TJyCM4ueNms62ft6NZ2ddj8nTx39al02dAO2V9ppPEM1Uw5Q/pGJNjoD3xGZ0CTl3gFnLhG7ovUpbd5nYged2DFjsBbaOlE4lATOF41DoF4VTT38rX9xckGZfA29owmIBrG1Uc0UdmV8LvZNSSCMlFKsqVN8uzjQw3xhedsA2fykjq8/UlIfPoI1P9A9eTHO9TPDTsUQrfYMCgTjimF0PQkZKqK/w31eMEd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Sun, 14 Jun 2026 11:02:09 -1000 you wrote:
> This comment was thoughtlessly copied from the x86 version and doesn't
> apply to arm64. Remove it.
> 
> Reported-by: Will Deacon <will@kernel.org>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - [bpf-next] arm64: mm: Remove misleading pte_none() comment from ptep_try_set()
    https://git.kernel.org/bpf/bpf-next/c/16deef8de06e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



