Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA924CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260218E0006; Mon, 15 Sep 2025 09:03:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210908E0001; Mon, 15 Sep 2025 09:03:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1267D8E0006; Mon, 15 Sep 2025 09:03:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0046D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:03:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6CCC1A066D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:03:53 +0000 (UTC)
X-FDA: 83891501946.04.8BB434C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4987D140006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:03:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nU9F+PlC
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757941432; a=rsa-sha256;
	cv=none;
	b=dpEgv4Ymr/qU5UflHX/vF2RCMKUAVbVa6tmqnIyM6w04F8RsAMgyjMqq+Vlr5Ua3Hh4ipd
	CabRJf250SQr+xti9dyMQqDKjwhS4KlU8AA/WE895WtjATsAgaiyawcl9g9+g/LRNHM/VR
	3yGcx7WaJI6zzcVZ1ZbiQkNegzYrVKM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nU9F+PlC;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757941432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HecF/V9RIJz47JJ92Q0WH8NZR2yLKdnnccClZz9CwMM=;
	b=IHj6aCZl8ews1c5bnMexgsU3eMoWqhkk5LZ03jkT2qDrMXqyynVKhSE6nbPi7vmyjt1DlL
	9CXGN8bOVgmTMD4laBuV5eLSTxArTktDYSr8dQlDjebvphCOJLn1tqIFPlD3e6Lmn/0IFb
	AdntiiEJtcqC8z2AUStvPdSXzv9Hhss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HecF/V9RIJz47JJ92Q0WH8NZR2yLKdnnccClZz9CwMM=; b=nU9F+PlCB4NHvlRloevMm9huBy
	NPcVaTx208rnn43lGy4pJZkNJo0Cj6tIBgiZ9MuleN4ZTOXHIO7e1u+tJGz1RyeYegSFQ6dXyksEJ
	8pwciMZBLfe2TB3DCbfjj7ClzUFO1LMftR4u4es4hknSiEVumI572pWTlj7DhFAsAZnFvYVBROpop
	eYjiGr+BiGdE+FpkN1eOxoiTPttmg3u7yIxvgm+uh3koonub/rFF1hTuidH3GljkIMTzTHV1vkfID
	Ux7e3yYKQNsr+cEzkh67FPQeiOYKqlW/o0a9NAU2/cKLk8yIcb5JkCyenXGhzf/tocKyK+L9bv+8k
	XpfXhwag==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uy8s1-0000000Fcdi-0x0v;
	Mon, 15 Sep 2025 13:03:49 +0000
Date: Mon, 15 Sep 2025 14:03:49 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Any way to ensure minimal folio size and alignment for iomap
 based direct IO?
