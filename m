Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A707CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486886B008A; Fri, 16 Oct 2026 03:46:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457F26B0096; Fri, 16 Oct 2026 03:46:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370C46B009D; Fri, 16 Oct 2026 03:46:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3966B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:46:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BF0FC02C1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:46:22 +0000 (UTC)
X-FDA: 85327706604.27.ADF6210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A21D3C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:46:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WJ/WoHq+";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792136780;
	b=yF0iOCuaEMEw15Xlo3329dZ+jFW+Ghm84u/KzLKIOUTwG1U6tTjM2Hsm1BztV92vOwRbs7
	8ermkgrz6Qk04lcCDWaK3a+JC8OgiHSTOPjVkqPHWKWR3E2pcMM1S61hZL3RXNpqIXO5wU
	7yaPz12AlWcJEh3I075xXz4zjqIpp78=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WJ/WoHq+";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792136780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/5cfg4kcZ+247ukxIkzBDbMpFjAapYr13Xc1y3GaQfY=;
	b=JprcrSlEIBnzjfs7KMoU1nhb52lKmBKMpjmvcqEhKZ2ibNjoSjS+YsgqOVxN336kYIbS/6
	P9reELLLJohkjnqeX/oSrbmkfiAkMn9l1nJ0wzUuRYy6dHnJioNqcUXRrn4s8/BaoV4FzX
	YJwXmnJ3venyCTkkECk2WOJz67W3s/4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1032E43074;
	Fri, 16 Oct 2026 07:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9901F000C4;
	Fri, 16 Oct 2026 07:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792136778;
	bh=/5cfg4kcZ+247ukxIkzBDbMpFjAapYr13Xc1y3GaQfY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WJ/WoHq+G5+/VU7Kyyrai5GRSG6o0JrxOP7WCJ8mNdYN3IKCeHPjzRU/g/Sq+rK/b
	 WU0dWDjdXQglO3oBvt/xna8WCZ7GkvVPBAei43hYv2SsTetD0NoGJZRHVvBVcsbKiZ
	 ftxmS0e9zXm+rotYpp+9YkhA1HFqCd74p5uF4jWkFqbjqMQm4p2WprJoUoAcZecHwx
	 YzUIJ5w3YFFdk3aV7piDjzx5BvYKu5qdLCnlCA1c8qzL9kx7ENvMQYwa8txxakaBpt
	 BUO4zi7Kw1YCF6udev9Kx3Yn8rsPvcoDV1a/VsJ5zafV0GOE7UQTQn1dK/PuPgclUn
	 snZi6t0oPrvvg==
Message-ID: <1d850e66-2c8b-4912-829c-ab620de833e5@kernel.org>
Date: Fri, 16 Oct 2026 09:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_vma_mapped: continue past nonmatching huge PMDs
To: Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261016011549.61146-1-kylebot@openai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261016011549.61146-1-kylebot@openai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A21D3C0004
X-Rspam-User: 
X-Stat-Signature: nok4segubgi8f14y357ykrakz197h4c8
X-HE-Tag: 1792136780-614349
X-HE-Meta: U2FsdGVkX1+3SK87Q9j3cczlK/mbzJYiLUXmydqxiOnaAZj+X4J/i1zcO+BWFaHMCyA7aFH3hPrzIMryVqzsIQBiDoLEALMWu7L5scNrNQ2SDnyZ1SwT60ScYm2RHW7xGxkCQhnjL0qw8wcgqeBJkDMtyaEAOL6v+7w1A5ruvUKdsCAS54juqLSpi4CyNQJi+6UA2oKQnMADRpEeLbuw7QWFlBahZSrkIOsjPIz/ZOHL0a4FH9OwX3DYuodlBiXvE5mgXZMnrhQOvm/gFE4vRzn/iWBkc010wOyqA/aHdtm99M2uZn7R4GFRb8WSStw9f3Wxeofu/cDWnUCDYl9mg8s1+sgVmgjwyH3mltpcSCfhYS6yt550dWHU2Z81u46xlfulNou+fA57O8+19cw5kyTqyG77ytC9v++KzrA4baXH4SkEGSzYrTSdjoXGdvFJbZ55ouxiWBcSpzw0R8UUfp32vBchgyx8HWv/mlkfBPT07rvMglcjnlbR8r9m7uqIhQmhSLMYKUC7yNwquZZ7X5+cFJbHhXlVESeUCPmFRmOH0+3NVCmGXT0WQt24QCpW5CDRRWL4+5KNi1D96FILYhfOS8GXzvIqCRodJQNTx9GENZbpU6CO2agjAb0FrSMCR62X6U9rb/FzKO5vLpLSKUbN0qnS3jrqClR9cxhU5lRaBFvnxPfl0TbgHAeeacaJkf+ZHJ7Z5uaApUG4+woZcakJCkIZ17cy0aoUqZMJsHnPkXFwg6Mm9x+BiLfIeeJXyV0AS4SnrekYfXSPxRopIva/idULi9cboZ8dLaECHZ6Jx3WtkiVq4VEIA6kLlwgwG8wCEj0rVx4rmZMwOdiOGnRnbdiGZdGBxva6yX+QI+5S5JdbOwQkdSqKY/6mjk/ZJ+yPQuU+k87kdZpcTZ5d+tIlJroVM6psIdDGpIsVEj/nshLrl+my6LgZlxqUtvube8MAN1WI95OGMoPvOqd
 z2JNUEV8
 79LaXtIueazUXyXrJh9CzTiWl0C6Lx2nSqpCakhdrc+Qi33VhYxu2jKI6693bptrYb5H72pyfTGg7rcXDiogy8A9qa6/GlVkmXXuXDTtTkj1j7TUr8qGO3KT2gzM3rzffb3cGOSSZgt+h4Wr/zGebLlR4cAnBpVQ68Z9z5Qgik0H+ped7YZuFesJJD8zgqD5W2ryr26YWeXYJct/uWljsLgVsyHOr7gftxILi6EyQ8mVcMQptEgL5NKxIDPXr8BUo/Qh7pPjrKAfmVr5e8DQfiS9IWm++/pocmh8h38kNBzTpagUxlXa9DhEANwUVraeQyJPKdvY0uy1T1QNB9ureGu4eAA5cTI5Nj+7x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 03:15, Kyle Zeng wrote:
> A PTE-mapped large folio can straddle PMD boundaries after an unaligned
> mremap().  If the first part is discarded and replaced with an unrelated
> huge PMD, page_vma_mapped_walk() stops instead of looking for the rest
> of the folio in subsequent PMDs.
> 
> This also affects migration entries.  A walk that stops at an unrelated
> huge PMD can leave migration PTEs behind when migration or an anonymous
> folio split restores the mappings.  Those entries do not hold mapping
> references and can outlive the source folio.
> > Skip the current PMD rather than ending the walk on a flag or PFN
> mismatch.  Do the same if the PMD became nonpresent before the locked
> recheck.  Release the PMD lock, clear the per-PMD state and advance with
> step_forward(), so the existing range limit controls termination.
> This covers present, migration and device-private huge PMDs while
> preserving the matching-PMD and split-to-PTE paths.
> 
> Fixes: ace71a19cec5 ("mm: introduce page_vma_mapped_walk()")

THP migration was added in

616b8371539 ("mm: thp: enable thp migration in generic path")

which was a couple (3?) of release after ace71a19cec5. Doesn't really make a
difference for backporting, so we can just keep the Fixes as is (it's the
obvious right thing to do :) ).

> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM

We can drop these now.

> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

