Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75234FED3EC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28C86B008A; Fri, 24 Apr 2026 11:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00656B0092; Fri, 24 Apr 2026 11:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E6B6B0093; Fri, 24 Apr 2026 11:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF9D36B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:54:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73D431A022F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:54:02 +0000 (UTC)
X-FDA: 84693895524.08.73D957D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BBB4B40016
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:54:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UCixd85V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777046040; a=rsa-sha256;
	cv=none;
	b=krzyC5KacJOEjUQt4oErRRimNLO8Pty9QcR9GTvb2IngqCzWhtJ2m7cG4HKqmodPnc3bp0
	20YBBmf6z4kirKMcEKERPS/AfoJrb/bhrcN7CedJVY9vxrcKts9dtbRL6SbiktaLYN3Stk
	IrfbpfQ48EX9xXv3ML4YbaS/T4mO9/c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UCixd85V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777046040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jhixw9LE/eoE5ENGIt2g7/waIGAJqNUyqL7AlX/L2g8=;
	b=jIOuaF2FC/YEhvxGKtTeEx67eanwlxC3+Qxa7QXSBfE3o2vMVgsLY+z+OXgh0QGglX+nK7
	CLeQS6T3vMCd4aPud2MfT2Aq+EXdO7FnKWWnfb1qUpl6BctGo/h+pcJxXDjb4zOIe3/MEH
	LCIF7Cg/gBIAimWAucXq4O+WhxO56TY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8271544449;
	Fri, 24 Apr 2026 15:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277C0C19425;
	Fri, 24 Apr 2026 15:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777046039;
	bh=L1qvt9XFmKqHuBL1luYsZv9G/s41zEhYQsK5r3exiK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UCixd85VwId4bqsHLmqNCoDTR2MYJm8+INbqMo/JyDU6Bd6W8QxEUsNRNOk5hcEHN
	 6nfDzJ8wOunIAz7+NbcFhjEcKl0X5z25xjIDav2SO4h6K+ujR0Z198EWEqN3nKp++/
	 8Sq5sUmfGu7h3lSguPSUMwuQQZGLRWeCOgTpxSfi1vDDIBk52pKVVqH8XfxYm6+rf2
	 6OCtZRLYzVQp/bPCtRdv6cJ2MX6TNVxHQ3bVKdh3mknIiCSHsYFH96Z3AfnJQk4EwX
	 pdyzEAssBR6sd99ee/Qx/2TX38FkKQCh6ZQzZWvld5WTzqeQ8aEypEDRaCHjdmzbJ2
	 23m7B8PYQoXKA==
Date: Fri, 24 Apr 2026 11:53:57 -0400
From: Sasha Levin <sashal@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	skhan@linuxfoundation.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Message-ID: <aeuSFV6IcfQ0lifO@laps>
References: <20260424140056.2094777-1-sashal@kernel.org>
 <aeuNdOmgxA-k9BqY@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aeuNdOmgxA-k9BqY@casper.infradead.org>
