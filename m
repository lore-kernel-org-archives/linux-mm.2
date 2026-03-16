Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359B6F53D69
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:49:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA916B02E9; Mon, 16 Mar 2026 11:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1A16B02EA; Mon, 16 Mar 2026 11:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8736B02EB; Mon, 16 Mar 2026 11:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACAA6B02E9
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:49:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BAEA1A0306
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:49:29 +0000 (UTC)
X-FDA: 84552360858.26.63FF290
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA8D8C000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:49:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onaCm5sY;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773676167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw3++yX4phoJgoR6LBgrDxim4Sm36JlhNfF+/1M0oVo=;
	b=fgkLdIXURdHKSOA4/PxD/FjT6UMcRGRXIJIz4x4XbGTsHw5ZboXtn6ZvUOjmYU/23AcjEk
	ssn8jhx/2FMp6Eu3CphafEVyovb0EIA4IUuKwP5XO52VDmeNFtw3EmcPGNaf72MOi4uDHK
	d8P5CcNH29GsNmr5q+ztfjSAk8fOQaI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onaCm5sY;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773676167; a=rsa-sha256;
	cv=none;
	b=foXCZs77yrxXJHLiTvEWwZ7GrPATWAoRv4k3dNiC5Y3VJphyWhc3PelXA2kGcNaatBLyY7
	uOnTwhRs1O+dIGv0KmusKCyj6PLzSDqfugpVifABNQXYM5lqBTusbNE4BjhB/g2noh9uG8
	84roh2b/bvRKK8yIV88DQOcGfW3a3q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C72260018;
	Mon, 16 Mar 2026 15:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EAEC19425;
	Mon, 16 Mar 2026 15:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773676166;
	bh=jbzCLmEeN0HUYbn8E5mzfMIWihyrE9Oq/AEzj5Fa0PQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=onaCm5sYCrFpmf1zu9J/x02WZtd4jpgTMIHMd3pdzw7+MDI8z2TbRN0UMATB5SX8t
	 RejjVNolNajkTFy9C1LnW/D+StxC13R84Onk4/JaDXvhscWMYL3LOsfCQWjpkB02XT
	 F54R4ADnwdLCkmXK7FmaDkJ1jKuYzxHmHRtS0AR+g6HZoqWcphmzfbnbTbIzlyzlK8
	 GIDeCpcFGnoOEqxKyC0cJeS0zxU/txv2JXb4IMFKK9me9ScQVxO5Y3FfehUrGKiS4T
	 qvUsqNim/fwniei6C+IO4Dlsi764Mhx0DYbvOHoAcRnbSRIom0tmtlYKKZ2YkEWEUr
	 WjdAkGm34ih0Q==
Date: Mon, 16 Mar 2026 15:49:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <59b849b9-87ff-48f7-94fb-363d5f54d8f4@lucifer.local>
References: <20260316140122.339697-1-ljs@kernel.org>
 <abgY3RNYj7WrYYnq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abgY3RNYj7WrYYnq@google.com>
