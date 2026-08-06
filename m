Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB5BC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 11:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4736B0098; Thu,  6 Aug 2026 07:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4E26B009B; Thu,  6 Aug 2026 07:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB706B009D; Thu,  6 Aug 2026 07:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59B0D6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:05:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE042806EF
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:05:43 +0000 (UTC)
X-FDA: 85070564166.26.0D511CF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8E07DA0013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 11:05:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdfm6Dj8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786014342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBHoCOw1ImpMQvHY2LHwVTE9sWIRGcI2lzzAAUZdljs=;
	b=XoOvY+1dDK0D0LEtMVZgB+vSZcYYItxaFwyhrIDgcDyARlVX8ZwSYYrPG9m3DeEUetlsOR
	w+Uljav+hyeoL7eIcNO0J0JGzWr5BuFAoFJQVP0VFY9+i57RWSXZDLVTC8nz2wEmwRLDLi
	5vNICHyANmEBYOT1WhM3PHwlJmdflTQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdfm6Dj8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786014342;
	b=FSJf/bWJyQWadYOWMse5GkI1lLNT5l9KA3OsmPvKrL/FPvXUAkx1bwRu604lkQTAVsCcJg
	hhFPyzUY7cmo4sYI8amw87XPhEHNkY/pP+5ATDQrKJ6ppJwGPgdKQzuqVyms6F9k1L3D6D
	FDH5AyKAss8yoFJzOLbSZtNREJlYWUo=
Date: Thu, 6 Aug 2026 19:05:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786014337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yBHoCOw1ImpMQvHY2LHwVTE9sWIRGcI2lzzAAUZdljs=;
	b=fdfm6Dj8sNYa9PhQA5DGuYQjQoi1jT9VwAS5UpyKydTon7tIev1vnacYRizTD2/VVbawXy
	UrmH56oIMtF/Ws8yDIHxbCK3R2OFQjho2HLxukWtB15ttCotM8gpiVJk8zePwsN9JO/7mI
	gIZYE+56u72NrYm8Ux+fj/YbqIjrisA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH 0/6] mm/mglru: skip empty PUD subtrees during aging
 with PUD-level Bloom filter
Message-ID: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806103003.3924438-1-baoquan.he@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ihichpmbsej1nig48segmtu7dueu6n4i
X-Rspamd-Queue-Id: 8E07DA0013
X-HE-Tag: 1786014340-740620
X-HE-Meta: U2FsdGVkX19LKySpKwJWSc1C0/q0+jRZlo39pnFQIHLAgJ7aiM0OTBulOn9dVRt60NzNGsyt6GTusqIf8Gpn1o+2+46mV/GdjQkLAxHE1owvaw0hNA3jyjwtdvEHmVEdRzvqooJZcYcN2+yxUhSn3gj0f25kPl4oKhZsYouFX3GXWGfKomNsfh49FMDYmBIo4nDuMua3CcB3F4srKWpzBU65H4kJmVSXkpQhZadWvbQ0iukUIT3Ky3BXxYrTCRv3dj05t9M0cGCJ2emrK6XkqrarHYrkoVKJUlApKOPOj3Cug9JZlE0Ik+t6k2LHGYDrtzRdsuP3E0AtOpror5V96b+m3xudTHjPlReYrU0SuRwfHceon/USSQRqJnbB31E5xLZTxRcU8TBOLmMzwWg82GYQ/f6YEPMHM5sdlV60r4/aftaZIO8wSAhLV0A9CqqM4cBwqc4V52ynaxHehZc74dj00A5253bMSfLSEQRxcYQjZm3JqkzcJ7OKEFOa/dnLJb8LoaHvVxkcMh5wM1tC4n3sYNPxii79Z4GU9XPXffhKwz1kH9XW5Z5ZbjgaZBlJcFFuUUPFwDunisimTRCqrGz0RUK/ZBjW1FycTiHmSJW+jTjZ3xVJjth5es8+q12V06tUS1NaF7KBnIDFbfw8nKECQ+DlUY2smFe81ODERq5aX99hb1uM4LE4S7EF4fjYCgQk1E0iF5IzQmY/LKzVKA8jLBjchqtoOqEWGR0WHRbaFXzu1kYyjZc6lUUIqyfpgmIP8JnjEIgZzJF/vi4KxHPym1pbVWIFaY7Slm1pZhcnJBaG8t5qeGBJWFeNIdpdDoGtMF85LpFTkf4b8xo7KYsLp9zV1/8MM/UrIl0qiEezKnF4Q2uHZdBsH3QLQJ9RD3hswjgpdzSOYneZiJQqnST7J1ggq1ru0FMFNvUOym/+jB2hb/VL8197V+y8UZZaXEmOjjvFHmmMxwk0sbF
 stW3e8bP
 VO11zUQRYCEPmXdsUDYly5gbOQKX13I2XM3hU1y7TfH3Ofn/jI16qmoe/z0DiP/E3bNXlc9ShF3aal8+23NrRlYEKSa6z6xRU7kkc7utdUBcO6ubHVq65PltZQdlfzjJr6LeoOe+0h864e8HCCbEvyI741BzPAgdsKetdaR7ZKvrKi1WCmBGXGzjtlcPeFoOLjpKgSGJH+1eZAmnBhlbCayS2dbKFe+VaVmwIfZGPl7+lkvOujxE10DED86GCvXuGxqjZH5idvm13lV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/06/26 at 06:29pm, Baoquan He wrote:
> Problem
> =======
> 
> MGLRU's aging walks every present PUD of every mm in the mm_list.  When
> an mm has no pages on a given NUMA node, all 512 PMDs in each PUD fail
> the existing PMD-level Bloom filter test, yet the walker still descends
> every PUD and iterates every PMD ??? pure waste.
> 
> These cross-node empty walks are structural: lru_gen_use_mm() sets
> mm->lru_gen.bitmap to -1 (all nodes) at each context switch, so every
> node's kswapd independently walks the same mm.  On a 2-node KVM guest,
> ~80% of all aging walks are empty; the worst-case leaf-traversal waste
> with a fully resident remote mm is ~73%.

A note on the design background and one limitation.

These patches replace my earlier per-mm empty_map approach, which skipped
an mm for K generations  (default 4) after an empty walk on a node. As
Kairui pointed out, that leaves a window of up to K generations during which
pages migrated into the node are not scanned by aging until the forced  rescan,
and it adds 16 bytes of per-mm state with awkward invalidation semantics.
Following his  suggestion, the series instead adds a PUD-level Bloom filter — a
coarser counterpart of the existing  PMD-level filter — so a 1GB subtree that
had no young entries for this lruvec last generation is skipped, with no per-mm
state and no blind window.

I will paste the empty_map patches to this thread for reviewers'
reference.

