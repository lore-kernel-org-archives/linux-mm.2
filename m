Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDADCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC8666B0005; Mon, 25 May 2026 11:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F546B0088; Mon, 25 May 2026 11:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBD56B008A; Mon, 25 May 2026 11:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC2036B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:50:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0C2A16071E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:50:09 +0000 (UTC)
X-FDA: 84806378538.13.DC8B034
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE7F718000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:50:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brMJBmOd;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779724208; a=rsa-sha256;
	cv=none;
	b=oTbZHjhl53Pz9sSDru64jnYSnBxR/3jCLnlSVTKKuzKGezNZn3KGJX+jCkO84xekFU31FG
	h7PowF/OMnv180J2OdwO9cleves2GZ6M6zTKUEIvoSt9KnM/OiKS6vb+I5hxye+3uF8o92
	PnLuREUuv+sOnFBiV4bFDvTEYV9+kbs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=brMJBmOd;
	spf=pass (imf06.hostedemail.com: domain of patchwork-bot+netdevbpf@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+netdevbpf@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779724208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=er8UsZouFFhjk3+GJ7baiqXv2Lc2B7dnsZku6inG5sI=;
	b=sTH1vJTtjNP5BS/eci6Aj34XzNeshI79nbC1sQtefwSpLZ0CR/41HiNq7mN+6XpgtZdmVz
	KqdaD/BoeWi1urIQ6T4idpMfBC3A510XuxVV+IsDxLCpJ5J8+F+BrKGSi3HnDRWoIxksZU
	uNtqDw+wCbbG+z2VJ1Oy4bjbMUoHb4g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CF866008A;
	Mon, 25 May 2026 15:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFEA1F000E9;
	Mon, 25 May 2026 15:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779724207;
	bh=er8UsZouFFhjk3+GJ7baiqXv2Lc2B7dnsZku6inG5sI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=brMJBmOdnKnF0Zzaqx3KMPwRmWhnrFvJ9fsvRMKS1QqqYYinLPIQx3ln4zUHdNlnW
	 WKzpvsQG2U0W8+bUfXh6XXoGubc33vvVXOtwWNXemRLFrdEM7/53r0nI5jkUh7h5Mi
	 ZDS+jJ6GNIsz4SM6W1NWONn8j/SlHm7ZNOI7MENr9ckh9Zdgm/qgqXzkQEzo0XDimU
	 DqS2uD7a0wQrRM2NKrvZ1vE2r0zaORQFFclfsvScJSwuDdUz+wP1pB54UX9QSoROxb
	 nPLGv/Huo1DAoAnXLD8cOypzfXvtLrKkm6/kZ/g0asgTFFDHppJJactOzD1y6ef2NC
	 1Yu5c5ql2/JBQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19B69380AA66;
	Mon, 25 May 2026 15:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot
 installs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177972421364.2623932.4873892825966322227.git-patchwork-notify@kernel.org>
Date: Mon, 25 May 2026 15:50:13 +0000
References: <20260522172219.1423324-2-tj@kernel.org>
In-Reply-To: <20260522172219.1423324-2-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: void@manifault.com, arighi@nvidia.com, changwoo@igalia.com,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net,
 martin.lau@linux.dev, memxor@gmail.com, peterz@infradead.org,
 catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, akpm@linux-foundation.org,
 david@kernel.org, rppt@kernel.org, emil@etsalapatis.com,
 sched-ext@lists.linux.dev, bpf@vger.kernel.org, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: EE7F718000D
X-Rspamd-Server: rspam03
X-Stat-Signature: tfeb1p3sdxowcshectyhb4diaoojfrdd
X-HE-Tag: 1779724207-892401
X-HE-Meta: U2FsdGVkX1+DE//voN5Bdl32x0BtTkB9eByJ2jwJIyhjoHua/4GOOK2efYYr6zQgcyBwWklVU5saH7z3W4JVVEk14k1MMwaorCxVjf0fqJxZyEOp1nlJ7YBiP67cI+tdYAqkfRmJ0Y0bebQZCZzO10xD8xspoREW5XrAcBrIiPOlR9r2pTFhzyN9hvUSmMPnhbiDcTZTDb4/K4g4OWNfrp5isAlmLJKtCTJoyboW+Ik2ViEsziLKUnlQc8VBO5hQDYukJa+8UMBN6UQA4OlWRttdJRehZGraVYRhYYPSvGqrZg7wWCChZsT6hukLTQKjtfGc6g1CWIhE3aW724DLW34/WZHmGSiqljJco9fP04XUU2Zhy1PmrJfbRb1p/2sB/yIXX8YuJ3LNJgmBZrWtQmD4qzeSxQ4S27wube6t3YxUNytKJSESfhKXlbk7HwUPMgGilo3wPmzrtvwqFUly0PXEz3/fHbACcGLgy/yEJ+ZAC20rpUVa5vpGJjPA1stV/+MeskFxSm6Tc+OVw2orliWn/zVctkaHUnK6+1i96aBhhL4ehTn8VB9qMutB8lY/eqzmuG5EsntS8SEvUs2/YpC8y4PGoTpIrryVVnqOH4yYxDb+TZ3SkN0zO2c7DGZvAufwXK0fSL4224OXDjbVJuGzsnfrA9zCMN0bP26hmKk346iMuYFj/aP1r1NUYhGoF0OFc3Evtf2hKwKBIPlQxbuqg7z9SkJ+iz89v3EloWkfrt2ZbEoHqPe/5LH+k0lC56JPoHEKe93BvJ7tKyr3e8EhwDOdZ/FCDaE+vGiygnP0nNeXQ9sO9MpyXxFht1di9FBJWuskxN/YLLWMwWquHtarRwtJLhjRxkETCZYyJh94mZlowXTbVQhn66kb2Mhs8Di2Qw4e/C1Iiq9m7SB7dMFTcSoQ4rAGrmGGWmmzdlzlwmJN+NQztOrszWSV5ZuWYlPxPrv5WLHa+q6wL9f
 YMKsAyHs
 2WgnSSj33/2B16u5iwh6k67sgLi/Ed4J5ATAETl95MhppaEwq4p0rP2EzRmFcKyKBqjuzzPHgKZ2JqLM9SsDg2El83SI80zWUbwUDd3Zo2mLhR+Z8ABaMit044w+ESAaXNME7PHHLzkxZvb2xpInEN0o6QWBSzMspYW4vmq21+wADkpkJd90/Lhe9ajoj785HrHdA1RQjk6qmVMXLskV82jq9I+uLFpC3LSgY5diHc5kLBASulEOVj1dJUMl7m8RmzXJ5EJpA2HzAOtAPs/SUKxXdCjfeC1gTS8a3a2+JQICRgI6BEShUXbnVdzmQ5oDPE2Dg6r3mxkt2O5rxRqy9BjyfoUXRR2ic7btwqUofHfN7l6WKEd1wZ5TmOStBE++kHRo0nY14ki8m45BGuoH0UaOerob/htmztanY7XFKeigWvmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri, 22 May 2026 07:22:12 -1000 you wrote:
> Add ptep_try_set(ptep, new_pte): atomically set *ptep to new_pte iff it is
> currently pte_none(). Returns true on success, false if the slot was already
> populated or the arch has no implementation.
> 
> The intended caller is the upcoming bpf_arena kernel-side fault recovery
> path. The install runs from a page fault that can be nested under locks
> held by the faulting kernel caller (e.g. a BPF program holding
> raw_res_spin_lock_irqsave on its arena's spinlock), so trylock-and-retry
> would A-A deadlock. Lock-free cmpxchg is the only viable option, which
> constrains this helper to special kernel page tables where concurrent
> writers cooperate via atomic accessors.
> 
> [...]

Here is the summary with links:
  - [1/8] mm: Add ptep_try_set() for lockless empty-slot installs
    https://git.kernel.org/bpf/bpf-next/c/258df8fce42f
  - [2/8] bpf: Recover arena kernel faults with scratch page
    (no matching commit)
  - [3/8] bpf: Add sleepable variant of bpf_arena_alloc_pages for kernel callers
    https://git.kernel.org/bpf/bpf-next/c/f211c81ddc36
  - [4/8] bpf: Add bpf_struct_ops_for_each_prog()
    https://git.kernel.org/bpf/bpf-next/c/7c48a28c1bbe
  - [5/8] bpf/arena: Add bpf_arena_map_kern_vm_start() and bpf_prog_arena()
    https://git.kernel.org/bpf/bpf-next/c/53cc12a2dc88
  - [6/8] sched_ext: Require an arena for cid-form schedulers
    (no matching commit)
  - [7/8] sched_ext: Sub-allocator over kernel-claimed BPF arena pages
    (no matching commit)
  - [8/8] sched_ext: Convert ops.set_cmask() to arena-resident cmask
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



