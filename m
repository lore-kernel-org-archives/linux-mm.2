Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77926CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 18:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD30A6B016C; Sun, 31 May 2026 14:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83CE6B016D; Sun, 31 May 2026 14:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972A36B016E; Sun, 31 May 2026 14:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88CD06B016C
	for <linux-mm@kvack.org>; Sun, 31 May 2026 14:59:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 317311C05F0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:59:01 +0000 (UTC)
X-FDA: 84828627282.01.0D7C375
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5694A80005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 18:58:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YNh/LumM";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780253939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjVt0UsISSTwZDvffigjt8YBiFpMw+nOdlcd3vzCHGc=;
	b=lxG3Gt+98t7AZTeGoBIIS69z8DHl0O0LsAO0BXGRjj3WcFpw6z5krwhynMzk17A5A6mmhN
	iyiOX+vn4I1PsWfzynEGPyq1I2huv5wi35YkqNjZHcIG/X/Udhp8Ad19XBXJp2MGtMGYvk
	Tp4WziQhnmq4a4sCBYx7YVSAAzc6kcE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YNh/LumM";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780253939; a=rsa-sha256;
	cv=none;
	b=Vu2xDp7fPl34118lqlpxbs7SbGuD8Qv0FaGg5poxscmL3T1elufTJUYcdw1RMjqmKR8D85
	RaEL/OAVIhrfT/nsF7KPx++BVZb+gHM4m0TNj/PvYe+7LQq2qk8P5z8ablOkUD+odst6vJ
	TZxgjFihEg6ekkMaC84tk0xSzlbUY80=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62899441CB;
	Sun, 31 May 2026 18:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D161F00893;
	Sun, 31 May 2026 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780253938;
	bh=GjVt0UsISSTwZDvffigjt8YBiFpMw+nOdlcd3vzCHGc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YNh/LumMIZ723DQ/0VP1GsxHxDjZrdxhVNhzemW/jiRb5w5/80kYkSqAPFZGJBQEw
	 +U2f7XtX8p48n1O6HbjMPXAfpgWnxCaoO2NbStZkaiRGY+/urn0fAUopy2gsspP47m
	 HXcV9+JVpjHDRaGp4ZYSIZTH/8Kw0TUWjTtfNGkM0v6rUMA2eetPYF33K4zwyNwjJ3
	 9pVf6drwd/aAxwQDBUqiMjmffm/SvVRkspQEAYPgs59JoR4gQHwPECpfA/PNSm6tHR
	 emsS5rbPW8TwzN+gl4QTRujSNvPF7Cc3z8OFL3e2itKVZHK58fQbVAGDl9vnE0Zllw
	 xKt9ksAra4hZQ==
Message-ID: <1ed6751d-e286-4c6f-864a-800f8baf54c3@kernel.org>
Date: Sun, 31 May 2026 20:58:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
To: Tejun Heo <tj@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
 <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
 <3901fe0537edee9d7acdfd91695ead28@kernel.org>
 <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com>
 <ahnedQ33ZH8ogjbC@slm.duckdns.org>
 <8cc56c7a4aa29628b7d17d85be7eadb9@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8cc56c7a4aa29628b7d17d85be7eadb9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z4kqdpjgchoityn6w4wr85zswtoqfmq4
X-Rspamd-Queue-Id: 5694A80005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780253939-303528
X-HE-Meta: U2FsdGVkX18z27bmmd7X7gAp4m4yuOy+umjyOpqObsF8C+UujUbYr447vJpcBtcfLVKC+gNPJcBsRjgiWRSZG33zGlXvHdeml5K8HRjoSjbHYkVcTZ5IwSRAJ4URQa+7wzIpCVMDKTgYKxfaYgOyNrEwPzb5rkpHoI+jS6oGM+lkEceSZshAK1gm9jcKQFvS4s5YwWCPLGqSckAGCiIJlWH1O26qNKNmIRuZY+7oZK2OZOj0jV2nwIxBIbnjPbwxKrEjKkNN1KxqOv67AfQu81ZOsnExH7oBJLRbF15yMp1tYu/vao4pMcH+TxXOnl1QXOfktLkmVp2yCp16SQLFPxwEMtV1bG/Ex4DJBqjN/rmPyjwzxva01+qvOnAC2D3r7Fq3SYaSTyZBDg9JgjwirDpQUmI4FYTebWHh6zDnXROknhkbwurLQi++fwTxmj/HM0BHd754yrdq6TQSPGG5+Sn+T6iP4kdaKEbCDDERzSsnQy7u9WarMpWZIQUOGKx00gXGfPlUbGxDPGnrCpyL4nq+aRRl5zGs9f/oEzQBYYNrYCaBrxyWm4sEzydC+utWnAchq2xwpbkYQr4R4hZkAxIa52LoXZnaaE9PnlFdCTzejven8nClZi6ERyIwAxP/1sRV5FrhQKemxr/T736KnlRxZ4NJXlyEsJMSlPVOjoEHhyyG3dUT8kFxW0XfSVwvHqyuoe2mc8RM48F0y7HiB72EwY9GohPR6QBY0jMompoJS298H9J0mIoWJPJmmB8Jk/cr04oq5ZpX0MGTqeQULr+n/+jonwn3pD7/G1AScjIc8TF8s4M8Xkzd+D6m3/zLz/FRG6tAjaV4esJfyyzuOTK+ZExpIIYQTXDVB+T6TaUu1LD/fJnaFuRt2jxF0ciHsbq92rx0xpzWXAHGInTvWlok7ZYdLEQwtHFr1r04NrgZ3X17FmnobyRDAsR/3BKLzWscj8Awpm1IOaO0GaZ
 ryjV3g8G
 J912Opl0PdYYMkzjQJggY6Zeg3Sf4tOPkMwXukfQwEu3LzqkzbL5WlK1pRJPzH+c/mcEX3radIx5FJabKVywq8nXsqCrz7edYD6ak0w5DdtMDdGleB095+EUaqkgPM826XpfPl1Mx/L0YUlXxh6iygxTckn4avXUEfJ7lsrIVCgRnNyeTAmhxMmYq5Q6xpiD/N357W2AGlsbcRBkcHhxZIMeaYNGO0fS5r9PCpS5311KbSCDf1ZOfEFWP/7nXPgN5mkfk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 19:47, Tejun Heo wrote:
> Hello,
> 
> I posted the check removal [1], and Sashiko's review flagged a
> break-before-make problem with it [2] that I think is real.

Yeah, and as I raised previously, this is very questionable locking design :)

Either everybody works with atomics or nobody.

> 
> The scratch page is a present PAGE_KERNEL mapping, so having
> apply_range_set_cb() overwrite it via set_pte_at() during
> bpf_arena_alloc_pages() is a valid->valid PFN change. I'm not familiar with
> arm at all. David, my understanding is that's a break-before-make violation
> on arm64, and that on any arch the stale TLB entry keeps resolving to the
> shared scratch page until it's flushed, so a later access can hit scratch
> instead of the new page. Is that what you were worried about?
> 
> So instead of just dropping the check, the install should route through an
> invalid entry rather than overwrite in place:
> 
> 	while (!ptep_try_set(pte, mk_pte(page, PAGE_KERNEL))) {
> 		old = ptep_get(pte);
> 		if (pte_none(old))
> 			continue;
> 		if (WARN_ON_ONCE(pte_page(old) != arena->scratch_page))
> 			return -EBUSY;
> 		ptep_get_and_clear(&init_mm, addr, pte);
> 		broke_scratch = true;
> 	}

We have to handle architectures where ptep_try_set() is not implemented (as I
tried with my variant).

-- 
Cheers,

David

