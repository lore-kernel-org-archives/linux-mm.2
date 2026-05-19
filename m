Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77A8CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E82A56B0005; Tue, 19 May 2026 04:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35AC6B0088; Tue, 19 May 2026 04:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A066B008C; Tue, 19 May 2026 04:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C4F196B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:58:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 55D4D1C0C35
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:58:15 +0000 (UTC)
X-FDA: 84783567750.16.EC7C756
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9CB71C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:58:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIQ+Vgif;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779181093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7SH+YPF95/zLwMr5N6vP1dVxD0qTdJr5+mf2xNfP+q0=;
	b=y7RqmEN8iQ7nQMU7rBKAzrCHf7/X+d2Mm21AqDuDQ2cYONtQHGV0/fArUjaHiV8HmHBEU5
	0h4Kx5EwXg7ybOn9iizFZEQxL+UmRpvb+aaTS54MoNT6XWK7toi4H1ztEvAigJU600FWpj
	NlpYJcJT7SDIKRAbDmDwrGLbudhwzzo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OIQ+Vgif;
	spf=pass (imf21.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779181093; a=rsa-sha256;
	cv=none;
	b=x/1ywH8qqtam/seW+MtXbjiAwba0WZQUm1VMBeBWPcEyETAZ1d4/Lxsmvmt+GnloYCMwZ1
	1VXyjkR6CiSiNJXNNNNquDNEbbm3A93Xz+4qyVYvudEKXLJg1KH0Em+vwqQVqLXAdXFirY
	mOq7yySfdXD+TJ9DT1XkakkCzl8rMkw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E59600AE;
	Tue, 19 May 2026 08:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8029C2BCB3;
	Tue, 19 May 2026 08:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779181092;
	bh=gauNbmJGhz8SMUOs2xoEyEo5YiMVdKM4Tk3hN8N4jDY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OIQ+VgifWcStlS5toMmZGu84EdGLCtmmnLn3Ob3jognZffsMTzc/DJEggAgX+G8GF
	 gfXNpBlOAUMaNuJe9AtOT/v5b/oebVSMZIx3zMHhjtWXCiv7fi10XdKZkOB2uy6vB0
	 efEsR/C9/1Yi/v/sOFKfbAf3ry0bfSdYJ++0AuKQwIqLG+z057qPvsDwpVQXffOll/
	 KOaJDFoh8mi0pv5pkUtjWLO+6PnBcJ0+oBFBk11sntZi7sVHF8Qr13ZiGb7Pxi+jZS
	 SggTQz761MHciv8LbGkZHWQ+0ROYb8U0S0OUmBVl3yj/UjdDwGaZBKr0hvRoiMoU4x
	 EO+uDPznm51EA==
Date: Mon, 18 May 2026 22:58:11 -1000
Message-ID: <297658c4ae2d6e7103f5968efc936224@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>,
 sched-ext@lists.linux.dev,
 bpf@vger.kernel.org,
 x86@kernel.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm: Add ptep_try_install() for lockless empty-slot installs
In-Reply-To: <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
 <20260517211232.1670594-2-tj@kernel.org>
 <9ba50fd2-077e-4291-9276-9adb18186873@kernel.org>
 <agtuPrgIDNKSu2Oo@slm.duckdns.org>
 <2f02d90d-cdc9-48ef-abe3-99e00f22595f@kernel.org>
X-Stat-Signature: g9gcjz3mf5u6updziwckm1hb6twr54dm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9CB71C000B
X-Rspam-User: 
X-HE-Tag: 1779181093-76574
X-HE-Meta: U2FsdGVkX19LVkjKJSxflMS5J6dTIFk351T4qtWr0ayg3T5uV4K//HiNUYY9CGGXvR32iGyhUod0X2kZ2GX4KammmAzEApfOr7ECky9bGkjef4K/te+lg3pWPbhEKB2aSMhnjgVUsbbyG+iZt6ZvSAWauRLM+lOYjXnetA7pgsRSvyVEef3KQDs6k21eJnTh4A1gF/7VL/12UAc/5/gWg0AtHsSpD+K4qQe+IE+j5J2KYSz+PMgF/hbKeaQUYIMYVCKn7Nqcrn5qxGQuLrvxRd1Hi0ZnzF9GfWhL7XAF0RyKA1c7m7kFqLPDwF+dMLAWzvSWhuoSLLRuIfTdPfM0nWjlqE49D7Ys5P3wbVVO3uSNRH12hkN76Hj0o7gySorT2E92/AfVj5tC3LnljXMh5zUFqwNWhhxt64Y4/PR7S7C9ZngRTwkoh2Yuu+dc6BWVje2yjojoij+CXfSZMt8DG3yHtyY5EZYPAWHqcI/zxzrOnkOltSfDhaJ7ik+Z9Nzu27DxMilwLjHz6qxRyPCSPgNwiQaKH4cCmThHX50KmPCx0M8gWdTMci8VQO+ZLAnFL4nkwr/pWp4EB9DsTtsvdqT83gZyCWtDA+RIeHZtohJK5XUGSPQrtB9SRHlW2nyG2eZhsSyo0u8h9YwkhEtjgLeZrIbmZNvAbLYWOe5RW/UDBlG3Z2MczOHLsG395EQ7QN9ceepWJZ4Xm4zAwBb4zqdOXSMDwJc9HcMKog0d4fZ4ArO2GoYpOn3/8CT0K2/9SzAR0WWbNTntffl50fBOHIw84EOkWpA3J6EoZYQyD8L7DP+pS8H4897GupgBi1xZFclo35Uv2Km2iTBC9TlknieUxhj/oX4b7GvbUHF9P8jH0nkmB8s5y2zIvQEZIMeA2IK2cPLR0KnUahrdk9ocAK4Q86QLMHB/eFNslXg42z3yXUG76c1U6jvGpP6cgvz1tQhDE50HYXL1GtACpaq
 pXTs1fse
 q5XhrJhEf0wtdfmQnVbJLF+FJuRE8g07W35uNXaYjoVQkuR74apLVquzOtZ2qa96xt7COM/Du4UhotGn1JP5JevCjhlKfEAuF7s+KrVCp9a6zGQi/EN/vZSfkAc3QIWBN5NYOERTBnH6+9sHThXXKHzCXJHodjydSbDCCEmSRX9kWjnV/ib8AVqONaTc3T+UERAHLrQHLU8+iCpJPLseUxvW3xYw6EsPgKZ+GkDTp70PeurF0vsiucbHZCydybJVV3mOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, David.

On Tue, May 19, 2026 at 10:00:39AM +0200, David Hildenbrand (Arm) wrote:
> Is that really possible? I'd much rather prefer to trylock and retry, unless
> that can really result in deadlocks. But I have the feeling that such deadlocks
> should be impossible here.

I'm not well versed in either mm or BPF, so the BPF folks will have a
better take. But here's a scenario that seemed plausible to me:

1. A bpf prog calls bpf_arena_alloc_pages() on its arena. The kernel
   takes arena->spinlock via raw_res_spin_lock_irqsave().
2. Under the lock, the alloc path goes through bpf_map_alloc_pages()
   -> alloc_pages_node(), which fires trace_mm_page_alloc().
3. A BPF tracepoint program on mm_page_alloc that shares the arena
   starts running with the lock still held.
4. The tracepoint program calls a kfunc, passing an arena pointer
   one entry past the array it meant to touch.
5. The kfunc dereferences. The kernel-side address is unbacked, so
   the CPU faults.

trylock + retry at 5 would A-A deadlock.

> For example, staring at apply_range_set_cb(), what prevents:
>
> (1) apply_range_set_cb() finding pte_none(ptep_get(pte)
> (2) apply_range_set_scratch_cb() succeeding ptep_try_install()
> (3) apply_range_set_cb() overwriting the pte with set_pte_at()
>
> Between (2) and (3) CPUs could access the scratch PTE.

Scratch only gets installed when BPF passes an unallocated arena
address to the kernel side, which is itself the violation, reported
through the program's BPF stream. Behavior at that addr is then
undefined. For scx, the scheduler should be aborted and torn down.

The only requirements are that the kernel doesn't oops and the
violation gets caught. Beyond that, behavior at the address is
unspecified, and which installer wins the race doesn't matter as
long as kernel integrity holds.

Thanks.

--
tejun

