Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B177CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:50:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6472D6B0088; Tue, 13 Oct 2026 05:50:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F82F6B008C; Tue, 13 Oct 2026 05:50:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DD86B009E; Tue, 13 Oct 2026 05:50:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36AA36B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:50:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7DB71A03F2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:50:27 +0000 (UTC)
X-FDA: 85317132894.04.0AAD243
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 23C9680009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:50:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmJPBX7E;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791885026;
	b=PBUW1Di7rLWDc4AB9Mzth7TKHS5YXyBj98j3D+oEVxYyG8O/uS/q68SrjfbOVnEZAlpMBk
	cLQHpPJlzFAAlkd/UCswlqWN93plkale24C1qiZqCt98Wv+2dX7Gs5mdNHm8s+om3ZEYnK
	q2UL8Y4nhMWRJDvLVoCrXGJV+YqQLE0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmJPBX7E;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791885026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2L34z+bOs84sZoHi9G7zWfo0PJtuhsn1e2vgvgH0gTs=;
	b=ttIP8MgzkeLMBJrrKJtMZALRpg8N+YxM74yNvuHoyD6oQ6PBASq1GJaMDayY5Y+D2CjDlh
	zfCv/Ox02zzFR5RUgfRMya0CX30lmepOaxXYvyeH7LSkkW0sBuslobYqNYUJJJDTwOV6qM
	YpDeWrTa3/l1UXJJpmxDPxl5eJZU47w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F076E41633;
	Tue, 13 Oct 2026 09:50:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B311F000FF;
	Tue, 13 Oct 2026 09:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791885024;
	bh=2L34z+bOs84sZoHi9G7zWfo0PJtuhsn1e2vgvgH0gTs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=HmJPBX7EJ06gfSIk/CPzPyZoB06dosq4VlKJU+T82QwD/Ema0z9e7cWcjFxJ7m4Ca
	 pxERnuW6IM+dTBeI/b8GAhY5K+O+CL0P/NUynQSIlLgDFUacZQ+OTt0FZoTpFOa3on
	 Pva+I8hRzTMMXj7wF04jZwIOOK+HYCig1O2JUeJ36SItVZ9txaZWI/wWh3QhKgyv4L
	 pBhLWlZecUxnTD10zjL9UTxq6U8GfhmLpzEMlzyVKB7E0ZxQ0My+AC3W+GUd9uGNAC
	 J5x1O4lU+1ThKoH+XBmOBoLmZiJJwHWv+O6eYsl3rJywvywi15+BgUqH/w9U2IoQdG
	 PfjT0qyiyfbjg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260919135327.74089-1-kaitao.cheng@linux.dev>
References: <20260919135327.74089-1-kaitao.cheng@linux.dev>
Subject: Re: [PATCH v2 0/3] memblock: Remove unused exact nid allocation
 API
Message-Id: <179188501773.4183299.8247277870365097333.b4-ty@b4>
Date: Tue, 13 Oct 2026 12:50:17 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23C9680009
X-Rspam-User: 
X-Stat-Signature: n8koa8ui59fee7hk4p9bskxkadk7fkaq
X-HE-Tag: 1791885026-602544
X-HE-Meta: U2FsdGVkX1+Zgj/PstPQTqauhbqkDVZK6DyryF0u8Fq6mKm91u4koG41pZ6I77RJiuPCRUEYcNn/s5XaJX+BtBxgwaoSlp0vj+2sESLvWxF0CnCyR9l5I1i2EZx8tbgYbNefX2mtOeRQ1y85xBBHFfTteaPWUe6M0hrAiaFNefsnamj3B2MaYUeNl3aNtQurrIlItxS638kBfFKK8cb5ELPkM7SVByElSbpkDKThEg3I1EH4vDiuC0VFzoFNrGwa5tVMVWiZSIfyhvI8qWIh0HZJbdGk/7ebU4MvROYUiOnsUHOYGl3lgXnwpExRnsNNerGIL71ZqCGo9tDEgyF7ZBPci2QwOK8eEs84kUYPIm+uNomT1Kirau3zJdpTyPJG2ASHAfMs94sZSAP6eLv5d5fSdryDwyIQ9AlwgNPVs9xuaFyIwsZobOxxArXWQl0gZp+Tbs0kT1zIdce4vOtgveiRXAVivnnofKDg2H9R/aVQHUEf1mnbO4j7yQHk9tinStKkGjX+XFIQzY/hbc/+fibpzKqYIhpkW0YdmOWKxB1tYEaTr/s5r4Ha0+fZzLAGFLOpFG0NBm2q8rEYy9S6dOnzFTUQ1JcRv0suty7EgImOqdt72HSyHKR9g1fymAwnf2YXrNx5t0MdCTxWmNrViZcnvLtWavLu6LOEbyZNWlP3YV8cF3CxOIBuHOBqehykwIkeUARVXYRsZqQXjBZqHVGcs/eqLibtV7mKf14sjjPqOBlFmHhY2vcqONyue96lpz3Vfsgr8P9xaap7otioMTlxtv5uAwqmaXbJ5P9wIBNOhszF8f1yeOadapDmbeOC2OK+r9EHJ42xV4o3FwRLAWk7XLlwkI0aHGw21bZxpq9Eljcup4OHWGT0hu40Mld1/zElO5VGfYUo4RrsjKwII5B11+MTwxKFNopdmS6maklR55JivVC2g31Q5CR83OVYpIPZpxVsImMquXUAbaA
 2DJYsWQq
 6LvthyVwNOpAB9KQ+JsXAUhs1v1qr0jw8qnn0IgEwYOHQsk0J3WbeKeNnbYhDvBri9Kq3GzPby/wqoJONzovTHgX9GbgQq7fzUwHg+KZZRtpVyWQG79l2byAyDk151TuOfHcBxLHugxXE5ZZNe1bpJnkQVECXmBgEXry8RLMm4DNUY90KWSe9yKH1kjmQeayAqCluzH6soNxuT54lvASN14pTGwPLCR7Qq1Ev1k5zUIM3nkAhBkCm+bWzSxnWJ25/y+V7SPnO1xUl+e0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 21:53:24 +0800, Kaitao Cheng wrote:
> memblock: Remove unused exact nid allocation API
> 
> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
> mechanism") removed the only memmap_alloc() caller that requested an
> allocation from an exact NUMA node. All remaining callers allow fallback
> to other nodes, leaving the exact_nid argument unused.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/3] mm: Remove unused exact_nid parameter from memmap_alloc()
      commit: 063b5e8bbd216c27e885f45e29e23d053aa565fc
[2/3] memblock tests: Move exact nid tests to memblock_alloc_range_nid()
      commit: fba3e86fb848f79c4573243affcd7d79d378958d
[3/3] memblock: Remove unused memblock_alloc_exact_nid_raw()
      commit: ea27be9f7ce90a05e779d20b60969ce2a9834f77

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.



