Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1E4FEC0F7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 19:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27E56B0005; Tue, 24 Mar 2026 15:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEC96B0088; Tue, 24 Mar 2026 15:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B151C6B008A; Tue, 24 Mar 2026 15:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D84F6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:25:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5A7131B7D45
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:25:47 +0000 (UTC)
X-FDA: 84581936334.23.1578C02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CA8858000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:25:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NUIN27Zc;
	spf=pass (imf30.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774380345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjPobcRvMeT/wfdI0dPdxyvnVFJANL4EtHvxl7f/5nA=;
	b=61DK0bThJFCgNVsGtd3PcgmBEvCVBCyTSyhi1JsrKXraj2SSDN4/OQsgk3b6UaGVI4tsju
	iENbeivOraaCr8Mzs/7aT4n3rs2Huy5vSsfp24XMaP3rlx0QvAmq/02uNZ71YEP9PP/8D3
	uRzMjG3XI9pDS/FZMwPqrMSd6zA96Bc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NUIN27Zc;
	spf=pass (imf30.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774380345; a=rsa-sha256;
	cv=none;
	b=3jSYnhuxEyFwdP8EnQrJKMDIfJKDFvv2hv0+ZOmC3D+5/0PoDkWUV6dEaHIL4wOF5S442G
	ZwwQpS55DqrHSDkRZOYuEFDL3DKF7Q2wV90bxVvTXSBm55ctXNpnYtfwXHf6Sssb3om9G/
	f7HEhGauwPhyRS/rSM0x56Ccl398IQc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52E8360103;
	Tue, 24 Mar 2026 19:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6B9C19424;
	Tue, 24 Mar 2026 19:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774380345;
	bh=i7rPO7vJ0iMIhXdIA5JbBJbypaa0ZTSBnbMplVZXRa4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NUIN27ZcKuNYOfYaRtrqCVW5R8ocr6UKZ9Q7eRmeK/Mer+lFKudGrW4Cio+tO31BN
	 B+5h3I7dQNHoR5Lsa1fV7UhcnFuCZjt45pwkq90SB5kSktwjl7t86r5Xr3aZ3oy23F
	 80LSejXGPp3+C2Cp2DiRRpogfzd6IDAJx6yrovu3e6gO6bbkz5HVUlMG9DI0nP5vCV
	 IxFlmGehCGXSoSOysg69v+zrppfr7GS1PdlOEdDq5KxbWjwoRe5Mm/1C5b599JzK6i
	 5MB8bd6zoJ6HQmCZJo3xKGsOE5DZxuH4JJaE1N+medG41vM7n/T24jNlphmoz1HZg6
	 lftUVVUhYvSpg==
From: Thomas Gleixner <tglx@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hao-Yu Yang <naup96721@gmail.com>, mingo@redhat.com,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hillenbrand <david@kernel.org>, Eric Dumazet <edumazet@google.com>,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
In-Reply-To: <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
 <87fr5pgp5x.ffs@tglx>
 <20260324174418.GB1850007@noisy.programming.kicks-ass.net>
Date: Tue, 24 Mar 2026 20:25:41 +0100
Message-ID: <87a4vxghca.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA8858000B
X-Stat-Signature: zwry9nz9eykd5ry5bhb8mwzcpmq59z88
X-Rspam-User: 
X-HE-Tag: 1774380345-469053
X-HE-Meta: U2FsdGVkX1/WWUFsQqFVoNvpvnQ5I8TIgHBpuQiye6zOrJ7Y860Yd8l5zywcnpikH+u1tIvCV3ORRbaADpevKoqZRvrKa3UWYjUQQCcXZDrlAerwG2hVhAGWdpIwjYtcvxBV1I6fziNQm49QVhEIfvJssIZhKdFAwYGRcC7elw18HN5jilFySyxAZGpgYskIAxLFS1Zq11kaWi80+kc+gX4T0qtAoaLg0JsJDqsGF/F3ceBINSE6BrT1jzmXBjMUkOcc1riCj5LpNF1i1AMzPIvjPRzD3IfBYHjj1FjC+e2CD5ccmy/yt+8gLPRrw3QdVPJVLStSGKr1GOYQY3x0ZC+A/LXXQestzRg4vP7qS51z51UK8XK2K6XQKmlPmnsfb4zkdn5LNbOY6dxovEutFFEpTBQCAz4INzU9pSS6hWmj0rq2BVZ2K6TZxOOxfaommh8QukxbqJptlhF7NLCU9vHtbRacxrgXfNyslHBfYjc327qVX7L0c6JRK3EHnJa4XDvlCdCrzmBn7DkYtHPOuGo8JLVp4v8y/Qee4/vlKsrdKbadj5Vgp3j4J9dEdqBsz1WBYsHjcd6fElpOEo7Hsr/73TIw0msVI8/mufiBwg/17zdQtA7y18b8Q7T9/CIHrwsQ/HZDNJ6OWE8gMUjSasVswsdFCup6ojfted5zlbvEt4G+wMusKdRSnkDUwI2XEbzU5xC+Q87j8HdjksG2t+P76SHSvKz8YYvz8cHYNrL3fK//U+cyph+VEaPu6IBjJBH+cbqZxGeovG0vrOau2PUX+rPXsRz6RFHUfZ/OMFc9Zx7egSMxQixeTtswciLhkAxE7gewqX7TkwTlQNFAjeCkOi01dDqbfVwpmIEE+0hR0jC2HvM3KnOgAnYpXn4KMmkcXec+lq3onHvJy3HdLMWEzVPxzmLYQmbaMR9PjrDVGQjbtJ02CgDtQJFDxLXTU7e9hzCGUT00mSdvCOk
 gM0lGXrz
 hs40wU+ID6VM+OaPzuX57qRA+pfEsxREbwTBIHTSLxiRt8XfDXjfMTEisP6rWDIBMZOLZRtL42fMz18OE60+7rTg8oz1gsy99mEod0g3jM/OHaNFD19xvpRbzhgD35cxkMK5TUksLLmOQ9NVUS/3kkyT5M8STSj7myXYR2q1ywccV+S5zLwvH4AFT/rbCXgq6c3T8WZwpOIokckHbW8YG1LoadfAYHP3BmmhhfEbQV6GGn/mMMaz1/6WeeA8xT1GKzU1dfiQi5Cwxkjlg8c4Adf5PSs7BAZ3voniTOBA42uBDThHDOD7TAJ+XtpKf0zCLc/5JVCi1OTz65YbQoD9DrnqfXLLmww8oRbUb2tpLtiJDLBauN4W8bNv+G9bbO7yRh77A95zghDJMj6P67rl2vXAoB6QQO+ZyEPRQliAh1RRGGFA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24 2026 at 18:44, Peter Zijlstra wrote:

> On Tue, Mar 24, 2026 at 05:36:42PM +0100, Thomas Gleixner wrote:
>> On Tue, Mar 24 2026 at 15:00, Peter Zijlstra wrote:
>> > On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
>> > Not to mention we don't actually need any of that here, because:
>> >
>> >> Especially the writer side is required so that the proper memory
>> >> barriers are inserted for architectures with a weakly ordered memory
>> >> model.
>> >
>> > The vma->vm_policy thing is written under mmap_lock held for writing,
>> > and the futex consumer is a speculative read lock. Specifically the
>> > ordering is through the associated seqcount.
>> 
>> Duh. Yes.
>> 
>> > All that is really needed is to extend the lifetime of the mpol to the
>> > associated RCU period. Which is exactly what this patch does.
>> >
>> > Want me to go write up a better Changelog?
>> 
>> And a comment in the code explaining the RCU magic perhaps?
>
> Does this work for you?

Perfect

> ---
> Subject: futex: Fix UaF between futex_key_to_node_opt() and vma_replace_policy()
> From: Hao-Yu Yang <naup96721@gmail.com>
> Date: Fri, 13 Mar 2026 20:47:56 +0800
>
> From: Hao-Yu Yang <naup96721@gmail.com>
>
> During futex_key_to_node_opt() execution, vma->vm_policy is read under
> speculative mmap lock and RCU. Concurrently, mbind() may call
> vma_replace_policy() which frees the old mempolicy immediately via
> kmem_cache_free().
>
> This creates a race where __futex_key_to_node() dereferences a freed
> mempolicy pointer, causing a use-after-free read of mpol->mode.
>
> [  151.412631] BUG: KASAN: slab-use-after-free in __futex_key_to_node (kernel/futex/core.c:349)
> [  151.414046] Read of size 2 at addr ffff888001c49634 by task e/87
>
> [  151.415969] Call Trace:
>
> [  151.416732]  __asan_load2 (mm/kasan/generic.c:271)
> [  151.416777]  __futex_key_to_node (kernel/futex/core.c:349)
> [  151.416822]  get_futex_key (kernel/futex/core.c:374 kernel/futex/core.c:386 kernel/futex/core.c:593)
>
> Fix by adding rcu to __mpol_put().
>
> Fixes: c042c505210d ("futex: Implement FUTEX2_MPOL")
> Reported-by: Hao-Yu Yang <naup96721@gmail.com>
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Hao-Yu Yang <naup96721@gmail.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Reviewed-by: Thomas Gleixner <tglx@kernel.org>

I think there was also a Reviewed-by from Eric in one of the previous threads.

Thanks,

        tglx

