Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFBBC55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2992A6B00EC; Tue,  4 Aug 2026 10:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2337F6B00EF; Tue,  4 Aug 2026 10:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FE36B00ED; Tue,  4 Aug 2026 10:17:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0876B00EC
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:17:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87BCD1C002C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:47:57 +0000 (UTC)
X-FDA: 85063412994.21.F3BD0BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id C56CDC000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:47:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RC5kAQBs;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785844075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FRzOzpIi+MydaQXJQZvVYfZdxwZTduR9pSlIEHwnIcI=;
	b=OdLdKakvabDSX1GV5yWHBRgB/OyvZu/bINfgiM+uxkwqLM8i0MOGzK+l89+NRQrpCeQR7g
	gGtkQMiDZzBzcGfORXLPhRmiiTCa5lLoezInY83SLt33imyFn+GCTrL8qSpASwrvQb8UxQ
	/H7vIDVopvzGYPcl/QFldfpm+o/hxkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785844075;
	b=YAcH9wZuR7Ma8d0jyceApN9NnwsfAW2xF+rjKJFRZjYPvHLWMEWfA27lQsSL3AJHUZdOyO
	mUd1gm4NS8SEA6/QsQ+w/1T1j9N+NIdBjGmgBI/U0IaFRLiGZNp3qx+lEWBIQEbUAb/DL9
	QVu0Jbc9tSpst3qy1JVxxqJTGngc9OU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RC5kAQBs;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EEA2743CAF;
	Tue,  4 Aug 2026 11:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75E51F000E9;
	Tue,  4 Aug 2026 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785844074;
	bh=FRzOzpIi+MydaQXJQZvVYfZdxwZTduR9pSlIEHwnIcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RC5kAQBskgIc7+U34xpy85vP+1uNo5BlMHcQXbPJ0odww3Liu/QrmS+xik+Oz7t43
	 PhcdHh9A2ma8NEOfaokv3Rf2RCoOYTxTqF2C/RDtr1j0N0Yn0NKYbVUSCaNb+gYaQ+
	 zlyy+okzpprthZ9Elwpl8mGUHgUvpGFRu5fXKKm9QxSBeGxyiaIPDpjtACR8GtFn6j
	 jKOcdWxq+ZKcq8+sVN4RiSJO3J9LWgLte8golfwvk19LEfg5PBxBEw4gl7UQtoWHN7
	 3wkbD+n/KH9KlEXqwMvuKG6VQT0gJr1CFOQNDNNy1GOWd+U4xIpoy9dufifMociNy9
	 IgiFntbgtP/xg==
Date: Tue, 4 Aug 2026 12:47:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, baohua@kernel.org, mhocko@suse.com, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, vbabka@kernel.org, 
	willy@infradead.org, zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v4 0/3] mm: retry page faults under per-VMA lock when
 possible
Message-ID: <anHQjuAbK-a-QGhJ@lucifer>
References: <20260804095135.45897-1-zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804095135.45897-1-zhanghongru@xiaomi.com>
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-Stat-Signature: hedtsaxqudb61q5im3rbme6txwbnrypi
X-Rspamd-Queue-Id: C56CDC000B
X-HE-Tag: 1785844075-41613
X-HE-Meta: U2FsdGVkX183HlWmHKKrO70Bl7Jud3QPUAD8VquxtlUHvtV/gU01HKo8xhh//VGxc2ci0rY0O7P+K9QDHv8qhNNoimJADLSgN0eKBHCwxdT4EkyGrst1HTXCYC58xncbY69afJZSmJUKwAdlwIgjJY1PGiJxp9b3JvRUAFJuGZgZrrDBeu8MKpN1plIpXdjbTtoORi5I3FZ5xiCwrjjdA9gZApVWHfXeoIpxpf/Vk85geUiraONyhFEE2lSXzuyBQXam3CR1W3/8lbgeiZDwIzUsob12aXJycZ38OzllQCcV9JLkIUhixav86xxduzpLjreKh53inWAyIz3cUHbzQWFf48VV8DRsqoU+zHKWR2RyUtmvsjNjjimxX6sXiMmGGK2vOMBc/8CtsVTMC54iBbkC10loRgNozCKkzTeRqE6wpN4j9OPUcWrIzO0564eBtPtKU38s7tWoWXzjWbZe5Jvj6I2xLI57QTolI+QsJ4ErBKt/5QCk8fTZFobcC7ZqY44SOOdNU7QLIPC7k/f1XyQRmFzAXv5WrhnNjuG4VC109tUPlhqH3V+wpLE3TILIuE3OHRV3hfs5NQuSrfOpYLxtpfUyj3SzYl20hM0tNblqyTifxVzByWerz9134zD68Dvu6Vus/S0alEVcAwgtFnRY215D5veY5rFaf8nLaMJQMC7YFVjYVrEXP2utwUGbz2cS/qQEQDX5cnwR4hKLPLBVV2Sa1QJ7cIdMUbAULEAqJYCx0zAKep25msvwfWJmcE6WvpGICUsjP5brB8ac0OO1IRQyaJ9+8J4RZpqkKBPff4IHjE2Llht+QJlBFUaZfmYCxWDPJAqAtY3IB5YBWce0Ih89ZGGjcTErfduJ/KiAcWS4ixi3BAUT/GD84tw4Oq+EhMOe1tDV908Pk0f4XOkF8sPdF5wfNTIwP0DANUgw6GOUIjFcCq9g6iic5egSB+WJXVTsAv7d1CUiYc8
 dZNf6loC
 1RznMZ2k57RO3wSAdV5ffxWEd9tpfsK78JGNZsHctYMpPpQD9nu0wKjFvP8kdxN3X4mnpcNDJJOaR+0tosq2kQoXBZgTODKlLpSGJeGmhdOQF+VTCkxmVPloYdZWqSXSQtxv4/ND65Ra809UywYcXTg3xbxw7xdvGm6R1nbc4Jr/0qpYn3Dy0Ledm5/xisDMx5h1YL5xaljg20rNHlTImQRQ9cgz82ICYAa/Zjkb3WeNynXYAlsOMiSZuumuga198AEz4DMLGnu682ZcaKVAB6v+HNYorjaQa4U/l1mb+qGbS6zjBEV6n6URy1WtkbDJpMiM61SDFK/AydQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Your series was sent in a broken way somehow, all the patches should be
