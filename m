Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28500C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5036B00F5; Mon,  6 Jul 2026 10:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EAF6B00F7; Mon,  6 Jul 2026 10:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38F96B00F8; Mon,  6 Jul 2026 10:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2CEF6B00F5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:34:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D0DE120432
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:34:00 +0000 (UTC)
X-FDA: 84958596240.09.D10F44A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 803FE40017
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:33:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZyapHbIX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783348438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZidfra1OEKhogkC2HXYCg2cBCh5erxMqJGy/hmUltA=;
	b=XAcfsHH7haFpXcipiygyxHb8yy6B8Zox6iexI/o/9ejMG7324elZvkJFwYSkB0lLRb74Gz
	dTPkdHHEja2xfny10BFJNrSQ8MleUYD/I9mDRXvOs7rzMkhF26wEvTFox6s1UBP/VtXqI+
	GzIuu00c+98LiwYk3wRiiWvS+U06Bno=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZyapHbIX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783348438;
	b=U2iwX4AgKpAqywCj5ntmwbqJuvVJ943Pu/+msPM2SP8klSA2gYJs64bp2SSfUaY9WCZ67K
	c6ngHFUDjt2iEDo8B0vnED4qqfbNeWuNGrGkWftIfJZSVW5HGlzVdtu2/oqsp20w7FTOWe
	ifo+59w6r3GEv6ooEhAuDXY4SAMEhhA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4D5F4198B;
	Mon,  6 Jul 2026 14:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21E51F000E9;
	Mon,  6 Jul 2026 14:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783348437;
	bh=FZidfra1OEKhogkC2HXYCg2cBCh5erxMqJGy/hmUltA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZyapHbIXG2NOcX3c+KDvES77zPIfYC5Bs4Q4FFYAasXEnMjfTOePXBiFkIhg/Tu/G
	 Y/6ucLjGeBbKx0HIrozVJWwICiV9tf/iAkNZ+vjINfKF7xpJtqR4wm1irD3FsSxbWY
	 jgy97oLF3tBtPT5jdw5BxPPt+DJOvQ9CVy84JZEmZBn1seEWg+p9RgsB7djqL8KfMx
	 V/Lf9hv8eajAPJhZn4BKMFolvLtnDZnwpslNcaoZcbTIb4Pr14oYR3evwi+O5v4GmO
	 VIJ4ij81BAjKbCP85lKm0inpcq26Gxo2YLkfFoShz8dWYIO1PvSwPJ3YpJfFgGn0SJ
	 vYfUGFTmbf8Iw==
Date: Mon, 6 Jul 2026 17:33:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [RFC PATCH 6/6] arm64: mm: support PMD page coalescing in the
 linear map
Message-ID: <aku8zidRtXPe_Rle@kernel.org>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-7-abarnas@google.com>
 <799181c3-a1a1-4de7-bc6a-576d3282efb0@arm.com>
 <akuieSDlbYdHnkCV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akuieSDlbYdHnkCV@google.com>