Message-ID: <aMgOtdmxNoYB7_Ye@casper.infradead.org>
References: <9598a140-aa45-4d73-9cd2-0c7ca6e4020a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9598a140-aa45-4d73-9cd2-0c7ca6e4020a@gmx.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4987D140006
X-Stat-Signature: q8q373h89xrtw6kpdzwqb7w9kuiwmmco
X-Rspam-User: 
X-HE-Tag: 1757941431-431294
X-HE-Meta: U2FsdGVkX1/I9QykehA4msJ4P+NDKo+Vz1du1EpkQepTKjdj/RP5BgwqzQP/MCrkMssKNUGghqRb3A6GOWuRqZ3h3aTxFyN/kD9k/VgHE1Dl8UAXmDSZausLcLtniXBPqNVQT+dJo6PdPx4D9ofqDCRxcih96Jg6ZM80yk0dh86PgQlFbDQFfd9IlWg5hKKYyfRWGo+Z1Po6nQdgQBX8LLntjDvIin1lQIFcyZc9Rs/Npz1+yP0hYJSZ6RCIh+m0HozhODTjmLFKPiDHRlZSAEGccGoochNgzEOqJUOgNq8TUMnBD3mFAryoa5XkHIAe5Efw7vWC2tbsVCpE5BJYjGa+ejSfDbRxEM/sKrHBRZWKZ58N/6nn1zh83soQYaIMx6vXi/Og9NCmXjrFwAb9QYwEqithHQDHu88LJgVQM/cTvH/s03ZkxC+pasDuhu53XRWY5JJAIUINRHnFPbOVJfOiR2BVbrlbRFJMP3o9uCt6eQAw9G3UK1fC4GXqCftHiwn6wpU2clPJlL20deYTfBjXN8zOlZ20qtxaOb59C1S7OJfrgzlVT5xh5kCFs2t26v8Gu8tkMoFRcFy7OZq6xikZBSvlbX4PQDkkFR56RtzCg0vMu3JWfhkcWOuUFGbNDkv3YXwOBEAQml6GAIOz9NSUtL6UfLabwbbB5J/WxU4fXCbaEBBPq+3kmAoqWpyckpNMybvULQkR9pq5Xr7aCjG9ex5cI0TBQ36NMZ3EfuCsmn3tgpRJjQBABT17PlHpgm4qNNuotyY7JIWV9apzFngPp4x0lumu37tBQyBTeyNAVrY5CllSX6zQXMWoeOvEbiLkpRnWMbB9TiEp7TyyhX3Tf4+QhVSoLDv+ZMRXc7qCHIzc+gYBOoZIl8VzFHCUOLXBPG8S1qk32HyX+whKTLmRDyMt6Zi+WswCre44fRMYy9UOYSPsyoe/oQ/subLaHesRpH4YH8kqp70KRYr
 rBfkFQVy
 pHZSRyQH18/kNVsITtpwqTT6ydynKsW5iXAHfQ87kjvr7Fl/eM9NTk3jtL7eC9ccb1nHWuGzX1ItObtaXG0sT7YajYECs+62yfiIGejgvB9EqyGg/oZ4WzACmVgLfzh7vPIXo8aOhzj2SYxMPO+0u+agmzEso5H8rh0fPpgStHp9HGLGEIYs0gRmSRgkNfKUH1B3Mj4TayVlEs+ze5ip6lySxU7j5b/Q75i5rcSugle1xueSdjxXqRxGuRrxWaznJhTkpMKsAOtm8i+RKpxhtFvEboMcLjuKMJ6p2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 07:32:53PM +0930, Qu Wenruo wrote:
> - No fs block is allowed to cross (large) folio boundaries
>   This ensure that the btrfs checksum routine needs no multi-shot calls
>   for a single data block, and ensures we can use a lot of
>   bio_advance_iter_single() calls to move to the next block.

That's true for pagecache I/O, yes.

> But things are going crazy for iomap based direct IOs.
> 
> I'm getting the following bio during my local tests, which is using 8K fs
> block size with 4K page size:
> 
> [  130.957366] root=5 inode=2464 logical=15974400 length=8192 index=0
> bv_offset=0 bv_len=4096 is not aligned to 8192
> [  130.957376] i=0 page=0xffff8cc616e96000 offset=0 size=4096
> [  130.961977] i=1 page=0xffff8cc61730e000 offset=0 size=4096
> 
> The bio initially looks fine, the length is 8K, properly aligned.
> 
> But the dump of the bio shows it's not the case, instead of a large folio,
> it's two page sized folios.
> 
> This will not pass the btrfs requirement, but weirdly the alignment check
> for the iov_iter at check_direct_IO() shows no problem.
> 
> But unfortunately I can not find any folio allocation for the direct IO
> routine except the zero_page...
> 
> Any clue on the iomap part, or is the btrfs requirement incompatible with
> iomap in the first place?

It's nothing to do with iomap.  We can't make the assumption that
userspace is using large folios for, eg, anonymous memory.  Or if
the memory is backed by page cache, we can't assume that the file
that's mmaped is on a similarly-aligned block device.

