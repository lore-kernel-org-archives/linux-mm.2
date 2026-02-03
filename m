Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D46EE87855
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC466B00A4; Tue,  3 Feb 2026 13:40:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 673736B00AB; Tue,  3 Feb 2026 13:40:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589846B00AC; Tue,  3 Feb 2026 13:40:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48A3D6B00A4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:40:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8DE88C07B
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:40:13 +0000 (UTC)
X-FDA: 84404010306.18.1484B25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5C7E2180008
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:40:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdN9vlEc;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770144012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cESLO7EPLjiYLM7kmKu59f6Z32mI6s3DLVo4D5WZgrg=;
	b=8A9kL4TJcPVJa/G0vM/e06XMZkNqY4ZBev/yw2l+KSa8mO9wi0/MQr2OSJUAsVdyeQfAcZ
	LqpuZ4la7mn0xFuS4tqHjSveKsdfL/ctQoM0Dv2xYKSOwQQ/RIzMZmpezr7LpDf5/fMWr7
	PQ9R4ZUQYjIfPUnAvylaKrTQX7/VOSY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pdN9vlEc;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770144012; a=rsa-sha256;
	cv=none;
	b=fkPr5OWbqlEABoWNK0TzbjHE7AktJVD2jntOyTeFQp6lg4JNHOIBLP+8s7Jl6f+0hRDEqb
	ePW7rXoYxIBuzuoIjcJ8WgzdJD4JoLZH0KLZDjZqr4CtiKt5iHc3xtcx0lGnJdU69TWAXA
	ygZQCY2RR5+hDP8gGuvCfaZmCwzK8nY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C224360143;
	Tue,  3 Feb 2026 18:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818ADC116D0;
	Tue,  3 Feb 2026 18:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770144011;
	bh=4+/Y4bSWbE/KBeeVwbdY/YvPY6O1OYogfJvl/txSdP0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pdN9vlEcMTWS0IHz5XjIZbkBpAFlujj1SKURJZHhVtdeiWxUn2xAKOG9Cy8o2KGH9
	 GXxEYEIeAs6jEuxdR88AQiTLOKv2KN3fXZvfVaZ2vfAXjpL0cpXVr7HB+ADp6cXXnq
	 XhFO8i507bvvXpkv7lYSypQwlPsTDlk0FcWj874+U2fAR4RqN73uuLYX0NADaT6fA+
	 Okg4XNhSXLDrTqKCHUrO9gRPWmnMbdqJ++U670kaCpSUTTl3jeCymZ5r4RtNNamA2Y
	 F7c5ntkqIazuMFolCLiO7MadWq43eavGxzzLsmOdr3VJiPMeSdhPWPfqTDWv78I9qV
	 Gvnecne7Ya7MA==
