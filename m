Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7447C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 08:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE646B00F1; Tue, 30 Jun 2026 04:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F446B00F2; Tue, 30 Jun 2026 04:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486146B00F3; Tue, 30 Jun 2026 04:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 248106B00F1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:29:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 924461A01B6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:29:03 +0000 (UTC)
X-FDA: 84935903766.01.F9DF18D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B3D9140009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:29:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjJEArWc;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782808142;
	b=v+ZewWhu9qoqsQLFo9tZqej4+F7EM5En6k81FXN1wWjdLZ6OcXZR1u2wn1HNPrAu80tJfQ
	21uF+oTPnBhKWo7SzgPxBVzna9zU0lHQ7nTfoFYn0yFpXkJROOFaQXP0vf5GwbrWdoq1h7
	6x6TGr3qCu8l69PzsmjkgIvFUBTr84I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782808142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBSQrrcP22vcidqBU5gs9JP9ZNJkO8H4LBPIYaG3eqM=;
	b=eda40MSwpIMw59JC1mji9Vfy0+rLfantN8vYRMzAUdJTLkhaZ8FEk0IbYgNKQlWe1QLTe2
	tRgAAy30Gs900h46qxQN17VVCa/FL5jR305wk1R9MXQXATa8hVxEddY6T0k+nHE2ECh7Sf
	h6owCduNLCFipctPcX+NPLYA+Iw2Hy4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QjJEArWc;
	spf=pass (imf23.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80EC2600C3;
	Tue, 30 Jun 2026 08:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA941F000E9;
	Tue, 30 Jun 2026 08:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782808141;
	bh=NBSQrrcP22vcidqBU5gs9JP9ZNJkO8H4LBPIYaG3eqM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=QjJEArWc6o2bKMiByFHlpaEcIa/OX3OXGcxzE2bMrmH44w+PQBkqKu3l4ekfgXLuY
	 fPZdoJAMcOfsGY0obVkd16FxAqon+yo5X+5azLEYSpuZOzaM0QYMEZSEB7lowm+P5s
	 lbc3XDU2CfCGTctts8WmoPZKYYQzuVUH4jU8eDBlfa/eDFwk6dvKs6j8WdMN357NoY
	 SU098KQy0kcFPk2EHdgkZDoeB0xk/XDWtE4PCinelV/YWa6WVt8goSGqORVnON+PJ8
	 4tyWSNueK3GgBBt2ZbeVJCeVtTHkxYf7oM8gxZiyGQWzPlX4y75gJecrwlnIu9x7A/
	 Qu2ZG+YjWsioQ==
From: Thomas Gleixner <tglx@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij
 <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, Quentin
 Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 12/13] x86: Add support for dynamic kernel stacks via
 FRED
In-Reply-To: <7D930EA3-54D1-41CD-B547-8A2A69F89142@zytor.com>
References: <20260424191456.2679717-1-stevensd@google.com>
 <20260424191456.2679717-13-stevensd@google.com> <87zf0hgc3r.ffs@fw13>
 <CAOiLmNGD08mLKAJvRZdaS7b+3BeR8Ln2G0sEqNCmbD6cRFzAxA@mail.gmail.com>
 <87ldbyhatz.ffs@fw13> <888C322E-BF59-4C72-BFD2-2E71FD8605C0@zytor.com>
 <878q7xspqu.ffs@fw13> <7D930EA3-54D1-41CD-B547-8A2A69F89142@zytor.com>
