Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD1BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7565F6B0088; Wed, 16 Sep 2026 07:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DF426B0093; Wed, 16 Sep 2026 07:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6B66B0095; Wed, 16 Sep 2026 07:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 23C956B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:19:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64208A06C3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:19:58 +0000 (UTC)
X-FDA: 85219380876.25.EBD1CD5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B308C1C0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:19:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXofrAj2;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789557596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRclFTTpqSB9gmtGUfB/BgSZNFidCGvGHCEsK1ylq+w=;
	b=0dUGGrfr0brIuU4gIT1EUmjBW0q3kChbovq7Tzr4zzWc2bcB+EsjEK4rDAc9vBINJducym
	xSUZwTPu4X+Lc8sMWdzgcP6n2dqF5s4BGy8RJ58eECHLuhW3QRjEwOd5TBpIEYmYeIBO4M
	Kq3zU5uBgy5vnQUEV49nr122mBEZfeA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789557596;
	b=PEBbUBjeguPxVXdxqL7GxGu7yX3gJKeyxtetbm08/hpwO96EgB3i/v8fGlvzY0pzyqIbAo
	dhs2ASZ/KNgmUHCr7cE77iXzW+ST9uHp+JBfI39trn0Uo8HE5Y5JJMgANHtp1MyTfCpdnr
	99VWv0f4YmN7fVrvtJAcKc0siK/jgLw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AXofrAj2;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDD9843596;
	Wed, 16 Sep 2026 11:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C5A1F000FF;
	Wed, 16 Sep 2026 11:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789557595;
	bh=HRclFTTpqSB9gmtGUfB/BgSZNFidCGvGHCEsK1ylq+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AXofrAj2cb8X/1Xy6Jdwg7mt7lD10KDxqgMWB21VNqVWTiKTrPkEFqHS8OcSG7Mgt
	 /2jVW73/arrzHLjA9ya24/4o+ne84qjYNM5cP6EArkGobsyfQ4DhIn4T/FnvvozxOJ
	 yveHP7GklOrBmOgJAG9ADA+lZz5tzVgNtYBzjnIC3C9Bp6TLQdMfLExVT2X+Hi+mWf
	 uQJQtYflGTau81ct7iPIUa2parYwOnq3tT8aQXBDxxcgQyQ7eSn8pdoTs9dYEBufe4
	 t3L2fmqW1NaY1kjlFpHR8DCgqbrOlIxQm4/mFtyTlgIJzmnKf70bwlkkwgpGsDWxZX
	 vOCenYnEzN0uQ==
Date: Wed, 16 Sep 2026 12:19:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new v3] mm: mincore: use per-vma lock during page
 table walk
Message-ID: <aqp4Uvem1MWQOUZA@gremlin>
References: <20260916043153.2631696-1-wangkefeng.wang@huawei.com>
 <9da6298e-485a-41af-a42f-7dd05c571125@kernel.org>
 <1ddf7304-70d9-4e35-935a-9d622b022e4f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ddf7304-70d9-4e35-935a-9d622b022e4f@huawei.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: rjj8w5gckwb9yzr8ic46hym1tcgyt95m
X-Rspamd-Queue-Id: B308C1C0006
X-HE-Tag: 1789557596-479267
X-HE-Meta: U2FsdGVkX18WOAqtW4vvIJPzkFEP1LZbJQbUYOWU4ew07K2BejrQVjmpapRTMM/34M62ky976eDG7MCMFbT7BFGccA+Q+TdFsO1WuRxefaCt3Zy/2U9grqttKv8QKAlmLLI2WTqBK/e4cLEXna75ULbFFfI+8Top+xWhdDDqzyJIJ45VrHaXWhc2SY2K6kI9C0wUkoxZ6rAf7aC0E6eoRQkvED7z0aZsWjC5Q+m2Mq3HhCxzmK/EfoIw5Q+LP+akeFAHgM/AY09VmpkluUVZf2vh1t20oEbqetW2CzheY8SeGeczyQvfH24ptJATuZWKY4RhTYknFS6gpE5T7FikHDRzcp1jZ8r5MixRm3xsqpxlxaadPS6kmFB5CulSX1EJ7T30orLa4+qtalbj0hSNmJCn9Bxs2x6HGYBKWHpw+GD1L7pMwE2DBergOsnSprJE7F0rXIwjYZQSl82EsunkPTrvCb8xDP9xBh4ELg0Tp11v3WlPcfSAy9dDfv4nkjDCMiC4YNLP7h4EJCbXpuDp8htPuyCdPgjK6CQQKGqKJ/wJR456FqzYFtmXX0qDsy8oBEMkQpEkLaZ7vVPuwn2ZIoWeF7uW9SiSdu3YOW3quTbZeh9wer75PJ6pVlEcmzL5w/XW3RdLgZIq9EkepOs0snQddIJI733jcHyyg0TIkvBKkQyvsh7TrzLRvUrV/L97YwSN32dA7ivYH72bJi0Jj8juGHj6Jzn6uQa5Ax5PS5aKU8TG5gS8gBOBjn7CKwNeDMujbJee2ouiM2MjOhcPKp/7GK7ztnSe7XPqdPDiY53lH9UsmX6oEAWQqPEeRHa5kcv28dOtNWSY0AEeu/fODkhZqh0i8Exre9FldojnULQ71kO0DKdOuWia8GMhD9uPni6oUnwwOO7QSRY3HwkreZrfaEwZYUp8IoGN/s2LCJaHnCBpGs4CdSH2Wh2KT9YTifaW512WFsv3A1oteOk
 2aXrM4eq
 7hVpVEJYFUzNBX4EdKeMQRP+suY8+mY93UQ/zpFQw92N92iHkphRpyyJZfitdQjL095fvGeA5bEP+yQC2i+YpaO6OHs/JDjRmS5THhZu72qai+/7fn4X4mjVq9KhBlK0OWmcKJwxfVSpngvl5T+K8syQYwybLFTK3TghiqfUHpMuNZCIreyouW542THULHiEWnJABlRpCyv8U7OpFdUWROW9iShITHkmYxkvJ/kYtGN1F9TMAUewr+yuzQkNp4v4tnOJlyD5dOLU5PpzarFowhkdiF2Ni6ctWJOQDydIFWhTIUHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 02:50:17PM +0800, Kefeng Wang wrote:
>
>
> On 9/16/2026 2:33 PM, David Hildenbrand (Arm) wrote:
> > On 9/16/26 06:31, Kefeng Wang wrote:
> > > do_mincore() performs a read-only, per-VMA residency query,
> > > making it a good candidate for per-VMA locking. Convert it
> > > to acquire the per-VMA lock, thereby reducing contention on
> > > the per-MM mmap_lock.
> > >
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > > Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> > > ---
> > > v3:
> > > - add vma_assert_locked, update changelog/comment, per David
> >
> > It likely was Lorenzo :)
> >
>
> Oh, I'm completely blind :)
>
> > > - Add RB
> > > v2, (RESEND):
> > > - using new vma_start_read_unlocked() API, suggestted by Pedro Falcato
> > > v1:
> > > - https://lore.kernel.org/linux-mm/20260701144047.3786939-2-wangkefeng.wang@huawei.com/
> > >
> > >   mm/mincore.c | 29 +++++++++++++++++------------
> > >   1 file changed, 17 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/mm/mincore.c b/mm/mincore.c
> > > index c086836bc4bc..0fe50f8a7e62 100644
> > > --- a/mm/mincore.c
> > > +++ b/mm/mincore.c
> > > @@ -235,24 +235,22 @@ static const struct mm_walk_ops mincore_walk_ops = {
> > >   	.pmd_entry		= mincore_pte_range,
> > >   	.pte_hole		= mincore_unmapped_range,
> > >   	.hugetlb_entry		= mincore_hugetlb,
> > > -	.walk_lock		= PGWALK_RDLOCK,
> > > +	.walk_lock		= PGWALK_VMA_RDLOCK_VERIFY,
> > >   };
> > >   /*
> > >    * Do a chunk of "sys_mincore()". We've already checked
> > > - * all the arguments, we hold the mmap semaphore: we should
> > > + * all the arguments, we hold the VMA read lock: we should
> > >    * just return the amount of info we're asked for.
> > >    */
> > > -static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *vec)
> > > +static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
> > > +		unsigned long pages, unsigned char *vec)
> > >   {
> > > -	struct vm_area_struct *vma;
> > > -	unsigned long end;
> > > +	unsigned long end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
> > >   	int err;
> > > -	vma = vma_lookup(current->mm, addr);
> > > -	if (!vma)
> > > -		return -ENOMEM;
> > > -	end = min(vma->vm_end, addr + (pages << PAGE_SHIFT));
> > > +	vma_assert_locked(vma);
> >
> > I think Lorenzo asked whether we should do that. But the walk_page_vma() further
> > below would already verify that due to PGWALK_VMA_RDLOCK_VERIFY (see
> > process_vma_walk_lock) so not sure if that's really required here.

That happens after you do actions which require the lock.

>
> I misunderstood Lorenzo's intention, which has already been verified through
> the PGWALK_VMA_RDLOCK_VERIFY check. I don't think it has much value, but
> adding it doesn't do any harm.

...! I mean, the polite thing might be to ask? :)

It's not critical, since you literally take it immediately prior to calling
do_mincore().

But I felt it'd be a nice, self-contained, self-documenting way of
establishing the invariant given you just changed the function.

However you're also commenting that so it's not vital.

>
> >
> > AFAIKS, everything we do in mincore_pte_range() should be compatible with the
> > VMA lock, including the swap and pagecache handling.

It'd be pretty broken if the VMA lock provided less guarantees than the
mmap read lock in VMA-specific operations.

> >
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> >
>

--
Cheers, Lorenzo

