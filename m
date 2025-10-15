Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6B46CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 10:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8358E0012; Wed, 15 Oct 2025 06:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAF3C8E0002; Wed, 15 Oct 2025 06:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC568E0012; Wed, 15 Oct 2025 06:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC2F68E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:31:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FE5AC0577
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:31:28 +0000 (UTC)
X-FDA: 83999981856.08.41248CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 88E2F2000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:31:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMYDJoas;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760524286; a=rsa-sha256;
	cv=none;
	b=4N326ka1q5BVEUkFFVZnzyDx25jF06ndhirBYoQ01zVxPM8m1ORUVbM1EOqCLjavkp+9Vi
	HM9JEBcEKXWJyqaURqKEpc3xMdqd/8uEcWQjiLWwdTGEPVYCea7pgDT2YGUQaB/toq/Gff
	sdNequItoLwRFtD+KzHrHJb+l9IREtY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gMYDJoas;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760524286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hd7n/ogHjt8UuKgnsY6RQ8ZuHV5+fvy11N+hA57sL9g=;
	b=UHtSTNkY8EiBM937hj5yz690mK6nY/FUI+uU1RQETsfW7R200eMHqmNytl2/7Lf/rMgTVC
	Ick/yzYJTwE1GO5xV9H/byy2svt0Knh5JiMJ6hijsWsDGrkMxu07/MfdLe042haoJ49hUt
	x49BsSf17Bix49m5J8omZTWXnZalHZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D84D63C5C;
	Wed, 15 Oct 2025 10:31:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BA9C4CEF8;
	Wed, 15 Oct 2025 10:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760524285;
	bh=1n+bUnxTbBE8EknqcnxMtqsgtSOAIFCgs/K/zO4CNUo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gMYDJoasKXL641lJV252CoiQMlV0VXd+PyD2mGkm8s1VtldzzSQ7wvKM7H5Z56f1C
	 1spl9dRmpoJNyVdm6c2e1IHhtWUOcCb5vSL+m6vw2OOSaf5UsB09OZ2M2tEsZ1SDTQ
	 evHr+DUegmE2FWgtBGh8CyD+/3gebei2z31DuO+2+tYyjiQRdSn9USRjga5do/Xy5n
	 UHKGsgjc6S/QZf3ZL5IpXxaqPI46SnflsWlXaZlV/AftP8izua555ToGFkzYhIOuov
	 QISHsMebADcRebGxZou/J+YQChJv/menrjqL9GkFh1y99AUGA6DIxoroVW3MP8t+Cv
	 tUOuJLZyha9zw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 6ECAD380CFDE;
	Wed, 15 Oct 2025 10:31:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf] bpf: Replace bpf_map_kmalloc_node() with
 kmalloc_nolock() to allocate bpf_async_cb structures.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176052427024.282100.959584197933795259.git-patchwork-notify@kernel.org>
Date: Wed, 15 Oct 2025 10:31:10 +0000
References: <20251015000700.28988-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20251015000700.28988-1-alexei.starovoitov@gmail.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@kernel.org, shakeel.butt@linux.dev, vbabka@suse.cz,
 harry.yoo@oracle.com, yepeilin@google.com, linux-mm@kvack.org,
 kernel-team@fb.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 88E2F2000A
