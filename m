Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB241C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581066B0088; Thu, 31 Jul 2025 12:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559566B008A; Thu, 31 Jul 2025 12:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EAA6B0096; Thu, 31 Jul 2025 12:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33CCF6B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:43:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D37CB80C86
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:43:29 +0000 (UTC)
X-FDA: 83725130538.13.CEAF3B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 045AB40015
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:43:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R29G5Yt0;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753980208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fllF32BwSzVtMq34PCLv2uzsJPKTH9pY9aKfeCH4g+Q=;
	b=4Psm69SKQEZsjf6hgVnIBjG00BMjFa5lltfJq4gCyL77mfIKwXiczjulhUwBxpiGUGLMsB
	hupOBWhb8hgpezhH5254xzrfYVa2GjFk0f/D7u+8p4u1+EjF+k3iQERHunE9/786g6C1nW
	D5l245UA9TyxsBQuQIwaj8paRlGzTzY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R29G5Yt0;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753980208; a=rsa-sha256;
	cv=none;
	b=Ysr3Dr/10HGVKKdfF0YJw+uQd3JTjPHDNCpet7aEUlFPKAGx8KNREm7NFLW2nmVQjlkgcE
	e413vc4nQqOF1jBoSDHQ4mtSawx2ttuG00Vx9EdrYF5qGJSxRH5kPHyeyMLJCWlAr6v7S2
	LHFEVr6l1Jf+VrEQH3uEeR988J4C+BY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA42545AE2;
	Thu, 31 Jul 2025 16:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7794EC4CEF6;
	Thu, 31 Jul 2025 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753980206;
	bh=8Jzo9B7rarBf0z4ymivEctvIbRt086rr/yY3XaKFfV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R29G5Yt0xrgV3h51gy0LEn9281Zm5Xaof/tAnhNBQGOuTZHrx+uTA//yPXXoEqxFA
	 DvwHSDT1eBMR//v7vip89SLwkCPGpCpA5cH90eLJFym28+V6+CsDtCKgtIjLY4HSm3
	 yakI0O8YhU4nLnuI+FHkOJnnToHxx097YfUWDRo1YXuCI0lfezkr0VmoY1/mc3D6Ka
	 Ymes0jW0XmwYoJf4a+IV1fRRniB5R1P+moxHdZiHVczksBS2RhM+e6BWoGloHfwj7j
	 Q6DZDgAj0SIoKfYvG4ySnNRBMaHXZWx4gl3Dlad3XbfSdil/RhXN0B6KIzO5SR8ux6
	 /p4v18n1q4+Gw==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Thu, 31 Jul 2025 09:43:23 -0700
Message-Id: <20250731164323.15107-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=NC65XCkmX1YzivEJtPc+sEJ3pLHUsYhF60QJnk_OtpVw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: doybcoujyd1drx38x9pq9md5ny8hwuqo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 045AB40015
X-Rspam-User: 
X-HE-Tag: 1753980207-494904
X-HE-Meta: U2FsdGVkX1+jnbt86HtVOsvC/gvSb181g2K4K0HTTiKlpodOQi3Ae1MLEYv0mwo056Q1vy6nGYmJZf5KMx0dk7JtaVkQ375DF5WCw4TtSSEmHIlPasPBy1t1fmDoueRk2NCSBsU0TAqaWfYgHNt+23ePZP8cfrE6enmjBifKml9SPHEpKB20IEjQ9tcqRDeGsHuh5s/wMBC4hkXFmKq5XXzGQg3NWO6mCH+89Ln6krezHpp2YS9fZKsiVRXykFxRqTSq77c864PXsy59RGQDI9u8+gqHVyHdcCAfrNqQln4MfFxsnWi2HN82Kz7NALiWxnaWHfmnkDkV1xChHfDiMqAUXtTDdLzpMqzBoKZAwM9C6XtIjs7LRgNsJtXj4uSFaGB1JVLWFAXs7XY87VjIWJKOlnZ91uyOvcy2v62q8OBpS2E7fGNWiy31DKT+uPkO4B7CoIS43vB3M5bbtZ7UKO0Y2tss+UhIIcRN8GQwa0/qHhJpFVcAWbLZrRx5TGMxzueB5lzhI3OnISb+xc8I/T3H0mJOvO2b0FopyQsxagYZ/pWxE7vhIVEOHEfzfyo4nHI6U1ftRbNQxDhPJhednome4EjjoaYrFgz9fAxa9XhZUMmarzfl7gfgtGG/2gi1LjcVZjEIMyzmv8MCVk0WhQeRJ8jYU1VECvaerdlGR1leR70GYuq39ItaOVobHqwufxp5Qdd749toYQVVWHgYZ1PxV7EeV5zW2irTpjUM2mDPLXX033AmGwipRDePWMhabzAvxBaAflfL38QpyJ/J5Z1eyOcuQ5L0sDpe+v7Npjd0i3meAHFQmkA8rTOMzSEvdXjulU7hxSEVPedjDPD70ttuKrr4KgiP/e1K4oN0TXusxbVODLb/wSIU6n7YUsmA0akkPEDVIT1O2UUdxdJEzpMdNEA/ciYnWNzDuqsA0qcU0/NXMelBIfUvHxNYfsb9zyKGM5AcBIWewZAppbd
 TsFzGnku
 lQ0k6G2FCxZiwlnM5nXtg+i0nZlsxrq9Ib9B46JraMR5LJM5XnirlefW+dKPWYtUT0ghHj4owXzvQfThLhlW312Xj543X6IMWREwojtC8fyWghG2bgpRrfKGExy3lN1ySWCOaIIl18o32K/nbXacyxSHYH/56tZ41LQ/U11QzVYKa2bb7ZCgP9C13FVqrCUY6sHzUYmVuLx/gIfaCf2fHRdXKAasXsAayV/Q0PMhtV/9685rV8gAYm+cfMY9RjcEeP9eYoPbyiLrcKo6gEorMsLCRf7wv27KkXPJo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Wed, 30 Jul 2025 17:21:44 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Wed, Jul 30, 2025 at 4:41 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > When zswap writeback is enabled and it fails compressing a given page,
