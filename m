Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8190B10BA445
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12436B00A0; Fri, 27 Mar 2026 04:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C2E06B00A1; Fri, 27 Mar 2026 04:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFB46B00A3; Fri, 27 Mar 2026 04:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8283E6B00A0
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:43:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28E101B96EB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:43:25 +0000 (UTC)
X-FDA: 84591203970.26.02FE0F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62BB310000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:43:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CdwmAEK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774601003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWv3283qDDaH0F9gL1ambYuPHPHnEYdrJUAhVXf9o1k=;
	b=sNIEYbcDrloEkpGSUuirGik1icwltROIbQE2splYEZ0QrW4cfeMI+hzBChGVPn28rxjVt0
	6MRUDoF/aRYOhbSRoOCEsQHPdHXdIF6l6QsCTUf7vPFC/9LfCw/NLwUnpiysvUj7RzyD5Z
	TL9DB8yGontLw1e5ZW0h8WeVv5ywmyI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774601003; a=rsa-sha256;
	cv=none;
	b=1Y6CZW7s7Gq1D6qy/B2ib0j+V5kWOl3maaw+zxpGWWyeg0KF+AzZgRT3Xqfg5QDnzXhs+F
	KR6MEDDece2QA7xCMbf9kusbNmQU/5H69zVgGwRSOD1ZLYEJsev7X9sDhnokVDoTwdpu5a
	Bqj3wr+hWaXYEYSHV7dcn/Jn7r8IEyc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CdwmAEK9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 26C0D40A6E;
	Fri, 27 Mar 2026 08:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECFFC19423;
	Fri, 27 Mar 2026 08:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774601002;
	bh=uSAEwv+P0NWX+V8A9QMICb6Q1yjjMb/K72DG65M/P6s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CdwmAEK9/IFM+EMSgv+GZ9ZiT76lRLLB86oWqQrq7C2uu9OiZLoSUXMc5BIsA0J00
	 IBMD0wPdVdFw4GyPS2ZKEvPE4iHbRUP/T2GgfjNh+seLgDT2o54Z6zZWTUt/k8nRlc
	 BF8aTp5KdnIH2qwAsAPnfy3OeORNSRCOj8UuzNJ+5UziM0BxVWkPCGEK2SvUxmVv+o
	 D+Xpgtx/RoNNYEJ29wK0jydMrqjUvCT1kCUWo+KywHkKhxUy2T2al3sO5Lqb6NVilB
	 f1dFDPvgKgA1A7bA2qCxhjUqluqXr+Ds1KHhO57uUaEkxyDQJekZ1WZrn67Izo3csm
	 JuATilun0kMpQ==
Date: Fri, 27 Mar 2026 17:43:19 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, hao.li@linux.dev,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
	linux@roeck-us.net, andy.shevchenko@gmail.com, hch@lst.de,
	Jeff.kirsher@gmail.com, Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] mm/slab: align kmalloc to cacheline when DMA API
 debugging is active
Message-ID: <acZDJ4Nfw4x7HCSr@hyeyoo>
References: <20260327055846.248829-1-mikhail.v.gavrilov@gmail.com>
 <acYlxRBhSMcwBnja@hyeyoo>
 <CABXGCsMTk6kDuJxsTAUKP6npTvp4X6Ryng+P4xjMUsPbTA43+Q@mail.gmail.com>
 <acY5G-lKZQEsUbRw@hyeyoo>
 <CABXGCsPQo=Npum2aHet3QkZWkWEnEVMAw0KQ1AHPrNjMn=9bmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsPQo=Npum2aHet3QkZWkWEnEVMAw0KQ1AHPrNjMn=9bmA@mail.gmail.com>