in-reply-to the cover, not separate (unless my client screwed it up somehow :)

On Tue, Aug 04, 2026 at 05:51:35PM +0800, Hongru Zhang wrote:
> This v4 reworks the v3 approach in response to review feedback: it keeps

You shouldn't put stuff about the review process in the cover. it should
summarise what you're trying to do in the series.

In mm we append the cover letter to the first commit in the series once
merged so try to avoid superfluous stuff.

> VM_FAULT_RETRY unchanged and introduces VM_FAULT_MAY_USE_VMA_LOCK as an
> advisory opt-in bit. Fault handlers can return
> VM_FAULT_RETRY | VM_FAULT_MAY_USE_VMA_LOCK when a retry may continue
> under the per-VMA lock, and architecture fault handlers perform at most
> one bounded VMA-lock retry by setting FAULT_FLAG_TRIED before retrying.
> This preserves the existing fallback behavior for retry paths that do
> not opt in.
>
> Patch 1 adds the new advisory bit and the bounded retry plumbing.
> Patch 2 lets filemap faults opt in to VMA-lock retry.
> Patch 3 lets swap faults opt in to VMA-lock retry.
>
> We tested this on a 20-core Intel i7-12700 desktop with a 2GB swapfile.
> For the filemap workload, we adapted the v2 stress model to a 20-core
> desktop by reducing the thread count and adjusting the memcg limits. The
> benchmark uses concurrent file-backed page faults under memcg pressure
> with parallel munmap to amplify mmap_lock read-write contention.
> Throughput improved by 31.3% to 69.5%, while mmap_lock contention
> dropped by about 97.8% to 97.9%.

That's good information thanks!

>
> For the swap workload, we use a non-zero anonymous mapping under memcg
> pressure with optional mmap writer threads. Throughput improved by 6.3%
> to 47.1%, with the largest gain under four mmap writers.
>
> The detailed benchmark tables are in the individual patch changelogs.
> Build testing was done with C=1 on x86, arm, arm64, loongarch, powerpc,
> riscv and s390, with no new warnings in the touched files.
>
> Changes since v3:
> - Keep VM_FAULT_RETRY unchanged and add VM_FAULT_MAY_USE_VMA_LOCK as an advisory bit
> - Bound VMA-lock retries with FAULT_FLAG_TRIED
> - Opt in filemap_fault() and do_swap_page() to VM_FAULT_MAY_USE_VMA_LOCK
> - Rebased on mm-unstable

you should list all the changes for _all_ of the revisions. you should also
prefix with RFC given these are all RFC's presumably. You should also credit
people where revisions are a result of review.

>
> Link to v3:
> https://lore.kernel.org/all/20260626075019.1833065-1-zhanghongru@xiaomi.com/
>
> Link to v2:
> https://lore.kernel.org/all/20260430040427.4672-1-baohua@kernel.org/
>
> Link to v1:
> https://lore.kernel.org/all/20251127011438.6918-1-21cnbao@gmail.com/
>
> Hongru Zhang (3):
>   mm: allow page faults to request VMA-lock retry
>   mm/filemap: allow filemap faults to retry under the VMA lock
>   mm/swap: allow swap faults to retry under the VMA lock
>
>  arch/arm/mm/fault.c       |  6 ++++--
>  arch/arm64/mm/fault.c     |  7 +++++--
>  arch/loongarch/mm/fault.c |  6 ++++--
>  arch/powerpc/mm/fault.c   |  6 ++++--
>  arch/riscv/mm/fault.c     |  6 ++++--
>  arch/s390/mm/fault.c      |  5 +++--
>  arch/x86/mm/fault.c       |  6 ++++--
>  include/linux/mm.h        | 28 ++++++++++++++++++++++++++++
>  include/linux/mm_types.h  |  4 ++++
>  mm/filemap.c              |  2 +-
>  mm/memory.c               |  4 +++-
>  11 files changed, 64 insertions(+), 16 deletions(-)
>
>
> base-commit: 486855239e38a91d3eae26618ccb7845c1764625
> --
> 2.43.0
>

--
Cheers, Lorenzo

