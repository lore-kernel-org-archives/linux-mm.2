Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EBCCF6BE3
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6CBE6B0088; Tue,  6 Jan 2026 20:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A1E6B0092; Tue,  6 Jan 2026 20:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50126B0093; Tue,  6 Jan 2026 20:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3FAD6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:56:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C9CF1ADC36
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:56:29 +0000 (UTC)
X-FDA: 84303503298.30.72D30B0
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4B952A000D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:56:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlXhP7+V;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767750987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJoCJVDnxCDd/rs/jugLWSqf+Q6wUvR5qXjAJFKp/XA=;
	b=hws2a8W+5QoKdSb9MafKs85XPndunT+bxeb21RecIxhE5c8rdnswm7HLcwLidn6mRvgk2t
	ZJJ9lUYqY+7v7GpgJ+K5gzixpM5mT+n2W/DNmMP8xKbxItIuxwKUW/m16qMHW60xw0dOGH
	KLBtiZ0qUnvbbqZiD7OFUBmX/r7UtRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767750987; a=rsa-sha256;
	cv=none;
	b=eJK33RCPnyXdFNOsKUAcLqK1z+nXtA+at8fIFqCBzfmlCnCqhnjg6cK/Lb9kjO6NDiuR1c
	YCsFTX4JmojCNHeNAmRKgI8ZgdumbyC9PrGMhdxt3njnekMVOL4GoevKk80+k2XKSgCdxA
	xiy7fDNrY3Iia7h8lC07SOb2KN/cxFc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlXhP7+V;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 7 Jan 2026 01:56:20 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767750985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lJoCJVDnxCDd/rs/jugLWSqf+Q6wUvR5qXjAJFKp/XA=;
	b=vlXhP7+VL7Ic6kkh2IUB2RVLcULDP4YMQL3IE75nbz+xw872HBCl7MP7f47ElFgurd9umA
	KS6w2GaVIUK//12z50CXc/nbZM4PJ6eZGlYRpt5BKPXzjScJHqaXB/cabzLNNAVw4NeXg6
	IIbVHLjYInhPbuftjMynzA5vgGrSFLg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: posuzfpo6mume6yh6g98citb6hu31qaj
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B952A000D
X-Rspam-User: 
X-HE-Tag: 1767750987-77124
X-HE-Meta: U2FsdGVkX1/S5gIsgZt63iTyUJYCpPDZ0FGI7lt4zENbVkIPkKBDZKffQBspp34CuTJtH5pY0zYetHyqwoIrWvMu+vumDoyb6DUFkw/2lWkyLG/b5AYOKIdX4Pai1Ve8T4N6bvnqBmojX+4fpHzrQrew1ptiRuImpIYUP3GDq759+WaHaR6SUCRyG+2KSASSNEVuVZYjsza9+Vq2RbIq51wUgWH7FHRMG76QdGn/n/ZneP7lFIvcRVuyJWZcPsYtD/WlGYAiZSUN6B85IWMaOyyBVi9YjALDGSeTwM7v8+Z34vuyeOHQrKEfi6+RsOYHIxE0YhBBx4NcU0q+oUGG9TwHdGgkTdVdJ5hRGmEkcM0FdZyMPNtVxjzO40kiuKj6b+rehPeQUSyT/pVH2o/gtrhSx1j2i00wiMVQqCMfxvOld41iFDBFQIaypRXSQNqxxai8MjQ1RWgFj7RM4DD8uT4n/o7FItlUMCf7j/C2YM6wjgFKrgrV2MJAn1hSZJAYkH5FGyiWJJauniP+ZxFprIxc7Hj9RkwPipmGPdaD3cFwddXaYJ9FGNEfvZRRP9MGxjOStTfBfdqKtWjWzK66MNWKf87lDAHf/noGOrbEAwIr93+GbKf4Mtp+JWm8uetSX2722/lfl6zH8qxGkoPa5/O57MUFLumTxCENJ4wYjuV8oYz1E6EerOwbcNES9Tt/1wBXB4mQVszL8u6T+z7h9fNakN8fbbHBTtVnqE6Rn0nljJFPerIhsYvZ0w5AK3AluK/EYvR7Y9J1++tzBa7rA3oJWKEM5RBqDMb81H86bj/K6OThOMQdHwuDMpj+aggWY+obs5zN1pYroKPKPcP2Z/ROJoNDSLZNUOqDSHLS5uS2QGA2Cx3SDoUQmBCMOO0bhjYhCzfe1oPjGkc/aaLeO61nsqkOcxxmlaGG0Oq2iHVObA51Keppxo0X53w9wazdfh3u+Lraq85hjms1WR4
 M9xi9gkd
 OsZ7lGDipbgCPrV1yRkrQxeXqntU2G1V53P+x959fnCzsro6tEKFjzdBANFqEdPlSsqqivo66nFoBuhh2nX0wGRe3hJUAIDL6i+MJAt2QKvy1xC7UjDJhyPoZK2uIUzxd8sMiQ+r6urvfsSXgoLr+E8FHklUy5jtjXHj3CNq2GK/DTUkhTRq8L6N2hlmN6mUw+a2A8UW5OAXMW1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:37:24AM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 09:59), Sergey Senozhatsky wrote:
> > On (26/01/07 00:23), Yosry Ahmed wrote:
> > > Instead of modifying mem_len, can we modify 'off' like zs_obj_write()
> > > and zs_obj_read_end()? I think this can actually be done as a prequel to
> > > this patch. Arguably, it makes more sense as we avoid unnecessarily
> > > copying the handle (completely untested):
> > > 
> > > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > > index 5bf832f9c05c..48c288da43b8 100644
> > > --- a/mm/zsmalloc.c
> > > +++ b/mm/zsmalloc.c
> > > @@ -1087,6 +1087,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> > >         class = zspage_class(pool, zspage);
> > >         off = offset_in_page(class->size * obj_idx);
> > > 
> > > +       if (!ZsHugePage(zspage))
> > > +               off += ZS_HANDLE_SIZE;
> > > +
> > >         if (off + class->size <= PAGE_SIZE) {
> > >                 /* this object is contained entirely within a page */
> > >                 addr = kmap_local_zpdesc(zpdesc);
> > > @@ -1107,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
> > >                                  0, sizes[1]);
> > >         }
> > > 
> > > -       if (!ZsHugePage(zspage))
> > > -               addr += ZS_HANDLE_SIZE;
> > > -
> > >         return addr;
> > >  }
> > >  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
> > > @@ -1129,9 +1129,10 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
> > >         class = zspage_class(pool, zspage);
> > >         off = offset_in_page(class->size * obj_idx);
> > > 
> > > +       if (!ZsHugePage(zspage))
> > > +               off += ZS_HANDLE_SIZE;
> > > +
> > >         if (off + class->size <= PAGE_SIZE) {
> > > -               if (!ZsHugePage(zspage))
> > > -                       off += ZS_HANDLE_SIZE;
> > >                 handle_mem -= off;
> > >                 kunmap_local(handle_mem);
> > >         }
> > > 
> > > ---
> > > Does this work?
> > 
> > Sounds interesting.  Let me try it out.
> 
> I recall us having exactly this idea when we first introduced
> zs_obj_{read,write}_end() functions, and I do recall that it
> did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
> me dig into it again.

Maybe because at this point we are trying to memcpy() class->size, which
already includes ZS_HANDLE_SIZE. So reading after increasing the offset
reads ZS_HANDLE_SIZE after class->size.

