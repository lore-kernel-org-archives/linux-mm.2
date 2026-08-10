Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C4DC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98F66B007B; Mon, 10 Aug 2026 14:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C47536B008A; Mon, 10 Aug 2026 14:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F3D6B0093; Mon, 10 Aug 2026 14:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2DC6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:22:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05967140259
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:22:21 +0000 (UTC)
X-FDA: 85086179682.27.3B44968
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 608A5C000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:22:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/81SzEu";
	spf=pass (imf10.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786386139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=idH41Udq/zUejz1xnxNcUng7Sk0U5FMVLyHKXUD83Wg=;
	b=EZcLUjhMD8uun4SWtpXvfTrUZefxRbVWE+zJdVNlukOvXLryc0uHhp/+en9zuCCCqNIljr
	6FUtEvetb2A60SV8elV9JfwqqFyrhQQjiRl0Uv7lBq1n/6QY10BbfOKpG+czBINE7frhyR
	kKH1jry/d2qky90BD9fP+7GhRFv2P5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786386139;
	b=M5fWTpZASV5hOrr33OKl/yCp/2QEJzxN7ot3zoz6MwEMyBIqlTyMWgnhGc137jnLIu9Vir
	rAQN2z8UUjVkda1ynDAuWZciKjm9VasVKIkhLtLeeZER9m5uq7mwPkMk1yTVyQLblKulCE
	j6SIwIc4ladAorLQgq9+Y89kdErMI+U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a/81SzEu";
	spf=pass (imf10.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0973C600AD;
	Mon, 10 Aug 2026 18:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABF91F000E9;
	Mon, 10 Aug 2026 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786386137;
	bh=idH41Udq/zUejz1xnxNcUng7Sk0U5FMVLyHKXUD83Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a/81SzEubaTt/dIFO2hAwaZS5EZOaqle/2CQj/skmyX8V6jGvrKP834iCaiDLMUXK
	 GlkecvwKjqnyPY+XdZw7a05hhUJ1o2DmZ10/gXhnwS9e9LYWjvV6l52qeIUHEvPIJN
	 BFZtTFTqSEjuni/b1afAbm+Aep2GMrMPQSoRmZtpuZ/YP8kDj2DiOKXgNjx7ikxlbU
	 rZX/agd/GK8Wl7VKMkmx+zC05A8NQZuKuQ5EciWcqpk3nyucOXVdeQ2gOLoXhlCoxy
	 TgtAWhHIYkPWmE5oS3wLamysaekGTDQXxepiD8SjCm4skpbcC3ceZti0k9keVX0yjr
	 1RD3i4HIH2lPg==
Date: Mon, 10 Aug 2026 18:22:15 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <20260810182215.GA270444@google.com>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
 <20260810161404.GA1930@sol>
 <anoIiy0V-m-05yZc@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anoIiy0V-m-05yZc@infradead.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cnp6c3a3o5q7w7bq1ep59i1ot9i5fatn
X-Rspamd-Queue-Id: 608A5C000F
X-HE-Tag: 1786386139-410410
X-HE-Meta: U2FsdGVkX19/EwiHJ18SW7wX7QWNxgg3bYRTe4gMdBUlMsQSneydJFbPfiU2eoarfrIaqzOF+J/8AdVaJcS1a0/rzbY+6oFSIEyhmfOWdS/L2pEx1C3OXqUxqgUyJR/SF7TfAwwXdgN6zUKF3gNmszOFu9jX0s61xFqSdUntPzjVRfNnVeMrzY2djPivoi22amnHLaD98VIzIAoSGfo+d2veABLAcGOyjbGwNDhVTyPGc+bA7FkjX3V8gDGN5Aj+A3/CH5oohL4ZajLlwTmf6sKZIaXc18AKypbd6PyWdJPN59uo9yfnfs0BByNpVkaTbwhxRUtxebCsyz/kPMp+xWShe6x1oDFmkvO9Qft/i4GDdKAZ7MgQALQFz+0WFXdTXpsufHEAA7Twa7jvjC/GApsZmM1YXhCTvl/hK58i/fn/tByhTls4k/eqMehbw1cn2bFmVUM6JIJra/nn6yRJN5Jlx+CXdrcDniy+kMaXmEbD2ibY1ZrvZhkGu3CkDe+hZrnuFBcqm/hTW1Vo0pdGhGr0JQTtifABLlvhNsSqvfH4qY2snU6wRgiRlqaozw2GIC+ZwBPKCohz3BqhkNr3EvmWegtN6adUCy9WK3mGvPVhCTQrpqoM9K9JdLgXeJTOnx+zcxi1DsDq6xety2duZ2BE9wdNL52medfLz8spnno8O3iGB6j12AKu/twqhCRUUmAfcB3k/LMsa+jU5UcNsRl+I39tvIjkDqgVp9ncYfEaDHKLs+866tAsE7YBn4Lyx0Bfd5bwzkgfy6lIPIZCw+Mm6q4smwVkk9q0vr3cb2dmClylP9x5qrhUgeGHlCC2n7JqHpYrsobF05/7z9KyGG8meb3mue2lG6q1pb6UI+hYqMyoTYWJSi6hkLrOkYSNdYj3lP5aFrFU+9CLFMlemmrm9OOW2ymll5KmWgyL/iugKcW9OPRfU7JF47NTIKAwHHShNjAYPDou69qhmmj
 usgjR5Gi
 z90MilUemaXcyW5Wj3SgNxBBasLT90N41oDWaqMTE44qifmrQ7UKuqcW7Inpuv+krNAMv7M7qu053k10zOTs099kYQbeYZsES3koCmNpCD3C0g+Hnbr/c0IYgAUlniqD33ErDrFRU3zFfmTGN7hIg7ci1bT+3HqsZyz7WGJo3llZNJO+2s5gCfo1hrT+CTw55nnNGP2JpLvRtnXaUZVRlDh63ClztEiKqeiOdFkB+HC+yHAQaCgPMcWbYmKX857BO1nexUBf7PWHmKbU/4daV0lZYFM/YcqBSjmPZ95BJTM8KolUZb89FvMcM6haGTO0Lo9a9InJR6yimJj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 10:21:15AM -0700, Christoph Hellwig wrote:
> On Mon, Aug 10, 2026 at 09:14:04AM -0700, Eric Biggers wrote:
> > On Mon, Aug 10, 2026 at 09:00:11AM -0700, Christoph Hellwig wrote:
> > > On Thu, Aug 06, 2026 at 03:10:30PM -0700, Eric Biggers wrote:
> > > > To fix a deadlock, blk-crypto-fallback needs to be able to make fallible
> > > > mempool_alloc_bulk() allocations.
> > > 
> > > It doesn't.  fallible mempool allocations are a concept that doesn't
> > > make much sense.  Please just go straight to the backing page allocator
> > > instead for callers that do not need the mempool guarantees.
> > 
> > It does make sense.  When alloc_pages_bulk() doesn't completely succeed,
> > there still might be pages available in the mempool.
> 
> But they should not go to a caller that does not need the mempool.

The caller does need the mempool.

> > blk_crypto_alloc_enc_bio() should try to take them before falling back
> > to scheduling the rescuer kworker.  The rescuer encounters scheduling
> > overhead and is single-threaded, so it's slow and should be used only
> > when absolutely necessary.
> 
> No, it should just try a regular non-bulk alloc_pages (and eventually
> alloc_pages_bulk should do that fallback for the callers, but that's
> a separate discussion).

It already does that.  blk_crypto_alloc_enc_bio() first calls
alloc_pages_bulk().  If it doesn't completely succeed, it calls
mempool_alloc_bulk() to get the rest.  That itself tries regular
allocations again before actually using the mempool.  It needs a
guaranteed allocation, so it needs the mempool.

Now, as I explained in this patchset, whether this code can wait forever
for the mempool actually depends on whether it's a recursive bio
submission or not.  If it is, then it cannot wait, but ultimately it
does still need to use the mempool to get a guaranteed allocation.

Falling back to the rescuer kthread (which can wait on the mempool)
solves that.  But before taking that slow fallback, it's much more
efficient to check the mempool directly first, since pages may be
available there (and in fact it's fairly likely that they will be, since
regular allocations are always used first).  The whole point of the
mempool is that it can be used when the regular allocation fails.

This is also the only caller of mempool_alloc_bulk().  So I'm kind of
confused why it would not be allowed to implement the behavior that is
desired here, especially when the non-bulk API offers it already.

- Eric