X-Rspamd-Queue-Id: 803FE40017
X-Stat-Signature: 4d6sjhxeresa8uar8u7r4mako9en91nr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783348438-141521
X-HE-Meta: U2FsdGVkX19OAGL2UDQKf0Qn2x7uLcBkHEIAk9n13ibglzMNGEew79mQMxt+PPOKgdQgcBd5yTERG8RFVcn6YqgqDZ3to01UxgNRi8yW3Rtepj+/hhV6iXNW8l9/XycY8OeA3h/iyYRd6LUvEq3d7hDau+dLsF1gz2SbWbz/C/1yhSI1DzUXqzdjyzpCba4by31bEiOOUFHUM2vYYHmhhUe5JAE5ZhPireRj1E7y3cgJvdGCzwYmPtjrgUjOhXq8kkDiKEm/C3MvS74YaUC8lFMZ5ZqnA6kPmwzRcR0zJ/do6PA7mwArF5RdVIfkMoXKn3N9vEmndqg3ny2MtEFWKH9Mfw5cVC1EsjgktXLhCg+KaJZJ0IiwlVh1kMqePVa8YAr8dtBmIbp/C6Be9TDVwU8pyrR/qa6Mv2T7A5DXnX5RkLAuh3YvEfD4uTknWOWlHe2zQtNUedvHcnLCJmfOQl3R+DdBOeGSk37vrdB1plfatdUWHRgG/wxyIQo4CN5QmBUVaJQNJkSLe9SUedG62r0MS5pKgWRzHdBgfAEfADhutz5K31lf26a6yp2174hf7Q/d2bsW6I1tC6A2aJcHpoRWi4OBWuzAHCTI4klm5mnRFG8h4hb46vp+gr74dIMWgXVqdF6xKTJ8e7OGeQ6iJkm3VdbQmSzzjqjk72ECdfXZto38QghhuT96S3AIBZPz16xu7/qoNB4zgCrWd9WyKnkEBNFONM6dfgfxi89lO28aWXiX8iicHQcPCqwLEFMvhqCp32BgPRwjs/w+p72N1tSBQnfsR9S3sKvnqsHrhcKfDKGihvXKRpXhffd63p4w4adHomjoiCS47iwFiGGcurmMD9rttVkG+S+3osVTlJCf5b+YuLgN+4JsD8InXOiUSq5Z9w/m3UcSELvFfzXvrxJI0Ik+VbGcB3O6rUmkU5uj0oENPgi+JieLdarvrvObKDzwCOEbuU9wFBW31q+
 DCNpwoBM
 WedDqpW6C7eQLDV35nSpzarrJIPJUZMOepySLqXLeGhUysFuLkNJAsh/VCjCHnOfOCQFmTh7XkUdoVS/iALZQu6W1CHsHf1iGDTRbmQVnulIFB56qSPWa2VhoVlp9E+M4T5Q9oyoZXqnyxUKwTTGqFcab+WYaE2nHFenbzxlnpM5XjfCPdB9kskI8tyFowP5mlrFNWm+zRkqNgTeySRlk+Y29GB2CrmDYnOqCbvLc5xXgRW7RKDxLfFUzit/foG8xzZgSi30J0HPcnnGOZ555vhPNzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 12:41:29PM +0000, Adrian Barnaś wrote:
> Hi Mike,
> 
> On Fri, Jun 19, 2026 at 02:40:40PM +0100, Ryan Roberts wrote:
> 
> > I don't think this is safe in general. Let's say we have a 2M region split into
> > 512 x 4K PTEs. It's possible that the first 1M is one object and the second 1M
> > is another object. Different CPUs could set_memory_*() on those 2 objects
> > concurrently. If one of them then calls this function, we could end up
> > collapsing the whole 2M while the other is trying to modify the PTEs and they
> > will race.
> > 
> > Note that splitting _is_ safe (and protected by this lock) because you'd have 2
> > objects backed by the same PMD, so they would both have to split before
> > modifying the PTEs.
> > 
> > I think you'd need to ensure mutual exclusion at a higher level if doing this;
> > probably execmem is the place that can ensure that no objects within a 2M region
> > are racily trying to modify their permissions?
> > 
> > Thanks,
> > Ryan
> 
> I wonder what do you think about enforcing mutual exclusion for permission
> changes to the ROX_CACHE block as Ryan sugest?
> 
> Would it be appropriate to add locks (over `&execmem_cache.mutex`) to
> `execmem_force_rw` and `execmem_restore_rox`?
>                                                                             I
> see that x86 has a lock that wraps entire process of updating attributes
> (including spliting and collapsing pages):
> ```
> spin_lock(&cpa_lock);
> ret = __change_page_attr(cpa, primary);
> spin_unlock(&cpa_lock);                                            ```
> As I understand it makes it safe already.
> However, on ARM64 there is a split lock (which works fine for spliting) but
> for collapsing at least on my implementation it is not sufficient as
> Ryan pointed out.

I think the lock should be at set_memory level so that set_memory callers
shouldn't care about the differences in arch implementations.

I also suspect that the lockless page table walk in update_range_prot()
isn't safe today.
 
> Best regards
> Adrian

-- 
Sincerely yours,
Mike.