Date: Tue, 30 Jun 2026 10:28:57 +0200
Message-ID: <87v7b0qvna.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: xsebmes1jxx1of5tf1du865186n6as8w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B3D9140009
X-HE-Tag: 1782808141-439697
X-HE-Meta: U2FsdGVkX1+mIniqauwSkW025v4K4RW1vzsHY1gcSulorxxccAMbBG4lcMh6RmQsMlE9oxL+jpFzadnHbcjWp9ik7Ie/2hUs8Jj0uxam6ymojUDb5Bo4X//7NPak9e/XlkVhOFXiVpyZmY3eWDnq0E2ai8PdXGAc1MWdPhuakccAQ0hDsRgiewh/0muy70qoaOHM1cqsr4wLRWebYOmvNd1MD79hV0DXkpXcmFBb0qXX2Fq2mGfH+LumcGI/NB+Zp2oeKhY1Wm2qmceHWN7kWDSq1Yh0yNiH4+itH0jKQKjvf2cn3ItRZ9G2ikR7otuzS3jVylQStGak7X0vsoNtZ92aHV3chWkUXPveHbc5FVyLcT5uSLih5wzq5papVTWZWeCtTYOa1ENHpdZl0yFwpf8+2RLEfr+joCFBLhIy2/fy2ryFVujcNp42K0V5MoAflZBLlC0sgKgS3SLTHRulVIv4PGZxr2HrXcIeXzqIOAb55ruXvTRMw3gPOyNtwivQhJ6MT4K4PxAHk971U0qq5NQngArCO0Ecry7rn3hstxPC4/Vfg035DgWzXkeUYbamFhq17wUbjmoPvtGFeFWQ72T8Fc2D09dczJceU3gxZfL1llNMWSItj4wGVKI31++7u0nH59O53X9abFVfEKzITsJN5FMg1XRGF5r71n3X8veQD6vHEh95ZorVN+jPxqW8a3uATrOHEt34+78otOVR10/z7fMXJAx2NrWQi91oz7G54GK2EBKfQb+QG6I0WRvSp4kHw6RSkmTWMN6HGjUWTT6bm7nYPZkt90nwKOD3xjF043MJghdAyCVFmA1+GB8m/4S0yvOlfHVoaAZDVE8u8jeqAFNDna0vkcbUtvTPGS8bIQaQrELcV8TxIDCHYzSmjyWHxhAuKpZziiqiL47IoAV+sVoXQ/0CwRTP0d08+dckKGdk4dei/5WmVblI0WIcidRQEWTv6Neb47+Bg6j
 qqLHAjpK
 rC8opzmEQQuIdHPbVz2sctCHiOAobv4iTFU8KE2hD46iRRNeK3LFit0v0p07H/q+iVWGNx6HlFZBu01YfbNFRAiozgJXiFimK1H+QXlmhyhMVLWaevKY/ST0SEuQZlchKxhhdZbLUhBOo/ZYHivRVjGcArMQlPb2QvOouOJglNuVN5fRfXZhUPXXknZne3mSNFYW3WU6JjyfEKVbqui84tCLG+cdkhvRsT3Xpc5mrF0FYwlnickxEu3qKeDpS23xRzVHgfpaQUsxxCmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29 2026 at 07:52, H. Peter Anvin wrote:
> On June 29, 2026 1:41:13 AM PDT, Thomas Gleixner <tglx@kernel.org> wrote:
>>On Sun, Jun 28 2026 at 13:33, H. Peter Anvin wrote:
>>>
>>> To be fair, for this *specific* case, memmove() does exist for a reason :)
>>
>> It does, but why bother doing actual work, if you know upfront that it's
>> not required :)
>
> Of course. 
>
> Then there is the very open question if this thing has legs at
> all.

The jury is still out on that :)

> I'm still interested in using SL1 for the interrupt stack as I think
> that could be a performance boost.

I'm not convinced that it will give you a measurable boost.

It spares the trivial stack switch to/from the interrupt stack in
call_on_stack() and the hardirq_stack_inuse logic around it. With an
interrupt rate of 50KHz and 10 instructions spared, that gives you
0.025% performance win on a 2GHz machine.

But if need_resched() is set the return path has to do the full stack
pivot to the SL0 stack. That's a memcpy() of sizeof(fred_frame) + the
extra stack consumption including common_interrupt(), which accumulates
to ~256 bytes, i.e. four cache lines. Plus the FRED_CONFIG MSR write.

IOW, if need_resched() is set, it's a guaranteed loss and latency
sensitive scenarios including RT will notice.

Thanks,

        tglx