X-Stat-Signature: 3cunyhyqufe4yeujdtjqqq3zxnjkuidw
X-HE-Tag: 1760524286-959894
X-HE-Meta: U2FsdGVkX19K0xXSxuCwQSDHof/9wM10DhkqTvQ1NozdC6HorZyma9iGiNzIZ8UxWa+0a1UBq1r6+pEBnSg3N32qOBg/PIMaWBVgwWr3RDAmsc7TbjrUxcHZRD1SxLUm6ph3x4bxm3JxRvkGH3RC9Dn0PYhXPsReTNsiXOsrHo6GAlCkInC6r9S33yte4OhTJEfbWEg+sUbCMoetzxGisUfNIcyQI0EVq+ijWNsSEf9M2krnm48dqUK8GGWB3httd+7DDMZe572pgpYpcSNJ+b46RFfFvC4AFH0Dqik0Ofq+s2b/F11FBcWoKFPrNwV5VKo7A1Hl0RB4ozz2/BJSm0oGotVgD+C8QUb8PbMe1QPv62dCtsCtUYOqIbbbE6pYnekNFz/aVpi42JGQF0XeaIXaLzysSPTPqaS6p5mB/bcw9fDn3w6KVOr2GQ8xo/qO5WxzEl8Eujzv/iWu8hJq1SaTwi3wAYTU2/ek7cgPf1YmhSn5/L6zYCaTM9ERf8NG1p3jK9nX56hcw0BFm1GyaU8E8E4djAd9MA8Nd8I4Y6ZB8gaR6OUUdCuWr/5BjjBmH+zJaNx+rMFeNFryMdzvgLx9RHK38exvXqmFIljNe86iXfr+kxDDJpKZVTX4QWxsxWZN6XERJ9SuC5J7laqiG0bYgzsq3wiEVMPPR8LJnn/qCVMM2mQ1Mhgm3nG1SRVNZ15hq37IkPdExKa0Jlla3CydfXJ35pvm2e3KktQeo0aakzDXts1L03ESscYjk6ip5QNU+p1XoAQ01m12Jx7UK18OQfoSOHAZD1Gb3t2u3A/XIHgqnkTRUgwvuXzbGYs3vXGQF5vZ+yi32vvc8ohF4+jRrSQkvm6o3JWlPiJvdP3wkL/icm9dP5o+N/bnWDk66EbEws9YmmKcpCQwGUxILdENpn9QCcgC633pXVnqRrtQg9JvYLeb4kFRgvM49L5jYrIUUChsXL+s/XMOVKk
 RupT+jFE
 BcNQOcLeFfCGh+ksNTmpNGRm3V1w6eRnjKk4P+XJSGh/trJlNXlQrAQkcpLMClN1MP/bD0IjIq5dNd3P+nMW0wQytW7YKSrh/Nm2YNu5+k84E+5/xoNv3Dezv5fcIXgkwT74hT0B86YfL9kg4EeVWgZ+pI4A38A5g917vYMYtoDPLw3wRsReR4C5HmKEEkugSh/0phm55KepxwpDWSnz+aC/Pk8fD4elBVFpXEiPI/JaXqogr6nrhbWAUZeqFCLj26TOahCsEMGdrIKOe2O+95E1EglICKGU/bnxGzKOWBWwCS5v0nUCr/TqmednZ1ZtlggYO5gmPDpt/IigdL50qxsznuRJIJOqIVeQPMi7YqAWhWiMzQBDg86EBt3ECdUVx9vHnwbCew6bn/x86J+RC+9iaYUcWtDc1OlNKtWgNL1e5lZ2Bf5kPlrEQt2PMrwzYGeJNwPUh7kFFPMVSGGVxNallRJNGgFnpJXpE1AycUB2PvNmUiJs39d2ztCotNUALFY6ImW7rokWai/b6bVzstaX1g1DRxteovBfEcDBfl2kagvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 14 Oct 2025 17:07:00 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The following kmemleak splat:
> [    8.105530] kmemleak: Trying to color unknown object at 0xff11000100e918c0 as Black
> [    8.106521] Call Trace:
> [    8.106521]  <TASK>
> [    8.106521]  dump_stack_lvl+0x4b/0x70
> [    8.106521]  kvfree_call_rcu+0xcb/0x3b0
> [    8.106521]  ? hrtimer_cancel+0x21/0x40
> [    8.106521]  bpf_obj_free_fields+0x193/0x200
> [    8.106521]  htab_map_update_elem+0x29c/0x410
> [    8.106521]  bpf_prog_cfc8cd0f42c04044_overwrite_cb+0x47/0x4b
> [    8.106521]  bpf_prog_8c30cd7c4db2e963_overwrite_timer+0x65/0x86
> [    8.106521]  bpf_prog_test_run_syscall+0xe1/0x2a0
> 
> [...]

Here is the summary with links:
  - [v2,bpf] bpf: Replace bpf_map_kmalloc_node() with kmalloc_nolock() to allocate bpf_async_cb structures.
    https://git.kernel.org/bpf/bpf/c/5fb750e8a9ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



