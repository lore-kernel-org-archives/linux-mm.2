Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9C5CD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 02:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6962B6B0092; Tue, 12 May 2026 22:47:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6471F6B0093; Tue, 12 May 2026 22:47:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 535F36B0096; Tue, 12 May 2026 22:47:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4A76B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 22:47:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBCB81A05C1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:47:48 +0000 (UTC)
X-FDA: 84760861416.29.2D655EE
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 02A7280008
	for <linux-mm@kvack.org>; Wed, 13 May 2026 02:47:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NddXXRBo;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778640467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06gGqdUNMKvX/WJ+4BlOMkKZ5L7m8iKcXoUPE36yZHM=;
	b=Lje7yJmeLYQDJ9zhoAGQSnQnG8Lf57YA8rZKUTz8tMjZYQST6AVh1aHJRZDz3Aigkg/Xxk
	yCQAvA92aC9wnjasSdVbgeCw9wgZUMopNhxzB38vYEqxWrDf7fw5FeSX8syYxt6eDoxDoN
	bFU5bmAe35yCqa57NnaSIfkOL0IiZ8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778640467; a=rsa-sha256;
	cv=none;
	b=3cyjuVk5h0F9LGslLmdNLKLsBG9f3L15pvYnNZ70xp+ogPr8EC49gam34lDjY3TyTKflHv
	HRNUp7ScGqVCGR0nMEDw5GObNd31AMDgTDK1jym/8V85tRJ64+6Kpu9L+xqdq18eCj+vb8
	xtraOksF7BCqqXJmAZPlKH0nSGJzvOU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NddXXRBo;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-365cae89bf5so2726101a91.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 19:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1778640466; x=1779245266; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=06gGqdUNMKvX/WJ+4BlOMkKZ5L7m8iKcXoUPE36yZHM=;
        b=NddXXRBo8LkEI52Kv5YWv2H9qxbIQaDNRvb2h+hchtRMVGA06GKDJZLLzLXqRIyn8X
         sXq/ZlcwOb9heOVUYDqrm/zGLT8ImfpyXAat5F9vSkDJotypVJk4BQgXNo9Qv4sM7Nzy
         B3FfWe8MXuOGZ5ASISS0g7tpTRg3GNw/sUi4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778640466; x=1779245266;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=06gGqdUNMKvX/WJ+4BlOMkKZ5L7m8iKcXoUPE36yZHM=;
        b=lIQOnIFnr2bpnscTSHGmRNb9AwJGIcbKOabokT1Fu3OLN5umKRIL9gIkZxuJKakDoW
         soYUf6XlfQyxWs73QHjxnUh3iIJsjibg72+G6qvqKg5VUOwMHMl2tgxf/7r/qJmSfAPq
         Dd2AbV+jh3s5KmwdFZlRGhlJVFrZ7s63bJ/sbRqiPX4wWm8yknoRUYzF1ftyrXUAkxsC
         tINX/cTbIu+7w0LVtt91MuwA3P2zKBNwBD2zhinNyJPJF3wtDyQi38TRNJ7nmrn87eEd
         uIwqu4WnE5/MHa/mOmHWHwyiEyruN9XBwl7hEftJotgFQlSUQVuDDkpMXM25ZTaVfwN7
         rQJQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kdKRXRUVaZ2lRi6qPYA2iCE7GXBi+9Xviryt8nyr7kQp86wVpSnbKBGx7nDfa2eFWAFrO4ZUruA==@kvack.org
X-Gm-Message-State: AOJu0YzEbjRgIad62AbAye7plN988mVgOdLKZqd0A1DRqDH3/KK2Gpfi
	g8Ox1yG9SRFk2NBzEi3nHKgZvkEH1pOjR/flwckQiTzxDjSYWQ/ep+pybfY4ikqcog==
