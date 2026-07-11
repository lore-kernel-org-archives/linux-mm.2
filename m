Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B29C44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBF56B0093; Fri, 10 Jul 2026 20:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC896B0095; Fri, 10 Jul 2026 20:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2E76B0096; Fri, 10 Jul 2026 20:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6996B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:25:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9FEEAA0406
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:25:54 +0000 (UTC)
X-FDA: 84974603028.10.66C534D
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FD5318000A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:25:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJ59kQOf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783729553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozuHQhVAjCW4JCxIsyp8AZOTcw8eEPsbEwyEh/H07xc=;
	b=DJ4paanAUPSrwZYfhrViRzklPUd/h7JlANiL97JwzJNMFv2pWyx4fC2eRIiD0dBUemidiL
	qnR52wozuIVEmzaremOSLtZnBUx7n+mSEMLdyiY2Zmkw6RB9TxZSUFWRxFg1DBZA1GhfPL
	6ASXV3njelHO2LafDgHg/tWT69/FDMg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LJ59kQOf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783729553;
	b=0R+OKf+4LZ8WNAka6az6Eq8UGeLosJEzAQf5Ojdu6k5O3flkqh5YA2azacQw3CFg6PrgaH
	/UaBAtpfXQ7/eMbq4W41djP2eV4HivNRog0gwjVrweLgKShfIFzXWqmvvGAh/G15hHDbuv
	sCLvhgKGHyDHVoO2sZCdGuijY7buBnM=
Message-ID: <133c3c19-22ae-4de5-98e0-6970b707bf37@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783729546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ozuHQhVAjCW4JCxIsyp8AZOTcw8eEPsbEwyEh/H07xc=;
	b=LJ59kQOflH4Xwi55pz3SR4YZ+SZR4DgfALUVoXqN08vKRlsEwz2raNVipgNS9depuera86
	58A2/XqIqEGURFDg0itA/yBn4xNw8b/j6f4yCsOwD2cxdZFpKNR+uqvznbvoqrIgZewPTK
	LY00VDlf7sl1JHOE+tUToHYnrxcTUGg=
Date: Sat, 11 Jul 2026 08:25:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/zswap: flush dcache in the compressed decompression
 path
To: Yosry Ahmed <yosry@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Song Hu <husong@kylinos.cn>,
 linux-mm@kvack.org, hannes@cmpxchg.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, ljs@kernel.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au
References: <CAO9r8zN4ig_GGP4a=NLZ9PUW+jFmSfY1yBLrkPA9azvDCrGSvQ@mail.gmail.com>
 <20260710184052.3614560-1-joshua.hahnjy@gmail.com>
 <CAO9r8zOuRFcYnLGUcRYyg9_nAk1TvCxUvV_0101msKL0Mx0P6A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <CAO9r8zOuRFcYnLGUcRYyg9_nAk1TvCxUvV_0101msKL0Mx0P6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1FD5318000A