Date: Tue, 3 Feb 2026 20:40:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
Message-ID: <aYJBBs17B-SQXFqq@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: t5pez87d8fo55en15mttfsu6kw8b3gb7
X-Rspamd-Queue-Id: 5C7E2180008
X-Rspam-User: 
X-HE-Tag: 1770144012-936553
X-HE-Meta: U2FsdGVkX1+45yKO2O2Kax//4GNR3qw3v4kcLwm+Xdg4wAIfArl8rgMdFj1HinV0VivwE64R2OkA4FJ3/FUVFuA5cnoCMSW//uj1Hx16K34DwzTlV8wP90dUZpQTSdjn/TnWrCNjwkPnCzVtb0XfWehkhxGKHDKCnz+S7O9SuAeSqEl7l32x1RmFJr6yiADrEExStY6wosMXIRGeT8pheC2fN/ExFkDooaQARtRdPVVpJ/MP65wqvxEXperNdvtVAQXfnSPLuosprJBVgKjum7Nb8JA6ObSA7Uq0PyzNxJXYEWn+hR7d/uLbUzmgeSFsDl48/GJSmTjzPI5ngtxwzc2O3tOUv7yWkBYM/hK9KrejI8DRloajeDaWD5uQGNqLIBuRyDcdJahHRln9CX1J89818iew0HE+GFC9oIoJgOeXqrFVfqV2P2nLpkd7DXEgOuqLkPwclQvSNdgCz0wSOuC+Xy+a7JxJNHdgnVCPsZyPTzamrSRrrXIDjBDrT0QS0h0U6kj+HV94lXl6u8dM/TMDu/mDNCVsklTNnfHlrOpWlFyLi96rL4fjwRwRvL92rTnzVj0QTdbmv0XZesGzF42EKhcEoU2B5W/+kkq63xDahX0Aa2GA9dXRCSQkkzKP8Yl1hXPXbZvI7rVhX2BlMYkn9twX3hWjALiqtQSjN7xmg0YAb+S3uNqFOzuodP8Et3smlSG+7B/bEGZgrmqBiyjzCFgAxIGmSRJmuqX/mDcacYWtOo02ihzFqt/j1smX+qAuwfpZBqR2iIWgGStFmnd27AMb0FnmmRlyK75XImzdFQP+tHglWaPf85Mh2ipRJRGkiQ7f+VxlCDtX3KFMozsceYHHXDxBJtwinKBbzIGimwM3+6Um536esF9KG79OtU/8ays5QrNNp6B6bnNl0KT0ljaVfTO1f/SKDEfuc7RGdHKVApRGr+09EfusXVw6IkWF6CV9H0rs71yvWG2
 QyD+9BvT
 TXk2T2UhYglI/I+9qbdYGMAPPnnbSr+tOavMpzhR5wCwaFRWYfrwfL/GRgW0wPjLwSysh3Vk8nwZ6KwIRJ1wdPjUdxluUXiygnkIR0kUX/8H3G+rkKMpoUE+yMszzHaySNA4saIjE8NUIdkx6/hLaUaaIQ6F3/+KNS8v/fC9ZemS5cksWNgkqZoylDPMC3jhPeMPZYgtBqbgTEZtXhIgpFpwbHYLMSbWu5J2mhGra+YkfAaTS8PAi/2gAitDr4Gvwv/KxWnHgj97c5gERAslb/Jz5aDgGAvBHL9gl0Ftgpt0IAswSzxH7iVR/Em6eG809dvvfhjQgvuB1BSROlxF8feUF8Fbukq9/ioPA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ben,

On Tue, Feb 03, 2026 at 07:02:08PM +1100, Benjamin Herrenschmidt wrote:
> Currently, when using deferred struct page init, we may end up not
> freeing the pages depending on where they are. Typically this happens
> when efi_free_boot_services() tries to free UEFI Boot Services pages.
> 
> We can hit the !early_page_initialised() test in memblock_free_pages()
> since the deferred initializer hasn't even started yet. As a result we
> drop the pages on the floor.
> 
> Now, memblock_free_late() should only ever be called for pages that
> are reserved, and thus for which the struct page has already been
> initialized by memmap_init_reserved_pages().
> 
> So it should be safe to just free them normally and ignore the deferred
> initializer, which will skip over them as it skips over anything still
> in the memblock reserved list.
> 
> This recovers something like 130MB of RAM on EC2 t3a.nano instances who
> only have 512MB to begin with (as to why UEFI uses that much, that's a
> question for another day).
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  mm/internal.h | 2 +-
>  mm/memblock.c | 6 ++++--
>  mm/mm_init.c  | 4 ++--
>  3 files changed, 7 insertions(+), 5 deletions(-)
 
...

> @@ -2440,9 +2440,9 @@ void *__init alloc_large_system_hash(const char
> *tablename,
>  }
>  
>  void __init memblock_free_pages(struct page *page, unsigned long pfn,
> -							unsigned int
> order)
> +				unsigned int order, bool reserved)

I've been thinking about after more coffee after our chat on IRC, and I
believe we don't need the bool reserved here.

Since the assumption that memblock_free_late() should be called only after
buddy is initialized, all the reserved pages should have their memmap setup
with PG_Reserved set. So we can use PageReserved() instead of passing the
boolean.

>  {
> -	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
> +	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT) && !reserved)
> {
>  		int nid = early_pfn_to_nid(pfn);
>  
>  		if (!early_page_initialised(pfn, nid))

-- 
Sincerely yours,
Mike.