X-Gm-Gg: Acq92OHYRM5OWFwt3cudzWVcZAEILkotxHCES/RGQ01eyUI3l9B0MYZ/7ZzsKNoaRBH
	/BMMDUpHCZVCkZn67Ge9Uz5RB0P5uIcvO3rnQl81GLZX3qoTy0YocA7Fm/uK9AiMTMvYg4vJj9i
	2Cya0nMAouyhUw4k856jyer5PI+l3JRg08UA+wl+0Hyw/QXIvNqoaxHPo+tnFg6hxNXMBTnNQ8z
	P8Hh+CwI27MOyeAoJ+XDzzC51OdukkYSyIfs0727OjmMq1V3ZwCAddsWt56TAu5zD7UbmHemWTm
	FV6QK9p+ClWEJnSYEaMMQ3kvklWKCkwVCc5oo8iZpVgVk+FyzZkdnbz9Yk3gItDXTClQFWdJIcF
	EFfO/iNIG3YrQqLqvhALM7Egg1ZkcGrboaBMttEo1vT3ieM6LRgSuV0JbUcJA2Aw9RwQwmR85Vp
	sLvlC2VGuXyPfiOVaWvnRZmO97eUsqF8NmTzO14rTqyjAeuRT8r6dDRp0wwpdkSwpG9dFdH0BPN
	A==
X-Received: by 2002:a17:90b:4f92:b0:368:f179:ba07 with SMTP id 98e67ed59e1d1-368f3aa9f3cmr1629152a91.9.1778640465784;
        Tue, 12 May 2026 19:47:45 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:e541:a7ed:e8ee:843c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-368b06d6b33sm1567998a91.10.2026.05.12.19.47.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 19:47:45 -0700 (PDT)
Date: Wed, 13 May 2026 11:47:41 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kartik Nair <contact.kartikn@gmail.com>, minchan@kernel.org, 
	senozhatsky@chromium.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] zsmalloc: zero-initialize zspage memory to prevent KMSAN
 uninit reads
Message-ID: <agPjfGO6zh9HLPBE@google.com>
References: <20260511213658.25273-1-contact.kartikn@gmail.com>
 <20260512144733.9132c83e392a109743e92f71@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512144733.9132c83e392a109743e92f71@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02A7280008
