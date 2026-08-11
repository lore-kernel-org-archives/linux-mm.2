Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB35BC5AD55
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6237A6B008A; Tue, 11 Aug 2026 01:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3D26B008C; Tue, 11 Aug 2026 01:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C33D6B0092; Tue, 11 Aug 2026 01:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ED2BB6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:43:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 452FCA0376
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:43:06 +0000 (UTC)
X-FDA: 85087895172.17.30BFA9E
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7A7A7A000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:43:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmLe3z78;
	spf=pass (imf15.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786426984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwYASxEZOdWoj37YH1RdRjVEdz25n+52dFAwjvk67KQ=;
	b=Dl1KpL7v6w4tF4yDhkEm02HDfERJi8vxPh8IjT1d+VdHNfUH9aNd04Z05Xa0tl7AqTQMiD
	2U0OVP1NEEmHC0kKHWab1ecih0DgGIhJ32d8ZPCnlc+ZbI/liHAhsMxHFvEE3IOEUn7jvS
	SSOdm+N4AtkVQ7oPKn2dhUADvSIfzRM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JmLe3z78;
	spf=pass (imf15.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786426984;
	b=PSW9H/0YdtAKnPJpTPNhiKQia4caQqW0YGrLKi4040kmxe5E/cMZb//AJaI+OzD913rzwH
	PamVjG+brvDQe2tT45rFnayxCLtrRk76hcB6VaRTM/TBtrHnH2CNuTphBUhQPLJWcLC5QD
	cgQztjy1JS0T4gI8XHYmmWlfTpNNPRA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4957eefd361so19524915e9.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786426983; x=1787031783; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hwYASxEZOdWoj37YH1RdRjVEdz25n+52dFAwjvk67KQ=;
        b=JmLe3z78ne0shc1Hf++wCcUq2fdzlxrobjc39htlFlxRTCiEcYsmCKI8xszxrpFSXU
         kGF0EYTpmsCSzc6k12b4FSANpeiP457blY6bQw6iueIE03m8YkipKwzMyTmijedkBuYN
         PBHcsA9pwy1iTlSZ24lW2y2fHl3795MLEkcdj4R1EWY/alFi2CwVIBN0dIu+DcM0Ckcx
         1iXMo0GZIEhvEEHt4xxrgWJfGLkvSgN3nuSC4lCyU8OrHOAA6QnbPf4+AiV1T2c3oTQd
         sak3EF5HyvJ8xgDvzFafJndfiHfeBEhsvGfoJ6LcU9JZxgStonS6dxHCAQOzfj3eDFu5
         t52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786426983; x=1787031783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hwYASxEZOdWoj37YH1RdRjVEdz25n+52dFAwjvk67KQ=;
        b=Uhm3tslgjvLsGi9O1+4U16wZE4wEilAc7ktY35qbwVab6MdvwqhTVIS2duTINr/oeL
         v3WSdzUj0WN9wRkI+YzhAybLKFkgtiBxcomD4pBtElvEkCSSDomjYhUWvBUwyfUCmtxv
         /fRamy2vIrY1cHcCpBYOX/H0B6qrcdJYRgiuG7/EFIAgYloWA+Fpo9U/I5gb97kBgPf7
         QtQvYm3jIybA67r3dqIK0Ho5XtXKMAibWJjKrXjd2qEb1qYM2GOgCpEVBgIEAFuoevt2
         /smDQT+bBB4swXk7asM72R3kUQpb5BQGrwKMjoEQRh8ZFtVTQFjIhWzqSJfDJ58D8tsr
         4rVA==
X-Forwarded-Encrypted: i=1; AHgh+RoaIz1aNenVzYBt+78ASi24zuvZigsU00235CDfqAmBKqUx2kNlp2Meky1R48XbZr7EnbdiLJHd+A==@kvack.org
X-Gm-Message-State: AOJu0YxTp/hULr4wXPzxzbxK2FhVyiC+CfWIDRBm4JlL57Xz3QN3LCUA
	77YAVSpK7V1y0sUgcPX11m55tPL9NKXuvEq5PSeZwXu0AjicDXiV9fRJ
X-Gm-Gg: AR+sD108Dzn8iQDODkV0Ghf8M/LieYqwxWMpXodbmlbUC5TxzvpvDAxNLoveDAFsuCw
	Df14FF708XUh6fOcwyt1aSP2XVn5UY3y09om9fi90xDEr/rIRS5HsbjOY7lzhGBJRcoUralOzE/
	66KqThJXDcXhJOJOlGGDobDwxjcO29x6OWJSy8evgPL2qTx6CVA7wANqfTwQ4KyjWGdAREce+oh
	Xc8oxFqm1ZIgEbWRu84W0LzzWne5jmiyhXK+KhL1YIgqnvBvEcFrEgA8K3A1nLkSLxtBcmzSCL6
	4tH9h9dJTQxlc/k+0/FQeND7WjKuyXud6QJG/+DELbbbfmxKkZ3loerk53JTmHaajtPWfGCOXxg
	SKrcgHkvqq3nEOBTbPp7xzb45tT09Z4ydZX3x4mwWsSh3PBKjtmPSdaW0YVTylglgXZaEPIL4y5
	KBE4gUsLhuMr4oFLHhV/DVrlHH18885h7k1s3QpgyMwbEfx6bQ08ganN0TmuQM5k+NljSSuIGA4
	cXrVzTtK5vrQaGopurbSUpnk3JqN6gJZfE15H+FZ2TwHc8ZEJ2cs0wYXuooqY816OUi2Su/ZAvn
	TS7S2nMb4Vg5M8yeCOc0cFNwPXbKs/8K7QMY/S1bDWHr9MRApWcZ03xf2vJ3LOzszoDNE1vx3c6
	DT3VK6CI=
X-Received: by 2002:a05:600c:3553:b0:499:7312:2d5f with SMTP id 5b1f17b1804b1-49978494c8cmr10369445e9.19.1786426982735;
        Mon, 10 Aug 2026 22:43:02 -0700 (PDT)
Received: from MacBook-Pro-von-Karl (dynamic-2a02-3100-a133-e401-bc8e-d36c-2d08-c5e0.310.pool.telefonica.de. [2a02:3100:a133:e401:bc8e:d36c:2d08:c5e0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499740c46efsm39080525e9.4.2026.08.10.22.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 22:43:02 -0700 (PDT)
Date: Tue, 11 Aug 2026 07:43:00 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] slab: align ZERO_SIZE_PTR to ARCH_KMALLOC_MINALIGN
Message-ID: <anq18FjtFR8KqxyM@gmail.com>
References: <20260808105622.62026-1-kmehltretter@gmail.com>
 <annfnXskDJuyzMKD@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <annfnXskDJuyzMKD@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A7A7A000A
X-Stat-Signature: txr7wfo7x5jzxem4m9d5xm3je5ifpj6j
X-HE-Tag: 1786426984-522259
X-HE-Meta: U2FsdGVkX18wdMXAb6scf6b1pQuNr/UBhU8QLXj00fdPP+Us55ypRjlcE3p9b6pUhFZ7aZZrZzxh7ginjKl3sK1EXO8OkBWqJ5gE4O+lZNFArmHVdX12uYng6zeW+oVNyls6xm/MPSZUsdqa3GrYk68zpn85gljbdRAMDWAaj/ndYhCE/Bswu5AHK8KzoQ2wrqLw3LTOBZpjTjCrLLFbjSaN4WofqT56led2FFDmhE3g/gj87LPLn/OCae6d6Zh6QDWTtXE5pn6RpFuEF2dAgmbTlSpfioeUm6sVv3boV8SfKcKRJ8/TveX709350EoC6dmvoaiC/TB1OjdetCQG56YS/AJJjcuBeQ72RmZRQ4gjxMLwC2VOGQYKo+m2Ipbxw9u2RB27OCLLQJutyUcM7GTgvfLA4vtZm+FR3lvDcFtL54BuLXXKc/c0g3W3e2PDfAh3S1QXUKvYwa+SjPatKtN6Ajo04DlF4BGztfyr4CJo9U49tX2RthBunDPP1M/4mrphkQxWplphp4PDWGLLlFRuFPVTdBwW7JKHenPBQZha/Aqjlua/0d0hJz4hXclma6+wGOROj+wtmpyyoaDgoZfD5yP9ab7TnIreLXB30gNolHwYlcseYcPo5YbJ7o5DVFqe1Lb1rCVTMiVh1y2c4+rtaWxFzmye5FfZpNSytor60R6GbTFUkxDdaj19IyInwtT+Thjzt1ZOPPcKCKJ74bict0QVu8pnCaxPrMDKHm7o6l5Zxsszvt8Mnek0TFXal+eklt1rcqicykxD7ujbXJ0x9qTBHvEDzj9fb7jXfALsQOmeA0wJscn3PwCGYo79q+hTcj00FCDZwqXbRdhEDBcSzg7fEhVwagXbKtnhNd90cgjcPR0XwJrZLt6dYPCwhn+D0v9AoQyUU4ZB8ij6Cy986LPNAamxBUtJx7LRzc4ngZQZLN4i2DqQyNv2+ynHX7wsPQeBHWN0mMBWl02
 S00DpeGo
 0CBjADbZGDlozjutDNu26w8z/1Dv9uSNOxtDdSNdISyus+S9d9W/fuxXApoiXgdBfk1C3shQbo66Vys9CKA6Fya/YdyHK/ravL2pqBRixiKcTD7Bkwv3y49wlvqnFSeQ6aVVCCz5JtUVgm1tzrSoNNjOq1mCFk1OTif/vQHXlJow5FNChKszD5iyfiu8vDeZLqrxtzDpf0J4tJ74AytxrN+gNSWSJyllRHuDty6cDizbyUnXYui8k7+Rd9a4pD2e3Zp6iqMqKNkrHjZZnRU+TucBsPGkiD4PSImPCDHd6acKLCjcnJs2sf7bclnqNHMx0ikukrIfwhCWmFkRWD98EcpKTfCDvPwt9XlAzXiWxEtTuduW0bVhOL8moWtviiLOmXQWNjpxWu+Kmd2ARFAolDrq7WLze+XRAT6qfPJJzdNc+Mq00f2sUCYRrcmlFKM7z+iO/hUjxzMOrwwHf6YVBAqIVKb0DBk6zlUgOSLJx9p50g/yM+v+q2yhMeFbFRQpimD6Z6vPSEzrAI5UIhT1vu8sDDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 03:26:37PM +0100, Catalin Marinas wrote:
> On Sat, Aug 08, 2026 at 12:56:22PM +0200, Karl Mehltretter wrote:
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 32c9f8ed7ae20..0798a714da87f 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -259,13 +259,16 @@ enum _slab_flag_bits {
> >  
> >  /*
> >   * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
> > + * It satisfies the alignment promised by __assume_kmalloc_alignment
> > + * and keeps the historic value 16 where that is already aligned.
> >   *
> >   * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
> >   *
> >   * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
> >   * Both make kfree a no-op.
> >   */
> > -#define ZERO_SIZE_PTR ((void *)16)
> > +#define ZERO_SIZE_PTR ((void *)(ARCH_KMALLOC_MINALIGN > 16 ? \
> > +				ARCH_KMALLOC_MINALIGN : 16))
> >  
> >  #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
> >  				(unsigned long)ZERO_SIZE_PTR)
> > @@ -622,6 +625,12 @@ static inline bool kmem_dump_obj(void *object) { return false; }
> >  #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
> >  #endif
> >  
> > +/*
> > + * Keep ZERO_SIZE_PTR below PAGE_SIZE and the low pointer poison values.
> > + * 128 is the largest in-tree ARCH_KMALLOC_MINALIGN.
> > + */
> > +static_assert(ARCH_KMALLOC_MINALIGN <= 128);
> 
> I'm not sure we should bother with this, or at least make it strictly
> less than PAGE_SIZE since 128 doesn't have any meaning for the slab
> allocator.
> 

Thanks for the review!

The case I had in mind when choosing 128 was POISON_POINTER_DELTA == 0,
where LIST_POISON1 is 256 (0x100). With the current range check, an
architecture with non-coherent DMA and 256-byte cache lines would make
kfree(LIST_POISON1) a silent no-op.

Looking at this again, I think ZERO_OR_NULL_PTR() should match only NULL
and ZERO_SIZE_PTR, rather than the whole range below the sentinel. This
would also stop unrelated low pointer values from being silently
accepted. I'll include that change in v2.

Thanks,
Karl

