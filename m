Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A9BCFD371
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7ED6B0030; Mon, 24 Nov 2025 20:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468346B007B; Mon, 24 Nov 2025 20:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A41C6B0089; Mon, 24 Nov 2025 20:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26CCE6B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:18:19 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B9A2B4FAA5
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:18:18 +0000 (UTC)
X-FDA: 84147368676.30.25AE973
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0D2E7100004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:18:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEut25SD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764033497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teV0E68AlALeSUja57HXesBv832ktMdeUmeP+akVZP4=;
	b=AwWKmHJkoodZDcuQlN48A0+s5KdqxOfRWoKFSJmL83b7YHX5PDYxro90AGNfwqd3K/XI9f
	ZxqfTBtqpLs6mqvM2XVOxTtNl4+yGUQss8fNBafau32FqLh/XRBzANxZIxHhxd+ZTAQy9j
	7tpTb8cJcE7sz3iwjjYhEQlQIDaT9dM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764033497; a=rsa-sha256;
	cv=none;
	b=8GX7R6MuxFPoYWj4IybTBKak3YOJUkkseT1dq+hnvZwhaaXTTlqlvMCCNXu3OQ3DUp+sMb
	EueVBR62t3hKkTgsw8PJLMcGmbo5eNiS/Z+Xdo0AYASlI3gZF2jy9cJ/kl8y/c+U7UuYgO
	NKKlnrN/j1xGeDmOzA1XThNSyGzNui8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AEut25SD;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEC16435E3;
	Tue, 25 Nov 2025 01:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9532BC4CEF1;
	Tue, 25 Nov 2025 01:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764033495;
	bh=+2cgGufVo44/HmTgm2hDLVXFZxT+/fKOlp01kamj9o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEut25SD+vng87R7XeaR2L7VNOmfVGVWR8pCR4lj6hxHh+55pTmQmBMT709BMzQLW
	 CB/33no3pprN6vVOd2QzKCvVyeULRCz3POv7imFfjNXyGnZTpLULF7gmChlyxwBifx
	 pBM03+YdvpYUyEb5DO+ZToSnYQnEoNcMiWFJC3HIx7Lt9yCKjPR8KvwMpxj8mVU4L5
	 Ltm+Q3RxvDJeHTPxK3sM8R/KE/U0juXpWlQchg5c9iqzn1pEyIyhtDISzxaM6ecoar
	 6N4e9v5BZe1yCJ2dlVWTg8rTnzyUCPkRtIwv1+4NfrhW73SqcchrVEgB77yJ5EWk8k
	 zEwKllGgjkRyg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/mm_init: decouple page checking and init_on_{alloc, free}
Date: Mon, 24 Nov 2025 17:18:07 -0800
Message-ID: <20251125011808.74845-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124225408.2243564-2-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0D2E7100004
X-Stat-Signature: y9ckpipg7y6chxt8sk79dikib71ski8n
X-Rspam-User: 
X-HE-Tag: 1764033496-631873
X-HE-Meta: U2FsdGVkX1+caNrJJWgFRh+wiDw7RvprWzm+wnUf7WBDSk5Zlg8eFFtbsRx7pmxeewhnNgACrhOppvxFacU10phmFW+AHOqAvTuNoIU6Uc4VxHKnZw967fCTZwbvV3qZL3MtIVQ/F5hFZ55KkEaXQCI9VfjrUrj6H8aGYsv56E4DhM4aDnnu6Xx6ilF7rT1C1tWBC9poU/+L0M/G7MrzNcIovbC9h+rH1nrBNEN2H+25w0WkpwNf51W4LLRGmof4Fc976pMFPeNeOECOcShDNJjN0hM94Tz/KU2aJy+K4B61O/WmSD0yNyfHo9q54AxR/GYB0BEdMX+A+LVqjKMKQ03glT5JLv0QO03CuxwTAReIC3HjGN3msjelA4Im6y/VFrWomTZe1UXZopOZE/UH3KLaNWXTXOoAXQCJAM0TNI/oLKlYChiIBfDGgXVctV0xY9ljCMAMx2X9EVuwv97xeZFkiHqNm4DNuOuO41JPhswDkh+17wbI4Iznpymx0JYovmhUDV1yHJQbVCke5aI/Ngg1X/+0clXgJwND8s4I+81Awjpl6bzWbgkUs2td/q5TjcmDH0MxLE6NG54tY7PouAStyoXKJt0ibqvdLtTYT+AjEb5AVCKEAmwP5bRNq2+zkxxsfyUVbIGWGN9AZp018KVu2up9qje+8QsZJMJXp+8WMYipiTSP9CtwOmeHk0TkY0to6Jt0NBucLdSdSsUzRe9E/5Z21ocrVCnVJYA68lCiBHG/OFv3gVAy9giaqyjmfdm2B/tAVEsbN9A6dqonlevG4k5ryrCKpZ5bGG8jPn1aICo9HGgBRPaUZ8869/NpnhBjnhYMEvZ2rAk8x33Xte4ejuE735K02q+qKcWjDdHBozOWaZ2/o0bzOdoObmt0a0PJ2czXjVEXbk6O2J0+yTa0ZMc+ruJW6yyFxPT9lFzQ5W2FjfxNHT6EuJeFuPHZAKQ2E/tl+6wYUi1CAQ3
 mdlN687u
 YpVKgU+EGOjwbsRiWLaMdAqg4mZCaaSdlrR8gVP3+j4JXLjfYA/OI0Rew4zIVg6N1il10PmcBkcejzf3cDoc0nw6dPQ3o76yVuMee9NoLQzUvrBqCuTynkBQ8rAFU9mdv4Z4VXWxQJpi4O2Ipl0Ux2zHkPKc/mtKVnjo4oqu7NkYH8GvDA7PmPUvzghxaTV3ULgrYAgmesW13JTyYF/TxfsHXY7IeWZLZtvaoWeDIuCszTx/hr22iMCR+fDVBJgXxTEGrJjKQZV8A9dAdhmL6fR2i/uN1mIGhVh1EVtbhXFcc5fKDF+N/PdqJZgACx9CNIrijcqD5ed3Id1RUAbjL/78a1RACUJwNdpjArjIsyOzBatGorfgUDJuaKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 14:54:07 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> init_on_alloc and init_on_free protect the kernel by initializing
> allocated and freed pages to 0 on allocation time / deletion.
> Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce

I think 12 digits for commit hash id is enough.

> page alloc/free sanity checks") removed page checking from hot pcp
> drain and refill paths, and instead coupled it with CONFIG_DEBUG_VM,
> debug_pagealloc, page poisoning, and init_on_{alloc, free}.
> 
> As the commit suggests, the first three turn the kernel into a debug
> kernel, while the last hardens the kernel against leaking sensitive memory.
> While enabling page checking is relatively low-cost and tying it
> together with page initialization is not unreasonable, it does feel like
> a bit of a side-effect, rather than an obvious consequence.
> 
> With page checking now pulled out as a boot time parameter that can be
> set independently, let's decouple page checking and init_on_alloc and
> init_on_free.
> 
> As a direct side effect, systems that have init_on_alloc or init_on_free
> will no longer have page checking enabled by default; they will either
> have to pass the check_pages boot parameter, build the kernel with
> CONFIG_DEBUG_VM, or enable debug_pagealloc / page poisoning.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