> > zswap lets the page be swapped out to the backing swap device.  This
> > behavior breaks the zswap's writeback LRU order, and hence users can
> > experience unexpected latency spikes.
> >
> > Keep the LRU order by storing the original content in zswap as-is.  The
> > original content is saved in a dynamically allocated page size buffer,
> > and the pointer to the buffer is kept in zswap_entry, on the space for
> > zswap_entry->pool.  Whether the space is used for the original content
> > or zpool is identified by 'zswap_entry->length == PAGE_SIZE'.
[...]
> > ---
> >  mm/zswap.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 65 insertions(+), 8 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 7e02c760955f..e021865696c6 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
[...]
> > +/*
> > + * If the compression is failed, try saving the content as is without
> > + * compression, to keep the LRU order.  This can increase memory overhead from
> > + * metadata, but in common zswap use cases where there are sufficient amount of
> > + * compressible pages, the overhead should be not ciritical, and can be
> > + * mitigated by the writeback.  Also, the decompression overhead is optimized.
> > + *
> > + * When the writeback is disabled, however, the additional overhead could be
> > + * problematic.  For the case, just return the failure.  swap_writeout() will
> > + * put the page back to the active LRU list in the case.
> > + */
> > +static int zswap_handle_compression_failure(int comp_ret, struct page *page,
> > +               struct zswap_entry *entry)
> > +{
> > +       if (!zswap_save_incompressible_pages)
> > +               return comp_ret;
> > +       if (!mem_cgroup_zswap_writeback_enabled(
> > +                               folio_memcg(page_folio(page))))
> > +               return comp_ret;
> > +
> > +       entry->orig_data = kmalloc_node(PAGE_SIZE, GFP_NOWAIT | __GFP_NORETRY |
> > +                       __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
> 
> Hmm, seems like this new buffer is not migratable (for compaction etc.?)
> 
> My understanding is that zsmalloc's allocated memory can be migrated
> (which is why zswap only works with a handle - it's a layer of
> indirection that gives zsmalloc the ability to move memory around).
> 
> Besides, why should we re-invent the wheel when zsmalloc already
> handles page-sized objects? :)

Makes sense, I will use zpool in the next version.

I actually saw both you and Takero did so in your versions, but I didn't
realize the migration benefit of the approach.  Thank you for enlightening me,
now I think this migration benefit is important, and I will make the next
version to provide the migratability reusing zpool.

> 
> > +       if (!entry->orig_data)
> > +               return -ENOMEM;
> > +       memcpy_from_page(entry->orig_data, page, 0, PAGE_SIZE);
> > +       entry->length = PAGE_SIZE;
> > +       atomic_long_inc(&zswap_stored_uncompressed_pages);
> > +       return 0;
> > +}
> > +
> >  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >                            struct zswap_pool *pool)
> >  {
> > @@ -976,8 +1023,11 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >          */
> >         comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> >         dlen = acomp_ctx->req->dlen;
> > -       if (comp_ret)
> > +       if (comp_ret) {
> > +               comp_ret = zswap_handle_compression_failure(comp_ret, page,
> > +                               entry);
> >                 goto unlock;
> > +       }
> >
> >         zpool = pool->zpool;
> >         gfp = GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABLE;
> > @@ -1009,6 +1059,11 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >         int decomp_ret, dlen;
> >         u8 *src, *obj;
> >
> > +       if (entry->length == PAGE_SIZE) {
> > +               memcpy_to_folio(folio, 0, entry->orig_data, entry->length);
> > +               return true;
> > +       }
> 
> This might not be safe.
> 
> It's conceivable that in zswap_compress(), some compression algorithm
> "successfully" compresses a page to the same size (comp_ret == 0). We
> hand that to zsmalloc, which happily stores the page.
> 
> When we "decompress" the page again, we will attempt to
> memcpy_to_folio from a bogus address (the handle from zsmalloc).

Makes sense, thank you for catching this.

> 
> So, in zswap_compress, you have to treat both comp_ret == 0 and dlen
> == PAGE_SIZE as "compression failure".

I saw your reply saying you were meaning both comp_ret != 0 and dlen ==
PAGE_SIZE, and yes, this makes sense.  I will do so in the next version.


Thanks,
SJ

[...]