X-Rspamd-Queue-Id: AA8D8C000C
X-Stat-Signature: o66utgj8pnar737dmteewf8i45i7frok
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773676167-279741
X-HE-Meta: U2FsdGVkX1/HzM2jCsO9bgCBPpeMzd1V7wmeoxxRc0ITjpwsjrweaL16TOnebLMYmT6WnIEAY+5+rBYHvWwVCPiHl/X7o1kjaaS5M0NgzyxrYoGilR2h+vIDR0Ye1aIk57z20JkYldGYsfQEC/x0cU4JwDtciGirZBY0OMBerR68qAb/QE9FH5j8IXNb6e/UYSDVKsX3JyNDiXhbfK/mQKxsynAVL+Lz6KTuFTyJs7NBomNvNT3WXhexF8quCRHck39skW75GqIb1/c8vp7IycCCuoV/prsStoFlAGop68tsumxPs4g7GgrbRJRgs50zKKSunhiu3enByVoPp29BPDqtgirYQFZajAT+Z6kk0n/ieGHNCZOKcqTy6eXa3QqoxemBo4vRhTCt5wSmLkDAaF0zoz6RdzVIRoDwz5b/9AXAaNT9m4r4brgDq5YXi7WXvwDJGLP7mMUBmgXmaZlQ5jxk02/7TvqLHQvPnkSctfyy5XGS6mWFyp+P16FbOmMHWf0S0VN+Ewef+lw2iBZxvPePKh/cNKtBcvbbh324D3AjBQ/LOqlqo/7/o6mWZQIyCVMaHeeOInq0jF00pOKRerwgZl/WEWSYRkUoaZZA1RvcyODSpFvmqZs/XU0iaDrGk0Vj6R2jBY5Sm7hYQj19hXABD99h0W8xwukUxojfqj8PcqdHudysziKx4esipe5Am+tXszCCAkbF+FmIZaqsvGzKTBX+U1TaENKRFwxD8m+djcmcG1SAsx4MOUlicVP4hgwx3wL3g+VnEG3/875A/hS4AthjIo2GjfJ3C+L4PCmmMADl72YqWRYSjXpOI2pTvzLRARpeq5sC9KDDNgwo0FXRgYkBqeNUBy6OU9BSE5TC1Lh9olyKLqpJhbq1ZJVFXsoKb/CmtxHSjk7cal2vTL1UfDhs3Itqg0okEhBSKiNz4eOyxvK1Fvi9xZnRAFTp+UVP8rv+4t0ZGZegq8T
 yf4zQMlZ
 RNGejfnaEI+HNxj1+lBplcBbTMFeCTcl7AZwtjJndK1Van2Lge6hGuxI07pkbj4AYL0FUGvBzG5lxqHB80yrg5ZjnSbkhOweGKm2QoTaTtTkYB6020oepd+sRWdUNHlX2MGhjP3x/HjeQIJEiK1crNrssyQ8iJSa9IT0Wju8gsrPM2jjSreIHVZcspWETykP1rZ0BI/bNaYa0dc8K1rsjo47SiGyze/Yk3kOdK9Tcwp5HVm8H2yLJVEkvH4JMUH+bOnaKFwY9pwVTGUD2doq0AzraR81pPlxQFC/d1fzKeQ8bkMM8Bvhw8w/Cvnr+7dH8vwAZMuUTlHkhJKlv0aUOAo0H9ZnAhip2iaCN62vJOzj9jSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 02:52:24PM +0000, Yosry Ahmed wrote:
> On Mon, Mar 16, 2026 at 02:01:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> > zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> > data for uncompressed pages.
> >
> > In doing so, it mapped kernel memory locally for 32-bit kernels using
> > kmap_local_folio(), however it never unmapped this memory.
> >
> > This resulted in the linked syzbot report where a BUG_ON() is triggered due
> > to leaking the kmap slot.
> >
> > This patch fixes the issue by explicitly unmapping the established kmap.
> >
> > Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
> > Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Oh thanks for catching that, not sure how I ended up doing that tbh..

Don't worry I've made FAR worse mistakes in some of my patches, believe me :)
easily done.

>
> Anyway, LGTM:
>
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Thanks!

Cheers, Lorenzo

>
> > ---
> >  mm/zswap.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index e6ec3295bdb0..499520f65ff0 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -942,9 +942,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >
> >  	/* zswap entries of length PAGE_SIZE are not compressed. */
> >  	if (entry->length == PAGE_SIZE) {
> > +		void *dst;
> > +
> >  		WARN_ON_ONCE(input->length != PAGE_SIZE);
> > -		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
> > +
> > +		dst = kmap_local_folio(folio, 0);
> > +		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
> >  		dlen = PAGE_SIZE;
> > +		kunmap_local(dst);
> >  	} else {
> >  		sg_init_table(&output, 1);
> >  		sg_set_folio(&output, folio, PAGE_SIZE, 0);
> > --
> > 2.53.0

