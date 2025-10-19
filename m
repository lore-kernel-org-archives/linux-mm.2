Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E6ACCCD195
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 02:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEABE8E0007; Sat, 18 Oct 2025 22:30:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B048E0002; Sat, 18 Oct 2025 22:30:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD80F8E0007; Sat, 18 Oct 2025 22:30:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE3588E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 22:30:34 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1DA69140536
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:30:34 +0000 (UTC)
X-FDA: 84013285188.06.6E57287
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8229A40009
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:30:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KwR86TUV;
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760841032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOgq27wKJwXtSdzWirkOAdqPYtATP74fZtCRj6XX/Aw=;
	b=BOYrub2Xub7wAlxR1nsG57KSefDjk+C5pubSxrJGfnO8ssTUaiw/5Azo0TCzAfRLSeTeMa
	J5Kng5aUI53up7slxwZqNtMpq4bfSKHq/kG0MJvZoXhHSljV2J9P8P0NCpm6EFhDcBfekT
	Ujs3v4ntC8vqnO81yT+hohg6RTYv/J4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KwR86TUV;
	spf=pass (imf27.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760841032; a=rsa-sha256;
	cv=none;
	b=CEkMZH6qz7ZGgXZk1XWc+CvR0pcTWZHLjKHal0QlTWyuwY0Jq1DQav2zkxTFJoUTZndoZJ
	LKyCS+vJB8es1WPqHhXNFa7ydeGRYmRzNUhBgLmdZSa+mPXOh+WFMvlk+Bp4hzY9YvC40h
	0hgHdb+SpCfEQbYuZA1rpc6UPZm/xOk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70F44604BA;
	Sun, 19 Oct 2025 02:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F57C4CEF8;
	Sun, 19 Oct 2025 02:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760841031;
	bh=0qVFoHQo2yjBLNpYoXs4/kA5nVD1EKKdm52aSMvUiGw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KwR86TUV9EGFVS2J473hRYlIJMOvn96/YOO0mcFHQ4ldU4bV7a65lkSDi4f5Q01EY
	 XCZf2f+Jb5qXbWH+Jhu9JfzoPYryR+p7p+jzGCEJaGh3axR5UFgm/bwmtQO6lAXqIq
	 RmtwD7wa61ma5g/PelQOfa2eBCZNhlDM4aZ8dTWkRjnBu4jjFmvU7Zt7xNUbeT9HbE
	 XH33YqyOKxD/q3dpTC2Nl7aHCKMI217LTFBr/Y0ID3MR2YhfCgsPZsiA7ep78r/kMP
	 Sa8YSG5amA9m8m0STdH8AbOUYd3vpSfmJh8+uUNIXdfWv8KGD0mfLesu3JoE3sfM8T
	 bru1ifl4z+KUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3644139EFBBF;
	Sun, 19 Oct 2025 02:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next 0/2] bpf: MM related minor changes 
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176084101401.3155740.15408477033569481420.git-patchwork-notify@kernel.org>
Date: Sun, 19 Oct 2025 02:30:14 +0000
References: <20251016063929.13830-1-laoar.shao@gmail.com>
In-Reply-To: <20251016063929.13830-1-laoar.shao@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, bpf@vger.kernel.org,
 linux-mm@kvack.org, root@localhost.localdomain
