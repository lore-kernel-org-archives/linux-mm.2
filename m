Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A78CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4226B008C; Mon, 18 May 2026 05:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B1F6B0092; Mon, 18 May 2026 05:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8936B0093; Mon, 18 May 2026 05:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA2816B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:12:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EC9B120851
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:12:11 +0000 (UTC)
X-FDA: 84779974062.06.60B216F
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4275140005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:12:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LYGusmmj;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779095529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JWXNe2P5R0SlkTM/8T8R92El2t5JoKtgbEM8w2iwBC8=;
	b=NCxaiS3DxUUutoasg/wNYhtXrrGRb35WgSjDwpq3aKPv5jPaZD0etLK3qavTidg6ocwXDs
	TX8DG8XmV/i3RW2kI8XEDh/oGPpb9aCuFKOQ3svrrqkTAeC211kiQDrwPiPrnLWMM7Js/Y
	lQfwX5E287U81+yzEZiJ+EH87fugAgQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=LYGusmmj;
	spf=pass (imf01.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779095529; a=rsa-sha256;
	cv=none;
	b=b/c22XTKImw/eFR4qyTeOz8ckBuuUArADJSJJP2FhIq0N6dPxy9s6W8yY71rEOlC8XCVlV
	naQwpwPMn38vp3IdtSOiN5h/BPO3qsWIuVEVPVns7knEeXHm4rkPV2fFBI966L6vRkqIJ7
	Pvyw3zEpaR1pk1mFFMIW/raWgaPaVNA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779095524; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=JWXNe2P5R0SlkTM/8T8R92El2t5JoKtgbEM8w2iwBC8=;
 b=LYGusmmjkEfWhVSAfT9kv1tNfy5iAMNEmB5goHpQwtsNtYQ5ad1j9f0YNZYMItBTNsSdoM
 rfceGc32aCdPrg9YC902Vk4E81vOpCwSRPYwbNufD3CYsnc2DIYrSAboMjuGXsMAP2IzTs
 CiD7YYWF6C0l7Y+TjxZ4sKpeQUpaJ3imQD/Y730IcQCgJDYEVqITZVe4PKm+jng3kRkpHr
 T8c6c0qs3tJDcIUV5d/Or+Ic5RCFdwuscBDHlyx9qPQ3giEDQ7yYymRo8X49ZHvF1RfXRf
 qckBbcU0U1u+eJ+Yrlt3f256Cw1iqkV1emP4dAdCfhQIUA7i6guE0bMkrFgfew==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <agqyd5Kncrx5B_ex@kernel.org>
X-Lms-Return-Path: <lba+26a0ad7e2+527398+kvack.org+lizhe.67@bytedance.com>
Subject: Re: [PATCH 1/4] mm: factor zone-device page init helpers out of __init_zone_device_page
Message-Id: <20260518091142.71965-1-lizhe.67@bytedance.com>
References: <agqyd5Kncrx5B_ex@kernel.org>
Cc: <akpm@linux-foundation.org>, <arnd@arndb.de>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
Date: Mon, 18 May 2026 17:11:42 +0800
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
To: <rppt@kernel.org>
X-Mailer: git-send-email 2.45.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4275140005
X-Rspam-User: 
X-Stat-Signature: 1uzkbx5psxsurqobo9mnr38mq793qd98
X-HE-Tag: 1779095529-629818
X-HE-Meta: U2FsdGVkX1+Ix++4I4ehL6sZUYdb1MF7mo1xB0mOXI7uOHhl3hN6dRkhYC+4lPBRd7cTE8gks6D7I0P3FG3UnuqRKasL0T8iv1LzAtoni9gD50Fha4XRZyQQF1k03HhonYs5p5NUcoBZt9XuCepkt+PBLEG3pcJfDGw3v6aW5JT9mCip9A10Fdlr2XOQaQ+DX2SO11nsEe9rmvBgVQO90VS5zm9sO/2P3cnJu+GAXiWPOJtF1RlxSugzM/1sYktw9FHpIIotsWQ7nGtb+wlAffZE3r04IRzPv+S+MTlR3h33ZkYCCLC6qQfcmhFra8BWyh04vtG964V7FFhBZcQ/LmOVoMeIFzIBQEPrG7x1UPj+C+mwYdNcMUM/YZfaXxpVGGTJXyeBdZE2S8AVwWTIJc0XhQMyjAoSE8YCUtIusyL77Qcwa6PWGwGc7wQUoIcoZitLijfWf8MfboPZtazn9hnLqQpEmOQJm3zog3V3HRr5JOm4QdLjgPBffUwVQolX7G+HLhhYwUnQPRXmEmdTbqwZ5YVN9R3U1Xp24bD7Ehc9rXq9MqrRJYPeeUg66fMBqMcvhHyL0MOCZjVPdTy79JYAPwcrbWTkoWOuG4H9fZn5DoG6/AfybApp32OZiky1qlQqeCEI3duC6r84RWZ2Kdpj+pxItsosXUUiSeM9UYkBmywSrLqAWi/+kzsAM6OwxzS53996sx6iWvwsJmX8063Ax72vY2FYjodL89ZOb1zn5pMTtOIJcUAsMLlboVHWYkcjNQpyxadjmaOyJCY6PuPpKbE+84C47EqKH9ghixd3AZAoJoqsihcZ/m1njkRU5lBw6/YrcXKGu189uOJUPaN1qk7zkinxhH/syhYTXVpvqbAo7ZDKpmjCduV9gpWhq9InCJ03xwME6PTOLNMKX9Lw7SVYZK4mYt+GE7nJIeDv94eCqod7S4WWL0XXTQHyJ5X7uKwnEDI4SQBGniw
 2UUaSvvu
 pUbw8GYA8Kl2vX5iUchyYoYkqxSIS1xNgCq9uviCotszVt1A9Pc/Mb+/XQEdUrrKdaU6e05C1WwkRgExOq2Bx20qyEv2DubEshuCYgTLOkiJOflmkCAX2IootR1UEapIDHT1ZwV6JJDqocwEMIbQudGSGfc0Qh1GzpYSd6EylpbqLmtApu09GA2GL2TIV1JCOOV5obedMOUpPLvCCBr1G3t7+dz+Wh3wHpdiTbSBo0KnWZGWHVqdXIRPHGKbwWTI1P+65XmZr0xd3DtO/yE60xWy4EdLDgdeEO0ANcUFbhcz2XUt6l+9N7Xf3L/wGsXG9BJIWe+g76Yubqaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 09:23:33 +0300, rppt@kernel.org wrote:

> Hi,
> 
> On Fri, May 15, 2026 at 04:20:42PM +0800, Li Zhe wrote:
> > __init_zone_device_page() currently mixes three different jobs: deciding
> > the initial page refcount, initializing the generic ZONE_DEVICE state, and
> > setting up pageblock metadata.
> >
> > Split the refcount policy into zone_device_page_init_refcount() and move
> > the generic page initialization into generic_init_zone_device_page(). This
> > keeps the slow path behavior unchanged, but makes the individual pieces
> > reusable by later fast-path patches.
> >
> > No functional change intended.
> >
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> >  mm/mm_init.c | 62 ++++++++++++++++++++++++++++++++--------------------
> >  1 file changed, 38 insertions(+), 24 deletions(-)
> >
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index f9f8e1af921c..5244acb96dbb 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -987,11 +987,36 @@ static void __init memmap_init(void)
> >  }
> >
> >  #ifdef CONFIG_ZONE_DEVICE
> > -static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
> > -					  unsigned long zone_idx, int nid,
> > -					  struct dev_pagemap *pgmap)
> 
> Since you are already changing __init_zone_device_page(), I'd suggest
> renaming it to zone_device_page_init().
> 
> > +static inline int zone_device_page_init_refcount(
> > +		const struct dev_pagemap *pgmap)
> >  {
> > +	/*
> > +	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
> > +	 * directly to the driver page allocator which will set the page count
> > +	 * to 1 when allocating the page.
> > +	 *
> > +	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
> > +	 * their refcount reset to one whenever they are freed (ie. after
> > +	 * their refcount drops to 0).
> > +	 */
> > +	switch (pgmap->type) {
> > +	case MEMORY_DEVICE_FS_DAX:
> > +	case MEMORY_DEVICE_PRIVATE:
> > +	case MEMORY_DEVICE_COHERENT:
> > +	case MEMORY_DEVICE_PCI_P2PDMA:
> > +		return 0;
> > +	case MEMORY_DEVICE_GENERIC:
> > +		return 1;
> > +	default:
> > +		WARN_ONCE(1, "Unknown memory type!");
> > +		return 1;
> > +	}
> > +}
> >
> > +static void __ref generic_init_zone_device_page(struct page *page,
> > +		unsigned long pfn, unsigned long zone_idx, int nid,
> > +		struct dev_pagemap *pgmap)
> > +{
> 
> Here also would be better to use zone_device_page_ prefix.
> And I don't think "generic" adds clarity about what this function is doing.
> 
> Seeing that later patches rename it again to _slow variant, I'd suggest to
> call it __zone_device_page_init() at keep this name going forward.

Thanks, I will fix this in the v2 revision.

Thanks,
Zhe