X-Stat-Signature: dgwb39qmcqfg7ey5ah9in33f7bx196x9
X-Rspam-User: 
X-HE-Tag: 1778640466-662265
X-HE-Meta: U2FsdGVkX1+9fNA/YTPF0n+AZjqxzLg+w+DYFF6FQ4Kr5v7jlhtomWjKACN5UfGDhcEucS5MXU1+ssVzB1wVn32cifwldowsOwzCCwXgonwBwbwHlHfU8L735E8VsBk8wdC94nZ04a8Xk+40l5jQ1fZ9zhE97N/fGx8ducElRiVJGT8dOHZpJxXTfuDVF2/M6E61IKZM7FSikZf6TE9Q7+J9d2Nw0XZg95ooAEAKRnDgvMoU6LZcYzxaD0t4IKnMpO2CkuSuse5vmFHOkpXAc9RCD99j3yvZYIRiYiSYdmT0RAXefPRBv4/e5TipRyG40GXsIdwaq95oERQxBRKLvqXrNOL3PL1zL+z1fYV7ugjGEL/C/Uwn/PCIiJLKrDdM3k8q0Jm09K8Rq7UQ1wiU8fOXZF39O6+bWLPMG1DKJWFIBs2X2KebUyrxsErO6E/jTYLmk1ygD/qAptgDtOe7lz8t8ieV5b7f4mcf7EOnHPRH56vbCTQuK+OC1yKa49GDEP9mAcqjc2DyL76UNrAlTJSq+6IZr85Ooi1QEWctmtr+XsJv7sLYXptJVRXuWCimUb6KyCXZ0wR53BKtyBkuWgmJwqfsyw4vrYcFfoxI86fuTQVYDg2N9Yhoq/gQCpMFd8cwgmnxsTQFNlsCRM94fXSWOkmr83AZMgoppsl/RUkGo39MO6QKjkFmZFJjVnXP7j2/cJWQ56Yd0G+IUwb5Gks+atei3HsSbD4sJbnV6AeKSAVamg84E6mw4Gpf15IrLXdA4HrV1C7NImmzOx70vZAYRXdJMwk4HUVVqevFezA5nTCIWPSNJrdj0lg3T8wL9w0iNaT2OK25riWvWvSC1XCYMp7N92AZG3IzFjOkGKOyzOiClQhxLzzLtu+ieXv9ODbLME1OGIfUL6lFnB5HSIcgWuiInBFaYcZvjL/aKGRwddVPYWwwfrUOpb1JXGw+AJYkScfLQYg1GSsOHGh
 jAo0PpHe
 zp6ogKZE3VovbiG6NJQibx5fVEjfCzL9x01UZVPyM5K7p/PvtL3LpzT6Oi+yAm/iO8mrMENJBFVCxqe5PbpfMfUJAGF4iB9SFikGtIbakzg4rBMNL6yPTqrTCqcw81FV32cyjltFd9oa5/i5rJRFoa3X62tDvqIUBN6IVvQQxx7OSpABb5UvQSRTpOgluVdctR05579tSzFQhGbgIYOeKqrg077gxvTXmMDN9fI/8zDnEUt9Zn2365aBqGWyfXVizbh/Q9RvlTVtMqyoEAEn9mdYKLEh4psg+VshoQ8/zZb7eeB4twA3ThvUyi6rjylGhLZnClfE1LU1UqI+xdL1Vw+gXSJi5wvBA5SWfVsSWHEEsCEEnwKgCF6UB9wnW6f+V/uJeD2yo7SpUQeQVlwTNPIkfHqa5q1b5ScA6MDvD9jHBh8aI48QlB2C65lzcbeTW/1nJNSUiOvYrQU4zLroCXd4a97FCx743sJxxHXrwkqMJFkTg/zhUhBfdYrp4aWq4CeYnP/7pC82dSdSx0DBVJ4RB8WNCdAxZW9rklRTRaNQ+S1rjJ7SHPWfzU1fcQyD2ro5wTZznOGkZG2SGRWKKE4xFaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding Yosry and Herbert,

On (26/05/12 14:47), Andrew Morton wrote:
> > Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> > __GFP_ZERO, leaving physical memory uninitialized. When a compressed
> > object spans two physical pages in a zspage, zs_obj_read_sg_begin()
> > sets up a scatterlist pointing directly at the raw second page. If the
> > second page was freshly allocated and never written beyond the object
> > boundary, KMSAN detects reads of uninitialized memory downstream in
> > the decompressor (e.g. sw842_decompress reading the CRC trailer).

I don't get this.  How can sw842_decompress() read more bytes than
it's told to decompress.  We first compress and store the object,
before we load and decompress, reading past the known compressed
object size (which we pass to decompress function) should not happen.
Yosry, Herbert, any ideas?

> > Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
> > all pages backing a zspage are zero-initialized at allocation time.
> > 
> > Reported-by: syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=8f77ff6144a73f0cf71b
> > Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>
> 
> Thanks.
> 
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -951,7 +951,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
> >  	for (i = 0; i < class->pages_per_zspage; i++) {
> >  		struct zpdesc *zpdesc;
> >  
> > -		zpdesc = alloc_zpdesc(gfp, nid);
> > +		zpdesc = alloc_zpdesc(gfp | __GFP_ZERO, nid);
> >  		if (!zpdesc) {
> >  			while (--i >= 0) {
> >  				zpdesc_dec_zone_page_state(zpdescs[i]);
> 
> Decompressing uninitialized memory sounds rather bad, so I'll add a
> cc:stable to this.
[..]
> I think the Fixes: target is 56e5a103a721 ("zsmalloc: prefer the the
> original page's node for compressed data").  Can people please check
> this when reviewing?

If we need to pick a zsmalloc commit, then this probably can be related
to zs_obj_read_sg_begin() API (which is used only by zswap at the moemnt),
so probably the Fixes: tag be dc2e4982cb018 (zsmalloc: introduce SG-list
based object read API).