X-Stat-Signature: oa8pihtot91abkkbjiygj3k8fziqxnx4
X-Rspamd-Queue-Id: 8229A40009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760841032-477062
X-HE-Meta: U2FsdGVkX1+vdqhwZpAIHDdPE8K0Yg7q+W7uHMxKfjCpHQJSe+lbne9muZRpAxrJgQZiX9B4giPzWVW8pAC7XYPZYea0U79Dju2sHnvT/p7R7T8Y5b4i51jD3CJ3WHVrSjYvA/zaZ4ka4b7DG0wtEgnL1YtYmp4Tq5pssL0RrGU+nc1iXwtNfX/1WiLoQrFnCxyVfSN+qbtO4G0QAzDyF1jQU2MmJUS1q+WwQ7X1nPEEjMRvddLEr2E9LqdeXTE+8spc2K/e5CGzgRyGpBXFkAGozCLaYOuKr8YDLIopAMq1T/jC7qqudvfvJYdFiTu4fTlRFqDWa6TBT8fAbF02Z3mXnfVooqRmiUjuLjSHLRhjPaA8Y2cOwCGRNyEVupqg9E2Y5Vuct4yYDvhHbxEgekP2YSRzL8cnUwGIByvp4okRpusVAaRqCy5LoSdjTl91mG22Dyn4DuIDiuqa6fW42gU29dXWRmkZSN7jyE2Dt4NIOmIXrpE6vXpwiBUxUvpaoQCZVq5bw/fTTPqoTpCIDh/qdgw4i6FWt/PEFA+3dzBq45SmCeGpR42QawNSyT3FE1eeO1soReEEuMtFMhdwUor46NqdsGzE+ZU6DC6drQ/T47dYHJCDjh8lyy+oqb/PIAm5jn4mb+Yh7iNQSdPzEqG2TZGw1oNBWGL8xpXueahiECH4fUfl33dBa+ZCoJ0i+esRZr44b51v9mkq4E9h8TSnILlC0JoACCP07R/ZWhzFgKzFxIA9JIVgpqo5V2zs0U1HK5tSS8tmE5846q1LcNzPwR9MKnhWLk6uizSGHTrzcR0On/qgeKWcB6iiBzKZJl/q+u7v/yUve12/rUNVG3eWtVWCBNgMIK3h+nBmYvAghit34rrRAe7SUiVyhuDm5mjUPKkgJaHgPR414ryGsyJ0gWEDuc+lEL8ekv1FncGGpCpfUZRc5PMgDeTQZMVKAgoU+wipycl4OPNSH3V
 Rk+lC8kO
 u9cg1lR1d2dVK5Ozxs3ZBZyHfZ5Fj7fsGTm/DbmWfbelMPg+S9KXqgERp3PIqTzEKI1wD5COSdN0dvSof9B5GPBRiltf5eXaz5oaSd3cKZ5Dw4oiT6GiYlpx8joNKVFlkZDy1afMymk130igjHb4ChP4RqjEMPnFbffpCXzi93wb0ceT37vPX16JcxCE07KWhF2YiksnfFUF5fDjn/cEwDEcmxXYmXMpB7tE/8GwdvSLfWNZcGmL/TrHI0yySwQY2zuAgXWArLLkaDknjrDJFiLZ7hr79nZ4mZjDvRTnIQuZ/quNgp4pDyWzzxwperII2EWDLNpTRLhsME1p6DZmupRfabvNArDw8mRpHnSLrdS6a+G3W6Kl8jW4CALYEveSm5pFHGVvw2cMmXKqku+Xm+8dCOaXPDB5eYc9Szn45JURXNLLgJ+lOsst55cWGxLdku6Gc9uPvjPKWMw28BJo5zd6AIy2+w/haTiDdmRGK2eEjMFoDu5bH5FU1MJnCFuSrPEXb8slqQjxBVPTM+waRks+l8hZhdzWMY07y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 16 Oct 2025 14:39:27 +0800 you wrote:
> From: root <root@localhost.localdomain>
> 
> These two minor patches were developed during the implementation of
> BPF-THP:
> 
>   https://lwn.net/Articles/1042138/
> 
> [...]

Here is the summary with links:
  - [bpf-next,1/2] bpf: mark mm->owner as __safe_rcu_or_null
    https://git.kernel.org/bpf/bpf-next/c/ec8e3e27a140
  - [bpf-next,2/2] bpf: mark vma->{vm_mm,vm_file} as __safe_trusted_or_null
    https://git.kernel.org/bpf/bpf-next/c/7484e7cd8ab1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



