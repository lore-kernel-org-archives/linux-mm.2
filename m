Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7E9FF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F8F6B00AC; Wed, 29 Apr 2026 23:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579FC6B00AD; Wed, 29 Apr 2026 23:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291446B00AE; Wed, 29 Apr 2026 23:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 115C16B00AC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7ED616022E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:32 +0000 (UTC)
X-FDA: 84713784624.22.4D6C9FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 412F620003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDec7xN4;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oK0RL2F/L+M5dfAvTQeZ+Tbi1Enr1MAJ/BzaJVahsw=;
	b=C5YV4bDWMTtiIaCoXOJM+duLEM5BwvrE1o0kS8yEAL66cUHYGJCRB19Mwbxyo84Jy/oW5w
	UgfThcv125vdiig/2GO3IB7knr5xrMJLHfjUAP5igaSgfxQGRXyZw446Cx09o1R9xwQdqx
	F7o/S93mohbcDj/+ZSPz+ELVgCKmUH0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YDec7xN4;
	spf=pass (imf13.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519591; a=rsa-sha256;
	cv=none;
	b=cfvh8A7cC3LcbXQJrqK+7AOCEab6NGeW9Yy2wafNIEeRQIhEBCg+0yKy4+FDHFu2oU3+rK
	yJ8Q1FRO78x03eo/p1yHmD8oCeRr3qvNKEuVNw/nwlN8Sup8o98+BH4C9jBclKCfVqL65v
	lvVkt72CP0e15qeOrEwrX74iJyvQmEE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B348361330;
	Thu, 30 Apr 2026 03:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BA1C2BCB9;
	Thu, 30 Apr 2026 03:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519590;
	bh=jzZuBjGs6d//AuDRvfXUPCJyxdAcdxXtpm8HzJf5lJU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YDec7xN4GgIHYxxQboOLUbUYbbvBYvnFwvFlnN4Pkvu/m8uiFtXXPmJQYboZEMuwM
	 4pxMYNokfOgCdNlI2KJ6ESz18qolGtTs7BwEGy+u3PBOUBdor0Hog62FPZKdlUichJ
	 tKFpwGoZJRw6d/pJa3z7TPuVtgIxOSxYtVgcgrI8I/PR1/sWZgK4JBRCqP4THb9aN3
	 hOp5H8D4lUYt7ZahrJKsA6nSwJ/0HxzbRn77Hcr02O2pIZJUfET8BQdXHW2xdKR6dm
	 f73ut3z3cqnO57mGnch0C4kBKpYioYz1mr5yhV+dc0QPZ6XkrJzTmQQ664unY5icPx
	 JD55dswsCR4/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E6B3809A07;
	Thu, 30 Apr 2026 03:25:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 05/18] riscv/mm: Align vmemmap to maximal folio size
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751954529.2274119.13385443972464181623.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:45 +0000
References: <20260227193030.272078-5-kas@kernel.org>
In-Reply-To: <20260227193030.272078-5-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev
X-Rspam-User: 
X-Rspamd-Queue-Id: 412F620003
X-Rspamd-Server: rspam06
X-Stat-Signature: emoxbsgbua74e4sebqdr9nyxq8xtbpab
X-HE-Tag: 1777519591-957511
X-HE-Meta: U2FsdGVkX19zhAQ9rwVPsAqsQBeS3U/0rzrPPaFkHY/tMFjSs6xTEtFqwlZnUfmp6FdqVJG6BQOJ2qogoP6guqQ/lxNEky1psyX5CRQ3qhtMjc5XuAjwzrNei5HBg6a7X3wkKugvTs57J6RYvieJwzx7cRCW/JzuZx/zv4khEhz2HRlmtbsgwoAoj3w/wg019TcIWNvvBnp0cyUiWdRUqn0ixDy7j8j6ARhAOeN42WCQGKeDpeW2a6FhOfZgA1cADEICzznJJnsj01mwinZkFwyOxEb8yXZnpq4MeX0zsMZyOsclosYaxjknR2bgIIk4hJpJgX7d7oy6JqxVCpCV/ZVMF+LZsSMewFNEpow0cVL5NhggKG3cgh41Vcr8G5EQF6vFtHHyYsikBTcCKLCoep/OmioIVHm9Lt1N7dLDp4Xe+9fBwkWqqg2sXBBd2pjifNKkEE/bVSiWk4V6/tGxO7msgOj5ToZrN4QQeahTN7tobRj/+SsukOm7n+zbSNJmSDyCdaeG5vFd/QKLjkNkT+QR7EVPG9JKawFmRSGj+MUfpiRyOtpsOFsGuCuMHV6cTxQQgeaKzJlGslivQ1+4NZ/tvU+qXPpy0f2r5XWL7haR4AyaNxZhy5Qlv6L72Kebf+XaAYhdXvB0dMz+YMMuRkz8J/T6dGMK8rorxASlVGEEVpqDkQ4K9NtFF/Ud9KteAxAxKHa0xkEfXLAAfS+MyZoEBdSyegapDlE3F6za/caTGzLBBe3GX/+QG+MqzETW4bvU7o5QbfNL1bto89Rz4s5uMn6l67QBWiaSp01kl6uTgjNcOD4VFuPpmVUbUx/H+a4tB5fj05vh2UjujtoVQ9p0JJdlr1fzEwuwkcRu1fsE7yjxoSG1wtaqinbTMRXolFxfacGblM8lu0S1S6KXv5B04jr5clHuPC6XLPw2FxMAdqlIc09iWCBJIpN1Wkk7dggwdsfcjiFi3vC0Ccf
 74OmekiQ
 D2ozWu6/29Dp7l/JfNwvOVPh5tGAOCQ84D9kD52Z7dRFumO9rbGKPdIZNPYijA+ol0OacjIUCT8GlwqqsxNpd2jhwZtdHptas73Lx5Xko2wdrN3/JvlHFx2SnyppvWC2iWKQUL9KUHDoUgXjyZP+UWySu7V3bxrOursWODsy2vbhm0Fb8AlBPEADzrNDdxVMs9tPivi0pT89syfQjK9QAPD1bj5b45H4CbmFd1KuBHG0pHOHfqaVg0SW5c/KYJYEYdJWeTaD9glQx4z/KIJQqOxlJQmb9cTYfjKffOElgqlHMp1ntAZ85kOMsbmAihrZ2MLmZnpu3iGW8LWu85VDPMIm/DDoetAKFvM4IZaGyN/IoG08RugzRd9Bs6PuDL7NCqzYNkgkeDCXVjWw6+L61pONAxgAD0SpnNvPHhjr4gyhta3O9PQZLvXsi5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:06 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The upcoming change to the HugeTLB vmemmap optimization (HVO) requires
> struct pages of the head page to be naturally aligned with regard to the
> folio size.
> 
> Align vmemmap to the newly introduced MAX_FOLIO_VMEMMAP_ALIGN.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,05/18] riscv/mm: Align vmemmap to maximal folio size
    https://git.kernel.org/riscv/c/476849b0fba4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



