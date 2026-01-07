Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B101ACF6BEA
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 05:19:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143EC6B0092; Wed,  7 Jan 2026 00:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C66F6B0093; Wed,  7 Jan 2026 00:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0A2A6B0095; Wed,  7 Jan 2026 00:19:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2A5C6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 00:19:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 87AC41A42F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:19:28 +0000 (UTC)
X-FDA: 84304014816.06.FD0AFF6
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id A19A120005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:19:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OuCfpNyr;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767763167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWaSUc6L0T03Z2UjxWjCOpKRtehcAcQyQoINuKbHWcM=;
	b=1E2tl+ZzlqoAqogEc/KUreYXNrwMNW7536LJuuDkbCxlwMC6rKP12aOp7b/ibdlinPbl8S
	sVOs7tl8KLbhPPqO7TBJqX824PGBPX1+pZXGrsT9UVe54hdTOP0CkHO28JpV12lpGqi/Bh
	2qOeGevKHKqW3LGuMbJmiVrec1dCVH4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OuCfpNyr;
	spf=pass (imf13.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767763167; a=rsa-sha256;
	cv=none;
	b=0zfd8V/h3levnLuwPiBzfCaoQ2Nxf91BW9CpO5YHlA5yXSoA/Il4ZlHDIsipO1N95fbs4D
	XdJS9LWTM+pXcGsQ0vd8hsT5o3Y4unXRBwO319mYMwsF4d5W0z9QPrdFb4E5alSW/3ZbYc
	wL9it1LihNjnlG5w+7ZjTYLLFFQATGU=
Date: Wed, 7 Jan 2026 05:19:16 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767763164;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BWaSUc6L0T03Z2UjxWjCOpKRtehcAcQyQoINuKbHWcM=;
	b=OuCfpNyrQRgZ+LM0zepCnsi1wNqaJhahZ7V2/uxRIiiIx5npxla9zoSxvrAfoZi/XuLWlx
	2c6/kB1jOMVCdHKp2wDBvquAOnF/yUJCPtUpadRFKZi76GsAoXQ0rD8Zudh7I+/wfFDy19
	Uw1Rg6AvXXhQFsiHYhu26VlTOWOqqUA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <u6dy6oa6ztghy7ozficimubhb2mwppcq6gosupepnn63uu6oq7@qyph3nyq7las>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hc47tmau3s19abiqigoq9x74u9hqb4q6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A19A120005
X-HE-Tag: 1767763166-344277
X-HE-Meta: U2FsdGVkX1/t4ss50OBQQcB9HNJ/RIXWGsN/CONol8j/P2jvC4vtSuBXvF1stujDD0zALEJM7wJHnjhoTByxf4+2plIh6rSgnJtNVMI8LVsTK2cKS7tjNcFvFqmYqVjk64YaQ8Kgszm34+qaNAaBZRsWMKdHfk3aivHLSlKBJdLEhsFNf8YqF9EPYKg0vVvt8YypGOTpu4jjvy+6auIQ28UqwpsLOO5uvQ/rZgyJpFYJQ/66uIUJGaJJttLRxDqhSmVihxYOgjRSlxlCAFlO5IPAJzHZ76nDCzv/Iyk7Cq/NCpkakNnBn0b8jEDYIRA/Fw+iJB3JcROVTX5AQw1eSYh9Qm9QAJaX6ymyCQkioqjh8lGwDFonHk9lqapi2D+zpVHwUmQyrn4WuRDKOCBhl5sxacpoZpBhVTY7+CsMrAs05r5lQkf52e0CbARMjeZwLMLCJR0h6ix/yWYHEl0CPdun+g93L4vEdKpx2js5JqkO/LYgfNmHfXbCaFN6MA0/Na8zaglV14uIilNP692M2gaCaicnSTy/VECBqXhA6iMwEGFW+64g4wKO5ez1O3vq61gSEbzoCpwaGIAKmBz7huCBfAm3RiixBRTl8qRlfO42qlv7MDjf1JPUsPJUCgU4WKo0MLYrawboGbeuR6admGodt7iMDBbHpV4xqrfDGjtGWcBymxmXrURkcKLHtFXjB5ZjBZmbqjgGCXlUGZ/F+SGMaPfYidlVBJy7lwSoa5AKwb+yEDy2rKdaafJ752bBhWSObToTJmf+1uUNJ2dmh3r/0sN+Vm4NuZ5R3GtbM8nI8Az1ta/UUFG3uPR2fUaBsxPAKEb/6oTRqgT/vvWX8OKFifcgjhXYrAEYRAF0mRkEJbgnoJclMHQQjRAKGBMo+aQ4Ym5Rl2pi1znKZTGGvzEEjN24SVIWkc3PfLYkSscLEdBcF1B/538Uto4PYLRUzoUK1Om27K1AmW5/Cy9
 ngnKrB0i
 VG+E6lp6x1Bk2ghAcVl0hrK4fVNysazpLZ2uju2sOpXY0OsT0NM1JIhFAHsd/j7YW0PFdiDQdh8H4IDYrrpUgKk8f6hBRQe261s0TBYBO/u5B5ax6hZgeu8jy2J+5gUrRpjmZyalpeWX9EZJWiM+BSCRzKHroK+JLBRnOn/V2auIzL2Oom0vMgqUeTmW3TLLXr2IIquYyXA19SuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 11:20:20AM +0900, Sergey Senozhatsky wrote:
> On (26/01/07 02:10), Yosry Ahmed wrote:
> > On Wed, Jan 07, 2026 at 11:06:09AM +0900, Sergey Senozhatsky wrote:
> > > On (26/01/07 01:56), Yosry Ahmed wrote:
> > > > > I recall us having exactly this idea when we first introduced
> > > > > zs_obj_{read,write}_end() functions, and I do recall that it
> > > > > did not work.  Somehow this panics in __memcpy+0xc/0x44.  Let
> > > > > me dig into it again.
> > > > 
> > > > Maybe because at this point we are trying to memcpy() class->size, which
> > > > already includes ZS_HANDLE_SIZE. So reading after increasing the offset
> > > > reads ZS_HANDLE_SIZE after class->size.
> > > 
> > > Yeah, I guess that falsely hits the spanning path because of extra
> > > sizeof(unsigned long).
> > 
> > Or the object could be spanning two pages indeed, but we're copying
> > extra sizeof(unsigned long), that shouldn't crash tho.
> 
> It seems there is no second page, it's a pow-of-two size class.  So
> we mis-detect spanning.
> 
> [   51.406310] zsmalloc: :: size class 48, orig offt 16336, page size 16384, memcpy sizes 40, 8
> [   51.407571] Unable to handle kernel paging request at virtual address ffffc04000000000
> [   51.420816] pc : __memcpy+0xc/0x44
> 
> Second memcpy() of sizeof(unsigned long) traps.

I think this case is exactly what you expected earlier (not sure what
you mean by the pow of 2 reply). We increase the offset by 8 bytes
(ZS_HANDLE_SIZE), but we still copy 48 bytes, even though 48 bytes
includes both the object and ZS_HANDLE_SIZE. So we end up copying 8
bytes beyond the end of the object, which puts us in the next page which
we should not be copying.

I think to fix the bug at this point we need to subtract ZS_HANDLE_SIZE
from class->size before we use it for copying or spanning detection.

Something like (untested):

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 5bf832f9c05c..894783d2526c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1072,6 +1072,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
        unsigned long obj, off;
        unsigned int obj_idx;
        struct size_class *class;
+       unsigned long size;
        void *addr;

        /* Guarantee we can get zspage from handle safely */
@@ -1087,7 +1088,13 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);