X-Rspamd-Queue-Id: 62BB310000B
X-Stat-Signature: t1djpb4dfgdkkqunquya78do14fpo371
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774601003-865167
X-HE-Meta: U2FsdGVkX18ZkXwVne9fsz9xAptK/kCk+n4SeL35QpBZjZaNachUR5FcA9RjUJ1uQnzTj86fP8onleLL5UgyJxuoNUaUAv4ar3YDdJ3APiKl7UL+AkziDfYbxVeaUJNHjExR7o37NNH9DOtR6DoRFCjw3AGTYMHdEZLRK9r3l4bmxPKqTJ37y0nzEYB5EpQi4bW6UMlkPXYYf40lhsUVf6lmeDvEwuWc/ceqUFTuR8x1oB0ehCqZXltOMcfrTvqPwo5xI1i8dKYp0WS/67yfzg7Gamm73BA7OBFJTkS4f+sH6u3K8yxVQNqqOGGqVyBRvAybKjHpqQdbitexDxCSdqKdUX3JNj7C0n680/fFMgnxDjkC6q74mPiB8Apl4RAA/8kvbLRystfqCef/1UVkjngX7AyDcjnfpeBzdKEOeOUVnCf72ZldOXXA023R4daor2lfk7JWYzwkoXRz93I9Cl+Mp0cWC7FGvh6OX+In/+P01mNG45bKZbN9O5l9mJljBA+z2j7JqB+6/3worATfcYB9K0QM3gC2CyJZAGyDKDjIAakFZvqeyaN94uan2x2CARH/X+QsSw+uR85ysSkQGSjKaMOED1Z41FdLuE3tPFuVqTppRWfd1TxS9OG8KN1E00c1RCIEi8Emrp+EnfDtZ8VvVTiR1mtt7dhBysbyjeUCsM3/vznyj+2UuvKhVgUugJenLaQ+FsPIyI0DHtMh0/JgZpvj18zfwk3Iw74PP7XUCQm6Mn4MNkK6qOczcSaEtxAYXBGdVT4RYKiWQdwj/igotq1sVL/5yVvg5aQPpNat8uJ+SP/OlVehiMPHRK9Z3/Wa0QnL9ZYjbf2cIS+CfayOwE8AeIvr0WnBWJrEIDQmR3MM6gSC2sbifLA7kx9Z9/xSxx/c1bSq4D9iSUwKXsHf1Scp/FBZqyWkVf4sn4FSWjkueoOA7M6S+xKd3/pqOo2om3v6cOkttJ1vPGE
 6yorsS7t
 bLDsXn1L6I1AmVONSSdE3jdZTRsteRgsynBfkRkjqf6XJQNBCwQ8Vf4HowieNrFaaByImwNxPYKKoZmNwG0mTcp1vFNcXTtncxXchO7QTaZDVhUgDuaa+oFtUnoLy4DUjBqBj0M4dGKdtbZY4GoehkM9izIivAa3Zb9TPSVGSf9clJ0FZ+GzfVnPVtm1WQ5RF17jmvJoKuuSMUeadp17uQoa3bC2olJ7w8uSqOMO1Njlr6xYypuipbMRWPEpSdieuM+6hs5Ph1bSpu0pSPSRHBXOcX99Lzymu4A2Y/2Qym15+bgZLiaqvvTql9neGMZM1uoCPaQxw99qwWPDjKAg+1dkD3dwbD/aRNb8g/U9FpOekBlpDRO/tn4stcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 01:07:21PM +0500, Mikhail Gavrilov wrote:
> On Fri, Mar 27, 2026 at 1:00 PM Harry Yoo (Oracle) <harry@kernel.org> wrote:
> >
> > But dma_get_cache_alignment() < L1_CACHE_BYTES means the architecture
> > actually allows overlapping cachelines, no?
> 
> Hi Harry,
> 
> On x86_64, dma_get_cache_alignment() returns L1_CACHE_BYTES (both
> are 64). The condition (dma_get_cache_alignment() < L1_CACHE_BYTES)
> would be false, so the check wouldn't suppress the warning.

How does dma_get_cache_alignment() return L1_CACHE_BYTES when
x86_64 doesn't define ARCH_HAS_DMA_MINALIGN?

> The problem isn't that the architecture allows overlapping --

Probably what I said was misleading...

I didn't mean "the architecture is fine with overlapping cacheline".

I meant "not defining ARCH_DMA_MINALIGN or defining it as smaller than
L1_CACHE_BYTES is how architectures tell kmalloc subsystem that
kmalloc objects don't have to be aligned with cacheline size."

> it's that kmalloc returns 8-byte aligned buffers that happen to land in
> the same 64-byte cacheline.
> The DMA debug code correctly identifies that two DMA mappings share
> a cacheline, but on coherent platforms this is harmless.

That happens only when the architecture can live with that.

> Adding a dev_is_dma_coherent() check in dma-debug would fix x86
> but would also silence the warning for any coherent device, including
> ones behind IOMMUs that might have non-coherent paths.

Sorry, I don't understand where the idea of adding a
dma_is_dma_coherent() check comes from ...

> That's why Alan's conclusion was that fixing the allocator side is safer --
> it doesn't weaken any debug checks, it just ensures the situation
> never arises.

-- 
Cheers,
Harry / Hyeonggon