X-Rspamd-Queue-Id: BBB4B40016
X-Rspamd-Server: rspam12
X-Stat-Signature: t9z76zr3sewznntz5hyjgboai3rexs6s
X-Rspam-User: 
X-HE-Tag: 1777046040-278949
X-HE-Meta: U2FsdGVkX1/g+oetPvn7Kt9VsYKSuJfcXLaKXFEijf1BoUl+a+myfKyuJdGSpTet3NsmU67/QGD6GBAmOsxnh+B+P5KdZslKOxE7KmsEzeHeiA0g2gxVZ68/y8VAEofBKV6fZevfFfFB793hsmM9mB28QiqIES+9OhX+WVeToIfMleo+GWfV3/tTPIpctWsowY6KqEKutt7m9v0NfRuv5R3yWMN8stPMPueMW+afVhf7PcEkDht3pWtCO5s2E6STtP7V42nCfjrRQA1PS+gFZjgXMi0R5O85qBldE7ykJ3BHCsTxitYYoQxKCbow43D8Uv9HgPmgvueHozUv+h0jKgeOne9bqIcshIKttuCKOBLdv6VRF5eaWW8UDp+z3/iBYJ32pC/Nb0CVj2qEtCL+TYIg5bAqYRTRV4FbtHisLtXcn3xMpGxbkRy5RDa3XpYojWD5aua6GN8rzYQp0diNdoh8++qV45wo9nKeZdwlWIAXmDOLASQCU64NSkIbr196BE5xIxl4gIqyEg/JddOEGpt2f6arfw6GbMAbiHsEON6tns+PRabBKeF9ZiJf7cs2I/t7GctJsEwi9zd2qj89HSh/87D7MY+euNHsdHe2vE2Frznnv3Z483YNi8PSgpfThN4CfN8zAAnlffAx4i6hZa4ln6q3s0Ni09czqe5xbrXAYrYlb6B79bVVy+0yf8W0vtF/Fq0or2YBUESh/9Y4g3Vx5N6DQdttIToTgQ293YS9HqMMavNDHmqBZvjNZd/cj1F8F5CspE8ECLEPd1+7OMHoz0W/OG9w5oDLo4ogi8plo8OuUDrrl/2kvEC5Oq+TgCgoRQolWu/l55TFo2QbIm4aMP/5jdpB5tvaJ0HVwWc3P7rFHzevJMe+666mDMd/tZO44RZVdhvqYT1F1cyFUggoLPx+pfPBbbPimOKossIbWHBfLSqT1wt/vvmmJK0WFaUzwO/BhkxpSL460ED
 CuHBGkGj
 Dlu6kzAI1t1ZTOVRMSeh0Ba3bIh8yJt6nrhYayOl0NL1i8ExabrEtr+7H2CreD5PKeMAbr6uxVevPR+d5qSghokf+g3RzaygNaN+kwfO7atMiSwvmn+dr4UceogYLrG19AtzgJ4/QAiHPJ659iFZOlUAwVyVYmr/hdezZHiSiHxcXfe4qin6w/+1/LtsA20AehZZ63kO+tDp2U4eMWV+ryqdUSRC68ThpMzgqn8UEgFDkBRj9KGbYvG5por2IDNDZv51qT4BUaDBn9dz5ar7JwHP/Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 04:34:12PM +0100, Matthew Wilcox wrote:
>On Fri, Apr 24, 2026 at 10:00:49AM -0400, Sasha Levin wrote:
>> corruption must be detected before it propagates. The dual-bitmap
>> implements a way to protect from corruption coming from hardware or
>> software - two complementary representations of page allocation state,
>> allocated independently via memblock, where any single-bit fault in
>> either bitmap is immediately detectable. Performance is secondary to
>> correctness in this context. A safety mechanism must be simple enough
>> to audit and certify, must fail deterministically (panic, not
>> log-and-hope), and its correctness matters more than its throughput.
>> The dual-bitmap adds two atomic bitops per alloc/free, but for
>> safety-critical deployments this cost is acceptable because the
>> alternative - undetected corruption propagating silently - violates
>> the system's safety case. The static key ensures zero cost for kernels
>> that don't need it.
>
>But doubling the storage requirement in order to achieve merely detection
>is significantly worse than state-of-the-art in 1950 (when Richard
>Hamming invented Hamming codes).  If we used a (7,3) code, we'd have
>SECDED at a lower cost.  Of course, there are far better codes available
>than that today.

I agree with the density concern. I have two reasons for that:

1. Update cost. On the alloc/free hot path the dual-bitmap update is two
independent test_and_set_bit. A Hamming/SECDED codeword needs a
read-modify-write of the whole word with locking on every state change.

2. Correlated faults. The two copies need to sit in different physical memory
so a multi-bit fault (row, column, bank, row-hammer) can only hit one of them.
See this paper which has some numbers:
https://dl.acm.org/doi/epdf/10.1145/2786763.2694348 - About 21% of DRAM faults
span more than one bit, plain SECDED can leave up to 20 FIT per device of
undetected errors from those, and it only helps at all if data and parity bits
are spread across physically separate cells.

Two memblock_alloc'd bitmaps give that separation for free. You could
interleave a code across two independent regions instead, but then
the invariant check stops being a one-line complement check, which is
what I was trying to keep simple for the audit side.

-- 
Thanks,
Sasha