X-Stat-Signature: o574neptgppe1zppcxjksro63oq7ky8b
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783729550-123899
X-HE-Meta: U2FsdGVkX1/kYbZOLdrjrOM9VfS+oSPcmG3SlIoqsOKbI7oiiYM12Cbc16i6mgbZH36jfewTX0h+xohXzlnhvhLEVVy1eU0LhmqUa4/8fYEhArraHz3kcasvfxAv2rEVkHmFelfKz0r5ioGuc6nycitm4ACHPuKlJryHh/Wjn98e7/pXRrvKkyjgOF/oSFmKPWXhpeLPdiM4JZ2aP4fQK5V0VtmTmJGB26msrD4s7T3xZn9hNU/fdnOGSab+CTHeenRVuKFdFzKM6/GiLNlQix4ZuXGmZPsDaDV9Ls8MsxXvRKYKAf++4j9r0prc8TE/9+LSoNxMSdtt0pLF+fn8KJN0UHtgakSOrkZhLFqbYjkvdc/8zBjZdWLmtV9v3aXn2snLPY4vkKD4TWmgy5ewGIDVLDHVt8g77qwRs9vNGUk0nkZ09hAQ9MHYgJ2L1ViXPaytdBFo9BKOBoPis2XVU/bXn7TgAz7vshpQxisgyRPgOhrr8I5Ts4WjmMSP2vzOnJtbkNSIKl4HP/8wQUQGYrpy7GDL9GOIfMUT7zkTPyduzEsyE381PM330G/Rcw7ztpWYFaoyts7NExbIRtFVQ3Y68hQw3pTwGc0Zd3DC84UCC2I1p8+RksEz9BGmqTafCCjaCmgR8DzVGhwyYHK/QJItsvgp8UUcfrtU7SnPgJMWx6N7DdlXbpTt5Z4FvjtlGUNY0vnPnJYxId0CkUS7RTfUOGHq1+MagRfEBNsktZFV99f4gq+L1HLwdaPP/r9Rilio2PO1H3DnshLsmPHMG92o7JF8/pTlE5Az6drMUekH7xuYbKwwRpHC7pGzrqZANDkXihhQ//9vWiw26YqLEd5CudBQlwbHpGX3v/z7awJzPTwrGKCVo5Km+IZZxkh55t73Aw7HeoTq7hq5pyNLgaLP00xNfRh21J5UIS0KfOfLkJNz+2b+G5vdCrI4+mY/X5zrAT30psxWVB0dDMF
 oTGsS/0+
 0vgelX5uRmQHvG9EORxuTKtyx4VAlzbZFPAKYKdOmRuXdCrvVGgdX0XzqjWQUFl3fPAax2SqtzumpqEEJrttqfuklxvx8Ajq5TOR8YXNGO4Uj4cix1lL4g7DmBI+8LM5Bfvd+wDhw4KoWLsbt4AGurkNiaHcKn08L4IHPPVdxf9KI7ImcLsJ+yKpz3DfpyA5WpifhbkN5m/y3DhOS3HGladb29kxvgLQnp0ptrfZN5DNZu2IZuCeYmdTKf8P8yIoV/UPfuuz36D8GrJcfLW5HuZNvvkgujCuKrskhWT8/IqEusCQXGSC+UUKDgt9Gen67t+8X1qudMEK/UbF7qqVs3BkztQjbSTXHvp+iEaYYqFVofRM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc Herbert, in case you missed that]

On 7/11/26 2:43 AM, Yosry Ahmed wrote:
> On Fri, Jul 10, 2026 at 11:40 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Fri, 10 Jul 2026 11:22:43 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > On Fri, Jul 10, 2026 at 1:28 AM Song Hu <husong@kylinos.cn> wrote:
> > > >
> > > > Both branches of zswap_decompress() write the destination folio through a
> > > > kernel mapping: the incompressible branch via kmap_local_folio() and the
> > > > compressed branch via the crypto scatterwalk. Yet only the incompressible
> > > > branch calls flush_dcache_folio(); the compressed branch was missed. On
> > > > aliasing D-cache architectures this can leave stale cache lines visible to
> > > > userland after a zswap load.
> > >
> > > Adding Herbert here.
> > >
> > > Doesn't the Crypto API take care of this for the decompression path?
> > > Maybe in scomp_acomp_comp_decomp()?
> >
> > This is what I think too. Actually if you use something like
> > zstd_decompress() as well, it ends up calling:
> > acomp_walk_done_dst() --> scatterwalk_done_dst()
> >                       --> __scatterwalk_flush_dcache_pages()
> >                       --> flush_dcache_page()
> > over all the pages in the loop.
> >
> > Maybe I'm missing a path here that would require us to manually flush
> > from zswap? But even still, I think that should be handled by the
> > path that is repsonsible for doing the actual decompression, not
> > zswap.
> >
> > What do you think?
> 
> Yeah I am hoping Herbert will help us out here.
> 