-       if (off + class->size <= PAGE_SIZE) {
+       size = class->size;
+       if (!ZsHugePage(zspage)) {
+               off += ZS_HANDLE_SIZE;
+               size -= ZS_HANDLE_SIZE;
+       }
+
+       if (off + size <= PAGE_SIZE) {
                /* this object is contained entirely within a page */
                addr = kmap_local_zpdesc(zpdesc);
                addr += off;
@@ -1096,7 +1103,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,

                /* this object spans two pages */
                sizes[0] = PAGE_SIZE - off;
-               sizes[1] = class->size - sizes[0];
+               sizes[1] = size - sizes[0];
                addr = local_copy;

                memcpy_from_page(addr, zpdesc_page(zpdesc),
@@ -1107,9 +1114,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
                                 0, sizes[1]);
        }

-       if (!ZsHugePage(zspage))
-               addr += ZS_HANDLE_SIZE;
-
        return addr;
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_begin);
@@ -1121,6 +1125,7 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
        struct zpdesc *zpdesc;
        unsigned long obj, off;
        unsigned int obj_idx;
+       unsigned long size;
        struct size_class *class;

        obj = handle_to_obj(handle);
@@ -1129,9 +1134,13 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);

-       if (off + class->size <= PAGE_SIZE) {
-               if (!ZsHugePage(zspage))
-                       off += ZS_HANDLE_SIZE;
+       size = class->size;
+       if (!ZsHugePage(zspage)) {
+               off += ZS_HANDLE_SIZE;
+               size -= ZS_HANDLE_SIZE;
+       }
+
+       if (off + size <= PAGE_SIZE) {
                handle_mem -= off;
                kunmap_local(handle_mem);
        }

> 
> > I think the changes need to be shuffled around to avoid this, or just
> > have a combined patch, which would be less pretty.
> 
> I think I prefer a shuffle.
> 
> There is another possible improvement point (UNTESTED): if the first
> page holds only ZS_HANDLE bytes, then we can avoid memcpy() path and
> instead just kmap the second page + offset.

Yeah good point.

